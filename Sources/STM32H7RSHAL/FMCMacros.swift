// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension FMC {
  public func enable() { modify(.btcr(0), set: 0x8000_0000) }
  public func disable() { modify(.btcr(0), clear: 0x8000_0000) }
  public func enableNORSRAM(_ bank: UInt32) { modify(.btcr(bank), set: 1) }
  public func disableNORSRAM(_ bank: UInt32) { modify(.btcr(bank), clear: 1) }
  public func enableNAND() { modify(.pcr, set: 4) }
  public func disableNAND() { modify(.pcr, clear: 4) }
  public func enableNANDInterrupts(_ mask: UInt32) { modify(.sr, set: mask) }
  public func disableNANDInterrupts(_ mask: UInt32) { modify(.sr, clear: mask) }
  public func getNANDFlag(_ mask: UInt32) -> Bool { (registers.read(.sr) & mask) == mask }
  public func clearNANDFlag(_ mask: UInt32) { modify(.sr, clear: mask) }
  public func enableSDRAMInterrupts(_ mask: UInt32) { modify(.sdrtr, set: mask) }
  public func disableSDRAMInterrupts(_ mask: UInt32) { modify(.sdrtr, clear: mask) }
  public func getSDRAMFlag(_ mask: UInt32) -> Bool { (registers.read(.sdsr) & mask) == mask }
  public func clearSDRAMFlag(_ mask: UInt32) { modify(.sdrtr, set: mask) }
}
