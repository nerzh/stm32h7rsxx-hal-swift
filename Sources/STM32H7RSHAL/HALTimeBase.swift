// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum HALTickFrequency: UInt32, CaseIterable {
    case hertz10 = 100
    case hertz100 = 10
    case kilohertz1 = 1
}

public enum HALTimeBaseWord: Int {
    case tick = 0
    case priority = 1
    case frequency = 2
}

// Shared state is external to the value-type handle. Hardware implementations
// must use volatile accesses, including while an ISR updates the tick word.
public protocol HALTimeBaseIO {
    func read(_ word: HALTimeBaseWord) -> UInt32
    func write(_ word: HALTimeBaseWord, value: UInt32)
    func configureSysTick(ticks: UInt32) -> UInt32
    func setSysTickPriority(_ priority: UInt32)
    func readSysTickControl() -> UInt32
    func writeSysTickControl(_ value: UInt32)
}

public struct HALTimeBase<IO: HALTimeBaseIO> {
    public let registers: IO

    public init(registers: IO) {
        self.registers = registers
    }

    // SystemCoreClock is an explicit input instead of a CMSIS global variable.
    // Hardware setup precedes priority validation, including on failure, as in C.
    public func initializeTick(priority: UInt32, coreClockHz: UInt32) -> HALStatus {
        let frequency = registers.read(.frequency)
        if frequency != 0 {
            if registers.configureSysTick(ticks: coreClockHz / (1000 / frequency)) == 0 {
                if priority < (1 << 4) {
                    registers.setSysTickPriority(priority)
                    registers.write(.priority, value: priority)
                    return .ok
                }
            }
        }
        return .error
    }

    public func incrementTick() {
        let tick = registers.read(.tick)
        let frequency = registers.read(.frequency)
        registers.write(.tick, value: tick &+ frequency)
    }

    public func getTick() -> UInt32 { registers.read(.tick) }
    public func getTickPriority() -> UInt32 { registers.read(.priority) }
    public func getTickFrequency() -> HALTickFrequency {
        // Like the C enum, the stored value must be one of the three frequencies.
        HALTickFrequency(rawValue: registers.read(.frequency))!
    }

    public func setTickFrequency(_ frequency: HALTickFrequency, coreClockHz: UInt32) -> HALStatus {
        if registers.read(.frequency) != frequency.rawValue {
            let previous = registers.read(.frequency)
            registers.write(.frequency, value: frequency.rawValue)
            let status = initializeTick(priority: registers.read(.priority), coreClockHz: coreClockHz)
            if status != .ok {
                // The original restores only uwTickFreq, not the SysTick registers.
                registers.write(.frequency, value: previous)
            }
            return status
        }
        return .ok
    }

    public func delay(milliseconds: UInt32) {
        let start = getTick()
        var wait = milliseconds
        if wait < UInt32.max {
            wait &+= registers.read(.frequency)
        }
        while (getTick() &- start) < wait {}
    }

    public func suspendTick() {
        registers.writeSysTickControl(registers.readSysTickControl() & ~UInt32(1 << 1))
    }

    public func resumeTick() {
        registers.writeSysTickControl(registers.readSysTickControl() | (1 << 1))
    }
}
