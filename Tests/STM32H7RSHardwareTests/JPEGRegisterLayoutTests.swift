import XCTest
import STM32H7RSHAL
@testable import STM32H7RSHardware

final class JPEGRegisterLayoutTests: XCTestCase {
    func testAllRegisterAndTableAddressesMatchCMSISIncludingSVDCorrections() {
        let io = STM32JPEGRegisters()
        for register in JPEGRegister.allCases { XCTAssertEqual(io.address(of: register), 0x52003000 + UInt(register.rawValue)) }
        let offsets: [(JPEGTable, UInt, Int)] = [(.quantization0,0x50,16),(.quantization1,0x90,16),(.quantization2,0xD0,16),(.quantization3,0x110,16),(.huffmanMinimum,0x150,16),(.huffmanBase,0x190,32),(.huffmanSymbols,0x210,84),(.dht,0x360,103),(.ac0,0x500,88),(.ac1,0x660,88),(.dc0,0x7C0,8),(.dc1,0x7E0,8)]
        for (table, offset, count) in offsets {
            XCTAssertEqual(table.wordCount,count)
            for i in 0..<count { XCTAssertEqual(io.address(of: table,index:i),0x52003000 + offset + UInt(i)*4) }
        }
        XCTAssertEqual(io.dataAddress(.input),0x52003040); XCTAssertEqual(io.dataAddress(.output),0x52003044)
    }
    func testHandleBytePaddingNativePointersAndLiveConfiguration() {
        let words = UnsafeMutableBufferPointer<UInt32>.allocate(capacity:16), pointers = UnsafeMutableBufferPointer<UInt>.allocate(capacity:8)
        words.initialize(repeating:0xABCD0000); pointers.initialize(repeating:123)
        defer { words.deallocate(); pointers.deallocate() }
        let io = STM32JPEGHandleRegisters(storage:.init(rebasing:words[1..<15]),pointers:.init(rebasing:pointers[1..<7]))
        for field in JPEGHandleWord.allCases {
            io.write(field,value:0x12340000 | UInt32(field.rawValue)); let expected = field == .customQuantizationTable ? 9 : 0x12340000 | UInt32(field.rawValue)
            XCTAssertEqual(io.read(field),expected)
        }
        XCTAssertEqual(words[10],0xABCD0009); XCTAssertEqual(io.configurationPointer,words.baseAddress!+1)
        io.configurationPointer[4] = 75; XCTAssertEqual(io.read(.imageQuality),75)
        for stream in JPEGStream.allCases { let pointer = UnsafeMutablePointer<UInt8>(bitPattern:UInt(bitPattern:words.baseAddress!)+UInt(stream.rawValue))!; io.writeBuffer(stream,value:pointer); XCTAssertEqual(io.readBuffer(stream),pointer); XCTAssertEqual(pointers[Int(stream.rawValue)+1],UInt(bitPattern:pointer)); io.writeBuffer(stream,value:nil); XCTAssertNil(io.readBuffer(stream)) }
        for i in 0..<4 { let pointer = UnsafeRawPointer(words.baseAddress!+i).assumingMemoryBound(to:UInt8.self); io.writeQuantizationTable(i,value:pointer); XCTAssertEqual(io.readQuantizationTable(i),pointer); XCTAssertEqual(pointers[i+3],UInt(bitPattern:pointer)); io.writeQuantizationTable(i,value:nil); XCTAssertNil(io.readQuantizationTable(i)) }
        XCTAssertEqual(words[0],0xABCD0000); XCTAssertEqual(words[15],0xABCD0000); XCTAssertEqual(pointers[0],123); XCTAssertEqual(pointers[7],123)
    }
    func testCallbackSlotsKeepDistinctSignaturesAndPointerArguments() {
        let slots = UnsafeMutableBufferPointer<UInt>.allocate(capacity:11), result = UnsafeMutableBufferPointer<UInt>.allocate(capacity:5)
        slots.initialize(repeating:0); result.initialize(repeating:0); slots[0]=123; slots[10]=456
        defer { slots.deallocate(); result.deallocate() }
        let io = STM32JPEGCallbackRegisters(storage:.init(rebasing:slots[1..<10]),context:result.baseAddress!)
        let callback: JPEGCallback = { $0!.assumingMemoryBound(to:UInt.self)[0] += 1 }
        for id in JPEGCallbackID.allCases { XCTAssertNil(io.read(id)); io.write(id,value:callback); XCTAssertEqual(slots[Int(id.rawValue)+1],unsafeBitCast(callback,to:UInt.self)); io.read(id)!(io.context); io.write(id,value:nil); XCTAssertNil(io.read(id)) }
        let info: JPEGInfoReadyCallback = { $0!.assumingMemoryBound(to:UInt.self)[1] = UInt(bitPattern:$1) }
        let get: JPEGGetDataCallback = { $0!.assumingMemoryBound(to:UInt.self)[2] = UInt($1) }
        let data: JPEGDataReadyCallback = { $0!.assumingMemoryBound(to:UInt.self)[3] = UInt(bitPattern:$1); $0!.assumingMemoryBound(to:UInt.self)[4] = UInt($2) }
        XCTAssertNil(io.readInfoReady()); XCTAssertNil(io.readGetData()); XCTAssertNil(io.readDataReady())
        io.writeInfoReady(info); io.writeGetData(get); io.writeDataReady(data)
        XCTAssertEqual(slots[7],unsafeBitCast(info,to:UInt.self)); XCTAssertEqual(slots[8],unsafeBitCast(get,to:UInt.self)); XCTAssertEqual(slots[9],unsafeBitCast(data,to:UInt.self))
        let pointer = UnsafeMutableRawPointer(result.baseAddress!)
        io.readInfoReady()!(io.context,pointer.assumingMemoryBound(to:UInt32.self)); io.readGetData()!(io.context,0x12345678); io.readDataReady()!(io.context,pointer.assumingMemoryBound(to:UInt8.self),0x87654321)
        XCTAssertEqual(Array(result),[5,UInt(bitPattern:pointer),0x12345678,UInt(bitPattern:pointer),0x87654321])
        io.writeInfoReady(nil); io.writeGetData(nil); io.writeDataReady(nil)
        XCTAssertNil(io.readInfoReady()); XCTAssertNil(io.readGetData()); XCTAssertNil(io.readDataReady())
        XCTAssertEqual(slots[0],123); XCTAssertEqual(slots[1],0); XCTAssertEqual(slots[10],456)
    }
}
