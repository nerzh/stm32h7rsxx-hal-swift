// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct ETHWakeup<Registers: EXTIRegisterIO> {
  public var registers: Registers
  public init(registers: Registers) { self.registers = registers }
  public mutating func enableInterrupt(_ line: UInt32) {
    registers.write(.interruptMask(bank: 1), value: registers.read(.interruptMask(bank: 1)) | line)
  }
  public mutating func getFlag(_ line: UInt32) -> UInt32 {
    registers.read(.pending(bank: 1)) & line
  }
  public mutating func clearFlag(_ line: UInt32) { registers.write(.pending(bank: 1), value: line) }
  public mutating func enableRisingEdge(_ line: UInt32) {
    registers.write(
      .fallingTrigger(bank: 1), value: registers.read(.fallingTrigger(bank: 1)) & ~line)
    registers.write(.risingTrigger(bank: 1), value: registers.read(.risingTrigger(bank: 1)) | line)
  }
  public mutating func enableFallingEdge(_ line: UInt32) {
    registers.write(.risingTrigger(bank: 1), value: registers.read(.risingTrigger(bank: 1)) & ~line)
    registers.write(
      .fallingTrigger(bank: 1), value: registers.read(.fallingTrigger(bank: 1)) | line)
  }
  public mutating func enableRisingFallingEdge(_ line: UInt32) {
    registers.write(.risingTrigger(bank: 1), value: registers.read(.risingTrigger(bank: 1)) | line)
    registers.write(
      .fallingTrigger(bank: 1), value: registers.read(.fallingTrigger(bank: 1)) | line)
  }
  public mutating func generateSoftwareInterrupt(_ line: UInt32) {
    registers.write(
      .softwareInterrupt(bank: 1), value: registers.read(.softwareInterrupt(bank: 1)) | line)
  }
}
