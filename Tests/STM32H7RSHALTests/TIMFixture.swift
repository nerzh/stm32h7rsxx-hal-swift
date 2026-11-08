import CTIMReference
import XCTest

@testable import STM32H7RSHAL

final class TIMFixture: TIMRegisterIO, TIMHandleIO, TIMCallbackIO, TIMDMAIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(callbacks: Bool = true) {
    allocation = .allocate(byteCount: CTIM_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CTIM_Reset(state, callbacks ? 1 : 0)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  var instance: TIMInstance { TIMInstance.allCases[Int(control(0))] }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CTIM_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CTIM_Set(state, group, index, value)
  }
  func control(_ index: UInt32) -> UInt32 { get(2, index) }
  func control(_ index: UInt32, _ value: UInt32) { set(2, index, value) }
  func buffer(_ index: UInt32 = 0) -> UnsafeMutablePointer<UInt32> { CTIM_Buffer(state, index)! }
  func raw(_ register: TIMRegister) -> UInt32 { get(0, register.rawValue / 4) }
  func raw(_ register: TIMRegister, _ value: UInt32) { set(0, register.rawValue / 4, value) }
  func read(_ register: TIMRegister) -> UInt32 { CTIM_ReadRegister(state, register.rawValue) }
  func write(_ register: TIMRegister, value: UInt32) {
    CTIM_WriteRegister(state, register.rawValue, value)
  }
  func address(of register: TIMRegister) -> UInt32 { instance.rawValue + register.rawValue }
  func read(_ word: TIMConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: TIMConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: TIMHandleWord) -> UInt32 { get(1, 6 + UInt32(word.rawValue)) }
  func write(_ word: TIMHandleWord, value: UInt32) { set(1, 6 + UInt32(word.rawValue), value) }
  func readChannelState(_ index: Int, complementary: Bool) -> UInt32 {
    get(1, (complementary ? 16 : 10) + UInt32(index))
  }
  func writeChannelState(_ index: Int, complementary: Bool, value: UInt32) {
    set(1, (complementary ? 16 : 10) + UInt32(index), value)
  }
  func read(_ id: TIMCallbackID) -> TIMCallback? {
    let bits = CTIM_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: TIMCallback.self)
  }
  func write(_ id: TIMCallbackID, value: TIMCallback?) {
    CTIM_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: TIMCallbackDefaults {
    .init(
      baseMspInitialize: unsafeBitCast(CTIM_Callback(0, 1), to: TIMCallback.self),
      baseMspDeinitialize: unsafeBitCast(CTIM_Callback(1, 1), to: TIMCallback.self),
      inputCaptureMspInitialize: unsafeBitCast(CTIM_Callback(2, 1), to: TIMCallback.self),
      inputCaptureMspDeinitialize: unsafeBitCast(CTIM_Callback(3, 1), to: TIMCallback.self),
      outputCompareMspInitialize: unsafeBitCast(CTIM_Callback(4, 1), to: TIMCallback.self),
      outputCompareMspDeinitialize: unsafeBitCast(CTIM_Callback(5, 1), to: TIMCallback.self),
      pWMMspInitialize: unsafeBitCast(CTIM_Callback(6, 1), to: TIMCallback.self),
      pWMMspDeinitialize: unsafeBitCast(CTIM_Callback(7, 1), to: TIMCallback.self),
      onePulseMspInitialize: unsafeBitCast(CTIM_Callback(8, 1), to: TIMCallback.self),
      onePulseMspDeinitialize: unsafeBitCast(CTIM_Callback(9, 1), to: TIMCallback.self),
      encoderMspInitialize: unsafeBitCast(CTIM_Callback(10, 1), to: TIMCallback.self),
      encoderMspDeinitialize: unsafeBitCast(CTIM_Callback(11, 1), to: TIMCallback.self),
      hallSensorMspInitialize: unsafeBitCast(CTIM_Callback(12, 1), to: TIMCallback.self),
      hallSensorMspDeinitialize: unsafeBitCast(CTIM_Callback(13, 1), to: TIMCallback.self),
      periodElapsed: unsafeBitCast(CTIM_Callback(14, 1), to: TIMCallback.self),
      periodElapsedHalfComplete: unsafeBitCast(CTIM_Callback(15, 1), to: TIMCallback.self),
      trigger: unsafeBitCast(CTIM_Callback(16, 1), to: TIMCallback.self),
      triggerHalfComplete: unsafeBitCast(CTIM_Callback(17, 1), to: TIMCallback.self),
      inputCaptureCapture: unsafeBitCast(CTIM_Callback(18, 1), to: TIMCallback.self),
      inputCaptureCaptureHalfComplete: unsafeBitCast(CTIM_Callback(19, 1), to: TIMCallback.self),
      outputCompareDelayElapsed: unsafeBitCast(CTIM_Callback(20, 1), to: TIMCallback.self),
      pWMPulseFinished: unsafeBitCast(CTIM_Callback(21, 1), to: TIMCallback.self),
      pWMPulseFinishedHalfComplete: unsafeBitCast(CTIM_Callback(22, 1), to: TIMCallback.self),
      error: unsafeBitCast(CTIM_Callback(23, 1), to: TIMCallback.self),
      commutation: unsafeBitCast(CTIM_Callback(24, 1), to: TIMCallback.self),
      commutationHalfComplete: unsafeBitCast(CTIM_Callback(25, 1), to: TIMCallback.self),
      breakEvent: unsafeBitCast(CTIM_Callback(26, 1), to: TIMCallback.self),
      break2: unsafeBitCast(CTIM_Callback(27, 1), to: TIMCallback.self),
      encoderIndex: unsafeBitCast(CTIM_Callback(28, 1), to: TIMCallback.self),
      directionChange: unsafeBitCast(CTIM_Callback(29, 1), to: TIMCallback.self),
      indexError: unsafeBitCast(CTIM_Callback(30, 1), to: TIMCallback.self),
      transitionError: unsafeBitCast(CTIM_Callback(31, 1), to: TIMCallback.self))
  }
  var driver: TIM<TIMFixture, TIMFixture, TIMFixture, TIMFixture> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: control(63) != 0)
  }
  func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, _ d: UInt32 = 0)
    -> UInt32
  {
    CTIM_Activate(state)
    switch op {
    case 0: return driver.baseInitialize().rawValue
    case 1: return driver.baseDeinitialize().rawValue
    case 2: return driver.baseStart().rawValue
    case 3: return driver.baseStop().rawValue
    case 4: return driver.baseStartInterrupt().rawValue
    case 5: return driver.baseStopInterrupt().rawValue
    case 6:
      return driver.baseStartDMA(
        control(13) != 0 ? nil : UnsafePointer(buffer(0)), UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 7: return driver.baseStopDMA().rawValue
    case 8: return driver.outputCompareInitialize().rawValue
    case 9: return driver.outputCompareDeinitialize().rawValue
    case 10: return driver.outputCompareStart(a).rawValue
    case 11: return driver.outputCompareStop(a).rawValue
    case 12: return driver.outputCompareStartInterrupt(a).rawValue
    case 13: return driver.outputCompareStopInterrupt(a).rawValue
    case 14:
      return driver.outputCompareStartDMA(
        a, control(13) != 0 ? nil : UnsafePointer(buffer(0)), UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 15: return driver.outputCompareStopDMA(a).rawValue
    case 16: return driver.pwmInitialize().rawValue
    case 17: return driver.pwmDeinitialize().rawValue
    case 18: return driver.pwmStart(a).rawValue
    case 19: return driver.pwmStop(a).rawValue
    case 20: return driver.pwmStartInterrupt(a).rawValue
    case 21: return driver.pwmStopInterrupt(a).rawValue
    case 22:
      return driver.pwmStartDMA(
        a, control(13) != 0 ? nil : UnsafePointer(buffer(0)), UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 23: return driver.pwmStopDMA(a).rawValue
    case 24: return driver.inputCaptureInitialize().rawValue
    case 25: return driver.inputCaptureDeinitialize().rawValue
    case 26: return driver.inputCaptureStart(a).rawValue
    case 27: return driver.inputCaptureStop(a).rawValue
    case 28: return driver.inputCaptureStartInterrupt(a).rawValue
    case 29: return driver.inputCaptureStopInterrupt(a).rawValue
    case 30:
      return driver.inputCaptureStartDMA(
        a, control(13) != 0 ? nil : buffer(0), UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 31: return driver.inputCaptureStopDMA(a).rawValue
    case 32: return driver.onePulseInitialize(a).rawValue
    case 33: return driver.onePulseDeinitialize().rawValue
    case 34: return driver.onePulseStart(a).rawValue
    case 35: return driver.onePulseStop(a).rawValue
    case 36: return driver.onePulseStartInterrupt(a).rawValue
    case 37: return driver.onePulseStopInterrupt(a).rawValue
    case 38:
      return driver.encoderInitialize(
        .init(
          encoderMode: get(3, 0), inputCapture1Polarity: get(3, 1),
          inputCapture1Selection: get(3, 2), inputCapture1Prescaler: get(3, 3),
          inputCapture1Filter: get(3, 4), inputCapture2Polarity: get(3, 5),
          inputCapture2Selection: get(3, 6), inputCapture2Prescaler: get(3, 7),
          inputCapture2Filter: get(3, 8))
      ).rawValue
    case 39: return driver.encoderDeinitialize().rawValue
    case 40: return driver.encoderStart(a).rawValue
    case 41: return driver.encoderStop(a).rawValue
    case 42: return driver.encoderStartInterrupt(a).rawValue
    case 43: return driver.encoderStopInterrupt(a).rawValue
    case 44:
      return driver.encoderStartDMA(
        a, control(13) != 0 ? nil : buffer(0), control(15) != 0 ? nil : buffer(1),
        UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 45: return driver.encoderStopDMA(a).rawValue
    case 46:
      driver.interruptHandler()
      return 0
    case 47:
      return driver.outputCompareConfigureChannel(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareFastMode: get(3, 4),
          outputCompareIdleState: get(3, 5), outputCompareNIdleState: get(3, 6)), a
      ).rawValue
    case 48:
      return driver.inputCaptureConfigureChannel(
        .init(
          inputCapturePolarity: get(3, 0), inputCaptureSelection: get(3, 1),
          inputCapturePrescaler: get(3, 2), inputCaptureFilter: get(3, 3)), a
      ).rawValue
    case 49:
      return driver.pwmConfigureChannel(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareFastMode: get(3, 4),
          outputCompareIdleState: get(3, 5), outputCompareNIdleState: get(3, 6)), a
      ).rawValue
    case 50:
      return driver.onePulseConfigureChannel(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareIdleState: get(3, 4),
          outputCompareNIdleState: get(3, 5), inputCapturePolarity: get(3, 6),
          inputCaptureSelection: get(3, 7), inputCaptureFilter: get(3, 8)), a, b
      ).rawValue
    case 51:
      return driver.dmaBurstWriteStart(a, b, control(13) != 0 ? nil : UnsafePointer(buffer(0)), c)
        .rawValue
    case 52:
      return driver.dmaBurstMultiWriteStart(
        a, b, control(13) != 0 ? nil : UnsafePointer(buffer(0)), c, d
      ).rawValue
    case 53: return driver.dmaBurstWriteStop(a).rawValue
    case 54: return driver.dmaBurstReadStart(a, b, control(13) != 0 ? nil : buffer(0), c).rawValue
    case 55:
      return driver.dmaBurstMultiReadStart(a, b, control(13) != 0 ? nil : buffer(0), c, d).rawValue
    case 56: return driver.dmaBurstReadStop(a).rawValue
    case 57: return driver.generateEvent(a).rawValue
    case 58:
      return driver.configOCrefClear(
        .init(
          clearInputState: get(3, 0), clearInputSource: get(3, 1), clearInputPolarity: get(3, 2),
          clearInputPrescaler: get(3, 3), clearInputFilter: get(3, 4)), a
      ).rawValue
    case 59:
      return driver.configClockSource(
        .init(
          clockSource: get(3, 0), clockPolarity: get(3, 1), clockPrescaler: get(3, 2),
          clockFilter: get(3, 3))
      ).rawValue
    case 60: return driver.configTI1Input(a).rawValue
    case 61:
      return driver.slaveConfigSynchro(
        .init(
          slaveMode: get(3, 0), inputTrigger: get(3, 1), triggerPolarity: get(3, 2),
          triggerPrescaler: get(3, 3), triggerFilter: get(3, 4))
      ).rawValue
    case 62:
      return driver.slaveConfigSynchroInterrupt(
        .init(
          slaveMode: get(3, 0), inputTrigger: get(3, 1), triggerPolarity: get(3, 2),
          triggerPrescaler: get(3, 3), triggerFilter: get(3, 4))
      ).rawValue
    case 63: return driver.readCapturedValue(a)
    case 64:
      return driver.dmaStartInterrupt(TIMDMAChannel(rawValue: control(30))!, a, b, c).rawValue
    case 65:
      return driver.registerCallback(
        a, b == 0 ? nil : unsafeBitCast(CTIM_Callback(a < 32 ? a : 0, b), to: TIMCallback.self)
      ).rawValue
    case 66: return driver.unregisterCallback(a).rawValue
    case 67: return driver.baseGetState()
    case 68: return driver.outputCompareGetState()
    case 69: return driver.pwmGetState()
    case 70: return driver.inputCaptureGetState()
    case 71: return driver.onePulseGetState()
    case 72: return driver.encoderGetState()
    case 73: return driver.getActiveChannel()
    case 74: return driver.getChannelState(a)
    case 75: return driver.dmaBurstState()
    case 76:
      driver.dmaError(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 77:
      driver.dmaDelayPulseCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 78:
      driver.dmaDelayPulseHalfCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 79:
      driver.dmaCaptureCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 80:
      driver.dmaCaptureHalfCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 81:
      driver.dmaPeriodElapsedCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 82:
      driver.dmaPeriodElapsedHalfCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 83:
      driver.dmaTriggerCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 84:
      driver.dmaTriggerHalfCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 85:
      driver.baseSetConfig(
        .init(
          prescaler: get(3, 0), counterMode: get(3, 1), period: get(3, 2), clockDivision: get(3, 3),
          repetitionCounter: get(3, 4), autoReloadPreload: get(3, 5)))
      return 0
    case 86:
      driver.oc1SetConfig(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareFastMode: get(3, 4),
          outputCompareIdleState: get(3, 5), outputCompareNIdleState: get(3, 6)))
      return 0
    case 87:
      driver.oc2SetConfig(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareFastMode: get(3, 4),
          outputCompareIdleState: get(3, 5), outputCompareNIdleState: get(3, 6)))
      return 0
    case 88:
      driver.oc3SetConfig(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareFastMode: get(3, 4),
          outputCompareIdleState: get(3, 5), outputCompareNIdleState: get(3, 6)))
      return 0
    case 89:
      driver.oc4SetConfig(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareFastMode: get(3, 4),
          outputCompareIdleState: get(3, 5), outputCompareNIdleState: get(3, 6)))
      return 0
    case 90:
      driver.oc5SetConfig(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareFastMode: get(3, 4),
          outputCompareIdleState: get(3, 5), outputCompareNIdleState: get(3, 6)))
      return 0
    case 91:
      driver.oc6SetConfig(
        .init(
          outputCompareMode: get(3, 0), pulse: get(3, 1), outputComparePolarity: get(3, 2),
          outputCompareNPolarity: get(3, 3), outputCompareFastMode: get(3, 4),
          outputCompareIdleState: get(3, 5), outputCompareNIdleState: get(3, 6)))
      return 0
    case 92:
      return driver.slaveTimerSetConfig(
        .init(
          slaveMode: get(3, 0), inputTrigger: get(3, 1), triggerPolarity: get(3, 2),
          triggerPrescaler: get(3, 3), triggerFilter: get(3, 4))
      ).rawValue
    case 93:
      driver.ti1SetConfig(a, b, c)
      return 0
    case 94:
      driver.ti1ConfigInputStage(a, b)
      return 0
    case 95:
      driver.ti2SetConfig(a, b, c)
      return 0
    case 96:
      driver.ti2ConfigInputStage(a, b)
      return 0
    case 97:
      driver.ti3SetConfig(a, b, c)
      return 0
    case 98:
      driver.ti4SetConfig(a, b, c)
      return 0
    case 99:
      driver.iTRxSetConfig(a)
      return 0
    case 100:
      driver.etrSetConfig(a, b, c)
      return 0
    case 101:
      driver.ccxChannelCmd(a, b)
      return 0
    case 102:
      driver.resetCallback()
      return 0
    case 103:
      return driver.hallSensorInitialize(
        .init(
          inputCapture1Polarity: get(3, 0), inputCapture1Prescaler: get(3, 1),
          inputCapture1Filter: get(3, 2), commutationDelay: get(3, 3))
      ).rawValue
    case 104: return driver.hallSensorDeinitialize().rawValue
    case 105: return driver.hallSensorStart().rawValue
    case 106: return driver.hallSensorStop().rawValue
    case 107: return driver.hallSensorStartInterrupt().rawValue
    case 108: return driver.hallSensorStopInterrupt().rawValue
    case 109:
      return driver.hallSensorStartDMA(
        control(13) != 0 ? nil : buffer(0), UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 110: return driver.hallSensorStopDMA().rawValue
    case 111: return driver.outputCompareNStart(a).rawValue
    case 112: return driver.outputCompareNStop(a).rawValue
    case 113: return driver.outputCompareNStartInterrupt(a).rawValue
    case 114: return driver.outputCompareNStopInterrupt(a).rawValue
    case 115:
      return driver.outputCompareNStartDMA(
        a, control(13) != 0 ? nil : UnsafePointer(buffer(0)), UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 116: return driver.outputCompareNStopDMA(a).rawValue
    case 117: return driver.pwmNStart(a).rawValue
    case 118: return driver.pwmNStop(a).rawValue
    case 119: return driver.pwmNStartInterrupt(a).rawValue
    case 120: return driver.pwmNStopInterrupt(a).rawValue
    case 121:
      return driver.pwmNStartDMA(
        a, control(13) != 0 ? nil : UnsafePointer(buffer(0)), UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 122: return driver.pwmNStopDMA(a).rawValue
    case 123: return driver.onePulseNStart(a).rawValue
    case 124: return driver.onePulseNStop(a).rawValue
    case 125: return driver.onePulseNStartInterrupt(a).rawValue
    case 126: return driver.onePulseNStopInterrupt(a).rawValue
    case 127: return driver.configCommutEvent(a, b).rawValue
    case 128: return driver.configCommutEventInterrupt(a, b).rawValue
    case 129: return driver.configCommutEventDMA(a, b).rawValue
    case 130:
      return driver.masterConfigSynchronization(
        .init(
          masterOutputTrigger: get(3, 0), masterOutputTrigger2: get(3, 1),
          masterSlaveMode: get(3, 2))
      ).rawValue
    case 131:
      return driver.configBreakDeadTime(
        .init(
          offStateRunMode: get(3, 0), offStateIdleMode: get(3, 1), lockLevel: get(3, 2),
          deadTime: get(3, 3), breakState: get(3, 4), breakPolarity: get(3, 5),
          breakFilter: get(3, 6), breakAFMode: get(3, 7), break2State: get(3, 8),
          break2Polarity: get(3, 9), break2Filter: get(3, 10), break2AFMode: get(3, 11),
          automaticOutput: get(3, 12))
      ).rawValue
    case 132:
      return driver.configBreakInput(
        a, .init(source: get(3, 0), enable: get(3, 1), polarity: get(3, 2))
      ).rawValue
    case 133: return driver.remapConfig(a).rawValue
    case 134: return driver.tiSelection(a, b).rawValue
    case 135: return driver.groupChannel5(a).rawValue
    case 136: return driver.disarmBreakInput(a).rawValue
    case 137: return driver.reArmBreakInput(a, getTick: { CTIM_TickFor(self.state) }).rawValue
    case 138: return driver.ditheringEnable().rawValue
    case 139: return driver.ditheringDisable().rawValue
    case 140: return driver.outputCompareConfigPulseOnCompare(a, b).rawValue
    case 141: return driver.configSlaveModePreload(a).rawValue
    case 142: return driver.enableSlaveModePreload().rawValue
    case 143: return driver.disableSlaveModePreload().rawValue
    case 144: return driver.enableDeadTimePreload().rawValue
    case 145: return driver.disableDeadTimePreload().rawValue
    case 146: return driver.configDeadTime(a).rawValue
    case 147: return driver.configAsymmetricalDeadTime(a).rawValue
    case 148: return driver.enableAsymmetricalDeadTime().rawValue
    case 149: return driver.disableAsymmetricalDeadTime().rawValue
    case 150:
      return driver.configEncoderIndex(
        .init(
          polarity: get(3, 0), prescaler: get(3, 1), filter: get(3, 2), blanking: get(3, 3),
          firstIndexEnable: get(3, 4), position: get(3, 5), direction: get(3, 6))
      ).rawValue
    case 151: return driver.enableEncoderIndex().rawValue
    case 152: return driver.disableEncoderIndex().rawValue
    case 153: return driver.enableEncoderFirstIndex().rawValue
    case 154: return driver.disableEncoderFirstIndex().rawValue
    case 155: return driver.hallSensorGetState()
    case 156: return driver.getChannelNState(a)
    case 157:
      driver.dmaCommutationCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 158:
      driver.dmaCommutationHalfCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 159:
      driver.dmaDelayPulseNCplt(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 160:
      driver.dmaErrorCCxN(
        sourceContext: UnsafeMutableRawPointer(bitPattern: CTIM_DMAContext(state, control(30))))
      return 0
    case 161:
      driver.ccxNChannelCmd(a, b)
      return 0
    case 200:
      driver.resetHandleState()
      return 0
    case 201:
      driver.enable()
      return 0
    case 202:
      driver.disable()
      return 0
    case 203:
      driver.enableMainOutput()
      return 0
    case 204:
      driver.disableMainOutput()
      return 0
    case 205:
      driver.disableMainOutputUnconditionally()
      return 0
    case 206:
      driver.enableInterrupts(a)
      return 0
    case 207:
      driver.disableInterrupts(a)
      return 0
    case 208:
      driver.enableDMARequests(a)
      return 0
    case 209:
      driver.disableDMARequests(a)
      return 0
    case 210: return driver.getFlag(a) ? 1 : 0
    case 211:
      driver.clearFlag(a)
      return 0
    case 212: return driver.getInterruptSource(a) ? 1 : 0
    case 213:
      driver.clearInterrupt(a)
      return 0
    case 214:
      driver.enableUpdateFlagRemap()
      return 0
    case 215:
      driver.disableUpdateFlagRemap()
      return 0
    case 216: return driver.isCountingDown() ? 1 : 0
    case 217:
      driver.setPrescaler(a)
      return 0
    case 218:
      driver.setCounter(a)
      return 0
    case 219: return driver.getCounter()
    case 220:
      driver.setAutoReload(a)
      return 0
    case 221: return driver.getAutoReload()
    case 222:
      driver.setClockDivision(a)
      return 0
    case 223: return driver.getClockDivision()
    case 224:
      driver.setInputCapturePrescaler(a, b)
      return 0
    case 225: return driver.getInputCapturePrescaler(a)
    case 226:
      driver.setCompare(a, b)
      return 0
    case 227: return driver.getCompare(a)
    case 228:
      driver.enableOutputComparePreload(a)
      return 0
    case 229:
      driver.disableOutputComparePreload(a)
      return 0
    case 230:
      driver.enableOutputCompareFast(a)
      return 0
    case 231:
      driver.disableOutputCompareFast(a)
      return 0
    case 232:
      driver.enableUpdateRequestSource()
      return 0
    case 233:
      driver.disableUpdateRequestSource()
      return 0
    case 234:
      driver.setCapturePolarity(a, b)
      return 0
    case 235:
      driver.selectCaptureCompareDMARequest(a)
      return 0
    case 300: return TIMCalculations.updateFlagCopy(a) ? 1 : 0
    case 301: return TIMCalculations.prescaler(a, b)
    case 302: return TIMCalculations.period(a, b, c)
    case 303: return TIMCalculations.periodDither(a, b, c)
    case 304: return TIMCalculations.pulse(a, b, c)
    case 305: return TIMCalculations.pulseDither(a, b, c)
    case 306: return TIMCalculations.periodByDelay(a, b, c, d)
    case 307: return TIMCalculations.periodDitherByDelay(a, b, c, d)
    default: preconditionFailure("Unknown TIM operation")
    }
  }
  func attached(_ channel: TIMDMAChannel) -> UInt32 { CTIM_AttachedDMA(state, channel.rawValue) }
  func attach(_ channel: TIMDMAChannel, _ index: UInt32?) {
    CTIM_AttachDMA(state, channel.rawValue, index ?? UInt32.max)
  }
  func dmaSetting(_ index: UInt32, _ word: UInt32) -> UInt32 { CTIM_GetDMA(state, index, word) }
  func dmaSetting(_ index: UInt32, _ word: UInt32, _ value: UInt32) {
    CTIM_SetDMA(state, index, word, value)
  }
  func isPresent(_ channel: TIMDMAChannel) -> Bool { attached(channel) != UInt32.max }
  func matches(_ channel: TIMDMAChannel, context: UnsafeMutableRawPointer?) -> Bool {
    isPresent(channel) && UInt(bitPattern: context) == CTIM_DMAContext(state, attached(channel))
  }
  func read(_ channel: TIMDMAChannel, word: DMAHandleWord) -> UInt32 {
    let d = attached(channel)
    switch word {
    case .mode: return dmaSetting(d, 0)
    case .queueAddress: return dmaSetting(d, 2) == 0 ? 0 : 0x2400_1000 + d * 0x100
    default: preconditionFailure("Unexpected DMA field")
    }
  }
  func readSourceDataWidth(_ channel: TIMDMAChannel) -> UInt32 { dmaSetting(attached(channel), 1) }
  func readMemory32(_ channel: TIMDMAChannel, at address: UInt32) -> UInt32 {
    let d = attached(channel)
    let queue: UInt32 = 0x2400_1000 + d * 0x100
    if address == queue { return dmaSetting(d, 3) == 0 ? 0 : queue + 0x40 }
    return get(10 + d, (address - queue - 0x40) / 4)
  }
  func writeMemory32(_ channel: TIMDMAChannel, at address: UInt32, value: UInt32) {
    let d = attached(channel)
    let node: UInt32 = 0x2400_1040 + d * 0x100
    set(10 + d, (address - node) / 4, value)
  }
  func callback(_ kind: TIMDMACallbackKind) -> DMACallback {
    switch kind {
    case .error: return timFixtureDMA_error
    case .delayPulseComplete: return timFixtureDMA_delayPulseComplete
    case .delayPulseHalfComplete: return timFixtureDMA_delayPulseHalfComplete
    case .captureComplete: return timFixtureDMA_captureComplete
    case .captureHalfComplete: return timFixtureDMA_captureHalfComplete
    case .periodElapsedComplete: return timFixtureDMA_periodElapsedComplete
    case .periodElapsedHalfComplete: return timFixtureDMA_periodElapsedHalfComplete
    case .triggerComplete: return timFixtureDMA_triggerComplete
    case .triggerHalfComplete: return timFixtureDMA_triggerHalfComplete
    case .commutationComplete: return timFixtureDMA_commutationComplete
    case .commutationHalfComplete: return timFixtureDMA_commutationHalfComplete
    case .delayPulseNComplete: return timFixtureDMA_delayPulseNComplete
    case .errorCCxN: return timFixtureDMA_errorCCxN
    }
  }
  func writeCallback(_ channel: TIMDMAChannel, id: DMACallbackID, value: DMACallback?) {
    var code: UInt32 = 0
    if let value {
      let bits = unsafeBitCast(value, to: UInt.self)
      for kind in TIMDMACallbackKind.allCases {
        if bits == unsafeBitCast(callback(kind), to: UInt.self) {
          code = kind.rawValue + 1
          break
        }
      }
      precondition(code != 0)
    }
    CTIM_SetDMACallback(state, attached(channel), UInt32(id.rawValue), code)
  }
  func startInterrupt(
    _ channel: TIMDMAChannel, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CTIM_RecordDMA(
        state, attached(channel), 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt(_ channel: TIMDMAChannel) -> HALStatus {
    HALStatus(rawValue: CTIM_RecordDMA(state, attached(channel), 1, 0, 0, 0))!
  }
  func abortInterrupt(_ channel: TIMDMAChannel) -> HALStatus {
    HALStatus(rawValue: CTIM_RecordDMA(state, attached(channel), 2, 0, 0, 0))!
  }
}
private func timFixtureDMA_error(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_delayPulseComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_delayPulseHalfComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_captureComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_captureHalfComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_periodElapsedComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_periodElapsedHalfComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_triggerComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_triggerHalfComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_commutationComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_commutationHalfComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_delayPulseNComplete(_ context: UnsafeMutableRawPointer?) {}
private func timFixtureDMA_errorCCxN(_ context: UnsafeMutableRawPointer?) {}

struct TIMPair {
  let swift: TIMFixture
  let c: TIMFixture
  init(callbacks: Bool = true) {
    swift = TIMFixture(callbacks: callbacks)
    c = TIMFixture(callbacks: callbacks)
  }
  func setup(_ body: (TIMFixture) -> Void) {
    body(swift)
    body(c)
  }
  @discardableResult func verify(
    _ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, _ d: UInt32 = 0,
    file: StaticString = #filePath, line: UInt = #line
  ) -> UInt32 {
    let expected = CTIM_Run(self.c.state, op, a, b, c, d)
    let actual = swift.run(op, a, b, c, d)
    XCTAssertEqual(
      actual, expected, "operation \(op), args \(a),\(b),\(c),\(d)", file: file, line: line)
    if op >= 200 {
      for f in [swift, self.c] {
        f.control(23, 0)
        for i: UInt32 in 0..<2048 { f.set(6, i, 0) }
      }
    }
    let difference = CTIM_Compare(swift.state, self.c.state)
    if difference != 0 {
      let g = difference / 0x1000 - 1
      let i = difference % 0x1000
      let details =
        g < 7
        ? "group \(g) index \(i): Swift \(swift.get(g,i)), C \(self.c.get(g,i))"
        : "DMA or callback difference"
      XCTFail(
        "operation \(op): difference 0x\(String(difference,radix:16)), \(details)", file: file,
        line: line)
    }
    return actual
  }
}
