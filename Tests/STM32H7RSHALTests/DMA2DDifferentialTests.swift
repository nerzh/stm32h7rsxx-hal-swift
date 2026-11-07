import XCTest
import CDMA2DReference
import STM32H7RSHAL

private final class DMA2DPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CDMA2D_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CDMA2D_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    let mode: UInt32
    init(_ mode: UInt32, state: UInt32 = 1, lock: UInt32 = 0, seed: UInt32 = 0) {
        self.mode = mode
        CDMA2D_Reset(actual, mode); CDMA2D_Reset(expected, mode)
        for index: UInt32 in 0..<20 { set(0, index, seed) }
        set(1, 0, lock); set(1, 1, state); set(1, 2, 0x8000)
        set(2, 0, 1); set(2, 3, 501)
        for id: UInt32 in 0..<6 { callback(id, 1) }
    }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) {
        CDMA2D_Set(actual, area, index, value); CDMA2D_Set(expected, area, index, value)
    }
    func callback(_ id: UInt32, _ token: UInt32) {
        CDMA2D_SetCallback(actual, id, token); CDMA2D_SetCallback(expected, id, token)
    }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, _ d: UInt32 = 0, _ e: UInt32 = 0,
             file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(3, 0, 0); set(2, 4, 0)
        let expectedResult = CDMA2D_Run(expected, op, a, b, c, d, e)
        let result = DMA2DReferenceIO(state: actual, mode: mode).run(op, a, b, c, d, e)
        let label = "mode \(mode), op \(op), args \([a,b,c,d,e])"
        XCTAssertEqual(result, expectedResult, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0, 20), (1, 24), (2, 12)] {
            for index in 0..<count {
                XCTAssertEqual(CDMA2D_Get(actual, area, index), CDMA2D_Get(expected, area, index),
                               "\(label), area \(area), word \(index)", file: file, line: line)
            }
        }
        for id: UInt32 in 0..<6 {
            XCTAssertEqual(CDMA2D_GetCallback(actual, id), CDMA2D_GetCallback(expected, id), file: file, line: line)
        }
        let count = CDMA2D_TraceCount(actual), referenceCount = CDMA2D_TraceCount(expected)
        XCTAssertEqual(count, referenceCount, label, file: file, line: line)
        for event in 0..<min(count, referenceCount) {
            for word: UInt32 in 0..<56 {
                XCTAssertEqual(CDMA2D_TraceWord(actual, event, word), CDMA2D_TraceWord(expected, event, word),
                               "\(label), event \(event)/\(word)", file: file, line: line)
            }
        }
        return result
    }
}

final class DMA2DDifferentialTests: XCTestCase {
    func testInitializeAllModesFormatsStatesLocksAndMSPChanges() {
        for callbacks: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2, 3, 4, 5, .max] {
                for mode: UInt32 in 0..<6 {
                    for format: UInt32 in 0..<5 {
                        for flags: UInt32 in 0..<16 {
                            let p = DMA2DPair(callbacks, state: state, lock: flags & 1, seed: 0xA5A5_A5A5)
                            p.set(1, 3, mode << 16); p.set(1, 4, format); p.set(1, 5, flags & 1 == 0 ? 0 : 0xFFFF)
                            p.set(1, 6, flags & 1); p.set(1, 7, (flags >> 1) & 1)
                            p.set(1, 8, ((flags >> 2) & 1) << 8); p.set(1, 9, ((flags >> 3) & 1) << 6)
                            p.callback(0, flags % 3); p.callback(4, 2); p.callback(5, 2)
                            p.set(2, 10, flags == 15 ? 1 : 0)
                            XCTAssertEqual(p.run(0), 0)
                            XCTAssertEqual(p.run(25), 1); XCTAssertEqual(p.run(26), 0)
                        }
                    }
                }
            }
        }
    }
    func testStartAndBlendPreserveCColorPackingAndLockRules() {
        for mode: UInt32 in 0..<6 {
            for format: UInt32 in 0..<5 {
                for color: UInt32 in [0, 1, 0x1234_5678, 0x80FF_0080, .max] {
                    for op: UInt32 in 2...5 {
                        let p = DMA2DPair(mode & 1, state: mode, seed: 0xA5A5_A5A5)
                        p.set(1, 3, mode << 16); p.set(1, 4, format)
                        if op < 4 { XCTAssertEqual(p.run(op, color, 0x2402_0000, 0x3FFF, 0xFFFF), 0) }
                        else { XCTAssertEqual(p.run(op, color, color ^ 0xFFFFFFFF, 0x2402_0000, 0x3FFF, 0xFFFF), 0) }
                        XCTAssertEqual(p.run(op), 2)
                    }
                }
            }
        }
        for op: UInt32 in 2...5 { XCTAssertEqual(DMA2DPair(0).run(op), 0) }
    }
    func testLayersEveryInputFormatAlphaAndChromaMode() {
        for layer: UInt32 in 0...1 {
            for mode: UInt32 in [0, 0x10000, 0x30000] {
                for format: UInt32 in 0...11 {
                    for alphaMode: UInt32 in 0...2 {
                        for flags: UInt32 in 0..<4 {
                            for alpha: UInt32 in [0, 1, 255, 0x1234_5678, .max] {
                                let p = DMA2DPair(flags & 1, seed: .max)
                                p.set(1, 3, mode)
                                let words: [UInt32] = [0xFFFF, format, alphaMode, alpha, flags & 1, flags >> 1, flags % 3]
                                for (i, word) in words.enumerated() { p.set(1, 10 + layer * 7 + UInt32(i), word) }
                                XCTAssertEqual(p.run(19, layer), 0)
                            }
                        }
                    }
                }
            }
        }
        // C intentionally skips the input format/mode assertions in R2M mode.
        let p = DMA2DPair(0)
        p.set(1, 3, 0x30000); p.set(1, 11, .max); p.set(1, 12, .max)
        XCTAssertEqual(p.run(19), 0)
    }
    func testCLUTConfigurationAndBothCLoadEntryPoints() {
        for mode: UInt32 in 0...1 {
            for layer: UInt32 in 0...1 {
                for size: UInt32 in [0, 1, 127, 255] {
                    for format: UInt32 in 0...1 {
                        for op: UInt32 in [9, 10, 11, 12, 13, 20] {
                            let p = DMA2DPair(mode, state: size % 6, seed: 0xCAFE_BABE)
                            XCTAssertEqual(p.run(op, layer, 0x2402_0010, format, size), 0)
                        }
                    }
                }
            }
        }
    }
    func testAbortSuspendResumeWithDelayedHardwareAndTickWraparound() {
        for op: UInt32 in [6, 7, 8, 14, 15, 16] {
            for layer: UInt32 in [0, 1, 2, .max] {
                for behavior: UInt32 in 0...3 {
                    for initial: UInt32 in 0..<4 {
                        for tick: UInt32 in [0, 0xFFFF_FF00] {
                            let p = DMA2DPair(0, state: 2, lock: 1)
                            p.set(0, 0, 0x3F00 | initial)
                            p.set(0, 7, (initial & 1) << 5); p.set(0, 9, ((initial >> 1) & 1) << 5)
                            p.set(2, 1, behavior); p.set(2, 2, tick)
                            p.run(op, layer)
                        }
                    }
                    let p = DMA2DPair(1, state: 2, lock: 1)
                    p.set(0, 0, 0x3F01); p.set(0, 7, 0x20); p.set(0, 9, 0x20)
                    p.set(2, 1, behavior); p.set(2, 5, 3); p.set(2, 6, 1); p.set(2, 9, 3)
                    p.run(op, layer)
                }
            }
        }
    }
    func testPollingErrorsCompletionTimeoutAndZeroTimeoutPrecedence() {
        for starts: UInt32 in 0..<8 {
            for flags: UInt32 in 0..<64 {
                for timeout: UInt32 in [0, 1, 1000] {
                    let p = DMA2DPair(0, state: 2, lock: 1)
                    p.set(0, 0, starts & 1); p.set(0, 7, ((starts >> 1) & 1) << 5)
                    p.set(0, 9, ((starts >> 2) & 1) << 5); p.set(0, 1, flags)
                    p.set(2, 1, 1); p.set(2, 2, 0xFFFF_FF00)
                    p.run(17, timeout)
                }
            }
        }
        for starts: UInt32 in 1..<8 {
            for limit: UInt32 in [1000, .max] {
                let p = DMA2DPair(1, state: 2, lock: 1)
                p.set(0, 0, starts & 1); p.set(0, 7, ((starts >> 1) & 1) << 5)
                p.set(0, 9, ((starts >> 2) & 1) << 5)
                p.set(2, 5, 1); p.set(2, 8, 0x12)
                XCTAssertEqual(p.run(17, limit), 0)
            }
        }
    }
    func testInterruptSnapshotAndEveryFlagMaskCombination() {
        for mode: UInt32 in 0...1 {
            for flags: UInt32 in 0..<64 {
                for enabled: UInt32 in 0..<64 {
                    let p = DMA2DPair(mode, state: 2, lock: 1)
                    p.set(0, 0, 0x70001 | (enabled << 8)); p.set(0, 1, flags)
                    for id: UInt32 in 0..<6 { p.callback(id, id < 4 ? flags % 3 : 1 + (flags & 1)) }
                    p.set(2, 10, flags & 1)
                    p.run(18)
                }
            }
        }
    }
    func testDeinitializeClockGateAbortPriorityAndFailurePropagation() {
        for mode: UInt32 in 0...1 {
            for clock: UInt32 in 0...1 {
                for starts: UInt32 in 0..<8 {
                    for behavior: UInt32 in 0...3 {
                        let p = DMA2DPair(mode, state: 2, lock: 1, seed: 0xA5A5_A5A5)
                        p.set(0, 0, starts & 1); p.set(0, 7, ((starts >> 1) & 1) << 5)
                        p.set(0, 9, ((starts >> 2) & 1) << 5)
                        p.set(2, 0, clock); p.set(2, 1, behavior); p.callback(1, starts % 3)
                        p.run(1)
                    }
                }
            }
            XCTAssertEqual(DMA2DPair(mode).run(0, 1), 1)
            XCTAssertEqual(DMA2DPair(mode).run(1, 1), 1)
        }
    }
    func testWatermarkDeadTimeCallbacksAndMacros() {
        for lock: UInt32 in [0, 1, 2] {
            for value: UInt32 in [0, 1, 255, 0xFFFF, 0x10000, .max] {
                for op: UInt32 in 21...24 { DMA2DPair(0, lock: lock, seed: .max).run(op, value) }
                for op: UInt32 in 28...33 { DMA2DPair(0, lock: lock, seed: value).run(op, value ^ 0x5555_5555) }
            }
            for state: UInt32 in [0, 1, 2, 3, 4, 5, .max] {
                for id: UInt32 in [0, 1, 2, 3, 4, 5, 6, .max] {
                    for token: UInt32 in 0...2 {
                        let p = DMA2DPair(1, state: state, lock: lock)
                        p.run(34, id, token); p.run(35, id)
                    }
                }
            }
        }
        for mode: UInt32 in 0...1 {
            let p = DMA2DPair(mode, state: 2, lock: 1)
            p.run(27); XCTAssertEqual(p.run(25), 0); XCTAssertEqual(p.run(26), 0x8000)
        }
    }
}
