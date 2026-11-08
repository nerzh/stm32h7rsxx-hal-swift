import CCortexHALSupport
import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
typealias DeviceUSART = STM32H7R.USART1
typealias DeviceLPUART = STM32H7R.LPUART1
#else
import STM32H7S
typealias DeviceUSART = STM32H7S.USART1
typealias DeviceLPUART = STM32H7S.LPUART1
#endif

public struct STM32UARTRegisters: UARTRegisterIO {
    public let instance: UARTInstance
    public init(instance: UARTInstance) { self.instance = instance }

    // USART1/2/3 and UART4/5/7/8 share the CMSIS USART_TypeDef layout.
    // The raw storage accesses retain the C driver's full 32-bit bus accesses.
    var usart: DeviceUSART { .init(unsafeAddress: UInt(instance.rawValue)) }
    var lowPower: DeviceLPUART { .init(unsafeAddress: UInt(instance.rawValue)) }

    func address(of register: UARTRegister) -> UInt {
        if instance.isLowPower {
            switch register {
            case .cr1: return lowPower.cr1.unsafeAddress
            case .cr2: return lowPower.cr2.unsafeAddress
            case .cr3: return lowPower.cr3.unsafeAddress
            case .brr: return lowPower.brr.unsafeAddress
            case .rqr: return lowPower.rqr.unsafeAddress
            case .isr: return lowPower.isr.unsafeAddress
            case .icr: return lowPower.icr.unsafeAddress
            case .rdr: return lowPower.rdr.unsafeAddress
            case .tdr: return lowPower.tdr.unsafeAddress
            case .presc: return lowPower.presc.unsafeAddress
            case .gtpr, .rtor: preconditionFailure("LPUART has no GTPR or RTOR register")
            }
        }
        switch register {
        case .cr1: return usart.cr1.unsafeAddress
        case .cr2: return usart.cr2.unsafeAddress
        case .cr3: return usart.cr3.unsafeAddress
        case .brr: return usart.brr.unsafeAddress
        case .gtpr: return usart.gtpr.unsafeAddress
        case .rtor: return usart.rtor.unsafeAddress
        case .rqr: return usart.rqr.unsafeAddress
        case .isr: return usart.isr.unsafeAddress
        case .icr: return usart.icr.unsafeAddress
        case .rdr: return usart.rdr.unsafeAddress
        case .tdr: return usart.tdr.unsafeAddress
        case .presc: return usart.presc.unsafeAddress
        }
    }

    public func read(_ register: UARTRegister) -> UInt32 {
        if instance.isLowPower {
            switch register {
            case .cr1: return lowPower.cr1.read().raw.storage
            case .cr2: return lowPower.cr2.read().raw.storage
            case .cr3: return lowPower.cr3.read().raw.storage
            case .brr: return lowPower.brr.read().raw.storage
            case .rqr: return lowPower.rqr.read().raw.storage
            case .isr: return lowPower.isr.read().raw.storage
            case .rdr: return lowPower.rdr.read().raw.storage
            case .tdr: return lowPower.tdr.read().raw.storage
            case .presc: return lowPower.presc.read().raw.storage
            case .gtpr, .rtor: preconditionFailure("LPUART has no GTPR or RTOR register")
            case .icr: preconditionFailure("UART interrupt-clear register is write-only")
            }
        }
        switch register {
        case .cr1: return usart.cr1.read().raw.storage
        case .cr2: return usart.cr2.read().raw.storage
        case .cr3: return usart.cr3.read().raw.storage
        case .brr: return usart.brr.read().raw.storage
        case .gtpr: return usart.gtpr.read().raw.storage
        case .rtor: return usart.rtor.read().raw.storage
        case .rqr: return usart.rqr.read().raw.storage
        case .isr: return usart.isr.read().raw.storage
        case .rdr: return usart.rdr.read().raw.storage
        case .tdr: return usart.tdr.read().raw.storage
        case .presc: return usart.presc.read().raw.storage
        case .icr:
            // SMARTCARD's C macros read ICR before modifying it, although the SVD
            // marks it write-only. Preserve the original volatile bus access.
            return VolatileMappedRegister<UInt32>(unsafeBitPattern: usart.icr.unsafeAddress).load()
        }
    }

    public func write(_ register: UARTRegister, value: UInt32) {
        if instance.isLowPower {
            switch register {
            case .cr1: lowPower.cr1.write { $0.raw.storage = value }
            case .cr2: lowPower.cr2.write { $0.raw.storage = value }
            case .cr3: lowPower.cr3.write { $0.raw.storage = value }
            case .brr: lowPower.brr.write { $0.raw.storage = value }
            case .rqr: lowPower.rqr.write { $0.raw.storage = value }
            case .icr: lowPower.icr.write { $0.raw.storage = value }
            case .tdr: lowPower.tdr.write { $0.raw.storage = value }
            case .presc: lowPower.presc.write { $0.raw.storage = value }
            case .gtpr, .rtor: preconditionFailure("LPUART has no GTPR or RTOR register")
            case .isr, .rdr: preconditionFailure("UART status and receive data are read-only")
            }
            return
        }
        switch register {
        case .cr1: usart.cr1.write { $0.raw.storage = value }
        case .cr2: usart.cr2.write { $0.raw.storage = value }
        case .cr3: usart.cr3.write { $0.raw.storage = value }
        case .brr: usart.brr.write { $0.raw.storage = value }
        case .gtpr: usart.gtpr.write { $0.raw.storage = value }
        case .rtor: usart.rtor.write { $0.raw.storage = value }
        case .rqr: usart.rqr.write { $0.raw.storage = value }
        case .icr: usart.icr.write { $0.raw.storage = value }
        case .tdr: usart.tdr.write { $0.raw.storage = value }
        case .presc: usart.presc.write { $0.raw.storage = value }
        case .isr, .rdr: preconditionFailure("UART status and receive data are read-only")
        }
    }

    public func atomicModify(_ register: UARTRegister, clear: UInt32, set: UInt32) {
        precondition(register == .cr1 || register == .cr2 || register == .cr3)
        hal_cortex_atomic_modify32(UnsafeMutablePointer<UInt32>(bitPattern: address(of: register))!, clear, set)
    }
}
