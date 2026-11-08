import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class ADCRegisterLayoutTests: XCTestCase {
    func testBothADCInstancesAndCorrectedCommonRegisterBase() {
        let io = STM32ADCRegisters(systemCoreClock: { 64_000_000 })
        for instance in ADCInstance.allCases {
            for register in ADCRegister.allCases {
                XCTAssertEqual(io.address(of: register, instance: instance), 0x40022000 + UInt(instance.rawValue) * 0x100 + UInt(register.rawValue))
            }
            XCTAssertEqual(io.dataAddress(instance: instance), 0x40022040 + instance.rawValue * 0x100)
        }
        for register in ADCCommonRegister.allCases { XCTAssertEqual(io.commonAddress(of: register), 0x40022300 + UInt(register.rawValue)) }
        XCTAssertEqual(io.commonDataAddress(), 0x4002230C)
        XCTAssertEqual(io.systemCoreClock(), 64_000_000)
        io.stabilizationDelay(iterations: 0)
        io.stabilizationDelay(iterations: 642)
    }
    func testFactoryCalibrationAddresses() {
        let io = STM32ADCCalibrationRegisters()
        XCTAssertEqual(io.address(of: .vrefInt), 0x08FFF810)
        XCTAssertEqual(io.address(of: .temperature1), 0x08FFF814)
        XCTAssertEqual(io.address(of: .temperature2), 0x08FFF818)
    }
    func testAllTwentyFiveHandleWords() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 27)
        words.initialize(repeating: 0xDEADBEEF); defer { words.deallocate() }
        let handle = STM32ADCHandleRegisters(storage: .init(rebasing: words[1..<26]))
        for word in ADCHandleWord.allCases {
            let value = UInt32(word.rawValue) + 0x12340000
            handle.write(word, value: value)
            XCTAssertEqual(handle.read(word), value); XCTAssertEqual(words[word.rawValue+1], value)
        }
        XCTAssertEqual(words[0], 0xDEADBEEF); XCTAssertEqual(words[26], 0xDEADBEEF)
    }
    func testElevenNativeWidthCallbackSlots() {
        let slots = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 13)
        slots.initialize(repeating: 0); slots[0] = 123; slots[12] = 456; defer { slots.deallocate() }
        var calls: UInt32 = 0
        withUnsafeMutablePointer(to: &calls) { context in
            let io = STM32ADCCallbackRegisters(storage: .init(rebasing: slots[1..<12]), context: context)
            let callback: ADCCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee += 1 }
            for id in ADCCallbackID.allCases {
                XCTAssertNil(io.read(id)); io.write(id, value: callback)
                XCTAssertEqual(slots[Int(id.rawValue)+1], unsafeBitCast(callback, to: UInt.self))
                io.read(id)!(io.context); io.write(id, value: nil); XCTAssertNil(io.read(id))
            }
        }
        XCTAssertEqual(calls, 11); XCTAssertEqual(slots[0], 123); XCTAssertEqual(slots[12], 456)
    }
}
