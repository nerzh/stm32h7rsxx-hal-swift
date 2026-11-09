import XCTest
import STM32H7RSHAL
import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class LLSystemRegisterLayoutTests: XCTestCase {
    func testDebugRegistersMatchCMSISOffsets() {
        XCTAssertEqual(dbgmcu.unsafeAddress, 0x5C001000)
        let registers: [(LLDebugRegister, UInt)] = [
            (.idcode, dbgmcu.idc.unsafeAddress), (.cr, dbgmcu.cr.unsafeAddress),
            (.ahb1fzr, dbgmcu.ahb1fzr.unsafeAddress), (.ahb5fzr, dbgmcu.ahb5fzr.unsafeAddress),
            (.apb1fzr, dbgmcu.apb1fzr.unsafeAddress), (.apb2fzr, dbgmcu.apb2fz.unsafeAddress),
            (.apb4fzr, dbgmcu.apb4fzr.unsafeAddress),
        ]
        XCTAssertEqual(registers.count, LLDebugRegister.allCases.count)
        for (register, address) in registers {
            let adapted = STM32HALRegisters.address(of: register)
            XCTAssertEqual(adapted, 0x5C001000 + UInt(register.rawValue))
            if register == .ahb5fzr {
                XCTAssertEqual(address, 0x5C001020) // Known pinned-SVD discrepancy.
                XCTAssertEqual(adapted, 0x5C00101C)
            } else {
                XCTAssertEqual(address, adapted)
            }
        }
    }
}
