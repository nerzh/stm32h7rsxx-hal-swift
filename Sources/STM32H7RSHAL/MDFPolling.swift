// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MDF {
    func waitForFlag(_ flag: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        var status = HALStatus.ok
        let start = getTick()
        // Keep the flag read before the status test, including after timeout.
        while registers.read(.dfltisr) & flag != flag && status == .ok {
            if timeout != .max && (getTick() &- start > timeout || timeout == 0) { status = .timeout }
        }
        return status
    }
    @discardableResult
    public func pollForAcquisition(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        guard handle.read(.state) == 2 else { return .error }
        let status = waitForFlag(8, timeout: timeout, getTick: getTick)
        let flags = registers.read(.dfltisr) & 0xA02
        if flags != 0 {
            if flags & 2 == 2 { addError(1) }
            if flags & 0x200 == 0x200 { addError(16) }
            if flags & 0x800 == 0x800 { addError(2) }
            modify(.dfltisr, set: flags); invoke(.error)
        }
        if status == .ok && registers.read(.dfltcr) & 0x70 == 0x10 { handle.write(.state, value: 1) }
        return status
    }
    @discardableResult
    public func pollForSoundLevel(timeout: UInt32, soundLevel: UnsafeMutablePointer<UInt32>?, ambientNoise: UnsafeMutablePointer<UInt32>?, getTick: () -> UInt32) -> HALStatus {
        guard let soundLevel, let ambientNoise, handle.read(.state) == 2 else { return .error }
        guard registers.read(.sadcr) & 0x80000000 != 0 else { return .error }
        let status = waitForFlag(0x2000, timeout: timeout, getTick: getTick)
        if status == .ok {
            soundLevel.pointee = registers.read(.sadsdlvr); ambientNoise.pointee = registers.read(.sadanlvr)
            modify(.dfltisr, set: 0x2000)
        }
        return status
    }
    @discardableResult
    public func pollForSoundActivity(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        guard handle.read(.state) == 2 else { return .error }
        guard registers.read(.sadcr) & 0x80000000 != 0 else { return .error }
        let status = waitForFlag(0x1000, timeout: timeout, getTick: getTick)
        if status == .ok { modify(.dfltisr, set: 0x1000) }
        return status
    }
    @discardableResult
    public func pollForClockAbsence(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        guard canMonitorClockAbsence() else { return .error }
        let status = waitForFlag(0x400, timeout: timeout, getTick: getTick)
        if status == .ok { modify(.dfltisr, set: 0x400) }
        return status
    }
}
