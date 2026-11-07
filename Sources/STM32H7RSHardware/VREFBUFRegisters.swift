import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32VREFBUFRegisters: VREFBUFRegisterIO {
    public init() {}
    public func read(_ register: VREFBUFRegister) -> UInt32 {
        switch register {
        case .csr: return vrefbuf.csr.read().raw.storage
        case .ccr: return vrefbuf.ccr.read().raw.storage
        }
    }
    public func write(_ register: VREFBUFRegister, value: UInt32) {
        switch register {
        case .csr: vrefbuf.csr.write { $0.raw.storage = value }
        case .ccr: vrefbuf.ccr.write { $0.raw.storage = value }
        }
    }
    func address(of register: VREFBUFRegister) -> UInt {
        switch register {
        case .csr: return vrefbuf.csr.unsafeAddress
        case .ccr: return vrefbuf.ccr.unsafeAddress
        }
    }
}

public extension STM32H7RSHAL.VREFBUF where IO == STM32VREFBUFRegisters {
    init() { self.init(registers: STM32VREFBUFRegisters()) }
}
