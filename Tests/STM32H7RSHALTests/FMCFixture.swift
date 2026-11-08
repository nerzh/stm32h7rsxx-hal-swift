import CFMCReference
import STM32H7RSHAL
import XCTest

final class FMCFixture: FMCRegisterIO {
  let allocation: UnsafeMutableRawPointer
  let state: OpaquePointer
  init() {
    allocation = .allocate(byteCount: CFMC_Size(), alignment: 16)
    state = OpaquePointer(allocation)
    CFMC_Reset(state)
  }
  deinit { allocation.deallocate() }
  func get(_ group: UInt32, _ index: UInt32) -> UInt32 { CFMC_Get(state, group, index) }
  func set(_ group: UInt32, _ index: UInt32, _ value: UInt32) {
    CFMC_Set(state, group, index, value)
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
  func read(_ register: FMCRegister) -> UInt32 { CFMC_Read(state, offset(register)) }
  func write(_ register: FMCRegister, value: UInt32) { CFMC_Write(state, offset(register), value) }
  var driver: FMC<FMCFixture> { .init(registers: self) }
  func run(_ operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0) -> UInt32 {
    CFMC_Activate(state)
    var v0 = FMCNORSRAMConfiguration(
      bank: get(1, 0), dataAddressMux: get(1, 1), memoryType: get(1, 2), memoryDataWidth: get(1, 3),
      burstAccessMode: get(1, 4), waitSignalPolarity: get(1, 5), waitSignalActive: get(1, 6),
      writeOperation: get(1, 7), waitSignal: get(1, 8), extendedMode: get(1, 9),
      asynchronousWait: get(1, 10), writeBurst: get(1, 11), continuousClock: get(1, 12),
      writeFIFO: get(1, 13), pageSize: get(1, 14))
    var v1 = FMCNORSRAMTiming(
      addressSetupTime: get(2, 0), addressHoldTime: get(2, 1), dataSetupTime: get(2, 2),
      busTurnAroundDuration: get(2, 3), clockDivision: get(2, 4), dataLatency: get(2, 5),
      accessMode: get(2, 6))
    var v2 = FMCNANDConfiguration(
      bank: get(3, 0), waitFeature: get(3, 1), memoryDataWidth: get(3, 2),
      eccComputation: get(3, 3), eccPageSize: get(3, 4), tclrSetupTime: get(3, 5),
      tarSetupTime: get(3, 6))
    var v3 = FMCNANDTiming(
      setupTime: get(4, 0), waitSetupTime: get(4, 1), holdSetupTime: get(4, 2),
      hiZSetupTime: get(4, 3))
    var v4 = FMCSDRAMConfiguration(
      bank: get(5, 0), columnBitsNumber: get(5, 1), rowBitsNumber: get(5, 2),
      memoryDataWidth: get(5, 3), internalBankNumber: get(5, 4), casLatency: get(5, 5),
      writeProtection: get(5, 6), sdClockPeriod: get(5, 7), readBurst: get(5, 8),
      readPipeDelay: get(5, 9))
    var v5 = FMCSDRAMTiming(
      loadToActiveDelay: get(6, 0), exitSelfRefreshDelay: get(6, 1), selfRefreshTime: get(6, 2),
      rowCycleDelay: get(6, 3), writeRecoveryTime: get(6, 4), rpDelay: get(6, 5),
      rcdDelay: get(6, 6))
    var v6 = FMCSDRAMCommand(
      commandMode: get(7, 0), commandTarget: get(7, 1), autoRefreshNumber: get(7, 2),
      modeRegisterDefinition: get(7, 3))
    switch operation {
    case 0:
      return withUnsafePointer(to: &v0) { p in
        driver.initializeNORSRAM(get(8, 9) != 0 ? nil : p).rawValue
      }
    case 1:
      return driver.deinitializeNORSRAM(a).rawValue
    case 2:
      return withUnsafePointer(to: &v1) { p in
        driver.configureNORSRAMTiming(get(8, 9) != 0 ? nil : p, a).rawValue
      }
    case 3:
      return withUnsafePointer(to: &v1) { p in
        driver.configureNORSRAMExtendedTiming(get(8, 9) != 0 ? nil : p, a, b).rawValue
      }
    case 4:
      return driver.enableNORSRAMWrite(a).rawValue
    case 5:
      return driver.disableNORSRAMWrite(a).rawValue
    case 6:
      return withUnsafePointer(to: &v2) { p in
        driver.initializeNAND(get(8, 9) != 0 ? nil : p).rawValue
      }
    case 7:
      return withUnsafePointer(to: &v3) { p in
        driver.configureNANDCommonSpaceTiming(get(8, 9) != 0 ? nil : p, a).rawValue
      }
    case 8:
      return withUnsafePointer(to: &v3) { p in
        driver.configureNANDAttributeSpaceTiming(get(8, 9) != 0 ? nil : p, a).rawValue
      }
    case 9:
      return driver.deinitializeNAND(a).rawValue
    case 10:
      return driver.enableNANDECC(a).rawValue
    case 11:
      return driver.disableNANDECC(a).rawValue
    case 12:
      return driver.getNANDECC(CFMC_Output(state), a, b, getTick: { CFMC_TickFor(self.state) })
        .rawValue
    case 13:
      return withUnsafePointer(to: &v4) { p in
        driver.initializeSDRAM(get(8, 9) != 0 ? nil : p).rawValue
      }
    case 14:
      return withUnsafePointer(to: &v5) { p in
        driver.configureSDRAMTiming(get(8, 9) != 0 ? nil : p, a).rawValue
      }
    case 15:
      return driver.deinitializeSDRAM(a).rawValue
    case 16:
      return driver.enableSDRAMWriteProtection(a).rawValue
    case 17:
      return driver.disableSDRAMWriteProtection(a).rawValue
    case 18:
      return withUnsafePointer(to: &v6) { p in
        driver.sendSDRAMCommand(get(8, 9) != 0 ? nil : p, a).rawValue
      }
    case 19:
      return driver.programSDRAMRefreshRate(a).rawValue
    case 20:
      return driver.setSDRAMAutoRefreshNumber(a).rawValue
    case 21:
      return driver.getSDRAMModeStatus(a)
    case 22:
      driver.enable()
      return 0
    case 23:
      driver.disable()
      return 0
    case 24:
      driver.enableNORSRAM(a)
      return 0
    case 25:
      driver.disableNORSRAM(a)
      return 0
    case 26:
      driver.enableNAND()
      return 0
    case 27:
      driver.disableNAND()
      return 0
    case 28:
      driver.enableNANDInterrupts(a)
      return 0
    case 29:
      driver.disableNANDInterrupts(a)
      return 0
    case 30: return driver.getNANDFlag(a) ? 1 : 0
    case 31:
      driver.clearNANDFlag(a)
      return 0
    case 32:
      driver.enableSDRAMInterrupts(a)
      return 0
    case 33:
      driver.disableSDRAMInterrupts(a)
      return 0
    case 34: return driver.getSDRAMFlag(a) ? 1 : 0
    case 35:
      driver.clearSDRAMFlag(a)
      return 0
    default: preconditionFailure("Unknown operation")
    }
  }
}
func checkFMC(
  _ setup: (FMCFixture) -> Void, operation: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0,
  _ c: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line
) {
  let reference = FMCFixture()
  let swift = FMCFixture()
  setup(reference)
  setup(swift)
  let expected = CFMC_Run(reference.state, operation, a, b, c)
  XCTAssertEqual(swift.run(operation, a, b, c), expected, file: file, line: line)
  let difference = CFMC_Compare(reference.state, swift.state)
  if difference != 0 {
    let g = (difference >> 16) - 1
    let i = difference & 0xFFFF
    XCTFail(
      "operation \(operation), difference \(String(difference,radix:16)), C \(reference.get(g,i)), Swift \(swift.get(g,i))",
      file: file, line: line)
  }
}
