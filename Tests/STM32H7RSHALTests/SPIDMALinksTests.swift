import STM32H7RSHAL
import XCTest

private func spiBridgeParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<DMAListTestIO>.fromOpaque(context!).takeUnretainedValue().readParent()
}
private func spiBridgeDispatch(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  let owner = Unmanaged<SPIFixture>.fromOpaque(parent!).takeUnretainedValue()
  let channel = Unmanaged<DMAListTestIO>.fromOpaque(source!).takeUnretainedValue()
  owner.driver.dmaCallback(SPIDMACallbackKind(rawValue: kind)!, source: channel.driver)
}
private struct SPIBridgeDMAStorage: DMACallbackIO {
  let io: DMAListTestIO
  let context: UnsafeMutableRawPointer?
  func read(_ id: DMACallbackID) -> DMACallback? { io.read(id) }
  func write(_ id: DMACallbackID, value: DMACallback?) { io.write(id, value: value) }
  func readParent() -> UnsafeMutableRawPointer? { io.readParent() }
  func writeParent(_ value: UnsafeMutableRawPointer?) { io.writeParent(value) }
}

final class SPIDMALinksTests: XCTestCase {
  func testLiveInitWidthValidationAndRealDMAStart() {
    let owner = SPIFixture()
    let channel = DMAListTestIO()
    var width: UInt32 = 0
    let links = SPIDMALinks(
      transmit: channel.driver, getSourceDataWidth: { _ in width },
      getDestinationDataWidth: { _ in
        XCTFail("Unexpected destination width read")
        return 0
      })
    let driver = SPI(registers: owner, handle: owner, callbacks: owner, dma: links)
    for next: UInt32 in [0, 1, 2] {
      width = next
      owner.write(.state, value: 1)
      owner.write(.dataSize, value: 15)
      channel.handleWords[.state] = 1
      channel.handleWords[.lock] = 0
      channel.registers[.ctr1] = 0
      let result = driver.transmitDMA(UnsafeRawPointer(owner.buffer()), 7)
      if width == 0 {
        XCTAssertEqual(result, .error)
        XCTAssertEqual(owner.read(SPIHandleWord.state), 3)
      } else {
        XCTAssertEqual(result, .ok)
        XCTAssertEqual(
          channel.registers[.csar], UInt32(truncatingIfNeeded: UInt(bitPattern: owner.buffer())))
        XCTAssertEqual(channel.registers[.cdar], 0x4200_3020)
        XCTAssertEqual(channel.registers[.cbr1], 14)
        XCTAssertEqual(channel.handleWords[.state], 2)
        XCTAssertNotNil(links.readCallback(.transmit, id: .transferComplete))
      }
    }
  }

  func testDuplexUsesRealLinkedListStartAndUpdatesBothHeads() {
    let owner = SPIFixture()
    let tx = DMAListTestIO()
    let rx = DMAListTestIO()
    for channel in [tx, rx] {
      channel.handleWords[.mode] = 0x81
      channel.handleWords[.state] = 1
      channel.handleWords[.queueAddress] = 0x2400_1000
      channel.seedQueue(0x2400_1000, nodes: [0x2400_1100])
    }
    owner.write(.state, value: 1)
    owner.write(.dataSize, value: 7)
    let links = SPIDMALinks(
      transmit: tx.driver, receive: rx.driver, getSourceDataWidth: { _ in 0 },
      getDestinationDataWidth: { _ in 0 })
    let driver = SPI(registers: owner, handle: owner, callbacks: owner, dma: links)
    XCTAssertEqual(
      driver.transmitReceiveDMA(
        UnsafeRawPointer(owner.buffer()), UnsafeMutableRawPointer(owner.buffer(1)), 5,
        getTick: { 0 }), .ok)
    XCTAssertEqual(tx.memory[0x2400_1108], 5)
    XCTAssertEqual(tx.memory[0x2400_1110], 0x4200_3020)
    XCTAssertEqual(rx.memory[0x2400_1108], 5)
    XCTAssertEqual(rx.memory[0x2400_110C], 0x4200_3030)
    XCTAssertEqual(owner.raw(.cr2) & 0xFFFF, 0)
    XCTAssertNil(links.readCallback(.transmit, id: .transferComplete))
    XCTAssertNotNil(links.readCallback(.receive, id: .transferComplete))
  }

  func testAllThunksResolveCurrentParentAndActualSourceError() {
    let first = SPIFixture()
    let second = SPIFixture()
    let channel = DMAListTestIO()
    channel.handleWords[.errorCode] = 1
    let links = SPIDMALinks(
      transmit: channel.driver, getSourceDataWidth: { _ in 0 }, getDestinationDataWidth: { _ in 0 })
    var descriptor = SPIDMACallbackContext(
      dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: spiBridgeParent,
      dispatch: spiBridgeDispatch)
    withUnsafeMutablePointer(to: &descriptor) { pointer in
      for kind in SPIDMACallbackKind.allCases {
        links.writeCallback(.transmit, id: .transferComplete, value: links.callback(kind))
        for owner in [first, second] {
          channel.parent = Unmanaged.passUnretained(owner).toOpaque()
          owner.write(.state, value: 5)
          owner.setting(.transmit, 0, 1)
          owner.setting(.receive, 0, 1)
          owner.setting(.transmit, 2, 0x81)
          owner.setting(.receive, 2, 0x81)
          let before = owner.control(8)
          channel.callbackSlots[0]!(UnsafeMutableRawPointer(pointer))
          XCTAssertEqual(owner.control(8), before + 10)
          if kind == .error { XCTAssertEqual(owner.read(SPIHandleWord.errorCode) & 0x10, 0x10) }
        }
      }
    }
    XCTAssertEqual(channel.events.filter { $0 == .parentRead }.count, 20)
  }

  func testRealDMAInterruptEnablesSPIEndInterruptOnCurrentParent() {
    let first = SPIFixture()
    let second = SPIFixture()
    let channel = DMAListTestIO()
    channel.handleWords[.state] = 1
    channel.parent = Unmanaged.passUnretained(first).toOpaque()
    var descriptor = SPIDMACallbackContext(
      dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: spiBridgeParent,
      dispatch: spiBridgeDispatch)
    withUnsafeMutablePointer(to: &descriptor) { pointer in
      let storage = SPIBridgeDMAStorage(io: channel, context: UnsafeMutableRawPointer(pointer))
      let dma = DMA(registers: channel, handle: channel, callbacks: storage, memory: channel)
      let links = SPIDMALinks(
        transmit: dma, getSourceDataWidth: { _ in 0 }, getDestinationDataWidth: { _ in 0 })
      let driver = SPI(registers: first, handle: first, callbacks: first, dma: links)
      first.write(.state, value: 1)
      first.write(.dataSize, value: 7)
      XCTAssertEqual(driver.transmitDMA(UnsafeRawPointer(first.buffer()), 5), .ok)
      second.write(.state, value: 3)
      channel.parent = Unmanaged.passUnretained(second).toOpaque()
      channel.registers[.csr] = 0x100
      channel.registers[.misr] = 1
      channel.registers[.cbr1] = 0
      dma.handleInterrupt()
      XCTAssertEqual(second.raw(.ier) & 8, 8)
      XCTAssertEqual(first.raw(.ier) & 8, 0)
      XCTAssertEqual(second.read(SPIHandleWord.state), 3)
    }
  }
}
