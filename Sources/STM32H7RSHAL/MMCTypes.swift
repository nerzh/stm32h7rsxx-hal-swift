// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias MMCConfigurationWord = SDConfigurationWord
public enum MMCHandleWord: Int, CaseIterable {
  case lock = 0
  case transmitSize = 1
  case receiveSize = 2
  case transferContext = 3
  case state = 4
  case errorCode = 5
}
public enum MMCCardWord: Int, CaseIterable {
  case cardType = 0
  case cardClass = 1
  case relativeCardAddress = 2
  case blockCount = 3
  case blockSize = 4
  case logicalBlockCount = 5
  case logicalBlockSize = 6
}
public typealias MMCCardRegister = SDCardRegister
public protocol MMCHandleIO {
  func read(_ word: MMCConfigurationWord) -> UInt32
  func write(_ word: MMCConfigurationWord, value: UInt32)
  func read(_ word: MMCHandleWord) -> UInt32
  func write(_ word: MMCHandleWord, value: UInt32)
  func read(_ word: MMCCardWord) -> UInt32
  func write(_ word: MMCCardWord, value: UInt32)
  func readRPMBErrorCode() -> UInt16
  func writeRPMBErrorCode(_ value: UInt16)
  func extendedCSDPointer() -> UnsafeMutablePointer<UInt32>
  func readCardRegister(_ register: MMCCardRegister, index: Int) -> UInt32
  func writeCardRegister(_ register: MMCCardRegister, index: Int, value: UInt32)
  func readTransmitBuffer() -> UnsafePointer<UInt8>?
  func writeTransmitBuffer(_ value: UnsafePointer<UInt8>?)
  func readReceiveBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeReceiveBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
extension MMCHandleIO {
  public func setConfiguration(_ value: SDMMCConfiguration) {
    write(.clockEdge, value: value.clockEdge)
    write(.clockPowerSave, value: value.clockPowerSave)
    write(.busWide, value: value.busWide)
    write(.hardwareFlowControl, value: value.hardwareFlowControl)
    write(.clockDivider, value: value.clockDivider)
    write(.transceiverPresent, value: value.transceiverPresent)
  }
  public func setCardInfo(_ value: MMCCardInfo) {
    write(.cardType, value: value.cardType)
    write(.cardClass, value: value.cardClass)
    write(.relativeCardAddress, value: value.relativeCardAddress)
    write(.blockCount, value: value.blockCount)
    write(.blockSize, value: value.blockSize)
    write(.logicalBlockCount, value: value.logicalBlockCount)
    write(.logicalBlockSize, value: value.logicalBlockSize)
  }
}
public typealias MMCCallback = UARTCallback
public typealias MMCCallbackID = SDCallbackID
public protocol MMCCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: MMCCallbackID) -> MMCCallback?
  func write(_ id: MMCCallbackID, value: MMCCallback?)
}
public struct MMCCallbackDefaults {
  public let transmitComplete: MMCCallback
  public let receiveComplete: MMCCallback
  public let error: MMCCallback
  public let abortComplete: MMCCallback
  public let readDMALinkedListBufferComplete: MMCCallback
  public let writeDMALinkedListBufferComplete: MMCCallback
  public let mspInitialize: MMCCallback
  public let mspDeinitialize: MMCCallback
  public init(
    transmitComplete: @escaping MMCCallback = { _ in },
    receiveComplete: @escaping MMCCallback = { _ in }, error: @escaping MMCCallback = { _ in },
    abortComplete: @escaping MMCCallback = { _ in },
    readDMALinkedListBufferComplete: @escaping MMCCallback = { _ in },
    writeDMALinkedListBufferComplete: @escaping MMCCallback = { _ in },
    mspInitialize: @escaping MMCCallback = { _ in },
    mspDeinitialize: @escaping MMCCallback = { _ in }
  ) {
    self.transmitComplete = transmitComplete
    self.receiveComplete = receiveComplete
    self.error = error
    self.abortComplete = abortComplete
    self.readDMALinkedListBufferComplete = readDMALinkedListBufferComplete
    self.writeDMALinkedListBufferComplete = writeDMALinkedListBufferComplete
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  public func callback(_ id: MMCCallbackID) -> MMCCallback {
    switch id {
    case .transmitComplete: return transmitComplete
    case .receiveComplete: return receiveComplete
    case .error: return error
    case .abortComplete: return abortComplete
    case .readDMALinkedListBufferComplete: return readDMALinkedListBufferComplete
    case .writeDMALinkedListBufferComplete: return writeDMALinkedListBufferComplete
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct MMCUnregisteredCallbacks: MMCCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: MMCCallbackID) -> MMCCallback? { nil }
  public func write(_ id: MMCCallbackID, value: MMCCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct MMC<
  Registers: SDMMCRegisterIO, Handle: MMCHandleIO, Callbacks: MMCCallbackIO, Memory: DMAMemoryIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let memory: Memory
  public let defaults: MMCCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public let lowVoltage: Bool
  public let useSDTransceiver: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, memory: Memory,
    defaults: MMCCallbackDefaults = .init(), useRegisteredCallbacks: Bool = true,
    lowVoltage: Bool = false, useSDTransceiver: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.memory = memory
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
    self.lowVoltage = lowVoltage
    self.useSDTransceiver = useSDTransceiver
  }
  public var sdmmc: SDMMC<Registers> { .init(registers: registers) }
  public var linkedList: SDMMCDMALinkedList<Memory> { .init(memory: memory) }
  func modify(_ register: SDMMCRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
