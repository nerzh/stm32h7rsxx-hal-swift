import CSDRAMReference
import STM32H7RSHAL
import XCTest

final class SDRAMFixture: SDRAMHandleIO, SDRAMCallbackIO, FMCMemoryIO, FMCRegisterIO, FMCDMAIO,
  RAMTestFixture
{
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  let variant: UInt32
  let ownsAllocation: Bool
  init(variant: UInt32 = 1) {
    self.variant = variant
    ownsAllocation = true
    allocation = .allocate(byteCount: CSDRAM_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CSDRAM_Reset(state)
  }
  init(borrowing state: OpaquePointer, variant: UInt32) {
    self.variant = variant
    ownsAllocation = false
    self.state = state
    allocation = UnsafeMutableRawPointer(state)
  }
  deinit { if ownsAllocation { allocation.deallocate() } }
  var context: UnsafeMutableRawPointer? { allocation }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CSDRAM_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CSDRAM_Set(state, group, index, value)
  }
  func runReference(_ operation: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
    CSDRAM_Run(state, variant, operation, a, b, c)
  }
  func compare(to other: any RAMTestFixture) -> UInt32 { CSDRAM_Compare(state, other.state) }
  func setParent(_ source: UInt32, to other: any RAMTestFixture) {
    CSDRAM_SetParent(state, source, other.state)
  }
  func read(_ word: SDRAMConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: SDRAMConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: SDRAMHandleWord) -> UInt32 { get(2, UInt32(word.rawValue)) }
  func write(_ word: SDRAMHandleWord, value: UInt32) { set(2, UInt32(word.rawValue), value) }
  func read(_ id: SDRAMCallbackID) -> SDRAMCallback? {
    guard let p = CSDRAM_GetCallback(state, id.rawValue) else { return nil }
    return unsafeBitCast(p, to: SDRAMCallback.self)
  }
  func write(_ id: SDRAMCallbackID, value: SDRAMCallback?) {
    CSDRAM_SetCallback(
      state, id.rawValue, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func callback(_ id: UInt32, _ token: UInt32) -> SDRAMCallback? {
    CSDRAM_Callback(id, token).map { unsafeBitCast($0, to: SDRAMCallback.self) }
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
  func read(_ register: FMCRegister) -> UInt32 { CSDRAM_ReadRegister(state, offset(register)) }
  func write(_ register: FMCRegister, value: UInt32) {
    CSDRAM_WriteRegister(state, offset(register), value)
  }
  func read8(at address: UInt32) -> UInt8 {
    UInt8(truncatingIfNeeded: CSDRAM_ReadMemory(state, 8, address))
  }
  func write8(at address: UInt32, value: UInt8) {
    CSDRAM_WriteMemory(state, 8, address, UInt32(value))
  }
  func read16(at address: UInt32) -> UInt16 {
    UInt16(truncatingIfNeeded: CSDRAM_ReadMemory(state, 16, address))
  }
  func write16(at address: UInt32, value: UInt16) {
    CSDRAM_WriteMemory(state, 16, address, UInt32(value))
  }
  func read32(at address: UInt32) -> UInt32 {
    UInt32(truncatingIfNeeded: CSDRAM_ReadMemory(state, 32, address))
  }
  func write32(at address: UInt32, value: UInt32) {
    CSDRAM_WriteMemory(state, 32, address, UInt32(value))
  }
  func getPRIMASK() -> UInt32 { preconditionFailure("Unexpected interrupt mask access") }
  func disableIRQ() { preconditionFailure("Unexpected interrupt masking") }
  func setPRIMASK(_ value: UInt32) { preconditionFailure("Unexpected interrupt mask access") }
  func instructionSynchronizationBarrier() { preconditionFailure("Unexpected instruction barrier") }
  func dataSynchronizationBarrier() { preconditionFailure("Unexpected barrier") }
  var channel: UInt32 { return get(6, 4) }
  func read(_ word: DMAHandleWord) -> UInt32 {
    switch word {
    case .mode: return CSDRAM_DMARead(state, channel, 0)
    case .lock: return CSDRAM_DMARead(state, channel, 6)
    case .state: return CSDRAM_DMARead(state, channel, 5)
    case .errorCode: return CSDRAM_DMARead(state, channel, 7)
    case .queueAddress:
      return CSDRAM_DMARead(state, channel, 2) != 0 ? 0x2403_0000 + channel * 0x100 : 0
    }
  }
  func readDestinationDataWidth() -> UInt32 { CSDRAM_DMARead(state, channel, 1) }
  func readMemory32(at address: UInt32) -> UInt32 { CSDRAM_DMAReadMemory(state, address) }
  func writeMemory32(at address: UInt32, value: UInt32) {
    CSDRAM_DMAWriteMemory(state, address, value)
  }
  func writeCallback(_ id: DMACallbackID, value: DMACallback?) {
    CSDRAM_DMASetCallback(
      state, channel, id.rawValue, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) }
    )
  }
  func callback(_ kind: FMCDMACallbackKind) -> DMACallback {
    unsafeBitCast(CSDRAM_DMACallback(variant, kind.rawValue)!, to: DMACallback.self)
  }
  func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32)
    -> HALStatus
  {
    HALStatus(rawValue: CSDRAM_Start(state, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt() -> HALStatus {
    let head = readMemory32(at: read(.queueAddress))
    return HALStatus(
      rawValue: CSDRAM_Start(
        state, 1, readMemory32(at: head + 12), readMemory32(at: head + 16),
        readMemory32(at: head + 8)))!
  }
  var driver: SDRAM<SDRAMFixture, SDRAMFixture, SDRAMFixture, SDRAMFixture, SDRAMFixture> {
    .init(
      registers: self, handle: self, callbacks: self, memory: self, dma: self,
      defaults: .init(
        mspInitialize: callback(0, 1)!, mspDeinitialize: callback(1, 1)!,
        refreshError: callback(2, 1)!, dmaComplete: callback(3, 1)!, dmaError: callback(4, 1)!),
      useRegisteredCallbacks: variant != 0)
  }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CSDRAM_Activate(state)
    var t0 = FMCSDRAMTiming(
      loadToActiveDelay: get(3, 0), exitSelfRefreshDelay: get(3, 1), selfRefreshTime: get(3, 2),
      rowCycleDelay: get(3, 3), writeRecoveryTime: get(3, 4), rpDelay: get(3, 5),
      rcdDelay: get(3, 6))
    var t1 = FMCSDRAMTiming(
      loadToActiveDelay: get(4, 0), exitSelfRefreshDelay: get(4, 1), selfRefreshTime: get(4, 2),
      rowCycleDelay: get(4, 3), writeRecoveryTime: get(4, 4), rpDelay: get(4, 5),
      rcdDelay: get(4, 6))
    var command = FMCSDRAMCommand(
      commandMode: get(5, 0), commandTarget: get(5, 1), autoRefreshNumber: get(5, 2),
      modeRegisterDefinition: get(5, 3))
    switch operation {
    case 0: return driver.initialize(&t0).rawValue
    case 1: return driver.deinitialize().rawValue
    case 2:
      driver.interruptHandler()
      return 0
    case 3:
      return driver.read8(
        a, get(6, 5) != 0 ? nil : CSDRAM_Buffer(state)!.assumingMemoryBound(to: UInt8.self), b
      ).rawValue
    case 4:
      return driver.write8(
        a, get(6, 5) != 0 ? nil : CSDRAM_Buffer(state)!.assumingMemoryBound(to: UInt8.self), b
      ).rawValue
    case 5:
      return driver.read16(
        a, get(6, 5) != 0 ? nil : CSDRAM_Buffer(state)!.assumingMemoryBound(to: UInt16.self), b
      ).rawValue
    case 6:
      return driver.write16(
        a, get(6, 5) != 0 ? nil : CSDRAM_Buffer(state)!.assumingMemoryBound(to: UInt16.self), b
      ).rawValue
    case 7:
      return driver.read32(
        a, get(6, 5) != 0 ? nil : CSDRAM_Buffer(state)!.assumingMemoryBound(to: UInt32.self), b
      ).rawValue
    case 8:
      return driver.write32(
        a, get(6, 5) != 0 ? nil : CSDRAM_Buffer(state)!.assumingMemoryBound(to: UInt32.self), b
      ).rawValue
    case 9:
      return driver.readDMA(
        a, get(6, 5) != 0 ? nil : CSDRAM_Buffer(state)!.assumingMemoryBound(to: UInt32.self), b
      ).rawValue
    case 10:
      return driver.writeDMA(
        a, get(6, 5) != 0 ? nil : CSDRAM_Buffer(state)!.assumingMemoryBound(to: UInt32.self), b
      ).rawValue
    case 11: return driver.registerCallback(a, callback(a, b)).rawValue
    case 12: return driver.unregisterCallback(a).rawValue
    case 13: return driver.registerDMACallback(a, callback(a, b)).rawValue
    case 14: return driver.enableWriteProtection().rawValue
    case 15: return driver.disableWriteProtection().rawValue
    case 16: return driver.sendCommand(&command, a).rawValue
    case 17: return driver.programRefreshRate(a).rawValue
    case 18: return driver.setAutoRefreshNumber(a).rawValue
    case 19: return driver.getModeStatus()
    case 20: return driver.getState()
    case 50:
      driver.resetHandleState()
      return 0
    case 51:
      let context = CSDRAM_DMAContext(state, b)!
      let parent = SDRAMFixture(
        borrowing: OpaquePointer(CSDRAM_GetParent(context)!), variant: variant)
      parent.driver.handleDMAEvent(
        FMCDMACallbackKind(rawValue: a)!, sourceContext: context,
        source: SDRAMDMAEventSource(context: context))
      return 0
    default: preconditionFailure("Unknown operation")
    }
  }
}
private struct SDRAMDMAEventSource: FMCDMAEventSourceIO {
  let context: UnsafeMutableRawPointer
  func disable() { CSDRAM_DisableDMA(context) }
}
