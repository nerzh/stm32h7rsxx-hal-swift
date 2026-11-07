import XCTest
@testable import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// CRC_TypeDef/CRC_BASE agree in all four CMSIS stm32h7{r,s}{3,7}xx.h files at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and both pinned swift-stm32 SVDs.
// Only addresses and generated storage widths are inspected; no host MMIO occurs.
final class CRCRegisterLayoutTests: XCTestCase {
    func testRegistersMatchCMSISIncludingReservedWordAtOffsetTwelve() {
        XCTAssertEqual(crc.unsafeAddress, 0x5802_4C00)
        XCTAssertEqual([
            crc.dr.unsafeAddress, crc.idr.unsafeAddress, crc.cr.unsafeAddress,
            crc.`init`.unsafeAddress, crc.pol.unsafeAddress,
        ], [0x5802_4C00, 0x5802_4C04, 0x5802_4C08, 0x5802_4C10, 0x5802_4C14])
    }

    func testByteAndHalfwordWritesUseDRBaseAndGeneratedWidthsAgree() {
        XCTAssertEqual(crc.dr8.unsafeAddress, crc.dr.unsafeAddress)
        XCTAssertEqual(crc.dr16.unsafeAddress, crc.dr.unsafeAddress)
        XCTAssertEqual(MemoryLayout<CRC.DR.Raw.Storage>.size, 4)
        XCTAssertEqual(MemoryLayout<CRC.DR8.Raw.Storage>.size, 1)
        XCTAssertEqual(MemoryLayout<CRC.DR16.Raw.Storage>.size, 2)
        XCTAssertEqual(MemoryLayout<CRC.IDR.Raw.Storage>.size, 4)
    }
}
