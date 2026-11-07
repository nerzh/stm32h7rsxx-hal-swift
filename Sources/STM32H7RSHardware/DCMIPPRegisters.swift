import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32DCMIPPRegisters: DCMIPPRegisterIO {
    public init() {}
    public func read(_ register: DCMIPPRegister) -> UInt32 {
        switch register {
        case .ipgr1: return dcmipp.ipgr1.read().raw.storage
        case .ipgr2: return dcmipp.ipgr2.read().raw.storage
        case .ipgr3: return dcmipp.ipgr3.read().raw.storage
        case .ipc1r1: return dcmipp.ipc1r1.read().raw.storage
        case .ipc1r2: return dcmipp.ipc1r2.read().raw.storage
        case .ipc1r3: return dcmipp.ipc1r3.read().raw.storage
        case .prcr: return dcmipp.prcr.read().raw.storage
        case .prescr: return dcmipp.prescr.read().raw.storage
        case .presur: return dcmipp.presur.read().raw.storage
        case .cmcr: return dcmipp.cmcr.read().raw.storage
        case .cmfrcr: return dcmipp.cmfrcr.read().raw.storage
        case .cmier: return dcmipp.cmier.read().raw.storage
        case .cmsr1: return dcmipp.cmsr1.read().raw.storage
        case .cmsr2: return dcmipp.cmsr2.read().raw.storage
        case .cmfcr: return dcmipp.cmfcr.read().raw.storage
        case .p0fscr: return dcmipp.p0fscr.read().raw.storage
        case .p0fctcr: return dcmipp.p0fctcr.read().raw.storage
        case .p0scstr: return dcmipp.p0scstr.read().raw.storage
        case .p0scszr: return dcmipp.p0scszr.read().raw.storage
        case .p0dccntr: return dcmipp.p0dccntr.read().raw.storage
        case .p0dclmtr: return dcmipp.p0dclmtr.read().raw.storage
        case .p0ppcr: return dcmipp.p0ppcr.read().raw.storage
        case .p0ppm0ar1: return dcmipp.p0ppm0ar1.read().raw.storage
        case .p0ppm0ar2: return dcmipp.p0ppm0ar2.read().raw.storage
        }
    }
    public func write(_ register: DCMIPPRegister, value: UInt32) {
        switch register {
        case .ipgr1: dcmipp.ipgr1.write { $0.raw.storage = value }
        case .ipgr2: dcmipp.ipgr2.write { $0.raw.storage = value }
        case .ipgr3: preconditionFailure("DCMIPP IPGR3 is read-only")
        case .ipc1r1: dcmipp.ipc1r1.write { $0.raw.storage = value }
        case .ipc1r2: dcmipp.ipc1r2.write { $0.raw.storage = value }
        case .ipc1r3: dcmipp.ipc1r3.write { $0.raw.storage = value }
        case .prcr: dcmipp.prcr.write { $0.raw.storage = value }
        case .prescr: dcmipp.prescr.write { $0.raw.storage = value }
        case .presur: dcmipp.presur.write { $0.raw.storage = value }
        case .cmcr: dcmipp.cmcr.write { $0.raw.storage = value }
        case .cmfrcr: preconditionFailure("DCMIPP CMFRCR is read-only")
        case .cmier: dcmipp.cmier.write { $0.raw.storage = value }
        case .cmsr1: preconditionFailure("DCMIPP CMSR1 is read-only")
        case .cmsr2: preconditionFailure("DCMIPP CMSR2 is read-only")
        case .cmfcr: dcmipp.cmfcr.write { $0.raw.storage = value }
        case .p0fscr: dcmipp.p0fscr.write { $0.raw.storage = value }
        case .p0fctcr: dcmipp.p0fctcr.write { $0.raw.storage = value }
        case .p0scstr: dcmipp.p0scstr.write { $0.raw.storage = value }
        case .p0scszr: dcmipp.p0scszr.write { $0.raw.storage = value }
        case .p0dccntr: preconditionFailure("DCMIPP P0DCCNTR is read-only")
        case .p0dclmtr: dcmipp.p0dclmtr.write { $0.raw.storage = value }
        case .p0ppcr: dcmipp.p0ppcr.write { $0.raw.storage = value }
        case .p0ppm0ar1: dcmipp.p0ppm0ar1.write { $0.raw.storage = value }
        case .p0ppm0ar2: dcmipp.p0ppm0ar2.write { $0.raw.storage = value }
        }
    }
    func address(of register: DCMIPPRegister) -> UInt {
        switch register {
        case .ipgr1: return dcmipp.ipgr1.unsafeAddress
        case .ipgr2: return dcmipp.ipgr2.unsafeAddress
        case .ipgr3: return dcmipp.ipgr3.unsafeAddress
        case .ipc1r1: return dcmipp.ipc1r1.unsafeAddress
        case .ipc1r2: return dcmipp.ipc1r2.unsafeAddress
        case .ipc1r3: return dcmipp.ipc1r3.unsafeAddress
        case .prcr: return dcmipp.prcr.unsafeAddress
        case .prescr: return dcmipp.prescr.unsafeAddress
        case .presur: return dcmipp.presur.unsafeAddress
        case .cmcr: return dcmipp.cmcr.unsafeAddress
        case .cmfrcr: return dcmipp.cmfrcr.unsafeAddress
        case .cmier: return dcmipp.cmier.unsafeAddress
        case .cmsr1: return dcmipp.cmsr1.unsafeAddress
        case .cmsr2: return dcmipp.cmsr2.unsafeAddress
        case .cmfcr: return dcmipp.cmfcr.unsafeAddress
        case .p0fscr: return dcmipp.p0fscr.unsafeAddress
        case .p0fctcr: return dcmipp.p0fctcr.unsafeAddress
        case .p0scstr: return dcmipp.p0scstr.unsafeAddress
        case .p0scszr: return dcmipp.p0scszr.unsafeAddress
        case .p0dccntr: return dcmipp.p0dccntr.unsafeAddress
        case .p0dclmtr: return dcmipp.p0dclmtr.unsafeAddress
        case .p0ppcr: return dcmipp.p0ppcr.unsafeAddress
        case .p0ppm0ar1: return dcmipp.p0ppm0ar1.unsafeAddress
        case .p0ppm0ar2: return dcmipp.p0ppm0ar2.unsafeAddress
        }
    }
}
