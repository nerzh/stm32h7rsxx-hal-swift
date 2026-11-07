// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Swift port of stm32h7rsxx_hal_exti.c / stm32h7rsxx_hal_exti.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt for license terms.

public enum EXTIRegister: Hashable {
    // Bank and GPIO selection indices are zero-based.
    case risingTrigger(bank: Int)
    case fallingTrigger(bank: Int)
    case softwareInterrupt(bank: Int)
    case interruptMask(bank: Int)
    case eventMask(bank: Int)
    case pending(bank: Int)
    case gpioSelection(index: Int)
}

public protocol EXTIRegisterIO {
    mutating func read(_ register: EXTIRegister) -> UInt32
    mutating func write(_ register: EXTIRegister, value: UInt32)
}

public struct EXTILine: Equatable, Sendable {
    public let rawValue: UInt32

    // C assert_param(IS_EXTI_LINE) is a precondition in the Swift API.
    public init(rawValue: UInt32) {
        let properties = rawValue & 0x0700_0000
        precondition(
            (rawValue & ~UInt32(0x1703_001F)) == 0 &&
            (properties == 0x0100_0000 || properties == 0x0200_0000 || properties == 0x0600_0000) &&
            ((rawValue & 0x0003_001F) < 0x0002_000E || (rawValue & 0x0003_001F) == 0x0002_000D)
        )
        self.rawValue = rawValue
    }

    var bank: Int { Int((rawValue & 0x0003_0000) >> 16) }
    var position: UInt32 { rawValue & 0x1F }
    var mask: UInt32 { 1 << position }
    var isConfigurable: Bool { (rawValue & 0x0200_0000) != 0 }
    var isGPIO: Bool { (rawValue & 0x0600_0000) == 0x0600_0000 }
}

public struct EXTIMode: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let interrupt = Self(rawValue: 0x01)
    public static let event = Self(rawValue: 0x02)
}

public struct EXTITrigger: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let rising = Self(rawValue: 0x01)
    public static let falling = Self(rawValue: 0x02)
}

public struct EXTIConfiguration: Equatable, Sendable {
    public var line: EXTILine
    public var mode: EXTIMode
    public var trigger: EXTITrigger
    public var gpioSelection: UInt32

    public init(line: EXTILine, mode: EXTIMode, trigger: EXTITrigger = [], gpioSelection: UInt32 = 0) {
        self.line = line
        self.mode = mode
        self.trigger = trigger
        self.gpioSelection = gpioSelection
    }
}

// A value-type handle replaces the nullable C handle/configuration pointers.
// A callback may be nil, as in EXTI_HandleTypeDef.PendingCallback.
public struct EXTI<IO: EXTIRegisterIO> {
    public var registers: IO
    public private(set) var line: EXTILine
    private var pendingCallback: (() -> Void)?

    public init(registers: IO, line: EXTILine) {
        self.registers = registers
        self.line = line
        self.pendingCallback = nil
    }

    @discardableResult
    public mutating func setConfigLine(_ configuration: EXTIConfiguration) -> HALStatus {
        precondition((configuration.mode.rawValue & 3) != 0 && (configuration.mode.rawValue & ~UInt32(3)) == 0)
        line = configuration.line
        let bank = line.bank
        let position = line.position
        let mask = line.mask
        var value: UInt32

        if line.isConfigurable {
            precondition((configuration.trigger.rawValue & ~UInt32(3)) == 0)
            value = registers.read(.risingTrigger(bank: bank))
            if (configuration.trigger.rawValue & 1) != 0 {
                value |= mask
            } else {
                value &= ~mask
            }
            registers.write(.risingTrigger(bank: bank), value: value)

            value = registers.read(.fallingTrigger(bank: bank))
            if (configuration.trigger.rawValue & 2) != 0 {
                value |= mask
            } else {
                value &= ~mask
            }
            registers.write(.fallingTrigger(bank: bank), value: value)

            if line.isGPIO {
                precondition(configuration.gpioSelection <= 7 || (configuration.gpioSelection >= 12 && configuration.gpioSelection <= 15))
                precondition(position < 16)
                value = registers.read(.gpioSelection(index: Int(position >> 2)))
                value &= ~(0xF << (4 * (position & 3)))
                value |= configuration.gpioSelection << (4 * (position & 3))
                registers.write(.gpioSelection(index: Int(position >> 2)), value: value)
            }
        }

        value = registers.read(.interruptMask(bank: bank))
        if (configuration.mode.rawValue & 1) != 0 {
            value |= mask
        } else {
            value &= ~mask
        }
        registers.write(.interruptMask(bank: bank), value: value)

        precondition((line.rawValue & 0x1000_0000) == 0x1000_0000 || (configuration.mode.rawValue & 2) != 2)
        value = registers.read(.eventMask(bank: bank))
        if (configuration.mode.rawValue & 2) != 0 {
            value |= mask
        } else {
            value &= ~mask
        }
        registers.write(.eventMask(bank: bank), value: value)
        return .ok
    }

    public mutating func getConfigLine() -> EXTIConfiguration {
        let bank = line.bank
        let position = line.position
        let mask = line.mask
        var configuration = EXTIConfiguration(line: line, mode: [])
        var value = registers.read(.interruptMask(bank: bank))
        if (value & mask) != 0 {
            configuration.mode = .interrupt
        }
        value = registers.read(.eventMask(bank: bank))
        if (value & mask) != 0 {
            configuration.mode = EXTIMode(rawValue: configuration.mode.rawValue | 2)
        }

        if line.isConfigurable {
            value = registers.read(.risingTrigger(bank: bank))
            if (value & mask) != 0 {
                configuration.trigger = .rising
            }
            value = registers.read(.fallingTrigger(bank: bank))
            if (value & mask) != 0 {
                configuration.trigger = EXTITrigger(rawValue: configuration.trigger.rawValue | 2)
            }
            if line.isGPIO {
                precondition(position < 16)
                value = registers.read(.gpioSelection(index: Int(position >> 2)))
                configuration.gpioSelection = (value >> (4 * (position & 3))) & 0xF
            }
        }
        return configuration
    }

    @discardableResult
    public mutating func clearConfigLine() -> HALStatus {
        let bank = line.bank
        let mask = line.mask
        var value = registers.read(.interruptMask(bank: bank)) & ~mask
        registers.write(.interruptMask(bank: bank), value: value)
        value = registers.read(.eventMask(bank: bank)) & ~mask
        registers.write(.eventMask(bank: bank), value: value)

        if line.isConfigurable {
            value = registers.read(.risingTrigger(bank: bank)) & ~mask
            registers.write(.risingTrigger(bank: bank), value: value)
            value = registers.read(.fallingTrigger(bank: bank)) & ~mask
            registers.write(.fallingTrigger(bank: bank), value: value)
            if line.isGPIO {
                let position = line.position
                precondition(position < 16)
                value = registers.read(.gpioSelection(index: Int(position >> 2)))
                value &= ~(0xF << (4 * (position & 3)))
                registers.write(.gpioSelection(index: Int(position >> 2)), value: value)
            }
        }
        return .ok
    }

    @discardableResult
    public mutating func registerCallback(id: UInt32 = 0, _ callback: (() -> Void)?) -> HALStatus {
        switch id {
        case 0:
            pendingCallback = callback
            return .ok
        default:
            return .error
        }
    }

    @discardableResult
    public mutating func getHandle(line: EXTILine) -> HALStatus {
        self.line = line
        return .ok
    }

    // HAL_EXTI_IRQHandler. Use this for configurable lines with a pending register.
    // Direct lines are acknowledged by their originating peripheral. In particular,
    // line 77 has IMR3/EMR3 but no PR3; the C pointer arithmetic is not evidence
    // that a hardware pending register exists for that line.
    public mutating func irqHandler() {
        let mask = line.mask
        let register = EXTIRegister.pending(bank: line.bank)
        let value = registers.read(register) & mask
        if value != 0 {
            registers.write(register, value: mask)
            pendingCallback?()
        }
    }

    public mutating func getPending(edge: UInt32 = 3) -> UInt32 {
        precondition(line.isConfigurable)
        // Edge is ignored by the H7RS C driver; PRx does not distinguish edges.
        return (registers.read(.pending(bank: line.bank)) & line.mask) >> line.position
    }

    public mutating func clearPending(edge: UInt32 = 3) {
        precondition(line.isConfigurable)
        registers.write(.pending(bank: line.bank), value: line.mask)
    }

    public mutating func generateSWI() {
        precondition(line.isConfigurable)
        registers.write(.softwareInterrupt(bank: line.bank), value: line.mask)
    }
}

extension EXTILine {
    public static let line0 = Self(rawValue: 0x16000000)
    public static let line1 = Self(rawValue: 0x16000001)
    public static let line2 = Self(rawValue: 0x16000002)
    public static let line3 = Self(rawValue: 0x16000003)
    public static let line4 = Self(rawValue: 0x16000004)
    public static let line5 = Self(rawValue: 0x16000005)
    public static let line6 = Self(rawValue: 0x16000006)
    public static let line7 = Self(rawValue: 0x16000007)
    public static let line8 = Self(rawValue: 0x16000008)
    public static let line9 = Self(rawValue: 0x16000009)
    public static let line10 = Self(rawValue: 0x1600000A)
    public static let line11 = Self(rawValue: 0x1600000B)
    public static let line12 = Self(rawValue: 0x1600000C)
    public static let line13 = Self(rawValue: 0x1600000D)
    public static let line14 = Self(rawValue: 0x1600000E)
    public static let line15 = Self(rawValue: 0x1600000F)
    public static let line16 = Self(rawValue: 0x12000010)
    public static let line17 = Self(rawValue: 0x12000011)
    public static let line18 = Self(rawValue: 0x12000012)
    public static let line19 = Self(rawValue: 0x12000013)
    public static let line20 = Self(rawValue: 0x12000014)
    public static let line21 = Self(rawValue: 0x12000015)
    public static let line22 = Self(rawValue: 0x11000016)
    public static let line23 = Self(rawValue: 0x11000017)
    public static let line24 = Self(rawValue: 0x11000018)
    public static let line25 = Self(rawValue: 0x11000019)
    public static let line26 = Self(rawValue: 0x1100001A)
    public static let line27 = Self(rawValue: 0x1100001B)
    public static let line28 = Self(rawValue: 0x1100001C)
    public static let line30 = Self(rawValue: 0x1100001E)
    public static let line31 = Self(rawValue: 0x1100001F)
    public static let line32 = Self(rawValue: 0x11010000)
    public static let line33 = Self(rawValue: 0x11010001)
    public static let line34 = Self(rawValue: 0x12010002)
    public static let line35 = Self(rawValue: 0x11010003)
    public static let line36 = Self(rawValue: 0x11010004)
    public static let line37 = Self(rawValue: 0x11010005)
    public static let line38 = Self(rawValue: 0x11010006)
    public static let line39 = Self(rawValue: 0x11010007)
    public static let line40 = Self(rawValue: 0x11010008)
    public static let line41 = Self(rawValue: 0x11010009)
    public static let line42 = Self(rawValue: 0x1101000A)
    public static let line43 = Self(rawValue: 0x1101000B)
    public static let line44 = Self(rawValue: 0x1101000C)
    public static let line45 = Self(rawValue: 0x1101000D)
    public static let line46 = Self(rawValue: 0x1201000E)
    public static let line47 = Self(rawValue: 0x1101000F)
    public static let line48 = Self(rawValue: 0x11010010)
    public static let line49 = Self(rawValue: 0x12010011)
    public static let line50 = Self(rawValue: 0x11010012)
    public static let line51 = Self(rawValue: 0x12010013)
    public static let line52 = Self(rawValue: 0x11010014)
    public static let line53 = Self(rawValue: 0x11010015)
    public static let line54 = Self(rawValue: 0x12010016)
    public static let line55 = Self(rawValue: 0x11010017)
    public static let line56 = Self(rawValue: 0x11010018)
    public static let line57 = Self(rawValue: 0x11010019)
    public static let line58 = Self(rawValue: 0x1101001A)
    public static let line59 = Self(rawValue: 0x1101001B)
    public static let line77 = Self(rawValue: 0x1102000D)
}
