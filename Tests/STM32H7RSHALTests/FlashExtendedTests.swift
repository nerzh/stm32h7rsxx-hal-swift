import XCTest
@testable import STM32H7RSHAL

private enum FlashExtendedAccess: Equatable {
  case read(FlashRegister), write(FlashRegister, UInt32)
  case processRead(FlashProcessWord), processWrite(FlashProcessWord, UInt32)
  case memoryRead(UInt32), memoryWrite(UInt32, UInt32), tick(UInt32), callback
}
private func flashExtendedECCCallback(_ context: UnsafeMutableRawPointer?) {
  let io = Unmanaged<FlashExtendedIO>.fromOpaque(context!).takeUnretainedValue()
  io.trace.append(.callback)
  io.callbackFlags.append(io.registers[.isr, default: 0])
  io.onCallback?()
}
private final class FlashExtendedIO: FlashRegisterIO, FlashProcessIO, FlashMemoryIO {
  var registers: [FlashRegister: UInt32] = [:]
  var words: [FlashProcessWord: UInt32] = [:]
  var memory: [UInt32: UInt32] = [:]
  var trace: [FlashExtendedAccess] = []
  var scripts: [FlashRegister: [UInt32]] = [:]
  var onWrite: ((FlashRegister, UInt32) -> Void)?
  var onRead: ((FlashRegister) -> Void)?
  var onTick: ((UInt32) -> Void)?
  var onCallback: (() -> Void)?
  var callbackFlags: [UInt32] = []
  var tick: UInt32 = 0
  var tickStep: UInt32 = 1
  var flash: Flash<FlashExtendedIO, FlashExtendedIO, FlashExtendedIO> {
    .init(registers: self, process: self, memory: self,
      callbacks: .init(context: Unmanaged.passUnretained(self).toOpaque(), eccDetection: flashExtendedECCCallback))
  }
  var registerTrace: [FlashExtendedAccess] {
    trace.filter { switch $0 { case .read, .write: return true; default: return false } }
  }
  var writes: [FlashExtendedAccess] { trace.filter { if case .write = $0 { return true }; return false } }
  func valuesWritten(to register: FlashRegister) -> [UInt32] {
    trace.compactMap { if case let .write(r, value) = $0, r == register { return value }; return nil }
  }
  func read(_ register: FlashRegister) -> UInt32 {
    trace.append(.read(register)); onRead?(register)
    if scripts[register]?.isEmpty == false { return scripts[register]!.removeFirst() }
    return registers[register, default: 0]
  }
  func write(_ register: FlashRegister, value: UInt32) {
    trace.append(.write(register, value)); registers[register] = value
    if register == .icr { registers[.isr, default: 0] &= ~value }
    if register == .opticr { registers[.optisr, default: 0] &= ~value }
    onWrite?(register, value)
  }
  func read(_ register: FlashTimingRegister) -> UInt32 { 0 }
  func write(_ register: FlashTimingRegister, value: UInt32) { XCTFail("Unexpected ACR access") }
  func read(_ word: FlashProcessWord) -> UInt32 { trace.append(.processRead(word)); return words[word, default: 0] }
  func write(_ word: FlashProcessWord, value: UInt32) { trace.append(.processWrite(word, value)); words[word] = value }
  func read32(at address: UInt32) -> UInt32 { trace.append(.memoryRead(address)); return memory[address, default: 0] }
  func write32(at address: UInt32, value: UInt32) { trace.append(.memoryWrite(address, value)); memory[address] = value }
  func read8(at address: UInt32) -> UInt8 { XCTFail("Unexpected byte access"); return 0 }
  func read16(at address: UInt32) -> UInt16 { XCTFail("Unexpected halfword access"); return 0 }
  func write8(at address: UInt32, value: UInt8) { XCTFail("Unexpected byte access") }
  func write16(at address: UInt32, value: UInt16) { XCTFail("Unexpected halfword access") }
  func getPRIMASK() -> UInt32 { XCTFail("Unexpected PRIMASK access"); return 0 }
  func disableIRQ() { XCTFail("Unexpected IRQ masking") }
  func setPRIMASK(_ value: UInt32) { XCTFail("Unexpected PRIMASK access") }
  func instructionSynchronizationBarrier() { XCTFail("Unexpected barrier") }
  func dataSynchronizationBarrier() { XCTFail("Unexpected barrier") }
  func getTick() -> UInt32 {
    let value = tick; tick &+= tickStep; trace.append(.tick(value)); onTick?(value); return value
  }
}

final class FlashExtendedTests: XCTestCase {
  func testMassEraseKeepsSectorOutputAndUsesExactLockAndMMIOOrder() {
    let io = FlashExtendedIO(); io.registers[.cr] = 0xA501_01C2; io.words[.errorCode] = .max
    var sectorError: UInt32 = 0x1234
    XCTAssertEqual(io.flash.erase(.init(typeErase: 8), sectorError: &sectorError, getTick: io.getTick), .ok)
    XCTAssertEqual(sectorError, 0x1234)
    XCTAssertEqual(io.trace, [
      .processRead(.lock), .processWrite(.lock, 1), .processWrite(.errorCode, 0), .tick(0),
      .read(.sr), .read(.isr), .read(.optisr), .read(.isr),
      .read(.cr), .write(.cr, 0xA501_01EA), .tick(1),
      .read(.sr), .read(.isr), .read(.optisr), .read(.isr),
      .read(.cr), .write(.cr, 0xA501_0022), .processWrite(.lock, 0)])
  }

  func testSectorEraseStopsAtFirstErrorAndCleansSelection() {
    let io = FlashExtendedIO(); io.registers[.cr] = 0x9000_0002
    var starts = 0
    io.onWrite = { register, value in
      if register == .cr && value & 0x24 == 0x24 {
        starts += 1
        if starts == 2 { io.registers[.isr] = 0x0002_0000 }
      }
    }
    var failed: UInt32 = 123
    XCTAssertEqual(io.flash.erase(.init(sector: 2, sectorCount: 4), sectorError: &failed, getTick: io.getTick), .error)
    XCTAssertEqual(failed, 3); XCTAssertEqual(starts, 2)
    XCTAssertEqual(io.valuesWritten(to: .cr), [0x9000_00A6, 0x9000_00E6, 0x9000_0022])
    XCTAssertEqual(io.words[.errorCode], 0x0002_0000); XCTAssertEqual(io.words[.lock], 0)
    XCTAssertEqual(io.valuesWritten(to: .icr), [0x0002_0000])
    XCTAssertEqual(io.valuesWritten(to: .opticr), [0])
  }

  func testZeroSectorCountPreservesCEmptyLoop() {
    let io = FlashExtendedIO(); io.registers[.cr] = .max
    var failed: UInt32 = 0
    XCTAssertEqual(io.flash.erase(.init(sector: 7, sectorCount: 0), sectorError: &failed, getTick: io.getTick), .ok)
    XCTAssertEqual(failed, .max)
    XCTAssertEqual(io.valuesWritten(to: .cr), [0xFFFF_FE3B])
  }

  func testInitialWaitTimeoutDoesNotStartOrChangeOutput() {
    let io = FlashExtendedIO(); io.registers[.sr] = 4; io.tick = .max - 500; io.tickStep = 1001
    var failed: UInt32 = 91
    XCTAssertEqual(io.flash.erase(.init(), sectorError: &failed, getTick: io.getTick), .timeout)
    XCTAssertEqual(failed, 91); XCTAssertEqual(io.writes, [])
    XCTAssertEqual(io.words[.errorCode], 0); XCTAssertEqual(io.words[.lock], 0)
  }

  func testEraseInterruptStoresProcessBeforeStartingAndRetainsLock() {
    let io = FlashExtendedIO(); io.registers[.ier] = 0x8000_0001
    XCTAssertEqual(io.flash.eraseInterrupt(.init(sector: 6, sectorCount: 2), getTick: io.getTick), .ok)
    XCTAssertEqual(Array(io.trace.suffix(7)), [.processWrite(.procedure, 4),
      .read(.ier), .write(.ier, 0x802F_0001), .processWrite(.sectorsRemaining, 2),
      .processWrite(.sector, 6), .read(.cr), .write(.cr, 0x1A4)])
    XCTAssertEqual(io.words[.lock], 1)
    let mass = FlashExtendedIO(); mass.words[.sector] = 5; mass.words[.sectorsRemaining] = 7
    XCTAssertEqual(mass.flash.eraseInterrupt(.init(typeErase: 8), getTick: mass.getTick), .ok)
    XCTAssertEqual(mass.words[.sector], 5); XCTAssertEqual(mass.words[.sectorsRemaining], 7)
    XCTAssertEqual(mass.words[.procedure], 8); XCTAssertEqual(mass.words[.lock], 1)
  }

  func testExtendedSoftwareLockRejectsWithoutMutation() {
    let io = FlashExtendedIO(); io.words[.lock] = 1; io.words[.errorCode] = 23
    var output: UInt32 = 7
    XCTAssertEqual(io.flash.erase(.init(), sectorError: &output, getTick: io.getTick), .busy)
    XCTAssertEqual(io.flash.eraseInterrupt(.init(), getTick: io.getTick), .busy)
    XCTAssertEqual(io.flash.programOptionBytes(.init(), getTick: io.getTick), .busy)
    XCTAssertEqual(io.flash.configureOTPLock(0, getTick: io.getTick), .busy)
    XCTAssertEqual(io.flash.configureKey(.init(), keyAddress: 0, getTick: io.getTick), .busy)
    XCTAssertEqual(io.flash.getKey(.init(), outputAddress: nil, getTick: io.getTick), .busy)
    XCTAssertEqual(io.trace, Array(repeating: .processRead(.lock), count: 6))
    XCTAssertEqual(output, 7); XCTAssertEqual(io.words[.errorCode], 23)
  }

  func testOptionByteGroupsOrderAndUnrelatedBits() {
    let io = FlashExtendedIO()
    for r: FlashRegister in [.optcr, .wrpsrp, .obw1srp, .obw2srp, .hdpsrp, .nvsrp] { io.registers[r] = .max }
    let config = FlashOptionBytesConfiguration(optionType: 15, wrpState: 1, wrpSector: 0xFFFF_00A5,
      userType: 0x1FFF, userConfiguration1: 0, userConfiguration2: 0,
      hdpStartPage: 0x12, hdpEndPage: 0xAB, nvState: 0x51)
    XCTAssertEqual(io.flash.programOptionBytes(config, getTick: io.getTick), .ok)
    XCTAssertEqual(io.writes, [.write(.optcr, .max), .write(.wrpsrp, 0xFFFF_FF5A),
      .write(.obw1srp, 0xDFF9_FC23), .write(.obw2srp, 0xFFFF_FC88),
      .write(.hdpsrp, 0xFFAB_FF12), .write(.nvsrp, 0xFFFF_FF51), .write(.optcr, 0xFFFF_FFFD)])
    XCTAssertEqual(io.words[.lock], 0)
  }

  func testEveryUserSelectionOnlyChangesItsFieldAndRegister() {
    let fields: [(UInt32, FlashRegister, UInt32)] = [
      (1,.obw1srp,0xC),(2,.obw1srp,0x10),(4,.obw1srp,0x40),(8,.obw1srp,0x80),
      (0x10,.obw1srp,0x100),(0x20,.obw1srp,0x200),(0x40,.obw1srp,0x20000),
      (0x80,.obw1srp,0x40000),(0x100,.obw1srp,0x20000000),(0x200,.obw2srp,7),
      (0x400,.obw2srp,0x70),(0x800,.obw2srp,0x100),(0x1000,.obw2srp,0x200)]
    for (selection, register, mask) in fields {
      for input: UInt32 in [0, .max, 0xA5A5_A5A5] {
        let io = FlashExtendedIO(); io.registers[register] = 0x5A5A_5A5A
        let config = FlashOptionBytesConfiguration(optionType: 2, userType: selection,
          userConfiguration1: input, userConfiguration2: input)
        XCTAssertEqual(io.flash.programOptionBytes(config, getTick: io.getTick), .ok)
        XCTAssertEqual(io.writes, [.write(.optcr, 2),
          .write(register, (0x5A5A_5A5A & ~mask) | (input & mask)), .write(.optcr, 0)])
      }
    }
  }

  func testOptionTypeZeroAndWRPDisable() {
    let io = FlashExtendedIO()
    XCTAssertEqual(io.flash.programOptionBytes(.init(), getTick: io.getTick), .ok)
    XCTAssertEqual(io.writes, [])
    io.trace = []; io.registers[.wrpsrp] = 0x1234_5600
    XCTAssertEqual(io.flash.programOptionBytes(.init(optionType: 1, wrpState: 0, wrpSector: 0xFFFF_FFA5), getTick: io.getTick), .ok)
    XCTAssertEqual(io.valuesWritten(to: .wrpsrp), [0x1234_56A5])
  }

  func testOptionReadbackPreservesUnassignedFieldsAndUsesFreshReads() {
    let io = FlashExtendedIO(); io.registers[.wrpsr] = .max
    io.registers[.obw1sr] = 0x1234_5678; io.registers[.obw2sr] = .max
    io.scripts[.hdpsr] = [0xFF01_FF23, 0xFFAB_FF45]
    io.registers[.nvsr] = 0xFFFF_FFB4; io.registers[.rotsr] = .max; io.registers[.epochsr] = .max
    var config = FlashOptionBytesConfiguration(optionType: 123, wrpState: 44, wrpSector: 0xCAFE, userType: 456)
    io.flash.getOptionBytesConfiguration(&config)
    XCTAssertEqual(config, .init(optionType: 123, wrpState: 0, wrpSector: 0xCAFE, userType: 456,
      userConfiguration1: 0x1234_5678, userConfiguration2: .max, hdpStartPage: 0x23,
      hdpEndPage: 0xAB, nvState: 0xB4, rotConfiguration: 0xFF00_FFFF, epoch: 0x00FF_FFFF))
    XCTAssertEqual(io.registerTrace, [.read(.wrpsr), .read(.obw1sr), .read(.obw2sr), .read(.hdpsr),
      .read(.hdpsr), .read(.nvsr), .read(.rotsr), .read(.epochsr)])
    io.trace = []; io.scripts[.wrpsr] = [0, 0xFFFFFFA5]
    io.flash.getOptionBytesConfiguration(&config)
    XCTAssertEqual(config.wrpState, 1); XCTAssertEqual(config.wrpSector, 0x5A)
    XCTAssertEqual(Array(io.registerTrace.prefix(2)), [.read(.wrpsr), .read(.wrpsr)])
  }

  func testOTPLockOrderAndTimeoutCleanup() {
    let io = FlashExtendedIO(); io.registers[.cr] = 0x8000_0000; io.registers[.optcr] = 0x4000_0000
    io.registers[.otplsrp] = .max; io.tickStep = 1001
    io.onWrite = { register, _ in if register == .otplsrp { io.registers[.sr] = 4 } }
    XCTAssertEqual(io.flash.configureOTPLock(0xA55A, getTick: io.getTick), .timeout)
    XCTAssertEqual(io.writes, [.write(.cr, 0x8001_0000), .write(.optcr, 0x4000_0002),
      .write(.otplsrp, 0xFFFF_A55A), .write(.optcr, 0x4000_0000), .write(.cr, 0x8000_0000)])
    XCTAssertEqual(io.words[.lock], 0)
    io.registers[.otplsr] = 0xABCD_1234; XCTAssertEqual(io.flash.getOTPLock(), 0x1234)
  }

  func testKeyProgrammingAllSizesLevelsAndWordAccessOrder() {
    for (size, count): (UInt32, Int) in [(0,1),(0x400,2),(0x800,4),(0xC00,8)] {
      for level: UInt32 in [0, 0x100, 0x200] {
        let io = FlashExtendedIO(); io.registers[.obkcr] = .max; io.registers[.optcr] = 0x100
        for index in 0..<8 { io.memory[0x2400_0000 + UInt32(index)*4] = 0xA500_0000 + UInt32(index) }
        XCTAssertEqual(io.flash.configureKey(.init(index: 31, size: size, hdplLevel: level),
          keyAddress: 0x2400_0000, getTick: io.getTick), .ok)
        var words: [FlashExtendedAccess] = []
        for index in 0..<count { words += [.memoryRead(0x2400_0000 + UInt32(index)*4), .write(.obkdr(index: index), 0xA500_0000 + UInt32(index))] }
        let accesses = io.trace.filter { access in
          switch access { case .memoryRead: return true; case .write(.obkdr(index: _), _): return true; default: return false }
        }
        XCTAssertEqual(accesses, words)
        let control = (UInt32.max & ~UInt32(0xF1F)) | 31 | size | level
        XCTAssertEqual(io.valuesWritten(to: .obkcr), [control, control | 0xC000, (control | 0xC000) & ~UInt32(0x4000)])
        XCTAssertEqual(io.valuesWritten(to: .optcr), [0x102, 0x100]); XCTAssertEqual(io.words[.lock], 0)
      }
    }
  }

  func testGetKeyNilLoadsWithoutReadingAndSuccessfulReadsUseOnlySelectedWords() {
    for (size, count): (UInt32, Int) in [(0,1),(0x400,2),(0x800,4),(0xC00,8)] {
      for output: UInt32? in [nil, 0, 0x2400_1000] {
        let io = FlashExtendedIO(); io.registers[.obkcr] = .max
        for index in 0..<8 { io.registers[.obkdr(index: index)] = UInt32(index) + 0xAB00 }
        XCTAssertEqual(io.flash.getKey(.init(index: 7, size: size, hdplLevel: 0x100),
          outputAddress: output, getTick: io.getTick), .ok)
        let control = (UInt32.max & ~UInt32(0x4F1F)) | 7 | size | 0x100
        XCTAssertEqual(io.valuesWritten(to: .obkcr), [control, control | 0x8000])
        var expected: [FlashExtendedAccess] = []
        if let output, output != 0 { for index in 0..<count {
          expected += [.read(.obkdr(index: index)), .memoryWrite(output + UInt32(index)*4, UInt32(index) + 0xAB00)]
        } }
        XCTAssertEqual(io.trace.filter { switch $0 { case .read(.obkdr(index: _)), .memoryWrite: return true; default: return false } }, expected)
      }
    }
  }

  func testKeySecondWaitFailureStillClearsProgramControlsAndLeavesOutputUntouched() {
    for isRead in [false, true] {
      let io = FlashExtendedIO(); io.memory[0x2400_0000] = 0x1234
      io.onWrite = { register, value in
        if register == .obkcr && value & 0x8000 != 0 { io.registers[.isr] = 0x0004_0000 }
      }
      let status = isRead ? io.flash.getKey(.init(), outputAddress: 0x2400_0000, getTick: io.getTick)
        : io.flash.configureKey(.init(), keyAddress: 0x2400_0000, getTick: io.getTick)
      XCTAssertEqual(status, .error); XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(io.memory[0x2400_0000], 0x1234)
      XCTAssertEqual(io.registers[.optcr], 0)
      XCTAssertEqual(io.registers[.obkcr, default: 0] & 0x4000, 0)
      if isRead { XCTAssertFalse(io.trace.contains(.read(.obkdr(index: 0)))) }
    }
  }

  func testCRCModesBurstFieldsAndRegisterOrder() {
    for type: UInt32 in [0, 0x200, 0x0100_0200] {
      for burst in FlashCRCBurstSize.allCases {
        let io = FlashExtendedIO(); io.registers[.crccr] = 0x8000_0010
        io.registers[.cr] = 0x1234; io.registers[.crcdatar] = 0xDEAD_BEEF
        var result: UInt32 = 0
        XCTAssertEqual(io.flash.computeCRC(.init(typeCRC: type, burstSize: burst.rawValue, sector: 2,
          sectorCount: 2, startAddress: 0x0800_1234, endAddress: 0x0800_5678), result: &result, getTick: io.getTick), .ok)
        let initial: UInt32 = 0x8002_0010 | burst.rawValue
        var expected: [FlashExtendedAccess] = [.write(.cr, 0x0002_1234), .write(.icr, 0x1800_0000), .write(.crccr, initial)]
        if type == 0 {
          expected += [.write(.crccr, initial), .write(.crcsaddr, 0x1234), .write(.crceaddr, 0x5678), .write(.crccr, initial | 0x10000)]
        } else if type == 0x200 {
          expected += [.write(.crccr, initial | 0xA00), .write(.crccr, initial | 0xA02),
            .write(.crccr, initial | 0xE02), .write(.crccr, initial | 0xE03),
            .write(.crccr, initial | 0xE03), .write(.crccr, initial | 0x10E03)]
        } else { expected += [.write(.crccr, initial | 0x0100_0200), .write(.crccr, initial | 0x0101_0200)] }
        expected += [.write(.cr, 0x1234), .write(.icr, 0x1800_0000)]
        XCTAssertEqual(io.writes, expected); XCTAssertEqual(result, 0xDEAD_BEEF)
        XCTAssertEqual(io.words[.lock], 0)
        XCTAssertEqual(Array(io.trace.prefix(6)), [.tick(0), .read(.sr), .read(.isr), .read(.optisr), .read(.isr), .processRead(.lock)])
      }
    }
  }

  func testCRCWaitBeforeLockPreservesOutputAndExistingError() {
    let io = FlashExtendedIO(); io.words[.lock] = 1; io.words[.errorCode] = 0x10
    var result: UInt32 = 99
    XCTAssertEqual(io.flash.computeCRC(.init(), result: &result, getTick: io.getTick), .busy)
    XCTAssertEqual(result, 99); XCTAssertEqual(io.words[.errorCode], 0x10)
    XCTAssertEqual(io.writes, [])
    io.trace = []; io.registers[.isr] = 0x0002_0000
    XCTAssertEqual(io.flash.computeCRC(.init(), result: &result, getTick: io.getTick), .error)
    XCTAssertFalse(io.trace.contains(.processRead(.lock)))
    XCTAssertEqual(io.words[.lock], 1); XCTAssertEqual(io.words[.errorCode], 0x0002_0010)
  }

  func testCRCSecondWaitAlwaysReturnsResultAndCleansOnTimeoutOrError() {
    for failure in 0..<2 {
      let io = FlashExtendedIO(); io.tick = .max - 500; io.tickStep = 1001
      io.registers[.crcdatar] = 0xA55A_1234
      io.onWrite = { register, value in
        if register == .crccr && value & 0x10000 != 0 {
          if failure == 0 { io.registers[.sr] = 8 } else { io.registers[.isr] = 0x1800_0000 }
        }
      }
      var result: UInt32 = 0
      XCTAssertEqual(io.flash.computeCRC(.init(typeCRC: 0x0100_0200), result: &result, getTick: io.getTick), failure == 0 ? .timeout : .error)
      XCTAssertEqual(result, 0xA55A_1234); XCTAssertEqual(io.registers[.cr], 0); XCTAssertEqual(io.words[.lock], 0)
      XCTAssertEqual(Array(io.trace.suffix(5)), [.read(.crcdatar), .read(.cr), .write(.cr, 0), .write(.icr, 0x1800_0000), .processWrite(.lock, 0)])
      XCTAssertEqual(io.words[.errorCode], failure == 0 ? 0 : 0x1000_0000)
    }
  }

  func testCRCWaitStrictTimeoutWrapZeroAndFreshFlagReads() {
    let io = FlashExtendedIO(); io.tick = .max - 1; io.registers[.sr] = 8
    XCTAssertEqual(io.flash.waitForCRCOperation(timeout: 1, getTick: io.getTick), .timeout)
    XCTAssertEqual(io.trace, [.tick(.max - 1), .read(.sr), .tick(.max), .read(.sr), .tick(0)])
    io.trace = []; io.tick = 9
    XCTAssertEqual(io.flash.waitForCRCOperation(timeout: 0, getTick: io.getTick), .timeout)
    XCTAssertEqual(io.trace, [.tick(9), .read(.sr), .tick(10)])
    io.trace = []; io.registers[.sr] = 0; io.scripts[.isr] = [0, 0x0800_0000]
    XCTAssertEqual(io.flash.waitForCRCOperation(timeout: 0, getTick: io.getTick), .ok)
    XCTAssertEqual(Array(io.trace.suffix(3)), [.read(.isr), .read(.isr), .write(.icr, 0x0800_0000)])
    io.trace = []; io.words[.errorCode] = 7; io.registers[.isr] = 0x1800_0000
    XCTAssertEqual(io.flash.waitForCRCOperation(timeout: .max, getTick: io.getTick), .error)
    XCTAssertEqual(io.words[.errorCode], 0x1000_0007)
    XCTAssertEqual(io.valuesWritten(to: .icr), [0x1000_0000])
    XCTAssertEqual(io.registers[.isr], 0x0800_0000)
  }

  func testECCInterruptControlMasksPreserveAllOtherBits() {
    let io = FlashExtendedIO(); io.registers[.ier] = 0x8000_0001
    io.flash.enableECCCorrectionInterrupt(); io.flash.enableECCDetectionInterrupt()
    io.flash.disableECCCorrectionInterrupt(); io.flash.disableECCDetectionInterrupt()
    XCTAssertEqual(io.registerTrace, [.read(.ier), .write(.ier, 0x8200_0001),
      .read(.ier), .write(.ier, 0x8600_0001), .read(.ier), .write(.ier, 0x8400_0001),
      .read(.ier), .write(.ier, 0x8000_0001)])
  }

  func testECCInfoAddressBoundariesAndSingleErrorPriority() {
    let cases: [(UInt32, UInt32)] = [(0x07FF_FFFF,4),(0x0800_0000,0),(0x0800_FFFF,0),(0x0801_0000,4),
      (0x08FF_EFFF,4),(0x08FF_F000,2),(0x08FF_F3FF,2),(0x08FF_F400,4),
      (0x1FEF_FFFF,4),(0x1FF0_0000,1),(0x1FF1_FFFF,1),(0x1FF2_0000,4)]
    for (address, area) in cases {
      for flags: UInt32 in [0, 0x0400_0000, 0x0200_0000, 0x0600_0000] {
        let io = FlashExtendedIO(); io.registers[.isr] = flags
        let selected: FlashRegister = flags & 0x0200_0000 != 0 ? .eccsfaddr : .eccdfaddr
        io.registers[selected] = address
        var info = FlashECCInfo(area: .max, address: .max, masterID: .max)
        io.flash.getECCInfo(&info)
        XCTAssertEqual(info, .init(area: area, address: address, masterID: 0))
        XCTAssertEqual(io.trace, [.read(.isr), .read(selected)])
      }
    }
  }

  func testECCDetectionCallbackSeesPendingFlagBeforeClearWithoutInterruptGate() {
    let io = FlashExtendedIO(); io.registers[.isr] = 0x0600_0000; io.registers[.ier] = 0
    io.onCallback = {
      var info = FlashECCInfo(); io.flash.getECCInfo(&info)
      XCTAssertEqual(io.registers[.isr], 0x0600_0000)
    }
    io.flash.handleECCDetectionInterrupt()
    XCTAssertEqual(io.callbackFlags, [0x0600_0000])
    XCTAssertEqual(io.trace, [.read(.isr), .callback, .read(.isr), .read(.eccsfaddr), .write(.icr, 0x0400_0000)])
    XCTAssertEqual(io.registers[.isr], 0x0200_0000)
    io.trace = []; io.flash.handleECCDetectionInterrupt(); XCTAssertEqual(io.trace, [.read(.isr)])
  }
}
