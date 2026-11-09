// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

func _llSerialPrescaler(_ index: UInt32) -> UInt32 {
    precondition(index < 12, "LL prescaler table index is out of bounds")
    return serialPrescalerDivisor(index)
}
public func __LL_USART_DIV_SAMPLING8(_ clock: UInt32, _ prescaler: UInt32, _ baud: UInt32) -> UInt32 {
    (((clock / _llSerialPrescaler(prescaler)) &* 2) &+ (baud / 2)) / baud
}
public func __LL_USART_DIV_SAMPLING16(_ clock: UInt32, _ prescaler: UInt32, _ baud: UInt32) -> UInt32 {
    ((clock / _llSerialPrescaler(prescaler)) &+ (baud / 2)) / baud
}
public func __LL_LPUART_DIV(_ clock: UInt32, _ prescaler: UInt32, _ baud: UInt32) -> UInt32 {
    UInt32(
        (((UInt64(clock) / UInt64(_llSerialPrescaler(UInt32(UInt16(truncatingIfNeeded: prescaler))))) * 256)
            + UInt64(baud / 2)) / UInt64(baud) & 0xFFFFF)
}
public func LL_USART_IsActiveFlag_RXNE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    LL_USART_IsActiveFlag_RXNE_RXFNE(registers)
}
public func LL_USART_IsActiveFlag_TXE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    LL_USART_IsActiveFlag_TXE_TXFNF(registers)
}
public func LL_USART_EnableIT_RXNE<IO: UARTRegisterIO>(_ registers: IO) { LL_USART_EnableIT_RXNE_RXFNE(registers) }
public func LL_USART_EnableIT_TXE<IO: UARTRegisterIO>(_ registers: IO) { LL_USART_EnableIT_TXE_TXFNF(registers) }
public func LL_USART_DisableIT_RXNE<IO: UARTRegisterIO>(_ registers: IO) { LL_USART_DisableIT_RXNE_RXFNE(registers) }
public func LL_USART_DisableIT_TXE<IO: UARTRegisterIO>(_ registers: IO) { LL_USART_DisableIT_TXE_TXFNF(registers) }
public func LL_USART_IsEnabledIT_RXNE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    LL_USART_IsEnabledIT_RXNE_RXFNE(registers)
}
public func LL_USART_IsEnabledIT_TXE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    LL_USART_IsEnabledIT_TXE_TXFNF(registers)
}
public func LL_LPUART_IsActiveFlag_RXNE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    LL_LPUART_IsActiveFlag_RXNE_RXFNE(registers)
}
public func LL_LPUART_IsActiveFlag_TXE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    LL_LPUART_IsActiveFlag_TXE_TXFNF(registers)
}
public func LL_LPUART_EnableIT_RXNE<IO: UARTRegisterIO>(_ registers: IO) { LL_LPUART_EnableIT_RXNE_RXFNE(registers) }
public func LL_LPUART_EnableIT_TXE<IO: UARTRegisterIO>(_ registers: IO) { LL_LPUART_EnableIT_TXE_TXFNF(registers) }
public func LL_LPUART_DisableIT_RXNE<IO: UARTRegisterIO>(_ registers: IO) { LL_LPUART_DisableIT_RXNE_RXFNE(registers) }
public func LL_LPUART_DisableIT_TXE<IO: UARTRegisterIO>(_ registers: IO) { LL_LPUART_DisableIT_TXE_TXFNF(registers) }
public func LL_LPUART_IsEnabledIT_RXNE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    LL_LPUART_IsEnabledIT_RXNE_RXFNE(registers)
}
public func LL_LPUART_IsEnabledIT_TXE<IO: UARTRegisterIO>(_ registers: IO) -> UInt32 {
    LL_LPUART_IsEnabledIT_TXE_TXFNF(registers)
}
public func LL_USART_WriteReg<IO: UARTRegisterIO>(_ registers: IO, _ register: UARTRegister, _ value: UInt32) {
    registers.write(register, value: value)
}
public func LL_USART_ReadReg<IO: UARTRegisterIO>(_ registers: IO, _ register: UARTRegister) -> UInt32 {
    registers.read(register)
}
public func LL_LPUART_WriteReg<IO: UARTRegisterIO>(_ registers: IO, _ register: UARTRegister, _ value: UInt32) {
    registers.write(register, value: value)
}
public func LL_LPUART_ReadReg<IO: UARTRegisterIO>(_ registers: IO, _ register: UARTRegister) -> UInt32 {
    registers.read(register)
}
