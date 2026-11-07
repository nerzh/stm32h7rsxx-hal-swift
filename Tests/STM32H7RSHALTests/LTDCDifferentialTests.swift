import XCTest
import CLTDCReference
import STM32H7RSHAL

final class LTDCPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CLTDC_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CLTDC_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    let mode: UInt32
    init(_ mode: UInt32, state: UInt32 = 1, lock: UInt32 = 0, seed: UInt32 = 0) {
        self.mode = mode
        CLTDC_Reset(actual, mode); CLTDC_Reset(expected, mode)
        for index: UInt32 in 0..<128 { set(0, index, seed) }
        set(1, 0, lock); set(1, 1, state); set(1, 2, 0x8000)
        set(2, 1, 51)
        for id: UInt32 in 0..<5 { callback(id, 1) }
    }
    func configure(_ values: [UInt32], layer: UInt32? = nil) {
        for (i, value) in values.enumerated() {
            if let layer { set(1, 16 + layer * 13 + UInt32(i), value) }
            else { set(5, UInt32(i), value) }
        }
    }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) {
        CLTDC_Set(actual, area, index, value); CLTDC_Set(expected, area, index, value)
    }
    func callback(_ id: UInt32, _ token: UInt32) {
        CLTDC_SetCallback(actual, id, token); CLTDC_SetCallback(expected, id, token)
    }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0,
             file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(3, 0, 0); set(2, 2, 0)
        let expectedResult = CLTDC_Run(expected, op, a, b, c)
        let result = LTDCReferenceIO(state: actual, mode: mode).run(op, a, b, c)
        let label = "mode \(mode), op \(op), args \([a,b,c])"
        XCTAssertEqual(result, expectedResult, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0, 128), (1, 42), (2, 6), (5, 13)] {
            for index in 0..<count {
                XCTAssertEqual(CLTDC_Get(actual, area, index), CLTDC_Get(expected, area, index),
                               "\(label), area \(area), word \(index)", file: file, line: line)
            }
        }
        for id: UInt32 in 0..<5 {
            XCTAssertEqual(CLTDC_GetCallback(actual, id), CLTDC_GetCallback(expected, id), file: file, line: line)
        }
        let count = CLTDC_TraceCount(actual), referenceCount = CLTDC_TraceCount(expected)
        XCTAssertEqual(count, referenceCount, label, file: file, line: line)
        for event in 0..<min(count, referenceCount) {
            for word: UInt32 in 0..<184 {
                XCTAssertEqual(CLTDC_TraceWord(actual, event, word), CLTDC_TraceWord(expected, event, word),
                               "\(label), event \(event)/\(word)", file: file, line: line)
            }
        }
        return result
    }
}

final class LTDCDifferentialTests: XCTestCase {
    func testInitializeAllPolaritiesStatesLocksAndLiveMSPChanges() {
        for callbacks: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2, 3, 4, .max] {
                for flags: UInt32 in 0..<16 {
                    for lock: UInt32 in [0, 1, .max] {
                        let p = LTDCPair(callbacks, state: state, lock: lock, seed: 0xA5A5A5A5)
                        p.set(1, 3, (flags & 1) << 31); p.set(1, 4, ((flags >> 1) & 1) << 30)
                        p.set(1, 5, ((flags >> 2) & 1) << 29); p.set(1, 6, ((flags >> 3) & 1) << 28)
                        for i: UInt32 in 7..<15 { p.set(1, i, flags & 1 == 0 ? 0 : i & 1 == 1 ? 0xFFF : 0x7FF) }
                        p.set(1, 15, 0xFEDCBA98); p.set(2, 5, flags & 1)
                        p.callback(0, flags % 3); p.callback(2, 2); p.callback(3, 2); p.callback(4, 2)
                        XCTAssertEqual(p.run(0), 0)
                        XCTAssertEqual(p.run(32), 1); XCTAssertEqual(p.run(33), 0)
                    }
                }
            }
        }
        // C validates individual fields, without imposing their documented ordering.
        let p = LTDCPair(0)
        p.set(1, 7, 0xFFF); p.set(1, 8, 0x7FF)
        XCTAssertEqual(p.run(0), 0)
    }
    func testDeinitializeVSYNCTimeoutBoundariesWrapAndCallbacks() {
        for mode: UInt32 in 0...1 {
            for seed: UInt32 in [0, .max] {
                for start: UInt32 in [0, .max - 99] {
                    for step: UInt32 in [1, 50, 100, 101] {
                        for at: UInt32 in [0, 1, 3] {
                            let p = LTDCPair(mode, state: 2, lock: 1, seed: seed)
                            p.set(2, 0, start); p.set(2, 1, step); p.set(2, 3, at); p.set(2, 4, 4)
                            p.callback(1, at); p.set(2, 5, at & 1)
                            XCTAssertEqual(p.run(1), 0)
                            XCTAssertEqual(CLTDC_Get(p.actual, 1, 0), 0)
                            XCTAssertEqual(CLTDC_Get(p.actual, 1, 1), 0)
                            XCTAssertEqual(CLTDC_Get(p.actual, 1, 2), 0)
                        }
                    }
                }
            }
        }
        let p = LTDCPair(0)
        p.set(2, 1, 1)
        XCTAssertEqual(p.run(1), 0)
        XCTAssertEqual(CLTDC_Get(p.actual, 2, 2), 102)
        XCTAssertEqual(p.run(0, 1), 1); XCTAssertEqual(p.run(1, 1), 1)
    }
    func testLayerConfigurationAllFormatsBoundariesAndReversedWindows() {
        let windows: [[UInt32]] = [[0, 0, 0, 0], [0, 64, 0, 48], [0xFFF, 0xFFF, 0xFFF, 0xFFF], [0xFFF, 0, 0xFFF, 0]]
        for layer: UInt32 in 0...1 {
            for format: UInt32 in 0...7 {
                for (i, window) in windows.enumerated() {
                    for op: UInt32 in 3...4 {
                        for alpha: UInt32 in [0, 1, 127, 255] {
                            let p = LTDCPair(layer, seed: .max)
                            let words = window + [format, alpha, 255 - alpha, i & 1 == 0 ? 0x400 : 0x600,
                                                  i & 2 == 0 ? 5 : 7, 0xFFFFFFFD, i & 1 == 0 ? 0 : 0x1FFF,
                                                  i & 1 == 0 ? 0 : 0x7FF, 0xFEDCBA98]
                            p.configure(words)
                            XCTAssertEqual(p.run(op, layer), 0)
                        }
                    }
                }
            }
        }
    }
    func testWindowFormatAlphaAddressAndPitchUpdatesWithAndWithoutReload() {
        for layer: UInt32 in 0...1 {
            for format: UInt32 in [0, 1, 2, 3, 4, 5, 6, 7, .max] {
                for old: UInt32 in [0, 0x1000, .max] {
                    for op: UInt32 in 6...19 {
                        let p = LTDCPair(layer, seed: .max)
                        p.configure([old, old &+ 31, old, old &+ 17, format, 127, 255, 0x400, 7, old, old, old, old], layer: layer)
                        let value: UInt32
                        switch op {
                        case 6...9: value = old == 0 ? 0 : 0x1FFF
                        case 10...11: value = format & 7
                        case 12...13: value = old & 0xFF
                        default: value = old
                        }
                        XCTAssertEqual(p.run(op, layer, value, old & 0x7FF), 0)
                    }
                }
            }
        }
    }
    func testCLUTAllFormatsZeroSizeAL44AndAddressWrapping() {
        for layer: UInt32 in 0...1 {
            for format: UInt32 in 0...7 {
                for count: UInt32 in [0, 1, 16, 17, 255, 256, 257, 512] {
                    let p = LTDCPair(layer, seed: .max)
                    p.set(1, 16 + layer * 13 + 4, format)
                    XCTAssertEqual(p.run(5, layer, count), 0)
                }
            }
        }
    }
    func testControlOperationsLocksAndStates() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2, 3, 4, .max] {
                for lock: UInt32 in [0, 1, .max] {
                    for op: UInt32 in 3...31 {
                        let p = LTDCPair(mode, state: state, lock: lock, seed: .max)
                        p.configure([0, 1, 0, 1, 0, 255, 127, 0x400, 5, 0x24000000, 1, 1, 0x12345678])
                        let a: UInt32 = op == 31 ? 2 : op == 30 ? 0x7FF : mode
                        XCTAssertEqual(p.run(op, a, 0), lock == 1 ? 2 : 0)
                    }
                }
            }
        }
    }
    func testInterruptEveryFlagSourceCombinationAndCallbackMutation() {
        for mode: UInt32 in 0...1 {
            for flags: UInt32 in 0..<16 {
                for sources: UInt32 in 0..<16 {
                    for mutate: UInt32 in 0...1 {
                        let p = LTDCPair(mode, state: 2, lock: 1, seed: 0xA5A5A5A5)
                        p.set(0, 0x38 / 4, flags | 0x80000000); p.set(0, 0x34 / 4, sources | 0x40000000)
                        p.set(2, 5, mutate)
                        XCTAssertEqual(p.run(2), 0)
                    }
                }
            }
        }
    }
    func testCallbackRegistrationAndUnregistrationRules() {
        for state: UInt32 in [0, 1, 2, 3, 4, .max] {
            for lock: UInt32 in [0, 1, .max] {
                for id: UInt32 in [0, 1, 2, 3, 4, 5, .max] {
                    for token: UInt32 in 0...2 {
                        let p = LTDCPair(1, state: state, lock: lock)
                        p.run(46, id, token)
                        p.run(47, id)
                    }
                }
            }
        }
    }
    func testPublicMacrosPreserveUnrelatedBits() {
        for mode: UInt32 in 0...1 {
            for seed: UInt32 in [0, 1, 2, 0xA5A5A5A5, .max] {
                let p = LTDCPair(mode, state: 2, lock: 1, seed: seed)
                for op: UInt32 in 34...45 {
                    p.run(op, op == 37 || op == 38 ? mode : seed)
                }
            }
        }
    }
}
