import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32RCCClockRecoveryRegisters: CRSRegisterIO {
    public init() {}

    public func read(_ register: CRSRegister) -> UInt32 {
        switch register {
        case .cr: return crs.cr.read().raw.storage
        case .cfgr: return crs.cfgr.read().raw.storage
        case .isr: return crs.isr.read().raw.storage
        case .icr: return crs.icr.read().raw.storage
        case .rccAPB1Reset2: return rcc.apb1rstr2.read().raw.storage
        }
    }

    public func write(_ register: CRSRegister, value: UInt32) {
        switch register {
        case .cr: crs.cr.write { $0.raw.storage = value }
        case .cfgr: crs.cfgr.write { $0.raw.storage = value }
        case .icr: crs.icr.write { $0.raw.storage = value }
        case .rccAPB1Reset2: rcc.apb1rstr2.write { $0.raw.storage = value }
        case .isr: preconditionFailure("CRS status register is read-only")
        }
    }
}

public extension STM32H7RSHAL.RCCClockRecovery where IO == STM32RCCClockRecoveryRegisters {
    init() { self.init(registers: STM32RCCClockRecoveryRegisters()) }
}
