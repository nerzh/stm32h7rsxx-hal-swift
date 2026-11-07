// Copyright (c) 2022 STMicroelectronics.
// SPDX-License-Identifier: Apache-2.0
// Register offsets adapted from CMSIS stm32h7s3xx.h, revision
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
typealias DeviceEXTI = STM32H7R.EXTI
#else
import STM32H7S
typealias DeviceEXTI = STM32H7S.EXTI
#endif

// The pinned SVD omits reserved gaps in EXTI_TypeDef. Keep its register
// layouts and volatile accessors, but bind them to authoritative CMSIS offsets.
// There is no PR3, RTSR3, FTSR3, or SWIER3 in this device.
enum CMSISEXTI {
    static var rtsr1: Register<DeviceEXTI.RTSR1> { .init(unsafeAddress: exti.unsafeAddress + 0x00) }
    static var ftsr1: Register<DeviceEXTI.FTSR1> { .init(unsafeAddress: exti.unsafeAddress + 0x04) }
    static var swier1: Register<DeviceEXTI.SWIER1> { .init(unsafeAddress: exti.unsafeAddress + 0x08) }
    static var rtsr2: Register<DeviceEXTI.RTSR2> { .init(unsafeAddress: exti.unsafeAddress + 0x20) }
    static var ftsr2: Register<DeviceEXTI.FTSR2> { .init(unsafeAddress: exti.unsafeAddress + 0x24) }
    static var swier2: Register<DeviceEXTI.SWIER2> { .init(unsafeAddress: exti.unsafeAddress + 0x28) }
    static var imr1: Register<DeviceEXTI.IMR1> { .init(unsafeAddress: exti.unsafeAddress + 0x80) }
    static var emr1: Register<DeviceEXTI.EMR1> { .init(unsafeAddress: exti.unsafeAddress + 0x84) }
    static var pr1: Register<DeviceEXTI.PR1> { .init(unsafeAddress: exti.unsafeAddress + 0x88) }
    static var imr2: Register<DeviceEXTI.IMR2> { .init(unsafeAddress: exti.unsafeAddress + 0x90) }
    static var emr2: Register<DeviceEXTI.EMR2> { .init(unsafeAddress: exti.unsafeAddress + 0x94) }
    static var pr2: Register<DeviceEXTI.PR2> { .init(unsafeAddress: exti.unsafeAddress + 0x98) }
    static var imr3: Register<DeviceEXTI.IMR3> { .init(unsafeAddress: exti.unsafeAddress + 0xA0) }
    static var emr3: Register<DeviceEXTI.EMR3> { .init(unsafeAddress: exti.unsafeAddress + 0xA4) }
}

public struct STM32EXTIRegisters: EXTIRegisterIO {
    public init() {}

    public mutating func read(_ register: EXTIRegister) -> UInt32 {
        switch register {
        case .risingTrigger(let bank):
            precondition(bank == 0 || bank == 1)
            return bank == 0 ? CMSISEXTI.rtsr1.read().raw.storage : CMSISEXTI.rtsr2.read().raw.storage
        case .fallingTrigger(let bank):
            precondition(bank == 0 || bank == 1)
            return bank == 0 ? CMSISEXTI.ftsr1.read().raw.storage : CMSISEXTI.ftsr2.read().raw.storage
        case .softwareInterrupt(let bank):
            precondition(bank == 0 || bank == 1)
            return bank == 0 ? CMSISEXTI.swier1.read().raw.storage : CMSISEXTI.swier2.read().raw.storage
        case .interruptMask(let bank):
            switch bank {
            case 0: return CMSISEXTI.imr1.read().raw.storage
            case 1: return CMSISEXTI.imr2.read().raw.storage
            case 2: return CMSISEXTI.imr3.read().raw.storage
            default: preconditionFailure("Invalid EXTI bank")
            }
        case .eventMask(let bank):
            switch bank {
            case 0: return CMSISEXTI.emr1.read().raw.storage
            case 1: return CMSISEXTI.emr2.read().raw.storage
            case 2: return CMSISEXTI.emr3.read().raw.storage
            default: preconditionFailure("Invalid EXTI bank")
            }
        case .pending(let bank):
            precondition(bank == 0 || bank == 1)
            return bank == 0 ? CMSISEXTI.pr1.read().raw.storage : CMSISEXTI.pr2.read().raw.storage
        case .gpioSelection(let index): return SBSGPIOSelection.read(index)
        }
    }

    public mutating func write(_ register: EXTIRegister, value: UInt32) {
        switch register {
        case .risingTrigger(let bank):
            precondition(bank == 0 || bank == 1)
            if bank == 0 { CMSISEXTI.rtsr1.write { $0.raw.storage = value } }
            else { CMSISEXTI.rtsr2.write { $0.raw.storage = value } }
        case .fallingTrigger(let bank):
            precondition(bank == 0 || bank == 1)
            if bank == 0 { CMSISEXTI.ftsr1.write { $0.raw.storage = value } }
            else { CMSISEXTI.ftsr2.write { $0.raw.storage = value } }
        case .softwareInterrupt(let bank):
            precondition(bank == 0 || bank == 1)
            if bank == 0 { CMSISEXTI.swier1.write { $0.raw.storage = value } }
            else { CMSISEXTI.swier2.write { $0.raw.storage = value } }
        case .interruptMask(let bank):
            switch bank {
            case 0: CMSISEXTI.imr1.write { $0.raw.storage = value }
            case 1: CMSISEXTI.imr2.write { $0.raw.storage = value }
            case 2: CMSISEXTI.imr3.write { $0.raw.storage = value }
            default: preconditionFailure("Invalid EXTI bank")
            }
        case .eventMask(let bank):
            switch bank {
            case 0: CMSISEXTI.emr1.write { $0.raw.storage = value }
            case 1: CMSISEXTI.emr2.write { $0.raw.storage = value }
            case 2: CMSISEXTI.emr3.write { $0.raw.storage = value }
            default: preconditionFailure("Invalid EXTI bank")
            }
        case .pending(let bank):
            precondition(bank == 0 || bank == 1)
            if bank == 0 { CMSISEXTI.pr1.write { $0.raw.storage = value } }
            else { CMSISEXTI.pr2.write { $0.raw.storage = value } }
        case .gpioSelection(let index): SBSGPIOSelection.write(index, value: value)
        }
    }
}
