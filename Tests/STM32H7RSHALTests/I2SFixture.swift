import CAudioReference
import STM32H7RSHAL
import XCTest

final class I2SFixture: I2SRegisterIO, I2SHandleIO, I2SCallbackIO, I2SDMAIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(callbacks: Bool = true) {
    allocation = .allocate(byteCount: CI2S_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CI2S_Reset(state, callbacks ? 1 : 0)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  var instance: I2SInstance { I2SInstance.allCases[Int(control(0))] }
  func control(_ index: UInt32) -> UInt32 { CI2S_Get(state, 2, index) }
  func control(_ index: UInt32, _ value: UInt32) { CI2S_Set(state, 2, index, value) }
  func buffer(_ index: UInt32 = 0) -> UnsafeMutablePointer<UInt8> { CI2S_Buffer(state, index)! }
  func read(_ register: I2SRegister) -> UInt32 { CI2S_Get(state, 0, register.rawValue / 4) }
  func write(_ register: I2SRegister, value: UInt32) {
    CI2S_Set(state, 0, register.rawValue / 4, value)
  }
  func address(of register: I2SRegister) -> UInt32 { instance.rawValue + register.rawValue }
  func read16(_ register: I2SRegister) -> UInt16 { UInt16(truncatingIfNeeded: read(register)) }
  func write16(_ register: I2SRegister, value: UInt16) {
    write(register, value: (read(register) & 0xFFFF_0000) | UInt32(value))
  }
  func read(_ word: I2SConfigurationWord) -> UInt32 {
    CI2S_Get(state, 1, 0 + UInt32(word.rawValue))
  }
  func write(_ word: I2SConfigurationWord, value: UInt32) {
    CI2S_Set(state, 1, 0 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: I2SHandleHalfWord) -> UInt16 {
    UInt16(truncatingIfNeeded: CI2S_Get(state, 1, 10 + UInt32(word.rawValue)))
  }
  func write(_ word: I2SHandleHalfWord, value: UInt16) {
    CI2S_Set(state, 1, 10 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: I2SHandleWord) -> UInt32 { CI2S_Get(state, 1, 14 + UInt32(word.rawValue)) }
  func write(_ word: I2SHandleWord, value: UInt32) {
    CI2S_Set(state, 1, 14 + UInt32(word.rawValue), UInt32(value))
  }
  func readPointer(_ direction: UARTBufferPointer) -> UnsafeMutableRawPointer? {
    UnsafeMutableRawPointer(bitPattern: CI2S_GetPointer(state, UInt32(direction.rawValue)))
  }
  func writePointer(_ direction: UARTBufferPointer, value: UnsafeMutableRawPointer?) {
    CI2S_SetPointer(state, UInt32(direction.rawValue), UInt(bitPattern: value))
  }
  func read(_ id: I2SCallbackID) -> I2SCallback? {
    let bits = CI2S_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I2SCallback.self)
  }
  func write(_ id: I2SCallbackID, value: I2SCallback?) {
    CI2S_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: I2SCallbackDefaults {
    .init(
      transmitComplete: unsafeBitCast(CI2S_Callback(0, 1), to: I2SCallback.self),
      receiveComplete: unsafeBitCast(CI2S_Callback(1, 1), to: I2SCallback.self),
      transmitReceiveComplete: unsafeBitCast(CI2S_Callback(2, 1), to: I2SCallback.self),
      transmitHalfComplete: unsafeBitCast(CI2S_Callback(3, 1), to: I2SCallback.self),
      receiveHalfComplete: unsafeBitCast(CI2S_Callback(4, 1), to: I2SCallback.self),
      transmitReceiveHalfComplete: unsafeBitCast(CI2S_Callback(5, 1), to: I2SCallback.self),
      error: unsafeBitCast(CI2S_Callback(6, 1), to: I2SCallback.self),
      mspInitialize: unsafeBitCast(CI2S_Callback(7, 1), to: I2SCallback.self),
      mspDeinitialize: unsafeBitCast(CI2S_Callback(8, 1), to: I2SCallback.self))
  }
  var driver: I2S<I2SFixture, I2SFixture, I2SFixture, I2SFixture> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: control(63) != 0)
  }
  func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CI2S_Activate(state)
    let d = driver
    switch op {
    case 0:
      return d.initialize(getPeripheralClockFrequency: { CI2S_ClockFor(self.state, $0) }).rawValue
    case 1: return d.deinitialize().rawValue
    case 16: return d.enableIOSwap().rawValue
    case 17: return d.disableIOSwap().rawValue
    case 18: return d.isIOSwapEnabled()
    case 20: return d.getState()
    case 21: return d.getError()
    case 4:
      return d.transmit(
        buffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        count: UInt16(truncatingIfNeeded: a), timeout: b, getTick: { CI2S_TickFor(self.state) }
      ).rawValue
    case 5:
      return d.receive(
        buffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        count: UInt16(truncatingIfNeeded: a), timeout: b, getTick: { CI2S_TickFor(self.state) }
      ).rawValue
    case 6:
      return d.transmitReceive(
        transmitBuffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        receiveBuffer: control(15) != 0
          ? nil : UnsafeMutableRawPointer(buffer(1).advanced(by: Int(control(16)))),
        count: UInt16(truncatingIfNeeded: a), timeout: b, getTick: { CI2S_TickFor(self.state) }
      ).rawValue
    case 7:
      return d.transmitInterrupt(
        buffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 8:
      return d.receiveInterrupt(
        buffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 9:
      return d.transmitReceiveInterrupt(
        transmitBuffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        receiveBuffer: control(15) != 0
          ? nil : UnsafeMutableRawPointer(buffer(1).advanced(by: Int(control(16)))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 10:
      return d.transmitDMA(
        buffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 11:
      return d.receiveDMA(
        buffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 12:
      return d.transmitReceiveDMA(
        transmitBuffer: control(13) != 0
          ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        receiveBuffer: control(15) != 0
          ? nil : UnsafeMutableRawPointer(buffer(1).advanced(by: Int(control(16)))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 13: return d.pauseDMA(getTick: { CI2S_TickFor(self.state) }).rawValue
    case 14: return d.resumeDMA().rawValue
    case 15: return d.stopDMA(getTick: { CI2S_TickFor(self.state) }).rawValue
    case 19:
      d.interruptHandler()
      return 0
    case 22:
      d.dmaCallback(
        .transmitComplete,
        source: I2SFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 23:
      d.dmaCallback(
        .transmitHalfComplete,
        source: I2SFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 24:
      d.dmaCallback(
        .receiveComplete,
        source: I2SFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 25:
      d.dmaCallback(
        .receiveHalfComplete,
        source: I2SFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 26:
      d.dmaCallback(
        .transmitReceiveComplete,
        source: I2SFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 27:
      d.dmaCallback(
        .transmitReceiveHalfComplete,
        source: I2SFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 28:
      d.dmaCallback(
        .error,
        source: I2SFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 2:
      return d.registerCallback(
        a,
        callback: b == 0
          ? nil : unsafeBitCast(CI2S_Callback(a < 9 ? a : 0, b), to: I2SCallback.self)
      ).rawValue
    case 3: return d.unregisterCallback(a).rawValue
    default: preconditionFailure()
    }
  }
}
struct I2SPair {
  let c: I2SFixture
  let swift: I2SFixture
  init(callbacks: Bool = true) {
    c = I2SFixture(callbacks: callbacks)
    swift = I2SFixture(callbacks: callbacks)
  }
  func setup(_ body: (I2SFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0, file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let expected = CI2S_Run(c.state, op, a, b, d)
    XCTAssertEqual(swift.run(op, a, b, d), expected, "operation \(op)", file: file, line: line)
    let difference = CI2S_Compare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "operation \(op) difference \(String(difference,radix:16))", file: file,
      line: line)
  }
}

extension I2SFixture {
  func setting(_ d: UARTDMADirection, _ index: UInt32) -> UInt32 {
    CI2S_Get(state, d == .transmit ? 3 : 4, index)
  }
  func setting(_ d: UARTDMADirection, _ index: UInt32, _ value: UInt32) {
    CI2S_Set(state, d == .transmit ? 3 : 4, index, value)
  }
  func isPresent(_ d: UARTDMADirection) -> Bool { setting(d, 0) != 0 }
  func read(_ d: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    switch word {
    case .mode: return setting(d, 2)
    case .state: return setting(d, 4)
    case .errorCode: return setting(d, 3)
    case .queueAddress: return setting(d, 5) != 0 ? 0x1000 : 0
    default: preconditionFailure()
    }
  }
  func readMemory32(_ d: UARTDMADirection, at address: UInt32) -> UInt32 {
    if address == 0x1000 { return setting(d, 6) != 0 ? 0x2000 : 0 }
    precondition(address >= 0x2000 && address < 0x2020)
    return CI2S_Get(state, d == .transmit ? 5 : 6, (address - 0x2000) / 4)
  }
  func writeMemory32(_ d: UARTDMADirection, at address: UInt32, value: UInt32) {
    precondition(address >= 0x2000 && address < 0x2020)
    CI2S_Set(state, d == .transmit ? 5 : 6, (address - 0x2000) / 4, value)
  }
  func callback(_ kind: I2SDMACallbackKind) -> DMACallback { I2SNoDMA().callback(kind) }
  func writeCallback(_ d: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    var index: UInt32 = 0
    if let value {
      for kind in I2SDMACallbackKind.allCases {
        if unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) {
          index = kind.rawValue + 1
        }
      }
      precondition(index != 0)
    }
    CI2S_Set(state, d == .transmit ? 9 : 10, id.rawValue, index)
  }
  func startInterrupt(
    _ d: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CI2S_RecordDMA(
        state, d == .transmit ? 0 : 1, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt(_ d: UARTDMADirection) -> HALStatus {
    HALStatus(rawValue: CI2S_RecordDMA(state, d == .transmit ? 0 : 1, 1, 0, 0, 0))!
  }
  func abort(_ d: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    HALStatus(rawValue: CI2S_RecordDMA(state, d == .transmit ? 0 : 1, 2, 0, 0, 0))!
  }
  func abortInterrupt(_ d: UARTDMADirection) -> HALStatus {
    _ = CI2S_RecordDMA(state, d == .transmit ? 0 : 1, 3, 0, 0, 0)
    let id = CI2S_Get(state, d == .transmit ? 9 : 10, 3)
    if setting(d, 11) != 0 && id != 0 {
      driver.dmaCallback(
        I2SDMACallbackKind(rawValue: id - 1)!,
        source: I2SFixtureDMAEvent(fixture: self, direction: d))
    }
    return HALStatus(rawValue: setting(d, 10))!
  }
}
struct I2SFixtureDMAEvent: I2SDMAEventSourceIO {
  let fixture: I2SFixture
  let direction: UARTDMADirection
  func readConfigurationMode() -> UInt32 { fixture.setting(direction, 1) }
}
