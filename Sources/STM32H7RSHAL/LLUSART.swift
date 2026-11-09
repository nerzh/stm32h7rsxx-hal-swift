// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_USART_ICR_PECF: UInt32 = 0x0000_0001
public let LL_USART_ICR_FECF: UInt32 = 0x0000_0002
public let LL_USART_ICR_NECF: UInt32 = 0x0000_0004
public let LL_USART_ICR_ORECF: UInt32 = 0x0000_0008
public let LL_USART_ICR_IDLECF: UInt32 = 0x0000_0010
public let LL_USART_ICR_TXFECF: UInt32 = 0x0000_0020
public let LL_USART_ICR_TCCF: UInt32 = 0x0000_0040
public let LL_USART_ICR_TCBGTCF: UInt32 = 0x0000_0080
public let LL_USART_ICR_LBDCF: UInt32 = 0x0000_0100
public let LL_USART_ICR_CTSCF: UInt32 = 0x0000_0200
public let LL_USART_ICR_RTOCF: UInt32 = 0x0000_0800
public let LL_USART_ICR_EOBCF: UInt32 = 0x0000_1000
public let LL_USART_ICR_UDRCF: UInt32 = 0x0000_2000
public let LL_USART_ICR_CMCF: UInt32 = 0x0002_0000
public let LL_USART_ICR_WUCF: UInt32 = 0x0010_0000
public let LL_USART_ISR_PE: UInt32 = 0x0000_0001
public let LL_USART_ISR_FE: UInt32 = 0x0000_0002
public let LL_USART_ISR_NE: UInt32 = 0x0000_0004
public let LL_USART_ISR_ORE: UInt32 = 0x0000_0008
public let LL_USART_ISR_IDLE: UInt32 = 0x0000_0010
public let LL_USART_ISR_RXNE_RXFNE: UInt32 = 0x0000_0020
public let LL_USART_ISR_TC: UInt32 = 0x0000_0040
public let LL_USART_ISR_TXE_TXFNF: UInt32 = 0x0000_0080
public let LL_USART_ISR_LBDF: UInt32 = 0x0000_0100
public let LL_USART_ISR_CTSIF: UInt32 = 0x0000_0200
public let LL_USART_ISR_CTS: UInt32 = 0x0000_0400
public let LL_USART_ISR_RTOF: UInt32 = 0x0000_0800
public let LL_USART_ISR_EOBF: UInt32 = 0x0000_1000
public let LL_USART_ISR_UDR: UInt32 = 0x0000_2000
public let LL_USART_ISR_ABRE: UInt32 = 0x0000_4000
public let LL_USART_ISR_ABRF: UInt32 = 0x0000_8000
public let LL_USART_ISR_BUSY: UInt32 = 0x0001_0000
public let LL_USART_ISR_CMF: UInt32 = 0x0002_0000
public let LL_USART_ISR_SBKF: UInt32 = 0x0004_0000
public let LL_USART_ISR_RWU: UInt32 = 0x0008_0000
public let LL_USART_ISR_WUF: UInt32 = 0x0010_0000
public let LL_USART_ISR_TEACK: UInt32 = 0x0020_0000
public let LL_USART_ISR_REACK: UInt32 = 0x0040_0000
public let LL_USART_ISR_TXFE: UInt32 = 0x0080_0000
public let LL_USART_ISR_RXFF: UInt32 = 0x0100_0000
public let LL_USART_ISR_TCBGT: UInt32 = 0x0200_0000
public let LL_USART_ISR_RXFT: UInt32 = 0x0400_0000
public let LL_USART_ISR_TXFT: UInt32 = 0x0800_0000
public let LL_USART_CR1_IDLEIE: UInt32 = 0x0000_0010
public let LL_USART_CR1_RXNEIE_RXFNEIE: UInt32 = 0x0000_0020
public let LL_USART_CR1_TCIE: UInt32 = 0x0000_0040
public let LL_USART_CR1_TXEIE_TXFNFIE: UInt32 = 0x0000_0080
public let LL_USART_CR1_PEIE: UInt32 = 0x0000_0100
public let LL_USART_CR1_CMIE: UInt32 = 0x0000_4000
public let LL_USART_CR1_RTOIE: UInt32 = 0x0400_0000
public let LL_USART_CR1_EOBIE: UInt32 = 0x0800_0000
public let LL_USART_CR1_TXFEIE: UInt32 = 0x4000_0000
public let LL_USART_CR1_RXFFIE: UInt32 = 0x8000_0000
public let LL_USART_CR2_LBDIE: UInt32 = 0x0000_0040
public let LL_USART_CR3_EIE: UInt32 = 0x0000_0001
public let LL_USART_CR3_CTSIE: UInt32 = 0x0000_0400
public let LL_USART_CR3_WUFIE: UInt32 = 0x0040_0000
public let LL_USART_CR3_TXFTIE: UInt32 = 0x0080_0000
public let LL_USART_CR3_TCBGTIE: UInt32 = 0x0100_0000
public let LL_USART_CR3_RXFTIE: UInt32 = 0x1000_0000
public let LL_USART_FIFOTHRESHOLD_1_8: UInt32 = 0x0000_0000
public let LL_USART_FIFOTHRESHOLD_1_4: UInt32 = 0x0000_0001
public let LL_USART_FIFOTHRESHOLD_1_2: UInt32 = 0x0000_0002
public let LL_USART_FIFOTHRESHOLD_3_4: UInt32 = 0x0000_0003
public let LL_USART_FIFOTHRESHOLD_7_8: UInt32 = 0x0000_0004
public let LL_USART_FIFOTHRESHOLD_8_8: UInt32 = 0x0000_0005
public let LL_USART_DIRECTION_NONE: UInt32 = 0x0000_0000
public let LL_USART_DIRECTION_RX: UInt32 = 0x0000_0004
public let LL_USART_DIRECTION_TX: UInt32 = 0x0000_0008
public let LL_USART_DIRECTION_TX_RX: UInt32 = 0x0000_000C
public let LL_USART_PARITY_NONE: UInt32 = 0x0000_0000
public let LL_USART_PARITY_EVEN: UInt32 = 0x0000_0400
public let LL_USART_PARITY_ODD: UInt32 = 0x0000_0600
public let LL_USART_WAKEUP_IDLELINE: UInt32 = 0x0000_0000
public let LL_USART_WAKEUP_ADDRESSMARK: UInt32 = 0x0000_0800
public let LL_USART_DATAWIDTH_7B: UInt32 = 0x1000_0000
public let LL_USART_DATAWIDTH_8B: UInt32 = 0x0000_0000
public let LL_USART_DATAWIDTH_9B: UInt32 = 0x0000_1000
public let LL_USART_OVERSAMPLING_16: UInt32 = 0x0000_0000
public let LL_USART_OVERSAMPLING_8: UInt32 = 0x0000_8000
public let LL_USART_CLOCK_DISABLE: UInt32 = 0x0000_0000
public let LL_USART_CLOCK_ENABLE: UInt32 = 0x0000_0800
public let LL_USART_LASTCLKPULSE_NO_OUTPUT: UInt32 = 0x0000_0000
public let LL_USART_LASTCLKPULSE_OUTPUT: UInt32 = 0x0000_0100
public let LL_USART_PHASE_1EDGE: UInt32 = 0x0000_0000
public let LL_USART_PHASE_2EDGE: UInt32 = 0x0000_0200
public let LL_USART_POLARITY_LOW: UInt32 = 0x0000_0000
public let LL_USART_POLARITY_HIGH: UInt32 = 0x0000_0400
public let LL_USART_PRESCALER_DIV1: UInt32 = 0x0000_0000
public let LL_USART_PRESCALER_DIV2: UInt32 = 0x0000_0001
public let LL_USART_PRESCALER_DIV4: UInt32 = 0x0000_0002
public let LL_USART_PRESCALER_DIV6: UInt32 = 0x0000_0003
public let LL_USART_PRESCALER_DIV8: UInt32 = 0x0000_0004
public let LL_USART_PRESCALER_DIV10: UInt32 = 0x0000_0005
public let LL_USART_PRESCALER_DIV12: UInt32 = 0x0000_0006
public let LL_USART_PRESCALER_DIV16: UInt32 = 0x0000_0007
public let LL_USART_PRESCALER_DIV32: UInt32 = 0x0000_0008
public let LL_USART_PRESCALER_DIV64: UInt32 = 0x0000_0009
public let LL_USART_PRESCALER_DIV128: UInt32 = 0x0000_000A
public let LL_USART_PRESCALER_DIV256: UInt32 = 0x0000_000B
public let LL_USART_STOPBITS_0_5: UInt32 = 0x0000_1000
public let LL_USART_STOPBITS_1: UInt32 = 0x0000_0000
public let LL_USART_STOPBITS_1_5: UInt32 = 0x0000_3000
public let LL_USART_STOPBITS_2: UInt32 = 0x0000_2000
public let LL_USART_TXRX_STANDARD: UInt32 = 0x0000_0000
public let LL_USART_TXRX_SWAPPED: UInt32 = 0x0000_8000
public let LL_USART_RXPIN_LEVEL_STANDARD: UInt32 = 0x0000_0000
public let LL_USART_RXPIN_LEVEL_INVERTED: UInt32 = 0x0001_0000
public let LL_USART_TXPIN_LEVEL_STANDARD: UInt32 = 0x0000_0000
public let LL_USART_TXPIN_LEVEL_INVERTED: UInt32 = 0x0002_0000
public let LL_USART_BINARY_LOGIC_POSITIVE: UInt32 = 0x0000_0000
public let LL_USART_BINARY_LOGIC_NEGATIVE: UInt32 = 0x0004_0000
public let LL_USART_BITORDER_LSBFIRST: UInt32 = 0x0000_0000
public let LL_USART_BITORDER_MSBFIRST: UInt32 = 0x0008_0000
public let LL_USART_AUTOBAUD_DETECT_ON_STARTBIT: UInt32 = 0x0000_0000
public let LL_USART_AUTOBAUD_DETECT_ON_FALLINGEDGE: UInt32 = 0x0020_0000
public let LL_USART_AUTOBAUD_DETECT_ON_7F_FRAME: UInt32 = 0x0040_0000
public let LL_USART_AUTOBAUD_DETECT_ON_55_FRAME: UInt32 = 0x0060_0000
public let LL_USART_ADDRESS_DETECT_4B: UInt32 = 0x0000_0000
public let LL_USART_ADDRESS_DETECT_7B: UInt32 = 0x0000_0010
public let LL_USART_HWCONTROL_NONE: UInt32 = 0x0000_0000
public let LL_USART_HWCONTROL_RTS: UInt32 = 0x0000_0100
public let LL_USART_HWCONTROL_CTS: UInt32 = 0x0000_0200
public let LL_USART_HWCONTROL_RTS_CTS: UInt32 = 0x0000_0300
public let LL_USART_WAKEUP_ON_ADDRESS: UInt32 = 0x0000_0000
public let LL_USART_WAKEUP_ON_STARTBIT: UInt32 = 0x0020_0000
public let LL_USART_WAKEUP_ON_RXNE: UInt32 = 0x0030_0000
public let LL_USART_IRDA_POWER_NORMAL: UInt32 = 0x0000_0000
public let LL_USART_IRDA_POWER_LOW: UInt32 = 0x0000_0004
public let LL_USART_LINBREAK_DETECT_10B: UInt32 = 0x0000_0000
public let LL_USART_LINBREAK_DETECT_11B: UInt32 = 0x0000_0020
public let LL_USART_DE_POLARITY_HIGH: UInt32 = 0x0000_0000
public let LL_USART_DE_POLARITY_LOW: UInt32 = 0x0000_8000
public let LL_USART_DMA_REG_DATA_TRANSMIT: UInt32 = 0x0000_0000
public let LL_USART_DMA_REG_DATA_RECEIVE: UInt32 = 0x0000_0001

public func LL_USART_Enable<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr1, value: registers.read(UARTRegister.cr1) | (0x1))
}

public func LL_USART_Disable<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr1, value: registers.read(UARTRegister.cr1) & ~(0x1))
}

public func LL_USART_IsEnabled<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_USART_EnableFIFO<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr1, value: registers.read(UARTRegister.cr1) | (0x2000_0000))
}

public func LL_USART_DisableFIFO<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr1, value: registers.read(UARTRegister.cr1) & ~(0x2000_0000))
}

public func LL_USART_IsEnabledFIFO<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x2000_0000)) == (0x2000_0000)) ? 1 : 0)
}

public func LL_USART_SetTXFIFOThreshold<IO: UARTRegisterIO>(_ registers: IO, _ Threshold: UInt32) {
    registers.atomicModify(UARTRegister.cr3, clear: 0xe000_0000, set: Threshold << 0x1d)
}

public func LL_USART_GetTXFIFOThreshold<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0xe000_0000)) >> 0x1d)
}

public func LL_USART_SetRXFIFOThreshold<IO: UARTRegisterIO>(_ registers: IO, _ Threshold: UInt32) {
    registers.atomicModify(UARTRegister.cr3, clear: 0xe000000, set: Threshold << 0x19)
}

public func LL_USART_GetRXFIFOThreshold<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0xe000000)) >> 0x19)
}

public func LL_USART_ConfigFIFOsThreshold<IO: UARTRegisterIO>(
    _ registers: IO, _ TXThreshold: UInt32, _ RXThreshold: UInt32
) {
    registers.atomicModify(
        UARTRegister.cr3, clear: 0xe000_0000 | 0xe000000, set: (TXThreshold << 0x1d) | (RXThreshold << 0x19))
}

public func LL_USART_EnableInStopMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x2)
}

public func LL_USART_DisableInStopMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x2, set: 0)
}

public func LL_USART_IsEnabledInStopMode<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_USART_EnableDirectionRx<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x4)
}

public func LL_USART_DisableDirectionRx<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4, set: 0)
}

public func LL_USART_EnableDirectionTx<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x8)
}

public func LL_USART_DisableDirectionTx<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x8, set: 0)
}

public func LL_USART_SetTransferDirection<IO: UARTRegisterIO>(_ registers: IO, _ TransferDirection: UInt32) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4 | 0x8, set: TransferDirection)
}

public func LL_USART_GetTransferDirection<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x4 | 0x8)))
}

public func LL_USART_SetParity<IO: UARTRegisterIO>(_ registers: IO, _ Parity: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x200 | 0x400)) | (Parity))
}

public func LL_USART_GetParity<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x200 | 0x400)))
}

public func LL_USART_SetWakeUpMethod<IO: UARTRegisterIO>(_ registers: IO, _ Method: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x800)) | (Method))
}

public func LL_USART_GetWakeUpMethod<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x800)))
}

public func LL_USART_SetDataWidth<IO: UARTRegisterIO>(_ registers: IO, _ DataWidth: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x1000_1000)) | (DataWidth))
}

public func LL_USART_GetDataWidth<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x1000_1000)))
}

public func LL_USART_EnableMuteMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x2000)
}

public func LL_USART_DisableMuteMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x2000, set: 0)
}

public func LL_USART_IsEnabledMuteMode<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_USART_SetOverSampling<IO: UARTRegisterIO>(_ registers: IO, _ OverSampling: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x8000)) | (OverSampling))
}

public func LL_USART_GetOverSampling<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x8000)))
}

public func LL_USART_SetLastClkPulseOutput<IO: UARTRegisterIO>(_ registers: IO, _ LastBitClockPulse: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x100)) | (LastBitClockPulse))
}

public func LL_USART_GetLastClkPulseOutput<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x100)))
}

public func LL_USART_SetClockPhase<IO: UARTRegisterIO>(_ registers: IO, _ ClockPhase: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x200)) | (ClockPhase))
}

public func LL_USART_GetClockPhase<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x200)))
}

public func LL_USART_SetClockPolarity<IO: UARTRegisterIO>(_ registers: IO, _ ClockPolarity: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x400)) | (ClockPolarity))
}

public func LL_USART_GetClockPolarity<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x400)))
}

public func LL_USART_ConfigClock<IO: UARTRegisterIO>(
    _ registers: IO, _ Phase: UInt32, _ Polarity: UInt32, _ LBCPOutput: UInt32
) {
    registers.write(
        UARTRegister.cr2,
        value: (registers.read(UARTRegister.cr2) & ~(0x200 | 0x400 | 0x100)) | (Phase | Polarity | LBCPOutput))
}

public func LL_USART_SetPrescaler<IO: UARTRegisterIO>(_ registers: IO, _ PrescalerValue: UInt32) {
    registers.write(
        UARTRegister.presc,
        value: (registers.read(UARTRegister.presc) & ~(0xf)) | UInt32(UInt16(truncatingIfNeeded: PrescalerValue)))
}

public func LL_USART_GetPrescaler<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.presc) & (0xf)))
}

public func LL_USART_EnableSCLKOutput<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x800))
}

public func LL_USART_DisableSCLKOutput<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~(0x800))
}

public func LL_USART_IsEnabledSCLKOutput<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr2) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_USART_SetStopBitsLength<IO: UARTRegisterIO>(_ registers: IO, _ StopBits: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x3000)) | (StopBits))
}

public func LL_USART_GetStopBitsLength<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x3000)))
}

public func LL_USART_ConfigCharacter<IO: UARTRegisterIO>(
    _ registers: IO, _ DataWidth: UInt32, _ Parity: UInt32, _ StopBits: UInt32
) {
    registers.write(
        UARTRegister.cr1,
        value: (registers.read(UARTRegister.cr1) & ~(0x200 | 0x400 | 0x1000_1000)) | (Parity | DataWidth))
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x3000)) | (StopBits))
}

public func LL_USART_SetTXRXSwap<IO: UARTRegisterIO>(_ registers: IO, _ SwapConfig: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x8000)) | (SwapConfig))
}

public func LL_USART_GetTXRXSwap<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x8000)))
}

public func LL_USART_SetRXPinLevel<IO: UARTRegisterIO>(_ registers: IO, _ PinInvMethod: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x10000)) | (PinInvMethod))
}

public func LL_USART_GetRXPinLevel<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x10000)))
}

public func LL_USART_SetTXPinLevel<IO: UARTRegisterIO>(_ registers: IO, _ PinInvMethod: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x20000)) | (PinInvMethod))
}

public func LL_USART_GetTXPinLevel<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x20000)))
}

public func LL_USART_SetBinaryDataLogic<IO: UARTRegisterIO>(_ registers: IO, _ DataLogic: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x40000)) | (DataLogic))
}

public func LL_USART_GetBinaryDataLogic<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x40000)))
}

public func LL_USART_SetTransferBitOrder<IO: UARTRegisterIO>(_ registers: IO, _ BitOrder: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x80000)) | (BitOrder))
}

public func LL_USART_GetTransferBitOrder<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x80000)))
}

public func LL_USART_EnableAutoBaudRate<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x100000))
}

public func LL_USART_DisableAutoBaudRate<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~(0x100000))
}

public func LL_USART_IsEnabledAutoBaud<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr2) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_USART_SetAutoBaudRateMode<IO: UARTRegisterIO>(_ registers: IO, _ AutoBaudRateMode: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x600000)) | (AutoBaudRateMode))
}

public func LL_USART_GetAutoBaudRateMode<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x600000)))
}

public func LL_USART_EnableRxTimeout<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x800000))
}

public func LL_USART_DisableRxTimeout<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~(0x800000))
}

public func LL_USART_IsEnabledRxTimeout<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr2) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_USART_ConfigNodeAddress<IO: UARTRegisterIO>(_ registers: IO, _ AddressLen: UInt32, _ NodeAddress: UInt32)
{
    registers.write(
        UARTRegister.cr2,
        value: (registers.read(UARTRegister.cr2) & ~(0xff00_0000 | 0x10)) | ((AddressLen | (NodeAddress << 0x18))))
}

public func LL_USART_GetNodeAddress<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0xff00_0000)) >> 0x18)
}

public func LL_USART_GetNodeAddressLen<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x10)))
}

public func LL_USART_EnableRTSHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x100))
}

public func LL_USART_DisableRTSHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x100))
}

public func LL_USART_EnableCTSHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x200))
}

public func LL_USART_DisableCTSHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x200))
}

public func LL_USART_SetHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO, _ HardwareFlowControl: UInt32) {
    registers.write(
        UARTRegister.cr3, value: (registers.read(UARTRegister.cr3) & ~(0x100 | 0x200)) | (HardwareFlowControl))
}

public func LL_USART_GetHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0x100 | 0x200)))
}

public func LL_USART_EnableOneBitSamp<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x800))
}

public func LL_USART_DisableOneBitSamp<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x800))
}

public func LL_USART_IsEnabledOneBitSamp<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_USART_EnableOverrunDetect<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x1000))
}

public func LL_USART_DisableOverrunDetect<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x1000))
}

public func LL_USART_IsEnabledOverrunDetect<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x1000)) != 0x1000) ? 1 : 0)
}

public func LL_USART_SetWKUPType<IO: UARTRegisterIO>(_ registers: IO, _ Type: UInt32) {
    registers.write(UARTRegister.cr3, value: (registers.read(UARTRegister.cr3) & ~(0x300000)) | (Type))
}

public func LL_USART_GetWKUPType<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0x300000)))
}

public func LL_USART_SetBaudRate<IO: UARTRegisterIO>(
    _ registers: IO, _ PeriphClk: UInt32, _ PrescalerValue: UInt32, _ OverSampling: UInt32, _ BaudRate: UInt32
) {
    if PrescalerValue > LL_USART_PRESCALER_DIV256 { return }
    if BaudRate == 0 { return }
    if OverSampling == LL_USART_OVERSAMPLING_8 {
        let usartdiv = UInt32(
            UInt16(
                truncatingIfNeeded: __LL_USART_DIV_SAMPLING8(
                    PeriphClk, UInt32(UInt8(truncatingIfNeeded: PrescalerValue)), BaudRate)))
        var brrtemp = usartdiv & 0xFFF0
        brrtemp |= UInt32(UInt16(truncatingIfNeeded: (usartdiv & 0x000F) >> 1))
        registers.write(.brr, value: brrtemp)
    } else {
        registers.write(
            .brr,
            value: UInt32(
                UInt16(
                    truncatingIfNeeded: __LL_USART_DIV_SAMPLING16(
                        PeriphClk, UInt32(UInt8(truncatingIfNeeded: PrescalerValue)), BaudRate))))
    }
}

public func LL_USART_GetBaudRate<IO: UARTRegisterIO>(
    _ registers: IO, _ PeriphClk: UInt32, _ PrescalerValue: UInt32, _ OverSampling: UInt32
) -> UInt32 {
    let periphclkpresc = PeriphClk / _llSerialPrescaler(UInt32(UInt8(truncatingIfNeeded: PrescalerValue)))
    var usartdiv = registers.read(.brr)
    var brrresult: UInt32 = 0
    if usartdiv == 0 {
    } else if OverSampling == LL_USART_OVERSAMPLING_8 {
        usartdiv = UInt32(UInt16(truncatingIfNeeded: (usartdiv & 0xFFF0) | ((usartdiv & 0x0007) << 1)))
        if usartdiv != 0 { brrresult = (periphclkpresc &* 2) / usartdiv }
    } else {
        if usartdiv & 0xFFFF != 0 { brrresult = periphclkpresc / usartdiv }
    }
    return brrresult
}

public func LL_USART_SetRxTimeout<IO: UARTRegisterIO>(_ registers: IO, _ Timeout: UInt32) {
    registers.write(UARTRegister.rtor, value: (registers.read(UARTRegister.rtor) & ~(0xffffff)) | (Timeout))
}

public func LL_USART_GetRxTimeout<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.rtor) & (0xffffff)))
}

public func LL_USART_SetBlockLength<IO: UARTRegisterIO>(_ registers: IO, _ BlockLength: UInt32) {
    registers.write(
        UARTRegister.rtor, value: (registers.read(UARTRegister.rtor) & ~(0xff00_0000)) | (BlockLength << 0x18))
}

public func LL_USART_GetBlockLength<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.rtor) & (0xff00_0000)) >> 0x18)
}

public func LL_USART_EnableIrda<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x2))
}

public func LL_USART_DisableIrda<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x2))
}

public func LL_USART_IsEnabledIrda<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_USART_SetIrdaPowerMode<IO: UARTRegisterIO>(_ registers: IO, _ PowerMode: UInt32) {
    registers.write(UARTRegister.cr3, value: (registers.read(UARTRegister.cr3) & ~(0x4)) | (PowerMode))
}

public func LL_USART_GetIrdaPowerMode<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0x4)))
}

public func LL_USART_SetIrdaPrescaler<IO: UARTRegisterIO>(_ registers: IO, _ PrescalerValue: UInt32) {
    registers.write(
        UARTRegister.gtpr,
        value: (registers.read(UARTRegister.gtpr) & ~(0xff)) | UInt32(UInt16(truncatingIfNeeded: PrescalerValue)))
}

public func LL_USART_GetIrdaPrescaler<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.gtpr) & (0xff)))
}

public func LL_USART_EnableSmartcardNACK<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x10))
}

public func LL_USART_DisableSmartcardNACK<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x10))
}

public func LL_USART_IsEnabledSmartcardNACK<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_USART_EnableSmartcard<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x20))
}

public func LL_USART_DisableSmartcard<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x20))
}

public func LL_USART_IsEnabledSmartcard<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_USART_SetSmartcardAutoRetryCount<IO: UARTRegisterIO>(_ registers: IO, _ AutoRetryCount: UInt32) {
    registers.write(UARTRegister.cr3, value: (registers.read(UARTRegister.cr3) & ~(0xe0000)) | (AutoRetryCount << 0x11))
}

public func LL_USART_GetSmartcardAutoRetryCount<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0xe0000)) >> 0x11)
}

public func LL_USART_SetSmartcardPrescaler<IO: UARTRegisterIO>(_ registers: IO, _ PrescalerValue: UInt32) {
    registers.write(
        UARTRegister.gtpr,
        value: (registers.read(UARTRegister.gtpr) & ~(0xff)) | UInt32(UInt16(truncatingIfNeeded: PrescalerValue)))
}

public func LL_USART_GetSmartcardPrescaler<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.gtpr) & (0xff)))
}

public func LL_USART_SetSmartcardGuardTime<IO: UARTRegisterIO>(_ registers: IO, _ GuardTime: UInt32) {
    registers.write(
        UARTRegister.gtpr,
        value: (registers.read(UARTRegister.gtpr) & ~(0xff00)) | (UInt32(UInt16(truncatingIfNeeded: GuardTime << 0x8))))
}

public func LL_USART_GetSmartcardGuardTime<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.gtpr) & (0xff00)) >> 0x8)
}

public func LL_USART_EnableHalfDuplex<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x8))
}

public func LL_USART_DisableHalfDuplex<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x8))
}

public func LL_USART_IsEnabledHalfDuplex<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_USART_EnableSPISlave<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x1))
}

public func LL_USART_DisableSPISlave<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~(0x1))
}

public func LL_USART_IsEnabledSPISlave<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr2) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_USART_EnableSPISlaveSelect<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~(0x8))
}

public func LL_USART_DisableSPISlaveSelect<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x8))
}

public func LL_USART_IsEnabledSPISlaveSelect<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr2) & (0x8)) != (0x8)) ? 1 : 0)
}

public func LL_USART_SetLINBrkDetectionLen<IO: UARTRegisterIO>(_ registers: IO, _ LINBDLength: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x20)) | (LINBDLength))
}

public func LL_USART_GetLINBrkDetectionLen<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x20)))
}

public func LL_USART_EnableLIN<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x4000))
}

public func LL_USART_DisableLIN<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~(0x4000))
}

public func LL_USART_IsEnabledLIN<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr2) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_USART_SetDEDeassertionTime<IO: UARTRegisterIO>(_ registers: IO, _ Time: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x1f0000)) | (Time << 0x10))
}

public func LL_USART_GetDEDeassertionTime<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x1f0000)) >> 0x10)
}

public func LL_USART_SetDEAssertionTime<IO: UARTRegisterIO>(_ registers: IO, _ Time: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x3e00000)) | (Time << 0x15))
}

public func LL_USART_GetDEAssertionTime<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x3e00000)) >> 0x15)
}

public func LL_USART_EnableDEMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x4000))
}

public func LL_USART_DisableDEMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x4000))
}

public func LL_USART_IsEnabledDEMode<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_USART_SetDESignalPolarity<IO: UARTRegisterIO>(_ registers: IO, _ Polarity: UInt32) {
    registers.write(UARTRegister.cr3, value: (registers.read(UARTRegister.cr3) & ~(0x8000)) | (Polarity))
}

public func LL_USART_GetDESignalPolarity<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0x8000)))
}

public func LL_USART_ConfigAsyncMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~((0x4000 | 0x800)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~((0x20 | 0x2 | 0x8)))
}

public func LL_USART_ConfigSyncMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~((0x4000)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~((0x20 | 0x2 | 0x8)))
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x800))
}

public func LL_USART_ConfigLINMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~((0x800 | 0x3000)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~((0x2 | 0x20 | 0x8)))
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x4000))
}

public func LL_USART_ConfigHalfDuplexMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~((0x4000 | 0x800)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~((0x20 | 0x2)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x8))
}

public func LL_USART_ConfigSmartcardMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~((0x4000)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~((0x2 | 0x8)))

    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | ((0x1000 | 0x2000 | 0x800)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x20))
}

public func LL_USART_ConfigIrdaMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~((0x4000 | 0x800 | 0x3000)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~((0x20 | 0x8)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x2))
}

public func LL_USART_ConfigMultiProcessMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~((0x4000 | 0x800)))
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~((0x20 | 0x8 | 0x2)))
}

public func LL_USART_IsActiveFlag_PE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_FE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_NE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_ORE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_IDLE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_RXNE_RXFNE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_TC<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_TXE_TXFNF<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_LBD<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_nCTS<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_CTS<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_RTO<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_EOB<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_UDR<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_ABRE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_ABR<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_BUSY<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_CM<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_SBK<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_RWU<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_WKUP<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_TEACK<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_REACK<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_TXFE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_RXFF<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_TCBGT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x2000000)) == (0x2000000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_TXFT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x8000000)) == (0x8000000)) ? 1 : 0)
}

public func LL_USART_IsActiveFlag_RXFT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_USART_ClearFlag_PE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x1)
}

public func LL_USART_ClearFlag_FE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x2)
}

public func LL_USART_ClearFlag_NE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x4)
}

public func LL_USART_ClearFlag_ORE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x8)
}

public func LL_USART_ClearFlag_IDLE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x10)
}

public func LL_USART_ClearFlag_TXFE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x20)
}

public func LL_USART_ClearFlag_TC<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x40)
}

public func LL_USART_ClearFlag_TCBGT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x80)
}

public func LL_USART_ClearFlag_LBD<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x100)
}

public func LL_USART_ClearFlag_nCTS<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x200)
}

public func LL_USART_ClearFlag_RTO<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x800)
}

public func LL_USART_ClearFlag_EOB<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x1000)
}

public func LL_USART_ClearFlag_UDR<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x2000)
}

public func LL_USART_ClearFlag_CM<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x20000)
}

public func LL_USART_ClearFlag_WKUP<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x100000)
}

public func LL_USART_EnableIT_IDLE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x10)
}

public func LL_USART_EnableIT_RXNE_RXFNE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x20)
}

public func LL_USART_EnableIT_TC<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x40)
}

public func LL_USART_EnableIT_TXE_TXFNF<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x80)
}

public func LL_USART_EnableIT_PE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x100)
}

public func LL_USART_EnableIT_CM<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x4000)
}

public func LL_USART_EnableIT_RTO<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x4000000)
}

public func LL_USART_EnableIT_EOB<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x8000000)
}

public func LL_USART_EnableIT_TXFE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x4000_0000)
}

public func LL_USART_EnableIT_RXFF<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x8000_0000)
}

public func LL_USART_EnableIT_LBD<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) | (0x40))
}

public func LL_USART_EnableIT_ERROR<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x1)
}

public func LL_USART_EnableIT_CTS<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x400)
}

public func LL_USART_EnableIT_WKUP<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x400000)
}

public func LL_USART_EnableIT_TXFT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x800000)
}

public func LL_USART_EnableIT_TCBGT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x1000000)
}

public func LL_USART_EnableIT_RXFT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x1000_0000)
}

public func LL_USART_DisableIT_IDLE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x10, set: 0)
}

public func LL_USART_DisableIT_RXNE_RXFNE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x20, set: 0)
}

public func LL_USART_DisableIT_TC<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x40, set: 0)
}

public func LL_USART_DisableIT_TXE_TXFNF<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x80, set: 0)
}

public func LL_USART_DisableIT_PE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x100, set: 0)
}

public func LL_USART_DisableIT_CM<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4000, set: 0)
}

public func LL_USART_DisableIT_RTO<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4000000, set: 0)
}

public func LL_USART_DisableIT_EOB<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x8000000, set: 0)
}

public func LL_USART_DisableIT_TXFE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4000_0000, set: 0)
}

public func LL_USART_DisableIT_RXFF<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x8000_0000, set: 0)
}

public func LL_USART_DisableIT_LBD<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr2, value: registers.read(UARTRegister.cr2) & ~(0x40))
}

public func LL_USART_DisableIT_ERROR<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x1, set: 0)
}

public func LL_USART_DisableIT_CTS<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x400, set: 0)
}

public func LL_USART_DisableIT_WKUP<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x400000, set: 0)
}

public func LL_USART_DisableIT_TXFT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x800000, set: 0)
}

public func LL_USART_DisableIT_TCBGT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x1000000, set: 0)
}

public func LL_USART_DisableIT_RXFT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x1000_0000, set: 0)
}

public func LL_USART_IsEnabledIT_IDLE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_RXNE_RXFNE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_TC<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_TXE_TXFNF<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_PE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_CM<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_RTO<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_EOB<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x8000000)) == (0x8000000)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_TXFE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_RXFF<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_LBD<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr2) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_ERROR<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_CTS<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_WKUP<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_TXFT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_TCBGT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_USART_IsEnabledIT_RXFT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x1000_0000)) == (0x1000_0000)) ? 1 : 0)
}

public func LL_USART_EnableDMAReq_RX<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x40)
}

public func LL_USART_DisableDMAReq_RX<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x40, set: 0)
}

public func LL_USART_IsEnabledDMAReq_RX<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_USART_EnableDMAReq_TX<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x80)
}

public func LL_USART_DisableDMAReq_TX<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x80, set: 0)
}

public func LL_USART_IsEnabledDMAReq_TX<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_USART_EnableDMADeactOnRxErr<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x2000))
}

public func LL_USART_DisableDMADeactOnRxErr<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x2000))
}

public func LL_USART_IsEnabledDMADeactOnRxErr<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_USART_DMA_GetRegAddr<IO: UARTRegisterIO>(_ registers: IO, _ Direction: UInt32) -> UInt32 {
    return registers.instance.rawValue &+ (Direction == LL_USART_DMA_REG_DATA_TRANSMIT ? 0x28 : 0x24)
}

public func LL_USART_ReceiveData8<IO: UARTRegisterIO>(_ registers: IO) -> UInt8 {
    return UInt8(truncatingIfNeeded: ((registers.read(UARTRegister.rdr) & (0x1ff)) & 0xFF))
}

public func LL_USART_ReceiveData9<IO: UARTRegisterIO>(_ registers: IO) -> UInt16 {
    return UInt16(truncatingIfNeeded: ((registers.read(UARTRegister.rdr) & (0x1ff))))
}

public func LL_USART_TransmitData8<IO: UARTRegisterIO>(_ registers: IO, _ Value: UInt8) {
    registers.write(UARTRegister.tdr, value: UInt32(Value))
}

public func LL_USART_TransmitData9<IO: UARTRegisterIO>(_ registers: IO, _ Value: UInt16) {
    registers.write(UARTRegister.tdr, value: (UInt32(Value) & 0x1FF))
}

public func LL_USART_RequestAutoBaudRate<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x1))
}

public func LL_USART_RequestBreakSending<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x2))
}

public func LL_USART_RequestEnterMuteMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x4))
}

public func LL_USART_RequestRxDataFlush<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x8))
}

public func LL_USART_RequestTxDataFlush<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x10))
}

public func LL_USART_DeInit<IO: UARTRegisterIO & LLBusRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue

    if registers.instance == .usart1 {
        LL_APB2_GRP1_ForceReset(&registers, LL_APB2_GRP1_PERIPH_USART1)

        LL_APB2_GRP1_ReleaseReset(&registers, LL_APB2_GRP1_PERIPH_USART1)
    } else if registers.instance == .usart2 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_USART2)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_USART2)
    } else if registers.instance == .usart3 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_USART3)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_USART3)
    } else if registers.instance == .uart4 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_UART4)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_UART4)
    } else if registers.instance == .uart5 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_UART5)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_UART5)
    } else if registers.instance == .uart7 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_UART7)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_UART7)
    } else if registers.instance == .uart8 {
        LL_APB1_GRP1_ForceReset(&registers, LL_APB1_GRP1_PERIPH_UART8)

        LL_APB1_GRP1_ReleaseReset(&registers, LL_APB1_GRP1_PERIPH_UART8)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_USART_Init<IO: UARTRegisterIO, Clock: LLRCCRegisterIO>(
    _ registers: IO, _ USART_InitStruct: LL_USART_InitTypeDef, clocks: inout Clock,
    oscillators: RCCOscillatorValues = .llDefaults
) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.error.rawValue
    var periphclk: UInt32 = LL_RCC_PERIPH_FREQUENCY_NO

    if LL_USART_IsEnabled(registers) == 0 {
        registers.write(
            UARTRegister.cr1,
            value: (registers.read(UARTRegister.cr1) & ~((0x1000_1000 | 0x400 | 0x200 | 0x8 | 0x4 | 0x8000)))
                | ((USART_InitStruct.DataWidth | USART_InitStruct.Parity | USART_InitStruct.TransferDirection
                    | USART_InitStruct.OverSampling)))

        LL_USART_SetStopBitsLength(registers, USART_InitStruct.StopBits)

        LL_USART_SetHWFlowCtrl(registers, USART_InitStruct.HardwareFlowControl)

        if registers.instance == .usart1 {
            periphclk = LL_RCC_GetUSARTClockFreq(&clocks, LL_RCC_USART1_CLKSOURCE, oscillators: oscillators)
        } else if registers.instance == .usart2 {
            periphclk = LL_RCC_GetUSARTClockFreq(&clocks, LL_RCC_USART234578_CLKSOURCE, oscillators: oscillators)
        } else if registers.instance == .usart3 {
            periphclk = LL_RCC_GetUSARTClockFreq(&clocks, LL_RCC_USART234578_CLKSOURCE, oscillators: oscillators)
        } else if registers.instance == .uart4 {
            periphclk = LL_RCC_GetUARTClockFreq(&clocks, LL_RCC_USART234578_CLKSOURCE, oscillators: oscillators)
        } else if registers.instance == .uart5 {
            periphclk = LL_RCC_GetUARTClockFreq(&clocks, LL_RCC_USART234578_CLKSOURCE, oscillators: oscillators)
        } else if registers.instance == .uart7 {
            periphclk = LL_RCC_GetUARTClockFreq(&clocks, LL_RCC_USART234578_CLKSOURCE, oscillators: oscillators)
        } else if registers.instance == .uart8 {
            periphclk = LL_RCC_GetUARTClockFreq(&clocks, LL_RCC_USART234578_CLKSOURCE, oscillators: oscillators)
        } else {
        }

        if (periphclk != LL_RCC_PERIPH_FREQUENCY_NO)
            && (USART_InitStruct.BaudRate != 0)
        {
            status = LLErrorStatus.success.rawValue
            LL_USART_SetBaudRate(
                registers, periphclk, USART_InitStruct.PrescalerValue, USART_InitStruct.OverSampling,
                USART_InitStruct.BaudRate)

        }

        LL_USART_SetPrescaler(registers, USART_InitStruct.PrescalerValue)
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_USART_StructInit(_ USART_InitStruct: inout LL_USART_InitTypeDef) {
    USART_InitStruct.PrescalerValue = LL_USART_PRESCALER_DIV1
    USART_InitStruct.BaudRate = 9600
    USART_InitStruct.DataWidth = LL_USART_DATAWIDTH_8B
    USART_InitStruct.StopBits = LL_USART_STOPBITS_1
    USART_InitStruct.Parity = LL_USART_PARITY_NONE
    USART_InitStruct.TransferDirection = LL_USART_DIRECTION_TX_RX
    USART_InitStruct.HardwareFlowControl = LL_USART_HWCONTROL_NONE
    USART_InitStruct.OverSampling = LL_USART_OVERSAMPLING_16
}

public func LL_USART_ClockInit<IO: UARTRegisterIO>(_ registers: IO, _ USART_ClockInitStruct: LL_USART_ClockInitTypeDef)
    -> LLErrorStatus
{
    var status: UInt32 = LLErrorStatus.success.rawValue

    if LL_USART_IsEnabled(registers) == 0 {

        registers.write(
            UARTRegister.cr2,
            value: (registers.read(UARTRegister.cr2) & ~(0x800 | 0x200 | 0x400 | 0x100))
                | (USART_ClockInitStruct.ClockOutput | USART_ClockInitStruct.ClockPolarity
                    | USART_ClockInitStruct.ClockPhase | USART_ClockInitStruct.LastBitClockPulse))
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_USART_ClockStructInit(_ USART_ClockInitStruct: inout LL_USART_ClockInitTypeDef) {
    USART_ClockInitStruct.ClockOutput = LL_USART_CLOCK_DISABLE
    USART_ClockInitStruct.ClockPolarity = LL_USART_POLARITY_LOW
    USART_ClockInitStruct.ClockPhase = LL_USART_PHASE_1EDGE
    USART_ClockInitStruct.LastBitClockPulse = LL_USART_LASTCLKPULSE_NO_OUTPUT
}
