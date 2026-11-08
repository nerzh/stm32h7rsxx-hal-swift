// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NAND operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum NANDConstants {
  public static let ADDR_AREA: UInt32 = 0x20000
  public static let CMD_AREA: UInt32 = 0x10000
  public static let HAL_NAND_IT_CB_ID: UInt32 = 0x2
  public static let HAL_NAND_MSP_DEINIT_CB_ID: UInt32 = 0x1
  public static let HAL_NAND_MSP_INIT_CB_ID: UInt32 = 0x0
  public static let HAL_NAND_STATE_BUSY: UInt32 = 0x2
  public static let HAL_NAND_STATE_ERROR: UInt32 = 0x3
  public static let HAL_NAND_STATE_READY: UInt32 = 0x1
  public static let HAL_NAND_STATE_RESET: UInt32 = 0x0
  public static let NAND_BUSY: UInt32 = 0x0
  public static let NAND_CMD_AREA_A: UInt32 = 0x0
  public static let NAND_CMD_AREA_B: UInt32 = 0x1
  public static let NAND_CMD_AREA_C: UInt32 = 0x50
  public static let NAND_CMD_AREA_TRUE1: UInt32 = 0x30
  public static let NAND_CMD_ERASE0: UInt32 = 0x60
  public static let NAND_CMD_ERASE1: UInt32 = 0xd0
  public static let NAND_CMD_LOCK_STATUS: UInt32 = 0x7a
  public static let NAND_CMD_READID: UInt32 = 0x90
  public static let NAND_CMD_RESET: UInt32 = 0xff
  public static let NAND_CMD_STATUS: UInt32 = 0x70
  public static let NAND_CMD_WRITE0: UInt32 = 0x80
  public static let NAND_CMD_WRITE_TRUE1: UInt32 = 0x10
  public static let NAND_DEVICE: UInt32 = 0x8000_0000
  public static let NAND_ERROR: UInt32 = 0x1
  public static let NAND_INVALID_ADDRESS: UInt32 = 0x200
  public static let NAND_READY: UInt32 = 0x40
  public static let NAND_TIMEOUT_ERROR: UInt32 = 0x400
  public static let NAND_VALID_ADDRESS: UInt32 = 0x100
  public static let NAND_WRITE_TIMEOUT: UInt32 = 0x1000000
}
