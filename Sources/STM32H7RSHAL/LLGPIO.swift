// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from stm32h7rsxx_ll_*.h/.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// CMSIS encodings: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

public let LL_GPIO_PIN_0: UInt32 = 0x00000001
public let LL_GPIO_PIN_1: UInt32 = 0x00000002
public let LL_GPIO_PIN_2: UInt32 = 0x00000004
public let LL_GPIO_PIN_3: UInt32 = 0x00000008
public let LL_GPIO_PIN_4: UInt32 = 0x00000010
public let LL_GPIO_PIN_5: UInt32 = 0x00000020
public let LL_GPIO_PIN_6: UInt32 = 0x00000040
public let LL_GPIO_PIN_7: UInt32 = 0x00000080
public let LL_GPIO_PIN_8: UInt32 = 0x00000100
public let LL_GPIO_PIN_9: UInt32 = 0x00000200
public let LL_GPIO_PIN_10: UInt32 = 0x00000400
public let LL_GPIO_PIN_11: UInt32 = 0x00000800
public let LL_GPIO_PIN_12: UInt32 = 0x00001000
public let LL_GPIO_PIN_13: UInt32 = 0x00002000
public let LL_GPIO_PIN_14: UInt32 = 0x00004000
public let LL_GPIO_PIN_15: UInt32 = 0x00008000
public let LL_GPIO_PIN_ALL: UInt32 = 0x0000FFFF
public let LL_GPIO_MODE_INPUT: UInt32 = 0x00000000
public let LL_GPIO_MODE_OUTPUT: UInt32 = 0x00000001
public let LL_GPIO_MODE_ALTERNATE: UInt32 = 0x00000002
public let LL_GPIO_MODE_ANALOG: UInt32 = 0x00000003
public let LL_GPIO_OUTPUT_PUSHPULL: UInt32 = 0x00000000
public let LL_GPIO_OUTPUT_OPENDRAIN: UInt32 = 0x00000001
public let LL_GPIO_SPEED_FREQ_LOW: UInt32 = 0x00000000
public let LL_GPIO_SPEED_FREQ_MEDIUM: UInt32 = 0x00000001
public let LL_GPIO_SPEED_FREQ_HIGH: UInt32 = 0x00000002
public let LL_GPIO_SPEED_FREQ_VERY_HIGH: UInt32 = 0x00000003
public let LL_GPIO_PULL_NO: UInt32 = 0x00000000
public let LL_GPIO_PULL_UP: UInt32 = 0x00000001
public let LL_GPIO_PULL_DOWN: UInt32 = 0x00000002
public let LL_GPIO_AF_0: UInt32 = 0x00000000
public let LL_GPIO_AF_1: UInt32 = 0x00000001
public let LL_GPIO_AF_2: UInt32 = 0x00000002
public let LL_GPIO_AF_3: UInt32 = 0x00000003
public let LL_GPIO_AF_4: UInt32 = 0x00000004
public let LL_GPIO_AF_5: UInt32 = 0x00000005
public let LL_GPIO_AF_6: UInt32 = 0x00000006
public let LL_GPIO_AF_7: UInt32 = 0x00000007
public let LL_GPIO_AF_8: UInt32 = 0x00000008
public let LL_GPIO_AF_9: UInt32 = 0x00000009
public let LL_GPIO_AF_10: UInt32 = 0x0000000A
public let LL_GPIO_AF_11: UInt32 = 0x0000000B
public let LL_GPIO_AF_12: UInt32 = 0x0000000C
public let LL_GPIO_AF_13: UInt32 = 0x0000000D
public let LL_GPIO_AF_14: UInt32 = 0x0000000E
public let LL_GPIO_AF_15: UInt32 = 0x0000000F

public func LL_GPIO_SetPinMode<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32, _ Mode: UInt32) {
    registers.write(.moder, value: (registers.read(.moder) & ~((0x3 << (_llPositionValue(Pin) &* 0x2)))) | ((Mode << (_llPositionValue(Pin) &* 0x2))))
}

public func LL_GPIO_GetPinMode<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32) -> UInt32 {
    return ((registers.read(.moder) & ((0x3 << (_llPositionValue(Pin) &* 0x2)))) >> (_llPositionValue(Pin) &* 0x2))
}

public func LL_GPIO_SetPinOutputType<IO: GPIORegisterIO>(_ registers: inout IO, _ PinMask: UInt32, _ OutputType: UInt32) {
    registers.write(.otyper, value: (registers.read(.otyper) & ~(PinMask)) | ((PinMask &* OutputType)))
}

public func LL_GPIO_GetPinOutputType<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32) -> UInt32 {
    return ((registers.read(.otyper) & (Pin)) >> _llPositionValue(Pin))
}

public func LL_GPIO_SetPinSpeed<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32, _ Speed: UInt32) {
    registers.write(.ospeedr, value: (registers.read(.ospeedr) & ~((0x3 << (_llPositionValue(Pin) &* 0x2)))) | ((Speed << (_llPositionValue(Pin) &* 0x2))))
}

public func LL_GPIO_GetPinSpeed<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32) -> UInt32 {
    return ((registers.read(.ospeedr) & ((0x3 << (_llPositionValue(Pin) &* 0x2)))) >> (_llPositionValue(Pin) &* 0x2))
}

public func LL_GPIO_SetPinPull<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32, _ Pull: UInt32) {
    registers.write(.pupdr, value: (registers.read(.pupdr) & ~((0x3 << (_llPositionValue(Pin) &* 0x2)))) | ((Pull << (_llPositionValue(Pin) &* 0x2))))
}

public func LL_GPIO_GetPinPull<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32) -> UInt32 {
    return ((registers.read(.pupdr) & ((0x3 << (_llPositionValue(Pin) &* 0x2)))) >> (_llPositionValue(Pin) &* 0x2))
}

public func LL_GPIO_SetAFPin_0_7<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32, _ Alternate: UInt32) {
    registers.write(.alternateFunction(index: 0), value: (registers.read(.alternateFunction(index: 0)) & ~((0xF << (_llPositionValue(Pin) &* 0x4)))) | ((Alternate << (_llPositionValue(Pin) &* 0x4))))
}

public func LL_GPIO_GetAFPin_0_7<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32) -> UInt32 {
    return ((registers.read(.alternateFunction(index: 0)) & ((0xF << (_llPositionValue(Pin) &* 0x4)))) >> (_llPositionValue(Pin) &* 0x4))
}

public func LL_GPIO_SetAFPin_8_15<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32, _ Alternate: UInt32) {
    registers.write(.alternateFunction(index: 1), value: (registers.read(.alternateFunction(index: 1)) & ~((0xF << (_llPositionValue(Pin >> 8) &* 0x4)))) | ((Alternate << (_llPositionValue(Pin >> 8) &* 0x4))))
}

public func LL_GPIO_GetAFPin_8_15<IO: GPIORegisterIO>(_ registers: inout IO, _ Pin: UInt32) -> UInt32 {
    return ((registers.read(.alternateFunction(index: 1)) & ((0xF << (_llPositionValue(Pin >> 8) &* 0x4)))) >> (_llPositionValue(Pin >> 8) &* 0x4))
}

public func LL_GPIO_LockPin<IO: GPIORegisterIO>(_ registers: inout IO, _ PinMask: UInt32) {
    registers.write(.lckr, value: 0x10000 | PinMask)
    registers.write(.lckr, value: PinMask)
    registers.write(.lckr, value: 0x10000 | PinMask)
    _ = registers.read(.lckr)
}

public func LL_GPIO_IsPinLocked<IO: GPIORegisterIO>(_ registers: inout IO, _ PinMask: UInt32) -> UInt32 {
    return (((registers.read(.lckr) & (PinMask)) == (PinMask)) ? 1 : 0)
}

public func LL_GPIO_IsAnyPinLocked<IO: GPIORegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(.lckr) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_GPIO_ReadInputPort<IO: GPIORegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(.idr))
}

public func LL_GPIO_IsInputPinSet<IO: GPIORegisterIO>(_ registers: inout IO, _ PinMask: UInt32) -> UInt32 {
    return (((registers.read(.idr) & (PinMask)) == (PinMask)) ? 1 : 0)
}

public func LL_GPIO_WriteOutputPort<IO: GPIORegisterIO>(_ registers: inout IO, _ PortValue: UInt32) {
    registers.write(.odr, value: PortValue)
}

public func LL_GPIO_ReadOutputPort<IO: GPIORegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(.odr))
}

public func LL_GPIO_IsOutputPinSet<IO: GPIORegisterIO>(_ registers: inout IO, _ PinMask: UInt32) -> UInt32 {
    return (((registers.read(.odr) & (PinMask)) == (PinMask)) ? 1 : 0)
}

public func LL_GPIO_SetOutputPin<IO: GPIORegisterIO>(_ registers: inout IO, _ PinMask: UInt32) {
    registers.write(.bsrr, value: PinMask)
}

public func LL_GPIO_ResetOutputPin<IO: GPIORegisterIO>(_ registers: inout IO, _ PinMask: UInt32) {
    registers.write(.brr, value: PinMask)
}

public func LL_GPIO_TogglePin<IO: GPIORegisterIO>(_ registers: inout IO, _ PinMask: UInt32) {
    let odr: UInt32 = registers.read(.odr)
    registers.write(.bsrr, value: ((odr & PinMask) << 16) | (~odr & PinMask))
}

// POSITION_VAL uses CLZ(RBIT(value)) in CMSIS. A zero pin would lead to
// undefined C shifts in the per-pin helpers; reject that input explicitly.
private func _llPositionValue(_ value: UInt32) -> UInt32 {
    precondition(value != 0)
    return UInt32(value.trailingZeroBitCount)
}

public func LL_GPIO_WriteReg<IO: GPIORegisterIO>(_ registers: inout IO, _ register: GPIORegister, _ value: UInt32) {
    registers.write(register, value: value)
}

public func LL_GPIO_ReadReg<IO: GPIORegisterIO>(_ registers: inout IO, _ register: GPIORegister) -> UInt32 {
    registers.read(register)
}
