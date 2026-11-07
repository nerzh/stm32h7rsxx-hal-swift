import XCTest
import CGFXTIMReference
import STM32H7RSHAL

private final class GFXTIMPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CGFXTIM_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CGFXTIM_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    let mode: UInt32
    init(_ mode: UInt32, state: UInt32 = 1, seed: UInt32 = 0xA5A5_A5A5) {
        self.mode = mode
        CGFXTIM_Reset(actual, mode); CGFXTIM_Reset(expected, mode)
        for index: UInt32 in 0..<0x2B { set(0, index, seed ^ (index * 0x10203)) }
        set(1, 0, state); set(1, 1, 0x8000); set(3, 0, 0xDEAD_BEEF)
        for id: UInt32 in 1...17 { callback(id, 1) }
    }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) {
        CGFXTIM_Set(actual, area, index, value); CGFXTIM_Set(expected, area, index, value)
    }
    func configuration(_ words: [UInt32]) { for (i, word) in words.enumerated() { set(2, UInt32(i), word) } }
    func callback(_ id: UInt32, _ token: UInt32) {
        CGFXTIM_SetCallback(actual, id, token); CGFXTIM_SetCallback(expected, id, token)
    }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, nulls: UInt32 = 0,
             file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(3, 2, 0)
        let expectedResult = CGFXTIM_Run(expected, op, a, b, nulls)
        let result = GFXTIMReferenceIO(state: actual, mode: mode).run(op, a, b, nulls)
        let label = "mode \(mode), op \(op), a \(a), b \(b), nulls \(nulls)"
        XCTAssertEqual(result, expectedResult, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0, 0x2B), (1, 6), (2, 10), (3, 3)] {
            for index in 0..<count {
                XCTAssertEqual(CGFXTIM_Get(actual, area, index), CGFXTIM_Get(expected, area, index),
                               "\(label), area \(area), word \(index)", file: file, line: line)
            }
        }
        for id: UInt32 in 1...17 {
            XCTAssertEqual(CGFXTIM_GetCallback(actual, id), CGFXTIM_GetCallback(expected, id),
                           "\(label), callback \(id)", file: file, line: line)
        }
        let count = CGFXTIM_TraceCount(actual), referenceCount = CGFXTIM_TraceCount(expected)
        XCTAssertEqual(count, referenceCount, label, file: file, line: line)
        for event in 0..<min(count, referenceCount) {
            for word: UInt32 in 0..<12 {
                XCTAssertEqual(CGFXTIM_TraceWord(actual, event, word), CGFXTIM_TraceWord(expected, event, word),
                               "\(label), event \(event)/\(word)", file: file, line: line)
            }
        }
        return result
    }
}

final class GFXTIMDifferentialTests: XCTestCase {
    func testInitializeAllSourcesPolaritiesStatesAndCallbackModes() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 0xFF, .max] {
                for fields: UInt32 in 0..<64 {
                    let p = GFXTIMPair(mode, state: state)
                    p.set(1, 2, (fields & 3) << 8); p.set(1, 3, (fields >> 2) & 3)
                    p.set(1, 4, ((fields >> 4) & 1) << 4); p.set(1, 5, fields >> 5)
                    for id: UInt32 in 1...17 { p.callback(id, fields % 3) }
                    XCTAssertEqual(p.run(0), state == 0 ? 0 : 1)
                    XCTAssertEqual(p.run(0), 1)
                }
            }
        }
    }
    func testMSPReadsLiveConfigurationAndDeinitializePreservesErrors() {
        for mode: UInt32 in 0...1 {
            for token: UInt32 in 0...2 {
                let p = GFXTIMPair(mode, state: 0)
                p.callback(16, token); p.set(3, 1, 1)
                XCTAssertEqual(p.run(0), 0)
                XCTAssertEqual(CGFXTIM_Get(p.actual, 0, 0) & 0x313, 0x303)
                XCTAssertEqual(p.run(26), 0)
                p.set(1, 1, 0x8123); p.callback(17, token)
                XCTAssertEqual(p.run(1), 0)
                XCTAssertEqual(p.run(25), 0)
                XCTAssertEqual(p.run(26), 0x81A3)
                XCTAssertEqual(p.run(26), 0x81A3)
                XCTAssertEqual(p.run(1), 1)
            }
            for state: UInt32 in [0, 1, 0xFF, .max] {
                let p = GFXTIMPair(mode, state: state)
                XCTAssertEqual(p.run(1), state == 1 ? 0 : 1)
                XCTAssertEqual(p.run(26), 0x8000)
            }
        }
    }
    func testClockGeneratorAllSelectorsAndReloadEdges() {
        for mode: UInt32 in 0...1 {
            for selector: UInt32 in 0..<8 {
                for flags: UInt32 in 0..<8 {
                    for reload: UInt32 in [0, 1, 0xFFF, 0x3F_FFFF] {
                        let p = GFXTIMPair(mode)
                        p.configuration([selector << 12, reload, (flags & 1) << 4, selector,
                                         ((selector + 1) & 7) << 28, reload & 0xFFF,
                                         ((selector + 2) & 7) << 20, ((selector + 3) & 7) << 16,
                                         ((flags >> 1) & 1) << 17, ((flags >> 2) & 1) << 16])
                        XCTAssertEqual(p.run(2), 0)
                        for counters: UInt32 in [0x100, 0x1000000, 0x1000100] { XCTAssertEqual(p.run(3, counters), 0) }
                    }
                }
            }
        }
    }
    func testAbsoluteTimerEveryInterruptMaskAndCounterBoundary() {
        for mode: UInt32 in 0...1 {
            for mask: UInt32 in 0..<32 {
                for value: UInt32 in [0, 1, 0xFFF, 0xFFFFF] {
                    let p = GFXTIMPair(mode)
                    p.configuration([value, value ^ 0xFFFFF, mask & 1, (mask >> 1) & 1,
                                     value & 0xFFF, (value ^ 0xFFF) & 0xFFF, value & 0xFFF,
                                     (mask >> 2) & 1, (mask >> 3) & 1, (mask >> 4) & 1])
                    XCTAssertEqual(p.run(4), 0)
                    for op: UInt32 in 5...7 { XCTAssertEqual(p.run(op), 0) }
                    for comparator: UInt32 in [0x1C, 0x1D] { XCTAssertEqual(p.run(10, comparator, value & 0xFFF), 0) }
                }
            }
            for value: UInt32 in [0, 1, 0xFFFFF, 0x100000, 0x80000000, .max] {
                XCTAssertEqual(GFXTIMPair(mode).run(9, value), 0)
            }
        }
    }
    func testRelativeTimerPreservesUnusualCModeValidation() {
        for mode: UInt32 in 0...1 {
            for timer: UInt32 in 0...1 {
                for value: UInt32 in [0, 1, 0xFFF] {
                    for counterMode: UInt32 in [0, 1, 2, 0xFFF] {
                        for interrupt: UInt32 in 0...1 {
                            let p = GFXTIMPair(mode)
                            p.configuration([value, counterMode, interrupt])
                            XCTAssertEqual(p.run(11, timer), 0)
                            for op: UInt32 in 12...14 { XCTAssertEqual(p.run(op, timer), 0) }
                            XCTAssertEqual(p.run(15, timer, value ^ 0xFFF), 0)
                        }
                    }
                }
            }
        }
    }
    func testEventGeneratorEveryValidSourceCombination() {
        for mode: UInt32 in 0...1 {
            for generator: UInt32 in 0..<4 {
                for line: UInt32 in [0, 1, 2, 4, 5] {
                    for frame: UInt32 in [0, 0x10, 0x20, 0x40, 0x50] {
                        for interrupt: UInt32 in 0...1 {
                            let p = GFXTIMPair(mode)
                            p.configuration([line, frame, interrupt])
                            XCTAssertEqual(p.run(17, generator), 0)
                            XCTAssertEqual(p.run(18, generator), 0)
                            XCTAssertEqual(p.run(19, generator), 0)
                        }
                    }
                }
            }
        }
    }
    func testWatchdogEveryClockReloadAndInterruptCombination() {
        for mode: UInt32 in 0...1 {
            for clock: UInt32 in 0..<12 {
                for reload: UInt32 in [0, 0x10, 0x20] {
                    for flags: UInt32 in 0..<4 {
                        for value: UInt32 in [0, 1, 0xFFFF] {
                            let p = GFXTIMPair(mode)
                            p.configuration([clock << 8, value, reload, value ^ 0xFFFF, flags & 1, flags >> 1])
                            XCTAssertEqual(p.run(20), 0)
                            for op: UInt32 in 21...23 { XCTAssertEqual(p.run(op), 0) }
                        }
                    }
                }
            }
        }
    }
    func testCounterOutputsIncludeNullAndAliasedHandleAndRegisters() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 0xFF] {
                for output: UInt32 in [0, 1, 0x100, 0x101, 0x105, 0x200, 0x214, 0x22A] {
                    for selector: UInt32 in [0x14, 0x15, 0x16, 0, 1] {
                        let p = GFXTIMPair(mode, state: state)
                        XCTAssertEqual(p.run(selector < 2 ? 16 : 8, selector, output), state == 1 && output != 0 ? 0 : 1)
                    }
                }
            }
        }
    }
    func testNullHandlesAndConfigurationsReturnWithoutRegisterAccess() {
        let args: [(UInt32, UInt32)] = [(0, 0), (0, 0), (0, 0), (0x100, 0), (0, 0), (0, 0),
            (0, 0), (0, 0), (0x14, 1), (0, 0), (0x1C, 0), (0, 0), (0, 0), (0, 0), (0, 0),
            (0, 0), (0, 1), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)]
        for mode: UInt32 in 0...1 {
            for op: UInt32 in 0...23 {
                let p = GFXTIMPair(mode)
                XCTAssertEqual(p.run(op, args[Int(op)].0, args[Int(op)].1, nulls: 1), 1)
                XCTAssertEqual(CGFXTIM_TraceCount(p.actual), 0)
            }
            for op: UInt32 in [2, 4, 11, 17, 20] {
                XCTAssertEqual(GFXTIMPair(mode).run(op, nulls: 2), 1)
            }
        }
        XCTAssertEqual(GFXTIMPair(1).run(30, 1, 2, nulls: 1), 1)
        XCTAssertEqual(GFXTIMPair(1).run(31, 1, nulls: 1), 1)
    }
    func testNonReadyOperationsPreserveRegistersAndErrors() {
        for state: UInt32 in [0, 0xFF, .max] {
            let p = GFXTIMPair(state & 1, state: state)
            for op: UInt32 in [1, 2, 4, 5, 6, 7, 9, 11, 12, 13, 14, 15, 17, 18, 19, 20, 21, 22, 23] {
                XCTAssertEqual(p.run(op), 1)
                XCTAssertEqual(CGFXTIM_TraceCount(p.actual), 0)
            }
            XCTAssertEqual(p.run(3, 0x100), 1); XCTAssertEqual(p.run(8, 0x14, 1), 1)
            XCTAssertEqual(p.run(10, 0x1C), 1); XCTAssertEqual(p.run(16, 0, 1), 1)
            XCTAssertEqual(p.run(25), state); XCTAssertEqual(p.run(26), 0x8000)
        }
    }
    func testInterruptSnapshotsFlagsAndRereadsCallbacksBeforeFinalClear() {
        let flags: [UInt32] = [0, 1, 2, 4, 0x10, 0x100, 0x200, 0x1000, 0x2000,
            0x10000, 0x20000, 0x40000, 0x80000, 0x1000000, 0x2000000, 0x80000000, 0x30F3317, .max]
        for mode: UInt32 in 0...1 {
            for status in flags {
                for enabled in flags {
                    for action: UInt32 in 0...1 {
                        let p = GFXTIMPair(mode, state: status & 1)
                        p.set(0, 0x30 / 4, status); p.set(0, 0x38 / 4, enabled); p.set(3, 1, action)
                        for id: UInt32 in 1...17 { p.callback(id, 1 + (id & 1)) }
                        p.run(24)
                        XCTAssertEqual(CGFXTIM_Get(p.actual, 0, 0x34 / 4), status & enabled)
                    }
                }
            }
        }
    }
    func testCallbackRegistrationEveryIDStateAndNullPointer() {
        for state: UInt32 in [0, 1, 0xFF, .max] {
            for id: UInt32 in Array(0...18) + [.max] {
                for token: UInt32 in 0...2 {
                    let p = GFXTIMPair(1, state: state)
                    p.run(30, id, token); p.run(31, id)
                    let valid = state == 1 && (1...17).contains(id) || state == 0 && (16...17).contains(id)
                    XCTAssertEqual(CGFXTIM_Get(p.actual, 1, 1), 0x8000 | (valid && token != 0 ? 0 : 2))
                }
            }
            for mode: UInt32 in 0...1 {
                let p = GFXTIMPair(mode, state: state)
                for id: UInt32 in 1...17 { p.callback(id, 2) }
                p.run(27)
                XCTAssertEqual(p.run(25), 0); XCTAssertEqual(p.run(26), 0x8000)
            }
        }
    }
    func testFlagMacrosPreserveCombinedMaskAndWriteOneToClearSemantics() {
        for status: UInt32 in [0, 1, 0x30F3317, 0x80000000, .max] {
            for mask: UInt32 in [0, 1, 3, 0x30F3317, 0x80000000, .max] {
                let p = GFXTIMPair(0)
                p.set(0, 0x30 / 4, status)
                XCTAssertEqual(p.run(28, mask), status & mask == mask ? 1 : 0)
                p.run(29, mask)
                XCTAssertEqual(CGFXTIM_Get(p.actual, 0, 0x30 / 4), status & ~mask)
            }
        }
    }
}
