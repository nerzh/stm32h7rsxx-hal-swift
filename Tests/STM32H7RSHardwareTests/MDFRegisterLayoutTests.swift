import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class MDFRegisterLayoutTests: XCTestCase {
    func testRegisterAddressesAndDMAEndpoint() {
        let io = STM32MDFRegisters()
        for register in MDFRegister.allCases { XCTAssertEqual(io.address(of: register), 0x4002F000 + UInt(register.rawValue)) }
        XCTAssertEqual(io.dataAddress(), 0x4002F0F0)
    }
    func testHandleIdentityAndSharedOwnerUseNativeWidthAndPreserveGuards() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 16), owners = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 3)
        words.initialize(repeating: 0xABCD0000); owners.initialize(repeating: 123)
        defer { words.deallocate(); owners.deallocate() }
        let handle = STM32MDFHandleRegisters(storage: .init(rebasing: words[1..<15]))
        let first = STM32MDFSharedRegisters(registeredHandle: owners.baseAddress! + 1), second = STM32MDFSharedRegisters(registeredHandle: owners.baseAddress! + 1)
        XCTAssertEqual(handle.identity,UInt(bitPattern: words.baseAddress! + 1))
        for word in MDFHandleWord.allCases { handle.write(word,value:UInt32(word.rawValue) | 0xFEDC0000); XCTAssertEqual(handle.read(word),UInt32(word.rawValue) | 0xFEDC0000) }
        first.writeRegisteredHandle(handle.identity); XCTAssertEqual(second.readRegisteredHandle(),handle.identity)
        second.writeRegisteredHandle(0); XCTAssertEqual(first.readRegisteredHandle(),0)
        XCTAssertEqual(words[0],0xABCD0000); XCTAssertEqual(words[15],0xABCD0000); XCTAssertEqual(owners[0],123); XCTAssertEqual(owners[2],123)
    }
    func testCallbackSlotsPreserveBothSignaturesAndArguments() {
        let slots = UnsafeMutableBufferPointer<UInt>.allocate(capacity: 10), values = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: 3)
        slots.initialize(repeating: 0); values.initialize(repeating: 0); slots[0] = 123; slots[9] = 456
        defer { slots.deallocate(); values.deallocate() }
        let io = STM32MDFCallbackRegisters(storage: .init(rebasing: slots[1..<9]),context: values.baseAddress!)
        let callback: MDFCallback = { $0!.assumingMemoryBound(to: UInt32.self)[0] += 1 }
        for id in MDFCallbackID.allCases where id != .soundLevel {
            XCTAssertNil(io.read(id)); io.write(id,value:callback)
            XCTAssertEqual(slots[Int(id.rawValue)+1],unsafeBitCast(callback,to:UInt.self))
            io.read(id)!(io.context); io.write(id,value:nil); XCTAssertNil(io.read(id))
        }
        let sound: MDFSoundLevelCallback = { $0!.assumingMemoryBound(to:UInt32.self)[1] = $1; $0!.assumingMemoryBound(to:UInt32.self)[2] = $2 }
        XCTAssertNil(io.readSoundLevel()); io.writeSoundLevel(sound)
        XCTAssertEqual(slots[4],unsafeBitCast(sound,to:UInt.self)); io.readSoundLevel()!(io.context,0x12345678,0x87654321)
        io.writeSoundLevel(nil); XCTAssertNil(io.readSoundLevel())
        XCTAssertEqual(Array(values),[6,0x12345678,0x87654321]); XCTAssertEqual(slots[0],123); XCTAssertEqual(slots[1],0); XCTAssertEqual(slots[9],456)
    }
}
