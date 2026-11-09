import CLLReference
import STM32H7RSHAL
import XCTest

private struct LLRTCAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}
private final class LLRTCImage: RTCRegisterIO, IWDGRegisterIO, WWDGRegisterIO, LLCortexRegisterIO {
    var cells: [UInt32]
    var trace: [LLRTCAccess] = []
    var statusReads: UInt32 = 0
    var ticks: UInt32 = 0
    var reads: UInt32 = 0
    let salt: UInt32
    let instance: UInt32
    init(_ seed: UInt32, _ salt: UInt32, _ instance: UInt32) {
        cells = (0..<512).map { seed ^ (UInt32($0) &* 0x9E37_79B9) }
        self.salt = salt
        self.instance = instance
    }
    func readIndex(_ i: Int) -> UInt32 {
        var value = cells[i] ^ (salt &* reads)
        reads &+= 1
        if i == 3 {
            statusReads &+= 1
            value &= ~UInt32(0x60)
            switch instance {
            case 0: value |= 0x60
            case 1:
                if statusReads >= 3 { value |= 0x40 }
                if statusReads >= 6 { value |= 0x20 }
            case 2: break
            case 3: value |= 0x40
            case 4: if ticks >= 1000 { value |= 0x60 }
            case 5: if statusReads >= 10 { value |= 0x60 }
            default: preconditionFailure("Unknown ready mode")
            }
        }
        if i == 224 {
            ticks &+= 1
            value = instance == 5 && ticks % 4 != 0 ? 0 : 0x10000
        }
        trace.append(.init(index: UInt32(i), value: value, kind: 0))
        return value
    }
    func writeIndex(_ i: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(i), value: value, kind: 1))
        cells[i] = value
    }
    func read(_ r: RTCRegister) -> UInt32 { readIndex(Int(r.rawValue / 4)) }
    func write(_ r: RTCRegister, value: UInt32) { writeIndex(Int(r.rawValue / 4), value) }
    func readTamper(_ r: RTCTamperRegister) -> UInt32 { readIndex(64 + Int(r.rawValue / 4)) }
    func writeTamper(_ r: RTCTamperRegister, value: UInt32) { writeIndex(64 + Int(r.rawValue / 4), value) }
    func readBackup(_ i: UInt32) -> UInt32 {
        precondition(i < 32)
        return readIndex(128 + Int(i))
    }
    func writeBackup(_ i: UInt32, value: UInt32) {
        precondition(i < 32)
        writeIndex(128 + Int(i), value)
    }
    func read(_ r: IWDGRegister) -> UInt32 { readIndex(192 + IWDGRegister.allCases.firstIndex(of: r)!) }
    func write(_ r: IWDGRegister, value: UInt32) { writeIndex(192 + IWDGRegister.allCases.firstIndex(of: r)!, value) }
    func read(_ r: WWDGRegister) -> UInt32 { readIndex(208 + WWDGRegister.allCases.firstIndex(of: r)!) }
    func write(_ r: WWDGRegister, value: UInt32) { writeIndex(208 + WWDGRegister.allCases.firstIndex(of: r)!, value) }
    func read(_ r: CortexRegister) -> UInt32 {
        precondition(r == .sysTickControl)
        return readIndex(224)
    }
    func write(_ r: CortexRegister, value: UInt32) { preconditionFailure("Unexpected core write") }
    func read(_ r: LLCoreRegister) -> UInt32 { preconditionFailure("Unexpected core read") }
    func write(_ r: LLCoreRegister, value: UInt32) { preconditionFailure("Unexpected core write") }
    func readPriority(_ r: CortexPriorityRegister) -> UInt8 { preconditionFailure("Unexpected priority read") }
    func writePriority(_ r: CortexPriorityRegister, value: UInt8) { preconditionFailure("Unexpected priority write") }
    func perform(_ i: CortexInstruction) { preconditionFailure("Unexpected core instruction") }

}
private func runLLRTC(_ op: Int, _ io: LLRTCImage, _ args: [UInt32]) -> UInt32 {
    var clock = io
    switch op {
    case 0:
        LL_RTC_SetHourFormat(io, args[0])
        return 0
    case 1:
        let result = LL_RTC_GetHourFormat(io)
        return result
    case 2:
        LL_RTC_SetAlarmOutEvent(io, args[0])
        return 0
    case 3:
        let result = LL_RTC_GetAlarmOutEvent(io)
        return result
    case 4:
        LL_RTC_SetAlarmOutputType(io, args[0])
        return 0
    case 5:
        let result = LL_RTC_GetAlarmOutputType(io)
        return result
    case 6:
        LL_RTC_EnableInitMode(io)
        return 0
    case 7:
        LL_RTC_DisableInitMode(io)
        return 0
    case 8:
        LL_RTC_SetBinaryMode(io, args[0])
        return 0
    case 9:
        let result = LL_RTC_GetBinaryMode(io)
        return result
    case 10:
        LL_RTC_SetBinMixBCDU(io, args[0])
        return 0
    case 11:
        let result = LL_RTC_GetBinMixBCDU(io)
        return result
    case 12:
        LL_RTC_SetOutputPolarity(io, args[0])
        return 0
    case 13:
        let result = LL_RTC_GetOutputPolarity(io)
        return result
    case 14:
        LL_RTC_EnableShadowRegBypass(io)
        return 0
    case 15:
        LL_RTC_DisableShadowRegBypass(io)
        return 0
    case 16:
        let result = LL_RTC_IsShadowRegBypassEnabled(io)
        return result
    case 17:
        LL_RTC_EnableRefClock(io)
        return 0
    case 18:
        LL_RTC_DisableRefClock(io)
        return 0
    case 19:
        LL_RTC_SetAsynchPrescaler(io, args[0])
        return 0
    case 20:
        LL_RTC_SetSynchPrescaler(io, args[0])
        return 0
    case 21:
        let result = LL_RTC_GetAsynchPrescaler(io)
        return result
    case 22:
        let result = LL_RTC_GetSynchPrescaler(io)
        return result
    case 23:
        LL_RTC_EnableWriteProtection(io)
        return 0
    case 24:
        LL_RTC_DisableWriteProtection(io)
        return 0
    case 25:
        LL_RTC_EnableTamperOutput(io)
        return 0
    case 26:
        LL_RTC_DisableTamperOutput(io)
        return 0
    case 27:
        let result = LL_RTC_IsTamperOutputEnabled(io)
        return result
    case 28:
        LL_RTC_EnableAlarmPullUp(io)
        return 0
    case 29:
        LL_RTC_DisableAlarmPullUp(io)
        return 0
    case 30:
        let result = LL_RTC_IsAlarmPullUpEnabled(io)
        return result
    case 31:
        LL_RTC_EnableOutput2(io)
        return 0
    case 32:
        LL_RTC_DisableOutput2(io)
        return 0
    case 33:
        let result = LL_RTC_IsOutput2Enabled(io)
        return result
    case 34:
        LL_RTC_TIME_SetFormat(io, args[0])
        return 0
    case 35:
        let result = LL_RTC_TIME_GetFormat(io)
        return result
    case 36:
        LL_RTC_TIME_SetHour(io, args[0])
        return 0
    case 37:
        let result = LL_RTC_TIME_GetHour(io)
        return result
    case 38:
        LL_RTC_TIME_SetMinute(io, args[0])
        return 0
    case 39:
        let result = LL_RTC_TIME_GetMinute(io)
        return result
    case 40:
        LL_RTC_TIME_SetSecond(io, args[0])
        return 0
    case 41:
        let result = LL_RTC_TIME_GetSecond(io)
        return result
    case 42:
        LL_RTC_TIME_Config(io, args[0], args[1], args[2], args[3])
        return 0
    case 43:
        let result = LL_RTC_TIME_Get(io)
        return result
    case 44:
        LL_RTC_TIME_EnableDayLightStore(io)
        return 0
    case 45:
        LL_RTC_TIME_DisableDayLightStore(io)
        return 0
    case 46:
        let result = LL_RTC_TIME_IsDayLightStoreEnabled(io)
        return result
    case 47:
        LL_RTC_TIME_DecHour(io)
        return 0
    case 48:
        LL_RTC_TIME_IncHour(io)
        return 0
    case 49:
        let result = LL_RTC_TIME_GetSubSecond(io)
        return result
    case 50:
        LL_RTC_TIME_Synchronize(io, args[0], args[1])
        return 0
    case 51:
        LL_RTC_DATE_SetYear(io, args[0])
        return 0
    case 52:
        let result = LL_RTC_DATE_GetYear(io)
        return result
    case 53:
        LL_RTC_DATE_SetWeekDay(io, args[0])
        return 0
    case 54:
        let result = LL_RTC_DATE_GetWeekDay(io)
        return result
    case 55:
        LL_RTC_DATE_SetMonth(io, args[0])
        return 0
    case 56:
        let result = LL_RTC_DATE_GetMonth(io)
        return result
    case 57:
        LL_RTC_DATE_SetDay(io, args[0])
        return 0
    case 58:
        let result = LL_RTC_DATE_GetDay(io)
        return result
    case 59:
        LL_RTC_DATE_Config(io, args[0], args[1], args[2], args[3])
        return 0
    case 60:
        let result = LL_RTC_DATE_Get(io)
        return result
    case 61:
        LL_RTC_ALMA_Enable(io)
        return 0
    case 62:
        LL_RTC_ALMA_Disable(io)
        return 0
    case 63:
        LL_RTC_ALMA_SetMask(io, args[0])
        return 0
    case 64:
        let result = LL_RTC_ALMA_GetMask(io)
        return result
    case 65:
        LL_RTC_ALMA_EnableWeekday(io)
        return 0
    case 66:
        LL_RTC_ALMA_DisableWeekday(io)
        return 0
    case 67:
        LL_RTC_ALMA_SetDay(io, args[0])
        return 0
    case 68:
        let result = LL_RTC_ALMA_GetDay(io)
        return result
    case 69:
        LL_RTC_ALMA_SetWeekDay(io, args[0])
        return 0
    case 70:
        let result = LL_RTC_ALMA_GetWeekDay(io)
        return result
    case 71:
        LL_RTC_ALMA_SetTimeFormat(io, args[0])
        return 0
    case 72:
        let result = LL_RTC_ALMA_GetTimeFormat(io)
        return result
    case 73:
        LL_RTC_ALMA_SetHour(io, args[0])
        return 0
    case 74:
        let result = LL_RTC_ALMA_GetHour(io)
        return result
    case 75:
        LL_RTC_ALMA_SetMinute(io, args[0])
        return 0
    case 76:
        let result = LL_RTC_ALMA_GetMinute(io)
        return result
    case 77:
        LL_RTC_ALMA_SetSecond(io, args[0])
        return 0
    case 78:
        let result = LL_RTC_ALMA_GetSecond(io)
        return result
    case 79:
        LL_RTC_ALMA_ConfigTime(io, args[0], args[1], args[2], args[3])
        return 0
    case 80:
        let result = LL_RTC_ALMA_GetTime(io)
        return result
    case 81:
        LL_RTC_ALMA_SetSubSecondMask(io, args[0])
        return 0
    case 82:
        let result = LL_RTC_ALMA_GetSubSecondMask(io)
        return result
    case 83:
        LL_RTC_ALMA_SetBinAutoClr(io, args[0])
        return 0
    case 84:
        let result = LL_RTC_ALMA_GetBinAutoClr(io)
        return result
    case 85:
        LL_RTC_ALMA_SetSubSecond(io, args[0])
        return 0
    case 86:
        let result = LL_RTC_ALMA_GetSubSecond(io)
        return result
    case 87:
        LL_RTC_ALMB_Enable(io)
        return 0
    case 88:
        LL_RTC_ALMB_Disable(io)
        return 0
    case 89:
        LL_RTC_ALMB_SetMask(io, args[0])
        return 0
    case 90:
        let result = LL_RTC_ALMB_GetMask(io)
        return result
    case 91:
        LL_RTC_ALMB_EnableWeekday(io)
        return 0
    case 92:
        LL_RTC_ALMB_DisableWeekday(io)
        return 0
    case 93:
        LL_RTC_ALMB_SetDay(io, args[0])
        return 0
    case 94:
        let result = LL_RTC_ALMB_GetDay(io)
        return result
    case 95:
        LL_RTC_ALMB_SetWeekDay(io, args[0])
        return 0
    case 96:
        let result = LL_RTC_ALMB_GetWeekDay(io)
        return result
    case 97:
        LL_RTC_ALMB_SetTimeFormat(io, args[0])
        return 0
    case 98:
        let result = LL_RTC_ALMB_GetTimeFormat(io)
        return result
    case 99:
        LL_RTC_ALMB_SetHour(io, args[0])
        return 0
    case 100:
        let result = LL_RTC_ALMB_GetHour(io)
        return result
    case 101:
        LL_RTC_ALMB_SetMinute(io, args[0])
        return 0
    case 102:
        let result = LL_RTC_ALMB_GetMinute(io)
        return result
    case 103:
        LL_RTC_ALMB_SetSecond(io, args[0])
        return 0
    case 104:
        let result = LL_RTC_ALMB_GetSecond(io)
        return result
    case 105:
        LL_RTC_ALMB_ConfigTime(io, args[0], args[1], args[2], args[3])
        return 0
    case 106:
        let result = LL_RTC_ALMB_GetTime(io)
        return result
    case 107:
        LL_RTC_ALMB_SetSubSecondMask(io, args[0])
        return 0
    case 108:
        let result = LL_RTC_ALMB_GetSubSecondMask(io)
        return result
    case 109:
        LL_RTC_ALMB_SetBinAutoClr(io, args[0])
        return 0
    case 110:
        let result = LL_RTC_ALMB_GetBinAutoClr(io)
        return result
    case 111:
        LL_RTC_ALMB_SetSubSecond(io, args[0])
        return 0
    case 112:
        let result = LL_RTC_ALMB_GetSubSecond(io)
        return result
    case 113:
        LL_RTC_TS_EnableInternalEvent(io)
        return 0
    case 114:
        LL_RTC_TS_DisableInternalEvent(io)
        return 0
    case 115:
        LL_RTC_TS_Enable(io)
        return 0
    case 116:
        LL_RTC_TS_Disable(io)
        return 0
    case 117:
        LL_RTC_TS_SetActiveEdge(io, args[0])
        return 0
    case 118:
        let result = LL_RTC_TS_GetActiveEdge(io)
        return result
    case 119:
        let result = LL_RTC_TS_GetTimeFormat(io)
        return result
    case 120:
        let result = LL_RTC_TS_GetHour(io)
        return result
    case 121:
        let result = LL_RTC_TS_GetMinute(io)
        return result
    case 122:
        let result = LL_RTC_TS_GetSecond(io)
        return result
    case 123:
        let result = LL_RTC_TS_GetTime(io)
        return result
    case 124:
        let result = LL_RTC_TS_GetWeekDay(io)
        return result
    case 125:
        let result = LL_RTC_TS_GetMonth(io)
        return result
    case 126:
        let result = LL_RTC_TS_GetDay(io)
        return result
    case 127:
        let result = LL_RTC_TS_GetDate(io)
        return result
    case 128:
        let result = LL_RTC_TS_GetSubSecond(io)
        return result
    case 129:
        LL_RTC_TS_EnableOnTamper(io)
        return 0
    case 130:
        LL_RTC_TS_DisableOnTamper(io)
        return 0
    case 131:
        LL_RTC_TAMPER_Enable(io, args[0])
        return 0
    case 132:
        LL_RTC_TAMPER_Disable(io, args[0])
        return 0
    case 133:
        LL_RTC_TAMPER_EnableMask(io, args[0])
        return 0
    case 134:
        LL_RTC_TAMPER_DisableMask(io, args[0])
        return 0
    case 135:
        LL_RTC_TAMPER_EnableEraseBKP(io, args[0])
        return 0
    case 136:
        LL_RTC_TAMPER_DisableEraseBKP(io, args[0])
        return 0
    case 137:
        LL_RTC_TAMPER_DisablePullUp(io)
        return 0
    case 138:
        LL_RTC_TAMPER_EnablePullUp(io)
        return 0
    case 139:
        LL_RTC_TAMPER_SetPrecharge(io, args[0])
        return 0
    case 140:
        let result = LL_RTC_TAMPER_GetPrecharge(io)
        return result
    case 141:
        LL_RTC_TAMPER_SetFilterCount(io, args[0])
        return 0
    case 142:
        let result = LL_RTC_TAMPER_GetFilterCount(io)
        return result
    case 143:
        LL_RTC_TAMPER_SetSamplingFreq(io, args[0])
        return 0
    case 144:
        let result = LL_RTC_TAMPER_GetSamplingFreq(io)
        return result
    case 145:
        LL_RTC_TAMPER_EnableActiveLevel(io, args[0])
        return 0
    case 146:
        LL_RTC_TAMPER_DisableActiveLevel(io, args[0])
        return 0
    case 147:
        LL_RTC_TAMPER_ITAMP_Enable(io, args[0])
        return 0
    case 148:
        LL_RTC_TAMPER_ITAMP_Disable(io, args[0])
        return 0
    case 149:
        LL_RTC_TAMPER_ITAMP_EnableEraseBKP(io, args[0])
        return 0
    case 150:
        LL_RTC_TAMPER_ITAMP_DisableEraseBKP(io, args[0])
        return 0
    case 151:
        LL_RTC_TAMPER_ATAMP_EnableActiveMode(io, args[0])
        return 0
    case 152:
        LL_RTC_TAMPER_ATAMP_DisableActiveMode(io, args[0])
        return 0
    case 153:
        LL_RTC_TAMPER_ATAMP_EnableFilter(io)
        return 0
    case 154:
        LL_RTC_TAMPER_ATAMP_DisableFilter(io)
        return 0
    case 155:
        LL_RTC_TAMPER_ATAMP_SetOutputChangePeriod(io, args[0])
        return 0
    case 156:
        let result = LL_RTC_TAMPER_ATAMP_GetOutputChangePeriod(io)
        return result
    case 157:
        LL_RTC_TAMPER_ATAMP_SetAsyncPrescaler(io, args[0])
        return 0
    case 158:
        let result = LL_RTC_TAMPER_ATAMP_GetAsyncPrescaler(io)
        return result
    case 159:
        LL_RTC_TAMPER_ATAMP_EnableOutputSharing(io)
        return 0
    case 160:
        LL_RTC_TAMPER_ATAMP_DisableOutputSharing(io)
        return 0
    case 161:
        LL_RTC_TAMPER_ATAMP_SetSharedOuputSelection(io, args[0])
        return 0
    case 162:
        let result = LL_RTC_TAMPER_ATAMP_GetSharedOuputSelection(io)
        return result
    case 163:
        LL_RTC_TAMPER_ATAMP_WriteSeed(io, args[0])
        return 0
    case 164:
        let result = LL_RTC_IsActiveFlag_ATAMP_INITS(io)
        return result
    case 165:
        let result = LL_RTC_IsActiveFlag_ATAMP_SEEDF(io)
        return result
    case 166:
        LL_RTC_WAKEUP_Enable(io)
        return 0
    case 167:
        LL_RTC_WAKEUP_Disable(io)
        return 0
    case 168:
        let result = LL_RTC_WAKEUP_IsEnabled(io)
        return result
    case 169:
        LL_RTC_WAKEUP_SetClock(io, args[0])
        return 0
    case 170:
        let result = LL_RTC_WAKEUP_GetClock(io)
        return result
    case 171:
        LL_RTC_WAKEUP_SetAutoReload(io, args[0])
        return 0
    case 172:
        let result = LL_RTC_WAKEUP_GetAutoReload(io)
        return result
    case 173:
        LL_RTC_BKP_SetRegister(io, args[0], args[1])
        return 0
    case 174:
        let result = LL_RTC_BKP_GetRegister(io, args[0])
        return result
    case 175:
        LL_RTC_CAL_SetOutputFreq(io, args[0])
        return 0
    case 176:
        let result = LL_RTC_CAL_GetOutputFreq(io)
        return result
    case 177:
        LL_RTC_CAL_SetPulse(io, args[0])
        return 0
    case 178:
        let result = LL_RTC_CAL_IsPulseInserted(io)
        return result
    case 179:
        LL_RTC_CAL_SetPeriod(io, args[0])
        return 0
    case 180:
        let result = LL_RTC_CAL_GetPeriod(io)
        return result
    case 181:
        LL_RTC_CAL_SetMinus(io, args[0])
        return 0
    case 182:
        let result = LL_RTC_CAL_GetMinus(io)
        return result
    case 183:
        LL_RTC_CAL_LowPower_Enable(io)
        return 0
    case 184:
        LL_RTC_CAL_LowPower_Disable(io)
        return 0
    case 185:
        let result = LL_RTC_CAL_LowPower_IsEnabled(io)
        return result
    case 186:
        let result = LL_RTC_IsActiveFlag_ITS(io)
        return result
    case 187:
        let result = LL_RTC_IsActiveFlag_RECALP(io)
        return result
    case 188:
        let result = LL_RTC_IsActiveFlag_TSOV(io)
        return result
    case 189:
        let result = LL_RTC_IsActiveFlag_TS(io)
        return result
    case 190:
        let result = LL_RTC_IsActiveFlag_WUT(io)
        return result
    case 191:
        let result = LL_RTC_IsActiveFlag_ALRB(io)
        return result
    case 192:
        let result = LL_RTC_IsActiveFlag_ALRA(io)
        return result
    case 193:
        let result = LL_RTC_IsActiveFlag_SSRU(io)
        return result
    case 194:
        LL_RTC_ClearFlag_ITS(io)
        return 0
    case 195:
        LL_RTC_ClearFlag_TSOV(io)
        return 0
    case 196:
        LL_RTC_ClearFlag_TS(io)
        return 0
    case 197:
        LL_RTC_ClearFlag_WUT(io)
        return 0
    case 198:
        LL_RTC_ClearFlag_ALRB(io)
        return 0
    case 199:
        LL_RTC_ClearFlag_ALRA(io)
        return 0
    case 200:
        LL_RTC_ClearFlag_SSRU(io)
        return 0
    case 201:
        let result = LL_RTC_IsActiveFlag_INIT(io)
        return result
    case 202:
        let result = LL_RTC_IsActiveFlag_RS(io)
        return result
    case 203:
        LL_RTC_ClearFlag_RS(io)
        return 0
    case 204:
        let result = LL_RTC_IsActiveFlag_INITS(io)
        return result
    case 205:
        let result = LL_RTC_IsActiveFlag_SHP(io)
        return result
    case 206:
        let result = LL_RTC_IsActiveFlag_WUTW(io)
        return result
    case 207:
        let result = LL_RTC_IsActiveFlag_ALRAM(io)
        return result
    case 208:
        let result = LL_RTC_IsActiveFlag_SSRUM(io)
        return result
    case 209:
        let result = LL_RTC_IsActiveFlag_ALRBM(io)
        return result
    case 210:
        let result = LL_RTC_IsActiveFlag_WUTM(io)
        return result
    case 211:
        let result = LL_RTC_IsActiveFlag_TSM(io)
        return result
    case 212:
        let result = LL_RTC_IsActiveFlag_TSOVM(io)
        return result
    case 213:
        let result = LL_RTC_IsActiveFlag_ITSM(io)
        return result
    case 214:
        let result = LL_RTC_IsActiveFlag_TAMP1(io)
        return result
    case 215:
        let result = LL_RTC_IsActiveFlag_TAMP2(io)
        return result
    case 216:
        let result = LL_RTC_IsActiveFlag_TAMP3(io)
        return result
    case 217:
        let result = LL_RTC_IsActiveFlag_TAMP4(io)
        return result
    case 218:
        let result = LL_RTC_IsActiveFlag_TAMP5(io)
        return result
    case 219:
        let result = LL_RTC_IsActiveFlag_TAMP6(io)
        return result
    case 220:
        let result = LL_RTC_IsActiveFlag_TAMP7(io)
        return result
    case 221:
        let result = LL_RTC_IsActiveFlag_TAMP8(io)
        return result
    case 222:
        let result = LL_RTC_IsActiveFlag_ITAMP1(io)
        return result
    case 223:
        let result = LL_RTC_IsActiveFlag_ITAMP2(io)
        return result
    case 224:
        let result = LL_RTC_IsActiveFlag_ITAMP3(io)
        return result
    case 225:
        let result = LL_RTC_IsActiveFlag_ITAMP4(io)
        return result
    case 226:
        let result = LL_RTC_IsActiveFlag_ITAMP5(io)
        return result
    case 227:
        let result = LL_RTC_IsActiveFlag_ITAMP6(io)
        return result
    case 228:
        let result = LL_RTC_IsActiveFlag_ITAMP7(io)
        return result
    case 229:
        let result = LL_RTC_IsActiveFlag_ITAMP8(io)
        return result
    case 230:
        let result = LL_RTC_IsActiveFlag_ITAMP9(io)
        return result
    case 231:
        let result = LL_RTC_IsActiveFlag_ITAMP11(io)
        return result
    case 232:
        let result = LL_RTC_IsActiveFlag_ITAMP15(io)
        return result
    case 233:
        let result = LL_RTC_IsActiveFlag_TAMP1M(io)
        return result
    case 234:
        let result = LL_RTC_IsActiveFlag_TAMP2M(io)
        return result
    case 235:
        let result = LL_RTC_IsActiveFlag_TAMP3M(io)
        return result
    case 236:
        let result = LL_RTC_IsActiveFlag_TAMP4M(io)
        return result
    case 237:
        let result = LL_RTC_IsActiveFlag_TAMP5M(io)
        return result
    case 238:
        let result = LL_RTC_IsActiveFlag_TAMP6M(io)
        return result
    case 239:
        let result = LL_RTC_IsActiveFlag_TAMP7M(io)
        return result
    case 240:
        let result = LL_RTC_IsActiveFlag_TAMP8M(io)
        return result
    case 241:
        let result = LL_RTC_IsActiveFlag_ITAMP1M(io)
        return result
    case 242:
        let result = LL_RTC_IsActiveFlag_ITAMP2M(io)
        return result
    case 243:
        let result = LL_RTC_IsActiveFlag_ITAMP3M(io)
        return result
    case 244:
        let result = LL_RTC_IsActiveFlag_ITAMP4M(io)
        return result
    case 245:
        let result = LL_RTC_IsActiveFlag_ITAMP5M(io)
        return result
    case 246:
        let result = LL_RTC_IsActiveFlag_ITAMP6M(io)
        return result
    case 247:
        let result = LL_RTC_IsActiveFlag_ITAMP7M(io)
        return result
    case 248:
        let result = LL_RTC_IsActiveFlag_ITAMP8M(io)
        return result
    case 249:
        let result = LL_RTC_IsActiveFlag_ITAMP9M(io)
        return result
    case 250:
        let result = LL_RTC_IsActiveFlag_ITAMP11M(io)
        return result
    case 251:
        let result = LL_RTC_IsActiveFlag_ITAMP15M(io)
        return result
    case 252:
        LL_RTC_ClearFlag_TAMP1(io)
        return 0
    case 253:
        LL_RTC_ClearFlag_TAMP2(io)
        return 0
    case 254:
        LL_RTC_ClearFlag_TAMP3(io)
        return 0
    case 255:
        LL_RTC_ClearFlag_TAMP4(io)
        return 0
    case 256:
        LL_RTC_ClearFlag_TAMP5(io)
        return 0
    case 257:
        LL_RTC_ClearFlag_TAMP6(io)
        return 0
    case 258:
        LL_RTC_ClearFlag_TAMP7(io)
        return 0
    case 259:
        LL_RTC_ClearFlag_TAMP8(io)
        return 0
    case 260:
        LL_RTC_ClearFlag_ITAMP1(io)
        return 0
    case 261:
        LL_RTC_ClearFlag_ITAMP2(io)
        return 0
    case 262:
        LL_RTC_ClearFlag_ITAMP3(io)
        return 0
    case 263:
        LL_RTC_ClearFlag_ITAMP4(io)
        return 0
    case 264:
        LL_RTC_ClearFlag_ITAMP5(io)
        return 0
    case 265:
        LL_RTC_ClearFlag_ITAMP6(io)
        return 0
    case 266:
        LL_RTC_ClearFlag_ITAMP7(io)
        return 0
    case 267:
        LL_RTC_ClearFlag_ITAMP8(io)
        return 0
    case 268:
        LL_RTC_ClearFlag_ITAMP9(io)
        return 0
    case 269:
        LL_RTC_ClearFlag_ITAMP11(io)
        return 0
    case 270:
        LL_RTC_ClearFlag_ITAMP15(io)
        return 0
    case 271:
        LL_RTC_SetRtcPrivilege(io, args[0])
        return 0
    case 272:
        let result = LL_RTC_GetRtcPrivilege(io)
        return result
    case 273:
        LL_RTC_SetTampPrivilege(io, args[0])
        return 0
    case 274:
        let result = LL_RTC_GetTampPrivilege(io)
        return result
    case 275:
        LL_RTC_SetBackupRegisterPrivilege(io, args[0])
        return 0
    case 276:
        let result = LL_RTC_GetBackupRegisterPrivilege(io)
        return result
    case 277:
        LL_RTC_SetBackupRegProtection(io, args[0], args[1])
        return 0
    case 278:
        let result = LL_RTC_GetBackupRegProtectionStartZone2(io)
        return result
    case 279:
        let result = LL_RTC_GetBackupRegProtectionStartZone3(io)
        return result
    case 280:
        LL_RTC_EnableIT_TS(io)
        return 0
    case 281:
        LL_RTC_DisableIT_TS(io)
        return 0
    case 282:
        LL_RTC_EnableIT_WUT(io)
        return 0
    case 283:
        LL_RTC_DisableIT_WUT(io)
        return 0
    case 284:
        LL_RTC_EnableIT_ALRB(io)
        return 0
    case 285:
        LL_RTC_DisableIT_ALRB(io)
        return 0
    case 286:
        LL_RTC_EnableIT_ALRA(io)
        return 0
    case 287:
        LL_RTC_DisableIT_ALRA(io)
        return 0
    case 288:
        LL_RTC_EnableIT_SSRU(io)
        return 0
    case 289:
        LL_RTC_DisableIT_SSRU(io)
        return 0
    case 290:
        let result = LL_RTC_IsEnabledIT_TS(io)
        return result
    case 291:
        let result = LL_RTC_IsEnabledIT_WUT(io)
        return result
    case 292:
        let result = LL_RTC_IsEnabledIT_ALRB(io)
        return result
    case 293:
        let result = LL_RTC_IsEnabledIT_ALRA(io)
        return result
    case 294:
        let result = LL_RTC_IsEnabledIT_SSRU(io)
        return result
    case 295:
        LL_RTC_EnableIT_TAMP1(io)
        return 0
    case 296:
        LL_RTC_DisableIT_TAMP1(io)
        return 0
    case 297:
        LL_RTC_EnableIT_TAMP2(io)
        return 0
    case 298:
        LL_RTC_DisableIT_TAMP2(io)
        return 0
    case 299:
        LL_RTC_EnableIT_TAMP3(io)
        return 0
    case 300:
        LL_RTC_DisableIT_TAMP3(io)
        return 0
    case 301:
        LL_RTC_EnableIT_TAMP4(io)
        return 0
    case 302:
        LL_RTC_DisableIT_TAMP4(io)
        return 0
    case 303:
        LL_RTC_EnableIT_TAMP5(io)
        return 0
    case 304:
        LL_RTC_DisableIT_TAMP5(io)
        return 0
    case 305:
        LL_RTC_EnableIT_TAMP6(io)
        return 0
    case 306:
        LL_RTC_DisableIT_TAMP6(io)
        return 0
    case 307:
        LL_RTC_EnableIT_TAMP7(io)
        return 0
    case 308:
        LL_RTC_DisableIT_TAMP7(io)
        return 0
    case 309:
        LL_RTC_EnableIT_TAMP8(io)
        return 0
    case 310:
        LL_RTC_DisableIT_TAMP8(io)
        return 0
    case 311:
        LL_RTC_EnableIT_ITAMP1(io)
        return 0
    case 312:
        LL_RTC_DisableIT_ITAMP1(io)
        return 0
    case 313:
        LL_RTC_EnableIT_ITAMP2(io)
        return 0
    case 314:
        LL_RTC_DisableIT_ITAMP2(io)
        return 0
    case 315:
        LL_RTC_EnableIT_ITAMP3(io)
        return 0
    case 316:
        LL_RTC_DisableIT_ITAMP3(io)
        return 0
    case 317:
        LL_RTC_EnableIT_ITAMP4(io)
        return 0
    case 318:
        LL_RTC_DisableIT_ITAMP4(io)
        return 0
    case 319:
        LL_RTC_EnableIT_ITAMP5(io)
        return 0
    case 320:
        LL_RTC_DisableIT_ITAMP5(io)
        return 0
    case 321:
        LL_RTC_EnableIT_ITAMP6(io)
        return 0
    case 322:
        LL_RTC_DisableIT_ITAMP6(io)
        return 0
    case 323:
        LL_RTC_EnableIT_ITAMP7(io)
        return 0
    case 324:
        LL_RTC_DisableIT_ITAMP7(io)
        return 0
    case 325:
        LL_RTC_EnableIT_ITAMP8(io)
        return 0
    case 326:
        LL_RTC_DisableIT_ITAMP8(io)
        return 0
    case 327:
        LL_RTC_EnableIT_ITAMP9(io)
        return 0
    case 328:
        LL_RTC_DisableIT_ITAMP9(io)
        return 0
    case 329:
        LL_RTC_EnableIT_ITAMP11(io)
        return 0
    case 330:
        LL_RTC_DisableIT_ITAMP11(io)
        return 0
    case 331:
        LL_RTC_EnableIT_ITAMP15(io)
        return 0
    case 332:
        LL_RTC_DisableIT_ITAMP15(io)
        return 0
    case 333:
        let result = LL_RTC_IsEnabledIT_TAMP1(io)
        return result
    case 334:
        let result = LL_RTC_IsEnabledIT_TAMP2(io)
        return result
    case 335:
        let result = LL_RTC_IsEnabledIT_TAMP3(io)
        return result
    case 336:
        let result = LL_RTC_IsEnabledIT_TAMP4(io)
        return result
    case 337:
        let result = LL_RTC_IsEnabledIT_TAMP5(io)
        return result
    case 338:
        let result = LL_RTC_IsEnabledIT_TAMP6(io)
        return result
    case 339:
        let result = LL_RTC_IsEnabledIT_TAMP7(io)
        return result
    case 340:
        let result = LL_RTC_IsEnabledIT_TAMP8(io)
        return result
    case 341:
        let result = LL_RTC_IsEnabledIT_ITAMP1(io)
        return result
    case 342:
        let result = LL_RTC_IsEnabledIT_ITAMP2(io)
        return result
    case 343:
        let result = LL_RTC_IsEnabledIT_ITAMP3(io)
        return result
    case 344:
        let result = LL_RTC_IsEnabledIT_ITAMP4(io)
        return result
    case 345:
        let result = LL_RTC_IsEnabledIT_ITAMP5(io)
        return result
    case 346:
        let result = LL_RTC_IsEnabledIT_ITAMP6(io)
        return result
    case 347:
        let result = LL_RTC_IsEnabledIT_ITAMP7(io)
        return result
    case 348:
        let result = LL_RTC_IsEnabledIT_ITAMP8(io)
        return result
    case 349:
        let result = LL_RTC_IsEnabledIT_ITAMP9(io)
        return result
    case 350:
        let result = LL_RTC_IsEnabledIT_ITAMP11(io)
        return result
    case 351:
        let result = LL_RTC_IsEnabledIT_ITAMP15(io)
        return result
    case 352:
        LL_RTC_IncrementMonotonicCounter(io)
        return 0
    case 353:
        let result = LL_RTC_GetMonotonicCounter(io)
        return result
    case 354:
        let result = LL_RTC_DeInit(io, clock: &clock).rawValue
        return result
    case 355:
        var v1 = LL_RTC_InitTypeDef()
        v1.HourFormat = args[0]
        v1.AsynchPrescaler = args[1]
        v1.SynchPrescaler = args[2]
        let result = LL_RTC_Init(io, &v1, clock: &clock).rawValue
        io.cells[384] = UInt32(v1.HourFormat)
        io.cells[385] = UInt32(v1.AsynchPrescaler)
        io.cells[386] = UInt32(v1.SynchPrescaler)
        return result
    case 356:
        var v0 = LL_RTC_InitTypeDef()
        v0.HourFormat = args[0]
        v0.AsynchPrescaler = args[1]
        v0.SynchPrescaler = args[2]
        LL_RTC_StructInit(&v0)
        io.cells[384] = UInt32(v0.HourFormat)
        io.cells[385] = UInt32(v0.AsynchPrescaler)
        io.cells[386] = UInt32(v0.SynchPrescaler)
        return 0
    case 357:
        var v2 = LL_RTC_TimeTypeDef()
        v2.TimeFormat = args[1]
        v2.Hours = UInt8(truncatingIfNeeded: args[2])
        v2.Minutes = UInt8(truncatingIfNeeded: args[3])
        v2.Seconds = UInt8(truncatingIfNeeded: args[4])
        let result = LL_RTC_TIME_Init(io, args[0], &v2, clock: &clock).rawValue
        io.cells[384] = UInt32(v2.TimeFormat)
        io.cells[385] = UInt32(v2.Hours)
        io.cells[386] = UInt32(v2.Minutes)
        io.cells[387] = UInt32(v2.Seconds)
        return result
    case 358:
        var v0 = LL_RTC_TimeTypeDef()
        v0.TimeFormat = args[0]
        v0.Hours = UInt8(truncatingIfNeeded: args[1])
        v0.Minutes = UInt8(truncatingIfNeeded: args[2])
        v0.Seconds = UInt8(truncatingIfNeeded: args[3])
        LL_RTC_TIME_StructInit(&v0)
        io.cells[384] = UInt32(v0.TimeFormat)
        io.cells[385] = UInt32(v0.Hours)
        io.cells[386] = UInt32(v0.Minutes)
        io.cells[387] = UInt32(v0.Seconds)
        return 0
    case 359:
        var v2 = LL_RTC_DateTypeDef()
        v2.WeekDay = UInt8(truncatingIfNeeded: args[1])
        v2.Month = UInt8(truncatingIfNeeded: args[2])
        v2.Day = UInt8(truncatingIfNeeded: args[3])
        v2.Year = UInt8(truncatingIfNeeded: args[4])
        let result = LL_RTC_DATE_Init(io, args[0], &v2, clock: &clock).rawValue
        io.cells[384] = UInt32(v2.WeekDay)
        io.cells[385] = UInt32(v2.Month)
        io.cells[386] = UInt32(v2.Day)
        io.cells[387] = UInt32(v2.Year)
        return result
    case 360:
        var v0 = LL_RTC_DateTypeDef()
        v0.WeekDay = UInt8(truncatingIfNeeded: args[0])
        v0.Month = UInt8(truncatingIfNeeded: args[1])
        v0.Day = UInt8(truncatingIfNeeded: args[2])
        v0.Year = UInt8(truncatingIfNeeded: args[3])
        LL_RTC_DATE_StructInit(&v0)
        io.cells[384] = UInt32(v0.WeekDay)
        io.cells[385] = UInt32(v0.Month)
        io.cells[386] = UInt32(v0.Day)
        io.cells[387] = UInt32(v0.Year)
        return 0
    case 361:
        var v2 = LL_RTC_AlarmTypeDef()
        v2.AlarmTime.TimeFormat = args[1]
        v2.AlarmTime.Hours = UInt8(truncatingIfNeeded: args[2])
        v2.AlarmTime.Minutes = UInt8(truncatingIfNeeded: args[3])
        v2.AlarmTime.Seconds = UInt8(truncatingIfNeeded: args[4])
        v2.AlarmMask = args[5]
        v2.AlarmDateWeekDaySel = args[6]
        v2.AlarmDateWeekDay = UInt8(truncatingIfNeeded: args[7])
        let result = LL_RTC_ALMA_Init(io, args[0], &v2).rawValue
        io.cells[384] = UInt32(v2.AlarmTime.TimeFormat)
        io.cells[385] = UInt32(v2.AlarmTime.Hours)
        io.cells[386] = UInt32(v2.AlarmTime.Minutes)
        io.cells[387] = UInt32(v2.AlarmTime.Seconds)
        io.cells[388] = UInt32(v2.AlarmMask)
        io.cells[389] = UInt32(v2.AlarmDateWeekDaySel)
        io.cells[390] = UInt32(v2.AlarmDateWeekDay)
        return result
    case 362:
        var v2 = LL_RTC_AlarmTypeDef()
        v2.AlarmTime.TimeFormat = args[1]
        v2.AlarmTime.Hours = UInt8(truncatingIfNeeded: args[2])
        v2.AlarmTime.Minutes = UInt8(truncatingIfNeeded: args[3])
        v2.AlarmTime.Seconds = UInt8(truncatingIfNeeded: args[4])
        v2.AlarmMask = args[5]
        v2.AlarmDateWeekDaySel = args[6]
        v2.AlarmDateWeekDay = UInt8(truncatingIfNeeded: args[7])
        let result = LL_RTC_ALMB_Init(io, args[0], &v2).rawValue
        io.cells[384] = UInt32(v2.AlarmTime.TimeFormat)
        io.cells[385] = UInt32(v2.AlarmTime.Hours)
        io.cells[386] = UInt32(v2.AlarmTime.Minutes)
        io.cells[387] = UInt32(v2.AlarmTime.Seconds)
        io.cells[388] = UInt32(v2.AlarmMask)
        io.cells[389] = UInt32(v2.AlarmDateWeekDaySel)
        io.cells[390] = UInt32(v2.AlarmDateWeekDay)
        return result
    case 363:
        var v0 = LL_RTC_AlarmTypeDef()
        v0.AlarmTime.TimeFormat = args[0]
        v0.AlarmTime.Hours = UInt8(truncatingIfNeeded: args[1])
        v0.AlarmTime.Minutes = UInt8(truncatingIfNeeded: args[2])
        v0.AlarmTime.Seconds = UInt8(truncatingIfNeeded: args[3])
        v0.AlarmMask = args[4]
        v0.AlarmDateWeekDaySel = args[5]
        v0.AlarmDateWeekDay = UInt8(truncatingIfNeeded: args[6])
        LL_RTC_ALMA_StructInit(&v0)
        io.cells[384] = UInt32(v0.AlarmTime.TimeFormat)
        io.cells[385] = UInt32(v0.AlarmTime.Hours)
        io.cells[386] = UInt32(v0.AlarmTime.Minutes)
        io.cells[387] = UInt32(v0.AlarmTime.Seconds)
        io.cells[388] = UInt32(v0.AlarmMask)
        io.cells[389] = UInt32(v0.AlarmDateWeekDaySel)
        io.cells[390] = UInt32(v0.AlarmDateWeekDay)
        return 0
    case 364:
        var v0 = LL_RTC_AlarmTypeDef()
        v0.AlarmTime.TimeFormat = args[0]
        v0.AlarmTime.Hours = UInt8(truncatingIfNeeded: args[1])
        v0.AlarmTime.Minutes = UInt8(truncatingIfNeeded: args[2])
        v0.AlarmTime.Seconds = UInt8(truncatingIfNeeded: args[3])
        v0.AlarmMask = args[4]
        v0.AlarmDateWeekDaySel = args[5]
        v0.AlarmDateWeekDay = UInt8(truncatingIfNeeded: args[6])
        LL_RTC_ALMB_StructInit(&v0)
        io.cells[384] = UInt32(v0.AlarmTime.TimeFormat)
        io.cells[385] = UInt32(v0.AlarmTime.Hours)
        io.cells[386] = UInt32(v0.AlarmTime.Minutes)
        io.cells[387] = UInt32(v0.AlarmTime.Seconds)
        io.cells[388] = UInt32(v0.AlarmMask)
        io.cells[389] = UInt32(v0.AlarmDateWeekDaySel)
        io.cells[390] = UInt32(v0.AlarmDateWeekDay)
        return 0
    case 365:
        let result = LL_RTC_EnterInitMode(io, clock: &clock).rawValue
        return result
    case 366:
        let result = LL_RTC_ExitInitMode(io).rawValue
        return result
    case 367:
        let result = LL_RTC_WaitForSynchro(io, clock: &clock).rawValue
        return result
    case 368:
        LL_IWDG_Enable(io)
        return 0
    case 369:
        LL_IWDG_ReloadCounter(io)
        return 0
    case 370:
        LL_IWDG_EnableWriteAccess(io)
        return 0
    case 371:
        LL_IWDG_DisableWriteAccess(io)
        return 0
    case 372:
        LL_IWDG_SetPrescaler(io, args[0])
        return 0
    case 373:
        let result = LL_IWDG_GetPrescaler(io)
        return result
    case 374:
        LL_IWDG_SetReloadCounter(io, args[0])
        return 0
    case 375:
        let result = LL_IWDG_GetReloadCounter(io)
        return result
    case 376:
        LL_IWDG_SetWindow(io, args[0])
        return 0
    case 377:
        let result = LL_IWDG_GetWindow(io)
        return result
    case 378:
        LL_IWDG_SetEwiTime(io, args[0])
        return 0
    case 379:
        let result = LL_IWDG_GetEwiTime(io)
        return result
    case 380:
        LL_IWDG_EnableIT_EWI(io)
        return 0
    case 381:
        LL_IWDG_DisableIT_EWI(io)
        return 0
    case 382:
        let result = LL_IWDG_IsEnabledIT_EWI(io)
        return result
    case 383:
        let result = LL_IWDG_IsActiveFlag_PVU(io)
        return result
    case 384:
        let result = LL_IWDG_IsActiveFlag_RVU(io)
        return result
    case 385:
        let result = LL_IWDG_IsActiveFlag_WVU(io)
        return result
    case 386:
        let result = LL_IWDG_IsActiveFlag_EWU(io)
        return result
    case 387:
        let result = LL_IWDG_IsReady(io)
        return result
    case 388:
        let result = LL_IWDG_IsActiveFlag_ONF(io)
        return result
    case 389:
        let result = LL_IWDG_IsActiveFlag_EWIF(io)
        return result
    case 390:
        LL_IWDG_ClearFlag_EWIF(io)
        return 0
    case 391:
        LL_WWDG_Enable(io)
        return 0
    case 392:
        let result = LL_WWDG_IsEnabled(io)
        return result
    case 393:
        LL_WWDG_SetCounter(io, args[0])
        return 0
    case 394:
        let result = LL_WWDG_GetCounter(io)
        return result
    case 395:
        LL_WWDG_SetPrescaler(io, args[0])
        return 0
    case 396:
        let result = LL_WWDG_GetPrescaler(io)
        return result
    case 397:
        LL_WWDG_SetWindow(io, args[0])
        return 0
    case 398:
        let result = LL_WWDG_GetWindow(io)
        return result
    case 399:
        let result = LL_WWDG_IsActiveFlag_EWKUP(io)
        return result
    case 400:
        LL_WWDG_ClearFlag_EWKUP(io)
        return 0
    case 401:
        LL_WWDG_EnableIT_EWKUP(io)
        return 0
    case 402:
        let result = LL_WWDG_IsEnabledIT_EWKUP(io)
        return result
    case 403:
        LL_RTC_WriteReg(io, RTCRegister.cr, args[0])
        return LL_RTC_ReadReg(io, RTCRegister.cr)
    case 404:
        LL_IWDG_WriteReg(io, IWDGRegister.pr, args[0])
        return LL_IWDG_ReadReg(io, IWDGRegister.pr)
    case 405:
        LL_WWDG_WriteReg(io, WWDGRegister.cfr, args[0])
        return LL_WWDG_ReadReg(io, WWDGRegister.cfr)
    case 406: return UInt32(__LL_RTC_CONVERT_BIN2BCD(args[0]))
    case 407: return UInt32(__LL_RTC_CONVERT_BCD2BIN(args[0]))
    case 408: return UInt32(__LL_RTC_GET_WEEKDAY(args[0]))
    case 409: return UInt32(__LL_RTC_GET_YEAR(args[0]))
    case 410: return UInt32(__LL_RTC_GET_MONTH(args[0]))
    case 411: return UInt32(__LL_RTC_GET_DAY(args[0]))
    case 412: return UInt32(__LL_RTC_GET_HOUR(args[0]))
    case 413: return UInt32(__LL_RTC_GET_MINUTE(args[0]))
    case 414: return UInt32(__LL_RTC_GET_SECOND(args[0]))
    default: preconditionFailure("Unknown operation")
    }
}
final class LLRTCDifferentialTests: XCTestCase {
    @discardableResult private func compare(
        _ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0, instance: UInt32 = 0,
        file: StaticString = #filePath, line: UInt = #line
    ) -> LLRTCImage {
        let c = CL57_Create()!
        defer { CL57_Destroy(c) }
        CL57_Reset(c, seed, salt, instance)
        let io = LLRTCImage(seed, salt, instance)
        let sr = runLLRTC(op, io, args)
        let cr = CL57_Run(c, UInt32(op), args)
        let context = "op=\(op) seed=\(seed) salt=\(salt) instance=\(instance) args=\(args)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL57_GetCells(c), count: 512)
        for i in cells.indices where cells[i] != io.cells[i] {
            XCTFail("\(context) cell \(i): Swift \(io.cells[i]), C \(cells[i])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL57_GetTrace(c), count: Int(CL57_GetTraceCount(c)))
        XCTAssertEqual(
            io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file,
            line: line)
        return io
    }
    func testEveryFunctionWithChangingReadsAndAllInstances() {
        for op in 0..<403 {
            for instance: UInt32 in 0..<1 {
                for sample: UInt32 in 0..<32 {
                    let seed = sample &* 0x9E37_79B9
                    var args = (0..<16).map { seed ^ (UInt32($0) &* 0x1020_4081) }
                    if op == 173 { args[0] = sample % 32 }
                    if op == 174 { args[0] = sample % 32 }
                    compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x1020_4081, instance: instance)
                }
            }
        }
    }
    func testCalendarFormatsMutationAndTimeoutBranches() {
        let values: [UInt32] = [0, 9, 10, 23, 59, 99, 0x99, 0xFF, 0x100, .max]
        for op in [357, 359] {
            for format: UInt32 in [0, 1, 2] {
                for hour: UInt32 in [0, 0x40] {
                    for bypass: UInt32 in [0, 0x20] {
                        for value in values {
                            for mode: UInt32 in 0..<6 {
                                let seed = (UInt32(6) &* 0x9E37_79B9 & ~UInt32(0x60)) | hour | bypass
                                let args: [UInt32] =
                                    op == 357
                                    ? [format, 0x400000, value, value &+ 1, value &+ 2]
                                    : [format, value, value &+ 1, value &+ 2, value &+ 3]
                                compare(op, args, seed: seed, instance: mode)
                            }
                        }
                    }
                }
            }
        }
    }
    func testInitializationAndSynchronizationTimeoutBoundaries() {
        for op in [354, 355, 357, 359, 365, 367] {
            for mode: UInt32 in 0..<6 {
                for seed: UInt32 in [0, 0xA5A5_A5A5, .max] {
                    for salt: UInt32 in [0, 0x1020_4081] {
                        compare(
                            op, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], seed: seed, salt: salt,
                            instance: mode)
                    }
                }
            }
        }
    }
    func testAlarmFormatsWeekdaysMasksAndNestedByteFields() {
        for op in [361, 362] {
            for format: UInt32 in [0, 1] {
                for hour: UInt32 in [0, 0x40] {
                    for select: UInt32 in [0, 0x4000_0000] {
                        for mask: UInt32 in [0, 0x8080_8080, 0x8000_0000, .max] {
                            for value: UInt32 in [0, 1, 7, 23, 59, 99, 255, 256] {
                                let seed = (UInt32(6) &* 0x9E37_79B9 & ~UInt32(0x40)) | hour
                                compare(
                                    op, [format, 0x400000, value, value &+ 1, value &+ 2, mask, select, value &+ 3],
                                    seed: seed, salt: 0x1020_4081)
                            }
                        }
                    }
                }
            }
        }
    }
    func testBackupRegistersUseEverySlot() {
        for op in [173, 174] {
            for index: UInt32 in 0..<32 {
                for sample: UInt32 in 0..<16 {
                    compare(op, [index, sample &* 0x9E37_79B9], seed: sample, salt: 0x1020_4081)
                }
            }
        }
    }
    func testWatchdogKeysMasksAndBoundaryValues() {
        for op in 368..<403 {
            for value: UInt32 in [0, 1, 0x3F, 0x40, 0x7F, 0x80, 0xFF, 0xFFF, 0x1000, 0xAAAA, 0xCCCC, .max] {
                for salt: UInt32 in [0, 0x1020_4081] {
                    compare(op, [value], seed: 0xA5A5_A5A5, salt: salt)
                }
            }
        }
    }
    func testConversionPackedFieldsAndRawMacros() {
        for op in 406..<415 {
            for sample: UInt32 in 0..<512 { compare(op, [sample % 2 == 0 ? sample : 0xF0F0_F000 | sample]) }
        }
        for op in 403..<406 {
            for sample: UInt32 in 0..<32 { compare(op, [sample &* 0x9E37_79B9], seed: ~sample, salt: 0x1020_4081) }
        }
    }
    func testIndependentMutationTimeoutCleanupAndRegisterPacking() {
        let io = LLRTCImage(0, 0, 2)
        var clock = io
        io.cells[6] = 0
        var time = LL_RTC_TimeTypeDef(TimeFormat: 0x400000, Hours: 23, Minutes: 59, Seconds: 58)
        XCTAssertEqual(LL_RTC_TIME_Init(io, LL_RTC_FORMAT_BIN, &time, clock: &clock), .error)
        XCTAssertEqual(time.TimeFormat, 0)
        XCTAssertEqual(io.ticks, 1000)
        XCTAssertEqual(io.cells[9], 0xFF)
        XCTAssertEqual(io.trace.prefix(3).map { $0.index }, [6, 9, 9])
        let dateIO = LLRTCImage(0, 0, 2)
        var dateClock = dateIO
        var date = LL_RTC_DateTypeDef(WeekDay: 3, Month: 0x12, Day: 31, Year: 24)
        XCTAssertEqual(LL_RTC_DATE_Init(dateIO, 0, &date, clock: &dateClock), .error)
        XCTAssertEqual(date.Month, 12)
        XCTAssertEqual(dateIO.ticks, 1000)
        let boundary = LLRTCImage(0, 0, 4)
        var boundaryClock = boundary
        XCTAssertEqual(LL_RTC_EnterInitMode(boundary, clock: &boundaryClock), .error)
        XCTAssertEqual(boundary.ticks, 1000)
        XCTAssertEqual((boundary.trace.last?.value ?? 0) & 0x40, 0x40)
        let cleanup = LLRTCImage(0, 0, 2)
        var cleanupClock = cleanup
        let oldTR = cleanup.cells[0]
        XCTAssertEqual(LL_RTC_DeInit(cleanup, clock: &cleanupClock), .error)
        XCTAssertEqual(cleanup.cells[0], oldTR)
        XCTAssertEqual(cleanup.trace.suffix(10).map { $0.index }, [64, 65, 66, 72, 73, 67, 68, 71, 75, 79])
        XCTAssertEqual(cleanup.cells[68], 0x70000)
        XCTAssertEqual(cleanup.cells[79], .max)
        let direct = LLRTCImage(0, 0, 0)
        direct.cells[0] = 0
        LL_RTC_TIME_Config(direct, 0x400000, 0x23, 0x59, 0x58)
        XCTAssertEqual(direct.cells[0], 0x635958)
        direct.cells[1] = 0
        LL_RTC_DATE_Config(direct, 3, 0x31, 0x12, 0x24)
        XCTAssertEqual(direct.cells[1], 0x247231)
        direct.trace.removeAll()
        LL_IWDG_Enable(direct)
        LL_IWDG_ReloadCounter(direct)
        LL_IWDG_EnableWriteAccess(direct)
        LL_IWDG_DisableWriteAccess(direct)
        XCTAssertEqual(
            direct.trace,
            [
                .init(index: 192, value: 0xCCCC, kind: 1), .init(index: 192, value: 0xAAAA, kind: 1),
                .init(index: 192, value: 0x5555, kind: 1), .init(index: 192, value: 0, kind: 1),
            ])
        direct.trace.removeAll()
        LL_WWDG_ClearFlag_EWKUP(direct)
        XCTAssertEqual(direct.trace, [.init(index: 210, value: 0xFFFF_FFFE, kind: 1)])
        XCTAssertEqual(__LL_RTC_CONVERT_BIN2BCD(256), 0x96)
        for value: UInt32 in 0...99 {
            XCTAssertEqual(UInt32(__LL_RTC_CONVERT_BCD2BIN(UInt32(__LL_RTC_CONVERT_BIN2BCD(value)))), value)
        }
        var config = LL_RTC_InitTypeDef()
        LL_RTC_StructInit(&config)
        XCTAssertEqual(config.AsynchPrescaler, 127)
        XCTAssertEqual(config.SynchPrescaler, 255)
    }
    func testPinnedConstants() {
        let constants: [UInt32] = [
            LL_RTC_FORMAT_BIN,
            LL_RTC_FORMAT_BCD,
            LL_RTC_ALMA_DATEWEEKDAYSEL_DATE,
            LL_RTC_ALMA_DATEWEEKDAYSEL_WEEKDAY,
            LL_RTC_ALMB_DATEWEEKDAYSEL_DATE,
            LL_RTC_ALMB_DATEWEEKDAYSEL_WEEKDAY,
            LL_RTC_SCR_SSRUF,
            LL_RTC_SCR_ITSF,
            LL_RTC_SCR_TSOVF,
            LL_RTC_SCR_TSF,
            LL_RTC_SCR_WUTF,
            LL_RTC_SCR_ALRBF,
            LL_RTC_SCR_ALRAF,
            LL_RTC_ICSR_RECALPF,
            LL_RTC_ICSR_BCDU_2,
            LL_RTC_ICSR_BCDU_1,
            LL_RTC_ICSR_BCDU_0,
            LL_RTC_ICSR_BIN_1,
            LL_RTC_ICSR_BIN_0,
            LL_RTC_ICSR_INITF,
            LL_RTC_ICSR_RSF,
            LL_RTC_ICSR_INITS,
            LL_RTC_ICSR_SHPF,
            LL_RTC_ICSR_WUTWF,
            LL_RTC_CR_TSIE,
            LL_RTC_CR_WUTIE,
            LL_RTC_CR_ALRBIE,
            LL_RTC_CR_ALRAIE,
            LL_RTC_WEEKDAY_MONDAY,
            LL_RTC_WEEKDAY_TUESDAY,
            LL_RTC_WEEKDAY_WEDNESDAY,
            LL_RTC_WEEKDAY_THURSDAY,
            LL_RTC_WEEKDAY_FRIDAY,
            LL_RTC_WEEKDAY_SATURDAY,
            LL_RTC_WEEKDAY_SUNDAY,
            LL_RTC_MONTH_JANUARY,
            LL_RTC_MONTH_FEBRUARY,
            LL_RTC_MONTH_MARCH,
            LL_RTC_MONTH_APRIL,
            LL_RTC_MONTH_MAY,
            LL_RTC_MONTH_JUNE,
            LL_RTC_MONTH_JULY,
            LL_RTC_MONTH_AUGUST,
            LL_RTC_MONTH_SEPTEMBER,
            LL_RTC_MONTH_OCTOBER,
            LL_RTC_MONTH_NOVEMBER,
            LL_RTC_MONTH_DECEMBER,
            LL_RTC_HOURFORMAT_24HOUR,
            LL_RTC_HOURFORMAT_AMPM,
            LL_RTC_ALARMOUT_DISABLE,
            LL_RTC_ALARMOUT_ALMA,
            LL_RTC_ALARMOUT_ALMB,
            LL_RTC_ALARMOUT_WAKEUP,
            LL_RTC_ALARM_OUTPUTTYPE_PUSHPULL,
            LL_RTC_ALARM_OUTPUTTYPE_OPENDRAIN,
            LL_RTC_OUTPUTPOLARITY_PIN_HIGH,
            LL_RTC_OUTPUTPOLARITY_PIN_LOW,
            LL_RTC_TIME_FORMAT_AM_OR_24,
            LL_RTC_TIME_FORMAT_PM,
            LL_RTC_SHIFT_SECOND_DELAY,
            LL_RTC_SHIFT_SECOND_ADVANCE,
            LL_RTC_ALMA_MASK_NONE,
            LL_RTC_ALMA_MASK_DATEWEEKDAY,
            LL_RTC_ALMA_MASK_HOURS,
            LL_RTC_ALMA_MASK_MINUTES,
            LL_RTC_ALMA_MASK_SECONDS,
            LL_RTC_ALMA_MASK_ALL,
            LL_RTC_ALMA_TIME_FORMAT_AM,
            LL_RTC_ALMA_TIME_FORMAT_PM,
            LL_RTC_ALMA_SUBSECONDBIN_AUTOCLR_NO,
            LL_RTC_ALMA_SUBSECONDBIN_AUTOCLR_YES,
            LL_RTC_ALMB_MASK_NONE,
            LL_RTC_ALMB_MASK_DATEWEEKDAY,
            LL_RTC_ALMB_MASK_HOURS,
            LL_RTC_ALMB_MASK_MINUTES,
            LL_RTC_ALMB_MASK_SECONDS,
            LL_RTC_ALMB_MASK_ALL,
            LL_RTC_ALMB_TIME_FORMAT_AM,
            LL_RTC_ALMB_TIME_FORMAT_PM,
            LL_RTC_ALMB_SUBSECONDBIN_AUTOCLR_NO,
            LL_RTC_ALMB_SUBSECONDBIN_AUTOCLR_YES,
            LL_RTC_TIMESTAMP_EDGE_RISING,
            LL_RTC_TIMESTAMP_EDGE_FALLING,
            LL_RTC_TS_TIME_FORMAT_AM,
            LL_RTC_TS_TIME_FORMAT_PM,
            LL_RTC_TAMPER_1,
            LL_RTC_TAMPER_2,
            LL_RTC_TAMPER_3,
            LL_RTC_TAMPER_4,
            LL_RTC_TAMPER_5,
            LL_RTC_TAMPER_6,
            LL_RTC_TAMPER_7,
            LL_RTC_TAMPER_8,
            LL_RTC_TAMPER_MASK_TAMPER1,
            LL_RTC_TAMPER_MASK_TAMPER2,
            LL_RTC_TAMPER_MASK_TAMPER3,
            LL_RTC_TAMPER_NOERASE_TAMPER1,
            LL_RTC_TAMPER_NOERASE_TAMPER2,
            LL_RTC_TAMPER_NOERASE_TAMPER3,
            LL_RTC_TAMPER_NOERASE_TAMPER4,
            LL_RTC_TAMPER_NOERASE_TAMPER5,
            LL_RTC_TAMPER_NOERASE_TAMPER6,
            LL_RTC_TAMPER_NOERASE_TAMPER7,
            LL_RTC_TAMPER_NOERASE_TAMPER8,
            LL_RTC_TAMPER_DURATION_1RTCCLK,
            LL_RTC_TAMPER_DURATION_2RTCCLK,
            LL_RTC_TAMPER_DURATION_4RTCCLK,
            LL_RTC_TAMPER_DURATION_8RTCCLK,
            LL_RTC_TAMPER_FILTER_DISABLE,
            LL_RTC_TAMPER_FILTER_2SAMPLE,
            LL_RTC_TAMPER_FILTER_4SAMPLE,
            LL_RTC_TAMPER_FILTER_8SAMPLE,
            LL_RTC_TAMPER_SAMPLFREQDIV_32768,
            LL_RTC_TAMPER_SAMPLFREQDIV_16384,
            LL_RTC_TAMPER_SAMPLFREQDIV_8192,
            LL_RTC_TAMPER_SAMPLFREQDIV_4096,
            LL_RTC_TAMPER_SAMPLFREQDIV_2048,
            LL_RTC_TAMPER_SAMPLFREQDIV_1024,
            LL_RTC_TAMPER_SAMPLFREQDIV_512,
            LL_RTC_TAMPER_SAMPLFREQDIV_256,
            LL_RTC_TAMPER_ACTIVELEVEL_TAMP1,
            LL_RTC_TAMPER_ACTIVELEVEL_TAMP2,
            LL_RTC_TAMPER_ACTIVELEVEL_TAMP3,
            LL_RTC_TAMPER_ACTIVELEVEL_TAMP4,
            LL_RTC_TAMPER_ACTIVELEVEL_TAMP5,
            LL_RTC_TAMPER_ACTIVELEVEL_TAMP6,
            LL_RTC_TAMPER_ACTIVELEVEL_TAMP7,
            LL_RTC_TAMPER_ACTIVELEVEL_TAMP8,
            LL_RTC_TAMPER_ITAMP1,
            LL_RTC_TAMPER_ITAMP2,
            LL_RTC_TAMPER_ITAMP3,
            LL_RTC_TAMPER_ITAMP4,
            LL_RTC_TAMPER_ITAMP5,
            LL_RTC_TAMPER_ITAMP6,
            LL_RTC_TAMPER_ITAMP7,
            LL_RTC_TAMPER_ITAMP8,
            LL_RTC_TAMPER_ITAMP9,
            LL_RTC_TAMPER_ITAMP11,
            LL_RTC_TAMPER_ITAMP15,
            LL_RTC_TAMPER_NOERASE_ITAMPER1,
            LL_RTC_TAMPER_NOERASE_ITAMPER2,
            LL_RTC_TAMPER_NOERASE_ITAMPER3,
            LL_RTC_TAMPER_NOERASE_ITAMPER4,
            LL_RTC_TAMPER_NOERASE_ITAMPER5,
            LL_RTC_TAMPER_NOERASE_ITAMPER6,
            LL_RTC_TAMPER_NOERASE_ITAMPER7,
            LL_RTC_TAMPER_NOERASE_ITAMPER8,
            LL_RTC_TAMPER_NOERASE_ITAMPER9,
            LL_RTC_TAMPER_NOERASE_ITAMPER11,
            LL_RTC_TAMPER_NOERASE_ITAMPER15,
            LL_RTC_TAMPER_ATAMP_TAMP1AM,
            LL_RTC_TAMPER_ATAMP_TAMP2AM,
            LL_RTC_TAMPER_ATAMP_TAMP3AM,
            LL_RTC_TAMPER_ATAMP_TAMP4AM,
            LL_RTC_TAMPER_ATAMP_TAMP5AM,
            LL_RTC_TAMPER_ATAMP_TAMP6AM,
            LL_RTC_TAMPER_ATAMP_TAMP7AM,
            LL_RTC_TAMPER_ATAMP_TAMP8AM,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_2,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_4,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_8,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_16,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_32,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_64,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_128,
            LL_RTC_TAMPER_ATAMP_ASYNCPRES_RTCCLK_2048,
            LL_RTC_TAMPER_ATAMP1IN_ATAMP1OUT,
            LL_RTC_TAMPER_ATAMP1IN_ATAMP2OUT,
            LL_RTC_TAMPER_ATAMP1IN_ATAMP3OUT,
            LL_RTC_TAMPER_ATAMP1IN_ATAMP4OUT,
            LL_RTC_TAMPER_ATAMP1IN_ATAMP5OUT,
            LL_RTC_TAMPER_ATAMP1IN_ATAMP6OUT,
            LL_RTC_TAMPER_ATAMP1IN_ATAMP7OUT,
            LL_RTC_TAMPER_ATAMP1IN_ATAMP8OUT,
            LL_RTC_TAMPER_ATAMP2IN_ATAMP1OUT,
            LL_RTC_TAMPER_ATAMP2IN_ATAMP2OUT,
            LL_RTC_TAMPER_ATAMP2IN_ATAMP3OUT,
            LL_RTC_TAMPER_ATAMP2IN_ATAMP4OUT,
            LL_RTC_TAMPER_ATAMP2IN_ATAMP5OUT,
            LL_RTC_TAMPER_ATAMP2IN_ATAMP6OUT,
            LL_RTC_TAMPER_ATAMP2IN_ATAMP7OUT,
            LL_RTC_TAMPER_ATAMP2IN_ATAMP8OUT,
            LL_RTC_TAMPER_ATAMP3IN_ATAMP1OUT,
            LL_RTC_TAMPER_ATAMP3IN_ATAMP2OUT,
            LL_RTC_TAMPER_ATAMP3IN_ATAMP3OUT,
            LL_RTC_TAMPER_ATAMP3IN_ATAMP4OUT,
            LL_RTC_TAMPER_ATAMP3IN_ATAMP5OUT,
            LL_RTC_TAMPER_ATAMP3IN_ATAMP6OUT,
            LL_RTC_TAMPER_ATAMP3IN_ATAMP7OUT,
            LL_RTC_TAMPER_ATAMP3IN_ATAMP8OUT,
            LL_RTC_TAMPER_ATAMP4IN_ATAMP1OUT,
            LL_RTC_TAMPER_ATAMP4IN_ATAMP2OUT,
            LL_RTC_TAMPER_ATAMP4IN_ATAMP3OUT,
            LL_RTC_TAMPER_ATAMP4IN_ATAMP4OUT,
            LL_RTC_TAMPER_ATAMP4IN_ATAMP5OUT,
            LL_RTC_TAMPER_ATAMP4IN_ATAMP6OUT,
            LL_RTC_TAMPER_ATAMP4IN_ATAMP7OUT,
            LL_RTC_TAMPER_ATAMP4IN_ATAMP8OUT,
            LL_RTC_TAMPER_ATAMP5IN_ATAMP1OUT,
            LL_RTC_TAMPER_ATAMP5IN_ATAMP2OUT,
            LL_RTC_TAMPER_ATAMP5IN_ATAMP3OUT,
            LL_RTC_TAMPER_ATAMP5IN_ATAMP4OUT,
            LL_RTC_TAMPER_ATAMP5IN_ATAMP5OUT,
            LL_RTC_TAMPER_ATAMP5IN_ATAMP6OUT,
            LL_RTC_TAMPER_ATAMP5IN_ATAMP7OUT,
            LL_RTC_TAMPER_ATAMP5IN_ATAMP8OUT,
            LL_RTC_TAMPER_ATAMP6IN_ATAMP1OUT,
            LL_RTC_TAMPER_ATAMP6IN_ATAMP2OUT,
            LL_RTC_TAMPER_ATAMP6IN_ATAMP3OUT,
            LL_RTC_TAMPER_ATAMP6IN_ATAMP4OUT,
            LL_RTC_TAMPER_ATAMP6IN_ATAMP5OUT,
            LL_RTC_TAMPER_ATAMP6IN_ATAMP6OUT,
            LL_RTC_TAMPER_ATAMP6IN_ATAMP7OUT,
            LL_RTC_TAMPER_ATAMP6IN_ATAMP8OUT,
            LL_RTC_TAMPER_ATAMP7IN_ATAMP1OUT,
            LL_RTC_TAMPER_ATAMP7IN_ATAMP2OUT,
            LL_RTC_TAMPER_ATAMP7IN_ATAMP3OUT,
            LL_RTC_TAMPER_ATAMP7IN_ATAMP4OUT,
            LL_RTC_TAMPER_ATAMP7IN_ATAMP5OUT,
            LL_RTC_TAMPER_ATAMP7IN_ATAMP6OUT,
            LL_RTC_TAMPER_ATAMP7IN_ATAMP7OUT,
            LL_RTC_TAMPER_ATAMP7IN_ATAMP8OUT,
            LL_RTC_TAMPER_ATAMP8IN_ATAMP1OUT,
            LL_RTC_TAMPER_ATAMP8IN_ATAMP2OUT,
            LL_RTC_TAMPER_ATAMP8IN_ATAMP3OUT,
            LL_RTC_TAMPER_ATAMP8IN_ATAMP4OUT,
            LL_RTC_TAMPER_ATAMP8IN_ATAMP5OUT,
            LL_RTC_TAMPER_ATAMP8IN_ATAMP6OUT,
            LL_RTC_TAMPER_ATAMP8IN_ATAMP7OUT,
            LL_RTC_TAMPER_ATAMP8IN_ATAMP8OUT,
            LL_RTC_BKP_DR0,
            LL_RTC_BKP_DR1,
            LL_RTC_BKP_DR2,
            LL_RTC_BKP_DR3,
            LL_RTC_BKP_DR4,
            LL_RTC_BKP_DR5,
            LL_RTC_BKP_DR6,
            LL_RTC_BKP_DR7,
            LL_RTC_BKP_DR8,
            LL_RTC_BKP_DR9,
            LL_RTC_BKP_DR10,
            LL_RTC_BKP_DR11,
            LL_RTC_BKP_DR12,
            LL_RTC_BKP_DR13,
            LL_RTC_BKP_DR14,
            LL_RTC_BKP_DR15,
            LL_RTC_BKP_DR16,
            LL_RTC_BKP_DR17,
            LL_RTC_BKP_DR18,
            LL_RTC_BKP_DR19,
            LL_RTC_BKP_DR20,
            LL_RTC_BKP_DR21,
            LL_RTC_BKP_DR22,
            LL_RTC_BKP_DR23,
            LL_RTC_BKP_DR24,
            LL_RTC_BKP_DR25,
            LL_RTC_BKP_DR26,
            LL_RTC_BKP_DR27,
            LL_RTC_BKP_DR28,
            LL_RTC_BKP_DR29,
            LL_RTC_BKP_DR30,
            LL_RTC_BKP_DR31,
            LL_RTC_WAKEUPCLOCK_DIV_16,
            LL_RTC_WAKEUPCLOCK_DIV_8,
            LL_RTC_WAKEUPCLOCK_DIV_4,
            LL_RTC_WAKEUPCLOCK_DIV_2,
            LL_RTC_WAKEUPCLOCK_CKSPRE,
            LL_RTC_WAKEUPCLOCK_CKSPRE_WUT,
            LL_RTC_CALIB_OUTPUT_NONE,
            LL_RTC_CALIB_OUTPUT_1HZ,
            LL_RTC_CALIB_OUTPUT_512HZ,
            LL_RTC_CALIB_INSERTPULSE_NONE,
            LL_RTC_CALIB_INSERTPULSE_SET,
            LL_RTC_CALIB_PERIOD_32SEC,
            LL_RTC_CALIB_PERIOD_16SEC,
            LL_RTC_CALIB_PERIOD_8SEC,
            LL_RTC_CALIB_LOWPOWER_NONE,
            LL_RTC_CALIB_LOWPOWER_SET,
            LL_RTC_BINARY_NONE,
            LL_RTC_BINARY_ONLY,
            LL_RTC_BINARY_MIX,
            LL_RTC_BINARY_MIX_BCDU_0,
            LL_RTC_BINARY_MIX_BCDU_1,
            LL_RTC_BINARY_MIX_BCDU_2,
            LL_RTC_BINARY_MIX_BCDU_3,
            LL_RTC_BINARY_MIX_BCDU_4,
            LL_RTC_BINARY_MIX_BCDU_5,
            LL_RTC_BINARY_MIX_BCDU_6,
            LL_RTC_BINARY_MIX_BCDU_7,
            LL_RTC_PRIVILEGE_FULL_YES,
            LL_RTC_PRIVILEGE_FULL_NO,
            LL_RTC_PRIVILEGE_FEATURE_INIT,
            LL_RTC_PRIVILEGE_FEATURE_CAL,
            LL_RTC_PRIVILEGE_FEATURE_TS,
            LL_RTC_PRIVILEGE_FEATURE_WUT,
            LL_RTC_PRIVILEGE_FEATURE_ALRA,
            LL_RTC_PRIVILEGE_FEATURE_ALRB,
            LL_TAMP_PRIVILEGE_FULL_YES,
            LL_TAMP_PRIVILEGE_FULL_NO,
            LL_RTC_PRIVILEGE_BKUP_ZONE_NONE,
            LL_RTC_PRIVILEGE_BKUP_ZONE_1,
            LL_RTC_PRIVILEGE_BKUP_ZONE_2,
            LL_RTC_PRIVILEGE_BKUP_ZONE_ALL,
            LL_IWDG_KEY_RELOAD,
            LL_IWDG_KEY_ENABLE,
            LL_IWDG_KEY_WR_ACCESS_ENABLE,
            LL_IWDG_KEY_WR_ACCESS_DISABLE,
            LL_IWDG_SR_PVU,
            LL_IWDG_SR_RVU,
            LL_IWDG_SR_WVU,
            LL_IWDG_PRESCALER_4,
            LL_IWDG_PRESCALER_8,
            LL_IWDG_PRESCALER_16,
            LL_IWDG_PRESCALER_32,
            LL_IWDG_PRESCALER_64,
            LL_IWDG_PRESCALER_128,
            LL_IWDG_PRESCALER_256,
            LL_IWDG_PRESCALER_512,
            LL_IWDG_PRESCALER_1024,
            LL_WWDG_CFR_EWI,
            LL_WWDG_PRESCALER_1,
            LL_WWDG_PRESCALER_2,
            LL_WWDG_PRESCALER_4,
            LL_WWDG_PRESCALER_8,
            LL_WWDG_PRESCALER_16,
            LL_WWDG_PRESCALER_32,
            LL_WWDG_PRESCALER_64,
            LL_WWDG_PRESCALER_128,
        ]
        for (i, value) in constants.enumerated() { XCTAssertEqual(value, CL57_Constant(UInt32(i))) }
    }
}
