// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_I2C_ICR_ADDRCF: UInt32 = 0x0000_0008
public let LL_I2C_ICR_NACKCF: UInt32 = 0x0000_0010
public let LL_I2C_ICR_STOPCF: UInt32 = 0x0000_0020
public let LL_I2C_ICR_BERRCF: UInt32 = 0x0000_0100
public let LL_I2C_ICR_ARLOCF: UInt32 = 0x0000_0200
public let LL_I2C_ICR_OVRCF: UInt32 = 0x0000_0400
public let LL_I2C_ICR_PECCF: UInt32 = 0x0000_0800
public let LL_I2C_ICR_TIMOUTCF: UInt32 = 0x0000_1000
public let LL_I2C_ICR_ALERTCF: UInt32 = 0x0000_2000
public let LL_I2C_ISR_TXE: UInt32 = 0x0000_0001
public let LL_I2C_ISR_TXIS: UInt32 = 0x0000_0002
public let LL_I2C_ISR_RXNE: UInt32 = 0x0000_0004
public let LL_I2C_ISR_ADDR: UInt32 = 0x0000_0008
public let LL_I2C_ISR_NACKF: UInt32 = 0x0000_0010
public let LL_I2C_ISR_STOPF: UInt32 = 0x0000_0020
public let LL_I2C_ISR_TC: UInt32 = 0x0000_0040
public let LL_I2C_ISR_TCR: UInt32 = 0x0000_0080
public let LL_I2C_ISR_BERR: UInt32 = 0x0000_0100
public let LL_I2C_ISR_ARLO: UInt32 = 0x0000_0200
public let LL_I2C_ISR_OVR: UInt32 = 0x0000_0400
public let LL_I2C_ISR_PECERR: UInt32 = 0x0000_0800
public let LL_I2C_ISR_TIMEOUT: UInt32 = 0x0000_1000
public let LL_I2C_ISR_ALERT: UInt32 = 0x0000_2000
public let LL_I2C_ISR_BUSY: UInt32 = 0x0000_8000
public let LL_I2C_CR1_TXIE: UInt32 = 0x0000_0002
public let LL_I2C_CR1_RXIE: UInt32 = 0x0000_0004
public let LL_I2C_CR1_ADDRIE: UInt32 = 0x0000_0008
public let LL_I2C_CR1_NACKIE: UInt32 = 0x0000_0010
public let LL_I2C_CR1_STOPIE: UInt32 = 0x0000_0020
public let LL_I2C_CR1_TCIE: UInt32 = 0x0000_0040
public let LL_I2C_CR1_ERRIE: UInt32 = 0x0000_0080
public let LL_I2C_MODE_I2C: UInt32 = 0x0000_0000
public let LL_I2C_MODE_SMBUS_HOST: UInt32 = 0x0010_0000
public let LL_I2C_MODE_SMBUS_DEVICE: UInt32 = 0x0000_0000
public let LL_I2C_MODE_SMBUS_DEVICE_ARP: UInt32 = 0x0020_0000
public let LL_I2C_ANALOGFILTER_ENABLE: UInt32 = 0x0000_0000
public let LL_I2C_ANALOGFILTER_DISABLE: UInt32 = 0x0000_1000
public let LL_I2C_ADDRESSING_MODE_7BIT: UInt32 = 0x0000_0000
public let LL_I2C_ADDRESSING_MODE_10BIT: UInt32 = 0x0000_0800
public let LL_I2C_OWNADDRESS1_7BIT: UInt32 = 0x0000_0000
public let LL_I2C_OWNADDRESS1_10BIT: UInt32 = 0x0000_0400
public let LL_I2C_OWNADDRESS2_NOMASK: UInt32 = 0x0000_0000
public let LL_I2C_OWNADDRESS2_MASK01: UInt32 = 0x0000_0100
public let LL_I2C_OWNADDRESS2_MASK02: UInt32 = 0x0000_0200
public let LL_I2C_OWNADDRESS2_MASK03: UInt32 = 0x0000_0300
public let LL_I2C_OWNADDRESS2_MASK04: UInt32 = 0x0000_0400
public let LL_I2C_OWNADDRESS2_MASK05: UInt32 = 0x0000_0500
public let LL_I2C_OWNADDRESS2_MASK06: UInt32 = 0x0000_0600
public let LL_I2C_OWNADDRESS2_MASK07: UInt32 = 0x0000_0700
public let LL_I2C_ACK: UInt32 = 0x0000_0000
public let LL_I2C_NACK: UInt32 = 0x0000_8000
public let LL_I2C_ADDRSLAVE_7BIT: UInt32 = 0x0000_0000
public let LL_I2C_ADDRSLAVE_10BIT: UInt32 = 0x0000_0800
public let LL_I2C_REQUEST_WRITE: UInt32 = 0x0000_0000
public let LL_I2C_REQUEST_READ: UInt32 = 0x0000_0400
public let LL_I2C_MODE_RELOAD: UInt32 = 0x0100_0000
public let LL_I2C_MODE_AUTOEND: UInt32 = 0x0200_0000
public let LL_I2C_MODE_SOFTEND: UInt32 = 0x0000_0000
public let LL_I2C_MODE_SMBUS_RELOAD: UInt32 = 0x0100_0000
public let LL_I2C_MODE_SMBUS_AUTOEND_NO_PEC: UInt32 = 0x0200_0000
public let LL_I2C_MODE_SMBUS_SOFTEND_NO_PEC: UInt32 = 0x0000_0000
public let LL_I2C_MODE_SMBUS_AUTOEND_WITH_PEC: UInt32 = 0x0600_0000
public let LL_I2C_MODE_SMBUS_SOFTEND_WITH_PEC: UInt32 = 0x0400_0000
public let LL_I2C_GENERATE_NOSTARTSTOP: UInt32 = 0x0000_0000
public let LL_I2C_GENERATE_STOP: UInt32 = 0x8000_4000
public let LL_I2C_GENERATE_START_READ: UInt32 = 0x8000_2400
public let LL_I2C_GENERATE_START_WRITE: UInt32 = 0x8000_2000
public let LL_I2C_GENERATE_RESTART_7BIT_READ: UInt32 = 0x8000_2400
public let LL_I2C_GENERATE_RESTART_7BIT_WRITE: UInt32 = 0x8000_2000
public let LL_I2C_GENERATE_RESTART_10BIT_READ: UInt32 = 0x8000_3400
public let LL_I2C_GENERATE_RESTART_10BIT_WRITE: UInt32 = 0x8000_2000
public let LL_I2C_DIRECTION_WRITE: UInt32 = 0x0000_0000
public let LL_I2C_DIRECTION_READ: UInt32 = 0x0001_0000
public let LL_I2C_DMA_REG_DATA_TRANSMIT: UInt32 = 0x0000_0000
public let LL_I2C_DMA_REG_DATA_RECEIVE: UInt32 = 0x0000_0001
public let LL_I2C_SMBUS_TIMEOUTA_MODE_SCL_LOW: UInt32 = 0x0000_0000
public let LL_I2C_SMBUS_TIMEOUTA_MODE_SDA_SCL_HIGH: UInt32 = 0x0000_1000
public let LL_I2C_SMBUS_TIMEOUTA: UInt32 = 0x0000_8000
public let LL_I2C_SMBUS_TIMEOUTB: UInt32 = 0x8000_0000
public let LL_I2C_SMBUS_ALL_TIMEOUT: UInt32 = 0x8000_8000

public func LL_I2C_Enable<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x1))
}

public func LL_I2C_Disable<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x1))
}

public func LL_I2C_IsEnabled<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_I2C_ConfigFilters<IO: I2CRegisterIO>(_ registers: IO, _ AnalogFilter: UInt32, _ DigitalFilter: UInt32) {
    registers.write(
        I2CRegister.cr1,
        value: (registers.read(I2CRegister.cr1) & ~(0x1000 | 0xf00)) | (AnalogFilter | (DigitalFilter << 0x8)))
}

public func LL_I2C_SetDigitalFilter<IO: I2CRegisterIO>(_ registers: IO, _ DigitalFilter: UInt32) {
    registers.write(I2CRegister.cr1, value: (registers.read(I2CRegister.cr1) & ~(0xf00)) | (DigitalFilter << 0x8))
}

public func LL_I2C_GetDigitalFilter<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.cr1) & (0xf00)) >> 0x8)
}

public func LL_I2C_EnableAnalogFilter<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x1000))
}

public func LL_I2C_DisableAnalogFilter<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x1000))
}

public func LL_I2C_IsEnabledAnalogFilter<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x1000)) != (0x1000)) ? 1 : 0)
}

public func LL_I2C_EnableDMAReq_TX<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x4000))
}

public func LL_I2C_DisableDMAReq_TX<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x4000))
}

public func LL_I2C_IsEnabledDMAReq_TX<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_I2C_EnableDMAReq_RX<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x8000))
}

public func LL_I2C_DisableDMAReq_RX<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x8000))
}

public func LL_I2C_IsEnabledDMAReq_RX<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_I2C_DMA_GetRegAddr<IO: I2CRegisterIO>(_ registers: IO, _ Direction: UInt32) -> UInt32 {
    return registers.address(of: Direction == LL_I2C_DMA_REG_DATA_TRANSMIT ? .txdr : .rxdr)
}

public func LL_I2C_EnableClockStretching<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x20000))
}

public func LL_I2C_DisableClockStretching<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x20000))
}

public func LL_I2C_IsEnabledClockStretching<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x20000)) != (0x20000)) ? 1 : 0)
}

public func LL_I2C_EnableSlaveByteControl<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x10000))
}

public func LL_I2C_DisableSlaveByteControl<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x10000))
}

public func LL_I2C_IsEnabledSlaveByteControl<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_I2C_EnableWakeUpFromStop<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x40000))
}

public func LL_I2C_DisableWakeUpFromStop<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x40000))
}

public func LL_I2C_IsEnabledWakeUpFromStop<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_I2C_EnableGeneralCall<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x80000))
}

public func LL_I2C_DisableGeneralCall<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x80000))
}

public func LL_I2C_IsEnabledGeneralCall<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_I2C_EnableFastModePlus<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x1000000))
}

public func LL_I2C_DisableFastModePlus<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x1000000))
}

public func LL_I2C_IsEnabledFastModePlus<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_I2C_EnableAutoClearFlag_ADDR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x4000_0000))
}

public func LL_I2C_DisableAutoClearFlag_ADDR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x4000_0000))
}

public func LL_I2C_IsEnabledAutoClearFlag_ADDR<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_I2C_EnableAutoClearFlag_STOP<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x8000_0000))
}

public func LL_I2C_DisableAutoClearFlag_STOP<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x8000_0000))
}

public func LL_I2C_IsEnabledAutoClearFlag_STOP<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_I2C_SetMasterAddressingMode<IO: I2CRegisterIO>(_ registers: IO, _ AddressingMode: UInt32) {
    registers.write(I2CRegister.cr2, value: (registers.read(I2CRegister.cr2) & ~(0x800)) | (AddressingMode))
}

public func LL_I2C_GetMasterAddressingMode<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.cr2) & (0x800)))
}

public func LL_I2C_SetOwnAddress1<IO: I2CRegisterIO>(_ registers: IO, _ OwnAddress1: UInt32, _ OwnAddrSize: UInt32) {
    registers.write(
        I2CRegister.oar1, value: (registers.read(I2CRegister.oar1) & ~(0x3ff | 0x400)) | (OwnAddress1 | OwnAddrSize))
}

public func LL_I2C_EnableOwnAddress1<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.oar1, value: registers.read(I2CRegister.oar1) | (0x8000))
}

public func LL_I2C_DisableOwnAddress1<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.oar1, value: registers.read(I2CRegister.oar1) & ~(0x8000))
}

public func LL_I2C_IsEnabledOwnAddress1<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.oar1) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_I2C_SetOwnAddress2<IO: I2CRegisterIO>(_ registers: IO, _ OwnAddress2: UInt32, _ OwnAddrMask: UInt32) {
    registers.write(
        I2CRegister.oar2, value: (registers.read(I2CRegister.oar2) & ~(0xfe | 0x700)) | (OwnAddress2 | OwnAddrMask))
}

public func LL_I2C_EnableOwnAddress2<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.oar2, value: registers.read(I2CRegister.oar2) | (0x8000))
}

public func LL_I2C_DisableOwnAddress2<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.oar2, value: registers.read(I2CRegister.oar2) & ~(0x8000))
}

public func LL_I2C_IsEnabledOwnAddress2<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.oar2) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_I2C_SetTiming<IO: I2CRegisterIO>(_ registers: IO, _ Timing: UInt32) {
    registers.write(I2CRegister.timingr, value: Timing)
}

public func LL_I2C_GetTimingPrescaler<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.timingr) & (0xf000_0000)) >> 0x1c)
}

public func LL_I2C_GetClockLowPeriod<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.timingr) & (0xff)) >> 0x0)
}

public func LL_I2C_GetClockHighPeriod<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.timingr) & (0xff00)) >> 0x8)
}

public func LL_I2C_GetDataHoldTime<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.timingr) & (0xf0000)) >> 0x10)
}

public func LL_I2C_GetDataSetupTime<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.timingr) & (0xf00000)) >> 0x14)
}

public func LL_I2C_SetMode<IO: I2CRegisterIO>(_ registers: IO, _ PeripheralMode: UInt32) {
    registers.write(
        I2CRegister.cr1, value: (registers.read(I2CRegister.cr1) & ~(0x100000 | 0x200000)) | (PeripheralMode))
}

public func LL_I2C_GetMode<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.cr1) & (0x100000 | 0x200000)))
}

public func LL_I2C_EnableSMBusAlert<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x400000))
}

public func LL_I2C_DisableSMBusAlert<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x400000))
}

public func LL_I2C_IsEnabledSMBusAlert<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_I2C_EnableSMBusPEC<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x800000))
}

public func LL_I2C_DisableSMBusPEC<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x800000))
}

public func LL_I2C_IsEnabledSMBusPEC<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_I2C_ConfigSMBusTimeout<IO: I2CRegisterIO>(
    _ registers: IO, _ TimeoutA: UInt32, _ TimeoutAMode: UInt32, _ TimeoutB: UInt32
) {
    registers.write(
        I2CRegister.timeoutr,
        value: (registers.read(I2CRegister.timeoutr) & ~(0xfff | 0x1000 | 0xfff0000))
            | (TimeoutA | TimeoutAMode | (TimeoutB << 0x10)))
}

public func LL_I2C_SetSMBusTimeoutA<IO: I2CRegisterIO>(_ registers: IO, _ TimeoutA: UInt32) {
    registers.write(I2CRegister.timeoutr, value: TimeoutA)
}

public func LL_I2C_GetSMBusTimeoutA<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.timeoutr) & (0xfff)))
}

public func LL_I2C_SetSMBusTimeoutAMode<IO: I2CRegisterIO>(_ registers: IO, _ TimeoutAMode: UInt32) {
    registers.write(I2CRegister.timeoutr, value: TimeoutAMode)
}

public func LL_I2C_GetSMBusTimeoutAMode<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.timeoutr) & (0x1000)))
}

public func LL_I2C_SetSMBusTimeoutB<IO: I2CRegisterIO>(_ registers: IO, _ TimeoutB: UInt32) {
    registers.write(I2CRegister.timeoutr, value: TimeoutB << 0x10)
}

public func LL_I2C_GetSMBusTimeoutB<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.timeoutr) & (0xfff0000)) >> 0x10)
}

public func LL_I2C_EnableSMBusTimeout<IO: I2CRegisterIO>(_ registers: IO, _ ClockTimeout: UInt32) {
    registers.write(I2CRegister.timeoutr, value: registers.read(I2CRegister.timeoutr) | (ClockTimeout))
}

public func LL_I2C_DisableSMBusTimeout<IO: I2CRegisterIO>(_ registers: IO, _ ClockTimeout: UInt32) {
    registers.write(I2CRegister.timeoutr, value: registers.read(I2CRegister.timeoutr) & ~(ClockTimeout))
}

public func LL_I2C_IsEnabledSMBusTimeout<IO: I2CRegisterIO>(_ registers: IO, _ ClockTimeout: UInt32) -> UInt32 {
    return (((registers.read(I2CRegister.timeoutr) & ((0x8000 | 0x8000_0000))) == (ClockTimeout)) ? 1 : 0)
}

public func LL_I2C_EnableIT_TX<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x2))
}

public func LL_I2C_DisableIT_TX<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x2))
}

public func LL_I2C_IsEnabledIT_TX<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_I2C_EnableIT_RX<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x4))
}

public func LL_I2C_DisableIT_RX<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x4))
}

public func LL_I2C_IsEnabledIT_RX<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_I2C_EnableIT_ADDR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x8))
}

public func LL_I2C_DisableIT_ADDR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x8))
}

public func LL_I2C_IsEnabledIT_ADDR<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_I2C_EnableIT_NACK<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x10))
}

public func LL_I2C_DisableIT_NACK<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x10))
}

public func LL_I2C_IsEnabledIT_NACK<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_I2C_EnableIT_STOP<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x20))
}

public func LL_I2C_DisableIT_STOP<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x20))
}

public func LL_I2C_IsEnabledIT_STOP<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_I2C_EnableIT_TC<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x40))
}

public func LL_I2C_DisableIT_TC<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x40))
}

public func LL_I2C_IsEnabledIT_TC<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_I2C_EnableIT_ERR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) | (0x80))
}

public func LL_I2C_DisableIT_ERR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr1, value: registers.read(I2CRegister.cr1) & ~(0x80))
}

public func LL_I2C_IsEnabledIT_ERR<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr1) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_TXE<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_TXIS<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_RXNE<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_ADDR<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_NACK<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_STOP<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_TC<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_TCR<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_BERR<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_ARLO<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_OVR<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_I2C_IsActiveSMBusFlag_PECERR<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_I2C_IsActiveSMBusFlag_TIMEOUT<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_I2C_IsActiveSMBusFlag_ALERT<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_I2C_IsActiveFlag_BUSY<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_I2C_ClearFlag_ADDR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x8))
}

public func LL_I2C_ClearFlag_NACK<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x10))
}

public func LL_I2C_ClearFlag_STOP<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x20))
}

public func LL_I2C_ClearFlag_TXE<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.isr, value: 0x1)
}

public func LL_I2C_ClearFlag_BERR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x100))
}

public func LL_I2C_ClearFlag_ARLO<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x200))
}

public func LL_I2C_ClearFlag_OVR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x400))
}

public func LL_I2C_ClearSMBusFlag_PECERR<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x800))
}

public func LL_I2C_ClearSMBusFlag_TIMEOUT<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x1000))
}

public func LL_I2C_ClearSMBusFlag_ALERT<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.icr, value: registers.read(I2CRegister.icr) | (0x2000))
}

public func LL_I2C_EnableAutoEndMode<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) | (0x2000000))
}

public func LL_I2C_DisableAutoEndMode<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) & ~(0x2000000))
}

public func LL_I2C_IsEnabledAutoEndMode<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr2) & (0x2000000)) == (0x2000000)) ? 1 : 0)
}

public func LL_I2C_EnableReloadMode<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) | (0x1000000))
}

public func LL_I2C_DisableReloadMode<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) & ~(0x1000000))
}

public func LL_I2C_IsEnabledReloadMode<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr2) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_I2C_SetTransferSize<IO: I2CRegisterIO>(_ registers: IO, _ TransferSize: UInt32) {
    registers.write(I2CRegister.cr2, value: (registers.read(I2CRegister.cr2) & ~(0xff0000)) | (TransferSize << 0x10))
}

public func LL_I2C_GetTransferSize<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.cr2) & (0xff0000)) >> 0x10)
}

public func LL_I2C_AcknowledgeNextData<IO: I2CRegisterIO>(_ registers: IO, _ TypeAcknowledge: UInt32) {
    registers.write(I2CRegister.cr2, value: (registers.read(I2CRegister.cr2) & ~(0x8000)) | (TypeAcknowledge))
}

public func LL_I2C_GenerateStartCondition<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) | (0x2000))
}

public func LL_I2C_GenerateStopCondition<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) | (0x4000))
}

public func LL_I2C_EnableAuto10BitRead<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) & ~(0x1000))
}

public func LL_I2C_DisableAuto10BitRead<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) | (0x1000))
}

public func LL_I2C_IsEnabledAuto10BitRead<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr2) & (0x1000)) != (0x1000)) ? 1 : 0)
}

public func LL_I2C_SetTransferRequest<IO: I2CRegisterIO>(_ registers: IO, _ TransferRequest: UInt32) {
    registers.write(I2CRegister.cr2, value: (registers.read(I2CRegister.cr2) & ~(0x400)) | (TransferRequest))
}

public func LL_I2C_GetTransferRequest<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.cr2) & (0x400)))
}

public func LL_I2C_SetSlaveAddr<IO: I2CRegisterIO>(_ registers: IO, _ SlaveAddr: UInt32) {
    registers.write(I2CRegister.cr2, value: (registers.read(I2CRegister.cr2) & ~(0x3ff)) | (SlaveAddr))
}

public func LL_I2C_GetSlaveAddr<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.cr2) & (0x3ff)))
}

public func LL_I2C_HandleTransfer<IO: I2CRegisterIO>(
    _ registers: IO, _ SlaveAddr: UInt32, _ SlaveAddrSize: UInt32, _ TransferSize: UInt32, _ EndMode: UInt32,
    _ Request: UInt32
) {
    var tmp: UInt32 =
        (((SlaveAddr & 0x3ff) | (SlaveAddrSize & 0x800) | ((TransferSize << 0x10) & 0xff0000) | EndMode | Request)
            & (~0x8000_0000))

    registers.write(
        I2CRegister.cr2,
        value: (registers.read(I2CRegister.cr2)
            & ~(0x3ff | 0x800 | (0x400 & (Request >> (31 &- 0xa))) | 0x2000 | 0x4000 | 0x1000000 | 0xff0000 | 0x2000000
            | 0x1000)) | (tmp))
}

public func LL_I2C_GetTransferDirection<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.isr) & (0x10000)))
}

public func LL_I2C_GetAddressMatchCode<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.isr) & (0xfe0000)) >> 0x11) << 1)
}

public func LL_I2C_EnableSMBusPECCompare<IO: I2CRegisterIO>(_ registers: IO) {
    registers.write(I2CRegister.cr2, value: registers.read(I2CRegister.cr2) | (0x4000000))
}

public func LL_I2C_IsEnabledSMBusPECCompare<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(I2CRegister.cr2) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_I2C_GetSMBusPEC<IO: I2CRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(I2CRegister.pecr) & (0xff)))
}

public func LL_I2C_ReceiveData8<IO: I2CRegisterIO>(_ registers: IO) -> UInt8 {
    return UInt8(truncatingIfNeeded: ((registers.read(I2CRegister.rxdr) & (0xff))))
}

public func LL_I2C_TransmitData8<IO: I2CRegisterIO>(_ registers: IO, _ Data: UInt8) {
    registers.write(I2CRegister.txdr, value: UInt32(Data))
}

public func LL_I2C_DeInit<IO: I2CRegisterIO & LLBusRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue

    if registers.address(of: I2CRegister.cr1) == 0x4000_5400 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_I2C1)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_I2C1)
    } else if registers.address(of: I2CRegister.cr1) == 0x4000_5800 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_I2C2)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_I2C2)
    } else if registers.address(of: I2CRegister.cr1) == 0x4000_5c00 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_I2C3)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_I2C3)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_I2C_Init<IO: I2CRegisterIO>(_ registers: IO, _ I2C_InitStruct: LL_I2C_InitTypeDef) -> LLErrorStatus {

    LL_I2C_Disable(registers)

    LL_I2C_ConfigFilters(registers, I2C_InitStruct.AnalogFilter, I2C_InitStruct.DigitalFilter)

    LL_I2C_SetTiming(registers, I2C_InitStruct.Timing)

    LL_I2C_Enable(registers)

    LL_I2C_DisableOwnAddress1(registers)
    LL_I2C_SetOwnAddress1(registers, I2C_InitStruct.OwnAddress1, I2C_InitStruct.OwnAddrSize)

    if I2C_InitStruct.OwnAddress1 != 0 {
        LL_I2C_EnableOwnAddress1(registers)
    }

    LL_I2C_SetMode(registers, I2C_InitStruct.PeripheralMode)

    LL_I2C_AcknowledgeNextData(registers, I2C_InitStruct.TypeAcknowledge)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_I2C_StructInit(_ I2C_InitStruct: inout LL_I2C_InitTypeDef) {
    I2C_InitStruct.PeripheralMode = LL_I2C_MODE_I2C
    I2C_InitStruct.Timing = 0
    I2C_InitStruct.AnalogFilter = LL_I2C_ANALOGFILTER_ENABLE
    I2C_InitStruct.DigitalFilter = 0
    I2C_InitStruct.OwnAddress1 = 0
    I2C_InitStruct.TypeAcknowledge = LL_I2C_NACK
    I2C_InitStruct.OwnAddrSize = LL_I2C_OWNADDRESS1_7BIT
}
