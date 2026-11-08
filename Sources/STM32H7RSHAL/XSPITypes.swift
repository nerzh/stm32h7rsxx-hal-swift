// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum XSPIRegister: UInt32, CaseIterable {
  case cr = 0
  case dcr1 = 8
  case dcr2 = 12
  case dcr3 = 16
  case dcr4 = 20
  case sr = 32
  case fcr = 36
  case dlr = 64
  case ar = 72
  case dr = 80
  case psmkr = 128
  case psmar = 136
  case pir = 144
  case ccr = 256
  case tcr = 264
  case ir = 272
  case abr = 288
  case lptr = 304
  case wpccr = 320
  case wptcr = 328
  case wpir = 336
  case wpabr = 352
  case wccr = 384
  case wtcr = 392
  case wir = 400
  case wabr = 416
  case hlcr = 512
  case calfcr = 528
  case calmr = 536
  case calsor = 544
  case calsir = 552
}
public enum XSPIInstance: UInt32, CaseIterable {
  case xspi1 = 1_375_752_192
  case xspi2 = 1_375_772_672
}
public protocol XSPIRegisterIO {
  var instance: XSPIInstance { get }
  func read(_ register: XSPIRegister) -> UInt32
  func write(_ register: XSPIRegister, value: UInt32)
  func read8(_ register: XSPIRegister) -> UInt8
  func write8(_ register: XSPIRegister, value: UInt8)
  func address(of register: XSPIRegister) -> UInt32
  func readControl(_ instance: XSPIInstance) -> UInt32
  func writeControl(_ instance: XSPIInstance, value: UInt32)
  func readManagerControl() -> UInt32
  func writeManagerControl(_ value: UInt32)
}
public struct XSPIConfiguration: Equatable, Sendable {
  public var fifoThresholdByte: UInt32
  public var memoryMode: UInt32
  public var memoryType: UInt32
  public var memorySize: UInt32
  public var chipSelectHighTimeCycle: UInt32
  public var freeRunningClock: UInt32
  public var clockMode: UInt32
  public var wrapSize: UInt32
  public var clockPrescaler: UInt32
  public var sampleShifting: UInt32
  public var delayHoldQuarterCycle: UInt32
  public var chipSelectBoundary: UInt32
  public var maxTran: UInt32
  public var refresh: UInt32
  public var memorySelect: UInt32
  public init(
    fifoThresholdByte: UInt32 = 0, memoryMode: UInt32 = 0, memoryType: UInt32 = 0,
    memorySize: UInt32 = 0, chipSelectHighTimeCycle: UInt32 = 0, freeRunningClock: UInt32 = 0,
    clockMode: UInt32 = 0, wrapSize: UInt32 = 0, clockPrescaler: UInt32 = 0,
    sampleShifting: UInt32 = 0, delayHoldQuarterCycle: UInt32 = 0, chipSelectBoundary: UInt32 = 0,
    maxTran: UInt32 = 0, refresh: UInt32 = 0, memorySelect: UInt32 = 0
  ) {
    self.fifoThresholdByte = fifoThresholdByte
    self.memoryMode = memoryMode
    self.memoryType = memoryType
    self.memorySize = memorySize
    self.chipSelectHighTimeCycle = chipSelectHighTimeCycle
    self.freeRunningClock = freeRunningClock
    self.clockMode = clockMode
    self.wrapSize = wrapSize
    self.clockPrescaler = clockPrescaler
    self.sampleShifting = sampleShifting
    self.delayHoldQuarterCycle = delayHoldQuarterCycle
    self.chipSelectBoundary = chipSelectBoundary
    self.maxTran = maxTran
    self.refresh = refresh
    self.memorySelect = memorySelect
  }
}
public struct XSPIRegularCommand: Equatable, Sendable {
  public var operationType: UInt32
  public var ioSelect: UInt32
  public var instruction: UInt32
  public var instructionMode: UInt32
  public var instructionWidth: UInt32
  public var instructionDTRMode: UInt32
  public var address: UInt32
  public var addressMode: UInt32
  public var addressWidth: UInt32
  public var addressDTRMode: UInt32
  public var alternateBytes: UInt32
  public var alternateBytesMode: UInt32
  public var alternateBytesWidth: UInt32
  public var alternateBytesDTRMode: UInt32
  public var dataMode: UInt32
  public var dataLength: UInt32
  public var dataDTRMode: UInt32
  public var dummyCycles: UInt32
  public var dqsMode: UInt32
  public init(
    operationType: UInt32 = 0, ioSelect: UInt32 = 0, instruction: UInt32 = 0,
    instructionMode: UInt32 = 0, instructionWidth: UInt32 = 0, instructionDTRMode: UInt32 = 0,
    address: UInt32 = 0, addressMode: UInt32 = 0, addressWidth: UInt32 = 0,
    addressDTRMode: UInt32 = 0, alternateBytes: UInt32 = 0, alternateBytesMode: UInt32 = 0,
    alternateBytesWidth: UInt32 = 0, alternateBytesDTRMode: UInt32 = 0, dataMode: UInt32 = 0,
    dataLength: UInt32 = 0, dataDTRMode: UInt32 = 0, dummyCycles: UInt32 = 0, dqsMode: UInt32 = 0
  ) {
    self.operationType = operationType
    self.ioSelect = ioSelect
    self.instruction = instruction
    self.instructionMode = instructionMode
    self.instructionWidth = instructionWidth
    self.instructionDTRMode = instructionDTRMode
    self.address = address
    self.addressMode = addressMode
    self.addressWidth = addressWidth
    self.addressDTRMode = addressDTRMode
    self.alternateBytes = alternateBytes
    self.alternateBytesMode = alternateBytesMode
    self.alternateBytesWidth = alternateBytesWidth
    self.alternateBytesDTRMode = alternateBytesDTRMode
    self.dataMode = dataMode
    self.dataLength = dataLength
    self.dataDTRMode = dataDTRMode
    self.dummyCycles = dummyCycles
    self.dqsMode = dqsMode
  }
}
public struct XSPIHyperbusConfiguration: Equatable, Sendable {
  public var rwRecoveryTimeCycle: UInt32
  public var accessTimeCycle: UInt32
  public var writeZeroLatency: UInt32
  public var latencyMode: UInt32
  public init(
    rwRecoveryTimeCycle: UInt32 = 0, accessTimeCycle: UInt32 = 0, writeZeroLatency: UInt32 = 0,
    latencyMode: UInt32 = 0
  ) {
    self.rwRecoveryTimeCycle = rwRecoveryTimeCycle
    self.accessTimeCycle = accessTimeCycle
    self.writeZeroLatency = writeZeroLatency
    self.latencyMode = latencyMode
  }
}
public struct XSPIHyperbusCommand: Equatable, Sendable {
  public var addressSpace: UInt32
  public var address: UInt32
  public var addressWidth: UInt32
  public var dataLength: UInt32
  public var dqsMode: UInt32
  public var dataMode: UInt32
  public init(
    addressSpace: UInt32 = 0, address: UInt32 = 0, addressWidth: UInt32 = 0, dataLength: UInt32 = 0,
    dqsMode: UInt32 = 0, dataMode: UInt32 = 0
  ) {
    self.addressSpace = addressSpace
    self.address = address
    self.addressWidth = addressWidth
    self.dataLength = dataLength
    self.dqsMode = dqsMode
    self.dataMode = dataMode
  }
}
public struct XSPIAutoPollingConfiguration: Equatable, Sendable {
  public var matchValue: UInt32
  public var matchMask: UInt32
  public var matchMode: UInt32
  public var automaticStop: UInt32
  public var intervalTime: UInt32
  public init(
    matchValue: UInt32 = 0, matchMask: UInt32 = 0, matchMode: UInt32 = 0, automaticStop: UInt32 = 0,
    intervalTime: UInt32 = 0
  ) {
    self.matchValue = matchValue
    self.matchMask = matchMask
    self.matchMode = matchMode
    self.automaticStop = automaticStop
    self.intervalTime = intervalTime
  }
}
public struct XSPIMemoryMappedConfiguration: Equatable, Sendable {
  public var timeOutActivation: UInt32
  public var timeoutPeriodClock: UInt32
  public init(timeOutActivation: UInt32 = 0, timeoutPeriodClock: UInt32 = 0) {
    self.timeOutActivation = timeOutActivation
    self.timeoutPeriodClock = timeoutPeriodClock
  }
}
public struct XSPIManagerConfiguration: Equatable, Sendable {
  public var nCSOverride: UInt32
  public var ioPort: UInt32
  public var req2AckTime: UInt32
  public init(nCSOverride: UInt32 = 0, ioPort: UInt32 = 0, req2AckTime: UInt32 = 0) {
    self.nCSOverride = nCSOverride
    self.ioPort = ioPort
    self.req2AckTime = req2AckTime
  }
}
public struct XSPICalibrationConfiguration: Equatable, Sendable {
  public var delayValueType: UInt32
  public var fineCalibrationUnit: UInt32
  public var coarseCalibrationUnit: UInt32
  public var maxCalibration: UInt32
  public init(
    delayValueType: UInt32 = 0, fineCalibrationUnit: UInt32 = 0, coarseCalibrationUnit: UInt32 = 0,
    maxCalibration: UInt32 = 0
  ) {
    self.delayValueType = delayValueType
    self.fineCalibrationUnit = fineCalibrationUnit
    self.coarseCalibrationUnit = coarseCalibrationUnit
    self.maxCalibration = maxCalibration
  }
}
public enum XSPIConfigurationWord: Int, CaseIterable {
  case fifoThresholdByte = 0
  case memoryMode = 1
  case memoryType = 2
  case memorySize = 3
  case chipSelectHighTimeCycle = 4
  case freeRunningClock = 5
  case clockMode = 6
  case wrapSize = 7
  case clockPrescaler = 8
  case sampleShifting = 9
  case delayHoldQuarterCycle = 10
  case chipSelectBoundary = 11
  case maxTran = 12
  case refresh = 13
  case memorySelect = 14
}
public enum XSPIHandleWord: Int, CaseIterable {
  case transferSize = 0
  case transferCount = 1
  case state = 2
  case errorCode = 3
  case timeout = 4
}
public protocol XSPIHandleIO {
  func read(_ word: XSPIConfigurationWord) -> UInt32
  func write(_ word: XSPIConfigurationWord, value: UInt32)
  func read(_ word: XSPIHandleWord) -> UInt32
  func write(_ word: XSPIHandleWord, value: UInt32)
  func readBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
extension XSPIHandleIO {
  public func setConfiguration(_ value: XSPIConfiguration) {
    write(.fifoThresholdByte, value: value.fifoThresholdByte)
    write(.memoryMode, value: value.memoryMode)
    write(.memoryType, value: value.memoryType)
    write(.memorySize, value: value.memorySize)
    write(.chipSelectHighTimeCycle, value: value.chipSelectHighTimeCycle)
    write(.freeRunningClock, value: value.freeRunningClock)
    write(.clockMode, value: value.clockMode)
    write(.wrapSize, value: value.wrapSize)
    write(.clockPrescaler, value: value.clockPrescaler)
    write(.sampleShifting, value: value.sampleShifting)
    write(.delayHoldQuarterCycle, value: value.delayHoldQuarterCycle)
    write(.chipSelectBoundary, value: value.chipSelectBoundary)
    write(.maxTran, value: value.maxTran)
    write(.refresh, value: value.refresh)
    write(.memorySelect, value: value.memorySelect)
  }
}
public typealias XSPICallback = UARTCallback
public enum XSPICallbackID: UInt32, CaseIterable {
  case error = 0
  case abortComplete = 1
  case fifoThreshold = 2
  case commandComplete = 3
  case receiveComplete = 4
  case transmitComplete = 5
  case receiveHalfComplete = 6
  case transmitHalfComplete = 7
  case statusMatch = 8
  case timeout = 9
  case mspInitialize = 10
  case mspDeinitialize = 11
}
public protocol XSPICallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: XSPICallbackID) -> XSPICallback?
  func write(_ id: XSPICallbackID, value: XSPICallback?)
}
public struct XSPICallbackDefaults {
  public var error: XSPICallback
  public var abortComplete: XSPICallback
  public var fifoThreshold: XSPICallback
  public var commandComplete: XSPICallback
  public var receiveComplete: XSPICallback
  public var transmitComplete: XSPICallback
  public var receiveHalfComplete: XSPICallback
  public var transmitHalfComplete: XSPICallback
  public var statusMatch: XSPICallback
  public var timeout: XSPICallback
  public var mspInitialize: XSPICallback
  public var mspDeinitialize: XSPICallback
  public init(
    error: @escaping XSPICallback = { _ in }, abortComplete: @escaping XSPICallback = { _ in },
    fifoThreshold: @escaping XSPICallback = { _ in },
    commandComplete: @escaping XSPICallback = { _ in },
    receiveComplete: @escaping XSPICallback = { _ in },
    transmitComplete: @escaping XSPICallback = { _ in },
    receiveHalfComplete: @escaping XSPICallback = { _ in },
    transmitHalfComplete: @escaping XSPICallback = { _ in },
    statusMatch: @escaping XSPICallback = { _ in }, timeout: @escaping XSPICallback = { _ in },
    mspInitialize: @escaping XSPICallback = { _ in },
    mspDeinitialize: @escaping XSPICallback = { _ in }
  ) {
    self.error = error
    self.abortComplete = abortComplete
    self.fifoThreshold = fifoThreshold
    self.commandComplete = commandComplete
    self.receiveComplete = receiveComplete
    self.transmitComplete = transmitComplete
    self.receiveHalfComplete = receiveHalfComplete
    self.transmitHalfComplete = transmitHalfComplete
    self.statusMatch = statusMatch
    self.timeout = timeout
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  func callback(_ id: XSPICallbackID) -> XSPICallback {
    switch id {
    case .error: return error
    case .abortComplete: return abortComplete
    case .fifoThreshold: return fifoThreshold
    case .commandComplete: return commandComplete
    case .receiveComplete: return receiveComplete
    case .transmitComplete: return transmitComplete
    case .receiveHalfComplete: return receiveHalfComplete
    case .transmitHalfComplete: return transmitHalfComplete
    case .statusMatch: return statusMatch
    case .timeout: return timeout
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct XSPIUnregisteredCallbacks: XSPICallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: XSPICallbackID) -> XSPICallback? { nil }
  public func write(_ id: XSPICallbackID, value: XSPICallback?) {
    preconditionFailure("Registered callback storage is unavailable")
  }
}
public enum XSPIDMACallbackKind: UInt32, CaseIterable {
  case complete = 0
  case halfComplete = 1
  case error = 2
  case abortComplete = 3
}
public typealias XSPIDMACallbackContext = UARTDMACallbackContext
public enum XSPIDMAConfigurationWord: Int, CaseIterable {
  case destinationDataWidth = 0
  case direction = 1
  case sourceIncrement = 2
  case destinationIncrement = 3
}
public protocol XSPIDMAIO {
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32
  func readConfiguration(_ direction: UARTDMADirection, word: XSPIDMAConfigurationWord) -> UInt32
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32)
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: XSPIDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus
  func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus
}
public struct XSPI<
  Registers: XSPIRegisterIO, Handle: XSPIHandleIO, Callbacks: XSPICallbackIO, DMAIO: XSPIDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: XSPICallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: XSPICallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  func modify(_ register: XSPIRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
