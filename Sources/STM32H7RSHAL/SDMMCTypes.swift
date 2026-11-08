// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDMMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SDMMCInstance: UInt32, CaseIterable, Sendable {
  case sdmmc1 = 1
  case sdmmc2 = 2
}
public enum SDMMCRegister: UInt32, CaseIterable, Sendable {
  case power = 0x0
  case clkcr = 0x4
  case arg = 0x8
  case cmd = 0xc
  case respcmd = 0x10
  case resp1 = 0x14
  case resp2 = 0x18
  case resp3 = 0x1c
  case resp4 = 0x20
  case dtimer = 0x24
  case dlen = 0x28
  case dctrl = 0x2c
  case dcount = 0x30
  case sta = 0x34
  case icr = 0x38
  case mask = 0x3c
  case acktime = 0x40
  case idmactrl = 0x50
  case idmabsize = 0x54
  case idmabaser = 0x58
  case idmalar = 0x64
  case idmabar = 0x68
  case fifo = 0x80
}
public protocol SDMMCRegisterIO {
  var instance: SDMMCInstance { get }
  func read(_ register: SDMMCRegister) -> UInt32
  func write(_ register: SDMMCRegister, value: UInt32)
  func address(of register: SDMMCRegister) -> UInt32
}
public struct SDMMC<Registers: SDMMCRegisterIO> {
  public let registers: Registers
  public init(registers: Registers) { self.registers = registers }
  func modify(_ register: SDMMCRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
