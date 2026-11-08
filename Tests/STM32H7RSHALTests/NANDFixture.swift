import CNANDReference
import STM32H7RSHAL
import XCTest

final class NANDFixture: NANDHandleIO, NANDCallbackIO, FMCMemoryIO, FMCRegisterIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  let variant: UInt32
  init(variant: UInt32 = 1) {
    self.variant = variant
    allocation = .allocate(byteCount: CNAND_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CNAND_Reset(state)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CNAND_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CNAND_Set(state, group, index, value)
  }
  func read(_ word: NANDConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: NANDConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: NANDHandleWord) -> UInt32 { get(2, UInt32(word.rawValue)) }
  func write(_ word: NANDHandleWord, value: UInt32) { set(2, UInt32(word.rawValue), value) }
  func read(_ word: NANDDeviceConfigurationWord) -> UInt32 { get(3, UInt32(word.rawValue)) }
  func write(_ word: NANDDeviceConfigurationWord, value: UInt32) {
    set(3, UInt32(word.rawValue), value)
  }
  func read(_ id: NANDCallbackID) -> NANDCallback? {
    guard let p = CNAND_GetCallback(state, id.rawValue) else { return nil }
    return unsafeBitCast(p, to: NANDCallback.self)
  }
  func write(_ id: NANDCallbackID, value: NANDCallback?) {
    CNAND_SetCallback(
      state, id.rawValue, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func callback(_ id: UInt32, _ token: UInt32) -> NANDCallback? {
    CNAND_Callback(id, token).map { unsafeBitCast($0, to: NANDCallback.self) }
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
  func read(_ register: FMCRegister) -> UInt32 { CNAND_ReadRegister(state, offset(register)) }
  func write(_ register: FMCRegister, value: UInt32) {
    CNAND_WriteRegister(state, offset(register), value)
  }
  func read8(at address: UInt32) -> UInt8 {
    UInt8(truncatingIfNeeded: CNAND_ReadMemory(state, 8, address))
  }
  func write8(at address: UInt32, value: UInt8) {
    CNAND_WriteMemory(state, 8, address, UInt32(value))
  }
  func read16(at address: UInt32) -> UInt16 {
    UInt16(truncatingIfNeeded: CNAND_ReadMemory(state, 16, address))
  }
  func write16(at address: UInt32, value: UInt16) {
    CNAND_WriteMemory(state, 16, address, UInt32(value))
  }
  func read32(at address: UInt32) -> UInt32 {
    UInt32(truncatingIfNeeded: CNAND_ReadMemory(state, 32, address))
  }
  func write32(at address: UInt32, value: UInt32) {
    CNAND_WriteMemory(state, 32, address, UInt32(value))
  }
  func getPRIMASK() -> UInt32 { preconditionFailure("Unexpected interrupt mask access") }
  func disableIRQ() { preconditionFailure("Unexpected interrupt masking") }
  func setPRIMASK(_ value: UInt32) { preconditionFailure("Unexpected interrupt mask access") }
  func instructionSynchronizationBarrier() { preconditionFailure("Unexpected instruction barrier") }
  func dataSynchronizationBarrier() { CNAND_Barrier(state) }
  var driver: NAND<NANDFixture, NANDFixture, NANDFixture, NANDFixture> {
    .init(
      registers: self, handle: self, callbacks: self, memory: self,
      defaults: .init(
        mspInitialize: callback(0, 1)!, mspDeinitialize: callback(1, 1)!, interrupt: callback(2, 1)!
      ), useRegisteredCallbacks: variant != 0)
  }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CNAND_Activate(state)
    var t0 = FMCNANDTiming(
      setupTime: get(7, 0), waitSetupTime: get(7, 1), holdSetupTime: get(7, 2),
      hiZSetupTime: get(7, 3))
    var t1 = FMCNANDTiming(
      setupTime: get(8, 0), waitSetupTime: get(8, 1), holdSetupTime: get(8, 2),
      hiZSetupTime: get(8, 3))
    var device = NANDDeviceConfiguration(
      pageSize: get(4, 0), spareAreaSize: get(4, 1), blockSize: get(4, 2), blockCount: get(4, 3),
      planeCount: get(4, 4), planeSize: get(4, 5), extraCommandEnable: get(4, 6))
    var address = NANDAddress(
      page: UInt16(truncatingIfNeeded: get(5, 0)), plane: UInt16(truncatingIfNeeded: get(5, 1)),
      block: UInt16(truncatingIfNeeded: get(5, 2)))
    var id = NANDID(
      makerID: UInt8(truncatingIfNeeded: get(6, 0)), deviceID: UInt8(truncatingIfNeeded: get(6, 1)),
      thirdID: UInt8(truncatingIfNeeded: get(6, 2)), fourthID: UInt8(truncatingIfNeeded: get(6, 3)))
    defer {
      set(4, 0, UInt32(device.pageSize))
      set(4, 1, UInt32(device.spareAreaSize))
      set(4, 2, UInt32(device.blockSize))
      set(4, 3, UInt32(device.blockCount))
      set(4, 4, UInt32(device.planeCount))
      set(4, 5, UInt32(device.planeSize))
      set(4, 6, UInt32(device.extraCommandEnable))
      set(5, 0, UInt32(address.page))
      set(5, 1, UInt32(address.plane))
      set(5, 2, UInt32(address.block))
      set(6, 0, UInt32(id.makerID))
      set(6, 1, UInt32(id.deviceID))
      set(6, 2, UInt32(id.thirdID))
      set(6, 3, UInt32(id.fourthID))
    }
    switch operation {
    case 0: return driver.initialize(&t0, &t1).rawValue
    case 1: return driver.deinitialize().rawValue
    case 2:
      driver.interruptHandler()
      return 0
    case 3: return driver.readID(&id).rawValue
    case 4: return driver.reset().rawValue
    case 5: return driver.configureDevice(&device).rawValue
    case 6:
      return driver.readPages8(
        &address, CNAND_Buffer(state)!.assumingMemoryBound(to: UInt8.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 7:
      return driver.readPages16(
        &address, CNAND_Buffer(state)!.assumingMemoryBound(to: UInt16.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 8:
      return driver.writePages8(
        &address, CNAND_Buffer(state)!.assumingMemoryBound(to: UInt8.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 9:
      return driver.writePages16(
        &address, CNAND_Buffer(state)!.assumingMemoryBound(to: UInt16.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 10:
      return driver.readSpareArea8(
        &address, CNAND_Buffer(state)!.assumingMemoryBound(to: UInt8.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 11:
      return driver.readSpareArea16(
        &address, CNAND_Buffer(state)!.assumingMemoryBound(to: UInt16.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 12:
      return driver.writeSpareArea8(
        &address, CNAND_Buffer(state)!.assumingMemoryBound(to: UInt8.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 13:
      return driver.writeSpareArea16(
        &address, CNAND_Buffer(state)!.assumingMemoryBound(to: UInt16.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 14: return driver.eraseBlock(&address).rawValue
    case 15: return driver.incrementAddress(&address)
    case 16: return driver.registerCallback(a, callback(a, b)).rawValue
    case 17: return driver.unregisterCallback(a).rawValue
    case 18: return driver.enableECC().rawValue
    case 19: return driver.disableECC().rawValue
    case 20:
      return driver.getECC(
        CNAND_Value(state, 5)!.assumingMemoryBound(to: UInt32.self), a,
        getTick: { CNAND_TickFor(self.state) }
      ).rawValue
    case 21: return driver.getState()
    case 22: return driver.readStatus()
    case 23:
      driver.resetHandleState()
      return 0
    default: preconditionFailure("Unknown operation")
    }
  }
}
@discardableResult
func checkNAND(
  _ setup: (NANDFixture) -> Void = { _ in }, variant: UInt32 = 1, operation: UInt32,
  _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, file: StaticString = #filePath,
  line: UInt = #line
) -> NANDFixture {
  let reference = NANDFixture(variant: variant)
  let swift = NANDFixture(variant: variant)
  setup(reference)
  setup(swift)
  let expected = CNAND_Run(reference.state, variant, operation, a, b, c)
  let actual = swift.run(operation, a, b, c)
  XCTAssertEqual(actual, expected, "operation \(operation)", file: file, line: line)
  let difference = CNAND_Compare(reference.state, swift.state)
  XCTAssertEqual(
    difference, 0, "operation \(operation), difference \(difference)", file: file, line: line)
  return swift
}
