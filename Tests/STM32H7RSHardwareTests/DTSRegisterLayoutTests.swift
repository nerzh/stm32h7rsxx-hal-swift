import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

private func dtsLayoutCallback(_ context: UnsafeMutableRawPointer?) {
    let count = context!.assumingMemoryBound(to: UInt32.self)
    count.pointee += 1
}

final class DTSRegisterLayoutTests: XCTestCase {
    func testDTSRegisterAddressesMatchCMSIS() {
        let registers = STM32DTSRegisters()
        let layout: [(DTSRegister, UInt)] = [
            (.cfgr1, 0x00), (.t0valr1, 0x08), (.rampvalr, 0x10), (.itr1, 0x14),
            (.dr, 0x1C), (.sr, 0x20), (.itenr, 0x24), (.icifr, 0x28),
        ]
        for (register, offset) in layout {
            XCTAssertEqual(registers.address(of: register), 0x5800_6800 + offset)
        }
    }

    func testDTSHandleCopiesShareNineVolatileWords() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 10)
        storage.initialize(repeating: 0)
        defer { storage.deinitialize(); storage.deallocate() }
        storage[9] = 0xAABB_CCDD
        let first = STM32DTSHandleRegisters(storage: storage)
        let second = first
        for word in DTSConfigurationWord.allCases {
            first.write(word, value: 0x1234_0000 | UInt32(word.rawValue))
            XCTAssertEqual(second.read(word), storage[word.rawValue])
        }
        second.write(DTSHandleWord.lock, value: 1)
        second.write(DTSHandleWord.state, value: 0xFEDC_BA98)
        XCTAssertEqual(storage[7], 1)
        XCTAssertEqual(first.read(DTSHandleWord.state), 0xFEDC_BA98)
        XCTAssertEqual(storage[8], 0xFEDC_BA98)
        XCTAssertEqual(storage[9], 0xAABB_CCDD)
    }

    func testDTSCallbackSlotsUseNativeFunctionPointersAndSharedContext() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 9)
        storage.initialize(repeating: 0)
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        count.initialize(to: 0)
        defer { storage.deinitialize(); storage.deallocate(); count.deinitialize(count: 1); count.deallocate() }
        storage[8] = 0xABCD
        let first = STM32DTSCallbackRegisters(storage: storage, context: count)
        let second = first
        for id in DTSCallbackID.allCases {
            XCTAssertNil(first.read(id))
            first.write(id, value: dtsLayoutCallback)
            second.read(id)!(second.context)
            second.write(id, value: nil)
            XCTAssertNil(first.read(id))
        }
        XCTAssertEqual(count.pointee, 8)
        XCTAssertEqual(storage[8], 0xABCD)
    }
}
