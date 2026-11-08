import XCTest
import STM32H7RSHAL

private func jpegBridgeReadParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    let channel = Unmanaged<JPEGBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
    channel.parentReads += 1
    return channel.parent
}
private func jpegBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ event: UInt32) {
    let result = parent!.assumingMemoryBound(to: UInt.self)
    result[0] = UInt(event); result[1] = UInt(bitPattern:source)
}
private final class JPEGBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel = DMAChannel(controller: .gpdma1, index: 0)
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var slots: [DMACallbackID: DMACallback] = [:]
  var memory: [UInt32: UInt32] = [:]
  var parent: UnsafeMutableRawPointer?
  var parentReads = 0
  var registerReads: [DMARegister] = []
  let descriptor = UnsafeMutablePointer<JPEGDMACallbackContext>.allocate(capacity: 1)
  init() {
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: jpegBridgeReadParent, dispatch: jpegBridgeDispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  var dma: DMA<JPEGBridgeChannel, JPEGBridgeChannel, JPEGBridgeChannel, JPEGBridgeChannel> {
    .init(registers: self, handle: self, callbacks: self, memory: self)
  }
  func read(_ register: DMARegister) -> UInt32 { registerReads.append(register); return registers[register, default: 0] }
  func write(_ register: DMARegister, value: UInt32) { registers[register] = value }
  func read(_ word: DMAHandleWord) -> UInt32 { words[word, default: 0] }
  func write(_ word: DMAHandleWord, value: UInt32) { words[word] = value }
  func read(_ id: DMACallbackID) -> DMACallback? { slots[id] }
  func write(_ id: DMACallbackID, value: DMACallback?) { slots[id] = value }
  func readParent() -> UnsafeMutableRawPointer? { parent }
  func writeParent(_ value: UnsafeMutableRawPointer?) { parent = value }
  func read32(at address: UInt32) -> UInt32 { memory[address, default: 0] }
  func write32(at address: UInt32, value: UInt32) { memory[address] = value }
}


final class JPEGDMALinksTests: XCTestCase {
    func testBothStreamsDelegateStartsCountersMemoryAndAbortsToExistingDMA() {
        let input = JPEGBridgeChannel(), output = JPEGBridgeChannel(), link = JPEGDMALinks(input:input.dma,output:output.dma)
        for (stream,channel) in [(JPEGStream.input,input),(.output,output)] {
            XCTAssertEqual(link.startInterrupt(stream,sourceAddress:0x24001000,destinationAddress:0x52003040,sourceDataSize:16),.ok)
            XCTAssertEqual(channel.registers[.csar],0x24001000); XCTAssertEqual(channel.registers[.cdar],0x52003040); XCTAssertEqual(link.getCounter(stream),16)
            channel.registers[.csr]=0x2000; XCTAssertEqual(link.abort(stream,getTick:{0}),.ok); XCTAssertEqual(channel.words[.state],1)
            link.writeMemory32(stream,at:0x1000,value:0x2000); XCTAssertEqual(link.readMemory32(stream,at:0x1000),0x2000)
            channel.registers[.cbr1]=0xABCD1234; XCTAssertEqual(link.getCounter(stream),0x1234)
            channel.registers[.csr]=0x560000; XCTAssertEqual(link.getFIFOLevel(stream),0x56)
            channel.words[.errorCode]=0x10; XCTAssertEqual(channel.dma.getError().rawValue,0x10)
        }
    }
    func testThunksReadLiveParentAndPassActualSourceWithoutReadingCounters() {
        let channel = JPEGBridgeChannel(), link = JPEGDMALinks(input:JPEGBridgeChannel().dma)
        let first = UnsafeMutablePointer<UInt>.allocate(capacity:2), second = UnsafeMutablePointer<UInt>.allocate(capacity:2)
        first.initialize(repeating:.max,count:2); second.initialize(repeating:.max,count:2)
        defer { first.deallocate(); second.deallocate() }
        for kind in JPEGDMACallbackKind.allCases {
            for pointer in [first,second] {
                channel.parent=UnsafeMutableRawPointer(pointer); link.callback(kind)(channel.context)
                XCTAssertEqual(pointer[0],UInt(kind.rawValue)); XCTAssertEqual(pointer[1],UInt(bitPattern:Unmanaged.passUnretained(channel).toOpaque()))
            }
        }
        XCTAssertEqual(channel.parentReads,8); XCTAssertTrue(channel.registerReads.isEmpty)
    }
}
