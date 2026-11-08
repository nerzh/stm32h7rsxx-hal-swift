// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    @discardableResult
    public func configureAnalogWatchdog(_ c: ADCAnalogWatchdogConfiguration) -> HALStatus {
        if !tryLock() { return .busy }
        let regularOngoing = LL_ADC_REG_IsConversionOngoing(instance)
        let injectedOngoing = LL_ADC_INJ_IsConversionOngoing(instance)
        if regularOngoing == 0 && injectedOngoing == 0 {
            if c.watchdogNumber == ADCC.ADC_ANALOGWATCHDOG_1 {
                let group: UInt32
                switch c.watchdogMode {
                case ADCC.ADC_ANALOGWATCHDOG_SINGLE_REG:
                    group = (c.channel & ADCC.ADC_CHANNEL_ID_MASK) | ADCC.ADC_CFGR_AWD1EN | ADCC.ADC_CFGR_AWD1SGL
                case ADCC.ADC_ANALOGWATCHDOG_SINGLE_INJEC:
                    group = (c.channel & ADCC.ADC_CHANNEL_ID_MASK) | ADCC.ADC_CFGR_JAWD1EN | ADCC.ADC_CFGR_AWD1SGL
                case ADCC.ADC_ANALOGWATCHDOG_SINGLE_REGINJEC:
                    group = (c.channel & ADCC.ADC_CHANNEL_ID_MASK) | ADCC.ADC_CFGR_JAWD1EN | ADCC.ADC_CFGR_AWD1EN | ADCC.ADC_CFGR_AWD1SGL
                case ADCC.ADC_ANALOGWATCHDOG_ALL_REG: group = ADCC.LL_ADC_AWD_ALL_CHANNELS_REG
                case ADCC.ADC_ANALOGWATCHDOG_ALL_INJEC: group = ADCC.LL_ADC_AWD_ALL_CHANNELS_INJ
                case ADCC.ADC_ANALOGWATCHDOG_ALL_REGINJEC: group = ADCC.LL_ADC_AWD_ALL_CHANNELS_REG_INJ
                default: group = ADCC.LL_ADC_AWD_DISABLE
                }
                LL_ADC_SetAnalogWDMonitChannels(instance, ADCC.LL_ADC_AWD1, group)
                modify(.tr1, clear: ADCC.ADC_TR1_AWDFILT, set: c.filteringConfig)
                clearState(ADCC.HAL_ADC_STATE_AWD1)
                LL_ADC_ClearFlag_AWD1(instance)
                if c.interruptMode == 1 { LL_ADC_EnableIT_AWD1(instance) } else { LL_ADC_DisableIT_AWD1(instance) }
            } else {
                switch c.watchdogMode {
                case ADCC.ADC_ANALOGWATCHDOG_SINGLE_REG, ADCC.ADC_ANALOGWATCHDOG_SINGLE_INJEC, ADCC.ADC_ANALOGWATCHDOG_SINGLE_REGINJEC:
                    setBits(c.watchdogNumber == ADCC.ADC_ANALOGWATCHDOG_2 ? .awd2cr : .awd3cr, 1 << (ADCHelpers.channelNumber(c.channel) & 0x1F))
                case ADCC.ADC_ANALOGWATCHDOG_ALL_REG, ADCC.ADC_ANALOGWATCHDOG_ALL_INJEC, ADCC.ADC_ANALOGWATCHDOG_ALL_REGINJEC:
                    LL_ADC_SetAnalogWDMonitChannels(instance, c.watchdogNumber, ADCC.LL_ADC_AWD_ALL_CHANNELS_REG_INJ)
                default: LL_ADC_SetAnalogWDMonitChannels(instance, c.watchdogNumber, ADCC.LL_ADC_AWD_DISABLE)
                }
                if c.watchdogNumber == ADCC.ADC_ANALOGWATCHDOG_2 {
                    clearState(ADCC.HAL_ADC_STATE_AWD2); LL_ADC_ClearFlag_AWD2(instance)
                    if c.interruptMode == 1 { LL_ADC_EnableIT_AWD2(instance) } else { LL_ADC_DisableIT_AWD2(instance) }
                } else {
                    clearState(ADCC.HAL_ADC_STATE_AWD3); LL_ADC_ClearFlag_AWD3(instance)
                    if c.interruptMode == 1 { LL_ADC_EnableIT_AWD3(instance) } else { LL_ADC_DisableIT_AWD3(instance) }
                }
            }
        }
        let high: UInt32, low: UInt32
        if c.watchdogNumber == ADCC.ADC_ANALOGWATCHDOG_1 {
            high = c.highThreshold << (((read(.cfgr) & ADCC.ADC_CFGR_RES) >> 3) &* 2)
            low = c.lowThreshold << (((read(.cfgr) & ADCC.ADC_CFGR_RES) >> 3) &* 2)
        } else {
            high = watchdog23Threshold(c.highThreshold)
            low = watchdog23Threshold(c.lowThreshold)
        }
        LL_ADC_ConfigAnalogWDThresholds(instance, c.watchdogNumber, high, low)
        unlock(); return .ok
    }
    func watchdog23Threshold(_ value: UInt32) -> UInt32 {
        if read(.cfgr) & ADCC.ADC_CFGR_RES != (ADCC.ADC_CFGR_RES_1 | ADCC.ADC_CFGR_RES_0) {
            return value >> ((4 &- (((read(.cfgr) & ADCC.ADC_CFGR_RES) >> 3) &* 2)) & 0x1F)
        }
        return value << 2
    }
}
