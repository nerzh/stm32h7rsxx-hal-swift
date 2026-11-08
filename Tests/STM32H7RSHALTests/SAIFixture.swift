import CAudioReference
import STM32H7RSHAL
import XCTest

final class SAIFixture: SAIRegisterIO, SAIHandleIO, SAICallbackIO, SAIDMAIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(callbacks: Bool = true) {
    allocation = .allocate(byteCount: CSAI_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CSAI_Reset(state, callbacks ? 1 : 0)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  var instance: SAIInstance { SAIInstance.allCases[Int(control(0))] }
  func control(_ index: UInt32) -> UInt32 { CSAI_Get(state, 2, index) }
  func control(_ index: UInt32, _ value: UInt32) { CSAI_Set(state, 2, index, value) }
  func buffer(_ index: UInt32 = 0) -> UnsafeMutablePointer<UInt8> { CSAI_Buffer(state, index)! }
  func read(_ register: SAIRegister) -> UInt32 { CSAI_Get(state, 0, register.rawValue / 4) }
  func write(_ register: SAIRegister, value: UInt32) {
    CSAI_Set(state, 0, register.rawValue / 4, value)
  }
  func address(of register: SAIRegister) -> UInt32 { instance.rawValue + register.rawValue }
  func readGlobal(_ peripheral: SAIPeripheral, _ register: SAIGlobalRegister) -> UInt32 {
    CSAI_Get(state, 11, (peripheral.rawValue - 1) * 19 + register.rawValue / 4)
  }
  func writeGlobal(_ peripheral: SAIPeripheral, _ register: SAIGlobalRegister, value: UInt32) {
    CSAI_Set(state, 11, (peripheral.rawValue - 1) * 19 + register.rawValue / 4, value)
  }
  func read(_ word: SAIConfigurationWord) -> UInt32 {
    CSAI_Get(state, 1, 0 + UInt32(word.rawValue))
  }
  func write(_ word: SAIConfigurationWord, value: UInt32) {
    CSAI_Set(state, 1, 0 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: SAIFrameWord) -> UInt32 { CSAI_Get(state, 1, 20 + UInt32(word.rawValue)) }
  func write(_ word: SAIFrameWord, value: UInt32) {
    CSAI_Set(state, 1, 20 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: SAISlotWord) -> UInt32 { CSAI_Get(state, 1, 25 + UInt32(word.rawValue)) }
  func write(_ word: SAISlotWord, value: UInt32) {
    CSAI_Set(state, 1, 25 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: SAIHandleHalfWord) -> UInt16 {
    UInt16(truncatingIfNeeded: CSAI_Get(state, 1, 29 + UInt32(word.rawValue)))
  }
  func write(_ word: SAIHandleHalfWord, value: UInt16) {
    CSAI_Set(state, 1, 29 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: SAIHandleWord) -> UInt32 { CSAI_Get(state, 1, 31 + UInt32(word.rawValue)) }
  func write(_ word: SAIHandleWord, value: UInt32) {
    CSAI_Set(state, 1, 31 + UInt32(word.rawValue), UInt32(value))
  }
  func readBuffer() -> UnsafeMutablePointer<UInt8>? {
    UnsafeMutablePointer<UInt8>(bitPattern: CSAI_GetPointer(state, 0))
  }
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    CSAI_SetPointer(state, 0, UInt(bitPattern: value))
  }
  func readMute() -> SAIMuteCallback? {
    let bits = CSAI_GetCallback(state, 7)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SAIMuteCallback.self)
  }
  func writeMute(_ value: SAIMuteCallback?) {
    CSAI_SetCallback(state, 7, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func read(_ id: SAICallbackID) -> SAICallback? {
    let bits = CSAI_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SAICallback.self)
  }
  func write(_ id: SAICallbackID, value: SAICallback?) {
    CSAI_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: SAICallbackDefaults {
    .init(
      receiveComplete: unsafeBitCast(CSAI_Callback(0, 1), to: SAICallback.self),
      receiveHalfComplete: unsafeBitCast(CSAI_Callback(1, 1), to: SAICallback.self),
      transmitComplete: unsafeBitCast(CSAI_Callback(2, 1), to: SAICallback.self),
      transmitHalfComplete: unsafeBitCast(CSAI_Callback(3, 1), to: SAICallback.self),
      error: unsafeBitCast(CSAI_Callback(4, 1), to: SAICallback.self),
      mspInitialize: unsafeBitCast(CSAI_Callback(5, 1), to: SAICallback.self),
      mspDeinitialize: unsafeBitCast(CSAI_Callback(6, 1), to: SAICallback.self))
  }
  var driver: SAI<SAIFixture, SAIFixture, SAIFixture, SAIFixture> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: control(63) != 0)
  }
  func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CSAI_Activate(state)
    let d = driver
    switch op {
    case 1:
      return d.initialize(
        getPeripheralClockFrequency: { CSAI_ClockFor(self.state, $0) },
        systemCoreClock: { self.control(6) }
      ).rawValue
    case 2: return d.deinitialize(systemCoreClock: { self.control(6) }).rawValue
    case 20: return d.getState()
    case 21: return d.getError()
    case 5:
      return d.transmit(
        buffer: control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))),
        count: UInt16(truncatingIfNeeded: a), timeout: b, getTick: { CSAI_TickFor(self.state) },
        systemCoreClock: { self.control(6) }
      ).rawValue
    case 6:
      return d.receive(
        buffer: control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))),
        count: UInt16(truncatingIfNeeded: a), timeout: b, getTick: { CSAI_TickFor(self.state) },
        systemCoreClock: { self.control(6) }
      ).rawValue
    case 7:
      return d.transmitInterrupt(
        buffer: control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 8:
      return d.receiveInterrupt(
        buffer: control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 9: return d.pauseDMA().rawValue
    case 10: return d.resumeDMA().rawValue
    case 11:
      return d.stopDMA(getTick: { CSAI_TickFor(self.state) }, systemCoreClock: { self.control(6) })
        .rawValue
    case 12:
      return d.abort(getTick: { CSAI_TickFor(self.state) }, systemCoreClock: { self.control(6) })
        .rawValue
    case 13:
      return d.transmitDMA(
        buffer: control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))),
        count: UInt16(truncatingIfNeeded: a), getTick: { CSAI_TickFor(self.state) }
      ).rawValue
    case 14:
      return d.receiveDMA(
        buffer: control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))),
        count: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 15: return d.enableTransmitMute(value: UInt16(truncatingIfNeeded: a)).rawValue
    case 16: return d.disableTransmitMute().rawValue
    case 17:
      return d.enableReceiveMute(
        callback: b == 0 ? nil : unsafeBitCast(CSAI_Callback(7, b), to: SAIMuteCallback.self),
        counter: UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 18: return d.disableReceiveMute().rawValue
    case 19:
      d.interruptHandler(
        getTick: { CSAI_TickFor(self.state) }, systemCoreClock: { self.control(6) })
      return 0
    case 33:
      d.dmaCallback(
        .transmitComplete,
        source: SAIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive),
        systemCoreClock: { self.control(6) })
      return 0
    case 34:
      d.dmaCallback(
        .transmitHalfComplete,
        source: SAIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive),
        systemCoreClock: { self.control(6) })
      return 0
    case 35:
      d.dmaCallback(
        .receiveComplete,
        source: SAIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive),
        systemCoreClock: { self.control(6) })
      return 0
    case 36:
      d.dmaCallback(
        .receiveHalfComplete,
        source: SAIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive),
        systemCoreClock: { self.control(6) })
      return 0
    case 37:
      d.dmaCallback(
        .error,
        source: SAIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive),
        systemCoreClock: { self.control(6) })
      return 0
    case 38:
      d.dmaCallback(
        .abort,
        source: SAIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive),
        systemCoreClock: { self.control(6) })
      return 0
    case 3:
      return d.registerCallback(
        a,
        callback: b == 0
          ? nil : unsafeBitCast(CSAI_Callback(a < 7 ? a : 0, b), to: SAICallback.self)
      ).rawValue
    case 4: return d.unregisterCallback(a).rawValue
    case 0:
      return d.initializeProtocol(
        a, dataSize: b, slotCount: c,
        getPeripheralClockFrequency: { CSAI_ClockFor(self.state, $0) },
        systemCoreClock: { self.control(6) }
      ).rawValue
    case 39:
      return d.configurePDMMicrophoneDelay(
        .init(microphonePair: control(30), leftDelay: control(31), rightDelay: control(32))
      ).rawValue
    default: preconditionFailure()
    }
  }
}
struct SAIPair {
  let c: SAIFixture
  let swift: SAIFixture
  init(callbacks: Bool = true) {
    c = SAIFixture(callbacks: callbacks)
    swift = SAIFixture(callbacks: callbacks)
  }
  func setup(_ body: (SAIFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0, file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let expected = CSAI_Run(c.state, op, a, b, d)
    XCTAssertEqual(swift.run(op, a, b, d), expected, "operation \(op)", file: file, line: line)
    let difference = CSAI_Compare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "operation \(op) difference \(String(difference,radix:16))", file: file,
      line: line)
  }
}

extension SAIFixture {
  func setting(_ d: UARTDMADirection, _ index: UInt32) -> UInt32 {
    CSAI_Get(state, d == .transmit ? 3 : 4, index)
  }
  func setting(_ d: UARTDMADirection, _ index: UInt32, _ value: UInt32) {
    CSAI_Set(state, d == .transmit ? 3 : 4, index, value)
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
    return CSAI_Get(state, d == .transmit ? 5 : 6, (address - 0x2000) / 4)
  }
  func writeMemory32(_ d: UARTDMADirection, at address: UInt32, value: UInt32) {
    precondition(address >= 0x2000 && address < 0x2020)
    CSAI_Set(state, d == .transmit ? 5 : 6, (address - 0x2000) / 4, value)
  }
  func callback(_ kind: SAIDMACallbackKind) -> DMACallback { SAINoDMA().callback(kind) }
  func writeCallback(_ d: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    var index: UInt32 = 0
    if let value {
      for kind in SAIDMACallbackKind.allCases {
        if unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) {
          index = kind.rawValue + 1
        }
      }
      precondition(index != 0)
    }
    CSAI_Set(state, d == .transmit ? 9 : 10, id.rawValue, index)
  }
  func startInterrupt(
    _ d: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CSAI_RecordDMA(
        state, d == .transmit ? 0 : 1, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt(_ d: UARTDMADirection) -> HALStatus {
    HALStatus(rawValue: CSAI_RecordDMA(state, d == .transmit ? 0 : 1, 1, 0, 0, 0))!
  }
  func abort(_ d: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    HALStatus(rawValue: CSAI_RecordDMA(state, d == .transmit ? 0 : 1, 2, 0, 0, 0))!
  }
  func abortInterrupt(_ d: UARTDMADirection) -> HALStatus {
    _ = CSAI_RecordDMA(state, d == .transmit ? 0 : 1, 3, 0, 0, 0)
    let id = CSAI_Get(state, d == .transmit ? 9 : 10, 3)
    if setting(d, 11) != 0 && id != 0 {
      driver.dmaCallback(
        SAIDMACallbackKind(rawValue: id - 1)!,
        source: SAIFixtureDMAEvent(fixture: self, direction: d), systemCoreClock: { control(6) })
    }
    return HALStatus(rawValue: setting(d, 10))!
  }
}
struct SAIFixtureDMAEvent: SAIDMAEventSourceIO {
  let fixture: SAIFixture
  let direction: UARTDMADirection
  func readMode() -> UInt32 { fixture.setting(direction, 2) }
  func getCounter() -> UInt32 { preconditionFailure("SAI never reads the DMA counter") }
}
