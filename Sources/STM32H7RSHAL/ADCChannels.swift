// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum ADCHelpers {
    public static func channelNumber(_ channel: UInt32) -> UInt32 {
        if channel & ADCC.ADC_CHANNEL_ID_BITFIELD_MASK == 0 {
            return (channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS
        }
        return UInt32(channel.trailingZeroBitCount)
    }
    public static func channel(_ number: UInt32) -> UInt32 {
        if number <= 9 {
            return (number << ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS) | (ADCC.ADC_AWD2CR_AWD2CH_0 << number) |
                ADCC.ADC_SMPR1_REGOFFSET | ((3 &* number) << ADCC.ADC_CHANNEL_SMPx_BITOFFSET_POS)
        }
        return (number << ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS) | (ADCC.ADC_AWD2CR_AWD2CH_0 << number) |
            ADCC.ADC_SMPR2_REGOFFSET | ((3 &* (number &- 10)) << ADCC.ADC_CHANNEL_SMPx_BITOFFSET_POS)
    }
    public static func isInternalChannel(_ channel: UInt32) -> Bool { channel & ADCC.ADC_CHANNEL_ID_INTERNAL_CH_MASK != 0 }
}
extension ADC {
    @discardableResult
    public func configureChannel(_ c: ADCChannelConfiguration) -> HALStatus {
        if !tryLock() { return .busy }
        var status: HALStatus = .ok
        if LL_ADC_REG_IsConversionOngoing(instance) == 0 {
            LL_ADC_REG_SetSequencerRanks(instance, c.rank, c.channel)
            let regularOngoing = LL_ADC_REG_IsConversionOngoing(instance)
            let injectedOngoing = LL_ADC_INJ_IsConversionOngoing(instance)
            if regularOngoing == 0 && injectedOngoing == 0 {
                configureSampling(channel: c.channel, time: c.samplingTime)
                configureOffset(channel: c.channel, number: c.offsetNumber, value: c.offset, sign: c.offsetSign, saturation: c.offsetSaturation)
            }
            configureSingleDiff(channel: c.channel, singleDiff: c.singleDiff, samplingTime: c.samplingTime)
            configureInternalPath(channel: c.channel, injected: false)
        } else { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); status = .error }
        unlock(); return status
    }
    func configureSampling(channel: UInt32, time: UInt32) {
        if time == ADCC.ADC_SAMPLETIME_3CYCLES_5 {
            LL_ADC_SetChannelSamplingTime(instance, channel, ADCC.LL_ADC_SAMPLINGTIME_2CYCLES_5)
            LL_ADC_SetSamplingTimeCommonConfig(instance, ADCC.LL_ADC_SAMPLINGTIME_COMMON_3C5_REPL_2C5)
        } else {
            LL_ADC_SetChannelSamplingTime(instance, channel, time)
            LL_ADC_SetSamplingTimeCommonConfig(instance, ADCC.LL_ADC_SAMPLINGTIME_COMMON_DEFAULT)
        }
    }
    func configureOffset(channel: UInt32, number: UInt32, value: UInt32, sign: UInt32, saturation: UInt32) {
        let shifted = value << (((read(.cfgr) & ADCC.ADC_CFGR_RES) >> 3) &* 2)
        if number != ADCC.ADC_OFFSET_NONE {
            LL_ADC_SetOffset(instance, number, channel, shifted)
            LL_ADC_SetOffsetSign(instance, number, sign)
            LL_ADC_SetOffsetSaturation(instance, number, saturation == 1 ? ADCC.LL_ADC_OFFSET_SATURATION_ENABLE : ADCC.LL_ADC_OFFSET_SATURATION_DISABLE)
        } else {
            for offset in UInt32(0)...3 {
                if ADCHelpers.channelNumber(LL_ADC_GetOffsetChannel(instance, offset)) == ADCHelpers.channelNumber(channel) {
                    LL_ADC_SetOffsetState(instance, offset, ADCC.LL_ADC_OFFSET_DISABLE)
                }
            }
        }
    }
    func configureSingleDiff(channel: UInt32, singleDiff: UInt32, samplingTime: UInt32) {
        if LL_ADC_IsEnabled(instance) == 0 {
            LL_ADC_SetChannelSingleDiff(instance, channel, singleDiff)
            if singleDiff == ADCC.ADC_DIFFERENTIAL_ENDED {
                LL_ADC_SetChannelSamplingTime(instance, ADCHelpers.channel((ADCHelpers.channelNumber(channel) &+ 1) & 0x1F), samplingTime)
            }
        }
    }
    func configureInternalPath(channel: UInt32, injected: Bool) {
        if ADCHelpers.isInternalChannel(channel) {
            let path = LL_ADC_GetCommonPathInternalCh()
            if channel == ADCC.ADC_CHANNEL_TEMPSENSOR && path & ADCC.LL_ADC_PATH_INTERNAL_TEMPSENSOR == 0 {
                if instance == .adc1 {
                    LL_ADC_SetCommonPathInternalCh(ADCC.LL_ADC_PATH_INTERNAL_TEMPSENSOR | path)
                    // InjectedConfigChannel has one additional +1 in the original delay formula.
                    let cycles = (registers.systemCoreClock() / 200_000) &+ 1
                    registers.stabilizationDelay(iterations: (ADCC.LL_ADC_DELAY_TEMPSENSOR_STAB_US / 10) &* (injected ? cycles &+ 1 : cycles))
                }
            } else if channel == ADCC.ADC_CHANNEL_VBAT && path & ADCC.LL_ADC_PATH_INTERNAL_VBAT == 0 {
                if instance == .adc2 { LL_ADC_SetCommonPathInternalCh(ADCC.LL_ADC_PATH_INTERNAL_VBAT | path) }
            } else if channel == ADCC.ADC_CHANNEL_VREFINT && path & ADCC.LL_ADC_PATH_INTERNAL_VREFINT == 0 {
                if instance == .adc1 { LL_ADC_SetCommonPathInternalCh(ADCC.LL_ADC_PATH_INTERNAL_VREFINT | path) }
            } else if channel == ADCC.ADC_CHANNEL_VDDCORE {
                if instance == .adc2 { LL_ADC_SetPathInternalChAdd(instance, ADCC.LL_ADC_PATH_INTERNAL_VDDCORE) }
            }
        }
    }
    func injectedRank(_ channel: UInt32, _ rank: UInt32) -> UInt32 {
        ((channel & ADCC.ADC_CHANNEL_ID_NUMBER_MASK) >> ADCC.ADC_CHANNEL_ID_NUMBER_BITOFFSET_POS) << (rank & ADCC.ADC_INJ_RANK_ID_JSQR_MASK)
    }
    @discardableResult
    public func configureInjectedChannel(_ c: ADCInjectedConfiguration) -> HALStatus {
        if !tryLock() { return .busy }
        var status: HALStatus = .ok
        var context: UInt32 = 0
        let fields = ADCC.ADC_JSQR_JL | ADCC.ADC_JSQR_JEXTSEL | ADCC.ADC_JSQR_JEXTEN | ADCC.ADC_JSQR_JSQ1 |
            ADCC.ADC_JSQR_JSQ2 | ADCC.ADC_JSQR_JSQ3 | ADCC.ADC_JSQR_JSQ4
        if handle.read(.scanConvMode) == ADCC.ADC_SCAN_DISABLE || c.injectedNbrOfConversion == 1 {
            if c.injectedRank == ADCC.ADC_INJECTED_RANK_1 {
                if c.externalTrigInjecConv != ADCC.ADC_INJECTED_SOFTWARE_START {
                    context = injectedRank(c.injectedChannel, ADCC.ADC_INJECTED_RANK_1) |
                        (c.externalTrigInjecConv & ADCC.ADC_JSQR_JEXTSEL) | c.externalTrigInjecConvEdge
                } else { context = injectedRank(c.injectedChannel, ADCC.ADC_INJECTED_RANK_1) }
                modify(.jsqr, clear: fields, set: context)
                handle.write(.injectionContextQueue, value: context)
            }
        } else {
            if handle.read(.injectionChannelCount) == 0 {
                handle.write(.injectionChannelCount, value: c.injectedNbrOfConversion)
                handle.write(.injectionContextQueue, value: 0)
                if c.externalTrigInjecConv != ADCC.ADC_INJECTED_SOFTWARE_START {
                    context = (c.injectedNbrOfConversion &- 1) | (c.externalTrigInjecConv & ADCC.ADC_JSQR_JEXTSEL) | c.externalTrigInjecConvEdge
                } else { context = c.injectedNbrOfConversion &- 1 }
            }
            context &= ~injectedRank(ADCC.ADC_SQR3_SQ10, c.injectedRank)
            context |= injectedRank(c.injectedChannel, c.injectedRank)
            handle.write(.injectionChannelCount, value: handle.read(.injectionChannelCount) &- 1)
            handle.write(.injectionContextQueue, value: handle.read(.injectionContextQueue) | context)
            if handle.read(.injectionChannelCount) == 0 { modify(.jsqr, clear: fields, set: handle.read(.injectionContextQueue)) }
        }
        if LL_ADC_INJ_IsConversionOngoing(instance) == 0 {
            if c.autoInjectedConv == 0 {
                modify(.cfgr, clear: ADCC.ADC_CFGR_JQM | ADCC.ADC_CFGR_JDISCEN,
                       set: (c.queueInjectedContext << ADCC.ADC_CFGR_JQM_Pos) | (c.injectedDiscontinuousConvMode << ADCC.ADC_CFGR_JDISCEN_Pos))
            } else {
                modify(.cfgr, clear: ADCC.ADC_CFGR_JQM | ADCC.ADC_CFGR_JDISCEN, set: c.queueInjectedContext << ADCC.ADC_CFGR_JQM_Pos)
            }
        }
        let regularOngoing = LL_ADC_REG_IsConversionOngoing(instance)
        let injectedOngoing = LL_ADC_INJ_IsConversionOngoing(instance)
        if regularOngoing == 0 && injectedOngoing == 0 {
            if c.externalTrigInjecConv == ADCC.ADC_INJECTED_SOFTWARE_START || c.externalTrigInjecConvEdge == ADCC.ADC_EXTERNALTRIGINJECCONV_EDGE_NONE {
                if c.autoInjectedConv == 1 { setBits(.cfgr, ADCC.ADC_CFGR_JAUTO) }
                else { clearBits(.cfgr, ADCC.ADC_CFGR_JAUTO) }
            } else {
                if c.autoInjectedConv == 1 { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); status = .error }
                else { clearBits(.cfgr, ADCC.ADC_CFGR_JAUTO) }
            }
            if c.injecOversamplingMode == 1 {
                modify(.cfgr2, clear: ADCC.ADC_CFGR2_JOVSE | ADCC.ADC_CFGR2_OVSR | ADCC.ADC_CFGR2_OVSS,
                       set: ADCC.ADC_CFGR2_JOVSE | c.injecOversampling.ratio | c.injecOversampling.rightBitShift)
            } else { clearBits(.cfgr2, ADCC.ADC_CFGR2_JOVSE) }
            configureSampling(channel: c.injectedChannel, time: c.injectedSamplingTime)
            configureOffset(channel: c.injectedChannel, number: c.injectedOffsetNumber, value: c.injectedOffset,
                            sign: c.injectedOffsetSign, saturation: c.injectedOffsetSaturation)
        }
        configureSingleDiff(channel: c.injectedChannel, singleDiff: c.injectedSingleDiff, samplingTime: c.injectedSamplingTime)
        configureInternalPath(channel: c.injectedChannel, injected: true)
        unlock(); return status
    }
    @discardableResult
    public func configureMultimode(_ c: ADCMultimodeConfiguration) -> HALStatus {
        if !tryLock() { return .busy }
        if instance != .adc1 { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); unlock(); return .error }
        var status: HALStatus = .ok
        let slaveOngoing = LL_ADC_REG_IsConversionOngoing(.adc2)
        if LL_ADC_REG_IsConversionOngoing(instance) == 0 && slaveOngoing == 0 {
            if c.mode != ADCC.ADC_MODE_INDEPENDENT {
                modifyCommon(.ccr, clear: ADCC.ADC_CCR_MDMA | ADCC.ADC_CCR_DMACFG,
                             set: c.dmaAccessMode | (((handle.read(.conversionDataManagement) & ADCC.ADC_CFGR_DMACFG) >> ADCC.ADC_CFGR_DMACFG_Pos) << ADCC.ADC_CCR_DMACFG_Pos))
                if commonEnabled() == 0 { modifyCommon(.ccr, clear: ADCC.ADC_CCR_DUAL | ADCC.ADC_CCR_DELAY, set: c.mode | c.twoSamplingDelay) }
            } else {
                modifyCommon(.ccr, clear: ADCC.ADC_CCR_MDMA | ADCC.ADC_CCR_DMACFG, set: 0)
                if commonEnabled() == 0 { modifyCommon(.ccr, clear: ADCC.ADC_CCR_DUAL | ADCC.ADC_CCR_DELAY, set: 0) }
            }
        } else { addState(ADCC.HAL_ADC_STATE_ERROR_CONFIG); status = .error }
        unlock(); return status
    }
}
