// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MDF {
    @discardableResult
    public func generateTrigger() -> HALStatus {
        if handle.read(.state) != 1 && handle.read(.state) != 2 { return .error }
        if registers.read(.gcr) & 1 == 1 { return .error }
        modify(.gcr, set: 1); return .ok
    }
    @discardableResult
    public func setDelay(_ delay: UInt32) -> HALStatus {
        precondition(delay <= 127)
        guard handle.read(.state) == 2 else { return .error }
        guard registers.read(.dlycr) & 0x80000000 != 0x80000000 else { return .error }
        modify(.dlycr, set: delay); return .ok
    }
    @discardableResult
    public func getDelay(_ value: UnsafeMutablePointer<UInt32>?) -> HALStatus {
        guard let value, handle.read(.state) == 2 else { return .error }
        value.pointee = registers.read(.dlycr) & 0x7F; return .ok
    }
    @discardableResult
    public func setGain(_ gain: Int32) -> HALStatus {
        precondition((-16...24).contains(gain))
        guard handle.read(.state) == 2 else { return .error }
        let encoded = gain < 0 ? UInt32(bitPattern: gain - 16) & 0x3F : UInt32(gain)
        modify(.dfltcicr, clear: 0x3F00000, set: encoded << 20); return .ok
    }
    @discardableResult
    public func getGain(_ value: UnsafeMutablePointer<Int32>?) -> HALStatus {
        guard let value, handle.read(.state) == 2 else { return .error }
        var encoded = (registers.read(.dfltcicr) & 0x3F00000) >> 20
        if encoded > 31 { encoded |= 0xFFFFFFC0; value.pointee = Int32(bitPattern: encoded) + 16 }
        else { value.pointee = Int32(encoded) }
        return .ok
    }
    @discardableResult
    public func getAcquisitionValue(_ value: UnsafeMutablePointer<Int32>?) -> HALStatus {
        guard let value else { return .error }
        if handle.read(.state) != 2 && handle.read(.state) != 1 { return .error }
        value.pointee = Int32(bitPattern: registers.read(.dfltdr)); return .ok
    }
    func canMonitorClockAbsence() -> Bool {
        if handle.read(.state) != 2 && handle.read(.state) != 1 { return false }
        if registers.read(.sitfcr) & 0x80000000 == 0 { return false }
        if registers.read(.sitfcr) & 0x30 != 0x10 { return false }
        return true
    }
    @discardableResult
    public func startClockAbsenceInterrupt() -> HALStatus {
        guard canMonitorClockAbsence() else { return .error }
        modify(.dfltisr, set: 0x400)
        if registers.read(.dfltisr) & 0x400 == 0x400 { return .error }
        modify(.dfltier, set: 0x400); return .ok
    }
    @discardableResult
    public func stopClockAbsenceInterrupt() -> HALStatus {
        guard canMonitorClockAbsence() else { return .error }
        modify(.dfltier, clear: 0x400); modify(.dfltisr, set: 0x400); return .ok
    }
}
