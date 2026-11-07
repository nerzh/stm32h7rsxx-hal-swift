// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LTDC operations and definitions from stm32h7rsxx_hal_ltdc.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum LTDCRegister: UInt32, CaseIterable, Sendable {
    case sscr = 0x8
    case bpcr = 0xc
    case awcr = 0x10
    case twcr = 0x14
    case gcr = 0x18
    case srcr = 0x24
    case bccr = 0x2c
    case ier = 0x34
    case isr = 0x38
    case icr = 0x3c
    case lipcr = 0x40
    case cpsr = 0x44
    case cdsr = 0x48
}
public enum LTDCLayerRegister: UInt32, CaseIterable, Sendable {
    case cr = 0x0
    case whpcr = 0x4
    case wvpcr = 0x8
    case ckcr = 0xc
    case pfcr = 0x10
    case cacr = 0x14
    case dccr = 0x18
    case bfcr = 0x1c
    case cfbar = 0x28
    case cfblr = 0x2c
    case cfblnr = 0x30
    case clutwr = 0x40
}
public enum LTDCHandleWord: Int, CaseIterable, Sendable {
    case lock = 0
    case state = 1
    case errorCode = 2
    case hsPolarity = 3
    case vsPolarity = 4
    case dePolarity = 5
    case pcPolarity = 6
    case horizontalSync = 7
    case verticalSync = 8
    case accumulatedHBP = 9
    case accumulatedVBP = 10
    case accumulatedActiveWidth = 11
    case accumulatedActiveHeight = 12
    case totalWidth = 13
    case totalHeight = 14
    case backgroundColor = 15
    case layer0WindowX0 = 16
    case layer0WindowX1 = 17
    case layer0WindowY0 = 18
    case layer0WindowY1 = 19
    case layer0PixelFormat = 20
    case layer0Alpha = 21
    case layer0Alpha0 = 22
    case layer0BlendingFactor1 = 23
    case layer0BlendingFactor2 = 24
    case layer0FrameBufferAddress = 25
    case layer0ImageWidth = 26
    case layer0ImageHeight = 27
    case layer0BackgroundColor = 28
    case layer1WindowX0 = 29
    case layer1WindowX1 = 30
    case layer1WindowY0 = 31
    case layer1WindowY1 = 32
    case layer1PixelFormat = 33
    case layer1Alpha = 34
    case layer1Alpha0 = 35
    case layer1BlendingFactor1 = 36
    case layer1BlendingFactor2 = 37
    case layer1FrameBufferAddress = 38
    case layer1ImageWidth = 39
    case layer1ImageHeight = 40
    case layer1BackgroundColor = 41
}
public enum LTDCLayerWord: Int, CaseIterable, Sendable {
    case windowX0 = 0
    case windowX1 = 1
    case windowY0 = 2
    case windowY1 = 3
    case pixelFormat = 4
    case alpha = 5
    case alpha0 = 6
    case blendingFactor1 = 7
    case blendingFactor2 = 8
    case frameBufferAddress = 9
    case imageWidth = 10
    case imageHeight = 11
    case backgroundColor = 12
}
public protocol LTDCRegisterIO {
    func read(_ register: LTDCRegister) -> UInt32
    func write(_ register: LTDCRegister, value: UInt32)
    func read(_ register: LTDCLayerRegister, layer: UInt32) -> UInt32
    func write(_ register: LTDCLayerRegister, layer: UInt32, value: UInt32)
}
public protocol LTDCHandleIO {
    func read(_ word: LTDCHandleWord) -> UInt32
    func write(_ word: LTDCHandleWord, value: UInt32)
}
public enum LTDCHorizontalSyncPolarity: UInt32, CaseIterable, Sendable {
    case activeLow = 0x0
    case activeHigh = 0x80000000
}
public enum LTDCVerticalSyncPolarity: UInt32, CaseIterable, Sendable {
    case activeLow = 0x0
    case activeHigh = 0x40000000
}
public enum LTDCDataEnablePolarity: UInt32, CaseIterable, Sendable {
    case activeLow = 0x0
    case activeHigh = 0x20000000
}
public enum LTDCPixelClockPolarity: UInt32, CaseIterable, Sendable {
    case inputPixelClock = 0x0
    case invertedInputPixelClock = 0x10000000
}
public enum LTDCLayer: UInt32, CaseIterable, Sendable {
    case first = 0x0
    case second = 0x1
}
public enum LTDCState: UInt32, CaseIterable, Sendable {
    case reset = 0x0
    case ready = 0x1
    case busy = 0x2
    case timeout = 0x3
    case error = 0x4
}
public enum LTDCPixelFormat: UInt32, CaseIterable, Sendable {
    case argb8888 = 0x0
    case rgb888 = 0x1
    case rgb565 = 0x2
    case argb1555 = 0x3
    case argb4444 = 0x4
    case l8 = 0x5
    case al44 = 0x6
    case al88 = 0x7
}
public enum LTDCReload: UInt32, CaseIterable, Sendable {
    case immediate = 0x1
    case verticalBlanking = 0x2
}
public enum LTDCBlendingFactor1: UInt32, CaseIterable, Sendable {
    case constantAlpha = 0x400
    case pixelAlphaTimesConstantAlpha = 0x600
}
public enum LTDCBlendingFactor2: UInt32, CaseIterable, Sendable {
    case constantAlpha = 0x5
    case pixelAlphaTimesConstantAlpha = 0x7
}
public struct LTDCError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let transfer = Self(rawValue: 0x1)
    public static let fifoUnderrun = Self(rawValue: 0x2)
    public static let timeout = Self(rawValue: 0x20)
    public static let invalidCallback = Self(rawValue: 0x40)
}
public struct LTDCInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let line = Self(rawValue: 0x1)
    public static let fifoUnderrun = Self(rawValue: 0x2)
    public static let transferError = Self(rawValue: 0x4)
    public static let reload = Self(rawValue: 0x8)
}
public typealias LTDCFlags = LTDCInterrupts
public struct LTDCLayerConfiguration: Equatable, Sendable {
    // Background color uses B, G, R, reserved bytes, matching the C structure.
    public var windowX0: UInt32
    public var windowX1: UInt32
    public var windowY0: UInt32
    public var windowY1: UInt32
    public var pixelFormat: UInt32
    public var alpha: UInt32
    public var alpha0: UInt32
    public var blendingFactor1: UInt32
    public var blendingFactor2: UInt32
    public var frameBufferAddress: UInt32
    public var imageWidth: UInt32
    public var imageHeight: UInt32
    public var backgroundColor: UInt32
    public init(windowX0: UInt32, windowX1: UInt32, windowY0: UInt32,
                windowY1: UInt32, pixelFormat: UInt32, alpha: UInt32,
                alpha0: UInt32, blendingFactor1: UInt32, blendingFactor2: UInt32,
                frameBufferAddress: UInt32, imageWidth: UInt32, imageHeight: UInt32,
                backgroundColor: UInt32) {
        self.windowX0 = windowX0
        self.windowX1 = windowX1
        self.windowY0 = windowY0
        self.windowY1 = windowY1
        self.pixelFormat = pixelFormat
        self.alpha = alpha
        self.alpha0 = alpha0
        self.blendingFactor1 = blendingFactor1
        self.blendingFactor2 = blendingFactor2
        self.frameBufferAddress = frameBufferAddress
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.backgroundColor = backgroundColor
    }
    public subscript(_ word: LTDCLayerWord) -> UInt32 {
        switch word {
        case .windowX0: return windowX0
        case .windowX1: return windowX1
        case .windowY0: return windowY0
        case .windowY1: return windowY1
        case .pixelFormat: return pixelFormat
        case .alpha: return alpha
        case .alpha0: return alpha0
        case .blendingFactor1: return blendingFactor1
        case .blendingFactor2: return blendingFactor2
        case .frameBufferAddress: return frameBufferAddress
        case .imageWidth: return imageWidth
        case .imageHeight: return imageHeight
        case .backgroundColor: return backgroundColor
        }
    }
}
public struct LTDC<Registers: LTDCRegisterIO, Handle: LTDCHandleIO, Callbacks: LTDCCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: LTDCCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: LTDCCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
