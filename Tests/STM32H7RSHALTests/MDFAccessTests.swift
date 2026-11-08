import XCTest
import STM32H7RSHAL

private final class MDFRegisterTrace: MDFRegisterIO {
    enum Event: Equatable { case read(MDFRegister), write(MDFRegister, UInt32) }
    let model: MDFModel
    var events: [Event] = []
    var writeOneToClear = false
    init(_ model: MDFModel) { self.model = model }
    func read(_ register: MDFRegister) -> UInt32 { events.append(.read(register)); return model.read(register) }
    func write(_ register: MDFRegister, value: UInt32) {
        events.append(.write(register, value))
        model.write(register, value: register == .dfltisr && writeOneToClear ? model.read(register) & ~value : value)
    }
    func dataAddress() -> UInt32 { model.dataAddress() }
    var driver: MDF<MDFRegisterTrace, MDFModel, MDFModel, MDFModel, MDFModel> {
        .init(registers: self, handle: model, shared: model, callbacks: model, dma: model, defaults: model.driver.defaults, useRegisteredCallbacks: model.get(11,0) != 0)
    }
}
final class MDFAccessTests: XCTestCase {
    func testTimeoutReadsFlagAgainAndThenErrors() {
        let p = MDFPair(), io = MDFRegisterTrace(.init(state: p.actual)); p.set(1,12,2)
        var ticks: UInt32 = 0
        XCTAssertEqual(io.driver.pollForAcquisition(timeout: 0, getTick: { ticks += 1; return ticks }), .timeout)
        XCTAssertEqual(ticks,2); XCTAssertEqual(io.events,[.read(.dfltisr),.read(.dfltisr),.read(.dfltisr)])
    }
    func testIRQSnapshotsEnableBeforeFlagsAndClearsOtherW1CFlagsToo() {
        let p = MDFPair(), io = MDFRegisterTrace(.init(state: p.actual)); io.writeOneToClear = true
        p.reg(.dfltier,0x3E03); p.reg(.dfltisr,0x3E03)
        io.driver.handleInterrupt()
        XCTAssertEqual(io.events,[.read(.dfltier),.read(.dfltisr),.read(.dfltisr),.write(.dfltisr,0x3E03)])
        XCTAssertEqual(p.get(0,0xB0 / 4),0); XCTAssertEqual(p.get(1,13),1); XCTAssertEqual(p.get(10,0),1)
    }
    func testClockMonitorEnablesOnlyAfterW1CAcknowledgement() {
        let p = MDFPair(), io = MDFRegisterTrace(.init(state: p.actual)); io.writeOneToClear = true
        p.reg(.sitfcr,0x80000011); p.reg(.dfltisr,0x1400); p.reg(.dfltier,0x200)
        XCTAssertEqual(io.driver.startClockAbsenceInterrupt(),.ok)
        XCTAssertEqual(io.events,[.read(.sitfcr),.read(.sitfcr),.read(.dfltisr),.write(.dfltisr,0x1400),.read(.dfltisr),.read(.dfltier),.write(.dfltier,0x600)])
    }
    func testSoundLevelIRQReadsLevelsBeforeAcknowledgement() {
        let p = MDFPair(), io = MDFRegisterTrace(.init(state: p.actual))
        p.reg(.dfltier,0x2000); p.reg(.dfltisr,0x2000)
        io.driver.handleInterrupt()
        XCTAssertEqual(io.events,[.read(.dfltier),.read(.dfltisr),.read(.sadsdlvr),.read(.sadanlvr),.read(.dfltisr),.write(.dfltisr,0x2000)])
    }
    func testSetDelayKeepsExistingBitsAndGainPreservesOtherFields() {
        let p = MDFPair(), io = MDFRegisterTrace(.init(state: p.actual)); p.set(1,12,2); p.reg(.dlycr,0x55); p.reg(.dfltcicr,.max)
        XCTAssertEqual(io.driver.setDelay(0x2A),.ok); XCTAssertEqual(io.driver.setGain(-16),.ok)
        XCTAssertEqual(io.events,[.read(.dlycr),.read(.dlycr),.write(.dlycr,0x7F),.read(.dfltcicr),.write(.dfltcicr,0xFE0FFFFF)])
    }
}
