// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public struct LL_RCC_ClocksTypeDef: Equatable, Sendable {
    public var SYSCLK_Frequency: UInt32
    public var CPUCLK_Frequency: UInt32
    public var HCLK_Frequency: UInt32
    public var PCLK1_Frequency: UInt32
    public var PCLK2_Frequency: UInt32
    public var PCLK4_Frequency: UInt32
    public var PCLK5_Frequency: UInt32

    public init(
        SYSCLK_Frequency: UInt32 = 0, CPUCLK_Frequency: UInt32 = 0, HCLK_Frequency: UInt32 = 0,
        PCLK1_Frequency: UInt32 = 0, PCLK2_Frequency: UInt32 = 0, PCLK4_Frequency: UInt32 = 0,
        PCLK5_Frequency: UInt32 = 0
    ) {
        self.SYSCLK_Frequency = SYSCLK_Frequency
        self.CPUCLK_Frequency = CPUCLK_Frequency
        self.HCLK_Frequency = HCLK_Frequency
        self.PCLK1_Frequency = PCLK1_Frequency
        self.PCLK2_Frequency = PCLK2_Frequency
        self.PCLK4_Frequency = PCLK4_Frequency
        self.PCLK5_Frequency = PCLK5_Frequency
    }
}

public struct LL_PLL_ClocksTypeDef: Equatable, Sendable {
    public var PLL_P_Frequency: UInt32
    public var PLL_Q_Frequency: UInt32
    public var PLL_R_Frequency: UInt32
    public var PLL_S_Frequency: UInt32
    public var PLL_T_Frequency: UInt32

    public init(
        PLL_P_Frequency: UInt32 = 0, PLL_Q_Frequency: UInt32 = 0, PLL_R_Frequency: UInt32 = 0,
        PLL_S_Frequency: UInt32 = 0, PLL_T_Frequency: UInt32 = 0
    ) {
        self.PLL_P_Frequency = PLL_P_Frequency
        self.PLL_Q_Frequency = PLL_Q_Frequency
        self.PLL_R_Frequency = PLL_R_Frequency
        self.PLL_S_Frequency = PLL_S_Frequency
        self.PLL_T_Frequency = PLL_T_Frequency
    }
}

public struct LL_PLL_SpreadSpectrumTypeDef: Equatable, Sendable {
    public var ModulationPeriod: UInt16
    public var IncrementStep: UInt16
    public var SpreadMode: UInt16
    public var DitheringRPDFN: UInt16
    public var DitheringTPDFN: UInt16

    public init(
        ModulationPeriod: UInt16 = 0, IncrementStep: UInt16 = 0, SpreadMode: UInt16 = 0, DitheringRPDFN: UInt16 = 0,
        DitheringTPDFN: UInt16 = 0
    ) {
        self.ModulationPeriod = ModulationPeriod
        self.IncrementStep = IncrementStep
        self.SpreadMode = SpreadMode
        self.DitheringRPDFN = DitheringRPDFN
        self.DitheringTPDFN = DitheringTPDFN
    }
}

public struct LL_UTILS_PLLInitTypeDef: Equatable, Sendable {
    public var PLLM: UInt32
    public var PLLN: UInt32
    public var PLLP: UInt32
    public var FRACN: UInt32
    public var VCO_Input: UInt32
    public var VCO_Output: UInt32

    public init(
        PLLM: UInt32 = 0, PLLN: UInt32 = 0, PLLP: UInt32 = 0, FRACN: UInt32 = 0, VCO_Input: UInt32 = 0,
        VCO_Output: UInt32 = 0
    ) {
        self.PLLM = PLLM
        self.PLLN = PLLN
        self.PLLP = PLLP
        self.FRACN = FRACN
        self.VCO_Input = VCO_Input
        self.VCO_Output = VCO_Output
    }
}

public struct LL_UTILS_ClkInitTypeDef: Equatable, Sendable {
    public var SYSCLKDivider: UInt32
    public var AHBCLKDivider: UInt32
    public var APB1CLKDivider: UInt32
    public var APB2CLKDivider: UInt32
    public var APB4CLKDivider: UInt32
    public var APB5CLKDivider: UInt32

    public init(
        SYSCLKDivider: UInt32 = 0, AHBCLKDivider: UInt32 = 0, APB1CLKDivider: UInt32 = 0, APB2CLKDivider: UInt32 = 0,
        APB4CLKDivider: UInt32 = 0, APB5CLKDivider: UInt32 = 0
    ) {
        self.SYSCLKDivider = SYSCLKDivider
        self.AHBCLKDivider = AHBCLKDivider
        self.APB1CLKDivider = APB1CLKDivider
        self.APB2CLKDivider = APB2CLKDivider
        self.APB4CLKDivider = APB4CLKDivider
        self.APB5CLKDivider = APB5CLKDivider
    }
}
