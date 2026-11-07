import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// Expected addresses come from CMSIS stm32h7{s,r}{3,7}xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010. These tests inspect address
// values only: they never read or write memory-mapped hardware.
final class RegisterLayoutTests: XCTestCase {
    func testEXTIRegistersPreserveCMSISReservedGaps() {
        XCTAssertEqual(exti.unsafeAddress, 0x5800_0000)
        let actual: [UInt] = [
            CMSISEXTI.rtsr1.unsafeAddress,
            CMSISEXTI.ftsr1.unsafeAddress,
            CMSISEXTI.swier1.unsafeAddress,
            CMSISEXTI.rtsr2.unsafeAddress,
            CMSISEXTI.ftsr2.unsafeAddress,
            CMSISEXTI.swier2.unsafeAddress,
            CMSISEXTI.imr1.unsafeAddress,
            CMSISEXTI.emr1.unsafeAddress,
            CMSISEXTI.pr1.unsafeAddress,
            CMSISEXTI.imr2.unsafeAddress,
            CMSISEXTI.emr2.unsafeAddress,
            CMSISEXTI.pr2.unsafeAddress,
            CMSISEXTI.imr3.unsafeAddress,
            CMSISEXTI.emr3.unsafeAddress,
        ]
        let expected: [UInt] = [
            0x5800_0000, 0x5800_0004, 0x5800_0008,
            0x5800_0020, 0x5800_0024, 0x5800_0028,
            0x5800_0080, 0x5800_0084, 0x5800_0088,
            0x5800_0090, 0x5800_0094, 0x5800_0098,
            0x5800_00A0, 0x5800_00A4,
        ]
        XCTAssertEqual(actual, expected)
    }

    func testGPIOPortAddressesAndSelectionIndicesMatchCMSIS() {
        let ports: [(GPIOPort, UInt, UInt, UInt32)] = [
            (.a, gpioa.unsafeAddress, 0x5802_0000, 0),
            (.b, gpiob.unsafeAddress, 0x5802_0400, 1),
            (.c, gpioc.unsafeAddress, 0x5802_0800, 2),
            (.d, gpiod.unsafeAddress, 0x5802_0C00, 3),
            (.e, gpioe.unsafeAddress, 0x5802_1000, 4),
            (.f, gpiof.unsafeAddress, 0x5802_1400, 5),
            (.g, gpiog.unsafeAddress, 0x5802_1800, 6),
            (.h, gpioh.unsafeAddress, 0x5802_1C00, 7),
            (.m, gpiom.unsafeAddress, 0x5802_3000, 12),
            (.n, gpion.unsafeAddress, 0x5802_3400, 13),
            (.o, gpioo.unsafeAddress, 0x5802_3800, 14),
            (.p, gpiop.unsafeAddress, 0x5802_3C00, 15),
        ]
        for (port, actualAddress, expectedAddress, expectedIndex) in ports {
            XCTAssertEqual(actualAddress, expectedAddress)
            XCTAssertEqual(port.rawValue, expectedIndex)
            XCTAssertEqual(UInt32(actualAddress) & ~UInt32(0x5802_0000), expectedIndex << 10)
        }
    }

    func testCommonGPIOLayoutMatchesCMSISTypeDef() {
        let gpio = GPIOA(unsafeAddress: 0x5802_0000)
        let actual: [UInt] = [
            gpio.moder.unsafeAddress, gpio.otyper.unsafeAddress,
            gpio.ospeedr.unsafeAddress, gpio.pupdr.unsafeAddress,
            gpio.idr.unsafeAddress, gpio.odr.unsafeAddress,
            gpio.bsrr.unsafeAddress, gpio.lckr.unsafeAddress,
            gpio.afrl.unsafeAddress, gpio.afrh.unsafeAddress,
            gpio.brr.unsafeAddress,
        ]
        let expected: [UInt] = [
            0x5802_0000, 0x5802_0004, 0x5802_0008, 0x5802_000C,
            0x5802_0010, 0x5802_0014, 0x5802_0018, 0x5802_001C,
            0x5802_0020, 0x5802_0024, 0x5802_0028,
        ]
        XCTAssertEqual(actual, expected)
    }

    func testSBSExternalInterruptArrayMatchesCMSIS() {
        XCTAssertEqual(sbs.unsafeAddress, 0x5800_0400)
        let actual: [UInt] = [
            sbs.exticr1.unsafeAddress, sbs.exticr2.unsafeAddress,
            sbs.exticr3.unsafeAddress, sbs.exticr4.unsafeAddress,
        ]
        let expected: [UInt] = [0x5800_0530, 0x5800_0534, 0x5800_0538, 0x5800_053C]
        XCTAssertEqual(actual, expected)
    }
}
