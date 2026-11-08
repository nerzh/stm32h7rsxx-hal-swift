// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDIOS operations and definitions from stm32h7rsxx_hal_mdios.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum MDIOSRegister: UInt32, CaseIterable, Sendable {
    case cr = 0, wrfr = 4, cwrfr = 8, rdfr = 12, crdfr = 16, sr = 20, clrfr = 24
}
public enum MDIOSWakeupRegister: CaseIterable, Sendable { case imr2, pr2, rtsr2, ftsr2, swier2 }
public protocol MDIOSRegisterIO {
    func read(_ register: MDIOSRegister) -> UInt32
    func write(_ register: MDIOSRegister, value: UInt32)
    func readInput(_ index: UInt32) -> UInt32
    func writeOutput(_ index: UInt32, value: UInt32)
    func read(_ register: MDIOSWakeupRegister) -> UInt32
    func write(_ register: MDIOSWakeupRegister, value: UInt32)
}
public enum MDIOSHandleWord: Int, CaseIterable { case portAddress = 0, preambleCheck, state, errorCode, lock }
public protocol MDIOSHandleIO {
    func read(_ word: MDIOSHandleWord) -> UInt32
    func write(_ word: MDIOSHandleWord, value: UInt32)
}
public enum MDIOSState: UInt32, CaseIterable, Sendable { case reset = 0, ready = 1, busy = 2, error = 4 }
public enum MDIOSPreambleCheck: UInt32, CaseIterable, Sendable { case enabled = 0, disabled = 0x80 }
public struct MDIOSInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let write = Self(rawValue: 2)
    public static let read = Self(rawValue: 4)
    public static let error = Self(rawValue: 8)
}
public struct MDIOSHardwareErrors: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let turnaround = Self(rawValue: 4)
    public static let start = Self(rawValue: 2)
    public static let preamble = Self(rawValue: 1)
}
public struct MDIOSError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let parameter = Self(rawValue: 1)
    public static let busy = Self(rawValue: 2)
    public static let timeout = Self(rawValue: 4)
    public static let data = Self(rawValue: 0x10)
    public static let invalidCallback = Self(rawValue: 0x20)
}
public struct MDIOS<Registers: MDIOSRegisterIO, Handle: MDIOSHandleIO, Callbacks: MDIOSCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: MDIOSCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: MDIOSCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
