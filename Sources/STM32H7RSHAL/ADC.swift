// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    public func setConfiguration(_ c: ADCConfiguration) {
        handle.write(.clockPrescaler, value: c.clockPrescaler)
        handle.write(.resolution, value: c.resolution)
        handle.write(.dataAlign, value: c.dataAlign)
        handle.write(.scanConvMode, value: c.scanConvMode)
        handle.write(.eocSelection, value: c.eocSelection)
        handle.write(.lowPowerAutoWait, value: c.lowPowerAutoWait)
        handle.write(.continuousConvMode, value: c.continuousConvMode)
        handle.write(.nbrOfConversion, value: c.nbrOfConversion)
        handle.write(.discontinuousConvMode, value: c.discontinuousConvMode)
        handle.write(.nbrOfDiscConversion, value: c.nbrOfDiscConversion)
        handle.write(.externalTrigConv, value: c.externalTrigConv)
        handle.write(.externalTrigConvEdge, value: c.externalTrigConvEdge)
        handle.write(.samplingMode, value: c.samplingMode)
        handle.write(.conversionDataManagement, value: c.conversionDataManagement)
        handle.write(.overrun, value: c.overrun)
        handle.write(.oversamplingMode, value: c.oversamplingMode)
        handle.write(.oversamplingRatio, value: c.oversampling.ratio)
        handle.write(.oversamplingRightBitShift, value: c.oversampling.rightBitShift)
        handle.write(.oversamplingTriggeredMode, value: c.oversampling.triggeredMode)
        handle.write(.oversamplingOversamplingStopReset, value: c.oversampling.oversamplingStopReset)
    }
}
extension ADC {
    @discardableResult
    public func initialize(_ configuration: ADCConfiguration) -> HALStatus {
        setConfiguration(configuration)
        return initialize()
    }
    @discardableResult
    public func initialize() -> HALStatus {
        var status: HALStatus = .ok
        if handle.read(.state) == 0 {
            if useRegisteredCallbacks {
                for raw in UInt32(0)...8 {
                    let id = ADCCallbackID(rawValue: raw)!
                    callbacks.write(id, value: defaults.callback(id))
                }
                prepareMSPCallback(.mspInitialize)
            }
            invoke(.mspInitialize)
            handle.write(.errorCode, value: 0)
            unlock()
        }
        if LL_ADC_IsDeepPowerDownEnabled(instance) != 0 { LL_ADC_DisableDeepPowerDown(instance) }
        if LL_ADC_IsInternalRegulatorEnabled(instance) == 0 {
            LL_ADC_EnableInternalRegulator(instance)
            registers.stabilizationDelay(iterations: (ADCC.LL_ADC_DELAY_INTERNAL_REGUL_STAB_US / 10) &* ((registers.systemCoreClock() / 200_000) &+ 1))
        }
        if LL_ADC_IsInternalRegulatorEnabled(instance) == 0 { markInternalError(); status = .error }
        let regularOngoing = LL_ADC_REG_IsConversionOngoing(instance)
        if handle.read(.state) & ADCC.HAL_ADC_STATE_ERROR_INTERNAL == 0 && regularOngoing == 0 {
            modifyState(clear: ADCC.HAL_ADC_STATE_REG_BUSY, set: ADCC.HAL_ADC_STATE_BUSY_INTERNAL)
            if LL_ADC_IsEnabled(instance) == 0 {
                if commonEnabled() == 0 { LL_ADC_SetCommonClock(handle.read(.clockPrescaler)) }
            }
            var cfgr = (handle.read(.continuousConvMode) << 13) | handle.read(.overrun) |
                handle.read(.dataAlign) | handle.read(.resolution) | (handle.read(.discontinuousConvMode) << 16)
            if handle.read(.discontinuousConvMode) == 1 { cfgr |= (handle.read(.nbrOfDiscConversion) &- 1) << 17 }
            if handle.read(.externalTrigConv) != ADCC.ADC_SOFTWARE_START {
                cfgr |= (handle.read(.externalTrigConv) & ADCC.ADC_CFGR_EXTSEL) | handle.read(.externalTrigConvEdge)
            }
            modify(.cfgr, clear: ADCC.ADC_CFGR_RES | ADCC.ADC_CFGR_ALIGN | ADCC.ADC_CFGR_CONT |
                   ADCC.ADC_CFGR_OVRMOD | ADCC.ADC_CFGR_DISCEN | ADCC.ADC_CFGR_DISCNUM | ADCC.ADC_CFGR_EXTEN | ADCC.ADC_CFGR_EXTSEL, set: cfgr)
            modify(.cfgr2, clear: ADCC.ADC_CFGR2_BULB | ADCC.ADC_CFGR2_SMPTRIG, set: handle.read(.samplingMode))
            let injectedOngoing = LL_ADC_INJ_IsConversionOngoing(instance)
            if regularOngoing == 0 && injectedOngoing == 0 {
                cfgr = (handle.read(.lowPowerAutoWait) << 14) | handle.read(.conversionDataManagement)
                modify(.cfgr, clear: ADCC.ADC_CFGR_FIELDS_2, set: cfgr)
                if handle.read(.oversamplingMode) == 1 {
                    modify(.cfgr2, clear: ADCC.ADC_CFGR2_OVSR | ADCC.ADC_CFGR2_OVSS | ADCC.ADC_CFGR2_TROVS | ADCC.ADC_CFGR2_ROVSM,
                           set: ADCC.ADC_CFGR2_ROVSE | handle.read(.oversamplingRatio) | handle.read(.oversamplingRightBitShift) |
                           handle.read(.oversamplingTriggeredMode) | handle.read(.oversamplingOversamplingStopReset))
                } else { clearBits(.cfgr2, ADCC.ADC_CFGR2_ROVSE) }
            }
            if handle.read(.scanConvMode) == ADCC.ADC_SCAN_ENABLE {
                modify(.sqr1, clear: ADCC.ADC_SQR1_L, set: handle.read(.nbrOfConversion) &- 1)
            } else { clearBits(.sqr1, ADCC.ADC_SQR1_L) }
            modifyState(clear: ADCC.HAL_ADC_STATE_BUSY_INTERNAL, set: ADCC.HAL_ADC_STATE_READY)
        } else { addState(ADCC.HAL_ADC_STATE_ERROR_INTERNAL); status = .error }
        return status
    }
    @discardableResult
    public func deinitialize(getTick: () -> UInt32) -> HALStatus {
        addState(ADCC.HAL_ADC_STATE_BUSY_INTERNAL)
        var status = conversionStop(group: ADCC.ADC_REGULAR_INJECTED_GROUP, getTick: getTick)
        setBits(.cfgr, ADCC.ADC_CFGR_JQM)
        if status == .ok {
            status = disable(getTick: getTick)
            if status == .ok { handle.write(.state, value: ADCC.HAL_ADC_STATE_READY) }
        }
        disableInterrupts(0x7FF)
        clearFlag(0x7FF)
        clearBits(.cr, ADCC.ADC_CR_ADVREGEN | ADCC.ADC_CR_ADCALDIF)
        setBits(.cr, ADCC.ADC_CR_DEEPPWD)
        clearBits(.cfgr, ADCC.ADC_CFGR_FIELDS)
        setBits(.cfgr, ADCC.ADC_CFGR_JQDIS)
        clearBits(.cfgr2, ADCC.ADC_CFGR2_ROVSM | ADCC.ADC_CFGR2_TROVS | ADCC.ADC_CFGR2_OVSS |
                  ADCC.ADC_CFGR2_OVSR | ADCC.ADC_CFGR2_JOVSE | ADCC.ADC_CFGR2_ROVSE)
        clearBits(.smpr1, ADCC.ADC_SMPR1_FIELDS)
        clearBits(.smpr2, ADCC.ADC_SMPR2_SMP18 | ADCC.ADC_SMPR2_SMP17 | ADCC.ADC_SMPR2_SMP16 |
                  ADCC.ADC_SMPR2_SMP15 | ADCC.ADC_SMPR2_SMP14 | ADCC.ADC_SMPR2_SMP13 | ADCC.ADC_SMPR2_SMP12 | ADCC.ADC_SMPR2_SMP11 | ADCC.ADC_SMPR2_SMP10)
        clearBits(.tr1, ADCC.ADC_TR1_HT1 | ADCC.ADC_TR1_LT1)
        clearBits(.tr2, ADCC.ADC_TR2_HT2 | ADCC.ADC_TR2_LT2)
        clearBits(.tr3, ADCC.ADC_TR3_HT3 | ADCC.ADC_TR3_LT3)
        clearBits(.sqr1, ADCC.ADC_SQR1_SQ4 | ADCC.ADC_SQR1_SQ3 | ADCC.ADC_SQR1_SQ2 | ADCC.ADC_SQR1_SQ1 | ADCC.ADC_SQR1_L)
        clearBits(.sqr2, ADCC.ADC_SQR2_SQ9 | ADCC.ADC_SQR2_SQ8 | ADCC.ADC_SQR2_SQ7 | ADCC.ADC_SQR2_SQ6 | ADCC.ADC_SQR2_SQ5)
        clearBits(.sqr3, ADCC.ADC_SQR3_SQ14 | ADCC.ADC_SQR3_SQ13 | ADCC.ADC_SQR3_SQ12 | ADCC.ADC_SQR3_SQ11 | ADCC.ADC_SQR3_SQ10)
        clearBits(.sqr4, ADCC.ADC_SQR4_SQ16 | ADCC.ADC_SQR4_SQ15)
        clearBits(.ofr1, ADCC.ADC_OFR1_OFFSET1_EN | ADCC.ADC_OFR1_OFFSET1_CH | ADCC.ADC_OFR1_OFFSET1)
        clearBits(.ofr2, ADCC.ADC_OFR2_OFFSET2_EN | ADCC.ADC_OFR2_OFFSET2_CH | ADCC.ADC_OFR2_OFFSET2)
        clearBits(.ofr3, ADCC.ADC_OFR3_OFFSET3_EN | ADCC.ADC_OFR3_OFFSET3_CH | ADCC.ADC_OFR3_OFFSET3)
        clearBits(.ofr4, ADCC.ADC_OFR4_OFFSET4_EN | ADCC.ADC_OFR4_OFFSET4_CH | ADCC.ADC_OFR4_OFFSET4)
        clearBits(.awd2cr, ADCC.ADC_AWD2CR_AWD2CH)
        clearBits(.awd3cr, ADCC.ADC_AWD3CR_AWD3CH)
        clearBits(.difsel, ADCC.ADC_DIFSEL_DIFSEL)
        clearBits(.calfact, ADCC.ADC_CALFACT_CALFACT_D | ADCC.ADC_CALFACT_CALFACT_S)
        if commonEnabled() == 0 {
            modifyCommon(.ccr, clear: ADCC.ADC_CCR_CKMODE | ADCC.ADC_CCR_PRESC | ADCC.ADC_CCR_VBATEN | ADCC.ADC_CCR_TSEN |
                         ADCC.ADC_CCR_VREFEN | ADCC.ADC_CCR_MDMA | ADCC.ADC_CCR_DMACFG | ADCC.ADC_CCR_DELAY | ADCC.ADC_CCR_DUAL, set: 0)
            prepareMSPCallback(.mspDeinitialize)
            invoke(.mspDeinitialize)
        }
        handle.write(.errorCode, value: 0)
        handle.write(.injectionContextQueue, value: 0)
        handle.write(.injectionChannelCount, value: 0)
        handle.write(.state, value: 0)
        unlock()
        return status
    }
}
