import XCTest
@testable import STM32H7RSHAL

private enum VREFBUFTestAccess: Equatable {
  case read(VREFBUFRegister, UInt32), write(VREFBUFRegister, UInt32), tick(UInt32)
}
private final class VREFBUFTestIO: VREFBUFRegisterIO {
  var values: [VREFBUFRegister: UInt32] = [:]
  var trace: [VREFBUFTestAccess] = []
  var tick: UInt32 = 0, tickStep: UInt32 = 1, tickCalls = 0
  var onTick: ((Int) -> Void)?
  func read(_ register: VREFBUFRegister) -> UInt32 {
    let value = values[register, default: 0]; trace.append(.read(register, value)); return value
  }
  func write(_ register: VREFBUFRegister, value: UInt32) {
    trace.append(.write(register, value)); values[register] = value
  }
  func getTick() -> UInt32 {
    let value = tick; tick &+= tickStep; tickCalls += 1
    trace.append(.tick(value)); onTick?(tickCalls); return value
  }
}

final class VREFBUFTests: XCTestCase {
  func testVoltageHighImpedanceAndAllTrimmingValuesPreserveOtherBits() {
    let io = VREFBUFTestIO()
    let vref = VREFBUF(registers: io)
    for scale in VREFBUFVoltageScale.allCases {
      io.values[.csr] = .max; io.trace = []; vref.configureVoltageScaling(scale.rawValue)
      XCTAssertEqual(io.trace, [.read(.csr, .max), .write(.csr, 0xFFFFFF8F | scale.rawValue)])
    }
    for mode in VREFBUFHighImpedance.allCases {
      io.values[.csr] = .max; io.trace = []; vref.configureHighImpedance(mode.rawValue)
      XCTAssertEqual(io.trace, [.read(.csr, .max), .write(.csr, 0xFFFFFFFD | mode.rawValue)])
    }
    for trim in UInt32(0)..<64 {
      io.values[.ccr] = 0xA5A5A5A5; io.trace = []; vref.configureTrimming(trim)
      XCTAssertEqual(io.trace, [.read(.ccr, 0xA5A5A5A5), .write(.ccr, 0xA5A5A580 | trim)])
    }
  }

  func testAlreadyReadyStillEnablesAndReadsInitialTick() {
    let io = VREFBUFTestIO(); io.values[.csr] = 0xA500003A
    let vref = VREFBUF(registers: io)
    XCTAssertEqual(vref.enable(getTick: io.getTick), .ok)
    XCTAssertEqual(io.trace, [.read(.csr, 0xA500003A), .write(.csr, 0xA500003B),
      .tick(0), .read(.csr, 0xA500003B)])
  }

  func testStrictTenMillisecondDeadlineWithWrappingTicks() {
    for initial: UInt32 in [0, .max - 5] {
      for readyCall in [1, 2, 11, 12, 13] {
        let io = VREFBUFTestIO(); io.tick = initial
        io.onTick = { [unowned io] count in if count == readyCall { io.values[.csr, default: 0] |= 8 } }
        let vref = VREFBUF(registers: io)
        XCTAssertEqual(vref.enable(getTick: io.getTick), readyCall <= 11 ? .ok : .timeout)
        XCTAssertEqual(io.tickCalls, readyCall <= 11 ? readyCall : 12)
        XCTAssertEqual(io.values[.csr, default: 0] & 1, 1)
      }
    }
  }

  func testTimeoutDoesNotRecheckReadyOrClearEnable() {
    let io = VREFBUFTestIO(); io.tickStep = 11
    io.onTick = { [unowned io] count in if count == 2 { io.values[.csr, default: 0] |= 8 } }
    let vref = VREFBUF(registers: io)
    XCTAssertEqual(vref.enable(getTick: io.getTick), .timeout)
    XCTAssertEqual(io.trace, [.read(.csr, 0), .write(.csr, 1), .tick(0), .read(.csr, 1), .tick(11)])
    XCTAssertEqual(io.values[.csr], 9)
  }

  func testDisableOnlyClearsEnableAndDoesNotPoll() {
    let io = VREFBUFTestIO(); io.values[.csr] = .max
    VREFBUF(registers: io).disable()
    XCTAssertEqual(io.trace, [.read(.csr, .max), .write(.csr, 0xFFFFFFFE)])
    XCTAssertEqual(io.tickCalls, 0)
  }
}
