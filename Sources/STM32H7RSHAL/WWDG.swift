// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_wwdg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum WWDGRegister: Hashable, CaseIterable { case cr, cfr, sr }
public protocol WWDGRegisterIO {
    func read(_ register: WWDGRegister) -> UInt32
    func write(_ register: WWDGRegister, value: UInt32)
}

public enum WWDGConfigurationWord: Int, CaseIterable {
    case prescaler = 0, window = 1, counter = 2, earlyWakeupMode = 3
}
public protocol WWDGConfigurationIO {
    func read(_ word: WWDGConfigurationWord) -> UInt32
    func write(_ word: WWDGConfigurationWord, value: UInt32)
}

public enum WWDGPrescaler: UInt32, CaseIterable, Sendable {
    case divide1 = 0, divide2 = 0x0800, divide4 = 0x1000, divide8 = 0x1800
    case divide16 = 0x2000, divide32 = 0x2800, divide64 = 0x3000, divide128 = 0x3800
}
public enum WWDGEarlyWakeupMode: UInt32, Sendable { case disabled = 0, enabled = 0x200 }

public struct WWDGConfiguration: Equatable, Sendable {
    public var prescaler: UInt32
    public var window: UInt32
    public var counter: UInt32
    public var earlyWakeupMode: UInt32

    public init(prescaler: UInt32, window: UInt32, counter: UInt32, earlyWakeupMode: UInt32 = 0) {
        self.prescaler = prescaler
        self.window = window
        self.counter = counter
        self.earlyWakeupMode = earlyWakeupMode
    }

    public func store<IO: WWDGConfigurationIO>(in storage: IO) {
        storage.write(.prescaler, value: prescaler)
        storage.write(.window, value: window)
        storage.write(.counter, value: counter)
        storage.write(.earlyWakeupMode, value: earlyWakeupMode)
    }
}

public struct WWDG<Registers: WWDGRegisterIO, Configuration: WWDGConfigurationIO> {
    public let registers: Registers
    public let configuration: Configuration

    public init(registers: Registers, configuration: Configuration) {
        self.registers = registers
        self.configuration = configuration
    }

    @discardableResult
    public func initialize(mspInitialize: (Self) -> Void = { _ in }) -> HALStatus {
        precondition(configuration.read(.prescaler) & ~UInt32(0x3800) == 0)
        let window = configuration.read(.window)
        precondition(window >= 0x40 && window <= 0x7F)
        let counter = configuration.read(.counter)
        precondition(counter >= 0x40 && counter <= 0x7F)
        let mode = configuration.read(.earlyWakeupMode)
        precondition(mode == 0 || mode == 0x200)
        mspInitialize(self)
        registers.write(.cr, value: 0x80 | configuration.read(.counter))
        registers.write(.cfr, value: configuration.read(.earlyWakeupMode)
            | configuration.read(.prescaler) | configuration.read(.window))
        return .ok
    }

    @discardableResult
    public func refresh() -> HALStatus {
        registers.write(.cr, value: configuration.read(.counter))
        return .ok
    }

    public func handleInterrupt(earlyWakeup: (Self) -> Void = { _ in }) {
        if getInterruptSource(0x200) {
            if getFlag(1) {
                clearFlag(1)
                earlyWakeup(self)
            }
        }
    }

    public func enable() { registers.write(.cr, value: registers.read(.cr) | 0x80) }
    public func enableInterrupt(_ mask: UInt32 = 0x200) {
        registers.write(.cfr, value: registers.read(.cfr) | mask)
    }
    public func getInterrupt(_ mask: UInt32 = 1) -> Bool { getFlag(mask) }
    public func clearInterrupt(_ mask: UInt32 = 1) { clearFlag(mask) }
    public func getFlag(_ mask: UInt32 = 1) -> Bool { registers.read(.sr) & mask == mask }
    public func clearFlag(_ mask: UInt32 = 1) { registers.write(.sr, value: ~mask) }
    public func getInterruptSource(_ mask: UInt32 = 0x200) -> Bool { registers.read(.cfr) & mask == mask }
}
