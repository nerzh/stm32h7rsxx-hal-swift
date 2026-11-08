import XCTest
import CSPDIFRXReference
import STM32H7RSHAL

final class SPDIFRXPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CSPDIFRX_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CSPDIFRX_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    init(_ mode: UInt32 = 0) { CSPDIFRX_Reset(actual, mode); CSPDIFRX_Reset(expected, mode); set(1, 17, 1) }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CSPDIFRX_Set(actual, area, index, value); CSPDIFRX_Set(expected, area, index, value) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CSPDIFRX_Get(actual, area, index) }
    func callback(_ id: UInt32, _ token: UInt32) { CSPDIFRX_SetCallback(actual, id, token); CSPDIFRX_SetCallback(expected, id, token) }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(7, 0, 0)
        let wanted = CSPDIFRX_Run(expected, op, a, b, c), result = SPDIFRXModel(state: actual).run(op, a, b, c)
        let label = "mode \(get(9, 0)), op \(op), args \([a,b,c])"
        XCTAssertEqual(result, wanted, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0,7),(1,19),(2,26),(3,12),(4,128),(5,8),(6,2),(8,2),(10,6),(11,1)] {
            XCTAssertEqual((0..<count).map { CSPDIFRX_Get(actual, area, $0) }, (0..<count).map { CSPDIFRX_Get(expected, area, $0) }, "\(label), area \(area)", file: file, line: line)
        }
        for i: UInt32 in 0..<7 { XCTAssertEqual(CSPDIFRX_GetCallback(actual, i), CSPDIFRX_GetCallback(expected, i), label, file: file, line: line) }
        let events = get(7, 0), expectedEvents = CSPDIFRX_Get(expected, 7, 0)
        XCTAssertEqual(events, expectedEvents, label, file: file, line: line)
        for e in 0..<min(events, expectedEvents) {
            XCTAssertEqual((0..<224).map { CSPDIFRX_TraceWord(actual, e, $0) }, (0..<224).map { CSPDIFRX_TraceWord(expected, e, $0) }, "\(label), event \(e)", file: file, line: line)
        }
        return result
    }
}
final class SPDIFRXDifferentialTests: XCTestCase {
    func testInitializationOptionsMSPMutationAndDeinitialization() {
        for mode: UInt32 in 0...1 { for options: UInt32 in 0..<2048 {
            let p = SPDIFRXPair(mode)
            p.set(0,0,.max); p.set(0,1,.max); p.set(1,17,options & 1); p.set(1,16,1); p.set(1,18,0x8000)
            p.set(1,0,(options & 3)<<16); p.set(1,1,((options>>2)&3)<<12); p.set(1,2,((options>>4)&1)<<14)
            p.set(1,3,((options>>5)&1)<<11); p.set(1,4,(options % 3)<<4); p.set(1,5,((options>>6)&1)<<3)
            p.set(1,6,((options>>7)&1)<<9); p.set(1,7,((options>>8)&1)<<8); p.set(1,8,((options>>9)&1)<<7); p.set(1,9,((options>>10)&1)<<6)
            p.set(1,10,(options>>3)&1); p.set(1,11,(options>>4)&1); p.callback(5,options % 3); p.callback(6,options % 3)
            p.set(3,5,(options>>10)&1); _ = p.run(0); _ = p.run(1)
        } }
    }
    func testFormatChangesWhileReceivingAndMaskOnlyChanges() {
        for current: UInt32 in 0..<4 { for oldFormat: UInt32 in [0,0x10,0x20] { for format: UInt32 in [0,0x10,0x20] {
            for options: UInt32 in 0..<64 {
                let p = SPDIFRXPair(); p.set(0,0,0xFF000404 | current | oldFormat | ((options & 1)<<3))
                p.set(10,0,format); p.set(10,1,((options>>1)&1)<<3); p.set(10,2,((options>>2)&1)<<9)
                p.set(10,3,((options>>3)&1)<<8); p.set(10,4,((options>>4)&1)<<7); p.set(10,5,((options>>5)&1)<<6)
                _ = p.run(2)
            }
        } } }
    }
    func testPollingBothStreamsTimeoutPerWordAndTickWrap() {
        for op: UInt32 in [3,4] { for count: UInt32 in [0,1,2,8] { for flags: UInt32 in [0,1,2,32,35] {
            for timeout: UInt32 in [0,1,3] {
                let p = SPDIFRXPair(); p.set(0,0,0x30000); p.set(0,1,.max); p.set(0,2,flags); p.set(6,0,.max - 2); p.set(3,6,0x12340000)
                _ = p.run(op,1,count,timeout)
            }
        } } }
        for op: UInt32 in [3,4] { for state: UInt32 in [0,1,2,3,4,7] { for lock: UInt32 in [0,1,2] {
            let p = SPDIFRXPair(); p.set(1,17,state); p.set(1,16,lock); p.set(0,2,35)
            _ = p.run(op,0,4,1); _ = p.run(op,1,4,.max)
        } } }
        let p = SPDIFRXPair(); p.set(3,2,2); p.set(3,3,35); _ = p.run(3,1,3,3)
    }
    func testInterruptStartValidatesStateFirstAndUsesGlobalCRAndDoWhileBudget() {
        for op: UInt32 in [5,6] { for state: UInt32 in [0,1,2,3,4,7] { for lock: UInt32 in [0,1,2] {
            for global: UInt32 in 0..<4 { for budget: UInt32 in [0,23999,24000] { for flags: UInt32 in [0,32] {
                let p = SPDIFRXPair(); p.set(1,17,state); p.set(1,16,lock); p.set(0,1,.max); p.set(0,2,flags)
                p.set(3,8,1); p.set(11,0,global); p.set(3,0,budget)
                _ = p.run(op,0,1); _ = p.run(op,1,0); _ = p.run(op,1,65535)
            } } }
        } } }
    }
    func testDMAStartsNormalLinkedFailureTimeoutAndControlBufferBeforeLock() {
        for mode: UInt32 in 0...1 { for op: UInt32 in [7,8] { for dmaMode: UInt32 in [0,0x80,0x81] {
            for status: UInt32 in 0...3 { for count: UInt32 in [0,1,16383,16384,65535] { for sync: UInt32 in [0,32] {
                let p = SPDIFRXPair(mode), base = (op - 7) * 13
                p.set(0,0,0x300000); p.set(0,1,.max); p.set(0,2,sync); p.set(2,base+1,dmaMode); p.set(2,base+11,status)
                _ = p.run(op,5,count)
            } } }
        } } }
        for op: UInt32 in [7,8] { for state: UInt32 in [0,1,2,3,4,7] { for lock: UInt32 in [0,1,2] {
            let p = SPDIFRXPair(); p.set(1,17,state); p.set(1,16,lock); p.set(0,0,3); _ = p.run(op,0,1); _ = p.run(op,5,2)
        } } }
        for op: UInt32 in [7,8] { let p = SPDIFRXPair(); let base = (op - 7)*13; p.set(2,base+1,0x80); p.set(2,base+2,0); XCTAssertEqual(p.run(op,1,4),1); XCTAssertEqual(p.get(1,16),0) }
    }
    func testIRQSnapshotsBothStreamsDefaultErrorsAndUInt16Underflow() {
        for mode: UInt32 in 0...1 { for flags: UInt32 in 0..<16 { for enabled: UInt32 in 0..<128 {
            for count: UInt32 in [0,1,2] {
                let p = SPDIFRXPair(mode); p.set(0,0,.max); p.set(0,1,enabled | 0xFFFF0000); p.set(0,2,flags | 0x1F0)
                p.set(0,4,0x12345678); p.set(0,5,0x87654321); p.set(1,13,count); p.set(1,15,count); p.set(1,17,4); p.set(1,16,1)
                for id: UInt32 in 0..<7 { p.callback(id,2) }
                p.set(3,4,flags & 1); _ = p.run(10)
            }
        } } }
    }
    func testDMAEventsAndStopKeepReferenceAsymmetries() {
        for mode: UInt32 in 0...1 { for op: UInt32 in 9...17 where op != 10 && op != 11 && op != 12 {
            for dmaMode: UInt32 in [0,0x80,0x81,0x181] { for stream: UInt32 in 0...1 { for mutation: UInt32 in 0...1 {
                let p = SPDIFRXPair(mode); p.set(0,0,.max); p.set(1,13,8); p.set(1,15,9); p.set(1,17,4); p.set(1,18,0x100)
                p.set(2,stream*13+1,dmaMode); p.set(3,4,mutation); _ = p.run(op,stream)
            } } }
        } }
        for presence: UInt32 in 0..<4 { let p = SPDIFRXPair(); p.set(2,0,presence & 1); p.set(2,13,(presence>>1)&1); _ = p.run(9) }
    }
    func testCallbackRegistrationAndControlMacros() {
        for op: UInt32 in [18,19] { for state: UInt32 in [0,1,2,3,4,7] { for lock: UInt32 in [0,1,2] {
            for id: UInt32 in 0...8 { for token: UInt32 in 0...2 {
                let p = SPDIFRXPair(1); p.set(1,17,state); p.set(1,16,lock); _ = p.run(op,id,token)
            } }
        } } }
        for mode: UInt32 in 0...1 { for op: UInt32 in 20...28 { for mask: UInt32 in [0,1,3,0x7F,.max] {
            let p = SPDIFRXPair(mode); p.set(0,0,.max); p.set(0,1,.max); p.set(0,2,mask); _ = p.run(op,mask)
        } } }
    }
}
