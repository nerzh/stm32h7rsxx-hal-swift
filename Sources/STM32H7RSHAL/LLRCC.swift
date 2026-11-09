// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public enum LLRCCRegister: UInt32, CaseIterable, Sendable {
    case csicfgr = 0xC
    case crrcr = 0x8
    case pll1sscgr = 0xCC
    case pll2sscgr = 0xD0
    case pll3sscgr = 0xD4
}

public protocol LLRCCRegisterIO: RCCExtendedRegisterIO, LLBusRegisterIO {
    mutating func read(_ register: LLRCCRegister) -> UInt32
    mutating func write(_ register: LLRCCRegister, value: UInt32)
}

public let LL_RCC_PrescTable: InlineArray<16, UInt8> = [0, 0, 0, 0, 1, 2, 3, 4, 1, 2, 3, 4, 6, 7, 8, 9]

extension RCCOscillatorValues {
    // LL header defaults differ from the HAL external audio-clock default.
    public static var llDefaults: Self { .init(external: 12_288_000) }
}

public let LL_RCC_REG_SHIFT: UInt32 = 0x0000_0000
public let LL_RCC_POS_SHIFT: UInt32 = 0x0000_0008
public let LL_RCC_CONFIG_SHIFT: UInt32 = 0x0000_0010
public let LL_RCC_MASK_SHIFT: UInt32 = 0x0000_0018
public let LL_RCC_HSI_DIV_1: UInt32 = 0x0000_0000
public let LL_RCC_HSI_DIV_2: UInt32 = 0x0000_0008
public let LL_RCC_HSI_DIV_4: UInt32 = 0x0000_0010
public let LL_RCC_HSI_DIV_8: UInt32 = 0x0000_0018
public let LL_RCC_SWP_XSPI1_NEUTRAL: UInt32 = 0x0000_0000
public let LL_RCC_SWP_XSPI1_HCLK5: UInt32 = 0x0000_0010
public let LL_RCC_SWP_XSPI1_PLL2S: UInt32 = 0x0000_0020
public let LL_RCC_SWP_XSPI1_PLL2T: UInt32 = 0x0000_0030
public let LL_RCC_SWP_XSPI1_HCLK_DIV4: UInt32 = 0x0000_0040
public let LL_RCC_SWP_XSPI2_NEUTRAL: UInt32 = 0x0000_0000
public let LL_RCC_SWP_XSPI2_HCLK5: UInt32 = 0x0000_0100
public let LL_RCC_SWP_XSPI2_PLL2S: UInt32 = 0x0000_0200
public let LL_RCC_SWP_XSPI2_PLL2T: UInt32 = 0x0000_0300
public let LL_RCC_SWP_XSPI2_HCLK_DIV4: UInt32 = 0x0000_0400
public let LL_RCC_SWP_FMC_NEUTRAL: UInt32 = 0x0000_0000
public let LL_RCC_SWP_FMC_HCLK5: UInt32 = 0x0000_1000
public let LL_RCC_SWP_FMC_PLL1Q: UInt32 = 0x0000_2000
public let LL_RCC_SWP_FMC_PLL2R: UInt32 = 0x0000_3000
public let LL_RCC_SWP_FMC_HSI: UInt32 = 0x0000_4000
public let LL_RCC_SWP_FMC_HCLK_DIV4: UInt32 = 0x0000_5000
public let LL_RCC_LSEDRIVE_LOW: UInt32 = 0x0000_0000
public let LL_RCC_LSEDRIVE_MEDIUMLOW: UInt32 = 0x0000_0008
public let LL_RCC_LSEDRIVE_MEDIUMHIGH: UInt32 = 0x0000_0010
public let LL_RCC_LSEDRIVE_HIGH: UInt32 = 0x0000_0018
public let LL_RCC_SYS_CLKSOURCE_HSI: UInt32 = 0x0000_0000
public let LL_RCC_SYS_CLKSOURCE_CSI: UInt32 = 0x0000_0001
public let LL_RCC_SYS_CLKSOURCE_HSE: UInt32 = 0x0000_0002
public let LL_RCC_SYS_CLKSOURCE_PLL1: UInt32 = 0x0000_0003
public let LL_RCC_SYS_CLKSOURCE_STATUS_HSI: UInt32 = 0x0000_0000
public let LL_RCC_SYS_CLKSOURCE_STATUS_CSI: UInt32 = 0x0000_0008
public let LL_RCC_SYS_CLKSOURCE_STATUS_HSE: UInt32 = 0x0000_0010
public let LL_RCC_SYS_CLKSOURCE_STATUS_PLL1: UInt32 = 0x0000_0018
public let LL_RCC_SYSWAKEUP_CLKSOURCE_HSI: UInt32 = 0x0000_0000
public let LL_RCC_SYSWAKEUP_CLKSOURCE_CSI: UInt32 = 0x0000_0040
public let LL_RCC_KERWAKEUP_CLKSOURCE_HSI: UInt32 = 0x0000_0000
public let LL_RCC_KERWAKEUP_CLKSOURCE_CSI: UInt32 = 0x0000_0080
public let LL_RCC_SYSCLK_DIV_1: UInt32 = 0x0000_0000
public let LL_RCC_SYSCLK_DIV_2: UInt32 = 0x0000_0008
public let LL_RCC_SYSCLK_DIV_4: UInt32 = 0x0000_0009
public let LL_RCC_SYSCLK_DIV_8: UInt32 = 0x0000_000A
public let LL_RCC_SYSCLK_DIV_16: UInt32 = 0x0000_000B
public let LL_RCC_SYSCLK_DIV_64: UInt32 = 0x0000_000C
public let LL_RCC_SYSCLK_DIV_128: UInt32 = 0x0000_000D
public let LL_RCC_SYSCLK_DIV_256: UInt32 = 0x0000_000E
public let LL_RCC_SYSCLK_DIV_512: UInt32 = 0x0000_000F
public let LL_RCC_AHB_DIV_1: UInt32 = 0x0000_0000
public let LL_RCC_AHB_DIV_2: UInt32 = 0x0000_0008
public let LL_RCC_AHB_DIV_4: UInt32 = 0x0000_0009
public let LL_RCC_AHB_DIV_8: UInt32 = 0x0000_000A
public let LL_RCC_AHB_DIV_16: UInt32 = 0x0000_000B
public let LL_RCC_AHB_DIV_64: UInt32 = 0x0000_000C
public let LL_RCC_AHB_DIV_128: UInt32 = 0x0000_000D
public let LL_RCC_AHB_DIV_256: UInt32 = 0x0000_000E
public let LL_RCC_AHB_DIV_512: UInt32 = 0x0000_000F
public let LL_RCC_APB1_DIV_1: UInt32 = 0x0000_0000
public let LL_RCC_APB1_DIV_2: UInt32 = 0x0000_0004
public let LL_RCC_APB1_DIV_4: UInt32 = 0x0000_0005
public let LL_RCC_APB1_DIV_8: UInt32 = 0x0000_0006
public let LL_RCC_APB1_DIV_16: UInt32 = 0x0000_0007
public let LL_RCC_APB2_DIV_1: UInt32 = 0x0000_0000
public let LL_RCC_APB2_DIV_2: UInt32 = 0x0000_0040
public let LL_RCC_APB2_DIV_4: UInt32 = 0x0000_0050
public let LL_RCC_APB2_DIV_8: UInt32 = 0x0000_0060
public let LL_RCC_APB2_DIV_16: UInt32 = 0x0000_0070
public let LL_RCC_APB4_DIV_1: UInt32 = 0x0000_0000
public let LL_RCC_APB4_DIV_2: UInt32 = 0x0000_0400
public let LL_RCC_APB4_DIV_4: UInt32 = 0x0000_0500
public let LL_RCC_APB4_DIV_8: UInt32 = 0x0000_0600
public let LL_RCC_APB4_DIV_16: UInt32 = 0x0000_0700
public let LL_RCC_APB5_DIV_1: UInt32 = 0x0000_0000
public let LL_RCC_APB5_DIV_2: UInt32 = 0x0000_4000
public let LL_RCC_APB5_DIV_4: UInt32 = 0x0000_5000
public let LL_RCC_APB5_DIV_8: UInt32 = 0x0000_6000
public let LL_RCC_APB5_DIV_16: UInt32 = 0x0000_7000
public let LL_RCC_MCO1SOURCE_HSI: UInt32 = 0x0000_01C0
public let LL_RCC_MCO1SOURCE_LSE: UInt32 = 0x0040_01C0
public let LL_RCC_MCO1SOURCE_HSE: UInt32 = 0x0080_01C0
public let LL_RCC_MCO1SOURCE_PLL1Q: UInt32 = 0x00C0_01C0
public let LL_RCC_MCO1SOURCE_HSI48: UInt32 = 0x0100_01C0
public let LL_RCC_MCO2SOURCE_SYSCLK: UInt32 = 0x0000_E000
public let LL_RCC_MCO2SOURCE_PLL2P: UInt32 = 0x2000_E000
public let LL_RCC_MCO2SOURCE_HSE: UInt32 = 0x4000_E000
public let LL_RCC_MCO2SOURCE_PLL1P: UInt32 = 0x6000_E000
public let LL_RCC_MCO2SOURCE_CSI: UInt32 = 0x8000_E000
public let LL_RCC_MCO2SOURCE_LSI: UInt32 = 0xA000_E000
public let LL_RCC_MCO1_DIV_1: UInt32 = 0x0004_003C
public let LL_RCC_MCO1_DIV_2: UInt32 = 0x0008_003C
public let LL_RCC_MCO1_DIV_3: UInt32 = 0x000C_003C
public let LL_RCC_MCO1_DIV_4: UInt32 = 0x0010_003C
public let LL_RCC_MCO1_DIV_5: UInt32 = 0x0014_003C
public let LL_RCC_MCO1_DIV_6: UInt32 = 0x0018_003C
public let LL_RCC_MCO1_DIV_7: UInt32 = 0x001C_003C
public let LL_RCC_MCO1_DIV_8: UInt32 = 0x0020_003C
public let LL_RCC_MCO1_DIV_9: UInt32 = 0x0024_003C
public let LL_RCC_MCO1_DIV_10: UInt32 = 0x0028_003C
public let LL_RCC_MCO1_DIV_11: UInt32 = 0x002C_003C
public let LL_RCC_MCO1_DIV_12: UInt32 = 0x0030_003C
public let LL_RCC_MCO1_DIV_13: UInt32 = 0x0034_003C
public let LL_RCC_MCO1_DIV_14: UInt32 = 0x0038_003C
public let LL_RCC_MCO1_DIV_15: UInt32 = 0x003C_003C
public let LL_RCC_MCO2_DIV_1: UInt32 = 0x0200_1E00
public let LL_RCC_MCO2_DIV_2: UInt32 = 0x0400_1E00
public let LL_RCC_MCO2_DIV_3: UInt32 = 0x0600_1E00
public let LL_RCC_MCO2_DIV_4: UInt32 = 0x0800_1E00
public let LL_RCC_MCO2_DIV_5: UInt32 = 0x0A00_1E00
public let LL_RCC_MCO2_DIV_6: UInt32 = 0x0C00_1E00
public let LL_RCC_MCO2_DIV_7: UInt32 = 0x0E00_1E00
public let LL_RCC_MCO2_DIV_8: UInt32 = 0x1000_1E00
public let LL_RCC_MCO2_DIV_9: UInt32 = 0x1200_1E00
public let LL_RCC_MCO2_DIV_10: UInt32 = 0x1400_1E00
public let LL_RCC_MCO2_DIV_11: UInt32 = 0x1600_1E00
public let LL_RCC_MCO2_DIV_12: UInt32 = 0x1800_1E00
public let LL_RCC_MCO2_DIV_13: UInt32 = 0x1A00_1E00
public let LL_RCC_MCO2_DIV_14: UInt32 = 0x1C00_1E00
public let LL_RCC_MCO2_DIV_15: UInt32 = 0x1E00_1E00
public let LL_RCC_RTC_NOCLOCK: UInt32 = 0x0000_0000
public let LL_RCC_RTC_HSE_DIV_2: UInt32 = 0x0000_0200
public let LL_RCC_RTC_HSE_DIV_3: UInt32 = 0x0000_0300
public let LL_RCC_RTC_HSE_DIV_4: UInt32 = 0x0000_0400
public let LL_RCC_RTC_HSE_DIV_5: UInt32 = 0x0000_0500
public let LL_RCC_RTC_HSE_DIV_6: UInt32 = 0x0000_0600
public let LL_RCC_RTC_HSE_DIV_7: UInt32 = 0x0000_0700
public let LL_RCC_RTC_HSE_DIV_8: UInt32 = 0x0000_0800
public let LL_RCC_RTC_HSE_DIV_9: UInt32 = 0x0000_0900
public let LL_RCC_RTC_HSE_DIV_10: UInt32 = 0x0000_0A00
public let LL_RCC_RTC_HSE_DIV_11: UInt32 = 0x0000_0B00
public let LL_RCC_RTC_HSE_DIV_12: UInt32 = 0x0000_0C00
public let LL_RCC_RTC_HSE_DIV_13: UInt32 = 0x0000_0D00
public let LL_RCC_RTC_HSE_DIV_14: UInt32 = 0x0000_0E00
public let LL_RCC_RTC_HSE_DIV_15: UInt32 = 0x0000_0F00
public let LL_RCC_RTC_HSE_DIV_16: UInt32 = 0x0000_1000
public let LL_RCC_RTC_HSE_DIV_17: UInt32 = 0x0000_1100
public let LL_RCC_RTC_HSE_DIV_18: UInt32 = 0x0000_1200
public let LL_RCC_RTC_HSE_DIV_19: UInt32 = 0x0000_1300
public let LL_RCC_RTC_HSE_DIV_20: UInt32 = 0x0000_1400
public let LL_RCC_RTC_HSE_DIV_21: UInt32 = 0x0000_1500
public let LL_RCC_RTC_HSE_DIV_22: UInt32 = 0x0000_1600
public let LL_RCC_RTC_HSE_DIV_23: UInt32 = 0x0000_1700
public let LL_RCC_RTC_HSE_DIV_24: UInt32 = 0x0000_1800
public let LL_RCC_RTC_HSE_DIV_25: UInt32 = 0x0000_1900
public let LL_RCC_RTC_HSE_DIV_26: UInt32 = 0x0000_1A00
public let LL_RCC_RTC_HSE_DIV_27: UInt32 = 0x0000_1B00
public let LL_RCC_RTC_HSE_DIV_28: UInt32 = 0x0000_1C00
public let LL_RCC_RTC_HSE_DIV_29: UInt32 = 0x0000_1D00
public let LL_RCC_RTC_HSE_DIV_30: UInt32 = 0x0000_1E00
public let LL_RCC_RTC_HSE_DIV_31: UInt32 = 0x0000_1F00
public let LL_RCC_RTC_HSE_DIV_32: UInt32 = 0x0000_2000
public let LL_RCC_RTC_HSE_DIV_33: UInt32 = 0x0000_2100
public let LL_RCC_RTC_HSE_DIV_34: UInt32 = 0x0000_2200
public let LL_RCC_RTC_HSE_DIV_35: UInt32 = 0x0000_2300
public let LL_RCC_RTC_HSE_DIV_36: UInt32 = 0x0000_2400
public let LL_RCC_RTC_HSE_DIV_37: UInt32 = 0x0000_2500
public let LL_RCC_RTC_HSE_DIV_38: UInt32 = 0x0000_2600
public let LL_RCC_RTC_HSE_DIV_39: UInt32 = 0x0000_2700
public let LL_RCC_RTC_HSE_DIV_40: UInt32 = 0x0000_2800
public let LL_RCC_RTC_HSE_DIV_41: UInt32 = 0x0000_2900
public let LL_RCC_RTC_HSE_DIV_42: UInt32 = 0x0000_2A00
public let LL_RCC_RTC_HSE_DIV_43: UInt32 = 0x0000_2B00
public let LL_RCC_RTC_HSE_DIV_44: UInt32 = 0x0000_2C00
public let LL_RCC_RTC_HSE_DIV_45: UInt32 = 0x0000_2D00
public let LL_RCC_RTC_HSE_DIV_46: UInt32 = 0x0000_2E00
public let LL_RCC_RTC_HSE_DIV_47: UInt32 = 0x0000_2F00
public let LL_RCC_RTC_HSE_DIV_48: UInt32 = 0x0000_3000
public let LL_RCC_RTC_HSE_DIV_49: UInt32 = 0x0000_3100
public let LL_RCC_RTC_HSE_DIV_50: UInt32 = 0x0000_3200
public let LL_RCC_RTC_HSE_DIV_51: UInt32 = 0x0000_3300
public let LL_RCC_RTC_HSE_DIV_52: UInt32 = 0x0000_3400
public let LL_RCC_RTC_HSE_DIV_53: UInt32 = 0x0000_3500
public let LL_RCC_RTC_HSE_DIV_54: UInt32 = 0x0000_3600
public let LL_RCC_RTC_HSE_DIV_55: UInt32 = 0x0000_3700
public let LL_RCC_RTC_HSE_DIV_56: UInt32 = 0x0000_3800
public let LL_RCC_RTC_HSE_DIV_57: UInt32 = 0x0000_3900
public let LL_RCC_RTC_HSE_DIV_58: UInt32 = 0x0000_3A00
public let LL_RCC_RTC_HSE_DIV_59: UInt32 = 0x0000_3B00
public let LL_RCC_RTC_HSE_DIV_60: UInt32 = 0x0000_3C00
public let LL_RCC_RTC_HSE_DIV_61: UInt32 = 0x0000_3D00
public let LL_RCC_RTC_HSE_DIV_62: UInt32 = 0x0000_3E00
public let LL_RCC_RTC_HSE_DIV_63: UInt32 = 0x0000_3F00
public let LL_RCC_ADC_CLKSOURCE_PLL2P: UInt32 = 0x0000_0000
public let LL_RCC_ADC_CLKSOURCE_PLL3R: UInt32 = 0x0100_0000
public let LL_RCC_ADC_CLKSOURCE_CLKP: UInt32 = 0x0200_0000
public let LL_RCC_ADF1_CLKSOURCE_HCLK: UInt32 = 0x0000_0000
public let LL_RCC_ADF1_CLKSOURCE_PLL2P: UInt32 = 0x0010_0000
public let LL_RCC_ADF1_CLKSOURCE_PLL3P: UInt32 = 0x0020_0000
public let LL_RCC_ADF1_CLKSOURCE_I2S_CKIN: UInt32 = 0x0030_0000
public let LL_RCC_ADF1_CLKSOURCE_CSI: UInt32 = 0x0040_0000
public let LL_RCC_ADF1_CLKSOURCE_HSI: UInt32 = 0x0050_0000
public let LL_RCC_CEC_CLKSOURCE_LSE: UInt32 = 0x0000_0000
public let LL_RCC_CEC_CLKSOURCE_LSI: UInt32 = 0x1000_0000
public let LL_RCC_CEC_CLKSOURCE_CSI_DIV_122: UInt32 = 0x2000_0000
public let LL_RCC_CLKP_CLKSOURCE_HSI: UInt32 = 0x0000_0000
public let LL_RCC_CLKP_CLKSOURCE_CSI: UInt32 = 0x1000_0000
public let LL_RCC_CLKP_CLKSOURCE_HSE: UInt32 = 0x2000_0000
public let LL_RCC_ETH1PHY_CLKSOURCE_HSE: UInt32 = 0x0000_0000
public let LL_RCC_ETH1PHY_CLKSOURCE_PLL3S: UInt32 = 0x0004_0000
public let LL_RCC_ETH1REF_CLKSOURCE_RMII: UInt32 = 0x0000_0000
public let LL_RCC_ETH1REF_CLKSOURCE_HSE: UInt32 = 0x0001_0000
public let LL_RCC_ETH1REF_CLKSOURCE_FB: UInt32 = 0x0002_0000
public let LL_RCC_FDCAN_CLKSOURCE_HSE: UInt32 = 0x0000_0000
public let LL_RCC_FDCAN_CLKSOURCE_PLL1Q: UInt32 = 0x0040_0000
public let LL_RCC_FDCAN_CLKSOURCE_PLL2Q: UInt32 = 0x0080_0000
public let LL_RCC_FMC_CLKSOURCE_HCLK: UInt32 = 0x0000_0000
public let LL_RCC_FMC_CLKSOURCE_PLL1Q: UInt32 = 0x0000_0001
public let LL_RCC_FMC_CLKSOURCE_PLL2R: UInt32 = 0x0000_0002
public let LL_RCC_FMC_CLKSOURCE_HSI: UInt32 = 0x0000_0003
public let LL_RCC_FMC_CLKSOURCE_HCLK_DIV4: UInt32 = 0x0000_5000
public let LL_RCC_I2C1_CLKSOURCE_PCLK1: UInt32 = 0x0300_0C04
public let LL_RCC_I2C1_CLKSOURCE_PLL3R: UInt32 = 0x0301_0C04
public let LL_RCC_I2C1_CLKSOURCE_HSI: UInt32 = 0x0302_0C04
public let LL_RCC_I2C1_CLKSOURCE_CSI: UInt32 = 0x0303_0C04
public let LL_RCC_I2C23_CLKSOURCE_PCLK1: UInt32 = 0x0300_0804
public let LL_RCC_I2C23_CLKSOURCE_PLL3R: UInt32 = 0x0301_0804
public let LL_RCC_I2C23_CLKSOURCE_HSI: UInt32 = 0x0302_0804
public let LL_RCC_I2C23_CLKSOURCE_CSI: UInt32 = 0x0303_0804
public let LL_RCC_I3C1_CLKSOURCE_PCLK1: UInt32 = 0x0000_0000
public let LL_RCC_I3C1_CLKSOURCE_PLL3R: UInt32 = 0x0000_1000
public let LL_RCC_I3C1_CLKSOURCE_HSI: UInt32 = 0x0000_2000
public let LL_RCC_I3C1_CLKSOURCE_CSI: UInt32 = 0x0000_3000
public let LL_RCC_LPTIM1_CLKSOURCE_PCLK1: UInt32 = 0x0700_1004
public let LL_RCC_LPTIM1_CLKSOURCE_PLL2P: UInt32 = 0x0701_1004
public let LL_RCC_LPTIM1_CLKSOURCE_PLL3R: UInt32 = 0x0702_1004
public let LL_RCC_LPTIM1_CLKSOURCE_LSE: UInt32 = 0x0703_1004
public let LL_RCC_LPTIM1_CLKSOURCE_LSI: UInt32 = 0x0704_1004
public let LL_RCC_LPTIM1_CLKSOURCE_CLKP: UInt32 = 0x0705_1004
public let LL_RCC_LPTIM23_CLKSOURCE_PCLK4: UInt32 = 0x0700_080C
public let LL_RCC_LPTIM23_CLKSOURCE_PLL2P: UInt32 = 0x0701_080C
public let LL_RCC_LPTIM23_CLKSOURCE_PLL3R: UInt32 = 0x0702_080C
public let LL_RCC_LPTIM23_CLKSOURCE_LSE: UInt32 = 0x0703_080C
public let LL_RCC_LPTIM23_CLKSOURCE_LSI: UInt32 = 0x0704_080C
public let LL_RCC_LPTIM23_CLKSOURCE_CLKP: UInt32 = 0x0705_080C
public let LL_RCC_LPTIM45_CLKSOURCE_PCLK4: UInt32 = 0x0700_0C0C
public let LL_RCC_LPTIM45_CLKSOURCE_PLL2P: UInt32 = 0x0701_0C0C
public let LL_RCC_LPTIM45_CLKSOURCE_PLL3R: UInt32 = 0x0702_0C0C
public let LL_RCC_LPTIM45_CLKSOURCE_LSE: UInt32 = 0x0703_0C0C
public let LL_RCC_LPTIM45_CLKSOURCE_LSI: UInt32 = 0x0704_0C0C
public let LL_RCC_LPTIM45_CLKSOURCE_CLKP: UInt32 = 0x0705_0C0C
public let LL_RCC_LPUART1_CLKSOURCE_PCLK4: UInt32 = 0x0000_0000
public let LL_RCC_LPUART1_CLKSOURCE_PLL2Q: UInt32 = 0x0000_0001
public let LL_RCC_LPUART1_CLKSOURCE_PLL3Q: UInt32 = 0x0000_0002
public let LL_RCC_LPUART1_CLKSOURCE_HSI: UInt32 = 0x0000_0003
public let LL_RCC_LPUART1_CLKSOURCE_CSI: UInt32 = 0x0000_0004
public let LL_RCC_LPUART1_CLKSOURCE_LSE: UInt32 = 0x0000_0005
public let LL_RCC_LTDC_CLKSOURCE_PLL3R: UInt32 = 0x0000_0000
public let LL_RCC_PSSI_CLKSOURCE_PLL3R: UInt32 = 0x0000_0000
public let LL_RCC_PSSI_CLKSOURCE_CLKP: UInt32 = 0x0800_0000
public let LL_RCC_SAI1_CLKSOURCE_PLL1Q: UInt32 = 0x0700_1008
public let LL_RCC_SAI1_CLKSOURCE_PLL2P: UInt32 = 0x0701_1008
public let LL_RCC_SAI1_CLKSOURCE_PLL3P: UInt32 = 0x0702_1008
public let LL_RCC_SAI1_CLKSOURCE_I2S_CKIN: UInt32 = 0x0703_1008
public let LL_RCC_SAI1_CLKSOURCE_CLKP: UInt32 = 0x0704_1008
public let LL_RCC_SAI2_CLKSOURCE_PLL1Q: UInt32 = 0x0700_1408
public let LL_RCC_SAI2_CLKSOURCE_PLL2P: UInt32 = 0x0701_1408
public let LL_RCC_SAI2_CLKSOURCE_PLL3P: UInt32 = 0x0702_1408
public let LL_RCC_SAI2_CLKSOURCE_I2S_CKIN: UInt32 = 0x0703_1408
public let LL_RCC_SAI2_CLKSOURCE_CLKP: UInt32 = 0x0704_1408
public let LL_RCC_SAI2_CLKSOURCE_SPDIFRX: UInt32 = 0x0701_1408
public let LL_RCC_SDMMC_CLKSOURCE_PLL2S: UInt32 = 0x0000_0000
public let LL_RCC_SDMMC_CLKSOURCE_PLL2T: UInt32 = 0x0000_0004
public let LL_RCC_SPDIFRX_CLKSOURCE_PLL1Q: UInt32 = 0x0000_0000
public let LL_RCC_SPDIFRX_CLKSOURCE_PLL2R: UInt32 = 0x0100_0000
public let LL_RCC_SPDIFRX_CLKSOURCE_PLL3R: UInt32 = 0x0200_0000
public let LL_RCC_SPDIFRX_CLKSOURCE_HSI: UInt32 = 0x0300_0000
public let LL_RCC_SPI1_CLKSOURCE_PLL1Q: UInt32 = 0x0700_0808
public let LL_RCC_SPI1_CLKSOURCE_PLL2P: UInt32 = 0x0701_0808
public let LL_RCC_SPI1_CLKSOURCE_PLL3P: UInt32 = 0x0702_0808
public let LL_RCC_SPI1_CLKSOURCE_I2S_CKIN: UInt32 = 0x0703_0808
public let LL_RCC_SPI1_CLKSOURCE_CLKP: UInt32 = 0x0704_0808
public let LL_RCC_SPI23_CLKSOURCE_PLL1Q: UInt32 = 0x0700_0404
public let LL_RCC_SPI23_CLKSOURCE_PLL2P: UInt32 = 0x0701_0404
public let LL_RCC_SPI23_CLKSOURCE_PLL3P: UInt32 = 0x0702_0404
public let LL_RCC_SPI23_CLKSOURCE_I2S_CKIN: UInt32 = 0x0703_0404
public let LL_RCC_SPI23_CLKSOURCE_CLKP: UInt32 = 0x0704_0404
public let LL_RCC_SPI45_CLKSOURCE_PCLK2: UInt32 = 0x0700_0408
public let LL_RCC_SPI45_CLKSOURCE_PLL2Q: UInt32 = 0x0701_0408
public let LL_RCC_SPI45_CLKSOURCE_PLL3Q: UInt32 = 0x0702_0408
public let LL_RCC_SPI45_CLKSOURCE_HSI: UInt32 = 0x0703_0408
public let LL_RCC_SPI45_CLKSOURCE_CSI: UInt32 = 0x0704_0408
public let LL_RCC_SPI45_CLKSOURCE_HSE: UInt32 = 0x0705_0408
public let LL_RCC_SPI6_CLKSOURCE_PCLK4: UInt32 = 0x0700_040C
public let LL_RCC_SPI6_CLKSOURCE_PLL2Q: UInt32 = 0x0701_040C
public let LL_RCC_SPI6_CLKSOURCE_PLL3Q: UInt32 = 0x0702_040C
public let LL_RCC_SPI6_CLKSOURCE_HSI: UInt32 = 0x0703_040C
public let LL_RCC_SPI6_CLKSOURCE_CSI: UInt32 = 0x0704_040C
public let LL_RCC_SPI6_CLKSOURCE_HSE: UInt32 = 0x0705_040C
public let LL_RCC_USART1_CLKSOURCE_PCLK2: UInt32 = 0x0700_0008
public let LL_RCC_USART1_CLKSOURCE_PLL2Q: UInt32 = 0x0701_0008
public let LL_RCC_USART1_CLKSOURCE_PLL3Q: UInt32 = 0x0702_0008
public let LL_RCC_USART1_CLKSOURCE_HSI: UInt32 = 0x0703_0008
public let LL_RCC_USART1_CLKSOURCE_CSI: UInt32 = 0x0704_0008
public let LL_RCC_USART1_CLKSOURCE_LSE: UInt32 = 0x0705_0008
public let LL_RCC_USART234578_CLKSOURCE_PCLK1: UInt32 = 0x0700_0004
public let LL_RCC_USART234578_CLKSOURCE_PLL2Q: UInt32 = 0x0701_0004
public let LL_RCC_USART234578_CLKSOURCE_PLL3Q: UInt32 = 0x0702_0004
public let LL_RCC_USART234578_CLKSOURCE_HSI: UInt32 = 0x0703_0004
public let LL_RCC_USART234578_CLKSOURCE_CSI: UInt32 = 0x0704_0004
public let LL_RCC_USART234578_CLKSOURCE_LSE: UInt32 = 0x0705_0004
public let LL_RCC_OTGFS_CLKSOURCE_HSI48: UInt32 = 0x0000_0000
public let LL_RCC_OTGFS_CLKSOURCE_PLL3Q: UInt32 = 0x0000_4000
public let LL_RCC_OTGFS_CLKSOURCE_HSE: UInt32 = 0x0000_8000
public let LL_RCC_OTGFS_CLKSOURCE_CLK48: UInt32 = 0x0000_C000
public let LL_RCC_USBPHYC_CLKSOURCE_HSE: UInt32 = 0x0000_0000
public let LL_RCC_USBPHYC_CLKSOURCE_HSE_DIV_2: UInt32 = 0x0000_1000
public let LL_RCC_USBPHYC_CLKSOURCE_PLL3Q: UInt32 = 0x0000_2000
public let LL_RCC_USBPHYC_CLKSOURCE_DISABLE: UInt32 = 0x0000_3000
public let LL_RCC_USBREF_CLKSOURCE_16M: UInt32 = 0x0000_0300
public let LL_RCC_USBREF_CLKSOURCE_19_2M: UInt32 = 0x0000_0800
public let LL_RCC_USBREF_CLKSOURCE_20M: UInt32 = 0x0000_0900
public let LL_RCC_USBREF_CLKSOURCE_24M: UInt32 = 0x0000_0A00
public let LL_RCC_USBREF_CLKSOURCE_26M: UInt32 = 0x0000_0E00
public let LL_RCC_USBREF_CLKSOURCE_32M: UInt32 = 0x0000_0B00
public let LL_RCC_XSPI1_CLKSOURCE_HCLK: UInt32 = 0x0300_0400
public let LL_RCC_XSPI1_CLKSOURCE_PLL2S: UInt32 = 0x0301_0400
public let LL_RCC_XSPI1_CLKSOURCE_PLL2T: UInt32 = 0x0302_0400
public let LL_RCC_XSPI1_CLKSOURCE_HCLK_DIV4: UInt32 = 0x0000_0040
public let LL_RCC_XSPI2_CLKSOURCE_HCLK: UInt32 = 0x0300_0600
public let LL_RCC_XSPI2_CLKSOURCE_PLL2S: UInt32 = 0x0301_0600
public let LL_RCC_XSPI2_CLKSOURCE_PLL2T: UInt32 = 0x0302_0600
public let LL_RCC_XSPI2_CLKSOURCE_HCLK_DIV4: UInt32 = 0x0000_0400
public let LL_RCC_ADC_CLKSOURCE: UInt32 = 0x0300_0000
public let LL_RCC_ADF1_CLKSOURCE: UInt32 = 0x0070_0000
public let LL_RCC_CEC_CLKSOURCE: UInt32 = 0x3000_0000
public let LL_RCC_CLKP_CLKSOURCE: UInt32 = 0x3000_0000
public let LL_RCC_ETH1PHY_CLKSOURCE: UInt32 = 0x0004_0000
public let LL_RCC_ETH1REF_CLKSOURCE: UInt32 = 0x0003_0000
public let LL_RCC_FDCAN_CLKSOURCE: UInt32 = 0x00C0_0000
public let LL_RCC_FMC_CLKSOURCE: UInt32 = 0x0000_0003
public let LL_RCC_I2C1_CLKSOURCE: UInt32 = 0x0300_0C04
public let LL_RCC_I2C23_CLKSOURCE: UInt32 = 0x0300_0804
public let LL_RCC_I3C1_CLKSOURCE: UInt32 = 0x0000_3000
public let LL_RCC_LPTIM1_CLKSOURCE: UInt32 = 0x0700_1004
public let LL_RCC_LPTIM23_CLKSOURCE: UInt32 = 0x0700_080C
public let LL_RCC_LPTIM45_CLKSOURCE: UInt32 = 0x0700_0C0C
public let LL_RCC_LPUART1_CLKSOURCE: UInt32 = 0x0000_0007
public let LL_RCC_OTGFS_CLKSOURCE: UInt32 = 0x0000_C000
public let LL_RCC_PSSI_CLKSOURCE: UInt32 = 0x0800_0000
public let LL_RCC_SAI1_CLKSOURCE: UInt32 = 0x0700_1008
public let LL_RCC_SAI2_CLKSOURCE: UInt32 = 0x0700_1408
public let LL_RCC_SDMMC_CLKSOURCE: UInt32 = 0x0000_0004
public let LL_RCC_SPDIFRX_CLKSOURCE: UInt32 = 0x0300_0000
public let LL_RCC_SPI1_CLKSOURCE: UInt32 = 0x0700_0808
public let LL_RCC_SPI23_CLKSOURCE: UInt32 = 0x0700_0404
public let LL_RCC_SPI45_CLKSOURCE: UInt32 = 0x0700_0408
public let LL_RCC_SPI6_CLKSOURCE: UInt32 = 0x0700_040C
public let LL_RCC_USART1_CLKSOURCE: UInt32 = 0x0700_0008
public let LL_RCC_USART234578_CLKSOURCE: UInt32 = 0x0700_0004
public let LL_RCC_USBPHYC_CLKSOURCE: UInt32 = 0x0000_3000
public let LL_RCC_USBREF_CLKSOURCE: UInt32 = 0x0000_0F00
public let LL_RCC_XSPI1_CLKSOURCE: UInt32 = 0x0300_0400
public let LL_RCC_XSPI2_CLKSOURCE: UInt32 = 0x0300_0600
public let LL_RCC_RTC_CLKSOURCE_NONE: UInt32 = 0x0000_0000
public let LL_RCC_RTC_CLKSOURCE_LSE: UInt32 = 0x0000_0100
public let LL_RCC_RTC_CLKSOURCE_LSI: UInt32 = 0x0000_0200
public let LL_RCC_RTC_CLKSOURCE_HSE: UInt32 = 0x0000_0300
public let LL_RCC_TIM_PRESCALER_TWICE: UInt32 = 0x0000_0000
public let LL_RCC_TIM_PRESCALER_FOUR_TIMES: UInt32 = 0x0000_8000
public let LL_RCC_TIM_PRESCALER_DISABLE: UInt32 = 0x0000_0000
public let LL_RCC_TIM_PRESCALER_ENABLE: UInt32 = 0x0000_8000
public let LL_RCC_PLLSOURCE_HSI: UInt32 = 0x0000_0000
public let LL_RCC_PLLSOURCE_CSI: UInt32 = 0x0000_0001
public let LL_RCC_PLLSOURCE_HSE: UInt32 = 0x0000_0002
public let LL_RCC_PLLSOURCE_NONE: UInt32 = 0x0000_0003
public let LL_RCC_PLLINPUTRANGE_1_2: UInt32 = 0x0000_0000
public let LL_RCC_PLLINPUTRANGE_2_4: UInt32 = 0x0000_0008
public let LL_RCC_PLLINPUTRANGE_4_8: UInt32 = 0x0000_0010
public let LL_RCC_PLLINPUTRANGE_8_16: UInt32 = 0x0000_0018
public let LL_RCC_PLLVCORANGE_WIDE: UInt32 = 0x0000_0000
public let LL_RCC_PLLVCORANGE_MEDIUM: UInt32 = 0x0000_0002
public let LL_RCC_PLL_SPREAD_CENTER: UInt32 = 0x0000_0000
public let LL_RCC_PLL_SPREAD_DOWN: UInt32 = 0x0000_8000
public let LL_RCC_PLL_DITHERING_TPDFN_ENABLE: UInt32 = 0x0000_0000
public let LL_RCC_PLL_DITHERING_TPDFN_DISABLE: UInt32 = 0x0000_2000
public let LL_RCC_PLL_DITHERING_RPDFN_ENABLE: UInt32 = 0x0000_0000
public let LL_RCC_PLL_DITHERING_RPDFN_DISABLE: UInt32 = 0x0000_4000
public let LL_RCC_PERIPH_FREQUENCY_NO: UInt32 = 0x0000_0000
public let LL_RCC_PERIPH_FREQUENCY_NA: UInt32 = 0xFFFF_FFFF

public func LL_RCC_HSE_EnableCSS<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x100000))
}

public func LL_RCC_HSE_EnableBypass<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x40000))
}

public func LL_RCC_HSE_DisableBypass<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x40000))
}

public func LL_RCC_HSE_SelectAnalogClock<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x80000))
}

public func LL_RCC_HSE_SelectDigitalClock<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x80000))
}

public func LL_RCC_HSE_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x10000))
}

public func LL_RCC_HSE_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x10000))
}

public func LL_RCC_HSE_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x20000)) == 0x20000) ? 1 : 0)
}

public func LL_RCC_HSI_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x1))
}

public func LL_RCC_HSI_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x1))
}

public func LL_RCC_HSI_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x4)) == 0x4) ? 1 : 0)
}

public func LL_RCC_HSI_IsDividerReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x20)) == 0x20) ? 1 : 0)
}

public func LL_RCC_HSI_SetDivider<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Divider: UInt32) {
    registers.write(RCCClockRegister.cr, value: (registers.read(RCCClockRegister.cr) & ~(0x18)) | (Divider))
}

public func LL_RCC_HSI_GetDivider<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.cr) & (0x18)))
}

public func LL_RCC_HSI_EnableStopMode<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x2))
}

public func LL_RCC_HSI_DisableStopMode<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x2))
}

public func LL_RCC_HSI_IsEnabledStopMode<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_RCC_EnableXSPIClockProtection<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCExtendedRegister.ckprotr, value: registers.read(RCCExtendedRegister.ckprotr) | (0x1))
}

public func LL_RCC_DisableXSPIClockProtection<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCExtendedRegister.ckprotr, value: registers.read(RCCExtendedRegister.ckprotr) & ~(0x1))
}

public func LL_RCC_IsEnabledXSPIClockProtection<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCExtendedRegister.ckprotr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_RCC_EnableFMCClockProtection<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCExtendedRegister.ckprotr, value: registers.read(RCCExtendedRegister.ckprotr) | (0x2))
}

public func LL_RCC_DisableFMCClockProtection<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCExtendedRegister.ckprotr, value: registers.read(RCCExtendedRegister.ckprotr) & ~(0x2))
}

public func LL_RCC_IsEnabledFMCClockProtection<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCExtendedRegister.ckprotr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_RCC_GetXSPI2SwitchPosition<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCExtendedRegister.ckprotr) & (0x700)))
}

public func LL_RCC_GetXSPI1SwitchPosition<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCExtendedRegister.ckprotr) & (0x70)))
}

public func LL_RCC_GetFMCSwitchPosition<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCExtendedRegister.ckprotr) & (0x7000)))
}

public func LL_RCC_HSI_GetCalibration<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCControlRegister.hsicfgr) & (0xFFF)) >> 0x0)
}

public func LL_RCC_HSI_SetCalibTrimming<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Value: UInt32) {
    registers.write(
        RCCControlRegister.hsicfgr,
        value: (registers.read(RCCControlRegister.hsicfgr) & ~(0x7F00_0000)) | (Value << 0x18))
}

public func LL_RCC_HSI_GetCalibTrimming<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCControlRegister.hsicfgr) & (0x7F00_0000)) >> 0x18)
}

public func LL_RCC_CSI_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x80))
}

public func LL_RCC_CSI_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x80))
}

public func LL_RCC_CSI_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x100)) == 0x100) ? 1 : 0)
}

public func LL_RCC_CSI_EnableStopMode<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x200))
}

public func LL_RCC_CSI_DisableStopMode<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x200))
}

public func LL_RCC_CSI_IsEnabledStopMode<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_RCC_CSI_GetCalibration<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.csicfgr) & (0xFF)) >> 0x0)
}

public func LL_RCC_CSI_SetCalibTrimming<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Value: UInt32) {
    registers.write(
        LLRCCRegister.csicfgr, value: (registers.read(LLRCCRegister.csicfgr) & ~(0x3F00_0000)) | (Value << 0x18))
}

public func LL_RCC_CSI_GetCalibTrimming<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.csicfgr) & (0x3F00_0000)) >> 0x18)
}

public func LL_RCC_HSI48_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x1000))
}

public func LL_RCC_HSI48_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x1000))
}

public func LL_RCC_HSI48_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x2000)) == 0x2000) ? 1 : 0)
}

public func LL_RCC_HSI48_GetCalibration<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.crrcr) & (0x3FF)) >> 0x0)
}

public func LL_RCC_LSE_EnableCSS<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) | (0x20))
}

public func LL_RCC_LSE_DisableCSS<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) & ~(0x20))
}

public func LL_RCC_LSE_IsFailureDetected<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.bdcr) & (0x40)) == 0x40) ? 1 : 0)
}

public func LL_RCC_LSE_ReArmCSS<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) | (0x1000))
}

public func LL_RCC_LSE_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) | (0x1))
}

public func LL_RCC_LSE_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) & ~(0x1))
}

public func LL_RCC_LSE_EnableBypass<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) | (0x4))
}

public func LL_RCC_LSE_DisableBypass<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) & ~(0x4))
}

public func LL_RCC_LSE_SelectDigitalClock<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) | (0x80))
}

public func LL_RCC_LSE_SelectAnalogClock<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) & ~(0x80))
}

public func LL_RCC_LSE_SetDriveCapability<IO: LLRCCRegisterIO>(_ registers: inout IO, _ LSEDrive: UInt32) {
    registers.write(RCCControlRegister.bdcr, value: (registers.read(RCCControlRegister.bdcr) & ~(0x18)) | (LSEDrive))
}

public func LL_RCC_LSE_GetDriveCapability<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCControlRegister.bdcr) & (0x18)))
}

public func LL_RCC_LSE_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.bdcr) & (0x2)) == 0x2) ? 1 : 0)
}

public func LL_RCC_LSI_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.csr, value: registers.read(RCCControlRegister.csr) | (0x1))
}

public func LL_RCC_LSI_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.csr, value: registers.read(RCCControlRegister.csr) & ~(0x1))
}

public func LL_RCC_LSI_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.csr) & (0x2)) == 0x2) ? 1 : 0)
}

public func LL_RCC_SetSysClkSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Source: UInt32) {
    registers.write(RCCClockRegister.cfgr, value: (registers.read(RCCClockRegister.cfgr) & ~(0x7)) | (Source))
}

public func LL_RCC_GetSysClkSource<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.cfgr) & (0x38)))
}

public func LL_RCC_SetSysWakeUpClkSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Source: UInt32) {
    registers.write(RCCClockRegister.cfgr, value: (registers.read(RCCClockRegister.cfgr) & ~(0x40)) | (Source))
}

public func LL_RCC_GetSysWakeUpClkSource<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.cfgr) & (0x40)))
}

public func LL_RCC_SetKerWakeUpClkSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Source: UInt32) {
    registers.write(RCCClockRegister.cfgr, value: (registers.read(RCCClockRegister.cfgr) & ~(0x80)) | (Source))
}

public func LL_RCC_GetKerWakeUpClkSource<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.cfgr) & (0x80)))
}

public func LL_RCC_SetSysPrescaler<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(RCCClockRegister.cdcfgr, value: (registers.read(RCCClockRegister.cdcfgr) & ~(0xF)) | (Prescaler))
}

public func LL_RCC_SetAHBPrescaler<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(RCCClockRegister.bmcfgr, value: (registers.read(RCCClockRegister.bmcfgr) & ~(0xF)) | (Prescaler))
}

public func LL_RCC_SetAPB1Prescaler<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(RCCClockRegister.apbcfgr, value: (registers.read(RCCClockRegister.apbcfgr) & ~(0x7)) | (Prescaler))
}

public func LL_RCC_SetAPB2Prescaler<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(RCCClockRegister.apbcfgr, value: (registers.read(RCCClockRegister.apbcfgr) & ~(0x70)) | (Prescaler))
}

public func LL_RCC_SetAPB4Prescaler<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(
        RCCClockRegister.apbcfgr, value: (registers.read(RCCClockRegister.apbcfgr) & ~(0x700)) | (Prescaler))
}

public func LL_RCC_SetAPB5Prescaler<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(
        RCCClockRegister.apbcfgr, value: (registers.read(RCCClockRegister.apbcfgr) & ~(0x7000)) | (Prescaler))
}

public func LL_RCC_GetSysPrescaler<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.cdcfgr) & (0xF)))
}

public func LL_RCC_GetAHBPrescaler<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.bmcfgr) & (0xF)))
}

public func LL_RCC_GetAPB1Prescaler<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.apbcfgr) & (0x7)))
}

public func LL_RCC_GetAPB2Prescaler<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.apbcfgr) & (0x70)))
}

public func LL_RCC_GetAPB4Prescaler<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.apbcfgr) & (0x700)))
}

public func LL_RCC_GetAPB5Prescaler<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.apbcfgr) & (0x7000)))
}

public func LL_RCC_ConfigMCO<IO: LLRCCRegisterIO>(_ registers: inout IO, _ MCOxSource: UInt32, _ MCOxPrescaler: UInt32)
{
    registers.write(
        RCCClockRegister.cfgr,
        value: (registers.read(RCCClockRegister.cfgr) & ~((MCOxSource << 16) | (MCOxPrescaler << 16)))
            | ((MCOxSource & 0xFFFF_0000) | (MCOxPrescaler & 0xFFFF_0000)))
}

public func LL_RCC_SetClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    let selectedRegister = llRCCClockSelectionRegister(LL_CLKSOURCE_REG(ClkSource))
    registers.write(
        selectedRegister,
        value: (registers.read(selectedRegister) & ~(LL_CLKSOURCE_MASK(ClkSource))) | (LL_CLKSOURCE_CONFIG(ClkSource)))
}

public func LL_RCC_SetADCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x3000000)) | (ClkSource))
}

public func LL_RCC_SetADFClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x700000)) | (ClkSource))
}

public func LL_RCC_SetCECClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr2, value: (registers.read(RCCExtendedRegister.ccipr2) & ~(0x3000_0000)) | (ClkSource))
}

public func LL_RCC_SetCLKPClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x3000_0000)) | (ClkSource))
}

public func LL_RCC_SetETHPHYClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x40000)) | (ClkSource))
}

public func LL_RCC_SetETHREFClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x30000)) | (ClkSource))
}

public func LL_RCC_SetFDCANClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr2, value: (registers.read(RCCExtendedRegister.ccipr2) & ~(0xC00000)) | (ClkSource))
}

public func LL_RCC_SetFMCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x3)) | (ClkSource))
}

public func LL_RCC_SetI2CClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    LL_RCC_SetClockSource(&registers, ClkSource)
}

public func LL_RCC_SetI3CClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr2, value: (registers.read(RCCExtendedRegister.ccipr2) & ~(0x3000)) | (ClkSource))
}

public func LL_RCC_SetLPTIMClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    LL_RCC_SetClockSource(&registers, ClkSource)
}

public func LL_RCC_SetLPUARTClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr4, value: (registers.read(RCCExtendedRegister.ccipr4) & ~(0x7)) | (ClkSource))
}

public func LL_RCC_SetOTGFSClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0xC000)) | (ClkSource))
}

public func LL_RCC_SetXSPIClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    LL_RCC_SetClockSource(&registers, ClkSource)
}

public func LL_RCC_SetPSSIClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x8000000)) | (ClkSource))
}

public func LL_RCC_SetSAIClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    LL_RCC_SetClockSource(&registers, ClkSource)
}

public func LL_RCC_SetSDMMCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x4)) | (ClkSource))
}

public func LL_RCC_SetSPDIFRXClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr2, value: (registers.read(RCCExtendedRegister.ccipr2) & ~(0x3000000)) | (ClkSource))
}

public func LL_RCC_SetSPIClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    LL_RCC_SetClockSource(&registers, ClkSource)
}

public func LL_RCC_SetUSARTClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    LL_RCC_SetClockSource(&registers, ClkSource)
}

public func LL_RCC_SetUSBPHYCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0x3000)) | (ClkSource))
}

public func LL_RCC_SetUSBREFClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ ClkSource: UInt32) {
    registers.write(
        RCCExtendedRegister.ccipr1, value: (registers.read(RCCExtendedRegister.ccipr1) & ~(0xF00)) | (ClkSource))
}

public func LL_RCC_GetClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    let selectedRegister = llRCCClockSelectionRegister(LL_CLKSOURCE_REG(Periph))
    return
        (Periph
        | ((((registers.read(selectedRegister) & (LL_CLKSOURCE_MASK(Periph)))) >> LL_CLKSOURCE_SHIFT(Periph))
            << LL_RCC_CONFIG_SHIFT))
}

public func LL_RCC_GetADCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x3000000)))
}

public func LL_RCC_GetADFClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x700000)))
}

public func LL_RCC_GetCECClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr2) & (0x3000_0000)))
}

public func LL_RCC_GetCLKPClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x3000_0000)))
}

public func LL_RCC_GetETHPHYClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x40000)))
}

public func LL_RCC_GetETHREFClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x30000)))
}

public func LL_RCC_GetFDCANClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr2) & (0xC00000)))
}

public func LL_RCC_GetFMCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x3)))
}

public func LL_RCC_GetI2CClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    return LL_RCC_GetClockSource(&registers, Periph)
}

public func LL_RCC_GetI3CClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr2) & (0x3000)))
}

public func LL_RCC_GetLPTIMClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    return LL_RCC_GetClockSource(&registers, Periph)
}

public func LL_RCC_GetLPUARTClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr4) & (0x7)))
}

public func LL_RCC_GetOTGFSClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0xC000)))
}

public func LL_RCC_GetXSPIClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    return LL_RCC_GetClockSource(&registers, Periph)
}

public func LL_RCC_GetPSSIClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x8000000)))
}

public func LL_RCC_GetSAIClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return LL_RCC_GetClockSource(&registers, Periph)
}

public func LL_RCC_GetSDMMCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x4)))
}

public func LL_RCC_GetSPDIFRXClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr2) & (0x3000000)))
}

public func LL_RCC_GetSPIClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    return LL_RCC_GetClockSource(&registers, Periph)
}

public func LL_RCC_GetUSARTClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return LL_RCC_GetClockSource(&registers, Periph)
}

public func LL_RCC_GetUSBPHYCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0x3000)))
}

public func LL_RCC_GetUSBREFClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Periph: UInt32) -> UInt32 {
    _ = Periph
    return ((registers.read(RCCExtendedRegister.ccipr1) & (0xF00)))
}

public func LL_RCC_SetRTCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Source: UInt32) {
    registers.write(RCCControlRegister.bdcr, value: (registers.read(RCCControlRegister.bdcr) & ~(0x300)) | (Source))
}

public func LL_RCC_GetRTCClockSource<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCControlRegister.bdcr) & (0x300)))
}

public func LL_RCC_EnableRTC<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) | (0x8000))
}

public func LL_RCC_DisableRTC<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) & ~(0x8000))
}

public func LL_RCC_IsEnabledRTC<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.bdcr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_RCC_ForceBackupDomainReset<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) | (0x10000))
}

public func LL_RCC_ReleaseBackupDomainReset<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.bdcr, value: registers.read(RCCControlRegister.bdcr) & ~(0x10000))
}

public func LL_RCC_SetRTC_HSEPrescaler<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(RCCClockRegister.cfgr, value: (registers.read(RCCClockRegister.cfgr) & ~(0x3F00)) | (Prescaler))
}

public func LL_RCC_GetRTC_HSEPrescaler<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.cfgr) & (0x3F00)))
}

public func LL_RCC_SetTIMPrescaler<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Prescaler: UInt32) {
    registers.write(RCCClockRegister.cfgr, value: (registers.read(RCCClockRegister.cfgr) & ~(0x8000)) | (Prescaler))
}

public func LL_RCC_GetTIMPrescaler<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.cfgr) & (0x8000)))
}

public func LL_RCC_USBPHYC_EnablePowerDown<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(LLBusRegister.ahb1lpenr, value: registers.read(LLBusRegister.ahb1lpenr) | (0x1000000))
}

public func LL_RCC_USBPHYC_DisablePowerDown<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(LLBusRegister.ahb1lpenr, value: registers.read(LLBusRegister.ahb1lpenr) & ~(0x1000000))
}

public func LL_RCC_USBPHYC_IsEnabledPowerDown<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLBusRegister.ahb1lpenr) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_RCC_PLL_SetSource<IO: LLRCCRegisterIO>(_ registers: inout IO, _ PLLSource: UInt32) {
    registers.write(
        RCCClockRegister.pllckselr, value: (registers.read(RCCClockRegister.pllckselr) & ~(0x3)) | (PLLSource))
}

public func LL_RCC_PLL_GetSource<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllckselr) & (0x3)))
}

public func LL_RCC_PLL1_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x1000000))
}

public func LL_RCC_PLL1_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x1000000))
}

public func LL_RCC_PLL1_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x2000000)) == (0x2000000)) ? 1 : 0)
}

public func LL_RCC_PLL1_ConfigDomain_SYS<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ Source: UInt32, _ M: UInt32, _ N: UInt32, _ P: UInt32
) {
    registers.write(
        RCCClockRegister.pllckselr,
        value: (registers.read(RCCClockRegister.pllckselr) & ~(0x3F0 | 0x3)) | ((M << 0x4) | Source))
    registers.write(
        RCCClockRegister.pll1divr1,
        value: (registers.read(RCCClockRegister.pll1divr1) & ~(0xFE00 | 0x1FF))
            | (((P &- 1) << 0x9) | ((N &- 1) << 0x0)))
}

public func LL_RCC_PLL1P_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x20))
}

public func LL_RCC_PLL1Q_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x40))
}

public func LL_RCC_PLL1R_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x80))
}

public func LL_RCC_PLL1S_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x100))
}

public func LL_RCC_PLL1FRACN_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x1))
}

public func LL_RCC_PLL1P_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x20)) == 0x20) ? 1 : 0)
}

public func LL_RCC_PLL1Q_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x40)) == 0x40) ? 1 : 0)
}

public func LL_RCC_PLL1R_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x80)) == 0x80) ? 1 : 0)
}

public func LL_RCC_PLL1S_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x100)) == 0x100) ? 1 : 0)
}

public func LL_RCC_PLL1FRACN_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x1)) == 0x1) ? 1 : 0)
}

public func LL_RCC_PLL1P_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x20))
}

public func LL_RCC_PLL1Q_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x40))
}

public func LL_RCC_PLL1R_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x80))
}

public func LL_RCC_PLL1S_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x100))
}

public func LL_RCC_PLL1FRACN_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x1))
}

public func LL_RCC_PLL1_GetVCOInputRange<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllcfgr) & (0x18)))
}

public func LL_RCC_PLL1_GetVCOOutputRange<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllcfgr) & (0x2)))
}

public func LL_RCC_PLL1_SetVCOInputRange<IO: LLRCCRegisterIO>(_ registers: inout IO, _ InputRange: UInt32) {
    registers.write(
        RCCClockRegister.pllcfgr, value: (registers.read(RCCClockRegister.pllcfgr) & ~(0x18)) | (InputRange))
}

public func LL_RCC_PLL1_SetVCOOutputRange<IO: LLRCCRegisterIO>(_ registers: inout IO, _ VCORange: UInt32) {
    registers.write(RCCClockRegister.pllcfgr, value: (registers.read(RCCClockRegister.pllcfgr) & ~(0x2)) | (VCORange))
}

public func LL_RCC_PLL1_GetN<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll1divr1) & (0x1FF)) >> 0x0) &+ 1)
}

public func LL_RCC_PLL1_GetM<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllckselr) & (0x3F0)) >> 0x4)
}

public func LL_RCC_PLL1_GetP<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll1divr1) & (0xFE00)) >> 0x9) &+ 1)
}

public func LL_RCC_PLL1_GetQ<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll1divr1) & (0x7F0000)) >> 0x10) &+ 1)
}

public func LL_RCC_PLL1_GetR<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll1divr1) & (0x7F00_0000)) >> 0x18) &+ 1)
}

public func LL_RCC_PLL1_GetS<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll1divr2) & (0x7)) >> 0x0) &+ 1)
}

public func LL_RCC_PLL1_GetFRACN<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pll1fracr) & (0xFFF8)) >> 0x3)
}

public func LL_RCC_PLL1_SetN<IO: LLRCCRegisterIO>(_ registers: inout IO, _ N: UInt32) {
    registers.write(
        RCCClockRegister.pll1divr1, value: (registers.read(RCCClockRegister.pll1divr1) & ~(0x1FF)) | ((N &- 1) << 0x0))
}

public func LL_RCC_PLL1_SetM<IO: LLRCCRegisterIO>(_ registers: inout IO, _ M: UInt32) {
    registers.write(
        RCCClockRegister.pllckselr, value: (registers.read(RCCClockRegister.pllckselr) & ~(0x3F0)) | (M << 0x4))
}

public func LL_RCC_PLL1_SetP<IO: LLRCCRegisterIO>(_ registers: inout IO, _ P: UInt32) {
    registers.write(
        RCCClockRegister.pll1divr1, value: (registers.read(RCCClockRegister.pll1divr1) & ~(0xFE00)) | ((P &- 1) << 0x9))
}

public func LL_RCC_PLL1_SetQ<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Q: UInt32) {
    registers.write(
        RCCClockRegister.pll1divr1,
        value: (registers.read(RCCClockRegister.pll1divr1) & ~(0x7F0000)) | ((Q &- 1) << 0x10))
}

public func LL_RCC_PLL1_SetR<IO: LLRCCRegisterIO>(_ registers: inout IO, _ R: UInt32) {
    registers.write(
        RCCClockRegister.pll1divr1,
        value: (registers.read(RCCClockRegister.pll1divr1) & ~(0x7F00_0000)) | ((R &- 1) << 0x18))
}

public func LL_RCC_PLL1_SetS<IO: LLRCCRegisterIO>(_ registers: inout IO, _ S: UInt32) {
    registers.write(
        RCCClockRegister.pll1divr2, value: (registers.read(RCCClockRegister.pll1divr2) & ~(0x7)) | ((S &- 1) << 0x0))
}

public func LL_RCC_PLL1_SetFRACN<IO: LLRCCRegisterIO>(_ registers: inout IO, _ FRACN: UInt32) {
    registers.write(
        RCCClockRegister.pll1fracr, value: (registers.read(RCCClockRegister.pll1fracr) & ~(0xFFF8)) | (FRACN << 0x3))
}

public func LL_RCC_PLL1_EnableSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x4))
}

public func LL_RCC_PLL1_DisableSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x4))
}

public func LL_RCC_PLL1_IsEnabledSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x4)) == 0x4) ? 1 : 0)
}

public func LL_RCC_PLL1_GetModulationPeriod<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll1sscgr) & (0x1FFF)))
}

public func LL_RCC_PLL1_GetIncrementStep<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll1sscgr) & (0x7FFF_0000)) >> 0x10)
}

public func LL_RCC_PLL1_GetSpreadSelection<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll1sscgr) & (0x8000)))
}

public func LL_RCC_PLL1_IsEnabledRPDFNDithering<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLRCCRegister.pll1sscgr) & (0x4000)) == 0) ? 1 : 0)
}

public func LL_RCC_PLL1_IsEnabledTPDFNDithering<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLRCCRegister.pll1sscgr) & (0x2000)) == 0) ? 1 : 0)
}

public func LL_RCC_PLL2_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x4000000))
}

public func LL_RCC_PLL2_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x4000000))
}

public func LL_RCC_PLL2_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x8000000)) == 0x8000000) ? 1 : 0)
}

public func LL_RCC_PLL2P_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x10000))
}

public func LL_RCC_PLL2Q_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x20000))
}

public func LL_RCC_PLL2R_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x40000))
}

public func LL_RCC_PLL2S_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x80000))
}

public func LL_RCC_PLL2T_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x100000))
}

public func LL_RCC_PLL2FRACN_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x800))
}

public func LL_RCC_PLL2P_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x10000)) == 0x10000) ? 1 : 0)
}

public func LL_RCC_PLL2Q_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x20000)) == 0x20000) ? 1 : 0)
}

public func LL_RCC_PLL2R_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x40000)) == 0x40000) ? 1 : 0)
}

public func LL_RCC_PLL2S_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x80000)) == 0x80000) ? 1 : 0)
}

public func LL_RCC_PLL2T_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x100000)) == 0x100000) ? 1 : 0)
}

public func LL_RCC_PLL2FRACN_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x800)) == 0x800) ? 1 : 0)
}

public func LL_RCC_PLL2P_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x10000))
}

public func LL_RCC_PLL2Q_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x20000))
}

public func LL_RCC_PLL2R_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x40000))
}

public func LL_RCC_PLL2S_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x80000))
}

public func LL_RCC_PLL2T_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x100000))
}

public func LL_RCC_PLL2FRACN_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x800))
}

public func LL_RCC_PLL2_GetVCOInputRange<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllcfgr) & (0xC000)) >> 11)
}

public func LL_RCC_PLL2_GetVCOOutputRange<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllcfgr) & (0x1000)) >> 11)
}

public func LL_RCC_PLL2_SetVCOInputRange<IO: LLRCCRegisterIO>(_ registers: inout IO, _ InputRange: UInt32) {
    registers.write(
        RCCClockRegister.pllcfgr, value: (registers.read(RCCClockRegister.pllcfgr) & ~(0xC000)) | ((InputRange << 11)))
}

public func LL_RCC_PLL2_SetVCOOutputRange<IO: LLRCCRegisterIO>(_ registers: inout IO, _ VCORange: UInt32) {
    registers.write(
        RCCClockRegister.pllcfgr, value: (registers.read(RCCClockRegister.pllcfgr) & ~(0x1000)) | ((VCORange << 11)))
}

public func LL_RCC_PLL2_GetN<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll2divr1) & (0x1FF)) >> 0x0) &+ 1)
}

public func LL_RCC_PLL2_GetM<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllckselr) & (0x3F000)) >> 0xC)
}

public func LL_RCC_PLL2_GetP<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll2divr1) & (0xFE00)) >> 0x9) &+ 1)
}

public func LL_RCC_PLL2_GetQ<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll2divr1) & (0x7F0000)) >> 0x10) &+ 1)
}

public func LL_RCC_PLL2_GetR<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll2divr1) & (0x7F00_0000)) >> 0x18) &+ 1)
}

public func LL_RCC_PLL2_GetS<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll2divr2) & (0x7)) >> 0x0) &+ 1)
}

public func LL_RCC_PLL2_GetT<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll2divr2) & (0x700)) >> 0x8) &+ 1)
}

public func LL_RCC_PLL2_GetFRACN<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pll2fracr) & (0xFFF8)) >> 0x3)
}

public func LL_RCC_PLL2_SetN<IO: LLRCCRegisterIO>(_ registers: inout IO, _ N: UInt32) {
    registers.write(
        RCCClockRegister.pll2divr1, value: (registers.read(RCCClockRegister.pll2divr1) & ~(0x1FF)) | ((N &- 1) << 0x0))
}

public func LL_RCC_PLL2_SetM<IO: LLRCCRegisterIO>(_ registers: inout IO, _ M: UInt32) {
    registers.write(
        RCCClockRegister.pllckselr, value: (registers.read(RCCClockRegister.pllckselr) & ~(0x3F000)) | (M << 0xC))
}

public func LL_RCC_PLL2_SetP<IO: LLRCCRegisterIO>(_ registers: inout IO, _ P: UInt32) {
    registers.write(
        RCCClockRegister.pll2divr1, value: (registers.read(RCCClockRegister.pll2divr1) & ~(0xFE00)) | ((P &- 1) << 0x9))
}

public func LL_RCC_PLL2_SetQ<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Q: UInt32) {
    registers.write(
        RCCClockRegister.pll2divr1,
        value: (registers.read(RCCClockRegister.pll2divr1) & ~(0x7F0000)) | ((Q &- 1) << 0x10))
}

public func LL_RCC_PLL2_SetR<IO: LLRCCRegisterIO>(_ registers: inout IO, _ R: UInt32) {
    registers.write(
        RCCClockRegister.pll2divr1,
        value: (registers.read(RCCClockRegister.pll2divr1) & ~(0x7F00_0000)) | ((R &- 1) << 0x18))
}

public func LL_RCC_PLL2_SetS<IO: LLRCCRegisterIO>(_ registers: inout IO, _ S: UInt32) {
    registers.write(
        RCCClockRegister.pll2divr2, value: (registers.read(RCCClockRegister.pll2divr2) & ~(0x7)) | ((S &- 1) << 0x0))
}

public func LL_RCC_PLL2_SetT<IO: LLRCCRegisterIO>(_ registers: inout IO, _ T: UInt32) {
    registers.write(
        RCCClockRegister.pll2divr2, value: (registers.read(RCCClockRegister.pll2divr2) & ~(0x700)) | ((T &- 1) << 0x8))
}

public func LL_RCC_PLL2_SetFRACN<IO: LLRCCRegisterIO>(_ registers: inout IO, _ FRACN: UInt32) {
    registers.write(
        RCCClockRegister.pll2fracr, value: (registers.read(RCCClockRegister.pll2fracr) & ~(0xFFF8)) | (FRACN << 0x3))
}

public func LL_RCC_PLL2_EnableSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x2000))
}

public func LL_RCC_PLL2_DisableSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x2000))
}

public func LL_RCC_PLL2_IsEnabledSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x2000)) == 0x2000) ? 1 : 0)
}

public func LL_RCC_PLL2_GetModulationPeriod<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll2sscgr) & (0x1FFF)))
}

public func LL_RCC_PLL2_GetIncrementStep<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll2sscgr) & (0x7FFF_0000)) >> 0x10)
}

public func LL_RCC_PLL2_GetSpreadSelection<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll2sscgr) & (0x8000)))
}

public func LL_RCC_PLL2_IsEnabledRPDFNDithering<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLRCCRegister.pll2sscgr) & (0x4000)) == 0) ? 1 : 0)
}

public func LL_RCC_PLL2_IsEnabledTPDFNDithering<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLRCCRegister.pll2sscgr) & (0x2000)) == 0) ? 1 : 0)
}

public func LL_RCC_PLL3_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x1000_0000))
}

public func LL_RCC_PLL3_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x1000_0000))
}

public func LL_RCC_PLL3_IsReady<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.cr) & (0x2000_0000)) == 0x2000_0000) ? 1 : 0)
}

public func LL_RCC_PLL3P_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x8000000))
}

public func LL_RCC_PLL3Q_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x1000_0000))
}

public func LL_RCC_PLL3R_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x2000_0000))
}

public func LL_RCC_PLL3S_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x4000_0000))
}

public func LL_RCC_PLL3FRACN_Enable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x400000))
}

public func LL_RCC_PLL3P_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x8000000)) == 0x8000000) ? 1 : 0)
}

public func LL_RCC_PLL3Q_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x1000_0000)) == 0x1000_0000) ? 1 : 0)
}

public func LL_RCC_PLL3R_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x2000_0000)) == 0x2000_0000) ? 1 : 0)
}

public func LL_RCC_PLL3S_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x4000_0000)) == 0x4000_0000) ? 1 : 0)
}

public func LL_RCC_PLL3FRACN_IsEnabled<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x400000)) == 0x400000) ? 1 : 0)
}

public func LL_RCC_PLL3P_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x8000000))
}

public func LL_RCC_PLL3Q_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x1000_0000))
}

public func LL_RCC_PLL3R_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x2000_0000))
}

public func LL_RCC_PLL3S_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x4000_0000))
}

public func LL_RCC_PLL3FRACN_Disable<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x400000))
}

public func LL_RCC_PLL3_GetVCOInputRange<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllcfgr) & (0x6000000)) >> 22)
}

public func LL_RCC_PLL3_GetVCOOutputRange<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllcfgr) & (0x800000)) >> 22)
}

public func LL_RCC_PLL3_SetVCOInputRange<IO: LLRCCRegisterIO>(_ registers: inout IO, _ InputRange: UInt32) {
    registers.write(
        RCCClockRegister.pllcfgr,
        value: (registers.read(RCCClockRegister.pllcfgr) & ~(0x6000000)) | ((InputRange << 22)))
}

public func LL_RCC_PLL3_SetVCOOutputRange<IO: LLRCCRegisterIO>(_ registers: inout IO, _ VCORange: UInt32) {
    registers.write(
        RCCClockRegister.pllcfgr, value: (registers.read(RCCClockRegister.pllcfgr) & ~(0x800000)) | ((VCORange << 22)))
}

public func LL_RCC_PLL3_GetN<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll3divr1) & (0x1FF)) >> 0x0) &+ 1)
}

public func LL_RCC_PLL3_GetM<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pllckselr) & (0x3F00000)) >> 0x14)
}

public func LL_RCC_PLL3_GetP<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll3divr1) & (0xFE00)) >> 0x9) &+ 1)
}

public func LL_RCC_PLL3_GetQ<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll3divr1) & (0x7F0000)) >> 0x10) &+ 1)
}

public func LL_RCC_PLL3_GetR<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll3divr1) & (0x7F00_0000)) >> 0x18) &+ 1)
}

public func LL_RCC_PLL3_GetS<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pll3divr2) & (0x7)) >> 0x0) &+ 1)
}

public func LL_RCC_PLL3_GetFRACN<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(RCCClockRegister.pll3fracr) & (0xFFF8)) >> 0x3)
}

public func LL_RCC_PLL3_SetN<IO: LLRCCRegisterIO>(_ registers: inout IO, _ N: UInt32) {
    registers.write(
        RCCClockRegister.pll3divr1, value: (registers.read(RCCClockRegister.pll3divr1) & ~(0x1FF)) | ((N &- 1) << 0x0))
}

public func LL_RCC_PLL3_SetM<IO: LLRCCRegisterIO>(_ registers: inout IO, _ M: UInt32) {
    registers.write(
        RCCClockRegister.pllckselr, value: (registers.read(RCCClockRegister.pllckselr) & ~(0x3F00000)) | (M << 0x14))
}

public func LL_RCC_PLL3_SetP<IO: LLRCCRegisterIO>(_ registers: inout IO, _ P: UInt32) {
    registers.write(
        RCCClockRegister.pll3divr1, value: (registers.read(RCCClockRegister.pll3divr1) & ~(0xFE00)) | ((P &- 1) << 0x9))
}

public func LL_RCC_PLL3_SetQ<IO: LLRCCRegisterIO>(_ registers: inout IO, _ Q: UInt32) {
    registers.write(
        RCCClockRegister.pll3divr1,
        value: (registers.read(RCCClockRegister.pll3divr1) & ~(0x7F0000)) | ((Q &- 1) << 0x10))
}

public func LL_RCC_PLL3_SetR<IO: LLRCCRegisterIO>(_ registers: inout IO, _ R: UInt32) {
    registers.write(
        RCCClockRegister.pll3divr1,
        value: (registers.read(RCCClockRegister.pll3divr1) & ~(0x7F00_0000)) | ((R &- 1) << 0x18))
}

public func LL_RCC_PLL3_SetS<IO: LLRCCRegisterIO>(_ registers: inout IO, _ S: UInt32) {
    registers.write(
        RCCClockRegister.pll3divr2, value: (registers.read(RCCClockRegister.pll3divr2) & ~(0x7)) | ((S &- 1) << 0x0))
}

public func LL_RCC_PLL3_SetFRACN<IO: LLRCCRegisterIO>(_ registers: inout IO, _ FRACN: UInt32) {
    registers.write(
        RCCClockRegister.pll3fracr, value: (registers.read(RCCClockRegister.pll3fracr) & ~(0xFFF8)) | (FRACN << 0x3))
}

public func LL_RCC_PLL3_EnableSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) | (0x1000000))
}

public func LL_RCC_PLL3_DisableSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCClockRegister.pllcfgr, value: registers.read(RCCClockRegister.pllcfgr) & ~(0x1000000))
}

public func LL_RCC_PLL3_IsEnabledSpreadSpectrum<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCClockRegister.pllcfgr) & (0x1000000)) == 0x1000000) ? 1 : 0)
}

public func LL_RCC_PLL3_GetModulationPeriod<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll3sscgr) & (0x1FFF)))
}

public func LL_RCC_PLL3_GetIncrementStep<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll3sscgr) & (0x7FFF_0000)) >> 0x10)
}

public func LL_RCC_PLL3_GetSpreadSelection<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLRCCRegister.pll3sscgr) & (0x8000)))
}

public func LL_RCC_PLL3_IsEnabledRPDFNDithering<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLRCCRegister.pll3sscgr) & (0x4000)) == 0) ? 1 : 0)
}

public func LL_RCC_PLL3_IsEnabledTPDFNDithering<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLRCCRegister.pll3sscgr) & (0x2000)) == 0) ? 1 : 0)
}

public func LL_RCC_ClearFlag_LSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x1))
}

public func LL_RCC_ClearFlag_LSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x2))
}

public func LL_RCC_ClearFlag_HSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x4))
}

public func LL_RCC_ClearFlag_HSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x8))
}

public func LL_RCC_ClearFlag_CSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x10))
}

public func LL_RCC_ClearFlag_HSI48RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x20))
}

public func LL_RCC_ClearFlag_PLL1RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x40))
}

public func LL_RCC_ClearFlag_PLL2RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x80))
}

public func LL_RCC_ClearFlag_PLL3RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x100))
}

public func LL_RCC_ClearFlag_LSECSS<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x200))
}

public func LL_RCC_ClearFlag_HSECSS<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cicr, value: registers.read(RCCControlRegister.cicr) | (0x400))
}

public func LL_RCC_IsActiveFlag_LSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x1)) == 0x1) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_LSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x2)) == 0x2) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_HSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x4)) == 0x4) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_HSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x8)) == 0x8) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_CSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x10)) == 0x10) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_HSI48RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x20)) == 0x20) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_PLL1RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x40)) == 0x40) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_PLL2RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x80)) == 0x80) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_PLL3RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x100)) == 0x100) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_LSECSS<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x200)) == 0x200) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_HSECSS<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cifr) & (0x400)) == 0x400) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_LPWRRST<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.rsr) & (0x4000_0000)) == 0x4000_0000) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_WWDGRST<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.rsr) & (0x1000_0000)) == 0x1000_0000) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_IWDGRST<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.rsr) & (0x4000000)) == 0x4000000) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_SFTRST<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.rsr) & (0x1000000)) == 0x1000000) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_PORRST<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.rsr) & (0x800000)) == 0x800000) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_PINRST<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.rsr) & (0x400000)) == 0x400000) ? 1 : 0)
}

public func LL_RCC_IsActiveFlag_BORRST<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.rsr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_RCC_ClearResetFlags<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.rsr, value: registers.read(RCCControlRegister.rsr) | (0x10000))
}

public func LL_RCC_EnableIT_LSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x1))
}

public func LL_RCC_EnableIT_LSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x2))
}

public func LL_RCC_EnableIT_HSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x4))
}

public func LL_RCC_EnableIT_HSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x8))
}

public func LL_RCC_EnableIT_CSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x10))
}

public func LL_RCC_EnableIT_HSI48RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x20))
}

public func LL_RCC_EnableIT_PLL1RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x40))
}

public func LL_RCC_EnableIT_PLL2RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x80))
}

public func LL_RCC_EnableIT_PLL3RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x100))
}

public func LL_RCC_EnableIT_LSECSS<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) | (0x200))
}

public func LL_RCC_DisableIT_LSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x1))
}

public func LL_RCC_DisableIT_LSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x2))
}

public func LL_RCC_DisableIT_HSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x4))
}

public func LL_RCC_DisableIT_HSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x8))
}

public func LL_RCC_DisableIT_CSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x10))
}

public func LL_RCC_DisableIT_HSI48RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x20))
}

public func LL_RCC_DisableIT_PLL1RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x40))
}

public func LL_RCC_DisableIT_PLL2RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x80))
}

public func LL_RCC_DisableIT_PLL3RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x100))
}

public func LL_RCC_DisableIT_LSECSS<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    registers.write(RCCControlRegister.cier, value: registers.read(RCCControlRegister.cier) & ~(0x200))
}

public func LL_RCC_IsEnableIT_LSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x1)) == 0x1) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_LSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x2)) == 0x2) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_HSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x4)) == 0x4) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_HSERDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x8)) == 0x8) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_CSIRDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x10)) == 0x10) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_HSI48RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x20)) == 0x20) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_PLL1RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x40)) == 0x40) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_PLL2RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x80)) == 0x80) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_PLL3RDY<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x100)) == 0x100) ? 1 : 0)
}

public func LL_RCC_IsEnableIT_LSECSS<IO: LLRCCRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(RCCControlRegister.cier) & (0x200)) == 0x200) ? 1 : 0)
}

public func LL_RCC_CalcPLLClockFreq(_ PLLInputFreq: UInt32, _ M: UInt32, _ N: UInt32, _ FRACN: UInt32, _ PQR: UInt32)
    -> UInt32
{
    precondition(M != 0 && PQR != 0)
    var freq = (Float(PLLInputFreq) / Float(M)) * (Float(N) + (Float(FRACN) / Float(0x2000)))
    freq = freq / Float(PQR)
    return UInt32(freq)
}

private func llRCCClockSelectionRegister(_ offset: UInt32) -> RCCExtendedRegister {
    switch offset {
    case 0: return .ccipr1
    case 4: return .ccipr2
    case 8: return .ccipr3
    case 12: return .ccipr4
    default: preconditionFailure("Clock source must select a CCIPR register")
    }
}

public func LL_CLKSOURCE_SHIFT(_ source: UInt32) -> UInt32 { (source >> LL_RCC_POS_SHIFT) & 0x1F }
public func LL_CLKSOURCE_MASK(_ source: UInt32) -> UInt32 {
    ((source >> LL_RCC_MASK_SHIFT) & 0xFF) << LL_CLKSOURCE_SHIFT(source)
}
public func LL_CLKSOURCE_CONFIG(_ source: UInt32) -> UInt32 {
    ((source >> LL_RCC_CONFIG_SHIFT) & 0xFF) << LL_CLKSOURCE_SHIFT(source)
}
public func LL_CLKSOURCE_REG(_ source: UInt32) -> UInt32 { (source >> LL_RCC_REG_SHIFT) & 0xFF }
public func LL_CLKSOURCE(_ register: UInt32, _ mask: UInt32, _ position: UInt32, _ clock: UInt32) -> UInt32 {
    ((mask >> position) << LL_RCC_MASK_SHIFT) | (position << LL_RCC_POS_SHIFT) | (register << LL_RCC_REG_SHIFT)
        | ((clock >> position) << LL_RCC_CONFIG_SHIFT)
}

public func LL_RCC_CALC_SYSCLK_FREQ(_ frequency: UInt32, _ prescaler: UInt32) -> UInt32 {
    frequency >> (UInt32(LL_RCC_PrescTable[Int((prescaler & 0xf) >> 0x0)]) & 0x1F)
}

public func LL_RCC_CALC_HCLK_FREQ(_ frequency: UInt32, _ prescaler: UInt32) -> UInt32 {
    frequency >> (UInt32(LL_RCC_PrescTable[Int((prescaler & 0xf) >> 0x0)]) & 0x1F)
}

public func LL_RCC_CALC_PCLK1_FREQ(_ frequency: UInt32, _ prescaler: UInt32) -> UInt32 {
    frequency >> (UInt32(LL_RCC_PrescTable[Int((prescaler & 0x7) >> 0x0)]) & 0x1F)
}

public func LL_RCC_CALC_PCLK2_FREQ(_ frequency: UInt32, _ prescaler: UInt32) -> UInt32 {
    frequency >> (UInt32(LL_RCC_PrescTable[Int((prescaler & 0x70) >> 0x4)]) & 0x1F)
}

public func LL_RCC_CALC_PCLK4_FREQ(_ frequency: UInt32, _ prescaler: UInt32) -> UInt32 {
    frequency >> (UInt32(LL_RCC_PrescTable[Int((prescaler & 0x700) >> 0x8)]) & 0x1F)
}

public func LL_RCC_CALC_PCLK5_FREQ(_ frequency: UInt32, _ prescaler: UInt32) -> UInt32 {
    frequency >> (UInt32(LL_RCC_PrescTable[Int((prescaler & 0x7000) >> 0xc)]) & 0x1F)
}

public func LL_RCC_WriteReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: RCCClockRegister, _ value: UInt32) {
    registers.write(register, value: value)
}

public func LL_RCC_ReadReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: RCCClockRegister) -> UInt32 {
    registers.read(register)
}

public func LL_RCC_WriteReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: RCCControlRegister, _ value: UInt32)
{
    registers.write(register, value: value)
}

public func LL_RCC_ReadReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: RCCControlRegister) -> UInt32 {
    registers.read(register)
}

public func LL_RCC_WriteReg<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ register: RCCExtendedRegister, _ value: UInt32
) {
    registers.write(register, value: value)
}

public func LL_RCC_ReadReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: RCCExtendedRegister) -> UInt32 {
    registers.read(register)
}

public func LL_RCC_WriteReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: LLBusRegister, _ value: UInt32) {
    registers.write(register, value: value)
}

public func LL_RCC_ReadReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: LLBusRegister) -> UInt32 {
    registers.read(register)
}

public func LL_RCC_WriteReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: LLRCCRegister, _ value: UInt32) {
    registers.write(register, value: value)
}

public func LL_RCC_ReadReg<IO: LLRCCRegisterIO>(_ registers: inout IO, _ register: LLRCCRegister) -> UInt32 {
    registers.read(register)
}
