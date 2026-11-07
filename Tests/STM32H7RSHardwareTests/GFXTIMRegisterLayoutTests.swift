import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

extension RegisterLayoutTests {
    func testGFXTIMAddressesMatchCMSISIncludingReservedGaps() {
        let io = STM32GFXTIMRegisters()
        let offsets: [UInt] = [0, 4, 8, 12, 16, 20, 0x20, 0x30, 0x34, 0x38, 0x3C,
            0x40, 0x44, 0x50, 0x54, 0x58, 0x60, 0x70, 0x74, 0x80, 0x84, 0x88, 0x8C, 0xA0, 0xA4, 0xA8]
        XCTAssertEqual(GFXTIMRegister.allCases.count, offsets.count)
        for (register, offset) in zip(GFXTIMRegister.allCases, offsets) {
            XCTAssertEqual(io.address(of: register), 0x5000_4000 + offset)
        }
    }
    func testGFXTIMHandleWordsRemainSharedBetweenAliases() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 8)
        storage.initialize(repeating: 0xA5A5_A5A5)
        defer { storage.deallocate() }
        let io = STM32GFXTIMHandleRegisters(storage: .init(rebasing: storage[1..<7]))
        let alias = io
        XCTAssertEqual(GFXTIMHandleWord.allCases.count, 6)
        for word in GFXTIMHandleWord.allCases {
            io.write(word, value: UInt32(word.rawValue) * 17)
            XCTAssertEqual(alias.read(word), UInt32(word.rawValue) * 17)
            XCTAssertEqual(storage[word.rawValue + 1], UInt32(word.rawValue) * 17)
            storage[word.rawValue + 1] = 0x1234_5678
            XCTAssertEqual(io.read(word), 0x1234_5678)
        }
        XCTAssertEqual(storage[0], 0xA5A5_A5A5); XCTAssertEqual(storage[7], 0xA5A5_A5A5)
    }
    func testGFXTIMCallbackSlotsUseNativePointersAndOneBasedIDs() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 19)
        storage.initialize(repeating: 0)
        storage[0] = 0x1234; storage[18] = 0x5678
        let context = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        context.initialize(to: 0)
        defer { storage.deallocate(); context.deallocate() }
        let io = STM32GFXTIMCallbackRegisters(storage: .init(rebasing: storage[1..<18]), context: context)
        let callback: GFXTIMCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in GFXTIMCallbackID.allCases {
            XCTAssertNil(io.read(id))
            io.write(id, value: callback)
            XCTAssertEqual(storage[Int(id.rawValue)], unsafeBitCast(callback, to: UInt.self))
            io.read(id)!(io.context)
            io.write(id, value: nil)
            XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context.pointee, 17)
        XCTAssertEqual(storage[0], 0x1234); XCTAssertEqual(storage[18], 0x5678)
    }
}
