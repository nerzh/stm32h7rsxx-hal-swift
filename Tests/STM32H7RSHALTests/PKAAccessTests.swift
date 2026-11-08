import XCTest
import STM32H7RSHAL

private final class PKAAccessIO: PKARegisterIO {
    let model: PKAModel
    var accesses: [String]=[]
    var changingReads: [UInt32]=[]
    init(_ model: PKAModel) { self.model=model }
    func read(_ register: PKARegister) -> UInt32 { accesses.append("r\(register.rawValue)");return model.read(register) }
    func write(_ register: PKARegister, value: UInt32) { accesses.append("w\(register.rawValue):\(value)");model.write(register,value:value) }
    func readRAM(_ index: UInt32) -> UInt32 {
        accesses.append("ramR\(index)")
        return changingReads.isEmpty ? model.readRAM(index) : changingReads.removeFirst()
    }
    func writeRAM(_ index: UInt32, value: UInt32) { accesses.append("ramW\(index):\(value)");model.writeRAM(index,value:value) }
    func readOperandWord(_ pointer: UnsafePointer<UInt32>) -> UInt32 { accesses.append("operandR");return pointer.pointee }
    func writeResultWord(_ pointer: UnsafeMutablePointer<UInt32>, value: UInt32) { accesses.append("resultW");pointer.pointee=value }
    var driver: PKA<PKAAccessIO,PKAModel,PKAModel> { .init(registers:self,handle:model,callbacks:model,defaults:model.defaults) }
}
final class PKAAccessTests: XCTestCase {
    func testEachOutputByteObservesItsOwnVolatileRead() {
        let pair=PKAPair();let io=PKAAccessIO(pair.swift)
        io.changingReads=[0x01020304,0x11121314,0x21222324,0x31323334,0x41424344,0x51525354,0x61626364]
        var bytes=[UInt8](repeating:0,count:7)
        bytes.withUnsafeMutableBufferPointer {io.driver.readBytes(fromRAM:100,to:$0.baseAddress,count:7)}
        XCTAssertEqual(bytes,[0x62,0x53,0x44,0x31,0x22,0x13,0x04])
        XCTAssertEqual(io.accesses,Array(repeating:"ramR100",count:4)+Array(repeating:"ramR101",count:3))
    }
    func testWordCopiesInterleaveVolatileLoadAndStore() {
        let pair=PKAPair();let io=PKAAccessIO(pair.swift)
        let input: [UInt32]=[0x12345678,0xAABBCCDD,0x76543210]
        input.withUnsafeBufferPointer {io.driver.writeWords(toRAM:100,from:$0.baseAddress,count:3)}
        XCTAssertEqual(io.accesses,["operandR","ramW100:305419896","operandR","ramW101:2864434397","operandR","ramW102:1985229328"])
        io.accesses=[]
        var output=[UInt32](repeating:0,count:3)
        output.withUnsafeMutableBufferPointer {io.driver.readWords(fromRAM:100,to:$0.baseAddress,count:3)}
        XCTAssertEqual(output,input);XCTAssertEqual(io.accesses,["ramR100","resultW","ramR101","resultW","ramR102","resultW"])
    }
    func testErrorCheckUsesThreeStatusReadsAndModeSpecificRAMRead() {
        let pair=PKAPair();let io=PKAAccessIO(pair.swift)
        XCTAssertEqual(io.driver.checkError(mode:0x24),0)
        XCTAssertEqual(io.accesses,["r4","r4","r4","ramR760"])
        io.accesses=[];XCTAssertEqual(io.driver.checkError(mode:9),0)
        XCTAssertEqual(io.accesses,["r4","r4","r4"])
    }
    func testIRQFlagsAreAcknowledgedByDirectWritesInCOrder() {
        let pair=PKAPair();let io=PKAAccessIO(pair.swift)
        pair.set(0,0,0x3A0000);pair.set(0,1,0x3A0000);io.driver.handleInterrupt()
        XCTAssertEqual(io.accesses,["r0","r0","r4","w8:1048576","w8:524288","w8:2097152","w8:131072"])
    }
    func testNilArithmeticResultStillReadsSizeAndCarry() {
        let pair=PKAPair();let io=PKAAccessIO(pair.swift)
        pair.set(0,0,9<<8);pair.set(1,2,64)
        io.driver.getArithmeticResult(nil)
        XCTAssertEqual(io.accesses,["r0","ramR2","ramR672"])
    }
}
