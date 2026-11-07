import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32RCCClockRegisters: RCCClockRegisterIO {
    public init() {}

    public mutating func read(_ register: RCCClockRegister) -> UInt32 {
        // These offsets and fields match CMSIS RCC_TypeDef for H7R3/H7R7/H7S3/H7S7.
        switch register {
        case .cr: return rcc.cr.read().raw.storage
        case .cfgr: return rcc.cfgr.read().raw.storage
        case .cdcfgr: return rcc.cdcfgr.read().raw.storage
        case .bmcfgr: return rcc.bmcfgr.read().raw.storage
        case .apbcfgr: return rcc.apbcfgr.read().raw.storage
        case .pllckselr: return rcc.pllckselr.read().raw.storage
        case .pllcfgr: return rcc.pllcfgr.read().raw.storage
        case .pll1divr1: return rcc.pll1divr1.read().raw.storage
        case .pll1fracr: return rcc.pll1fracr.read().raw.storage
        case .pll2divr1: return rcc.pll2divr1.read().raw.storage
        case .pll2fracr: return rcc.pll2fracr.read().raw.storage
        case .pll3divr1: return rcc.pll3divr1.read().raw.storage
        case .pll3fracr: return rcc.pll3fracr.read().raw.storage
        case .pll1divr2: return rcc.pll1divr2.read().raw.storage
        case .pll2divr2: return rcc.pll2divr2.read().raw.storage
        case .pll3divr2: return rcc.pll3divr2.read().raw.storage
        }
    }
}

public extension RCCClock where IO == STM32RCCClockRegisters {
    init(oscillators: RCCOscillatorValues = RCCOscillatorValues()) {
        self.init(registers: STM32RCCClockRegisters(), oscillators: oscillators)
    }
}
