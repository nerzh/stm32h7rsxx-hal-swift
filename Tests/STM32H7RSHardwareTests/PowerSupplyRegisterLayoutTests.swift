import XCTest
import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class PowerSupplyRegisterLayoutTests: XCTestCase {
    // CMSIS stm32h7{s,r}{3,7}xx.h at 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
    func testSupplyAndVoltageRegistersMatchCMSIS() {
        XCTAssertEqual(pwr.unsafeAddress, 0x5802_4800)
        XCTAssertEqual(pwr.sr1.unsafeAddress, 0x5802_4804)
        XCTAssertEqual(pwr.csr2.unsafeAddress, 0x5802_480C)
        XCTAssertEqual(pwr.csr4.unsafeAddress, 0x5802_4814)
    }

    func testFlashAccessControlAddressMatchesCMSIS() {
        XCTAssertEqual(flash.unsafeAddress, 0x5200_2000)
        XCTAssertEqual(flash.acr.unsafeAddress, 0x5200_2000)
    }
}
