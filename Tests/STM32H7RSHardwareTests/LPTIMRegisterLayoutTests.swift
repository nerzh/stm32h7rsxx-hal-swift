import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

extension RegisterLayoutTests {
    func testLPTIMAddressesMatchCMSISIncludingReservedGaps() {
        let bases: [UInt32] = [0x40002400, 0x58002400, 0x58002800, 0x58002C00, 0x58003000]
        let offsets: [UInt32] = [0, 4, 8, 12, 16, 20, 24, 28, 36, 40, 44, 52]
        for (instance, base) in zip(LPTIMInstance.allCases, bases) {
            let io = STM32LPTIMRegisters(instance: instance)
            for (register, offset) in zip(LPTIMRegister.allCases, offsets) { XCTAssertEqual(io.address(of: register), base + offset) }
        }
    }
    func testLPTIMWakeupMaskUsesCMSISOffsetInsteadOfIncompleteSVD() {
        for instance in LPTIMInstance.allCases {
            XCTAssertEqual(STM32LPTIMRegisters(instance: instance).wakeupInterruptMask.unsafeAddress, 0x58000090)
        }
    }
    func testLPTIMHandleWordsRemainSharedBetweenAliases() {
        let storage = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 21)
        storage.initialize(repeating: 0xA5A5_A5A5)
        defer { storage.deallocate() }
        let io = STM32LPTIMHandleRegisters(storage: .init(rebasing: storage[1..<20]))
        let alias = io
        XCTAssertEqual(LPTIMHandleWord.allCases.count, 19)
        for word in LPTIMHandleWord.allCases {
            io.write(word, value: UInt32(word.rawValue) * 17)
            XCTAssertEqual(alias.read(word), UInt32(word.rawValue) * 17)
            XCTAssertEqual(storage[word.rawValue + 1], UInt32(word.rawValue) * 17)
            storage[word.rawValue + 1] = 0x1234_5678
            XCTAssertEqual(io.read(word), 0x1234_5678)
        }
        XCTAssertEqual(storage[0], 0xA5A5_A5A5); XCTAssertEqual(storage[20], 0xA5A5_A5A5)
    }
    func testLPTIMCallbackSlotsUseNativePointersAndZeroBasedIDs() {
        let storage = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 18)
        storage.initialize(repeating: 0)
        storage[0] = 0x1234; storage[17] = 0x5678
        let context = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        context.initialize(to: 0)
        defer { storage.deallocate(); context.deallocate() }
        let io = STM32LPTIMCallbackRegisters(storage: .init(rebasing: storage[1..<17]), context: context)
        let callback: LPTIMCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in LPTIMCallbackID.allCases {
            XCTAssertNil(io.read(id))
            io.write(id, value: callback)
            XCTAssertEqual(storage[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            io.read(id)!(io.context)
            io.write(id, value: nil)
            XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(context.pointee, 16)
        XCTAssertEqual(storage[0], 0x1234); XCTAssertEqual(storage[17], 0x5678)
    }
}
