// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension RTC {
    @discardableResult
    public func initialize(getTick: () -> UInt32) -> HALStatus {
        precondition(handle.read(.hourFormat) == 0 || handle.read(.hourFormat) == 0x40)
        precondition(handle.read(.asynchronousPrescaler) <= 0x7F && handle.read(.synchronousPrescaler) <= 0x7FFF)
        precondition(handle.read(.output) & ~UInt32(0x600000) == 0 || handle.read(.output) == 0x4000000)
        precondition(handle.read(.outputPolarity) == 0 || handle.read(.outputPolarity) == 0x100000)
        precondition(handle.read(.outputType) == 0 || handle.read(.outputType) == 0x40000000)
        precondition(handle.read(.outputPullUp) == 0 || handle.read(.outputPullUp) == 0x20000000)
        precondition(handle.read(.outputRemap) == 0 || handle.read(.outputRemap) == 0x80000000)
        precondition(RTCBinaryMode(rawValue: handle.read(.binaryMode)) != nil)
        precondition(handle.read(.binaryMixUpdate) & ~UInt32(0x1C00) == 0)
        var status: HALStatus = .error
        if handle.read(.state) == 0 {
            unlock()
            if useRegisteredCallbacks {
                for id in RTCCallbackID.allCases where id.rawValue < 24 { callbacks.write(id, value: defaults.callback(id)) }
                if callbacks.read(.mspInitialize) == nil { callbacks.write(.mspInitialize, value: defaults.mspInitialize) }
                invoke(.mspInitialize)
                if callbacks.read(.mspDeinitialize) == nil { callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize) }
            } else { invoke(.mspInitialize) }
        }
        handle.write(.state, value: 2)
        if registers.read(.icsr) & 0x10 == 0 {
            if registers.read(.icsr) & 0x300 != 0x100 {
                disableWriteProtection(); status = enterInitialization(getTick: getTick)
                if status == .ok {
                    modify(.cr, clear: 0x04700040)
                    modify(.cr, set: handle.read(.hourFormat) | handle.read(.output) | handle.read(.outputPolarity))
                    registers.write(.prer, value: handle.read(.synchronousPrescaler) | (handle.read(.asynchronousPrescaler) << 16))
                    modify(.icsr, clear: 0x1F00, set: handle.read(.binaryMode) | handle.read(.binaryMixUpdate))
                    status = exitInitialization(getTick: getTick)
                    if status == .ok { modify(.cr, clear: 0xE0000000, set: handle.read(.outputPullUp) | handle.read(.outputType) | handle.read(.outputRemap)) }
                }
                enableWriteProtection()
            } else { status = .ok }
        } else { status = .ok }
        if status == .ok { handle.write(.state, value: 1) }
        return status
    }
    @discardableResult
    public func deinitialize(getTick: () -> UInt32) -> HALStatus {
        handle.write(.state, value: 2); disableWriteProtection()
        var status = enterInitialization(getTick: getTick)
        if status == .ok {
            registers.write(.cr, value: 0); registers.write(.dr, value: 0x2101); registers.write(.tr, value: 0)
            registers.write(.prer, value: 0x7F00FF); registers.write(.alrmar, value: 0); registers.write(.alrmbr, value: 0)
            registers.write(.shiftr, value: 0); registers.write(.calr, value: 0)
            registers.write(.alrmassr, value: 0); registers.write(.alrmbssr, value: 0)
            modify(.icsr, clear: 0x1F00); registers.write(.scr, value: 0x3F); registers.write(.privcfgr, value: 0)
            status = exitInitialization(getTick: getTick); enableWriteProtection()
        }
        if status == .ok {
            let start = getTick()
            while registers.readInstanceInitializationStatus() & 4 == 0 && status != .timeout {
                if getTick() &- start > 1000 {
                    if registers.read(.icsr) & 4 == 0 { handle.write(.state, value: 3); status = .timeout }
                    else { break }
                }
            }
            registers.write(.cr, value: 0); registers.write(.wutr, value: 0xFFFF)
            registers.writeTamper(.cr1, value: 0); registers.writeTamper(.cr2, value: 0); registers.writeTamper(.cr3, value: 0)
            registers.writeTamper(.fltcr, value: 0); registers.writeTamper(.atcr1, value: 0xF0000); registers.writeTamper(.ator, value: 0)
            registers.writeTamper(.atcr2, value: 0); registers.writeTamper(.privcfgr, value: 0)
            if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil { callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize) }
            invoke(.mspDeinitialize); handle.write(.state, value: 0); unlock()
        }
        return status
    }
    @discardableResult
    public func waitForSynchronization(getTick: () -> UInt32) -> HALStatus {
        modify(.icsr, clear: 0x20); let start = getTick()
        while registers.read(.icsr) & 0x20 == 0 {
            if getTick() &- start > 1000 {
                if registers.read(.icsr) & 0x20 == 0 { handle.write(.state, value: 3); return .timeout }
                else { break }
            }
        }
        return .ok
    }
    @discardableResult
    public func enterInitialization(getTick: () -> UInt32) -> HALStatus {
        var status: HALStatus = .ok
        if registers.read(.icsr) & 0x40 == 0 {
            modify(.icsr, set: 0x80); let start = getTick()
            while registers.read(.icsr) & 0x40 == 0 && status != .timeout {
                if getTick() &- start > 1000 {
                    if registers.read(.icsr) & 0x40 == 0 { status = .timeout; handle.write(.state, value: 3) }
                    else { break }
                }
            }
        }
        return status
    }
    @discardableResult
    public func exitInitialization(getTick: () -> UInt32) -> HALStatus {
        var status: HALStatus = .ok
        modify(.icsr, clear: 0x80)
        if registers.read(.cr) & 0x20 == 0 {
            if waitForSynchronization(getTick: getTick) != .ok { handle.write(.state, value: 3); status = .timeout }
        } else {
            modify(.cr, clear: 0x20)
            if waitForSynchronization(getTick: getTick) != .ok { handle.write(.state, value: 3); status = .timeout }
            modify(.cr, set: 0x20)
        }
        return status
    }
}
