// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SDIOConstants {
  public static let HAL_SDIOS_DATA_RATE_DDR50: UInt32 = 0x3
  public static let HAL_SDIOS_DATA_RATE_SDR12: UInt32 = 0x0
  public static let HAL_SDIOS_DATA_RATE_SDR25: UInt32 = 0x1
  public static let HAL_SDIOS_DATA_RATE_SDR50: UInt32 = 0x2
  public static let HAL_SDIO_1_WIRE_MODE: UInt32 = 0x0
  public static let HAL_SDIO_4_WIRES_MODE: UInt32 = 0x1
  public static let HAL_SDIO_BUS_WIDTH_8BIT_NOT_SUPPORTED: UInt32 = 0x0
  public static let HAL_SDIO_BUS_WIDTH_8BIT_SUPPORTED: UInt32 = 0x1
  public static let HAL_SDIO_DATA_BLOCK_SIZE_1024BYTE: UInt32 = 0x400
  public static let HAL_SDIO_DATA_BLOCK_SIZE_128BYTE: UInt32 = 0x80
  public static let HAL_SDIO_DATA_BLOCK_SIZE_16BYTE: UInt32 = 0x10
  public static let HAL_SDIO_DATA_BLOCK_SIZE_1BYTE: UInt32 = 0x1
  public static let HAL_SDIO_DATA_BLOCK_SIZE_2048BYTE: UInt32 = 0x800
  public static let HAL_SDIO_DATA_BLOCK_SIZE_256BYTE: UInt32 = 0x100
  public static let HAL_SDIO_DATA_BLOCK_SIZE_2BYTE: UInt32 = 0x2
  public static let HAL_SDIO_DATA_BLOCK_SIZE_32BYTE: UInt32 = 0x20
  public static let HAL_SDIO_DATA_BLOCK_SIZE_4BYTE: UInt32 = 0x4
  public static let HAL_SDIO_DATA_BLOCK_SIZE_512BYTE: UInt32 = 0x200
  public static let HAL_SDIO_DATA_BLOCK_SIZE_64BYTE: UInt32 = 0x40
  public static let HAL_SDIO_DATA_BLOCK_SIZE_8BYTE: UInt32 = 0x8
  public static let HAL_SDIO_ERROR_CB_ID: UInt32 = 0x2
  public static let HAL_SDIO_ERROR_DATA_CRC_FAIL: UInt32 = 0x2
  public static let HAL_SDIO_ERROR_DATA_TIMEOUT: UInt32 = 0x8
  public static let HAL_SDIO_ERROR_INVALID_CALLBACK: UInt32 = 0x8000000
  public static let HAL_SDIO_ERROR_NONE: UInt32 = 0x0
  public static let HAL_SDIO_ERROR_RX_OVERRUN: UInt32 = 0x20
  public static let HAL_SDIO_ERROR_TIMEOUT: UInt32 = 0x8000_0000
  public static let HAL_SDIO_ERROR_TX_UNDERRUN: UInt32 = 0x10
  public static let HAL_SDIO_FBR_SUPPORT_CSA: UInt32 = 0x1
  public static let HAL_SDIO_FBR_SUPPORT_POWER_SELECTION: UInt32 = 0x1
  public static let HAL_SDIO_FUNCTION_0: UInt32 = 0x0
  public static let HAL_SDIO_FUNCTION_1: UInt32 = 0x1
  public static let HAL_SDIO_FUNCTION_2: UInt32 = 0x2
  public static let HAL_SDIO_FUNCTION_3: UInt32 = 0x3
  public static let HAL_SDIO_FUNCTION_4: UInt32 = 0x4
  public static let HAL_SDIO_FUNCTION_5: UInt32 = 0x5
  public static let HAL_SDIO_FUNCTION_6: UInt32 = 0x6
  public static let HAL_SDIO_FUNCTION_7: UInt32 = 0x7
  public static let HAL_SDIO_MODE_BLOCK: UInt32 = 0x1
  public static let HAL_SDIO_MODE_BYTE: UInt32 = 0x0
  public static let HAL_SDIO_MSP_DEINIT_CB_ID: UInt32 = 0x11
  public static let HAL_SDIO_MSP_INIT_CB_ID: UInt32 = 0x10
  public static let HAL_SDIO_OP_CODE_AUTO_INC: UInt32 = 0x1
  public static let HAL_SDIO_OP_CODE_NO_INC: UInt32 = 0x0
  public static let HAL_SDIO_READ_AFTER_WRITE: UInt32 = 0x1
  public static let HAL_SDIO_RX_CPLT_CB_ID: UInt32 = 0x1
  public static let HAL_SDIO_STATE_BUSY: UInt32 = 0x2
  public static let HAL_SDIO_STATE_READY: UInt32 = 0x1
  public static let HAL_SDIO_STATE_RESET: UInt32 = 0x0
  public static let HAL_SDIO_TX_CPLT_CB_ID: UInt32 = 0x0
  public static let HAL_SDIO_WRITE_ONLY: UInt32 = 0x0
  public static let SDIO_CONTEXT_DMA: UInt32 = 0x80
  public static let SDIO_CONTEXT_IT: UInt32 = 0x8
  public static let SDIO_CONTEXT_NONE: UInt32 = 0x0
  public static let SDIO_CONTEXT_READ_MULTIPLE_BLOCK: UInt32 = 0x2
  public static let SDIO_CONTEXT_READ_SINGLE_BLOCK: UInt32 = 0x1
  public static let SDIO_CONTEXT_WRITE_MULTIPLE_BLOCK: UInt32 = 0x20
  public static let SDIO_CONTEXT_WRITE_SINGLE_BLOCK: UInt32 = 0x10
  public static let SDIO_MAX_IO_NUMBER: UInt32 = 0x7
}
