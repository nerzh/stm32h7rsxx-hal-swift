import XCTest
import CGraphicsReference
import STM32H7RSHAL

private final class GraphicsPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CGraphics_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CGraphics_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    let mode: UInt32
    init(_ mode: UInt32, state: UInt32 = 0, seed: UInt32 = 0) {
        self.mode = mode
        CGraphics_Reset(actual, mode); CGraphics_Reset(expected, mode)
        for area: UInt32 in 0...1 {
            for index: UInt32 in 0..<(area == 0 ? 12 : 1024) { set(area, index, seed) }
        }
        set(2, 9, state); set(3, 1, state)
    }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) {
        CGraphics_Set(actual, area, index, value); CGraphics_Set(expected, area, index, value)
    }
    func callback(_ module: UInt32, _ index: UInt32, _ token: UInt32) {
        CGraphics_SetCallback(actual, module, index, token); CGraphics_SetCallback(expected, module, index, token)
    }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, _ d: UInt32 = 0,
             file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(5, 2, 0)
        let reference = CGraphics_Run(expected, op, a, b, c, d)
        let result = GraphicsReferenceIO(state: actual, mode: mode).run(op, a, b, c, d)
        XCTAssertEqual(result, reference, "mode \(mode), op \(op)", file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0, 12), (1, 1024), (2, 11), (3, 3), (5, 2)] {
            for index in 0..<count {
                XCTAssertEqual(CGraphics_Get(actual, area, index), CGraphics_Get(expected, area, index),
                               "op \(op), area \(area), word \(index)", file: file, line: line)
            }
        }
        if (2...4).contains(op) {
            for index: UInt32 in 1024..<3072 {
                XCTAssertEqual(CGraphics_Get(actual, 0, index), CGraphics_Get(expected, 0, index), file: file, line: line)
            }
        }
        for module: UInt32 in 0...1 {
            for index: UInt32 in 0..<3 {
                XCTAssertEqual(CGraphics_GetCallback(actual, module, index), CGraphics_GetCallback(expected, module, index),
                               "callback \(module)/\(index)", file: file, line: line)
            }
        }
        let actualCount = CGraphics_TraceCount(actual), expectedCount = CGraphics_TraceCount(expected)
        XCTAssertEqual(actualCount, expectedCount, file: file, line: line)
        for event in 0..<min(actualCount, expectedCount) {
            for word: UInt32 in 0..<20 {
                XCTAssertEqual(CGraphics_TraceWord(actual, event, word), CGraphics_TraceWord(expected, event, word),
                               "event \(event)/\(word), op \(op)", file: file, line: line)
            }
        }
        return result
    }
}

final class GraphicsDifferentialTests: XCTestCase {
    func testGFXMMUInitializeEveryStateAndAllInterruptMasks() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2, .max] {
                for size: UInt32 in [0, 0x40] {
                    for mask: UInt32 in 0..<32 {
                        let p = GraphicsPair(mode, state: state, seed: 0xA5A5_A5A5)
                        p.set(2, 0, size); p.set(2, 1, 0xCAFE_BABE); p.set(2, 2, mask & 1)
                        for index: UInt32 in 3...6 { p.set(2, index, 0x2400_0000 + index * 0x1000) }
                        p.set(2, 7, mask == 0 ? 0 : 1); p.set(2, 8, mask); p.set(2, 10, .max)
                        p.callback(0, 0, 2); p.callback(0, 1, mask % 3)
                        XCTAssertEqual(p.run(0), 0)
                        XCTAssertEqual(p.run(8), 1)
                        XCTAssertEqual(p.run(9), 0)
                    }
                }
            }
        }
    }
    func testGFXMMURepeatedInitializeAndMSPConfigurationMutation() {
        for mode: UInt32 in 0...1 {
            let p = GraphicsPair(mode)
            p.set(5, 1, 1)
            for _ in 0..<3 {
                XCTAssertEqual(p.run(0), 0)
                XCTAssertEqual(CGraphics_Get(p.actual, 0, 0), 0x40)
                XCTAssertEqual(CGraphics_Get(p.actual, 0, 4), 0x1357_9BDF)
                XCTAssertEqual(CGraphics_Get(p.actual, 0, 8), 0x2401_0000)
            }
        }
    }
    func testGFXMMUDeinitializePreservesConfigurationAndErrors() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2, .max] {
                for token: UInt32 in 0...2 {
                    let p = GraphicsPair(mode, state: state, seed: .max)
                    p.set(2, 10, 0xABCD); p.callback(0, 2, token)
                    XCTAssertEqual(p.run(1), 0)
                    XCTAssertEqual(p.run(8), 0)
                    XCTAssertEqual(CGraphics_Get(p.actual, 2, 10), 0xABCD)
                }
            }
        }
    }
    func testGFXMMUPackingAllActivationAndModeCombinations() {
        for state: UInt32 in [0, 1, 2] {
            for block: UInt32 in [0, 0x40] {
                for enabled: UInt32 in 0..<16 {
                    for modes: UInt32 in 0..<16 {
                        let p = GraphicsPair(enabled & 1, state: state)
                        p.set(0, 0, 0xFFAA_800F | block)
                        XCTAssertEqual(p.run(6, enabled, modes, (enabled << 4) | modes), state == 1 && block != 0 ? 0 : 1)
                    }
                }
            }
        }
    }
    func testGFXMMUBuffersUpdateHardwareWithoutChangingInit() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2, .max] {
                let p = GraphicsPair(mode, state: state, seed: 0xA5A5_A5A5)
                XCTAssertEqual(p.run(5, 0, 0x2400_0010, 0x9000_0000, 0xFFFF_FFF0), state == 1 ? 0 : 1)
                XCTAssertEqual(CGraphics_Get(p.actual, 2, 4), 0)
            }
        }
    }
    func testGFXMMUInterruptEveryFlagAndMaskCombination() {
        for mode: UInt32 in 0...1 {
            for flags: UInt32 in 0..<32 {
                for mask: UInt32 in 0..<32 {
                    let p = GraphicsPair(mode, state: flags & 1)
                    p.set(0, 0, 0x8000 | mask); p.set(0, 1, 0xFFFF_0000 | flags)
                    p.set(2, 10, 0x100); p.callback(0, 0, 1 + (flags & 1))
                    p.run(7)
                    XCTAssertEqual(CGraphics_Get(p.actual, 2, 10), 0x100 | (flags & mask))
                }
            }
        }
    }
    func testGFXMMUErrorReadClearsAndRestoresExactMask() {
        for mode: UInt32 in 0...1 {
            for mask: UInt32 in [0, 1, 0x1234_5679] {
                let p = GraphicsPair(mode)
                p.set(2, 10, .max); p.set(5, 0, mask)
                XCTAssertEqual(p.run(9), .max)
                XCTAssertEqual(p.run(9), 0)
                XCTAssertEqual(CGraphics_Get(p.actual, 5, 0), mask)
            }
        }
    }
    func testGFXMMUCallbackRegistrationAndReset() {
        for state: UInt32 in [0, 1, 2, .max] {
            for id: UInt32 in [0, 1, 2, 3, .max] {
                for token: UInt32 in 0...2 {
                    let p = GraphicsPair(1, state: state)
                    p.set(2, 10, 0x10)
                    p.run(11, id, token); p.run(12, id)
                    for index: UInt32 in 0..<3 { p.callback(0, index, 2) }
                    p.run(10)
                    XCTAssertEqual(CGraphics_GetCallback(p.actual, 0, 0), 2)
                }
            }
        }
    }
    func testGFXMMULUTStateTranslationAndRangeFailures() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2] {
                for translation: UInt32 in [0, 0x8000] {
                    let p = GraphicsPair(mode, state: state)
                    p.set(0, 0, translation)
                    for first: UInt32 in [1, 512, 1023] {
                        XCTAssertEqual(p.run(2, first, 1024), 1)
                        XCTAssertEqual(p.run(3, first, 1024), 1)
                    }
                    if state != 1 || translation == 0 {
                        XCTAssertEqual(p.run(2, 0, 1024), 1)
                        XCTAssertEqual(p.run(3, 0, 1024), 1)
                        XCTAssertEqual(p.run(4, 1023, 1, 0xFFFF, UInt32(bitPattern: -255)), 1)
                    }
                }
            }
        }
    }
    func testGPU2DLifecycleAcrossAllStatesLocksAndCallbackModes() {
        for mode: UInt32 in 0...1 {
            for state: UInt32 in [0, 1, 2, 3, 4, .max] {
                for lock: UInt32 in [0, 1, 2] {
                    for token: UInt32 in 0...2 {
                        for op: UInt32 in [20, 21] {
                            let p = GraphicsPair(mode, state: state, seed: 0xA5A5_A5A5)
                            p.set(3, 0, lock); p.set(3, 2, .max)
                            p.callback(1, 0, token); p.callback(1, 1, token); p.callback(1, 2, 2)
                            p.run(op); p.run(26); p.run(27)
                        }
                    }
                }
            }
        }
    }
    func testGPU2DCallbackMSPMutationBeforeLockAllocation() {
        for mode: UInt32 in 0...1 {
            let p = GraphicsPair(mode)
            p.set(5, 1, 1); p.set(3, 0, 1)
            XCTAssertEqual(p.run(20), 0)
            XCTAssertEqual(CGraphics_Get(p.actual, 3, 0), 0)
            XCTAssertEqual(p.run(21), 0)
            XCTAssertEqual(CGraphics_Get(p.actual, 3, 0), 0)
        }
    }
    func testGPU2DAllAlignedRegisterOffsetsAndMasks() {
        let p = GraphicsPair(0, state: 4)
        p.set(3, 0, 1)
        for offset: UInt32 in stride(from: 0, to: 0x1000, by: 4) {
            XCTAssertEqual(p.run(23, offset, offset ^ 0xA5A5_FFFF), 0)
            XCTAssertEqual(p.run(22, offset), offset ^ 0xA5A5_FFFF)
        }
        for flags: UInt32 in [0, 1, 2, 0xCAFE_BABE, .max] {
            for mask: UInt32 in [0, 1, 2, 0xCAFE, .max] {
                p.set(1, 0xF8 / 4, flags)
                p.run(29, mask); p.run(31, mask); p.run(30, mask)
            }
        }
    }
    func testGPU2DInterruptFlagsCommandIDsAndNullCompletion() {
        for mode: UInt32 in 0...1 {
            for flags: UInt32 in [0, 1, 2, 3, .max] {
                for id: UInt32 in [0, 1, 0x1234_5678, .max] {
                    for token: UInt32 in 0...2 {
                        let p = GraphicsPair(mode, state: 3)
                        p.set(1, 0xF8 / 4, flags); p.set(1, 0x148 / 4, id)
                        p.set(3, 0, 1); p.callback(1, 2, token)
                        p.run(24); p.run(25)
                    }
                }
            }
        }
    }
    func testGPU2DCallbackRegistrationStateLockAndNullOrder() {
        for state: UInt32 in [0, 1, 2, 3, 4, .max] {
            for lock: UInt32 in [0, 1, 2] {
                for id: UInt32 in [0, 1, 2, .max] {
                    for token: UInt32 in 0...2 {
                        let p = GraphicsPair(1, state: state)
                        p.set(3, 0, lock); p.set(3, 2, 0x80)
                        p.run(32, 0, id, token); p.run(33, 0, id)
                        p.run(34, 0, token); p.run(35)
                        for index: UInt32 in 0..<3 { p.callback(1, index, 2) }
                        p.run(28)
                    }
                }
            }
        }
    }
    func testNullableHandlesAndLegacyResetLeaveOtherFieldsUntouched() {
        for mode: UInt32 in 0...1 {
            let p = GraphicsPair(mode, state: 4)
            p.set(3, 0, 1); p.set(3, 2, 0x1234)
            for op: UInt32 in [0, 1, 20, 21] { XCTAssertEqual(p.run(op, 1), 1) }
            if mode != 0 {
                for op: UInt32 in [32, 33, 34, 35] { XCTAssertEqual(p.run(op, 1), 1) }
            }
            p.run(10); p.run(28)
            XCTAssertEqual(CGraphics_Get(p.actual, 3, 0), 1)
            XCTAssertEqual(CGraphics_Get(p.actual, 3, 2), 0x1234)
        }
    }
}
