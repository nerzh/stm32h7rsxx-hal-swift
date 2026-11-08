import CI2CReference
import STM32H7RSHAL
import XCTest

final class I2CFixture: I2CRegisterIO, I2CHandleIO, I2CCallbackIO, I2CDMAIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(callbacks: Bool = true) {
    allocation = .allocate(byteCount: CI2C_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CI2C_Reset(state, callbacks ? 1 : 0)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  var buffer: UnsafeMutablePointer<UInt8> { CI2C_Buffer(state)! }
  func control(_ index: UInt32) -> UInt32 { CI2C_Get(state, 2, index) }
  func control(_ index: UInt32, _ value: UInt32) { CI2C_Set(state, 2, index, value) }
  func read(_ register: I2CRegister) -> UInt32 { CI2C_Get(state, 0, register.rawValue / 4) }
  func write(_ register: I2CRegister, value: UInt32) {
    CI2C_Set(state, 0, register.rawValue / 4, value)
  }
  func address(of register: I2CRegister) -> UInt32 { 0x4000_5400 + register.rawValue }
  func read(_ word: I2CConfigurationWord) -> UInt32 { CI2C_Get(state, 1, UInt32(word.rawValue)) }
  func write(_ word: I2CConfigurationWord, value: UInt32) {
    CI2C_Set(state, 1, UInt32(word.rawValue), value)
  }
  func read(_ word: I2CHandleHalfWord) -> UInt16 {
    UInt16(truncatingIfNeeded: CI2C_Get(state, 1, 8 + UInt32(word.rawValue)))
  }
  func write(_ word: I2CHandleHalfWord, value: UInt16) {
    CI2C_Set(state, 1, 8 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: I2CHandleWord) -> UInt32 { CI2C_Get(state, 1, 10 + UInt32(word.rawValue)) }
  func write(_ word: I2CHandleWord, value: UInt32) {
    CI2C_Set(state, 1, 10 + UInt32(word.rawValue), value)
  }
  func readBuffer() -> UnsafeMutablePointer<UInt8>? { CI2C_GetBuffer(state) }
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) { CI2C_SetBuffer(state, value) }
  func read(_ id: I2CCallbackID) -> I2CCallback? {
    let bits = CI2C_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I2CCallback.self)
  }
  func write(_ id: I2CCallbackID, value: I2CCallback?) {
    CI2C_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func readAddress() -> I2CAddressCallback? {
    let bits = CI2C_GetCallback(state, 11)
    return bits == 0 ? nil : unsafeBitCast(bits, to: I2CAddressCallback.self)
  }
  func writeAddress(_ value: I2CAddressCallback?) {
    CI2C_SetCallback(state, 11, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  var defaults: I2CCallbackDefaults {
    .init(
      masterTransmitComplete: unsafeBitCast(CI2C_Callback(0, 1), to: I2CCallback.self),
      masterReceiveComplete: unsafeBitCast(CI2C_Callback(1, 1), to: I2CCallback.self),
      slaveTransmitComplete: unsafeBitCast(CI2C_Callback(2, 1), to: I2CCallback.self),
      slaveReceiveComplete: unsafeBitCast(CI2C_Callback(3, 1), to: I2CCallback.self),
      listenComplete: unsafeBitCast(CI2C_Callback(4, 1), to: I2CCallback.self),
      memoryTransmitComplete: unsafeBitCast(CI2C_Callback(5, 1), to: I2CCallback.self),
      memoryReceiveComplete: unsafeBitCast(CI2C_Callback(6, 1), to: I2CCallback.self),
      error: unsafeBitCast(CI2C_Callback(7, 1), to: I2CCallback.self),
      abortComplete: unsafeBitCast(CI2C_Callback(8, 1), to: I2CCallback.self),
      mspInitialize: unsafeBitCast(CI2C_Callback(9, 1), to: I2CCallback.self),
      mspDeinitialize: unsafeBitCast(CI2C_Callback(10, 1), to: I2CCallback.self),
      address: unsafeBitCast(CI2C_Callback(11, 1), to: I2CAddressCallback.self))
  }
  var driver: I2C<I2CFixture, I2CFixture, I2CFixture, I2CFixture> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: control(31) != 0)
  }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    let d = driver
    switch operation {
    case 0: return d.initialize().rawValue
    case 1: return d.deinitialize().rawValue
    case 2:
      return d.registerCallback(
        a,
        callback: b == 0
          ? nil : unsafeBitCast(CI2C_Callback(a <= 10 ? a : 0, b), to: I2CCallback.self)
      ).rawValue
    case 3: return d.unregisterCallback(a).rawValue
    case 4:
      return d.registerAddressCallback(
        b == 0 ? nil : unsafeBitCast(CI2C_Callback(11, b), to: I2CAddressCallback.self)
      ).rawValue
    case 5: return d.unregisterAddressCallback().rawValue
    case 38: return d.getState()
    case 39: return d.getMode()
    case 40: return d.getError()
    case 73: return d.configureAnalogFilter(a).rawValue
    case 74: return d.configureDigitalFilter(a).rawValue
    case 75: return d.enableWakeup().rawValue
    case 76: return d.disableWakeup().rawValue
    case 77: return d.configureFastModePlus(a).rawValue
    case 6:
      return d.masterTransmit(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), timeout: c, getTick: { CI2C_TickFor(self.state) }
      ).rawValue
    case 7:
      return d.masterReceive(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), timeout: c, getTick: { CI2C_TickFor(self.state) }
      ).rawValue
    case 8:
      return d.slaveTransmit(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), timeout: c, getTick: { CI2C_TickFor(self.state) }
      ).rawValue
    case 9:
      return d.slaveReceive(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), timeout: c, getTick: { CI2C_TickFor(self.state) }
      ).rawValue
    case 24:
      return d.isDeviceReady(
        address: UInt16(truncatingIfNeeded: a), trials: b, timeout: c,
        getTick: { CI2C_TickFor(self.state) }
      ).rawValue
    case 18:
      return d.writeMemory(
        address: UInt16(truncatingIfNeeded: a),
        memoryAddress: UInt16(truncatingIfNeeded: control(15)),
        memoryAddressSize: UInt16(truncatingIfNeeded: control(16)),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), timeout: c, getTick: { CI2C_TickFor(self.state) }
      ).rawValue
    case 19:
      return d.readMemory(
        address: UInt16(truncatingIfNeeded: a),
        memoryAddress: UInt16(truncatingIfNeeded: control(15)),
        memoryAddressSize: UInt16(truncatingIfNeeded: control(16)),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), timeout: c, getTick: { CI2C_TickFor(self.state) }
      ).rawValue
    case 10:
      return d.masterTransmitInterrupt(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 11:
      return d.masterReceiveInterrupt(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 12:
      return d.slaveTransmitInterrupt(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 13:
      return d.slaveReceiveInterrupt(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 14:
      return d.masterTransmitDMA(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 15:
      return d.masterReceiveDMA(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 16:
      return d.slaveTransmitDMA(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 17:
      return d.slaveReceiveDMA(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 20:
      return d.writeMemoryInterrupt(
        address: UInt16(truncatingIfNeeded: a),
        memoryAddress: UInt16(truncatingIfNeeded: control(15)),
        memoryAddressSize: UInt16(truncatingIfNeeded: control(16)),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 21:
      return d.readMemoryInterrupt(
        address: UInt16(truncatingIfNeeded: a),
        memoryAddress: UInt16(truncatingIfNeeded: control(15)),
        memoryAddressSize: UInt16(truncatingIfNeeded: control(16)),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 22:
      return d.writeMemoryDMA(
        address: UInt16(truncatingIfNeeded: a),
        memoryAddress: UInt16(truncatingIfNeeded: control(15)),
        memoryAddressSize: UInt16(truncatingIfNeeded: control(16)),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 23:
      return d.readMemoryDMA(
        address: UInt16(truncatingIfNeeded: a),
        memoryAddress: UInt16(truncatingIfNeeded: control(15)),
        memoryAddressSize: UInt16(truncatingIfNeeded: control(16)),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b)
      ).rawValue
    case 25:
      return d.masterSequentialTransmitInterrupt(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), options: control(17)
      ).rawValue
    case 26:
      return d.masterSequentialTransmitDMA(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), options: control(17)
      ).rawValue
    case 27:
      return d.masterSequentialReceiveInterrupt(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), options: control(17)
      ).rawValue
    case 28:
      return d.masterSequentialReceiveDMA(
        address: UInt16(truncatingIfNeeded: a),
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), options: control(17)
      ).rawValue
    case 29:
      return d.slaveSequentialTransmitInterrupt(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), options: control(17)
      ).rawValue
    case 30:
      return d.slaveSequentialTransmitDMA(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), options: control(17)
      ).rawValue
    case 31:
      return d.slaveSequentialReceiveInterrupt(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), options: control(17)
      ).rawValue
    case 32:
      return d.slaveSequentialReceiveDMA(
        buffer: control(13) != 0 ? nil : buffer + Int(control(14)),
        count: UInt16(truncatingIfNeeded: b), options: control(17)
      ).rawValue
    case 33: return d.enableListenInterrupt().rawValue
    case 34: return d.disableListenInterrupt().rawValue
    case 35: return d.abortMasterInterrupt(address: UInt16(truncatingIfNeeded: a)).rawValue
    case 36:
      d.eventInterruptHandler()
      return 0
    case 37:
      d.errorInterruptHandler()
      return 0
    case 58:
      d.dmaCallback(.masterTransmitComplete)
      return 0
    case 59:
      d.dmaCallback(.slaveTransmitComplete)
      return 0
    case 60:
      d.dmaCallback(.masterReceiveComplete)
      return 0
    case 61:
      d.dmaCallback(.slaveReceiveComplete)
      return 0
    case 62:
      d.dmaCallback(.error)
      return 0
    case 63:
      d.dmaCallback(.abort)
      return 0
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
    default: preconditionFailure()
    }
  }
}
struct I2CPair {
  let c: I2CFixture
  let swift: I2CFixture
  init(callbacks: Bool = true) {
    c = I2CFixture(callbacks: callbacks)
    swift = I2CFixture(callbacks: callbacks)
  }
  func setup(_ body: (I2CFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0,
    file: StaticString = #filePath, line: UInt = #line
  ) {
    let expected = CI2C_Run(c.state, operation, a, b, d)
    XCTAssertEqual(
      swift.run(operation, a, b, d), expected, "operation \(operation)", file: file, line: line)
    let difference = CI2C_Compare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "operation \(operation) difference \(String(difference, radix: 16))",
      file: file, line: line)
  }
}

extension I2CFixture {
  func setting(_ d: UARTDMADirection, _ index: UInt32) -> UInt32 {
    CI2C_Get(state, d == .transmit ? 3 : 4, index)
  }
  func setting(_ d: UARTDMADirection, _ index: UInt32, _ value: UInt32) {
    CI2C_Set(state, d == .transmit ? 3 : 4, index, value)
  }
  func isPresent(_ direction: UARTDMADirection) -> Bool { setting(direction, 0) != 0 }
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    switch word {
    case .mode: return setting(direction, 1)
    case .state: return setting(direction, 3)
    case .errorCode: return setting(direction, 2)
    case .queueAddress: return setting(direction, 4) != 0 ? 0x1000 : 0
    default: preconditionFailure()
    }
  }
  func getCounter(_ direction: UARTDMADirection) -> UInt32 { setting(direction, 9) & 0xFFFF }
  func getFIFOLevel(_ direction: UARTDMADirection) -> UInt32 { setting(direction, 10) }
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    if address == 0x1000 { return setting(direction, 5) != 0 ? 0x2000 : 0 }
    precondition(address >= 0x2000 && address < 0x2020)
    return CI2C_Get(state, direction == .transmit ? 5 : 6, (address - 0x2000) / 4)
  }
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    precondition(address >= 0x2000 && address < 0x2020)
    CI2C_Set(state, direction == .transmit ? 5 : 6, (address - 0x2000) / 4, value)
  }
  func callback(_ kind: I2CDMACallbackKind) -> DMACallback { I2CNoDMA().callback(kind) }
  func callbackIndex(_ kind: I2CDMACallbackKind) -> UInt32 {
    switch kind {
    case .masterTransmitComplete: return 1
    case .slaveTransmitComplete: return 3
    case .masterReceiveComplete: return 2
    case .slaveReceiveComplete: return 4
    case .error: return 5
    case .abort: return 6
    }
  }
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    var index: UInt32 = 0
    if let value {
      for raw in 0..<6 {
        let kind = I2CDMACallbackKind(rawValue: UInt32(raw))!
        if unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) {
          index = callbackIndex(kind)
        }
      }
      precondition(index != 0)
    }
    CI2C_Set(state, direction == .transmit ? 9 : 10, id.rawValue, index)
  }
  func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID) {
    let index = CI2C_Get(state, direction == .transmit ? 9 : 10, id.rawValue)
    let kind: I2CDMACallbackKind
    switch index {
    case 1: kind = .masterTransmitComplete
    case 2: kind = .masterReceiveComplete
    case 3: kind = .slaveTransmitComplete
    case 4: kind = .slaveReceiveComplete
    case 5: kind = .error
    case 6: kind = .abort
    default: preconditionFailure()
    }
    driver.dmaCallback(kind)
  }
  func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CI2C_RecordDMA(
        state, direction == .transmit ? 0 : 1, 0, sourceAddress, destinationAddress, sourceDataSize)
    )!
  }
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    HALStatus(rawValue: CI2C_RecordDMA(state, direction == .transmit ? 0 : 1, 1, 0, 0, 0))!
  }
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus {
    _ = CI2C_RecordDMA(state, direction == .transmit ? 0 : 1, 2, 0, 0, 0)
    if setting(direction, 11) != 0 && CI2C_Get(state, direction == .transmit ? 9 : 10, 3) != 0 {
      invokeCallback(direction, id: .abort)
    }
    return HALStatus(rawValue: setting(direction, 8))!
  }
}
