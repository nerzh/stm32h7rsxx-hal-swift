// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NOR operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum NORConfigurationWord: Int, CaseIterable {
  case bank = 0
  case dataAddressMux = 1
  case memoryType = 2
  case memoryDataWidth = 3
  case burstAccessMode = 4
  case waitSignalPolarity = 5
  case waitSignalActive = 6
  case writeOperation = 7
  case waitSignal = 8
  case extendedMode = 9
  case asynchronousWait = 10
  case writeBurst = 11
  case continuousClock = 12
  case writeFIFO = 13
  case pageSize = 14
}
public enum NORHandleWord: Int, CaseIterable {
  case lock = 0
  case state = 1
  case commandSet = 2
}
public enum NORCallbackID: UInt32, CaseIterable {
  case mspInitialize = 0
  case mspDeinitialize = 1
}
public protocol NORHandleIO {
  func read(_ word: NORConfigurationWord) -> UInt32
  func write(_ word: NORConfigurationWord, value: UInt32)
  func read(_ word: NORHandleWord) -> UInt32
  func write(_ word: NORHandleWord, value: UInt32)
}
extension NORHandleIO {
  public func setConfiguration(_ value: FMCNORSRAMConfiguration) {
    write(.bank, value: value.bank)
    write(.dataAddressMux, value: value.dataAddressMux)
    write(.memoryType, value: value.memoryType)
    write(.memoryDataWidth, value: value.memoryDataWidth)
    write(.burstAccessMode, value: value.burstAccessMode)
    write(.waitSignalPolarity, value: value.waitSignalPolarity)
    write(.waitSignalActive, value: value.waitSignalActive)
    write(.writeOperation, value: value.writeOperation)
    write(.waitSignal, value: value.waitSignal)
    write(.extendedMode, value: value.extendedMode)
    write(.asynchronousWait, value: value.asynchronousWait)
    write(.writeBurst, value: value.writeBurst)
    write(.continuousClock, value: value.continuousClock)
    write(.writeFIFO, value: value.writeFIFO)
    write(.pageSize, value: value.pageSize)
  }
}
// The original file-global width is shared by every NOR handle. The owner provides
// one initially zero word for all wrappers, including wrappers for different banks.
public protocol NORSharedIO {
  func readMemoryDataWidth() -> UInt32
  func writeMemoryDataWidth(_ value: UInt32)
}
public typealias NORCallback = UARTCallback
public typealias NORWaitCallback = FDCANCallback
public protocol NORCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: NORCallbackID) -> NORCallback?
  func write(_ id: NORCallbackID, value: NORCallback?)
}
public struct NORCallbackDefaults {
  public let mspInitialize: NORCallback
  public let mspDeinitialize: NORCallback
  public let mspWait: NORWaitCallback
  public init(
    mspInitialize: @escaping NORCallback = { _ in },
    mspDeinitialize: @escaping NORCallback = { _ in },
    mspWait: @escaping NORWaitCallback = { _, _ in }
  ) {
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.mspWait = mspWait
  }
  public func callback(_ id: NORCallbackID) -> NORCallback {
    switch id {
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct NORUnregisteredCallbacks: NORCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: NORCallbackID) -> NORCallback? { nil }
  public func write(_ id: NORCallbackID, value: NORCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct NOR<
  Registers: FMCRegisterIO, Handle: NORHandleIO, Shared: NORSharedIO, Callbacks: NORCallbackIO,
  Memory: FMCMemoryIO
> {
  public let registers: Registers
  public let handle: Handle
  public let shared: Shared
  public let callbacks: Callbacks
  public let memory: Memory
  public let defaults: NORCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, shared: Shared, callbacks: Callbacks, memory: Memory,
    defaults: NORCallbackDefaults = .init(), useRegisteredCallbacks: Bool = true
  ) {
    self.registers = registers
    self.handle = handle
    self.shared = shared
    self.callbacks = callbacks
    self.memory = memory
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  public var fmc: FMC<Registers> { .init(registers: registers) }
}
