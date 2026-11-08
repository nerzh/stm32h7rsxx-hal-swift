// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum RTCRegister: UInt32, CaseIterable, Sendable {
    case tr = 0x0
    case dr = 0x4
    case ssr = 0x8
    case icsr = 0xC
    case prer = 0x10
    case wutr = 0x14
    case cr = 0x18
    case privcfgr = 0x1C
    case wpr = 0x24
    case calr = 0x28
    case shiftr = 0x2C
    case tstr = 0x30
    case tsdr = 0x34
    case tsssr = 0x38
    case alrmar = 0x40
    case alrmassr = 0x44
    case alrmbr = 0x48
    case alrmbssr = 0x4C
    case sr = 0x50
    case misr = 0x54
    case scr = 0x5C
    case alrabinr = 0x70
    case alrbbinr = 0x74
}
public enum RTCTamperRegister: UInt32, CaseIterable, Sendable {
    case cr1 = 0x0
    case cr2 = 0x4
    case cr3 = 0x8
    case fltcr = 0xC
    case atcr1 = 0x10
    case atseedr = 0x14
    case ator = 0x18
    case atcr2 = 0x1C
    case cfgr = 0x20
    case privcfgr = 0x24
    case ier = 0x2C
    case sr = 0x30
    case misr = 0x34
    case scr = 0x3C
    case count1r = 0x40
    case rpcfgr = 0x54
}
public protocol RTCRegisterIO {
    func read(_ register: RTCRegister) -> UInt32
    func write(_ register: RTCRegister, value: UInt32)
    func readTamper(_ register: RTCTamperRegister) -> UInt32
    func writeTamper(_ register: RTCTamperRegister, value: UInt32)
    func readBackup(_ index: UInt32) -> UInt32
    func writeBackup(_ index: UInt32, value: UInt32)
    // DeInit alone polls the legacy handle Instance; other operations use RTC.
    func readInstanceInitializationStatus() -> UInt32
}
public extension RTCRegisterIO {
    func readInstanceInitializationStatus() -> UInt32 { read(.icsr) }
}
public enum RTCHandleWord: Int, CaseIterable {
    case hourFormat = 0, asynchronousPrescaler, synchronousPrescaler, output, outputRemap
    case outputPolarity, outputType, outputPullUp, binaryMode, binaryMixUpdate, lock, state
}
public protocol RTCHandleIO {
    func read(_ word: RTCHandleWord) -> UInt32
    func write(_ word: RTCHandleWord, value: UInt32)
}
public enum RTCState: UInt32, CaseIterable, Sendable { case reset = 0, ready, busy, timeout, error }
public enum RTCFormat: UInt32, CaseIterable, Sendable { case binary = 0, bcd = 1 }
public enum RTCHourFormat: UInt32, CaseIterable, Sendable { case hours24 = 0, hours12 = 0x40 }
public enum RTCBinaryMode: UInt32, CaseIterable, Sendable { case none = 0, only = 0x100, mixed = 0x200 }
public enum RTCAlarmSelection: UInt32, CaseIterable, Sendable { case a = 0x100, b = 0x200 }
// RTC flag selectors are identifiers, not OR-combinable register masks.
public enum RTCFlag: UInt32, CaseIterable, Sendable {
    case recalibrationPending = 1, initializationReady, synchronized, calendarInitialized, shiftPending, wakeUpWritable
    case subsecondUnderflow, internalTimestamp, timestampOverflow, timestamp, wakeUp, alarmB, alarmA
}
public struct RTCConfiguration: Equatable, Sendable {
    public var hourFormat: UInt32
    public var asynchronousPrescaler: UInt32
    public var synchronousPrescaler: UInt32
    public var output: UInt32
    public var outputRemap: UInt32
    public var outputPolarity: UInt32
    public var outputType: UInt32
    public var outputPullUp: UInt32
    public var binaryMode: UInt32
    public var binaryMixUpdate: UInt32
    public init(hourFormat: UInt32 = 0, asynchronousPrescaler: UInt32 = 0, synchronousPrescaler: UInt32 = 0, output: UInt32 = 0, outputRemap: UInt32 = 0, outputPolarity: UInt32 = 0, outputType: UInt32 = 0, outputPullUp: UInt32 = 0, binaryMode: UInt32 = 0, binaryMixUpdate: UInt32 = 0) {
        self.hourFormat = hourFormat
        self.asynchronousPrescaler = asynchronousPrescaler
        self.synchronousPrescaler = synchronousPrescaler
        self.output = output
        self.outputRemap = outputRemap
        self.outputPolarity = outputPolarity
        self.outputType = outputType
        self.outputPullUp = outputPullUp
        self.binaryMode = binaryMode
        self.binaryMixUpdate = binaryMixUpdate
    }
}
public struct RTCTime: Equatable, Sendable {
    public var hours: UInt8
    public var minutes: UInt8
    public var seconds: UInt8
    public var timeFormat: UInt8
    public var subseconds: UInt32
    public var secondFraction: UInt32
    public var daylightSaving: UInt32
    public var storeOperation: UInt32
    public init(hours: UInt8 = 0, minutes: UInt8 = 0, seconds: UInt8 = 0, timeFormat: UInt8 = 0, subseconds: UInt32 = 0, secondFraction: UInt32 = 0, daylightSaving: UInt32 = 0, storeOperation: UInt32 = 0) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.timeFormat = timeFormat
        self.subseconds = subseconds
        self.secondFraction = secondFraction
        self.daylightSaving = daylightSaving
        self.storeOperation = storeOperation
    }
}
public struct RTCDate: Equatable, Sendable {
    public var weekday: UInt8
    public var month: UInt8
    public var day: UInt8
    public var year: UInt8
    public init(weekday: UInt8 = 0, month: UInt8 = 0, day: UInt8 = 0, year: UInt8 = 0) {
        self.weekday = weekday
        self.month = month
        self.day = day
        self.year = year
    }
}
public struct RTCAlarm: Equatable, Sendable {
    public var time: RTCTime
    public var mask: UInt32
    public var subsecondMask: UInt32
    public var binaryAutoClear: UInt32
    public var dateWeekdaySelection: UInt32
    public var dateWeekday: UInt8
    public var flagAutoClear: UInt32
    public var alarm: UInt32
    public init(time: RTCTime = .init(), mask: UInt32 = 0, subsecondMask: UInt32 = 0, binaryAutoClear: UInt32 = 0, dateWeekdaySelection: UInt32 = 0, dateWeekday: UInt8 = 0, flagAutoClear: UInt32 = 0, alarm: UInt32 = 0x100) {
        self.time = time
        self.mask = mask
        self.subsecondMask = subsecondMask
        self.binaryAutoClear = binaryAutoClear
        self.dateWeekdaySelection = dateWeekdaySelection
        self.dateWeekday = dateWeekday
        self.flagAutoClear = flagAutoClear
        self.alarm = alarm
    }
}
public struct RTCTamperConfiguration: Equatable, Sendable {
    public var tamper: UInt32
    public var trigger: UInt32
    public var noErase: UInt32
    public var maskFlag: UInt32
    public var filter: UInt32
    public var samplingFrequency: UInt32
    public var prechargeDuration: UInt32
    public var pullUp: UInt32
    public var timestampOnDetection: UInt32
    public init(tamper: UInt32 = 0, trigger: UInt32 = 0, noErase: UInt32 = 0, maskFlag: UInt32 = 0, filter: UInt32 = 0, samplingFrequency: UInt32 = 0, prechargeDuration: UInt32 = 0, pullUp: UInt32 = 0, timestampOnDetection: UInt32 = 0) {
        self.tamper = tamper
        self.trigger = trigger
        self.noErase = noErase
        self.maskFlag = maskFlag
        self.filter = filter
        self.samplingFrequency = samplingFrequency
        self.prechargeDuration = prechargeDuration
        self.pullUp = pullUp
        self.timestampOnDetection = timestampOnDetection
    }
}
public struct RTCActiveTamperInput: Equatable, Sendable {
    public var enable: UInt32
    public var interrupt: UInt32
    public var output: UInt32
    public var noErase: UInt32
    public var maskFlag: UInt32
    public init(enable: UInt32 = 0, interrupt: UInt32 = 0, output: UInt32 = 0, noErase: UInt32 = 0, maskFlag: UInt32 = 0) {
        self.enable = enable
        self.interrupt = interrupt
        self.output = output
        self.noErase = noErase
        self.maskFlag = maskFlag
    }
}
public struct RTCInternalTamperConfiguration: Equatable, Sendable {
    public var tamper: UInt32
    public var timestampOnDetection: UInt32
    public var noErase: UInt32
    public init(tamper: UInt32 = 0, timestampOnDetection: UInt32 = 0, noErase: UInt32 = 0) {
        self.tamper = tamper
        self.timestampOnDetection = timestampOnDetection
        self.noErase = noErase
    }
}
public struct RTCPrivilegeConfiguration: Equatable, Sendable {
    public var rtcFull: UInt32
    public var rtcFeatures: UInt32
    public var tamperFull: UInt32
    public var backupZone: UInt32
    public var backupStartZone2: UInt32
    public var backupStartZone3: UInt32
    public var monotonicCounter: UInt32
    public init(rtcFull: UInt32 = 0, rtcFeatures: UInt32 = 0, tamperFull: UInt32 = 0, backupZone: UInt32 = 0, backupStartZone2: UInt32 = 0, backupStartZone3: UInt32 = 0, monotonicCounter: UInt32 = 0) {
        self.rtcFull = rtcFull
        self.rtcFeatures = rtcFeatures
        self.tamperFull = tamperFull
        self.backupZone = backupZone
        self.backupStartZone2 = backupStartZone2
        self.backupStartZone3 = backupStartZone3
        self.monotonicCounter = monotonicCounter
    }
}
public struct RTCActiveTampersConfiguration: Sendable {
    public var filter: UInt32
    public var asynchronousPrescaler: UInt32
    public var timestampOnDetection: UInt32
    public var outputChangePeriod: UInt32
    public var seed: InlineArray<4, UInt32>
    public var inputs: InlineArray<8, RTCActiveTamperInput>
    public init(filter: UInt32 = 0, asynchronousPrescaler: UInt32 = 0, timestampOnDetection: UInt32 = 0,
                outputChangePeriod: UInt32 = 0, seed: InlineArray<4, UInt32> = .init(repeating: 0),
                inputs: InlineArray<8, RTCActiveTamperInput> = .init(repeating: .init())) {
        self.filter = filter; self.asynchronousPrescaler = asynchronousPrescaler
        self.timestampOnDetection = timestampOnDetection; self.outputChangePeriod = outputChangePeriod
        self.seed = seed; self.inputs = inputs
    }
}
public struct RTC<Registers: RTCRegisterIO, Handle: RTCHandleIO, Callbacks: RTCCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: RTCCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: RTCCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
    public func setConfiguration(_ value: RTCConfiguration) {
        handle.write(.hourFormat, value: value.hourFormat)
        handle.write(.asynchronousPrescaler, value: value.asynchronousPrescaler)
        handle.write(.synchronousPrescaler, value: value.synchronousPrescaler)
        handle.write(.output, value: value.output)
        handle.write(.outputRemap, value: value.outputRemap)
        handle.write(.outputPolarity, value: value.outputPolarity)
        handle.write(.outputType, value: value.outputType)
        handle.write(.outputPullUp, value: value.outputPullUp)
        handle.write(.binaryMode, value: value.binaryMode)
        handle.write(.binaryMixUpdate, value: value.binaryMixUpdate)
    }
}
