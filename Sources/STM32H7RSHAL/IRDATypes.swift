// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// IRDA operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum IRDAConfigurationWord: Int, CaseIterable {
  case baudRate = 0
  case wordLength = 1
  case parity = 2
  case mode = 3
  case prescaler = 4
  case powerMode = 5
  case clockPrescaler = 6
}
public enum IRDAHandleHalfWord: Int, CaseIterable {
  case transmitSize = 0
  case transmitCount = 1
  case receiveSize = 2
  case receiveCount = 3
  case mask = 4
}
public enum IRDAHandleWord: Int, CaseIterable {
  case lock = 0
  case globalState = 1
  case receiveState = 2
  case errorCode = 3
}
public protocol IRDAHandleIO {
  // Reads zero-extend narrow C fields; writes retain their UInt8/UInt16 assignment width.
  func read(_ word: IRDAConfigurationWord) -> UInt32
  func write(_ word: IRDAConfigurationWord, value: UInt32)
  func read(_ word: IRDAHandleHalfWord) -> UInt16
  func write(_ word: IRDAHandleHalfWord, value: UInt16)
  func read(_ word: IRDAHandleWord) -> UInt32
  func write(_ word: IRDAHandleWord, value: UInt32)
  func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer?
  func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?)
}
public typealias IRDAState = UARTState
public struct IRDAError: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let parity = Self(rawValue: 0x1)
  public static let noise = Self(rawValue: 0x2)
  public static let framing = Self(rawValue: 0x4)
  public static let overrun = Self(rawValue: 0x8)
  public static let dma = Self(rawValue: 0x10)
  public static let busy = Self(rawValue: 0x20)
  public static let invalidCallback = Self(rawValue: 0x40)
}
public struct IRDAConfiguration: Equatable, Sendable {
  public var baudRate: UInt32
  public var wordLength: UInt32
  public var parity: UInt32
  public var mode: UInt32
  public var prescaler: UInt32
  public var powerMode: UInt32
  public var clockPrescaler: UInt32
  public init(
    baudRate: UInt32 = 115200, wordLength: UInt32 = 0, parity: UInt32 = 0, mode: UInt32 = 12,
    prescaler: UInt32 = 1, powerMode: UInt32 = 0, clockPrescaler: UInt32 = 0
  ) {
    self.baudRate = baudRate
    self.wordLength = wordLength
    self.parity = parity
    self.mode = mode
    self.prescaler = prescaler
    self.powerMode = powerMode
    self.clockPrescaler = clockPrescaler
  }
}
extension IRDAHandleIO {
  public func setConfiguration(_ configuration: IRDAConfiguration) {
    write(.baudRate, value: configuration.baudRate)
    write(.wordLength, value: configuration.wordLength)
    write(.parity, value: configuration.parity)
    write(.mode, value: configuration.mode)
    write(.prescaler, value: configuration.prescaler)
    write(.powerMode, value: configuration.powerMode)
    write(.clockPrescaler, value: configuration.clockPrescaler)
  }
  public func getConfiguration() -> IRDAConfiguration {
    .init(
      baudRate: read(.baudRate), wordLength: read(.wordLength), parity: read(.parity),
      mode: read(.mode), prescaler: read(.prescaler), powerMode: read(.powerMode),
      clockPrescaler: read(.clockPrescaler))
  }
}
public typealias IRDACallback = UARTCallback
public enum IRDACallbackID: UInt32, CaseIterable {
  case transmitHalfComplete = 0
  case transmitComplete = 1
  case receiveHalfComplete = 2
  case receiveComplete = 3
  case error = 4
  case abortComplete = 5
  case abortTransmitComplete = 6
  case abortReceiveComplete = 7
  case mspInitialize = 8
  case mspDeinitialize = 9
}
public protocol IRDACallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: IRDACallbackID) -> IRDACallback?
  func write(_ id: IRDACallbackID, value: IRDACallback?)
}
public struct IRDACallbackDefaults {
  public let transmitHalfComplete: IRDACallback
  public let transmitComplete: IRDACallback
  public let receiveHalfComplete: IRDACallback
  public let receiveComplete: IRDACallback
  public let error: IRDACallback
  public let abortComplete: IRDACallback
  public let abortTransmitComplete: IRDACallback
  public let abortReceiveComplete: IRDACallback
  public let mspInitialize: IRDACallback
  public let mspDeinitialize: IRDACallback
  public init(
    transmitHalfComplete: @escaping IRDACallback = { _ in },
    transmitComplete: @escaping IRDACallback = { _ in },
    receiveHalfComplete: @escaping IRDACallback = { _ in },
    receiveComplete: @escaping IRDACallback = { _ in },
    error: @escaping IRDACallback = { _ in },
    abortComplete: @escaping IRDACallback = { _ in },
    abortTransmitComplete: @escaping IRDACallback = { _ in },
    abortReceiveComplete: @escaping IRDACallback = { _ in },
    mspInitialize: @escaping IRDACallback = { _ in },
    mspDeinitialize: @escaping IRDACallback = { _ in }
  ) {
    self.transmitHalfComplete = transmitHalfComplete
    self.transmitComplete = transmitComplete
    self.receiveHalfComplete = receiveHalfComplete
    self.receiveComplete = receiveComplete
    self.error = error
    self.abortComplete = abortComplete
    self.abortTransmitComplete = abortTransmitComplete
    self.abortReceiveComplete = abortReceiveComplete
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  public func callback(_ id: IRDACallbackID) -> IRDACallback {
    switch id {
    case .transmitHalfComplete: return transmitHalfComplete
    case .transmitComplete: return transmitComplete
    case .receiveHalfComplete: return receiveHalfComplete
    case .receiveComplete: return receiveComplete
    case .error: return error
    case .abortComplete: return abortComplete
    case .abortTransmitComplete: return abortTransmitComplete
    case .abortReceiveComplete: return abortReceiveComplete
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct IRDAUnregisteredCallbacks: IRDACallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: IRDACallbackID) -> IRDACallback? { nil }
  public func write(_ id: IRDACallbackID, value: IRDACallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct IRDA<
  Registers: UARTRegisterIO, Handle: IRDAHandleIO,
  Callbacks: IRDACallbackIO, DMAIO: UARTDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: IRDACallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: IRDACallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
}
// The original IRDA HSI branch uses HSI_VALUE without applying HSIDIV.
public protocol IRDAClockIO: UARTClockIO {
  func unprescaledHSIFrequency() -> UInt32
}
