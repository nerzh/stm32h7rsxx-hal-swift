// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDIOS operations and definitions from stm32h7rsxx_hal_mdios.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MDIOS {
    public func setConfiguration(portAddress: UInt32, preambleCheck: MDIOSPreambleCheck) {
        handle.write(.portAddress, value: portAddress); handle.write(.preambleCheck, value: preambleCheck.rawValue)
    }
    @discardableResult
    public func initialize() -> HALStatus {
        precondition(handle.read(.portAddress) < 32)
        precondition(MDIOSPreambleCheck(rawValue: handle.read(.preambleCheck)) != nil)
        if handle.read(.state) == 0 {
            if useRegisteredCallbacks {
                callbacks.write(.writeComplete, value: defaults.writeComplete)
                callbacks.write(.readComplete, value: defaults.readComplete)
                callbacks.write(.error, value: defaults.error)
                callbacks.write(.wakeup, value: defaults.wakeup)
                prepareMSPCallback(.mspInitialize)
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 2)
        var cr = registers.read(.cr)
        cr &= ~(0x1 | 0x80 | 0x1F00)
        cr |= (handle.read(.portAddress) << 8) | handle.read(.preambleCheck) | 1
        registers.write(.cr, value: cr)
        handle.write(.errorCode, value: 0); handle.write(.state, value: 1); unlock()
        return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        handle.write(.state, value: 2); disable()
        prepareMSPCallback(.mspDeinitialize); invoke(.mspDeinitialize)
        handle.write(.state, value: 0); unlock()
        return .ok
    }
    @discardableResult
    public func writeRegister(_ index: UInt32, value: UInt16) -> HALStatus {
        precondition(index < 32)
        guard lock() else { return .busy }
        registers.writeOutput(index, value: UInt32(value)); unlock()
        return .ok
    }
    @discardableResult
    public func readRegister(_ index: UInt32, value: inout UInt16) -> HALStatus {
        precondition(index < 32)
        guard lock() else { return .busy }
        value = UInt16(truncatingIfNeeded: registers.readInput(index)); unlock()
        return .ok
    }
    public func getWrittenRegisterAddress() -> UInt32 { registers.read(.wrfr) }
    public func getReadRegisterAddress() -> UInt32 { registers.read(.rdfr) }
    @discardableResult
    public func clearWrittenRegisterAddress(_ index: UInt32) -> HALStatus {
        precondition(index < 32)
        guard lock() else { return .busy }
        // The upstream function ORs RegNum itself, without converting it to a bit mask.
        modify(.cwrfr, set: index); unlock()
        return .ok
    }
    @discardableResult
    public func clearReadRegisterAddress(_ index: UInt32) -> HALStatus {
        precondition(index < 32)
        guard lock() else { return .busy }
        modify(.crdfr, set: index); unlock()
        return .ok
    }
    @discardableResult
    public func enableEvents() -> HALStatus {
        guard lock() else { return .busy }
        enableInterrupts([.write, .read, .error]); unlock()
        return .ok
    }
    public func handleInterrupt() {
        let source = registers.read(.cr)
        let flags = registers.read(.sr)
        let wakeup = registers.read(MDIOSWakeupRegister.pr2)
        if source & 2 != 0 {
            if getWrittenRegisterAddress() != 0 { invoke(.writeComplete); modify(.cwrfr, set: .max) }
        }
        if source & 4 != 0 {
            if getReadRegisterAddress() != 0 { invoke(.readComplete); modify(.crdfr, set: .max) }
        }
        if source & 8 != 0 {
            if flags & 7 != 0 { addError(0x10); invoke(.error); clearErrorFlag(.init(rawValue: 7)) }
            handle.write(.errorCode, value: 0)
        }
        if wakeup & 0x400 != 0 { clearWakeupFlag(); invoke(.wakeup) }
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func enable() { modify(.cr, set: 1) }
    public func disable() { modify(.cr, clear: 1) }
    public func enableInterrupts(_ mask: MDIOSInterrupts) { modify(.cr, set: mask.rawValue) }
    public func disableInterrupts(_ mask: MDIOSInterrupts) { modify(.cr, clear: mask.rawValue) }
    public func getInterruptSource(_ mask: MDIOSInterrupts) -> UInt32 { registers.read(.cr) & mask.rawValue }
    public func getWriteFlag(_ mask: UInt32) -> UInt32 { registers.read(.wrfr) & mask }
    public func getReadFlag(_ mask: UInt32) -> UInt32 { registers.read(.rdfr) & mask }
    public func getErrorFlag(_ mask: MDIOSHardwareErrors) -> UInt32 { registers.read(.sr) & mask.rawValue }
    public func clearErrorFlag(_ mask: MDIOSHardwareErrors) { modify(.clrfr, set: mask.rawValue) }
    public func enableWakeupInterrupt(mask: UInt32 = 0x400) { modifyWakeup(.imr2, set: mask) }
    // Preserve the upstream macros: EXTI42 is a direct line on H7RS. Its
    // edge/software/pending bits are reserved; the IMR2 mask is implemented.
    public func getWakeupFlag(mask: UInt32 = 0x400) -> UInt32 { registers.read(MDIOSWakeupRegister.pr2) & mask }
    public func clearWakeupFlag(mask: UInt32 = 0x400) { registers.write(MDIOSWakeupRegister.pr2, value: mask) }
    public func enableWakeupRisingEdge(mask: UInt32 = 0x400) { modifyWakeup(.ftsr2, clear: mask); modifyWakeup(.rtsr2, set: mask) }
    public func enableWakeupFallingEdge(mask: UInt32 = 0x400) { modifyWakeup(.rtsr2, clear: mask); modifyWakeup(.ftsr2, set: mask) }
    public func enableWakeupBothEdges(mask: UInt32 = 0x400) { modifyWakeup(.rtsr2, set: mask); modifyWakeup(.ftsr2, set: mask) }
    public func generateWakeupInterrupt(mask: UInt32 = 0x400) { modifyWakeup(.swier2, set: mask) }
    func modify(_ register: MDIOSRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func modifyWakeup(_ register: MDIOSWakeupRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func lock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func unlock() { handle.write(.lock, value: 0) }
}
