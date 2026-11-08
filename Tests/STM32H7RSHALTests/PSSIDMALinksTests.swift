import XCTest
import STM32H7RSHAL

private func pssiBridgeReadParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    let channel = Unmanaged<PSSIBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
    channel.parentReads += 1
    return channel.parent
}
private func pssiBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ event: UInt32) {
    let result = parent!.assumingMemoryBound(to: UInt.self)
    result[0] = UInt(event)
}
private final class PSSIBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel = DMAChannel(controller: .gpdma1, index: 0)
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var slots: [DMACallbackID: DMACallback] = [:]
  var memory: [UInt32: UInt32] = [:]
  var parent: UnsafeMutableRawPointer?
  var parentReads = 0
  let descriptor = UnsafeMutablePointer<PSSIDMACallbackContext>.allocate(capacity: 1)
  init() {
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: pssiBridgeReadParent, dispatch: pssiBridgeDispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  var dma: DMA<PSSIBridgeChannel, PSSIBridgeChannel, PSSIBridgeChannel, PSSIBridgeChannel> {
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


final class PSSIDMALinksTests: XCTestCase {
    func testLiveInitWidthIsIndependentOfDMARegisterContentsAndChannelsStaySeparate() {
        let tx = PSSIBridgeChannel(), rx = PSSIBridgeChannel()
        var txWidth: UInt32 = 0x20000, rxWidth: UInt32 = 1
        let links = PSSIDMALinks(transmit: tx.dma, receive: rx.dma, getDataWidth: { $0 == .transmit ? txWidth : rxWidth })
        tx.registers[.ctr1] = 0; rx.registers[.ctr1] = .max
        XCTAssertEqual(links.readDataWidth(.transmit), 0x20000); XCTAssertEqual(links.readDataWidth(.receive), 1)
        txWidth = 0; rxWidth = 2
        XCTAssertEqual(links.readDataWidth(.transmit), 0); XCTAssertEqual(links.readDataWidth(.receive), 2)
        XCTAssertEqual(links.startInterrupt(.transmit, sourceAddress: 0x24001000, destinationAddress: 0x48000428, sourceDataSize: 4), .ok)
        XCTAssertEqual(tx.registers[.csar], 0x24001000); XCTAssertEqual(tx.registers[.cdar], 0x48000428)
        XCTAssertEqual(tx.registers[.cbr1], 4); XCTAssertEqual(rx.words[.state], 1)
        links.writeMemory32(.receive, at: 0x1000, value: 0x2000)
        XCTAssertEqual(links.readMemory32(.receive, at: 0x1000), 0x2000); XCTAssertNil(tx.memory[0x1000])
        XCTAssertTrue(links.isPresent(.transmit)); XCTAssertTrue(links.isPresent(.receive))
    }
    func testEveryThunkReadsTheCurrentParentAtInvocation() {
        let channel = PSSIBridgeChannel()
        let links = PSSIDMALinks(transmit: channel.dma, getDataWidth: { _ in 0 })
        let first = UnsafeMutablePointer<UInt>.allocate(capacity: 1), second = UnsafeMutablePointer<UInt>.allocate(capacity: 1)
        first.initialize(to: .max); second.initialize(to: .max)
        defer { first.deallocate(); second.deallocate() }
        for kind in PSSIDMACallbackKind.allCases {
            links.writeCallback(.transmit, id: .transferComplete, value: links.callback(kind))
            channel.parent = UnsafeMutableRawPointer(first); links.invokeCallback(.transmit, id: .transferComplete)
            XCTAssertEqual(first.pointee, UInt(kind.rawValue))
            channel.parent = UnsafeMutableRawPointer(second); links.invokeCallback(.transmit, id: .transferComplete)
            XCTAssertEqual(second.pointee, UInt(kind.rawValue))
        }
        XCTAssertEqual(channel.parentReads, 8); XCTAssertFalse(links.isPresent(.receive))
    }
}
