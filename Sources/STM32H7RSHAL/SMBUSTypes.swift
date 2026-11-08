// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias SMBUSRegister = I2CRegister
public typealias SMBUSRegisterIO = I2CRegisterIO
public enum SMBUSConfigurationWord: Int, CaseIterable {
  case timing = 0
  case analogFilter = 1
  case ownAddress1 = 2
  case addressingMode = 3
  case dualAddressMode = 4
  case ownAddress2 = 5
  case ownAddress2Masks = 6
  case generalCallMode = 7
  case noStretchMode = 8
  case packetErrorCheckMode = 9
  case peripheralMode = 10
  case smbusTimeout = 11
}
public enum SMBUSHandleWord: Int, CaseIterable {
  case state = 0
  case errorCode = 1
  case lock = 2
  case transferOptions = 3
  case previousState = 4
}
public enum SMBUSHandleHalfWord: Int, CaseIterable {
  case transferSize = 0
  case transferCount = 1
}
public struct SMBUSConfiguration: Equatable, Sendable {
  public var timing: UInt32
  public var analogFilter: UInt32
  public var ownAddress1: UInt32
  public var addressingMode: UInt32
  public var dualAddressMode: UInt32
  public var ownAddress2: UInt32
  public var ownAddress2Masks: UInt32
  public var generalCallMode: UInt32
  public var noStretchMode: UInt32
  public var packetErrorCheckMode: UInt32
  public var peripheralMode: UInt32
  public var smbusTimeout: UInt32
  public init(
    timing: UInt32 = 0, analogFilter: UInt32 = 0, ownAddress1: UInt32 = 0,
    addressingMode: UInt32 = 0, dualAddressMode: UInt32 = 0, ownAddress2: UInt32 = 0,
    ownAddress2Masks: UInt32 = 0, generalCallMode: UInt32 = 0, noStretchMode: UInt32 = 0,
    packetErrorCheckMode: UInt32 = 0, peripheralMode: UInt32 = 0, smbusTimeout: UInt32 = 0
  ) {
    self.timing = timing
    self.analogFilter = analogFilter
    self.ownAddress1 = ownAddress1
    self.addressingMode = addressingMode
    self.dualAddressMode = dualAddressMode
    self.ownAddress2 = ownAddress2
    self.ownAddress2Masks = ownAddress2Masks
    self.generalCallMode = generalCallMode
    self.noStretchMode = noStretchMode
    self.packetErrorCheckMode = packetErrorCheckMode
    self.peripheralMode = peripheralMode
    self.smbusTimeout = smbusTimeout
  }
}
public protocol SMBUSHandleIO {
  func read(_ word: SMBUSConfigurationWord) -> UInt32
  func write(_ word: SMBUSConfigurationWord, value: UInt32)
  func read(_ word: SMBUSHandleWord) -> UInt32
  func write(_ word: SMBUSHandleWord, value: UInt32)
  func read(_ word: SMBUSHandleHalfWord) -> UInt16
  func write(_ word: SMBUSHandleHalfWord, value: UInt16)
  func readBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
extension SMBUSHandleIO {
  public func setConfiguration(_ value: SMBUSConfiguration) {
    write(.timing, value: value.timing)
    write(.analogFilter, value: value.analogFilter)
    write(.ownAddress1, value: value.ownAddress1)
    write(.addressingMode, value: value.addressingMode)
    write(.dualAddressMode, value: value.dualAddressMode)
    write(.ownAddress2, value: value.ownAddress2)
    write(.ownAddress2Masks, value: value.ownAddress2Masks)
    write(.generalCallMode, value: value.generalCallMode)
    write(.noStretchMode, value: value.noStretchMode)
    write(.packetErrorCheckMode, value: value.packetErrorCheckMode)
    write(.peripheralMode, value: value.peripheralMode)
    write(.smbusTimeout, value: value.smbusTimeout)
  }
}
public typealias SMBUSCallback = UARTCallback
public typealias SMBUSAddressCallback = I2CAddressCallback
public enum SMBUSCallbackID: UInt32, CaseIterable {
  case masterTransmitComplete = 0
  case masterReceiveComplete = 1
  case slaveTransmitComplete = 2
  case slaveReceiveComplete = 3
  case listenComplete = 4
  case error = 5
  case mspInitialize = 6
  case mspDeinitialize = 7
}
public protocol SMBUSCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: SMBUSCallbackID) -> SMBUSCallback?
  func write(_ id: SMBUSCallbackID, value: SMBUSCallback?)
  func readAddress() -> SMBUSAddressCallback?
  func writeAddress(_ value: SMBUSAddressCallback?)
}
public struct SMBUSCallbackDefaults {
  public let masterTransmitComplete: SMBUSCallback
  public let masterReceiveComplete: SMBUSCallback
  public let slaveTransmitComplete: SMBUSCallback
  public let slaveReceiveComplete: SMBUSCallback
  public let listenComplete: SMBUSCallback
  public let error: SMBUSCallback
  public let mspInitialize: SMBUSCallback
  public let mspDeinitialize: SMBUSCallback
  public let address: SMBUSAddressCallback
  public init(
    masterTransmitComplete: @escaping SMBUSCallback = { _ in },
    masterReceiveComplete: @escaping SMBUSCallback = { _ in },
    slaveTransmitComplete: @escaping SMBUSCallback = { _ in },
    slaveReceiveComplete: @escaping SMBUSCallback = { _ in },
    listenComplete: @escaping SMBUSCallback = { _ in }, error: @escaping SMBUSCallback = { _ in },
    mspInitialize: @escaping SMBUSCallback = { _ in },
    mspDeinitialize: @escaping SMBUSCallback = { _ in },
    address: @escaping SMBUSAddressCallback = { _, _, _ in }
  ) {
    self.masterTransmitComplete = masterTransmitComplete
    self.masterReceiveComplete = masterReceiveComplete
    self.slaveTransmitComplete = slaveTransmitComplete
    self.slaveReceiveComplete = slaveReceiveComplete
    self.listenComplete = listenComplete
    self.error = error
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.address = address
  }
  public func callback(_ id: SMBUSCallbackID) -> SMBUSCallback {
    switch id {
    case .masterTransmitComplete: return masterTransmitComplete
    case .masterReceiveComplete: return masterReceiveComplete
    case .slaveTransmitComplete: return slaveTransmitComplete
    case .slaveReceiveComplete: return slaveReceiveComplete
    case .listenComplete: return listenComplete
    case .error: return error
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct SMBUSUnregisteredCallbacks: SMBUSCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: SMBUSCallbackID) -> SMBUSCallback? { nil }
  public func write(_ id: SMBUSCallbackID, value: SMBUSCallback?) {
    preconditionFailure("Callback storage is absent")
  }
  public func readAddress() -> SMBUSAddressCallback? { nil }
  public func writeAddress(_ value: SMBUSAddressCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct SMBUS<Registers: SMBUSRegisterIO, Handle: SMBUSHandleIO, Callbacks: SMBUSCallbackIO> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let defaults: SMBUSCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks,
    defaults: SMBUSCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  func modify(_ register: SMBUSRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
  func lock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func invoke(_ id: SMBUSCallbackID) {
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
