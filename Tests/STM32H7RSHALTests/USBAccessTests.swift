import CUSBReference
import STM32H7RSHAL
import XCTest

final class USBAccessTests: XCTestCase {
  func testPCDAndHCDClearFlagsKeepDistinctAccessSequences() {
    let f = USBFixture()
    f.write(.gintsts, value: 0xA5A5)
    f.recordAccesses = true
    f.pcd.clearFlag(0xFF)
    XCTAssertEqual(f.accesses.map { $0.0 }, [false, true])
    XCTAssertEqual(f.accesses.map { $0.1 }, [0x14, 0x14])
    XCTAssertEqual(f.accesses.map { $0.2 }, [0xA5A5, 0xA5])
    f.accesses.removeAll()
    f.hcd.clearFlag(0xFF)
    XCTAssertEqual(f.accesses.map { $0.0 }, [true])
    XCTAssertEqual(f.accesses.map { $0.1 }, [0x14])
    XCTAssertEqual(f.accesses.map { $0.2 }, [0xFF])
  }
  func testResetAndFlushWaitForHardwareCompletion() {
    let f = USBFixture(highSpeed: false)
    var polls = 0
    f.readTransform = { register, original in
      guard register == .grstctl else { return original }
      polls += 1
      if polls < 3 { return 0 }
      // AHB idle becomes true; reset/flush requests clear on the next read.
      return 0x8000_0000
    }
    f.recordAccesses = true
    XCTAssertEqual(f.driver.initializeCore(f.configuration), .ok)
    XCTAssertEqual(f.accesses.filter { $0.0 }.map { $0.1 }, [0xC, 0x10, 0x38])
    XCTAssertEqual(f.accesses.filter { $0.0 }.map { $0.2 }, [0x40, 0x8000_0001, 0x10000])
    f.accesses.removeAll()
    XCTAssertEqual(f.driver.flushTransmitFIFO(7), .ok)
    XCTAssertEqual(f.accesses.map { $0.0 }, [false, true, false])
    XCTAssertEqual(f.accesses.map { $0.1 }, [0x10, 0x10, 0x10])
    XCTAssertEqual(f.accesses[1].2, 0x1E0)
    f.accesses.removeAll()
    XCTAssertEqual(f.driver.flushReceiveFIFO(), .ok)
    XCTAssertEqual(f.accesses.map { $0.0 }, [false, true, false])
    XCTAssertEqual(f.accesses[1].2, 0x10)
  }
  func testFIFOUsesWordAccessesAndLeavesTailPaddingUntouched() {
    let f = USBFixture()
    for i in 0..<12 { f.buffer[i] = UInt8(i) }
    f.recordAccesses = true
    XCTAssertEqual(f.driver.writePacket(f.buffer + 1, channelOrEndpoint: 2, length: 5, dma: 0), .ok)
    XCTAssertEqual(f.accesses.map { $0.0 }, [true, true])
    XCTAssertEqual(f.accesses.map { $0.1 }, [0x3000, 0x3000])
    XCTAssertEqual(f.accesses.map { $0.2 }, [0x0403_0201, 0x0807_0605])
    f.accesses.removeAll()
    f.readTransform = { _, _ in 0xA1B2_C3D4 }
    XCTAssertEqual(f.driver.readPacket(f.buffer + 1, length: 5), f.buffer + 6)
    XCTAssertEqual(f.accesses.map { $0.0 }, [false, false])
    XCTAssertEqual(f.accesses.map { $0.1 }, [0x1000, 0x1000])
    XCTAssertEqual(
      Array(UnsafeBufferPointer(start: f.buffer, count: 8)),
      [0, 0xD4, 0xC3, 0xB2, 0xA1, 0xD4, 6, 7])
  }
}
