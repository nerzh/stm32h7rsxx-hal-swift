import XCTest
import CDCMIPPReference
import STM32H7RSHAL

final class DCMIPPPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CDCMIPP_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CDCMIPP_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    let mode: UInt32
    init(_ mode: UInt32, state: UInt32 = 2, pipeState: UInt32 = 1, seed: UInt32 = 0) {
        self.mode = mode
        CDCMIPP_Reset(actual, mode); CDCMIPP_Reset(expected, mode)
        for register in DCMIPPRegister.allCases { set(0, register.rawValue / 4, seed) }
        set(1, 0, state); set(1, 1, pipeState); set(1, 2, 0x8000)
        set(2, 1, 501)
        for id: UInt32 in 0..<8 { callback(id, 1) }
    }
    func parameters(_ start: UInt32, _ values: [UInt32]) {
        for (i, value) in values.enumerated() { set(4, start + UInt32(i), value) }
    }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) {
        CDCMIPP_Set(actual, area, index, value); CDCMIPP_Set(expected, area, index, value)
    }
    func callback(_ id: UInt32, _ token: UInt32) {
        CDCMIPP_SetCallback(actual, id, token); CDCMIPP_SetCallback(expected, id, token)
    }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0,
             file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(3, 0, 0); set(2, 2, 0)
        let expectedResult = CDCMIPP_Run(expected, op, a, b, c)
        let result = DCMIPPReferenceIO(state: actual, mode: mode).run(op, a, b, c)
        let label = "mode \(mode), op \(op), args \([a,b,c])"
        XCTAssertEqual(result, expectedResult, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(1, 3), (2, 6), (4, 24)] {
            for index in 0..<count {
                XCTAssertEqual(CDCMIPP_Get(actual, area, index), CDCMIPP_Get(expected, area, index),
                               "\(label), area \(area), word \(index)", file: file, line: line)
            }
        }
        for register in DCMIPPRegister.allCases {
            XCTAssertEqual(CDCMIPP_Get(actual, 0, register.rawValue / 4), CDCMIPP_Get(expected, 0, register.rawValue / 4),
                           "\(label), register \(register)", file: file, line: line)
        }
        for id: UInt32 in 0..<8 {
            XCTAssertEqual(CDCMIPP_GetCallback(actual, id), CDCMIPP_GetCallback(expected, id), file: file, line: line)
        }
        let count = CDCMIPP_TraceCount(actual), referenceCount = CDCMIPP_TraceCount(expected)
        XCTAssertEqual(count, referenceCount, label, file: file, line: line)
        for event in 0..<min(count, referenceCount) {
            for word: UInt32 in 0..<44 {
                XCTAssertEqual(CDCMIPP_TraceWord(actual, event, word), CDCMIPP_TraceWord(expected, event, word),
                               "\(label), event \(event)/\(word)", file: file, line: line)
            }
        }
        return result
    }
}

final class DCMIPPDifferentialTests: XCTestCase {
    func testInitializeDeinitializeEveryStateAndCallbackMode() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2, 3, 4, .max] {
                for pipe: UInt32 in [0, 1, 2, 3, 4, .max] {
                    for token: UInt32 in 0...2 {
                        let p = DCMIPPPair(mode, state: state, pipeState: pipe, seed: .max)
                        p.callback(0, token); p.callback(1, token); p.set(2, 5, token & 1)
                        XCTAssertEqual(p.run(0), 0); XCTAssertEqual(p.run(29), 1)
                        XCTAssertEqual(p.run(30), 0); XCTAssertEqual(p.run(31), 0)
                        XCTAssertEqual(p.run(1), 0); XCTAssertEqual(p.run(29), 0)
                    }
                }
            }
        }
    }
    func testParallelAllFormatsWidthsAndPolarities() {
        for format in DCMIPPFormat.allCases {
            for width in DCMIPPDataWidth.allCases {
                for flags: UInt32 in 0..<64 {
                    let p = DCMIPPPair(flags & 1, state: 1, seed: .max)
                    p.parameters(0, [format.rawValue, flags & 1 == 0 ? 0 : DCMIPPVerticalSyncPolarity.high.rawValue,
                        flags & 2 == 0 ? 0 : DCMIPPHorizontalSyncPolarity.high.rawValue,
                        flags & 4 == 0 ? 0 : DCMIPPPixelClockPolarity.rising.rawValue, width.rawValue,
                        flags & 8 == 0 ? 0 : DCMIPPSynchronization.embedded.rawValue, 0xFEDCBA98,
                        flags & 16 == 0 ? 0 : DCMIPPSwapBits.enabled.rawValue,
                        flags & 32 == 0 ? 0 : DCMIPPSwapCycles.enabled.rawValue])
                    XCTAssertEqual(p.run(2), 0)
                    XCTAssertEqual(p.run(2), 1)
                }
            }
        }
        for state: UInt32 in [0, 2, 3, 4, .max] {
            XCTAssertEqual(DCMIPPPair(0, state: state).run(2), 1)
        }
    }
    func testPipeConfigurationUsesBothGlobalAndPipeState() {
        for state: UInt32 in [0, 1, 2, 3, 4, .max] {
            for pipe: UInt32 in [0, 1, 2, 3, 4, .max] {
                for rate in DCMIPPFrameRate.allCases {
                    let p = DCMIPPPair(0, state: state, pipeState: pipe, seed: .max)
                    p.parameters(9, [rate.rawValue])
                    XCTAssertEqual(p.run(3), state == 2 && [0, 1, 4].contains(pipe) ? 0 : 1)
                }
            }
        }
    }
    func testIPPlugConfigurationAllEncodingsAndBoundaryFields() {
        for page in DCMIPPMemoryPageSize.allCases {
            for traffic in DCMIPPTrafficBurstSize.allCases {
                for transactions in DCMIPPOutstandingTransactions.allCases {
                    for seed: UInt32 in [0, .max] {
                        let p = DCMIPPPair(0, state: 1, seed: seed)
                        p.set(2, 3, 2); p.set(2, 4, 1)
                        p.parameters(10, [1, page.rawValue, traffic.rawValue, transactions.rawValue,
                                           seed & 31, ~seed & 31, seed & 15])
                        XCTAssertEqual(p.run(4), 0)
                    }
                }
            }
        }
    }
    func testWaitsPreserveDoWhileTimeoutOrderWrapAndFailureState() {
        for op: UInt32 in [4, 7, 8] {
            for state: UInt32 in [0, 1, 2, 3, 4, .max] {
                for pipe: UInt32 in [0, 1, 2, 3, 4, .max] {
                    for start: UInt32 in [0, .max - 1000] {
                        for step: UInt32 in [500, 1000, 1001] {
                            for at: UInt32 in [0, 1, 2, 3] {
                                let p = DCMIPPPair(0, state: state, pipeState: pipe, seed: .max)
                                p.set(0, 8 / 4, 0); p.set(2, 0, start); p.set(2, 1, step)
                                p.set(2, 3, at); p.set(2, 4, 3); p.parameters(10, [1, 0, 0, 0, 0, 31, 15])
                                p.run(op)
                            }
                        }
                    }
                }
            }
        }
        // Timeout wins even when the peripheral is already idle.
        let p = DCMIPPPair(0)
        p.set(2, 1, 1001)
        XCTAssertEqual(p.run(7), 1)
        XCTAssertEqual(CDCMIPP_Get(p.actual, 1, 1), 1)
    }
    func testStartAddressAlignmentModesAndRetainedDoubleBufferBit() {
        for state: UInt32 in [0, 1, 2, 3, 4, .max] {
            for pipe: UInt32 in [0, 1, 2, 3, 4, .max] {
                for seed: UInt32 in [0, .max] {
                    for mode in DCMIPPCaptureMode.allCases {
                        for offset: UInt32 in 0...15 {
                            for op: UInt32 in 5...6 {
                                let p = DCMIPPPair(0, state: state, pipeState: pipe, seed: seed)
                                let address = 0x24020000 + offset
                                if op == 5 { p.run(op, address, mode.rawValue) }
                                else { p.run(op, address, 0x24021000, mode.rawValue) }
                            }
                        }
                        let p = DCMIPPPair(0, state: state, pipeState: pipe, seed: seed)
                        p.run(6, 0x24020000, 0x24021001, mode.rawValue)
                        p.run(9)
                    }
                }
            }
        }
    }
    func testCropByteInputRestrictionAndBoundaryDimensions() {
        for state: UInt32 in [0, 1, 2, 3, 4, .max] {
            for format in DCMIPPFormat.allCases {
                for enabled: UInt32 in [0, 0x4000] {
                    for boundary: UInt32 in [0, 0xFFF] {
                        for area in DCMIPPCropArea.allCases {
                            let p = DCMIPPPair(0, state: state, seed: .max)
                            p.set(0, 0x104 / 4, enabled | format.rawValue)
                            p.parameters(17, [boundary, 0xFFF - boundary, max(boundary, 1), max(boundary, 1), area.rawValue])
                            p.run(11); p.run(12); XCTAssertEqual(p.run(13), 0)
                        }
                    }
                }
            }
        }
    }
    func testDecimationCrossRestrictions() {
        for width in DCMIPPDataWidth.allCases {
            for selection in DCMIPPByteSelection.allCases {
                for start in DCMIPPByteSelectionStart.allCases {
                    let p = DCMIPPPair(0, seed: .max)
                    p.set(0, 0x104 / 4, width.rawValue | 0xFF0000)
                    p.run(14, start.rawValue, selection.rawValue)
                }
            }
        }
        for selection in DCMIPPLineSelection.allCases {
            for start in DCMIPPLineSelectionStart.allCases {
                DCMIPPPair(0, seed: .max).run(15, start.rawValue, selection.rawValue)
            }
        }
    }
    func testControlsCountersSyncMemoryAndUnalignedAddressSetter() {
        for state: UInt32 in [0, 1, 2, 3, 4, .max] {
            for seed: UInt32 in [0, 0x12345678, .max] {
                let p = DCMIPPPair(0, state: state, seed: seed)
                p.parameters(22, [seed, 0xAA5555AA])
                for limit: UInt32 in [1, 0x12345, 0xFFFFFF] { p.run(16, limit); p.run(17) }
                for rate in DCMIPPFrameRate.allCases { p.run(18, rate.rawValue) }
                for mode in DCMIPPCaptureMode.allCases { p.run(19, mode.rawValue) }
                for pipe: UInt32 in [0, 1, .max] { p.run(20, pipe) }
                for memory: UInt32 in 0...1 { p.run(21, memory, seed) }
                for format in DCMIPPFormat.allCases { p.run(22, format.rawValue) }
                p.run(23)
                for interval in DCMIPPLineEventInterval.allCases { p.run(24, interval.rawValue); p.run(25) }
                p.run(26); p.run(27); p.run(28)
                for mask: UInt32 in [0, 0xC760, .max] {
                    for op: UInt32 in 32...36 { p.run(op, mask) }
                }
            }
        }
    }
    func testEveryIRQFlagSourceCombinationWithSnapshotAndCallbackMutation() {
        let bits: [UInt32] = [0x20, 0x40, 0x100, 0x200, 0x400, 0x4000, 0x8000]
        let masks: [UInt32] = (0..<128).map { value in
            bits.enumerated().reduce(UInt32(0)) { $0 | (value & (1 << $1.offset) == 0 ? 0 : $1.element) }
        }
        for mode: UInt32 in 0...1 {
            for (i, flags) in masks.enumerated() {
                for sources in masks {
                    let p = DCMIPPPair(mode, state: 2, pipeState: 2)
                    p.set(0, 0x3F8 / 4, flags | 0x80000000); p.set(0, 0x3F0 / 4, sources | 0x10000000)
                    p.set(0, 0x500 / 4, i & 1 == 0 ? 0 : 4); p.set(2, 5, UInt32((i >> 1) & 1))
                    p.run(10)
                }
            }
        }
    }
    func testCommonAndPipeCallbackRegistrationIncludingUnregisterErrorOmission() {
        for state: UInt32 in [0, 1, 2, 3, 4, .max] {
            for id: UInt32 in [0, 1, 2, 3, 4, 5, 6, .max] {
                for token: UInt32 in 0...2 {
                    let p = DCMIPPPair(1, state: state)
                    p.run(37, id, token); p.run(38, id)
                    p.run(39, id, token); p.run(40, id)
                }
            }
        }
        let p = DCMIPPPair(1)
        XCTAssertEqual(p.run(37, 2, 2), 0)
        XCTAssertEqual(p.run(38, 2), 1)
        XCTAssertEqual(CDCMIPP_GetCallback(p.actual, 2), 2)
    }
}
