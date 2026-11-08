// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LPTIM operations and definitions from stm32h7rsxx_hal_lptim.c/.h and
// stm32h7rsxx_ll_lptim.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum LPTIMInstance: UInt32, CaseIterable, Sendable {
    case lptim1 = 1, lptim2, lptim3, lptim4, lptim5
    public var supportsCaptureAndDMA: Bool { rawValue <= 3 }
    public var baseAddress: UInt32 {
        switch self {
        case .lptim1: return 0x40002400
        case .lptim2: return 0x58002400
        case .lptim3: return 0x58002800
        case .lptim4: return 0x58002c00
        case .lptim5: return 0x58003000
        }
    }
    public var wakeupInterruptMask: UInt32 {
        switch self {
        case .lptim1: return 0x8000
        case .lptim2: return 0x10000
        case .lptim3: return 0x40000
        case .lptim4: return 0x100000
        case .lptim5: return 0x200000
        }
    }
}
public enum LPTIMRegister: UInt32, CaseIterable, Sendable {
    case isr = 0x0
    case icr = 0x4
    case dier = 0x8
    case cfgr = 0xc
    case cr = 0x10
    case ccr1 = 0x14
    case arr = 0x18
    case cnt = 0x1c
    case cfgr2 = 0x24
    case rcr = 0x28
    case ccmr1 = 0x2c
    case ccr2 = 0x34
}
public protocol LPTIMRegisterIO {
    var instance: LPTIMInstance { get }
    func read(_ register: LPTIMRegister) -> UInt32
    func write(_ register: LPTIMRegister, value: UInt32)
    func address(of register: LPTIMRegister) -> UInt32
    func readWakeupInterruptMask() -> UInt32
    func writeWakeupInterruptMask(_ value: UInt32)
}
public enum LPTIMHandleWord: Int, CaseIterable {
    case clockSource = 0, clockPrescaler, clockPolarity, clockSampleTime
    case triggerSource, triggerActiveEdge, triggerSampleTime, period, updateMode, counterSource
    case input1Source, input2Source, repetitionCounter, activeChannel, status, lock, state
    case channel1State, channel2State
}
// Nineteen caller-owned words, shared by foreground and IRQ callbacks.
public protocol LPTIMHandleIO {
    func read(_ word: LPTIMHandleWord) -> UInt32
    func write(_ word: LPTIMHandleWord, value: UInt32)
}
public enum LPTIMState: UInt32, CaseIterable, Sendable { case reset = 0, ready, busy, timeout, error }
public enum LPTIMChannelState: UInt32, CaseIterable, Sendable { case reset = 0, ready, busy }
public enum LPTIMActiveChannel: UInt32, CaseIterable, Sendable { case cleared = 0, channel1, channel2 }
public enum LPTIMChannel: UInt32, CaseIterable, Sendable { case channel1 = 0, channel2 }
public enum LPTIMClockSource: UInt32, CaseIterable, Sendable {
    case apbClockLowPowerOscillator = 0x0
    case ultraLowPower = 0x1
}
public enum LPTIMPrescaler: UInt32, CaseIterable, Sendable {
    case divide1 = 0x0
    case divide2 = 0x200
    case divide4 = 0x400
    case divide8 = 0x600
    case divide16 = 0x800
    case divide32 = 0xa00
    case divide64 = 0xc00
    case divide128 = 0xe00
}
public enum LPTIMClockSampleTime: UInt32, CaseIterable, Sendable {
    case direct = 0x0
    case twoTransitions = 0x8
    case fourTransitions = 0x10
    case eightTransitions = 0x18
}
public enum LPTIMClockPolarity: UInt32, CaseIterable, Sendable {
    case rising = 0x0
    case falling = 0x2
    case bothEdges = 0x4
}
public enum LPTIMTriggerSource: UInt32, CaseIterable, Sendable {
    case software = 0xffff
    case source0 = 0x0
    case source1 = 0x2000
    case source2 = 0x4000
    case source3 = 0x6000
    case source4 = 0x8000
    case source5 = 0xa000
    case source6 = 0xc000
    case source7 = 0xe000
}
public enum LPTIMTriggerActiveEdge: UInt32, CaseIterable, Sendable {
    case rising = 0x20000
    case falling = 0x40000
    case bothEdges = 0x60000
}
public enum LPTIMTriggerSampleTime: UInt32, CaseIterable, Sendable {
    case direct = 0x0
    case twoTransitions = 0x40
    case fourTransitions = 0x80
    case eightTransitions = 0xc0
}
public enum LPTIMUpdateMode: UInt32, CaseIterable, Sendable {
    case immediate = 0x0
    case endOfPeriod = 0x400000
}
public enum LPTIMCounterSource: UInt32, CaseIterable, Sendable {
    case internalClock = 0x0
    case externalInput = 0x800000
}
public enum LPTIMOutputPolarity: UInt32, CaseIterable, Sendable {
    case high = 0x0
    case low = 0x1
}
public enum LPTIMCapturePrescaler: UInt32, CaseIterable, Sendable {
    case divide1 = 0x0
    case divide2 = 0x100
    case divide4 = 0x200
    case divide8 = 0x300
}
public enum LPTIMCapturePolarity: UInt32, CaseIterable, Sendable {
    case rising = 0x0
    case falling = 0x4
    case bothEdges = 0xc
}
public enum LPTIMCaptureFilter: UInt32, CaseIterable, Sendable {
    case divide1 = 0x0
    case divide2 = 0x1000
    case divide4 = 0x2000
    case divide8 = 0x3000
}
public enum LPTIMCaptureInputSource {
    public static let gpio: UInt32 = 0
    public static let lsi: UInt32 = 0x100000
    public static let lse: UInt32 = 0x200000
    public static let hsiDividedBy1024: UInt32 = 0x100000
    public static let csiDividedBy128: UInt32 = 0x200000
}
public struct LPTIMFlags: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let capture1Overrun = Self(rawValue: 0x1000)
    public static let capture2Overrun = Self(rawValue: 0x2000)
    public static let captureCompare1 = Self(rawValue: 0x1)
    public static let captureCompare2 = Self(rawValue: 0x200)
    public static let compare1Write = Self(rawValue: 0x8)
    public static let compare2Write = Self(rawValue: 0x80000)
    public static let interruptEnableWrite = Self(rawValue: 0x1000000)
    public static let repetitionWrite = Self(rawValue: 0x100)
    public static let update = Self(rawValue: 0x80)
    public static let directionDown = Self(rawValue: 0x40)
    public static let directionUp = Self(rawValue: 0x20)
    public static let autoReloadWrite = Self(rawValue: 0x10)
    public static let externalTrigger = Self(rawValue: 0x4)
    public static let autoReloadMatch = Self(rawValue: 0x2)
}
public struct LPTIMInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let capture1Overrun = Self(rawValue: 0x1000)
    public static let capture2Overrun = Self(rawValue: 0x2000)
    public static let captureCompare1 = Self(rawValue: 0x1)
    public static let captureCompare2 = Self(rawValue: 0x200)
    public static let compare1Write = Self(rawValue: 0x8)
    public static let compare2Write = Self(rawValue: 0x80000)
    public static let repetitionWrite = Self(rawValue: 0x100)
    public static let update = Self(rawValue: 0x80)
    public static let directionDown = Self(rawValue: 0x40)
    public static let directionUp = Self(rawValue: 0x20)
    public static let autoReloadWrite = Self(rawValue: 0x10)
    public static let externalTrigger = Self(rawValue: 0x4)
    public static let autoReloadMatch = Self(rawValue: 0x2)
}
public struct LPTIMDMARequests: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let captureCompare1 = Self(rawValue: 0x10000)
    public static let captureCompare2 = Self(rawValue: 0x2000000)
    public static let update = Self(rawValue: 0x800000)
}
public struct LPTIMConfiguration: Equatable, Sendable {
    public var clockSource: UInt32
    public var clockPrescaler: UInt32
    public var clockPolarity: UInt32
    public var clockSampleTime: UInt32
    public var triggerSource: UInt32
    public var triggerActiveEdge: UInt32
    public var triggerSampleTime: UInt32
    public var period: UInt32
    public var updateMode: UInt32
    public var counterSource: UInt32
    public var input1Source: UInt32
    public var input2Source: UInt32
    public var repetitionCounter: UInt32
    public init(clockSource: UInt32 = 0,
                clockPrescaler: UInt32 = 0,
                clockPolarity: UInt32 = 0,
                clockSampleTime: UInt32 = 0,
                triggerSource: UInt32 = 0xFFFF,
                triggerActiveEdge: UInt32 = 0,
                triggerSampleTime: UInt32 = 0,
                period: UInt32 = 1,
                updateMode: UInt32 = 0,
                counterSource: UInt32 = 0,
                input1Source: UInt32 = 0,
                input2Source: UInt32 = 0,
                repetitionCounter: UInt32 = 0) {
        self.clockSource = clockSource
        self.clockPrescaler = clockPrescaler
        self.clockPolarity = clockPolarity
        self.clockSampleTime = clockSampleTime
        self.triggerSource = triggerSource
        self.triggerActiveEdge = triggerActiveEdge
        self.triggerSampleTime = triggerSampleTime
        self.period = period
        self.updateMode = updateMode
        self.counterSource = counterSource
        self.input1Source = input1Source
        self.input2Source = input2Source
        self.repetitionCounter = repetitionCounter
    }
}
public struct LPTIMOutputCompareConfiguration: Equatable, Sendable {
    public var pulse: UInt32
    public var polarity: UInt32
    public init(pulse: UInt32 = 0,
                polarity: UInt32 = 0) {
        self.pulse = pulse
        self.polarity = polarity
    }
}
public struct LPTIMInputCaptureConfiguration: Equatable, Sendable {
    public var inputSource: UInt32
    public var prescaler: UInt32
    public var polarity: UInt32
    public var filter: UInt32
    public init(inputSource: UInt32 = 0,
                prescaler: UInt32 = 0,
                polarity: UInt32 = 0,
                filter: UInt32 = 0) {
        self.inputSource = inputSource
        self.prescaler = prescaler
        self.polarity = polarity
        self.filter = filter
    }
}
public struct LPTIM<Registers: LPTIMRegisterIO, Handle: LPTIMHandleIO, Callbacks: LPTIMCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: LPTIMCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public let getSystemCoreClock: () -> UInt32
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                getSystemCoreClock: @escaping () -> UInt32,
                defaults: LPTIMCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.getSystemCoreClock = getSystemCoreClock
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
