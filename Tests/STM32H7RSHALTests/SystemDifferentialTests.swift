import XCTest
import CSystemReference
@testable import STM32H7RSHAL

private struct SystemReferenceIO: SBSRegisterIO, VREFBUFRegisterIO, AXIMASIBRegisterIO, AXIMAMIBRegisterIO, FMCBankMappingRegisterIO {
  let state: UnsafeMutablePointer<CSystemState>
  let instance: UInt32
  init(_ state: UnsafeMutablePointer<CSystemState>, instance: UInt32 = 0) { self.state = state; self.instance = instance }
  func map(_ register: SBSRegister) -> CSystemRegister {
    switch register {
    case .bootsr: return CSystem_BOOTSR
    case .hdplcr: return CSystem_HDPLCR
    case .hdplsr: return CSystem_HDPLSR
    case .dbgcr: return CSystem_DBGCR
    case .dbglockr: return CSystem_DBGLOCKR
    case .rsscmdr: return CSystem_RSSCMDR
    case .pmcr: return CSystem_PMCR
    case .fpuimr: return CSystem_FPUIMR
    case .mesr: return CSystem_MESR
    case .cccsr: return CSystem_CCCSR
    case .ccvalr: return CSystem_CCVALR
    case .ccswvalr: return CSystem_CCSWVALR
    case .bklockr: return CSystem_BKLOCKR
    case .extiConfiguration(let index): return CSystemRegister(rawValue: CSystem_EXTICR0.rawValue + UInt32(index))
    }
  }
  func read(_ register: SBSRegister) -> UInt32 { CSystem_Get(state, map(register)) }
  func write(_ register: SBSRegister, value: UInt32) { CSystem_Write(state, map(register), value) }
  func read(_ register: VREFBUFRegister) -> UInt32 { CSystem_Read(state, register == .csr ? CSystem_VREF_CSR : CSystem_VREF_CCR) }
  func write(_ register: VREFBUFRegister, value: UInt32) { CSystem_Write(state, register == .csr ? CSystem_VREF_CSR : CSystem_VREF_CCR, value) }
  func map(_ register: AXIMASIBRegister) -> CSystemRegister {
    let offset: UInt32
    switch register { case .fnmod2: offset = 0; case .readQoS: offset = 1; case .writeQoS: offset = 2; case .fnmod: offset = 3 }
    return CSystemRegister(rawValue: CSystem_ASIB1_FNMOD2.rawValue + instance * 4 + offset)
  }
  func read(_ register: AXIMASIBRegister) -> UInt32 { CSystem_Get(state, map(register)) }
  func write(_ register: AXIMASIBRegister, value: UInt32) { CSystem_Write(state, map(register), value) }
  func map(_ register: AXIMAMIBRegister) -> CSystemRegister {
    let offset: UInt32
    switch register { case .fnmodBusMatrixIssuing: offset = 0; case .fnmod2: offset = 1; case .fnmodLongBurst: offset = 2; case .fnmod: offset = 3 }
    return CSystemRegister(rawValue: CSystem_AMIB1_FNMODBMISS.rawValue + instance * 4 + offset)
  }
  func read(_ register: AXIMAMIBRegister) -> UInt32 { CSystem_Get(state, map(register)) }
  func write(_ register: AXIMAMIBRegister, value: UInt32) { CSystem_Write(state, map(register), value) }
  func read(_ register: FMCBankMappingRegister) -> UInt32 { CSystem_Get(state, CSystem_FMC_BCR1) }
  func write(_ register: FMCBankMappingRegister, value: UInt32) { CSystem_Write(state, CSystem_FMC_BCR1, value) }

  func run(_ operation: CSystemOperation, a: UInt32, b: UInt32, c: UInt32, d: UInt32) -> UInt32 {
    let sbs = SBS(registers: self), vref = VREFBUF(registers: self)
    let asib = AXIMASIB(registers: SystemReferenceIO(state, instance: a))
    let amib = AXIMAMIB(registers: SystemReferenceIO(state, instance: a))
    let fmc = FMCBankMapping(registers: self)
    switch operation {
    case CSystem_SBS_GetBootAddress: return sbs.getBootAddress()
    case CSystem_SBS_IncrementHDPLValue: sbs.incrementHDPLValue()
    case CSystem_SBS_GetHDPLValue: return sbs.getHDPLValue()
    case CSystem_SBS_OpenAccessPort: sbs.openAccessPort()
    case CSystem_SBS_OpenDebug: sbs.openDebug()
    case CSystem_SBS_ConfigDebugLevel: return sbs.configureDebugLevel(a).rawValue
    case CSystem_SBS_GetDebugLevel: return sbs.getDebugLevel()
    case CSystem_SBS_UnlockDebugConfig: sbs.unlockDebugConfiguration()
    case CSystem_SBS_LockDebugConfig: sbs.lockDebugConfiguration()
    case CSystem_SBS_ConfigRSSCommand: sbs.configureRSSCommand(a)
    case CSystem_SBS_GetRSSCommand: return sbs.getRSSCommand()
    case CSystem_SBS_EnableIOAnalogBooster: sbs.enableIOAnalogBooster()
    case CSystem_SBS_DisableIOAnalogBooster: sbs.disableIOAnalogBooster()
    case CSystem_SBS_EnableIOAnalogSwitchVdd: sbs.enableIOAnalogSwitchVDD()
    case CSystem_SBS_DisableIOAnalogSwitchVdd: sbs.disableIOAnalogSwitchVDD()
    case CSystem_SBS_ConfigEthernetPHY: sbs.configureEthernetPHY(a)
    case CSystem_SBS_ConfigAXISRAMWaitState: sbs.configureAXISRAMWaitState(a)
    case CSystem_SBS_EnableCompensationCell: sbs.enableCompensationCell(a)
    case CSystem_SBS_DisableCompensationCell: sbs.disableCompensationCell(a)
    case CSystem_SBS_GetCompensationCellReadyStatus: return sbs.getCompensationCellReadyStatus(a)
    case CSystem_SBS_ConfigCompensationCell: sbs.configureCompensationCell(a, code: b, nmosValue: c, pmosValue: d)
    case CSystem_SBS_GetCompensationCell:
      return sbs.getCompensationCell(a, code: CSystem_Pointer(state, b), nmosValue: CSystem_Pointer(state, c),
                                     pmosValue: CSystem_Pointer(state, d)).rawValue
    case CSystem_SBS_EnableIOSpeedOptimize: sbs.enableIOSpeedOptimization(a)
    case CSystem_SBS_DisableIOSpeedOptimize: sbs.disableIOSpeedOptimization(a)
    case CSystem_SBS_ConfigTimerBreakInput: sbs.configureTimerBreakInput(a)
    case CSystem_SBS_GetTimerBreakInputConfig: return sbs.getTimerBreakInputConfiguration()
    case CSystem_SBS_EXTIConfig: sbs.configureEXTI(a, port: b)
    case CSystem_SBS_GetEXTIConfig: return sbs.getEXTIConfiguration(a)
    case CSystem_VREFBUF_VoltageScalingConfig: vref.configureVoltageScaling(a)
    case CSystem_VREFBUF_HighImpedanceConfig: vref.configureHighImpedance(a)
    case CSystem_VREFBUF_TrimmingConfig: vref.configureTrimming(a)
    case CSystem_VREFBUF_Enable: return vref.enable(getTick: { CSystem_Tick(state) }).rawValue
    case CSystem_VREFBUF_Disable: vref.disable()
    case CSystem_AXIM_ASIB_EnablePacking: asib.enablePacking()
    case CSystem_AXIM_ASIB_DisablePacking: asib.disablePacking()
    case CSystem_AXIM_ASIB_IssuingConfig: asib.configureIssuing(read: b, write: c)
    case CSystem_AXIM_ASIB_ReadQoSConfig: asib.configureReadQoS(b)
    case CSystem_AXIM_ASIB_WriteQoSConfig: asib.configureWriteQoS(b)
    case CSystem_AXIM_AMIB_EnablePacking: amib.enablePacking()
    case CSystem_AXIM_AMIB_DisablePacking: amib.disablePacking()
    case CSystem_AXIM_AMIB_IssuingConfig: amib.configureIssuing(read: b, write: c)
    case CSystem_AXIM_AMIB_IssuingConfigBusMatrix: amib.configureBusMatrixIssuing(read: b, write: c)
    case CSystem_AXIM_AMIB_EnableLongBurst: amib.enableLongBurst()
    case CSystem_AXIM_AMIB_DisableLongBurst: amib.disableLongBurst()
    case CSystem_FMC_SetBankSwapConfig: fmc.setBankSwapConfiguration(a)
    case CSystem_FMC_GetBankSwapConfig: return fmc.getBankSwapConfiguration()
    case CSystem_SBS_EnableFPUInterrupts: sbs.enableFPUInterrupts(a)
    case CSystem_SBS_DisableFPUInterrupts: sbs.disableFPUInterrupts(a)
    case CSystem_SBS_GetMemoryEraseStatus: return sbs.getMemoryEraseStatus()
    default: preconditionFailure("Unknown system operation")
    }
    return 0
  }
}
private final class SystemReferencePair {
  let actual = UnsafeMutablePointer<CSystemState>.allocate(capacity: 1)
  let reference = UnsafeMutablePointer<CSystemState>.allocate(capacity: 1)
  init(seed: UInt32 = 0, setup: (UnsafeMutablePointer<CSystemState>) -> Void = { _ in }) {
    CSystem_Reset(actual); CSystem_Reset(reference)
    configure { s in
      for index in UInt32(0)..<CSystem_RegisterCount.rawValue { CSystem_Set(s, CSystemRegister(rawValue: index), seed) }
      setup(s)
    }
  }
  deinit { actual.deallocate(); reference.deallocate() }
  func configure(_ setup: (UnsafeMutablePointer<CSystemState>) -> Void) { setup(actual); setup(reference) }
  @discardableResult func run(_ operation: CSystemOperation, a: UInt32 = 0, b: UInt32 = 0,
    c: UInt32 = 0, d: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
    let expected = CSystem_Run(reference, operation, a, b, c, d)
    let result = SystemReferenceIO(actual).run(operation, a: a, b: b, c: c, d: d)
    XCTAssertEqual(result, expected, "operation \(operation.rawValue)", file: file, line: line)
    for index in UInt32(0)..<CSystem_RegisterCount.rawValue {
      XCTAssertEqual(CSystem_Get(actual, CSystemRegister(rawValue: index)), CSystem_Get(reference, CSystemRegister(rawValue: index)),
                     "register \(index)", file: file, line: line)
    }
    for selector in UInt32(1)...3 {
      XCTAssertEqual(CSystem_Pointer(actual, selector).pointee, CSystem_Pointer(reference, selector).pointee, file: file, line: line)
    }
    XCTAssertEqual(actual.pointee.tick, reference.pointee.tick, file: file, line: line)
    XCTAssertEqual(actual.pointee.tickCalls, reference.pointee.tickCalls, file: file, line: line)
    func trace(_ s: UnsafeMutablePointer<CSystemState>) -> [[UInt32]] {
      (0..<s.pointee.accessCount).compactMap {
        let event = CSystem_GetAccess(s, $0)
        guard event.kind == 1 || event.reg == CSystem_VREF_CSR || event.reg == CSystem_VREF_CCR else { return nil }
        return [event.reg.rawValue, event.value, event.kind, event.tickCalls]
      }
    }
    XCTAssertEqual(trace(actual), trace(reference), "all macro writes / full VREF accesses", file: file, line: line)
    return result
  }
}

final class SystemDifferentialTests: XCTestCase {
  func testSBSSecurityAccessAndReadbackOnMockRegistersOnly() {
    for seed: UInt32 in [0, .max, 0xA5A5A5A5, 0x5A5A5A5A] {
      let pair = SystemReferencePair(seed: seed)
      for operation in [CSystem_SBS_GetBootAddress, CSystem_SBS_IncrementHDPLValue, CSystem_SBS_GetHDPLValue,
        CSystem_SBS_OpenAccessPort, CSystem_SBS_OpenDebug, CSystem_SBS_GetDebugLevel,
        CSystem_SBS_UnlockDebugConfig, CSystem_SBS_LockDebugConfig, CSystem_SBS_GetMemoryEraseStatus] {
        pair.run(operation)
      }
      for level: UInt32 in [0xB4, 0x51, 0x8A, 0x6F] {
        pair.run(CSystem_SBS_ConfigDebugLevel, a: level); pair.run(CSystem_SBS_GetDebugLevel)
      }
      for command: UInt32 in [0, 1, 0xFFFF, 0x10000, 0x80000000, 0x12345678, .max] {
        pair.run(CSystem_SBS_ConfigRSSCommand, a: command); pair.run(CSystem_SBS_GetRSSCommand)
      }
    }
  }

  func testSBSAnalogBoosterPHYAndWaitStatePreserveUnrelatedBits() {
    for seed: UInt32 in [0, .max, 0xA5A5A5A5] {
      let pair = SystemReferencePair(seed: seed)
      for operation in [CSystem_SBS_EnableIOAnalogBooster, CSystem_SBS_EnableIOAnalogSwitchVdd,
        CSystem_SBS_DisableIOAnalogBooster, CSystem_SBS_DisableIOAnalogSwitchVdd] {
        pair.run(operation)
      }
      for phy: UInt32 in [0, 0x800000] { pair.run(CSystem_SBS_ConfigEthernetPHY, a: phy) }
      for wait: UInt32 in [0, 0x10000000] { pair.run(CSystem_SBS_ConfigAXISRAMWaitState, a: wait) }
    }
  }

  func testCompensationCellAllSixteenBySixteenCodesAndRegisterChoice() {
    for selection: UInt32 in [1, 4, 0x10] {
      for nmos: UInt32 in 0..<16 {
        for pmos: UInt32 in 0..<16 {
          let pair = SystemReferencePair(seed: 0xA5A5A5A5)
          pair.run(CSystem_SBS_ConfigCompensationCell, a: selection, b: 1, c: nmos, d: pmos)
          pair.run(CSystem_SBS_GetCompensationCell, a: selection, b: 1, c: 2, d: 3)
          XCTAssertEqual(CSystem_Pointer(pair.actual, 2).pointee, nmos)
          XCTAssertEqual(CSystem_Pointer(pair.actual, 3).pointee, pmos)
          // Cell codes do not validate or consume the unused NMOS/PMOS values.
          pair.run(CSystem_SBS_ConfigCompensationCell, a: selection, b: 0, c: .max, d: .max)
          pair.run(CSystem_SBS_GetCompensationCell, a: selection, b: 1, c: 2, d: 3)
        }
      }
    }
  }

  func testCompensationGetterNullAliasingRawSelectionsAndShiftWrap() {
    let pointers: [UInt32] = [0, 1, 2, 3, 0x100 + CSystem_CCCSR.rawValue,
      0x100 + CSystem_CCVALR.rawValue, 0x100 + CSystem_CCSWVALR.rawValue]
    for selection: UInt32 in [0, 1, 4, 0x10, 3, 0x80000000, .max] {
      for code in pointers {
        for nmos in pointers {
          for pmos in pointers {
            let pair = SystemReferencePair { s in
              CSystem_Set(s, CSystem_CCCSR, 0xAAAAAAAA)
              CSystem_Set(s, CSystem_CCVALR, 0x12345678)
              CSystem_Set(s, CSystem_CCSWVALR, 0xFEDCBA98)
            }
            pair.run(CSystem_SBS_GetCompensationCell, a: selection, b: code, c: nmos, d: pmos)
          }
        }
      }
    }
  }

  func testCompensationReadyEnableAndIOHighSpeedBits() {
    for seed: UInt32 in [0, .max, 0xA5A5A5A5] {
      let pair = SystemReferencePair(seed: seed)
      for selection: UInt32 in [1, 4, 0x10] {
        pair.run(CSystem_SBS_EnableCompensationCell, a: selection)
        pair.run(CSystem_SBS_DisableCompensationCell, a: selection)
      }
      for selection: UInt32 in [0x100, 0x200, 0x400] {
        pair.run(CSystem_SBS_GetCompensationCellReadyStatus, a: selection)
      }
      for selection: UInt32 in [0x10000, 0x20000, 0x40000] {
        pair.run(CSystem_SBS_EnableIOSpeedOptimize, a: selection)
        pair.run(CSystem_SBS_DisableIOSpeedOptimize, a: selection)
      }
    }
  }

  func testTimerBreakAllCombinationsAndFPUExtraBits() {
    let bits: [UInt32] = [4, 8, 0x40, 0x80, 0x2000, 0x4000, 0x200000, 0x800000]
    for combination in 1..<256 {
      var value: UInt32 = 0
      for index in 0..<8 where combination & (1 << index) != 0 { value |= bits[index] }
      let pair = SystemReferencePair(seed: 0x55000000)
      pair.run(CSystem_SBS_ConfigTimerBreakInput, a: value)
      pair.run(CSystem_SBS_GetTimerBreakInputConfig)
    }
    for bits: UInt32 in 1..<64 {
      let pair = SystemReferencePair(seed: 0xA5A5A5A5)
      pair.run(CSystem_SBS_EnableFPUInterrupts, a: bits | 0x80000000)
      pair.run(CSystem_SBS_DisableFPUInterrupts, a: bits | 0x80000000)
    }
  }

  func testEXTIAllPinsPortsAndReservedReadback() {
    for input: UInt32 in 0..<16 {
      for port: UInt32 in [0, 1, 2, 3, 4, 5, 6, 7, 12, 13, 14, 15] {
        let pair = SystemReferencePair(seed: 0xA5A5A5A5)
        pair.run(CSystem_SBS_EXTIConfig, a: input, b: port)
        XCTAssertEqual(pair.run(CSystem_SBS_GetEXTIConfig, a: input), port)
      }
      let reserved = SystemReferencePair(seed: 0xBBBBBBBB)
      XCTAssertEqual(reserved.run(CSystem_SBS_GetEXTIConfig, a: input), 0xB)
    }
  }

  func testVREFConfigurationAllScalesImpedanceAndTrim() {
    for seed: UInt32 in [0, .max, 0xA5A5A5A5] {
      for scale: UInt32 in [0, 0x10, 0x20, 0x30] {
        for impedance: UInt32 in [0, 2] {
          let pair = SystemReferencePair(seed: seed)
          pair.run(CSystem_VREFBUF_VoltageScalingConfig, a: scale)
          pair.run(CSystem_VREFBUF_HighImpedanceConfig, a: impedance)
          pair.run(CSystem_VREFBUF_Disable)
        }
      }
      for trim: UInt32 in 0..<64 { SystemReferencePair(seed: seed).run(CSystem_VREFBUF_TrimmingConfig, a: trim) }
    }
  }

  func testVREFEnableStrictTenTickTimeoutNoFinalRecheckAndRollover() {
    for start: UInt32 in [0, .max - 5] {
      for step: UInt32 in [0, 1, 2, 11] {
        for readyCall: UInt32 in 1...14 {
          let pair = SystemReferencePair { s in
            s.pointee.tick = start; s.pointee.tickStep = step
            CSystem_ScheduleTick(s, readyCall, CSystem_VREF_CSR, 0x80000009)
          }
          pair.run(CSystem_VREFBUF_Enable)
          pair.run(CSystem_VREFBUF_Disable)
        }
      }
    }
    let initiallyReady = SystemReferencePair(seed: .max)
    initiallyReady.run(CSystem_VREFBUF_Enable)
    XCTAssertEqual(initiallyReady.actual.pointee.tickCalls, 1)
    let neverReady = SystemReferencePair()
    XCTAssertEqual(neverReady.run(CSystem_VREFBUF_Enable), 3)
    XCTAssertEqual(neverReady.actual.pointee.tickCalls, 12)
    XCTAssertEqual(CSystem_Get(neverReady.actual, CSystem_VREF_CSR), 1)
  }

  func testASIBAllInstancesQoSAndIssuingUseFullWrites() {
    for instance: UInt32 in 0..<11 {
      let pair = SystemReferencePair(seed: .max)
      pair.run(CSystem_AXIM_ASIB_EnablePacking, a: instance)
      pair.run(CSystem_AXIM_ASIB_DisablePacking, a: instance)
      for read: UInt32 in [0, 1] {
        for write: UInt32 in [0, 2] { pair.run(CSystem_AXIM_ASIB_IssuingConfig, a: instance, b: read, c: write) }
      }
      for priority: UInt32 in 0..<16 {
        pair.run(CSystem_AXIM_ASIB_ReadQoSConfig, a: instance, b: priority)
        pair.run(CSystem_AXIM_ASIB_WriteQoSConfig, a: instance, b: priority)
      }
    }
  }

  func testAMIBAllInstancesFullWritesAndFMCBankMappingReadback() {
    for instance: UInt32 in 0..<10 {
      let pair = SystemReferencePair(seed: .max)
      for operation in [CSystem_AXIM_AMIB_EnablePacking, CSystem_AXIM_AMIB_DisablePacking,
        CSystem_AXIM_AMIB_EnableLongBurst, CSystem_AXIM_AMIB_DisableLongBurst] { pair.run(operation, a: instance) }
      for read: UInt32 in [0, 1] {
        for write: UInt32 in [0, 2] {
          pair.run(CSystem_AXIM_AMIB_IssuingConfig, a: instance, b: read, c: write)
          pair.run(CSystem_AXIM_AMIB_IssuingConfigBusMatrix, a: instance, b: read, c: write)
        }
      }
    }
    for seed: UInt32 in [0, .max, 0xA5A5A5A5] {
      for mode: UInt32 in 0..<4 {
        let pair = SystemReferencePair(seed: seed) { CSystem_Set($0, CSystem_FMC_BCR1, (seed & ~0x03000000) | (mode << 24)) }
        XCTAssertEqual(pair.run(CSystem_FMC_GetBankSwapConfig), mode << 24)
        pair.run(CSystem_FMC_SetBankSwapConfig, a: 0)
        pair.run(CSystem_FMC_SetBankSwapConfig, a: 0x01000000)
        pair.run(CSystem_FMC_GetBankSwapConfig)
      }
    }
  }
}
