import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// Available on STM32H7R7/S7 only; family SVD definitions also exist for R3/S3.
public struct STM32LTDCRegisters: LTDCRegisterIO {
    public init() {}
    public func read(_ register: LTDCRegister) -> UInt32 {
        switch register {
        case .sscr: return ltdc.sscr.read().raw.storage
        case .bpcr: return ltdc.bpcr.read().raw.storage
        case .awcr: return ltdc.awcr.read().raw.storage
        case .twcr: return ltdc.twcr.read().raw.storage
        case .gcr: return ltdc.gcr.read().raw.storage
        case .srcr: return ltdc.srcr.read().raw.storage
        case .bccr: return ltdc.bccr.read().raw.storage
        case .ier: return ltdc.ier.read().raw.storage
        case .isr: return ltdc.isr.read().raw.storage
        case .icr: return ltdc.icr.read().raw.storage
        case .lipcr: return ltdc.lipcr.read().raw.storage
        case .cpsr: return ltdc.cpsr.read().raw.storage
        case .cdsr: return ltdc.cdsr.read().raw.storage
        }
    }
    public func write(_ register: LTDCRegister, value: UInt32) {
        switch register {
        case .sscr: ltdc.sscr.write { $0.raw.storage = value }
        case .bpcr: ltdc.bpcr.write { $0.raw.storage = value }
        case .awcr: ltdc.awcr.write { $0.raw.storage = value }
        case .twcr: ltdc.twcr.write { $0.raw.storage = value }
        case .gcr: ltdc.gcr.write { $0.raw.storage = value }
        case .srcr: ltdc.srcr.write { $0.raw.storage = value }
        case .bccr: ltdc.bccr.write { $0.raw.storage = value }
        case .ier: ltdc.ier.write { $0.raw.storage = value }
        case .isr: preconditionFailure("LTDC ISR is read-only")
        case .icr: ltdc.icr.write { $0.raw.storage = value }
        case .lipcr: ltdc.lipcr.write { $0.raw.storage = value }
        case .cpsr: preconditionFailure("LTDC CPSR is read-only")
        case .cdsr: preconditionFailure("LTDC CDSR is read-only")
        }
    }
    func address(of register: LTDCRegister) -> UInt {
        switch register {
        case .sscr: return ltdc.sscr.unsafeAddress
        case .bpcr: return ltdc.bpcr.unsafeAddress
        case .awcr: return ltdc.awcr.unsafeAddress
        case .twcr: return ltdc.twcr.unsafeAddress
        case .gcr: return ltdc.gcr.unsafeAddress
        case .srcr: return ltdc.srcr.unsafeAddress
        case .bccr: return ltdc.bccr.unsafeAddress
        case .ier: return ltdc.ier.unsafeAddress
        case .isr: return ltdc.isr.unsafeAddress
        case .icr: return ltdc.icr.unsafeAddress
        case .lipcr: return ltdc.lipcr.unsafeAddress
        case .cpsr: return ltdc.cpsr.unsafeAddress
        case .cdsr: return ltdc.cdsr.unsafeAddress
        }
    }
    public func read(_ register: LTDCLayerRegister, layer: UInt32) -> UInt32 {
        precondition(layer < 2)
        switch register {
        case .cr: return ltdc.layer[Int(layer)].cr.read().raw.storage
        case .whpcr: return ltdc.layer[Int(layer)].whpcr.read().raw.storage
        case .wvpcr: return ltdc.layer[Int(layer)].wvpcr.read().raw.storage
        case .ckcr: return ltdc.layer[Int(layer)].ckcr.read().raw.storage
        case .pfcr: return ltdc.layer[Int(layer)].pfcr.read().raw.storage
        case .cacr: return ltdc.layer[Int(layer)].cacr.read().raw.storage
        case .dccr: return ltdc.layer[Int(layer)].dccr.read().raw.storage
        case .bfcr: return ltdc.layer[Int(layer)].bfcr.read().raw.storage
        case .cfbar: return ltdc.layer[Int(layer)].cfbar.read().raw.storage
        case .cfblr: return ltdc.layer[Int(layer)].cfblr.read().raw.storage
        case .cfblnr: return ltdc.layer[Int(layer)].cfblnr.read().raw.storage
        case .clutwr: return ltdc.layer[Int(layer)].clutwr.read().raw.storage
        }
    }
    public func write(_ register: LTDCLayerRegister, layer: UInt32, value: UInt32) {
        precondition(layer < 2)
        switch register {
        case .cr: ltdc.layer[Int(layer)].cr.write { $0.raw.storage = value }
        case .whpcr: ltdc.layer[Int(layer)].whpcr.write { $0.raw.storage = value }
        case .wvpcr: ltdc.layer[Int(layer)].wvpcr.write { $0.raw.storage = value }
        case .ckcr: ltdc.layer[Int(layer)].ckcr.write { $0.raw.storage = value }
        case .pfcr: ltdc.layer[Int(layer)].pfcr.write { $0.raw.storage = value }
        case .cacr: ltdc.layer[Int(layer)].cacr.write { $0.raw.storage = value }
        case .dccr: ltdc.layer[Int(layer)].dccr.write { $0.raw.storage = value }
        case .bfcr: ltdc.layer[Int(layer)].bfcr.write { $0.raw.storage = value }
        case .cfbar: ltdc.layer[Int(layer)].cfbar.write { $0.raw.storage = value }
        case .cfblr: ltdc.layer[Int(layer)].cfblr.write { $0.raw.storage = value }
        case .cfblnr: ltdc.layer[Int(layer)].cfblnr.write { $0.raw.storage = value }
        case .clutwr: ltdc.layer[Int(layer)].clutwr.write { $0.raw.storage = value }
        }
    }
    func address(of register: LTDCLayerRegister, layer: UInt32) -> UInt {
        precondition(layer < 2)
        switch register {
        case .cr: return ltdc.layer[Int(layer)].cr.unsafeAddress
        case .whpcr: return ltdc.layer[Int(layer)].whpcr.unsafeAddress
        case .wvpcr: return ltdc.layer[Int(layer)].wvpcr.unsafeAddress
        case .ckcr: return ltdc.layer[Int(layer)].ckcr.unsafeAddress
        case .pfcr: return ltdc.layer[Int(layer)].pfcr.unsafeAddress
        case .cacr: return ltdc.layer[Int(layer)].cacr.unsafeAddress
        case .dccr: return ltdc.layer[Int(layer)].dccr.unsafeAddress
        case .bfcr: return ltdc.layer[Int(layer)].bfcr.unsafeAddress
        case .cfbar: return ltdc.layer[Int(layer)].cfbar.unsafeAddress
        case .cfblr: return ltdc.layer[Int(layer)].cfblr.unsafeAddress
        case .cfblnr: return ltdc.layer[Int(layer)].cfblnr.unsafeAddress
        case .clutwr: return ltdc.layer[Int(layer)].clutwr.unsafeAddress
        }
    }
}
