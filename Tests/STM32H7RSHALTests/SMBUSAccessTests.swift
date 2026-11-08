import STM32H7RSHAL
import XCTest

private final class SMBUSObservedRegisters: SMBUSRegisterIO {
  let fixture = SMBUSFixture()
  var reads: [SMBUSRegister] = []
  var writes: [(SMBUSRegister, UInt32)] = []
  var clearFlagsOnSourceRead = false
  var writeLocks: [UInt32] = []
  func read(_ register: SMBUSRegister) -> UInt32 {
    reads.append(register)
    let value = fixture.read(register)
    if clearFlagsOnSourceRead && register == .cr1 { fixture.write(.isr, value: 0) }
    return value
  }
  func write(_ register: SMBUSRegister, value: UInt32) {
    writes.append((register, value))
    writeLocks.append(fixture.read(.lock))
    fixture.write(register, value: value)
  }
  func address(of register: SMBUSRegister) -> UInt32 { fixture.address(of: register) }
  var driver: SMBUS<SMBUSObservedRegisters, SMBUSFixture, SMBUSFixture> {
    .init(
      registers: self, handle: fixture, callbacks: fixture, defaults: fixture.defaults
    )
  }
}
final class SMBUSAccessTests: XCTestCase {
  func testEventHandlerCapturesFlagsBeforeSourcesEvenWithoutTransfer() {
    let io = SMBUSObservedRegisters()
    io.driver.eventInterruptHandler()
    XCTAssertEqual(io.reads, [.isr, .cr1])
    XCTAssertTrue(io.writes.isEmpty)
  }
  func testFlagClearsPreserveTXEReadModifyWriteAndDirectICRWrites() {
    let io = SMBUSObservedRegisters()
    io.fixture.write(.isr, value: 0xA000)
    io.driver.clearFlag(1)
    XCTAssertEqual(io.reads, [.isr])
    XCTAssertEqual(io.writes.map { $0.0 }, [.isr])
    XCTAssertEqual(io.writes.map { $0.1 }, [0xA001])
    io.reads = []
    io.writes = []
    io.driver.clearFlag(0x30)
    XCTAssertTrue(io.reads.isEmpty)
    XCTAssertEqual(io.writes.map { $0.0 }, [.icr])
    XCTAssertEqual(io.writes.map { $0.1 }, [0x30])
  }
  func testErrorHandlerUsesCapturedFlagsForAllSixErrors() {
    let io = SMBUSObservedRegisters()
    io.fixture.write(.isr, value: 0x3F00)
    io.fixture.write(.cr1, value: 0x80)
    io.clearFlagsOnSourceRead = true
    io.driver.errorInterruptHandler()
    XCTAssertEqual(Array(io.reads.prefix(2)), [.isr, .cr1])
    XCTAssertEqual(
      io.writes.filter { $0.0 == .icr }.map { $0.1 }, [0x100, 0x400, 0x200, 0x1000, 0x2000, 0x800])
    XCTAssertEqual(io.fixture.read(.errorCode), 0xEB)
    XCTAssertEqual(io.fixture.control(8), 11)
  }

  func testInitializationDisablesBothTimeoutsBeforeReplacingRegister() {
    let io = SMBUSObservedRegisters()
    io.fixture.write(.timeoutr, value: .max)
    io.fixture.write(.smbusTimeout, value: 0x1234)
    XCTAssertEqual(io.driver.initialize(), .ok)
    XCTAssertEqual(
      io.writes.filter { $0.0 == .timeoutr }.map { $0.1 },
      [0xFFFF_7FFF, 0x7FFF_7FFF, 0x1234])
  }
  func testTransferInterruptsAreEnabledOnlyAfterUnlocking() {
    for receive in [false, true] {
      let io = SMBUSObservedRegisters()
      io.fixture.write(.state, value: 1)
      let status =
        receive
        ? io.driver.masterReceiveInterrupt(0xA4, io.fixture.buffer, 2, 0x2000000)
        : io.driver.masterTransmitInterrupt(0xA4, io.fixture.buffer, 2, 0x2000000)
      XCTAssertEqual(status, .ok)
      for i in io.writes.indices where io.writes[i].0 == .cr1 {
        XCTAssertEqual(io.writeLocks[i], 0)
      }
      XCTAssertEqual(io.writes.last?.0, .cr1)
    }
  }
}
