import CRTCReference
import STM32H7RSHAL

struct RTCModel: RTCRegisterIO, RTCHandleIO, RTCCallbackIO {
    let state: OpaquePointer
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func get(_ area: UInt32, _ i: UInt32) -> UInt32 { CRTC_Get(state, area, i) }
    func set(_ area: UInt32, _ i: UInt32, _ v: UInt32) { CRTC_Set(state, area, i, v) }
    func read(_ register: RTCRegister) -> UInt32 { get(0, register.rawValue / 4) }
    func write(_ register: RTCRegister, value: UInt32) { set(0, register.rawValue / 4, value) }
    func readTamper(_ register: RTCTamperRegister) -> UInt32 { get(1, register.rawValue / 4) }
    func writeTamper(_ register: RTCTamperRegister, value: UInt32) { set(1, register.rawValue / 4, value) }
    func readBackup(_ index: UInt32) -> UInt32 { get(1, 64 + index) }
    func writeBackup(_ index: UInt32, value: UInt32) { set(1, 64 + index, value) }
    func readInstanceInitializationStatus() -> UInt32 { get(get(10, 7) == 0 ? 0 : 15, 3) }
    func read(_ word: RTCHandleWord) -> UInt32 { get(2, UInt32(word.rawValue)) }
    func write(_ word: RTCHandleWord, value: UInt32) { set(2, UInt32(word.rawValue), value) }
    func read(_ id: RTCCallbackID) -> RTCCallback? { Self.callback(id.rawValue, CRTC_GetCallback(state, id.rawValue)) }
    func write(_ id: RTCCallbackID, value: RTCCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(Self.callback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CRTC_SetCallback(state, id.rawValue, token)
    }
    static func callback(_ id: UInt32, _ token: UInt32) -> RTCCallback? {
        if token == 0 { return nil }
        switch (id, token) {
        case (0, 1): return { CRTC_Callback(OpaquePointer($0!), 0, 1) }
        case (0, 2): return { CRTC_Callback(OpaquePointer($0!), 0, 2) }
        case (1, 1): return { CRTC_Callback(OpaquePointer($0!), 1, 1) }
        case (1, 2): return { CRTC_Callback(OpaquePointer($0!), 1, 2) }
        case (2, 1): return { CRTC_Callback(OpaquePointer($0!), 2, 1) }
        case (2, 2): return { CRTC_Callback(OpaquePointer($0!), 2, 2) }
        case (3, 1): return { CRTC_Callback(OpaquePointer($0!), 3, 1) }
        case (3, 2): return { CRTC_Callback(OpaquePointer($0!), 3, 2) }
        case (4, 1): return { CRTC_Callback(OpaquePointer($0!), 4, 1) }
        case (4, 2): return { CRTC_Callback(OpaquePointer($0!), 4, 2) }
        case (5, 1): return { CRTC_Callback(OpaquePointer($0!), 5, 1) }
        case (5, 2): return { CRTC_Callback(OpaquePointer($0!), 5, 2) }
        case (6, 1): return { CRTC_Callback(OpaquePointer($0!), 6, 1) }
        case (6, 2): return { CRTC_Callback(OpaquePointer($0!), 6, 2) }
        case (7, 1): return { CRTC_Callback(OpaquePointer($0!), 7, 1) }
        case (7, 2): return { CRTC_Callback(OpaquePointer($0!), 7, 2) }
        case (8, 1): return { CRTC_Callback(OpaquePointer($0!), 8, 1) }
        case (8, 2): return { CRTC_Callback(OpaquePointer($0!), 8, 2) }
        case (9, 1): return { CRTC_Callback(OpaquePointer($0!), 9, 1) }
        case (9, 2): return { CRTC_Callback(OpaquePointer($0!), 9, 2) }
        case (10, 1): return { CRTC_Callback(OpaquePointer($0!), 10, 1) }
        case (10, 2): return { CRTC_Callback(OpaquePointer($0!), 10, 2) }
        case (11, 1): return { CRTC_Callback(OpaquePointer($0!), 11, 1) }
        case (11, 2): return { CRTC_Callback(OpaquePointer($0!), 11, 2) }
        case (12, 1): return { CRTC_Callback(OpaquePointer($0!), 12, 1) }
        case (12, 2): return { CRTC_Callback(OpaquePointer($0!), 12, 2) }
        case (13, 1): return { CRTC_Callback(OpaquePointer($0!), 13, 1) }
        case (13, 2): return { CRTC_Callback(OpaquePointer($0!), 13, 2) }
        case (14, 1): return { CRTC_Callback(OpaquePointer($0!), 14, 1) }
        case (14, 2): return { CRTC_Callback(OpaquePointer($0!), 14, 2) }
        case (15, 1): return { CRTC_Callback(OpaquePointer($0!), 15, 1) }
        case (15, 2): return { CRTC_Callback(OpaquePointer($0!), 15, 2) }
        case (16, 1): return { CRTC_Callback(OpaquePointer($0!), 16, 1) }
        case (16, 2): return { CRTC_Callback(OpaquePointer($0!), 16, 2) }
        case (17, 1): return { CRTC_Callback(OpaquePointer($0!), 17, 1) }
        case (17, 2): return { CRTC_Callback(OpaquePointer($0!), 17, 2) }
        case (18, 1): return { CRTC_Callback(OpaquePointer($0!), 18, 1) }
        case (18, 2): return { CRTC_Callback(OpaquePointer($0!), 18, 2) }
        case (19, 1): return { CRTC_Callback(OpaquePointer($0!), 19, 1) }
        case (19, 2): return { CRTC_Callback(OpaquePointer($0!), 19, 2) }
        case (20, 1): return { CRTC_Callback(OpaquePointer($0!), 20, 1) }
        case (20, 2): return { CRTC_Callback(OpaquePointer($0!), 20, 2) }
        case (21, 1): return { CRTC_Callback(OpaquePointer($0!), 21, 1) }
        case (21, 2): return { CRTC_Callback(OpaquePointer($0!), 21, 2) }
        case (22, 1): return { CRTC_Callback(OpaquePointer($0!), 22, 1) }
        case (22, 2): return { CRTC_Callback(OpaquePointer($0!), 22, 2) }
        case (23, 1): return { CRTC_Callback(OpaquePointer($0!), 23, 1) }
        case (23, 2): return { CRTC_Callback(OpaquePointer($0!), 23, 2) }
        case (24, 1): return { CRTC_Callback(OpaquePointer($0!), 24, 1) }
        case (24, 2): return { CRTC_Callback(OpaquePointer($0!), 24, 2) }
        case (25, 1): return { CRTC_Callback(OpaquePointer($0!), 25, 1) }
        case (25, 2): return { CRTC_Callback(OpaquePointer($0!), 25, 2) }
        default: return nil
        }
    }
    var defaults: RTCCallbackDefaults { .init(alarmA: Self.callback(0, 1)!, alarmB: Self.callback(1, 1)!, timestamp: Self.callback(2, 1)!, wakeUp: Self.callback(3, 1)!, subsecondUnderflow: Self.callback(4, 1)!, tamper1: Self.callback(5, 1)!, tamper2: Self.callback(6, 1)!, tamper3: Self.callback(7, 1)!, tamper4: Self.callback(8, 1)!, tamper5: Self.callback(9, 1)!, tamper6: Self.callback(10, 1)!, tamper7: Self.callback(11, 1)!, tamper8: Self.callback(12, 1)!, internalTamper1: Self.callback(13, 1)!, internalTamper2: Self.callback(14, 1)!, internalTamper3: Self.callback(15, 1)!, internalTamper4: Self.callback(16, 1)!, internalTamper5: Self.callback(17, 1)!, internalTamper6: Self.callback(18, 1)!, internalTamper7: Self.callback(19, 1)!, internalTamper8: Self.callback(20, 1)!, internalTamper9: Self.callback(21, 1)!, internalTamper11: Self.callback(22, 1)!, internalTamper15: Self.callback(23, 1)!, mspInitialize: Self.callback(24, 1)!, mspDeinitialize: Self.callback(25, 1)!) }
    var driver: RTC<Self, Self, Self> { .init(registers: self, handle: self, callbacks: self, defaults: defaults, useRegisteredCallbacks: get(14, 0) != 0) }
    var time: RTCTime {
        get {
            var value = RTCTime()
            value.hours = UInt8(truncatingIfNeeded: get(3, 0))
            value.minutes = UInt8(truncatingIfNeeded: get(3, 1))
            value.seconds = UInt8(truncatingIfNeeded: get(3, 2))
            value.timeFormat = UInt8(truncatingIfNeeded: get(3, 3))
            value.subseconds = get(3, 4)
            value.secondFraction = get(3, 5)
            value.daylightSaving = get(3, 6)
            value.storeOperation = get(3, 7)
            return value
        }
        nonmutating set {
            set(3, 0, UInt32(newValue.hours))
            set(3, 1, UInt32(newValue.minutes))
            set(3, 2, UInt32(newValue.seconds))
            set(3, 3, UInt32(newValue.timeFormat))
            set(3, 4, UInt32(newValue.subseconds))
            set(3, 5, UInt32(newValue.secondFraction))
            set(3, 6, UInt32(newValue.daylightSaving))
            set(3, 7, UInt32(newValue.storeOperation))
        }
    }
    var date: RTCDate {
        get {
            var value = RTCDate()
            value.weekday = UInt8(truncatingIfNeeded: get(4, 0))
            value.month = UInt8(truncatingIfNeeded: get(4, 1))
            value.day = UInt8(truncatingIfNeeded: get(4, 2))
            value.year = UInt8(truncatingIfNeeded: get(4, 3))
            return value
        }
        nonmutating set {
            set(4, 0, UInt32(newValue.weekday))
            set(4, 1, UInt32(newValue.month))
            set(4, 2, UInt32(newValue.day))
            set(4, 3, UInt32(newValue.year))
        }
    }
    var alarm: RTCAlarm {
        get {
            var value = RTCAlarm()
            value.time.hours = UInt8(truncatingIfNeeded: get(5, 0))
            value.time.minutes = UInt8(truncatingIfNeeded: get(5, 1))
            value.time.seconds = UInt8(truncatingIfNeeded: get(5, 2))
            value.time.timeFormat = UInt8(truncatingIfNeeded: get(5, 3))
            value.time.subseconds = get(5, 4)
            value.time.secondFraction = get(5, 5)
            value.time.daylightSaving = get(5, 6)
            value.time.storeOperation = get(5, 7)
            value.mask = get(5, 8)
            value.subsecondMask = get(5, 9)
            value.binaryAutoClear = get(5, 10)
            value.dateWeekdaySelection = get(5, 11)
            value.dateWeekday = UInt8(truncatingIfNeeded: get(5, 12))
            value.flagAutoClear = get(5, 13)
            value.alarm = get(5, 14)
            return value
        }
        nonmutating set {
            set(5, 0, UInt32(newValue.time.hours))
            set(5, 1, UInt32(newValue.time.minutes))
            set(5, 2, UInt32(newValue.time.seconds))
            set(5, 3, UInt32(newValue.time.timeFormat))
            set(5, 4, UInt32(newValue.time.subseconds))
            set(5, 5, UInt32(newValue.time.secondFraction))
            set(5, 6, UInt32(newValue.time.daylightSaving))
            set(5, 7, UInt32(newValue.time.storeOperation))
            set(5, 8, UInt32(newValue.mask))
            set(5, 9, UInt32(newValue.subsecondMask))
            set(5, 10, UInt32(newValue.binaryAutoClear))
            set(5, 11, UInt32(newValue.dateWeekdaySelection))
            set(5, 12, UInt32(newValue.dateWeekday))
            set(5, 13, UInt32(newValue.flagAutoClear))
            set(5, 14, UInt32(newValue.alarm))
        }
    }
    var tamper: RTCTamperConfiguration {
        get {
            var value = RTCTamperConfiguration()
            value.tamper = get(6, 0)
            value.trigger = get(6, 1)
            value.noErase = get(6, 2)
            value.maskFlag = get(6, 3)
            value.filter = get(6, 4)
            value.samplingFrequency = get(6, 5)
            value.prechargeDuration = get(6, 6)
            value.pullUp = get(6, 7)
            value.timestampOnDetection = get(6, 8)
            return value
        }
        nonmutating set {
            set(6, 0, UInt32(newValue.tamper))
            set(6, 1, UInt32(newValue.trigger))
            set(6, 2, UInt32(newValue.noErase))
            set(6, 3, UInt32(newValue.maskFlag))
            set(6, 4, UInt32(newValue.filter))
            set(6, 5, UInt32(newValue.samplingFrequency))
            set(6, 6, UInt32(newValue.prechargeDuration))
            set(6, 7, UInt32(newValue.pullUp))
            set(6, 8, UInt32(newValue.timestampOnDetection))
        }
    }
    var internalTamper: RTCInternalTamperConfiguration {
        get {
            var value = RTCInternalTamperConfiguration()
            value.tamper = get(8, 0)
            value.timestampOnDetection = get(8, 1)
            value.noErase = get(8, 2)
            return value
        }
        nonmutating set {
            set(8, 0, UInt32(newValue.tamper))
            set(8, 1, UInt32(newValue.timestampOnDetection))
            set(8, 2, UInt32(newValue.noErase))
        }
    }
    var privilege: RTCPrivilegeConfiguration {
        get {
            var value = RTCPrivilegeConfiguration()
            value.rtcFull = get(9, 0)
            value.rtcFeatures = get(9, 1)
            value.tamperFull = get(9, 2)
            value.backupZone = get(9, 3)
            value.backupStartZone2 = get(9, 4)
            value.backupStartZone3 = get(9, 5)
            value.monotonicCounter = get(9, 6)
            return value
        }
        nonmutating set {
            set(9, 0, UInt32(newValue.rtcFull))
            set(9, 1, UInt32(newValue.rtcFeatures))
            set(9, 2, UInt32(newValue.tamperFull))
            set(9, 3, UInt32(newValue.backupZone))
            set(9, 4, UInt32(newValue.backupStartZone2))
            set(9, 5, UInt32(newValue.backupStartZone3))
            set(9, 6, UInt32(newValue.monotonicCounter))
        }
    }
    var active: RTCActiveTampersConfiguration {
        var value = RTCActiveTampersConfiguration(filter: get(7,0), asynchronousPrescaler: get(7,1), timestampOnDetection: get(7,2), outputChangePeriod: get(7,3))
        for i in 0..<4 { value.seed[i] = get(7, UInt32(4 + i)) }
        for i in 0..<8 {
            let n = UInt32(8 + i * 5)
            value.inputs[i] = .init(enable: get(7,n), interrupt: get(7,n+1), output: get(7,n+2), noErase: get(7,n+3), maskFlag: get(7,n+4))
        }
        return value
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        let rtc = driver
        let tick = { CRTC_TickFor(state) }
        switch op {
        case 0: return rtc.initialize(getTick: tick).rawValue
        case 1: return rtc.deinitialize(getTick: tick).rawValue
        case 2: return rtc.registerCallback(id: a, callback: Self.callback(a,b)).rawValue
        case 3: return rtc.unregisterCallback(id: a).rawValue
        case 4: var value = time; let status = rtc.setTime(&value, format: a, getTick: tick); time = value; return status.rawValue
        case 5: var value = time; let status = rtc.getTime(&value, format: a); time = value; return status.rawValue
        case 6: var value = date; let status = rtc.setDate(&value, format: a, getTick: tick); date = value; return status.rawValue
        case 7: var value = date; let status = rtc.getDate(&value, format: a); date = value; return status.rawValue
        case 8: rtc.addDaylightSavingHour(); return 0
        case 9: rtc.subtractDaylightSavingHour(); return 0
        case 10: rtc.setDaylightSavingStoreOperation(); return 0
        case 11: rtc.clearDaylightSavingStoreOperation(); return 0
        case 12: return rtc.getDaylightSavingStoreOperation()
        case 13: var value = alarm; let status = rtc.setAlarm(&value, format: a); alarm = value; return status.rawValue
        case 14: var value = alarm; let status = rtc.setAlarmIT(&value, format: a); alarm = value; return status.rawValue
        case 15: return rtc.deactivateAlarm(a).rawValue
        case 16: var value = alarm; let status = rtc.getAlarm(&value, selection: a, format: b); alarm = value; return status.rawValue
        case 17: rtc.alarmIRQHandler(); return 0
        case 18: return rtc.pollForAlarmA(timeout: a, getTick: tick).rawValue
        case 19: return rtc.waitForSynchronization(getTick: tick).rawValue
        case 20: return rtc.getState()
        case 21: return rtc.enterInitialization(getTick: tick).rawValue
        case 22: return rtc.exitInitialization(getTick: tick).rawValue
        case 23: return UInt32(RTCEncoding.byteToBCD(UInt8(truncatingIfNeeded: a)))
        case 24: return UInt32(RTCEncoding.bcdToByte(UInt8(truncatingIfNeeded: a)))
        case 25: return rtc.setTimestamp(edge: a, pin: b).rawValue
        case 26: return rtc.setTimestampIT(edge: a, pin: b).rawValue
        case 27: return rtc.deactivateTimestamp().rawValue
        case 28: return rtc.setInternalTimestamp().rawValue
        case 29: return rtc.deactivateInternalTimestamp().rawValue
        case 30: var t = time; var d = date; let status = rtc.getTimestamp(time: &t, date: &d, format: a); time = t; date = d; return status.rawValue
        case 31: rtc.timestampIRQHandler(); return 0
        case 32: return rtc.pollForTimestamp(timeout: a, getTick: tick).rawValue
        case 33: return rtc.setWakeUpTimer(counter: a, clock: b, getTick: tick).rawValue
        case 34: return rtc.setWakeUpTimerIT(counter: a, clock: b, autoClear: c, getTick: tick).rawValue
        case 35: return rtc.deactivateWakeUpTimer().rawValue
        case 36: return rtc.getWakeUpTimer()
        case 37: rtc.wakeUpIRQHandler(); return 0
        case 38: return rtc.pollForWakeUpTimer(timeout: a, getTick: tick).rawValue
        case 39: return rtc.setSmoothCalibration(period: a, plusPulses: b, minusPulses: c, getTick: tick).rawValue
        case 40: return rtc.setLowPowerCalibration(a).rawValue
        case 41: return rtc.setSynchronizationShift(addSecond: a, subtractFraction: b, getTick: tick).rawValue
        case 42: return rtc.setCalibrationOutput(a).rawValue
        case 43: return rtc.deactivateCalibrationOutput().rawValue
        case 44: return rtc.setReferenceClock(getTick: tick).rawValue
        case 45: return rtc.deactivateReferenceClock(getTick: tick).rawValue
        case 46: return rtc.enableBypassShadow().rawValue
        case 47: return rtc.disableBypassShadow().rawValue
        case 48: return rtc.incrementMonotonicCounter(instance: a).rawValue
        case 49: var value = get(12,0); let status = rtc.getMonotonicCounter(instance: a, value: &value); set(12,0,value); return status.rawValue
        case 50: return rtc.setSubsecondUnderflowIT().rawValue
        case 51: return rtc.deactivateSubsecondUnderflow().rawValue
        case 52: rtc.subsecondUnderflowIRQHandler(); return 0
        case 53: return rtc.pollForAlarmB(timeout: a, getTick: tick).rawValue
        case 54: return rtc.setTamper(tamper).rawValue
        case 55: return rtc.setTamperIT(tamper).rawValue
        case 56: return rtc.deactivateTamper(a).rawValue
        case 57: return rtc.setActiveTampers(active, getTick: tick).rawValue
        case 58: let seed = (0..<4).map { get(7,4+$0) }; return seed.withUnsafeBufferPointer { rtc.setActiveSeed($0.baseAddress!, getTick: tick).rawValue }
        case 59: return rtc.lockBootHardwareKey().rawValue
        case 60: return rtc.deactivateActiveTampers().rawValue
        case 61: return rtc.pollForTamper(a, timeout: b, getTick: tick).rawValue
        case 62: return rtc.setInternalTamper(internalTamper).rawValue
        case 63: return rtc.setInternalTamperIT(internalTamper).rawValue
        case 64: return rtc.deactivateInternalTamper(a).rawValue
        case 65: return rtc.pollForInternalTamper(a, timeout: b, getTick: tick).rawValue
        case 66: rtc.tamperIRQHandler(); return 0
        case 67: rtc.writeBackup(a, value: b); return 0
        case 68: return rtc.readBackup(a)
        case 69: rtc.eraseBackup(); return 0
        case 70: rtc.blockBackup(); return 0
        case 71: rtc.unblockBackup(); return 0
        case 72: rtc.configureEraseDeviceSecrets(a); return 0
        case 73: return rtc.setPrivilegeMode(privilege).rawValue
        case 74: var value = privilege; let status = rtc.getPrivilegeMode(&value); privilege = value; return status.rawValue
        case 75: rtc.resetHandleState(); return 0
        case 76: rtc.disableWriteProtection(); return 0
        case 77: rtc.enableWriteProtection(); return 0
        case 78: rtc.addDaylightSavingHour(storeOperation: a); return 0
        case 79: rtc.subtractDaylightSavingHour(storeOperation: a); return 0
        case 80: return rtc.getFlag(a) ? 1 : 0
        case 81: rtc.clearFlags(a); return 0
        case 82: return rtc.isCalendarInitialized() ? 1 : 0
        case 83: return rtc.getBinaryMode()
        case 84: rtc.enableAlarmInterrupt(a); return 0
        case 85: rtc.disableAlarmInterrupt(a); return 0
        case 86: return rtc.getAlarmInterrupt(a) ? 1 : 0
        case 87: return rtc.getAlarmInterruptSource(a) ? 1 : 0
        case 88: return rtc.getAlarmFlag(a) ? 1 : 0
        case 89: rtc.clearAlarmFlag(a); return 0
        case 90: return rtc.getWakeUpFlag(a) ? 1 : 0
        case 91: return rtc.getTimestampFlag(a) ? 1 : 0
        case 92: rtc.clearTimestampFlag(a); return 0
        case 93: rtc.enableAlarmA(); return 0
        case 94: rtc.disableAlarmA(); return 0
        case 95: rtc.enableAlarmB(); return 0
        case 96: rtc.disableAlarmB(); return 0
        case 97: rtc.enableWakeUpTimer(); return 0
        case 98: rtc.disableWakeUpTimer(); return 0
        case 99: rtc.enableWakeUpInterrupt(); return 0
        case 100: rtc.disableWakeUpInterrupt(); return 0
        case 101: rtc.enableTimestamp(); return 0
        case 102: rtc.disableTimestamp(); return 0
        case 103: rtc.enableTimestampInterrupt(); return 0
        case 104: rtc.disableTimestampInterrupt(); return 0
        case 105: rtc.enableInternalTimestamp(); return 0
        case 106: rtc.disableInternalTimestamp(); return 0
        case 107: rtc.enableTamperTimestamp(); return 0
        case 108: rtc.disableTamperTimestamp(); return 0
        case 109: rtc.enableTamperDetectionOutput(); return 0
        case 110: rtc.disableTamperDetectionOutput(); return 0
        case 111: rtc.enableCalibrationOutput(); return 0
        case 112: rtc.disableCalibrationOutput(); return 0
        case 113: rtc.enableReferenceClockDetection(); return 0
        case 114: rtc.disableReferenceClockDetection(); return 0
        case 115: rtc.enableSubsecondUnderflowInterrupt(); return 0
        case 116: rtc.disableSubsecondUnderflowInterrupt(); return 0
        case 117: return rtc.getWakeUpInterrupt() ? 1 : 0
        case 118: return rtc.getWakeUpInterruptSource() ? 1 : 0
        case 119: return rtc.getTimestampInterrupt() ? 1 : 0
        case 120: return rtc.getTimestampInterruptSource() ? 1 : 0
        case 121: return rtc.getSubsecondUnderflowInterrupt() ? 1 : 0
        case 122: return rtc.getSubsecondUnderflowInterruptSource() ? 1 : 0
        case 123: rtc.clearWakeUpFlag(); return 0
        case 124: rtc.clearInternalTimestampFlag(); return 0
        case 125: rtc.clearSubsecondUnderflowFlag(); return 0
        case 126: return rtc.getInternalTimestampFlag() ? 1 : 0
        case 127: return rtc.getSubsecondUnderflowFlag() ? 1 : 0
        case 128: return rtc.getShiftFlag() ? 1 : 0
        case 129: rtc.enableTamper(a); return 0
        case 130: rtc.disableTamper(a); return 0
        case 131: rtc.enableTamperInterrupt(a); return 0
        case 132: rtc.disableTamperInterrupt(a); return 0
        case 133: return rtc.getTamperFlag(a) ? 1 : 0
        case 134: return rtc.getTamperInterrupt(a) ? 1 : 0
        case 135: return rtc.getTamperInterruptSource(a) ? 1 : 0
        case 136: rtc.clearTamperFlags(a); return 0
        default: fatalError("Unknown RTC operation")
        }
    }
}
