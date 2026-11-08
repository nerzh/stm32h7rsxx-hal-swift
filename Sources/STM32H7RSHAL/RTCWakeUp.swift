// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


extension RTC {
    @discardableResult
    public func setWakeUpTimer(counter: UInt32, clock: UInt32, getTick: () -> UInt32) -> HALStatus {
        setWakeUpTimer(counter: counter, clock: clock, autoClear: 0, interrupt: false, getTick: getTick)
    }
    @discardableResult
    public func setWakeUpTimerIT(counter: UInt32, clock: UInt32, autoClear: UInt32, getTick: () -> UInt32) -> HALStatus {
        setWakeUpTimer(counter: counter, clock: clock, autoClear: autoClear, interrupt: true, getTick: getTick)
    }
    private func setWakeUpTimer(counter: UInt32, clock: UInt32, autoClear: UInt32, interrupt: Bool, getTick: () -> UInt32) -> HALStatus {
        precondition(clock <= 4 || clock == 6)
        precondition(counter <= 0xFFFF && (!interrupt || autoClear <= counter))
        guard lock() else { return .busy }
        handle.write(.state, value: RTCState.busy.rawValue)
        modify(.cr, clear: 0x400)
        if interrupt { registers.write(.scr, value: 0x4) }
        if registers.read(.icsr) & 0x40 == 0 {
            let start = getTick()
            while registers.read(.icsr) & 0x4 == 0 {
                if getTick() &- start > 0x3E8 {
                    if registers.read(.icsr) & 0x4 == 0 {
                        handle.write(.state, value: RTCState.timeout.rawValue)
                        unlock(); return .timeout
                    } else { break }
                }
            }
        }
        if interrupt {
            registers.write(.wutr, value: counter | autoClear << 0x10)
            modify(.cr, clear: 0x7, set: clock)
            modify(.cr, set: 0x4000 | 0x400)
        } else {
            modify(.cr, clear: 0x7, set: clock)
            registers.write(.wutr, value: counter)
            modify(.cr, set: 0x400)
        }
        handle.write(.state, value: RTCState.ready.rawValue)
        unlock(); return .ok
    }
    @discardableResult
    public func deactivateWakeUpTimer() -> HALStatus { changeControl(clear: 0x400 | 0x4000) }
    public func getWakeUpTimer() -> UInt32 { registers.read(.wutr) & 0xFFFF }
    public func wakeUpIRQHandler() {
        if registers.read(.misr) & 0x4 != 0 {
            registers.write(.scr, value: 0x4); invoke(.wakeUp)
        }
        handle.write(.state, value: RTCState.ready.rawValue)
    }
    public func pollForWakeUpTimer(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        pollEvent(flag: 0x4, clear: 0x4, timeout: timeout, getTick: getTick)
    }
    @discardableResult
    public func setSubsecondUnderflowIT() -> HALStatus { changeControl(set: 0x80) }
    @discardableResult
    public func deactivateSubsecondUnderflow() -> HALStatus { changeControl(clear: 0x80) }
    public func subsecondUnderflowIRQHandler() {
        if registers.read(.misr) & 0x40 != 0 {
            registers.write(.scr, value: 0x40); invoke(.subsecondUnderflow)
        }
        handle.write(.state, value: RTCState.ready.rawValue)
    }
}
