// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DMA2D operations from stm32h7rsxx_hal_dma2d.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DMA2D {
    @discardableResult
    public func abort(getTick: () -> UInt32) -> HALStatus {
        // Writing zero to START avoids restarting a transfer completed during RMW.
        modify(.cr, clear: 5, set: 4)
        let start = getTick()
        while registers.read(.cr) & 1 != 0 {
            if getTick() &- start > 1000 { return timeout(unlock: true) }
        }
        disableInterrupts(0x2300)
        handle.write(.state, value: 1); handle.write(.lock, value: 0)
        return .ok
    }
    @discardableResult
    public func suspend(getTick: () -> UInt32) -> HALStatus {
        modify(.cr, clear: 3, set: 2)
        let start = getTick()
        while registers.read(.cr) & 3 == 1 {
            if getTick() &- start > 1000 { return timeout(unlock: false) }
        }
        if registers.read(.cr) & 1 != 0 { handle.write(.state, value: 5) }
        else { modify(.cr, clear: 2) }
        return .ok
    }
    @discardableResult
    public func resume() -> HALStatus {
        if registers.read(.cr) & 3 == 3 { handle.write(.state, value: 2) }
        modify(.cr, clear: 3)
        return .ok
    }
    @discardableResult
    public func abortCLUT(layer: UInt32, getTick: () -> UInt32) -> HALStatus {
        // C deliberately has no layer assertion here and selects FG only for 1.
        modify(.cr, set: 4)
        let register: DMA2DRegister = layer == 1 ? .fgpfccr : .bgpfccr
        let start = getTick()
        while registers.read(register) & 0x20 != 0 {
            if getTick() &- start > 1000 { return timeout(unlock: true) }
        }
        disableInterrupts(0x3900)
        handle.write(.state, value: 1); handle.write(.lock, value: 0)
        return .ok
    }
    @discardableResult
    public func suspendCLUT(layer: UInt32, getTick: () -> UInt32) -> HALStatus {
        modify(.cr, set: 2)
        let register: DMA2DRegister = layer == 1 ? .fgpfccr : .bgpfccr
        let start = getTick()
        var suspended: UInt32 = registers.read(.cr) & 2 == 2 ? 1 : 0
        suspended |= registers.read(register) & 0x20 != 0x20 ? 1 : 0
        while suspended == 0 {
            if getTick() &- start > 1000 { return timeout(unlock: false) }
            suspended = registers.read(.cr) & 2 == 2 ? 1 : 0
            suspended |= registers.read(register) & 0x20 != 0x20 ? 1 : 0
        }
        if registers.read(register) & 0x20 != 0 { handle.write(.state, value: 5) }
        else { modify(.cr, clear: 2) }
        return .ok
    }
    @discardableResult
    public func resumeCLUT(layer: UInt32) -> HALStatus {
        // Resume selects BG only for zero, unlike Abort/Suspend in the pinned C.
        if registers.read(.cr) & 2 == 2 {
            if registers.read(layer == 0 ? .bgpfccr : .fgpfccr) & 0x20 == 0x20 { handle.write(.state, value: 2) }
        }
        modify(.cr, clear: 2)
        return .ok
    }
    @discardableResult
    public func pollForTransfer(timeout limit: UInt32, getTick: () -> UInt32) -> HALStatus {
        if registers.read(.cr) & 1 != 0 {
            let start = getTick()
            while getFlag(2) == 0 {
                let flags = registers.read(.isr)
                if flags & 0x21 != 0 {
                    if flags & 0x20 != 0 { addError(2) }
                    if flags & 1 != 0 { addError(1) }
                    clearFlag(0x21)
                    handle.write(.state, value: 4); handle.write(.lock, value: 0)
                    return .error
                }
                if limit != .max {
                    if getTick() &- start > limit || limit == 0 { return timeout(unlock: true) }
                }
            }
        }
        var layerStart = registers.read(.fgpfccr) & 0x20
        layerStart |= registers.read(.bgpfccr) & 0x20
        if layerStart != 0 {
            let start = getTick()
            while getFlag(0x10) == 0 {
                let flags = registers.read(.isr)
                if flags & 0x29 != 0 {
                    if flags & 8 != 0 { addError(4) }
                    if flags & 0x20 != 0 { addError(2) }
                    if flags & 1 != 0 { addError(1) }
                    clearFlag(0x29)
                    handle.write(.state, value: 4); handle.write(.lock, value: 0)
                    return .error
                }
                if limit != .max {
                    if getTick() &- start > limit || limit == 0 { return timeout(unlock: true) }
                }
            }
        }
        clearFlag(0x12)
        handle.write(.state, value: 1); handle.write(.lock, value: 0)
        return .ok
    }
    public func handleInterrupt() {
        let flags = registers.read(.isr)
        let control = registers.read(.cr)
        if flags & 1 != 0 && control & 0x100 != 0 {
            disableInterrupts(0x100); addError(1); clearFlag(1)
            handle.write(.state, value: 4); handle.write(.lock, value: 0); invoke(.transferError)
        }
        if flags & 0x20 != 0 && control & 0x2000 != 0 {
            disableInterrupts(0x2000); clearFlag(0x20); addError(2)
            handle.write(.state, value: 4); handle.write(.lock, value: 0); invoke(.transferError)
        }
        if flags & 8 != 0 && control & 0x800 != 0 {
            disableInterrupts(0x800); clearFlag(8); addError(4)
            handle.write(.state, value: 4); handle.write(.lock, value: 0); invoke(.transferError)
        }
        if flags & 4 != 0 && control & 0x400 != 0 {
            disableInterrupts(0x400); clearFlag(4); invoke(.lineEvent)
        }
        if flags & 2 != 0 && control & 0x200 != 0 {
            disableInterrupts(0x200); clearFlag(2); addError(0)
            handle.write(.state, value: 1); handle.write(.lock, value: 0); invoke(.transferComplete)
        }
        if flags & 0x10 != 0 && control & 0x1000 != 0 {
            disableInterrupts(0x1000); clearFlag(0x10); addError(0)
            handle.write(.state, value: 1); handle.write(.lock, value: 0); invoke(.clutComplete)
        }
    }
    func addError(_ error: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | error) }
    private func timeout(unlock: Bool) -> HALStatus {
        addError(0x20); handle.write(.state, value: 3)
        if unlock { handle.write(.lock, value: 0) }
        return .timeout
    }
}
