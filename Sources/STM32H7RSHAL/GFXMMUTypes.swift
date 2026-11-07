// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// GFXMMU types from stm32h7rsxx_hal_gfxmmu.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum GFXMMURegister: Hashable {
    case cr, sr, fcr, dvr, dar, b0cr, b1cr, b2cr, b3cr
    case lut(index: Int)
}
public protocol GFXMMURegisterIO {
    func read(_ register: GFXMMURegister) -> UInt32
    func write(_ register: GFXMMURegister, value: UInt32)
    func address(of register: GFXMMURegister) -> UInt32
}
public protocol GFXMMUMemoryIO: DMAMemoryIO {
    func getPRIMASK() -> UInt32
    func disableIRQ()
    func setPRIMASK(_ value: UInt32)
}
public enum GFXMMUHandleWord: Int, CaseIterable {
    case blockSize = 0, defaultValue, addressTranslation
    case buffer0, buffer1, buffer2, buffer3, interruptsEnabled, interrupts, state, errorCode
}
// Eleven caller-owned words, accessed through shared volatile storage on ARM.
public protocol GFXMMUHandleIO {
    func read(_ word: GFXMMUHandleWord) -> UInt32
    func write(_ word: GFXMMUHandleWord, value: UInt32)
}
public enum GFXMMUState: UInt32, CaseIterable, Sendable { case reset = 0, ready = 1 }
public enum GFXMMUBlockSize: UInt32, CaseIterable, Sendable { case bytes16 = 0, bytes12 = 0x40 }
public enum GFXMMUPackingMode: UInt32, CaseIterable, Sendable { case removeMSB = 0, removeLSB = 1 }
public struct GFXMMUInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let buffer0Overflow = Self(rawValue: 1)
    public static let buffer1Overflow = Self(rawValue: 2)
    public static let buffer2Overflow = Self(rawValue: 4)
    public static let buffer3Overflow = Self(rawValue: 8)
    public static let busMasterError = Self(rawValue: 0x10)
}
public struct GFXMMUError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let buffer0Overflow = Self(rawValue: 1)
    public static let buffer1Overflow = Self(rawValue: 2)
    public static let buffer2Overflow = Self(rawValue: 4)
    public static let buffer3Overflow = Self(rawValue: 8)
    public static let busMaster = Self(rawValue: 0x10)
    public static let invalidCallback = Self(rawValue: 0x100)
}
public struct GFXMMUBuffers: Equatable, Sendable {
    public var buffer0, buffer1, buffer2, buffer3: UInt32
    public init(buffer0: UInt32, buffer1: UInt32, buffer2: UInt32, buffer3: UInt32) {
        self.buffer0 = buffer0; self.buffer1 = buffer1; self.buffer2 = buffer2; self.buffer3 = buffer3
    }
}
public struct GFXMMULUTLine: Equatable, Sendable {
    public var lineNumber, lineStatus, firstVisibleBlock, lastVisibleBlock: UInt32
    public var lineOffset: Int32
    public init(lineNumber: UInt32, lineStatus: UInt32, firstVisibleBlock: UInt32,
                lastVisibleBlock: UInt32, lineOffset: Int32) {
        self.lineNumber = lineNumber; self.lineStatus = lineStatus
        self.firstVisibleBlock = firstVisibleBlock; self.lastVisibleBlock = lastVisibleBlock
        self.lineOffset = lineOffset
    }
}
public struct GFXMMUPacking: Equatable, Sendable {
    public var buffer0Enabled, buffer0Mode, buffer1Enabled, buffer1Mode: UInt32
    public var buffer2Enabled, buffer2Mode, buffer3Enabled, buffer3Mode, defaultAlpha: UInt32
    public init(buffer0Enabled: UInt32 = 0, buffer0Mode: UInt32 = 0,
                buffer1Enabled: UInt32 = 0, buffer1Mode: UInt32 = 0,
                buffer2Enabled: UInt32 = 0, buffer2Mode: UInt32 = 0,
                buffer3Enabled: UInt32 = 0, buffer3Mode: UInt32 = 0, defaultAlpha: UInt32 = 0) {
        self.buffer0Enabled = buffer0Enabled; self.buffer0Mode = buffer0Mode
        self.buffer1Enabled = buffer1Enabled; self.buffer1Mode = buffer1Mode
        self.buffer2Enabled = buffer2Enabled; self.buffer2Mode = buffer2Mode
        self.buffer3Enabled = buffer3Enabled; self.buffer3Mode = buffer3Mode; self.defaultAlpha = defaultAlpha
    }
}
public typealias GFXMMUCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum GFXMMUCallbackID: UInt32, CaseIterable, Sendable {
    case error = 0, mspInitialize = 1, mspDeinitialize = 2
}
public protocol GFXMMUCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: GFXMMUCallbackID) -> GFXMMUCallback?
    func write(_ id: GFXMMUCallbackID, value: GFXMMUCallback?)
}
public struct GFXMMUCallbackDefaults {
    public var error, mspInitialize, mspDeinitialize: GFXMMUCallback
    public init(error: @escaping GFXMMUCallback = { _ in },
                mspInitialize: @escaping GFXMMUCallback = { _ in },
                mspDeinitialize: @escaping GFXMMUCallback = { _ in }) {
        self.error = error; self.mspInitialize = mspInitialize; self.mspDeinitialize = mspDeinitialize
    }
    func callback(_ id: GFXMMUCallbackID) -> GFXMMUCallback {
        switch id { case .error: return error; case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize }
    }
}
public struct GFXMMU<Registers: GFXMMURegisterIO, Handle: GFXMMUHandleIO,
                     Callbacks: GFXMMUCallbackIO, Memory: GFXMMUMemoryIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let memory: Memory
    public let defaults: GFXMMUCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks, memory: Memory,
                defaults: GFXMMUCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks; self.memory = memory
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
