// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

import MMIO
import STM32H7RSHAL
import _Volatile

#if STM32H7R
    import STM32H7R
#else
    import STM32H7S
#endif

public struct STM32DLYBRegisters: DLYBRegisterIO {
    public let instance: DLYBInstance
    public init(instance: DLYBInstance) { self.instance = instance }
    public func address(of register: DLYBRegister) -> UInt32 {
        switch (instance, register) {
        case (.sdmmc1, .cr): return UInt32(dlyb1.cr.unsafeAddress)
        case (.sdmmc1, .cfgr): return UInt32(dlyb1.cfgr.unsafeAddress)
        case (.sdmmc2, .cr): return UInt32(dlyb2.cr.unsafeAddress)
        case (.sdmmc2, .cfgr): return UInt32(dlyb2.cfgr.unsafeAddress)
        }
    }
    public func read(_ register: DLYBRegister) -> UInt32 {
        switch (instance, register) {
        case (.sdmmc1, .cr): return dlyb1.cr.read().raw.storage
        case (.sdmmc1, .cfgr): return dlyb1.cfgr.read().raw.storage
        case (.sdmmc2, .cr): return dlyb2.cr.read().raw.storage
        case (.sdmmc2, .cfgr): return dlyb2.cfgr.read().raw.storage
        }
    }
    public func write(_ register: DLYBRegister, value: UInt32) {
        switch (instance, register) {
        case (.sdmmc1, .cr): dlyb1.cr.write { $0.raw.storage = value }
        case (.sdmmc1, .cfgr): dlyb1.cfgr.write { $0.raw.storage = value }
        case (.sdmmc2, .cr): dlyb2.cr.write { $0.raw.storage = value }
        case (.sdmmc2, .cfgr): dlyb2.cfgr.write { $0.raw.storage = value }
        }
    }
}
