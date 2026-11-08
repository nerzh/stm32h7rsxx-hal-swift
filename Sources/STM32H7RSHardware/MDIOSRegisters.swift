import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32MDIOSRegisters: MDIOSRegisterIO {
    public init() {}
    public func read(_ register: MDIOSRegister) -> UInt32 {
        switch register {
        case .cr: return mdios.cr.read().raw.storage
        case .wrfr: return mdios.wrfr.read().raw.storage
        case .cwrfr: return mdios.cwrfr.read().raw.storage
        case .rdfr: return mdios.rdfr.read().raw.storage
        case .crdfr: return mdios.crdfr.read().raw.storage
        case .sr: return mdios.sr.read().raw.storage
        case .clrfr: return mdios.clrfr.read().raw.storage
        }
    }
    public func write(_ register: MDIOSRegister, value: UInt32) {
        switch register {
        case .cr: mdios.cr.write { $0.raw.storage = value }
        case .wrfr: preconditionFailure("MDIOS register is read-only")
        case .cwrfr: mdios.cwrfr.write { $0.raw.storage = value }
        case .rdfr: preconditionFailure("MDIOS register is read-only")
        case .crdfr: mdios.crdfr.write { $0.raw.storage = value }
        case .sr: preconditionFailure("MDIOS register is read-only")
        case .clrfr: mdios.clrfr.write { $0.raw.storage = value }
        }
    }
    public func readInput(_ index: UInt32) -> UInt32 {
        switch index {
        case 0: return mdios.dinr0.read().raw.storage
        case 1: return mdios.dinr1.read().raw.storage
        case 2: return mdios.dinr2.read().raw.storage
        case 3: return mdios.dinr3.read().raw.storage
        case 4: return mdios.dinr4.read().raw.storage
        case 5: return mdios.dinr5.read().raw.storage
        case 6: return mdios.dinr6.read().raw.storage
        case 7: return mdios.dinr7.read().raw.storage
        case 8: return mdios.dinr8.read().raw.storage
        case 9: return mdios.dinr9.read().raw.storage
        case 10: return mdios.dinr10.read().raw.storage
        case 11: return mdios.dinr11.read().raw.storage
        case 12: return mdios.dinr12.read().raw.storage
        case 13: return mdios.dinr13.read().raw.storage
        case 14: return mdios.dinr14.read().raw.storage
        case 15: return mdios.dinr15.read().raw.storage
        case 16: return mdios.dinr16.read().raw.storage
        case 17: return mdios.dinr17.read().raw.storage
        case 18: return mdios.dinr18.read().raw.storage
        case 19: return mdios.dinr19.read().raw.storage
        case 20: return mdios.dinr20.read().raw.storage
        case 21: return mdios.dinr21.read().raw.storage
        case 22: return mdios.dinr22.read().raw.storage
        case 23: return mdios.dinr23.read().raw.storage
        case 24: return mdios.dinr24.read().raw.storage
        case 25: return mdios.dinr25.read().raw.storage
        case 26: return mdios.dinr26.read().raw.storage
        case 27: return mdios.dinr27.read().raw.storage
        case 28: return mdios.dinr28.read().raw.storage
        case 29: return mdios.dinr29.read().raw.storage
        case 30: return mdios.dinr30.read().raw.storage
        case 31: return mdios.dinr31.read().raw.storage
        default: preconditionFailure("MDIOS register index must be below 32")
        }
    }
    public func writeOutput(_ index: UInt32, value: UInt32) {
        switch index {
        case 0: mdios.doutr0.write { $0.raw.storage = value }
        case 1: mdios.doutr1.write { $0.raw.storage = value }
        case 2: mdios.doutr2.write { $0.raw.storage = value }
        case 3: mdios.doutr3.write { $0.raw.storage = value }
        case 4: mdios.doutr4.write { $0.raw.storage = value }
        case 5: mdios.doutr5.write { $0.raw.storage = value }
        case 6: mdios.doutr6.write { $0.raw.storage = value }
        case 7: mdios.doutr7.write { $0.raw.storage = value }
        case 8: mdios.doutr8.write { $0.raw.storage = value }
        case 9: mdios.doutr9.write { $0.raw.storage = value }
        case 10: mdios.doutr10.write { $0.raw.storage = value }
        case 11: mdios.doutr11.write { $0.raw.storage = value }
        case 12: mdios.doutr12.write { $0.raw.storage = value }
        case 13: mdios.doutr13.write { $0.raw.storage = value }
        case 14: mdios.doutr14.write { $0.raw.storage = value }
        case 15: mdios.doutr15.write { $0.raw.storage = value }
        case 16: mdios.doutr16.write { $0.raw.storage = value }
        case 17: mdios.doutr17.write { $0.raw.storage = value }
        case 18: mdios.doutr18.write { $0.raw.storage = value }
        case 19: mdios.doutr19.write { $0.raw.storage = value }
        case 20: mdios.doutr20.write { $0.raw.storage = value }
        case 21: mdios.doutr21.write { $0.raw.storage = value }
        case 22: mdios.doutr22.write { $0.raw.storage = value }
        case 23: mdios.doutr23.write { $0.raw.storage = value }
        case 24: mdios.doutr24.write { $0.raw.storage = value }
        case 25: mdios.doutr25.write { $0.raw.storage = value }
        case 26: mdios.doutr26.write { $0.raw.storage = value }
        case 27: mdios.doutr27.write { $0.raw.storage = value }
        case 28: mdios.doutr28.write { $0.raw.storage = value }
        case 29: mdios.doutr29.write { $0.raw.storage = value }
        case 30: mdios.doutr30.write { $0.raw.storage = value }
        case 31: mdios.doutr31.write { $0.raw.storage = value }
        default: preconditionFailure("MDIOS register index must be below 32")
        }
    }
    var wakeupIMR2: Register<DeviceEXTI.IMR2> { CMSISEXTI.imr2 }
    var wakeupPR2: Register<DeviceEXTI.PR2> { CMSISEXTI.pr2 }
    var wakeupRTSR2: Register<DeviceEXTI.RTSR2> { CMSISEXTI.rtsr2 }
    var wakeupFTSR2: Register<DeviceEXTI.FTSR2> { CMSISEXTI.ftsr2 }
    var wakeupSWIER2: Register<DeviceEXTI.SWIER2> { CMSISEXTI.swier2 }

    public func read(_ register: MDIOSWakeupRegister) -> UInt32 {
        switch register {
        case .imr2: return wakeupIMR2.read().raw.storage
        case .pr2: return wakeupPR2.read().raw.storage
        case .rtsr2: return wakeupRTSR2.read().raw.storage
        case .ftsr2: return wakeupFTSR2.read().raw.storage
        case .swier2: return wakeupSWIER2.read().raw.storage
        }
    }
    public func write(_ register: MDIOSWakeupRegister, value: UInt32) {
        switch register {
        case .imr2: wakeupIMR2.write { $0.raw.storage = value }
        case .pr2: wakeupPR2.write { $0.raw.storage = value }
        case .rtsr2: wakeupRTSR2.write { $0.raw.storage = value }
        case .ftsr2: wakeupFTSR2.write { $0.raw.storage = value }
        case .swier2: wakeupSWIER2.write { $0.raw.storage = value }
        }
    }
    func address(of register: MDIOSRegister) -> UInt {
        switch register {
        case .cr: return mdios.cr.unsafeAddress
        case .wrfr: return mdios.wrfr.unsafeAddress
        case .cwrfr: return mdios.cwrfr.unsafeAddress
        case .rdfr: return mdios.rdfr.unsafeAddress
        case .crdfr: return mdios.crdfr.unsafeAddress
        case .sr: return mdios.sr.unsafeAddress
        case .clrfr: return mdios.clrfr.unsafeAddress
        }
    }
    func inputAddress(_ index: UInt32) -> UInt {
        switch index {
        case 0: return mdios.dinr0.unsafeAddress
        case 1: return mdios.dinr1.unsafeAddress
        case 2: return mdios.dinr2.unsafeAddress
        case 3: return mdios.dinr3.unsafeAddress
        case 4: return mdios.dinr4.unsafeAddress
        case 5: return mdios.dinr5.unsafeAddress
        case 6: return mdios.dinr6.unsafeAddress
        case 7: return mdios.dinr7.unsafeAddress
        case 8: return mdios.dinr8.unsafeAddress
        case 9: return mdios.dinr9.unsafeAddress
        case 10: return mdios.dinr10.unsafeAddress
        case 11: return mdios.dinr11.unsafeAddress
        case 12: return mdios.dinr12.unsafeAddress
        case 13: return mdios.dinr13.unsafeAddress
        case 14: return mdios.dinr14.unsafeAddress
        case 15: return mdios.dinr15.unsafeAddress
        case 16: return mdios.dinr16.unsafeAddress
        case 17: return mdios.dinr17.unsafeAddress
        case 18: return mdios.dinr18.unsafeAddress
        case 19: return mdios.dinr19.unsafeAddress
        case 20: return mdios.dinr20.unsafeAddress
        case 21: return mdios.dinr21.unsafeAddress
        case 22: return mdios.dinr22.unsafeAddress
        case 23: return mdios.dinr23.unsafeAddress
        case 24: return mdios.dinr24.unsafeAddress
        case 25: return mdios.dinr25.unsafeAddress
        case 26: return mdios.dinr26.unsafeAddress
        case 27: return mdios.dinr27.unsafeAddress
        case 28: return mdios.dinr28.unsafeAddress
        case 29: return mdios.dinr29.unsafeAddress
        case 30: return mdios.dinr30.unsafeAddress
        case 31: return mdios.dinr31.unsafeAddress
        default: preconditionFailure("MDIOS register index must be below 32")
        }
    }
    func outputAddress(_ index: UInt32) -> UInt {
        switch index {
        case 0: return mdios.doutr0.unsafeAddress
        case 1: return mdios.doutr1.unsafeAddress
        case 2: return mdios.doutr2.unsafeAddress
        case 3: return mdios.doutr3.unsafeAddress
        case 4: return mdios.doutr4.unsafeAddress
        case 5: return mdios.doutr5.unsafeAddress
        case 6: return mdios.doutr6.unsafeAddress
        case 7: return mdios.doutr7.unsafeAddress
        case 8: return mdios.doutr8.unsafeAddress
        case 9: return mdios.doutr9.unsafeAddress
        case 10: return mdios.doutr10.unsafeAddress
        case 11: return mdios.doutr11.unsafeAddress
        case 12: return mdios.doutr12.unsafeAddress
        case 13: return mdios.doutr13.unsafeAddress
        case 14: return mdios.doutr14.unsafeAddress
        case 15: return mdios.doutr15.unsafeAddress
        case 16: return mdios.doutr16.unsafeAddress
        case 17: return mdios.doutr17.unsafeAddress
        case 18: return mdios.doutr18.unsafeAddress
        case 19: return mdios.doutr19.unsafeAddress
        case 20: return mdios.doutr20.unsafeAddress
        case 21: return mdios.doutr21.unsafeAddress
        case 22: return mdios.doutr22.unsafeAddress
        case 23: return mdios.doutr23.unsafeAddress
        case 24: return mdios.doutr24.unsafeAddress
        case 25: return mdios.doutr25.unsafeAddress
        case 26: return mdios.doutr26.unsafeAddress
        case 27: return mdios.doutr27.unsafeAddress
        case 28: return mdios.doutr28.unsafeAddress
        case 29: return mdios.doutr29.unsafeAddress
        case 30: return mdios.doutr30.unsafeAddress
        case 31: return mdios.doutr31.unsafeAddress
        default: preconditionFailure("MDIOS register index must be below 32")
        }
    }
}
