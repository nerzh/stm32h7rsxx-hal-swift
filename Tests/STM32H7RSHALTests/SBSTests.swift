import XCTest
@testable import STM32H7RSHAL

private enum SBSTestAccess: Equatable {
  case read(SBSRegister, UInt32)
  case write(SBSRegister, UInt32)
}
private final class SBSTestIO: SBSRegisterIO {
  var values: [SBSRegister: UInt32] = [:]
  var trace: [SBSTestAccess] = []
  func read(_ register: SBSRegister) -> UInt32 {
    let value = values[register, default: 0]
    trace.append(.read(register, value))
    return value
  }
  func write(_ register: SBSRegister, value: UInt32) {
    trace.append(.write(register, value)); values[register] = value
  }
}

final class SBSTests: XCTestCase {
  func testSecurityKeysAndRawStatusMasks() {
    let io = SBSTestIO(), original: UInt32 = 0xA5C39F72
    let sbs = SBS(registers: io)
    let cases: [(SBSRegister, UInt32, UInt32, () -> Void)] = [
      (.hdplcr, 0xFF, 0x6A, { sbs.incrementHDPLValue() }),
      (.dbgcr, 0xFF, 0xB4, { sbs.openAccessPort() }),
      (.dbgcr, 0xFF00, 0xB400, { sbs.openDebug() }),
      (.dbglockr, 0xFF, 0xB4, { sbs.unlockDebugConfiguration() }),
      (.dbglockr, 0xFF, 0xC3, { sbs.lockDebugConfiguration() })
    ]
    for (register, clear, set, operation) in cases {
      io.values[register] = original; io.trace = []
      operation()
      XCTAssertEqual(io.trace, [.read(register, original), .write(register, (original & ~clear) | set)])
    }
    io.values[.bootsr] = original; io.values[.hdplsr] = original; io.values[.dbgcr] = original
    io.trace = []
    XCTAssertEqual(sbs.getBootAddress(), original)
    XCTAssertEqual(sbs.getHDPLValue(), 0x72)
    XCTAssertEqual(sbs.getDebugLevel(), 0xC3)
    XCTAssertEqual(io.trace, [.read(.bootsr, original), .read(.hdplsr, original), .read(.dbgcr, original)])
  }

  func testDebugLevelZeroRejectsWithoutIOAndOtherLevelsPreserveFields() {
    let io = SBSTestIO()
    let sbs = SBS(registers: io)
    let driver = SBS(registers: io)
    XCTAssertEqual(sbs.configureDebugLevel(SBSHDPL.level0.rawValue), .error)
    XCTAssertTrue(sbs.registers.trace.isEmpty)
    for level: UInt32 in [0x51, 0x8A, 0x6F] {
      io.values[.dbgcr] = .max; io.trace = []
      XCTAssertEqual(driver.configureDebugLevel(level), .ok)
      XCTAssertEqual(io.trace, [.read(.dbgcr, .max), .write(.dbgcr, 0xFF00FFFF | (level << 16))])
    }
  }

  func testRSSCommandRetainsUnmaskedHighInputBits() {
    let io = SBSTestIO(), original: UInt32 = 0x1200ABCD
    let sbs = SBS(registers: io)
    for command: UInt32 in [0, 1, 0xFFFF, 0x80001234, .max] {
      io.values[.rsscmdr] = original; io.trace = []
      sbs.configureRSSCommand(command)
      let expected = 0x12000000 | command
      XCTAssertEqual(io.trace, [.read(.rsscmdr, original), .write(.rsscmdr, expected)])
      XCTAssertEqual(sbs.getRSSCommand(), command & 0xFFFF)
    }
  }

  func testAnalogSupplySelectionsAreMutuallyExclusiveAndDisableIsIndependent() {
    let io = SBSTestIO()
    let driver = SBS(registers: io)
    let cases: [(UInt32, UInt32, () -> Void)] = [
      (0x300, 0x100, { driver.enableIOAnalogBooster() }),
      (0x100, 0, { driver.disableIOAnalogBooster() }),
      (0x300, 0x200, { driver.enableIOAnalogSwitchVDD() }),
      (0x200, 0, { driver.disableIOAnalogSwitchVDD() })
    ]
    for seed: UInt32 in [0, 0x100, 0x200, .max] {
      for (clear, set, operation) in cases {
        io.values[.pmcr] = seed; io.trace = []; operation()
        XCTAssertEqual(io.trace, [.read(.pmcr, seed), .write(.pmcr, (seed & ~clear) | set)])
      }
    }
  }

  func testEthernetAndAXISRAMSettingsPreserveOtherPMCRBits() {
    let io = SBSTestIO(), seed: UInt32 = .max
    let sbs = SBS(registers: io)
    for phy in SBSEthernetPHY.allCases {
      io.values[.pmcr] = seed; io.trace = []; sbs.configureEthernetPHY(phy.rawValue)
      XCTAssertEqual(io.trace, [.read(.pmcr, seed), .write(.pmcr, 0xFF1FFFFF | phy.rawValue)])
    }
    for wait in SBSAXISRAMWaitState.allCases {
      io.values[.pmcr] = seed; io.trace = []; sbs.configureAXISRAMWaitState(wait.rawValue)
      XCTAssertEqual(io.trace, [.read(.pmcr, seed), .write(.pmcr, 0xEFFFFFFF | wait.rawValue)])
    }
  }

  func testCompensationEnableDisableReadyAndSpeedSelection() {
    let io = SBSTestIO(), seed: UInt32 = 0xA5A5A5A5
    let sbs = SBS(registers: io)
    for cell in SBSCompensationCell.allCases {
      io.values[.cccsr] = seed; io.trace = []
      sbs.enableCompensationCell(cell.rawValue); sbs.disableCompensationCell(cell.rawValue)
      XCTAssertEqual(io.trace, [.read(.cccsr, seed), .write(.cccsr, seed | cell.rawValue),
        .read(.cccsr, seed | cell.rawValue), .write(.cccsr, seed & ~cell.rawValue)])
    }
    for cell in SBSCompensationCellReady.allCases {
      for seed: UInt32 in [0, cell.rawValue, ~cell.rawValue, .max] {
        io.values[.cccsr] = seed; io.trace = []
        XCTAssertEqual(sbs.getCompensationCellReadyStatus(cell.rawValue), seed & cell.rawValue == 0 ? 0 : 1)
        XCTAssertEqual(io.trace, [.read(.cccsr, seed)])
      }
    }
    for selection in SBSIOSpeedOptimization.allCases {
      io.values[.cccsr] = seed; io.trace = []
      sbs.enableIOSpeedOptimization(selection.rawValue); sbs.disableIOSpeedOptimization(selection.rawValue)
      XCTAssertEqual(io.trace, [.read(.cccsr, seed), .write(.cccsr, seed | selection.rawValue),
        .read(.cccsr, seed | selection.rawValue), .write(.cccsr, seed & ~selection.rawValue)])
    }
  }

  func testCompensationRegisterCodesAllNibblesAndWriteOrdering() {
    let io = SBSTestIO()
    let sbs = SBS(registers: io)
    let driver = SBS(registers: io)
    let configurations: [(UInt32, UInt32, UInt32)] = [(1, 0, 2), (4, 8, 8), (16, 16, 32)]
    for (selection, offset, codeBit) in configurations {
      for nmos in UInt32(0)..<16 {
        for pmos in UInt32(0)..<16 {
          io.values[.cccsr] = 0x5A5A5A5A; io.values[.ccswvalr] = 0xA5A5A5A5; io.trace = []
          driver.configureCompensationCell(selection, code: 1, nmosValue: nmos, pmosValue: pmos)
          let expected = (UInt32(0xA5A5A5A5) & ~(0xFF << offset)) | (nmos << offset) | (pmos << (offset + 4))
          XCTAssertEqual(io.trace, [.read(.ccswvalr, 0xA5A5A5A5), .write(.ccswvalr, expected),
            .read(.cccsr, 0x5A5A5A5A), .write(.cccsr, 0x5A5A5A5A | codeBit)])
        }
      }
    }
    // Cell-selected values do not validate or use the NMOS/PMOS arguments.
    for selection: UInt32 in [1, 4, 16] {
      sbs.registers.values[.cccsr] = .max; sbs.registers.trace = []
      sbs.configureCompensationCell(selection, code: 0, nmosValue: .max, pmosValue: .max)
      XCTAssertEqual(sbs.registers.trace, [.read(.cccsr, .max), .write(.cccsr, ~(selection << 1))])
    }
  }

  func testCompensationGetterNullOutputsLeaveAllStorageUntouched() {
    let io = SBSTestIO()
    let driver = SBS(registers: io)
    let storage = UnsafeMutablePointer<UInt32>.allocate(capacity: 3)
    storage.initialize(repeating: 0, count: 3)
    defer { storage.deinitialize(count: 3); storage.deallocate() }
    for nulls in 1..<8 {
      for index in 0..<3 { storage[index] = 0xA5A5A5A5 }; io.trace = []
      XCTAssertEqual(driver.getCompensationCell(0xFFFFFFFF,
        code: nulls & 1 != 0 ? nil : storage,
        nmosValue: nulls & 2 != 0 ? nil : storage + 1,
        pmosValue: nulls & 4 != 0 ? nil : storage + 2), .error)
      XCTAssertEqual(Array(UnsafeBufferPointer(start: storage, count: 3)), [0xA5A5A5A5, 0xA5A5A5A5, 0xA5A5A5A5])
      XCTAssertTrue(io.trace.isEmpty)
    }
  }

  func testCompensationGetterAliasingAndRawSelection() {
    let io = SBSTestIO()
    let driver = SBS(registers: io)
    let storage = UnsafeMutablePointer<UInt32>.allocate(capacity: 3)
    storage.initialize(repeating: 0, count: 3)
    defer { storage.deinitialize(count: 3); storage.deallocate() }
    for selection: UInt32 in [0, 1, 4, 16, 5, 0x80000000, .max] {
      for software in [false, true] {
        io.values[.cccsr] = software ? .max : 0
        io.values[.ccvalr] = 0x00A1B2C3; io.values[.ccswvalr] = 0x004D5E6F
        for codeIndex in 0..<3 { for nmosIndex in 0..<3 { for pmosIndex in 0..<3 {
          for index in 0..<3 { storage[index] = 0xEE }; io.trace = []
          let code: UInt32 = software && selection << 1 != 0 ? 1 : 0
          let value: UInt32 = code == 0 ? 0x00A1B2C3 : 0x004D5E6F
          let offset: UInt32 = selection == 1 ? 0 : selection == 4 ? 8 : 16
          var expected: [UInt32] = [0xEE, 0xEE, 0xEE]
          expected[codeIndex] = code; expected[nmosIndex] = (value >> offset) & 15
          expected[pmosIndex] = (value >> (offset + 4)) & 15
          XCTAssertEqual(driver.getCompensationCell(selection, code: storage + codeIndex,
            nmosValue: storage + nmosIndex, pmosValue: storage + pmosIndex), .ok)
          XCTAssertEqual(Array(UnsafeBufferPointer(start: storage, count: 3)), expected)
          XCTAssertEqual(io.trace, [.read(.cccsr, software ? .max : 0),
            .read(code == 0 ? .ccvalr : .ccswvalr, value)])
        } } }
      }
    }
  }

  func testTimerBreakAllValidSubsetsAccumulateAndGetterMasks() {
    let io = SBSTestIO()
    let sbs = SBS(registers: io)
    let driver = SBS(registers: io)
    let bits: [UInt32] = [4, 8, 0x40, 0x80, 0x2000, 0x4000, 0x200000, 0x800000]
    for subset in 1..<256 {
      var input: UInt32 = 0
      for index in 0..<8 where subset & (1 << index) != 0 { input |= bits[index] }
      io.values[.bklockr] = 0x55000001; io.trace = []
      driver.configureTimerBreakInput(input)
      XCTAssertEqual(io.trace, [.read(.bklockr, 0x55000001), .write(.bklockr, 0x55000001 | input)])
      XCTAssertEqual(driver.getTimerBreakInputConfiguration(), input)
    }
    sbs.registers.values[.bklockr] = .max
    XCTAssertEqual(sbs.getTimerBreakInputConfiguration(), 0x00A060CC)
  }

  func testEXTIAllLinesAndGPIOPortsPreserveOtherNibbles() {
    let io = SBSTestIO(), seed: UInt32 = 0xA5C39F72
    let sbs = SBS(registers: io)
    for line in UInt32(0)..<16 { for port in GPIOPort.allCases {
      let register = SBSRegister.extiConfiguration(index: Int(line / 4))
      let offset = 4 * (line % 4)
      io.values[register] = seed; io.trace = []
      sbs.configureEXTI(line, port: port)
      let expected = (seed & ~(0xF << offset)) | (port.rawValue << offset)
      XCTAssertEqual(io.trace, [.read(register, seed), .write(register, expected)])
      XCTAssertEqual(sbs.getEXTIConfiguration(line), port.rawValue)
    } }
    io.values[.extiConfiguration(index: 0)] = 0xBA98
    XCTAssertEqual(sbs.getEXTIConfiguration(0), 8)
    XCTAssertEqual(sbs.getEXTIConfiguration(1), 9)
  }

  func testFPUMacrosAcceptExtraBitsAndMemoryEraseStatusIsRawMask() {
    let io = SBSTestIO()
    let sbs = SBS(registers: io)
    let driver = SBS(registers: io)
    for known in UInt32(1)..<64 { for extra: UInt32 in [0, 0x80000000, 0xFFFFFFC0] {
      let mask = known | extra
      io.values[.fpuimr] = 0x5A5A5A5A; io.trace = []
      driver.enableFPUInterrupts(mask); driver.disableFPUInterrupts(mask)
      XCTAssertEqual(io.trace, [.read(.fpuimr, 0x5A5A5A5A), .write(.fpuimr, 0x5A5A5A5A | mask),
        .read(.fpuimr, 0x5A5A5A5A | mask), .write(.fpuimr, 0x5A5A5A5A & ~mask)])
    } }
    for value: UInt32 in [0, 1, 2, .max] {
      sbs.registers.values[.mesr] = value; sbs.registers.trace = []
      XCTAssertEqual(sbs.getMemoryEraseStatus(), value & 1)
      XCTAssertEqual(sbs.registers.trace, [.read(.mesr, value)])
    }
  }
}
