import CTIMReference
import STM32H7RSHAL
import XCTest

private final class TIMBridgeOwner {
  var events: [UInt32] = []
  var source: UnsafeMutableRawPointer?
  var receive: (UnsafeMutableRawPointer?, UInt32) -> Void = { _, _ in }
}
private func timBridgeParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<DMAListTestIO>.fromOpaque(context!).takeUnretainedValue().readParent()
}
private func timBridgeDispatch(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  let owner = Unmanaged<TIMBridgeOwner>.fromOpaque(parent!).takeUnretainedValue()
  owner.events.append(kind)
  owner.source = source
  owner.receive(source, kind)
}
private struct TIMBridgeStorage: DMACallbackIO {
  let io: DMAListTestIO
  let context: UnsafeMutableRawPointer?
  func read(_ id: DMACallbackID) -> DMACallback? { io.read(id) }
  func write(_ id: DMACallbackID, value: DMACallback?) { io.write(id, value: value) }
  func readParent() -> UnsafeMutableRawPointer? { io.readParent() }
  func writeParent(_ value: UnsafeMutableRawPointer?) { io.writeParent(value) }
}
final class TIMDMALinksTests: XCTestCase {
  func testEveryDMAThunkReadsCurrentParentAndRetainsActualHandleIdentity() {
    let first = TIMBridgeOwner()
    let second = TIMBridgeOwner()
    let channel = DMAListTestIO()
    let context = Unmanaged.passUnretained(channel).toOpaque()
    var descriptor = TIMDMACallbackContext(
      dmaContext: context, readParent: timBridgeParent, dispatch: timBridgeDispatch)
    withUnsafeMutablePointer(to: &descriptor) { pointer in
      let dma = DMA(
        registers: channel, handle: channel,
        callbacks: TIMBridgeStorage(io: channel, context: UnsafeMutableRawPointer(pointer)),
        memory: channel)
      let links = TIMDMALinks(
        captureCompare1: dma, captureCompare2: dma, getSourceDataWidth: { _ in 0 })
      XCTAssertTrue(links.matches(.captureCompare1, context: context))
      XCTAssertTrue(links.matches(.captureCompare2, context: context))
      XCTAssertFalse(links.matches(.captureCompare3, context: context))
      XCTAssertFalse(
        links.matches(.captureCompare1, context: UnsafeMutableRawPointer(bitPattern: 1)))
      for owner in [first, second] {
        channel.parent = Unmanaged.passUnretained(owner).toOpaque()
        for kind in TIMDMACallbackKind.allCases {
          links.writeCallback(.captureCompare1, id: .transferComplete, value: links.callback(kind))
          channel.callbackSlots[0]!(UnsafeMutableRawPointer(pointer))
        }
        XCTAssertEqual(owner.events, TIMDMACallbackKind.allCases.map(\.rawValue))
        XCTAssertEqual(owner.source, context)
      }
    }
    XCTAssertEqual(channel.events.filter { $0 == .parentRead }.count, 26)
  }
  func testRealDMAStartAndInterruptCallsCurrentTimerParent() {
    let first = TIMFixture()
    let second = TIMFixture()
    let channel = DMAListTestIO()
    let parent = TIMBridgeOwner()
    channel.handleWords[.state] = 1
    channel.parent = Unmanaged.passUnretained(parent).toOpaque()
    var descriptor = TIMDMACallbackContext(
      dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: timBridgeParent,
      dispatch: timBridgeDispatch)
    withUnsafeMutablePointer(to: &descriptor) { pointer in
      let dma = DMA(
        registers: channel, handle: channel,
        callbacks: TIMBridgeStorage(io: channel, context: UnsafeMutableRawPointer(pointer)),
        memory: channel)
      let links = TIMDMALinks(update: dma, getSourceDataWidth: { _ in 2 })
      let driver = TIM(
        registers: first, handle: first, callbacks: first, dma: links, defaults: first.defaults,
        useRegisteredCallbacks: true)
      let secondDriver = TIM(
        registers: second, handle: second, callbacks: second, dma: links, defaults: second.defaults,
        useRegisteredCallbacks: true)
      first.write(.state, value: 1)
      XCTAssertEqual(driver.baseStartDMA(UnsafePointer(first.buffer()), 7), .ok)
      XCTAssertEqual(
        channel.registers[.csar], UInt32(truncatingIfNeeded: UInt(bitPattern: first.buffer())))
      XCTAssertEqual(channel.registers[.cdar], 0x4200_002C)
      XCTAssertEqual(channel.registers[.cbr1], 7)
      parent.receive = { source, kind in
        secondDriver.dmaCallback(TIMDMACallbackKind(rawValue: kind)!, sourceContext: source)
      }
      channel.registers[.csr] = 0x100
      channel.registers[.misr] = 1
      channel.registers[.cbr1] = 0
      dma.handleInterrupt()
      XCTAssertEqual(first.control(8), 0)
      XCTAssertEqual(second.control(8), 18)
      XCTAssertEqual(second.get(4, 0), 14)
      XCTAssertEqual(first.read(TIMHandleWord.state), 2)
      parent.receive = { _, _ in }
    }
  }
  func testBurstUsesLiveConfigurationWidthAndRealLinkedListHead() {
    let owner = TIMFixture()
    let channel = DMAListTestIO()
    var width: UInt32 = 0
    let links = TIMDMALinks(update: channel.driver, getSourceDataWidth: { _ in width })
    let driver = TIM(registers: owner, handle: owner, callbacks: owner, dma: links)
    for next: UInt32 in [0, 1, 2] {
      width = next
      owner.write(.dmaBurstState, value: 1)
      channel.handleWords[.state] = 1
      channel.handleWords[.lock] = 0
      XCTAssertEqual(
        driver.dmaBurstWriteStart(11, 0x100, UnsafePointer(owner.buffer()), 0x200), .ok)
      XCTAssertEqual(channel.registers[.cbr1], 3 << width)
    }
    owner.write(.dmaBurstState, value: 1)
    channel.handleWords[.state] = 1
    channel.handleWords[.lock] = 0
    channel.handleWords[.mode] = 0x81
    channel.handleWords[.queueAddress] = 0x2400_1000
    channel.seedQueue(0x2400_1000, nodes: [0x2400_1100])
    channel.memory[0x2400_1100] = 2
    XCTAssertEqual(driver.dmaBurstWriteStart(11, 0x100, UnsafePointer(owner.buffer()), 0x200), .ok)
    XCTAssertEqual(channel.memory[0x2400_1108], 12)
    XCTAssertEqual(
      channel.memory[0x2400_110C], UInt32(truncatingIfNeeded: UInt(bitPattern: owner.buffer())))
    XCTAssertEqual(channel.memory[0x2400_1110], 0x4200_03E0)
  }
}
