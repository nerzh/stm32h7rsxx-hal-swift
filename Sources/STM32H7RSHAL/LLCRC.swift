// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_CRC_POLYLENGTH_32B: UInt32 = 0x0000_0000
public let LL_CRC_POLYLENGTH_16B: UInt32 = 0x0000_0008
public let LL_CRC_POLYLENGTH_8B: UInt32 = 0x0000_0010
public let LL_CRC_POLYLENGTH_7B: UInt32 = 0x0000_0018
public let LL_CRC_INDATA_REVERSE_NONE: UInt32 = 0x0000_0000
public let LL_CRC_INDATA_REVERSE_BYTE: UInt32 = 0x0000_0020
public let LL_CRC_INDATA_REVERSE_HALFWORD: UInt32 = 0x0000_0040
public let LL_CRC_INDATA_REVERSE_WORD: UInt32 = 0x0000_0060
public let LL_CRC_OUTDATA_REVERSE_NONE: UInt32 = 0x0000_0000
public let LL_CRC_OUTDATA_REVERSE_BIT: UInt32 = 0x0000_0080
public let LL_CRC_DEFAULT_CRC32_POLY: UInt32 = 0x04C1_1DB7
public let LL_CRC_DEFAULT_CRC_INITVALUE: UInt32 = 0xFFFF_FFFF

public func LL_CRC_ResetCRCCalculationUnit<IO: CRCRegisterIO>(_ registers: inout IO) {
    registers.write(CRCRegister.cr, value: registers.read(CRCRegister.cr) | (0x1))
}

public func LL_CRC_SetPolynomialSize<IO: CRCRegisterIO>(_ registers: inout IO, _ PolySize: UInt32) {
    registers.write(CRCRegister.cr, value: (registers.read(CRCRegister.cr) & ~(0x18)) | (PolySize))
}

public func LL_CRC_GetPolynomialSize<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRCRegister.cr) & (0x18)))
}

public func LL_CRC_SetInputDataReverseMode<IO: CRCRegisterIO>(_ registers: inout IO, _ ReverseMode: UInt32) {
    registers.write(CRCRegister.cr, value: (registers.read(CRCRegister.cr) & ~(0x60)) | (ReverseMode))
}

public func LL_CRC_GetInputDataReverseMode<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRCRegister.cr) & (0x60)))
}

public func LL_CRC_SetOutputDataReverseMode<IO: CRCRegisterIO>(_ registers: inout IO, _ ReverseMode: UInt32) {
    registers.write(CRCRegister.cr, value: (registers.read(CRCRegister.cr) & ~(0x80)) | (ReverseMode))
}

public func LL_CRC_GetOutputDataReverseMode<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(CRCRegister.cr) & (0x80)))
}

public func LL_CRC_SetInitialData<IO: CRCRegisterIO>(_ registers: inout IO, _ InitCrc: UInt32) {
    registers.write(CRCRegister.initialValue, value: InitCrc)
}

public func LL_CRC_GetInitialData<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(CRCRegister.initialValue))
}

public func LL_CRC_SetPolynomialCoef<IO: CRCRegisterIO>(_ registers: inout IO, _ PolynomCoef: UInt32) {
    registers.write(CRCRegister.polynomial, value: PolynomCoef)
}

public func LL_CRC_GetPolynomialCoef<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(CRCRegister.polynomial))
}

public func LL_CRC_FeedData32<IO: CRCRegisterIO>(_ registers: inout IO, _ InData: UInt32) {
    registers.write(CRCRegister.dr, value: InData)
}

public func LL_CRC_FeedData16<IO: CRCRegisterIO>(_ registers: inout IO, _ InData: UInt16) {
    registers.writeData16(InData)
}

public func LL_CRC_FeedData8<IO: CRCRegisterIO>(_ registers: inout IO, _ InData: UInt8) {
    registers.writeData8(InData)
}

public func LL_CRC_ReadData32<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(CRCRegister.dr))
}

public func LL_CRC_ReadData16<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt16 {
    return UInt16(truncatingIfNeeded: registers.read(.dr))
}

public func LL_CRC_ReadData8<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt8 {
    return UInt8(truncatingIfNeeded: registers.read(.dr))
}

public func LL_CRC_ReadData7<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt8 {
    return UInt8(truncatingIfNeeded: registers.read(.dr) & 0x7F)
}

public func LL_CRC_Read_IDR<IO: CRCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(CRCRegister.idr))
}

public func LL_CRC_Write_IDR<IO: CRCRegisterIO>(_ registers: inout IO, _ InData: UInt32) {
    registers.write(.idr, value: InData)
}

public func LL_CRC_DeInit<IO: CRCRegisterIO & LLBusRegisterIO>(_ registers: inout IO, isKnownInstance: Bool = true)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.success.rawValue

    if isKnownInstance {
        LL_AHB4_GRP1_ForceReset(&registers, LL_AHB4_GRP1_PERIPH_CRC)

        LL_AHB4_GRP1_ReleaseReset(&registers, LL_AHB4_GRP1_PERIPH_CRC)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}
