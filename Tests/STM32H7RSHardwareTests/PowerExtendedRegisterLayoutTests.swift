import XCTest
@testable import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// Addresses agree with all four CMSIS stm32h7{r,s}{3,7}xx.h headers at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and both pinned PWR SVDs.
final class PowerExtendedRegisterLayoutTests: XCTestCase {
    func testPowerExtendedAddressesMatchCMSISReservedGaps() {
        XCTAssertEqual(pwr.unsafeAddress, 0x5802_4800)
        XCTAssertEqual([
            pwr.cr1.unsafeAddress, pwr.sr1.unsafeAddress, pwr.csr1.unsafeAddress,
            pwr.csr2.unsafeAddress, pwr.csr3.unsafeAddress, pwr.csr4.unsafeAddress,
            pwr.wkupcr.unsafeAddress, pwr.wkupfr.unsafeAddress, pwr.wkupepr.unsafeAddress,
            pwr.ucpdr.unsafeAddress, pwr.apcr.unsafeAddress, pwr.pucrn.unsafeAddress,
            pwr.pdcrn.unsafeAddress, pwr.pucro.unsafeAddress, pwr.pdcro.unsafeAddress, pwr.pdcrp.unsafeAddress,
        ], [0x5802_4800, 0x5802_4804, 0x5802_4808, 0x5802_480C, 0x5802_4810, 0x5802_4814,
            0x5802_4820, 0x5802_4824, 0x5802_4828, 0x5802_482C, 0x5802_4830, 0x5802_4834,
            0x5802_4838, 0x5802_483C, 0x5802_4840, 0x5802_4844])
    }

    func testAVDAndWakeUpUseCorrectedEXTIAddresses() {
        XCTAssertEqual([
            CMSISEXTI.rtsr1.unsafeAddress, CMSISEXTI.ftsr1.unsafeAddress, CMSISEXTI.swier1.unsafeAddress,
            CMSISEXTI.imr1.unsafeAddress, CMSISEXTI.emr1.unsafeAddress, CMSISEXTI.pr1.unsafeAddress,
            CMSISEXTI.imr2.unsafeAddress,
        ], [0x5800_0000, 0x5800_0004, 0x5800_0008, 0x5800_0080, 0x5800_0084, 0x5800_0088, 0x5800_0090])
    }
}
