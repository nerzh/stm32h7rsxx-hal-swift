// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    func LL_ADC_SetCommonClock(_ CommonClock: UInt32) {
        modifyCommon(.ccr, clear: ADCC.ADC_CCR_CKMODE | ADCC.ADC_CCR_PRESC, set: CommonClock)
    }
    func LL_ADC_SetCommonPathInternalCh(_ PathInternal: UInt32) {
        modifyCommon(.ccr, clear: ADCC.ADC_CCR_VREFEN | ADCC.ADC_CCR_TSEN | ADCC.ADC_CCR_VBATEN, set: PathInternal)
    }
    func LL_ADC_GetCommonPathInternalCh() -> UInt32 {
        return ((registers.readCommon(.ccr) & (ADCC.ADC_CCR_VREFEN | ADCC.ADC_CCR_TSEN | ADCC.ADC_CCR_VBATEN)))
    }
    func LL_ADC_SetPathInternalChAdd(_ adc: ADCInstance, _ PathInternal: UInt32) {
        setBits(.or, PathInternal, instance: adc)
    }
    func LL_ADC_SetCalibrationFactor(_ adc: ADCInstance, _ SingleDiff: UInt32, _ CalibrationFactor: UInt32) {
        modify(.calfact, clear: SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_FACTOR_MASK, set: CalibrationFactor << (((SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_F_BIT_D_MASK) >> ADCC.ADC_SINGLEDIFF_CALIB_F_BIT_D_SHIFT4) & ~(SingleDiff & ADCC.ADC_CALFACT_CALFACT_S)), instance: adc)
    }
    func LL_ADC_GetCalibrationFactor(_ adc: ADCInstance, _ SingleDiff: UInt32) -> UInt32 {
        return ((registers.read(.calfact, instance: adc) & (SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_FACTOR_MASK)) >> ((SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_F_BIT_D_MASK) >> ADCC.ADC_SINGLEDIFF_CALIB_F_BIT_D_SHIFT4))
    }
    func LL_ADC_SetOffset(_ adc: ADCInstance, _ Offsety: UInt32, _ Channel: UInt32, _ OffsetLevel: UInt32) {
        let reg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
        modify(reg, clear: ADCC.ADC_OFR1_OFFSET1_EN | ADCC.ADC_OFR1_OFFSET1_CH | ADCC.ADC_OFR1_OFFSET1, set: ADCC.ADC_OFR1_OFFSET1_EN | (Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) | OffsetLevel, instance: adc)
    }
    func LL_ADC_GetOffsetChannel(_ adc: ADCInstance, _ Offsety: UInt32) -> UInt32 {
        let reg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
        return (registers.read(reg, instance: adc) & ADCC.ADC_OFR1_OFFSET1_CH)
    }
    func LL_ADC_SetOffsetState(_ adc: ADCInstance, _ Offsety: UInt32, _ OffsetState: UInt32) {
        let reg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
        modify(reg, clear: ADCC.ADC_OFR1_OFFSET1_EN, set: OffsetState, instance: adc)
    }
    func LL_ADC_SetOffsetSign(_ adc: ADCInstance, _ Offsety: UInt32, _ OffsetSign: UInt32) {
        let reg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
        modify(reg, clear: ADCC.ADC_OFR1_OFFSETPOS, set: OffsetSign, instance: adc)
    }
    func LL_ADC_SetOffsetSaturation(_ adc: ADCInstance, _ Offsety: UInt32, _ OffsetSaturation: UInt32) {
        let reg = ADCRegister(rawValue: ADCRegister.ofr1.rawValue &+ ((Offsety) << 2))!
        modify(reg, clear: ADCC.ADC_OFR1_SATEN, set: OffsetSaturation, instance: adc)
    }
    func LL_ADC_SetSamplingTimeCommonConfig(_ adc: ADCInstance, _ SamplingTimeCommonConfig: UInt32) {
        modify(.smpr1, clear: ADCC.ADC_SMPR1_SMPPLUS, set: SamplingTimeCommonConfig, instance: adc)
    }
    func LL_ADC_REG_IsTriggerSourceSWStart(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.cfgr, instance: adc) & ADCC.ADC_CFGR_EXTEN) == (ADCC.LL_ADC_REG_TRIG_SOFTWARE & ADCC.ADC_CFGR_EXTEN)) ? 1 : 0)
    }
    func LL_ADC_REG_SetSequencerRanks(_ adc: ADCInstance, _ Rank: UInt32, _ Channel: UInt32) {
        let reg = ADCRegister(rawValue: ADCRegister.sqr1.rawValue &+ ((((Rank & ADCC.ADC_REG_SQRX_REGOFFSET_MASK) >> ADCC.ADC_SQRX_REGOFFSET_POS)) << 2))!
        modify(reg, clear: ADCC.ADC_CHANNEL_ID_NUMBER_MASK_POSBIT0 << (Rank & ADCC.ADC_REG_RANK_ID_SQRX_MASK), set: ((Channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS) << (Rank & ADCC.ADC_REG_RANK_ID_SQRX_MASK), instance: adc)
    }
    func LL_ADC_INJ_IsTriggerSourceSWStart(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.jsqr, instance: adc) & ADCC.ADC_JSQR_JEXTEN) == (ADCC.LL_ADC_INJ_TRIG_SOFTWARE & ADCC.ADC_JSQR_JEXTEN)) ? 1 : 0)
    }
    func LL_ADC_INJ_GetTrigAuto(_ adc: ADCInstance) -> UInt32 {
        return ((registers.read(.cfgr, instance: adc) & ADCC.ADC_CFGR_JAUTO))
    }
    func LL_ADC_INJ_SetQueueMode(_ adc: ADCInstance, _ QueueMode: UInt32) {
        modify(.cfgr, clear: ADCC.ADC_CFGR_JQM | ADCC.ADC_CFGR_JQDIS, set: QueueMode, instance: adc)
    }
    func LL_ADC_SetChannelSamplingTime(_ adc: ADCInstance, _ Channel: UInt32, _ SamplingTime: UInt32) {
        let reg = ADCRegister(rawValue: ADCRegister.smpr1.rawValue &+ ((((Channel & ADCC.ADC_CHANNEL_SMPRX_REGOFFSET_MASK) >> ADCC.ADC_SMPRX_REGOFFSET_POS)) << 2))!
        modify(reg, clear: ADCC.ADC_SMPR1_SMP0 << ((Channel & ADCC.ADC_CHANNEL_SMPx_BITOFFSET_MASK) >> ADCC.ADC_CHANNEL_SMPx_BITOFFSET_POS), set: SamplingTime << ((Channel & ADCC.ADC_CHANNEL_SMPx_BITOFFSET_MASK) >> ADCC.ADC_CHANNEL_SMPx_BITOFFSET_POS), instance: adc)
    }
    func LL_ADC_SetChannelSingleDiff(_ adc: ADCInstance, _ Channel: UInt32, _ SingleDiff: UInt32) {
        modify(.difsel, clear: Channel & ADCC.ADC_SINGLEDIFF_CHANNEL_MASK, set: (Channel & ADCC.ADC_SINGLEDIFF_CHANNEL_MASK) & (ADCC.ADC_DIFSEL_DIFSEL >> (SingleDiff & ADCC.ADC_SINGLEDIFF_CHANNEL_SHIFT_MASK)), instance: adc)
    }
    func LL_ADC_SetAnalogWDMonitChannels(_ adc: ADCInstance, _ AWDy: UInt32, _ AWDChannelGroup: UInt32) {
        let reg = ADCRegister(rawValue: ADCRegister.cfgr.rawValue &+ ((((AWDy & ADCC.ADC_AWD_CRX_REGOFFSET_MASK) >> ADCC.ADC_AWD_CRX_REGOFFSET_POS) + ((AWDy & ADCC.ADC_AWD_CR12_REGOFFSETGAP_MASK) * ADCC.ADC_AWD_CR12_REGOFFSETGAP_VAL)) << 2))!
        modify(reg, clear: (AWDy & ADCC.ADC_AWD_CR_ALL_CHANNEL_MASK), set: AWDChannelGroup & AWDy, instance: adc)
    }
    func LL_ADC_ConfigAnalogWDThresholds(_ adc: ADCInstance, _ AWDy: UInt32, _ AWDThresholdHighValue: UInt32, _ AWDThresholdLowValue: UInt32) {
        let reg = ADCRegister(rawValue: ADCRegister.tr1.rawValue &+ ((((AWDy & ADCC.ADC_AWD_TRX_REGOFFSET_MASK) >> ADCC.ADC_AWD_TRX_REGOFFSET_POS)) << 2))!
        modify(reg, clear: ADCC.ADC_TR1_HT1 | ADCC.ADC_TR1_LT1, set: (AWDThresholdHighValue << ADCC.ADC_TR1_HT1_BITOFFSET_POS) | AWDThresholdLowValue, instance: adc)
    }
    func LL_ADC_GetMultimode() -> UInt32 {
        return ((registers.readCommon(.ccr) & ADCC.ADC_CCR_DUAL))
    }
    func LL_ADC_GetMultiDMATransfer() -> UInt32 {
        return ((registers.readCommon(.ccr) & (ADCC.ADC_CCR_MDMA | ADCC.ADC_CCR_DMACFG)))
    }
    func LL_ADC_EnableDeepPowerDown(_ adc: ADCInstance) {
        modify(.cr, clear: ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_DEEPPWD, instance: adc)
    }
    func LL_ADC_DisableDeepPowerDown(_ adc: ADCInstance) {
        clearBits(.cr, (ADCC.ADC_CR_DEEPPWD | ADCC.ADC_CR_BITS_PROPERTY_RS), instance: adc)
    }
    func LL_ADC_IsDeepPowerDownEnabled(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.cr, instance: adc) & ADCC.ADC_CR_DEEPPWD) == (ADCC.ADC_CR_DEEPPWD)) ? 1 : 0)
    }
    func LL_ADC_EnableInternalRegulator(_ adc: ADCInstance) {
        modify(.cr, clear: ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_ADVREGEN, instance: adc)
    }
    func LL_ADC_DisableInternalRegulator(_ adc: ADCInstance) {
        clearBits(.cr, (ADCC.ADC_CR_ADVREGEN | ADCC.ADC_CR_BITS_PROPERTY_RS), instance: adc)
    }
    func LL_ADC_IsInternalRegulatorEnabled(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.cr, instance: adc) & ADCC.ADC_CR_ADVREGEN) == (ADCC.ADC_CR_ADVREGEN)) ? 1 : 0)
    }
    func LL_ADC_Enable(_ adc: ADCInstance) {
        modify(.cr, clear: ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_ADEN, instance: adc)
    }
    func LL_ADC_Disable(_ adc: ADCInstance) {
        modify(.cr, clear: ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_ADDIS, instance: adc)
    }
    func LL_ADC_IsEnabled(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.cr, instance: adc) & ADCC.ADC_CR_ADEN) == (ADCC.ADC_CR_ADEN)) ? 1 : 0)
    }
    func LL_ADC_IsDisableOngoing(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.cr, instance: adc) & ADCC.ADC_CR_ADDIS) == (ADCC.ADC_CR_ADDIS)) ? 1 : 0)
    }
    func LL_ADC_StartCalibration(_ adc: ADCInstance, _ SingleDiff: UInt32) {
        modify(.cr, clear: ADCC.ADC_CR_ADCALDIF | ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_ADCAL | (SingleDiff & ADCC.ADC_SINGLEDIFF_CALIB_START_MASK), instance: adc)
    }
    func LL_ADC_IsCalibrationOnGoing(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.cr, instance: adc) & ADCC.ADC_CR_ADCAL) == (ADCC.ADC_CR_ADCAL)) ? 1 : 0)
    }
    func LL_ADC_REG_StartConversion(_ adc: ADCInstance) {
        modify(.cr, clear: ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_ADSTART, instance: adc)
    }
    func LL_ADC_REG_StopConversion(_ adc: ADCInstance) {
        modify(.cr, clear: ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_ADSTP, instance: adc)
    }
    func LL_ADC_REG_IsConversionOngoing(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.cr, instance: adc) & ADCC.ADC_CR_ADSTART) == (ADCC.ADC_CR_ADSTART)) ? 1 : 0)
    }
    func LL_ADC_INJ_StartConversion(_ adc: ADCInstance) {
        modify(.cr, clear: ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_JADSTART, instance: adc)
    }
    func LL_ADC_INJ_StopConversion(_ adc: ADCInstance) {
        modify(.cr, clear: ADCC.ADC_CR_BITS_PROPERTY_RS, set: ADCC.ADC_CR_JADSTP, instance: adc)
    }
    func LL_ADC_INJ_IsConversionOngoing(_ adc: ADCInstance) -> UInt32 {
        return (((registers.read(.cr, instance: adc) & ADCC.ADC_CR_JADSTART) == (ADCC.ADC_CR_JADSTART)) ? 1 : 0)
    }
    func LL_ADC_ClearFlag_AWD1(_ adc: ADCInstance) {
        registers.write(.isr, instance: adc, value: ADCC.LL_ADC_FLAG_AWD1)
    }
    func LL_ADC_ClearFlag_AWD2(_ adc: ADCInstance) {
        registers.write(.isr, instance: adc, value: ADCC.LL_ADC_FLAG_AWD2)
    }
    func LL_ADC_ClearFlag_AWD3(_ adc: ADCInstance) {
        registers.write(.isr, instance: adc, value: ADCC.LL_ADC_FLAG_AWD3)
    }
    func LL_ADC_EnableIT_AWD1(_ adc: ADCInstance) {
        setBits(.ier, ADCC.LL_ADC_IT_AWD1, instance: adc)
    }
    func LL_ADC_EnableIT_AWD2(_ adc: ADCInstance) {
        setBits(.ier, ADCC.LL_ADC_IT_AWD2, instance: adc)
    }
    func LL_ADC_EnableIT_AWD3(_ adc: ADCInstance) {
        setBits(.ier, ADCC.LL_ADC_IT_AWD3, instance: adc)
    }
    func LL_ADC_DisableIT_AWD1(_ adc: ADCInstance) {
        clearBits(.ier, ADCC.LL_ADC_IT_AWD1, instance: adc)
    }
    func LL_ADC_DisableIT_AWD2(_ adc: ADCInstance) {
        clearBits(.ier, ADCC.LL_ADC_IT_AWD2, instance: adc)
    }
    func LL_ADC_DisableIT_AWD3(_ adc: ADCInstance) {
        clearBits(.ier, ADCC.LL_ADC_IT_AWD3, instance: adc)
    }
}
extension ADC {
    func read(_ register: ADCRegister) -> UInt32 { registers.read(register, instance: instance) }
    func write(_ register: ADCRegister, _ value: UInt32) { registers.write(register, instance: instance, value: value) }
    func modify(_ register: ADCRegister, clear: UInt32, set: UInt32, instance adc: ADCInstance? = nil) {
        let adc = adc ?? instance
        registers.write(register, instance: adc, value: (registers.read(register, instance: adc) & ~clear) | set)
    }
    func setBits(_ register: ADCRegister, _ bits: UInt32, instance adc: ADCInstance? = nil) {
        let adc = adc ?? instance
        registers.write(register, instance: adc, value: registers.read(register, instance: adc) | bits)
    }
    func clearBits(_ register: ADCRegister, _ bits: UInt32, instance adc: ADCInstance? = nil) {
        let adc = adc ?? instance
        registers.write(register, instance: adc, value: registers.read(register, instance: adc) & ~bits)
    }
    func modifyCommon(_ register: ADCCommonRegister, clear: UInt32, set: UInt32) {
        registers.writeCommon(register, value: (registers.readCommon(register) & ~clear) | set)
    }
    func modifyState(clear: UInt32, set: UInt32) { handle.write(.state, value: (handle.read(.state) & ~clear) | set) }
    func addState(_ value: UInt32) { handle.write(.state, value: handle.read(.state) | value) }
    func clearState(_ value: UInt32) { handle.write(.state, value: handle.read(.state) & ~value) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func clearError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) & ~value) }
    func markInternalError() { addState(16); addError(1) }
    func tryLock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func unlock() { handle.write(.lock, value: 0) }
    // The original common-instance macro uses bitwise OR: always perform both reads.
    func commonEnabled() -> UInt32 { LL_ADC_IsEnabled(.adc1) | LL_ADC_IsEnabled(.adc2) }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func enableInterrupts(_ mask: UInt32) { setBits(.ier, mask) }
    public func disableInterrupts(_ mask: UInt32) { clearBits(.ier, mask) }
    public func getInterruptSource(_ mask: UInt32) -> Bool { read(.ier) & mask == mask }
    public func getFlag(_ mask: UInt32) -> Bool { read(.isr) & mask == mask }
    public func clearFlag(_ mask: UInt32) { write(.isr, mask) }
}
