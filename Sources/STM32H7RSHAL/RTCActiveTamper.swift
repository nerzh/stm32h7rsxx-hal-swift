// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.


extension RTC {
    @discardableResult
    public func setActiveTampers(_ c: RTCActiveTampersConfiguration, getTick: () -> UInt32) -> HALStatus {
        if registers.readTamper(.ator) & 0x8000 != 0 { deactivateActiveTampers() }
        let cr = registers.read(.cr)
        if cr & 0x2000000 != c.timestampOnDetection { modify(.cr, clear: 0x2000000, set: c.timestampOnDetection) }
        var cr1 = registers.readTamper(.cr1)
        var cr2 = registers.readTamper(.cr2)
        var atcr2: UInt32 = 0
        var ier = registers.readTamper(.ier)
        var atcr1 = c.filter | c.outputChangePeriod << 0x18 | c.asynchronousPrescaler
        for i in 0..<8 {
            let input = c.inputs[i]
            if input.enable != 0 {
                cr1 |= UInt32(0x1) << i
                atcr1 |= UInt32(0x1) << i
                if input.interrupt != 0 { ier |= UInt32(0x1) << i }
                if input.maskFlag != 0 { cr2 |= UInt32(0x10000) << i }
                if input.noErase != 0 { cr2 |= UInt32(0x1) << i }
                atcr2 |= input.output << (3 * i + 0x8)
                if UInt32(i) != input.output { atcr1 |= 0x40000000 }
            }
        }
        registers.writeTamper(.ier, value: ier)
        registers.writeTamper(.atcr1, value: atcr1)
        registers.writeTamper(.atcr2, value: atcr2)
        registers.writeTamper(.cr2, value: cr2)
        registers.writeTamper(.cr1, value: cr1)
        for i in 0..<4 { registers.writeTamper(.atseedr, value: c.seed[i]) }
        return waitForActiveSeed(getTick: getTick)
    }
    @discardableResult
    public func setActiveSeed(_ seed: UnsafePointer<UInt32>, getTick: () -> UInt32) -> HALStatus {
        if registers.readTamper(.ator) & 0x8000 == 0 { return .error }
        for i in 0..<4 { registers.writeTamper(.atseedr, value: seed[i]) }
        return waitForActiveSeed(getTick: getTick)
    }
    private func waitForActiveSeed(getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        while registers.readTamper(.ator) & 0x4000 != 0 {
            if getTick() &- start > 0x3E8 {
                if registers.readTamper(.ator) & 0x4000 != 0 {
                    handle.write(.state, value: RTCState.timeout.rawValue)
                    return .timeout
                } else { break }
            }
        }
        return .ok
    }
    @discardableResult
    public func deactivateActiveTampers() -> HALStatus {
        let mask = registers.readTamper(.atcr1) & 0xFF
        modifyTamper(.cr1, clear: mask)
        registers.writeTamper(.scr, value: mask)
        modifyTamper(.cr2, clear: mask | (mask & (0x1 | 0x2 | 0x4)) << 0x10)
        modifyTamper(.ier, clear: mask)
        registers.writeTamper(.atcr1, value: 0x10000 | 0x20000 | 0x40000)
        registers.writeTamper(.atcr2, value: 0)
        return .ok
    }
}
