// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


extension RTC {
    @discardableResult
    public func setTamper(_ configuration: RTCTamperConfiguration) -> HALStatus { setTamper(configuration, interrupt: false) }
    @discardableResult
    public func setTamperIT(_ configuration: RTCTamperConfiguration) -> HALStatus { setTamper(configuration, interrupt: true) }
    private func setTamper(_ configuration: RTCTamperConfiguration, interrupt: Bool) -> HALStatus {
        let c = configuration
        precondition(c.tamper != 0 && c.tamper & ~UInt32(0xFF) == 0)
        precondition(c.trigger <= 3 && c.noErase <= 1 && c.maskFlag <= 1)
        precondition(!interrupt || c.maskFlag == 0)
        precondition(interrupt || c.maskFlag == 0 || c.tamper <= 0x4)
        precondition(c.timestampOnDetection == 0 || c.timestampOnDetection == 0x2000000)
        precondition(c.filter & ~UInt32(0x18) == 0 && c.samplingFrequency <= 7)
        precondition(c.prechargeDuration & ~UInt32(0x60) == 0 && (c.pullUp == 0 || c.pullUp == 0x80))
        precondition(c.filter == 0 ? c.trigger <= 1 : c.trigger >= 2)
        var word = registers.readTamper(.cr2)
        word &= ~(c.tamper << 0x18 | c.tamper << 0x10 | c.tamper << 0x0)
        if c.trigger == 0x3 || c.trigger == 0x1 {
            word |= c.tamper << 0x18
        }
        if !interrupt && c.maskFlag != 0 { word |= c.tamper << 0x10 }
        if c.noErase != 0 { word |= c.tamper << 0x0 }
        registers.writeTamper(.cr2, value: word)
        registers.writeTamper(.fltcr, value: c.filter | c.samplingFrequency | c.prechargeDuration | c.pullUp)
        if registers.read(.cr) & 0x2000000 != c.timestampOnDetection {
            modify(.cr, clear: 0x2000000, set: c.timestampOnDetection)
        }
        if interrupt { modifyTamper(.ier, set: c.tamper) }
        modifyTamper(.cr1, set: c.tamper)
        return .ok
    }
    @discardableResult
    public func deactivateTamper(_ mask: UInt32) -> HALStatus {
        precondition(mask != 0 && mask & ~UInt32(0xFF) == 0)
        modifyTamper(.cr1, clear: mask)
        registers.writeTamper(.scr, value: mask)
        modifyTamper(.cr2, clear: mask << 0x18 | mask << 0x10 | mask << 0x0)
        modifyTamper(.ier, clear: mask)
        return .ok
    }
    @discardableResult
    public func setInternalTamper(_ configuration: RTCInternalTamperConfiguration) -> HALStatus {
        setInternalTamper(configuration, interrupt: false)
    }
    @discardableResult
    public func setInternalTamperIT(_ configuration: RTCInternalTamperConfiguration) -> HALStatus {
        setInternalTamper(configuration, interrupt: true)
    }
    private func setInternalTamper(_ c: RTCInternalTamperConfiguration, interrupt: Bool) -> HALStatus {
        precondition(c.tamper != 0 && c.tamper & ~UInt32(0x45FF0000) == 0)
        precondition(c.noErase <= 1 && (c.timestampOnDetection == 0 || c.timestampOnDetection == 0x2000000))
        if registers.read(.cr) & 0x2000000 != c.timestampOnDetection {
            modify(.cr, clear: 0x2000000, set: c.timestampOnDetection)
        }
        if interrupt { modifyTamper(.ier, set: c.tamper) }
        let mask = c.tamper >> (0x10 - 0x0)
        if c.noErase != 0 { modifyTamper(.cr3, set: mask) } else { modifyTamper(.cr3, clear: mask) }
        modifyTamper(.cr1, set: c.tamper)
        return .ok
    }
    @discardableResult
    public func deactivateInternalTamper(_ mask: UInt32) -> HALStatus {
        precondition(mask != 0 && mask & ~UInt32(0x45FF0000) == 0)
        modifyTamper(.cr1, clear: mask)
        modifyTamper(.ier, clear: mask)
        registers.writeTamper(.scr, value: mask)
        return .ok
    }
    public func pollForTamper(_ mask: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        precondition(mask != 0 && mask & ~UInt32(0xFF) == 0)
        return pollTamper(mask, timeout: timeout, getTick: getTick)
    }
    public func pollForInternalTamper(_ mask: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        precondition(mask != 0 && mask & ~UInt32(0x45FF0000) == 0)
        return pollTamper(mask, timeout: timeout, getTick: getTick)
    }
    private func pollTamper(_ mask: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        while registers.readTamper(.sr) & mask != mask {
            if timeout != UInt32.max {
                if getTick() &- start > timeout || timeout == 0 {
                    if registers.readTamper(.sr) & mask != mask { return .timeout } else { break }
                }
            }
        }
        registers.writeTamper(.scr, value: mask)
        return .ok
    }
    public func tamperIRQHandler() {
        let status = registers.readTamper(.misr)
        for i: UInt32 in 0..<8 {
            if status & (UInt32(1) << i) != 0 { invoke(RTCCallbackID(rawValue: 5 + i)!) }
        }
        for i: UInt32 in 0..<9 {
            if status & (UInt32(0x10000) << i) != 0 { invoke(RTCCallbackID(rawValue: 13 + i)!) }
        }
        if status & 0x4000000 != 0 { invoke(.internalTamper11) }
        if status & 0x40000000 != 0 { invoke(.internalTamper15) }
        registers.writeTamper(.scr, value: status)
    }
}
