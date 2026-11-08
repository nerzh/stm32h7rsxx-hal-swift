import CSRAMReference
import STM32H7RSHAL
import XCTest

final class SRAMConstantsTests: XCTestCase {
  func testPinnedEncodings() {
    XCTAssertEqual(SRAMConstants.HAL_SRAM_DMA_XFER_CPLT_CB_ID, CSRAM_Constant(0))
    XCTAssertEqual(SRAMConstants.HAL_SRAM_DMA_XFER_ERR_CB_ID, CSRAM_Constant(1))
    XCTAssertEqual(SRAMConstants.HAL_SRAM_MSP_DEINIT_CB_ID, CSRAM_Constant(2))
    XCTAssertEqual(SRAMConstants.HAL_SRAM_MSP_INIT_CB_ID, CSRAM_Constant(3))
    XCTAssertEqual(SRAMConstants.HAL_SRAM_STATE_BUSY, CSRAM_Constant(4))
    XCTAssertEqual(SRAMConstants.HAL_SRAM_STATE_ERROR, CSRAM_Constant(5))
    XCTAssertEqual(SRAMConstants.HAL_SRAM_STATE_PROTECTED, CSRAM_Constant(6))
    XCTAssertEqual(SRAMConstants.HAL_SRAM_STATE_READY, CSRAM_Constant(7))
    XCTAssertEqual(SRAMConstants.HAL_SRAM_STATE_RESET, CSRAM_Constant(8))
  }
}
