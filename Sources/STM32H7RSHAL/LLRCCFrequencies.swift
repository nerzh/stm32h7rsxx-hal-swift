// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public func LL_RCC_DeInit<IO: LLRCCRegisterIO>(_ registers: inout IO) {
    if 0x3 > ((registers.read(FlashTimingRegister.acr) & (0xf))) {
        registers.write(FlashTimingRegister.acr, value: (registers.read(FlashTimingRegister.acr) & ~(0xf)) | ((0x3)))
    }

    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) | (0x1))

    while LL_RCC_HSI_IsReady(&registers) == 0 {}

    registers.write(RCCClockRegister.cfgr, value: 0)

    registers.write(
        RCCClockRegister.cr,
        value: registers.read(RCCClockRegister.cr)
            & ~(0x10000 | 0x80000 | 0x2 | 0x18 | 0x80 | 0x200 | 0x1000 | 0x1000000 | 0x4000000 | 0x1000_0000))

    while LL_RCC_PLL1_IsReady(&registers) != 0 {}

    while LL_RCC_PLL2_IsReady(&registers) != 0 {}

    while LL_RCC_PLL3_IsReady(&registers) != 0 {}

    registers.write(RCCClockRegister.cdcfgr, value: 0)

    registers.write(RCCClockRegister.bmcfgr, value: 0)

    registers.write(RCCClockRegister.apbcfgr, value: 0)

    registers.write(RCCClockRegister.pllckselr, value: (32 << 0x4) | (32 << 0xc) | (32 << 0x14))

    registers.write(RCCClockRegister.pllcfgr, value: 0)

    registers.write(RCCClockRegister.pll1divr1, value: 0x0101_0280)
    registers.write(RCCClockRegister.pll1divr2, value: 0x0000_0101)

    registers.write(RCCClockRegister.pll1fracr, value: 0)

    registers.write(RCCClockRegister.pll2divr1, value: 0x0101_0280)
    registers.write(RCCClockRegister.pll2divr2, value: 0x0000_0101)

    registers.write(RCCClockRegister.pll2fracr, value: 0)

    // Preserve the pinned C reset sequence: PLL2 is written twice; PLL3 dividers stay unchanged.
    registers.write(RCCClockRegister.pll2divr1, value: 0x0101_0280)
    registers.write(RCCClockRegister.pll2divr2, value: 0x0000_0101)

    registers.write(RCCClockRegister.pll3fracr, value: 0)

    registers.write(RCCClockRegister.cr, value: registers.read(RCCClockRegister.cr) & ~(0x40000))

    registers.write(RCCControlRegister.cier, value: 0)

    registers.write(
        RCCControlRegister.cicr,
        value: registers.read(RCCControlRegister.cicr)
            | (0x1 | 0x2 | 0x4 | 0x8 | 0x10 | 0x20 | 0x40 | 0x80 | 0x100 | 0x200 | 0x400))

    registers.write(RCCControlRegister.rsr, value: registers.read(RCCControlRegister.rsr) | (0x10000))

    if 0x3 < ((registers.read(FlashTimingRegister.acr) & (0xf))) {
        registers.write(FlashTimingRegister.acr, value: (registers.read(FlashTimingRegister.acr) & ~(0xf)) | ((0x3)))
    }
}

public func LL_RCC_GetSystemClocksFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ RCC_Clocks: inout LL_RCC_ClocksTypeDef, oscillators: RCCOscillatorValues = .llDefaults
) {
    // The pinned C function leaves CPUCLK_Frequency untouched.
    RCC_Clocks.SYSCLK_Frequency = LL_RCC_CALC_SYSCLK_FREQ(
        RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))

    RCC_Clocks.HCLK_Frequency = RCC_GetHCLKClockFreq(&registers, RCC_Clocks.SYSCLK_Frequency)

    RCC_Clocks.PCLK1_Frequency = RCC_GetPCLK1ClockFreq(&registers, RCC_Clocks.HCLK_Frequency)

    RCC_Clocks.PCLK2_Frequency = RCC_GetPCLK2ClockFreq(&registers, RCC_Clocks.HCLK_Frequency)

    RCC_Clocks.PCLK4_Frequency = RCC_GetPCLK4ClockFreq(&registers, RCC_Clocks.HCLK_Frequency)

    RCC_Clocks.PCLK5_Frequency = RCC_GetPCLK5ClockFreq(&registers, RCC_Clocks.HCLK_Frequency)
}

public func LL_RCC_GetPLL1ClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ PLL_Clocks: inout LL_PLL_ClocksTypeDef, oscillators: RCCOscillatorValues = .llDefaults
) {
    var pllinputfreq: UInt32 = 0x0
    var pllsource: UInt32
    var m: UInt32
    var n: UInt32
    var fracn: UInt32 = 0

    pllsource = LL_RCC_PLL_GetSource(&registers)
    switch pllsource
    {
    case 0x0:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                pllinputfreq = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x1:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            pllinputfreq = oscillators.csi
        }
        break
    case 0x2:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            pllinputfreq = oscillators.hse
        }
        break
    case 0x3: fallthrough
    default:
        break
    }
    PLL_Clocks.PLL_P_Frequency = 0
    PLL_Clocks.PLL_Q_Frequency = 0
    PLL_Clocks.PLL_R_Frequency = 0
    PLL_Clocks.PLL_S_Frequency = 0
    PLL_Clocks.PLL_T_Frequency = 0
    m = LL_RCC_PLL1_GetM(&registers)
    n = LL_RCC_PLL1_GetN(&registers)
    if LL_RCC_PLL1FRACN_IsEnabled(&registers) != 0 {
        fracn = LL_RCC_PLL1_GetFRACN(&registers)
    }
    if m != 0 {
        if LL_RCC_PLL1P_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_P_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL1_GetP(&registers))
        }
        if LL_RCC_PLL1Q_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_Q_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL1_GetQ(&registers))
        }
        if LL_RCC_PLL1R_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_R_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL1_GetR(&registers))
        }
        if LL_RCC_PLL1S_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_S_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL1_GetS(&registers))
        }
    }
}

public func LL_RCC_GetPLL2ClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ PLL_Clocks: inout LL_PLL_ClocksTypeDef, oscillators: RCCOscillatorValues = .llDefaults
) {
    var pllinputfreq: UInt32 = 0x0
    var pllsource: UInt32
    var m: UInt32
    var n: UInt32
    var fracn: UInt32 = 0

    pllsource = LL_RCC_PLL_GetSource(&registers)
    switch pllsource
    {
    case 0x0:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                pllinputfreq = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x1:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            pllinputfreq = oscillators.csi
        }
        break
    case 0x2:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            pllinputfreq = oscillators.hse
        }
        break
    case 0x3: fallthrough
    default:
        break
    }
    PLL_Clocks.PLL_P_Frequency = 0
    PLL_Clocks.PLL_Q_Frequency = 0
    PLL_Clocks.PLL_R_Frequency = 0
    PLL_Clocks.PLL_S_Frequency = 0
    PLL_Clocks.PLL_T_Frequency = 0
    m = LL_RCC_PLL2_GetM(&registers)
    n = LL_RCC_PLL2_GetN(&registers)
    if LL_RCC_PLL2FRACN_IsEnabled(&registers) != 0 {
        fracn = LL_RCC_PLL2_GetFRACN(&registers)
    }
    if m != 0 {
        if LL_RCC_PLL2P_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_P_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL2_GetP(&registers))
        }
        if LL_RCC_PLL2Q_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_Q_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL2_GetQ(&registers))
        }
        if LL_RCC_PLL2R_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_R_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL2_GetR(&registers))
        }
        if LL_RCC_PLL2S_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_S_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL2_GetS(&registers))
        }
        if LL_RCC_PLL2T_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_T_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL2_GetT(&registers))
        }
    }
}

public func LL_RCC_GetPLL3ClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ PLL_Clocks: inout LL_PLL_ClocksTypeDef, oscillators: RCCOscillatorValues = .llDefaults
) {
    var pllinputfreq: UInt32 = 0x0
    var pllsource: UInt32
    var m: UInt32
    var n: UInt32
    var fracn: UInt32 = 0

    pllsource = LL_RCC_PLL_GetSource(&registers)
    switch pllsource
    {
    case 0x0:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                pllinputfreq = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x1:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            pllinputfreq = oscillators.csi
        }
        break
    case 0x2:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            pllinputfreq = oscillators.hse
        }
        break
    case 0x3: fallthrough
    default:
        break
    }
    PLL_Clocks.PLL_P_Frequency = 0
    PLL_Clocks.PLL_Q_Frequency = 0
    PLL_Clocks.PLL_R_Frequency = 0
    PLL_Clocks.PLL_S_Frequency = 0
    PLL_Clocks.PLL_T_Frequency = 0
    m = LL_RCC_PLL3_GetM(&registers)
    n = LL_RCC_PLL3_GetN(&registers)
    if LL_RCC_PLL3FRACN_IsEnabled(&registers) != 0 {
        fracn = LL_RCC_PLL3_GetFRACN(&registers)
    }
    if (m != 0) && (pllinputfreq != 0) {
        if LL_RCC_PLL3P_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_P_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL3_GetP(&registers))
        }
        if LL_RCC_PLL3Q_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_Q_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL3_GetQ(&registers))
        }
        if LL_RCC_PLL3R_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_R_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL3_GetR(&registers))
        }
        if LL_RCC_PLL3S_IsEnabled(&registers) != 0 {
            PLL_Clocks.PLL_S_Frequency = LL_RCC_CalcPLLClockFreq(
                pllinputfreq, m, n, fracn, LL_RCC_PLL3_GetS(&registers))
        }
    }
}

public func LL_RCC_PLL1_ConfigSpreadSpectrum<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ pConfig: LL_PLL_SpreadSpectrumTypeDef
) {
    registers.write(
        LLRCCRegister.pll1sscgr,
        value: (registers.read(LLRCCRegister.pll1sscgr) & ~((0x1fff | 0x7fff_0000 | 0x8000 | 0x2000 | 0x4000)))
            | ((UInt32(pConfig.ModulationPeriod) | (UInt32(pConfig.IncrementStep) << 0x10) | UInt32(pConfig.SpreadMode)
                | UInt32(pConfig.DitheringTPDFN) | UInt32(pConfig.DitheringRPDFN))))
}

public func LL_RCC_PLL2_ConfigSpreadSpectrum<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ pConfig: LL_PLL_SpreadSpectrumTypeDef
) {
    registers.write(
        LLRCCRegister.pll2sscgr,
        value: (registers.read(LLRCCRegister.pll2sscgr) & ~((0x1fff | 0x7fff_0000 | 0x8000 | 0x2000 | 0x4000)))
            | ((UInt32(pConfig.ModulationPeriod) | (UInt32(pConfig.IncrementStep) << 0x10) | UInt32(pConfig.SpreadMode)
                | UInt32(pConfig.DitheringTPDFN) | UInt32(pConfig.DitheringRPDFN))))
}

public func LL_RCC_PLL3_ConfigSpreadSpectrum<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ pConfig: LL_PLL_SpreadSpectrumTypeDef
) {
    registers.write(
        LLRCCRegister.pll3sscgr,
        value: (registers.read(LLRCCRegister.pll3sscgr) & ~((0x1fff | 0x7fff_0000 | 0x8000 | 0x2000 | 0x4000)))
            | ((UInt32(pConfig.ModulationPeriod) | (UInt32(pConfig.IncrementStep) << 0x10) | UInt32(pConfig.SpreadMode)
                | UInt32(pConfig.DitheringTPDFN) | UInt32(pConfig.DitheringRPDFN))))
}

public func LL_RCC_GetUSARTClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ USARTxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var usart_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetUSARTClockSource(&registers, USARTxSource)
    {
    case 0x7000008:
        usart_frequency = RCC_GetPCLK2ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x7000004:
        usart_frequency = RCC_GetPCLK1ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x7010008, 0x7010004:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            usart_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x7020008, 0x7020004:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            usart_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x7030008, 0x7030004:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                usart_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x7040008, 0x7040004:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            usart_frequency = oscillators.csi
        }
        break
    case 0x7050008, 0x7050004:
        if LL_RCC_LSE_IsReady(&registers) != 0 {
            usart_frequency = oscillators.lse
        }
        break
    default:
        break
    }
    return usart_frequency
}

public func LL_RCC_GetUARTClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ UARTxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var uart_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetUSARTClockSource(&registers, UARTxSource)
    {
    case 0x7000004:
        uart_frequency = RCC_GetPCLK1ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x7010004:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            uart_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x7020004:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            uart_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x7030004:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                uart_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x7040004:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            uart_frequency = oscillators.csi
        }
        break
    case 0x7050004:
        if LL_RCC_LSE_IsReady(&registers) != 0 {
            uart_frequency = oscillators.lse
        }
        break
    default:
        break
    }
    return uart_frequency
}

public func LL_RCC_GetLPUARTClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ LPUARTxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var lpuart_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetLPUARTClockSource(&registers, LPUARTxSource)
    {
    case 0x0:
        lpuart_frequency = RCC_GetPCLK4ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x1:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            lpuart_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x2:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            lpuart_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x3:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                lpuart_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x4:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            lpuart_frequency = oscillators.csi
        }
        break
    case 0x5:
        if LL_RCC_LSE_IsReady(&registers) != 0 {
            lpuart_frequency = oscillators.lse
        }
        break
    default:
        break
    }
    return lpuart_frequency
}

public func LL_RCC_GetI2CClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ I2CxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var i2c_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetI2CClockSource(&registers, I2CxSource)
    {
    case 0x3000c04, 0x3000804:
        i2c_frequency = RCC_GetPCLK1ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x3010c04, 0x3010804:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            i2c_frequency = PLL_Clocks.PLL_R_Frequency
        }
        break
    case 0x3020c04, 0x3020804:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                i2c_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x3030c04, 0x3030804:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            i2c_frequency = oscillators.csi
        }
        break
    default:
        break
    }
    return i2c_frequency
}

public func LL_RCC_GetI3CClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ I3CxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var i3c_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetI3CClockSource(&registers, I3CxSource)
    {
    case 0x0:
        i3c_frequency = RCC_GetPCLK1ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x1000:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            i3c_frequency = PLL_Clocks.PLL_R_Frequency
        }
        break
    case 0x2000:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                i3c_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x3000:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            i3c_frequency = oscillators.csi
        }
        break
    default:
        break
    }
    return i3c_frequency
}

public func LL_RCC_GetLPTIMClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ LPTIMxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var lptim_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetLPTIMClockSource(&registers, LPTIMxSource)
    {
    case 0x7001004:
        lptim_frequency = RCC_GetPCLK1ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x700080c, 0x7000c0c:
        lptim_frequency = RCC_GetPCLK4ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x7011004, 0x701080c, 0x7010c0c:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            lptim_frequency = PLL_Clocks.PLL_P_Frequency
        }
        break
    case 0x7021004, 0x702080c, 0x7020c0c:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            lptim_frequency = PLL_Clocks.PLL_R_Frequency
        }
        break
    case 0x7031004, 0x703080c, 0x7030c0c:
        if LL_RCC_LSE_IsReady(&registers) != 0 {
            lptim_frequency = oscillators.lse
        }
        break
    case 0x7041004, 0x704080c, 0x7040c0c:
        if LL_RCC_LSI_IsReady(&registers) != 0 {
            lptim_frequency = oscillators.lsi
        }
        break
    case 0x7051004, 0x705080c, 0x7050c0c:
        lptim_frequency = LL_RCC_GetCLKPClockFreq(&registers, 0x3000_0000, oscillators: oscillators)
        break
    default:
        break
    }
    return lptim_frequency
}

public func LL_RCC_GetSAIClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ SAIxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var sai_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetSAIClockSource(&registers, SAIxSource)
    {
    case 0x7001008, 0x7001408:
        if LL_RCC_PLL1_IsReady(&registers) != 0 {
            LL_RCC_GetPLL1ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            sai_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x7011008, 0x7011408:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            sai_frequency = PLL_Clocks.PLL_P_Frequency
        }
        break
    case 0x7021008, 0x7021408:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            sai_frequency = PLL_Clocks.PLL_P_Frequency
        }
        break
    case 0x7031008, 0x7031408:
        sai_frequency = oscillators.external
        break
    case 0x7041008, 0x7041408:
        sai_frequency = LL_RCC_GetCLKPClockFreq(&registers, 0x3000_0000, oscillators: oscillators)
        break
    default:
        break
    }
    return sai_frequency
}

public func LL_RCC_GetADCClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ ADCxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var adc_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetADCClockSource(&registers, ADCxSource)
    {
    case 0x0:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            adc_frequency = PLL_Clocks.PLL_P_Frequency
        }
        break
    case 0x1000000:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            adc_frequency = PLL_Clocks.PLL_R_Frequency
        }
        break
    case 0x2000000:
        adc_frequency = LL_RCC_GetCLKPClockFreq(&registers, 0x3000_0000, oscillators: oscillators)
        break
    default:
        break
    }
    return adc_frequency
}

public func LL_RCC_GetSDMMCClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ SDMMCxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var sdmmc_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetSDMMCClockSource(&registers, SDMMCxSource)
    {
    case 0x0:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            sdmmc_frequency = PLL_Clocks.PLL_S_Frequency
        }
        break
    case 0x4:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            sdmmc_frequency = PLL_Clocks.PLL_T_Frequency
        }
        break
    default:
        break
    }
    return sdmmc_frequency
}

public func LL_RCC_GetCECClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ CECxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var cec_frequency: UInt32 = 0x0

    switch LL_RCC_GetCECClockSource(&registers, CECxSource)
    {
    case 0x0:
        if LL_RCC_LSE_IsReady(&registers) != 0 {
            cec_frequency = oscillators.lse
        }
        break
    case 0x1000_0000:
        if LL_RCC_LSI_IsReady(&registers) != 0 {
            cec_frequency = oscillators.lsi
        }
        break
    case 0x2000_0000:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            cec_frequency = oscillators.csi / 122
        }
        break
    default:
        break
    }
    return cec_frequency
}

public func LL_RCC_GetPSSIClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ PSSIxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var pssi_frequency: UInt32 = 0x0
    var pll_clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetPSSIClockSource(&registers, PSSIxSource)
    {
    case 0x0:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &pll_clocks, oscillators: oscillators)
            pssi_frequency = pll_clocks.PLL_R_Frequency
        }
        break
    case 0x8000000:
        pssi_frequency = LL_RCC_GetCLKPClockFreq(&registers, 0x3000_0000, oscillators: oscillators)
        break
    default:
        break
    }
    return pssi_frequency
}

public func LL_RCC_GetUSBPHYCClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ USBPHYCxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var usb_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetUSBPHYCClockSource(&registers, USBPHYCxSource)
    {
    case 0x0:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            usb_frequency = oscillators.hse
        }
        break
    case 0x1000:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            usb_frequency = (oscillators.hse / 2)
        }
        break
    case 0x2000:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            usb_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x3000: fallthrough
    default:
        break
    }
    return usb_frequency
}

public func LL_RCC_GetADFClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ ADFxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var adf_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetADFClockSource(&registers, ADFxSource)
    {
    case 0x0:
        adf_frequency = RCC_GetHCLKClockFreq(
            &registers,
            LL_RCC_CALC_SYSCLK_FREQ(
                RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers)))
        break
    case 0x100000:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            adf_frequency = PLL_Clocks.PLL_P_Frequency
        }
        break
    case 0x200000:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            adf_frequency = PLL_Clocks.PLL_P_Frequency
        }
        break
    case 0x300000:
        adf_frequency = oscillators.external
        break
    case 0x400000:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            adf_frequency = oscillators.csi
        }
        break
    case 0x500000:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                adf_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    default:
        break
    }
    return adf_frequency
}

public func LL_RCC_GetSPDIFRXClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ SPDIFRXxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var spdif_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetSPDIFRXClockSource(&registers, SPDIFRXxSource)
    {
    case 0x0:
        if LL_RCC_PLL1_IsReady(&registers) != 0 {
            LL_RCC_GetPLL1ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            spdif_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x1000000:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            spdif_frequency = PLL_Clocks.PLL_R_Frequency
        }
        break
    case 0x2000000:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            spdif_frequency = PLL_Clocks.PLL_R_Frequency
        }
        break
    case 0x3000000:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                spdif_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    default:
        break
    }
    return spdif_frequency
}

public func LL_RCC_GetSPIClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ SPIxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var spi_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetSPIClockSource(&registers, SPIxSource)
    {
    case 0x7000808, 0x7000404:
        if LL_RCC_PLL1_IsReady(&registers) != 0 {
            LL_RCC_GetPLL1ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            spi_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x7010808, 0x7010404:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            spi_frequency = PLL_Clocks.PLL_P_Frequency
        }
        break
    case 0x7020808, 0x7020404:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            spi_frequency = PLL_Clocks.PLL_P_Frequency
        }
        break
    case 0x7030808, 0x7030404:
        spi_frequency = oscillators.external
        break
    case 0x7040808, 0x7040404:
        spi_frequency = LL_RCC_GetCLKPClockFreq(&registers, 0x3000_0000, oscillators: oscillators)
        break
    case 0x7000408:
        spi_frequency = RCC_GetPCLK2ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x700040c:
        spi_frequency = RCC_GetPCLK4ClockFreq(
            &registers,
            RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers))))
        break
    case 0x7010408, 0x701040c:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            spi_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x7020408, 0x702040c:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            spi_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x7030408, 0x703040c:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                spi_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x7040408, 0x704040c:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            spi_frequency = oscillators.csi
        }
        break
    case 0x7050408, 0x705040c:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            spi_frequency = oscillators.hse
        }
        break
    default:
        break
    }
    return spi_frequency
}

public func LL_RCC_GetETHPHYClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ ETHxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var eth_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetETHPHYClockSource(&registers, ETHxSource)
    {
    case 0x0:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            eth_frequency = oscillators.hse
        }
        break
    case 0x40000:
        if LL_RCC_PLL3_IsReady(&registers) != 0 {
            LL_RCC_GetPLL3ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            eth_frequency = PLL_Clocks.PLL_S_Frequency
        }
        break
    default:
        break
    }
    return eth_frequency
}

public func LL_RCC_GetFDCANClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ FDCANxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var fdcan_frequency: UInt32 = 0x0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetFDCANClockSource(&registers, FDCANxSource)
    {
    case 0x0:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            fdcan_frequency = oscillators.hse
        }
        break
    case 0x400000:
        if LL_RCC_PLL1_IsReady(&registers) != 0 {
            LL_RCC_GetPLL1ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            fdcan_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x800000:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            fdcan_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    default:
        break
    }
    return fdcan_frequency
}

public func LL_RCC_GetFMCClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ FMCxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var fmc_frequency: UInt32 = 0x0
    var clksource: UInt32
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    if LL_RCC_GetFMCSwitchPosition(&registers) == 0x5000 {
        clksource = 0x5000
    } else {
        clksource = LL_RCC_GetFMCClockSource(&registers, FMCxSource)
    }
    switch clksource
    {
    case 0x0:
        fmc_frequency = RCC_GetHCLKClockFreq(
            &registers,
            LL_RCC_CALC_SYSCLK_FREQ(
                RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers)))
        break
    case 0x1:
        if LL_RCC_PLL1_IsReady(&registers) != 0 {
            LL_RCC_GetPLL1ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            fmc_frequency = PLL_Clocks.PLL_Q_Frequency
        }
        break
    case 0x2:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            fmc_frequency = PLL_Clocks.PLL_R_Frequency
        }
        break
    case 0x3:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                fmc_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x5000:
        fmc_frequency =
            (RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers)))
                / 4)
        break
    default:
        break
    }
    return fmc_frequency
}

public func LL_RCC_GetXSPIClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ XSPIxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var xspi_frequency: UInt32 = 0x0
    var clksource: UInt32
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    clksource = LL_RCC_GetXSPIClockSource(&registers, XSPIxSource)

    switch XSPIxSource
    {
    case 0x3000400:
        if LL_RCC_GetXSPI1SwitchPosition(&registers) == 0x40 {
            clksource = 0x40
        }
        break
    case 0x3000600:
        if LL_RCC_GetXSPI2SwitchPosition(&registers) == 0x400 {
            clksource = 0x400
        }
        break
    default:
        break
    }
    switch clksource
    {
    case 0x3000400, 0x3000600:
        xspi_frequency = RCC_GetHCLKClockFreq(
            &registers,
            LL_RCC_CALC_SYSCLK_FREQ(
                RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers)))
        break
    case 0x3010400, 0x3010600:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            xspi_frequency = PLL_Clocks.PLL_S_Frequency
        }
        break
    case 0x3020400, 0x3020600:
        if LL_RCC_PLL2_IsReady(&registers) != 0 {
            LL_RCC_GetPLL2ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
            xspi_frequency = PLL_Clocks.PLL_T_Frequency
        }
        break
    case 0x40, 0x400:
        xspi_frequency =
            (RCC_GetHCLKClockFreq(
                &registers,
                LL_RCC_CALC_SYSCLK_FREQ(
                    RCC_GetSystemClockFreq(&registers, oscillators: oscillators), LL_RCC_GetSysPrescaler(&registers)))
                / 4)
        break
    default:
        break
    }
    return xspi_frequency
}

public func LL_RCC_GetCLKPClockFreq<IO: LLRCCRegisterIO>(
    _ registers: inout IO, _ CLKPxSource: UInt32, oscillators: RCCOscillatorValues = .llDefaults
) -> UInt32 {
    var clkp_frequency: UInt32 = 0x0

    switch LL_RCC_GetCLKPClockSource(&registers, CLKPxSource)
    {
    case 0x0:
        if LL_RCC_HSI_IsReady(&registers) != 0 {
            if LL_RCC_HSI_IsDividerReady(&registers) != 0 {
                clkp_frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
            }
        }
        break
    case 0x1000_0000:
        if LL_RCC_CSI_IsReady(&registers) != 0 {
            clkp_frequency = oscillators.csi
        }
        break
    case 0x2000_0000:
        if LL_RCC_HSE_IsReady(&registers) != 0 {
            clkp_frequency = oscillators.hse
        }
        break
    default:
        break
    }
    return clkp_frequency
}

private func RCC_GetSystemClockFreq<IO: LLRCCRegisterIO>(_ registers: inout IO, oscillators: RCCOscillatorValues)
    -> UInt32
{
    var frequency: UInt32 = 0
    var PLL_Clocks = LL_PLL_ClocksTypeDef()

    switch LL_RCC_GetSysClkSource(&registers)
    {
    case 0x0:
        frequency = oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3)
        break
    case 0x8:
        frequency = oscillators.csi
        break
    case 0x10:
        frequency = oscillators.hse
        break
    case 0x18:
        LL_RCC_GetPLL1ClockFreq(&registers, &PLL_Clocks, oscillators: oscillators)
        frequency = PLL_Clocks.PLL_P_Frequency
        break
    default:
        break
    }
    return frequency
}

private func RCC_GetHCLKClockFreq<IO: LLRCCRegisterIO>(_ registers: inout IO, _ SYSCLK_Frequency: UInt32) -> UInt32 {
    return LL_RCC_CALC_HCLK_FREQ(SYSCLK_Frequency, LL_RCC_GetAHBPrescaler(&registers))
}

private func RCC_GetPCLK1ClockFreq<IO: LLRCCRegisterIO>(_ registers: inout IO, _ HCLK_Frequency: UInt32) -> UInt32 {
    return LL_RCC_CALC_PCLK1_FREQ(HCLK_Frequency, LL_RCC_GetAPB1Prescaler(&registers))
}

private func RCC_GetPCLK2ClockFreq<IO: LLRCCRegisterIO>(_ registers: inout IO, _ HCLK_Frequency: UInt32) -> UInt32 {
    return LL_RCC_CALC_PCLK2_FREQ(HCLK_Frequency, LL_RCC_GetAPB2Prescaler(&registers))
}

private func RCC_GetPCLK4ClockFreq<IO: LLRCCRegisterIO>(_ registers: inout IO, _ HCLK_Frequency: UInt32) -> UInt32 {
    return LL_RCC_CALC_PCLK4_FREQ(HCLK_Frequency, LL_RCC_GetAPB4Prescaler(&registers))
}

private func RCC_GetPCLK5ClockFreq<IO: LLRCCRegisterIO>(_ registers: inout IO, _ HCLK_Frequency: UInt32) -> UInt32 {
    return LL_RCC_CALC_PCLK5_FREQ(HCLK_Frequency, LL_RCC_GetAPB5Prescaler(&registers))
}
