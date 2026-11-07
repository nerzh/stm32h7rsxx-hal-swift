import XCTest
import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class RCCClockRecoveryRegisterLayoutTests: XCTestCase {
    func testCRSAndResetAddressesMatchPinnedCMSIS() {
        // CMSIS commit 7e6e213ddc397c76622a0aca2f623ccc3b34c010, all four
        // stm32h7{r,s}{3,7}xx.h variants; generated registers from swift-stm32.
        XCTAssertEqual(crs.unsafeAddress, 0x4000_8400)
        XCTAssertEqual([crs.cr.unsafeAddress, crs.cfgr.unsafeAddress,
                        crs.isr.unsafeAddress, crs.icr.unsafeAddress],
                       [0x4000_8400, 0x4000_8404, 0x4000_8408, 0x4000_840C])
        XCTAssertEqual(rcc.apb1rstr2.unsafeAddress, 0x5802_4494)
    }
}
