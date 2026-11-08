import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class FDCANRegisterLayoutTests: XCTestCase {
    func testBothInstancesCommonDividerAndMessageRAM() {
        for instance in FDCANInstance.allCases {
            let io=STM32FDCANRegisters(instance:instance)
            for register in FDCANRegister.allCases {
                XCTAssertEqual(io.address(of:register),0x4000A000+UInt(instance.rawValue)*0x400+UInt(register.rawValue))
            }
            XCTAssertEqual(io.clockDividerAddress(),0x4000A100)
            XCTAssertEqual(io.messageRAMBase(),0x4000AC00)
        }
    }
    func testTwentySevenCallerOwnedHandleWords() {
        let storage=UnsafeMutableBufferPointer<UInt32>.allocate(capacity:29)
        storage.initialize(repeating:0xDEADBEEF);defer {storage.deallocate()}
        let io=STM32FDCANHandleRegisters(storage:.init(rebasing:storage[1..<28]))
        for word in FDCANHandleWord.allCases {
            let value=UInt32(word.rawValue)+0x98760000;io.write(word,value:value)
            XCTAssertEqual(io.read(word),value);XCTAssertEqual(storage[word.rawValue+1],value)
        }
        XCTAssertEqual(storage[0],0xDEADBEEF);XCTAssertEqual(storage[28],0xDEADBEEF)
    }
    func testThirteenCallbackSlotsForwardContextAndEventMask() {
        let storage=UnsafeMutableBufferPointer<UInt>.allocate(capacity:15)
        storage.initialize(repeating:0);storage[0]=123;storage[14]=456;defer {storage.deallocate()}
        var sum:UInt32=0
        withUnsafeMutablePointer(to:&sum) {p in
            let io=STM32FDCANCallbackRegisters(storage:.init(rebasing:storage[1..<14]),context:p)
            let callback:FDCANCallback = {p,mask in p!.assumingMemoryBound(to:UInt32.self).pointee &+= mask}
            for id in FDCANCallbackID.allCases {
                XCTAssertNil(io.read(id));io.write(id,value:callback);io.read(id)!(io.context,1<<id.rawValue)
                XCTAssertEqual(storage[Int(id.rawValue)+1],unsafeBitCast(callback,to:UInt.self))
                io.write(id,value:nil);XCTAssertNil(io.read(id))
            }
        }
        XCTAssertEqual(sum,0x1FFF);XCTAssertEqual(storage[0],123);XCTAssertEqual(storage[14],456)
    }
}
