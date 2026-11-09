// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from stm32h7rsxx_ll_gpio.c / stm32h7rsxx_ll_exti.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// CMSIS encodings: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

// ErrorStatus encoding from the pinned STM32H7RS CMSIS device header.
public enum LLErrorStatus: UInt32, Sendable {
    case success = 0
    case error = 1
}

public struct LL_GPIO_InitTypeDef: Equatable, Sendable {
    public var Pin: UInt32
    public var Mode: UInt32
    public var Speed: UInt32
    public var OutputType: UInt32
    public var Pull: UInt32
    public var Alternate: UInt32

    public init(Pin: UInt32 = LL_GPIO_PIN_ALL, Mode: UInt32 = LL_GPIO_MODE_ANALOG,
                Speed: UInt32 = LL_GPIO_SPEED_FREQ_LOW, OutputType: UInt32 = LL_GPIO_OUTPUT_PUSHPULL,
                Pull: UInt32 = LL_GPIO_PULL_NO, Alternate: UInt32 = LL_GPIO_AF_0) {
        self.Pin = Pin; self.Mode = Mode; self.Speed = Speed
        self.OutputType = OutputType; self.Pull = Pull; self.Alternate = Alternate
    }
}

public func LL_GPIO_StructInit(_ configuration: inout LL_GPIO_InitTypeDef) {
    configuration = .init()
}

@discardableResult
public func LL_GPIO_Init<IO: GPIORegisterIO>(_ registers: inout IO, _ configuration: LL_GPIO_InitTypeDef) -> LLErrorStatus {
    // The C loop requires a nonzero 16-bit pin selection to avoid invalid shifts.
    precondition(configuration.Pin != 0 && configuration.Pin <= LL_GPIO_PIN_ALL)
    var pinpos = UInt32(configuration.Pin.trailingZeroBitCount)
    while (configuration.Pin >> pinpos) != 0 {
        let currentpin = configuration.Pin & (UInt32(1) << pinpos)
        if currentpin != 0 {
            if configuration.Mode == LL_GPIO_MODE_OUTPUT || configuration.Mode == LL_GPIO_MODE_ALTERNATE {
                LL_GPIO_SetPinSpeed(&registers, currentpin, configuration.Speed)
                LL_GPIO_SetPinOutputType(&registers, currentpin, configuration.OutputType)
            }
            LL_GPIO_SetPinPull(&registers, currentpin, configuration.Pull)
            if configuration.Mode == LL_GPIO_MODE_ALTERNATE {
                if currentpin < LL_GPIO_PIN_8 {
                    LL_GPIO_SetAFPin_0_7(&registers, currentpin, configuration.Alternate)
                } else {
                    LL_GPIO_SetAFPin_8_15(&registers, currentpin, configuration.Alternate)
                }
            }
            LL_GPIO_SetPinMode(&registers, currentpin, configuration.Mode)
        }
        pinpos &+= 1
    }
    return .success
}

@discardableResult
public func LL_GPIO_DeInit<IO: LLBusRegisterIO>(_ registers: inout IO, _ port: GPIOPort?) -> LLErrorStatus {
    // A missing port represents the C unknown-instance error path.
    guard let port else { return .error }
    let mask = UInt32(1) << port.rawValue
    LL_AHB4_GRP1_ForceReset(&registers, mask)
    LL_AHB4_GRP1_ReleaseReset(&registers, mask)
    return .success
}

public struct LL_EXTI_InitTypeDef: Equatable, Sendable {
    public var Line_0_31: UInt32
    public var Line_32_63: UInt32
    public var Line_64_95: UInt32
    public var LineCommand: UInt32
    public var Mode: UInt8
    public var Trigger: UInt8

    public init(Line_0_31: UInt32 = LL_EXTI_LINE_NONE, Line_32_63: UInt32 = LL_EXTI_LINE_NONE,
                Line_64_95: UInt32 = LL_EXTI_LINE_NONE, LineCommand: UInt32 = 0,
                Mode: UInt8 = LL_EXTI_MODE_IT, Trigger: UInt8 = LL_EXTI_TRIGGER_FALLING) {
        self.Line_0_31 = Line_0_31; self.Line_32_63 = Line_32_63; self.Line_64_95 = Line_64_95
        self.LineCommand = LineCommand; self.Mode = Mode; self.Trigger = Trigger
    }
}

public func LL_EXTI_StructInit(_ configuration: inout LL_EXTI_InitTypeDef) {
    configuration = .init()
}

@discardableResult
public func LL_EXTI_DeInit<IO: EXTIRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    LL_EXTI_WriteReg(&registers, .interruptMask(bank: 0), 0xFFC00000)
    LL_EXTI_WriteReg(&registers, .eventMask(bank: 0), 0)
    LL_EXTI_WriteReg(&registers, .risingTrigger(bank: 0), 0)
    LL_EXTI_WriteReg(&registers, .fallingTrigger(bank: 0), 0)
    LL_EXTI_WriteReg(&registers, .pending(bank: 0), 0x003FFFFF)
    LL_EXTI_WriteReg(&registers, .interruptMask(bank: 1), 0xFFB5BFFB)
    LL_EXTI_WriteReg(&registers, .eventMask(bank: 1), 0)
    LL_EXTI_WriteReg(&registers, .risingTrigger(bank: 1), 0)
    LL_EXTI_WriteReg(&registers, .fallingTrigger(bank: 1), 0)
    LL_EXTI_WriteReg(&registers, .pending(bank: 1), 0x004A4004)
    LL_EXTI_WriteReg(&registers, .interruptMask(bank: 2), 0x00003FFF)
    LL_EXTI_WriteReg(&registers, .eventMask(bank: 2), 0)
    return .success
}

@discardableResult
public func LL_EXTI_Init<IO: EXTIRegisterIO>(_ registers: inout IO, _ configuration: LL_EXTI_InitTypeDef) -> LLErrorStatus {
    var status = LLErrorStatus.success
    if configuration.LineCommand != 0 {
        // Process banks in the original order, retaining writes before an error.
        for bank in 0..<3 {
            let line = bank == 0 ? configuration.Line_0_31 : bank == 1 ? configuration.Line_32_63 : configuration.Line_64_95
            if line == LL_EXTI_LINE_NONE { continue }
            switch configuration.Mode {
            case LL_EXTI_MODE_IT:
                registers.write(.eventMask(bank: bank), value: registers.read(.eventMask(bank: bank)) & ~line)
                registers.write(.interruptMask(bank: bank), value: registers.read(.interruptMask(bank: bank)) | line)
            case LL_EXTI_MODE_EVENT:
                registers.write(.interruptMask(bank: bank), value: registers.read(.interruptMask(bank: bank)) & ~line)
                registers.write(.eventMask(bank: bank), value: registers.read(.eventMask(bank: bank)) | line)
            case LL_EXTI_MODE_IT_EVENT:
                registers.write(.interruptMask(bank: bank), value: registers.read(.interruptMask(bank: bank)) | line)
                registers.write(.eventMask(bank: bank), value: registers.read(.eventMask(bank: bank)) | line)
            default: status = .error
            }
            if configuration.Trigger != LL_EXTI_TRIGGER_NONE {
                if bank == 2 {
                    status = .error
                } else {
                    switch configuration.Trigger {
                    case LL_EXTI_TRIGGER_RISING:
                        registers.write(.fallingTrigger(bank: bank), value: registers.read(.fallingTrigger(bank: bank)) & ~line)
                        registers.write(.risingTrigger(bank: bank), value: registers.read(.risingTrigger(bank: bank)) | line)
                    case LL_EXTI_TRIGGER_FALLING:
                        registers.write(.risingTrigger(bank: bank), value: registers.read(.risingTrigger(bank: bank)) & ~line)
                        registers.write(.fallingTrigger(bank: bank), value: registers.read(.fallingTrigger(bank: bank)) | line)
                    case LL_EXTI_TRIGGER_RISING_FALLING:
                        registers.write(.risingTrigger(bank: bank), value: registers.read(.risingTrigger(bank: bank)) | line)
                        registers.write(.fallingTrigger(bank: bank), value: registers.read(.fallingTrigger(bank: bank)) | line)
                    default: status = .error
                    }
                }
            }
        }
    } else {
        LL_EXTI_DisableIT_0_31(&registers, configuration.Line_0_31)
        LL_EXTI_DisableEvent_0_31(&registers, configuration.Line_0_31)
        LL_EXTI_DisableIT_32_63(&registers, configuration.Line_32_63)
        LL_EXTI_DisableEvent_32_63(&registers, configuration.Line_32_63)
        LL_EXTI_DisableIT_64_95(&registers, configuration.Line_64_95)
        LL_EXTI_DisableEvent_64_95(&registers, configuration.Line_64_95)
    }
    return status
}
