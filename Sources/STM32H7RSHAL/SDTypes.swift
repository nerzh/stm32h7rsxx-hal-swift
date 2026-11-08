// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SDConfigurationWord: Int, CaseIterable {
  case clockEdge = 0
  case clockPowerSave = 1
  case busWide = 2
  case hardwareFlowControl = 3
  case clockDivider = 4
  case transceiverPresent = 5
}
public enum SDHandleWord: Int, CaseIterable {
  case lock = 0
  case transmitSize = 1
  case receiveSize = 2
  case transferContext = 3
  case state = 4
  case errorCode = 5
}
public enum SDCardWord: Int, CaseIterable {
  case cardType = 0
  case cardVersion = 1
  case cardClass = 2
  case relativeCardAddress = 3
  case blockCount = 4
  case blockSize = 5
  case logicalBlockCount = 6
  case logicalBlockSize = 7
  case cardSpeed = 8
}
public enum SDCardRegister: Int, CaseIterable {
  case csd = 0
  case cid = 1
}
public protocol SDHandleIO {
  func read(_ word: SDConfigurationWord) -> UInt32
  func write(_ word: SDConfigurationWord, value: UInt32)
  func read(_ word: SDHandleWord) -> UInt32
  func write(_ word: SDHandleWord, value: UInt32)
  func read(_ word: SDCardWord) -> UInt32
  func write(_ word: SDCardWord, value: UInt32)
  func readCardRegister(_ register: SDCardRegister, index: Int) -> UInt32
  func writeCardRegister(_ register: SDCardRegister, index: Int, value: UInt32)
  func readTransmitBuffer() -> UnsafePointer<UInt8>?
  func writeTransmitBuffer(_ value: UnsafePointer<UInt8>?)
  func readReceiveBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeReceiveBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
extension SDHandleIO {
  public func setConfiguration(_ value: SDMMCConfiguration) {
    write(.clockEdge, value: value.clockEdge)
    write(.clockPowerSave, value: value.clockPowerSave)
    write(.busWide, value: value.busWide)
    write(.hardwareFlowControl, value: value.hardwareFlowControl)
    write(.clockDivider, value: value.clockDivider)
    write(.transceiverPresent, value: value.transceiverPresent)
  }
  public func setCardInfo(_ value: SDCardInfo) {
    write(.cardType, value: value.cardType)
    write(.cardVersion, value: value.cardVersion)
    write(.cardClass, value: value.cardClass)
    write(.relativeCardAddress, value: value.relativeCardAddress)
    write(.blockCount, value: value.blockCount)
    write(.blockSize, value: value.blockSize)
    write(.logicalBlockCount, value: value.logicalBlockCount)
    write(.logicalBlockSize, value: value.logicalBlockSize)
    write(.cardSpeed, value: value.cardSpeed)
  }
}
public typealias SDCallback = UARTCallback
public typealias SDTransceiverCallback = @convention(c) (UInt32) -> Void
public enum SDCallbackID: UInt32, CaseIterable {
  case transmitComplete = 0
  case receiveComplete = 1
  case error = 2
  case abortComplete = 3
  case readDMALinkedListBufferComplete = 4
  case writeDMALinkedListBufferComplete = 5
  case mspInitialize = 16
  case mspDeinitialize = 17
}
public protocol SDCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: SDCallbackID) -> SDCallback?
  func write(_ id: SDCallbackID, value: SDCallback?)
  func readTransceiver() -> SDTransceiverCallback?
  func writeTransceiver(_ value: SDTransceiverCallback?)
}
public struct SDCallbackDefaults {
  public let transmitComplete: SDCallback
  public let receiveComplete: SDCallback
  public let error: SDCallback
  public let abortComplete: SDCallback
  public let readDMALinkedListBufferComplete: SDCallback
  public let writeDMALinkedListBufferComplete: SDCallback
  public let mspInitialize: SDCallback
  public let mspDeinitialize: SDCallback
  public let transceiver: SDTransceiverCallback
  public init(
    transmitComplete: @escaping SDCallback = { _ in },
    receiveComplete: @escaping SDCallback = { _ in }, error: @escaping SDCallback = { _ in },
    abortComplete: @escaping SDCallback = { _ in },
    readDMALinkedListBufferComplete: @escaping SDCallback = { _ in },
    writeDMALinkedListBufferComplete: @escaping SDCallback = { _ in },
    mspInitialize: @escaping SDCallback = { _ in },
    mspDeinitialize: @escaping SDCallback = { _ in },
    transceiver: @escaping SDTransceiverCallback = { _ in }
  ) {
    self.transmitComplete = transmitComplete
    self.receiveComplete = receiveComplete
    self.error = error
    self.abortComplete = abortComplete
    self.readDMALinkedListBufferComplete = readDMALinkedListBufferComplete
    self.writeDMALinkedListBufferComplete = writeDMALinkedListBufferComplete
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.transceiver = transceiver
  }
  public func callback(_ id: SDCallbackID) -> SDCallback {
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
public struct SDUnregisteredCallbacks: SDCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: SDCallbackID) -> SDCallback? { nil }
  public func write(_ id: SDCallbackID, value: SDCallback?) {
    preconditionFailure("Callback storage is absent")
  }
  public func readTransceiver() -> SDTransceiverCallback? { nil }
  public func writeTransceiver(_ value: SDTransceiverCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public protocol SDRegisterIO: SDMMCRegisterIO {
  func readDelayControl() -> UInt32
  func writeDelayControl(_ value: UInt32)
}
public struct SD<
  Registers: SDRegisterIO, Handle: SDHandleIO, Callbacks: SDCallbackIO, Memory: DMAMemoryIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let memory: Memory
  public let defaults: SDCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public let useTransceiver: Bool
  public let useDirectionPolarity: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, memory: Memory,
    defaults: SDCallbackDefaults = .init(), useRegisteredCallbacks: Bool = true,
    useTransceiver: Bool = false, useDirectionPolarity: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.memory = memory
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
    self.useTransceiver = useTransceiver
    self.useDirectionPolarity = useDirectionPolarity
  }
  public var sdmmc: SDMMC<Registers> { .init(registers: registers) }
  public var linkedList: SDMMCDMALinkedList<Memory> { .init(memory: memory) }
  func modify(_ register: SDMMCRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
