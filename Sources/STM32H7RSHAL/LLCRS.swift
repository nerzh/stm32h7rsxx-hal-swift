// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_CRS_ISR_SYNCOKF: UInt32 = 0x0000_0001
public let LL_CRS_ISR_SYNCWARNF: UInt32 = 0x0000_0002
public let LL_CRS_ISR_ERRF: UInt32 = 0x0000_0004
public let LL_CRS_ISR_ESYNCF: UInt32 = 0x0000_0008
public let LL_CRS_ISR_SYNCERR: UInt32 = 0x0000_0100
public let LL_CRS_ISR_SYNCMISS: UInt32 = 0x0000_0200
public let LL_CRS_ISR_TRIMOVF: UInt32 = 0x0000_0400
public let LL_CRS_CR_SYNCOKIE: UInt32 = 0x0000_0001
public let LL_CRS_CR_SYNCWARNIE: UInt32 = 0x0000_0002
public let LL_CRS_CR_ERRIE: UInt32 = 0x0000_0004
public let LL_CRS_CR_ESYNCIE: UInt32 = 0x0000_0008
public let LL_CRS_SYNC_DIV_1: UInt32 = 0x0000_0000
public let LL_CRS_SYNC_DIV_2: UInt32 = 0x0100_0000
public let LL_CRS_SYNC_DIV_4: UInt32 = 0x0200_0000
public let LL_CRS_SYNC_DIV_8: UInt32 = 0x0300_0000
public let LL_CRS_SYNC_DIV_16: UInt32 = 0x0400_0000
public let LL_CRS_SYNC_DIV_32: UInt32 = 0x0500_0000
public let LL_CRS_SYNC_DIV_64: UInt32 = 0x0600_0000
public let LL_CRS_SYNC_DIV_128: UInt32 = 0x0700_0000
public let LL_CRS_SYNC_SOURCE_GPIO: UInt32 = 0x0000_0000
public let LL_CRS_SYNC_SOURCE_LSE: UInt32 = 0x1000_0000
public let LL_CRS_SYNC_SOURCE_OTG_FS: UInt32 = 0x2000_0000
public let LL_CRS_SYNC_SOURCE_OTG_HS: UInt32 = 0x3000_0000
public let LL_CRS_SYNC_POLARITY_RISING: UInt32 = 0x0000_0000
public let LL_CRS_SYNC_POLARITY_FALLING: UInt32 = 0x8000_0000
public let LL_CRS_FREQ_ERROR_DIR_UP: UInt32 = 0x0000_0000
public let LL_CRS_FREQ_ERROR_DIR_DOWN: UInt32 = 0x0000_8000
public let LL_CRS_RELOADVALUE_DEFAULT: UInt32 = 0x0000_BB7F
public let LL_CRS_ERRORLIMIT_DEFAULT: UInt32 = 0x0000_0022
public let LL_CRS_HSI48CALIBRATION_DEFAULT: UInt32 = 0x0000_0020

public func LL_CRS_EnableFreqErrorCounter<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) | (0x20))
}

public func LL_CRS_DisableFreqErrorCounter<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) & ~(0x20))
}

public func LL_CRS_IsEnabledFreqErrorCounter<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.cr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_CRS_EnableAutoTrimming<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) | (0x40))
}

public func LL_CRS_DisableAutoTrimming<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) & ~(0x40))
}

public func LL_CRS_IsEnabledAutoTrimming<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.cr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_CRS_SetHSI48SmoothTrimming<IO: CRSRegisterIO>(_ registers: inout IO, _ Value: UInt32) {
    registers.write(CRSRegister.cr, value: (registers.read(CRSRegister.cr) & ~(0x3F00)) | (Value << 0x8))
}

public func LL_CRS_GetHSI48SmoothTrimming<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRSRegister.cr) & (0x3F00)) >> 0x8)
}

public func LL_CRS_SetReloadCounter<IO: CRSRegisterIO>(_ registers: inout IO, _ Value: UInt32) {
    registers.write(CRSRegister.cfgr, value: (registers.read(CRSRegister.cfgr) & ~(0xFFFF)) | (Value))
}

public func LL_CRS_GetReloadCounter<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRSRegister.cfgr) & (0xFFFF)))
}

public func LL_CRS_SetFreqErrorLimit<IO: CRSRegisterIO>(_ registers: inout IO, _ Value: UInt32) {
    registers.write(CRSRegister.cfgr, value: (registers.read(CRSRegister.cfgr) & ~(0xFF0000)) | (Value << 0x10))
}

public func LL_CRS_GetFreqErrorLimit<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRSRegister.cfgr) & (0xFF0000)) >> 0x10)
}

public func LL_CRS_SetSyncDivider<IO: CRSRegisterIO>(_ registers: inout IO, _ Divider: UInt32) {
    registers.write(CRSRegister.cfgr, value: (registers.read(CRSRegister.cfgr) & ~(0x7000000)) | (Divider))
}

public func LL_CRS_GetSyncDivider<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRSRegister.cfgr) & (0x7000000)))
}

public func LL_CRS_SetSyncSignalSource<IO: CRSRegisterIO>(_ registers: inout IO, _ Source: UInt32) {
    registers.write(CRSRegister.cfgr, value: (registers.read(CRSRegister.cfgr) & ~(0x3000_0000)) | (Source))
}

public func LL_CRS_GetSyncSignalSource<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRSRegister.cfgr) & (0x3000_0000)))
}

public func LL_CRS_SetSyncPolarity<IO: CRSRegisterIO>(_ registers: inout IO, _ Polarity: UInt32) {
    registers.write(CRSRegister.cfgr, value: (registers.read(CRSRegister.cfgr) & ~(0x8000_0000)) | (Polarity))
}

public func LL_CRS_GetSyncPolarity<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRSRegister.cfgr) & (0x8000_0000)))
}

public func LL_CRS_ConfigSynchronization<IO: CRSRegisterIO>(
    _ registers: inout IO, _ HSI48CalibrationValue: UInt32, _ ErrorLimitValue: UInt32, _ ReloadValue: UInt32,
    _ Settings: UInt32
) {
    registers.write(
        CRSRegister.cr, value: (registers.read(CRSRegister.cr) & ~(0x3F00)) | (HSI48CalibrationValue << 0x8))
    registers.write(
        CRSRegister.cfgr,
        value: (registers.read(CRSRegister.cfgr) & ~(0xFFFF | 0xFF0000 | 0x7000000 | 0x3000_0000 | 0x8000_0000))
            | (ReloadValue | (ErrorLimitValue << 0x10) | Settings))
}

public func LL_CRS_GenerateEvent_SWSYNC<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) | (0x80))
}

public func LL_CRS_GetFreqErrorDirection<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRSRegister.isr) & (0x8000)))
}

public func LL_CRS_GetFreqErrorCapture<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRSRegister.isr) & (0xFFFF_0000)) >> 0x10)
}

public func LL_CRS_IsActiveFlag_SYNCOK<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.isr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_CRS_IsActiveFlag_SYNCWARN<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.isr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_CRS_IsActiveFlag_ERR<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.isr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_CRS_IsActiveFlag_ESYNC<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.isr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_CRS_IsActiveFlag_SYNCERR<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.isr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_CRS_IsActiveFlag_SYNCMISS<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.isr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_CRS_IsActiveFlag_TRIMOVF<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.isr) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_CRS_ClearFlag_SYNCOK<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.icr, value: 0x1)
}

public func LL_CRS_ClearFlag_SYNCWARN<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.icr, value: 0x2)
}

public func LL_CRS_ClearFlag_ERR<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.icr, value: 0x4)
}

public func LL_CRS_ClearFlag_ESYNC<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.icr, value: 0x8)
}

public func LL_CRS_EnableIT_SYNCOK<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) | (0x1))
}

public func LL_CRS_DisableIT_SYNCOK<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) & ~(0x1))
}

public func LL_CRS_IsEnabledIT_SYNCOK<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.cr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_CRS_EnableIT_SYNCWARN<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) | (0x2))
}

public func LL_CRS_DisableIT_SYNCWARN<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) & ~(0x2))
}

public func LL_CRS_IsEnabledIT_SYNCWARN<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.cr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_CRS_EnableIT_ERR<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) | (0x4))
}

public func LL_CRS_DisableIT_ERR<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) & ~(0x4))
}

public func LL_CRS_IsEnabledIT_ERR<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.cr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_CRS_EnableIT_ESYNC<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) | (0x8))
}

public func LL_CRS_DisableIT_ESYNC<IO: CRSRegisterIO>(_ registers: inout IO) {
    registers.write(CRSRegister.cr, value: registers.read(CRSRegister.cr) & ~(0x8))
}

public func LL_CRS_IsEnabledIT_ESYNC<IO: CRSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CRSRegister.cr) & (0x8)) == (0x8)) ? 1 : 0)
}

@discardableResult
public func LL_CRS_DeInit<IO: LLBusRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    LL_APB1_GRP2_ForceReset(&registers, LL_APB1_GRP2_PERIPH_CRS)
    LL_APB1_GRP2_ReleaseReset(&registers, LL_APB1_GRP2_PERIPH_CRS)
    return .success
}

public func LL_CRS_WriteReg<IO: CRSRegisterIO>(_ registers: inout IO, _ register: CRSRegister, _ value: UInt32) {
    registers.write(register, value: value)
}

public func LL_CRS_ReadReg<IO: CRSRegisterIO>(_ registers: inout IO, _ register: CRSRegister) -> UInt32 {
    registers.read(register)
}

public func __LL_CRS_CALC_CALCULATE_RELOADVALUE(_ target: UInt32, _ sync: UInt32) -> UInt32 {
    precondition(sync != 0)
    return (target / sync) &- 1
}
