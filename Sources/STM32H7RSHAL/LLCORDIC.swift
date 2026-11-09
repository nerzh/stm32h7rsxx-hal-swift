// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_CORDIC_FLAG_RRDY: UInt32 = 0x8000_0000
public let LL_CORDIC_IT_IEN: UInt32 = 0x0001_0000
public let LL_CORDIC_FUNCTION_COSINE: UInt32 = 0x0000_0000
public let LL_CORDIC_FUNCTION_SINE: UInt32 = 0x0000_0001
public let LL_CORDIC_FUNCTION_PHASE: UInt32 = 0x0000_0002
public let LL_CORDIC_FUNCTION_MODULUS: UInt32 = 0x0000_0003
public let LL_CORDIC_FUNCTION_ARCTANGENT: UInt32 = 0x0000_0004
public let LL_CORDIC_FUNCTION_HCOSINE: UInt32 = 0x0000_0005
public let LL_CORDIC_FUNCTION_HSINE: UInt32 = 0x0000_0006
public let LL_CORDIC_FUNCTION_HARCTANGENT: UInt32 = 0x0000_0007
public let LL_CORDIC_FUNCTION_NATURALLOG: UInt32 = 0x0000_0008
public let LL_CORDIC_FUNCTION_SQUAREROOT: UInt32 = 0x0000_0009
public let LL_CORDIC_PRECISION_1CYCLE: UInt32 = 0x0000_0010
public let LL_CORDIC_PRECISION_2CYCLES: UInt32 = 0x0000_0020
public let LL_CORDIC_PRECISION_3CYCLES: UInt32 = 0x0000_0030
public let LL_CORDIC_PRECISION_4CYCLES: UInt32 = 0x0000_0040
public let LL_CORDIC_PRECISION_5CYCLES: UInt32 = 0x0000_0050
public let LL_CORDIC_PRECISION_6CYCLES: UInt32 = 0x0000_0060
public let LL_CORDIC_PRECISION_7CYCLES: UInt32 = 0x0000_0070
public let LL_CORDIC_PRECISION_8CYCLES: UInt32 = 0x0000_0080
public let LL_CORDIC_PRECISION_9CYCLES: UInt32 = 0x0000_0090
public let LL_CORDIC_PRECISION_10CYCLES: UInt32 = 0x0000_00A0
public let LL_CORDIC_PRECISION_11CYCLES: UInt32 = 0x0000_00B0
public let LL_CORDIC_PRECISION_12CYCLES: UInt32 = 0x0000_00C0
public let LL_CORDIC_PRECISION_13CYCLES: UInt32 = 0x0000_00D0
public let LL_CORDIC_PRECISION_14CYCLES: UInt32 = 0x0000_00E0
public let LL_CORDIC_PRECISION_15CYCLES: UInt32 = 0x0000_00F0
public let LL_CORDIC_SCALE_0: UInt32 = 0x0000_0000
public let LL_CORDIC_SCALE_1: UInt32 = 0x0000_0100
public let LL_CORDIC_SCALE_2: UInt32 = 0x0000_0200
public let LL_CORDIC_SCALE_3: UInt32 = 0x0000_0300
public let LL_CORDIC_SCALE_4: UInt32 = 0x0000_0400
public let LL_CORDIC_SCALE_5: UInt32 = 0x0000_0500
public let LL_CORDIC_SCALE_6: UInt32 = 0x0000_0600
public let LL_CORDIC_SCALE_7: UInt32 = 0x0000_0700
public let LL_CORDIC_NBWRITE_1: UInt32 = 0x0000_0000
public let LL_CORDIC_NBWRITE_2: UInt32 = 0x0010_0000
public let LL_CORDIC_NBREAD_1: UInt32 = 0x0000_0000
public let LL_CORDIC_NBREAD_2: UInt32 = 0x0008_0000
public let LL_CORDIC_INSIZE_32BITS: UInt32 = 0x0000_0000
public let LL_CORDIC_INSIZE_16BITS: UInt32 = 0x0040_0000
public let LL_CORDIC_OUTSIZE_32BITS: UInt32 = 0x0000_0000
public let LL_CORDIC_OUTSIZE_16BITS: UInt32 = 0x0020_0000
public let LL_CORDIC_DMA_REG_DATA_IN: UInt32 = 0x0000_0000
public let LL_CORDIC_DMA_REG_DATA_OUT: UInt32 = 0x0000_0001

public func LL_CORDIC_Config<IO: CORDICRegisterIO>(
    _ registers: IO, _ Function: UInt32, _ Precision: UInt32, _ Scale: UInt32, _ NbWrite: UInt32, _ NbRead: UInt32,
    _ InSize: UInt32, _ OutSize: UInt32
) {
    registers.write(
        CORDICRegister.csr,
        value: (registers.read(CORDICRegister.csr) & ~(0xf | 0xf0 | 0x700 | 0x100000 | 0x80000 | 0x400000 | 0x200000))
            | (Function | Precision | Scale | NbWrite | NbRead | InSize | OutSize))
}

public func LL_CORDIC_SetFunction<IO: CORDICRegisterIO>(_ registers: IO, _ Function: UInt32) {
    registers.write(CORDICRegister.csr, value: (registers.read(CORDICRegister.csr) & ~(0xf)) | (Function))
}

public func LL_CORDIC_GetFunction<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(CORDICRegister.csr) & (0xf)))
}

public func LL_CORDIC_SetPrecision<IO: CORDICRegisterIO>(_ registers: IO, _ Precision: UInt32) {
    registers.write(CORDICRegister.csr, value: (registers.read(CORDICRegister.csr) & ~(0xf0)) | (Precision))
}

public func LL_CORDIC_GetPrecision<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(CORDICRegister.csr) & (0xf0)))
}

public func LL_CORDIC_SetScale<IO: CORDICRegisterIO>(_ registers: IO, _ Scale: UInt32) {
    registers.write(CORDICRegister.csr, value: (registers.read(CORDICRegister.csr) & ~(0x700)) | (Scale))
}

public func LL_CORDIC_GetScale<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(CORDICRegister.csr) & (0x700)))
}

public func LL_CORDIC_SetNbWrite<IO: CORDICRegisterIO>(_ registers: IO, _ NbWrite: UInt32) {
    registers.write(CORDICRegister.csr, value: (registers.read(CORDICRegister.csr) & ~(0x100000)) | (NbWrite))
}

public func LL_CORDIC_GetNbWrite<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(CORDICRegister.csr) & (0x100000)))
}

public func LL_CORDIC_SetNbRead<IO: CORDICRegisterIO>(_ registers: IO, _ NbRead: UInt32) {
    registers.write(CORDICRegister.csr, value: (registers.read(CORDICRegister.csr) & ~(0x80000)) | (NbRead))
}

public func LL_CORDIC_GetNbRead<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(CORDICRegister.csr) & (0x80000)))
}

public func LL_CORDIC_SetInSize<IO: CORDICRegisterIO>(_ registers: IO, _ InSize: UInt32) {
    registers.write(CORDICRegister.csr, value: (registers.read(CORDICRegister.csr) & ~(0x400000)) | (InSize))
}

public func LL_CORDIC_GetInSize<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(CORDICRegister.csr) & (0x400000)))
}

public func LL_CORDIC_SetOutSize<IO: CORDICRegisterIO>(_ registers: IO, _ OutSize: UInt32) {
    registers.write(CORDICRegister.csr, value: (registers.read(CORDICRegister.csr) & ~(0x200000)) | (OutSize))
}

public func LL_CORDIC_GetOutSize<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(CORDICRegister.csr) & (0x200000)))
}

public func LL_CORDIC_EnableIT<IO: CORDICRegisterIO>(_ registers: IO) {
    registers.write(CORDICRegister.csr, value: registers.read(CORDICRegister.csr) | (0x10000))
}

public func LL_CORDIC_DisableIT<IO: CORDICRegisterIO>(_ registers: IO) {
    registers.write(CORDICRegister.csr, value: registers.read(CORDICRegister.csr) & ~(0x10000))
}

public func LL_CORDIC_IsEnabledIT<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(CORDICRegister.csr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_CORDIC_EnableDMAReq_RD<IO: CORDICRegisterIO>(_ registers: IO) {
    registers.write(CORDICRegister.csr, value: registers.read(CORDICRegister.csr) | (0x20000))
}

public func LL_CORDIC_DisableDMAReq_RD<IO: CORDICRegisterIO>(_ registers: IO) {
    registers.write(CORDICRegister.csr, value: registers.read(CORDICRegister.csr) & ~(0x20000))
}

public func LL_CORDIC_IsEnabledDMAReq_RD<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(CORDICRegister.csr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_CORDIC_EnableDMAReq_WR<IO: CORDICRegisterIO>(_ registers: IO) {
    registers.write(CORDICRegister.csr, value: registers.read(CORDICRegister.csr) | (0x40000))
}

public func LL_CORDIC_DisableDMAReq_WR<IO: CORDICRegisterIO>(_ registers: IO) {
    registers.write(CORDICRegister.csr, value: registers.read(CORDICRegister.csr) & ~(0x40000))
}

public func LL_CORDIC_IsEnabledDMAReq_WR<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(CORDICRegister.csr) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_CORDIC_DMA_GetRegAddr<IO: CORDICRegisterIO>(_ registers: IO, _ Direction: UInt32) -> UInt32 {
    return registers.address(of: Direction == LL_CORDIC_DMA_REG_DATA_OUT ? .rdata : .wdata)
}

public func LL_CORDIC_IsActiveFlag_RRDY<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(CORDICRegister.csr) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_CORDIC_WriteData<IO: CORDICRegisterIO>(_ registers: IO, _ InData: UInt32) {
    registers.write(CORDICRegister.wdata, value: InData)
}

public func LL_CORDIC_ReadData<IO: CORDICRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(CORDICRegister.rdata))
}

public func LL_CORDIC_DeInit<IO: CORDICRegisterIO & LLBusRegisterIO>(
    _ registers: inout IO, isKnownInstance: Bool = true
) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue

    if isKnownInstance {
        LL_AHB2_GRP1_ForceReset(&registers, LL_AHB2_GRP1_PERIPH_CORDIC)

        LL_AHB2_GRP1_ReleaseReset(&registers, LL_AHB2_GRP1_PERIPH_CORDIC)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}
