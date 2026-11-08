// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum I2SRegister: UInt32, CaseIterable {
  case cr1 = 0
  case cr2 = 4
  case cfg1 = 8
  case cfg2 = 12
  case ier = 16
  case sr = 20
  case ifcr = 24
  case txdr = 32
  case rxdr = 48
  case crcpoly = 64
  case txcrc = 68
  case rxcrc = 72
  case udrdr = 76
  case i2scfgr = 80
}
public enum I2SInstance: UInt32, CaseIterable {
  case spi1 = 1_107_308_544
  case spi2 = 1_073_756_160
  case spi3 = 1_073_757_184
  case spi6 = 1_476_400_128
}
public protocol I2SRegisterIO {
  var instance: I2SInstance { get }
  func read(_ register: I2SRegister) -> UInt32
  func write(_ register: I2SRegister, value: UInt32)
  func address(of register: I2SRegister) -> UInt32
  func read16(_ register: I2SRegister) -> UInt16
  func write16(_ register: I2SRegister, value: UInt16)
}
public enum I2SConfigurationWord: Int, CaseIterable {
  case mode = 0
  case standard = 1
  case dataFormat = 2
  case masterClockOutput = 3
  case audioFrequency = 4
  case clockPolarity = 5
  case firstBit = 6
  case wordSelectInversion = 7
  case data24BitAlignment = 8
  case masterKeepIOState = 9
}
public enum I2SHandleWord: Int, CaseIterable {
  case receiveISR = 0
  case transmitISR = 1
  case lock = 2
  case state = 3
  case errorCode = 4
}
public enum I2SHandleHalfWord: Int, CaseIterable {
  case transmitSize = 0
  case transmitCount = 1
  case receiveSize = 2
  case receiveCount = 3
}
public enum I2STransferISR: UInt32, CaseIterable {
  case none = 0
  case transmit16 = 1
  case transmit32 = 2
  case receive16 = 3
  case receive32 = 4
}
public struct I2SConfiguration: Equatable, Sendable {
  public var mode: UInt32
  public var standard: UInt32
  public var dataFormat: UInt32
  public var masterClockOutput: UInt32
  public var audioFrequency: UInt32
  public var clockPolarity: UInt32
  public var firstBit: UInt32
  public var wordSelectInversion: UInt32
  public var data24BitAlignment: UInt32
  public var masterKeepIOState: UInt32
  public init(
    mode: UInt32 = 0, standard: UInt32 = 0, dataFormat: UInt32 = 0, masterClockOutput: UInt32 = 0,
    audioFrequency: UInt32 = 0, clockPolarity: UInt32 = 0, firstBit: UInt32 = 0,
    wordSelectInversion: UInt32 = 0, data24BitAlignment: UInt32 = 0, masterKeepIOState: UInt32 = 0
  ) {
    self.mode = mode
    self.standard = standard
    self.dataFormat = dataFormat
    self.masterClockOutput = masterClockOutput
    self.audioFrequency = audioFrequency
    self.clockPolarity = clockPolarity
    self.firstBit = firstBit
    self.wordSelectInversion = wordSelectInversion
    self.data24BitAlignment = data24BitAlignment
    self.masterKeepIOState = masterKeepIOState
  }
}
public protocol I2SHandleIO {
  func read(_ word: I2SConfigurationWord) -> UInt32
  func write(_ word: I2SConfigurationWord, value: UInt32)
  func read(_ word: I2SHandleWord) -> UInt32
  func write(_ word: I2SHandleWord, value: UInt32)
  func read(_ word: I2SHandleHalfWord) -> UInt16
  func write(_ word: I2SHandleHalfWord, value: UInt16)
  func readPointer(_ direction: UARTBufferPointer) -> UnsafeMutableRawPointer?
  func writePointer(_ direction: UARTBufferPointer, value: UnsafeMutableRawPointer?)
}
extension I2SHandleIO {
  public func setConfiguration(_ value: I2SConfiguration) {
    write(.mode, value: value.mode)
    write(.standard, value: value.standard)
    write(.dataFormat, value: value.dataFormat)
    write(.masterClockOutput, value: value.masterClockOutput)
    write(.audioFrequency, value: value.audioFrequency)
    write(.clockPolarity, value: value.clockPolarity)
    write(.firstBit, value: value.firstBit)
    write(.wordSelectInversion, value: value.wordSelectInversion)
    write(.data24BitAlignment, value: value.data24BitAlignment)
    write(.masterKeepIOState, value: value.masterKeepIOState)
  }
}
public typealias I2SCallback = UARTCallback
public enum I2SCallbackID: UInt32, CaseIterable {
  case transmitComplete = 0
  case receiveComplete = 1
  case transmitReceiveComplete = 2
  case transmitHalfComplete = 3
  case receiveHalfComplete = 4
  case transmitReceiveHalfComplete = 5
  case error = 6
  case mspInitialize = 7
  case mspDeinitialize = 8
}
public protocol I2SCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: I2SCallbackID) -> I2SCallback?
  func write(_ id: I2SCallbackID, value: I2SCallback?)
}
public struct I2SCallbackDefaults {
  public var transmitComplete: I2SCallback
  public var receiveComplete: I2SCallback
  public var transmitReceiveComplete: I2SCallback
  public var transmitHalfComplete: I2SCallback
  public var receiveHalfComplete: I2SCallback
  public var transmitReceiveHalfComplete: I2SCallback
  public var error: I2SCallback
  public var mspInitialize: I2SCallback
  public var mspDeinitialize: I2SCallback
  public init(
    transmitComplete: @escaping I2SCallback = { _ in },
    receiveComplete: @escaping I2SCallback = { _ in },
    transmitReceiveComplete: @escaping I2SCallback = { _ in },
    transmitHalfComplete: @escaping I2SCallback = { _ in },
    receiveHalfComplete: @escaping I2SCallback = { _ in },
    transmitReceiveHalfComplete: @escaping I2SCallback = { _ in },
    error: @escaping I2SCallback = { _ in }, mspInitialize: @escaping I2SCallback = { _ in },
    mspDeinitialize: @escaping I2SCallback = { _ in }
  ) {
    self.transmitComplete = transmitComplete
    self.receiveComplete = receiveComplete
    self.transmitReceiveComplete = transmitReceiveComplete
    self.transmitHalfComplete = transmitHalfComplete
    self.receiveHalfComplete = receiveHalfComplete
    self.transmitReceiveHalfComplete = transmitReceiveHalfComplete
    self.error = error
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  func callback(_ id: I2SCallbackID) -> I2SCallback {
    switch id {
    case .transmitComplete: return transmitComplete
    case .receiveComplete: return receiveComplete
    case .transmitReceiveComplete: return transmitReceiveComplete
    case .transmitHalfComplete: return transmitHalfComplete
    case .receiveHalfComplete: return receiveHalfComplete
    case .transmitReceiveHalfComplete: return transmitReceiveHalfComplete
    case .error: return error
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct I2SUnregisteredCallbacks: I2SCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: I2SCallbackID) -> I2SCallback? { nil }
  public func write(_ id: I2SCallbackID, value: I2SCallback?) {
    preconditionFailure("Registered callback storage is unavailable")
  }
}
public enum I2SDMACallbackKind: UInt32, CaseIterable {
  case transmitComplete = 0
  case transmitHalfComplete = 1
  case receiveComplete = 2
  case receiveHalfComplete = 3
  case transmitReceiveComplete = 4
  case transmitReceiveHalfComplete = 5
  case error = 6
}
public typealias I2SDMACallbackContext = UARTDMACallbackContext
public protocol I2SDMAEventSourceIO {
  func readConfigurationMode() -> UInt32
}
public protocol I2SDMAIO {
  func isPresent(_ direction: UARTDMADirection) -> Bool
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32)
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: I2SDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus
  func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus
}
public struct I2S<
  Registers: I2SRegisterIO, Handle: I2SHandleIO, Callbacks: I2SCallbackIO, DMAIO: I2SDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: I2SCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: I2SCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
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
  func invoke(_ id: I2SCallbackID) {
    (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
  }
  func modify(_ register: I2SRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
