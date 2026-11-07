import XCTest
@testable import STM32H7RSHAL

private func uartBridgeParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<UARTBridgeChannel>.fromOpaque(context!).takeUnretainedValue().parent
}
private func uartBridgeDispatch(_ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32) {
  let owner = Unmanaged<UARTBridgeFixture>.fromOpaque(parent!).takeUnretainedValue()
  let original = Unmanaged<UARTBridgeChannel>.fromOpaque(source!).takeUnretainedValue()
  owner.uart.handleDMAEvent(UARTDMACallbackKind(rawValue: kind)!, source: original.driver)
}

private final class UARTBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel: DMAChannel
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var callbacks: [DMACallbackID: DMACallback] = [:]
  var parent: UnsafeMutableRawPointer?
  var memory: [UInt32: UInt32] = [:]
  var callbackReads = 0
  let descriptor = UnsafeMutablePointer<UARTDMACallbackContext>.allocate(capacity: 1)
  init(index: Int) {
    channel = DMAChannel(controller: .gpdma1, index: index)
    descriptor.initialize(to: .init(dmaContext: Unmanaged.passUnretained(self).toOpaque(),
      readParent: uartBridgeParent, dispatch: uartBridgeDispatch))
  }
  deinit { descriptor.deinitialize(count: 1); descriptor.deallocate() }
  var driver: DMA<UARTBridgeChannel, UARTBridgeChannel, UARTBridgeChannel, UARTBridgeChannel> {
    .init(registers: self, handle: self, callbacks: self, memory: self)
  }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  func read(_ register: DMARegister) -> UInt32 { registers[register, default: 0] }
  func write(_ register: DMARegister, value: UInt32) {
    registers[register] = value
    if register == .cfcr { registers[.csr, default: 0] &= ~value }
    if register == .ccr && value & 4 != 0 { registers[.csr, default: 0] |= 0x2000 }
    if register == .ccr && value & 2 != 0 {
      registers[.ccr] = value & ~UInt32(7); registers[.csr, default: 0] |= 1
    }
  }
  func read(_ word: DMAHandleWord) -> UInt32 { words[word, default: 0] }
  func write(_ word: DMAHandleWord, value: UInt32) { words[word] = value }
  func read(_ id: DMACallbackID) -> DMACallback? { callbackReads += 1; return callbacks[id] }
  func write(_ id: DMACallbackID, value: DMACallback?) { callbacks[id] = value }
  func readParent() -> UnsafeMutableRawPointer? { parent }
  func writeParent(_ value: UnsafeMutableRawPointer?) { parent = value }
  func read32(at address: UInt32) -> UInt32 { memory[address, default: 0] }
  func write32(at address: UInt32, value: UInt32) { memory[address] = value }
}

private final class UARTBridgeFixture {
  let io = UARTDMAFixture()
  let tx = UARTBridgeChannel(index: 0)
  let rx = UARTBridgeChannel(index: 1)
  init() {
    tx.parent = Unmanaged.passUnretained(self).toOpaque()
    rx.parent = Unmanaged.passUnretained(self).toOpaque()
  }
  var links: UARTDMALinks<UARTBridgeChannel, UARTBridgeChannel, UARTBridgeChannel, UARTBridgeChannel> {
    .init(transmit: tx.driver, receive: rx.driver)
  }
  var uart: UART<UARTDMAFixture, UARTDMAFixture, UARTDMAFixture,
    UARTDMALinks<UARTBridgeChannel, UARTBridgeChannel, UARTBridgeChannel, UARTBridgeChannel>> {
    .init(registers: io, handle: io, callbacks: io, dma: links, defaults: io.defaults)
  }
}

final class UARTDMALinksTests: XCTestCase {
  func testRealDMATransmitCompletionWaitsForUARTTCInterrupt() {
    let fixture = UARTBridgeFixture()
    let data = UnsafeRawPointer(bitPattern: 0x2400_1000)!
    XCTAssertEqual(fixture.uart.transmitDMA(data, size: 32), .ok)
    XCTAssertEqual(fixture.tx.words[.state], 2)
    XCTAssertEqual(fixture.tx.words[.lock], 1)
    XCTAssertEqual(fixture.tx.registers[.csar], 0x2400_1000)
    XCTAssertEqual(fixture.tx.registers[.cdar], 0x4000_4428)
    XCTAssertEqual(fixture.tx.registers[.cbr1], 32)
    fixture.tx.registers[.csr] = 0x100
    fixture.tx.registers[.cbr1] = 0
    fixture.tx.registers[.misr] = 1 << fixture.tx.channel.index
    fixture.tx.driver.handleInterrupt()
    XCTAssertEqual(fixture.tx.words[.state], 1)
    XCTAssertEqual(fixture.tx.words[.lock], 0)
    XCTAssertEqual(fixture.io.halves[.transmitCount], 0)
    XCTAssertEqual(fixture.io.words[.globalState], 0x21)
    XCTAssertTrue(fixture.io.events.isEmpty)
    fixture.io.registers[.isr] = 0x40
    fixture.uart.handleInterrupt(getTick: fixture.io.getTick)
    XCTAssertEqual(fixture.io.events, [.callback(.transmitComplete)])
    XCTAssertEqual(fixture.io.words[.globalState], 0x20)
  }

  func testRealDMAHalfAndReceiveCompletionRearmFromUARTCallback() {
    let fixture = UARTBridgeFixture()
    let data = UnsafeMutableRawPointer(bitPattern: 0x2400_2000)!
    XCTAssertEqual(fixture.uart.receiveToIdleDMA(data, size: 32), .ok)
    fixture.rx.registers[.csr] = 0x200
    fixture.rx.registers[.cbr1] = 16
    fixture.rx.registers[.misr] = 1 << fixture.rx.channel.index
    fixture.rx.driver.handleInterrupt()
    XCTAssertEqual(fixture.io.events, [.rxEvent(16)])
    XCTAssertEqual(fixture.rx.words[.state], 2)
    fixture.io.onRxEvent = { size in
      if size == 32 { XCTAssertEqual(fixture.uart.receiveToIdleDMA(data, size: 64), .ok) }
    }
    fixture.rx.registers[.csr] = 0x100
    fixture.rx.registers[.cbr1] = 0
    fixture.rx.registers[.misr] = 1 << fixture.rx.channel.index
    fixture.rx.driver.handleInterrupt()
    XCTAssertEqual(fixture.io.events, [.rxEvent(16), .rxEvent(32)])
    XCTAssertEqual(fixture.rx.words[.state], 2)
    XCTAssertEqual(fixture.rx.words[.lock], 1)
    XCTAssertEqual(fixture.rx.registers[.cbr1], 64)
    XCTAssertEqual(fixture.io.words[.receiveState], 0x22)
    XCTAssertEqual(fixture.io.halves[.receiveSize], 64)
  }

  func testDMAForwarderRoutesMemoryCountersParentsSuspendResumeAndAbort() {
    let fixture = UARTBridgeFixture()
    let links = fixture.links
    XCTAssertTrue(links.isPresent(.transmit)); XCTAssertTrue(links.isPresent(.receive))
    links.writeMemory32(.receive, at: 0x2400_8000, value: 0xABCD_1234)
    XCTAssertEqual(links.readMemory32(.receive, at: 0x2400_8000), 0xABCD_1234)
    XCTAssertEqual(links.readMemory32(.transmit, at: 0x2400_8000), 0)
    fixture.rx.registers[.cbr1] = 0x1234_5678
    XCTAssertEqual(links.getCounter(.receive), 0x5678)
    let parent = links.readParent(.transmit)
    links.writeParent(.receive, value: UnsafeMutableRawPointer(bitPattern: 0xCAFE))
    XCTAssertEqual(links.readParent(.receive), UnsafeMutableRawPointer(bitPattern: 0xCAFE))
    XCTAssertEqual(links.readParent(.transmit), parent)
    XCTAssertEqual(links.startInterrupt(.transmit, sourceAddress: 0x2400_1000,
      destinationAddress: 0x4000_4428, sourceDataSize: 5), .ok)
    XCTAssertEqual(links.read(.transmit, word: .state), 2)
    XCTAssertEqual(links.suspend(.transmit, getTick: { 0 }), .ok)
    XCTAssertEqual(links.read(.transmit, word: .state), 5)
    XCTAssertEqual(links.resume(.transmit), .ok)
    XCTAssertEqual(links.abort(.transmit, getTick: { 0 }), .ok)
    XCTAssertEqual(links.read(.transmit, word: .state), 1)
    XCTAssertEqual(links.read(.transmit, word: .lock), 0)
  }

  func testForwarderDirectCallbackDoesExactlyOneReadAndPreservesSourceParent() {
    let fixture = UARTBridgeFixture()
    fixture.links.writeCallback(.transmit, id: .halfTransfer, value: fixture.links.callback(.transmitHalfComplete))
    fixture.tx.callbackReads = 0
    fixture.links.invokeCallback(.transmit, id: .halfTransfer)
    XCTAssertEqual(fixture.tx.callbackReads, 1)
    XCTAssertEqual(fixture.io.events, [.callback(.transmitHalfComplete)])
    let absent = UARTNoDMA()
    XCTAssertFalse(absent.isPresent(.transmit)); XCTAssertFalse(absent.isPresent(.receive))
    let one = UARTDMALinks(transmit: fixture.tx.driver)
    XCTAssertTrue(one.isPresent(.transmit)); XCTAssertFalse(one.isPresent(.receive))
  }
}
