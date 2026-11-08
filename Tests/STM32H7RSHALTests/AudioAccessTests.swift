import STM32H7RSHAL
import XCTest

private enum AudioAccess: Equatable {
  case read(UInt32, Int)
  case write(UInt32, Int, UInt32)
}
private final class I2SAccessIO: I2SRegisterIO {
  let fixture = I2SFixture()
  var accesses: [AudioAccess] = []
  var instance: I2SInstance { fixture.instance }
  func address(of register: I2SRegister) -> UInt32 { fixture.address(of: register) }
  func read(_ register: I2SRegister) -> UInt32 {
    accesses.append(.read(register.rawValue, 32))
    return fixture.read(register)
  }
  func write(_ register: I2SRegister, value: UInt32) {
    accesses.append(.write(register.rawValue, 32, value))
    fixture.write(register, value: value)
  }
  func read16(_ register: I2SRegister) -> UInt16 {
    accesses.append(.read(register.rawValue, 16))
    return fixture.read16(register)
  }
  func write16(_ register: I2SRegister, value: UInt16) {
    accesses.append(.write(register.rawValue, 16, UInt32(value)))
    fixture.write16(register, value: value)
  }
  var driver: I2S<I2SAccessIO, I2SFixture, I2SFixture, I2SNoDMA> {
    .init(registers: self, handle: fixture, callbacks: fixture, dma: .init())
  }
}
private final class SAIAccessIO: SAIRegisterIO {
  let fixture = SAIFixture()
  var accesses: [AudioAccess] = []
  var instance: SAIInstance { fixture.instance }
  func address(of register: SAIRegister) -> UInt32 { fixture.address(of: register) }
  func read(_ register: SAIRegister) -> UInt32 {
    accesses.append(.read(register.rawValue, 32))
    return fixture.read(register)
  }
  func write(_ register: SAIRegister, value: UInt32) {
    accesses.append(.write(register.rawValue, 32, value))
    fixture.write(register, value: value)
  }
  func readGlobal(_ peripheral: SAIPeripheral, _ register: SAIGlobalRegister) -> UInt32 {
    fixture.readGlobal(peripheral, register)
  }
  func writeGlobal(_ peripheral: SAIPeripheral, _ register: SAIGlobalRegister, value: UInt32) {
    fixture.writeGlobal(peripheral, register, value: value)
  }
  var driver: SAI<SAIAccessIO, SAIFixture, SAIFixture, SAINoDMA> {
    .init(registers: self, handle: fixture, callbacks: fixture, dma: .init())
  }
}
final class AudioAccessTests: XCTestCase {
  func testI2SClearMacrosKeepReadModifyWriteButSAIClearWritesDirectly() {
    let i = I2SAccessIO()
    i.fixture.write(.ifcr, value: 0x8000)
    i.driver.clearOverrunFlag()
    i.driver.clearUnderrunFlag()
    i.driver.clearFrameErrorFlag()
    XCTAssertEqual(
      i.accesses,
      [
        .read(24, 32), .write(24, 32, 0x8040), .read(24, 32), .write(24, 32, 0x8060), .read(24, 32),
        .write(24, 32, 0x8160),
      ])
    let s = SAIAccessIO()
    s.driver.clearFlag(0x21)
    XCTAssertEqual(s.accesses, [.write(24, 32, 0x21)])
  }
  func testI2SDataAccessUsesOriginalHalfwordOrWordWidth() {
    for format: UInt32 in [0, 0x800, 0x100, 0x200] {
      let io = I2SAccessIO()
      let f = io.fixture
      f.write(.state, value: 1)
      f.write(.dataFormat, value: format)
      f.write(.sr, value: 3)
      f.buffer()[0] = 0x12
      f.buffer()[1] = 0x34
      f.buffer()[2] = 0x56
      f.buffer()[3] = 0x78
      XCTAssertEqual(
        io.driver.transmit(
          buffer: UnsafeMutableRawPointer(f.buffer()), count: 1, timeout: 100, getTick: { 0 }), .ok)
      let width = format == 0 || format == 0x800 ? 16 : 32
      XCTAssertEqual(
        io.accesses.filter {
          if case .write(32, _, _) = $0 { return true }
          return false
        }, [.write(32, width, width == 16 ? 0x3412 : 0x7856_3412)])
      io.accesses = []
      f.write(.rxdr, value: 0xAABB_CCDD)
      XCTAssertEqual(
        io.driver.receive(
          buffer: UnsafeMutableRawPointer(f.buffer()), count: 1, timeout: 100, getTick: { 0 }), .ok)
      XCTAssertEqual(
        io.accesses.filter {
          if case .read(48, _) = $0 { return true }
          return false
        }, [.read(48, width)])
    }
  }
  func testInterruptRegisterSnapshotOrderAndInactiveSAI() {
    let i = I2SAccessIO()
    i.driver.interruptHandler()
    XCTAssertEqual(i.accesses, [.read(16, 32), .read(20, 32)])
    let s = SAIAccessIO()
    s.driver.interruptHandler(getTick: { 0 }, systemCoreClock: { 64_000_000 })
    XCTAssertEqual(s.accesses, [])
    s.fixture.write(.state, value: 1)
    s.driver.interruptHandler(getTick: { 0 }, systemCoreClock: { 64_000_000 })
    XCTAssertEqual(s.accesses, [.read(20, 32), .read(16, 32), .read(0, 32)])
  }
}
