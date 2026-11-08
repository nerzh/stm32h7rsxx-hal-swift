// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ADC operations from stm32h7rsxx_hal_adc.c/.h and stm32h7rsxx_hal_adc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum ADCFactoryCalibrationWord: UInt32, CaseIterable, Sendable { case vrefInt = 0, temperature1 = 4, temperature2 = 8 }
public protocol ADCCalibrationIO { func read(_ word: ADCFactoryCalibrationWord) -> UInt16 }

extension ADCHelpers {
    public static func externalChannel(_ channel: UInt32) -> UInt32 { channel & ~ADCC.ADC_CHANNEL_ID_INTERNAL_CH_MASK }
    public static func isInternalChannelAvailable(_ channel: UInt32, instance: ADCInstance) -> Bool {
        (instance == .adc1 && (channel == ADCConstants.ADC_CHANNEL_TEMPSENSOR || channel == ADCConstants.ADC_CHANNEL_VREFINT)) ||
        (instance == .adc2 && (channel == ADCConstants.ADC_CHANNEL_VBAT || channel == ADCConstants.ADC_CHANNEL_VDDCORE))
    }
    public static func multimodeData(_ data: UInt32, masterSlave: UInt32) -> UInt32 {
        (data >> (ADCC.ADC_CDR_RDATA_SLV_Pos & ~masterSlave)) & ADCC.ADC_CDR_RDATA_MST
    }
    public static func digitalScale(resolution: UInt32) -> UInt32 { 0xFFF >> (resolution >> (ADCC.ADC_CFGR_RES_BITOFFSET_POS &- 1)) }
    public static func convertDataResolution(_ data: UInt32, current: UInt32, target: UInt32) -> UInt32 {
        (data << (current >> (ADCC.ADC_CFGR_RES_BITOFFSET_POS &- 1))) >> (target >> (ADCC.ADC_CFGR_RES_BITOFFSET_POS &- 1))
    }
    public static func dataToVoltage(_ data: UInt32, vrefAnalog: UInt32, resolution: UInt32) -> UInt32 {
        (data &* vrefAnalog) / digitalScale(resolution: resolution)
    }
    public static func differentialDataToVoltage(_ data: UInt32, vrefAnalog: UInt32, resolution: UInt32) -> Int32 {
        (Int32(bitPattern: data << 1) &* Int32(bitPattern: vrefAnalog)) / Int32(bitPattern: digitalScale(resolution: resolution)) &- Int32(bitPattern: vrefAnalog)
    }
    public static func vrefAnalogVoltage<Calibration: ADCCalibrationIO>(vrefIntData: UInt32, resolution: UInt32, calibration: Calibration) -> UInt32 {
        (UInt32(calibration.read(.vrefInt)) &* 3300) / convertDataResolution(vrefIntData, current: resolution, target: 0)
    }
    public static func temperature<Calibration: ADCCalibrationIO>(data: UInt32, vrefAnalog: UInt32, resolution: UInt32, calibration: Calibration) -> Int32 {
        if Int32(calibration.read(.temperature2)) &- Int32(calibration.read(.temperature1)) != 0 {
            let converted = Int32(bitPattern: (convertDataResolution(data, current: resolution, target: 0) &* vrefAnalog) / 3300)
            let numerator = (converted &- Int32(calibration.read(.temperature1))) &* 100
            return numerator / (Int32(calibration.read(.temperature2)) &- Int32(calibration.read(.temperature1))) &+ 30
        }
        return Int32(bitPattern: ADCC.LL_ADC_TEMPERATURE_CALC_ERROR)
    }
    public static func temperatureFromTypicalParameters(data: UInt32, vrefAnalog: UInt32, resolution: UInt32,
                                                        averageSlope: UInt32, calibrationVoltage: UInt32, calibrationTemperature: Int32) -> Int32 {
        let sensed = Int32(bitPattern: (((data &* vrefAnalog) / digitalScale(resolution: resolution)) &* 1000))
        return (sensed &- Int32(bitPattern: calibrationVoltage &* 1000)) / Int32(bitPattern: averageSlope) &+ calibrationTemperature
    }
}
