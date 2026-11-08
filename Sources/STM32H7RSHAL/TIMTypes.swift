// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum TIMRegister: UInt32, CaseIterable {
  case cr1 = 0
  case cr2 = 4
  case smcr = 8
  case dier = 12
  case sr = 16
  case egr = 20
  case ccmr1 = 24
  case ccmr2 = 28
  case ccer = 32
  case cnt = 36
  case psc = 40
  case arr = 44
  case rcr = 48
  case ccr1 = 52
  case ccr2 = 56
  case ccr3 = 60
  case ccr4 = 64
  case bdtr = 68
  case ccr5 = 72
  case ccr6 = 76
  case ccmr3 = 80
  case dtr2 = 84
  case ecr = 88
  case tisel = 92
  case af1 = 96
  case af2 = 100
  case dcr = 988
  case dmar = 992
}
public enum TIMInstance: UInt32, CaseIterable {
  case tim1 = 1_107_296_256
  case tim2 = 1_073_741_824
  case tim3 = 1_073_742_848
  case tim4 = 1_073_743_872
  case tim5 = 1_073_744_896
  case tim6 = 1_073_745_920
  case tim7 = 1_073_746_944
  case tim9 = 1_107_315_712
  case tim12 = 1_073_747_968
  case tim13 = 1_073_748_992
  case tim14 = 1_073_750_016
  case tim15 = 1_107_312_640
  case tim16 = 1_107_313_664
  case tim17 = 1_107_314_688
}
public protocol TIMRegisterIO {
  var instance: TIMInstance { get }
  func read(_ register: TIMRegister) -> UInt32
  func write(_ register: TIMRegister, value: UInt32)
  func address(of register: TIMRegister) -> UInt32
}
public struct TIMBaseConfiguration: Equatable, Sendable {
  public var prescaler: UInt32
  public var counterMode: UInt32
  public var period: UInt32
  public var clockDivision: UInt32
  public var repetitionCounter: UInt32
  public var autoReloadPreload: UInt32
  public init(
    prescaler: UInt32 = 0, counterMode: UInt32 = 0, period: UInt32 = 0, clockDivision: UInt32 = 0,
    repetitionCounter: UInt32 = 0, autoReloadPreload: UInt32 = 0
  ) {
    self.prescaler = prescaler
    self.counterMode = counterMode
    self.period = period
    self.clockDivision = clockDivision
    self.repetitionCounter = repetitionCounter
    self.autoReloadPreload = autoReloadPreload
  }
}
public struct TIMOutputCompareConfiguration: Equatable, Sendable {
  public var outputCompareMode: UInt32
  public var pulse: UInt32
  public var outputComparePolarity: UInt32
  public var outputCompareNPolarity: UInt32
  public var outputCompareFastMode: UInt32
  public var outputCompareIdleState: UInt32
  public var outputCompareNIdleState: UInt32
  public init(
    outputCompareMode: UInt32 = 0, pulse: UInt32 = 0, outputComparePolarity: UInt32 = 0,
    outputCompareNPolarity: UInt32 = 0, outputCompareFastMode: UInt32 = 0,
    outputCompareIdleState: UInt32 = 0, outputCompareNIdleState: UInt32 = 0
  ) {
    self.outputCompareMode = outputCompareMode
    self.pulse = pulse
    self.outputComparePolarity = outputComparePolarity
    self.outputCompareNPolarity = outputCompareNPolarity
    self.outputCompareFastMode = outputCompareFastMode
    self.outputCompareIdleState = outputCompareIdleState
    self.outputCompareNIdleState = outputCompareNIdleState
  }
}
public struct TIMOnePulseConfiguration: Equatable, Sendable {
  public var outputCompareMode: UInt32
  public var pulse: UInt32
  public var outputComparePolarity: UInt32
  public var outputCompareNPolarity: UInt32
  public var outputCompareIdleState: UInt32
  public var outputCompareNIdleState: UInt32
  public var inputCapturePolarity: UInt32
  public var inputCaptureSelection: UInt32
  public var inputCaptureFilter: UInt32
  public init(
    outputCompareMode: UInt32 = 0, pulse: UInt32 = 0, outputComparePolarity: UInt32 = 0,
    outputCompareNPolarity: UInt32 = 0, outputCompareIdleState: UInt32 = 0,
    outputCompareNIdleState: UInt32 = 0, inputCapturePolarity: UInt32 = 0,
    inputCaptureSelection: UInt32 = 0, inputCaptureFilter: UInt32 = 0
  ) {
    self.outputCompareMode = outputCompareMode
    self.pulse = pulse
    self.outputComparePolarity = outputComparePolarity
    self.outputCompareNPolarity = outputCompareNPolarity
    self.outputCompareIdleState = outputCompareIdleState
    self.outputCompareNIdleState = outputCompareNIdleState
    self.inputCapturePolarity = inputCapturePolarity
    self.inputCaptureSelection = inputCaptureSelection
    self.inputCaptureFilter = inputCaptureFilter
  }
}
public struct TIMInputCaptureConfiguration: Equatable, Sendable {
  public var inputCapturePolarity: UInt32
  public var inputCaptureSelection: UInt32
  public var inputCapturePrescaler: UInt32
  public var inputCaptureFilter: UInt32
  public init(
    inputCapturePolarity: UInt32 = 0, inputCaptureSelection: UInt32 = 0,
    inputCapturePrescaler: UInt32 = 0, inputCaptureFilter: UInt32 = 0
  ) {
    self.inputCapturePolarity = inputCapturePolarity
    self.inputCaptureSelection = inputCaptureSelection
    self.inputCapturePrescaler = inputCapturePrescaler
    self.inputCaptureFilter = inputCaptureFilter
  }
}
public struct TIMEncoderConfiguration: Equatable, Sendable {
  public var encoderMode: UInt32
  public var inputCapture1Polarity: UInt32
  public var inputCapture1Selection: UInt32
  public var inputCapture1Prescaler: UInt32
  public var inputCapture1Filter: UInt32
  public var inputCapture2Polarity: UInt32
  public var inputCapture2Selection: UInt32
  public var inputCapture2Prescaler: UInt32
  public var inputCapture2Filter: UInt32
  public init(
    encoderMode: UInt32 = 0, inputCapture1Polarity: UInt32 = 0, inputCapture1Selection: UInt32 = 0,
    inputCapture1Prescaler: UInt32 = 0, inputCapture1Filter: UInt32 = 0,
    inputCapture2Polarity: UInt32 = 0, inputCapture2Selection: UInt32 = 0,
    inputCapture2Prescaler: UInt32 = 0, inputCapture2Filter: UInt32 = 0
  ) {
    self.encoderMode = encoderMode
    self.inputCapture1Polarity = inputCapture1Polarity
    self.inputCapture1Selection = inputCapture1Selection
    self.inputCapture1Prescaler = inputCapture1Prescaler
    self.inputCapture1Filter = inputCapture1Filter
    self.inputCapture2Polarity = inputCapture2Polarity
    self.inputCapture2Selection = inputCapture2Selection
    self.inputCapture2Prescaler = inputCapture2Prescaler
    self.inputCapture2Filter = inputCapture2Filter
  }
}
public struct TIMClockConfiguration: Equatable, Sendable {
  public var clockSource: UInt32
  public var clockPolarity: UInt32
  public var clockPrescaler: UInt32
  public var clockFilter: UInt32
  public init(
    clockSource: UInt32 = 0, clockPolarity: UInt32 = 0, clockPrescaler: UInt32 = 0,
    clockFilter: UInt32 = 0
  ) {
    self.clockSource = clockSource
    self.clockPolarity = clockPolarity
    self.clockPrescaler = clockPrescaler
    self.clockFilter = clockFilter
  }
}
public struct TIMClearInputConfiguration: Equatable, Sendable {
  public var clearInputState: UInt32
  public var clearInputSource: UInt32
  public var clearInputPolarity: UInt32
  public var clearInputPrescaler: UInt32
  public var clearInputFilter: UInt32
  public init(
    clearInputState: UInt32 = 0, clearInputSource: UInt32 = 0, clearInputPolarity: UInt32 = 0,
    clearInputPrescaler: UInt32 = 0, clearInputFilter: UInt32 = 0
  ) {
    self.clearInputState = clearInputState
    self.clearInputSource = clearInputSource
    self.clearInputPolarity = clearInputPolarity
    self.clearInputPrescaler = clearInputPrescaler
    self.clearInputFilter = clearInputFilter
  }
}
public struct TIMMasterConfiguration: Equatable, Sendable {
  public var masterOutputTrigger: UInt32
  public var masterOutputTrigger2: UInt32
  public var masterSlaveMode: UInt32
  public init(
    masterOutputTrigger: UInt32 = 0, masterOutputTrigger2: UInt32 = 0, masterSlaveMode: UInt32 = 0
  ) {
    self.masterOutputTrigger = masterOutputTrigger
    self.masterOutputTrigger2 = masterOutputTrigger2
    self.masterSlaveMode = masterSlaveMode
  }
}
public struct TIMSlaveConfiguration: Equatable, Sendable {
  public var slaveMode: UInt32
  public var inputTrigger: UInt32
  public var triggerPolarity: UInt32
  public var triggerPrescaler: UInt32
  public var triggerFilter: UInt32
  public init(
    slaveMode: UInt32 = 0, inputTrigger: UInt32 = 0, triggerPolarity: UInt32 = 0,
    triggerPrescaler: UInt32 = 0, triggerFilter: UInt32 = 0
  ) {
    self.slaveMode = slaveMode
    self.inputTrigger = inputTrigger
    self.triggerPolarity = triggerPolarity
    self.triggerPrescaler = triggerPrescaler
    self.triggerFilter = triggerFilter
  }
}
public struct TIMBreakDeadTimeConfiguration: Equatable, Sendable {
  public var offStateRunMode: UInt32
  public var offStateIdleMode: UInt32
  public var lockLevel: UInt32
  public var deadTime: UInt32
  public var breakState: UInt32
  public var breakPolarity: UInt32
  public var breakFilter: UInt32
  public var breakAFMode: UInt32
  public var break2State: UInt32
  public var break2Polarity: UInt32
  public var break2Filter: UInt32
  public var break2AFMode: UInt32
  public var automaticOutput: UInt32
  public init(
    offStateRunMode: UInt32 = 0, offStateIdleMode: UInt32 = 0, lockLevel: UInt32 = 0,
    deadTime: UInt32 = 0, breakState: UInt32 = 0, breakPolarity: UInt32 = 0,
    breakFilter: UInt32 = 0, breakAFMode: UInt32 = 0, break2State: UInt32 = 0,
    break2Polarity: UInt32 = 0, break2Filter: UInt32 = 0, break2AFMode: UInt32 = 0,
    automaticOutput: UInt32 = 0
  ) {
    self.offStateRunMode = offStateRunMode
    self.offStateIdleMode = offStateIdleMode
    self.lockLevel = lockLevel
    self.deadTime = deadTime
    self.breakState = breakState
    self.breakPolarity = breakPolarity
    self.breakFilter = breakFilter
    self.breakAFMode = breakAFMode
    self.break2State = break2State
    self.break2Polarity = break2Polarity
    self.break2Filter = break2Filter
    self.break2AFMode = break2AFMode
    self.automaticOutput = automaticOutput
  }
}
public struct TIMHallSensorConfiguration: Equatable, Sendable {
  public var inputCapture1Polarity: UInt32
  public var inputCapture1Prescaler: UInt32
  public var inputCapture1Filter: UInt32
  public var commutationDelay: UInt32
  public init(
    inputCapture1Polarity: UInt32 = 0, inputCapture1Prescaler: UInt32 = 0,
    inputCapture1Filter: UInt32 = 0, commutationDelay: UInt32 = 0
  ) {
    self.inputCapture1Polarity = inputCapture1Polarity
    self.inputCapture1Prescaler = inputCapture1Prescaler
    self.inputCapture1Filter = inputCapture1Filter
    self.commutationDelay = commutationDelay
  }
}
public struct TIMBreakInputConfiguration: Equatable, Sendable {
  public var source: UInt32
  public var enable: UInt32
  public var polarity: UInt32
  public init(source: UInt32 = 0, enable: UInt32 = 0, polarity: UInt32 = 0) {
    self.source = source
    self.enable = enable
    self.polarity = polarity
  }
}
public struct TIMEncoderIndexConfiguration: Equatable, Sendable {
  public var polarity: UInt32
  public var prescaler: UInt32
  public var filter: UInt32
  public var blanking: UInt32
  public var firstIndexEnable: UInt32
  public var position: UInt32
  public var direction: UInt32
  public init(
    polarity: UInt32 = 0, prescaler: UInt32 = 0, filter: UInt32 = 0, blanking: UInt32 = 0,
    firstIndexEnable: UInt32 = 0, position: UInt32 = 0, direction: UInt32 = 0
  ) {
    self.polarity = polarity
    self.prescaler = prescaler
    self.filter = filter
    self.blanking = blanking
    self.firstIndexEnable = firstIndexEnable
    self.position = position
    self.direction = direction
  }
}
public enum TIMConfigurationWord: Int, CaseIterable {
  case prescaler = 0
  case counterMode = 1
  case period = 2
  case clockDivision = 3
  case repetitionCounter = 4
  case autoReloadPreload = 5
}
public enum TIMHandleWord: Int, CaseIterable {
  case channel = 0
  case lock = 1
  case state = 2
  case dmaBurstState = 3
}
public protocol TIMHandleIO {
  func read(_ word: TIMConfigurationWord) -> UInt32
  func write(_ word: TIMConfigurationWord, value: UInt32)
  func read(_ word: TIMHandleWord) -> UInt32
  func write(_ word: TIMHandleWord, value: UInt32)
  func readChannelState(_ index: Int, complementary: Bool) -> UInt32
  func writeChannelState(_ index: Int, complementary: Bool, value: UInt32)
}
extension TIMHandleIO {
  public func setConfiguration(_ configuration: TIMBaseConfiguration) {
    write(.prescaler, value: configuration.prescaler)
    write(.counterMode, value: configuration.counterMode)
    write(.period, value: configuration.period)
    write(.clockDivision, value: configuration.clockDivision)
    write(.repetitionCounter, value: configuration.repetitionCounter)
    write(.autoReloadPreload, value: configuration.autoReloadPreload)
  }
  public func configuration() -> TIMBaseConfiguration {
    .init(
      prescaler: read(.prescaler), counterMode: read(.counterMode), period: read(.period),
      clockDivision: read(.clockDivision), repetitionCounter: read(.repetitionCounter),
      autoReloadPreload: read(.autoReloadPreload))
  }
}
public typealias TIMCallback = UARTCallback
public enum TIMCallbackID: UInt32, CaseIterable {
  case baseMspInitialize = 0
  case baseMspDeinitialize = 1
  case inputCaptureMspInitialize = 2
  case inputCaptureMspDeinitialize = 3
  case outputCompareMspInitialize = 4
  case outputCompareMspDeinitialize = 5
  case pWMMspInitialize = 6
  case pWMMspDeinitialize = 7
  case onePulseMspInitialize = 8
  case onePulseMspDeinitialize = 9
  case encoderMspInitialize = 10
  case encoderMspDeinitialize = 11
  case hallSensorMspInitialize = 12
  case hallSensorMspDeinitialize = 13
  case periodElapsed = 14
  case periodElapsedHalfComplete = 15
  case trigger = 16
  case triggerHalfComplete = 17
  case inputCaptureCapture = 18
  case inputCaptureCaptureHalfComplete = 19
  case outputCompareDelayElapsed = 20
  case pWMPulseFinished = 21
  case pWMPulseFinishedHalfComplete = 22
  case error = 23
  case commutation = 24
  case commutationHalfComplete = 25
  case breakEvent = 26
  case break2 = 27
  case encoderIndex = 28
  case directionChange = 29
  case indexError = 30
  case transitionError = 31
}
public protocol TIMCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: TIMCallbackID) -> TIMCallback?
  func write(_ id: TIMCallbackID, value: TIMCallback?)
}
public struct TIMCallbackDefaults {
  public var baseMspInitialize: TIMCallback
  public var baseMspDeinitialize: TIMCallback
  public var inputCaptureMspInitialize: TIMCallback
  public var inputCaptureMspDeinitialize: TIMCallback
  public var outputCompareMspInitialize: TIMCallback
  public var outputCompareMspDeinitialize: TIMCallback
  public var pWMMspInitialize: TIMCallback
  public var pWMMspDeinitialize: TIMCallback
  public var onePulseMspInitialize: TIMCallback
  public var onePulseMspDeinitialize: TIMCallback
  public var encoderMspInitialize: TIMCallback
  public var encoderMspDeinitialize: TIMCallback
  public var hallSensorMspInitialize: TIMCallback
  public var hallSensorMspDeinitialize: TIMCallback
  public var periodElapsed: TIMCallback
  public var periodElapsedHalfComplete: TIMCallback
  public var trigger: TIMCallback
  public var triggerHalfComplete: TIMCallback
  public var inputCaptureCapture: TIMCallback
  public var inputCaptureCaptureHalfComplete: TIMCallback
  public var outputCompareDelayElapsed: TIMCallback
  public var pWMPulseFinished: TIMCallback
  public var pWMPulseFinishedHalfComplete: TIMCallback
  public var error: TIMCallback
  public var commutation: TIMCallback
  public var commutationHalfComplete: TIMCallback
  public var breakEvent: TIMCallback
  public var break2: TIMCallback
  public var encoderIndex: TIMCallback
  public var directionChange: TIMCallback
  public var indexError: TIMCallback
  public var transitionError: TIMCallback
  public init(
    baseMspInitialize: @escaping TIMCallback = { _ in },
    baseMspDeinitialize: @escaping TIMCallback = { _ in },
    inputCaptureMspInitialize: @escaping TIMCallback = { _ in },
    inputCaptureMspDeinitialize: @escaping TIMCallback = { _ in },
    outputCompareMspInitialize: @escaping TIMCallback = { _ in },
    outputCompareMspDeinitialize: @escaping TIMCallback = { _ in },
    pWMMspInitialize: @escaping TIMCallback = { _ in },
    pWMMspDeinitialize: @escaping TIMCallback = { _ in },
    onePulseMspInitialize: @escaping TIMCallback = { _ in },
    onePulseMspDeinitialize: @escaping TIMCallback = { _ in },
    encoderMspInitialize: @escaping TIMCallback = { _ in },
    encoderMspDeinitialize: @escaping TIMCallback = { _ in },
    hallSensorMspInitialize: @escaping TIMCallback = { _ in },
    hallSensorMspDeinitialize: @escaping TIMCallback = { _ in },
    periodElapsed: @escaping TIMCallback = { _ in },
    periodElapsedHalfComplete: @escaping TIMCallback = { _ in },
    trigger: @escaping TIMCallback = { _ in },
    triggerHalfComplete: @escaping TIMCallback = { _ in },
    inputCaptureCapture: @escaping TIMCallback = { _ in },
    inputCaptureCaptureHalfComplete: @escaping TIMCallback = { _ in },
    outputCompareDelayElapsed: @escaping TIMCallback = { _ in },
    pWMPulseFinished: @escaping TIMCallback = { _ in },
    pWMPulseFinishedHalfComplete: @escaping TIMCallback = { _ in },
    error: @escaping TIMCallback = { _ in }, commutation: @escaping TIMCallback = { _ in },
    commutationHalfComplete: @escaping TIMCallback = { _ in },
    breakEvent: @escaping TIMCallback = { _ in }, break2: @escaping TIMCallback = { _ in },
    encoderIndex: @escaping TIMCallback = { _ in },
    directionChange: @escaping TIMCallback = { _ in }, indexError: @escaping TIMCallback = { _ in },
    transitionError: @escaping TIMCallback = { _ in }
  ) {
    self.baseMspInitialize = baseMspInitialize
    self.baseMspDeinitialize = baseMspDeinitialize
    self.inputCaptureMspInitialize = inputCaptureMspInitialize
    self.inputCaptureMspDeinitialize = inputCaptureMspDeinitialize
    self.outputCompareMspInitialize = outputCompareMspInitialize
    self.outputCompareMspDeinitialize = outputCompareMspDeinitialize
    self.pWMMspInitialize = pWMMspInitialize
    self.pWMMspDeinitialize = pWMMspDeinitialize
    self.onePulseMspInitialize = onePulseMspInitialize
    self.onePulseMspDeinitialize = onePulseMspDeinitialize
    self.encoderMspInitialize = encoderMspInitialize
    self.encoderMspDeinitialize = encoderMspDeinitialize
    self.hallSensorMspInitialize = hallSensorMspInitialize
    self.hallSensorMspDeinitialize = hallSensorMspDeinitialize
    self.periodElapsed = periodElapsed
    self.periodElapsedHalfComplete = periodElapsedHalfComplete
    self.trigger = trigger
    self.triggerHalfComplete = triggerHalfComplete
    self.inputCaptureCapture = inputCaptureCapture
    self.inputCaptureCaptureHalfComplete = inputCaptureCaptureHalfComplete
    self.outputCompareDelayElapsed = outputCompareDelayElapsed
    self.pWMPulseFinished = pWMPulseFinished
    self.pWMPulseFinishedHalfComplete = pWMPulseFinishedHalfComplete
    self.error = error
    self.commutation = commutation
    self.commutationHalfComplete = commutationHalfComplete
    self.breakEvent = breakEvent
    self.break2 = break2
    self.encoderIndex = encoderIndex
    self.directionChange = directionChange
    self.indexError = indexError
    self.transitionError = transitionError
  }
  func callback(_ id: TIMCallbackID) -> TIMCallback {
    switch id {
    case .baseMspInitialize: return baseMspInitialize
    case .baseMspDeinitialize: return baseMspDeinitialize
    case .inputCaptureMspInitialize: return inputCaptureMspInitialize
    case .inputCaptureMspDeinitialize: return inputCaptureMspDeinitialize
    case .outputCompareMspInitialize: return outputCompareMspInitialize
    case .outputCompareMspDeinitialize: return outputCompareMspDeinitialize
    case .pWMMspInitialize: return pWMMspInitialize
    case .pWMMspDeinitialize: return pWMMspDeinitialize
    case .onePulseMspInitialize: return onePulseMspInitialize
    case .onePulseMspDeinitialize: return onePulseMspDeinitialize
    case .encoderMspInitialize: return encoderMspInitialize
    case .encoderMspDeinitialize: return encoderMspDeinitialize
    case .hallSensorMspInitialize: return hallSensorMspInitialize
    case .hallSensorMspDeinitialize: return hallSensorMspDeinitialize
    case .periodElapsed: return periodElapsed
    case .periodElapsedHalfComplete: return periodElapsedHalfComplete
    case .trigger: return trigger
    case .triggerHalfComplete: return triggerHalfComplete
    case .inputCaptureCapture: return inputCaptureCapture
    case .inputCaptureCaptureHalfComplete: return inputCaptureCaptureHalfComplete
    case .outputCompareDelayElapsed: return outputCompareDelayElapsed
    case .pWMPulseFinished: return pWMPulseFinished
    case .pWMPulseFinishedHalfComplete: return pWMPulseFinishedHalfComplete
    case .error: return error
    case .commutation: return commutation
    case .commutationHalfComplete: return commutationHalfComplete
    case .breakEvent: return breakEvent
    case .break2: return break2
    case .encoderIndex: return encoderIndex
    case .directionChange: return directionChange
    case .indexError: return indexError
    case .transitionError: return transitionError
    }
  }
}
public struct TIMUnregisteredCallbacks: TIMCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: TIMCallbackID) -> TIMCallback? { nil }
  public func write(_ id: TIMCallbackID, value: TIMCallback?) {
    preconditionFailure("Registered callback storage is unavailable")
  }
}
public enum TIMDMAChannel: UInt32, CaseIterable {
  case update = 0
  case captureCompare1 = 1
  case captureCompare2 = 2
  case captureCompare3 = 3
  case captureCompare4 = 4
  case commutation = 5
  case trigger = 6
}
public enum TIMDMACallbackKind: UInt32, CaseIterable {
  case error = 0
  case delayPulseComplete = 1
  case delayPulseHalfComplete = 2
  case captureComplete = 3
  case captureHalfComplete = 4
  case periodElapsedComplete = 5
  case periodElapsedHalfComplete = 6
  case triggerComplete = 7
  case triggerHalfComplete = 8
  case commutationComplete = 9
  case commutationHalfComplete = 10
  case delayPulseNComplete = 11
  case errorCCxN = 12
}
public typealias TIMDMACallbackContext = UARTDMACallbackContext
public protocol TIMDMAIO {
  func isPresent(_ channel: TIMDMAChannel) -> Bool
  func matches(_ channel: TIMDMAChannel, context: UnsafeMutableRawPointer?) -> Bool
  func read(_ channel: TIMDMAChannel, word: DMAHandleWord) -> UInt32
  func readSourceDataWidth(_ channel: TIMDMAChannel) -> UInt32
  func readMemory32(_ channel: TIMDMAChannel, at address: UInt32) -> UInt32
  func writeMemory32(_ channel: TIMDMAChannel, at address: UInt32, value: UInt32)
  func writeCallback(_ channel: TIMDMAChannel, id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: TIMDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ channel: TIMDMAChannel, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus
  func startLinkedListInterrupt(_ channel: TIMDMAChannel) -> HALStatus
  func abortInterrupt(_ channel: TIMDMAChannel) -> HALStatus
}
public struct TIM<
  Registers: TIMRegisterIO, Handle: TIMHandleIO, Callbacks: TIMCallbackIO, DMAIO: TIMDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: TIMCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: TIMCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  func lock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func modify(_ register: TIMRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
