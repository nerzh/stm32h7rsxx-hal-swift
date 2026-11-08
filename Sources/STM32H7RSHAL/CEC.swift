// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CEC operations and definitions from stm32h7rsxx_hal_cec.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CEC {
    public func setConfiguration(_ configuration: CECConfiguration, receiveBuffer: UnsafeMutablePointer<UInt8>?) {
        handle.write(.signalFreeTime, value: configuration.signalFreeTime)
        handle.write(.tolerance, value: configuration.tolerance)
        handle.write(.bitRisingErrorReceiveStop, value: configuration.bitRisingErrorReceiveStop)
        handle.write(.bitRisingErrorGeneration, value: configuration.bitRisingErrorGeneration)
        handle.write(.longBitPeriodErrorGeneration, value: configuration.longBitPeriodErrorGeneration)
        handle.write(.broadcastNoErrorGeneration, value: configuration.broadcastNoErrorGeneration)
        handle.write(.signalFreeTimeOption, value: configuration.signalFreeTimeOption)
        handle.write(.listenMode, value: configuration.listenMode)
        handle.write(.ownAddress, value: configuration.ownAddress)
        handle.writePointer(.receive, value: receiveBuffer.map { UnsafeMutableRawPointer($0) })
    }
    @discardableResult
    public func initialize() -> HALStatus {
        guard handle.readPointer(.receive) != nil else { return .error }
        precondition(handle.read(.signalFreeTime) <= 7)
        precondition(CECTolerance(rawValue: handle.read(.tolerance)) != nil)
        precondition(CECBitRisingErrorReceiveStop(rawValue: handle.read(.bitRisingErrorReceiveStop)) != nil)
        precondition(CECBitRisingErrorGeneration(rawValue: handle.read(.bitRisingErrorGeneration)) != nil)
        precondition(CECLongBitPeriodErrorGeneration(rawValue: handle.read(.longBitPeriodErrorGeneration)) != nil)
        precondition(CECBroadcastErrorGeneration(rawValue: handle.read(.broadcastNoErrorGeneration)) != nil)
        precondition(CECSignalFreeTimeOption(rawValue: handle.read(.signalFreeTimeOption)) != nil)
        precondition(CECListenMode(rawValue: handle.read(.listenMode)) != nil)
        precondition(handle.read(.ownAddress) <= 0x7FFF)
        if handle.read(.globalState) == 0 {
            unlock()
            if useRegisteredCallbacks {
                callbacks.write(.transmitComplete, value: defaults.transmitComplete)
                callbacks.writeReceive(defaults.receiveComplete)
                callbacks.write(.error, value: defaults.error)
                prepareMSPCallback(.mspInitialize)
            }
            invoke(.mspInitialize)
        }
        handle.write(.globalState, value: 0x24); disable()
        let cfgr = handle.read(.signalFreeTime) | handle.read(.tolerance) | handle.read(.bitRisingErrorReceiveStop)
            | handle.read(.bitRisingErrorGeneration) | handle.read(.longBitPeriodErrorGeneration)
            | handle.read(.broadcastNoErrorGeneration) | handle.read(.signalFreeTimeOption)
            | (UInt32(handle.read(.ownAddress)) << 16) | handle.read(.listenMode)
        registers.write(.cfgr, value: cfgr)
        enableInterrupts(.init(rawValue: 0x1FFF)); enable()
        handle.write(.errorCode, value: 0); handle.write(.globalState, value: 0x20); handle.write(.receiveState, value: 0x20)
        return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        handle.write(.globalState, value: 0x24)
        prepareMSPCallback(.mspDeinitialize); invoke(.mspDeinitialize)
        disable(); clearFlag(.init(rawValue: 0x1FFF)); disableInterrupts(.init(rawValue: 0x1FFF))
        handle.write(.errorCode, value: 0); handle.write(.globalState, value: 0); handle.write(.receiveState, value: 0)
        unlock(); return .ok
    }
    @discardableResult
    public func setDeviceAddress(_ address: UInt16) -> HALStatus {
        precondition(address <= 0x7FFF)
        guard handle.read(.globalState) == 0x20 && handle.read(.receiveState) == 0x20 else { return .busy }
        guard lock() else { return .busy }
        handle.write(.globalState, value: 0x24); disable()
        if address != 0 { setOwnAddress(UInt32(address)) } else { clearOwnAddress() }
        handle.write(.globalState, value: 0x20); handle.write(.errorCode, value: 0)
        unlock(); enable(); return .ok
    }
    @discardableResult
    public func transmitInterrupt(initiator: UInt8, destination: UInt8, data: UnsafePointer<UInt8>?, count: UInt32) -> HALStatus {
        guard handle.read(.globalState) == 0x20 else { return .busy }
        if data == nil && count > 0 { return .error }
        precondition(destination <= 0xF && initiator <= 0xF && count <= 0x10)
        guard lock() else { return .busy }
        handle.writePointer(.transmit, value: data.map { UnsafeMutableRawPointer(mutating: $0) })
        handle.write(.globalState, value: 0x21); handle.write(.errorCode, value: 0)
        handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: count))
        if count == 0 { setLastTransmitByte() }
        registers.write(.txdr, value: (UInt32(initiator) << 4) | UInt32(destination))
        setFirstTransmitByte(); unlock(); return .ok
    }
    public func getLastReceivedFrameSize() -> UInt32 { UInt32(handle.read(.receiveSize)) }
    public func changeReceiveBuffer(_ buffer: UnsafeMutablePointer<UInt8>?) { handle.writePointer(.receive, value: buffer.map { UnsafeMutableRawPointer($0) }) }
    public func getState() -> UInt32 {
        let global = handle.read(.globalState), receive = handle.read(.receiveState)
        return global | receive
    }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func resetHandleState() {
        handle.write(.globalState, value: 0); handle.write(.receiveState, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
    public func getFlag(_ flags: CECFlags) -> UInt32 { registers.read(.isr) & flags.rawValue }
    public func clearFlag(_ flags: CECFlags) { modify(.isr, set: flags.rawValue) }
    public func enableInterrupts(_ mask: CECInterrupts) { modify(.ier, set: mask.rawValue) }
    public func disableInterrupts(_ mask: CECInterrupts) { modify(.ier, clear: mask.rawValue) }
    public func getInterruptSource(_ mask: CECInterrupts) -> UInt32 { registers.read(.ier) & mask.rawValue }
    public func enable() { modify(.cr, set: 1) }
    public func disable() { modify(.cr, clear: 1) }
    public func setFirstTransmitByte() { modify(.cr, set: 2) }
    public func setLastTransmitByte() { modify(.cr, set: 4) }
    public func getTransmissionStartFlag() -> UInt32 { registers.read(.cr) & 2 }
    public func getTransmissionEndFlag() -> UInt32 { registers.read(.cr) & 4 }
    public func clearOwnAddress() { modify(.cfgr, clear: 0x7FFF0000) }
    public func setOwnAddress(_ address: UInt32) { modify(.cfgr, set: address << 16) }
    func modify(_ register: CECRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func lock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func unlock() { handle.write(.lock, value: 0) }
}
