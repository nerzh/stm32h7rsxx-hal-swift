import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32PowerExtendedRegisters: PowerExtendedRegisterIO {
    public init() {}

    public func read(_ register: PowerExtendedRegister) -> UInt32 {
        switch register {
        case .cr1: return pwr.cr1.read().raw.storage
        case .sr1: return pwr.sr1.read().raw.storage
        case .csr1: return pwr.csr1.read().raw.storage
        case .csr2: return pwr.csr2.read().raw.storage
        case .csr3: return pwr.csr3.read().raw.storage
        case .csr4: return pwr.csr4.read().raw.storage
        case .wakeupClear: return pwr.wkupcr.read().raw.storage
        case .wakeupFlags: return pwr.wkupfr.read().raw.storage
        case .wakeupEnablePolarity: return pwr.wkupepr.read().raw.storage
        case .ucpdr: return pwr.ucpdr.read().raw.storage
        case .apcr: return pwr.apcr.read().raw.storage
        case .pullUpN: return pwr.pucrn.read().raw.storage
        case .pullDownN: return pwr.pdcrn.read().raw.storage
        case .pullUpO: return pwr.pucro.read().raw.storage
        case .pullDownO: return pwr.pdcro.read().raw.storage
        case .pullDownP: return pwr.pdcrp.read().raw.storage
        case .extiInterruptMask: return CMSISEXTI.imr1.read().raw.storage
        case .extiEventMask: return CMSISEXTI.emr1.read().raw.storage
        case .extiRisingTrigger: return CMSISEXTI.rtsr1.read().raw.storage
        case .extiFallingTrigger: return CMSISEXTI.ftsr1.read().raw.storage
        case .extiPending: return CMSISEXTI.pr1.read().raw.storage
        case .extiSoftwareInterrupt: return CMSISEXTI.swier1.read().raw.storage
        case .extiInterruptMask2: return CMSISEXTI.imr2.read().raw.storage
        }
    }

    public func write(_ register: PowerExtendedRegister, value: UInt32) {
        switch register {
        case .cr1: pwr.cr1.write { $0.raw.storage = value }
        case .csr1: pwr.csr1.write { $0.raw.storage = value }
        case .csr2: pwr.csr2.write { $0.raw.storage = value }
        case .csr3: pwr.csr3.write { $0.raw.storage = value }
        case .csr4: pwr.csr4.write { $0.raw.storage = value }
        case .wakeupClear: pwr.wkupcr.write { $0.raw.storage = value }
        case .wakeupEnablePolarity: pwr.wkupepr.write { $0.raw.storage = value }
        case .ucpdr: pwr.ucpdr.write { $0.raw.storage = value }
        case .apcr: pwr.apcr.write { $0.raw.storage = value }
        case .pullUpN: pwr.pucrn.write { $0.raw.storage = value }
        case .pullDownN: pwr.pdcrn.write { $0.raw.storage = value }
        case .pullUpO: pwr.pucro.write { $0.raw.storage = value }
        case .pullDownO: pwr.pdcro.write { $0.raw.storage = value }
        case .pullDownP: pwr.pdcrp.write { $0.raw.storage = value }
        case .extiInterruptMask: CMSISEXTI.imr1.write { $0.raw.storage = value }
        case .extiEventMask: CMSISEXTI.emr1.write { $0.raw.storage = value }
        case .extiRisingTrigger: CMSISEXTI.rtsr1.write { $0.raw.storage = value }
        case .extiFallingTrigger: CMSISEXTI.ftsr1.write { $0.raw.storage = value }
        case .extiPending: CMSISEXTI.pr1.write { $0.raw.storage = value }
        case .extiSoftwareInterrupt: CMSISEXTI.swier1.write { $0.raw.storage = value }
        case .extiInterruptMask2: CMSISEXTI.imr2.write { $0.raw.storage = value }
        case .sr1, .wakeupFlags: preconditionFailure("PWR status is read-only")
        }
    }
}

public extension PowerExtended where IO == STM32PowerExtendedRegisters {
    init() { self.init(registers: STM32PowerExtendedRegisters()) }
}
