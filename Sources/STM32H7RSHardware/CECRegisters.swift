import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32CECRegisters: CECRegisterIO {
    public init() {}
    public func read(_ register: CECRegister) -> UInt32 {
        switch register {
        case .cr: return cec.cr.read().raw.storage
        case .cfgr: return cec.cfgr.read().raw.storage
        case .txdr: preconditionFailure("CEC TXDR is write-only")
        case .rxdr: return cec.rxdr.read().raw.storage
        case .isr: return cec.isr.read().raw.storage
        case .ier: return cec.ier.read().raw.storage
        }
    }
    public func write(_ register: CECRegister, value: UInt32) {
        switch register {
        case .cr: cec.cr.write { $0.raw.storage = value }
        case .cfgr: cec.cfgr.write { $0.raw.storage = value }
        case .txdr: cec.txdr.write { $0.raw.storage = value }
        case .rxdr: preconditionFailure("CEC RXDR is read-only")
        case .isr: cec.isr.write { $0.raw.storage = value }
        case .ier: cec.ier.write { $0.raw.storage = value }
        }
    }
    func address(of register: CECRegister) -> UInt {
        switch register {
        case .cr: return cec.cr.unsafeAddress
        case .cfgr: return cec.cfgr.unsafeAddress
        case .txdr: return cec.txdr.unsafeAddress
        case .rxdr: return cec.rxdr.unsafeAddress
        case .isr: return cec.isr.unsafeAddress
        case .ier: return cec.ier.unsafeAddress
        }
    }
}
