import XCTest
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class LLBusRegisterLayoutTests: XCTestCase {
    func testEveryBusRegisterAgainstDeviceSVD() {
        XCTAssertEqual(rcc.ahb1enr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb1enr.rawValue))
        XCTAssertEqual(rcc.ahb1rstr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb1rstr.rawValue))
        XCTAssertEqual(rcc.ahb1lpenr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb1lpenr.rawValue))
        XCTAssertEqual(rcc.ahb2enr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb2enr.rawValue))
        XCTAssertEqual(rcc.ahb2rstr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb2rstr.rawValue))
        XCTAssertEqual(rcc.ahb2lpenr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb2lpenr.rawValue))
        XCTAssertEqual(rcc.ahb3enr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb3enr.rawValue))
        XCTAssertEqual(rcc.ahb3rstr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb3rstr.rawValue))
        XCTAssertEqual(rcc.ahb3lpenr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb3lpenr.rawValue))
        XCTAssertEqual(rcc.ahb4enr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb4enr.rawValue))
        XCTAssertEqual(rcc.ahb4rstr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb4rstr.rawValue))
        XCTAssertEqual(rcc.ahb4lpenr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb4lpenr.rawValue))
        XCTAssertEqual(rcc.ahb5enr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb5enr.rawValue))
        XCTAssertEqual(rcc.ahb5rstr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb5rstr.rawValue))
        XCTAssertEqual(rcc.ahb5lpenr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ahb5lpenr.rawValue))
        XCTAssertEqual(rcc.apb1enr1.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb1enr1.rawValue))
        XCTAssertEqual(rcc.apb1rstr1.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb1rstr1.rawValue))
        XCTAssertEqual(rcc.apb1lpenr1.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb1lpenr1.rawValue))
        XCTAssertEqual(rcc.apb1enr2.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb1enr2.rawValue))
        XCTAssertEqual(rcc.apb1rstr2.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb1rstr2.rawValue))
        XCTAssertEqual(rcc.apb1lpenr2.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb1lpenr2.rawValue))
        XCTAssertEqual(rcc.apb2enr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb2enr.rawValue))
        XCTAssertEqual(rcc.apb2rstr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb2rstr.rawValue))
        XCTAssertEqual(rcc.apb2lpenr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb2lpenr.rawValue))
        XCTAssertEqual(rcc.apb4enr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb4enr.rawValue))
        XCTAssertEqual(rcc.apb4rstr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb4rstr.rawValue))
        XCTAssertEqual(rcc.apb4lpenr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb4lpenr.rawValue))
        XCTAssertEqual(rcc.apb5enr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb5enr.rawValue))
        XCTAssertEqual(rcc.apb5rstr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb5rstr.rawValue))
        XCTAssertEqual(rcc.apb5lpenr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.apb5lpenr.rawValue))
        XCTAssertEqual(rcc.ckgdisr.unsafeAddress - rcc.unsafeAddress, UInt(LLBusRegister.ckgdisr.rawValue))
    }
}
