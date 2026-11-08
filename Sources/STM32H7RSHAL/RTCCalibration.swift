// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


extension RTC {
    @discardableResult
    public func setSmoothCalibration(period: UInt32, plusPulses: UInt32, minusPulses: UInt32, getTick: () -> UInt32) -> HALStatus {
        precondition(period == 0 || period == 0x4000 || period == 0x2000)
        precondition((plusPulses == 0 || plusPulses == 0x8000) && minusPulses <= 0x1FF)
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        guard waitForPendingClear(0x10000, getTick: getTick) == .ok else { unlock(); return .timeout }
        disableWriteProtection()
        modify(.calr, clear: 0x8000 | 0x4000 | 0x2000 | 0x1FF,
               set: period | plusPulses | minusPulses)
        enableWriteProtection()
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    func waitForPendingClear(_ mask: UInt32, getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        while registers.read(.icsr) & mask != 0 {
            if getTick() &- start > 0x3E8 {
                if registers.read(.icsr) & mask != 0 {
                    handle.write(.state, value: RTCState.timeout.rawValue)
                    return .timeout
                } else { break }
            }
        }
        return .ok
    }
    @discardableResult
    public func setLowPowerCalibration(_ value: UInt32) -> HALStatus {
        precondition(value == 0 || value == 0x1000)
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        disableWriteProtection()
        modify(.calr, clear: 0x1000, set: value)
        enableWriteProtection()
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func setSynchronizationShift(addSecond: UInt32, subtractFraction: UInt32, getTick: () -> UInt32) -> HALStatus {
        precondition((addSecond == 0 || addSecond == 0x80000000) && subtractFraction <= 0x7FFF)
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        guard waitForPendingClear(0x8, getTick: getTick) == .ok else { unlock(); return .timeout }
        disableWriteProtection()
        if registers.read(.cr) & 0x10 == 0 {
            // The C mask clears SUBFS only; an existing ADD1S bit is retained.
            modify(.shiftr, clear: 0x7FFF, set: subtractFraction | addSecond)
            if registers.read(.cr) & 0x20 == 0 {
                if waitForSynchronization(getTick: getTick) != .ok {
                    enableWriteProtection(); handle.write(.state, value: RTCState.error.rawValue)
                    unlock(); return .error
                }
            }
        } else {
            enableWriteProtection(); handle.write(.state, value: RTCState.error.rawValue)
            unlock(); return .error
        }
        enableWriteProtection()
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func setCalibrationOutput(_ value: UInt32) -> HALStatus {
        precondition(value == 0 || value == 0x80000)
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        modify(.cr, clear: 0x80000, set: value)
        modify(.cr, set: 0x800000)
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func deactivateCalibrationOutput() -> HALStatus { changeControl(clear: 0x800000) }
    @discardableResult
    public func setReferenceClock(getTick: () -> UInt32) -> HALStatus { changeReferenceClock(enabled: true, getTick: getTick) }
    @discardableResult
    public func deactivateReferenceClock(getTick: () -> UInt32) -> HALStatus { changeReferenceClock(enabled: false, getTick: getTick) }
    private func changeReferenceClock(enabled: Bool, getTick: () -> UInt32) -> HALStatus {
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        disableWriteProtection()
        var status = enterInitialization(getTick: getTick)
        if status == .ok {
            if enabled { modify(.cr, set: 0x10) } else { modify(.cr, clear: 0x10) }
            status = exitInitialization(getTick: getTick)
        }
        enableWriteProtection()
        if status == .ok { handle.write(.state, value: RTCState.ready.rawValue) }
        unlock(); return status
    }
    @discardableResult
    public func enableBypassShadow() -> HALStatus { changeControl(set: 0x20) }
    @discardableResult
    public func disableBypassShadow() -> HALStatus { changeControl(clear: 0x20) }
}
