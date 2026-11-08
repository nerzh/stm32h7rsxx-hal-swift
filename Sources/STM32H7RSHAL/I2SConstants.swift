// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum I2SConstants {
  public static let HAL_I2S_ERROR_CB_ID: UInt32 = 0x6
  public static let HAL_I2S_ERROR_DMA: UInt32 = 0x8
  public static let HAL_I2S_ERROR_FRE: UInt32 = 0x20
  public static let HAL_I2S_ERROR_INVALID_CALLBACK: UInt32 = 0x100
  public static let HAL_I2S_ERROR_NONE: UInt32 = 0x0
  public static let HAL_I2S_ERROR_NOT_SUPPORTED: UInt32 = 0x80
  public static let HAL_I2S_ERROR_NO_OGT: UInt32 = 0x40
  public static let HAL_I2S_ERROR_OVR: UInt32 = 0x2
  public static let HAL_I2S_ERROR_PRESCALER: UInt32 = 0x10
  public static let HAL_I2S_ERROR_TIMEOUT: UInt32 = 0x1
  public static let HAL_I2S_ERROR_UDR: UInt32 = 0x4
  public static let HAL_I2S_MSPDEINIT_CB_ID: UInt32 = 0x8
  public static let HAL_I2S_MSPINIT_CB_ID: UInt32 = 0x7
  public static let HAL_I2S_RX_COMPLETE_CB_ID: UInt32 = 0x1
  public static let HAL_I2S_RX_HALF_COMPLETE_CB_ID: UInt32 = 0x4
  public static let HAL_I2S_STATE_BUSY: UInt32 = 0x2
  public static let HAL_I2S_STATE_BUSY_RX: UInt32 = 0x4
  public static let HAL_I2S_STATE_BUSY_TX: UInt32 = 0x3
  public static let HAL_I2S_STATE_BUSY_TX_RX: UInt32 = 0x5
  public static let HAL_I2S_STATE_ERROR: UInt32 = 0x7
  public static let HAL_I2S_STATE_READY: UInt32 = 0x1
  public static let HAL_I2S_STATE_RESET: UInt32 = 0x0
  public static let HAL_I2S_STATE_TIMEOUT: UInt32 = 0x6
  public static let HAL_I2S_TX_COMPLETE_CB_ID: UInt32 = 0x0
  public static let HAL_I2S_TX_HALF_COMPLETE_CB_ID: UInt32 = 0x3
  public static let HAL_I2S_TX_RX_COMPLETE_CB_ID: UInt32 = 0x2
  public static let HAL_I2S_TX_RX_HALF_COMPLETE_CB_ID: UInt32 = 0x5
  public static let I2S_AUDIOFREQ_11K: UInt32 = 0x2b11
  public static let I2S_AUDIOFREQ_16K: UInt32 = 0x3e80
  public static let I2S_AUDIOFREQ_192K: UInt32 = 0x2ee00
  public static let I2S_AUDIOFREQ_22K: UInt32 = 0x5622
  public static let I2S_AUDIOFREQ_32K: UInt32 = 0x7d00
  public static let I2S_AUDIOFREQ_44K: UInt32 = 0xac44
  public static let I2S_AUDIOFREQ_48K: UInt32 = 0xbb80
  public static let I2S_AUDIOFREQ_8K: UInt32 = 0x1f40
  public static let I2S_AUDIOFREQ_96K: UInt32 = 0x17700
  public static let I2S_AUDIOFREQ_DEFAULT: UInt32 = 0x2
  public static let I2S_CPOL_HIGH: UInt32 = 0x800
  public static let I2S_CPOL_LOW: UInt32 = 0x0
  public static let I2S_DATAFORMAT_16B: UInt32 = 0x0
  public static let I2S_DATAFORMAT_16B_EXTENDED: UInt32 = 0x400
  public static let I2S_DATAFORMAT_24B: UInt32 = 0x100
  public static let I2S_DATAFORMAT_32B: UInt32 = 0x200
  public static let I2S_DATA_24BIT_ALIGNMENT_LEFT: UInt32 = 0x4000
  public static let I2S_DATA_24BIT_ALIGNMENT_RIGHT: UInt32 = 0x0
  public static let I2S_FIRSTBIT_LSB: UInt32 = 0x800000
  public static let I2S_FIRSTBIT_MSB: UInt32 = 0x0
  public static let I2S_FLAG_DXP: UInt32 = 0x4
  public static let I2S_FLAG_FRE: UInt32 = 0x100
  public static let I2S_FLAG_MASK: UInt32 = 0x167
  public static let I2S_FLAG_OVR: UInt32 = 0x40
  public static let I2S_FLAG_RXP: UInt32 = 0x1
  public static let I2S_FLAG_TXP: UInt32 = 0x2
  public static let I2S_FLAG_UDR: UInt32 = 0x20
  public static let I2S_IT_DXP: UInt32 = 0x4
  public static let I2S_IT_ERR: UInt32 = 0x160
  public static let I2S_IT_FRE: UInt32 = 0x100
  public static let I2S_IT_OVR: UInt32 = 0x40
  public static let I2S_IT_RXP: UInt32 = 0x1
  public static let I2S_IT_TXP: UInt32 = 0x2
  public static let I2S_IT_UDR: UInt32 = 0x20
  public static let I2S_MASTER_KEEP_IO_STATE_DISABLE: UInt32 = 0x0
  public static let I2S_MASTER_KEEP_IO_STATE_ENABLE: UInt32 = 0x8000_0000
  public static let I2S_MCLKOUTPUT_DISABLE: UInt32 = 0x0
  public static let I2S_MCLKOUTPUT_ENABLE: UInt32 = 0x2000000
  public static let I2S_MODE_MASTER_FULLDUPLEX: UInt32 = 0xa
  public static let I2S_MODE_MASTER_RX: UInt32 = 0x6
  public static let I2S_MODE_MASTER_TX: UInt32 = 0x4
  public static let I2S_MODE_SLAVE_FULLDUPLEX: UInt32 = 0x8
  public static let I2S_MODE_SLAVE_RX: UInt32 = 0x2
  public static let I2S_MODE_SLAVE_TX: UInt32 = 0x0
  public static let I2S_STANDARD_LSB: UInt32 = 0x20
  public static let I2S_STANDARD_MSB: UInt32 = 0x10
  public static let I2S_STANDARD_PCM_LONG: UInt32 = 0xb0
  public static let I2S_STANDARD_PCM_SHORT: UInt32 = 0x30
  public static let I2S_STANDARD_PHILIPS: UInt32 = 0x0
  public static let I2S_WS_INVERSION_DISABLE: UInt32 = 0x0
  public static let I2S_WS_INVERSION_ENABLE: UInt32 = 0x2000
}
