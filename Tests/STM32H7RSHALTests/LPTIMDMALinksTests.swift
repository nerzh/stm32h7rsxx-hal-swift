import XCTest
import STM32H7RSHAL

private func lptimBridgeReadParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    let channel = Unmanaged<LPTIMBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
    channel.parentReads += 1
    return channel.parent
}
private func lptimBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ event: UInt32) {
    let result = parent!.assumingMemoryBound(to: UInt.self)
    result[0] = UInt(bitPattern: source); result[1] = UInt(event)
}
private final class LPTIMBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel = DMAChannel(controller: .gpdma1, index: 0)
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var slots: [DMACallbackID: DMACallback] = [:]
  var memory: [UInt32: UInt32] = [:]
  var parent: UnsafeMutableRawPointer?
  var parentReads = 0
  let descriptor = UnsafeMutablePointer<LPTIMDMACallbackContext>.allocate(capacity: 1)
  init() {
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: lptimBridgeReadParent, dispatch: lptimBridgeDispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  var dma: DMA<LPTIMBridgeChannel, LPTIMBridgeChannel, LPTIMBridgeChannel, LPTIMBridgeChannel> {
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


final class LPTIMDMALinksTests: XCTestCase {
    func testBothLinksForwardDMAAndPreserveHandleIdentity() {
        let first = LPTIMBridgeChannel(), second = LPTIMBridgeChannel()
        let links = LPTIMDMALinks(channel1: first.dma, channel2: second.dma)
        XCTAssertEqual(links.startInterrupt(.channel2, sourceAddress: 0x1000, destinationAddress: 0x40002434, sourceDataSize: 12), .ok)
        XCTAssertEqual(second.registers[.csar], 0x1000); XCTAssertEqual(second.registers[.cdar], 0x40002434)
        XCTAssertEqual(second.registers[.cbr1], 12); XCTAssertEqual(second.words[.state], 2)
        XCTAssertEqual(first.words[.state], 1)
        links.writeMemory32(.channel1, at: 0x1000, value: 0x2000)
        XCTAssertEqual(links.readMemory32(.channel1, at: 0x1000), 0x2000)
        XCTAssertTrue(links.matches(.channel1, context: Unmanaged.passUnretained(first).toOpaque()))
        XCTAssertFalse(links.matches(.channel1, context: Unmanaged.passUnretained(second).toOpaque()))
        let aliases = LPTIMDMALinks(channel1: first.dma, channel2: first.dma)
        XCTAssertTrue(aliases.matches(.channel2, context: Unmanaged.passUnretained(first).toOpaque()))
        let missing = LPTIMDMALinks<LPTIMBridgeChannel, LPTIMBridgeChannel, LPTIMBridgeChannel, LPTIMBridgeChannel>()
        XCTAssertFalse(missing.matches(.channel1, context: nil))
    }
    func testAllThunksReadTheCurrentParentAndDispatchTheOriginalDMAContext() {
        let channel = LPTIMBridgeChannel(), links = LPTIMDMALinks(channel1: channel.dma)
        let first = UnsafeMutablePointer<UInt>.allocate(capacity: 2), second = UnsafeMutablePointer<UInt>.allocate(capacity: 2)
        first.initialize(repeating: 0, count: 2); second.initialize(repeating: 0, count: 2)
        defer { first.deallocate(); second.deallocate() }
        for kind in LPTIMDMACallbackKind.allCases {
            links.writeCallback(.channel1, id: .transferComplete, value: links.callback(kind))
            channel.parent = UnsafeMutableRawPointer(first); channel.slots[.transferComplete]!(channel.context)
            XCTAssertEqual(first[0], UInt(bitPattern: Unmanaged.passUnretained(channel).toOpaque())); XCTAssertEqual(first[1], UInt(kind.rawValue))
            channel.parent = UnsafeMutableRawPointer(second); channel.slots[.transferComplete]!(channel.context)
            XCTAssertEqual(second[0], first[0]); XCTAssertEqual(second[1], first[1])
        }
        XCTAssertEqual(channel.parentReads, 10)
    }
}
