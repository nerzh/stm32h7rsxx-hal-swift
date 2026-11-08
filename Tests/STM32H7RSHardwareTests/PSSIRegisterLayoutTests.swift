import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

extension RegisterLayoutTests {
    func testPSSIRegistersAndDataWidthsUseCMSISAddresses() {
        let io = STM32PSSIRegisters()
        let offsets: [UInt] = [0,4,8,12,16,20,40]
        for (r,o) in zip(PSSIRegister.allCases, offsets) { XCTAssertEqual(io.address(of: r), 0x48000400 + o) }
        XCTAssertEqual(io.dataAddress(), 0x48000428)
    }
    func testPSSIHandleAndBufferPointerStorageIsSharedAndDisjoint() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 13)
        let pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 3)
        words.initialize(repeating: .max); pointers.initialize(repeating: 0xABCD)
        defer { words.deallocate(); pointers.deallocate() }
        let io = STM32PSSIHandleRegisters(storage: .init(rebasing: words[1..<12]), bufferPointer: pointers.baseAddress! + 1), alias = io
        XCTAssertEqual(PSSIHandleWord.allCases.count, 11)
        for word in PSSIHandleWord.allCases {
            io.write(word, value: UInt32(word.rawValue)); XCTAssertEqual(alias.read(word), UInt32(word.rawValue))
            XCTAssertEqual(words[word.rawValue + 1], UInt32(word.rawValue))
        }
        let address = UnsafeMutableRawPointer(bitPattern: 0x12345678)
        io.writeBuffer(address); XCTAssertEqual(alias.readBuffer(), address); XCTAssertEqual(pointers[1], 0x12345678)
        io.writeBuffer(nil); XCTAssertNil(alias.readBuffer()); XCTAssertEqual(pointers[1], 0)
        XCTAssertEqual(words[0], .max); XCTAssertEqual(words[12], .max)
        XCTAssertEqual(pointers[0], 0xABCD); XCTAssertEqual(pointers[2], 0xABCD)
    }
    func testPSSICallbackStoragePreservesSparseIDGapAndSentinels() {
        let pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 9)
        let counter = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        pointers.initialize(repeating: 0); counter.initialize(to: 0)
        pointers[0] = 0x1234; pointers[3] = 0xABCD; pointers[8] = 0x5678
        defer { pointers.deallocate(); counter.deallocate() }
        let io = STM32PSSICallbackRegisters(storage: .init(rebasing: pointers[1..<8]), context: counter)
        let callback: PSSICallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        XCTAssertEqual(PSSICallbackID.allCases.map(\.rawValue), [0,1,3,4,5,6])
        for id in PSSICallbackID.allCases {
            XCTAssertNil(io.read(id)); io.write(id, value: callback)
            XCTAssertEqual(pointers[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            io.read(id)!(io.context); io.write(id, value: nil); XCTAssertNil(io.read(id))
        }
        XCTAssertEqual(counter.pointee, 6); XCTAssertEqual(pointers[3], 0xABCD)
        XCTAssertEqual(pointers[0], 0x1234); XCTAssertEqual(pointers[8], 0x5678)
    }
}
