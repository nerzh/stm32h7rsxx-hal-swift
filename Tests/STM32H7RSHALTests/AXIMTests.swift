import XCTest
@testable import STM32H7RSHAL

private enum AXIMAccess: Equatable {
  case asibRead(Int, AXIMASIBRegister), asibWrite(Int, AXIMASIBRegister, UInt32)
  case amibRead(Int, AXIMAMIBRegister), amibWrite(Int, AXIMAMIBRegister, UInt32)
}
private final class AXIMTestBus {
  var asibs: [Int: [AXIMASIBRegister: UInt32]] = [:]
  var amibs: [Int: [AXIMAMIBRegister: UInt32]] = [:]
  var trace: [AXIMAccess] = []
  init() {
    for port in 1...11 {
      asibs[port] = Dictionary(uniqueKeysWithValues: AXIMASIBRegister.allCases.map { ($0, 0xFFFF_FFFF) })
    }
    for port in 1...10 {
      amibs[port] = Dictionary(uniqueKeysWithValues: AXIMAMIBRegister.allCases.map { ($0, 0xFFFF_FFFF) })
    }
  }
}
private struct AXIMASIBTestIO: AXIMASIBRegisterIO {
  let bus: AXIMTestBus
  let port: Int
  func read(_ register: AXIMASIBRegister) -> UInt32 {
    bus.trace.append(.asibRead(port, register)); return bus.asibs[port]![register]!
  }
  func write(_ register: AXIMASIBRegister, value: UInt32) {
    bus.trace.append(.asibWrite(port, register, value)); bus.asibs[port]![register] = value
  }
}
private struct AXIMAMIBTestIO: AXIMAMIBRegisterIO {
  let bus: AXIMTestBus
  let port: Int
  func read(_ register: AXIMAMIBRegister) -> UInt32 {
    bus.trace.append(.amibRead(port, register)); return bus.amibs[port]![register]!
  }
  func write(_ register: AXIMAMIBRegister, value: UInt32) {
    bus.trace.append(.amibWrite(port, register, value)); bus.amibs[port]![register] = value
  }
}

final class AXIMTests: XCTestCase {
  func testASIBPackingReplacesWholeRegisterOnAllElevenInstances() {
    for port in 1...11 {
      let bus = AXIMTestBus(), otherPorts = Set(1...11).subtracting([port])
      let driver = AXIMASIB(registers: AXIMASIBTestIO(bus: bus, port: port))
      driver.disablePacking()
      XCTAssertEqual(bus.asibs[port]![.fnmod2], 1)
      driver.enablePacking()
      XCTAssertEqual(bus.asibs[port]![.fnmod2], 0)
      XCTAssertEqual(bus.trace, [.asibWrite(port, .fnmod2, 1), .asibWrite(port, .fnmod2, 0)])
      for register in [AXIMASIBRegister.readQoS, .writeQoS, .fnmod] {
        XCTAssertEqual(bus.asibs[port]![register], .max)
      }
      for other in otherPorts { XCTAssertEqual(bus.asibs[other]![.fnmod2], .max) }
    }
  }

  func testASIBIssuingAllBitCombinationsAreFullWrites() {
    for port in 1...11 {
      for read in AXIMReadIssuing.allCases {
        for write in AXIMWriteIssuing.allCases {
          let bus = AXIMTestBus()
          let driver = AXIMASIB(registers: AXIMASIBTestIO(bus: bus, port: port))
          driver.configureIssuing(read: read, write: write)
          let expected = read.rawValue | write.rawValue
          XCTAssertEqual(bus.trace, [.asibWrite(port, .fnmod, expected)])
          XCTAssertEqual(bus.asibs[port]![.fnmod], expected)
          XCTAssertEqual(bus.asibs[port]![.fnmod2], .max)
          XCTAssertEqual(bus.asibs[port]![.readQoS], .max); XCTAssertEqual(bus.asibs[port]![.writeQoS], .max)
        }
      }
    }
  }

  func testASIBReadAndWriteQoSAllPrioritiesDoNotRetainReservedBits() {
    for port in 1...11 {
      for priority: UInt32 in 0...15 {
        let bus = AXIMTestBus()
        let driver = AXIMASIB(registers: AXIMASIBTestIO(bus: bus, port: port))
        driver.configureReadQoS(priority)
        XCTAssertEqual(bus.asibs[port]![.readQoS], priority)
        XCTAssertEqual(bus.asibs[port]![.writeQoS], .max)
        driver.configureWriteQoS(15 - priority)
        XCTAssertEqual(bus.asibs[port]![.writeQoS], 15 - priority)
        XCTAssertEqual(bus.trace, [.asibWrite(port, .readQoS, priority), .asibWrite(port, .writeQoS, 15 - priority)])
        XCTAssertEqual(bus.asibs[port]![.fnmod], .max); XCTAssertEqual(bus.asibs[port]![.fnmod2], .max)
      }
    }
  }

  func testAMIBPackingAndLongBurstReplaceIndependentRegistersOnAllTenInstances() {
    for port in 1...10 {
      let bus = AXIMTestBus(), otherPorts = Set(1...10).subtracting([port])
      let driver = AXIMAMIB(registers: AXIMAMIBTestIO(bus: bus, port: port))
      driver.enablePacking(); driver.enableLongBurst()
      XCTAssertEqual(bus.amibs[port]![.fnmod2], 0); XCTAssertEqual(bus.amibs[port]![.fnmodLongBurst], 1)
      driver.disablePacking(); driver.disableLongBurst()
      XCTAssertEqual(bus.amibs[port]![.fnmod2], 1); XCTAssertEqual(bus.amibs[port]![.fnmodLongBurst], 0)
      XCTAssertEqual(bus.trace, [.amibWrite(port, .fnmod2, 0), .amibWrite(port, .fnmodLongBurst, 1),
        .amibWrite(port, .fnmod2, 1), .amibWrite(port, .fnmodLongBurst, 0)])
      XCTAssertEqual(bus.amibs[port]![.fnmod], .max); XCTAssertEqual(bus.amibs[port]![.fnmodBusMatrixIssuing], .max)
      for other in otherPorts {
        XCTAssertEqual(bus.amibs[other]![.fnmod2], .max); XCTAssertEqual(bus.amibs[other]![.fnmodLongBurst], .max)
      }
    }
  }

  func testAMIBNormalAndBusMatrixIssuingUseDistinctRegistersAndAllBitCombinations() {
    for port in 1...10 {
      for read in AXIMReadIssuing.allCases {
        for write in AXIMWriteIssuing.allCases {
          let bus = AXIMTestBus()
          let driver = AXIMAMIB(registers: AXIMAMIBTestIO(bus: bus, port: port))
          driver.configureIssuing(read: read, write: write)
          let expected = read.rawValue | write.rawValue
          XCTAssertEqual(bus.amibs[port]![.fnmod], expected)
          XCTAssertEqual(bus.amibs[port]![.fnmodBusMatrixIssuing], .max)
          driver.configureBusMatrixIssuing(read: read, write: write)
          XCTAssertEqual(bus.amibs[port]![.fnmodBusMatrixIssuing], expected)
          XCTAssertEqual(bus.trace, [.amibWrite(port, .fnmod, expected), .amibWrite(port, .fnmodBusMatrixIssuing, expected)])
          XCTAssertEqual(bus.amibs[port]![.fnmod2], .max); XCTAssertEqual(bus.amibs[port]![.fnmodLongBurst], .max)
        }
      }
    }
  }

  func testIssuingEncodingsMatchASIBAMIBAndBusMatrixCConstants() {
    XCTAssertEqual(AXIMReadIssuing.normal.rawValue, 0); XCTAssertEqual(AXIMReadIssuing.forceOne.rawValue, 1)
    XCTAssertEqual(AXIMWriteIssuing.normal.rawValue, 0); XCTAssertEqual(AXIMWriteIssuing.forceOne.rawValue, 2)
    XCTAssertNil(AXIMReadIssuing(rawValue: 2)); XCTAssertNil(AXIMWriteIssuing(rawValue: 1))
  }
}
