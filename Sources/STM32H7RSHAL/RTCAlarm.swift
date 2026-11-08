// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


extension RTC {
    @discardableResult
    public func setAlarm(_ alarm: inout RTCAlarm, format: UInt32) -> HALStatus {
        setAlarm(&alarm, format: format, interrupt: false)
    }
    @discardableResult
    public func setAlarmIT(_ alarm: inout RTCAlarm, format: UInt32) -> HALStatus {
        setAlarm(&alarm, format: format, interrupt: true)
    }
    private func setAlarm(_ alarm: inout RTCAlarm, format: UInt32, interrupt: Bool) -> HALStatus {
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        var word: UInt32 = 0
        let binaryMode = registers.read(.icsr) & 0x300
        if binaryMode != 0x100 {
            let hours = format == 0 ? alarm.time.hours : RTCEncoding.bcdToByte(alarm.time.hours)
            if registers.read(.cr) & 0x40 != 0 {
                precondition(hours >= 1 && hours <= 12 && alarm.time.timeFormat <= 1)
            } else {
                alarm.time.timeFormat = 0
                precondition(hours <= 23)
            }
            let minutes = format == 0 ? alarm.time.minutes : RTCEncoding.bcdToByte(alarm.time.minutes)
            let seconds = format == 0 ? alarm.time.seconds : RTCEncoding.bcdToByte(alarm.time.seconds)
            let day = format == 0 ? alarm.dateWeekday : RTCEncoding.bcdToByte(alarm.dateWeekday)
            precondition(minutes <= 59 && seconds <= 59)
            precondition(day >= 1 && day <= (alarm.dateWeekdaySelection == 0 ? 31 : 7))
            if format == 0 {
                word = UInt32(RTCEncoding.byteToBCD(alarm.time.hours)) << 0x10
                    | UInt32(RTCEncoding.byteToBCD(alarm.time.minutes)) << 0x8
                    | UInt32(RTCEncoding.byteToBCD(alarm.time.seconds)) << 0x0
                    | UInt32(alarm.time.timeFormat) << 0x16
                    | UInt32(RTCEncoding.byteToBCD(alarm.dateWeekday)) << 0x18
                    | alarm.dateWeekdaySelection | alarm.mask
            } else {
                word = UInt32(alarm.time.hours) << 0x10
                    | UInt32(alarm.time.minutes) << 0x8
                    | UInt32(alarm.time.seconds) << 0x0
                    | UInt32(alarm.time.timeFormat) << 0x16
                    | UInt32(alarm.dateWeekday) << 0x18
                    | alarm.dateWeekdaySelection | alarm.mask
            }
        }
        let a = alarm.alarm == 0x100
        modify(.cr, clear: a ? 0x100 | 0x1000 : 0x200 | 0x2000)
        registers.write(.scr, value: a ? 0x1 : 0x2)
        if binaryMode == 0x100 {
            registers.write(a ? .alrmassr : .alrmbssr, value: alarm.subsecondMask | alarm.binaryAutoClear)
        } else {
            registers.write(a ? .alrmar : .alrmbr, value: word)
            registers.write(a ? .alrmassr : .alrmbssr, value: alarm.subsecondMask)
        }
        registers.write(a ? .alrabinr : .alrbbinr, value: alarm.time.subseconds)
        let clearFlag: UInt32 = a ? 0x8000000 : 0x10000000
        if alarm.flagAutoClear == 1 { modify(.cr, set: clearFlag) }
        else { modify(.cr, clear: clearFlag) }
        let enable: UInt32 = a ? 0x100 : 0x200
        let irq: UInt32 = interrupt ? (a ? 0x1000 : 0x2000) : 0
        modify(.cr, set: enable | irq)
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func deactivateAlarm(_ alarm: UInt32) -> HALStatus {
        precondition(alarm == 0x100 || alarm == 0x200)
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        if alarm == 0x100 {
            modify(.cr, clear: 0x100 | 0x1000)
            modify(.alrmassr, clear: 0x80000000)
        } else {
            modify(.cr, clear: 0x200 | 0x2000)
            modify(.alrmbssr, clear: 0x80000000)
        }
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func getAlarm(_ alarm: inout RTCAlarm, selection: UInt32, format: UInt32) -> HALStatus {
        precondition(format <= 1 && (selection == 0x100 || selection == 0x200))
        alarm.alarm = selection == 0x100 ? 0x100 : 0x200
        let word = registers.read(selection == 0x100 ? .alrmar : .alrmbr)
        let subseconds = registers.read(selection == 0x100 ? .alrmassr : .alrmbssr) & 0x7FFF
        alarm.time.hours = UInt8((word & (0x300000 | 0xF0000)) >> 0x10)
        alarm.time.minutes = UInt8((word & (0x7000 | 0xF00)) >> 0x8)
        alarm.time.seconds = UInt8((word & (0x70 | 0xF)) >> 0x0)
        alarm.time.timeFormat = UInt8((word & 0x400000) >> 0x16)
        alarm.time.subseconds = subseconds
        alarm.dateWeekday = UInt8((word & (0x30000000 | 0xF000000)) >> 0x18)
        alarm.dateWeekdaySelection = word & 0x40000000
        alarm.mask = word & 0x80808080
        if format == 0 {
            alarm.time.hours = RTCEncoding.bcdToByte(alarm.time.hours)
            alarm.time.minutes = RTCEncoding.bcdToByte(alarm.time.minutes)
            alarm.time.seconds = RTCEncoding.bcdToByte(alarm.time.seconds)
            alarm.dateWeekday = RTCEncoding.bcdToByte(alarm.dateWeekday)
        }
        return .ok
    }
    public func alarmIRQHandler() {
        let status = registers.read(.misr)
        if status & 0x1 != 0 { registers.write(.scr, value: 0x1); invoke(.alarmA) }
        if status & 0x2 != 0 { registers.write(.scr, value: 0x2); invoke(.alarmB) }
        handle.write(.state, value: RTCState.ready.rawValue)
    }
    public func pollForAlarmA(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        pollEvent(flag: 0x1, clear: 0x1, timeout: timeout, getTick: getTick)
    }
    public func pollForAlarmB(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        pollEvent(flag: 0x2, clear: 0x2, timeout: timeout, getTick: getTick)
    }
    func pollEvent(flag: UInt32, clear: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        while registers.read(.sr) & flag == 0 {
            if timeout != UInt32.max {
                if getTick() &- start > timeout || timeout == 0 {
                    if registers.read(.sr) & flag == 0 { return .timeout }
                    else { break }
                }
            }
        }
        if clear != 0 { registers.write(.scr, value: clear) }
        return .ok
    }
}
