// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    func injectedIndependent(_ mode: UInt32) -> Bool {
        mode == ADCC.LL_ADC_MULTI_INDEPENDENT || mode == ADCC.LL_ADC_MULTI_DUAL_REG_SIMULT || mode == ADCC.LL_ADC_MULTI_DUAL_REG_INTERL
    }
    @discardableResult
    public func startInjected(getTick: () -> UInt32) -> HALStatus { startInjected(interrupts: false, getTick: getTick) }
    @discardableResult
    public func startInjectedInterrupt(getTick: () -> UInt32) -> HALStatus { startInjected(interrupts: true, getTick: getTick) }
    private func startInjected(interrupts: Bool, getTick: () -> UInt32) -> HALStatus {
        let mode = LL_ADC_GetMultimode()
        if LL_ADC_INJ_IsConversionOngoing(instance) != 0 { return .busy }
        let queueDisabled = read(.cfgr) & ADCC.ADC_CFGR_JQDIS
        if read(.jsqr) & ADCC.ADC_JSQR_JEXTEN == 0 && queueDisabled == 0 { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); return .error }
        if !tryLock() { return .busy }
        let status = enable(getTick: getTick)
        if status == .ok {
            if handle.read(.state) & ADCC.HAL_ADC_STATE_REG_BUSY != 0 { clearError(ADCC.HAL_ADC_ERROR_JQOVF) }
            else { handle.write(.errorCode, value: 0) }
            modifyState(clear: ADCC.HAL_ADC_STATE_READY | ADCC.HAL_ADC_STATE_INJ_EOC, set: ADCC.HAL_ADC_STATE_INJ_BUSY)
            if instance == .adc1 || mode == ADCC.LL_ADC_MULTI_INDEPENDENT { clearState(ADCC.HAL_ADC_STATE_MULTIMODE_SLAVE) }
            clearFlag(ADCC.ADC_FLAG_JEOC | ADCC.ADC_FLAG_JEOS)
            unlock()
            if interrupts {
                if read(.cfgr) & ADCC.ADC_CFGR_JQM != 0 { enableInterrupts(ADCC.ADC_FLAG_JQOVF) }
                configureInjectedCompletionInterrupt()
            }
            if instance == .adc1 || injectedIndependent(mode) {
                if LL_ADC_INJ_GetTrigAuto(instance) == ADCC.LL_ADC_INJ_TRIG_INDEPENDENT { LL_ADC_INJ_StartConversion(instance) }
            } else { addState(ADCC.HAL_ADC_STATE_MULTIMODE_SLAVE) }
        } else { unlock() }
        return status
    }
    @discardableResult
    public func stopInjected(getTick: () -> UInt32) -> HALStatus { stopInjected(interrupts: false, getTick: getTick) }
    @discardableResult
    public func stopInjectedInterrupt(getTick: () -> UInt32) -> HALStatus { stopInjected(interrupts: true, getTick: getTick) }
    private func stopInjected(interrupts: Bool, getTick: () -> UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        var status = conversionStop(group: ADCC.ADC_INJECTED_GROUP, getTick: getTick)
        if status == .ok {
            if interrupts { disableInterrupts(ADCC.ADC_IT_JEOC | ADCC.ADC_IT_JEOS | ADCC.ADC_FLAG_JQOVF) }
            if LL_ADC_REG_IsConversionOngoing(instance) == 0 {
                status = disable(getTick: getTick)
                if status == .ok { modifyState(clear: ADCC.HAL_ADC_STATE_REG_BUSY | ADCC.HAL_ADC_STATE_INJ_BUSY, set: ADCC.HAL_ADC_STATE_READY) }
            } else { clearState(ADCC.HAL_ADC_STATE_INJ_BUSY) }
        }
        unlock(); return status
    }
    @discardableResult
    public func pollForInjectedConversion(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
        let mode = LL_ADC_GetMultimode()
        let end = handle.read(.eocSelection) == ADCC.ADC_EOC_SEQ_CONV ? ADCC.ADC_FLAG_JEOS : ADCC.ADC_FLAG_JEOC
        let start = getTick()
        while read(.isr) & end == 0 {
            if timeout != UInt32.max {
                if getTick() &- start > timeout || timeout == 0 {
                    if read(.isr) & end == 0 { addState(ADCC.HAL_ADC_STATE_TIMEOUT); unlock(); return .timeout }
                }
            }
        }
        let injectedSoftware = LL_ADC_INJ_IsTriggerSourceSWStart(instance)
        let regularSoftware = LL_ADC_REG_IsTriggerSourceSWStart(instance)
        let cfgr: UInt32
        if instance == .adc1 || injectedIndependent(mode) { cfgr = read(.cfgr) }
        else { cfgr = registers.read(.cfgr, instance: .adc1) }
        addState(ADCC.HAL_ADC_STATE_INJ_EOC)
        if injectedSoftware != 0 || ((cfgr & ADCC.ADC_CFGR_JAUTO == 0) && (regularSoftware != 0 && cfgr & ADCC.ADC_CFGR_CONT == 0)) {
            if getFlag(ADCC.ADC_FLAG_JEOS) {
                if cfgr & ADCC.ADC_CFGR_JQM == 0 {
                    clearState(ADCC.HAL_ADC_STATE_INJ_BUSY)
                    if handle.read(.state) & ADCC.HAL_ADC_STATE_REG_BUSY == 0 { addState(ADCC.HAL_ADC_STATE_READY) }
                }
            }
        }
        if end == ADCC.ADC_FLAG_JEOS {
            if cfgr & ADCC.ADC_CFGR_AUTDLY == 0 { clearFlag(ADCC.ADC_FLAG_JEOC | ADCC.ADC_FLAG_JEOS) }
        } else { clearFlag(ADCC.ADC_FLAG_JEOC) }
        return .ok
    }
    public func getInjectedValue(rank: UInt32) -> UInt32 {
        switch rank {
        case ADCC.ADC_INJECTED_RANK_4: return read(.jdr4)
        case ADCC.ADC_INJECTED_RANK_3: return read(.jdr3)
        case ADCC.ADC_INJECTED_RANK_2: return read(.jdr2)
        default: return read(.jdr1)
        }
    }
    @discardableResult
    public func enableInjectedQueue() -> HALStatus {
        let regularOngoing = LL_ADC_REG_IsConversionOngoing(instance)
        let injectedOngoing = LL_ADC_INJ_IsConversionOngoing(instance)
        if regularOngoing == 0 && injectedOngoing == 0 {
            clearBits(.cfgr, ADCC.ADC_CFGR_JQDIS); clearState(ADCC.HAL_ADC_STATE_INJ_JQOVF); return .ok
        }
        return .error
    }
    @discardableResult
    public func disableInjectedQueue() -> HALStatus {
        let regularOngoing = LL_ADC_REG_IsConversionOngoing(instance)
        let injectedOngoing = LL_ADC_INJ_IsConversionOngoing(instance)
        if regularOngoing == 0 && injectedOngoing == 0 { LL_ADC_INJ_SetQueueMode(instance, ADCC.LL_ADC_INJ_QUEUE_DISABLE); return .ok }
        return .error
    }
    @discardableResult
    public func disableVoltageRegulator() -> HALStatus {
        if LL_ADC_IsEnabled(instance) == 0 { LL_ADC_DisableInternalRegulator(instance); return .ok }
        return .error
    }
    @discardableResult
    public func enterDeepPowerDownMode() -> HALStatus {
        if LL_ADC_IsEnabled(instance) == 0 { LL_ADC_EnableDeepPowerDown(instance); return .ok }
        return .error
    }
    @discardableResult
    public func stopRegular(getTick: () -> UInt32) -> HALStatus { stopRegular(interrupts: false, getTick: getTick) }
    @discardableResult
    public func stopRegularInterrupt(getTick: () -> UInt32) -> HALStatus { stopRegular(interrupts: true, getTick: getTick) }
    private func stopRegular(interrupts: Bool, getTick: () -> UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        var status = conversionStop(group: ADCC.ADC_REGULAR_GROUP, getTick: getTick)
        if status == .ok {
            clearState(ADCC.HAL_ADC_STATE_REG_BUSY)
            if interrupts { disableInterrupts(ADCC.ADC_IT_EOC | ADCC.ADC_IT_EOS | ADCC.ADC_IT_OVR) }
            if LL_ADC_INJ_IsConversionOngoing(instance) == 0 {
                status = disable(getTick: getTick)
                if status == .ok { modifyState(clear: ADCC.HAL_ADC_STATE_INJ_BUSY, set: ADCC.HAL_ADC_STATE_READY) }
            } else { addState(ADCC.HAL_ADC_STATE_INJ_BUSY) }
        }
        unlock(); return status
    }
}
