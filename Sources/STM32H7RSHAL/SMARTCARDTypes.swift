// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMARTCARD/SMARTCARDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SMARTCARDConfigurationWord: Int, CaseIterable {
  case baudRate = 0
  case wordLength = 1
  case stopBits = 2
  case parity = 3
  case mode = 4
  case clockPolarity = 5
  case clockPhase = 6
  case clockLastBit = 7
  case oneBitSampling = 8
  case prescaler = 9
  case guardTime = 10
  case nackEnable = 11
  case timeoutEnable = 12
  case timeoutValue = 13
  case blockLength = 14
  case autoRetryCount = 15
  case clockPrescaler = 16
}
public enum SMARTCARDAdvancedConfigurationWord: Int, CaseIterable {
  case features = 0
  case txPinLevelInvert = 1
  case rxPinLevelInvert = 2
  case dataInvert = 3
  case swap = 4
  case overrunDisable = 5
  case dmaDisableOnReceiveError = 6
  case mostSignificantBitFirst = 7
  case transmitCompletionIndication = 8
}
public enum SMARTCARDHandleHalfWord: Int, CaseIterable {
  case transmitSize = 0
  case transmitCount = 1
  case receiveSize = 2
  case receiveCount = 3
  case rxDataToProcess = 4
  case txDataToProcess = 5
}
public enum SMARTCARDHandleWord: Int, CaseIterable {
  case fifoMode = 0
  case rxISR = 1
  case txISR = 2
  case lock = 3
  case globalState = 4
  case receiveState = 5
  case errorCode = 6
}
public protocol SMARTCARDHandleIO {
  // Reads zero-extend narrow C fields; writes retain their UInt8/UInt16 assignment width.
  func read(_ word: SMARTCARDConfigurationWord) -> UInt32
  func write(_ word: SMARTCARDConfigurationWord, value: UInt32)
  func read(_ word: SMARTCARDAdvancedConfigurationWord) -> UInt32
  func write(_ word: SMARTCARDAdvancedConfigurationWord, value: UInt32)
  func read(_ word: SMARTCARDHandleHalfWord) -> UInt16
  func write(_ word: SMARTCARDHandleHalfWord, value: UInt16)
  func read(_ word: SMARTCARDHandleWord) -> UInt32
  func write(_ word: SMARTCARDHandleWord, value: UInt32)
  func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer?
  func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?)
}
public typealias SMARTCARDState = UARTState
public struct SMARTCARDError: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let parity = Self(rawValue: 0x1)
  public static let noise = Self(rawValue: 0x2)
  public static let framing = Self(rawValue: 0x4)
  public static let overrun = Self(rawValue: 0x8)
  public static let dma = Self(rawValue: 0x10)
  public static let receiverTimeout = Self(rawValue: 0x20)
  public static let invalidCallback = Self(rawValue: 0x40)
}
public struct SMARTCARDConfiguration: Equatable, Sendable {
  public var baudRate: UInt32
  public var wordLength: UInt32
  public var stopBits: UInt32
  public var parity: UInt32
  public var mode: UInt32
  public var clockPolarity: UInt32
  public var clockPhase: UInt32
  public var clockLastBit: UInt32
  public var oneBitSampling: UInt32
  public var prescaler: UInt32
  public var guardTime: UInt32
  public var nackEnable: UInt32
  public var timeoutEnable: UInt32
  public var timeoutValue: UInt32
  public var blockLength: UInt32
  public var autoRetryCount: UInt32
  public var clockPrescaler: UInt32
  public init(
    baudRate: UInt32 = 9600, wordLength: UInt32 = 4096, stopBits: UInt32 = 12288,
    parity: UInt32 = 1024, mode: UInt32 = 12, clockPolarity: UInt32 = 0, clockPhase: UInt32 = 0,
    clockLastBit: UInt32 = 0, oneBitSampling: UInt32 = 0, prescaler: UInt32 = 1,
    guardTime: UInt32 = 0, nackEnable: UInt32 = 0, timeoutEnable: UInt32 = 0,
    timeoutValue: UInt32 = 0, blockLength: UInt32 = 0, autoRetryCount: UInt32 = 0,
    clockPrescaler: UInt32 = 0
  ) {
    self.baudRate = baudRate
    self.wordLength = wordLength
    self.stopBits = stopBits
    self.parity = parity
    self.mode = mode
    self.clockPolarity = clockPolarity
    self.clockPhase = clockPhase
    self.clockLastBit = clockLastBit
    self.oneBitSampling = oneBitSampling
    self.prescaler = prescaler
    self.guardTime = guardTime
    self.nackEnable = nackEnable
    self.timeoutEnable = timeoutEnable
    self.timeoutValue = timeoutValue
    self.blockLength = blockLength
    self.autoRetryCount = autoRetryCount
    self.clockPrescaler = clockPrescaler
  }
}
extension SMARTCARDHandleIO {
  public func setConfiguration(_ configuration: SMARTCARDConfiguration) {
    write(.baudRate, value: configuration.baudRate)
    write(.wordLength, value: configuration.wordLength)
    write(.stopBits, value: configuration.stopBits)
    write(.parity, value: configuration.parity)
    write(.mode, value: configuration.mode)
    write(.clockPolarity, value: configuration.clockPolarity)
    write(.clockPhase, value: configuration.clockPhase)
    write(.clockLastBit, value: configuration.clockLastBit)
    write(.oneBitSampling, value: configuration.oneBitSampling)
    write(.prescaler, value: configuration.prescaler)
    write(.guardTime, value: configuration.guardTime)
    write(.nackEnable, value: configuration.nackEnable)
    write(.timeoutEnable, value: configuration.timeoutEnable)
    write(.timeoutValue, value: configuration.timeoutValue)
    write(.blockLength, value: configuration.blockLength)
    write(.autoRetryCount, value: configuration.autoRetryCount)
    write(.clockPrescaler, value: configuration.clockPrescaler)
  }
  public func getConfiguration() -> SMARTCARDConfiguration {
    .init(
      baudRate: read(.baudRate), wordLength: read(.wordLength), stopBits: read(.stopBits),
      parity: read(.parity), mode: read(.mode), clockPolarity: read(.clockPolarity),
      clockPhase: read(.clockPhase), clockLastBit: read(.clockLastBit),
      oneBitSampling: read(.oneBitSampling), prescaler: read(.prescaler),
      guardTime: read(.guardTime), nackEnable: read(.nackEnable),
      timeoutEnable: read(.timeoutEnable), timeoutValue: read(.timeoutValue),
      blockLength: read(.blockLength), autoRetryCount: read(.autoRetryCount),
      clockPrescaler: read(.clockPrescaler))
  }
}
public struct SMARTCARDAdvancedConfiguration: Equatable, Sendable {
  public var features: UInt32
  public var txPinLevelInvert: UInt32
  public var rxPinLevelInvert: UInt32
  public var dataInvert: UInt32
  public var swap: UInt32
  public var overrunDisable: UInt32
  public var dmaDisableOnReceiveError: UInt32
  public var mostSignificantBitFirst: UInt32
  public var transmitCompletionIndication: UInt32
  public init(
    features: UInt32 = 0, txPinLevelInvert: UInt32 = 0, rxPinLevelInvert: UInt32 = 0,
    dataInvert: UInt32 = 0, swap: UInt32 = 0, overrunDisable: UInt32 = 0,
    dmaDisableOnReceiveError: UInt32 = 0, mostSignificantBitFirst: UInt32 = 0,
    transmitCompletionIndication: UInt32 = 1574
  ) {
    self.features = features
    self.txPinLevelInvert = txPinLevelInvert
    self.rxPinLevelInvert = rxPinLevelInvert
    self.dataInvert = dataInvert
    self.swap = swap
    self.overrunDisable = overrunDisable
    self.dmaDisableOnReceiveError = dmaDisableOnReceiveError
    self.mostSignificantBitFirst = mostSignificantBitFirst
    self.transmitCompletionIndication = transmitCompletionIndication
  }
}
extension SMARTCARDHandleIO {
  public func setAdvancedConfiguration(_ configuration: SMARTCARDAdvancedConfiguration) {
    write(.features, value: configuration.features)
    write(.txPinLevelInvert, value: configuration.txPinLevelInvert)
    write(.rxPinLevelInvert, value: configuration.rxPinLevelInvert)
    write(.dataInvert, value: configuration.dataInvert)
    write(.swap, value: configuration.swap)
    write(.overrunDisable, value: configuration.overrunDisable)
    write(.dmaDisableOnReceiveError, value: configuration.dmaDisableOnReceiveError)
    write(.mostSignificantBitFirst, value: configuration.mostSignificantBitFirst)
    write(.transmitCompletionIndication, value: configuration.transmitCompletionIndication)
  }
  public func getAdvancedConfiguration() -> SMARTCARDAdvancedConfiguration {
    .init(
      features: read(.features), txPinLevelInvert: read(.txPinLevelInvert),
      rxPinLevelInvert: read(.rxPinLevelInvert), dataInvert: read(.dataInvert), swap: read(.swap),
      overrunDisable: read(.overrunDisable),
      dmaDisableOnReceiveError: read(.dmaDisableOnReceiveError),
      mostSignificantBitFirst: read(.mostSignificantBitFirst),
      transmitCompletionIndication: read(.transmitCompletionIndication))
  }
}
public typealias SMARTCARDCallback = UARTCallback
public enum SMARTCARDCallbackID: UInt32, CaseIterable {
  case transmitComplete = 0
  case receiveComplete = 1
  case error = 2
  case abortComplete = 3
  case abortTransmitComplete = 4
  case abortReceiveComplete = 5
  case receiveFIFOFull = 6
  case transmitFIFOEmpty = 7
  case mspInitialize = 8
  case mspDeinitialize = 9
}
public protocol SMARTCARDCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: SMARTCARDCallbackID) -> SMARTCARDCallback?
  func write(_ id: SMARTCARDCallbackID, value: SMARTCARDCallback?)
}
public struct SMARTCARDCallbackDefaults {
  public let transmitComplete: SMARTCARDCallback
  public let receiveComplete: SMARTCARDCallback
  public let error: SMARTCARDCallback
  public let abortComplete: SMARTCARDCallback
  public let abortTransmitComplete: SMARTCARDCallback
  public let abortReceiveComplete: SMARTCARDCallback
  public let receiveFIFOFull: SMARTCARDCallback
  public let transmitFIFOEmpty: SMARTCARDCallback
  public let mspInitialize: SMARTCARDCallback
  public let mspDeinitialize: SMARTCARDCallback
  public init(
    transmitComplete: @escaping SMARTCARDCallback = { _ in },
    receiveComplete: @escaping SMARTCARDCallback = { _ in },
    error: @escaping SMARTCARDCallback = { _ in },
    abortComplete: @escaping SMARTCARDCallback = { _ in },
    abortTransmitComplete: @escaping SMARTCARDCallback = { _ in },
    abortReceiveComplete: @escaping SMARTCARDCallback = { _ in },
    receiveFIFOFull: @escaping SMARTCARDCallback = { _ in },
    transmitFIFOEmpty: @escaping SMARTCARDCallback = { _ in },
    mspInitialize: @escaping SMARTCARDCallback = { _ in },
    mspDeinitialize: @escaping SMARTCARDCallback = { _ in }
  ) {
    self.transmitComplete = transmitComplete
    self.receiveComplete = receiveComplete
    self.error = error
    self.abortComplete = abortComplete
    self.abortTransmitComplete = abortTransmitComplete
    self.abortReceiveComplete = abortReceiveComplete
    self.receiveFIFOFull = receiveFIFOFull
    self.transmitFIFOEmpty = transmitFIFOEmpty
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  public func callback(_ id: SMARTCARDCallbackID) -> SMARTCARDCallback {
    switch id {
    case .transmitComplete: return transmitComplete
    case .receiveComplete: return receiveComplete
    case .error: return error
    case .abortComplete: return abortComplete
    case .abortTransmitComplete: return abortTransmitComplete
    case .abortReceiveComplete: return abortReceiveComplete
    case .receiveFIFOFull: return receiveFIFOFull
    case .transmitFIFOEmpty: return transmitFIFOEmpty
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct SMARTCARDUnregisteredCallbacks: SMARTCARDCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: SMARTCARDCallbackID) -> SMARTCARDCallback? { nil }
  public func write(_ id: SMARTCARDCallbackID, value: SMARTCARDCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct SMARTCARD<
  Registers: UARTRegisterIO, Handle: SMARTCARDHandleIO,
  Callbacks: SMARTCARDCallbackIO, DMAIO: UARTDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: SMARTCARDCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: SMARTCARDCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
}
