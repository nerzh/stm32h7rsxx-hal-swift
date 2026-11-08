import XCTest
import STM32H7RSHAL

private final class PSSIAccessIO: PSSIRegisterIO {
    let base: PSSIModel
    var events: [String] = []
    init(_ base: PSSIModel) { self.base = base }
    func read(_ register: PSSIRegister) -> UInt32 { events.append("r:\(register)"); return base.read(register) }
    func write(_ register: PSSIRegister, value: UInt32) { events.append("w:\(register)"); base.write(register, value: value) }
    func dataAddress() -> UInt32 { base.dataAddress() }
    func readData8() -> UInt8 { events.append("r8"); return base.readData8() }
    func readData16() -> UInt16 { events.append("r16"); return base.readData16() }
    func writeData8(_ value: UInt8) { events.append("w8"); base.writeData8(value) }
    func writeData16(_ value: UInt16) { events.append("w16"); base.writeData16(value) }
}
final class PSSIAccessTests: XCTestCase {
    func testPollingUsesExactDataAccessWidthAndChecksStatusBeforeEveryElement() {
        let buffer = UnsafeMutablePointer<UInt32>.allocate(capacity: 2)
        buffer.initialize(repeating: 0x12345678, count: 2)
        defer { buffer.deallocate() }
        for width: UInt32 in 0...2 { for receive in [false,true] {
            let p = PSSIPair(), model = PSSIModel(state: p.actual), io = PSSIAccessIO(model)
            p.set(1,0,width); p.set(0,1,12)
            let d = PSSI(registers: io, handle: model, callbacks: model, dma: model)
            let status = receive ? d.receive(buffer, count: 8, timeout: 0, getTick: { 0 }) : d.transmit(buffer, count: 8, timeout: 0, getTick: { 0 })
            XCTAssertEqual(status, .ok)
            let access = width == 2 ? (receive ? "r:dr" : "w:dr") : "\(receive ? "r" : "w")\(width == 0 ? 8 : 16)"
            let expected = Array(repeating: ["r:sr",access], count: 8 >> Int(width)).flatMap { $0 }
            XCTAssertEqual(Array(io.events.dropFirst(8)), expected + ["r:ris"])
        } }
    }
    func testReceiveDMADisablesBeforeLockWhileTransmitChecksLockFirst() {
        for receive in [false,true] {
            let p = PSSIPair(), model = PSSIModel(state: p.actual), io = PSSIAccessIO(model)
            p.set(1,8,1); p.set(0,0,0x4000)
            let d = PSSI(registers: io, handle: model, callbacks: model, dma: model)
            XCTAssertEqual(receive ? d.receiveDMA(nil, count: 4) : d.transmitDMA(nil, count: 4), .busy)
            XCTAssertEqual(io.events, receive ? ["r:cr","w:cr"] : [])
        }
    }
}
