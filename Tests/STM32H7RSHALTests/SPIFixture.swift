import CSPIReference
import XCTest

@testable import STM32H7RSHAL

final class SPIFixture: SPIRegisterIO, SPIHandleIO, SPICallbackIO, SPIDMAIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(callbacks: Bool = true, crc: Bool = true) {
    allocation = .allocate(byteCount: CSPI_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CSPI_Reset(state, callbacks ? 1 : 0)
    CSPI_Set(state, 2, 62, crc ? 1 : 0)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  var instance: SPIInstance { SPIInstance.allCases[Int(control(0))] }
  func control(_ index: UInt32) -> UInt32 { CSPI_Get(state, 2, index) }
  func control(_ index: UInt32, _ value: UInt32) { CSPI_Set(state, 2, index, value) }
  func buffer(_ index: UInt32 = 0) -> UnsafeMutablePointer<UInt8> { CSPI_Buffer(state, index)! }
  func raw(_ register: SPIRegister, _ value: UInt32) {
    CSPI_Set(state, 0, register.rawValue / 4, value)
  }
  func raw(_ register: SPIRegister) -> UInt32 { CSPI_Get(state, 0, register.rawValue / 4) }
  func read(_ register: SPIRegister) -> UInt32 { CSPI_ReadRegister(state, register.rawValue, 4) }
  func write(_ register: SPIRegister, value: UInt32) {
    CSPI_WriteRegister(state, register.rawValue, 4, value)
  }
  func read16(_ register: SPIRegister) -> UInt16 {
    UInt16(CSPI_ReadRegister(state, register.rawValue, 2))
  }
  func write16(_ register: SPIRegister, value: UInt16) {
    CSPI_WriteRegister(state, register.rawValue, 2, UInt32(value))
  }
  func read8(_ register: SPIRegister) -> UInt8 {
    UInt8(CSPI_ReadRegister(state, register.rawValue, 1))
  }
  func write8(_ register: SPIRegister, value: UInt8) {
    CSPI_WriteRegister(state, register.rawValue, 1, UInt32(value))
  }
  func address(of register: SPIRegister) -> UInt32 { instance.rawValue + register.rawValue }
  func read(_ word: SPIConfigurationWord) -> UInt32 {
    CSPI_Get(state, 1, 0 + UInt32(word.rawValue))
  }
  func write(_ word: SPIConfigurationWord, value: UInt32) {
    CSPI_Set(state, 1, 0 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: SPIHandleHalfWord) -> UInt16 {
    UInt16(truncatingIfNeeded: CSPI_Get(state, 1, 24 + UInt32(word.rawValue)))
  }
  func write(_ word: SPIHandleHalfWord, value: UInt16) {
    CSPI_Set(state, 1, 24 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: SPIHandleWord) -> UInt32 { CSPI_Get(state, 1, 28 + UInt32(word.rawValue)) }
  func write(_ word: SPIHandleWord, value: UInt32) {
    CSPI_Set(state, 1, 28 + UInt32(word.rawValue), UInt32(value))
  }
  func readPointer(_ direction: UARTBufferPointer) -> UnsafeMutableRawPointer? {
    UnsafeMutableRawPointer(bitPattern: CSPI_GetPointer(state, UInt32(direction.rawValue)))
  }
  func writePointer(_ direction: UARTBufferPointer, value: UnsafeMutableRawPointer?) {
    CSPI_SetPointer(state, UInt32(direction.rawValue), UInt(bitPattern: value))
  }
  func read(_ id: SPICallbackID) -> SPICallback? {
    let bits = CSPI_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: SPICallback.self)
  }
  func write(_ id: SPICallbackID, value: SPICallback?) {
    CSPI_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: SPICallbackDefaults {
    .init(
      transmitComplete: unsafeBitCast(CSPI_Callback(0, 1), to: SPICallback.self),
      receiveComplete: unsafeBitCast(CSPI_Callback(1, 1), to: SPICallback.self),
      transmitReceiveComplete: unsafeBitCast(CSPI_Callback(2, 1), to: SPICallback.self),
      transmitHalfComplete: unsafeBitCast(CSPI_Callback(3, 1), to: SPICallback.self),
      receiveHalfComplete: unsafeBitCast(CSPI_Callback(4, 1), to: SPICallback.self),
      transmitReceiveHalfComplete: unsafeBitCast(CSPI_Callback(5, 1), to: SPICallback.self),
      error: unsafeBitCast(CSPI_Callback(6, 1), to: SPICallback.self),
      abortComplete: unsafeBitCast(CSPI_Callback(7, 1), to: SPICallback.self),
      suspend: unsafeBitCast(CSPI_Callback(8, 1), to: SPICallback.self),
      mspInitialize: unsafeBitCast(CSPI_Callback(9, 1), to: SPICallback.self),
      mspDeinitialize: unsafeBitCast(CSPI_Callback(10, 1), to: SPICallback.self))
  }
  var driver: SPI<SPIFixture, SPIFixture, SPIFixture, SPIFixture> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: control(63) != 0, useCRC: control(62) != 0)
  }
  func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CSPI_Activate(state)
    let d = driver
    switch op {
    case 0: return d.initialize().rawValue
    case 1: return d.deinitialize().rawValue
    case 2:
      return d.registerCallback(
        a, b == 0 ? nil : unsafeBitCast(CSPI_Callback(a < 11 ? a : 0, b), to: SPICallback.self)
      ).rawValue
    case 3: return d.unregisterCallback(a).rawValue
    case 4:
      return d.transmit(
        control(13) != 0 ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        UInt16(truncatingIfNeeded: a), b, getTick: { CSPI_TickFor(self.state) }
      ).rawValue
    case 5:
      return d.receive(
        control(13) != 0 ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        UInt16(truncatingIfNeeded: a), b, getTick: { CSPI_TickFor(self.state) }
      ).rawValue
    case 6:
      return d.transmitReceive(
        control(13) != 0 ? nil : UnsafeRawPointer(buffer(0).advanced(by: Int(control(14)))),
        control(15) != 0 ? nil : UnsafeMutableRawPointer(buffer(1).advanced(by: Int(control(16)))),
        UInt16(truncatingIfNeeded: a), b, getTick: { CSPI_TickFor(self.state) }
      ).rawValue
    case 7:
      return d.transmitInterrupt(
        control(13) != 0 ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 8:
      return d.receiveInterrupt(
        control(13) != 0 ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 9:
      return d.transmitReceiveInterrupt(
        control(13) != 0 ? nil : UnsafeRawPointer(buffer(0).advanced(by: Int(control(14)))),
        control(15) != 0 ? nil : UnsafeMutableRawPointer(buffer(1).advanced(by: Int(control(16)))),
        UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 10:
      return d.transmitDMA(
        control(13) != 0 ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 11:
      return d.receiveDMA(
        control(13) != 0 ? nil : UnsafeMutableRawPointer(buffer(0).advanced(by: Int(control(14)))),
        UInt16(truncatingIfNeeded: a)
      ).rawValue
    case 12:
      return d.transmitReceiveDMA(
        control(13) != 0 ? nil : UnsafeRawPointer(buffer(0).advanced(by: Int(control(14)))),
        control(15) != 0 ? nil : UnsafeMutableRawPointer(buffer(1).advanced(by: Int(control(16)))),
        UInt16(truncatingIfNeeded: a), getTick: { CSPI_TickFor(self.state) }
      ).rawValue
    case 13:
      return d.abort(getTick: { CSPI_TickFor(self.state) }, systemCoreClock: { self.control(6) })
        .rawValue
    case 14: return d.abortInterrupt(systemCoreClock: { self.control(6) }).rawValue
    case 15: return d.pauseDMA().rawValue
    case 16: return d.resumeDMA().rawValue
    case 17: return d.stopDMA().rawValue
    case 18:
      d.interruptHandler()
      return 0
    case 19: return d.getState()
    case 20: return d.getError()
    case 21:
      d.dmaTransmitComplete(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 22:
      d.dmaReceiveComplete(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 23:
      d.dmaTransmitReceiveComplete(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 24:
      d.dmaTransmitHalfComplete(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 25:
      d.dmaReceiveHalfComplete(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 26:
      d.dmaTransmitReceiveHalfComplete(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 27:
      d.dmaError(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 28:
      d.dmaAbortOnError(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 29:
      d.dmaTransmitAbort(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 30:
      d.dmaReceiveAbort(
        source: SPIFixtureDMAEvent(fixture: self, direction: a & 1 == 0 ? .transmit : .receive))
      return 0
    case 31:
      d.receive8Interrupt()
      return 0
    case 32:
      d.receive16Interrupt()
      return 0
    case 33:
      d.receive32Interrupt()
      return 0
    case 34:
      d.transmit8Interrupt()
      return 0
    case 35:
      d.transmit16Interrupt()
      return 0
    case 36:
      d.transmit32Interrupt()
      return 0
    case 37:
      d.abortTransfer()
      return 0
    case 38:
      d.closeTransfer()
      return 0
    case 39:
      return d.waitOnFlag(a, b, c, control(18), getTick: { CSPI_TickFor(self.state) }).rawValue
    case 40: return d.packetSize()
    case 41: return d.flushReceiveFIFO().rawValue
    case 42: return d.enableLockConfiguration().rawValue
    case 43: return d.configureUnderrun(a, b).rawValue
    default: preconditionFailure("Unknown SPI test operation")
    }
  }
}
struct SPIPair {
  let c: SPIFixture
  let swift: SPIFixture
  init(callbacks: Bool = true, crc: Bool = true) {
    c = SPIFixture(callbacks: callbacks, crc: crc)
    swift = SPIFixture(callbacks: callbacks, crc: crc)
  }
  func setup(_ body: (SPIFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0, file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let expected = CSPI_Run(c.state, op, a, b, d)
    XCTAssertEqual(swift.run(op, a, b, d), expected, "operation \(op)", file: file, line: line)
    let difference = CSPI_Compare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "operation \(op) difference \(String(difference,radix:16))", file: file,
      line: line)
  }
}

extension SPIFixture {
  func setting(_ d: UARTDMADirection, _ index: UInt32) -> UInt32 {
    CSPI_Get(state, d == .transmit ? 3 : 4, index)
  }
  func setting(_ d: UARTDMADirection, _ index: UInt32, _ value: UInt32) {
    CSPI_Set(state, d == .transmit ? 3 : 4, index, value)
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
    return CSPI_Get(state, d == .transmit ? 5 : 6, (address - 0x2000) / 4)
  }
  func writeMemory32(_ d: UARTDMADirection, at address: UInt32, value: UInt32) {
    precondition(address >= 0x2000 && address < 0x2020)
    CSPI_Set(state, d == .transmit ? 5 : 6, (address - 0x2000) / 4, value)
  }
  func callback(_ kind: SPIDMACallbackKind) -> DMACallback { SPINoDMA().callback(kind) }
  func writeCallback(_ d: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    var index: UInt32 = 0
    if let value {
      for kind in SPIDMACallbackKind.allCases {
        if unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) {
          index = kind.rawValue + 1
        }
      }
      precondition(index != 0)
    }
    CSPI_Set(state, d == .transmit ? 9 : 10, id.rawValue, index)
  }
  func startInterrupt(
    _ d: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CSPI_RecordDMA(
        state, d == .transmit ? 0 : 1, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt(_ d: UARTDMADirection) -> HALStatus {
    HALStatus(rawValue: CSPI_RecordDMA(state, d == .transmit ? 0 : 1, 1, 0, 0, 0))!
  }
  func abort(_ d: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    HALStatus(rawValue: CSPI_RecordDMA(state, d == .transmit ? 0 : 1, 2, 0, 0, 0))!
  }
  func abortInterrupt(_ d: UARTDMADirection) -> HALStatus {
    _ = CSPI_RecordDMA(state, d == .transmit ? 0 : 1, 3, 0, 0, 0)
    let id = CSPI_Get(state, d == .transmit ? 9 : 10, 3)
    if setting(d, 11) != 0 && id != 0 {
      driver.dmaCallback(
        SPIDMACallbackKind(rawValue: id - 1)!,
        source: SPIFixtureDMAEvent(fixture: self, direction: d))
    }
    return HALStatus(rawValue: setting(d, 10))!
  }
}
struct SPIFixtureDMAEvent: SPIDMAEventSourceIO {
  let fixture: SPIFixture
  let direction: UARTDMADirection
  func readErrorCode() -> UInt32 { fixture.setting(direction, 3) }
}
extension SPIFixture {
  func readSourceDataWidth(_ d: UARTDMADirection) -> UInt32 { setting(d, 13) }
  func readDestinationDataWidth(_ d: UARTDMADirection) -> UInt32 { setting(d, 14) }
  func readCallback(_ d: UARTDMADirection, id: DMACallbackID) -> DMACallback? {
    let value = CSPI_Get(state, d == .transmit ? 9 : 10, id.rawValue)
    return value == 0 ? nil : callback(SPIDMACallbackKind(rawValue: value - 1)!)
  }
}
