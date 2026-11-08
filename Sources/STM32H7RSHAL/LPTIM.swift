// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LPTIM operations and definitions from stm32h7rsxx_hal_lptim.c/.h and
// stm32h7rsxx_ll_lptim.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension LPTIM {
    public func setConfiguration(_ configuration: LPTIMConfiguration) {
        handle.write(.clockSource, value: configuration.clockSource)
        handle.write(.clockPrescaler, value: configuration.clockPrescaler)
        handle.write(.clockPolarity, value: configuration.clockPolarity)
        handle.write(.clockSampleTime, value: configuration.clockSampleTime)
        handle.write(.triggerSource, value: configuration.triggerSource)
        handle.write(.triggerActiveEdge, value: configuration.triggerActiveEdge)
        handle.write(.triggerSampleTime, value: configuration.triggerSampleTime)
        handle.write(.period, value: configuration.period)
        handle.write(.updateMode, value: configuration.updateMode)
        handle.write(.counterSource, value: configuration.counterSource)
        handle.write(.input1Source, value: configuration.input1Source)
        handle.write(.input2Source, value: configuration.input2Source)
        handle.write(.repetitionCounter, value: configuration.repetitionCounter)
    }
    @discardableResult
    public func initialize() -> HALStatus {
        precondition((1...0xFFFF).contains(handle.read(.period)))
        precondition(LPTIMClockSource(rawValue: handle.read(.clockSource)) != nil)
        precondition(LPTIMPrescaler(rawValue: handle.read(.clockPrescaler)) != nil)
        if handle.read(.clockSource) == 1 || handle.read(.counterSource) == 0x800000 {
            precondition(LPTIMClockPolarity(rawValue: handle.read(.clockPolarity)) != nil)
            precondition(LPTIMClockSampleTime(rawValue: handle.read(.clockSampleTime)) != nil)
        }
        precondition(LPTIMTriggerSource(rawValue: handle.read(.triggerSource)) != nil)
        if handle.read(.triggerSource) != 0xFFFF {
            precondition(LPTIMTriggerActiveEdge(rawValue: handle.read(.triggerActiveEdge)) != nil)
            precondition(LPTIMTriggerSampleTime(rawValue: handle.read(.triggerSampleTime)) != nil)
        }
        precondition(LPTIMUpdateMode(rawValue: handle.read(.updateMode)) != nil)
        precondition(LPTIMCounterSource(rawValue: handle.read(.counterSource)) != nil)
        precondition(handle.read(.repetitionCounter) <= 0xFF)
        if handle.read(.state) == 0 {
            handle.write(.lock, value: 0)
            if useRegisteredCallbacks {
                for id in LPTIMCallbackID.allCases where id.rawValue >= 2 && id != .error {
                    callbacks.write(id, value: defaults.callback(id))
                }
                callbacks.write(.error, value: defaults.callback(.error))
                prepareMSPCallback(.mspInitialize)
            }
            invoke(.mspInitialize)
        }
        handle.write(.state, value: 2)
        enable()
        clearFlag(.repetitionWrite)
        setRepetitionCounter(handle.read(.repetitionCounter))
        if waitForFlag(.repetitionWrite) == .timeout { return .timeout }
        clearFlag(.autoReloadWrite)
        setAutoReload(handle.read(.period))
        if waitForFlag(.autoReloadWrite) == .timeout { return .timeout }
        disable()
        var cfgr = registers.read(.cfgr)
        if handle.read(.clockSource) == 1 || handle.read(.counterSource) == 0x800000 { cfgr &= ~(0x6 | 0x18) }
        if handle.read(.triggerSource) != 0xFFFF { cfgr &= ~(0xC0 | 0xE000) }
        cfgr &= ~(0x1 | 0x60000 | 0x400000 | 0xE00 | 0x800000)
        cfgr |= handle.read(.clockSource) | handle.read(.clockPrescaler) | handle.read(.updateMode) | handle.read(.counterSource)
        if handle.read(.clockSource) == 0 { cfgr |= handle.read(.triggerSampleTime) | handle.read(.clockSampleTime) }
        if handle.read(.clockSource) == 1 || handle.read(.counterSource) == 0x800000 {
            cfgr |= handle.read(.clockPolarity) | handle.read(.clockSampleTime)
        }
        if handle.read(.triggerSource) != 0xFFFF {
            cfgr |= handle.read(.triggerSource) | handle.read(.triggerActiveEdge) | handle.read(.triggerSampleTime)
        }
        registers.write(.cfgr, value: cfgr)
        if registers.instance == .lptim1 || registers.instance == .lptim2 {
            precondition(handle.read(.input1Source) == 0 && handle.read(.input2Source) == 0)
            registers.write(.cfgr2, value: handle.read(.input1Source) | handle.read(.input2Source))
        } else if registers.instance == .lptim3 {
            precondition(handle.read(.input1Source) == 0)
            registers.write(.cfgr2, value: handle.read(.input1Source))
        }
        handle.write(.channel1State, value: 1); handle.write(.channel2State, value: 1)
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        handle.write(.state, value: 2)
        enable()
        if registers.instance.supportsCaptureAndDMA { registers.write(.ccmr1, value: 0) }
        clearFlag(.compare1Write); setCompare(channel: .channel1, value: 0)
        if waitForFlag(.compare1Write) == .timeout { return .timeout }
        if registers.instance.supportsCaptureAndDMA {
            clearFlag(.compare2Write); setCompare(channel: .channel2, value: 0)
            if waitForFlag(.compare2Write) == .timeout { return .timeout }
        }
        clearFlag(.autoReloadWrite); setAutoReload(0)
        if waitForFlag(.autoReloadWrite) == .timeout { return .timeout }
        disable()
        registers.write(.cfgr, value: 0); registers.write(.cfgr2, value: 0)
        prepareMSPCallback(.mspDeinitialize); invoke(.mspDeinitialize)
        handle.write(.channel1State, value: 0); handle.write(.channel2State, value: 0)
        handle.write(.state, value: 0); handle.write(.lock, value: 0)
        return .ok
    }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        handle.write(.channel1State, value: 0); handle.write(.channel2State, value: 0)
        if useRegisteredCallbacks {
            callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil)
        }
    }
    public func getState() -> UInt32 { handle.read(.state) }
    public func readCounter() -> UInt32 { registers.read(.cnt) }
    public func readAutoReload() -> UInt32 { registers.read(.arr) }
    public func readCapturedValue(channel: LPTIMChannel) -> UInt32 {
        validate(channel); return registers.read(channel == .channel1 ? .ccr1 : .ccr2)
    }
    public func inputCaptureOffset(channel: LPTIMChannel) -> UInt8 {
        let prescaler = (registers.read(.cfgr) & 0xE00) >> 9
        let filter = ((registers.read(.ccmr1) >> (channel.rawValue * 16)) & 0x3000) >> 12
        // Exact LL_LPTIM_OFFSET_TAB_ICx, indexed by the clock prescaler and IC filter.
        switch prescaler {
        case 0: switch filter { case 0: return 2; case 1: return 7; case 2: return 9; default: return 13 }
        case 1: switch filter { case 0: return 3; case 1: return 5; case 2: return 6; default: return 8 }
        case 2: switch filter { case 0: return 2; case 1: return 3; case 2: return 4; default: return 5 }
        case 3: return filter < 2 ? 2 : 3
        default: return 2
        }
    }
    public func enable() { modify(.cr, set: 1) }
    public func disable() {
        if registers.read(.ccmr1) & 2 == 0 {
            if registers.read(.ccmr1) & 0x20000 == 0 { modify(.cr, clear: 1) }
        }
    }
    public func startContinuous() { modify(.cr, set: 4) }
    public func startSingle() { modify(.cr, set: 2) }
    public func resetCounter() { modify(.cr, set: 8) }
    public func resetCounterAfterRead() { modify(.cr, set: 0x10) }
    public func setAutoReload(_ value: UInt32) { registers.write(.arr, value: value) }
    public func setCompare(channel: LPTIMChannel, value: UInt32) { registers.write(channel == .channel1 ? .ccr1 : .ccr2, value: value) }
    public func setRepetitionCounter(_ value: UInt32) { registers.write(.rcr, value: value) }
    public func getRepetitionCounter() -> UInt32 { registers.read(.rcr) }
    public func enableCaptureCompare(channel: LPTIMChannel) { modify(.ccmr1, set: 2 << (channel.rawValue * 16)) }
    public func disableCaptureCompare(channel: LPTIMChannel) { modify(.ccmr1, clear: 2 << (channel.rawValue * 16)) }
    public func getFlag(_ flags: LPTIMFlags) -> Bool { registers.read(.isr) & flags.rawValue == flags.rawValue }
    public func clearFlag(_ flags: LPTIMFlags) { registers.write(.icr, value: flags.rawValue) }
    public func enableInterrupts(_ interrupts: LPTIMInterrupts) { modify(.dier, set: interrupts.rawValue) }
    public func disableInterrupts(_ interrupts: LPTIMInterrupts) { modify(.dier, clear: interrupts.rawValue) }
    public func getInterruptSource(_ interrupts: LPTIMInterrupts) -> Bool { registers.read(.dier) & interrupts.rawValue == interrupts.rawValue }
    public func enableDMARequests(_ requests: LPTIMDMARequests) { modify(.dier, set: requests.rawValue) }
    public func disableDMARequests(_ requests: LPTIMDMARequests) { modify(.dier, clear: requests.rawValue) }
    public func enableWakeupInterrupt() { registers.writeWakeupInterruptMask(registers.readWakeupInterruptMask() | registers.instance.wakeupInterruptMask) }
    public func disableWakeupInterrupt() { registers.writeWakeupInterruptMask(registers.readWakeupInterruptMask() & ~registers.instance.wakeupInterruptMask) }
    func modify(_ register: LPTIMRegister, clear: UInt32 = 0, set: UInt32 = 0) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }
    func validate(_ channel: LPTIMChannel) { precondition(channel == .channel1 || registers.instance.supportsCaptureAndDMA) }
    func channelWord(_ channel: LPTIMChannel) -> LPTIMHandleWord { channel == .channel1 ? .channel1State : .channel2State }
    func waitForFlag(_ flag: LPTIMFlags) -> HALStatus {
        var result = HALStatus.ok
        var count: UInt32 = 1000 &* (getSystemCoreClock() / 20 / 1000)
        repeat {
            count &-= 1
            if count == 0 { result = .timeout }
        } while !getFlag(flag) && count != 0
        return result
    }
}
