import XCTest
import STM32H7RSHAL
import CDMA2DReference

private final class DMA2DTrace: DMA2DRegisterIO {
    enum Event: Equatable { case read(DMA2DRegister), write(DMA2DRegister, UInt32) }
    let storage = UnsafeMutableRawPointer.allocate(byteCount: CDMA2D_Size(), alignment: 16)
    let io: DMA2DReferenceIO
    var events: [Event] = []
    var completeAfterControlRead = false
    init() {
        io = .init(state: OpaquePointer(storage), mode: 0)
        CDMA2D_Reset(io.state, 0)
    }
    deinit { storage.deallocate() }
    var hal: DMA2D<DMA2DTrace, DMA2DReferenceIO, DMA2DReferenceIO> {
        .init(registers: self, handle: io, callbacks: io, defaults: io.dma.defaults)
    }
    func isClockEnabled() -> Bool { true }
    func read(_ register: DMA2DRegister) -> UInt32 {
        events.append(.read(register))
        let value = io.read(register)
        if register == .cr && completeAfterControlRead {
            completeAfterControlRead = false
            io.write(.cr, value: value & ~UInt32(7))
        }
        return value
    }
    func write(_ register: DMA2DRegister, value: UInt32) {
        events.append(.write(register, value))
        io.write(register, value: value)
    }
}
final class DMA2DAccessTests: XCTestCase {
    func testCompletedTransferCannotBeRestartedByAbortSuspendOrResume() {
        for operation in 0..<3 {
            let t = DMA2DTrace()
            t.io.write(.cr, value: operation == 2 ? 3 : 1)
            t.completeAfterControlRead = true
            switch operation {
            case 0: XCTAssertEqual(t.hal.abort(getTick: { 0 }), .ok)
            case 1: XCTAssertEqual(t.hal.suspend(getTick: { 0 }), .ok)
            default: XCTAssertEqual(t.hal.resume(), .ok)
            }
            let writes = t.events.compactMap { event -> UInt32? in
                if case .write(.cr, let value) = event { return value }; return nil
            }
            XCTAssertFalse(writes.isEmpty)
            XCTAssertTrue(writes.allSatisfy { $0 & 1 == 0 })
            XCTAssertEqual(t.io.read(.cr) & 1, 0)
        }
    }
    func testStartingTransferWritesDimensionsAndAddressBeforeInterruptsAndStart() {
        let t = DMA2DTrace()
        t.io.write(.mode, value: 0)
        XCTAssertEqual(t.hal.start(data: 0x24020000, destination: 0x24024000, width: 17, height: 3, interrupts: true), .ok)
        XCTAssertEqual(t.events, [.read(.nlr), .write(.nlr, 0x110003), .write(.omar, 0x24024000),
            .write(.fgmar, 0x24020000), .read(.cr), .write(.cr, 0x2300), .read(.cr), .write(.cr, 0x2301)])
    }
    func testInitializationRetainsTwoSeparateOutputFormatModifications() {
        let t = DMA2DTrace()
        t.io.write(DMA2DHandleWord.state, value: 1)
        t.io.write(.alphaInverted, value: 1); t.io.write(.redBlueSwap, value: 1)
        XCTAssertEqual(t.hal.initialize(), .ok)
        XCTAssertEqual(t.events, [.read(.cr), .write(.cr, 0), .read(.opfccr), .write(.opfccr, 0),
            .read(.oor), .write(.oor, 0), .read(.opfccr), .write(.opfccr, 0x300000)])
    }
    func testInterruptUsesOneStatusSnapshotAndClearsEachFlagDirectly() {
        let t = DMA2DTrace()
        t.io.write(.isr, value: 3); t.io.write(.cr, value: 0x300)
        t.hal.handleInterrupt()
        XCTAssertEqual(t.events, [.read(.isr), .read(.cr), .read(.cr), .write(.cr, 0x200), .write(.ifcr, 1),
                                  .read(.cr), .write(.cr, 0), .write(.ifcr, 2)])
        XCTAssertEqual(t.io.read(DMA2DHandleWord.errorCode), 1)
        XCTAssertEqual(t.io.read(DMA2DHandleWord.state), 1)
    }
}
