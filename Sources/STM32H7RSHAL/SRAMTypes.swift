// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SRAMConfigurationWord: Int, CaseIterable {
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
public enum SRAMHandleWord: Int, CaseIterable {
  case lock = 0
  case state = 1
}
public enum SRAMCallbackID: UInt32, CaseIterable {
  case mspInitialize = 0
  case mspDeinitialize = 1
  case dmaComplete = 2
  case dmaError = 3
}
public protocol SRAMHandleIO {
  func read(_ word: SRAMConfigurationWord) -> UInt32
  func write(_ word: SRAMConfigurationWord, value: UInt32)
  func read(_ word: SRAMHandleWord) -> UInt32
  func write(_ word: SRAMHandleWord, value: UInt32)
}
extension SRAMHandleIO {
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
public typealias SRAMCallback = UARTCallback
// DMA completion/error callbacks receive the source DMA context, not the memory handle context.
public protocol SRAMCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: SRAMCallbackID) -> SRAMCallback?
  func write(_ id: SRAMCallbackID, value: SRAMCallback?)
}
public struct SRAMCallbackDefaults {
  public let mspInitialize: SRAMCallback
  public let mspDeinitialize: SRAMCallback
  public let dmaComplete: SRAMCallback
  public let dmaError: SRAMCallback
  public init(
    mspInitialize: @escaping SRAMCallback = { _ in },
    mspDeinitialize: @escaping SRAMCallback = { _ in },
    dmaComplete: @escaping SRAMCallback = { _ in }, dmaError: @escaping SRAMCallback = { _ in }
  ) {
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.dmaComplete = dmaComplete
    self.dmaError = dmaError
  }
  public func callback(_ id: SRAMCallbackID) -> SRAMCallback {
    switch id {
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    case .dmaComplete: return dmaComplete
    case .dmaError: return dmaError
    }
  }
}
public struct SRAMUnregisteredCallbacks: SRAMCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: SRAMCallbackID) -> SRAMCallback? { nil }
  public func write(_ id: SRAMCallbackID, value: SRAMCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct SRAM<
  Registers: FMCRegisterIO, Handle: SRAMHandleIO, Callbacks: SRAMCallbackIO, Memory: FMCMemoryIO,
  DMAIO: FMCDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let memory: Memory
  public let dma: DMAIO
  public let defaults: SRAMCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, memory: Memory, dma: DMAIO,
    defaults: SRAMCallbackDefaults = .init(), useRegisteredCallbacks: Bool = true
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
