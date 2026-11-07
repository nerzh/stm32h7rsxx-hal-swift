// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DCMIPP pipe operations from stm32h7rsxx_hal_dcmipp.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DCMIPP {
    @discardableResult
    public func configureCrop(_ c: DCMIPPCropConfiguration, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0 && DCMIPPCropArea(rawValue: c.area) != nil)
        precondition(c.horizontalStart <= 0xFFF && c.verticalStart <= 0xFFF)
        precondition(c.horizontalSize >= 1 && c.horizontalSize <= 0xFFF && c.verticalSize >= 1 && c.verticalSize <= 0xFFF)
        if handle.read(.state) != 2 { return .error }
        let control = registers.read(.prcr)
        if control & 0x4000 == 0x4000 && control & 0xFF0000 == 0 { return .error }
        modify(.p0scstr, clear: 0x0FFF0FFF, set: c.horizontalStart | (c.verticalStart << 16))
        modify(.p0scszr, clear: 0x4FFF0FFF, set: c.horizontalSize | (c.verticalSize << 16) | c.area)
        return .ok
    }
    @discardableResult
    public func enableCrop(pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if handle.read(.state) != 2 { return .error }
        let control = registers.read(.prcr)
        if control & 0x4000 == 0x4000 && control & 0xFF0000 == 0 { return .error }
        modify(.p0scszr, set: 0x80000000)
        return .ok
    }
    @discardableResult
    public func disableCrop(pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0); modify(.p0scszr, clear: 0x80000000); return .ok
    }
    @discardableResult
    public func configureByteDecimation(start: DCMIPPByteSelectionStart, mode: DCMIPPByteSelection, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        let width = registers.read(.prcr) & 0x1C00
        if (start == .even && mode.rawValue > 0) || (mode.rawValue > 0x80 && width != 0) { return .error }
        modify(.p0ppcr, clear: 0x380, set: start.rawValue | mode.rawValue)
        return .ok
    }
    @discardableResult
    public func configureLineDecimation(start: DCMIPPLineSelectionStart, mode: DCMIPPLineSelection, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if start == .even && mode == .alternate { return .error }
        modify(.p0ppcr, clear: 0xC00, set: start.rawValue | mode.rawValue)
        return .ok
    }
    @discardableResult
    public func enableLimitEvent(_ limit: UInt32, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0 && limit >= 1 && limit <= 0xFFFFFF)
        registers.write(.p0dclmtr, value: limit | 0x80000000); enableInterrupts(0x4000)
        return .ok
    }
    @discardableResult
    public func disableLimitEvent(pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        modify(.p0dclmtr, clear: 0x80000000); disableInterrupts(0x4000)
        return .ok
    }
    @discardableResult
    public func setFrameRate(_ rate: DCMIPPFrameRate, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0); modify(.p0fctcr, clear: 3, set: rate.rawValue); return .ok
    }
    @discardableResult
    public func setCaptureMode(_ mode: DCMIPPCaptureMode, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0); modify(.p0fctcr, clear: 4, set: mode.rawValue); return .ok
    }
    @discardableResult
    public func enableCapture(pipe: UInt32 = 0) -> HALStatus {
        if pipe != 0 { return .error }
        modify(.p0fctcr, set: 8); return .ok
    }
    @discardableResult
    public func setMemoryAddress(_ address: UInt32, memory: DCMIPPMemory, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if memory == .first { registers.write(.p0ppm0ar1, value: address) }
        else {
            if registers.read(.p0ppcr) & 0x10000 != 0x10000 { return .error }
            registers.write(.p0ppm0ar2, value: address)
        }
        return .ok
    }
    @discardableResult
    public func setInputPixelFormat(_ format: DCMIPPFormat, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0); modify(.prcr, clear: 0xFF0000, set: format.rawValue); return .ok
    }
    @discardableResult
    public func setSyncUnmask(_ codes: UInt32) -> HALStatus {
        if handle.read(.state) != 2 { return .error }
        if registers.read(.prcr) & 0x10 != 0x10 { return .error }
        registers.write(.presur, value: codes); return .ok
    }
    @discardableResult
    public func enableLineEvent(_ interval: DCMIPPLineEventInterval, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        modify(.p0ppcr, clear: 0xE000, set: interval.rawValue); enableInterrupts(0x100)
        return .ok
    }
    @discardableResult
    public func disableLineEvent(pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0); disableInterrupts(0x100); return .ok
    }
    @discardableResult
    public func resetFrameCounter(pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if handle.read(.state) != 2 { return .error }
        modify(.cmcr, set: 0x10); return .ok
    }
    @discardableResult
    public func readFrameCounter(_ counter: inout UInt32, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if handle.read(.state) != 2 { return .error }
        counter = registers.read(.cmfrcr); return .ok
    }
    @discardableResult
    public func readDataCounter(_ counter: inout UInt32, pipe: UInt32 = 0) -> HALStatus {
        precondition(pipe == 0)
        if handle.read(.state) != 2 { return .error }
        counter = registers.read(.p0dccntr); return .ok
    }
}
