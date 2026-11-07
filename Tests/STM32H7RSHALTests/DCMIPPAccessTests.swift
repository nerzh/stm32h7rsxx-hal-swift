import XCTest
import STM32H7RSHAL
import CDCMIPPReference

private final class DCMIPPTrace: DCMIPPRegisterIO {
    enum Event: Equatable { case read(DCMIPPRegister), write(DCMIPPRegister, UInt32), tick(UInt32) }
    let storage = UnsafeMutableRawPointer.allocate(byteCount: CDCMIPP_Size(), alignment: 16)
    let io: DCMIPPReferenceIO
    var events: [Event] = []
    var ticks: UInt32 = 0
    var tickStep: UInt32 = 1
    init() {
        io = .init(state: OpaquePointer(storage), mode: 0)
        CDCMIPP_Reset(io.state, 0)
    }
    deinit { storage.deallocate() }
    var hal: DCMIPP<DCMIPPTrace, DCMIPPReferenceIO, DCMIPPReferenceIO> {
        .init(registers: self, handle: io, callbacks: io, defaults: io.hal.defaults)
    }
    func read(_ register: DCMIPPRegister) -> UInt32 { events.append(.read(register)); return io.read(register) }
    func write(_ register: DCMIPPRegister, value: UInt32) { events.append(.write(register, value)); io.write(register, value: value) }
    func tick() -> UInt32 { let value = ticks; ticks &+= tickStep; events.append(.tick(value)); return value }
}
final class DCMIPPAccessTests: XCTestCase {
    func testStartEnablesPipeBeforeCaptureAndKeepsDifferentInterruptMasks() {
        for doubleBuffer in [false, true] {
            let t = DCMIPPTrace()
            t.io.write(.pipeState, value: 1)
            if doubleBuffer { XCTAssertEqual(t.hal.startDoubleBuffer(address0: 0x24020000, address1: 0x24021000, mode: .snapshot), .ok) }
            else { XCTAssertEqual(t.hal.start(address: 0x24020000, mode: .snapshot), .ok) }
            var expected: [DCMIPPTrace.Event] = [.read(.p0fctcr), .write(.p0fctcr, 4), .write(.p0ppm0ar1, 0x24020000)]
            if doubleBuffer { expected += [.write(.p0ppm0ar2, 0x24021000), .read(.p0ppcr), .write(.p0ppcr, 0x10000)] }
            expected += [.read(.cmier), .write(.cmier, doubleBuffer ? 0x8600 : 0x8620),
                .read(.p0fscr), .write(.p0fscr, 0x80000000), .read(.p0fctcr), .write(.p0fctcr, 12)]
            XCTAssertEqual(t.events, expected)
        }
    }
    func testTimeoutIsCheckedBeforeStatusEvenWhenCaptureIsInactive() {
        for suspended in [false, true] {
            let t = DCMIPPTrace()
            t.io.write(.pipeState, value: 2); t.io.write(.p0fctcr, value: 12); t.tickStep = 1001
            XCTAssertEqual(suspended ? t.hal.suspend(getTick: t.tick) : t.hal.stop(getTick: t.tick), .error)
            XCTAssertEqual(t.events, [.read(.p0fctcr), .write(.p0fctcr, 4), .tick(0), .tick(1001)])
            XCTAssertEqual(t.io.read(.pipeState), suspended ? 4 : 2)
        }
    }
    func testIPPlugWaitsBeforeWritingConfigurationAndReleasesLockLast() {
        let t = DCMIPPTrace()
        t.io.write(DCMIPPHandleWord.state, value: 1); t.io.write(.ipgr3, value: 1)
        XCTAssertEqual(t.hal.configureIPPlug(.init(client: 1, memoryPageSize: 7, traffic: 4,
            maxOutstandingTransactions: 3, start: 0, end: 31, arbitrationRatio: 15), getTick: t.tick), .ok)
        XCTAssertEqual(t.events, [.read(.ipgr2), .write(.ipgr2, 1), .tick(0), .tick(1), .read(.ipgr3),
            .write(.ipgr1, 7), .write(.ipc1r1, 0x304), .write(.ipc1r2, 0xF0000), .write(.ipc1r3, 0x1F0000),
            .read(.ipgr2), .write(.ipgr2, 0), .read(.cmier), .write(.cmier, 0x20)])
    }
    func testInterruptSnapshotProcessesAllFlagsDespiteDisablingSources() {
        let t = DCMIPPTrace()
        t.io.write(.cmsr2, value: 0xC760); t.io.write(.cmier, value: 0xC760); t.io.write(.p0fctcr, value: 4)
        t.hal.handleInterrupt()
        XCTAssertEqual(t.events, [.read(.cmsr2), .read(.cmier),
            .read(.cmier), .write(.cmier, 0x8760), .write(.cmfcr, 0x4000), .write(.cmfcr, 0x400),
            .read(.p0fctcr), .read(.cmier), .write(.cmier, 0x160), .write(.cmfcr, 0x200), .write(.cmfcr, 0x100),
            .read(.cmier), .write(.cmier, 0x160), .write(.cmfcr, 0x8000),
            .read(.cmier), .write(.cmier, 0x120), .write(.cmfcr, 0x40),
            .read(.cmier), .write(.cmier, 0x100), .write(.cmfcr, 0x20)])
        XCTAssertEqual(t.io.read(.errorCode), 15)
        XCTAssertEqual(t.io.read(DCMIPPHandleWord.state), 4); XCTAssertEqual(t.io.read(.pipeState), 4)
    }
}
