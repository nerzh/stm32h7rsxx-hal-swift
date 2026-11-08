// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SDRAMConfigurationWord: Int, CaseIterable {
  case bank = 0
  case columnBitsNumber = 1
  case rowBitsNumber = 2
  case memoryDataWidth = 3
  case internalBankNumber = 4
  case casLatency = 5
  case writeProtection = 6
  case sdClockPeriod = 7
  case readBurst = 8
  case readPipeDelay = 9
}
public enum SDRAMHandleWord: Int, CaseIterable {
  case lock = 0
  case state = 1
}
public enum SDRAMCallbackID: UInt32, CaseIterable {
  case mspInitialize = 0
  case mspDeinitialize = 1
  case refreshError = 2
  case dmaComplete = 3
  case dmaError = 4
}
public protocol SDRAMHandleIO {
  func read(_ word: SDRAMConfigurationWord) -> UInt32
  func write(_ word: SDRAMConfigurationWord, value: UInt32)
  func read(_ word: SDRAMHandleWord) -> UInt32
  func write(_ word: SDRAMHandleWord, value: UInt32)
}
extension SDRAMHandleIO {
  public func setConfiguration(_ value: FMCSDRAMConfiguration) {
    write(.bank, value: value.bank)
    write(.columnBitsNumber, value: value.columnBitsNumber)
    write(.rowBitsNumber, value: value.rowBitsNumber)
    write(.memoryDataWidth, value: value.memoryDataWidth)
    write(.internalBankNumber, value: value.internalBankNumber)
    write(.casLatency, value: value.casLatency)
    write(.writeProtection, value: value.writeProtection)
    write(.sdClockPeriod, value: value.sdClockPeriod)
    write(.readBurst, value: value.readBurst)
    write(.readPipeDelay, value: value.readPipeDelay)
  }
}
public typealias SDRAMCallback = UARTCallback
// DMA completion/error callbacks receive the source DMA context, not the memory handle context.
public protocol SDRAMCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: SDRAMCallbackID) -> SDRAMCallback?
  func write(_ id: SDRAMCallbackID, value: SDRAMCallback?)
}
public struct SDRAMCallbackDefaults {
  public let mspInitialize: SDRAMCallback
  public let mspDeinitialize: SDRAMCallback
  public let refreshError: SDRAMCallback
  public let dmaComplete: SDRAMCallback
  public let dmaError: SDRAMCallback
  public init(
    mspInitialize: @escaping SDRAMCallback = { _ in },
    mspDeinitialize: @escaping SDRAMCallback = { _ in },
    refreshError: @escaping SDRAMCallback = { _ in },
    dmaComplete: @escaping SDRAMCallback = { _ in }, dmaError: @escaping SDRAMCallback = { _ in }
  ) {
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.refreshError = refreshError
    self.dmaComplete = dmaComplete
    self.dmaError = dmaError
  }
  public func callback(_ id: SDRAMCallbackID) -> SDRAMCallback {
    switch id {
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    case .refreshError: return refreshError
    case .dmaComplete: return dmaComplete
    case .dmaError: return dmaError
    }
  }
}
public struct SDRAMUnregisteredCallbacks: SDRAMCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: SDRAMCallbackID) -> SDRAMCallback? { nil }
  public func write(_ id: SDRAMCallbackID, value: SDRAMCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct SDRAM<
  Registers: FMCRegisterIO, Handle: SDRAMHandleIO, Callbacks: SDRAMCallbackIO, Memory: FMCMemoryIO,
  DMAIO: FMCDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let memory: Memory
  public let dma: DMAIO
  public let defaults: SDRAMCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, memory: Memory, dma: DMAIO,
    defaults: SDRAMCallbackDefaults = .init(), useRegisteredCallbacks: Bool = true
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.memory = memory
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  public var fmc: FMC<Registers> { .init(registers: registers) }
}
