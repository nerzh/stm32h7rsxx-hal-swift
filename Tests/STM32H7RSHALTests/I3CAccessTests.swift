import CI3CReference
import STM32H7RSHAL
import XCTest

private final class I3CObservedRegisters: I3CRegisterIO {
  let fixture = I3CFixture()
  var reads: [I3CRegister] = []
  var writes: [(I3CRegister, UInt32)] = []
  var clearEventsOnMaskRead = false
  func read(_ register: I3CRegister) -> UInt32 {
    reads.append(register)
    let value = fixture.read(register)
    if clearEventsOnMaskRead && register == .ier { fixture.write(.evr, value: 0) }
    return value
  }
  func write(_ register: I3CRegister, value: UInt32) {
    writes.append((register, value))
    fixture.write(register, value: value)
  }
  func address(of register: I3CRegister) -> UInt32 { fixture.address(of: register) }
  var driver: I3C<I3CObservedRegisters, I3CFixture, I3CFixture, I3CFixture> {
    .init(
      registers: self, handle: fixture, callbacks: fixture, dma: fixture, defaults: fixture.defaults
    )
  }
}
final class I3CAccessTests: XCTestCase {
  func testIRQSnapshotAndDirectClearOrder() {
    let io = I3CObservedRegisters()
    io.driver.eventInterruptHandler()
    XCTAssertEqual(io.reads, [.evr, .ier])
    io.reads = []
    io.fixture.write(.mode, value: 1)
    io.fixture.write(.state, value: 0x20)
    io.fixture.write(.evr, value: 0x800)
    io.fixture.write(.ier, value: 0x800)
    io.clearEventsOnMaskRead = true
    io.driver.errorInterruptHandler()
    XCTAssertEqual(Array(io.reads.prefix(2)), [.evr, .ier])
    XCTAssertEqual(io.writes.first?.0, .cevr)
    XCTAssertEqual(io.writes.first?.1, 0x800)
    XCTAssertFalse(io.reads.contains(.cevr))
  }

  func testStatusFIFOIsReadForDrainAndDataAccessUsesWordRegisters() {
    let io = I3CObservedRegisters()
    prepareI3CInterrupt(io.fixture, selector: 10, state: 0x21)
    io.fixture.loadStructures()
    io.fixture.write(.evr, value: 0x8)
    io.fixture.write(.ier, value: 0x8)
    io.driver.eventInterruptHandler()
    XCTAssertEqual(Array(io.reads.prefix(2)), [.evr, .ier])
    XCTAssertTrue(io.reads.contains(.sr))
    XCTAssertTrue(io.writes.isEmpty)
  }

  func testPublicRegisterAndPayloadMacros() {
    let io = I3CObservedRegisters()
    io.fixture.write(.ier, value: 0xA500)
    io.driver.enableInterrupts(0x33)
    io.driver.disableInterrupts(0xF00)
    XCTAssertEqual(io.reads, [.ier, .ier])
    XCTAssertEqual(io.writes.map { $0.1 }, [0xA533, 0xA033])
    for value: UInt32 in 0..<256 {
      XCTAssertEqual(
        io.driver.getBusCharacteristics(UInt64(value) << 48 | 0xFF00_0000_0000_00FF), value)
      XCTAssertEqual(io.driver.isIBICapable(value), value & 2 == 2 ? 1 : 0)
      XCTAssertEqual(io.driver.hasIBIPayload(value), value & 4 == 4 ? 1 : 0)
      XCTAssertEqual(io.driver.isControllerCapable(value), value & 0x40 == 0x40 ? 1 : 0)
    }
    io.fixture.write(.state, value: 0x60)
    io.driver.resetHandleState()
    XCTAssertEqual(io.fixture.read(.state), 0)
    XCTAssertNil(io.fixture.read(.mspInitialize))
    XCTAssertNil(io.fixture.read(.mspDeinitialize))
  }

  func testRegisterAccessTraceMatchesCForConfigurationAndPayloadFIFO() {
    for op: UInt32 in [0, 1, 11, 12, 13, 14, 15, 18, 20, 21, 22, 23, 24, 25, 26, 41] {
      checkI3C(
        { f in
          prepareI3CBuffers(f)
          f.control(30, 1)
          f.set(0, 0x50 / 4, 0x10)
          f.set(0, 0x10 / 4, 0xA7)
        }, operation: op, 2, 3)
    }
  }
}
