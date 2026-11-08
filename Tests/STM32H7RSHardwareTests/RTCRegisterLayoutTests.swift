import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class RTCRegisterLayoutTests: XCTestCase {
    func testAllRTCAndTamperAddressesIncludingMissingRPCFGR() {
        let io = STM32RTCRegisters()
        for register in RTCRegister.allCases { XCTAssertEqual(io.address(of: register),0x58004000 + UInt(register.rawValue)) }
        for register in RTCTamperRegister.allCases { XCTAssertEqual(io.address(of: register),0x58004400 + UInt(register.rawValue)) }
        for index: UInt32 in 0..<32 { XCTAssertEqual(io.backupAddress(index),0x58004500 + UInt(index)*4) }
    }
    func testHandleSlotsAndLegacyInstanceRead() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity:14)
        words.initialize(repeating:0xDEADBEEF)
        defer { words.deallocate() }
        let handle = STM32RTCHandleRegisters(storage:.init(rebasing:words[1..<13]))
        for word in RTCHandleWord.allCases {
            handle.write(word,value:0x12340000 | UInt32(word.rawValue))
            XCTAssertEqual(handle.read(word),words[word.rawValue+1])
            XCTAssertEqual(words[word.rawValue+1],0x12340000 | UInt32(word.rawValue))
        }
        XCTAssertEqual(words[0],0xDEADBEEF); XCTAssertEqual(words[13],0xDEADBEEF)
        let registers = STM32RTCRegisters(legacyInstanceAddress:UInt(bitPattern:words.baseAddress!))
        XCTAssertEqual(registers.readInstanceInitializationStatus(),words[3])
    }
    func testAllCallbackSlotsUseNativePointerWidth() {
        let slots = UnsafeMutableBufferPointer<UInt>.allocate(capacity:28)
        slots.initialize(repeating:0); slots[0]=123; slots[27]=456
        defer { slots.deallocate() }
        var count: UInt32 = 0
        withUnsafeMutablePointer(to:&count) { context in
            let io = STM32RTCCallbackRegisters(storage:.init(rebasing:slots[1..<27]),context:context)
            let callback: RTCCallback = { $0!.assumingMemoryBound(to:UInt32.self).pointee += 1 }
            for id in RTCCallbackID.allCases {
                XCTAssertNil(io.read(id)); io.write(id,value:callback)
                XCTAssertEqual(slots[Int(id.rawValue)+1],unsafeBitCast(callback,to:UInt.self))
                io.read(id)!(io.context); io.write(id,value:nil); XCTAssertNil(io.read(id))
            }
        }
        XCTAssertEqual(count,26); XCTAssertEqual(slots[0],123); XCTAssertEqual(slots[27],456)
    }
}
