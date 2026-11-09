// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_I3C_EVR_CFEF: UInt32 = 0x0000_0001
public let LL_I3C_EVR_TXFEF: UInt32 = 0x0000_0002
public let LL_I3C_EVR_CFNFF: UInt32 = 0x0000_0004
public let LL_I3C_EVR_SFNEF: UInt32 = 0x0000_0008
public let LL_I3C_EVR_TXFNFF: UInt32 = 0x0000_0010
public let LL_I3C_EVR_RXFNEF: UInt32 = 0x0000_0020
public let LL_I3C_EVR_RXLASTF: UInt32 = 0x0000_0080
public let LL_I3C_EVR_TXLASTF: UInt32 = 0x0000_0040
public let LL_I3C_EVR_FCF: UInt32 = 0x0000_0200
public let LL_I3C_EVR_RXTGTENDF: UInt32 = 0x0000_0400
public let LL_I3C_EVR_ERRF: UInt32 = 0x0000_0800
public let LL_I3C_EVR_IBIF: UInt32 = 0x0000_8000
public let LL_I3C_EVR_IBIENDF: UInt32 = 0x0001_0000
public let LL_I3C_EVR_CRF: UInt32 = 0x0002_0000
public let LL_I3C_EVR_CRUPDF: UInt32 = 0x0004_0000
public let LL_I3C_EVR_HJF: UInt32 = 0x0008_0000
public let LL_I3C_EVR_WKPF: UInt32 = 0x0020_0000
public let LL_I3C_EVR_GETF: UInt32 = 0x0040_0000
public let LL_I3C_EVR_STAF: UInt32 = 0x0080_0000
public let LL_I3C_EVR_DAUPDF: UInt32 = 0x0100_0000
public let LL_I3C_EVR_MWLUPDF: UInt32 = 0x0200_0000
public let LL_I3C_EVR_MRLUPDF: UInt32 = 0x0400_0000
public let LL_I3C_EVR_RSTF: UInt32 = 0x0800_0000
public let LL_I3C_EVR_ASUPDF: UInt32 = 0x1000_0000
public let LL_I3C_EVR_INTUPDF: UInt32 = 0x2000_0000
public let LL_I3C_EVR_DEFF: UInt32 = 0x4000_0000
public let LL_I3C_EVR_GRPF: UInt32 = 0x8000_0000
public let LL_I3C_SER_PERR: UInt32 = 0x0000_0010
public let LL_I3C_SER_STALL: UInt32 = 0x0000_0020
public let LL_I3C_SER_DOVR: UInt32 = 0x0000_0040
public let LL_I3C_SER_COVR: UInt32 = 0x0000_0080
public let LL_I3C_SER_ANACK: UInt32 = 0x0000_0100
public let LL_I3C_SER_DNACK: UInt32 = 0x0000_0200
public let LL_I3C_SER_DERR: UInt32 = 0x0000_0400
public let LL_I3C_IER_CFNFIE: UInt32 = 0x0000_0004
public let LL_I3C_IER_SFNEIE: UInt32 = 0x0000_0008
public let LL_I3C_IER_TXFNFIE: UInt32 = 0x0000_0010
public let LL_I3C_IER_RXFNEIE: UInt32 = 0x0000_0020
public let LL_I3C_IER_FCIE: UInt32 = 0x0000_0200
public let LL_I3C_IER_RXTGTENDIE: UInt32 = 0x0000_0400
public let LL_I3C_IER_ERRIE: UInt32 = 0x0000_0800
public let LL_I3C_IER_IBIIE: UInt32 = 0x0000_8000
public let LL_I3C_IER_IBIENDIE: UInt32 = 0x0001_0000
public let LL_I3C_IER_CRIE: UInt32 = 0x0002_0000
public let LL_I3C_IER_CRUPDIE: UInt32 = 0x0004_0000
public let LL_I3C_IER_HJIE: UInt32 = 0x0008_0000
public let LL_I3C_IER_WKPIE: UInt32 = 0x0020_0000
public let LL_I3C_IER_GETIE: UInt32 = 0x0040_0000
public let LL_I3C_IER_STAIE: UInt32 = 0x0080_0000
public let LL_I3C_IER_DAUPDIE: UInt32 = 0x0100_0000
public let LL_I3C_IER_MWLUPDIE: UInt32 = 0x0200_0000
public let LL_I3C_IER_MRLUPDIE: UInt32 = 0x0400_0000
public let LL_I3C_IER_RSTIE: UInt32 = 0x0800_0000
public let LL_I3C_IER_ASUPDIE: UInt32 = 0x1000_0000
public let LL_I3C_IER_INTUPDIE: UInt32 = 0x2000_0000
public let LL_I3C_IER_DEFIE: UInt32 = 0x4000_0000
public let LL_I3C_IER_GRPIE: UInt32 = 0x8000_0000
public let LL_I3C_MODE_CONTROLLER: UInt32 = 0x0000_0002
public let LL_I3C_MODE_TARGET: UInt32 = 0x0000_0000
public let LL_I3C_DMA_REG_DATA_TRANSMIT_BYTE: UInt32 = 0x0000_0000
public let LL_I3C_DMA_REG_DATA_RECEIVE_BYTE: UInt32 = 0x0000_0001
public let LL_I3C_DMA_REG_DATA_TRANSMIT_WORD: UInt32 = 0x0000_0002
public let LL_I3C_DMA_REG_DATA_RECEIVE_WORD: UInt32 = 0x0000_0003
public let LL_I3C_DMA_REG_STATUS: UInt32 = 0x0000_0004
public let LL_I3C_DMA_REG_CONTROL: UInt32 = 0x0000_0005
public let LL_I3C_RXFIFO_THRESHOLD_1_4: UInt32 = 0x0000_0000
public let LL_I3C_RXFIFO_THRESHOLD_4_4: UInt32 = 0x0000_0400
public let LL_I3C_TXFIFO_THRESHOLD_1_4: UInt32 = 0x0000_0000
public let LL_I3C_TXFIFO_THRESHOLD_4_4: UInt32 = 0x0000_4000
public let LL_I3C_PAYLOAD_EMPTY: UInt32 = 0x0000_0000
public let LL_I3C_PAYLOAD_1_BYTE: UInt32 = 0x0001_0000
public let LL_I3C_PAYLOAD_2_BYTES: UInt32 = 0x0002_0000
public let LL_I3C_PAYLOAD_3_BYTES: UInt32 = 0x0003_0000
public let LL_I3C_PAYLOAD_4_BYTES: UInt32 = 0x0004_0000
public let LL_I3C_SDA_HOLD_TIME_0_5: UInt32 = 0x0000_0000
public let LL_I3C_SDA_HOLD_TIME_1_5: UInt32 = 0x1000_0000
public let LL_I3C_OWN_ACTIVITY_STATE_0: UInt32 = 0x0000_0000
public let LL_I3C_OWN_ACTIVITY_STATE_1: UInt32 = 0x0000_0100
public let LL_I3C_OWN_ACTIVITY_STATE_2: UInt32 = 0x0000_0200
public let LL_I3C_OWN_ACTIVITY_STATE_3: UInt32 = 0x0000_0300
public let LL_I3C_DEVICE_ROLE_AS_TARGET: UInt32 = 0x0000_0000
public let LL_I3C_DEVICE_ROLE_AS_CONTROLLER: UInt32 = 0x0000_0040
public let LL_I3C_IBI_NO_ADDITIONAL_DATA: UInt32 = 0x0000_0000
public let LL_I3C_IBI_ADDITIONAL_DATA: UInt32 = 0x0000_0004
public let LL_I3C_NO_DATA_SPEED_LIMITATION: UInt32 = 0x0000_0000
public let LL_I3C_MAX_DATA_SPEED_LIMITATION: UInt32 = 0x0000_0001
public let LL_I3C_MDB_NO_PENDING_READ_NOTIFICATION: UInt32 = 0x0000_0000
public let LL_I3C_MDB_PENDING_READ_NOTIFICATION: UInt32 = 0x0000_4000
public let LL_I3C_HANDOFF_GRP_ADDR_NOT_SUPPORTED: UInt32 = 0x0000_0000
public let LL_I3C_HANDOFF_GRP_ADDR_SUPPORTED: UInt32 = 0x0000_0200
public let LL_I3C_HANDOFF_NOT_DELAYED: UInt32 = 0x0000_0000
public let LL_I3C_HANDOFF_DELAYED: UInt32 = 0x0000_0008
public let LL_I3C_HANDOFF_ACTIVITY_STATE_0: UInt32 = 0x0000_0000
public let LL_I3C_HANDOFF_ACTIVITY_STATE_1: UInt32 = 0x0000_0001
public let LL_I3C_HANDOFF_ACTIVITY_STATE_2: UInt32 = 0x0000_0002
public let LL_I3C_HANDOFF_ACTIVITY_STATE_3: UInt32 = 0x0000_0003
public let LL_I3C_GETMXDS_FORMAT_1: UInt32 = 0x0000_0000
public let LL_I3C_GETMXDS_FORMAT_2_LSB: UInt32 = 0x0000_0100
public let LL_I3C_GETMXDS_FORMAT_2_MID: UInt32 = 0x0000_0200
public let LL_I3C_GETMXDS_FORMAT_2_MSB: UInt32 = 0x0000_0300
public let LL_I3C_TURNAROUND_TIME_TSCO_LESS_12NS: UInt32 = 0x0000_0000
public let LL_I3C_TURNAROUND_TIME_TSCO_GREATER_12NS: UInt32 = 0x0100_0000
public let LL_I3C_BUS_ACTIVITY_STATE_0: UInt32 = 0x0000_0000
public let LL_I3C_BUS_ACTIVITY_STATE_1: UInt32 = 0x0010_0000
public let LL_I3C_BUS_ACTIVITY_STATE_2: UInt32 = 0x0020_0000
public let LL_I3C_BUS_ACTIVITY_STATE_3: UInt32 = 0x0030_0000
public let LL_I3C_RESET_ACTION_NONE: UInt32 = 0x0000_0000
public let LL_I3C_RESET_ACTION_PARTIAL: UInt32 = 0x0040_0000
public let LL_I3C_RESET_ACTION_FULL: UInt32 = 0x0080_0000
public let LL_I3C_DIRECTION_WRITE: UInt32 = 0x0000_0000
public let LL_I3C_DIRECTION_READ: UInt32 = 0x0001_0000
public let LL_I3C_GENERATE_STOP: UInt32 = 0x8000_0000
public let LL_I3C_GENERATE_RESTART: UInt32 = 0x0000_0000
public let LL_I3C_CONTROLLER_MTYPE_RELEASE: UInt32 = 0x0000_0000
public let LL_I3C_CONTROLLER_MTYPE_HEADER: UInt32 = 0x0800_0000
public let LL_I3C_CONTROLLER_MTYPE_PRIVATE: UInt32 = 0x1000_0000
public let LL_I3C_CONTROLLER_MTYPE_DIRECT: UInt32 = 0x1800_0000
public let LL_I3C_CONTROLLER_MTYPE_LEGACY_I2C: UInt32 = 0x2000_0000
public let LL_I3C_CONTROLLER_MTYPE_CCC: UInt32 = 0x3000_0000
public let LL_I3C_TARGET_MTYPE_HOT_JOIN: UInt32 = 0x4000_0000
public let LL_I3C_TARGET_MTYPE_CONTROLLER_ROLE_REQ: UInt32 = 0x4800_0000
public let LL_I3C_TARGET_MTYPE_IBI: UInt32 = 0x5000_0000
public let LL_I3C_MESSAGE_ERROR: UInt32 = 0x0000_0000
public let LL_I3C_MESSAGE_DIRECTION_WRITE: UInt32 = 0x0000_0000
public let LL_I3C_MESSAGE_DIRECTION_READ: UInt32 = 0x0004_0000
public let LL_I3C_CONTROLLER_ERROR_CE0: UInt32 = 0x0000_0000
public let LL_I3C_CONTROLLER_ERROR_CE1: UInt32 = 0x0000_0001
public let LL_I3C_CONTROLLER_ERROR_CE2: UInt32 = 0x0000_0002
public let LL_I3C_CONTROLLER_ERROR_CE3: UInt32 = 0x0000_0003
public let LL_I3C_TARGET_ERROR_TE0: UInt32 = 0x0000_0008
public let LL_I3C_TARGET_ERROR_TE1: UInt32 = 0x0000_0009
public let LL_I3C_TARGET_ERROR_TE2: UInt32 = 0x0000_000A
public let LL_I3C_TARGET_ERROR_TE3: UInt32 = 0x0000_000B
public let LL_I3C_TARGET_ERROR_TE4: UInt32 = 0x0000_000C
public let LL_I3C_TARGET_ERROR_TE5: UInt32 = 0x0000_000D
public let LL_I3C_TARGET_ERROR_TE6: UInt32 = 0x0000_000E
public let LL_I3C_BCR_IN_PAYLOAD_SHIFT: UInt32 = 0x0000_0030
public let LL_I3C_IBI_CAPABILITY: UInt32 = 0x0001_0000
public let LL_I3C_IBI_NO_CAPABILITY: UInt32 = 0x0000_0000
public let LL_I3C_IBI_DATA_ENABLE: UInt32 = 0x0004_0000
public let LL_I3C_IBI_DATA_DISABLE: UInt32 = 0x0000_0000
public let LL_I3C_CR_CAPABILITY: UInt32 = 0x0002_0000
public let LL_I3C_CR_NO_CAPABILITY: UInt32 = 0x0000_0000

public func LL_I3C_Enable<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x1))
}

public func LL_I3C_Disable<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x1))
}

public func LL_I3C_IsEnabled<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_I3C_IsEnabledReset<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.devr0) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_I3C_SetMode<IO: I3CRegisterIO>(_ registers: IO, _ PeripheralMode: UInt32) {
    registers.write(I3CRegister.cfgr, value: (registers.read(I3CRegister.cfgr) & ~(0x2)) | (PeripheralMode))
}

public func LL_I3C_GetMode<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_I3C_EnableArbitrationHeader<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x4))
}

public func LL_I3C_DisableArbitrationHeader<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x4))
}

public func LL_I3C_IsEnabledArbitrationHeader<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x4)) == (0x4)) ? 0 : 1)
}

public func LL_I3C_EnableResetPattern<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x8))
}

public func LL_I3C_DisableResetPattern<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x8))
}

public func LL_I3C_IsEnabledResetPattern<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_I3C_EnableExitPattern<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x10))
}

public func LL_I3C_DisableExitPattern<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x10))
}

public func LL_I3C_IsEnabledExitPattern<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_I3C_EnableHighKeeperSDA<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x20))
}

public func LL_I3C_DisableHighKeeperSDA<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x20))
}

public func LL_I3C_IsEnabledHighKeeperSDA<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_I3C_EnableHJAck<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x80))
}

public func LL_I3C_DisableHJAck<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x80))
}

public func LL_I3C_IsEnabledHJAck<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_I3C_DMA_GetRegAddr<IO: I3CRegisterIO>(_ registers: IO, _ Direction: UInt32) -> UInt32 {
    if Direction == LL_I3C_DMA_REG_DATA_TRANSMIT_BYTE { return registers.address(of: .tdr) }
    if Direction == LL_I3C_DMA_REG_DATA_RECEIVE_BYTE { return registers.address(of: .rdr) }
    if Direction == LL_I3C_DMA_REG_DATA_TRANSMIT_WORD { return registers.address(of: .tdwr) }
    if Direction == LL_I3C_DMA_REG_DATA_RECEIVE_WORD { return registers.address(of: .rdwr) }
    if Direction == LL_I3C_DMA_REG_STATUS { return registers.address(of: .sr) }
    return registers.address(of: .cr)
}

public func LL_I3C_EnableDMAReq_RX<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x100))
}

public func LL_I3C_DisableDMAReq_RX<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x100))
}

public func LL_I3C_IsEnabledDMAReq_RX<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_I3C_SetRxFIFOThreshold<IO: I3CRegisterIO>(_ registers: IO, _ RxFIFOThreshold: UInt32) {
    registers.write(I3CRegister.cfgr, value: (registers.read(I3CRegister.cfgr) & ~(0x400)) | (RxFIFOThreshold))
}

public func LL_I3C_GetRxFIFOThreshold<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.cfgr) & (0x400)))
}

public func LL_I3C_EnableDMAReq_TX<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x1000))
}

public func LL_I3C_DisableDMAReq_TX<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x1000))
}

public func LL_I3C_IsEnabledDMAReq_TX<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_I3C_SetTxFIFOThreshold<IO: I3CRegisterIO>(_ registers: IO, _ TxFIFOThreshold: UInt32) {
    registers.write(I3CRegister.cfgr, value: (registers.read(I3CRegister.cfgr) & ~(0x4000)) | (TxFIFOThreshold))
}

public func LL_I3C_GetTxFIFOThreshold<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.cfgr) & (0x4000)))
}

public func LL_I3C_EnableDMAReq_Status<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x10000))
}

public func LL_I3C_DisableDMAReq_Status<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x10000))
}

public func LL_I3C_IsEnabledDMAReq_Status<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_I3C_EnableStatusFIFO<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x40000))
}

public func LL_I3C_DisableStatusFIFO<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x40000))
}

public func LL_I3C_IsEnabledStatusFIFO<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_I3C_EnableControlFIFO<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x80000))
}

public func LL_I3C_DisableControlFIFO<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x80000))
}

public func LL_I3C_IsEnabledControlFIFO<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_I3C_EnableDMAReq_Control<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x100000))
}

public func LL_I3C_DisableDMAReq_Control<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) & ~(0x100000))
}

public func LL_I3C_IsEnabledDMAReq_Control<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.cfgr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_I3C_EnableOwnDynAddress<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.devr0, value: registers.read(I3CRegister.devr0) | (0x1))
}

public func LL_I3C_DisableOwnDynAddress<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.devr0, value: registers.read(I3CRegister.devr0) & ~(0x1))
}

public func LL_I3C_IsEnabledOwnDynAddress<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.devr0) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_I3C_SetOwnDynamicAddress<IO: I3CRegisterIO>(_ registers: IO, _ OwnDynamicAddress: UInt32) {
    registers.write(
        I3CRegister.devr0, value: (registers.read(I3CRegister.devr0) & ~(0xfe)) | ((OwnDynamicAddress << 0x1)))
}

public func LL_I3C_GetOwnDynamicAddress<IO: I3CRegisterIO>(_ registers: IO) -> UInt8 {
    return UInt8(truncatingIfNeeded: ((registers.read(I3CRegister.devr0) & (0xfe)) >> 0x1))
}

public func LL_I3C_EnableIBI<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.devr0, value: registers.read(I3CRegister.devr0) | (0x10000))
}

public func LL_I3C_DisableIBI<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.devr0, value: registers.read(I3CRegister.devr0) & ~(0x10000))
}

public func LL_I3C_IsEnabledIBI<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.devr0) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_I3C_EnableControllerRoleReq<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.devr0, value: registers.read(I3CRegister.devr0) | (0x20000))
}

public func LL_I3C_DisableControllerRoleReq<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.devr0, value: registers.read(I3CRegister.devr0) & ~(0x20000))
}

public func LL_I3C_IsEnabledControllerRoleReq<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.devr0) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_I3C_EnableHotJoin<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.devr0, value: registers.read(I3CRegister.devr0) | (0x80000))
}

public func LL_I3C_DisableHotJoin<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.devr0, value: registers.read(I3CRegister.devr0) & ~(0x80000))
}

public func LL_I3C_IsEnabledHotJoin<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.devr0) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_I3C_SetMaxReadLength<IO: I3CRegisterIO>(_ registers: IO, _ MaxReadLength: UInt16) {
    registers.write(
        I3CRegister.maxrlr, value: (registers.read(I3CRegister.maxrlr) & ~(0xffff)) | (UInt32(MaxReadLength)))
}

public func LL_I3C_GetMaxReadLength<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.maxrlr) & (0xffff)))
}

public func LL_I3C_ConfigNbIBIAddData<IO: I3CRegisterIO>(_ registers: IO, _ NbIBIAddData: UInt32) {
    registers.write(I3CRegister.maxrlr, value: (registers.read(I3CRegister.maxrlr) & ~(0x70000)) | (NbIBIAddData))
}

public func LL_I3C_GetConfigNbIBIAddData<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.maxrlr) & (0x70000)))
}

public func LL_I3C_SetMaxWriteLength<IO: I3CRegisterIO>(_ registers: IO, _ MaxWriteLength: UInt16) {
    registers.write(
        I3CRegister.maxwlr, value: (registers.read(I3CRegister.maxwlr) & ~(0xffff)) | (UInt32(MaxWriteLength)))
}

public func LL_I3C_GetMaxWriteLength<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.maxwlr) & (0xffff)))
}

public func LL_I3C_ConfigClockWaveForm<IO: I3CRegisterIO>(_ registers: IO, _ ClockWaveForm: UInt32) {
    registers.write(I3CRegister.timingr0, value: ClockWaveForm)
}

public func LL_I3C_GetClockWaveForm<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(I3CRegister.timingr0))
}

public func LL_I3C_SetPeriodClockLowPP<IO: I3CRegisterIO>(_ registers: IO, _ PeriodClockLowPP: UInt32) {
    registers.write(
        I3CRegister.timingr0, value: (registers.read(I3CRegister.timingr0) & ~(0xff)) | ((PeriodClockLowPP << 0x0)))
}

public func LL_I3C_GetPeriodClockLowPP<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr0) & (0xff)) >> 0x0)
}

public func LL_I3C_SetPeriodClockHighI3C<IO: I3CRegisterIO>(_ registers: IO, _ PeriodClockHighI3C: UInt32) {
    registers.write(
        I3CRegister.timingr0, value: (registers.read(I3CRegister.timingr0) & ~(0xff00)) | ((PeriodClockHighI3C << 0x8)))
}

public func LL_I3C_GetPeriodClockHighI3C<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr0) & (0xff00)) >> 0x8)
}

public func LL_I3C_SetPeriodClockLowOD<IO: I3CRegisterIO>(_ registers: IO, _ PeriodClockLowOD: UInt32) {
    registers.write(
        I3CRegister.timingr0, value: (registers.read(I3CRegister.timingr0) & ~(0xff0000)) | ((PeriodClockLowOD << 0x10))
    )
}

public func LL_I3C_GetPeriodClockLowOD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr0) & (0xff0000)) >> 0x10)
}

public func LL_I3C_SetPeriodClockHighI2C<IO: I3CRegisterIO>(_ registers: IO, _ PeriodClockHighI2C: UInt32) {
    registers.write(
        I3CRegister.timingr0,
        value: (registers.read(I3CRegister.timingr0) & ~(0xff00_0000)) | (PeriodClockHighI2C << 0x18))
}

public func LL_I3C_GetPeriodClockHighI2C<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr0) & (0xff00_0000)) >> 0x18)
}

public func LL_I3C_SetDataHoldTime<IO: I3CRegisterIO>(_ registers: IO, _ DataHoldTime: UInt32) {
    registers.write(
        I3CRegister.timingr1, value: (registers.read(I3CRegister.timingr1) & ~(0x1000_0000)) | (DataHoldTime))
}

public func LL_I3C_GetDataHoldTime<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr1) & (0x1000_0000)))
}

public func LL_I3C_SetAvalTiming<IO: I3CRegisterIO>(_ registers: IO, _ AvalTiming: UInt32) {
    registers.write(
        I3CRegister.timingr1, value: (registers.read(I3CRegister.timingr1) & ~(0xff)) | ((AvalTiming << 0x0)))
}

public func LL_I3C_GetAvalTiming<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr1) & (0xff)) >> 0x0)
}

public func LL_I3C_SetFreeTiming<IO: I3CRegisterIO>(_ registers: IO, _ FreeTiming: UInt32) {
    registers.write(
        I3CRegister.timingr1, value: (registers.read(I3CRegister.timingr1) & ~(0x7f0000)) | ((FreeTiming << 0x10)))
}

public func LL_I3C_GetFreeTiming<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr1) & (0x7f0000)) >> 0x10)
}

public func LL_I3C_SetControllerActivityState<IO: I3CRegisterIO>(_ registers: IO, _ ControllerActivityState: UInt32) {
    registers.write(
        I3CRegister.timingr1, value: (registers.read(I3CRegister.timingr1) & ~(0x300)) | (ControllerActivityState))
}

public func LL_I3C_GetControllerActivityState<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr1) & (0x300)))
}

public func LL_I3C_SetCtrlBusCharacteristic<IO: I3CRegisterIO>(_ registers: IO, _ CtrlBusCharacteristic: UInt32) {
    registers.write(I3CRegister.timingr1, value: CtrlBusCharacteristic)
}

public func LL_I3C_GetCtrlBusCharacteristic<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(I3CRegister.timingr1))
}

public func LL_I3C_SetTgtBusCharacteristic<IO: I3CRegisterIO>(_ registers: IO, _ TgtBusCharacteristic: UInt32) {
    registers.write(
        I3CRegister.timingr1, value: (registers.read(I3CRegister.timingr1) & ~(0xff)) | ((TgtBusCharacteristic & 0xff)))
}

public func LL_I3C_GetTgtBusCharacteristic<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr1) & (0xff)))
}

public func LL_I3C_SetStallTime<IO: I3CRegisterIO>(_ registers: IO, _ ControllerStallTime: UInt32) {
    registers.write(
        I3CRegister.timingr2, value: (registers.read(I3CRegister.timingr2) & ~(0xff00)) | ((ControllerStallTime << 0x8))
    )
}

public func LL_I3C_GetStallTime<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.timingr2) & (0xff00)))
}

public func LL_I3C_EnableStallACK<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.timingr2, value: registers.read(I3CRegister.timingr2) | (0x8))
}

public func LL_I3C_DisableStallACK<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.timingr2, value: registers.read(I3CRegister.timingr2) & ~(0x8))
}

public func LL_I3C_IsEnabledStallACK<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.timingr2) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_I3C_EnableStallParityCCC<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.timingr2, value: registers.read(I3CRegister.timingr2) | (0x4))
}

public func LL_I3C_DisableStallParityCCC<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.timingr2, value: registers.read(I3CRegister.timingr2) & ~(0x4))
}

public func LL_I3C_IsEnabledStallParityCCC<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.timingr2) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_I3C_EnableStallParityData<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.timingr2, value: registers.read(I3CRegister.timingr2) | (0x2))
}

public func LL_I3C_DisableStallParityData<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.timingr2, value: registers.read(I3CRegister.timingr2) & ~(0x2))
}

public func LL_I3C_IsEnabledStallParityData<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.timingr2) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_I3C_EnableStallTbit<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.timingr2, value: registers.read(I3CRegister.timingr2) | (0x1))
}

public func LL_I3C_DisableStallTbit<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.timingr2, value: registers.read(I3CRegister.timingr2) & ~(0x1))
}

public func LL_I3C_IsEnabledStallTbit<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.timingr2) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_I3C_SetDeviceCapabilityOnBus<IO: I3CRegisterIO>(_ registers: IO, _ DeviceCapabilityOnBus: UInt32) {
    registers.write(I3CRegister.bcr, value: (registers.read(I3CRegister.bcr) & ~(0x40)) | (DeviceCapabilityOnBus))
}

public func LL_I3C_GetDeviceCapabilityOnBus<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.bcr) & (0x40)))
}

public func LL_I3C_SetDeviceIBIPayload<IO: I3CRegisterIO>(_ registers: IO, _ DeviceIBIPayload: UInt32) {
    registers.write(I3CRegister.bcr, value: (registers.read(I3CRegister.bcr) & ~(0x4)) | (DeviceIBIPayload))
}

public func LL_I3C_GetDeviceIBIPayload<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.bcr) & (0x4)))
}

public func LL_I3C_SetDataSpeedLimitation<IO: I3CRegisterIO>(_ registers: IO, _ DataSpeedLimitation: UInt32) {
    registers.write(I3CRegister.bcr, value: (registers.read(I3CRegister.bcr) & ~(0x1)) | (DataSpeedLimitation))
}

public func LL_I3C_GetDataSpeedLimitation<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.bcr) & (0x1)))
}

public func LL_I3C_SetDeviceCharacteristics<IO: I3CRegisterIO>(_ registers: IO, _ DeviceCharacteristics: UInt32) {
    registers.write(I3CRegister.dcr, value: (registers.read(I3CRegister.dcr) & ~(0xff)) | (DeviceCharacteristics))
}

public func LL_I3C_GetDeviceCharacteristics<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.dcr) & (0xff)))
}

public func LL_I3C_SetPendingReadMDB<IO: I3CRegisterIO>(_ registers: IO, _ PendingReadMDB: UInt32) {
    registers.write(I3CRegister.getcapr, value: (registers.read(I3CRegister.getcapr) & ~(0x4000)) | (PendingReadMDB))
}

public func LL_I3C_GetPendingReadMDB<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.getcapr) & (0x4000)))
}

public func LL_I3C_SetGrpAddrHandoffSupport<IO: I3CRegisterIO>(_ registers: IO, _ GrpAddrHandoffSupport: UInt32) {
    registers.write(
        I3CRegister.crcapr, value: (registers.read(I3CRegister.crcapr) & ~(0x200)) | (GrpAddrHandoffSupport))
}

public func LL_I3C_GetGrpAddrHandoffSupport<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.crcapr) & (0x200)))
}

public func LL_I3C_SetControllerHandoffDelayed<IO: I3CRegisterIO>(_ registers: IO, _ ControllerHandoffDelayed: UInt32) {
    registers.write(
        I3CRegister.crcapr, value: (registers.read(I3CRegister.crcapr) & ~(0x8)) | (ControllerHandoffDelayed))
}

public func LL_I3C_GetControllerHandoffDelayed<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.crcapr) & (0x8)))
}

public func LL_I3C_SetHandoffActivityState<IO: I3CRegisterIO>(_ registers: IO, _ HandoffActivityState: UInt32) {
    registers.write(
        I3CRegister.getmxdsr, value: (registers.read(I3CRegister.getmxdsr) & ~(0x3)) | (HandoffActivityState))
}

public func LL_I3C_GetHandoffActivityState<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.getmxdsr) & (0x3)))
}

public func LL_I3C_SetMaxDataSpeedFormat<IO: I3CRegisterIO>(_ registers: IO, _ MaxDataSpeedFormat: UInt32) {
    registers.write(
        I3CRegister.getmxdsr, value: (registers.read(I3CRegister.getmxdsr) & ~(0x300)) | (MaxDataSpeedFormat))
}

public func LL_I3C_GetMaxDataSpeedFormat<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.getmxdsr) & (0x300)))
}

public func LL_I3C_SetMiddleByteTurnAround<IO: I3CRegisterIO>(_ registers: IO, _ MiddleByteTurnAround: UInt32) {
    registers.write(
        I3CRegister.getmxdsr,
        value: (registers.read(I3CRegister.getmxdsr) & ~(0xff0000)) | ((MiddleByteTurnAround << 0x10)))
}

public func LL_I3C_GetMiddleByteTurnAround<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.getmxdsr) & (0xff0000)))
}

public func LL_I3C_SetDataTurnAroundTime<IO: I3CRegisterIO>(_ registers: IO, _ DataTurnAroundTime: UInt32) {
    registers.write(
        I3CRegister.getmxdsr, value: (registers.read(I3CRegister.getmxdsr) & ~(0x1000000)) | (DataTurnAroundTime))
}

public func LL_I3C_GetDataTurnAroundTime<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.getmxdsr) & (0x1000000)))
}

public func LL_I3C_SetMIPIInstanceID<IO: I3CRegisterIO>(_ registers: IO, _ MIPIInstanceID: UInt32) {
    registers.write(
        I3CRegister.epidr, value: (registers.read(I3CRegister.epidr) & ~(0xf000)) | ((MIPIInstanceID << 0xc)))
}

public func LL_I3C_GetMIPIInstanceID<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.epidr) & (0xf000)) >> 0xc)
}

public func LL_I3C_GetIDTypeSelector<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.epidr) & (0x10000)) >> 0x10)
}

public func LL_I3C_GetMIPIManufacturerID<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.epidr) & (0xfffe_0000)) >> 0x11)
}

public func LL_I3C_RequestRxFIFOFlush<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x200))
}

public func LL_I3C_RequestTxFIFOFlush<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x2000))
}

public func LL_I3C_RequestStatusFIFOFlush<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x20000))
}

public func LL_I3C_GetActivityState<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.devr0) & (0x300000)))
}

public func LL_I3C_GetResetAction<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.devr0) & (0xc00000)))
}

public func LL_I3C_RequestControlFIFOFlush<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x200000))
}

public func LL_I3C_RequestTransfer<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cfgr, value: registers.read(I3CRegister.cfgr) | (0x4000_0000))
}

public func LL_I3C_ControllerHandleMessage<IO: I3CRegisterIO>(
    _ registers: IO, _ TargetAddr: UInt32, _ TransferSize: UInt32, _ Direction: UInt32, _ MessageType: UInt32,
    _ EndMode: UInt32
) {
    registers.write(
        I3CRegister.cr,
        value: ((TargetAddr << 0x11) | TransferSize | Direction | MessageType | EndMode)
            & (0xfe0000 | 0xffff | 0x10000 | 0x7800_0000 | 0x8000_0000))
}

public func LL_I3C_ControllerHandleCCC<IO: I3CRegisterIO>(
    _ registers: IO, _ CCCValue: UInt32, _ AddByteSize: UInt32, _ EndMode: UInt32
) {
    registers.write(
        I3CRegister.cr,
        value: ((CCCValue << 0x10) | AddByteSize | EndMode | LL_I3C_CONTROLLER_MTYPE_CCC)
            & (0xff0000 | 0xffff | 0x7800_0000 | 0x8000_0000))
}

public func LL_I3C_TargetHandleMessage<IO: I3CRegisterIO>(_ registers: IO, _ MessageType: UInt32, _ IBISize: UInt32) {
    registers.write(I3CRegister.cr, value: (MessageType | IBISize) & (0xffff | 0x7800_0000))
}

public func LL_I3C_ReceiveData8<IO: I3CRegisterIO>(_ registers: IO) -> UInt8 {
    return UInt8(truncatingIfNeeded: ((registers.read(I3CRegister.rdr) & (0xff))))
}

public func LL_I3C_TransmitData8<IO: I3CRegisterIO>(_ registers: IO, _ Data: UInt8) {
    registers.write(I3CRegister.tdr, value: UInt32(Data))
}

public func LL_I3C_ReceiveData32<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(I3CRegister.rdwr))
}

public func LL_I3C_TransmitData32<IO: I3CRegisterIO>(_ registers: IO, _ Data: UInt32) {
    registers.write(I3CRegister.tdwr, value: Data)
}

public func LL_I3C_SetIBIPayload<IO: I3CRegisterIO>(_ registers: IO, _ OwnIBIPayload: UInt32) {
    registers.write(I3CRegister.ibidr, value: OwnIBIPayload)
}

public func LL_I3C_GetIBIPayload<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(I3CRegister.ibidr))
}

public func LL_I3C_GetNbIBIAddData<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.rmr) & (0x7)))
}

public func LL_I3C_GetIBITargetAddr<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.rmr) & (0xfe0000)) >> 0x11)
}

public func LL_I3C_ConfigTxPreload<IO: I3CRegisterIO>(_ registers: IO, _ TxDataCount: UInt16) {
    registers.write(
        I3CRegister.tgttdr,
        value: (registers.read(I3CRegister.tgttdr) & ~((0x10000 | 0xffff))) | ((0x10000 | UInt32(TxDataCount))))
}

public func LL_I3C_IsActiveTxPreload<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.tgttdr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_I3C_GetTxPreloadDataCount<IO: I3CRegisterIO>(_ registers: IO) -> UInt16 {
    return UInt16(truncatingIfNeeded: ((registers.read(I3CRegister.tgttdr) & (0xffff))))
}

public func LL_I3C_GetXferDataCount<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.sr) & (0xffff)))
}

public func LL_I3C_IsTargetAbortPrivateRead<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.sr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_I3C_GetMessageDirection<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.sr) & (0x40000)))
}

public func LL_I3C_GetMessageIdentifier<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.sr) & (0xff00_0000)))
}

public func LL_I3C_GetMessageErrorCode<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.ser) & (0xf)))
}

public func LL_I3C_GetReceiveCommandCode<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I3CRegister.rmr) & (0xff00)) >> 0x8)
}

public func LL_I3C_SetTargetDynamicAddress<IO: I3CRegisterIO>(
    _ registers: IO, _ TargetId: UInt32, _ DynamicAddr: UInt32
) {
    registers.write(
        _llI3CTargetRegister(TargetId),
        value: (registers.read(_llI3CTargetRegister(TargetId)) & ~(0xfe)) | ((DynamicAddr << 0x1)))
}

public func LL_I3C_GetTargetDynamicAddress<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) -> UInt32 {
    return (((registers.read(_llI3CTargetRegister(TargetId)) & (0xfe))) >> 0x1)
}

public func LL_I3C_EnableTargetIBIAck<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) {
    registers.write(_llI3CTargetRegister(TargetId), value: registers.read(_llI3CTargetRegister(TargetId)) | (0x10000))
}

public func LL_I3C_DisableTargetIBIAck<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) {
    registers.write(_llI3CTargetRegister(TargetId), value: registers.read(_llI3CTargetRegister(TargetId)) & ~(0x10000))
}

public func LL_I3C_IsEnabledTargetIBIAck<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) -> UInt32 {
    return (((registers.read(_llI3CTargetRegister(TargetId)) & (0x10000)) == 0x10000) ? 1 : 0)
}

public func LL_I3C_EnableTargetCRAck<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) {
    registers.write(_llI3CTargetRegister(TargetId), value: registers.read(_llI3CTargetRegister(TargetId)) | (0x20000))
}

public func LL_I3C_DisableTargetCRAck<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) {
    registers.write(_llI3CTargetRegister(TargetId), value: registers.read(_llI3CTargetRegister(TargetId)) & ~(0x20000))
}

public func LL_I3C_IsEnabledTargetCRAck<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) -> UInt32 {
    return (((registers.read(_llI3CTargetRegister(TargetId)) & (0x20000)) == 0x20000) ? 1 : 0)
}

public func LL_I3C_EnableIBIAddData<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) {
    registers.write(_llI3CTargetRegister(TargetId), value: registers.read(_llI3CTargetRegister(TargetId)) | (0x40000))
}

public func LL_I3C_DisableIBIAddData<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) {
    registers.write(_llI3CTargetRegister(TargetId), value: registers.read(_llI3CTargetRegister(TargetId)) & ~(0x40000))
}

public func LL_I3C_IsEnabledIBIAddData<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) -> UInt32 {
    return (((registers.read(_llI3CTargetRegister(TargetId)) & (0x40000)) == 0x40000) ? 1 : 0)
}

public func LL_I3C_EnableFrameSuspend<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) {
    registers.write(_llI3CTargetRegister(TargetId), value: registers.read(_llI3CTargetRegister(TargetId)) | (0x80000))
}

public func LL_I3C_DisableFrameSuspend<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) {
    registers.write(_llI3CTargetRegister(TargetId), value: registers.read(_llI3CTargetRegister(TargetId)) & ~(0x80000))
}

public func LL_I3C_IsFrameMustBeSuspended<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) -> UInt32 {
    return (((registers.read(_llI3CTargetRegister(TargetId)) & (0x80000)) == 0x80000) ? 1 : 0)
}

public func LL_I3C_IsAllowedPayloadUpdate<IO: I3CRegisterIO>(_ registers: IO, _ TargetId: UInt32) -> UInt32 {
    return (((registers.read(_llI3CTargetRegister(TargetId)) & (0x8000_0000)) != 0x8000_0000) ? 1 : 0)
}

public func LL_I3C_ConfigDeviceCapabilities<IO: I3CRegisterIO>(
    _ registers: IO, _ TargetId: UInt32, _ DynamicAddr: UInt32, _ IBIAck: UInt32, _ IBIAddData: UInt32, _ CRAck: UInt32
) {
    registers.write(
        _llI3CTargetRegister(TargetId),
        value: (registers.read(_llI3CTargetRegister(TargetId)) & ~((0xfe | 0x10000 | 0x20000 | 0x40000)))
            | (((DynamicAddr << 0x1) | IBIAck | IBIAddData | CRAck)))
}

public func LL_I3C_IsActiveFlag_CFE<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_TXFE<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_CFNF<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_SFNE<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_TXFNF<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_RXFNE<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_RXLAST<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_TXLAST<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_FC<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_RXTGTEND<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_ERR<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_IBI<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_IBIEND<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_CR<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_CRUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_HJ<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_WKP<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_GET<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_STA<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_DAUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_MWLUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x2000000)) == (0x2000000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_MRLUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_RST<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x8000000)) == (0x8000000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_ASUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x1000_0000)) == (0x1000_0000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_INTUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x2000_0000)) == (0x2000_0000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_DEF<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_GRP<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.evr) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_PERR<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ser) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_STALL<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ser) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_DOVR<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ser) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_COVR<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ser) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_ANACK<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ser) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_DNACK<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ser) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_I3C_IsActiveFlag_DERR<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ser) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_I3C_EnableIT_CFNF<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x4))
}

public func LL_I3C_DisableIT_CFNF<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x4))
}

public func LL_I3C_IsEnabledIT_CFNF<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_I3C_EnableIT_SFNE<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x8))
}

public func LL_I3C_DisableIT_SFNE<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x8))
}

public func LL_I3C_IsEnabledIT_SFNE<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_I3C_EnableIT_TXFNF<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x10))
}

public func LL_I3C_DisableIT_TXFNF<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x10))
}

public func LL_I3C_IsEnabledIT_TXFNF<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_I3C_EnableIT_RXFNE<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x20))
}

public func LL_I3C_DisableIT_RXFNE<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x20))
}

public func LL_I3C_IsEnabledIT_RXFNE<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_I3C_EnableIT_FC<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x200))
}

public func LL_I3C_DisableIT_FC<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x200))
}

public func LL_I3C_IsEnabledIT_FC<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_I3C_EnableIT_RXTGTEND<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x400))
}

public func LL_I3C_DisableIT_RXTGTEND<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x400))
}

public func LL_I3C_IsEnabledIT_RXTGTEND<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_I3C_EnableIT_ERR<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x800))
}

public func LL_I3C_DisableIT_ERR<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x800))
}

public func LL_I3C_IsEnabledIT_ERR<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_I3C_EnableIT_IBI<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x8000))
}

public func LL_I3C_DisableIT_IBI<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x8000))
}

public func LL_I3C_IsEnabledIT_IBI<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_IBIEND<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x10000))
}

public func LL_I3C_DisableIT_IBIEND<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x10000))
}

public func LL_I3C_IsEnabledIT_IBIEND<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_CR<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x20000))
}

public func LL_I3C_DisableIT_CR<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x20000))
}

public func LL_I3C_IsEnabledIT_CR<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_CRUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x40000))
}

public func LL_I3C_DisableIT_CRUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x40000))
}

public func LL_I3C_IsEnabledIT_CRUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_HJ<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x80000))
}

public func LL_I3C_DisableIT_HJ<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x80000))
}

public func LL_I3C_IsEnabledIT_HJ<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_WKP<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x200000))
}

public func LL_I3C_DisableIT_WKP<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x200000))
}

public func LL_I3C_IsEnabledIT_WKP<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_GET<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x400000))
}

public func LL_I3C_DisableIT_GET<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x400000))
}

public func LL_I3C_IsEnabledIT_GET<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_STA<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x800000))
}

public func LL_I3C_DisableIT_STA<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x800000))
}

public func LL_I3C_IsEnabledIT_STA<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_DAUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x1000000))
}

public func LL_I3C_DisableIT_DAUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x1000000))
}

public func LL_I3C_IsEnabledIT_DAUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_MWLUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x2000000))
}

public func LL_I3C_DisableIT_MWLUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x2000000))
}

public func LL_I3C_IsEnabledIT_MWLUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x2000000)) == (0x2000000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_MRLUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x4000000))
}

public func LL_I3C_DisableIT_MRLUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x4000000))
}

public func LL_I3C_IsEnabledIT_MRLUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_RST<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x8000000))
}

public func LL_I3C_DisableIT_RST<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x8000000))
}

public func LL_I3C_IsEnabledIT_RST<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x8000000)) == (0x8000000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_ASUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x1000_0000))
}

public func LL_I3C_DisableIT_ASUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x1000_0000))
}

public func LL_I3C_IsEnabledIT_ASUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x1000_0000)) == (0x1000_0000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_INTUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x2000_0000))
}

public func LL_I3C_DisableIT_INTUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x2000_0000))
}

public func LL_I3C_IsEnabledIT_INTUPD<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x2000_0000)) == (0x2000_0000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_DEF<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x4000_0000))
}

public func LL_I3C_DisableIT_DEF<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x4000_0000))
}

public func LL_I3C_IsEnabledIT_DEF<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_I3C_EnableIT_GRP<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) | (0x8000_0000))
}

public func LL_I3C_DisableIT_GRP<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.ier, value: registers.read(I3CRegister.ier) & ~(0x8000_0000))
}

public func LL_I3C_IsEnabledIT_GRP<IO: I3CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I3CRegister.ier) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_I3C_ClearFlag_FC<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x200)
}

public func LL_I3C_ClearFlag_RXTGTEND<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x400)
}

public func LL_I3C_ClearFlag_ERR<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x800)
}

public func LL_I3C_ClearFlag_IBI<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x8000)
}

public func LL_I3C_ClearFlag_IBIEND<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x10000)
}

public func LL_I3C_ClearFlag_CR<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x20000)
}

public func LL_I3C_ClearFlag_CRUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x40000)
}

public func LL_I3C_ClearFlag_HJ<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x80000)
}

public func LL_I3C_ClearFlag_WKP<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x200000)
}

public func LL_I3C_ClearFlag_GET<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x400000)
}

public func LL_I3C_ClearFlag_STA<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x800000)
}

public func LL_I3C_ClearFlag_DAUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x1000000)
}

public func LL_I3C_ClearFlag_MWLUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x2000000)
}

public func LL_I3C_ClearFlag_MRLUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x4000000)
}

public func LL_I3C_ClearFlag_RST<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x8000000)
}

public func LL_I3C_ClearFlag_ASUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x1000_0000)
}

public func LL_I3C_ClearFlag_INTUPD<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x2000_0000)
}

public func LL_I3C_ClearFlag_DEF<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x4000_0000)
}

public func LL_I3C_ClearFlag_GRP<IO: I3CRegisterIO>(_ registers: IO) {
    registers.write(I3CRegister.cevr, value: 0x8000_0000)
}

public func LL_I3C_DeInit<IO: I3CRegisterIO & LLBusRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue

    _ = registers

    LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_I3C1)

    LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_I3C1)
    return LLErrorStatus(rawValue: status)!
}

public func LL_I3C_Init<IO: I3CRegisterIO>(_ registers: IO, _ I3C_InitStruct: inout LL_I3C_InitTypeDef, _ Mode: UInt32)
    -> LLErrorStatus
{
    var waveform_value: UInt32
    var timing_value: UInt32

    LL_I3C_Disable(registers)

    if Mode == LL_I3C_MODE_CONTROLLER {

        LL_I3C_SetMode(registers, LL_I3C_MODE_CONTROLLER)

        waveform_value =
            ((UInt32(I3C_InitStruct.CtrlBusCharacteristic.SCLPPLowDuration))
                | (UInt32(I3C_InitStruct.CtrlBusCharacteristic.SCLI3CHighDuration) << 0x8)
                | (UInt32(I3C_InitStruct.CtrlBusCharacteristic.SCLODLowDuration) << 0x10)
                | (UInt32(I3C_InitStruct.CtrlBusCharacteristic.SCLI2CHighDuration) << 0x18))
        LL_I3C_ConfigClockWaveForm(registers, waveform_value)

        timing_value =
            ((I3C_InitStruct.CtrlBusCharacteristic.SDAHoldTime) | (I3C_InitStruct.CtrlBusCharacteristic.WaitTime)
                | (UInt32(I3C_InitStruct.CtrlBusCharacteristic.BusFreeDuration) << 0x10)
                | (UInt32(I3C_InitStruct.CtrlBusCharacteristic.BusIdleDuration)))
        LL_I3C_SetCtrlBusCharacteristic(registers, timing_value)
    } else {
        LL_I3C_SetMode(registers, LL_I3C_MODE_TARGET)

        LL_I3C_SetTgtBusCharacteristic(registers, UInt32(I3C_InitStruct.TgtBusCharacteristic.BusAvailableDuration))
    }

    LL_I3C_Enable(registers)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_I3C_StructInit(_ I3C_InitStruct: inout LL_I3C_InitTypeDef) {
    I3C_InitStruct.CtrlBusCharacteristic.SDAHoldTime = LL_I3C_SDA_HOLD_TIME_0_5
    I3C_InitStruct.CtrlBusCharacteristic.WaitTime = LL_I3C_OWN_ACTIVITY_STATE_0
    I3C_InitStruct.CtrlBusCharacteristic.SCLPPLowDuration = 0
    I3C_InitStruct.CtrlBusCharacteristic.SCLI3CHighDuration = 0
    I3C_InitStruct.CtrlBusCharacteristic.SCLODLowDuration = 0
    I3C_InitStruct.CtrlBusCharacteristic.SCLI2CHighDuration = 0
    I3C_InitStruct.CtrlBusCharacteristic.BusFreeDuration = 0
    I3C_InitStruct.CtrlBusCharacteristic.BusIdleDuration = 0
    I3C_InitStruct.TgtBusCharacteristic.BusAvailableDuration = 0
}
