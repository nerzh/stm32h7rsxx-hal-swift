// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PKA operations and definitions from stm32h7rsxx_hal_pka.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PKA {
    @discardableResult
    public func initialize(getTick: () -> UInt32) -> HALStatus {
        var status: HALStatus = .ok
        if handle.read(.state) == PKAState.reset.rawValue {
            if useRegisteredCallbacks {
                callbacks.write(.operationComplete, value: defaults.operationComplete)
                callbacks.write(.error, value: defaults.error)
                if callbacks.read(.mspInitialize) == nil { callbacks.write(.mspInitialize, value: defaults.mspInitialize) }
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: PKAState.busy.rawValue)
        var start = getTick()
        while registers.read(.cr) & 0x1 != 0x1 {
            registers.write(.cr, value: 0x1)
            if getTick() &- start > 1000 { status = .timeout; break }
        }
        start = getTick()
        if waitOnFlagUntilTimeout(flag: 0x1, status: false, tickStart: start, timeout: 5000, getTick: getTick) != .ok { return .timeout }
        modify(.clrfr, set: 0x20000 | 0x80000 | 0x100000 | 0x200000)
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: PKAState.ready.rawValue)
        return status
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        handle.write(.state, value: PKAState.busy.rawValue)
        registers.write(.cr, value: 0)
        modify(.clrfr, set: 0x20000 | 0x80000 | 0x100000 | 0x200000)
        if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil { callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize) }
        invoke(.mspDeinitialize)
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: PKAState.reset.rawValue)
        return .ok
    }
    public func deinitializeMSP<System: PKASystemIO>(system: System, getTick: () -> UInt32) {
        var start = getTick()
        system.forceReset(); system.releaseReset()
        while registers.read(.cr) != 0x1 {
            registers.write(.cr, value: 0x1)
            if getTick() &- start > 1000 { handle.write(.state, value: PKAState.error.rawValue) }
        }
        start = getTick()
        if waitOnFlagUntilTimeout(flag: 0x1, status: false, tickStart: start, timeout: 1000, getTick: getTick) != .ok {
            handle.write(.state, value: PKAState.error.rawValue)
        }
        modify(.clrfr, set: 0x20000 | 0x80000 | 0x100000 | 0x200000)
        registers.write(.cr, value: 0)
        system.disableClock(); system.disableInterrupt()
    }
    @discardableResult
    public func abort() -> HALStatus {
        disable(); enable()
        modify(.clrfr, set: 0x20000 | 0x80000 | 0x100000 | 0x200000)
        handle.write(.errorCode, value: 0x0)
        handle.write(.state, value: PKAState.ready.rawValue)
        return .ok
    }
    public func resetRAM() { for index: UInt32 in 0..<1334 { registers.writeRAM(index, value: 0) } }
    public func waitOnFlagUntilTimeout(flag: UInt32, status: Bool, tickStart: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        while getFlag(flag) == status {
            if timeout != UInt32.max {
                if getTick() &- tickStart > timeout || timeout == 0 {
                    handle.write(.state, value: PKAState.ready.rawValue)
                    handle.write(.errorCode, value: 0x4)
                    return .timeout
                }
            }
        }
        return .ok
    }
    public func pollEndOfOperation(timeout: UInt32, tickStart: UInt32, getTick: () -> UInt32) -> HALStatus {
        while registers.read(.sr) & 0x20000 == 0 {
            if timeout != UInt32.max {
                if getTick() &- tickStart > timeout || timeout == 0 { return .timeout }
            }
        }
        return .ok
    }
    public func checkError(mode: UInt32) -> UInt32 {
        var error: UInt32 = 0
        if getFlag(0x80000) { error |= 0x2 }
        if getFlag(0x100000) { error |= 0x1 }
        if getFlag(0x200000) { error |= 0x8 }
        if let index = operationErrorIndex(mode), registers.readRAM(index) != 0xD60D { error |= 0x8 }
        return error
    }
    func operationErrorIndex(_ mode: UInt32) -> UInt32? {
        switch mode {
        case 0x24: return 0x2F8
        case 0x27: return 0x48
        case 0x2F: return 0xA0
        case 0x20: return 0xA0
        case 0x3: return 0x3A6
        default: return nil
        }
    }
    @discardableResult
    public func process(mode: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        guard handle.read(.state) == PKAState.ready.rawValue else { return .error }
        handle.write(.state, value: PKAState.busy.rawValue)
        handle.write(.errorCode, value: 0x0)
        let tickStart = getTick()
        modify(.cr, clear: 0x3F00 | 0x20000 | 0x80000 | 0x100000 | 0x200000,
               set: mode << 0x8)
        start()
        if pollEndOfOperation(timeout: timeout, tickStart: tickStart, getTick: getTick) != .ok {
            disable(); addError(0x4); enable()
        }
        addError(checkError(mode: mode))
        modify(.clrfr, set: 0x20000 | 0x80000 | 0x100000 | 0x200000)
        handle.write(.state, value: PKAState.ready.rawValue)
        return handle.read(.errorCode) != 0x0 ? .error : .ok
    }
    @discardableResult
    public func processIT(mode: UInt32) -> HALStatus {
        guard handle.read(.state) == PKAState.ready.rawValue else { return .error }
        handle.write(.state, value: PKAState.busy.rawValue)
        handle.write(.errorCode, value: 0x0)
        modify(.cr, clear: 0x3F00 | 0x20000 | 0x80000 | 0x100000 | 0x200000,
               set: mode << 0x8 | 0x20000 | 0x80000 | 0x100000 | 0x200000)
        start(); return .ok
    }
    public func handleInterrupt() {
        let mode = getMode()
        let source = registers.read(.cr)
        let flags = registers.read(.sr)
        if source & 0x100000 == 0x100000 && flags & 0x100000 == 0x100000 {
            addError(0x1); clearFlags(0x100000)
        }
        if source & 0x80000 == 0x80000 && flags & 0x80000 == 0x80000 {
            addError(0x2); clearFlags(0x80000)
        }
        if source & 0x200000 == 0x200000 && flags & 0x200000 == 0x200000 {
            addError(0x8); clearFlags(0x200000)
        }
        if let index = operationErrorIndex(mode), registers.readRAM(index) != 0xD60D { addError(0x8) }
        if handle.read(.errorCode) != 0x0 { invoke(.error) }
        if source & 0x20000 == 0x20000 && flags & 0x20000 == 0x20000 {
            clearFlags(0x20000)
            handle.write(.state, value: PKAState.ready.rawValue)
            invoke(.operationComplete)
        }
    }
}
