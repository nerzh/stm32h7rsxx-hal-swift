import XCTest
import CMDFReference
import STM32H7RSHAL

final class MDFPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CMDF_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CMDF_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    init(_ mode: UInt32 = 0) { CMDF_Reset(actual, mode); CMDF_Reset(expected, mode); set(1, 12, 1) }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CMDF_Set(actual, area, index, value); CMDF_Set(expected, area, index, value) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CMDF_Get(actual, area, index) }
    func reg(_ register: MDFRegister, _ value: UInt32) { set(0, register.rawValue / 4, value) }
    func callback(_ id: UInt32, _ token: UInt32) { CMDF_SetCallback(actual, id, token); CMDF_SetCallback(expected, id, token) }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(10, 0, 0)
        let wanted = CMDF_Run(expected, op, a, b), result = MDFModel(state: actual).run(op, a, b)
        let label = "mode \(get(11, 0)), op \(op), args \([a,b])"
        XCTAssertEqual(result, wanted, label, file: file, line: line)
        let counts: [UInt32] = [64,14,26,3,9,12,6,3,1,2]
        for area: UInt32 in 0..<10 {
            XCTAssertEqual((0..<counts[Int(area)]).map { CMDF_Get(actual, area, $0) }, (0..<counts[Int(area)]).map { CMDF_Get(expected, area, $0) }, "\(label), area \(area)", file: file, line: line)
        }
        for i: UInt32 in 1...7 { XCTAssertEqual(CMDF_GetCallback(actual, i), CMDF_GetCallback(expected, i), label, file: file, line: line) }
        let events = get(10, 0), expectedEvents = CMDF_Get(expected, 10, 0)
        XCTAssertEqual(events, expectedEvents, label, file: file, line: line)
        for e in 0..<min(events, expectedEvents) {
            XCTAssertEqual((0..<160).map { CMDF_TraceWord(actual, e, $0) }, (0..<160).map { CMDF_TraceWord(expected, e, $0) }, "\(label), event \(e)", file: file, line: line)
        }
        return result
    }
}
final class MDFDifferentialTests: XCTestCase {
    func testInitializationOptionsGlobalOwnerAndMSPMutation() {
        for mode: UInt32 in 0...1 { for options: UInt32 in 0..<512 {
            let p = MDFPair(mode)
            p.reg(.ckgcr, 0x7FFFFFFF); p.reg(.sitfcr, 0x7FFFFFFF); p.reg(.bsmxcr, .max)
            p.set(1,0,options % 128 + 1); p.set(1,1,options & 1); p.set(1,2,((options % 3) + 1) << 5)
            p.set(1,3,options % 16 + 1); p.set(1,4,(options >> 1) & 1); p.set(1,5,((options >> 2) & 1) << 13)
            p.set(1,6,((options >> 3) & 1) << 8); p.set(1,7,(options >> 4) & 1); p.set(1,8,((options >> 5) & 3) << 4)
            p.set(1,9,((options >> 7) & 1) << 1); p.set(1,10,4 + options % 28); p.set(1,11,(options >> 8) & 1)
            p.set(1,12,options & 1); p.set(1,13,0x8000); p.set(5,8,(options >> 8) & 1)
            for i: UInt32 in 1...7 { p.callback(i,options % 3) }
            XCTAssertEqual(p.run(0),0); XCTAssertEqual(p.run(0),1); p.run(27); XCTAssertEqual(p.run(0),1); XCTAssertEqual(p.run(1),0)
        } }
        for owner: UInt32 in 0...2 { for active: UInt32 in 0..<4 {
            let p = MDFPair(1); p.set(8,0,owner); p.reg(.ckgcr,(active & 1) << 31); p.reg(.sitfcr,((active >> 1) & 1) << 31); p.set(1,7,1)
            p.run(0); p.reg(.sadcr,.max); p.reg(.dfltcr,.max); p.reg(.sitfcr,.max); p.run(1)
        } }
    }
    func testCallbackRegistrationIncludesSeparateSoundSignatureAndInvalidIDs() {
        for state: UInt32 in [0,1,2,255] { for id: UInt32 in 0...9 { for token: UInt32 in 0...2 {
            let p = MDFPair(1); p.set(1,12,state); p.set(1,13,0x4000)
            p.run(2,id,token); p.run(3,id); p.run(4,token); p.run(5)
        } } }
    }
    func testFilterConfigurationPollingInterruptAndDMA() {
        for op: UInt32 in [6,10,12] { for n: UInt32 in 0..<2048 {
            let p = MDFPair(n & 1)
            p.reg(.dfltcr,0x7FFFFFFF); p.reg(.dfltier,0x80000000); p.reg(.sadcr,0x7FFFFFFF)
            p.set(2,0,[UInt32(0),2,3][Int(n % 3)]); p.set(2,1,n % 128); p.set(2,2,0x40 | ((n & 1) << 4)); p.set(2,3,2 + n % 511)
            p.set(2,4,UInt32(bitPattern: Int32(n % 41) - 16)); p.set(2,5,(n >> 1) & 1); p.set(2,6,((n >> 2) & 1) << 4)
            p.set(2,7,(n >> 3) & 1); p.set(2,8,((n >> 4) & 3) << 8); p.set(2,9,(n >> 6) & 1)
            let sadMode = [UInt32(0),0x1000,0x3000][Int(n % 3)]
            p.set(2,10,sadMode); p.set(2,11,[UInt32(0),0x100,0x200,0x300,0x400,0x500,0x700][Int(n % 7)])
            p.set(2,12,sadMode == 0x3000 ? .max : (n >> 7) & 1); p.set(2,13,((n >> 8) & 1) << 3); p.set(2,14,[UInt32(0),2,6][Int(n % 3)])
            p.set(2,15,n * 4); p.set(2,16,(n & 7) << 12); p.set(2,17,[UInt32(0),0x100,0x200,0x300,0x700][Int(n % 5)])
            p.set(2,18,sadMode == 0x1000 ? .max : n & 7); p.set(2,19,n % 10); p.set(2,20,(n >> 9) & 1)
            p.set(2,21,(n % 5) << 4); p.set(2,22,((n >> 10) & 1) << 2); p.set(2,23,n % 256)
            p.set(2,24,(n & 1) << 13); p.set(2,25,((n >> 1) & 1) << 8); p.set(3,2,n & 1)
            p.set(4,0,[UInt32(0),0x80,0x81][Int(n % 3)]); p.run(op)
        } }
    }
    func testStartFailuresAndDMAAbortPreservePartialState() {
        for op: UInt32 in [6,10,12] { for state: UInt32 in [0,1,2,255] { for active: UInt32 in 0..<4 { for present: UInt32 in 0..<4 {
            let p = MDFPair(); p.set(1,12,state); p.reg(.dfltcr,(active & 1) << 31); p.reg(.sadcr,((active >> 1) & 1) << 31)
            p.set(5,0,present & 1); p.set(5,1,(present >> 1) & 1); p.run(op)
        } } } }
        for dmaMode: UInt32 in [0,0x80,0x81] { for status: UInt32 in 0...3 { for queue: UInt32 in 0...1 {
            let p = MDFPair(1); p.set(4,0,dmaMode); p.set(4,1,queue); p.set(5,5,status); p.set(2,9,1); p.set(2,5,1); p.set(2,20,1)
            p.run(12); p.reg(.sadcr,.max); p.reg(.dfltcr,.max); p.set(5,6,status); p.run(13)
        } } }
        for op: UInt32 in [9,11,13] { for state: UInt32 in [0,1,2,255] { for active: UInt32 in 0..<4 { for status: UInt32 in 0...3 {
            let p = MDFPair(); p.set(1,12,state); p.reg(.dfltcr,0x7FFFFFFF | ((active & 1) << 31)); p.reg(.sadcr,0x7FFFFFFF | (((active >> 1) & 1) << 31))
            p.reg(.dfltier,.max); p.reg(.dfltisr,0x400); p.set(5,6,status); p.run(op)
        } } } }
    }
    func testPollingTimeoutWrapErrorCallbacksAndDelayedFlags() {
        for op: UInt32 in [7,19,20,21] { for flags: UInt32 in [0,1,8,0x400,0xA02,0xA0A,0x1000,0x2000,0x3E0B] {
            for timeout: UInt32 in [0,1,3] { for mutation: UInt32 in 0...1 {
                let p = MDFPair(mutation); p.set(1,12,2); p.reg(.sadcr,.max); p.reg(.sitfcr,0x80000011); p.reg(.dfltcr,0x11)
                p.reg(.sadsdlvr,0x12345678); p.reg(.sadanlvr,0x87654321); p.reg(.dfltisr,flags); p.set(9,0,.max - 2); p.set(5,7,mutation)
                for id: UInt32 in 1...7 { p.callback(id,2) }
                p.run(op,timeout,3)
            } }
        } }
        for op: UInt32 in [7,19,20,21] {
            let p = MDFPair(); p.set(1,12,2); p.reg(.sadcr,.max); p.reg(.sitfcr,0x80000011); p.set(5,3,2); p.set(5,4,0x3E0B); p.run(op,3,3)
            p.reg(.dfltisr,0x3E0B); p.run(op,.max,3)
        }
        for state: UInt32 in [0,1,2,255] { for pointers: UInt32 in 0..<4 {
            let p = MDFPair(); p.set(1,12,state); p.reg(.dfltisr,.max); p.run(19,0,pointers); p.run(20,0); p.run(7,0)
            for sitf: UInt32 in [0,0x10,0x80000000,0x80000010,0x80000020,0x80000030] { p.reg(.sitfcr,sitf); p.run(21,0); p.run(22); p.run(23) }
        } }
    }
    func testIRQHandlesOnePriorityAndCallbackMutationBeforeModeRead() {
        let bits: [UInt32] = [2,1,0x800,0x400,0x200,0x1000,0x2000]
        for mode: UInt32 in 0...1 { for flags: UInt32 in 0..<128 { for enabled: UInt32 in 0..<128 {
            let p = MDFPair(mode)
            let mask = { (v: UInt32) in bits.enumerated().reduce(UInt32(0)) { $0 | ((v >> $1.offset) & 1 == 0 ? 0 : $1.element) } }
            p.reg(.dfltisr,mask(flags) | 8); p.reg(.dfltier,mask(enabled)); p.reg(.dfltcr,0x11); p.set(1,12,2); p.set(1,13,0x8000)
            p.reg(.sadsdlvr,0x12345678); p.reg(.sadanlvr,0xABCDEF00); p.set(5,7,flags & 1)
            for id: UInt32 in 1...7 { p.callback(id,2) }; p.run(24)
        } } }
    }
    func testGainDelayDataAndSoftwareTrigger() {
        for state: UInt32 in [0,1,2,255] {
            let p = MDFPair(); p.set(1,12,state)
            for gain: Int32 in -16...24 { p.reg(.dfltcicr,.max); p.run(17,UInt32(bitPattern: gain)); p.run(18,1) }
            for raw: UInt32 in 0..<64 { p.reg(.dfltcicr,raw << 20); p.run(18,1) }
            p.run(18,0)
            for delay: UInt32 in 0..<128 { p.reg(.dlycr,0x55); p.run(15,delay); p.run(16,1); p.reg(.dlycr,.max); p.run(15,delay) }
            p.run(16,0)
            for raw: UInt32 in [0,1,0x7FFFFFFF,0x80000000,.max] { p.reg(.dfltdr,raw); p.run(8,0); p.run(8,1); p.reg(.gcr,raw); p.run(14) }
            p.run(25); p.run(26)
        }
    }
    func testDMAEventsAndResetMacroBothCallbackModes() {
        for mode: UInt32 in 0...1 { for dmaMode: UInt32 in [0,0x80,0x81,0x181] { for op: UInt32 in [27,28,29,30] { for mutation: UInt32 in 0...1 {
            let p = MDFPair(mode); p.set(1,12,2); p.set(1,13,0x8000); p.set(4,0,dmaMode); p.set(8,0,1); p.reg(.dfltcr,.max); p.set(5,7,mutation)
            for id: UInt32 in 1...7 { p.callback(id,2) }; p.run(op)
        } } } }
    }
}
