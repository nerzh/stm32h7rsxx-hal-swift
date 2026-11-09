import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

extension STM32RCCRegisters: LLBusRegisterIO {
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        switch register {
        case .ahb1enr: return rcc.ahb1enr.read().raw.storage
        case .ahb1rstr: return rcc.ahb1rstr.read().raw.storage
        case .ahb1lpenr: return rcc.ahb1lpenr.read().raw.storage
        case .ahb2enr: return rcc.ahb2enr.read().raw.storage
        case .ahb2rstr: return rcc.ahb2rstr.read().raw.storage
        case .ahb2lpenr: return rcc.ahb2lpenr.read().raw.storage
        case .ahb3enr: return rcc.ahb3enr.read().raw.storage
        case .ahb3rstr: return rcc.ahb3rstr.read().raw.storage
        case .ahb3lpenr: return rcc.ahb3lpenr.read().raw.storage
        case .ahb4enr: return rcc.ahb4enr.read().raw.storage
        case .ahb4rstr: return rcc.ahb4rstr.read().raw.storage
        case .ahb4lpenr: return rcc.ahb4lpenr.read().raw.storage
        case .ahb5enr: return rcc.ahb5enr.read().raw.storage
        case .ahb5rstr: return rcc.ahb5rstr.read().raw.storage
        case .ahb5lpenr: return rcc.ahb5lpenr.read().raw.storage
        case .apb1enr1: return rcc.apb1enr1.read().raw.storage
        case .apb1rstr1: return rcc.apb1rstr1.read().raw.storage
        case .apb1lpenr1: return rcc.apb1lpenr1.read().raw.storage
        case .apb1enr2: return rcc.apb1enr2.read().raw.storage
        case .apb1rstr2: return rcc.apb1rstr2.read().raw.storage
        case .apb1lpenr2: return rcc.apb1lpenr2.read().raw.storage
        case .apb2enr: return rcc.apb2enr.read().raw.storage
        case .apb2rstr: return rcc.apb2rstr.read().raw.storage
        case .apb2lpenr: return rcc.apb2lpenr.read().raw.storage
        case .apb4enr: return rcc.apb4enr.read().raw.storage
        case .apb4rstr: return rcc.apb4rstr.read().raw.storage
        case .apb4lpenr: return rcc.apb4lpenr.read().raw.storage
        case .apb5enr: return rcc.apb5enr.read().raw.storage
        case .apb5rstr: return rcc.apb5rstr.read().raw.storage
        case .apb5lpenr: return rcc.apb5lpenr.read().raw.storage
        case .ckgdisr: return rcc.ckgdisr.read().raw.storage
        }
    }

    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        switch register {
        case .ahb1enr: rcc.ahb1enr.write { $0.raw.storage = value }
        case .ahb1rstr: rcc.ahb1rstr.write { $0.raw.storage = value }
        case .ahb1lpenr: rcc.ahb1lpenr.write { $0.raw.storage = value }
        case .ahb2enr: rcc.ahb2enr.write { $0.raw.storage = value }
        case .ahb2rstr: rcc.ahb2rstr.write { $0.raw.storage = value }
        case .ahb2lpenr: rcc.ahb2lpenr.write { $0.raw.storage = value }
        case .ahb3enr: rcc.ahb3enr.write { $0.raw.storage = value }
        case .ahb3rstr: rcc.ahb3rstr.write { $0.raw.storage = value }
        case .ahb3lpenr: rcc.ahb3lpenr.write { $0.raw.storage = value }
        case .ahb4enr: rcc.ahb4enr.write { $0.raw.storage = value }
        case .ahb4rstr: rcc.ahb4rstr.write { $0.raw.storage = value }
        case .ahb4lpenr: rcc.ahb4lpenr.write { $0.raw.storage = value }
        case .ahb5enr: rcc.ahb5enr.write { $0.raw.storage = value }
        case .ahb5rstr: rcc.ahb5rstr.write { $0.raw.storage = value }
        case .ahb5lpenr: rcc.ahb5lpenr.write { $0.raw.storage = value }
        case .apb1enr1: rcc.apb1enr1.write { $0.raw.storage = value }
        case .apb1rstr1: rcc.apb1rstr1.write { $0.raw.storage = value }
        case .apb1lpenr1: rcc.apb1lpenr1.write { $0.raw.storage = value }
        case .apb1enr2: rcc.apb1enr2.write { $0.raw.storage = value }
        case .apb1rstr2: rcc.apb1rstr2.write { $0.raw.storage = value }
        case .apb1lpenr2: rcc.apb1lpenr2.write { $0.raw.storage = value }
        case .apb2enr: rcc.apb2enr.write { $0.raw.storage = value }
        case .apb2rstr: rcc.apb2rstr.write { $0.raw.storage = value }
        case .apb2lpenr: rcc.apb2lpenr.write { $0.raw.storage = value }
        case .apb4enr: rcc.apb4enr.write { $0.raw.storage = value }
        case .apb4rstr: rcc.apb4rstr.write { $0.raw.storage = value }
        case .apb4lpenr: rcc.apb4lpenr.write { $0.raw.storage = value }
        case .apb5enr: rcc.apb5enr.write { $0.raw.storage = value }
        case .apb5rstr: rcc.apb5rstr.write { $0.raw.storage = value }
        case .apb5lpenr: rcc.apb5lpenr.write { $0.raw.storage = value }
        case .ckgdisr: rcc.ckgdisr.write { $0.raw.storage = value }
        }
    }
}
