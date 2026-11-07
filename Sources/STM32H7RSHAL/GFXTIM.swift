// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// GFXTIM operations from stm32h7rsxx_hal_gfxtim.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension GFXTIM {
    @discardableResult
    public func initialize() -> HALStatus {
        precondition(GFXTIMSynchronizationSource(rawValue: handle.read(.synchronizationSource)) != nil)
        precondition(GFXTIMTearingEffectSource(rawValue: handle.read(.tearingEffectSource)) != nil)
        precondition(GFXTIMTearingEffectPolarity(rawValue: handle.read(.tearingEffectPolarity)) != nil)
        precondition(handle.read(.tearingEffectInterrupt) <= 1)
        if handle.read(.state) != 0 { return .error }
        if useRegisteredCallbacks {
            for raw in UInt32(1)...15 {
                let id = GFXTIMCallbackID(rawValue: raw)!
                callbacks.write(id, value: defaults.callback(id))
            }
            if callbacks.read(.mspInitialize) == nil { callbacks.write(.mspInitialize, value: defaults.mspInitialize) }
        }
        invoke(.mspInitialize)
        modify(.cr, clear: 0x313, set: handle.read(.synchronizationSource) |
               handle.read(.tearingEffectSource) | handle.read(.tearingEffectPolarity))
        modify(.ier, clear: 4, set: handle.read(.tearingEffectInterrupt) << 2)
        handle.write(.errorCode, value: 0)
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        if handle.read(.state) != 1 { return .error }
        if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
            callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        }
        invoke(.mspDeinitialize)
        handle.write(.state, value: 0)
        return .ok
    }
    @discardableResult
    public func configureClockGenerator(_ configuration: GFXTIMClockGeneratorConfiguration?) -> HALStatus {
        guard let c = configuration else { return .error }
        precondition(GFXTIMLineCounterReloadSource(rawValue: c.lineCounterHardwareReloadSource) != nil)
        precondition(c.lineCounterReloadValue <= 0x3F_FFFF && c.frameCounterReloadValue <= 0xFFF)
        precondition(GFXTIMLineCounterClock(rawValue: c.lineCounterClockSource) != nil)
        precondition(GFXTIMLineClockSource(rawValue: c.lineClockSource) != nil)
        precondition(GFXTIMFrameCounterReloadSource(rawValue: c.frameCounterHardwareReloadSource) != nil)
        precondition(GFXTIMFrameCounterClock(rawValue: c.frameCounterClockSource) != nil)
        precondition(GFXTIMFrameClockSource(rawValue: c.frameClockSource) != nil)
        precondition(c.lineClockCalibration == 0 || c.lineClockCalibration == 0x20000)
        precondition(c.frameClockCalibration == 0 || c.frameClockCalibration == 0x10000)
        if handle.read(.state) != 1 { return .error }
        modify(.cgcr, clear: 0x0070_0010)
        modify(.lccrr, clear: 0x3F_FFFF, set: c.lineCounterReloadValue)
        modify(.fccrr, clear: 0xFFF, set: c.frameCounterReloadValue)
        modify(.cgcr, clear: 0x7077_7017, set: c.lineCounterHardwareReloadSource | c.lineCounterClockSource |
               c.lineClockSource | c.frameCounterHardwareReloadSource | c.frameCounterClockSource | c.frameClockSource)
        modify(.cr, clear: 0x30000, set: c.lineClockCalibration | c.frameClockCalibration)
        return .ok
    }
    @discardableResult
    public func reloadClockGenerator(_ counters: UInt32) -> HALStatus {
        precondition(counters == 0x100 || counters == 0x0100_0000 || counters == 0x0100_0100)
        if handle.read(.state) != 1 { return .error }
        modify(.cgcr, set: counters)
        return .ok
    }
    @discardableResult
    public func configureAbsoluteTimer(_ configuration: GFXTIMAbsoluteTimerConfiguration?) -> HALStatus {
        guard let c = configuration else { return .error }
        precondition(c.frameCompare1 <= 0xFFFFF && c.frameCounter <= 0xFFFFF)
        precondition(c.lineCompare1 <= 0xFFF && c.lineCompare2 <= 0xFFF && c.lineCounter <= 0xFFF)
        precondition(c.frameOverflowInterrupt <= 1 && c.frameCompare1Interrupt <= 1 &&
                     c.lineOverflowInterrupt <= 1 && c.lineCompare1Interrupt <= 1 && c.lineCompare2Interrupt <= 1)
        if handle.read(.state) != 1 { return .error }
        modify(.afcc1r, clear: 0xFFFFF, set: c.frameCompare1)
        modify(.afcr, clear: 0xFFFFF, set: c.frameCounter)
        modify(.alcc1r, clear: 0xFFF, set: c.lineCompare1)
        modify(.alcc2r, clear: 0xFFF, set: c.lineCompare2)
        modify(.alcr, clear: 0xFFF, set: c.lineCounter)
        modify(.ier, clear: 0x313, set: c.frameOverflowInterrupt | (c.frameCompare1Interrupt << 4) |
               (c.lineOverflowInterrupt << 1) | (c.lineCompare1Interrupt << 8) | (c.lineCompare2Interrupt << 9))
        return .ok
    }
    @discardableResult public func startAbsoluteTimer() -> HALStatus { readySet(.tcr, 0x11) }
    @discardableResult public func stopAbsoluteTimer() -> HALStatus { readySet(.tdr, 0x11) }
    @discardableResult public func resetAbsoluteTimer() -> HALStatus { readySet(.tcr, 0x22) }
    @discardableResult
    public func getAbsoluteCounter(_ time: UInt32, value: UnsafeMutablePointer<UInt32>?) -> HALStatus {
        guard let value else { return .error }
        precondition(GFXTIMAbsoluteTime(rawValue: time) != nil)
        if handle.read(.state) != 1 { return .error }
        switch time {
        case 0x14: value.pointee = registers.read(.atr)
        case 0x15: value.pointee = registers.read(.afcr)
        default: value.pointee = registers.read(.alcr)
        }
        return .ok
    }
    @discardableResult
    public func setAbsoluteFrameCompare(_ value: UInt32) -> HALStatus {
        if handle.read(.state) != 1 { return .error }
        // C has no value assertion here and does not mask the new value.
        modify(.afcc1r, clear: 0xFFFFF, set: value)
        return .ok
    }
    @discardableResult
    public func setAbsoluteLineCompare(_ comparator: UInt32, value: UInt32) -> HALStatus {
        precondition(GFXTIMAbsoluteLineComparator(rawValue: comparator) != nil && value <= 0xFFF)
        if handle.read(.state) != 1 { return .error }
        registers.write(comparator == 0x1C ? .alcc1r : .alcc2r, value: value)
        return .ok
    }
    @discardableResult
    public func configureRelativeTimer(_ timer: UInt32, configuration: GFXTIMRelativeTimerConfiguration?) -> HALStatus {
        guard let c = configuration else { return .error }
        // The pinned C checks CounterMode with IS_GFXTIM_RELATIVE_FRAME_VALUE.
        precondition(c.autoReloadValue <= 0xFFF && c.counterMode <= 0xFFF && c.reloadInterrupt <= 1 && timer <= 1)
        if handle.read(.state) != 1 { return .error }
        if timer == 0 {
            modify(.rfc1rr, clear: 0xFFF, set: c.autoReloadValue)
            modify(.tcr, clear: 0x20000, set: c.counterMode << 17)
            modify(.ier, clear: 0x1000, set: c.reloadInterrupt << 12)
        } else {
            modify(.rfc2rr, clear: 0xFFF, set: c.autoReloadValue)
            modify(.tcr, clear: 0x200000, set: c.counterMode << 21)
            modify(.ier, clear: 0x2000, set: c.reloadInterrupt << 13)
        }
        return .ok
    }
    @discardableResult
    public func startRelativeTimer(_ timer: UInt32) -> HALStatus {
        precondition(timer <= 1)
        return readySet(.tcr, timer == 0 ? 0x10000 : 0x100000)
    }
    @discardableResult
    public func stopRelativeTimer(_ timer: UInt32) -> HALStatus {
        precondition(timer <= 1)
        return readySet(.tdr, timer == 0 ? 0x10000 : 0x100000)
    }
    @discardableResult
    public func forceRelativeTimerReload(_ timer: UInt32) -> HALStatus {
        precondition(timer <= 1)
        return readySet(.tcr, timer == 0 ? 0x40000 : 0x400000)
    }
    @discardableResult
    public func setRelativeTimerReload(_ timer: UInt32, value: UInt32) -> HALStatus {
        precondition(value <= 0xFFF && timer <= 1)
        if handle.read(.state) != 1 { return .error }
        registers.write(timer == 0 ? .rfc1rr : .rfc2rr, value: value)
        return .ok
    }
    @discardableResult
    public func getRelativeCounter(_ timer: UInt32, value: UnsafeMutablePointer<UInt32>?) -> HALStatus {
        guard let value else { return .error }
        precondition(timer <= 1)
        if handle.read(.state) != 1 { return .error }
        value.pointee = registers.read(timer == 0 ? .rfc1r : .rfc2r)
        return .ok
    }
    @discardableResult
    public func configureEventGenerator(_ generator: UInt32, configuration: GFXTIMEventGeneratorConfiguration?) -> HALStatus {
        guard let c = configuration else { return .error }
        precondition(generator <= 3 && GFXTIMLineEvent(rawValue: c.lineEvent) != nil &&
                     GFXTIMFrameEvent(rawValue: c.frameEvent) != nil && c.eventInterrupt <= 1)
        if handle.read(.state) != 1 { return .error }
        let shift = generator &* 8
        modify(.evsr, clear: 0x77 << shift, set: (c.lineEvent | c.frameEvent) << shift)
        modify(.ier, clear: 0x10000 << generator, set: c.eventInterrupt << (generator &+ 16))
        return .ok
    }
    @discardableResult
    public func enableEventGenerator(_ generator: UInt32) -> HALStatus {
        precondition(generator <= 3)
        return readySet(.evcr, 1 << generator)
    }
    @discardableResult
    public func disableEventGenerator(_ generator: UInt32) -> HALStatus {
        precondition(generator <= 3)
        if handle.read(.state) != 1 { return .error }
        modify(.evcr, clear: 1 << generator)
        return .ok
    }
    @discardableResult
    public func configureWatchdog(_ configuration: GFXTIMWatchdogConfiguration?) -> HALStatus {
        guard let c = configuration else { return .error }
        precondition(GFXTIMWatchdogClock(rawValue: c.clockSource) != nil &&
                     GFXTIMWatchdogHardwareReload(rawValue: c.hardwareReload) != nil)
        precondition(c.autoReloadValue <= 0xFFFF && c.preAlarmValue <= 0xFFFF &&
                     c.alarmInterrupt <= 1 && c.preAlarmInterrupt <= 1)
        if handle.read(.state) != 1 { return .error }
        modify(.wdgrr, clear: 0xFFFF, set: c.autoReloadValue)
        modify(.wdgpar, clear: 0xFFFF, set: c.preAlarmValue)
        modify(.wdgtcr, clear: 0xF30, set: c.clockSource | c.hardwareReload)
        modify(.ier, clear: 0x0300_0000, set: (c.alarmInterrupt << 24) | (c.preAlarmInterrupt << 25))
        return .ok
    }
    @discardableResult public func enableWatchdog() -> HALStatus { readySet(.wdgtcr, 1) }
    @discardableResult public func disableWatchdog() -> HALStatus { readySet(.wdgtcr, 2) }
    @discardableResult public func refreshWatchdog() -> HALStatus { readySet(.wdgtcr, 0x10000) }
    public func handleInterrupt() {
        let status = registers.read(.isr)
        let enabled = registers.read(.ier)
        let interrupts = status & enabled
        // C snapshots ISR/IER once, calls hooks in this order, then clears the
        // original mask, including bits without callbacks and the zero case.
        if interrupts & 0x10 != 0 { invoke(.absoluteFrameCompare1) }
        if interrupts & 1 != 0 { invoke(.absoluteFrameOverflow) }
        if interrupts & 0x100 != 0 { invoke(.absoluteLineCompare1) }
        if interrupts & 0x200 != 0 { invoke(.absoluteLineCompare2) }
        if interrupts & 2 != 0 { invoke(.absoluteLineOverflow) }
        if interrupts & 4 != 0 { invoke(.tearingEffect) }
        if interrupts & 0x1000 != 0 { invoke(.relativeFrame1Reload) }
        if interrupts & 0x2000 != 0 { invoke(.relativeFrame2Reload) }
        if interrupts & 0x10000 != 0 { invoke(.event1) }
        if interrupts & 0x20000 != 0 { invoke(.event2) }
        if interrupts & 0x40000 != 0 { invoke(.event3) }
        if interrupts & 0x80000 != 0 { invoke(.event4) }
        if interrupts & 0x0100_0000 != 0 { invoke(.watchdogAlarm) }
        if interrupts & 0x0200_0000 != 0 { invoke(.watchdogPreAlarm) }
        registers.write(.icr, value: interrupts)
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.isr) & flag == flag ? 1 : 0 }
    public func getFlag(_ flag: GFXTIMFlags) -> UInt32 { getFlag(flag.rawValue) }
    public func clearFlag(_ flag: UInt32) { registers.write(.icr, value: flag) }
    public func clearFlag(_ flag: GFXTIMFlags) { clearFlag(flag.rawValue) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks {
            callbacks.write(.mspInitialize, value: nil)
            callbacks.write(.mspDeinitialize, value: nil)
        }
    }
    @discardableResult
    public func registerCallback(id: UInt32, callback: GFXTIMCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { return invalidCallback() }
        return updateCallback(id: id, callback: callback, useDefault: false)
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        return updateCallback(id: id, callback: nil, useDefault: true)
    }
    @discardableResult
    public func registerCallback(id: GFXTIMCallbackID, callback: GFXTIMCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }
    @discardableResult
    public func unregisterCallback(id: GFXTIMCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    private func updateCallback(id: UInt32, callback: GFXTIMCallback?, useDefault: Bool) -> HALStatus {
        let valid: Bool
        if handle.read(.state) == 1 { valid = id >= 1 && id <= 17 }
        else if handle.read(.state) == 0 { valid = id == 16 || id == 17 }
        else { valid = false }
        guard valid, let id = GFXTIMCallbackID(rawValue: id) else { return invalidCallback() }
        callbacks.write(id, value: useDefault ? defaults.callback(id) : callback)
        return .ok
    }
    private func invalidCallback() -> HALStatus {
        handle.write(.errorCode, value: handle.read(.errorCode) | 2)
        return .error
    }
    private func invoke(_ id: GFXTIMCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    private func modify(_ register: GFXTIMRegister, clear: UInt32 = 0, set: UInt32 = 0) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
    private func readySet(_ register: GFXTIMRegister, _ value: UInt32) -> HALStatus {
        if handle.read(.state) != 1 { return .error }
        modify(register, set: value)
        return .ok
    }
}
