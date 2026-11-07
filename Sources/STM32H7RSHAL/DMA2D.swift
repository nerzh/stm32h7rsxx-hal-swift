// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DMA2D operations from stm32h7rsxx_hal_dma2d.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DMA2D {
    @discardableResult
    public func initialize() -> HALStatus {
        precondition(DMA2DMode(rawValue: handle.read(.mode)) != nil)
        precondition(handle.read(.colorMode) <= 4 && handle.read(.outputOffset) <= 0xFFFF)
        precondition(handle.read(.alphaInverted) <= 1 && handle.read(.redBlueSwap) <= 1)
        precondition(DMA2DLineOffsetMode(rawValue: handle.read(.lineOffsetMode)) != nil)
        precondition(handle.read(.bytesSwap) == 0 || handle.read(.bytesSwap) == 0x100)
        if handle.read(.state) == 0 {
            if useRegisteredCallbacks {
                callbacks.write(.lineEvent, value: defaults.lineEvent)
                callbacks.write(.clutComplete, value: defaults.clutComplete)
                if callbacks.read(.mspInitialize) == nil { callbacks.write(.mspInitialize, value: defaults.mspInitialize) }
            } else {
                // The registered-callback branch in C does not initialize Lock.
                handle.write(.lock, value: 0)
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 2)
        modify(.cr, clear: 0x70040, set: handle.read(.mode) | handle.read(.lineOffsetMode))
        modify(.opfccr, clear: 0x107, set: handle.read(.colorMode) | handle.read(.bytesSwap))
        modify(.oor, clear: 0xFFFF, set: handle.read(.outputOffset))
        modify(.opfccr, clear: 0x300000, set: (handle.read(.alphaInverted) << 20) | (handle.read(.redBlueSwap) << 21))
        handle.write(.errorCode, value: 0); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func deinitialize(getTick: () -> UInt32) -> HALStatus {
        if registers.isClockEnabled() {
            if registers.read(.cr) & 1 == 1 {
                if abort(getTick: getTick) != .ok { return .error }
            } else if registers.read(.bgpfccr) & 0x20 == 0x20 {
                if abortCLUT(layer: 0, getTick: getTick) != .ok { return .error }
            } else if registers.read(.fgpfccr) & 0x20 == 0x20 {
                if abortCLUT(layer: 1, getTick: getTick) != .ok { return .error }
            }
        }
        registers.write(.cr, value: 0); registers.write(.ifcr, value: 0x3F)
        registers.write(.fgor, value: 0); registers.write(.bgor, value: 0)
        registers.write(.fgpfccr, value: 0); registers.write(.bgpfccr, value: 0)
        registers.write(.opfccr, value: 0)
        if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
            callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        }
        invoke(.mspDeinitialize)
        handle.write(.errorCode, value: 0); handle.write(.state, value: 0); handle.write(.lock, value: 0)
        return .ok
    }
    @discardableResult
    public func start(data: UInt32, destination: UInt32, width: UInt32, height: UInt32,
                      interrupts: Bool = false) -> HALStatus {
        precondition(height <= 0xFFFF && width <= 0x3FFF)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        setConfiguration(data: data, destination: destination, width: width, height: height)
        if interrupts { enableInterrupts(0x2300) }
        enable()
        return .ok
    }
    @discardableResult
    public func startBlending(foreground: UInt32, background: UInt32, destination: UInt32,
                              width: UInt32, height: UInt32, interrupts: Bool = false) -> HALStatus {
        precondition(height <= 0xFFFF && width <= 0x3FFF)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        if handle.read(.mode) == 0x40000 {
            registers.write(.fgcolr, value: foreground)
            setConfiguration(data: background, destination: destination, width: width, height: height)
        } else if handle.read(.mode) == 0x50000 {
            registers.write(.bgcolr, value: background)
            setConfiguration(data: foreground, destination: destination, width: width, height: height)
        } else {
            registers.write(.bgmar, value: background)
            setConfiguration(data: foreground, destination: destination, width: width, height: height)
        }
        if interrupts { enableInterrupts(0x2300) }
        enable()
        return .ok
    }
    @discardableResult
    public func configureLayer(_ layer: UInt32) -> HALStatus {
        precondition(layer <= 1)
        precondition(layerWord(layer, 0) <= 0xFFFF)
        if handle.read(.mode) != 0x30000 {
            precondition(layerWord(layer, 1) <= 11)
            if handle.read(.mode) != 0 { precondition(layerWord(layer, 2) <= 2) }
        }
        precondition(layerWord(layer, 4) <= 1 && layerWord(layer, 5) <= 1)
        if layer == 1 && layerWord(layer, 1) == 11 { precondition(layerWord(layer, 6) <= 2) }
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        var value = layerWord(layer, 1) | (layerWord(layer, 2) << 16) |
                    (layerWord(layer, 4) << 20) | (layerWord(layer, 5) << 21)
        var mask: UInt32 = 0xFF33_000F
        if layerWord(layer, 1) == 10 || layerWord(layer, 1) == 9 { value |= layerWord(layer, 3) & 0xFF00_0000 }
        else { value |= layerWord(layer, 3) << 24 }
        if layer == 0 {
            modify(.bgpfccr, clear: mask, set: value)
            registers.write(.bgor, value: layerWord(layer, 0))
            if layerWord(layer, 1) == 10 || layerWord(layer, 1) == 9 {
                registers.write(.bgcolr, value: layerWord(layer, 3) & 0xFFFFFF)
            }
        } else {
            if layerWord(layer, 1) == 11 { value |= layerWord(layer, 6) << 18; mask |= 0xC0000 }
            modify(.fgpfccr, clear: mask, set: value)
            registers.write(.fgor, value: layerWord(layer, 0))
            if layerWord(layer, 1) == 10 || layerWord(layer, 1) == 9 {
                registers.write(.fgcolr, value: layerWord(layer, 3) & 0xFFFFFF)
            }
        }
        handle.write(.state, value: 1); handle.write(.lock, value: 0)
        return .ok
    }
    @discardableResult
    public func configureCLUT(_ configuration: DMA2DCLUTConfiguration, layer: UInt32) -> HALStatus {
        precondition(layer <= 1 && configuration.colorMode <= 1 && configuration.size <= 255)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        setCLUT(configuration, layer: layer)
        handle.write(.state, value: 1); handle.write(.lock, value: 0)
        return .ok
    }
    @discardableResult
    public func enableCLUT(layer: UInt32) -> HALStatus {
        precondition(layer <= 1)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        modify(layer == 0 ? .bgpfccr : .fgpfccr, set: 0x20)
        return .ok
    }
    // Both CLUTStartLoad and CLUTLoad C APIs perform the same register sequence.
    @discardableResult
    public func loadCLUT(_ configuration: DMA2DCLUTConfiguration, layer: UInt32, interrupts: Bool = false) -> HALStatus {
        precondition(layer <= 1 && configuration.colorMode <= 1 && configuration.size <= 255)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        setCLUT(configuration, layer: layer)
        if interrupts { enableInterrupts(0x3900) }
        modify(layer == 0 ? .bgpfccr : .fgpfccr, set: 0x20)
        return .ok
    }
    @discardableResult
    public func programLineEvent(_ line: UInt32) -> HALStatus {
        if line > 0xFFFF { return .error }
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        registers.write(.lwr, value: line); enableInterrupts(0x400)
        handle.write(.state, value: 1); handle.write(.lock, value: 0)
        return .ok
    }
    @discardableResult
    public func enableDeadTime() -> HALStatus { updateDeadTime(clear: 0, set: 1) }
    @discardableResult
    public func disableDeadTime() -> HALStatus { updateDeadTime(clear: 1, set: 0) }
    @discardableResult
    public func configureDeadTime(_ value: UInt8) -> HALStatus { updateDeadTime(clear: 0xFF00, set: UInt32(value) << 8) }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func enable() { modify(.cr, set: 1) }
    public func getFlag(_ flags: UInt32) -> UInt32 { registers.read(.isr) & flags }
    public func clearFlag(_ flags: UInt32) { registers.write(.ifcr, value: flags) }
    public func enableInterrupts(_ mask: UInt32) { modify(.cr, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { modify(.cr, clear: mask) }
    public func getInterruptSource(_ mask: UInt32) -> UInt32 { registers.read(.cr) & mask }
    func lock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func modify(_ register: DMA2DRegister, clear: UInt32 = 0, set: UInt32 = 0) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
    func invoke(_ id: DMA2DCallbackID) {
        if id == .transferComplete || id == .transferError { callbacks.read(id)?(callbacks.context) }
        else if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)!(callbacks.context) }
    }
    private func layerWord(_ layer: UInt32, _ index: Int) -> UInt32 {
        handle.read(DMA2DHandleWord(rawValue: 10 + Int(layer) * 7 + index)!)
    }
    private func setCLUT(_ c: DMA2DCLUTConfiguration, layer: UInt32) {
        registers.write(layer == 0 ? .bgcmar : .fgcmar, value: c.address)
        modify(layer == 0 ? .bgpfccr : .fgpfccr, clear: 0xFF10, set: (c.size << 8) | (c.colorMode << 4))
    }
    private func updateDeadTime(clear: UInt32, set: UInt32) -> HALStatus {
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        modify(.amtcr, clear: clear, set: set)
        handle.write(.state, value: 1); handle.write(.lock, value: 0)
        return .ok
    }
    private func setConfiguration(data: UInt32, destination: UInt32, width: UInt32, height: UInt32) {
        modify(.nlr, clear: 0x3FFF_FFFF, set: height | (width << 16))
        registers.write(.omar, value: destination)
        if handle.read(.mode) == 0x30000 {
            var a = data & 0xFF00_0000, r = data & 0x00FF_0000, g = data & 0x0000_FF00, b = data & 0xFF
            let value: UInt32
            if handle.read(.colorMode) == 0 { value = g | r | a | b }
            else if handle.read(.colorMode) == 1 { value = g | r | b }
            else if handle.read(.colorMode) == 2 {
                r >>= 19; g >>= 10; b >>= 3
                value = (g << 5) | (r << 11) | b
            } else if handle.read(.colorMode) == 3 {
                a >>= 31; r >>= 19; g >>= 11; b >>= 3
                value = (g << 5) | (r << 10) | (a << 15) | b
            } else {
                a >>= 28; r >>= 20; g >>= 12; b >>= 4
                value = (g << 4) | (r << 8) | (a << 12) | b
            }
            registers.write(.ocolr, value: value)
        } else if handle.read(.mode) == 0x40000 { registers.write(.bgmar, value: data) }
        else { registers.write(.fgmar, value: data) }
    }
}
