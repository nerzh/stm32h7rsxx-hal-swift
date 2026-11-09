// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_LPUART_ICR_PECF: UInt32 = 0x0000_0001
public let LL_LPUART_ICR_FECF: UInt32 = 0x0000_0002
public let LL_LPUART_ICR_NCF: UInt32 = 0x0000_0004
public let LL_LPUART_ICR_ORECF: UInt32 = 0x0000_0008
public let LL_LPUART_ICR_IDLECF: UInt32 = 0x0000_0010
public let LL_LPUART_ICR_TCCF: UInt32 = 0x0000_0040
public let LL_LPUART_ICR_CTSCF: UInt32 = 0x0000_0200
public let LL_LPUART_ICR_CMCF: UInt32 = 0x0002_0000
public let LL_LPUART_ICR_WUCF: UInt32 = 0x0010_0000
public let LL_LPUART_ISR_PE: UInt32 = 0x0000_0001
public let LL_LPUART_ISR_FE: UInt32 = 0x0000_0002
public let LL_LPUART_ISR_NE: UInt32 = 0x0000_0004
public let LL_LPUART_ISR_ORE: UInt32 = 0x0000_0008
public let LL_LPUART_ISR_IDLE: UInt32 = 0x0000_0010
public let LL_LPUART_ISR_RXNE_RXFNE: UInt32 = 0x0000_0020
public let LL_LPUART_ISR_TC: UInt32 = 0x0000_0040
public let LL_LPUART_ISR_TXE_TXFNF: UInt32 = 0x0000_0080
public let LL_LPUART_ISR_CTSIF: UInt32 = 0x0000_0200
public let LL_LPUART_ISR_CTS: UInt32 = 0x0000_0400
public let LL_LPUART_ISR_BUSY: UInt32 = 0x0001_0000
public let LL_LPUART_ISR_CMF: UInt32 = 0x0002_0000
public let LL_LPUART_ISR_SBKF: UInt32 = 0x0004_0000
public let LL_LPUART_ISR_RWU: UInt32 = 0x0008_0000
public let LL_LPUART_ISR_WUF: UInt32 = 0x0010_0000
public let LL_LPUART_ISR_TEACK: UInt32 = 0x0020_0000
public let LL_LPUART_ISR_REACK: UInt32 = 0x0040_0000
public let LL_LPUART_ISR_TXFE: UInt32 = 0x0080_0000
public let LL_LPUART_ISR_RXFF: UInt32 = 0x0100_0000
public let LL_LPUART_ISR_RXFT: UInt32 = 0x0400_0000
public let LL_LPUART_ISR_TXFT: UInt32 = 0x0800_0000
public let LL_LPUART_CR1_IDLEIE: UInt32 = 0x0000_0010
public let LL_LPUART_CR1_RXNEIE_RXFNEIE: UInt32 = 0x0000_0020
public let LL_LPUART_CR1_TCIE: UInt32 = 0x0000_0040
public let LL_LPUART_CR1_TXEIE_TXFNFIE: UInt32 = 0x0000_0080
public let LL_LPUART_CR1_PEIE: UInt32 = 0x0000_0100
public let LL_LPUART_CR1_CMIE: UInt32 = 0x0000_4000
public let LL_LPUART_CR1_TXFEIE: UInt32 = 0x4000_0000
public let LL_LPUART_CR1_RXFFIE: UInt32 = 0x8000_0000
public let LL_LPUART_CR3_EIE: UInt32 = 0x0000_0001
public let LL_LPUART_CR3_CTSIE: UInt32 = 0x0000_0400
public let LL_LPUART_CR3_WUFIE: UInt32 = 0x0040_0000
public let LL_LPUART_CR3_TXFTIE: UInt32 = 0x0080_0000
public let LL_LPUART_CR3_RXFTIE: UInt32 = 0x1000_0000
public let LL_LPUART_FIFOTHRESHOLD_1_8: UInt32 = 0x0000_0000
public let LL_LPUART_FIFOTHRESHOLD_1_4: UInt32 = 0x0000_0001
public let LL_LPUART_FIFOTHRESHOLD_1_2: UInt32 = 0x0000_0002
public let LL_LPUART_FIFOTHRESHOLD_3_4: UInt32 = 0x0000_0003
public let LL_LPUART_FIFOTHRESHOLD_7_8: UInt32 = 0x0000_0004
public let LL_LPUART_FIFOTHRESHOLD_8_8: UInt32 = 0x0000_0005
public let LL_LPUART_DIRECTION_NONE: UInt32 = 0x0000_0000
public let LL_LPUART_DIRECTION_RX: UInt32 = 0x0000_0004
public let LL_LPUART_DIRECTION_TX: UInt32 = 0x0000_0008
public let LL_LPUART_DIRECTION_TX_RX: UInt32 = 0x0000_000C
public let LL_LPUART_PARITY_NONE: UInt32 = 0x0000_0000
public let LL_LPUART_PARITY_EVEN: UInt32 = 0x0000_0400
public let LL_LPUART_PARITY_ODD: UInt32 = 0x0000_0600
public let LL_LPUART_WAKEUP_IDLELINE: UInt32 = 0x0000_0000
public let LL_LPUART_WAKEUP_ADDRESSMARK: UInt32 = 0x0000_0800
public let LL_LPUART_DATAWIDTH_7B: UInt32 = 0x1000_0000
public let LL_LPUART_DATAWIDTH_8B: UInt32 = 0x0000_0000
public let LL_LPUART_DATAWIDTH_9B: UInt32 = 0x0000_1000
public let LL_LPUART_PRESCALER_DIV1: UInt32 = 0x0000_0000
public let LL_LPUART_PRESCALER_DIV2: UInt32 = 0x0000_0001
public let LL_LPUART_PRESCALER_DIV4: UInt32 = 0x0000_0002
public let LL_LPUART_PRESCALER_DIV6: UInt32 = 0x0000_0003
public let LL_LPUART_PRESCALER_DIV8: UInt32 = 0x0000_0004
public let LL_LPUART_PRESCALER_DIV10: UInt32 = 0x0000_0005
public let LL_LPUART_PRESCALER_DIV12: UInt32 = 0x0000_0006
public let LL_LPUART_PRESCALER_DIV16: UInt32 = 0x0000_0007
public let LL_LPUART_PRESCALER_DIV32: UInt32 = 0x0000_0008
public let LL_LPUART_PRESCALER_DIV64: UInt32 = 0x0000_0009
public let LL_LPUART_PRESCALER_DIV128: UInt32 = 0x0000_000A
public let LL_LPUART_PRESCALER_DIV256: UInt32 = 0x0000_000B
public let LL_LPUART_STOPBITS_1: UInt32 = 0x0000_0000
public let LL_LPUART_STOPBITS_2: UInt32 = 0x0000_2000
public let LL_LPUART_TXRX_STANDARD: UInt32 = 0x0000_0000
public let LL_LPUART_TXRX_SWAPPED: UInt32 = 0x0000_8000
public let LL_LPUART_RXPIN_LEVEL_STANDARD: UInt32 = 0x0000_0000
public let LL_LPUART_RXPIN_LEVEL_INVERTED: UInt32 = 0x0001_0000
public let LL_LPUART_TXPIN_LEVEL_STANDARD: UInt32 = 0x0000_0000
public let LL_LPUART_TXPIN_LEVEL_INVERTED: UInt32 = 0x0002_0000
public let LL_LPUART_BINARY_LOGIC_POSITIVE: UInt32 = 0x0000_0000
public let LL_LPUART_BINARY_LOGIC_NEGATIVE: UInt32 = 0x0004_0000
public let LL_LPUART_BITORDER_LSBFIRST: UInt32 = 0x0000_0000
public let LL_LPUART_BITORDER_MSBFIRST: UInt32 = 0x0008_0000
public let LL_LPUART_ADDRESS_DETECT_4B: UInt32 = 0x0000_0000
public let LL_LPUART_ADDRESS_DETECT_7B: UInt32 = 0x0000_0010
public let LL_LPUART_HWCONTROL_NONE: UInt32 = 0x0000_0000
public let LL_LPUART_HWCONTROL_RTS: UInt32 = 0x0000_0100
public let LL_LPUART_HWCONTROL_CTS: UInt32 = 0x0000_0200
public let LL_LPUART_HWCONTROL_RTS_CTS: UInt32 = 0x0000_0300
public let LL_LPUART_WAKEUP_ON_ADDRESS: UInt32 = 0x0000_0000
public let LL_LPUART_WAKEUP_ON_STARTBIT: UInt32 = 0x0020_0000
public let LL_LPUART_WAKEUP_ON_RXNE: UInt32 = 0x0030_0000
public let LL_LPUART_DE_POLARITY_HIGH: UInt32 = 0x0000_0000
public let LL_LPUART_DE_POLARITY_LOW: UInt32 = 0x0000_8000
public let LL_LPUART_DMA_REG_DATA_TRANSMIT: UInt32 = 0x0000_0000
public let LL_LPUART_DMA_REG_DATA_RECEIVE: UInt32 = 0x0000_0001

public func LL_LPUART_Enable<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr1, value: registers.read(UARTRegister.cr1) | (0x1))
}

public func LL_LPUART_Disable<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr1, value: registers.read(UARTRegister.cr1) & ~(0x1))
}

public func LL_LPUART_IsEnabled<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_LPUART_EnableFIFO<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr1, value: registers.read(UARTRegister.cr1) | (0x2000_0000))
}

public func LL_LPUART_DisableFIFO<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr1, value: registers.read(UARTRegister.cr1) & ~(0x2000_0000))
}

public func LL_LPUART_IsEnabledFIFO<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x2000_0000)) == (0x2000_0000)) ? 1 : 0)
}

public func LL_LPUART_SetTXFIFOThreshold<IO: UARTRegisterIO>(_ registers: IO, _ Threshold: UInt32) {
    registers.atomicModify(UARTRegister.cr3, clear: 0xe000_0000, set: Threshold << 0x1d)
}

public func LL_LPUART_GetTXFIFOThreshold<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0xe000_0000)) >> 0x1d)
}

public func LL_LPUART_SetRXFIFOThreshold<IO: UARTRegisterIO>(_ registers: IO, _ Threshold: UInt32) {
    registers.atomicModify(UARTRegister.cr3, clear: 0xe000000, set: Threshold << 0x19)
}

public func LL_LPUART_GetRXFIFOThreshold<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0xe000000)) >> 0x19)
}

public func LL_LPUART_ConfigFIFOsThreshold<IO: UARTRegisterIO>(
    _ registers: IO, _ TXThreshold: UInt32, _ RXThreshold: UInt32
) {
    registers.atomicModify(
        UARTRegister.cr3, clear: 0xe000_0000 | 0xe000000, set: (TXThreshold << 0x1d) | (RXThreshold << 0x19))
}

public func LL_LPUART_EnableInStopMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x2)
}

public func LL_LPUART_DisableInStopMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x2, set: 0)
}

public func LL_LPUART_IsEnabledInStopMode<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_LPUART_EnableDirectionRx<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x4)
}

public func LL_LPUART_DisableDirectionRx<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4, set: 0)
}

public func LL_LPUART_EnableDirectionTx<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x8)
}

public func LL_LPUART_DisableDirectionTx<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x8, set: 0)
}

public func LL_LPUART_SetTransferDirection<IO: UARTRegisterIO>(_ registers: IO, _ TransferDirection: UInt32) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4 | 0x8, set: TransferDirection)
}

public func LL_LPUART_GetTransferDirection<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x4 | 0x8)))
}

public func LL_LPUART_SetParity<IO: UARTRegisterIO>(_ registers: IO, _ Parity: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x200 | 0x400)) | (Parity))
}

public func LL_LPUART_GetParity<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x200 | 0x400)))
}

public func LL_LPUART_SetWakeUpMethod<IO: UARTRegisterIO>(_ registers: IO, _ Method: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x800)) | (Method))
}

public func LL_LPUART_GetWakeUpMethod<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x800)))
}

public func LL_LPUART_SetDataWidth<IO: UARTRegisterIO>(_ registers: IO, _ DataWidth: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x1000_1000)) | (DataWidth))
}

public func LL_LPUART_GetDataWidth<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x1000_1000)))
}

public func LL_LPUART_EnableMuteMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x2000)
}

public func LL_LPUART_DisableMuteMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x2000, set: 0)
}

public func LL_LPUART_IsEnabledMuteMode<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_LPUART_SetPrescaler<IO: UARTRegisterIO>(_ registers: IO, _ PrescalerValue: UInt32) {
    registers.write(
        UARTRegister.presc,
        value: (registers.read(UARTRegister.presc) & ~(0xf)) | UInt32(UInt16(truncatingIfNeeded: PrescalerValue)))
}

public func LL_LPUART_GetPrescaler<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.presc) & (0xf)))
}

public func LL_LPUART_SetStopBitsLength<IO: UARTRegisterIO>(_ registers: IO, _ StopBits: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x3000)) | (StopBits))
}

public func LL_LPUART_GetStopBitsLength<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x3000)))
}

public func LL_LPUART_ConfigCharacter<IO: UARTRegisterIO>(
    _ registers: IO, _ DataWidth: UInt32, _ Parity: UInt32, _ StopBits: UInt32
) {
    registers.write(
        UARTRegister.cr1,
        value: (registers.read(UARTRegister.cr1) & ~(0x200 | 0x400 | 0x1000_1000)) | (Parity | DataWidth))
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x3000)) | (StopBits))
}

public func LL_LPUART_SetTXRXSwap<IO: UARTRegisterIO>(_ registers: IO, _ SwapConfig: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x8000)) | (SwapConfig))
}

public func LL_LPUART_GetTXRXSwap<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x8000)))
}

public func LL_LPUART_SetRXPinLevel<IO: UARTRegisterIO>(_ registers: IO, _ PinInvMethod: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x10000)) | (PinInvMethod))
}

public func LL_LPUART_GetRXPinLevel<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x10000)))
}

public func LL_LPUART_SetTXPinLevel<IO: UARTRegisterIO>(_ registers: IO, _ PinInvMethod: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x20000)) | (PinInvMethod))
}

public func LL_LPUART_GetTXPinLevel<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x20000)))
}

public func LL_LPUART_SetBinaryDataLogic<IO: UARTRegisterIO>(_ registers: IO, _ DataLogic: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x40000)) | (DataLogic))
}

public func LL_LPUART_GetBinaryDataLogic<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x40000)))
}

public func LL_LPUART_SetTransferBitOrder<IO: UARTRegisterIO>(_ registers: IO, _ BitOrder: UInt32) {
    registers.write(UARTRegister.cr2, value: (registers.read(UARTRegister.cr2) & ~(0x80000)) | (BitOrder))
}

public func LL_LPUART_GetTransferBitOrder<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x80000)))
}

public func LL_LPUART_ConfigNodeAddress<IO: UARTRegisterIO>(
    _ registers: IO, _ AddressLen: UInt32, _ NodeAddress: UInt32
) {
    registers.write(
        UARTRegister.cr2,
        value: (registers.read(UARTRegister.cr2) & ~(0xff00_0000 | 0x10)) | ((AddressLen | (NodeAddress << 0x18))))
}

public func LL_LPUART_GetNodeAddress<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0xff00_0000)) >> 0x18)
}

public func LL_LPUART_GetNodeAddressLen<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr2) & (0x10)))
}

public func LL_LPUART_EnableRTSHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x100))
}

public func LL_LPUART_DisableRTSHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x100))
}

public func LL_LPUART_EnableCTSHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x200))
}

public func LL_LPUART_DisableCTSHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x200))
}

public func LL_LPUART_SetHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO, _ HardwareFlowControl: UInt32) {
    registers.write(
        UARTRegister.cr3, value: (registers.read(UARTRegister.cr3) & ~(0x100 | 0x200)) | (HardwareFlowControl))
}

public func LL_LPUART_GetHWFlowCtrl<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0x100 | 0x200)))
}

public func LL_LPUART_EnableOverrunDetect<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x1000))
}

public func LL_LPUART_DisableOverrunDetect<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x1000))
}

public func LL_LPUART_IsEnabledOverrunDetect<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x1000)) != 0x1000) ? 1 : 0)
}

public func LL_LPUART_SetWKUPType<IO: UARTRegisterIO>(_ registers: IO, _ Type: UInt32) {
    registers.write(UARTRegister.cr3, value: (registers.read(UARTRegister.cr3) & ~(0x300000)) | (Type))
}

public func LL_LPUART_GetWKUPType<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0x300000)))
}

public func LL_LPUART_SetBaudRate<IO: UARTRegisterIO>(
    _ registers: IO, _ PeriphClk: UInt32, _ PrescalerValue: UInt32, _ BaudRate: UInt32
) {
    if BaudRate != 0 { registers.write(.brr, value: __LL_LPUART_DIV(PeriphClk, PrescalerValue, BaudRate)) }
}

public func LL_LPUART_GetBaudRate<IO: UARTRegisterIO>(_ registers: IO, _ PeriphClk: UInt32, _ PrescalerValue: UInt32)
    -> UInt32
{
    let periphclkpresc = PeriphClk / _llSerialPrescaler(UInt32(UInt16(truncatingIfNeeded: PrescalerValue)))
    let lpuartdiv = registers.read(.brr) & 0xFFFFF
    if lpuartdiv >= 0x300 { return UInt32(truncatingIfNeeded: (UInt64(periphclkpresc) * 256) / UInt64(lpuartdiv)) }
    return 0
}

public func LL_LPUART_EnableHalfDuplex<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x8))
}

public func LL_LPUART_DisableHalfDuplex<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x8))
}

public func LL_LPUART_IsEnabledHalfDuplex<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_LPUART_SetDEDeassertionTime<IO: UARTRegisterIO>(_ registers: IO, _ Time: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x1f0000)) | (Time << 0x10))
}

public func LL_LPUART_GetDEDeassertionTime<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x1f0000)) >> 0x10)
}

public func LL_LPUART_SetDEAssertionTime<IO: UARTRegisterIO>(_ registers: IO, _ Time: UInt32) {
    registers.write(UARTRegister.cr1, value: (registers.read(UARTRegister.cr1) & ~(0x3e00000)) | (Time << 0x15))
}

public func LL_LPUART_GetDEAssertionTime<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr1) & (0x3e00000)) >> 0x15)
}

public func LL_LPUART_EnableDEMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x4000))
}

public func LL_LPUART_DisableDEMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x4000))
}

public func LL_LPUART_IsEnabledDEMode<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_LPUART_SetDESignalPolarity<IO: UARTRegisterIO>(_ registers: IO, _ Polarity: UInt32) {
    registers.write(UARTRegister.cr3, value: (registers.read(UARTRegister.cr3) & ~(0x8000)) | (Polarity))
}

public func LL_LPUART_GetDESignalPolarity<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(UARTRegister.cr3) & (0x8000)))
}

public func LL_LPUART_IsActiveFlag_PE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_FE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_NE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_ORE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_IDLE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_RXNE_RXFNE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_TC<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_TXE_TXFNF<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_nCTS<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_CTS<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_BUSY<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_CM<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x20000)) == (0x20000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_SBK<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x40000)) == (0x40000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_RWU<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x80000)) == (0x80000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_WKUP<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_TEACK<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_REACK<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_TXFE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_RXFF<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_TXFT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x8000000)) == (0x8000000)) ? 1 : 0)
}

public func LL_LPUART_IsActiveFlag_RXFT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.isr) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_LPUART_ClearFlag_PE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x1)
}

public func LL_LPUART_ClearFlag_FE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x2)
}

public func LL_LPUART_ClearFlag_NE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x4)
}

public func LL_LPUART_ClearFlag_ORE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x8)
}

public func LL_LPUART_ClearFlag_IDLE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x10)
}

public func LL_LPUART_ClearFlag_TC<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x40)
}

public func LL_LPUART_ClearFlag_nCTS<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x200)
}

public func LL_LPUART_ClearFlag_CM<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x20000)
}

public func LL_LPUART_ClearFlag_WKUP<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.icr, value: 0x100000)
}

public func LL_LPUART_EnableIT_IDLE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x10)
}

public func LL_LPUART_EnableIT_RXNE_RXFNE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x20)
}

public func LL_LPUART_EnableIT_TC<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x40)
}

public func LL_LPUART_EnableIT_TXE_TXFNF<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x80)
}

public func LL_LPUART_EnableIT_PE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x100)
}

public func LL_LPUART_EnableIT_CM<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x4000)
}

public func LL_LPUART_EnableIT_TXFE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x4000_0000)
}

public func LL_LPUART_EnableIT_RXFF<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0, set: 0x8000_0000)
}

public func LL_LPUART_EnableIT_ERROR<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x1)
}

public func LL_LPUART_EnableIT_CTS<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x400)
}

public func LL_LPUART_EnableIT_WKUP<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x400000)
}

public func LL_LPUART_EnableIT_TXFT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x800000)
}

public func LL_LPUART_EnableIT_RXFT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x1000_0000)
}

public func LL_LPUART_DisableIT_IDLE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x10, set: 0)
}

public func LL_LPUART_DisableIT_RXNE_RXFNE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x20, set: 0)
}

public func LL_LPUART_DisableIT_TC<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x40, set: 0)
}

public func LL_LPUART_DisableIT_TXE_TXFNF<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x80, set: 0)
}

public func LL_LPUART_DisableIT_PE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x100, set: 0)
}

public func LL_LPUART_DisableIT_CM<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4000, set: 0)
}

public func LL_LPUART_DisableIT_TXFE<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x4000_0000, set: 0)
}

public func LL_LPUART_DisableIT_RXFF<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr1, clear: 0x8000_0000, set: 0)
}

public func LL_LPUART_DisableIT_ERROR<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x1, set: 0)
}

public func LL_LPUART_DisableIT_CTS<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x400, set: 0)
}

public func LL_LPUART_DisableIT_WKUP<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x400000, set: 0)
}

public func LL_LPUART_DisableIT_TXFT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x800000, set: 0)
}

public func LL_LPUART_DisableIT_RXFT<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x1000_0000, set: 0)
}

public func LL_LPUART_IsEnabledIT_IDLE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_RXNE_RXFNE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x20)) == (0x20)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_TC<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_TXE_TXFNF<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_PE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_CM<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_TXFE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x4000_0000)) == (0x4000_0000)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_RXFF<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr1) & (0x8000_0000)) == (0x8000_0000)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_ERROR<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_CTS<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x400)) == (0x400)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_WKUP<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_TXFT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_LPUART_IsEnabledIT_RXFT<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x1000_0000)) == (0x1000_0000)) ? 1 : 0)
}

public func LL_LPUART_EnableDMAReq_RX<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x40)
}

public func LL_LPUART_DisableDMAReq_RX<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x40, set: 0)
}

public func LL_LPUART_IsEnabledDMAReq_RX<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x40)) == (0x40)) ? 1 : 0)
}

public func LL_LPUART_EnableDMAReq_TX<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0, set: 0x80)
}

public func LL_LPUART_DisableDMAReq_TX<IO: UARTRegisterIO>(_ registers: IO) {
    registers.atomicModify(UARTRegister.cr3, clear: 0x80, set: 0)
}

public func LL_LPUART_IsEnabledDMAReq_TX<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_LPUART_EnableDMADeactOnRxErr<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) | (0x2000))
}

public func LL_LPUART_DisableDMADeactOnRxErr<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.cr3, value: registers.read(UARTRegister.cr3) & ~(0x2000))
}

public func LL_LPUART_IsEnabledDMADeactOnRxErr<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(UARTRegister.cr3) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_LPUART_DMA_GetRegAddr<IO: UARTRegisterIO>(_ registers: IO, _ Direction: UInt32) -> UInt32 {
    return registers.instance.rawValue &+ (Direction == LL_LPUART_DMA_REG_DATA_TRANSMIT ? 0x28 : 0x24)
}

public func LL_LPUART_ReceiveData8<IO: UARTRegisterIO>(_ registers: IO) -> UInt8 {
    return UInt8(truncatingIfNeeded: ((registers.read(UARTRegister.rdr) & (0x1ff)) & 0xFF))
}

public func LL_LPUART_ReceiveData9<IO: UARTRegisterIO>(_ registers: IO) -> UInt16 {
    return UInt16(truncatingIfNeeded: ((registers.read(UARTRegister.rdr) & (0x1ff))))
}

public func LL_LPUART_TransmitData8<IO: UARTRegisterIO>(_ registers: IO, _ Value: UInt8) {
    registers.write(UARTRegister.tdr, value: UInt32(Value))
}

public func LL_LPUART_TransmitData9<IO: UARTRegisterIO>(_ registers: IO, _ Value: UInt16) {
    registers.write(UARTRegister.tdr, value: UInt32(Value) & 0x1FF)
}

public func LL_LPUART_RequestBreakSending<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x2))
}

public func LL_LPUART_RequestEnterMuteMode<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x4))
}

public func LL_LPUART_RequestRxDataFlush<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x8))
}

public func LL_LPUART_RequestTxDataFlush<IO: UARTRegisterIO>(_ registers: IO) {
    registers.write(UARTRegister.rqr, value: registers.read(UARTRegister.rqr) | (0x10))
}

public func LL_LPUART_DeInit<IO: UARTRegisterIO & LLBusRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.success.rawValue

    if registers.instance == .lpuart1 {
        LL_APB4_GRP1_ForceReset(&registers, LL_APB4_GRP1_PERIPH_LPUART1)

        LL_APB4_GRP1_ReleaseReset(&registers, LL_APB4_GRP1_PERIPH_LPUART1)
    } else {
        status = LLErrorStatus.error.rawValue
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_LPUART_Init<IO: UARTRegisterIO, Clock: LLRCCRegisterIO>(
    _ registers: IO, _ LPUART_InitStruct: LL_LPUART_InitTypeDef, clocks: inout Clock,
    oscillators: RCCOscillatorValues = .llDefaults
) -> LLErrorStatus {
    var status: UInt32 = LLErrorStatus.error.rawValue
    var periphclk: UInt32

    if LL_LPUART_IsEnabled(registers) == 0 {
        registers.write(
            UARTRegister.cr1,
            value: (registers.read(UARTRegister.cr1) & ~((0x1000_1000 | 0x400 | 0x200 | 0x8 | 0x4)))
                | ((LPUART_InitStruct.DataWidth | LPUART_InitStruct.Parity | LPUART_InitStruct.TransferDirection)))

        LL_LPUART_SetStopBitsLength(registers, LPUART_InitStruct.StopBits)

        LL_LPUART_SetHWFlowCtrl(registers, LPUART_InitStruct.HardwareFlowControl)

        periphclk = LL_RCC_GetLPUARTClockFreq(&clocks, LL_RCC_LPUART1_CLKSOURCE, oscillators: oscillators)

        if (periphclk != LL_RCC_PERIPH_FREQUENCY_NO)
            && (LPUART_InitStruct.BaudRate != 0)
        {
            status = LLErrorStatus.success.rawValue
            LL_LPUART_SetBaudRate(registers, periphclk, LPUART_InitStruct.PrescalerValue, LPUART_InitStruct.BaudRate)

        }

        LL_LPUART_SetPrescaler(registers, LPUART_InitStruct.PrescalerValue)
    }
    return LLErrorStatus(rawValue: status)!
}

public func LL_LPUART_StructInit(_ LPUART_InitStruct: inout LL_LPUART_InitTypeDef) {
    LPUART_InitStruct.PrescalerValue = LL_LPUART_PRESCALER_DIV1
    LPUART_InitStruct.BaudRate = 9600
    LPUART_InitStruct.DataWidth = LL_LPUART_DATAWIDTH_8B
    LPUART_InitStruct.StopBits = LL_LPUART_STOPBITS_1
    LPUART_InitStruct.Parity = LL_LPUART_PARITY_NONE
    LPUART_InitStruct.TransferDirection = LL_LPUART_DIRECTION_TX_RX
    LPUART_InitStruct.HardwareFlowControl = LL_LPUART_HWCONTROL_NONE
}
