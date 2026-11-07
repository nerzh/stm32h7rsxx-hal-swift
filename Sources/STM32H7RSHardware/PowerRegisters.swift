// Copyright (c) 2022 STMicroelectronics.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Register offsets: CMSIS stm32h7s3xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010
// and CMSIS_6 core_cm7.h at 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt.

import CCortexHALSupport
import CortexMCore
import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32PowerRegisters: PowerRegisterIO {
    public init() {}

    // SCB_BASE (0xE000ED00) + offsetof(SCB_Type, SCR) (0x10).
    static let systemControlAddress: UInt = 0xE000_ED10

    private var systemControl: VolatileMappedRegister<UInt32> {
        .init(unsafeBitPattern: Self.systemControlAddress)
    }

    public mutating func read(_ register: PowerRegister) -> UInt32 {
        switch register {
        case .cr1: return pwr.cr1.read().raw.storage
        case .csr3: return pwr.csr3.read().raw.storage
        case .wakeupEnablePolarity: return pwr.wkupepr.read().raw.storage
        case .systemControl: return systemControl.load()
        case .extiInterruptMask: return CMSISEXTI.imr1.read().raw.storage
        case .extiEventMask: return CMSISEXTI.emr1.read().raw.storage
        case .extiRisingTrigger: return CMSISEXTI.rtsr1.read().raw.storage
        case .extiFallingTrigger: return CMSISEXTI.ftsr1.read().raw.storage
        }
    }

    public mutating func write(_ register: PowerRegister, value: UInt32) {
        switch register {
        case .cr1: pwr.cr1.write { $0.raw.storage = value }
        case .csr3: pwr.csr3.write { $0.raw.storage = value }
        case .wakeupEnablePolarity: pwr.wkupepr.write { $0.raw.storage = value }
        case .systemControl: systemControl.store(value)
        case .extiInterruptMask: CMSISEXTI.imr1.write { $0.raw.storage = value }
        case .extiEventMask: CMSISEXTI.emr1.write { $0.raw.storage = value }
        case .extiRisingTrigger: CMSISEXTI.rtsr1.write { $0.raw.storage = value }
        case .extiFallingTrigger: CMSISEXTI.ftsr1.write { $0.raw.storage = value }
        }
    }

    public mutating func dataSynchronizationBarrier() {
        CortexMCore.dataSynchronizationBarrier()
    }

    public mutating func instructionSynchronizationBarrier() {
        CortexMCore.instructionSynchronizationBarrier()
    }

    public mutating func waitForInterrupt() {
        CortexMCore.waitForInterrupt()
    }

    public mutating func sendEvent() {
        hal_cortex_sev()
    }

    public mutating func waitForEvent() {
        hal_cortex_wfe()
    }
}

public extension Power where IO == STM32PowerRegisters {
    init() {
        self.init(registers: STM32PowerRegisters())
    }
}
