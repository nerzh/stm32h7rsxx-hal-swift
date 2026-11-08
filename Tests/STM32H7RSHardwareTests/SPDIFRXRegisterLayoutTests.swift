import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class SPDIFRXRegisterLayoutTests: XCTestCase {
    func testRegisterAddressesAndBothDMAEndpoints() {
        let io = STM32SPDIFRXRegisters()
        for register in SPDIFRXRegister.allCases { XCTAssertEqual(io.address(of: register), 0x40004000 + UInt(register.rawValue)) }
        XCTAssertEqual(io.dataAddress(.data), 0x40004010); XCTAssertEqual(io.dataAddress(.control), 0x40004014)
    }
    func testHandleHalfwordCountersAndNativeBufferPointersPreserveGuards() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 21), pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 4)
        let data = UnsafeMutablePointer<UInt32>.allocate(capacity: 2)
        words.initialize(repeating: 0xABCD0000); pointers.initialize(repeating: 0)
        defer { words.deallocate(); pointers.deallocate(); data.deallocate() }
        pointers[0] = 123; pointers[3] = 456
        let io = STM32SPDIFRXHandleRegisters(storage: .init(rebasing: words[1..<20]), bufferPointers: .init(rebasing: pointers[1..<3]))
        for word in SPDIFRXHandleWord.allCases {
            io.write(word, value: 0xFEDC1234)
            let half = (12...15).contains(word.rawValue)
            XCTAssertEqual(io.read(word), half ? 0x1234 : 0xFEDC1234)
            XCTAssertEqual(words[word.rawValue + 1], half ? 0xABCD1234 : 0xFEDC1234)
        }
        for stream in SPDIFRXStream.allCases {
            XCTAssertNil(io.readBuffer(stream)); io.writeBuffer(stream, value: data + Int(stream.rawValue))
            XCTAssertEqual(io.readBuffer(stream), data + Int(stream.rawValue)); io.writeBuffer(stream, value: nil)
            XCTAssertNil(io.readBuffer(stream))
        }
        XCTAssertEqual(words[0], 0xABCD0000); XCTAssertEqual(words[20], 0xABCD0000)
        XCTAssertEqual(pointers[0], 123); XCTAssertEqual(pointers[3], 456)
    }
    func testCallbackSlotsUseNativeWidthAndCorrectIDs() {
        let slots = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 9)
        slots.initialize(repeating: 0); slots[0] = 123; slots[8] = 456
        let counter = UnsafeMutablePointer<UInt32>.allocate(capacity: 1); counter.initialize(to: 0)
        defer { slots.deallocate(); counter.deallocate() }
        let io = STM32SPDIFRXCallbackRegisters(storage: .init(rebasing: slots[1..<8]), context: counter)
        let callback: SPDIFRXCallback = { $0!.assumingMemoryBound(to: UInt32.self).pointee &+= 1 }
        for id in SPDIFRXCallbackID.allCases {
            XCTAssertNil(io.read(id)); io.write(id, value: callback)
            XCTAssertEqual(slots[Int(id.rawValue) + 1], unsafeBitCast(callback, to: UInt.self))
            io.read(id)!(io.context); io.write(id, value: nil)
        }
        XCTAssertEqual(counter.pointee, 7); XCTAssertEqual(slots[0], 123); XCTAssertEqual(slots[8], 456)
    }
}
