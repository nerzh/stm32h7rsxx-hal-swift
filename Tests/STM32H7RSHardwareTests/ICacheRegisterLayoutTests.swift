import XCTest
import STM32H7RSHAL
import STM32H7RSHardware
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

final class ICacheRegisterLayoutTests: XCTestCase {
    func testPeripheralRegistersMatchH7R7AndH7S7CMSIS() {
        // CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010: this peripheral
        // is absent from H7R3/H7S3, despite both aggregated SVDs containing it.
        XCTAssertEqual(icache.unsafeAddress, 0x5201_5000)
        XCTAssertEqual([icache.cr.unsafeAddress, icache.sr.unsafeAddress, icache.ier.unsafeAddress,
                        icache.fcr.unsafeAddress, icache.hmonr.unsafeAddress, icache.mmonr.unsafeAddress],
                       [0x5201_5000, 0x5201_5004, 0x5201_5008, 0x5201_500C, 0x5201_5010, 0x5201_5014])
        XCTAssertEqual(MemoryLayout<ICACHE.CR.Raw.Storage>.size, 4)
        XCTAssertEqual(MemoryLayout<ICACHE.SR.Raw.Storage>.size, 4)
        XCTAssertEqual(MemoryLayout<ICACHE.IER.Raw.Storage>.size, 4)
        XCTAssertEqual(MemoryLayout<ICACHE.FCR.Raw.Storage>.size, 4)
        XCTAssertEqual(MemoryLayout<ICACHE.HMONR.Raw.Storage>.size, 4)
        XCTAssertEqual(MemoryLayout<ICACHE.MMONR.Raw.Storage>.size, 4)
    }

    func testHardwareConstructionRequiresAnExplicitSupportedDeviceWithoutAccessingMMIO() {
        let r = STM32ICacheRegisters(device: .h7r7)
        let s = STM32ICacheRegisters(device: .h7s7)
        XCTAssertEqual(r.device, .h7r7)
        XCTAssertEqual(s.device, .h7s7)
        let cache = ICache<STM32ICacheRegisters>(device: .h7s7)
        XCTAssertEqual(cache.registers.device, .h7s7)
    }
}
