import XCTest
import STM32H7RSHAL
import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class LLClockRegisterLayoutTests: XCTestCase {
    func testAdditionalRCCRegistersMatchPinnedCMSIS() {
        let registers: [(LLRCCRegister, UInt)] = [
            (.csicfgr, rcc.csicfgr.unsafeAddress), (.crrcr, rcc.crrcr.unsafeAddress),
            (.pll1sscgr, rcc.pll1sscgr.unsafeAddress), (.pll2sscgr, rcc.pll2sscgr.unsafeAddress),
            (.pll3sscgr, rcc.pll3sscgr.unsafeAddress)
        ]
        XCTAssertEqual(registers.count, LLRCCRegister.allCases.count)
        for (register, address) in registers {
            XCTAssertEqual(address, rcc.unsafeAddress + UInt(register.rawValue))
        }
        XCTAssertEqual(STM32HALRegisters.packageAddress, 0x08FFF80C)
    }
}
