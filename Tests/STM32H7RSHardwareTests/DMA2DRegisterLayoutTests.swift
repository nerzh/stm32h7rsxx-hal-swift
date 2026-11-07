import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

extension RegisterLayoutTests {
    func testDMA2DAddressesMatchCMSISIncludingReservedGaps() {
        let io = STM32DMA2DRegisters()
        let offsets: [UInt] = Array(stride(from: 0, through: 0x4C, by: 4))
        XCTAssertEqual(DMA2DRegister.allCases.count, offsets.count)
        for (register, offset) in zip(DMA2DRegister.allCases, offsets) {
            XCTAssertEqual(io.address(of: register), 0x5200_1000 + offset)
        }
    }
    func testDMA2DHandleWordsRemainSharedBetweenAliases() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 26)
        storage.initialize(repeating: 0xA5A5_A5A5)
        defer { storage.deallocate() }
        let io = STM32DMA2DHandleRegisters(storage: .init(rebasing: storage[1..<25]))
        let alias = io
        XCTAssertEqual(DMA2DHandleWord.allCases.count, 24)
        for word in DMA2DHandleWord.allCases {
            io.write(word, value: UInt32(word.rawValue) * 17)
            XCTAssertEqual(alias.read(word), UInt32(word.rawValue) * 17)
            XCTAssertEqual(storage[word.rawValue + 1], UInt32(word.rawValue) * 17)
            storage[word.rawValue + 1] = 0x1234_5678
            XCTAssertEqual(io.read(word), 0x1234_5678)
        }
        XCTAssertEqual(storage[0], 0xA5A5_A5A5); XCTAssertEqual(storage[25], 0xA5A5_A5A5)
    }
    func testDMA2DCallbackSlotsUseNativePointersAndZeroBasedIDs() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 8)
        storage.initialize(repeating: 0)
        storage[0] = 0x1234; storage[7] = 0x5678
        let context = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        context.initialize(to: 0)
        defer { storage.deallocate(); context.deallocate() }
        let io = STM32DMA2DCallbackRegisters(storage: .init(rebasing: storage[1..<7]), context: context)
        let callback: DMA2DCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in DMA2DCallbackID.allCases {
            XCTAssertNil(io.read(id))
            io.write(id, value: callback)
            XCTAssertEqual(storage[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            io.read(id)!(io.context)
            io.write(id, value: nil)
            XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context.pointee, 6)
        XCTAssertEqual(storage[0], 0x1234); XCTAssertEqual(storage[7], 0x5678)
    }
}
