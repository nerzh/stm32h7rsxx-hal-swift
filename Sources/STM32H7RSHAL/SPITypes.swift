// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias SPIRegister = I2SRegister
public enum SPIInstance: UInt32, CaseIterable {
  case spi1 = 1_107_308_544
  case spi2 = 1_073_756_160
  case spi3 = 1_073_757_184
  case spi4 = 1_107_309_568
  case spi5 = 1_107_316_736
  case spi6 = 1_476_400_128
}
public protocol SPIRegisterIO {
  var instance: SPIInstance { get }
  func read(_ register: SPIRegister) -> UInt32
  func write(_ register: SPIRegister, value: UInt32)
  func address(of register: SPIRegister) -> UInt32
  func read8(_ register: SPIRegister) -> UInt8
  func write8(_ register: SPIRegister, value: UInt8)
  func read16(_ register: SPIRegister) -> UInt16
  func write16(_ register: SPIRegister, value: UInt16)
}
public enum SPIConfigurationWord: Int, CaseIterable {
  case mode = 0
  case direction = 1
  case dataSize = 2
  case clockPolarity = 3
  case clockPhase = 4
  case nss = 5
  case baudRatePrescaler = 6
  case firstBit = 7
  case tiMode = 8
  case crcCalculation = 9
  case crcPolynomial = 10
  case crcLength = 11
  case nssPulseMode = 12
  case nssPolarity = 13
  case fifoThreshold = 14
  case transmitCRCInitializationPattern = 15
  case receiveCRCInitializationPattern = 16
  case masterSSIdleness = 17
  case masterInterDataIdleness = 18
  case masterReceiverAutoSuspend = 19
  case masterKeepIOState = 20
  case ioSwap = 21
  case readyMasterManagement = 22
  case readyPolarity = 23
}
public enum SPIHandleWord: Int, CaseIterable {
  case crcSize = 0
  case receiveISR = 1
  case transmitISR = 2
  case lock = 3
  case state = 4
  case errorCode = 5
}
public enum SPIHandleHalfWord: Int, CaseIterable {
  case transmitSize = 0
  case transmitCount = 1
  case receiveSize = 2
  case receiveCount = 3
}
public enum SPITransferISR: UInt32, CaseIterable {
  case none = 0
  case transmit8 = 1
  case transmit16 = 2
  case transmit32 = 3
  case receive8 = 4
  case receive16 = 5
  case receive32 = 6
}
public struct SPIConfiguration: Equatable, Sendable {
  public var mode: UInt32
  public var direction: UInt32
  public var dataSize: UInt32
  public var clockPolarity: UInt32
  public var clockPhase: UInt32
  public var nss: UInt32
  public var baudRatePrescaler: UInt32
  public var firstBit: UInt32
  public var tiMode: UInt32
  public var crcCalculation: UInt32
  public var crcPolynomial: UInt32
  public var crcLength: UInt32
  public var nssPulseMode: UInt32
  public var nssPolarity: UInt32
  public var fifoThreshold: UInt32
  public var transmitCRCInitializationPattern: UInt32
  public var receiveCRCInitializationPattern: UInt32
  public var masterSSIdleness: UInt32
  public var masterInterDataIdleness: UInt32
  public var masterReceiverAutoSuspend: UInt32
  public var masterKeepIOState: UInt32
  public var ioSwap: UInt32
  public var readyMasterManagement: UInt32
  public var readyPolarity: UInt32
  public init(
    mode: UInt32 = 0, direction: UInt32 = 0, dataSize: UInt32 = 0, clockPolarity: UInt32 = 0,
    clockPhase: UInt32 = 0, nss: UInt32 = 0, baudRatePrescaler: UInt32 = 0, firstBit: UInt32 = 0,
    tiMode: UInt32 = 0, crcCalculation: UInt32 = 0, crcPolynomial: UInt32 = 0,
    crcLength: UInt32 = 0, nssPulseMode: UInt32 = 0, nssPolarity: UInt32 = 0,
    fifoThreshold: UInt32 = 0, transmitCRCInitializationPattern: UInt32 = 0,
    receiveCRCInitializationPattern: UInt32 = 0, masterSSIdleness: UInt32 = 0,
    masterInterDataIdleness: UInt32 = 0, masterReceiverAutoSuspend: UInt32 = 0,
    masterKeepIOState: UInt32 = 0, ioSwap: UInt32 = 0, readyMasterManagement: UInt32 = 0,
    readyPolarity: UInt32 = 0
  ) {
    self.mode = mode
    self.direction = direction
    self.dataSize = dataSize
    self.clockPolarity = clockPolarity
    self.clockPhase = clockPhase
    self.nss = nss
    self.baudRatePrescaler = baudRatePrescaler
    self.firstBit = firstBit
    self.tiMode = tiMode
    self.crcCalculation = crcCalculation
    self.crcPolynomial = crcPolynomial
    self.crcLength = crcLength
    self.nssPulseMode = nssPulseMode
    self.nssPolarity = nssPolarity
    self.fifoThreshold = fifoThreshold
    self.transmitCRCInitializationPattern = transmitCRCInitializationPattern
    self.receiveCRCInitializationPattern = receiveCRCInitializationPattern
    self.masterSSIdleness = masterSSIdleness
    self.masterInterDataIdleness = masterInterDataIdleness
    self.masterReceiverAutoSuspend = masterReceiverAutoSuspend
    self.masterKeepIOState = masterKeepIOState
    self.ioSwap = ioSwap
    self.readyMasterManagement = readyMasterManagement
    self.readyPolarity = readyPolarity
  }
}
public protocol SPIHandleIO {
  func read(_ word: SPIConfigurationWord) -> UInt32
  func write(_ word: SPIConfigurationWord, value: UInt32)
  func read(_ word: SPIHandleWord) -> UInt32
  func write(_ word: SPIHandleWord, value: UInt32)
  func read(_ word: SPIHandleHalfWord) -> UInt16
  func write(_ word: SPIHandleHalfWord, value: UInt16)
  func readPointer(_ direction: UARTBufferPointer) -> UnsafeMutableRawPointer?
  func writePointer(_ direction: UARTBufferPointer, value: UnsafeMutableRawPointer?)
}
extension SPIHandleIO {
  public func setConfiguration(_ value: SPIConfiguration) {
    write(.mode, value: value.mode)
    write(.direction, value: value.direction)
    write(.dataSize, value: value.dataSize)
    write(.clockPolarity, value: value.clockPolarity)
    write(.clockPhase, value: value.clockPhase)
    write(.nss, value: value.nss)
    write(.baudRatePrescaler, value: value.baudRatePrescaler)
    write(.firstBit, value: value.firstBit)
    write(.tiMode, value: value.tiMode)
    write(.crcCalculation, value: value.crcCalculation)
    write(.crcPolynomial, value: value.crcPolynomial)
    write(.crcLength, value: value.crcLength)
    write(.nssPulseMode, value: value.nssPulseMode)
    write(.nssPolarity, value: value.nssPolarity)
    write(.fifoThreshold, value: value.fifoThreshold)
    write(.transmitCRCInitializationPattern, value: value.transmitCRCInitializationPattern)
    write(.receiveCRCInitializationPattern, value: value.receiveCRCInitializationPattern)
    write(.masterSSIdleness, value: value.masterSSIdleness)
    write(.masterInterDataIdleness, value: value.masterInterDataIdleness)
    write(.masterReceiverAutoSuspend, value: value.masterReceiverAutoSuspend)
    write(.masterKeepIOState, value: value.masterKeepIOState)
    write(.ioSwap, value: value.ioSwap)
    write(.readyMasterManagement, value: value.readyMasterManagement)
    write(.readyPolarity, value: value.readyPolarity)
  }
}
public typealias SPICallback = UARTCallback
public enum SPICallbackID: UInt32, CaseIterable {
  case transmitComplete = 0
  case receiveComplete = 1
  case transmitReceiveComplete = 2
  case transmitHalfComplete = 3
  case receiveHalfComplete = 4
  case transmitReceiveHalfComplete = 5
  case error = 6
  case abortComplete = 7
  case suspend = 8
  case mspInitialize = 9
  case mspDeinitialize = 10
}
public protocol SPICallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: SPICallbackID) -> SPICallback?
  func write(_ id: SPICallbackID, value: SPICallback?)
}
private func spiNoop(_ context: UnsafeMutableRawPointer?) {}
public struct SPICallbackDefaults {
  public var transmitComplete: SPICallback
  public var receiveComplete: SPICallback
  public var transmitReceiveComplete: SPICallback
  public var transmitHalfComplete: SPICallback
  public var receiveHalfComplete: SPICallback
  public var transmitReceiveHalfComplete: SPICallback
  public var error: SPICallback
  public var abortComplete: SPICallback
  public var suspend: SPICallback
  public var mspInitialize: SPICallback
  public var mspDeinitialize: SPICallback
  public init(
    transmitComplete: @escaping SPICallback = { _ in },
    receiveComplete: @escaping SPICallback = { _ in },
    transmitReceiveComplete: @escaping SPICallback = { _ in },
    transmitHalfComplete: @escaping SPICallback = { _ in },
    receiveHalfComplete: @escaping SPICallback = { _ in },
    transmitReceiveHalfComplete: @escaping SPICallback = { _ in },
    error: @escaping SPICallback = { _ in }, abortComplete: @escaping SPICallback = { _ in },
    suspend: @escaping SPICallback = { _ in }, mspInitialize: @escaping SPICallback = { _ in },
    mspDeinitialize: @escaping SPICallback = { _ in }
  ) {
    self.transmitComplete = transmitComplete
    self.receiveComplete = receiveComplete
    self.transmitReceiveComplete = transmitReceiveComplete
    self.transmitHalfComplete = transmitHalfComplete
    self.receiveHalfComplete = receiveHalfComplete
    self.transmitReceiveHalfComplete = transmitReceiveHalfComplete
    self.error = error
    self.abortComplete = abortComplete
    self.suspend = suspend
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  func callback(_ id: SPICallbackID) -> SPICallback {
    switch id {
    case .transmitComplete: return transmitComplete
    case .receiveComplete: return receiveComplete
    case .transmitReceiveComplete: return transmitReceiveComplete
    case .transmitHalfComplete: return transmitHalfComplete
    case .receiveHalfComplete: return receiveHalfComplete
    case .transmitReceiveHalfComplete: return transmitReceiveHalfComplete
    case .error: return error
    case .abortComplete: return abortComplete
    case .suspend: return suspend
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct SPIUnregisteredCallbacks: SPICallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: SPICallbackID) -> SPICallback? { nil }
  public func write(_ id: SPICallbackID, value: SPICallback?) {
    preconditionFailure("Registered callback storage is unavailable")
  }
}
public enum SPIDMACallbackKind: UInt32, CaseIterable {
  case transmitComplete = 0
  case receiveComplete = 1
  case transmitReceiveComplete = 2
  case transmitHalfComplete = 3
  case receiveHalfComplete = 4
  case transmitReceiveHalfComplete = 5
  case error = 6
  case abortOnError = 7
  case transmitAbort = 8
  case receiveAbort = 9
}
public typealias SPIDMACallbackContext = UARTDMACallbackContext
public protocol SPIDMAEventSourceIO {
  func readErrorCode() -> UInt32
}
public protocol SPIDMAIO {
  func isPresent(_ direction: UARTDMADirection) -> Bool
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32)
  func readSourceDataWidth(_ direction: UARTDMADirection) -> UInt32
  func readDestinationDataWidth(_ direction: UARTDMADirection) -> UInt32
  func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback?
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: SPIDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus
  func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus
}
public struct SPI<
  Registers: SPIRegisterIO, Handle: SPIHandleIO, Callbacks: SPICallbackIO, DMAIO: SPIDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: SPICallbackDefaults
  public let useRegisteredCallbacks: Bool
  public let useCRC: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: SPICallbackDefaults = .init(), useRegisteredCallbacks: Bool = false,
    useCRC: Bool = true
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
    self.useCRC = useCRC
  }
  func lock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func invoke(_ id: SPICallbackID) {
    (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
  }
  func modify(_ register: SPIRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
