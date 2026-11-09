// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from stm32h7rsxx_ll_*.h/.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// CMSIS encodings: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

public let LL_EXTI_REGISTER_PINPOS_SHFT: UInt32 = 0x00000010
public let LL_EXTI_LINE_0: UInt32 = 0x00000001
public let LL_EXTI_LINE_1: UInt32 = 0x00000002
public let LL_EXTI_LINE_2: UInt32 = 0x00000004
public let LL_EXTI_LINE_3: UInt32 = 0x00000008
public let LL_EXTI_LINE_4: UInt32 = 0x00000010
public let LL_EXTI_LINE_5: UInt32 = 0x00000020
public let LL_EXTI_LINE_6: UInt32 = 0x00000040
public let LL_EXTI_LINE_7: UInt32 = 0x00000080
public let LL_EXTI_LINE_8: UInt32 = 0x00000100
public let LL_EXTI_LINE_9: UInt32 = 0x00000200
public let LL_EXTI_LINE_10: UInt32 = 0x00000400
public let LL_EXTI_LINE_11: UInt32 = 0x00000800
public let LL_EXTI_LINE_12: UInt32 = 0x00001000
public let LL_EXTI_LINE_13: UInt32 = 0x00002000
public let LL_EXTI_LINE_14: UInt32 = 0x00004000
public let LL_EXTI_LINE_15: UInt32 = 0x00008000
public let LL_EXTI_LINE_16: UInt32 = 0x00010000
public let LL_EXTI_LINE_17: UInt32 = 0x00020000
public let LL_EXTI_LINE_18: UInt32 = 0x00040000
public let LL_EXTI_LINE_19: UInt32 = 0x00080000
public let LL_EXTI_LINE_20: UInt32 = 0x00100000
public let LL_EXTI_LINE_21: UInt32 = 0x00200000
public let LL_EXTI_LINE_22: UInt32 = 0x00400000
public let LL_EXTI_LINE_23: UInt32 = 0x00800000
public let LL_EXTI_LINE_24: UInt32 = 0x01000000
public let LL_EXTI_LINE_25: UInt32 = 0x02000000
public let LL_EXTI_LINE_26: UInt32 = 0x04000000
public let LL_EXTI_LINE_27: UInt32 = 0x08000000
public let LL_EXTI_LINE_28: UInt32 = 0x10000000
public let LL_EXTI_LINE_29: UInt32 = 0x20000000
public let LL_EXTI_LINE_30: UInt32 = 0x40000000
public let LL_EXTI_LINE_31: UInt32 = 0x80000000
public let LL_EXTI_LINE_ALL_0_31: UInt32 = 0xFFFFFFFF
public let LL_EXTI_LINE_32: UInt32 = 0x00000001
public let LL_EXTI_LINE_33: UInt32 = 0x00000002
public let LL_EXTI_LINE_34: UInt32 = 0x00000004
public let LL_EXTI_LINE_35: UInt32 = 0x00000008
public let LL_EXTI_LINE_36: UInt32 = 0x00000010
public let LL_EXTI_LINE_37: UInt32 = 0x00000020
public let LL_EXTI_LINE_38: UInt32 = 0x00000040
public let LL_EXTI_LINE_39: UInt32 = 0x00000080
public let LL_EXTI_LINE_40: UInt32 = 0x00000100
public let LL_EXTI_LINE_41: UInt32 = 0x00000200
public let LL_EXTI_LINE_42: UInt32 = 0x00000400
public let LL_EXTI_LINE_43: UInt32 = 0x00000800
public let LL_EXTI_LINE_44: UInt32 = 0x00001000
public let LL_EXTI_LINE_45: UInt32 = 0x00002000
public let LL_EXTI_LINE_46: UInt32 = 0x00004000
public let LL_EXTI_LINE_47: UInt32 = 0x00008000
public let LL_EXTI_LINE_48: UInt32 = 0x00010000
public let LL_EXTI_LINE_49: UInt32 = 0x00020000
public let LL_EXTI_LINE_50: UInt32 = 0x00040000
public let LL_EXTI_LINE_51: UInt32 = 0x00080000
public let LL_EXTI_LINE_52: UInt32 = 0x00100000
public let LL_EXTI_LINE_53: UInt32 = 0x00200000
public let LL_EXTI_LINE_54: UInt32 = 0x00400000
public let LL_EXTI_LINE_55: UInt32 = 0x00800000
public let LL_EXTI_LINE_56: UInt32 = 0x01000000
public let LL_EXTI_LINE_57: UInt32 = 0x02000000
public let LL_EXTI_LINE_58: UInt32 = 0x04000000
public let LL_EXTI_LINE_59: UInt32 = 0x08000000
public let LL_EXTI_LINE_ALL_32_63: UInt32 = 0x0FFFFFFF
public let LL_EXTI_LINE_77: UInt32 = 0x00002000
public let LL_EXTI_LINE_ALL_64_95: UInt32 = 0x00002000
public let LL_EXTI_LINE_ALL: UInt32 = 0xFFFFFFFF
public let LL_EXTI_LINE_NONE: UInt32 = 0x00000000
public let LL_EXTI_MODE_IT: UInt8 = 0x00000000
public let LL_EXTI_MODE_EVENT: UInt8 = 0x00000001
public let LL_EXTI_MODE_IT_EVENT: UInt8 = 0x00000002
public let LL_EXTI_TRIGGER_NONE: UInt8 = 0x00000000
public let LL_EXTI_TRIGGER_RISING: UInt8 = 0x00000001
public let LL_EXTI_TRIGGER_FALLING: UInt8 = 0x00000002
public let LL_EXTI_TRIGGER_RISING_FALLING: UInt8 = 0x00000003

public func LL_EXTI_EnableIT_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.interruptMask(bank: 0), value: registers.read(.interruptMask(bank: 0)) | (ExtiLine))
}

public func LL_EXTI_EnableIT_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.interruptMask(bank: 1), value: registers.read(.interruptMask(bank: 1)) | (ExtiLine))
}

public func LL_EXTI_EnableIT_64_95<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.interruptMask(bank: 2), value: registers.read(.interruptMask(bank: 2)) | (ExtiLine))
}

public func LL_EXTI_DisableIT_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.interruptMask(bank: 0), value: registers.read(.interruptMask(bank: 0)) & ~(ExtiLine))
}

public func LL_EXTI_DisableIT_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.interruptMask(bank: 1), value: registers.read(.interruptMask(bank: 1)) & ~(ExtiLine))
}

public func LL_EXTI_DisableIT_64_95<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.interruptMask(bank: 2), value: registers.read(.interruptMask(bank: 2)) & ~(ExtiLine))
}

public func LL_EXTI_IsEnabledIT_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.interruptMask(bank: 0)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_IsEnabledIT_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.interruptMask(bank: 1)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_IsEnabledIT_64_95<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.interruptMask(bank: 2)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_EnableEvent_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.eventMask(bank: 0), value: registers.read(.eventMask(bank: 0)) | (ExtiLine))
}

public func LL_EXTI_EnableEvent_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.eventMask(bank: 1), value: registers.read(.eventMask(bank: 1)) | (ExtiLine))
}

public func LL_EXTI_EnableEvent_64_95<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.eventMask(bank: 2), value: registers.read(.eventMask(bank: 2)) | (ExtiLine))
}

public func LL_EXTI_DisableEvent_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.eventMask(bank: 0), value: registers.read(.eventMask(bank: 0)) & ~(ExtiLine))
}

public func LL_EXTI_DisableEvent_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.eventMask(bank: 1), value: registers.read(.eventMask(bank: 1)) & ~(ExtiLine))
}

public func LL_EXTI_DisableEvent_64_95<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.eventMask(bank: 2), value: registers.read(.eventMask(bank: 2)) & ~(ExtiLine))
}

public func LL_EXTI_IsEnabledEvent_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.eventMask(bank: 0)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_IsEnabledEvent_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.eventMask(bank: 1)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_IsEnabledEvent_64_95<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.eventMask(bank: 2)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_EnableRisingTrig_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.risingTrigger(bank: 0), value: registers.read(.risingTrigger(bank: 0)) | (ExtiLine))
}

public func LL_EXTI_EnableRisingTrig_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.risingTrigger(bank: 1), value: registers.read(.risingTrigger(bank: 1)) | (ExtiLine))
}

public func LL_EXTI_DisableRisingTrig_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.risingTrigger(bank: 0), value: registers.read(.risingTrigger(bank: 0)) & ~(ExtiLine))
}

public func LL_EXTI_DisableRisingTrig_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.risingTrigger(bank: 1), value: registers.read(.risingTrigger(bank: 1)) & ~(ExtiLine))
}

public func LL_EXTI_IsEnabledRisingTrig_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.risingTrigger(bank: 0)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_IsEnabledRisingTrig_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.risingTrigger(bank: 1)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_EnableFallingTrig_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.fallingTrigger(bank: 0), value: registers.read(.fallingTrigger(bank: 0)) | (ExtiLine))
}

public func LL_EXTI_EnableFallingTrig_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.fallingTrigger(bank: 1), value: registers.read(.fallingTrigger(bank: 1)) | (ExtiLine))
}

public func LL_EXTI_DisableFallingTrig_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.fallingTrigger(bank: 0), value: registers.read(.fallingTrigger(bank: 0)) & ~(ExtiLine))
}

public func LL_EXTI_DisableFallingTrig_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.fallingTrigger(bank: 1), value: registers.read(.fallingTrigger(bank: 1)) & ~(ExtiLine))
}

public func LL_EXTI_IsEnabledFallingTrig_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.fallingTrigger(bank: 0)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_IsEnabledFallingTrig_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.fallingTrigger(bank: 1)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_GenerateSWI_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.softwareInterrupt(bank: 0), value: registers.read(.softwareInterrupt(bank: 0)) | (ExtiLine))
}

public func LL_EXTI_GenerateSWI_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.softwareInterrupt(bank: 1), value: registers.read(.softwareInterrupt(bank: 1)) | (ExtiLine))
}

public func LL_EXTI_IsActiveFlag_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.pending(bank: 0)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_IsActiveFlag_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return (((registers.read(.pending(bank: 1)) & (ExtiLine)) == (ExtiLine)) ? 1 : 0)
}

public func LL_EXTI_ReadFlag_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return ((registers.read(.pending(bank: 0)) & (ExtiLine)))
}

public func LL_EXTI_ReadFlag_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) -> UInt32 {
    return ((registers.read(.pending(bank: 1)) & (ExtiLine)))
}

public func LL_EXTI_ClearFlag_0_31<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.pending(bank: 0), value: ExtiLine)
}

public func LL_EXTI_ClearFlag_32_63<IO: EXTIRegisterIO>(_ registers: inout IO, _ ExtiLine: UInt32) {
    registers.write(.pending(bank: 1), value: ExtiLine)
}

public func LL_EXTI_WriteReg<IO: EXTIRegisterIO>(_ registers: inout IO, _ register: EXTIRegister, _ value: UInt32) {
    registers.write(register, value: value)
}

public func LL_EXTI_ReadReg<IO: EXTIRegisterIO>(_ registers: inout IO, _ register: EXTIRegister) -> UInt32 {
    registers.read(register)
}
