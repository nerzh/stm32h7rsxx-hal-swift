// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LTDC layer operations from stm32h7rsxx_hal_ltdc.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension LTDC {
    @discardableResult
    public func configureLayer(_ configuration: LTDCLayerConfiguration, layer: UInt32, reload: Bool = true) -> HALStatus {
        precondition(layer < 2)
        precondition(configuration.windowX0 <= 0xFFF && configuration.windowX1 <= 0xFFF)
        // Both vertical assertions in C use the horizontal position mask.
        precondition(configuration.windowY0 <= 0xFFF && configuration.windowY1 <= 0xFFF)
        precondition(configuration.pixelFormat <= 7 && configuration.alpha <= 255 && configuration.alpha0 <= 255)
        precondition(LTDCBlendingFactor1(rawValue: configuration.blendingFactor1) != nil)
        precondition(LTDCBlendingFactor2(rawValue: configuration.blendingFactor2) != nil)
        precondition(configuration.imageWidth <= 0x1FFF && configuration.imageHeight <= 0x7FF)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        for word in LTDCLayerWord.allCases { writeLayer(layer, word, configuration[word]) }
        setConfiguration(layer: layer) { configuration[$0] }
        return finish(reload: reload)
    }
    @discardableResult
    public func setWindowSize(width: UInt32, height: UInt32, layer: UInt32, reload: Bool = true) -> HALStatus {
        precondition(layer < 2 && width <= 0x1FFF && height <= 0x7FF)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        writeLayer(layer, .windowX1, width &+ readLayer(layer, .windowX0))
        writeLayer(layer, .windowY1, height &+ readLayer(layer, .windowY0))
        writeLayer(layer, .imageWidth, width); writeLayer(layer, .imageHeight, height)
        setConfiguration(layer: layer) { readLayer(layer, $0) }
        return finish(reload: reload)
    }
    @discardableResult
    public func setWindowPosition(x: UInt32, y: UInt32, layer: UInt32, reload: Bool = true) -> HALStatus {
        precondition(layer < 2 && x <= 0x1FFF && y <= 0x7FF)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        writeLayer(layer, .windowX0, x); writeLayer(layer, .windowX1, x &+ readLayer(layer, .imageWidth))
        writeLayer(layer, .windowY0, y); writeLayer(layer, .windowY1, y &+ readLayer(layer, .imageHeight))
        setConfiguration(layer: layer) { readLayer(layer, $0) }
        return finish(reload: reload)
    }
    @discardableResult
    public func setPixelFormat(_ format: LTDCPixelFormat, layer: UInt32, reload: Bool = true) -> HALStatus {
        updateLayer(layer, .pixelFormat, format.rawValue, reload: reload)
    }
    @discardableResult
    public func setAlpha(_ alpha: UInt32, layer: UInt32, reload: Bool = true) -> HALStatus {
        precondition(alpha <= 255)
        return updateLayer(layer, .alpha, alpha, reload: reload)
    }
    @discardableResult
    public func setAddress(_ address: UInt32, layer: UInt32, reload: Bool = true) -> HALStatus {
        updateLayer(layer, .frameBufferAddress, address, reload: reload)
    }
    @discardableResult
    public func setPitch(pixels: UInt32, layer: UInt32, reload: Bool = true) -> HALStatus {
        precondition(layer < 2)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        let pixelFormat = readLayer(layer, .pixelFormat)
        let pitch = (pixels &* bytesPerPixel { pixelFormat }) << 16
        modify(.cfblr, layer: layer, clear: 0x1FFF0000)
        if reload { reloadImmediately() }
        modify(.cfblr, layer: layer, set: pitch)
        if reload { reloadImmediately() }
        return finish()
    }
    @discardableResult
    public func configureColorKeying(rgb: UInt32, layer: UInt32, reload: Bool = true) -> HALStatus {
        precondition(layer < 2)
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        modify(.ckcr, layer: layer, clear: 0xFFFFFF)
        registers.write(.ckcr, layer: layer, value: rgb)
        return finish(reload: reload)
    }
    @discardableResult
    public func configureCLUT(_ colors: UnsafeBufferPointer<UInt32>, layer: UInt32) -> HALStatus {
        precondition(layer < 2 && UInt(colors.count) <= UInt(UInt32.max))
        if !lock() { return .busy }
        handle.write(.state, value: 2)
        for counter in 0..<UInt32(colors.count) {
            let index = readLayer(layer, .pixelFormat) == 6 ? counter &+ (16 &* counter) : counter
            let color = colors[Int(counter)] & 0xFF | colors[Int(counter)] & 0xFF00 | colors[Int(counter)] & 0xFF0000
            registers.write(.clutwr, layer: layer, value: (index << 24) | color)
        }
        return finish()
    }
    @discardableResult
    public func enableColorKeying(layer: UInt32, reload: Bool = true) -> HALStatus { updateControl(layer, clear: 0, set: 2, reload: reload) }
    @discardableResult
    public func disableColorKeying(layer: UInt32, reload: Bool = true) -> HALStatus { updateControl(layer, clear: 2, set: 0, reload: reload) }
    @discardableResult
    public func enableCLUT(layer: UInt32, reload: Bool = true) -> HALStatus { updateControl(layer, clear: 0, set: 0x10, reload: reload) }
    @discardableResult
    public func disableCLUT(layer: UInt32, reload: Bool = true) -> HALStatus { updateControl(layer, clear: 0x10, set: 0, reload: reload) }
    private func readLayer(_ layer: UInt32, _ word: LTDCLayerWord) -> UInt32 {
        handle.read(LTDCHandleWord(rawValue: 16 + Int(layer) * 13 + word.rawValue)!)
    }
    private func writeLayer(_ layer: UInt32, _ word: LTDCLayerWord, _ value: UInt32) {
        handle.write(LTDCHandleWord(rawValue: 16 + Int(layer) * 13 + word.rawValue)!, value: value)
    }
    private func updateLayer(_ layer: UInt32, _ word: LTDCLayerWord, _ value: UInt32, reload: Bool) -> HALStatus {
        precondition(layer < 2)
        if !lock() { return .busy }
        handle.write(.state, value: 2); writeLayer(layer, word, value)
        setConfiguration(layer: layer) { readLayer(layer, $0) }
        return finish(reload: reload)
    }
    private func updateControl(_ layer: UInt32, clear: UInt32, set: UInt32, reload: Bool) -> HALStatus {
        precondition(layer < 2)
        if !lock() { return .busy }
        handle.write(.state, value: 2); modify(.cr, layer: layer, clear: clear, set: set)
        return finish(reload: reload)
    }
    private func bytesPerPixel(_ format: () -> UInt32) -> UInt32 {
        if format() == 0 { return 4 }
        else if format() == 1 { return 3 }
        else if format() == 4 || format() == 2 || format() == 3 || format() == 7 { return 2 }
        else { return 1 }
    }
    private func setConfiguration(layer: UInt32, read: (LTDCLayerWord) -> UInt32) {
        var temporary = (read(.windowX1) &+ ((registers.read(.bpcr) & 0x0FFF0000) >> 16)) << 16
        modify(.whpcr, layer: layer, clear: 0x0FFF0FFF)
        registers.write(.whpcr, layer: layer, value: (read(.windowX0) &+ ((registers.read(.bpcr) & 0x0FFF0000) >> 16) &+ 1) | temporary)
        temporary = (read(.windowY1) &+ (registers.read(.bpcr) & 0x7FF)) << 16
        modify(.wvpcr, layer: layer, clear: 0x07FF07FF)
        registers.write(.wvpcr, layer: layer, value: (read(.windowY0) &+ (registers.read(.bpcr) & 0x7FF) &+ 1) | temporary)
        modify(.pfcr, layer: layer, clear: 7)
        registers.write(.pfcr, layer: layer, value: read(.pixelFormat))
        let green = read(.backgroundColor) & 0xFF00, red = read(.backgroundColor) & 0xFF0000
        let alpha = read(.alpha0) << 24
        registers.write(.dccr, layer: layer, value: (read(.backgroundColor) & 0xFF) | green | red | alpha)
        modify(.cacr, layer: layer, clear: 0xFF)
        registers.write(.cacr, layer: layer, value: read(.alpha))
        modify(.bfcr, layer: layer, clear: 0x707)
        registers.write(.bfcr, layer: layer, value: read(.blendingFactor1) | read(.blendingFactor2))
        registers.write(.cfbar, layer: layer, value: read(.frameBufferAddress))
        temporary = bytesPerPixel { read(.pixelFormat) }
        modify(.cfblr, layer: layer, clear: 0x1FFF1FFF)
        registers.write(.cfblr, layer: layer, value: ((read(.imageWidth) &* temporary) << 16) |
                        ((read(.windowX1) &- read(.windowX0)) &* temporary &+ 7))
        modify(.cfblnr, layer: layer, clear: 0x7FF)
        registers.write(.cfblnr, layer: layer, value: read(.imageHeight))
        enableLayer(layer)
    }
}
