// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PSSI operations and definitions from stm32h7rsxx_hal_pssi.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PSSI {
    @discardableResult
    public func transmit(_ data: UnsafeRawPointer?, count: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        if (handle.read(.dataWidth) == 0 && handle.read(.busWidth) != 0)
            || (handle.read(.dataWidth) == 1 && count % 2 != 0)
            || (handle.read(.dataWidth) == 2 && count % 4 != 0) {
            handle.write(.errorCode, value: 1); return .error
        }
        guard handle.read(.state) == 1 else { return .busy }
        guard lock() else { return .busy }
        handle.write(.state, value: 2); handle.write(.errorCode, value: 0); disable()
        modify(.cr, clear: 0x80000020, set: 0x80000000 | (handle.read(.clockPolarity) == 1 ? 0 : 0x20))
        if dmaModuleEnabled { modify(.cr, clear: 0x40000000) }
        enable()
        var remaining = count
        var buffer = data
        if handle.read(.dataWidth) == 0 {
            while remaining > 0 {
                let start = getTick()
                if waitOnStatus(flag: 8, status: 0, timeout: timeout, start: start, getTick: getTick) != .ok {
                    handle.write(.errorCode, value: 0x10); handle.write(.state, value: 1); unlock(); return .error
                }
                registers.writeData8(buffer!.load(as: UInt8.self))
                buffer = buffer!.advanced(by: 1); remaining &-= 1
            }
        }
        else if handle.read(.dataWidth) == 1 {
            while remaining > 0 {
                let start = getTick()
                if waitOnStatus(flag: 4, status: 0, timeout: timeout, start: start, getTick: getTick) != .ok {
                    handle.write(.errorCode, value: 0x10); handle.write(.state, value: 1); unlock(); return .error
                }
                registers.writeData16(buffer!.load(as: UInt16.self))
                buffer = buffer!.advanced(by: 2); remaining &-= 2
            }
        }
        else if handle.read(.dataWidth) == 2 {
            while remaining > 0 {
                let start = getTick()
                if waitOnStatus(flag: 4, status: 0, timeout: timeout, start: start, getTick: getTick) != .ok {
                    handle.write(.errorCode, value: 0x10); handle.write(.state, value: 1); unlock(); return .error
                }
                registers.write(.dr, value: buffer!.load(as: UInt32.self))
                buffer = buffer!.advanced(by: 4); remaining &-= 4
            }
        }
        else { handle.write(.errorCode, value: 1); handle.write(.state, value: 1); unlock(); return .error }
        if getFlag(2) != 0 {
            clearFlag(2)
            disable(); handle.write(.errorCode, value: 2); handle.write(.state, value: 1)
            unlock(); return .error
        }
        handle.write(.state, value: 1); unlock(); return .ok
    }
    @discardableResult
    public func receive(_ data: UnsafeMutableRawPointer?, count: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        if (handle.read(.dataWidth) == 0 && handle.read(.busWidth) != 0)
            || (handle.read(.dataWidth) == 1 && count % 2 != 0)
            || (handle.read(.dataWidth) == 2 && count % 4 != 0) {
            handle.write(.errorCode, value: 1); return .error
        }
        guard handle.read(.state) == 1 else { return .busy }
        guard lock() else { return .busy }
        handle.write(.state, value: 2); handle.write(.errorCode, value: 0); disable()
        modify(.cr, clear: 0x80000020, set: handle.read(.clockPolarity) == 0 ? 0 : 0x20)
        if dmaModuleEnabled { modify(.cr, clear: 0x40000000) }
        enable()
        var remaining = count
        var buffer = data
        if handle.read(.dataWidth) == 0 {
            while remaining > 0 {
                let start = getTick()
                if waitOnStatus(flag: 8, status: 0, timeout: timeout, start: start, getTick: getTick) != .ok {
                    handle.write(.errorCode, value: 0x10); handle.write(.state, value: 1); unlock(); return .error
                }
                buffer!.storeBytes(of: registers.readData8(), as: UInt8.self)
                buffer = buffer!.advanced(by: 1); remaining &-= 1
            }
        }
        else if handle.read(.dataWidth) == 1 {
            while remaining > 0 {
                let start = getTick()
                if waitOnStatus(flag: 4, status: 0, timeout: timeout, start: start, getTick: getTick) != .ok {
                    handle.write(.errorCode, value: 0x10); handle.write(.state, value: 1); unlock(); return .error
                }
                buffer!.storeBytes(of: registers.readData16(), as: UInt16.self)
                buffer = buffer!.advanced(by: 2); remaining &-= 2
            }
        }
        else if handle.read(.dataWidth) == 2 {
            while remaining > 0 {
                let start = getTick()
                if waitOnStatus(flag: 4, status: 0, timeout: timeout, start: start, getTick: getTick) != .ok {
                    handle.write(.errorCode, value: 0x10); handle.write(.state, value: 1); unlock(); return .error
                }
                buffer!.storeBytes(of: registers.read(.dr), as: UInt32.self)
                buffer = buffer!.advanced(by: 4); remaining &-= 4
            }
        }
        else { handle.write(.errorCode, value: 1); handle.write(.state, value: 1); unlock(); return .error }
        if getFlag(2) != 0 {
            clearFlag(2)
            handle.write(.errorCode, value: 4)
            unlock(); return .error
        }
        handle.write(.state, value: 1); unlock(); return .ok
    }
    func waitOnStatus(flag: UInt32, status: UInt32, timeout: UInt32, start: UInt32, getTick: () -> UInt32) -> HALStatus {
        while getStatus(flag) & flag == status {
            if timeout != .max {
                if (getTick() &- start) > timeout || timeout == 0 {
                    addError(0x10); handle.write(.state, value: 1); unlock(); return .error
                }
            }
        }
        return .ok
    }
}
