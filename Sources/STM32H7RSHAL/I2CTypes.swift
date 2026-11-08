// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum I2CRegister: UInt32, CaseIterable, Sendable {
  case cr1 = 0
  case cr2 = 4
  case oar1 = 8
  case oar2 = 12
  case timingr = 16
  case timeoutr = 20
  case isr = 24
  case icr = 28
  case pecr = 32
  case rxdr = 36
  case txdr = 40
}
public protocol I2CRegisterIO {
  func read(_ register: I2CRegister) -> UInt32
  func write(_ register: I2CRegister, value: UInt32)
  func address(of register: I2CRegister) -> UInt32
}
public enum I2CConfigurationWord: Int, CaseIterable {
  case timing = 0
  case ownAddress1 = 1
  case addressingMode = 2
  case dualAddressMode = 3
  case ownAddress2 = 4
  case ownAddress2Masks = 5
  case generalCallMode = 6
  case noStretchMode = 7
}
public enum I2CHandleWord: Int, CaseIterable {
  case state = 0
  case mode = 1
  case errorCode = 2
  case lock = 3
  case transferOptions = 4
  case previousState = 5
  case transferISR = 6
  case addressEventCount = 7
  case deviceAddress = 8
  case memoryAddress = 9
}
public enum I2CHandleHalfWord: Int, CaseIterable {
  case transferSize = 0
  case transferCount = 1
}
public enum I2CTransferISR: UInt32, Sendable {
  case none = 0
  case masterInterrupt = 1
  case memoryInterrupt = 2
  case slaveInterrupt = 3
  case masterDMA = 4
  case memoryDMA = 5
  case slaveDMA = 6
}
public struct I2CConfiguration: Equatable, Sendable {
  public var timing: UInt32
  public var ownAddress1: UInt32
  public var addressingMode: UInt32
  public var dualAddressMode: UInt32
  public var ownAddress2: UInt32
  public var ownAddress2Masks: UInt32
  public var generalCallMode: UInt32
  public var noStretchMode: UInt32
  public init(
    timing: UInt32 = 0, ownAddress1: UInt32 = 0, addressingMode: UInt32 = 0,
    dualAddressMode: UInt32 = 0, ownAddress2: UInt32 = 0, ownAddress2Masks: UInt32 = 0,
    generalCallMode: UInt32 = 0, noStretchMode: UInt32 = 0
  ) {
    self.timing = timing
    self.ownAddress1 = ownAddress1
    self.addressingMode = addressingMode
    self.dualAddressMode = dualAddressMode
    self.ownAddress2 = ownAddress2
    self.ownAddress2Masks = ownAddress2Masks
    self.generalCallMode = generalCallMode
    self.noStretchMode = noStretchMode
  }
}
public protocol I2CHandleIO {
  func read(_ word: I2CConfigurationWord) -> UInt32
  func write(_ word: I2CConfigurationWord, value: UInt32)
  func read(_ word: I2CHandleWord) -> UInt32
  func write(_ word: I2CHandleWord, value: UInt32)
  func read(_ word: I2CHandleHalfWord) -> UInt16
  func write(_ word: I2CHandleHalfWord, value: UInt16)
  func readBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
extension I2CHandleIO {
  public func setConfiguration(_ value: I2CConfiguration) {
    write(.timing, value: value.timing)
    write(.ownAddress1, value: value.ownAddress1)
    write(.addressingMode, value: value.addressingMode)
    write(.dualAddressMode, value: value.dualAddressMode)
    write(.ownAddress2, value: value.ownAddress2)
    write(.ownAddress2Masks, value: value.ownAddress2Masks)
    write(.generalCallMode, value: value.generalCallMode)
    write(.noStretchMode, value: value.noStretchMode)
  }
}
public typealias I2CCallback = UARTCallback
public typealias I2CAddressCallback =
  @convention(c) (UnsafeMutableRawPointer?, UInt8, UInt16) -> Void
public enum I2CCallbackID: UInt32, CaseIterable {
  case masterTransmitComplete = 0
  case masterReceiveComplete = 1
  case slaveTransmitComplete = 2
  case slaveReceiveComplete = 3
  case listenComplete = 4
  case memoryTransmitComplete = 5
  case memoryReceiveComplete = 6
  case error = 7
  case abortComplete = 8
  case mspInitialize = 9
  case mspDeinitialize = 10
}
public protocol I2CCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: I2CCallbackID) -> I2CCallback?
  func write(_ id: I2CCallbackID, value: I2CCallback?)
  func readAddress() -> I2CAddressCallback?
  func writeAddress(_ value: I2CAddressCallback?)
}
public struct I2CCallbackDefaults {
  public let masterTransmitComplete: I2CCallback
  public let masterReceiveComplete: I2CCallback
  public let slaveTransmitComplete: I2CCallback
  public let slaveReceiveComplete: I2CCallback
  public let listenComplete: I2CCallback
  public let memoryTransmitComplete: I2CCallback
  public let memoryReceiveComplete: I2CCallback
  public let error: I2CCallback
  public let abortComplete: I2CCallback
  public let mspInitialize: I2CCallback
  public let mspDeinitialize: I2CCallback
  public let address: I2CAddressCallback
  public init(
    masterTransmitComplete: @escaping I2CCallback = { _ in },
    masterReceiveComplete: @escaping I2CCallback = { _ in },
    slaveTransmitComplete: @escaping I2CCallback = { _ in },
    slaveReceiveComplete: @escaping I2CCallback = { _ in },
    listenComplete: @escaping I2CCallback = { _ in },
    memoryTransmitComplete: @escaping I2CCallback = { _ in },
    memoryReceiveComplete: @escaping I2CCallback = { _ in },
    error: @escaping I2CCallback = { _ in }, abortComplete: @escaping I2CCallback = { _ in },
    mspInitialize: @escaping I2CCallback = { _ in },
    mspDeinitialize: @escaping I2CCallback = { _ in },
    address: @escaping I2CAddressCallback = { _, _, _ in }
  ) {
    self.masterTransmitComplete = masterTransmitComplete
    self.masterReceiveComplete = masterReceiveComplete
    self.slaveTransmitComplete = slaveTransmitComplete
    self.slaveReceiveComplete = slaveReceiveComplete
    self.listenComplete = listenComplete
    self.memoryTransmitComplete = memoryTransmitComplete
    self.memoryReceiveComplete = memoryReceiveComplete
    self.error = error
    self.abortComplete = abortComplete
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.address = address
  }
  public func callback(_ id: I2CCallbackID) -> I2CCallback {
    switch id {
    case .masterTransmitComplete: return masterTransmitComplete
    case .masterReceiveComplete: return masterReceiveComplete
    case .slaveTransmitComplete: return slaveTransmitComplete
    case .slaveReceiveComplete: return slaveReceiveComplete
    case .listenComplete: return listenComplete
    case .memoryTransmitComplete: return memoryTransmitComplete
    case .memoryReceiveComplete: return memoryReceiveComplete
    case .error: return error
    case .abortComplete: return abortComplete
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct I2CUnregisteredCallbacks: I2CCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: I2CCallbackID) -> I2CCallback? { nil }
  public func write(_ id: I2CCallbackID, value: I2CCallback?) {
    preconditionFailure("Callback storage is absent")
  }
  public func readAddress() -> I2CAddressCallback? { nil }
  public func writeAddress(_ value: I2CAddressCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public enum I2CDMACallbackKind: UInt32, CaseIterable {
  case masterTransmitComplete = 0
  case masterReceiveComplete, slaveTransmitComplete, slaveReceiveComplete, error, abort
}
// Reuse the existing DMA parent/dispatcher descriptor and transfer directions.
public typealias I2CDMACallbackContext = UARTDMACallbackContext
public protocol I2CDMAIO {
  func isPresent(_ direction: UARTDMADirection) -> Bool
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32
  func getCounter(_ direction: UARTDMADirection) -> UInt32
  func getFIFOLevel(_ direction: UARTDMADirection) -> UInt32
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32)
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?)
  func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID)
  func callback(_ kind: I2CDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus
}
public struct I2C<
  Registers: I2CRegisterIO, Handle: I2CHandleIO, Callbacks: I2CCallbackIO, DMAIO: I2CDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: I2CCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: I2CCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  func modify(_ register: I2CRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
  func lock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func invoke(_ id: I2CCallbackID) {
    (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
  }
  func invokeAddress(direction: UInt8, match: UInt16) {
    (useRegisteredCallbacks ? callbacks.readAddress()! : defaults.address)(
      callbacks.context, direction, match)
  }
  func advanceBuffer(_ count: UInt32) {
    handle.writeBuffer(
      UnsafeMutablePointer<UInt8>(bitPattern: UInt(bitPattern: handle.readBuffer()) &+ UInt(count)))
  }
}
