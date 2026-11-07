import STM32H7RSHAL
import CGFXTIMReference

func gfxtimCallback(_ id: UInt32, _ token: UInt32) -> GFXTIMCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (1, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 1, 1) }
    case (1, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 1, 2) }
    case (2, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 2, 1) }
    case (2, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 2, 2) }
    case (3, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 3, 1) }
    case (3, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 3, 2) }
    case (4, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 4, 1) }
    case (4, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 4, 2) }
    case (5, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 5, 1) }
    case (5, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 5, 2) }
    case (6, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 6, 1) }
    case (6, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 6, 2) }
    case (7, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 7, 1) }
    case (7, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 7, 2) }
    case (8, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 8, 1) }
    case (8, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 8, 2) }
    case (9, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 9, 1) }
    case (9, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 9, 2) }
    case (10, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 10, 1) }
    case (10, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 10, 2) }
    case (11, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 11, 1) }
    case (11, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 11, 2) }
    case (12, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 12, 1) }
    case (12, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 12, 2) }
    case (13, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 13, 1) }
    case (13, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 13, 2) }
    case (14, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 14, 1) }
    case (14, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 14, 2) }
    case (15, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 15, 1) }
    case (15, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 15, 2) }
    case (16, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 16, 1) }
    case (16, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 16, 2) }
    case (17, 1): return { CGFXTIM_Callback(OpaquePointer($0!), 17, 1) }
    case (17, 2): return { CGFXTIM_Callback(OpaquePointer($0!), 17, 2) }
    default: preconditionFailure("Invalid GFXTIM callback")
    }
}

struct GFXTIMReferenceIO: GFXTIMRegisterIO, GFXTIMHandleIO, GFXTIMCallbackIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func read(_ register: GFXTIMRegister) -> UInt32 { CGFXTIM_Read(state, register.rawValue) }
    func write(_ register: GFXTIMRegister, value: UInt32) { CGFXTIM_Write(state, register.rawValue, value) }
    func read(_ word: GFXTIMHandleWord) -> UInt32 { CGFXTIM_Get(state, 1, UInt32(word.rawValue)) }
    func write(_ word: GFXTIMHandleWord, value: UInt32) { CGFXTIM_Set(state, 1, UInt32(word.rawValue), value) }
    func read(_ id: GFXTIMCallbackID) -> GFXTIMCallback? {
        gfxtimCallback(id.rawValue, CGFXTIM_GetCallback(state, id.rawValue))
    }
    func write(_ id: GFXTIMCallbackID, value: GFXTIMCallback?) {
        let token: UInt32 = value.map {
            unsafeBitCast($0, to: UInt.self) == unsafeBitCast(gfxtimCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2
        } ?? 0
        CGFXTIM_SetCallback(state, id.rawValue, token)
    }
    var timer: GFXTIM<Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self,
              defaults: .init(
                absoluteFrameCompare1: gfxtimCallback(1, 1)!,
                absoluteFrameOverflow: gfxtimCallback(2, 1)!,
                absoluteLineCompare1: gfxtimCallback(3, 1)!,
                absoluteLineCompare2: gfxtimCallback(4, 1)!,
                absoluteLineOverflow: gfxtimCallback(5, 1)!,
                relativeFrame1Reload: gfxtimCallback(6, 1)!,
                relativeFrame2Reload: gfxtimCallback(7, 1)!,
                tearingEffect: gfxtimCallback(8, 1)!,
                event1: gfxtimCallback(9, 1)!,
                event2: gfxtimCallback(10, 1)!,
                event3: gfxtimCallback(11, 1)!,
                event4: gfxtimCallback(12, 1)!,
                watchdogAlarm: gfxtimCallback(13, 1)!,
                watchdogPreAlarm: gfxtimCallback(14, 1)!,
                error: gfxtimCallback(15, 1)!,
                mspInitialize: gfxtimCallback(16, 1)!,
                mspDeinitialize: gfxtimCallback(17, 1)!), useRegisteredCallbacks: mode != 0)
    }
    func configuration(_ index: UInt32) -> UInt32 { CGFXTIM_Get(state, 2, index) }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ nulls: UInt32) -> UInt32 {
        if nulls & 1 != 0 && (op <= 23 || op == 30 || op == 31) { return 1 }
        let c = configuration
        switch op {
        case 0: return timer.initialize().rawValue
        case 1: return timer.deinitialize().rawValue
        case 2: return timer.configureClockGenerator(nulls & 2 != 0 ? nil : .init(
            lineCounterHardwareReloadSource: c(0), lineCounterReloadValue: c(1), lineCounterClockSource: c(2),
            lineClockSource: c(3), frameCounterHardwareReloadSource: c(4), frameCounterReloadValue: c(5),
            frameCounterClockSource: c(6), frameClockSource: c(7), lineClockCalibration: c(8), frameClockCalibration: c(9))).rawValue
        case 3: return timer.reloadClockGenerator(a).rawValue
        case 4: return timer.configureAbsoluteTimer(nulls & 2 != 0 ? nil : .init(
            frameCompare1: c(0), frameCounter: c(1), frameOverflowInterrupt: c(2), frameCompare1Interrupt: c(3),
            lineCompare1: c(4), lineCompare2: c(5), lineCounter: c(6), lineOverflowInterrupt: c(7),
            lineCompare1Interrupt: c(8), lineCompare2Interrupt: c(9))).rawValue
        case 5: return timer.startAbsoluteTimer().rawValue
        case 6: return timer.stopAbsoluteTimer().rawValue
        case 7: return timer.resetAbsoluteTimer().rawValue
        case 8: return timer.getAbsoluteCounter(a, value: CGFXTIM_Output(state, b)).rawValue
        case 9: return timer.setAbsoluteFrameCompare(a).rawValue
        case 10: return timer.setAbsoluteLineCompare(a, value: b).rawValue
        case 11: return timer.configureRelativeTimer(a, configuration: nulls & 2 != 0 ? nil : .init(
            autoReloadValue: c(0), counterMode: c(1), reloadInterrupt: c(2))).rawValue
        case 12: return timer.startRelativeTimer(a).rawValue
        case 13: return timer.stopRelativeTimer(a).rawValue
        case 14: return timer.forceRelativeTimerReload(a).rawValue
        case 15: return timer.setRelativeTimerReload(a, value: b).rawValue
        case 16: return timer.getRelativeCounter(a, value: CGFXTIM_Output(state, b)).rawValue
        case 17: return timer.configureEventGenerator(a, configuration: nulls & 2 != 0 ? nil : .init(
            lineEvent: c(0), frameEvent: c(1), eventInterrupt: c(2))).rawValue
        case 18: return timer.enableEventGenerator(a).rawValue
        case 19: return timer.disableEventGenerator(a).rawValue
        case 20: return timer.configureWatchdog(nulls & 2 != 0 ? nil : .init(
            clockSource: c(0), autoReloadValue: c(1), hardwareReload: c(2), preAlarmValue: c(3),
            alarmInterrupt: c(4), preAlarmInterrupt: c(5))).rawValue
        case 21: return timer.enableWatchdog().rawValue
        case 22: return timer.disableWatchdog().rawValue
        case 23: return timer.refreshWatchdog().rawValue
        case 24: timer.handleInterrupt()
        case 25: return timer.getState()
        case 26: return timer.getError()
        case 27: timer.resetHandleState()
        case 28: return timer.getFlag(a)
        case 29: timer.clearFlag(a)
        case 30: return timer.registerCallback(id: a, callback: gfxtimCallback((1...17).contains(a) ? a : 1, b)).rawValue
        case 31: return timer.unregisterCallback(id: a).rawValue
        default: preconditionFailure("Invalid GFXTIM operation")
        }
        return 0
    }
}
