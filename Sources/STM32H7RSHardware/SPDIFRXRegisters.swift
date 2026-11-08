import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32SPDIFRXRegisters: SPDIFRXRegisterIO {
    public init() {}
    public func read(_ register: SPDIFRXRegister) -> UInt32 {
        switch register {
        case .cr: return spdifrx.cr.read().raw.storage
        case .imr: return spdifrx.imr.read().raw.storage
        case .sr: return spdifrx.sr.read().raw.storage
        case .ifcr: preconditionFailure("SPDIFRX IFCR is write-only")
        // All SVD format views share +0x10; read the whole word without field conversion.
        case .dr: return spdifrx.fmt0_dr.read().raw.storage
        case .csr: return spdifrx.csr.read().raw.storage
        case .dir: return spdifrx.dir.read().raw.storage
        }
    }
    public func write(_ register: SPDIFRXRegister, value: UInt32) {
        switch register {
        case .cr: spdifrx.cr.write { $0.raw.storage = value }
        case .imr: spdifrx.imr.write { $0.raw.storage = value }
        case .sr: preconditionFailure("SPDIFRX register is read-only")
        case .ifcr: spdifrx.ifcr.write { $0.raw.storage = value }
        case .dr: preconditionFailure("SPDIFRX register is read-only")
        case .csr: preconditionFailure("SPDIFRX register is read-only")
        case .dir: preconditionFailure("SPDIFRX register is read-only")
        }
    }
    public func dataAddress(_ stream: SPDIFRXStream) -> UInt32 { UInt32(stream == .data ? spdifrx.fmt0_dr.unsafeAddress : spdifrx.csr.unsafeAddress) }
    func address(of register: SPDIFRXRegister) -> UInt {
        switch register {
        case .cr: return spdifrx.cr.unsafeAddress
        case .imr: return spdifrx.imr.unsafeAddress
        case .sr: return spdifrx.sr.unsafeAddress
        case .ifcr: return spdifrx.ifcr.unsafeAddress
        case .dr: return spdifrx.fmt0_dr.unsafeAddress
        case .csr: return spdifrx.csr.unsafeAddress
        case .dir: return spdifrx.dir.unsafeAddress
        }
    }
}
