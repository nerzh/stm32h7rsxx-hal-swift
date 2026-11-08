import CSDRAMReference
import STM32H7RSHAL
import XCTest

final class SDRAMConstantsTests: XCTestCase {
  func testPinnedEncodings() {
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_DMA_XFER_CPLT_CB_ID, CSDRAM_Constant(0))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_DMA_XFER_ERR_CB_ID, CSDRAM_Constant(1))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_MSP_DEINIT_CB_ID, CSDRAM_Constant(2))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_MSP_INIT_CB_ID, CSDRAM_Constant(3))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_REFRESH_ERR_CB_ID, CSDRAM_Constant(4))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_STATE_BUSY, CSDRAM_Constant(5))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_STATE_ERROR, CSDRAM_Constant(6))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_STATE_PRECHARGED, CSDRAM_Constant(7))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_STATE_READY, CSDRAM_Constant(8))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_STATE_RESET, CSDRAM_Constant(9))
    XCTAssertEqual(SDRAMConstants.HAL_SDRAM_STATE_WRITE_PROTECTED, CSDRAM_Constant(10))
  }
}
