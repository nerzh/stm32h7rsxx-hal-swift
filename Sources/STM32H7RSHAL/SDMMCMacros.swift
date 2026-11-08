// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDMMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDMMC {
  public func getFlag(_ mask: UInt32) -> Bool { (registers.read(.sta) & mask) != 0 }
  public func getInterrupt(_ mask: UInt32) -> Bool { (registers.read(.sta) & mask) == mask }
  public func clearFlag(_ mask: UInt32) { registers.write(.icr, value: mask) }
  public func clearInterrupt(_ mask: UInt32) { registers.write(.icr, value: mask) }
  public func enableInterrupts(_ mask: UInt32) { modify(.mask, set: mask) }
  public func disableInterrupts(_ mask: UInt32) { modify(.mask, clear: mask) }
  public func enableStartReadWait() { modify(.dctrl, set: 0x100) }
  public func disableStartReadWait() { modify(.dctrl, clear: 0x100) }
  public func enableStopReadWait() { modify(.dctrl, set: 0x200) }
  public func disableStopReadWait() { modify(.dctrl, clear: 0x200) }
  public func enableOperation() { modify(.dctrl, set: 0x800) }
  public func disableOperation() { modify(.dctrl, clear: 0x800) }
  public func enableSuspendCommand() { modify(.cmd, set: 0x10000) }
  public func disableSuspendCommand() { modify(.cmd, clear: 0x10000) }
  public func enableCommandTransfer() { modify(.cmd, set: 0x40) }
  public func disableCommandTransfer() { modify(.cmd, clear: 0x40) }
  public func enableCommandStop() { modify(.cmd, set: 0x80) }
  public func disableCommandStop() { modify(.cmd, clear: 0x80) }
}
