// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRS functions and macros from stm32h7rsxx_hal_rcc_ex.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum CRSRegister: Hashable, CaseIterable { case cr, cfgr, isr, icr, rccAPB1Reset2 }

public protocol CRSRegisterIO {
    func read(_ register: CRSRegister) -> UInt32
    func write(_ register: CRSRegister, value: UInt32)
}

public struct CRSStatus: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let timeout = Self(rawValue: 0x01)
    public static let syncOK = Self(rawValue: 0x02)
    public static let syncWarning = Self(rawValue: 0x04)
    public static let syncError = Self(rawValue: 0x08)
    public static let syncMiss = Self(rawValue: 0x10)
    public static let trimOverflow = Self(rawValue: 0x20)
}

// Prescaler = divider exponent (0...7) << 24. Source = GPIO/LSE/USB FS/USB HS
// encoded as 0...3 << 28. Polarity = 0 (rising) or 0x80000000 (falling).
// Default values are the HAL constants for 48 MHz / 1 kHz synchronization.
public struct CRSConfiguration: Equatable, Sendable {
    public var prescaler: UInt32
    public var source: UInt32
    public var polarity: UInt32
    public var reloadValue: UInt32
    public var errorLimitValue: UInt32
    public var hsi48CalibrationValue: UInt32

    public init(prescaler: UInt32 = 0, source: UInt32 = 0x2000_0000,
                polarity: UInt32 = 0, reloadValue: UInt32 = 0xBB7F,
                errorLimitValue: UInt32 = 0x22, hsi48CalibrationValue: UInt32 = 0x20) {
        self.prescaler = prescaler
        self.source = source
        self.polarity = polarity
        self.reloadValue = reloadValue
        self.errorLimitValue = errorLimitValue
        self.hsi48CalibrationValue = hsi48CalibrationValue
    }
}

public struct CRSSynchronizationInfo: Equatable, Sendable {
    public var reloadValue: UInt32
    public var hsi48CalibrationValue: UInt32
    public var frequencyErrorCapture: UInt32
    // The C encoding is retained: 0 = upcounting, 0x8000 = downcounting.
    public var frequencyErrorDirection: UInt32

    public init(reloadValue: UInt32 = 0, hsi48CalibrationValue: UInt32 = 0,
                frequencyErrorCapture: UInt32 = 0, frequencyErrorDirection: UInt32 = 0) {
        self.reloadValue = reloadValue
        self.hsi48CalibrationValue = hsi48CalibrationValue
        self.frequencyErrorCapture = frequencyErrorCapture
        self.frequencyErrorDirection = frequencyErrorDirection
    }
}

public struct RCCClockRecovery<IO: CRSRegisterIO> {
    public let registers: IO
    public init(registers: IO) { self.registers = registers }

    public func configure(_ configuration: CRSConfiguration) {
        precondition(configuration.prescaler & ~UInt32(0x0700_0000) == 0)
        precondition(configuration.source & ~UInt32(0x3000_0000) == 0)
        precondition(configuration.polarity == 0 || configuration.polarity == 0x8000_0000)
        precondition(configuration.reloadValue <= 0xFFFF)
        precondition(configuration.errorLimitValue <= 0xFF)
        precondition(configuration.hsi48CalibrationValue <= 0x3F)

        modify(.rccAPB1Reset2, clear: 0, set: 2)
        modify(.rccAPB1Reset2, clear: 2, set: 0)
        var value = configuration.prescaler | configuration.source | configuration.polarity
        value |= configuration.reloadValue
        value |= configuration.errorLimitValue << 16
        registers.write(.cfgr, value: value)
        modify(.cr, clear: 0x3F00, set: configuration.hsi48CalibrationValue << 8)
        modify(.cr, clear: 0, set: 0x60)
    }

    public func softwareSync() { modify(.cr, clear: 0, set: 0x80) }

    public func getInfo() -> CRSSynchronizationInfo {
        var info = CRSSynchronizationInfo()
        info.reloadValue = registers.read(.cfgr) & 0xFFFF
        info.hsi48CalibrationValue = (registers.read(.cr) & 0x3F00) >> 8
        info.frequencyErrorCapture = (registers.read(.isr) & 0xFFFF_0000) >> 16
        info.frequencyErrorDirection = registers.read(.isr) & 0x8000
        return info
    }

    public func wait(timeout: UInt32, getTick: () -> UInt32) -> CRSStatus {
        var status: CRSStatus = []
        let start = getTick()
        repeat {
            if timeout != UInt32.max {
                if (getTick() &- start) > timeout || timeout == 0 {
                    status = .timeout
                }
            }
            if getFlag(1) {
                status.insert(.syncOK)
                clearFlag(1)
            }
            if getFlag(2) {
                status.insert(.syncWarning)
                clearFlag(2)
            }
            if getFlag(0x400) {
                status.insert(.trimOverflow)
                clearFlag(0x400)
            }
            if getFlag(0x100) {
                status.insert(.syncError)
                clearFlag(0x100)
            }
            if getFlag(0x200) {
                status.insert(.syncMiss)
                clearFlag(0x200)
            }
            if getFlag(8) { clearFlag(8) }
        } while status.isEmpty
        return status
    }

    public func handleInterrupt(syncOK: () -> Void = {}, syncWarning: () -> Void = {},
                                expectedSync: () -> Void = {}, error: (CRSStatus) -> Void = { _ in }) {
        var errors: CRSStatus = []
        let flags = registers.read(.isr)
        let sources = registers.read(.cr)
        if flags & 1 != 0 && sources & 1 != 0 {
            registers.write(.icr, value: 1)
            syncOK()
        } else if flags & 2 != 0 && sources & 2 != 0 {
            registers.write(.icr, value: 2)
            syncWarning()
        } else if flags & 8 != 0 && sources & 8 != 0 {
            registers.write(.icr, value: 8)
            expectedSync()
        } else {
            if flags & 4 != 0 && sources & 4 != 0 {
                if flags & 0x100 != 0 { errors.insert(.syncError) }
                if flags & 0x200 != 0 { errors.insert(.syncMiss) }
                if flags & 0x400 != 0 { errors.insert(.trimOverflow) }
                registers.write(.icr, value: 4)
                error(errors)
            }
        }
    }

    // Interrupt masks: SYNCOK=1, SYNCWARN=2, ERR=4, ESYNC=8. All three
    // individual error interrupt names in C alias the common ERR source.
    public func enableInterrupts(_ mask: UInt32) { modify(.cr, clear: 0, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { modify(.cr, clear: mask, set: 0) }
    public func getInterruptSource(_ mask: UInt32) -> Bool { registers.read(.cr) & mask != 0 }
    public func clearInterrupt(_ mask: UInt32) {
        registers.write(.icr, value: mask & 4 != 0 ? 4 | (mask & ~UInt32(4)) : mask)
    }

    // Flag masks additionally include SYNCERR=0x100, SYNCMISS=0x200 and
    // TRIMOVF=0x400. Clearing any individual error clears all three in hardware.
    public func getFlag(_ mask: UInt32) -> Bool { registers.read(.isr) & mask == mask }
    public func clearFlag(_ mask: UInt32) {
        registers.write(.icr, value: mask & 0x700 != 0 ? 4 | (mask & ~UInt32(0x700)) : mask)
    }
    public func enableFrequencyErrorCounter() { modify(.cr, clear: 0, set: 0x20) }
    public func disableFrequencyErrorCounter() { modify(.cr, clear: 0x20, set: 0) }
    public func enableAutomaticCalibration() { modify(.cr, clear: 0, set: 0x40) }
    public func disableAutomaticCalibration() { modify(.cr, clear: 0x40, set: 0) }

    public static func reloadValue(targetFrequency: UInt32, synchronizationFrequency: UInt32) -> UInt32 {
        precondition(synchronizationFrequency != 0)
        return (targetFrequency / synchronizationFrequency) &- 1
    }

    private func modify(_ register: CRSRegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
}
