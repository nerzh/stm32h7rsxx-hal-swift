import CLLReference
import STM32H7RSHAL
import XCTest

final class LLUtilityCompletenessTests: XCTestCase {
    func testI2CTimingFieldsAgainstOriginalMacro() {
        for prescaler: UInt32 in 0..<32 {
            for setup: UInt32 in 0..<32 {
                for hold: UInt32 in 0..<32 {
                    let high = prescaler &* 0x1020_4081
                    let low = setup &* 0x9E37_79B9 ^ hold
                    XCTAssertEqual(
                        __LL_I2C_CONVERT_TIMINGS(prescaler, setup, hold, high, low),
                        CL60_I2CTiming(prescaler, setup, hold, high, low))
                }
            }
        }
        for field in 0..<5 {
            for value: UInt32 in [0, 1, 15, 16, 31, 127, 255, 256, 0x8000_0000, .max] {
                for background: UInt32 in [0, .max] {
                    var args = Array(repeating: background, count: 5)
                    args[field] = value
                    XCTAssertEqual(
                        __LL_I2C_CONVERT_TIMINGS(args[0], args[1], args[2], args[3], args[4]),
                        CL60_I2CTiming(args[0], args[1], args[2], args[3], args[4]))
                }
            }
        }
        XCTAssertEqual(__LL_I2C_CONVERT_TIMINGS(3, 4, 5, 0x67, 0x89), 0x3045_6789)
        XCTAssertEqual(__LL_I2C_CONVERT_TIMINGS(.max, .max, .max, .max, .max), 0xF0FF_FFFF)
    }
    func testI3CPayloadExtractionAndCapabilityMasksAgainstOriginalMacros() {
        for bcr: UInt64 in 0..<256 {
            for high: UInt64 in 0..<256 {
                let payload = (high << 56) | (bcr << 48) | ((high &* 0x0102_0408_1020) & 0x0000_FFFF_FFFF_FFFF)
                XCTAssertEqual(LL_I3C_GET_BCR(payload), CL60_I3CBCR(payload))
                XCTAssertEqual(LL_I3C_GET_BCR(payload), UInt32(bcr))
            }
        }
        for sample: UInt32 in 0..<1024 {
            for bcr in [sample, sample | 0xFFFF_FC00, sample &* 0x9E37_79B9] {
                XCTAssertEqual(LL_I3C_GET_IBI_CAPABLE(bcr), CL60_I3CIBI(bcr))
                XCTAssertEqual(LL_I3C_GET_IBI_PAYLOAD(bcr), CL60_I3CPayload(bcr))
                XCTAssertEqual(LL_I3C_GET_CR_CAPABLE(bcr), CL60_I3CController(bcr))
            }
        }
        XCTAssertEqual(LL_I3C_GET_IBI_CAPABLE(0x2), 0x10000)
        XCTAssertEqual(LL_I3C_GET_IBI_PAYLOAD(0x4), 0x40000)
        XCTAssertEqual(LL_I3C_GET_CR_CAPABLE(0x40), 0x20000)
        XCTAssertEqual(LL_I3C_GET_BCR(0xABCD_EF12_3456_7890), 0xCD)
    }
    func testExistingHALHelperRetainsBooleanCapabilityResults() {
        let fixture = I3CFixture()
        let driver = fixture.driver
        for bcr: UInt32 in 0..<256 {
            let payload = (UInt64(bcr) << 48) | 0xAB00_1234_5678_9ABC
            XCTAssertEqual(driver.getBusCharacteristics(payload), LL_I3C_GET_BCR(payload))
            XCTAssertEqual(driver.isIBICapable(bcr), (bcr & 2) >> 1)
            XCTAssertEqual(driver.hasIBIPayload(bcr), (bcr & 4) >> 2)
            XCTAssertEqual(driver.isControllerCapable(bcr), (bcr & 0x40) >> 6)
        }
    }
}
