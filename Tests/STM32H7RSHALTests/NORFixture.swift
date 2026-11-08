import CNORReference
import STM32H7RSHAL
import XCTest

final class NORFixture: NORHandleIO, NORSharedIO, NORCallbackIO, FMCMemoryIO, FMCRegisterIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  let variant: UInt32
  init(variant: UInt32 = 1) {
    self.variant = variant
    allocation = .allocate(byteCount: CNOR_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CNOR_Reset(state)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CNOR_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CNOR_Set(state, group, index, value)
  }
  func readMemoryDataWidth() -> UInt32 { CNOR_ReadShared(state) }
  func writeMemoryDataWidth(_ value: UInt32) { CNOR_WriteShared(state, value) }
  func shareWidth(with other: NORFixture) { CNOR_Share(state, other.state) }
  func read(_ word: NORConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: NORConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: NORHandleWord) -> UInt32 { get(2, UInt32(word.rawValue)) }
  func write(_ word: NORHandleWord, value: UInt32) { set(2, UInt32(word.rawValue), value) }
  func read(_ id: NORCallbackID) -> NORCallback? {
    guard let p = CNOR_GetCallback(state, id.rawValue) else { return nil }
    return unsafeBitCast(p, to: NORCallback.self)
  }
  func write(_ id: NORCallbackID, value: NORCallback?) {
    CNOR_SetCallback(
      state, id.rawValue, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func callback(_ id: UInt32, _ token: UInt32) -> NORCallback? {
    CNOR_Callback(id, token).map { unsafeBitCast($0, to: NORCallback.self) }
  }
  func offset(_ register: FMCRegister) -> UInt32 {
    switch register {
    case .btcr(let index): return index * 4
    case .bwtr(let index): return 0x104 + index * 4
    case .pcr: return 0x80
    case .sr: return 0x84
    case .pmem: return 0x88
    case .patt: return 0x8C
    case .eccr: return 0x94
    case .sdcr(let index): return 0x140 + index * 4
    case .sdtr(let index): return 0x148 + index * 4
    case .sdcmr: return 0x150
    case .sdrtr: return 0x154
    case .sdsr: return 0x158
    }
  }
  func read(_ register: FMCRegister) -> UInt32 { CNOR_ReadRegister(state, offset(register)) }
  func write(_ register: FMCRegister, value: UInt32) {
    CNOR_WriteRegister(state, offset(register), value)
  }
  func read8(at address: UInt32) -> UInt8 {
    UInt8(truncatingIfNeeded: CNOR_ReadMemory(state, 8, address))
  }
  func write8(at address: UInt32, value: UInt8) {
    CNOR_WriteMemory(state, 8, address, UInt32(value))
  }
  func read16(at address: UInt32) -> UInt16 {
    UInt16(truncatingIfNeeded: CNOR_ReadMemory(state, 16, address))
  }
  func write16(at address: UInt32, value: UInt16) {
    CNOR_WriteMemory(state, 16, address, UInt32(value))
  }
  func read32(at address: UInt32) -> UInt32 {
    UInt32(truncatingIfNeeded: CNOR_ReadMemory(state, 32, address))
  }
  func write32(at address: UInt32, value: UInt32) {
    CNOR_WriteMemory(state, 32, address, UInt32(value))
  }
  func getPRIMASK() -> UInt32 { preconditionFailure("Unexpected interrupt mask access") }
  func disableIRQ() { preconditionFailure("Unexpected interrupt masking") }
  func setPRIMASK(_ value: UInt32) { preconditionFailure("Unexpected interrupt mask access") }
  func instructionSynchronizationBarrier() { preconditionFailure("Unexpected instruction barrier") }
  func dataSynchronizationBarrier() { CNOR_Barrier(state) }
  var driver: NOR<NORFixture, NORFixture, NORFixture, NORFixture, NORFixture> {
    .init(
      registers: self, handle: self, shared: self, callbacks: self, memory: self,
      defaults: .init(
        mspInitialize: callback(0, 1)!, mspDeinitialize: callback(1, 1)!,
        mspWait: { context, timeout in CNOR_Wait(OpaquePointer(context!), timeout) }),
      useRegisteredCallbacks: variant != 0)
  }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CNOR_Activate(state)
    var t0 = FMCNORSRAMTiming(
      addressSetupTime: get(5, 0), addressHoldTime: get(5, 1), dataSetupTime: get(5, 2),
      busTurnAroundDuration: get(5, 3), clockDivision: get(5, 4), dataLatency: get(5, 5),
      accessMode: get(5, 6))
    var t1 = FMCNORSRAMTiming(
      addressSetupTime: get(6, 0), addressHoldTime: get(6, 1), dataSetupTime: get(6, 2),
      busTurnAroundDuration: get(6, 3), clockDivision: get(6, 4), dataLatency: get(6, 5),
      accessMode: get(6, 6))
    var id = NORID(
      manufacturerCode: UInt16(truncatingIfNeeded: get(3, 0)),
      deviceCode1: UInt16(truncatingIfNeeded: get(3, 1)),
      deviceCode2: UInt16(truncatingIfNeeded: get(3, 2)),
      deviceCode3: UInt16(truncatingIfNeeded: get(3, 3)))
    var cfi = NORCFI(
      cfi1: UInt16(truncatingIfNeeded: get(4, 0)), cfi2: UInt16(truncatingIfNeeded: get(4, 1)),
      cfi3: UInt16(truncatingIfNeeded: get(4, 2)), cfi4: UInt16(truncatingIfNeeded: get(4, 3)))
    defer {
      set(3, 0, UInt32(id.manufacturerCode))
      set(3, 1, UInt32(id.deviceCode1))
      set(3, 2, UInt32(id.deviceCode2))
      set(3, 3, UInt32(id.deviceCode3))
      set(4, 0, UInt32(cfi.cfi1))
      set(4, 1, UInt32(cfi.cfi2))
      set(4, 2, UInt32(cfi.cfi3))
      set(4, 3, UInt32(cfi.cfi4))
    }
    switch operation {
    case 0:
      return withUnsafeMutablePointer(to: &t1) { ext in
        driver.initialize(&t0, get(7, 9) != 0 ? nil : ext)
      }.rawValue
    case 1: return driver.deinitialize().rawValue
    case 2: return driver.readID(&id).rawValue
    case 3: return driver.returnToReadMode().rawValue
    case 4: return driver.read(a, CNOR_Buffer(state)!.assumingMemoryBound(to: UInt16.self)).rawValue
    case 5:
      return driver.program(a, CNOR_Buffer(state)!.assumingMemoryBound(to: UInt16.self)).rawValue
    case 6:
      return driver.readBuffer(a, CNOR_Buffer(state)!.assumingMemoryBound(to: UInt16.self), b)
        .rawValue
    case 7:
      return driver.programBuffer(a, CNOR_Buffer(state)!.assumingMemoryBound(to: UInt16.self), b)
        .rawValue
    case 8: return driver.eraseBlock(a, b).rawValue
    case 9: return driver.eraseChip(a).rawValue
    case 10: return driver.readCFI(&cfi).rawValue
    case 11: return driver.registerCallback(a, callback(a, b)).rawValue
    case 12: return driver.unregisterCallback(a).rawValue
    case 13: return driver.enableWrite().rawValue
    case 14: return driver.disableWrite().rawValue
    case 15: return driver.getState()
    case 16: return driver.getStatus(a, b, getTick: { CNOR_TickFor(self.state) })
    case 17:
      driver.resetHandleState()
      return 0
    default: preconditionFailure("Unknown operation")
    }
  }
}
@discardableResult
func checkNOR(
  _ setup: (NORFixture) -> Void = { _ in }, variant: UInt32 = 1, operation: UInt32, _ a: UInt32 = 0,
  _ b: UInt32 = 0, _ c: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line
) -> NORFixture {
  let reference = NORFixture(variant: variant)
  let swift = NORFixture(variant: variant)
  setup(reference)
  setup(swift)
  let expected = CNOR_Run(reference.state, variant, operation, a, b, c)
  XCTAssertEqual(
    swift.run(operation, a, b, c), expected, "operation \(operation)", file: file, line: line)
  XCTAssertEqual(
    CNOR_Compare(reference.state, swift.state), 0, "operation \(operation)", file: file, line: line)
  return swift
}
