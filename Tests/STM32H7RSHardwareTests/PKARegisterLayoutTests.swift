import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class PKARegisterLayoutTests: XCTestCase {
    func testRegistersAndAll1334RAMWords() {
        let io=STM32PKARegisters()
        for register in PKARegister.allCases { XCTAssertEqual(io.address(of:register),0x48022000+UInt(register.rawValue)) }
        for index: UInt32 in 0..<1334 { XCTAssertEqual(io.ramAddress(index),0x48022400+UInt(index)*4) }
        XCTAssertEqual(io.ramAddress(1333),0x480238D4)
    }
    func testFiveHandleWordsAndVolatileCallerBuffers() {
        let words=UnsafeMutableBufferPointer<UInt32>.allocate(capacity:7)
        words.initialize(repeating:0xDEADBEEF);defer {words.deallocate()}
        let handle=STM32PKAHandleRegisters(storage:.init(rebasing:words[1..<6]))
        let registers=STM32PKARegisters()
        for word in PKAHandleWord.allCases {
            let value=UInt32(word.rawValue)+0x12340000
            handle.write(word,value:value)
            XCTAssertEqual(handle.read(word),value);XCTAssertEqual(words[word.rawValue+1],value)
            XCTAssertEqual(registers.readOperandWord(words.baseAddress!.advanced(by:word.rawValue+1)),value)
            registers.writeResultWord(words.baseAddress!.advanced(by:word.rawValue+1),value:value+7)
            XCTAssertEqual(handle.read(word),value+7)
        }
        XCTAssertEqual(words[0],0xDEADBEEF);XCTAssertEqual(words[6],0xDEADBEEF)
    }
    func testFourNativeWidthCallbackSlots() {
        let slots=UnsafeMutableBufferPointer<UInt>.allocate(capacity:6)
        slots.initialize(repeating:0);slots[0]=123;slots[5]=456;defer {slots.deallocate()}
        var calls: UInt32=0
        withUnsafeMutablePointer(to:&calls) {context in
            let io=STM32PKACallbackRegisters(storage:.init(rebasing:slots[1..<5]),context:context)
            let callback: PKACallback = {$0!.assumingMemoryBound(to:UInt32.self).pointee+=1}
            for id in PKACallbackID.allCases {
                XCTAssertNil(io.read(id));io.write(id,value:callback)
                XCTAssertEqual(slots[Int(id.rawValue)+1],unsafeBitCast(callback,to:UInt.self))
                io.read(id)!(io.context);io.write(id,value:nil);XCTAssertNil(io.read(id))
            }
        }
        XCTAssertEqual(calls,4);XCTAssertEqual(slots[0],123);XCTAssertEqual(slots[5],456)
    }
}
