// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Types and encodings from stm32h7rsxx_hal_cordic.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum CORDICRegister: Hashable, CaseIterable { case csr, wdata, rdata }
public protocol CORDICRegisterIO {
  func read(_ register: CORDICRegister) -> UInt32
  func write(_ register: CORDICRegister, value: UInt32)
  func address(of register: CORDICRegister) -> UInt32
}
public enum CORDICHandleWord: Int, CaseIterable {
  case calculationsToOrder = 0, calculationsToGet, dmaDirection, lock, state, errorCode
}
public enum CORDICBufferPointer: Int, CaseIterable { case input = 0, output }
// Six shared UInt32 words and two native-pointer slots replace the mutable C
// handle. Hardware storage is volatile; copies used by foreground, IRQ and DMA
// callbacks share it without holding a Swift inout access across an operation.
// Buffer ownership remains with the caller until asynchronous work completes.
public protocol CORDICHandleIO {
  func read(_ word: CORDICHandleWord) -> UInt32
  func write(_ word: CORDICHandleWord, value: UInt32)
  func readPointer(_ pointer: CORDICBufferPointer) -> UnsafeMutableRawPointer?
  func writePointer(_ pointer: CORDICBufferPointer, value: UnsafeMutableRawPointer?)
}
public enum CORDICState: UInt32, CaseIterable, Sendable {
  case reset = 0, ready = 1, busy = 2, error = 3
}
public struct CORDICError: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let parameter = Self(rawValue: 1)
  public static let notReady = Self(rawValue: 2)
  public static let timeout = Self(rawValue: 4)
  public static let dma = Self(rawValue: 8)
  public static let invalidCallback = Self(rawValue: 0x10)
}
public enum CORDICFunction: UInt32, CaseIterable, Sendable {
  case cosine = 0, sine, phase, modulus, arctangent, hyperbolicCosine
  case hyperbolicSine, hyperbolicArctangent, naturalLogarithm, squareRoot
}
public enum CORDICPrecision: UInt32, CaseIterable, Sendable {
  case cycles1 = 0x10, cycles2 = 0x20, cycles3 = 0x30, cycles4 = 0x40
  case cycles5 = 0x50, cycles6 = 0x60, cycles7 = 0x70, cycles8 = 0x80
  case cycles9 = 0x90, cycles10 = 0xA0, cycles11 = 0xB0, cycles12 = 0xC0
  case cycles13 = 0xD0, cycles14 = 0xE0, cycles15 = 0xF0
}
public enum CORDICScale: UInt32, CaseIterable, Sendable {
  case scale0 = 0, scale1 = 0x100, scale2 = 0x200, scale3 = 0x300
  case scale4 = 0x400, scale5 = 0x500, scale6 = 0x600, scale7 = 0x700
}
public enum CORDICInputSize: UInt32, CaseIterable, Sendable { case bits32 = 0, bits16 = 0x0040_0000 }
public enum CORDICOutputSize: UInt32, CaseIterable, Sendable { case bits32 = 0, bits16 = 0x0020_0000 }
public enum CORDICWriteCount: UInt32, CaseIterable, Sendable { case one = 0, two = 0x0010_0000 }
public enum CORDICReadCount: UInt32, CaseIterable, Sendable { case one = 0, two = 0x0008_0000 }
public struct CORDICFlags: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let resultReady = Self(rawValue: 0x8000_0000)
}
public struct CORDICInterrupts: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let resultReady = Self(rawValue: 0x0001_0000)
}
public enum CORDICDMATransferDirection: UInt32, CaseIterable, Sendable {
  case none = 0, input = 1, output = 2, inputOutput = 3
}
public struct CORDICConfiguration: Equatable, Sendable {
  public var function, scale, inputSize, outputSize, writeCount, readCount, precision: UInt32
  public init(function: UInt32 = 0, scale: UInt32 = 0, inputSize: UInt32 = 0,
              outputSize: UInt32 = 0, writeCount: UInt32 = 0, readCount: UInt32 = 0,
              precision: UInt32 = 0x10) {
    self.function = function; self.scale = scale; self.inputSize = inputSize
    self.outputSize = outputSize; self.writeCount = writeCount
    self.readCount = readCount; self.precision = precision
  }
}

public enum CORDICDMADirection: UInt32, CaseIterable, Sendable { case input = 0, output = 1 }
public enum CORDICDMACallbackKind: UInt32, CaseIterable, Sendable {
  case inputComplete = 0, outputComplete, error
}
public typealias CORDICDMAParentReader =
  @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
public typealias CORDICDMADispatcher =
  @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
// Each DMA callback context points to this caller-owned immutable descriptor.
// The thunk reads the original DMA handle's current Parent on every invocation.
public struct CORDICDMACallbackContext {
  public let dmaContext: UnsafeMutableRawPointer?
  public let readParent: CORDICDMAParentReader
  public let dispatch: CORDICDMADispatcher
  public init(dmaContext: UnsafeMutableRawPointer?, readParent: @escaping CORDICDMAParentReader,
              dispatch: @escaping CORDICDMADispatcher) {
    self.dmaContext = dmaContext; self.readParent = readParent; self.dispatch = dispatch
  }
}
// This boundary delegates transfers to the existing DMA HAL. As in C, an active
// direction requires a valid linked DMA handle; no additional nil check is made.
public protocol CORDICDMAIO {
  func writeCallback(_ direction: CORDICDMADirection, id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: CORDICDMACallbackKind) -> DMACallback
  func startInterrupt(_ direction: CORDICDMADirection, sourceAddress: UInt32,
                      destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus
}

public struct CORDIC<Registers: CORDICRegisterIO, Handle: CORDICHandleIO,
                     Callbacks: CORDICCallbackIO, DMAIO: CORDICDMAIO> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: CORDICCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
              defaults: CORDICCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
    self.registers = registers; self.handle = handle; self.callbacks = callbacks
    self.dma = dma; self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
  }
}
