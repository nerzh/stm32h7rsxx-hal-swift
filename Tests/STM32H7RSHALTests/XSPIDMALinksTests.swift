import CXSPIReference
import STM32H7RSHAL
import XCTest

private func xspiBridgeParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<DMAListTestIO>.fromOpaque(context!).takeUnretainedValue().readParent()
}
private func xspiBridgeDispatch(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  Unmanaged<XSPIFixture>.fromOpaque(parent!).takeUnretainedValue().driver.dmaCallback(
    XSPIDMACallbackKind(rawValue: kind)!)
}
private struct XSPIBridgeDMAStorage: DMACallbackIO {
  let io: DMAListTestIO
  let context: UnsafeMutableRawPointer?
  func read(_ id: DMACallbackID) -> DMACallback? { io.read(id) }
  func write(_ id: DMACallbackID, value: DMACallback?) { io.write(id, value: value) }
  func readParent() -> UnsafeMutableRawPointer? { io.readParent() }
  func writeParent(_ value: UnsafeMutableRawPointer?) { io.writeParent(value) }
}
final class XSPIDMALinksTests: XCTestCase {
  func testLiveConfigurationAndActualDMAStart() {
    let owner = XSPIFixture()
    let channel = DMAListTestIO()
    var width: UInt32 = 0
    let links = XSPIDMALinks(
      transmit: channel.driver,
      getConfiguration: { _, word in
        switch word {
        case .destinationDataWidth: return width
        case .direction: return 0x400
        case .sourceIncrement: return 8
        case .destinationIncrement: return 0
        }
      })
    let driver = XSPI(registers: owner, handle: owner, callbacks: owner, dma: links)
    for next: UInt32 in [0, 0x10000, 0x20000] {
      width = next
      owner.write(.state, value: 4)
      owner.write(.fifoThresholdByte, value: 4)
      owner.raw(.dlr, 7)
      channel.handleWords[.state] = 1
      channel.handleWords[.lock] = 0
      channel.registers[.ctr1] = 0
      XCTAssertEqual(driver.transmitDMA(owner.buffer()), .ok)
      XCTAssertEqual(
        channel.registers[.csar], UInt32(truncatingIfNeeded: UInt(bitPattern: owner.buffer())))
      XCTAssertEqual(channel.registers[.cdar], 0x5200_5050)
      XCTAssertEqual(channel.registers[.cbr1], 8)
      XCTAssertEqual(channel.handleWords[.state], 2)
      XCTAssertEqual(owner.read(.transferCount), 8)
    }
  }
  func testLinkedListNodeDirectionAndAddressUpdates() {
    for receive in [false, true] {
      let owner = XSPIFixture()
      let channel = DMAListTestIO()
      channel.handleWords[.mode] = 0x81
      channel.handleWords[.state] = 1
      channel.handleWords[.queueAddress] = 0x2400_1000
      channel.seedQueue(0x2400_1000, nodes: [0x2400_1100])
      channel.memory[0x2400_1100] = 0x20000
      let links = XSPIDMALinks(
        transmit: channel.driver, receive: channel.driver,
        getConfiguration: { _, _ in
          XCTFail("Linked-list width must come from its head")
          return 0
        })
      let driver = XSPI(registers: owner, handle: owner, callbacks: owner, dma: links)
      owner.write(.state, value: 4)
      owner.write(.fifoThresholdByte, value: 4)
      owner.raw(.dlr, 7)
      XCTAssertEqual(
        receive ? driver.receiveDMA(owner.buffer()) : driver.transmitDMA(owner.buffer()), .ok)
      XCTAssertEqual(channel.memory[0x2400_1108], 8)
      XCTAssertEqual(channel.memory[receive ? 0x2400_110C : 0x2400_1110], 0x5200_5050)
      XCTAssertEqual(channel.memory[0x2400_1100]! & 0x80008, receive ? 0x80000 : 8)
      XCTAssertEqual(channel.memory[0x2400_1104]! & 0x400, receive ? 0 : 0x400)
    }
  }
  func testAllThunksReadCurrentParent() {
    let channel = DMAListTestIO()
    let links = XSPIDMALinks(transmit: channel.driver, getConfiguration: { _, _ in 0 })
    var descriptor = XSPIDMACallbackContext(
      dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: xspiBridgeParent,
      dispatch: xspiBridgeDispatch)
    withUnsafeMutablePointer(to: &descriptor) { ptr in
      for kind in XSPIDMACallbackKind.allCases {
        for _ in 0..<2 {
          let p = XSPIPair()
          p.setup { f in
            f.write(.state, value: 0x18)
            f.write(.transferCount, value: 7)
            f.raw(.cr, 0x1F0004)
          }
          channel.parent = Unmanaged.passUnretained(p.swift).toOpaque()
          links.writeCallback(.transmit, id: .transferComplete, value: links.callback(kind))
          _ = CXSPI_Run(p.c.state, 32 + kind.rawValue, 0, 0, 0)
          channel.callbackSlots[0]!(UnsafeMutableRawPointer(ptr))
          XCTAssertEqual(CXSPI_Compare(p.c.state, p.swift.state), 0)
        }
      }
    }
    XCTAssertEqual(channel.events.filter { $0 == .parentRead }.count, 8)
  }
  func testActualDMAInterruptEnablesXSPICompletionOnCurrentParent() {
    let first = XSPIFixture()
    let second = XSPIFixture()
    let channel = DMAListTestIO()
    channel.handleWords[.state] = 1
    channel.parent = Unmanaged.passUnretained(first).toOpaque()
    var descriptor = XSPIDMACallbackContext(
      dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: xspiBridgeParent,
      dispatch: xspiBridgeDispatch)
    withUnsafeMutablePointer(to: &descriptor) { ptr in
      let storage = XSPIBridgeDMAStorage(io: channel, context: UnsafeMutableRawPointer(ptr))
      let dma = DMA(registers: channel, handle: channel, callbacks: storage, memory: channel)
      let links = XSPIDMALinks(
        transmit: dma,
        getConfiguration: { _, word in
          switch word {
          case .destinationDataWidth: return 0
          case .direction: return 0x400
          case .sourceIncrement: return 8
          case .destinationIncrement: return 0
          }
        })
      let driver = XSPI(registers: first, handle: first, callbacks: first, dma: links)
      first.write(.state, value: 4)
      first.raw(.dlr, 4)
      XCTAssertEqual(driver.transmitDMA(first.buffer()), .ok)
      second.write(.state, value: 0x18)
      second.write(.transferCount, value: 5)
      second.raw(.cr, 4)
      channel.parent = Unmanaged.passUnretained(second).toOpaque()
      channel.registers[.csr] = 0x100
      channel.registers[.misr] = 1
      channel.registers[.cbr1] = 0
      dma.handleInterrupt()
      XCTAssertEqual(second.raw(.cr) & 0x20004, 0x20000)
      XCTAssertEqual(second.read(.transferCount), 0)
      XCTAssertEqual(first.read(.transferCount), 5)
      XCTAssertEqual(first.raw(.cr) & 0x20004, 4)
    }
  }
}
