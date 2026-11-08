import STM32H7RSHAL
import XCTest

private func audioParent(_ context: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
  Unmanaged<DMAListTestIO>.fromOpaque(context!).takeUnretainedValue().readParent()
}
private func i2sAudioDispatch(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  let owner = Unmanaged<I2SFixture>.fromOpaque(parent!).takeUnretainedValue()
  let channel = Unmanaged<DMAListTestIO>.fromOpaque(source!).takeUnretainedValue()
  owner.driver.dmaCallback(
    I2SDMACallbackKind(rawValue: kind)!,
    source: DMAConfiguration(mode: channel.memory[0x9000, default: 0]))
}
private func saiAudioDispatch(
  _ parent: UnsafeMutableRawPointer?, _ source: UnsafeMutableRawPointer?, _ kind: UInt32
) {
  let owner = Unmanaged<SAIFixture>.fromOpaque(parent!).takeUnretainedValue()
  let channel = Unmanaged<DMAListTestIO>.fromOpaque(source!).takeUnretainedValue()
  owner.driver.dmaCallback(
    SAIDMACallbackKind(rawValue: kind)!, source: channel.driver, systemCoreClock: { 64_000_000 })
}
private struct AudioCallbackStorage: DMACallbackIO {
  let io: DMAListTestIO
  let context: UnsafeMutableRawPointer?
  func read(_ id: DMACallbackID) -> DMACallback? { io.read(id) }
  func write(_ id: DMACallbackID, value: DMACallback?) { io.write(id, value: value) }
  func readParent() -> UnsafeMutableRawPointer? { io.readParent() }
  func writeParent(_ value: UnsafeMutableRawPointer?) { io.writeParent(value) }
}
final class AudioDMALinksTests: XCTestCase {
  func testI2SUsesRealDMAStartAndCurrentParentWithOriginalConfigurationMode() {
    for receive in [false, true] {
      for format: UInt32 in [0, 0x100] {
        let io = I2SFixture()
        let other = I2SFixture()
        let channel = DMAListTestIO()
        channel.handleWords[.state] = 1
        channel.parent = Unmanaged.passUnretained(io).toOpaque()
        var descriptor = I2SDMACallbackContext(
          dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: audioParent,
          dispatch: i2sAudioDispatch)
        withUnsafeMutablePointer(to: &descriptor) { pointer in
          let d = DMA(
            registers: channel, handle: channel,
            callbacks: AudioCallbackStorage(io: channel, context: UnsafeMutableRawPointer(pointer)),
            memory: channel)
          let links = I2SDMALinks(transmit: receive ? nil : d, receive: receive ? d : nil)
          let audio = I2S(
            registers: io, handle: io, callbacks: io, dma: links, defaults: io.defaults,
            useRegisteredCallbacks: true)
          io.write(.state, value: 1)
          io.write(.dataFormat, value: format)
          let status =
            receive
            ? audio.receiveDMA(buffer: UnsafeMutableRawPointer(io.buffer()), count: 3)
            : audio.transmitDMA(buffer: UnsafeMutableRawPointer(io.buffer()), count: 3)
          XCTAssertEqual(status, .ok)
          XCTAssertEqual(channel.registers[.cbr1], format == 0 ? 6 : 12)
          XCTAssertEqual(
            channel.registers[receive ? .csar : .cdar], io.instance.rawValue + (receive ? 48 : 32))
          other.write(.state, value: 5)
          other.write(.transmitCount, value: 17)
          other.write(.receiveCount, value: 19)
          other.write(.cfg1, value: 0xC000)
          channel.parent = Unmanaged.passUnretained(other).toOpaque()
          channel.memory[0x9000] = 1
          channel.callbackSlots[0]!(UnsafeMutableRawPointer(pointer))
          XCTAssertEqual(other.read(.state), 5)
          channel.memory[0x9000] = 0
          channel.registers[.csr] = 0x100
          channel.registers[.misr] = 1
          channel.registers[.cbr1] = 0
          d.handleInterrupt()
          XCTAssertEqual(other.read(.state), 1)
          XCTAssertEqual(other.read(receive ? I2SHandleHalfWord.receiveCount : .transmitCount), 0)
          XCTAssertEqual(io.control(8), 0)
          XCTAssertEqual(other.control(8), 20)
        }
      }
    }
  }
  func testSAIUsesRealDMAAndReadsCurrentHandleMode() {
    for receive in [false, true] {
      for size: UInt32 in [0x40, 0x80, 0xE0] {
        let io = SAIFixture()
        let channel = DMAListTestIO()
        channel.handleWords[.state] = 1
        channel.parent = Unmanaged.passUnretained(io).toOpaque()
        var descriptor = SAIDMACallbackContext(
          dmaContext: Unmanaged.passUnretained(channel).toOpaque(), readParent: audioParent,
          dispatch: saiAudioDispatch)
        withUnsafeMutablePointer(to: &descriptor) { pointer in
          let d = DMA(
            registers: channel, handle: channel,
            callbacks: AudioCallbackStorage(io: channel, context: UnsafeMutableRawPointer(pointer)),
            memory: channel)
          let audio = SAI(
            registers: io, handle: io, callbacks: io,
            dma: SAIDMALinks(transmit: receive ? nil : d, receive: receive ? d : nil),
            defaults: io.defaults, useRegisteredCallbacks: true)
          io.write(.state, value: 1)
          io.write(.dataSize, value: size)
          io.write(.sr, value: 0x10000)
          let status =
            receive
            ? audio.receiveDMA(buffer: io.buffer(), count: 3)
            : audio.transmitDMA(buffer: io.buffer(), count: 3, getTick: { 0 })
          XCTAssertEqual(status, .ok)
          XCTAssertEqual(channel.registers[.cbr1], size == 0x40 ? 3 : size == 0x80 ? 6 : 12)
          channel.handleWords[.mode] = 0x81
          channel.callbackSlots[0]!(UnsafeMutableRawPointer(pointer))
          XCTAssertEqual(io.read(.transferCount), 3)
          channel.handleWords[.mode] = 0
          channel.registers[.csr] = 0x100
          channel.registers[.misr] = 1
          channel.registers[.cbr1] = 0
          d.handleInterrupt()
          XCTAssertEqual(io.read(.state), 1)
          XCTAssertEqual(io.read(.transferCount), 0)
          XCTAssertEqual(io.read(.cr1) & 0x20000, 0)
          XCTAssertEqual(io.control(8), 20)
        }
      }
    }
  }
}
