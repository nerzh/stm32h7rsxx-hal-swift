// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LTDC operations from stm32h7rsxx_hal_ltdc.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension LTDC {
    @discardableResult
    public func initialize() -> HALStatus {
        precondition(handle.read(.horizontalSync) <= 0xFFF && handle.read(.verticalSync) <= 0x7FF)
        precondition(handle.read(.accumulatedHBP) <= 0xFFF && handle.read(.accumulatedVBP) <= 0x7FF)
        precondition(handle.read(.accumulatedActiveWidth) <= 0xFFF && handle.read(.accumulatedActiveHeight) <= 0x7FF)
        precondition(handle.read(.totalWidth) <= 0xFFF && handle.read(.totalHeight) <= 0x7FF)
        precondition(handle.read(.hsPolarity) == 0 || handle.read(.hsPolarity) == 0x80000000)
        precondition(handle.read(.vsPolarity) == 0 || handle.read(.vsPolarity) == 0x40000000)
        precondition(handle.read(.dePolarity) == 0 || handle.read(.dePolarity) == 0x20000000)
        precondition(handle.read(.pcPolarity) == 0 || handle.read(.pcPolarity) == 0x10000000)
        if handle.read(.state) == 0 {
            handle.write(.lock, value: 0)
            if useRegisteredCallbacks {
                callbacks.write(.lineEvent, value: defaults.lineEvent)
                callbacks.write(.reloadEvent, value: defaults.reloadEvent)
                callbacks.write(.error, value: defaults.error)
                if callbacks.read(.mspInitialize) == nil { callbacks.write(.mspInitialize, value: defaults.mspInitialize) }
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 2)
        modify(.gcr, clear: 0xF0000000)
        modify(.gcr, set: handle.read(.hsPolarity) | handle.read(.vsPolarity) |
               handle.read(.dePolarity) | handle.read(.pcPolarity))
        registers.write(.sscr, value: (handle.read(.horizontalSync) << 16) | handle.read(.verticalSync))
        registers.write(.bpcr, value: (handle.read(.accumulatedHBP) << 16) | handle.read(.accumulatedVBP))
        registers.write(.awcr, value: (handle.read(.accumulatedActiveWidth) << 16) | handle.read(.accumulatedActiveHeight))
        registers.write(.twcr, value: (handle.read(.totalWidth) << 16) | handle.read(.totalHeight))
        let green = handle.read(.backgroundColor) & 0xFF00
        let red = handle.read(.backgroundColor) & 0xFF0000
        modify(.bccr, clear: 0xFFFFFF)
        modify(.bccr, set: red | green | (handle.read(.backgroundColor) & 0xFF))
        enableInterrupts(6); enable()
        handle.write(.errorCode, value: 0); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func deinitialize(getTick: () -> UInt32) -> HALStatus {
        disableLayer(0); disableLayer(1); reloadAtVerticalBlanking()
        let start = getTick()
        while registers.read(.cdsr) & 4 == 0 {
            // Upstream stops waiting after 100 ticks but still returns HAL_OK.
            if getTick() &- start > 100 { break }
        }
        disable()
        if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
            callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        }
        invoke(.mspDeinitialize)
        handle.write(.errorCode, value: 0); handle.write(.state, value: 0); handle.write(.lock, value: 0)
        return .ok
    }
    public func handleInterrupt() {
        let flags = registers.read(.isr), sources = registers.read(.ier)
        if flags & 4 != 0 && sources & 4 != 0 {
            disableInterrupts(4); clearFlag(4); addError(1)
            handle.write(.state, value: 4); handle.write(.lock, value: 0); invoke(.error)
        }
        if flags & 2 != 0 && sources & 2 != 0 {
            disableInterrupts(2); clearFlag(2); addError(2)
            handle.write(.state, value: 4); handle.write(.lock, value: 0); invoke(.error)
        }
        if flags & 1 != 0 && sources & 1 != 0 {
            disableInterrupts(1); clearFlag(1)
            handle.write(.state, value: 1); handle.write(.lock, value: 0); invoke(.lineEvent)
        }
        if flags & 8 != 0 && sources & 8 != 0 {
            disableInterrupts(8); clearFlag(8)
            handle.write(.state, value: 1); handle.write(.lock, value: 0); invoke(.reloadEvent)
        }
    }
    @discardableResult
    public func programLineEvent(_ line: UInt32) -> HALStatus {
        precondition(line <= 0x7FF)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        disableInterrupts(1); registers.write(.lipcr, value: line); enableInterrupts(1)
        return finish()
    }
    @discardableResult
    public func reload(_ type: LTDCReload) -> HALStatus {
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        enableInterrupts(8); registers.write(.srcr, value: type.rawValue)
        return finish()
    }
    @discardableResult
    public func enableDither() -> HALStatus { updateDither(clear: 0, set: 0x10000) }
    @discardableResult
    public func disableDither() -> HALStatus { updateDither(clear: 0x10000, set: 0) }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func enable() { modify(.gcr, set: 1) }
    public func disable() { modify(.gcr, clear: 1) }
    public func enableLayer(_ layer: UInt32) { precondition(layer < 2); modify(.cr, layer: layer, set: 1) }
    public func disableLayer(_ layer: UInt32) { precondition(layer < 2); modify(.cr, layer: layer, clear: 1) }
    public func reloadImmediately() { modify(.srcr, set: 1) }
    public func reloadAtVerticalBlanking() { modify(.srcr, set: 2) }
    public func getFlag(_ mask: UInt32) -> UInt32 { registers.read(.isr) & mask }
    public func clearFlag(_ mask: UInt32) { registers.write(.icr, value: mask) }
    public func enableInterrupts(_ mask: UInt32) { modify(.ier, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { modify(.ier, clear: mask) }
    public func getInterruptSource(_ mask: UInt32) -> UInt32 { registers.read(.ier) & mask }
    func lock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func finish(reload: Bool = false) -> HALStatus {
        if reload { registers.write(.srcr, value: 1) }
        handle.write(.state, value: 1); handle.write(.lock, value: 0)
        return .ok
    }
    func modify(_ register: LTDCRegister, clear: UInt32 = 0, set: UInt32 = 0) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
    func modify(_ register: LTDCLayerRegister, layer: UInt32, clear: UInt32 = 0, set: UInt32 = 0) {
        registers.write(register, layer: layer, value: (registers.read(register, layer: layer) & ~clear) | set)
    }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func invoke(_ id: LTDCCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)!(callbacks.context) }
    }
    private func updateDither(clear: UInt32, set: UInt32) -> HALStatus {
        if !lock() { return .busy }
        handle.write(.state, value: 2); modify(.gcr, clear: clear, set: set)
        return finish()
    }
}
