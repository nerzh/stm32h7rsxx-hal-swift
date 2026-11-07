import XCTest
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// RCC_TypeDef and RCC_BASE from CMSIS stm32h7{r,s}{3,7}xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010. Only addresses are inspected;
// these tests never access memory-mapped device storage on the host.
final class RCCRegisterLayoutTests: XCTestCase {
    func testControlRegistersMatchCMSISIncludingReservedGaps() {
        let actual: [UInt] = [
            rcc.hsicfgr.unsafeAddress, rcc.cier.unsafeAddress, rcc.cifr.unsafeAddress,
            rcc.cicr.unsafeAddress, rcc.bdcr.unsafeAddress, rcc.csr.unsafeAddress,
            rcc.rsr.unsafeAddress, rcc.ahb4enr.unsafeAddress, pwr.cr1.unsafeAddress,
        ]
        XCTAssertEqual(actual, [
            0x5802_4404, 0x5802_4460, 0x5802_4464, 0x5802_4468, 0x5802_4470,
            0x5802_4474, 0x5802_4530, 0x5802_4540, 0x5802_4800,
        ])
    }

    func testFrequencyQueryRegistersMatchAllFourCMSISDeviceLayouts() {
        XCTAssertEqual(rcc.unsafeAddress, 0x5802_4400)
        let registers: [(String, UInt, UInt)] = [
            ("CR", rcc.cr.unsafeAddress, 0x5802_4400),
            ("CFGR", rcc.cfgr.unsafeAddress, 0x5802_4410),
            ("CDCFGR", rcc.cdcfgr.unsafeAddress, 0x5802_4418),
            ("BMCFGR", rcc.bmcfgr.unsafeAddress, 0x5802_441C),
            ("APBCFGR", rcc.apbcfgr.unsafeAddress, 0x5802_4420),
            ("PLLCKSELR", rcc.pllckselr.unsafeAddress, 0x5802_4428),
            ("PLLCFGR", rcc.pllcfgr.unsafeAddress, 0x5802_442C),
            ("PLL1DIVR1", rcc.pll1divr1.unsafeAddress, 0x5802_4430),
            ("PLL1FRACR", rcc.pll1fracr.unsafeAddress, 0x5802_4434),
            ("PLL2DIVR1", rcc.pll2divr1.unsafeAddress, 0x5802_4438),
            ("PLL2FRACR", rcc.pll2fracr.unsafeAddress, 0x5802_443C),
            ("PLL3DIVR1", rcc.pll3divr1.unsafeAddress, 0x5802_4440),
            ("PLL3FRACR", rcc.pll3fracr.unsafeAddress, 0x5802_4444),
            ("PLL1DIVR2", rcc.pll1divr2.unsafeAddress, 0x5802_44C0),
            ("PLL2DIVR2", rcc.pll2divr2.unsafeAddress, 0x5802_44C4),
            ("PLL3DIVR2", rcc.pll3divr2.unsafeAddress, 0x5802_44C8),
        ]
        for (name, actual, expected) in registers {
            XCTAssertEqual(actual, expected, name)
        }
    }
}
