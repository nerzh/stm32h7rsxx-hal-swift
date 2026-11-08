// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


extension RTC {
    public func getFlag(_ selector: UInt32) -> Bool {
        switch selector {
        case 1: return registers.read(.icsr) & 0x10000 != 0
        case 2: return registers.read(.icsr) & 0x40 != 0
        case 3: return registers.read(.icsr) & 0x20 != 0
        case 4: return registers.read(.icsr) & 0x10 != 0
        case 5: return registers.read(.icsr) & 0x8 != 0
        case 6: return registers.read(.icsr) & 0x4 != 0
        case 7: return registers.read(.sr) & 0x40 != 0
        case 8: return registers.read(.sr) & 0x20 != 0
        case 9: return registers.read(.sr) & 0x10 != 0
        case 10: return registers.read(.sr) & 0x8 != 0
        case 11: return registers.read(.sr) & 0x4 != 0
        case 12: return registers.read(.sr) & 0x2 != 0
        case 13: return registers.read(.sr) & 0x1 != 0
        default: return false
        }
    }
    public func getFlag(_ flag: RTCFlag) -> Bool { getFlag(flag.rawValue) }
    public func clearFlags(_ mask: UInt32) { registers.write(.scr, value: mask) }
    public func isCalendarInitialized() -> Bool { registers.read(.icsr) & 0x10 != 0 }
    public func getBinaryMode() -> UInt32 { registers.read(.icsr) & 0x300 }
    public func enableAlarmInterrupt(_ selector: UInt32) {
        if selector == 0x1000 { modify(.cr, set: 0x1000) }
        else if selector == 0x2000 { modify(.cr, set: 0x2000) }
    }
    public func disableAlarmInterrupt(_ selector: UInt32) {
        if selector == 0x1000 { modify(.cr, clear: 0x1000) }
        else if selector == 0x2000 { modify(.cr, clear: 0x2000) }
    }
    public func getAlarmInterrupt(_ selector: UInt32) -> Bool {
        if selector == 0x1000 { return registers.read(.misr) & 0x1 != 0 }
        if selector == 0x2000 { return registers.read(.misr) & 0x2 != 0 }
        return false
    }
    public func getAlarmInterruptSource(_ selector: UInt32) -> Bool {
        if selector == 0x1000 { return registers.read(.cr) & 0x1000 != 0 }
        if selector == 0x2000 { return registers.read(.cr) & 0x2000 != 0 }
        return false
    }
    public func getAlarmFlag(_ selector: UInt32) -> Bool {
        (selector == 0xD || selector == 0xC) ? getFlag(selector) : false
    }
    public func clearAlarmFlag(_ selector: UInt32) {
        if selector == 0xD { registers.write(.scr, value: 0x1) }
        else if selector == 0xC { registers.write(.scr, value: 0x2) }
    }
    public func getWakeUpFlag(_ selector: UInt32) -> Bool {
        (selector == 0xB || selector == 0x6) ? getFlag(selector) : false
    }
    public func getTimestampFlag(_ selector: UInt32) -> Bool {
        (selector == 0xA || selector == 0x9) ? getFlag(selector) : false
    }
    public func clearTimestampFlag(_ selector: UInt32) {
        if selector == 0xA { registers.write(.scr, value: 0x8) }
        else if selector == 0x9 { registers.write(.scr, value: 0x10) }
    }
    public func enableAlarmA() { modify(.cr, set: 0x100) }
    public func disableAlarmA() { modify(.cr, clear: 0x100) }
    public func enableAlarmB() { modify(.cr, set: 0x200) }
    public func disableAlarmB() { modify(.cr, clear: 0x200) }
    public func enableWakeUpTimer() { modify(.cr, set: 0x400) }
    public func disableWakeUpTimer() { modify(.cr, clear: 0x400) }
    public func enableWakeUpInterrupt() { modify(.cr, set: 0x4000) }
    public func disableWakeUpInterrupt() { modify(.cr, clear: 0x4000) }
    public func enableTimestamp() { modify(.cr, set: 0x800) }
    public func disableTimestamp() { modify(.cr, clear: 0x800) }
    public func enableTimestampInterrupt() { modify(.cr, set: 0x8000) }
    public func disableTimestampInterrupt() { modify(.cr, clear: 0x8000) }
    public func enableInternalTimestamp() { modify(.cr, set: 0x1000000) }
    public func disableInternalTimestamp() { modify(.cr, clear: 0x1000000) }
    public func enableTamperTimestamp() { modify(.cr, set: 0x2000000) }
    public func disableTamperTimestamp() { modify(.cr, clear: 0x2000000) }
    public func enableTamperDetectionOutput() { modify(.cr, set: 0x4000000) }
    public func disableTamperDetectionOutput() { modify(.cr, clear: 0x4000000) }
    public func enableCalibrationOutput() { modify(.cr, set: 0x800000) }
    public func disableCalibrationOutput() { modify(.cr, clear: 0x800000) }
    public func enableReferenceClockDetection() { modify(.cr, set: 0x10) }
    public func disableReferenceClockDetection() { modify(.cr, clear: 0x10) }
    public func enableSubsecondUnderflowInterrupt() { modify(.cr, set: 0x80) }
    public func disableSubsecondUnderflowInterrupt() { modify(.cr, clear: 0x80) }
    public func getWakeUpInterrupt() -> Bool { registers.read(.misr) & 0x4 != 0 }
    public func getWakeUpInterruptSource() -> Bool { registers.read(.cr) & 0x4000 != 0 }
    public func getTimestampInterrupt() -> Bool { registers.read(.misr) & 0x8 != 0 }
    public func getTimestampInterruptSource() -> Bool { registers.read(.cr) & 0x8000 != 0 }
    public func getSubsecondUnderflowInterrupt() -> Bool { registers.read(.misr) & 0x40 != 0 }
    public func getSubsecondUnderflowInterruptSource() -> Bool { registers.read(.cr) & 0x80 != 0 }
    public func clearWakeUpFlag() { registers.write(.scr, value: 0x4) }
    public func clearInternalTimestampFlag() { registers.write(.scr, value: 0x20) }
    public func clearSubsecondUnderflowFlag() { registers.write(.scr, value: 0x40) }
    public func getInternalTimestampFlag() -> Bool { registers.read(.sr) & 0x20 != 0 }
    public func getSubsecondUnderflowFlag() -> Bool { registers.read(.sr) & 0x40 != 0 }
    public func getShiftFlag() -> Bool { registers.read(.icsr) & 0x8 != 0 }
    public func enableTamper(_ mask: UInt32) { modifyTamper(.cr1, set: mask) }
    public func disableTamper(_ mask: UInt32) { modifyTamper(.cr1, clear: mask) }
    public func enableTamperInterrupt(_ mask: UInt32) { modifyTamper(.ier, set: mask) }
    public func disableTamperInterrupt(_ mask: UInt32) { modifyTamper(.ier, clear: mask) }
    public func getTamperFlag(_ mask: UInt32) -> Bool { registers.readTamper(.sr) & mask != 0 }
    public func getTamperInterrupt(_ mask: UInt32) -> Bool { registers.readTamper(.misr) & mask != 0 }
    public func getTamperInterruptSource(_ mask: UInt32) -> Bool { registers.readTamper(.ier) & mask != 0 }
    public func clearTamperFlags(_ mask: UInt32) { registers.writeTamper(.scr, value: mask) }
    public func addDaylightSavingHour(storeOperation: UInt32) {
        disableWriteProtection()
        modify(.cr, set: 0x10000)
        modify(.cr, clear: 0x40000, set: storeOperation)
        enableWriteProtection()
    }
    public func subtractDaylightSavingHour(storeOperation: UInt32) {
        disableWriteProtection()
        modify(.cr, set: 0x20000)
        modify(.cr, clear: 0x40000, set: storeOperation)
        enableWriteProtection()
    }
}
