import XCTest
import CPSSIReference
import STM32H7RSHAL

final class PSSIPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CPSSI_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CPSSI_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    init(_ mode: UInt32 = 0, _ dma: UInt32 = 1) { CPSSI_Reset(actual, mode, dma); CPSSI_Reset(expected, mode, dma); set(1, 9, 1) }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CPSSI_Set(actual, area, index, value); CPSSI_Set(expected, area, index, value) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CPSSI_Get(actual, area, index) }
    func callback(_ id: UInt32, _ token: UInt32) { CPSSI_SetCallback(actual, id, token); CPSSI_SetCallback(expected, id, token) }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(7, 0, 0)
        let wanted = CPSSI_Run(expected, op, a, b, c)
        let result = PSSIModel(state: actual).run(op, a, b, c)
        let label = "mode \(get(9, 0)), dma \(get(9, 1)), op \(op), args \([a,b,c])"
        XCTAssertEqual(result, wanted, label, file: file, line: line)
        for (area, count): (UInt32, UInt32) in [(0,11),(1,11),(2,30),(3,12),(4,256),(5,8),(6,2),(8,1)] {
            for i in 0..<count { XCTAssertEqual(CPSSI_Get(actual, area, i), CPSSI_Get(expected, area, i), "\(label), area \(area)/\(i)", file: file, line: line) }
        }
        for id: UInt32 in 0..<7 { XCTAssertEqual(CPSSI_GetCallback(actual, id), CPSSI_GetCallback(expected, id), label, file: file, line: line) }
        let events = CPSSI_TraceCount(actual), expectedEvents = CPSSI_TraceCount(expected)
        XCTAssertEqual(events, expectedEvents, label, file: file, line: line)
        for event in 0..<min(events, expectedEvents) { for word: UInt32 in 0..<128 {
            XCTAssertEqual(CPSSI_TraceWord(actual, event, word), CPSSI_TraceWord(expected, event, word), "\(label), event \(event)/\(word)", file: file, line: line)
        } }
        return result
    }
}
final class PSSIDifferentialTests: XCTestCase {
    func testInitializationAllOptionsMSPMutationsAndDeferredWidthValidation() {
        for mode: UInt32 in 0...1 { for options: UInt32 in 0..<128 { for state: UInt32 in [0,1,2,7] {
            let p = PSSIPair(mode); p.set(0,0,.max); p.set(1,0,.max)
            p.set(1,1,(options & 1) * 0xC00); p.set(1,2,((options >> 1) & 7) << 18)
            p.set(1,3,(options >> 4) & 1); p.set(1,4,((options >> 5) & 1) << 6); p.set(1,5,((options >> 6) & 1) << 8)
            p.set(1,9,state); p.set(1,8,1); p.callback(5,options % 3); p.callback(6,options % 3); p.set(3,5,options & 1)
            XCTAssertEqual(p.run(0),0); XCTAssertEqual(p.run(1),0)
        } } }
    }
    func testPollingWidthsBusConstraintsStatesAndDirectionSpecificErrors() {
        for dma: UInt32 in 0...1 { for width: UInt32 in 0...3 { for bus: UInt32 in [0,0xC00] {
            for size: UInt32 in [0,1,2,3,4,8,12] { for rx: UInt32 in 0...1 { for flags: UInt32 in [0,2] {
                let p = PSSIPair(size & 1,dma); p.set(1,0,width); p.set(1,1,bus); p.set(1,3,size & 1)
                p.set(0,0,.max); p.set(0,1,12); p.set(0,2,flags); p.set(0,10,0xFEDCBA98); p.set(3,9,0x87654300)
                _ = p.run(2 + rx,size == 0 ? 0 : 1,size,5)
            } } }
        } } }
        for state: UInt32 in [0,1,2,3,4,7] { for lock: UInt32 in [0,1,2] {
            let p = PSSIPair(); p.set(1,9,state); p.set(1,8,lock); p.set(0,1,12); _ = p.run(2,1,4,1); _ = p.run(3,1,4,1)
        } }
        let p = PSSIPair(); p.set(0,1,12); p.set(0,2,2); XCTAssertEqual(p.run(3,1,1,0),1); XCTAssertEqual(p.get(1,9),2)
    }
    func testPollingTimeoutTickWrapPerElementAndLateReady() {
        for op: UInt32 in [2,3] { for timeout: UInt32 in [0,1,3,.max] { for ready: UInt32 in [1,2,4,8] {
            if timeout == .max && ready != 1 { continue }
            let p = PSSIPair(); p.set(6,0,.max - 2); p.set(3,2,ready); p.set(3,3,12)
            _ = p.run(op,1,4,timeout)
        } } }
    }
    func testDMAStartModesWidthsQueuesSizesAndFailureCleanup() {
        for mode: UInt32 in 0...1 { for op: UInt32 in [4,5] { for size: UInt32 in [0,1,65535,65536,65537,.max] {
            for setup: UInt32 in 0..<16 {
                let dir = op - 4, p = PSSIPair(mode)
                p.set(0,0,.max); p.set(1,1,0xC00); p.set(1,3,setup & 1)
                p.set(2,dir*15,setup & 1); p.set(2,dir*15+1,setup & 2 == 0 ? 0 : 0x80)
                p.set(2,dir*15+2,setup & 4 == 0 ? 0 : 2); p.set(2,dir*15+3,setup & 8 == 0 ? 0 : 1)
                p.set(2,dir*15+12,0)
                _ = p.run(op,5,size)
            }
        } } }
        for op: UInt32 in [4,5] { for linked: UInt32 in [0,0x80] { for status: UInt32 in 0...3 {
            let p = PSSIPair(), dir = op - 4
            p.set(2,dir*15+1,linked); p.set(2,dir*15+12,status)
            XCTAssertEqual(p.run(op,1,16),status == 0 ? 0 : 1)
            if status == 0 { XCTAssertEqual(p.get(1,9),op - 1); XCTAssertEqual(p.get(1,6),0) }
        } } }
        for op: UInt32 in [4,5] { for state: UInt32 in [0,1,2,3,4,7] { for lock: UInt32 in [0,1,2] {
            let p = PSSIPair(); p.set(0,0,.max); p.set(1,9,state); p.set(1,8,lock); _ = p.run(op,0,4)
        } } }
    }
    func testAbortIRQAndDMAEventsWithSynchronousCallbacksAndMutation() {
        for mode: UInt32 in 0...1 { for op: UInt32 in [6,7,10,11,12,13] { for state: UInt32 in 0...7 {
            for flags: UInt32 in 0..<16 {
                let p = PSSIPair(mode); p.set(1,9,state); p.set(1,8,flags & 1)
                p.set(1,10,flags & 2 == 0 ? 0 : 0x8000); p.set(0,0,flags & 4 == 0 ? 0 : 0x40004000)
                p.set(0,2,flags & 8 == 0 ? 0 : 2); p.set(0,3,.max); p.set(0,4,0)
                p.set(2,13,flags & 1); p.set(2,28,flags & 1); p.set(2,14,(flags >> 1) & 1); p.set(2,29,(flags >> 1) & 1)
                p.set(3,4,(flags >> 3) & 1); _ = p.run(op)
            }
        } } }
        for state: UInt32 in 0...7 {
            let p = PSSIPair(0,0); p.set(1,9,state); p.set(0,0,.max); p.set(0,2,2); p.set(0,3,.max); _ = p.run(7)
        }
        let p = PSSIPair(); p.set(1,9,3); p.set(0,0,0x40004000); XCTAssertEqual(p.run(6),0)
        XCTAssertEqual(p.get(1,9),7); XCTAssertEqual(p.get(5,6),0)
    }
    func testCallbackRegistrationSparseIDsNoLockAndControlMacros() {
        for state: UInt32 in 0...7 { for lock: UInt32 in [0,1,2] { for id: UInt32 in 0...8 { for token: UInt32 in 0...2 {
            let p = PSSIPair(1); p.set(1,9,state); p.set(1,8,lock); _ = p.run(15,id,token); _ = p.run(16,id)
        } } } }
        for mode: UInt32 in 0...1 { for seed: UInt32 in [0,.max,0xA5A5A5A5] {
            let p = PSSIPair(mode); for i: UInt32 in 0..<11 { p.set(0,i,seed) }
            for op: UInt32 in [8,9,17,18,19,20,21,22,23,24,25] { _ = p.run(op,seed) }
            for state: UInt32 in [0,1,3] { for lock: UInt32 in [0,1] { for source: UInt32 in [0,0x20000000] {
                p.set(1,9,state); p.set(1,8,lock); _ = p.run(14,source)
            } } }
        } }
    }
}
