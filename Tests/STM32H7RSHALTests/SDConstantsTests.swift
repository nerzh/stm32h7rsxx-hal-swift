import CSDReference
import STM32H7RSHAL
import XCTest

final class SDConstantsTests: XCTestCase {
  func testPinnedConstants() {
    XCTAssertEqual(SDConstants.BLOCKSIZE, CSD_Constant(0), "BLOCKSIZE")
    XCTAssertEqual(SDConstants.CARD_HIGH_SPEED, CSD_Constant(1), "CARD_HIGH_SPEED")
    XCTAssertEqual(SDConstants.CARD_NORMAL_SPEED, CSD_Constant(2), "CARD_NORMAL_SPEED")
    XCTAssertEqual(SDConstants.CARD_SDHC_SDXC, CSD_Constant(3), "CARD_SDHC_SDXC")
    XCTAssertEqual(SDConstants.CARD_SDSC, CSD_Constant(4), "CARD_SDSC")
    XCTAssertEqual(SDConstants.CARD_SECURED, CSD_Constant(5), "CARD_SECURED")
    XCTAssertEqual(SDConstants.CARD_ULTRA_HIGH_SPEED, CSD_Constant(6), "CARD_ULTRA_HIGH_SPEED")
    XCTAssertEqual(SDConstants.CARD_V1_X, CSD_Constant(7), "CARD_V1_X")
    XCTAssertEqual(SDConstants.CARD_V2_X, CSD_Constant(8), "CARD_V2_X")
    XCTAssertEqual(SDConstants.HAL_SD_ABORT_CB_ID, CSD_Constant(9), "HAL_SD_ABORT_CB_ID")
    XCTAssertEqual(
      SDConstants.HAL_SD_CARD_DISCONNECTED, CSD_Constant(10), "HAL_SD_CARD_DISCONNECTED")
    XCTAssertEqual(SDConstants.HAL_SD_CARD_ERROR, CSD_Constant(11), "HAL_SD_CARD_ERROR")
    XCTAssertEqual(
      SDConstants.HAL_SD_CARD_IDENTIFICATION, CSD_Constant(12), "HAL_SD_CARD_IDENTIFICATION")
    XCTAssertEqual(SDConstants.HAL_SD_CARD_PROGRAMMING, CSD_Constant(13), "HAL_SD_CARD_PROGRAMMING")
    XCTAssertEqual(SDConstants.HAL_SD_CARD_READY, CSD_Constant(14), "HAL_SD_CARD_READY")
    XCTAssertEqual(SDConstants.HAL_SD_CARD_RECEIVING, CSD_Constant(15), "HAL_SD_CARD_RECEIVING")
    XCTAssertEqual(SDConstants.HAL_SD_CARD_SENDING, CSD_Constant(16), "HAL_SD_CARD_SENDING")
    XCTAssertEqual(SDConstants.HAL_SD_CARD_STANDBY, CSD_Constant(17), "HAL_SD_CARD_STANDBY")
    XCTAssertEqual(SDConstants.HAL_SD_CARD_TRANSFER, CSD_Constant(18), "HAL_SD_CARD_TRANSFER")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_ADDR_MISALIGNED, CSD_Constant(19), "HAL_SD_ERROR_ADDR_MISALIGNED")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_ADDR_OUT_OF_RANGE, CSD_Constant(20), "HAL_SD_ERROR_ADDR_OUT_OF_RANGE"
    )
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_AKE_SEQ_ERR, CSD_Constant(21), "HAL_SD_ERROR_AKE_SEQ_ERR")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_BAD_ERASE_PARAM, CSD_Constant(22), "HAL_SD_ERROR_BAD_ERASE_PARAM")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_BLOCK_LEN_ERR, CSD_Constant(23), "HAL_SD_ERROR_BLOCK_LEN_ERR")
    XCTAssertEqual(SDConstants.HAL_SD_ERROR_BUSY, CSD_Constant(24), "HAL_SD_ERROR_BUSY")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_CARD_ECC_DISABLED, CSD_Constant(25), "HAL_SD_ERROR_CARD_ECC_DISABLED"
    )
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_CARD_ECC_FAILED, CSD_Constant(26), "HAL_SD_ERROR_CARD_ECC_FAILED")
    XCTAssertEqual(SDConstants.HAL_SD_ERROR_CB_ID, CSD_Constant(27), "HAL_SD_ERROR_CB_ID")
    XCTAssertEqual(SDConstants.HAL_SD_ERROR_CC_ERR, CSD_Constant(28), "HAL_SD_ERROR_CC_ERR")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_CID_CSD_OVERWRITE, CSD_Constant(29), "HAL_SD_ERROR_CID_CSD_OVERWRITE"
    )
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_CMD_CRC_FAIL, CSD_Constant(30), "HAL_SD_ERROR_CMD_CRC_FAIL")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_CMD_RSP_TIMEOUT, CSD_Constant(31), "HAL_SD_ERROR_CMD_RSP_TIMEOUT")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_COM_CRC_FAILED, CSD_Constant(32), "HAL_SD_ERROR_COM_CRC_FAILED")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_DATA_CRC_FAIL, CSD_Constant(33), "HAL_SD_ERROR_DATA_CRC_FAIL")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_DATA_TIMEOUT, CSD_Constant(34), "HAL_SD_ERROR_DATA_TIMEOUT")
    XCTAssertEqual(SDConstants.HAL_SD_ERROR_DMA, CSD_Constant(35), "HAL_SD_ERROR_DMA")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_ERASE_RESET, CSD_Constant(36), "HAL_SD_ERROR_ERASE_RESET")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_ERASE_SEQ_ERR, CSD_Constant(37), "HAL_SD_ERROR_ERASE_SEQ_ERR")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_GENERAL_UNKNOWN_ERR, CSD_Constant(38),
      "HAL_SD_ERROR_GENERAL_UNKNOWN_ERR")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_ILLEGAL_CMD, CSD_Constant(39), "HAL_SD_ERROR_ILLEGAL_CMD")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_INVALID_CALLBACK, CSD_Constant(40), "HAL_SD_ERROR_INVALID_CALLBACK")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_INVALID_VOLTRANGE, CSD_Constant(41), "HAL_SD_ERROR_INVALID_VOLTRANGE"
    )
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_LOCK_UNLOCK_FAILED, CSD_Constant(42),
      "HAL_SD_ERROR_LOCK_UNLOCK_FAILED")
    XCTAssertEqual(SDConstants.HAL_SD_ERROR_NONE, CSD_Constant(43), "HAL_SD_ERROR_NONE")
    XCTAssertEqual(SDConstants.HAL_SD_ERROR_PARAM, CSD_Constant(44), "HAL_SD_ERROR_PARAM")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_REQUEST_NOT_APPLICABLE, CSD_Constant(45),
      "HAL_SD_ERROR_REQUEST_NOT_APPLICABLE")
    XCTAssertEqual(SDConstants.HAL_SD_ERROR_RX_OVERRUN, CSD_Constant(46), "HAL_SD_ERROR_RX_OVERRUN")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_STREAM_READ_UNDERRUN, CSD_Constant(47),
      "HAL_SD_ERROR_STREAM_READ_UNDERRUN")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_STREAM_WRITE_OVERRUN, CSD_Constant(48),
      "HAL_SD_ERROR_STREAM_WRITE_OVERRUN")
    XCTAssertEqual(SDConstants.HAL_SD_ERROR_TIMEOUT, CSD_Constant(49), "HAL_SD_ERROR_TIMEOUT")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_TX_UNDERRUN, CSD_Constant(50), "HAL_SD_ERROR_TX_UNDERRUN")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_UNSUPPORTED_FEATURE, CSD_Constant(51),
      "HAL_SD_ERROR_UNSUPPORTED_FEATURE")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_WP_ERASE_SKIP, CSD_Constant(52), "HAL_SD_ERROR_WP_ERASE_SKIP")
    XCTAssertEqual(
      SDConstants.HAL_SD_ERROR_WRITE_PROT_VIOLATION, CSD_Constant(53),
      "HAL_SD_ERROR_WRITE_PROT_VIOLATION")
    XCTAssertEqual(SDConstants.HAL_SD_MSP_DEINIT_CB_ID, CSD_Constant(54), "HAL_SD_MSP_DEINIT_CB_ID")
    XCTAssertEqual(SDConstants.HAL_SD_MSP_INIT_CB_ID, CSD_Constant(55), "HAL_SD_MSP_INIT_CB_ID")
    XCTAssertEqual(
      SDConstants.HAL_SD_READ_DMA_LNKLST_BUF_CPLT_CB_ID, CSD_Constant(56),
      "HAL_SD_READ_DMA_LNKLST_BUF_CPLT_CB_ID")
    XCTAssertEqual(SDConstants.HAL_SD_RX_CPLT_CB_ID, CSD_Constant(57), "HAL_SD_RX_CPLT_CB_ID")
    XCTAssertEqual(SDConstants.HAL_SD_STATE_BUSY, CSD_Constant(58), "HAL_SD_STATE_BUSY")
    XCTAssertEqual(SDConstants.HAL_SD_STATE_ERROR, CSD_Constant(59), "HAL_SD_STATE_ERROR")
    XCTAssertEqual(
      SDConstants.HAL_SD_STATE_PROGRAMMING, CSD_Constant(60), "HAL_SD_STATE_PROGRAMMING")
    XCTAssertEqual(SDConstants.HAL_SD_STATE_READY, CSD_Constant(61), "HAL_SD_STATE_READY")
    XCTAssertEqual(SDConstants.HAL_SD_STATE_RECEIVING, CSD_Constant(62), "HAL_SD_STATE_RECEIVING")
    XCTAssertEqual(SDConstants.HAL_SD_STATE_RESET, CSD_Constant(63), "HAL_SD_STATE_RESET")
    XCTAssertEqual(SDConstants.HAL_SD_STATE_TIMEOUT, CSD_Constant(64), "HAL_SD_STATE_TIMEOUT")
    XCTAssertEqual(SDConstants.HAL_SD_STATE_TRANSFER, CSD_Constant(65), "HAL_SD_STATE_TRANSFER")
    XCTAssertEqual(SDConstants.HAL_SD_TX_CPLT_CB_ID, CSD_Constant(66), "HAL_SD_TX_CPLT_CB_ID")
    XCTAssertEqual(
      SDConstants.HAL_SD_WRITE_DMA_LNKLST_BUF_CPLT_CB_ID, CSD_Constant(67),
      "HAL_SD_WRITE_DMA_LNKLST_BUF_CPLT_CB_ID")
    XCTAssertEqual(SDConstants.SD_CONTEXT_DMA, CSD_Constant(68), "SD_CONTEXT_DMA")
    XCTAssertEqual(SDConstants.SD_CONTEXT_IT, CSD_Constant(69), "SD_CONTEXT_IT")
    XCTAssertEqual(SDConstants.SD_CONTEXT_NONE, CSD_Constant(70), "SD_CONTEXT_NONE")
    XCTAssertEqual(
      SDConstants.SD_CONTEXT_READ_MULTIPLE_BLOCK, CSD_Constant(71), "SD_CONTEXT_READ_MULTIPLE_BLOCK"
    )
    XCTAssertEqual(
      SDConstants.SD_CONTEXT_READ_SINGLE_BLOCK, CSD_Constant(72), "SD_CONTEXT_READ_SINGLE_BLOCK")
    XCTAssertEqual(
      SDConstants.SD_CONTEXT_WRITE_MULTIPLE_BLOCK, CSD_Constant(73),
      "SD_CONTEXT_WRITE_MULTIPLE_BLOCK")
    XCTAssertEqual(
      SDConstants.SD_CONTEXT_WRITE_SINGLE_BLOCK, CSD_Constant(74), "SD_CONTEXT_WRITE_SINGLE_BLOCK")
  }
}
