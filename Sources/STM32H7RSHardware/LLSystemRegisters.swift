// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

import STM32H7RSHAL
import _Volatile
import MMIO
#if STM32H7R
import STM32H7R
typealias LLDeviceDebug = STM32H7R.DBGMCU
#else
import STM32H7S
typealias LLDeviceDebug = STM32H7S.DBGMCU
#endif

extension STM32CortexRegisters: LLCortexRegisterIO {
    public mutating func read(_ register: LLCoreRegister) -> UInt32 {
        let address: UInt = register == .cpuid ? 0xE000ED00 : 0xE000ED10
        return VolatileMappedRegister<UInt32>(unsafeBitPattern: address).load()
    }
    public mutating func write(_ register: LLCoreRegister, value: UInt32) {
        precondition(register == .systemControl, "CPUID is read-only")
        VolatileMappedRegister<UInt32>(unsafeBitPattern: 0xE000ED10).store(value)
    }
}

extension STM32HALRegisters: LLDebugRegisterIO {
    public static func address(of register: LLDebugRegister) -> UInt {
        dbgmcu.unsafeAddress + UInt(register.rawValue)
    }

    // The pinned SVD puts AHB5FZR at +0x20. CMSIS places it at +0x1C;
    // retain the generated register layout at the corrected address.
    private var llAHB5Freeze: Register<LLDeviceDebug.AHB5FZR> {
        .init(unsafeAddress: Self.address(of: .ahb5fzr))
    }

    public mutating func read(_ register: LLDebugRegister) -> UInt32 {
        switch register {
        case .ahb1fzr: return dbgmcu.ahb1fzr.read().raw.storage
        case .ahb5fzr: return llAHB5Freeze.read().raw.storage
        case .apb1fzr: return dbgmcu.apb1fzr.read().raw.storage
        case .apb2fzr: return dbgmcu.apb2fz.read().raw.storage
        case .apb4fzr: return dbgmcu.apb4fzr.read().raw.storage
        case .cr: return read(HALRegister.debugControl)
        case .idcode: return read(HALRegister.debugIdentification)
        }
    }
    public mutating func write(_ register: LLDebugRegister, value: UInt32) {
        switch register {
        case .ahb1fzr: dbgmcu.ahb1fzr.write { $0.raw.storage = value }
        case .ahb5fzr: llAHB5Freeze.write { $0.raw.storage = value }
        case .apb1fzr: dbgmcu.apb1fzr.write { $0.raw.storage = value }
        case .apb2fzr: dbgmcu.apb2fz.write { $0.raw.storage = value }
        case .apb4fzr: dbgmcu.apb4fzr.write { $0.raw.storage = value }
        case .cr: write(HALRegister.debugControl, value: value)
        case .idcode: preconditionFailure("DBGMCU identification is read-only")
        }
    }
}
