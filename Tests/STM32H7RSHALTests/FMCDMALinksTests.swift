import STM32H7RSHAL
import XCTest

private func fmcBridgeParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<DMAListTestIO>.fromOpaque(context!).takeUnretainedValue().readParent()
}
private func fmcBridgeComplete(_ context: UnsafeMutableRawPointer?) {
  Unmanaged<DMAListTestIO>.fromOpaque(context!).takeUnretainedValue().memory[0x9010] = 1
}
private func fmcBridgeError(_ context: UnsafeMutableRawPointer?) {
  Unmanaged<DMAListTestIO>.fromOpaque(context!).takeUnretainedValue().memory[0x9010] = 2
}
private struct FMCBridgeCallbacks: SRAMCallbackIO, SDRAMCallbackIO {
  var context: UnsafeMutableRawPointer? { nil }
  func read(_ id: SRAMCallbackID) -> SRAMCallback? {
    id == .dmaError ? fmcBridgeError : fmcBridgeComplete
  }
  func read(_ id: SDRAMCallbackID) -> SDRAMCallback? {
    id == .dmaError ? fmcBridgeError : fmcBridgeComplete
  }
  func write(_ id: SRAMCallbackID, value: SRAMCallback?) {
    preconditionFailure("Unexpected callback write")
  }
  func write(_ id: SDRAMCallbackID, value: SDRAMCallback?) {
    preconditionFailure("Unexpected callback write")
  }
}
private func fmcSRAMDispatch(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  let owner = Unmanaged<SRAMFixture>.fromOpaque(parent!).takeUnretainedValue()
  let channel = Unmanaged<DMAListTestIO>.fromOpaque(source!).takeUnretainedValue()
  let driver = SRAM(
    registers: owner, handle: owner, callbacks: FMCBridgeCallbacks(), memory: owner, dma: FMCNoDMA()
  )
  driver.handleDMAEvent(
    FMCDMACallbackKind(rawValue: kind)!, sourceContext: source, source: channel.driver)
}
private func fmcSDRAMDispatch(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  let owner = Unmanaged<SDRAMFixture>.fromOpaque(parent!).takeUnretainedValue()
  let channel = Unmanaged<DMAListTestIO>.fromOpaque(source!).takeUnretainedValue()
  let driver = SDRAM(
    registers: owner, handle: owner, callbacks: FMCBridgeCallbacks(), memory: owner, dma: FMCNoDMA()
  )
  driver.handleDMAEvent(
    FMCDMACallbackKind(rawValue: kind)!, sourceContext: source, source: channel.driver)
}

final class FMCDMALinksTests: XCTestCase {
  func testSRAMUsesLiveInitWidthAndRealDMAStart() {
    let owner = SRAMFixture()
    let channel = DMAListTestIO()
    var width: UInt32 = 0
    let links = FMCDMALinks(dma: channel.driver, getDestinationDataWidth: { width })
    let driver = SRAM(
      registers: owner, handle: owner, callbacks: FMCBridgeCallbacks(), memory: owner, dma: links)
    for next: UInt32 in [0, 0x10000, 0x20000, 0x30000] {
      width = next
      channel.handleWords[.state] = 1
      channel.handleWords[.lock] = 0
      channel.registers[.ctr1] = 0x30000
      owner.write(SRAMHandleWord.state, value: 1)
      XCTAssertEqual(driver.readDMA(0x6000_0080, nil, 17), .ok)
      XCTAssertEqual(channel.registers[.csar], 0x6000_0080)
      XCTAssertEqual(channel.registers[.cdar], 0)
      XCTAssertEqual(channel.registers[.cbr1], next == 0x10000 ? 34 : next == 0x20000 ? 68 : 17)
      XCTAssertEqual(channel.handleWords[.state], 2)
      XCTAssertEqual(owner.read(SRAMHandleWord.state), 2)
      XCTAssertNotNil(channel.callbackSlots[0])
      XCTAssertNotNil(channel.callbackSlots[2])
    }
  }

  func testSDRAMUsesHeadWidthAndRealLinkedListStart() {
    let owner = SDRAMFixture()
    let channel = DMAListTestIO()
    channel.handleWords[.mode] = 0x80
    channel.handleWords[.state] = 1
    channel.handleWords[.queueAddress] = 0x2400_1000
    channel.seedQueue(0x2400_1000, nodes: [0x2400_1100])
    channel.memory[0x2400_1100] = 0x20000
    let links = FMCDMALinks(
      dma: channel.driver,
      getDestinationDataWidth: {
        XCTFail("Unexpected Init width read")
        return 0
      })
    let driver = SDRAM(
      registers: owner, handle: owner, callbacks: FMCBridgeCallbacks(), memory: owner, dma: links)
    XCTAssertEqual(driver.writeDMA(0x6000_0080, nil, 17), .ok)
    XCTAssertEqual(channel.memory[0x2400_1108], 68)
    XCTAssertEqual(channel.memory[0x2400_110C], 0)
    XCTAssertEqual(channel.memory[0x2400_1110], 0x6000_0080)
    XCTAssertEqual(channel.handleWords[.state], 2)
    XCTAssertEqual(channel.registers[.ccr, default: 0] & 1, 1)
  }

  func testAllThunksReadCurrentSRAMParentAndPassSourceDMAContext() {
    let first = SRAMFixture()
    let second = SRAMFixture()
    let channel = DMAListTestIO()
    let links = FMCDMALinks(dma: channel.driver, getDestinationDataWidth: { 0 })
    var descriptor = FMCDMACallbackContext(
      dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: fmcBridgeParent,
      dispatch: fmcSRAMDispatch)
    withUnsafeMutablePointer(to: &descriptor) { pointer in
      for event in FMCDMACallbackKind.allCases {
        links.writeCallback(.transferComplete, value: links.callback(event))
        for owner in [first, second] {
          channel.parent = Unmanaged.passUnretained(owner).toOpaque()
          channel.registers[.ccr] = 0xA5A5_0001
          channel.callbackSlots[0]!(UnsafeMutableRawPointer(pointer))
          XCTAssertEqual(
            owner.read(SRAMHandleWord.state),
            event == .complete ? 1 : event == .protectedComplete ? 4 : 3)
          XCTAssertEqual(channel.registers[.ccr], 0xA5A5_0007)
          XCTAssertEqual(channel.memory[0x9010], event == .error ? 2 : 1)
        }
      }
    }
    XCTAssertEqual(channel.events.filter { $0 == .parentRead }.count, 6)
  }

  func testSDRAMCompletionFromDMAInterruptResolvesCurrentParent() {
    let first = SDRAMFixture()
    let second = SDRAMFixture()
    let channel = DMAListTestIO()
    channel.handleWords[.state] = 1
    channel.parent = Unmanaged.passUnretained(first).toOpaque()
    var descriptor = FMCDMACallbackContext(
      dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: fmcBridgeParent,
      dispatch: fmcSDRAMDispatch)
    let links = FMCDMALinks(dma: channel.driver, getDestinationDataWidth: { 0 })
    links.writeCallback(.transferComplete, value: links.callback(.complete))
    withUnsafeMutablePointer(to: &descriptor) { pointer in
      // The interrupt invokes the same thunk with the descriptor supplied by the DMA callback storage.
      let callbacks = FMCBridgeDMAStorage(io: channel, context: UnsafeMutableRawPointer(pointer))
      let dma = DMA(registers: channel, handle: channel, callbacks: callbacks, memory: channel)
      XCTAssertEqual(
        dma.startInterrupt(
          sourceAddress: 0x6000_0080, destinationAddress: 0x2400_0000, sourceDataSize: 7), .ok)
      second.write(SDRAMHandleWord.state, value: 3)
      channel.parent = Unmanaged.passUnretained(second).toOpaque()
      channel.registers[.csr] = 0x100
      channel.registers[.misr] = 1
      channel.registers[.cbr1] = 0
      dma.handleInterrupt()
      XCTAssertEqual(second.read(SDRAMHandleWord.state), 1)
      XCTAssertEqual(channel.registers[.ccr, default: 0] & 6, 6)
      XCTAssertEqual(channel.memory[0x9010], 1)
    }
  }
}
private struct FMCBridgeDMAStorage: DMACallbackIO {
  let io: DMAListTestIO
  let context: UnsafeMutableRawPointer?
  func read(_ id: DMACallbackID) -> DMACallback? { io.read(id) }
  func write(_ id: DMACallbackID, value: DMACallback?) { io.write(id, value: value) }
  func readParent() -> UnsafeMutableRawPointer? { io.readParent() }
  func writeParent(_ value: UnsafeMutableRawPointer?) { io.writeParent(value) }
}
