import STM32H7RSHAL
import XCTest

private func i2cBridgeParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<I2CBridgeChannel>.fromOpaque(context!).takeUnretainedValue().parent
}
private func i2cBridgeDispatch(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  let owner = Unmanaged<I2CBridgeFixture>.fromOpaque(parent!).takeUnretainedValue()
  owner.events.append(kind)
  owner.sources.append(source)
  owner.i2c.dmaCallback(I2CDMACallbackKind(rawValue: kind)!)
}
private final class I2CBridgeChannel: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
  let channel: DMAChannel
  var registers: [DMARegister: UInt32] = [:]
  var words: [DMAHandleWord: UInt32] = [.state: 1]
  var callbacks: [DMACallbackID: DMACallback] = [:]
  var parent: UnsafeMutableRawPointer?
  var memory: [UInt32: UInt32] = [:]
  var callbackReads = 0
  let descriptor = UnsafeMutablePointer<I2CDMACallbackContext>.allocate(capacity: 1)
  init(index: Int) {
    channel = DMAChannel(controller: .gpdma1, index: index)
    descriptor.initialize(
      to: .init(
        dmaContext: Unmanaged.passUnretained(self).toOpaque(),
        readParent: i2cBridgeParent, dispatch: i2cBridgeDispatch))
  }
  deinit {
    descriptor.deinitialize(count: 1)
    descriptor.deallocate()
  }
  var driver: DMA<I2CBridgeChannel, I2CBridgeChannel, I2CBridgeChannel, I2CBridgeChannel> {
    .init(registers: self, handle: self, callbacks: self, memory: self)
  }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(descriptor) }
  func read(_ register: DMARegister) -> UInt32 { registers[register, default: 0] }
  func write(_ register: DMARegister, value: UInt32) {
    registers[register] = value
    if register == .cfcr { registers[.csr, default: 0] &= ~value }
    if register == .ccr && value & 4 != 0 { registers[.csr, default: 0] |= 0x2000 }
    if register == .ccr && value & 2 != 0 {
      registers[.ccr] = value & ~UInt32(7)
      registers[.csr, default: 0] |= 1
    }
  }
  func read(_ word: DMAHandleWord) -> UInt32 { words[word, default: 0] }
  func write(_ word: DMAHandleWord, value: UInt32) { words[word] = value }
  func read(_ id: DMACallbackID) -> DMACallback? {
    callbackReads += 1
    return callbacks[id]
  }
  func write(_ id: DMACallbackID, value: DMACallback?) { callbacks[id] = value }
  func readParent() -> UnsafeMutableRawPointer? { parent }
  func writeParent(_ value: UnsafeMutableRawPointer?) { parent = value }
  func read32(at address: UInt32) -> UInt32 { memory[address, default: 0] }
  func write32(at address: UInt32, value: UInt32) { memory[address] = value }
}

private final class I2CBridgeFixture {
  let io = I2CFixture()
  let tx = I2CBridgeChannel(index: 0)
  let rx = I2CBridgeChannel(index: 1)
  var events: [UInt32] = []
  var sources: [UnsafeMutableRawPointer?] = []
  init() {
    tx.parent = Unmanaged.passUnretained(self).toOpaque()
    rx.parent = Unmanaged.passUnretained(self).toOpaque()
    io.write(.state, value: 0x20)
    io.write(.addressingMode, value: 1)
  }
  var links: I2CDMALinks<I2CBridgeChannel, I2CBridgeChannel, I2CBridgeChannel, I2CBridgeChannel> {
    .init(transmit: tx.driver, receive: rx.driver)
  }
  var i2c:
    I2C<
      I2CFixture, I2CFixture, I2CFixture,
      I2CDMALinks<I2CBridgeChannel, I2CBridgeChannel, I2CBridgeChannel, I2CBridgeChannel>
    >
  {
    .init(
      registers: io, handle: io, callbacks: io, dma: links, defaults: io.defaults,
      useRegisteredCallbacks: true)
  }
}
final class I2CDMALinksTests: XCTestCase {
  func testRealDMAChunkReloadAndStopCompletionBothDirections() {
    for receive in [false, true] {
      let f = I2CBridgeFixture()
      let channel = receive ? f.rx : f.tx
      let status =
        receive
        ? f.i2c.masterReceiveDMA(address: 0xA0, buffer: f.io.buffer, count: 257)
        : f.i2c.masterTransmitDMA(address: 0xA0, buffer: f.io.buffer, count: 257)
      XCTAssertEqual(status, .ok)
      XCTAssertEqual(channel.words[.state], 2)
      XCTAssertEqual(channel.registers[.cbr1], 255)
      XCTAssertEqual(
        channel.registers[receive ? .csar : .cdar], receive ? 0x4000_5424 : 0x4000_5428)
      XCTAssertEqual(f.io.read(.transferCount), 2)
      channel.registers[.csr] = 0x100
      channel.registers[.cbr1] = 0
      channel.registers[.misr] = 1 << channel.channel.index
      channel.driver.handleInterrupt()
      XCTAssertEqual(channel.registers[.cbr1], 2)
      XCTAssertEqual(channel.words[.state], 2)
      XCTAssertEqual(f.io.readBuffer(), f.io.buffer + 255)
      f.io.write(.isr, value: 0x80)
      f.i2c.eventInterruptHandler()
      XCTAssertEqual(f.io.read(.transferCount), 0)
      XCTAssertEqual(f.io.read(.cr1) & (receive ? 0x8000 : 0x4000), receive ? 0x8000 : 0x4000)
      channel.registers[.csr] = 0x100
      channel.registers[.cbr1] = 0
      channel.driver.handleInterrupt()
      XCTAssertEqual(channel.words[.state], 1)
      XCTAssertEqual(f.io.read(.state), receive ? 0x22 : 0x21)
      XCTAssertEqual(f.io.control(8), 0)
      f.io.write(.isr, value: 0x20)
      f.i2c.eventInterruptHandler()
      XCTAssertEqual(f.io.read(.state), 0x20)
      XCTAssertEqual(f.io.read(.mode), 0)
      XCTAssertEqual(f.io.control(8), 11)
      XCTAssertEqual(f.events, receive ? [1, 1] : [0, 0])
    }
  }
  func testLiveDMAParentAndFIFOLevelAreForwarded() {
    let first = I2CBridgeFixture()
    let second = I2CBridgeFixture()
    first.tx.registers[.csr] = 0x5A0000
    XCTAssertEqual(first.links.getFIFOLevel(.transmit), 0x5A)
    first.tx.parent = Unmanaged.passUnretained(second).toOpaque()
    second.io.write(.cr1, value: 0x4000)
    first.links.callback(.masterTransmitComplete)(first.tx.context)
    XCTAssertTrue(first.events.isEmpty)
    XCTAssertEqual(second.events, [0])
    XCTAssertEqual(second.sources, [Unmanaged.passUnretained(first.tx).toOpaque()])
    XCTAssertEqual(second.io.read(.cr1) & 0x4000, 0)
  }
  func testAbortFallbackReadsCurrentCallbackExactlyOnce() {
    let f = I2CBridgeFixture()
    f.links.writeCallback(.transmit, id: .abort, value: f.links.callback(.abort))
    f.io.write(.state, value: 0x60)
    f.tx.callbackReads = 0
    f.links.invokeCallback(.transmit, id: .abort)
    XCTAssertEqual(f.tx.callbackReads, 1)
    XCTAssertEqual(f.events, [5])
    XCTAssertNil(f.tx.callbacks[.abort])
    XCTAssertEqual(f.io.read(.state), 0x20)
    XCTAssertEqual(f.io.control(8), 11)
  }
}
