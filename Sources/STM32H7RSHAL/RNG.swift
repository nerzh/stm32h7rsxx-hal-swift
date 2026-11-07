// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_rng.c/.h and stm32h7rsxx_hal_rng_ex.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum RNGRegister: Hashable, CaseIterable { case cr, sr, dr, htcr }

public protocol RNGRegisterIO {
    func read(_ register: RNGRegister) -> UInt32
    func write(_ register: RNGRegister, value: UInt32)
}

public enum RNGHandleWord: Int, CaseIterable {
    case clockErrorDetection = 0, lock = 1, state = 2, errorCode = 3, randomNumber = 4
}

// The caller owns five long-lived words, initially zero. All accesses must be
// volatile when foreground code and the RNG IRQ share this state. Copying an IO
// adapter must preserve access to the same words, rather than copying their values.
public protocol RNGStateIO {
    func read(_ word: RNGHandleWord) -> UInt32
    func write(_ word: RNGHandleWord, value: UInt32)
}

public enum RNGState: UInt32, CaseIterable, Sendable {
    case reset = 0, ready = 1, busy = 2, timeout = 3, error = 4
}

public enum RNGClockErrorDetection: UInt32, Sendable { case enabled = 0, disabled = 0x20 }

public struct RNGError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let invalidCallback = Self(rawValue: 0x01)
    public static let timeout = Self(rawValue: 0x02)
    public static let busy = Self(rawValue: 0x04)
    public static let seed = Self(rawValue: 0x08)
    public static let clock = Self(rawValue: 0x10)
    public static let recoverSeed = Self(rawValue: 0x20)
}

// Values use the C register encodings: ClockDivider = exponent << 16 (0...15),
// NistCompliance = 0 or 0x1000, AutoReset = 0 (enabled) or 0x80 (disabled).
// HealthTest is passed through unchanged; the C driver does not validate it.
public struct RNGConfiguration: Equatable, Sendable {
    public var config1: UInt32
    public var config2: UInt32
    public var config3: UInt32
    public var clockDivider: UInt32
    public var nistCompliance: UInt32
    public var autoReset: UInt32
    public var healthTest: UInt32

    public init(config1: UInt32 = 0, config2: UInt32 = 0, config3: UInt32 = 0,
                clockDivider: UInt32 = 0, nistCompliance: UInt32 = 0,
                autoReset: UInt32 = 0, healthTest: UInt32 = 0) {
        self.config1 = config1
        self.config2 = config2
        self.config3 = config3
        self.clockDivider = clockDivider
        self.nistCompliance = nistCompliance
        self.autoReset = autoReset
        self.healthTest = healthTest
    }
}

// Immutable wrappers may be used by foreground code and IRQ handlers without a
// shared Swift inout access. Synchronization still follows the C driver: its
// Lock check/set is not atomic and is not a general multithreaded mutex.
// This core implements USE_HAL_RNG_REGISTER_CALLBACKS=0 with nonescaping hooks.
// RNGRegistered adds the optional registered-callback behavior without changing
// this peripheral algorithm or storing capturing Swift closures.
public struct RNG<Registers: RNGRegisterIO, State: RNGStateIO> {
    public let registers: Registers
    public let state: State

    public init(registers: Registers, state: State) {
        self.registers = registers
        self.state = state
    }

    @discardableResult
    public func initialize(getTick: () -> UInt32, mspInitialize: (Self) -> Void = { _ in }) -> HALStatus {
        let detection = state.read(.clockErrorDetection)
        precondition(detection == 0 || detection == 0x20)
        if getState() == .reset {
            unlock()
            mspInitialize(self)
        }
        setState(.busy)
        disable()
        modify(.cr, clear: 0x4000_0020, set: state.read(.clockErrorDetection) | 0x4000_0000)
        modify(.cr, clear: 0x4000_0000, set: 0)
        var start = getTick()
        while (registers.read(.cr) & 0x4000_0000) != 0 {
            if (getTick() &- start) > 10 {
                if (registers.read(.cr) & 0x4000_0000) != 0 {
                    setState(.ready)
                    setError(.timeout)
                    return .error
                }
            }
        }
        enable()
        if getInterrupt(0x40) {
            setState(.error)
            return .error
        }
        start = getTick()
        while !getFlag(1) {
            if (getTick() &- start) > 10 {
                if !getFlag(1) {
                    setState(.error)
                    setError(.timeout)
                    return .error
                }
            }
        }
        setState(.ready)
        setError([])
        return .ok
    }

    @discardableResult
    public func deinitialize(getTick: () -> UInt32, mspDeinitialize: (Self) -> Void = { _ in }) -> HALStatus {
        modify(.cr, clear: 0x4000_0020, set: 0x4000_0000)
        modify(.cr, clear: 0x4000_0000, set: 0)
        let start = getTick()
        while (registers.read(.cr) & 0x4000_0000) != 0 {
            if (getTick() &- start) > 10 {
                if (registers.read(.cr) & 0x4000_0000) != 0 {
                    setState(.ready)
                    setError(.timeout)
                    unlock()
                    return .error
                }
            }
        }
        modify(.cr, clear: 0x0C, set: 0)
        modify(.sr, clear: 0x60, set: 0)
        mspDeinitialize(self)
        setState(.reset)
        setError([])
        unlock()
        return .ok
    }

    // Output is untouched on failure, including a seed error detected AFTER DR
    // has been read. RandomNumber still retains that DR read, exactly as in C.
    @discardableResult
    public func generateRandomNumber(_ output: inout UInt32, getTick: () -> UInt32,
                                     errorCallback: (Self) -> Void = { _ in }) -> HALStatus {
        if !tryLock() { return .busy }
        var status = HALStatus.ok
        if getState() == .ready {
            setState(.busy)
            if getInterrupt(0x40) {
                setError(.seed)
                status = recoverSeedErrorInternal(errorCallback: errorCallback)
                if status == .error {
                    setError(.recoverSeed)
                    return status
                }
            }
            let start = getTick()
            while !getFlag(1) {
                if (getTick() &- start) > 10 {
                    if !getFlag(1) {
                        setState(.ready)
                        setError(.timeout)
                        unlock()
                        return .error
                    }
                }
            }
            state.write(.randomNumber, value: registers.read(.dr))
            if getInterrupt(0x40) {
                setError(.seed)
                status = .error
            } else {
                output = state.read(.randomNumber)
            }
            setState(.ready)
        } else {
            setError(.busy)
            status = .error
        }
        unlock()
        return status
    }

    @discardableResult
    public func generateRandomNumberInterrupt() -> HALStatus {
        if !tryLock() { return .busy }
        var status = HALStatus.ok
        if getState() == .ready {
            setState(.busy)
            enableInterrupts()
        } else {
            unlock()
            setError(.busy)
            status = .error
        }
        return status
    }

    public func handleInterrupt(readyDataCallback: (Self, UInt32) -> Void = { _, _ in },
                                errorCallback: (Self) -> Void = { _ in }) {
        var clockError: UInt32 = 0
        let flags = registers.read(.sr)
        if (flags & 0x20) == 0x20 {
            setError(.clock)
            clockError = 1
        } else if (flags & 0x40) == 0x40 {
            if (flags & 4) != 4 {
                modify(.sr, clear: 0x40, set: 0)
            } else {
                setError(.seed)
                clockError = 1
                disableInterrupts()
            }
        }
        if clockError == 1 {
            setState(.error)
            errorCallback(self)
            clearInterrupt(0x60)
            return
        }
        if (flags & 1) == 1 {
            disableInterrupts()
            state.write(.randomNumber, value: registers.read(.dr))
            if getState() != .error {
                setState(.ready)
                unlock()
                readyDataCallback(self, state.read(.randomNumber))
            }
        }
    }

    public func readLastRandomNumber() -> UInt32 { state.read(.randomNumber) }
    public func getState() -> RNGState { RNGState(rawValue: state.read(.state))! }
    public func getError() -> RNGError { RNGError(rawValue: state.read(.errorCode)) }

    @discardableResult
    public func setConfig(_ configuration: RNGConfiguration?, getTick: () -> UInt32) -> HALStatus {
        guard let configuration else { return .error }
        precondition(configuration.clockDivider & ~UInt32(0x000F_0000) == 0)
        precondition(configuration.nistCompliance == 0 || configuration.nistCompliance == 0x1000)
        precondition(configuration.config1 <= 0x3F && configuration.config2 <= 7 && configuration.config3 <= 0xF)
        precondition(configuration.autoReset == 0 || configuration.autoReset == 0x80)
        if getState() == .ready {
            setState(.busy)
            disable()
            let value = configuration.clockDivider | configuration.nistCompliance | configuration.autoReset
                | (configuration.config1 << 20) | (configuration.config2 << 13) | (configuration.config3 << 8)
            modify(.cr, clear: 0x03FF_FF80, set: 0x4000_0000 | value)
            registers.write(.htcr, value: configuration.healthTest)
            modify(.cr, clear: 0x4000_0000, set: 0)
            let start = getTick()
            while (registers.read(.cr) & 0x4000_0000) != 0 {
                if (getTick() &- start) > 2 {
                    if (registers.read(.cr) & 0x4000_0000) != 0 {
                        setState(.ready)
                        setError(.timeout)
                        return .error
                    }
                }
            }
            enable()
            setState(.ready)
            return .ok
        }
        setError(.busy)
        return .error
    }

    @discardableResult
    public func getConfig(_ configuration: inout RNGConfiguration?) -> HALStatus {
        guard var value = configuration else { return .error }
        if getState() == .ready {
            setState(.busy)
            value.config1 = (registers.read(.cr) & 0x03F0_0000) >> 20
            value.config2 = (registers.read(.cr) & 0x0000_E000) >> 13
            value.config3 = (registers.read(.cr) & 0x0000_0F00) >> 8
            value.clockDivider = registers.read(.cr) & 0x000F_0000
            value.nistCompliance = registers.read(.cr) & 0x1000
            value.autoReset = registers.read(.cr) & 0x80
            value.healthTest = registers.read(.htcr)
            configuration = value
            setState(.ready)
            return .ok
        }
        state.write(.errorCode, value: state.read(.errorCode) | RNGError.busy.rawValue)
        return .error
    }

    @discardableResult
    public func getConfig(_ configuration: inout RNGConfiguration) -> HALStatus {
        var value: RNGConfiguration? = configuration
        let status = getConfig(&value)
        configuration = value!
        return status
    }

    @discardableResult
    public func lockConfig() -> HALStatus {
        if getState() == .ready {
            setState(.busy)
            modify(.cr, clear: 0x8000_0000, set: 0x8000_0000)
            setState(.ready)
            return .ok
        }
        setError(.busy)
        return .error
    }

    @discardableResult
    public func recoverSeedError(errorCallback: (Self) -> Void = { _ in }) -> HALStatus {
        if getState() == .ready {
            setState(.busy)
            let status = recoverSeedErrorInternal(errorCallback: errorCallback)
            if status == .error { setError(.recoverSeed) }
            // The upstream RNGEx function deliberately has no READY assignment.
            return status
        }
        setError(.busy)
        return .error
    }

    public func resetHandleState() { setState(.reset) }
    public func enable() { modify(.cr, clear: 0, set: 4) }
    public func disable() { modify(.cr, clear: 4, set: 0) }
    public func getFlag(_ flag: UInt32) -> Bool { (registers.read(.sr) & flag) == flag }
    public func clearFlag(_ flag: UInt32) {} // The upstream macro is empty.
    public func enableInterrupts() { modify(.cr, clear: 0, set: 8) }
    public func disableInterrupts() { modify(.cr, clear: 8, set: 0) }
    public func getInterrupt(_ interrupt: UInt32) -> Bool { (registers.read(.sr) & interrupt) == interrupt }
    public func clearInterrupt(_ interrupt: UInt32) { registers.write(.sr, value: ~interrupt) }

    func recoverSeedErrorInternal(errorCallback: (Self) -> Void) -> HALStatus {
        if !getFlag(4) {
            modify(.sr, clear: 0x40, set: 0)
        } else {
            modify(.cr, clear: 0, set: 0x4000_0000)
            modify(.cr, clear: 0x4000_0000, set: 0)
            // C uses a volatile ten-count loop here, NOT HAL_GetTick(). Decrement
            // precedes both the timeout check and the register read (nine reads).
            var count: UInt32 = 10
            repeat {
                count &-= 1
                if count == 0 {
                    setState(.ready)
                    state.write(.errorCode, value: state.read(.errorCode) | RNGError.timeout.rawValue)
                    unlock()
                    errorCallback(self)
                    return .error
                }
            } while (registers.read(.cr) & 0x4000_0000) != 0
            if getInterrupt(0x40) { modify(.sr, clear: 0x40, set: 0) }
            count = 10
            repeat {
                count &-= 1
                if count == 0 {
                    setState(.ready)
                    state.write(.errorCode, value: state.read(.errorCode) | RNGError.timeout.rawValue)
                    unlock()
                    errorCallback(self)
                    return .error
                }
            } while (registers.read(.sr) & 4) != 0
        }
        state.write(.errorCode, value: state.read(.errorCode) & ~RNGError.seed.rawValue)
        return .ok
    }

    func tryLock() -> Bool {
        if state.read(.lock) == 1 { return false }
        state.write(.lock, value: 1)
        return true
    }

    func unlock() { state.write(.lock, value: 0) }
    func setState(_ value: RNGState) { state.write(.state, value: value.rawValue) }
    func setError(_ value: RNGError) { state.write(.errorCode, value: value.rawValue) }
    private func modify(_ register: RNGRegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
}
