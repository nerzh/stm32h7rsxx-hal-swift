// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NAND operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum NANDConfigurationWord: Int, CaseIterable {
  case bank = 0
  case waitFeature = 1
  case memoryDataWidth = 2
  case eccComputation = 3
  case eccPageSize = 4
  case tclrSetupTime = 5
  case tarSetupTime = 6
}
public enum NANDHandleWord: Int, CaseIterable {
  case lock = 0
  case state = 1
}
public enum NANDDeviceConfigurationWord: Int, CaseIterable {
  case pageSize = 0
  case spareAreaSize = 1
  case blockSize = 2
  case blockCount = 3
  case planeCount = 4
  case planeSize = 5
  case extraCommandEnable = 6
}
public enum NANDCallbackID: UInt32, CaseIterable {
  case mspInitialize = 0
  case mspDeinitialize = 1
  case interrupt = 2
}
public protocol NANDHandleIO {
  func read(_ word: NANDConfigurationWord) -> UInt32
  func write(_ word: NANDConfigurationWord, value: UInt32)
  func read(_ word: NANDHandleWord) -> UInt32
  func write(_ word: NANDHandleWord, value: UInt32)
  func read(_ word: NANDDeviceConfigurationWord) -> UInt32
  func write(_ word: NANDDeviceConfigurationWord, value: UInt32)
}
extension NANDHandleIO {
  public func setConfiguration(_ value: FMCNANDConfiguration) {
    write(.bank, value: value.bank)
    write(.waitFeature, value: value.waitFeature)
    write(.memoryDataWidth, value: value.memoryDataWidth)
    write(.eccComputation, value: value.eccComputation)
    write(.eccPageSize, value: value.eccPageSize)
    write(.tclrSetupTime, value: value.tclrSetupTime)
    write(.tarSetupTime, value: value.tarSetupTime)
  }
  public func setDeviceConfiguration(_ value: NANDDeviceConfiguration) {
    write(.pageSize, value: value.pageSize)
    write(.spareAreaSize, value: value.spareAreaSize)
    write(.blockSize, value: value.blockSize)
    write(.blockCount, value: value.blockCount)
    write(.planeCount, value: value.planeCount)
    write(.planeSize, value: value.planeSize)
    write(.extraCommandEnable, value: value.extraCommandEnable)
  }
}
public typealias NANDCallback = UARTCallback
public protocol NANDCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: NANDCallbackID) -> NANDCallback?
  func write(_ id: NANDCallbackID, value: NANDCallback?)
}
public struct NANDCallbackDefaults {
  public let mspInitialize: NANDCallback
  public let mspDeinitialize: NANDCallback
  public let interrupt: NANDCallback
  public init(
    mspInitialize: @escaping NANDCallback = { _ in },
    mspDeinitialize: @escaping NANDCallback = { _ in }, interrupt: @escaping NANDCallback = { _ in }
  ) {
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.interrupt = interrupt
  }
  public func callback(_ id: NANDCallbackID) -> NANDCallback {
    switch id {
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    case .interrupt: return interrupt
    }
  }
}
public struct NANDUnregisteredCallbacks: NANDCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: NANDCallbackID) -> NANDCallback? { nil }
  public func write(_ id: NANDCallbackID, value: NANDCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct NAND<
  Registers: FMCRegisterIO, Handle: NANDHandleIO, Callbacks: NANDCallbackIO, Memory: FMCMemoryIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let memory: Memory
  public let defaults: NANDCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, memory: Memory,
    defaults: NANDCallbackDefaults = .init(), useRegisteredCallbacks: Bool = true
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.memory = memory
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  public var fmc: FMC<Registers> { .init(registers: registers) }
}
