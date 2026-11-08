import XCTest
import CRTCReference
import STM32H7RSHAL

private final class RTCTrace: RTCRegisterIO {
    let model: RTCModel
    var events: [String] = []
    var icsr: [UInt32] = []
    init(_ state: OpaquePointer) { model = .init(state: state) }
    func read(_ r: RTCRegister) -> UInt32 {
        events.append("r:\(r)")
        if r == .icsr && !icsr.isEmpty { return icsr.removeFirst() }
        return model.read(r)
    }
    func write(_ r: RTCRegister, value: UInt32) { events.append("w:\(r):\(value)"); model.write(r,value:value) }
    func readTamper(_ r: RTCTamperRegister) -> UInt32 { events.append("tr:\(r)"); return model.readTamper(r) }
    func writeTamper(_ r: RTCTamperRegister, value: UInt32) { events.append("tw:\(r):\(value)"); model.writeTamper(r,value:value) }
    func readBackup(_ i: UInt32) -> UInt32 { model.readBackup(i) }
    func writeBackup(_ i: UInt32, value: UInt32) { model.writeBackup(i,value:value) }
    func readInstanceInitializationStatus() -> UInt32 { events.append("legacy:icsr"); return model.readInstanceInitializationStatus() }
    var driver: RTC<RTCTrace, RTCModel, RTCModel> { .init(registers:self,handle:model,callbacks:model,defaults:model.defaults) }
}
final class RTCAccessTests: XCTestCase {
    func testEnterInitializationStillReadsFlagAfterTimeoutStatus() {
        let p = RTCPair()
        let trace = RTCTrace(p.actual)
        var tick: UInt32 = 0
        XCTAssertEqual(trace.driver.enterInitialization { defer { tick &+= 1001 }; return tick },.timeout)
        XCTAssertEqual(trace.events, ["r:icsr","r:icsr","w:icsr:128","r:icsr","r:icsr","r:icsr"])
    }
    func testSynchronizationAcceptsFlagOnTimeoutRecheck() {
        let p = RTCPair(), trace: RTCTrace
        trace = RTCTrace(p.actual); trace.icsr = [0,0,0x20]
        var tick: UInt32 = 0
        XCTAssertEqual(trace.driver.waitForSynchronization { defer { tick &+= 1001 }; return tick },.ok)
        XCTAssertEqual(trace.events,["r:icsr","w:icsr:0","r:icsr","r:icsr"])
    }
    func testDeinitPollsLegacyInstanceThenRechecksGlobalRTC() {
        let p = RTCPair(); p.set(10,7,1); p.set(10,1,0x60); p.reg(.icsr,0x40)
        let trace = RTCTrace(p.actual)
        XCTAssertEqual(trace.driver.deinitialize { CRTC_TickFor(p.actual) },.timeout)
        let first = trace.events.firstIndex(of:"legacy:icsr")!
        XCTAssertEqual(Array(trace.events[first..<(first+3)]),["legacy:icsr","r:icsr","legacy:icsr"])
        XCTAssertEqual(p.get(2,11),0)
    }
    func testAlarmWritesBinarySubsecondsWithoutWriteProtectionSequence() {
        let p = RTCPair(), trace: RTCTrace
        trace = RTCTrace(p.actual)
        var alarm = RTCAlarm(time:.init(subseconds:123),subsecondMask:0x0F000000,dateWeekday:1)
        XCTAssertEqual(trace.driver.setAlarm(&alarm,format:0),.ok)
        XCTAssertEqual(trace.events.filter { $0.hasPrefix("w:") }.map { String($0.split(separator:":")[1]) },["cr","scr","alrmar","alrmassr","alrabinr","cr","cr"])
    }
    func testActiveSeedsAreFourWritesBeforeReadback() {
        let p = RTCPair(), trace: RTCTrace
        trace = RTCTrace(p.actual)
        let config = RTCActiveTampersConfiguration(seed:[1,2,3,4])
        XCTAssertEqual(trace.driver.setActiveTampers(config,getTick:{0}),.ok)
        XCTAssertEqual(Array(trace.events.suffix(5)),["tw:atseedr:1","tw:atseedr:2","tw:atseedr:3","tw:atseedr:4","tr:ator"])
    }
}
