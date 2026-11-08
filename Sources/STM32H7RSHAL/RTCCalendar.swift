// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum RTCEncoding {
    public static func byteToBCD(_ value: UInt8) -> UInt8 {
        var high: UInt32 = 0, remaining = value
        while remaining >= 10 { high &+= 1; remaining &-= 10 }
        return UInt8(truncatingIfNeeded: high << 4) | remaining
    }
    public static func bcdToByte(_ value: UInt8) -> UInt8 {
        let high = ((UInt32(value) & 0xF0) >> 4) * 10
        return UInt8(truncatingIfNeeded: high + (UInt32(value) & 0x0F))
    }
}
extension RTC {
    @discardableResult
    public func setTime(_ time: inout RTCTime, format: UInt32, getTick: () -> UInt32) -> HALStatus {
        guard lock() else { return .busy }
        handle.write(.state, value: 2); disableWriteProtection()
        var status = enterInitialization(getTick: getTick)
        if status == .ok {
            if registers.read(.icsr) & 0x300 != 0x100 {
                let value: UInt32
                if format == 0 {
                    if registers.read(.cr) & 0x40 != 0 { precondition((1...12).contains(time.hours) && time.timeFormat <= 1) }
                    else { time.timeFormat = 0; precondition(time.hours <= 23) }
                    precondition(time.minutes <= 59 && time.seconds <= 59)
                    value = (UInt32(RTCEncoding.byteToBCD(time.hours)) << 16) | (UInt32(RTCEncoding.byteToBCD(time.minutes)) << 8)
                        | UInt32(RTCEncoding.byteToBCD(time.seconds)) | (UInt32(time.timeFormat) << 22)
                } else {
                    if registers.read(.cr) & 0x40 != 0 { precondition((1...12).contains(RTCEncoding.bcdToByte(time.hours)) && time.timeFormat <= 1) }
                    else { time.timeFormat = 0; precondition(RTCEncoding.bcdToByte(time.hours) <= 23) }
                    precondition(RTCEncoding.bcdToByte(time.minutes) <= 59 && RTCEncoding.bcdToByte(time.seconds) <= 59)
                    value = (UInt32(time.hours) << 16) | (UInt32(time.minutes) << 8) | UInt32(time.seconds) | (UInt32(time.timeFormat) << 22)
                }
                registers.write(.tr, value: value & 0x007F7F7F); modify(.cr, clear: 0x40000)
            }
            status = exitInitialization(getTick: getTick)
        }
        enableWriteProtection(); if status == .ok { handle.write(.state, value: 1) }; unlock(); return status
    }
    @discardableResult
    public func getTime(_ time: inout RTCTime, format: UInt32) -> HALStatus {
        time.subseconds = registers.read(.ssr)
        if registers.read(.icsr) & 0x300 != 0x100 {
            precondition(format <= 1)
            time.secondFraction = registers.read(.prer) & 0x7FFF
            let value = registers.read(.tr) & 0x007F7F7F
            time.hours = UInt8((value & 0x3F0000) >> 16); time.minutes = UInt8((value & 0x7F00) >> 8)
            time.seconds = UInt8(value & 0x7F); time.timeFormat = UInt8((value & 0x400000) >> 22)
            if format == 0 { time.hours = RTCEncoding.bcdToByte(time.hours); time.minutes = RTCEncoding.bcdToByte(time.minutes); time.seconds = RTCEncoding.bcdToByte(time.seconds) }
        }
        return .ok
    }
    @discardableResult
    public func setDate(_ date: inout RTCDate, format: UInt32, getTick: () -> UInt32) -> HALStatus {
        precondition(format <= 1); guard lock() else { return .busy }; handle.write(.state, value: 2)
        if format == 0 && date.month & 0x10 == 0x10 { date.month = (date.month & ~UInt8(0x10)) &+ 10 }
        precondition((1...7).contains(date.weekday))
        let value: UInt32
        if format == 0 {
            precondition(date.year <= 99 && (1...12).contains(date.month) && (1...31).contains(date.day))
            value = (UInt32(RTCEncoding.byteToBCD(date.year)) << 16) | (UInt32(RTCEncoding.byteToBCD(date.month)) << 8)
                | UInt32(RTCEncoding.byteToBCD(date.day)) | (UInt32(date.weekday) << 13)
        } else {
            precondition(RTCEncoding.bcdToByte(date.year) <= 99 && (1...12).contains(RTCEncoding.bcdToByte(date.month)) && (1...31).contains(RTCEncoding.bcdToByte(date.day)))
            value = (UInt32(date.year) << 16) | (UInt32(date.month) << 8) | UInt32(date.day) | (UInt32(date.weekday) << 13)
        }
        disableWriteProtection(); var status = enterInitialization(getTick: getTick)
        if status == .ok { registers.write(.dr, value: value & 0x00FFFF3F); status = exitInitialization(getTick: getTick) }
        enableWriteProtection(); if status == .ok { handle.write(.state, value: 1) }; unlock(); return status
    }
    @discardableResult
    public func getDate(_ date: inout RTCDate, format: UInt32) -> HALStatus {
        precondition(format <= 1); let value = registers.read(.dr) & 0x00FFFF3F
        date.year = UInt8((value & 0xFF0000) >> 16); date.month = UInt8((value & 0x1F00) >> 8)
        date.day = UInt8(value & 0x3F); date.weekday = UInt8((value & 0xE000) >> 13)
        if format == 0 { date.year = RTCEncoding.bcdToByte(date.year); date.month = RTCEncoding.bcdToByte(date.month); date.day = RTCEncoding.bcdToByte(date.day) }
        return .ok
    }
    public func addDaylightSavingHour() { disableWriteProtection(); modify(.cr, set: 0x10000); enableWriteProtection() }
    public func subtractDaylightSavingHour() { disableWriteProtection(); modify(.cr, set: 0x20000); enableWriteProtection() }
    public func setDaylightSavingStoreOperation() { modify(.cr, set: 0x40000) }
    public func clearDaylightSavingStoreOperation() { modify(.cr, clear: 0x40000) }
    public func getDaylightSavingStoreOperation() -> UInt32 { registers.read(.cr) & 0x40000 }
}
