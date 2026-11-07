import XCTest
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class RCCExtendedRegisterLayoutTests: XCTestCase {
    func testKernelClockAndProtectionOffsetsMatchCMSIS() {
        // RCC_TypeDef at pinned CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
        XCTAssertEqual([rcc.ccipr1.unsafeAddress, rcc.ccipr2.unsafeAddress,
                        rcc.ccipr3.unsafeAddress, rcc.ccipr4.unsafeAddress, rcc.ckprotr.unsafeAddress],
                       [0x5802_444C, 0x5802_4450, 0x5802_4454, 0x5802_4458, 0x5802_4500])
    }
}
