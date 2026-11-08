import XCTest
import CMCEReference
import STM32H7RSHAL

final class MCEPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CMCE_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CMCE_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    init(_ mode: UInt32 = 0, _ instance: UInt32 = 1) { CMCE_Reset(actual, mode, instance); CMCE_Reset(expected, mode, instance) }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CMCE_Set(actual, area, index, value); CMCE_Set(expected, area, index, value) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CMCE_Get(actual, area, index) }
    func callback(_ id: UInt32, _ token: UInt32) { CMCE_SetCallback(actual, id, token); CMCE_SetCallback(expected, id, token) }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(6, 0, 0)
        let wanted = CMCE_Run(expected, op, a, b), result = MCEModel(state: actual).run(op, a, b)
        let label = "mode \(get(7, 0)), instance \(get(7, 1)), op \(op), args \([a,b])"
        XCTAssertEqual(result, wanted, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0,192),(1,3),(2,8),(3,10),(4,4),(5,2)] {
            let actualWords = (0..<count).map { CMCE_Get(actual, area, $0) }
            let expectedWords = (0..<count).map { CMCE_Get(expected, area, $0) }
            XCTAssertEqual(actualWords, expectedWords, "\(label), area \(area)", file: file, line: line)
        }
        for id: UInt32 in 0..<3 { XCTAssertEqual(CMCE_GetCallback(actual, id), CMCE_GetCallback(expected, id), label, file: file, line: line) }
        let events = get(6, 0), expectedEvents = CMCE_Get(expected, 6, 0)
        XCTAssertEqual(events, expectedEvents, label, file: file, line: line)
        for event in 0..<min(events, expectedEvents) {
            let actualWords = (0..<208).map { CMCE_TraceWord(actual, event, $0) }
            let expectedWords = (0..<208).map { CMCE_TraceWord(expected, event, $0) }
            XCTAssertEqual(actualWords, expectedWords, "\(label), event \(event)", file: file, line: line)
        }
        return result
    }
}
final class MCEDifferentialTests: XCTestCase {
    func testInitializationDeinitializationCallbacksAndState() {
        for mode: UInt32 in 0...1 { for instance: UInt32 in 1...3 { for state: UInt32 in [0,1,2,7] {
            for token: UInt32 in 0...2 { for mutation: UInt32 in 0...1 {
                let p = MCEPair(mode, instance)
                for i: UInt32 in 0..<192 { p.set(0, i, .max) }
                p.set(1, 0, state); p.set(1, 1, 1); p.set(1, 2, 0x100)
                p.callback(1, token); p.callback(2, token); p.set(2, 5, mutation)
                XCTAssertEqual(p.run(0), 0); XCTAssertEqual(p.run(1), 0)
                _ = p.run(17); _ = p.run(18); _ = p.run(19)
            } }
        } } }
    }
    func testNoekeonBothKeyKindsLocksNilUnknownAndTickWrap() {
        for mode: UInt32 in 0...1 { for instance: UInt32 in 2...3 { for type: UInt32 in [0,1,2,.max] {
            for lock: UInt32 in [0,1,2] { for cr: UInt32 in 0...3 { for present: UInt32 in 0...1 {
                let p = MCEPair(mode, instance); p.set(0, 0, cr); p.set(0, 1, 5); p.set(1, 1, lock); p.set(2, 0, present)
                for i: UInt32 in 0..<4 { p.set(4, i, 0xFEDD1234 &+ i) }
                _ = p.run(2, type)
            } } }
        } } }
        for type: UInt32 in 0...1 { for ready: UInt32 in [0,1,2,255,256,257,258] { for start: UInt32 in [0,.max - 3] {
            let p = MCEPair(1, 2); p.set(5, 0, start); p.set(2, 3, ready); p.set(2, 4, type == 0 ? 1 : 4)
            _ = p.run(2, type)
        } } }
    }
    func testAESConfigurationsAndContextLocksIncludingAlreadyDesiredState() {
        for mode: UInt32 in 0...1 { for context: UInt32 in [0,0x200,0x400] { for flags: UInt32 in 0..<8 {
            for global: UInt32 in 0...1 { for lock: UInt32 in [0,1,2] { for present: UInt32 in 0..<4 {
                let p = MCEPair(mode); p.set(0, 0, global); p.set(1, 1, lock)
                p.set(0, 0x240 / 4, 0xABCD1200 | flags); p.set(0, 0x270 / 4, 0x56783400 | flags)
                p.set(2, 0, present & 1); p.set(2, 1, (present >> 1) & 1)
                p.set(3, 6, 0xFEDCBA98); p.set(3, 7, 0x12345678); p.set(3, 8, 0xF9876543)
                for i: UInt32 in 0..<4 { p.set(4, i, i &* 0x12345678) }
                _ = p.run(3, context)
                for op: UInt32 in [6,7,11,12] { _ = p.run(op, context) }
            } } }
        } } }
        for instance: UInt32 in 2...3 { let p = MCEPair(0, instance); for op: UInt32 in [6,7,11,12] { XCTAssertEqual(p.run(op, 0), 1) } }
    }
    func testRegionConfigurationPreservesContextAndAllInstances() {
        for instance: UInt32 in 1...3 { for region: UInt32 in 0..<4 { for options: UInt32 in 0..<64 {
            let cipher = ((options >> 2) & 3) << 14
            if instance != 1 && cipher == 0x4000 { continue }
            let p = MCEPair(options & 1, instance); p.set(0, (0x40 + 0x10 * region) / 4, 0xA5A50600 | (options & 1))
            p.set(0, (0x4C + 0x10 * region) / 4, .max)
            p.set(3, 0, 0x200); p.set(3, 1, 0x90001000); p.set(3, 2, 0x9000FFFF)
            p.set(3, 3, cipher); p.set(3, 4, ((options >> 4) & 1) << 16); p.set(3, 5, ((options >> 5) & 1) << 16)
            XCTAssertEqual(p.run(4, region), 0)
            XCTAssertEqual(p.get(0, (0x40 + region * 0x10) / 4) & 0x600, 0x600)
            for context: UInt32 in instance == 1 ? [0,0x200,0x400] : [0] { XCTAssertEqual(p.run(5, context, region), 0) }
            XCTAssertEqual(p.run(8, region), 1); XCTAssertEqual(p.run(9, region), 0); XCTAssertEqual(p.run(9, region), 1)
            XCTAssertEqual(p.run(8, region), 0)
        } } }
        for op: UInt32 in [4,5,8,9,10,13] { for cr: UInt32 in 0...3 { for lock: UInt32 in [0,1,2] {
            let p = MCEPair(); p.set(0, 0, cr); p.set(1, 1, lock); _ = p.run(op)
        } } }
        let p = MCEPair(); p.set(2, 1, 0); XCTAssertEqual(p.run(4), 1)
    }
    func testCRCGetterPreservesIncomingValueQuirk() {
        for context: UInt32 in [0x200,0x400] { for crc: UInt32 in 0...255 { for initial: UInt32 in [0,1,.max] {
            let p = MCEPair(); p.set(0, (0x240 + ((context - 0x200) >> 9) * 0x30) / 4, 0x12340007 | (crc << 8))
            p.set(3, 9, initial); XCTAssertEqual(p.run(14, context), initial == 0 ? 1 : 0); XCTAssertEqual(p.get(3, 9), crc)
        } } }
    }
    func testKeyCRCZeroOnesEveryBitAndSeededVectors() {
        var seed: UInt32 = 0xDEADBEEF
        for vector in 0..<4226 {
            var key = [UInt32](repeating: 0, count: 4)
            if vector == 1 { key = [.max,.max,.max,.max] }
            else if vector >= 2 && vector < 130 { key[(vector - 2) / 32] = 1 << ((vector - 2) % 32) }
            else if vector >= 130 { for i in 0..<4 { seed ^= seed << 13; seed ^= seed >> 17; seed ^= seed << 5; key[i] = seed } }
            key.withUnsafeBufferPointer { XCTAssertEqual(MCEKeyCRC.compute($0.baseAddress!), CMCE_KeyCRC($0.baseAddress!), "vector \(vector)") }
        }
    }
    func testInterruptSnapshotsCallbacksFlagsAndW1C() {
        for mode: UInt32 in 0...1 { for flags: UInt32 in 0..<4 { for access: UInt32 in [0,0x10,0x80,0x90] {
            for enable: UInt32 in 0..<4 { for mutation: UInt32 in 0...1 { for w1c: UInt32 in 0...1 {
                let p = MCEPair(mode); p.set(0, 2, flags | 0x8000); p.set(0, 8, access | 3); p.set(0, 4, enable)
                p.set(1, 2, 0x100); p.set(2, 5, mutation); p.set(2, 6, w1c); p.callback(0, 2)
                for flag in MCEFlag.allCases { _ = p.run(22, flag.rawValue) }
                _ = p.run(16)
                for flag in MCEFlag.allCases { _ = p.run(23, flag.rawValue) }
                _ = p.run(20, 3); _ = p.run(21, 2)
            } } }
        } } }
    }
}
