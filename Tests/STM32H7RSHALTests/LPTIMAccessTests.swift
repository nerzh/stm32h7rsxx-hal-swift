import XCTest
import STM32H7RSHAL

private final class LPTIMAccessIO: LPTIMRegisterIO {
    let instance: LPTIMInstance
    var values: [LPTIMRegister: UInt32] = [.isr: .max]
    var events: [String] = []
    var reads: [LPTIMRegister: [UInt32]] = [:]
    init(_ instance: LPTIMInstance = .lptim1) { self.instance = instance }
    func read(_ register: LPTIMRegister) -> UInt32 {
        events.append("r:\(register)")
        if let queued = reads[register], !queued.isEmpty {
            let value = queued[0]; reads[register]!.removeFirst(); return value
        }
        return values[register, default: 0]
    }
    func write(_ register: LPTIMRegister, value: UInt32) { events.append("w:\(register)"); values[register] = value }
    func address(of register: LPTIMRegister) -> UInt32 { instance.baseAddress + register.rawValue }
    func readWakeupInterruptMask() -> UInt32 { events.append("r:exti"); return 0 }
    func writeWakeupInterruptMask(_ value: UInt32) { events.append("w:exti") }
}
private final class LPTIMCallbackRecorder: LPTIMCallbackIO {
    let base: LPTIMReferenceIO
    var writes: [UInt32] = []
    init(_ base: LPTIMReferenceIO) { self.base = base }
    var context: UnsafeMutableRawPointer? { base.context }
    func read(_ id: LPTIMCallbackID) -> LPTIMCallback? { base.read(id) }
    func write(_ id: LPTIMCallbackID, value: LPTIMCallback?) { writes.append(id.rawValue); base.write(id, value: value) }
}
final class LPTIMAccessTests: XCTestCase {
    func testInitializeResetsErrorCallbackLastAsInC() {
        let p = LPTIMPair(1), callbacks = LPTIMCallbackRecorder(p.io)
        p.set(1, 16, 0); p.callback(0, 0)
        let d = LPTIM(registers: p.io, handle: p.io, callbacks: callbacks,
                      getSystemCoreClock: { 20000 }, useRegisteredCallbacks: true)
        XCTAssertEqual(d.initialize(), .ok)
        XCTAssertEqual(callbacks.writes, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 12, 0])
    }
    func testDisableReadsBothChannelEnablesSeparatelyAndShortCircuits() {
        let p = LPTIMPair(), io = LPTIMAccessIO()
        let d = LPTIM(registers: io, handle: p.io, callbacks: p.io, getSystemCoreClock: { 20000 })
        io.values[.ccmr1] = 2; d.disable(); XCTAssertEqual(io.events, ["r:ccmr1"])
        io.events = []; io.values[.ccmr1] = 0x20000; d.disable(); XCTAssertEqual(io.events, ["r:ccmr1", "r:ccmr1"])
        io.events = []; io.values[.ccmr1] = 0; io.reads[.ccmr1] = [0, 0x20000]
        d.disable(); XCTAssertEqual(io.events, ["r:ccmr1", "r:ccmr1"])
        io.events = []; d.disable(); XCTAssertEqual(io.events, ["r:ccmr1", "r:ccmr1", "r:cr", "w:cr"])
    }
    func testOutputConfigurationWaitsBeforePublishingCCMRAndDisabling() {
        let p = LPTIMPair(), io = LPTIMAccessIO(.lptim4)
        let d = LPTIM(registers: io, handle: p.io, callbacks: p.io, getSystemCoreClock: { 20000 })
        XCTAssertEqual(d.configureOutputCompare(.init(pulse: 123, polarity: 1), channel: .channel1), .ok)
        XCTAssertEqual(io.events, ["r:ccmr1", "r:cfgr", "w:cfgr", "r:cr", "w:cr", "w:icr", "w:ccr1", "r:isr", "r:ccmr1", "r:ccmr1", "r:cr", "w:cr", "w:ccmr1"])
    }
    func testCaptureStartsCounterBeforeChannelEnableWithoutClearingDIEROK() {
        let p = LPTIMPair(), io = LPTIMAccessIO()
        let d = LPTIM(registers: io, handle: p.io, callbacks: p.io, getSystemCoreClock: { 20000 })
        XCTAssertEqual(d.startInputCapture(channel: .channel2, interrupts: true), .ok)
        XCTAssertEqual(io.events, ["r:cr", "w:cr", "r:dier", "w:dier", "r:isr", "r:cr", "w:cr", "r:ccmr1", "w:ccmr1"])
    }
    func testIRQReadsISRForEveryBranchAndDIEROnlyForSetFlags() {
        let p = LPTIMPair(), io = LPTIMAccessIO()
        let d = LPTIM(registers: io, handle: p.io, callbacks: p.io, getSystemCoreClock: { 20000 })
        io.values[.isr] = 0; d.handleInterrupt()
        XCTAssertEqual(io.events, Array(repeating: "r:isr", count: 13))
        io.events = []; io.values[.isr] = 1; d.handleInterrupt()
        XCTAssertEqual(io.events, ["r:isr", "r:dier"] + Array(repeating: "r:isr", count: 12))
    }
}
