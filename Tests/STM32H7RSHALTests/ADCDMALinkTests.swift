import XCTest
import STM32H7RSHAL

private func adcBridgeParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    let channel = Unmanaged<ADCBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
    channel.parentReads += 1; return channel.parent
}
private func adcBridgeWidth(_ context: UnsafeMutableRawPointer?) -> UInt32 {
    Unmanaged<ADCBridgeChannel>.fromOpaque(context!).takeUnretainedValue().sourceWidth
}
private func adcBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ event: UInt32, _ incoming: UnsafeMutableRawPointer?) {
    let result = parent!.assumingMemoryBound(to: UInt.self)
    result[0] = UInt(event); result[1] = UInt(bitPattern: incoming)
}
private final class ADCBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
    let channel = DMAChannel(controller: .gpdma1, index: 0)
    var registers: [DMARegister: UInt32] = [:]
    var words: [DMAHandleWord: UInt32] = [.state: 1]
    var slots: [DMACallbackID: DMACallback] = [:]
    var memory: [UInt32: UInt32] = [:]
    var parent: UnsafeMutableRawPointer?
    var parentReads = 0
    var sourceWidth: UInt32 = 2
    let descriptor = UnsafeMutablePointer<ADCDMACallbackContext>.allocate(capacity: 1)
    init() {
        descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(), readParent: adcBridgeParent, dispatch: adcBridgeDispatch))
    }
    deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
    var dma: DMA<ADCBridgeChannel,ADCBridgeChannel,ADCBridgeChannel,ADCBridgeChannel> {
        .init(registers:self,handle:self,callbacks:self,memory:self)
    }
    var link: ADCDMALink<ADCBridgeChannel,ADCBridgeChannel,ADCBridgeChannel,ADCBridgeChannel> {
        .init(input:dma,configurationContext:Unmanaged.passUnretained(self).toOpaque(),readSourceWidth:adcBridgeWidth)
    }
    func read(_ register: DMARegister) -> UInt32 { registers[register,default:0] }
    func write(_ register: DMARegister,value:UInt32) { registers[register]=value }
    func read(_ word: DMAHandleWord) -> UInt32 { words[word,default:0] }
    func write(_ word: DMAHandleWord,value:UInt32) { words[word]=value }
    func read(_ id: DMACallbackID) -> DMACallback? { slots[id] }
    func write(_ id: DMACallbackID,value:DMACallback?) { slots[id]=value }
    func readParent() -> UnsafeMutableRawPointer? { parent }
    func writeParent(_ value:UnsafeMutableRawPointer?) { parent=value }
    func read32(at address:UInt32) -> UInt32 { memory[address,default:0] }
    func write32(at address:UInt32,value:UInt32) { memory[address]=value }
}
final class ADCDMALinkTests: XCTestCase {
    func testLiveWidthNodeConfigurationAndExistingDMAOperations() {
        let channel = ADCBridgeChannel(), link = ADCBridgeChannel().link
        let actual = channel.link
        XCTAssertEqual(actual.sourceDataWidth(),2); channel.sourceWidth=1; XCTAssertEqual(actual.sourceDataWidth(),1)
        XCTAssertEqual(actual.startInterrupt(sourceAddress:0x40022040,destinationAddress:0x24001000,sourceDataSize:16),.ok)
        XCTAssertEqual(channel.registers[.csar],0x40022040); XCTAssertEqual(channel.registers[.cdar],0x24001000)
        XCTAssertEqual(channel.registers[.cbr1],16); channel.registers[.csr]=0x2000
        XCTAssertEqual(actual.abort(getTick:{0}),.ok)
        let list=DMALinkedList(memory:channel)
        for width:UInt32 in 0...2 {
            var node=DMANodeConfiguration(); node.configuration.sourceDataWidth=width
            XCTAssertEqual(list.buildNode(node,at:0x2000),.ok)
            var observed:UInt32=99
            XCTAssertEqual(actual.getNodeSourceWidth(at:0x2000,width:&observed),.ok); XCTAssertEqual(observed,width)
        }
        var unchanged:UInt32=99
        XCTAssertEqual(actual.getNodeSourceWidth(at:0,width:&unchanged),.error); XCTAssertEqual(unchanged,99)
        actual.writeMemory32(at:0x1000,value:0x2000); XCTAssertEqual(actual.readMemory32(at:0x1000),0x2000)
        channel.words[.mode]=0x80; channel.words[.queueAddress]=0x1000
        XCTAssertEqual(actual.startLinkedListInterrupt(),.ok)
        actual.writeCallback(.error,value:link.callback(.error)); XCTAssertNotNil(channel.slots[.error])
    }
    func testThunksResolveLiveParentAndPreserveOriginalIncomingContext() {
        let channel=ADCBridgeChannel(), link=channel.link
        let first=UnsafeMutablePointer<UInt>.allocate(capacity:2), second=UnsafeMutablePointer<UInt>.allocate(capacity:2)
        first.initialize(repeating:0,count:2); second.initialize(repeating:0,count:2)
        defer { first.deallocate(); second.deallocate() }
        for kind in ADCDMACallbackKind.allCases {
            for pointer in [first,second] {
                channel.parent=UnsafeMutableRawPointer(pointer); link.callback(kind)(channel.context)
                XCTAssertEqual(pointer[0],UInt(kind.rawValue)); XCTAssertEqual(pointer[1],UInt(bitPattern:channel.context))
            }
        }
        channel.slots[.error]=link.callback(.error)
        link.invokeErrorCallback(context:channel.context)
        XCTAssertEqual(second[0],2); XCTAssertEqual(second[1],UInt(bitPattern:channel.context))
        XCTAssertEqual(channel.parentReads,7)
        channel.slots[.error] = { $0!.assumingMemoryBound(to:UInt.self).pointee=123 }
        link.invokeErrorCallback(context:UnsafeMutableRawPointer(first)); XCTAssertEqual(first[0],123)
    }
}
