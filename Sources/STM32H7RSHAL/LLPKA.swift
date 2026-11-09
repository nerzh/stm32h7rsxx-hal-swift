// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_PKA_SR_ADDRERRF: UInt32 = 0x0010_0000
public let LL_PKA_SR_RAMERRF: UInt32 = 0x0008_0000
public let LL_PKA_SR_PROCENDF: UInt32 = 0x0002_0000
public let LL_PKA_SR_BUSY: UInt32 = 0x0001_0000
public let LL_PKA_SR_INITOK: UInt32 = 0x0000_0001
public let LL_PKA_SR_OPERRF: UInt32 = 0x0020_0000
public let LL_PKA_CR_ADDRERRIE: UInt32 = 0x0010_0000
public let LL_PKA_CR_RAMERRIE: UInt32 = 0x0008_0000
public let LL_PKA_CR_PROCENDIE: UInt32 = 0x0002_0000
public let LL_PKA_CLRFR_PROCENDFC: UInt32 = 0x0002_0000
public let LL_PKA_CLRFR_RAMERRFC: UInt32 = 0x0008_0000
public let LL_PKA_CLRFR_ADDRERRFC: UInt32 = 0x0010_0000
public let LL_PKA_CR_OPERRIE: UInt32 = 0x0020_0000
public let LL_PKA_CLRFR_OPERRFC: UInt32 = 0x0020_0000
public let LL_PKA_MODE_MODULAR_EXP: UInt32 = 0x0000_0000
public let LL_PKA_MODE_MONTGOMERY_PARAM: UInt32 = 0x0000_0001
public let LL_PKA_MODE_MODULAR_EXP_FAST: UInt32 = 0x0000_0002
public let LL_PKA_MODE_MODULAR_EXP_PROTECT: UInt32 = 0x0000_0003
public let LL_PKA_MODE_ECC_MUL: UInt32 = 0x0000_0020
public let LL_PKA_MODE_ECC_COMPLETE_ADD: UInt32 = 0x0000_0023
public let LL_PKA_MODE_ECDSA_SIGNATURE: UInt32 = 0x0000_0024
public let LL_PKA_MODE_ECDSA_VERIFICATION: UInt32 = 0x0000_0026
public let LL_PKA_MODE_POINT_CHECK: UInt32 = 0x0000_0028
public let LL_PKA_MODE_RSA_CRT_EXP: UInt32 = 0x0000_0007
public let LL_PKA_MODE_MODULAR_INV: UInt32 = 0x0000_0008
public let LL_PKA_MODE_ARITHMETIC_ADD: UInt32 = 0x0000_0009
public let LL_PKA_MODE_ARITHMETIC_SUB: UInt32 = 0x0000_000A
public let LL_PKA_MODE_ARITHMETIC_MUL: UInt32 = 0x0000_000B
public let LL_PKA_MODE_COMPARISON: UInt32 = 0x0000_000C
public let LL_PKA_MODE_MODULAR_REDUC: UInt32 = 0x0000_000D
public let LL_PKA_MODE_MODULAR_ADD: UInt32 = 0x0000_000E
public let LL_PKA_MODE_MODULAR_SUB: UInt32 = 0x0000_000F
public let LL_PKA_MODE_MONTGOMERY_MUL: UInt32 = 0x0000_0010
public let LL_PKA_MODE_DOUBLE_BASE_LADDER: UInt32 = 0x0000_0027
public let LL_PKA_MODE_ECC_PROJECTIVE_AFF: UInt32 = 0x0000_002F

public func LL_PKA_Config<IO: PKARegisterIO>(_ registers: IO, _ Mode: UInt32) {
    registers.write(PKARegister.cr, value: (registers.read(PKARegister.cr) & ~((0x3f00))) | ((Mode << 0x8)))
}

public func LL_PKA_Enable<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) | (0x1))
}

public func LL_PKA_Disable<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) & ~(0x1))
}

public func LL_PKA_IsEnabled<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.cr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_PKA_SetMode<IO: PKARegisterIO>(_ registers: IO, _ Mode: UInt32) {
    registers.write(PKARegister.cr, value: (registers.read(PKARegister.cr) & ~(0x3f00)) | (Mode << 0x8))
}

public func LL_PKA_GetMode<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(PKARegister.cr) & (0x3f00)) >> 0x8)
}

public func LL_PKA_Start<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) | (0x2))
}

public func LL_PKA_EnableIT_ADDRERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) | (0x100000))
}

public func LL_PKA_EnableIT_RAMERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) | (0x80000))
}

public func LL_PKA_EnableIT_OPERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) | (0x200000))
}

public func LL_PKA_EnableIT_PROCEND<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) | (0x20000))
}

public func LL_PKA_DisableIT_ADDERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) & ~(0x100000))
}

public func LL_PKA_DisableIT_RAMERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) & ~(0x80000))
}

public func LL_PKA_DisableIT_PROCEND<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) & ~(0x20000))
}

public func LL_PKA_DisableIT_OPERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.cr, value: registers.read(PKARegister.cr) & ~(0x200000))
}

public func LL_PKA_IsEnabledIT_ADDRERR<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.cr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_PKA_IsEnabledIT_RAMERR<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.cr) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_PKA_IsEnabledIT_OPERR<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.cr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_PKA_IsEnabledIT_PROCEND<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.cr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_PKA_IsActiveFlag_ADDRERR<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.sr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_PKA_IsActiveFlag_RAMERR<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.sr) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_PKA_IsActiveFlag_OPERR<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.sr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_PKA_IsActiveFlag_PROCEND<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.sr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_PKA_IsActiveFlag_BUSY<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.sr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_PKA_IsActiveFlag_INITOK<IO: PKARegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(PKARegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_PKA_ClearFlag_ADDERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.clrfr, value: registers.read(PKARegister.clrfr) | (0x100000))
}

public func LL_PKA_ClearFlag_RAMERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.clrfr, value: registers.read(PKARegister.clrfr) | (0x80000))
}

public func LL_PKA_ClearFlag_OPERR<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.clrfr, value: registers.read(PKARegister.clrfr) | (0x200000))
}

public func LL_PKA_ClearFlag_PROCEND<IO: PKARegisterIO>(_ registers: IO) {
    registers.write(PKARegister.clrfr, value: registers.read(PKARegister.clrfr) | (0x20000))
}

public func LL_PKA_DeInit<IO: PKARegisterIO & LLBusRegisterIO>(_ registers: inout IO, isKnownInstance: Bool = true)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.success.rawValue

    if isKnownInstance {
        LL_AHB3_GRP1_ForceReset(&registers, LL_AHB3_GRP1_PERIPH_PKA)

        LL_AHB3_GRP1_ReleaseReset(&registers, LL_AHB3_GRP1_PERIPH_PKA)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_PKA_Init<IO: PKARegisterIO>(_ registers: IO, _ PKA_InitStruct: inout LL_PKA_InitTypeDef) -> LLErrorStatus
{

    LL_PKA_Config(registers, PKA_InitStruct.Mode)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_PKA_StructInit(_ PKA_InitStruct: inout LL_PKA_InitTypeDef) {
    PKA_InitStruct.Mode = LL_PKA_MODE_MODULAR_EXP
}
