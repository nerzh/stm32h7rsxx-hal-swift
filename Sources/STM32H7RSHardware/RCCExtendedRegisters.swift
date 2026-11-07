import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

extension STM32RCCRegisters: RCCExtendedRegisterIO {
    public mutating func read(_ register: RCCExtendedRegister) -> UInt32 {
        switch register {
        case .ccipr1: return rcc.ccipr1.read().raw.storage
        case .ccipr2: return rcc.ccipr2.read().raw.storage
        case .ccipr3: return rcc.ccipr3.read().raw.storage
        case .ccipr4: return rcc.ccipr4.read().raw.storage
        case .ckprotr: return rcc.ckprotr.read().raw.storage
        }
    }

    public mutating func write(_ register: RCCExtendedRegister, value: UInt32) {
        switch register {
        case .ccipr1: rcc.ccipr1.write { $0.raw.storage = value }
        case .ccipr2: rcc.ccipr2.write { $0.raw.storage = value }
        case .ccipr3: rcc.ccipr3.write { $0.raw.storage = value }
        case .ccipr4: rcc.ccipr4.write { $0.raw.storage = value }
        case .ckprotr: rcc.ckprotr.write { $0.raw.storage = value }
        }
    }

    public mutating func read(_ register: EXTIRegister) -> UInt32 {
        var registers = STM32EXTIRegisters()
        return registers.read(register)
    }

    public mutating func write(_ register: EXTIRegister, value: UInt32) {
        var registers = STM32EXTIRegisters()
        registers.write(register, value: value)
    }
}
