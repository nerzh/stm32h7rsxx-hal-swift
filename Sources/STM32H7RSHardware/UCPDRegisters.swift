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

public struct STM32UCPDRegisters: UCPDRegisterIO, LLBusRegisterIO {
    public init() {}
    public func address(of register: UCPDRegister) -> UInt32 {
        switch register {
        case .cfg1: return UInt32(ucpd.cfgr1.unsafeAddress)
        case .cfg2: return UInt32(ucpd.cfgr2.unsafeAddress)
        case .cr: return UInt32(ucpd.cr.unsafeAddress)
        case .imr: return UInt32(ucpd.imr.unsafeAddress)
        case .sr: return UInt32(ucpd.sr.unsafeAddress)
        case .icr: return UInt32(ucpd.icr.unsafeAddress)
        case .tx_ordset: return UInt32(ucpd.tx_ordsetr.unsafeAddress)
        case .tx_paysz: return UInt32(ucpd.tx_payszr.unsafeAddress)
        case .txdr: return UInt32(ucpd.txdr.unsafeAddress)
        case .rx_ordset: return UInt32(ucpd.rx_ordsetr.unsafeAddress)
        case .rx_paysz: return UInt32(ucpd.rx_payszr.unsafeAddress)
        case .rxdr: return UInt32(ucpd.rxdr.unsafeAddress)
        case .rx_ordext1: return UInt32(ucpd.rx_ordextr1.unsafeAddress)
        case .rx_ordext2: return UInt32(ucpd.rx_ordextr2.unsafeAddress)
        case .cfg3: return UInt32(ucpd.unsafeAddress) + 8
        }
    }
    public func read(_ register: UCPDRegister) -> UInt32 {
        switch register {
        case .cfg1: return ucpd.cfgr1.read().raw.storage
        case .cfg2: return ucpd.cfgr2.read().raw.storage
        case .cr: return ucpd.cr.read().raw.storage
        case .imr: return ucpd.imr.read().raw.storage
        case .sr: return ucpd.sr.read().raw.storage
        case .tx_ordset: return ucpd.tx_ordsetr.read().raw.storage
        case .tx_paysz: return ucpd.tx_payszr.read().raw.storage
        case .rx_ordset: return ucpd.rx_ordsetr.read().raw.storage
        case .rx_paysz: return ucpd.rx_payszr.read().raw.storage
        case .rxdr: return ucpd.rxdr.read().raw.storage
        case .rx_ordext1: return ucpd.rx_ordextr1.read().raw.storage
        case .rx_ordext2: return ucpd.rx_ordextr2.read().raw.storage
        // Preserve ST's ICR read/modify/write and CMSIS-only CFG3 accesses.
        default: return VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
        }
    }
    public func write(_ register: UCPDRegister, value: UInt32) {
        switch register {
        case .cfg1: ucpd.cfgr1.write { $0.raw.storage = value }
        case .cfg2: ucpd.cfgr2.write { $0.raw.storage = value }
        case .cr: ucpd.cr.write { $0.raw.storage = value }
        case .imr: ucpd.imr.write { $0.raw.storage = value }
        case .icr: ucpd.icr.write { $0.raw.storage = value }
        case .tx_ordset: ucpd.tx_ordsetr.write { $0.raw.storage = value }
        case .tx_paysz: ucpd.tx_payszr.write { $0.raw.storage = value }
        case .txdr: ucpd.txdr.write { $0.raw.storage = value }
        case .rx_ordext1: ucpd.rx_ordextr1.write { $0.raw.storage = value }
        case .rx_ordext2: ucpd.rx_ordextr2.write { $0.raw.storage = value }
        default: VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
        }
    }
    public mutating func read(_ register: LLBusRegister) -> UInt32 {
        var bus = STM32RCCRegisters()
        return bus.read(register)
    }
    public mutating func write(_ register: LLBusRegister, value: UInt32) {
        var bus = STM32RCCRegisters()
        bus.write(register, value: value)
    }
}
