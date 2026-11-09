// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from stm32h7rsxx_ll_*.h/.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// CMSIS encodings: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

public enum LLBusRegister: UInt32, CaseIterable, Sendable {
    case ahb1enr = 0x138
    case ahb1rstr = 0x080
    case ahb1lpenr = 0x160
    case ahb2enr = 0x13C
    case ahb2rstr = 0x084
    case ahb2lpenr = 0x164
    case ahb3enr = 0x158
    case ahb3rstr = 0x0A4
    case ahb3lpenr = 0x16C
    case ahb4enr = 0x140
    case ahb4rstr = 0x088
    case ahb4lpenr = 0x168
    case ahb5enr = 0x134
    case ahb5rstr = 0x07C
    case ahb5lpenr = 0x15C
    case apb1enr1 = 0x148
    case apb1rstr1 = 0x090
    case apb1lpenr1 = 0x170
    case apb1enr2 = 0x14C
    case apb1rstr2 = 0x094
    case apb1lpenr2 = 0x174
    case apb2enr = 0x150
    case apb2rstr = 0x098
    case apb2lpenr = 0x178
    case apb4enr = 0x154
    case apb4rstr = 0x09C
    case apb4lpenr = 0x17C
    case apb5enr = 0x144
    case apb5rstr = 0x08C
    case apb5lpenr = 0x180
    case ckgdisr = 0x0B0
}

public protocol LLBusRegisterIO {
    mutating func read(_ register: LLBusRegister) -> UInt32
    mutating func write(_ register: LLBusRegister, value: UInt32)
}

public let LL_AHB1_GRP1_PERIPH_GPDMA1: UInt32 = 0x00000010
public let LL_AHB1_GRP1_PERIPH_ADC12: UInt32 = 0x00000020
public let LL_AHB1_GRP1_PERIPH_ETH1MAC: UInt32 = 0x00008000
public let LL_AHB1_GRP1_PERIPH_ETH1TX: UInt32 = 0x00010000
public let LL_AHB1_GRP1_PERIPH_ETH1RX: UInt32 = 0x00020000
public let LL_AHB1_GRP1_PERIPH_USBOTGHS: UInt32 = 0x02000000
public let LL_AHB1_GRP1_PERIPH_USBOTGFS: UInt32 = 0x08000000
public let LL_AHB1_GRP1_PERIPH_USBPHYC: UInt32 = 0x04000000
public let LL_AHB1_GRP1_PERIPH_ADF1: UInt32 = 0x80000000
public let LL_AHB2_GRP1_PERIPH_PSSI: UInt32 = 0x00000002
public let LL_AHB2_GRP1_PERIPH_SDMMC2: UInt32 = 0x00000200
public let LL_AHB2_GRP1_PERIPH_CORDIC: UInt32 = 0x00004000
public let LL_AHB2_GRP1_PERIPH_AHBSRAM1: UInt32 = 0x20000000
public let LL_AHB2_GRP1_PERIPH_AHBSRAM2: UInt32 = 0x40000000
public let LL_AHB3_GRP1_PERIPH_RNG: UInt32 = 0x00000001
public let LL_AHB3_GRP1_PERIPH_HASH: UInt32 = 0x00000002
public let LL_AHB3_GRP1_PERIPH_CRYP: UInt32 = 0x00000004
public let LL_AHB3_GRP1_PERIPH_SAES: UInt32 = 0x00000010
public let LL_AHB3_GRP1_PERIPH_PKA: UInt32 = 0x00000040
public let LL_AHB4_GRP1_PERIPH_GPIOA: UInt32 = 0x00000001
public let LL_AHB4_GRP1_PERIPH_GPIOB: UInt32 = 0x00000002
public let LL_AHB4_GRP1_PERIPH_GPIOC: UInt32 = 0x00000004
public let LL_AHB4_GRP1_PERIPH_GPIOD: UInt32 = 0x00000008
public let LL_AHB4_GRP1_PERIPH_GPIOE: UInt32 = 0x00000010
public let LL_AHB4_GRP1_PERIPH_GPIOF: UInt32 = 0x00000020
public let LL_AHB4_GRP1_PERIPH_GPIOG: UInt32 = 0x00000040
public let LL_AHB4_GRP1_PERIPH_GPIOH: UInt32 = 0x00000080
public let LL_AHB4_GRP1_PERIPH_GPIOM: UInt32 = 0x00001000
public let LL_AHB4_GRP1_PERIPH_GPION: UInt32 = 0x00002000
public let LL_AHB4_GRP1_PERIPH_GPIOO: UInt32 = 0x00004000
public let LL_AHB4_GRP1_PERIPH_GPIOP: UInt32 = 0x00008000
public let LL_AHB4_GRP1_PERIPH_CRC: UInt32 = 0x00080000
public let LL_AHB4_GRP1_PERIPH_BKPRAM: UInt32 = 0x10000000
public let LL_AHB5_GRP1_PERIPH_HPDMA1: UInt32 = 0x00000001
public let LL_AHB5_GRP1_PERIPH_DMA2D: UInt32 = 0x00000002
public let LL_AHB5_GRP1_PERIPH_JPEG: UInt32 = 0x00000008
public let LL_AHB5_GRP1_PERIPH_FMC: UInt32 = 0x00000010
public let LL_AHB5_GRP1_PERIPH_XSPI1: UInt32 = 0x00000020
public let LL_AHB5_GRP1_PERIPH_XSPI2: UInt32 = 0x00001000
public let LL_AHB5_GRP1_PERIPH_XSPIM: UInt32 = 0x00004000
public let LL_AHB5_GRP1_PERIPH_SDMMC1: UInt32 = 0x00000100
public let LL_AHB5_GRP1_PERIPH_GFXMMU: UInt32 = 0x00080000
public let LL_AHB5_GRP1_PERIPH_GPU2D: UInt32 = 0x00100000
public let LL_AHB5_GRP1_PERIPH_FLASH: UInt32 = 0x00000004
public let LL_AHB5_GRP1_PERIPH_AXISRAM: UInt32 = 0x80000000
public let LL_AHB5_GRP1_PERIPH_DTCM1: UInt32 = 0x10000000
public let LL_AHB5_GRP1_PERIPH_DTCM2: UInt32 = 0x20000000
public let LL_AHB5_GRP1_PERIPH_ITCM: UInt32 = 0x40000000
public let LL_APB1_GRP1_PERIPH_TIM2: UInt32 = 0x00000001
public let LL_APB1_GRP1_PERIPH_TIM3: UInt32 = 0x00000002
public let LL_APB1_GRP1_PERIPH_TIM4: UInt32 = 0x00000004
public let LL_APB1_GRP1_PERIPH_TIM5: UInt32 = 0x00000008
public let LL_APB1_GRP1_PERIPH_TIM6: UInt32 = 0x00000010
public let LL_APB1_GRP1_PERIPH_TIM7: UInt32 = 0x00000020
public let LL_APB1_GRP1_PERIPH_TIM12: UInt32 = 0x00000040
public let LL_APB1_GRP1_PERIPH_TIM13: UInt32 = 0x00000080
public let LL_APB1_GRP1_PERIPH_TIM14: UInt32 = 0x00000100
public let LL_APB1_GRP1_PERIPH_LPTIM1: UInt32 = 0x00000200
public let LL_APB1_GRP1_PERIPH_WWDG: UInt32 = 0x00000800
public let LL_APB1_GRP1_PERIPH_SPI2: UInt32 = 0x00004000
public let LL_APB1_GRP1_PERIPH_SPI3: UInt32 = 0x00008000
public let LL_APB1_GRP1_PERIPH_SPDIFRX: UInt32 = 0x00010000
public let LL_APB1_GRP1_PERIPH_USART2: UInt32 = 0x00020000
public let LL_APB1_GRP1_PERIPH_USART3: UInt32 = 0x00040000
public let LL_APB1_GRP1_PERIPH_UART4: UInt32 = 0x00080000
public let LL_APB1_GRP1_PERIPH_UART5: UInt32 = 0x00100000
public let LL_APB1_GRP1_PERIPH_I2C1: UInt32 = 0x00200000
public let LL_APB1_GRP1_PERIPH_I2C2: UInt32 = 0x00400000
public let LL_APB1_GRP1_PERIPH_I2C3: UInt32 = 0x00800000
public let LL_APB1_GRP1_PERIPH_I3C1: UInt32 = 0x00200000
public let LL_APB1_GRP1_PERIPH_CEC: UInt32 = 0x08000000
public let LL_APB1_GRP1_PERIPH_UART7: UInt32 = 0x40000000
public let LL_APB1_GRP1_PERIPH_UART8: UInt32 = 0x80000000
public let LL_APB1_GRP2_PERIPH_CRS: UInt32 = 0x00000002
public let LL_APB1_GRP2_PERIPH_MDIOS: UInt32 = 0x00000020
public let LL_APB1_GRP2_PERIPH_FDCAN: UInt32 = 0x00000100
public let LL_APB1_GRP2_PERIPH_UCPD1: UInt32 = 0x08000000
public let LL_APB2_GRP1_PERIPH_TIM1: UInt32 = 0x00000001
public let LL_APB2_GRP1_PERIPH_USART1: UInt32 = 0x00000010
public let LL_APB2_GRP1_PERIPH_SPI1: UInt32 = 0x00001000
public let LL_APB2_GRP1_PERIPH_SPI4: UInt32 = 0x00002000
public let LL_APB2_GRP1_PERIPH_TIM15: UInt32 = 0x00010000
public let LL_APB2_GRP1_PERIPH_TIM16: UInt32 = 0x00020000
public let LL_APB2_GRP1_PERIPH_TIM17: UInt32 = 0x00040000
public let LL_APB2_GRP1_PERIPH_TIM9: UInt32 = 0x00080000
public let LL_APB2_GRP1_PERIPH_SPI5: UInt32 = 0x00100000
public let LL_APB2_GRP1_PERIPH_SAI1: UInt32 = 0x00400000
public let LL_APB2_GRP1_PERIPH_SAI2: UInt32 = 0x00800000
public let LL_APB4_GRP1_PERIPH_SBS: UInt32 = 0x00000002
public let LL_APB4_GRP1_PERIPH_LPUART1: UInt32 = 0x00000008
public let LL_APB4_GRP1_PERIPH_SPI6: UInt32 = 0x00000020
public let LL_APB4_GRP1_PERIPH_LPTIM2: UInt32 = 0x00000200
public let LL_APB4_GRP1_PERIPH_LPTIM3: UInt32 = 0x00000400
public let LL_APB4_GRP1_PERIPH_LPTIM4: UInt32 = 0x00000800
public let LL_APB4_GRP1_PERIPH_LPTIM5: UInt32 = 0x00001000
public let LL_APB4_GRP1_PERIPH_VREF: UInt32 = 0x00008000
public let LL_APB4_GRP1_PERIPH_RTCAPB: UInt32 = 0x00010000
public let LL_APB4_GRP1_PERIPH_DTS: UInt32 = 0x04000000
public let LL_APB5_GRP1_PERIPH_LTDC: UInt32 = 0x00000002
public let LL_APB5_GRP1_PERIPH_DCMIPP: UInt32 = 0x00000004
public let LL_APB5_GRP1_PERIPH_GFXTIM: UInt32 = 0x00000010
public let LL_CKGA_PERIPH_AXI: UInt32 = 0x00000001
public let LL_CKGA_PERIPH_AHBM: UInt32 = 0x00000002
public let LL_CKGA_PERIPH_SDMMC1: UInt32 = 0x00000004
public let LL_CKGA_PERIPH_HPDMA1: UInt32 = 0x00000008
public let LL_CKGA_PERIPH_CPU: UInt32 = 0x00000010
public let LL_CKGA_PERIPH_GPU2DS1: UInt32 = 0x00000040
public let LL_CKGA_PERIPH_GPU2DS0: UInt32 = 0x00000020
public let LL_CKGA_PERIPH_GPU2DCL: UInt32 = 0x00000080
public let LL_CKGA_PERIPH_DCMIPP: UInt32 = 0x00000100
public let LL_CKGA_PERIPH_DMA2D: UInt32 = 0x00000200
public let LL_CKGA_PERIPH_GFXMMUS: UInt32 = 0x00000400
public let LL_CKGA_PERIPH_LTDC: UInt32 = 0x00000800
public let LL_CKGA_PERIPH_GFXMMUM: UInt32 = 0x00001000
public let LL_CKGA_PERIPH_AHBS: UInt32 = 0x00002000
public let LL_CKGA_PERIPH_FMC: UInt32 = 0x00004000
public let LL_CKGA_PERIPH_XSPI1: UInt32 = 0x00008000
public let LL_CKGA_PERIPH_XSPI2: UInt32 = 0x00010000
public let LL_CKGA_PERIPH_AXIRAM1: UInt32 = 0x00100000
public let LL_CKGA_PERIPH_AXIRAM2: UInt32 = 0x00080000
public let LL_CKGA_PERIPH_AXIRAM3: UInt32 = 0x00040000
public let LL_CKGA_PERIPH_AXIRAM4: UInt32 = 0x00020000
public let LL_CKGA_PERIPH_FLASH: UInt32 = 0x00200000
public let LL_CKGA_PERIPH_EXTI: UInt32 = 0x40000000
public let LL_CKGA_PERIPH_JTAG: UInt32 = 0x80000000

public func LL_AHB1_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb1enr, value: registers.read(.ahb1enr) | (Periphs))
    _ = (registers.read(.ahb1enr) & (Periphs))
}

public func LL_AHB1_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.ahb1enr) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_AHB1_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb1enr, value: registers.read(.ahb1enr) & ~(Periphs))
}

public func LL_AHB1_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb1rstr, value: registers.read(.ahb1rstr) | (Periphs))
}

public func LL_AHB1_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb1rstr, value: registers.read(.ahb1rstr) & ~(Periphs))
}

public func LL_AHB1_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb1lpenr, value: registers.read(.ahb1lpenr) | (Periphs))
    _ = (registers.read(.ahb1lpenr) & (Periphs))
}

public func LL_AHB1_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb1lpenr, value: registers.read(.ahb1lpenr) & ~(Periphs))
}

public func LL_AHB2_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb2enr, value: registers.read(.ahb2enr) | (Periphs))
    _ = (registers.read(.ahb2enr) & (Periphs))
}

public func LL_AHB2_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.ahb2enr) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_AHB2_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb2enr, value: registers.read(.ahb2enr) & ~(Periphs))
}

public func LL_AHB2_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb2rstr, value: registers.read(.ahb2rstr) | (Periphs))
}

public func LL_AHB2_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb2rstr, value: registers.read(.ahb2rstr) & ~(Periphs))
}

public func LL_AHB2_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb2lpenr, value: registers.read(.ahb2lpenr) | (Periphs))
    _ = (registers.read(.ahb2lpenr) & (Periphs))
}

public func LL_AHB2_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb2lpenr, value: registers.read(.ahb2lpenr) & ~(Periphs))
}

public func LL_AHB3_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb3enr, value: registers.read(.ahb3enr) | (Periphs))
    _ = (registers.read(.ahb3enr) & (Periphs))
}

public func LL_AHB3_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.ahb3enr) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_AHB3_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb3enr, value: registers.read(.ahb3enr) & ~(Periphs))
}

public func LL_AHB3_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb3rstr, value: registers.read(.ahb3rstr) | (Periphs))
}

public func LL_AHB3_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb3rstr, value: registers.read(.ahb3rstr) & ~(Periphs))
}

public func LL_AHB3_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb3lpenr, value: registers.read(.ahb3lpenr) | (Periphs))
    _ = (registers.read(.ahb3lpenr) & (Periphs))
}

public func LL_AHB3_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb3lpenr, value: registers.read(.ahb3lpenr) & ~(Periphs))
}

public func LL_AHB4_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb4enr, value: registers.read(.ahb4enr) | (Periphs))
    _ = (registers.read(.ahb4enr) & (Periphs))
}

public func LL_AHB4_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.ahb4enr) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_AHB4_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb4enr, value: registers.read(.ahb4enr) & ~(Periphs))
}

public func LL_AHB4_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb4rstr, value: registers.read(.ahb4rstr) | (Periphs))
}

public func LL_AHB4_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb4rstr, value: registers.read(.ahb4rstr) & ~(Periphs))
}

public func LL_AHB4_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb4lpenr, value: registers.read(.ahb4lpenr) | (Periphs))
    _ = (registers.read(.ahb4lpenr) & (Periphs))
}

public func LL_AHB4_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb4lpenr, value: registers.read(.ahb4lpenr) & ~(Periphs))
}

public func LL_AHB5_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb5enr, value: registers.read(.ahb5enr) | (Periphs))
    _ = (registers.read(.ahb5enr) & (Periphs))
}

public func LL_AHB5_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.ahb5enr) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_AHB5_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb5enr, value: registers.read(.ahb5enr) & ~(Periphs))
}

public func LL_AHB5_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb5rstr, value: registers.read(.ahb5rstr) | (Periphs))
}

public func LL_AHB5_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb5rstr, value: registers.read(.ahb5rstr) & ~(Periphs))
}

public func LL_AHB5_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb5lpenr, value: registers.read(.ahb5lpenr) | (Periphs))
    _ = (registers.read(.ahb5lpenr) & (Periphs))
}

public func LL_AHB5_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ahb5lpenr, value: registers.read(.ahb5lpenr) & ~(Periphs))
}

public func LL_APB1_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1enr1, value: registers.read(.apb1enr1) | (Periphs))
    _ = (registers.read(.apb1enr1) & (Periphs))
}

public func LL_APB1_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.apb1enr1) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_APB1_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1enr1, value: registers.read(.apb1enr1) & ~(Periphs))
}

public func LL_APB1_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1rstr1, value: registers.read(.apb1rstr1) | (Periphs))
}

public func LL_APB1_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1rstr1, value: registers.read(.apb1rstr1) & ~(Periphs))
}

public func LL_APB1_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1lpenr1, value: registers.read(.apb1lpenr1) | (Periphs))
    _ = (registers.read(.apb1lpenr1) & (Periphs))
}

public func LL_APB1_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1lpenr1, value: registers.read(.apb1lpenr1) & ~(Periphs))
}

public func LL_APB1_GRP2_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1enr2, value: registers.read(.apb1enr2) | (Periphs))
    _ = (registers.read(.apb1enr2) & (Periphs))
}

public func LL_APB1_GRP2_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.apb1enr2) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_APB1_GRP2_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1enr2, value: registers.read(.apb1enr2) & ~(Periphs))
}

public func LL_APB1_GRP2_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1rstr2, value: registers.read(.apb1rstr2) | (Periphs))
}

public func LL_APB1_GRP2_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1rstr2, value: registers.read(.apb1rstr2) & ~(Periphs))
}

public func LL_APB1_GRP2_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1lpenr2, value: registers.read(.apb1lpenr2) | (Periphs))
    _ = (registers.read(.apb1lpenr2) & (Periphs))
}

public func LL_APB1_GRP2_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb1lpenr2, value: registers.read(.apb1lpenr2) & ~(Periphs))
}

public func LL_APB2_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb2enr, value: registers.read(.apb2enr) | (Periphs))
    _ = (registers.read(.apb2enr) & (Periphs))
}

public func LL_APB2_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.apb2enr) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_APB2_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb2enr, value: registers.read(.apb2enr) & ~(Periphs))
}

public func LL_APB2_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb2rstr, value: registers.read(.apb2rstr) | (Periphs))
}

public func LL_APB2_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb2rstr, value: registers.read(.apb2rstr) & ~(Periphs))
}

public func LL_APB2_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb2lpenr, value: registers.read(.apb2lpenr) | (Periphs))
    _ = (registers.read(.apb2lpenr) & (Periphs))
}

public func LL_APB2_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb2lpenr, value: registers.read(.apb2lpenr) & ~(Periphs))
}

public func LL_APB4_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb4enr, value: registers.read(.apb4enr) | (Periphs))
    _ = (registers.read(.apb4enr) & (Periphs))
}

public func LL_APB4_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.apb4enr) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_APB4_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb4enr, value: registers.read(.apb4enr) & ~(Periphs))
}

public func LL_APB4_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb4rstr, value: registers.read(.apb4rstr) | (Periphs))
}

public func LL_APB4_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb4rstr, value: registers.read(.apb4rstr) & ~(Periphs))
}

public func LL_APB4_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb4lpenr, value: registers.read(.apb4lpenr) | (Periphs))
    _ = (registers.read(.apb4lpenr) & (Periphs))
}

public func LL_APB4_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb4lpenr, value: registers.read(.apb4lpenr) & ~(Periphs))
}

public func LL_APB5_GRP1_EnableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb5enr, value: registers.read(.apb5enr) | (Periphs))
    _ = (registers.read(.apb5enr) & (Periphs))
}

public func LL_APB5_GRP1_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.apb5enr) & (Periphs)) == Periphs) ? 1 : 0)
}

public func LL_APB5_GRP1_DisableClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb5enr, value: registers.read(.apb5enr) & ~(Periphs))
}

public func LL_APB5_GRP1_ForceReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb5rstr, value: registers.read(.apb5rstr) | (Periphs))
}

public func LL_APB5_GRP1_ReleaseReset<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb5rstr, value: registers.read(.apb5rstr) & ~(Periphs))
}

public func LL_APB5_GRP1_EnableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb5lpenr, value: registers.read(.apb5lpenr) | (Periphs))
    _ = (registers.read(.apb5lpenr) & (Periphs))
}

public func LL_APB5_GRP1_DisableClockSleep<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.apb5lpenr, value: registers.read(.apb5lpenr) & ~(Periphs))
}

public func LL_CKGA_Enable<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ckgdisr, value: registers.read(.ckgdisr) & ~(Periphs))
}

public func LL_CKGA_IsEnabledClock<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) -> UInt32 {
    return (((registers.read(.ckgdisr) & (Periphs)) == 0) ? 1 : 0)
}

public func LL_CKGA_Disable<IO: LLBusRegisterIO>(_ registers: inout IO, _ Periphs: UInt32) {
    registers.write(.ckgdisr, value: registers.read(.ckgdisr) | (Periphs))
}
