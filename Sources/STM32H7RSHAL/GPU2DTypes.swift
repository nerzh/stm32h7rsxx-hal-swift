// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// GPU2D types from stm32h7rsxx_hal_gpu2d.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// GPU2D exposes register offsets to the higher-level graphics library.
public protocol GPU2DRegisterIO {
    func read(offset: UInt32) -> UInt32
    func write(offset: UInt32, value: UInt32)
}
public enum GPU2DRegisterOffset {
    public static let interruptControl: UInt32 = 0xF8
    public static let commandListID: UInt32 = 0x148
    public static let breakpoint: UInt32 = 0x80
    public static let systemInterrupt: UInt32 = 0xFF8
    public static let limit: UInt32 = 0x1000
}
public enum GPU2DHandleWord: Int, CaseIterable { case lock = 0, state, errorCode }
public protocol GPU2DHandleIO {
    func read(_ word: GPU2DHandleWord) -> UInt32
    func write(_ word: GPU2DHandleWord, value: UInt32)
}
public enum GPU2DState: UInt32, CaseIterable, Sendable {
    case reset = 0, ready = 1, busy = 2, timeout = 3, error = 4
}
public struct GPU2DError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let timeout = Self(rawValue: 1)
    public static let invalidCallback = Self(rawValue: 2)
}
public typealias GPU2DCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias GPU2DCommandListCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public enum GPU2DCallbackID: UInt32, CaseIterable, Sendable { case mspInitialize = 0, mspDeinitialize = 1 }
// Two MSP callbacks and one command-list callback, all initially nil.
public protocol GPU2DCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: GPU2DCallbackID) -> GPU2DCallback?
    func write(_ id: GPU2DCallbackID, value: GPU2DCallback?)
    func readCommandListComplete() -> GPU2DCommandListCallback?
    func writeCommandListComplete(_ value: GPU2DCommandListCallback?)
}
public struct GPU2DCallbackDefaults {
    public var mspInitialize, mspDeinitialize, error: GPU2DCallback
    public var commandListComplete: GPU2DCommandListCallback
    public init(mspInitialize: @escaping GPU2DCallback = { _ in },
                mspDeinitialize: @escaping GPU2DCallback = { _ in },
                commandListComplete: @escaping GPU2DCommandListCallback = { _, _ in },
                error: @escaping GPU2DCallback = { _ in while true {} }) {
        self.mspInitialize = mspInitialize; self.mspDeinitialize = mspDeinitialize
        self.commandListComplete = commandListComplete; self.error = error
    }
    func callback(_ id: GPU2DCallbackID) -> GPU2DCallback {
        switch id { case .mspInitialize: return mspInitialize; case .mspDeinitialize: return mspDeinitialize }
    }
}
public struct GPU2D<Registers: GPU2DRegisterIO, Handle: GPU2DHandleIO, Callbacks: GPU2DCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: GPU2DCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: GPU2DCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
