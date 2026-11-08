import XCTest
import STM32H7RSHAL

private final class MCEAccessModel: MCERegisterIO, MCEHandleIO, MCECallbackIO {
    enum Event: Equatable { case read(MCERegister), write(MCERegister, UInt32), tick }
    var instance = MCEInstance.mce1
    var values: [MCERegister: UInt32] = [:]
    var words: [MCEHandleWord: UInt32] = [:]
    var events: [Event] = []
    var context: UnsafeMutableRawPointer? { nil }
    func read(_ reg: MCERegister) -> UInt32 { events.append(.read(reg)); return values[reg, default: 0] }
    func write(_ reg: MCERegister, value: UInt32) { events.append(.write(reg, value)); values[reg] = value; if reg == .iacr { values[.iasr, default: 0] &= ~value } }
    func read(_ word: MCEHandleWord) -> UInt32 { words[word, default: 0] }
    func write(_ word: MCEHandleWord, value: UInt32) { words[word] = value }
    func read(_ id: MCECallbackID) -> MCECallback? { nil }
    func write(_ id: MCECallbackID, value: MCECallback?) { XCTFail("Unregistered mode must not touch callback storage") }
    var driver: MCE<MCEAccessModel, MCEAccessModel, MCEAccessModel> { .init(registers: self, handle: self, callbacks: self) }
}
final class MCEAccessTests: XCTestCase {
    func testNoekeonReadsTickBeforeLockAndWritesZeroBeforeReplacingValidKey() {
        for fast in [false,true] {
            let m = MCEAccessModel(); m.instance = .mce2; m.values[.sr] = 5
            let key: [UInt32] = [0x1234,0x5678,0x9ABC,0xDEF0]
            key.withUnsafeBufferPointer { XCTAssertEqual(m.driver.configureNoekeon(keyType: fast ? 1 : 0, key: $0.baseAddress, getTick: { m.events.append(.tick); return 0 }), .ok) }
            let reg: (UInt32) -> MCERegister = { fast ? .fastMasterKey($0) : .masterKey($0) }
            XCTAssertEqual(m.events, [.tick,.read(.cr),.read(.sr),.write(reg(0),0),.write(reg(0),key[0]),.write(reg(1),key[1]),.write(reg(2),key[2]),.write(reg(3),key[3]),.read(.sr)])
            m.events = []; m.values[.cr] = 2
            XCTAssertEqual(m.driver.configureNoekeon(keyType: 0, key: nil, getTick: { m.events.append(.tick); return 0 }), .ok)
            XCTAssertEqual(m.events, [.tick,.read(.cr)])
        }
    }
    func testAESWritesNonceKeyWordsThenVersionAndReadsBothLocksSeparately() {
        let m = MCEAccessModel(), key: [UInt32] = [11,22,33,44]
        key.withUnsafeBufferPointer { XCTAssertEqual(m.driver.configureAESContext(.init(nonce0: 7, nonce1: 8, version: 9, key: $0.baseAddress), context: 0x400), .ok) }
        XCTAssertEqual(m.events, [.read(.cr),.read(.context(1,.cccfgr)),.read(.context(1,.cccfgr)),
            .write(.context(1,.ccnr0),7),.write(.context(1,.ccnr1),8),.write(.context(1,.cckeyr0),11),.write(.context(1,.cckeyr1),22),
            .write(.context(1,.cckeyr2),33),.write(.context(1,.cckeyr3),44),.read(.context(1,.cccfgr)),.write(.context(1,.cccfgr),9<<16)])
    }
    func testAlreadyEnabledContextSkipsGlobalLockButStillPerformsRMW() {
        let m = MCEAccessModel(); m.values[.cr] = 1; m.values[.context(0,.cccfgr)] = 3
        XCTAssertEqual(m.driver.enableAESContext(0x200), .ok)
        XCTAssertEqual(m.events, [.read(.context(0,.cccfgr)),.read(.context(0,.cccfgr)),.write(.context(0,.cccfgr),3)])
    }
    func testIRQUsesSnapshotIgnoresEnableRegisterAndClearsFlagsSeparately() {
        let m = MCEAccessModel(); m.values[.iasr] = 3; m.values[.iaesr] = 0x90
        m.driver.handleInterrupt()
        XCTAssertEqual(m.events, [.read(.iasr),.write(.iacr,1),.read(.iaesr),.write(.iacr,2)])
        XCTAssertEqual(m.words[.errorCode], 9); XCTAssertEqual(m.values[.iasr], 0)
    }
}
