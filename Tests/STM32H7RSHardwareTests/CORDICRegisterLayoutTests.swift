import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

private func cordicLayoutCallback(_ context: UnsafeMutableRawPointer?) {
    context!.assumingMemoryBound(to: UInt32.self).pointee += 1
}

final class CORDICRegisterLayoutTests: XCTestCase {
    func testCORDICRegisterAddressesMatchCMSIS() {
        let registers = STM32CORDICRegisters()
        XCTAssertEqual(registers.address(of: .csr), 0x4800_4400)
        XCTAssertEqual(registers.address(of: .wdata), 0x4800_4404)
        XCTAssertEqual(registers.address(of: .rdata), 0x4800_4408)
    }

    func testCORDICHandleCopiesShareSixWordsAndNativePointers() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 7)
        let pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 3)
        let data = UnsafeMutableBufferPointer<Int32>.allocate(capacity: 4)
        words.initialize(repeating: 0); pointers.initialize(repeating: 0); data.initialize(repeating: 0)
        defer {
            words.deinitialize(); words.deallocate(); pointers.deinitialize(); pointers.deallocate()
            data.deinitialize(); data.deallocate()
        }
        words[6] = 0xAABB_CCDD; pointers[2] = 0x1234_5678
        let foreground = STM32CORDICHandleRegisters(words: words, pointers: pointers)
        let interrupt = foreground
        for word in CORDICHandleWord.allCases {
            foreground.write(word, value: 0xABCD_0000 | UInt32(word.rawValue))
            XCTAssertEqual(interrupt.read(word), words[word.rawValue])
        }
        for pointer in CORDICBufferPointer.allCases {
            let expected = UnsafeMutableRawPointer(data.baseAddress!.advanced(by: pointer.rawValue + 1))
            foreground.writePointer(pointer, value: expected)
            XCTAssertEqual(interrupt.readPointer(pointer), expected)
            XCTAssertEqual(pointers[pointer.rawValue], UInt(bitPattern: expected))
            interrupt.writePointer(pointer, value: nil)
            XCTAssertNil(foreground.readPointer(pointer))
        }
        XCTAssertEqual(words[6], 0xAABB_CCDD); XCTAssertEqual(pointers[2], 0x1234_5678)
    }

    func testCORDICCallbackSlotsRetainNativePointersAndForwardContext() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 5)
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        storage.initialize(repeating: 0); count.initialize(to: 0)
        defer { storage.deinitialize(); storage.deallocate(); count.deinitialize(count: 1); count.deallocate() }
        storage[4] = 0xABCD
        let first = STM32CORDICCallbackRegisters(storage: storage, context: count)
        let second = first
        for id in CORDICCallbackID.allCases {
            XCTAssertNil(first.read(id)); first.write(id, value: cordicLayoutCallback)
            second.read(id)!(second.context)
            second.write(id, value: nil); XCTAssertNil(first.read(id))
        }
        XCTAssertEqual(count.pointee, 4); XCTAssertEqual(storage[4], 0xABCD)
    }
}
