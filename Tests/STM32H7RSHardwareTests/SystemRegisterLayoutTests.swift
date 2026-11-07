import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

// Expected addresses come from CMSIS stm32h7{s,r}{3,7}xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
final class SystemRegisterLayoutTests: XCTestCase {
    func testSBSAddressesIncludeReservedGaps() {
        let registers = STM32SBSRegisters()
        let cases: [(SBSRegister, UInt)] = [
            (.bootsr, 0x00), (.hdplcr, 0x10), (.hdplsr, 0x14),
            (.dbgcr, 0x20), (.dbglockr, 0x24), (.rsscmdr, 0x34),
            (.pmcr, 0x100), (.fpuimr, 0x104), (.mesr, 0x108),
            (.cccsr, 0x110), (.ccvalr, 0x114), (.ccswvalr, 0x118), (.bklockr, 0x120),
            (.extiConfiguration(index: 0), 0x130), (.extiConfiguration(index: 1), 0x134),
            (.extiConfiguration(index: 2), 0x138), (.extiConfiguration(index: 3), 0x13C),
        ]
        for (register, offset) in cases {
            XCTAssertEqual(registers.address(of: register), 0x5800_0400 + offset)
        }
    }

    func testVREFBUFAndFMCAddresses() {
        let vref = STM32VREFBUFRegisters()
        XCTAssertEqual(vref.address(of: .csr), 0x5800_3C00)
        XCTAssertEqual(vref.address(of: .ccr), 0x5800_3C04)
        XCTAssertEqual(STM32FMCBankMappingRegisters().address(of: .bcr1), 0x5200_4000)
    }

    func testEveryAXIMASIBInstanceAndRegisterAddress() {
        let bases: [UInt] = [0xBFF4_2000, 0xBFF4_3000, 0xBFF4_4000, 0xBFF4_5000,
                            0xBFF4_6000, 0xBFF4_7000, 0xBFF4_8000, 0xBFF4_9000,
                            0xBFF4_A000, 0xBFF4_B000, 0xBFF4_C000]
        XCTAssertEqual(STM32AXIMASIBInstance.allCases.map(\.rawValue), bases)
        let offsets: [(AXIMASIBRegister, UInt)] = [
            (.fnmod2, 0x24), (.readQoS, 0x100), (.writeQoS, 0x104), (.fnmod, 0x108),
        ]
        for (instance, base) in zip(STM32AXIMASIBInstance.allCases, bases) {
            let registers = STM32AXIMASIBRegisters(instance)
            for (register, offset) in offsets {
                XCTAssertEqual(registers.address(of: register), base + offset)
            }
        }
    }

    func testEveryAXIMAMIBInstanceAndRegisterAddress() {
        let bases: [UInt] = [0xBFF0_2000, 0xBFF0_3000, 0xBFF0_4000, 0xBFF0_5000,
                            0xBFF0_6000, 0xBFF0_7000, 0xBFF0_8000, 0xBFF0_9000,
                            0xBFF0_A000, 0xBFF0_B000]
        XCTAssertEqual(STM32AXIMAMIBInstance.allCases.map(\.rawValue), bases)
        let offsets: [(AXIMAMIBRegister, UInt)] = [
            (.fnmodBusMatrixIssuing, 0x08), (.fnmod2, 0x24),
            (.fnmodLongBurst, 0x2C), (.fnmod, 0x108),
        ]
        for (instance, base) in zip(STM32AXIMAMIBInstance.allCases, bases) {
            let registers = STM32AXIMAMIBRegisters(instance)
            for (register, offset) in offsets {
                XCTAssertEqual(registers.address(of: register), base + offset)
            }
        }
    }
}
