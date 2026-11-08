import XCTest
import STM32H7RSHAL

private func spdifrxBridgeReadParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    let channel = Unmanaged<SPDIFRXBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
    channel.parentReads += 1
    return channel.parent
}
private func spdifrxBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ event: UInt32, _ mode: UInt32) {
    let result = parent!.assumingMemoryBound(to: UInt.self)
    result[0] = UInt(event); result[1] = UInt(mode)
}
private final class SPDIFRXBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel = DMAChannel(controller: .gpdma1, index: 0)
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var slots: [DMACallbackID: DMACallback] = [:]
  var memory: [UInt32: UInt32] = [:]
  var parent: UnsafeMutableRawPointer?
  var parentReads = 0
  var modeReads = 0
  let descriptor = UnsafeMutablePointer<SPDIFRXDMACallbackContext>.allocate(capacity: 1)
  init() {
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: spdifrxBridgeReadParent, readMode: spdifrxBridgeReadMode, dispatch: spdifrxBridgeDispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  var dma: DMA<SPDIFRXBridgeChannel, SPDIFRXBridgeChannel, SPDIFRXBridgeChannel, SPDIFRXBridgeChannel> {
    .init(registers: self, handle: self, callbacks: self, memory: self)
  }
  func read(_ register: DMARegister) -> UInt32 { registers[register, default: 0] }
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


private func spdifrxBridgeReadMode(_ context: UnsafeMutableRawPointer?) -> UInt32 {
    let channel = Unmanaged<SPDIFRXBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
    channel.modeReads += 1; return channel.words[.mode, default: 0]
}
final class SPDIFRXDMALinksTests: XCTestCase {
    func testChannelsStartAndDisableThroughExistingDMAImplementation() {
        let data = SPDIFRXBridgeChannel(), control = SPDIFRXBridgeChannel()
        let links = SPDIFRXDMALinks(data: data.dma, control: control.dma)
        XCTAssertTrue(links.isPresent(.data)); XCTAssertTrue(links.isPresent(.control))
        XCTAssertEqual(links.startInterrupt(.data, sourceAddress: 0x40004010, destinationAddress: 0x24001000, sourceDataSize: 16), .ok)
        XCTAssertEqual(data.registers[.csar], 0x40004010); XCTAssertEqual(data.registers[.cdar], 0x24001000); XCTAssertEqual(data.registers[.cbr1], 16)
        XCTAssertEqual(control.words[.state], 1)
        XCTAssertEqual(links.startInterrupt(.control, sourceAddress: 0x40004014, destinationAddress: 0x24002000, sourceDataSize: 4), .ok)
        XCTAssertEqual(control.registers[.csar], 0x40004014); XCTAssertEqual(control.registers[.cdar], 0x24002000)
        links.writeMemory32(.control, at: 0x1000, value: 0x2000)
        XCTAssertEqual(links.readMemory32(.control, at: 0x1000), 0x2000); XCTAssertNil(data.memory[0x1000])
        links.disable(.data); XCTAssertEqual(data.registers[.ccr, default: 0] & 6, 6); XCTAssertEqual(control.registers[.ccr, default: 0] & 6, 0)
        links.disable(.control); XCTAssertEqual(control.registers[.ccr, default: 0] & 6, 6)
        XCTAssertFalse(SPDIFRXNoDMA().isPresent(.data)); XCTAssertFalse(SPDIFRXNoDMA().isPresent(.control))
    }
    func testEveryThunkReadsCurrentParentAndOnlyDataCompletionReadsMode() {
        let channel = SPDIFRXBridgeChannel(), links = SPDIFRXDMALinks(data: SPDIFRXBridgeChannel().dma)
        let first = UnsafeMutablePointer<UInt>.allocate(capacity: 2), second = UnsafeMutablePointer<UInt>.allocate(capacity: 2)
        first.initialize(repeating: .max, count: 2); second.initialize(repeating: .max, count: 2)
        defer { first.deallocate(); second.deallocate() }
        for kind in SPDIFRXDMACallbackKind.allCases {
            channel.parent = UnsafeMutableRawPointer(first); channel.words[.mode] = 0x81
            links.callback(kind)(channel.context)
            XCTAssertEqual(first[0], UInt(kind.rawValue)); XCTAssertEqual(first[1], kind == .receiveComplete ? 0x81 : 0)
            channel.parent = UnsafeMutableRawPointer(second); channel.words[.mode] = 0x80
            links.callback(kind)(channel.context)
            XCTAssertEqual(second[0], UInt(kind.rawValue)); XCTAssertEqual(second[1], kind == .receiveComplete ? 0x80 : 0)
        }
        XCTAssertEqual(channel.parentReads, 10); XCTAssertEqual(channel.modeReads, 2)
    }
}
