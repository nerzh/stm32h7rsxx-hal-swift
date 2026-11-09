// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Missing SVD register offsets follow CMSIS LPTIM_TypeDef at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import MMIO
import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32LPTIMRegisters: LPTIMRegisterIO {
    public let instance: LPTIMInstance
    public init(instance: LPTIMInstance) { self.instance = instance }
    var baseAddress: UInt {
        switch instance {
        case .lptim1: return lptim1.unsafeAddress
        case .lptim2: return lptim2.unsafeAddress
        case .lptim3: return lptim3.unsafeAddress
        case .lptim4: return lptim4.unsafeAddress
        case .lptim5: return lptim5.unsafeAddress
        }
    }
    public func address(of register: LPTIMRegister) -> UInt32 { UInt32(baseAddress) + register.rawValue }
    public func read(_ register: LPTIMRegister) -> UInt32 {
        // ST LL clears flags with SET_BIT on ICR. Preserve its volatile read
        // before the write, even though the SVD describes ICR as write-only.
        switch register {
        case .isr:
            switch instance {
            case .lptim1: return lptim1.isr_output.read().raw.storage
            case .lptim2: return lptim2.isr_output.read().raw.storage
            case .lptim3: return lptim3.isr_output.read().raw.storage
            case .lptim4: return lptim4.isr.read().raw.storage
            case .lptim5: return lptim5.isr.read().raw.storage
            }
        case .dier:
            switch instance {
            case .lptim1: return lptim1.dier_output.read().raw.storage
            case .lptim2: return lptim2.dier_output.read().raw.storage
            case .lptim3: return lptim3.dier_output.read().raw.storage
            case .lptim4: return lptim4.dier.read().raw.storage
            case .lptim5: return lptim5.dier.read().raw.storage
            }
        default:
            // The pinned SVD omits CFGR through CCR2. Offsets follow CMSIS
            // LPTIM_TypeDef; keep the full-width volatile accesses used by C.
            return VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
        }
    }
    public func write(_ register: LPTIMRegister, value: UInt32) {
        precondition(register != .isr && register != .cnt, "LPTIM register is read-only")
        switch register {
        case .icr:
            switch instance {
            case .lptim1: lptim1.icr_output.write { $0.raw.storage = value }
            case .lptim2: lptim2.icr_output.write { $0.raw.storage = value }
            case .lptim3: lptim3.icr_output.write { $0.raw.storage = value }
            case .lptim4: lptim4.icr.write { $0.raw.storage = value }
            case .lptim5: lptim5.icr.write { $0.raw.storage = value }
            }
        case .dier:
            switch instance {
            case .lptim1: lptim1.dier_output.write { $0.raw.storage = value }
            case .lptim2: lptim2.dier_output.write { $0.raw.storage = value }
            case .lptim3: lptim3.dier_output.write { $0.raw.storage = value }
            case .lptim4: lptim4.dier.write { $0.raw.storage = value }
            case .lptim5: lptim5.dier.write { $0.raw.storage = value }
            }
        default: VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
        }
    }
    var wakeupInterruptMask: Register<DeviceEXTI.IMR2> { CMSISEXTI.imr2 }
    public func readWakeupInterruptMask() -> UInt32 { wakeupInterruptMask.read().raw.storage }
    public func writeWakeupInterruptMask(_ value: UInt32) { wakeupInterruptMask.write { $0.raw.storage = value } }
}
