// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DMA2D operations and definitions from stm32h7rsxx_hal_dma2d.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum DMA2DRegister: UInt32, CaseIterable, Sendable {
    case cr = 0x0
    case isr = 0x4
    case ifcr = 0x8
    case fgmar = 0xC
    case fgor = 0x10
    case bgmar = 0x14
    case bgor = 0x18
    case fgpfccr = 0x1C
    case fgcolr = 0x20
    case bgpfccr = 0x24
    case bgcolr = 0x28
    case fgcmar = 0x2C
    case bgcmar = 0x30
    case opfccr = 0x34
    case ocolr = 0x38
    case omar = 0x3C
    case oor = 0x40
    case nlr = 0x44
    case lwr = 0x48
    case amtcr = 0x4C
}
public protocol DMA2DRegisterIO {
    func read(_ register: DMA2DRegister) -> UInt32
    func write(_ register: DMA2DRegister, value: UInt32)
    func isClockEnabled() -> Bool
}
public enum DMA2DHandleWord: Int, CaseIterable {
    case lock = 0
    case state = 1
    case errorCode = 2
    case mode = 3
    case colorMode = 4
    case outputOffset = 5
    case alphaInverted = 6
    case redBlueSwap = 7
    case bytesSwap = 8
    case lineOffsetMode = 9
    case backgroundInputOffset = 10
    case backgroundColorMode = 11
    case backgroundAlphaMode = 12
    case backgroundInputAlpha = 13
    case backgroundAlphaInverted = 14
    case backgroundRedBlueSwap = 15
    case backgroundChromaSubsampling = 16
    case foregroundInputOffset = 17
    case foregroundColorMode = 18
    case foregroundAlphaMode = 19
    case foregroundInputAlpha = 20
    case foregroundAlphaInverted = 21
    case foregroundRedBlueSwap = 22
    case foregroundChromaSubsampling = 23
}
public protocol DMA2DHandleIO {
    func read(_ word: DMA2DHandleWord) -> UInt32
    func write(_ word: DMA2DHandleWord, value: UInt32)
}
public enum DMA2DState: UInt32, CaseIterable, Sendable {
    case reset = 0x0
    case ready = 0x1
    case busy = 0x2
    case timeout = 0x3
    case error = 0x4
    case suspend = 0x5
}
public enum DMA2DMode: UInt32, CaseIterable, Sendable {
    case memoryToMemory = 0x0
    case pixelFormatConversion = 0x10000
    case blend = 0x20000
    case registerToMemory = 0x30000
    case blendFixedForeground = 0x40000
    case blendFixedBackground = 0x50000
}
public enum DMA2DOutputColorMode: UInt32, CaseIterable, Sendable {
    case argb8888 = 0x0
    case rgb888 = 0x1
    case rgb565 = 0x2
    case argb1555 = 0x3
    case argb4444 = 0x4
}
public enum DMA2DInputColorMode: UInt32, CaseIterable, Sendable {
    case argb8888 = 0x0
    case rgb888 = 0x1
    case rgb565 = 0x2
    case argb1555 = 0x3
    case argb4444 = 0x4
    case l8 = 0x5
    case al44 = 0x6
    case al88 = 0x7
    case l4 = 0x8
    case a8 = 0x9
    case a4 = 0xA
    case ycbcr = 0xB
}
public enum DMA2DAlphaMode: UInt32, CaseIterable, Sendable {
    case unchanged = 0x0
    case replace = 0x1
    case combine = 0x2
}
public enum DMA2DChromaSubsampling: UInt32, CaseIterable, Sendable {
    case none = 0x0
    case ycbcr422 = 0x1
    case ycbcr420 = 0x2
}
public enum DMA2DLayer: UInt32, CaseIterable, Sendable {
    case background = 0x0
    case foreground = 0x1
}
public enum DMA2DLineOffsetMode: UInt32, CaseIterable, Sendable {
    case pixels = 0x0
    case bytes = 0x40
}
public enum DMA2DCLUTColorMode: UInt32, CaseIterable, Sendable {
    case argb8888 = 0x0
    case rgb888 = 0x1
}
public struct DMA2DError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let transfer = Self(rawValue: 0x1)
    public static let configuration = Self(rawValue: 0x2)
    public static let clutAccess = Self(rawValue: 0x4)
    public static let timeout = Self(rawValue: 0x20)
    public static let invalidCallback = Self(rawValue: 0x40)
}
public struct DMA2DFlags: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let transferError = Self(rawValue: 0x1)
    public static let transferComplete = Self(rawValue: 0x2)
    public static let line = Self(rawValue: 0x4)
    public static let clutAccessError = Self(rawValue: 0x8)
    public static let clutComplete = Self(rawValue: 0x10)
    public static let configurationError = Self(rawValue: 0x20)
}
public struct DMA2DInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let transferError = Self(rawValue: 0x100)
    public static let transferComplete = Self(rawValue: 0x200)
    public static let line = Self(rawValue: 0x400)
    public static let clutAccessError = Self(rawValue: 0x800)
    public static let clutComplete = Self(rawValue: 0x1000)
    public static let configurationError = Self(rawValue: 0x2000)
}
public struct DMA2DCLUTConfiguration: Equatable, Sendable {
    public var address: UInt32
    public var colorMode: UInt32
    public var size: UInt32
    public init(address: UInt32, colorMode: UInt32, size: UInt32) {
        self.address = address; self.colorMode = colorMode; self.size = size
    }
}
public struct DMA2D<Registers: DMA2DRegisterIO, Handle: DMA2DHandleIO, Callbacks: DMA2DCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: DMA2DCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: DMA2DCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
