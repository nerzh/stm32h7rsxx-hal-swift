import XCTest
import STM32H7RSHAL
import CLLReference

private struct LLTimerAccess: Equatable { var index: UInt32; var value: UInt32; var kind: UInt32 }
private final class LLTimerImage {
    var cells: [UInt32]
    var trace: [LLTimerAccess] = []
    var reads: UInt32 = 0
    let salt: UInt32
    let instanceID: UInt32
    init(seed: UInt32, salt: UInt32, instance: UInt32) {
        cells = (0..<6144).map { seed ^ (UInt32($0) &* 0x9E3779B9) }
        self.salt = salt; self.instanceID = instance
    }
    func read(_ index: Int) -> UInt32 {
        let value = cells[index] ^ (salt &* reads); reads &+= 1
        trace.append(.init(index: UInt32(index), value: value, kind: 0)); return value
    }
    func write(_ index: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(index), value: value, kind: 1)); cells[index] = value
    }
}
private struct LLTIMImage: TIMRegisterIO, LLBusRegisterIO {
    let image: LLTimerImage
    var instance: TIMInstance {
        let instances: [TIMInstance] = [.tim1,.tim2,.tim3,.tim4,.tim5,.tim6,.tim7,.tim9,.tim12,.tim13,.tim14,.tim15,.tim16,.tim17]
        return image.instanceID < 14 ? instances[Int(image.instanceID)] : .tim1
    }
    func read(_ register: TIMRegister) -> UInt32 { image.read(Int(image.instanceID) * 256 + Int(register.rawValue / 4)) }
    func write(_ register: TIMRegister, value: UInt32) { image.write(Int(image.instanceID) * 256 + Int(register.rawValue / 4), value) }
    func address(of register: TIMRegister) -> UInt32 { instance.rawValue + register.rawValue }
    func read(_ register: LLBusRegister) -> UInt32 { image.read(4096 + Int(register.rawValue / 4)) }
    func write(_ register: LLBusRegister, value: UInt32) { image.write(4096 + Int(register.rawValue / 4), value) }
}
private struct LLLPTIMImage: LPTIMRegisterIO, LLBusRegisterIO {
    let image: LLTimerImage
    var instance: LPTIMInstance { LPTIMInstance(rawValue: image.instanceID + 1) ?? .lptim1 }
    func read(_ register: LPTIMRegister) -> UInt32 { image.read(3584 + Int(image.instanceID) * 16 + Int(register.rawValue / 4)) }
    func write(_ register: LPTIMRegister, value: UInt32) { image.write(3584 + Int(image.instanceID) * 16 + Int(register.rawValue / 4), value) }
    func address(of register: LPTIMRegister) -> UInt32 { instance.baseAddress + register.rawValue }
    func readWakeupInterruptMask() -> UInt32 { preconditionFailure("Not used by LL") }
    func writeWakeupInterruptMask(_ value: UInt32) { preconditionFailure("Not used by LL") }
    func read(_ register: LLBusRegister) -> UInt32 { image.read(4096 + Int(register.rawValue / 4)) }
    func write(_ register: LLBusRegister, value: UInt32) { image.write(4096 + Int(register.rawValue / 4), value) }
}
private func runLLTimer(_ op: Int, _ io: LLTimerImage, _ args: [UInt32]) -> UInt32 {
    var tim = LLTIMImage(image: io), lptim = LLLPTIMImage(image: io)
    switch op {
    case 0:
        LL_TIM_EnableCounter(&tim)
        return 0
    case 1:
        LL_TIM_DisableCounter(&tim)
        return 0
    case 2:
        let result = LL_TIM_IsEnabledCounter(&tim)
        return result
    case 3:
        LL_TIM_EnableUpdateEvent(&tim)
        return 0
    case 4:
        LL_TIM_DisableUpdateEvent(&tim)
        return 0
    case 5:
        let result = LL_TIM_IsEnabledUpdateEvent(&tim)
        return result
    case 6:
        LL_TIM_SetUpdateSource(&tim, args[0])
        return 0
    case 7:
        let result = LL_TIM_GetUpdateSource(&tim)
        return result
    case 8:
        LL_TIM_SetOnePulseMode(&tim, args[0])
        return 0
    case 9:
        let result = LL_TIM_GetOnePulseMode(&tim)
        return result
    case 10:
        LL_TIM_SetCounterMode(&tim, args[0])
        return 0
    case 11:
        let result = LL_TIM_GetCounterMode(&tim)
        return result
    case 12:
        LL_TIM_EnableARRPreload(&tim)
        return 0
    case 13:
        LL_TIM_DisableARRPreload(&tim)
        return 0
    case 14:
        let result = LL_TIM_IsEnabledARRPreload(&tim)
        return result
    case 15:
        LL_TIM_SetClockDivision(&tim, args[0])
        return 0
    case 16:
        let result = LL_TIM_GetClockDivision(&tim)
        return result
    case 17:
        LL_TIM_SetCounter(&tim, args[0])
        return 0
    case 18:
        let result = LL_TIM_GetCounter(&tim)
        return result
    case 19:
        let result = LL_TIM_GetDirection(&tim)
        return result
    case 20:
        LL_TIM_SetPrescaler(&tim, args[0])
        return 0
    case 21:
        let result = LL_TIM_GetPrescaler(&tim)
        return result
    case 22:
        LL_TIM_SetAutoReload(&tim, args[0])
        return 0
    case 23:
        let result = LL_TIM_GetAutoReload(&tim)
        return result
    case 24:
        LL_TIM_SetRepetitionCounter(&tim, args[0])
        return 0
    case 25:
        let result = LL_TIM_GetRepetitionCounter(&tim)
        return result
    case 26:
        LL_TIM_EnableUIFRemap(&tim)
        return 0
    case 27:
        LL_TIM_DisableUIFRemap(&tim)
        return 0
    case 28:
        let result = LL_TIM_IsActiveUIFCPY(args[0])
        return result
    case 29:
        LL_TIM_EnableDithering(&tim)
        return 0
    case 30:
        LL_TIM_DisableDithering(&tim)
        return 0
    case 31:
        let result = LL_TIM_IsEnabledDithering(&tim)
        return result
    case 32:
        LL_TIM_CC_EnablePreload(&tim)
        return 0
    case 33:
        LL_TIM_CC_DisablePreload(&tim)
        return 0
    case 34:
        let result = LL_TIM_CC_IsEnabledPreload(&tim)
        return result
    case 35:
        LL_TIM_CC_SetUpdate(&tim, args[0])
        return 0
    case 36:
        LL_TIM_CC_SetDMAReqTrigger(&tim, args[0])
        return 0
    case 37:
        let result = LL_TIM_CC_GetDMAReqTrigger(&tim)
        return result
    case 38:
        LL_TIM_CC_SetLockLevel(&tim, args[0])
        return 0
    case 39:
        LL_TIM_CC_EnableChannel(&tim, args[0])
        return 0
    case 40:
        LL_TIM_CC_DisableChannel(&tim, args[0])
        return 0
    case 41:
        let result = LL_TIM_CC_IsEnabledChannel(&tim, args[0])
        return result
    case 42:
        LL_TIM_OC_ConfigOutput(&tim, args[0], args[1])
        return 0
    case 43:
        LL_TIM_OC_SetMode(&tim, args[0], args[1])
        return 0
    case 44:
        let result = LL_TIM_OC_GetMode(&tim, args[0])
        return result
    case 45:
        LL_TIM_OC_SetPolarity(&tim, args[0], args[1])
        return 0
    case 46:
        let result = LL_TIM_OC_GetPolarity(&tim, args[0])
        return result
    case 47:
        LL_TIM_OC_SetIdleState(&tim, args[0], args[1])
        return 0
    case 48:
        let result = LL_TIM_OC_GetIdleState(&tim, args[0])
        return result
    case 49:
        LL_TIM_OC_EnableFast(&tim, args[0])
        return 0
    case 50:
        LL_TIM_OC_DisableFast(&tim, args[0])
        return 0
    case 51:
        let result = LL_TIM_OC_IsEnabledFast(&tim, args[0])
        return result
    case 52:
        LL_TIM_OC_EnablePreload(&tim, args[0])
        return 0
    case 53:
        LL_TIM_OC_DisablePreload(&tim, args[0])
        return 0
    case 54:
        let result = LL_TIM_OC_IsEnabledPreload(&tim, args[0])
        return result
    case 55:
        LL_TIM_OC_EnableClear(&tim, args[0])
        return 0
    case 56:
        LL_TIM_OC_DisableClear(&tim, args[0])
        return 0
    case 57:
        let result = LL_TIM_OC_IsEnabledClear(&tim, args[0])
        return result
    case 58:
        LL_TIM_OC_SetDeadTime(&tim, args[0])
        return 0
    case 59:
        LL_TIM_OC_SetCompareCH1(&tim, args[0])
        return 0
    case 60:
        LL_TIM_OC_SetCompareCH2(&tim, args[0])
        return 0
    case 61:
        LL_TIM_OC_SetCompareCH3(&tim, args[0])
        return 0
    case 62:
        LL_TIM_OC_SetCompareCH4(&tim, args[0])
        return 0
    case 63:
        LL_TIM_OC_SetCompareCH5(&tim, args[0])
        return 0
    case 64:
        LL_TIM_OC_SetCompareCH6(&tim, args[0])
        return 0
    case 65:
        let result = LL_TIM_OC_GetCompareCH1(&tim)
        return result
    case 66:
        let result = LL_TIM_OC_GetCompareCH2(&tim)
        return result
    case 67:
        let result = LL_TIM_OC_GetCompareCH3(&tim)
        return result
    case 68:
        let result = LL_TIM_OC_GetCompareCH4(&tim)
        return result
    case 69:
        let result = LL_TIM_OC_GetCompareCH5(&tim)
        return result
    case 70:
        let result = LL_TIM_OC_GetCompareCH6(&tim)
        return result
    case 71:
        LL_TIM_SetCH5CombinedChannels(&tim, args[0])
        return 0
    case 72:
        LL_TIM_OC_SetPulseWidthPrescaler(&tim, args[0])
        return 0
    case 73:
        let result = LL_TIM_OC_GetPulseWidthPrescaler(&tim)
        return result
    case 74:
        LL_TIM_OC_SetPulseWidth(&tim, args[0])
        return 0
    case 75:
        let result = LL_TIM_OC_GetPulseWidth(&tim)
        return result
    case 76:
        LL_TIM_IC_Config(&tim, args[0], args[1])
        return 0
    case 77:
        LL_TIM_IC_SetActiveInput(&tim, args[0], args[1])
        return 0
    case 78:
        let result = LL_TIM_IC_GetActiveInput(&tim, args[0])
        return result
    case 79:
        LL_TIM_IC_SetPrescaler(&tim, args[0], args[1])
        return 0
    case 80:
        let result = LL_TIM_IC_GetPrescaler(&tim, args[0])
        return result
    case 81:
        LL_TIM_IC_SetFilter(&tim, args[0], args[1])
        return 0
    case 82:
        let result = LL_TIM_IC_GetFilter(&tim, args[0])
        return result
    case 83:
        LL_TIM_IC_SetPolarity(&tim, args[0], args[1])
        return 0
    case 84:
        let result = LL_TIM_IC_GetPolarity(&tim, args[0])
        return result
    case 85:
        LL_TIM_IC_EnableXORCombination(&tim)
        return 0
    case 86:
        LL_TIM_IC_DisableXORCombination(&tim)
        return 0
    case 87:
        let result = LL_TIM_IC_IsEnabledXORCombination(&tim)
        return result
    case 88:
        let result = LL_TIM_IC_GetCaptureCH1(&tim)
        return result
    case 89:
        let result = LL_TIM_IC_GetCaptureCH2(&tim)
        return result
    case 90:
        let result = LL_TIM_IC_GetCaptureCH3(&tim)
        return result
    case 91:
        let result = LL_TIM_IC_GetCaptureCH4(&tim)
        return result
    case 92:
        LL_TIM_EnableExternalClock(&tim)
        return 0
    case 93:
        LL_TIM_DisableExternalClock(&tim)
        return 0
    case 94:
        let result = LL_TIM_IsEnabledExternalClock(&tim)
        return result
    case 95:
        LL_TIM_SetClockSource(&tim, args[0])
        return 0
    case 96:
        LL_TIM_SetEncoderMode(&tim, args[0])
        return 0
    case 97:
        LL_TIM_SetTriggerOutput(&tim, args[0])
        return 0
    case 98:
        LL_TIM_SetTriggerOutput2(&tim, args[0])
        return 0
    case 99:
        LL_TIM_SetSlaveMode(&tim, args[0])
        return 0
    case 100:
        LL_TIM_SetTriggerInput(&tim, args[0])
        return 0
    case 101:
        LL_TIM_EnableMasterSlaveMode(&tim)
        return 0
    case 102:
        LL_TIM_DisableMasterSlaveMode(&tim)
        return 0
    case 103:
        let result = LL_TIM_IsEnabledMasterSlaveMode(&tim)
        return result
    case 104:
        LL_TIM_ConfigETR(&tim, args[0], args[1], args[2])
        return 0
    case 105:
        LL_TIM_SetETRSource(&tim, args[0])
        return 0
    case 106:
        LL_TIM_EnableSMSPreload(&tim)
        return 0
    case 107:
        LL_TIM_DisableSMSPreload(&tim)
        return 0
    case 108:
        let result = LL_TIM_IsEnabledSMSPreload(&tim)
        return result
    case 109:
        LL_TIM_SetSMSPreloadSource(&tim, args[0])
        return 0
    case 110:
        let result = LL_TIM_GetSMSPreloadSource(&tim)
        return result
    case 111:
        LL_TIM_EnableBRK(&tim)
        return 0
    case 112:
        LL_TIM_DisableBRK(&tim)
        return 0
    case 113:
        LL_TIM_ConfigBRK(&tim, args[0], args[1], args[2])
        return 0
    case 114:
        LL_TIM_DisarmBRK(&tim)
        return 0
    case 115:
        LL_TIM_EnableBRK2(&tim)
        return 0
    case 116:
        LL_TIM_DisableBRK2(&tim)
        return 0
    case 117:
        LL_TIM_ConfigBRK2(&tim, args[0], args[1], args[2])
        return 0
    case 118:
        LL_TIM_DisarmBRK2(&tim)
        return 0
    case 119:
        LL_TIM_SetOffStates(&tim, args[0], args[1])
        return 0
    case 120:
        LL_TIM_EnableAutomaticOutput(&tim)
        return 0
    case 121:
        LL_TIM_DisableAutomaticOutput(&tim)
        return 0
    case 122:
        let result = LL_TIM_IsEnabledAutomaticOutput(&tim)
        return result
    case 123:
        LL_TIM_EnableAllOutputs(&tim)
        return 0
    case 124:
        LL_TIM_DisableAllOutputs(&tim)
        return 0
    case 125:
        let result = LL_TIM_IsEnabledAllOutputs(&tim)
        return result
    case 126:
        LL_TIM_EnableBreakInputSource(&tim, args[0], args[1])
        return 0
    case 127:
        LL_TIM_DisableBreakInputSource(&tim, args[0], args[1])
        return 0
    case 128:
        LL_TIM_SetBreakInputSourcePolarity(&tim, args[0], args[1], args[2])
        return 0
    case 129:
        LL_TIM_EnableAsymmetricalDeadTime(&tim)
        return 0
    case 130:
        LL_TIM_DisableAsymmetricalDeadTime(&tim)
        return 0
    case 131:
        let result = LL_TIM_IsEnabledAsymmetricalDeadTime(&tim)
        return result
    case 132:
        LL_TIM_SetFallingDeadTime(&tim, args[0])
        return 0
    case 133:
        let result = LL_TIM_GetFallingDeadTime(&tim)
        return result
    case 134:
        LL_TIM_EnableDeadTimePreload(&tim)
        return 0
    case 135:
        LL_TIM_DisableDeadTimePreload(&tim)
        return 0
    case 136:
        let result = LL_TIM_IsEnabledDeadTimePreload(&tim)
        return result
    case 137:
        LL_TIM_ConfigDMABurst(&tim, args[0], args[1], args[2])
        return 0
    case 138:
        LL_TIM_EnableEncoderIndex(&tim)
        return 0
    case 139:
        LL_TIM_DisableEncoderIndex(&tim)
        return 0
    case 140:
        let result = LL_TIM_IsEnabledEncoderIndex(&tim)
        return result
    case 141:
        LL_TIM_SetIndexDirection(&tim, args[0])
        return 0
    case 142:
        let result = LL_TIM_GetIndexDirection(&tim)
        return result
    case 143:
        LL_TIM_SetIndexblanking(&tim, args[0])
        return 0
    case 144:
        let result = LL_TIM_GetIndexblanking(&tim)
        return result
    case 145:
        LL_TIM_EnableFirstIndex(&tim)
        return 0
    case 146:
        LL_TIM_DisableFirstIndex(&tim)
        return 0
    case 147:
        let result = LL_TIM_IsEnabledFirstIndex(&tim)
        return result
    case 148:
        LL_TIM_SetIndexPositionning(&tim, args[0])
        return 0
    case 149:
        let result = LL_TIM_GetIndexPositionning(&tim)
        return result
    case 150:
        LL_TIM_ConfigIDX(&tim, args[0])
        return 0
    case 151:
        LL_TIM_SetRemap(&tim, args[0])
        return 0
    case 152:
        LL_TIM_ClearFlag_UPDATE(&tim)
        return 0
    case 153:
        let result = LL_TIM_IsActiveFlag_UPDATE(&tim)
        return result
    case 154:
        LL_TIM_ClearFlag_CC1(&tim)
        return 0
    case 155:
        let result = LL_TIM_IsActiveFlag_CC1(&tim)
        return result
    case 156:
        LL_TIM_ClearFlag_CC2(&tim)
        return 0
    case 157:
        let result = LL_TIM_IsActiveFlag_CC2(&tim)
        return result
    case 158:
        LL_TIM_ClearFlag_CC3(&tim)
        return 0
    case 159:
        let result = LL_TIM_IsActiveFlag_CC3(&tim)
        return result
    case 160:
        LL_TIM_ClearFlag_CC4(&tim)
        return 0
    case 161:
        let result = LL_TIM_IsActiveFlag_CC4(&tim)
        return result
    case 162:
        LL_TIM_ClearFlag_CC5(&tim)
        return 0
    case 163:
        let result = LL_TIM_IsActiveFlag_CC5(&tim)
        return result
    case 164:
        LL_TIM_ClearFlag_CC6(&tim)
        return 0
    case 165:
        let result = LL_TIM_IsActiveFlag_CC6(&tim)
        return result
    case 166:
        LL_TIM_ClearFlag_COM(&tim)
        return 0
    case 167:
        let result = LL_TIM_IsActiveFlag_COM(&tim)
        return result
    case 168:
        LL_TIM_ClearFlag_TRIG(&tim)
        return 0
    case 169:
        let result = LL_TIM_IsActiveFlag_TRIG(&tim)
        return result
    case 170:
        LL_TIM_ClearFlag_BRK(&tim)
        return 0
    case 171:
        let result = LL_TIM_IsActiveFlag_BRK(&tim)
        return result
    case 172:
        LL_TIM_ClearFlag_BRK2(&tim)
        return 0
    case 173:
        let result = LL_TIM_IsActiveFlag_BRK2(&tim)
        return result
    case 174:
        LL_TIM_ClearFlag_CC1OVR(&tim)
        return 0
    case 175:
        let result = LL_TIM_IsActiveFlag_CC1OVR(&tim)
        return result
    case 176:
        LL_TIM_ClearFlag_CC2OVR(&tim)
        return 0
    case 177:
        let result = LL_TIM_IsActiveFlag_CC2OVR(&tim)
        return result
    case 178:
        LL_TIM_ClearFlag_CC3OVR(&tim)
        return 0
    case 179:
        let result = LL_TIM_IsActiveFlag_CC3OVR(&tim)
        return result
    case 180:
        LL_TIM_ClearFlag_CC4OVR(&tim)
        return 0
    case 181:
        let result = LL_TIM_IsActiveFlag_CC4OVR(&tim)
        return result
    case 182:
        LL_TIM_ClearFlag_SYSBRK(&tim)
        return 0
    case 183:
        let result = LL_TIM_IsActiveFlag_SYSBRK(&tim)
        return result
    case 184:
        LL_TIM_ClearFlag_TERR(&tim)
        return 0
    case 185:
        let result = LL_TIM_IsActiveFlag_TERR(&tim)
        return result
    case 186:
        LL_TIM_ClearFlag_IERR(&tim)
        return 0
    case 187:
        let result = LL_TIM_IsActiveFlag_IERR(&tim)
        return result
    case 188:
        LL_TIM_ClearFlag_DIR(&tim)
        return 0
    case 189:
        let result = LL_TIM_IsActiveFlag_DIR(&tim)
        return result
    case 190:
        LL_TIM_ClearFlag_IDX(&tim)
        return 0
    case 191:
        let result = LL_TIM_IsActiveFlag_IDX(&tim)
        return result
    case 192:
        LL_TIM_EnableIT_UPDATE(&tim)
        return 0
    case 193:
        LL_TIM_DisableIT_UPDATE(&tim)
        return 0
    case 194:
        let result = LL_TIM_IsEnabledIT_UPDATE(&tim)
        return result
    case 195:
        LL_TIM_EnableIT_CC1(&tim)
        return 0
    case 196:
        LL_TIM_DisableIT_CC1(&tim)
        return 0
    case 197:
        let result = LL_TIM_IsEnabledIT_CC1(&tim)
        return result
    case 198:
        LL_TIM_EnableIT_CC2(&tim)
        return 0
    case 199:
        LL_TIM_DisableIT_CC2(&tim)
        return 0
    case 200:
        let result = LL_TIM_IsEnabledIT_CC2(&tim)
        return result
    case 201:
        LL_TIM_EnableIT_CC3(&tim)
        return 0
    case 202:
        LL_TIM_DisableIT_CC3(&tim)
        return 0
    case 203:
        let result = LL_TIM_IsEnabledIT_CC3(&tim)
        return result
    case 204:
        LL_TIM_EnableIT_CC4(&tim)
        return 0
    case 205:
        LL_TIM_DisableIT_CC4(&tim)
        return 0
    case 206:
        let result = LL_TIM_IsEnabledIT_CC4(&tim)
        return result
    case 207:
        LL_TIM_EnableIT_COM(&tim)
        return 0
    case 208:
        LL_TIM_DisableIT_COM(&tim)
        return 0
    case 209:
        let result = LL_TIM_IsEnabledIT_COM(&tim)
        return result
    case 210:
        LL_TIM_EnableIT_TRIG(&tim)
        return 0
    case 211:
        LL_TIM_DisableIT_TRIG(&tim)
        return 0
    case 212:
        let result = LL_TIM_IsEnabledIT_TRIG(&tim)
        return result
    case 213:
        LL_TIM_EnableIT_BRK(&tim)
        return 0
    case 214:
        LL_TIM_DisableIT_BRK(&tim)
        return 0
    case 215:
        let result = LL_TIM_IsEnabledIT_BRK(&tim)
        return result
    case 216:
        LL_TIM_EnableIT_TERR(&tim)
        return 0
    case 217:
        LL_TIM_DisableIT_TERR(&tim)
        return 0
    case 218:
        let result = LL_TIM_IsEnabledIT_TERR(&tim)
        return result
    case 219:
        LL_TIM_EnableIT_IERR(&tim)
        return 0
    case 220:
        LL_TIM_DisableIT_IERR(&tim)
        return 0
    case 221:
        let result = LL_TIM_IsEnabledIT_IERR(&tim)
        return result
    case 222:
        LL_TIM_EnableIT_DIR(&tim)
        return 0
    case 223:
        LL_TIM_DisableIT_DIR(&tim)
        return 0
    case 224:
        let result = LL_TIM_IsEnabledIT_DIR(&tim)
        return result
    case 225:
        LL_TIM_EnableIT_IDX(&tim)
        return 0
    case 226:
        LL_TIM_DisableIT_IDX(&tim)
        return 0
    case 227:
        let result = LL_TIM_IsEnabledIT_IDX(&tim)
        return result
    case 228:
        LL_TIM_EnableDMAReq_UPDATE(&tim)
        return 0
    case 229:
        LL_TIM_DisableDMAReq_UPDATE(&tim)
        return 0
    case 230:
        let result = LL_TIM_IsEnabledDMAReq_UPDATE(&tim)
        return result
    case 231:
        LL_TIM_EnableDMAReq_CC1(&tim)
        return 0
    case 232:
        LL_TIM_DisableDMAReq_CC1(&tim)
        return 0
    case 233:
        let result = LL_TIM_IsEnabledDMAReq_CC1(&tim)
        return result
    case 234:
        LL_TIM_EnableDMAReq_CC2(&tim)
        return 0
    case 235:
        LL_TIM_DisableDMAReq_CC2(&tim)
        return 0
    case 236:
        let result = LL_TIM_IsEnabledDMAReq_CC2(&tim)
        return result
    case 237:
        LL_TIM_EnableDMAReq_CC3(&tim)
        return 0
    case 238:
        LL_TIM_DisableDMAReq_CC3(&tim)
        return 0
    case 239:
        let result = LL_TIM_IsEnabledDMAReq_CC3(&tim)
        return result
    case 240:
        LL_TIM_EnableDMAReq_CC4(&tim)
        return 0
    case 241:
        LL_TIM_DisableDMAReq_CC4(&tim)
        return 0
    case 242:
        let result = LL_TIM_IsEnabledDMAReq_CC4(&tim)
        return result
    case 243:
        LL_TIM_EnableDMAReq_COM(&tim)
        return 0
    case 244:
        LL_TIM_DisableDMAReq_COM(&tim)
        return 0
    case 245:
        let result = LL_TIM_IsEnabledDMAReq_COM(&tim)
        return result
    case 246:
        LL_TIM_EnableDMAReq_TRIG(&tim)
        return 0
    case 247:
        LL_TIM_DisableDMAReq_TRIG(&tim)
        return 0
    case 248:
        let result = LL_TIM_IsEnabledDMAReq_TRIG(&tim)
        return result
    case 249:
        LL_TIM_GenerateEvent_UPDATE(&tim)
        return 0
    case 250:
        LL_TIM_GenerateEvent_CC1(&tim)
        return 0
    case 251:
        LL_TIM_GenerateEvent_CC2(&tim)
        return 0
    case 252:
        LL_TIM_GenerateEvent_CC3(&tim)
        return 0
    case 253:
        LL_TIM_GenerateEvent_CC4(&tim)
        return 0
    case 254:
        LL_TIM_GenerateEvent_COM(&tim)
        return 0
    case 255:
        LL_TIM_GenerateEvent_TRIG(&tim)
        return 0
    case 256:
        LL_TIM_GenerateEvent_BRK(&tim)
        return 0
    case 257:
        LL_TIM_GenerateEvent_BRK2(&tim)
        return 0
    case 258:
        let result = LL_TIM_DeInit(&tim, isKnownInstance: io.instanceID < 14).rawValue
        return result
    case 259:
        var v0 = LL_TIM_InitTypeDef(Prescaler: UInt16(truncatingIfNeeded: args[0]), CounterMode: args[1], Autoreload: args[2], ClockDivision: args[3], RepetitionCounter: args[4])
        LL_TIM_StructInit(&v0)
        io.cells[5000] = UInt32(v0.Prescaler)
        io.cells[5001] = v0.CounterMode
        io.cells[5002] = v0.Autoreload
        io.cells[5003] = v0.ClockDivision
        io.cells[5004] = v0.RepetitionCounter
        return 0
    case 260:
        let v1 = LL_TIM_InitTypeDef(Prescaler: UInt16(truncatingIfNeeded: args[0]), CounterMode: args[1], Autoreload: args[2], ClockDivision: args[3], RepetitionCounter: args[4])
        let result = LL_TIM_Init(&tim, v1).rawValue
        io.cells[5000] = UInt32(v1.Prescaler)
        io.cells[5001] = v1.CounterMode
        io.cells[5002] = v1.Autoreload
        io.cells[5003] = v1.ClockDivision
        io.cells[5004] = v1.RepetitionCounter
        return result
    case 261:
        var v0 = LL_TIM_OC_InitTypeDef(OCMode: args[0], OCState: args[1], OCNState: args[2], CompareValue: args[3], OCPolarity: args[4], OCNPolarity: args[5], OCIdleState: args[6], OCNIdleState: args[7])
        LL_TIM_OC_StructInit(&v0)
        io.cells[5000] = v0.OCMode
        io.cells[5001] = v0.OCState
        io.cells[5002] = v0.OCNState
        io.cells[5003] = v0.CompareValue
        io.cells[5004] = v0.OCPolarity
        io.cells[5005] = v0.OCNPolarity
        io.cells[5006] = v0.OCIdleState
        io.cells[5007] = v0.OCNIdleState
        return 0
    case 262:
        let v2 = LL_TIM_OC_InitTypeDef(OCMode: args[1], OCState: args[2], OCNState: args[3], CompareValue: args[4], OCPolarity: args[5], OCNPolarity: args[6], OCIdleState: args[7], OCNIdleState: args[8])
        let result = LL_TIM_OC_Init(&tim, args[0], v2).rawValue
        io.cells[5000] = v2.OCMode
        io.cells[5001] = v2.OCState
        io.cells[5002] = v2.OCNState
        io.cells[5003] = v2.CompareValue
        io.cells[5004] = v2.OCPolarity
        io.cells[5005] = v2.OCNPolarity
        io.cells[5006] = v2.OCIdleState
        io.cells[5007] = v2.OCNIdleState
        return result
    case 263:
        var v0 = LL_TIM_IC_InitTypeDef(ICPolarity: args[0], ICActiveInput: args[1], ICPrescaler: args[2], ICFilter: args[3])
        LL_TIM_IC_StructInit(&v0)
        io.cells[5000] = v0.ICPolarity
        io.cells[5001] = v0.ICActiveInput
        io.cells[5002] = v0.ICPrescaler
        io.cells[5003] = v0.ICFilter
        return 0
    case 264:
        let v2 = LL_TIM_IC_InitTypeDef(ICPolarity: args[1], ICActiveInput: args[2], ICPrescaler: args[3], ICFilter: args[4])
        let result = LL_TIM_IC_Init(&tim, args[0], v2).rawValue
        io.cells[5000] = v2.ICPolarity
        io.cells[5001] = v2.ICActiveInput
        io.cells[5002] = v2.ICPrescaler
        io.cells[5003] = v2.ICFilter
        return result
    case 265:
        var v0 = LL_TIM_ENCODER_InitTypeDef(EncoderMode: args[0], IC1Polarity: args[1], IC1ActiveInput: args[2], IC1Prescaler: args[3], IC1Filter: args[4], IC2Polarity: args[5], IC2ActiveInput: args[6], IC2Prescaler: args[7], IC2Filter: args[8])
        LL_TIM_ENCODER_StructInit(&v0)
        io.cells[5000] = v0.EncoderMode
        io.cells[5001] = v0.IC1Polarity
        io.cells[5002] = v0.IC1ActiveInput
        io.cells[5003] = v0.IC1Prescaler
        io.cells[5004] = v0.IC1Filter
        io.cells[5005] = v0.IC2Polarity
        io.cells[5006] = v0.IC2ActiveInput
        io.cells[5007] = v0.IC2Prescaler
        io.cells[5008] = v0.IC2Filter
        return 0
    case 266:
        let v1 = LL_TIM_ENCODER_InitTypeDef(EncoderMode: args[0], IC1Polarity: args[1], IC1ActiveInput: args[2], IC1Prescaler: args[3], IC1Filter: args[4], IC2Polarity: args[5], IC2ActiveInput: args[6], IC2Prescaler: args[7], IC2Filter: args[8])
        let result = LL_TIM_ENCODER_Init(&tim, v1).rawValue
        io.cells[5000] = v1.EncoderMode
        io.cells[5001] = v1.IC1Polarity
        io.cells[5002] = v1.IC1ActiveInput
        io.cells[5003] = v1.IC1Prescaler
        io.cells[5004] = v1.IC1Filter
        io.cells[5005] = v1.IC2Polarity
        io.cells[5006] = v1.IC2ActiveInput
        io.cells[5007] = v1.IC2Prescaler
        io.cells[5008] = v1.IC2Filter
        return result
    case 267:
        var v0 = LL_TIM_HALLSENSOR_InitTypeDef(IC1Polarity: args[0], IC1Prescaler: args[1], IC1Filter: args[2], CommutationDelay: args[3])
        LL_TIM_HALLSENSOR_StructInit(&v0)
        io.cells[5000] = v0.IC1Polarity
        io.cells[5001] = v0.IC1Prescaler
        io.cells[5002] = v0.IC1Filter
        io.cells[5003] = v0.CommutationDelay
        return 0
    case 268:
        let v1 = LL_TIM_HALLSENSOR_InitTypeDef(IC1Polarity: args[0], IC1Prescaler: args[1], IC1Filter: args[2], CommutationDelay: args[3])
        let result = LL_TIM_HALLSENSOR_Init(&tim, v1).rawValue
        io.cells[5000] = v1.IC1Polarity
        io.cells[5001] = v1.IC1Prescaler
        io.cells[5002] = v1.IC1Filter
        io.cells[5003] = v1.CommutationDelay
        return result
    case 269:
        var v0 = LL_TIM_BDTR_InitTypeDef(OSSRState: args[0], OSSIState: args[1], LockLevel: args[2], DeadTime: UInt8(truncatingIfNeeded: args[3]), BreakState: UInt16(truncatingIfNeeded: args[4]), BreakPolarity: args[5], BreakFilter: args[6], BreakAFMode: args[7], Break2State: args[8], Break2Polarity: args[9], Break2Filter: args[10], Break2AFMode: args[11], AutomaticOutput: args[12])
        LL_TIM_BDTR_StructInit(&v0)
        io.cells[5000] = v0.OSSRState
        io.cells[5001] = v0.OSSIState
        io.cells[5002] = v0.LockLevel
        io.cells[5003] = UInt32(v0.DeadTime)
        io.cells[5004] = UInt32(v0.BreakState)
        io.cells[5005] = v0.BreakPolarity
        io.cells[5006] = v0.BreakFilter
        io.cells[5007] = v0.BreakAFMode
        io.cells[5008] = v0.Break2State
        io.cells[5009] = v0.Break2Polarity
        io.cells[5010] = v0.Break2Filter
        io.cells[5011] = v0.Break2AFMode
        io.cells[5012] = v0.AutomaticOutput
        return 0
    case 270:
        let v1 = LL_TIM_BDTR_InitTypeDef(OSSRState: args[0], OSSIState: args[1], LockLevel: args[2], DeadTime: UInt8(truncatingIfNeeded: args[3]), BreakState: UInt16(truncatingIfNeeded: args[4]), BreakPolarity: args[5], BreakFilter: args[6], BreakAFMode: args[7], Break2State: args[8], Break2Polarity: args[9], Break2Filter: args[10], Break2AFMode: args[11], AutomaticOutput: args[12])
        let result = LL_TIM_BDTR_Init(&tim, v1).rawValue
        io.cells[5000] = v1.OSSRState
        io.cells[5001] = v1.OSSIState
        io.cells[5002] = v1.LockLevel
        io.cells[5003] = UInt32(v1.DeadTime)
        io.cells[5004] = UInt32(v1.BreakState)
        io.cells[5005] = v1.BreakPolarity
        io.cells[5006] = v1.BreakFilter
        io.cells[5007] = v1.BreakAFMode
        io.cells[5008] = v1.Break2State
        io.cells[5009] = v1.Break2Polarity
        io.cells[5010] = v1.Break2Filter
        io.cells[5011] = v1.Break2AFMode
        io.cells[5012] = v1.AutomaticOutput
        return result
    case 271:
        LL_LPTIM_Enable(&lptim)
        return 0
    case 272:
        LL_LPTIM_Disable(&lptim)
        return 0
    case 273:
        let result = LL_LPTIM_IsEnabled(&lptim)
        return result
    case 274:
        LL_LPTIM_StartCounter(&lptim, args[0])
        return 0
    case 275:
        LL_LPTIM_EnableResetAfterRead(&lptim)
        return 0
    case 276:
        LL_LPTIM_DisableResetAfterRead(&lptim)
        return 0
    case 277:
        let result = LL_LPTIM_IsEnabledResetAfterRead(&lptim)
        return result
    case 278:
        LL_LPTIM_ResetCounter(&lptim)
        return 0
    case 279:
        LL_LPTIM_SetUpdateMode(&lptim, args[0])
        return 0
    case 280:
        let result = LL_LPTIM_GetUpdateMode(&lptim)
        return result
    case 281:
        LL_LPTIM_SetAutoReload(&lptim, args[0])
        return 0
    case 282:
        let result = LL_LPTIM_GetAutoReload(&lptim)
        return result
    case 283:
        LL_LPTIM_SetRepetition(&lptim, args[0])
        return 0
    case 284:
        let result = LL_LPTIM_GetRepetition(&lptim)
        return result
    case 285:
        LL_LPTIM_CC_EnableChannel(&lptim, args[0])
        return 0
    case 286:
        LL_LPTIM_CC_DisableChannel(&lptim, args[0])
        return 0
    case 287:
        let result = LL_LPTIM_CC_IsEnabledChannel(&lptim, args[0])
        return result
    case 288:
        LL_LPTIM_OC_SetCompareCH1(&lptim, args[0])
        return 0
    case 289:
        let result = LL_LPTIM_OC_GetCompareCH1(&lptim)
        return result
    case 290:
        LL_LPTIM_OC_SetCompareCH2(&lptim, args[0])
        return 0
    case 291:
        let result = LL_LPTIM_OC_GetCompareCH2(&lptim)
        return result
    case 292:
        let result = LL_LPTIM_GetCounter(&lptim)
        return result
    case 293:
        LL_LPTIM_SetCounterMode(&lptim, args[0])
        return 0
    case 294:
        let result = LL_LPTIM_GetCounterMode(&lptim)
        return result
    case 295:
        LL_LPTIM_SetWaveform(&lptim, args[0])
        return 0
    case 296:
        let result = LL_LPTIM_GetWaveform(&lptim)
        return result
    case 297:
        LL_LPTIM_OC_SetPolarity(&lptim, args[0], args[1])
        return 0
    case 298:
        let result = LL_LPTIM_OC_GetPolarity(&lptim, args[0])
        return result
    case 299:
        LL_LPTIM_SetPrescaler(&lptim, args[0])
        return 0
    case 300:
        let result = LL_LPTIM_GetPrescaler(&lptim)
        return result
    case 301:
        LL_LPTIM_SetInput1Src(&lptim, args[0])
        return 0
    case 302:
        LL_LPTIM_SetInput2Src(&lptim, args[0])
        return 0
    case 303:
        LL_LPTIM_SetRemap(&lptim, args[0])
        return 0
    case 304:
        LL_LPTIM_IC_SetPolarity(&lptim, args[0], args[1])
        return 0
    case 305:
        let result = LL_LPTIM_IC_GetPolarity(&lptim, args[0])
        return result
    case 306:
        LL_LPTIM_IC_SetFilter(&lptim, args[0], args[1])
        return 0
    case 307:
        let result = LL_LPTIM_IC_GetFilter(&lptim, args[0])
        return result
    case 308:
        LL_LPTIM_IC_SetPrescaler(&lptim, args[0], args[1])
        return 0
    case 309:
        let result = LL_LPTIM_IC_GetPrescaler(&lptim, args[0])
        return result
    case 310:
        LL_LPTIM_CC_SetChannelMode(&lptim, args[0], args[1])
        return 0
    case 311:
        let result = LL_LPTIM_CC_GetChannelMode(&lptim, args[0])
        return result
    case 312:
        let result = LL_LPTIM_IC_GetCaptureCH1(&lptim)
        return result
    case 313:
        let result = LL_LPTIM_IC_GetCaptureCH2(&lptim)
        return result
    case 314:
        LL_LPTIM_EnableTimeout(&lptim)
        return 0
    case 315:
        LL_LPTIM_DisableTimeout(&lptim)
        return 0
    case 316:
        let result = LL_LPTIM_IsEnabledTimeout(&lptim)
        return result
    case 317:
        LL_LPTIM_TrigSw(&lptim)
        return 0
    case 318:
        LL_LPTIM_ConfigTrigger(&lptim, args[0], args[1], args[2])
        return 0
    case 319:
        let result = LL_LPTIM_GetTriggerSource(&lptim)
        return result
    case 320:
        let result = LL_LPTIM_GetTriggerFilter(&lptim)
        return result
    case 321:
        let result = LL_LPTIM_GetTriggerPolarity(&lptim)
        return result
    case 322:
        LL_LPTIM_SetClockSource(&lptim, args[0])
        return 0
    case 323:
        let result = LL_LPTIM_GetClockSource(&lptim)
        return result
    case 324:
        LL_LPTIM_ConfigClock(&lptim, args[0], args[1])
        return 0
    case 325:
        let result = LL_LPTIM_GetClockPolarity(&lptim)
        return result
    case 326:
        let result = LL_LPTIM_GetClockFilter(&lptim)
        return result
    case 327:
        LL_LPTIM_SetEncoderMode(&lptim, args[0])
        return 0
    case 328:
        let result = LL_LPTIM_GetEncoderMode(&lptim)
        return result
    case 329:
        LL_LPTIM_EnableEncoderMode(&lptim)
        return 0
    case 330:
        LL_LPTIM_DisableEncoderMode(&lptim)
        return 0
    case 331:
        let result = LL_LPTIM_IsEnabledEncoderMode(&lptim)
        return result
    case 332:
        LL_LPTIM_ClearFlag_CC1(&lptim)
        return 0
    case 333:
        let result = LL_LPTIM_IsActiveFlag_CC1(&lptim)
        return result
    case 334:
        LL_LPTIM_ClearFlag_CC2(&lptim)
        return 0
    case 335:
        let result = LL_LPTIM_IsActiveFlag_CC2(&lptim)
        return result
    case 336:
        LL_LPTIM_ClearFlag_CC1O(&lptim)
        return 0
    case 337:
        let result = LL_LPTIM_IsActiveFlag_CC1O(&lptim)
        return result
    case 338:
        LL_LPTIM_ClearFlag_CC2O(&lptim)
        return 0
    case 339:
        let result = LL_LPTIM_IsActiveFlag_CC2O(&lptim)
        return result
    case 340:
        LL_LPTIM_ClearFlag_ARRM(&lptim)
        return 0
    case 341:
        let result = LL_LPTIM_IsActiveFlag_ARRM(&lptim)
        return result
    case 342:
        LL_LPTIM_ClearFlag_EXTTRIG(&lptim)
        return 0
    case 343:
        let result = LL_LPTIM_IsActiveFlag_EXTTRIG(&lptim)
        return result
    case 344:
        LL_LPTIM_ClearFlag_CMP1OK(&lptim)
        return 0
    case 345:
        let result = LL_LPTIM_IsActiveFlag_CMP1OK(&lptim)
        return result
    case 346:
        LL_LPTIM_ClearFlag_CMP2OK(&lptim)
        return 0
    case 347:
        let result = LL_LPTIM_IsActiveFlag_CMP2OK(&lptim)
        return result
    case 348:
        LL_LPTIM_ClearFlag_DIEROK(&lptim)
        return 0
    case 349:
        let result = LL_LPTIM_IsActiveFlag_DIEROK(&lptim)
        return result
    case 350:
        LL_LPTIM_ClearFlag_ARROK(&lptim)
        return 0
    case 351:
        let result = LL_LPTIM_IsActiveFlag_ARROK(&lptim)
        return result
    case 352:
        LL_LPTIM_ClearFlag_UP(&lptim)
        return 0
    case 353:
        let result = LL_LPTIM_IsActiveFlag_UP(&lptim)
        return result
    case 354:
        LL_LPTIM_ClearFlag_DOWN(&lptim)
        return 0
    case 355:
        let result = LL_LPTIM_IsActiveFlag_DOWN(&lptim)
        return result
    case 356:
        LL_LPTIM_ClearFlag_REPOK(&lptim)
        return 0
    case 357:
        let result = LL_LPTIM_IsActiveFlag_REPOK(&lptim)
        return result
    case 358:
        LL_LPTIM_ClearFlag_UE(&lptim)
        return 0
    case 359:
        let result = LL_LPTIM_IsActiveFlag_UE(&lptim)
        return result
    case 360:
        LL_LPTIM_EnableIT_CC1(&lptim)
        return 0
    case 361:
        LL_LPTIM_DisableIT_CC1(&lptim)
        return 0
    case 362:
        let result = LL_LPTIM_IsEnabledIT_CC1(&lptim)
        return result
    case 363:
        LL_LPTIM_EnableIT_CC2(&lptim)
        return 0
    case 364:
        LL_LPTIM_DisableIT_CC2(&lptim)
        return 0
    case 365:
        let result = LL_LPTIM_IsEnabledIT_CC2(&lptim)
        return result
    case 366:
        LL_LPTIM_EnableIT_CC1O(&lptim)
        return 0
    case 367:
        LL_LPTIM_DisableIT_CC1O(&lptim)
        return 0
    case 368:
        let result = LL_LPTIM_IsEnabledIT_CC1O(&lptim)
        return result
    case 369:
        LL_LPTIM_EnableIT_CC2O(&lptim)
        return 0
    case 370:
        LL_LPTIM_DisableIT_CC2O(&lptim)
        return 0
    case 371:
        let result = LL_LPTIM_IsEnabledIT_CC2O(&lptim)
        return result
    case 372:
        LL_LPTIM_EnableIT_ARRM(&lptim)
        return 0
    case 373:
        LL_LPTIM_DisableIT_ARRM(&lptim)
        return 0
    case 374:
        let result = LL_LPTIM_IsEnabledIT_ARRM(&lptim)
        return result
    case 375:
        LL_LPTIM_EnableIT_EXTTRIG(&lptim)
        return 0
    case 376:
        LL_LPTIM_DisableIT_EXTTRIG(&lptim)
        return 0
    case 377:
        let result = LL_LPTIM_IsEnabledIT_EXTTRIG(&lptim)
        return result
    case 378:
        LL_LPTIM_EnableIT_CMP1OK(&lptim)
        return 0
    case 379:
        LL_LPTIM_DisableIT_CMP1OK(&lptim)
        return 0
    case 380:
        let result = LL_LPTIM_IsEnabledIT_CMP1OK(&lptim)
        return result
    case 381:
        LL_LPTIM_EnableIT_CMP2OK(&lptim)
        return 0
    case 382:
        LL_LPTIM_DisableIT_CMP2OK(&lptim)
        return 0
    case 383:
        let result = LL_LPTIM_IsEnabledIT_CMP2OK(&lptim)
        return result
    case 384:
        LL_LPTIM_EnableIT_ARROK(&lptim)
        return 0
    case 385:
        LL_LPTIM_DisableIT_ARROK(&lptim)
        return 0
    case 386:
        let result = LL_LPTIM_IsEnabledIT_ARROK(&lptim)
        return result
    case 387:
        LL_LPTIM_EnableIT_UP(&lptim)
        return 0
    case 388:
        LL_LPTIM_DisableIT_UP(&lptim)
        return 0
    case 389:
        let result = LL_LPTIM_IsEnabledIT_UP(&lptim)
        return result
    case 390:
        LL_LPTIM_EnableIT_DOWN(&lptim)
        return 0
    case 391:
        LL_LPTIM_DisableIT_DOWN(&lptim)
        return 0
    case 392:
        let result = LL_LPTIM_IsEnabledIT_DOWN(&lptim)
        return result
    case 393:
        LL_LPTIM_EnableIT_REPOK(&lptim)
        return 0
    case 394:
        LL_LPTIM_DisableIT_REPOK(&lptim)
        return 0
    case 395:
        let result = LL_LPTIM_IsEnabledIT_REPOK(&lptim)
        return result
    case 396:
        LL_LPTIM_EnableIT_UE(&lptim)
        return 0
    case 397:
        LL_LPTIM_DisableIT_UE(&lptim)
        return 0
    case 398:
        let result = LL_LPTIM_IsEnabledIT_UE(&lptim)
        return result
    case 399:
        LL_LPTIM_EnableDMAReq_UPDATE(&lptim)
        return 0
    case 400:
        LL_LPTIM_DisableDMAReq_UPDATE(&lptim)
        return 0
    case 401:
        let result = LL_LPTIM_IsEnabledDMAReq_UPDATE(&lptim)
        return result
    case 402:
        LL_LPTIM_EnableDMAReq_CC1(&lptim)
        return 0
    case 403:
        LL_LPTIM_DisableDMAReq_CC1(&lptim)
        return 0
    case 404:
        let result = LL_LPTIM_IsEnabledDMAReq_CC1(&lptim)
        return result
    case 405:
        LL_LPTIM_EnableDMAReq_CC2(&lptim)
        return 0
    case 406:
        LL_LPTIM_DisableDMAReq_CC2(&lptim)
        return 0
    case 407:
        let result = LL_LPTIM_IsEnabledDMAReq_CC2(&lptim)
        return result
    case 408:
        let result = LL_LPTIM_DeInit(&lptim, isKnownInstance: io.instanceID < 5).rawValue
        return result
    case 409:
        var v0 = LL_LPTIM_InitTypeDef(ClockSource: args[0], Prescaler: args[1], Waveform: args[2])
        LL_LPTIM_StructInit(&v0)
        io.cells[5000] = v0.ClockSource
        io.cells[5001] = v0.Prescaler
        io.cells[5002] = v0.Waveform
        return 0
    case 410:
        let v1 = LL_LPTIM_InitTypeDef(ClockSource: args[0], Prescaler: args[1], Waveform: args[2])
        let result = LL_LPTIM_Init(&lptim, v1).rawValue
        io.cells[5000] = v1.ClockSource
        io.cells[5001] = v1.Prescaler
        io.cells[5002] = v1.Waveform
        return result
    case 411: LL_LPTIM_ClearFLAG_CC1(&lptim); return 0
    case 412: LL_LPTIM_ClearFLAG_CC2(&lptim); return 0
    case 413: LL_LPTIM_ClearFLAG_CC1O(&lptim); return 0
    case 414: LL_LPTIM_ClearFLAG_CC2O(&lptim); return 0
    case 415: LL_LPTIM_ClearFLAG_ARRM(&lptim); return 0
    case 416: LL_TIM_ReArmBRK(&tim); return 0
    case 417: LL_TIM_ReArmBRK2(&tim); return 0
    case 418: LL_TIM_WriteReg(&tim, .cr1, args[0]); return LL_TIM_ReadReg(&tim, .cr1)
    case 419: LL_LPTIM_WriteReg(&lptim, .cfgr, args[0]); return LL_LPTIM_ReadReg(&lptim, .cfgr)
    case 420: return __LL_TIM_GETFLAG_UIFCPY(args[0])
    case 421: return __LL_TIM_CALC_DEADTIME(args[0], args[1], args[2])
    case 422: return __LL_TIM_CALC_PSC(args[0], args[1])
    case 423: return __LL_TIM_CALC_ARR(args[0], args[1], args[2])
    case 424: return __LL_TIM_CALC_ARR_DITHER(args[0], args[1], args[2])
    case 425: return __LL_TIM_CALC_DELAY(args[0], args[1], args[2])
    case 426: return __LL_TIM_CALC_DELAY_DITHER(args[0], args[1], args[2])
    case 427: return __LL_TIM_CALC_PULSE(args[0], args[1], args[2], args[3])
    case 428: return __LL_TIM_CALC_PULSE_DITHER(args[0], args[1], args[2], args[3])
    case 429: return __LL_TIM_GET_ICPSC_RATIO(args[0])
    case 430: return UInt32(LL_LPTIM_IC_GET_OFFSET(args[0], args[1]))
    default: preconditionFailure("Unknown operation")
    }
}
final class LLTimerDifferentialTests: XCTestCase {
    private func compare(_ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0, instance: UInt32 = 0,
                         file: StaticString = #filePath, line: UInt = #line) {
        let c = CL52_Create()!; defer { CL52_Destroy(c) }
        CL52_Reset(c, seed, salt, instance)
        let io = LLTimerImage(seed: seed, salt: salt, instance: instance)
        let cr = CL52_Run(c, UInt32(op), args), sr = runLLTimer(op, io, args)
        let context = "op=\(op) args=\(args) seed=\(seed) salt=\(salt) instance=\(instance)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL52_GetCells(c), count: 6144)
        for i in cells.indices where cells[i] != io.cells[i] {
            XCTFail("\(context) cell \(i): Swift \(io.cells[i]), C \(cells[i])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL52_GetTrace(c), count: Int(CL52_GetTraceCount(c)))
        XCTAssertEqual(io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file, line: line)
    }
    func testEveryFunctionOnEveryInstanceWithChangingReads() {
        let channels: [UInt32] = [LL_TIM_CHANNEL_CH1,LL_TIM_CHANNEL_CH1N,LL_TIM_CHANNEL_CH2,LL_TIM_CHANNEL_CH2N,
            LL_TIM_CHANNEL_CH3,LL_TIM_CHANNEL_CH3N,LL_TIM_CHANNEL_CH4,LL_TIM_CHANNEL_CH4N,
            LL_TIM_CHANNEL_CH5,LL_TIM_CHANNEL_CH6,0,.max,3,7,0x100,0x400]
        for op in 0..<411 {
            let isTIM = op < 271
            for instance: UInt32 in 0..<(isTIM ? 14 : 5) {
                for sample: UInt32 in 0..<16 {
                    let seed = sample &* 0x9E3779B9
                    var args = (0..<32).map { seed ^ (UInt32($0) &* 0x10204081) }
                    if op == 42 { args[0] = channels[Int(sample)] }
                    if op == 43 { args[0] = channels[Int(sample)] }
                    if op == 44 { args[0] = channels[Int(sample)] }
                    if op == 45 { args[0] = channels[Int(sample)] }
                    if op == 46 { args[0] = channels[Int(sample)] }
                    if op == 47 { args[0] = channels[Int(sample)] }
                    if op == 48 { args[0] = channels[Int(sample)] }
                    if op == 49 { args[0] = channels[Int(sample)] }
                    if op == 50 { args[0] = channels[Int(sample)] }
                    if op == 51 { args[0] = channels[Int(sample)] }
                    if op == 52 { args[0] = channels[Int(sample)] }
                    if op == 53 { args[0] = channels[Int(sample)] }
                    if op == 54 { args[0] = channels[Int(sample)] }
                    if op == 55 { args[0] = channels[Int(sample)] }
                    if op == 56 { args[0] = channels[Int(sample)] }
                    if op == 57 { args[0] = channels[Int(sample)] }
                    if op == 76 { args[0] = channels[Int(sample)] }
                    if op == 77 { args[0] = channels[Int(sample)] }
                    if op == 78 { args[0] = channels[Int(sample)] }
                    if op == 79 { args[0] = channels[Int(sample)] }
                    if op == 80 { args[0] = channels[Int(sample)] }
                    if op == 81 { args[0] = channels[Int(sample)] }
                    if op == 82 { args[0] = channels[Int(sample)] }
                    if op == 83 { args[0] = channels[Int(sample)] }
                    if op == 84 { args[0] = channels[Int(sample)] }
                    if op == 126 { args[0] = (sample % 2) * 4 }
                    if op == 127 { args[0] = (sample % 2) * 4 }
                    if op == 128 { args[0] = (sample % 2) * 4 }
                    if op == 262 { args[0] = channels[Int(sample)] }
                    if op == 264 { args[0] = channels[Int(sample)] }
                    if op == 285 { args[0] = sample % 2 }
                    if op == 286 { args[0] = sample % 2 }
                    if op == 287 { args[0] = sample % 2 }
                    if op == 297 { args[0] = sample % 2 }
                    if op == 298 { args[0] = sample % 2 }
                    if op == 304 { args[0] = sample % 2 }
                    if op == 305 { args[0] = sample % 2 }
                    if op == 306 { args[0] = sample % 2 }
                    if op == 307 { args[0] = sample % 2 }
                    if op == 308 { args[0] = sample % 2 }
                    if op == 309 { args[0] = sample % 2 }
                    if op == 310 { args[0] = sample % 2 }
                    if op == 311 { args[0] = sample % 2 }
                    compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x10204081, instance: instance)
                }
            }
        }
    }
    func testUnknownInstancesReturnErrorWithoutIO() {
        compare(258, [], instance: 14)
        compare(408, [], instance: 5)
    }
    func testAliasesNoOpsAndRawRegisterMacros() {
        for op in 411..<420 {
            for sample: UInt32 in 0..<32 {
                compare(op, [sample &* 0x9E3779B9], seed: sample, salt: 0x10204081, instance: sample % 5)
            }
        }
    }
    func testCalculationMacrosAtBoundariesAndOverflow() {
        let clocks: [UInt32] = [4,32_768,1_000_000,64_000_000,128_000_000,480_000_000,.max]
        for clock in clocks {
            for sample: UInt32 in 0..<256 {
                let prescaler = sample * 257
                let delay = sample &* 0x10204081
                compare(420, [delay])
                compare(422, [clock, sample+1])
                for op in 423...424 { compare(op, [clock, prescaler, sample+1]) }
                for op in 425...428 { compare(op, [clock, prescaler, delay, ~delay]) }
                compare(429, [(sample % 32) << 18])
                compare(430, [delay, ~delay])
            }
        }
        let delays: [UInt32] = [0,1,127,128,129,254,255,256,257,503,504,505,511,512,513,1007,1008,1009,1023,1024,1025,
                              4_294_966,4_294_967,4_294_968,4_294_969,.max]
        for clock in clocks {
            for division: UInt32 in [0,0x100,0x200,.max] {
                for delay in delays { compare(421, [clock,division,delay]) }
                for sample: UInt32 in 0..<512 { compare(421, [clock,division,sample &* 0x10204081]) }
            }
        }
    }
    func testBreakEnablePreservesRequiredReadback() {
        let io = LLTimerImage(seed: 0, salt: 0, instance: 0)
        var tim = LLTIMImage(image: io)
        LL_TIM_EnableBRK(&tim)
        XCTAssertEqual(io.trace.map(\.kind), [0,1,0])
        XCTAssertEqual(io.trace.map(\.index), [17,17,17])
        let before = io.trace
        LL_TIM_ReArmBRK(&tim); LL_TIM_ReArmBRK2(&tim)
        XCTAssertEqual(io.trace, before)
    }
    func testLPTIMFlagClearingRetainsTheICRRead() {
        let image = LLTimerImage(seed: 0, salt: 0, instance: 0)
        image.cells[3585] = 0x80000000
        var io = LLLPTIMImage(image: image)
        LL_LPTIM_ClearFlag_ARRM(&io)
        XCTAssertEqual(image.trace, [
            .init(index: 3585, value: 0x80000000, kind: 0),
            .init(index: 3585, value: 0x80000002, kind: 1)
        ])
    }
    func testLPTIMCaptureFilterUsesBits12And13() {
        XCTAssertEqual(LL_LPTIM_IC_GET_OFFSET(0, 0x0000), 2)
        XCTAssertEqual(LL_LPTIM_IC_GET_OFFSET(0, 0x1000), 7)
        XCTAssertEqual(LL_LPTIM_IC_GET_OFFSET(0, 0x2000), 9)
        XCTAssertEqual(LL_LPTIM_IC_GET_OFFSET(0, 0x3000), 13)
        XCTAssertEqual(LL_LPTIM_IC_GET_OFFSET(0, 0x00C0), 2)
        XCTAssertEqual(LL_LPTIM_IC_GET_OFFSET(0, 0x30C0), 13)
    }
    func testConstantsAndPublicTablesAgainstC() {
        XCTAssertEqual(UInt32(LL_TIM_SR_UIF), CL52_Constant(0), "LL_TIM_SR_UIF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC1IF), CL52_Constant(1), "LL_TIM_SR_CC1IF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC2IF), CL52_Constant(2), "LL_TIM_SR_CC2IF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC3IF), CL52_Constant(3), "LL_TIM_SR_CC3IF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC4IF), CL52_Constant(4), "LL_TIM_SR_CC4IF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC5IF), CL52_Constant(5), "LL_TIM_SR_CC5IF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC6IF), CL52_Constant(6), "LL_TIM_SR_CC6IF")
        XCTAssertEqual(UInt32(LL_TIM_SR_COMIF), CL52_Constant(7), "LL_TIM_SR_COMIF")
        XCTAssertEqual(UInt32(LL_TIM_SR_TIF), CL52_Constant(8), "LL_TIM_SR_TIF")
        XCTAssertEqual(UInt32(LL_TIM_SR_BIF), CL52_Constant(9), "LL_TIM_SR_BIF")
        XCTAssertEqual(UInt32(LL_TIM_SR_B2IF), CL52_Constant(10), "LL_TIM_SR_B2IF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC1OF), CL52_Constant(11), "LL_TIM_SR_CC1OF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC2OF), CL52_Constant(12), "LL_TIM_SR_CC2OF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC3OF), CL52_Constant(13), "LL_TIM_SR_CC3OF")
        XCTAssertEqual(UInt32(LL_TIM_SR_CC4OF), CL52_Constant(14), "LL_TIM_SR_CC4OF")
        XCTAssertEqual(UInt32(LL_TIM_SR_SBIF), CL52_Constant(15), "LL_TIM_SR_SBIF")
        XCTAssertEqual(UInt32(LL_TIM_SR_IDXF), CL52_Constant(16), "LL_TIM_SR_IDXF")
        XCTAssertEqual(UInt32(LL_TIM_SR_DIRF), CL52_Constant(17), "LL_TIM_SR_DIRF")
        XCTAssertEqual(UInt32(LL_TIM_SR_IERRF), CL52_Constant(18), "LL_TIM_SR_IERRF")
        XCTAssertEqual(UInt32(LL_TIM_SR_TERRF), CL52_Constant(19), "LL_TIM_SR_TERRF")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_DISABLE), CL52_Constant(20), "LL_TIM_BREAK_DISABLE")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_ENABLE), CL52_Constant(21), "LL_TIM_BREAK_ENABLE")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_DISABLE), CL52_Constant(22), "LL_TIM_BREAK2_DISABLE")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_ENABLE), CL52_Constant(23), "LL_TIM_BREAK2_ENABLE")
        XCTAssertEqual(UInt32(LL_TIM_AUTOMATICOUTPUT_DISABLE), CL52_Constant(24), "LL_TIM_AUTOMATICOUTPUT_DISABLE")
        XCTAssertEqual(UInt32(LL_TIM_AUTOMATICOUTPUT_ENABLE), CL52_Constant(25), "LL_TIM_AUTOMATICOUTPUT_ENABLE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_UIE), CL52_Constant(26), "LL_TIM_DIER_UIE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_CC1IE), CL52_Constant(27), "LL_TIM_DIER_CC1IE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_CC2IE), CL52_Constant(28), "LL_TIM_DIER_CC2IE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_CC3IE), CL52_Constant(29), "LL_TIM_DIER_CC3IE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_CC4IE), CL52_Constant(30), "LL_TIM_DIER_CC4IE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_COMIE), CL52_Constant(31), "LL_TIM_DIER_COMIE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_TIE), CL52_Constant(32), "LL_TIM_DIER_TIE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_BIE), CL52_Constant(33), "LL_TIM_DIER_BIE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_IDXIE), CL52_Constant(34), "LL_TIM_DIER_IDXIE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_DIRIE), CL52_Constant(35), "LL_TIM_DIER_DIRIE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_IERRIE), CL52_Constant(36), "LL_TIM_DIER_IERRIE")
        XCTAssertEqual(UInt32(LL_TIM_DIER_TERRIE), CL52_Constant(37), "LL_TIM_DIER_TERRIE")
        XCTAssertEqual(UInt32(LL_TIM_UPDATESOURCE_REGULAR), CL52_Constant(38), "LL_TIM_UPDATESOURCE_REGULAR")
        XCTAssertEqual(UInt32(LL_TIM_UPDATESOURCE_COUNTER), CL52_Constant(39), "LL_TIM_UPDATESOURCE_COUNTER")
        XCTAssertEqual(UInt32(LL_TIM_ONEPULSEMODE_SINGLE), CL52_Constant(40), "LL_TIM_ONEPULSEMODE_SINGLE")
        XCTAssertEqual(UInt32(LL_TIM_ONEPULSEMODE_REPETITIVE), CL52_Constant(41), "LL_TIM_ONEPULSEMODE_REPETITIVE")
        XCTAssertEqual(UInt32(LL_TIM_COUNTERMODE_UP), CL52_Constant(42), "LL_TIM_COUNTERMODE_UP")
        XCTAssertEqual(UInt32(LL_TIM_COUNTERMODE_DOWN), CL52_Constant(43), "LL_TIM_COUNTERMODE_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_COUNTERMODE_CENTER_DOWN), CL52_Constant(44), "LL_TIM_COUNTERMODE_CENTER_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_COUNTERMODE_CENTER_UP), CL52_Constant(45), "LL_TIM_COUNTERMODE_CENTER_UP")
        XCTAssertEqual(UInt32(LL_TIM_COUNTERMODE_CENTER_UP_DOWN), CL52_Constant(46), "LL_TIM_COUNTERMODE_CENTER_UP_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_CLOCKDIVISION_DIV1), CL52_Constant(47), "LL_TIM_CLOCKDIVISION_DIV1")
        XCTAssertEqual(UInt32(LL_TIM_CLOCKDIVISION_DIV2), CL52_Constant(48), "LL_TIM_CLOCKDIVISION_DIV2")
        XCTAssertEqual(UInt32(LL_TIM_CLOCKDIVISION_DIV4), CL52_Constant(49), "LL_TIM_CLOCKDIVISION_DIV4")
        XCTAssertEqual(UInt32(LL_TIM_COUNTERDIRECTION_UP), CL52_Constant(50), "LL_TIM_COUNTERDIRECTION_UP")
        XCTAssertEqual(UInt32(LL_TIM_COUNTERDIRECTION_DOWN), CL52_Constant(51), "LL_TIM_COUNTERDIRECTION_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_CCUPDATESOURCE_COMG_ONLY), CL52_Constant(52), "LL_TIM_CCUPDATESOURCE_COMG_ONLY")
        XCTAssertEqual(UInt32(LL_TIM_CCUPDATESOURCE_COMG_AND_TRGI), CL52_Constant(53), "LL_TIM_CCUPDATESOURCE_COMG_AND_TRGI")
        XCTAssertEqual(UInt32(LL_TIM_CCDMAREQUEST_CC), CL52_Constant(54), "LL_TIM_CCDMAREQUEST_CC")
        XCTAssertEqual(UInt32(LL_TIM_CCDMAREQUEST_UPDATE), CL52_Constant(55), "LL_TIM_CCDMAREQUEST_UPDATE")
        XCTAssertEqual(UInt32(LL_TIM_LOCKLEVEL_OFF), CL52_Constant(56), "LL_TIM_LOCKLEVEL_OFF")
        XCTAssertEqual(UInt32(LL_TIM_LOCKLEVEL_1), CL52_Constant(57), "LL_TIM_LOCKLEVEL_1")
        XCTAssertEqual(UInt32(LL_TIM_LOCKLEVEL_2), CL52_Constant(58), "LL_TIM_LOCKLEVEL_2")
        XCTAssertEqual(UInt32(LL_TIM_LOCKLEVEL_3), CL52_Constant(59), "LL_TIM_LOCKLEVEL_3")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH1), CL52_Constant(60), "LL_TIM_CHANNEL_CH1")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH1N), CL52_Constant(61), "LL_TIM_CHANNEL_CH1N")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH2), CL52_Constant(62), "LL_TIM_CHANNEL_CH2")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH2N), CL52_Constant(63), "LL_TIM_CHANNEL_CH2N")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH3), CL52_Constant(64), "LL_TIM_CHANNEL_CH3")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH3N), CL52_Constant(65), "LL_TIM_CHANNEL_CH3N")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH4), CL52_Constant(66), "LL_TIM_CHANNEL_CH4")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH4N), CL52_Constant(67), "LL_TIM_CHANNEL_CH4N")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH5), CL52_Constant(68), "LL_TIM_CHANNEL_CH5")
        XCTAssertEqual(UInt32(LL_TIM_CHANNEL_CH6), CL52_Constant(69), "LL_TIM_CHANNEL_CH6")
        XCTAssertEqual(UInt32(LL_TIM_OCSTATE_DISABLE), CL52_Constant(70), "LL_TIM_OCSTATE_DISABLE")
        XCTAssertEqual(UInt32(LL_TIM_OCSTATE_ENABLE), CL52_Constant(71), "LL_TIM_OCSTATE_ENABLE")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_ASSYMETRIC_PWM1), CL52_Constant(72), "LL_TIM_OCMODE_ASSYMETRIC_PWM1")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_ASSYMETRIC_PWM2), CL52_Constant(73), "LL_TIM_OCMODE_ASSYMETRIC_PWM2")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_FROZEN), CL52_Constant(74), "LL_TIM_OCMODE_FROZEN")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_ACTIVE), CL52_Constant(75), "LL_TIM_OCMODE_ACTIVE")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_INACTIVE), CL52_Constant(76), "LL_TIM_OCMODE_INACTIVE")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_TOGGLE), CL52_Constant(77), "LL_TIM_OCMODE_TOGGLE")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_FORCED_INACTIVE), CL52_Constant(78), "LL_TIM_OCMODE_FORCED_INACTIVE")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_FORCED_ACTIVE), CL52_Constant(79), "LL_TIM_OCMODE_FORCED_ACTIVE")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_PWM1), CL52_Constant(80), "LL_TIM_OCMODE_PWM1")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_PWM2), CL52_Constant(81), "LL_TIM_OCMODE_PWM2")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_RETRIG_OPM1), CL52_Constant(82), "LL_TIM_OCMODE_RETRIG_OPM1")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_RETRIG_OPM2), CL52_Constant(83), "LL_TIM_OCMODE_RETRIG_OPM2")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_COMBINED_PWM1), CL52_Constant(84), "LL_TIM_OCMODE_COMBINED_PWM1")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_COMBINED_PWM2), CL52_Constant(85), "LL_TIM_OCMODE_COMBINED_PWM2")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_ASYMMETRIC_PWM1), CL52_Constant(86), "LL_TIM_OCMODE_ASYMMETRIC_PWM1")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_ASYMMETRIC_PWM2), CL52_Constant(87), "LL_TIM_OCMODE_ASYMMETRIC_PWM2")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_PULSE_ON_COMPARE), CL52_Constant(88), "LL_TIM_OCMODE_PULSE_ON_COMPARE")
        XCTAssertEqual(UInt32(LL_TIM_OCMODE_DIRECTION_OUTPUT), CL52_Constant(89), "LL_TIM_OCMODE_DIRECTION_OUTPUT")
        XCTAssertEqual(UInt32(LL_TIM_OCPOLARITY_HIGH), CL52_Constant(90), "LL_TIM_OCPOLARITY_HIGH")
        XCTAssertEqual(UInt32(LL_TIM_OCPOLARITY_LOW), CL52_Constant(91), "LL_TIM_OCPOLARITY_LOW")
        XCTAssertEqual(UInt32(LL_TIM_OCIDLESTATE_LOW), CL52_Constant(92), "LL_TIM_OCIDLESTATE_LOW")
        XCTAssertEqual(UInt32(LL_TIM_OCIDLESTATE_HIGH), CL52_Constant(93), "LL_TIM_OCIDLESTATE_HIGH")
        XCTAssertEqual(UInt32(LL_TIM_GROUPCH5_NONE), CL52_Constant(94), "LL_TIM_GROUPCH5_NONE")
        XCTAssertEqual(UInt32(LL_TIM_GROUPCH5_OC1REFC), CL52_Constant(95), "LL_TIM_GROUPCH5_OC1REFC")
        XCTAssertEqual(UInt32(LL_TIM_GROUPCH5_OC2REFC), CL52_Constant(96), "LL_TIM_GROUPCH5_OC2REFC")
        XCTAssertEqual(UInt32(LL_TIM_GROUPCH5_OC3REFC), CL52_Constant(97), "LL_TIM_GROUPCH5_OC3REFC")
        XCTAssertEqual(UInt32(LL_TIM_ACTIVEINPUT_DIRECTTI), CL52_Constant(98), "LL_TIM_ACTIVEINPUT_DIRECTTI")
        XCTAssertEqual(UInt32(LL_TIM_ACTIVEINPUT_INDIRECTTI), CL52_Constant(99), "LL_TIM_ACTIVEINPUT_INDIRECTTI")
        XCTAssertEqual(UInt32(LL_TIM_ACTIVEINPUT_TRC), CL52_Constant(100), "LL_TIM_ACTIVEINPUT_TRC")
        XCTAssertEqual(UInt32(LL_TIM_ICPSC_DIV1), CL52_Constant(101), "LL_TIM_ICPSC_DIV1")
        XCTAssertEqual(UInt32(LL_TIM_ICPSC_DIV2), CL52_Constant(102), "LL_TIM_ICPSC_DIV2")
        XCTAssertEqual(UInt32(LL_TIM_ICPSC_DIV4), CL52_Constant(103), "LL_TIM_ICPSC_DIV4")
        XCTAssertEqual(UInt32(LL_TIM_ICPSC_DIV8), CL52_Constant(104), "LL_TIM_ICPSC_DIV8")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV1), CL52_Constant(105), "LL_TIM_IC_FILTER_FDIV1")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV1_N2), CL52_Constant(106), "LL_TIM_IC_FILTER_FDIV1_N2")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV1_N4), CL52_Constant(107), "LL_TIM_IC_FILTER_FDIV1_N4")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV1_N8), CL52_Constant(108), "LL_TIM_IC_FILTER_FDIV1_N8")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV2_N6), CL52_Constant(109), "LL_TIM_IC_FILTER_FDIV2_N6")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV2_N8), CL52_Constant(110), "LL_TIM_IC_FILTER_FDIV2_N8")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV4_N6), CL52_Constant(111), "LL_TIM_IC_FILTER_FDIV4_N6")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV4_N8), CL52_Constant(112), "LL_TIM_IC_FILTER_FDIV4_N8")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV8_N6), CL52_Constant(113), "LL_TIM_IC_FILTER_FDIV8_N6")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV8_N8), CL52_Constant(114), "LL_TIM_IC_FILTER_FDIV8_N8")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV16_N5), CL52_Constant(115), "LL_TIM_IC_FILTER_FDIV16_N5")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV16_N6), CL52_Constant(116), "LL_TIM_IC_FILTER_FDIV16_N6")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV16_N8), CL52_Constant(117), "LL_TIM_IC_FILTER_FDIV16_N8")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV32_N5), CL52_Constant(118), "LL_TIM_IC_FILTER_FDIV32_N5")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV32_N6), CL52_Constant(119), "LL_TIM_IC_FILTER_FDIV32_N6")
        XCTAssertEqual(UInt32(LL_TIM_IC_FILTER_FDIV32_N8), CL52_Constant(120), "LL_TIM_IC_FILTER_FDIV32_N8")
        XCTAssertEqual(UInt32(LL_TIM_IC_POLARITY_RISING), CL52_Constant(121), "LL_TIM_IC_POLARITY_RISING")
        XCTAssertEqual(UInt32(LL_TIM_IC_POLARITY_FALLING), CL52_Constant(122), "LL_TIM_IC_POLARITY_FALLING")
        XCTAssertEqual(UInt32(LL_TIM_IC_POLARITY_BOTHEDGE), CL52_Constant(123), "LL_TIM_IC_POLARITY_BOTHEDGE")
        XCTAssertEqual(UInt32(LL_TIM_CLOCKSOURCE_INTERNAL), CL52_Constant(124), "LL_TIM_CLOCKSOURCE_INTERNAL")
        XCTAssertEqual(UInt32(LL_TIM_CLOCKSOURCE_EXT_MODE1), CL52_Constant(125), "LL_TIM_CLOCKSOURCE_EXT_MODE1")
        XCTAssertEqual(UInt32(LL_TIM_CLOCKSOURCE_EXT_MODE2), CL52_Constant(126), "LL_TIM_CLOCKSOURCE_EXT_MODE2")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_X2_TI1), CL52_Constant(127), "LL_TIM_ENCODERMODE_X2_TI1")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_X2_TI2), CL52_Constant(128), "LL_TIM_ENCODERMODE_X2_TI2")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_X4_TI12), CL52_Constant(129), "LL_TIM_ENCODERMODE_X4_TI12")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_CLOCKPLUSDIRECTION_X2), CL52_Constant(130), "LL_TIM_ENCODERMODE_CLOCKPLUSDIRECTION_X2")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_CLOCKPLUSDIRECTION_X1), CL52_Constant(131), "LL_TIM_ENCODERMODE_CLOCKPLUSDIRECTION_X1")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_DIRECTIONALCLOCK_X2), CL52_Constant(132), "LL_TIM_ENCODERMODE_DIRECTIONALCLOCK_X2")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_DIRECTIONALCLOCK_X1_TI12), CL52_Constant(133), "LL_TIM_ENCODERMODE_DIRECTIONALCLOCK_X1_TI12")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_X1_TI1), CL52_Constant(134), "LL_TIM_ENCODERMODE_X1_TI1")
        XCTAssertEqual(UInt32(LL_TIM_ENCODERMODE_X1_TI2), CL52_Constant(135), "LL_TIM_ENCODERMODE_X1_TI2")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_RESET), CL52_Constant(136), "LL_TIM_TRGO_RESET")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_ENABLE), CL52_Constant(137), "LL_TIM_TRGO_ENABLE")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_UPDATE), CL52_Constant(138), "LL_TIM_TRGO_UPDATE")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_CC1IF), CL52_Constant(139), "LL_TIM_TRGO_CC1IF")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_OC1REF), CL52_Constant(140), "LL_TIM_TRGO_OC1REF")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_OC2REF), CL52_Constant(141), "LL_TIM_TRGO_OC2REF")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_OC3REF), CL52_Constant(142), "LL_TIM_TRGO_OC3REF")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_OC4REF), CL52_Constant(143), "LL_TIM_TRGO_OC4REF")
        XCTAssertEqual(UInt32(LL_TIM_TRGO_ENCODERCLK), CL52_Constant(144), "LL_TIM_TRGO_ENCODERCLK")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_RESET), CL52_Constant(145), "LL_TIM_TRGO2_RESET")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_ENABLE), CL52_Constant(146), "LL_TIM_TRGO2_ENABLE")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_UPDATE), CL52_Constant(147), "LL_TIM_TRGO2_UPDATE")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_CC1F), CL52_Constant(148), "LL_TIM_TRGO2_CC1F")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC1), CL52_Constant(149), "LL_TIM_TRGO2_OC1")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC2), CL52_Constant(150), "LL_TIM_TRGO2_OC2")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC3), CL52_Constant(151), "LL_TIM_TRGO2_OC3")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC4), CL52_Constant(152), "LL_TIM_TRGO2_OC4")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC5), CL52_Constant(153), "LL_TIM_TRGO2_OC5")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC6), CL52_Constant(154), "LL_TIM_TRGO2_OC6")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC4_RISINGFALLING), CL52_Constant(155), "LL_TIM_TRGO2_OC4_RISINGFALLING")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC6_RISINGFALLING), CL52_Constant(156), "LL_TIM_TRGO2_OC6_RISINGFALLING")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC4_RISING_OC6_RISING), CL52_Constant(157), "LL_TIM_TRGO2_OC4_RISING_OC6_RISING")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC4_RISING_OC6_FALLING), CL52_Constant(158), "LL_TIM_TRGO2_OC4_RISING_OC6_FALLING")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC5_RISING_OC6_RISING), CL52_Constant(159), "LL_TIM_TRGO2_OC5_RISING_OC6_RISING")
        XCTAssertEqual(UInt32(LL_TIM_TRGO2_OC5_RISING_OC6_FALLING), CL52_Constant(160), "LL_TIM_TRGO2_OC5_RISING_OC6_FALLING")
        XCTAssertEqual(UInt32(LL_TIM_SLAVEMODE_DISABLED), CL52_Constant(161), "LL_TIM_SLAVEMODE_DISABLED")
        XCTAssertEqual(UInt32(LL_TIM_SLAVEMODE_RESET), CL52_Constant(162), "LL_TIM_SLAVEMODE_RESET")
        XCTAssertEqual(UInt32(LL_TIM_SLAVEMODE_GATED), CL52_Constant(163), "LL_TIM_SLAVEMODE_GATED")
        XCTAssertEqual(UInt32(LL_TIM_SLAVEMODE_TRIGGER), CL52_Constant(164), "LL_TIM_SLAVEMODE_TRIGGER")
        XCTAssertEqual(UInt32(LL_TIM_SLAVEMODE_COMBINED_RESETTRIGGER), CL52_Constant(165), "LL_TIM_SLAVEMODE_COMBINED_RESETTRIGGER")
        XCTAssertEqual(UInt32(LL_TIM_SLAVEMODE_COMBINED_GATEDRESET), CL52_Constant(166), "LL_TIM_SLAVEMODE_COMBINED_GATEDRESET")
        XCTAssertEqual(UInt32(LL_TIM_SMSPS_TIMUPDATE), CL52_Constant(167), "LL_TIM_SMSPS_TIMUPDATE")
        XCTAssertEqual(UInt32(LL_TIM_SMSPS_INDEX), CL52_Constant(168), "LL_TIM_SMSPS_INDEX")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR0), CL52_Constant(169), "LL_TIM_TS_ITR0")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR1), CL52_Constant(170), "LL_TIM_TS_ITR1")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR2), CL52_Constant(171), "LL_TIM_TS_ITR2")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR3), CL52_Constant(172), "LL_TIM_TS_ITR3")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR4), CL52_Constant(173), "LL_TIM_TS_ITR4")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR5), CL52_Constant(174), "LL_TIM_TS_ITR5")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR6), CL52_Constant(175), "LL_TIM_TS_ITR6")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR7), CL52_Constant(176), "LL_TIM_TS_ITR7")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR8), CL52_Constant(177), "LL_TIM_TS_ITR8")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR9), CL52_Constant(178), "LL_TIM_TS_ITR9")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR10), CL52_Constant(179), "LL_TIM_TS_ITR10")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR11), CL52_Constant(180), "LL_TIM_TS_ITR11")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR12), CL52_Constant(181), "LL_TIM_TS_ITR12")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR13), CL52_Constant(182), "LL_TIM_TS_ITR13")
        XCTAssertEqual(UInt32(LL_TIM_TS_ITR14), CL52_Constant(183), "LL_TIM_TS_ITR14")
        XCTAssertEqual(UInt32(LL_TIM_TS_TI1F_ED), CL52_Constant(184), "LL_TIM_TS_TI1F_ED")
        XCTAssertEqual(UInt32(LL_TIM_TS_TI1FP1), CL52_Constant(185), "LL_TIM_TS_TI1FP1")
        XCTAssertEqual(UInt32(LL_TIM_TS_TI2FP2), CL52_Constant(186), "LL_TIM_TS_TI2FP2")
        XCTAssertEqual(UInt32(LL_TIM_TS_ETRF), CL52_Constant(187), "LL_TIM_TS_ETRF")
        XCTAssertEqual(UInt32(LL_TIM_ETR_POLARITY_NONINVERTED), CL52_Constant(188), "LL_TIM_ETR_POLARITY_NONINVERTED")
        XCTAssertEqual(UInt32(LL_TIM_ETR_POLARITY_INVERTED), CL52_Constant(189), "LL_TIM_ETR_POLARITY_INVERTED")
        XCTAssertEqual(UInt32(LL_TIM_ETR_PRESCALER_DIV1), CL52_Constant(190), "LL_TIM_ETR_PRESCALER_DIV1")
        XCTAssertEqual(UInt32(LL_TIM_ETR_PRESCALER_DIV2), CL52_Constant(191), "LL_TIM_ETR_PRESCALER_DIV2")
        XCTAssertEqual(UInt32(LL_TIM_ETR_PRESCALER_DIV4), CL52_Constant(192), "LL_TIM_ETR_PRESCALER_DIV4")
        XCTAssertEqual(UInt32(LL_TIM_ETR_PRESCALER_DIV8), CL52_Constant(193), "LL_TIM_ETR_PRESCALER_DIV8")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV1), CL52_Constant(194), "LL_TIM_ETR_FILTER_FDIV1")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV1_N2), CL52_Constant(195), "LL_TIM_ETR_FILTER_FDIV1_N2")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV1_N4), CL52_Constant(196), "LL_TIM_ETR_FILTER_FDIV1_N4")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV1_N8), CL52_Constant(197), "LL_TIM_ETR_FILTER_FDIV1_N8")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV2_N6), CL52_Constant(198), "LL_TIM_ETR_FILTER_FDIV2_N6")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV2_N8), CL52_Constant(199), "LL_TIM_ETR_FILTER_FDIV2_N8")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV4_N6), CL52_Constant(200), "LL_TIM_ETR_FILTER_FDIV4_N6")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV4_N8), CL52_Constant(201), "LL_TIM_ETR_FILTER_FDIV4_N8")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV8_N6), CL52_Constant(202), "LL_TIM_ETR_FILTER_FDIV8_N6")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV8_N8), CL52_Constant(203), "LL_TIM_ETR_FILTER_FDIV8_N8")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV16_N5), CL52_Constant(204), "LL_TIM_ETR_FILTER_FDIV16_N5")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV16_N6), CL52_Constant(205), "LL_TIM_ETR_FILTER_FDIV16_N6")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV16_N8), CL52_Constant(206), "LL_TIM_ETR_FILTER_FDIV16_N8")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV32_N5), CL52_Constant(207), "LL_TIM_ETR_FILTER_FDIV32_N5")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV32_N6), CL52_Constant(208), "LL_TIM_ETR_FILTER_FDIV32_N6")
        XCTAssertEqual(UInt32(LL_TIM_ETR_FILTER_FDIV32_N8), CL52_Constant(209), "LL_TIM_ETR_FILTER_FDIV32_N8")
        XCTAssertEqual(UInt32(LL_TIM_TIM1_ETRSOURCE_GPIO), CL52_Constant(210), "LL_TIM_TIM1_ETRSOURCE_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM1_ETRSOURCE_ADC1_AWD1), CL52_Constant(211), "LL_TIM_TIM1_ETRSOURCE_ADC1_AWD1")
        XCTAssertEqual(UInt32(LL_TIM_TIM1_ETRSOURCE_ADC1_AWD2), CL52_Constant(212), "LL_TIM_TIM1_ETRSOURCE_ADC1_AWD2")
        XCTAssertEqual(UInt32(LL_TIM_TIM1_ETRSOURCE_ADC1_AWD3), CL52_Constant(213), "LL_TIM_TIM1_ETRSOURCE_ADC1_AWD3")
        XCTAssertEqual(UInt32(LL_TIM_TIM1_ETRSOURCE_ADC2_AWD1), CL52_Constant(214), "LL_TIM_TIM1_ETRSOURCE_ADC2_AWD1")
        XCTAssertEqual(UInt32(LL_TIM_TIM1_ETRSOURCE_ADC2_AWD2), CL52_Constant(215), "LL_TIM_TIM1_ETRSOURCE_ADC2_AWD2")
        XCTAssertEqual(UInt32(LL_TIM_TIM1_ETRSOURCE_ADC2_AWD3), CL52_Constant(216), "LL_TIM_TIM1_ETRSOURCE_ADC2_AWD3")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_GPIO), CL52_Constant(217), "LL_TIM_TIM2_ETRSOURCE_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_DCMIPP_HSYNC), CL52_Constant(218), "LL_TIM_TIM2_ETRSOURCE_DCMIPP_HSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_LTDC_HSYNC), CL52_Constant(219), "LL_TIM_TIM2_ETRSOURCE_LTDC_HSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_SAI1_FSA), CL52_Constant(220), "LL_TIM_TIM2_ETRSOURCE_SAI1_FSA")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_SAI1_FSB), CL52_Constant(221), "LL_TIM_TIM2_ETRSOURCE_SAI1_FSB")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_GFXTIM_TE), CL52_Constant(222), "LL_TIM_TIM2_ETRSOURCE_GFXTIM_TE")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_DCMIPP_VSYNC), CL52_Constant(223), "LL_TIM_TIM2_ETRSOURCE_DCMIPP_VSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_LTDC_VSYNC), CL52_Constant(224), "LL_TIM_TIM2_ETRSOURCE_LTDC_VSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_TIM3_ETR), CL52_Constant(225), "LL_TIM_TIM2_ETRSOURCE_TIM3_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_TIM4_ETR), CL52_Constant(226), "LL_TIM_TIM2_ETRSOURCE_TIM4_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_TIM5_ETR), CL52_Constant(227), "LL_TIM_TIM2_ETRSOURCE_TIM5_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_ETRSOURCE_ETH_PPS), CL52_Constant(228), "LL_TIM_TIM2_ETRSOURCE_ETH_PPS")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_GPIO), CL52_Constant(229), "LL_TIM_TIM3_ETRSOURCE_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_DCMIPP_HSYNC), CL52_Constant(230), "LL_TIM_TIM3_ETRSOURCE_DCMIPP_HSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_LTDC_HSYNC), CL52_Constant(231), "LL_TIM_TIM3_ETRSOURCE_LTDC_HSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_GFXTIM_TE), CL52_Constant(232), "LL_TIM_TIM3_ETRSOURCE_GFXTIM_TE")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_DCMIPP_VSYNC), CL52_Constant(233), "LL_TIM_TIM3_ETRSOURCE_DCMIPP_VSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_LTDC_VSYNC), CL52_Constant(234), "LL_TIM_TIM3_ETRSOURCE_LTDC_VSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_TIM2_ETR), CL52_Constant(235), "LL_TIM_TIM3_ETRSOURCE_TIM2_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_TIM4_ETR), CL52_Constant(236), "LL_TIM_TIM3_ETRSOURCE_TIM4_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_TIM5_ETR), CL52_Constant(237), "LL_TIM_TIM3_ETRSOURCE_TIM5_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_ETRSOURCE_ETH_PPS), CL52_Constant(238), "LL_TIM_TIM3_ETRSOURCE_ETH_PPS")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_GPIO), CL52_Constant(239), "LL_TIM_TIM4_ETRSOURCE_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_DCMIPP_HSYNC), CL52_Constant(240), "LL_TIM_TIM4_ETRSOURCE_DCMIPP_HSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_LTDC_HSYNC), CL52_Constant(241), "LL_TIM_TIM4_ETRSOURCE_LTDC_HSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_GFXTIM_TE), CL52_Constant(242), "LL_TIM_TIM4_ETRSOURCE_GFXTIM_TE")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_DCMIPP_VSYNC), CL52_Constant(243), "LL_TIM_TIM4_ETRSOURCE_DCMIPP_VSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_LTDC_VSYNC), CL52_Constant(244), "LL_TIM_TIM4_ETRSOURCE_LTDC_VSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_TIM2_ETR), CL52_Constant(245), "LL_TIM_TIM4_ETRSOURCE_TIM2_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_TIM3_ETR), CL52_Constant(246), "LL_TIM_TIM4_ETRSOURCE_TIM3_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM4_ETRSOURCE_TIM5_ETR), CL52_Constant(247), "LL_TIM_TIM4_ETRSOURCE_TIM5_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_GPIO), CL52_Constant(248), "LL_TIM_TIM5_ETRSOURCE_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_SAI2_FSA), CL52_Constant(249), "LL_TIM_TIM5_ETRSOURCE_SAI2_FSA")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_SAI2_FSB), CL52_Constant(250), "LL_TIM_TIM5_ETRSOURCE_SAI2_FSB")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_DCMIPP_HSYNC), CL52_Constant(251), "LL_TIM_TIM5_ETRSOURCE_DCMIPP_HSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_LTDC_HSYNC), CL52_Constant(252), "LL_TIM_TIM5_ETRSOURCE_LTDC_HSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_GFXTIM_TE), CL52_Constant(253), "LL_TIM_TIM5_ETRSOURCE_GFXTIM_TE")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_DCMIPP_VSYNC), CL52_Constant(254), "LL_TIM_TIM5_ETRSOURCE_DCMIPP_VSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_LTDC_VSYNC), CL52_Constant(255), "LL_TIM_TIM5_ETRSOURCE_LTDC_VSYNC")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_TIM2_ETR), CL52_Constant(256), "LL_TIM_TIM5_ETRSOURCE_TIM2_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_TIM3_ETR), CL52_Constant(257), "LL_TIM_TIM5_ETRSOURCE_TIM3_ETR")
        XCTAssertEqual(UInt32(LL_TIM_TIM5_ETRSOURCE_TIM4_ETR), CL52_Constant(258), "LL_TIM_TIM5_ETRSOURCE_TIM4_ETR")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_POLARITY_LOW), CL52_Constant(259), "LL_TIM_BREAK_POLARITY_LOW")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_POLARITY_HIGH), CL52_Constant(260), "LL_TIM_BREAK_POLARITY_HIGH")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV1), CL52_Constant(261), "LL_TIM_BREAK_FILTER_FDIV1")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV1_N2), CL52_Constant(262), "LL_TIM_BREAK_FILTER_FDIV1_N2")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV1_N4), CL52_Constant(263), "LL_TIM_BREAK_FILTER_FDIV1_N4")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV1_N8), CL52_Constant(264), "LL_TIM_BREAK_FILTER_FDIV1_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV2_N6), CL52_Constant(265), "LL_TIM_BREAK_FILTER_FDIV2_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV2_N8), CL52_Constant(266), "LL_TIM_BREAK_FILTER_FDIV2_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV4_N6), CL52_Constant(267), "LL_TIM_BREAK_FILTER_FDIV4_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV4_N8), CL52_Constant(268), "LL_TIM_BREAK_FILTER_FDIV4_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV8_N6), CL52_Constant(269), "LL_TIM_BREAK_FILTER_FDIV8_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV8_N8), CL52_Constant(270), "LL_TIM_BREAK_FILTER_FDIV8_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV16_N5), CL52_Constant(271), "LL_TIM_BREAK_FILTER_FDIV16_N5")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV16_N6), CL52_Constant(272), "LL_TIM_BREAK_FILTER_FDIV16_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV16_N8), CL52_Constant(273), "LL_TIM_BREAK_FILTER_FDIV16_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV32_N5), CL52_Constant(274), "LL_TIM_BREAK_FILTER_FDIV32_N5")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV32_N6), CL52_Constant(275), "LL_TIM_BREAK_FILTER_FDIV32_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_FILTER_FDIV32_N8), CL52_Constant(276), "LL_TIM_BREAK_FILTER_FDIV32_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_POLARITY_LOW), CL52_Constant(277), "LL_TIM_BREAK2_POLARITY_LOW")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_POLARITY_HIGH), CL52_Constant(278), "LL_TIM_BREAK2_POLARITY_HIGH")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV1), CL52_Constant(279), "LL_TIM_BREAK2_FILTER_FDIV1")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV1_N2), CL52_Constant(280), "LL_TIM_BREAK2_FILTER_FDIV1_N2")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV1_N4), CL52_Constant(281), "LL_TIM_BREAK2_FILTER_FDIV1_N4")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV1_N8), CL52_Constant(282), "LL_TIM_BREAK2_FILTER_FDIV1_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV2_N6), CL52_Constant(283), "LL_TIM_BREAK2_FILTER_FDIV2_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV2_N8), CL52_Constant(284), "LL_TIM_BREAK2_FILTER_FDIV2_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV4_N6), CL52_Constant(285), "LL_TIM_BREAK2_FILTER_FDIV4_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV4_N8), CL52_Constant(286), "LL_TIM_BREAK2_FILTER_FDIV4_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV8_N6), CL52_Constant(287), "LL_TIM_BREAK2_FILTER_FDIV8_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV8_N8), CL52_Constant(288), "LL_TIM_BREAK2_FILTER_FDIV8_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV16_N5), CL52_Constant(289), "LL_TIM_BREAK2_FILTER_FDIV16_N5")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV16_N6), CL52_Constant(290), "LL_TIM_BREAK2_FILTER_FDIV16_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV16_N8), CL52_Constant(291), "LL_TIM_BREAK2_FILTER_FDIV16_N8")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV32_N5), CL52_Constant(292), "LL_TIM_BREAK2_FILTER_FDIV32_N5")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV32_N6), CL52_Constant(293), "LL_TIM_BREAK2_FILTER_FDIV32_N6")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_FILTER_FDIV32_N8), CL52_Constant(294), "LL_TIM_BREAK2_FILTER_FDIV32_N8")
        XCTAssertEqual(UInt32(LL_TIM_OSSI_DISABLE), CL52_Constant(295), "LL_TIM_OSSI_DISABLE")
        XCTAssertEqual(UInt32(LL_TIM_OSSI_ENABLE), CL52_Constant(296), "LL_TIM_OSSI_ENABLE")
        XCTAssertEqual(UInt32(LL_TIM_OSSR_DISABLE), CL52_Constant(297), "LL_TIM_OSSR_DISABLE")
        XCTAssertEqual(UInt32(LL_TIM_OSSR_ENABLE), CL52_Constant(298), "LL_TIM_OSSR_ENABLE")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_INPUT_BKIN), CL52_Constant(299), "LL_TIM_BREAK_INPUT_BKIN")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_INPUT_BKIN2), CL52_Constant(300), "LL_TIM_BREAK_INPUT_BKIN2")
        XCTAssertEqual(UInt32(LL_TIM_BKIN_SOURCE_BKIN), CL52_Constant(301), "LL_TIM_BKIN_SOURCE_BKIN")
        XCTAssertEqual(UInt32(LL_TIM_BKIN_POLARITY_LOW), CL52_Constant(302), "LL_TIM_BKIN_POLARITY_LOW")
        XCTAssertEqual(UInt32(LL_TIM_BKIN_POLARITY_HIGH), CL52_Constant(303), "LL_TIM_BKIN_POLARITY_HIGH")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_AFMODE_INPUT), CL52_Constant(304), "LL_TIM_BREAK_AFMODE_INPUT")
        XCTAssertEqual(UInt32(LL_TIM_BREAK_AFMODE_BIDIRECTIONAL), CL52_Constant(305), "LL_TIM_BREAK_AFMODE_BIDIRECTIONAL")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_AFMODE_INPUT), CL52_Constant(306), "LL_TIM_BREAK2_AFMODE_INPUT")
        XCTAssertEqual(UInt32(LL_TIM_BREAK2_AFMODE_BIDIRECTIONAL), CL52_Constant(307), "LL_TIM_BREAK2_AFMODE_BIDIRECTIONAL")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CR1), CL52_Constant(308), "LL_TIM_DMABURST_BASEADDR_CR1")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CR2), CL52_Constant(309), "LL_TIM_DMABURST_BASEADDR_CR2")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_SMCR), CL52_Constant(310), "LL_TIM_DMABURST_BASEADDR_SMCR")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_DIER), CL52_Constant(311), "LL_TIM_DMABURST_BASEADDR_DIER")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_SR), CL52_Constant(312), "LL_TIM_DMABURST_BASEADDR_SR")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_EGR), CL52_Constant(313), "LL_TIM_DMABURST_BASEADDR_EGR")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCMR1), CL52_Constant(314), "LL_TIM_DMABURST_BASEADDR_CCMR1")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCMR2), CL52_Constant(315), "LL_TIM_DMABURST_BASEADDR_CCMR2")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCER), CL52_Constant(316), "LL_TIM_DMABURST_BASEADDR_CCER")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CNT), CL52_Constant(317), "LL_TIM_DMABURST_BASEADDR_CNT")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_PSC), CL52_Constant(318), "LL_TIM_DMABURST_BASEADDR_PSC")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_ARR), CL52_Constant(319), "LL_TIM_DMABURST_BASEADDR_ARR")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_RCR), CL52_Constant(320), "LL_TIM_DMABURST_BASEADDR_RCR")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCR1), CL52_Constant(321), "LL_TIM_DMABURST_BASEADDR_CCR1")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCR2), CL52_Constant(322), "LL_TIM_DMABURST_BASEADDR_CCR2")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCR3), CL52_Constant(323), "LL_TIM_DMABURST_BASEADDR_CCR3")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCR4), CL52_Constant(324), "LL_TIM_DMABURST_BASEADDR_CCR4")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_BDTR), CL52_Constant(325), "LL_TIM_DMABURST_BASEADDR_BDTR")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCR5), CL52_Constant(326), "LL_TIM_DMABURST_BASEADDR_CCR5")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCR6), CL52_Constant(327), "LL_TIM_DMABURST_BASEADDR_CCR6")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_CCMR3), CL52_Constant(328), "LL_TIM_DMABURST_BASEADDR_CCMR3")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_DTR2), CL52_Constant(329), "LL_TIM_DMABURST_BASEADDR_DTR2")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_ECR), CL52_Constant(330), "LL_TIM_DMABURST_BASEADDR_ECR")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_TISEL), CL52_Constant(331), "LL_TIM_DMABURST_BASEADDR_TISEL")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_AF1), CL52_Constant(332), "LL_TIM_DMABURST_BASEADDR_AF1")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_BASEADDR_AF2), CL52_Constant(333), "LL_TIM_DMABURST_BASEADDR_AF2")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_1TRANSFER), CL52_Constant(334), "LL_TIM_DMABURST_LENGTH_1TRANSFER")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_2TRANSFERS), CL52_Constant(335), "LL_TIM_DMABURST_LENGTH_2TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_3TRANSFERS), CL52_Constant(336), "LL_TIM_DMABURST_LENGTH_3TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_4TRANSFERS), CL52_Constant(337), "LL_TIM_DMABURST_LENGTH_4TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_5TRANSFERS), CL52_Constant(338), "LL_TIM_DMABURST_LENGTH_5TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_6TRANSFERS), CL52_Constant(339), "LL_TIM_DMABURST_LENGTH_6TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_7TRANSFERS), CL52_Constant(340), "LL_TIM_DMABURST_LENGTH_7TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_8TRANSFERS), CL52_Constant(341), "LL_TIM_DMABURST_LENGTH_8TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_9TRANSFERS), CL52_Constant(342), "LL_TIM_DMABURST_LENGTH_9TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_10TRANSFERS), CL52_Constant(343), "LL_TIM_DMABURST_LENGTH_10TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_11TRANSFERS), CL52_Constant(344), "LL_TIM_DMABURST_LENGTH_11TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_12TRANSFERS), CL52_Constant(345), "LL_TIM_DMABURST_LENGTH_12TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_13TRANSFERS), CL52_Constant(346), "LL_TIM_DMABURST_LENGTH_13TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_14TRANSFERS), CL52_Constant(347), "LL_TIM_DMABURST_LENGTH_14TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_15TRANSFERS), CL52_Constant(348), "LL_TIM_DMABURST_LENGTH_15TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_16TRANSFERS), CL52_Constant(349), "LL_TIM_DMABURST_LENGTH_16TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_17TRANSFERS), CL52_Constant(350), "LL_TIM_DMABURST_LENGTH_17TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_18TRANSFERS), CL52_Constant(351), "LL_TIM_DMABURST_LENGTH_18TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_19TRANSFERS), CL52_Constant(352), "LL_TIM_DMABURST_LENGTH_19TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_20TRANSFERS), CL52_Constant(353), "LL_TIM_DMABURST_LENGTH_20TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_21TRANSFERS), CL52_Constant(354), "LL_TIM_DMABURST_LENGTH_21TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_22TRANSFERS), CL52_Constant(355), "LL_TIM_DMABURST_LENGTH_22TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_23TRANSFERS), CL52_Constant(356), "LL_TIM_DMABURST_LENGTH_23TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_24TRANSFERS), CL52_Constant(357), "LL_TIM_DMABURST_LENGTH_24TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_25TRANSFERS), CL52_Constant(358), "LL_TIM_DMABURST_LENGTH_25TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMABURST_LENGTH_26TRANSFERS), CL52_Constant(359), "LL_TIM_DMABURST_LENGTH_26TRANSFERS")
        XCTAssertEqual(UInt32(LL_TIM_DMA_UPDATE), CL52_Constant(360), "LL_TIM_DMA_UPDATE")
        XCTAssertEqual(UInt32(LL_TIM_DMA_CC1), CL52_Constant(361), "LL_TIM_DMA_CC1")
        XCTAssertEqual(UInt32(LL_TIM_DMA_CC2), CL52_Constant(362), "LL_TIM_DMA_CC2")
        XCTAssertEqual(UInt32(LL_TIM_DMA_CC3), CL52_Constant(363), "LL_TIM_DMA_CC3")
        XCTAssertEqual(UInt32(LL_TIM_DMA_CC4), CL52_Constant(364), "LL_TIM_DMA_CC4")
        XCTAssertEqual(UInt32(LL_TIM_DMA_COM), CL52_Constant(365), "LL_TIM_DMA_COM")
        XCTAssertEqual(UInt32(LL_TIM_DMA_TRIGGER), CL52_Constant(366), "LL_TIM_DMA_TRIGGER")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_TI1_RMP_GPIO), CL52_Constant(367), "LL_TIM_TIM2_TI1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM2_TI1_RMP_ETH_PPS), CL52_Constant(368), "LL_TIM_TIM2_TI1_RMP_ETH_PPS")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_TI1_RMP_GPIO), CL52_Constant(369), "LL_TIM_TIM3_TI1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM3_TI1_RMP_ETH_PPS), CL52_Constant(370), "LL_TIM_TIM3_TI1_RMP_ETH_PPS")
        XCTAssertEqual(UInt32(LL_TIM_TIM9_TI1_RMP_GPIO), CL52_Constant(371), "LL_TIM_TIM9_TI1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM9_TI1_RMP_MCO1), CL52_Constant(372), "LL_TIM_TIM9_TI1_RMP_MCO1")
        XCTAssertEqual(UInt32(LL_TIM_TIM9_TI1_RMP_MCO2), CL52_Constant(373), "LL_TIM_TIM9_TI1_RMP_MCO2")
        XCTAssertEqual(UInt32(LL_TIM_TIM12_TI1_RMP_GPIO), CL52_Constant(374), "LL_TIM_TIM12_TI1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM12_TI1_RMP_SPDIF_FS), CL52_Constant(375), "LL_TIM_TIM12_TI1_RMP_SPDIF_FS")
        XCTAssertEqual(UInt32(LL_TIM_TIM12_TI1_RMP_HSI_1024), CL52_Constant(376), "LL_TIM_TIM12_TI1_RMP_HSI_1024")
        XCTAssertEqual(UInt32(LL_TIM_TIM12_TI1_RMP_CSI_128), CL52_Constant(377), "LL_TIM_TIM12_TI1_RMP_CSI_128")
        XCTAssertEqual(UInt32(LL_TIM_TIM12_TI1_RMP_MCO1), CL52_Constant(378), "LL_TIM_TIM12_TI1_RMP_MCO1")
        XCTAssertEqual(UInt32(LL_TIM_TIM12_TI1_RMP_MCO2), CL52_Constant(379), "LL_TIM_TIM12_TI1_RMP_MCO2")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI1_RMP_GPIO), CL52_Constant(380), "LL_TIM_TIM15_TI1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI1_RMP_TIM2_CH1), CL52_Constant(381), "LL_TIM_TIM15_TI1_RMP_TIM2_CH1")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI1_RMP_TIM3_CH1), CL52_Constant(382), "LL_TIM_TIM15_TI1_RMP_TIM3_CH1")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI1_RMP_TIM4_CH1), CL52_Constant(383), "LL_TIM_TIM15_TI1_RMP_TIM4_CH1")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI1_RMP_MCO1), CL52_Constant(384), "LL_TIM_TIM15_TI1_RMP_MCO1")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI1_RMP_MCO2), CL52_Constant(385), "LL_TIM_TIM15_TI1_RMP_MCO2")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI2_RMP_GPIO), CL52_Constant(386), "LL_TIM_TIM15_TI2_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI2_RMP_TIM2_CH2), CL52_Constant(387), "LL_TIM_TIM15_TI2_RMP_TIM2_CH2")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI2_RMP_TIM3_CH2), CL52_Constant(388), "LL_TIM_TIM15_TI2_RMP_TIM3_CH2")
        XCTAssertEqual(UInt32(LL_TIM_TIM15_TI2_RMP_TIM4_CH2), CL52_Constant(389), "LL_TIM_TIM15_TI2_RMP_TIM4_CH2")
        XCTAssertEqual(UInt32(LL_TIM_TIM16_TI1_RMP_GPIO), CL52_Constant(390), "LL_TIM_TIM16_TI1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM16_TI1_RMP_RTC_WKUP), CL52_Constant(391), "LL_TIM_TIM16_TI1_RMP_RTC_WKUP")
        XCTAssertEqual(UInt32(LL_TIM_TIM17_TI1_RMP_GPIO), CL52_Constant(392), "LL_TIM_TIM17_TI1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_TIM_TIM17_TI1_RMP_SPDIF_FS), CL52_Constant(393), "LL_TIM_TIM17_TI1_RMP_SPDIF_FS")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_UP_DOWN), CL52_Constant(394), "LL_TIM_INDEX_UP_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_UP), CL52_Constant(395), "LL_TIM_INDEX_UP")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_DOWN), CL52_Constant(396), "LL_TIM_INDEX_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_BLANK_ALWAYS), CL52_Constant(397), "LL_TIM_INDEX_BLANK_ALWAYS")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_BLANK_TI3), CL52_Constant(398), "LL_TIM_INDEX_BLANK_TI3")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_BLANK_TI4), CL52_Constant(399), "LL_TIM_INDEX_BLANK_TI4")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_POSITION_DOWN_DOWN), CL52_Constant(400), "LL_TIM_INDEX_POSITION_DOWN_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_POSITION_DOWN_UP), CL52_Constant(401), "LL_TIM_INDEX_POSITION_DOWN_UP")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_POSITION_UP_DOWN), CL52_Constant(402), "LL_TIM_INDEX_POSITION_UP_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_POSITION_UP_UP), CL52_Constant(403), "LL_TIM_INDEX_POSITION_UP_UP")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_POSITION_DOWN), CL52_Constant(404), "LL_TIM_INDEX_POSITION_DOWN")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_POSITION_UP), CL52_Constant(405), "LL_TIM_INDEX_POSITION_UP")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_ALL), CL52_Constant(406), "LL_TIM_INDEX_ALL")
        XCTAssertEqual(UInt32(LL_TIM_INDEX_FIRST_ONLY), CL52_Constant(407), "LL_TIM_INDEX_FIRST_ONLY")
        XCTAssertEqual(UInt32(LL_TIM_PWPRSC_X1), CL52_Constant(408), "LL_TIM_PWPRSC_X1")
        XCTAssertEqual(UInt32(LL_TIM_PWPRSC_X2), CL52_Constant(409), "LL_TIM_PWPRSC_X2")
        XCTAssertEqual(UInt32(LL_TIM_PWPRSC_X4), CL52_Constant(410), "LL_TIM_PWPRSC_X4")
        XCTAssertEqual(UInt32(LL_TIM_PWPRSC_X8), CL52_Constant(411), "LL_TIM_PWPRSC_X8")
        XCTAssertEqual(UInt32(LL_TIM_PWPRSC_X16), CL52_Constant(412), "LL_TIM_PWPRSC_X16")
        XCTAssertEqual(UInt32(LL_TIM_PWPRSC_X32), CL52_Constant(413), "LL_TIM_PWPRSC_X32")
        XCTAssertEqual(UInt32(LL_TIM_PWPRSC_X64), CL52_Constant(414), "LL_TIM_PWPRSC_X64")
        XCTAssertEqual(UInt32(LL_TIM_PWPRSC_X128), CL52_Constant(415), "LL_TIM_PWPRSC_X128")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_CMP1OK), CL52_Constant(416), "LL_LPTIM_ISR_CMP1OK")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_CMP2OK), CL52_Constant(417), "LL_LPTIM_ISR_CMP2OK")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_CC1IF), CL52_Constant(418), "LL_LPTIM_ISR_CC1IF")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_CC2IF), CL52_Constant(419), "LL_LPTIM_ISR_CC2IF")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_CC1OF), CL52_Constant(420), "LL_LPTIM_ISR_CC1OF")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_CC2OF), CL52_Constant(421), "LL_LPTIM_ISR_CC2OF")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_DIEROK), CL52_Constant(422), "LL_LPTIM_ISR_DIEROK")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_ARRM), CL52_Constant(423), "LL_LPTIM_ISR_ARRM")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_EXTTRIG), CL52_Constant(424), "LL_LPTIM_ISR_EXTTRIG")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_ARROK), CL52_Constant(425), "LL_LPTIM_ISR_ARROK")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_UP), CL52_Constant(426), "LL_LPTIM_ISR_UP")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_DOWN), CL52_Constant(427), "LL_LPTIM_ISR_DOWN")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_UE), CL52_Constant(428), "LL_LPTIM_ISR_UE")
        XCTAssertEqual(UInt32(LL_LPTIM_ISR_REPOK), CL52_Constant(429), "LL_LPTIM_ISR_REPOK")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_CMP1OKIE), CL52_Constant(430), "LL_LPTIM_DIER_CMP1OKIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_CMP2OKIE), CL52_Constant(431), "LL_LPTIM_DIER_CMP2OKIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_CC1IFIE), CL52_Constant(432), "LL_LPTIM_DIER_CC1IFIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_CC2IFIE), CL52_Constant(433), "LL_LPTIM_DIER_CC2IFIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_CC1OFIE), CL52_Constant(434), "LL_LPTIM_DIER_CC1OFIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_CC2OFIE), CL52_Constant(435), "LL_LPTIM_DIER_CC2OFIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_ARRMIE), CL52_Constant(436), "LL_LPTIM_DIER_ARRMIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_EXTTRIGIE), CL52_Constant(437), "LL_LPTIM_DIER_EXTTRIGIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_ARROKIE), CL52_Constant(438), "LL_LPTIM_DIER_ARROKIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_UPIE), CL52_Constant(439), "LL_LPTIM_DIER_UPIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_DOWNIE), CL52_Constant(440), "LL_LPTIM_DIER_DOWNIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_UEIE), CL52_Constant(441), "LL_LPTIM_DIER_UEIE")
        XCTAssertEqual(UInt32(LL_LPTIM_DIER_REPOKIE), CL52_Constant(442), "LL_LPTIM_DIER_REPOKIE")
        XCTAssertEqual(UInt32(LL_LPTIM_OPERATING_MODE_CONTINUOUS), CL52_Constant(443), "LL_LPTIM_OPERATING_MODE_CONTINUOUS")
        XCTAssertEqual(UInt32(LL_LPTIM_OPERATING_MODE_ONESHOT), CL52_Constant(444), "LL_LPTIM_OPERATING_MODE_ONESHOT")
        XCTAssertEqual(UInt32(LL_LPTIM_UPDATE_MODE_IMMEDIATE), CL52_Constant(445), "LL_LPTIM_UPDATE_MODE_IMMEDIATE")
        XCTAssertEqual(UInt32(LL_LPTIM_UPDATE_MODE_ENDOFPERIOD), CL52_Constant(446), "LL_LPTIM_UPDATE_MODE_ENDOFPERIOD")
        XCTAssertEqual(UInt32(LL_LPTIM_COUNTER_MODE_INTERNAL), CL52_Constant(447), "LL_LPTIM_COUNTER_MODE_INTERNAL")
        XCTAssertEqual(UInt32(LL_LPTIM_COUNTER_MODE_EXTERNAL), CL52_Constant(448), "LL_LPTIM_COUNTER_MODE_EXTERNAL")
        XCTAssertEqual(UInt32(LL_LPTIM_OUTPUT_WAVEFORM_PWM), CL52_Constant(449), "LL_LPTIM_OUTPUT_WAVEFORM_PWM")
        XCTAssertEqual(UInt32(LL_LPTIM_OUTPUT_WAVEFORM_SETONCE), CL52_Constant(450), "LL_LPTIM_OUTPUT_WAVEFORM_SETONCE")
        XCTAssertEqual(UInt32(LL_LPTIM_OUTPUT_POLARITY_REGULAR), CL52_Constant(451), "LL_LPTIM_OUTPUT_POLARITY_REGULAR")
        XCTAssertEqual(UInt32(LL_LPTIM_OUTPUT_POLARITY_INVERSE), CL52_Constant(452), "LL_LPTIM_OUTPUT_POLARITY_INVERSE")
        XCTAssertEqual(UInt32(LL_LPTIM_CHANNEL_CH1), CL52_Constant(453), "LL_LPTIM_CHANNEL_CH1")
        XCTAssertEqual(UInt32(LL_LPTIM_CHANNEL_CH2), CL52_Constant(454), "LL_LPTIM_CHANNEL_CH2")
        XCTAssertEqual(UInt32(LL_LPTIM_ICPSC_DIV1), CL52_Constant(455), "LL_LPTIM_ICPSC_DIV1")
        XCTAssertEqual(UInt32(LL_LPTIM_ICPSC_DIV2), CL52_Constant(456), "LL_LPTIM_ICPSC_DIV2")
        XCTAssertEqual(UInt32(LL_LPTIM_ICPSC_DIV4), CL52_Constant(457), "LL_LPTIM_ICPSC_DIV4")
        XCTAssertEqual(UInt32(LL_LPTIM_ICPSC_DIV8), CL52_Constant(458), "LL_LPTIM_ICPSC_DIV8")
        XCTAssertEqual(UInt32(LL_LPTIM_ICFLT_CLOCK_DIV1), CL52_Constant(459), "LL_LPTIM_ICFLT_CLOCK_DIV1")
        XCTAssertEqual(UInt32(LL_LPTIM_ICFLT_CLOCK_DIV2), CL52_Constant(460), "LL_LPTIM_ICFLT_CLOCK_DIV2")
        XCTAssertEqual(UInt32(LL_LPTIM_ICFLT_CLOCK_DIV4), CL52_Constant(461), "LL_LPTIM_ICFLT_CLOCK_DIV4")
        XCTAssertEqual(UInt32(LL_LPTIM_ICFLT_CLOCK_DIV8), CL52_Constant(462), "LL_LPTIM_ICFLT_CLOCK_DIV8")
        XCTAssertEqual(UInt32(LL_LPTIM_ICPOLARITY_RISING), CL52_Constant(463), "LL_LPTIM_ICPOLARITY_RISING")
        XCTAssertEqual(UInt32(LL_LPTIM_ICPOLARITY_FALLING), CL52_Constant(464), "LL_LPTIM_ICPOLARITY_FALLING")
        XCTAssertEqual(UInt32(LL_LPTIM_ICPOLARITY_RISING_FALLING), CL52_Constant(465), "LL_LPTIM_ICPOLARITY_RISING_FALLING")
        XCTAssertEqual(UInt32(LL_LPTIM_CCMODE_OUTPUT_PWM), CL52_Constant(466), "LL_LPTIM_CCMODE_OUTPUT_PWM")
        XCTAssertEqual(UInt32(LL_LPTIM_CCMODE_INPUTCAPTURE), CL52_Constant(467), "LL_LPTIM_CCMODE_INPUTCAPTURE")
        XCTAssertEqual(UInt32(LL_LPTIM_PRESCALER_DIV1), CL52_Constant(468), "LL_LPTIM_PRESCALER_DIV1")
        XCTAssertEqual(UInt32(LL_LPTIM_PRESCALER_DIV2), CL52_Constant(469), "LL_LPTIM_PRESCALER_DIV2")
        XCTAssertEqual(UInt32(LL_LPTIM_PRESCALER_DIV4), CL52_Constant(470), "LL_LPTIM_PRESCALER_DIV4")
        XCTAssertEqual(UInt32(LL_LPTIM_PRESCALER_DIV8), CL52_Constant(471), "LL_LPTIM_PRESCALER_DIV8")
        XCTAssertEqual(UInt32(LL_LPTIM_PRESCALER_DIV16), CL52_Constant(472), "LL_LPTIM_PRESCALER_DIV16")
        XCTAssertEqual(UInt32(LL_LPTIM_PRESCALER_DIV32), CL52_Constant(473), "LL_LPTIM_PRESCALER_DIV32")
        XCTAssertEqual(UInt32(LL_LPTIM_PRESCALER_DIV64), CL52_Constant(474), "LL_LPTIM_PRESCALER_DIV64")
        XCTAssertEqual(UInt32(LL_LPTIM_PRESCALER_DIV128), CL52_Constant(475), "LL_LPTIM_PRESCALER_DIV128")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_GPIO), CL52_Constant(476), "LL_LPTIM_TRIG_SOURCE_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_RTCALARMA), CL52_Constant(477), "LL_LPTIM_TRIG_SOURCE_RTCALARMA")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_RTCALARMB), CL52_Constant(478), "LL_LPTIM_TRIG_SOURCE_RTCALARMB")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_RTCTAMP1), CL52_Constant(479), "LL_LPTIM_TRIG_SOURCE_RTCTAMP1")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_RTCTAMP2), CL52_Constant(480), "LL_LPTIM_TRIG_SOURCE_RTCTAMP2")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_RTCTAMP3), CL52_Constant(481), "LL_LPTIM_TRIG_SOURCE_RTCTAMP3")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_SAI1_FS_A), CL52_Constant(482), "LL_LPTIM_TRIG_SOURCE_SAI1_FS_A")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_SAI1_FS_B), CL52_Constant(483), "LL_LPTIM_TRIG_SOURCE_SAI1_FS_B")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_SAI2_FS_A), CL52_Constant(484), "LL_LPTIM_TRIG_SOURCE_SAI2_FS_A")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_SOURCE_SAI2_FS_B), CL52_Constant(485), "LL_LPTIM_TRIG_SOURCE_SAI2_FS_B")
        XCTAssertEqual(UInt32(LL_LPTIM3_TRIG_SOURCE_LPTIM2_CH1), CL52_Constant(486), "LL_LPTIM3_TRIG_SOURCE_LPTIM2_CH1")
        XCTAssertEqual(UInt32(LL_LPTIM3_TRIG_SOURCE_LPTIM4), CL52_Constant(487), "LL_LPTIM3_TRIG_SOURCE_LPTIM4")
        XCTAssertEqual(UInt32(LL_LPTIM3_TRIG_SOURCE_LPTIM5), CL52_Constant(488), "LL_LPTIM3_TRIG_SOURCE_LPTIM5")
        XCTAssertEqual(UInt32(LL_LPTIM4_TRIG_SOURCE_LPTIM2_CH1), CL52_Constant(489), "LL_LPTIM4_TRIG_SOURCE_LPTIM2_CH1")
        XCTAssertEqual(UInt32(LL_LPTIM4_TRIG_SOURCE_LPTIM3_CH1), CL52_Constant(490), "LL_LPTIM4_TRIG_SOURCE_LPTIM3_CH1")
        XCTAssertEqual(UInt32(LL_LPTIM4_TRIG_SOURCE_LPTIM5), CL52_Constant(491), "LL_LPTIM4_TRIG_SOURCE_LPTIM5")
        XCTAssertEqual(UInt32(LL_LPTIM5_TRIG_SOURCE_LPTIM2_CH1), CL52_Constant(492), "LL_LPTIM5_TRIG_SOURCE_LPTIM2_CH1")
        XCTAssertEqual(UInt32(LL_LPTIM5_TRIG_SOURCE_LPTIM3_CH1), CL52_Constant(493), "LL_LPTIM5_TRIG_SOURCE_LPTIM3_CH1")
        XCTAssertEqual(UInt32(LL_LPTIM5_TRIG_SOURCE_LPTIM4), CL52_Constant(494), "LL_LPTIM5_TRIG_SOURCE_LPTIM4")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_FILTER_NONE), CL52_Constant(495), "LL_LPTIM_TRIG_FILTER_NONE")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_FILTER_2), CL52_Constant(496), "LL_LPTIM_TRIG_FILTER_2")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_FILTER_4), CL52_Constant(497), "LL_LPTIM_TRIG_FILTER_4")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_FILTER_8), CL52_Constant(498), "LL_LPTIM_TRIG_FILTER_8")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_POLARITY_RISING), CL52_Constant(499), "LL_LPTIM_TRIG_POLARITY_RISING")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_POLARITY_FALLING), CL52_Constant(500), "LL_LPTIM_TRIG_POLARITY_FALLING")
        XCTAssertEqual(UInt32(LL_LPTIM_TRIG_POLARITY_RISING_FALLING), CL52_Constant(501), "LL_LPTIM_TRIG_POLARITY_RISING_FALLING")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_SOURCE_INTERNAL), CL52_Constant(502), "LL_LPTIM_CLK_SOURCE_INTERNAL")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_SOURCE_EXTERNAL), CL52_Constant(503), "LL_LPTIM_CLK_SOURCE_EXTERNAL")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_FILTER_NONE), CL52_Constant(504), "LL_LPTIM_CLK_FILTER_NONE")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_FILTER_2), CL52_Constant(505), "LL_LPTIM_CLK_FILTER_2")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_FILTER_4), CL52_Constant(506), "LL_LPTIM_CLK_FILTER_4")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_FILTER_8), CL52_Constant(507), "LL_LPTIM_CLK_FILTER_8")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_POLARITY_RISING), CL52_Constant(508), "LL_LPTIM_CLK_POLARITY_RISING")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_POLARITY_FALLING), CL52_Constant(509), "LL_LPTIM_CLK_POLARITY_FALLING")
        XCTAssertEqual(UInt32(LL_LPTIM_CLK_POLARITY_RISING_FALLING), CL52_Constant(510), "LL_LPTIM_CLK_POLARITY_RISING_FALLING")
        XCTAssertEqual(UInt32(LL_LPTIM_ENCODER_MODE_RISING), CL52_Constant(511), "LL_LPTIM_ENCODER_MODE_RISING")
        XCTAssertEqual(UInt32(LL_LPTIM_ENCODER_MODE_FALLING), CL52_Constant(512), "LL_LPTIM_ENCODER_MODE_FALLING")
        XCTAssertEqual(UInt32(LL_LPTIM_ENCODER_MODE_RISING_FALLING), CL52_Constant(513), "LL_LPTIM_ENCODER_MODE_RISING_FALLING")
        XCTAssertEqual(UInt32(LL_LPTIM_INPUT1_SRC_GPIO), CL52_Constant(514), "LL_LPTIM_INPUT1_SRC_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_INPUT2_SRC_GPIO), CL52_Constant(515), "LL_LPTIM_INPUT2_SRC_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM1_IC1_RMP_GPIO), CL52_Constant(516), "LL_LPTIM_LPTIM1_IC1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM1_IC2_RMP_GPIO), CL52_Constant(517), "LL_LPTIM_LPTIM1_IC2_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM1_IC2_RMP_LSI), CL52_Constant(518), "LL_LPTIM_LPTIM1_IC2_RMP_LSI")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM1_IC2_RMP_LSE), CL52_Constant(519), "LL_LPTIM_LPTIM1_IC2_RMP_LSE")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM2_IC1_RMP_GPIO), CL52_Constant(520), "LL_LPTIM_LPTIM2_IC1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM2_IC2_RMP_GPIO), CL52_Constant(521), "LL_LPTIM_LPTIM2_IC2_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM2_IC2_RMP_HSI_1024), CL52_Constant(522), "LL_LPTIM_LPTIM2_IC2_RMP_HSI_1024")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM2_IC2_RMP_CSI_128), CL52_Constant(523), "LL_LPTIM_LPTIM2_IC2_RMP_CSI_128")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM3_IC1_RMP_GPIO), CL52_Constant(524), "LL_LPTIM_LPTIM3_IC1_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_LPTIM3_IC2_RMP_GPIO), CL52_Constant(525), "LL_LPTIM_LPTIM3_IC2_RMP_GPIO")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_CCxP[0]), CL52_Constant(576), "LL_LPTIM_SHIFT_TAB_CCxP[0]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_CCxP[1]), CL52_Constant(577), "LL_LPTIM_SHIFT_TAB_CCxP[1]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_ICxF[0]), CL52_Constant(578), "LL_LPTIM_SHIFT_TAB_ICxF[0]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_ICxF[1]), CL52_Constant(579), "LL_LPTIM_SHIFT_TAB_ICxF[1]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_ICxPSC[0]), CL52_Constant(580), "LL_LPTIM_SHIFT_TAB_ICxPSC[0]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_ICxPSC[1]), CL52_Constant(581), "LL_LPTIM_SHIFT_TAB_ICxPSC[1]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_CCxSEL[0]), CL52_Constant(582), "LL_LPTIM_SHIFT_TAB_CCxSEL[0]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_CCxSEL[1]), CL52_Constant(583), "LL_LPTIM_SHIFT_TAB_CCxSEL[1]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_CCxE[0]), CL52_Constant(584), "LL_LPTIM_SHIFT_TAB_CCxE[0]")
        XCTAssertEqual(UInt32(LL_LPTIM_SHIFT_TAB_CCxE[1]), CL52_Constant(585), "LL_LPTIM_SHIFT_TAB_CCxE[1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[0][0]), CL52_Constant(586), "LL_LPTIM_OFFSET_TAB_ICx[0][0]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[0][1]), CL52_Constant(587), "LL_LPTIM_OFFSET_TAB_ICx[0][1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[0][2]), CL52_Constant(588), "LL_LPTIM_OFFSET_TAB_ICx[0][2]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[0][3]), CL52_Constant(589), "LL_LPTIM_OFFSET_TAB_ICx[0][3]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[1][0]), CL52_Constant(590), "LL_LPTIM_OFFSET_TAB_ICx[1][0]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[1][1]), CL52_Constant(591), "LL_LPTIM_OFFSET_TAB_ICx[1][1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[1][2]), CL52_Constant(592), "LL_LPTIM_OFFSET_TAB_ICx[1][2]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[1][3]), CL52_Constant(593), "LL_LPTIM_OFFSET_TAB_ICx[1][3]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[2][0]), CL52_Constant(594), "LL_LPTIM_OFFSET_TAB_ICx[2][0]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[2][1]), CL52_Constant(595), "LL_LPTIM_OFFSET_TAB_ICx[2][1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[2][2]), CL52_Constant(596), "LL_LPTIM_OFFSET_TAB_ICx[2][2]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[2][3]), CL52_Constant(597), "LL_LPTIM_OFFSET_TAB_ICx[2][3]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[3][0]), CL52_Constant(598), "LL_LPTIM_OFFSET_TAB_ICx[3][0]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[3][1]), CL52_Constant(599), "LL_LPTIM_OFFSET_TAB_ICx[3][1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[3][2]), CL52_Constant(600), "LL_LPTIM_OFFSET_TAB_ICx[3][2]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[3][3]), CL52_Constant(601), "LL_LPTIM_OFFSET_TAB_ICx[3][3]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[4][0]), CL52_Constant(602), "LL_LPTIM_OFFSET_TAB_ICx[4][0]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[4][1]), CL52_Constant(603), "LL_LPTIM_OFFSET_TAB_ICx[4][1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[4][2]), CL52_Constant(604), "LL_LPTIM_OFFSET_TAB_ICx[4][2]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[4][3]), CL52_Constant(605), "LL_LPTIM_OFFSET_TAB_ICx[4][3]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[5][0]), CL52_Constant(606), "LL_LPTIM_OFFSET_TAB_ICx[5][0]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[5][1]), CL52_Constant(607), "LL_LPTIM_OFFSET_TAB_ICx[5][1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[5][2]), CL52_Constant(608), "LL_LPTIM_OFFSET_TAB_ICx[5][2]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[5][3]), CL52_Constant(609), "LL_LPTIM_OFFSET_TAB_ICx[5][3]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[6][0]), CL52_Constant(610), "LL_LPTIM_OFFSET_TAB_ICx[6][0]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[6][1]), CL52_Constant(611), "LL_LPTIM_OFFSET_TAB_ICx[6][1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[6][2]), CL52_Constant(612), "LL_LPTIM_OFFSET_TAB_ICx[6][2]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[6][3]), CL52_Constant(613), "LL_LPTIM_OFFSET_TAB_ICx[6][3]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[7][0]), CL52_Constant(614), "LL_LPTIM_OFFSET_TAB_ICx[7][0]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[7][1]), CL52_Constant(615), "LL_LPTIM_OFFSET_TAB_ICx[7][1]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[7][2]), CL52_Constant(616), "LL_LPTIM_OFFSET_TAB_ICx[7][2]")
        XCTAssertEqual(UInt32(LL_LPTIM_OFFSET_TAB_ICx[7][3]), CL52_Constant(617), "LL_LPTIM_OFFSET_TAB_ICx[7][3]")
    }
}
