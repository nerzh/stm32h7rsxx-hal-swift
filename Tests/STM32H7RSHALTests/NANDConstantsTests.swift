import CNANDReference
import STM32H7RSHAL
import XCTest

final class NANDConstantsTests: XCTestCase {
  func testPinnedEncodings() {
    XCTAssertEqual(NANDConstants.ADDR_AREA, CNAND_Constant(0))
    XCTAssertEqual(NANDConstants.CMD_AREA, CNAND_Constant(1))
    XCTAssertEqual(NANDConstants.HAL_NAND_IT_CB_ID, CNAND_Constant(2))
    XCTAssertEqual(NANDConstants.HAL_NAND_MSP_DEINIT_CB_ID, CNAND_Constant(3))
    XCTAssertEqual(NANDConstants.HAL_NAND_MSP_INIT_CB_ID, CNAND_Constant(4))
    XCTAssertEqual(NANDConstants.HAL_NAND_STATE_BUSY, CNAND_Constant(5))
    XCTAssertEqual(NANDConstants.HAL_NAND_STATE_ERROR, CNAND_Constant(6))
    XCTAssertEqual(NANDConstants.HAL_NAND_STATE_READY, CNAND_Constant(7))
    XCTAssertEqual(NANDConstants.HAL_NAND_STATE_RESET, CNAND_Constant(8))
    XCTAssertEqual(NANDConstants.NAND_BUSY, CNAND_Constant(9))
    XCTAssertEqual(NANDConstants.NAND_CMD_AREA_A, CNAND_Constant(10))
    XCTAssertEqual(NANDConstants.NAND_CMD_AREA_B, CNAND_Constant(11))
    XCTAssertEqual(NANDConstants.NAND_CMD_AREA_C, CNAND_Constant(12))
    XCTAssertEqual(NANDConstants.NAND_CMD_AREA_TRUE1, CNAND_Constant(13))
    XCTAssertEqual(NANDConstants.NAND_CMD_ERASE0, CNAND_Constant(14))
    XCTAssertEqual(NANDConstants.NAND_CMD_ERASE1, CNAND_Constant(15))
    XCTAssertEqual(NANDConstants.NAND_CMD_LOCK_STATUS, CNAND_Constant(16))
    XCTAssertEqual(NANDConstants.NAND_CMD_READID, CNAND_Constant(17))
    XCTAssertEqual(NANDConstants.NAND_CMD_RESET, CNAND_Constant(18))
    XCTAssertEqual(NANDConstants.NAND_CMD_STATUS, CNAND_Constant(19))
    XCTAssertEqual(NANDConstants.NAND_CMD_WRITE0, CNAND_Constant(20))
    XCTAssertEqual(NANDConstants.NAND_CMD_WRITE_TRUE1, CNAND_Constant(21))
    XCTAssertEqual(NANDConstants.NAND_DEVICE, CNAND_Constant(22))
    XCTAssertEqual(NANDConstants.NAND_ERROR, CNAND_Constant(23))
    XCTAssertEqual(NANDConstants.NAND_INVALID_ADDRESS, CNAND_Constant(24))
    XCTAssertEqual(NANDConstants.NAND_READY, CNAND_Constant(25))
    XCTAssertEqual(NANDConstants.NAND_TIMEOUT_ERROR, CNAND_Constant(26))
    XCTAssertEqual(NANDConstants.NAND_VALID_ADDRESS, CNAND_Constant(27))
    XCTAssertEqual(NANDConstants.NAND_WRITE_TIMEOUT, CNAND_Constant(28))
  }
}
