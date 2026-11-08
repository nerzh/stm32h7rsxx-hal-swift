// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NOR operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum NORConstants {
  public static let CFI1_ADDRESS: UInt32 = 0x61
  public static let CFI2_ADDRESS: UInt32 = 0x62
  public static let CFI3_ADDRESS: UInt32 = 0x63
  public static let CFI4_ADDRESS: UInt32 = 0x64
  public static let DEVICE_CODE1_ADDR: UInt32 = 0x1
  public static let DEVICE_CODE2_ADDR: UInt32 = 0xe
  public static let DEVICE_CODE3_ADDR: UInt32 = 0xf
  public static let HAL_NOR_MSP_DEINIT_CB_ID: UInt32 = 0x1
  public static let HAL_NOR_MSP_INIT_CB_ID: UInt32 = 0x0
  public static let HAL_NOR_STATE_BUSY: UInt32 = 0x2
  public static let HAL_NOR_STATE_ERROR: UInt32 = 0x3
  public static let HAL_NOR_STATE_PROTECTED: UInt32 = 0x4
  public static let HAL_NOR_STATE_READY: UInt32 = 0x1
  public static let HAL_NOR_STATE_RESET: UInt32 = 0x0
  public static let HAL_NOR_STATUS_ERROR: UInt32 = 0x2
  public static let HAL_NOR_STATUS_ONGOING: UInt32 = 0x1
  public static let HAL_NOR_STATUS_SUCCESS: UInt32 = 0x0
  public static let HAL_NOR_STATUS_TIMEOUT: UInt32 = 0x3
  public static let MC_ADDRESS: UInt32 = 0x0
  public static let NOR_MEMORY_16B: UInt32 = 0x1
  public static let NOR_MEMORY_8B: UInt32 = 0x0
  public static let NOR_MEMORY_ADRESS1: UInt32 = 0x6000_0000
  public static let NOR_MEMORY_ADRESS2: UInt32 = 0x6400_0000
  public static let NOR_MEMORY_ADRESS3: UInt32 = 0x6800_0000
  public static let NOR_MEMORY_ADRESS4: UInt32 = 0x6c00_0000
  public static let NOR_TMEOUT: UInt32 = 0xffff
}
