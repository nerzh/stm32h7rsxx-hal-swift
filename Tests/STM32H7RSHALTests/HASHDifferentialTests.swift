import XCTest
import CHASHReference
@testable import STM32H7RSHAL

private func hashWords<T>(_ value: T) -> [UInt32] {
  withUnsafeBytes(of: value) { Array($0.bindMemory(to: UInt32.self)) }
}
private func hashReferenceCallback(_ pointer: UnsafeMutableRawPointer?, _ id: UInt32, _ implementation: UInt32) {
  let io = Unmanaged<HASHReferenceIO>.fromOpaque(pointer!).takeUnretainedValue()
  CHASH_EmitCallback(io.fixture.state, io.index, id, implementation)
}
private func hashCallback(_ id: UInt32, _ implementation: UInt32) -> HASHCallback? {
  if implementation == 0 { return nil }
  switch (id, implementation) {
  case (0, 1): return { hashReferenceCallback($0, 0, 1) }
  case (0, 2): return { hashReferenceCallback($0, 0, 2) }
  case (0, 3): return { hashReferenceCallback($0, 0, 3) }
  case (1, 1): return { hashReferenceCallback($0, 1, 1) }
  case (1, 2): return { hashReferenceCallback($0, 1, 2) }
  case (1, 3): return { hashReferenceCallback($0, 1, 3) }
  case (2, 1): return { hashReferenceCallback($0, 2, 1) }
  case (2, 2): return { hashReferenceCallback($0, 2, 2) }
  case (2, 3): return { hashReferenceCallback($0, 2, 3) }
  case (3, 1): return { hashReferenceCallback($0, 3, 1) }
  case (3, 2): return { hashReferenceCallback($0, 3, 2) }
  case (3, 3): return { hashReferenceCallback($0, 3, 3) }
  case (4, 1): return { hashReferenceCallback($0, 4, 1) }
  case (4, 2): return { hashReferenceCallback($0, 4, 2) }
  case (4, 3): return { hashReferenceCallback($0, 4, 3) }
  default: return { hashReferenceCallback($0, 0, 2) }
  }
}
private final class HASHReferenceIO: HASHRegisterIO, HASHHandleIO, HASHCallbackIO, HASHDMAIO, HASHMemoryIO {
  unowned let fixture: HASHReferenceFixture
  let index: UInt32
  init(_ fixture: HASHReferenceFixture, _ index: UInt32) { self.fixture = fixture; self.index = index }
  var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
  var driver: HASH<HASHReferenceIO, HASHReferenceIO, HASHReferenceIO, HASHReferenceIO, HASHReferenceIO> {
    .init(registers: self, handle: self, callbacks: self, dma: self, memory: self,
      defaults: .init(mspInitialize: hashCallback(0, 1)!, mspDeinitialize: hashCallback(1, 1)!,
        inputComplete: hashCallback(2, 1)!, digestComplete: hashCallback(3, 1)!, error: hashCallback(4, 1)!),
      useRegisteredCallbacks: fixture.registered, useSuspendResume: fixture.suspend)
  }
  func map(_ register: HASHRegister) -> CHASHRegister {
    switch register {
    case .cr: return CHASH_CR
    case .din: return CHASH_DIN
    case .str: return CHASH_STR
    case .imr: return CHASH_IMR
    case .sr: return CHASH_SR
    case .hr(let i): return CHASHRegister(rawValue: CHASH_HR0.rawValue + UInt32(i))
    case .csr(let i): return CHASHRegister(rawValue: CHASH_CSR0.rawValue + UInt32(i))
    case .digest(let i): return CHASHRegister(rawValue: CHASH_DIGEST0.rawValue + UInt32(i))
    }
  }
  func read(_ register: HASHRegister) -> UInt32 {
    fixture.scriptedRegisters.contains(register) ? CHASH_Read(fixture.state, map(register)) : CHASH_Get(fixture.state, map(register))
  }
  func write(_ register: HASHRegister, value: UInt32) {
    if register == .din { CHASH_Set(fixture.state, map(register), value) }
    else { CHASH_Write(fixture.state, map(register), value) }
  }
  func address(of register: HASHRegister) -> UInt32 {
    let r = map(register).rawValue
    if r <= CHASH_SR.rawValue { return 0x48020400 + r * 4 }
    if r <= CHASH_CSR102.rawValue { return 0x480204F8 + (r - CHASH_CSR0.rawValue) * 4 }
    return 0x48020710 + (r - CHASH_DIGEST0.rawValue) * 4
  }
  func read(_ word: HASHHandleWord) -> UInt32 { CHASH_GetWord(fixture.state, index, UInt32(word.rawValue)) }
  func write(_ word: HASHHandleWord, value: UInt32) { CHASH_SetWord(fixture.state, index, UInt32(word.rawValue), value) }
  func read8(at address: UInt32) -> UInt8 { UInt8(truncatingIfNeeded: CHASH_ReadMemory(fixture.state, address, 1)) }
  func read16(at address: UInt32) -> UInt16 { UInt16(truncatingIfNeeded: CHASH_ReadMemory(fixture.state, address, 2)) }
  func read32(at address: UInt32) -> UInt32 { CHASH_ReadMemory(fixture.state, address, 4) }
  func write32(at address: UInt32, value: UInt32) { CHASH_WriteMemory(fixture.state, address, value, 4) }
  func read(_ id: HASHCallbackID) -> HASHCallback? { hashCallback(id.rawValue, CHASH_GetCallback(fixture.state, index, id.rawValue)) }
  func write(_ id: HASHCallbackID, value: HASHCallback?) {
    var selector: UInt32 = 0
    if let value {
      for candidate in UInt32(1)...3 where unsafeBitCast(value, to: UInt.self) == unsafeBitCast(hashCallback(id.rawValue, candidate)!, to: UInt.self) { selector = candidate }
      precondition(selector != 0)
    }
    CHASH_SetCallback(fixture.state, index, id.rawValue, selector)
  }
  var channel: UInt32 { let value = CHASH_GetLink(fixture.state, index); precondition(value >= 0); return UInt32(value) }
  func read(_ word: DMAHandleWord) -> UInt32 {
    switch word {
    case .mode: return CHASH_GetDMAWord(fixture.state, channel, 1)
    case .queueAddress: return CHASH_GetDMAWord(fixture.state, channel, 4) != 0 ? 0x20003000 + channel * 0x100 : 0
    case .errorCode: return CHASH_GetDMAWord(fixture.state, channel, 6)
    default: preconditionFailure("Unused HASH DMA word")
    }
  }
  func getCounter() -> UInt32 { CHASH_GetDMAWord(fixture.state, channel, 2) & 0xFFFF }
  func getFIFOLevel() -> UInt32 { (CHASH_GetDMAWord(fixture.state, channel, 3) >> 16) & 0xFF }
  func readMemory32(at address: UInt32) -> UInt32 { CHASH_ReadMemory(fixture.state, address, 4) }
  func writeMemory32(at address: UInt32, value: UInt32) { CHASH_WriteMemory(fixture.state, address, value, 4) }
  func writeCallback(_ id: DMACallbackID, value: DMACallback?) {
    let slot: UInt32
    switch id { case .transferComplete: slot = 0; case .error: slot = 1; default: preconditionFailure("Unused HASH DMA callback") }
    var selector: UInt32 = 0
    if let value {
      for kind in HASHDMACallbackKind.allCases where unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) { selector = kind.rawValue + 1 }
      precondition(selector != 0)
    }
    CHASH_SetDMACallback(fixture.state, channel, slot, selector)
  }
  func callback(_ kind: HASHDMACallbackKind) -> DMACallback { HASHNoDMA().callback(kind) }
  func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
    HALStatus(rawValue: CHASH_DMAOperation(fixture.state, channel, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt() -> HALStatus { HALStatus(rawValue: CHASH_DMAOperation(fixture.state, channel, 1, 0, 0, 0))! }
  func abort(getTick: () -> UInt32) -> HALStatus { HALStatus(rawValue: CHASH_DMAOperation(fixture.state, channel, 2, 0, 0, 0))! }
  @discardableResult func run(_ operation: CHASHOperation, a: UInt32, b: UInt32, c: UInt32, d: UInt32) -> UInt32 {
    let tick = { CHASH_Tick(self.fixture.state) }
    switch operation {
    case CHASH_Initialize: return driver.initialize().rawValue
    case CHASH_Deinitialize: return driver.deinitialize().rawValue
    case CHASH_SetConfiguration:
      let v = fixture.state.pointee.configuration
      return driver.setConfiguration(a != 0 ? nil : .init(dataType: v.0, keySize: v.1, keyAddress: v.2, algorithm: v.3)).rawValue
    case CHASH_GetConfiguration:
      let v = fixture.state.pointee.configuration
      var configuration = HASHConfiguration(dataType: v.0, keySize: v.1, keyAddress: v.2, algorithm: v.3)
      let result = a != 0 ? driver.getConfiguration(nil) : driver.getConfiguration(&configuration)
      fixture.state.pointee.configuration = (configuration.dataType, configuration.keySize, configuration.keyAddress, configuration.algorithm)
      return result.rawValue
    case CHASH_Start: return driver.start(inputAddress: a, size: b, outputAddress: c, timeout: d, getTick: tick).rawValue
    case CHASH_StartInterrupt: return driver.startInterrupt(inputAddress: a, size: b, outputAddress: c).rawValue
    case CHASH_StartDMA: return driver.startDMA(inputAddress: a, size: b, outputAddress: c).rawValue
    case CHASH_Accumulate: return driver.accumulate(inputAddress: a, size: b, timeout: d, getTick: tick).rawValue
    case CHASH_AccumulateLast: return driver.accumulateLast(inputAddress: a, size: b, outputAddress: c, timeout: d, getTick: tick).rawValue
    case CHASH_AccumulateInterrupt: return driver.accumulateInterrupt(inputAddress: a, size: b).rawValue
    case CHASH_AccumulateLastInterrupt: return driver.accumulateLastInterrupt(inputAddress: a, size: b, outputAddress: c).rawValue
    case CHASH_HMACStart: return driver.startHMAC(inputAddress: a, size: b, outputAddress: c, timeout: d, getTick: tick).rawValue
    case CHASH_HMACAccumulate: return driver.accumulateHMAC(inputAddress: a, size: b, timeout: d, getTick: tick).rawValue
    case CHASH_HMACAccumulateLast: return driver.accumulateHMACLast(inputAddress: a, size: b, outputAddress: c, timeout: d, getTick: tick).rawValue
    case CHASH_HMACStartInterrupt: return driver.startHMACInterrupt(inputAddress: a, size: b, outputAddress: c).rawValue
    case CHASH_HMACAccumulateInterrupt: return driver.accumulateHMACInterrupt(inputAddress: a, size: b).rawValue
    case CHASH_HMACAccumulateLastInterrupt: return driver.accumulateHMACLastInterrupt(inputAddress: a, size: b, outputAddress: c).rawValue
    case CHASH_HMACStartDMA: return driver.startHMACDMA(inputAddress: a, size: b, outputAddress: c).rawValue
    case CHASH_HandleInterrupt: driver.handleInterrupt()
    case CHASH_GetState: return driver.getState()
    case CHASH_GetError: return driver.getError()
    case CHASH_ResetHandleState: driver.resetHandleState()
    case CHASH_RegisterCallback: return driver.registerCallback(id: a, callback: hashCallback(a, b)).rawValue
    case CHASH_UnregisterCallback: return driver.unregisterCallback(id: a).rawValue
    case CHASH_EnableInterrupts: driver.enableInterrupts(a)
    case CHASH_DisableInterrupts: driver.disableInterrupts(a)
    case CHASH_GetFlag: return driver.getFlag(a)
    case CHASH_ClearFlag: driver.clearFlag(a)
    case CHASH_GetInterruptSource: return driver.getInterruptSource(a)
    case CHASH_SetMDMAT: driver.enableMultipleDMATransfers()
    case CHASH_ResetMDMAT: driver.disableMultipleDMATransfers()
    case CHASH_DigestLength: return UInt32(driver.digestLength())
    case CHASH_WriteData: driver.writeData(inputAddress: a, size: b)
    case CHASH_WriteDataInterrupt: return driver.writeDataInterrupt().rawValue
    case CHASH_GetDigest: driver.getDigest(outputAddress: a, size: UInt8(truncatingIfNeeded: b))
    case CHASH_Wait: return driver.waitOnFlagUntilTimeout(a, status: b, timeout: c, getTick: tick).rawValue
    case CHASH_Suspend: driver.suspend(contextAddress: a)
    case CHASH_Resume: driver.resume(contextAddress: a)
    case CHASH_ProcessSuspend: return driver.processSuspend(getTick: tick).rawValue
    default: preconditionFailure("Unknown HASH operation")
    }
    return 0
  }
}
private final class HASHReferenceFixture {
  let state = UnsafeMutablePointer<CHASHState>.allocate(capacity: 1)
  let registered: Bool, suspend: Bool
  var handles: [HASHReferenceIO] = []
  var scriptedRegisters: Set<HASHRegister> = []
  init(registered: Bool, suspend: Bool, swift: Bool) {
    self.registered = registered; self.suspend = suspend
    CHASH_Reset(state, registered ? 1 : 0, suspend ? 1 : 0)
    handles = [HASHReferenceIO(self, 0), HASHReferenceIO(self, 1)]
    if swift {
      CHASH_SetExecutionHook(state, Unmanaged.passUnretained(self).toOpaque(), { pointer, action in
        let fixture = Unmanaged<HASHReferenceFixture>.fromOpaque(pointer!).takeUnretainedValue()
        if action.kind == CHASH_ActionDMAEvent { fixture.dma(action.target, action.index) }
        else { fixture.handles[Int(action.target)].run(CHASHOperation(rawValue: action.index), a: action.a, b: action.b, c: action.c, d: action.d) }
      })
    }
  }
  deinit { state.deallocate() }
  func dma(_ channel: UInt32, _ kind: UInt32) {
    let parent = CHASH_GetDMAWord(state, channel, 0)
    precondition(parent < 2)
    handles[Int(parent)].driver.handleDMAEvent(HASHDMACallbackKind(rawValue: kind)!)
  }
}
private final class HASHReferencePair {
  let actual: HASHReferenceFixture, reference: HASHReferenceFixture
  init(registered: Bool, suspend: Bool, setup: (UnsafeMutablePointer<CHASHState>) -> Void = { _ in }) {
    actual = .init(registered: registered, suspend: suspend, swift: true)
    reference = .init(registered: registered, suspend: suspend, swift: false)
    configure(setup)
  }
  func configure(_ setup: (UnsafeMutablePointer<CHASHState>) -> Void) { setup(actual.state); setup(reference.state) }
  func clearObservations() {
    configure { $0.pointee.accessCount = 0; $0.pointee.callbackCount = 0; $0.pointee.dmaCount = 0 }
  }
  @discardableResult func run(_ operation: CHASHOperation, handle: UInt32 = 0,
    a: UInt32 = 0, b: UInt32 = 0, c: UInt32 = 0, d: UInt32 = 0,
    file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
    clearObservations()
    let expected = CHASH_Run(reference.state, handle, operation, a, b, c, d)
    let result = actual.handles[Int(handle)].run(operation, a: a, b: b, c: c, d: d)
    XCTAssertEqual(result, expected, "operation \(operation.rawValue)", file: file, line: line)
    compare(file: file, line: line); return result
  }
  func dma(_ channel: UInt32, _ kind: UInt32, file: StaticString = #filePath, line: UInt = #line) {
    clearObservations(); CHASH_InvokeDMA(reference.state, channel, kind); actual.dma(channel, kind); compare(file: file, line: line)
  }
  func compare(file: StaticString, line: UInt) {
    let a = actual.state, r = reference.state
    XCTAssertEqual(hashWords(CHASH_GetSnapshot(a)), hashWords(CHASH_GetSnapshot(r)), file: file, line: line)
    for index in UInt32(0)..<CHASH_RegisterCount.rawValue {
      XCTAssertEqual(CHASH_Get(a, CHASHRegister(rawValue: index)), CHASH_Get(r, CHASHRegister(rawValue: index)), "register \(index)", file: file, line: line)
    }
    XCTAssertEqual(hashWords(a.pointee.configuration), hashWords(r.pointee.configuration), file: file, line: line)
    XCTAssertEqual(a.pointee.tick, r.pointee.tick, file: file, line: line)
    XCTAssertEqual(a.pointee.tickCalls, r.pointee.tickCalls, file: file, line: line)
    XCTAssertEqual(a.pointee.callbackCount, r.pointee.callbackCount, file: file, line: line)
    XCTAssertEqual(a.pointee.dmaCount, r.pointee.dmaCount, file: file, line: line)
    for i in 0..<min(a.pointee.callbackCount, r.pointee.callbackCount) {
      XCTAssertEqual(hashWords(CHASH_GetCallbackEvent(a, i)), hashWords(CHASH_GetCallbackEvent(r, i)), "callback \(i)", file: file, line: line)
    }
    for i in 0..<min(a.pointee.dmaCount, r.pointee.dmaCount) {
      XCTAssertEqual(hashWords(CHASH_GetDMAEvent(a, i)), hashWords(CHASH_GetDMAEvent(r, i)), "DMA \(i)", file: file, line: line)
    }
    func writes(_ s: UnsafeMutablePointer<CHASHState>) -> [[UInt32]] {
      (0..<s.pointee.accessCount).compactMap { i in
        let v = CHASH_GetAccess(s, i)
        return v.kind == 1 ? [v.reg.rawValue, v.value, v.tickCalls] : nil
      }
    }
    XCTAssertEqual(writes(a), writes(r), "macro MMIO writes", file: file, line: line)
  }
}
private func hashReady(_ s: UnsafeMutablePointer<CHASHState>, handle: UInt32 = 0) {
  CHASH_SetWord(s, handle, CHASH_state.rawValue, 1); CHASH_SetWord(s, handle, CHASH_phase.rawValue, 1)
  for id in UInt32(0)..<5 { CHASH_SetCallback(s, handle, id, 1) }
}
private func hashAction(_ kind: CHASHActionKind, target: UInt32 = 0, index: UInt32 = 0, value: UInt32 = 0,
  a: UInt32 = 0, b: UInt32 = 0, c: UInt32 = 0, d: UInt32 = 0) -> CHASHAction {
  .init(kind: kind, target: target, index: index, value: value, a: a, b: b, c: c, d: d)
}

final class HASHDifferentialTests: XCTestCase {
  func testLifecycleAcrossBothCallbackAndSuspendOptions() {
    for registered in [false, true] { for suspend in [false, true] {
      for state in UInt32(0)...3 { for lock: UInt32 in [0, 1, 2] { for selector in UInt32(0)...3 {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
          CHASH_Set(s, CHASH_CR, .max)
          for word in UInt32(6)..<25 { CHASH_SetWord(s, 0, word, 0xA0 + word) }
          CHASH_SetWord(s, 0, CHASH_state.rawValue, state); CHASH_SetWord(s, 0, CHASH_lock.rawValue, lock)
          for id in UInt32(0)..<5 { CHASH_SetCallback(s, 0, id, selector) }
        }
        pair.run(CHASH_Initialize); pair.run(CHASH_GetState); pair.run(CHASH_GetError)
        pair.run(CHASH_Deinitialize); pair.run(CHASH_ResetHandleState)
      } } }
    } }
  }
  func testMSPReentryAndConfigurationChangesRemainVisible() {
    for registered in [false, true] { for suspend in [false, true] {
      let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
        CHASH_SetCallback(s, 0, 0, 3)
        CHASH_SetCallbackAction(s, 0, 0, 0, hashAction(CHASH_ActionWord, index: CHASH_dataType.rawValue, value: 0x30))
        CHASH_SetCallbackAction(s, 0, 0, 1, hashAction(CHASH_ActionWord, index: CHASH_algorithm.rawValue, value: 0x001E0000))
        CHASH_SetCallbackAction(s, 0, 0, 2, hashAction(CHASH_ActionWord, index: CHASH_lock.rawValue, value: 1))
        CHASH_SetCallbackAction(s, 0, 0, 3, hashAction(CHASH_ActionCall, index: CHASH_GetError.rawValue))
        CHASH_SetCallbackAction(s, 0, 1, 0, hashAction(CHASH_ActionWord, index: CHASH_inputCount.rawValue, value: 99))
      }
      pair.run(CHASH_Initialize)
      XCTAssertEqual(CHASH_GetWord(pair.actual.state, 0, CHASH_lock.rawValue), 1)
      pair.run(CHASH_Deinitialize)
      XCTAssertEqual(CHASH_GetWord(pair.actual.state, 0, CHASH_inputCount.rawValue), 99)
    } }
  }
  func testSetConfigurationAlgorithmsFormatsStatesAndLockOrdering() {
    for registered in [false, true] { for suspend in [false, true] {
      for algorithm in HASHAlgorithm.allCases { for data in HASHDataType.allCases {
        for state in UInt32(0)...3 { for lock in UInt32(0)...2 {
          let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
            hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, state); CHASH_SetWord(s, 0, CHASH_lock.rawValue, lock)
            CHASH_SetWord(s, 0, CHASH_errorCode.rawValue, 0x80); CHASH_Set(s, CHASH_CR, .max)
            s.pointee.configuration = (data.rawValue, .max, 0x20000410, algorithm.rawValue)
          }
          pair.run(CHASH_SetConfiguration)
          pair.run(CHASH_GetConfiguration)
        } }
      } }
    } }
  }
  func testGetConfigurationPreservesRawFieldsAndNullOutputs() {
    for registered in [false, true] { for suspend in [false, true] {
      for state: UInt32 in [0, 1, 2, 3, .max] { for lock: UInt32 in [0, 1, 2] { for null in UInt32(0)...1 {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
          hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, state); CHASH_SetWord(s, 0, CHASH_lock.rawValue, lock)
          CHASH_SetWord(s, 0, CHASH_dataType.rawValue, .max); CHASH_SetWord(s, 0, CHASH_algorithm.rawValue, .max)
          CHASH_SetWord(s, 0, CHASH_keySize.rawValue, .max); CHASH_SetWord(s, 0, CHASH_keyAddress.rawValue, 0x20001600)
          s.pointee.configuration = (0x55, 0x66, 0x20000400, 0x77)
        }
        pair.run(CHASH_GetConfiguration, a: null)
        pair.configure { $0.pointee.configuration = (0, 0, 0, 0) }
        pair.run(CHASH_SetConfiguration, a: 1)
      } } }
    } }
  }
  func testRegistrationAllIDsNullCallbacksAndLifecycleStates() {
    for suspend in [false, true] { for state: UInt32 in [0, 1, 2, 3, .max] {
      for id: UInt32 in [0, 1, 2, 3, 4, 5, .max] { for selector in UInt32(0)...3 {
        let pair = HASHReferencePair(registered: true, suspend: suspend) { s in
          hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, state)
          CHASH_SetWord(s, 0, CHASH_lock.rawValue, 1); CHASH_SetWord(s, 0, CHASH_errorCode.rawValue, 0x80)
        }
        pair.run(CHASH_RegisterCallback, a: id, b: selector)
        pair.run(CHASH_UnregisterCallback, a: id)
        pair.run(CHASH_ResetHandleState)
      } }
    } }
  }
  func testFlagsMacrosAndRepeatedDigestAlgorithmReads() {
    for registered in [false, true] { for suspend in [false, true] {
      for seed: UInt32 in [0, .max, 0xA5A55A5A] {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
          CHASH_Set(s, CHASH_CR, seed); CHASH_Set(s, CHASH_SR, ~seed); CHASH_Set(s, CHASH_IMR, seed)
        }
        for flag: UInt32 in [0, 1, 2, 3, 4, 8, 9, 0x1000, .max] {
          pair.run(CHASH_GetFlag, a: flag); pair.run(CHASH_GetInterruptSource, a: flag)
          pair.run(CHASH_EnableInterrupts, a: flag); pair.run(CHASH_DisableInterrupts, a: flag)
          pair.run(CHASH_ClearFlag, a: flag)
        }
        pair.run(CHASH_SetMDMAT); pair.run(CHASH_ResetMDMAT)
      }
      for algorithm: UInt32 in [0, 0x40000, 0x60000, 0x180000, 0x1A0000, 0x1C0000, 0x1E0000, 0x80000] {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { CHASH_Set($0, CHASH_CR, algorithm) }
        pair.actual.scriptedRegisters = [.cr]
        pair.run(CHASH_DigestLength)
        XCTAssertEqual(pair.actual.state.pointee.readCounts.0, pair.reference.state.pointee.readCounts.0)
      }
      let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
        CHASH_Set(s, CHASH_CR, 0x180000)
        CHASH_ScheduleRead(s, CHASH_CR, 2, hashAction(CHASH_ActionRegister, index: CHASH_CR.rawValue, value: 0x60000))
      }
      pair.actual.scriptedRegisters = [.cr]
      XCTAssertEqual(pair.run(CHASH_DigestLength), 32)
    } }
  }
  func testWaitStrictTimeoutZeroRolloverAndFinalReadyWithoutRecheck() {
    for registered in [false, true] { for suspend in [false, true] {
      for start: UInt32 in [0, .max - 2] { for timeout: UInt32 in [0, 1, 3, 10] { for readyCall in UInt32(1)...14 {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
          hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, 2); CHASH_SetWord(s, 0, CHASH_lock.rawValue, 1)
          CHASH_SetWord(s, 0, CHASH_errorCode.rawValue, 0x80); s.pointee.tick = start
          CHASH_ScheduleTick(s, readyCall, hashAction(CHASH_ActionRegister, index: CHASH_SR.rawValue, value: 2))
        }
        pair.run(CHASH_Wait, a: 2, b: 0, c: timeout)
      } } }
      let ready = HASHReferencePair(registered: registered, suspend: suspend) { CHASH_Set($0, CHASH_SR, 2) }
      ready.run(CHASH_Wait, a: 2, b: 0, c: .max)
      XCTAssertEqual(ready.actual.state.pointee.tickCalls, 1)
      let late = HASHReferencePair(registered: registered, suspend: suspend) { s in
        CHASH_ScheduleTick(s, 2, hashAction(CHASH_ActionRegister, index: CHASH_SR.rawValue, value: 2))
      }
      XCTAssertEqual(late.run(CHASH_Wait, a: 2, b: 0, c: 0), 1)
      XCTAssertEqual(CHASH_Get(late.actual.state, CHASH_SR), 2)
    } }
  }
  func testDataEntryRejectionsReturnBeforeNarrowedPointerDereferences() {
    let operations: [CHASHOperation] = [CHASH_Start, CHASH_StartInterrupt, CHASH_StartDMA,
      CHASH_Accumulate, CHASH_AccumulateLast, CHASH_AccumulateInterrupt, CHASH_AccumulateLastInterrupt,
      CHASH_HMACStart, CHASH_HMACAccumulate, CHASH_HMACAccumulateLast, CHASH_HMACStartInterrupt,
      CHASH_HMACAccumulateInterrupt, CHASH_HMACAccumulateLastInterrupt, CHASH_HMACStartDMA]
    for registered in [false, true] { for suspend in [false, true] {
      for operation in operations { for state: UInt32 in [0, 1, 2, 3, .max] {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
          hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, state); CHASH_SetWord(s, 0, CHASH_lock.rawValue, 1)
          CHASH_SetWord(s, 0, CHASH_errorCode.rawValue, 0x80)
        }
        pair.run(operation, a: 0x20000000, b: 4, c: 0x20000800, d: 0)
      } }
      for operation in [CHASH_Accumulate, CHASH_AccumulateInterrupt, CHASH_HMACAccumulate, CHASH_HMACAccumulateInterrupt] {
        for size: UInt32 in [1, 2, 3, 65, .max] {
          let pair = HASHReferencePair(registered: registered, suspend: suspend) { hashReady($0) }
          pair.run(operation, a: 0x20000000, b: size, c: 0x20000800, d: 0)
        }
      }
    } }
  }
  func testZeroSizePollingTimeoutsAndUnchangedEmptyInputHelpers() {
    for registered in [false, true] { for suspend in [false, true] {
      for operation in [CHASH_Start, CHASH_Accumulate, CHASH_AccumulateLast, CHASH_HMACStart, CHASH_HMACAccumulate, CHASH_HMACAccumulateLast] {
        for status: UInt32 in [0, 8] { for timeout: UInt32 in [0, 3] {
          let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
            hashReady(s); CHASH_Set(s, CHASH_SR, status); CHASH_SetWord(s, 0, CHASH_phase.rawValue, 2)
          }
          pair.run(operation, a: 0x20000000, b: 0, c: 0x20000800, d: timeout)
        } }
      }
      let pair = HASHReferencePair(registered: registered, suspend: suspend) { hashReady($0) }
      pair.run(CHASH_WriteData, a: 0x20000000, b: 0)
      for size: UInt32 in [0, 1, 8, 16, 63, 255] { pair.run(CHASH_GetDigest, a: 0x20000800, b: size) }
      pair.run(CHASH_WriteDataInterrupt)
      pair.run(CHASH_HandleInterrupt)
    } }
  }
  func testDMAStartStatusRoundingAndMissingLinkedNodes() {
    for registered in [false, true] { for suspend in [false, true] {
      for mode: UInt32 in [0, 0x80, 0x81] { for status in UInt32(0)...3 { for size: UInt32 in [0, 1, 3, 4, 63, 64, .max - 2, .max] {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
          hashReady(s); CHASH_SetDMAWord(s, 0, 1, mode)
          s.pointee.dmaStatus.0 = (status, status, 0)
        }
        pair.run(CHASH_StartDMA, a: 0x20000000, b: size, c: 0x20000800)
      } } }
      for missing in UInt32(4)...5 {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
          hashReady(s); CHASH_SetDMAWord(s, 0, 1, 0x80); CHASH_SetDMAWord(s, 0, missing, 0)
        }
        XCTAssertEqual(pair.run(CHASH_StartDMA, a: 0x20000000, b: 8, c: 0x20000800), 1)
      }
    } }
  }
  func testSuspendedDMAUsesDifferentNormalAndLinkedSourceAddresses() {
    for registered in [false, true] { for suspend in [false, true] {
      for operation in [CHASH_StartDMA, CHASH_HMACStartDMA] { for mode: UInt32 in [0, 0x80] {
        let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
          hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, 3)
          CHASH_SetWord(s, 0, CHASH_inputAddress.rawValue, 0x20000014)
          CHASH_SetWord(s, 0, CHASH_outputAddress.rawValue, 0x20000804)
          CHASH_SetWord(s, 0, CHASH_inputCount.rawValue, 9); CHASH_SetDMAWord(s, 0, 1, mode)
        }
        pair.run(operation, a: 0x20000000, b: 123, c: 0x20000800)
        let event = CHASH_GetDMAEvent(pair.actual.state, 0)
        XCTAssertEqual(event.source, operation == CHASH_StartDMA && mode == 0 ? 0x20000000 : 0x20000014)
        XCTAssertEqual(event.size, 12)
      } }
    } }
  }
  func testDMAErrorLiveParentReentryAndMultiBufferCompletion() {
    for registered in [false, true] { for suspend in [false, true] {
      let pair = HASHReferencePair(registered: registered, suspend: suspend) { s in
        hashReady(s); hashReady(s, handle: 1); CHASH_SetDMAWord(s, 0, 0, 1)
        CHASH_SetWord(s, 1, CHASH_state.rawValue, 2); CHASH_SetWord(s, 1, CHASH_lock.rawValue, 1)
        CHASH_SetWord(s, 1, CHASH_errorCode.rawValue, 0x80); CHASH_Set(s, CHASH_CR, 8)
        CHASH_SetCallbackAction(s, 1, 4, 0, hashAction(CHASH_ActionWord, target: 1, index: CHASH_lock.rawValue, value: 0))
        CHASH_SetCallbackAction(s, 1, 4, 1, hashAction(CHASH_ActionCall, target: 1, index: CHASH_StartDMA.rawValue, a: 0x20001000, b: 8, c: 0x20001800))
      }
      pair.dma(0, 1)
      XCTAssertEqual(CHASH_GetWord(pair.actual.state, 1, CHASH_state.rawValue), 2)
      for hmac in [false, true] {
        let completion = HASHReferencePair(registered: registered, suspend: suspend) { s in
          hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, 2); CHASH_SetWord(s, 0, CHASH_lock.rawValue, 1)
          CHASH_SetWord(s, 0, CHASH_phase.rawValue, 4); CHASH_Set(s, CHASH_CR, 0x2008 | (hmac ? 0x40 : 0))
        }
        completion.dma(0, 0)
        XCTAssertEqual(completion.actual.state.pointee.callbackCount, 0)
      }
    } }
  }
  func testProcessSuspendUnitComparisonAbortFailuresAndRemainingPointer() {
    for registered in [false, true] {
      for state in UInt32(0)...3 {
        let pair = HASHReferencePair(registered: registered, suspend: true) { s in
          hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, state)
        }
        pair.run(CHASH_ProcessSuspend)
      }
      for remaining: UInt32 in [0, 31, 32, 33, 63] { for abortStatus in UInt32(0)...3 {
        let pair = HASHReferencePair(registered: registered, suspend: true) { s in
          hashReady(s); CHASH_SetWord(s, 0, CHASH_state.rawValue, 2); CHASH_SetWord(s, 0, CHASH_lock.rawValue, 1)
          CHASH_SetWord(s, 0, CHASH_inputAddress.rawValue, 0x20000000); CHASH_SetWord(s, 0, CHASH_size.rawValue, 256)
          CHASH_Set(s, CHASH_CR, 8); CHASH_Set(s, CHASH_SR, 0x80004)
          CHASH_SetDMAWord(s, 0, 2, remaining * 4); s.pointee.dmaStatus.0 = (0, 0, abortStatus)
          CHASH_ScheduleTick(s, 1, hashAction(CHASH_ActionRegister, index: CHASH_SR.rawValue, value: 1))
        }
        pair.run(CHASH_ProcessSuspend)
      } }
    }
  }
  func testNullCHandlesBeforeAnyDereference() {
    let operations: [CHASHOperation] = [CHASH_Initialize, CHASH_Deinitialize, CHASH_SetConfiguration, CHASH_GetConfiguration,
      CHASH_Start, CHASH_StartInterrupt, CHASH_StartDMA, CHASH_Accumulate, CHASH_AccumulateLast,
      CHASH_AccumulateInterrupt, CHASH_AccumulateLastInterrupt, CHASH_HMACStart, CHASH_HMACAccumulate,
      CHASH_HMACAccumulateLast, CHASH_HMACStartInterrupt, CHASH_HMACAccumulateInterrupt,
      CHASH_HMACAccumulateLastInterrupt, CHASH_HMACStartDMA]
    for registered in [false, true] { for suspend in [false, true] {
      let fixture = HASHReferenceFixture(registered: registered, suspend: suspend, swift: false)
      for operation in operations { XCTAssertEqual(CHASH_RunNull(fixture.state, operation), 1) }
      XCTAssertEqual(fixture.state.pointee.accessCount, 0)
      XCTAssertEqual(fixture.state.pointee.callbackCount, 0)
    } }
  }
}
