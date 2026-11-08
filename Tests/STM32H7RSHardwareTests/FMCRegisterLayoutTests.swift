import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class FMCRegisterLayoutTests: XCTestCase {
  func testCMSISBankOffsetsAndSVDPeripheralBase() {
    let io = STM32FMCRegisters()
    for index: UInt32 in 0..<8 {
      XCTAssertEqual(io.address(of: .btcr(index)), 0x5200_4000 + index * 4)
    }
    for index: UInt32 in 0..<7 {
      XCTAssertEqual(io.address(of: .bwtr(index)), 0x5200_4104 + index * 4)
    }
    for (register, address): (FMCRegister, UInt32) in [
      (.pcr, 0x5200_4080), (.sr, 0x5200_4084), (.pmem, 0x5200_4088),
      (.patt, 0x5200_408C), (.eccr, 0x5200_4094), (.sdcr(0), 0x5200_4140),
      (.sdcr(1), 0x5200_4144), (.sdtr(0), 0x5200_4148), (.sdtr(1), 0x5200_414C),
      (.sdcmr, 0x5200_4150), (.sdrtr, 0x5200_4154), (.sdsr, 0x5200_4158),
    ] {
      XCTAssertEqual(io.address(of: register), address)
    }
  }
}
