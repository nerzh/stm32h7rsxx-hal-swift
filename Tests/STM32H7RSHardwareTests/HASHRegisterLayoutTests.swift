import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

private func hashLayoutCallback(_ context: UnsafeMutableRawPointer?) {
    context!.assumingMemoryBound(to: UInt32.self).pointee += 1
}

final class HASHRegisterLayoutTests: XCTestCase {
    // Expected addresses are the CMSIS HASH and HASH_DIGEST layouts at
    // 7e6e213ddc397c76622a0aca2f623ccc3b34c010, identical for all four H7RS devices.
    func testHASHRegistersAndAllContextAndDigestWords() {
        let registers = STM32HASHRegisters()
        let singletons: [(HASHRegister, UInt32)] = [
            (.cr, 0), (.din, 4), (.str, 8), (.imr, 0x20), (.sr, 0x24),
        ]
        for (register, offset) in singletons {
            XCTAssertEqual(registers.address(of: register), 0x4802_0400 + offset)
        }
        for index in 0..<5 {
            XCTAssertEqual(registers.address(of: .hr(index: index)), 0x4802_040C + UInt32(index) * 4)
        }
        for index in 0..<103 {
            XCTAssertEqual(registers.address(of: .csr(index: index)), 0x4802_04F8 + UInt32(index) * 4)
        }
        for index in 0..<16 {
            XCTAssertEqual(registers.address(of: .digest(index: index)), 0x4802_0710 + UInt32(index) * 4)
        }
    }

    func testHASHHandleCopiesShareAllTwentyFiveWords() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 26)
        storage.initialize(repeating: 0)
        defer { storage.deinitialize(); storage.deallocate() }
        storage[25] = 0xAABB_CCDD
        let first = STM32HASHHandleRegisters(storage: storage)
        let second = first
        XCTAssertEqual(HASHHandleWord.allCases.count, 25)
        for word in HASHHandleWord.allCases {
            first.write(word, value: 0x1234_0000 | UInt32(word.rawValue))
            XCTAssertEqual(second.read(word), storage[word.rawValue])
            second.write(word, value: .max)
            XCTAssertEqual(first.read(word), .max)
        }
        XCTAssertEqual(storage[25], 0xAABB_CCDD)
    }

    func testHASHCallbacksKeepNativeWidthAndSharedContext() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 6)
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        storage.initialize(repeating: 0); count.initialize(to: 0)
        defer { storage.deinitialize(); storage.deallocate(); count.deinitialize(count: 1); count.deallocate() }
        storage[5] = 0xABCD_EF01
        let first = STM32HASHCallbackRegisters(storage: storage, context: count)
        let second = first
        for id in HASHCallbackID.allCases {
            XCTAssertNil(first.read(id))
            first.write(id, value: hashLayoutCallback)
            second.read(id)!(second.context)
            second.write(id, value: nil)
            XCTAssertNil(first.read(id))
        }
        XCTAssertEqual(count.pointee, 5)
        XCTAssertEqual(storage[5], 0xABCD_EF01)
    }
}
