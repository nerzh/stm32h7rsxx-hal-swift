import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32GFXTIMRegisters: GFXTIMRegisterIO {
    public init() {}
    public func read(_ register: GFXTIMRegister) -> UInt32 {
        switch register {
        case .cr: return gfxtim.cr.read().raw.storage
        case .cgcr: return gfxtim.cgcr.read().raw.storage
        case .tcr: return gfxtim.tcr.read().raw.storage
        case .tdr: return gfxtim.tdr.read().raw.storage
        case .evcr: return gfxtim.evcr.read().raw.storage
        case .evsr: return gfxtim.evsr.read().raw.storage
        case .wdgtcr: return gfxtim.wdgtcr.read().raw.storage
        case .isr: return gfxtim.isr.read().raw.storage
        case .icr: return gfxtim.icr.read().raw.storage
        case .ier: return gfxtim.ier.read().raw.storage
        case .tsr: return gfxtim.tsr.read().raw.storage
        case .lccrr: return gfxtim.lccrr.read().raw.storage
        case .fccrr: return gfxtim.fccrr.read().raw.storage
        case .atr: return gfxtim.atr.read().raw.storage
        case .afcr: return gfxtim.afcr.read().raw.storage
        case .alcr: return gfxtim.alcr.read().raw.storage
        case .afcc1r: return gfxtim.afcc1r.read().raw.storage
        case .alcc1r: return gfxtim.alcc1r.read().raw.storage
        case .alcc2r: return gfxtim.alcc2r.read().raw.storage
        case .rfc1r: return gfxtim.rfc1r.read().raw.storage
        case .rfc1rr: return gfxtim.rfc1rr.read().raw.storage
        case .rfc2r: return gfxtim.rfc2r.read().raw.storage
        case .rfc2rr: return gfxtim.rfc2rr.read().raw.storage
        case .wdgcr: return gfxtim.wdgcr.read().raw.storage
        case .wdgrr: return gfxtim.wdgrr.read().raw.storage
        case .wdgpar: return gfxtim.wdgpar.read().raw.storage
        }
    }
    public func write(_ register: GFXTIMRegister, value: UInt32) {
        switch register {
        case .cr: gfxtim.cr.write { $0.raw.storage = value }
        case .cgcr: gfxtim.cgcr.write { $0.raw.storage = value }
        case .tcr: gfxtim.tcr.write { $0.raw.storage = value }
        case .tdr: gfxtim.tdr.write { $0.raw.storage = value }
        case .evcr: gfxtim.evcr.write { $0.raw.storage = value }
        case .evsr: gfxtim.evsr.write { $0.raw.storage = value }
        case .wdgtcr: gfxtim.wdgtcr.write { $0.raw.storage = value }
        case .icr: gfxtim.icr.write { $0.raw.storage = value }
        case .ier: gfxtim.ier.write { $0.raw.storage = value }
        case .lccrr: gfxtim.lccrr.write { $0.raw.storage = value }
        case .fccrr: gfxtim.fccrr.write { $0.raw.storage = value }
        case .afcr: gfxtim.afcr.write { $0.raw.storage = value }
        case .alcr: gfxtim.alcr.write { $0.raw.storage = value }
        case .afcc1r: gfxtim.afcc1r.write { $0.raw.storage = value }
        case .alcc1r: gfxtim.alcc1r.write { $0.raw.storage = value }
        case .alcc2r: gfxtim.alcc2r.write { $0.raw.storage = value }
        case .rfc1rr: gfxtim.rfc1rr.write { $0.raw.storage = value }
        case .rfc2rr: gfxtim.rfc2rr.write { $0.raw.storage = value }
        case .wdgrr: gfxtim.wdgrr.write { $0.raw.storage = value }
        case .wdgpar: gfxtim.wdgpar.write { $0.raw.storage = value }
        case .isr, .tsr, .atr, .rfc1r, .rfc2r, .wdgcr: preconditionFailure("GFXTIM status and counter registers are read-only")
        }
    }
    public func address(of register: GFXTIMRegister) -> UInt {
        switch register {
        case .cr: return gfxtim.cr.unsafeAddress
        case .cgcr: return gfxtim.cgcr.unsafeAddress
        case .tcr: return gfxtim.tcr.unsafeAddress
        case .tdr: return gfxtim.tdr.unsafeAddress
        case .evcr: return gfxtim.evcr.unsafeAddress
        case .evsr: return gfxtim.evsr.unsafeAddress
        case .wdgtcr: return gfxtim.wdgtcr.unsafeAddress
        case .isr: return gfxtim.isr.unsafeAddress
        case .icr: return gfxtim.icr.unsafeAddress
        case .ier: return gfxtim.ier.unsafeAddress
        case .tsr: return gfxtim.tsr.unsafeAddress
        case .lccrr: return gfxtim.lccrr.unsafeAddress
        case .fccrr: return gfxtim.fccrr.unsafeAddress
        case .atr: return gfxtim.atr.unsafeAddress
        case .afcr: return gfxtim.afcr.unsafeAddress
        case .alcr: return gfxtim.alcr.unsafeAddress
        case .afcc1r: return gfxtim.afcc1r.unsafeAddress
        case .alcc1r: return gfxtim.alcc1r.unsafeAddress
        case .alcc2r: return gfxtim.alcc2r.unsafeAddress
        case .rfc1r: return gfxtim.rfc1r.unsafeAddress
        case .rfc1rr: return gfxtim.rfc1rr.unsafeAddress
        case .rfc2r: return gfxtim.rfc2r.unsafeAddress
        case .rfc2rr: return gfxtim.rfc2rr.unsafeAddress
        case .wdgcr: return gfxtim.wdgcr.unsafeAddress
        case .wdgrr: return gfxtim.wdgrr.unsafeAddress
        case .wdgpar: return gfxtim.wdgpar.unsafeAddress
        }
    }
}
public extension STM32H7RSHAL.GFXTIM where Registers == STM32GFXTIMRegisters {
    init(handle: Handle, callbacks: Callbacks, defaults: GFXTIMCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.init(registers: STM32GFXTIMRegisters(), handle: handle, callbacks: callbacks,
                  defaults: defaults, useRegisteredCallbacks: useRegisteredCallbacks)
    }
}
