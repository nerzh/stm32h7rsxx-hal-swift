// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public enum LLDebugRegister: UInt32, CaseIterable, Sendable {
    case ahb1fzr = 0x24
    case ahb5fzr = 0x1C
    case apb1fzr = 0x3C
    case apb2fzr = 0x4C
    case apb4fzr = 0x54
    case cr = 0x4
    case idcode = 0x0
}

public protocol LLDebugRegisterIO {
    mutating func read(_ register: LLDebugRegister) -> UInt32
    mutating func write(_ register: LLDebugRegister, value: UInt32)
}

public let LL_SBS_REGISTER_PINPOS_SHFT: UInt32 = 0x00000010
public let LL_SBS_HDPL_INCREMENT_VALUE: UInt32 = 0x0000006A
public let LL_SBS_DBG_UNLOCK: UInt32 = 0x0000B400
public let LL_SBS_ACCESS_PORT_UNLOCK: UInt32 = 0x000000B4
public let LL_SBS_DBG_CONFIG_LOCK: UInt32 = 0x000000C3
public let LL_SBS_DBG_CONFIG_UNLOCK: UInt32 = 0x000000B4
public let LL_SBS_HDPL0: UInt32 = 0x000000B4
public let LL_SBS_HDPL1: UInt32 = 0x00000051
public let LL_SBS_HDPL2: UInt32 = 0x0000008A
public let LL_SBS_HDPL3: UInt32 = 0x0000006F
public let LL_SBS_AXISRAM_NO_WS: UInt32 = 0x00000000
public let LL_SBS_AXISRAM_ONE_WS: UInt32 = 0x10000000
public let LL_SBS_ETH_PHYSEL_GMII_MII: UInt32 = 0x00000000
public let LL_SBS_ETH_PHYSEL_RMII: UInt32 = 0x00800000
public let LL_SBS_BOOSTVDDSEL_VDDA: UInt32 = 0x00000000
public let LL_SBS_BOOSTVDDSEL_VDD: UInt32 = 0x00000200
public let LL_SBS_XSPI2_CODE_CELL: UInt32 = 0x00000000
public let LL_SBS_XSPI2_CODE_REG: UInt32 = 0x00000020
public let LL_SBS_XSPI1_CODE_CELL: UInt32 = 0x00000000
public let LL_SBS_XSPI1_CODE_REG: UInt32 = 0x00000008
public let LL_SBS_IO_CODE_CELL: UInt32 = 0x00000000
public let LL_SBS_IO_CODE_REG: UInt32 = 0x00000002
public let LL_SBS_TIMBREAK_PVD: UInt32 = 0x00000004
public let LL_SBS_TIMBREAK_FLASHECC: UInt32 = 0x00000008
public let LL_SBS_TIMBREAK_CM7LCKUP: UInt32 = 0x00000040
public let LL_SBS_TIMBREAK_BKRAMECC: UInt32 = 0x00000080
public let LL_SBS_TIMBREAK_DTCMECC: UInt32 = 0x00002000
public let LL_SBS_TIMBREAK_ITCMECC: UInt32 = 0x00004000
public let LL_SBS_TIMBREAK_ARAM3ECC: UInt32 = 0x00200000
public let LL_SBS_TIMBREAK_ARAM1ECC: UInt32 = 0x00800000
public let LL_SBS_EXTI_PORTA: UInt32 = 0x00000000
public let LL_SBS_EXTI_PORTB: UInt32 = 0x00000001
public let LL_SBS_EXTI_PORTC: UInt32 = 0x00000002
public let LL_SBS_EXTI_PORTD: UInt32 = 0x00000003
public let LL_SBS_EXTI_PORTE: UInt32 = 0x00000004
public let LL_SBS_EXTI_PORTF: UInt32 = 0x00000005
public let LL_SBS_EXTI_PORTG: UInt32 = 0x00000006
public let LL_SBS_EXTI_PORTH: UInt32 = 0x00000007
public let LL_SBS_EXTI_PORTM: UInt32 = 0x0000000C
public let LL_SBS_EXTI_PORTN: UInt32 = 0x0000000D
public let LL_SBS_EXTI_PORTO: UInt32 = 0x0000000E
public let LL_SBS_EXTI_PORTP: UInt32 = 0x0000000F
public let LL_SBS_EXTI_LINE0: UInt32 = 0x00000000
public let LL_SBS_EXTI_LINE1: UInt32 = 0x00040000
public let LL_SBS_EXTI_LINE2: UInt32 = 0x00080000
public let LL_SBS_EXTI_LINE3: UInt32 = 0x000C0000
public let LL_SBS_EXTI_LINE4: UInt32 = 0x00000001
public let LL_SBS_EXTI_LINE5: UInt32 = 0x00040001
public let LL_SBS_EXTI_LINE6: UInt32 = 0x00080001
public let LL_SBS_EXTI_LINE7: UInt32 = 0x000C0001
public let LL_SBS_EXTI_LINE8: UInt32 = 0x00000002
public let LL_SBS_EXTI_LINE9: UInt32 = 0x00040002
public let LL_SBS_EXTI_LINE10: UInt32 = 0x00080002
public let LL_SBS_EXTI_LINE11: UInt32 = 0x000C0002
public let LL_SBS_EXTI_LINE12: UInt32 = 0x00000003
public let LL_SBS_EXTI_LINE13: UInt32 = 0x00040003
public let LL_SBS_EXTI_LINE14: UInt32 = 0x00080003
public let LL_SBS_EXTI_LINE15: UInt32 = 0x000C0003
public let LL_DBGMCU_DCRT_SYSTEM: UInt32 = 0x00000000
public let LL_DBGMCU_DCRT_POWER: UInt32 = 0x00010000
public let LL_DBGMCU_AHB5_GRP1_HPDMA0_STOP: UInt32 = 0x00000001
public let LL_DBGMCU_AHB5_GRP1_HPDMA1_STOP: UInt32 = 0x00000002
public let LL_DBGMCU_AHB5_GRP1_HPDMA2_STOP: UInt32 = 0x00000004
public let LL_DBGMCU_AHB5_GRP1_HPDMA3_STOP: UInt32 = 0x00000008
public let LL_DBGMCU_AHB5_GRP1_HPDMA4_STOP: UInt32 = 0x00000010
public let LL_DBGMCU_AHB5_GRP1_HPDMA5_STOP: UInt32 = 0x00000020
public let LL_DBGMCU_AHB5_GRP1_HPDMA6_STOP: UInt32 = 0x00000040
public let LL_DBGMCU_AHB5_GRP1_HPDMA7_STOP: UInt32 = 0x00000080
public let LL_DBGMCU_AHB5_GRP1_HPDMA8_STOP: UInt32 = 0x00000100
public let LL_DBGMCU_AHB5_GRP1_HPDMA9_STOP: UInt32 = 0x00000200
public let LL_DBGMCU_AHB5_GRP1_HPDMA10_STOP: UInt32 = 0x00000400
public let LL_DBGMCU_AHB5_GRP1_HPDMA11_STOP: UInt32 = 0x00000800
public let LL_DBGMCU_AHB5_GRP1_HPDMA12_STOP: UInt32 = 0x00001000
public let LL_DBGMCU_AHB5_GRP1_HPDMA13_STOP: UInt32 = 0x00002000
public let LL_DBGMCU_AHB5_GRP1_HPDMA14_STOP: UInt32 = 0x00004000
public let LL_DBGMCU_AHB5_GRP1_HPDMA15_STOP: UInt32 = 0x00008000
public let LL_DBGMCU_AHB1_GRP1_GPDMA0_STOP: UInt32 = 0x00000001
public let LL_DBGMCU_AHB1_GRP1_GPDMA1_STOP: UInt32 = 0x00000002
public let LL_DBGMCU_AHB1_GRP1_GPDMA2_STOP: UInt32 = 0x00000004
public let LL_DBGMCU_AHB1_GRP1_GPDMA3_STOP: UInt32 = 0x00000008
public let LL_DBGMCU_AHB1_GRP1_GPDMA4_STOP: UInt32 = 0x00000010
public let LL_DBGMCU_AHB1_GRP1_GPDMA5_STOP: UInt32 = 0x00000020
public let LL_DBGMCU_AHB1_GRP1_GPDMA6_STOP: UInt32 = 0x00000040
public let LL_DBGMCU_AHB1_GRP1_GPDMA7_STOP: UInt32 = 0x00000080
public let LL_DBGMCU_AHB1_GRP1_GPDMA8_STOP: UInt32 = 0x00000100
public let LL_DBGMCU_AHB1_GRP1_GPDMA9_STOP: UInt32 = 0x00000200
public let LL_DBGMCU_AHB1_GRP1_GPDMA10_STOP: UInt32 = 0x00000400
public let LL_DBGMCU_AHB1_GRP1_GPDMA11_STOP: UInt32 = 0x00000800
public let LL_DBGMCU_AHB1_GRP1_GPDMA12_STOP: UInt32 = 0x00001000
public let LL_DBGMCU_AHB1_GRP1_GPDMA13_STOP: UInt32 = 0x00002000
public let LL_DBGMCU_AHB1_GRP1_GPDMA14_STOP: UInt32 = 0x00004000
public let LL_DBGMCU_AHB1_GRP1_GPDMA15_STOP: UInt32 = 0x00008000
public let LL_DBGMCU_APB1_GRP1_TIM2_STOP: UInt32 = 0x00000001
public let LL_DBGMCU_APB1_GRP1_TIM3_STOP: UInt32 = 0x00000002
public let LL_DBGMCU_APB1_GRP1_TIM4_STOP: UInt32 = 0x00000004
public let LL_DBGMCU_APB1_GRP1_TIM5_STOP: UInt32 = 0x00000008
public let LL_DBGMCU_APB1_GRP1_TIM6_STOP: UInt32 = 0x00000010
public let LL_DBGMCU_APB1_GRP1_TIM7_STOP: UInt32 = 0x00000020
public let LL_DBGMCU_APB1_GRP1_TIM12_STOP: UInt32 = 0x00000040
public let LL_DBGMCU_APB1_GRP1_TIM13_STOP: UInt32 = 0x00000080
public let LL_DBGMCU_APB1_GRP1_TIM14_STOP: UInt32 = 0x00000100
public let LL_DBGMCU_APB1_GRP1_LPTIM1_STOP: UInt32 = 0x00000200
public let LL_DBGMCU_APB1_GRP1_WWDG_STOP: UInt32 = 0x00000800
public let LL_DBGMCU_APB1_GRP1_I2C1_STOP: UInt32 = 0x00200000
public let LL_DBGMCU_APB1_GRP1_I2C2_STOP: UInt32 = 0x00400000
public let LL_DBGMCU_APB1_GRP1_I2C3_STOP: UInt32 = 0x00800000
public let LL_DBGMCU_APB2_GRP1_TIM1_STOP: UInt32 = 0x00000001
public let LL_DBGMCU_APB2_GRP1_TIM9_STOP: UInt32 = 0x00080000
public let LL_DBGMCU_APB2_GRP1_TIM15_STOP: UInt32 = 0x00010000
public let LL_DBGMCU_APB2_GRP1_TIM16_STOP: UInt32 = 0x00020000
public let LL_DBGMCU_APB2_GRP1_TIM17_STOP: UInt32 = 0x00040000
public let LL_DBGMCU_APB4_GRP1_LPTIM2_STOP: UInt32 = 0x00000200
public let LL_DBGMCU_APB4_GRP1_LPTIM3_STOP: UInt32 = 0x00000400
public let LL_DBGMCU_APB4_GRP1_LPTIM4_STOP: UInt32 = 0x00000800
public let LL_DBGMCU_APB4_GRP1_LPTIM5_STOP: UInt32 = 0x00001000
public let LL_DBGMCU_APB4_GRP1_IWDG_STOP: UInt32 = 0x00040000
public let LL_DBGMCU_APB4_GRP1_RTC_STOP: UInt32 = 0x00010000
public let LL_VREFBUF_VOLTAGE_SCALE0: UInt32 = 0x00000000
public let LL_VREFBUF_VOLTAGE_SCALE1: UInt32 = 0x00000010
public let LL_VREFBUF_VOLTAGE_SCALE2: UInt32 = 0x00000020
public let LL_VREFBUF_VOLTAGE_SCALE3: UInt32 = 0x00000030
public let LL_FLASH_LATENCY_0: UInt32 = 0x00000000
public let LL_FLASH_LATENCY_1: UInt32 = 0x00000001
public let LL_FLASH_LATENCY_2: UInt32 = 0x00000002
public let LL_FLASH_LATENCY_3: UInt32 = 0x00000003
public let LL_FLASH_LATENCY_4: UInt32 = 0x00000004
public let LL_FLASH_LATENCY_5: UInt32 = 0x00000005
public let LL_FLASH_LATENCY_6: UInt32 = 0x00000006
public let LL_FLASH_LATENCY_7: UInt32 = 0x00000007

public func LL_SBS_GetBootAddress<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.bootsr) & (0xFFFFFFFF)))
}

public func LL_SBS_IncrementHDPL<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.hdplcr, value: (registers.read(SBSRegister.hdplcr) & ~(0xFF)) | (LL_SBS_HDPL_INCREMENT_VALUE))
}

public func LL_SBS_GetCurrentHDPL<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.hdplsr) & (0xFF)))
}

public func LL_SBS_SetAuthDbgHDPL<IO: SBSRegisterIO>(_ registers: inout IO, _ Level: UInt32) {
    registers.write(SBSRegister.dbgcr, value: (registers.read(SBSRegister.dbgcr) & ~(0xFF0000)) | ((Level << 0x10)))
}

public func LL_SBS_GetAuthDbgHDPL<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.dbgcr) & (0xFF0000)) >> 0x10)
}

public func LL_SBS_UnlockDebug<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.dbgcr, value: (registers.read(SBSRegister.dbgcr) & ~(0xFF00)) | (LL_SBS_DBG_UNLOCK))
}

public func LL_SBS_IsUnlockedDebug<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.dbgcr) & (0xFF00)) == LL_SBS_DBG_UNLOCK) ? 1 : 0)
}

public func LL_SBS_UnlockAccessPort<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.dbgcr, value: (registers.read(SBSRegister.dbgcr) & ~(0xFF)) | (LL_SBS_ACCESS_PORT_UNLOCK))
}

public func LL_SBS_IsUnlockedAccessPort<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.dbgcr) & (0xFF)) == LL_SBS_ACCESS_PORT_UNLOCK) ? 1 : 0)
}

public func LL_SBS_LockDebugConfig<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.dbglockr, value: (registers.read(SBSRegister.dbglockr) & ~(0xFF)) | (LL_SBS_DBG_CONFIG_LOCK))
}

public func LL_SBS_UnlockDebugConfig<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.dbglockr, value: (registers.read(SBSRegister.dbglockr) & ~(0xFF)) | (LL_SBS_DBG_CONFIG_UNLOCK))
}

public func LL_SBS_IsUnlockedDebugConfig<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.dbglockr) & (0xFF)) == LL_SBS_DBG_CONFIG_UNLOCK) ? 1 : 0)
}

public func LL_SBS_SetRSSCmd<IO: SBSRegisterIO>(_ registers: inout IO, _ Command: UInt32) {
    registers.write(SBSRegister.rsscmdr, value: (registers.read(SBSRegister.rsscmdr) & ~(0xFFFF)) | (Command))
}

public func LL_SBS_GetRSSCmd<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.rsscmdr) & (0xFFFF)))
}

public func LL_SBS_SetAXISRAMWaitState<IO: SBSRegisterIO>(_ registers: inout IO, _ WaitState: UInt32) {
    registers.write(SBSRegister.pmcr, value: (registers.read(SBSRegister.pmcr) & ~(0x10000000)) | (WaitState))
}

public func LL_SBS_GetAXISRAMWaitState<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.pmcr) & (0x10000000)))
}

public func LL_SBS_SetEthernetPhy<IO: SBSRegisterIO>(_ registers: inout IO, _ Interface: UInt32) {
    registers.write(SBSRegister.pmcr, value: (registers.read(SBSRegister.pmcr) & ~(0xE00000)) | (Interface))
}

public func LL_SBS_GetEthernetPhy<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.pmcr) & (0xE00000)))
}

public func LL_SBS_SetBoosterVoltage<IO: SBSRegisterIO>(_ registers: inout IO, _ Voltage: UInt32) {
    registers.write(SBSRegister.pmcr, value: (registers.read(SBSRegister.pmcr) & ~(0x200)) | (Voltage))
}

public func LL_SBS_GetBoosterVoltage<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.pmcr) & (0x200)))
}

public func LL_SBS_EnableBooster<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.pmcr, value: registers.read(SBSRegister.pmcr) | (0x100))
}

public func LL_SBS_DisableBooster<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.pmcr, value: registers.read(SBSRegister.pmcr) & ~(0x100))
}

public func LL_SBS_IsEnabledBooster<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.pmcr) & (0x100)) != 0) ? 1 : 0)
}

public func LL_SBS_EnableIT_FPU_IOC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) | (0x1))
}

public func LL_SBS_EnableIT_FPU_DZC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) | (0x2))
}

public func LL_SBS_EnableIT_FPU_UFC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) | (0x4))
}

public func LL_SBS_EnableIT_FPU_OFC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) | (0x8))
}

public func LL_SBS_EnableIT_FPU_IDC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) | (0x10))
}

public func LL_SBS_EnableIT_FPU_IXC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) | (0x20))
}

public func LL_SBS_DisableIT_FPU_IOC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) & ~(0x1))
}

public func LL_SBS_DisableIT_FPU_DZC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) & ~(0x2))
}

public func LL_SBS_DisableIT_FPU_UFC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) & ~(0x4))
}

public func LL_SBS_DisableIT_FPU_OFC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) & ~(0x8))
}

public func LL_SBS_DisableIT_FPU_IDC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) & ~(0x10))
}

public func LL_SBS_DisableIT_FPU_IXC<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.fpuimr, value: registers.read(SBSRegister.fpuimr) & ~(0x20))
}

public func LL_SBS_IsEnabledIT_FPU_IOC<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.fpuimr) & (0x1)) == 0x1) ? 1 : 0)
}

public func LL_SBS_IsEnabledIT_FPU_DZC<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.fpuimr) & (0x2)) == 0x2) ? 1 : 0)
}

public func LL_SBS_IsEnabledIT_FPU_UFC<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.fpuimr) & (0x4)) == 0x4) ? 1 : 0)
}

public func LL_SBS_IsEnabledIT_FPU_OFC<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.fpuimr) & (0x8)) == 0x8) ? 1 : 0)
}

public func LL_SBS_IsEnabledIT_FPU_IDC<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.fpuimr) & (0x10)) == 0x10) ? 1 : 0)
}

public func LL_SBS_IsEnabledIT_FPU_IXC<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.fpuimr) & (0x20)) == 0x20) ? 1 : 0)
}

public func LL_SBS_IsDoneMemoryErase<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.mesr) & (0x1)))
}

public func LL_SBS_EnableXSPI2SpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) | (0x40000))
}

public func LL_SBS_DisableXSPI2SpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) & ~(0x40000))
}

public func LL_SBS_IsEnabledXSPI2SpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x40000)) != 0) ? 1 : 0)
}

public func LL_SBS_EnableXSPI1SpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) | (0x20000))
}

public func LL_SBS_DisableXSPI1SpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) & ~(0x20000))
}

public func LL_SBS_IsEnabledXSPI1SpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x20000)) != 0) ? 1 : 0)
}

public func LL_SBS_EnableIOSpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) | (0x10000))
}

public func LL_SBS_DisableIOSpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) & ~(0x10000))
}

public func LL_SBS_IsEnabledIOSpeedOptim<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x10000)) != 0) ? 1 : 0)
}

public func LL_SBS_IsReadyXSPI2CompCell<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x400)) != 0) ? 1 : 0)
}

public func LL_SBS_IsReadyXSPI1CompCell<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x200)) != 0) ? 1 : 0)
}

public func LL_SBS_IsReadyIOCompCell<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x100)) != 0) ? 1 : 0)
}

public func LL_SBS_SetXSPI2CompCellCode<IO: SBSRegisterIO>(_ registers: inout IO, _ Code: UInt32) {
    registers.write(SBSRegister.cccsr, value: (registers.read(SBSRegister.cccsr) & ~(0x20)) | (Code))
}

public func LL_SBS_GetXSPI2CompCellCode<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.cccsr) & (0x20)))
}

public func LL_SBS_EnableXSPI2CompCell<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) | (0x10))
}

public func LL_SBS_DisableXSPI2CompCell<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) & ~(0x10))
}

public func LL_SBS_IsEnabledXSPI2CompCell<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x10)) != 0) ? 1 : 0)
}

public func LL_SBS_SetXSPI1CompCellCode<IO: SBSRegisterIO>(_ registers: inout IO, _ Code: UInt32) {
    registers.write(SBSRegister.cccsr, value: (registers.read(SBSRegister.cccsr) & ~(0x8)) | (Code))
}

public func LL_SBS_GetXSPI1CompCellCode<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.cccsr) & (0x8)))
}

public func LL_SBS_EnableXSPI1CompCell<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) | (0x4))
}

public func LL_SBS_DisableXSPI1CompCell<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) & ~(0x4))
}

public func LL_SBS_IsEnabledXSPI1CompCell<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x4)) != 0) ? 1 : 0)
}

public func LL_SBS_SetIOCompCellCode<IO: SBSRegisterIO>(_ registers: inout IO, _ Code: UInt32) {
    registers.write(SBSRegister.cccsr, value: (registers.read(SBSRegister.cccsr) & ~(0x2)) | (Code))
}

public func LL_SBS_GetIOCompCellCode<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.cccsr) & (0x2)))
}

public func LL_SBS_EnableIOCompCell<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) | (0x1))
}

public func LL_SBS_DisableIOCompCell<IO: SBSRegisterIO>(_ registers: inout IO) {
    registers.write(SBSRegister.cccsr, value: registers.read(SBSRegister.cccsr) & ~(0x1))
}

public func LL_SBS_IsEnabledIOCompCell<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.cccsr) & (0x1)) != 0) ? 1 : 0)
}

public func LL_SBS_GetXSPI2PmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccvalr) & (0xF00000))) >> 0x14)
}

public func LL_SBS_GetXSPI2NmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccvalr) & (0xF0000))) >> 0x10)
}

public func LL_SBS_GetXSPI1PmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccvalr) & (0xF000))) >> 0xC)
}

public func LL_SBS_GetXSPI1NmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccvalr) & (0xF00))) >> 0x8)
}

public func LL_SBS_GetIOPmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccvalr) & (0xF0))) >> 0x4)
}

public func LL_SBS_GetIONmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.ccvalr) & (0xF)))
}

public func LL_SBS_SetXSPI2SwPmosComp<IO: SBSRegisterIO>(_ registers: inout IO, _ Compensation: UInt32) {
    registers.write(SBSRegister.ccswvalr, value: (registers.read(SBSRegister.ccswvalr) & ~(0xF00000)) | ((Compensation << 0x14)))
}

public func LL_SBS_GetXSPI2SwPmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccswvalr) & (0xF00000))) >> 0x14)
}

public func LL_SBS_SetXSPI2SwNmosComp<IO: SBSRegisterIO>(_ registers: inout IO, _ Compensation: UInt32) {
    registers.write(SBSRegister.ccswvalr, value: (registers.read(SBSRegister.ccswvalr) & ~(0xF0000)) | ((Compensation << 0x10)))
}

public func LL_SBS_GetXSPI2SwNmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccswvalr) & (0xF0000))) >> 0x10)
}

public func LL_SBS_SetXSPI1SwPmosComp<IO: SBSRegisterIO>(_ registers: inout IO, _ Compensation: UInt32) {
    registers.write(SBSRegister.ccswvalr, value: (registers.read(SBSRegister.ccswvalr) & ~(0xF000)) | ((Compensation << 0xC)))
}

public func LL_SBS_GetXSPI1SwPmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccswvalr) & (0xF000))) >> 0xC)
}

public func LL_SBS_SetXSPI1SwNmosComp<IO: SBSRegisterIO>(_ registers: inout IO, _ Compensation: UInt32) {
    registers.write(SBSRegister.ccswvalr, value: (registers.read(SBSRegister.ccswvalr) & ~(0xF00)) | ((Compensation << 0x8)))
}

public func LL_SBS_GetXSPI1SwNmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccswvalr) & (0xF00))) >> 0x8)
}

public func LL_SBS_SetIOSwPmosComp<IO: SBSRegisterIO>(_ registers: inout IO, _ Compensation: UInt32) {
    registers.write(SBSRegister.ccswvalr, value: (registers.read(SBSRegister.ccswvalr) & ~(0xF0)) | ((Compensation << 0x4)))
}

public func LL_SBS_GetIOSwPmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccswvalr) & (0xF0))) >> 0x4)
}

public func LL_SBS_SetIOSwNmosComp<IO: SBSRegisterIO>(_ registers: inout IO, _ Compensation: UInt32) {
    registers.write(SBSRegister.ccswvalr, value: (registers.read(SBSRegister.ccswvalr) & ~(0xF)) | ((Compensation << 0x0)))
}

public func LL_SBS_GetIOSwNmosComp<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(SBSRegister.ccswvalr) & (0xF))) >> 0x0)
}

public func LL_SBS_SetTIMBreakInputs<IO: SBSRegisterIO>(_ registers: inout IO, _ Break: UInt32) {
    registers.write(SBSRegister.bklockr, value: (registers.read(SBSRegister.bklockr) & ~((0x4 | 0x8 | 0x40 | 0x80 | 0x2000 | 0x4000 | 0x200000 | 0x800000))) | (Break))
}

public func LL_SBS_GetTIMBreakInputs<IO: SBSRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(SBSRegister.bklockr) & ((0x4 | 0x8 | 0x40 | 0x80 | 0x2000 | 0x4000 | 0x200000 | 0x800000))))
}

public func LL_SBS_SetEXTISource<IO: SBSRegisterIO>(_ registers: inout IO, _ Port: UInt32, _ Line: UInt32) {
    registers.write(SBSRegister.extiConfiguration(index: Int(Line & 0x03)), value: (registers.read(SBSRegister.extiConfiguration(index: Int(Line & 0x03))) & ~(0xF << (Line >> LL_SBS_REGISTER_PINPOS_SHFT))) | (Port << (Line >> LL_SBS_REGISTER_PINPOS_SHFT)))
}

public func LL_SBS_GetEXTISource<IO: SBSRegisterIO>(_ registers: inout IO, _ Line: UInt32) -> UInt32 {
    return ((registers.read(SBSRegister.extiConfiguration(index: Int(Line & 0x03))) & ((0xF << (Line >> LL_SBS_REGISTER_PINPOS_SHFT)))) >> (Line >> LL_SBS_REGISTER_PINPOS_SHFT))
}

public func LL_DBGMCU_GetDeviceID<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLDebugRegister.idcode) & (0xFFF)))
}

public func LL_DBGMCU_GetRevisionID<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLDebugRegister.idcode) & (0xFFFF0000)) >> 0x10)
}

public func LL_DBGMCU_EnableDBGSleepMode<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) | (0x1))
}

public func LL_DBGMCU_DisableDBGSleepMode<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) & ~(0x1))
}

public func LL_DBGMCU_IsEnabledDBGSleepMode<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLDebugRegister.cr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_DBGMCU_EnableDBGStopMode<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) | (0x2))
}

public func LL_DBGMCU_DisableDBGStopMode<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) & ~(0x2))
}

public func LL_DBGMCU_IsEnabledDBGStopMode<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLDebugRegister.cr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_DBGMCU_EnableDBGStandbyMode<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) | (0x4))
}

public func LL_DBGMCU_DisableDBGStandbyMode<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) & ~(0x4))
}

public func LL_DBGMCU_IsEnabledDBGStandbyMode<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLDebugRegister.cr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_DBGMCU_SetDbgCredentialResetType<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Type: UInt32) {
    registers.write(LLDebugRegister.cr, value: (registers.read(LLDebugRegister.cr) & ~(0x10000)) | (Type))
}

public func LL_DBGMCU_GetDbgCredentialResetType<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLDebugRegister.cr) & (0x10000)))
}

public func LL_DBGMCU_EnableTraceClock<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) | (0x100000))
}

public func LL_DBGMCU_DisableTraceClock<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) & ~(0x100000))
}

public func LL_DBGMCU_IsEnabledTraceClock<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLDebugRegister.cr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_DBGMCU_EnableDebugClock<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) | (0x200000))
}

public func LL_DBGMCU_DisableDebugClock<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) & ~(0x200000))
}

public func LL_DBGMCU_IsEnabledDebugClock<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLDebugRegister.cr) & (0x200000)) != 0) ? 1 : 0)
}

public func LL_DBGMCU_EnableTriggerOutput<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) | (0x10000000))
}

public func LL_DBGMCU_DisableTriggerOutput<IO: LLDebugRegisterIO>(_ registers: inout IO) {
    registers.write(LLDebugRegister.cr, value: registers.read(LLDebugRegister.cr) & ~(0x10000000))
}

public func LL_DBGMCU_IsEnabledTriggerOutput<IO: LLDebugRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(LLDebugRegister.cr) & (0x10000000)) != 0) ? 1 : 0)
}

public func LL_DBGMCU_APB1_GRP1_FreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.apb1fzr, value: registers.read(LLDebugRegister.apb1fzr) | (Periphs))
}

public func LL_DBGMCU_APB1_GRP1_UnFreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.apb1fzr, value: registers.read(LLDebugRegister.apb1fzr) & ~(Periphs))
}

public func LL_DBGMCU_APB4_GRP1_FreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.apb4fzr, value: registers.read(LLDebugRegister.apb4fzr) | (Periphs))
}

public func LL_DBGMCU_APB4_GRP1_UnFreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.apb4fzr, value: registers.read(LLDebugRegister.apb4fzr) & ~(Periphs))
}

public func LL_DBGMCU_APB2_GRP1_FreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.apb2fzr, value: registers.read(LLDebugRegister.apb2fzr) | (Periphs))
}

public func LL_DBGMCU_APB2_GRP1_UnFreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.apb2fzr, value: registers.read(LLDebugRegister.apb2fzr) & ~(Periphs))
}

public func LL_DBGMCU_AHB5_GRP1_FreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.ahb5fzr, value: registers.read(LLDebugRegister.ahb5fzr) | (Periphs))
}

public func LL_DBGMCU_AHB5_GRP1_UnFreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.ahb5fzr, value: registers.read(LLDebugRegister.ahb5fzr) & ~(Periphs))
}

public func LL_DBGMCU_AHB1_GRP1_FreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.ahb1fzr, value: registers.read(LLDebugRegister.ahb1fzr) | (Periphs))
}

public func LL_DBGMCU_AHB1_GRP1_UnFreezePeriph<IO: LLDebugRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(LLDebugRegister.ahb1fzr, value: registers.read(LLDebugRegister.ahb1fzr) & ~(Periphs))
}

public func LL_VREFBUF_Enable<IO: VREFBUFRegisterIO>(_ registers: inout IO) {
    registers.write(VREFBUFRegister.csr, value: registers.read(VREFBUFRegister.csr) | (0x1))
}

public func LL_VREFBUF_Disable<IO: VREFBUFRegisterIO>(_ registers: inout IO) {
    registers.write(VREFBUFRegister.csr, value: registers.read(VREFBUFRegister.csr) & ~(0x1))
}

public func LL_VREFBUF_EnableHIZ<IO: VREFBUFRegisterIO>(_ registers: inout IO) {
    registers.write(VREFBUFRegister.csr, value: registers.read(VREFBUFRegister.csr) | (0x2))
}

public func LL_VREFBUF_DisableHIZ<IO: VREFBUFRegisterIO>(_ registers: inout IO) {
    registers.write(VREFBUFRegister.csr, value: registers.read(VREFBUFRegister.csr) & ~(0x2))
}

public func LL_VREFBUF_SetVoltageScaling<IO: VREFBUFRegisterIO>(_ registers: inout IO, _ Scale: UInt32) {
    registers.write(VREFBUFRegister.csr, value: (registers.read(VREFBUFRegister.csr) & ~(0x70)) | (Scale))
}

public func LL_VREFBUF_GetVoltageScaling<IO: VREFBUFRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(VREFBUFRegister.csr) & (0x70)))
}

public func LL_VREFBUF_IsVREFReady<IO: VREFBUFRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(VREFBUFRegister.csr) & (0x8)) == 0x8) ? 1 : 0)
}

public func LL_VREFBUF_GetTrimming<IO: VREFBUFRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(VREFBUFRegister.ccr) & (0x3F)))
}

public func LL_VREFBUF_SetTrimming<IO: VREFBUFRegisterIO>(_ registers: inout IO, _ Value: UInt32) {
    registers.write(VREFBUFRegister.ccr, value: Value)
}

public func LL_FLASH_SetLatency<IO: FlashTimingRegisterIO>(_ registers: inout IO, _ Latency: UInt32) {
    registers.write(FlashTimingRegister.acr, value: (registers.read(FlashTimingRegister.acr) & ~(0xF)) | (Latency))
}

public func LL_FLASH_GetLatency<IO: FlashTimingRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(FlashTimingRegister.acr) & (0xF)))
}

public func LL_FLASH_Unlock<IO: FlashRegisterIO>(_ registers: inout IO) {
    registers.write(FlashRegister.keyr, value: 0x45670123)
    registers.write(FlashRegister.keyr, value: 0xCDEF89AB)
}

public func LL_FLASH_Lock<IO: FlashRegisterIO>(_ registers: inout IO) {
    registers.write(FlashRegister.cr, value: registers.read(FlashRegister.cr) | (0x1))
}

public func LL_FLASH_IsLocked<IO: FlashRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(FlashRegister.cr) & (0x1)) == 0x1) ? 1 : 0)
}

public func LL_FLASH_OptionBytes_Unlock<IO: FlashRegisterIO>(_ registers: inout IO) {
    registers.write(FlashRegister.optkeyr, value: 0x08192A3B)
    registers.write(FlashRegister.optkeyr, value: 0x4C5D6E7F)
}

public func LL_FLASH_OptionBytes_Lock<IO: FlashRegisterIO>(_ registers: inout IO) {
    registers.write(FlashRegister.optcr, value: registers.read(FlashRegister.optcr) | (0x1))
}

public func LL_FLASH_OptionBytes_IsLocked<IO: FlashRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(FlashRegister.optcr) & (0x1)) == 0x1) ? 1 : 0)
}

public func LL_FLASH_OptionBytes_EnableProg<IO: FlashRegisterIO>(_ registers: inout IO) {
    registers.write(FlashRegister.optcr, value: registers.read(FlashRegister.optcr) | (0x2))
}

public func LL_FLASH_OptionBytes_DisableProg<IO: FlashRegisterIO>(_ registers: inout IO) {
    registers.write(FlashRegister.optcr, value: registers.read(FlashRegister.optcr) & ~(0x2))
}

public func LL_FLASH_OptionBytes_IsEnabledProg<IO: FlashRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(FlashRegister.optcr) & (0x2)) == 0x2) ? 1 : 0)
}

public func LL_FLASH_IsPendingOperation<IO: FlashRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(FlashRegister.sr) & (0x4)) == 0x4) ? 1 : 0)
}

public func LL_FLASH_OptionBytes_EnableI2C<IO: FlashRegisterIO>(_ registers: inout IO) {
    registers.write(FlashRegister.obw2srp, value: registers.read(FlashRegister.obw2srp) | (0x200))
}

public func LL_FLASH_OptionBytes_EnableI3C<IO: FlashRegisterIO>(_ registers: inout IO) {
    registers.write(FlashRegister.obw2srp, value: registers.read(FlashRegister.obw2srp) & ~(0x200))
}

public func LL_FLASH_OptionBytes_IsI2CEnabled<IO: FlashRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(FlashRegister.obw2sr) & (0x200)) == 0x200) ? 1 : 0)
}

public func LL_FLASH_OptionBytes_IsI3CEnabled<IO: FlashRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(FlashRegister.obw2sr) & (0x200)) == 0) ? 1 : 0)
}
