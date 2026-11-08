import CUSBReference
import STM32H7RSHAL
import XCTest

final class USBFixture: USBRegisterIO {
  let state: OpaquePointer
  let allocation: UnsafeMutableRawPointer
  var accesses: [(Bool, UInt32, UInt32)] = []
  var recordAccesses = false
  var readTransform: ((USBRegister, UInt32) -> UInt32)?
  init(highSpeed: Bool = true) {
    allocation = .allocate(byteCount: CUSB_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CUSB_Reset(state, highSpeed ? 1 : 0)
  }
  deinit { allocation.deallocate() }
  var control: UnsafeMutablePointer<UInt32> { CUSB_Control(state)! }
  var buffer: UnsafeMutablePointer<UInt8> { CUSB_Buffer(state)! }
  var isHighSpeedInstance: Bool { control[0] != 0 }
  var driver: USB<USBFixture> { USB(registers: self, pollingTimeout: 32) }
  func delayAfterAHBIdle() {}
  func read(_ register: USBRegister) -> UInt32 {
    let original = CUSB_Registers(state)![Int(register.rawValue / 4)]
    let value = readTransform?(register, original) ?? original
    if recordAccesses { accesses.append((false, register.rawValue, value)) }
    return value
  }
  func write(_ register: USBRegister, value: UInt32) {
    CUSB_Registers(state)![Int(register.rawValue / 4)] = value
    if recordAccesses { accesses.append((true, register.rawValue, value)) }
  }
  func delay(_ milliseconds: UInt32) { CUSB_DelayFor(state, milliseconds) }
  var configuration: USBConfiguration {
    USBConfiguration(
      deviceEndpoints: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 0)),
      hostChannels: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 1)),
      dmaEnable: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 2)),
      speed: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 3)),
      endpoint0MaximumPacketSize: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 4)),
      phyInterface: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 5)),
      sofEnable: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 6)),
      lowPowerEnable: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 7)),
      lpmEnable: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 8)),
      batteryChargingEnable: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 9)),
      vbusSensingEnable: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 10)),
      useDedicatedEndpoint1: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 11)),
      useExternalVBUS: UInt8(truncatingIfNeeded: CUSB_GetConfiguration(state, 12)))
  }
  var endpoint: USBTestEndpoint { USBTestEndpoint(state: state) }
  var channel: USBTestChannel { USBTestChannel(state: state) }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    let d = driver
    let byte = UInt8(truncatingIfNeeded: a)
    switch operation {
    case 0: return d.initializeCore(configuration).rawValue
    case 1: return d.setTurnaroundTime(hclk: a, speed: UInt8(truncatingIfNeeded: b)).rawValue
    case 2: return d.enableGlobalInterrupt().rawValue
    case 3: return d.disableGlobalInterrupt().rawValue
    case 4: return d.setCurrentMode(a, delay: delay).rawValue
    case 5: return d.initializeDevice(configuration).rawValue
    case 6: return d.flushTransmitFIFO(a).rawValue
    case 7: return d.flushReceiveFIFO().rawValue
    case 8: return d.setDeviceSpeed(byte).rawValue
    case 9: return UInt32(d.getDeviceSpeed())
    case 10: return d.activateEndpoint(endpoint).rawValue
    case 11: return d.activateDedicatedEndpoint(endpoint).rawValue
    case 12: return d.deactivateEndpoint(endpoint).rawValue
    case 13: return d.deactivateDedicatedEndpoint(endpoint).rawValue
    case 14: return d.startEndpointTransfer(endpoint, dma: byte).rawValue
    case 15: return d.stopEndpointTransfer(endpoint).rawValue
    case 16: return d.setEndpointStall(endpoint).rawValue
    case 17: return d.clearEndpointStall(endpoint).rawValue
    case 18:
      return d.writePacket(
        buffer + Int(c), channelOrEndpoint: byte, length: UInt16(truncatingIfNeeded: b), dma: 0
      ).rawValue
    case 19:
      return UInt32(
        buffer.distance(to: d.readPacket(buffer + Int(c), length: UInt16(truncatingIfNeeded: b))!))
    case 20: return d.stopDevice().rawValue
    case 21: return d.setDeviceAddress(byte).rawValue
    case 22: return d.connectDevice().rawValue
    case 23: return d.disconnectDevice().rawValue
    case 24: return UInt32(d.readInterrupts())
    case 25: return UInt32(d.readChannelInterrupts(byte))
    case 26: return UInt32(d.readAllOutEndpointInterrupts())
    case 27: return UInt32(d.readAllInEndpointInterrupts())
    case 28: return UInt32(d.readOutEndpointInterrupts(byte))
    case 29: return UInt32(d.readInEndpointInterrupts(byte))
    case 30:
      d.clearInterrupts(a)
      return 0
    case 31: return UInt32(d.getMode())
    case 32: return d.activateSetup().rawValue
    case 33: return d.startEndpoint0Out(dma: byte, setup: buffer + Int(c)).rawValue
    case 35: return d.initializeHost(configuration).rawValue
    case 36: return d.initializeFullLowSpeedClock(byte).rawValue
    case 37: return d.resetPort(delay: delay).rawValue
    case 38: return d.driveVBUS(byte).rawValue
    case 39: return UInt32(d.getHostSpeed())
    case 40: return UInt32(d.getCurrentFrame())
    case 41:
      return d.initializeHostChannel(
        byte, endpoint: UInt8(truncatingIfNeeded: b), deviceAddress: UInt8(truncatingIfNeeded: c),
        speed: UInt8(truncatingIfNeeded: control[5]), type: UInt8(truncatingIfNeeded: control[6]),
        maximumPacketSize: UInt16(truncatingIfNeeded: control[7])
      ).rawValue
    case 42: return d.startHostChannelTransfer(channel, dma: byte).rawValue
    case 43: return UInt32(d.readHostChannelInterrupts())
    case 44: return d.haltHostChannel(byte).rawValue
    case 45: return d.activateHostChannel(byte, direction: UInt8(truncatingIfNeeded: b)).rawValue
    case 46: return d.doPing(byte).rawValue
    case 47: return d.stopHost().rawValue
    case 48: return d.activateRemoteWakeup().rawValue
    case 49: return d.deactivateRemoteWakeup().rawValue
    default: preconditionFailure()
    }
  }
}
struct USBTestEndpoint: USBEndpointIO {
  let state: OpaquePointer
  func read(_ field: USBEndpointField) -> UInt32 { CUSB_GetEndpoint(state, UInt32(field.rawValue)) }
  func write(_ field: USBEndpointField, value: UInt32) {
    CUSB_SetEndpoint(state, UInt32(field.rawValue), value)
  }
  func readBuffer() -> UnsafeMutablePointer<UInt8>? { CUSB_GetEndpointBuffer(state) }
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) { CUSB_SetEndpointBuffer(state, value) }
}
struct USBTestChannel: USBHostChannelIO {
  let state: OpaquePointer
  func read(_ field: USBHostChannelField) -> UInt32 {
    CUSB_GetChannel(state, UInt32(field.rawValue))
  }
  func write(_ field: USBHostChannelField, value: UInt32) {
    CUSB_SetChannel(state, UInt32(field.rawValue), value)
  }
  func readBuffer() -> UnsafeMutablePointer<UInt8>? { CUSB_GetChannelBuffer(state) }
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) { CUSB_SetChannelBuffer(state, value) }
}
struct USBPair {
  let c: USBFixture
  let swift: USBFixture
  init(highSpeed: Bool = true) {
    c = USBFixture(highSpeed: highSpeed)
    swift = USBFixture(highSpeed: highSpeed)
  }
  func setup(_ body: (USBFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0,
    file: StaticString = #filePath, line: UInt = #line
  ) {
    let expected = CUSB_Run(c.state, operation, a, b, d)
    XCTAssertEqual(
      swift.run(operation, a, b, d), expected, "operation \(operation)", file: file, line: line)
    let difference = CUSB_Compare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "operation \(operation), difference \(String(difference, radix: 16))",
      file: file, line: line)
  }
}
