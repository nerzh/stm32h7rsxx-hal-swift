import STM32H7RSHAL
import XCTest

private final class I2CObservedRegisters: I2CRegisterIO {
  let fixture = I2CFixture()
  var reads: [I2CRegister] = []
  var writes: [(I2CRegister, UInt32)] = []
  var clearFlagsOnSourceRead = false
  func read(_ register: I2CRegister) -> UInt32 {
    reads.append(register)
    let value = fixture.read(register)
    if clearFlagsOnSourceRead && register == .cr1 { fixture.write(.isr, value: 0) }
    return value
  }
  func write(_ register: I2CRegister, value: UInt32) {
    writes.append((register, value))
    fixture.write(register, value: value)
  }
  func address(of register: I2CRegister) -> UInt32 { fixture.address(of: register) }
  var driver: I2C<I2CObservedRegisters, I2CFixture, I2CFixture, I2CFixture> {
    .init(
      registers: self, handle: fixture, callbacks: fixture, dma: fixture, defaults: fixture.defaults
    )
  }
}
final class I2CAccessTests: XCTestCase {
  func testEventHandlerCapturesFlagsBeforeSourcesEvenWithoutTransfer() {
    let io = I2CObservedRegisters()
    io.driver.eventInterruptHandler()
    XCTAssertEqual(io.reads, [.isr, .cr1])
    XCTAssertTrue(io.writes.isEmpty)
  }
  func testFlagClearsPreserveTXEReadModifyWriteAndDirectICRWrites() {
    let io = I2CObservedRegisters()
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
  func testErrorHandlerUsesCapturedFlagsForAllThreeErrors() {
    let io = I2CObservedRegisters()
    io.fixture.write(.isr, value: 0x700)
    io.fixture.write(.cr1, value: 0x80)
    io.clearFlagsOnSourceRead = true
    io.driver.errorInterruptHandler()
    XCTAssertEqual(Array(io.reads.prefix(2)), [.isr, .cr1])
    XCTAssertEqual(io.writes.filter { $0.0 == .icr }.map { $0.1 }, [0x100, 0x400, 0x200])
    XCTAssertEqual(io.fixture.read(.errorCode), 0xB)
    XCTAssertEqual(io.fixture.control(8), 11)
  }
}
