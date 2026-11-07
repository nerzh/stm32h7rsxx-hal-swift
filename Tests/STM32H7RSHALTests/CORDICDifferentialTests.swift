import XCTest
import CCORDICReference
@testable import STM32H7RSHAL

private func cordicWords<T>(_ value: T) -> [UInt32] {
  withUnsafeBytes(of: value) { Array($0.bindMemory(to: UInt32.self)) }
}
private func cordicReferenceCallback(_ pointer: UnsafeMutableRawPointer?, _ id: UInt32, _ implementation: UInt32) {
  let io = Unmanaged<CORDICReferenceIO>.fromOpaque(pointer!).takeUnretainedValue()
  CCORDIC_EmitCallback(io.fixture.state, io.index, id, implementation)
}
private func cordicCallback(_ id: UInt32, _ implementation: UInt32) -> CORDICCallback? {
  if implementation == 0 { return nil }
  switch (id, implementation) {
  case (0, 1): return { cordicReferenceCallback($0, 0, 1) }
  case (0, 2): return { cordicReferenceCallback($0, 0, 2) }
  case (0, 3): return { cordicReferenceCallback($0, 0, 3) }
  case (1, 1): return { cordicReferenceCallback($0, 1, 1) }
  case (1, 2): return { cordicReferenceCallback($0, 1, 2) }
  case (1, 3): return { cordicReferenceCallback($0, 1, 3) }
  case (2, 1): return { cordicReferenceCallback($0, 2, 1) }
  case (2, 2): return { cordicReferenceCallback($0, 2, 2) }
  case (2, 3): return { cordicReferenceCallback($0, 2, 3) }
  case (3, 1): return { cordicReferenceCallback($0, 3, 1) }
  case (3, 2): return { cordicReferenceCallback($0, 3, 2) }
  case (3, 3): return { cordicReferenceCallback($0, 3, 3) }
  default: return { cordicReferenceCallback($0, 0, 2) }
  }
}
private final class CORDICReferenceIO: CORDICRegisterIO, CORDICHandleIO, CORDICCallbackIO, CORDICDMAIO {
  unowned let fixture: CORDICReferenceFixture
  let index: UInt32
  init(_ fixture: CORDICReferenceFixture, _ index: UInt32) { self.fixture = fixture; self.index = index }
  var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
  var driver: CORDIC<CORDICReferenceIO, CORDICReferenceIO, CORDICReferenceIO, CORDICReferenceIO> {
    .init(registers: self, handle: self, callbacks: self, dma: self,
      defaults: .init(error: cordicCallback(0, 1)!, calculateComplete: cordicCallback(1, 1)!,
                      mspInitialize: cordicCallback(2, 1)!, mspDeinitialize: cordicCallback(3, 1)!),
      useRegisteredCallbacks: fixture.registered)
  }
  func map(_ register: CORDICRegister) -> CCORDICRegister {
    switch register { case .csr: return CCORDIC_CSR; case .wdata: return CCORDIC_WDATA; case .rdata: return CCORDIC_RDATA }
  }
  func read(_ register: CORDICRegister) -> UInt32 {
    register == .rdata ? CCORDIC_Read(fixture.state, CCORDIC_RDATA) : CCORDIC_Get(fixture.state, map(register))
  }
  func write(_ register: CORDICRegister, value: UInt32) { CCORDIC_Write(fixture.state, map(register), value) }
  func address(of register: CORDICRegister) -> UInt32 { 0x48004400 + map(register).rawValue * 4 }
  func read(_ word: CORDICHandleWord) -> UInt32 { CCORDIC_GetWord(fixture.state, index, UInt32(word.rawValue)) }
  func write(_ word: CORDICHandleWord, value: UInt32) { CCORDIC_SetWord(fixture.state, index, UInt32(word.rawValue), value) }
  func readPointer(_ pointer: CORDICBufferPointer) -> UnsafeMutableRawPointer? {
    let value = CCORDIC_GetPointer(fixture.state, index, UInt32(pointer.rawValue))
    if value == 0 { return nil }
    let output: UInt32 = value >= 0x11000000 ? 1 : 0
    let relative = value - (output == 1 ? 0x11000000 : 0x10000000)
    let handle = relative / 0x1000, offset = relative % 0x1000
    return UnsafeMutableRawPointer(CCORDIC_Buffer(fixture.state, handle, output)!).advanced(by: Int(offset))
  }
  func writePointer(_ pointer: CORDICBufferPointer, value: UnsafeMutableRawPointer?) {
    guard let value else { CCORDIC_SetPointer(fixture.state, index, UInt32(pointer.rawValue), 0); return }
    let direction = UInt32(pointer.rawValue)
    let base = UInt(bitPattern: CCORDIC_Buffer(fixture.state, index, direction)!)
    let bits = UInt(bitPattern: value)
    // A one-past pointer can equal the next native buffer's base.
    let logical: UInt32
    if bits >= base && bits <= base + 128 {
      logical = 0x10000000 + index * 0x1000 + direction * 0x01000000 + UInt32(bits - base)
    } else { logical = CCORDIC_NormalizeAddress(fixture.state, bits) }
    CCORDIC_SetPointer(fixture.state, index, direction, logical)
  }
  func read(_ id: CORDICCallbackID) -> CORDICCallback? { cordicCallback(id.rawValue, CCORDIC_GetCallback(fixture.state, index, id.rawValue)) }
  func write(_ id: CORDICCallbackID, value: CORDICCallback?) {
    var implementation: UInt32 = 0
    if let value {
      for candidate in UInt32(1)...3 {
        if unsafeBitCast(value, to: UInt.self) == unsafeBitCast(cordicCallback(id.rawValue, candidate)!, to: UInt.self) {
          implementation = candidate; break
        }
      }
      precondition(implementation != 0)
    }
    CCORDIC_SetCallback(fixture.state, index, id.rawValue, implementation)
  }
  func writeCallback(_ direction: CORDICDMADirection, id: DMACallbackID, value: DMACallback?) {
    let channel = CCORDIC_GetLink(fixture.state, index, direction.rawValue)
    precondition(channel >= 0)
    let slot: UInt32
    switch id { case .transferComplete: slot = 0; case .error: slot = 1; default: preconditionFailure("Unused DMA callback") }
    var selector: UInt32 = 0
    if let value {
      for kind in CORDICDMACallbackKind.allCases {
        if unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) { selector = kind.rawValue + 1 }
      }
      precondition(selector != 0)
    }
    CCORDIC_SetDMACallback(fixture.state, UInt32(channel), slot, selector)
  }
  func callback(_ kind: CORDICDMACallbackKind) -> DMACallback { CORDICNoDMA().callback(kind) }
  func startInterrupt(_ direction: CORDICDMADirection, sourceAddress: UInt32,
                      destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    let channel = CCORDIC_GetLink(fixture.state, index, direction.rawValue)
    precondition(channel >= 0)
    return HALStatus(rawValue: CCORDIC_DMAStartModel(fixture.state, UInt32(channel),
      CCORDIC_NormalizeAddress(fixture.state, UInt(sourceAddress)),
      CCORDIC_NormalizeAddress(fixture.state, UInt(destinationAddress)), sourceDataSize))!
  }
  @discardableResult func run(_ operation: CCORDICOperation, a: UInt32, b: UInt32, c: UInt32, d: UInt32) -> UInt32 {
    let input: UnsafePointer<Int32>? = c == 0 ? UnsafePointer(CCORDIC_Buffer(fixture.state, index, 0)!) : nil
    let output = d == 0 ? CCORDIC_Buffer(fixture.state, index, 1) : nil
    let tick = { CCORDIC_Tick(self.fixture.state) }
    switch operation {
    case CCORDIC_Initialize: return driver.initialize().rawValue
    case CCORDIC_Deinitialize: return driver.deinitialize().rawValue
    case CCORDIC_Configure:
      let v = fixture.state.pointee.configuration
      return driver.configure(.init(function: v.Function, scale: v.Scale, inputSize: v.InSize, outputSize: v.OutSize,
        writeCount: v.NbWrite, readCount: v.NbRead, precision: v.Precision)).rawValue
    case CCORDIC_Calculate: return driver.calculate(input, output: output, count: a, timeout: b, getTick: tick).rawValue
    case CCORDIC_CalculateZeroOverhead: return driver.calculateZeroOverhead(input, output: output, count: a, timeout: b, getTick: tick).rawValue
    case CCORDIC_CalculateInterrupt: return driver.calculateInterrupt(input, output: output, count: a).rawValue
    case CCORDIC_CalculateDMA: return driver.calculateDMA(input, output: output, count: a, direction: b).rawValue
    case CCORDIC_HandleInterrupt: driver.handleInterrupt()
    case CCORDIC_GetState: return driver.getState()
    case CCORDIC_GetError: return driver.getError()
    case CCORDIC_RegisterCallback: return driver.registerCallback(id: a, callback: cordicCallback(a, b)).rawValue
    case CCORDIC_UnregisterCallback: return driver.unregisterCallback(id: a).rawValue
    case CCORDIC_ResetHandleState: driver.resetHandleState()
    case CCORDIC_EnableInterrupts: driver.enableInterrupts(a)
    case CCORDIC_DisableInterrupts: driver.disableInterrupts(a)
    case CCORDIC_GetFlag: return driver.getFlag(a)
    case CCORDIC_GetInterruptSource: return driver.getInterruptSource(a)
    default: preconditionFailure("Unknown CORDIC operation")
    }
    return 0
  }
}
private final class CORDICReferenceFixture {
  let state = UnsafeMutablePointer<CCORDICState>.allocate(capacity: 1)
  let registered: Bool
  var handles: [CORDICReferenceIO] = []
  init(registered: Bool, swift: Bool) {
    self.registered = registered; CCORDIC_Reset(state, registered ? 1 : 0)
    handles = [CORDICReferenceIO(self, 0), CORDICReferenceIO(self, 1)]
    if swift {
      CCORDIC_SetExecutionHook(state, Unmanaged.passUnretained(self).toOpaque(), { pointer, action in
        Unmanaged<CORDICReferenceFixture>.fromOpaque(pointer!).takeUnretainedValue().apply(action)
      })
    }
  }
  deinit { state.deallocate() }
  func dma(_ channel: UInt32, _ kind: UInt32) {
    let parent = CCORDIC_GetDMAParent(state, channel)
    precondition(parent >= 0)
    handles[Int(parent)].driver.handleDMAEvent(CORDICDMACallbackKind(rawValue: kind)!)
  }
  func apply(_ action: CCORDICAction) {
    switch action.kind {
    case CCORDIC_ActionNone: break
    case CCORDIC_ActionRegister: CCORDIC_Set(state, CCORDICRegister(rawValue: action.index), action.value)
    case CCORDIC_ActionWord: CCORDIC_SetWord(state, action.target, action.index, action.value)
    case CCORDIC_ActionPointer: CCORDIC_SetPointer(state, action.target, action.index, action.value)
    case CCORDIC_ActionCall: handles[Int(action.target)].run(CCORDICOperation(rawValue: action.index), a: action.a, b: action.b, c: action.c, d: action.d)
    case CCORDIC_ActionDMAParent: CCORDIC_SetDMAParent(state, action.target, Int32(bitPattern: action.value))
    case CCORDIC_ActionDMAEvent: dma(action.target, action.index)
    default: preconditionFailure("Unknown CORDIC action")
    }
  }
}
private final class CORDICReferencePair {
  let actual: CORDICReferenceFixture, reference: CORDICReferenceFixture
  init(registered: Bool, setup: (UnsafeMutablePointer<CCORDICState>) -> Void = { _ in }) {
    actual = .init(registered: registered, swift: true); reference = .init(registered: registered, swift: false)
    configure(setup)
  }
  func configure(_ setup: (UnsafeMutablePointer<CCORDICState>) -> Void) { setup(actual.state); setup(reference.state) }
  @discardableResult func run(_ operation: CCORDICOperation, handle: UInt32 = 0,
    a: UInt32 = 0, b: UInt32 = 0, c: UInt32 = 0, d: UInt32 = 0,
    file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
    let expected = CCORDIC_Run(reference.state, handle, operation, a, b, c, d)
    let result = actual.handles[Int(handle)].run(operation, a: a, b: b, c: c, d: d)
    XCTAssertEqual(result, expected, "operation \(operation.rawValue)", file: file, line: line)
    compare(file: file, line: line); return result
  }
  func dma(_ channel: UInt32, _ kind: UInt32, file: StaticString = #filePath, line: UInt = #line) {
    CCORDIC_InvokeDMA(reference.state, channel, kind); actual.dma(channel, kind); compare(file: file, line: line)
  }
  func compare(file: StaticString, line: UInt) {
    let a = actual.state, r = reference.state
    XCTAssertEqual(cordicWords(CCORDIC_GetSnapshot(a)), cordicWords(CCORDIC_GetSnapshot(r)), file: file, line: line)
    XCTAssertEqual(a.pointee.tick, r.pointee.tick, file: file, line: line)
    XCTAssertEqual(a.pointee.tickCalls, r.pointee.tickCalls, file: file, line: line)
    XCTAssertEqual(a.pointee.resultIndex, r.pointee.resultIndex, file: file, line: line)
    XCTAssertEqual(a.pointee.callbackCount, r.pointee.callbackCount, file: file, line: line)
    XCTAssertEqual(a.pointee.dmaCount, r.pointee.dmaCount, file: file, line: line)
    for i in 0..<min(a.pointee.callbackCount, r.pointee.callbackCount) {
      XCTAssertEqual(cordicWords(CCORDIC_GetCallbackEvent(a, i)), cordicWords(CCORDIC_GetCallbackEvent(r, i)), "callback \(i)", file: file, line: line)
    }
    for i in 0..<min(a.pointee.dmaCount, r.pointee.dmaCount) {
      XCTAssertEqual(cordicWords(CCORDIC_GetDMAEvent(a, i)), cordicWords(CCORDIC_GetDMAEvent(r, i)), "DMA start \(i)", file: file, line: line)
    }
    func data(_ s: UnsafeMutablePointer<CCORDICState>) -> [[UInt32]] {
      (0..<s.pointee.accessCount).compactMap {
        let value = CCORDIC_GetAccess(s, $0)
        guard value.reg == CCORDIC_WDATA || value.reg == CCORDIC_RDATA else { return nil }
        return [value.reg.rawValue, value.value, value.kind, value.tickCalls]
      }
    }
    XCTAssertEqual(data(a), data(r), "WDATA/RDATA access order", file: file, line: line)
  }
}
private func cordicReady(_ s: UnsafeMutablePointer<CCORDICState>, _ h: UInt32 = 0) {
  CCORDIC_SetWord(s, h, 4, 1)
  for id in UInt32(0)..<4 { CCORDIC_SetCallback(s, h, id, 1) }
}
private func cordicAction(_ kind: CCORDICActionKind, target: UInt32 = 0, index: UInt32 = 0, value: UInt32 = 0,
                          a: UInt32 = 0, b: UInt32 = 0, c: UInt32 = 0, d: UInt32 = 0) -> CCORDICAction {
  CCORDICAction(kind: kind, target: target, index: index, value: value, a: a, b: b, c: c, d: d)
}

final class CORDICDifferentialTests: XCTestCase {
  func testInitializationAndDeinitializationEveryStateAndCallbackPreset() {
    for registered in [false, true] {
      for state: UInt32 in [0, 1, 2, 3, .max] {
        for preset: UInt32 in 0..<4 {
          let pair = CORDICReferencePair(registered: registered) { s in
            for word in UInt32(0)..<6 { CCORDIC_SetWord(s, 0, word, 0xA5000000 + word) }
            CCORDIC_SetWord(s, 0, 4, state)
            CCORDIC_SetPointer(s, 0, 0, 0x10000004); CCORDIC_SetPointer(s, 0, 1, 0x11000008)
            for id in UInt32(0)..<4 { CCORDIC_SetCallback(s, 0, id, preset) }
            CCORDIC_SetCallbackAction(s, 0, 2, 0, cordicAction(CCORDIC_ActionWord, index: 5, value: .max))
            CCORDIC_SetCallbackAction(s, 0, 3, 0, cordicAction(CCORDIC_ActionWord, index: 3, value: 1))
          }
          pair.run(CCORDIC_Initialize); pair.run(CCORDIC_Initialize)
          pair.run(CCORDIC_Deinitialize); pair.run(CCORDIC_GetState); pair.run(CCORDIC_GetError)
          pair.run(CCORDIC_ResetHandleState)
        }
      }
      let s = CORDICReferenceFixture(registered: registered, swift: false)
      XCTAssertEqual(CCORDIC_RunNull(s.state, CCORDIC_Initialize), 1)
      XCTAssertEqual(CCORDIC_RunNull(s.state, CCORDIC_Deinitialize), 1)
    }
  }

  func testCallbackRegistrationStatesIDsNullAndRestoration() {
    for state: UInt32 in [0, 1, 2, 3, .max] {
      for id: UInt32 in [0, 1, 2, 3, 4, .max] {
        for implementation: UInt32 in 0..<4 {
          let pair = CORDICReferencePair(registered: true) { s in
            CCORDIC_SetWord(s, 0, 4, state); CCORDIC_SetWord(s, 0, 5, 0x80)
          }
          pair.run(CCORDIC_RegisterCallback, a: id, b: implementation)
          pair.run(CCORDIC_UnregisterCallback, a: id)
        }
      }
    }
  }

  func testConfigurationAllFunctionsPrecisionsAndPackedWidths() {
    for registered in [false, true] {
      for function in UInt32(0)..<10 {
        for precision in UInt32(1)...15 {
          let pair = CORDICReferencePair(registered: registered) { s in
            cordicReady(s); CCORDIC_Set(s, CCORDIC_CSR, .max)
            s.pointee.configuration = CORDIC_ConfigTypeDef(Function: function, Scale: ((function + precision) & 7) << 8,
              InSize: precision & 1 == 0 ? 0 : 0x400000, OutSize: precision & 2 == 0 ? 0 : 0x200000,
              NbWrite: precision & 4 == 0 ? 0 : 0x100000, NbRead: precision & 8 == 0 ? 0 : 0x80000,
              Precision: precision << 4)
          }
          pair.run(CCORDIC_Configure)
        }
      }
      for state: UInt32 in [0, 2, 3, .max] {
        let pair = CORDICReferencePair(registered: registered) { CCORDIC_SetWord($0, 0, 4, state) }
        pair.run(CCORDIC_Configure)
      }
    }
  }

  func testCalculationArgumentValidationAndNotReadyPrecedence() {
    for registered in [false, true] {
      for operation in [CCORDIC_Calculate, CCORDIC_CalculateZeroOverhead, CCORDIC_CalculateInterrupt] {
        for state: UInt32 in [0, 1, 2, 3, .max] {
          for invalid: UInt32 in 0..<4 {
            let pair = CORDICReferencePair(registered: registered) { s in
              cordicReady(s); CCORDIC_SetWord(s, 0, 4, state); CCORDIC_SetWord(s, 0, 5, 0x80)
            }
            pair.run(operation, a: invalid == 0 ? 0 : 1, b: 0,
              c: invalid == 1 ? 1 : 0, d: invalid == 2 ? 1 : 0)
          }
        }
      }
    }
  }

  func testPollingAndZeroOverheadAllWordCountsAndReadiness() {
    for registered in [false, true] {
      for operation in [CCORDIC_Calculate, CCORDIC_CalculateZeroOverhead] {
        for bits: UInt32 in 0..<4 {
          for count: UInt32 in [1, 2, 3, 16] {
            let pair = CORDICReferencePair(registered: registered) { s in
              cordicReady(s); CCORDIC_SetWord(s, 0, 3, 1)
              CCORDIC_Set(s, CCORDIC_CSR, 0x80600000 | (bits & 1 == 0 ? 0 : 0x100000) | (bits & 2 == 0 ? 0 : 0x80000))
            }
            pair.run(operation, a: count, b: .max)
            XCTAssertEqual(CCORDIC_GetWord(pair.actual.state, 0, 3), 1)
          }
        }
        let lastUnready = CORDICReferencePair(registered: registered) { s in cordicReady(s); CCORDIC_Set(s, CCORDIC_CSR, 0) }
        lastUnready.run(operation, a: 1, b: 0)
        XCTAssertEqual(lastUnready.actual.state.pointee.tickCalls, 1)
        XCTAssertEqual(lastUnready.actual.state.pointee.resultIndex, 1)
      }
    }
  }

  func testPollingTimeoutStrictBoundaryRolloverAndReadBeforeZeroOverheadTimeout() {
    for registered in [false, true] {
      for operation in [CCORDIC_Calculate, CCORDIC_CalculateZeroOverhead] {
        for start: UInt32 in [0, .max - 1] {
          for timeout: UInt32 in [0, 1, 2, 4] {
            for readyCall in UInt32(1)...(timeout + 3) {
              let pair = CORDICReferencePair(registered: registered) { s in
                cordicReady(s); CCORDIC_Set(s, CCORDIC_CSR, 0); s.pointee.tick = start
                CCORDIC_ScheduleTick(s, readyCall, cordicAction(CCORDIC_ActionRegister, index: 0, value: 0x80000000))
              }
              pair.run(operation, a: 2, b: timeout)
            }
          }
        }
      }
    }
  }

  func testHelpersReadFreshNARGSAndNRESAfterFirstTransfer() {
    for registered in [false, true] {
      for initial: UInt32 in [0, 0x180000] {
        let pair = CORDICReferencePair(registered: registered) { s in
          cordicReady(s); CCORDIC_Set(s, CCORDIC_CSR, 0x80000000 | initial)
          CCORDIC_ScheduleWrite(s, CCORDIC_WDATA, 1, cordicAction(CCORDIC_ActionRegister, index: 0, value: 0x80180000 ^ initial))
          CCORDIC_ScheduleRead(s, CCORDIC_RDATA, 1, cordicAction(CCORDIC_ActionRegister, index: 0, value: 0x80000000 | initial))
        }
        pair.run(CCORDIC_CalculateZeroOverhead, a: 3, b: .max)
      }
    }
  }

  func testInterruptAllWordWidthsAndFullBufferOnePastPointers() {
    for registered in [false, true] {
      for bits: UInt32 in 0..<4 {
        for count: UInt32 in [1, 3, 16] {
          let pair = CORDICReferencePair(registered: registered) { s in
            cordicReady(s); CCORDIC_Set(s, CCORDIC_CSR, 0x80000000 | (bits & 1 == 0 ? 0 : 0x100000) | (bits & 2 == 0 ? 0 : 0x80000))
          }
          pair.run(CCORDIC_CalculateInterrupt, a: count)
          for _ in UInt32(0)..<count { pair.run(CCORDIC_HandleInterrupt) }
          XCTAssertEqual(pair.actual.state.pointee.callbackCount, 1)
          XCTAssertEqual(CCORDIC_GetPointer(pair.actual.state, 0, 1), 0x11000000 + count * (bits & 2 == 0 ? 4 : 8))
        }
      }
    }
  }

  func testInterruptGateCounterUnderflowAndCallbackRearm() {
    for registered in [false, true] {
      for flags: UInt32 in [0, 0x10000, 0x80000000, 0x80010000] {
        let pair = CORDICReferencePair(registered: registered) { s in
          cordicReady(s); CCORDIC_SetWord(s, 0, 4, 3)
          CCORDIC_Set(s, CCORDIC_CSR, flags); CCORDIC_SetPointer(s, 0, 1, 0x11000000)
        }
        pair.run(CCORDIC_HandleInterrupt)
        if flags == 0x80010000 { XCTAssertEqual(CCORDIC_GetWord(pair.actual.state, 0, 1), .max) }
      }
      let pair = CORDICReferencePair(registered: registered) { s in
        cordicReady(s)
        CCORDIC_SetCallbackAction(s, 0, 1, 0, cordicAction(CCORDIC_ActionCall, index: CCORDIC_CalculateInterrupt.rawValue, a: 1))
      }
      pair.run(CCORDIC_CalculateInterrupt, a: 1)
      pair.run(CCORDIC_HandleInterrupt); pair.run(CCORDIC_HandleInterrupt)
      XCTAssertEqual(pair.actual.state.pointee.callbackCount, 2)
    }
  }

  func testDMAParametersStatusesCountsWrappingAndOutputBeforeInput() {
    for registered in [false, true] {
      for direction: UInt32 in 1...3 {
        for bits: UInt32 in 0..<4 {
          for count: UInt32 in [0, 1, 7, 0x20000000, 0x40000000, 0x80000000, .max] {
            for failure: UInt32 in 0..<3 {
              let pair = CORDICReferencePair(registered: registered) { s in
                cordicReady(s); CCORDIC_Set(s, CCORDIC_CSR, (bits & 1 == 0 ? 0 : 0x100000) | (bits & 2 == 0 ? 0 : 0x80000))
                if failure == 1 { s.pointee.dmaStatus.0 = 1 }
                if failure == 2 { s.pointee.dmaStatus.1 = 3 }
              }
              pair.run(CCORDIC_CalculateDMA, a: count, b: direction)
            }
          }
        }
        for state: UInt32 in [0, 1, 2, 3] {
          for nulls: UInt32 in 0..<4 {
            let pair = CORDICReferencePair(registered: registered) { s in cordicReady(s); CCORDIC_SetWord(s, 0, 4, state) }
            pair.run(CCORDIC_CalculateDMA, a: 1, b: direction, c: nulls & 1, d: (nulls >> 1) & 1)
          }
        }
      }
    }
  }

  func testDMACompletionOrderingErrorsAndLiveParent() {
    for registered in [false, true] {
      for direction: UInt32 in 1...3 {
        for outputFirst in [false, true] {
          let pair = CORDICReferencePair(registered: registered) { cordicReady($0) }
          pair.run(CCORDIC_CalculateDMA, a: 3, b: direction)
          if direction == 3 {
            pair.dma(outputFirst ? 1 : 0, outputFirst ? 1 : 0)
            pair.dma(outputFirst ? 0 : 1, outputFirst ? 0 : 1)
          } else { pair.dma(direction == 1 ? 0 : 1, direction == 1 ? 0 : 1) }
        }
      }
      for kind: UInt32 in 0..<3 {
        let pair = CORDICReferencePair(registered: registered) { s in
          cordicReady(s, 0); cordicReady(s, 1)
          CCORDIC_SetWord(s, 1, 2, 1); CCORDIC_SetWord(s, 1, 4, 2); CCORDIC_SetWord(s, 1, 5, 0x80)
        }
        pair.run(CCORDIC_CalculateDMA, a: 2, b: 3)
        pair.configure { CCORDIC_SetDMAParent($0, 0, 1) }
        pair.dma(0, kind)
        XCTAssertEqual(CCORDIC_GetWord(pair.actual.state, 0, 4), 2)
        XCTAssertEqual(CCORDIC_GetWord(pair.actual.state, 1, 4), 1)
      }
    }
  }

  func testDMAImmediateCompletionAndCallbackReentryDuringStart() {
    for registered in [false, true] {
      for kind: UInt32 in 0..<3 {
        let pair = CORDICReferencePair(registered: registered) { s in
          cordicReady(s)
          CCORDIC_SetDMAAction(s, 1, 0, cordicAction(CCORDIC_ActionDMAEvent, target: 1, index: kind))
          CCORDIC_SetCallbackAction(s, 0, kind == 2 ? 0 : 1, 0,
            cordicAction(CCORDIC_ActionRegister, index: 0, value: 0x180000))
        }
        pair.run(CCORDIC_CalculateDMA, a: 2, b: 3)
      }
    }
  }

  func testExportedInterruptAndFlagMacrosIncludingZeroMask() {
    for registered in [false, true] {
      for bits: UInt32 in [0, 0x10000, 0x80000000, 0xFFFFFFFF] {
        let pair = CORDICReferencePair(registered: registered) { CCORDIC_Set($0, CCORDIC_CSR, 0xA5A5A5A5) }
        pair.run(CCORDIC_GetFlag, a: bits); pair.run(CCORDIC_GetInterruptSource, a: bits)
        pair.run(CCORDIC_EnableInterrupts, a: bits); pair.run(CCORDIC_DisableInterrupts, a: bits)
      }
    }
  }
}
