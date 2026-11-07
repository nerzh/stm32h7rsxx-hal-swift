import XCTest
import CDTSReference
@testable import STM32H7RSHAL

private func dtsReferenceCallback(_ context: UnsafeMutableRawPointer?, _ id: UInt32, _ implementation: UInt32) {
  let fixture = Unmanaged<DTSReferenceFixture>.fromOpaque(context!).takeUnretainedValue()
  CDTS_EmitCallback(fixture.state, id, implementation)
}
private func dtsReferenceCallbackValue(_ id: UInt32, _ implementation: UInt32) -> DTSCallback? {
  if implementation == 0 { return nil }
  switch (id, implementation) {
  case (0, 1): return { context in dtsReferenceCallback(context, 0, 1) }
  case (0, 2): return { context in dtsReferenceCallback(context, 0, 2) }
  case (0, 3): return { context in dtsReferenceCallback(context, 0, 3) }
  case (1, 1): return { context in dtsReferenceCallback(context, 1, 1) }
  case (1, 2): return { context in dtsReferenceCallback(context, 1, 2) }
  case (1, 3): return { context in dtsReferenceCallback(context, 1, 3) }
  case (2, 1): return { context in dtsReferenceCallback(context, 2, 1) }
  case (2, 2): return { context in dtsReferenceCallback(context, 2, 2) }
  case (2, 3): return { context in dtsReferenceCallback(context, 2, 3) }
  case (3, 1): return { context in dtsReferenceCallback(context, 3, 1) }
  case (3, 2): return { context in dtsReferenceCallback(context, 3, 2) }
  case (3, 3): return { context in dtsReferenceCallback(context, 3, 3) }
  case (4, 1): return { context in dtsReferenceCallback(context, 4, 1) }
  case (4, 2): return { context in dtsReferenceCallback(context, 4, 2) }
  case (4, 3): return { context in dtsReferenceCallback(context, 4, 3) }
  case (5, 1): return { context in dtsReferenceCallback(context, 5, 1) }
  case (5, 2): return { context in dtsReferenceCallback(context, 5, 2) }
  case (5, 3): return { context in dtsReferenceCallback(context, 5, 3) }
  case (6, 1): return { context in dtsReferenceCallback(context, 6, 1) }
  case (6, 2): return { context in dtsReferenceCallback(context, 6, 2) }
  case (6, 3): return { context in dtsReferenceCallback(context, 6, 3) }
  case (7, 1): return { context in dtsReferenceCallback(context, 7, 1) }
  case (7, 2): return { context in dtsReferenceCallback(context, 7, 2) }
  case (7, 3): return { context in dtsReferenceCallback(context, 7, 3) }
  default: preconditionFailure("Invalid DTS fixture callback selector")
  }
}
private func dtsReferenceAction(_ context: UnsafeMutableRawPointer?, _ action: CDTSAction) {
  Unmanaged<DTSReferenceFixture>.fromOpaque(context!).takeUnretainedValue().apply(action)
}
private final class DTSReferenceFixture: DTSRegisterIO, DTSHandleIO, DTSCallbackIO, EXTIRegisterIO {
  let state = UnsafeMutablePointer<CDTSState>.allocate(capacity: 1)
  let registered: Bool
  init(registered: Bool, swift: Bool) {
    self.registered = registered
    CDTS_Reset(state, registered ? 1 : 0)
    if swift { CDTS_SetExecutionHook(state, context, dtsReferenceAction) }
  }
  deinit { state.deallocate() }
  var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
  var driver: DTS<DTSReferenceFixture, DTSReferenceFixture, DTSReferenceFixture> {
    .init(registers: self, handle: self, callbacks: self,
      defaults: .init(measureComplete: dtsReferenceCallbackValue(0, 1)!,
        asyncMeasureComplete: dtsReferenceCallbackValue(1, 1)!,
        lowThreshold: dtsReferenceCallbackValue(2, 1)!,
        asyncLowThreshold: dtsReferenceCallbackValue(3, 1)!,
        highThreshold: dtsReferenceCallbackValue(4, 1)!,
        asyncHighThreshold: dtsReferenceCallbackValue(5, 1)!,
        mspInitialize: dtsReferenceCallbackValue(6, 1)!,
        mspDeinitialize: dtsReferenceCallbackValue(7, 1)!), useRegisteredCallbacks: registered)
  }
  func read(_ register: DTSRegister) -> UInt32 {
    CDTS_Get(state, CDTSRegister(rawValue: UInt32(DTSRegister.allCases.firstIndex(of: register)!)))
  }
  func write(_ register: DTSRegister, value: UInt32) {
    CDTS_Write(state, CDTSRegister(rawValue: UInt32(DTSRegister.allCases.firstIndex(of: register)!)), value)
  }
  func read(_ word: DTSConfigurationWord) -> UInt32 { CDTS_GetWord(state, UInt32(word.rawValue)) }
  func write(_ word: DTSConfigurationWord, value: UInt32) { CDTS_SetWord(state, UInt32(word.rawValue), value) }
  func read(_ word: DTSHandleWord) -> UInt32 { CDTS_GetWord(state, 7 + UInt32(word.rawValue)) }
  func write(_ word: DTSHandleWord, value: UInt32) { CDTS_SetWord(state, 7 + UInt32(word.rawValue), value) }
  func read(_ id: DTSCallbackID) -> DTSCallback? { dtsReferenceCallbackValue(id.rawValue, CDTS_GetCallback(state, id.rawValue)) }
  func write(_ id: DTSCallbackID, value: DTSCallback?) {
    var selector: UInt32 = 0
    if let value {
      let bits = unsafeBitCast(value, to: UInt.self)
      selector = (UInt32(1)...3).first {
        unsafeBitCast(dtsReferenceCallbackValue(id.rawValue, $0)!, to: UInt.self) == bits
      }!
    }
    CDTS_SetCallback(state, id.rawValue, selector)
  }
  private func extiRegister(_ register: EXTIRegister) -> CDTSRegister {
    switch register {
    case .interruptMask(bank: 1): return CDTS_EXTI_IMR2
    case .eventMask(bank: 1): return CDTS_EXTI_EMR2
    default: preconditionFailure("DTS must use EXTI bank 1")
    }
  }
  func read(_ register: EXTIRegister) -> UInt32 { CDTS_Get(state, extiRegister(register)) }
  func write(_ register: EXTIRegister, value: UInt32) { CDTS_Write(state, extiRegister(register), value) }
  func apply(_ action: CDTSAction) {
    switch action.kind {
    case CDTS_ActionNone: break
    case CDTS_ActionRegister: CDTS_Set(state, CDTSRegister(rawValue: action.index), action.value)
    case CDTS_ActionWord: CDTS_SetWord(state, action.index, action.value)
    case CDTS_ActionCall:
      _ = run(CDTSOperation(rawValue: action.index), argument: action.argument, implementation: action.implementation)
    default: preconditionFailure("Unknown DTS fixture action")
    }
  }
  func run(_ operation: CDTSOperation, argument: UInt32 = 0, implementation: UInt32 = 0) -> UInt32 {
    let dts = driver
    switch operation {
    case CDTS_Initialize: return dts.initialize().rawValue
    case CDTS_Deinitialize: return dts.deinitialize().rawValue
    case CDTS_Start: return dts.start(getTick: { CDTS_Tick(self.state) }, delay: { CDTS_Delay(self.state, $0) }).rawValue
    case CDTS_Stop: return dts.stop().rawValue
    case CDTS_StartInterrupt: return dts.startInterrupt(getTick: { CDTS_Tick(self.state) }, delay: { CDTS_Delay(self.state, $0) }).rawValue
    case CDTS_StopInterrupt: return dts.stopInterrupt().rawValue
    case CDTS_GetTemperature:
      var output = state.pointee.temperature
      let status = dts.getTemperature(&output, getPCLK1Frequency: { self.state.pointee.pclk1 }, lseValue: state.pointee.lse)
      state.pointee.temperature = output
      return status.rawValue
    case CDTS_HandleInterrupt: dts.handleInterrupt(); return 0
    case CDTS_GetState: return dts.getState()
    case CDTS_RegisterCallback:
      return dts.registerCallback(id: argument, callback: dtsReferenceCallbackValue(argument < 8 ? argument : 0, implementation)).rawValue
    case CDTS_UnregisterCallback: return dts.unregisterCallback(id: argument).rawValue
    case CDTS_ResetHandleState: dts.resetHandleState(); return 0
    case CDTS_Enable: dts.enable(); return 0
    case CDTS_Disable: dts.disable(); return 0
    case CDTS_EnableInterrupts: dts.enableInterrupts(argument); return 0
    case CDTS_DisableInterrupts: dts.disableInterrupts(argument); return 0
    case CDTS_GetFlag: return dts.getFlag(argument)
    case CDTS_ClearFlag: dts.clearFlag(argument); return 0
    case CDTS_GetInterruptSource: return dts.getInterruptSource(argument)
    case CDTS_GetReferenceClock: return dts.getReferenceClock(argument)
    case CDTS_GetTrigger: return dts.getTrigger()
    case CDTS_EnableWakeupInterrupt: var io = self; dts.enableWakeupInterrupt(registers: &io); return 0
    case CDTS_DisableWakeupInterrupt: var io = self; dts.disableWakeupInterrupt(registers: &io); return 0
    case CDTS_EnableWakeupEvent: var io = self; dts.enableWakeupEvent(registers: &io); return 0
    case CDTS_DisableWakeupEvent: var io = self; dts.disableWakeupEvent(registers: &io); return 0
    default: preconditionFailure("Unknown DTS reference operation")
    }
  }
}
private final class DTSReferencePair {
  let reference: DTSReferenceFixture
  let actual: DTSReferenceFixture
  init(registered: Bool, setup: (UnsafeMutablePointer<CDTSState>) -> Void = { _ in }) {
    reference = .init(registered: registered, swift: false)
    actual = .init(registered: registered, swift: true)
    setup(reference.state); setup(actual.state)
  }
  func configureBoth(_ action: (UnsafeMutablePointer<CDTSState>) -> Void) {
    action(reference.state); action(actual.state)
  }
  func run(_ operation: CDTSOperation, argument: UInt32 = 0, implementation: UInt32 = 0,
           file: StaticString = #filePath, line: UInt = #line) {
    let expected = CDTS_Run(reference.state, operation, argument, implementation)
    let result = actual.run(operation, argument: argument, implementation: implementation)
    XCTAssertEqual(result, expected, "DTS operation \(operation.rawValue)", file: file, line: line)
    compare(file: file, line: line)
  }
  private func words<T>(_ value: T) -> [UInt32] {
    withUnsafeBytes(of: value) { Array($0.bindMemory(to: UInt32.self)) }
  }
  private func writes(_ state: UnsafeMutablePointer<CDTSState>) -> [[UInt32]] {
    (UInt32(0)..<state.pointee.accessCount).compactMap { index in
      let access = CDTS_GetAccess(state, index)
      // The original CLEAR_FLAG macro writes ICIFR directly, outside WRITE_REG.
      guard access.kind == 1 && access.reg != CDTS_ICIFR else { return nil }
      return [access.reg.rawValue, access.value, access.tickCall]
    }
  }
  func compare(file: StaticString = #filePath, line: UInt = #line) {
    let a = actual.state, b = reference.state
    XCTAssertEqual(words(CDTS_GetSnapshot(a)), words(CDTS_GetSnapshot(b)), "DTS final state", file: file, line: line)
    XCTAssertEqual(a.pointee.tick, b.pointee.tick, file: file, line: line)
    XCTAssertEqual(a.pointee.tickCalls, b.pointee.tickCalls, file: file, line: line)
    XCTAssertEqual(a.pointee.callbackCount, b.pointee.callbackCount, file: file, line: line)
    XCTAssertEqual(a.pointee.delayCount, b.pointee.delayCount, file: file, line: line)
    XCTAssertEqual(writes(a), writes(b), "DTS macro write order", file: file, line: line)
    for index in UInt32(0)..<min(a.pointee.callbackCount, b.pointee.callbackCount) {
      XCTAssertEqual(words(CDTS_GetCallbackEvent(a, index)), words(CDTS_GetCallbackEvent(b, index)),
        "DTS callback snapshot \(index)", file: file, line: line)
    }
    for index in UInt32(0)..<min(a.pointee.delayCount, b.pointee.delayCount) {
      XCTAssertEqual(words(CDTS_GetDelayEvent(a, index)), words(CDTS_GetDelayEvent(b, index)),
        "DTS delay snapshot \(index)", file: file, line: line)
    }
  }
}

final class DTSDifferentialTests: XCTestCase {
  private func registerAction(_ register: CDTSRegister, _ value: UInt32) -> CDTSAction {
    .init(kind: CDTS_ActionRegister, index: register.rawValue, value: value, argument: 0, implementation: 0)
  }
  private func wordAction(_ word: UInt32, _ value: UInt32) -> CDTSAction {
    .init(kind: CDTS_ActionWord, index: word, value: value, argument: 0, implementation: 0)
  }
  private func callAction(_ operation: CDTSOperation, argument: UInt32 = 0, implementation: UInt32 = 0) -> CDTSAction {
    .init(kind: CDTS_ActionCall, index: operation.rawValue, value: 0, argument: argument, implementation: implementation)
  }

  func testInitializationClockQuickMeasurementSamplingTriggersAndDividerMatrix() {
    for registered in [false, true] {
      for quick: UInt32 in [0, 0x200000] {
        for clock: UInt32 in [0, 0x100000] {
          for samples in UInt32(1)...15 {
            for trigger in UInt32(0)...4 {
              let pair = DTSReferencePair(registered: registered) { state in
                CDTS_SetWord(state, 0, quick)
                CDTS_SetWord(state, 1, clock)
                CDTS_SetWord(state, 2, trigger << 8)
                CDTS_SetWord(state, 3, samples << 16)
                CDTS_SetWord(state, 4, samples & 1 == 0 ? 127 : 0)
                CDTS_SetWord(state, 5, 0xFEDC)
                CDTS_SetWord(state, 6, 0x1234)
                CDTS_SetWord(state, 7, 1)
                CDTS_Set(state, CDTS_CFGR1, 0xFFFF_FFFF)
                CDTS_Set(state, CDTS_ITR1, 0x55AA_9966)
              }
              pair.run(CDTS_Initialize)
            }
          }
        }
      }
    }
  }

  func testInitializationChecksFullCalibrationRegistersAndLeavesBusyOnError() {
    for registered in [false, true] {
      for initialState in UInt32(0)...4 {
        for (ramp, calibration): (UInt32, UInt32) in [(0, 6000), (1000, 0), (0xFFFF0000, 0x40000000), (1000, 6000)] {
          let pair = DTSReferencePair(registered: registered) { state in
            CDTS_SetWord(state, 8, initialState)
            CDTS_SetWord(state, 7, 1)
            CDTS_Set(state, CDTS_RAMPVALR, ramp)
            CDTS_Set(state, CDTS_T0VALR1, calibration)
            CDTS_Set(state, CDTS_CFGR1, .max)
          }
          pair.run(CDTS_Initialize)
        }
      }
    }
  }

  func testMSPInitializationMutatesSharedConfigurationBeforeHardwareWrites() {
    for registered in [false, true] {
      for implementation in UInt32(0)...3 {
        let pair = DTSReferencePair(registered: registered) { state in
          for id in UInt32(0)..<8 { CDTS_SetCallback(state, id, 3) }
          CDTS_SetCallback(state, 6, implementation)
          CDTS_SetWord(state, 7, 1)
          CDTS_SetCallbackAction(state, 6, 0, self.wordAction(1, 0x100000))
          CDTS_SetCallbackAction(state, 6, 1, self.wordAction(0, 0x200000))
          // Divider is only asserted in the non-quick PCLK path in the C source.
          CDTS_SetCallbackAction(state, 6, 2, self.wordAction(4, 0xFF))
          CDTS_SetCallbackAction(state, 6, 3, self.wordAction(5, 0xAAAA))
        }
        pair.run(CDTS_Initialize)
      }
    }
  }

  func testDeinitializationPreservesConfigurationLockAndCallbackObservationOrder() {
    for registered in [false, true] {
      for initialState in UInt32(0)...4 {
        for implementation in UInt32(0)...3 {
          let pair = DTSReferencePair(registered: registered) { state in
            CDTS_SetWord(state, 8, initialState)
            CDTS_SetWord(state, 7, 1)
            CDTS_SetWord(state, 5, 1234)
            CDTS_Set(state, CDTS_CFGR1, .max)
            CDTS_Set(state, CDTS_ITR1, .max)
            CDTS_Set(state, CDTS_ITENR, .max)
            CDTS_SetCallback(state, 7, implementation)
            CDTS_SetCallbackAction(state, 7, 0, self.wordAction(8, 4))
            CDTS_SetCallbackAction(state, 7, 1, self.wordAction(6, 4321))
          }
          pair.run(CDTS_Deinitialize)
        }
      }
    }
  }

  func testStartStopStateClockAndHardwareTriggerSelections() {
    for registered in [false, true] {
      for stateValue in UInt32(0)...4 {
        for clock: UInt32 in [0, 0x100000] {
          for trigger in UInt32(0)...4 {
            for operation in [CDTS_Start, CDTS_StartInterrupt, CDTS_Stop, CDTS_StopInterrupt] {
              let pair = DTSReferencePair(registered: registered) { state in
                CDTS_SetWord(state, 8, stateValue)
                CDTS_SetWord(state, 7, 1)
                CDTS_SetWord(state, 1, clock)
                CDTS_SetWord(state, 2, trigger == 0 ? 0x100 : 0)
                CDTS_Set(state, CDTS_CFGR1, 0x8000_0011 | (trigger << 8) | (clock ^ 0x100000))
                CDTS_Set(state, CDTS_SR, 0x8000)
                CDTS_Set(state, CDTS_ITENR, 0xA5A5_0077)
              }
              pair.run(operation)
            }
          }
        }
      }
    }
  }

  func testStartupTimeoutStrictBoundaryAndWrapKeepBusyAndEnabled() {
    for operation in [CDTS_Start, CDTS_StartInterrupt] {
      for start: UInt32 in [0, .max - 1] {
        for arrival: UInt32 in [0, 2, 3] {
          let pair = DTSReferencePair(registered: true) { state in
            state.pointee.tick = start
            CDTS_SetWord(state, 8, 1)
            CDTS_SetWord(state, 7, 1)
            CDTS_SetWord(state, 1, 0x100000)
            if arrival != 0 { CDTS_ScheduleTick(state, arrival, self.registerAction(CDTS_SR, 0x8000)) }
          }
          pair.run(operation)
          XCTAssertEqual(CDTS_GetWord(pair.actual.state, 8), arrival == 2 ? 1 : 2)
          XCTAssertEqual(CDTS_Get(pair.actual.state, CDTS_CFGR1) & 1, 1)
          XCTAssertEqual(pair.actual.state.pointee.delayCount, arrival == 2 ? 1 : 0)
        }
      }
    }
  }

  func testDelaySeesBusyAndReentrantStopCannotInterruptStartup() {
    for operation in [CDTS_Start, CDTS_StartInterrupt] {
      let pair = DTSReferencePair(registered: false) { state in
        CDTS_SetWord(state, 8, 1)
        CDTS_Set(state, CDTS_SR, 0x8000)
        CDTS_SetDelayAction(state, self.callAction(CDTS_StopInterrupt))
      }
      pair.run(operation)
      XCTAssertEqual(CDTS_Get(pair.actual.state, CDTS_CFGR1) & 0x11, 0x11)
      XCTAssertEqual(pair.actual.state.pointee.delayCount, 1)
      XCTAssertEqual(CDTS_GetDelayEvent(pair.actual.state, 0).duration, 5)
    }
  }

  func testTemperaturePhysicalRangesSignedRoundingAndFactoryTemperatures() {
    for clock: UInt32 in [0, 0x100000] {
      for samples in UInt32(1)...15 {
        for measuredSamples: UInt32 in [1, 3, 80, 255, 1000, 32768, 65535] {
          for calibrationTemperature: UInt32 in [0, 1] {
            let pair = DTSReferencePair(registered: false) { state in
              CDTS_SetWord(state, 8, 1)
              CDTS_SetWord(state, 1, clock)
              CDTS_SetWord(state, 3, samples << 16)
              CDTS_Set(state, CDTS_DR, 0xABCD_0000 | measuredSamples)
              CDTS_Set(state, CDTS_T0VALR1, calibrationTemperature << 16 | 6000)
              CDTS_Set(state, CDTS_RAMPVALR, 0xABCD_03E8)
              state.pointee.temperature = -123456
            }
            pair.run(CDTS_GetTemperature)
          }
        }
      }
    }
  }

  func testTemperatureUnsignedMultiplicationWrapBeforeDivisionOnBothClocks() {
    for clock: UInt32 in [0, 0x100000] {
      for frequency: UInt32 in [0, 1, 65_537, 48_000_000, 0x8000_0000, .max] {
        for sampling: UInt32 in [1, 2, 15] {
          for samples: UInt32 in [1, 3, 65_535] {
            for calibration: UInt32 in [0, 6000] {
              let measured = clock == 0
                ? (frequency &* sampling) / samples
                : (frequency &* samples) / sampling
              let difference = Int64(Int32(bitPattern: measured)) - Int64(calibration * 100)
              // The original signed C subtraction is undefined outside Int32.
              guard difference >= Int64(Int32.min) && difference <= Int64(Int32.max) else { continue }
              let pair = DTSReferencePair(registered: true) { state in
                CDTS_SetWord(state, 8, 1)
                CDTS_SetWord(state, 1, clock)
                CDTS_SetWord(state, 3, sampling << 16)
                CDTS_Set(state, CDTS_DR, samples)
                CDTS_Set(state, CDTS_T0VALR1, 0x10000 | calibration)
                CDTS_Set(state, CDTS_RAMPVALR, 1000)
                state.pointee.pclk1 = frequency
                state.pointee.lse = frequency
                state.pointee.temperature = 0x12345678
              }
              pair.run(CDTS_GetTemperature)
            }
          }
        }
      }
    }
  }

  func testTemperatureErrorsPreserveOutputAndRestoreReadyOnlyAfterEntering() {
    for initialState in UInt32(0)...4 {
      for (sampling, samples, calibration, ramp): (UInt32, UInt32, UInt32, UInt32) in [
        (0, 80, 6000, 1000), (0x10000, 0, 6000, 1000),
        (0x10000, 80, 0x20000 | 6000, 1000), (0x10000, 80, 0x80010000 | 6000, 1000),
        (0x10000, 80, 6000, 0), (0x10000, 80, 6000, 0xFFFF0000),
      ] {
        let pair = DTSReferencePair(registered: false) { state in
          CDTS_SetWord(state, 8, initialState)
          CDTS_SetWord(state, 7, 1)
          CDTS_SetWord(state, 3, sampling)
          CDTS_Set(state, CDTS_DR, samples)
          CDTS_Set(state, CDTS_T0VALR1, calibration)
          CDTS_Set(state, CDTS_RAMPVALR, ramp)
          state.pointee.temperature = -987654
        }
        pair.run(CDTS_GetTemperature)
        XCTAssertEqual(pair.actual.state.pointee.temperature, -987654)
      }
    }
  }

  func testIRQAllFlagCombinationsIgnoreInterruptEnableAndKeepCallbackOrder() {
    let bits: [UInt32] = [1, 2, 4, 0x10, 0x20, 0x40]
    for registered in [false, true] {
      for combination: UInt32 in 0..<64 {
        for enables: UInt32 in [0, .max] {
          let flags = bits.enumerated().reduce(UInt32(0)) { $0 | ((combination & (1 << $1.offset)) != 0 ? $1.element : 0) }
          let pair = DTSReferencePair(registered: registered) { state in
            CDTS_SetWord(state, 8, 2)
            CDTS_Set(state, CDTS_SR, flags | 0x8000)
            CDTS_Set(state, CDTS_ITENR, enables)
            for id in UInt32(0)..<8 { CDTS_SetCallback(state, id, 2) }
          }
          pair.run(CDTS_HandleInterrupt)
        }
      }
    }
  }

  func testIRQReadsEachFlagAgainAfterCallbacksMutateSR() {
    let ids: [UInt32] = [1, 3, 5, 0, 2, 4]
    let flags: [UInt32] = [0x10, 0x20, 0x40, 1, 2, 4, 0]
    for registered in [false, true] {
      let pair = DTSReferencePair(registered: registered) { state in
        CDTS_Set(state, CDTS_SR, flags[0])
        for (index, id) in ids.enumerated() {
          CDTS_SetCallback(state, id, 3)
          CDTS_SetCallbackAction(state, id, 0, self.registerAction(CDTS_SR, flags[index + 1]))
          CDTS_SetCallbackAction(state, id, 1, self.wordAction(8, UInt32(index)))
        }
      }
      pair.run(CDTS_HandleInterrupt)
      XCTAssertEqual(pair.actual.state.pointee.callbackCount, 6)
      XCTAssertEqual((UInt32(0)..<6).map { CDTS_GetCallbackEvent(pair.actual.state, $0).callbackID }, ids)
    }
  }

  func testIRQRecursiveEntryConsumesActionsAndUsesFreshOuterFlags() {
    for registered in [false, true] {
      let pair = DTSReferencePair(registered: registered) { state in
        for id in UInt32(0)..<8 { CDTS_SetCallback(state, id, 1) }
        CDTS_Set(state, CDTS_SR, 0x10)
        CDTS_SetCallbackAction(state, 1, 0, self.registerAction(CDTS_SR, 4))
        CDTS_SetCallbackAction(state, 1, 1, self.callAction(CDTS_HandleInterrupt))
        CDTS_SetCallbackAction(state, 1, 2, self.registerAction(CDTS_SR, 0))
      }
      pair.run(CDTS_HandleInterrupt)
      XCTAssertEqual(pair.actual.state.pointee.callbackCount, 2)
      XCTAssertEqual(CDTS_GetCallbackEvent(pair.actual.state, 0).callbackID, 1)
      XCTAssertEqual(CDTS_GetCallbackEvent(pair.actual.state, 1).callbackID, 4)
    }
  }

  func testCallbackRegistrationStatesNilUnknownIDsAndResetMacro() {
    for stateValue in UInt32(0)...4 {
      for id: UInt32 in Array(0...8) + [UInt32.max] {
        for implementation in UInt32(0)...3 {
          let pair = DTSReferencePair(registered: true) { state in
            CDTS_SetWord(state, 8, stateValue)
            CDTS_SetWord(state, 7, 1)
            for callback in UInt32(0)..<8 { CDTS_SetCallback(state, callback, 3) }
          }
          pair.run(CDTS_RegisterCallback, argument: id, implementation: implementation)
          pair.run(CDTS_UnregisterCallback, argument: id)
          pair.run(CDTS_ResetHandleState)
        }
      }
    }
  }

  func testExportedRegisterMacrosIncludingEXTIBankQuirkAndZeroMasks() {
    for initial: UInt32 in [0, 0x8000_0555, .max] {
      for mask: UInt32 in [0, 1, 7, 0x70, 0x77, .max] {
        let pair = DTSReferencePair(registered: false) { state in
          CDTS_SetWord(state, 8, 4)
          for register in [CDTS_CFGR1, CDTS_SR, CDTS_ITENR, CDTS_EXTI_IMR2, CDTS_EXTI_EMR2] { CDTS_Set(state, register, initial) }
        }
        pair.run(CDTS_GetFlag, argument: mask)
        pair.run(CDTS_GetInterruptSource, argument: mask)
        pair.run(CDTS_GetReferenceClock, argument: mask)
        pair.run(CDTS_GetTrigger)
        pair.run(CDTS_GetState)
        pair.run(CDTS_ClearFlag, argument: mask)
        pair.run(CDTS_EnableInterrupts, argument: mask)
        pair.run(CDTS_DisableInterrupts, argument: mask)
        pair.run(CDTS_Enable)
        pair.run(CDTS_Disable)
        pair.run(CDTS_EnableWakeupInterrupt)
        pair.run(CDTS_DisableWakeupInterrupt)
        pair.run(CDTS_EnableWakeupEvent)
        pair.run(CDTS_DisableWakeupEvent)
        pair.run(CDTS_ResetHandleState)
      }
    }
  }

  func testSourceNullHandleGuardsWithoutMutatingFixture() {
    // Swift's value wrapper has no nullable handle; verify the C harness boundary.
    for registered in [false, true] {
      let pair = DTSReferencePair(registered: registered)
      for operation in [CDTS_Initialize, CDTS_Deinitialize, CDTS_Start, CDTS_Stop, CDTS_StartInterrupt, CDTS_StopInterrupt] {
        XCTAssertEqual(CDTS_RunNull(pair.reference.state, operation), 1)
        pair.compare()
      }
    }
  }
}
