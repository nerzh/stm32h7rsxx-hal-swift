import XCTest
@testable import STM32H7RSHAL

private final class JPEGRegisterTrace: JPEGRegisterIO {
    enum Event: Equatable { case read(JPEGRegister), write(JPEGRegister,UInt32), readTable(JPEGTable,Int), writeTable(JPEGTable,Int,UInt32) }
    let model: JPEGModel
    var events: [Event] = []
    var statuses: [UInt32] = []
    init(_ model: JPEGModel) { self.model = model }
    func read(_ register: JPEGRegister) -> UInt32 { events.append(.read(register)); if register == .sr && !statuses.isEmpty { return statuses.removeFirst() }; return model.read(register) }
    func write(_ register: JPEGRegister,value:UInt32) { events.append(.write(register,value)); model.write(register,value:value) }
    func readTable(_ table: JPEGTable,index:Int) -> UInt32 { events.append(.readTable(table,index)); return model.readTable(table,index:index) }
    func writeTable(_ table: JPEGTable,index:Int,value:UInt32) { events.append(.writeTable(table,index,value)); model.writeTable(table,index:index,value:value) }
    func dataAddress(_ stream: JPEGStream) -> UInt32 { model.dataAddress(stream) }
    var driver: JPEG<JPEGRegisterTrace,JPEGModel,JPEGModel,JPEGModel> { .init(registers:self,handle:model,callbacks:model,dma:model,defaults:model.driver.defaults) }
}
final class JPEGAccessTests: XCTestCase {
    func testInitializationClearsStartAndRequestsBeforeFlushingAndAcknowledging() {
        let pair = JPEGPair(), io = JPEGRegisterTrace(.init(state:pair.actual))
        XCTAssertEqual(io.driver.initialize(),.ok)
        XCTAssertEqual(Array(io.events.prefix(14)),[.read(.cr),.write(.cr,1),.read(.confr0),.write(.confr0,0),.read(.cr),.write(.cr,1),.read(.cr),.write(.cr,1),.read(.cr),.write(.cr,0x2001),.read(.cr),.write(.cr,0x6001),.read(.cfr),.write(.cfr,0x60)])
        io.events=[]; XCTAssertEqual(io.driver.deinitialize(),.ok); XCTAssertTrue(io.events.isEmpty)
    }
    func testDHTSharedWordsAreReadModifiedWrittenInSourceOrder() {
        let pair = JPEGPair(), io = JPEGRegisterTrace(.init(state:pair.actual))
        io.driver.setDHTMemory()
        let reads = io.events.compactMap { event -> Int? in if case .readTable(.dht,let index) = event { return index }; return nil }
        XCTAssertEqual(reads,[51,51,55,55,58,58,62,62])
        for (i,event) in io.events.enumerated() { if case .readTable(let table,let index) = event { if case .writeTable(let nextTable,let nextIndex,_) = io.events[i+1] { XCTAssertEqual(table,nextTable); XCTAssertEqual(index,nextIndex) } else { XCTFail("Table read must be followed by its write") } } }
        let writes = io.events.compactMap { event -> Int? in if case .writeTable(.dht,let index,_) = event { return index }; return nil }
        XCTAssertEqual(Array(writes.prefix(11)),[3,2,1,0,6,5,4,10,9,8,7]); XCTAssertEqual(Set(writes),Set(0...102))
    }
    func testProcessUsesSingleStatusSnapshotAndFlagsClearUsesReadModifyWrite() {
        let pair = JPEGPair(), io = JPEGRegisterTrace(.init(state:pair.actual))
        io.model.write(.state,value:3); io.model.write(.context,value:9); io.statuses=[0,0x20]
        io.driver.handleInterrupt(); XCTAssertEqual(io.events,[.read(.sr)]); XCTAssertEqual(io.model.read(.state),3)
        io.events=[]; io.model.write(.cfr,value:0x100); io.driver.clearFlags(.max)
        XCTAssertEqual(io.events,[.read(.cfr),.write(.cfr,0x160)])
    }
    func testHuffmanRejectsOversubscribedAndOutOfRangeTablesBeforeInvalidStore() {
        let pair = JPEGPair(), d = JPEGModel(state:pair.actual).driver
        var stores = 0
        for isAC in [false,true] {
            XCTAssertEqual(d.makeHuffmanCodes(isAC:isAC,bits:{ $0 == 0 ? 2 : 0 },symbols:{ _ in 0 },store:{ _,_,_ in stores += 1 }),.error)
            XCTAssertEqual(d.makeHuffmanCodes(isAC:isAC,bits:{ $0 < 2 ? 255 : 0 },symbols:{ _ in 0 },store:{ _,_,_ in stores += 1 }),.error)
            XCTAssertEqual(d.makeHuffmanCodes(isAC:isAC,bits:{ $0 == 1 ? 1 : 0 },symbols:{ _ in isAC ? 0xFF : 12 },store:{ _,_,_ in stores += 1 }),.error)
        }
        XCTAssertEqual(stores,0)
        var codes: [(Int,UInt32,UInt8)] = []
        XCTAssertEqual(d.makeHuffmanCodes(isAC:true,bits:{ $0 == 1 ? 3 : 0 },symbols:{ [0,0xF0,0xF1][$0] },store:{ codes.append(($0,$1,$2)) }),.ok)
        XCTAssertEqual(codes.map { $0.0 },[160,161,150]); XCTAssertEqual(codes.map { $0.1 },[0,1,2]); XCTAssertEqual(codes.map { $0.2 },[1,1,1])
    }
}
