import CSMBUSReference
import XCTest

@testable import STM32H7RSHAL

final class SMBUSFixture: SMBUSRegisterIO, SMBUSHandleIO, SMBUSCallbackIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(callbacks: Bool = true) {
    allocation = .allocate(byteCount: CSMBUS_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CSMBUS_Reset(state, callbacks ? 1 : 0)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  var buffer: UnsafeMutablePointer<UInt8> { CSMBUS_Buffer(state)! }
  func control(_ index: UInt32) -> UInt32 { CSMBUS_Get(state, 2, index) }
  func control(_ index: UInt32, _ value: UInt32) { CSMBUS_Set(state, 2, index, value) }
  func read(_ register: SMBUSRegister) -> UInt32 { CSMBUS_Get(state, 0, register.rawValue / 4) }
  func write(_ register: SMBUSRegister, value: UInt32) {
    CSMBUS_Set(state, 0, register.rawValue / 4, value)
  }
  func address(of register: SMBUSRegister) -> UInt32 { 0x4000_5400 + register.rawValue }
  func read(_ word: SMBUSConfigurationWord) -> UInt32 {
    CSMBUS_Get(state, 1, UInt32(word.rawValue))
  }
  func write(_ word: SMBUSConfigurationWord, value: UInt32) {
    CSMBUS_Set(state, 1, UInt32(word.rawValue), value)
  }
  func read(_ word: SMBUSHandleHalfWord) -> UInt16 {
    UInt16(truncatingIfNeeded: CSMBUS_Get(state, 1, 12 + UInt32(word.rawValue)))
  }
  func write(_ word: SMBUSHandleHalfWord, value: UInt16) {
    CSMBUS_Set(state, 1, 12 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: SMBUSHandleWord) -> UInt32 { CSMBUS_Get(state, 1, 14 + UInt32(word.rawValue)) }
  func write(_ word: SMBUSHandleWord, value: UInt32) {
    CSMBUS_Set(state, 1, 14 + UInt32(word.rawValue), value)
  }
  func readBuffer() -> UnsafeMutablePointer<UInt8>? { CSMBUS_GetBuffer(state) }
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) { CSMBUS_SetBuffer(state, value) }
  func read(_ id: SMBUSCallbackID) -> SMBUSCallback? {
    let bits = CSMBUS_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SMBUSCallback.self)
  }
  func write(_ id: SMBUSCallbackID, value: SMBUSCallback?) {
    CSMBUS_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readAddress() -> SMBUSAddressCallback? {
    let bits = CSMBUS_GetCallback(state, 8)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SMBUSAddressCallback.self)
  }
  func writeAddress(_ value: SMBUSAddressCallback?) {
    CSMBUS_SetCallback(state, 8, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: SMBUSCallbackDefaults {
    .init(
      masterTransmitComplete: unsafeBitCast(CSMBUS_Callback(0, 1), to: SMBUSCallback.self),
      masterReceiveComplete: unsafeBitCast(CSMBUS_Callback(1, 1), to: SMBUSCallback.self),
      slaveTransmitComplete: unsafeBitCast(CSMBUS_Callback(2, 1), to: SMBUSCallback.self),
      slaveReceiveComplete: unsafeBitCast(CSMBUS_Callback(3, 1), to: SMBUSCallback.self),
      listenComplete: unsafeBitCast(CSMBUS_Callback(4, 1), to: SMBUSCallback.self),
      error: unsafeBitCast(CSMBUS_Callback(5, 1), to: SMBUSCallback.self),
      mspInitialize: unsafeBitCast(CSMBUS_Callback(6, 1), to: SMBUSCallback.self),
      mspDeinitialize: unsafeBitCast(CSMBUS_Callback(7, 1), to: SMBUSCallback.self),
      address: unsafeBitCast(CSMBUS_Callback(8, 1), to: SMBUSAddressCallback.self))
  }
  var driver: SMBUS<SMBUSFixture, SMBUSFixture, SMBUSFixture> {
    .init(
      registers: self, handle: self, callbacks: self, defaults: defaults,
      useRegisteredCallbacks: control(31) != 0)
  }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    let d = driver
    switch operation {
    case 0: return d.initialize().rawValue
    case 1: return d.deinitialize().rawValue
    case 2: return d.configureAnalogFilter(a).rawValue
    case 3: return d.configureDigitalFilter(a).rawValue
    case 4:
      return d.registerCallback(
        a, b == 0 ? nil : unsafeBitCast(CSMBUS_Callback(a < 8 ? a : 0, b), to: SMBUSCallback.self)
      ).rawValue
    case 5: return d.unregisterCallback(a).rawValue
    case 6:
      return d.registerAddressCallback(
        b == 0 ? nil : unsafeBitCast(CSMBUS_Callback(8, b), to: SMBUSAddressCallback.self)
      ).rawValue
    case 7: return d.unregisterAddressCallback().rawValue
    case 8:
      return d.masterTransmitInterrupt(
        UInt16(truncatingIfNeeded: a), control(13) != 0 ? nil : buffer + Int(control(14)),
        UInt16(truncatingIfNeeded: b), control(17)
      ).rawValue
    case 9:
      return d.masterReceiveInterrupt(
        UInt16(truncatingIfNeeded: a), control(13) != 0 ? nil : buffer + Int(control(14)),
        UInt16(truncatingIfNeeded: b), control(17)
      ).rawValue
    case 10: return d.abortMasterInterrupt(UInt16(truncatingIfNeeded: a)).rawValue
    case 11:
      return d.slaveTransmitInterrupt(
        control(13) != 0 ? nil : buffer + Int(control(14)), UInt16(truncatingIfNeeded: b),
        control(17)
      ).rawValue
    case 12:
      return d.slaveReceiveInterrupt(
        control(13) != 0 ? nil : buffer + Int(control(14)), UInt16(truncatingIfNeeded: b),
        control(17)
      ).rawValue
    case 13: return d.enableListenInterrupt().rawValue
    case 14: return d.disableListenInterrupt().rawValue
    case 15: return d.enableAlertInterrupt().rawValue
    case 16: return d.disableAlertInterrupt().rawValue
    case 17:
      return d.isDeviceReady(
        UInt16(truncatingIfNeeded: a), b, c, getTick: { CSMBUS_TickFor(self.state) }
      ).rawValue
    case 18:
      d.eventInterruptHandler()
      return 0
    case 19:
      d.errorInterruptHandler()
      return 0
    case 20: return d.getState()
    case 21: return d.getError()
    case 22: return d.masterInterrupt(a).rawValue
    case 23: return d.slaveInterrupt(a).rawValue
    case 24:
      d.enableIRQ(a)
      return 0
    case 25:
      d.disableIRQ(a)
      return 0
    case 26:
      d.interruptError()
      return 0
    case 27: return d.waitOnFlag(a, b, c, getTick: { CSMBUS_TickFor(self.state) }).rawValue
    case 28:
      d.flushTransmitData()
      return 0
    case 29:
      d.transferConfiguration(a, b, control(19), c)
      return 0
    case 30:
      d.convertOtherTransferOptions()
      return 0
    case 31: return d.enableWakeUp().rawValue
    case 32: return d.disableWakeUp().rawValue
    case 33: return d.configureFastModePlus(a).rawValue
    case 100: return d.getFlag(a)
    case 101:
      d.clearFlag(a)
      return 0
    case 102:
      d.enableInterrupts(a)
      return 0
    case 103:
      d.disableInterrupts(a)
      return 0
    case 104: return d.getInterruptSource(a)
    case 105:
      d.enable()
      return 0
    case 106:
      d.disable()
      return 0
    case 107:
      d.generateNACK()
      return 0
    case 108:
      d.resetHandleState()
      return 0
    case 109:
      d.resetCR1()
      return 0
    case 110:
      d.resetCR2()
      return 0
    case 111: return d.addressMatch()
    case 112: return d.direction()
    case 113: return d.stopMode()
    case 114: return d.pecMode()
    case 115: return d.alertEnabled()
    case 116: return d.checkFlag(a, b)
    case 117: return d.checkInterruptSource(a, b)
    case 118: return d.generateStart(a, b)
    case 119: return d.isOtherTransferOptions(a)
    default: preconditionFailure("Unknown SMBus test operation")
    }
  }
}
struct SMBUSPair {
  let c: SMBUSFixture
  let swift: SMBUSFixture
  init(callbacks: Bool = true) {
    c = SMBUSFixture(callbacks: callbacks)
    swift = SMBUSFixture(callbacks: callbacks)
  }
  func setup(_ body: (SMBUSFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0,
    file: StaticString = #filePath, line: UInt = #line
  ) {
    let expected = CSMBUS_Run(c.state, operation, a, b, d)
    XCTAssertEqual(
      swift.run(operation, a, b, d), expected, "operation \(operation)", file: file, line: line)
    let difference = CSMBUS_Compare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "operation \(operation) difference \(String(difference, radix: 16))",
      file: file, line: line)
  }
}
