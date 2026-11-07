// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_iwdg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum IWDGRegister: Hashable, CaseIterable { case kr, pr, rlr, sr, winr, ewcr }
public protocol IWDGRegisterIO {
    func read(_ register: IWDGRegister) -> UInt32
    func write(_ register: IWDGRegister, value: UInt32)
}

public enum IWDGConfigurationWord: Int, CaseIterable {
    case prescaler = 0, reload = 1, window = 2, earlyWakeup = 3
}
public protocol IWDGConfigurationIO {
    func read(_ word: IWDGConfigurationWord) -> UInt32
    func write(_ word: IWDGConfigurationWord, value: UInt32)
}

public enum IWDGPrescaler: UInt32, CaseIterable, Sendable {
    case divide4 = 0, divide8 = 1, divide16 = 2, divide32 = 3, divide64 = 4
    case divide128 = 5, divide256 = 6, divide512 = 7, divide1024 = 8
}

public struct IWDGConfiguration: Equatable, Sendable {
    public var prescaler: UInt32
    public var reload: UInt32
    public var window: UInt32
    // Zero disables EWI; 1...0xFFF is the early wakeup comparator threshold.
    public var earlyWakeup: UInt32

    public init(prescaler: UInt32, reload: UInt32, window: UInt32 = 0xFFF, earlyWakeup: UInt32 = 0) {
        self.prescaler = prescaler
        self.reload = reload
        self.window = window
        self.earlyWakeup = earlyWakeup
    }

    public func store<IO: IWDGConfigurationIO>(in storage: IO) {
        storage.write(.prescaler, value: prescaler)
        storage.write(.reload, value: reload)
        storage.write(.window, value: window)
        storage.write(.earlyWakeup, value: earlyWakeup)
    }
}

public struct IWDGTiming: Equatable, Sendable {
    public var lsiFrequency: UInt32
    public var lsiStartupMicroseconds: UInt32

    public init(lsiFrequency: UInt32 = 32_000, lsiStartupMicroseconds: UInt32 = 130) {
        self.lsiFrequency = lsiFrequency
        self.lsiStartupMicroseconds = lsiStartupMicroseconds
    }

    public var updateTimeout: UInt32 {
        precondition(lsiFrequency / 128 != 0)
        // Preserve the original division order, including LSI_VALUE / 128.
        // The upstream defaults produce 4097 ms, not a rounded oscillator period.
        return ((1 * 1024 * 1000) / (lsiFrequency / 128)) + ((lsiStartupMicroseconds / 1000) + 1)
    }
}

// The C handle contains configuration and optional callback pointers, but no
// software state or lock. Caller-owned configuration remains shared with IRQ
// handles and callbacks; copying this wrapper must not copy the backing words.
public struct IWDG<Registers: IWDGRegisterIO, Configuration: IWDGConfigurationIO> {
    public let registers: Registers
    public let configuration: Configuration
    public let timing: IWDGTiming

    public init(registers: Registers, configuration: Configuration, timing: IWDGTiming = .init()) {
        self.registers = registers
        self.configuration = configuration
        self.timing = timing
    }

    @discardableResult
    public func initialize(getTick: () -> UInt32, mspInitialize: (Self) -> Void = { _ in }) -> HALStatus {
        precondition(configuration.read(.prescaler) <= 8)
        precondition(configuration.read(.reload) <= 0xFFF)
        precondition(configuration.read(.window) <= 0xFFF)
        precondition(configuration.read(.earlyWakeup) <= 0xFFF)
        mspInitialize(self)
        start()
        enableWriteAccess()
        registers.write(.pr, value: configuration.read(.prescaler))
        registers.write(.rlr, value: configuration.read(.reload))

        var startTick = getTick()
        while registers.read(.sr) & 2 != 0 {
            if (getTick() &- startTick) > timing.updateTimeout {
                if registers.read(.sr) & 2 != 0 { return .timeout }
            }
        }

        if configuration.read(.earlyWakeup) == 0 {
            registers.write(.ewcr, value: 0x4000)
        } else {
            registers.write(.ewcr, value: 0xC000 | configuration.read(.earlyWakeup))
        }

        startTick = getTick()
        while registers.read(.sr) & 0xF != 0 {
            if (getTick() &- startTick) > timing.updateTimeout {
                if registers.read(.sr) & 0xF != 0 { return .timeout }
            }
        }

        if registers.read(.winr) != configuration.read(.window) {
            registers.write(.winr, value: configuration.read(.window))
        } else {
            reloadCounter()
        }
        return .ok
    }

    @discardableResult
    public func refresh() -> HALStatus { reloadCounter(); return .ok }
    public func getActiveStatus() -> UInt32 { registers.read(.sr) & 0x100 }

    public func handleInterrupt(earlyWakeup: (Self) -> Void = { _ in }) {
        if registers.read(.sr) & 0x4000 != 0 {
            registers.write(.ewcr, value: registers.read(.ewcr) | 0x4000)
            earlyWakeup(self)
        }
    }

    public func start() { registers.write(.kr, value: 0xCCCC) }
    public func reloadCounter() { registers.write(.kr, value: 0xAAAA) }
    public func enableWriteAccess() { registers.write(.kr, value: 0x5555) }
    public func disableWriteAccess() { registers.write(.kr, value: 0) }
}
