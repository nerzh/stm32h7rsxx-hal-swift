// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


extension RTC {
    @discardableResult
    public func setTimestamp(edge: UInt32, pin: UInt32 = 0) -> HALStatus {
        precondition((edge == 0 || edge == 0x8) && pin == 0)
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        modify(.cr, clear: 0x8 | 0x800)
        modify(.cr, set: edge | 0x800)
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func setTimestampIT(edge: UInt32, pin: UInt32 = 0) -> HALStatus {
        precondition((edge == 0 || edge == 0x8) && pin == 0)
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        modify(.cr, clear: 0x8 | 0x800 | 0x8000)
        modify(.cr, set: edge)
        modify(.cr, set: 0x800 | 0x8000)
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func deactivateTimestamp() -> HALStatus {
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        modify(.cr, clear: 0x8 | 0x800 | 0x8000)
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func setInternalTimestamp() -> HALStatus { changeControl(set: 0x1000000) }
    @discardableResult
    public func deactivateInternalTimestamp() -> HALStatus { changeControl(clear: 0x1000000) }
    func changeControl(clear: UInt32 = 0, set: UInt32 = 0) -> HALStatus {
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        modify(.cr, clear: clear, set: set)
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func getTimestamp(time: inout RTCTime, date: inout RTCDate, format: UInt32) -> HALStatus {
        precondition(format <= 1)
        let timeWord = registers.read(.tstr) & 0x7F7F7F
        let dateWord = registers.read(.tsdr) & 0xFFFF3F
        time.hours = UInt8((timeWord & (0x300000 | 0xF0000)) >> 0x10)
        time.minutes = UInt8((timeWord & (0x7000 | 0xF00)) >> 0x8)
        time.seconds = UInt8((timeWord & (0x70 | 0xF)) >> 0x0)
        time.timeFormat = UInt8((timeWord & 0x400000) >> 0x16)
        time.subseconds = registers.read(.tsssr) & 0xFFFFFFFF
        date.year = 0
        date.month = UInt8((dateWord & (0x1000 | 0xF00)) >> 0x8)
        date.day = UInt8(dateWord & (0x30 | 0xF))
        date.weekday = UInt8((dateWord & 0xE000) >> 0xD)
        if format == 0 {
            time.hours = RTCEncoding.bcdToByte(time.hours)
            time.minutes = RTCEncoding.bcdToByte(time.minutes)
            time.seconds = RTCEncoding.bcdToByte(time.seconds)
            date.month = RTCEncoding.bcdToByte(date.month)
            date.day = RTCEncoding.bcdToByte(date.day)
            date.weekday = RTCEncoding.bcdToByte(date.weekday)
        }
        if registers.read(.sr) & 0x8 != 0 {
            registers.write(.scr, value: 0x20 | 0x8)
            if registers.read(.sr) & 0x10 != 0 {
                registers.write(.scr, value: 0x10)
                return .error
            }
        }
        return .ok
    }
    public func timestampIRQHandler() {
        if registers.read(.misr) & 0x8 != 0 {
            invoke(.timestamp)
            registers.write(.scr, value: 0x20 | 0x8)
        }
        handle.write(.state, value: RTCState.ready.rawValue)
    }
    public func pollForTimestamp(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        pollEvent(flag: 0x8, clear: 0, timeout: timeout, getTick: getTick)
    }
}
