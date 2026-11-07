import XCTest
import CRCCExtendedReference
@testable import STM32H7RSHAL

// The C layer supplies hardware stimuli and observations only on the Swift side.
// Every driver operation and callback reentry below runs the Swift implementation.
private final class CRSDifferentialIO: CRSRegisterIO {
    var state = CRCCExtendedState()
    var driver: RCCClockRecovery<CRSDifferentialIO> { .init(registers: self) }

    init() { CRCCExtended_Reset(&state) }

    static func register(_ register: CRSRegister) -> CRCCExtendedRegister {
        switch register {
        case .cr: return CRCCExtended_CRS_CR
        case .cfgr: return CRCCExtended_CRS_CFGR
        case .isr: return CRCCExtended_CRS_ISR
        case .icr: return CRCCExtended_CRS_ICR
        case .rccAPB1Reset2: return CRCCExtended_APB1RSTR2
        }
    }

    func read(_ register: CRSRegister) -> UInt32 {
        CRCCExtended_Read(&state, Self.register(register))
    }
    func write(_ register: CRSRegister, value: UInt32) {
        CRCCExtended_Write(&state, Self.register(register), value)
    }
    func getTick() -> UInt32 { CRCCExtended_Tick(&state) }

    func record(_ id: CRCCExtendedCallbackID, _ argument: UInt32 = 0) {
        CRCCExtended_RecordCallback(&state, id, argument)
        let bit: UInt32 = 1 << id.rawValue
        if state.crsIRQReentryMask & bit != 0 {
            state.crsIRQReentryMask &= ~bit
            interrupt()
        }
    }

    func interrupt() {
        driver.handleInterrupt(syncOK: { self.record(CRCCExtended_CRSSyncOKCallback) },
            syncWarning: { self.record(CRCCExtended_CRSSyncWarningCallback) },
            expectedSync: { self.record(CRCCExtended_CRSExpectedSyncCallback) },
            error: { self.record(CRCCExtended_CRSErrorCallback, $0.rawValue) })
    }
}

final class CRSDifferentialTests: XCTestCase {
    private func pair(_ setup: (inout CRCCExtendedState) -> Void = { _ in })
        -> (CRSDifferentialIO, CRSDifferentialIO) {
        let actual = CRSDifferentialIO()
        setup(&actual.state)
        let reference = CRSDifferentialIO()
        reference.state = actual.state
        return (actual, reference)
    }

    private func assertMatches(_ actual: CRSDifferentialIO, _ reference: CRSDifferentialIO,
                               _ context: String = "", file: StaticString = #filePath, line: UInt = #line) {
        for index in UInt32(0)..<CRCCExtended_RegisterCount.rawValue {
            let register = CRCCExtendedRegister(rawValue: index)
            XCTAssertEqual(CRCCExtended_Get(&actual.state, register), CRCCExtended_Get(&reference.state, register),
                           "\(context), register \(index)", file: file, line: line)
            // Unlike the core RCC frequency functions, every C CRS read goes
            // through a macro hook, including both IRQ snapshot registers.
            XCTAssertEqual(CRCCExtended_ReadCount(&actual.state, register), CRCCExtended_ReadCount(&reference.state, register),
                           "\(context), read count \(index)", file: file, line: line)
        }
        XCTAssertEqual([actual.state.tick, actual.state.tickCalls, actual.state.totalReadCalls,
                        actual.state.crsResetCount, actual.state.backupResetCount, actual.state.crsIRQReentryMask],
                       [reference.state.tick, reference.state.tickCalls, reference.state.totalReadCalls,
                        reference.state.crsResetCount, reference.state.backupResetCount, reference.state.crsIRQReentryMask],
                       context, file: file, line: line)
        XCTAssertEqual(actual.state.writeCount, reference.state.writeCount, context, file: file, line: line)
        for index in UInt32(0)..<min(actual.state.writeCount, reference.state.writeCount) {
            let a = CRCCExtended_GetWrite(&actual.state, index)
            let e = CRCCExtended_GetWrite(&reference.state, index)
            XCTAssertEqual([a.reg.rawValue, a.value, a.tickCall], [e.reg.rawValue, e.value, e.tickCall],
                           "\(context), write \(index)", file: file, line: line)
        }
        XCTAssertEqual(actual.state.callbackCount, reference.state.callbackCount, context, file: file, line: line)
        for index in UInt32(0)..<min(actual.state.callbackCount, reference.state.callbackCount) {
            func fields(_ entry: CRCCExtendedCallback) -> [UInt32] {
                [entry.callbackID.rawValue, entry.argument, entry.tickCall, entry.writeCount,
                 entry.crsCR, entry.crsCFGR, entry.crsISR, entry.crsICR,
                 entry.rccBDCR, entry.rccCIER, entry.rccCIFR, entry.rccCICR, entry.extiPR1]
            }
            XCTAssertEqual(fields(CRCCExtended_GetCallback(&actual.state, index)),
                           fields(CRCCExtended_GetCallback(&reference.state, index)),
                           "\(context), callback \(index)", file: file, line: line)
        }
    }

    private func wait(_ actual: CRSDifferentialIO, _ reference: CRSDifferentialIO,
                       timeout: UInt32, context: String = "", file: StaticString = #filePath, line: UInt = #line) -> CRSStatus {
        let status = actual.driver.wait(timeout: timeout, getTick: actual.getTick)
        XCTAssertEqual(status.rawValue, CRCCExtended_WaitCRSSynchronization(&reference.state, timeout),
                       context, file: file, line: line)
        assertMatches(actual, reference, context, file: file, line: line)
        return status
    }

    private static func flags(_ combination: UInt32) -> UInt32 {
        // Bits 0...3 are summary/status flags; bits 4...6 are individual errors.
        (combination & 15) | ((combination & 0x70) << 4)
    }

    func testConfigurationAllEncodingsAndNumericEdgesMatchOriginalC() {
        let fields: [(UInt32, UInt32, UInt32)] = [(0, 0, 0), (0xFFFF, 0xFF, 0x3F), (0xBB7F, 0x22, 0x20)]
        for divider in UInt32(0)...7 {
            for source in UInt32(0)...3 {
                for polarity in [UInt32(0), 0x8000_0000] {
                    for (reload, limit, trim) in fields {
                        let config = CRSConfiguration(prescaler: divider << 24, source: source << 28,
                            polarity: polarity, reloadValue: reload, errorLimitValue: limit, hsi48CalibrationValue: trim)
                        var cConfig = RCC_CRSInitTypeDef(Prescaler: config.prescaler, Source: config.source,
                            Polarity: polarity, ReloadValue: reload, ErrorLimitValue: limit, HSI48CalibrationValue: trim)
                        let (actual, reference) = pair {
                            CRCCExtended_Set(&$0, CRCCExtended_CRS_CR, 0xFFFF_FFFF)
                            CRCCExtended_Set(&$0, CRCCExtended_CRS_CFGR, 0xFFFF_FFFF)
                            CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, 0xFFFF_FFFF)
                            CRCCExtended_Set(&$0, CRCCExtended_APB1RSTR2, 0xA5A5_5555)
                        }
                        actual.driver.configure(config)
                        CRCCExtended_ConfigureCRS(&reference.state, &cConfig)
                        assertMatches(actual, reference, "divider \(divider), source \(source), polarity \(polarity), trim \(trim)")
                    }
                }
            }
        }
    }

    func testSoftwareSyncAndReadbackRawFieldsMatchOriginalC() {
        var seed: UInt32 = 0x61C4_A9D3
        func next() -> UInt32 { seed = seed &* 1_664_525 &+ 1_013_904_223; return seed }
        for iteration in 0..<128 {
            let cr = next(), cfgr = next(), isr = next()
            let (actual, reference) = pair {
                CRCCExtended_Set(&$0, CRCCExtended_CRS_CR, cr)
                CRCCExtended_Set(&$0, CRCCExtended_CRS_CFGR, cfgr)
                CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, isr)
            }
            actual.driver.softwareSync()
            CRCCExtended_GenerateCRSSoftwareSync(&reference.state)
            let info = actual.driver.getInfo()
            var cInfo = RCC_CRSSynchroInfoTypeDef()
            CRCCExtended_GetCRSInfo(&reference.state, &cInfo)
            XCTAssertEqual([info.reloadValue, info.hsi48CalibrationValue, info.frequencyErrorCapture, info.frequencyErrorDirection],
                           [cInfo.ReloadValue, cInfo.HSI48CalibrationValue, cInfo.FreqErrorCapture, cInfo.FreqErrorDirection])
            assertMatches(actual, reference, "raw readback \(iteration)")
        }
    }

    func testReadbackObservesDistinctISRReadsAndFieldReadOrder() {
        let (actual, reference) = pair {
            CRCCExtended_ScheduleRead(&$0, CRCCExtended_CRS_CFGR, 1, CRCCExtended_CRS_CR, .max, 0x1500)
            CRCCExtended_ScheduleRead(&$0, CRCCExtended_CRS_CR, 1, CRCCExtended_CRS_ISR, .max, 0x2468_0000)
            CRCCExtended_ScheduleRead(&$0, CRCCExtended_CRS_ISR, 2, CRCCExtended_CRS_ISR, .max, 0x9876_8000)
        }
        let info = actual.driver.getInfo()
        var cInfo = RCC_CRSSynchroInfoTypeDef()
        CRCCExtended_GetCRSInfo(&reference.state, &cInfo)
        XCTAssertEqual(info, .init(reloadValue: 0xBB7F, hsi48CalibrationValue: 0x15,
                                   frequencyErrorCapture: 0x2468, frequencyErrorDirection: 0x8000))
        XCTAssertEqual([info.reloadValue, info.hsi48CalibrationValue, info.frequencyErrorCapture, info.frequencyErrorDirection],
                       [cInfo.ReloadValue, cInfo.HSI48CalibrationValue, cInfo.FreqErrorCapture, cInfo.FreqErrorDirection])
        assertMatches(actual, reference)
    }

    func testEveryIRQFlagAndEnableCombinationMatchesOriginalC() {
        for combination in UInt32(0)..<128 {
            for enables in UInt32(0)..<16 {
                let flags = Self.flags(combination)
                let (actual, reference) = pair {
                    CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, flags | 0xA35C_8000)
                    CRCCExtended_Set(&$0, CRCCExtended_CRS_CR, enables | 0x6B00)
                }
                actual.interrupt()
                CRCCExtended_HandleCRSInterrupt(&reference.state)
                assertMatches(actual, reference, "IRQ flags \(flags), enables \(enables)")
                XCTAssertLessThanOrEqual(actual.state.callbackCount, 1)
            }
        }
    }

    func testIRQUsesSavedISRAndFreshEnableSnapshot() {
        let cases: [(UInt32, UInt32, UInt32, UInt32)] = [
            (1, 15, 0x704, 15), (0x704, 15, 1, 15),
            (0x70F, 15, 0x70F, 0), (0x70F, 0, 0x70F, 4),
        ]
        for (initialFlags, initialEnables, laterFlags, laterEnables) in cases {
            let (actual, reference) = pair {
                CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, initialFlags)
                CRCCExtended_Set(&$0, CRCCExtended_CRS_CR, initialEnables)
                CRCCExtended_ScheduleRead(&$0, CRCCExtended_CRS_CR, 1, CRCCExtended_CRS_ISR, .max, laterFlags)
                CRCCExtended_ScheduleRead(&$0, CRCCExtended_CRS_CR, 1, CRCCExtended_CRS_CR, .max, laterEnables)
            }
            actual.interrupt()
            CRCCExtended_HandleCRSInterrupt(&reference.state)
            assertMatches(actual, reference)
        }
    }

    func testEveryPollingFlagCombinationMatchesWithAndWithoutImmediateTimeout() {
        for combination in UInt32(0)..<128 {
            for timeout in [UInt32(0), 2] {
                let flags = Self.flags(combination)
                let (actual, reference) = pair { CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, flags) }
                _ = wait(actual, reference, timeout: timeout, context: "poll flags \(flags), timeout \(timeout)")
            }
        }
    }

    func testPollingFreshFlagsAfterSharedErrorClearMatchC() {
        let (actual, reference) = pair {
            for (index, flags) in [UInt32(1), 2, 0x400, 0x100, 0x200, 8].enumerated() {
                CRCCExtended_ScheduleRead(&$0, CRCCExtended_CRS_ISR, UInt32(index + 1),
                                           CRCCExtended_CRS_ISR, 0, flags)
            }
        }
        XCTAssertEqual(wait(actual, reference, timeout: 10), [.syncOK, .syncWarning, .trimOverflow, .syncError, .syncMiss])

        let (simultaneous, cSimultaneous) = pair { CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, 0x70F) }
        XCTAssertEqual(wait(simultaneous, cSimultaneous, timeout: 10), [.syncOK, .syncWarning, .trimOverflow])
    }

    func testFlagArrivalAtEveryReadPositionAndTickBoundaryMatchesC() {
        for flag in [UInt32(1), 2, 0x100, 0x200, 0x400] {
            for afterRead in UInt32(1)...30 {
                let (actual, reference) = pair {
                    CRCCExtended_ScheduleRead(&$0, CRCCExtended_CRS_ISR, afterRead, CRCCExtended_CRS_ISR, 0, flag)
                }
                _ = wait(actual, reference, timeout: 3, context: "flag \(flag) at ISR read \(afterRead)")
            }
        }
        for afterTick in UInt32(1)...7 {
            let (actual, reference) = pair {
                CRCCExtended_ScheduleTick(&$0, afterTick, CRCCExtended_CRS_ISR, 0, 0x703)
            }
            _ = wait(actual, reference, timeout: 3, context: "flags at tick call \(afterTick)")
        }
    }

    func testTimeoutStrictBoundaryZeroAndRolloverMatchC() {
        for start in [UInt32(0), UInt32.max - 2, UInt32.max] {
            for step in [UInt32(1), 2, 4] {
                for timeout in [UInt32(0), 1, 2, 3] {
                    let (actual, reference) = pair { $0.tick = start; $0.tickStep = step }
                    XCTAssertEqual(wait(actual, reference, timeout: timeout,
                        context: "start \(start), step \(step), timeout \(timeout)"), .timeout)
                }
            }
        }
        let (actual, reference) = pair {
            $0.tickStep = 0
            CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, 1)
        }
        XCTAssertEqual(wait(actual, reference, timeout: 0), [.timeout, .syncOK])
        XCTAssertEqual(actual.state.tickCalls, 2)
    }

    func testMaximumDelayIgnoresTicksUntilRealStatusAndClearsExpectedSync() {
        for afterRead in [UInt32(1), 6, 7, 13, 24] {
            let (actual, reference) = pair {
                $0.tick = UInt32.max
                $0.tickStep = 0
                CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, 8)
                CRCCExtended_ScheduleRead(&$0, CRCCExtended_CRS_ISR, afterRead,
                                           CRCCExtended_CRS_ISR, 0, 1)
            }
            XCTAssertEqual(wait(actual, reference, timeout: .max), .syncOK)
            XCTAssertEqual(actual.state.tickCalls, 1)
            XCTAssertEqual(CRCCExtended_Get(&actual.state, CRCCExtended_CRS_ISR), 0)
        }
    }

    func testExpectedSyncAndSummaryErrorAloneOnlyFinishByTimeout() {
        for flags in [UInt32(0), 4, 8, 12] {
            let (actual, reference) = pair { CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, flags) }
            XCTAssertEqual(wait(actual, reference, timeout: 2), .timeout)
            XCTAssertEqual(actual.state.tickCalls, 4)
            XCTAssertEqual(CRCCExtended_Get(&actual.state, CRCCExtended_CRS_ISR), flags & ~UInt32(8))
        }
    }

    func testEveryCallbackCanReenterAfterICRAndPreserveCOrdering() {
        let cases: [(UInt32, CRCCExtendedCallbackID)] = [
            (15, CRCCExtended_CRSSyncOKCallback), (14, CRCCExtended_CRSSyncWarningCallback),
            (12, CRCCExtended_CRSExpectedSyncCallback), (4, CRCCExtended_CRSErrorCallback),
        ]
        for (sources, callback) in cases {
            let (actual, reference) = pair {
                CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, 0x70F)
                CRCCExtended_Set(&$0, CRCCExtended_CRS_CR, sources)
                $0.crsIRQReentryMask = 1 << callback.rawValue
            }
            actual.interrupt()
            CRCCExtended_HandleCRSInterrupt(&reference.state)
            assertMatches(actual, reference)
            XCTAssertEqual(actual.state.crsIRQReentryMask, 0)
            XCTAssertEqual(actual.state.callbackCount, callback == CRCCExtended_CRSErrorCallback ? 1 : 2)
        }
    }

    func testNestedCallbacksDrainAllFourPrioritiesExactlyLikeC() {
        let (actual, reference) = pair {
            CRCCExtended_Set(&$0, CRCCExtended_CRS_ISR, 0x70F)
            CRCCExtended_Set(&$0, CRCCExtended_CRS_CR, 15)
            $0.crsIRQReentryMask = 0x1E
        }
        actual.interrupt()
        CRCCExtended_HandleCRSInterrupt(&reference.state)
        assertMatches(actual, reference)
        XCTAssertEqual(actual.state.callbackCount, 4)
        XCTAssertEqual(CRCCExtended_Get(&actual.state, CRCCExtended_CRS_ISR), 0)
        XCTAssertEqual((UInt32(0)..<4).map { CRCCExtended_GetCallback(&actual.state, $0).callbackID.rawValue }, [1, 2, 3, 4])
        XCTAssertEqual((UInt32(0)..<4).map { CRCCExtended_GetWrite(&actual.state, $0).value }, [1, 2, 8, 4])
    }
}
