// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    @discardableResult
    public func conversionStop(group: UInt32, getTick: () -> UInt32) -> HALStatus {
        var timeoutCycles: UInt32 = 0
        var group = group
        let regularOngoing = LL_ADC_REG_IsConversionOngoing(instance)
        let injectedOngoing = LL_ADC_INJ_IsConversionOngoing(instance)
        if regularOngoing != 0 || injectedOngoing != 0 {
            if read(.cfgr) & ADCC.ADC_CFGR_JAUTO != 0 && handle.read(.continuousConvMode) == 1 && handle.read(.lowPowerAutoWait) == 1 {
                group = ADCC.ADC_REGULAR_GROUP
                while !getFlag(ADCC.ADC_FLAG_JEOS) {
                    if timeoutCycles >= (653 * 4096 * 256 * 4) { markInternalError(); return .error }
                    timeoutCycles &+= 1
                }
                clearFlag(ADCC.ADC_FLAG_JEOS)
            }
            if group != ADCC.ADC_INJECTED_GROUP {
                if LL_ADC_REG_IsConversionOngoing(instance) != 0 {
                    if LL_ADC_IsDisableOngoing(instance) == 0 { LL_ADC_REG_StopConversion(instance) }
                }
            }
            if group != ADCC.ADC_REGULAR_GROUP {
                if LL_ADC_INJ_IsConversionOngoing(instance) != 0 {
                    if LL_ADC_IsDisableOngoing(instance) == 0 { LL_ADC_INJ_StopConversion(instance) }
                }
            }
            let mask: UInt32
            switch group {
            case ADCC.ADC_REGULAR_INJECTED_GROUP: mask = ADCC.ADC_CR_ADSTART | ADCC.ADC_CR_JADSTART
            case ADCC.ADC_INJECTED_GROUP: mask = ADCC.ADC_CR_JADSTART
            default: mask = ADCC.ADC_CR_ADSTART
            }
            let start = getTick()
            while read(.cr) & mask != 0 {
                if getTick() &- start > ADCC.ADC_STOP_CONVERSION_TIMEOUT {
                    if read(.cr) & mask != 0 { markInternalError(); return .error }
                }
            }
        }
        return .ok
    }
    @discardableResult
    public func enable(getTick: () -> UInt32) -> HALStatus {
        enable(instance: instance, getTick: getTick, recordError: true)
    }
    // Multimode uses a temporary slave handle in C; its error fields are discarded.
    func enable(instance adc: ADCInstance, getTick: () -> UInt32, recordError: Bool) -> HALStatus {
        if LL_ADC_IsEnabled(adc) == 0 {
            if registers.read(.cr, instance: adc) & (ADCC.ADC_CR_ADCAL | ADCC.ADC_CR_JADSTP | ADCC.ADC_CR_ADSTP |
                    ADCC.ADC_CR_JADSTART | ADCC.ADC_CR_ADSTART | ADCC.ADC_CR_ADDIS | ADCC.ADC_CR_ADEN) != 0 {
                if recordError { markInternalError() }; return .error
            }
            LL_ADC_Enable(adc)
            if LL_ADC_GetCommonPathInternalCh() & ADCC.LL_ADC_PATH_INTERNAL_TEMPSENSOR != 0 {
                registers.stabilizationDelay(iterations: (ADCC.LL_ADC_DELAY_TEMPSENSOR_STAB_US / 10) &* ((registers.systemCoreClock() / 200_000) &+ 1))
            }
            let start = getTick()
            while registers.read(.isr, instance: adc) & ADCC.ADC_FLAG_RDY != ADCC.ADC_FLAG_RDY {
                if LL_ADC_IsEnabled(adc) == 0 { LL_ADC_Enable(adc) }
                if getTick() &- start > 2 {
                    if registers.read(.isr, instance: adc) & ADCC.ADC_FLAG_RDY != ADCC.ADC_FLAG_RDY {
                        if recordError { markInternalError() }; return .error
                    }
                }
            }
        }
        return .ok
    }
    @discardableResult
    public func disable(getTick: () -> UInt32) -> HALStatus {
        disable(instance: instance, getTick: getTick, recordError: true)
    }
    func disable(instance adc: ADCInstance, getTick: () -> UInt32, recordError: Bool) -> HALStatus {
        let disabling = LL_ADC_IsDisableOngoing(adc)
        if LL_ADC_IsEnabled(adc) != 0 && disabling == 0 {
            if registers.read(.cr, instance: adc) & (ADCC.ADC_CR_JADSTART | ADCC.ADC_CR_ADSTART | ADCC.ADC_CR_ADEN) == ADCC.ADC_CR_ADEN {
                LL_ADC_Disable(adc)
                registers.write(.isr, instance: adc, value: ADCC.ADC_FLAG_EOSMP | ADCC.ADC_FLAG_RDY)
            } else { if recordError { markInternalError() }; return .error }
            let start = getTick()
            while registers.read(.cr, instance: adc) & ADCC.ADC_CR_ADEN != 0 {
                if getTick() &- start > 2 {
                    if registers.read(.cr, instance: adc) & ADCC.ADC_CR_ADEN != 0 { if recordError { markInternalError() }; return .error }
                }
            }
        }
        return .ok
    }
    @discardableResult
    public func startCalibration(singleDiff: UInt32, getTick: () -> UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        let status = disable(getTick: getTick)
        if status == .ok {
            modifyState(clear: ADCC.HAL_ADC_STATE_REG_BUSY | ADCC.HAL_ADC_STATE_INJ_BUSY, set: ADCC.HAL_ADC_STATE_BUSY_INTERNAL)
            LL_ADC_StartCalibration(instance, singleDiff)
            var waitIndex: UInt32 = 0
            while LL_ADC_IsCalibrationOnGoing(instance) != 0 {
                waitIndex &+= 1
                if waitIndex >= 633_600_000 {
                    modifyState(clear: ADCC.HAL_ADC_STATE_BUSY_INTERNAL, set: ADCC.HAL_ADC_STATE_ERROR_INTERNAL)
                    unlock(); return .error
                }
            }
            modifyState(clear: ADCC.HAL_ADC_STATE_BUSY_INTERNAL, set: ADCC.HAL_ADC_STATE_READY)
        } else { addState(ADCC.HAL_ADC_STATE_ERROR_INTERNAL) }
        unlock(); return status
    }
    public func getCalibrationValue(singleDiff: UInt32) -> UInt32 { LL_ADC_GetCalibrationFactor(instance, singleDiff) }
    @discardableResult
    public func setCalibrationValue(singleDiff: UInt32, factor: UInt32) -> HALStatus {
        if !tryLock() { return .busy }
        var status: HALStatus = .ok
        let regularOngoing = LL_ADC_REG_IsConversionOngoing(instance)
        let injectedOngoing = LL_ADC_INJ_IsConversionOngoing(instance)
        if LL_ADC_IsEnabled(instance) != 0 && regularOngoing == 0 && injectedOngoing == 0 {
            LL_ADC_SetCalibrationFactor(instance, singleDiff, factor)
        } else { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); addError(ADCC.HAL_ADC_ERROR_INTERNAL); status = .error }
        unlock(); return status
    }
}
