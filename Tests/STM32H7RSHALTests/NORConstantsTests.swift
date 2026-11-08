import CNORReference
import STM32H7RSHAL
import XCTest

final class NORConstantsTests: XCTestCase {
  func testPinnedEncodings() {
    XCTAssertEqual(NORConstants.CFI1_ADDRESS, CNOR_Constant(0))
    XCTAssertEqual(NORConstants.CFI2_ADDRESS, CNOR_Constant(1))
    XCTAssertEqual(NORConstants.CFI3_ADDRESS, CNOR_Constant(2))
    XCTAssertEqual(NORConstants.CFI4_ADDRESS, CNOR_Constant(3))
    XCTAssertEqual(NORConstants.DEVICE_CODE1_ADDR, CNOR_Constant(4))
    XCTAssertEqual(NORConstants.DEVICE_CODE2_ADDR, CNOR_Constant(5))
    XCTAssertEqual(NORConstants.DEVICE_CODE3_ADDR, CNOR_Constant(6))
    XCTAssertEqual(NORConstants.HAL_NOR_MSP_DEINIT_CB_ID, CNOR_Constant(7))
    XCTAssertEqual(NORConstants.HAL_NOR_MSP_INIT_CB_ID, CNOR_Constant(8))
    XCTAssertEqual(NORConstants.HAL_NOR_STATE_BUSY, CNOR_Constant(9))
    XCTAssertEqual(NORConstants.HAL_NOR_STATE_ERROR, CNOR_Constant(10))
    XCTAssertEqual(NORConstants.HAL_NOR_STATE_PROTECTED, CNOR_Constant(11))
    XCTAssertEqual(NORConstants.HAL_NOR_STATE_READY, CNOR_Constant(12))
    XCTAssertEqual(NORConstants.HAL_NOR_STATE_RESET, CNOR_Constant(13))
    XCTAssertEqual(NORConstants.HAL_NOR_STATUS_ERROR, CNOR_Constant(14))
    XCTAssertEqual(NORConstants.HAL_NOR_STATUS_ONGOING, CNOR_Constant(15))
    XCTAssertEqual(NORConstants.HAL_NOR_STATUS_SUCCESS, CNOR_Constant(16))
    XCTAssertEqual(NORConstants.HAL_NOR_STATUS_TIMEOUT, CNOR_Constant(17))
    XCTAssertEqual(NORConstants.MC_ADDRESS, CNOR_Constant(18))
    XCTAssertEqual(NORConstants.NOR_MEMORY_16B, CNOR_Constant(19))
    XCTAssertEqual(NORConstants.NOR_MEMORY_8B, CNOR_Constant(20))
    XCTAssertEqual(NORConstants.NOR_MEMORY_ADRESS1, CNOR_Constant(21))
    XCTAssertEqual(NORConstants.NOR_MEMORY_ADRESS2, CNOR_Constant(22))
    XCTAssertEqual(NORConstants.NOR_MEMORY_ADRESS3, CNOR_Constant(23))
    XCTAssertEqual(NORConstants.NOR_MEMORY_ADRESS4, CNOR_Constant(24))
    XCTAssertEqual(NORConstants.NOR_TMEOUT, CNOR_Constant(25))
  }
}
