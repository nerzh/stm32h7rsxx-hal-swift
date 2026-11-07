import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32FMCBankMappingRegisters: FMCBankMappingRegisterIO {
    public init() {}
    public func read(_ register: FMCBankMappingRegister) -> UInt32 {
        switch register {
        case .bcr1: return fmc.bcr1.read().raw.storage
        }
    }
    public func write(_ register: FMCBankMappingRegister, value: UInt32) {
        switch register {
        case .bcr1: fmc.bcr1.write { $0.raw.storage = value }
        }
    }
    func address(of register: FMCBankMappingRegister) -> UInt {
        switch register {
        case .bcr1: return fmc.bcr1.unsafeAddress
        }
    }
}

public extension FMCBankMapping where IO == STM32FMCBankMappingRegisters {
    init() { self.init(registers: STM32FMCBankMappingRegisters()) }
}
