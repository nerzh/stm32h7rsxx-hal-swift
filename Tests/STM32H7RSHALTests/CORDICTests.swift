import XCTest
@testable import STM32H7RSHAL

private enum CORDICAccess: Equatable {
  case read(CORDICRegister), write(CORDICRegister, UInt32)
  case word(CORDICHandleWord, UInt32), pointer(CORDICBufferPointer, Int?)
  case callbackRead(CORDICCallbackID), callbackWrite(CORDICCallbackID, Bool), callback(CORDICCallbackID)
  case tick(UInt32), dmaCallback(CORDICDMADirection, DMACallbackID)
  case dmaStart(CORDICDMADirection, UInt32, UInt32, UInt32)
}
private struct CORDICSnapshot {
  let id: CORDICCallbackID
  let state, error, lock, direction, csr, order, get: UInt32
}
private func cordicTestObject(_ context: UnsafeMutableRawPointer?) -> CORDICTestIO {
  Unmanaged<CORDICTestIO>.fromOpaque(context!).takeUnretainedValue()
}
private func cordicTestError(_ context: UnsafeMutableRawPointer?) { cordicTestObject(context).record(.error) }
private func cordicTestComplete(_ context: UnsafeMutableRawPointer?) { cordicTestObject(context).record(.calculateComplete) }
private func cordicTestInit(_ context: UnsafeMutableRawPointer?) { cordicTestObject(context).record(.mspInitialize) }
private func cordicTestDeinit(_ context: UnsafeMutableRawPointer?) { cordicTestObject(context).record(.mspDeinitialize) }
private func cordicTestCustom(_ context: UnsafeMutableRawPointer?) { cordicTestObject(context).customCalls += 1 }

private final class CORDICTestIO: CORDICRegisterIO, CORDICHandleIO, CORDICCallbackIO, CORDICDMAIO {
  var registers: [CORDICRegister: UInt32] = [.csr: 0x8000_0000]
  var words: [CORDICHandleWord: UInt32] = [.state: 1, .lock: 0xA5]
  var pointers: [CORDICBufferPointer: UnsafeMutableRawPointer] = [:]
  var slots: [CORDICCallbackID: CORDICCallback] = [:]
  var dmaSlots: [CORDICDMADirection: [DMACallbackID: DMACallback]] = [:]
  var dmaStatuses: [CORDICDMADirection: HALStatus] = [:]
  var trace: [CORDICAccess] = []
  var snapshots: [CORDICSnapshot] = []
  var readValues: [CORDICRegister: [UInt32]] = [:]
  var onRead: ((CORDICRegister) -> Void)?
  var onWrite: ((CORDICRegister, UInt32) -> Void)?
  var onCallback: ((CORDICCallbackID) -> Void)?
  var tickValues: [UInt32] = []
  var tick: UInt32 = 0
  var tickStep: UInt32 = 1
  var customCalls = 0
  let registered: Bool
  let input = UnsafeMutablePointer<Int32>.allocate(capacity: 64)
  let output = UnsafeMutablePointer<Int32>.allocate(capacity: 64)

  init(registered: Bool = false) {
    self.registered = registered
    input.initialize(repeating: 0, count: 64)
    output.initialize(repeating: 0x1234_5678, count: 64)
    for index in 0..<64 { input[index] = Int32(bitPattern: 0x8000_0100 + UInt32(index)) }
    slots = [.error: cordicTestError, .calculateComplete: cordicTestComplete,
      .mspInitialize: cordicTestInit, .mspDeinitialize: cordicTestDeinit]
  }
  deinit {
    input.deinitialize(count: 64); input.deallocate()
    output.deinitialize(count: 64); output.deallocate()
  }
  var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
  var defaults: CORDICCallbackDefaults {
    .init(error: cordicTestError, calculateComplete: cordicTestComplete,
      mspInitialize: cordicTestInit, mspDeinitialize: cordicTestDeinit)
  }
  var driver: CORDIC<CORDICTestIO, CORDICTestIO, CORDICTestIO, CORDICTestIO> {
    .init(registers: self, handle: self, callbacks: self, dma: self,
      defaults: defaults, useRegisteredCallbacks: registered)
  }
  var mmio: [CORDICAccess] {
    trace.filter { switch $0 { case .read, .write: return true; default: return false } }
  }
  var ticks: [UInt32] { trace.compactMap { if case let .tick(value) = $0 { return value }; return nil } }
  var events: [CORDICCallbackID] { snapshots.map(\.id) }
  var writes: [UInt32] {
    trace.compactMap { if case let .write(.wdata, value) = $0 { return value }; return nil }
  }
  func pointerOffset(_ id: CORDICBufferPointer) -> Int? {
    guard let pointer = pointers[id] else { return nil }
    let base = id == .input ? input : output
    return (Int(bitPattern: pointer) - Int(bitPattern: base)) / 4
  }
  func read(_ register: CORDICRegister) -> UInt32 {
    trace.append(.read(register)); onRead?(register)
    if readValues[register]?.isEmpty == false { return readValues[register]!.removeFirst() }
    return registers[register, default: 0]
  }
  func write(_ register: CORDICRegister, value: UInt32) {
    trace.append(.write(register, value)); registers[register] = value; onWrite?(register, value)
  }
  func address(of register: CORDICRegister) -> UInt32 {
    switch register { case .csr: return 0x4800_4400; case .wdata: return 0x4800_4404; case .rdata: return 0x4800_4408 }
  }
  func read(_ word: CORDICHandleWord) -> UInt32 { words[word, default: 0] }
  func write(_ word: CORDICHandleWord, value: UInt32) { trace.append(.word(word, value)); words[word] = value }
  func readPointer(_ pointer: CORDICBufferPointer) -> UnsafeMutableRawPointer? { pointers[pointer] }
  func writePointer(_ pointer: CORDICBufferPointer, value: UnsafeMutableRawPointer?) {
    pointers[pointer] = value; trace.append(.pointer(pointer, pointerOffset(pointer)))
  }
  func read(_ id: CORDICCallbackID) -> CORDICCallback? { trace.append(.callbackRead(id)); return slots[id] }
  func write(_ id: CORDICCallbackID, value: CORDICCallback?) {
    trace.append(.callbackWrite(id, value != nil)); slots[id] = value
  }
  func record(_ id: CORDICCallbackID) {
    trace.append(.callback(id))
    snapshots.append(.init(id: id, state: read(.state), error: read(.errorCode), lock: read(.lock),
      direction: read(.dmaDirection), csr: registers[.csr, default: 0],
      order: read(.calculationsToOrder), get: read(.calculationsToGet)))
    onCallback?(id)
  }
  func getTick() -> UInt32 {
    let value: UInt32
    if tickValues.isEmpty { value = tick; tick &+= tickStep } else { value = tickValues.removeFirst() }
    trace.append(.tick(value)); return value
  }
  func callback(_ kind: CORDICDMACallbackKind) -> DMACallback { cordicDMAThunk(kind) }
  func writeCallback(_ direction: CORDICDMADirection, id: DMACallbackID, value: DMACallback?) {
    trace.append(.dmaCallback(direction, id)); dmaSlots[direction, default: [:]][id] = value
  }
  func startInterrupt(_ direction: CORDICDMADirection, sourceAddress: UInt32,
    destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    trace.append(.dmaStart(direction, sourceAddress, destinationAddress, sourceDataSize))
    return dmaStatuses[direction, default: .ok]
  }
}

private func cordicBridgeParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  let channel = Unmanaged<CORDICBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
  channel.parentReads += 1
  return channel.parent
}
private func cordicBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ event: UInt32) {
  let owner = Unmanaged<CORDICBridgeOwner>.fromOpaque(parent!).takeUnretainedValue()
  owner.driver.handleDMAEvent(CORDICDMACallbackKind(rawValue: event)!)
}
private final class CORDICBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel: DMAChannel
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var slots: [DMACallbackID: DMACallback] = [:]
  var parent: UnsafeMutableRawPointer?
  var parentReads = 0
  let descriptor = UnsafeMutablePointer<CORDICDMACallbackContext>.allocate(capacity: 1)
  init(index: Int) {
    channel = DMAChannel(controller: .gpdma1, index: index)
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: cordicBridgeParent, dispatch: cordicBridgeDispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  var driver: DMA<CORDICBridgeChannel, CORDICBridgeChannel, CORDICBridgeChannel, CORDICBridgeChannel> {
    .init(registers: self, handle: self, callbacks: self, memory: self)
  }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  func read(_ register: DMARegister) -> UInt32 { registers[register, default: 0] }
  func write(_ register: DMARegister, value: UInt32) {
    registers[register] = value
    if register == .cfcr { registers[.csr, default: 0] &= ~value }
  }
  func read(_ word: DMAHandleWord) -> UInt32 { words[word, default: 0] }
  func write(_ word: DMAHandleWord, value: UInt32) { words[word] = value }
  func read(_ id: DMACallbackID) -> DMACallback? { slots[id] }
  func write(_ id: DMACallbackID, value: DMACallback?) { slots[id] = value }
  func readParent() -> UnsafeMutableRawPointer? { parent }
  func writeParent(_ value: UnsafeMutableRawPointer?) { parent = value }
  func read32(at address: UInt32) -> UInt32 { XCTFail("Linear DMA must not read queue memory"); return 0 }
  func write32(at address: UInt32, value: UInt32) { XCTFail("Linear DMA must not write queue memory") }
  func complete() {
    registers[.cbr1] = 0; registers[.csr] = 0x100; registers[.misr] = 1 << channel.index
    driver.handleInterrupt()
  }
}
private final class CORDICBridgeOwner {
  let io = CORDICTestIO()
  let input = CORDICBridgeChannel(index: 0)
  let output = CORDICBridgeChannel(index: 1)
  init() {
    input.parent = Unmanaged.passUnretained(self).toOpaque()
    output.parent = Unmanaged.passUnretained(self).toOpaque()
  }
  var links: CORDICDMALinks<CORDICBridgeChannel, CORDICBridgeChannel, CORDICBridgeChannel, CORDICBridgeChannel> {
    .init(input: input.driver, output: output.driver)
  }
  var driver: CORDIC<CORDICTestIO, CORDICTestIO, CORDICTestIO,
    CORDICDMALinks<CORDICBridgeChannel, CORDICBridgeChannel, CORDICBridgeChannel, CORDICBridgeChannel>> {
    .init(registers: io, handle: io, callbacks: io, dma: links, defaults: io.defaults)
  }
}

final class CORDICTests: XCTestCase {
  func testInitializationCallbackOrderAndExternalStorageReset() {
    for registered in [false, true] {
      let io = CORDICTestIO(registered: registered)
      io.words[.state] = 0; io.words[.errorCode] = 31
      io.words[.calculationsToOrder] = 9; io.words[.calculationsToGet] = 10; io.words[.dmaDirection] = 3
      io.pointers[.input] = UnsafeMutableRawPointer(io.input); io.pointers[.output] = UnsafeMutableRawPointer(io.output)
      io.slots[.mspInitialize] = nil; io.slots[.error] = cordicTestCustom
      io.onCallback = { id in
        if id == .mspInitialize {
          XCTAssertEqual(io.words[.state], 0); XCTAssertEqual(io.words[.lock], 0)
          XCTAssertEqual(io.words[.errorCode], 31); XCTAssertEqual(io.pointerOffset(.input), 0)
          io.words[.lock] = 7
        }
      }
      XCTAssertEqual(io.driver.initialize(), .ok)
      XCTAssertEqual(io.events, [.mspInitialize]); XCTAssertEqual(io.words[.lock], 7)
      XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.errorCode], 0)
      XCTAssertEqual(io.words[.calculationsToOrder], 0); XCTAssertEqual(io.words[.calculationsToGet], 0)
      XCTAssertEqual(io.words[.dmaDirection], 0); XCTAssertTrue(io.pointers.isEmpty); XCTAssertTrue(io.mmio.isEmpty)
      if registered {
        XCTAssertEqual(Array(io.trace.prefix(6)), [.word(.lock, 0), .callbackWrite(.error, true),
          .callbackWrite(.calculateComplete, true), .callbackRead(.mspInitialize),
          .callbackWrite(.mspInitialize, true), .callbackRead(.mspInitialize)])
      }
      XCTAssertEqual(Array(io.trace.suffix(7)), [.word(.errorCode, 0), .pointer(.input, nil),
        .pointer(.output, nil), .word(.calculationsToOrder, 0), .word(.calculationsToGet, 0),
        .word(.dmaDirection, 0), .word(.state, 1)])
    }
  }

  func testInitializationNonResetStatesSkipsMSPAndPreservesLockAndSlots() {
    for state: UInt32 in [1, 2, 3, .max] {
      let io = CORDICTestIO(registered: true); io.words[.state] = state; io.slots[.error] = cordicTestCustom
      XCTAssertEqual(io.driver.initialize(), .ok)
      XCTAssertTrue(io.events.isEmpty); XCTAssertEqual(io.words[.lock], 0xA5)
      io.slots[.error]?(io.context); XCTAssertEqual(io.customCalls, 1)
      XCTAssertEqual(io.words[.state], 1); XCTAssertTrue(io.mmio.isEmpty)
    }
  }

  func testDeinitializationCallsMSPWhileBusyThenResetsLockLast() {
    for registered in [false, true] {
      let io = CORDICTestIO(registered: registered); io.words[.errorCode] = 8
      io.slots[.mspDeinitialize] = nil
      XCTAssertEqual(io.driver.deinitialize(), .ok)
      XCTAssertEqual(io.events, [.mspDeinitialize]); XCTAssertEqual(io.snapshots[0].state, 2)
      XCTAssertEqual(io.snapshots[0].error, 8); XCTAssertEqual(io.snapshots[0].lock, 0xA5)
      XCTAssertEqual(Array(io.trace.suffix(8)), [.word(.errorCode, 0), .pointer(.input, nil),
        .pointer(.output, nil), .word(.calculationsToOrder, 0), .word(.calculationsToGet, 0),
        .word(.dmaDirection, 0), .word(.state, 0), .word(.lock, 0)])
      XCTAssertTrue(io.mmio.isEmpty)
    }
  }

  func testRegistrationMatrixPreservesExistingErrorsAndLock() {
    for state: UInt32 in [0, 1, 2, 3, .max] {
      for id: UInt32 in 0...4 {
        let valid = (state == 1 && id < 4) || (state == 0 && (id == 2 || id == 3))
        for unregister in [false, true] {
          let io = CORDICTestIO(registered: true); io.words[.state] = state; io.words[.errorCode] = 0x85
          let status = unregister ? io.driver.unregisterCallback(id: id)
            : io.driver.registerCallback(id: id, callback: cordicTestCustom)
          XCTAssertEqual(status, valid ? .ok : .error)
          XCTAssertEqual(io.words[.errorCode], valid ? 0x85 : 0x95)
          XCTAssertEqual(io.words[.state], state); XCTAssertEqual(io.words[.lock], 0xA5)
          XCTAssertTrue(io.mmio.isEmpty)
          if valid, let callbackID = CORDICCallbackID(rawValue: id) {
            io.slots[callbackID]?(io.context)
            XCTAssertEqual(io.customCalls, unregister ? 0 : 1)
            XCTAssertEqual(io.events, unregister ? [callbackID] : [])
          }
        }
        let io = CORDICTestIO(registered: true); io.words[.state] = state; io.words[.errorCode] = 0x85
        XCTAssertEqual(io.driver.registerCallback(id: id, callback: nil), .error)
        XCTAssertEqual(io.words[.errorCode], 0x95)
        XCTAssertEqual(io.trace, [.word(.errorCode, 0x95)])
      }
    }
  }

  func testMacrosPreserveBitsDummyMacrosDoNoIOAndResetOnlyMSPSlots() {
    let io = CORDICTestIO(registered: true); io.registers[.csr] = 0xA5A4_1234
    io.driver.enableInterrupts(0x10000); io.driver.disableInterrupts(0x10000)
    XCTAssertEqual(io.registers[.csr], 0xA5A4_1234)
    XCTAssertEqual(io.driver.getInterruptSource(0xA000_0000), 0xA000_0000)
    XCTAssertEqual(io.driver.getFlag(0), 1); XCTAssertEqual(io.driver.getFlag(0xA000_0000), 1)
    XCTAssertEqual(io.driver.getFlag(0xA000_0001), 0)
    io.trace = []
    io.driver.getInterrupt(0x10000); io.driver.clearInterrupt(0x10000); io.driver.clearFlag(.max)
    XCTAssertTrue(io.trace.isEmpty)
    io.driver.resetHandleState()
    XCTAssertEqual(io.trace, [.word(.state, 0), .callbackWrite(.mspInitialize, false), .callbackWrite(.mspDeinitialize, false)])
    XCTAssertNotNil(io.slots[.error]); XCTAssertNotNil(io.slots[.calculateComplete])
    XCTAssertEqual(io.words[.lock], 0xA5)
    let legacy = CORDICTestIO(); legacy.driver.resetHandleState()
    XCTAssertEqual(legacy.trace, [.word(.state, 0)]); XCTAssertNotNil(legacy.slots[.mspInitialize])
  }

  func testConfigurationMasksAllFieldsAndRetainsStateErrorsAndLock() {
    let io = CORDICTestIO(); io.registers[.csr] = .max; io.words[.errorCode] = 31
    let config = CORDICConfiguration(function: 9, scale: 0x500, inputSize: 0,
      outputSize: 0x200000, writeCount: 0x100000, readCount: 0, precision: 0xA0)
    XCTAssertEqual(io.driver.configure(config), .ok)
    XCTAssertEqual(io.mmio, [.read(.csr), .write(.csr, 0xFFB7_FDA9)])
    XCTAssertEqual(io.words[.errorCode], 31); XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.words[.lock], 0xA5)
    io.trace = []; io.words[.state] = 2; io.words[.errorCode] = 0x80
    XCTAssertEqual(io.driver.configure(config), .error)
    XCTAssertEqual(io.trace, [.word(.errorCode, 0x82)])
  }

  func testPollingPipelineExactMMIOAndOutputBitPatterns() {
    let io = CORDICTestIO(); io.readValues[.rdata] = [0x8000_0000, .max, 0x1234_5678]
    XCTAssertEqual(io.driver.calculate(io.input, output: io.output, count: 3, timeout: 100, getTick: io.getTick), .ok)
    XCTAssertEqual(io.mmio, [.write(.wdata, 0x8000_0100), .read(.csr),
      .write(.wdata, 0x8000_0101), .read(.csr), .read(.csr), .read(.rdata), .read(.csr),
      .write(.wdata, 0x8000_0102), .read(.csr), .read(.csr), .read(.rdata), .read(.csr),
      .read(.rdata), .read(.csr)])
    XCTAssertEqual(Array(UnsafeBufferPointer(start: io.output, count: 3)), [.min, -1, 0x1234_5678])
    XCTAssertEqual(io.ticks, [0, 1, 2]); XCTAssertEqual(io.words[.lock], 0xA5)
    XCTAssertTrue(io.pointers.isEmpty); XCTAssertNil(io.words[.calculationsToOrder])
  }

  func testBothPollingModesRespectAllArgumentAndResultCounts() {
    for zeroOverhead in [false, true] {
      for arguments in 1...2 {
        for results in 1...2 {
          let io = CORDICTestIO()
          io.registers[.csr] = 0x8060_0000 | (arguments == 2 ? 0x100000 : 0) | (results == 2 ? 0x80000 : 0)
          io.readValues[.rdata] = (0..<(results * 3)).map { 0xFFFF_F000 + UInt32($0) }
          let status = zeroOverhead
            ? io.driver.calculateZeroOverhead(io.input, output: io.output, count: 3, timeout: 100, getTick: io.getTick)
            : io.driver.calculate(io.input, output: io.output, count: 3, timeout: 100, getTick: io.getTick)
          XCTAssertEqual(status, .ok)
          XCTAssertEqual(io.writes, (0..<(arguments * 3)).map { 0x8000_0100 + UInt32($0) })
          XCTAssertEqual(Array(UnsafeBufferPointer(start: io.output, count: results * 3)),
            (0..<(results * 3)).map { Int32(bitPattern: 0xFFFF_F000 + UInt32($0)) })
          XCTAssertEqual(io.output[results * 3], 0x1234_5678)
          XCTAssertEqual(io.mmio.filter { $0 == .read(.csr) }.count, zeroOverhead ? 6 : 8)
        }
      }
    }
  }

  func testHelpersReadArgumentAndResultCountAfterFirstTransfer() {
    let io = CORDICTestIO(); io.registers[.csr] = 0
    io.readValues[.rdata] = [0x8000_0000, .max]
    io.onWrite = { register, _ in if register == .wdata { io.registers[.csr, default: 0] |= 0x100000 } }
    io.onRead = { register in if register == .rdata { io.registers[.csr, default: 0] |= 0x80000 } }
    XCTAssertEqual(io.driver.calculate(io.input, output: io.output, count: 1, timeout: 0, getTick: io.getTick), .ok)
    XCTAssertEqual(io.writes, [0x8000_0100, 0x8000_0101]); XCTAssertEqual(io.output[0], .min); XCTAssertEqual(io.output[1], -1)
    XCTAssertEqual(io.mmio, [.write(.wdata, 0x8000_0100), .read(.csr), .write(.wdata, 0x8000_0101),
      .read(.rdata), .read(.csr), .read(.rdata)])
  }

  func testPollingTimeoutStrictBoundaryAcrossRolloverLeavesOutputUntouched() {
    let io = CORDICTestIO(); io.registers[.csr] = 0
    io.tickValues = [.max - 1, .max, 0, 1]
    XCTAssertEqual(io.driver.calculate(io.input, output: io.output, count: 2, timeout: 2, getTick: io.getTick), .error)
    XCTAssertEqual(io.ticks, [.max - 1, .max, 0, 1]); XCTAssertEqual(io.words[.state], 1)
    XCTAssertEqual(io.words[.errorCode], 4); XCTAssertEqual(io.words[.lock], 0xA5)
    XCTAssertEqual(io.output[0], 0x1234_5678); XCTAssertEqual(io.writes.count, 2)
    XCTAssertEqual(io.mmio.filter { $0 == .read(.csr) }.count, 4)
    XCTAssertFalse(io.mmio.contains(.read(.rdata)))
  }

  func testPollingChecksTimeoutBeforeReadyAndMaxDelaySuppressesFurtherTicks() {
    let expired = CORDICTestIO()
    XCTAssertEqual(expired.driver.calculate(expired.input, output: expired.output, count: 2,
      timeout: 0, getTick: expired.getTick), .error)
    XCTAssertEqual(expired.mmio.filter { $0 == .read(.csr) }.count, 2)
    XCTAssertEqual(expired.output[0], 0x1234_5678)
    let boundary = CORDICTestIO(); boundary.tickStep = 0
    XCTAssertEqual(boundary.driver.calculate(boundary.input, output: boundary.output, count: 2,
      timeout: 0, getTick: boundary.getTick), .ok)
    let infinite = CORDICTestIO(); infinite.readValues[.csr] = [0, 0, 0, 0, 0x8000_0000]
    XCTAssertEqual(infinite.driver.calculate(infinite.input, output: infinite.output, count: 2,
      timeout: .max, getTick: infinite.getTick), .ok)
    XCTAssertEqual(infinite.ticks, [0]); XCTAssertEqual(infinite.mmio.filter { $0 == .read(.csr) }.count, 7)
  }

  func testZeroOverheadConsumesOutputBeforeCheckingTimeout() {
    let io = CORDICTestIO(); io.registers[.csr] = 0; io.readValues[.rdata] = [.max, 0x8000_0000]
    XCTAssertEqual(io.driver.calculateZeroOverhead(io.input, output: io.output, count: 3,
      timeout: 0, getTick: io.getTick), .error)
    XCTAssertEqual(io.output[0], -1); XCTAssertEqual(io.output[1], 0x1234_5678)
    XCTAssertEqual(io.writes.count, 2); XCTAssertEqual(io.ticks, [0, 1]); XCTAssertEqual(io.words[.errorCode], 4)
    XCTAssertEqual(io.mmio, [.write(.wdata, 0x8000_0100), .read(.csr), .write(.wdata, 0x8000_0101),
      .read(.csr), .read(.rdata), .read(.csr)])
  }

  func testSingleCalculationSkipsTimeoutAndReadyPollingInBothModes() {
    for zeroOverhead in [false, true] {
      let io = CORDICTestIO(); io.registers[.csr] = 0; io.readValues[.rdata] = [.max]
      let status = zeroOverhead
        ? io.driver.calculateZeroOverhead(io.input, output: io.output, count: 1, timeout: 0, getTick: io.getTick)
        : io.driver.calculate(io.input, output: io.output, count: 1, timeout: 0, getTick: io.getTick)
      XCTAssertEqual(status, .ok); XCTAssertEqual(io.output[0], -1); XCTAssertEqual(io.ticks, [0])
      XCTAssertEqual(io.mmio, [.write(.wdata, 0x8000_0100), .read(.csr), .read(.rdata), .read(.csr)])
    }
  }

  func testBufferValidationPrecedesStateAndDoesNotTouchLockOrMMIO() {
    for operation in 0...2 {
      for invalid in 0...2 {
        let io = CORDICTestIO(); io.words[.state] = 2; io.words[.errorCode] = 0x80
        let input: UnsafePointer<Int32>? = invalid == 0 ? nil : UnsafePointer(io.input)
        let output: UnsafeMutablePointer<Int32>? = invalid == 1 ? nil : io.output
        let count: UInt32 = invalid == 2 ? 0 : 1
        let status: HALStatus
        if operation == 0 { status = io.driver.calculate(input, output: output, count: count, timeout: 0, getTick: io.getTick) }
        else if operation == 1 { status = io.driver.calculateZeroOverhead(input, output: output, count: count, timeout: 0, getTick: io.getTick) }
        else { status = io.driver.calculateInterrupt(input, output: output, count: count) }
        XCTAssertEqual(status, .error); XCTAssertEqual(io.trace, [.word(.errorCode, 0x81)])
        XCTAssertEqual(io.words[.lock], 0xA5)
      }
    }
    let io = CORDICTestIO(); io.words[.state] = .max; io.words[.errorCode] = 0x80
    XCTAssertEqual(io.driver.calculateInterrupt(io.input, output: io.output, count: 1), .error)
    XCTAssertEqual(io.trace, [.word(.errorCode, 0x82)])
  }

  func testInterruptStartPublishesCountersAndPointersBeforeEnablingAndWriting() {
    let io = CORDICTestIO(); io.registers[.csr] = 0x0010_0053
    io.onWrite = { register, _ in
      if register == .csr || register == .wdata {
        XCTAssertEqual(io.pointerOffset(.input), 2); XCTAssertEqual(io.pointerOffset(.output), 0)
        XCTAssertEqual(io.words[.calculationsToOrder], 2); XCTAssertEqual(io.words[.calculationsToGet], 3)
        XCTAssertEqual(io.words[.state], 2)
      }
    }
    XCTAssertEqual(io.driver.calculateInterrupt(io.input, output: io.output, count: 3), .ok)
    XCTAssertEqual(io.trace, [.word(.errorCode, 0), .word(.state, 2), .read(.csr),
      .pointer(.input, 2), .pointer(.output, 0), .word(.calculationsToOrder, 2), .word(.calculationsToGet, 3),
      .read(.csr), .write(.csr, 0x0011_0053), .write(.wdata, 0x8000_0100), .read(.csr), .write(.wdata, 0x8000_0101)])
    XCTAssertEqual(io.words[.lock], 0xA5)
  }

  func testInterruptStartRechecksArgumentCountAfterPublishingInputPointer() {
    let io = CORDICTestIO(); io.registers[.csr] = 0x100000
    io.onWrite = { register, _ in if register == .wdata { io.registers[.csr, default: 0] &= ~UInt32(0x100000) } }
    XCTAssertEqual(io.driver.calculateInterrupt(io.input, output: io.output, count: 2), .ok)
    XCTAssertEqual(io.pointerOffset(.input), 2); XCTAssertEqual(io.writes.count, 1)
  }

  func testInterruptGatesUseTwoFreshCSRReadsAndNoStateCheck() {
    let io = CORDICTestIO(); io.registers[.csr] = 0x80000000
    io.driver.handleInterrupt(); XCTAssertEqual(io.trace, [.read(.csr)])
    io.trace = []; io.readValues[.csr] = [0x10000, 0]
    io.driver.handleInterrupt(); XCTAssertEqual(io.trace, [.read(.csr), .read(.csr)])
    io.trace = []; io.words[.state] = 0x99; io.words[.calculationsToGet] = 1
    io.pointers[.output] = UnsafeMutableRawPointer(io.output); io.registers[.csr] = 0x80010000
    io.driver.handleInterrupt(); XCTAssertEqual(io.events, [.calculateComplete]); XCTAssertEqual(io.words[.state], 1)
  }

  func testInterruptPointerUpdatesPrecedeCountReadsAndCompletionCanRearm() {
    for registered in [false, true] {
      let io = CORDICTestIO(registered: registered); io.registers[.csr] = 0x8018_0000
      XCTAssertEqual(io.driver.calculateInterrupt(io.input, output: io.output, count: 2), .ok)
      io.trace = []; io.readValues[.rdata] = [1, 2, 3, 4]
      io.onRead = { register in
        if register == .csr && io.output[0] == 1 { XCTAssertGreaterThanOrEqual(io.pointerOffset(.output)!, 1) }
      }
      io.driver.handleInterrupt()
      XCTAssertEqual(io.trace, [.read(.csr), .read(.csr), .word(.calculationsToGet, 1),
        .read(.rdata), .pointer(.output, 1), .read(.csr), .read(.rdata), .pointer(.output, 2),
        .word(.calculationsToOrder, 0), .write(.wdata, 0x8000_0102), .pointer(.input, 3),
        .read(.csr), .write(.wdata, 0x8000_0103), .pointer(.input, 4)])
      io.onRead = nil
      io.onCallback = { id in
        if id == .calculateComplete {
          XCTAssertEqual(io.words[.state], 1); XCTAssertEqual(io.registers[.csr, default: 0] & 0x10000, 0)
          XCTAssertEqual(io.driver.calculateInterrupt(io.input, output: io.output, count: 1), .ok)
        }
      }
      io.driver.handleInterrupt()
      XCTAssertEqual(io.events, [.calculateComplete]); XCTAssertEqual(io.snapshots[0].get, 0)
      XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.calculationsToGet], 1)
      XCTAssertEqual(io.registers[.csr, default: 0] & 0x10000, 0x10000)
      XCTAssertEqual(Array(UnsafeBufferPointer(start: io.output, count: 4)), [1, 2, 3, 4])
    }
  }

  func testInterruptZeroRemainingCountWrapsWithoutInventedGuard() {
    let io = CORDICTestIO(); io.words[.state] = 3; io.words[.calculationsToGet] = 0
    io.pointers[.output] = UnsafeMutableRawPointer(io.output); io.registers[.csr] = 0x80010000
    io.driver.handleInterrupt()
    XCTAssertEqual(io.words[.calculationsToGet], .max); XCTAssertEqual(io.words[.state], 3)
    XCTAssertEqual(io.pointerOffset(.output), 1); XCTAssertTrue(io.events.isEmpty)
    XCTAssertEqual(io.registers[.csr], 0x80010000)
  }

  func testInterruptHelpersUseLivePointersAndFinalRemainingCount() {
    let io = CORDICTestIO(); io.words[.state] = 2
    io.words[.calculationsToGet] = 2; io.words[.calculationsToOrder] = 1
    io.pointers[.input] = UnsafeMutableRawPointer(io.input)
    io.pointers[.output] = UnsafeMutableRawPointer(io.output)
    io.registers[.csr] = 0x8019_0000; io.readValues[.rdata] = [11, 22]
    io.onRead = { register in
      if register == .csr && io.pointerOffset(.output) == 1 {
        io.pointers[.output] = UnsafeMutableRawPointer(io.output.advanced(by: 8))
        io.words[.calculationsToGet] = 0
      }
    }
    var firstWrite = true
    io.onWrite = { register, _ in
      if register == .wdata && firstWrite {
        firstWrite = false
        io.pointers[.input] = UnsafeMutableRawPointer(io.input.advanced(by: 8))
      }
    }
    io.driver.handleInterrupt()
    XCTAssertEqual(io.output[0], 11); XCTAssertEqual(io.output[1], 0x1234_5678)
    XCTAssertEqual(io.output[8], 22); XCTAssertEqual(io.pointerOffset(.output), 9)
    XCTAssertEqual(io.writes, [0x8000_0100, 0x8000_0109]); XCTAssertEqual(io.pointerOffset(.input), 10)
    XCTAssertEqual(io.events, [.calculateComplete]); XCTAssertEqual(io.words[.state], 1)
  }

  func testDMAValidationUsesOnlyRequestedDirectionsAndDoesNotSetBufferPointers() {
    for direction: UInt32 in 1...3 {
      let io = CORDICTestIO(); io.words[.calculationsToOrder] = 11; io.words[.calculationsToGet] = 12
      XCTAssertEqual(io.driver.calculateDMA(direction == 2 ? nil : io.input,
        output: direction == 1 ? nil : io.output, count: 1, direction: direction), .ok)
      XCTAssertTrue(io.pointers.isEmpty); XCTAssertEqual(io.words[.calculationsToOrder], 11)
      XCTAssertEqual(io.words[.calculationsToGet], 12); XCTAssertEqual(io.words[.lock], 0xA5)
      let bad = CORDICTestIO(); bad.words[.state] = 2; bad.words[.errorCode] = 0x80
      XCTAssertEqual(bad.driver.calculateDMA(nil, output: nil, count: 0, direction: direction), .error)
      XCTAssertEqual(bad.trace, [.word(.errorCode, 0x81)])
      XCTAssertEqual(bad.driver.calculateDMA(nil, output: nil, count: 1, direction: direction), .error)
      XCTAssertEqual(bad.words[.errorCode], 0x81)
    }
  }

  func testDMAStartsOutputBeforeInputAndEnablesRequestsAfterEachSuccessfulStart() {
    let io = CORDICTestIO(); io.registers[.csr] = 0x0018_0053
    let input = UInt32(truncatingIfNeeded: UInt(bitPattern: io.input))
    let output = UInt32(truncatingIfNeeded: UInt(bitPattern: io.output))
    XCTAssertEqual(io.driver.calculateDMA(io.input, output: io.output, count: 3, direction: 3), .ok)
    XCTAssertEqual(io.trace, [.word(.errorCode, 0), .word(.state, 2), .word(.dmaDirection, 3),
      .dmaCallback(.output, .transferComplete), .dmaCallback(.output, .error), .read(.csr),
      .dmaStart(.output, 0x48004408, output, 24), .read(.csr), .write(.csr, 0x001A_0053),
      .dmaCallback(.input, .transferComplete), .dmaCallback(.input, .error), .read(.csr),
      .dmaStart(.input, input, 0x48004404, 24), .read(.csr), .write(.csr, 0x001E_0053)])
  }

  func testDMAStartFailuresLeaveBusyAndPreserveAlreadyStartedOutput() {
    for failedDirection in [CORDICDMADirection.output, .input] {
      for status in [HALStatus.error, .busy, .timeout] {
        let io = CORDICTestIO(); io.registers[.csr] = 0x55
        io.dmaStatuses[failedDirection] = status
        XCTAssertEqual(io.driver.calculateDMA(io.input, output: io.output, count: 1, direction: 3), .error)
        XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.dmaDirection], 3)
        XCTAssertEqual(io.words[.errorCode], 8); XCTAssertEqual(io.words[.lock], 0xA5)
        XCTAssertEqual(io.registers[.csr], failedDirection == .output ? 0x55 : 0x20055)
        XCTAssertEqual(io.trace.filter { if case .dmaStart = $0 { return true }; return false }.count,
          failedDirection == .output ? 1 : 2)
        XCTAssertTrue(io.events.isEmpty)
      }
    }
  }

  func testDMASizeMultiplicationWrapsAtUInt32Width() {
    for pair in [(UInt32(0), UInt32(4)), (UInt32(0x180000), UInt32(8))] {
      let io = CORDICTestIO(); io.registers[.csr] = pair.0
      XCTAssertEqual(io.driver.calculateDMA(io.input, output: io.output, count: 0x4000_0001, direction: 3), .ok)
      let sizes = io.trace.compactMap { entry -> UInt32? in
        if case let .dmaStart(_, _, _, size) = entry { return size }; return nil
      }
      XCTAssertEqual(sizes, [pair.1, pair.1])
    }
  }

  func testDMACallbacksKeepExactDirectionStateErrorAndRequestSideEffects() {
    for registered in [false, true] {
      for direction: UInt32 in 0...3 {
        let io = CORDICTestIO(registered: registered); io.words[.state] = 2
        io.words[.dmaDirection] = direction; io.words[.errorCode] = 0x81; io.registers[.csr] = 0x8006_0053
        io.driver.handleDMAEvent(.inputComplete)
        XCTAssertEqual(io.registers[.csr], 0x8002_0053)
        XCTAssertEqual(io.words[.dmaDirection], direction == 1 ? 0 : direction)
        XCTAssertEqual(io.words[.state], direction == 1 ? 1 : 2)
        XCTAssertEqual(io.events, direction == 1 ? [.calculateComplete] : [])
        io.trace = []; io.snapshots = []
        io.driver.handleDMAEvent(.error)
        XCTAssertEqual(io.events, [.error]); XCTAssertEqual(io.snapshots[0].state, 1)
        XCTAssertEqual(io.snapshots[0].error, 0x89); XCTAssertEqual(io.snapshots[0].csr, 0x8002_0053)
        XCTAssertEqual(io.words[.dmaDirection], direction == 1 ? 0 : direction); XCTAssertTrue(io.mmio.isEmpty)
        io.snapshots = []; io.driver.handleDMAEvent(.outputComplete)
        XCTAssertEqual(io.events, [.calculateComplete]); XCTAssertEqual(io.snapshots[0].direction, 0)
        XCTAssertEqual(io.snapshots[0].state, 1); XCTAssertEqual(io.snapshots[0].csr, 0x8000_0053)
      }
    }
  }

  func testDMAInputCallbackReadsDirectionAfterRequestClearAndLateInputAffectsRearm() {
    let io = CORDICTestIO(); io.words[.state] = 2; io.words[.dmaDirection] = 3; io.registers[.csr] = 0x60000
    io.onWrite = { register, _ in if register == .csr { io.words[.dmaDirection] = 1 } }
    io.driver.handleDMAEvent(.inputComplete)
    XCTAssertEqual(io.events, [.calculateComplete]); XCTAssertEqual(io.words[.dmaDirection], 0)
    io.onWrite = nil; io.snapshots = []
    io.onCallback = { id in
      if id == .calculateComplete {
        XCTAssertEqual(io.driver.calculateDMA(io.input, output: io.output, count: 1, direction: 3), .ok)
      }
    }
    io.driver.handleDMAEvent(.outputComplete)
    XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.dmaDirection], 3)
    XCTAssertEqual(io.registers[.csr, default: 0] & 0x60000, 0x60000)
    io.driver.handleDMAEvent(.inputComplete)
    XCTAssertEqual(io.registers[.csr, default: 0] & 0x60000, 0x20000)
    XCTAssertEqual(io.events, [.calculateComplete]); XCTAssertEqual(io.words[.state], 2)
  }

  func testDMAForwarderUsesExistingDMATransferStateAndRearmsAfterCompletion() {
    let owner = CORDICBridgeOwner()
    XCTAssertEqual(owner.driver.calculateDMA(owner.io.input, output: owner.io.output, count: 3, direction: 3), .ok)
    XCTAssertEqual(owner.input.words[.state], 2); XCTAssertEqual(owner.output.words[.state], 2)
    XCTAssertEqual(owner.input.registers[.cbr1], 12); XCTAssertEqual(owner.output.registers[.cbr1], 12)
    XCTAssertEqual(owner.input.registers[.cdar], 0x48004404)
    XCTAssertEqual(owner.output.registers[.csar], 0x48004408)
    owner.input.complete()
    XCTAssertTrue(owner.io.events.isEmpty); XCTAssertEqual(owner.io.words[.state], 2)
    XCTAssertEqual(owner.input.words[.state], 1); XCTAssertEqual(owner.input.words[.lock], 0)
    owner.io.onCallback = { id in
      if id == .calculateComplete {
        XCTAssertEqual(owner.output.words[.state], 1); XCTAssertEqual(owner.output.words[.lock], 0)
        XCTAssertEqual(owner.driver.calculateDMA(owner.io.input, output: owner.io.output, count: 4, direction: 3), .ok)
      }
    }
    owner.output.complete()
    XCTAssertEqual(owner.io.events, [.calculateComplete]); XCTAssertEqual(owner.io.words[.state], 2)
    XCTAssertEqual(owner.input.words[.state], 2); XCTAssertEqual(owner.output.words[.state], 2)
    XCTAssertEqual(owner.input.registers[.cbr1], 16); XCTAssertEqual(owner.output.registers[.cbr1], 16)
    XCTAssertEqual(owner.io.registers[.csr, default: 0] & 0x60000, 0x60000)
    XCTAssertEqual(owner.input.parentReads, 1); XCTAssertEqual(owner.output.parentReads, 1)
  }

  func testAllDMAThunksReadLiveParentInsteadOfCapturingOriginalCORDIC() {
    let original = CORDICBridgeOwner(), replacement = CORDICBridgeOwner()
    original.io.words[.state] = 2; original.io.words[.dmaDirection] = 1; original.io.registers[.csr] = 0x40000
    replacement.io.words[.state] = 2; replacement.io.words[.dmaDirection] = 1; replacement.io.registers[.csr] = 0x40000
    original.input.parent = Unmanaged.passUnretained(replacement).toOpaque()
    original.links.callback(.inputComplete)(original.input.context)
    XCTAssertEqual(replacement.io.events, [.calculateComplete]); XCTAssertEqual(replacement.io.words[.state], 1)
    XCTAssertTrue(original.io.events.isEmpty); XCTAssertEqual(original.io.words[.state], 2)
    original.input.parent = Unmanaged.passUnretained(original).toOpaque()
    CORDICNoDMA().callback(.error)(original.input.context)
    XCTAssertEqual(original.io.events, [.error]); XCTAssertEqual(original.io.words[.errorCode], 8)
    original.links.callback(.outputComplete)(original.input.context)
    XCTAssertEqual(original.io.events, [.error, .calculateComplete]); XCTAssertEqual(original.input.parentReads, 3)
    XCTAssertEqual(original.io.registers[.csr], 0x40000)
  }

  func testGettersReturnUnknownRawBitsWithoutChangingState() {
    let io = CORDICTestIO(); io.words[.state] = 0xAABB_CCDD; io.words[.errorCode] = 0x8000_001F
    XCTAssertEqual(io.driver.getState(), 0xAABB_CCDD); XCTAssertEqual(io.driver.getError(), 0x8000_001F)
    XCTAssertTrue(io.trace.isEmpty)
  }
}
