// UID address from CMSIS stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32HALRegisters: HALRegisterIO {
    public init() {}

    public mutating func read(_ register: HALRegister) -> UInt32 {
        switch register {
        case .apb1Reset1: return rcc.apb1rstr1.read().raw.storage
        case .apb1Reset2: return rcc.apb1rstr2.read().raw.storage
        case .apb2Reset: return rcc.apb2rstr.read().raw.storage
        case .apb4Reset: return rcc.apb4rstr.read().raw.storage
        case .apb5Reset: return rcc.apb5rstr.read().raw.storage
        case .ahb1Reset: return rcc.ahb1rstr.read().raw.storage
        case .ahb2Reset: return rcc.ahb2rstr.read().raw.storage
        case .ahb3Reset: return rcc.ahb3rstr.read().raw.storage
        case .ahb4Reset: return rcc.ahb4rstr.read().raw.storage
        case .ahb5Reset: return rcc.ahb5rstr.read().raw.storage
        case .debugIdentification: return dbgmcu.idc.read().raw.storage
        case .debugControl: return dbgmcu.cr.read().raw.storage
        case .uniqueIDWord(let index):
            return VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.uniqueIDWordAddress(index: index)).load()
        }
    }

    public mutating func write(_ register: HALRegister, value: UInt32) {
        switch register {
        case .apb1Reset1: rcc.apb1rstr1.write { $0.raw.storage = value }
        case .apb1Reset2: rcc.apb1rstr2.write { $0.raw.storage = value }
        case .apb2Reset: rcc.apb2rstr.write { $0.raw.storage = value }
        case .apb4Reset: rcc.apb4rstr.write { $0.raw.storage = value }
        case .apb5Reset: rcc.apb5rstr.write { $0.raw.storage = value }
        case .ahb1Reset: rcc.ahb1rstr.write { $0.raw.storage = value }
        case .ahb2Reset: rcc.ahb2rstr.write { $0.raw.storage = value }
        case .ahb3Reset: rcc.ahb3rstr.write { $0.raw.storage = value }
        case .ahb4Reset: rcc.ahb4rstr.write { $0.raw.storage = value }
        case .ahb5Reset: rcc.ahb5rstr.write { $0.raw.storage = value }
        case .debugControl: dbgmcu.cr.write { $0.raw.storage = value }
        case .debugIdentification, .uniqueIDWord: preconditionFailure("Read-only HAL register")
        }
    }

    public mutating func setPriorityGrouping(_ group: UInt32) {
        var cortex = Cortex(registers: STM32CortexRegisters())
        cortex.setPriorityGrouping(group)
    }

    static func uniqueIDWordAddress(index: Int) -> UInt {
        precondition((0..<3).contains(index))
        return 0x08FFF800 + UInt(index) * 4
    }
}
