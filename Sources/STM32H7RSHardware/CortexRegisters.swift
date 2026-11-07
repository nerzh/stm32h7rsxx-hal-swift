// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Register layout adapted from CMSIS_6 core_cm7.h at
// 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt and LICENSES/ARM-CMSIS-Apache-2.0.txt.

import CCortexHALSupport
import CortexMCore
import STM32H7RSHAL
import _Volatile

public struct STM32CortexRegisters: CortexRegisterIO {
    public init() {}

    public mutating func read(_ register: CortexRegister) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.address(of: register)).load()
    }

    public mutating func write(_ register: CortexRegister, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.address(of: register)).store(value)
    }

    public mutating func readPriority(_ register: CortexPriorityRegister) -> UInt8 {
        VolatileMappedRegister<UInt8>(unsafeBitPattern: Self.address(of: register)).load()
    }

    public mutating func writePriority(_ register: CortexPriorityRegister, value: UInt8) {
        VolatileMappedRegister<UInt8>(unsafeBitPattern: Self.address(of: register)).store(value)
    }

    public mutating func perform(_ instruction: CortexInstruction) {
        switch instruction {
        case .compilerBarrier: hal_cortex_compiler_barrier()
        case .dataMemoryBarrier: hal_cortex_dmb()
        case .dataSynchronizationBarrier: dataSynchronizationBarrier()
        case .instructionSynchronizationBarrier: instructionSynchronizationBarrier()
        case .sendEvent: hal_cortex_sev()
        case .waitForEvent: hal_cortex_wfe()
        case .noOperation: hal_cortex_nop()
        }
    }

    static func address(of register: CortexRegister) -> UInt {
        switch register {
        case .aircr: return 0xE000ED0C
        case .shcsr: return 0xE000ED24
        case .sysTickControl: return 0xE000E010
        case .sysTickReload: return 0xE000E014
        case .sysTickCurrent: return 0xE000E018
        case .mpuControl: return 0xE000ED94
        case .mpuRegionNumber: return 0xE000ED98
        case .mpuRegionBaseAddress: return 0xE000ED9C
        case .mpuRegionAttributes: return 0xE000EDA0
        case .nvicSetEnable(let bank): return bankAddress(base: 0xE000E100, bank: bank)
        case .nvicClearEnable(let bank): return bankAddress(base: 0xE000E180, bank: bank)
        case .nvicSetPending(let bank): return bankAddress(base: 0xE000E200, bank: bank)
        case .nvicClearPending(let bank): return bankAddress(base: 0xE000E280, bank: bank)
        case .nvicActive(let bank): return bankAddress(base: 0xE000E300, bank: bank)
        }
    }

    static func address(of register: CortexPriorityRegister) -> UInt {
        switch register {
        case .device(let index):
            precondition(index >= 0 && index < 240)
            return 0xE000E400 + UInt(index)
        case .system(let index):
            precondition(index >= 0 && index < 12)
            return 0xE000ED18 + UInt(index)
        }
    }

    private static func bankAddress(base: UInt, bank: Int) -> UInt {
        precondition(bank >= 0 && bank < 8)
        return base + UInt(bank) * 4
    }
}
