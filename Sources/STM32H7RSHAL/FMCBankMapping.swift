// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of HAL_FMC_{Set,Get}BankSwapConfig in stm32h7rsxx_hal.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum FMCBankSwapMode: UInt32, CaseIterable, Sendable {
  case mode0 = 0
  case mode1 = 0x0100_0000
}
public enum FMCBankMappingRegister: Hashable, CaseIterable { case bcr1 }
public protocol FMCBankMappingRegisterIO {
  func read(_ register: FMCBankMappingRegister) -> UInt32
  func write(_ register: FMCBankMappingRegister, value: UInt32)
}

public struct FMCBankMapping<IO: FMCBankMappingRegisterIO> {
  public let registers: IO
  public init(registers: IO) { self.registers = registers }

  public func setBankSwapConfiguration(_ configuration: UInt32) {
    precondition(configuration == 0 || configuration == 0x0100_0000)
    let value = (registers.read(.bcr1) & ~UInt32(0x0300_0000)) | configuration
    registers.write(.bcr1, value: value)
  }
  public func setBankSwapConfiguration(_ configuration: FMCBankSwapMode) {
    setBankSwapConfiguration(configuration.rawValue)
  }

  // Preserve both raw BMAP bits, including encodings not accepted by the setter.
  public func getBankSwapConfiguration() -> UInt32 { registers.read(.bcr1) & 0x0300_0000 }
}
