import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

extension RegisterLayoutTests {
    func testLTDCAddressesMatchCMSISIncludingReservedGaps() {
        let io = STM32LTDCRegisters()
        let offsets: [UInt] = [0x08, 0x0C, 0x10, 0x14, 0x18, 0x24, 0x2C, 0x34, 0x38, 0x3C, 0x40, 0x44, 0x48]
        XCTAssertEqual(LTDCRegister.allCases.count, offsets.count)
        for (register, offset) in zip(LTDCRegister.allCases, offsets) {
            XCTAssertEqual(io.address(of: register), 0x5000_1000 + offset)
        }
        let layerOffsets: [UInt] = [0, 4, 8, 0xC, 0x10, 0x14, 0x18, 0x1C, 0x28, 0x2C, 0x30, 0x40]
        XCTAssertEqual(LTDCLayerRegister.allCases.count, layerOffsets.count)
        for layer: UInt32 in 0...1 {
            for (register, offset) in zip(LTDCLayerRegister.allCases, layerOffsets) {
                XCTAssertEqual(io.address(of: register, layer: layer), 0x5000_1084 + UInt(layer) * 0x80 + offset)
            }
        }
    }
    func testLTDCHandleWordsRemainSharedBetweenAliases() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 44)
        storage.initialize(repeating: 0xA5A5_A5A5)
        defer { storage.deallocate() }
        let io = STM32LTDCHandleRegisters(storage: .init(rebasing: storage[1..<43]))
        let alias = io
        XCTAssertEqual(LTDCHandleWord.allCases.count, 42)
        for word in LTDCHandleWord.allCases {
            io.write(word, value: UInt32(word.rawValue) * 17)
            XCTAssertEqual(alias.read(word), UInt32(word.rawValue) * 17)
            XCTAssertEqual(storage[word.rawValue + 1], UInt32(word.rawValue) * 17)
            storage[word.rawValue + 1] = 0x1234_5678
            XCTAssertEqual(io.read(word), 0x1234_5678)
        }
        XCTAssertEqual(storage[0], 0xA5A5_A5A5); XCTAssertEqual(storage[43], 0xA5A5_A5A5)
    }
    func testLTDCCallbackSlotsUseNativePointersAndZeroBasedIDs() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 7)
        storage.initialize(repeating: 0)
        storage[0] = 0x1234; storage[6] = 0x5678
        let context = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        context.initialize(to: 0)
        defer { storage.deallocate(); context.deallocate() }
        let io = STM32LTDCCallbackRegisters(storage: .init(rebasing: storage[1..<6]), context: context)
        let callback: LTDCCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in LTDCCallbackID.allCases {
            XCTAssertNil(io.read(id))
            io.write(id, value: callback)
            XCTAssertEqual(storage[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            io.read(id)!(io.context)
            io.write(id, value: nil)
            XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context.pointee, 5)
        XCTAssertEqual(storage[0], 0x1234); XCTAssertEqual(storage[6], 0x5678)
    }
}
