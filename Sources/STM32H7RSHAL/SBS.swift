// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SBS functions and macros from stm32h7rsxx_hal.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SBSRegister: Hashable {
  case bootsr, hdplcr, hdplsr, dbgcr, dbglockr, rsscmdr, pmcr, fpuimr, mesr
  case cccsr, ccvalr, ccswvalr, bklockr
  case extiConfiguration(index: Int)
}
public protocol SBSRegisterIO {
  func read(_ register: SBSRegister) -> UInt32
  func write(_ register: SBSRegister, value: UInt32)
}
public enum SBSHDPL: UInt32, CaseIterable, Sendable {
  case level0 = 0xB4, level1 = 0x51, level2 = 0x8A, level3 = 0x6F
}
public enum SBSEthernetPHY: UInt32, CaseIterable, Sendable { case gmiiOrMII = 0, rmii = 0x0080_0000 }
public enum SBSAXISRAMWaitState: UInt32, CaseIterable, Sendable { case zero = 0, one = 0x1000_0000 }
public enum SBSCompensationCell: UInt32, CaseIterable, Sendable { case analog = 1, xspi1 = 4, xspi2 = 0x10 }
public enum SBSCompensationCellReady: UInt32, CaseIterable, Sendable {
  case analog = 0x100, xspi1 = 0x200, xspi2 = 0x400
}
public enum SBSCompensationCode: UInt32, CaseIterable, Sendable { case cell = 0, register = 1 }
public enum SBSIOSpeedOptimization: UInt32, CaseIterable, Sendable {
  case analog = 0x0001_0000, xspi1 = 0x0002_0000, xspi2 = 0x0004_0000
}
public struct SBSTimerBreakInputs: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let pvd = Self(rawValue: 4)
  public static let flashECC = Self(rawValue: 8)
  public static let coreLockup = Self(rawValue: 0x40)
  public static let backupRAMECC = Self(rawValue: 0x80)
  public static let dtcmECC = Self(rawValue: 0x2000)
  public static let itcmECC = Self(rawValue: 0x4000)
  public static let axiSRAM3ECC = Self(rawValue: 0x0020_0000)
  public static let axiSRAM1ECC = Self(rawValue: 0x0080_0000)
}
public struct SBSFPUInterrupts: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let invalidOperation = Self(rawValue: 1)
  public static let divideByZero = Self(rawValue: 2)
  public static let underflow = Self(rawValue: 4)
  public static let overflow = Self(rawValue: 8)
  public static let inputDenormal = Self(rawValue: 0x10)
  public static let inexact = Self(rawValue: 0x20)
}

public struct SBS<IO: SBSRegisterIO> {
  public let registers: IO
  public init(registers: IO) { self.registers = registers }

  public func getBootAddress() -> UInt32 { registers.read(.bootsr) }
  public func incrementHDPLValue() { modify(.hdplcr, clear: 0xFF, set: 0x6A) }
  public func getHDPLValue() -> UInt32 { registers.read(.hdplsr) & 0xFF }
  public func openAccessPort() { modify(.dbgcr, clear: 0xFF, set: 0xB4) }
  public func openDebug() { modify(.dbgcr, clear: 0xFF00, set: 0xB400) }
  @discardableResult
  public func configureDebugLevel(_ level: UInt32) -> HALStatus {
    precondition(SBSHDPL(rawValue: level) != nil)
    if level != 0xB4 {
      modify(.dbgcr, clear: 0x00FF_0000, set: level << 16)
      return .ok
    }
    return .error
  }
  public func getDebugLevel() -> UInt32 { (registers.read(.dbgcr) & 0x00FF_0000) >> 16 }
  public func unlockDebugConfiguration() { modify(.dbglockr, clear: 0xFF, set: 0xB4) }
  public func lockDebugConfiguration() { modify(.dbglockr, clear: 0xFF, set: 0xC3) }
  public func configureRSSCommand(_ command: UInt32) {
    // The C function does not mask or assert the command before MODIFY_REG.
    modify(.rsscmdr, clear: 0xFFFF, set: command)
  }
  public func getRSSCommand() -> UInt32 { registers.read(.rsscmdr) & 0xFFFF }

  public func enableIOAnalogBooster() { modify(.pmcr, clear: 0x300, set: 0x100) }
  public func disableIOAnalogBooster() { modify(.pmcr, clear: 0x100) }
  public func enableIOAnalogSwitchVDD() { modify(.pmcr, clear: 0x300, set: 0x200) }
  public func disableIOAnalogSwitchVDD() { modify(.pmcr, clear: 0x200) }
  public func configureEthernetPHY(_ configuration: UInt32) {
    precondition(SBSEthernetPHY(rawValue: configuration) != nil)
    modify(.pmcr, clear: 0x00E0_0000, set: configuration)
  }
  public func configureAXISRAMWaitState(_ configuration: UInt32) {
    precondition(SBSAXISRAMWaitState(rawValue: configuration) != nil)
    modify(.pmcr, clear: 0x1000_0000, set: configuration)
  }

  public func enableCompensationCell(_ selection: UInt32) {
    precondition(SBSCompensationCell(rawValue: selection) != nil)
    modify(.cccsr, set: selection)
  }
  public func disableCompensationCell(_ selection: UInt32) {
    precondition(SBSCompensationCell(rawValue: selection) != nil)
    modify(.cccsr, clear: selection)
  }
  public func getCompensationCellReadyStatus(_ selection: UInt32) -> UInt32 {
    precondition(SBSCompensationCellReady(rawValue: selection) != nil)
    return registers.read(.cccsr) & selection == 0 ? 0 : 1
  }
  public func configureCompensationCell(_ selection: UInt32, code: UInt32,
                                        nmosValue: UInt32, pmosValue: UInt32) {
    precondition(SBSCompensationCell(rawValue: selection) != nil)
    precondition(SBSCompensationCode(rawValue: code) != nil)
    if code == 1 {
      precondition(nmosValue < 16 && pmosValue < 16)
      let offset: UInt32 = selection == 1 ? 0 : selection == 4 ? 8 : 16
      modify(.ccswvalr, clear: 0xFF << offset,
             set: (nmosValue << offset) | (pmosValue << (offset + 4)))
    }
    modify(.cccsr, clear: selection << 1,
           set: code << (selection.trailingZeroBitCount + 1))
  }
  @discardableResult
  public func getCompensationCell(_ selection: UInt32, code: UnsafeMutablePointer<UInt32>?,
                                  nmosValue: UnsafeMutablePointer<UInt32>?,
                                  pmosValue: UnsafeMutablePointer<UInt32>?) -> HALStatus {
    guard let code, let nmosValue, let pmosValue else { return .error }
    // Optional raw pointers retain the C null and aliasing semantics. Write the
    // code before choosing the value register, then NMOS before PMOS.
    code.pointee = registers.read(.cccsr) & (selection << 1) == 0 ? 0 : 1
    let value = code.pointee == 0 ? registers.read(.ccvalr) : registers.read(.ccswvalr)
    let offset: UInt32 = selection == 1 ? 0 : selection == 4 ? 8 : 16
    nmosValue.pointee = (value >> offset) & 0xF
    pmosValue.pointee = (value >> (offset + 4)) & 0xF
    return .ok
  }

  public func enableIOSpeedOptimization(_ selection: UInt32) {
    precondition(SBSIOSpeedOptimization(rawValue: selection) != nil)
    modify(.cccsr, set: selection)
  }
  public func disableIOSpeedOptimization(_ selection: UInt32) {
    precondition(SBSIOSpeedOptimization(rawValue: selection) != nil)
    modify(.cccsr, clear: selection)
  }
  // BKLOCKR configuration remains set until system reset, as in the C HAL.
  public func configureTimerBreakInput(_ input: UInt32) {
    precondition(input & 0x00A0_60CC != 0 && input & ~UInt32(0x00A0_60CC) == 0)
    modify(.bklockr, set: input)
  }
  public func getTimerBreakInputConfiguration() -> UInt32 { registers.read(.bklockr) & 0x00A0_60CC }
  public func configureEXTI(_ input: UInt32, port: UInt32) {
    precondition(input < 16)
    precondition(GPIOPort(rawValue: port) != nil)
    let register = Int(input / 4)
    let offset = 4 * (input % 4)
    modify(.extiConfiguration(index: register), clear: 0xF << offset, set: port << offset)
  }
  public func configureEXTI(_ input: UInt32, port: GPIOPort) { configureEXTI(input, port: port.rawValue) }
  public func getEXTIConfiguration(_ input: UInt32) -> UInt32 {
    precondition(input < 16)
    let register = Int(input / 4)
    let offset = 4 * (input % 4)
    return (registers.read(.extiConfiguration(index: register)) & (0xF << offset)) >> offset
  }

  public func enableFPUInterrupts(_ interrupts: UInt32) {
    // IS_SBS_FPU_INTERRUPT requires any known bit; it permits extra bits.
    precondition(interrupts & 0x3F != 0)
    modify(.fpuimr, set: interrupts)
  }
  public func disableFPUInterrupts(_ interrupts: UInt32) {
    precondition(interrupts & 0x3F != 0)
    modify(.fpuimr, clear: interrupts)
  }
  public func enableFPUInterrupts(_ interrupts: SBSFPUInterrupts) { enableFPUInterrupts(interrupts.rawValue) }
  public func disableFPUInterrupts(_ interrupts: SBSFPUInterrupts) { disableFPUInterrupts(interrupts.rawValue) }
  public func getMemoryEraseStatus() -> UInt32 { registers.read(.mesr) & 1 }

  private func modify(_ register: SBSRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
