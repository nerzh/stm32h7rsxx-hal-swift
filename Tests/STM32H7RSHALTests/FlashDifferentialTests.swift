import XCTest
import CFLASHReference
@testable import STM32H7RSHAL

private func flashWords<T>(_ value: T) -> [UInt32] {
  withUnsafeBytes(of: value) { Array($0.bindMemory(to: UInt32.self)) }
}

private final class FlashReferenceIO: FlashRegisterIO, FlashProcessIO, FlashMemoryIO {
  let state: UnsafeMutablePointer<CFLASHState>
  init(_ state: UnsafeMutablePointer<CFLASHState>) { self.state = state }
  var flash: Flash<FlashReferenceIO, FlashReferenceIO, FlashReferenceIO> {
    Flash(registers: self, process: self, memory: self, callbacks: FlashCallbacks(
      context: UnsafeMutableRawPointer(state),
      endOfOperation: { CFLASH_EmitCallback($0!.assumingMemoryBound(to: CFLASHState.self), 0, $1) },
      operationError: { CFLASH_EmitCallback($0!.assumingMemoryBound(to: CFLASHState.self), 1, $1) },
      eccCorrection: { CFLASH_EmitCallback($0!.assumingMemoryBound(to: CFLASHState.self), 2, 0) },
      eccDetection: { CFLASH_EmitCallback($0!.assumingMemoryBound(to: CFLASHState.self), 3, 0) }))
  }
  func map(_ register: FlashRegister) -> CFLASHRegister {
    switch register {
    case .cr: return CFLASH_CR
    case .sr: return CFLASH_SR
    case .ier: return CFLASH_IER
    case .isr: return CFLASH_ISR
    case .icr: return CFLASH_ICR
    case .keyr: return CFLASH_KEYR
    case .optkeyr: return CFLASH_OPTKEYR
    case .optcr: return CFLASH_OPTCR
    case .optisr: return CFLASH_OPTISR
    case .opticr: return CFLASH_OPTICR
    case .wrpsr: return CFLASH_WRPSR
    case .wrpsrp: return CFLASH_WRPSRP
    case .obw1sr: return CFLASH_OBW1SR
    case .obw1srp: return CFLASH_OBW1SRP
    case .obw2sr: return CFLASH_OBW2SR
    case .obw2srp: return CFLASH_OBW2SRP
    case .hdpsr: return CFLASH_HDPSR
    case .hdpsrp: return CFLASH_HDPSRP
    case .nvsr: return CFLASH_NVSR
    case .nvsrp: return CFLASH_NVSRP
    case .rotsr: return CFLASH_ROTSR
    case .epochsr: return CFLASH_EPOCHSR
    case .otplsr: return CFLASH_OTPLSR
    case .otplsrp: return CFLASH_OTPLSRP
    case .obkcr: return CFLASH_OBKCR
    case .obkdr(let index): return CFLASHRegister(rawValue: CFLASH_OBKDR0.rawValue + UInt32(index))
    case .crccr: return CFLASH_CRCCR
    case .crcsaddr: return CFLASH_CRCSADDR
    case .crceaddr: return CFLASH_CRCEADDR
    case .crcdatar: return CFLASH_CRCDATAR
    case .eccdfaddr: return CFLASH_ECCDFADDR
    case .eccsfaddr: return CFLASH_ECCSFADDR
    }
  }
  // Original C has direct accesses; only final storage and macro writes are
  // compared here. Independent trace tests cover the complete Swift order.
  func read(_ register: FlashRegister) -> UInt32 { CFLASH_Get(state, map(register)) }
  func write(_ register: FlashRegister, value: UInt32) { CFLASH_Write(state, map(register), value) }
  func read(_ register: FlashTimingRegister) -> UInt32 { CFLASH_Get(state, CFLASH_ACR) }
  func write(_ register: FlashTimingRegister, value: UInt32) { CFLASH_Write(state, CFLASH_ACR, value) }
  func read(_ word: FlashProcessWord) -> UInt32 { CFLASH_GetProcess(state, UInt32(word.rawValue)) }
  func write(_ word: FlashProcessWord, value: UInt32) { CFLASH_SetProcess(state, UInt32(word.rawValue), value) }
  func read32(at address: UInt32) -> UInt32 {
    precondition(address >= 0x2000_0000 && address < 0x2000_0020 && address & 3 == 0)
    return withUnsafePointer(to: state.pointee.keys) {
      $0.withMemoryRebound(to: UInt32.self, capacity: 8) { $0[Int((address - 0x2000_0000) / 4)] }
    }
  }
  func write32(at address: UInt32, value: UInt32) {
    precondition(address >= 0x2000_0000 && address < 0x2000_0020 && address & 3 == 0)
    withUnsafeMutablePointer(to: &state.pointee.keys) {
      $0.withMemoryRebound(to: UInt32.self, capacity: 8) { $0[Int((address - 0x2000_0000) / 4)] = value }
    }
  }
  func read8(at address: UInt32) -> UInt8 { fatalError("Successful programming is ARM-only") }
  func read16(at address: UInt32) -> UInt16 { fatalError("Successful programming is ARM-only") }
  func write8(at address: UInt32, value: UInt8) { fatalError("Successful programming is ARM-only") }
  func write16(at address: UInt32, value: UInt16) { fatalError("Successful programming is ARM-only") }
  func getPRIMASK() -> UInt32 { CFLASH_Intrinsic(state, 0, 0) }
  func disableIRQ() { _ = CFLASH_Intrinsic(state, 1, 0) }
  func instructionSynchronizationBarrier() { _ = CFLASH_Intrinsic(state, 2, 0) }
  func dataSynchronizationBarrier() { _ = CFLASH_Intrinsic(state, 3, 0) }
  func setPRIMASK(_ value: UInt32) { _ = CFLASH_Intrinsic(state, 4, value) }

  func options(_ c: FLASH_OBProgramInitTypeDef) -> FlashOptionBytesConfiguration {
    .init(optionType: c.OptionType, wrpState: c.WRPState, wrpSector: c.WRPSector,
          userType: c.USERType, userConfiguration1: c.USERConfig1, userConfiguration2: c.USERConfig2,
          hdpStartPage: c.HDPStartPage, hdpEndPage: c.HDPEndPage, nvState: c.NVState,
          rotConfiguration: c.ROTConfig, epoch: c.EPOCH)
  }
  func storeOptions(_ value: FlashOptionBytesConfiguration) {
    state.pointee.options = FLASH_OBProgramInitTypeDef(
      OptionType: value.optionType, WRPState: value.wrpState, WRPSector: value.wrpSector,
      USERType: value.userType, USERConfig1: value.userConfiguration1, USERConfig2: value.userConfiguration2,
      HDPStartPage: value.hdpStartPage, HDPEndPage: value.hdpEndPage, NVState: value.nvState,
      ROTConfig: value.rotConfiguration, EPOCH: value.epoch)
  }
  @discardableResult func run(_ operation: CFLASHOperation, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
    let tick = { CFLASH_Tick(self.state) }
    let erase = state.pointee.erase
    let eraseConfig = FlashEraseConfiguration(typeErase: erase.TypeErase, sector: erase.Sector, sectorCount: erase.NbSectors)
    let key = state.pointee.key
    let keyConfig = FlashKeyConfiguration(index: key.Index, size: key.Size, hdplLevel: key.HDPLLevel)
    switch operation {
    case CFLASH_Program: return flash.program(type: a, address: b, dataAddress: c, getTick: tick).rawValue
    case CFLASH_ProgramInterrupt: return flash.programInterrupt(type: a, address: b, dataAddress: c, getTick: tick).rawValue
    case CFLASH_HandleInterrupt: flash.handleInterrupt()
    case CFLASH_Unlock: return flash.unlock().rawValue
    case CFLASH_Lock: return flash.lock().rawValue
    case CFLASH_UnlockOptionBytes: return flash.unlockOptionBytes().rawValue
    case CFLASH_LockOptionBytes: return flash.lockOptionBytes().rawValue
    case CFLASH_GetError: return flash.getError()
    case CFLASH_Wait: return flash.waitForLastOperation(timeout: a, getTick: tick).rawValue
    case CFLASH_Erase: return flash.erase(eraseConfig, sectorError: &state.pointee.sectorError, getTick: tick).rawValue
    case CFLASH_EraseInterrupt: return flash.eraseInterrupt(eraseConfig, getTick: tick).rawValue
    case CFLASH_ProgramOptionBytes: return flash.programOptionBytes(options(state.pointee.options), getTick: tick).rawValue
    case CFLASH_GetOptionBytes:
      var value = options(state.pointee.options); flash.getOptionBytesConfiguration(&value); storeOptions(value)
    case CFLASH_ConfigureOTPLock: return flash.configureOTPLock(a, getTick: tick).rawValue
    case CFLASH_GetOTPLock: return flash.getOTPLock()
    case CFLASH_ConfigureKey: return flash.configureKey(keyConfig, keyAddress: 0x2000_0000, getTick: tick).rawValue
    case CFLASH_GetKey:
      let output: UInt32? = a == 0 ? 0x2000_0000 : a == 2 ? 0 : nil
      return flash.getKey(keyConfig, outputAddress: output, getTick: tick).rawValue
    case CFLASH_ComputeCRC:
      let value = state.pointee.crc
      return flash.computeCRC(.init(typeCRC: value.TypeCRC, burstSize: value.BurstSize, sector: value.Sector,
                                    sectorCount: value.NbSectors, startAddress: value.CRCStartAddr, endAddress: value.CRCEndAddr),
                              result: &state.pointee.crcResult, getTick: tick).rawValue
    case CFLASH_EnableECCCorrection: flash.enableECCCorrectionInterrupt()
    case CFLASH_DisableECCCorrection: flash.disableECCCorrectionInterrupt()
    case CFLASH_EnableECCDetection: flash.enableECCDetectionInterrupt()
    case CFLASH_DisableECCDetection: flash.disableECCDetectionInterrupt()
    case CFLASH_GetECCInfo:
      var value = FlashECCInfo(area: state.pointee.ecc.Area, address: state.pointee.ecc.Address, masterID: state.pointee.ecc.MasterID)
      flash.getECCInfo(&value)
      state.pointee.ecc = FLASH_EccInfoTypeDef(Area: value.area, Address: value.address, MasterID: value.masterID)
    case CFLASH_HandleECCDetection: flash.handleECCDetectionInterrupt()
    case CFLASH_EnableInterrupts: flash.enableInterrupts(a)
    case CFLASH_DisableInterrupts: flash.disableInterrupts(a)
    case CFLASH_GetFlag: return flash.getFlag(a)
    case CFLASH_ClearFlag: flash.clearFlag(a)
    case CFLASH_SetLatency: flash.setLatency(FlashLatency(rawValue: a)!)
    case CFLASH_GetLatency: return flash.getLatency()
    default: fatalError("Unknown FLASH operation")
    }
    return 0
  }
  func apply(_ action: CFLASHAction) {
    switch action.kind {
    case CFLASH_ActionNone: break
    case CFLASH_ActionRegister: CFLASH_Set(state, CFLASHRegister(rawValue: action.index), action.value)
    case CFLASH_ActionProcess: CFLASH_SetProcess(state, action.index, action.value)
    case CFLASH_ActionCall: run(CFLASHOperation(rawValue: action.index), action.a, action.b, action.c)
    default: fatalError("Unknown FLASH action")
    }
  }
}

private final class FlashReferencePair {
  let actual = UnsafeMutablePointer<CFLASHState>.allocate(capacity: 1)
  let reference = UnsafeMutablePointer<CFLASHState>.allocate(capacity: 1)
  let io: FlashReferenceIO
  init(_ setup: (UnsafeMutablePointer<CFLASHState>) -> Void = { _ in }) {
    actual.initialize(to: CFLASHState()); reference.initialize(to: CFLASHState())
    CFLASH_Reset(actual); CFLASH_Reset(reference)
    io = FlashReferenceIO(actual)
    CFLASH_SetExecutionHook(actual, Unmanaged.passUnretained(io).toOpaque(), { context, action in
      Unmanaged<FlashReferenceIO>.fromOpaque(context!).takeUnretainedValue().apply(action)
    })
    configure(setup)
  }
  deinit { actual.deinitialize(count: 1); reference.deinitialize(count: 1); actual.deallocate(); reference.deallocate() }
  func configure(_ body: (UnsafeMutablePointer<CFLASHState>) -> Void) { body(actual); body(reference) }
  @discardableResult func run(_ operation: CFLASHOperation, a: UInt32 = 0, b: UInt32 = 0, c: UInt32 = 0,
                             file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
    let expected = CFLASH_Run(reference, operation, a, b, c)
    let result = io.run(operation, a, b, c)
    XCTAssertEqual(result, expected, "operation \(operation.rawValue)", file: file, line: line)
    XCTAssertEqual(flashWords(CFLASH_GetSnapshot(actual)), flashWords(CFLASH_GetSnapshot(reference)), file: file, line: line)
    XCTAssertEqual(actual.pointee.tick, reference.pointee.tick, file: file, line: line)
    XCTAssertEqual(actual.pointee.tickCalls, reference.pointee.tickCalls, file: file, line: line)
    XCTAssertEqual(actual.pointee.primask, reference.pointee.primask, file: file, line: line)
    XCTAssertEqual(actual.pointee.callbackCount, reference.pointee.callbackCount, file: file, line: line)
    for index in 0..<min(actual.pointee.callbackCount, reference.pointee.callbackCount) {
      XCTAssertEqual(flashWords(CFLASH_GetCallbackEvent(actual, index)), flashWords(CFLASH_GetCallbackEvent(reference, index)),
                     "callback \(index)", file: file, line: line)
    }
    XCTAssertEqual(writes(actual, operation), writes(reference, operation), "macro writes", file: file, line: line)
    return result
  }
  func writes(_ state: UnsafeMutablePointer<CFLASHState>, _ operation: CFLASHOperation) -> [[UInt32]] {
    // These registers are written only through macros in the C bodies.
    let traced: Set<UInt32> = [CFLASH_ACR, CFLASH_KEYR, CFLASH_CR, CFLASH_IER, CFLASH_CRCCR,
      CFLASH_OPTKEYR, CFLASH_OPTCR, CFLASH_OBKCR, CFLASH_NVSRP, CFLASH_OTPLSRP,
      CFLASH_HDPSRP, CFLASH_OBW1SRP, CFLASH_OBW2SRP].map(\.rawValue).reduce(into: []) { $0.insert($1) }
    return (0..<state.pointee.accessCount).compactMap {
      let entry = CFLASH_GetAccess(state, $0)
      guard entry.kind == 1, traced.contains(entry.reg.rawValue) else { return nil }
      return [entry.reg.rawValue, entry.value, entry.tickCall]
    }
  }
}

private func flashRegisterAction(_ register: CFLASHRegister, _ value: UInt32) -> CFLASHAction {
  CFLASHAction(kind: CFLASH_ActionRegister, index: register.rawValue, value: value, a: 0, b: 0, c: 0)
}
private func flashProcessAction(_ word: UInt32, _ value: UInt32) -> CFLASHAction {
  CFLASHAction(kind: CFLASH_ActionProcess, index: word, value: value, a: 0, b: 0, c: 0)
}
private func flashCallAction(_ operation: CFLASHOperation, _ a: UInt32 = 0) -> CFLASHAction {
  CFLASHAction(kind: CFLASH_ActionCall, index: operation.rawValue, value: 0, a: a, b: 0, c: 0)
}

final class FlashDifferentialTests: XCTestCase {
  func testWaitErrorsFlagOverlapTimeoutBoundariesAndRollover() {
    for isr: UInt32 in [0, 0x10000, 0x20000, 0x113E0000, 0x06000000, 0x18000000, .max] {
      for option: UInt32 in [0, 0x08000000, 0x50000000, .max] {
        let pair = FlashReferencePair { s in
          CFLASH_Set(s, CFLASH_ISR, isr); CFLASH_Set(s, CFLASH_OPTISR, option)
          CFLASH_SetProcess(s, 1, 0x80)
        }
        pair.run(CFLASH_Wait, a: 0)
        pair.run(CFLASH_GetError)
      }
    }
    for timeout: UInt32 in [0, 1, 2, 7] {
      for start: UInt32 in [0, .max - 2] {
        for readyCall in 1...(timeout + 3) {
          let pair = FlashReferencePair { s in
            s.pointee.tick = start; CFLASH_Set(s, CFLASH_SR, 4)
            CFLASH_ScheduleTick(s, readyCall, flashRegisterAction(CFLASH_SR, 0))
          }
          pair.run(CFLASH_Wait, a: timeout)
        }
      }
    }
    FlashReferencePair().run(CFLASH_Wait, a: .max)
  }

  func testProgramBothModesAllTypesBeforeMemoryFailure() {
    for type in FlashProgramType.allCases {
      for operation in [CFLASH_Program, CFLASH_ProgramInterrupt] {
        for failure in 0..<4 {
          let pair = FlashReferencePair { s in
            CFLASH_SetProcess(s, 1, 0x80)
            if failure == 0 { CFLASH_SetProcess(s, 0, 1) }
            if failure == 1 { CFLASH_Set(s, CFLASH_ISR, 0x20000) }
            if failure == 2 { CFLASH_Set(s, CFLASH_OPTISR, 0x08000000) }
            if failure == 3 { CFLASH_Set(s, CFLASH_SR, 4); s.pointee.tickStep = 1001 }
          }
          pair.run(operation, a: type.rawValue, b: 0x08000000, c: 0x20000000)
        }
      }
    }
  }

  func testLockUnlockSuccessfulRejectedAndAlreadyUnlockedPaths() {
    for option in [false, true] {
      let control = option ? CFLASH_OPTCR : CFLASH_CR
      let key = option ? CFLASH_OPTKEYR : CFLASH_KEYR
      for initial: UInt32 in [0xA5000000, 0xA5000001] {
        for unlockSucceeds in [false, true] {
          let pair = FlashReferencePair { s in
            CFLASH_Set(s, control, initial)
            if unlockSucceeds { CFLASH_ScheduleWrite(s, key, 2, flashRegisterAction(control, initial & ~1)) }
          }
          pair.run(option ? CFLASH_UnlockOptionBytes : CFLASH_Unlock)
          pair.run(option ? CFLASH_LockOptionBytes : CFLASH_Lock)
        }
      }
      let rejected = FlashReferencePair { s in
        CFLASH_ScheduleWrite(s, control, 1, flashRegisterAction(control, 0))
      }
      XCTAssertEqual(rejected.run(option ? CFLASH_LockOptionBytes : CFLASH_Lock), 1)
    }
  }

  func testExportedMacrosPreserveSharedISRAndOptionBitEncodings() {
    for bits: UInt32 in [0, 0x10000, 0x06000000, 0x08000000, 0x10000000, 0x58000000, 0x173F0000, .max] {
      let pair = FlashReferencePair { s in
        CFLASH_Set(s, CFLASH_IER, 0xA5A5A5A5); CFLASH_Set(s, CFLASH_OPTCR, 0x5A5A5A5A)
        CFLASH_Set(s, CFLASH_ISR, 0xA5A5A5A5); CFLASH_Set(s, CFLASH_OPTISR, 0x5A5A5A5A)
      }
      pair.run(CFLASH_EnableInterrupts, a: bits); pair.run(CFLASH_DisableInterrupts, a: bits)
      pair.run(CFLASH_GetFlag, a: bits); pair.run(CFLASH_ClearFlag, a: bits)
    }
    for latency in FlashLatency.allCases {
      let pair = FlashReferencePair { CFLASH_Set($0, CFLASH_ACR, .max) }
      pair.run(CFLASH_SetLatency, a: latency.rawValue); pair.run(CFLASH_GetLatency)
    }
  }

  func testInterruptCombinedStatusProcedureAndECCGates() {
    let procedures: [UInt32] = [0, 4, 8, 0x12, 0x40010010]
    for procedure in procedures {
      for combination: UInt32 in 0..<32 {
        let pair = FlashReferencePair { s in
          CFLASH_SetProcess(s, 0, 1); CFLASH_SetProcess(s, 1, 0x80)
          CFLASH_SetProcess(s, 2, procedure); CFLASH_SetProcess(s, 3, 0x08000124)
          CFLASH_SetProcess(s, 4, 2); CFLASH_SetProcess(s, 5, combination & 1 == 0 ? 1 : 2)
          let status: UInt32 = (combination & 1 == 0 ? 0 : 0x10000) |
            (combination & 2 == 0 ? 0 : 0x20000) | (combination & 4 == 0 ? 0 : 0x02000000) |
            (combination & 8 == 0 ? 0 : 0x04000000)
          CFLASH_Set(s, CFLASH_ISR, status)
          CFLASH_Set(s, CFLASH_OPTISR, combination & 16 == 0 ? 0 : 0x08000000)
          CFLASH_Set(s, CFLASH_IER, combination & 2 == 0 ? .max : 0)
          CFLASH_Set(s, CFLASH_CR, .max)
        }
        pair.run(CFLASH_HandleInterrupt)
      }
    }
  }

  func testInterruptCallbacksRearmMutatePendingBitsAndReenter() {
    let pair = FlashReferencePair { s in
      CFLASH_SetProcess(s, 0, 1); CFLASH_SetProcess(s, 2, 0x12); CFLASH_SetProcess(s, 3, 0x08000100)
      CFLASH_Set(s, CFLASH_ISR, 0x00030000)
      CFLASH_SetCallbackAction(s, 1, 0, flashProcessAction(2, 4))
      CFLASH_SetCallbackAction(s, 1, 1, flashProcessAction(4, 3))
      CFLASH_SetCallbackAction(s, 1, 2, flashProcessAction(5, 2))
      CFLASH_SetCallbackAction(s, 0, 0, flashRegisterAction(CFLASH_ISR, 0x06000000))
      CFLASH_SetCallbackAction(s, 0, 1, flashRegisterAction(CFLASH_IER, 0x06000000))
      CFLASH_SetCallbackAction(s, 2, 0, flashRegisterAction(CFLASH_ISR, 0x04000000))
      CFLASH_SetCallbackAction(s, 2, 1, flashCallAction(CFLASH_HandleECCDetection))
      CFLASH_SetCallbackAction(s, 3, 0, flashRegisterAction(CFLASH_ISR, 0))
    }
    pair.run(CFLASH_HandleInterrupt)
    XCTAssertEqual(pair.actual.pointee.callbackCount, 4)
  }

  func testEraseAllSectorsZeroCountMassAndInterruptContinuation() {
    for start: UInt32 in 0..<8 {
      for count in 0...(8 - start) {
        let pair = FlashReferencePair { s in s.pointee.erase.Sector = start; s.pointee.erase.NbSectors = count }
        pair.run(CFLASH_Erase)
      }
    }
    let mass = FlashReferencePair { $0.pointee.erase.TypeErase = 8 }
    mass.run(CFLASH_Erase)
    for type: UInt32 in [4, 8] {
      let pair = FlashReferencePair { s in s.pointee.erase.TypeErase = type; s.pointee.erase.Sector = 2; s.pointee.erase.NbSectors = 3 }
      pair.run(CFLASH_EraseInterrupt)
      for _ in 0..<3 {
        pair.configure { CFLASH_Set($0, CFLASH_ISR, 0x10000) }
        pair.run(CFLASH_HandleInterrupt)
      }
    }
  }

  func testEraseFailureAtEachSectorAndTimeoutCleanup() {
    for badSector: UInt32 in 0..<4 {
      let pair = FlashReferencePair { s in
        s.pointee.erase.NbSectors = 4
        CFLASH_ScheduleWrite(s, CFLASH_CR, badSector + 1, flashRegisterAction(CFLASH_ISR, 0x40000))
      }
      pair.run(CFLASH_Erase)
      XCTAssertEqual(pair.actual.pointee.sectorError, badSector)
    }
    for operation in [CFLASH_Erase, CFLASH_EraseInterrupt] {
      for phase in 0..<2 {
        let pair = FlashReferencePair { s in
          s.pointee.tickStep = 1001
          if phase == 0 { CFLASH_Set(s, CFLASH_SR, 4) }
          else { CFLASH_ScheduleWrite(s, CFLASH_CR, 1, flashRegisterAction(CFLASH_SR, 4)) }
        }
        pair.run(operation)
      }
    }
  }

  func testOptionProgrammingAllGroupsAndUserMasks() {
    for groups: UInt32 in 0..<16 {
      for state: UInt32 in [0, 1] {
        let pair = FlashReferencePair { s in
          s.pointee.options = FLASH_OBProgramInitTypeDef(OptionType: groups, WRPState: state, WRPSector: 0xA5,
            USERType: 0x1FFF, USERConfig1: 0x200603DC, USERConfig2: 0x377, HDPStartPage: 0x12,
            HDPEndPage: 0xEF, NVState: 0x51, ROTConfig: .max, EPOCH: .max)
          CFLASH_Set(s, CFLASH_WRPSRP, 0xA5A5A5A5); CFLASH_Set(s, CFLASH_OBW1SRP, 0x5A5A5A5A)
          CFLASH_Set(s, CFLASH_OBW2SRP, 0xA5A5A5A5); CFLASH_Set(s, CFLASH_HDPSRP, .max)
          CFLASH_Set(s, CFLASH_NVSRP, .max)
        }
        pair.run(CFLASH_ProgramOptionBytes)
      }
    }
    for bit: UInt32 in 0..<13 {
      for value: UInt32 in [0, .max] {
        let pair = FlashReferencePair { s in
          s.pointee.options.OptionType = 2; s.pointee.options.USERType = 1 << bit
          s.pointee.options.USERConfig1 = value; s.pointee.options.USERConfig2 = value
          CFLASH_Set(s, CFLASH_OBW1SRP, ~value); CFLASH_Set(s, CFLASH_OBW2SRP, ~value)
        }
        pair.run(CFLASH_ProgramOptionBytes)
      }
    }
  }

  func testOptionReadbackKeepsUntouchedFieldsAndReservedBits() {
    for wrp: UInt32 in [0, 0xFF, 0x123400FF, 0xA5A55A5A] {
      let pair = FlashReferencePair { s in
        s.pointee.options.OptionType = 0xDEADBEEF; s.pointee.options.USERType = 0xCAFEBABE
        s.pointee.options.WRPSector = 0x11223344
        for reg in [CFLASH_WRPSR, CFLASH_OBW1SR, CFLASH_OBW2SR, CFLASH_HDPSR, CFLASH_NVSR, CFLASH_ROTSR, CFLASH_EPOCHSR] {
          CFLASH_Set(s, reg, 0xA5F03C5A)
        }
        CFLASH_Set(s, CFLASH_WRPSR, wrp)
      }
      pair.run(CFLASH_GetOptionBytes)
      XCTAssertEqual(pair.actual.pointee.options.OptionType, 0xDEADBEEF)
      if wrp & 0xFF == 0xFF { XCTAssertEqual(pair.actual.pointee.options.WRPSector, 0x11223344) }
    }
  }

  func testOTPLockAndEveryKeySizeLevelIndexAndOptionalOutput() {
    for blocks: UInt32 in [0, 1, 0x8000, 0xFFFF] {
      let pair = FlashReferencePair { s in CFLASH_Set(s, CFLASH_OTPLSRP, .max); CFLASH_Set(s, CFLASH_OTPLSR, 0xA5A51234) }
      pair.run(CFLASH_ConfigureOTPLock, a: blocks); pair.run(CFLASH_GetOTPLock)
    }
    for size in FlashKeySize.allCases {
      for level in FlashKeyLevel.allCases {
        for index: UInt32 in [0, 31] {
          let pair = FlashReferencePair { s in
            s.pointee.key = FLASH_KeyConfigTypeDef(Index: index, Size: size.rawValue, HDPLLevel: level.rawValue)
            CFLASH_Set(s, CFLASH_OBKCR, 0xA5A5A5A5)
          }
          pair.run(CFLASH_ConfigureKey)
          pair.configure { s in
            for i: UInt32 in 0..<8 { CFLASH_Set(s, CFLASHRegister(rawValue: CFLASH_OBKDR0.rawValue + i), 0xF0000000 + i) }
          }
          pair.run(CFLASH_GetKey, a: 1); pair.run(CFLASH_GetKey, a: 2); pair.run(CFLASH_GetKey)
        }
      }
    }
  }

  func testExtendedSharedLockFirstAndSecondWaitFailures() {
    let operations = [CFLASH_ProgramOptionBytes, CFLASH_ConfigureOTPLock, CFLASH_ConfigureKey, CFLASH_GetKey, CFLASH_ComputeCRC]
    for operation in operations {
      for failure in 0..<5 {
        let pair = FlashReferencePair { s in
          s.pointee.options.OptionType = 1
          s.pointee.tickStep = 1001
          CFLASH_SetProcess(s, 1, 0x8000)
          if failure == 0 { CFLASH_SetProcess(s, 0, 1) }
          if failure == 1 { CFLASH_Set(s, CFLASH_ISR, 0x20000) }
          if failure == 2 { CFLASH_Set(s, CFLASH_SR, 4) }
          if failure == 3 {
            let trigger = operation == CFLASH_ComputeCRC ? CFLASH_CR : CFLASH_OPTCR
            CFLASH_ScheduleWrite(s, trigger, 1, flashRegisterAction(CFLASH_SR, operation == CFLASH_ComputeCRC ? 8 : 4))
          }
          if failure == 4 {
            let trigger = operation == CFLASH_ComputeCRC ? CFLASH_CR : CFLASH_OPTCR
            CFLASH_ScheduleWrite(s, trigger, 1, flashRegisterAction(CFLASH_ISR, operation == CFLASH_ComputeCRC ? 0x10000000 : 0x80000))
          }
        }
        pair.run(operation)
      }
    }
  }

  func testCRCBankSectorAddressAllBurstsAndCompletionResults() {
    for type in FlashCRCType.allCases {
      for burst in FlashCRCBurstSize.allCases {
        for finalStatus: UInt32 in [0, 0x08000000, 0x10000000] {
          let pair = FlashReferencePair { s in
            s.pointee.crc = FLASH_CRCInitTypeDef(TypeCRC: type.rawValue, BurstSize: burst.rawValue,
              Sector: 2, NbSectors: 4, CRCStartAddr: 0x08001234, CRCEndAddr: 0x0800FEDC)
            CFLASH_Set(s, CFLASH_CRCDATAR, 0x9ABCDEFA)
            CFLASH_ScheduleWrite(s, CFLASH_CR, 1, flashRegisterAction(CFLASH_ISR, finalStatus))
          }
          pair.run(CFLASH_ComputeCRC)
          XCTAssertEqual(pair.actual.pointee.crcResult, 0x9ABCDEFA)
        }
      }
    }
    for completion: UInt32 in [1, 2, 3, 4] {
      let pair = FlashReferencePair { s in
        CFLASH_Set(s, CFLASH_SR, 8); s.pointee.tick = .max - 2; s.pointee.tickStep = 501
        CFLASH_ScheduleTick(s, completion, flashRegisterAction(CFLASH_SR, 0))
      }
      pair.run(CFLASH_ComputeCRC)
    }
  }

  func testECCAddressBoundariesSelectionInterruptGatesAndClearAfterCallback() {
    let addresses: [UInt32] = [0, 0x07FFFFFF, 0x08000000, 0x0800FFFF, 0x08010000,
      0x08FFEFFF, 0x08FFF000, 0x08FFF3FF, 0x08FFF400, 0x1FEFFFFF, 0x1FF00000, 0x1FF1FFFF, 0x1FF20000, .max]
    for address in addresses {
      for single in [false, true] {
        let pair = FlashReferencePair { s in
          CFLASH_Set(s, CFLASH_ISR, single ? 0x02000000 : 0x04000000)
          CFLASH_Set(s, single ? CFLASH_ECCSFADDR : CFLASH_ECCDFADDR, address)
        }
        pair.run(CFLASH_GetECCInfo)
      }
    }
    let pair = FlashReferencePair { s in
      CFLASH_Set(s, CFLASH_ISR, 0x04000000); CFLASH_Set(s, CFLASH_ICR, 0x1234)
      CFLASH_SetCallbackAction(s, 3, 0, flashCallAction(CFLASH_GetECCInfo))
      CFLASH_Set(s, CFLASH_ECCDFADDR, 0x1FF00010)
    }
    pair.run(CFLASH_HandleECCDetection)
    XCTAssertEqual(pair.actual.pointee.callbackCount, 1)
    for operation in [CFLASH_EnableECCCorrection, CFLASH_EnableECCDetection, CFLASH_DisableECCCorrection, CFLASH_DisableECCDetection] {
      pair.run(operation)
    }
  }
}
