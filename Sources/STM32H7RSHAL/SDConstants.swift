// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SDConstants {
  public static let BLOCKSIZE: UInt32 = 0x200
  public static let CARD_HIGH_SPEED: UInt32 = 0x100
  public static let CARD_NORMAL_SPEED: UInt32 = 0x0
  public static let CARD_SDHC_SDXC: UInt32 = 0x1
  public static let CARD_SDSC: UInt32 = 0x0
  public static let CARD_SECURED: UInt32 = 0x3
  public static let CARD_ULTRA_HIGH_SPEED: UInt32 = 0x200
  public static let CARD_V1_X: UInt32 = 0x0
  public static let CARD_V2_X: UInt32 = 0x1
  public static let HAL_SD_ABORT_CB_ID: UInt32 = 0x3
  public static let HAL_SD_CARD_DISCONNECTED: UInt32 = 0x8
  public static let HAL_SD_CARD_ERROR: UInt32 = 0xff
  public static let HAL_SD_CARD_IDENTIFICATION: UInt32 = 0x2
  public static let HAL_SD_CARD_PROGRAMMING: UInt32 = 0x7
  public static let HAL_SD_CARD_READY: UInt32 = 0x1
  public static let HAL_SD_CARD_RECEIVING: UInt32 = 0x6
  public static let HAL_SD_CARD_SENDING: UInt32 = 0x5
  public static let HAL_SD_CARD_STANDBY: UInt32 = 0x3
  public static let HAL_SD_CARD_TRANSFER: UInt32 = 0x4
  public static let HAL_SD_ERROR_ADDR_MISALIGNED: UInt32 = 0x40
  public static let HAL_SD_ERROR_ADDR_OUT_OF_RANGE: UInt32 = 0x2000000
  public static let HAL_SD_ERROR_AKE_SEQ_ERR: UInt32 = 0x800000
  public static let HAL_SD_ERROR_BAD_ERASE_PARAM: UInt32 = 0x200
  public static let HAL_SD_ERROR_BLOCK_LEN_ERR: UInt32 = 0x80
  public static let HAL_SD_ERROR_BUSY: UInt32 = 0x2000_0000
  public static let HAL_SD_ERROR_CARD_ECC_DISABLED: UInt32 = 0x200000
  public static let HAL_SD_ERROR_CARD_ECC_FAILED: UInt32 = 0x4000
  public static let HAL_SD_ERROR_CB_ID: UInt32 = 0x2
  public static let HAL_SD_ERROR_CC_ERR: UInt32 = 0x8000
  public static let HAL_SD_ERROR_CID_CSD_OVERWRITE: UInt32 = 0x80000
  public static let HAL_SD_ERROR_CMD_CRC_FAIL: UInt32 = 0x1
  public static let HAL_SD_ERROR_CMD_RSP_TIMEOUT: UInt32 = 0x4
  public static let HAL_SD_ERROR_COM_CRC_FAILED: UInt32 = 0x1000
  public static let HAL_SD_ERROR_DATA_CRC_FAIL: UInt32 = 0x2
  public static let HAL_SD_ERROR_DATA_TIMEOUT: UInt32 = 0x8
  public static let HAL_SD_ERROR_DMA: UInt32 = 0x4000_0000
  public static let HAL_SD_ERROR_ERASE_RESET: UInt32 = 0x400000
  public static let HAL_SD_ERROR_ERASE_SEQ_ERR: UInt32 = 0x100
  public static let HAL_SD_ERROR_GENERAL_UNKNOWN_ERR: UInt32 = 0x10000
  public static let HAL_SD_ERROR_ILLEGAL_CMD: UInt32 = 0x2000
  public static let HAL_SD_ERROR_INVALID_CALLBACK: UInt32 = 0x8000000
  public static let HAL_SD_ERROR_INVALID_VOLTRANGE: UInt32 = 0x1000000
  public static let HAL_SD_ERROR_LOCK_UNLOCK_FAILED: UInt32 = 0x800
  public static let HAL_SD_ERROR_NONE: UInt32 = 0x0
  public static let HAL_SD_ERROR_PARAM: UInt32 = 0x8000000
  public static let HAL_SD_ERROR_REQUEST_NOT_APPLICABLE: UInt32 = 0x4000000
  public static let HAL_SD_ERROR_RX_OVERRUN: UInt32 = 0x20
  public static let HAL_SD_ERROR_STREAM_READ_UNDERRUN: UInt32 = 0x20000
  public static let HAL_SD_ERROR_STREAM_WRITE_OVERRUN: UInt32 = 0x40000
  public static let HAL_SD_ERROR_TIMEOUT: UInt32 = 0x8000_0000
  public static let HAL_SD_ERROR_TX_UNDERRUN: UInt32 = 0x10
  public static let HAL_SD_ERROR_UNSUPPORTED_FEATURE: UInt32 = 0x1000_0000
  public static let HAL_SD_ERROR_WP_ERASE_SKIP: UInt32 = 0x100000
  public static let HAL_SD_ERROR_WRITE_PROT_VIOLATION: UInt32 = 0x400
  public static let HAL_SD_MSP_DEINIT_CB_ID: UInt32 = 0x11
  public static let HAL_SD_MSP_INIT_CB_ID: UInt32 = 0x10
  public static let HAL_SD_READ_DMA_LNKLST_BUF_CPLT_CB_ID: UInt32 = 0x4
  public static let HAL_SD_RX_CPLT_CB_ID: UInt32 = 0x1
  public static let HAL_SD_STATE_BUSY: UInt32 = 0x3
  public static let HAL_SD_STATE_ERROR: UInt32 = 0xf
  public static let HAL_SD_STATE_PROGRAMMING: UInt32 = 0x4
  public static let HAL_SD_STATE_READY: UInt32 = 0x1
  public static let HAL_SD_STATE_RECEIVING: UInt32 = 0x5
  public static let HAL_SD_STATE_RESET: UInt32 = 0x0
  public static let HAL_SD_STATE_TIMEOUT: UInt32 = 0x2
  public static let HAL_SD_STATE_TRANSFER: UInt32 = 0x6
  public static let HAL_SD_TX_CPLT_CB_ID: UInt32 = 0x0
  public static let HAL_SD_WRITE_DMA_LNKLST_BUF_CPLT_CB_ID: UInt32 = 0x5
  public static let SD_CONTEXT_DMA: UInt32 = 0x80
  public static let SD_CONTEXT_IT: UInt32 = 0x8
  public static let SD_CONTEXT_NONE: UInt32 = 0x0
  public static let SD_CONTEXT_READ_MULTIPLE_BLOCK: UInt32 = 0x2
  public static let SD_CONTEXT_READ_SINGLE_BLOCK: UInt32 = 0x1
  public static let SD_CONTEXT_WRITE_MULTIPLE_BLOCK: UInt32 = 0x20
  public static let SD_CONTEXT_WRITE_SINGLE_BLOCK: UInt32 = 0x10
}
