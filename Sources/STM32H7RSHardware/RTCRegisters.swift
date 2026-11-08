// Copyright (c) 2022 STMicroelectronics.
// SPDX-License-Identifier: Apache-2.0
// RTC/TAMP offsets adapted from CMSIS stm32h7s3xx.h, revision
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import MMIO
import _Volatile
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
typealias DeviceRTC = STM32H7R.RTC
#else
import STM32H7S
typealias DeviceRTC = STM32H7S.RTC
#endif

public struct STM32RTCRegisters: RTCRegisterIO {
    private let legacyInstanceAddress: UInt
    public init(legacyInstanceAddress: UInt? = nil) {
        self.legacyInstanceAddress = legacyInstanceAddress ?? rtc.unsafeAddress
        precondition(self.legacyInstanceAddress & 3 == 0)
    }
    public func readInstanceInitializationStatus() -> UInt32 {
        Register<DeviceRTC.ICSR>(unsafeAddress: legacyInstanceAddress + 0xC).read().raw.storage
    }
    public func read(_ register: RTCRegister) -> UInt32 {
        switch register {
        case .tr: return rtc.tr.read().raw.storage
        case .dr: return rtc.dr.read().raw.storage
        case .ssr: return rtc.ssr.read().raw.storage
        case .icsr: return rtc.icsr.read().raw.storage
        case .prer: return rtc.prer.read().raw.storage
        case .wutr: return rtc.wutr.read().raw.storage
        case .cr: return rtc.cr.read().raw.storage
        case .privcfgr: return rtc.privcfgr.read().raw.storage
        case .wpr: return rtc.wpr.read().raw.storage
        case .calr: return rtc.calr.read().raw.storage
        case .shiftr: return rtc.shiftr.read().raw.storage
        case .tstr: return rtc.tstr.read().raw.storage
        case .tsdr: return rtc.tsdr.read().raw.storage
        case .tsssr: return rtc.tsssr.read().raw.storage
        case .alrmar: return rtc.alrmr[0].read().raw.storage
        case .alrmassr: return rtc.alrmssr[0].read().raw.storage
        case .alrmbr: return rtc.alrmr[1].read().raw.storage
        case .alrmbssr: return rtc.alrmssr[1].read().raw.storage
        case .sr: return rtc.sr.read().raw.storage
        case .misr: return rtc.misr.read().raw.storage
        case .scr: return rtc.scr.read().raw.storage
        case .alrabinr: return rtc.alrbinr[0].read().raw.storage
        case .alrbbinr: return rtc.alrbinr[1].read().raw.storage
        }
    }
    public func write(_ register: RTCRegister, value: UInt32) {
        switch register {
        case .tr: rtc.tr.write { $0.raw.storage = value }
        case .dr: rtc.dr.write { $0.raw.storage = value }
        case .ssr: preconditionFailure("RTC/TAMP register is read-only")
        case .icsr: rtc.icsr.write { $0.raw.storage = value }
        case .prer: rtc.prer.write { $0.raw.storage = value }
        case .wutr: rtc.wutr.write { $0.raw.storage = value }
        case .cr: rtc.cr.write { $0.raw.storage = value }
        case .privcfgr: rtc.privcfgr.write { $0.raw.storage = value }
        case .wpr: rtc.wpr.write { $0.raw.storage = value }
        case .calr: rtc.calr.write { $0.raw.storage = value }
        case .shiftr: rtc.shiftr.write { $0.raw.storage = value }
        case .tstr: preconditionFailure("RTC/TAMP register is read-only")
        case .tsdr: preconditionFailure("RTC/TAMP register is read-only")
        case .tsssr: preconditionFailure("RTC/TAMP register is read-only")
        case .alrmar: rtc.alrmr[0].write { $0.raw.storage = value }
        case .alrmassr: rtc.alrmssr[0].write { $0.raw.storage = value }
        case .alrmbr: rtc.alrmr[1].write { $0.raw.storage = value }
        case .alrmbssr: rtc.alrmssr[1].write { $0.raw.storage = value }
        case .sr: preconditionFailure("RTC/TAMP register is read-only")
        case .misr: preconditionFailure("RTC/TAMP register is read-only")
        case .scr: rtc.scr.write { $0.raw.storage = value }
        case .alrabinr: rtc.alrbinr[0].write { $0.raw.storage = value }
        case .alrbbinr: rtc.alrbinr[1].write { $0.raw.storage = value }
        }
    }
    func address(of register: RTCRegister) -> UInt {
        switch register {
        case .tr: return rtc.tr.unsafeAddress
        case .dr: return rtc.dr.unsafeAddress
        case .ssr: return rtc.ssr.unsafeAddress
        case .icsr: return rtc.icsr.unsafeAddress
        case .prer: return rtc.prer.unsafeAddress
        case .wutr: return rtc.wutr.unsafeAddress
        case .cr: return rtc.cr.unsafeAddress
        case .privcfgr: return rtc.privcfgr.unsafeAddress
        case .wpr: return rtc.wpr.unsafeAddress
        case .calr: return rtc.calr.unsafeAddress
        case .shiftr: return rtc.shiftr.unsafeAddress
        case .tstr: return rtc.tstr.unsafeAddress
        case .tsdr: return rtc.tsdr.unsafeAddress
        case .tsssr: return rtc.tsssr.unsafeAddress
        case .alrmar: return rtc.alrmr[0].unsafeAddress
        case .alrmassr: return rtc.alrmssr[0].unsafeAddress
        case .alrmbr: return rtc.alrmr[1].unsafeAddress
        case .alrmbssr: return rtc.alrmssr[1].unsafeAddress
        case .sr: return rtc.sr.unsafeAddress
        case .misr: return rtc.misr.unsafeAddress
        case .scr: return rtc.scr.unsafeAddress
        case .alrabinr: return rtc.alrbinr[0].unsafeAddress
        case .alrbbinr: return rtc.alrbinr[1].unsafeAddress
        }
    }
    public func readTamper(_ register: RTCTamperRegister) -> UInt32 {
        switch register {
        case .cr1: return tamp.cr1.read().raw.storage
        case .cr2: return tamp.cr2.read().raw.storage
        case .cr3: return tamp.cr3.read().raw.storage
        case .fltcr: return tamp.fltcr.read().raw.storage
        case .atcr1: return tamp.atcr1.read().raw.storage
        case .atseedr: return tamp.atseedr.read().raw.storage
        case .ator: return tamp.ator.read().raw.storage
        case .atcr2: return tamp.atcr2.read().raw.storage
        case .cfgr: return tamp.cfgr.read().raw.storage
        case .privcfgr: return tamp.privcfgr.read().raw.storage
        case .ier: return tamp.ier.read().raw.storage
        case .sr: return tamp.sr.read().raw.storage
        case .misr: return tamp.misr.read().raw.storage
        case .scr: return tamp.scr.read().raw.storage
        case .count1r: return tamp.count1r.read().raw.storage
        case .rpcfgr: return VolatileMappedRegister<UInt32>(unsafeBitPattern: tamp.unsafeAddress + 0x54).load()
        }
    }
    public func writeTamper(_ register: RTCTamperRegister, value: UInt32) {
        switch register {
        case .cr1: tamp.cr1.write { $0.raw.storage = value }
        case .cr2: tamp.cr2.write { $0.raw.storage = value }
        case .cr3: tamp.cr3.write { $0.raw.storage = value }
        case .fltcr: tamp.fltcr.write { $0.raw.storage = value }
        case .atcr1: tamp.atcr1.write { $0.raw.storage = value }
        case .atseedr: tamp.atseedr.write { $0.raw.storage = value }
        case .ator: tamp.ator.write { $0.raw.storage = value }
        case .atcr2: tamp.atcr2.write { $0.raw.storage = value }
        case .cfgr: tamp.cfgr.write { $0.raw.storage = value }
        case .privcfgr: tamp.privcfgr.write { $0.raw.storage = value }
        case .ier: tamp.ier.write { $0.raw.storage = value }
        case .sr: preconditionFailure("RTC/TAMP register is read-only")
        case .misr: preconditionFailure("RTC/TAMP register is read-only")
        case .scr: tamp.scr.write { $0.raw.storage = value }
        case .count1r: tamp.count1r.write { $0.raw.storage = value }
        case .rpcfgr: VolatileMappedRegister<UInt32>(unsafeBitPattern: tamp.unsafeAddress + 0x54).store(value)
        }
    }
    func address(of register: RTCTamperRegister) -> UInt {
        switch register {
        case .cr1: return tamp.cr1.unsafeAddress
        case .cr2: return tamp.cr2.unsafeAddress
        case .cr3: return tamp.cr3.unsafeAddress
        case .fltcr: return tamp.fltcr.unsafeAddress
        case .atcr1: return tamp.atcr1.unsafeAddress
        case .atseedr: return tamp.atseedr.unsafeAddress
        case .ator: return tamp.ator.unsafeAddress
        case .atcr2: return tamp.atcr2.unsafeAddress
        case .cfgr: return tamp.cfgr.unsafeAddress
        case .privcfgr: return tamp.privcfgr.unsafeAddress
        case .ier: return tamp.ier.unsafeAddress
        case .sr: return tamp.sr.unsafeAddress
        case .misr: return tamp.misr.unsafeAddress
        case .scr: return tamp.scr.unsafeAddress
        case .count1r: return tamp.count1r.unsafeAddress
        case .rpcfgr: return tamp.unsafeAddress + 0x54
        }
    }
    public func readBackup(_ index: UInt32) -> UInt32 {
        precondition(index < 32); return tamp.bkpr[Int(index)].read().raw.storage
    }
    public func writeBackup(_ index: UInt32, value: UInt32) {
        precondition(index < 32); tamp.bkpr[Int(index)].write { $0.raw.storage = value }
    }
    func backupAddress(_ index: UInt32) -> UInt {
        precondition(index < 32); return tamp.bkpr[Int(index)].unsafeAddress
    }
}
