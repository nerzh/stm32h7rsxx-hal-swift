import CUSARTReference
import STM32H7RSHAL
import XCTest

struct USARTModel: UARTRegisterIO, USARTHandleIO, USARTCallbackIO, UARTClockIO, UARTDMAIO {
  let state: OpaquePointer
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
  func get(_ group: UInt32, _ i: UInt32) -> UInt32 { CUSART_Get(state, group, i) }
  func set(_ group: UInt32, _ i: UInt32, _ v: UInt32) { CUSART_Set(state, group, i, v) }
  var instance: UARTInstance { UARTInstance(rawValue: get(2, 3))! }
  func read(_ register: UARTRegister) -> UInt32 {
    get(0, UInt32(UARTRegister.allCases.firstIndex(of: register)!))
  }
  func write(_ register: UARTRegister, value: UInt32) {
    set(0, UInt32(UARTRegister.allCases.firstIndex(of: register)!), value)
  }
  func atomicModify(_ register: UARTRegister, clear: UInt32, set: UInt32) {
    XCTFail("USART source does not use atomic UART writes")
  }
  func read(_ word: USARTConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: USARTConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: UARTHandleHalfWord) -> UInt16 {
    UInt16(truncatingIfNeeded: get(1, 9 + UInt32(word.rawValue)))
  }
  func write(_ word: UARTHandleHalfWord, value: UInt16) {
    set(1, 9 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: USARTHandleWord) -> UInt32 { get(1, 16 + UInt32(word.rawValue)) }
  func write(_ word: USARTHandleWord, value: UInt32) { set(1, 16 + UInt32(word.rawValue), value) }
  func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer? {
    CUSART_GetPointer(state, UInt32(pointer.rawValue))
  }
  func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?) {
    CUSART_SetPointer(state, UInt32(pointer.rawValue), value)
  }
  func source(for instance: UARTInstance) -> UARTClockSource {
    switch get(2, 5) {
    case 0: return instance == .usart1 ? .pclk2 : .pclk1
    case 1: return .pll2Q
    case 2: return .pll3Q
    case 3: return .hsi
    case 4: return .csi
    case 5: return .lse
    default: return .undefined
    }
  }
  func frequency(_ source: UARTClockSource) -> UInt32 {
    source == .hsi && get(2, 6) != 0 ? get(2, 4) >> (get(2, 7) >> 3) : get(2, 4)
  }
  func read(_ id: USARTCallbackID) -> USARTCallback? {
    Self.callback(id.rawValue, CUSART_GetCallback(state, id.rawValue))
  }
  func write(_ id: USARTCallbackID, value: USARTCallback?) {
    var token: UInt32 = 0
    if let value {
      for k: UInt32 in 1...3 {
        if unsafeBitCast(value, to: UInt.self)
          == unsafeBitCast(Self.callback(id.rawValue, k)!, to: UInt.self)
        {
          token = k
        }
      }
      precondition(token != 0)
    }
    CUSART_SetCallback(state, id.rawValue, token)
  }
  static func callback(_ id: UInt32, _ token: UInt32) -> USARTCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (0, 1): return { CUSART_Callback(OpaquePointer($0!), 0, 1) }
    case (0, 2): return { CUSART_Callback(OpaquePointer($0!), 0, 2) }
    case (0, 3): return { CUSART_Callback(OpaquePointer($0!), 0, 3) }
    case (1, 1): return { CUSART_Callback(OpaquePointer($0!), 1, 1) }
    case (1, 2): return { CUSART_Callback(OpaquePointer($0!), 1, 2) }
    case (1, 3): return { CUSART_Callback(OpaquePointer($0!), 1, 3) }
    case (2, 1): return { CUSART_Callback(OpaquePointer($0!), 2, 1) }
    case (2, 2): return { CUSART_Callback(OpaquePointer($0!), 2, 2) }
    case (2, 3): return { CUSART_Callback(OpaquePointer($0!), 2, 3) }
    case (3, 1): return { CUSART_Callback(OpaquePointer($0!), 3, 1) }
    case (3, 2): return { CUSART_Callback(OpaquePointer($0!), 3, 2) }
    case (3, 3): return { CUSART_Callback(OpaquePointer($0!), 3, 3) }
    case (4, 1): return { CUSART_Callback(OpaquePointer($0!), 4, 1) }
    case (4, 2): return { CUSART_Callback(OpaquePointer($0!), 4, 2) }
    case (4, 3): return { CUSART_Callback(OpaquePointer($0!), 4, 3) }
    case (5, 1): return { CUSART_Callback(OpaquePointer($0!), 5, 1) }
    case (5, 2): return { CUSART_Callback(OpaquePointer($0!), 5, 2) }
    case (5, 3): return { CUSART_Callback(OpaquePointer($0!), 5, 3) }
    case (6, 1): return { CUSART_Callback(OpaquePointer($0!), 6, 1) }
    case (6, 2): return { CUSART_Callback(OpaquePointer($0!), 6, 2) }
    case (6, 3): return { CUSART_Callback(OpaquePointer($0!), 6, 3) }
    case (7, 1): return { CUSART_Callback(OpaquePointer($0!), 7, 1) }
    case (7, 2): return { CUSART_Callback(OpaquePointer($0!), 7, 2) }
    case (7, 3): return { CUSART_Callback(OpaquePointer($0!), 7, 3) }
    case (8, 1): return { CUSART_Callback(OpaquePointer($0!), 8, 1) }
    case (8, 2): return { CUSART_Callback(OpaquePointer($0!), 8, 2) }
    case (8, 3): return { CUSART_Callback(OpaquePointer($0!), 8, 3) }
    case (9, 1): return { CUSART_Callback(OpaquePointer($0!), 9, 1) }
    case (9, 2): return { CUSART_Callback(OpaquePointer($0!), 9, 2) }
    case (9, 3): return { CUSART_Callback(OpaquePointer($0!), 9, 3) }
    case (10, 1): return { CUSART_Callback(OpaquePointer($0!), 10, 1) }
    case (10, 2): return { CUSART_Callback(OpaquePointer($0!), 10, 2) }
    case (10, 3): return { CUSART_Callback(OpaquePointer($0!), 10, 3) }
    default: preconditionFailure("Unknown callback")
    }
  }
  var defaults: USARTCallbackDefaults {
    .init(
      transmitHalfComplete: Self.callback(0, 1)!, transmitComplete: Self.callback(1, 1)!,
      receiveHalfComplete: Self.callback(2, 1)!, receiveComplete: Self.callback(3, 1)!,
      transmitReceiveComplete: Self.callback(4, 1)!, error: Self.callback(5, 1)!,
      abortComplete: Self.callback(6, 1)!, receiveFIFOFull: Self.callback(7, 1)!,
      transmitFIFOEmpty: Self.callback(8, 1)!, mspInitialize: Self.callback(9, 1)!,
      mspDeinitialize: Self.callback(10, 1)!)
  }
  var driver: USART<Self, Self, Self, Self> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: get(2, 31) != 0)
  }
  func isPresent(_ direction: UARTDMADirection) -> Bool { get(3 + direction.rawValue, 0) != 0 }
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32 {
    let group = 3 + direction.rawValue
    switch word {
    case .mode: return get(group, 1)
    case .errorCode: return get(group, 2)
    case .state: return get(group, 3)
    case .queueAddress: return get(group, 4) == 0 ? 0 : 0x1000
    case .lock: return 0
    }
  }
  func getCounter(_ direction: UARTDMADirection) -> UInt32 { 0 }
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32 {
    if address == 0x1000 { return get(3 + direction.rawValue, 5) == 0 ? 0 : 0x2000 }
    return get(5 + direction.rawValue, (address - 0x2000) / 4)
  }
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32) {
    set(5 + direction.rawValue, (address - 0x2000) / 4, value)
  }
  func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback? {
    let token = CUSART_GetDMACallback(state, direction.rawValue, id.rawValue)
    return token == 0 ? nil : callback(UARTDMACallbackKind(rawValue: token - 1)!)
  }
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    var token: UInt32 = 0
    if let value {
      for k: UInt32 in 0..<8 {
        if unsafeBitCast(value, to: UInt.self)
          == unsafeBitCast(callback(UARTDMACallbackKind(rawValue: k)!), to: UInt.self)
        {
          token = k + 1
        }
      }
      precondition(token != 0)
    }
    CUSART_SetDMACallback(state, direction.rawValue, id.rawValue, token)
  }
  func readParent(_ direction: UARTDMADirection) -> UnsafeMutableRawPointer? { context }
  func writeParent(_ direction: UARTDMADirection, value: UnsafeMutableRawPointer?) {
    XCTFail("USART does not assign DMA Parent")
  }
  func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID) {
    let kind = UARTDMACallbackKind(
      rawValue: CUSART_GetDMACallback(state, direction.rawValue, id.rawValue) - 1)!
    driver.handleDMAEvent(kind, source: USARTDMASource(model: self, direction: direction))
  }
  func callback(_ kind: UARTDMACallbackKind) -> DMACallback {
    switch kind {
    case .transmitComplete: return { $0!.assumingMemoryBound(to: UInt32.self).pointee = 0 }
    case .transmitHalfComplete: return { $0!.assumingMemoryBound(to: UInt32.self).pointee = 1 }
    case .receiveComplete: return { $0!.assumingMemoryBound(to: UInt32.self).pointee = 2 }
    case .receiveHalfComplete: return { $0!.assumingMemoryBound(to: UInt32.self).pointee = 3 }
    case .error: return { $0!.assumingMemoryBound(to: UInt32.self).pointee = 4 }
    case .abortOnError: return { $0!.assumingMemoryBound(to: UInt32.self).pointee = 5 }
    case .transmitAbort: return { $0!.assumingMemoryBound(to: UInt32.self).pointee = 6 }
    case .receiveAbort: return { $0!.assumingMemoryBound(to: UInt32.self).pointee = 7 }
    default: preconditionFailure("Unknown USART DMA event")
    }
  }
  func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CUSART_DMAAction(
        state, direction.rawValue, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus { action(direction, 1) }
  func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    action(direction, 2)
  }
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus { action(direction, 3) }
  func suspend(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    action(direction, 4)
  }
  func resume(_ direction: UARTDMADirection) -> HALStatus { action(direction, 5) }
  func action(_ direction: UARTDMADirection, _ op: UInt32) -> HALStatus {
    HALStatus(rawValue: CUSART_DMAAction(state, direction.rawValue, op, 0, 0, 0))!
  }
  func tick() -> UInt32 { CUSART_TickFor(state) }
  func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    let d = driver
    let tx: UnsafeRawPointer? = c & 1 != 0 ? nil : UnsafeRawPointer(CUSART_Buffer(state, 0))
    let rx = c & 2 != 0 ? nil : CUSART_Buffer(state, 1)
    switch op {
    case 0: return d.initialize(clocks: self, getTick: tick).rawValue
    case 1: return d.deinitialize().rawValue
    case 2: return d.registerCallback(id: a, callback: Self.callback(a < 11 ? a : 0, b)).rawValue
    case 3: return d.unregisterCallback(id: a).rawValue
    case 4:
      return d.transmit(tx, size: UInt16(truncatingIfNeeded: a), timeout: b, getTick: tick).rawValue
    case 5:
      return d.receive(rx, size: UInt16(truncatingIfNeeded: a), timeout: b, getTick: tick).rawValue
    case 6:
      return d.transmitReceive(
        tx, receiveData: rx, size: UInt16(truncatingIfNeeded: a), timeout: b, getTick: tick
      ).rawValue
    case 7: return d.transmitInterrupt(tx, size: UInt16(truncatingIfNeeded: a)).rawValue
    case 8: return d.receiveInterrupt(rx, size: UInt16(truncatingIfNeeded: a)).rawValue
    case 9:
      return d.transmitReceiveInterrupt(tx, receiveData: rx, size: UInt16(truncatingIfNeeded: a))
        .rawValue
    case 10: return d.transmitDMA(tx, size: UInt16(truncatingIfNeeded: a)).rawValue
    case 11: return d.receiveDMA(rx, size: UInt16(truncatingIfNeeded: a), getTick: tick).rawValue
    case 12:
      return d.transmitReceiveDMA(
        tx, receiveData: rx, size: UInt16(truncatingIfNeeded: a), getTick: tick
      ).rawValue
    case 13: return d.pauseDMA(getTick: tick).rawValue
    case 14: return d.resumeDMA().rawValue
    case 15: return d.stopDMA(getTick: tick).rawValue
    case 16: return d.abort(getTick: tick).rawValue
    case 17: return d.abortInterrupt().rawValue
    case 18:
      d.handleInterrupt()
      return 0
    case 19: return d.getState()
    case 20: return d.getError()
    case 23...30:
      d.handleDMAEvent(
        UARTDMACallbackKind(rawValue: op - 23)!,
        source: USARTDMASource(model: self, direction: UARTDMADirection(rawValue: a)!))
      return 0
    case 31:
      return d.waitOnFlag(a, status: b, start: get(2, 12), timeout: c, getTick: tick).rawValue
    case 32: return d.setConfiguration(clocks: self).rawValue
    case 33: return d.checkIdleState(getTick: tick).rawValue
    case 43: return d.enableSlaveMode().rawValue
    case 44: return d.disableSlaveMode().rawValue
    case 45: return d.configureNSS(a).rawValue
    case 46: return d.enableFIFOMode().rawValue
    case 47: return d.disableFIFOMode().rawValue
    case 48: return d.setTransmitFIFOThreshold(a).rawValue
    case 49: return d.setReceiveFIFOThreshold(a).rawValue
    case 100: return d.getFlag(a)
    case 101:
      d.clearFlag(a)
      return 0
    case 102:
      d.enableInterrupt(a)
      return 0
    case 103:
      d.disableInterrupt(a)
      return 0
    case 104: return d.getInterrupt(a)
    case 105: return d.getInterruptSource(a)
    case 106:
      d.sendRequest(a)
      return 0
    case 107:
      d.enableOneBitSampling()
      return 0
    case 108:
      d.disableOneBitSampling()
      return 0
    case 109:
      d.enable()
      return 0
    case 110:
      d.disable()
      return 0
    case 111:
      d.resetHandleState()
      return 0
    default: preconditionFailure("Private helpers are tested through their public callers")
    }
  }
}
struct USARTDMASource: UARTDMAEventSourceIO {
  let model: USARTModel
  let direction: UARTDMADirection
  func readMode() -> UInt32 { model.read(direction, word: .mode) }
  func getCounter() -> UInt32 { 0 }
}
final class USARTPair {
  let cStorage = UnsafeMutableRawPointer.allocate(byteCount: CUSART_Size(), alignment: 16)
  let swiftStorage = UnsafeMutableRawPointer.allocate(byteCount: CUSART_Size(), alignment: 16)
  let mode: UInt32
  var c: USARTModel { .init(state: OpaquePointer(cStorage)) }
  var swift: USARTModel { .init(state: OpaquePointer(swiftStorage)) }
  init(_ mode: UInt32) {
    self.mode = mode
    reset()
  }
  deinit {
    cStorage.deallocate()
    swiftStorage.deallocate()
  }
  func reset() {
    CUSART_Reset(c.state, mode)
    CUSART_Reset(swift.state, mode)
  }
  func set(_ group: UInt32, _ i: UInt32, _ value: UInt32) {
    c.set(group, i, value)
    swift.set(group, i, value)
  }
  func callback(_ id: UInt32, _ value: UInt32) {
    CUSART_SetCallback(c.state, id, value)
    CUSART_SetCallback(swift.state, id, value)
  }
  func dmaCallback(_ direction: UInt32, _ id: UInt32, _ value: UInt32) {
    CUSART_SetDMACallback(c.state, direction, id, value)
    CUSART_SetDMACallback(swift.state, direction, id, value)
  }
  @discardableResult
  func run(
    _ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ v: UInt32 = 0, file: StaticString = #filePath,
    line: UInt = #line
  ) -> UInt32 {
    let expected = CUSART_Run(c.state, op, a, b, v)
    let actual = swift.run(op, a, b, v)
    XCTAssertEqual(
      actual, expected, "operation \(op), arguments \(a), \(b), \(v)", file: file, line: line)
    compare(file: file, line: line)
    return actual
  }
  func compare(file: StaticString = #filePath, line: UInt = #line) {
    for (group, count): (UInt32, UInt32) in [
      (0, 12), (1, 23), (2, 32), (3, 16), (4, 16), (5, 8), (6, 8),
    ] {
      let actual = (0..<count).map { i in
        group == 5 || group == 6
          ? CUSART_Normalize(swift.state, swift.get(group, i)) : swift.get(group, i)
      }
      let expected = (0..<count).map { i in
        group == 5 || group == 6 ? CUSART_Normalize(c.state, c.get(group, i)) : c.get(group, i)
      }
      XCTAssertEqual(actual, expected, "group \(group)", file: file, line: line)
    }
    for direction: UInt32 in 0..<2 {
      let actual = (0..<5).map { CUSART_GetDMACallback(swift.state, direction, UInt32($0)) }
      let expected = (0..<5).map { CUSART_GetDMACallback(c.state, direction, UInt32($0)) }
      XCTAssertEqual(actual, expected, "DMA callbacks \(direction)", file: file, line: line)
      let actualBytes = Array(
        UnsafeBufferPointer(
          start: CUSART_Buffer(swift.state, direction)!.assumingMemoryBound(to: UInt8.self),
          count: 512))
      let expectedBytes = Array(
        UnsafeBufferPointer(
          start: CUSART_Buffer(c.state, direction)!.assumingMemoryBound(to: UInt8.self), count: 512)
      )
      XCTAssertEqual(actualBytes, expectedBytes, "buffer \(direction)", file: file, line: line)
      let a = CUSART_GetPointer(swift.state, direction)
      let b = CUSART_GetPointer(c.state, direction)
      let ao = a.map {
        UInt(bitPattern: $0) &- UInt(bitPattern: CUSART_Buffer(swift.state, direction))
      }
      let bo = b.map { UInt(bitPattern: $0) &- UInt(bitPattern: CUSART_Buffer(c.state, direction)) }
      // Receive_DMA deliberately aliases the TX pointer to the RX buffer.
      if direction == 0 && a == CUSART_Buffer(swift.state, 1) && b == CUSART_Buffer(c.state, 1) {
      } else {
        XCTAssertEqual(ao, bo, file: file, line: line)
      }
    }
    XCTAssertEqual(
      (0..<11).map { CUSART_GetCallback(swift.state, UInt32($0)) },
      (0..<11).map { CUSART_GetCallback(c.state, UInt32($0)) }, file: file, line: line)
    for (group, index): (UInt32, UInt32) in [(7, 8), (8, 9)] {
      XCTAssertEqual(
        (0..<swift.get(2, index)).map { swift.get(group, $0) },
        (0..<c.get(2, index)).map { c.get(group, $0) }, "trace \(group)", file: file, line: line)
    }
  }
}
