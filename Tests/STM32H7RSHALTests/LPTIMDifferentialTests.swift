import XCTest
import CLPTIMReference
import STM32H7RSHAL

final class LPTIMPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CLPTIM_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CLPTIM_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    let mode: UInt32
    let instance: LPTIMInstance
    init(_ mode: UInt32 = 0, instance: LPTIMInstance = .lptim1, seed: UInt32 = 0) {
        self.mode = mode; self.instance = instance
        CLPTIM_Reset(actual, mode, instance.rawValue); CLPTIM_Reset(expected, mode, instance.rawValue)
        for register in LPTIMRegister.allCases { set(0, register.rawValue / 4, seed) }
        set(0, 0, .max); set(1, 4, 0xFFFF); set(1, 7, 1); set(1, 16, 1); set(1, 17, 1); set(1, 18, 1)
        set(2, 0, 20000)
        for id: UInt32 in 0..<16 { callback(id, 1) }
    }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    var io: LPTIMReferenceIO { .init(state: actual, mode: mode, instance: instance) }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) {
        CLPTIM_Set(actual, area, index, value); CLPTIM_Set(expected, area, index, value)
    }
    func callback(_ id: UInt32, _ token: UInt32) {
        CLPTIM_SetCallback(actual, id, token); CLPTIM_SetCallback(expected, id, token)
    }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CLPTIM_Get(actual, area, index) }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0,
             file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(3, 0, 0); set(2, 1, 0); set(2, 8, 0)
        let expectedResult = CLPTIM_Run(expected, op, a, b, c)
        let result = io.run(op, a, b, c)
        let label = "mode \(mode), instance \(instance), op \(op), args \([a,b,c])"
        XCTAssertEqual(result, expectedResult, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0, 14), (1, 19), (2, 10), (4, 6), (5, 1), (6, 24), (7, 9)] {
            for index in 0..<count {
                XCTAssertEqual(CLPTIM_Get(actual, area, index), CLPTIM_Get(expected, area, index),
                               "\(label), area \(area), word \(index)", file: file, line: line)
            }
        }
        for id: UInt32 in 0..<16 { XCTAssertEqual(CLPTIM_GetCallback(actual, id), CLPTIM_GetCallback(expected, id), label, file: file, line: line) }
        for ch: UInt32 in 1...2 { for id: UInt32 in 0..<3 {
            XCTAssertEqual(CLPTIM_GetDMACallback(actual, ch, id), CLPTIM_GetDMACallback(expected, ch, id), label, file: file, line: line)
        } }
        let count = CLPTIM_TraceCount(actual), referenceCount = CLPTIM_TraceCount(expected)
        XCTAssertEqual(count, referenceCount, label, file: file, line: line)
        for event in 0..<min(count, referenceCount) { for word: UInt32 in 0..<95 {
            XCTAssertEqual(CLPTIM_TraceWord(actual, event, word), CLPTIM_TraceWord(expected, event, word),
                           "\(label), event \(event)/\(word)", file: file, line: line)
        } }
        return result
    }
}
final class LPTIMDifferentialTests: XCTestCase {
    func testInitializationAllClockTriggerConfigurationsAndInstances() {
        for instance in LPTIMInstance.allCases { for clock: UInt32 in 0...1 { for prescaler in LPTIMPrescaler.allCases {
            for trigger in LPTIMTriggerSource.allCases { for counter in LPTIMCounterSource.allCases {
                let p = LPTIMPair(clock, instance: instance, seed: .max)
                p.set(1, 0, clock); p.set(1, 1, prescaler.rawValue); p.set(1, 2, 4); p.set(1, 3, 0x18)
                p.set(1, 4, trigger.rawValue); p.set(1, 5, 0x60000); p.set(1, 6, 0xC0)
                p.set(1, 7, 0xFFFF); p.set(1, 8, 0x400000); p.set(1, 9, counter.rawValue); p.set(1, 12, 0xFF)
                XCTAssertEqual(p.run(0), 0)
            } }
        } } }
    }
    func testInitializationDeinitializationStatesAndMSPCallbacks() {
        for mode: UInt32 in 0...1 { for instance in LPTIMInstance.allCases { for state: UInt32 in [0, 1, 2, 3, 4, .max] {
            for token: UInt32 in 0...2 {
                let p = LPTIMPair(mode, instance: instance, seed: 0xA5A5A5A5)
                p.set(1, 16, state); p.set(1, 15, 1); p.callback(0, token); p.callback(1, token)
                XCTAssertEqual(p.run(0), 0); XCTAssertEqual(p.run(1), 0)
                XCTAssertEqual(p.get(1, 15), 0); XCTAssertEqual(p.run(41), 0)
            }
        } } }
    }
    func testWriteTimeoutsAndLastIterationArrival() {
        for instance in LPTIMInstance.allCases { for op: UInt32 in [0, 1, 4, 5, 8, 9, 12, 13, 18, 20, 21, 24, 25, 30] {
            for missing: UInt32 in [0x100, 0x10, 0x8, 0x80000, 0x1000000, .max] {
                let p = LPTIMPair(1, instance: instance)
                p.set(0, 0, ~missing); _ = p.run(op)
            }
        } }
        for arrival: UInt32 in [1, 2, 999, 1000, 1001] {
            let p = LPTIMPair(); p.set(0, 0, 0); p.set(2, 2, arrival); p.set(2, 3, 0x1000000)
            XCTAssertEqual(p.run(24), arrival < 1000 ? 0 : 3)
            XCTAssertEqual(p.get(2, 1), min(arrival, 1000))
        }
        for clock: UInt32 in [0, 19, 19999, 20000, 64000000, .max] {
            let p = LPTIMPair(); p.set(2, 0, clock); XCTAssertEqual(p.run(24), 0)
        }
    }
    func testWaveformsChannelStatesTriggerSourcesAndStopMasks() {
        for instance in LPTIMInstance.allCases { for ch: UInt32 in 0..<(instance.supportsCaptureAndDMA ? 2 : 1) {
            for op: UInt32 in 2...13 { for state: UInt32 in [0, 1, 2, .max] { for trigger: UInt32 in [0, 0xFFFF] {
                let p = LPTIMPair(op & 1, instance: instance, seed: .max)
                p.set(1, 17 + ch, state); p.set(1, 4, trigger); _ = p.run(op, ch)
            } } }
        } }
        let p = LPTIMPair(seed: .max); XCTAssertEqual(p.run(13), 0)
        XCTAssertNotEqual(p.get(0, 2) & LPTIMInterrupts.update.rawValue, 0)
    }
    func testEncoderTimeoutCounterAndCaptureModes() {
        for instance in LPTIMInstance.allCases { for op: UInt32 in 14...29 {
            if !instance.supportsCaptureAndDMA && (op < 18 || op > 25) { continue }
            for bits: UInt32 in 0..<8 {
                let p = LPTIMPair(bits & 1, instance: instance, seed: bits & 2 == 0 ? 0 : .max)
                p.set(1, 2, 2); p.set(1, 9, bits & 4 == 0 ? 0 : 0x800000)
                _ = p.run(op, op == 18 || op == 20 ? 0xFFFF : bits & 1)
            }
        } }
    }
    func testOutputComparePolarityAndCaptureFilters() {
        for instance in LPTIMInstance.allCases { for ch: UInt32 in 0..<(instance.supportsCaptureAndDMA ? 2 : 1) {
            for polarity: UInt32 in 0...1 { for pulse: UInt32 in [0, 1, 0xFFFF] {
                let p = LPTIMPair(polarity, instance: instance, seed: .max)
                p.set(4, 0, pulse); p.set(4, 1, polarity); XCTAssertEqual(p.run(30, ch), 0)
            } }
            if instance.supportsCaptureAndDMA {
                for prescaler in LPTIMCapturePrescaler.allCases { for polarity in LPTIMCapturePolarity.allCases { for filter in LPTIMCaptureFilter.allCases {
                    for source: UInt32 in (ch == 0 || instance == .lptim3 ? [0] : [0, 0x100000, 0x200000]) {
                        let p = LPTIMPair(1, instance: instance, seed: .max)
                        p.set(4, 2, source); p.set(4, 3, prescaler.rawValue); p.set(4, 4, polarity.rawValue); p.set(4, 5, filter.rawValue)
                        XCTAssertEqual(p.run(31, ch), 0)
                    }
                } } }
            }
        } }
    }
    func testAllInputCaptureOffsetsAndReadMacros() {
        for prescaler in LPTIMPrescaler.allCases { for filter in LPTIMCaptureFilter.allCases { for ch: UInt32 in 0...1 {
            let p = LPTIMPair(); p.set(0, 3, prescaler.rawValue); p.set(0, 11, filter.rawValue << (ch * 16)); _ = p.run(40, ch)
        } } }
        for instance in LPTIMInstance.allCases { for seed: UInt32 in [0, .max, 0xA5A5A5A5, 0x5A5A5A5A] {
            let p = LPTIMPair(seed & 1, instance: instance, seed: seed)
            for op: UInt32 in 37...39 { _ = p.run(op) }
            for op: UInt32 in 45...65 { _ = p.run(op, [52,55,56].contains(op) ? 0 : seed, seed) }
        } }
    }
    func testLiveInterruptFlagsAndCallbackChannelLifetime() {
        let flags: [UInt32] = [1, 0x200, 0x1000, 0x2000, 2, 4, 8, 0x80000, 0x10, 0x20, 0x40, 0x80, 0x100]
        for mask: UInt32 in 0..<8192 {
            var bits: UInt32 = 0
            for i in 0..<13 where mask & (1 << i) != 0 { bits |= flags[i] }
            let p = LPTIMPair(mask & 1)
            p.set(0, 0, bits); p.set(0, 2, .max); p.set(0, 11, mask & 2 == 0 ? 0 : 0x10001)
            _ = p.run(36)
        }
        for flag in flags { for source in flags { for mutate: UInt32 in 0...1 {
            let p = LPTIMPair(mutate); p.set(0, 0, flag); p.set(0, 2, source); p.set(2, 4, mutate); _ = p.run(36)
        } } }
        for mode: UInt32 in 0...1 {
            let p = LPTIMPair(mode); p.set(0, 2, .max); p.set(2, 4, 1); _ = p.run(36)
            XCTAssertEqual(CLPTIM_TraceCount(p.actual), 1)
        }
    }
    func testCallbackRegistrationAndReset() {
        for state: UInt32 in [0, 1, 2, 3, 4, .max] { for id: UInt32 in 0...17 { for token: UInt32 in 0...2 {
            let p = LPTIMPair(1); p.set(1, 16, state); _ = p.run(43, id, token); _ = p.run(44, id)
        } } }
        for mode: UInt32 in 0...1 { let p = LPTIMPair(mode); _ = p.run(42) }
    }
    func testDMAStartsStopsFailuresAndLinkedListNodes() {
        for op: UInt32 in [32, 34] { for ch: UInt32 in 0...1 { for mode: UInt32 in [0, 1, 0x80, 0x81] {
            for queue: UInt32 in 0...1 { for head: UInt32 in 0...1 { for status: UInt32 in 0...3 {
                let p = LPTIMPair(status & 1, seed: .max)
                p.set(7, (ch + 1) * 3, mode); p.set(7, (ch + 1) * 3 + 1, queue); p.set(7, (ch + 1) * 3 + 2, head)
                p.set(2, 5, status); p.set(2, 6, status)
                _ = p.run(op, ch, 0x24001000, 123); _ = p.run(op + 1, ch)
            } } }
        } } }
        for op: UInt32 in [32, 34] { for ch: UInt32 in 0...1 { for status: UInt32 in [0, 1, 2, .max] {
            for address: UInt32 in [0, 0x24001000] { for length: UInt32 in [0, 1, .max] {
                let p = LPTIMPair(); p.set(1, 17 + ch, status); _ = p.run(op, ch, address, length)
            } }
        } } }
        for op: UInt32 in [32, 34] { let p = LPTIMPair(); p.set(0, 0, 0); XCTAssertEqual(p.run(op, 0, 0x24001000, 16), 3) }
    }
    func testDMACallbacksAndMutation() {
        for mode: UInt32 in 0...1 { for kind: UInt32 in 0..<5 { for source: UInt32 in 0..<3 { for mutate: UInt32 in 0...1 {
            let p = LPTIMPair(mode); p.set(1, 13, 0x55); p.set(1, 16, 2); p.set(1, 17, 2); p.set(1, 18, 2); p.set(2, 4, mutate)
            _ = p.run(66, kind, source)
            XCTAssertEqual(p.get(1, 17), 2); XCTAssertEqual(p.get(1, 18), 2)
        } } } }
    }
}
