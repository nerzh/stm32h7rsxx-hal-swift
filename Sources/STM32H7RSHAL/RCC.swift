// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_rcc.c/.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum RCCControlRegister: Hashable, CaseIterable {
    case hsicfgr, bdcr, csr, cier, cifr, cicr, rsr, ahb4enr
    case powerControl1
}

public protocol RCCRegisterIO: RCCClockRegisterIO, FlashTimingRegisterIO {
    mutating func write(_ register: RCCClockRegister, value: UInt32)
    mutating func read(_ register: RCCControlRegister) -> UInt32
    mutating func write(_ register: RCCControlRegister, value: UInt32)
    mutating func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration)
}

// State and tick access are nonmutating so an ISR can use its own immutable
// handle while an RCC configuration call is active. Copies must share storage.
public protocol RCCSystemIO {
    func getTick() -> UInt32
    func getTickPriority() -> UInt32
    func getSystemCoreClock() -> UInt32
    func setSystemCoreClock(_ frequency: UInt32)
    func initializeTick(priority: UInt32, coreClockHz: UInt32) -> HALStatus
}

public struct RCCTimeouts: Equatable, Sendable {
    public var hseStartup: UInt32
    public var lseStartup: UInt32
    public init(hseStartup: UInt32 = 100, lseStartup: UInt32 = 5_000) {
        self.hseStartup = hseStartup
        self.lseStartup = lseStartup
    }
}

// Fields retain the upstream encodings, including values read from hardware.
// State: 0 = unchanged, 1 = off, 2 = on. Source: 0 = HSI, 1 = CSI, 2 = HSE.
public struct RCCPLLConfiguration: Equatable, Sendable {
    public var state: UInt32
    public var source: UInt32
    public var m: UInt32
    public var n: UInt32
    public var p: UInt32
    public var q: UInt32
    public var r: UInt32
    public var s: UInt32
    public var t: UInt32
    public var fractional: UInt32

    public init(state: UInt32 = 0, source: UInt32 = 0, m: UInt32 = 0, n: UInt32 = 0,
                p: UInt32 = 0, q: UInt32 = 0, r: UInt32 = 0, s: UInt32 = 0,
                t: UInt32 = 0, fractional: UInt32 = 0) {
        self.state = state; self.source = source; self.m = m; self.n = n
        self.p = p; self.q = q; self.r = r; self.s = s; self.t = t
        self.fractional = fractional
    }
}

public struct RCCOscillatorConfiguration: Equatable, Sendable {
    // OscillatorType bits: HSE=1, HSI=2, LSE=4, LSI=8, CSI=16, HSI48=32.
    public var oscillatorType: UInt32
    public var hseState: UInt32
    public var lseState: UInt32
    public var hsiState: UInt32
    public var hsiDivider: UInt32
    public var hsiCalibration: UInt32
    public var lsiState: UInt32
    public var hsi48State: UInt32
    public var csiState: UInt32
    public var pll1: RCCPLLConfiguration
    public var pll2: RCCPLLConfiguration
    public var pll3: RCCPLLConfiguration

    public init(oscillatorType: UInt32 = 0, hseState: UInt32 = 0, lseState: UInt32 = 0,
                hsiState: UInt32 = 0, hsiDivider: UInt32 = 0, hsiCalibration: UInt32 = 0,
                lsiState: UInt32 = 0, hsi48State: UInt32 = 0, csiState: UInt32 = 0,
                pll1: RCCPLLConfiguration = .init(), pll2: RCCPLLConfiguration = .init(),
                pll3: RCCPLLConfiguration = .init()) {
        self.oscillatorType = oscillatorType; self.hseState = hseState; self.lseState = lseState
        self.hsiState = hsiState; self.hsiDivider = hsiDivider; self.hsiCalibration = hsiCalibration
        self.lsiState = lsiState; self.hsi48State = hsi48State; self.csiState = csiState
        self.pll1 = pll1; self.pll2 = pll2; self.pll3 = pll3
    }
}

public struct RCCClockConfiguration: Equatable, Sendable {
    // ClockType bits: SYSCLK=1, HCLK=2, PCLK1=4, PCLK2=8, PCLK4=16, PCLK5=32.
    public var clockType: UInt32
    public var systemSource: UInt32
    public var systemDivider: UInt32
    public var ahbDivider: UInt32
    public var apb1Divider: UInt32
    public var apb2Divider: UInt32
    public var apb4Divider: UInt32
    public var apb5Divider: UInt32

    public init(clockType: UInt32 = 0, systemSource: UInt32 = 0, systemDivider: UInt32 = 0,
                ahbDivider: UInt32 = 0, apb1Divider: UInt32 = 0, apb2Divider: UInt32 = 0,
                apb4Divider: UInt32 = 0, apb5Divider: UInt32 = 0) {
        self.clockType = clockType; self.systemSource = systemSource; self.systemDivider = systemDivider
        self.ahbDivider = ahbDivider; self.apb1Divider = apb1Divider; self.apb2Divider = apb2Divider
        self.apb4Divider = apb4Divider; self.apb5Divider = apb5Divider
    }
}

public struct RCC<IO: RCCRegisterIO, System: RCCSystemIO> {
    public var registers: IO
    public let system: System
    public var oscillators: RCCOscillatorValues
    public var timeouts: RCCTimeouts

    public init(registers: IO, system: System, oscillators: RCCOscillatorValues = .init(),
                timeouts: RCCTimeouts = .init()) {
        self.registers = registers
        self.system = system
        self.oscillators = oscillators
        self.timeouts = timeouts
    }

    @discardableResult
    public mutating func deinitialize() -> HALStatus {
        var started = system.getTick()
        set(.cr, bits: 1)
        if !wait(.cr, mask: 4, equals: 4, started: started, timeout: 1) { return .timeout }
        set(.hsicfgr, bits: 0x4000_0000)

        var clock = RCCClock(registers: registers, oscillators: oscillators)
        let hclk = clock.getHCLKFreq()
        registers = clock.registers
        if hclk > oscillators.hsi {
            registers.write(.cfgr, value: 0)
            system.setSystemCoreClock(oscillators.hsi)
            if initializeTick() != .ok { return .error }
            started = system.getTick()
            if !wait(.cfgr, mask: 0x38, equals: 0, started: started, timeout: 5_000) { return .timeout }
            FlashTiming(registers: registers).setLatency(.waitStates1)
        } else {
            FlashTiming(registers: registers).setLatency(.waitStates1)
            registers.write(.cfgr, value: 0)
            // Upstream does not update SystemCoreClock in this branch.
            if initializeTick() != .ok { return .error }
            started = system.getTick()
            if !wait(.cfgr, mask: 0x38, equals: 0, started: started, timeout: 5_000) { return .timeout }
        }

        started = system.getTick()
        clear(.cr, bits: 0x0001_0000 | 2 | 0x18 | 0x80 | 0x200 | 0x1000 | 0x0010_0000)
        if !wait(.cr, mask: 0x0002_0000, equals: 0, started: started, timeout: timeouts.hseStartup) { return .timeout }

        started = system.getTick()
        clear(.cr, bits: 0x0100_0000)
        if !wait(.cr, mask: 0x0200_0000, equals: 0, started: started, timeout: 50) { return .timeout }
        started = system.getTick()
        clear(.cr, bits: 0x0400_0000)
        if !wait(.cr, mask: 0x0800_0000, equals: 0, started: started, timeout: 50) { return .timeout }
        started = system.getTick()
        clear(.cr, bits: 0x1000_0000)
        if !wait(.cr, mask: 0x2000_0000, equals: 0, started: started, timeout: 50) { return .timeout }

        registers.write(.cdcfgr, value: 0)
        registers.write(.bmcfgr, value: 0)
        registers.write(.apbcfgr, value: 0)
        registers.write(.pllckselr, value: 0x0202_0200)
        registers.write(.pllcfgr, value: 0)
        registers.write(.pll1divr1, value: 0x0101_0280)
        registers.write(.pll1divr2, value: 0x0000_0101)
        registers.write(.pll1fracr, value: 0)
        registers.write(.pll2divr1, value: 0x0101_0280)
        registers.write(.pll2divr2, value: 0x0000_0101)
        registers.write(.pll2fracr, value: 0)
        registers.write(.pll3divr1, value: 0x0101_0280)
        registers.write(.pll3divr2, value: 0x0000_0101)
        registers.write(.pll3fracr, value: 0)
        clear(.cr, bits: 0x0004_0000)
        registers.write(.cier, value: 0)
        registers.write(.cicr, value: UInt32.max)
        set(.rsr, bits: 0x0001_0000)
        return .ok
    }

    @discardableResult
    public mutating func configureOscillators(_ configuration: inout RCCOscillatorConfiguration?) -> HALStatus {
        guard var value = configuration else { return .error }
        let status = configureOscillators(&value)
        configuration = value
        return status
    }

    @discardableResult
    public mutating func configureOscillators(_ configuration: inout RCCOscillatorConfiguration) -> HALStatus {
        precondition(configuration.oscillatorType == 0 || (configuration.oscillatorType & 0x3F) != 0)
        let sysclksrc = registers.read(.cfgr) & 0x38
        let pllsrc = registers.read(.pllckselr) & 3
        let pllrdy = registers.read(.cr) & 0x2A00_0000

        if (configuration.oscillatorType & 1) == 1 {
            let state = configuration.hseState
            precondition(state == 0 || state == 0x10000 || state == 0x50000 || state == 0xD0000)
            if sysclksrc == 0x10 || (pllrdy != 0 && pllsrc == 2) {
                if state == 0 { return .error }
            } else {
                configureHSE(state)
                let started = system.getTick()
                if !wait(.cr, mask: 0x20000, equals: state == 0 ? 0 : 0x20000,
                         started: started, timeout: timeouts.hseStartup) { return .timeout }
            }
        }

        if (configuration.oscillatorType & 2) == 2 {
            precondition(configuration.hsiState == 0 || configuration.hsiState == 1)
            precondition(configuration.hsiCalibration <= 0x7F)
            if sysclksrc == 0 || (pllrdy != 0 && pllsrc == 0) {
                if configuration.hsiState == 0 { return .error }
                let previousDivider = registers.read(.cr) & 0x18
                if pllsrc == 0 && pllrdy != 0 && previousDivider != configuration.hsiDivider { return .error }
                precondition(configuration.hsiDivider == 0 || configuration.hsiDivider == 8 ||
                             configuration.hsiDivider == 16 || configuration.hsiDivider == 24)
                modify(.cr, clear: 0x19, set: 1 | configuration.hsiDivider)
                if sysclksrc == 0 {
                    system.setSystemCoreClock(oscillators.hsi / (1 << ((registers.read(.cr) & 0x18) >> 3)))
                }
                if initializeTick() != .ok { return .error }
                modify(.hsicfgr, clear: 0x7F00_0000, set: configuration.hsiCalibration << 24)
            } else if configuration.hsiState != 0 {
                modify(.cr, clear: 0x19, set: configuration.hsiState | configuration.hsiDivider)
                modify(.hsicfgr, clear: 0x7F00_0000, set: configuration.hsiCalibration << 24)
                let started = system.getTick()
                if !wait(.cr, mask: 4, equals: 4, started: started, timeout: 1) { return .timeout }
            } else {
                clear(.cr, bits: 1)
                let started = system.getTick()
                if !wait(.cr, mask: 4, equals: 0, started: started, timeout: 1) { return .timeout }
            }
        }

        if (configuration.oscillatorType & 0x10) == 0x10 {
            precondition(configuration.csiState == 0 || configuration.csiState == 0x80)
            if sysclksrc == 8 || (pllrdy != 0 && pllsrc == 1) {
                if configuration.csiState == 0 { return .error }
            } else {
                if configuration.csiState != 0 { set(.cr, bits: 0x80) } else { clear(.cr, bits: 0x80) }
                let started = system.getTick()
                if !wait(.cr, mask: 0x100, equals: configuration.csiState == 0 ? 0 : 0x100,
                         started: started, timeout: 1) { return .timeout }
            }
        }

        if (configuration.oscillatorType & 8) == 8 {
            precondition(configuration.lsiState == 0 || configuration.lsiState == 1)
            if configuration.lsiState != 0 { set(.csr, bits: 1) } else { clear(.csr, bits: 1) }
            let started = system.getTick()
            if !wait(.csr, mask: 2, equals: configuration.lsiState == 0 ? 0 : 2,
                     started: started, timeout: 1) { return .timeout }
        }

        if (configuration.oscillatorType & 0x20) == 0x20 {
            precondition(configuration.hsi48State == 0 || configuration.hsi48State == 0x1000)
            if configuration.hsi48State != 0 { set(.cr, bits: 0x1000) } else { clear(.cr, bits: 0x1000) }
            let started = system.getTick()
            if !wait(.cr, mask: 0x2000, equals: configuration.hsi48State == 0 ? 0 : 0x2000,
                     started: started, timeout: 1) { return .timeout }
        }

        if (configuration.oscillatorType & 4) == 4 {
            let state = configuration.lseState
            precondition(state == 0 || state == 1 || state == 5 || state == 0x85)
            set(.powerControl1, bits: 0x100)
            configureLSE(state)
            let started = system.getTick()
            if !wait(.bdcr, mask: 2, equals: state == 0 ? 0 : 2,
                     started: started, timeout: timeouts.lseStartup) { return .timeout }
        }

        precondition(configuration.pll1.state <= 2)
        if configuration.pll1.state != 0 {
            if sysclksrc == 0x18 {
                if configuration.pll1.state == 1 { return .error }
                let previousFraction = (registers.read(.pll1fracr) & 0xFFF8) >> 3
                if configuration.pll1.fractional != previousFraction {
                    precondition(configuration.pll1.fractional <= 8191)
                    clear(.pllcfgr, bits: 1)
                    let started = system.getTick()
                    while (system.getTick() &- started) < 1 {}
                    modify(.pll1fracr, clear: 0xFFF8, set: configuration.pll1.fractional << 3)
                    set(.pllcfgr, bits: 1)
                }
            } else {
                configuration.pll1.t = 1
                if configurePLL(0, configuration: configuration.pll1) != .ok { return .error }
            }
        }
        precondition(configuration.pll2.state <= 2)
        if configuration.pll2.state != 0 {
            if configurePLL(1, configuration: configuration.pll2) != .ok { return .error }
        }
        precondition(configuration.pll3.state <= 2)
        if configuration.pll3.state != 0 {
            configuration.pll3.t = 1
            if configurePLL(2, configuration: configuration.pll3) != .ok { return .error }
        }
        return .ok
    }

    @discardableResult
    public mutating func configureClock(_ configuration: RCCClockConfiguration?, latency: FlashLatency) -> HALStatus {
        guard let configuration else { return .error }
        precondition(configuration.clockType >= 1 && configuration.clockType <= 63)

        if latency.rawValue > FlashTiming(registers: registers).getLatency() {
            FlashTiming(registers: registers).setLatency(latency)
            if FlashTiming(registers: registers).getLatency() != latency.rawValue { return .error }
        }

        configureAPBDivider(type: 4, clockType: configuration.clockType, divider: configuration.apb1Divider,
                            position: 0, increasing: true)
        configureAPBDivider(type: 8, clockType: configuration.clockType, divider: configuration.apb2Divider,
                            position: 4, increasing: true)
        configureAPBDivider(type: 16, clockType: configuration.clockType, divider: configuration.apb4Divider,
                            position: 8, increasing: true)
        configureAPBDivider(type: 32, clockType: configuration.clockType, divider: configuration.apb5Divider,
                            position: 12, increasing: true)
        if (configuration.clockType & 2) == 2 {
            precondition(configuration.ahbDivider == 0 || (8...15).contains(configuration.ahbDivider))
            if configuration.ahbDivider > (registers.read(.bmcfgr) & 0xF) {
                modify(.bmcfgr, clear: 0xF, set: configuration.ahbDivider)
            }
        }

        if (configuration.clockType & 1) == 1 {
            precondition(configuration.systemSource <= 3)
            precondition(configuration.systemDivider == 0 || (8...15).contains(configuration.systemDivider))
            modify(.cdcfgr, clear: 0xF, set: configuration.systemDivider)
            let readyMask: UInt32
            if configuration.systemSource == 2 { readyMask = 0x0002_0000 }
            else if configuration.systemSource == 3 { readyMask = 0x0200_0000 }
            else if configuration.systemSource == 1 { readyMask = 0x100 }
            else { readyMask = 4 }
            if (registers.read(.cr) & readyMask) == 0 { return .error }
            modify(.cfgr, clear: 7, set: configuration.systemSource)
            let started = system.getTick()
            if !wait(.cfgr, mask: 0x38, equals: configuration.systemSource << 3,
                     started: started, timeout: 5_000) { return .timeout }
        }

        if (configuration.clockType & 2) == 2 {
            precondition(configuration.ahbDivider == 0 || (8...15).contains(configuration.ahbDivider))
            if configuration.ahbDivider < (registers.read(.bmcfgr) & 0xF) {
                modify(.bmcfgr, clear: 0xF, set: configuration.ahbDivider)
            }
        }
        if latency.rawValue < FlashTiming(registers: registers).getLatency() {
            FlashTiming(registers: registers).setLatency(latency)
            if FlashTiming(registers: registers).getLatency() != latency.rawValue { return .error }
        }
        configureAPBDivider(type: 4, clockType: configuration.clockType, divider: configuration.apb1Divider,
                            position: 0, increasing: false)
        configureAPBDivider(type: 8, clockType: configuration.clockType, divider: configuration.apb2Divider,
                            position: 4, increasing: false)
        configureAPBDivider(type: 16, clockType: configuration.clockType, divider: configuration.apb4Divider,
                            position: 8, increasing: false)
        configureAPBDivider(type: 32, clockType: configuration.clockType, divider: configuration.apb5Divider,
                            position: 12, increasing: false)

        var clock = RCCClock(registers: registers, oscillators: oscillators)
        let frequency = clock.getSysClockFreq()
        registers = clock.registers
        system.setSystemCoreClock(frequency)
        return initializeTick()
    }

    public mutating func getOscillatorConfiguration() -> RCCOscillatorConfiguration {
        var configuration = RCCOscillatorConfiguration(oscillatorType: 0x3F)
        var value = registers.read(.bdcr)
        configuration.lseState = value & 0x85
        value = registers.read(.csr)
        configuration.lsiState = value & 1
        value = registers.read(.cr)
        configuration.hseState = value & 0x000D_0000
        configuration.hsiState = value & 1
        configuration.hsiDivider = value & 0x18
        configuration.hsiCalibration = (registers.read(.hsicfgr) & 0x7F00_0000) >> 24
        configuration.hsi48State = value & 0x1000
        configuration.csiState = value & 0x80
        configuration.pll1 = getPLLConfiguration(0, control: value)
        value = registers.read(.cr)
        configuration.pll2 = getPLLConfiguration(1, control: value)
        value = registers.read(.cr)
        configuration.pll3 = getPLLConfiguration(2, control: value)
        return configuration
    }

    public mutating func getClockConfiguration() -> (configuration: RCCClockConfiguration, latency: UInt32) {
        var configuration = RCCClockConfiguration(clockType: 0x3F)
        configuration.systemSource = registers.read(.cfgr) & 7
        configuration.systemDivider = registers.read(.cdcfgr) & 0xF
        configuration.ahbDivider = registers.read(.bmcfgr) & 0xF
        configuration.apb1Divider = registers.read(.apbcfgr) & 7
        configuration.apb2Divider = registers.read(.apbcfgr) & 0x70
        configuration.apb4Divider = registers.read(.apbcfgr) & 0x700
        configuration.apb5Divider = registers.read(.apbcfgr) & 0x7000
        return (configuration, FlashTiming(registers: registers).getLatency())
    }

    // Output encodings: RCC_MCO1_PA8 = 0x100, RCC_MCO2_PC9 = 0x10020200.
    // Source and divider retain their upstream RCC_CFGR field encodings.
    public mutating func configureMCO(output: UInt32, source: UInt32, divider: UInt32) {
        precondition(output == 0x100 || output == 0x1002_0200)
        let index = output & 0x1000_0000
        let portIndex = (output & 0x000F_0000) >> 16
        set(.ahb4enr, bits: 1 << portIndex)
        let configuration = GPIOConfiguration(pins: UInt16(output & 0xFFFF), mode: .alternatePushPull,
                                              pull: .none, speed: .veryHigh,
                                              alternate: (output & 0x0FF0_0000) >> 20)
        registers.initializeMCOGPIO(port: GPIOPort(rawValue: portIndex)!, configuration: configuration)
        if index == 0 {
            precondition((divider & ~UInt32(0x003C_0000)) == 0)
            precondition((source & ~UInt32(0x01C0_0000)) == 0 && (source >> 22) <= 4)
            modify(.cfgr, clear: 0x01FC_0000, set: source | divider)
        } else if index == 0x1000_0000 {
            precondition((divider & ~UInt32(0x003C_0000)) == 0)
            precondition((source & ~UInt32(0xE000_0000)) == 0 && (source >> 29) <= 5)
            modify(.cfgr, clear: 0xFE00_0000, set: source | (divider << 7))
        }
    }

    public mutating func enableCSS() { set(.cr, bits: 0x0010_0000) }
    public mutating func disableCSS() { clear(.cr, bits: 0x0010_0000) }

    // The default closure replaces HAL_RCC_HSECSSCallback's empty weak body.
    // HAL_RCC_LSECSSCallback is not called by the upstream RCC NMI handler.
    public mutating func handleNMI(hseCSSCallback: () -> Void = {}) {
        if (registers.read(.cifr) & 0x400) == 0x400 {
            registers.write(.cicr, value: 0x400)
            hseCSSCallback()
        }
    }

    public mutating func getResetSource() -> UInt32 {
        let reset = registers.read(.rsr) & 0x5562_0000
        set(.rsr, bits: 0x0001_0000)
        return reset
    }

    private mutating func configureAPBDivider(type: UInt32, clockType: UInt32, divider: UInt32,
                                             position: UInt32, increasing: Bool) {
        if (clockType & type) == type {
            precondition((divider & ~(UInt32(7) << position)) == 0 &&
                         (divider == 0 || ((divider >> position) >= 4 && (divider >> position) <= 7)))
            let previous = registers.read(.apbcfgr) & (7 << position)
            if increasing ? divider > previous : divider < previous {
                modify(.apbcfgr, clear: 7 << position, set: divider)
            }
        }
    }

    private mutating func getPLLConfiguration(_ number: UInt32, control: UInt32) -> RCCPLLConfiguration {
        var configuration = RCCPLLConfiguration(state: (control & (0x0100_0000 << (2 * number))) != 0 ? 2 : 1)
        var value = registers.read(.pllckselr)
        configuration.source = value & 3
        configuration.m = (value & (0x3F0 << (8 * number))) >> (4 + 8 * number)
        value = registers.read(.pllcfgr)
        if (value & (1 << (11 * number))) != 0 {
            let fracr: RCCClockRegister = number == 0 ? .pll1fracr : number == 1 ? .pll2fracr : .pll3fracr
            value = (registers.read(fracr) & 0xFFF8) >> 3
        } else {
            value = 0
        }
        configuration.fractional = value
        let divr1: RCCClockRegister = number == 0 ? .pll1divr1 : number == 1 ? .pll2divr1 : .pll3divr1
        value = registers.read(divr1)
        configuration.n = (value & 0x1FF) + 1
        configuration.r = ((value & 0x7F00_0000) >> 24) + 1
        configuration.p = ((value & 0xFE00) >> 9) + 1
        configuration.q = ((value & 0x7F_0000) >> 16) + 1
        let divr2: RCCClockRegister = number == 0 ? .pll1divr2 : number == 1 ? .pll2divr2 : .pll3divr2
        value = registers.read(divr2)
        configuration.s = (value & 7) + 1
        configuration.t = number == 1 ? ((value & 0x700) >> 8) + 1 : 0
        return configuration
    }

    // The upstream helper is shared by all three PLLs. Keep it internal so
    // differential tests can check its timeout status before OscConfig maps it.
    mutating func configurePLL(_ number: UInt32, configuration: RCCPLLConfiguration) -> HALStatus {
        precondition(number <= 2)
        let divr1: RCCClockRegister = number == 0 ? .pll1divr1 : number == 1 ? .pll2divr1 : .pll3divr1
        let divr2: RCCClockRegister = number == 0 ? .pll1divr2 : number == 1 ? .pll2divr2 : .pll3divr2
        clear(.pllcfgr, bits: 0x3E0 << (11 * number))
        clear(.cr, bits: 0x0100_0000 << (2 * number))
        var started = system.getTick()
        let ready = UInt32(0x0200_0000) << (2 * number)
        if !wait(.cr, mask: ready, equals: 0, started: started, timeout: 50) { return .timeout }

        if configuration.state == 2 {
            precondition(configuration.source <= 2)
            precondition(configuration.m >= 1 && configuration.m <= 63)
            precondition(configuration.n >= 8 && configuration.n <= 420)
            precondition(configuration.p >= 1 && configuration.p <= 128)
            precondition(configuration.q >= 1 && configuration.q <= 128)
            precondition(configuration.r >= 1 && configuration.r <= 128)
            precondition(configuration.s >= 1 && configuration.s <= 8)
            precondition(configuration.t >= 1 && configuration.t <= 8)
            let source = configuration.source
            var vco: UInt32
            if source == 0 {
                vco = oscillators.hsi >> ((registers.read(.cr) & 0x18) >> 3)
            } else if source == 2 {
                vco = oscillators.hse
            } else {
                vco = oscillators.csi
            }
            vco /= configuration.m
            precondition(vco >= 1_000_000 && vco <= 16_000_000)
            if vco >= 8_000_000 { vco = 0x18 }
            else if vco >= 4_000_000 { vco = 0x10 }
            else if vco >= 2_000_000 { vco = 0x08 }
            else { vco = 0x02 }
            vco <<= 11 * number
            modify(.pllckselr, clear: 3 | (0x3F0 << (8 * number)),
                   set: source | (configuration.m << (4 + 8 * number)))
            if (registers.read(.pllckselr) & 3) != source { return .error }
            modify(.pllcfgr, clear: 0x1B << (11 * number), set: vco)
            registers.write(divr1, value: (configuration.n - 1) | ((configuration.p - 1) << 9) |
                            ((configuration.q - 1) << 16) | ((configuration.r - 1) << 24))
            registers.write(divr2, value: (configuration.s - 1) | ((configuration.t - 1) << 8))
            if number == 0 { set(.pllcfgr, bits: 0x20) }
            if configuration.fractional != 0 {
                precondition(configuration.fractional <= 8191)
                let fracr: RCCClockRegister = number == 0 ? .pll1fracr : number == 1 ? .pll2fracr : .pll3fracr
                modify(fracr, clear: 0xFFF8, set: configuration.fractional << 3)
                set(.pllcfgr, bits: 1 << (11 * number))
            }
            set(.cr, bits: 0x0100_0000 << (2 * number))
            started = system.getTick()
            if !wait(.cr, mask: ready, equals: ready, started: started, timeout: 50) { return .timeout }
        } else {
            // Preserve the additional DIVM1_Pos shift present in the C off path.
            modify(.pllckselr, clear: (0x3F0 << (4 + 8 * number)) | 3, set: 3)
        }
        return .ok
    }

    private func initializeTick() -> HALStatus {
        system.initializeTick(priority: system.getTickPriority(), coreClockHz: system.getSystemCoreClock())
    }

    private mutating func configureHSE(_ state: UInt32) {
        if state == 0x10000 { set(.cr, bits: 0x10000) }
        else if state == 0 {
            clear(.cr, bits: 0x10000); clear(.cr, bits: 0x80000); clear(.cr, bits: 0x40000)
        } else if state == 0x50000 {
            set(.cr, bits: 0x40000); clear(.cr, bits: 0x80000); set(.cr, bits: 0x10000)
        } else if state == 0xD0000 {
            set(.cr, bits: 0x40000); set(.cr, bits: 0x80000); set(.cr, bits: 0x10000)
        } else {
            clear(.cr, bits: 0x10000); clear(.cr, bits: 0x40000); clear(.cr, bits: 0x80000)
        }
    }

    private mutating func configureLSE(_ state: UInt32) {
        if state == 1 { set(.bdcr, bits: 1) }
        else if state == 0 {
            clear(.bdcr, bits: 1); clear(.bdcr, bits: 0x80); clear(.bdcr, bits: 4)
        } else if state == 5 {
            set(.bdcr, bits: 4); clear(.bdcr, bits: 0x80); set(.bdcr, bits: 1)
        } else if state == 0x85 {
            set(.bdcr, bits: 4); set(.bdcr, bits: 0x80); set(.bdcr, bits: 1)
        } else {
            clear(.bdcr, bits: 1); clear(.bdcr, bits: 4); clear(.bdcr, bits: 0x80)
        }
    }

    private mutating func wait(_ register: RCCClockRegister, mask: UInt32, equals value: UInt32,
                               started: UInt32, timeout: UInt32) -> Bool {
        while (registers.read(register) & mask) != value {
            if (system.getTick() &- started) > timeout { return false }
        }
        return true
    }

    private mutating func wait(_ register: RCCControlRegister, mask: UInt32, equals value: UInt32,
                               started: UInt32, timeout: UInt32) -> Bool {
        while (registers.read(register) & mask) != value {
            if (system.getTick() &- started) > timeout { return false }
        }
        return true
    }

    private mutating func modify(_ register: RCCClockRegister, clear mask: UInt32, set value: UInt32) {
        registers.write(register, value: (registers.read(register) & ~mask) | value)
    }
    private mutating func modify(_ register: RCCControlRegister, clear mask: UInt32, set value: UInt32) {
        registers.write(register, value: (registers.read(register) & ~mask) | value)
    }
    private mutating func set(_ register: RCCClockRegister, bits: UInt32) { modify(register, clear: 0, set: bits) }
    private mutating func set(_ register: RCCControlRegister, bits: UInt32) { modify(register, clear: 0, set: bits) }
    private mutating func clear(_ register: RCCClockRegister, bits: UInt32) { modify(register, clear: bits, set: 0) }
    private mutating func clear(_ register: RCCControlRegister, bits: UInt32) { modify(register, clear: bits, set: 0) }
}
