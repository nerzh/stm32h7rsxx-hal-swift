// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_pwr.c/.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum PowerPVDLevel: UInt32, CaseIterable {
    case level1 = 0x00, level2 = 0x20, level3 = 0x40, level4 = 0x60
    case level5 = 0x80, level6 = 0xA0, level7 = 0xC0, externalVoltage = 0xE0
}

public enum PowerPVDMode: UInt32, CaseIterable {
    case normal = 0x00000000
    case interruptRising = 0x00010001
    case interruptFalling = 0x00010002
    case interruptRisingFalling = 0x00010003
    case eventRising = 0x00020001
    case eventFalling = 0x00020002
    case eventRisingFalling = 0x00020003
}

public struct PowerPVDConfiguration {
    public var level: PowerPVDLevel
    public var mode: PowerPVDMode

    public init(level: PowerPVDLevel, mode: PowerPVDMode) {
        self.level = level
        self.mode = mode
    }
}

public enum PowerWakeUpPin: UInt32, CaseIterable {
    case pin1High = 0x0001, pin2High = 0x0002, pin3High = 0x0004, pin4High = 0x0008
    case pin1Low = 0x0101, pin2Low = 0x0202, pin3Low = 0x0404, pin4Low = 0x0808
}

// SLEEPENTRY and STOPENTRY have the same three values in the C HAL.
public enum PowerEntry: UInt8, CaseIterable {
    case waitForInterrupt = 1
    case waitForEvent = 2
    case waitForEventWithoutClearing = 3
}

public enum PowerRegister: Hashable {
    case cr1, csr3, wakeupEnablePolarity, systemControl
    case extiInterruptMask, extiEventMask, extiRisingTrigger, extiFallingTrigger
}

// Each read/write must perform exactly one volatile 32-bit register access.
public protocol PowerRegisterIO {
    mutating func read(_ register: PowerRegister) -> UInt32
    mutating func write(_ register: PowerRegister, value: UInt32)
    mutating func dataSynchronizationBarrier()
    mutating func instructionSynchronizationBarrier()
    mutating func waitForInterrupt()
    mutating func sendEvent()
    mutating func waitForEvent()
}

public struct Power<IO: PowerRegisterIO> {
    public var registers: IO

    public init(registers: IO) {
        self.registers = registers
    }

    // HAL_PWR_DeInit is intentionally empty on STM32H7RS.
    public mutating func deinitialize() {}

    public mutating func enableBackupAccess() {
        set(.cr1, bits: 1 << 8) // PWR_CR1_DBP
    }

    public mutating func disableBackupAccess() {
        clear(.cr1, bits: 1 << 8)
    }

    // PVD and AVD share EXTI line 16; this replaces its previous configuration.
    public mutating func configurePVD(_ configuration: PowerPVDConfiguration?) {
        guard let configuration else { return }
        let mode = configuration.mode.rawValue
        let value = (registers.read(.cr1) & ~(UInt32(7) << 5)) | configuration.level.rawValue
        registers.write(.cr1, value: value)

        clear(.extiEventMask, bits: 1 << 16)
        clear(.extiInterruptMask, bits: 1 << 16)
        clear(.extiRisingTrigger, bits: 1 << 16)
        clear(.extiFallingTrigger, bits: 1 << 16)

        if (mode & 0x00010000) == 0x00010000 {
            set(.extiInterruptMask, bits: 1 << 16)
        }
        if (mode & 0x00020000) == 0x00020000 {
            set(.extiEventMask, bits: 1 << 16)
        }
        if (mode & 0x00000001) == 0x00000001 {
            set(.extiRisingTrigger, bits: 1 << 16)
        }
        if (mode & 0x00000002) == 0x00000002 {
            set(.extiFallingTrigger, bits: 1 << 16)
        }
    }

    public mutating func enablePVD() {
        set(.cr1, bits: 1 << 4) // PWR_CR1_PVDE
    }

    public mutating func disablePVD() {
        clear(.cr1, bits: 1 << 4)
    }

    public mutating func enableWakeUpPin(_ pin: PowerWakeUpPin) {
        // Preserve the C HAL's replacement of ALL enable and polarity bits.
        let value = (registers.read(.wakeupEnablePolarity) & ~(UInt32(0xF) | (0xF << 8)))
            | pin.rawValue
        registers.write(.wakeupEnablePolarity, value: value)
    }

    public mutating func disableWakeUpPin(_ pin: PowerWakeUpPin) {
        clear(.wakeupEnablePolarity, bits: 0xF & pin.rawValue)
    }

    // The regulator argument is ignored without validation, as in the C HAL.
    public mutating func enterSleepMode(regulator _: UInt32 = 0, entry: PowerEntry) {
        clear(.systemControl, bits: 1 << 2) // SCB_SCR_SLEEPDEEP
        if entry == .waitForInterrupt {
            registers.waitForInterrupt()
        } else {
            if entry != .waitForEventWithoutClearing {
                registers.sendEvent()
                registers.waitForEvent()
            }
            registers.waitForEvent()
        }
    }

    // The regulator argument is ignored without validation, as in the C HAL.
    public mutating func enterStopMode(regulator _: UInt32 = 0, entry: PowerEntry) {
        clear(.csr3, bits: 1 << 0) // PWR_CSR3_PDDS
        set(.systemControl, bits: 1 << 2)
        registers.dataSynchronizationBarrier()
        registers.instructionSynchronizationBarrier()

        if entry == .waitForInterrupt {
            registers.waitForInterrupt()
        } else {
            if entry != .waitForEventWithoutClearing {
                registers.sendEvent()
                registers.waitForEvent()
            }
            registers.waitForEvent()
        }

        clear(.systemControl, bits: 1 << 2)
    }

    public mutating func enterStandbyMode() {
        set(.csr3, bits: 1 << 0)
        set(.systemControl, bits: 1 << 2)
        registers.dataSynchronizationBarrier()
        registers.instructionSynchronizationBarrier()
        registers.waitForInterrupt()
    }

    public mutating func enableSleepOnExit() {
        set(.systemControl, bits: 1 << 1) // SCB_SCR_SLEEPONEXIT
    }

    public mutating func disableSleepOnExit() {
        clear(.systemControl, bits: 1 << 1)
    }

    public mutating func enableSEVOnPend() {
        set(.systemControl, bits: 1 << 4) // SCB_SCR_SEVONPEND
    }

    public mutating func disableSEVOnPend() {
        clear(.systemControl, bits: 1 << 4)
    }

    private mutating func set(_ register: PowerRegister, bits: UInt32) {
        let value = registers.read(register) | bits
        registers.write(register, value: value)
    }

    private mutating func clear(_ register: PowerRegister, bits: UInt32) {
        let value = registers.read(register) & ~bits
        registers.write(register, value: value)
    }
}
