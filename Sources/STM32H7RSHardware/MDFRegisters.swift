import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// The pinned MDF HAL targets ADF1 and its only filter, ADF1_Filter0.
public struct STM32MDFRegisters: MDFRegisterIO {
    public init() {}
    public func read(_ register: MDFRegister) -> UInt32 {
        switch register {
        case .gcr: return adf.gcr.read().raw.storage
        case .ckgcr: return adf.ckgcr.read().raw.storage
        case .sitfcr: return adf.sitf0cr.read().raw.storage
        case .bsmxcr: return adf.bsmx0cr.read().raw.storage
        case .dfltcr: return adf.dflt0cr.read().raw.storage
        case .dfltcicr: return adf.dflt0cicr.read().raw.storage
        case .dfltrsfr: return adf.dflt0rsfr.read().raw.storage
        case .dlycr: return adf.dly0cr.read().raw.storage
        case .dfltier: return adf.dflt0ier.read().raw.storage
        case .dfltisr: return adf.dflt0isr.read().raw.storage
        case .sadcr: return adf.sadcr.read().raw.storage
        case .sadcfgr: return adf.sadcfgr.read().raw.storage
        case .sadsdlvr: return adf.sadsdlvr.read().raw.storage
        case .sadanlvr: return adf.sadanlvr.read().raw.storage
        case .dfltdr: return adf.dflt0dr.read().raw.storage
        }
    }
    public func write(_ register: MDFRegister, value: UInt32) {
        switch register {
        case .gcr: adf.gcr.write { $0.raw.storage = value }
        case .ckgcr: adf.ckgcr.write { $0.raw.storage = value }
        case .sitfcr: adf.sitf0cr.write { $0.raw.storage = value }
        case .bsmxcr: adf.bsmx0cr.write { $0.raw.storage = value }
        case .dfltcr: adf.dflt0cr.write { $0.raw.storage = value }
        case .dfltcicr: adf.dflt0cicr.write { $0.raw.storage = value }
        case .dfltrsfr: adf.dflt0rsfr.write { $0.raw.storage = value }
        case .dlycr: adf.dly0cr.write { $0.raw.storage = value }
        case .dfltier: adf.dflt0ier.write { $0.raw.storage = value }
        case .dfltisr: adf.dflt0isr.write { $0.raw.storage = value }
        case .sadcr: adf.sadcr.write { $0.raw.storage = value }
        case .sadcfgr: adf.sadcfgr.write { $0.raw.storage = value }
        case .sadsdlvr: preconditionFailure("ADF register is read-only")
        case .sadanlvr: preconditionFailure("ADF register is read-only")
        case .dfltdr: preconditionFailure("ADF register is read-only")
        }
    }
    public func dataAddress() -> UInt32 { UInt32(adf.dflt0dr.unsafeAddress) }
    func address(of register: MDFRegister) -> UInt {
        switch register {
        case .gcr: return adf.gcr.unsafeAddress
        case .ckgcr: return adf.ckgcr.unsafeAddress
        case .sitfcr: return adf.sitf0cr.unsafeAddress
        case .bsmxcr: return adf.bsmx0cr.unsafeAddress
        case .dfltcr: return adf.dflt0cr.unsafeAddress
        case .dfltcicr: return adf.dflt0cicr.unsafeAddress
        case .dfltrsfr: return adf.dflt0rsfr.unsafeAddress
        case .dlycr: return adf.dly0cr.unsafeAddress
        case .dfltier: return adf.dflt0ier.unsafeAddress
        case .dfltisr: return adf.dflt0isr.unsafeAddress
        case .sadcr: return adf.sadcr.unsafeAddress
        case .sadcfgr: return adf.sadcfgr.unsafeAddress
        case .sadsdlvr: return adf.sadsdlvr.unsafeAddress
        case .sadanlvr: return adf.sadanlvr.unsafeAddress
        case .dfltdr: return adf.dflt0dr.unsafeAddress
        }
    }
}
