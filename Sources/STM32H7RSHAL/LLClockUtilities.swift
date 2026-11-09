// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public enum LLIdentificationRegister: Hashable, Sendable { case package }
public protocol LLIdentificationRegisterIO: HALRegisterIO {
    mutating func read(_ register: LLIdentificationRegister) -> UInt32
}
public protocol LLClockUtilitiesRegisterIO: LLRCCRegisterIO, PowerExtendedRegisterIO {}

public let LL_MAX_DELAY: UInt32 = 0xFFFF_FFFF
public let LL_UTILS_HSEBYPASS_OFF: UInt32 = 0x0000_0000
public let LL_UTILS_HSEBYPASS_ON: UInt32 = 0x0000_0001
public let LL_UTILS_PACKAGETYPE_VFQFPN68_GP: UInt32 = 0x0000_0000
public let LL_UTILS_PACKAGETYPE_TFBGA100_SMPS_GP: UInt32 = 0x0000_0001
public let LL_UTILS_PACKAGETYPE_LQFP100_GP: UInt32 = 0x0000_0002
public let LL_UTILS_PACKAGETYPE_LQFP144_GP: UInt32 = 0x0000_0003
public let LL_UTILS_PACKAGETYPE_UFBGA144_SMPS_GP: UInt32 = 0x0000_0004
public let LL_UTILS_PACKAGETYPE_UFBGA144_SMPS_GFX: UInt32 = 0x0000_0005
public let LL_UTILS_PACKAGETYPE_UFBGA169_SMPS_GFX: UInt32 = 0x0000_0006
public let LL_UTILS_PACKAGETYPE_UFBGA169_SMPS_GP: UInt32 = 0x0000_0007
public let LL_UTILS_PACKAGETYPE_UFBGA176_25_SMPS_GP: UInt32 = 0x0000_0008
public let LL_UTILS_PACKAGETYPE_LQFP176_SMPS_GP: UInt32 = 0x0000_0009
public let LL_UTILS_PACKAGETYPE_LQFP176_SMPS_GFX: UInt32 = 0x0000_000A
public let LL_UTILS_PACKAGETYPE_UFBGA176_25_SMPS_GFX: UInt32 = 0x0000_000B
public let LL_UTILS_PACKAGETYPE_TFBGA225_OCTO: UInt32 = 0x0000_000C
public let LL_UTILS_PACKAGETYPE_TFBGA225_HEXA: UInt32 = 0x0000_000D
public let LL_UTILS_PACKAGETYPE_WLCSP_SMPS_GP: UInt32 = 0x0000_000E

public func LL_GetUID_Word0<IO: HALRegisterIO>(_ registers: inout IO) -> UInt32 {
    registers.read(HALRegister.uniqueIDWord(index: 0))
}

public func LL_GetUID_Word1<IO: HALRegisterIO>(_ registers: inout IO) -> UInt32 {
    registers.read(HALRegister.uniqueIDWord(index: 1))
}

public func LL_GetUID_Word2<IO: HALRegisterIO>(_ registers: inout IO) -> UInt32 {
    registers.read(HALRegister.uniqueIDWord(index: 2))
}

public func LL_GetPackageType<IO: LLIdentificationRegisterIO>(_ registers: inout IO) -> UInt32 {
    (registers.read(LLIdentificationRegister.package) & 0x000F_0000) >> 16
}

public func LL_InitTick<IO: CortexRegisterIO>(_ registers: inout IO, _ HCLKFrequency: UInt32, _ Ticks: UInt32) {
    if Ticks > 0 {
        registers.write(CortexRegister.sysTickReload, value: ((HCLKFrequency / Ticks) &- 1))
        registers.write(CortexRegister.sysTickCurrent, value: 0)
        registers.write(CortexRegister.sysTickControl, value: 0x4 | 0x1)
    }
}

public func LL_Init1msTick<IO: CortexRegisterIO>(_ registers: inout IO, _ CPU_Frequency: UInt32) {
    LL_InitTick(&registers, CPU_Frequency, 1000)
}

public func LL_mDelay<IO: CortexRegisterIO>(_ registers: inout IO, _ Delay: UInt32) {
    var count: UInt32 = Delay
    let tmp: UInt32 = registers.read(CortexRegister.sysTickControl)
    _ = tmp

    if count < 0xffff_ffff {
        count &+= 1
    }
    while count != 0 {
        if (registers.read(CortexRegister.sysTickControl) & 0x10000) != 0 {
            count &-= 1
        }
    }
}

public func LL_SetSystemCoreClock<System: RCCSystemIO>(_ CPU_Frequency: UInt32, system: System) {
    system.setSystemCoreClock(CPU_Frequency)
}

public func LL_PLL_ConfigSystemClock_HSI<IO: LLClockUtilitiesRegisterIO, System: RCCSystemIO>(
    _ registers: inout IO, _ UTILS_PLLInitStruct: inout LL_UTILS_PLLInitTypeDef,
    _ UTILS_ClkInitStruct: inout LL_UTILS_ClkInitTypeDef, oscillators: RCCOscillatorValues = .llDefaults, system: System
) -> LLErrorStatus {
    var status: LLErrorStatus
    var pllfreq: UInt32
    var hsi_clk: UInt32

    hsi_clk = (oscillators.hsi >> (LL_RCC_HSI_GetDivider(&registers) >> 0x3))

    if UTILS_IsPLLsNotBusy(&registers) == .success {
        pllfreq = UTILS_GetPLLOutputFrequency(hsi_clk, UTILS_PLLInitStruct)

        if LL_RCC_HSI_IsReady(&registers) != 1 {
            LL_RCC_HSI_Enable(&registers)
            while LL_RCC_HSI_IsReady(&registers) != 1 {
            }
        }

        LL_RCC_PLL1FRACN_Disable(&registers)
        LL_RCC_PLL_SetSource(&registers, 0x0)
        LL_RCC_PLL1_SetVCOInputRange(&registers, UTILS_PLLInitStruct.VCO_Input)
        LL_RCC_PLL1_SetVCOOutputRange(&registers, UTILS_PLLInitStruct.VCO_Output)
        LL_RCC_PLL1_SetM(&registers, UTILS_PLLInitStruct.PLLM)
        LL_RCC_PLL1_SetN(&registers, UTILS_PLLInitStruct.PLLN)
        LL_RCC_PLL1_SetP(&registers, UTILS_PLLInitStruct.PLLP)
        LL_RCC_PLL1_SetFRACN(&registers, UTILS_PLLInitStruct.FRACN)
        LL_RCC_PLL1FRACN_Enable(&registers)
        LL_RCC_PLL1_SetFRACN(&registers, UTILS_PLLInitStruct.FRACN)

        status = UTILS_EnablePLLAndSwitchSystem(&registers, pllfreq, &UTILS_ClkInitStruct, system: system)
    } else {
        status = .error
    }
    return status
}

public func LL_PLL_ConfigSystemClock_CSI<IO: LLClockUtilitiesRegisterIO, System: RCCSystemIO>(
    _ registers: inout IO, _ UTILS_PLLInitStruct: inout LL_UTILS_PLLInitTypeDef,
    _ UTILS_ClkInitStruct: inout LL_UTILS_ClkInitTypeDef, oscillators: RCCOscillatorValues = .llDefaults, system: System
) -> LLErrorStatus {
    var status: LLErrorStatus
    var pllfreq: UInt32

    if UTILS_IsPLLsNotBusy(&registers) == .success {
        pllfreq = UTILS_GetPLLOutputFrequency(oscillators.csi, UTILS_PLLInitStruct)

        if LL_RCC_CSI_IsReady(&registers) != 1 {
            LL_RCC_CSI_Enable(&registers)
            while LL_RCC_CSI_IsReady(&registers) != 1 {
            }
        }

        LL_RCC_PLL1FRACN_Disable(&registers)
        LL_RCC_PLL_SetSource(&registers, 0x1)
        LL_RCC_PLL1_SetVCOInputRange(&registers, UTILS_PLLInitStruct.VCO_Input)
        LL_RCC_PLL1_SetVCOOutputRange(&registers, UTILS_PLLInitStruct.VCO_Output)
        LL_RCC_PLL1_SetM(&registers, UTILS_PLLInitStruct.PLLM)
        LL_RCC_PLL1_SetN(&registers, UTILS_PLLInitStruct.PLLN)
        LL_RCC_PLL1_SetP(&registers, UTILS_PLLInitStruct.PLLP)
        LL_RCC_PLL1_SetFRACN(&registers, UTILS_PLLInitStruct.FRACN)
        LL_RCC_PLL1FRACN_Enable(&registers)
        LL_RCC_PLL1_SetFRACN(&registers, UTILS_PLLInitStruct.FRACN)

        status = UTILS_EnablePLLAndSwitchSystem(&registers, pllfreq, &UTILS_ClkInitStruct, system: system)
    } else {
        status = .error
    }
    return status
}

public func LL_PLL_ConfigSystemClock_HSE<IO: LLClockUtilitiesRegisterIO, System: RCCSystemIO>(
    _ registers: inout IO, _ HSEFrequency: UInt32, _ HSEBypass: UInt32,
    _ UTILS_PLLInitStruct: inout LL_UTILS_PLLInitTypeDef, _ UTILS_ClkInitStruct: inout LL_UTILS_ClkInitTypeDef,
    system: System
) -> LLErrorStatus {
    var status: LLErrorStatus
    var pllfreq: UInt32

    if UTILS_IsPLLsNotBusy(&registers) == .success {
        pllfreq = UTILS_GetPLLOutputFrequency(HSEFrequency, UTILS_PLLInitStruct)

        if LL_RCC_HSE_IsReady(&registers) != 1 {
            if HSEBypass == 0x1 {
                LL_RCC_HSE_EnableBypass(&registers)
            } else {
                LL_RCC_HSE_DisableBypass(&registers)
            }

            LL_RCC_HSE_Enable(&registers)
            while LL_RCC_HSE_IsReady(&registers) != 1 {
            }
        }

        LL_RCC_PLL1FRACN_Disable(&registers)
        LL_RCC_PLL_SetSource(&registers, 0x2)
        LL_RCC_PLL1_SetVCOInputRange(&registers, UTILS_PLLInitStruct.VCO_Input)
        LL_RCC_PLL1_SetVCOOutputRange(&registers, UTILS_PLLInitStruct.VCO_Output)
        LL_RCC_PLL1_SetM(&registers, UTILS_PLLInitStruct.PLLM)
        LL_RCC_PLL1_SetN(&registers, UTILS_PLLInitStruct.PLLN)
        LL_RCC_PLL1_SetP(&registers, UTILS_PLLInitStruct.PLLP)
        LL_RCC_PLL1_SetFRACN(&registers, UTILS_PLLInitStruct.FRACN)
        LL_RCC_PLL1FRACN_Enable(&registers)
        LL_RCC_PLL1_SetFRACN(&registers, UTILS_PLLInitStruct.FRACN)
        LL_RCC_PLL1FRACN_Enable(&registers)

        status = UTILS_EnablePLLAndSwitchSystem(&registers, pllfreq, &UTILS_ClkInitStruct, system: system)
    } else {
        status = .error
    }
    return status
}

public func LL_SetFlashLatency<IO: LLClockUtilitiesRegisterIO>(_ registers: inout IO, _ HCLK_Frequency: UInt32)
    -> LLErrorStatus
{
    var status: LLErrorStatus = .success
    var timeout: UInt32
    var getlatency: UInt32
    var latency: UInt32 = LL_FLASH_LATENCY_0

    if HCLK_Frequency == 0 {
        status = .error
    } else {
        if LL_PWR_GetRegulVoltageScaling(&registers) == LL_PWR_REGU_VOLTAGE_SCALE0 {
            if HCLK_Frequency <= 0x2625a00 {
            } else if HCLK_Frequency <= 0x4c4b400 {
                latency = LL_FLASH_LATENCY_1
            } else if HCLK_Frequency <= 0x7270e00 {
                latency = LL_FLASH_LATENCY_2
            } else if HCLK_Frequency <= 0x9896800 {
                latency = LL_FLASH_LATENCY_3
            } else if HCLK_Frequency <= 0xbebc200 {
                latency = LL_FLASH_LATENCY_4
            } else if HCLK_Frequency <= 0xe4e1c00 {
                latency = LL_FLASH_LATENCY_5
            } else if HCLK_Frequency <= 0x10b0_7600 {
                latency = LL_FLASH_LATENCY_6
            } else if HCLK_Frequency <= 0x1312_d000 {
                latency = LL_FLASH_LATENCY_7
            } else {
                status = .error
            }
        } else {
            if HCLK_Frequency <= 0x2255100 {
            } else if HCLK_Frequency <= 0x44aa200 {
                latency = LL_FLASH_LATENCY_1
            } else if HCLK_Frequency <= 0x66ff300 {
                latency = LL_FLASH_LATENCY_2
            } else if HCLK_Frequency <= 0x8954400 {
                latency = LL_FLASH_LATENCY_3
            } else if HCLK_Frequency <= 0xaba9500 {
                latency = LL_FLASH_LATENCY_4
            } else if HCLK_Frequency <= 0xcdfe600 {
                latency = LL_FLASH_LATENCY_5
            } else {
                status = .error
            }
        }
    }
    if status == .success {
        LL_FLASH_SetLatency(&registers, latency)

        timeout = 2
        repeat {
            getlatency = LL_FLASH_GetLatency(&registers)
            timeout &-= 1
        } while (getlatency != latency) && (timeout > 0)
        if getlatency != latency {
            status = .error
        }
    }
    return status
}

private func UTILS_GetPLLOutputFrequency(_ PLL_InputFrequency: UInt32, _ UTILS_PLLInitStruct: LL_UTILS_PLLInitTypeDef)
    -> UInt32
{
    var pllfreq: UInt32

    pllfreq = LL_RCC_CalcPLLClockFreq(
        PLL_InputFrequency, UTILS_PLLInitStruct.PLLM, UTILS_PLLInitStruct.PLLN, UTILS_PLLInitStruct.FRACN,
        UTILS_PLLInitStruct.PLLP)
    return pllfreq
}

private func UTILS_IsPLLsNotBusy<IO: LLRCCRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    var status: LLErrorStatus = .success

    if LL_RCC_PLL1_IsReady(&registers) != 0 {
        status = .error
    }

    if LL_RCC_PLL2_IsReady(&registers) != 0 {
        status = .error
    }

    if LL_RCC_PLL3_IsReady(&registers) != 0 {
        status = .error
    }
    return status
}

private func UTILS_EnablePLLAndSwitchSystem<IO: LLClockUtilitiesRegisterIO, System: RCCSystemIO>(
    _ registers: inout IO, _ SYSCLK_Frequency: UInt32, _ UTILS_ClkInitStruct: inout LL_UTILS_ClkInitTypeDef,
    system: System
) -> LLErrorStatus {
    var status: LLErrorStatus = .success
    var new_sysclk_frequency: UInt32
    var new_hclk_frequency: UInt32

    new_sysclk_frequency = LL_RCC_CALC_SYSCLK_FREQ(SYSCLK_Frequency, UTILS_ClkInitStruct.SYSCLKDivider)
    new_hclk_frequency = LL_RCC_CALC_HCLK_FREQ(new_sysclk_frequency, UTILS_ClkInitStruct.AHBCLKDivider)

    if system.getSystemCoreClock() < new_sysclk_frequency {
        status = LL_SetFlashLatency(&registers, new_hclk_frequency)
    }

    if status == .success {
        LL_RCC_PLL1_Enable(&registers)
        while LL_RCC_PLL1_IsReady(&registers) != 1 {
        }
        LL_RCC_PLL1P_Enable(&registers)

        LL_RCC_SetAPB1Prescaler(&registers, 0x7)
        LL_RCC_SetAPB2Prescaler(&registers, 0x70)
        LL_RCC_SetAPB4Prescaler(&registers, 0x700)
        LL_RCC_SetAPB5Prescaler(&registers, 0x7000)

        LL_RCC_SetSysPrescaler(&registers, UTILS_ClkInitStruct.SYSCLKDivider)

        LL_RCC_SetAHBPrescaler(&registers, UTILS_ClkInitStruct.AHBCLKDivider)

        LL_RCC_SetSysClkSource(&registers, 0x3)
        while LL_RCC_GetSysClkSource(&registers) != 0x18 {
        }

        LL_RCC_SetAPB1Prescaler(&registers, UTILS_ClkInitStruct.APB1CLKDivider)
        LL_RCC_SetAPB2Prescaler(&registers, UTILS_ClkInitStruct.APB2CLKDivider)
        LL_RCC_SetAPB4Prescaler(&registers, UTILS_ClkInitStruct.APB4CLKDivider)
        LL_RCC_SetAPB5Prescaler(&registers, UTILS_ClkInitStruct.APB5CLKDivider)

        if system.getSystemCoreClock() > new_sysclk_frequency {
            status = LL_SetFlashLatency(&registers, new_hclk_frequency)
        }

        if status == .success {
            LL_SetSystemCoreClock(new_sysclk_frequency, system: system)
        }
    }
    return status
}
