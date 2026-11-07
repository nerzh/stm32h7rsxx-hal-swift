import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32DTSRegisters: DTSRegisterIO {
    public init() {}

    public func read(_ register: DTSRegister) -> UInt32 {
        switch register {
        case .cfgr1: return dts.cfgr1.read().raw.storage
        case .t0valr1: return dts.t0valr1.read().raw.storage
        case .rampvalr: return dts.rampvalr.read().raw.storage
        case .itr1: return dts.itr1.read().raw.storage
        case .dr: return dts.dr.read().raw.storage
        case .sr: return dts.sr.read().raw.storage
        case .itenr: return dts.itenr.read().raw.storage
        case .icifr: return dts.icifr.read().raw.storage
        }
    }

    public func write(_ register: DTSRegister, value: UInt32) {
        switch register {
        case .cfgr1: dts.cfgr1.write { $0.raw.storage = value }
        case .itr1: dts.itr1.write { $0.raw.storage = value }
        case .dr: dts.dr.write { $0.raw.storage = value }
        case .itenr: dts.itenr.write { $0.raw.storage = value }
        case .icifr: dts.icifr.write { $0.raw.storage = value }
        case .t0valr1, .rampvalr, .sr:
            preconditionFailure("DTS calibration and status registers are read-only")
        }
    }

    func address(of register: DTSRegister) -> UInt {
        switch register {
        case .cfgr1: return dts.cfgr1.unsafeAddress
        case .t0valr1: return dts.t0valr1.unsafeAddress
        case .rampvalr: return dts.rampvalr.unsafeAddress
        case .itr1: return dts.itr1.unsafeAddress
        case .dr: return dts.dr.unsafeAddress
        case .sr: return dts.sr.unsafeAddress
        case .itenr: return dts.itenr.unsafeAddress
        case .icifr: return dts.icifr.unsafeAddress
        }
    }
}

public extension STM32H7RSHAL.DTS where Registers == STM32DTSRegisters {
    init(handle: Handle, callbacks: Callbacks, defaults: DTSCallbackDefaults = .init(),
         useRegisteredCallbacks: Bool = false) {
        self.init(registers: STM32DTSRegisters(), handle: handle, callbacks: callbacks,
                  defaults: defaults, useRegisteredCallbacks: useRegisteredCallbacks)
    }
}
