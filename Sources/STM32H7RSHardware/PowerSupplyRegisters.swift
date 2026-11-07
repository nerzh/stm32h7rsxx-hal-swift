import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32PowerSupplyRegisters: PowerSupplyRegisterIO {
    public init() {}

    public func read(_ register: PowerSupplyRegister) -> UInt32 {
        switch register {
        case .csr2: return pwr.csr2.read().raw.storage
        case .csr4: return pwr.csr4.read().raw.storage
        case .sr1: return pwr.sr1.read().raw.storage
        }
    }

    public func write(_ register: PowerSupplyRegister, value: UInt32) {
        switch register {
        case .csr2: pwr.csr2.write { $0.raw.storage = value }
        case .csr4: pwr.csr4.write { $0.raw.storage = value }
        case .sr1: preconditionFailure("PWR supply status is read-only")
        }
    }
}

public extension PowerSupply where IO == STM32PowerSupplyRegisters {
    init() {
        self.init(registers: STM32PowerSupplyRegisters())
    }
}
