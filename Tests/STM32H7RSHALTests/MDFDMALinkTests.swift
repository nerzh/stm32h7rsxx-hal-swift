import XCTest
import STM32H7RSHAL

private func mdfBridgeReadParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    let channel = Unmanaged<MDFBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
    channel.parentReads += 1
    return channel.parent
}
private func mdfBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ event: UInt32, _ mode: UInt32) {
    let result = parent!.assumingMemoryBound(to: UInt.self)
    result[0] = UInt(event); result[1] = UInt(mode)
}
private final class MDFBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel = DMAChannel(controller: .gpdma1, index: 0)
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var slots: [DMACallbackID: DMACallback] = [:]
  var memory: [UInt32: UInt32] = [:]
  var parent: UnsafeMutableRawPointer?
  var parentReads = 0
  var modeReads = 0
  let descriptor = UnsafeMutablePointer<MDFDMACallbackContext>.allocate(capacity: 1)
  init() {
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: mdfBridgeReadParent, readMode: mdfBridgeReadMode, dispatch: mdfBridgeDispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  var dma: DMA<MDFBridgeChannel, MDFBridgeChannel, MDFBridgeChannel, MDFBridgeChannel> {
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


private func mdfBridgeReadMode(_ context: UnsafeMutableRawPointer?) -> UInt32 {
    let channel = Unmanaged<MDFBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
    channel.modeReads += 1; return channel.words[.mode, default: 0]
}
final class MDFDMALinkTests: XCTestCase {
    func testStartAndAbortUseExistingDMAImplementation() {
        let channel = MDFBridgeChannel(), link = MDFDMALink(input: MDFBridgeChannel().dma)
        let actual = MDFDMALink(input: channel.dma)
        XCTAssertEqual(actual.startInterrupt(sourceAddress: 0x4002F0F0, destinationAddress: 0x24001000, sourceDataSize: 16), .ok)
        XCTAssertEqual(channel.registers[.csar], 0x4002F0F0); XCTAssertEqual(channel.registers[.cdar], 0x24001000); XCTAssertEqual(channel.registers[.cbr1], 16)
        actual.writeMemory32(at: 0x1000, value: 0x2000); XCTAssertEqual(actual.readMemory32(at: 0x1000), 0x2000)
        channel.registers[.csr] = 0x2000
        XCTAssertEqual(actual.abort(getTick: { 0 }), .ok); XCTAssertEqual(channel.words[.state], 1)
        let counter = UnsafeMutablePointer<UInt>.allocate(capacity: 2); counter.initialize(repeating: 0, count: 2)
        defer { counter.deallocate() }
        channel.parent = UnsafeMutableRawPointer(counter)
        actual.writeCallback(.error, value: link.callback(.error)); channel.slots[.error]!(channel.context)
        XCTAssertEqual(counter[0], 2)
    }
    func testEveryThunkReadsCurrentParentAndOnlyCompletionReadsMode() {
        let channel = MDFBridgeChannel(), link = MDFDMALink(input: MDFBridgeChannel().dma)
        let first = UnsafeMutablePointer<UInt>.allocate(capacity: 2), second = UnsafeMutablePointer<UInt>.allocate(capacity: 2)
        first.initialize(repeating: .max, count: 2); second.initialize(repeating: .max, count: 2)
        defer { first.deallocate(); second.deallocate() }
        for kind in MDFDMACallbackKind.allCases {
            channel.parent = UnsafeMutableRawPointer(first); channel.words[.mode] = 0x81
            link.callback(kind)(channel.context)
            XCTAssertEqual(first[0], UInt(kind.rawValue)); XCTAssertEqual(first[1], kind == .complete ? 0x81 : 0)
            channel.parent = UnsafeMutableRawPointer(second); channel.words[.mode] = 0x80
            link.callback(kind)(channel.context)
            XCTAssertEqual(second[0], UInt(kind.rawValue)); XCTAssertEqual(second[1], kind == .complete ? 0x80 : 0)
        }
        XCTAssertEqual(channel.parentReads, 6); XCTAssertEqual(channel.modeReads, 2)
    }
}
