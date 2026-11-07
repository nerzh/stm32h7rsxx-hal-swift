import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32DMA2DRegisters: DMA2DRegisterIO {
    public init() {}
    public func isClockEnabled() -> Bool { rcc.ahb5enr.read().raw.storage & 2 != 0 }
    public func read(_ register: DMA2DRegister) -> UInt32 {
        switch register {
        case .cr: return dma2d.cr.read().raw.storage
        case .isr: return dma2d.isr.read().raw.storage
        case .ifcr: return dma2d.ifcr.read().raw.storage
        case .fgmar: return dma2d.fgmar.read().raw.storage
        case .fgor: return dma2d.fgor.read().raw.storage
        case .bgmar: return dma2d.bgmar.read().raw.storage
        case .bgor: return dma2d.bgor.read().raw.storage
        case .fgpfccr: return dma2d.fgpfccr.read().raw.storage
        case .fgcolr: return dma2d.fgcolr.read().raw.storage
        case .bgpfccr: return dma2d.bgpfccr.read().raw.storage
        case .bgcolr: return dma2d.bgcolr.read().raw.storage
        case .fgcmar: return dma2d.fgcmar.read().raw.storage
        case .bgcmar: return dma2d.bgcmar.read().raw.storage
        case .opfccr: return dma2d.opfccr.read().raw.storage
        case .ocolr: return dma2d.ocolr_argb8888.read().raw.storage
        case .omar: return dma2d.omar.read().raw.storage
        case .oor: return dma2d.oor.read().raw.storage
        case .nlr: return dma2d.nlr.read().raw.storage
        case .lwr: return dma2d.lwr.read().raw.storage
        case .amtcr: return dma2d.amtcr.read().raw.storage
        }
    }
    public func write(_ register: DMA2DRegister, value: UInt32) {
        switch register {
        case .cr: dma2d.cr.write { $0.raw.storage = value }
        case .isr: preconditionFailure("DMA2D ISR is read-only")
        case .ifcr: dma2d.ifcr.write { $0.raw.storage = value }
        case .fgmar: dma2d.fgmar.write { $0.raw.storage = value }
        case .fgor: dma2d.fgor.write { $0.raw.storage = value }
        case .bgmar: dma2d.bgmar.write { $0.raw.storage = value }
        case .bgor: dma2d.bgor.write { $0.raw.storage = value }
        case .fgpfccr: dma2d.fgpfccr.write { $0.raw.storage = value }
        case .fgcolr: dma2d.fgcolr.write { $0.raw.storage = value }
        case .bgpfccr: dma2d.bgpfccr.write { $0.raw.storage = value }
        case .bgcolr: dma2d.bgcolr.write { $0.raw.storage = value }
        case .fgcmar: dma2d.fgcmar.write { $0.raw.storage = value }
        case .bgcmar: dma2d.bgcmar.write { $0.raw.storage = value }
        case .opfccr: dma2d.opfccr.write { $0.raw.storage = value }
        case .ocolr: dma2d.ocolr_argb8888.write { $0.raw.storage = value }
        case .omar: dma2d.omar.write { $0.raw.storage = value }
        case .oor: dma2d.oor.write { $0.raw.storage = value }
        case .nlr: dma2d.nlr.write { $0.raw.storage = value }
        case .lwr: dma2d.lwr.write { $0.raw.storage = value }
        case .amtcr: dma2d.amtcr.write { $0.raw.storage = value }
        }
    }
    public func address(of register: DMA2DRegister) -> UInt {
        switch register {
        case .cr: return dma2d.cr.unsafeAddress
        case .isr: return dma2d.isr.unsafeAddress
        case .ifcr: return dma2d.ifcr.unsafeAddress
        case .fgmar: return dma2d.fgmar.unsafeAddress
        case .fgor: return dma2d.fgor.unsafeAddress
        case .bgmar: return dma2d.bgmar.unsafeAddress
        case .bgor: return dma2d.bgor.unsafeAddress
        case .fgpfccr: return dma2d.fgpfccr.unsafeAddress
        case .fgcolr: return dma2d.fgcolr.unsafeAddress
        case .bgpfccr: return dma2d.bgpfccr.unsafeAddress
        case .bgcolr: return dma2d.bgcolr.unsafeAddress
        case .fgcmar: return dma2d.fgcmar.unsafeAddress
        case .bgcmar: return dma2d.bgcmar.unsafeAddress
        case .opfccr: return dma2d.opfccr.unsafeAddress
        case .ocolr: return dma2d.ocolr_argb8888.unsafeAddress
        case .omar: return dma2d.omar.unsafeAddress
        case .oor: return dma2d.oor.unsafeAddress
        case .nlr: return dma2d.nlr.unsafeAddress
        case .lwr: return dma2d.lwr.unsafeAddress
        case .amtcr: return dma2d.amtcr.unsafeAddress
        }
    }
}
public extension STM32H7RSHAL.DMA2D where Registers == STM32DMA2DRegisters {
    init(handle: Handle, callbacks: Callbacks, defaults: DMA2DCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.init(registers: STM32DMA2DRegisters(), handle: handle, callbacks: callbacks,
                  defaults: defaults, useRegisteredCallbacks: useRegisteredCallbacks)
    }
}
