import STM32H7RSHAL
import XCTest

private func i3cReadDMAParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<DMAListTestIO>.fromOpaque(context!).takeUnretainedValue().readParent()
}
private func i3cDispatchDMA(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  Unmanaged<I3CFixture>.fromOpaque(parent!).takeUnretainedValue().driver.dmaCallback(
    I3CDMACallbackKind(rawValue: kind)!)
}
private struct I3CTestDMACallbackStorage: DMACallbackIO {
  let io: DMAListTestIO
  let context: UnsafeMutableRawPointer?
  func read(_ id: DMACallbackID) -> DMACallback? { io.read(id) }
  func write(_ id: DMACallbackID, value: DMACallback?) { io.write(id, value: value) }
  func readParent() -> UnsafeMutableRawPointer? { io.readParent() }
  func writeParent(_ value: UnsafeMutableRawPointer?) { io.writeParent(value) }
}

final class I3CDMALinksTests: XCTestCase {
  func testThreeRealDMAChannelsAndCurrentParentCompletion() {
    for word in [false, true] {
      let io = I3CFixture()
      let other = I3CFixture()
      prepareI3CBuffers(io, count: 5)
      io.set(30, 5, 5)
      io.set(30, 7, 5)
      io.loadStructures()
      if word {
        io.set(
          0, 1,
          I3CConstants.HAL_I3C_TXFIFO_THRESHOLD_4_4 | I3CConstants.HAL_I3C_RXFIFO_THRESHOLD_4_4)
      }
      let channels = (0..<3).map { _ in DMAListTestIO() }
      for channel in channels {
        channel.handleWords[.state] = 1
        channel.parent = Unmanaged.passUnretained(io).toOpaque()
      }
      withUnsafeTemporaryAllocation(of: I3CDMACallbackContext.self, capacity: 3) { descriptors in
        for index in 0..<3 {
          descriptors.baseAddress!.advanced(by: index).initialize(
            to: .init(
              dmaContext: Unmanaged.passUnretained(channels[index]).toOpaque(),
              readParent: i3cReadDMAParent, dispatch: i3cDispatchDMA))
        }
        defer { descriptors.deinitialize() }
        let dmas = (0..<3).map { index in
          DMA(
            registers: channels[index], handle: channels[index],
            callbacks: I3CTestDMACallbackStorage(
              io: channels[index],
              context: UnsafeMutableRawPointer(descriptors.baseAddress! + index)),
            memory: channels[index])
        }
        let links = I3CDMALinks(control: dmas[0], transmit: dmas[1], receive: dmas[2])
        let driver = I3C(
          registers: io, handle: io, callbacks: io, dma: links, defaults: io.defaults)
        XCTAssertEqual(driver.controllerMultipleTransferDMA(io.transfer, getTick: { 0 }), .ok)
        XCTAssertEqual(channels[0].registers[.cbr1], 4)
        XCTAssertEqual(channels[1].registers[.cbr1], word ? 8 : 5)
        XCTAssertEqual(channels[2].registers[.cbr1], word ? 8 : 5)
        XCTAssertEqual(channels[0].registers[.cdar], 0x4000_5400)
        XCTAssertEqual(channels[1].registers[.cdar], word ? 0x4000_541C : 0x4000_5418)
        XCTAssertEqual(channels[2].registers[.csar], word ? 0x4000_5414 : 0x4000_5410)
        XCTAssertEqual(io.read(.state), 0x23)
        other.write(.cfgr, value: 0x101100)
        for index in 0..<3 {
          channels[index].parent = Unmanaged.passUnretained(other).toOpaque()
          channels[index].registers[.csr] = 0x100
          channels[index].registers[.misr] = 1
          channels[index].registers[.cbr1] = 0
          dmas[index].handleInterrupt()
          XCTAssertTrue(channels[index].events.contains(.parentRead))
        }
        XCTAssertEqual(other.read(.cfgr) & 0x101100, 0)
        XCTAssertEqual(io.read(.cfgr) & 0x101100, 0x101100)
        XCTAssertEqual(io.read(.state), 0x23)
        // DMA completion only clears requests; the I3C frame event completes the transfer.
        io.write(.cfgr, value: io.read(.cfgr) & ~0x101100)
        io.write(.evr, value: 0x200)
        driver.eventInterruptHandler()
        XCTAssertEqual(io.read(.state), 0x10)
        XCTAssertEqual(io.control(14), 12)
      }
    }
  }

  func testDMAStateCounterFIFOAndCurrentCallbackSlotForwarding() {
    let channel = DMAListTestIO()
    channel.handleWords[.state] = 2
    channel.registers[.cbr1] = 0xABCD_EF12
    channel.registers[.csr] = 0x0000_002A
    let links = I3CDMALinks(
      control: channel.driver, transmit: channel.driver, receive: channel.driver)
    for id in I3CDMAChannel.allCases {
      XCTAssertEqual(links.readState(id), 2)
      XCTAssertEqual(links.getCounter(id), 0xEF12)
      XCTAssertEqual(links.getFIFOLevel(id), channel.driver.getFIFOLevel())
      channel.events = []
      links.writeCallback(id, id: .abort, value: { _ in })
      channel.events = []
      links.invokeCallback(id, id: .abort)
      XCTAssertEqual(channel.events, [.callbackRead(.abort)])
    }
  }
}
