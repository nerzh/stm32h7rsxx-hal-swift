import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

// Expected addresses come from CMSIS stm32h7{s,r}{3,7}xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and CMSIS_6 core_cm7.h at
// 3c860f7a5810a34205bdbadb84b6d5f78f1cb322. These tests never read or write
// memory-mapped hardware; only the time-base test accesses owned host RAM.
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

    func testCortexSystemSysTickAndMPUAddressesMatchCMSIS() {
        let vectors: [(CortexRegister, UInt)] = [
            (.aircr, 0xE000_ED0C), (.shcsr, 0xE000_ED24),
            (.sysTickControl, 0xE000_E010), (.sysTickReload, 0xE000_E014),
            (.sysTickCurrent, 0xE000_E018),
            (.mpuControl, 0xE000_ED94), (.mpuRegionNumber, 0xE000_ED98),
            (.mpuRegionBaseAddress, 0xE000_ED9C), (.mpuRegionAttributes, 0xE000_EDA0),
        ]
        for (register, expected) in vectors {
            XCTAssertEqual(STM32CortexRegisters.address(of: register), expected)
        }
    }

    func testNVICRegisterBanksMatchCMSISArrayExtentsAndGaps() {
        for bank in 0..<8 {
            let offset = UInt(bank) * 4
            let vectors: [(CortexRegister, UInt)] = [
                (.nvicSetEnable(bank: bank), 0xE000_E100 + offset),
                (.nvicClearEnable(bank: bank), 0xE000_E180 + offset),
                (.nvicSetPending(bank: bank), 0xE000_E200 + offset),
                (.nvicClearPending(bank: bank), 0xE000_E280 + offset),
                (.nvicActive(bank: bank), 0xE000_E300 + offset),
            ]
            for (register, expected) in vectors {
                XCTAssertEqual(STM32CortexRegisters.address(of: register), expected)
            }
        }
    }

    func testPriorityRegistersHaveByteStrideAndCMSISArrayExtents() {
        for index in 0..<240 {
            XCTAssertEqual(STM32CortexRegisters.address(of: CortexPriorityRegister.device(index: index)),
                           0xE000_E400 + UInt(index))
        }
        for index in 0..<12 {
            XCTAssertEqual(STM32CortexRegisters.address(of: CortexPriorityRegister.system(index: index)),
                           0xE000_ED18 + UInt(index))
        }
        // SysTick priority is SHPR[11], not a word at SHPR3's base.
        XCTAssertEqual(STM32CortexRegisters.address(of: CortexPriorityRegister.system(index: 11)), 0xE000_ED23)
    }

    func testPowerRegisterAddressesMatchCMSIS() {
        XCTAssertEqual(pwr.unsafeAddress, 0x5802_4800)
        XCTAssertEqual(pwr.cr1.unsafeAddress, 0x5802_4800)
        XCTAssertEqual(pwr.csr3.unsafeAddress, 0x5802_4810)
        XCTAssertEqual(pwr.wkupepr.unsafeAddress, 0x5802_4828)
        XCTAssertEqual(STM32PowerRegisters.systemControlAddress, 0xE000_ED10)
    }

    func testHALResetRegisterAddressesMatchCMSIS() {
        let actual: [UInt] = [
            rcc.apb1rstr1.unsafeAddress, rcc.apb1rstr2.unsafeAddress,
            rcc.apb2rstr.unsafeAddress, rcc.apb4rstr.unsafeAddress, rcc.apb5rstr.unsafeAddress,
            rcc.ahb1rstr.unsafeAddress, rcc.ahb2rstr.unsafeAddress, rcc.ahb3rstr.unsafeAddress,
            rcc.ahb4rstr.unsafeAddress, rcc.ahb5rstr.unsafeAddress,
        ]
        let expected: [UInt] = [
            0x5802_4490, 0x5802_4494, 0x5802_4498, 0x5802_449C, 0x5802_448C,
            0x5802_4480, 0x5802_4484, 0x5802_44A4, 0x5802_4488, 0x5802_447C,
        ]
        XCTAssertEqual(actual, expected)
    }

    func testHALDeviceIdentificationAndDebugAddressesMatchCMSIS() {
        XCTAssertEqual(dbgmcu.idc.unsafeAddress, 0x5C00_1000)
        XCTAssertEqual(dbgmcu.cr.unsafeAddress, 0x5C00_1004)
        XCTAssertEqual((0..<3).map { STM32HALRegisters.uniqueIDWordAddress(index: $0) },
                       [0x08FF_F800, 0x08FF_F804, 0x08FF_F808])
    }

    func testTimeBaseStorageUsesThreeSeparateWordsAndCopiesShareStorage() {
        var storage: [UInt32] = [0, 16, 1]
        storage.withUnsafeMutableBufferPointer { buffer in
            let registers = STM32HALTimeBaseRegisters(storage: buffer)
            let copy = registers
            XCTAssertEqual(registers.read(.tick), 0)
            XCTAssertEqual(registers.read(.priority), 16)
            XCTAssertEqual(registers.read(.frequency), 1)
            registers.write(.tick, value: 0x12345678)
            copy.write(.priority, value: 5)
            registers.write(.frequency, value: 100)
            XCTAssertEqual(Array(buffer), [0x12345678, 5, 100])
            XCTAssertEqual(copy.read(.tick), 0x12345678)
            XCTAssertEqual(registers.read(.priority), 5)
        }
    }
}
