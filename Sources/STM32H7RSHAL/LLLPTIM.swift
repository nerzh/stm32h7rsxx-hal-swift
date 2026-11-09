// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_LPTIM_ISR_CMP1OK: UInt32 = 0x0000_0008
public let LL_LPTIM_ISR_CMP2OK: UInt32 = 0x0008_0000
public let LL_LPTIM_ISR_CC1IF: UInt32 = 0x0000_0001
public let LL_LPTIM_ISR_CC2IF: UInt32 = 0x0000_0200
public let LL_LPTIM_ISR_CC1OF: UInt32 = 0x0000_1000
public let LL_LPTIM_ISR_CC2OF: UInt32 = 0x0000_2000
public let LL_LPTIM_ISR_DIEROK: UInt32 = 0x0100_0000
public let LL_LPTIM_ISR_ARRM: UInt32 = 0x0000_0002
public let LL_LPTIM_ISR_EXTTRIG: UInt32 = 0x0000_0004
public let LL_LPTIM_ISR_ARROK: UInt32 = 0x0000_0010
public let LL_LPTIM_ISR_UP: UInt32 = 0x0000_0020
public let LL_LPTIM_ISR_DOWN: UInt32 = 0x0000_0040
public let LL_LPTIM_ISR_UE: UInt32 = 0x0000_0080
public let LL_LPTIM_ISR_REPOK: UInt32 = 0x0000_0100
public let LL_LPTIM_DIER_CMP1OKIE: UInt32 = 0x0000_0008
public let LL_LPTIM_DIER_CMP2OKIE: UInt32 = 0x0008_0000
public let LL_LPTIM_DIER_CC1IFIE: UInt32 = 0x0000_0001
public let LL_LPTIM_DIER_CC2IFIE: UInt32 = 0x0000_0200
public let LL_LPTIM_DIER_CC1OFIE: UInt32 = 0x0000_1000
public let LL_LPTIM_DIER_CC2OFIE: UInt32 = 0x0000_2000
public let LL_LPTIM_DIER_ARRMIE: UInt32 = 0x0000_0002
public let LL_LPTIM_DIER_EXTTRIGIE: UInt32 = 0x0000_0004
public let LL_LPTIM_DIER_ARROKIE: UInt32 = 0x0000_0010
public let LL_LPTIM_DIER_UPIE: UInt32 = 0x0000_0020
public let LL_LPTIM_DIER_DOWNIE: UInt32 = 0x0000_0040
public let LL_LPTIM_DIER_UEIE: UInt32 = 0x0000_0080
public let LL_LPTIM_DIER_REPOKIE: UInt32 = 0x0000_0100
public let LL_LPTIM_OPERATING_MODE_CONTINUOUS: UInt32 = 0x0000_0004
public let LL_LPTIM_OPERATING_MODE_ONESHOT: UInt32 = 0x0000_0002
public let LL_LPTIM_UPDATE_MODE_IMMEDIATE: UInt32 = 0x0000_0000
public let LL_LPTIM_UPDATE_MODE_ENDOFPERIOD: UInt32 = 0x0040_0000
public let LL_LPTIM_COUNTER_MODE_INTERNAL: UInt32 = 0x0000_0000
public let LL_LPTIM_COUNTER_MODE_EXTERNAL: UInt32 = 0x0080_0000
public let LL_LPTIM_OUTPUT_WAVEFORM_PWM: UInt32 = 0x0000_0000
public let LL_LPTIM_OUTPUT_WAVEFORM_SETONCE: UInt32 = 0x0010_0000
public let LL_LPTIM_OUTPUT_POLARITY_REGULAR: UInt32 = 0x0000_0000
public let LL_LPTIM_OUTPUT_POLARITY_INVERSE: UInt32 = 0x0000_0004
public let LL_LPTIM_CHANNEL_CH1: UInt32 = 0x0000_0000
public let LL_LPTIM_CHANNEL_CH2: UInt32 = 0x0000_0001
public let LL_LPTIM_ICPSC_DIV1: UInt32 = 0x0000_0000
public let LL_LPTIM_ICPSC_DIV2: UInt32 = 0x0000_0100
public let LL_LPTIM_ICPSC_DIV4: UInt32 = 0x0000_0200
public let LL_LPTIM_ICPSC_DIV8: UInt32 = 0x0000_0300
public let LL_LPTIM_ICFLT_CLOCK_DIV1: UInt32 = 0x0000_0000
public let LL_LPTIM_ICFLT_CLOCK_DIV2: UInt32 = 0x0000_1000
public let LL_LPTIM_ICFLT_CLOCK_DIV4: UInt32 = 0x0000_2000
public let LL_LPTIM_ICFLT_CLOCK_DIV8: UInt32 = 0x0000_3000
public let LL_LPTIM_ICPOLARITY_RISING: UInt32 = 0x0000_0000
public let LL_LPTIM_ICPOLARITY_FALLING: UInt32 = 0x0000_0004
public let LL_LPTIM_ICPOLARITY_RISING_FALLING: UInt32 = 0x0000_000C
public let LL_LPTIM_CCMODE_OUTPUT_PWM: UInt32 = 0x0000_0000
public let LL_LPTIM_CCMODE_INPUTCAPTURE: UInt32 = 0x0000_0001
public let LL_LPTIM_PRESCALER_DIV1: UInt32 = 0x0000_0000
public let LL_LPTIM_PRESCALER_DIV2: UInt32 = 0x0000_0200
public let LL_LPTIM_PRESCALER_DIV4: UInt32 = 0x0000_0400
public let LL_LPTIM_PRESCALER_DIV8: UInt32 = 0x0000_0600
public let LL_LPTIM_PRESCALER_DIV16: UInt32 = 0x0000_0800
public let LL_LPTIM_PRESCALER_DIV32: UInt32 = 0x0000_0A00
public let LL_LPTIM_PRESCALER_DIV64: UInt32 = 0x0000_0C00
public let LL_LPTIM_PRESCALER_DIV128: UInt32 = 0x0000_0E00
public let LL_LPTIM_TRIG_SOURCE_GPIO: UInt32 = 0x0000_0000
public let LL_LPTIM_TRIG_SOURCE_RTCALARMA: UInt32 = 0x0000_2000
public let LL_LPTIM_TRIG_SOURCE_RTCALARMB: UInt32 = 0x0000_4000
public let LL_LPTIM_TRIG_SOURCE_RTCTAMP1: UInt32 = 0x0000_6000
public let LL_LPTIM_TRIG_SOURCE_RTCTAMP2: UInt32 = 0x0000_8000
public let LL_LPTIM_TRIG_SOURCE_RTCTAMP3: UInt32 = 0x0000_A000
public let LL_LPTIM_TRIG_SOURCE_SAI1_FS_A: UInt32 = 0x0000_A000
public let LL_LPTIM_TRIG_SOURCE_SAI1_FS_B: UInt32 = 0x0000_C000
public let LL_LPTIM_TRIG_SOURCE_SAI2_FS_A: UInt32 = 0x0000_A000
public let LL_LPTIM_TRIG_SOURCE_SAI2_FS_B: UInt32 = 0x0000_C000
public let LL_LPTIM3_TRIG_SOURCE_LPTIM2_CH1: UInt32 = 0x0000_4000
public let LL_LPTIM3_TRIG_SOURCE_LPTIM4: UInt32 = 0x0000_6000
public let LL_LPTIM3_TRIG_SOURCE_LPTIM5: UInt32 = 0x0000_8000
public let LL_LPTIM4_TRIG_SOURCE_LPTIM2_CH1: UInt32 = 0x0000_2000
public let LL_LPTIM4_TRIG_SOURCE_LPTIM3_CH1: UInt32 = 0x0000_6000
public let LL_LPTIM4_TRIG_SOURCE_LPTIM5: UInt32 = 0x0000_8000
public let LL_LPTIM5_TRIG_SOURCE_LPTIM2_CH1: UInt32 = 0x0000_2000
public let LL_LPTIM5_TRIG_SOURCE_LPTIM3_CH1: UInt32 = 0x0000_4000
public let LL_LPTIM5_TRIG_SOURCE_LPTIM4: UInt32 = 0x0000_8000
public let LL_LPTIM_TRIG_FILTER_NONE: UInt32 = 0x0000_0000
public let LL_LPTIM_TRIG_FILTER_2: UInt32 = 0x0000_0040
public let LL_LPTIM_TRIG_FILTER_4: UInt32 = 0x0000_0080
public let LL_LPTIM_TRIG_FILTER_8: UInt32 = 0x0000_00C0
public let LL_LPTIM_TRIG_POLARITY_RISING: UInt32 = 0x0002_0000
public let LL_LPTIM_TRIG_POLARITY_FALLING: UInt32 = 0x0004_0000
public let LL_LPTIM_TRIG_POLARITY_RISING_FALLING: UInt32 = 0x0006_0000
public let LL_LPTIM_CLK_SOURCE_INTERNAL: UInt32 = 0x0000_0000
public let LL_LPTIM_CLK_SOURCE_EXTERNAL: UInt32 = 0x0000_0001
public let LL_LPTIM_CLK_FILTER_NONE: UInt32 = 0x0000_0000
public let LL_LPTIM_CLK_FILTER_2: UInt32 = 0x0000_0008
public let LL_LPTIM_CLK_FILTER_4: UInt32 = 0x0000_0010
public let LL_LPTIM_CLK_FILTER_8: UInt32 = 0x0000_0018
public let LL_LPTIM_CLK_POLARITY_RISING: UInt32 = 0x0000_0000
public let LL_LPTIM_CLK_POLARITY_FALLING: UInt32 = 0x0000_0002
public let LL_LPTIM_CLK_POLARITY_RISING_FALLING: UInt32 = 0x0000_0004
public let LL_LPTIM_ENCODER_MODE_RISING: UInt32 = 0x0000_0000
public let LL_LPTIM_ENCODER_MODE_FALLING: UInt32 = 0x0000_0002
public let LL_LPTIM_ENCODER_MODE_RISING_FALLING: UInt32 = 0x0000_0004
public let LL_LPTIM_INPUT1_SRC_GPIO: UInt32 = 0x0000_0000
public let LL_LPTIM_INPUT2_SRC_GPIO: UInt32 = 0x0000_0000
public let LL_LPTIM_LPTIM1_IC1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_LPTIM_LPTIM1_IC2_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_LPTIM_LPTIM1_IC2_RMP_LSI: UInt32 = 0x0010_0000
public let LL_LPTIM_LPTIM1_IC2_RMP_LSE: UInt32 = 0x0020_0000
public let LL_LPTIM_LPTIM2_IC1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_LPTIM_LPTIM2_IC2_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_LPTIM_LPTIM2_IC2_RMP_HSI_1024: UInt32 = 0x0010_0000
public let LL_LPTIM_LPTIM2_IC2_RMP_CSI_128: UInt32 = 0x0020_0000
public let LL_LPTIM_LPTIM3_IC1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_LPTIM_LPTIM3_IC2_RMP_GPIO: UInt32 = 0x0000_0000

public let LL_LPTIM_SHIFT_TAB_CCxP: InlineArray<2, UInt8> = [0, 16]
public let LL_LPTIM_SHIFT_TAB_ICxF: InlineArray<2, UInt8> = [0, 16]
public let LL_LPTIM_SHIFT_TAB_ICxPSC: InlineArray<2, UInt8> = [0, 16]
public let LL_LPTIM_SHIFT_TAB_CCxSEL: InlineArray<2, UInt8> = [0, 16]
public let LL_LPTIM_SHIFT_TAB_CCxE: InlineArray<2, UInt8> = [1, 17]
public let LL_LPTIM_OFFSET_TAB_ICx: InlineArray<8, InlineArray<4, UInt8>> = [
    [2, 7, 9, 13], [3, 5, 6, 8], [2, 3, 4, 5], [2, 2, 3, 3], [2, 2, 2, 2], [2, 2, 2, 2], [2, 2, 2, 2], [2, 2, 2, 2],
]
public func LL_LPTIM_Enable<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cr, value: registers.read(LPTIMRegister.cr) | (0x1))
}

public func LL_LPTIM_Disable<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cr, value: registers.read(LPTIMRegister.cr) & ~(0x1))
}

public func LL_LPTIM_IsEnabled<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.cr) & (0x1)) == 0x1) ? 1 : 0))
}

public func LL_LPTIM_StartCounter<IO: LPTIMRegisterIO>(_ registers: inout IO, _ OperatingMode: UInt32) {
    registers.write(LPTIMRegister.cr, value: (registers.read(LPTIMRegister.cr) & ~(0x4 | 0x2)) | (OperatingMode))
}

public func LL_LPTIM_EnableResetAfterRead<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cr, value: registers.read(LPTIMRegister.cr) | (0x10))
}

public func LL_LPTIM_DisableResetAfterRead<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cr, value: registers.read(LPTIMRegister.cr) & ~(0x10))
}

public func LL_LPTIM_IsEnabledResetAfterRead<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.cr) & (0x10)) == 0x10) ? 1 : 0))
}

public func LL_LPTIM_ResetCounter<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cr, value: registers.read(LPTIMRegister.cr) | (0x8))
}

public func LL_LPTIM_SetUpdateMode<IO: LPTIMRegisterIO>(_ registers: inout IO, _ UpdateMode: UInt32) {
    registers.write(LPTIMRegister.cfgr, value: (registers.read(LPTIMRegister.cfgr) & ~(0x400000)) | (UpdateMode))
}

public func LL_LPTIM_GetUpdateMode<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0x400000)))
}

public func LL_LPTIM_SetAutoReload<IO: LPTIMRegisterIO>(_ registers: inout IO, _ AutoReload: UInt32) {
    registers.write(LPTIMRegister.arr, value: (registers.read(LPTIMRegister.arr) & ~(0xffff)) | (AutoReload))
}

public func LL_LPTIM_GetAutoReload<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.arr) & (0xffff)))
}

public func LL_LPTIM_SetRepetition<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Repetition: UInt32) {
    registers.write(LPTIMRegister.rcr, value: (registers.read(LPTIMRegister.rcr) & ~(0xff)) | (Repetition))
}

public func LL_LPTIM_GetRepetition<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.rcr) & (0xff)))
}

public func LL_LPTIM_CC_EnableChannel<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    registers.write(
        LPTIMRegister.ccmr1,
        value: registers.read(LPTIMRegister.ccmr1) | (0x1 << LL_LPTIM_SHIFT_TAB_CCxE[Int(Channel)]))
}

public func LL_LPTIM_CC_DisableChannel<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    registers.write(
        LPTIMRegister.ccmr1,
        value: registers.read(LPTIMRegister.ccmr1) & ~(0x1 << LL_LPTIM_SHIFT_TAB_CCxE[Int(Channel)]))
}

public func LL_LPTIM_CC_IsEnabledChannel<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    return
        (((registers.read(LPTIMRegister.ccmr1) & (0x1 << LL_LPTIM_SHIFT_TAB_CCxE[Int(Channel)]))
        == (0x1 << LL_LPTIM_SHIFT_TAB_CCxE[Int(Channel)])) ? 1 : 0)
}

public func LL_LPTIM_OC_SetCompareCH1<IO: LPTIMRegisterIO>(_ registers: inout IO, _ CompareValue: UInt32) {
    registers.write(LPTIMRegister.ccr1, value: (registers.read(LPTIMRegister.ccr1) & ~(0xffff)) | (CompareValue))
}

public func LL_LPTIM_OC_GetCompareCH1<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.ccr1) & (0xffff)))
}

public func LL_LPTIM_OC_SetCompareCH2<IO: LPTIMRegisterIO>(_ registers: inout IO, _ CompareValue: UInt32) {
    registers.write(LPTIMRegister.ccr2, value: (registers.read(LPTIMRegister.ccr2) & ~(0xffff)) | (CompareValue))
}

public func LL_LPTIM_OC_GetCompareCH2<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.ccr2) & (0xffff)))
}

public func LL_LPTIM_GetCounter<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cnt) & (0xffff)))
}

public func LL_LPTIM_SetCounterMode<IO: LPTIMRegisterIO>(_ registers: inout IO, _ CounterMode: UInt32) {
    registers.write(LPTIMRegister.cfgr, value: (registers.read(LPTIMRegister.cfgr) & ~(0x800000)) | (CounterMode))
}

public func LL_LPTIM_GetCounterMode<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0x800000)))
}

public func LL_LPTIM_SetWaveform<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Waveform: UInt32) {
    registers.write(LPTIMRegister.cfgr, value: (registers.read(LPTIMRegister.cfgr) & ~(0x100000)) | (Waveform))
}

public func LL_LPTIM_GetWaveform<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0x100000)))
}

public func LL_LPTIM_OC_SetPolarity<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Polarity: UInt32) {
    if (registers.instance == .lptim4) || (registers.instance == .lptim5) {
        registers.write(
            LPTIMRegister.cfgr,
            value: (registers.read(LPTIMRegister.cfgr) & ~(0x200000)) | (((Polarity >> 0x2) << 0x15)))
    } else {
        registers.write(
            LPTIMRegister.ccmr1,
            value: (registers.read(LPTIMRegister.ccmr1) & ~((0xc << LL_LPTIM_SHIFT_TAB_CCxP[Int(Channel)])))
                | ((Polarity << LL_LPTIM_SHIFT_TAB_CCxP[Int(Channel)])))
    }
}

public func LL_LPTIM_OC_GetPolarity<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    if (registers.instance == .lptim4) || (registers.instance == .lptim5) {
        return (((registers.read(LPTIMRegister.cfgr) & (0x200000)) >> 0x15) << 0x2)
    } else {
        return
            ((registers.read(LPTIMRegister.ccmr1) & (0xc << LL_LPTIM_SHIFT_TAB_CCxP[Int(Channel)]))
            >> LL_LPTIM_SHIFT_TAB_CCxP[Int(Channel)])
    }
}

public func LL_LPTIM_SetPrescaler<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(LPTIMRegister.cfgr, value: (registers.read(LPTIMRegister.cfgr) & ~(0xe00)) | (Prescaler))
}

public func LL_LPTIM_GetPrescaler<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0xe00)))
}

public func LL_LPTIM_SetInput1Src<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Src: UInt32) {
    registers.write(LPTIMRegister.cfgr2, value: (registers.read(LPTIMRegister.cfgr2) & ~(0x3)) | (Src))
}

public func LL_LPTIM_SetInput2Src<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Src: UInt32) {
    registers.write(LPTIMRegister.cfgr2, value: (registers.read(LPTIMRegister.cfgr2) & ~(0x30)) | (Src))
}

public func LL_LPTIM_SetRemap<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Src: UInt32) {
    registers.write(LPTIMRegister.cfgr2, value: (registers.read(LPTIMRegister.cfgr2) & ~(0x30000 | 0x300000)) | (Src))
}

public func LL_LPTIM_IC_SetPolarity<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Polarity: UInt32) {
    registers.write(
        LPTIMRegister.ccmr1,
        value: (registers.read(LPTIMRegister.ccmr1) & ~(0xc << LL_LPTIM_SHIFT_TAB_CCxP[Int(Channel)]))
            | (Polarity << LL_LPTIM_SHIFT_TAB_CCxP[Int(Channel)]))
}

public func LL_LPTIM_IC_GetPolarity<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    return
        (((registers.read(LPTIMRegister.ccmr1) & (0xc << LL_LPTIM_SHIFT_TAB_CCxP[Int(Channel)])))
        >> LL_LPTIM_SHIFT_TAB_CCxP[Int(Channel)])
}

public func LL_LPTIM_IC_SetFilter<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Filter: UInt32) {
    registers.write(
        LPTIMRegister.ccmr1,
        value: (registers.read(LPTIMRegister.ccmr1) & ~(0x3000 << LL_LPTIM_SHIFT_TAB_ICxF[Int(Channel)]))
            | (Filter << LL_LPTIM_SHIFT_TAB_ICxF[Int(Channel)]))
}

public func LL_LPTIM_IC_GetFilter<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    return
        (((registers.read(LPTIMRegister.ccmr1) & (0x3000 << LL_LPTIM_SHIFT_TAB_ICxF[Int(Channel)])))
        >> LL_LPTIM_SHIFT_TAB_ICxF[Int(Channel)])
}

public func LL_LPTIM_IC_SetPrescaler<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Prescaler: UInt32)
{
    registers.write(
        LPTIMRegister.ccmr1,
        value: (registers.read(LPTIMRegister.ccmr1) & ~(0x300 << LL_LPTIM_SHIFT_TAB_ICxPSC[Int(Channel)]))
            | (Prescaler << LL_LPTIM_SHIFT_TAB_ICxPSC[Int(Channel)]))
}

public func LL_LPTIM_IC_GetPrescaler<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    return
        (((registers.read(LPTIMRegister.ccmr1) & (0x300 << LL_LPTIM_SHIFT_TAB_ICxPSC[Int(Channel)])))
        >> LL_LPTIM_SHIFT_TAB_ICxPSC[Int(Channel)])
}

public func LL_LPTIM_CC_SetChannelMode<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ CCMode: UInt32)
{
    registers.write(
        LPTIMRegister.ccmr1,
        value: registers.read(LPTIMRegister.ccmr1) | (CCMode << LL_LPTIM_SHIFT_TAB_CCxSEL[Int(Channel)]))
}

public func LL_LPTIM_CC_GetChannelMode<IO: LPTIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    return
        (((registers.read(LPTIMRegister.ccmr1) & (0x1 << LL_LPTIM_SHIFT_TAB_CCxSEL[Int(Channel)])))
        >> LL_LPTIM_SHIFT_TAB_CCxSEL[Int(Channel)])
}

public func LL_LPTIM_IC_GetCaptureCH1<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.ccr1) & (0xffff)))
}

public func LL_LPTIM_IC_GetCaptureCH2<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.ccr2) & (0xffff)))
}

public func LL_LPTIM_EnableTimeout<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cfgr, value: registers.read(LPTIMRegister.cfgr) | (0x80000))
}

public func LL_LPTIM_DisableTimeout<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cfgr, value: registers.read(LPTIMRegister.cfgr) & ~(0x80000))
}

public func LL_LPTIM_IsEnabledTimeout<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.cfgr) & (0x80000)) == 0x80000) ? 1 : 0))
}

public func LL_LPTIM_TrigSw<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cfgr, value: registers.read(LPTIMRegister.cfgr) & ~(0x60000))
}

public func LL_LPTIM_ConfigTrigger<IO: LPTIMRegisterIO>(
    _ registers: inout IO, _ Source: UInt32, _ Filter: UInt32, _ Polarity: UInt32
) {
    registers.write(
        LPTIMRegister.cfgr,
        value: (registers.read(LPTIMRegister.cfgr) & ~(0xe000 | 0xc0 | 0x60000)) | (Source | Filter | Polarity))
}

public func LL_LPTIM_GetTriggerSource<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0xe000)))
}

public func LL_LPTIM_GetTriggerFilter<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0xc0)))
}

public func LL_LPTIM_GetTriggerPolarity<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0x60000)))
}

public func LL_LPTIM_SetClockSource<IO: LPTIMRegisterIO>(_ registers: inout IO, _ ClockSource: UInt32) {
    registers.write(LPTIMRegister.cfgr, value: (registers.read(LPTIMRegister.cfgr) & ~(0x1)) | (ClockSource))
}

public func LL_LPTIM_GetClockSource<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0x1)))
}

public func LL_LPTIM_ConfigClock<IO: LPTIMRegisterIO>(
    _ registers: inout IO, _ ClockFilter: UInt32, _ ClockPolarity: UInt32
) {
    registers.write(
        LPTIMRegister.cfgr, value: (registers.read(LPTIMRegister.cfgr) & ~(0x18 | 0x6)) | (ClockFilter | ClockPolarity))
}

public func LL_LPTIM_GetClockPolarity<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0x6)))
}

public func LL_LPTIM_GetClockFilter<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0x18)))
}

public func LL_LPTIM_SetEncoderMode<IO: LPTIMRegisterIO>(_ registers: inout IO, _ EncoderMode: UInt32) {
    registers.write(LPTIMRegister.cfgr, value: (registers.read(LPTIMRegister.cfgr) & ~(0x6)) | (EncoderMode))
}

public func LL_LPTIM_GetEncoderMode<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LPTIMRegister.cfgr) & (0x6)))
}

public func LL_LPTIM_EnableEncoderMode<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cfgr, value: registers.read(LPTIMRegister.cfgr) | (0x1000000))
}

public func LL_LPTIM_DisableEncoderMode<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.cfgr, value: registers.read(LPTIMRegister.cfgr) & ~(0x1000000))
}

public func LL_LPTIM_IsEnabledEncoderMode<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.cfgr) & (0x1000000)) == 0x1000000) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x1))
}

public func LL_LPTIM_IsActiveFlag_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x1)) == 0x1) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x200))
}

public func LL_LPTIM_IsActiveFlag_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x200)) == 0x200) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_CC1O<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x1000))
}

public func LL_LPTIM_IsActiveFlag_CC1O<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x1000)) == 0x1000) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_CC2O<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x2000))
}

public func LL_LPTIM_IsActiveFlag_CC2O<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x2000)) == 0x2000) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_ARRM<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x2))
}

public func LL_LPTIM_IsActiveFlag_ARRM<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x2)) == 0x2) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_EXTTRIG<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x4))
}

public func LL_LPTIM_IsActiveFlag_EXTTRIG<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x4)) == 0x4) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_CMP1OK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x8))
}

public func LL_LPTIM_IsActiveFlag_CMP1OK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x8)) == 0x8) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_CMP2OK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x80000))
}

public func LL_LPTIM_IsActiveFlag_CMP2OK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x80000)) == 0x80000) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_DIEROK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x1000000))
}

public func LL_LPTIM_IsActiveFlag_DIEROK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.isr) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_LPTIM_ClearFlag_ARROK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x10))
}

public func LL_LPTIM_IsActiveFlag_ARROK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x10)) == 0x10) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_UP<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x20))
}

public func LL_LPTIM_IsActiveFlag_UP<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x20)) == 0x20) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_DOWN<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x40))
}

public func LL_LPTIM_IsActiveFlag_DOWN<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.isr) & (0x40)) == 0x40) ? 1 : 0))
}

public func LL_LPTIM_ClearFlag_REPOK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x100))
}

public func LL_LPTIM_IsActiveFlag_REPOK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.isr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_LPTIM_ClearFlag_UE<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.icr, value: registers.read(LPTIMRegister.icr) | (0x80))
}

public func LL_LPTIM_IsActiveFlag_UE<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.isr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_LPTIM_EnableIT_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x1))
}

public func LL_LPTIM_DisableIT_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x1))
}

public func LL_LPTIM_IsEnabledIT_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x1)) == 0x1) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x200))
}

public func LL_LPTIM_DisableIT_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x200))
}

public func LL_LPTIM_IsEnabledIT_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x200)) == 0x200) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_CC1O<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x1000))
}

public func LL_LPTIM_DisableIT_CC1O<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x1000))
}

public func LL_LPTIM_IsEnabledIT_CC1O<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x1000)) == 0x1000) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_CC2O<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x2000))
}

public func LL_LPTIM_DisableIT_CC2O<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x2000))
}

public func LL_LPTIM_IsEnabledIT_CC2O<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x2000)) == 0x2000) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_ARRM<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x2))
}

public func LL_LPTIM_DisableIT_ARRM<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x2))
}

public func LL_LPTIM_IsEnabledIT_ARRM<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x2)) == 0x2) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_EXTTRIG<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x4))
}

public func LL_LPTIM_DisableIT_EXTTRIG<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x4))
}

public func LL_LPTIM_IsEnabledIT_EXTTRIG<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x4)) == 0x4) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_CMP1OK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x8))
}

public func LL_LPTIM_DisableIT_CMP1OK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x8))
}

public func LL_LPTIM_IsEnabledIT_CMP1OK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x8)) == 0x8) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_CMP2OK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x80000))
}

public func LL_LPTIM_DisableIT_CMP2OK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x80000))
}

public func LL_LPTIM_IsEnabledIT_CMP2OK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x80000)) == 0x80000) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_ARROK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x10))
}

public func LL_LPTIM_DisableIT_ARROK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x10))
}

public func LL_LPTIM_IsEnabledIT_ARROK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x10)) == 0x10) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_UP<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x20))
}

public func LL_LPTIM_DisableIT_UP<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x20))
}

public func LL_LPTIM_IsEnabledIT_UP<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((((registers.read(LPTIMRegister.dier) & (0x20)) == 0x20) ? 1 : 0))
}

public func LL_LPTIM_EnableIT_DOWN<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x40))
}

public func LL_LPTIM_DisableIT_DOWN<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x40))
}

public func LL_LPTIM_IsEnabledIT_DOWN<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.dier) & (0x40)) == 0x40) ? 1 : 0)
}

public func LL_LPTIM_EnableIT_REPOK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x100))
}

public func LL_LPTIM_DisableIT_REPOK<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x100))
}

public func LL_LPTIM_IsEnabledIT_REPOK<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.dier) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_LPTIM_EnableIT_UE<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x80))
}

public func LL_LPTIM_DisableIT_UE<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x80))
}

public func LL_LPTIM_IsEnabledIT_UE<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.dier) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_LPTIM_EnableDMAReq_UPDATE<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x800000))
}

public func LL_LPTIM_DisableDMAReq_UPDATE<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x800000))
}

public func LL_LPTIM_IsEnabledDMAReq_UPDATE<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.dier) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_LPTIM_EnableDMAReq_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x10000))
}

public func LL_LPTIM_DisableDMAReq_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x10000))
}

public func LL_LPTIM_IsEnabledDMAReq_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.dier) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_LPTIM_EnableDMAReq_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) | (0x2000000))
}

public func LL_LPTIM_DisableDMAReq_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    registers.write(LPTIMRegister.dier, value: registers.read(LPTIMRegister.dier) & ~(0x2000000))
}

public func LL_LPTIM_IsEnabledDMAReq_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LPTIMRegister.dier) & (0x2000000)) == (0x2000000)) ? 1 : 0)
}

public func LL_LPTIM_DeInit<IO: LPTIMRegisterIO & LLBusRegisterIO>(_ registers: inout IO, isKnownInstance: Bool = true)
    -> LLErrorStatus
{
    if !isKnownInstance { return .error }
    var result: UInt32 = LLErrorStatus.success.rawValue

    if registers.instance == .lptim1 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_LPTIM1)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_LPTIM1)
    } else if registers.instance == .lptim2 {
        LL_APB4_GRP1_ForceReset(&registers, LL_APB4_GRP1_PERIPH_LPTIM2)
        LL_APB4_GRP1_ReleaseReset(&registers, LL_APB4_GRP1_PERIPH_LPTIM2)
    } else if registers.instance == .lptim3 {
        LL_APB4_GRP1_ForceReset(&registers, LL_APB4_GRP1_PERIPH_LPTIM3)
        LL_APB4_GRP1_ReleaseReset(&registers, LL_APB4_GRP1_PERIPH_LPTIM3)
    } else if registers.instance == .lptim4 {
        LL_APB4_GRP1_ForceReset(&registers, LL_APB4_GRP1_PERIPH_LPTIM4)
        LL_APB4_GRP1_ReleaseReset(&registers, LL_APB4_GRP1_PERIPH_LPTIM4)
    } else if registers.instance == .lptim5 {
        LL_APB4_GRP1_ForceReset(&registers, LL_APB4_GRP1_PERIPH_LPTIM5)
        LL_APB4_GRP1_ReleaseReset(&registers, LL_APB4_GRP1_PERIPH_LPTIM5)
    } else {
        result = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: result)!
}

public func LL_LPTIM_StructInit(_ LPTIM_InitStruct: inout LL_LPTIM_InitTypeDef) {
    LPTIM_InitStruct.ClockSource = LL_LPTIM_CLK_SOURCE_INTERNAL
    LPTIM_InitStruct.Prescaler = LL_LPTIM_PRESCALER_DIV1
    LPTIM_InitStruct.Waveform = LL_LPTIM_OUTPUT_WAVEFORM_PWM
}

public func LL_LPTIM_Init<IO: LPTIMRegisterIO>(_ registers: inout IO, _ LPTIM_InitStruct: LL_LPTIM_InitTypeDef)
    -> LLErrorStatus
{
    var result: UInt32 = LLErrorStatus.success.rawValue

    if LL_LPTIM_IsEnabled(&registers) == 1 {
        result = LLErrorStatus.error.rawValue
    } else {

        registers.write(
            LPTIMRegister.cfgr,
            value: (registers.read(LPTIMRegister.cfgr) & ~((0x1 | 0xe00 | 0x100000)))
                | (LPTIM_InitStruct.ClockSource | LPTIM_InitStruct.Prescaler | LPTIM_InitStruct.Waveform))
    }
    return LLErrorStatus(rawValue: result)!
}
