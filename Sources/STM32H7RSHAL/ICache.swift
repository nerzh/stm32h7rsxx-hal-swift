// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_icache.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum ICacheRegister: Hashable, CaseIterable { case cr, sr, ier, fcr, hmonr, mmonr }

public protocol ICacheRegisterIO {
    func read(_ register: ICacheRegister) -> UInt32
    func write(_ register: ICacheRegister, value: UInt32)
}

// The peripheral texture cache on H7R7/H7S7, separate from the Cortex-M7 cache.
public struct ICache<Registers: ICacheRegisterIO> {
    public let registers: Registers
    public init(registers: Registers) { self.registers = registers }

    @discardableResult
    public func configureAssociativity(_ mode: UInt32) -> HALStatus {
        precondition(mode == 0 || mode == 4)
        var status = HALStatus.ok
        if registers.read(.cr) & 1 != 0 { status = .error }
        else { modify(.cr, clear: 4, set: mode) }
        return status
    }

    @discardableResult
    public func deinitialize() -> HALStatus {
        registers.write(.ier, value: 0)
        registers.write(.fcr, value: 6)
        modify(.cr, clear: 1, set: 0)
        registers.write(.cr, value: 4)
        modify(.cr, clear: 0x30000, set: 0)
        modify(.cr, clear: 0, set: 0x30000 << 2)
        modify(.cr, clear: 0x30000 << 2, set: 0)
        return .ok
    }

    @discardableResult
    public func enable() -> HALStatus {
        modify(.cr, clear: 0, set: 1)
        return .ok
    }

    @discardableResult
    public func disable(getTick: () -> UInt32) -> HALStatus {
        var status = HALStatus.ok
        registers.write(.fcr, value: 2)
        modify(.cr, clear: 1, set: 0)
        let start = getTick()
        while registers.read(.cr) & 1 != 0 {
            if getTick() &- start > 1 {
                if registers.read(.cr) & 1 != 0 {
                    status = .timeout
                    break
                }
            }
        }
        return status
    }

    public func isEnabled() -> UInt32 { registers.read(.cr) & 1 != 0 ? 1 : 0 }

    @discardableResult
    public func invalidate(getTick: () -> UInt32) -> HALStatus {
        if registers.read(.sr) & 1 == 0 { modify(.cr, clear: 0, set: 2) }
        return waitForInvalidateComplete(getTick: getTick)
    }

    @discardableResult
    public func invalidateInterrupt() -> HALStatus {
        var status = HALStatus.ok
        if registers.read(.sr) & 1 != 0 { status = .error }
        else {
            registers.write(.fcr, value: 2)
            modify(.ier, clear: 0, set: 2)
            modify(.cr, clear: 0, set: 2)
        }
        return status
    }

    @discardableResult
    public func waitForInvalidateComplete(getTick: () -> UInt32) -> HALStatus {
        var status = HALStatus.ok
        if registers.read(.sr) & 1 != 0 {
            let start = getTick()
            while registers.read(.sr) & 2 == 0 {
                if getTick() &- start > 1 {
                    if registers.read(.sr) & 2 == 0 {
                        status = .timeout
                        break
                    }
                }
            }
        }
        registers.write(.fcr, value: 2)
        return status
    }

    @discardableResult
    public func startMonitor(_ monitor: UInt32) -> HALStatus {
        validateMonitor(monitor)
        modify(.cr, clear: 0, set: monitor)
        return .ok
    }

    @discardableResult
    public func stopMonitor(_ monitor: UInt32) -> HALStatus {
        validateMonitor(monitor)
        modify(.cr, clear: monitor, set: 0)
        return .ok
    }

    @discardableResult
    public func resetMonitor(_ monitor: UInt32) -> HALStatus {
        validateMonitor(monitor)
        modify(.cr, clear: 0, set: monitor << 2)
        modify(.cr, clear: monitor << 2, set: 0)
        return .ok
    }

    public func getHitValue() -> UInt32 { registers.read(.hmonr) }
    public func getMissValue() -> UInt32 { registers.read(.mmonr) }

    public func handleInterrupt(error: (Self) -> Void = { _ in },
                                invalidateComplete: (Self) -> Void = { _ in }) {
        let flags = registers.read(.sr)
        let sources = registers.read(.ier)
        if flags & sources & 4 != 0 {
            modify(.ier, clear: 4, set: 0)
            registers.write(.fcr, value: 4)
            error(self)
        }
        if flags & sources & 2 != 0 {
            modify(.ier, clear: 2, set: 0)
            registers.write(.fcr, value: 2)
            invalidateComplete(self)
        }
    }

    public func enableInterrupts(_ interrupts: UInt32) { modify(.ier, clear: 0, set: interrupts) }
    public func disableInterrupts(_ interrupts: UInt32) { modify(.ier, clear: interrupts, set: 0) }
    public func getInterruptSource(_ interrupts: UInt32) -> UInt32 {
        registers.read(.ier) & interrupts == interrupts ? 1 : 0
    }
    public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.sr) & flag != 0 ? 1 : 0 }
    public func clearFlag(_ flag: UInt32) { registers.write(.fcr, value: flag) }

    private func modify(_ register: ICacheRegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
    private func validateMonitor(_ monitor: UInt32) {
        precondition(monitor == 0x10000 || monitor == 0x20000 || monitor == 0x30000)
    }
}
