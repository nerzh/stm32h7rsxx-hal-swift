// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_SPI_SR_RXP: UInt32 = 0x0000_0001
public let LL_SPI_SR_TXP: UInt32 = 0x0000_0002
public let LL_SPI_SR_DXP: UInt32 = 0x0000_0004
public let LL_SPI_SR_EOT: UInt32 = 0x0000_0008
public let LL_SPI_SR_TXTF: UInt32 = 0x0000_0010
public let LL_SPI_SR_UDR: UInt32 = 0x0000_0020
public let LL_SPI_SR_CRCE: UInt32 = 0x0000_0080
public let LL_SPI_SR_MODF: UInt32 = 0x0000_0200
public let LL_SPI_SR_OVR: UInt32 = 0x0000_0040
public let LL_SPI_SR_TIFRE: UInt32 = 0x0000_0100
public let LL_SPI_SR_SUSP: UInt32 = 0x0000_0800
public let LL_SPI_SR_TXC: UInt32 = 0x0000_1000
public let LL_SPI_SR_RXWNE: UInt32 = 0x0000_8000
public let LL_SPI_IER_RXPIE: UInt32 = 0x0000_0001
public let LL_SPI_IER_TXPIE: UInt32 = 0x0000_0002
public let LL_SPI_IER_DXPIE: UInt32 = 0x0000_0004
public let LL_SPI_IER_EOTIE: UInt32 = 0x0000_0008
public let LL_SPI_IER_TXTFIE: UInt32 = 0x0000_0010
public let LL_SPI_IER_UDRIE: UInt32 = 0x0000_0020
public let LL_SPI_IER_OVRIE: UInt32 = 0x0000_0040
public let LL_SPI_IER_CRCEIE: UInt32 = 0x0000_0080
public let LL_SPI_IER_TIFREIE: UInt32 = 0x0000_0100
public let LL_SPI_IER_MODFIE: UInt32 = 0x0000_0200
public let LL_SPI_MODE_MASTER: UInt32 = 0x0040_0000
public let LL_SPI_MODE_SLAVE: UInt32 = 0x0000_0000
public let LL_SPI_SS_LEVEL_HIGH: UInt32 = 0x0000_1000
public let LL_SPI_SS_LEVEL_LOW: UInt32 = 0x0000_0000
public let LL_SPI_SS_IDLENESS_00CYCLE: UInt32 = 0x0000_0000
public let LL_SPI_SS_IDLENESS_01CYCLE: UInt32 = 0x0000_0001
public let LL_SPI_SS_IDLENESS_02CYCLE: UInt32 = 0x0000_0002
public let LL_SPI_SS_IDLENESS_03CYCLE: UInt32 = 0x0000_0003
public let LL_SPI_SS_IDLENESS_04CYCLE: UInt32 = 0x0000_0004
public let LL_SPI_SS_IDLENESS_05CYCLE: UInt32 = 0x0000_0005
public let LL_SPI_SS_IDLENESS_06CYCLE: UInt32 = 0x0000_0006
public let LL_SPI_SS_IDLENESS_07CYCLE: UInt32 = 0x0000_0007
public let LL_SPI_SS_IDLENESS_08CYCLE: UInt32 = 0x0000_0008
public let LL_SPI_SS_IDLENESS_09CYCLE: UInt32 = 0x0000_0009
public let LL_SPI_SS_IDLENESS_10CYCLE: UInt32 = 0x0000_000A
public let LL_SPI_SS_IDLENESS_11CYCLE: UInt32 = 0x0000_000B
public let LL_SPI_SS_IDLENESS_12CYCLE: UInt32 = 0x0000_000C
public let LL_SPI_SS_IDLENESS_13CYCLE: UInt32 = 0x0000_000D
public let LL_SPI_SS_IDLENESS_14CYCLE: UInt32 = 0x0000_000E
public let LL_SPI_SS_IDLENESS_15CYCLE: UInt32 = 0x0000_000F
public let LL_SPI_ID_IDLENESS_00CYCLE: UInt32 = 0x0000_0000
public let LL_SPI_ID_IDLENESS_01CYCLE: UInt32 = 0x0000_0010
public let LL_SPI_ID_IDLENESS_02CYCLE: UInt32 = 0x0000_0020
public let LL_SPI_ID_IDLENESS_03CYCLE: UInt32 = 0x0000_0030
public let LL_SPI_ID_IDLENESS_04CYCLE: UInt32 = 0x0000_0040
public let LL_SPI_ID_IDLENESS_05CYCLE: UInt32 = 0x0000_0050
public let LL_SPI_ID_IDLENESS_06CYCLE: UInt32 = 0x0000_0060
public let LL_SPI_ID_IDLENESS_07CYCLE: UInt32 = 0x0000_0070
public let LL_SPI_ID_IDLENESS_08CYCLE: UInt32 = 0x0000_0080
public let LL_SPI_ID_IDLENESS_09CYCLE: UInt32 = 0x0000_0090
public let LL_SPI_ID_IDLENESS_10CYCLE: UInt32 = 0x0000_00A0
public let LL_SPI_ID_IDLENESS_11CYCLE: UInt32 = 0x0000_00B0
public let LL_SPI_ID_IDLENESS_12CYCLE: UInt32 = 0x0000_00C0
public let LL_SPI_ID_IDLENESS_13CYCLE: UInt32 = 0x0000_00D0
public let LL_SPI_ID_IDLENESS_14CYCLE: UInt32 = 0x0000_00E0
public let LL_SPI_ID_IDLENESS_15CYCLE: UInt32 = 0x0000_00F0
public let LL_SPI_TXCRCINIT_ALL_ZERO_PATTERN: UInt32 = 0x0000_0000
public let LL_SPI_TXCRCINIT_ALL_ONES_PATTERN: UInt32 = 0x0000_8000
public let LL_SPI_RXCRCINIT_ALL_ZERO_PATTERN: UInt32 = 0x0000_0000
public let LL_SPI_RXCRCINIT_ALL_ONES_PATTERN: UInt32 = 0x0000_4000
public let LL_SPI_UDR_CONFIG_REGISTER_PATTERN: UInt32 = 0x0000_0000
public let LL_SPI_UDR_CONFIG_LAST_RECEIVED: UInt32 = 0x0000_0200
public let LL_SPI_PROTOCOL_MOTOROLA: UInt32 = 0x0000_0000
public let LL_SPI_PROTOCOL_TI: UInt32 = 0x0008_0000
public let LL_SPI_PHASE_1EDGE: UInt32 = 0x0000_0000
public let LL_SPI_PHASE_2EDGE: UInt32 = 0x0100_0000
public let LL_SPI_POLARITY_LOW: UInt32 = 0x0000_0000
public let LL_SPI_POLARITY_HIGH: UInt32 = 0x0200_0000
public let LL_SPI_NSS_POLARITY_LOW: UInt32 = 0x0000_0000
public let LL_SPI_NSS_POLARITY_HIGH: UInt32 = 0x1000_0000
public let LL_SPI_BAUDRATEPRESCALER_BYPASS: UInt32 = 0x8000_0000
public let LL_SPI_BAUDRATEPRESCALER_DIV2: UInt32 = 0x0000_0000
public let LL_SPI_BAUDRATEPRESCALER_DIV4: UInt32 = 0x1000_0000
public let LL_SPI_BAUDRATEPRESCALER_DIV8: UInt32 = 0x2000_0000
public let LL_SPI_BAUDRATEPRESCALER_DIV16: UInt32 = 0x3000_0000
public let LL_SPI_BAUDRATEPRESCALER_DIV32: UInt32 = 0x4000_0000
public let LL_SPI_BAUDRATEPRESCALER_DIV64: UInt32 = 0x5000_0000
public let LL_SPI_BAUDRATEPRESCALER_DIV128: UInt32 = 0x6000_0000
public let LL_SPI_BAUDRATEPRESCALER_DIV256: UInt32 = 0x7000_0000
public let LL_SPI_LSB_FIRST: UInt32 = 0x0080_0000
public let LL_SPI_MSB_FIRST: UInt32 = 0x0000_0000
public let LL_SPI_FULL_DUPLEX: UInt32 = 0x0000_0000
public let LL_SPI_SIMPLEX_TX: UInt32 = 0x0002_0000
public let LL_SPI_SIMPLEX_RX: UInt32 = 0x0004_0000
public let LL_SPI_HALF_DUPLEX_RX: UInt32 = 0x0006_0000
public let LL_SPI_HALF_DUPLEX_TX: UInt32 = 0x0006_0800
public let LL_SPI_DATAWIDTH_4BIT: UInt32 = 0x0000_0003
public let LL_SPI_DATAWIDTH_5BIT: UInt32 = 0x0000_0004
public let LL_SPI_DATAWIDTH_6BIT: UInt32 = 0x0000_0005
public let LL_SPI_DATAWIDTH_7BIT: UInt32 = 0x0000_0006
public let LL_SPI_DATAWIDTH_8BIT: UInt32 = 0x0000_0007
public let LL_SPI_DATAWIDTH_9BIT: UInt32 = 0x0000_0008
public let LL_SPI_DATAWIDTH_10BIT: UInt32 = 0x0000_0009
public let LL_SPI_DATAWIDTH_11BIT: UInt32 = 0x0000_000A
public let LL_SPI_DATAWIDTH_12BIT: UInt32 = 0x0000_000B
public let LL_SPI_DATAWIDTH_13BIT: UInt32 = 0x0000_000C
public let LL_SPI_DATAWIDTH_14BIT: UInt32 = 0x0000_000D
public let LL_SPI_DATAWIDTH_15BIT: UInt32 = 0x0000_000E
public let LL_SPI_DATAWIDTH_16BIT: UInt32 = 0x0000_000F
public let LL_SPI_DATAWIDTH_17BIT: UInt32 = 0x0000_0010
public let LL_SPI_DATAWIDTH_18BIT: UInt32 = 0x0000_0011
public let LL_SPI_DATAWIDTH_19BIT: UInt32 = 0x0000_0012
public let LL_SPI_DATAWIDTH_20BIT: UInt32 = 0x0000_0013
public let LL_SPI_DATAWIDTH_21BIT: UInt32 = 0x0000_0014
public let LL_SPI_DATAWIDTH_22BIT: UInt32 = 0x0000_0015
public let LL_SPI_DATAWIDTH_23BIT: UInt32 = 0x0000_0016
public let LL_SPI_DATAWIDTH_24BIT: UInt32 = 0x0000_0017
public let LL_SPI_DATAWIDTH_25BIT: UInt32 = 0x0000_0018
public let LL_SPI_DATAWIDTH_26BIT: UInt32 = 0x0000_0019
public let LL_SPI_DATAWIDTH_27BIT: UInt32 = 0x0000_001A
public let LL_SPI_DATAWIDTH_28BIT: UInt32 = 0x0000_001B
public let LL_SPI_DATAWIDTH_29BIT: UInt32 = 0x0000_001C
public let LL_SPI_DATAWIDTH_30BIT: UInt32 = 0x0000_001D
public let LL_SPI_DATAWIDTH_31BIT: UInt32 = 0x0000_001E
public let LL_SPI_DATAWIDTH_32BIT: UInt32 = 0x0000_001F
public let LL_SPI_FIFO_TH_01DATA: UInt32 = 0x0000_0000
public let LL_SPI_FIFO_TH_02DATA: UInt32 = 0x0000_0020
public let LL_SPI_FIFO_TH_03DATA: UInt32 = 0x0000_0040
public let LL_SPI_FIFO_TH_04DATA: UInt32 = 0x0000_0060
public let LL_SPI_FIFO_TH_05DATA: UInt32 = 0x0000_0080
public let LL_SPI_FIFO_TH_06DATA: UInt32 = 0x0000_00A0
public let LL_SPI_FIFO_TH_07DATA: UInt32 = 0x0000_00C0
public let LL_SPI_FIFO_TH_08DATA: UInt32 = 0x0000_00E0
public let LL_SPI_FIFO_TH_09DATA: UInt32 = 0x0000_0100
public let LL_SPI_FIFO_TH_10DATA: UInt32 = 0x0000_0120
public let LL_SPI_FIFO_TH_11DATA: UInt32 = 0x0000_0140
public let LL_SPI_FIFO_TH_12DATA: UInt32 = 0x0000_0160
public let LL_SPI_FIFO_TH_13DATA: UInt32 = 0x0000_0180
public let LL_SPI_FIFO_TH_14DATA: UInt32 = 0x0000_01A0
public let LL_SPI_FIFO_TH_15DATA: UInt32 = 0x0000_01C0
public let LL_SPI_FIFO_TH_16DATA: UInt32 = 0x0000_01E0
public let LL_SPI_CRCCALCULATION_DISABLE: UInt32 = 0x0000_0000
public let LL_SPI_CRCCALCULATION_ENABLE: UInt32 = 0x0040_0000
public let LL_SPI_CRC_4BIT: UInt32 = 0x0003_0000
public let LL_SPI_CRC_5BIT: UInt32 = 0x0004_0000
public let LL_SPI_CRC_6BIT: UInt32 = 0x0005_0000
public let LL_SPI_CRC_7BIT: UInt32 = 0x0006_0000
public let LL_SPI_CRC_8BIT: UInt32 = 0x0007_0000
public let LL_SPI_CRC_9BIT: UInt32 = 0x0008_0000
public let LL_SPI_CRC_10BIT: UInt32 = 0x0009_0000
public let LL_SPI_CRC_11BIT: UInt32 = 0x000A_0000
public let LL_SPI_CRC_12BIT: UInt32 = 0x000B_0000
public let LL_SPI_CRC_13BIT: UInt32 = 0x000C_0000
public let LL_SPI_CRC_14BIT: UInt32 = 0x000D_0000
public let LL_SPI_CRC_15BIT: UInt32 = 0x000E_0000
public let LL_SPI_CRC_16BIT: UInt32 = 0x000F_0000
public let LL_SPI_CRC_17BIT: UInt32 = 0x0010_0000
public let LL_SPI_CRC_18BIT: UInt32 = 0x0011_0000
public let LL_SPI_CRC_19BIT: UInt32 = 0x0012_0000
public let LL_SPI_CRC_20BIT: UInt32 = 0x0013_0000
public let LL_SPI_CRC_21BIT: UInt32 = 0x0014_0000
public let LL_SPI_CRC_22BIT: UInt32 = 0x0015_0000
public let LL_SPI_CRC_23BIT: UInt32 = 0x0016_0000
public let LL_SPI_CRC_24BIT: UInt32 = 0x0017_0000
public let LL_SPI_CRC_25BIT: UInt32 = 0x0018_0000
public let LL_SPI_CRC_26BIT: UInt32 = 0x0019_0000
public let LL_SPI_CRC_27BIT: UInt32 = 0x001A_0000
public let LL_SPI_CRC_28BIT: UInt32 = 0x001B_0000
public let LL_SPI_CRC_29BIT: UInt32 = 0x001C_0000
public let LL_SPI_CRC_30BIT: UInt32 = 0x001D_0000
public let LL_SPI_CRC_31BIT: UInt32 = 0x001E_0000
public let LL_SPI_CRC_32BIT: UInt32 = 0x001F_0000
public let LL_SPI_NSS_SOFT: UInt32 = 0x0400_0000
public let LL_SPI_NSS_HARD_INPUT: UInt32 = 0x0000_0000
public let LL_SPI_NSS_HARD_OUTPUT: UInt32 = 0x2000_0000
public let LL_SPI_RX_FIFO_0PACKET: UInt32 = 0x0000_0000
public let LL_SPI_RX_FIFO_1PACKET: UInt32 = 0x0000_2000
public let LL_SPI_RX_FIFO_2PACKET: UInt32 = 0x0000_4000
public let LL_SPI_RX_FIFO_3PACKET: UInt32 = 0x0000_6000
public let LL_I2S_DATAFORMAT_16B: UInt32 = 0x0000_0000
public let LL_I2S_DATAFORMAT_16B_EXTENDED: UInt32 = 0x0000_0400
public let LL_I2S_DATAFORMAT_24B: UInt32 = 0x0000_0500
public let LL_I2S_DATAFORMAT_24B_LEFT_ALIGNED: UInt32 = 0x0000_4500
public let LL_I2S_DATAFORMAT_32B: UInt32 = 0x0000_0600
public let LL_I2S_SLAVE_VARIABLE_CH_LENGTH: UInt32 = 0x0000_0000
public let LL_I2S_SLAVE_FIXED_CH_LENGTH: UInt32 = 0x0000_1000
public let LL_I2S_POLARITY_LOW: UInt32 = 0x0000_0000
public let LL_I2S_POLARITY_HIGH: UInt32 = 0x0000_0800
public let LL_I2S_STANDARD_PHILIPS: UInt32 = 0x0000_0000
public let LL_I2S_STANDARD_MSB: UInt32 = 0x0000_0010
public let LL_I2S_STANDARD_LSB: UInt32 = 0x0000_0020
public let LL_I2S_STANDARD_PCM_SHORT: UInt32 = 0x0000_0030
public let LL_I2S_STANDARD_PCM_LONG: UInt32 = 0x0000_00B0
public let LL_I2S_MODE_SLAVE_TX: UInt32 = 0x0000_0000
public let LL_I2S_MODE_SLAVE_RX: UInt32 = 0x0000_0002
public let LL_I2S_MODE_SLAVE_FULL_DUPLEX: UInt32 = 0x0000_0008
public let LL_I2S_MODE_MASTER_TX: UInt32 = 0x0000_0004
public let LL_I2S_MODE_MASTER_RX: UInt32 = 0x0000_0006
public let LL_I2S_MODE_MASTER_FULL_DUPLEX: UInt32 = 0x0000_000A
public let LL_I2S_PRESCALER_PARITY_EVEN: UInt32 = 0x0000_0000
public let LL_I2S_PRESCALER_PARITY_ODD: UInt32 = 0x0000_0001
public let LL_I2S_FIFO_TH_01DATA: UInt32 = 0x0000_0000
public let LL_I2S_FIFO_TH_02DATA: UInt32 = 0x0000_0020
public let LL_I2S_FIFO_TH_03DATA: UInt32 = 0x0000_0040
public let LL_I2S_FIFO_TH_04DATA: UInt32 = 0x0000_0060
public let LL_I2S_FIFO_TH_05DATA: UInt32 = 0x0000_0080
public let LL_I2S_FIFO_TH_06DATA: UInt32 = 0x0000_00A0
public let LL_I2S_FIFO_TH_07DATA: UInt32 = 0x0000_00C0
public let LL_I2S_FIFO_TH_08DATA: UInt32 = 0x0000_00E0
public let LL_I2S_LSB_FIRST: UInt32 = 0x0080_0000
public let LL_I2S_MSB_FIRST: UInt32 = 0x0000_0000
public let LL_I2S_MCLK_OUTPUT_DISABLE: UInt32 = 0x0000_0000
public let LL_I2S_MCLK_OUTPUT_ENABLE: UInt32 = 0x0200_0000
public let LL_I2S_AUDIOFREQ_192K: UInt32 = 0x0002_EE00
public let LL_I2S_AUDIOFREQ_96K: UInt32 = 0x0001_7700
public let LL_I2S_AUDIOFREQ_48K: UInt32 = 0x0000_BB80
public let LL_I2S_AUDIOFREQ_44K: UInt32 = 0x0000_AC44
public let LL_I2S_AUDIOFREQ_32K: UInt32 = 0x0000_7D00
public let LL_I2S_AUDIOFREQ_22K: UInt32 = 0x0000_5622
public let LL_I2S_AUDIOFREQ_16K: UInt32 = 0x0000_3E80
public let LL_I2S_AUDIOFREQ_11K: UInt32 = 0x0000_2B11
public let LL_I2S_AUDIOFREQ_8K: UInt32 = 0x0000_1F40
public let LL_I2S_AUDIOFREQ_DEFAULT: UInt32 = 0x0000_0000

public func LL_SPI_Enable<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) | (0x1))
}

public func LL_SPI_Disable<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) & ~(0x1))
}

public func LL_SPI_IsEnabled<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cr1) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_SPI_EnableIOSwap<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg2, value: registers.read(SPIRegister.cfg2) | (0x8000))
}

public func LL_SPI_DisableIOSwap<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg2, value: registers.read(SPIRegister.cfg2) & ~(0x8000))
}

public func LL_SPI_IsEnabledIOSwap<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cfg2) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_SPI_EnableGPIOControl<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg2, value: registers.read(SPIRegister.cfg2) | (0x8000_0000))
}

public func LL_SPI_DisableGPIOControl<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg2, value: registers.read(SPIRegister.cfg2) & ~(0x8000_0000))
}

public func LL_SPI_IsEnabledGPIOControl<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cfg2) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_SPI_SetMode<IO: SPIRegisterIO>(_ registers: IO, _ Mode: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0x400000)) | (Mode))
}

public func LL_SPI_GetMode<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0x400000)))
}

public func LL_SPI_SetMasterSSIdleness<IO: SPIRegisterIO>(_ registers: IO, _ MasterSSIdleness: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0xf)) | (MasterSSIdleness))
}

public func LL_SPI_GetMasterSSIdleness<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0xf)))
}

public func LL_SPI_SetInterDataIdleness<IO: SPIRegisterIO>(_ registers: IO, _ MasterInterDataIdleness: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0xf0)) | (MasterInterDataIdleness))
}

public func LL_SPI_GetInterDataIdleness<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0xf0)))
}

public func LL_SPI_SetTransferSize<IO: SPIRegisterIO>(_ registers: IO, _ Count: UInt32) {
    registers.write(SPIRegister.cr2, value: (registers.read(SPIRegister.cr2) & ~(0xffff)) | (Count))
}

public func LL_SPI_GetTransferSize<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cr2) & (0xffff)))
}

public func LL_SPI_EnableIOLock<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) | (0x10000))
}

public func LL_SPI_IsEnabledIOLock<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cr1) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_SPI_SetTxCRCInitPattern<IO: SPIRegisterIO>(_ registers: IO, _ TXCRCInitAll: UInt32) {
    registers.write(SPIRegister.cr1, value: (registers.read(SPIRegister.cr1) & ~(0x8000)) | (TXCRCInitAll))
}

public func LL_SPI_GetTxCRCInitPattern<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cr1) & (0x8000)))
}

public func LL_SPI_SetRxCRCInitPattern<IO: SPIRegisterIO>(_ registers: IO, _ RXCRCInitAll: UInt32) {
    registers.write(SPIRegister.cr1, value: (registers.read(SPIRegister.cr1) & ~(0x4000)) | (RXCRCInitAll))
}

public func LL_SPI_GetRxCRCInitPattern<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cr1) & (0x4000)))
}

public func LL_SPI_SetInternalSSLevel<IO: SPIRegisterIO>(_ registers: IO, _ SSLevel: UInt32) {
    registers.write(SPIRegister.cr1, value: (registers.read(SPIRegister.cr1) & ~(0x1000)) | (SSLevel))
}

public func LL_SPI_GetInternalSSLevel<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cr1) & (0x1000)))
}

public func LL_SPI_EnableFullSizeCRC<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) | (0x2000))
}

public func LL_SPI_DisableFullSizeCRC<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) & ~(0x2000))
}

public func LL_SPI_IsEnabledFullSizeCRC<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cr1) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_SPI_SuspendMasterTransfer<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) | (0x400))
}

public func LL_SPI_StartMasterTransfer<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) | (0x200))
}

public func LL_SPI_IsActiveMasterTransfer<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cr1) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_SPI_EnableMasterRxAutoSuspend<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) | (0x100))
}

public func LL_SPI_DisableMasterRxAutoSuspend<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) & ~(0x100))
}

public func LL_SPI_IsEnabledMasterRxAutoSuspend<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cr1) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_SPI_SetUDRConfiguration<IO: SPIRegisterIO>(_ registers: IO, _ UDRConfig: UInt32) {
    registers.write(SPIRegister.cfg1, value: (registers.read(SPIRegister.cfg1) & ~(0x200)) | (UDRConfig))
}

public func LL_SPI_GetUDRConfiguration<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg1) & (0x200)))
}

public func LL_SPI_SetStandard<IO: SPIRegisterIO>(_ registers: IO, _ Standard: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0x380000)) | (Standard))
}

public func LL_SPI_GetStandard<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0x380000)))
}

public func LL_SPI_SetClockPhase<IO: SPIRegisterIO>(_ registers: IO, _ ClockPhase: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0x1000000)) | (ClockPhase))
}

public func LL_SPI_GetClockPhase<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0x1000000)))
}

public func LL_SPI_SetClockPolarity<IO: SPIRegisterIO>(_ registers: IO, _ ClockPolarity: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0x2000000)) | (ClockPolarity))
}

public func LL_SPI_GetClockPolarity<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0x2000000)))
}

public func LL_SPI_SetNSSPolarity<IO: SPIRegisterIO>(_ registers: IO, _ NSSPolarity: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0x1000_0000)) | (NSSPolarity))
}

public func LL_SPI_GetNSSPolarity<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0x1000_0000)))
}

public func LL_SPI_SetBaudRatePrescaler<IO: SPIRegisterIO>(_ registers: IO, _ Baudrate: UInt32) {
    registers.write(
        SPIRegister.cfg1, value: (registers.read(SPIRegister.cfg1) & ~((0x7000_0000 | 0x8000_0000))) | (Baudrate))
}

public func LL_SPI_GetBaudRatePrescaler<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg1) & ((0x7000_0000 | 0x8000_0000))))
}

public func LL_SPI_SetTransferBitOrder<IO: SPIRegisterIO>(_ registers: IO, _ BitOrder: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0x800000)) | (BitOrder))
}

public func LL_SPI_GetTransferBitOrder<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0x800000)))
}

public func LL_SPI_SetTransferDirection<IO: SPIRegisterIO>(_ registers: IO, _ TransferDirection: UInt32) {
    registers.write(SPIRegister.cr1, value: (registers.read(SPIRegister.cr1) & ~(0x800)) | (TransferDirection & 0x800))
    registers.write(
        SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0x60000)) | (TransferDirection & 0x60000))
}

public func LL_SPI_GetTransferDirection<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    var Hddir: UInt32 = (registers.read(SPIRegister.cr1) & (0x800))
    var Comm: UInt32 = (registers.read(SPIRegister.cfg2) & (0x60000))
    return (Hddir | Comm)
}

public func LL_SPI_SetHalfDuplexDirection<IO: SPIRegisterIO>(_ registers: IO, _ HalfDuplexDirection: UInt32) {
    registers.write(
        SPIRegister.cr1, value: (registers.read(SPIRegister.cr1) & ~(0x800)) | (HalfDuplexDirection & 0x800))
}

public func LL_SPI_GetHalfDuplexDirection<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cr1) & (0x800)) | 0x60000)
}

public func LL_SPI_SetDataWidth<IO: SPIRegisterIO>(_ registers: IO, _ DataWidth: UInt32) {
    registers.write(SPIRegister.cfg1, value: (registers.read(SPIRegister.cfg1) & ~(0x1f)) | (DataWidth))
}

public func LL_SPI_GetDataWidth<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg1) & (0x1f)))
}

public func LL_SPI_SetFIFOThreshold<IO: SPIRegisterIO>(_ registers: IO, _ Threshold: UInt32) {
    registers.write(SPIRegister.cfg1, value: (registers.read(SPIRegister.cfg1) & ~(0x1e0)) | (Threshold))
}

public func LL_SPI_GetFIFOThreshold<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg1) & (0x1e0)))
}

public func LL_SPI_EnableCRC<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg1, value: registers.read(SPIRegister.cfg1) | (0x400000))
}

public func LL_SPI_DisableCRC<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg1, value: registers.read(SPIRegister.cfg1) & ~(0x400000))
}

public func LL_SPI_IsEnabledCRC<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cfg1) & (0x400000)) == 0x400000) ? 1 : 0)
}

public func LL_SPI_SetCRCWidth<IO: SPIRegisterIO>(_ registers: IO, _ CRCLength: UInt32) {
    registers.write(SPIRegister.cfg1, value: (registers.read(SPIRegister.cfg1) & ~(0x1f0000)) | (CRCLength))
}

public func LL_SPI_GetCRCWidth<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg1) & (0x1f0000)))
}

public func LL_SPI_SetNSSMode<IO: SPIRegisterIO>(_ registers: IO, _ NSS: UInt32) {
    registers.write(SPIRegister.cfg2, value: (registers.read(SPIRegister.cfg2) & ~(0x4000000 | 0x2000_0000)) | (NSS))
}

public func LL_SPI_GetNSSMode<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.cfg2) & (0x4000000 | 0x2000_0000)))
}

public func LL_SPI_EnableNSSPulseMgt<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg2, value: registers.read(SPIRegister.cfg2) | (0x4000_0000))
}

public func LL_SPI_DisableNSSPulseMgt<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg2, value: registers.read(SPIRegister.cfg2) & ~(0x4000_0000))
}

public func LL_SPI_IsEnabledNSSPulse<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cfg2) & (0x4000_0000)) == 0x4000_0000) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_RXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_TXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_DXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_EOT<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_TXTF<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_UDR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_CRCERR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_MODF<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_OVR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_FRE<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_SUSP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_TXC<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_SPI_IsActiveFlag_RXWNE<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.sr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_SPI_GetRemainingDataFrames<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.sr) & (0xffff_0000)) >> 0x10)
}

public func LL_SPI_GetRxFIFOPackingLevel<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.sr) & (0x6000)))
}

public func LL_SPI_ClearFlag_EOT<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ifcr, value: registers.read(SPIRegister.ifcr) | (0x8))
}

public func LL_SPI_ClearFlag_TXTF<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ifcr, value: registers.read(SPIRegister.ifcr) | (0x10))
}

public func LL_SPI_ClearFlag_UDR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ifcr, value: registers.read(SPIRegister.ifcr) | (0x20))
}

public func LL_SPI_ClearFlag_OVR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ifcr, value: registers.read(SPIRegister.ifcr) | (0x40))
}

public func LL_SPI_ClearFlag_CRCERR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ifcr, value: registers.read(SPIRegister.ifcr) | (0x80))
}

public func LL_SPI_ClearFlag_MODF<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ifcr, value: registers.read(SPIRegister.ifcr) | (0x200))
}

public func LL_SPI_ClearFlag_FRE<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ifcr, value: registers.read(SPIRegister.ifcr) | (0x100))
}

public func LL_SPI_ClearFlag_SUSP<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ifcr, value: registers.read(SPIRegister.ifcr) | (0x800))
}

public func LL_SPI_EnableIT_RXP<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x1))
}

public func LL_SPI_EnableIT_TXP<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x2))
}

public func LL_SPI_EnableIT_DXP<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x4))
}

public func LL_SPI_EnableIT_EOT<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x8))
}

public func LL_SPI_EnableIT_TXTF<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x10))
}

public func LL_SPI_EnableIT_UDR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x20))
}

public func LL_SPI_EnableIT_OVR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x40))
}

public func LL_SPI_EnableIT_CRCERR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x80))
}

public func LL_SPI_EnableIT_FRE<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x100))
}

public func LL_SPI_EnableIT_MODF<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) | (0x200))
}

public func LL_SPI_DisableIT_RXP<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x1))
}

public func LL_SPI_DisableIT_TXP<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x2))
}

public func LL_SPI_DisableIT_DXP<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x4))
}

public func LL_SPI_DisableIT_EOT<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x8))
}

public func LL_SPI_DisableIT_TXTF<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x10))
}

public func LL_SPI_DisableIT_UDR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x20))
}

public func LL_SPI_DisableIT_OVR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x40))
}

public func LL_SPI_DisableIT_CRCERR<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x80))
}

public func LL_SPI_DisableIT_FRE<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x100))
}

public func LL_SPI_DisableIT_MODF<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.ier, value: registers.read(SPIRegister.ier) & ~(0x200))
}

public func LL_SPI_IsEnabledIT_RXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_TXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_DXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_EOT<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_TXTF<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_UDR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_OVR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_CRCERR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_FRE<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_SPI_IsEnabledIT_MODF<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.ier) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_SPI_EnableDMAReq_RX<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg1, value: registers.read(SPIRegister.cfg1) | (0x4000))
}

public func LL_SPI_DisableDMAReq_RX<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg1, value: registers.read(SPIRegister.cfg1) & ~(0x4000))
}

public func LL_SPI_IsEnabledDMAReq_RX<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cfg1) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_SPI_EnableDMAReq_TX<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg1, value: registers.read(SPIRegister.cfg1) | (0x8000))
}

public func LL_SPI_DisableDMAReq_TX<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cfg1, value: registers.read(SPIRegister.cfg1) & ~(0x8000))
}

public func LL_SPI_IsEnabledDMAReq_TX<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.cfg1) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_SPI_DMA_GetTxRegAddr<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return registers.address(of: .txdr)
}

public func LL_SPI_DMA_GetRxRegAddr<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return registers.address(of: .rxdr)
}

public func LL_SPI_ReceiveData8<IO: SPIRegisterIO>(_ registers: IO) -> UInt8 {
    return registers.read8(.rxdr)
}

public func LL_SPI_ReceiveData16<IO: SPIRegisterIO>(_ registers: IO) -> UInt16 {
    return registers.read16(.rxdr)
}

public func LL_SPI_ReceiveData32<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return registers.read(.rxdr)
}

public func LL_SPI_TransmitData8<IO: SPIRegisterIO>(_ registers: IO, _ TxData: UInt8) {
    registers.write8(.txdr, value: TxData)
}

public func LL_SPI_TransmitData16<IO: SPIRegisterIO>(_ registers: IO, _ TxData: UInt16) {
    registers.write16(.txdr, value: TxData)
}

public func LL_SPI_TransmitData32<IO: SPIRegisterIO>(_ registers: IO, _ TxData: UInt32) {
    registers.write(.txdr, value: TxData)
}

public func LL_SPI_SetCRCPolynomial<IO: SPIRegisterIO>(_ registers: IO, _ CRCPoly: UInt32) {
    registers.write(SPIRegister.crcpoly, value: CRCPoly)
}

public func LL_SPI_GetCRCPolynomial<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(SPIRegister.crcpoly))
}

public func LL_SPI_SetUDRPattern<IO: SPIRegisterIO>(_ registers: IO, _ Pattern: UInt32) {
    registers.write(SPIRegister.udrdr, value: Pattern)
}

public func LL_SPI_GetUDRPattern<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(SPIRegister.udrdr))
}

public func LL_SPI_GetRxCRC<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(SPIRegister.rxcrc))
}

public func LL_SPI_GetTxCRC<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(SPIRegister.txcrc))
}

public func LL_I2S_SetDataFormat<IO: SPIRegisterIO>(_ registers: IO, _ DataLength: UInt32) {
    registers.write(
        SPIRegister.i2scfgr, value: (registers.read(SPIRegister.i2scfgr) & ~(0x300 | 0x400 | 0x4000)) | (DataLength))
}

public func LL_I2S_GetDataFormat<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.i2scfgr) & (0x300 | 0x400 | 0x4000)))
}

public func LL_I2S_SetChannelLengthType<IO: SPIRegisterIO>(_ registers: IO, _ ChannelLengthType: UInt32) {
    registers.write(SPIRegister.i2scfgr, value: (registers.read(SPIRegister.i2scfgr) & ~(0x1000)) | (ChannelLengthType))
}

public func LL_I2S_GetChannelLengthType<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.i2scfgr) & (0x1000)))
}

public func LL_I2S_EnableWordSelectInversion<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.i2scfgr, value: registers.read(SPIRegister.i2scfgr) | (0x2000))
}

public func LL_I2S_DisableWordSelectInversion<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.i2scfgr, value: registers.read(SPIRegister.i2scfgr) & ~(0x2000))
}

public func LL_I2S_IsEnabledWordSelectInversion<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.i2scfgr) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_I2S_SetClockPolarity<IO: SPIRegisterIO>(_ registers: IO, _ ClockPolarity: UInt32) {
    registers.write(SPIRegister.i2scfgr, value: (registers.read(SPIRegister.i2scfgr) & ~(0x800)) | (ClockPolarity))
}

public func LL_I2S_GetClockPolarity<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.i2scfgr) & (0x800)))
}

public func LL_I2S_SetStandard<IO: SPIRegisterIO>(_ registers: IO, _ Standard: UInt32) {
    registers.write(SPIRegister.i2scfgr, value: (registers.read(SPIRegister.i2scfgr) & ~(0x30 | 0x80)) | (Standard))
}

public func LL_I2S_GetStandard<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.i2scfgr) & (0x30 | 0x80)))
}

public func LL_I2S_SetTransferMode<IO: SPIRegisterIO>(_ registers: IO, _ Standard: UInt32) {
    registers.write(SPIRegister.i2scfgr, value: (registers.read(SPIRegister.i2scfgr) & ~(0xe)) | (Standard))
}

public func LL_I2S_GetTransferMode<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.i2scfgr) & (0xe)))
}

public func LL_I2S_Enable<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.i2scfgr, value: registers.read(SPIRegister.i2scfgr) | (0x1))
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) | (0x1))
}

public func LL_I2S_Disable<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.cr1, value: registers.read(SPIRegister.cr1) & ~(0x1))
    registers.write(SPIRegister.i2scfgr, value: registers.read(SPIRegister.i2scfgr) & ~(0x1))
}

public func LL_I2S_EnableIOSwap<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableIOSwap(registers)
}

public func LL_I2S_DisableIOSwap<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableIOSwap(registers)
}

public func LL_I2S_IsEnabledIOSwap<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledIOSwap(registers)
}

public func LL_I2S_EnableGPIOControl<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableGPIOControl(registers)
}

public func LL_I2S_DisableGPIOControl<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableGPIOControl(registers)
}

public func LL_I2S_IsEnabledGPIOControl<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledGPIOControl(registers)
}

public func LL_I2S_EnableIOLock<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableIOLock(registers)
}

public func LL_I2S_IsEnabledIOLock<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledIOLock(registers)
}

public func LL_I2S_SetTransferBitOrder<IO: SPIRegisterIO>(_ registers: IO, _ BitOrder: UInt32) {
    LL_SPI_SetTransferBitOrder(registers, BitOrder)
}

public func LL_I2S_GetTransferBitOrder<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_GetTransferBitOrder(registers)
}

public func LL_I2S_StartTransfer<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_StartMasterTransfer(registers)
}

public func LL_I2S_IsActiveTransfer<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsActiveMasterTransfer(registers)
}

public func LL_I2S_SetFIFOThreshold<IO: SPIRegisterIO>(_ registers: IO, _ Threshold: UInt32) {
    LL_SPI_SetFIFOThreshold(registers, Threshold)
}

public func LL_I2S_GetFIFOThreshold<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_GetFIFOThreshold(registers)
}

public func LL_I2S_SetPrescalerLinear<IO: SPIRegisterIO>(_ registers: IO, _ PrescalerLinear: UInt32) {
    registers.write(
        SPIRegister.i2scfgr, value: (registers.read(SPIRegister.i2scfgr) & ~(0xff0000)) | ((PrescalerLinear << 0x10)))
}

public func LL_I2S_GetPrescalerLinear<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.i2scfgr) & (0xff0000)) >> 0x10)
}

public func LL_I2S_SetPrescalerParity<IO: SPIRegisterIO>(_ registers: IO, _ PrescalerParity: UInt32) {
    registers.write(
        SPIRegister.i2scfgr, value: (registers.read(SPIRegister.i2scfgr) & ~(0x1000000)) | (PrescalerParity << 0x18))
}

public func LL_I2S_GetPrescalerParity<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(SPIRegister.i2scfgr) & (0x1000000)) >> 0x18)
}

public func LL_I2S_EnableMasterClock<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.i2scfgr, value: registers.read(SPIRegister.i2scfgr) | (0x2000000))
}

public func LL_I2S_DisableMasterClock<IO: SPIRegisterIO>(_ registers: IO) {
    registers.write(SPIRegister.i2scfgr, value: registers.read(SPIRegister.i2scfgr) & ~(0x2000000))
}

public func LL_I2S_IsEnabledMasterClock<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(SPIRegister.i2scfgr) & (0x2000000)) == (0x2000000)) ? 1 : 0)
}

public func LL_I2S_IsActiveFlag_RXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsActiveFlag_RXP(registers)
}

public func LL_I2S_IsActiveFlag_TXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsActiveFlag_TXP(registers)
}

public func LL_I2S_IsActiveFlag_UDR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsActiveFlag_UDR(registers)
}

public func LL_I2S_IsActiveFlag_OVR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsActiveFlag_OVR(registers)
}

public func LL_I2S_IsActiveFlag_FRE<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsActiveFlag_FRE(registers)
}

public func LL_I2S_ClearFlag_UDR<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_ClearFlag_UDR(registers)
}

public func LL_I2S_ClearFlag_OVR<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_ClearFlag_OVR(registers)
}

public func LL_I2S_ClearFlag_FRE<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_ClearFlag_FRE(registers)
}

public func LL_I2S_EnableIT_RXP<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableIT_RXP(registers)
}

public func LL_I2S_EnableIT_TXP<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableIT_TXP(registers)
}

public func LL_I2S_EnableIT_UDR<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableIT_UDR(registers)
}

public func LL_I2S_EnableIT_OVR<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableIT_OVR(registers)
}

public func LL_I2S_EnableIT_FRE<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableIT_FRE(registers)
}

public func LL_I2S_DisableIT_RXP<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableIT_RXP(registers)
}

public func LL_I2S_DisableIT_TXP<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableIT_TXP(registers)
}

public func LL_I2S_DisableIT_UDR<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableIT_UDR(registers)
}

public func LL_I2S_DisableIT_OVR<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableIT_OVR(registers)
}

public func LL_I2S_DisableIT_FRE<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableIT_FRE(registers)
}

public func LL_I2S_IsEnabledIT_RXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledIT_RXP(registers)
}

public func LL_I2S_IsEnabledIT_TXP<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledIT_TXP(registers)
}

public func LL_I2S_IsEnabledIT_UDR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledIT_UDR(registers)
}

public func LL_I2S_IsEnabledIT_OVR<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledIT_OVR(registers)
}

public func LL_I2S_IsEnabledIT_FRE<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledIT_FRE(registers)
}

public func LL_I2S_EnableDMAReq_RX<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableDMAReq_RX(registers)
}

public func LL_I2S_DisableDMAReq_RX<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableDMAReq_RX(registers)
}

public func LL_I2S_IsEnabledDMAReq_RX<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledDMAReq_RX(registers)
}

public func LL_I2S_EnableDMAReq_TX<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_EnableDMAReq_TX(registers)
}

public func LL_I2S_DisableDMAReq_TX<IO: SPIRegisterIO>(_ registers: IO) {
    LL_SPI_DisableDMAReq_TX(registers)
}

public func LL_I2S_IsEnabledDMAReq_TX<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_IsEnabledDMAReq_TX(registers)
}

public func LL_I2S_ReceiveData16<IO: SPIRegisterIO>(_ registers: IO) -> UInt16 {
    return UInt16(truncatingIfNeeded: LL_SPI_ReceiveData16(registers))
}

public func LL_I2S_ReceiveData32<IO: SPIRegisterIO>(_ registers: IO) -> UInt32 {
    return LL_SPI_ReceiveData32(registers)
}

public func LL_I2S_TransmitData16<IO: SPIRegisterIO>(_ registers: IO, _ TxData: UInt16) {
    LL_SPI_TransmitData16(registers, TxData)
}

public func LL_I2S_TransmitData32<IO: SPIRegisterIO>(_ registers: IO, _ TxData: UInt32) {
    LL_SPI_TransmitData32(registers, TxData)
}

public func LL_SPI_DeInit<IO: SPIRegisterIO & LLBusRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.error.rawValue

    if registers.instance == .spi1 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_SPI1)

        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_SPI1)

        status = LLErrorStatus.success.rawValue
    }
    if registers.instance == .spi2 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_SPI2)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_SPI2)

        status = LLErrorStatus.success.rawValue
    }
    if registers.instance == .spi3 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_SPI3)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_SPI3)

        status = LLErrorStatus.success.rawValue
    }
    if registers.instance == .spi4 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_SPI4)

        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_SPI4)

        status = LLErrorStatus.success.rawValue
    }
    if registers.instance == .spi5 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_SPI5)

        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_SPI5)

        status = LLErrorStatus.success.rawValue
    }
    if registers.instance == .spi6 {
        LL_APB4_GRP1_ForceReset(&registers, LL_APB4_GRP1_PERIPH_SPI6)

        LL_APB4_GRP1_ReleaseReset(&registers, LL_APB4_GRP1_PERIPH_SPI6)

        status = LLErrorStatus.success.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_SPI_Init<IO: SPIRegisterIO>(_ registers: IO, _ SPI_InitStruct: inout LL_SPI_InitTypeDef) -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.error.rawValue
    var tmp_nss: UInt32
    var tmp_mode: UInt32
    var tmp_nss_polarity: UInt32

    if LL_SPI_IsEnabled(registers) == 0x0000_0000 {
        registers.write(
            SPIRegister.cfg1,
            value: (registers.read(SPIRegister.cfg1) & ~(0x8000_0000 | 0x7000_0000 | 0x400000 | 0x1f))
                | (SPI_InitStruct.BaudRate | SPI_InitStruct.CRCCalculation | SPI_InitStruct.DataWidth))
        tmp_nss = SPI_InitStruct.NSS
        tmp_mode = SPI_InitStruct.Mode
        tmp_nss_polarity = LL_SPI_GetNSSPolarity(registers)

        if (tmp_nss == LL_SPI_NSS_SOFT)
            && (((tmp_nss_polarity == LL_SPI_NSS_POLARITY_LOW) && (tmp_mode == LL_SPI_MODE_MASTER))
                || ((tmp_nss_polarity == LL_SPI_NSS_POLARITY_HIGH) && (tmp_mode == LL_SPI_MODE_SLAVE)))
        {
            LL_SPI_SetInternalSSLevel(registers, LL_SPI_SS_LEVEL_HIGH)
        }

        registers.write(
            SPIRegister.cfg2,
            value: (registers.read(SPIRegister.cfg2)
                & ~(0x4000000 | 0x2000_0000 | 0x2000000 | 0x1000000 | 0x800000 | 0x400000 | 0x60000))
                | (SPI_InitStruct.NSS | SPI_InitStruct.ClockPolarity | SPI_InitStruct.ClockPhase
                    | SPI_InitStruct.BitOrder | SPI_InitStruct.Mode | (SPI_InitStruct.TransferDirection & 0x60000)))

        registers.write(
            SPIRegister.cr1,
            value: (registers.read(SPIRegister.cr1) & ~(0x800)) | (SPI_InitStruct.TransferDirection & 0x800))

        if SPI_InitStruct.CRCCalculation == LL_SPI_CRCCALCULATION_ENABLE {
            LL_SPI_SetCRCPolynomial(registers, SPI_InitStruct.CRCPoly)
        }

        registers.write(SPIRegister.i2scfgr, value: registers.read(SPIRegister.i2scfgr) & ~(0x1))
        status = LLErrorStatus.success.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_SPI_StructInit(_ SPI_InitStruct: inout LL_SPI_InitTypeDef) {
    SPI_InitStruct.TransferDirection = LL_SPI_FULL_DUPLEX
    SPI_InitStruct.Mode = LL_SPI_MODE_SLAVE
    SPI_InitStruct.DataWidth = LL_SPI_DATAWIDTH_8BIT
    SPI_InitStruct.ClockPolarity = LL_SPI_POLARITY_LOW
    SPI_InitStruct.ClockPhase = LL_SPI_PHASE_1EDGE
    SPI_InitStruct.NSS = LL_SPI_NSS_HARD_INPUT
    SPI_InitStruct.BaudRate = LL_SPI_BAUDRATEPRESCALER_DIV2
    SPI_InitStruct.BitOrder = LL_SPI_MSB_FIRST
    SPI_InitStruct.CRCCalculation = LL_SPI_CRCCALCULATION_DISABLE
    SPI_InitStruct.CRCPoly = 7
}

public func LL_I2S_DeInit<IO: SPIRegisterIO & LLBusRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    return LLErrorStatus(rawValue: LL_SPI_DeInit(&registers).rawValue)!
}

public func LL_I2S_Init<IO: SPIRegisterIO, Clock: LLRCCRegisterIO>(
    _ registers: IO, _ I2S_InitStruct: LL_I2S_InitTypeDef, clocks: inout Clock,
    oscillators: RCCOscillatorValues = .llDefaults
) -> LLErrorStatus {
    var i2sdiv: UInt32 = 0
    var i2sodd: UInt32 = 0
    var packetlength: UInt32 = 1
    var ispcm: UInt32 = 0
    var tmp: UInt32
    var sourceclock: UInt32 = 0
    var status: UInt32 = LLErrorStatus.error.rawValue

    _ = sourceclock

    if LL_SPI_IsEnabled(registers) == 0x0000_0000 {

        registers.write(
            SPIRegister.i2scfgr,
            value: (registers.read(SPIRegister.i2scfgr) & ~(0x2004f3f))
                | (I2S_InitStruct.Mode | I2S_InitStruct.Standard | I2S_InitStruct.DataFormat
                    | I2S_InitStruct.ClockPolarity | I2S_InitStruct.MCLKOutput | 0x1))

        if I2S_InitStruct.AudioFreq != LL_I2S_AUDIOFREQ_DEFAULT {
            if I2S_InitStruct.DataFormat != LL_I2S_DATAFORMAT_16B {
                packetlength = 2
            }

            if (I2S_InitStruct.Standard == LL_I2S_STANDARD_PCM_SHORT)
                || (I2S_InitStruct.Standard == LL_I2S_STANDARD_PCM_LONG)
            {
                ispcm = 1
            }

            if registers.instance == .spi1 {
                sourceclock = LL_RCC_GetSPIClockFreq(&clocks, LL_RCC_SPI1_CLKSOURCE, oscillators: oscillators)
            } else if (registers.instance == .spi2) || (registers.instance == .spi3) {
                sourceclock = LL_RCC_GetSPIClockFreq(&clocks, LL_RCC_SPI23_CLKSOURCE, oscillators: oscillators)
            } else {
                sourceclock = LL_RCC_GetSPIClockFreq(&clocks, LL_RCC_SPI6_CLKSOURCE, oscillators: oscillators)
            }

            if I2S_InitStruct.MCLKOutput == LL_I2S_MCLK_OUTPUT_ENABLE {
                tmp = (((sourceclock / (256 >> ispcm)) &* 16) / I2S_InitStruct.AudioFreq) &+ 8
            } else {
                tmp = (((sourceclock / ((32 >> ispcm) &* packetlength)) &* 16) / I2S_InitStruct.AudioFreq) &+ 8
            }

            tmp = tmp / 16

            i2sodd = tmp & 0x1

            i2sdiv = tmp / 2
        }

        if ((i2sodd == 1) && (i2sdiv == 1)) || (i2sdiv > 0xFF) {
            i2sdiv = 0
            i2sodd = 0
        }

        registers.write(
            SPIRegister.i2scfgr,
            value: (registers.read(SPIRegister.i2scfgr) & ~(0x1000000 | 0xff0000))
                | ((i2sodd << 0x18) | (i2sdiv << 0x10)))
        status = LLErrorStatus.success.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_I2S_StructInit(_ I2S_InitStruct: inout LL_I2S_InitTypeDef) {
    I2S_InitStruct.Mode = LL_I2S_MODE_SLAVE_TX
    I2S_InitStruct.Standard = LL_I2S_STANDARD_PHILIPS
    I2S_InitStruct.DataFormat = LL_I2S_DATAFORMAT_16B
    I2S_InitStruct.MCLKOutput = LL_I2S_MCLK_OUTPUT_DISABLE
    I2S_InitStruct.AudioFreq = LL_I2S_AUDIOFREQ_DEFAULT
    I2S_InitStruct.ClockPolarity = LL_I2S_POLARITY_LOW
}

public func LL_I2S_ConfigPrescaler<IO: SPIRegisterIO>(
    _ registers: IO, _ PrescalerLinear: UInt32, _ PrescalerParity: UInt32
) {

    registers.write(
        SPIRegister.i2scfgr,
        value: (registers.read(SPIRegister.i2scfgr) & ~(0xff0000 | 0x1000000))
            | ((PrescalerLinear << 0x10) | (PrescalerParity << 0x18)))
}
