// Copyright (c) 2022 STMicroelectronics.
// SPDX-License-Identifier: Apache-2.0
// Monitor addresses from all four CMSIS stm32h7{r,s}{3,7}xx.h headers at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
typealias DeviceRAMCFG = STM32H7R.RAMCFG
#else
import STM32H7S
typealias DeviceRAMCFG = STM32H7S.RAMCFG
#endif

public enum STM32RAMECCMonitor: UInt32, CaseIterable, Sendable {
    case ramecc1Monitor0 = 0x5200_9020
    case ramecc1Monitor1 = 0x5200_9040
    case ramecc1Monitor2 = 0x5200_9060
    case ramecc1Monitor3 = 0x5200_9080
    case ramecc1Monitor4 = 0x5200_90A0
    case ramecc2Monitor1 = 0x5802_7040
}

public struct STM32RAMECCRegisters: RAMECCRegisterIO {
    public let monitor: STM32RAMECCMonitor
    public init(monitor: STM32RAMECCMonitor) { self.monitor = monitor }

    // Both pinned SVDs name this block RAMCFG and label offsets 0x20...0xA0
    // M1...M5. CMSIS instead names RAMECC1 monitors 0...4 and RAMECC2 monitor 1
    // at 0x40. Reuse the SVD's identical typed monitor layouts at CMSIS addresses.
    var ier: Register<DeviceRAMCFG.IER> { .init(unsafeAddress: UInt(monitor.rawValue & 0xFFFF_FF00)) }
    var cr: Register<DeviceRAMCFG.M1CR> { .init(unsafeAddress: UInt(monitor.rawValue)) }
    var sr: Register<DeviceRAMCFG.M1SR> { .init(unsafeAddress: UInt(monitor.rawValue) + 4) }
    var far: Register<DeviceRAMCFG.M1FAR> { .init(unsafeAddress: UInt(monitor.rawValue) + 8) }
    var fdrl: Register<DeviceRAMCFG.M1FDRL> { .init(unsafeAddress: UInt(monitor.rawValue) + 12) }
    var fdrh: Register<DeviceRAMCFG.M1FDRH> { .init(unsafeAddress: UInt(monitor.rawValue) + 16) }
    var fecr: Register<DeviceRAMCFG.M1FECR> { .init(unsafeAddress: UInt(monitor.rawValue) + 20) }

    public func read(_ register: RAMECCRegister) -> UInt32 {
        switch register {
        case .ier: return ier.read().raw.storage
        case .cr: return cr.read().raw.storage
        case .sr: return sr.read().raw.storage
        case .far: return far.read().raw.storage
        case .fdrl: return fdrl.read().raw.storage
        case .fdrh: return fdrh.read().raw.storage
        case .fecr: return fecr.read().raw.storage
        }
    }

    public func write(_ register: RAMECCRegister, value: UInt32) {
        switch register {
        case .ier: ier.write { $0.raw.storage = value }
        case .cr: cr.write { $0.raw.storage = value }
        case .sr: sr.write { $0.raw.storage = value }
        case .far, .fdrl, .fdrh, .fecr: preconditionFailure("RAMECC failing information registers are read-only")
        }
    }
}

public extension STM32H7RSHAL.RAMECC where Registers == STM32RAMECCRegisters {
    init(monitor: STM32RAMECCMonitor, state: State) {
        self.init(registers: STM32RAMECCRegisters(monitor: monitor), state: state)
    }
}
