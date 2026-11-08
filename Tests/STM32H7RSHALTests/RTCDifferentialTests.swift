import XCTest
import CRTCReference
import STM32H7RSHAL

final class RTCPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CRTC_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CRTC_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    init(_ mode: UInt32 = 0) { CRTC_Reset(actual, mode); CRTC_Reset(expected, mode) }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CRTC_Set(actual, area, index, value); CRTC_Set(expected, area, index, value) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CRTC_Get(actual, area, index) }
    func reg(_ register: RTCRegister, _ value: UInt32) { set(0, register.rawValue / 4, value) }
    func tamp(_ register: RTCTamperRegister, _ value: UInt32) { set(1, register.rawValue / 4, value) }
    func callback(_ id: UInt32, _ token: UInt32) { CRTC_SetCallback(actual,id,token); CRTC_SetCallback(expected,id,token) }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(13,0,0)
        let wanted = CRTC_Run(expected, op, a, b, c), result = RTCModel(state: actual).run(op,a,b,c)
        let label = "mode \(get(14,0)) op \(op) args \([a,b,c])"
        XCTAssertEqual(result, wanted, label, file: file, line: line)
        let counts: [UInt32] = [32,96,12,8,4,15,9,48,3,7,8,2,1,1,1,32]
        for area: UInt32 in 0..<16 {
            XCTAssertEqual((0..<counts[Int(area)]).map { CRTC_Get(actual,area,$0) }, (0..<counts[Int(area)]).map { CRTC_Get(expected,area,$0) }, "\(label) area \(area)", file: file, line: line)
        }
        XCTAssertEqual((0..<26).map { CRTC_GetCallback(actual,$0) }, (0..<26).map { CRTC_GetCallback(expected,$0) }, label, file: file, line: line)
        for event in 0..<min(get(13,0),CRTC_Get(expected,13,0)) {
            XCTAssertEqual((0..<192).map { CRTC_TraceWord(actual,event,$0) }, (0..<192).map { CRTC_TraceWord(expected,event,$0) }, "\(label) callback \(event)", file: file, line: line)
        }
        return result
    }
}

final class RTCDifferentialTests: XCTestCase {
    func testEveryBCDByteIncludingOverflowAndNonDecimalNibbles() {
        let p = RTCPair()
        for value: UInt32 in 0...255 { p.run(23,value); p.run(24,value) }
    }
    func testInitializationOptionsSkipsAndMSPCallbackMutation() {
        for mode: UInt32 in 0...1 { for variant: UInt32 in 0..<160 {
            let p = RTCPair(mode)
            p.set(2,11,variant & 1); p.set(2,10,1)
            p.set(2,0,(variant & 1) << 6); p.set(2,1,variant % 128); p.set(2,2,variant * 199 % 32768)
            p.set(2,3,[0,0x200000,0x400000,0x600000,0x4000000][Int(variant % 5)])
            for (i,shift): (UInt32,UInt32) in [(4,31),(5,20),(6,30),(7,29)] { p.set(2,i,((variant >> (i-3)) & 1) << shift) }
            p.set(2,8,(variant % 3) << 8); p.set(2,9,(variant % 8) << 10)
            p.reg(.cr,0x5A5A5A5A); p.reg(.icsr,variant % 4 == 0 ? 0x10 : variant % 4 == 1 ? 0x100 : 0)
            p.set(10,6,variant % 8 == 0 ? 3 : 0)
            for id: UInt32 in 0..<26 { p.callback(id,variant % 3) }
            XCTAssertEqual(p.run(0),0)
            p.run(20)
        } }
    }
    func testDeinitializationTimeoutCleanupAndLegacyInstance() {
        for mode: UInt32 in 0...1 { for flags: UInt32 in [0,0x40,0x60,0x64] { for split: UInt32 in 0...1 {
            let p = RTCPair(mode)
            p.set(10,1,flags); p.set(10,7,split); p.reg(.icsr,flags); p.set(2,10,1)
            p.reg(.cr,.max); p.reg(.calr,.max); p.tamp(.atcr1,.max)
            p.callback(25,0); p.run(1)
        } } }
        let p = RTCPair(1); p.set(10,7,1); p.run(1)
        XCTAssertEqual(p.get(2,11),0)
        let timeout = RTCPair(); timeout.set(10,1,0); XCTAssertEqual(timeout.run(1),3)
        XCTAssertEqual(timeout.get(0,0x24/4),0x53)
        let wakeTimeout = RTCPair(); wakeTimeout.set(10,1,0x60); wakeTimeout.reg(.icsr,0x40)
        XCTAssertEqual(wakeTimeout.run(1),3); XCTAssertEqual(wakeTimeout.get(2,11),0)
    }
    func testCalendarBinaryBCDAndInputMutation() {
        for format: UInt32 in 0...1 { for hourFormat: UInt32 in [0,0x40] { for value: UInt32 in 0..<100 {
            let p = RTCPair()
            p.reg(.cr,hourFormat); p.reg(.icsr,0x40)
            let hour: UInt8 = UInt8(hourFormat == 0 ? value % 24 : value % 12 + 1)
            for (i,v): (UInt32,UInt8) in [(0,hour),(1,UInt8(value%60)),(2,UInt8((value*7)%60))] {
                p.set(3,i,UInt32(format == 0 ? v : RTCEncoding.byteToBCD(v)))
            }
            p.set(3,3,1); p.set(3,4,.max); p.set(3,6,0x10000); p.set(3,7,0x40000)
            p.run(4,format); p.run(5,format)
            for (i,v): (UInt32,UInt8) in [(1,UInt8(value%12+1)),(2,UInt8(value%31+1)),(3,UInt8(value))] {
                p.set(4,i,UInt32(format == 0 ? v : RTCEncoding.byteToBCD(v)))
            }
            p.set(4,0,value%7+1); p.run(6,format); p.run(7,format)
        } } }
        for month: UInt32 in [0x10,0x11,0x12] {
            let p = RTCPair(); p.reg(.icsr,0x40); p.set(4,1,month); p.run(6)
            XCTAssertEqual(p.get(4,1),month-6)
        }
        let binary = RTCPair(); binary.reg(.icsr,0x100); binary.reg(.ssr,.max)
        binary.set(3,0,255); binary.set(3,5,123); binary.run(5,99); binary.run(4,99)
        XCTAssertEqual(binary.get(3,0),255); XCTAssertEqual(binary.get(3,5),123)
    }
    func testCalendarSynchronizationFailuresAndLockedCalls() {
        for op: UInt32 in [4,6,13,14,15,25,26,27,28,29,33,34,35,39,40,41,42,43,44,45,46,47,50,51] {
            let p = RTCPair(); p.set(2,10,1)
            XCTAssertEqual(p.run(op,op == 15 ? 0x100 : 0),2)
        }
        for op: UInt32 in [4,6,19,21,22,44,45] { for flags: UInt32 in [0,0x40] { for bypass: UInt32 in [0,0x20] {
            let p = RTCPair(); p.set(10,1,flags); p.reg(.cr,bypass); p.reg(.icsr,flags)
            XCTAssertEqual(p.run(op),op == 21 && flags == 0x40 ? 0 : 3)
        } } }
    }
    func testAlarmModesMasksAndPartialGetFields() {
        for mode: UInt32 in [0,0x100,0x200] { for format: UInt32 in 0...1 { for value: UInt32 in 0..<64 {
            let p = RTCPair()
            p.reg(.icsr,mode); p.reg(.cr,value & 1 == 0 ? 0 : 0x40)
            p.set(5,0,format == 0 ? 12 : 0x12); p.set(5,1,format == 0 ? 35 : 0x35)
            p.set(5,2,format == 0 ? 58 : 0x58); p.set(5,3,1); p.set(5,4,value * 73)
            p.set(5,5,0xDEADBEEF); p.set(5,6,0x10000); p.set(5,7,0x40000)
            p.set(5,8,((value & 1) << 7) | ((value & 2) << 14) | ((value & 4) << 21) | ((value & 8) << 28))
            p.set(5,9,(value % (mode == 0x100 ? 32 : 16)) << 24); p.set(5,10,(value & 1) << 31)
            p.set(5,11,(value & 1) << 30); p.set(5,12,7); p.set(5,13,(value >> 1)&1)
            let selection: UInt32 = value & 1 == 0 ? 0x100 : 0x200
            p.set(5,14,selection); p.run(value & 2 == 0 ? 13 : 14,format)
            p.run(16,selection,format); p.run(15,selection)
        } } }
    }
    func testIRQSnapshotsAcknowledgementOrderAndLiveCallbacks() {
        for mode: UInt32 in 0...1 { for flags: UInt32 in 0..<64 { for mutation: UInt32 in 0...1 {
            for op: UInt32 in [17,31,37,52] {
                let p = RTCPair(mode); p.reg(.misr,flags); p.reg(.scr,0xDEADBEEF); p.set(10,6,mutation); p.set(2,11,2)
                p.run(op)
            }
        } } }
        for mode: UInt32 in 0...1 { for flags: UInt32 in [0,1,128,255,0x45FF0000,.max] { for mutation: UInt32 in 0...1 {
            let p = RTCPair(mode); p.tamp(.misr,flags); p.tamp(.scr,0xDEADBEEF); p.set(10,6,mutation); p.set(2,11,2)
            p.run(66)
        } } }
    }
    func testCallbackRegistrationStatesAndReset() {
        for state: UInt32 in [0,1,2,3,4,255] { for id: UInt32 in 0...27 { for token: UInt32 in 0...2 {
            let p = RTCPair(1); p.set(2,11,state); p.set(2,10,1)
            p.run(2,id,token); p.run(3,id)
        } } }
        for mode: UInt32 in 0...1 { let p = RTCPair(mode); p.run(75) }
    }
    func testTimestampRetrievalLeavesUnrelatedFieldsAndHandlesOverflow() {
        for format: UInt32 in 0...1 { for status: UInt32 in 0..<64 {
            let p = RTCPair(); p.reg(.tstr,0x452359); p.reg(.tsdr,0xE531); p.reg(.tsssr,.max); p.reg(.sr,status)
            p.set(3,5,0x12345678); p.set(3,6,0x10000); p.set(3,7,0x40000); p.set(4,3,99)
            p.run(30,format)
        } }
        for op: UInt32 in [25,26,27,28,29] { let p = RTCPair(); p.reg(.cr,.max); p.run(op,op==25 || op==26 ? 8 : 0) }
    }
    func testWakeupClockCounterAutoClearAndTimeout() {
        for clock: UInt32 in [0,1,2,3,4,6] { for count: UInt32 in [0,1,255,65535] { for flags: UInt32 in [0,4,0x40] {
            let p = RTCPair(); p.reg(.cr,.max); p.reg(.icsr,flags); p.set(10,1,flags)
            p.run(33,count,clock); p.run(34,count,clock,count); p.run(36); p.run(35)
        } } }
    }
    func testPollingFiniteInfiniteWrapAndLastFlagCheck() {
        for (op,mask): (UInt32,UInt32) in [(18,1),(32,8),(38,4),(53,2)] {
            for timeout: UInt32 in [0,1,1000,.max] { for ready in [false,true] {
                let p = RTCPair(); p.set(11,0,.max-500); p.reg(.sr,ready ? mask : 0)
                if timeout == .max { p.reg(.sr,mask) }
                p.run(op,timeout)
                let delayed = RTCPair(); delayed.set(10,2,2); delayed.set(10,3,0); delayed.set(10,4,0x50/4); delayed.set(10,5,mask)
                if timeout != .max { XCTAssertEqual(delayed.run(op,timeout),0) }
            } }
        }
        for (op,mask): (UInt32,UInt32) in [(61,3),(65,0x30000)] {
            for flags in [UInt32(0),mask &- 1,mask] {
                let p = RTCPair(); p.tamp(.sr,flags); p.run(op,mask,0)
            }
        }
    }
    func testCalibrationShiftReferenceClockAndDST() {
        for period: UInt32 in [0,0x2000,0x4000] { for plus: UInt32 in [0,0x8000] { for minus: UInt32 in [0,1,511] {
            let p = RTCPair(); p.reg(.calr,.max); p.run(39,period,plus,minus)
        } } }
        for pending: UInt32 in [0,8,0x10000] { for cr: UInt32 in [0,0x10,0x20,0x30] {
            let p = RTCPair(); p.reg(.icsr,pending); p.reg(.cr,cr); p.reg(.shiftr,.max)
            p.run(39); p.run(41,0,32767); p.run(41,0x80000000,0)
        } }
        for op: UInt32 in [8,9,10,11,12,40,42,43,44,45,46,47,50,51] {
            let p = RTCPair(); p.reg(.cr,0x5A5A5A5A); p.reg(.calr,.max); p.run(op)
        }
    }
}
