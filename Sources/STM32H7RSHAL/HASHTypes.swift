// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Types and encodings from stm32h7rsxx_hal_hash.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum HASHRegister: Hashable {
  case cr, din, str, imr, sr
  case hr(index: Int), csr(index: Int), digest(index: Int)
}
public protocol HASHRegisterIO {
  func read(_ register: HASHRegister) -> UInt32
  func write(_ register: HASHRegister, value: UInt32)
  func address(of register: HASHRegister) -> UInt32
}
// Addresses retain the C driver's 32-bit pointer arithmetic. A host model may
// map bus addresses to storage; hardware buffers remain owned by the caller.
public protocol HASHMemoryIO: DMAMemoryIO {
  func read8(at address: UInt32) -> UInt8
  func read16(at address: UInt32) -> UInt16
}
public enum HASHHandleWord: Int, CaseIterable {
  case dataType = 0, keySize, keyAddress, algorithm
  case inputAddress, outputAddress, inputCount, size, keyBufferAddress
  case phase, lock, errorCode, state, accumulation
  case suspendRequest, savedDataType, savedKeySize, savedKeyAddress, savedAlgorithm
  case savedInputAddress, savedOutputAddress, savedInputCount, savedSize, savedKeyBufferAddress, savedPhase
}
// Twenty-five caller-owned UInt32 words, shared by foreground, IRQ and DMA
// callbacks. Hardware implementations use volatile access without a long-lived
// Swift inout access. The C lock is a non-atomic check/set.
public protocol HASHHandleIO {
  func read(_ word: HASHHandleWord) -> UInt32
  func write(_ word: HASHHandleWord, value: UInt32)
}
public enum HASHState: UInt32, CaseIterable, Sendable {
  case reset = 0, ready = 1, busy = 2, suspended = 3
}
public enum HASHPhase: UInt32, CaseIterable, Sendable {
  case ready = 1, process = 2, hmacStep1 = 3, hmacStep2 = 4, hmacStep3 = 5
}
public enum HASHSuspendRequest: UInt32, CaseIterable, Sendable { case none = 0, requested = 1 }
public enum HASHAlgorithmMode: UInt32, CaseIterable, Sendable { case hash = 0, hmac = 0x40 }
public enum HASHKeyType: UInt32, CaseIterable, Sendable { case short = 0, long = 0x0001_0000 }
public enum HASHDataType: UInt32, CaseIterable, Sendable {
  case noSwap = 0, halfwordSwap = 0x10, byteSwap = 0x20, bitSwap = 0x30
}
public enum HASHAlgorithm: UInt32, CaseIterable, Sendable {
  case sha1 = 0, sha224 = 0x0004_0000, sha256 = 0x0006_0000
  case sha384 = 0x0018_0000, sha512_224 = 0x001A_0000
  case sha512_256 = 0x001C_0000, sha512 = 0x001E_0000
}
public struct HASHError: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let busy = Self(rawValue: 1)
  public static let dma = Self(rawValue: 2)
  public static let timeout = Self(rawValue: 4)
  public static let invalidCallback = Self(rawValue: 0x10)
}
public struct HASHFlags: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let inputReady = Self(rawValue: 1)
  public static let digestComplete = Self(rawValue: 2)
  public static let dmaActive = Self(rawValue: 4)
  public static let busy = Self(rawValue: 8)
  public static let inputNotEmpty = Self(rawValue: 0x1000)
}
public struct HASHInterrupts: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let inputReady = Self(rawValue: 1)
  public static let digestComplete = Self(rawValue: 2)
}
public struct HASHConfiguration: Equatable, Sendable {
  public var dataType, keySize, keyAddress, algorithm: UInt32
  public init(dataType: UInt32 = 0, keySize: UInt32 = 0,
              keyAddress: UInt32 = 0, algorithm: UInt32 = 0) {
    self.dataType = dataType; self.keySize = keySize
    self.keyAddress = keyAddress; self.algorithm = algorithm
  }
}
public enum HASHDMACallbackKind: UInt32, CaseIterable { case inputComplete = 0, error = 1 }
public typealias HASHDMAParentReader = @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
public typealias HASHDMADispatcher = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public struct HASHDMACallbackContext {
  public let dmaContext: UnsafeMutableRawPointer?
  public let readParent: HASHDMAParentReader
  public let dispatch: HASHDMADispatcher
  public init(dmaContext: UnsafeMutableRawPointer?, readParent: @escaping HASHDMAParentReader,
              dispatch: @escaping HASHDMADispatcher) {
    self.dmaContext = dmaContext; self.readParent = readParent; self.dispatch = dispatch
  }
}
public protocol HASHDMAIO {
  func read(_ word: DMAHandleWord) -> UInt32
  func getCounter() -> UInt32
  func getFIFOLevel() -> UInt32
  func readMemory32(at address: UInt32) -> UInt32
  func writeMemory32(at address: UInt32, value: UInt32)
  func writeCallback(_ id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: HASHDMACallbackKind) -> DMACallback
  func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus
  func startLinkedListInterrupt() -> HALStatus
  func abort(getTick: () -> UInt32) -> HALStatus
}
public struct HASH<Registers: HASHRegisterIO, Handle: HASHHandleIO, Callbacks: HASHCallbackIO,
                   DMAIO: HASHDMAIO, Memory: HASHMemoryIO> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let memory: Memory
  public let defaults: HASHCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public let useSuspendResume: Bool
  public init(registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO, memory: Memory,
              defaults: HASHCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false,
              useSuspendResume: Bool = false) {
    self.registers = registers; self.handle = handle; self.callbacks = callbacks
    self.dma = dma; self.memory = memory; self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks; self.useSuspendResume = useSuspendResume
  }
}
