import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32RCCRegisters: RCCRegisterIO {
    public init() {}

    public mutating func read(_ register: RCCClockRegister) -> UInt32 {
        var clocks = STM32RCCClockRegisters()
        return clocks.read(register)
    }

    public mutating func write(_ register: RCCClockRegister, value: UInt32) {
        switch register {
        case .cr: rcc.cr.write { $0.raw.storage = value }
        case .cfgr: rcc.cfgr.write { $0.raw.storage = value }
        case .cdcfgr: rcc.cdcfgr.write { $0.raw.storage = value }
        case .bmcfgr: rcc.bmcfgr.write { $0.raw.storage = value }
        case .apbcfgr: rcc.apbcfgr.write { $0.raw.storage = value }
        case .pllckselr: rcc.pllckselr.write { $0.raw.storage = value }
        case .pllcfgr: rcc.pllcfgr.write { $0.raw.storage = value }
        case .pll1divr1: rcc.pll1divr1.write { $0.raw.storage = value }
        case .pll1fracr: rcc.pll1fracr.write { $0.raw.storage = value }
        case .pll2divr1: rcc.pll2divr1.write { $0.raw.storage = value }
        case .pll2fracr: rcc.pll2fracr.write { $0.raw.storage = value }
        case .pll3divr1: rcc.pll3divr1.write { $0.raw.storage = value }
        case .pll3fracr: rcc.pll3fracr.write { $0.raw.storage = value }
        case .pll1divr2: rcc.pll1divr2.write { $0.raw.storage = value }
        case .pll2divr2: rcc.pll2divr2.write { $0.raw.storage = value }
        case .pll3divr2: rcc.pll3divr2.write { $0.raw.storage = value }
        }
    }

    public mutating func read(_ register: RCCControlRegister) -> UInt32 {
        switch register {
        case .hsicfgr: return rcc.hsicfgr.read().raw.storage
        case .bdcr: return rcc.bdcr.read().raw.storage
        case .csr: return rcc.csr.read().raw.storage
        case .cier: return rcc.cier.read().raw.storage
        case .cifr: return rcc.cifr.read().raw.storage
        case .cicr: return rcc.cicr.read().raw.storage
        case .rsr: return rcc.rsr.read().raw.storage
        case .ahb4enr: return rcc.ahb4enr.read().raw.storage
        case .powerControl1: return pwr.cr1.read().raw.storage
        }
    }

    public mutating func write(_ register: RCCControlRegister, value: UInt32) {
        switch register {
        case .hsicfgr: rcc.hsicfgr.write { $0.raw.storage = value }
        case .bdcr: rcc.bdcr.write { $0.raw.storage = value }
        case .csr: rcc.csr.write { $0.raw.storage = value }
        case .cier: rcc.cier.write { $0.raw.storage = value }
        case .cicr: rcc.cicr.write { $0.raw.storage = value }
        case .rsr: rcc.rsr.write { $0.raw.storage = value }
        case .ahb4enr: rcc.ahb4enr.write { $0.raw.storage = value }
        case .powerControl1: pwr.cr1.write { $0.raw.storage = value }
        case .cifr: preconditionFailure("RCC interrupt flags are read-only")
        }
    }

    public func read(_ register: FlashTimingRegister) -> UInt32 {
        STM32FlashTimingRegisters().read(register)
    }

    public func write(_ register: FlashTimingRegister, value: UInt32) {
        STM32FlashTimingRegisters().write(register, value: value)
    }

    public mutating func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration) {
        var gpio = GPIO(registers: STM32GPIORegisters(port: port), port: port)
        gpio.initialize(configuration)
    }
}

public extension STM32H7RSHAL.RCC where IO == STM32RCCRegisters {
    init(system: System, oscillators: RCCOscillatorValues = .init(), timeouts: RCCTimeouts = .init()) {
        self.init(registers: STM32RCCRegisters(), system: system, oscillators: oscillators, timeouts: timeouts)
    }
}
