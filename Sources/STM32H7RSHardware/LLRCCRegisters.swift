// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

import STM32H7RSHAL
import _Volatile

#if STM32H7R
    import STM32H7R
#else
    import STM32H7S
#endif

extension STM32RCCRegisters: LLRCCRegisterIO {
    public mutating func read(_ register: LLRCCRegister) -> UInt32 {
        switch register {
        case .csicfgr: return rcc.csicfgr.read().raw.storage
        case .crrcr: return rcc.crrcr.read().raw.storage
        case .pll1sscgr: return rcc.pll1sscgr.read().raw.storage
        case .pll2sscgr: return rcc.pll2sscgr.read().raw.storage
        case .pll3sscgr: return rcc.pll3sscgr.read().raw.storage
        }
    }
    public mutating func write(_ register: LLRCCRegister, value: UInt32) {
        switch register {
        case .csicfgr: rcc.csicfgr.write { $0.raw.storage = value }
        case .crrcr: rcc.crrcr.write { $0.raw.storage = value }
        case .pll1sscgr: rcc.pll1sscgr.write { $0.raw.storage = value }
        case .pll2sscgr: rcc.pll2sscgr.write { $0.raw.storage = value }
        case .pll3sscgr: rcc.pll3sscgr.write { $0.raw.storage = value }
        }
    }
}

extension STM32RCCRegisters: LLClockUtilitiesRegisterIO {
    public func read(_ register: PowerExtendedRegister) -> UInt32 {
        STM32PowerExtendedRegisters().read(register)
    }
    public func write(_ register: PowerExtendedRegister, value: UInt32) {
        STM32PowerExtendedRegisters().write(register, value: value)
    }
}

extension STM32HALRegisters: LLIdentificationRegisterIO {
    public static var packageAddress: UInt { 0x08FF_F80C }
    public mutating func read(_ register: LLIdentificationRegister) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: Self.packageAddress).load()
    }
}
