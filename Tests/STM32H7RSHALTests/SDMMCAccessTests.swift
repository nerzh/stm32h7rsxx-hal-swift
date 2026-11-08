import STM32H7RSHAL
import XCTest

private enum SDMMCAccess: Equatable {
  case read(SDMMCRegister)
  case write(SDMMCRegister, UInt32)
  case coreClock
}

private final class SDMMCObservedRegisters: SDMMCRegisterIO {
  let fixture = SDMMCFixture()
  var accesses: [SDMMCAccess] = []
  var instance: SDMMCInstance { fixture.instance }
  func address(of register: SDMMCRegister) -> UInt32 { fixture.address(of: register) }
  func read(_ register: SDMMCRegister) -> UInt32 {
    accesses.append(.read(register))
    return fixture.read(register)
  }
  func write(_ register: SDMMCRegister, value: UInt32) {
    accesses.append(.write(register, value))
    fixture.write(register, value: value)
  }
  var driver: SDMMC<SDMMCObservedRegisters> { .init(registers: self) }
}

final class SDMMCAccessTests: XCTestCase {
  func testClearWritesAndOriginalFIFOCountRead() {
    let io = SDMMCObservedRegisters()
    io.fixture.write(.fifo, value: 0xABCD_1234)
    io.driver.clearFlag(0x40)
    io.driver.clearInterrupt(0x100)
    XCTAssertEqual(io.driver.getFIFOCount(), 0xABCD_1234)
    XCTAssertEqual(io.accesses, [.write(.icr, 0x40), .write(.icr, 0x100), .read(.fifo)])
  }

  func testTimeoutCounterIsCheckedBeforeStatusRead() {
    let io = SDMMCObservedRegisters()
    io.fixture.write(.sta, value: 0x40)
    XCTAssertEqual(
      io.driver.getCommandResponse1(
        0, 0,
        getSystemCoreClock: {
          io.accesses.append(.coreClock)
          return 8000
        }), 0x8000_0000)
    XCTAssertEqual(io.accesses, [.coreClock])
    io.accesses = []
    io.fixture.write(.sta, value: 0x2000)
    XCTAssertEqual(
      io.driver.getCommandResponse1(
        0, 1,
        getSystemCoreClock: {
          io.accesses.append(.coreClock)
          return 8000
        }), 0x8000_0000)
    XCTAssertEqual(io.accesses, [.coreClock, .read(.sta)])
  }

  func testCommandPublishesArgumentBeforeCommandAndClockRead() {
    let io = SDMMCObservedRegisters()
    io.fixture.write(.cmd, value: 0)
    XCTAssertEqual(
      io.driver.commandReadSingleBlock(
        7,
        getSystemCoreClock: {
          io.accesses.append(.coreClock)
          return 0
        }), 0x8000_0000)
    XCTAssertEqual(
      io.accesses,
      [
        .write(.arg, 7), .read(.cmd), .write(.cmd, 0x1111), .coreClock,
      ])
  }

  func testInterruptAndFlagMacrosUseDifferentMaskPredicates() {
    let io = SDMMCObservedRegisters()
    io.fixture.write(.sta, value: 0x100)
    XCTAssertTrue(io.driver.getFlag(0x300))
    XCTAssertFalse(io.driver.getInterrupt(0x300))
    XCTAssertTrue(io.driver.getInterrupt(0))
    XCTAssertFalse(io.driver.getFlag(0))
    io.fixture.write(.mask, value: 0xA500)
    io.accesses = []
    io.driver.enableInterrupts(0x33)
    io.driver.disableInterrupts(0xF00)
    XCTAssertEqual(
      io.accesses,
      [
        .read(.mask), .write(.mask, 0xA533), .read(.mask), .write(.mask, 0xA033),
      ])
  }
}
