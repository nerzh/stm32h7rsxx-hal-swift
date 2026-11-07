// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// GFXMMU operations from stm32h7rsxx_hal_gfxmmu.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension GFXMMU {
    @discardableResult
    public func initialize() -> HALStatus {
        precondition(GFXMMUBlockSize(rawValue: handle.read(.blockSize)) != nil)
        precondition(handle.read(.addressTranslation) <= 1)
        precondition(handle.read(.buffer0) & 15 == 0 && handle.read(.buffer1) & 15 == 0 &&
                     handle.read(.buffer2) & 15 == 0 && handle.read(.buffer3) & 15 == 0)
        precondition(handle.read(.interruptsEnabled) <= 1)
        // Unlike most HAL modules, every Init resets ErrorCallback and calls MSP.
        if useRegisteredCallbacks {
            callbacks.write(.error, value: defaults.error)
            if callbacks.read(.mspInitialize) == nil {
                callbacks.write(.mspInitialize, value: defaults.mspInitialize)
            }
        }
        invoke(.mspInitialize)
        registers.write(.cr, value: 0)
        registers.write(.cr, value: registers.read(.cr) | handle.read(.blockSize))
        if handle.read(.addressTranslation) == 1 { modifyControl(set: 0x8000) }
        if handle.read(.interruptsEnabled) == 1 {
            precondition(handle.read(.interrupts) & 0x1F != 0)
            modifyControl(set: handle.read(.interrupts))
        }
        registers.write(.dvr, value: handle.read(.defaultValue))
        registers.write(.b0cr, value: handle.read(.buffer0))
        registers.write(.b1cr, value: handle.read(.buffer1))
        registers.write(.b2cr, value: handle.read(.buffer2))
        registers.write(.b3cr, value: handle.read(.buffer3))
        handle.write(.errorCode, value: 0)
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        modifyControl(clear: 0x1F)
        if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
            callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        }
        invoke(.mspDeinitialize)
        handle.write(.state, value: 0)
        return .ok
    }
    @discardableResult
    public func configureLUT(firstLine: UInt32, lineCount: UInt32, sourceAddress: UInt32) -> HALStatus {
        precondition(firstLine < 1024 && lineCount > 0 && lineCount <= 1024)
        if handle.read(.state) != 1 || (firstLine &+ lineCount) > 1024 { return .error }
        if registers.read(.cr) & 0x8000 == 0 { return .error }
        var source = sourceAddress
        var low = registers.address(of: .lut(index: Int(2 &* firstLine)))
        var high = registers.address(of: .lut(index: Int((2 &* firstLine) &+ 1)))
        var current: UInt32 = 0
        while current < lineCount {
            memory.write32(at: low, value: memory.read32(at: source))
            source &+= 4
            memory.write32(at: high, value: memory.read32(at: source))
            source &+= 4
            low &+= 8; high &+= 8; current &+= 1
        }
        return .ok
    }
    @discardableResult
    public func disableLUTLines(firstLine: UInt32, lineCount: UInt32) -> HALStatus {
        precondition(firstLine < 1024 && lineCount > 0 && lineCount <= 1024)
        if handle.read(.state) != 1 || (firstLine &+ lineCount) > 1024 { return .error }
        if registers.read(.cr) & 0x8000 == 0 { return .error }
        var low = registers.address(of: .lut(index: Int(2 &* firstLine)))
        var high = registers.address(of: .lut(index: Int((2 &* firstLine) &+ 1)))
        var current: UInt32 = 0
        while current < lineCount {
            memory.write32(at: low, value: 0)
            memory.write32(at: high, value: 0)
            low &+= 8; high &+= 8; current &+= 1
        }
        return .ok
    }
    @discardableResult
    public func configureLUTLine(_ line: GFXMMULUTLine) -> HALStatus {
        precondition(line.lineNumber < 1024 && line.lineStatus <= 1)
        precondition(line.firstVisibleBlock < 256 && line.lastVisibleBlock < 256)
        precondition(line.lineOffset >= -255 && line.lineOffset <= 261888)
        if handle.read(.state) != 1 { return .error }
        if registers.read(.cr) & 0x8000 == 0 { return .error }
        let low = registers.address(of: .lut(index: Int(2 &* line.lineNumber)))
        let high = registers.address(of: .lut(index: Int((2 &* line.lineNumber) &+ 1)))
        if line.lineStatus == 1 {
            memory.write32(at: low, value: line.lineStatus | (line.firstVisibleBlock << 8) | (line.lastVisibleBlock << 16))
            memory.write32(at: high, value: UInt32(bitPattern: line.lineOffset))
        } else {
            memory.write32(at: low, value: 0)
            memory.write32(at: high, value: 0)
        }
        return .ok
    }
    @discardableResult
    public func modifyBuffers(_ buffers: GFXMMUBuffers) -> HALStatus {
        precondition(buffers.buffer0 & 15 == 0 && buffers.buffer1 & 15 == 0 &&
                     buffers.buffer2 & 15 == 0 && buffers.buffer3 & 15 == 0)
        if handle.read(.state) != 1 { return .error }
        registers.write(.b0cr, value: buffers.buffer0)
        registers.write(.b1cr, value: buffers.buffer1)
        registers.write(.b2cr, value: buffers.buffer2)
        registers.write(.b3cr, value: buffers.buffer3)
        return .ok
    }
    @discardableResult
    public func configurePacking(_ packing: GFXMMUPacking) -> HALStatus {
        precondition(packing.buffer0Enabled <= 1 && packing.buffer1Enabled <= 1 &&
                     packing.buffer2Enabled <= 1 && packing.buffer3Enabled <= 1)
        precondition(packing.buffer0Mode <= 1 && packing.buffer1Mode <= 1 &&
                     packing.buffer2Mode <= 1 && packing.buffer3Mode <= 1 && packing.defaultAlpha < 256)
        if handle.read(.state) != 1 { return .error }
        if registers.read(.cr) & 0x40 == 0 { return .error }
        var value: UInt32 = 0
        if packing.buffer0Enabled == 1 { value |= (packing.buffer0Mode << 25) | 0x0100_0000 }
        if packing.buffer1Enabled == 1 { value |= (packing.buffer1Mode << 27) | 0x0400_0000 }
        if packing.buffer2Enabled == 1 { value |= (packing.buffer2Mode << 29) | 0x1000_0000 }
        if packing.buffer3Enabled == 1 { value |= (packing.buffer3Mode << 31) | 0x4000_0000 }
        // The C driver performs two distinct read/modify/write operations.
        modifyControl(clear: 0xFF00_0000)
        modifyControl(set: value)
        registers.write(.dar, value: packing.defaultAlpha)
        return .ok
    }
    public func handleInterrupt() {
        let flags = registers.read(.sr)
        let interrupts = registers.read(.cr) & 0x1F
        let error = flags & interrupts
        if error != 0 {
            registers.write(.fcr, value: error)
            handle.write(.errorCode, value: handle.read(.errorCode) | error)
            invoke(.error)
        }
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 {
        let mask = memory.getPRIMASK()
        memory.disableIRQ()
        let error = handle.read(.errorCode)
        handle.write(.errorCode, value: 0)
        memory.setPRIMASK(mask)
        return error
    }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks {
            callbacks.write(.mspInitialize, value: nil)
            callbacks.write(.mspDeinitialize, value: nil)
        }
    }
    @discardableResult
    public func registerCallback(id: UInt32, callback: GFXMMUCallback?) -> HALStatus {
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
    public func registerCallback(id: GFXMMUCallbackID, callback: GFXMMUCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }
    @discardableResult
    public func unregisterCallback(id: GFXMMUCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    private func updateCallback(id: UInt32, callback: GFXMMUCallback?, useDefault: Bool) -> HALStatus {
        let valid: Bool
        if handle.read(.state) == 1 { valid = id <= 2 }
        else if handle.read(.state) == 0 { valid = id == 1 || id == 2 }
        else { valid = false }
        guard valid, let id = GFXMMUCallbackID(rawValue: id) else { return invalidCallback() }
        callbacks.write(id, value: useDefault ? defaults.callback(id) : callback)
        return .ok
    }
    private func invalidCallback() -> HALStatus {
        handle.write(.errorCode, value: handle.read(.errorCode) | 0x100)
        return .error
    }
    private func invoke(_ id: GFXMMUCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    private func modifyControl(clear: UInt32 = 0, set: UInt32 = 0) {
        registers.write(.cr, value: (registers.read(.cr) & ~clear) | set)
    }
}
