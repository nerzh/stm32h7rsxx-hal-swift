// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_TIM_SR_UIF: UInt32 = 0x0000_0001
public let LL_TIM_SR_CC1IF: UInt32 = 0x0000_0002
public let LL_TIM_SR_CC2IF: UInt32 = 0x0000_0004
public let LL_TIM_SR_CC3IF: UInt32 = 0x0000_0008
public let LL_TIM_SR_CC4IF: UInt32 = 0x0000_0010
public let LL_TIM_SR_CC5IF: UInt32 = 0x0001_0000
public let LL_TIM_SR_CC6IF: UInt32 = 0x0002_0000
public let LL_TIM_SR_COMIF: UInt32 = 0x0000_0020
public let LL_TIM_SR_TIF: UInt32 = 0x0000_0040
public let LL_TIM_SR_BIF: UInt32 = 0x0000_0080
public let LL_TIM_SR_B2IF: UInt32 = 0x0000_0100
public let LL_TIM_SR_CC1OF: UInt32 = 0x0000_0200
public let LL_TIM_SR_CC2OF: UInt32 = 0x0000_0400
public let LL_TIM_SR_CC3OF: UInt32 = 0x0000_0800
public let LL_TIM_SR_CC4OF: UInt32 = 0x0000_1000
public let LL_TIM_SR_SBIF: UInt32 = 0x0000_2000
public let LL_TIM_SR_IDXF: UInt32 = 0x0010_0000
public let LL_TIM_SR_DIRF: UInt32 = 0x0020_0000
public let LL_TIM_SR_IERRF: UInt32 = 0x0040_0000
public let LL_TIM_SR_TERRF: UInt32 = 0x0080_0000
public let LL_TIM_BREAK_DISABLE: UInt32 = 0x0000_0000
public let LL_TIM_BREAK_ENABLE: UInt32 = 0x0000_1000
public let LL_TIM_BREAK2_DISABLE: UInt32 = 0x0000_0000
public let LL_TIM_BREAK2_ENABLE: UInt32 = 0x0100_0000
public let LL_TIM_AUTOMATICOUTPUT_DISABLE: UInt32 = 0x0000_0000
public let LL_TIM_AUTOMATICOUTPUT_ENABLE: UInt32 = 0x0000_4000
public let LL_TIM_DIER_UIE: UInt32 = 0x0000_0001
public let LL_TIM_DIER_CC1IE: UInt32 = 0x0000_0002
public let LL_TIM_DIER_CC2IE: UInt32 = 0x0000_0004
public let LL_TIM_DIER_CC3IE: UInt32 = 0x0000_0008
public let LL_TIM_DIER_CC4IE: UInt32 = 0x0000_0010
public let LL_TIM_DIER_COMIE: UInt32 = 0x0000_0020
public let LL_TIM_DIER_TIE: UInt32 = 0x0000_0040
public let LL_TIM_DIER_BIE: UInt32 = 0x0000_0080
public let LL_TIM_DIER_IDXIE: UInt32 = 0x0010_0000
public let LL_TIM_DIER_DIRIE: UInt32 = 0x0020_0000
public let LL_TIM_DIER_IERRIE: UInt32 = 0x0040_0000
public let LL_TIM_DIER_TERRIE: UInt32 = 0x0080_0000
public let LL_TIM_UPDATESOURCE_REGULAR: UInt32 = 0x0000_0000
public let LL_TIM_UPDATESOURCE_COUNTER: UInt32 = 0x0000_0004
public let LL_TIM_ONEPULSEMODE_SINGLE: UInt32 = 0x0000_0008
public let LL_TIM_ONEPULSEMODE_REPETITIVE: UInt32 = 0x0000_0000
public let LL_TIM_COUNTERMODE_UP: UInt32 = 0x0000_0000
public let LL_TIM_COUNTERMODE_DOWN: UInt32 = 0x0000_0010
public let LL_TIM_COUNTERMODE_CENTER_DOWN: UInt32 = 0x0000_0020
public let LL_TIM_COUNTERMODE_CENTER_UP: UInt32 = 0x0000_0040
public let LL_TIM_COUNTERMODE_CENTER_UP_DOWN: UInt32 = 0x0000_0060
public let LL_TIM_CLOCKDIVISION_DIV1: UInt32 = 0x0000_0000
public let LL_TIM_CLOCKDIVISION_DIV2: UInt32 = 0x0000_0100
public let LL_TIM_CLOCKDIVISION_DIV4: UInt32 = 0x0000_0200
public let LL_TIM_COUNTERDIRECTION_UP: UInt32 = 0x0000_0000
public let LL_TIM_COUNTERDIRECTION_DOWN: UInt32 = 0x0000_0010
public let LL_TIM_CCUPDATESOURCE_COMG_ONLY: UInt32 = 0x0000_0000
public let LL_TIM_CCUPDATESOURCE_COMG_AND_TRGI: UInt32 = 0x0000_0004
public let LL_TIM_CCDMAREQUEST_CC: UInt32 = 0x0000_0000
public let LL_TIM_CCDMAREQUEST_UPDATE: UInt32 = 0x0000_0008
public let LL_TIM_LOCKLEVEL_OFF: UInt32 = 0x0000_0000
public let LL_TIM_LOCKLEVEL_1: UInt32 = 0x0000_0100
public let LL_TIM_LOCKLEVEL_2: UInt32 = 0x0000_0200
public let LL_TIM_LOCKLEVEL_3: UInt32 = 0x0000_0300
public let LL_TIM_CHANNEL_CH1: UInt32 = 0x0000_0001
public let LL_TIM_CHANNEL_CH1N: UInt32 = 0x0000_0004
public let LL_TIM_CHANNEL_CH2: UInt32 = 0x0000_0010
public let LL_TIM_CHANNEL_CH2N: UInt32 = 0x0000_0040
public let LL_TIM_CHANNEL_CH3: UInt32 = 0x0000_0100
public let LL_TIM_CHANNEL_CH3N: UInt32 = 0x0000_0400
public let LL_TIM_CHANNEL_CH4: UInt32 = 0x0000_1000
public let LL_TIM_CHANNEL_CH4N: UInt32 = 0x0000_4000
public let LL_TIM_CHANNEL_CH5: UInt32 = 0x0001_0000
public let LL_TIM_CHANNEL_CH6: UInt32 = 0x0010_0000
public let LL_TIM_OCSTATE_DISABLE: UInt32 = 0x0000_0000
public let LL_TIM_OCSTATE_ENABLE: UInt32 = 0x0000_0001
public let LL_TIM_OCMODE_ASSYMETRIC_PWM1: UInt32 = 0x0001_0060
public let LL_TIM_OCMODE_ASSYMETRIC_PWM2: UInt32 = 0x0001_0070
public let LL_TIM_OCMODE_FROZEN: UInt32 = 0x0000_0000
public let LL_TIM_OCMODE_ACTIVE: UInt32 = 0x0000_0010
public let LL_TIM_OCMODE_INACTIVE: UInt32 = 0x0000_0020
public let LL_TIM_OCMODE_TOGGLE: UInt32 = 0x0000_0030
public let LL_TIM_OCMODE_FORCED_INACTIVE: UInt32 = 0x0000_0040
public let LL_TIM_OCMODE_FORCED_ACTIVE: UInt32 = 0x0000_0050
public let LL_TIM_OCMODE_PWM1: UInt32 = 0x0000_0060
public let LL_TIM_OCMODE_PWM2: UInt32 = 0x0000_0070
public let LL_TIM_OCMODE_RETRIG_OPM1: UInt32 = 0x0001_0000
public let LL_TIM_OCMODE_RETRIG_OPM2: UInt32 = 0x0001_0010
public let LL_TIM_OCMODE_COMBINED_PWM1: UInt32 = 0x0001_0040
public let LL_TIM_OCMODE_COMBINED_PWM2: UInt32 = 0x0001_0050
public let LL_TIM_OCMODE_ASYMMETRIC_PWM1: UInt32 = 0x0001_0060
public let LL_TIM_OCMODE_ASYMMETRIC_PWM2: UInt32 = 0x0001_0070
public let LL_TIM_OCMODE_PULSE_ON_COMPARE: UInt32 = 0x0001_0020
public let LL_TIM_OCMODE_DIRECTION_OUTPUT: UInt32 = 0x0001_0030
public let LL_TIM_OCPOLARITY_HIGH: UInt32 = 0x0000_0000
public let LL_TIM_OCPOLARITY_LOW: UInt32 = 0x0000_0002
public let LL_TIM_OCIDLESTATE_LOW: UInt32 = 0x0000_0000
public let LL_TIM_OCIDLESTATE_HIGH: UInt32 = 0x0000_0100
public let LL_TIM_GROUPCH5_NONE: UInt32 = 0x0000_0000
public let LL_TIM_GROUPCH5_OC1REFC: UInt32 = 0x2000_0000
public let LL_TIM_GROUPCH5_OC2REFC: UInt32 = 0x4000_0000
public let LL_TIM_GROUPCH5_OC3REFC: UInt32 = 0x8000_0000
public let LL_TIM_ACTIVEINPUT_DIRECTTI: UInt32 = 0x0001_0000
public let LL_TIM_ACTIVEINPUT_INDIRECTTI: UInt32 = 0x0002_0000
public let LL_TIM_ACTIVEINPUT_TRC: UInt32 = 0x0003_0000
public let LL_TIM_ICPSC_DIV1: UInt32 = 0x0000_0000
public let LL_TIM_ICPSC_DIV2: UInt32 = 0x0004_0000
public let LL_TIM_ICPSC_DIV4: UInt32 = 0x0008_0000
public let LL_TIM_ICPSC_DIV8: UInt32 = 0x000C_0000
public let LL_TIM_IC_FILTER_FDIV1: UInt32 = 0x0000_0000
public let LL_TIM_IC_FILTER_FDIV1_N2: UInt32 = 0x0010_0000
public let LL_TIM_IC_FILTER_FDIV1_N4: UInt32 = 0x0020_0000
public let LL_TIM_IC_FILTER_FDIV1_N8: UInt32 = 0x0030_0000
public let LL_TIM_IC_FILTER_FDIV2_N6: UInt32 = 0x0040_0000
public let LL_TIM_IC_FILTER_FDIV2_N8: UInt32 = 0x0050_0000
public let LL_TIM_IC_FILTER_FDIV4_N6: UInt32 = 0x0060_0000
public let LL_TIM_IC_FILTER_FDIV4_N8: UInt32 = 0x0070_0000
public let LL_TIM_IC_FILTER_FDIV8_N6: UInt32 = 0x0080_0000
public let LL_TIM_IC_FILTER_FDIV8_N8: UInt32 = 0x0090_0000
public let LL_TIM_IC_FILTER_FDIV16_N5: UInt32 = 0x00A0_0000
public let LL_TIM_IC_FILTER_FDIV16_N6: UInt32 = 0x00B0_0000
public let LL_TIM_IC_FILTER_FDIV16_N8: UInt32 = 0x00C0_0000
public let LL_TIM_IC_FILTER_FDIV32_N5: UInt32 = 0x00D0_0000
public let LL_TIM_IC_FILTER_FDIV32_N6: UInt32 = 0x00E0_0000
public let LL_TIM_IC_FILTER_FDIV32_N8: UInt32 = 0x00F0_0000
public let LL_TIM_IC_POLARITY_RISING: UInt32 = 0x0000_0000
public let LL_TIM_IC_POLARITY_FALLING: UInt32 = 0x0000_0002
public let LL_TIM_IC_POLARITY_BOTHEDGE: UInt32 = 0x0000_000A
public let LL_TIM_CLOCKSOURCE_INTERNAL: UInt32 = 0x0000_0000
public let LL_TIM_CLOCKSOURCE_EXT_MODE1: UInt32 = 0x0000_0007
public let LL_TIM_CLOCKSOURCE_EXT_MODE2: UInt32 = 0x0000_4000
public let LL_TIM_ENCODERMODE_X2_TI1: UInt32 = 0x0000_0001
public let LL_TIM_ENCODERMODE_X2_TI2: UInt32 = 0x0000_0002
public let LL_TIM_ENCODERMODE_X4_TI12: UInt32 = 0x0000_0003
public let LL_TIM_ENCODERMODE_CLOCKPLUSDIRECTION_X2: UInt32 = 0x0001_0002
public let LL_TIM_ENCODERMODE_CLOCKPLUSDIRECTION_X1: UInt32 = 0x0001_0003
public let LL_TIM_ENCODERMODE_DIRECTIONALCLOCK_X2: UInt32 = 0x0001_0004
public let LL_TIM_ENCODERMODE_DIRECTIONALCLOCK_X1_TI12: UInt32 = 0x0001_0005
public let LL_TIM_ENCODERMODE_X1_TI1: UInt32 = 0x0001_0006
public let LL_TIM_ENCODERMODE_X1_TI2: UInt32 = 0x0001_0007
public let LL_TIM_TRGO_RESET: UInt32 = 0x0000_0000
public let LL_TIM_TRGO_ENABLE: UInt32 = 0x0000_0010
public let LL_TIM_TRGO_UPDATE: UInt32 = 0x0000_0020
public let LL_TIM_TRGO_CC1IF: UInt32 = 0x0000_0030
public let LL_TIM_TRGO_OC1REF: UInt32 = 0x0000_0040
public let LL_TIM_TRGO_OC2REF: UInt32 = 0x0000_0050
public let LL_TIM_TRGO_OC3REF: UInt32 = 0x0000_0060
public let LL_TIM_TRGO_OC4REF: UInt32 = 0x0000_0070
public let LL_TIM_TRGO_ENCODERCLK: UInt32 = 0x0200_0000
public let LL_TIM_TRGO2_RESET: UInt32 = 0x0000_0000
public let LL_TIM_TRGO2_ENABLE: UInt32 = 0x0010_0000
public let LL_TIM_TRGO2_UPDATE: UInt32 = 0x0020_0000
public let LL_TIM_TRGO2_CC1F: UInt32 = 0x0030_0000
public let LL_TIM_TRGO2_OC1: UInt32 = 0x0040_0000
public let LL_TIM_TRGO2_OC2: UInt32 = 0x0050_0000
public let LL_TIM_TRGO2_OC3: UInt32 = 0x0060_0000
public let LL_TIM_TRGO2_OC4: UInt32 = 0x0070_0000
public let LL_TIM_TRGO2_OC5: UInt32 = 0x0080_0000
public let LL_TIM_TRGO2_OC6: UInt32 = 0x0090_0000
public let LL_TIM_TRGO2_OC4_RISINGFALLING: UInt32 = 0x00A0_0000
public let LL_TIM_TRGO2_OC6_RISINGFALLING: UInt32 = 0x00B0_0000
public let LL_TIM_TRGO2_OC4_RISING_OC6_RISING: UInt32 = 0x00C0_0000
public let LL_TIM_TRGO2_OC4_RISING_OC6_FALLING: UInt32 = 0x00D0_0000
public let LL_TIM_TRGO2_OC5_RISING_OC6_RISING: UInt32 = 0x00E0_0000
public let LL_TIM_TRGO2_OC5_RISING_OC6_FALLING: UInt32 = 0x00F0_0000
public let LL_TIM_SLAVEMODE_DISABLED: UInt32 = 0x0000_0000
public let LL_TIM_SLAVEMODE_RESET: UInt32 = 0x0000_0004
public let LL_TIM_SLAVEMODE_GATED: UInt32 = 0x0000_0005
public let LL_TIM_SLAVEMODE_TRIGGER: UInt32 = 0x0000_0006
public let LL_TIM_SLAVEMODE_COMBINED_RESETTRIGGER: UInt32 = 0x0001_0000
public let LL_TIM_SLAVEMODE_COMBINED_GATEDRESET: UInt32 = 0x0001_0001
public let LL_TIM_SMSPS_TIMUPDATE: UInt32 = 0x0000_0000
public let LL_TIM_SMSPS_INDEX: UInt32 = 0x0200_0000
public let LL_TIM_TS_ITR0: UInt32 = 0x0000_0000
public let LL_TIM_TS_ITR1: UInt32 = 0x0000_0010
public let LL_TIM_TS_ITR2: UInt32 = 0x0000_0020
public let LL_TIM_TS_ITR3: UInt32 = 0x0000_0030
public let LL_TIM_TS_ITR4: UInt32 = 0x0010_0000
public let LL_TIM_TS_ITR5: UInt32 = 0x0010_0010
public let LL_TIM_TS_ITR6: UInt32 = 0x0010_0020
public let LL_TIM_TS_ITR7: UInt32 = 0x0010_0030
public let LL_TIM_TS_ITR8: UInt32 = 0x0010_0040
public let LL_TIM_TS_ITR9: UInt32 = 0x0010_0050
public let LL_TIM_TS_ITR10: UInt32 = 0x0010_0060
public let LL_TIM_TS_ITR11: UInt32 = 0x0010_0070
public let LL_TIM_TS_ITR12: UInt32 = 0x0020_0000
public let LL_TIM_TS_ITR13: UInt32 = 0x0020_0010
public let LL_TIM_TS_ITR14: UInt32 = 0x0020_0020
public let LL_TIM_TS_TI1F_ED: UInt32 = 0x0000_0040
public let LL_TIM_TS_TI1FP1: UInt32 = 0x0000_0050
public let LL_TIM_TS_TI2FP2: UInt32 = 0x0000_0060
public let LL_TIM_TS_ETRF: UInt32 = 0x0000_0070
public let LL_TIM_ETR_POLARITY_NONINVERTED: UInt32 = 0x0000_0000
public let LL_TIM_ETR_POLARITY_INVERTED: UInt32 = 0x0000_8000
public let LL_TIM_ETR_PRESCALER_DIV1: UInt32 = 0x0000_0000
public let LL_TIM_ETR_PRESCALER_DIV2: UInt32 = 0x0000_1000
public let LL_TIM_ETR_PRESCALER_DIV4: UInt32 = 0x0000_2000
public let LL_TIM_ETR_PRESCALER_DIV8: UInt32 = 0x0000_3000
public let LL_TIM_ETR_FILTER_FDIV1: UInt32 = 0x0000_0000
public let LL_TIM_ETR_FILTER_FDIV1_N2: UInt32 = 0x0000_0100
public let LL_TIM_ETR_FILTER_FDIV1_N4: UInt32 = 0x0000_0200
public let LL_TIM_ETR_FILTER_FDIV1_N8: UInt32 = 0x0000_0300
public let LL_TIM_ETR_FILTER_FDIV2_N6: UInt32 = 0x0000_0400
public let LL_TIM_ETR_FILTER_FDIV2_N8: UInt32 = 0x0000_0500
public let LL_TIM_ETR_FILTER_FDIV4_N6: UInt32 = 0x0000_0600
public let LL_TIM_ETR_FILTER_FDIV4_N8: UInt32 = 0x0000_0700
public let LL_TIM_ETR_FILTER_FDIV8_N6: UInt32 = 0x0000_0800
public let LL_TIM_ETR_FILTER_FDIV8_N8: UInt32 = 0x0000_0900
public let LL_TIM_ETR_FILTER_FDIV16_N5: UInt32 = 0x0000_0A00
public let LL_TIM_ETR_FILTER_FDIV16_N6: UInt32 = 0x0000_0B00
public let LL_TIM_ETR_FILTER_FDIV16_N8: UInt32 = 0x0000_0C00
public let LL_TIM_ETR_FILTER_FDIV32_N5: UInt32 = 0x0000_0D00
public let LL_TIM_ETR_FILTER_FDIV32_N6: UInt32 = 0x0000_0E00
public let LL_TIM_ETR_FILTER_FDIV32_N8: UInt32 = 0x0000_0F00
public let LL_TIM_TIM1_ETRSOURCE_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM1_ETRSOURCE_ADC1_AWD1: UInt32 = 0x0000_C000
public let LL_TIM_TIM1_ETRSOURCE_ADC1_AWD2: UInt32 = 0x0001_0000
public let LL_TIM_TIM1_ETRSOURCE_ADC1_AWD3: UInt32 = 0x0001_4000
public let LL_TIM_TIM1_ETRSOURCE_ADC2_AWD1: UInt32 = 0x0001_8000
public let LL_TIM_TIM1_ETRSOURCE_ADC2_AWD2: UInt32 = 0x0001_C000
public let LL_TIM_TIM1_ETRSOURCE_ADC2_AWD3: UInt32 = 0x0002_0000
public let LL_TIM_TIM2_ETRSOURCE_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM2_ETRSOURCE_DCMIPP_HSYNC: UInt32 = 0x0000_4000
public let LL_TIM_TIM2_ETRSOURCE_LTDC_HSYNC: UInt32 = 0x0000_8000
public let LL_TIM_TIM2_ETRSOURCE_SAI1_FSA: UInt32 = 0x0001_0000
public let LL_TIM_TIM2_ETRSOURCE_SAI1_FSB: UInt32 = 0x0001_4000
public let LL_TIM_TIM2_ETRSOURCE_GFXTIM_TE: UInt32 = 0x0001_8000
public let LL_TIM_TIM2_ETRSOURCE_DCMIPP_VSYNC: UInt32 = 0x0001_C000
public let LL_TIM_TIM2_ETRSOURCE_LTDC_VSYNC: UInt32 = 0x0002_0000
public let LL_TIM_TIM2_ETRSOURCE_TIM3_ETR: UInt32 = 0x0002_8000
public let LL_TIM_TIM2_ETRSOURCE_TIM4_ETR: UInt32 = 0x0002_C000
public let LL_TIM_TIM2_ETRSOURCE_TIM5_ETR: UInt32 = 0x0003_0000
public let LL_TIM_TIM2_ETRSOURCE_ETH_PPS: UInt32 = 0x0003_4000
public let LL_TIM_TIM3_ETRSOURCE_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM3_ETRSOURCE_DCMIPP_HSYNC: UInt32 = 0x0000_4000
public let LL_TIM_TIM3_ETRSOURCE_LTDC_HSYNC: UInt32 = 0x0000_8000
public let LL_TIM_TIM3_ETRSOURCE_GFXTIM_TE: UInt32 = 0x0001_8000
public let LL_TIM_TIM3_ETRSOURCE_DCMIPP_VSYNC: UInt32 = 0x0001_C000
public let LL_TIM_TIM3_ETRSOURCE_LTDC_VSYNC: UInt32 = 0x0002_0000
public let LL_TIM_TIM3_ETRSOURCE_TIM2_ETR: UInt32 = 0x0002_4000
public let LL_TIM_TIM3_ETRSOURCE_TIM4_ETR: UInt32 = 0x0002_C000
public let LL_TIM_TIM3_ETRSOURCE_TIM5_ETR: UInt32 = 0x0003_0000
public let LL_TIM_TIM3_ETRSOURCE_ETH_PPS: UInt32 = 0x0003_4000
public let LL_TIM_TIM4_ETRSOURCE_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM4_ETRSOURCE_DCMIPP_HSYNC: UInt32 = 0x0000_4000
public let LL_TIM_TIM4_ETRSOURCE_LTDC_HSYNC: UInt32 = 0x0000_8000
public let LL_TIM_TIM4_ETRSOURCE_GFXTIM_TE: UInt32 = 0x0001_8000
public let LL_TIM_TIM4_ETRSOURCE_DCMIPP_VSYNC: UInt32 = 0x0001_C000
public let LL_TIM_TIM4_ETRSOURCE_LTDC_VSYNC: UInt32 = 0x0002_0000
public let LL_TIM_TIM4_ETRSOURCE_TIM2_ETR: UInt32 = 0x0002_4000
public let LL_TIM_TIM4_ETRSOURCE_TIM3_ETR: UInt32 = 0x0002_8000
public let LL_TIM_TIM4_ETRSOURCE_TIM5_ETR: UInt32 = 0x0003_0000
public let LL_TIM_TIM5_ETRSOURCE_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM5_ETRSOURCE_SAI2_FSA: UInt32 = 0x0000_4000
public let LL_TIM_TIM5_ETRSOURCE_SAI2_FSB: UInt32 = 0x0000_8000
public let LL_TIM_TIM5_ETRSOURCE_DCMIPP_HSYNC: UInt32 = 0x0000_C000
public let LL_TIM_TIM5_ETRSOURCE_LTDC_HSYNC: UInt32 = 0x0001_0000
public let LL_TIM_TIM5_ETRSOURCE_GFXTIM_TE: UInt32 = 0x0001_8000
public let LL_TIM_TIM5_ETRSOURCE_DCMIPP_VSYNC: UInt32 = 0x0001_C000
public let LL_TIM_TIM5_ETRSOURCE_LTDC_VSYNC: UInt32 = 0x0002_0000
public let LL_TIM_TIM5_ETRSOURCE_TIM2_ETR: UInt32 = 0x0002_4000
public let LL_TIM_TIM5_ETRSOURCE_TIM3_ETR: UInt32 = 0x0002_8000
public let LL_TIM_TIM5_ETRSOURCE_TIM4_ETR: UInt32 = 0x0002_C000
public let LL_TIM_BREAK_POLARITY_LOW: UInt32 = 0x0000_0000
public let LL_TIM_BREAK_POLARITY_HIGH: UInt32 = 0x0000_2000
public let LL_TIM_BREAK_FILTER_FDIV1: UInt32 = 0x0000_0000
public let LL_TIM_BREAK_FILTER_FDIV1_N2: UInt32 = 0x0001_0000
public let LL_TIM_BREAK_FILTER_FDIV1_N4: UInt32 = 0x0002_0000
public let LL_TIM_BREAK_FILTER_FDIV1_N8: UInt32 = 0x0003_0000
public let LL_TIM_BREAK_FILTER_FDIV2_N6: UInt32 = 0x0004_0000
public let LL_TIM_BREAK_FILTER_FDIV2_N8: UInt32 = 0x0005_0000
public let LL_TIM_BREAK_FILTER_FDIV4_N6: UInt32 = 0x0006_0000
public let LL_TIM_BREAK_FILTER_FDIV4_N8: UInt32 = 0x0007_0000
public let LL_TIM_BREAK_FILTER_FDIV8_N6: UInt32 = 0x0008_0000
public let LL_TIM_BREAK_FILTER_FDIV8_N8: UInt32 = 0x0009_0000
public let LL_TIM_BREAK_FILTER_FDIV16_N5: UInt32 = 0x000A_0000
public let LL_TIM_BREAK_FILTER_FDIV16_N6: UInt32 = 0x000B_0000
public let LL_TIM_BREAK_FILTER_FDIV16_N8: UInt32 = 0x000C_0000
public let LL_TIM_BREAK_FILTER_FDIV32_N5: UInt32 = 0x000D_0000
public let LL_TIM_BREAK_FILTER_FDIV32_N6: UInt32 = 0x000E_0000
public let LL_TIM_BREAK_FILTER_FDIV32_N8: UInt32 = 0x000F_0000
public let LL_TIM_BREAK2_POLARITY_LOW: UInt32 = 0x0000_0000
public let LL_TIM_BREAK2_POLARITY_HIGH: UInt32 = 0x0200_0000
public let LL_TIM_BREAK2_FILTER_FDIV1: UInt32 = 0x0000_0000
public let LL_TIM_BREAK2_FILTER_FDIV1_N2: UInt32 = 0x0010_0000
public let LL_TIM_BREAK2_FILTER_FDIV1_N4: UInt32 = 0x0020_0000
public let LL_TIM_BREAK2_FILTER_FDIV1_N8: UInt32 = 0x0030_0000
public let LL_TIM_BREAK2_FILTER_FDIV2_N6: UInt32 = 0x0040_0000
public let LL_TIM_BREAK2_FILTER_FDIV2_N8: UInt32 = 0x0050_0000
public let LL_TIM_BREAK2_FILTER_FDIV4_N6: UInt32 = 0x0060_0000
public let LL_TIM_BREAK2_FILTER_FDIV4_N8: UInt32 = 0x0070_0000
public let LL_TIM_BREAK2_FILTER_FDIV8_N6: UInt32 = 0x0080_0000
public let LL_TIM_BREAK2_FILTER_FDIV8_N8: UInt32 = 0x0090_0000
public let LL_TIM_BREAK2_FILTER_FDIV16_N5: UInt32 = 0x00A0_0000
public let LL_TIM_BREAK2_FILTER_FDIV16_N6: UInt32 = 0x00B0_0000
public let LL_TIM_BREAK2_FILTER_FDIV16_N8: UInt32 = 0x00C0_0000
public let LL_TIM_BREAK2_FILTER_FDIV32_N5: UInt32 = 0x00D0_0000
public let LL_TIM_BREAK2_FILTER_FDIV32_N6: UInt32 = 0x00E0_0000
public let LL_TIM_BREAK2_FILTER_FDIV32_N8: UInt32 = 0x00F0_0000
public let LL_TIM_OSSI_DISABLE: UInt32 = 0x0000_0000
public let LL_TIM_OSSI_ENABLE: UInt32 = 0x0000_0400
public let LL_TIM_OSSR_DISABLE: UInt32 = 0x0000_0000
public let LL_TIM_OSSR_ENABLE: UInt32 = 0x0000_0800
public let LL_TIM_BREAK_INPUT_BKIN: UInt32 = 0x0000_0000
public let LL_TIM_BREAK_INPUT_BKIN2: UInt32 = 0x0000_0004
public let LL_TIM_BKIN_SOURCE_BKIN: UInt32 = 0x0000_0001
public let LL_TIM_BKIN_POLARITY_LOW: UInt32 = 0x0000_0200
public let LL_TIM_BKIN_POLARITY_HIGH: UInt32 = 0x0000_0000
public let LL_TIM_BREAK_AFMODE_INPUT: UInt32 = 0x0000_0000
public let LL_TIM_BREAK_AFMODE_BIDIRECTIONAL: UInt32 = 0x1000_0000
public let LL_TIM_BREAK2_AFMODE_INPUT: UInt32 = 0x0000_0000
public let LL_TIM_BREAK2_AFMODE_BIDIRECTIONAL: UInt32 = 0x2000_0000
public let LL_TIM_DMABURST_BASEADDR_CR1: UInt32 = 0x0000_0000
public let LL_TIM_DMABURST_BASEADDR_CR2: UInt32 = 0x0000_0001
public let LL_TIM_DMABURST_BASEADDR_SMCR: UInt32 = 0x0000_0002
public let LL_TIM_DMABURST_BASEADDR_DIER: UInt32 = 0x0000_0003
public let LL_TIM_DMABURST_BASEADDR_SR: UInt32 = 0x0000_0004
public let LL_TIM_DMABURST_BASEADDR_EGR: UInt32 = 0x0000_0005
public let LL_TIM_DMABURST_BASEADDR_CCMR1: UInt32 = 0x0000_0006
public let LL_TIM_DMABURST_BASEADDR_CCMR2: UInt32 = 0x0000_0007
public let LL_TIM_DMABURST_BASEADDR_CCER: UInt32 = 0x0000_0008
public let LL_TIM_DMABURST_BASEADDR_CNT: UInt32 = 0x0000_0009
public let LL_TIM_DMABURST_BASEADDR_PSC: UInt32 = 0x0000_000A
public let LL_TIM_DMABURST_BASEADDR_ARR: UInt32 = 0x0000_000B
public let LL_TIM_DMABURST_BASEADDR_RCR: UInt32 = 0x0000_000C
public let LL_TIM_DMABURST_BASEADDR_CCR1: UInt32 = 0x0000_000D
public let LL_TIM_DMABURST_BASEADDR_CCR2: UInt32 = 0x0000_000E
public let LL_TIM_DMABURST_BASEADDR_CCR3: UInt32 = 0x0000_000F
public let LL_TIM_DMABURST_BASEADDR_CCR4: UInt32 = 0x0000_0010
public let LL_TIM_DMABURST_BASEADDR_BDTR: UInt32 = 0x0000_0011
public let LL_TIM_DMABURST_BASEADDR_CCR5: UInt32 = 0x0000_0012
public let LL_TIM_DMABURST_BASEADDR_CCR6: UInt32 = 0x0000_0013
public let LL_TIM_DMABURST_BASEADDR_CCMR3: UInt32 = 0x0000_0014
public let LL_TIM_DMABURST_BASEADDR_DTR2: UInt32 = 0x0000_0015
public let LL_TIM_DMABURST_BASEADDR_ECR: UInt32 = 0x0000_0016
public let LL_TIM_DMABURST_BASEADDR_TISEL: UInt32 = 0x0000_0017
public let LL_TIM_DMABURST_BASEADDR_AF1: UInt32 = 0x0000_0018
public let LL_TIM_DMABURST_BASEADDR_AF2: UInt32 = 0x0000_0019
public let LL_TIM_DMABURST_LENGTH_1TRANSFER: UInt32 = 0x0000_0000
public let LL_TIM_DMABURST_LENGTH_2TRANSFERS: UInt32 = 0x0000_0100
public let LL_TIM_DMABURST_LENGTH_3TRANSFERS: UInt32 = 0x0000_0200
public let LL_TIM_DMABURST_LENGTH_4TRANSFERS: UInt32 = 0x0000_0300
public let LL_TIM_DMABURST_LENGTH_5TRANSFERS: UInt32 = 0x0000_0400
public let LL_TIM_DMABURST_LENGTH_6TRANSFERS: UInt32 = 0x0000_0500
public let LL_TIM_DMABURST_LENGTH_7TRANSFERS: UInt32 = 0x0000_0600
public let LL_TIM_DMABURST_LENGTH_8TRANSFERS: UInt32 = 0x0000_0700
public let LL_TIM_DMABURST_LENGTH_9TRANSFERS: UInt32 = 0x0000_0800
public let LL_TIM_DMABURST_LENGTH_10TRANSFERS: UInt32 = 0x0000_0900
public let LL_TIM_DMABURST_LENGTH_11TRANSFERS: UInt32 = 0x0000_0A00
public let LL_TIM_DMABURST_LENGTH_12TRANSFERS: UInt32 = 0x0000_0B00
public let LL_TIM_DMABURST_LENGTH_13TRANSFERS: UInt32 = 0x0000_0C00
public let LL_TIM_DMABURST_LENGTH_14TRANSFERS: UInt32 = 0x0000_0D00
public let LL_TIM_DMABURST_LENGTH_15TRANSFERS: UInt32 = 0x0000_0E00
public let LL_TIM_DMABURST_LENGTH_16TRANSFERS: UInt32 = 0x0000_0F00
public let LL_TIM_DMABURST_LENGTH_17TRANSFERS: UInt32 = 0x0000_1000
public let LL_TIM_DMABURST_LENGTH_18TRANSFERS: UInt32 = 0x0000_1100
public let LL_TIM_DMABURST_LENGTH_19TRANSFERS: UInt32 = 0x0000_1200
public let LL_TIM_DMABURST_LENGTH_20TRANSFERS: UInt32 = 0x0000_1300
public let LL_TIM_DMABURST_LENGTH_21TRANSFERS: UInt32 = 0x0000_1400
public let LL_TIM_DMABURST_LENGTH_22TRANSFERS: UInt32 = 0x0000_1500
public let LL_TIM_DMABURST_LENGTH_23TRANSFERS: UInt32 = 0x0000_1600
public let LL_TIM_DMABURST_LENGTH_24TRANSFERS: UInt32 = 0x0000_1700
public let LL_TIM_DMABURST_LENGTH_25TRANSFERS: UInt32 = 0x0000_1800
public let LL_TIM_DMABURST_LENGTH_26TRANSFERS: UInt32 = 0x0000_1900
public let LL_TIM_DMA_UPDATE: UInt32 = 0x0001_0000
public let LL_TIM_DMA_CC1: UInt32 = 0x0002_0000
public let LL_TIM_DMA_CC2: UInt32 = 0x0003_0000
public let LL_TIM_DMA_CC3: UInt32 = 0x0004_0000
public let LL_TIM_DMA_CC4: UInt32 = 0x0005_0000
public let LL_TIM_DMA_COM: UInt32 = 0x0006_0000
public let LL_TIM_DMA_TRIGGER: UInt32 = 0x0007_0000
public let LL_TIM_TIM2_TI1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM2_TI1_RMP_ETH_PPS: UInt32 = 0x0000_0001
public let LL_TIM_TIM3_TI1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM3_TI1_RMP_ETH_PPS: UInt32 = 0x0000_0001
public let LL_TIM_TIM9_TI1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM9_TI1_RMP_MCO1: UInt32 = 0x0000_0004
public let LL_TIM_TIM9_TI1_RMP_MCO2: UInt32 = 0x0000_0005
public let LL_TIM_TIM12_TI1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM12_TI1_RMP_SPDIF_FS: UInt32 = 0x0000_0001
public let LL_TIM_TIM12_TI1_RMP_HSI_1024: UInt32 = 0x0000_0002
public let LL_TIM_TIM12_TI1_RMP_CSI_128: UInt32 = 0x0000_0003
public let LL_TIM_TIM12_TI1_RMP_MCO1: UInt32 = 0x0000_0004
public let LL_TIM_TIM12_TI1_RMP_MCO2: UInt32 = 0x0000_0005
public let LL_TIM_TIM15_TI1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM15_TI1_RMP_TIM2_CH1: UInt32 = 0x0000_0001
public let LL_TIM_TIM15_TI1_RMP_TIM3_CH1: UInt32 = 0x0000_0002
public let LL_TIM_TIM15_TI1_RMP_TIM4_CH1: UInt32 = 0x0000_0003
public let LL_TIM_TIM15_TI1_RMP_MCO1: UInt32 = 0x0000_0004
public let LL_TIM_TIM15_TI1_RMP_MCO2: UInt32 = 0x0000_0005
public let LL_TIM_TIM15_TI2_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM15_TI2_RMP_TIM2_CH2: UInt32 = 0x0000_0100
public let LL_TIM_TIM15_TI2_RMP_TIM3_CH2: UInt32 = 0x0000_0200
public let LL_TIM_TIM15_TI2_RMP_TIM4_CH2: UInt32 = 0x0000_0300
public let LL_TIM_TIM16_TI1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM16_TI1_RMP_RTC_WKUP: UInt32 = 0x0000_0003
public let LL_TIM_TIM17_TI1_RMP_GPIO: UInt32 = 0x0000_0000
public let LL_TIM_TIM17_TI1_RMP_SPDIF_FS: UInt32 = 0x0000_0001
public let LL_TIM_INDEX_UP_DOWN: UInt32 = 0x0000_0000
public let LL_TIM_INDEX_UP: UInt32 = 0x0000_0002
public let LL_TIM_INDEX_DOWN: UInt32 = 0x0000_0004
public let LL_TIM_INDEX_BLANK_ALWAYS: UInt32 = 0x0000_0000
public let LL_TIM_INDEX_BLANK_TI3: UInt32 = 0x0000_0008
public let LL_TIM_INDEX_BLANK_TI4: UInt32 = 0x0000_0010
public let LL_TIM_INDEX_POSITION_DOWN_DOWN: UInt32 = 0x0000_0000
public let LL_TIM_INDEX_POSITION_DOWN_UP: UInt32 = 0x0000_0040
public let LL_TIM_INDEX_POSITION_UP_DOWN: UInt32 = 0x0000_0080
public let LL_TIM_INDEX_POSITION_UP_UP: UInt32 = 0x0000_00C0
public let LL_TIM_INDEX_POSITION_DOWN: UInt32 = 0x0000_0000
public let LL_TIM_INDEX_POSITION_UP: UInt32 = 0x0000_0040
public let LL_TIM_INDEX_ALL: UInt32 = 0x0000_0000
public let LL_TIM_INDEX_FIRST_ONLY: UInt32 = 0x0000_0020
public let LL_TIM_PWPRSC_X1: UInt32 = 0x0000_0000
public let LL_TIM_PWPRSC_X2: UInt32 = 0x0100_0000
public let LL_TIM_PWPRSC_X4: UInt32 = 0x0200_0000
public let LL_TIM_PWPRSC_X8: UInt32 = 0x0300_0000
public let LL_TIM_PWPRSC_X16: UInt32 = 0x0400_0000
public let LL_TIM_PWPRSC_X32: UInt32 = 0x0500_0000
public let LL_TIM_PWPRSC_X64: UInt32 = 0x0600_0000
public let LL_TIM_PWPRSC_X128: UInt32 = 0x0700_0000

private let OFFSET_TAB_CCMRx: InlineArray<10, UInt8> = [0, 0, 0, 0, 4, 4, 4, 4, 56, 56]
private let SHIFT_TAB_OCxx: InlineArray<10, UInt8> = [0, 0, 8, 0, 0, 0, 8, 0, 0, 8]
private let SHIFT_TAB_ICxx: InlineArray<10, UInt8> = [0, 0, 8, 0, 0, 0, 8, 0, 0, 0]
private let SHIFT_TAB_CCxP: InlineArray<10, UInt8> = [0, 2, 4, 6, 8, 10, 12, 14, 16, 20]
private let SHIFT_TAB_OISx: InlineArray<10, UInt8> = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10]

private func _llTIMChannelIndex(_ channel: UInt32) -> UInt8 {
    if channel == LL_TIM_CHANNEL_CH1 { return 0 }
    if channel == LL_TIM_CHANNEL_CH1N { return 1 }
    if channel == LL_TIM_CHANNEL_CH2 { return 2 }
    if channel == LL_TIM_CHANNEL_CH2N { return 3 }
    if channel == LL_TIM_CHANNEL_CH3 { return 4 }
    if channel == LL_TIM_CHANNEL_CH3N { return 5 }
    if channel == LL_TIM_CHANNEL_CH4 { return 6 }
    if channel == LL_TIM_CHANNEL_CH4N { return 7 }
    if channel == LL_TIM_CHANNEL_CH5 { return 8 }
    return 9
}
public func LL_TIM_EnableCounter<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) | (0x1))
}

public func LL_TIM_DisableCounter<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) & ~(0x1))
}

public func LL_TIM_IsEnabledCounter<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.cr1) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_TIM_EnableUpdateEvent<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) & ~(0x2))
}

public func LL_TIM_DisableUpdateEvent<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) | (0x2))
}

public func LL_TIM_IsEnabledUpdateEvent<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.cr1) & (0x2)) == 0) ? 1 : 0)
}

public func LL_TIM_SetUpdateSource<IO: TIMRegisterIO>(_ registers: inout IO, _ UpdateSource: UInt32) {
    registers.write(TIMRegister.cr1, value: (registers.read(TIMRegister.cr1) & ~(0x4)) | (UpdateSource))
}

public func LL_TIM_GetUpdateSource<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.cr1) & (0x4)))
}

public func LL_TIM_SetOnePulseMode<IO: TIMRegisterIO>(_ registers: inout IO, _ OnePulseMode: UInt32) {
    registers.write(TIMRegister.cr1, value: (registers.read(TIMRegister.cr1) & ~(0x8)) | (OnePulseMode))
}

public func LL_TIM_GetOnePulseMode<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.cr1) & (0x8)))
}

public func LL_TIM_SetCounterMode<IO: TIMRegisterIO>(_ registers: inout IO, _ CounterMode: UInt32) {
    registers.write(TIMRegister.cr1, value: (registers.read(TIMRegister.cr1) & ~((0x10 | 0x60))) | (CounterMode))
}

public func LL_TIM_GetCounterMode<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    var counter_mode: UInt32
    counter_mode = ((registers.read(TIMRegister.cr1) & (0x60)))
    if counter_mode == 0 {
        counter_mode = ((registers.read(TIMRegister.cr1) & (0x10)))
    }
    return counter_mode
}

public func LL_TIM_EnableARRPreload<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) | (0x80))
}

public func LL_TIM_DisableARRPreload<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) & ~(0x80))
}

public func LL_TIM_IsEnabledARRPreload<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.cr1) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_TIM_SetClockDivision<IO: TIMRegisterIO>(_ registers: inout IO, _ ClockDivision: UInt32) {
    registers.write(TIMRegister.cr1, value: (registers.read(TIMRegister.cr1) & ~(0x300)) | (ClockDivision))
}

public func LL_TIM_GetClockDivision<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.cr1) & (0x300)))
}

public func LL_TIM_SetCounter<IO: TIMRegisterIO>(_ registers: inout IO, _ Counter: UInt32) {
    registers.write(TIMRegister.cnt, value: Counter)
}

public func LL_TIM_GetCounter<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.cnt))
}

public func LL_TIM_GetDirection<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.cr1) & (0x10)))
}

public func LL_TIM_SetPrescaler<IO: TIMRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(TIMRegister.psc, value: Prescaler)
}

public func LL_TIM_GetPrescaler<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.psc))
}

public func LL_TIM_SetAutoReload<IO: TIMRegisterIO>(_ registers: inout IO, _ AutoReload: UInt32) {
    registers.write(TIMRegister.arr, value: AutoReload)
}

public func LL_TIM_GetAutoReload<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.arr))
}

public func LL_TIM_SetRepetitionCounter<IO: TIMRegisterIO>(_ registers: inout IO, _ RepetitionCounter: UInt32) {
    registers.write(TIMRegister.rcr, value: RepetitionCounter)
}

public func LL_TIM_GetRepetitionCounter<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.rcr))
}

public func LL_TIM_EnableUIFRemap<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) | (0x800))
}

public func LL_TIM_DisableUIFRemap<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) & ~(0x800))
}

public func LL_TIM_IsActiveUIFCPY(_ Counter: UInt32) -> UInt32 {
    return (((Counter & 0x8000_0000) == (0x8000_0000)) ? 1 : 0)
}

public func LL_TIM_EnableDithering<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) | (0x1000))
}

public func LL_TIM_DisableDithering<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr1, value: registers.read(TIMRegister.cr1) & ~(0x1000))
}

public func LL_TIM_IsEnabledDithering<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.cr1) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_TIM_CC_EnablePreload<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr2, value: registers.read(TIMRegister.cr2) | (0x1))
}

public func LL_TIM_CC_DisablePreload<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr2, value: registers.read(TIMRegister.cr2) & ~(0x1))
}

public func LL_TIM_CC_IsEnabledPreload<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.cr2) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_TIM_CC_SetUpdate<IO: TIMRegisterIO>(_ registers: inout IO, _ CCUpdateSource: UInt32) {
    registers.write(TIMRegister.cr2, value: (registers.read(TIMRegister.cr2) & ~(0x4)) | (CCUpdateSource))
}

public func LL_TIM_CC_SetDMAReqTrigger<IO: TIMRegisterIO>(_ registers: inout IO, _ DMAReqTrigger: UInt32) {
    registers.write(TIMRegister.cr2, value: (registers.read(TIMRegister.cr2) & ~(0x8)) | (DMAReqTrigger))
}

public func LL_TIM_CC_GetDMAReqTrigger<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.cr2) & (0x8)))
}

public func LL_TIM_CC_SetLockLevel<IO: TIMRegisterIO>(_ registers: inout IO, _ LockLevel: UInt32) {
    registers.write(TIMRegister.bdtr, value: (registers.read(TIMRegister.bdtr) & ~(0x300)) | (LockLevel))
}

public func LL_TIM_CC_EnableChannel<IO: TIMRegisterIO>(_ registers: inout IO, _ Channels: UInt32) {
    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) | (Channels))
}

public func LL_TIM_CC_DisableChannel<IO: TIMRegisterIO>(_ registers: inout IO, _ Channels: UInt32) {
    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & ~(Channels))
}

public func LL_TIM_CC_IsEnabledChannel<IO: TIMRegisterIO>(_ registers: inout IO, _ Channels: UInt32) -> UInt32 {
    return (((registers.read(TIMRegister.ccer) & (Channels)) == (Channels)) ? 1 : 0)
}

public func LL_TIM_OC_ConfigOutput<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Configuration: UInt32)
{
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(pReg, value: registers.read(pReg) & ~((0x3 << SHIFT_TAB_OCxx[Int(iChannel)])))
    registers.write(
        TIMRegister.ccer,
        value: (registers.read(TIMRegister.ccer) & ~((0x2 << SHIFT_TAB_CCxP[Int(iChannel)])))
            | ((Configuration & 0x2) << SHIFT_TAB_CCxP[Int(iChannel)]))
    registers.write(
        TIMRegister.cr2,
        value: (registers.read(TIMRegister.cr2) & ~((0x100 << SHIFT_TAB_OISx[Int(iChannel)])))
            | ((Configuration & 0x100) << SHIFT_TAB_OISx[Int(iChannel)]))
}

public func LL_TIM_OC_SetMode<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Mode: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(
        pReg,
        value: (registers.read(pReg) & ~(((0x10070 | 0x3) << SHIFT_TAB_OCxx[Int(iChannel)])))
            | (Mode << SHIFT_TAB_OCxx[Int(iChannel)]))
}

public func LL_TIM_OC_GetMode<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    return
        ((registers.read(pReg) & (((0x10070 | 0x3) << SHIFT_TAB_OCxx[Int(iChannel)]))) >> SHIFT_TAB_OCxx[Int(iChannel)])
}

public func LL_TIM_OC_SetPolarity<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Polarity: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    registers.write(
        TIMRegister.ccer,
        value: (registers.read(TIMRegister.ccer) & ~((0x2 << SHIFT_TAB_CCxP[Int(iChannel)])))
            | (Polarity << SHIFT_TAB_CCxP[Int(iChannel)]))
}

public func LL_TIM_OC_GetPolarity<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    return
        ((registers.read(TIMRegister.ccer) & ((0x2 << SHIFT_TAB_CCxP[Int(iChannel)]))) >> SHIFT_TAB_CCxP[Int(iChannel)])
}

public func LL_TIM_OC_SetIdleState<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ IdleState: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    registers.write(
        TIMRegister.cr2,
        value: (registers.read(TIMRegister.cr2) & ~((0x100 << SHIFT_TAB_OISx[Int(iChannel)])))
            | (IdleState << SHIFT_TAB_OISx[Int(iChannel)]))
}

public func LL_TIM_OC_GetIdleState<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    return
        ((registers.read(TIMRegister.cr2) & ((0x100 << SHIFT_TAB_OISx[Int(iChannel)]))) >> SHIFT_TAB_OISx[Int(iChannel)])
}

public func LL_TIM_OC_EnableFast<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(pReg, value: registers.read(pReg) | ((0x4 << SHIFT_TAB_OCxx[Int(iChannel)])))
}

public func LL_TIM_OC_DisableFast<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(pReg, value: registers.read(pReg) & ~((0x4 << SHIFT_TAB_OCxx[Int(iChannel)])))
}

public func LL_TIM_OC_IsEnabledFast<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    var bitfield: UInt32 = 0x4 << SHIFT_TAB_OCxx[Int(iChannel)]
    return (((registers.read(pReg) & (bitfield)) == bitfield) ? 1 : 0)
}

public func LL_TIM_OC_EnablePreload<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(pReg, value: registers.read(pReg) | ((0x8 << SHIFT_TAB_OCxx[Int(iChannel)])))
}

public func LL_TIM_OC_DisablePreload<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(pReg, value: registers.read(pReg) & ~((0x8 << SHIFT_TAB_OCxx[Int(iChannel)])))
}

public func LL_TIM_OC_IsEnabledPreload<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    var bitfield: UInt32 = 0x8 << SHIFT_TAB_OCxx[Int(iChannel)]
    return (((registers.read(pReg) & (bitfield)) == bitfield) ? 1 : 0)
}

public func LL_TIM_OC_EnableClear<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(pReg, value: registers.read(pReg) | ((0x80 << SHIFT_TAB_OCxx[Int(iChannel)])))
}

public func LL_TIM_OC_DisableClear<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(pReg, value: registers.read(pReg) & ~((0x80 << SHIFT_TAB_OCxx[Int(iChannel)])))
}

public func LL_TIM_OC_IsEnabledClear<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    var bitfield: UInt32 = 0x80 << SHIFT_TAB_OCxx[Int(iChannel)]
    return (((registers.read(pReg) & (bitfield)) == bitfield) ? 1 : 0)
}

public func LL_TIM_OC_SetDeadTime<IO: TIMRegisterIO>(_ registers: inout IO, _ DeadTime: UInt32) {
    registers.write(TIMRegister.bdtr, value: (registers.read(TIMRegister.bdtr) & ~(0xff)) | (DeadTime))
}

public func LL_TIM_OC_SetCompareCH1<IO: TIMRegisterIO>(_ registers: inout IO, _ CompareValue: UInt32) {
    registers.write(TIMRegister.ccr1, value: CompareValue)
}

public func LL_TIM_OC_SetCompareCH2<IO: TIMRegisterIO>(_ registers: inout IO, _ CompareValue: UInt32) {
    registers.write(TIMRegister.ccr2, value: CompareValue)
}

public func LL_TIM_OC_SetCompareCH3<IO: TIMRegisterIO>(_ registers: inout IO, _ CompareValue: UInt32) {
    registers.write(TIMRegister.ccr3, value: CompareValue)
}

public func LL_TIM_OC_SetCompareCH4<IO: TIMRegisterIO>(_ registers: inout IO, _ CompareValue: UInt32) {
    registers.write(TIMRegister.ccr4, value: CompareValue)
}

public func LL_TIM_OC_SetCompareCH5<IO: TIMRegisterIO>(_ registers: inout IO, _ CompareValue: UInt32) {
    registers.write(TIMRegister.ccr5, value: (registers.read(TIMRegister.ccr5) & ~(0xfffff)) | (CompareValue))
}

public func LL_TIM_OC_SetCompareCH6<IO: TIMRegisterIO>(_ registers: inout IO, _ CompareValue: UInt32) {
    registers.write(TIMRegister.ccr6, value: CompareValue)
}

public func LL_TIM_OC_GetCompareCH1<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr1))
}

public func LL_TIM_OC_GetCompareCH2<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr2))
}

public func LL_TIM_OC_GetCompareCH3<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr3))
}

public func LL_TIM_OC_GetCompareCH4<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr4))
}

public func LL_TIM_OC_GetCompareCH5<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.ccr5) & (0xfffff)))
}

public func LL_TIM_OC_GetCompareCH6<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr6))
}

public func LL_TIM_SetCH5CombinedChannels<IO: TIMRegisterIO>(_ registers: inout IO, _ GroupCH5: UInt32) {
    registers.write(
        TIMRegister.ccr5,
        value: (registers.read(TIMRegister.ccr5) & ~((0x8000_0000 | 0x4000_0000 | 0x2000_0000))) | (GroupCH5))
}

public func LL_TIM_OC_SetPulseWidthPrescaler<IO: TIMRegisterIO>(_ registers: inout IO, _ PulseWidthPrescaler: UInt32) {
    registers.write(TIMRegister.ecr, value: (registers.read(TIMRegister.ecr) & ~(0x7000000)) | (PulseWidthPrescaler))
}

public func LL_TIM_OC_GetPulseWidthPrescaler<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.ecr) & (0x7000000)))
}

public func LL_TIM_OC_SetPulseWidth<IO: TIMRegisterIO>(_ registers: inout IO, _ PulseWidth: UInt32) {
    registers.write(TIMRegister.ecr, value: (registers.read(TIMRegister.ecr) & ~(0xff0000)) | (PulseWidth << 0x10))
}

public func LL_TIM_OC_GetPulseWidth<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.ecr) & (0xff0000)))
}

public func LL_TIM_IC_Config<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ Configuration: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(
        pReg,
        value: (registers.read(pReg) & ~(((0xf0 | 0xc | 0x3) << SHIFT_TAB_ICxx[Int(iChannel)])))
            | (((Configuration >> 16) & (0xf0 | 0xc | 0x3)) << SHIFT_TAB_ICxx[Int(iChannel)]))
    registers.write(
        TIMRegister.ccer,
        value: (registers.read(TIMRegister.ccer) & ~(((0x8 | 0x2) << SHIFT_TAB_CCxP[Int(iChannel)])))
            | ((Configuration & (0x8 | 0x2)) << SHIFT_TAB_CCxP[Int(iChannel)]))
}

public func LL_TIM_IC_SetActiveInput<IO: TIMRegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ ICActiveInput: UInt32
) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(
        pReg,
        value: (registers.read(pReg) & ~(((0x3) << SHIFT_TAB_ICxx[Int(iChannel)])))
            | ((ICActiveInput >> 16) << SHIFT_TAB_ICxx[Int(iChannel)]))
}

public func LL_TIM_IC_GetActiveInput<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    return
        (((registers.read(pReg) & (((0x3) << SHIFT_TAB_ICxx[Int(iChannel)]))) >> SHIFT_TAB_ICxx[Int(iChannel)]) << 16)
}

public func LL_TIM_IC_SetPrescaler<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ ICPrescaler: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(
        pReg,
        value: (registers.read(pReg) & ~(((0xc) << SHIFT_TAB_ICxx[Int(iChannel)])))
            | ((ICPrescaler >> 16) << SHIFT_TAB_ICxx[Int(iChannel)]))
}

public func LL_TIM_IC_GetPrescaler<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    return
        (((registers.read(pReg) & (((0xc) << SHIFT_TAB_ICxx[Int(iChannel)]))) >> SHIFT_TAB_ICxx[Int(iChannel)]) << 16)
}

public func LL_TIM_IC_SetFilter<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ ICFilter: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    registers.write(
        pReg,
        value: (registers.read(pReg) & ~(((0xf0) << SHIFT_TAB_ICxx[Int(iChannel)])))
            | ((ICFilter >> 16) << SHIFT_TAB_ICxx[Int(iChannel)]))
}

public func LL_TIM_IC_GetFilter<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    let pReg = TIMRegister(rawValue: 0x18 &+ UInt32(OFFSET_TAB_CCMRx[Int(iChannel)]))!
    return
        (((registers.read(pReg) & (((0xf0) << SHIFT_TAB_ICxx[Int(iChannel)]))) >> SHIFT_TAB_ICxx[Int(iChannel)]) << 16)
}

public func LL_TIM_IC_SetPolarity<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32, _ ICPolarity: UInt32) {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    registers.write(
        TIMRegister.ccer,
        value: (registers.read(TIMRegister.ccer) & ~(((0x8 | 0x2) << SHIFT_TAB_CCxP[Int(iChannel)])))
            | (ICPolarity << SHIFT_TAB_CCxP[Int(iChannel)]))
}

public func LL_TIM_IC_GetPolarity<IO: TIMRegisterIO>(_ registers: inout IO, _ Channel: UInt32) -> UInt32 {
    var iChannel: UInt8 = _llTIMChannelIndex(Channel)
    return
        ((registers.read(TIMRegister.ccer) & (((0x8 | 0x2) << SHIFT_TAB_CCxP[Int(iChannel)])))
        >> SHIFT_TAB_CCxP[Int(iChannel)])
}

public func LL_TIM_IC_EnableXORCombination<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr2, value: registers.read(TIMRegister.cr2) | (0x80))
}

public func LL_TIM_IC_DisableXORCombination<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.cr2, value: registers.read(TIMRegister.cr2) & ~(0x80))
}

public func LL_TIM_IC_IsEnabledXORCombination<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.cr2) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_TIM_IC_GetCaptureCH1<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr1))
}

public func LL_TIM_IC_GetCaptureCH2<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr2))
}

public func LL_TIM_IC_GetCaptureCH3<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr3))
}

public func LL_TIM_IC_GetCaptureCH4<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(TIMRegister.ccr4))
}

public func LL_TIM_EnableExternalClock<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.smcr, value: registers.read(TIMRegister.smcr) | (0x4000))
}

public func LL_TIM_DisableExternalClock<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.smcr, value: registers.read(TIMRegister.smcr) & ~(0x4000))
}

public func LL_TIM_IsEnabledExternalClock<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.smcr) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_TIM_SetClockSource<IO: TIMRegisterIO>(_ registers: inout IO, _ ClockSource: UInt32) {
    registers.write(TIMRegister.smcr, value: (registers.read(TIMRegister.smcr) & ~(0x10007 | 0x4000)) | (ClockSource))
}

public func LL_TIM_SetEncoderMode<IO: TIMRegisterIO>(_ registers: inout IO, _ EncoderMode: UInt32) {
    registers.write(TIMRegister.smcr, value: (registers.read(TIMRegister.smcr) & ~(0x10007)) | (EncoderMode))
}

public func LL_TIM_SetTriggerOutput<IO: TIMRegisterIO>(_ registers: inout IO, _ TimerSynchronization: UInt32) {
    registers.write(TIMRegister.cr2, value: (registers.read(TIMRegister.cr2) & ~(0x2000070)) | (TimerSynchronization))
}

public func LL_TIM_SetTriggerOutput2<IO: TIMRegisterIO>(_ registers: inout IO, _ ADCSynchronization: UInt32) {
    registers.write(TIMRegister.cr2, value: (registers.read(TIMRegister.cr2) & ~(0xf00000)) | (ADCSynchronization))
}

public func LL_TIM_SetSlaveMode<IO: TIMRegisterIO>(_ registers: inout IO, _ SlaveMode: UInt32) {
    registers.write(TIMRegister.smcr, value: (registers.read(TIMRegister.smcr) & ~(0x10007)) | (SlaveMode))
}

public func LL_TIM_SetTriggerInput<IO: TIMRegisterIO>(_ registers: inout IO, _ TriggerInput: UInt32) {
    registers.write(TIMRegister.smcr, value: (registers.read(TIMRegister.smcr) & ~(0x300070)) | (TriggerInput))
}

public func LL_TIM_EnableMasterSlaveMode<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.smcr, value: registers.read(TIMRegister.smcr) | (0x80))
}

public func LL_TIM_DisableMasterSlaveMode<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.smcr, value: registers.read(TIMRegister.smcr) & ~(0x80))
}

public func LL_TIM_IsEnabledMasterSlaveMode<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.smcr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_TIM_ConfigETR<IO: TIMRegisterIO>(
    _ registers: inout IO, _ ETRPolarity: UInt32, _ ETRPrescaler: UInt32, _ ETRFilter: UInt32
) {
    registers.write(
        TIMRegister.smcr,
        value: (registers.read(TIMRegister.smcr) & ~(0x8000 | 0x3000 | 0xf00))
            | (ETRPolarity | ETRPrescaler | ETRFilter))
}

public func LL_TIM_SetETRSource<IO: TIMRegisterIO>(_ registers: inout IO, _ ETRSource: UInt32) {
    registers.write(TIMRegister.af1, value: (registers.read(TIMRegister.af1) & ~(0x3c000)) | (ETRSource))
}

public func LL_TIM_EnableSMSPreload<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.smcr, value: registers.read(TIMRegister.smcr) | (0x1000000))
}

public func LL_TIM_DisableSMSPreload<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.smcr, value: registers.read(TIMRegister.smcr) & ~(0x1000000))
}

public func LL_TIM_IsEnabledSMSPreload<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.smcr) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_TIM_SetSMSPreloadSource<IO: TIMRegisterIO>(_ registers: inout IO, _ PreloadSource: UInt32) {
    registers.write(TIMRegister.smcr, value: (registers.read(TIMRegister.smcr) & ~(0x2000000)) | (PreloadSource))
}

public func LL_TIM_GetSMSPreloadSource<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.smcr) & (0x2000000)))
}

public func LL_TIM_EnableBRK<IO: TIMRegisterIO>(_ registers: inout IO) {
    var tmpreg: UInt32
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) | (0x1000))
    tmpreg = registers.read(TIMRegister.bdtr)
    _ = tmpreg
}

public func LL_TIM_DisableBRK<IO: TIMRegisterIO>(_ registers: inout IO) {
    var tmpreg: UInt32
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) & ~(0x1000))
    tmpreg = registers.read(TIMRegister.bdtr)
    _ = tmpreg
}

public func LL_TIM_ConfigBRK<IO: TIMRegisterIO>(
    _ registers: inout IO, _ BreakPolarity: UInt32, _ BreakFilter: UInt32, _ BreakAFMode: UInt32
) {
    var tmpreg: UInt32
    registers.write(
        TIMRegister.bdtr,
        value: (registers.read(TIMRegister.bdtr) & ~(0x2000 | 0xf0000 | 0x1000_0000))
            | (BreakPolarity | BreakFilter | BreakAFMode))
    tmpreg = registers.read(TIMRegister.bdtr)
    _ = tmpreg
}

public func LL_TIM_DisarmBRK<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) | (0x4000000))
}

public func LL_TIM_EnableBRK2<IO: TIMRegisterIO>(_ registers: inout IO) {
    var tmpreg: UInt32
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) | (0x1000000))
    tmpreg = registers.read(TIMRegister.bdtr)
    _ = tmpreg
}

public func LL_TIM_DisableBRK2<IO: TIMRegisterIO>(_ registers: inout IO) {
    var tmpreg: UInt32
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) & ~(0x1000000))
    tmpreg = registers.read(TIMRegister.bdtr)
    _ = tmpreg
}

public func LL_TIM_ConfigBRK2<IO: TIMRegisterIO>(
    _ registers: inout IO, _ Break2Polarity: UInt32, _ Break2Filter: UInt32, _ Break2AFMode: UInt32
) {
    var tmpreg: UInt32
    registers.write(
        TIMRegister.bdtr,
        value: (registers.read(TIMRegister.bdtr) & ~(0x2000000 | 0xf00000 | 0x2000_0000))
            | (Break2Polarity | Break2Filter | Break2AFMode))
    tmpreg = registers.read(TIMRegister.bdtr)
    _ = tmpreg
}

public func LL_TIM_DisarmBRK2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) | (0x8000000))
}

public func LL_TIM_SetOffStates<IO: TIMRegisterIO>(_ registers: inout IO, _ OffStateIdle: UInt32, _ OffStateRun: UInt32)
{
    registers.write(
        TIMRegister.bdtr, value: (registers.read(TIMRegister.bdtr) & ~(0x400 | 0x800)) | (OffStateIdle | OffStateRun))
}

public func LL_TIM_EnableAutomaticOutput<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) | (0x4000))
}

public func LL_TIM_DisableAutomaticOutput<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) & ~(0x4000))
}

public func LL_TIM_IsEnabledAutomaticOutput<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.bdtr) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_TIM_EnableAllOutputs<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) | (0x8000))
}

public func LL_TIM_DisableAllOutputs<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.bdtr, value: registers.read(TIMRegister.bdtr) & ~(0x8000))
}

public func LL_TIM_IsEnabledAllOutputs<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.bdtr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_TIM_EnableBreakInputSource<IO: TIMRegisterIO>(
    _ registers: inout IO, _ BreakInput: UInt32, _ Source: UInt32
) {
    let pReg = TIMRegister(rawValue: 0x60 &+ BreakInput)!
    registers.write(pReg, value: registers.read(pReg) | (Source))
}

public func LL_TIM_DisableBreakInputSource<IO: TIMRegisterIO>(
    _ registers: inout IO, _ BreakInput: UInt32, _ Source: UInt32
) {
    let pReg = TIMRegister(rawValue: 0x60 &+ BreakInput)!
    registers.write(pReg, value: registers.read(pReg) & ~(Source))
}

public func LL_TIM_SetBreakInputSourcePolarity<IO: TIMRegisterIO>(
    _ registers: inout IO, _ BreakInput: UInt32, _ Source: UInt32, _ Polarity: UInt32
) {
    let pReg = TIMRegister(rawValue: 0x60 &+ BreakInput)!
    registers.write(
        pReg,
        value: (registers.read(pReg) & ~((0x200 << (UInt32(Source.trailingZeroBitCount) & 0x1F))))
            | ((Polarity << (UInt32(Source.trailingZeroBitCount) & 0x1F))))
}

public func LL_TIM_EnableAsymmetricalDeadTime<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dtr2, value: registers.read(TIMRegister.dtr2) | (0x10000))
}

public func LL_TIM_DisableAsymmetricalDeadTime<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dtr2, value: registers.read(TIMRegister.dtr2) & ~(0x10000))
}

public func LL_TIM_IsEnabledAsymmetricalDeadTime<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dtr2) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_TIM_SetFallingDeadTime<IO: TIMRegisterIO>(_ registers: inout IO, _ DeadTime: UInt32) {
    registers.write(TIMRegister.dtr2, value: (registers.read(TIMRegister.dtr2) & ~(0xff)) | (DeadTime))
}

public func LL_TIM_GetFallingDeadTime<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.dtr2) & (0xff)))
}

public func LL_TIM_EnableDeadTimePreload<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dtr2, value: registers.read(TIMRegister.dtr2) | (0x20000))
}

public func LL_TIM_DisableDeadTimePreload<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dtr2, value: registers.read(TIMRegister.dtr2) & ~(0x20000))
}

public func LL_TIM_IsEnabledDeadTimePreload<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dtr2) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_TIM_ConfigDMABurst<IO: TIMRegisterIO>(
    _ registers: inout IO, _ DMABurstBaseAddress: UInt32, _ DMABurstLength: UInt32, _ DMABurstSource: UInt32
) {
    registers.write(
        TIMRegister.dcr,
        value: (registers.read(TIMRegister.dcr) & ~((0x1f00 | 0x1f | 0xf0000)))
            | ((DMABurstBaseAddress | DMABurstLength | DMABurstSource)))
}

public func LL_TIM_EnableEncoderIndex<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.ecr, value: registers.read(TIMRegister.ecr) | (0x1))
}

public func LL_TIM_DisableEncoderIndex<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.ecr, value: registers.read(TIMRegister.ecr) & ~(0x1))
}

public func LL_TIM_IsEnabledEncoderIndex<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.ecr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_TIM_SetIndexDirection<IO: TIMRegisterIO>(_ registers: inout IO, _ IndexDirection: UInt32) {
    registers.write(TIMRegister.ecr, value: (registers.read(TIMRegister.ecr) & ~(0x6)) | (IndexDirection))
}

public func LL_TIM_GetIndexDirection<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.ecr) & (0x6)))
}

public func LL_TIM_SetIndexblanking<IO: TIMRegisterIO>(_ registers: inout IO, _ Indexblanking: UInt32) {
    registers.write(TIMRegister.ecr, value: (registers.read(TIMRegister.ecr) & ~(0x18)) | (Indexblanking))
}

public func LL_TIM_GetIndexblanking<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.ecr) & (0x18)))
}

public func LL_TIM_EnableFirstIndex<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.ecr, value: registers.read(TIMRegister.ecr) | (0x20))
}

public func LL_TIM_DisableFirstIndex<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.ecr, value: registers.read(TIMRegister.ecr) & ~(0x20))
}

public func LL_TIM_IsEnabledFirstIndex<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.ecr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_TIM_SetIndexPositionning<IO: TIMRegisterIO>(_ registers: inout IO, _ IndexPositionning: UInt32) {
    registers.write(TIMRegister.ecr, value: (registers.read(TIMRegister.ecr) & ~(0xc0)) | (IndexPositionning))
}

public func LL_TIM_GetIndexPositionning<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(TIMRegister.ecr) & (0xc0)))
}

public func LL_TIM_ConfigIDX<IO: TIMRegisterIO>(_ registers: inout IO, _ Configuration: UInt32) {
    registers.write(
        TIMRegister.ecr, value: (registers.read(TIMRegister.ecr) & ~(0x6 | 0x18 | 0x20 | 0xc0)) | (Configuration))
}

public func LL_TIM_SetRemap<IO: TIMRegisterIO>(_ registers: inout IO, _ Remap: UInt32) {
    registers.write(
        TIMRegister.tisel, value: (registers.read(TIMRegister.tisel) & ~((0xf | 0xf00 | 0xf0000 | 0xf000000))) | (Remap)
    )
}

public func LL_TIM_ClearFlag_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x1))
}

public func LL_TIM_IsActiveFlag_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC1<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x2))
}

public func LL_TIM_IsActiveFlag_CC1<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x4))
}

public func LL_TIM_IsActiveFlag_CC2<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC3<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x8))
}

public func LL_TIM_IsActiveFlag_CC3<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC4<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x10))
}

public func LL_TIM_IsActiveFlag_CC4<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC5<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x10000))
}

public func LL_TIM_IsActiveFlag_CC5<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC6<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x20000))
}

public func LL_TIM_IsActiveFlag_CC6<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_COM<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x20))
}

public func LL_TIM_IsActiveFlag_COM<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x40))
}

public func LL_TIM_IsActiveFlag_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_BRK<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x80))
}

public func LL_TIM_IsActiveFlag_BRK<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_BRK2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x100))
}

public func LL_TIM_IsActiveFlag_BRK2<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC1OVR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x200))
}

public func LL_TIM_IsActiveFlag_CC1OVR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC2OVR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x400))
}

public func LL_TIM_IsActiveFlag_CC2OVR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC3OVR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x800))
}

public func LL_TIM_IsActiveFlag_CC3OVR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_CC4OVR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x1000))
}

public func LL_TIM_IsActiveFlag_CC4OVR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_SYSBRK<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x2000))
}

public func LL_TIM_IsActiveFlag_SYSBRK<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_TERR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x800000))
}

public func LL_TIM_IsActiveFlag_TERR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_IERR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x400000))
}

public func LL_TIM_IsActiveFlag_IERR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_DIR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x200000))
}

public func LL_TIM_IsActiveFlag_DIR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_TIM_ClearFlag_IDX<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.sr, value: ~(0x100000))
}

public func LL_TIM_IsActiveFlag_IDX<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.sr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_TIM_EnableIT_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x1))
}

public func LL_TIM_DisableIT_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x1))
}

public func LL_TIM_IsEnabledIT_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_TIM_EnableIT_CC1<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x2))
}

public func LL_TIM_DisableIT_CC1<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x2))
}

public func LL_TIM_IsEnabledIT_CC1<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_TIM_EnableIT_CC2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x4))
}

public func LL_TIM_DisableIT_CC2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x4))
}

public func LL_TIM_IsEnabledIT_CC2<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_TIM_EnableIT_CC3<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x8))
}

public func LL_TIM_DisableIT_CC3<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x8))
}

public func LL_TIM_IsEnabledIT_CC3<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_TIM_EnableIT_CC4<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x10))
}

public func LL_TIM_DisableIT_CC4<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x10))
}

public func LL_TIM_IsEnabledIT_CC4<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_TIM_EnableIT_COM<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x20))
}

public func LL_TIM_DisableIT_COM<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x20))
}

public func LL_TIM_IsEnabledIT_COM<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_TIM_EnableIT_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x40))
}

public func LL_TIM_DisableIT_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x40))
}

public func LL_TIM_IsEnabledIT_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_TIM_EnableIT_BRK<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x80))
}

public func LL_TIM_DisableIT_BRK<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x80))
}

public func LL_TIM_IsEnabledIT_BRK<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_TIM_EnableIT_TERR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x800000))
}

public func LL_TIM_DisableIT_TERR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x800000))
}

public func LL_TIM_IsEnabledIT_TERR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_TIM_EnableIT_IERR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x400000))
}

public func LL_TIM_DisableIT_IERR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x400000))
}

public func LL_TIM_IsEnabledIT_IERR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_TIM_EnableIT_DIR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x200000))
}

public func LL_TIM_DisableIT_DIR<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x200000))
}

public func LL_TIM_IsEnabledIT_DIR<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_TIM_EnableIT_IDX<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x100000))
}

public func LL_TIM_DisableIT_IDX<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x100000))
}

public func LL_TIM_IsEnabledIT_IDX<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_TIM_EnableDMAReq_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x100))
}

public func LL_TIM_DisableDMAReq_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x100))
}

public func LL_TIM_IsEnabledDMAReq_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_TIM_EnableDMAReq_CC1<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x200))
}

public func LL_TIM_DisableDMAReq_CC1<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x200))
}

public func LL_TIM_IsEnabledDMAReq_CC1<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_TIM_EnableDMAReq_CC2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x400))
}

public func LL_TIM_DisableDMAReq_CC2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x400))
}

public func LL_TIM_IsEnabledDMAReq_CC2<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_TIM_EnableDMAReq_CC3<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x800))
}

public func LL_TIM_DisableDMAReq_CC3<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x800))
}

public func LL_TIM_IsEnabledDMAReq_CC3<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_TIM_EnableDMAReq_CC4<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x1000))
}

public func LL_TIM_DisableDMAReq_CC4<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x1000))
}

public func LL_TIM_IsEnabledDMAReq_CC4<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_TIM_EnableDMAReq_COM<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x2000))
}

public func LL_TIM_DisableDMAReq_COM<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x2000))
}

public func LL_TIM_IsEnabledDMAReq_COM<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_TIM_EnableDMAReq_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) | (0x4000))
}

public func LL_TIM_DisableDMAReq_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.dier, value: registers.read(TIMRegister.dier) & ~(0x4000))
}

public func LL_TIM_IsEnabledDMAReq_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(TIMRegister.dier) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_TIM_GenerateEvent_UPDATE<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x1))
}

public func LL_TIM_GenerateEvent_CC1<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x2))
}

public func LL_TIM_GenerateEvent_CC2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x4))
}

public func LL_TIM_GenerateEvent_CC3<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x8))
}

public func LL_TIM_GenerateEvent_CC4<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x10))
}

public func LL_TIM_GenerateEvent_COM<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x20))
}

public func LL_TIM_GenerateEvent_TRIG<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x40))
}

public func LL_TIM_GenerateEvent_BRK<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x80))
}

public func LL_TIM_GenerateEvent_BRK2<IO: TIMRegisterIO>(_ registers: inout IO) {
    registers.write(TIMRegister.egr, value: registers.read(TIMRegister.egr) | (0x100))
}

public func LL_TIM_DeInit<IO: TIMRegisterIO & LLBusRegisterIO>(_ registers: inout IO, isKnownInstance: Bool = true)
    -> LLErrorStatus
{
    if !isKnownInstance { return .error }
    var result: UInt32 = LLErrorStatus.success.rawValue

    if registers.instance == .tim1 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_TIM1)
        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_TIM1)
    } else if registers.instance == .tim2 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM2)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM2)
    } else if registers.instance == .tim3 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM3)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM3)
    } else if registers.instance == .tim4 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM4)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM4)
    } else if registers.instance == .tim5 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM5)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM5)
    } else if registers.instance == .tim6 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM6)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM6)
    } else if registers.instance == .tim7 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM7)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM7)
    } else if registers.instance == .tim9 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_TIM9)
        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_TIM9)
    } else if registers.instance == .tim12 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM12)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM12)
    } else if registers.instance == .tim13 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM13)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM13)
    } else if registers.instance == .tim14 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_TIM14)
        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_TIM14)
    } else if registers.instance == .tim15 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_TIM15)
        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_TIM15)
    } else if registers.instance == .tim16 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_TIM16)
        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_TIM16)
    } else if registers.instance == .tim17 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_TIM17)
        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_TIM17)
    } else {
        result = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: result)!
}

public func LL_TIM_StructInit(_ TIM_InitStruct: inout LL_TIM_InitTypeDef) {
    TIM_InitStruct.Prescaler = UInt16(truncatingIfNeeded: 0x0000)
    TIM_InitStruct.CounterMode = LL_TIM_COUNTERMODE_UP
    TIM_InitStruct.Autoreload = 0xFFFF_FFFF
    TIM_InitStruct.ClockDivision = LL_TIM_CLOCKDIVISION_DIV1
    TIM_InitStruct.RepetitionCounter = 0x0000_0000
}

public func LL_TIM_Init<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_InitStruct: LL_TIM_InitTypeDef) -> LLErrorStatus
{
    var tmpcr1: UInt32

    tmpcr1 = registers.read(TIMRegister.cr1)
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim2) || ((registers.instance) == .tim3)
        || ((registers.instance) == .tim4) || ((registers.instance) == .tim5))
    {
        tmpcr1 = (tmpcr1 & ~((0x10 | 0x60))) | (TIM_InitStruct.CounterMode)
    }
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim2) || ((registers.instance) == .tim3)
        || ((registers.instance) == .tim4) || ((registers.instance) == .tim5) || ((registers.instance) == .tim9)
        || ((registers.instance) == .tim12) || ((registers.instance) == .tim13) || ((registers.instance) == .tim14)
        || ((registers.instance) == .tim15) || ((registers.instance) == .tim16) || ((registers.instance) == .tim17))
    {
        tmpcr1 = (tmpcr1 & ~(0x300)) | (TIM_InitStruct.ClockDivision)
    }

    registers.write(TIMRegister.cr1, value: tmpcr1)

    LL_TIM_SetAutoReload(&registers, TIM_InitStruct.Autoreload)

    LL_TIM_SetPrescaler(&registers, UInt32(TIM_InitStruct.Prescaler))
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim15) || ((registers.instance) == .tim16)
        || ((registers.instance) == .tim17))
    {
        LL_TIM_SetRepetitionCounter(&registers, TIM_InitStruct.RepetitionCounter)
    }

    LL_TIM_GenerateEvent_UPDATE(&registers)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_TIM_OC_StructInit(_ TIM_OC_InitStruct: inout LL_TIM_OC_InitTypeDef) {
    TIM_OC_InitStruct.OCMode = LL_TIM_OCMODE_FROZEN
    TIM_OC_InitStruct.OCState = LL_TIM_OCSTATE_DISABLE
    TIM_OC_InitStruct.OCNState = LL_TIM_OCSTATE_DISABLE
    TIM_OC_InitStruct.CompareValue = 0x0000_0000
    TIM_OC_InitStruct.OCPolarity = LL_TIM_OCPOLARITY_HIGH
    TIM_OC_InitStruct.OCNPolarity = LL_TIM_OCPOLARITY_HIGH
    TIM_OC_InitStruct.OCIdleState = LL_TIM_OCIDLESTATE_LOW
    TIM_OC_InitStruct.OCNIdleState = LL_TIM_OCIDLESTATE_LOW
}

public func LL_TIM_OC_Init<IO: TIMRegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ TIM_OC_InitStruct: LL_TIM_OC_InitTypeDef
) -> LLErrorStatus {
    var result: UInt32 = LLErrorStatus.error.rawValue
    switch Channel
    {
    case LL_TIM_CHANNEL_CH1:
        result = _llTIMOC1Config(&registers, TIM_OC_InitStruct).rawValue
        break
    case LL_TIM_CHANNEL_CH2:
        result = _llTIMOC2Config(&registers, TIM_OC_InitStruct).rawValue
        break
    case LL_TIM_CHANNEL_CH3:
        result = _llTIMOC3Config(&registers, TIM_OC_InitStruct).rawValue
        break
    case LL_TIM_CHANNEL_CH4:
        result = _llTIMOC4Config(&registers, TIM_OC_InitStruct).rawValue
        break
    case LL_TIM_CHANNEL_CH5:
        result = _llTIMOC5Config(&registers, TIM_OC_InitStruct).rawValue
        break
    case LL_TIM_CHANNEL_CH6:
        result = _llTIMOC6Config(&registers, TIM_OC_InitStruct).rawValue
        break
    default:
        break
    }
    return LLErrorStatus(rawValue: result)!
}

public func LL_TIM_IC_StructInit(_ TIM_ICInitStruct: inout LL_TIM_IC_InitTypeDef) {
    TIM_ICInitStruct.ICPolarity = LL_TIM_IC_POLARITY_RISING
    TIM_ICInitStruct.ICActiveInput = LL_TIM_ACTIVEINPUT_DIRECTTI
    TIM_ICInitStruct.ICPrescaler = LL_TIM_ICPSC_DIV1
    TIM_ICInitStruct.ICFilter = LL_TIM_IC_FILTER_FDIV1
}

public func LL_TIM_IC_Init<IO: TIMRegisterIO>(
    _ registers: inout IO, _ Channel: UInt32, _ TIM_IC_InitStruct: LL_TIM_IC_InitTypeDef
) -> LLErrorStatus {
    var result: UInt32 = LLErrorStatus.error.rawValue
    switch Channel
    {
    case LL_TIM_CHANNEL_CH1:
        result = _llTIMIC1Config(&registers, TIM_IC_InitStruct).rawValue
        break
    case LL_TIM_CHANNEL_CH2:
        result = _llTIMIC2Config(&registers, TIM_IC_InitStruct).rawValue
        break
    case LL_TIM_CHANNEL_CH3:
        result = _llTIMIC3Config(&registers, TIM_IC_InitStruct).rawValue
        break
    case LL_TIM_CHANNEL_CH4:
        result = _llTIMIC4Config(&registers, TIM_IC_InitStruct).rawValue
        break
    default:
        break
    }
    return LLErrorStatus(rawValue: result)!
}

public func LL_TIM_ENCODER_StructInit(_ TIM_EncoderInitStruct: inout LL_TIM_ENCODER_InitTypeDef) {
    TIM_EncoderInitStruct.EncoderMode = LL_TIM_ENCODERMODE_X2_TI1
    TIM_EncoderInitStruct.IC1Polarity = LL_TIM_IC_POLARITY_RISING
    TIM_EncoderInitStruct.IC1ActiveInput = LL_TIM_ACTIVEINPUT_DIRECTTI
    TIM_EncoderInitStruct.IC1Prescaler = LL_TIM_ICPSC_DIV1
    TIM_EncoderInitStruct.IC1Filter = LL_TIM_IC_FILTER_FDIV1
    TIM_EncoderInitStruct.IC2Polarity = LL_TIM_IC_POLARITY_RISING
    TIM_EncoderInitStruct.IC2ActiveInput = LL_TIM_ACTIVEINPUT_DIRECTTI
    TIM_EncoderInitStruct.IC2Prescaler = LL_TIM_ICPSC_DIV1
    TIM_EncoderInitStruct.IC2Filter = LL_TIM_IC_FILTER_FDIV1
}

public func LL_TIM_ENCODER_Init<IO: TIMRegisterIO>(
    _ registers: inout IO, _ TIM_EncoderInitStruct: LL_TIM_ENCODER_InitTypeDef
) -> LLErrorStatus {
    var tmpccmr1: UInt32
    var tmpccer: UInt32

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & (~(0x1 | 0x10)))

    tmpccmr1 = registers.read(TIMRegister.ccmr1)

    tmpccer = registers.read(TIMRegister.ccer)

    tmpccmr1 &= ~(0x3 | 0xf0 | 0xc)
    tmpccmr1 |= (TIM_EncoderInitStruct.IC1ActiveInput >> 16)
    tmpccmr1 |= (TIM_EncoderInitStruct.IC1Filter >> 16)
    tmpccmr1 |= (TIM_EncoderInitStruct.IC1Prescaler >> 16)

    tmpccmr1 &= ~(0x300 | 0xf000 | 0xc00)
    tmpccmr1 |= (TIM_EncoderInitStruct.IC2ActiveInput >> 8)
    tmpccmr1 |= (TIM_EncoderInitStruct.IC2Filter >> 8)
    tmpccmr1 |= (TIM_EncoderInitStruct.IC2Prescaler >> 8)

    tmpccer &= ~(0x2 | 0x8 | 0x20 | 0x80)
    tmpccer |= (TIM_EncoderInitStruct.IC1Polarity)
    tmpccer |= (TIM_EncoderInitStruct.IC2Polarity << 4)
    tmpccer |= (0x1 | 0x10)

    LL_TIM_SetEncoderMode(&registers, TIM_EncoderInitStruct.EncoderMode)

    registers.write(TIMRegister.ccmr1, value: tmpccmr1)

    registers.write(TIMRegister.ccer, value: tmpccer)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_TIM_HALLSENSOR_StructInit(_ TIM_HallSensorInitStruct: inout LL_TIM_HALLSENSOR_InitTypeDef) {
    TIM_HallSensorInitStruct.IC1Polarity = LL_TIM_IC_POLARITY_RISING
    TIM_HallSensorInitStruct.IC1Prescaler = LL_TIM_ICPSC_DIV1
    TIM_HallSensorInitStruct.IC1Filter = LL_TIM_IC_FILTER_FDIV1
    TIM_HallSensorInitStruct.CommutationDelay = 0
}

public func LL_TIM_HALLSENSOR_Init<IO: TIMRegisterIO>(
    _ registers: inout IO, _ TIM_HallSensorInitStruct: LL_TIM_HALLSENSOR_InitTypeDef
) -> LLErrorStatus {
    var tmpcr2: UInt32
    var tmpccmr1: UInt32
    var tmpccer: UInt32
    var tmpsmcr: UInt32

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & (~(0x1 | 0x10)))

    tmpcr2 = registers.read(TIMRegister.cr2)

    tmpccmr1 = registers.read(TIMRegister.ccmr1)

    tmpccer = registers.read(TIMRegister.ccer)

    tmpsmcr = registers.read(TIMRegister.smcr)

    tmpcr2 |= 0x80

    tmpcr2 |= LL_TIM_TRGO_OC2REF

    tmpsmcr &= ~(0x300070 | 0x10007)
    tmpsmcr |= LL_TIM_TS_TI1F_ED
    tmpsmcr |= LL_TIM_SLAVEMODE_RESET

    tmpccmr1 &= ~(0x3 | 0xf0 | 0xc)
    tmpccmr1 |= (LL_TIM_ACTIVEINPUT_TRC >> 16)
    tmpccmr1 |= (TIM_HallSensorInitStruct.IC1Filter >> 16)
    tmpccmr1 |= (TIM_HallSensorInitStruct.IC1Prescaler >> 16)

    tmpccmr1 &= ~(0x1007000 | 0x400 | 0x800 | 0x8000)
    tmpccmr1 |= (LL_TIM_OCMODE_PWM2 << 8)

    tmpccer &= ~(0x2 | 0x8 | 0x20 | 0x80)
    tmpccer |= (TIM_HallSensorInitStruct.IC1Polarity)
    tmpccer |= (0x1 | 0x10)

    registers.write(TIMRegister.cr2, value: tmpcr2)

    registers.write(TIMRegister.smcr, value: tmpsmcr)

    registers.write(TIMRegister.ccmr1, value: tmpccmr1)

    registers.write(TIMRegister.ccer, value: tmpccer)

    LL_TIM_OC_SetCompareCH2(&registers, TIM_HallSensorInitStruct.CommutationDelay)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_TIM_BDTR_StructInit(_ TIM_BDTRInitStruct: inout LL_TIM_BDTR_InitTypeDef) {
    TIM_BDTRInitStruct.OSSRState = LL_TIM_OSSR_DISABLE
    TIM_BDTRInitStruct.OSSIState = LL_TIM_OSSI_DISABLE
    TIM_BDTRInitStruct.LockLevel = LL_TIM_LOCKLEVEL_OFF
    TIM_BDTRInitStruct.DeadTime = UInt8(truncatingIfNeeded: 0x00)
    TIM_BDTRInitStruct.BreakState = UInt16(truncatingIfNeeded: LL_TIM_BREAK_DISABLE)
    TIM_BDTRInitStruct.BreakPolarity = LL_TIM_BREAK_POLARITY_LOW
    TIM_BDTRInitStruct.BreakFilter = LL_TIM_BREAK_FILTER_FDIV1
    TIM_BDTRInitStruct.BreakAFMode = LL_TIM_BREAK_AFMODE_INPUT
    TIM_BDTRInitStruct.Break2State = LL_TIM_BREAK2_DISABLE
    TIM_BDTRInitStruct.Break2Polarity = LL_TIM_BREAK2_POLARITY_LOW
    TIM_BDTRInitStruct.Break2Filter = LL_TIM_BREAK2_FILTER_FDIV1
    TIM_BDTRInitStruct.Break2AFMode = LL_TIM_BREAK2_AFMODE_INPUT
    TIM_BDTRInitStruct.AutomaticOutput = LL_TIM_AUTOMATICOUTPUT_DISABLE
}

public func LL_TIM_BDTR_Init<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_BDTRInitStruct: LL_TIM_BDTR_InitTypeDef)
    -> LLErrorStatus
{
    var tmpbdtr: UInt32 = 0

    tmpbdtr = (tmpbdtr & ~(0xff)) | (UInt32(TIM_BDTRInitStruct.DeadTime))
    tmpbdtr = (tmpbdtr & ~(0x300)) | (TIM_BDTRInitStruct.LockLevel)
    tmpbdtr = (tmpbdtr & ~(0x400)) | (TIM_BDTRInitStruct.OSSIState)
    tmpbdtr = (tmpbdtr & ~(0x800)) | (TIM_BDTRInitStruct.OSSRState)
    tmpbdtr = (tmpbdtr & ~(0x1000)) | (UInt32(TIM_BDTRInitStruct.BreakState))
    tmpbdtr = (tmpbdtr & ~(0x2000)) | (TIM_BDTRInitStruct.BreakPolarity)
    tmpbdtr = (tmpbdtr & ~(0x4000)) | (TIM_BDTRInitStruct.AutomaticOutput)
    tmpbdtr = (tmpbdtr & ~(0xf0000)) | (TIM_BDTRInitStruct.BreakFilter)
    tmpbdtr = (tmpbdtr & ~(0x1000_0000)) | (TIM_BDTRInitStruct.BreakAFMode)
    if ((registers.instance) == .tim1) {

        tmpbdtr = (tmpbdtr & ~(0xf00000)) | ((TIM_BDTRInitStruct.Break2Filter))
        tmpbdtr = (tmpbdtr & ~(0x1000000)) | (TIM_BDTRInitStruct.Break2State)
        tmpbdtr = (tmpbdtr & ~(0x2000000)) | (TIM_BDTRInitStruct.Break2Polarity)
        tmpbdtr = (tmpbdtr & ~(0x2000_0000)) | (TIM_BDTRInitStruct.Break2AFMode)
    }

    registers.write(TIMRegister.bdtr, value: tmpbdtr)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMOC1Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_OCInitStruct: LL_TIM_OC_InitTypeDef)
    -> LLErrorStatus
{
    var tmpccmr1: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & ~(0x1))

    tmpccer = registers.read(TIMRegister.ccer)

    tmpcr2 = registers.read(TIMRegister.cr2)

    tmpccmr1 = registers.read(TIMRegister.ccmr1)

    tmpccmr1 = tmpccmr1 & ~(0x3)

    tmpccmr1 = (tmpccmr1 & ~(0x10070)) | (TIM_OCInitStruct.OCMode)

    tmpccer = (tmpccer & ~(0x2)) | (TIM_OCInitStruct.OCPolarity)

    tmpccer = (tmpccer & ~(0x1)) | (TIM_OCInitStruct.OCState)
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim15) || ((registers.instance) == .tim16)
        || ((registers.instance) == .tim17))
    {

        tmpccer = (tmpccer & ~(0x8)) | (TIM_OCInitStruct.OCNPolarity << 2)

        tmpccer = (tmpccer & ~(0x4)) | (TIM_OCInitStruct.OCNState << 2)

        tmpcr2 = (tmpcr2 & ~(0x100)) | (TIM_OCInitStruct.OCIdleState)

        tmpcr2 = (tmpcr2 & ~(0x200)) | (TIM_OCInitStruct.OCNIdleState << 1)
    }

    registers.write(TIMRegister.cr2, value: tmpcr2)

    registers.write(TIMRegister.ccmr1, value: tmpccmr1)

    LL_TIM_OC_SetCompareCH1(&registers, TIM_OCInitStruct.CompareValue)

    registers.write(TIMRegister.ccer, value: tmpccer)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMOC2Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_OCInitStruct: LL_TIM_OC_InitTypeDef)
    -> LLErrorStatus
{
    var tmpccmr1: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & ~(0x10))

    tmpccer = registers.read(TIMRegister.ccer)

    tmpcr2 = registers.read(TIMRegister.cr2)

    tmpccmr1 = registers.read(TIMRegister.ccmr1)

    tmpccmr1 = tmpccmr1 & ~(0x300)

    tmpccmr1 = (tmpccmr1 & ~(0x1007000)) | (TIM_OCInitStruct.OCMode << 8)

    tmpccer = (tmpccer & ~(0x20)) | (TIM_OCInitStruct.OCPolarity << 4)

    tmpccer = (tmpccer & ~(0x10)) | (TIM_OCInitStruct.OCState << 4)
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim15) || ((registers.instance) == .tim16)
        || ((registers.instance) == .tim17))
    {

        tmpccer = (tmpccer & ~(0x80)) | (TIM_OCInitStruct.OCNPolarity << 6)

        tmpccer = (tmpccer & ~(0x40)) | (TIM_OCInitStruct.OCNState << 6)

        tmpcr2 = (tmpcr2 & ~(0x400)) | (TIM_OCInitStruct.OCIdleState << 2)

        tmpcr2 = (tmpcr2 & ~(0x800)) | (TIM_OCInitStruct.OCNIdleState << 3)
    }

    registers.write(TIMRegister.cr2, value: tmpcr2)

    registers.write(TIMRegister.ccmr1, value: tmpccmr1)

    LL_TIM_OC_SetCompareCH2(&registers, TIM_OCInitStruct.CompareValue)

    registers.write(TIMRegister.ccer, value: tmpccer)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMOC3Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_OCInitStruct: LL_TIM_OC_InitTypeDef)
    -> LLErrorStatus
{
    var tmpccmr2: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & ~(0x100))

    tmpccer = registers.read(TIMRegister.ccer)

    tmpcr2 = registers.read(TIMRegister.cr2)

    tmpccmr2 = registers.read(TIMRegister.ccmr2)

    tmpccmr2 = tmpccmr2 & ~(0x3)

    tmpccmr2 = (tmpccmr2 & ~(0x10070)) | (TIM_OCInitStruct.OCMode)

    tmpccer = (tmpccer & ~(0x200)) | (TIM_OCInitStruct.OCPolarity << 8)

    tmpccer = (tmpccer & ~(0x100)) | (TIM_OCInitStruct.OCState << 8)
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim15) || ((registers.instance) == .tim16)
        || ((registers.instance) == .tim17))
    {

        tmpccer = (tmpccer & ~(0x800)) | (TIM_OCInitStruct.OCNPolarity << 10)

        tmpccer = (tmpccer & ~(0x400)) | (TIM_OCInitStruct.OCNState << 10)

        tmpcr2 = (tmpcr2 & ~(0x1000)) | (TIM_OCInitStruct.OCIdleState << 4)

        tmpcr2 = (tmpcr2 & ~(0x2000)) | (TIM_OCInitStruct.OCNIdleState << 5)
    }

    registers.write(TIMRegister.cr2, value: tmpcr2)

    registers.write(TIMRegister.ccmr2, value: tmpccmr2)

    LL_TIM_OC_SetCompareCH3(&registers, TIM_OCInitStruct.CompareValue)

    registers.write(TIMRegister.ccer, value: tmpccer)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMOC4Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_OCInitStruct: LL_TIM_OC_InitTypeDef)
    -> LLErrorStatus
{
    var tmpccmr2: UInt32
    var tmpccer: UInt32
    var tmpcr2: UInt32

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & ~(0x1000))

    tmpccer = registers.read(TIMRegister.ccer)

    tmpcr2 = registers.read(TIMRegister.cr2)

    tmpccmr2 = registers.read(TIMRegister.ccmr2)

    tmpccmr2 = tmpccmr2 & ~(0x300)

    tmpccmr2 = (tmpccmr2 & ~(0x1007000)) | (TIM_OCInitStruct.OCMode << 8)

    tmpccer = (tmpccer & ~(0x2000)) | (TIM_OCInitStruct.OCPolarity << 12)

    tmpccer = (tmpccer & ~(0x1000)) | (TIM_OCInitStruct.OCState << 12)
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim15) || ((registers.instance) == .tim16)
        || ((registers.instance) == .tim17))
    {

        tmpccer = (tmpccer & ~(0x8000)) | (TIM_OCInitStruct.OCNPolarity << 14)

        tmpccer = (tmpccer & ~(0x4000)) | (TIM_OCInitStruct.OCNState << 14)

        tmpcr2 = (tmpcr2 & ~(0x4000)) | (TIM_OCInitStruct.OCIdleState << 6)

        tmpcr2 = (tmpcr2 & ~(0x8000)) | (TIM_OCInitStruct.OCNIdleState << 7)
    }

    registers.write(TIMRegister.cr2, value: tmpcr2)

    registers.write(TIMRegister.ccmr2, value: tmpccmr2)

    LL_TIM_OC_SetCompareCH4(&registers, TIM_OCInitStruct.CompareValue)

    registers.write(TIMRegister.ccer, value: tmpccer)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMOC5Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_OCInitStruct: LL_TIM_OC_InitTypeDef)
    -> LLErrorStatus
{
    var tmpccmr3: UInt32
    var tmpccer: UInt32

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & ~(0x10000))

    tmpccer = registers.read(TIMRegister.ccer)

    tmpccmr3 = registers.read(TIMRegister.ccmr3)

    tmpccmr3 = (tmpccmr3 & ~(0x10070)) | (TIM_OCInitStruct.OCMode)

    tmpccer = (tmpccer & ~(0x20000)) | (TIM_OCInitStruct.OCPolarity << 16)

    tmpccer = (tmpccer & ~(0x10000)) | (TIM_OCInitStruct.OCState << 16)
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim15) || ((registers.instance) == .tim16)
        || ((registers.instance) == .tim17))
    {

        registers.write(
            TIMRegister.cr2, value: (registers.read(TIMRegister.cr2) & ~(0x10000)) | (TIM_OCInitStruct.OCIdleState << 8)
        )
    }

    registers.write(TIMRegister.ccmr3, value: tmpccmr3)

    LL_TIM_OC_SetCompareCH5(&registers, TIM_OCInitStruct.CompareValue)

    registers.write(TIMRegister.ccer, value: tmpccer)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMOC6Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_OCInitStruct: LL_TIM_OC_InitTypeDef)
    -> LLErrorStatus
{
    var tmpccmr3: UInt32
    var tmpccer: UInt32

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & ~(0x100000))

    tmpccer = registers.read(TIMRegister.ccer)

    tmpccmr3 = registers.read(TIMRegister.ccmr3)

    tmpccmr3 = (tmpccmr3 & ~(0x1007000)) | (TIM_OCInitStruct.OCMode << 8)

    tmpccer = (tmpccer & ~(0x200000)) | (TIM_OCInitStruct.OCPolarity << 20)

    tmpccer = (tmpccer & ~(0x100000)) | (TIM_OCInitStruct.OCState << 20)
    if (((registers.instance) == .tim1) || ((registers.instance) == .tim15) || ((registers.instance) == .tim16)
        || ((registers.instance) == .tim17))
    {

        registers.write(
            TIMRegister.cr2,
            value: (registers.read(TIMRegister.cr2) & ~(0x40000)) | (TIM_OCInitStruct.OCIdleState << 10))
    }

    registers.write(TIMRegister.ccmr3, value: tmpccmr3)

    LL_TIM_OC_SetCompareCH6(&registers, TIM_OCInitStruct.CompareValue)

    registers.write(TIMRegister.ccer, value: tmpccer)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMIC1Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_ICInitStruct: LL_TIM_IC_InitTypeDef)
    -> LLErrorStatus
{

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & (~0x1))

    registers.write(
        TIMRegister.ccmr1,
        value: (registers.read(TIMRegister.ccmr1) & ~((0x3 | 0xf0 | 0xc)))
            | ((TIM_ICInitStruct.ICActiveInput | TIM_ICInitStruct.ICFilter | TIM_ICInitStruct.ICPrescaler) >> 16))

    registers.write(
        TIMRegister.ccer,
        value: (registers.read(TIMRegister.ccer) & ~((0x2 | 0x8))) | ((TIM_ICInitStruct.ICPolarity | 0x1)))
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMIC2Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_ICInitStruct: LL_TIM_IC_InitTypeDef)
    -> LLErrorStatus
{

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & (~0x10))

    registers.write(
        TIMRegister.ccmr1,
        value: (registers.read(TIMRegister.ccmr1) & ~((0x300 | 0xf000 | 0xc00)))
            | ((TIM_ICInitStruct.ICActiveInput | TIM_ICInitStruct.ICFilter | TIM_ICInitStruct.ICPrescaler) >> 8))

    registers.write(
        TIMRegister.ccer,
        value: (registers.read(TIMRegister.ccer) & ~((0x20 | 0x80))) | (((TIM_ICInitStruct.ICPolarity << 4) | 0x10)))
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMIC3Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_ICInitStruct: LL_TIM_IC_InitTypeDef)
    -> LLErrorStatus
{

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & (~0x100))

    registers.write(
        TIMRegister.ccmr2,
        value: (registers.read(TIMRegister.ccmr2) & ~((0x3 | 0xf0 | 0xc)))
            | ((TIM_ICInitStruct.ICActiveInput | TIM_ICInitStruct.ICFilter | TIM_ICInitStruct.ICPrescaler) >> 16))

    registers.write(
        TIMRegister.ccer,
        value: (registers.read(TIMRegister.ccer) & ~((0x200 | 0x800))) | (((TIM_ICInitStruct.ICPolarity << 8) | 0x100)))
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

private func _llTIMIC4Config<IO: TIMRegisterIO>(_ registers: inout IO, _ TIM_ICInitStruct: LL_TIM_IC_InitTypeDef)
    -> LLErrorStatus
{

    registers.write(TIMRegister.ccer, value: registers.read(TIMRegister.ccer) & (~0x1000))

    registers.write(
        TIMRegister.ccmr2,
        value: (registers.read(TIMRegister.ccmr2) & ~((0x300 | 0xf000 | 0xc00)))
            | ((TIM_ICInitStruct.ICActiveInput | TIM_ICInitStruct.ICFilter | TIM_ICInitStruct.ICPrescaler) >> 8))

    registers.write(
        TIMRegister.ccer,
        value: (registers.read(TIMRegister.ccer) & ~((0x2000 | 0x8000)))
            | (((TIM_ICInitStruct.ICPolarity << 12) | 0x1000)))
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}
