// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum FMCRegister: Hashable, Sendable {
  case btcr(UInt32)
  case bwtr(UInt32)
  case pcr, sr, pmem, patt, eccr
  case sdcr(UInt32)
  case sdtr(UInt32)
  case sdcmr, sdrtr, sdsr
}
public protocol FMCRegisterIO {
  func read(_ register: FMCRegister) -> UInt32
  func write(_ register: FMCRegister, value: UInt32)
}
public struct FMC<Registers: FMCRegisterIO> {
  public let registers: Registers
  public init(registers: Registers) { self.registers = registers }
  func modify(_ register: FMCRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}

// External memory uses the existing width-preserving bus and barrier interface.
public typealias FMCMemoryIO = FlashMemoryIO
