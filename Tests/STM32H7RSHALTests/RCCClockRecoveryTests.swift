import XCTest
@testable import STM32H7RSHAL

private enum CRSAccess: Equatable {
    case read(CRSRegister, UInt32), write(CRSRegister, UInt32), tick(UInt32)
    case callback(Int, UInt32)
}

private final class CRSRegisters: CRSRegisterIO {
    var values: [CRSRegister: UInt32] = [:]
    var scriptedReads: [CRSRegister: [UInt32]] = [:]
    var ticks: [UInt32] = []
    var accesses: [CRSAccess] = []

    func read(_ register: CRSRegister) -> UInt32 {
        let value: UInt32
        if var pending = scriptedReads[register], !pending.isEmpty {
            value = pending.removeFirst()
            scriptedReads[register] = pending
        } else { value = values[register, default: 0] }
        accesses.append(.read(register, value))
        return value
    }

    func write(_ register: CRSRegister, value: UInt32) {
        accesses.append(.write(register, value))
        values[register] = value
        if register == .icr {
            values[.isr, default: 0] &= ~(value & 0x0F)
            if value & 4 != 0 { values[.isr, default: 0] &= ~UInt32(0x700) }
        } else if register == .rccAPB1Reset2 && value & 2 != 0 {
            // CRS reset values from both pinned device SVDs. This models only
            // reset and W1C side effects, not automatic clock calibration.
            values[.cr] = 0x2000
            values[.cfgr] = 0x2022_BB7F
            values[.isr] = 0
            values[.icr] = 0
        }
    }

    func getTick() -> UInt32 {
        precondition(!ticks.isEmpty, "Unexpected tick read")
        let value = ticks.removeFirst()
        accesses.append(.tick(value))
        return value
    }
}

final class RCCClockRecoveryTests: XCTestCase {
    private typealias Driver = RCCClockRecovery<CRSRegisters>

    func testDefaultConfigurationResetsBeforeConfiguringAndEnabling() {
        let io = CRSRegisters()
        io.values = [.rccAPB1Reset2: 0xA5A5_5555, .cr: .max, .cfgr: .max, .isr: .max]
        Driver(registers: io).configure(.init())
        XCTAssertEqual(io.accesses, [
            .read(.rccAPB1Reset2, 0xA5A5_5555), .write(.rccAPB1Reset2, 0xA5A5_5557),
            .read(.rccAPB1Reset2, 0xA5A5_5557), .write(.rccAPB1Reset2, 0xA5A5_5555),
            .write(.cfgr, 0x2022_BB7F), .read(.cr, 0x2000), .write(.cr, 0x2000),
            .read(.cr, 0x2000), .write(.cr, 0x2060),
        ])
        XCTAssertEqual(io.values[.isr], 0)
    }

    func testConfigurationCoversEveryPrescalerSourcePolarityAndFieldEdges() {
        for divider in UInt32(0)...7 {
            for source in UInt32(0)...3 {
                for falling in [false, true] {
                    for high in [false, true] {
                        let io = CRSRegisters()
                        let config = CRSConfiguration(
                            prescaler: divider << 24, source: source << 28,
                            polarity: falling ? 0x8000_0000 : 0,
                            reloadValue: high ? 0xFFFF : 0,
                            errorLimitValue: high ? 0xFF : 0,
                            hsi48CalibrationValue: high ? 0x3F : 0)
                        Driver(registers: io).configure(config)
                        let packed = (divider << 24) | (source << 28)
                            | (falling ? 0x8000_0000 : 0) | (high ? 0x00FF_FFFF : 0)
                        XCTAssertEqual(io.values[.cfgr], packed)
                        XCTAssertEqual(io.values[.cr], high ? 0x3F60 : 0x60)
                        XCTAssertEqual(io.accesses.count, 9)
                    }
                }
            }
        }
    }

    func testInformationReadsEachFieldIncludingFreshErrorDirection() {
        let io = CRSRegisters()
        io.values = [.cfgr: 0xFFFF_1357, .cr: 0xFFFF_D5FF]
        io.scriptedReads[.isr] = [0x2468_0000, 0xFFFF_8000]
        let info = Driver(registers: io).getInfo()
        XCTAssertEqual(info, .init(reloadValue: 0x1357, hsi48CalibrationValue: 0x15,
                                   frequencyErrorCapture: 0x2468, frequencyErrorDirection: 0x8000))
        XCTAssertEqual(io.accesses, [.read(.cfgr, 0xFFFF_1357), .read(.cr, 0xFFFF_D5FF),
                                    .read(.isr, 0x2468_0000), .read(.isr, 0xFFFF_8000)])
    }

    func testWaitClearsAllErrorFlagsOnFirstIndividualError() {
        let io = CRSRegisters()
        io.values[.isr] = 0x70F
        io.ticks = [0, 1]
        let status = Driver(registers: io).wait(timeout: 10, getTick: io.getTick)
        XCTAssertEqual(status, [.syncOK, .syncWarning, .trimOverflow])
        XCTAssertEqual(io.accesses, [
            .tick(0), .tick(1), .read(.isr, 0x70F), .write(.icr, 1),
            .read(.isr, 0x70E), .write(.icr, 2), .read(.isr, 0x70C), .write(.icr, 4),
            .read(.isr, 8), .read(.isr, 8), .read(.isr, 8), .write(.icr, 8),
        ])
        XCTAssertEqual(io.values[.isr], 0)
    }

    func testWaitSeesNewFlagsBetweenIndividualChecks() {
        let io = CRSRegisters()
        io.ticks = [42, 42]
        io.scriptedReads[.isr] = [1, 2, 0x400, 0x100, 0x200, 8]
        XCTAssertEqual(Driver(registers: io).wait(timeout: 1, getTick: io.getTick),
                       [.syncOK, .syncWarning, .trimOverflow, .syncError, .syncMiss])
        XCTAssertEqual(io.accesses, [
            .tick(42), .tick(42), .read(.isr, 1), .write(.icr, 1),
            .read(.isr, 2), .write(.icr, 2), .read(.isr, 0x400), .write(.icr, 4),
            .read(.isr, 0x100), .write(.icr, 4), .read(.isr, 0x200), .write(.icr, 4),
            .read(.isr, 8), .write(.icr, 8),
        ])
    }

    func testWaitUsesStrictTimeoutAndWrappingTickSubtraction() {
        for start in [UInt32(100), UInt32.max] {
            let io = CRSRegisters()
            io.ticks = [start, start &+ 2, start &+ 3]
            XCTAssertEqual(Driver(registers: io).wait(timeout: 2, getTick: io.getTick), .timeout)
            var expected: [CRSAccess] = [.tick(start), .tick(start &+ 2)]
            expected += Array(repeating: .read(.isr, 0), count: 6)
            expected += [.tick(start &+ 3)]
            expected += Array(repeating: .read(.isr, 0), count: 6)
            XCTAssertEqual(io.accesses, expected)
        }
    }

    func testZeroTimeoutStillChecksFlagsAndCombinesTimeoutWithStatus() {
        let io = CRSRegisters()
        io.values[.isr] = 1
        io.ticks = [7, 7]
        XCTAssertEqual(Driver(registers: io).wait(timeout: 0, getTick: io.getTick), [.timeout, .syncOK])
        XCTAssertEqual(io.accesses, [.tick(7), .tick(7), .read(.isr, 1), .write(.icr, 1)]
            + Array(repeating: .read(.isr, 0), count: 5))
    }

    func testMaximumDelayReadsOnlyStartTickAndExpectedSyncDoesNotCompleteWait() {
        let io = CRSRegisters()
        io.ticks = [123]
        io.scriptedReads[.isr] = [8, 8, 8, 8, 8, 8, 1, 0, 0, 0, 0, 0]
        XCTAssertEqual(Driver(registers: io).wait(timeout: .max, getTick: io.getTick), .syncOK)
        var expected: [CRSAccess] = [.tick(123)]
        expected += Array(repeating: .read(.isr, 8), count: 6)
        expected += [.write(.icr, 8), .read(.isr, 1), .write(.icr, 1)]
        expected += Array(repeating: .read(.isr, 0), count: 5)
        XCTAssertEqual(io.accesses, expected)
    }

    func testErrorSummaryFlagAloneDoesNotEndPolling() {
        let io = CRSRegisters()
        io.values[.isr] = 4
        io.ticks = [0, 0]
        XCTAssertEqual(Driver(registers: io).wait(timeout: 0, getTick: io.getTick), .timeout)
        XCTAssertEqual(io.accesses, [.tick(0), .tick(0)] + Array(repeating: .read(.isr, 4), count: 6))
    }

    func testIRQUsesSingleSnapshotPriorityAndClearsBeforeCallback() {
        // callback IDs: 0=OK, 1=warning, 2=expected sync, 3=error.
        let cases: [(UInt32, UInt32, UInt32?, Int?, UInt32)] = [
            (0x70F, 0xF, 1, 0, 0), (0x70F, 0xE, 2, 1, 0),
            (0x70F, 0xC, 8, 2, 0), (0x70F, 4, 4, 3, 0x38),
            (0x700, 4, nil, nil, 0), (4, 4, 4, 3, 0),
            (1, 0, nil, nil, 0), (3, 2, 2, 1, 0),
        ]
        for (flags, sources, clear, callback, status) in cases {
            let io = CRSRegisters()
            io.values = [.isr: flags, .cr: sources]
            let record: (Int, UInt32) -> Void = { id, value in
                XCTAssertEqual(io.values[.icr], clear)
                io.accesses.append(.callback(id, value))
            }
            Driver(registers: io).handleInterrupt(syncOK: { record(0, 0) },
                syncWarning: { record(1, 0) }, expectedSync: { record(2, 0) },
                error: { record(3, $0.rawValue) })
            var expected: [CRSAccess] = [.read(.isr, flags), .read(.cr, sources)]
            if let clear, let callback { expected += [.write(.icr, clear), .callback(callback, status)] }
            XCTAssertEqual(io.accesses, expected)
        }
    }

    func testIRQCombinesEveryErrorCombinationFromSnapshot() {
        for errors in UInt32(0)...7 {
            let io = CRSRegisters()
            io.values = [.isr: (errors << 8) | 4, .cr: 4]
            var result: CRSStatus?
            Driver(registers: io).handleInterrupt(error: { result = $0 })
            XCTAssertEqual(result?.rawValue, errors << 3)
            XCTAssertEqual(io.values[.isr], 0)
            XCTAssertEqual(io.accesses, [.read(.isr, (errors << 8) | 4), .read(.cr, 4), .write(.icr, 4)])
        }
    }

    func testIRQCallbackCanHandleNextPendingSourceAfterFirstClear() {
        let io = CRSRegisters()
        io.values = [.isr: 3, .cr: 3]
        let driver = Driver(registers: io)
        driver.handleInterrupt(syncOK: {
            io.accesses.append(.callback(0, 0))
            driver.handleInterrupt(syncWarning: { io.accesses.append(.callback(1, 0)) })
        })
        XCTAssertEqual(io.accesses, [
            .read(.isr, 3), .read(.cr, 3), .write(.icr, 1), .callback(0, 0),
            .read(.isr, 2), .read(.cr, 3), .write(.icr, 2), .callback(1, 0),
        ])
    }

    func testMacroHelpersPreserveBitsAndUseDirectW1CClears() {
        let io = CRSRegisters()
        let driver = Driver(registers: io)
        io.values[.cr] = 0xA5A5_0000
        driver.enableInterrupts(0xF)
        driver.disableInterrupts(5)
        driver.enableFrequencyErrorCounter()
        driver.disableFrequencyErrorCounter()
        driver.enableAutomaticCalibration()
        driver.disableAutomaticCalibration()
        driver.softwareSync()
        XCTAssertEqual(io.accesses, [
            .read(.cr, 0xA5A5_0000), .write(.cr, 0xA5A5_000F),
            .read(.cr, 0xA5A5_000F), .write(.cr, 0xA5A5_000A),
            .read(.cr, 0xA5A5_000A), .write(.cr, 0xA5A5_002A),
            .read(.cr, 0xA5A5_002A), .write(.cr, 0xA5A5_000A),
            .read(.cr, 0xA5A5_000A), .write(.cr, 0xA5A5_004A),
            .read(.cr, 0xA5A5_004A), .write(.cr, 0xA5A5_000A),
            .read(.cr, 0xA5A5_000A), .write(.cr, 0xA5A5_008A),
        ])
        io.accesses = []
        for mask in [UInt32(1), 2, 4, 8, 0x100, 0x200, 0x400, 0x70B] { driver.clearFlag(mask) }
        driver.clearInterrupt(0xD)
        XCTAssertEqual(io.accesses, [.write(.icr, 1), .write(.icr, 2), .write(.icr, 4),
                                    .write(.icr, 8), .write(.icr, 4), .write(.icr, 4),
                                    .write(.icr, 4), .write(.icr, 0xF), .write(.icr, 0xD)])
    }

    func testInterruptSourceUsesAnyBitWhileFlagRequiresAllBits() {
        let io = CRSRegisters()
        io.values = [.cr: 1, .isr: 1]
        let driver = Driver(registers: io)
        XCTAssertTrue(driver.getInterruptSource(3))
        XCTAssertFalse(driver.getFlag(3))
        XCTAssertFalse(driver.getInterruptSource(0))
        XCTAssertTrue(driver.getFlag(0))
        XCTAssertEqual(io.accesses, [.read(.cr, 1), .read(.isr, 1), .read(.cr, 1), .read(.isr, 1)])
    }

    func testReloadFormulaUsesIntegerDivisionAndUnsignedSubtraction() {
        XCTAssertEqual(Driver.reloadValue(targetFrequency: 48_000_000, synchronizationFrequency: 1_000), 47_999)
        XCTAssertEqual(Driver.reloadValue(targetFrequency: 48_000_000, synchronizationFrequency: 32_768), 1_463)
        XCTAssertEqual(Driver.reloadValue(targetFrequency: 1_000, synchronizationFrequency: 1_000), 0)
        XCTAssertEqual(Driver.reloadValue(targetFrequency: 999, synchronizationFrequency: 1_000), UInt32.max)
    }
}
