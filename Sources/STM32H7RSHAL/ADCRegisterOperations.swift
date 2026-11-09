// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ADC {
    func LL_ADC_SetCommonClock(_ CommonClock: UInt32) {
        STM32H7RSHAL.LL_ADC_SetCommonClock(registers, CommonClock)
    }
    func LL_ADC_SetCommonPathInternalCh(_ PathInternal: UInt32) {
        STM32H7RSHAL.LL_ADC_SetCommonPathInternalCh(registers, PathInternal)
    }
    func LL_ADC_GetCommonPathInternalCh() -> UInt32 {
        return STM32H7RSHAL.LL_ADC_GetCommonPathInternalCh(registers)
    }
    func LL_ADC_SetPathInternalChAdd(_ adc: ADCInstance, _ PathInternal: UInt32) {
        STM32H7RSHAL.LL_ADC_SetPathInternalChAdd(registers, adc, PathInternal)
    }
    func LL_ADC_SetCalibrationFactor(_ adc: ADCInstance, _ SingleDiff: UInt32, _ CalibrationFactor: UInt32) {
        STM32H7RSHAL.LL_ADC_SetCalibrationFactor(registers, adc, SingleDiff, CalibrationFactor)
    }
    func LL_ADC_GetCalibrationFactor(_ adc: ADCInstance, _ SingleDiff: UInt32) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_GetCalibrationFactor(registers, adc, SingleDiff)
    }
    func LL_ADC_SetOffset(_ adc: ADCInstance, _ Offsety: UInt32, _ Channel: UInt32, _ OffsetLevel: UInt32) {
        STM32H7RSHAL.LL_ADC_SetOffset(registers, adc, Offsety, Channel, OffsetLevel)
    }
    func LL_ADC_GetOffsetChannel(_ adc: ADCInstance, _ Offsety: UInt32) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_GetOffsetChannel(registers, adc, Offsety)
    }
    func LL_ADC_SetOffsetState(_ adc: ADCInstance, _ Offsety: UInt32, _ OffsetState: UInt32) {
        STM32H7RSHAL.LL_ADC_SetOffsetState(registers, adc, Offsety, OffsetState)
    }
    func LL_ADC_SetOffsetSign(_ adc: ADCInstance, _ Offsety: UInt32, _ OffsetSign: UInt32) {
        STM32H7RSHAL.LL_ADC_SetOffsetSign(registers, adc, Offsety, OffsetSign)
    }
    func LL_ADC_SetOffsetSaturation(_ adc: ADCInstance, _ Offsety: UInt32, _ OffsetSaturation: UInt32) {
        STM32H7RSHAL.LL_ADC_SetOffsetSaturation(registers, adc, Offsety, OffsetSaturation)
    }
    func LL_ADC_SetSamplingTimeCommonConfig(_ adc: ADCInstance, _ SamplingTimeCommonConfig: UInt32) {
        STM32H7RSHAL.LL_ADC_SetSamplingTimeCommonConfig(registers, adc, SamplingTimeCommonConfig)
    }
    func LL_ADC_REG_IsTriggerSourceSWStart(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_REG_IsTriggerSourceSWStart(registers, adc)
    }
    func LL_ADC_REG_SetSequencerRanks(_ adc: ADCInstance, _ Rank: UInt32, _ Channel: UInt32) {
        STM32H7RSHAL.LL_ADC_REG_SetSequencerRanks(registers, adc, Rank, Channel)
    }
    func LL_ADC_INJ_IsTriggerSourceSWStart(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_INJ_IsTriggerSourceSWStart(registers, adc)
    }
    func LL_ADC_INJ_GetTrigAuto(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_INJ_GetTrigAuto(registers, adc)
    }
    func LL_ADC_INJ_SetQueueMode(_ adc: ADCInstance, _ QueueMode: UInt32) {
        STM32H7RSHAL.LL_ADC_INJ_SetQueueMode(registers, adc, QueueMode)
    }
    func LL_ADC_SetChannelSamplingTime(_ adc: ADCInstance, _ Channel: UInt32, _ SamplingTime: UInt32) {
        STM32H7RSHAL.LL_ADC_SetChannelSamplingTime(registers, adc, Channel, SamplingTime)
    }
    func LL_ADC_SetChannelSingleDiff(_ adc: ADCInstance, _ Channel: UInt32, _ SingleDiff: UInt32) {
        STM32H7RSHAL.LL_ADC_SetChannelSingleDiff(registers, adc, Channel, SingleDiff)
    }
    func LL_ADC_SetAnalogWDMonitChannels(_ adc: ADCInstance, _ AWDy: UInt32, _ AWDChannelGroup: UInt32) {
        STM32H7RSHAL.LL_ADC_SetAnalogWDMonitChannels(registers, adc, AWDy, AWDChannelGroup)
    }
    func LL_ADC_ConfigAnalogWDThresholds(
        _ adc: ADCInstance, _ AWDy: UInt32, _ AWDThresholdHighValue: UInt32, _ AWDThresholdLowValue: UInt32
    ) {
        STM32H7RSHAL.LL_ADC_ConfigAnalogWDThresholds(registers, adc, AWDy, AWDThresholdHighValue, AWDThresholdLowValue)
    }
    func LL_ADC_GetMultimode() -> UInt32 {
        return STM32H7RSHAL.LL_ADC_GetMultimode(registers)
    }
    func LL_ADC_GetMultiDMATransfer() -> UInt32 {
        return STM32H7RSHAL.LL_ADC_GetMultiDMATransfer(registers)
    }
    func LL_ADC_EnableDeepPowerDown(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_EnableDeepPowerDown(registers, adc)
    }
    func LL_ADC_DisableDeepPowerDown(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_DisableDeepPowerDown(registers, adc)
    }
    func LL_ADC_IsDeepPowerDownEnabled(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_IsDeepPowerDownEnabled(registers, adc)
    }
    func LL_ADC_EnableInternalRegulator(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_EnableInternalRegulator(registers, adc)
    }
    func LL_ADC_DisableInternalRegulator(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_DisableInternalRegulator(registers, adc)
    }
    func LL_ADC_IsInternalRegulatorEnabled(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_IsInternalRegulatorEnabled(registers, adc)
    }
    func LL_ADC_Enable(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_Enable(registers, adc)
    }
    func LL_ADC_Disable(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_Disable(registers, adc)
    }
    func LL_ADC_IsEnabled(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_IsEnabled(registers, adc)
    }
    func LL_ADC_IsDisableOngoing(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_IsDisableOngoing(registers, adc)
    }
    func LL_ADC_StartCalibration(_ adc: ADCInstance, _ SingleDiff: UInt32) {
        STM32H7RSHAL.LL_ADC_StartCalibration(registers, adc, SingleDiff)
    }
    func LL_ADC_IsCalibrationOnGoing(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_IsCalibrationOnGoing(registers, adc)
    }
    func LL_ADC_REG_StartConversion(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_REG_StartConversion(registers, adc)
    }
    func LL_ADC_REG_StopConversion(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_REG_StopConversion(registers, adc)
    }
    func LL_ADC_REG_IsConversionOngoing(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_REG_IsConversionOngoing(registers, adc)
    }
    func LL_ADC_INJ_StartConversion(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_INJ_StartConversion(registers, adc)
    }
    func LL_ADC_INJ_StopConversion(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_INJ_StopConversion(registers, adc)
    }
    func LL_ADC_INJ_IsConversionOngoing(_ adc: ADCInstance) -> UInt32 {
        return STM32H7RSHAL.LL_ADC_INJ_IsConversionOngoing(registers, adc)
    }
    func LL_ADC_ClearFlag_AWD1(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_ClearFlag_AWD1(registers, adc)
    }
    func LL_ADC_ClearFlag_AWD2(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_ClearFlag_AWD2(registers, adc)
    }
    func LL_ADC_ClearFlag_AWD3(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_ClearFlag_AWD3(registers, adc)
    }
    func LL_ADC_EnableIT_AWD1(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_EnableIT_AWD1(registers, adc)
    }
    func LL_ADC_EnableIT_AWD2(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_EnableIT_AWD2(registers, adc)
    }
    func LL_ADC_EnableIT_AWD3(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_EnableIT_AWD3(registers, adc)
    }
    func LL_ADC_DisableIT_AWD1(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_DisableIT_AWD1(registers, adc)
    }
    func LL_ADC_DisableIT_AWD2(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_DisableIT_AWD2(registers, adc)
    }
    func LL_ADC_DisableIT_AWD3(_ adc: ADCInstance) {
        STM32H7RSHAL.LL_ADC_DisableIT_AWD3(registers, adc)
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
    func markInternalError() {
        addState(16)
        addError(1)
    }
    func tryLock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1)
        return true
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
