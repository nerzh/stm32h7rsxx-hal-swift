import STM32H7RSHAL
import STM32H7RSHardware
import XCTest

final class LLConnectionRegisterLayoutTests: XCTestCase {
    func testUCPDRegisterOffsetsMatchCMSISIncludingMissingSVDSlot() {
        let io = STM32UCPDRegisters()
        let registers: [UCPDRegister] = [
            .cfg1, .cfg2, .cfg3, .cr, .imr, .sr, .icr, .tx_ordset, .tx_paysz, .txdr,
            .rx_ordset, .rx_paysz, .rxdr, .rx_ordext1, .rx_ordext2,
        ]
        XCTAssertEqual(registers.count, UCPDRegister.allCases.count)
        for (index, register) in registers.enumerated() {
            XCTAssertEqual(register.rawValue, UInt32(index) * 4)
            XCTAssertEqual(io.address(of: register), 0x4000_EC00 + UInt32(index) * 4)
        }
    }
    func testBothDLYBInstancesMatchCMSIS() {
        let first = STM32DLYBRegisters(instance: .sdmmc1)
        let second = STM32DLYBRegisters(instance: .sdmmc2)
        XCTAssertEqual(first.address(of: .cr), 0x5200_8000)
        XCTAssertEqual(first.address(of: .cfgr), 0x5200_8004)
        XCTAssertEqual(second.address(of: .cr), 0x4800_2800)
        XCTAssertEqual(second.address(of: .cfgr), 0x4800_2804)
        XCTAssertEqual(DLYBRegister.allCases, [.cr, .cfgr])
        XCTAssertEqual(DLYBRegister.cr.rawValue, 0)
        XCTAssertEqual(DLYBRegister.cfgr.rawValue, 4)
    }
}
