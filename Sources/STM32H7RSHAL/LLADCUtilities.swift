// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from stm32h7rsxx_ll_adc.h/.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// CMSIS encodings: 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public func LL_ADC_WriteReg<IO: ADCRegisterIO>(
    _ registers: IO, _ instance: ADCInstance, _ register: ADCRegister, _ value: UInt32
) {
    registers.write(register, instance: instance, value: value)
}
public func LL_ADC_ReadReg<IO: ADCRegisterIO>(_ registers: IO, _ instance: ADCInstance, _ register: ADCRegister)
    -> UInt32
{
    registers.read(register, instance: instance)
}
public func LL_ADC_WriteReg<IO: ADCRegisterIO>(_ registers: IO, _ register: ADCCommonRegister, _ value: UInt32) {
    registers.writeCommon(register, value: value)
}
public func LL_ADC_ReadReg<IO: ADCRegisterIO>(_ registers: IO, _ register: ADCCommonRegister) -> UInt32 {
    registers.readCommon(register)
}
public func __LL_ADC_CHANNEL_TO_DECIMAL_NB(_ channel: UInt32) -> UInt32 { ADCHelpers.channelNumber(channel) }
public func __LL_ADC_DECIMAL_NB_TO_CHANNEL(_ number: UInt32) -> UInt32 { ADCHelpers.channel(number) }
public func __LL_ADC_IS_CHANNEL_INTERNAL(_ channel: UInt32) -> Bool { ADCHelpers.isInternalChannel(channel) }
public func __LL_ADC_CHANNEL_INTERNAL_TO_EXTERNAL(_ channel: UInt32) -> UInt32 { ADCHelpers.externalChannel(channel) }
public func __LL_ADC_IS_CHANNEL_INTERNAL_AVAILABLE(_ instance: ADCInstance, _ channel: UInt32) -> Bool {
    ADCHelpers.isInternalChannelAvailable(channel, instance: instance)
}
public func __LL_ADC_ANALOGWD_CHANNEL_GROUP(_ channel: UInt32, _ group: UInt32) -> UInt32 {
    if group == LL_ADC_GROUP_REGULAR {
        return (channel & ADCC.ADC_CHANNEL_ID_MASK) | ADCC.ADC_CFGR_AWD1EN | ADCC.ADC_CFGR_AWD1SGL
    }
    if group == LL_ADC_GROUP_INJECTED {
        return (channel & ADCC.ADC_CHANNEL_ID_MASK) | ADCC.ADC_CFGR_JAWD1EN | ADCC.ADC_CFGR_AWD1SGL
    }
    return (channel & ADCC.ADC_CHANNEL_ID_MASK) | ADCC.ADC_CFGR_JAWD1EN | ADCC.ADC_CFGR_AWD1EN | ADCC.ADC_CFGR_AWD1SGL
}
public func __LL_ADC_ANALOGWD_SET_THRESHOLD_RESOLUTION(_ resolution: UInt32, _ threshold: UInt32) -> UInt32 {
    threshold << (resolution >> (ADCC.ADC_CFGR_RES_BITOFFSET_POS &- 1))
}
public func __LL_ADC_ANALOGWD_GET_THRESHOLD_RESOLUTION(_ resolution: UInt32, _ threshold: UInt32) -> UInt32 {
    threshold >> (resolution >> (ADCC.ADC_CFGR_RES_BITOFFSET_POS &- 1))
}
public func __LL_ADC_ANALOGWD_THRESHOLDS_HIGH_LOW(_ type: UInt32, _ thresholds: UInt32) -> UInt32 {
    (thresholds >> ((type & 0x10000) >> 0xc))
        & LL_ADC_AWD_THRESHOLD_LOW
}
public func __LL_ADC_CALIB_FACTOR_SINGLE_DIFF(_ single: UInt32, _ differential: UInt32) -> UInt32 {
    (differential << 16) | single
}
public func __LL_ADC_MULTI_CONV_DATA_MASTER_SLAVE(_ masterSlave: UInt32, _ data: UInt32) -> UInt32 {
    ADCHelpers.multimodeData(data, masterSlave: masterSlave)
}
public func __LL_ADC_MULTI_INSTANCE_MASTER(_ instance: ADCInstance) -> ADCInstance {
    instance == .adc2 ? .adc1 : instance
}
// The H7RS family has one common block. The C macro ignores its argument.
public func __LL_ADC_COMMON_INSTANCE(_ instance: ADCInstance) -> UInt32 { 0x4002_2300 }
public func __LL_ADC_IS_ENABLED_ALL_COMMON_INSTANCE<IO: ADCRegisterIO>(_ registers: IO) -> UInt32 {
    // Bitwise OR deliberately reads both instances.
    LL_ADC_IsEnabled(registers, .adc1) | LL_ADC_IsEnabled(registers, .adc2)
}
public func __LL_ADC_DIGITAL_SCALE(_ resolution: UInt32) -> UInt32 { ADCHelpers.digitalScale(resolution: resolution) }
public func __LL_ADC_CONVERT_DATA_RESOLUTION(_ data: UInt32, _ current: UInt32, _ target: UInt32) -> UInt32 {
    ADCHelpers.convertDataResolution(data, current: current, target: target)
}
public func __LL_ADC_CALC_DATA_TO_VOLTAGE(_ voltage: UInt32, _ data: UInt32, _ resolution: UInt32) -> UInt32 {
    ADCHelpers.dataToVoltage(data, vrefAnalog: voltage, resolution: resolution)
}
public func __LL_ADC_CALC_DIFF_DATA_TO_VOLTAGE(_ voltage: UInt32, _ data: UInt32, _ resolution: UInt32) -> Int32 {
    ADCHelpers.differentialDataToVoltage(data, vrefAnalog: voltage, resolution: resolution)
}
public func __LL_ADC_CALC_VREFANALOG_VOLTAGE<Calibration: ADCCalibrationIO>(
    _ data: UInt32, _ resolution: UInt32, _ calibration: Calibration
) -> UInt32 {
    ADCHelpers.vrefAnalogVoltage(vrefIntData: data, resolution: resolution, calibration: calibration)
}
public func __LL_ADC_CALC_TEMPERATURE<Calibration: ADCCalibrationIO>(
    _ voltage: UInt32, _ data: UInt32, _ resolution: UInt32, _ calibration: Calibration
) -> Int32 {
    ADCHelpers.temperature(data: data, vrefAnalog: voltage, resolution: resolution, calibration: calibration)
}
public func __LL_ADC_CALC_TEMPERATURE_TYP_PARAMS(
    _ averageSlope: UInt32, _ calibrationVoltage: UInt32, _ calibrationTemperature: Int32, _ voltage: UInt32,
    _ data: UInt32, _ resolution: UInt32
) -> Int32 {
    ADCHelpers.temperatureFromTypicalParameters(
        data: data, vrefAnalog: voltage, resolution: resolution, averageSlope: averageSlope,
        calibrationVoltage: calibrationVoltage, calibrationTemperature: calibrationTemperature)
}
