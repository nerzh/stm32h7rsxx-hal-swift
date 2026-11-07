import XCTest
@testable import STM32H7RSHAL

private func hashBridgeReadParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  let channel = Unmanaged<HASHBridgeChannel>.fromOpaque(context!).takeUnretainedValue()
  channel.parentReads += 1
  return channel.parent
}
private func hashBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ event: UInt32) {
  hashTestObject(parent).driver.handleDMAEvent(HASHDMACallbackKind(rawValue: event)!)
}
private final class HASHBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel = DMAChannel(controller: .gpdma1, index: 0)
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var slots: [DMACallbackID: DMACallback] = [:]
  var memory: [UInt32: UInt32] = [:]
  var parent: UnsafeMutableRawPointer?
  var parentReads = 0
  let descriptor = UnsafeMutablePointer<HASHDMACallbackContext>.allocate(capacity: 1)
  init() {
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: hashBridgeReadParent, dispatch: hashBridgeDispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  var dma: DMA<HASHBridgeChannel, HASHBridgeChannel, HASHBridgeChannel, HASHBridgeChannel> {
    .init(registers: self, handle: self, callbacks: self, memory: self)
  }
  var link: HASHDMALink<HASHBridgeChannel, HASHBridgeChannel, HASHBridgeChannel, HASHBridgeChannel> {
    .init(input: dma)
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

final class HASHDMALinkTests: XCTestCase {
  func testLinkForwardsActualDMAOperationsAndRegisterMasks() {
    let channel = HASHBridgeChannel()
    XCTAssertEqual(channel.link.startInterrupt(sourceAddress: 0x1000, destinationAddress: 0x4802_0404,
      sourceDataSize: 12), .ok)
    XCTAssertEqual(channel.registers[.csar], 0x1000)
    XCTAssertEqual(channel.registers[.cdar], 0x4802_0404)
    XCTAssertEqual(channel.registers[.cbr1], 12)
    XCTAssertEqual(channel.words[.state], 2)
    channel.registers[.cbr1] = 0xABCD_1234
    channel.registers[.csr] = 0xFF56_0000
    XCTAssertEqual(channel.link.getCounter(), 0x1234)
    XCTAssertEqual(channel.link.getFIFOLevel(), 0x56)
    channel.words[.mode] = 0x81
    XCTAssertEqual(channel.link.read(.mode), 0x81)
    channel.link.writeMemory32(at: 0x8000, value: 0x9000)
    XCTAssertEqual(channel.link.readMemory32(at: 0x8000), 0x9000)
  }

  func testFixedThunksReadLiveParentForEachEventAndPermitRecursiveDispatch() {
    let channel = HASHBridgeChannel()
    let first = HASHTestIO(), second = HASHTestIO(registered: true)
    first.words[.state] = 2; first.words[.lock] = 1; first.words[.phase] = 2
    second.words[.state] = 2; second.words[.lock] = 1
    channel.parent = first.context
    channel.link.writeCallback(.transferComplete, value: channel.link.callback(.inputComplete))
    channel.link.writeCallback(.error, value: channel.link.callback(.error))
    first.onCallback = { id in
      if id == .inputComplete {
        channel.parent = second.context
        channel.slots[.error]!(channel.context)
      }
    }
    channel.slots[.transferComplete]!(channel.context)
    XCTAssertEqual(first.events, [.inputComplete, .digestComplete])
    XCTAssertEqual(second.events, [.error])
    XCTAssertEqual(first.words[.state], 1); XCTAssertEqual(first.words[.lock], 0)
    XCTAssertEqual(second.words[.errorCode], 2); XCTAssertEqual(second.words[.lock], 1)
    XCTAssertEqual(channel.parentReads, 2)
    channel.slots[.error]!(channel.context)
    XCTAssertEqual(second.events, [.error, .error]); XCTAssertEqual(channel.parentReads, 3)
  }
}
