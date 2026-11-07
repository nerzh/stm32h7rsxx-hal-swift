import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32HASHRegisters: HASHRegisterIO {
    public init() {}
    public func read(_ register: HASHRegister) -> UInt32 {
        switch register {
        case .cr: return hash.cr.read().raw.storage
        case .str: return hash.str.read().raw.storage
        case .imr: return hash.imr.read().raw.storage
        case .sr: return hash.sr.read().raw.storage
        case .hr(let index):
            precondition((0..<5).contains(index))
            return hash.hra[index].read().raw.storage
        case .csr(let index):
            precondition((0..<103).contains(index))
            return hash.csr[index].read().raw.storage
        case .digest(let index):
            precondition((0..<16).contains(index))
            return hash.hr[index].read().raw.storage
        case .din: preconditionFailure("HASH data input register is write-only")
        }
    }
    public func write(_ register: HASHRegister, value: UInt32) {
        switch register {
        case .cr: hash.cr.write { $0.raw.storage = value }
        case .din: hash.din.write { $0.raw.storage = value }
        case .str: hash.str.write { $0.raw.storage = value }
        case .imr: hash.imr.write { $0.raw.storage = value }
        case .sr: hash.sr.write { $0.raw.storage = value }
        case .csr(let index):
            precondition((0..<103).contains(index))
            hash.csr[index].write { $0.raw.storage = value }
        case .hr, .digest: preconditionFailure("HASH digest registers are read-only")
        }
    }
    public func address(of register: HASHRegister) -> UInt32 {
        switch register {
        case .cr: return UInt32(hash.cr.unsafeAddress)
        case .din: return UInt32(hash.din.unsafeAddress)
        case .str: return UInt32(hash.str.unsafeAddress)
        case .imr: return UInt32(hash.imr.unsafeAddress)
        case .sr: return UInt32(hash.sr.unsafeAddress)
        case .hr(let index):
            precondition((0..<5).contains(index))
            return UInt32(hash.hra[index].unsafeAddress)
        case .csr(let index):
            precondition((0..<103).contains(index))
            return UInt32(hash.csr[index].unsafeAddress)
        case .digest(let index):
            precondition((0..<16).contains(index))
            return UInt32(hash.hr[index].unsafeAddress)
        }
    }
}

public extension STM32H7RSHAL.HASH where Registers == STM32HASHRegisters, Memory == STM32HASHMemory {
    init(handle: Handle, callbacks: Callbacks, dma: DMAIO,
         defaults: HASHCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false,
         useSuspendResume: Bool = false) {
        self.init(registers: STM32HASHRegisters(), handle: handle, callbacks: callbacks, dma: dma,
                  memory: STM32HASHMemory(), defaults: defaults,
                  useRegisteredCallbacks: useRegisteredCallbacks, useSuspendResume: useSuspendResume)
    }
}
