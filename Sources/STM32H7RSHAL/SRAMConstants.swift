// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SRAM operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SRAMConstants {
  public static let HAL_SRAM_DMA_XFER_CPLT_CB_ID: UInt32 = 0x2
  public static let HAL_SRAM_DMA_XFER_ERR_CB_ID: UInt32 = 0x3
  public static let HAL_SRAM_MSP_DEINIT_CB_ID: UInt32 = 0x1
  public static let HAL_SRAM_MSP_INIT_CB_ID: UInt32 = 0x0
  public static let HAL_SRAM_STATE_BUSY: UInt32 = 0x2
  public static let HAL_SRAM_STATE_ERROR: UInt32 = 0x3
  public static let HAL_SRAM_STATE_PROTECTED: UInt32 = 0x4
  public static let HAL_SRAM_STATE_READY: UInt32 = 0x1
  public static let HAL_SRAM_STATE_RESET: UInt32 = 0x0
}
