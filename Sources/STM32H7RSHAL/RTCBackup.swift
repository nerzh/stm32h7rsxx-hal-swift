// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


extension RTC {
    @discardableResult
    public func incrementMonotonicCounter(instance: UInt32 = 0) -> HALStatus {
        registers.writeTamper(.count1r, value: 0)
        return .ok
    }
    @discardableResult
    public func getMonotonicCounter(instance: UInt32 = 0, value: inout UInt32) -> HALStatus {
        value = registers.readTamper(.count1r)
        return .ok
    }
    public func writeBackup(_ index: UInt32, value: UInt32) {
        precondition(index < 32); registers.writeBackup(index, value: value)
    }
    public func readBackup(_ index: UInt32) -> UInt32 {
        precondition(index < 32); return registers.readBackup(index)
    }
    public func eraseBackup() { modifyTamper(.cr2, set: 0x800000) }
    public func blockBackup() { modifyTamper(.cr2, set: 0x400000) }
    public func unblockBackup() { modifyTamper(.cr2, clear: 0x400000) }
    public func configureEraseDeviceSecrets(_ value: UInt32) { modifyTamper(.rpcfgr, clear: 0x1, set: value) }
    @discardableResult
    public func lockBootHardwareKey() -> HALStatus { modifyTamper(.cfgr, set: 0x40000000); return .ok }
    @discardableResult
    public func setPrivilegeMode(_ c: RTCPrivilegeConfiguration) -> HALStatus {
        precondition(c.rtcFull == 0 || c.rtcFull == 0x8000)
        precondition(c.rtcFeatures & ~UInt32(0x600F) == 0)
        precondition(c.tamperFull == 0 || c.tamperFull == 0x80000000)
        precondition(c.monotonicCounter == 0 || c.monotonicCounter == 0x8000)
        precondition(c.backupZone & ~UInt32(0x40000000 | 0x20000000) == 0)
        precondition(c.backupStartZone2 < 32 && c.backupStartZone3 < 32)
        registers.write(.privcfgr, value: c.rtcFull | c.rtcFeatures)
        registers.writeTamper(.privcfgr, value: c.tamperFull | c.backupZone | c.monotonicCounter)
        modifyTamper(.cfgr, clear: 0xFF | 0xFF0000,
                     set: c.backupStartZone2 << 0x0 | c.backupStartZone3 << 0x10)
        return .ok
    }
    @discardableResult
    public func getPrivilegeMode(_ c: inout RTCPrivilegeConfiguration) -> HALStatus {
        let rtc = registers.read(.privcfgr)
        let tamp = registers.readTamper(.privcfgr)
        let cfgr = registers.readTamper(.cfgr)
        c.rtcFull = rtc & 0x8000
        c.rtcFeatures = rtc & 0x600F
        c.tamperFull = tamp & 0x80000000
        c.monotonicCounter = tamp & 0x8000
        c.backupZone = tamp & (0x40000000 | 0x20000000)
        c.backupStartZone2 = (cfgr & 0xFF) >> 0x0
        c.backupStartZone3 = (cfgr & 0xFF0000) >> 0x10
        return .ok
    }
}
