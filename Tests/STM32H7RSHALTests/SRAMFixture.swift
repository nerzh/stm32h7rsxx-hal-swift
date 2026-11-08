import CSRAMReference
import STM32H7RSHAL
import XCTest

final class SRAMFixture: SRAMHandleIO, SRAMCallbackIO, FMCMemoryIO, FMCRegisterIO, FMCDMAIO,
  RAMTestFixture
{
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  let variant: UInt32
  let ownsAllocation: Bool
  init(variant: UInt32 = 1) {
    self.variant = variant
    ownsAllocation = true
    allocation = .allocate(byteCount: CSRAM_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CSRAM_Reset(state)
  }
  init(borrowing state: OpaquePointer, variant: UInt32) {
    self.variant = variant
    ownsAllocation = false
    self.state = state
    allocation = UnsafeMutableRawPointer(state)
  }
  deinit { if ownsAllocation { allocation.deallocate() } }
  var context: UnsafeMutableRawPointer? { allocation }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CSRAM_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CSRAM_Set(state, group, index, value)
  }
  func runReference(_ operation: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
    CSRAM_Run(state, variant, operation, a, b, c)
  }
  func compare(to other: any RAMTestFixture) -> UInt32 { CSRAM_Compare(state, other.state) }
  func setParent(_ source: UInt32, to other: any RAMTestFixture) {
    CSRAM_SetParent(state, source, other.state)
  }
  func read(_ word: SRAMConfigurationWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
  func write(_ word: SRAMConfigurationWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
  func read(_ word: SRAMHandleWord) -> UInt32 { get(2, UInt32(word.rawValue)) }
  func write(_ word: SRAMHandleWord, value: UInt32) { set(2, UInt32(word.rawValue), value) }
  func read(_ id: SRAMCallbackID) -> SRAMCallback? {
    guard let p = CSRAM_GetCallback(state, id.rawValue) else { return nil }
    return unsafeBitCast(p, to: SRAMCallback.self)
  }
  func write(_ id: SRAMCallbackID, value: SRAMCallback?) {
    CSRAM_SetCallback(
      state, id.rawValue, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) })
  }
  func callback(_ id: UInt32, _ token: UInt32) -> SRAMCallback? {
    CSRAM_Callback(id, token).map { unsafeBitCast($0, to: SRAMCallback.self) }
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
  func read(_ register: FMCRegister) -> UInt32 { CSRAM_ReadRegister(state, offset(register)) }
  func write(_ register: FMCRegister, value: UInt32) {
    CSRAM_WriteRegister(state, offset(register), value)
  }
  func read8(at address: UInt32) -> UInt8 {
    UInt8(truncatingIfNeeded: CSRAM_ReadMemory(state, 8, address))
  }
  func write8(at address: UInt32, value: UInt8) {
    CSRAM_WriteMemory(state, 8, address, UInt32(value))
  }
  func read16(at address: UInt32) -> UInt16 {
    UInt16(truncatingIfNeeded: CSRAM_ReadMemory(state, 16, address))
  }
  func write16(at address: UInt32, value: UInt16) {
    CSRAM_WriteMemory(state, 16, address, UInt32(value))
  }
  func read32(at address: UInt32) -> UInt32 {
    UInt32(truncatingIfNeeded: CSRAM_ReadMemory(state, 32, address))
  }
  func write32(at address: UInt32, value: UInt32) {
    CSRAM_WriteMemory(state, 32, address, UInt32(value))
  }
  func getPRIMASK() -> UInt32 { preconditionFailure("Unexpected interrupt mask access") }
  func disableIRQ() { preconditionFailure("Unexpected interrupt masking") }
  func setPRIMASK(_ value: UInt32) { preconditionFailure("Unexpected interrupt mask access") }
  func instructionSynchronizationBarrier() { preconditionFailure("Unexpected instruction barrier") }
  func dataSynchronizationBarrier() { preconditionFailure("Unexpected barrier") }
  var channel: UInt32 { return get(6, 4) }
  func read(_ word: DMAHandleWord) -> UInt32 {
    switch word {
    case .mode: return CSRAM_DMARead(state, channel, 0)
    case .lock: return CSRAM_DMARead(state, channel, 6)
    case .state: return CSRAM_DMARead(state, channel, 5)
    case .errorCode: return CSRAM_DMARead(state, channel, 7)
    case .queueAddress:
      return CSRAM_DMARead(state, channel, 2) != 0 ? 0x2403_0000 + channel * 0x100 : 0
    }
  }
  func readDestinationDataWidth() -> UInt32 { CSRAM_DMARead(state, channel, 1) }
  func readMemory32(at address: UInt32) -> UInt32 { CSRAM_DMAReadMemory(state, address) }
  func writeMemory32(at address: UInt32, value: UInt32) {
    CSRAM_DMAWriteMemory(state, address, value)
  }
  func writeCallback(_ id: DMACallbackID, value: DMACallback?) {
    CSRAM_DMASetCallback(
      state, channel, id.rawValue, value.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) }
    )
  }
  func callback(_ kind: FMCDMACallbackKind) -> DMACallback {
    unsafeBitCast(CSRAM_DMACallback(variant, kind.rawValue)!, to: DMACallback.self)
  }
  func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32)
    -> HALStatus
  {
    HALStatus(rawValue: CSRAM_Start(state, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt() -> HALStatus {
    let head = readMemory32(at: read(.queueAddress))
    return HALStatus(
      rawValue: CSRAM_Start(
        state, 1, readMemory32(at: head + 12), readMemory32(at: head + 16),
        readMemory32(at: head + 8)))!
  }
  var driver: SRAM<SRAMFixture, SRAMFixture, SRAMFixture, SRAMFixture, SRAMFixture> {
    .init(
      registers: self, handle: self, callbacks: self, memory: self, dma: self,
      defaults: .init(
        mspInitialize: callback(0, 1)!, mspDeinitialize: callback(1, 1)!,
        dmaComplete: callback(2, 1)!, dmaError: callback(3, 1)!),
      useRegisteredCallbacks: variant != 0)
  }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CSRAM_Activate(state)
    var t0 = FMCNORSRAMTiming(
      addressSetupTime: get(3, 0), addressHoldTime: get(3, 1), dataSetupTime: get(3, 2),
      busTurnAroundDuration: get(3, 3), clockDivision: get(3, 4), dataLatency: get(3, 5),
      accessMode: get(3, 6))
    var t1 = FMCNORSRAMTiming(
      addressSetupTime: get(4, 0), addressHoldTime: get(4, 1), dataSetupTime: get(4, 2),
      busTurnAroundDuration: get(4, 3), clockDivision: get(4, 4), dataLatency: get(4, 5),
      accessMode: get(4, 6))
    var command = FMCSDRAMCommand(
      commandMode: get(5, 0), commandTarget: get(5, 1), autoRefreshNumber: get(5, 2),
      modeRegisterDefinition: get(5, 3))
    switch operation {
    case 0:
      return withUnsafeMutablePointer(to: &t1) { ext in
        driver.initialize(&t0, get(6, 6) != 0 ? nil : ext)
      }.rawValue
    case 1: return driver.deinitialize().rawValue
    case 2:
      return driver.read8(
        a, get(6, 5) != 0 ? nil : CSRAM_Buffer(state)!.assumingMemoryBound(to: UInt8.self), b
      ).rawValue
    case 3:
      return driver.write8(
        a, get(6, 5) != 0 ? nil : CSRAM_Buffer(state)!.assumingMemoryBound(to: UInt8.self), b
      ).rawValue
    case 4:
      return driver.read16(
        a, get(6, 5) != 0 ? nil : CSRAM_Buffer(state)!.assumingMemoryBound(to: UInt16.self), b
      ).rawValue
    case 5:
      return driver.write16(
        a, get(6, 5) != 0 ? nil : CSRAM_Buffer(state)!.assumingMemoryBound(to: UInt16.self), b
      ).rawValue
    case 6:
      return driver.read32(
        a, get(6, 5) != 0 ? nil : CSRAM_Buffer(state)!.assumingMemoryBound(to: UInt32.self), b
      ).rawValue
    case 7:
      return driver.write32(
        a, get(6, 5) != 0 ? nil : CSRAM_Buffer(state)!.assumingMemoryBound(to: UInt32.self), b
      ).rawValue
    case 8:
      return driver.readDMA(
        a, get(6, 5) != 0 ? nil : CSRAM_Buffer(state)!.assumingMemoryBound(to: UInt32.self), b
      ).rawValue
    case 9:
      return driver.writeDMA(
        a, get(6, 5) != 0 ? nil : CSRAM_Buffer(state)!.assumingMemoryBound(to: UInt32.self), b
      ).rawValue
    case 10: return driver.registerCallback(a, callback(a, b)).rawValue
    case 11: return driver.unregisterCallback(a).rawValue
    case 12: return driver.registerDMACallback(a, callback(a, b)).rawValue
    case 13: return driver.enableWrite().rawValue
    case 14: return driver.disableWrite().rawValue
    case 15: return driver.getState()
    case 50:
      driver.resetHandleState()
      return 0
    case 51:
      let context = CSRAM_DMAContext(state, b)!
      let parent = SRAMFixture(
        borrowing: OpaquePointer(CSRAM_GetParent(context)!), variant: variant)
      parent.driver.handleDMAEvent(
        FMCDMACallbackKind(rawValue: a)!, sourceContext: context,
        source: SRAMDMAEventSource(context: context))
      return 0
    default: preconditionFailure("Unknown operation")
    }
  }
}
private struct SRAMDMAEventSource: FMCDMAEventSourceIO {
  let context: UnsafeMutableRawPointer
  func disable() { CSRAM_DisableDMA(context) }
}
