// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    @discardableResult
    public func start(getTick: () -> UInt32) -> HALStatus { start(interrupts: false, getTick: getTick) }
    @discardableResult
    public func startInterrupt(getTick: () -> UInt32) -> HALStatus { start(interrupts: true, getTick: getTick) }
    private func start(interrupts: Bool, getTick: () -> UInt32) -> HALStatus {
        let mode = LL_ADC_GetMultimode()
        if LL_ADC_REG_IsConversionOngoing(instance) != 0 { return .busy }
        if !tryLock() { return .busy }
        let status = enable(getTick: getTick)
        if status == .ok {
            modifyState(clear: ADCC.HAL_ADC_STATE_READY | ADCC.HAL_ADC_STATE_REG_EOC | ADCC.HAL_ADC_STATE_REG_OVR | ADCC.HAL_ADC_STATE_REG_EOSMP,
                        set: ADCC.HAL_ADC_STATE_REG_BUSY)
            if instance == .adc1 || mode == ADCC.LL_ADC_MULTI_INDEPENDENT { clearState(ADCC.HAL_ADC_STATE_MULTIMODE_SLAVE) }
            if handle.read(.state) & ADCC.HAL_ADC_STATE_INJ_BUSY != 0 { clearError(ADCC.HAL_ADC_ERROR_OVR | ADCC.HAL_ADC_ERROR_DMA) }
            else { handle.write(.errorCode, value: 0) }
            clearFlag(ADCC.ADC_FLAG_EOC | ADCC.ADC_FLAG_EOS | ADCC.ADC_FLAG_OVR)
            unlock()
            if interrupts {
                disableInterrupts(ADCC.ADC_IT_EOC | ADCC.ADC_IT_EOS | ADCC.ADC_IT_OVR)
                enableInterrupts(handle.read(.eocSelection) == ADCC.ADC_EOC_SEQ_CONV ? ADCC.ADC_IT_EOS : ADCC.ADC_IT_EOC)
                if handle.read(.overrun) == ADCC.ADC_OVR_DATA_PRESERVED { enableInterrupts(ADCC.ADC_IT_OVR) }
            }
            if instance == .adc1 || regularIndependent(mode) {
                if read(.cfgr) & ADCC.ADC_CFGR_JAUTO != 0 {
                    modifyState(clear: ADCC.HAL_ADC_STATE_INJ_EOC, set: ADCC.HAL_ADC_STATE_INJ_BUSY)
                    if interrupts { configureInjectedCompletionInterrupt() }
                }
                LL_ADC_REG_StartConversion(instance)
            } else {
                addState(ADCC.HAL_ADC_STATE_MULTIMODE_SLAVE)
                if registers.read(.cfgr, instance: .adc1) & ADCC.ADC_CFGR_JAUTO != 0 {
                    modifyState(clear: ADCC.HAL_ADC_STATE_INJ_EOC, set: ADCC.HAL_ADC_STATE_INJ_BUSY)
                    if interrupts { configureInjectedCompletionInterrupt() }
                }
            }
        } else { unlock() }
        return status
    }
    func regularIndependent(_ mode: UInt32) -> Bool {
        mode == ADCC.LL_ADC_MULTI_INDEPENDENT || mode == ADCC.LL_ADC_MULTI_DUAL_INJ_SIMULT || mode == ADCC.LL_ADC_MULTI_DUAL_INJ_ALTERN
    }
    func configureInjectedCompletionInterrupt() {
        if handle.read(.eocSelection) == ADCC.ADC_EOC_SEQ_CONV {
            disableInterrupts(ADCC.ADC_IT_JEOC); enableInterrupts(ADCC.ADC_IT_JEOS)
        } else {
            disableInterrupts(ADCC.ADC_IT_JEOS); enableInterrupts(ADCC.ADC_IT_JEOC)
        }
    }
    @discardableResult
    public func stop(getTick: () -> UInt32) -> HALStatus { stop(interrupts: false, getTick: getTick) }
    @discardableResult
    public func stopInterrupt(getTick: () -> UInt32) -> HALStatus { stop(interrupts: true, getTick: getTick) }
    private func stop(interrupts: Bool, getTick: () -> UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        var status = conversionStop(group: ADCC.ADC_REGULAR_INJECTED_GROUP, getTick: getTick)
        if status == .ok {
            if interrupts { disableInterrupts(ADCC.ADC_IT_EOC | ADCC.ADC_IT_EOS | ADCC.ADC_IT_OVR) }
            status = disable(getTick: getTick)
            if status == .ok { modifyState(clear: ADCC.HAL_ADC_STATE_REG_BUSY | ADCC.HAL_ADC_STATE_INJ_BUSY, set: ADCC.HAL_ADC_STATE_READY) }
        }
        unlock(); return status
    }
    @discardableResult
    public func pollForConversion(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        let mode = LL_ADC_GetMultimode()
        let end: UInt32
        if handle.read(.eocSelection) == ADCC.ADC_EOC_SEQ_CONV { end = ADCC.ADC_FLAG_EOS }
        else {
            if regularIndependent(mode) {
                if read(.cfgr) & ADCC.ADC_CFGR_DMAEN != 0 { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); return .error }
            } else if LL_ADC_GetMultiDMATransfer() != ADCC.LL_ADC_MULTI_REG_DMA_EACH_ADC {
                addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); return .error
            }
            end = ADCC.ADC_FLAG_EOC
        }
        let start = getTick()
        while read(.isr) & end == 0 {
            if timeout != UInt32.max {
                if getTick() &- start > timeout || timeout == 0 {
                    if read(.isr) & end == 0 { addState(ADCC.HAL_ADC_STATE_TIMEOUT); unlock(); return .timeout }
                }
            }
        }
        addState(ADCC.HAL_ADC_STATE_REG_EOC)
        if LL_ADC_REG_IsTriggerSourceSWStart(instance) != 0 && handle.read(.continuousConvMode) == 0 {
            if getFlag(ADCC.ADC_FLAG_EOS) {
                clearState(ADCC.HAL_ADC_STATE_REG_BUSY)
                if handle.read(.state) & ADCC.HAL_ADC_STATE_INJ_BUSY == 0 { addState(ADCC.HAL_ADC_STATE_READY) }
            }
        }
        let cfgr: UInt32
        if instance == .adc1 || regularIndependent(mode) { cfgr = read(.cfgr) }
        else { cfgr = registers.read(.cfgr, instance: .adc1) }
        if end == ADCC.ADC_FLAG_EOS { clearFlag(ADCC.ADC_FLAG_EOS) }
        else if cfgr & ADCC.ADC_CFGR_AUTDLY == 0 { clearFlag(ADCC.ADC_FLAG_EOC | ADCC.ADC_FLAG_EOS) }
        return .ok
    }
    @discardableResult
    public func pollForEvent(_ event: UInt32, timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        let start = getTick()
        while !getFlag(event) {
            if timeout != UInt32.max {
                if getTick() &- start > timeout || timeout == 0 {
                    if !getFlag(event) { addState(ADCC.HAL_ADC_STATE_TIMEOUT); unlock(); return .timeout }
                }
            }
        }
        switch event {
        case ADCC.ADC_EOSMP_EVENT: addState(ADCC.HAL_ADC_STATE_REG_EOSMP); clearFlag(ADCC.ADC_FLAG_EOSMP)
        case ADCC.ADC_AWD_EVENT: addState(ADCC.HAL_ADC_STATE_AWD1); clearFlag(ADCC.ADC_FLAG_AWD1)
        case ADCC.ADC_AWD2_EVENT: addState(ADCC.HAL_ADC_STATE_AWD2); clearFlag(ADCC.ADC_FLAG_AWD2)
        case ADCC.ADC_AWD3_EVENT: addState(ADCC.HAL_ADC_STATE_AWD3); clearFlag(ADCC.ADC_FLAG_AWD3)
        case ADCC.ADC_JQOVF_EVENT:
            addState(ADCC.HAL_ADC_STATE_INJ_JQOVF); addError(ADCC.HAL_ADC_ERROR_JQOVF); clearFlag(ADCC.ADC_FLAG_JQOVF)
        default:
            if handle.read(.overrun) == ADCC.ADC_OVR_DATA_PRESERVED {
                addState(ADCC.HAL_ADC_STATE_REG_OVR); addError(ADCC.HAL_ADC_ERROR_OVR)
            } else { clearFlag(ADCC.ADC_FLAG_OVR) }
        }
        return .ok
    }
    public func getValue() -> UInt32 { read(.dr) }
    @discardableResult
    public func startSampling() -> HALStatus { setBits(.cfgr2, ADCC.ADC_CFGR2_SWTRIG); return .ok }
    @discardableResult
    public func stopSampling() -> HALStatus { clearBits(.cfgr2, ADCC.ADC_CFGR2_SWTRIG); return .ok }
}
