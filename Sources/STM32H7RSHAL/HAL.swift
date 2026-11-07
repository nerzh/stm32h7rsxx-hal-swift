// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of the initialization, identification, and debug functions in
// stm32h7rsxx_hal.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum HALRegister: Hashable {
    case apb1Reset1, apb1Reset2, apb2Reset, apb4Reset, apb5Reset
    case ahb1Reset, ahb2Reset, ahb3Reset, ahb4Reset, ahb5Reset
    case debugIdentification, debugControl
    case uniqueIDWord(index: Int)
}

public protocol HALRegisterIO {
    mutating func read(_ register: HALRegister) -> UInt32
    mutating func write(_ register: HALRegister, value: UInt32)
    mutating func setPriorityGrouping(_ group: UInt32)
}

public struct HAL<IO: HALRegisterIO, TimeIO: HALTimeBaseIO> {
    public var registers: IO
    // Give the ISR its own immutable copy of this handle. Reading it through
    // a HAL value during a mutating HAL call would overlap Swift's access scope.
    public let timeBase: HALTimeBase<TimeIO>

    public init(registers: IO, timeBase: HALTimeBase<TimeIO>) {
        self.registers = registers
        self.timeBase = timeBase
    }

    public static var version: UInt32 { 0x01020100 }

    @discardableResult
    public mutating func initialize(coreClockHz: UInt32, tickPriority: UInt32 = 15,
                                    mspInitialize: () -> Void = {}) -> HALStatus {
        registers.setPriorityGrouping(3) // NVIC_PRIORITYGROUP_4
        if timeBase.initializeTick(priority: tickPriority, coreClockHz: coreClockHz) != .ok {
            return .error
        }
        mspInitialize()
        return .ok
    }

    @discardableResult
    public mutating func deinitialize(mspDeinitialize: () -> Void = {}) -> HALStatus {
        // Preserve the masks and bus order of the C RCC reset macros.
        registers.write(.apb1Reset1, value: 0xC8FFC3FF)
        registers.write(.apb1Reset2, value: 0x08000122)
        registers.write(.apb1Reset1, value: 0)
        registers.write(.apb1Reset2, value: 0)
        reset(.apb2Reset, mask: 0xC8FFC3FF)
        reset(.apb4Reset, mask: 0x04009E2A)
        reset(.apb5Reset, mask: 0x00000016)
        reset(.ahb1Reset, mask: 0x8E008030)
        reset(.ahb2Reset, mask: 0x00004202)
        reset(.ahb3Reset, mask: 0x00000057)
        reset(.ahb4Reset, mask: 0x0008B0FF)
        reset(.ahb5Reset, mask: 0x0018513B)
        // The C implementation does not stop SysTick or reset uwTick here.
        mspDeinitialize()
        return .ok
    }

    public mutating func getRevisionID() -> UInt32 {
        (registers.read(.debugIdentification) & 0xFFFF0000) >> 16
    }

    public mutating func getDeviceID() -> UInt32 {
        registers.read(.debugIdentification) & 0xFFF
    }

    // As in C HAL_GetUIDw0/1/2, reads only the requested word. If caches are
    // enabled, configure 0x08FFF000...0x08FFFFFF as non-cacheable to avoid
    // speculative reads of virgin OTP data causing an ECC error (upstream note).
    public mutating func getUniqueIDWord(_ index: Int) -> UInt32 {
        precondition((0..<3).contains(index))
        return registers.read(.uniqueIDWord(index: index))
    }

    public mutating func enableDebugSleepMode() { setDebugBit(1) }
    public mutating func disableDebugSleepMode() { clearDebugBit(1) }
    public mutating func enableDebugStopMode() { setDebugBit(2) }
    public mutating func disableDebugStopMode() { clearDebugBit(2) }
    public mutating func enableDebugStandbyMode() { setDebugBit(4) }
    public mutating func disableDebugStandbyMode() { clearDebugBit(4) }

    private mutating func reset(_ register: HALRegister, mask: UInt32) {
        registers.write(register, value: mask)
        registers.write(register, value: 0)
    }

    private mutating func setDebugBit(_ bit: UInt32) {
        registers.write(.debugControl, value: registers.read(.debugControl) | bit)
    }

    private mutating func clearDebugBit(_ bit: UInt32) {
        registers.write(.debugControl, value: registers.read(.debugControl) & ~bit)
    }
}
