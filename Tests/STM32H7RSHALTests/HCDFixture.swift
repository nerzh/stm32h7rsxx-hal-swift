import CUSBReference
import STM32H7RSHAL
import XCTest

struct HCDTestHandle: HCDHandleIO {
  let state: OpaquePointer
  func read(_ word: HCDHandleWord) -> UInt32 { CUSB_HCDGetWord(state, UInt32(word.rawValue)) }
  func write(_ word: HCDHandleWord, value: UInt32) {
    CUSB_HCDSetWord(state, UInt32(word.rawValue), value)
  }
  func readConfiguration(_ field: USBConfigurationField) -> UInt8 {
    UInt8(truncatingIfNeeded: CUSB_HCDGetConfiguration(state, UInt32(field.rawValue)))
  }
  func writeConfiguration(_ field: USBConfigurationField, value: UInt8) {
    CUSB_HCDSetConfiguration(state, UInt32(field.rawValue), UInt32(value))
  }
  func channel(_ index: UInt32) -> HCDTestChannel { HCDTestChannel(state: state, index: index) }
}
struct HCDTestChannel: USBHostChannelIO {
  let state: OpaquePointer
  let index: UInt32
  func read(_ field: USBHostChannelField) -> UInt32 {
    CUSB_HCDChannelWord(state, index, UInt32(field.rawValue))
  }
  func write(_ field: USBHostChannelField, value: UInt32) {
    CUSB_HCDSetChannelWord(state, index, UInt32(field.rawValue), value)
  }
  func readBuffer() -> UnsafeMutablePointer<UInt8>? { CUSB_HCDChannelBuffer(state, index) }
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    CUSB_HCDSetChannelBuffer(state, index, value)
  }
}
struct HCDTestCallbacks: HCDCallbackIO {
  let state: OpaquePointer
  var context: UnsafeMutableRawPointer? { CUSB_HCDContext(state) }
  func read(_ id: HCDCallbackID) -> USBCallback? {
    let bits = CUSB_HCDGetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: USBCallback.self)
  }
  func write(_ id: HCDCallbackID, value: USBCallback?) {
    CUSB_HCDSetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readURB() -> HCDURBCallback? {
    let bits = CUSB_HCDGetCallback(state, 8)
    return bits == 0 ? nil : unsafeBitCast(bits, to: HCDURBCallback.self)
  }
  func writeURB(_ value: HCDURBCallback?) {
    CUSB_HCDSetCallback(state, 8, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
extension USBFixture {
  var hcdHandle: HCDTestHandle { HCDTestHandle(state: state) }
  var hcdCallbacks: HCDTestCallbacks { HCDTestCallbacks(state: state) }
  var hcd: HCD<USBFixture, HCDTestHandle, HCDTestCallbacks> {
    let defaults = HCDCallbackDefaults(
      startOfFrame: unsafeBitCast(CUSB_HCDCallback(1, 0), to: USBCallback.self),
      connect: unsafeBitCast(CUSB_HCDCallback(2, 0), to: USBCallback.self),
      disconnect: unsafeBitCast(CUSB_HCDCallback(3, 0), to: USBCallback.self),
      portEnabled: unsafeBitCast(CUSB_HCDCallback(4, 0), to: USBCallback.self),
      portDisabled: unsafeBitCast(CUSB_HCDCallback(5, 0), to: USBCallback.self),
      mspInitialize: unsafeBitCast(CUSB_HCDCallback(6, 0), to: USBCallback.self),
      mspDeinitialize: unsafeBitCast(CUSB_HCDCallback(7, 0), to: USBCallback.self),
      urbChange: unsafeBitCast(CUSB_HCDCallback(8, 0), to: HCDURBCallback.self))
    return HCD(
      usb: driver, handle: hcdHandle, callbacks: hcdCallbacks, defaults: defaults,
      useRegisteredCallbacks: control[9] != 0, inNAKAutoActivateDisabled: control[14] != 0)
  }
  func runHCD(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    let d = hcd
    let byte = UInt8(truncatingIfNeeded: a)
    switch operation {
    case 95: return d.initialize(delay: delay).rawValue
    case 96:
      return d.initializeChannel(
        byte, endpoint: UInt8(truncatingIfNeeded: b), deviceAddress: UInt8(truncatingIfNeeded: c),
        speed: UInt8(truncatingIfNeeded: control[5]), type: UInt8(truncatingIfNeeded: control[6]),
        maximumPacketSize: UInt16(truncatingIfNeeded: control[7])
      ).rawValue
    case 97: return d.haltChannel(byte).rawValue
    case 98: return d.deinitialize().rawValue
    case 99:
      return d.submitRequest(
        byte, direction: UInt8(truncatingIfNeeded: b), type: UInt8(truncatingIfNeeded: c),
        token: UInt8(truncatingIfNeeded: control[15]), buffer: buffer + Int(control[18]),
        length: UInt16(truncatingIfNeeded: control[16]),
        doPing: UInt8(truncatingIfNeeded: control[17])
      ).rawValue
    case 100:
      d.handleInterrupt()
      return 0
    case 101:
      return d.registerCallback(
        a,
        callback: b == 0
          ? nil : unsafeBitCast(CUSB_HCDCallback(a >= 1 && a <= 7 ? a : 1, 1), to: USBCallback.self)
      ).rawValue
    case 102: return d.unregisterCallback(a).rawValue
    case 103:
      return d.registerURBCallback(
        b == 0 ? nil : unsafeBitCast(CUSB_HCDCallback(8, 1), to: HCDURBCallback.self)
      ).rawValue
    case 104: return d.unregisterURBCallback().rawValue
    case 105: return d.start().rawValue
    case 106: return d.stop().rawValue
    case 107: return d.resetPort(delay: delay).rawValue
    case 108: return d.getState()
    case 109: return d.getURBState(byte)
    case 110: return d.getTransferCount(byte)
    case 111: return d.getChannelState(byte)
    case 112: return d.getCurrentFrame()
    case 113: return d.getCurrentSpeed()
    case 114:
      return d.setHubInfo(
        byte, address: UInt8(truncatingIfNeeded: b), port: UInt8(truncatingIfNeeded: c)
      ).rawValue
    case 115: return d.clearHubInfo(byte).rawValue
    case 116: return d.activateChannel(byte).rawValue
    default: preconditionFailure()
    }
  }
}
struct HCDPair {
  let c: USBFixture
  let swift: USBFixture
  init(highSpeed: Bool = true, callbacks: Bool = true, disableNAKAutoActivate: Bool = false) {
    c = USBFixture(highSpeed: highSpeed)
    swift = USBFixture(highSpeed: highSpeed)
    CUSB_HCDReset(c.state, callbacks ? 1 : 0, disableNAKAutoActivate ? 1 : 0)
    CUSB_HCDReset(swift.state, callbacks ? 1 : 0, disableNAKAutoActivate ? 1 : 0)
  }
  func setup(_ body: (USBFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0,
    file: StaticString = #filePath, line: UInt = #line
  ) {
    let expected = CUSB_HCDRun(c.state, operation, a, b, d)
    XCTAssertEqual(
      swift.runHCD(operation, a, b, d), expected, "HCD operation \(operation)", file: file,
      line: line)
    let difference = CUSB_HCDCompare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "HCD operation \(operation), difference \(String(difference,radix:16))",
      file: file, line: line)
  }
}
