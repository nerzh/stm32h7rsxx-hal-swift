// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PSSI operations and definitions from stm32h7rsxx_hal_pssi.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PSSI {
    public func setConfiguration(_ configuration: PSSIConfiguration) {
        handle.write(.dataWidth, value: configuration.dataWidth); handle.write(.busWidth, value: configuration.busWidth)
        handle.write(.controlSignal, value: configuration.controlSignal); handle.write(.clockPolarity, value: configuration.clockPolarity)
        handle.write(.dataEnablePolarity, value: configuration.dataEnablePolarity); handle.write(.readyPolarity, value: configuration.readyPolarity)
    }
    @discardableResult
    public func initialize() -> HALStatus {
        precondition(PSSIControlSignal(rawValue: handle.read(.controlSignal)) != nil)
        precondition(PSSIBusWidth(rawValue: handle.read(.busWidth)) != nil)
        precondition(PSSIClockPolarity(rawValue: handle.read(.clockPolarity)) != nil)
        precondition(PSSIDataEnablePolarity(rawValue: handle.read(.dataEnablePolarity)) != nil)
        precondition(PSSIReadyPolarity(rawValue: handle.read(.readyPolarity)) != nil)
        if handle.read(.state) == 0 {
            unlock()
            if useRegisteredCallbacks {
                callbacks.write(.transmitComplete, value: defaults.transmitComplete)
                callbacks.write(.receiveComplete, value: defaults.receiveComplete)
                callbacks.write(.error, value: defaults.error)
                callbacks.write(.abortComplete, value: defaults.abortComplete)
                prepareMSPCallback(.mspInitialize)
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 2); disable()
        modify(.cr, clear: 0x1C0D40, set: handle.read(.controlSignal) | handle.read(.dataEnablePolarity) | handle.read(.readyPolarity) | handle.read(.busWidth))
        handle.write(.errorCode, value: 0); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        handle.write(.state, value: 2); disable()
        prepareMSPCallback(.mspDeinitialize); invoke(.mspDeinitialize)
        handle.write(.errorCode, value: 0); handle.write(.state, value: 0); unlock()
        return .ok
    }
    @discardableResult
    public func configureClock(_ source: UInt32) -> HALStatus {
        precondition(PSSIClockSource(rawValue: source) != nil)
        guard handle.read(.state) == 1 else { return .busy }
        guard lock() else { return .busy }
        disable(); modify(.cr, clear: 0x20000000, set: source); enable(); unlock()
        return .ok
    }
    @discardableResult
    public func configureClock(_ source: PSSIClockSource) -> HALStatus { configureClock(source.rawValue) }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func enable() { modify(.cr, set: 0x4000) }
    public func disable() { modify(.cr, clear: 0x4000) }
    public func getStatus(_ flags: UInt32) -> UInt32 { registers.read(.sr) & flags }
    public func getFlag(_ flags: UInt32) -> UInt32 { registers.read(.ris) & flags }
    public func clearFlag(_ flags: UInt32) { registers.write(.icr, value: flags) }
    public func enableInterrupts(_ mask: UInt32) { modify(.ier, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { modify(.ier, clear: mask) }
    public func getInterruptSource(_ mask: UInt32) -> UInt32 { registers.read(.ier) & mask }
    func modify(_ register: PSSIRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func lock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func unlock() { handle.write(.lock, value: 0) }
}
