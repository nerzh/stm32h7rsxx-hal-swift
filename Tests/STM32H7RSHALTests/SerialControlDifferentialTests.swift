import XCTest
import CSerialControlReference
import STM32H7RSHAL

final class SerialControlPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CSerial_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CSerial_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    let kind: UInt32
    let mode: UInt32
    init(_ kind: UInt32, _ mode: UInt32 = 0, seed: UInt32 = 0) {
        self.kind = kind; self.mode = mode
        CSerial_Reset(actual, kind, mode); CSerial_Reset(expected, kind, mode)
        for index: UInt32 in 0..<(kind == 0 ? 128 : 6) { set(0, index, seed) }
        if kind == 0 { set(1, 2, 1) }
        else { set(1, 9, 0x20); set(1, 10, 0x20); set(1, 13, 2) }
        for id: UInt32 in 0..<(kind == 0 ? 6 : 5) { callback(id, 1) }
    }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) {
        CSerial_Set(actual, area, index, value); CSerial_Set(expected, area, index, value)
    }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CSerial_Get(actual, area, index) }
    func callback(_ id: UInt32, _ token: UInt32) { CSerial_SetCallback(actual, id, token); CSerial_SetCallback(expected, id, token) }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0,
             file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(6, 0, 0)
        let expectedResult = CSerial_Run(expected, op, a, b, c)
        let result = kind == 0 ? SerialMDIOSIO(state: actual, mode: mode).run(op, a, b, c)
                              : SerialCECIO(state: actual, mode: mode).run(op, a, b, c)
        let label = "kind \(kind), mode \(mode), op \(op), args \([a,b,c])"
        XCTAssertEqual(result, expectedResult, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0, kind == 0 ? 128 : 6), (1, kind == 0 ? 5 : 15), (2, 2), (3, 4), (4, 5)] {
            for index in 0..<count { XCTAssertEqual(CSerial_Get(actual, area, index), CSerial_Get(expected, area, index), "\(label), area \(area)/\(index)", file: file, line: line) }
        }
        for id: UInt32 in 0..<(kind == 0 ? 6 : 5) { XCTAssertEqual(CSerial_GetCallback(actual, id), CSerial_GetCallback(expected, id), label, file: file, line: line) }
        for index: UInt32 in 65535..<65582 { XCTAssertEqual(CSerial_Get(actual, 5, index), CSerial_Get(expected, 5, index), "\(label), byte \(index)", file: file, line: line) }
        let count = CSerial_TraceCount(actual), expectedCount = CSerial_TraceCount(expected)
        XCTAssertEqual(count, expectedCount, label, file: file, line: line)
        for event in 0..<min(count, expectedCount) { for word: UInt32 in 0..<180 {
            XCTAssertEqual(CSerial_TraceWord(actual, event, word), CSerial_TraceWord(expected, event, word), "\(label), event \(event)/\(word)", file: file, line: line)
        } }
        return result
    }
}
final class MDIOSDifferentialTests: XCTestCase {
    func testInitializationPortPreambleStatesAndMSPConfigurationChanges() {
        for mode: UInt32 in 0...1 { for port: UInt32 in 0..<32 { for preamble: UInt32 in [0, 0x80] {
            for state: UInt32 in [0, 1, 2, 4, .max] {
                let p = SerialControlPair(0, mode, seed: .max)
                p.set(1, 0, port); p.set(1, 1, preamble); p.set(1, 2, state); p.set(1, 3, 0x8000); p.set(1, 4, 1)
                p.callback(0, port % 3); p.callback(1, port % 3); p.set(3, 1, port & 1)
                XCTAssertEqual(p.run(0), 0); XCTAssertEqual(p.run(1), 0); XCTAssertEqual(p.get(1, 3), 0)
            }
        } } }
    }
    func testAllRegistersWordAccessTruncationAndLiteralClearIndex() {
        for mode: UInt32 in 0...1 { for index: UInt32 in 0..<32 { for lock: UInt32 in [0, 1, 2] {
            let p = SerialControlPair(0, mode, seed: 0xF00DCAFE)
            p.set(1, 4, lock); p.set(3, 2, 0x1234)
            _ = p.run(2, index, 0xFFFF); _ = p.run(3, index); _ = p.run(6, index); _ = p.run(7, index); _ = p.run(8)
            if lock != 1 { XCTAssertEqual(p.get(0, 96 + index), 0xFFFF); XCTAssertEqual(p.get(3, 2), 0xCAFE) }
        } } }
        let p = SerialControlPair(0); XCTAssertEqual(p.run(6, 5), 0); XCTAssertEqual(p.get(0, 2), 5)
    }
    func testInterruptSourcesFlagsWakeupAndCallbackMutation() {
        for mode: UInt32 in 0...1 { for source: UInt32 in 0..<8 { for errors: UInt32 in 0..<8 { for flags: UInt32 in 0..<8 {
            let p = SerialControlPair(0, mode)
            p.set(0, 0, source << 1); p.set(0, 5, errors); p.set(0, 1, flags & 1 == 0 ? 0 : .max); p.set(0, 3, flags & 2 == 0 ? 0 : .max)
            p.set(4, 1, flags & 4 == 0 ? 0 : 0x400); p.set(1, 3, 0x8000); p.set(3, 0, flags & 1)
            _ = p.run(9)
        } } } }
        let p = SerialControlPair(0); p.set(0, 0, 8); p.set(1, 3, 0x1234); _ = p.run(9)
        XCTAssertEqual(p.get(1, 3), 0)
    }
    func testCallbackLocksNilValidationResetAndMacros() {
        for state: UInt32 in [0, 1, 2, 4, .max] { for lock: UInt32 in [0, 1, 2] { for id: UInt32 in 0...7 { for token: UInt32 in 0...2 {
            let p = SerialControlPair(0, 1); p.set(1, 2, state); p.set(1, 4, lock)
            _ = p.run(12, id, token); _ = p.run(13, id)
        } } } }
        for mode: UInt32 in 0...1 { for seed: UInt32 in [0, .max, 0xA5A5A5A5] {
            let p = SerialControlPair(0, mode, seed: seed)
            for op: UInt32 in [4, 5, 10, 11, 14] + Array(15...30) { _ = p.run(op, seed) }
        } }
    }
}
final class CECDifferentialTests: XCTestCase {
    func testAllConfigurationOptionsAndLifecycleCallbacks() {
        for sft: UInt32 in 0..<8 { for mask: UInt32 in 0..<128 {
            let p = SerialControlPair(1, mask & 1, seed: .max); p.set(1, 0, sft)
            for i: UInt32 in 1...7 { p.set(1, i, mask & (1 << (i - 1)) == 0 ? 0 : i == 7 ? 0x80000000 : 1 << (i + 2)) }
            p.set(1, 12, 0x7FFF); p.set(1, 9, sft & 1 == 0 ? 0 : 0x20)
            p.callback(3, mask % 3); p.callback(4, mask % 3); p.set(3, 1, sft & 1)
            XCTAssertEqual(p.run(0), 0); XCTAssertEqual(p.run(1), 0)
        } }
        let p = SerialControlPair(1); _ = p.run(6, 0); XCTAssertEqual(p.run(0), 1)
    }
    func testOwnAddressAccumulatesBitsAndRequiresBothReadyStates() {
        for global: UInt32 in [0, 0x20, 0x21, 0x24, 0x50] { for receive: UInt32 in [0, 0x20, 0x22] { for lock: UInt32 in [0, 1, 2] {
            let p = SerialControlPair(1); p.set(1, 9, global); p.set(1, 10, receive); p.set(1, 8, lock)
            for address: UInt32 in [1, 0x4000, 0x1234, 0] { _ = p.run(2, address) }
        } } }
    }
    func testTransmitHeaderPayloadAndZeroLengthPollingMessage() {
        for initiator: UInt32 in 0..<16 { for destination: UInt32 in 0..<16 { for count: UInt32 in [0, 1, 2, 16] {
            let p = SerialControlPair(1, count & 1); p.set(3, 2, count)
            XCTAssertEqual(p.run(3, initiator, destination, count == 0 ? 0 : 65537), 0)
            for _ in 0..<count { p.set(0, 4, 0x100); _ = p.run(4) }
            p.set(0, 4, 0x200); _ = p.run(4); XCTAssertEqual(p.get(1, 9), 0x20)
        } } }
        for state: UInt32 in [0, 0x20, 0x21] { for lock: UInt32 in [0, 1] { for count: UInt32 in [0, 1] {
            let p = SerialControlPair(1); p.set(1, 9, state); p.set(1, 8, lock); p.set(3, 2, count); _ = p.run(3, 0, 15, 0)
        } } }
    }
    func testAllInterruptCombinationsIgnoreIERAndPreserveCallbackSnapshots() {
        for mode: UInt32 in 0...1 { for flags: UInt32 in 0..<8192 {
            let p = SerialControlPair(1, mode)
            p.set(0, 4, flags); p.set(0, 3, 0xABCDEF98); p.set(0, 5, 0)
            p.set(1, 9, 0x21); p.set(1, 14, 3); p.set(2, 1, 65540)
            _ = p.run(4)
        }
        }
        for flags: UInt32 in [0x1FFF, 3, 0x300, 0x1C80, 0x1C02, 0x7F] { for mode: UInt32 in 0...1 {
            let p = SerialControlPair(1, mode); p.set(0, 4, flags); p.set(3, 0, 1); _ = p.run(4)
        } }
    }
    func testReceiveFramesPointerRewindSizeResetAndSixteenBitWrap() {
        for mode: UInt32 in 0...1 { for size: UInt32 in [0, 1, 16] {
            let p = SerialControlPair(1, mode)
            for index in 0..<size { p.set(0, 4, 1); p.set(0, 3, index); _ = p.run(4); XCTAssertEqual(p.run(5), index + 1) }
            p.set(0, 4, 2); _ = p.run(4); XCTAssertEqual(p.get(2, 1), 65537); XCTAssertEqual(p.run(5), 0)
        } }
        let p = SerialControlPair(1); p.set(1, 13, 0); p.set(1, 14, 0xFFFF); p.set(0, 4, 0x101); _ = p.run(4)
        XCTAssertEqual(p.get(1, 13), 0xFFFF); XCTAssertEqual(p.get(1, 14), 0)
    }
    func testCallbackRegistrationSeparatesReceiveStateAndSignature() {
        for global: UInt32 in [0, 0x20, 0x21, 0x24] { for receive: UInt32 in [0, 0x20, 0x22] { for lock: UInt32 in [0, 1, 2] {
            for id: UInt32 in 0...6 { for token: UInt32 in 0...2 {
                let p = SerialControlPair(1, 1); p.set(1, 9, global); p.set(1, 10, receive); p.set(1, 8, lock)
                _ = p.run(9, id, token); _ = p.run(10, id); _ = p.run(11, token); _ = p.run(12)
            } }
        } } }
        for mode: UInt32 in 0...1 { let p = SerialControlPair(1, mode); _ = p.run(13) }
    }
    func testStateFlagControlAndAddressMacros() {
        for seed: UInt32 in [0, .max, 0xA5A5A5A5] {
            let p = SerialControlPair(1, seed & 1, seed: seed)
            p.set(1, 9, 0x21); p.set(1, 10, 0x22); XCTAssertEqual(p.run(7), 0x23)
            for op: UInt32 in [5, 8] + Array(14...26) { _ = p.run(op, seed) }
            _ = p.run(6, 65569)
        }
    }
}
