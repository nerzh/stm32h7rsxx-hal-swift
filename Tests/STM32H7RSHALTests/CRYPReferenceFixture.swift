import CCRYPReference
import XCTest

@testable import STM32H7RSHAL

struct CRYPModel: CRYPRegisterIO, CRYPHandleIO, CRYPCallbackIO, CRYPDMAIO {
  let state: OpaquePointer
  var control: UnsafeMutablePointer<UInt32> { CCRYP_Control(state)! }
  var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
  var instance: CRYPInstance { CRYPInstance(rawValue: control[3])! }
  func read(_ register: CRYPRegister) -> UInt32 { CCRYP_GetRegister(state, register.rawValue) }
  func write(_ register: CRYPRegister, value: UInt32) {
    CCRYP_SetRegister(state, register.rawValue, value)
  }
  func address(of register: CRYPRegister) -> UInt32 {
    (instance == .cryp ? 0x4802_0800 : 0x4802_1000) + register.rawValue
  }
  func read(_ word: CRYPConfigurationWord, saved: Bool) -> UInt32 {
    CCRYP_GetWord(state, UInt32(word.rawValue + (saved ? 9 : 0)))
  }
  func write(_ word: CRYPConfigurationWord, saved: Bool, value: UInt32) {
    CCRYP_SetWord(state, UInt32(word.rawValue + (saved ? 9 : 0)), value)
  }
  func read(_ word: CRYPHandleWord) -> UInt32 { CCRYP_GetWord(state, UInt32(word.rawValue + 18)) }
  func write(_ word: CRYPHandleWord, value: UInt32) {
    CCRYP_SetWord(state, UInt32(word.rawValue + 18), value)
  }
  func read(_ word: CRYPHandleHalfWord) -> UInt16 {
    UInt16(truncatingIfNeeded: CCRYP_GetWord(state, UInt32(word.rawValue + 34)))
  }
  func write(_ word: CRYPHandleHalfWord, value: UInt16) {
    CCRYP_SetWord(state, UInt32(word.rawValue + 34), UInt32(value))
  }
  func readPointer(_ pointer: CRYPPointer) -> UnsafeMutablePointer<UInt32>? {
    CCRYP_GetPointer(state, UInt32(pointer.rawValue))?.assumingMemoryBound(to: UInt32.self)
  }
  func writePointer(_ pointer: CRYPPointer, value: UnsafeMutablePointer<UInt32>?) {
    CCRYP_SetPointer(state, UInt32(pointer.rawValue), value)
  }
  func savedWords(_ array: CRYPSavedWords) -> UnsafeMutablePointer<UInt32> {
    CCRYP_SavedWords(state, UInt32(array.rawValue))!
  }
  func buffer(_ index: UInt32) -> UnsafeMutablePointer<UInt32> { CCRYP_Buffer(state, index)! }
  func read(_ id: CRYPCallbackID) -> CRYPCallback? {
    Self.callback(id.rawValue, CCRYP_GetCallback(state, id.rawValue))
  }
  func write(_ id: CRYPCallbackID, value: CRYPCallback?) {
    var token: UInt32 = 0
    if let value {
      for k: UInt32 in 1...3
      where unsafeBitCast(value, to: UInt.self)
        == unsafeBitCast(Self.callback(id.rawValue, k)!, to: UInt.self)
      { token = k }
      precondition(token != 0)
    }
    CCRYP_SetCallback(state, id.rawValue, token)
  }
  static func callback(_ id: UInt32, _ token: UInt32) -> CRYPCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (1, 1): return { CCRYP_Invoke(OpaquePointer($0!), 1, 1) }
    case (1, 2): return { CCRYP_Invoke(OpaquePointer($0!), 1, 2) }
    case (1, 3): return { CCRYP_Invoke(OpaquePointer($0!), 1, 3) }
    case (2, 1): return { CCRYP_Invoke(OpaquePointer($0!), 2, 1) }
    case (2, 2): return { CCRYP_Invoke(OpaquePointer($0!), 2, 2) }
    case (2, 3): return { CCRYP_Invoke(OpaquePointer($0!), 2, 3) }
    case (3, 1): return { CCRYP_Invoke(OpaquePointer($0!), 3, 1) }
    case (3, 2): return { CCRYP_Invoke(OpaquePointer($0!), 3, 2) }
    case (3, 3): return { CCRYP_Invoke(OpaquePointer($0!), 3, 3) }
    case (4, 1): return { CCRYP_Invoke(OpaquePointer($0!), 4, 1) }
    case (4, 2): return { CCRYP_Invoke(OpaquePointer($0!), 4, 2) }
    case (4, 3): return { CCRYP_Invoke(OpaquePointer($0!), 4, 3) }
    case (5, 1): return { CCRYP_Invoke(OpaquePointer($0!), 5, 1) }
    case (5, 2): return { CCRYP_Invoke(OpaquePointer($0!), 5, 2) }
    case (5, 3): return { CCRYP_Invoke(OpaquePointer($0!), 5, 3) }
    default: preconditionFailure("Unknown callback")
    }
  }
  var defaults: CRYPCallbackDefaults {
    .init(
      inputComplete: Self.callback(1, 1)!, outputComplete: Self.callback(2, 1)!,
      error: Self.callback(3, 1)!, mspInitialize: Self.callback(4, 1)!,
      mspDeinitialize: Self.callback(5, 1)!)
  }
  var driver: CRYP<Self, Self, Self, Self> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: control[0] != 0, useSuspendResume: control[1] != 0,
      engines: control[2] == 0 ? .both : control[2] == 1 ? .crypOnly : .saesOnly)
  }
  func read(_ stream: CRYPStream, word: DMAHandleWord) -> UInt32 {
    let i: UInt32
    switch word {
    case .mode: i = 0
    case .state: i = 1
    case .errorCode: i = 2
    case .lock: i = 3
    case .queueAddress:
      return CCRYP_GetDMA(state, stream.rawValue, 4) == 0 ? 0 : 0x1000 + stream.rawValue * 0x100
    }
    return CCRYP_GetDMA(state, stream.rawValue, i)
  }
  func readMemory32(_ stream: CRYPStream, at address: UInt32) -> UInt32 {
    precondition(address == 0x1000 + stream.rawValue * 0x100)
    return CCRYP_GetDMA(state, stream.rawValue, 5) == 0 ? 0 : 0x2000 + stream.rawValue * 0x100
  }
  func writeMemory32(_ stream: CRYPStream, at address: UInt32, value: UInt32) {
    CCRYP_SetNode(state, stream.rawValue, (address - (0x2000 + stream.rawValue * 0x100)) / 4, value)
  }
  func writeCallback(_ stream: CRYPStream, id: DMACallbackID, value: DMACallback?) {
    var token: UInt32 = 0
    if let value {
      for kind in CRYPDMACallbackKind.allCases
      where unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) {
        token = kind.rawValue + 1
      }
      precondition(token != 0)
    }
    CCRYP_SetDMACallback(state, stream.rawValue, id.rawValue, token)
  }
  func callback(_ kind: CRYPDMACallbackKind) -> DMACallback { CRYPNoDMA().callback(kind) }
  func startInterrupt(
    _ stream: CRYPStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CCRYP_DMAOperation(
        state, stream.rawValue, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt(_ stream: CRYPStream) -> HALStatus {
    HALStatus(rawValue: CCRYP_DMAOperation(state, stream.rawValue, 1, 0, 0, 0))!
  }
  func abort(_ stream: CRYPStream, getTick: () -> UInt32) -> HALStatus {
    HALStatus(rawValue: CCRYP_DMAOperation(state, stream.rawValue, 2, 0, 0, 0))!
  }
  func getCounter(_ stream: CRYPStream) -> UInt32 {
    CCRYP_GetDMA(state, stream.rawValue, 6) & 0xFFFF
  }
  func getFIFOLevel(_ stream: CRYPStream) -> UInt32 {
    (CCRYP_GetDMA(state, stream.rawValue, 7) >> 16) & 0xFF
  }
  func tick() -> UInt32 { CCRYP_TickFor(state) }
  func testConfiguration() -> CRYPConfiguration {
    var v = CRYPConfiguration()
    v.dataType = CCRYP_GetConfigurationWord(state, 0)
    v.keySize = CCRYP_GetConfigurationWord(state, 1)
    v.algorithm = CCRYP_GetConfigurationWord(state, 2)
    v.headerSize = CCRYP_GetConfigurationWord(state, 3)
    v.dataWidthUnit = CCRYP_GetConfigurationWord(state, 4)
    v.headerWidthUnit = CCRYP_GetConfigurationWord(state, 5)
    v.keyIVConfigurationSkip = CCRYP_GetConfigurationWord(state, 6)
    v.keyMode = CCRYP_GetConfigurationWord(state, 7)
    v.keySelection = CCRYP_GetConfigurationWord(state, 8)
    v.key = CCRYP_GetConfigurationPointer(state, 0)?.assumingMemoryBound(to: UInt32.self)
    v.initialVector = CCRYP_GetConfigurationPointer(state, 1)?.assumingMemoryBound(to: UInt32.self)
    v.header = CCRYP_GetConfigurationPointer(state, 2)?.assumingMemoryBound(to: UInt32.self)
    v.b0 = CCRYP_GetConfigurationPointer(state, 3)?.assumingMemoryBound(to: UInt32.self)
    return v
  }
  func storeTestConfiguration(_ v: CRYPConfiguration) {
    CCRYP_SetConfigurationWord(state, 0, v.dataType)
    CCRYP_SetConfigurationWord(state, 1, v.keySize)
    CCRYP_SetConfigurationWord(state, 2, v.algorithm)
    CCRYP_SetConfigurationWord(state, 3, v.headerSize)
    CCRYP_SetConfigurationWord(state, 4, v.dataWidthUnit)
    CCRYP_SetConfigurationWord(state, 5, v.headerWidthUnit)
    CCRYP_SetConfigurationWord(state, 6, v.keyIVConfigurationSkip)
    CCRYP_SetConfigurationWord(state, 7, v.keyMode)
    CCRYP_SetConfigurationWord(state, 8, v.keySelection)
    CCRYP_SetConfigurationPointer(state, 0, v.key)
    CCRYP_SetConfigurationPointer(state, 1, v.initialVector)
    CCRYP_SetConfigurationPointer(state, 2, v.header)
    CCRYP_SetConfigurationPointer(state, 3, v.b0)
  }
  func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
    let h = driver
    switch op {
    case 0: return c != 0 ? 1 : h.initialize(getRevision: { control[7] }, getTick: tick).rawValue
    case 1: return c != 0 ? 1 : h.deinitialize().rawValue
    case 2:
      var configuration = testConfiguration()
      return withUnsafePointer(to: &configuration) {
        h.setConfiguration(c != 0 ? nil : $0).rawValue
      }
    case 3:
      var configuration = testConfiguration()
      let result = withUnsafeMutablePointer(to: &configuration) {
        h.getConfiguration(c != 0 ? nil : $0).rawValue
      }
      storeTestConfiguration(configuration)
      return result
    case 4:
      return h.registerCallback(id: a, callback: Self.callback(a >= 1 && a <= 5 ? a : 1, b))
        .rawValue
    case 5: return h.unregisterCallback(id: a).rawValue
    case 6:
      h.processSuspend()
      return 0
    case 7: return h.dmaProcessSuspend(getTick: tick).rawValue
    case 8: return h.suspend(getTick: tick).rawValue
    case 9: return h.resume(getRevision: { control[7] }, getTick: tick).rawValue
    case 12:
      return h.encryptInterrupt(
        input: buffer(0), size: UInt16(truncatingIfNeeded: a), output: buffer(1), getTick: tick
      ).rawValue
    case 13:
      return h.decryptInterrupt(
        input: buffer(0), size: UInt16(truncatingIfNeeded: a), output: buffer(1), getTick: tick
      ).rawValue
    case 14:
      return h.encryptDMA(
        input: buffer(0), size: UInt16(truncatingIfNeeded: a), output: buffer(1), getTick: tick
      ).rawValue
    case 15:
      return h.decryptDMA(
        input: buffer(0), size: UInt16(truncatingIfNeeded: a), output: buffer(1), getTick: tick
      ).rawValue
    case 10:
      return h.encrypt(
        input: buffer(0), size: UInt16(truncatingIfNeeded: a), output: buffer(1), timeout: b,
        getTick: tick
      ).rawValue
    case 11:
      return h.decrypt(
        input: buffer(0), size: UInt16(truncatingIfNeeded: a), output: buffer(1), timeout: b,
        getTick: tick
      ).rawValue
    case 16:
      h.handleInterrupt()
      return 0
    case 17: return h.getError()
    case 18: return h.getState()
    case 19: return h.aesEncrypt(timeout: a, getTick: tick).rawValue
    case 20: return h.aesEncryptIT(getTick: tick).rawValue
    case 22: return h.aesDecryptIT(getTick: tick).rawValue
    case 29:
      h.aesInterrupt()
      return 0
    case 21: return h.aesDecrypt(timeout: a, getTick: tick).rawValue
    case 23: return h.aesDecryptDMA(getTick: tick).rawValue
    case 24:
      h.dmaInputComplete()
      return 0
    case 25:
      h.dmaOutputComplete()
      return 0
    case 26:
      h.dmaError()
      return 0
    case 27:
      h.setDMAConfiguration(inputAddress: a, size: UInt16(truncatingIfNeeded: b), outputAddress: c)
      return 0
    case 28:
      h.aesProcessData(timeout: a, getTick: tick)
      return 0
    case 30:
      h.setKey(a)
      return 0
    case 31: return h.aesGCMProcess(timeout: a, getTick: tick).rawValue
    case 32: return h.aesGCMProcessIT(getTick: tick).rawValue
    case 35: return h.aesCCMProcessIT(getTick: tick).rawValue
    case 33: return h.aesGCMProcessDMA(getTick: tick).rawValue
    case 36: return h.aesCCMProcessDMA(getTick: tick).rawValue
    case 34: return h.aesCCMProcess(timeout: a, getTick: tick).rawValue
    case 37:
      h.authenticationPayloadInterrupt()
      return 0
    case 38: return h.authenticationHeaderPhase(timeout: a, getTick: tick).rawValue
    case 39: return h.authenticationHeaderPhaseDMA(getTick: tick).rawValue
    case 40:
      h.authenticationHeaderInterrupt()
      return 0
    case 41: return h.waitOnInputEmpty(timeout: a, getTick: tick).rawValue
    case 42: return h.waitOnBusy(timeout: a, getTick: tick).rawValue
    case 43: return h.waitOnOutputNotEmpty(timeout: a, getTick: tick).rawValue
    case 44: return h.waitOnComputationComplete(timeout: a, getTick: tick).rawValue
    case 45:
      h.readInitialVector(buffer(6))
      return 0
    case 46:
      h.writeInitialVector(buffer(6))
      return 0
    case 47:
      h.readContext(buffer(6), algorithm: a)
      return 0
    case 48:
      h.writeContext(buffer(6), algorithm: a)
      return 0
    case 49:
      h.phaseProcessingResume()
      return 0
    case 50: return h.saesAlgorithm(a, order: b)
    case 51: return h.generateGCMAuthenticationTag(buffer(1), timeout: b, getTick: tick).rawValue
    case 52: return h.generateCCMAuthenticationTag(buffer(1), timeout: b, getTick: tick).rawValue
    case 53:
      return h.wrapKey(input: buffer(0), output: buffer(1), timeout: b, getTick: tick).rawValue
    case 54: return h.unwrapKey(input: buffer(0), timeout: b, getTick: tick).rawValue
    case 55:
      return h.encryptSharedKey(
        input: buffer(0), output: buffer(1), id: a, timeout: b, getTick: tick
      ).rawValue
    case 56: return h.decryptSharedKey(input: buffer(0), id: a, timeout: b, getTick: tick).rawValue
    case 57: return h.extendedKeyDecrypt(timeout: a, getTick: tick).rawValue
    case 58: return h.extendedKeyEncrypt(timeout: a, getTick: tick).rawValue
    case 59:
      h.setExtendedKey(a)
      return 0
    case 100:
      h.enable()
      return 0
    case 101:
      h.disable()
      return 0
    case 102: return h.getFlag(a) ? 1 : 0
    case 103:
      h.enableInterrupts(a)
      return 0
    case 104:
      h.disableInterrupts(a)
      return 0
    case 105:
      h.resetHandleState()
      return 0
    case 106: return h.getInterrupt(a) ? 1 : 0
    case 107: return h.getInterruptSource(a) ? 1 : 0
    case 108:
      h.clearFlags(a)
      return 0
    case 109: return h.saesDataType(a)
    case 110: return h.saesKeySize(a)
    case 111: return h.saesAlgorithmBits(a)
    case 112: return h.crypAlgorithmDirection(a)
    default: preconditionFailure("Unimplemented differential operation")
    }
  }
}
final class CRYPPair {
  let allocations: [UnsafeMutableRawPointer]
  let c: CRYPModel
  let swift: CRYPModel
  let registered, suspend, engines, instance: UInt32
  init(
    _ registered: UInt32 = 0, _ suspend: UInt32 = 0, _ engines: UInt32 = 0, _ instance: UInt32 = 0
  ) {
    allocations = (0..<2).map { _ in
      UnsafeMutableRawPointer.allocate(byteCount: CCRYP_Size(), alignment: 16)
    }
    c = CRYPModel(state: OpaquePointer(allocations[0]))
    swift = CRYPModel(state: OpaquePointer(allocations[1]))
    self.registered = registered
    self.suspend = suspend
    self.engines = engines
    self.instance = instance
    reset()
  }
  deinit { for p in allocations { p.deallocate() } }
  func reset() {
    for m in [c, swift] { CCRYP_Reset(m.state, registered, suspend, engines, instance) }
  }
  func configuration(_ w: CRYPConfigurationWord, _ v: UInt32) {
    c.write(w, saved: false, value: v)
    swift.write(w, saved: false, value: v)
  }
  func suppliedConfiguration(_ w: CRYPConfigurationWord, _ v: UInt32) {
    for m in [c, swift] { CCRYP_SetConfigurationWord(m.state, UInt32(w.rawValue), v) }
  }
  func word(_ w: CRYPHandleWord, _ v: UInt32) {
    c.write(w, value: v)
    swift.write(w, value: v)
  }
  func half(_ w: CRYPHandleHalfWord, _ v: UInt16) {
    c.write(w, value: v)
    swift.write(w, value: v)
  }
  func register(_ r: CRYPRegister, _ v: UInt32) {
    c.write(r, value: v)
    swift.write(r, value: v)
  }
  func control(_ i: Int, _ v: UInt32) {
    c.control[i] = v
    swift.control[i] = v
  }
  func callback(_ id: UInt32, _ value: UInt32) {
    CCRYP_SetCallback(c.state, id, value)
    CCRYP_SetCallback(swift.state, id, value)
  }
  func event(_ index: UInt32, _ due: UInt32, _ register: CRYPRegister, _ value: UInt32) {
    for m in [c, swift] { CCRYP_Event(m.state, index, due, register.rawValue, value) }
  }
  @discardableResult
  func run(
    _ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ v: UInt32 = 0, file: StaticString = #filePath,
    line: UInt = #line
  ) -> UInt32 {
    let expected = CCRYP_Run(c.state, op, a, b, v)
    let actual = swift.run(op, a, b, v)
    XCTAssertEqual(
      actual, expected, "operation \(op), arguments \(a), \(b), \(v)", file: file, line: line)
    compare(file: file, line: line)
    return actual
  }
  func compare(file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(
      (0..<40).map { CCRYP_GetWord(c.state, UInt32($0)) },
      (0..<40).map { CCRYP_GetWord(swift.state, UInt32($0)) }, "handle", file: file, line: line)
    XCTAssertEqual(
      (0..<196).map { CCRYP_GetRegister(c.state, UInt32($0 * 4)) },
      (0..<196).map { CCRYP_GetRegister(swift.state, UInt32($0 * 4)) }, "registers", file: file,
      line: line)
    XCTAssertEqual(
      Array(UnsafeBufferPointer(start: c.control, count: 64)),
      Array(UnsafeBufferPointer(start: swift.control, count: 64)), "control", file: file, line: line
    )
    XCTAssertEqual(
      (1...5).map { CCRYP_GetCallback(c.state, UInt32($0)) },
      (1...5).map { CCRYP_GetCallback(swift.state, UInt32($0)) }, "callbacks", file: file,
      line: line)
    XCTAssertEqual(
      Array(UnsafeBufferPointer(start: CCRYP_Trace(c.state), count: Int(c.control[8]))),
      Array(UnsafeBufferPointer(start: CCRYP_Trace(swift.state), count: Int(swift.control[8]))),
      "callback/DMA trace", file: file, line: line)
    for ch: UInt32 in 0..<2 {
      XCTAssertEqual(
        (0..<8).map { CCRYP_GetDMA(c.state, ch, UInt32($0)) },
        (0..<8).map { CCRYP_GetDMA(swift.state, ch, UInt32($0)) }, "DMA fields", file: file,
        line: line)
      XCTAssertEqual(
        (0..<8).map { CCRYP_GetNode(c.state, ch, UInt32($0)) },
        (0..<8).map { CCRYP_GetNode(swift.state, ch, UInt32($0)) }, "DMA node", file: file,
        line: line)
      XCTAssertEqual(
        (0..<5).map { CCRYP_GetDMACallback(c.state, ch, UInt32($0)) },
        (0..<5).map { CCRYP_GetDMACallback(swift.state, ch, UInt32($0)) }, "DMA callbacks",
        file: file, line: line)
    }
    for i: UInt32 in 0..<12 {
      XCTAssertEqual(
        CCRYP_Normalize(c.state, UInt(bitPattern: CCRYP_GetPointer(c.state, i))),
        CCRYP_Normalize(swift.state, UInt(bitPattern: CCRYP_GetPointer(swift.state, i))),
        "pointer \(i)", file: file, line: line)
    }
    for array in CRYPSavedWords.allCases {
      let count = array == .initialVector ? 4 : array == .context ? 16 : 8
      XCTAssertEqual(
        Array(UnsafeBufferPointer(start: c.savedWords(array), count: count)),
        Array(UnsafeBufferPointer(start: swift.savedWords(array), count: count)),
        "saved words \(array)", file: file, line: line)
    }
    for i: UInt32 in 0..<8 {
      XCTAssertEqual(
        Array(UnsafeBufferPointer(start: c.buffer(i), count: 256)),
        Array(UnsafeBufferPointer(start: swift.buffer(i), count: 256)), "buffer \(i)", file: file,
        line: line)
    }
    for i: UInt32 in 0..<9 {
      XCTAssertEqual(
        CCRYP_GetConfigurationWord(c.state, i), CCRYP_GetConfigurationWord(swift.state, i),
        "configuration \(i)", file: file, line: line)
    }
    for i: UInt32 in 0..<4 {
      XCTAssertEqual(
        CCRYP_Normalize(c.state, UInt(bitPattern: CCRYP_GetConfigurationPointer(c.state, i))),
        CCRYP_Normalize(
          swift.state, UInt(bitPattern: CCRYP_GetConfigurationPointer(swift.state, i))),
        "configuration pointer \(i)", file: file, line: line)
    }
  }
}
