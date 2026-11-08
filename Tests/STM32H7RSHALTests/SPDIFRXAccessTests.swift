import XCTest
import STM32H7RSHAL

private final class SPDIFRXRegisterTrace: SPDIFRXRegisterIO {
    enum Event: Equatable { case read(SPDIFRXRegister), write(SPDIFRXRegister, UInt32), peripheralControl }
    let model: SPDIFRXModel
    var events: [Event] = []
    init(_ model: SPDIFRXModel) { self.model = model }
    func read(_ register: SPDIFRXRegister) -> UInt32 { events.append(.read(register)); return model.read(register) }
    func write(_ register: SPDIFRXRegister, value: UInt32) { events.append(.write(register, value)); model.write(register, value: value) }
    func readPeripheralControl() -> UInt32 { events.append(.peripheralControl); return model.readPeripheralControl() }
    func dataAddress(_ stream: SPDIFRXStream) -> UInt32 { model.dataAddress(stream) }
    var driver: SPDIFRX<SPDIFRXRegisterTrace, SPDIFRXModel, SPDIFRXModel, SPDIFRXModel> {
        .init(registers: self, handle: model, callbacks: model, dma: model, defaults: model.driver.defaults, useRegisteredCallbacks: model.get(9,0) != 0)
    }
}
final class SPDIFRXAccessTests: XCTestCase {
    func testInterruptStartChecksGlobalControlAndTimeoutClearsEachMaskInOrder() {
        let p = SPDIFRXPair(), io = SPDIFRXRegisterTrace(.init(state: p.actual))
        p.set(0,1,.max)
        let buffer = io.model.readBuffer(.data)!
        XCTAssertEqual(io.driver.receiveInterrupt(.data, data: buffer, count: 1, systemCoreClock: 0), .timeout)
        XCTAssertEqual(Array(io.events.prefix(9)), [.read(.imr),.write(.imr,.max),.read(.imr),.write(.imr,.max),.read(.imr),.write(.imr,.max),.peripheralControl,.read(.cr),.write(.cr,1)])
        XCTAssertFalse(io.events.contains(.read(.sr)))
        let expected: [UInt32] = [0xFFFE,0xFFFC,0xFFF8,0xFFF0,0xFFE0,0xFFC0,0xFF80]
        XCTAssertEqual(Array(io.events.suffix(14)), expected.flatMap { [.read(.imr),.write(.imr,$0)] })
    }
    func testIRQReadsBothSnapshotsBeforeAnyDataAndAcknowledgesBeforeEachRead() {
        let p = SPDIFRXPair(), io = SPDIFRXRegisterTrace(.init(state: p.actual))
        p.set(0,2,3); p.set(0,1,3); p.set(1,13,2); p.set(1,15,2)
        io.driver.handleInterrupt()
        XCTAssertEqual(io.events, [.read(.sr),.read(.imr),.write(.ifcr,1),.read(.dr),.write(.ifcr,2),.read(.csr)])
    }
    func testDMAStopPerformsSeparateTruncatedRMWBeforeIdle() {
        let p = SPDIFRXPair(), io = SPDIFRXRegisterTrace(.init(state: p.actual))
        p.set(0,0,.max); p.set(2,0,0); p.set(2,13,0)
        XCTAssertEqual(io.driver.stopDMA(), .ok)
        XCTAssertEqual(io.events, [.read(.cr),.write(.cr,0xFFFB),.read(.cr),.write(.cr,0xFBFB),.read(.cr),.write(.cr,0xFBF8)])
    }
}

private final class SPDIFRXChangingState: SPDIFRXHandleIO {
    let model: SPDIFRXModel
    var stateReads = 0
    init(_ model: SPDIFRXModel) { self.model = model }
    func read(_ word: SPDIFRXHandleWord) -> UInt32 {
        if word == .state { stateReads += 1; return stateReads == 1 ? 1 : 0 }
        return model.read(word)
    }
    func write(_ word: SPDIFRXHandleWord, value: UInt32) { model.write(word, value: value) }
    func readBuffer(_ stream: SPDIFRXStream) -> UnsafeMutablePointer<UInt32>? { model.readBuffer(stream) }
    func writeBuffer(_ stream: SPDIFRXStream, value: UnsafeMutablePointer<UInt32>?) { model.writeBuffer(stream, value: value) }
}
extension SPDIFRXAccessTests {
    func testUnregisterRejectedMSPIDDoesNotReadStateAgainAfterReadyBranch() {
        let p = SPDIFRXPair(1), model = SPDIFRXModel(state: p.actual)
        let handle = SPDIFRXChangingState(model)
        let d = SPDIFRX(registers: model, handle: handle, callbacks: model, dma: model, useRegisteredCallbacks: true)
        XCTAssertEqual(d.unregisterCallback(id: .mspInitialize), .error)
        XCTAssertEqual(handle.stateReads, 1)
    }
}
