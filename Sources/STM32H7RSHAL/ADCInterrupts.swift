// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    public func irqHandler() {
        var overrunError: UInt32 = 0
        let isr = read(.isr)
        let ier = read(.ier)
        let mode = LL_ADC_GetMultimode()
        if isr & ADCC.ADC_FLAG_EOSMP == ADCC.ADC_FLAG_EOSMP && ier & ADCC.ADC_IT_EOSMP == ADCC.ADC_IT_EOSMP {
            if handle.read(.state) & ADCC.HAL_ADC_STATE_ERROR_INTERNAL == 0 { addState(ADCC.HAL_ADC_STATE_REG_EOSMP) }
            invoke(.endSampling)
            clearFlag(ADCC.ADC_FLAG_EOSMP)
        }
        if (isr & ADCC.ADC_FLAG_EOC == ADCC.ADC_FLAG_EOC && ier & ADCC.ADC_IT_EOC == ADCC.ADC_IT_EOC) ||
            (isr & ADCC.ADC_FLAG_EOS == ADCC.ADC_FLAG_EOS && ier & ADCC.ADC_IT_EOS == ADCC.ADC_IT_EOS) {
            if handle.read(.state) & ADCC.HAL_ADC_STATE_ERROR_INTERNAL == 0 { addState(ADCC.HAL_ADC_STATE_REG_EOC) }
            if LL_ADC_REG_IsTriggerSourceSWStart(instance) != 0 {
                let cfgr: UInt32
                if instance == .adc1 || regularIndependent(mode) { cfgr = read(.cfgr) }
                else { cfgr = registers.read(.cfgr, instance: .adc1) }
                if cfgr & ADCC.ADC_CFGR_CONT != ADCC.ADC_CFGR_CONT {
                    if getFlag(ADCC.ADC_FLAG_EOS) {
                        if LL_ADC_REG_IsConversionOngoing(instance) == 0 {
                            disableInterrupts(ADCC.ADC_IT_EOC | ADCC.ADC_IT_EOS)
                            clearState(ADCC.HAL_ADC_STATE_REG_BUSY)
                            if handle.read(.state) & ADCC.HAL_ADC_STATE_INJ_BUSY == 0 { addState(ADCC.HAL_ADC_STATE_READY) }
                        } else { markInternalError() }
                    }
                }
            }
            invoke(.conversionComplete)
            clearFlag(ADCC.ADC_FLAG_EOC | ADCC.ADC_FLAG_EOS)
        }
        if (isr & ADCC.ADC_FLAG_JEOC == ADCC.ADC_FLAG_JEOC && ier & ADCC.ADC_IT_JEOC == ADCC.ADC_IT_JEOC) ||
            (isr & ADCC.ADC_FLAG_JEOS == ADCC.ADC_FLAG_JEOS && ier & ADCC.ADC_IT_JEOS == ADCC.ADC_IT_JEOS) {
            if handle.read(.state) & ADCC.HAL_ADC_STATE_ERROR_INTERNAL == 0 { addState(ADCC.HAL_ADC_STATE_INJ_EOC) }
            let injectedSoftware = LL_ADC_INJ_IsTriggerSourceSWStart(instance)
            let regularSoftware = LL_ADC_REG_IsTriggerSourceSWStart(instance)
            let cfgr: UInt32
            if instance == .adc1 || injectedIndependent(mode) { cfgr = read(.cfgr) }
            else { cfgr = registers.read(.cfgr, instance: .adc1) }
            if injectedSoftware != 0 {
                if cfgr & ADCC.ADC_CFGR_JAUTO == 0 || (regularSoftware != 0 && cfgr & ADCC.ADC_CFGR_CONT == 0) {
                    if getFlag(ADCC.ADC_FLAG_JEOS) {
                        if cfgr & ADCC.ADC_CFGR_JQM == 0 {
                            if LL_ADC_INJ_IsConversionOngoing(instance) == 0 {
                                disableInterrupts(ADCC.ADC_IT_JEOC | ADCC.ADC_IT_JEOS)
                                clearState(ADCC.HAL_ADC_STATE_INJ_BUSY)
                                if handle.read(.state) & ADCC.HAL_ADC_STATE_REG_BUSY == 0 { addState(ADCC.HAL_ADC_STATE_READY) }
                            } else { markInternalError() }
                        }
                    }
                }
            }
            invoke(.injectedComplete)
            clearFlag(ADCC.ADC_FLAG_JEOC | ADCC.ADC_FLAG_JEOS)
        }
        if isr & ADCC.ADC_FLAG_AWD1 == ADCC.ADC_FLAG_AWD1 && ier & ADCC.ADC_IT_AWD1 == ADCC.ADC_IT_AWD1 {
            addState(ADCC.HAL_ADC_STATE_AWD1); invoke(.analogWatchdog1); clearFlag(ADCC.ADC_FLAG_AWD1)
        }
        if isr & ADCC.ADC_FLAG_AWD2 == ADCC.ADC_FLAG_AWD2 && ier & ADCC.ADC_IT_AWD2 == ADCC.ADC_IT_AWD2 {
            addState(ADCC.HAL_ADC_STATE_AWD2); invoke(.analogWatchdog2); clearFlag(ADCC.ADC_FLAG_AWD2)
        }
        if isr & ADCC.ADC_FLAG_AWD3 == ADCC.ADC_FLAG_AWD3 && ier & ADCC.ADC_IT_AWD3 == ADCC.ADC_IT_AWD3 {
            addState(ADCC.HAL_ADC_STATE_AWD3); invoke(.analogWatchdog3); clearFlag(ADCC.ADC_FLAG_AWD3)
        }
        if isr & ADCC.ADC_FLAG_OVR == ADCC.ADC_FLAG_OVR && ier & ADCC.ADC_IT_OVR == ADCC.ADC_IT_OVR {
            if handle.read(.overrun) == ADCC.ADC_OVR_DATA_PRESERVED { overrunError = 1 }
            else {
                if mode != ADCC.LL_ADC_MULTI_INDEPENDENT {
                    if LL_ADC_GetMultiDMATransfer() != ADCC.LL_ADC_MULTI_REG_DMA_EACH_ADC { overrunError = 1 }
                } else {
                    if read(.cfgr) & ADCC.ADC_CFGR_DMAEN != 0 { overrunError = 1 }
                }
            }
            if overrunError == 1 { addState(ADCC.HAL_ADC_STATE_REG_OVR); addError(ADCC.HAL_ADC_ERROR_OVR); invoke(.error) }
            clearFlag(ADCC.ADC_FLAG_OVR)
        }
        if isr & ADCC.ADC_FLAG_JQOVF == ADCC.ADC_FLAG_JQOVF && ier & ADCC.ADC_IT_JQOVF == ADCC.ADC_IT_JQOVF {
            addState(ADCC.HAL_ADC_STATE_INJ_JQOVF); addError(ADCC.HAL_ADC_ERROR_JQOVF)
            clearFlag(ADCC.ADC_FLAG_JQOVF); invoke(.injectedQueueOverflow)
        }
    }
    public func dmaConversionComplete(context: UnsafeMutableRawPointer?) {
        if handle.read(.state) & (ADCC.HAL_ADC_STATE_ERROR_INTERNAL | ADCC.HAL_ADC_STATE_ERROR_DMA) == 0 {
            addState(ADCC.HAL_ADC_STATE_REG_EOC)
            if read(.isr) & ADCC.ADC_FLAG_EOS != 0 {
                if LL_ADC_REG_IsTriggerSourceSWStart(instance) != 0 {
                    if read(.cfgr) & ADCC.ADC_CFGR_CONT == 0 {
                        clearState(ADCC.HAL_ADC_STATE_REG_BUSY)
                        if handle.read(.state) & ADCC.HAL_ADC_STATE_INJ_BUSY == 0 { addState(ADCC.HAL_ADC_STATE_READY) }
                    }
                }
            } else {
                if read(.cfgr) & ADCC.ADC_CFGR_DMACFG == 0 {
                    clearState(ADCC.HAL_ADC_STATE_REG_BUSY)
                    if handle.read(.state) & ADCC.HAL_ADC_STATE_INJ_BUSY == 0 { addState(ADCC.HAL_ADC_STATE_READY) }
                }
            }
            invoke(.conversionComplete)
        } else {
            if handle.read(.state) & ADCC.HAL_ADC_STATE_ERROR_INTERNAL != 0 { invoke(.error) }
            else { dma.invokeErrorCallback(context: context) }
        }
    }
    public func dmaConversionHalfComplete() { invoke(.conversionHalfComplete) }
    public func dmaError() {
        addState(ADCC.HAL_ADC_STATE_ERROR_DMA)
        addError(ADCC.HAL_ADC_ERROR_DMA)
        invoke(.error)
    }
}
