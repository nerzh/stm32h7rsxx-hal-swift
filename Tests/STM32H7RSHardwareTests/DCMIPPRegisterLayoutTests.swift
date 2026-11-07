import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

extension RegisterLayoutTests {
    func testDCMIPPAddressesMatchCMSISIncludingReservedGaps() {
        let io = STM32DCMIPPRegisters()
        let offsets: [UInt] = [0x0, 0x4, 0x8, 0x20, 0x24, 0x28, 0x104, 0x108, 0x10c, 0x204, 0x208, 0x3f0, 0x3f4, 0x3f8, 0x3fc, 0x404, 0x500, 0x504, 0x508, 0x5b0, 0x5b4, 0x5c0, 0x5c4, 0x5c8]
        XCTAssertEqual(DCMIPPRegister.allCases.count, offsets.count)
        for (register, offset) in zip(DCMIPPRegister.allCases, offsets) {
            XCTAssertEqual(io.address(of: register), 0x5000_2000 + offset)
        }
    }
    func testDCMIPPHandleWordsRemainSharedBetweenAliases() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 5)
        storage.initialize(repeating: 0xA5A5_A5A5)
        defer { storage.deallocate() }
        let io = STM32DCMIPPHandleRegisters(storage: .init(rebasing: storage[1..<4]))
        let alias = io
        XCTAssertEqual(DCMIPPHandleWord.allCases.count, 3)
        for word in DCMIPPHandleWord.allCases {
            io.write(word, value: UInt32(word.rawValue) * 17)
            XCTAssertEqual(alias.read(word), UInt32(word.rawValue) * 17)
            XCTAssertEqual(storage[word.rawValue + 1], UInt32(word.rawValue) * 17)
            storage[word.rawValue + 1] = 0x1234_5678
            XCTAssertEqual(io.read(word), 0x1234_5678)
        }
        XCTAssertEqual(storage[0], 0xA5A5_A5A5); XCTAssertEqual(storage[4], 0xA5A5_A5A5)
    }
    func testDCMIPPCommonAndPipeCallbacksUseDisjointNativePointerSlots() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 10)
        storage.initialize(repeating: 0)
        storage[0] = 0x1234; storage[9] = 0x5678
        let context = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        context.initialize(to: 0)
        defer { storage.deallocate(); context.deallocate() }
        let io = STM32DCMIPPCallbackRegisters(storage: .init(rebasing: storage[1..<9]), context: context)
        let callback: DCMIPPCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        let pipeCallback: DCMIPPPipeCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= $1 + 1 }
        for id in DCMIPPCallbackID.allCases {
            XCTAssertNil(io.read(id)); io.write(id, value: callback)
            XCTAssertEqual(storage[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            io.read(id)!(io.context)
        }
        for id in DCMIPPPipeCallbackID.allCases {
            XCTAssertNil(io.read(id)); io.write(id, value: pipeCallback)
            XCTAssertEqual(storage[Int(id.rawValue) + 3], unsafeBitCast(pipeCallback, to: UInt.self))
            io.read(id)!(io.context, id.rawValue)
        }
        for id in DCMIPPCallbackID.allCases { XCTAssertNotNil(io.read(id)); io.write(id, value: nil); XCTAssertNil(io.read(id)) }
        for id in DCMIPPPipeCallbackID.allCases { XCTAssertNotNil(io.read(id)); io.write(id, value: nil); XCTAssertNil(io.read(id)) }
        XCTAssertEqual(context.pointee, 23)
        XCTAssertEqual(storage[0], 0x1234); XCTAssertEqual(storage[9], 0x5678)
    }
}
