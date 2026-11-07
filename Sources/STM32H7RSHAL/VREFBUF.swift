// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// VREFBUF functions from stm32h7rsxx_hal.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum VREFBUFRegister: Hashable, CaseIterable { case csr, ccr }
public protocol VREFBUFRegisterIO {
  func read(_ register: VREFBUFRegister) -> UInt32
  func write(_ register: VREFBUFRegister, value: UInt32)
}
public enum VREFBUFVoltageScale: UInt32, CaseIterable, Sendable {
  case scale0 = 0, scale1 = 0x10, scale2 = 0x20, scale3 = 0x30
}
public enum VREFBUFHighImpedance: UInt32, CaseIterable, Sendable { case disabled = 0, enabled = 2 }

public struct VREFBUF<IO: VREFBUFRegisterIO> {
  public let registers: IO
  public init(registers: IO) { self.registers = registers }
  public func configureVoltageScaling(_ scale: UInt32) {
    precondition(VREFBUFVoltageScale(rawValue: scale) != nil)
    modify(.csr, clear: 0x70, set: scale)
  }
  public func configureHighImpedance(_ mode: UInt32) {
    precondition(VREFBUFHighImpedance(rawValue: mode) != nil)
    modify(.csr, clear: 2, set: mode)
  }
  public func configureTrimming(_ value: UInt32) {
    precondition(value <= 0x3F)
    modify(.ccr, clear: 0x3F, set: value)
  }
  @discardableResult
  public func enable(getTick: () -> UInt32) -> HALStatus {
    modify(.csr, set: 1)
    let tickStart = getTick()
    while registers.read(.csr) & 8 == 0 {
      if (getTick() &- tickStart) > 10 { return .timeout }
    }
    return .ok
  }
  public func disable() { modify(.csr, clear: 1) }
  private func modify(_ register: VREFBUFRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
