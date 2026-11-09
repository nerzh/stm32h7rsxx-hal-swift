// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_DMA2D_FLAG_CEIF: UInt32 = 0x0000_0020
public let LL_DMA2D_FLAG_CTCIF: UInt32 = 0x0000_0010
public let LL_DMA2D_FLAG_CAEIF: UInt32 = 0x0000_0008
public let LL_DMA2D_FLAG_TWIF: UInt32 = 0x0000_0004
public let LL_DMA2D_FLAG_TCIF: UInt32 = 0x0000_0002
public let LL_DMA2D_FLAG_TEIF: UInt32 = 0x0000_0001
public let LL_DMA2D_IT_CEIE: UInt32 = 0x0000_2000
public let LL_DMA2D_IT_CTCIE: UInt32 = 0x0000_1000
public let LL_DMA2D_IT_CAEIE: UInt32 = 0x0000_0800
public let LL_DMA2D_IT_TWIE: UInt32 = 0x0000_0400
public let LL_DMA2D_IT_TCIE: UInt32 = 0x0000_0200
public let LL_DMA2D_IT_TEIE: UInt32 = 0x0000_0100
public let LL_DMA2D_MODE_M2M: UInt32 = 0x0000_0000
public let LL_DMA2D_MODE_M2M_PFC: UInt32 = 0x0001_0000
public let LL_DMA2D_MODE_M2M_BLEND: UInt32 = 0x0002_0000
public let LL_DMA2D_MODE_R2M: UInt32 = 0x0003_0000
public let LL_DMA2D_MODE_M2M_BLEND_FIXED_COLOR_FG: UInt32 = 0x0004_0000
public let LL_DMA2D_MODE_M2M_BLEND_FIXED_COLOR_BG: UInt32 = 0x0005_0000
public let LL_DMA2D_OUTPUT_MODE_ARGB8888: UInt32 = 0x0000_0000
public let LL_DMA2D_OUTPUT_MODE_RGB888: UInt32 = 0x0000_0001
public let LL_DMA2D_OUTPUT_MODE_RGB565: UInt32 = 0x0000_0002
public let LL_DMA2D_OUTPUT_MODE_ARGB1555: UInt32 = 0x0000_0003
public let LL_DMA2D_OUTPUT_MODE_ARGB4444: UInt32 = 0x0000_0004
public let LL_DMA2D_INPUT_MODE_ARGB8888: UInt32 = 0x0000_0000
public let LL_DMA2D_INPUT_MODE_RGB888: UInt32 = 0x0000_0001
public let LL_DMA2D_INPUT_MODE_RGB565: UInt32 = 0x0000_0002
public let LL_DMA2D_INPUT_MODE_ARGB1555: UInt32 = 0x0000_0003
public let LL_DMA2D_INPUT_MODE_ARGB4444: UInt32 = 0x0000_0004
public let LL_DMA2D_INPUT_MODE_L8: UInt32 = 0x0000_0005
public let LL_DMA2D_INPUT_MODE_AL44: UInt32 = 0x0000_0006
public let LL_DMA2D_INPUT_MODE_AL88: UInt32 = 0x0000_0007
public let LL_DMA2D_INPUT_MODE_L4: UInt32 = 0x0000_0008
public let LL_DMA2D_INPUT_MODE_A8: UInt32 = 0x0000_0009
public let LL_DMA2D_INPUT_MODE_A4: UInt32 = 0x0000_000A
public let LL_DMA2D_INPUT_MODE_YCBCR: UInt32 = 0x0000_000B
public let LL_DMA2D_ALPHA_MODE_NO_MODIF: UInt32 = 0x0000_0000
public let LL_DMA2D_ALPHA_MODE_REPLACE: UInt32 = 0x0001_0000
public let LL_DMA2D_ALPHA_MODE_COMBINE: UInt32 = 0x0002_0000
public let LL_DMA2D_SWAP_MODE_REGULAR: UInt32 = 0x0000_0000
public let LL_DMA2D_SWAP_MODE_TWO_BY_TWO: UInt32 = 0x0000_0100
public let LL_DMA2D_RB_MODE_REGULAR: UInt32 = 0x0000_0000
public let LL_DMA2D_RB_MODE_SWAP: UInt32 = 0x0020_0000
public let LL_DMA2D_ALPHA_REGULAR: UInt32 = 0x0000_0000
public let LL_DMA2D_ALPHA_INVERTED: UInt32 = 0x0010_0000
public let LL_DMA2D_LINE_OFFSET_PIXELS: UInt32 = 0x0000_0000
public let LL_DMA2D_LINE_OFFSET_BYTES: UInt32 = 0x0000_0040
public let LL_DMA2D_CLUT_COLOR_MODE_ARGB8888: UInt32 = 0x0000_0000
public let LL_DMA2D_CLUT_COLOR_MODE_RGB888: UInt32 = 0x0000_0010
public let LL_DMA2D_CSS_444: UInt32 = 0x0000_0000
public let LL_DMA2D_CSS_422: UInt32 = 0x0004_0000
public let LL_DMA2D_CSS_420: UInt32 = 0x0008_0000

public func LL_DMA2D_Start<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) | (0x1))
}

public func LL_DMA2D_IsTransferOngoing<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_DMA2D_Suspend<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: (registers.read(DMA2DRegister.cr) & ~(0x2 | 0x1)) | (0x2))
}

public func LL_DMA2D_Resume<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) & ~(0x2 | 0x1))
}

public func LL_DMA2D_IsSuspended<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_DMA2D_Abort<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: (registers.read(DMA2DRegister.cr) & ~(0x4 | 0x1)) | (0x4))
}

public func LL_DMA2D_IsAborted<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_DMA2D_SetMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Mode: UInt32) {
    registers.write(DMA2DRegister.cr, value: (registers.read(DMA2DRegister.cr) & ~(0x70000)) | (Mode))
}

public func LL_DMA2D_GetMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.cr) & (0x70000)))
}

public func LL_DMA2D_SetOutputColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ ColorMode: UInt32) {
    registers.write(DMA2DRegister.opfccr, value: (registers.read(DMA2DRegister.opfccr) & ~(0x7)) | (ColorMode))
}

public func LL_DMA2D_GetOutputColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.opfccr) & (0x7)))
}

public func LL_DMA2D_SetOutputRBSwapMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ RBSwapMode: UInt32) {
    registers.write(DMA2DRegister.opfccr, value: (registers.read(DMA2DRegister.opfccr) & ~(0x200000)) | (RBSwapMode))
}

public func LL_DMA2D_GetOutputRBSwapMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.opfccr) & (0x200000)))
}

public func LL_DMA2D_SetOutputAlphaInvMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ AlphaInversionMode: UInt32) {
    registers.write(
        DMA2DRegister.opfccr, value: (registers.read(DMA2DRegister.opfccr) & ~(0x100000)) | (AlphaInversionMode))
}

public func LL_DMA2D_GetOutputAlphaInvMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.opfccr) & (0x100000)))
}

public func LL_DMA2D_SetOutputSwapMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ OutputSwapMode: UInt32) {
    registers.write(DMA2DRegister.opfccr, value: (registers.read(DMA2DRegister.opfccr) & ~(0x100)) | (OutputSwapMode))
}

public func LL_DMA2D_GetOutputSwapMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.opfccr) & (0x100)))
}

public func LL_DMA2D_SetLineOffsetMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ LineOffsetMode: UInt32) {
    registers.write(DMA2DRegister.cr, value: (registers.read(DMA2DRegister.cr) & ~(0x40)) | (LineOffsetMode))
}

public func LL_DMA2D_GetLineOffsetMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.cr) & (0x40)))
}

public func LL_DMA2D_SetLineOffset<IO: DMA2DRegisterIO>(_ registers: inout IO, _ LineOffset: UInt32) {
    registers.write(DMA2DRegister.oor, value: (registers.read(DMA2DRegister.oor) & ~(0xffff)) | (LineOffset))
}

public func LL_DMA2D_GetLineOffset<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.oor) & (0xffff)))
}

public func LL_DMA2D_SetNbrOfPixelsPerLines<IO: DMA2DRegisterIO>(_ registers: inout IO, _ NbrOfPixelsPerLines: UInt32) {
    registers.write(
        DMA2DRegister.nlr, value: (registers.read(DMA2DRegister.nlr) & ~(0x3fff_0000)) | ((NbrOfPixelsPerLines << 0x10))
    )
}

public func LL_DMA2D_GetNbrOfPixelsPerLines<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.nlr) & (0x3fff_0000)) >> 0x10)
}

public func LL_DMA2D_SetNbrOfLines<IO: DMA2DRegisterIO>(_ registers: inout IO, _ NbrOfLines: UInt32) {
    registers.write(DMA2DRegister.nlr, value: (registers.read(DMA2DRegister.nlr) & ~(0xffff)) | (NbrOfLines))
}

public func LL_DMA2D_GetNbrOfLines<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.nlr) & (0xffff)))
}

public func LL_DMA2D_SetOutputMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO, _ OutputMemoryAddress: UInt32) {
    registers.write(DMA2DRegister.omar, value: OutputMemoryAddress)
}

public func LL_DMA2D_GetOutputMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(DMA2DRegister.omar))
}

public func LL_DMA2D_SetOutputColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ OutputColor: UInt32) {
    registers.write(DMA2DRegister.ocolr, value: OutputColor)
}

public func LL_DMA2D_GetOutputColor<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.ocolr) & ((0xff | 0xff00 | 0xff0000 | 0xff00_0000))))
}

public func LL_DMA2D_SetLineWatermark<IO: DMA2DRegisterIO>(_ registers: inout IO, _ LineWatermark: UInt32) {
    registers.write(DMA2DRegister.lwr, value: (registers.read(DMA2DRegister.lwr) & ~(0xffff)) | (LineWatermark))
}

public func LL_DMA2D_GetLineWatermark<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.lwr) & (0xffff)))
}

public func LL_DMA2D_SetDeadTime<IO: DMA2DRegisterIO>(_ registers: inout IO, _ DeadTime: UInt32) {
    registers.write(DMA2DRegister.amtcr, value: (registers.read(DMA2DRegister.amtcr) & ~(0xff00)) | ((DeadTime << 0x8)))
}

public func LL_DMA2D_GetDeadTime<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.amtcr) & (0xff00)) >> 0x8)
}

public func LL_DMA2D_EnableDeadTime<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.amtcr, value: registers.read(DMA2DRegister.amtcr) | (0x1))
}

public func LL_DMA2D_DisableDeadTime<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.amtcr, value: registers.read(DMA2DRegister.amtcr) & ~(0x1))
}

public func LL_DMA2D_IsEnabledDeadTime<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.amtcr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_DMA2D_FGND_SetMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO, _ MemoryAddress: UInt32) {
    registers.write(DMA2DRegister.fgmar, value: MemoryAddress)
}

public func LL_DMA2D_FGND_GetMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(DMA2DRegister.fgmar))
}

public func LL_DMA2D_FGND_EnableCLUTLoad<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.fgpfccr, value: registers.read(DMA2DRegister.fgpfccr) | (0x20))
}

public func LL_DMA2D_FGND_IsEnabledCLUTLoad<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.fgpfccr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_DMA2D_FGND_SetColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ ColorMode: UInt32) {
    registers.write(DMA2DRegister.fgpfccr, value: (registers.read(DMA2DRegister.fgpfccr) & ~(0xf)) | (ColorMode))
}

public func LL_DMA2D_FGND_GetColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgpfccr) & (0xf)))
}

public func LL_DMA2D_FGND_SetAlphaMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ AphaMode: UInt32) {
    registers.write(DMA2DRegister.fgpfccr, value: (registers.read(DMA2DRegister.fgpfccr) & ~(0x30000)) | (AphaMode))
}

public func LL_DMA2D_FGND_GetAlphaMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgpfccr) & (0x30000)))
}

public func LL_DMA2D_FGND_SetAlpha<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Alpha: UInt32) {
    registers.write(
        DMA2DRegister.fgpfccr, value: (registers.read(DMA2DRegister.fgpfccr) & ~(0xff00_0000)) | ((Alpha << 0x18)))
}

public func LL_DMA2D_FGND_GetAlpha<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgpfccr) & (0xff00_0000)) >> 0x18)
}

public func LL_DMA2D_FGND_SetRBSwapMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ RBSwapMode: UInt32) {
    registers.write(DMA2DRegister.fgpfccr, value: (registers.read(DMA2DRegister.fgpfccr) & ~(0x200000)) | (RBSwapMode))
}

public func LL_DMA2D_FGND_GetRBSwapMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgpfccr) & (0x200000)))
}

public func LL_DMA2D_FGND_SetAlphaInvMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ AlphaInversionMode: UInt32) {
    registers.write(
        DMA2DRegister.fgpfccr, value: (registers.read(DMA2DRegister.fgpfccr) & ~(0x100000)) | (AlphaInversionMode))
}

public func LL_DMA2D_FGND_GetAlphaInvMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgpfccr) & (0x100000)))
}

public func LL_DMA2D_FGND_SetLineOffset<IO: DMA2DRegisterIO>(_ registers: inout IO, _ LineOffset: UInt32) {
    registers.write(DMA2DRegister.fgor, value: (registers.read(DMA2DRegister.fgor) & ~(0xffff)) | (LineOffset))
}

public func LL_DMA2D_FGND_GetLineOffset<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgor) & (0xffff)))
}

public func LL_DMA2D_FGND_SetColor<IO: DMA2DRegisterIO>(
    _ registers: inout IO, _ Red: UInt32, _ Green: UInt32, _ Blue: UInt32
) {
    registers.write(
        DMA2DRegister.fgcolr,
        value: (registers.read(DMA2DRegister.fgcolr) & ~((0xff0000 | 0xff00 | 0xff)))
            | (((Red << 0x10) | (Green << 0x8) | Blue)))
}

public func LL_DMA2D_FGND_SetRedColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Red: UInt32) {
    registers.write(DMA2DRegister.fgcolr, value: (registers.read(DMA2DRegister.fgcolr) & ~(0xff0000)) | ((Red << 0x10)))
}

public func LL_DMA2D_FGND_GetRedColor<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgcolr) & (0xff0000)) >> 0x10)
}

public func LL_DMA2D_FGND_SetGreenColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Green: UInt32) {
    registers.write(DMA2DRegister.fgcolr, value: (registers.read(DMA2DRegister.fgcolr) & ~(0xff00)) | ((Green << 0x8)))
}

public func LL_DMA2D_FGND_GetGreenColor<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgcolr) & (0xff00)) >> 0x8)
}

public func LL_DMA2D_FGND_SetBlueColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Blue: UInt32) {
    registers.write(DMA2DRegister.fgcolr, value: (registers.read(DMA2DRegister.fgcolr) & ~(0xff)) | (Blue))
}

public func LL_DMA2D_FGND_GetBlueColor<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgcolr) & (0xff)))
}

public func LL_DMA2D_FGND_SetCLUTMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO, _ CLUTMemoryAddress: UInt32) {
    registers.write(DMA2DRegister.fgcmar, value: CLUTMemoryAddress)
}

public func LL_DMA2D_FGND_GetCLUTMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(DMA2DRegister.fgcmar))
}

public func LL_DMA2D_FGND_SetCLUTSize<IO: DMA2DRegisterIO>(_ registers: inout IO, _ CLUTSize: UInt32) {
    registers.write(
        DMA2DRegister.fgpfccr, value: (registers.read(DMA2DRegister.fgpfccr) & ~(0xff00)) | ((CLUTSize << 0x8)))
}

public func LL_DMA2D_FGND_GetCLUTSize<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgpfccr) & (0xff00)) >> 0x8)
}

public func LL_DMA2D_FGND_SetCLUTColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ CLUTColorMode: UInt32) {
    registers.write(DMA2DRegister.fgpfccr, value: (registers.read(DMA2DRegister.fgpfccr) & ~(0x10)) | (CLUTColorMode))
}

public func LL_DMA2D_FGND_GetCLUTColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgpfccr) & (0x10)))
}

public func LL_DMA2D_FGND_SetChrSubSampling<IO: DMA2DRegisterIO>(_ registers: inout IO, _ ChromaSubSampling: UInt32) {
    registers.write(
        DMA2DRegister.fgpfccr, value: (registers.read(DMA2DRegister.fgpfccr) & ~(0xc0000)) | (ChromaSubSampling))
}

public func LL_DMA2D_FGND_GetChrSubSampling<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.fgpfccr) & (0xc0000)))
}

public func LL_DMA2D_BGND_SetMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO, _ MemoryAddress: UInt32) {
    registers.write(DMA2DRegister.bgmar, value: MemoryAddress)
}

public func LL_DMA2D_BGND_GetMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(DMA2DRegister.bgmar))
}

public func LL_DMA2D_BGND_EnableCLUTLoad<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.bgpfccr, value: registers.read(DMA2DRegister.bgpfccr) | (0x20))
}

public func LL_DMA2D_BGND_IsEnabledCLUTLoad<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.bgpfccr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_DMA2D_BGND_SetColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ ColorMode: UInt32) {
    registers.write(DMA2DRegister.bgpfccr, value: (registers.read(DMA2DRegister.bgpfccr) & ~(0xf)) | (ColorMode))
}

public func LL_DMA2D_BGND_GetColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgpfccr) & (0xf)))
}

public func LL_DMA2D_BGND_SetAlphaMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ AphaMode: UInt32) {
    registers.write(DMA2DRegister.bgpfccr, value: (registers.read(DMA2DRegister.bgpfccr) & ~(0x30000)) | (AphaMode))
}

public func LL_DMA2D_BGND_GetAlphaMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgpfccr) & (0x30000)))
}

public func LL_DMA2D_BGND_SetAlpha<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Alpha: UInt32) {
    registers.write(
        DMA2DRegister.bgpfccr, value: (registers.read(DMA2DRegister.bgpfccr) & ~(0xff00_0000)) | ((Alpha << 0x18)))
}

public func LL_DMA2D_BGND_GetAlpha<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgpfccr) & (0xff00_0000)) >> 0x18)
}

public func LL_DMA2D_BGND_SetRBSwapMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ RBSwapMode: UInt32) {
    registers.write(DMA2DRegister.bgpfccr, value: (registers.read(DMA2DRegister.bgpfccr) & ~(0x200000)) | (RBSwapMode))
}

public func LL_DMA2D_BGND_GetRBSwapMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgpfccr) & (0x200000)))
}

public func LL_DMA2D_BGND_SetAlphaInvMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ AlphaInversionMode: UInt32) {
    registers.write(
        DMA2DRegister.bgpfccr, value: (registers.read(DMA2DRegister.bgpfccr) & ~(0x100000)) | (AlphaInversionMode))
}

public func LL_DMA2D_BGND_GetAlphaInvMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgpfccr) & (0x100000)))
}

public func LL_DMA2D_BGND_SetLineOffset<IO: DMA2DRegisterIO>(_ registers: inout IO, _ LineOffset: UInt32) {
    registers.write(DMA2DRegister.bgor, value: (registers.read(DMA2DRegister.bgor) & ~(0xffff)) | (LineOffset))
}

public func LL_DMA2D_BGND_GetLineOffset<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgor) & (0xffff)))
}

public func LL_DMA2D_BGND_SetColor<IO: DMA2DRegisterIO>(
    _ registers: inout IO, _ Red: UInt32, _ Green: UInt32, _ Blue: UInt32
) {
    registers.write(
        DMA2DRegister.bgcolr,
        value: (registers.read(DMA2DRegister.bgcolr) & ~((0xff0000 | 0xff00 | 0xff)))
            | (((Red << 0x10) | (Green << 0x8) | Blue)))
}

public func LL_DMA2D_BGND_SetRedColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Red: UInt32) {
    registers.write(DMA2DRegister.bgcolr, value: (registers.read(DMA2DRegister.bgcolr) & ~(0xff0000)) | ((Red << 0x10)))
}

public func LL_DMA2D_BGND_GetRedColor<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgcolr) & (0xff0000)) >> 0x10)
}

public func LL_DMA2D_BGND_SetGreenColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Green: UInt32) {
    registers.write(DMA2DRegister.bgcolr, value: (registers.read(DMA2DRegister.bgcolr) & ~(0xff00)) | ((Green << 0x8)))
}

public func LL_DMA2D_BGND_GetGreenColor<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgcolr) & (0xff00)) >> 0x8)
}

public func LL_DMA2D_BGND_SetBlueColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ Blue: UInt32) {
    registers.write(DMA2DRegister.bgcolr, value: (registers.read(DMA2DRegister.bgcolr) & ~(0xff)) | (Blue))
}

public func LL_DMA2D_BGND_GetBlueColor<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgcolr) & (0xff)))
}

public func LL_DMA2D_BGND_SetCLUTMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO, _ CLUTMemoryAddress: UInt32) {
    registers.write(DMA2DRegister.bgcmar, value: CLUTMemoryAddress)
}

public func LL_DMA2D_BGND_GetCLUTMemAddr<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(DMA2DRegister.bgcmar))
}

public func LL_DMA2D_BGND_SetCLUTSize<IO: DMA2DRegisterIO>(_ registers: inout IO, _ CLUTSize: UInt32) {
    registers.write(
        DMA2DRegister.bgpfccr, value: (registers.read(DMA2DRegister.bgpfccr) & ~(0xff00)) | ((CLUTSize << 0x8)))
}

public func LL_DMA2D_BGND_GetCLUTSize<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgpfccr) & (0xff00)) >> 0x8)
}

public func LL_DMA2D_BGND_SetCLUTColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO, _ CLUTColorMode: UInt32) {
    registers.write(DMA2DRegister.bgpfccr, value: (registers.read(DMA2DRegister.bgpfccr) & ~(0x10)) | (CLUTColorMode))
}

public func LL_DMA2D_BGND_GetCLUTColorMode<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(DMA2DRegister.bgpfccr) & (0x10)))
}

public func LL_DMA2D_IsActiveFlag_CE<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.isr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_DMA2D_IsActiveFlag_CTC<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.isr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_DMA2D_IsActiveFlag_CAE<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.isr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_DMA2D_IsActiveFlag_TW<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.isr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_DMA2D_IsActiveFlag_TC<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.isr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_DMA2D_IsActiveFlag_TE<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.isr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_DMA2D_ClearFlag_CE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.ifcr, value: 0x20)
}

public func LL_DMA2D_ClearFlag_CTC<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.ifcr, value: 0x10)
}

public func LL_DMA2D_ClearFlag_CAE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.ifcr, value: 0x8)
}

public func LL_DMA2D_ClearFlag_TW<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.ifcr, value: 0x4)
}

public func LL_DMA2D_ClearFlag_TC<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.ifcr, value: 0x2)
}

public func LL_DMA2D_ClearFlag_TE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.ifcr, value: 0x1)
}

public func LL_DMA2D_EnableIT_CE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) | (0x2000))
}

public func LL_DMA2D_EnableIT_CTC<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) | (0x1000))
}

public func LL_DMA2D_EnableIT_CAE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) | (0x800))
}

public func LL_DMA2D_EnableIT_TW<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) | (0x400))
}

public func LL_DMA2D_EnableIT_TC<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) | (0x200))
}

public func LL_DMA2D_EnableIT_TE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) | (0x100))
}

public func LL_DMA2D_DisableIT_CE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) & ~(0x2000))
}

public func LL_DMA2D_DisableIT_CTC<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) & ~(0x1000))
}

public func LL_DMA2D_DisableIT_CAE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) & ~(0x800))
}

public func LL_DMA2D_DisableIT_TW<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) & ~(0x400))
}

public func LL_DMA2D_DisableIT_TC<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) & ~(0x200))
}

public func LL_DMA2D_DisableIT_TE<IO: DMA2DRegisterIO>(_ registers: inout IO) {
    registers.write(DMA2DRegister.cr, value: registers.read(DMA2DRegister.cr) & ~(0x100))
}

public func LL_DMA2D_IsEnabledIT_CE<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_DMA2D_IsEnabledIT_CTC<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_DMA2D_IsEnabledIT_CAE<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_DMA2D_IsEnabledIT_TW<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_DMA2D_IsEnabledIT_TC<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_DMA2D_IsEnabledIT_TE<IO: DMA2DRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(DMA2DRegister.cr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_DMA2D_DeInit<IO: LLBusRegisterIO>(_ registers: inout IO, isKnownInstance: Bool = true) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue

    if isKnownInstance {
        LL_AHB5_GRP1_ForceReset(&registers, LL_AHB5_GRP1_PERIPH_DMA2D)

        LL_AHB5_GRP1_ReleaseReset(&registers, LL_AHB5_GRP1_PERIPH_DMA2D)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_DMA2D_Init<IO: DMA2DRegisterIO>(_ registers: inout IO, _ DMA2D_InitStruct: inout LL_DMA2D_InitTypeDef)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.error.rawValue
    var dma2d_colorstruct = LL_DMA2D_ColorTypeDef()
    var tmp: UInt32
    var tmp1: UInt32
    var tmp2: UInt32
    var regMask: UInt32
    var regValue: UInt32

    tmp = LL_DMA2D_IsTransferOngoing(&registers)
    tmp1 = LL_DMA2D_FGND_IsEnabledCLUTLoad(&registers)
    tmp2 = LL_DMA2D_BGND_IsEnabledCLUTLoad(&registers)
    if (tmp == 0) && (tmp1 == 0) && (tmp2 == 0) {
        registers.write(
            DMA2DRegister.cr,
            value: (registers.read(DMA2DRegister.cr) & ~((0x70000 | 0x40)))
                | ((DMA2D_InitStruct.Mode | DMA2D_InitStruct.LineOffsetMode)))

        regMask = 0x7
        regValue = DMA2D_InitStruct.ColorMode
        regMask |= 0x100
        regValue |= DMA2D_InitStruct.OutputSwapMode
        regMask |= (0x200000 | 0x100000)
        regValue |= (DMA2D_InitStruct.AlphaInversionMode | DMA2D_InitStruct.RBSwapMode)
        registers.write(DMA2DRegister.opfccr, value: (registers.read(DMA2DRegister.opfccr) & ~(regMask)) | (regValue))

        LL_DMA2D_SetLineOffset(&registers, DMA2D_InitStruct.LineOffset)

        LL_DMA2D_ConfigSize(&registers, DMA2D_InitStruct.NbrOfLines, DMA2D_InitStruct.NbrOfPixelsPerLines)

        LL_DMA2D_SetOutputMemAddr(&registers, DMA2D_InitStruct.OutputMemoryAddress)

        dma2d_colorstruct.ColorMode = DMA2D_InitStruct.ColorMode
        dma2d_colorstruct.OutputBlue = DMA2D_InitStruct.OutputBlue
        dma2d_colorstruct.OutputGreen = DMA2D_InitStruct.OutputGreen
        dma2d_colorstruct.OutputRed = DMA2D_InitStruct.OutputRed
        dma2d_colorstruct.OutputAlpha = DMA2D_InitStruct.OutputAlpha
        LL_DMA2D_ConfigOutputColor(&registers, &dma2d_colorstruct)
        status = LLErrorStatus.success.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_DMA2D_StructInit(_ DMA2D_InitStruct: inout LL_DMA2D_InitTypeDef) {
    DMA2D_InitStruct.Mode = LL_DMA2D_MODE_M2M
    DMA2D_InitStruct.ColorMode = LL_DMA2D_OUTPUT_MODE_ARGB8888
    DMA2D_InitStruct.NbrOfLines = 0x0
    DMA2D_InitStruct.NbrOfPixelsPerLines = 0x0
    DMA2D_InitStruct.LineOffsetMode = LL_DMA2D_LINE_OFFSET_PIXELS
    DMA2D_InitStruct.LineOffset = 0x0
    DMA2D_InitStruct.OutputBlue = 0x0
    DMA2D_InitStruct.OutputGreen = 0x0
    DMA2D_InitStruct.OutputRed = 0x0
    DMA2D_InitStruct.OutputAlpha = 0x0
    DMA2D_InitStruct.OutputMemoryAddress = 0x0
    DMA2D_InitStruct.OutputSwapMode = LL_DMA2D_SWAP_MODE_REGULAR
    DMA2D_InitStruct.AlphaInversionMode = LL_DMA2D_ALPHA_REGULAR
    DMA2D_InitStruct.RBSwapMode = LL_DMA2D_RB_MODE_REGULAR
}

public func LL_DMA2D_ConfigLayer<IO: DMA2DRegisterIO>(
    _ registers: inout IO, _ DMA2D_LayerCfg: inout LL_DMA2D_LayerCfgTypeDef, _ LayerIdx: UInt32
) {

    if LayerIdx == 0 {
        LL_DMA2D_BGND_SetMemAddr(&registers, DMA2D_LayerCfg.MemoryAddress)

        LL_DMA2D_BGND_SetLineOffset(&registers, DMA2D_LayerCfg.LineOffset)

        registers.write(
            DMA2DRegister.bgpfccr,
            value: (registers.read(DMA2DRegister.bgpfccr)
                & ~((0xff00_0000 | 0x200000 | 0x100000 | 0x30000 | 0xff00 | 0x10 | 0xf)))
                | (((DMA2D_LayerCfg.Alpha << 0x18) | DMA2D_LayerCfg.RBSwapMode | DMA2D_LayerCfg.AlphaInversionMode
                    | DMA2D_LayerCfg.AlphaMode | (DMA2D_LayerCfg.CLUTSize << 0x8) | DMA2D_LayerCfg.CLUTColorMode
                    | DMA2D_LayerCfg.ColorMode)))

        LL_DMA2D_BGND_SetColor(&registers, DMA2D_LayerCfg.Red, DMA2D_LayerCfg.Green, DMA2D_LayerCfg.Blue)

        LL_DMA2D_BGND_SetCLUTMemAddr(&registers, DMA2D_LayerCfg.CLUTMemoryAddress)
    } else {
        LL_DMA2D_FGND_SetMemAddr(&registers, DMA2D_LayerCfg.MemoryAddress)

        LL_DMA2D_FGND_SetLineOffset(&registers, DMA2D_LayerCfg.LineOffset)

        registers.write(
            DMA2DRegister.fgpfccr,
            value: (registers.read(DMA2DRegister.fgpfccr)
                & ~((0xff00_0000 | 0x200000 | 0x100000 | 0xc0000 | 0x30000 | 0xff00 | 0x10 | 0xf)))
                | (((DMA2D_LayerCfg.Alpha << 0x18) | DMA2D_LayerCfg.RBSwapMode | DMA2D_LayerCfg.AlphaInversionMode
                    | DMA2D_LayerCfg.ChromaSubSampling | DMA2D_LayerCfg.AlphaMode | (DMA2D_LayerCfg.CLUTSize << 0x8)
                    | DMA2D_LayerCfg.CLUTColorMode | DMA2D_LayerCfg.ColorMode)))

        LL_DMA2D_FGND_SetColor(&registers, DMA2D_LayerCfg.Red, DMA2D_LayerCfg.Green, DMA2D_LayerCfg.Blue)

        LL_DMA2D_FGND_SetCLUTMemAddr(&registers, DMA2D_LayerCfg.CLUTMemoryAddress)
    }
}

public func LL_DMA2D_LayerCfgStructInit(_ DMA2D_LayerCfg: inout LL_DMA2D_LayerCfgTypeDef) {
    DMA2D_LayerCfg.MemoryAddress = 0x0
    DMA2D_LayerCfg.ColorMode = LL_DMA2D_INPUT_MODE_ARGB8888
    DMA2D_LayerCfg.LineOffset = 0x0
    DMA2D_LayerCfg.CLUTColorMode = LL_DMA2D_CLUT_COLOR_MODE_ARGB8888
    DMA2D_LayerCfg.CLUTSize = 0x0
    DMA2D_LayerCfg.AlphaMode = LL_DMA2D_ALPHA_MODE_NO_MODIF
    DMA2D_LayerCfg.Alpha = 0x0
    DMA2D_LayerCfg.Blue = 0x0
    DMA2D_LayerCfg.Green = 0x0
    DMA2D_LayerCfg.Red = 0x0
    DMA2D_LayerCfg.CLUTMemoryAddress = 0x0
    DMA2D_LayerCfg.AlphaInversionMode = LL_DMA2D_ALPHA_REGULAR
    DMA2D_LayerCfg.RBSwapMode = LL_DMA2D_RB_MODE_REGULAR
    DMA2D_LayerCfg.ChromaSubSampling = LL_DMA2D_CSS_444
}

public func LL_DMA2D_ConfigOutputColor<IO: DMA2DRegisterIO>(
    _ registers: inout IO, _ DMA2D_ColorStruct: inout LL_DMA2D_ColorTypeDef
) {
    var outgreen: UInt32
    var outred: UInt32
    var outalpha: UInt32

    if DMA2D_ColorStruct.ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB8888 {
        outgreen = DMA2D_ColorStruct.OutputGreen << 8
        outred = DMA2D_ColorStruct.OutputRed << 16
        outalpha = DMA2D_ColorStruct.OutputAlpha << 24
    } else if DMA2D_ColorStruct.ColorMode == LL_DMA2D_OUTPUT_MODE_RGB888 {
        outgreen = DMA2D_ColorStruct.OutputGreen << 8
        outred = DMA2D_ColorStruct.OutputRed << 16
        outalpha = 0x0000_0000
    } else if DMA2D_ColorStruct.ColorMode == LL_DMA2D_OUTPUT_MODE_RGB565 {
        outgreen = DMA2D_ColorStruct.OutputGreen << 5
        outred = DMA2D_ColorStruct.OutputRed << 11
        outalpha = 0x0000_0000
    } else if DMA2D_ColorStruct.ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB1555 {
        outgreen = DMA2D_ColorStruct.OutputGreen << 5
        outred = DMA2D_ColorStruct.OutputRed << 10
        outalpha = DMA2D_ColorStruct.OutputAlpha << 15
    } else {
        outgreen = DMA2D_ColorStruct.OutputGreen << 4
        outred = DMA2D_ColorStruct.OutputRed << 8
        outalpha = DMA2D_ColorStruct.OutputAlpha << 12
    }
    LL_DMA2D_SetOutputColor(&registers, (outgreen | outred | DMA2D_ColorStruct.OutputBlue | outalpha))
}

public func LL_DMA2D_GetOutputBlueColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ ColorMode: UInt32) -> UInt32 {
    var color: UInt32

    if ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB8888 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xFF)))
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_RGB888 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xFF)))
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_RGB565 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0x1F)))
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB1555 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0x1F)))
    } else {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xF)))
    }
    return color
}

public func LL_DMA2D_GetOutputGreenColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ ColorMode: UInt32) -> UInt32 {
    var color: UInt32

    if ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB8888 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xFF00)) >> 8)
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_RGB888 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xFF00)) >> 8)
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_RGB565 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0x7E0)) >> 5)
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB1555 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0x3E0)) >> 5)
    } else {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xF0)) >> 4)
    }
    return color
}

public func LL_DMA2D_GetOutputRedColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ ColorMode: UInt32) -> UInt32 {
    var color: UInt32

    if ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB8888 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xFF0000)) >> 16)
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_RGB888 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xFF0000)) >> 16)
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_RGB565 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xF800)) >> 11)
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB1555 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0x7C00)) >> 10)
    } else {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xF00)) >> 8)
    }
    return color
}

public func LL_DMA2D_GetOutputAlphaColor<IO: DMA2DRegisterIO>(_ registers: inout IO, _ ColorMode: UInt32) -> UInt32 {
    var color: UInt32

    if ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB8888 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xFF00_0000)) >> 24)
    } else if (ColorMode == LL_DMA2D_OUTPUT_MODE_RGB888) || (ColorMode == LL_DMA2D_OUTPUT_MODE_RGB565) {
        color = 0x0
    } else if ColorMode == LL_DMA2D_OUTPUT_MODE_ARGB1555 {
        color = ((registers.read(DMA2DRegister.ocolr) & (0x8000)) >> 15)
    } else {
        color = ((registers.read(DMA2DRegister.ocolr) & (0xF000)) >> 12)
    }
    return color
}

public func LL_DMA2D_ConfigSize<IO: DMA2DRegisterIO>(
    _ registers: inout IO, _ NbrOfLines: UInt32, _ NbrOfPixelsPerLines: UInt32
) {
    registers.write(
        DMA2DRegister.nlr,
        value: (registers.read(DMA2DRegister.nlr) & ~((0x3fff_0000 | 0xffff)))
            | (((NbrOfPixelsPerLines << 0x10) | NbrOfLines)))
}

public func LL_DMA2D_WriteReg<IO: DMA2DRegisterIO>(_ registers: inout IO, _ register: DMA2DRegister, _ value: UInt32) {
    registers.write(register, value: value)
}
public func LL_DMA2D_ReadReg<IO: DMA2DRegisterIO>(_ registers: inout IO, _ register: DMA2DRegister) -> UInt32 {
    registers.read(register)
}
