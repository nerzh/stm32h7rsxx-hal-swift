import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32ADCRegisters: ADCRegisterIO {
    private let readCoreClock: @convention(c) () -> UInt32
    public init(systemCoreClock: @escaping @convention(c) () -> UInt32) { readCoreClock = systemCoreClock }
    public func systemCoreClock() -> UInt32 { readCoreClock() }
    private func block(_ instance: ADCInstance) -> ADC1 { instance == .adc1 ? adc1 : adc2 }
    // The pinned SVD repeats +0x300 in both the common base and its register offsets.
    // Rebase the generated block so CCR resolves to CMSIS ADC12_COMMON_BASE +0x08.
    private var common: ADC12_common { ADC12_common(unsafeAddress: adc12_common.unsafeAddress - 0x300) }
    public func read(_ register: ADCRegister, instance: ADCInstance) -> UInt32 {
        let adc = block(instance)
        switch register {
        case .isr: return adc.isr.read().raw.storage
        case .ier: return adc.ier.read().raw.storage
        case .cr: return adc.cr.read().raw.storage
        case .cfgr: return adc.cfgr.read().raw.storage
        case .cfgr2: return adc.cfgr2.read().raw.storage
        case .smpr1: return adc.smpr1.read().raw.storage
        case .smpr2: return adc.smpr2.read().raw.storage
        case .tr1: return adc.tr1.read().raw.storage
        case .tr2: return adc.tr2.read().raw.storage
        case .tr3: return adc.tr3.read().raw.storage
        case .sqr1: return adc.sqr1.read().raw.storage
        case .sqr2: return adc.sqr2.read().raw.storage
        case .sqr3: return adc.sqr3.read().raw.storage
        case .sqr4: return adc.sqr4.read().raw.storage
        case .dr: return adc.dr.read().raw.storage
        case .jsqr: return adc.jsqr.read().raw.storage
        case .ofr1: return adc.ofr1.read().raw.storage
        case .ofr2: return adc.ofr2.read().raw.storage
        case .ofr3: return adc.ofr3.read().raw.storage
        case .ofr4: return adc.ofr4.read().raw.storage
        case .jdr1: return adc.jdr1.read().raw.storage
        case .jdr2: return adc.jdr2.read().raw.storage
        case .jdr3: return adc.jdr3.read().raw.storage
        case .jdr4: return adc.jdr4.read().raw.storage
        case .awd2cr: return adc.awd2cr.read().raw.storage
        case .awd3cr: return adc.awd3cr.read().raw.storage
        case .difsel: return adc.difsel.read().raw.storage
        case .calfact: return adc.calfact.read().raw.storage
        case .or: return adc.or.read().raw.storage
        }
    }
    public func write(_ register: ADCRegister, instance: ADCInstance, value: UInt32) {
        let adc = block(instance)
        switch register {
        case .isr: adc.isr.write { $0.raw.storage = value }
        case .ier: adc.ier.write { $0.raw.storage = value }
        case .cr: adc.cr.write { $0.raw.storage = value }
        case .cfgr: adc.cfgr.write { $0.raw.storage = value }
        case .cfgr2: adc.cfgr2.write { $0.raw.storage = value }
        case .smpr1: adc.smpr1.write { $0.raw.storage = value }
        case .smpr2: adc.smpr2.write { $0.raw.storage = value }
        case .tr1: adc.tr1.write { $0.raw.storage = value }
        case .tr2: adc.tr2.write { $0.raw.storage = value }
        case .tr3: adc.tr3.write { $0.raw.storage = value }
        case .sqr1: adc.sqr1.write { $0.raw.storage = value }
        case .sqr2: adc.sqr2.write { $0.raw.storage = value }
        case .sqr3: adc.sqr3.write { $0.raw.storage = value }
        case .sqr4: adc.sqr4.write { $0.raw.storage = value }
        case .dr: preconditionFailure("ADC data register is read-only")
        case .jsqr: adc.jsqr.write { $0.raw.storage = value }
        case .ofr1: adc.ofr1.write { $0.raw.storage = value }
        case .ofr2: adc.ofr2.write { $0.raw.storage = value }
        case .ofr3: adc.ofr3.write { $0.raw.storage = value }
        case .ofr4: adc.ofr4.write { $0.raw.storage = value }
        case .jdr1: preconditionFailure("ADC data register is read-only")
        case .jdr2: preconditionFailure("ADC data register is read-only")
        case .jdr3: preconditionFailure("ADC data register is read-only")
        case .jdr4: preconditionFailure("ADC data register is read-only")
        case .awd2cr: adc.awd2cr.write { $0.raw.storage = value }
        case .awd3cr: adc.awd3cr.write { $0.raw.storage = value }
        case .difsel: adc.difsel.write { $0.raw.storage = value }
        case .calfact: adc.calfact.write { $0.raw.storage = value }
        case .or: adc.or.write { $0.raw.storage = value }
        }
    }
    public func readCommon(_ register: ADCCommonRegister) -> UInt32 {
        switch register {
        case .csr: return common.csr.read().raw.storage
        case .ccr: return common.ccr.read().raw.storage
        case .cdr: return common.cdr.read().raw.storage
        }
    }
    public func writeCommon(_ register: ADCCommonRegister, value: UInt32) {
        switch register {
        case .ccr: common.ccr.write { $0.raw.storage = value }
        case .csr, .cdr: preconditionFailure("ADC common data/status register is read-only")
        }
    }
    public func dataAddress(instance: ADCInstance) -> UInt32 { UInt32(block(instance).dr.unsafeAddress) }
    public func commonDataAddress() -> UInt32 { UInt32(common.cdr.unsafeAddress) }
    public func stabilizationDelay(iterations: UInt32) {
        var count: UInt32 = iterations
        withUnsafeMutablePointer(to: &count) { pointer in
            let counter = VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(bitPattern: pointer))
            while counter.load() != 0 { counter.store(counter.load() &- 1) }
        }
    }
    func address(of register: ADCRegister, instance: ADCInstance) -> UInt {
        let adc = block(instance)
        switch register {
        case .isr: return adc.isr.unsafeAddress
        case .ier: return adc.ier.unsafeAddress
        case .cr: return adc.cr.unsafeAddress
        case .cfgr: return adc.cfgr.unsafeAddress
        case .cfgr2: return adc.cfgr2.unsafeAddress
        case .smpr1: return adc.smpr1.unsafeAddress
        case .smpr2: return adc.smpr2.unsafeAddress
        case .tr1: return adc.tr1.unsafeAddress
        case .tr2: return adc.tr2.unsafeAddress
        case .tr3: return adc.tr3.unsafeAddress
        case .sqr1: return adc.sqr1.unsafeAddress
        case .sqr2: return adc.sqr2.unsafeAddress
        case .sqr3: return adc.sqr3.unsafeAddress
        case .sqr4: return adc.sqr4.unsafeAddress
        case .dr: return adc.dr.unsafeAddress
        case .jsqr: return adc.jsqr.unsafeAddress
        case .ofr1: return adc.ofr1.unsafeAddress
        case .ofr2: return adc.ofr2.unsafeAddress
        case .ofr3: return adc.ofr3.unsafeAddress
        case .ofr4: return adc.ofr4.unsafeAddress
        case .jdr1: return adc.jdr1.unsafeAddress
        case .jdr2: return adc.jdr2.unsafeAddress
        case .jdr3: return adc.jdr3.unsafeAddress
        case .jdr4: return adc.jdr4.unsafeAddress
        case .awd2cr: return adc.awd2cr.unsafeAddress
        case .awd3cr: return adc.awd3cr.unsafeAddress
        case .difsel: return adc.difsel.unsafeAddress
        case .calfact: return adc.calfact.unsafeAddress
        case .or: return adc.or.unsafeAddress
        }
    }
    func commonAddress(of register: ADCCommonRegister) -> UInt {
        switch register {
        case .csr: return common.csr.unsafeAddress
        case .ccr: return common.ccr.unsafeAddress
        case .cdr: return common.cdr.unsafeAddress
        }
    }
}
