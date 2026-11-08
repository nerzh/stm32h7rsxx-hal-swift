// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LPTIM operations and definitions from stm32h7rsxx_hal_lptim.c/.h and
// stm32h7rsxx_ll_lptim.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension LPTIM {
    @discardableResult
    public func startPWM(channel: LPTIMChannel, interrupts: Bool = false) -> HALStatus {
        startOutput(channel: channel, mode: 0, interrupts: interrupts)
    }
    @discardableResult
    public func stopPWM(channel: LPTIMChannel, interrupts: Bool = false) -> HALStatus {
        stopOutput(channel: channel, setOnce: false, interrupts: interrupts)
    }
    @discardableResult
    public func startOnePulse(channel: LPTIMChannel, interrupts: Bool = false) -> HALStatus {
        startOutput(channel: channel, mode: 1, interrupts: interrupts)
    }
    @discardableResult
    public func stopOnePulse(channel: LPTIMChannel, interrupts: Bool = false) -> HALStatus {
        stopOutput(channel: channel, setOnce: false, interrupts: interrupts)
    }
    @discardableResult
    public func startSetOnce(channel: LPTIMChannel, interrupts: Bool = false) -> HALStatus {
        startOutput(channel: channel, mode: 2, interrupts: interrupts)
    }
    @discardableResult
    public func stopSetOnce(channel: LPTIMChannel, interrupts: Bool = false) -> HALStatus {
        stopOutput(channel: channel, setOnce: true, interrupts: interrupts)
    }
    private func outputInterrupts(_ channel: LPTIMChannel) -> LPTIMInterrupts {
        channel == .channel1 ? [.compare1Write, .captureCompare1, .autoReloadWrite, .autoReloadMatch]
                            : [.compare2Write, .captureCompare2, .autoReloadWrite, .autoReloadMatch]
    }
    private func startOutput(channel: LPTIMChannel, mode: UInt32, interrupts: Bool) -> HALStatus {
        validate(channel)
        guard handle.read(channelWord(channel)) == 1 else { return .error }
        handle.write(.state, value: 2); handle.write(channelWord(channel), value: 2)
        if mode == 2 { modify(.cfgr, set: 0x100000) } else { modify(.cfgr, clear: 0x100000) }
        enable()
        if interrupts {
            clearFlag(.interruptEnableWrite)
            var mask = outputInterrupts(channel).union(.update)
            if mode != 2 { mask.formUnion(.repetitionWrite) }
            enableInterrupts(mask)
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
            if handle.read(.triggerSource) != 0xFFFF {
                clearFlag(.interruptEnableWrite); enableInterrupts(.externalTrigger)
                if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
            }
        }
        enableCaptureCompare(channel: channel)
        if mode == 0 { startContinuous() } else { startSingle() }
        handle.write(.state, value: 1)
        return .ok
    }
    private func stopOutput(channel: LPTIMChannel, setOnce: Bool, interrupts: Bool) -> HALStatus {
        validate(channel)
        handle.write(.state, value: 2)
        disableCaptureCompare(channel: channel); disable()
        if interrupts {
            enable(); clearFlag(.interruptEnableWrite)
            var mask = outputInterrupts(channel)
            // SetOnce_Stop_IT intentionally leaves UPDATE enabled in the C driver.
            if !setOnce { mask.formUnion([.repetitionWrite, .update]) }
            disableInterrupts(mask)
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
            if handle.read(.triggerSource) != 0xFFFF {
                clearFlag(.interruptEnableWrite); disableInterrupts(.externalTrigger)
                if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
            }
            disable()
        }
        handle.write(channelWord(channel), value: 1); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func startEncoder(interrupts: Bool = false) -> HALStatus {
        precondition(registers.instance.supportsCaptureAndDMA)
        precondition(handle.read(.clockSource) == 0 && handle.read(.clockPrescaler) == 0)
        precondition(LPTIMClockPolarity(rawValue: handle.read(.clockPolarity)) != nil)
        handle.write(.state, value: 2)
        modify(.cfgr, clear: 6, set: handle.read(.clockPolarity))
        modify(.cfgr, set: 0x1000000)
        enable()
        if interrupts {
            clearFlag(.interruptEnableWrite); enableInterrupts([.directionUp, .directionDown])
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
        }
        startContinuous(); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func stopEncoder(interrupts: Bool = false) -> HALStatus {
        precondition(registers.instance.supportsCaptureAndDMA)
        handle.write(.state, value: 2)
        disable(); modify(.cfgr, clear: 0x1000000)
        if interrupts {
            enable(); clearFlag(.interruptEnableWrite); disableInterrupts([.directionUp, .directionDown])
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
            disable()
        }
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func startTimeout(_ timeout: UInt32, interrupts: Bool = false) -> HALStatus {
        precondition(timeout <= 0xFFFF)
        handle.write(.state, value: 2)
        if interrupts { enableWakeupInterrupt() }
        modify(.cfgr, set: 0x80000); enable()
        if interrupts {
            clearFlag(.interruptEnableWrite); enableInterrupts(.captureCompare1)
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
        }
        clearFlag(.compare1Write); setCompare(channel: .channel1, value: timeout)
        if waitForFlag(.compare1Write) == .timeout { return .timeout }
        startContinuous(); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func stopTimeout(interrupts: Bool = false) -> HALStatus {
        if interrupts { disableWakeupInterrupt() }
        handle.write(.state, value: 2)
        disable(); modify(.cfgr, clear: 0x80000)
        if interrupts {
            enable(); clearFlag(.interruptEnableWrite); disableInterrupts(.captureCompare1)
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
            disable()
        }
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func startCounter(interrupts: Bool = false) -> HALStatus {
        handle.write(.state, value: 2)
        if interrupts { enableWakeupInterrupt() }
        if handle.read(.clockSource) != 1 && handle.read(.counterSource) == 0x800000 {
            precondition(handle.read(.clockPrescaler) == 0)
            modify(.cfgr, clear: 0xE00)
        }
        enable()
        if interrupts {
            clearFlag(.interruptEnableWrite)
            enableInterrupts([.autoReloadWrite, .autoReloadMatch, .repetitionWrite, .update])
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
        }
        startContinuous(); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func stopCounter(interrupts: Bool = false) -> HALStatus {
        if interrupts { disableWakeupInterrupt() }
        handle.write(.state, value: 2); disable()
        if interrupts {
            enable(); clearFlag(.interruptEnableWrite)
            disableInterrupts([.autoReloadWrite, .autoReloadMatch, .repetitionWrite, .update])
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
            disable()
        }
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func startInputCapture(channel: LPTIMChannel, interrupts: Bool = false) -> HALStatus {
        precondition(registers.instance.supportsCaptureAndDMA)
        guard handle.read(channelWord(channel)) == 1 else { return .error }
        handle.write(.state, value: 2); handle.write(channelWord(channel), value: 2)
        enable()
        if interrupts {
            enableInterrupts(channel == .channel1 ? .captureCompare1 : .captureCompare2)
            if waitForFlag(.interruptEnableWrite) == .timeout { return .timeout }
        }
        startContinuous(); enableCaptureCompare(channel: channel)
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func stopInputCapture(channel: LPTIMChannel, interrupts: Bool = false) -> HALStatus {
        precondition(registers.instance.supportsCaptureAndDMA)
        handle.write(.state, value: 2)
        if interrupts { disableInterrupts(channel == .channel1 ? .captureCompare1 : .captureCompare2) }
        disableCaptureCompare(channel: channel); disable()
        handle.write(channelWord(channel), value: 1); handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func configureOutputCompare(_ configuration: LPTIMOutputCompareConfiguration, channel: LPTIMChannel) -> HALStatus {
        validate(channel)
        precondition(LPTIMOutputPolarity(rawValue: configuration.polarity) != nil && configuration.pulse <= 0xFFFF)
        handle.write(.state, value: 2)
        let shift = channel.rawValue * 16
        var ccmr = registers.read(.ccmr1)
        ccmr &= ~(0xD << shift)
        if channel == .channel1 && !registers.instance.supportsCaptureAndDMA {
            modify(.cfgr, clear: 0x200000, set: configuration.polarity << 21)
        } else { ccmr |= configuration.polarity << (2 + shift) }
        enable()
        let flag: LPTIMFlags = channel == .channel1 ? .compare1Write : .compare2Write
        clearFlag(flag); setCompare(channel: channel, value: configuration.pulse)
        if waitForFlag(flag) == .timeout { return .timeout }
        disable(); registers.write(.ccmr1, value: ccmr)
        handle.write(.state, value: 1)
        return .ok
    }
    @discardableResult
    public func configureInputCapture(_ configuration: LPTIMInputCaptureConfiguration, channel: LPTIMChannel) -> HALStatus {
        validate(channel)
        precondition(LPTIMCapturePrescaler(rawValue: configuration.prescaler) != nil)
        precondition(LPTIMCapturePolarity(rawValue: configuration.polarity) != nil)
        precondition(LPTIMCaptureFilter(rawValue: configuration.filter) != nil)
        handle.write(.state, value: 2)
        precondition(registers.instance.supportsCaptureAndDMA)
        if channel == .channel1 || registers.instance == .lptim3 { precondition(configuration.inputSource == 0) }
        else { precondition(configuration.inputSource == 0 || configuration.inputSource == 0x100000 || configuration.inputSource == 0x200000) }
        let shift = channel.rawValue * 16
        var ccmr = registers.read(.ccmr1)
        ccmr &= ~(0x330C << shift)
        ccmr |= (configuration.prescaler | configuration.polarity | configuration.filter | 1) << shift
        var cfgr2 = registers.read(.cfgr2)
        cfgr2 &= ~(channel == .channel1 ? 0x30000 : 0x300000)
        cfgr2 |= configuration.inputSource
        registers.write(.ccmr1, value: ccmr); registers.write(.cfgr2, value: cfgr2)
        handle.write(.state, value: 1)
        return .ok
    }
}
