// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_gpio.c/.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum GPIOPort: UInt32, CaseIterable {
    case a = 0, b = 1, c = 2, d = 3, e = 4, f = 5, g = 6, h = 7
    case m = 12, n = 13, o = 14, p = 15
}

public enum GPIOMode: UInt32, CaseIterable {
    case input = 0x00000000
    case outputPushPull = 0x00000001
    case outputOpenDrain = 0x00000011
    case alternatePushPull = 0x00000002
    case alternateOpenDrain = 0x00000012
    case analog = 0x00000003
    case interruptRising = 0x00110000
    case interruptFalling = 0x00210000
    case interruptRisingFalling = 0x00310000
    case eventRising = 0x00120000
    case eventFalling = 0x00220000
    case eventRisingFalling = 0x00320000
}

public enum GPIOPull: UInt32, CaseIterable {
    case none = 0, up = 1, down = 2
}

public enum GPIOSpeed: UInt32, CaseIterable {
    case low = 0, medium = 1, high = 2, veryHigh = 3
}

public enum GPIOPinState: UInt32 { case reset = 0, set = 1 }

public struct GPIOConfiguration {
    public var pins: UInt16
    public var mode: GPIOMode
    public var pull: GPIOPull
    public var speed: GPIOSpeed
    public var alternate: UInt32

    public init(pins: UInt16, mode: GPIOMode, pull: GPIOPull = .none,
                speed: GPIOSpeed = .low, alternate: UInt32 = 0) {
        self.pins = pins
        self.mode = mode
        self.pull = pull
        self.speed = speed
        self.alternate = alternate
    }
}

public enum GPIORegister: Hashable {
    case moder, otyper, ospeedr, pupdr, idr, odr, bsrr, brr, lckr
    case alternateFunction(index: Int), extiConfiguration(index: Int)
    case extiRisingTrigger, extiFallingTrigger, extiEventMask, extiInterruptMask
    case extiPending, extiSoftwareInterrupt
}

// Each operation must perform exactly one volatile 32-bit register access.
public protocol GPIORegisterIO {
    mutating func read(_ register: GPIORegister) -> UInt32
    mutating func write(_ register: GPIORegister, value: UInt32)
}

// The caller owns peripheral clocks and synchronization, as in the C HAL.
public struct GPIO<IO: GPIORegisterIO> {
    public var registers: IO
    public let port: GPIOPort

    public init(registers: IO, port: GPIOPort) {
        self.registers = registers
        self.port = port
    }

    // HAL_GPIO_Init. Preconditions correspond to the C HAL's assert_param checks.
    public mutating func initialize(_ configuration: GPIOConfiguration) {
        precondition(configuration.pins != 0)
        let pins = UInt32(configuration.pins)
        let mode = configuration.mode.rawValue
        var position: UInt32 = 0
        while (pins >> position) != 0 {
            let current = pins & (1 << position)
            if current != 0 {
                if (mode & 3) == 1 || (mode & 3) == 2 {
                    var temp = registers.read(.ospeedr)
                    temp &= ~(3 << (position * 2))
                    temp |= configuration.speed.rawValue << (position * 2)
                    registers.write(.ospeedr, value: temp)

                    temp = registers.read(.otyper)
                    temp &= ~(1 << position)
                    temp |= ((mode & 0x10) >> 4) << position
                    registers.write(.otyper, value: temp)
                }

                // Preserve the upstream analog + pull-up exception.
                if (mode & 3) != 3 || ((mode & 3) == 3 && configuration.pull != .up) {
                    var temp = registers.read(.pupdr)
                    temp &= ~(3 << (position * 2))
                    temp |= configuration.pull.rawValue << (position * 2)
                    registers.write(.pupdr, value: temp)
                }

                if (mode & 3) == 2 {
                    precondition(configuration.alternate <= 15)
                    let register = GPIORegister.alternateFunction(index: Int(position >> 3))
                    var temp = registers.read(register)
                    temp &= ~(0xF << ((position & 7) * 4))
                    temp |= configuration.alternate << ((position & 7) * 4)
                    registers.write(register, value: temp)
                }

                var temp = registers.read(.moder)
                temp &= ~(3 << (position * 2))
                temp |= (mode & 3) << (position * 2)
                registers.write(.moder, value: temp)

                if (mode & 0x00030000) != 0 {
                    let register = GPIORegister.extiConfiguration(index: Int(position >> 2))
                    temp = registers.read(register)
                    temp &= ~(0xF << ((position & 3) * 4))
                    temp |= port.rawValue << ((position & 3) * 4)
                    registers.write(register, value: temp)

                    temp = registers.read(.extiRisingTrigger)
                    temp &= ~current
                    if (mode & 0x00100000) != 0 { temp |= current }
                    registers.write(.extiRisingTrigger, value: temp)

                    temp = registers.read(.extiFallingTrigger)
                    temp &= ~current
                    if (mode & 0x00200000) != 0 { temp |= current }
                    registers.write(.extiFallingTrigger, value: temp)

                    temp = registers.read(.extiEventMask)
                    temp &= ~current
                    if (mode & 0x00020000) != 0 { temp |= current }
                    registers.write(.extiEventMask, value: temp)

                    temp = registers.read(.extiInterruptMask)
                    temp &= ~current
                    if (mode & 0x00010000) != 0 { temp |= current }
                    registers.write(.extiInterruptMask, value: temp)
                }
            }
            position += 1
        }
    }

    // HAL_GPIO_DeInit.
    public mutating func deinitialize(pins: UInt16) {
        precondition(pins != 0)
        let pins = UInt32(pins)
        var position: UInt32 = 0
        while (pins >> position) != 0 {
            let current = pins & (1 << position)
            if current != 0 {
                let register = GPIORegister.extiConfiguration(index: Int(position >> 2))
                var temp = registers.read(register)
                temp &= 0xF << ((position & 3) * 4)
                if temp == (port.rawValue << ((position & 3) * 4)) {
                    clear(.extiInterruptMask, bits: current)
                    clear(.extiEventMask, bits: current)
                    clear(.extiFallingTrigger, bits: current)
                    clear(.extiRisingTrigger, bits: current)
                    clear(register, bits: 0xF << ((position & 3) * 4))
                }
                temp = registers.read(.moder)
                temp |= 3 << (position * 2)
                registers.write(.moder, value: temp)
                clear(.alternateFunction(index: Int(position >> 3)), bits: 0xF << ((position & 7) * 4))
                clear(.ospeedr, bits: 3 << (position * 2))
                clear(.otyper, bits: 1 << position)
                clear(.pupdr, bits: 3 << (position * 2))
            }
            position += 1
        }
    }

    // HAL_GPIO_ReadPin returns SET when any selected input is set.
    public mutating func readPin(_ pins: UInt16) -> GPIOPinState {
        precondition(pins != 0)
        return (registers.read(.idr) & UInt32(pins)) != 0 ? .set : .reset
    }

    // HAL_GPIO_WritePin uses BRR for reset on this MCU family.
    public mutating func writePin(_ pins: UInt16, state: GPIOPinState) {
        precondition(pins != 0)
        registers.write(state != .reset ? .bsrr : .brr, value: UInt32(pins))
    }

    public mutating func writeMultipleStatePin(reset: UInt16, set: UInt16) {
        precondition((reset | set) != 0 && (reset & set) == 0)
        registers.write(.bsrr, value: (UInt32(reset) << 16) | UInt32(set))
    }

    public mutating func togglePin(_ pins: UInt16) {
        precondition(pins != 0)
        let odr = registers.read(.odr)
        registers.write(.bsrr, value: ((odr & UInt32(pins)) << 16) | (~odr & UInt32(pins)))
    }

    public mutating func lockPin(_ pins: UInt16) -> HALStatus {
        precondition(pins != 0)
        let temp = UInt32(0x00010000) | UInt32(pins)
        registers.write(.lckr, value: temp)
        registers.write(.lckr, value: UInt32(pins))
        registers.write(.lckr, value: temp)
        _ = registers.read(.lckr)
        return (registers.read(.lckr) & 0x00010000) != 0 ? .ok : .error
    }

    public mutating func extiIRQHandler(_ pins: UInt16, callback: (UInt16) -> Void) {
        if (registers.read(.extiPending) & UInt32(pins)) != 0 {
            registers.write(.extiPending, value: UInt32(pins))
            callback(pins)
        }
    }

    public mutating func extiGetFlag(_ pins: UInt16) -> UInt32 {
        registers.read(.extiPending) & UInt32(pins)
    }

    public mutating func extiClearFlag(_ pins: UInt16) {
        registers.write(.extiPending, value: UInt32(pins))
    }

    public mutating func extiGenerateSoftwareInterrupt(_ pins: UInt16) {
        registers.write(.extiSoftwareInterrupt, value: UInt32(pins))
    }

    private mutating func clear(_ register: GPIORegister, bits: UInt32) {
        let value = registers.read(register) & ~bits
        registers.write(register, value: value)
    }
}
