import CLLReference
import STM32H7RSHAL
import XCTest

private struct LLADCAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}
private final class LLADCImage: ADCRegisterIO, ADCCalibrationIO, LLBusRegisterIO {
    var cells: [UInt32]
    var trace: [LLADCAccess] = []
    var reads: UInt32 = 0
    var crReads: UInt32 = 0
    let salt: UInt32
    let instanceID: UInt32
    let stopAt: UInt32
    let disableAt: UInt32
    init(seed: UInt32, salt: UInt32, instance: UInt32, stopAt: UInt32 = 0, disableAt: UInt32 = 0) {
        cells = (0..<1024).map { seed ^ (UInt32($0) &* 0x9E37_79B9) }
        self.salt = salt
        self.instanceID = instance
        self.stopAt = stopAt
        self.disableAt = disableAt
    }
    func load(_ index: Int) -> UInt32 {
        if index == 2 || index == 66 {
            crReads &+= 1
            if stopAt != 0 && crReads >= stopAt { cells[index] &= ~0x3C }
            if disableAt != 0 && crReads >= disableAt && cells[index] & 2 != 0 { cells[index] &= ~3 }
        }
        let value = cells[index] ^ (salt &* reads)
        reads &+= 1
        trace.append(.init(index: UInt32(index), value: value, kind: 0))
        return value
    }
    func store(_ index: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(index), value: value, kind: 1))
        cells[index] = value
    }
    func read(_ register: ADCRegister, instance: ADCInstance) -> UInt32 {
        load(Int(instance.rawValue * 64 + register.rawValue / 4))
    }
    func write(_ register: ADCRegister, instance: ADCInstance, value: UInt32) {
        store(Int(instance.rawValue * 64 + register.rawValue / 4), value)
    }
    func readCommon(_ register: ADCCommonRegister) -> UInt32 { load(192 + Int(register.rawValue / 4)) }
    func writeCommon(_ register: ADCCommonRegister, value: UInt32) { store(192 + Int(register.rawValue / 4), value) }
    func dataAddress(instance: ADCInstance) -> UInt32 { 0x4002_2040 + instance.rawValue * 0x100 }
    func commonDataAddress() -> UInt32 { 0x4002_230C }
    func systemCoreClock() -> UInt32 { preconditionFailure("Not used by LL") }
    func stabilizationDelay(iterations: UInt32) { preconditionFailure("Not used by LL") }
    func read(_ register: LLBusRegister) -> UInt32 { load(256 + Int(register.rawValue / 4)) }
    func write(_ register: LLBusRegister, value: UInt32) { store(256 + Int(register.rawValue / 4), value) }
    func read(_ word: ADCFactoryCalibrationWord) -> UInt16 {
        let index = 600 + Int(word.rawValue / 4)
        let value = UInt16(truncatingIfNeeded: cells[index])
        trace.append(.init(index: UInt32(index), value: UInt32(value), kind: 2))
        return value
    }
}
private func runLLADC(_ op: Int, _ io: LLADCImage, _ args: [UInt32]) -> UInt32 {
    var bus = io
    let instance = ADCInstance(rawValue: io.instanceID)!
    switch op {
    case 0:
        let result = LL_ADC_DMA_GetRegAddr(io, instance, args[0])
        return result
    case 1:
        LL_ADC_SetCommonClock(io, args[0])
        return 0
    case 2:
        let result = LL_ADC_GetCommonClock(io)
        return result
    case 3:
        LL_ADC_SetCommonPathInternalCh(io, args[0])
        return 0
    case 4:
        LL_ADC_SetCommonPathInternalChAdd(io, args[0])
        return 0
    case 5:
        LL_ADC_SetCommonPathInternalChRem(io, args[0])
        return 0
    case 6:
        let result = LL_ADC_GetCommonPathInternalCh(io)
        return result
    case 7:
        LL_ADC_SetPathInternalCh(io, instance, args[0])
        return 0
    case 8:
        LL_ADC_SetPathInternalChAdd(io, instance, args[0])
        return 0
    case 9:
        LL_ADC_SetPathInternalChRem(io, instance, args[0])
        return 0
    case 10:
        let result = LL_ADC_GetPathInternalCh(io, instance)
        return result
    case 11:
        LL_ADC_SetCalibrationFactor(io, instance, args[0], args[1])
        return 0
    case 12:
        let result = LL_ADC_GetCalibrationFactor(io, instance, args[0])
        return result
    case 13:
        LL_ADC_SetResolution(io, instance, args[0])
        return 0
    case 14:
        let result = LL_ADC_GetResolution(io, instance)
        return result
    case 15:
        LL_ADC_SetDataAlignment(io, instance, args[0])
        return 0
    case 16:
        let result = LL_ADC_GetDataAlignment(io, instance)
        return result
    case 17:
        LL_ADC_SetLowPowerMode(io, instance, args[0])
        return 0
    case 18:
        let result = LL_ADC_GetLowPowerMode(io, instance)
        return result
    case 19:
        LL_ADC_SetOffset(io, instance, args[0], args[1], args[2])
        return 0
    case 20:
        let result = LL_ADC_GetOffsetChannel(io, instance, args[0])
        return result
    case 21:
        let result = LL_ADC_GetOffsetLevel(io, instance, args[0])
        return result
    case 22:
        LL_ADC_SetOffsetState(io, instance, args[0], args[1])
        return 0
    case 23:
        let result = LL_ADC_GetOffsetState(io, instance, args[0])
        return result
    case 24:
        LL_ADC_SetOffsetSign(io, instance, args[0], args[1])
        return 0
    case 25:
        let result = LL_ADC_GetOffsetSign(io, instance, args[0])
        return result
    case 26:
        LL_ADC_SetOffsetSaturation(io, instance, args[0], args[1])
        return 0
    case 27:
        let result = LL_ADC_GetOffsetSaturation(io, instance, args[0])
        return result
    case 28:
        LL_ADC_SetSamplingTimeCommonConfig(io, instance, args[0])
        return 0
    case 29:
        let result = LL_ADC_GetSamplingTimeCommonConfig(io, instance)
        return result
    case 30:
        LL_ADC_REG_SetTriggerSource(io, instance, args[0])
        return 0
    case 31:
        let result = LL_ADC_REG_GetTriggerSource(io, instance)
        return result
    case 32:
        let result = LL_ADC_REG_IsTriggerSourceSWStart(io, instance)
        return result
    case 33:
        LL_ADC_REG_SetTriggerEdge(io, instance, args[0])
        return 0
    case 34:
        let result = LL_ADC_REG_GetTriggerEdge(io, instance)
        return result
    case 35:
        LL_ADC_REG_SetSamplingMode(io, instance, args[0])
        return 0
    case 36:
        let result = LL_ADC_REG_GetSamplingMode(io, instance)
        return result
    case 37:
        LL_ADC_REG_SetSequencerLength(io, instance, args[0])
        return 0
    case 38:
        let result = LL_ADC_REG_GetSequencerLength(io, instance)
        return result
    case 39:
        LL_ADC_REG_SetSequencerDiscont(io, instance, args[0])
        return 0
    case 40:
        let result = LL_ADC_REG_GetSequencerDiscont(io, instance)
        return result
    case 41:
        LL_ADC_REG_SetSequencerRanks(io, instance, args[0], args[1])
        return 0
    case 42:
        let result = LL_ADC_REG_GetSequencerRanks(io, instance, args[0])
        return result
    case 43:
        LL_ADC_REG_SetContinuousMode(io, instance, args[0])
        return 0
    case 44:
        let result = LL_ADC_REG_GetContinuousMode(io, instance)
        return result
    case 45:
        LL_ADC_REG_SetDMATransfer(io, instance, args[0])
        return 0
    case 46:
        let result = LL_ADC_REG_GetDMATransfer(io, instance)
        return result
    case 47:
        LL_ADC_REG_SetMDFTransfer(io, instance, args[0])
        return 0
    case 48:
        let result = LL_ADC_REG_GetMDFTransfer(io, instance)
        return result
    case 49:
        LL_ADC_REG_SetOverrun(io, instance, args[0])
        return 0
    case 50:
        let result = LL_ADC_REG_GetOverrun(io, instance)
        return result
    case 51:
        LL_ADC_INJ_SetTriggerSource(io, instance, args[0])
        return 0
    case 52:
        let result = LL_ADC_INJ_GetTriggerSource(io, instance)
        return result
    case 53:
        let result = LL_ADC_INJ_IsTriggerSourceSWStart(io, instance)
        return result
    case 54:
        LL_ADC_INJ_SetTriggerEdge(io, instance, args[0])
        return 0
    case 55:
        let result = LL_ADC_INJ_GetTriggerEdge(io, instance)
        return result
    case 56:
        LL_ADC_INJ_SetSequencerLength(io, instance, args[0])
        return 0
    case 57:
        let result = LL_ADC_INJ_GetSequencerLength(io, instance)
        return result
    case 58:
        LL_ADC_INJ_SetSequencerDiscont(io, instance, args[0])
        return 0
    case 59:
        let result = LL_ADC_INJ_GetSequencerDiscont(io, instance)
        return result
    case 60:
        LL_ADC_INJ_SetSequencerRanks(io, instance, args[0], args[1])
        return 0
    case 61:
        let result = LL_ADC_INJ_GetSequencerRanks(io, instance, args[0])
        return result
    case 62:
        LL_ADC_INJ_SetTrigAuto(io, instance, args[0])
        return 0
    case 63:
        let result = LL_ADC_INJ_GetTrigAuto(io, instance)
        return result
    case 64:
        LL_ADC_INJ_SetQueueMode(io, instance, args[0])
        return 0
    case 65:
        let result = LL_ADC_INJ_GetQueueMode(io, instance)
        return result
    case 66:
        LL_ADC_INJ_ConfigQueueContext(io, instance, args[0], args[1], args[2], args[3], args[4], args[5], args[6])
        return 0
    case 67:
        LL_ADC_SetChannelSamplingTime(io, instance, args[0], args[1])
        return 0
    case 68:
        let result = LL_ADC_GetChannelSamplingTime(io, instance, args[0])
        return result
    case 69:
        LL_ADC_SetChannelSingleDiff(io, instance, args[0], args[1])
        return 0
    case 70:
        let result = LL_ADC_GetChannelSingleDiff(io, instance, args[0])
        return result
    case 71:
        LL_ADC_SetAnalogWDMonitChannels(io, instance, args[0], args[1])
        return 0
    case 72:
        let result = LL_ADC_GetAnalogWDMonitChannels(io, instance, args[0])
        return result
    case 73:
        LL_ADC_ConfigAnalogWDThresholds(io, instance, args[0], args[1], args[2])
        return 0
    case 74:
        LL_ADC_SetAnalogWDThresholds(io, instance, args[0], args[1], args[2])
        return 0
    case 75:
        let result = LL_ADC_GetAnalogWDThresholds(io, instance, args[0], args[1])
        return result
    case 76:
        LL_ADC_SetAWDFilteringConfiguration(io, instance, args[0], args[1])
        return 0
    case 77:
        let result = LL_ADC_GetAWDFilteringConfiguration(io, instance, args[0])
        return result
    case 78:
        LL_ADC_SetOverSamplingScope(io, instance, args[0])
        return 0
    case 79:
        let result = LL_ADC_GetOverSamplingScope(io, instance)
        return result
    case 80:
        LL_ADC_SetOverSamplingDiscont(io, instance, args[0])
        return 0
    case 81:
        let result = LL_ADC_GetOverSamplingDiscont(io, instance)
        return result
    case 82:
        LL_ADC_ConfigOverSamplingRatioShift(io, instance, args[0], args[1])
        return 0
    case 83:
        let result = LL_ADC_GetOverSamplingRatio(io, instance)
        return result
    case 84:
        let result = LL_ADC_GetOverSamplingShift(io, instance)
        return result
    case 85:
        LL_ADC_SetMultimode(io, args[0])
        return 0
    case 86:
        let result = LL_ADC_GetMultimode(io)
        return result
    case 87:
        LL_ADC_SetMultiDMATransfer(io, args[0])
        return 0
    case 88:
        let result = LL_ADC_GetMultiDMATransfer(io)
        return result
    case 89:
        LL_ADC_SetMultiTwoSamplingDelay(io, args[0])
        return 0
    case 90:
        let result = LL_ADC_GetMultiTwoSamplingDelay(io)
        return result
    case 91:
        LL_ADC_EnableDeepPowerDown(io, instance)
        return 0
    case 92:
        LL_ADC_DisableDeepPowerDown(io, instance)
        return 0
    case 93:
        let result = LL_ADC_IsDeepPowerDownEnabled(io, instance)
        return result
    case 94:
        LL_ADC_EnableInternalRegulator(io, instance)
        return 0
    case 95:
        LL_ADC_DisableInternalRegulator(io, instance)
        return 0
    case 96:
        let result = LL_ADC_IsInternalRegulatorEnabled(io, instance)
        return result
    case 97:
        LL_ADC_Enable(io, instance)
        return 0
    case 98:
        LL_ADC_Disable(io, instance)
        return 0
    case 99:
        let result = LL_ADC_IsEnabled(io, instance)
        return result
    case 100:
        let result = LL_ADC_IsDisableOngoing(io, instance)
        return result
    case 101:
        LL_ADC_StartCalibration(io, instance, args[0])
        return 0
    case 102:
        let result = LL_ADC_IsCalibrationOnGoing(io, instance)
        return result
    case 103:
        LL_ADC_REG_StartConversion(io, instance)
        return 0
    case 104:
        LL_ADC_REG_StopConversion(io, instance)
        return 0
    case 105:
        let result = LL_ADC_REG_IsConversionOngoing(io, instance)
        return result
    case 106:
        let result = LL_ADC_REG_IsStopConversionOngoing(io, instance)
        return result
    case 107:
        LL_ADC_REG_StartSamplingPhase(io, instance)
        return 0
    case 108:
        LL_ADC_REG_StopSamplingPhase(io, instance)
        return 0
    case 109:
        let result = LL_ADC_REG_ReadConversionData32(io, instance)
        return result
    case 110:
        let result = UInt32(LL_ADC_REG_ReadConversionData12(io, instance))
        return result
    case 111:
        let result = UInt32(LL_ADC_REG_ReadConversionData10(io, instance))
        return result
    case 112:
        let result = UInt32(LL_ADC_REG_ReadConversionData8(io, instance))
        return result
    case 113:
        let result = UInt32(LL_ADC_REG_ReadConversionData6(io, instance))
        return result
    case 114:
        let result = LL_ADC_REG_ReadMultiConversionData32(io, args[0])
        return result
    case 115:
        LL_ADC_INJ_StartConversion(io, instance)
        return 0
    case 116:
        LL_ADC_INJ_StopConversion(io, instance)
        return 0
    case 117:
        let result = LL_ADC_INJ_IsConversionOngoing(io, instance)
        return result
    case 118:
        let result = LL_ADC_INJ_IsStopConversionOngoing(io, instance)
        return result
    case 119:
        let result = LL_ADC_INJ_ReadConversionData32(io, instance, args[0])
        return result
    case 120:
        let result = UInt32(LL_ADC_INJ_ReadConversionData12(io, instance, args[0]))
        return result
    case 121:
        let result = UInt32(LL_ADC_INJ_ReadConversionData10(io, instance, args[0]))
        return result
    case 122:
        let result = UInt32(LL_ADC_INJ_ReadConversionData8(io, instance, args[0]))
        return result
    case 123:
        let result = UInt32(LL_ADC_INJ_ReadConversionData6(io, instance, args[0]))
        return result
    case 124:
        let result = LL_ADC_IsActiveFlag_ADRDY(io, instance)
        return result
    case 125:
        let result = LL_ADC_IsActiveFlag_EOC(io, instance)
        return result
    case 126:
        let result = LL_ADC_IsActiveFlag_EOS(io, instance)
        return result
    case 127:
        let result = LL_ADC_IsActiveFlag_OVR(io, instance)
        return result
    case 128:
        let result = LL_ADC_IsActiveFlag_EOSMP(io, instance)
        return result
    case 129:
        let result = LL_ADC_IsActiveFlag_JEOC(io, instance)
        return result
    case 130:
        let result = LL_ADC_IsActiveFlag_JEOS(io, instance)
        return result
    case 131:
        let result = LL_ADC_IsActiveFlag_JQOVF(io, instance)
        return result
    case 132:
        let result = LL_ADC_IsActiveFlag_AWD1(io, instance)
        return result
    case 133:
        let result = LL_ADC_IsActiveFlag_AWD2(io, instance)
        return result
    case 134:
        let result = LL_ADC_IsActiveFlag_AWD3(io, instance)
        return result
    case 135:
        LL_ADC_ClearFlag_ADRDY(io, instance)
        return 0
    case 136:
        LL_ADC_ClearFlag_EOC(io, instance)
        return 0
    case 137:
        LL_ADC_ClearFlag_EOS(io, instance)
        return 0
    case 138:
        LL_ADC_ClearFlag_OVR(io, instance)
        return 0
    case 139:
        LL_ADC_ClearFlag_EOSMP(io, instance)
        return 0
    case 140:
        LL_ADC_ClearFlag_JEOC(io, instance)
        return 0
    case 141:
        LL_ADC_ClearFlag_JEOS(io, instance)
        return 0
    case 142:
        LL_ADC_ClearFlag_JQOVF(io, instance)
        return 0
    case 143:
        LL_ADC_ClearFlag_AWD1(io, instance)
        return 0
    case 144:
        LL_ADC_ClearFlag_AWD2(io, instance)
        return 0
    case 145:
        LL_ADC_ClearFlag_AWD3(io, instance)
        return 0
    case 146:
        let result = LL_ADC_IsActiveFlag_MST_ADRDY(io)
        return result
    case 147:
        let result = LL_ADC_IsActiveFlag_SLV_ADRDY(io)
        return result
    case 148:
        let result = LL_ADC_IsActiveFlag_MST_EOC(io)
        return result
    case 149:
        let result = LL_ADC_IsActiveFlag_SLV_EOC(io)
        return result
    case 150:
        let result = LL_ADC_IsActiveFlag_MST_EOS(io)
        return result
    case 151:
        let result = LL_ADC_IsActiveFlag_SLV_EOS(io)
        return result
    case 152:
        let result = LL_ADC_IsActiveFlag_MST_OVR(io)
        return result
    case 153:
        let result = LL_ADC_IsActiveFlag_SLV_OVR(io)
        return result
    case 154:
        let result = LL_ADC_IsActiveFlag_MST_EOSMP(io)
        return result
    case 155:
        let result = LL_ADC_IsActiveFlag_SLV_EOSMP(io)
        return result
    case 156:
        let result = LL_ADC_IsActiveFlag_MST_JEOC(io)
        return result
    case 157:
        let result = LL_ADC_IsActiveFlag_SLV_JEOC(io)
        return result
    case 158:
        let result = LL_ADC_IsActiveFlag_MST_JEOS(io)
        return result
    case 159:
        let result = LL_ADC_IsActiveFlag_SLV_JEOS(io)
        return result
    case 160:
        let result = LL_ADC_IsActiveFlag_MST_JQOVF(io)
        return result
    case 161:
        let result = LL_ADC_IsActiveFlag_SLV_JQOVF(io)
        return result
    case 162:
        let result = LL_ADC_IsActiveFlag_MST_AWD1(io)
        return result
    case 163:
        let result = LL_ADC_IsActiveFlag_SLV_AWD1(io)
        return result
    case 164:
        let result = LL_ADC_IsActiveFlag_MST_AWD2(io)
        return result
    case 165:
        let result = LL_ADC_IsActiveFlag_SLV_AWD2(io)
        return result
    case 166:
        let result = LL_ADC_IsActiveFlag_MST_AWD3(io)
        return result
    case 167:
        let result = LL_ADC_IsActiveFlag_SLV_AWD3(io)
        return result
    case 168:
        LL_ADC_EnableIT_ADRDY(io, instance)
        return 0
    case 169:
        LL_ADC_EnableIT_EOC(io, instance)
        return 0
    case 170:
        LL_ADC_EnableIT_EOS(io, instance)
        return 0
    case 171:
        LL_ADC_EnableIT_OVR(io, instance)
        return 0
    case 172:
        LL_ADC_EnableIT_EOSMP(io, instance)
        return 0
    case 173:
        LL_ADC_EnableIT_JEOC(io, instance)
        return 0
    case 174:
        LL_ADC_EnableIT_JEOS(io, instance)
        return 0
    case 175:
        LL_ADC_EnableIT_JQOVF(io, instance)
        return 0
    case 176:
        LL_ADC_EnableIT_AWD1(io, instance)
        return 0
    case 177:
        LL_ADC_EnableIT_AWD2(io, instance)
        return 0
    case 178:
        LL_ADC_EnableIT_AWD3(io, instance)
        return 0
    case 179:
        LL_ADC_DisableIT_ADRDY(io, instance)
        return 0
    case 180:
        LL_ADC_DisableIT_EOC(io, instance)
        return 0
    case 181:
        LL_ADC_DisableIT_EOS(io, instance)
        return 0
    case 182:
        LL_ADC_DisableIT_OVR(io, instance)
        return 0
    case 183:
        LL_ADC_DisableIT_EOSMP(io, instance)
        return 0
    case 184:
        LL_ADC_DisableIT_JEOC(io, instance)
        return 0
    case 185:
        LL_ADC_DisableIT_JEOS(io, instance)
        return 0
    case 186:
        LL_ADC_DisableIT_JQOVF(io, instance)
        return 0
    case 187:
        LL_ADC_DisableIT_AWD1(io, instance)
        return 0
    case 188:
        LL_ADC_DisableIT_AWD2(io, instance)
        return 0
    case 189:
        LL_ADC_DisableIT_AWD3(io, instance)
        return 0
    case 190:
        let result = LL_ADC_IsEnabledIT_ADRDY(io, instance)
        return result
    case 191:
        let result = LL_ADC_IsEnabledIT_EOC(io, instance)
        return result
    case 192:
        let result = LL_ADC_IsEnabledIT_EOS(io, instance)
        return result
    case 193:
        let result = LL_ADC_IsEnabledIT_OVR(io, instance)
        return result
    case 194:
        let result = LL_ADC_IsEnabledIT_EOSMP(io, instance)
        return result
    case 195:
        let result = LL_ADC_IsEnabledIT_JEOC(io, instance)
        return result
    case 196:
        let result = LL_ADC_IsEnabledIT_JEOS(io, instance)
        return result
    case 197:
        let result = LL_ADC_IsEnabledIT_JQOVF(io, instance)
        return result
    case 198:
        let result = LL_ADC_IsEnabledIT_AWD1(io, instance)
        return result
    case 199:
        let result = LL_ADC_IsEnabledIT_AWD2(io, instance)
        return result
    case 200:
        let result = LL_ADC_IsEnabledIT_AWD3(io, instance)
        return result
    case 201:
        let result = LL_ADC_CommonDeInit(&bus).rawValue
        return result
    case 202:
        let v1 = LL_ADC_CommonInitTypeDef(
            CommonClock: args[0], Multimode: args[1], MultiDMATransfer: args[2], MultiTwoSamplingDelay: args[3])
        let result = LL_ADC_CommonInit(io, v1).rawValue
        io.cells[512] = v1.CommonClock
        io.cells[513] = v1.Multimode
        io.cells[514] = v1.MultiDMATransfer
        io.cells[515] = v1.MultiTwoSamplingDelay
        return result
    case 203:
        var v0 = LL_ADC_CommonInitTypeDef(
            CommonClock: args[0], Multimode: args[1], MultiDMATransfer: args[2], MultiTwoSamplingDelay: args[3])
        LL_ADC_CommonStructInit(&v0)
        io.cells[512] = v0.CommonClock
        io.cells[513] = v0.Multimode
        io.cells[514] = v0.MultiDMATransfer
        io.cells[515] = v0.MultiTwoSamplingDelay
        return 0
    case 204:
        let result = LL_ADC_DeInit(io, instance).rawValue
        return result
    case 205:
        let v1 = LL_ADC_InitTypeDef(Resolution: args[0], DataAlignment: args[1], LowPowerMode: args[2])
        let result = LL_ADC_Init(io, instance, v1).rawValue
        io.cells[512] = v1.Resolution
        io.cells[513] = v1.DataAlignment
        io.cells[514] = v1.LowPowerMode
        return result
    case 206:
        var v0 = LL_ADC_InitTypeDef(Resolution: args[0], DataAlignment: args[1], LowPowerMode: args[2])
        LL_ADC_StructInit(&v0)
        io.cells[512] = v0.Resolution
        io.cells[513] = v0.DataAlignment
        io.cells[514] = v0.LowPowerMode
        return 0
    case 207:
        let v1 = LL_ADC_REG_InitTypeDef(
            TriggerSource: args[0], SequencerLength: args[1], SequencerDiscont: args[2], ContinuousMode: args[3],
            DMATransfer: args[4], Overrun: args[5])
        let result = LL_ADC_REG_Init(io, instance, v1).rawValue
        io.cells[512] = v1.TriggerSource
        io.cells[513] = v1.SequencerLength
        io.cells[514] = v1.SequencerDiscont
        io.cells[515] = v1.ContinuousMode
        io.cells[516] = v1.DMATransfer
        io.cells[517] = v1.Overrun
        return result
    case 208:
        var v0 = LL_ADC_REG_InitTypeDef(
            TriggerSource: args[0], SequencerLength: args[1], SequencerDiscont: args[2], ContinuousMode: args[3],
            DMATransfer: args[4], Overrun: args[5])
        LL_ADC_REG_StructInit(&v0)
        io.cells[512] = v0.TriggerSource
        io.cells[513] = v0.SequencerLength
        io.cells[514] = v0.SequencerDiscont
        io.cells[515] = v0.ContinuousMode
        io.cells[516] = v0.DMATransfer
        io.cells[517] = v0.Overrun
        return 0
    case 209:
        let v1 = LL_ADC_INJ_InitTypeDef(
            TriggerSource: args[0], SequencerLength: args[1], SequencerDiscont: args[2], TrigAuto: args[3])
        let result = LL_ADC_INJ_Init(io, instance, v1).rawValue
        io.cells[512] = v1.TriggerSource
        io.cells[513] = v1.SequencerLength
        io.cells[514] = v1.SequencerDiscont
        io.cells[515] = v1.TrigAuto
        return result
    case 210:
        var v0 = LL_ADC_INJ_InitTypeDef(
            TriggerSource: args[0], SequencerLength: args[1], SequencerDiscont: args[2], TrigAuto: args[3])
        LL_ADC_INJ_StructInit(&v0)
        io.cells[512] = v0.TriggerSource
        io.cells[513] = v0.SequencerLength
        io.cells[514] = v0.SequencerDiscont
        io.cells[515] = v0.TrigAuto
        return 0
    case 211:
        LL_ADC_WriteReg(io, instance, .cfgr, args[0])
        return LL_ADC_ReadReg(io, instance, .cfgr)
    case 212:
        LL_ADC_WriteReg(io, .ccr, args[0])
        return LL_ADC_ReadReg(io, .ccr)
    case 213: return __LL_ADC_CHANNEL_TO_DECIMAL_NB(args[0])
    case 214: return __LL_ADC_DECIMAL_NB_TO_CHANNEL(args[0])
    case 215: return __LL_ADC_IS_CHANNEL_INTERNAL(args[0]) ? 1 : 0
    case 216: return __LL_ADC_CHANNEL_INTERNAL_TO_EXTERNAL(args[0])
    case 217: return __LL_ADC_ANALOGWD_CHANNEL_GROUP(args[0], args[1])
    case 218: return __LL_ADC_ANALOGWD_SET_THRESHOLD_RESOLUTION(args[0], args[1])
    case 219: return __LL_ADC_ANALOGWD_GET_THRESHOLD_RESOLUTION(args[0], args[1])
    case 220: return __LL_ADC_ANALOGWD_THRESHOLDS_HIGH_LOW(args[0], args[1])
    case 221: return __LL_ADC_CALIB_FACTOR_SINGLE_DIFF(args[0], args[1])
    case 222: return __LL_ADC_MULTI_CONV_DATA_MASTER_SLAVE(args[0], args[1])
    case 223: return __LL_ADC_DIGITAL_SCALE(args[0])
    case 224: return __LL_ADC_CONVERT_DATA_RESOLUTION(args[0], args[1], args[2])
    case 225: return __LL_ADC_CALC_DATA_TO_VOLTAGE(args[0], args[1], args[2])
    case 226: return UInt32(bitPattern: __LL_ADC_CALC_DIFF_DATA_TO_VOLTAGE(args[0], args[1], args[2]))
    case 227: return __LL_ADC_CALC_VREFANALOG_VOLTAGE(args[0], args[1], io)
    case 228: return UInt32(bitPattern: __LL_ADC_CALC_TEMPERATURE(args[0], args[1], args[2], io))
    case 229:
        return UInt32(
            bitPattern: __LL_ADC_CALC_TEMPERATURE_TYP_PARAMS(
                args[0], args[1], Int32(bitPattern: args[2]), args[3], args[4], args[5]))
    case 230: return __LL_ADC_IS_CHANNEL_INTERNAL_AVAILABLE(instance, args[0]) ? 1 : 0
    case 231: return __LL_ADC_MULTI_INSTANCE_MASTER(instance).rawValue
    case 232: return __LL_ADC_COMMON_INSTANCE(instance)
    case 233: return __LL_ADC_IS_ENABLED_ALL_COMMON_INSTANCE(io)
    default: preconditionFailure("Unknown operation")
    }
}
final class LLADCDifferentialTests: XCTestCase {
    @discardableResult
    private func compare(
        _ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0, instance: UInt32 = 0,
        cr: UInt32? = nil, stopAt: UInt32 = 0, disableAt: UInt32 = 0, factory: [UInt32]? = nil,
        file: StaticString = #filePath, line: UInt = #line
    ) -> LLADCImage {
        let c = CL53_Create()!
        defer { CL53_Destroy(c) }
        CL53_Reset(c, seed, salt, instance, stopAt, disableAt)
        let io = LLADCImage(seed: seed, salt: salt, instance: instance, stopAt: stopAt, disableAt: disableAt)
        if let cr {
            io.cells[Int(instance * 64 + 2)] = cr
            CL53_GetCells(c)[Int(instance * 64 + 2)] = cr
        }
        if let factory {
            for i in 0..<3 {
                io.cells[600 + i] = factory[i]
                CL53_GetCells(c)[600 + i] = factory[i]
            }
        }
        let sr = runLLADC(op, io, args)
        let crResult = CL53_Run(c, UInt32(op), args)
        let context = "op=\(op) args=\(args) seed=\(seed) salt=\(salt) instance=\(instance)"
        XCTAssertEqual(sr, crResult, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL53_GetCells(c), count: 1024)
        for i in cells.indices where cells[i] != io.cells[i] {
            XCTFail("\(context) cell \(i): Swift \(io.cells[i]), C \(cells[i])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL53_GetTrace(c), count: Int(CL53_GetTraceCount(c)))
        XCTAssertEqual(
            io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file,
            line: line)
        return io
    }
    func testEveryFunctionOnBothInstancesWithChangingReads() {
        let channels: [UInt32] =
            (0...18).map { __LL_ADC_DECIMAL_NB_TO_CHANNEL(UInt32($0)) } + [
                LL_ADC_CHANNEL_VREFINT, LL_ADC_CHANNEL_TEMPSENSOR, LL_ADC_CHANNEL_VBAT, LL_ADC_CHANNEL_VDDCORE,
            ]
        let regularRanks: [UInt32] = [
            LL_ADC_REG_RANK_1, LL_ADC_REG_RANK_2, LL_ADC_REG_RANK_3, LL_ADC_REG_RANK_4, LL_ADC_REG_RANK_5,
            LL_ADC_REG_RANK_6, LL_ADC_REG_RANK_7, LL_ADC_REG_RANK_8, LL_ADC_REG_RANK_9, LL_ADC_REG_RANK_10,
            LL_ADC_REG_RANK_11, LL_ADC_REG_RANK_12, LL_ADC_REG_RANK_13, LL_ADC_REG_RANK_14, LL_ADC_REG_RANK_15,
            LL_ADC_REG_RANK_16,
        ]
        let injectedRanks: [UInt32] = [LL_ADC_INJ_RANK_1, LL_ADC_INJ_RANK_2, LL_ADC_INJ_RANK_3, LL_ADC_INJ_RANK_4]
        let watchdogs: [UInt32] = [LL_ADC_AWD1, LL_ADC_AWD2, LL_ADC_AWD3]
        for op in 0..<211 {
            for instance: UInt32 in 0..<2 {
                for sample: UInt32 in 0..<32 {
                    let seed = sample &* 0x9E37_79B9
                    var args = (0..<16).map { seed ^ (UInt32($0) &* 0x1020_4081) }
                    if op == 11 { args[0] = sample % 2 == 0 ? LL_ADC_SINGLE_ENDED : LL_ADC_DIFFERENTIAL_ENDED }
                    if op == 12 { args[0] = sample % 2 == 0 ? LL_ADC_SINGLE_ENDED : LL_ADC_DIFFERENTIAL_ENDED }
                    if op == 19 { args[0] = sample % 4 }
                    if op == 19 { args[1] = channels[Int((sample + 1) % UInt32(channels.count))] }
                    if op == 20 { args[0] = sample % 4 }
                    if op == 21 { args[0] = sample % 4 }
                    if op == 22 { args[0] = sample % 4 }
                    if op == 23 { args[0] = sample % 4 }
                    if op == 24 { args[0] = sample % 4 }
                    if op == 25 { args[0] = sample % 4 }
                    if op == 26 { args[0] = sample % 4 }
                    if op == 27 { args[0] = sample % 4 }
                    if op == 41 { args[0] = regularRanks[Int(sample % 16)] }
                    if op == 41 { args[1] = channels[Int((sample + 1) % UInt32(channels.count))] }
                    if op == 42 { args[0] = regularRanks[Int(sample % 16)] }
                    if op == 60 { args[0] = injectedRanks[Int(sample % 4)] }
                    if op == 60 { args[1] = channels[Int((sample + 1) % UInt32(channels.count))] }
                    if op == 61 { args[0] = injectedRanks[Int(sample % 4)] }
                    if op == 66 { args[3] = channels[Int((sample + 3) % UInt32(channels.count))] }
                    if op == 66 { args[4] = channels[Int((sample + 4) % UInt32(channels.count))] }
                    if op == 66 { args[5] = channels[Int((sample + 5) % UInt32(channels.count))] }
                    if op == 66 { args[6] = channels[Int((sample + 6) % UInt32(channels.count))] }
                    if op == 67 { args[0] = channels[Int((sample + 0) % UInt32(channels.count))] }
                    if op == 68 { args[0] = channels[Int((sample + 0) % UInt32(channels.count))] }
                    if op == 69 { args[0] = channels[Int((sample + 0) % UInt32(channels.count))] }
                    if op == 69 { args[1] = sample % 2 == 0 ? LL_ADC_SINGLE_ENDED : LL_ADC_DIFFERENTIAL_ENDED }
                    if op == 70 { args[0] = channels[Int((sample + 0) % UInt32(channels.count))] }
                    if op == 71 { args[0] = watchdogs[Int(sample % 3)] }
                    if op == 72 { args[0] = watchdogs[Int(sample % 3)] }
                    if op == 73 { args[0] = watchdogs[Int(sample % 3)] }
                    if op == 74 { args[0] = watchdogs[Int(sample % 3)] }
                    if op == 74 {
                        args[1] =
                            sample % 3 == 0
                            ? LL_ADC_AWD_THRESHOLD_HIGH
                            : sample % 3 == 1 ? LL_ADC_AWD_THRESHOLD_LOW : (LL_ADC_AWD_THRESHOLD_HIGH | LL_ADC_AWD_THRESHOLD_LOW)
                    }
                    if op == 75 { args[0] = watchdogs[Int(sample % 3)] }
                    if op == 75 {
                        args[1] =
                            sample % 3 == 0
                            ? LL_ADC_AWD_THRESHOLD_HIGH
                            : sample % 3 == 1 ? LL_ADC_AWD_THRESHOLD_LOW : (LL_ADC_AWD_THRESHOLD_HIGH | LL_ADC_AWD_THRESHOLD_LOW)
                    }
                    if op == 76 { args[0] = watchdogs[Int(sample % 3)] }
                    if op == 77 { args[0] = watchdogs[Int(sample % 3)] }
                    if op == 101 { args[0] = sample % 2 == 0 ? LL_ADC_SINGLE_ENDED : LL_ADC_DIFFERENTIAL_ENDED }
                    if op == 119 { args[0] = injectedRanks[Int(sample % 4)] }
                    if op == 120 { args[0] = injectedRanks[Int(sample % 4)] }
                    if op == 121 { args[0] = injectedRanks[Int(sample % 4)] }
                    if op == 122 { args[0] = injectedRanks[Int(sample % 4)] }
                    if op == 123 { args[0] = injectedRanks[Int(sample % 4)] }
                    compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x1020_4081, instance: instance)
                }
            }
        }
    }
    func testDeInitSuccessStopAndDisableTimeoutPaths() {
        for instance: UInt32 in 0..<2 {
            for cr: UInt32 in [0, 1, 5, 9, 13, 0x11, 0x21, 0x31, 0x8000_0000, 0xFFFF_FFFF] {
                for scenario in [(UInt32(0), UInt32(0)), (8, 12), (0, 12), (8, 0), (7940, 11900)] {
                    compare(
                        204, [], seed: 0xA5A5_A5A5, instance: instance, cr: cr, stopAt: scenario.0,
                        disableAt: scenario.1)
                }
            }
        }
    }
    func testInitializationBranchesAndDefaultStructures() {
        for instance: UInt32 in 0..<2 {
            for enabled: UInt32 in 0...1 {
                for sample: UInt32 in 0..<16 {
                    let args: [UInt32] = [
                        sample % 2 == 0 ? 0 : 0x8200_0000, sample % 2 == 0 ? 0 : 3, sample * 65536, sample * 4096,
                        0x202, 0x1000,
                    ]
                    for op in [202, 205, 207, 209] { compare(op, args, seed: 0, instance: instance, cr: enabled) }
                }
            }
        }
    }
    func testRawRegisterAndInstanceHelpers() {
        for instance: UInt32 in 0..<2 {
            for sample: UInt32 in 0..<32 {
                compare(211, [sample &* 0x9E37_79B9], seed: sample, salt: 0x1020_4081, instance: instance)
                compare(212, [sample &* 0x9E37_79B9], seed: sample, salt: 0x1020_4081, instance: instance)
                compare(230, [sample &* 0x9E37_79B9], seed: sample, salt: 0x1020_4081, instance: instance)
                compare(231, [sample &* 0x9E37_79B9], seed: sample, salt: 0x1020_4081, instance: instance)
                compare(232, [sample &* 0x9E37_79B9], seed: sample, salt: 0x1020_4081, instance: instance)
                compare(233, [sample &* 0x9E37_79B9], seed: sample, salt: 0x1020_4081, instance: instance)
            }
        }
    }
    func testChannelWatchdogAndResolutionMacros() {
        let resolutions: [UInt32] = [
            LL_ADC_RESOLUTION_12B, LL_ADC_RESOLUTION_10B, LL_ADC_RESOLUTION_8B, LL_ADC_RESOLUTION_6B,
        ]
        for sample: UInt32 in 0..<256 {
            let value = sample &* 0x1020_4081
            let channel = __LL_ADC_DECIMAL_NB_TO_CHANNEL(sample % 19)
            compare(213, [value])
            compare(214, [sample % 32])
            compare(215, [value])
            compare(216, [value])
            compare(217, [channel, sample % 4])
            compare(220, [sample % 2 == 0 ? LL_ADC_AWD_THRESHOLD_HIGH : LL_ADC_AWD_THRESHOLD_LOW, value])
            compare(221, [value, ~value])
            compare(222, [sample % 2 == 0 ? LL_ADC_MULTI_MASTER : LL_ADC_MULTI_SLAVE, value])
            for resolution in resolutions {
                compare(218, [resolution, value])
                compare(219, [resolution, value])
                compare(223, [resolution])
                compare(224, [value, resolution, resolutions[Int(sample % 4)]])
            }
        }
    }
    func testVoltageTemperatureAndFactoryReadOrder() {
        for resolution: UInt32 in [0, 8, 16, 24] {
            let scale = __LL_ADC_DIGITAL_SCALE(resolution)
            for sample: UInt32 in 0..<128 {
                let data = 1 + sample * scale / 128
                let voltage: UInt32 = 1800 + sample * 12
                compare(225, [voltage, data, resolution], factory: [1500, 1000, 1300])
                compare(226, [voltage, data, resolution], factory: [1500, 1000, 1300])
                compare(227, [data, resolution], factory: [1500, 1000, 1300])
                compare(228, [voltage, data, resolution], factory: [1500, 1000, 1300])
                compare(229, [2500, 760, 30, voltage, data, resolution], factory: [1500, 1000, 1300])
                compare(228, [voltage, data, resolution], factory: [1500, 1000, 1000])
            }
        }
    }
    func testIndependentAccessContracts() {
        let io = LLADCImage(seed: 0, salt: 0, instance: 0)
        io.cells[2] = 1
        io.cells[66] = 0
        XCTAssertEqual(__LL_ADC_IS_ENABLED_ALL_COMMON_INSTANCE(io), 1)
        XCTAssertEqual(io.trace.map(\.index), [2, 66])
        io.trace.removeAll()
        io.cells[0] = 0x8000_0000
        LL_ADC_ClearFlag_EOC(io, .adc1)
        XCTAssertEqual(io.trace, [.init(index: 0, value: 4, kind: 1)])
        io.trace.removeAll()
        io.cells[2] = 0
        io.cells[66] = 1
        XCTAssertEqual(LL_ADC_CommonInit(io, .init()), .error)
        XCTAssertEqual(io.trace.map(\.index), [2, 66])
        io.trace.removeAll()
        io.cells[600] = 1500
        io.cells[601] = 1000
        io.cells[602] = 1300
        _ = __LL_ADC_CALC_TEMPERATURE(3300, 1100, LL_ADC_RESOLUTION_12B, io)
        XCTAssertEqual(io.trace.map(\.index), [602, 601, 601, 602, 601])
    }
    func testResetMasksDataWidthsAndTimeoutBounds() {
        let io = LLADCImage(seed: 0, salt: 0, instance: 0)
        io.cells[2] = 0; io.cells[66] = 0; io.cells[194] = 0x2000
        XCTAssertEqual(LL_ADC_CommonInit(io, .init()), .success)
        XCTAssertEqual(io.cells[194] & 0x2000, 0x2000)
        io.cells[5] = .max; io.cells[50] = 1
        XCTAssertEqual(LL_ADC_DeInit(io, .adc1), .success)
        XCTAssertEqual(io.cells[5] & 7, 7)
        XCTAssertEqual(io.cells[50], 1)
        io.cells[16] = .max
        XCTAssertEqual(LL_ADC_REG_ReadConversionData12(io, .adc1), 0xFFFF)
        XCTAssertEqual(LL_ADC_REG_ReadConversionData10(io, .adc1), 0xFFFF)
        XCTAssertEqual(LL_ADC_REG_ReadConversionData8(io, .adc1), 0xFF)
        XCTAssertEqual(LL_ADC_REG_ReadConversionData6(io, .adc1), 0xFF)
        io.trace.removeAll(); io.cells[2] = 1
        XCTAssertEqual(LL_ADC_DeInit(io, .adc1), .error)
        XCTAssertEqual(io.trace.filter { $0.index == 2 && $0.kind == 0 }.count, 3975)
        io.trace.removeAll(); io.cells[2] = 5
        XCTAssertEqual(LL_ADC_DeInit(io, .adc1), .error)
        XCTAssertEqual(io.trace.filter { $0.index == 2 && $0.kind == 0 }.count, 11911)
    }
    func testPinnedConstants() {
        let values: [UInt32] = [
            LL_ADC_FLAG_ADRDY,
            LL_ADC_FLAG_EOC,
            LL_ADC_FLAG_EOS,
            LL_ADC_FLAG_OVR,
            LL_ADC_FLAG_EOSMP,
            LL_ADC_FLAG_JEOC,
            LL_ADC_FLAG_JEOS,
            LL_ADC_FLAG_JQOVF,
            LL_ADC_FLAG_AWD1,
            LL_ADC_FLAG_AWD2,
            LL_ADC_FLAG_AWD3,
            LL_ADC_FLAG_ADRDY_MST,
            LL_ADC_FLAG_ADRDY_SLV,
            LL_ADC_FLAG_EOC_MST,
            LL_ADC_FLAG_EOC_SLV,
            LL_ADC_FLAG_EOS_MST,
            LL_ADC_FLAG_EOS_SLV,
            LL_ADC_FLAG_OVR_MST,
            LL_ADC_FLAG_OVR_SLV,
            LL_ADC_FLAG_EOSMP_MST,
            LL_ADC_FLAG_EOSMP_SLV,
            LL_ADC_FLAG_JEOC_MST,
            LL_ADC_FLAG_JEOC_SLV,
            LL_ADC_FLAG_JEOS_MST,
            LL_ADC_FLAG_JEOS_SLV,
            LL_ADC_FLAG_JQOVF_MST,
            LL_ADC_FLAG_JQOVF_SLV,
            LL_ADC_FLAG_AWD1_MST,
            LL_ADC_FLAG_AWD1_SLV,
            LL_ADC_FLAG_AWD2_MST,
            LL_ADC_FLAG_AWD2_SLV,
            LL_ADC_FLAG_AWD3_MST,
            LL_ADC_FLAG_AWD3_SLV,
            LL_ADC_IT_ADRDY,
            LL_ADC_IT_EOC,
            LL_ADC_IT_EOS,
            LL_ADC_IT_OVR,
            LL_ADC_IT_EOSMP,
            LL_ADC_IT_JEOC,
            LL_ADC_IT_JEOS,
            LL_ADC_IT_JQOVF,
            LL_ADC_IT_AWD1,
            LL_ADC_IT_AWD2,
            LL_ADC_IT_AWD3,
            LL_ADC_DMA_REG_REGULAR_DATA,
            LL_ADC_DMA_REG_REGULAR_DATA_MULTI,
            LL_ADC_CLOCK_SYNC_PCLK_DIV1,
            LL_ADC_CLOCK_SYNC_PCLK_DIV2,
            LL_ADC_CLOCK_SYNC_PCLK_DIV4,
            LL_ADC_CLOCK_ASYNC_DIV1,
            LL_ADC_CLOCK_ASYNC_DIV2,
            LL_ADC_CLOCK_ASYNC_DIV4,
            LL_ADC_CLOCK_ASYNC_DIV6,
            LL_ADC_CLOCK_ASYNC_DIV8,
            LL_ADC_CLOCK_ASYNC_DIV10,
            LL_ADC_CLOCK_ASYNC_DIV12,
            LL_ADC_CLOCK_ASYNC_DIV16,
            LL_ADC_CLOCK_ASYNC_DIV32,
            LL_ADC_CLOCK_ASYNC_DIV64,
            LL_ADC_CLOCK_ASYNC_DIV128,
            LL_ADC_CLOCK_ASYNC_DIV256,
            LL_ADC_PATH_INTERNAL_NONE,
            LL_ADC_PATH_INTERNAL_VREFINT,
            LL_ADC_PATH_INTERNAL_TEMPSENSOR,
            LL_ADC_PATH_INTERNAL_VBAT,
            LL_ADC_PATH_INTERNAL_VDDCORE,
            LL_ADC_RESOLUTION_12B,
            LL_ADC_RESOLUTION_10B,
            LL_ADC_RESOLUTION_8B,
            LL_ADC_RESOLUTION_6B,
            LL_ADC_DATA_ALIGN_RIGHT,
            LL_ADC_DATA_ALIGN_LEFT,
            LL_ADC_LP_MODE_NONE,
            LL_ADC_LP_AUTOWAIT,
            LL_ADC_OFFSET_1,
            LL_ADC_OFFSET_2,
            LL_ADC_OFFSET_3,
            LL_ADC_OFFSET_4,
            LL_ADC_OFFSET_DISABLE,
            LL_ADC_OFFSET_ENABLE,
            LL_ADC_OFFSET_SIGN_NEGATIVE,
            LL_ADC_OFFSET_SIGN_POSITIVE,
            LL_ADC_OFFSET_SATURATION_DISABLE,
            LL_ADC_OFFSET_SATURATION_ENABLE,
            LL_ADC_GROUP_REGULAR,
            LL_ADC_GROUP_INJECTED,
            LL_ADC_GROUP_REGULAR_INJECTED,
            LL_ADC_CHANNEL_0,
            LL_ADC_CHANNEL_1,
            LL_ADC_CHANNEL_2,
            LL_ADC_CHANNEL_3,
            LL_ADC_CHANNEL_4,
            LL_ADC_CHANNEL_5,
            LL_ADC_CHANNEL_6,
            LL_ADC_CHANNEL_7,
            LL_ADC_CHANNEL_8,
            LL_ADC_CHANNEL_9,
            LL_ADC_CHANNEL_10,
            LL_ADC_CHANNEL_11,
            LL_ADC_CHANNEL_12,
            LL_ADC_CHANNEL_13,
            LL_ADC_CHANNEL_14,
            LL_ADC_CHANNEL_15,
            LL_ADC_CHANNEL_16,
            LL_ADC_CHANNEL_17,
            LL_ADC_CHANNEL_18,
            LL_ADC_CHANNEL_VREFINT,
            LL_ADC_CHANNEL_TEMPSENSOR,
            LL_ADC_CHANNEL_VBAT,
            LL_ADC_CHANNEL_VDDCORE,
            LL_ADC_REG_TRIG_SOFTWARE,
            LL_ADC_REG_TRIG_EXT_TIM1_CH1,
            LL_ADC_REG_TRIG_EXT_TIM1_CH2,
            LL_ADC_REG_TRIG_EXT_TIM1_CH3,
            LL_ADC_REG_TRIG_EXT_TIM2_CH2,
            LL_ADC_REG_TRIG_EXT_TIM3_TRGO,
            LL_ADC_REG_TRIG_EXT_TIM4_CH4,
            LL_ADC_REG_TRIG_EXT_EXTI_LINE11,
            LL_ADC_REG_TRIG_EXT_TIM12_TRGO,
            LL_ADC_REG_TRIG_EXT_TIM9_TRGO,
            LL_ADC_REG_TRIG_EXT_TIM1_TRGO,
            LL_ADC_REG_TRIG_EXT_TIM1_TRGO2,
            LL_ADC_REG_TRIG_EXT_TIM2_TRGO,
            LL_ADC_REG_TRIG_EXT_TIM4_TRGO,
            LL_ADC_REG_TRIG_EXT_TIM6_TRGO,
            LL_ADC_REG_TRIG_EXT_TIM15_TRGO,
            LL_ADC_REG_TRIG_EXT_TIM3_CH4,
            LL_ADC_REG_TRIG_EXT_LPTIM1_CH1,
            LL_ADC_REG_TRIG_EXT_LPTIM2_CH1,
            LL_ADC_REG_TRIG_EXT_LPTIM3_CH1,
            LL_ADC_REG_TRIG_EXT_RISING,
            LL_ADC_REG_TRIG_EXT_FALLING,
            LL_ADC_REG_TRIG_EXT_RISINGFALLING,
            LL_ADC_REG_SAMPLING_MODE_NORMAL,
            LL_ADC_REG_SAMPLING_MODE_BULB,
            LL_ADC_REG_SAMPLING_MODE_TRIGGER_CONTROLED,
            LL_ADC_REG_CONV_SINGLE,
            LL_ADC_REG_CONV_CONTINUOUS,
            LL_ADC_REG_DMA_TRANSFER_NONE,
            LL_ADC_REG_DMA_TRANSFER_LIMITED,
            LL_ADC_REG_DMA_TRANSFER_UNLIMITED,
            LL_ADC_REG_MDF_TRANSFER_NONE,
            LL_ADC_REG_MDF_TRANSFER_ENABLE,
            LL_ADC_SAMPLINGTIME_COMMON_DEFAULT,
            LL_ADC_SAMPLINGTIME_COMMON_3C5_REPL_2C5,
            LL_ADC_REG_OVR_DATA_PRESERVED,
            LL_ADC_REG_OVR_DATA_OVERWRITTEN,
            LL_ADC_REG_SEQ_SCAN_DISABLE,
            LL_ADC_REG_SEQ_SCAN_ENABLE_2RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_3RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_4RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_5RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_6RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_7RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_8RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_9RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_10RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_11RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_12RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_13RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_14RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_15RANKS,
            LL_ADC_REG_SEQ_SCAN_ENABLE_16RANKS,
            LL_ADC_REG_SEQ_DISCONT_DISABLE,
            LL_ADC_REG_SEQ_DISCONT_1RANK,
            LL_ADC_REG_SEQ_DISCONT_2RANKS,
            LL_ADC_REG_SEQ_DISCONT_3RANKS,
            LL_ADC_REG_SEQ_DISCONT_4RANKS,
            LL_ADC_REG_SEQ_DISCONT_5RANKS,
            LL_ADC_REG_SEQ_DISCONT_6RANKS,
            LL_ADC_REG_SEQ_DISCONT_7RANKS,
            LL_ADC_REG_SEQ_DISCONT_8RANKS,
            LL_ADC_REG_RANK_1,
            LL_ADC_REG_RANK_2,
            LL_ADC_REG_RANK_3,
            LL_ADC_REG_RANK_4,
            LL_ADC_REG_RANK_5,
            LL_ADC_REG_RANK_6,
            LL_ADC_REG_RANK_7,
            LL_ADC_REG_RANK_8,
            LL_ADC_REG_RANK_9,
            LL_ADC_REG_RANK_10,
            LL_ADC_REG_RANK_11,
            LL_ADC_REG_RANK_12,
            LL_ADC_REG_RANK_13,
            LL_ADC_REG_RANK_14,
            LL_ADC_REG_RANK_15,
            LL_ADC_REG_RANK_16,
            LL_ADC_INJ_TRIG_SOFTWARE,
            LL_ADC_INJ_TRIG_EXT_TIM1_TRGO,
            LL_ADC_INJ_TRIG_EXT_TIM1_CH4,
            LL_ADC_INJ_TRIG_EXT_TIM2_TRGO,
            LL_ADC_INJ_TRIG_EXT_TIM2_CH1,
            LL_ADC_INJ_TRIG_EXT_TIM3_CH4,
            LL_ADC_INJ_TRIG_EXT_TIM4_TRGO,
            LL_ADC_INJ_TRIG_EXT_EXTI_LINE15,
            LL_ADC_INJ_TRIG_EXT_TIM9_CH1,
            LL_ADC_INJ_TRIG_EXT_TIM1_TRGO2,
            LL_ADC_INJ_TRIG_EXT_TIM12_TRGO,
            LL_ADC_INJ_TRIG_EXT_TIM9_TRGO,
            LL_ADC_INJ_TRIG_EXT_TIM3_CH3,
            LL_ADC_INJ_TRIG_EXT_TIM3_TRGO,
            LL_ADC_INJ_TRIG_EXT_TIM3_CH1,
            LL_ADC_INJ_TRIG_EXT_TIM6_TRGO,
            LL_ADC_INJ_TRIG_EXT_TIM15_TRGO,
            LL_ADC_INJ_TRIG_EXT_LPTIM1_CH2,
            LL_ADC_INJ_TRIG_EXT_LPTIM2_CH2,
            LL_ADC_INJ_TRIG_EXT_LPTIM3_CH1,
            LL_ADC_INJ_TRIG_EXT_RISING,
            LL_ADC_INJ_TRIG_EXT_FALLING,
            LL_ADC_INJ_TRIG_EXT_RISINGFALLING,
            LL_ADC_INJ_TRIG_INDEPENDENT,
            LL_ADC_INJ_TRIG_FROM_GRP_REGULAR,
            LL_ADC_INJ_QUEUE_2CONTEXTS_LAST_ACTIVE,
            LL_ADC_INJ_QUEUE_2CONTEXTS_END_EMPTY,
            LL_ADC_INJ_QUEUE_DISABLE,
            LL_ADC_INJ_SEQ_SCAN_DISABLE,
            LL_ADC_INJ_SEQ_SCAN_ENABLE_2RANKS,
            LL_ADC_INJ_SEQ_SCAN_ENABLE_3RANKS,
            LL_ADC_INJ_SEQ_SCAN_ENABLE_4RANKS,
            LL_ADC_INJ_SEQ_DISCONT_DISABLE,
            LL_ADC_INJ_SEQ_DISCONT_1RANK,
            LL_ADC_INJ_RANK_1,
            LL_ADC_INJ_RANK_2,
            LL_ADC_INJ_RANK_3,
            LL_ADC_INJ_RANK_4,
            LL_ADC_SAMPLINGTIME_2CYCLES_5,
            LL_ADC_SAMPLINGTIME_6CYCLES_5,
            LL_ADC_SAMPLINGTIME_12CYCLES_5,
            LL_ADC_SAMPLINGTIME_24CYCLES_5,
            LL_ADC_SAMPLINGTIME_47CYCLES_5,
            LL_ADC_SAMPLINGTIME_92CYCLES_5,
            LL_ADC_SAMPLINGTIME_247CYCLES_5,
            LL_ADC_SAMPLINGTIME_640CYCLES_5,
            LL_ADC_SINGLE_ENDED,
            LL_ADC_DIFFERENTIAL_ENDED,
            LL_ADC_BOTH_SINGLE_DIFF_ENDED,
            LL_ADC_AWD1,
            LL_ADC_AWD2,
            LL_ADC_AWD3,
            LL_ADC_AWD_DISABLE,
            LL_ADC_AWD_ALL_CHANNELS_REG,
            LL_ADC_AWD_ALL_CHANNELS_INJ,
            LL_ADC_AWD_ALL_CHANNELS_REG_INJ,
            LL_ADC_AWD_CHANNEL_0_REG,
            LL_ADC_AWD_CHANNEL_0_INJ,
            LL_ADC_AWD_CHANNEL_0_REG_INJ,
            LL_ADC_AWD_CHANNEL_1_REG,
            LL_ADC_AWD_CHANNEL_1_INJ,
            LL_ADC_AWD_CHANNEL_1_REG_INJ,
            LL_ADC_AWD_CHANNEL_2_REG,
            LL_ADC_AWD_CHANNEL_2_INJ,
            LL_ADC_AWD_CHANNEL_2_REG_INJ,
            LL_ADC_AWD_CHANNEL_3_REG,
            LL_ADC_AWD_CHANNEL_3_INJ,
            LL_ADC_AWD_CHANNEL_3_REG_INJ,
            LL_ADC_AWD_CHANNEL_4_REG,
            LL_ADC_AWD_CHANNEL_4_INJ,
            LL_ADC_AWD_CHANNEL_4_REG_INJ,
            LL_ADC_AWD_CHANNEL_5_REG,
            LL_ADC_AWD_CHANNEL_5_INJ,
            LL_ADC_AWD_CHANNEL_5_REG_INJ,
            LL_ADC_AWD_CHANNEL_6_REG,
            LL_ADC_AWD_CHANNEL_6_INJ,
            LL_ADC_AWD_CHANNEL_6_REG_INJ,
            LL_ADC_AWD_CHANNEL_7_REG,
            LL_ADC_AWD_CHANNEL_7_INJ,
            LL_ADC_AWD_CHANNEL_7_REG_INJ,
            LL_ADC_AWD_CHANNEL_8_REG,
            LL_ADC_AWD_CHANNEL_8_INJ,
            LL_ADC_AWD_CHANNEL_8_REG_INJ,
            LL_ADC_AWD_CHANNEL_9_REG,
            LL_ADC_AWD_CHANNEL_9_INJ,
            LL_ADC_AWD_CHANNEL_9_REG_INJ,
            LL_ADC_AWD_CHANNEL_10_REG,
            LL_ADC_AWD_CHANNEL_10_INJ,
            LL_ADC_AWD_CHANNEL_10_REG_INJ,
            LL_ADC_AWD_CHANNEL_11_REG,
            LL_ADC_AWD_CHANNEL_11_INJ,
            LL_ADC_AWD_CHANNEL_11_REG_INJ,
            LL_ADC_AWD_CHANNEL_12_REG,
            LL_ADC_AWD_CHANNEL_12_INJ,
            LL_ADC_AWD_CHANNEL_12_REG_INJ,
            LL_ADC_AWD_CHANNEL_13_REG,
            LL_ADC_AWD_CHANNEL_13_INJ,
            LL_ADC_AWD_CHANNEL_13_REG_INJ,
            LL_ADC_AWD_CHANNEL_14_REG,
            LL_ADC_AWD_CHANNEL_14_INJ,
            LL_ADC_AWD_CHANNEL_14_REG_INJ,
            LL_ADC_AWD_CHANNEL_15_REG,
            LL_ADC_AWD_CHANNEL_15_INJ,
            LL_ADC_AWD_CHANNEL_15_REG_INJ,
            LL_ADC_AWD_CHANNEL_16_REG,
            LL_ADC_AWD_CHANNEL_16_INJ,
            LL_ADC_AWD_CHANNEL_16_REG_INJ,
            LL_ADC_AWD_CHANNEL_17_REG,
            LL_ADC_AWD_CHANNEL_17_INJ,
            LL_ADC_AWD_CHANNEL_17_REG_INJ,
            LL_ADC_AWD_CHANNEL_18_REG,
            LL_ADC_AWD_CHANNEL_18_INJ,
            LL_ADC_AWD_CHANNEL_18_REG_INJ,
            LL_ADC_AWD_CH_VREFINT_REG,
            LL_ADC_AWD_CH_VREFINT_INJ,
            LL_ADC_AWD_CH_VREFINT_REG_INJ,
            LL_ADC_AWD_CH_TEMPSENSOR_REG,
            LL_ADC_AWD_CH_TEMPSENSOR_INJ,
            LL_ADC_AWD_CH_TEMPSENSOR_REG_INJ,
            LL_ADC_AWD_CH_VBAT_REG,
            LL_ADC_AWD_CH_VBAT_INJ,
            LL_ADC_AWD_CH_VBAT_REG_INJ,
            LL_ADC_AWD_CH_VDDCORE_REG,
            LL_ADC_AWD_CH_VDDCORE_INJ,
            LL_ADC_AWD_CH_VDDCORE_REG_INJ,
            LL_ADC_AWD_THRESHOLD_HIGH,
            LL_ADC_AWD_THRESHOLD_LOW,
            LL_ADC_AWD_THRESHOLDS_HIGH_LOW,
            LL_ADC_AWD_FILTERING_NONE,
            LL_ADC_AWD_FILTERING_2SAMPLES,
            LL_ADC_AWD_FILTERING_3SAMPLES,
            LL_ADC_AWD_FILTERING_4SAMPLES,
            LL_ADC_AWD_FILTERING_5SAMPLES,
            LL_ADC_AWD_FILTERING_6SAMPLES,
            LL_ADC_AWD_FILTERING_7SAMPLES,
            LL_ADC_AWD_FILTERING_8SAMPLES,
            LL_ADC_OVS_DISABLE,
            LL_ADC_OVS_GRP_REGULAR_CONTINUED,
            LL_ADC_OVS_GRP_REGULAR_RESUMED,
            LL_ADC_OVS_GRP_INJECTED,
            LL_ADC_OVS_GRP_INJ_REG_RESUMED,
            LL_ADC_OVS_REG_CONT,
            LL_ADC_OVS_REG_DISCONT,
            LL_ADC_OVS_RATIO_2,
            LL_ADC_OVS_RATIO_4,
            LL_ADC_OVS_RATIO_8,
            LL_ADC_OVS_RATIO_16,
            LL_ADC_OVS_RATIO_32,
            LL_ADC_OVS_RATIO_64,
            LL_ADC_OVS_RATIO_128,
            LL_ADC_OVS_RATIO_256,
            LL_ADC_OVS_SHIFT_NONE,
            LL_ADC_OVS_SHIFT_RIGHT_1,
            LL_ADC_OVS_SHIFT_RIGHT_2,
            LL_ADC_OVS_SHIFT_RIGHT_3,
            LL_ADC_OVS_SHIFT_RIGHT_4,
            LL_ADC_OVS_SHIFT_RIGHT_5,
            LL_ADC_OVS_SHIFT_RIGHT_6,
            LL_ADC_OVS_SHIFT_RIGHT_7,
            LL_ADC_OVS_SHIFT_RIGHT_8,
            LL_ADC_MULTI_INDEPENDENT,
            LL_ADC_MULTI_DUAL_REG_SIMULT,
            LL_ADC_MULTI_DUAL_REG_INTERL,
            LL_ADC_MULTI_DUAL_INJ_SIMULT,
            LL_ADC_MULTI_DUAL_INJ_ALTERN,
            LL_ADC_MULTI_DUAL_REG_SIM_INJ_SIM,
            LL_ADC_MULTI_DUAL_REG_SIM_INJ_ALT,
            LL_ADC_MULTI_DUAL_REG_INT_INJ_SIM,
            LL_ADC_MULTI_REG_DMA_EACH_ADC,
            LL_ADC_MULTI_REG_DMA_LIMIT_RES12_10B,
            LL_ADC_MULTI_REG_DMA_LIMIT_RES8_6B,
            LL_ADC_MULTI_REG_DMA_UNLMT_RES12_10B,
            LL_ADC_MULTI_REG_DMA_UNLMT_RES8_6B,
            LL_ADC_MULTI_TWOSMP_DELAY_1CYCLE,
            LL_ADC_MULTI_TWOSMP_DELAY_2CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_3CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_4CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_5CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_6CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_7CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_8CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_9CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_10CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_11CYCLES,
            LL_ADC_MULTI_TWOSMP_DELAY_12CYCLES,
            LL_ADC_MULTI_MASTER,
            LL_ADC_MULTI_SLAVE,
            LL_ADC_MULTI_MASTER_SLAVE,
            LL_ADC_TEMPERATURE_CALC_ERROR,
            LL_ADC_DELAY_INTERNAL_REGUL_STAB_US,
            LL_ADC_DELAY_VREFINT_STAB_US,
            LL_ADC_DELAY_TEMPSENSOR_STAB_US,
            LL_ADC_DELAY_TEMPSENSOR_BUFFER_STAB_US,
            LL_ADC_DELAY_CALIB_ENABLE_ADC_CYCLES,
        ]
        for (i, value) in values.enumerated() { XCTAssertEqual(value, CL53_Constant(UInt32(i)), "constant \(i)") }
    }
}
