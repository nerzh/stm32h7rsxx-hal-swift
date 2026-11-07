import XCTest
@testable import STM32H7RSHAL

private enum FMCMappingAccess: Equatable { case read, write(UInt32) }
private final class FMCMappingTestIO: FMCBankMappingRegisterIO {
  var value: UInt32
  var trace: [FMCMappingAccess] = []
  init(value: UInt32) { self.value = value }
  func read(_ register: FMCBankMappingRegister) -> UInt32 { trace.append(.read); return value }
  func write(_ register: FMCBankMappingRegister, value: UInt32) { trace.append(.write(value)); self.value = value }
}

final class FMCBankMappingTests: XCTestCase {
  func testSetterClearsBothMappingBitsAndPreservesEveryOtherBit() {
    for mode in FMCBankSwapMode.allCases {
      for initial: UInt32 in [0, .max, 0xA5A5_5A5A, 0x0100_0000, 0x0200_0000, 0x0300_0000] {
        let io = FMCMappingTestIO(value: initial)
        let driver = FMCBankMapping(registers: io)
        driver.setBankSwapConfiguration(mode)
        let expected = (initial & 0xFCFF_FFFF) | mode.rawValue
        XCTAssertEqual(io.trace, [.read, .write(expected)])
        XCTAssertEqual(io.value, expected)
      }
    }
  }

  func testGetterReturnsBothRawBitsIncludingReservedEncodingsWithOneRead() {
    for mapping: UInt32 in 0...3 {
      let io = FMCMappingTestIO(value: 0xACDE_FF81 | (mapping << 24))
      XCTAssertEqual(FMCBankMapping(registers: io).getBankSwapConfiguration(), mapping << 24)
      XCTAssertEqual(io.trace, [.read])
      XCTAssertEqual(io.value, 0xACDE_FF81 | (mapping << 24))
    }
  }

  func testRepeatedSettersUseFreshRegisterContents() {
    let io = FMCMappingTestIO(value: .max), driver = FMCBankMapping(registers: FMCMappingTestIO(value: 0))
    driver.setBankSwapConfiguration(0x0100_0000)
    let shared = FMCBankMapping(registers: io)
    shared.setBankSwapConfiguration(0)
    XCTAssertEqual(io.value, 0xFCFF_FFFF)
    io.value = 0xAA00_1234
    shared.setBankSwapConfiguration(0x0100_0000)
    XCTAssertEqual(io.value, 0xA900_1234)
    XCTAssertEqual(io.trace, [.read, .write(0xFCFF_FFFF), .read, .write(0xA900_1234)])
    XCTAssertEqual(driver.getBankSwapConfiguration(), 0x0100_0000)
  }
}
