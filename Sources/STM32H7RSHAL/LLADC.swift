// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from stm32h7rsxx_ll_adc.h/.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// CMSIS encodings: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_ADC_FLAG_ADRDY: UInt32 = 0x0000_0001
public let LL_ADC_FLAG_EOC: UInt32 = 0x0000_0004
public let LL_ADC_FLAG_EOS: UInt32 = 0x0000_0008
public let LL_ADC_FLAG_OVR: UInt32 = 0x0000_0010
public let LL_ADC_FLAG_EOSMP: UInt32 = 0x0000_0002
public let LL_ADC_FLAG_JEOC: UInt32 = 0x0000_0020
public let LL_ADC_FLAG_JEOS: UInt32 = 0x0000_0040
public let LL_ADC_FLAG_JQOVF: UInt32 = 0x0000_0400
public let LL_ADC_FLAG_AWD1: UInt32 = ADCC.LL_ADC_FLAG_AWD1
public let LL_ADC_FLAG_AWD2: UInt32 = ADCC.LL_ADC_FLAG_AWD2
public let LL_ADC_FLAG_AWD3: UInt32 = ADCC.LL_ADC_FLAG_AWD3
public let LL_ADC_FLAG_ADRDY_MST: UInt32 = 0x0000_0001
public let LL_ADC_FLAG_ADRDY_SLV: UInt32 = 0x0001_0000
public let LL_ADC_FLAG_EOC_MST: UInt32 = 0x0000_0004
public let LL_ADC_FLAG_EOC_SLV: UInt32 = 0x0004_0000
public let LL_ADC_FLAG_EOS_MST: UInt32 = 0x0000_0008
public let LL_ADC_FLAG_EOS_SLV: UInt32 = 0x0008_0000
public let LL_ADC_FLAG_OVR_MST: UInt32 = 0x0000_0010
public let LL_ADC_FLAG_OVR_SLV: UInt32 = 0x0010_0000
public let LL_ADC_FLAG_EOSMP_MST: UInt32 = 0x0000_0002
public let LL_ADC_FLAG_EOSMP_SLV: UInt32 = 0x0002_0000
public let LL_ADC_FLAG_JEOC_MST: UInt32 = 0x0000_0020
public let LL_ADC_FLAG_JEOC_SLV: UInt32 = 0x0020_0000
public let LL_ADC_FLAG_JEOS_MST: UInt32 = 0x0000_0040
public let LL_ADC_FLAG_JEOS_SLV: UInt32 = 0x0040_0000
public let LL_ADC_FLAG_JQOVF_MST: UInt32 = 0x0000_0400
public let LL_ADC_FLAG_JQOVF_SLV: UInt32 = 0x0400_0000
public let LL_ADC_FLAG_AWD1_MST: UInt32 = 0x0000_0080
public let LL_ADC_FLAG_AWD1_SLV: UInt32 = 0x0080_0000
public let LL_ADC_FLAG_AWD2_MST: UInt32 = 0x0000_0100
public let LL_ADC_FLAG_AWD2_SLV: UInt32 = 0x0100_0000
public let LL_ADC_FLAG_AWD3_MST: UInt32 = 0x0000_0200
public let LL_ADC_FLAG_AWD3_SLV: UInt32 = 0x0200_0000
public let LL_ADC_IT_ADRDY: UInt32 = 0x0000_0001
public let LL_ADC_IT_EOC: UInt32 = 0x0000_0004
public let LL_ADC_IT_EOS: UInt32 = 0x0000_0008
public let LL_ADC_IT_OVR: UInt32 = 0x0000_0010
public let LL_ADC_IT_EOSMP: UInt32 = 0x0000_0002
public let LL_ADC_IT_JEOC: UInt32 = 0x0000_0020
public let LL_ADC_IT_JEOS: UInt32 = 0x0000_0040
public let LL_ADC_IT_JQOVF: UInt32 = 0x0000_0400
public let LL_ADC_IT_AWD1: UInt32 = ADCC.LL_ADC_IT_AWD1
public let LL_ADC_IT_AWD2: UInt32 = ADCC.LL_ADC_IT_AWD2
public let LL_ADC_IT_AWD3: UInt32 = ADCC.LL_ADC_IT_AWD3
public let LL_ADC_DMA_REG_REGULAR_DATA: UInt32 = 0x0000_0000
public let LL_ADC_DMA_REG_REGULAR_DATA_MULTI: UInt32 = 0x0000_0001
public let LL_ADC_CLOCK_SYNC_PCLK_DIV1: UInt32 = 0x0001_0000
public let LL_ADC_CLOCK_SYNC_PCLK_DIV2: UInt32 = 0x0002_0000
public let LL_ADC_CLOCK_SYNC_PCLK_DIV4: UInt32 = 0x0003_0000
public let LL_ADC_CLOCK_ASYNC_DIV1: UInt32 = 0x0000_0000
public let LL_ADC_CLOCK_ASYNC_DIV2: UInt32 = 0x0004_0000
public let LL_ADC_CLOCK_ASYNC_DIV4: UInt32 = 0x0008_0000
public let LL_ADC_CLOCK_ASYNC_DIV6: UInt32 = 0x000C_0000
public let LL_ADC_CLOCK_ASYNC_DIV8: UInt32 = 0x0010_0000
public let LL_ADC_CLOCK_ASYNC_DIV10: UInt32 = 0x0014_0000
public let LL_ADC_CLOCK_ASYNC_DIV12: UInt32 = 0x0018_0000
public let LL_ADC_CLOCK_ASYNC_DIV16: UInt32 = 0x001C_0000
public let LL_ADC_CLOCK_ASYNC_DIV32: UInt32 = 0x0020_0000
public let LL_ADC_CLOCK_ASYNC_DIV64: UInt32 = 0x0024_0000
public let LL_ADC_CLOCK_ASYNC_DIV128: UInt32 = 0x0028_0000
public let LL_ADC_CLOCK_ASYNC_DIV256: UInt32 = 0x002C_0000
public let LL_ADC_PATH_INTERNAL_NONE: UInt32 = 0x0000_0000
public let LL_ADC_PATH_INTERNAL_VREFINT: UInt32 = ADCC.LL_ADC_PATH_INTERNAL_VREFINT
public let LL_ADC_PATH_INTERNAL_TEMPSENSOR: UInt32 = ADCC.LL_ADC_PATH_INTERNAL_TEMPSENSOR
public let LL_ADC_PATH_INTERNAL_VBAT: UInt32 = ADCC.LL_ADC_PATH_INTERNAL_VBAT
public let LL_ADC_PATH_INTERNAL_VDDCORE: UInt32 = ADCC.LL_ADC_PATH_INTERNAL_VDDCORE
public let LL_ADC_RESOLUTION_12B: UInt32 = 0x0000_0000
public let LL_ADC_RESOLUTION_10B: UInt32 = 0x0000_0008
public let LL_ADC_RESOLUTION_8B: UInt32 = 0x0000_0010
public let LL_ADC_RESOLUTION_6B: UInt32 = 0x0000_0018
public let LL_ADC_DATA_ALIGN_RIGHT: UInt32 = 0x0000_0000
public let LL_ADC_DATA_ALIGN_LEFT: UInt32 = 0x0000_8000
public let LL_ADC_LP_MODE_NONE: UInt32 = 0x0000_0000
public let LL_ADC_LP_AUTOWAIT: UInt32 = 0x0000_4000
public let LL_ADC_OFFSET_1: UInt32 = ADCC.LL_ADC_OFFSET_1
public let LL_ADC_OFFSET_2: UInt32 = ADCC.LL_ADC_OFFSET_2
public let LL_ADC_OFFSET_3: UInt32 = ADCC.LL_ADC_OFFSET_3
public let LL_ADC_OFFSET_4: UInt32 = ADCC.LL_ADC_OFFSET_4
public let LL_ADC_OFFSET_DISABLE: UInt32 = ADCC.LL_ADC_OFFSET_DISABLE
public let LL_ADC_OFFSET_ENABLE: UInt32 = 0x8000_0000
public let LL_ADC_OFFSET_SIGN_NEGATIVE: UInt32 = 0x0000_0000
public let LL_ADC_OFFSET_SIGN_POSITIVE: UInt32 = 0x0100_0000
public let LL_ADC_OFFSET_SATURATION_DISABLE: UInt32 = ADCC.LL_ADC_OFFSET_SATURATION_DISABLE
public let LL_ADC_OFFSET_SATURATION_ENABLE: UInt32 = ADCC.LL_ADC_OFFSET_SATURATION_ENABLE
public let LL_ADC_GROUP_REGULAR: UInt32 = ADCC.LL_ADC_GROUP_REGULAR
public let LL_ADC_GROUP_INJECTED: UInt32 = ADCC.LL_ADC_GROUP_INJECTED
public let LL_ADC_GROUP_REGULAR_INJECTED: UInt32 = ADCC.LL_ADC_GROUP_REGULAR_INJECTED
public let LL_ADC_CHANNEL_0: UInt32 = 0x0000_0001
public let LL_ADC_CHANNEL_1: UInt32 = 0x0430_0002
public let LL_ADC_CHANNEL_2: UInt32 = 0x0860_0004
public let LL_ADC_CHANNEL_3: UInt32 = 0x0C90_0008
public let LL_ADC_CHANNEL_4: UInt32 = 0x10C0_0010
public let LL_ADC_CHANNEL_5: UInt32 = 0x14F0_0020
public let LL_ADC_CHANNEL_6: UInt32 = 0x1920_0040
public let LL_ADC_CHANNEL_7: UInt32 = 0x1D50_0080
public let LL_ADC_CHANNEL_8: UInt32 = 0x2180_0100
public let LL_ADC_CHANNEL_9: UInt32 = 0x25B0_0200
public let LL_ADC_CHANNEL_10: UInt32 = 0x2A00_0400
public let LL_ADC_CHANNEL_11: UInt32 = 0x2E30_0800
public let LL_ADC_CHANNEL_12: UInt32 = 0x3260_1000
public let LL_ADC_CHANNEL_13: UInt32 = 0x3690_2000
public let LL_ADC_CHANNEL_14: UInt32 = 0x3AC0_4000
public let LL_ADC_CHANNEL_15: UInt32 = 0x3EF0_8000
public let LL_ADC_CHANNEL_16: UInt32 = 0x4321_0000
public let LL_ADC_CHANNEL_17: UInt32 = 0x4752_0000
public let LL_ADC_CHANNEL_18: UInt32 = 0x4B84_0000
public let LL_ADC_CHANNEL_VREFINT: UInt32 = 0xC752_0000
public let LL_ADC_CHANNEL_TEMPSENSOR: UInt32 = 0xC321_0000
public let LL_ADC_CHANNEL_VBAT: UInt32 = 0x4329_0000
public let LL_ADC_CHANNEL_VDDCORE: UInt32 = 0x475A_0000
public let LL_ADC_REG_TRIG_SOFTWARE: UInt32 = ADCC.LL_ADC_REG_TRIG_SOFTWARE
public let LL_ADC_REG_TRIG_EXT_TIM1_CH1: UInt32 = 0x0000_0400
public let LL_ADC_REG_TRIG_EXT_TIM1_CH2: UInt32 = 0x0000_0420
public let LL_ADC_REG_TRIG_EXT_TIM1_CH3: UInt32 = 0x0000_0440
public let LL_ADC_REG_TRIG_EXT_TIM2_CH2: UInt32 = 0x0000_0460
public let LL_ADC_REG_TRIG_EXT_TIM3_TRGO: UInt32 = 0x0000_0480
public let LL_ADC_REG_TRIG_EXT_TIM4_CH4: UInt32 = 0x0000_04A0
public let LL_ADC_REG_TRIG_EXT_EXTI_LINE11: UInt32 = 0x0000_04C0
public let LL_ADC_REG_TRIG_EXT_TIM12_TRGO: UInt32 = 0x0000_04E0
public let LL_ADC_REG_TRIG_EXT_TIM9_TRGO: UInt32 = 0x0000_0500
public let LL_ADC_REG_TRIG_EXT_TIM1_TRGO: UInt32 = 0x0000_0520
public let LL_ADC_REG_TRIG_EXT_TIM1_TRGO2: UInt32 = 0x0000_0540
public let LL_ADC_REG_TRIG_EXT_TIM2_TRGO: UInt32 = 0x0000_0560
public let LL_ADC_REG_TRIG_EXT_TIM4_TRGO: UInt32 = 0x0000_0580
public let LL_ADC_REG_TRIG_EXT_TIM6_TRGO: UInt32 = 0x0000_05A0
public let LL_ADC_REG_TRIG_EXT_TIM15_TRGO: UInt32 = 0x0000_05C0
public let LL_ADC_REG_TRIG_EXT_TIM3_CH4: UInt32 = 0x0000_05E0
public let LL_ADC_REG_TRIG_EXT_LPTIM1_CH1: UInt32 = 0x0000_0640
public let LL_ADC_REG_TRIG_EXT_LPTIM2_CH1: UInt32 = 0x0000_0660
public let LL_ADC_REG_TRIG_EXT_LPTIM3_CH1: UInt32 = 0x0000_0680
public let LL_ADC_REG_TRIG_EXT_RISING: UInt32 = 0x0000_0400
public let LL_ADC_REG_TRIG_EXT_FALLING: UInt32 = 0x0000_0800
public let LL_ADC_REG_TRIG_EXT_RISINGFALLING: UInt32 = 0x0000_0C00
public let LL_ADC_REG_SAMPLING_MODE_NORMAL: UInt32 = 0x0000_0000
public let LL_ADC_REG_SAMPLING_MODE_BULB: UInt32 = 0x0400_0000
public let LL_ADC_REG_SAMPLING_MODE_TRIGGER_CONTROLED: UInt32 = 0x0800_0000
public let LL_ADC_REG_CONV_SINGLE: UInt32 = 0x0000_0000
public let LL_ADC_REG_CONV_CONTINUOUS: UInt32 = 0x0000_2000
public let LL_ADC_REG_DMA_TRANSFER_NONE: UInt32 = 0x0000_0000
public let LL_ADC_REG_DMA_TRANSFER_LIMITED: UInt32 = 0x0000_0001
public let LL_ADC_REG_DMA_TRANSFER_UNLIMITED: UInt32 = 0x0000_0003
public let LL_ADC_REG_MDF_TRANSFER_NONE: UInt32 = 0x0000_0000
public let LL_ADC_REG_MDF_TRANSFER_ENABLE: UInt32 = 0x0000_0004
public let LL_ADC_SAMPLINGTIME_COMMON_DEFAULT: UInt32 = ADCC.LL_ADC_SAMPLINGTIME_COMMON_DEFAULT
public let LL_ADC_SAMPLINGTIME_COMMON_3C5_REPL_2C5: UInt32 = ADCC.LL_ADC_SAMPLINGTIME_COMMON_3C5_REPL_2C5
public let LL_ADC_REG_OVR_DATA_PRESERVED: UInt32 = 0x0000_0000
public let LL_ADC_REG_OVR_DATA_OVERWRITTEN: UInt32 = 0x0000_1000
public let LL_ADC_REG_SEQ_SCAN_DISABLE: UInt32 = 0x0000_0000
public let LL_ADC_REG_SEQ_SCAN_ENABLE_2RANKS: UInt32 = 0x0000_0001
public let LL_ADC_REG_SEQ_SCAN_ENABLE_3RANKS: UInt32 = 0x0000_0002
public let LL_ADC_REG_SEQ_SCAN_ENABLE_4RANKS: UInt32 = 0x0000_0003
public let LL_ADC_REG_SEQ_SCAN_ENABLE_5RANKS: UInt32 = 0x0000_0004
public let LL_ADC_REG_SEQ_SCAN_ENABLE_6RANKS: UInt32 = 0x0000_0005
public let LL_ADC_REG_SEQ_SCAN_ENABLE_7RANKS: UInt32 = 0x0000_0006
public let LL_ADC_REG_SEQ_SCAN_ENABLE_8RANKS: UInt32 = 0x0000_0007
public let LL_ADC_REG_SEQ_SCAN_ENABLE_9RANKS: UInt32 = 0x0000_0008
public let LL_ADC_REG_SEQ_SCAN_ENABLE_10RANKS: UInt32 = 0x0000_0009
public let LL_ADC_REG_SEQ_SCAN_ENABLE_11RANKS: UInt32 = 0x0000_000A
public let LL_ADC_REG_SEQ_SCAN_ENABLE_12RANKS: UInt32 = 0x0000_000B
public let LL_ADC_REG_SEQ_SCAN_ENABLE_13RANKS: UInt32 = 0x0000_000C
public let LL_ADC_REG_SEQ_SCAN_ENABLE_14RANKS: UInt32 = 0x0000_000D
public let LL_ADC_REG_SEQ_SCAN_ENABLE_15RANKS: UInt32 = 0x0000_000E
public let LL_ADC_REG_SEQ_SCAN_ENABLE_16RANKS: UInt32 = 0x0000_000F
public let LL_ADC_REG_SEQ_DISCONT_DISABLE: UInt32 = 0x0000_0000
public let LL_ADC_REG_SEQ_DISCONT_1RANK: UInt32 = 0x0001_0000
public let LL_ADC_REG_SEQ_DISCONT_2RANKS: UInt32 = 0x0003_0000
public let LL_ADC_REG_SEQ_DISCONT_3RANKS: UInt32 = 0x0005_0000
public let LL_ADC_REG_SEQ_DISCONT_4RANKS: UInt32 = 0x0007_0000
public let LL_ADC_REG_SEQ_DISCONT_5RANKS: UInt32 = 0x0009_0000
public let LL_ADC_REG_SEQ_DISCONT_6RANKS: UInt32 = 0x000B_0000
public let LL_ADC_REG_SEQ_DISCONT_7RANKS: UInt32 = 0x000D_0000
public let LL_ADC_REG_SEQ_DISCONT_8RANKS: UInt32 = 0x000F_0000
public let LL_ADC_REG_RANK_1: UInt32 = 0x0000_0006
public let LL_ADC_REG_RANK_2: UInt32 = 0x0000_000C
public let LL_ADC_REG_RANK_3: UInt32 = 0x0000_0012
public let LL_ADC_REG_RANK_4: UInt32 = 0x0000_0018
public let LL_ADC_REG_RANK_5: UInt32 = 0x0000_0100
public let LL_ADC_REG_RANK_6: UInt32 = 0x0000_0106
public let LL_ADC_REG_RANK_7: UInt32 = 0x0000_010C
public let LL_ADC_REG_RANK_8: UInt32 = 0x0000_0112
public let LL_ADC_REG_RANK_9: UInt32 = 0x0000_0118
public let LL_ADC_REG_RANK_10: UInt32 = 0x0000_0200
public let LL_ADC_REG_RANK_11: UInt32 = 0x0000_0206
public let LL_ADC_REG_RANK_12: UInt32 = 0x0000_020C
public let LL_ADC_REG_RANK_13: UInt32 = 0x0000_0212
public let LL_ADC_REG_RANK_14: UInt32 = 0x0000_0218
public let LL_ADC_REG_RANK_15: UInt32 = 0x0000_0300
public let LL_ADC_REG_RANK_16: UInt32 = 0x0000_0306
public let LL_ADC_INJ_TRIG_SOFTWARE: UInt32 = ADCC.LL_ADC_INJ_TRIG_SOFTWARE
public let LL_ADC_INJ_TRIG_EXT_TIM1_TRGO: UInt32 = 0x0000_0080
public let LL_ADC_INJ_TRIG_EXT_TIM1_CH4: UInt32 = 0x0000_0084
public let LL_ADC_INJ_TRIG_EXT_TIM2_TRGO: UInt32 = 0x0000_0088
public let LL_ADC_INJ_TRIG_EXT_TIM2_CH1: UInt32 = 0x0000_008C
public let LL_ADC_INJ_TRIG_EXT_TIM3_CH4: UInt32 = 0x0000_0090
public let LL_ADC_INJ_TRIG_EXT_TIM4_TRGO: UInt32 = 0x0000_0094
public let LL_ADC_INJ_TRIG_EXT_EXTI_LINE15: UInt32 = 0x0000_0098
public let LL_ADC_INJ_TRIG_EXT_TIM9_CH1: UInt32 = 0x0000_009C
public let LL_ADC_INJ_TRIG_EXT_TIM1_TRGO2: UInt32 = 0x0000_00A0
public let LL_ADC_INJ_TRIG_EXT_TIM12_TRGO: UInt32 = 0x0000_00A4
public let LL_ADC_INJ_TRIG_EXT_TIM9_TRGO: UInt32 = 0x0000_00A8
public let LL_ADC_INJ_TRIG_EXT_TIM3_CH3: UInt32 = 0x0000_00AC
public let LL_ADC_INJ_TRIG_EXT_TIM3_TRGO: UInt32 = 0x0000_00B0
public let LL_ADC_INJ_TRIG_EXT_TIM3_CH1: UInt32 = 0x0000_00B4
public let LL_ADC_INJ_TRIG_EXT_TIM6_TRGO: UInt32 = 0x0000_00B8
public let LL_ADC_INJ_TRIG_EXT_TIM15_TRGO: UInt32 = 0x0000_00BC
public let LL_ADC_INJ_TRIG_EXT_LPTIM1_CH2: UInt32 = 0x0000_00C8
public let LL_ADC_INJ_TRIG_EXT_LPTIM2_CH2: UInt32 = 0x0000_00CC
public let LL_ADC_INJ_TRIG_EXT_LPTIM3_CH1: UInt32 = 0x0000_00D0
public let LL_ADC_INJ_TRIG_EXT_RISING: UInt32 = 0x0000_0080
public let LL_ADC_INJ_TRIG_EXT_FALLING: UInt32 = 0x0000_0100
public let LL_ADC_INJ_TRIG_EXT_RISINGFALLING: UInt32 = 0x0000_0180
public let LL_ADC_INJ_TRIG_INDEPENDENT: UInt32 = ADCC.LL_ADC_INJ_TRIG_INDEPENDENT
public let LL_ADC_INJ_TRIG_FROM_GRP_REGULAR: UInt32 = 0x0200_0000
public let LL_ADC_INJ_QUEUE_2CONTEXTS_LAST_ACTIVE: UInt32 = 0x0000_0000
public let LL_ADC_INJ_QUEUE_2CONTEXTS_END_EMPTY: UInt32 = 0x0020_0000
public let LL_ADC_INJ_QUEUE_DISABLE: UInt32 = ADCC.LL_ADC_INJ_QUEUE_DISABLE
public let LL_ADC_INJ_SEQ_SCAN_DISABLE: UInt32 = 0x0000_0000
public let LL_ADC_INJ_SEQ_SCAN_ENABLE_2RANKS: UInt32 = 0x0000_0001
public let LL_ADC_INJ_SEQ_SCAN_ENABLE_3RANKS: UInt32 = 0x0000_0002
public let LL_ADC_INJ_SEQ_SCAN_ENABLE_4RANKS: UInt32 = 0x0000_0003
public let LL_ADC_INJ_SEQ_DISCONT_DISABLE: UInt32 = 0x0000_0000
public let LL_ADC_INJ_SEQ_DISCONT_1RANK: UInt32 = 0x0010_0000
public let LL_ADC_INJ_RANK_1: UInt32 = 0x0000_0009
public let LL_ADC_INJ_RANK_2: UInt32 = 0x0000_010F
public let LL_ADC_INJ_RANK_3: UInt32 = 0x0000_0215
public let LL_ADC_INJ_RANK_4: UInt32 = 0x0000_031B
public let LL_ADC_SAMPLINGTIME_2CYCLES_5: UInt32 = ADCC.LL_ADC_SAMPLINGTIME_2CYCLES_5
public let LL_ADC_SAMPLINGTIME_6CYCLES_5: UInt32 = 0x0000_0001
public let LL_ADC_SAMPLINGTIME_12CYCLES_5: UInt32 = 0x0000_0002
public let LL_ADC_SAMPLINGTIME_24CYCLES_5: UInt32 = 0x0000_0003
public let LL_ADC_SAMPLINGTIME_47CYCLES_5: UInt32 = 0x0000_0004
public let LL_ADC_SAMPLINGTIME_92CYCLES_5: UInt32 = 0x0000_0005
public let LL_ADC_SAMPLINGTIME_247CYCLES_5: UInt32 = 0x0000_0006
public let LL_ADC_SAMPLINGTIME_640CYCLES_5: UInt32 = 0x0000_0007
public let LL_ADC_SINGLE_ENDED: UInt32 = 0x0000_007F
public let LL_ADC_DIFFERENTIAL_ENDED: UInt32 = 0x407F_0000
public let LL_ADC_BOTH_SINGLE_DIFF_ENDED: UInt32 = 0x407F_007F
public let LL_ADC_AWD1: UInt32 = ADCC.LL_ADC_AWD1
public let LL_ADC_AWD2: UInt32 = 0x0017_FFFF
public let LL_ADC_AWD3: UInt32 = 0x0027_FFFF
public let LL_ADC_AWD_DISABLE: UInt32 = ADCC.LL_ADC_AWD_DISABLE
public let LL_ADC_AWD_ALL_CHANNELS_REG: UInt32 = ADCC.LL_ADC_AWD_ALL_CHANNELS_REG
public let LL_ADC_AWD_ALL_CHANNELS_INJ: UInt32 = ADCC.LL_ADC_AWD_ALL_CHANNELS_INJ
public let LL_ADC_AWD_ALL_CHANNELS_REG_INJ: UInt32 = ADCC.LL_ADC_AWD_ALL_CHANNELS_REG_INJ
public let LL_ADC_AWD_CHANNEL_0_REG: UInt32 = 0x00C0_0001
public let LL_ADC_AWD_CHANNEL_0_INJ: UInt32 = 0x0140_0001
public let LL_ADC_AWD_CHANNEL_0_REG_INJ: UInt32 = 0x01C0_0001
public let LL_ADC_AWD_CHANNEL_1_REG: UInt32 = 0x04C0_0002
public let LL_ADC_AWD_CHANNEL_1_INJ: UInt32 = 0x0540_0002
public let LL_ADC_AWD_CHANNEL_1_REG_INJ: UInt32 = 0x05C0_0002
public let LL_ADC_AWD_CHANNEL_2_REG: UInt32 = 0x08C0_0004
public let LL_ADC_AWD_CHANNEL_2_INJ: UInt32 = 0x0940_0004
public let LL_ADC_AWD_CHANNEL_2_REG_INJ: UInt32 = 0x09C0_0004
public let LL_ADC_AWD_CHANNEL_3_REG: UInt32 = 0x0CC0_0008
public let LL_ADC_AWD_CHANNEL_3_INJ: UInt32 = 0x0D40_0008
public let LL_ADC_AWD_CHANNEL_3_REG_INJ: UInt32 = 0x0DC0_0008
public let LL_ADC_AWD_CHANNEL_4_REG: UInt32 = 0x10C0_0010
public let LL_ADC_AWD_CHANNEL_4_INJ: UInt32 = 0x1140_0010
public let LL_ADC_AWD_CHANNEL_4_REG_INJ: UInt32 = 0x11C0_0010
public let LL_ADC_AWD_CHANNEL_5_REG: UInt32 = 0x14C0_0020
public let LL_ADC_AWD_CHANNEL_5_INJ: UInt32 = 0x1540_0020
public let LL_ADC_AWD_CHANNEL_5_REG_INJ: UInt32 = 0x15C0_0020
public let LL_ADC_AWD_CHANNEL_6_REG: UInt32 = 0x18C0_0040
public let LL_ADC_AWD_CHANNEL_6_INJ: UInt32 = 0x1940_0040
public let LL_ADC_AWD_CHANNEL_6_REG_INJ: UInt32 = 0x19C0_0040
public let LL_ADC_AWD_CHANNEL_7_REG: UInt32 = 0x1CC0_0080
public let LL_ADC_AWD_CHANNEL_7_INJ: UInt32 = 0x1D40_0080
public let LL_ADC_AWD_CHANNEL_7_REG_INJ: UInt32 = 0x1DC0_0080
public let LL_ADC_AWD_CHANNEL_8_REG: UInt32 = 0x20C0_0100
public let LL_ADC_AWD_CHANNEL_8_INJ: UInt32 = 0x2140_0100
public let LL_ADC_AWD_CHANNEL_8_REG_INJ: UInt32 = 0x21C0_0100
public let LL_ADC_AWD_CHANNEL_9_REG: UInt32 = 0x24C0_0200
public let LL_ADC_AWD_CHANNEL_9_INJ: UInt32 = 0x2540_0200
public let LL_ADC_AWD_CHANNEL_9_REG_INJ: UInt32 = 0x25C0_0200
public let LL_ADC_AWD_CHANNEL_10_REG: UInt32 = 0x28C0_0400
public let LL_ADC_AWD_CHANNEL_10_INJ: UInt32 = 0x2940_0400
public let LL_ADC_AWD_CHANNEL_10_REG_INJ: UInt32 = 0x29C0_0400
public let LL_ADC_AWD_CHANNEL_11_REG: UInt32 = 0x2CC0_0800
public let LL_ADC_AWD_CHANNEL_11_INJ: UInt32 = 0x2D40_0800
public let LL_ADC_AWD_CHANNEL_11_REG_INJ: UInt32 = 0x2DC0_0800
public let LL_ADC_AWD_CHANNEL_12_REG: UInt32 = 0x30C0_1000
public let LL_ADC_AWD_CHANNEL_12_INJ: UInt32 = 0x3140_1000
public let LL_ADC_AWD_CHANNEL_12_REG_INJ: UInt32 = 0x31C0_1000
public let LL_ADC_AWD_CHANNEL_13_REG: UInt32 = 0x34C0_2000
public let LL_ADC_AWD_CHANNEL_13_INJ: UInt32 = 0x3540_2000
public let LL_ADC_AWD_CHANNEL_13_REG_INJ: UInt32 = 0x35C0_2000
public let LL_ADC_AWD_CHANNEL_14_REG: UInt32 = 0x38C0_4000
public let LL_ADC_AWD_CHANNEL_14_INJ: UInt32 = 0x3940_4000
public let LL_ADC_AWD_CHANNEL_14_REG_INJ: UInt32 = 0x39C0_4000
public let LL_ADC_AWD_CHANNEL_15_REG: UInt32 = 0x3CC0_8000
public let LL_ADC_AWD_CHANNEL_15_INJ: UInt32 = 0x3D40_8000
public let LL_ADC_AWD_CHANNEL_15_REG_INJ: UInt32 = 0x3DC0_8000
public let LL_ADC_AWD_CHANNEL_16_REG: UInt32 = 0x40C1_0000
public let LL_ADC_AWD_CHANNEL_16_INJ: UInt32 = 0x4141_0000
public let LL_ADC_AWD_CHANNEL_16_REG_INJ: UInt32 = 0x41C1_0000
public let LL_ADC_AWD_CHANNEL_17_REG: UInt32 = 0x44C2_0000
public let LL_ADC_AWD_CHANNEL_17_INJ: UInt32 = 0x4542_0000
public let LL_ADC_AWD_CHANNEL_17_REG_INJ: UInt32 = 0x45C2_0000
public let LL_ADC_AWD_CHANNEL_18_REG: UInt32 = 0x48C4_0000
public let LL_ADC_AWD_CHANNEL_18_INJ: UInt32 = 0x4944_0000
public let LL_ADC_AWD_CHANNEL_18_REG_INJ: UInt32 = 0x49C4_0000
public let LL_ADC_AWD_CH_VREFINT_REG: UInt32 = 0xC4C2_0000
public let LL_ADC_AWD_CH_VREFINT_INJ: UInt32 = 0xC542_0000
public let LL_ADC_AWD_CH_VREFINT_REG_INJ: UInt32 = 0xC5C2_0000
public let LL_ADC_AWD_CH_TEMPSENSOR_REG: UInt32 = 0xC0C1_0000
public let LL_ADC_AWD_CH_TEMPSENSOR_INJ: UInt32 = 0xC141_0000
public let LL_ADC_AWD_CH_TEMPSENSOR_REG_INJ: UInt32 = 0xC1C1_0000
public let LL_ADC_AWD_CH_VBAT_REG: UInt32 = 0x40C9_0000
public let LL_ADC_AWD_CH_VBAT_INJ: UInt32 = 0x4149_0000
public let LL_ADC_AWD_CH_VBAT_REG_INJ: UInt32 = 0x41C9_0000
public let LL_ADC_AWD_CH_VDDCORE_REG: UInt32 = 0x44CA_0000
public let LL_ADC_AWD_CH_VDDCORE_INJ: UInt32 = 0x454A_0000
public let LL_ADC_AWD_CH_VDDCORE_REG_INJ: UInt32 = 0x45CA_0000
public let LL_ADC_AWD_THRESHOLD_HIGH: UInt32 = 0x0FFF_0000
public let LL_ADC_AWD_THRESHOLD_LOW: UInt32 = 0x0000_0FFF
public let LL_ADC_AWD_THRESHOLDS_HIGH_LOW: UInt32 = 0x0FFF_0FFF
public let LL_ADC_AWD_FILTERING_NONE: UInt32 = 0x0000_0000
public let LL_ADC_AWD_FILTERING_2SAMPLES: UInt32 = 0x0000_1000
public let LL_ADC_AWD_FILTERING_3SAMPLES: UInt32 = 0x0000_2000
public let LL_ADC_AWD_FILTERING_4SAMPLES: UInt32 = 0x0000_3000
public let LL_ADC_AWD_FILTERING_5SAMPLES: UInt32 = 0x0000_4000
public let LL_ADC_AWD_FILTERING_6SAMPLES: UInt32 = 0x0000_5000
public let LL_ADC_AWD_FILTERING_7SAMPLES: UInt32 = 0x0000_6000
public let LL_ADC_AWD_FILTERING_8SAMPLES: UInt32 = 0x0000_7000
public let LL_ADC_OVS_DISABLE: UInt32 = 0x0000_0000
public let LL_ADC_OVS_GRP_REGULAR_CONTINUED: UInt32 = 0x0000_0001
public let LL_ADC_OVS_GRP_REGULAR_RESUMED: UInt32 = 0x0000_0401
public let LL_ADC_OVS_GRP_INJECTED: UInt32 = 0x0000_0002
public let LL_ADC_OVS_GRP_INJ_REG_RESUMED: UInt32 = 0x0000_0003
public let LL_ADC_OVS_REG_CONT: UInt32 = 0x0000_0000
public let LL_ADC_OVS_REG_DISCONT: UInt32 = 0x0000_0200
public let LL_ADC_OVS_RATIO_2: UInt32 = 0x0000_0000
public let LL_ADC_OVS_RATIO_4: UInt32 = 0x0000_0004
public let LL_ADC_OVS_RATIO_8: UInt32 = 0x0000_0008
public let LL_ADC_OVS_RATIO_16: UInt32 = 0x0000_000C
public let LL_ADC_OVS_RATIO_32: UInt32 = 0x0000_0010
public let LL_ADC_OVS_RATIO_64: UInt32 = 0x0000_0014
public let LL_ADC_OVS_RATIO_128: UInt32 = 0x0000_0018
public let LL_ADC_OVS_RATIO_256: UInt32 = 0x0000_001C
public let LL_ADC_OVS_SHIFT_NONE: UInt32 = 0x0000_0000
public let LL_ADC_OVS_SHIFT_RIGHT_1: UInt32 = 0x0000_0020
public let LL_ADC_OVS_SHIFT_RIGHT_2: UInt32 = 0x0000_0040
public let LL_ADC_OVS_SHIFT_RIGHT_3: UInt32 = 0x0000_0060
public let LL_ADC_OVS_SHIFT_RIGHT_4: UInt32 = 0x0000_0080
public let LL_ADC_OVS_SHIFT_RIGHT_5: UInt32 = 0x0000_00A0
public let LL_ADC_OVS_SHIFT_RIGHT_6: UInt32 = 0x0000_00C0
public let LL_ADC_OVS_SHIFT_RIGHT_7: UInt32 = 0x0000_00E0
public let LL_ADC_OVS_SHIFT_RIGHT_8: UInt32 = 0x0000_0100
public let LL_ADC_MULTI_INDEPENDENT: UInt32 = ADCC.LL_ADC_MULTI_INDEPENDENT
public let LL_ADC_MULTI_DUAL_REG_SIMULT: UInt32 = ADCC.LL_ADC_MULTI_DUAL_REG_SIMULT
public let LL_ADC_MULTI_DUAL_REG_INTERL: UInt32 = ADCC.LL_ADC_MULTI_DUAL_REG_INTERL
public let LL_ADC_MULTI_DUAL_INJ_SIMULT: UInt32 = ADCC.LL_ADC_MULTI_DUAL_INJ_SIMULT
public let LL_ADC_MULTI_DUAL_INJ_ALTERN: UInt32 = ADCC.LL_ADC_MULTI_DUAL_INJ_ALTERN
public let LL_ADC_MULTI_DUAL_REG_SIM_INJ_SIM: UInt32 = 0x0000_0001
public let LL_ADC_MULTI_DUAL_REG_SIM_INJ_ALT: UInt32 = 0x0000_0002
public let LL_ADC_MULTI_DUAL_REG_INT_INJ_SIM: UInt32 = 0x0000_0003
public let LL_ADC_MULTI_REG_DMA_EACH_ADC: UInt32 = ADCC.LL_ADC_MULTI_REG_DMA_EACH_ADC
public let LL_ADC_MULTI_REG_DMA_LIMIT_RES12_10B: UInt32 = 0x0000_8000
public let LL_ADC_MULTI_REG_DMA_LIMIT_RES8_6B: UInt32 = 0x0000_C000
public let LL_ADC_MULTI_REG_DMA_UNLMT_RES12_10B: UInt32 = 0x0000_A000
public let LL_ADC_MULTI_REG_DMA_UNLMT_RES8_6B: UInt32 = 0x0000_E000
public let LL_ADC_MULTI_TWOSMP_DELAY_1CYCLE: UInt32 = 0x0000_0000
public let LL_ADC_MULTI_TWOSMP_DELAY_2CYCLES: UInt32 = 0x0000_0100
public let LL_ADC_MULTI_TWOSMP_DELAY_3CYCLES: UInt32 = 0x0000_0200
public let LL_ADC_MULTI_TWOSMP_DELAY_4CYCLES: UInt32 = 0x0000_0300
public let LL_ADC_MULTI_TWOSMP_DELAY_5CYCLES: UInt32 = 0x0000_0400
public let LL_ADC_MULTI_TWOSMP_DELAY_6CYCLES: UInt32 = 0x0000_0500
public let LL_ADC_MULTI_TWOSMP_DELAY_7CYCLES: UInt32 = 0x0000_0600
public let LL_ADC_MULTI_TWOSMP_DELAY_8CYCLES: UInt32 = 0x0000_0700
public let LL_ADC_MULTI_TWOSMP_DELAY_9CYCLES: UInt32 = 0x0000_0800
public let LL_ADC_MULTI_TWOSMP_DELAY_10CYCLES: UInt32 = 0x0000_0900
public let LL_ADC_MULTI_TWOSMP_DELAY_11CYCLES: UInt32 = 0x0000_0A00
public let LL_ADC_MULTI_TWOSMP_DELAY_12CYCLES: UInt32 = 0x0000_0B00
public let LL_ADC_MULTI_MASTER: UInt32 = 0x0000_FFFF
public let LL_ADC_MULTI_SLAVE: UInt32 = 0xFFFF_0000
public let LL_ADC_MULTI_MASTER_SLAVE: UInt32 = 0xFFFF_FFFF
public let LL_ADC_TEMPERATURE_CALC_ERROR: UInt32 = ADCC.LL_ADC_TEMPERATURE_CALC_ERROR
public let LL_ADC_DELAY_INTERNAL_REGUL_STAB_US: UInt32 = ADCC.LL_ADC_DELAY_INTERNAL_REGUL_STAB_US
public let LL_ADC_DELAY_VREFINT_STAB_US: UInt32 = 0x0000_000C
public let LL_ADC_DELAY_TEMPSENSOR_STAB_US: UInt32 = ADCC.LL_ADC_DELAY_TEMPSENSOR_STAB_US
public let LL_ADC_DELAY_TEMPSENSOR_BUFFER_STAB_US: UInt32 = 0x0000_000F
public let LL_ADC_DELAY_CALIB_ENABLE_ADC_CYCLES: UInt32 = 0x0000_0004

public func LL_ADC_DMA_GetRegAddr<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Register: UInt32) -> UInt32
{
    if Register == LL_ADC_DMA_REG_REGULAR_DATA { return registers.dataAddress(instance: ADCx) }
    return registers.commonDataAddress()
}

public func LL_ADC_SetCommonClock<IO: ADCRegisterIO>(_ registers: IO, _ CommonClock: UInt32) {
    registers.writeCommon(
        ADCCommonRegister.ccr,
        value: (registers.readCommon(ADCCommonRegister.ccr) & ~(ADCC.ADC_CCR_CKMODE | ADCC.ADC_CCR_PRESC))
            | (CommonClock))
}

public func LL_ADC_GetCommonClock<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.readCommon(ADCCommonRegister.ccr) & (ADCC.ADC_CCR_CKMODE | ADCC.ADC_CCR_PRESC)))
}

public func LL_ADC_SetCommonPathInternalCh<IO: ADCRegisterIO>(_ registers: IO, _ PathInternal: UInt32) {
    registers.writeCommon(
        ADCCommonRegister.ccr,
        value: (registers.readCommon(ADCCommonRegister.ccr)
            & ~(ADCC.ADC_CCR_VREFEN | ADCC.ADC_CCR_TSEN | ADCC.ADC_CCR_VBATEN)) | (PathInternal))
}

public func LL_ADC_SetCommonPathInternalChAdd<IO: ADCRegisterIO>(_ registers: IO, _ PathInternal: UInt32) {
    registers.writeCommon(ADCCommonRegister.ccr, value: registers.readCommon(ADCCommonRegister.ccr) | (PathInternal))
}

public func LL_ADC_SetCommonPathInternalChRem<IO: ADCRegisterIO>(_ registers: IO, _ PathInternal: UInt32) {
    registers.writeCommon(ADCCommonRegister.ccr, value: registers.readCommon(ADCCommonRegister.ccr) & ~(PathInternal))
}

public func LL_ADC_GetCommonPathInternalCh<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        ((registers.readCommon(ADCCommonRegister.ccr) & (ADCC.ADC_CCR_VREFEN | ADCC.ADC_CCR_TSEN | ADCC.ADC_CCR_VBATEN)))
}

public func LL_ADC_SetPathInternalCh<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ PathInternal: UInt32) {
    registers.write(
        ADCRegister.`or`, instance: ADCx,
        value: (registers.read(ADCRegister.`or`, instance: ADCx) & ~(0x1)) | (PathInternal))
}

public func LL_ADC_SetPathInternalChAdd<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ PathInternal: UInt32)
{
    registers.write(
        ADCRegister.`or`, instance: ADCx, value: registers.read(ADCRegister.`or`, instance: ADCx) | (PathInternal))
}

public func LL_ADC_SetPathInternalChRem<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ PathInternal: UInt32)
{
    registers.write(
        ADCRegister.`or`, instance: ADCx, value: registers.read(ADCRegister.`or`, instance: ADCx) & ~(PathInternal))
}

public func LL_ADC_GetPathInternalCh<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.`or`, instance: ADCx) & (0x1)))
}

public func LL_ADC_SetCalibrationFactor<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ SingleDiff: UInt32, _ CalibrationFactor: UInt32
) {
    registers.write(
        ADCRegister.calfact, instance: ADCx,
        value: (registers.read(ADCRegister.calfact, instance: ADCx)
            & ~(SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_FACTOR_MASK))
            | (CalibrationFactor
                << (((SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_F_BIT_D_MASK)
                    >> ADCC.ADC_SINGLEDIFF_CALIB_F_BIT_D_SHIFT4)
                    & ~(SingleDiff & ADCC.ADC_CALFACT_CALFACT_S)))
    )
}

public func LL_ADC_GetCalibrationFactor<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ SingleDiff: UInt32)
    -> UInt32
{
    return
        ((registers.read(ADCRegister.calfact, instance: ADCx) & ((SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_FACTOR_MASK)))
        >> ((SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_F_BIT_D_MASK) >> ADCC.ADC_SINGLEDIFF_CALIB_F_BIT_D_SHIFT4))
}

public func LL_ADC_SetResolution<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Resolution: UInt32) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_RES)) | (Resolution))
}

public func LL_ADC_GetResolution<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_RES)))
}

public func LL_ADC_SetDataAlignment<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ DataAlignment: UInt32) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_ALIGN)) | (DataAlignment))
}

public func LL_ADC_GetDataAlignment<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_ALIGN)))
}

public func LL_ADC_SetLowPowerMode<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ LowPowerMode: UInt32) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_AUTDLY)) | (LowPowerMode))
}

public func LL_ADC_GetLowPowerMode<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_AUTDLY)))
}

public func LL_ADC_SetOffset<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32, _ Channel: UInt32, _ OffsetLevel: UInt32
) {
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    registers.write(
        preg, instance: ADCx,
        value: (registers.read(preg, instance: ADCx)
            & ~(ADCC.ADC_OFR1_OFFSET1_EN | ADCC.ADC_OFR1_OFFSET1_CH | ADCC.ADC_OFR1_OFFSET1))
            | (ADCC.ADC_OFR1_OFFSET1_EN | (Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) | OffsetLevel))
}

public func LL_ADC_GetOffsetChannel<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32)
    -> UInt32
{
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    return (registers.read(preg, instance: ADCx) & (ADCC.ADC_OFR1_OFFSET1_CH))
}

public func LL_ADC_GetOffsetLevel<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32) -> UInt32
{
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    return (registers.read(preg, instance: ADCx) & (ADCC.ADC_OFR1_OFFSET1))
}

public func LL_ADC_SetOffsetState<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32, _ OffsetState: UInt32
) {
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    registers.write(
        preg, instance: ADCx,
        value: (registers.read(preg, instance: ADCx) & ~(ADCC.ADC_OFR1_OFFSET1_EN)) | (OffsetState))
}

public func LL_ADC_GetOffsetState<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32) -> UInt32
{
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    return (registers.read(preg, instance: ADCx) & (ADCC.ADC_OFR1_OFFSET1_EN))
}

public func LL_ADC_SetOffsetSign<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32, _ OffsetSign: UInt32
) {
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    registers.write(
        preg, instance: ADCx, value: (registers.read(preg, instance: ADCx) & ~(ADCC.ADC_OFR1_OFFSETPOS)) | (OffsetSign))
}

public func LL_ADC_GetOffsetSign<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32) -> UInt32 {
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    return (registers.read(preg, instance: ADCx) & (ADCC.ADC_OFR1_OFFSETPOS))
}

public func LL_ADC_SetOffsetSaturation<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32, _ OffsetSaturation: UInt32
) {
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    registers.write(
        preg, instance: ADCx,
        value: (registers.read(preg, instance: ADCx) & ~(ADCC.ADC_OFR1_SATEN)) | (OffsetSaturation))
}

public func LL_ADC_GetOffsetSaturation<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Offsety: UInt32)
    -> UInt32
{
    let preg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
    return (registers.read(preg, instance: ADCx) & (ADCC.ADC_OFR1_SATEN))
}

public func LL_ADC_SetSamplingTimeCommonConfig<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ SamplingTimeCommonConfig: UInt32
) {
    registers.write(
        ADCRegister.smpr1, instance: ADCx,
        value: (registers.read(ADCRegister.smpr1, instance: ADCx) & ~(ADCC.ADC_SMPR1_SMPPLUS))
            | (SamplingTimeCommonConfig))
}

public func LL_ADC_GetSamplingTimeCommonConfig<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.smpr1, instance: ADCx) & (ADCC.ADC_SMPR1_SMPPLUS)))
}

public func LL_ADC_REG_SetTriggerSource<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ TriggerSource: UInt32
) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_EXTEN | ADCC.ADC_CFGR_EXTSEL))
            | (TriggerSource))
}

public func LL_ADC_REG_GetTriggerSource<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    var trigger_source: UInt32 =
        (registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_EXTSEL | ADCC.ADC_CFGR_EXTEN))

    var shift_exten: UInt32 = ((trigger_source & ADCC.ADC_CFGR_EXTEN) >> (0xa &- 2))

    return
        ((trigger_source
        & (0x3ffe00 >> shift_exten) & ADCC.ADC_CFGR_EXTSEL)
        | ((0x444000 >> shift_exten) & ADCC.ADC_CFGR_EXTEN))
}

public func LL_ADC_REG_IsTriggerSourceSWStart<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return
        (((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_EXTEN))
        == (LL_ADC_REG_TRIG_SOFTWARE & ADCC.ADC_CFGR_EXTEN)) ? 1 : 0)
}

public func LL_ADC_REG_SetTriggerEdge<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ ExternalTriggerEdge: UInt32
) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_EXTEN)) | (ExternalTriggerEdge))
}

public func LL_ADC_REG_GetTriggerEdge<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_EXTEN)))
}

public func LL_ADC_REG_SetSamplingMode<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ SamplingMode: UInt32)
{
    registers.write(
        ADCRegister.cfgr2, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr2, instance: ADCx) & ~(ADCC.ADC_CFGR2_BULB | ADCC.ADC_CFGR2_SMPTRIG))
            | (SamplingMode))
}

public func LL_ADC_REG_GetSamplingMode<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr2, instance: ADCx) & (ADCC.ADC_CFGR2_BULB | ADCC.ADC_CFGR2_SMPTRIG)))
}

public func LL_ADC_REG_SetSequencerLength<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ SequencerNbRanks: UInt32
) {
    registers.write(
        ADCRegister.sqr1, instance: ADCx,
        value: (registers.read(ADCRegister.sqr1, instance: ADCx) & ~(ADCC.ADC_SQR1_L)) | (SequencerNbRanks))
}

public func LL_ADC_REG_GetSequencerLength<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.sqr1, instance: ADCx) & (ADCC.ADC_SQR1_L)))
}

public func LL_ADC_REG_SetSequencerDiscont<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ SeqDiscont: UInt32
) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_DISCEN | ADCC.ADC_CFGR_DISCNUM))
            | (SeqDiscont))
}

public func LL_ADC_REG_GetSequencerDiscont<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_DISCEN | ADCC.ADC_CFGR_DISCNUM)))
}

public func LL_ADC_REG_SetSequencerRanks<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32, _ Channel: UInt32
) {
    let preg = ADCRegister(
        rawValue: ADCRegister.sqr1.rawValue
            &+ ((((Rank & ADCC.ADC_REG_SQRX_REGOFFSET_MASK) >> ADCC.ADC_SQRX_REGOFFSET_POS)) << 2))!
    registers.write(
        preg, instance: ADCx,
        value: (registers.read(preg, instance: ADCx)
            & ~(ADCC.ADC_CHANNEL_ID_NUMBER_MASK_POSBIT0 << (Rank & ADCC.ADC_REG_RANK_ID_SQRX_MASK)))
            | (((Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
                << (Rank & ADCC.ADC_REG_RANK_ID_SQRX_MASK)))
}

public func LL_ADC_REG_GetSequencerRanks<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32)
    -> UInt32
{
    let preg = ADCRegister(
        rawValue: ADCRegister.sqr1.rawValue
            &+ ((((Rank & ADCC.ADC_REG_SQRX_REGOFFSET_MASK) >> ADCC.ADC_SQRX_REGOFFSET_POS)) << 2))!
    return
        (((registers.read(preg, instance: ADCx)
        & (ADCC.ADC_CHANNEL_ID_NUMBER_MASK_POSBIT0 << (Rank & ADCC.ADC_REG_RANK_ID_SQRX_MASK)))
        >> (Rank & ADCC.ADC_REG_RANK_ID_SQRX_MASK)) << ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
}

public func LL_ADC_REG_SetContinuousMode<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Continuous: UInt32)
{
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_CONT)) | (Continuous))
}

public func LL_ADC_REG_GetContinuousMode<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_CONT)))
}

public func LL_ADC_REG_SetDMATransfer<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ DMATransfer: UInt32) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_DMAEN | ADCC.ADC_CFGR_DMACFG))
            | (DMATransfer))
}

public func LL_ADC_REG_GetDMATransfer<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_DMAEN | ADCC.ADC_CFGR_DMACFG)))
}

public func LL_ADC_REG_SetMDFTransfer<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ MDFTransfer: UInt32) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(0x4)) | (MDFTransfer))
}

public func LL_ADC_REG_GetMDFTransfer<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (0x4)))
}

public func LL_ADC_REG_SetOverrun<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Overrun: UInt32) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_OVRMOD)) | (Overrun))
}

public func LL_ADC_REG_GetOverrun<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_OVRMOD)))
}

public func LL_ADC_INJ_SetTriggerSource<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ TriggerSource: UInt32
) {
    registers.write(
        ADCRegister.jsqr, instance: ADCx,
        value: (registers.read(ADCRegister.jsqr, instance: ADCx) & ~(ADCC.ADC_JSQR_JEXTSEL | ADCC.ADC_JSQR_JEXTEN))
            | (TriggerSource))
}

public func LL_ADC_INJ_GetTriggerSource<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    var trigger_source: UInt32 =
        (registers.read(ADCRegister.jsqr, instance: ADCx) & (ADCC.ADC_JSQR_JEXTSEL | ADCC.ADC_JSQR_JEXTEN))

    var shift_jexten: UInt32 = ((trigger_source & ADCC.ADC_JSQR_JEXTEN) >> (0x7 &- 2))

    return
        ((trigger_source
        & (0x7ffc0 >> shift_jexten) & ADCC.ADC_JSQR_JEXTSEL)
        | ((0x88800 >> shift_jexten) & ADCC.ADC_JSQR_JEXTEN))
}

public func LL_ADC_INJ_IsTriggerSourceSWStart<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return
        (((registers.read(ADCRegister.jsqr, instance: ADCx) & (ADCC.ADC_JSQR_JEXTEN))
        == (LL_ADC_INJ_TRIG_SOFTWARE & ADCC.ADC_JSQR_JEXTEN)) ? 1 : 0)
}

public func LL_ADC_INJ_SetTriggerEdge<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ ExternalTriggerEdge: UInt32
) {
    registers.write(
        ADCRegister.jsqr, instance: ADCx,
        value: (registers.read(ADCRegister.jsqr, instance: ADCx) & ~(ADCC.ADC_JSQR_JEXTEN)) | (ExternalTriggerEdge))
}

public func LL_ADC_INJ_GetTriggerEdge<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.jsqr, instance: ADCx) & (ADCC.ADC_JSQR_JEXTEN)))
}

public func LL_ADC_INJ_SetSequencerLength<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ SequencerNbRanks: UInt32
) {
    registers.write(
        ADCRegister.jsqr, instance: ADCx,
        value: (registers.read(ADCRegister.jsqr, instance: ADCx) & ~(ADCC.ADC_JSQR_JL)) | (SequencerNbRanks))
}

public func LL_ADC_INJ_GetSequencerLength<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.jsqr, instance: ADCx) & (ADCC.ADC_JSQR_JL)))
}

public func LL_ADC_INJ_SetSequencerDiscont<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ SeqDiscont: UInt32
) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_JDISCEN)) | (SeqDiscont))
}

public func LL_ADC_INJ_GetSequencerDiscont<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_JDISCEN)))
}

public func LL_ADC_INJ_SetSequencerRanks<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32, _ Channel: UInt32
) {
    registers.write(
        ADCRegister.jsqr, instance: ADCx,
        value: (registers.read(ADCRegister.jsqr, instance: ADCx)
            & ~((ADCC.ADC_CHANNEL_ID_NUMBER_MASK >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
            << (Rank & ADCC.ADC_INJ_RANK_ID_JSQR_MASK)))
            | (((Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
                << (Rank & ADCC.ADC_INJ_RANK_ID_JSQR_MASK)))
}

public func LL_ADC_INJ_GetSequencerRanks<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32)
    -> UInt32
{
    return
        (((registers.read(ADCRegister.jsqr, instance: ADCx)
        & ((ADCC.ADC_CHANNEL_ID_NUMBER_MASK >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
            << (Rank & ADCC.ADC_INJ_RANK_ID_JSQR_MASK)))
        >> (Rank & ADCC.ADC_INJ_RANK_ID_JSQR_MASK)) << ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
}

public func LL_ADC_INJ_SetTrigAuto<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ TrigAuto: UInt32) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_JAUTO)) | (TrigAuto))
}

public func LL_ADC_INJ_GetTrigAuto<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_JAUTO)))
}

public func LL_ADC_INJ_SetQueueMode<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ QueueMode: UInt32) {
    registers.write(
        ADCRegister.cfgr, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr, instance: ADCx) & ~(ADCC.ADC_CFGR_JQM | ADCC.ADC_CFGR_JQDIS))
            | (QueueMode))
}

public func LL_ADC_INJ_GetQueueMode<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr, instance: ADCx) & (ADCC.ADC_CFGR_JQM | ADCC.ADC_CFGR_JQDIS)))
}

public func LL_ADC_INJ_ConfigQueueContext<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ TriggerSource: UInt32, _ ExternalTriggerEdge: UInt32,
    _ SequencerNbRanks: UInt32, _ Rank1_Channel: UInt32, _ Rank2_Channel: UInt32, _ Rank3_Channel: UInt32,
    _ Rank4_Channel: UInt32
) {
    let is_trigger_not_sw: UInt32 = ((TriggerSource != LL_ADC_INJ_TRIG_SOFTWARE) ? 1 : 0)
    registers.write(
        ADCRegister.jsqr, instance: ADCx,
        value: (registers.read(ADCRegister.jsqr, instance: ADCx)
            & ~(ADCC.ADC_JSQR_JEXTSEL | ADCC.ADC_JSQR_JEXTEN | ADCC.ADC_JSQR_JSQ4 | ADCC.ADC_JSQR_JSQ3
            | ADCC.ADC_JSQR_JSQ2 | ADCC.ADC_JSQR_JSQ1 | ADCC.ADC_JSQR_JL))
            | ((TriggerSource & ADCC.ADC_JSQR_JEXTSEL) | (ExternalTriggerEdge &* (is_trigger_not_sw))
                | (((Rank4_Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
                    << (LL_ADC_INJ_RANK_4 & ADCC.ADC_INJ_RANK_ID_JSQR_MASK))
                | (((Rank3_Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
                    << (LL_ADC_INJ_RANK_3 & ADCC.ADC_INJ_RANK_ID_JSQR_MASK))
                | (((Rank2_Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
                    << (LL_ADC_INJ_RANK_2 & ADCC.ADC_INJ_RANK_ID_JSQR_MASK))
                | (((Rank1_Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS)
                    << (LL_ADC_INJ_RANK_1 & ADCC.ADC_INJ_RANK_ID_JSQR_MASK)) | SequencerNbRanks))
}

public func LL_ADC_SetChannelSamplingTime<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Channel: UInt32, _ SamplingTime: UInt32
) {
    let preg = ADCRegister(
        rawValue: ADCRegister.smpr1.rawValue
            &+ ((((Channel & ADCC.ADC_CHANNEL_SMPRX_REGOFFSET_MASK) >> ADCC.ADC_SMPRX_REGOFFSET_POS)) << 2))!
    registers.write(
        preg, instance: ADCx,
        value: (registers.read(preg, instance: ADCx)
            & ~(ADCC.ADC_SMPR1_SMP0
            << ((Channel & ADCC.ADC_CHANNEL_SMPx_BITOFFSET_MASK) >> ADCC.ADC_CHANNEL_SMPx_BITOFFSET_POS)))
            | (SamplingTime << ((Channel & ADCC.ADC_CHANNEL_SMPx_BITOFFSET_MASK) >> ADCC.ADC_CHANNEL_SMPx_BITOFFSET_POS))
    )
}

public func LL_ADC_GetChannelSamplingTime<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Channel: UInt32)
    -> UInt32
{
    let preg = ADCRegister(
        rawValue: ADCRegister.smpr1.rawValue
            &+ ((((Channel & ADCC.ADC_CHANNEL_SMPRX_REGOFFSET_MASK)
                >> ADCC.ADC_SMPRX_REGOFFSET_POS)) << 2))!
    return
        ((registers.read(preg, instance: ADCx)
        & (ADCC.ADC_SMPR1_SMP0
            << ((Channel & ADCC.ADC_CHANNEL_SMPx_BITOFFSET_MASK) >> ADCC.ADC_CHANNEL_SMPx_BITOFFSET_POS)))
        >> ((Channel & ADCC.ADC_CHANNEL_SMPx_BITOFFSET_MASK) >> ADCC.ADC_CHANNEL_SMPx_BITOFFSET_POS))
}

public func LL_ADC_SetChannelSingleDiff<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Channel: UInt32, _ SingleDiff: UInt32
) {
    registers.write(
        ADCRegister.difsel, instance: ADCx,
        value: (registers.read(ADCRegister.difsel, instance: ADCx) & ~(Channel & ADCC.ADC_SINGLEDIFF_CHANNEL_MASK))
            | ((Channel & ADCC.ADC_SINGLEDIFF_CHANNEL_MASK)
                & (ADCC.ADC_DIFSEL_DIFSEL >> (SingleDiff & ADCC.ADC_SINGLEDIFF_CHANNEL_SHIFT_MASK))))
}

public func LL_ADC_GetChannelSingleDiff<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Channel: UInt32)
    -> UInt32
{
    return ((registers.read(ADCRegister.difsel, instance: ADCx) & ((Channel & ADCC.ADC_SINGLEDIFF_CHANNEL_MASK))))
}

public func LL_ADC_SetAnalogWDMonitChannels<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ AWDy: UInt32, _ AWDChannelGroup: UInt32
) {
    let preg = ADCRegister(
        rawValue: ADCRegister.cfgr.rawValue
            &+ ((((AWDy & ADCC.ADC_AWD_CRX_REGOFFSET_MASK) >> ADCC.ADC_AWD_CRX_REGOFFSET_POS)
                &+ ((AWDy & ADCC.ADC_AWD_CR12_REGOFFSETGAP_MASK)
                    &* ADCC.ADC_AWD_CR12_REGOFFSETGAP_VAL))
                << 2))!
    registers.write(
        preg, instance: ADCx,
        value: (registers.read(preg, instance: ADCx) & ~((AWDy & ADCC.ADC_AWD_CR_ALL_CHANNEL_MASK)))
            | (AWDChannelGroup & AWDy))
}

public func LL_ADC_GetAnalogWDMonitChannels<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ AWDy: UInt32)
    -> UInt32
{
    let preg = ADCRegister(
        rawValue: ADCRegister.cfgr.rawValue
            &+ ((((AWDy & ADCC.ADC_AWD_CRX_REGOFFSET_MASK) >> ADCC.ADC_AWD_CRX_REGOFFSET_POS)
                &+ ((AWDy & ADCC.ADC_AWD_CR12_REGOFFSETGAP_MASK)
                    &* ADCC.ADC_AWD_CR12_REGOFFSETGAP_VAL))
                << 2))!
    var analog_wd_monit_channels: UInt32 =
        ((registers.read(preg, instance: ADCx) & (AWDy)) & AWDy & ADCC.ADC_AWD_CR_ALL_CHANNEL_MASK)

    if analog_wd_monit_channels != 0 {
        if AWDy == LL_ADC_AWD1 {
            if (analog_wd_monit_channels & ADCC.ADC_CFGR_AWD1SGL) == 0 {
                analog_wd_monit_channels =
                    ((analog_wd_monit_channels
                        | (0x7ffff))
                        & (~(0x7c00_0000)))
            } else {
                analog_wd_monit_channels =
                    (analog_wd_monit_channels
                        | (ADCC.ADC_AWD2CR_AWD2CH_0 << (analog_wd_monit_channels >> 0x1a)))
            }
        } else {
            if (analog_wd_monit_channels & 0x7ffff) == 0x7ffff {
                analog_wd_monit_channels =
                    (0x7ffff
                        | ((ADCC.ADC_CFGR_JAWD1EN | ADCC.ADC_CFGR_AWD1EN)))
            } else {

                analog_wd_monit_channels =
                    (analog_wd_monit_channels
                        | (ADCC.ADC_CFGR_JAWD1EN | ADCC.ADC_CFGR_AWD1EN | ADCC.ADC_CFGR_AWD1SGL)
                        | (__LL_ADC_CHANNEL_TO_DECIMAL_NB(analog_wd_monit_channels) << 0x1a))
            }
        }
    }
    return analog_wd_monit_channels
}

public func LL_ADC_ConfigAnalogWDThresholds<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ AWDy: UInt32, _ AWDThresholdHighValue: UInt32,
    _ AWDThresholdLowValue: UInt32
) {
    let preg = ADCRegister(
        rawValue: ADCRegister.tr1.rawValue
            &+ ((((AWDy & ADCC.ADC_AWD_TRX_REGOFFSET_MASK) >> ADCC.ADC_AWD_TRX_REGOFFSET_POS)) << 2))!
    registers.write(
        preg, instance: ADCx,
        value: (registers.read(preg, instance: ADCx) & ~(ADCC.ADC_TR1_HT1 | ADCC.ADC_TR1_LT1))
            | ((AWDThresholdHighValue << ADCC.ADC_TR1_HT1_BITOFFSET_POS) | AWDThresholdLowValue))
}

public func LL_ADC_SetAnalogWDThresholds<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ AWDy: UInt32, _ AWDThresholdsHighLow: UInt32, _ AWDThresholdValue: UInt32
) {
    let preg = ADCRegister(
        rawValue: ADCRegister.tr1.rawValue
            &+ ((((AWDy & ADCC.ADC_AWD_TRX_REGOFFSET_MASK) >> ADCC.ADC_AWD_TRX_REGOFFSET_POS)) << 2))!
    registers.write(
        preg, instance: ADCx,
        value: (registers.read(preg, instance: ADCx) & ~(AWDThresholdsHighLow))
            | (AWDThresholdValue << ((AWDThresholdsHighLow & 0x10000) >> 0xc)))
}

public func LL_ADC_GetAnalogWDThresholds<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ AWDy: UInt32, _ AWDThresholdsHighLow: UInt32
) -> UInt32 {
    let preg = ADCRegister(
        rawValue: ADCRegister.tr1.rawValue
            &+ ((((AWDy & ADCC.ADC_AWD_TRX_REGOFFSET_MASK) >> ADCC.ADC_AWD_TRX_REGOFFSET_POS)) << 2))!
    return
        ((registers.read(preg, instance: ADCx) & ((AWDThresholdsHighLow | ADCC.ADC_TR1_LT1)))
        >> (((AWDThresholdsHighLow & 0x10000) >> 0xc)
            & ~(AWDThresholdsHighLow & ADCC.ADC_TR1_LT1)))
}

public func LL_ADC_SetAWDFilteringConfiguration<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ AWDy: UInt32, _ FilteringConfig: UInt32
) {
    _ = AWDy
    registers.write(
        ADCRegister.tr1, instance: ADCx,
        value: (registers.read(ADCRegister.tr1, instance: ADCx) & ~(ADCC.ADC_TR1_AWDFILT)) | (FilteringConfig))
}

public func LL_ADC_GetAWDFilteringConfiguration<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ AWDy: UInt32)
    -> UInt32
{
    _ = AWDy
    return ((registers.read(ADCRegister.tr1, instance: ADCx) & (ADCC.ADC_TR1_AWDFILT)))
}

public func LL_ADC_SetOverSamplingScope<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ OvsScope: UInt32) {
    registers.write(
        ADCRegister.cfgr2, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr2, instance: ADCx)
            & ~(ADCC.ADC_CFGR2_ROVSE | ADCC.ADC_CFGR2_JOVSE | ADCC.ADC_CFGR2_ROVSM)) | (OvsScope))
}

public func LL_ADC_GetOverSamplingScope<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return
        ((registers.read(ADCRegister.cfgr2, instance: ADCx)
        & (ADCC.ADC_CFGR2_ROVSE | ADCC.ADC_CFGR2_JOVSE | ADCC.ADC_CFGR2_ROVSM)))
}

public func LL_ADC_SetOverSamplingDiscont<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ OverSamplingDiscont: UInt32
) {
    registers.write(
        ADCRegister.cfgr2, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr2, instance: ADCx) & ~(ADCC.ADC_CFGR2_TROVS)) | (OverSamplingDiscont))
}

public func LL_ADC_GetOverSamplingDiscont<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr2, instance: ADCx) & (ADCC.ADC_CFGR2_TROVS)))
}

public func LL_ADC_ConfigOverSamplingRatioShift<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ Ratio: UInt32, _ Shift: UInt32
) {
    registers.write(
        ADCRegister.cfgr2, instance: ADCx,
        value: (registers.read(ADCRegister.cfgr2, instance: ADCx) & ~((ADCC.ADC_CFGR2_OVSS | ADCC.ADC_CFGR2_OVSR)))
            | ((Shift | Ratio)))
}

public func LL_ADC_GetOverSamplingRatio<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr2, instance: ADCx) & (ADCC.ADC_CFGR2_OVSR)))
}

public func LL_ADC_GetOverSamplingShift<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.cfgr2, instance: ADCx) & (ADCC.ADC_CFGR2_OVSS)))
}

public func LL_ADC_SetMultimode<IO: ADCRegisterIO>(_ registers: IO, _ Multimode: UInt32) {
    registers.writeCommon(
        ADCCommonRegister.ccr, value: (registers.readCommon(ADCCommonRegister.ccr) & ~(ADCC.ADC_CCR_DUAL)) | (Multimode)
    )
}

public func LL_ADC_GetMultimode<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.readCommon(ADCCommonRegister.ccr) & (ADCC.ADC_CCR_DUAL)))
}

public func LL_ADC_SetMultiDMATransfer<IO: ADCRegisterIO>(_ registers: IO, _ MultiDMATransfer: UInt32) {
    registers.writeCommon(
        ADCCommonRegister.ccr,
        value: (registers.readCommon(ADCCommonRegister.ccr) & ~(ADCC.ADC_CCR_MDMA | ADCC.ADC_CCR_DMACFG))
            | (MultiDMATransfer))
}

public func LL_ADC_GetMultiDMATransfer<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.readCommon(ADCCommonRegister.ccr) & (ADCC.ADC_CCR_MDMA | ADCC.ADC_CCR_DMACFG)))
}

public func LL_ADC_SetMultiTwoSamplingDelay<IO: ADCRegisterIO>(_ registers: IO, _ MultiTwoSamplingDelay: UInt32) {
    registers.writeCommon(
        ADCCommonRegister.ccr,
        value: (registers.readCommon(ADCCommonRegister.ccr) & ~(ADCC.ADC_CCR_DELAY)) | (MultiTwoSamplingDelay))
}

public func LL_ADC_GetMultiTwoSamplingDelay<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.readCommon(ADCCommonRegister.ccr) & (ADCC.ADC_CCR_DELAY)))
}

public func LL_ADC_EnableDeepPowerDown<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_BITS_PROPERTY_RS))
            | (ADCC.ADC_CR_DEEPPWD))
}

public func LL_ADC_DisableDeepPowerDown<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: registers.read(ADCRegister.cr, instance: ADCx) & ~((ADCC.ADC_CR_DEEPPWD | ADCC.ADC_CR_BITS_PROPERTY_RS)))
}

public func LL_ADC_IsDeepPowerDownEnabled<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_DEEPPWD)) == (ADCC.ADC_CR_DEEPPWD)) ? 1 : 0)
}

public func LL_ADC_EnableInternalRegulator<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_BITS_PROPERTY_RS))
            | (ADCC.ADC_CR_ADVREGEN))
}

public func LL_ADC_DisableInternalRegulator<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: registers.read(ADCRegister.cr, instance: ADCx) & ~((ADCC.ADC_CR_ADVREGEN | ADCC.ADC_CR_BITS_PROPERTY_RS))
    )
}

public func LL_ADC_IsInternalRegulatorEnabled<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return
        (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_ADVREGEN)) == (ADCC.ADC_CR_ADVREGEN)) ? 1 : 0)
}

public func LL_ADC_Enable<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_BITS_PROPERTY_RS)) | (ADCC.ADC_CR_ADEN))
}

public func LL_ADC_Disable<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_BITS_PROPERTY_RS)) | (ADCC.ADC_CR_ADDIS))
}

public func LL_ADC_IsEnabled<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_ADEN)) == (ADCC.ADC_CR_ADEN)) ? 1 : 0)
}

public func LL_ADC_IsDisableOngoing<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_ADDIS)) == (ADCC.ADC_CR_ADDIS)) ? 1 : 0)
}

public func LL_ADC_StartCalibration<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ SingleDiff: UInt32) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_ADCALDIF | ADCC.ADC_CR_BITS_PROPERTY_RS))
            | (ADCC.ADC_CR_ADCAL | (SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_START_MASK)))
}

public func LL_ADC_IsCalibrationOnGoing<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_ADCAL)) == (ADCC.ADC_CR_ADCAL)) ? 1 : 0)
}

public func LL_ADC_REG_StartConversion<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_BITS_PROPERTY_RS))
            | (ADCC.ADC_CR_ADSTART))
}

public func LL_ADC_REG_StopConversion<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_BITS_PROPERTY_RS)) | (ADCC.ADC_CR_ADSTP))
}

public func LL_ADC_REG_IsConversionOngoing<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_ADSTART)) == (ADCC.ADC_CR_ADSTART)) ? 1 : 0)
}

public func LL_ADC_REG_IsStopConversionOngoing<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_ADSTP)) == (ADCC.ADC_CR_ADSTP)) ? 1 : 0)
}

public func LL_ADC_REG_StartSamplingPhase<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cfgr2, instance: ADCx,
        value: registers.read(ADCRegister.cfgr2, instance: ADCx) | (ADCC.ADC_CFGR2_SWTRIG))
}

public func LL_ADC_REG_StopSamplingPhase<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cfgr2, instance: ADCx,
        value: registers.read(ADCRegister.cfgr2, instance: ADCx) & ~(ADCC.ADC_CFGR2_SWTRIG))
}

public func LL_ADC_REG_ReadConversionData32<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return ((registers.read(ADCRegister.dr, instance: ADCx) & (0xffff)))
}

public func LL_ADC_REG_ReadConversionData12<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt16 {
    return UInt16(truncatingIfNeeded: ((registers.read(ADCRegister.dr, instance: ADCx) & (0xffff))))
}

public func LL_ADC_REG_ReadConversionData10<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt16 {
    return UInt16(truncatingIfNeeded: ((registers.read(ADCRegister.dr, instance: ADCx) & (0xffff))))
}

public func LL_ADC_REG_ReadConversionData8<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt8 {
    return UInt8(truncatingIfNeeded: ((registers.read(ADCRegister.dr, instance: ADCx) & (0xffff))))
}

public func LL_ADC_REG_ReadConversionData6<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt8 {
    return UInt8(truncatingIfNeeded: ((registers.read(ADCRegister.dr, instance: ADCx) & (0xffff))))
}

public func LL_ADC_REG_ReadMultiConversionData32<IO: ADCRegisterIO>(_ registers: IO, _ ConversionData: UInt32) -> UInt32
{
    return
        ((registers.readCommon(ADCCommonRegister.cdr) & (ConversionData))
        >> (UInt32(ConversionData.trailingZeroBitCount) & 0x1F))
}

public func LL_ADC_INJ_StartConversion<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_BITS_PROPERTY_RS))
            | (ADCC.ADC_CR_JADSTART))
}

public func LL_ADC_INJ_StopConversion<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.cr, instance: ADCx,
        value: (registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_BITS_PROPERTY_RS)) | (ADCC.ADC_CR_JADSTP)
    )
}

public func LL_ADC_INJ_IsConversionOngoing<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return
        (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_JADSTART)) == (ADCC.ADC_CR_JADSTART)) ? 1 : 0)
}

public func LL_ADC_INJ_IsStopConversionOngoing<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.cr, instance: ADCx) & (ADCC.ADC_CR_JADSTP)) == (ADCC.ADC_CR_JADSTP)) ? 1 : 0)
}

public func LL_ADC_INJ_ReadConversionData32<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32)
    -> UInt32
{
    let preg = ADCRegister(rawValue: ADCRegister.jdr1.rawValue &+ ((((Rank & 0x300) >> 0x8)) << 2))!
    return ((registers.read(preg, instance: ADCx) & (0xffff)))
}

public func LL_ADC_INJ_ReadConversionData12<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32)
    -> UInt16
{
    let preg = ADCRegister(rawValue: ADCRegister.jdr1.rawValue &+ ((((Rank & 0x300) >> 0x8)) << 2))!
    return UInt16(truncatingIfNeeded: ((registers.read(preg, instance: ADCx) & (0xffff))))
}

public func LL_ADC_INJ_ReadConversionData10<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32)
    -> UInt16
{
    let preg = ADCRegister(rawValue: ADCRegister.jdr1.rawValue &+ ((((Rank & 0x300) >> 0x8)) << 2))!
    return UInt16(truncatingIfNeeded: ((registers.read(preg, instance: ADCx) & (0xffff))))
}

public func LL_ADC_INJ_ReadConversionData8<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32)
    -> UInt8
{
    let preg = ADCRegister(rawValue: ADCRegister.jdr1.rawValue &+ ((((Rank & 0x300) >> 0x8)) << 2))!
    return UInt8(truncatingIfNeeded: ((registers.read(preg, instance: ADCx) & (0xffff))))
}

public func LL_ADC_INJ_ReadConversionData6<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ Rank: UInt32)
    -> UInt8
{
    let preg = ADCRegister(rawValue: ADCRegister.jdr1.rawValue &+ ((((Rank & 0x300) >> 0x8)) << 2))!
    return UInt8(truncatingIfNeeded: ((registers.read(preg, instance: ADCx) & (0xffff))))
}

public func LL_ADC_IsActiveFlag_ADRDY<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_ADRDY)) == (LL_ADC_FLAG_ADRDY)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_EOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_EOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_EOS)) == (LL_ADC_FLAG_EOS)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_OVR<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_OVR)) == (LL_ADC_FLAG_OVR)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_EOSMP<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_EOSMP)) == (LL_ADC_FLAG_EOSMP)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_JEOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_JEOC)) == (LL_ADC_FLAG_JEOC)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_JEOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_JEOS)) == (LL_ADC_FLAG_JEOS)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_JQOVF<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_JQOVF)) == (LL_ADC_FLAG_JQOVF)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_AWD1<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_AWD1)) == (LL_ADC_FLAG_AWD1)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_AWD2<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_AWD2)) == (LL_ADC_FLAG_AWD2)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_AWD3<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.isr, instance: ADCx) & (LL_ADC_FLAG_AWD3)) == (LL_ADC_FLAG_AWD3)) ? 1 : 0)
}

public func LL_ADC_ClearFlag_ADRDY<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_ADRDY)
}

public func LL_ADC_ClearFlag_EOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_EOC)
}

public func LL_ADC_ClearFlag_EOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_EOS)
}

public func LL_ADC_ClearFlag_OVR<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_OVR)
}

public func LL_ADC_ClearFlag_EOSMP<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_EOSMP)
}

public func LL_ADC_ClearFlag_JEOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_JEOC)
}

public func LL_ADC_ClearFlag_JEOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_JEOS)
}

public func LL_ADC_ClearFlag_JQOVF<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_JQOVF)
}

public func LL_ADC_ClearFlag_AWD1<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_AWD1)
}

public func LL_ADC_ClearFlag_AWD2<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_AWD2)
}

public func LL_ADC_ClearFlag_AWD3<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(ADCRegister.isr, instance: ADCx, value: LL_ADC_FLAG_AWD3)
}

public func LL_ADC_IsActiveFlag_MST_ADRDY<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_ADRDY_MST)) == (LL_ADC_FLAG_ADRDY_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_ADRDY<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_ADRDY_SLV)) == (LL_ADC_FLAG_ADRDY_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_EOC<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_EOC_SLV)) == (LL_ADC_FLAG_EOC_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_EOC<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_EOC_SLV)) == (LL_ADC_FLAG_EOC_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_EOS<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_EOS_MST)) == (LL_ADC_FLAG_EOS_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_EOS<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_EOS_SLV)) == (LL_ADC_FLAG_EOS_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_OVR<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_OVR_MST)) == (LL_ADC_FLAG_OVR_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_OVR<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_OVR_SLV)) == (LL_ADC_FLAG_OVR_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_EOSMP<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_EOSMP_MST)) == (LL_ADC_FLAG_EOSMP_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_EOSMP<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_EOSMP_SLV)) == (LL_ADC_FLAG_EOSMP_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_JEOC<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_JEOC_MST)) == (LL_ADC_FLAG_JEOC_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_JEOC<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_JEOC_SLV)) == (LL_ADC_FLAG_JEOC_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_JEOS<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_JEOS_MST)) == (LL_ADC_FLAG_JEOS_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_JEOS<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_JEOS_SLV)) == (LL_ADC_FLAG_JEOS_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_JQOVF<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_JQOVF_MST)) == (LL_ADC_FLAG_JQOVF_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_JQOVF<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return
        (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_JQOVF_SLV)) == (LL_ADC_FLAG_JQOVF_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_AWD1<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_AWD1_MST)) == (LL_ADC_FLAG_AWD1_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_AWD1<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_AWD1_SLV)) == (LL_ADC_FLAG_AWD1_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_AWD2<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_AWD2_MST)) == (LL_ADC_FLAG_AWD2_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_AWD2<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_AWD2_SLV)) == (LL_ADC_FLAG_AWD2_SLV)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_MST_AWD3<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_AWD3_MST)) == (LL_ADC_FLAG_AWD3_MST)) ? 1 : 0)
}

public func LL_ADC_IsActiveFlag_SLV_AWD3<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.readCommon(ADCCommonRegister.csr) & (LL_ADC_FLAG_AWD3_SLV)) == (LL_ADC_FLAG_AWD3_SLV)) ? 1 : 0)
}

public func LL_ADC_EnableIT_ADRDY<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_ADRDY))
}

public func LL_ADC_EnableIT_EOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_EOC))
}

public func LL_ADC_EnableIT_EOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_EOS))
}

public func LL_ADC_EnableIT_OVR<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_OVR))
}

public func LL_ADC_EnableIT_EOSMP<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_EOSMP))
}

public func LL_ADC_EnableIT_JEOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_JEOC))
}

public func LL_ADC_EnableIT_JEOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_JEOS))
}

public func LL_ADC_EnableIT_JQOVF<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_JQOVF))
}

public func LL_ADC_EnableIT_AWD1<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_AWD1))
}

public func LL_ADC_EnableIT_AWD2<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_AWD2))
}

public func LL_ADC_EnableIT_AWD3<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) | (LL_ADC_IT_AWD3))
}

public func LL_ADC_DisableIT_ADRDY<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_ADRDY))
}

public func LL_ADC_DisableIT_EOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_EOC))
}

public func LL_ADC_DisableIT_EOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_EOS))
}

public func LL_ADC_DisableIT_OVR<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_OVR))
}

public func LL_ADC_DisableIT_EOSMP<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_EOSMP))
}

public func LL_ADC_DisableIT_JEOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_JEOC))
}

public func LL_ADC_DisableIT_JEOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_JEOS))
}

public func LL_ADC_DisableIT_JQOVF<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_JQOVF))
}

public func LL_ADC_DisableIT_AWD1<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_AWD1))
}

public func LL_ADC_DisableIT_AWD2<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_AWD2))
}

public func LL_ADC_DisableIT_AWD3<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) {
    registers.write(
        ADCRegister.ier, instance: ADCx, value: registers.read(ADCRegister.ier, instance: ADCx) & ~(LL_ADC_IT_AWD3))
}

public func LL_ADC_IsEnabledIT_ADRDY<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_ADRDY)) == (LL_ADC_IT_ADRDY)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_EOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_EOC)) == (LL_ADC_IT_EOC)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_EOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_EOS)) == (LL_ADC_IT_EOS)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_OVR<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_OVR)) == (LL_ADC_IT_OVR)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_EOSMP<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_EOSMP)) == (LL_ADC_IT_EOSMP)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_JEOC<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_JEOC)) == (LL_ADC_IT_JEOC)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_JEOS<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_JEOS)) == (LL_ADC_IT_JEOS)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_JQOVF<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_JQOVF)) == (LL_ADC_IT_JQOVF)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_AWD1<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_AWD1)) == (LL_ADC_IT_AWD1)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_AWD2<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_AWD2)) == (LL_ADC_IT_AWD2)) ? 1 : 0)
}

public func LL_ADC_IsEnabledIT_AWD3<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> UInt32 {
    return (((registers.read(ADCRegister.ier, instance: ADCx) & (LL_ADC_IT_AWD3)) == (LL_ADC_IT_AWD3)) ? 1 : 0)
}

public func LL_ADC_CommonDeInit<IO: LLBusRegisterIO>(_ registers: inout IO) -> LLErrorStatus {

    LL_AHB1_GRP1_ForceReset(&registers, LL_AHB1_GRP1_PERIPH_ADC12)

    LL_AHB1_GRP1_ReleaseReset(&registers, LL_AHB1_GRP1_PERIPH_ADC12)
    return LLErrorStatus(rawValue: LLErrorStatus.success.rawValue)!
}

public func LL_ADC_CommonInit<IO: ADCRegisterIO>(_ registers: IO, _ pADC_CommonInitStruct: LL_ADC_CommonInitTypeDef)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.success.rawValue

    if pADC_CommonInitStruct.Multimode != LL_ADC_MULTI_INDEPENDENT {

    }

    if __LL_ADC_IS_ENABLED_ALL_COMMON_INSTANCE(registers) == 0 {

        if pADC_CommonInitStruct.Multimode != LL_ADC_MULTI_INDEPENDENT {
            registers.writeCommon(
                ADCCommonRegister.ccr,
                value: (registers.readCommon(ADCCommonRegister.ccr)
                    & ~(ADCC.ADC_CCR_CKMODE
                    | ADCC.ADC_CCR_PRESC
                    | ADCC.ADC_CCR_DUAL
                    | ADCC.ADC_CCR_MDMA
                    | ADCC.ADC_CCR_DELAY))
                    | (pADC_CommonInitStruct.CommonClock
                        | pADC_CommonInitStruct.Multimode
                        | pADC_CommonInitStruct.MultiDMATransfer
                        | pADC_CommonInitStruct.MultiTwoSamplingDelay))
        } else {
            registers.writeCommon(
                ADCCommonRegister.ccr,
                value: (registers.readCommon(ADCCommonRegister.ccr)
                    & ~(ADCC.ADC_CCR_CKMODE
                    | ADCC.ADC_CCR_PRESC
                    | ADCC.ADC_CCR_DUAL
                    | ADCC.ADC_CCR_MDMA
                    | ADCC.ADC_CCR_DELAY))
                    | (pADC_CommonInitStruct.CommonClock
                        | LL_ADC_MULTI_INDEPENDENT))
        }
    } else {

        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_ADC_CommonStructInit(_ pADC_CommonInitStruct: inout LL_ADC_CommonInitTypeDef) {
    pADC_CommonInitStruct.CommonClock = LL_ADC_CLOCK_SYNC_PCLK_DIV2

    pADC_CommonInitStruct.Multimode = LL_ADC_MULTI_INDEPENDENT
    pADC_CommonInitStruct.MultiDMATransfer = LL_ADC_MULTI_REG_DMA_EACH_ADC
    pADC_CommonInitStruct.MultiTwoSamplingDelay = LL_ADC_MULTI_TWOSMP_DELAY_1CYCLE
}

public func LL_ADC_DeInit<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue
    var timeout_cpu_cycles: UInt32 = 0

    if LL_ADC_IsEnabled(registers, ADCx) == 1 {
        if LL_ADC_REG_IsConversionOngoing(registers, ADCx) != 0 {
            if LL_ADC_REG_IsStopConversionOngoing(registers, ADCx) == 0 {
                LL_ADC_REG_StopConversion(registers, ADCx)
            }
        }

        if LL_ADC_INJ_IsConversionOngoing(registers, ADCx) != 0 {
            if LL_ADC_INJ_IsStopConversionOngoing(registers, ADCx) == 0 {
                LL_ADC_INJ_StopConversion(registers, ADCx)
            }
        }

        timeout_cpu_cycles = 3968
        while (LL_ADC_REG_IsStopConversionOngoing(registers, ADCx)
            | LL_ADC_INJ_IsStopConversionOngoing(registers, ADCx)) == 1
        {
            timeout_cpu_cycles &-= 1
            if timeout_cpu_cycles == 0 {
                status = LLErrorStatus.error.rawValue
                break
            }
        }

        LL_ADC_INJ_SetQueueMode(registers, ADCx, LL_ADC_INJ_QUEUE_2CONTEXTS_END_EMPTY)

        LL_ADC_Disable(registers, ADCx)

        timeout_cpu_cycles = 3968
        while LL_ADC_IsDisableOngoing(registers, ADCx) == 1 {
            timeout_cpu_cycles &-= 1
            if timeout_cpu_cycles == 0 {
                status = LLErrorStatus.error.rawValue
                break
            }
        }
    }

    if (registers.read(ADCRegister.cr, instance: ADCx)
        & ((ADCC.ADC_CR_JADSTP | ADCC.ADC_CR_ADSTP | ADCC.ADC_CR_JADSTART | ADCC.ADC_CR_ADSTART
            | ADCC.ADC_CR_ADDIS | ADCC.ADC_CR_ADEN)))
        == 0
    {

        registers.write(
            ADCRegister.ier, instance: ADCx,
            value: registers.read(ADCRegister.ier, instance: ADCx)
                & ~((LL_ADC_IT_ADRDY
                | LL_ADC_IT_EOC
                | LL_ADC_IT_EOS
                | LL_ADC_IT_OVR
                | LL_ADC_IT_EOSMP
                | LL_ADC_IT_JEOC
                | LL_ADC_IT_JEOS
                | LL_ADC_IT_JQOVF
                | LL_ADC_IT_AWD1
                | LL_ADC_IT_AWD2
                | LL_ADC_IT_AWD3)))

        registers.write(
            ADCRegister.isr, instance: ADCx,
            value: registers.read(ADCRegister.isr, instance: ADCx)
                | ((LL_ADC_FLAG_ADRDY
                    | LL_ADC_FLAG_EOC
                    | LL_ADC_FLAG_EOS
                    | LL_ADC_FLAG_OVR
                    | LL_ADC_FLAG_EOSMP
                    | LL_ADC_FLAG_JEOC
                    | LL_ADC_FLAG_JEOS
                    | LL_ADC_FLAG_JQOVF
                    | LL_ADC_FLAG_AWD1
                    | LL_ADC_FLAG_AWD2
                    | LL_ADC_FLAG_AWD3)))

        registers.write(
            ADCRegister.cr, instance: ADCx,
            value: registers.read(ADCRegister.cr, instance: ADCx) & ~(ADCC.ADC_CR_ADVREGEN | ADCC.ADC_CR_ADCALDIF))
        registers.write(
            ADCRegister.cr, instance: ADCx,
            value: registers.read(ADCRegister.cr, instance: ADCx) | (ADCC.ADC_CR_DEEPPWD))

        registers.write(
            ADCRegister.cfgr, instance: ADCx,
            value: (registers.read(ADCRegister.cfgr, instance: ADCx)
                & ~((0x7c00_0000 | ADCC.ADC_CFGR_JAUTO | ADCC.ADC_CFGR_JAWD1EN
                | ADCC.ADC_CFGR_AWD1EN | ADCC.ADC_CFGR_AWD1SGL | ADCC.ADC_CFGR_JQM
                | ADCC.ADC_CFGR_JDISCEN | ADCC.ADC_CFGR_DISCNUM | ADCC.ADC_CFGR_DISCEN
                | ADCC.ADC_CFGR_AUTDLY | ADCC.ADC_CFGR_CONT | ADCC.ADC_CFGR_OVRMOD
                | ADCC.ADC_CFGR_EXTEN | ADCC.ADC_CFGR_EXTSEL | ADCC.ADC_CFGR_ALIGN
                | ADCC.ADC_CFGR_RES | ADCC.ADC_CFGR_DMACFG | ADCC.ADC_CFGR_DMAEN))) | (ADCC.ADC_CFGR_JQDIS))

        registers.write(
            ADCRegister.cfgr2, instance: ADCx,
            value: registers.read(ADCRegister.cfgr2, instance: ADCx)
                & ~((ADCC.ADC_CFGR2_ROVSM | ADCC.ADC_CFGR2_TROVS | ADCC.ADC_CFGR2_OVSS
                | ADCC.ADC_CFGR2_SWTRIG | ADCC.ADC_CFGR2_BULB | ADCC.ADC_CFGR2_SMPTRIG
                | ADCC.ADC_CFGR2_OVSR | ADCC.ADC_CFGR2_JOVSE | ADCC.ADC_CFGR2_ROVSE)))

        registers.write(
            ADCRegister.smpr1, instance: ADCx,
            value: registers.read(ADCRegister.smpr1, instance: ADCx)
                & ~((0x3800_0000 | 0x7000000 | 0xe00000
                | 0x1c0000 | 0x38000 | 0x7000
                | 0xe00 | 0x1c0 | 0x38)))

        registers.write(
            ADCRegister.smpr2, instance: ADCx,
            value: registers.read(ADCRegister.smpr2, instance: ADCx)
                & ~((ADCC.ADC_SMPR2_SMP18 | ADCC.ADC_SMPR2_SMP17 | ADCC.ADC_SMPR2_SMP16
                | ADCC.ADC_SMPR2_SMP15 | ADCC.ADC_SMPR2_SMP14 | ADCC.ADC_SMPR2_SMP13
                | ADCC.ADC_SMPR2_SMP12 | ADCC.ADC_SMPR2_SMP11 | ADCC.ADC_SMPR2_SMP10)))

        registers.write(
            ADCRegister.tr1, instance: ADCx,
            value: (registers.read(ADCRegister.tr1, instance: ADCx)
                & ~(ADCC.ADC_TR1_AWDFILT | ADCC.ADC_TR1_HT1 | ADCC.ADC_TR1_LT1)) | (ADCC.ADC_TR1_HT1))

        registers.write(
            ADCRegister.tr2, instance: ADCx,
            value: (registers.read(ADCRegister.tr2, instance: ADCx) & ~(ADCC.ADC_TR2_HT2 | ADCC.ADC_TR2_LT2))
                | (ADCC.ADC_TR2_HT2))

        registers.write(
            ADCRegister.tr3, instance: ADCx,
            value: (registers.read(ADCRegister.tr3, instance: ADCx) & ~(ADCC.ADC_TR3_HT3 | ADCC.ADC_TR3_LT3))
                | (ADCC.ADC_TR3_HT3))

        registers.write(
            ADCRegister.sqr1, instance: ADCx,
            value: registers.read(ADCRegister.sqr1, instance: ADCx)
                & ~((ADCC.ADC_SQR1_SQ4 | ADCC.ADC_SQR1_SQ3 | ADCC.ADC_SQR1_SQ2
                | ADCC.ADC_SQR1_SQ1 | ADCC.ADC_SQR1_L)))

        registers.write(
            ADCRegister.sqr2, instance: ADCx,
            value: registers.read(ADCRegister.sqr2, instance: ADCx)
                & ~((ADCC.ADC_SQR2_SQ9 | ADCC.ADC_SQR2_SQ8 | ADCC.ADC_SQR2_SQ7
                | ADCC.ADC_SQR2_SQ6 | ADCC.ADC_SQR2_SQ5)))

        registers.write(
            ADCRegister.sqr3, instance: ADCx,
            value: registers.read(ADCRegister.sqr3, instance: ADCx)
                & ~((ADCC.ADC_SQR3_SQ14 | ADCC.ADC_SQR3_SQ13 | ADCC.ADC_SQR3_SQ12
                | ADCC.ADC_SQR3_SQ11 | ADCC.ADC_SQR3_SQ10)))

        registers.write(
            ADCRegister.sqr4, instance: ADCx,
            value: registers.read(ADCRegister.sqr4, instance: ADCx) & ~(ADCC.ADC_SQR4_SQ16 | ADCC.ADC_SQR4_SQ15))

        registers.write(
            ADCRegister.jsqr, instance: ADCx,
            value: registers.read(ADCRegister.jsqr, instance: ADCx)
                & ~((ADCC.ADC_JSQR_JL
                | ADCC.ADC_JSQR_JEXTSEL | ADCC.ADC_JSQR_JEXTEN
                | ADCC.ADC_JSQR_JSQ4 | ADCC.ADC_JSQR_JSQ3
                | ADCC.ADC_JSQR_JSQ2 | ADCC.ADC_JSQR_JSQ1)))

        registers.write(
            ADCRegister.ofr1, instance: ADCx,
            value: registers.read(ADCRegister.ofr1, instance: ADCx)
                & ~(ADCC.ADC_OFR1_OFFSET1_EN | ADCC.ADC_OFR1_OFFSET1_CH | ADCC.ADC_OFR1_OFFSET1 | ADCC.ADC_OFR1_SATEN
                | ADCC.ADC_OFR1_OFFSETPOS))
        registers.write(
            ADCRegister.ofr2, instance: ADCx,
            value: registers.read(ADCRegister.ofr2, instance: ADCx)
                & ~(ADCC.ADC_OFR2_OFFSET2_EN | ADCC.ADC_OFR2_OFFSET2_CH | ADCC.ADC_OFR2_OFFSET2 | 0x2000000 | 0x1000000)
        )
        registers.write(
            ADCRegister.ofr3, instance: ADCx,
            value: registers.read(ADCRegister.ofr3, instance: ADCx)
                & ~(ADCC.ADC_OFR3_OFFSET3_EN | ADCC.ADC_OFR3_OFFSET3_CH | ADCC.ADC_OFR3_OFFSET3 | 0x2000000 | 0x1000000)
        )
        registers.write(
            ADCRegister.ofr4, instance: ADCx,
            value: registers.read(ADCRegister.ofr4, instance: ADCx)
                & ~(ADCC.ADC_OFR4_OFFSET4_EN | ADCC.ADC_OFR4_OFFSET4_CH | ADCC.ADC_OFR4_OFFSET4 | 0x2000000 | 0x1000000)
        )

        registers.write(
            ADCRegister.awd2cr, instance: ADCx,
            value: registers.read(ADCRegister.awd2cr, instance: ADCx) & ~(ADCC.ADC_AWD2CR_AWD2CH))

        registers.write(
            ADCRegister.awd3cr, instance: ADCx,
            value: registers.read(ADCRegister.awd3cr, instance: ADCx) & ~(ADCC.ADC_AWD3CR_AWD3CH))

        registers.write(
            ADCRegister.difsel, instance: ADCx,
            value: registers.read(ADCRegister.difsel, instance: ADCx) & ~(ADCC.ADC_DIFSEL_DIFSEL))

        registers.write(
            ADCRegister.calfact, instance: ADCx,
            value: registers.read(ADCRegister.calfact, instance: ADCx)
                & ~(ADCC.ADC_CALFACT_CALFACT_D | ADCC.ADC_CALFACT_CALFACT_S))
    } else {

        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_ADC_Init<IO: ADCRegisterIO>(_ registers: IO, _ ADCx: ADCInstance, _ pADC_InitStruct: LL_ADC_InitTypeDef)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.success.rawValue

    if LL_ADC_IsEnabled(registers, ADCx) == 0 {

        registers.write(
            ADCRegister.cfgr, instance: ADCx,
            value: (registers.read(ADCRegister.cfgr, instance: ADCx)
                & ~(ADCC.ADC_CFGR_RES
                | ADCC.ADC_CFGR_ALIGN
                | ADCC.ADC_CFGR_AUTDLY))
                | (pADC_InitStruct.Resolution
                    | pADC_InitStruct.DataAlignment
                    | pADC_InitStruct.LowPowerMode))
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_ADC_StructInit(_ pADC_InitStruct: inout LL_ADC_InitTypeDef) {
    pADC_InitStruct.Resolution = LL_ADC_RESOLUTION_12B
    pADC_InitStruct.DataAlignment = LL_ADC_DATA_ALIGN_RIGHT
    pADC_InitStruct.LowPowerMode = LL_ADC_LP_MODE_NONE
}

public func LL_ADC_REG_Init<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ pADC_RegInitStruct: LL_ADC_REG_InitTypeDef
) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue

    if pADC_RegInitStruct.SequencerLength != LL_ADC_REG_SEQ_SCAN_DISABLE {

    }

    if LL_ADC_IsEnabled(registers, ADCx) == 0 {

        if pADC_RegInitStruct.SequencerLength != LL_ADC_REG_SEQ_SCAN_DISABLE {
            registers.write(
                ADCRegister.cfgr, instance: ADCx,
                value: (registers.read(ADCRegister.cfgr, instance: ADCx)
                    & ~(ADCC.ADC_CFGR_EXTSEL
                    | ADCC.ADC_CFGR_EXTEN
                    | ADCC.ADC_CFGR_DISCEN
                    | ADCC.ADC_CFGR_DISCNUM
                    | ADCC.ADC_CFGR_CONT
                    | 0x4
                    | ADCC.ADC_CFGR_DMAEN
                    | ADCC.ADC_CFGR_DMACFG
                    | ADCC.ADC_CFGR_OVRMOD))
                    | (pADC_RegInitStruct.TriggerSource
                        | pADC_RegInitStruct.SequencerDiscont
                        | pADC_RegInitStruct.ContinuousMode
                        | pADC_RegInitStruct.DMATransfer
                        | pADC_RegInitStruct.Overrun))
        } else {
            registers.write(
                ADCRegister.cfgr, instance: ADCx,
                value: (registers.read(ADCRegister.cfgr, instance: ADCx)
                    & ~(ADCC.ADC_CFGR_EXTSEL
                    | ADCC.ADC_CFGR_EXTEN
                    | ADCC.ADC_CFGR_DISCEN
                    | ADCC.ADC_CFGR_DISCNUM
                    | ADCC.ADC_CFGR_CONT
                    | 0x4
                    | ADCC.ADC_CFGR_DMAEN
                    | ADCC.ADC_CFGR_DMACFG
                    | ADCC.ADC_CFGR_OVRMOD))
                    | (pADC_RegInitStruct.TriggerSource
                        | LL_ADC_REG_SEQ_DISCONT_DISABLE
                        | pADC_RegInitStruct.ContinuousMode
                        | pADC_RegInitStruct.DMATransfer
                        | pADC_RegInitStruct.Overrun))
        }

        LL_ADC_REG_SetSequencerLength(registers, ADCx, pADC_RegInitStruct.SequencerLength)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_ADC_REG_StructInit(_ pADC_RegInitStruct: inout LL_ADC_REG_InitTypeDef) {
    pADC_RegInitStruct.TriggerSource = LL_ADC_REG_TRIG_SOFTWARE
    pADC_RegInitStruct.SequencerLength = LL_ADC_REG_SEQ_SCAN_DISABLE
    pADC_RegInitStruct.SequencerDiscont = LL_ADC_REG_SEQ_DISCONT_DISABLE
    pADC_RegInitStruct.ContinuousMode = LL_ADC_REG_CONV_SINGLE
    pADC_RegInitStruct.DMATransfer = LL_ADC_REG_DMA_TRANSFER_NONE
    pADC_RegInitStruct.Overrun = LL_ADC_REG_OVR_DATA_OVERWRITTEN
}

public func LL_ADC_INJ_Init<IO: ADCRegisterIO>(
    _ registers: IO, _ ADCx: ADCInstance, _ pADC_InjInitStruct: LL_ADC_INJ_InitTypeDef
) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue

    if LL_ADC_IsEnabled(registers, ADCx) == 0 {

        if pADC_InjInitStruct.SequencerLength != LL_ADC_REG_SEQ_SCAN_DISABLE {
            registers.write(
                ADCRegister.cfgr, instance: ADCx,
                value: (registers.read(ADCRegister.cfgr, instance: ADCx)
                    & ~(ADCC.ADC_CFGR_JDISCEN
                    | ADCC.ADC_CFGR_JAUTO))
                    | (pADC_InjInitStruct.SequencerDiscont
                        | pADC_InjInitStruct.TrigAuto))
        } else {
            registers.write(
                ADCRegister.cfgr, instance: ADCx,
                value: (registers.read(ADCRegister.cfgr, instance: ADCx)
                    & ~(ADCC.ADC_CFGR_JDISCEN
                    | ADCC.ADC_CFGR_JAUTO))
                    | (LL_ADC_REG_SEQ_DISCONT_DISABLE
                        | pADC_InjInitStruct.TrigAuto))
        }
        registers.write(
            ADCRegister.jsqr, instance: ADCx,
            value: (registers.read(ADCRegister.jsqr, instance: ADCx)
                & ~(ADCC.ADC_JSQR_JEXTSEL
                | ADCC.ADC_JSQR_JEXTEN
                | ADCC.ADC_JSQR_JL))
                | (pADC_InjInitStruct.TriggerSource
                    | pADC_InjInitStruct.SequencerLength))
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_ADC_INJ_StructInit(_ pADC_InjInitStruct: inout LL_ADC_INJ_InitTypeDef) {
    pADC_InjInitStruct.TriggerSource = LL_ADC_INJ_TRIG_SOFTWARE
    pADC_InjInitStruct.SequencerLength = LL_ADC_INJ_SEQ_SCAN_DISABLE
    pADC_InjInitStruct.SequencerDiscont = LL_ADC_INJ_SEQ_DISCONT_DISABLE
    pADC_InjInitStruct.TrigAuto = LL_ADC_INJ_TRIG_INDEPENDENT
}
