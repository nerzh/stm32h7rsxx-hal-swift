import CXSPIReference
import XCTest

@testable import STM32H7RSHAL

final class XSPIFixture: XSPIRegisterIO, XSPIHandleIO, XSPICallbackIO, XSPIDMAIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init(callbacks: Bool = true) {
    allocation = .allocate(byteCount: CXSPI_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CXSPI_Reset(state, callbacks ? 1 : 0)
  }
  deinit { allocation.deallocate() }
  var context: UnsafeMutableRawPointer? { allocation }
  var instance: XSPIInstance { XSPIInstance.allCases[Int(control(0))] }
  func control(_ index: UInt32) -> UInt32 { CXSPI_Get(state, 2, index) }
  func control(_ index: UInt32, _ value: UInt32) { CXSPI_Set(state, 2, index, value) }
  func buffer(_ index: UInt32 = 0) -> UnsafeMutablePointer<UInt8> { CXSPI_Buffer(state, index)! }
  func raw(_ register: XSPIRegister, _ value: UInt32) {
    CXSPI_Set(state, 0, register.rawValue / 4, value)
  }
  func raw(_ register: XSPIRegister) -> UInt32 { CXSPI_Get(state, 0, register.rawValue / 4) }
  func read(_ register: XSPIRegister) -> UInt32 {
    CXSPI_ReadRegister(state, control(0), register.rawValue, 4)
  }
  func write(_ register: XSPIRegister, value: UInt32) {
    CXSPI_WriteRegister(state, control(0), register.rawValue, 4, value)
  }
  func read8(_ register: XSPIRegister) -> UInt8 {
    UInt8(CXSPI_ReadRegister(state, control(0), register.rawValue, 1))
  }
  func write8(_ register: XSPIRegister, value: UInt8) {
    CXSPI_WriteRegister(state, control(0), register.rawValue, 1, UInt32(value))
  }
  func address(of register: XSPIRegister) -> UInt32 { instance.rawValue + register.rawValue }
  func readControl(_ instance: XSPIInstance) -> UInt32 {
    CXSPI_ReadRegister(state, instance == .xspi1 ? 0 : 1, 0, 4)
  }
  func writeControl(_ instance: XSPIInstance, value: UInt32) {
    CXSPI_WriteRegister(state, instance == .xspi1 ? 0 : 1, 0, 4, value)
  }
  func readManagerControl() -> UInt32 { CXSPI_ReadRegister(state, 2, 0, 4) }
  func writeManagerControl(_ value: UInt32) { CXSPI_WriteRegister(state, 2, 0, 4, value) }
  func config(_ index: UInt32) -> UInt32 { CXSPI_Get(state, 11, 1 + index) }
  func config(_ index: UInt32, _ value: UInt32) { CXSPI_Set(state, 11, 1 + index, value) }
  func read(_ word: XSPIConfigurationWord) -> UInt32 {
    CXSPI_Get(state, 1, 0 + UInt32(word.rawValue))
  }
  func write(_ word: XSPIConfigurationWord, value: UInt32) {
    CXSPI_Set(state, 1, 0 + UInt32(word.rawValue), UInt32(value))
  }
  func read(_ word: XSPIHandleWord) -> UInt32 { CXSPI_Get(state, 1, 15 + UInt32(word.rawValue)) }
  func write(_ word: XSPIHandleWord, value: UInt32) {
    CXSPI_Set(state, 1, 15 + UInt32(word.rawValue), UInt32(value))
  }
  func readBuffer() -> UnsafeMutablePointer<UInt8>? {
    UnsafeMutablePointer<UInt8>(bitPattern: CXSPI_GetPointer(state, 0))
  }
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?) {
    CXSPI_SetPointer(state, 0, UInt(bitPattern: value))
  }
  func read(_ id: XSPICallbackID) -> XSPICallback? {
    let bits = CXSPI_GetCallback(state, id.rawValue)
    return bits == 0 ? nil : unsafeBitCast(bits, to: XSPICallback.self)
  }
  func write(_ id: XSPICallbackID, value: XSPICallback?) {
    CXSPI_SetCallback(state, id.rawValue, value.map { unsafeBitCast($0, to: UInt.self) } ?? 0)
  }
  func configurationXSPIConfiguration() -> XSPIConfiguration {
    .init(
      fifoThresholdByte: config(0), memoryMode: config(1), memoryType: config(2),
      memorySize: config(3), chipSelectHighTimeCycle: config(4), freeRunningClock: config(5),
      clockMode: config(6), wrapSize: config(7), clockPrescaler: config(8),
      sampleShifting: config(9), delayHoldQuarterCycle: config(10), chipSelectBoundary: config(11),
      maxTran: config(12), refresh: config(13), memorySelect: config(14))
  }
  func setConfig(_ value: XSPIConfiguration) {
    config(0, value.fifoThresholdByte)
    config(1, value.memoryMode)
    config(2, value.memoryType)
    config(3, value.memorySize)
    config(4, value.chipSelectHighTimeCycle)
    config(5, value.freeRunningClock)
    config(6, value.clockMode)
    config(7, value.wrapSize)
    config(8, value.clockPrescaler)
    config(9, value.sampleShifting)
    config(10, value.delayHoldQuarterCycle)
    config(11, value.chipSelectBoundary)
    config(12, value.maxTran)
    config(13, value.refresh)
    config(14, value.memorySelect)
  }
  func configurationXSPIRegularCommand() -> XSPIRegularCommand {
    .init(
      operationType: config(0), ioSelect: config(1), instruction: config(2),
      instructionMode: config(3), instructionWidth: config(4), instructionDTRMode: config(5),
      address: config(6), addressMode: config(7), addressWidth: config(8),
      addressDTRMode: config(9), alternateBytes: config(10), alternateBytesMode: config(11),
      alternateBytesWidth: config(12), alternateBytesDTRMode: config(13), dataMode: config(14),
      dataLength: config(15), dataDTRMode: config(16), dummyCycles: config(17), dqsMode: config(18))
  }
  func setConfig(_ value: XSPIRegularCommand) {
    config(0, value.operationType)
    config(1, value.ioSelect)
    config(2, value.instruction)
    config(3, value.instructionMode)
    config(4, value.instructionWidth)
    config(5, value.instructionDTRMode)
    config(6, value.address)
    config(7, value.addressMode)
    config(8, value.addressWidth)
    config(9, value.addressDTRMode)
    config(10, value.alternateBytes)
    config(11, value.alternateBytesMode)
    config(12, value.alternateBytesWidth)
    config(13, value.alternateBytesDTRMode)
    config(14, value.dataMode)
    config(15, value.dataLength)
    config(16, value.dataDTRMode)
    config(17, value.dummyCycles)
    config(18, value.dqsMode)
  }
  func configurationXSPIHyperbusConfiguration() -> XSPIHyperbusConfiguration {
    .init(
      rwRecoveryTimeCycle: config(0), accessTimeCycle: config(1), writeZeroLatency: config(2),
      latencyMode: config(3))
  }
  func setConfig(_ value: XSPIHyperbusConfiguration) {
    config(0, value.rwRecoveryTimeCycle)
    config(1, value.accessTimeCycle)
    config(2, value.writeZeroLatency)
    config(3, value.latencyMode)
  }
  func configurationXSPIHyperbusCommand() -> XSPIHyperbusCommand {
    .init(
      addressSpace: config(0), address: config(1), addressWidth: config(2), dataLength: config(3),
      dqsMode: config(4), dataMode: config(5))
  }
  func setConfig(_ value: XSPIHyperbusCommand) {
    config(0, value.addressSpace)
    config(1, value.address)
    config(2, value.addressWidth)
    config(3, value.dataLength)
    config(4, value.dqsMode)
    config(5, value.dataMode)
  }
  func configurationXSPIAutoPollingConfiguration() -> XSPIAutoPollingConfiguration {
    .init(
      matchValue: config(0), matchMask: config(1), matchMode: config(2), automaticStop: config(3),
      intervalTime: config(4))
  }
  func setConfig(_ value: XSPIAutoPollingConfiguration) {
    config(0, value.matchValue)
    config(1, value.matchMask)
    config(2, value.matchMode)
    config(3, value.automaticStop)
    config(4, value.intervalTime)
  }
  func configurationXSPIMemoryMappedConfiguration() -> XSPIMemoryMappedConfiguration {
    .init(timeOutActivation: config(0), timeoutPeriodClock: config(1))
  }
  func setConfig(_ value: XSPIMemoryMappedConfiguration) {
    config(0, value.timeOutActivation)
    config(1, value.timeoutPeriodClock)
  }
  func configurationXSPIManagerConfiguration() -> XSPIManagerConfiguration {
    .init(nCSOverride: config(0), ioPort: config(1), req2AckTime: config(2))
  }
  func setConfig(_ value: XSPIManagerConfiguration) {
    config(0, value.nCSOverride)
    config(1, value.ioPort)
    config(2, value.req2AckTime)
  }
  func configurationXSPICalibrationConfiguration() -> XSPICalibrationConfiguration {
    .init(
      delayValueType: config(0), fineCalibrationUnit: config(1), coarseCalibrationUnit: config(2),
      maxCalibration: config(3))
  }
  func setConfig(_ value: XSPICalibrationConfiguration) {
    config(0, value.delayValueType)
    config(1, value.fineCalibrationUnit)
    config(2, value.coarseCalibrationUnit)
    config(3, value.maxCalibration)
  }
  var defaults: XSPICallbackDefaults {
    .init(
      error: unsafeBitCast(CXSPI_Callback(0, 1), to: XSPICallback.self),
      abortComplete: unsafeBitCast(CXSPI_Callback(1, 1), to: XSPICallback.self),
      fifoThreshold: unsafeBitCast(CXSPI_Callback(2, 1), to: XSPICallback.self),
      commandComplete: unsafeBitCast(CXSPI_Callback(3, 1), to: XSPICallback.self),
      receiveComplete: unsafeBitCast(CXSPI_Callback(4, 1), to: XSPICallback.self),
      transmitComplete: unsafeBitCast(CXSPI_Callback(5, 1), to: XSPICallback.self),
      receiveHalfComplete: unsafeBitCast(CXSPI_Callback(6, 1), to: XSPICallback.self),
      transmitHalfComplete: unsafeBitCast(CXSPI_Callback(7, 1), to: XSPICallback.self),
      statusMatch: unsafeBitCast(CXSPI_Callback(8, 1), to: XSPICallback.self),
      timeout: unsafeBitCast(CXSPI_Callback(9, 1), to: XSPICallback.self),
      mspInitialize: unsafeBitCast(CXSPI_Callback(10, 1), to: XSPICallback.self),
      mspDeinitialize: unsafeBitCast(CXSPI_Callback(11, 1), to: XSPICallback.self))
  }
  var driver: XSPI<XSPIFixture, XSPIFixture, XSPIFixture, XSPIFixture> {
    .init(
      registers: self, handle: self, callbacks: self, dma: self, defaults: defaults,
      useRegisteredCallbacks: control(63) != 0)
  }
  func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CXSPI_Activate(state)
    let d = driver
    switch op {
    case 0:
      let result = d.initialize(getTick: { CXSPI_TickFor(self.state) }).rawValue
      return result
    case 1:
      let result = d.deinitialize().rawValue
      return result
    case 2:
      d.interruptHandler()
      return 0
    case 3:
      let result = d.command(
        configurationXSPIRegularCommand(), b, getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 4:
      let result = d.commandInterrupt(
        configurationXSPIRegularCommand(), getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 5:
      let result = d.configureHyperbus(
        configurationXSPIHyperbusConfiguration(), b, getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 6:
      let result = d.hyperbusCommand(
        configurationXSPIHyperbusCommand(), b, getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 7:
      let result = d.transmit(
        control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))), b,
        getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 8:
      let result = d.receive(
        control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))), b,
        getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 9:
      let result = d.transmitInterrupt(
        control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14)))
      ).rawValue
      return result
    case 10:
      let result = d.receiveInterrupt(
        control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14)))
      ).rawValue
      return result
    case 11:
      let result = d.transmitDMA(control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))))
        .rawValue
      return result
    case 12:
      let result = d.receiveDMA(control(13) != 0 ? nil : buffer(0).advanced(by: Int(control(14))))
        .rawValue
      return result
    case 13:
      let result = d.autoPolling(
        configurationXSPIAutoPollingConfiguration(), b, getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 14:
      let result = d.autoPollingInterrupt(
        configurationXSPIAutoPollingConfiguration(), getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 15:
      let result = d.memoryMapped(
        configurationXSPIMemoryMappedConfiguration(), getTick: { CXSPI_TickFor(self.state) }
      ).rawValue
      return result
    case 16:
      let result = d.isMemoryMapped()
      return result
    case 17:
      let result = d.registerCallback(
        a, b == 0 ? nil : unsafeBitCast(CXSPI_Callback(a < 12 ? a : 0, b), to: XSPICallback.self)
      ).rawValue
      return result
    case 18:
      let result = d.unregisterCallback(a).rawValue
      return result
    case 19:
      let result = d.abort(getTick: { CXSPI_TickFor(self.state) }).rawValue
      return result
    case 20:
      let result = d.abortInterrupt().rawValue
      return result
    case 21:
      let result = d.setFifoThreshold(a).rawValue
      return result
    case 22:
      let result = d.getFifoThreshold()
      return result
    case 23:
      let result = d.setMemoryType(a).rawValue
      return result
    case 24:
      let result = d.setDeviceSize(a).rawValue
      return result
    case 25:
      let result = d.setClockPrescaler(a).rawValue
      return result
    case 26:
      let result = d.setTimeout(b).rawValue
      return result
    case 27:
      let result = d.getError()
      return result
    case 28:
      let result = d.getState()
      return result
    case 29:
      let result = d.configureManager(configurationXSPIManagerConfiguration(), b).rawValue
      return result
    case 30:
      var cfg = configurationXSPICalibrationConfiguration()
      let result = d.getDelayValue(&cfg).rawValue
      setConfig(cfg)
      return result
    case 31:
      let result = d.setDelayValue(configurationXSPICalibrationConfiguration()).rawValue
      return result
    case 32:
      d.dmaComplete()
      return 0
    case 33:
      d.dmaHalfComplete()
      return 0
    case 34:
      d.dmaError()
      return 0
    case 35:
      d.dmaAbortComplete()
      return 0
    case 36:
      let result = d.waitOnFlag(a, b, c, control(18), getTick: { CXSPI_TickFor(self.state) })
        .rawValue
      return result
    case 37:
      let result = d.configureCommand(configurationXSPIRegularCommand()).rawValue
      return result
    case 38:
      var cfg = configurationXSPIManagerConfiguration()
      d.getManagerConfiguration(UInt8(truncatingIfNeeded: a), &cfg)
      setConfig(cfg)
      return 0
    case 39:
      d.enable()
      return 0
    case 40:
      d.disable()
      return 0
    case 41:
      d.enableInterrupts(a)
      return 0
    case 42:
      d.disableInterrupts(a)
      return 0
    case 43: return d.getFlag(a)
    case 44: return d.getInterruptSource(a)
    case 45:
      d.clearFlags(a)
      return 0
    case 46:
      d.resetHandleState()
      return 0
    default: preconditionFailure("Unknown XSPI test operation")
    }
  }
}
struct XSPIPair {
  let c: XSPIFixture
  let swift: XSPIFixture
  init(callbacks: Bool = true) {
    c = XSPIFixture(callbacks: callbacks)
    swift = XSPIFixture(callbacks: callbacks)
  }
  func setup(_ body: (XSPIFixture) -> Void) {
    body(c)
    body(swift)
  }
  func verify(
    _ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ d: UInt32 = 0, file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let expected = CXSPI_Run(c.state, op, a, b, d)
    XCTAssertEqual(swift.run(op, a, b, d), expected, "operation \(op)", file: file, line: line)
    let difference = CXSPI_Compare(c.state, swift.state)
    XCTAssertEqual(
      difference, 0, "operation \(op) difference \(String(difference,radix:16))", file: file,
      line: line)
  }
}

extension XSPIFixture {
  func setting(_ d: UARTDMADirection, _ index: UInt32) -> UInt32 {
    CXSPI_Get(state, d == .transmit ? 3 : 4, index)
  }
  func setting(_ d: UARTDMADirection, _ index: UInt32, _ value: UInt32) {
    CXSPI_Set(state, d == .transmit ? 3 : 4, index, value)
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
    return CXSPI_Get(state, d == .transmit ? 5 : 6, (address - 0x2000) / 4)
  }
  func writeMemory32(_ d: UARTDMADirection, at address: UInt32, value: UInt32) {
    precondition(address >= 0x2000 && address < 0x2020)
    CXSPI_Set(state, d == .transmit ? 5 : 6, (address - 0x2000) / 4, value)
  }
  func callback(_ kind: XSPIDMACallbackKind) -> DMACallback { XSPINoDMA().callback(kind) }
  func writeCallback(_ d: UARTDMADirection, id: DMACallbackID, value: DMACallback?) {
    var index: UInt32 = 0
    if let value {
      for kind in XSPIDMACallbackKind.allCases {
        if unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) {
          index = kind.rawValue + 1
        }
      }
      precondition(index != 0)
    }
    CXSPI_Set(state, d == .transmit ? 9 : 10, id.rawValue, index)
  }
  func startInterrupt(
    _ d: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus {
    HALStatus(
      rawValue: CXSPI_RecordDMA(
        state, d == .transmit ? 0 : 1, 0, sourceAddress, destinationAddress, sourceDataSize))!
  }
  func startLinkedListInterrupt(_ d: UARTDMADirection) -> HALStatus {
    HALStatus(rawValue: CXSPI_RecordDMA(state, d == .transmit ? 0 : 1, 1, 0, 0, 0))!
  }
  func abort(_ d: UARTDMADirection, getTick: () -> UInt32) -> HALStatus {
    HALStatus(rawValue: CXSPI_RecordDMA(state, d == .transmit ? 0 : 1, 2, 0, 0, 0))!
  }
  func abortInterrupt(_ d: UARTDMADirection) -> HALStatus {
    _ = CXSPI_RecordDMA(state, d == .transmit ? 0 : 1, 3, 0, 0, 0)
    let id = CXSPI_Get(state, d == .transmit ? 9 : 10, 3)
    if setting(d, 11) != 0 && id != 0 {
      driver.dmaCallback(
        XSPIDMACallbackKind(rawValue: id - 1)!)
    }
    return HALStatus(rawValue: setting(d, 10))!
  }
}
extension XSPIFixture {
  func readConfiguration(_ d: UARTDMADirection, word: XSPIDMAConfigurationWord) -> UInt32 {
    switch word {
    case .destinationDataWidth: return setting(d, 14)
    case .direction: return setting(d, 16)
    case .sourceIncrement: return setting(d, 17)
    case .destinationIncrement: return setting(d, 18)
    }
  }
}
