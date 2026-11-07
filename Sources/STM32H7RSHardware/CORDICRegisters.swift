import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32CORDICRegisters: CORDICRegisterIO {
    public init() {}

    public func read(_ register: CORDICRegister) -> UInt32 {
        switch register {
        case .csr: return cordic.csr.read().raw.storage
        case .rdata: return cordic.rdata.read().raw.storage
        case .wdata: preconditionFailure("CORDIC argument register is write-only")
        }
    }
    public func write(_ register: CORDICRegister, value: UInt32) {
        switch register {
        case .csr: cordic.csr.write { $0.raw.storage = value }
        case .wdata: cordic.wdata.write { $0.raw.storage = value }
        case .rdata: preconditionFailure("CORDIC result register is read-only")
        }
    }
    public func address(of register: CORDICRegister) -> UInt32 {
        switch register {
        case .csr: return UInt32(cordic.csr.unsafeAddress)
        case .wdata: return UInt32(cordic.wdata.unsafeAddress)
        case .rdata: return UInt32(cordic.rdata.unsafeAddress)
        }
    }
}

public extension STM32H7RSHAL.CORDIC where Registers == STM32CORDICRegisters {
    init(handle: Handle, callbacks: Callbacks, dma: DMAIO,
         defaults: CORDICCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.init(registers: STM32CORDICRegisters(), handle: handle, callbacks: callbacks,
                  dma: dma, defaults: defaults, useRegisteredCallbacks: useRegisteredCallbacks)
    }
}
