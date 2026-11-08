// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART/USARTEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// USART reuses the physical UART register, clock and DMA adapters.
public enum USARTConfigurationWord: Int, CaseIterable {
  case baudRate = 0
  case wordLength, stopBits, parity, mode
  case clockPolarity, clockPhase, clockLastBit, clockPrescaler
}
public enum USARTHandleWord: Int, CaseIterable {
  case slaveMode = 0
  case fifoMode, rxISR, txISR, lock, state, errorCode
}
public protocol USARTHandleIO {
  func read(_ word: USARTConfigurationWord) -> UInt32
  func write(_ word: USARTConfigurationWord, value: UInt32)
  func read(_ word: UARTHandleHalfWord) -> UInt16
  func write(_ word: UARTHandleHalfWord, value: UInt16)
  func read(_ word: USARTHandleWord) -> UInt32
  func write(_ word: USARTHandleWord, value: UInt32)
  func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer?
  func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?)
}
public enum USARTState: UInt32, Sendable {
  case reset = 0
  case ready = 1
  case busy = 2
  case busyTransmit = 0x12
  case busyReceive = 0x22
  case busyTransmitReceive = 0x32
  case timeout = 3
  case error = 4
}
public struct USARTError: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let parity = Self(rawValue: 1)
  public static let noise = Self(rawValue: 2)
  public static let framing = Self(rawValue: 4)
  public static let overrun = Self(rawValue: 8)
  public static let dma = Self(rawValue: 0x10)
  public static let underrun = Self(rawValue: 0x20)
  public static let invalidCallback = Self(rawValue: 0x40)
  public static let receiverTimeout = Self(rawValue: 0x80)
}
public struct USARTConfiguration: Equatable, Sendable {
  public var baudRate: UInt32
  public var wordLength: UInt32
  public var stopBits: UInt32
  public var parity: UInt32
  public var mode: UInt32
  public var clockPolarity: UInt32
  public var clockPhase: UInt32
  public var clockLastBit: UInt32
  public var clockPrescaler: UInt32
  public init(
    baudRate: UInt32 = 115_200, wordLength: UInt32 = 0, stopBits: UInt32 = 0, parity: UInt32 = 0,
    mode: UInt32 = 12, clockPolarity: UInt32 = 0, clockPhase: UInt32 = 0, clockLastBit: UInt32 = 0,
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
    self.clockPrescaler = clockPrescaler
  }
}
extension USARTHandleIO {
  public func setConfiguration(_ configuration: USARTConfiguration) {
    write(.baudRate, value: configuration.baudRate)
    write(.wordLength, value: configuration.wordLength)
    write(.stopBits, value: configuration.stopBits)
    write(.parity, value: configuration.parity)
    write(.mode, value: configuration.mode)
    write(.clockPolarity, value: configuration.clockPolarity)
    write(.clockPhase, value: configuration.clockPhase)
    write(.clockLastBit, value: configuration.clockLastBit)
    write(.clockPrescaler, value: configuration.clockPrescaler)
  }
  public func getConfiguration() -> USARTConfiguration {
    .init(
      baudRate: read(.baudRate), wordLength: read(.wordLength), stopBits: read(.stopBits),
      parity: read(.parity), mode: read(.mode), clockPolarity: read(.clockPolarity),
      clockPhase: read(.clockPhase), clockLastBit: read(.clockLastBit),
      clockPrescaler: read(.clockPrescaler))
  }
}
public typealias USARTCallback = UARTCallback
public enum USARTCallbackID: UInt32, CaseIterable {
  case transmitHalfComplete = 0
  case transmitComplete = 1
  case receiveHalfComplete = 2
  case receiveComplete = 3
  case transmitReceiveComplete = 4
  case error = 5
  case abortComplete = 6
  case receiveFIFOFull = 7
  case transmitFIFOEmpty = 8
  case mspInitialize = 9
  case mspDeinitialize = 10
}
public protocol USARTCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: USARTCallbackID) -> USARTCallback?
  func write(_ id: USARTCallbackID, value: USARTCallback?)
}
public struct USARTCallbackDefaults {
  public let transmitHalfComplete: USARTCallback
  public let transmitComplete: USARTCallback
  public let receiveHalfComplete: USARTCallback
  public let receiveComplete: USARTCallback
  public let transmitReceiveComplete: USARTCallback
  public let error: USARTCallback
  public let abortComplete: USARTCallback
  public let receiveFIFOFull: USARTCallback
  public let transmitFIFOEmpty: USARTCallback
  public let mspInitialize: USARTCallback
  public let mspDeinitialize: USARTCallback
  public init(
    transmitHalfComplete: @escaping USARTCallback = { _ in },
    transmitComplete: @escaping USARTCallback = { _ in },
    receiveHalfComplete: @escaping USARTCallback = { _ in },
    receiveComplete: @escaping USARTCallback = { _ in },
    transmitReceiveComplete: @escaping USARTCallback = { _ in },
    error: @escaping USARTCallback = { _ in },
    abortComplete: @escaping USARTCallback = { _ in },
    receiveFIFOFull: @escaping USARTCallback = { _ in },
    transmitFIFOEmpty: @escaping USARTCallback = { _ in },
    mspInitialize: @escaping USARTCallback = { _ in },
    mspDeinitialize: @escaping USARTCallback = { _ in }
  ) {
    self.transmitHalfComplete = transmitHalfComplete
    self.transmitComplete = transmitComplete
    self.receiveHalfComplete = receiveHalfComplete
    self.receiveComplete = receiveComplete
    self.transmitReceiveComplete = transmitReceiveComplete
    self.error = error
    self.abortComplete = abortComplete
    self.receiveFIFOFull = receiveFIFOFull
    self.transmitFIFOEmpty = transmitFIFOEmpty
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  public func callback(_ id: USARTCallbackID) -> USARTCallback {
    switch id {
    case .transmitHalfComplete: return transmitHalfComplete
    case .transmitComplete: return transmitComplete
    case .receiveHalfComplete: return receiveHalfComplete
    case .receiveComplete: return receiveComplete
    case .transmitReceiveComplete: return transmitReceiveComplete
    case .error: return error
    case .abortComplete: return abortComplete
    case .receiveFIFOFull: return receiveFIFOFull
    case .transmitFIFOEmpty: return transmitFIFOEmpty
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct USARTUnregisteredCallbacks: USARTCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: USARTCallbackID) -> USARTCallback? { nil }
  public func write(_ id: USARTCallbackID, value: USARTCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct USART<
  Registers: UARTRegisterIO, Handle: USARTHandleIO,
  Callbacks: USARTCallbackIO, DMAIO: UARTDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: USARTCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: USARTCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
}
