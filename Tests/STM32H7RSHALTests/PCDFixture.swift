import CUSBReference
import STM32H7RSHAL
import XCTest

struct PCDTestHandle: PCDHandleIO {
  let state: OpaquePointer
  func read(_ word: PCDHandleWord) -> UInt32 { CUSB_PCDGetWord(state, UInt32(word.rawValue)) }
  func write(_ word: PCDHandleWord, value: UInt32) {
    CUSB_PCDSetWord(state, UInt32(word.rawValue), value)
  }
  func readConfiguration(_ field: USBConfigurationField) -> UInt8 {
    UInt8(truncatingIfNeeded: CUSB_PCDGetConfiguration(state, UInt32(field.rawValue)))
  }
  func writeConfiguration(_ field: USBConfigurationField, value: UInt8) {
    CUSB_PCDSetConfiguration(state, UInt32(field.rawValue), UInt32(value))
  }
  func endpoint(_ index: UInt32, isIn: Bool) -> PCDTestEndpoint {
    PCDTestEndpoint(state: state, index: index, direction: isIn ? 1 : 0)
  }
  func setupBuffer() -> UnsafeMutablePointer<UInt8> { CUSB_PCDSetup(state)! }
}
struct PCDTestEndpoint: USBEndpointIO {
  let state: OpaquePointer
  let index: UInt32
  let direction: UInt32
  func read(_ field: USBEndpointField) -> UInt32 {
    CUSB_PCDEndpointWord(state, direction, index, UInt32(field.rawValue))
  }
  func write(_ field: USBEndpointField, value: UInt32) {
    CUSB_PCDSetEndpointWord(state, direction, index, UInt32(field.rawValue), value)
  }
  func readBuffer() -> UnsafeMutablePointer<UInt8>? {
    CUSB_PCDEndpointBuffer(state, direction, index)
  }
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    CUSB_PCDSetEndpointBuffer(state, direction, index, value)
  }
}
struct PCDTestCallbacks: PCDCallbackIO {
  let state: OpaquePointer
  var context: UnsafeMutableRawPointer? { CUSB_PCDContext(state) }
  func read(_ id: PCDCallbackID) -> USBCallback? {
    let bits = CUSB_PCDGetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: USBCallback.self)
  }
  func write(_ id: PCDCallbackID, value: USBCallback?) {
    CUSB_PCDSetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readEndpoint(_ id: PCDEndpointCallbackID) -> USBEndpointCallback? {
    let bits = CUSB_PCDGetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: USBEndpointCallback.self)
  }
  func writeEndpoint(_ id: PCDEndpointCallbackID, value: USBEndpointCallback?) {
    CUSB_PCDSetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readMessage(_ id: PCDMessageCallbackID) -> USBMessageCallback? {
    let bits = CUSB_PCDGetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: USBMessageCallback.self)
  }
  func writeMessage(_ id: PCDMessageCallbackID, value: USBMessageCallback?) {
    CUSB_PCDSetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
}
extension USBFixture {
  var pcdHandle: PCDTestHandle { PCDTestHandle(state: state) }
  var pcdCallbacks: PCDTestCallbacks { PCDTestCallbacks(state: state) }
  var pcd: PCD<USBFixture, PCDTestHandle, PCDTestCallbacks> {
    let defaults = PCDCallbackDefaults(
      startOfFrame: unsafeBitCast(CUSB_PCDCallback(1, 0), to: USBCallback.self),
      setupStage: unsafeBitCast(CUSB_PCDCallback(2, 0), to: USBCallback.self),
      reset: unsafeBitCast(CUSB_PCDCallback(3, 0), to: USBCallback.self),
      suspend: unsafeBitCast(CUSB_PCDCallback(4, 0), to: USBCallback.self),
      resume: unsafeBitCast(CUSB_PCDCallback(5, 0), to: USBCallback.self),
      connect: unsafeBitCast(CUSB_PCDCallback(6, 0), to: USBCallback.self),
      disconnect: unsafeBitCast(CUSB_PCDCallback(7, 0), to: USBCallback.self),
      mspInitialize: unsafeBitCast(CUSB_PCDCallback(8, 0), to: USBCallback.self),
      mspDeinitialize: unsafeBitCast(CUSB_PCDCallback(9, 0), to: USBCallback.self),
      dataOut: unsafeBitCast(CUSB_PCDCallback(10, 0), to: USBEndpointCallback.self),
      dataIn: unsafeBitCast(CUSB_PCDCallback(11, 0), to: USBEndpointCallback.self),
      isochronousOutIncomplete: unsafeBitCast(
        CUSB_PCDCallback(12, 0), to: USBEndpointCallback.self),
      isochronousInIncomplete: unsafeBitCast(CUSB_PCDCallback(13, 0), to: USBEndpointCallback.self),
      batteryCharging: unsafeBitCast(CUSB_PCDCallback(14, 0), to: USBMessageCallback.self),
      linkPowerManagement: unsafeBitCast(CUSB_PCDCallback(15, 0), to: USBMessageCallback.self))
    return PCD(
      usb: driver, handle: pcdHandle, callbacks: pcdCallbacks, defaults: defaults,
      useRegisteredCallbacks: control[9] != 0)
  }
  func pcdTick() -> UInt32 {
    let value = control[2]
    control[2] &+= control[10]
    control[11] &+= 1
    return value
  }
  func pcdHCLK() -> UInt32 {
    control[13] &+= 1
    return control[12]
  }
  func runPCD(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    let d = pcd
    let byte = UInt8(truncatingIfNeeded: a)
    switch operation {
    case 50: return d.initialize(delay: delay).rawValue
    case 51: return d.deinitialize().rawValue
    case 52:
      return d.registerCallback(
        a,
        callback: b == 0
          ? nil : unsafeBitCast(CUSB_PCDCallback(a >= 1 && a <= 9 ? a : 1, 1), to: USBCallback.self)
      ).rawValue
    case 53: return d.unregisterCallback(a).rawValue
    case 54:
      return d.registerEndpointCallback(
        .dataOut,
        callback: b == 0
          ? nil : unsafeBitCast(CUSB_PCDCallback(10, 1), to: USBEndpointCallback.self)
      ).rawValue
    case 55: return d.unregisterEndpointCallback(.dataOut).rawValue
    case 56:
      return d.registerEndpointCallback(
        .dataIn,
        callback: b == 0
          ? nil : unsafeBitCast(CUSB_PCDCallback(11, 1), to: USBEndpointCallback.self)
      ).rawValue
    case 57: return d.unregisterEndpointCallback(.dataIn).rawValue
    case 58:
      return d.registerEndpointCallback(
        .isochronousOutIncomplete,
        callback: b == 0
          ? nil : unsafeBitCast(CUSB_PCDCallback(12, 1), to: USBEndpointCallback.self)
      ).rawValue
    case 59: return d.unregisterEndpointCallback(.isochronousOutIncomplete).rawValue
    case 60:
      return d.registerEndpointCallback(
        .isochronousInIncomplete,
        callback: b == 0
          ? nil : unsafeBitCast(CUSB_PCDCallback(13, 1), to: USBEndpointCallback.self)
      ).rawValue
    case 61: return d.unregisterEndpointCallback(.isochronousInIncomplete).rawValue
    case 62:
      return d.registerMessageCallback(
        .batteryCharging,
        callback: b == 0 ? nil : unsafeBitCast(CUSB_PCDCallback(14, 1), to: USBMessageCallback.self)
      ).rawValue
    case 63: return d.unregisterMessageCallback(.batteryCharging).rawValue
    case 64:
      return d.registerMessageCallback(
        .linkPowerManagement,
        callback: b == 0 ? nil : unsafeBitCast(CUSB_PCDCallback(15, 1), to: USBMessageCallback.self)
      ).rawValue
    case 65: return d.unregisterMessageCallback(.linkPowerManagement).rawValue
    case 66: return d.start().rawValue
    case 67: return d.stop().rawValue
    case 68:
      d.handleInterrupt(getHCLKFrequency: pcdHCLK)
      return 0
    case 69: return d.connectDevice().rawValue
    case 70: return d.disconnectDevice().rawValue
    case 71: return d.setAddress(byte).rawValue
    case 72:
      return d.openEndpoint(
        byte, maximumPacketSize: UInt16(truncatingIfNeeded: b), type: UInt8(truncatingIfNeeded: c)
      ).rawValue
    case 73: return d.closeEndpoint(byte).rawValue
    case 74: return d.receive(byte, buffer: buffer + Int(c), length: b).rawValue
    case 75: return d.getReceiveCount(byte)
    case 76: return d.transmit(byte, buffer: buffer + Int(c), length: b).rawValue
    case 77: return d.setEndpointStall(byte).rawValue
    case 78: return d.clearEndpointStall(byte).rawValue
    case 79: return d.abortEndpoint(byte).rawValue
    case 80: return d.flushEndpoint(byte).rawValue
    case 81: return d.activateRemoteWakeup().rawValue
    case 82: return d.deactivateRemoteWakeup().rawValue
    case 83: return d.getState()
    case 84: return d.setTestMode(byte).rawValue
    case 88: return d.setTransmitFIFO(byte, size: UInt16(truncatingIfNeeded: b)).rawValue
    case 89: return d.setReceiveFIFO(size: UInt16(truncatingIfNeeded: a)).rawValue
    case 90: return d.activateLPM().rawValue
    case 91: return d.deactivateLPM().rawValue
    case 92:
      d.detectBatteryChargingVBUS(getTick: pcdTick, delay: delay)
      return 0
    case 93: return d.activateBatteryCharging().rawValue
    case 94: return d.deactivateBatteryCharging().rawValue
    default: preconditionFailure()
    }
  }
}
struct PCDPair {
  let c: USBFixture
  let swift: USBFixture
  init(highSpeed: Bool = true, callbacks: Bool = true) {
    c = USBFixture(highSpeed: highSpeed)
    swift = USBFixture(highSpeed: highSpeed)
    CUSB_PCDReset(c.state, callbacks ? 1 : 0)
    CUSB_PCDReset(swift.state, callbacks ? 1 : 0)
  }
  func setup(_ body: (USBFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0,
    file: StaticString = #filePath, line: UInt = #line
  ) {
    let expected = CUSB_PCDRun(c.state, operation, a, b, d)
    XCTAssertEqual(
      swift.runPCD(operation, a, b, d), expected, "PCD operation \(operation)", file: file,
      line: line)
    let difference = CUSB_PCDCompare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "PCD operation \(operation), difference \(String(difference,radix:16))",
      file: file, line: line)
  }
}
