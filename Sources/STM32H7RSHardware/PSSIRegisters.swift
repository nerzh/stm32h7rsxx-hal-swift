import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32PSSIRegisters: PSSIRegisterIO {
    public init() {}
    public func read(_ register: PSSIRegister) -> UInt32 {
        switch register {
        case .cr: return pssi.cr.read().raw.storage
        case .sr: return pssi.sr.read().raw.storage
        case .ris: return pssi.ris.read().raw.storage
        case .ier: return pssi.ier.read().raw.storage
        case .mis: return pssi.mis.read().raw.storage
        case .icr: preconditionFailure("PSSI ICR is write-only")
        case .dr: return pssi.dr.read().raw.storage
        }
    }
    public func write(_ register: PSSIRegister, value: UInt32) {
        switch register {
        case .cr: pssi.cr.write { $0.raw.storage = value }
        case .sr: preconditionFailure("PSSI register is read-only")
        case .ris: preconditionFailure("PSSI register is read-only")
        case .ier: pssi.ier.write { $0.raw.storage = value }
        case .mis: preconditionFailure("PSSI register is read-only")
        case .icr: pssi.icr.write { $0.raw.storage = value }
        case .dr: pssi.dr.write { $0.raw.storage = value }
        }
    }
    public func dataAddress() -> UInt32 { UInt32(pssi.dr.unsafeAddress) }
    public func readData8() -> UInt8 { VolatileMappedRegister<UInt8>(unsafeBitPattern: pssi.dr.unsafeAddress).load() }
    public func readData16() -> UInt16 { VolatileMappedRegister<UInt16>(unsafeBitPattern: pssi.dr.unsafeAddress).load() }
    public func writeData8(_ value: UInt8) { VolatileMappedRegister<UInt8>(unsafeBitPattern: pssi.dr.unsafeAddress).store(value) }
    public func writeData16(_ value: UInt16) { VolatileMappedRegister<UInt16>(unsafeBitPattern: pssi.dr.unsafeAddress).store(value) }
    func address(of register: PSSIRegister) -> UInt {
        switch register {
        case .cr: return pssi.cr.unsafeAddress
        case .sr: return pssi.sr.unsafeAddress
        case .ris: return pssi.ris.unsafeAddress
        case .ier: return pssi.ier.unsafeAddress
        case .mis: return pssi.mis.unsafeAddress
        case .icr: return pssi.icr.unsafeAddress
        case .dr: return pssi.dr.unsafeAddress
        }
    }
}
