import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32RNGRegisters: RNGRegisterIO {
    public init() {}

    public func read(_ register: RNGRegister) -> UInt32 {
        switch register {
        case .cr: return rng.cr.read().raw.storage
        case .sr: return rng.sr.read().raw.storage
        case .dr: return rng.dr.read().raw.storage
        case .htcr: return rng.htcr.read().raw.storage
        }
    }

    public func write(_ register: RNGRegister, value: UInt32) {
        switch register {
        case .cr: rng.cr.write { $0.raw.storage = value }
        case .sr: rng.sr.write { $0.raw.storage = value }
        case .htcr: rng.htcr.write { $0.raw.storage = value }
        case .dr: preconditionFailure("RNG data register is read-only")
        }
    }
}

public extension STM32H7RSHAL.RNG where Registers == STM32RNGRegisters {
    init(state: State) {
        self.init(registers: STM32RNGRegisters(), state: state)
    }
}
