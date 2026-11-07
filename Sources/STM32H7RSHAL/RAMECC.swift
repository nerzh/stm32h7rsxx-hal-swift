// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_ramecc.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum RAMECCRegister: Hashable, CaseIterable { case ier, cr, sr, far, fdrl, fdrh, fecr }

public protocol RAMECCRegisterIO {
    func read(_ register: RAMECCRegister) -> UInt32
    func write(_ register: RAMECCRegister, value: UInt32)
}

public enum RAMECCHandleWord: Int, CaseIterable { case state = 0, errorCode = 1 }

// Two caller-owned words shared by foreground/IRQ wrapper copies. Hardware IO
// accesses these words with volatile semantics; the C driver has no handle lock.
public protocol RAMECCStateIO {
    func read(_ word: RAMECCHandleWord) -> UInt32
    func write(_ word: RAMECCHandleWord, value: UInt32)
}

public enum RAMECCState: UInt32, CaseIterable, Sendable {
    case reset = 0, ready = 1, busy = 2, error = 3
}

public struct RAMECCError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let timeout = Self(rawValue: 1)
    public static let busy = Self(rawValue: 2)
    // This is deliberately 3, as in C, rather than an independent error bit.
    public static let invalidCallback = Self(rawValue: 3)
}

public enum RAMECCInterrupt: UInt32, CaseIterable, Sendable {
    case globalAll = 0x1000_0001
    case globalSingleErrorRead = 0x1000_0002
    case globalDoubleErrorRead = 0x1000_0004
    case globalDoubleErrorWrite = 0x1000_0008
    case monitorSingleErrorRead = 0x2000_0004
    case monitorDoubleErrorRead = 0x2000_0008
    case monitorDoubleErrorWrite = 0x2000_0010
    case monitorAll = 0x2000_001C
}

public struct RAMECCFlags: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let singleErrorRead = Self(rawValue: 1)
    public static let doubleErrorRead = Self(rawValue: 2)
    public static let doubleErrorWrite = Self(rawValue: 4)
    public static let all: Self = [.singleErrorRead, .doubleErrorRead, .doubleErrorWrite]
}

// USE_HAL_RAMECC_REGISTER_CALLBACKS=0. Hooks are nonescaping and wrapper copies
// share the caller's IO, allowing callback reentry without a Swift inout access.
public struct RAMECC<Registers: RAMECCRegisterIO, State: RAMECCStateIO> {
    public let registers: Registers
    public let state: State

    public init(registers: Registers, state: State) {
        self.registers = registers
        self.state = state
    }

    @discardableResult
    public func initialize(mspInitialize: (Self) -> Void = { _ in }) -> HALStatus {
        state.write(.state, value: RAMECCState.busy.rawValue)
        mspInitialize(self)
        modify(.cr, clear: 0x20, set: 0)
        modify(.ier, clear: 0xF, set: 0)
        modify(.cr, clear: 0x1C, set: 0)
        clearFlag(7)
        state.write(.errorCode, value: 0)
        state.write(.state, value: RAMECCState.ready.rawValue)
        return .ok
    }

    @discardableResult
    public func deinitialize(mspDeinitialize: (Self) -> Void = { _ in }) -> HALStatus {
        modify(.cr, clear: 0x20, set: 0)
        modify(.ier, clear: 0xF, set: 0)
        modify(.cr, clear: 0x1C, set: 0)
        clearFlag(7)
        mspDeinitialize(self)
        state.write(.errorCode, value: 0)
        state.write(.state, value: RAMECCState.reset.rawValue)
        return .ok
    }

    @discardableResult
    public func startMonitor() -> HALStatus {
        if state.read(.state) == RAMECCState.ready.rawValue {
            state.write(.state, value: RAMECCState.busy.rawValue)
            modify(.cr, clear: 0, set: 0x20)
            state.write(.state, value: RAMECCState.ready.rawValue)
            return .ok
        }
        state.write(.errorCode, value: RAMECCError.busy.rawValue)
        return .error
    }

    @discardableResult
    public func stopMonitor() -> HALStatus {
        if state.read(.state) == RAMECCState.ready.rawValue {
            state.write(.state, value: RAMECCState.busy.rawValue)
            modify(.cr, clear: 0x20, set: 0)
            state.write(.state, value: RAMECCState.ready.rawValue)
            return .ok
        }
        state.write(.errorCode, value: RAMECCError.busy.rawValue)
        return .error
    }

    @discardableResult
    public func enableNotification(_ notification: RAMECCInterrupt) -> HALStatus {
        if state.read(.state) == RAMECCState.ready.rawValue {
            state.write(.state, value: RAMECCState.busy.rawValue)
            enableInterrupts(notification.rawValue)
            state.write(.state, value: RAMECCState.ready.rawValue)
            return .ok
        }
        state.write(.errorCode, value: RAMECCError.busy.rawValue)
        return .error
    }

    @discardableResult
    public func disableNotification(_ notification: RAMECCInterrupt) -> HALStatus {
        if state.read(.state) == RAMECCState.ready.rawValue {
            state.write(.state, value: RAMECCState.busy.rawValue)
            disableInterrupts(notification.rawValue)
            state.write(.state, value: RAMECCState.ready.rawValue)
            return .ok
        }
        state.write(.errorCode, value: RAMECCError.busy.rawValue)
        return .error
    }

    public func handleInterrupt(singleError: (Self) -> Void = { _ in }, doubleError: (Self) -> Void = { _ in }) {
        let monitor = registers.read(.cr)
        let global = registers.read(.ier)
        if monitor & 4 == 4 || global & 2 == 2 || global & 1 == 1 {
            if getFlag(1) != 0 {
                clearFlag(1)
                singleError(self)
            }
        }
        if monitor & 8 == 8 || monitor & 0x10 == 0x10 || global & 4 == 4 || global & 8 == 8 || global & 1 == 1 {
            if getFlag(2) != 0 {
                clearFlag(2)
                doubleError(self)
            }
            if getFlag(4) != 0 {
                clearFlag(4)
                doubleError(self)
            }
        }
    }

    public func getFailingAddress() -> UInt32 { registers.read(.far) }
    public func getFailingDataLow() -> UInt32 { registers.read(.fdrl) }
    public func getFailingDataHigh() -> UInt32 { registers.read(.fdrh) }
    public func getHammingErrorCode() -> UInt32 { registers.read(.fecr) }
    public func isECCSingleErrorDetected() -> UInt32 { registers.read(.sr) & 1 == 1 ? 1 : 0 }
    public func isECCDoubleErrorDetected() -> UInt32 { registers.read(.sr) & 6 != 0 ? 1 : 0 }
    public func getState() -> RAMECCState { RAMECCState(rawValue: state.read(.state))! }
    public func getError() -> RAMECCError { .init(rawValue: state.read(.errorCode)) }
    public func resetHandleState() { state.write(.state, value: RAMECCState.reset.rawValue) }

    // Raw macro equivalents preserve C's exact global-ID test. Only the four
    // defined global values take the global path; arbitrary combinations do not.
    public func enableInterrupts(_ interrupt: UInt32) {
        if isGlobalInterrupt(interrupt) { enableGlobalInterrupts(interrupt) }
        else { enableMonitorInterrupts(interrupt) }
    }
    public func disableInterrupts(_ interrupt: UInt32) {
        if isGlobalInterrupt(interrupt) { disableGlobalInterrupts(interrupt) }
        else { disableMonitorInterrupts(interrupt) }
    }
    public func getInterruptSource(_ interrupt: UInt32) -> UInt32 {
        isGlobalInterrupt(interrupt) ? getGlobalInterruptSource(interrupt) : getMonitorInterruptSource(interrupt)
    }
    public func enableGlobalInterrupts(_ interrupt: UInt32) { modify(.ier, clear: 0, set: interrupt & ~UInt32(0x1000_0000)) }
    public func enableMonitorInterrupts(_ interrupt: UInt32) { modify(.cr, clear: 0, set: interrupt & ~UInt32(0x2000_0000)) }
    public func disableGlobalInterrupts(_ interrupt: UInt32) { modify(.ier, clear: interrupt & ~UInt32(0x1000_0000), set: 0) }
    public func disableMonitorInterrupts(_ interrupt: UInt32) { modify(.cr, clear: interrupt & ~UInt32(0x2000_0000), set: 0) }
    public func getGlobalInterruptSource(_ interrupt: UInt32) -> UInt32 {
        registers.read(.ier) & (interrupt & ~UInt32(0x1000_0000)) != 0 ? 1 : 0
    }
    public func getMonitorInterruptSource(_ interrupt: UInt32) -> UInt32 {
        registers.read(.cr) & (interrupt & ~UInt32(0x2000_0000)) != 0 ? 1 : 0
    }
    public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.sr) & flag != 0 ? 1 : 0 }
    // The source clears SR with read-modify-write, not a W1C mask store.
    public func clearFlag(_ flag: UInt32) { modify(.sr, clear: flag, set: 0) }

    func modify(_ register: RAMECCRegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
    func isGlobalInterrupt(_ value: UInt32) -> Bool {
        value == 0x1000_0001 || value == 0x1000_0002 || value == 0x1000_0004 || value == 0x1000_0008
    }
}
