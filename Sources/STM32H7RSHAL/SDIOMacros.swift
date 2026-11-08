// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDIO {
  public func getFlag(_ mask: UInt32) -> Bool { sdmmc.getFlag(mask) }
  public func getInterrupt(_ mask: UInt32) -> Bool { sdmmc.getInterrupt(mask) }
  public func clearFlag(_ mask: UInt32) { sdmmc.clearFlag(mask) }
  public func enableInterrupts(_ mask: UInt32) { sdmmc.enableInterrupts(mask) }
  public func disableInterrupts(_ mask: UInt32) { sdmmc.disableInterrupts(mask) }
}
