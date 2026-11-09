// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_RTC_InitTypeDef: Equatable, Sendable {
    public var HourFormat: UInt32
    public var AsynchPrescaler: UInt32
    public var SynchPrescaler: UInt32
    public init(HourFormat: UInt32 = 0, AsynchPrescaler: UInt32 = 0, SynchPrescaler: UInt32 = 0) {
        self.HourFormat = HourFormat
        self.AsynchPrescaler = AsynchPrescaler
        self.SynchPrescaler = SynchPrescaler
    }
}

public struct LL_RTC_TimeTypeDef: Equatable, Sendable {
    public var TimeFormat: UInt32
    public var Hours: UInt8
    public var Minutes: UInt8
    public var Seconds: UInt8
    public init(TimeFormat: UInt32 = 0, Hours: UInt8 = 0, Minutes: UInt8 = 0, Seconds: UInt8 = 0) {
        self.TimeFormat = TimeFormat
        self.Hours = Hours
        self.Minutes = Minutes
        self.Seconds = Seconds
    }
}

public struct LL_RTC_DateTypeDef: Equatable, Sendable {
    public var WeekDay: UInt8
    public var Month: UInt8
    public var Day: UInt8
    public var Year: UInt8
    public init(WeekDay: UInt8 = 0, Month: UInt8 = 0, Day: UInt8 = 0, Year: UInt8 = 0) {
        self.WeekDay = WeekDay
        self.Month = Month
        self.Day = Day
        self.Year = Year
    }
}

public struct LL_RTC_AlarmTypeDef: Equatable, Sendable {
    public var AlarmTime: LL_RTC_TimeTypeDef
    public var AlarmMask: UInt32
    public var AlarmDateWeekDaySel: UInt32
    public var AlarmDateWeekDay: UInt8
    public init(
        AlarmTime: LL_RTC_TimeTypeDef = .init(), AlarmMask: UInt32 = 0, AlarmDateWeekDaySel: UInt32 = 0,
        AlarmDateWeekDay: UInt8 = 0
    ) {
        self.AlarmTime = AlarmTime
        self.AlarmMask = AlarmMask
        self.AlarmDateWeekDaySel = AlarmDateWeekDaySel
        self.AlarmDateWeekDay = AlarmDateWeekDay
    }
}
