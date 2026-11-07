import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public enum STM32ICacheDevice: Sendable { case h7r7, h7s7 }

// Peripheral texture cache, present on H7R7/H7S7 only. The explicit device
// declares the actual chip; this adapter does not access the Cortex-M7 cache.
public struct STM32ICacheRegisters: ICacheRegisterIO {
    public let device: STM32ICacheDevice
    public init(device: STM32ICacheDevice) { self.device = device }

    public func read(_ register: ICacheRegister) -> UInt32 {
        switch register {
        case .cr: return icache.cr.read().raw.storage
        case .sr: return icache.sr.read().raw.storage
        case .ier: return icache.ier.read().raw.storage
        case .hmonr: return icache.hmonr.read().raw.storage
        case .mmonr: return icache.mmonr.read().raw.storage
        case .fcr: preconditionFailure("ICACHE flag-clear register is write-only")
        }
    }

    public func write(_ register: ICacheRegister, value: UInt32) {
        switch register {
        case .cr: icache.cr.write { $0.raw.storage = value }
        case .ier: icache.ier.write { $0.raw.storage = value }
        case .fcr: icache.fcr.write { $0.raw.storage = value }
        case .sr, .hmonr, .mmonr: preconditionFailure("ICACHE status and monitor registers are read-only")
        }
    }
}

public extension STM32H7RSHAL.ICache where Registers == STM32ICacheRegisters {
    init(device: STM32ICacheDevice) { self.init(registers: STM32ICacheRegisters(device: device)) }
}
