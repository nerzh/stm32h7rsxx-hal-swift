// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// GFXTIM definitions from stm32h7rsxx_hal_gfxtim.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum GFXTIMRegister: UInt32, CaseIterable, Sendable {
    case cr = 0x0
    case cgcr = 0x4
    case tcr = 0x8
    case tdr = 0xC
    case evcr = 0x10
    case evsr = 0x14
    case wdgtcr = 0x20
    case isr = 0x30
    case icr = 0x34
    case ier = 0x38
    case tsr = 0x3C
    case lccrr = 0x40
    case fccrr = 0x44
    case atr = 0x50
    case afcr = 0x54
    case alcr = 0x58
    case afcc1r = 0x60
    case alcc1r = 0x70
    case alcc2r = 0x74
    case rfc1r = 0x80
    case rfc1rr = 0x84
    case rfc2r = 0x88
    case rfc2rr = 0x8C
    case wdgcr = 0xA0
    case wdgrr = 0xA4
    case wdgpar = 0xA8
}
public protocol GFXTIMRegisterIO {
    func read(_ register: GFXTIMRegister) -> UInt32
    func write(_ register: GFXTIMRegister, value: UInt32)
}
public enum GFXTIMHandleWord: Int, CaseIterable {
    case state = 0, errorCode, synchronizationSource, tearingEffectSource, tearingEffectPolarity, tearingEffectInterrupt
}
// Six caller-owned words, shared by foreground and IRQ callbacks without inout.
public protocol GFXTIMHandleIO {
    func read(_ word: GFXTIMHandleWord) -> UInt32
    func write(_ word: GFXTIMHandleWord, value: UInt32)
}
public enum GFXTIMState: UInt32, CaseIterable, Sendable { case reset = 0, ready = 1, error = 0xFF }
public struct GFXTIMError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let state = Self(rawValue: 1)
    public static let invalidCallback = Self(rawValue: 2)
}
public enum GFXTIMSynchronizationSource: UInt32, CaseIterable, Sendable {
    case hsyncVsync0 = 0x0
    case hsyncVsync1 = 0x100
    case hsyncVsync2 = 0x200
    case hsyncVsync3 = 0x300
}
public enum GFXTIMTearingEffectSource: UInt32, CaseIterable, Sendable {
    case gpio = 0x0
    case internalTearingEffect = 0x1
    case hsync = 0x2
    case vsync = 0x3
}
public enum GFXTIMTearingEffectPolarity: UInt32, CaseIterable, Sendable {
    case rising = 0x0
    case falling = 0x10
}
public enum GFXTIMLineCounterClock: UInt32, CaseIterable, Sendable {
    case disabled = 0x0
    case systemClock = 0x10
}
public enum GFXTIMLineCounterReloadSource: UInt32, CaseIterable, Sendable {
    case none = 0x0
    case frameCounterUnderflow = 0x1000
    case hsyncRising = 0x2000
    case hsyncFalling = 0x3000
    case vsyncRising = 0x4000
    case vsyncFalling = 0x5000
    case tearingEffectRising = 0x6000
    case tearingEffectFalling = 0x7000
}
public enum GFXTIMFrameCounterReloadSource: UInt32, CaseIterable, Sendable {
    case none = 0x0
    case lineCounterUnderflow = 0x10000000
    case hsyncRising = 0x20000000
    case hsyncFalling = 0x30000000
    case vsyncRising = 0x40000000
    case vsyncFalling = 0x50000000
    case tearingEffectRising = 0x60000000
    case tearingEffectFalling = 0x70000000
}
public enum GFXTIMFrameCounterClock: UInt32, CaseIterable, Sendable {
    case disabled = 0x0
    case lineCounterUnderflow = 0x100000
    case hsyncRising = 0x200000
    case hsyncFalling = 0x300000
    case vsyncRising = 0x400000
    case vsyncFalling = 0x500000
    case tearingEffectRising = 0x600000
    case tearingEffectFalling = 0x700000
}
public enum GFXTIMLineClockSource: UInt32, CaseIterable, Sendable {
    case lineCounterUnderflow = 0x0
    case frameCounterUnderflow = 0x1
    case hsyncRising = 0x2
    case hsyncFalling = 0x3
    case vsyncRising = 0x4
    case vsyncFalling = 0x5
    case tearingEffectRising = 0x6
    case tearingEffectFalling = 0x7
}
public enum GFXTIMFrameClockSource: UInt32, CaseIterable, Sendable {
    case lineCounterUnderflow = 0x0
    case frameCounterUnderflow = 0x10000
    case hsyncRising = 0x20000
    case hsyncFalling = 0x30000
    case vsyncRising = 0x40000
    case vsyncFalling = 0x50000
    case tearingEffectRising = 0x60000
    case tearingEffectFalling = 0x70000
}
public enum GFXTIMAbsoluteTime: UInt32, CaseIterable, Sendable {
    case global = 0x14
    case frame = 0x15
    case line = 0x16
}
public enum GFXTIMAbsoluteLineComparator: UInt32, CaseIterable, Sendable {
    case compare1 = 0x1C
    case compare2 = 0x1D
}
public enum GFXTIMRelativeTimer: UInt32, CaseIterable, Sendable {
    case timer1 = 0x0
    case timer2 = 0x1
}
public enum GFXTIMCounterMode: UInt32, CaseIterable, Sendable {
    case oneShot = 0x0
    case continuous = 0x1
}
public enum GFXTIMEventGenerator: UInt32, CaseIterable, Sendable {
    case event1 = 0x0
    case event2 = 0x1
    case event3 = 0x2
    case event4 = 0x3
}
public enum GFXTIMLineEvent: UInt32, CaseIterable, Sendable {
    case none = 0x0
    case absoluteLineOverflow = 0x1
    case tearingEffect = 0x2
    case absoluteLineCompare1 = 0x4
    case absoluteLineCompare2 = 0x5
}
public enum GFXTIMFrameEvent: UInt32, CaseIterable, Sendable {
    case none = 0x0
    case absoluteFrameOverflow = 0x10
    case absoluteFrameCompare = 0x20
    case relativeFrame1Reload = 0x40
    case relativeFrame2Reload = 0x50
}
public enum GFXTIMWatchdogHardwareReload: UInt32, CaseIterable, Sendable {
    case disabled = 0x0
    case rising = 0x10
    case falling = 0x20
}
public enum GFXTIMWatchdogClock: UInt32, CaseIterable, Sendable {
    case line = 0x0
    case frame = 0x100
    case hsyncRising = 0x200
    case hsyncFalling = 0x300
    case vsyncRising = 0x400
    case vsyncFalling = 0x500
    case tearingEffectRising = 0x600
    case tearingEffectFalling = 0x700
    case event1 = 0x800
    case event2 = 0x900
    case event3 = 0xA00
    case event4 = 0xB00
}
public struct GFXTIMClockGeneratorCounters: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let line = Self(rawValue: 0x100)
    public static let frame = Self(rawValue: 0x1000000)
}
public struct GFXTIMClockCalibration: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let line = Self(rawValue: 0x20000)
    public static let frame = Self(rawValue: 0x10000)
}
public struct GFXTIMFlags: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let absoluteFrameOverflow = Self(rawValue: 0x1)
    public static let absoluteLineOverflow = Self(rawValue: 0x2)
    public static let tearingEffect = Self(rawValue: 0x4)
    public static let absoluteFrameCompare1 = Self(rawValue: 0x10)
    public static let absoluteLineCompare1 = Self(rawValue: 0x100)
    public static let absoluteLineCompare2 = Self(rawValue: 0x200)
    public static let relativeFrame1Reload = Self(rawValue: 0x1000)
    public static let relativeFrame2Reload = Self(rawValue: 0x2000)
    public static let event1 = Self(rawValue: 0x10000)
    public static let event2 = Self(rawValue: 0x20000)
    public static let event3 = Self(rawValue: 0x40000)
    public static let event4 = Self(rawValue: 0x80000)
    public static let watchdogAlarm = Self(rawValue: 0x1000000)
    public static let watchdogPreAlarm = Self(rawValue: 0x2000000)
}
public struct GFXTIMClockGeneratorConfiguration: Equatable, Sendable {
    public var lineCounterHardwareReloadSource: UInt32
    public var lineCounterReloadValue: UInt32
    public var lineCounterClockSource: UInt32
    public var lineClockSource: UInt32
    public var frameCounterHardwareReloadSource: UInt32
    public var frameCounterReloadValue: UInt32
    public var frameCounterClockSource: UInt32
    public var frameClockSource: UInt32
    public var lineClockCalibration: UInt32
    public var frameClockCalibration: UInt32
    public init(lineCounterHardwareReloadSource: UInt32 = 0,
                lineCounterReloadValue: UInt32 = 0,
                lineCounterClockSource: UInt32 = 0,
                lineClockSource: UInt32 = 0,
                frameCounterHardwareReloadSource: UInt32 = 0,
                frameCounterReloadValue: UInt32 = 0,
                frameCounterClockSource: UInt32 = 0,
                frameClockSource: UInt32 = 0,
                lineClockCalibration: UInt32 = 0,
                frameClockCalibration: UInt32 = 0) {
        self.lineCounterHardwareReloadSource = lineCounterHardwareReloadSource
        self.lineCounterReloadValue = lineCounterReloadValue
        self.lineCounterClockSource = lineCounterClockSource
        self.lineClockSource = lineClockSource
        self.frameCounterHardwareReloadSource = frameCounterHardwareReloadSource
        self.frameCounterReloadValue = frameCounterReloadValue
        self.frameCounterClockSource = frameCounterClockSource
        self.frameClockSource = frameClockSource
        self.lineClockCalibration = lineClockCalibration
        self.frameClockCalibration = frameClockCalibration
    }
}
public struct GFXTIMAbsoluteTimerConfiguration: Equatable, Sendable {
    public var frameCompare1: UInt32
    public var frameCounter: UInt32
    public var frameOverflowInterrupt: UInt32
    public var frameCompare1Interrupt: UInt32
    public var lineCompare1: UInt32
    public var lineCompare2: UInt32
    public var lineCounter: UInt32
    public var lineOverflowInterrupt: UInt32
    public var lineCompare1Interrupt: UInt32
    public var lineCompare2Interrupt: UInt32
    public init(frameCompare1: UInt32 = 0,
                frameCounter: UInt32 = 0,
                frameOverflowInterrupt: UInt32 = 0,
                frameCompare1Interrupt: UInt32 = 0,
                lineCompare1: UInt32 = 0,
                lineCompare2: UInt32 = 0,
                lineCounter: UInt32 = 0,
                lineOverflowInterrupt: UInt32 = 0,
                lineCompare1Interrupt: UInt32 = 0,
                lineCompare2Interrupt: UInt32 = 0) {
        self.frameCompare1 = frameCompare1
        self.frameCounter = frameCounter
        self.frameOverflowInterrupt = frameOverflowInterrupt
        self.frameCompare1Interrupt = frameCompare1Interrupt
        self.lineCompare1 = lineCompare1
        self.lineCompare2 = lineCompare2
        self.lineCounter = lineCounter
        self.lineOverflowInterrupt = lineOverflowInterrupt
        self.lineCompare1Interrupt = lineCompare1Interrupt
        self.lineCompare2Interrupt = lineCompare2Interrupt
    }
}
public struct GFXTIMRelativeTimerConfiguration: Equatable, Sendable {
    public var autoReloadValue: UInt32
    public var counterMode: UInt32
    public var reloadInterrupt: UInt32
    public init(autoReloadValue: UInt32 = 0,
                counterMode: UInt32 = 0,
                reloadInterrupt: UInt32 = 0) {
        self.autoReloadValue = autoReloadValue
        self.counterMode = counterMode
        self.reloadInterrupt = reloadInterrupt
    }
}
public struct GFXTIMEventGeneratorConfiguration: Equatable, Sendable {
    public var lineEvent: UInt32
    public var frameEvent: UInt32
    public var eventInterrupt: UInt32
    public init(lineEvent: UInt32 = 0,
                frameEvent: UInt32 = 0,
                eventInterrupt: UInt32 = 0) {
        self.lineEvent = lineEvent
        self.frameEvent = frameEvent
        self.eventInterrupt = eventInterrupt
    }
}
public struct GFXTIMWatchdogConfiguration: Equatable, Sendable {
    public var clockSource: UInt32
    public var autoReloadValue: UInt32
    public var hardwareReload: UInt32
    public var preAlarmValue: UInt32
    public var alarmInterrupt: UInt32
    public var preAlarmInterrupt: UInt32
    public init(clockSource: UInt32 = 0,
                autoReloadValue: UInt32 = 0,
                hardwareReload: UInt32 = 0,
                preAlarmValue: UInt32 = 0,
                alarmInterrupt: UInt32 = 0,
                preAlarmInterrupt: UInt32 = 0) {
        self.clockSource = clockSource
        self.autoReloadValue = autoReloadValue
        self.hardwareReload = hardwareReload
        self.preAlarmValue = preAlarmValue
        self.alarmInterrupt = alarmInterrupt
        self.preAlarmInterrupt = preAlarmInterrupt
    }
}
public struct GFXTIM<Registers: GFXTIMRegisterIO, Handle: GFXTIMHandleIO, Callbacks: GFXTIMCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: GFXTIMCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: GFXTIMCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
