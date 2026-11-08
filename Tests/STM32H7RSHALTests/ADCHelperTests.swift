import XCTest
import CADCReference
import STM32H7RSHAL

private struct ADCFactoryModel: ADCCalibrationIO {
    var vref: UInt16 = 1500, t1: UInt16 = 900, t2: UInt16 = 1300
    func read(_ word: ADCFactoryCalibrationWord) -> UInt16 {
        switch word { case .vrefInt: return vref; case .temperature1: return t1; case .temperature2: return t2 }
    }
}
final class ADCHelperTests: XCTestCase {
    func testChannelEncodingsAndMultimodeExtraction() {
        for number: UInt32 in 0...18 {
            let expected = CADC_Macro(1,number,0,0,0,0,0)
            XCTAssertEqual(ADCHelpers.channel(number), expected)
            for channel in [expected, expected | 0x80000000, expected | 0x80080000, number << 26] {
                XCTAssertEqual(ADCHelpers.channelNumber(channel), CADC_Macro(0,channel,0,0,0,0,0))
                XCTAssertEqual(ADCHelpers.isInternalChannel(channel) ? 1 : 0, CADC_Macro(2,channel,0,0,0,0,0))
                XCTAssertEqual(ADCHelpers.externalChannel(channel), CADC_Macro(3,channel,0,0,0,0,0))
            }
        }
        let pair = ADCPair()
        CADC_Activate(pair.c.state)
        for channel: UInt32 in [ADCConstants.ADC_CHANNEL_TEMPSENSOR,ADCConstants.ADC_CHANNEL_VREFINT,ADCConstants.ADC_CHANNEL_VBAT,ADCConstants.ADC_CHANNEL_VDDCORE,ADCConstants.ADC_CHANNEL_3] {
            for instance in ADCInstance.allCases {
                XCTAssertEqual(ADCHelpers.isInternalChannelAvailable(channel, instance: instance) ? 1 : 0, CADC_Macro(4,channel,instance.rawValue,0,0,0,0))
            }
        }
        for selection: UInt32 in [0xFFFF,0xFFFF0000,UInt32.max] {
            for data: UInt32 in [0,1,0x12345678,UInt32.max] {
                XCTAssertEqual(ADCHelpers.multimodeData(data, masterSlave: selection), CADC_Macro(5,selection,data,0,0,0,0))
            }
        }
    }
    func testResolutionVoltageAndFactoryTemperatureMacros() {
        for current: UInt32 in [0,8,16,24] {
            XCTAssertEqual(ADCHelpers.digitalScale(resolution: current), CADC_Macro(6,current,0,0,0,0,0))
            for target: UInt32 in [0,8,16,24] {
                for data: UInt32 in [0,1,17,63] {
                    XCTAssertEqual(ADCHelpers.convertDataResolution(data,current:current,target:target), CADC_Macro(7,data,current,target,0,0,0))
                }
            }
            for data in stride(from: UInt32(1), through: ADCHelpers.digitalScale(resolution: current), by: 31) {
                for vref: UInt32 in [1800,3000,3300] {
                    XCTAssertEqual(ADCHelpers.dataToVoltage(data,vrefAnalog:vref,resolution:current), CADC_Macro(8,vref,data,current,0,0,0))
                    XCTAssertEqual(UInt32(bitPattern:ADCHelpers.differentialDataToVoltage(data,vrefAnalog:vref,resolution:current)), CADC_Macro(9,vref,data,current,0,0,0))
                    for factory in [ADCFactoryModel(),ADCFactoryModel(t1:1200,t2:800),ADCFactoryModel(t1:900,t2:900)] {
                        CADC_SetFactory(0,factory.vref); CADC_SetFactory(1,factory.t1); CADC_SetFactory(2,factory.t2)
                        XCTAssertEqual(ADCHelpers.vrefAnalogVoltage(vrefIntData:data,resolution:current,calibration:factory), CADC_Macro(10,data,current,0,0,0,0))
                        XCTAssertEqual(UInt32(bitPattern:ADCHelpers.temperature(data:data,vrefAnalog:vref,resolution:current,calibration:factory)), CADC_Macro(11,vref,data,current,0,0,0))
                    }
                    XCTAssertEqual(UInt32(bitPattern:ADCHelpers.temperatureFromTypicalParameters(data:data,vrefAnalog:vref,resolution:current,averageSlope:2500,calibrationVoltage:760,calibrationTemperature:25)), CADC_Macro(12,2500,760,25,vref,data,current))
                }
            }
        }
    }
}
