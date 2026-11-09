// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_RNG_CED_ENABLE: UInt32 = 0x0000_0000
public let LL_RNG_CED_DISABLE: UInt32 = 0x0000_0020
public let LL_RNG_ARDIS_ENABLE: UInt32 = 0x0000_0000
public let LL_RNG_ARDIS_DISABLE: UInt32 = 0x0000_0080
public let LL_RNG_CLKDIV_BY_1: UInt32 = 0x0000_0000
public let LL_RNG_CLKDIV_BY_2: UInt32 = 0x0001_0000
public let LL_RNG_CLKDIV_BY_4: UInt32 = 0x0002_0000
public let LL_RNG_CLKDIV_BY_8: UInt32 = 0x0003_0000
public let LL_RNG_CLKDIV_BY_16: UInt32 = 0x0004_0000
public let LL_RNG_CLKDIV_BY_32: UInt32 = 0x0005_0000
public let LL_RNG_CLKDIV_BY_64: UInt32 = 0x0006_0000
public let LL_RNG_CLKDIV_BY_128: UInt32 = 0x0007_0000
public let LL_RNG_CLKDIV_BY_256: UInt32 = 0x0008_0000
public let LL_RNG_CLKDIV_BY_512: UInt32 = 0x0009_0000
public let LL_RNG_CLKDIV_BY_1024: UInt32 = 0x000A_0000
public let LL_RNG_CLKDIV_BY_2048: UInt32 = 0x000B_0000
public let LL_RNG_CLKDIV_BY_4096: UInt32 = 0x000C_0000
public let LL_RNG_CLKDIV_BY_8192: UInt32 = 0x000D_0000
public let LL_RNG_CLKDIV_BY_16384: UInt32 = 0x000E_0000
public let LL_RNG_CLKDIV_BY_32768: UInt32 = 0x000F_0000
public let LL_RNG_NIST_COMPLIANT: UInt32 = 0x0000_0000
public let LL_RNG_CUSTOM_NIST: UInt32 = 0x0000_1000
public let LL_RNG_SR_DRDY: UInt32 = 0x0000_0001
public let LL_RNG_SR_CECS: UInt32 = 0x0000_0002
public let LL_RNG_SR_SECS: UInt32 = 0x0000_0004
public let LL_RNG_SR_CEIS: UInt32 = 0x0000_0020
public let LL_RNG_SR_SEIS: UInt32 = 0x0000_0040
public let LL_RNG_CR_IE: UInt32 = 0x0000_0008

public func LL_RNG_Enable<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) | (0x4))
}

public func LL_RNG_Disable<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4))
}

public func LL_RNG_IsEnabled<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.cr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_RNG_EnableClkErrorDetect<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0x20 | 0x4000_0000)) | (LL_RNG_CED_ENABLE | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_DisableClkErrorDetect<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0x20 | 0x4000_0000)) | (LL_RNG_CED_DISABLE | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_IsEnabledClkErrorDetect<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.cr) & (0x20)) != (0x20)) ? 1 : 0)
}

public func LL_RNG_EnableCondReset<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) | (0x4000_0000))
}

public func LL_RNG_DisableCondReset<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_IsEnabledCondReset<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.cr) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_RNG_ConfigLock<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) | (0x8000_0000))
}

public func LL_RNG_IsConfigLocked<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.cr) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_RNG_EnableNistCompliance<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0x1000 | 0x4000_0000)) | (LL_RNG_NIST_COMPLIANT | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_DisableNistCompliance<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0x1000 | 0x4000_0000)) | (LL_RNG_CUSTOM_NIST | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_IsEnabledNistCompliance<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.cr) & (0x1000)) != (0x1000)) ? 1 : 0)
}

public func LL_RNG_SetConfig1<IO: RNGRegisterIO>(_ registers: IO, _ Config1: UInt32) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0x3f00000 | 0x4000_0000)) | ((Config1 << 0x14) | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_GetConfig1<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RNGRegister.cr) & (0x3f00000)) >> 0x14)
}

public func LL_RNG_SetConfig2<IO: RNGRegisterIO>(_ registers: IO, _ Config2: UInt32) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0xe000 | 0x4000_0000)) | ((Config2 << 0xd) | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_GetConfig2<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RNGRegister.cr) & (0xe000)) >> 0xd)
}

public func LL_RNG_SetConfig3<IO: RNGRegisterIO>(_ registers: IO, _ Config3: UInt32) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0xf00 | 0x4000_0000)) | ((Config3 << 0x8) | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_GetConfig3<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(RNGRegister.cr) & (0xf00)) >> 0x8)
}

public func LL_RNG_SetClockDivider<IO: RNGRegisterIO>(_ registers: IO, _ Divider: UInt32) {
    registers.write(
        RNGRegister.cr, value: (registers.read(RNGRegister.cr) & ~(0xf0000 | 0x4000_0000)) | (Divider | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_GetClockDivider<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(RNGRegister.cr) & (0xf0000))
}

public func LL_RNG_IsActiveFlag_DRDY<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_RNG_IsActiveFlag_CECS<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.sr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_RNG_IsActiveFlag_SECS<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.sr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_RNG_IsActiveFlag_CEIS<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.sr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_RNG_IsActiveFlag_SEIS<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.sr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_RNG_ClearFlag_CEIS<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.sr, value: ~0x20)
}

public func LL_RNG_ClearFlag_SEIS<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.sr, value: ~0x40)
}

public func LL_RNG_EnableIT<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) | (0x8))
}

public func LL_RNG_DisableIT<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x8))
}

public func LL_RNG_IsEnabledIT<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.cr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_RNG_ReadRandData32<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(RNGRegister.dr))
}

public func LL_RNG_EnableArdis<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0x80 | 0x4000_0000)) | (LL_RNG_ARDIS_ENABLE | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_DisableArdis<IO: RNGRegisterIO>(_ registers: IO) {
    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0x80 | 0x4000_0000)) | (LL_RNG_ARDIS_DISABLE | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
}

public func LL_RNG_IsEnabledArdis<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(RNGRegister.cr) & (0x80)) != (0x80)) ? 1 : 0)
}

public func LL_RNG_SetHealthConfig<IO: RNGRegisterIO>(_ registers: IO, _ HTCFG: UInt32) {
    registers.write(RNGRegister.htcr, value: HTCFG)
}

public func LL_RNG_GetHealthConfig<IO: RNGRegisterIO>(_ registers: IO) -> UInt32 {
    return registers.read(RNGRegister.htcr)
}

public func LL_RNG_DeInit<IO: RNGRegisterIO & LLBusRegisterIO>(_ registers: inout IO, isKnownInstance: Bool = true)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.success.rawValue

    if isKnownInstance {
        LL_AHB3_GRP1_ForceReset(&registers, LL_AHB3_GRP1_PERIPH_RNG)

        LL_AHB3_GRP1_ReleaseReset(&registers, LL_AHB3_GRP1_PERIPH_RNG)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_RNG_Init<IO: RNGRegisterIO>(_ registers: IO, _ RNG_InitStruct: LL_RNG_InitTypeDef) -> LLErrorStatus {

    registers.write(
        RNGRegister.cr,
        value: (registers.read(RNGRegister.cr) & ~(0x20 | 0x4000_0000))
            | (RNG_InitStruct.ClockErrorDetection | 0x4000_0000))
    registers.write(RNGRegister.cr, value: registers.read(RNGRegister.cr) & ~(0x4000_0000))
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_RNG_StructInit(_ RNG_InitStruct: inout LL_RNG_InitTypeDef) {
    RNG_InitStruct.ClockErrorDetection = LL_RNG_CED_ENABLE
}
