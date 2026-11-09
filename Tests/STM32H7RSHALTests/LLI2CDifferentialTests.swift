import CLLReference
import STM32H7RSHAL
import XCTest

private struct LLI2CAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}
private final class LLI2CImage: I2CRegisterIO, I3CRegisterIO, LLBusRegisterIO {
    var cells: [UInt32]
    var trace: [LLI2CAccess] = []
    var reads: UInt32 = 0
    let salt: UInt32
    let instance: UInt32
    init(_ seed: UInt32, _ salt: UInt32, _ instance: UInt32) {
        cells = (0..<512).map { seed ^ (UInt32($0) &* 0x9E37_79B9) }
        self.salt = salt
        self.instance = instance
    }
    func readIndex(_ i: Int) -> UInt32 {
        let value = cells[i] ^ (salt &* reads)
        reads &+= 1
        trace.append(.init(index: UInt32(i), value: value, kind: 0))
        return value
    }
    func writeIndex(_ i: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(i), value: value, kind: 1))
        cells[i] = value
    }
    func read(_ r: I2CRegister) -> UInt32 { readIndex(Int(instance * 16 + r.rawValue / 4)) }
    func write(_ r: I2CRegister, value: UInt32) { writeIndex(Int(instance * 16 + r.rawValue / 4), value) }
    func address(of r: I2CRegister) -> UInt32 {
        (instance < 3 ? 0x4000_5400 + instance * 0x400 : 0xFFFF_0000) + r.rawValue
    }
    func read(_ r: I3CRegister) -> UInt32 { readIndex(64 + Int(r.rawValue / 4)) }
    func write(_ r: I3CRegister, value: UInt32) { writeIndex(64 + Int(r.rawValue / 4), value) }
    func address(of r: I3CRegister) -> UInt32 { 0x4000_5400 + r.rawValue }
    func read(_ r: LLBusRegister) -> UInt32 { readIndex(256 + Int(r.rawValue / 4)) }
    func write(_ r: LLBusRegister, value: UInt32) { writeIndex(256 + Int(r.rawValue / 4), value) }
}
private func runLLI2C(_ op: Int, _ io: LLI2CImage, _ args: [UInt32]) -> UInt32 {
    var bus = io
    switch op {
    case 0:
        LL_I2C_Enable(io)
        return 0
    case 1:
        LL_I2C_Disable(io)
        return 0
    case 2:
        let result = LL_I2C_IsEnabled(io)
        return result
    case 3:
        LL_I2C_ConfigFilters(io, args[0], args[1])
        return 0
    case 4:
        LL_I2C_SetDigitalFilter(io, args[0])
        return 0
    case 5:
        let result = LL_I2C_GetDigitalFilter(io)
        return result
    case 6:
        LL_I2C_EnableAnalogFilter(io)
        return 0
    case 7:
        LL_I2C_DisableAnalogFilter(io)
        return 0
    case 8:
        let result = LL_I2C_IsEnabledAnalogFilter(io)
        return result
    case 9:
        LL_I2C_EnableDMAReq_TX(io)
        return 0
    case 10:
        LL_I2C_DisableDMAReq_TX(io)
        return 0
    case 11:
        let result = LL_I2C_IsEnabledDMAReq_TX(io)
        return result
    case 12:
        LL_I2C_EnableDMAReq_RX(io)
        return 0
    case 13:
        LL_I2C_DisableDMAReq_RX(io)
        return 0
    case 14:
        let result = LL_I2C_IsEnabledDMAReq_RX(io)
        return result
    case 15:
        let result = LL_I2C_DMA_GetRegAddr(io, args[0])
        return result
    case 16:
        LL_I2C_EnableClockStretching(io)
        return 0
    case 17:
        LL_I2C_DisableClockStretching(io)
        return 0
    case 18:
        let result = LL_I2C_IsEnabledClockStretching(io)
        return result
    case 19:
        LL_I2C_EnableSlaveByteControl(io)
        return 0
    case 20:
        LL_I2C_DisableSlaveByteControl(io)
        return 0
    case 21:
        let result = LL_I2C_IsEnabledSlaveByteControl(io)
        return result
    case 22:
        LL_I2C_EnableWakeUpFromStop(io)
        return 0
    case 23:
        LL_I2C_DisableWakeUpFromStop(io)
        return 0
    case 24:
        let result = LL_I2C_IsEnabledWakeUpFromStop(io)
        return result
    case 25:
        LL_I2C_EnableGeneralCall(io)
        return 0
    case 26:
        LL_I2C_DisableGeneralCall(io)
        return 0
    case 27:
        let result = LL_I2C_IsEnabledGeneralCall(io)
        return result
    case 28:
        LL_I2C_EnableFastModePlus(io)
        return 0
    case 29:
        LL_I2C_DisableFastModePlus(io)
        return 0
    case 30:
        let result = LL_I2C_IsEnabledFastModePlus(io)
        return result
    case 31:
        LL_I2C_EnableAutoClearFlag_ADDR(io)
        return 0
    case 32:
        LL_I2C_DisableAutoClearFlag_ADDR(io)
        return 0
    case 33:
        let result = LL_I2C_IsEnabledAutoClearFlag_ADDR(io)
        return result
    case 34:
        LL_I2C_EnableAutoClearFlag_STOP(io)
        return 0
    case 35:
        LL_I2C_DisableAutoClearFlag_STOP(io)
        return 0
    case 36:
        let result = LL_I2C_IsEnabledAutoClearFlag_STOP(io)
        return result
    case 37:
        LL_I2C_SetMasterAddressingMode(io, args[0])
        return 0
    case 38:
        let result = LL_I2C_GetMasterAddressingMode(io)
        return result
    case 39:
        LL_I2C_SetOwnAddress1(io, args[0], args[1])
        return 0
    case 40:
        LL_I2C_EnableOwnAddress1(io)
        return 0
    case 41:
        LL_I2C_DisableOwnAddress1(io)
        return 0
    case 42:
        let result = LL_I2C_IsEnabledOwnAddress1(io)
        return result
    case 43:
        LL_I2C_SetOwnAddress2(io, args[0], args[1])
        return 0
    case 44:
        LL_I2C_EnableOwnAddress2(io)
        return 0
    case 45:
        LL_I2C_DisableOwnAddress2(io)
        return 0
    case 46:
        let result = LL_I2C_IsEnabledOwnAddress2(io)
        return result
    case 47:
        LL_I2C_SetTiming(io, args[0])
        return 0
    case 48:
        let result = LL_I2C_GetTimingPrescaler(io)
        return result
    case 49:
        let result = LL_I2C_GetClockLowPeriod(io)
        return result
    case 50:
        let result = LL_I2C_GetClockHighPeriod(io)
        return result
    case 51:
        let result = LL_I2C_GetDataHoldTime(io)
        return result
    case 52:
        let result = LL_I2C_GetDataSetupTime(io)
        return result
    case 53:
        LL_I2C_SetMode(io, args[0])
        return 0
    case 54:
        let result = LL_I2C_GetMode(io)
        return result
    case 55:
        LL_I2C_EnableSMBusAlert(io)
        return 0
    case 56:
        LL_I2C_DisableSMBusAlert(io)
        return 0
    case 57:
        let result = LL_I2C_IsEnabledSMBusAlert(io)
        return result
    case 58:
        LL_I2C_EnableSMBusPEC(io)
        return 0
    case 59:
        LL_I2C_DisableSMBusPEC(io)
        return 0
    case 60:
        let result = LL_I2C_IsEnabledSMBusPEC(io)
        return result
    case 61:
        LL_I2C_ConfigSMBusTimeout(io, args[0], args[1], args[2])
        return 0
    case 62:
        LL_I2C_SetSMBusTimeoutA(io, args[0])
        return 0
    case 63:
        let result = LL_I2C_GetSMBusTimeoutA(io)
        return result
    case 64:
        LL_I2C_SetSMBusTimeoutAMode(io, args[0])
        return 0
    case 65:
        let result = LL_I2C_GetSMBusTimeoutAMode(io)
        return result
    case 66:
        LL_I2C_SetSMBusTimeoutB(io, args[0])
        return 0
    case 67:
        let result = LL_I2C_GetSMBusTimeoutB(io)
        return result
    case 68:
        LL_I2C_EnableSMBusTimeout(io, args[0])
        return 0
    case 69:
        LL_I2C_DisableSMBusTimeout(io, args[0])
        return 0
    case 70:
        let result = LL_I2C_IsEnabledSMBusTimeout(io, args[0])
        return result
    case 71:
        LL_I2C_EnableIT_TX(io)
        return 0
    case 72:
        LL_I2C_DisableIT_TX(io)
        return 0
    case 73:
        let result = LL_I2C_IsEnabledIT_TX(io)
        return result
    case 74:
        LL_I2C_EnableIT_RX(io)
        return 0
    case 75:
        LL_I2C_DisableIT_RX(io)
        return 0
    case 76:
        let result = LL_I2C_IsEnabledIT_RX(io)
        return result
    case 77:
        LL_I2C_EnableIT_ADDR(io)
        return 0
    case 78:
        LL_I2C_DisableIT_ADDR(io)
        return 0
    case 79:
        let result = LL_I2C_IsEnabledIT_ADDR(io)
        return result
    case 80:
        LL_I2C_EnableIT_NACK(io)
        return 0
    case 81:
        LL_I2C_DisableIT_NACK(io)
        return 0
    case 82:
        let result = LL_I2C_IsEnabledIT_NACK(io)
        return result
    case 83:
        LL_I2C_EnableIT_STOP(io)
        return 0
    case 84:
        LL_I2C_DisableIT_STOP(io)
        return 0
    case 85:
        let result = LL_I2C_IsEnabledIT_STOP(io)
        return result
    case 86:
        LL_I2C_EnableIT_TC(io)
        return 0
    case 87:
        LL_I2C_DisableIT_TC(io)
        return 0
    case 88:
        let result = LL_I2C_IsEnabledIT_TC(io)
        return result
    case 89:
        LL_I2C_EnableIT_ERR(io)
        return 0
    case 90:
        LL_I2C_DisableIT_ERR(io)
        return 0
    case 91:
        let result = LL_I2C_IsEnabledIT_ERR(io)
        return result
    case 92:
        let result = LL_I2C_IsActiveFlag_TXE(io)
        return result
    case 93:
        let result = LL_I2C_IsActiveFlag_TXIS(io)
        return result
    case 94:
        let result = LL_I2C_IsActiveFlag_RXNE(io)
        return result
    case 95:
        let result = LL_I2C_IsActiveFlag_ADDR(io)
        return result
    case 96:
        let result = LL_I2C_IsActiveFlag_NACK(io)
        return result
    case 97:
        let result = LL_I2C_IsActiveFlag_STOP(io)
        return result
    case 98:
        let result = LL_I2C_IsActiveFlag_TC(io)
        return result
    case 99:
        let result = LL_I2C_IsActiveFlag_TCR(io)
        return result
    case 100:
        let result = LL_I2C_IsActiveFlag_BERR(io)
        return result
    case 101:
        let result = LL_I2C_IsActiveFlag_ARLO(io)
        return result
    case 102:
        let result = LL_I2C_IsActiveFlag_OVR(io)
        return result
    case 103:
        let result = LL_I2C_IsActiveSMBusFlag_PECERR(io)
        return result
    case 104:
        let result = LL_I2C_IsActiveSMBusFlag_TIMEOUT(io)
        return result
    case 105:
        let result = LL_I2C_IsActiveSMBusFlag_ALERT(io)
        return result
    case 106:
        let result = LL_I2C_IsActiveFlag_BUSY(io)
        return result
    case 107:
        LL_I2C_ClearFlag_ADDR(io)
        return 0
    case 108:
        LL_I2C_ClearFlag_NACK(io)
        return 0
    case 109:
        LL_I2C_ClearFlag_STOP(io)
        return 0
    case 110:
        LL_I2C_ClearFlag_TXE(io)
        return 0
    case 111:
        LL_I2C_ClearFlag_BERR(io)
        return 0
    case 112:
        LL_I2C_ClearFlag_ARLO(io)
        return 0
    case 113:
        LL_I2C_ClearFlag_OVR(io)
        return 0
    case 114:
        LL_I2C_ClearSMBusFlag_PECERR(io)
        return 0
    case 115:
        LL_I2C_ClearSMBusFlag_TIMEOUT(io)
        return 0
    case 116:
        LL_I2C_ClearSMBusFlag_ALERT(io)
        return 0
    case 117:
        LL_I2C_EnableAutoEndMode(io)
        return 0
    case 118:
        LL_I2C_DisableAutoEndMode(io)
        return 0
    case 119:
        let result = LL_I2C_IsEnabledAutoEndMode(io)
        return result
    case 120:
        LL_I2C_EnableReloadMode(io)
        return 0
    case 121:
        LL_I2C_DisableReloadMode(io)
        return 0
    case 122:
        let result = LL_I2C_IsEnabledReloadMode(io)
        return result
    case 123:
        LL_I2C_SetTransferSize(io, args[0])
        return 0
    case 124:
        let result = LL_I2C_GetTransferSize(io)
        return result
    case 125:
        LL_I2C_AcknowledgeNextData(io, args[0])
        return 0
    case 126:
        LL_I2C_GenerateStartCondition(io)
        return 0
    case 127:
        LL_I2C_GenerateStopCondition(io)
        return 0
    case 128:
        LL_I2C_EnableAuto10BitRead(io)
        return 0
    case 129:
        LL_I2C_DisableAuto10BitRead(io)
        return 0
    case 130:
        let result = LL_I2C_IsEnabledAuto10BitRead(io)
        return result
    case 131:
        LL_I2C_SetTransferRequest(io, args[0])
        return 0
    case 132:
        let result = LL_I2C_GetTransferRequest(io)
        return result
    case 133:
        LL_I2C_SetSlaveAddr(io, args[0])
        return 0
    case 134:
        let result = LL_I2C_GetSlaveAddr(io)
        return result
    case 135:
        LL_I2C_HandleTransfer(io, args[0], args[1], args[2], args[3], args[4])
        return 0
    case 136:
        let result = LL_I2C_GetTransferDirection(io)
        return result
    case 137:
        let result = LL_I2C_GetAddressMatchCode(io)
        return result
    case 138:
        LL_I2C_EnableSMBusPECCompare(io)
        return 0
    case 139:
        let result = LL_I2C_IsEnabledSMBusPECCompare(io)
        return result
    case 140:
        let result = LL_I2C_GetSMBusPEC(io)
        return result
    case 141:
        let result = UInt32(LL_I2C_ReceiveData8(io))
        return result
    case 142:
        LL_I2C_TransmitData8(io, UInt8(truncatingIfNeeded: args[0]))
        return 0
    case 143:
        let result = LL_I2C_DeInit(&bus).rawValue
        return result
    case 144:
        var v1 = LL_I2C_InitTypeDef()
        v1.PeripheralMode = args[0]
        v1.Timing = args[1]
        v1.AnalogFilter = args[2]
        v1.DigitalFilter = args[3]
        v1.OwnAddress1 = args[4]
        v1.TypeAcknowledge = args[5]
        v1.OwnAddrSize = args[6]
        let result = LL_I2C_Init(io, v1).rawValue
        io.cells[384] = UInt32(v1.PeripheralMode)
        io.cells[385] = UInt32(v1.Timing)
        io.cells[386] = UInt32(v1.AnalogFilter)
        io.cells[387] = UInt32(v1.DigitalFilter)
        io.cells[388] = UInt32(v1.OwnAddress1)
        io.cells[389] = UInt32(v1.TypeAcknowledge)
        io.cells[390] = UInt32(v1.OwnAddrSize)
        return result
    case 145:
        var v0 = LL_I2C_InitTypeDef()
        v0.PeripheralMode = args[0]
        v0.Timing = args[1]
        v0.AnalogFilter = args[2]
        v0.DigitalFilter = args[3]
        v0.OwnAddress1 = args[4]
        v0.TypeAcknowledge = args[5]
        v0.OwnAddrSize = args[6]
        LL_I2C_StructInit(&v0)
        io.cells[384] = UInt32(v0.PeripheralMode)
        io.cells[385] = UInt32(v0.Timing)
        io.cells[386] = UInt32(v0.AnalogFilter)
        io.cells[387] = UInt32(v0.DigitalFilter)
        io.cells[388] = UInt32(v0.OwnAddress1)
        io.cells[389] = UInt32(v0.TypeAcknowledge)
        io.cells[390] = UInt32(v0.OwnAddrSize)
        return 0
    case 146:
        LL_I3C_Enable(io)
        return 0
    case 147:
        LL_I3C_Disable(io)
        return 0
    case 148:
        let result = LL_I3C_IsEnabled(io)
        return result
    case 149:
        let result = LL_I3C_IsEnabledReset(io)
        return result
    case 150:
        LL_I3C_SetMode(io, args[0])
        return 0
    case 151:
        let result = LL_I3C_GetMode(io)
        return result
    case 152:
        LL_I3C_EnableArbitrationHeader(io)
        return 0
    case 153:
        LL_I3C_DisableArbitrationHeader(io)
        return 0
    case 154:
        let result = LL_I3C_IsEnabledArbitrationHeader(io)
        return result
    case 155:
        LL_I3C_EnableResetPattern(io)
        return 0
    case 156:
        LL_I3C_DisableResetPattern(io)
        return 0
    case 157:
        let result = LL_I3C_IsEnabledResetPattern(io)
        return result
    case 158:
        LL_I3C_EnableExitPattern(io)
        return 0
    case 159:
        LL_I3C_DisableExitPattern(io)
        return 0
    case 160:
        let result = LL_I3C_IsEnabledExitPattern(io)
        return result
    case 161:
        LL_I3C_EnableHighKeeperSDA(io)
        return 0
    case 162:
        LL_I3C_DisableHighKeeperSDA(io)
        return 0
    case 163:
        let result = LL_I3C_IsEnabledHighKeeperSDA(io)
        return result
    case 164:
        LL_I3C_EnableHJAck(io)
        return 0
    case 165:
        LL_I3C_DisableHJAck(io)
        return 0
    case 166:
        let result = LL_I3C_IsEnabledHJAck(io)
        return result
    case 167:
        let result = LL_I3C_DMA_GetRegAddr(io, args[0])
        return result
    case 168:
        LL_I3C_EnableDMAReq_RX(io)
        return 0
    case 169:
        LL_I3C_DisableDMAReq_RX(io)
        return 0
    case 170:
        let result = LL_I3C_IsEnabledDMAReq_RX(io)
        return result
    case 171:
        LL_I3C_SetRxFIFOThreshold(io, args[0])
        return 0
    case 172:
        let result = LL_I3C_GetRxFIFOThreshold(io)
        return result
    case 173:
        LL_I3C_EnableDMAReq_TX(io)
        return 0
    case 174:
        LL_I3C_DisableDMAReq_TX(io)
        return 0
    case 175:
        let result = LL_I3C_IsEnabledDMAReq_TX(io)
        return result
    case 176:
        LL_I3C_SetTxFIFOThreshold(io, args[0])
        return 0
    case 177:
        let result = LL_I3C_GetTxFIFOThreshold(io)
        return result
    case 178:
        LL_I3C_EnableDMAReq_Status(io)
        return 0
    case 179:
        LL_I3C_DisableDMAReq_Status(io)
        return 0
    case 180:
        let result = LL_I3C_IsEnabledDMAReq_Status(io)
        return result
    case 181:
        LL_I3C_EnableStatusFIFO(io)
        return 0
    case 182:
        LL_I3C_DisableStatusFIFO(io)
        return 0
    case 183:
        let result = LL_I3C_IsEnabledStatusFIFO(io)
        return result
    case 184:
        LL_I3C_EnableControlFIFO(io)
        return 0
    case 185:
        LL_I3C_DisableControlFIFO(io)
        return 0
    case 186:
        let result = LL_I3C_IsEnabledControlFIFO(io)
        return result
    case 187:
        LL_I3C_EnableDMAReq_Control(io)
        return 0
    case 188:
        LL_I3C_DisableDMAReq_Control(io)
        return 0
    case 189:
        let result = LL_I3C_IsEnabledDMAReq_Control(io)
        return result
    case 190:
        LL_I3C_EnableOwnDynAddress(io)
        return 0
    case 191:
        LL_I3C_DisableOwnDynAddress(io)
        return 0
    case 192:
        let result = LL_I3C_IsEnabledOwnDynAddress(io)
        return result
    case 193:
        LL_I3C_SetOwnDynamicAddress(io, args[0])
        return 0
    case 194:
        let result = UInt32(LL_I3C_GetOwnDynamicAddress(io))
        return result
    case 195:
        LL_I3C_EnableIBI(io)
        return 0
    case 196:
        LL_I3C_DisableIBI(io)
        return 0
    case 197:
        let result = LL_I3C_IsEnabledIBI(io)
        return result
    case 198:
        LL_I3C_EnableControllerRoleReq(io)
        return 0
    case 199:
        LL_I3C_DisableControllerRoleReq(io)
        return 0
    case 200:
        let result = LL_I3C_IsEnabledControllerRoleReq(io)
        return result
    case 201:
        LL_I3C_EnableHotJoin(io)
        return 0
    case 202:
        LL_I3C_DisableHotJoin(io)
        return 0
    case 203:
        let result = LL_I3C_IsEnabledHotJoin(io)
        return result
    case 204:
        LL_I3C_SetMaxReadLength(io, UInt16(truncatingIfNeeded: args[0]))
        return 0
    case 205:
        let result = LL_I3C_GetMaxReadLength(io)
        return result
    case 206:
        LL_I3C_ConfigNbIBIAddData(io, args[0])
        return 0
    case 207:
        let result = LL_I3C_GetConfigNbIBIAddData(io)
        return result
    case 208:
        LL_I3C_SetMaxWriteLength(io, UInt16(truncatingIfNeeded: args[0]))
        return 0
    case 209:
        let result = LL_I3C_GetMaxWriteLength(io)
        return result
    case 210:
        LL_I3C_ConfigClockWaveForm(io, args[0])
        return 0
    case 211:
        let result = LL_I3C_GetClockWaveForm(io)
        return result
    case 212:
        LL_I3C_SetPeriodClockLowPP(io, args[0])
        return 0
    case 213:
        let result = LL_I3C_GetPeriodClockLowPP(io)
        return result
    case 214:
        LL_I3C_SetPeriodClockHighI3C(io, args[0])
        return 0
    case 215:
        let result = LL_I3C_GetPeriodClockHighI3C(io)
        return result
    case 216:
        LL_I3C_SetPeriodClockLowOD(io, args[0])
        return 0
    case 217:
        let result = LL_I3C_GetPeriodClockLowOD(io)
        return result
    case 218:
        LL_I3C_SetPeriodClockHighI2C(io, args[0])
        return 0
    case 219:
        let result = LL_I3C_GetPeriodClockHighI2C(io)
        return result
    case 220:
        LL_I3C_SetDataHoldTime(io, args[0])
        return 0
    case 221:
        let result = LL_I3C_GetDataHoldTime(io)
        return result
    case 222:
        LL_I3C_SetAvalTiming(io, args[0])
        return 0
    case 223:
        let result = LL_I3C_GetAvalTiming(io)
        return result
    case 224:
        LL_I3C_SetFreeTiming(io, args[0])
        return 0
    case 225:
        let result = LL_I3C_GetFreeTiming(io)
        return result
    case 226:
        LL_I3C_SetControllerActivityState(io, args[0])
        return 0
    case 227:
        let result = LL_I3C_GetControllerActivityState(io)
        return result
    case 228:
        LL_I3C_SetCtrlBusCharacteristic(io, args[0])
        return 0
    case 229:
        let result = LL_I3C_GetCtrlBusCharacteristic(io)
        return result
    case 230:
        LL_I3C_SetTgtBusCharacteristic(io, args[0])
        return 0
    case 231:
        let result = LL_I3C_GetTgtBusCharacteristic(io)
        return result
    case 232:
        LL_I3C_SetStallTime(io, args[0])
        return 0
    case 233:
        let result = LL_I3C_GetStallTime(io)
        return result
    case 234:
        LL_I3C_EnableStallACK(io)
        return 0
    case 235:
        LL_I3C_DisableStallACK(io)
        return 0
    case 236:
        let result = LL_I3C_IsEnabledStallACK(io)
        return result
    case 237:
        LL_I3C_EnableStallParityCCC(io)
        return 0
    case 238:
        LL_I3C_DisableStallParityCCC(io)
        return 0
    case 239:
        let result = LL_I3C_IsEnabledStallParityCCC(io)
        return result
    case 240:
        LL_I3C_EnableStallParityData(io)
        return 0
    case 241:
        LL_I3C_DisableStallParityData(io)
        return 0
    case 242:
        let result = LL_I3C_IsEnabledStallParityData(io)
        return result
    case 243:
        LL_I3C_EnableStallTbit(io)
        return 0
    case 244:
        LL_I3C_DisableStallTbit(io)
        return 0
    case 245:
        let result = LL_I3C_IsEnabledStallTbit(io)
        return result
    case 246:
        LL_I3C_SetDeviceCapabilityOnBus(io, args[0])
        return 0
    case 247:
        let result = LL_I3C_GetDeviceCapabilityOnBus(io)
        return result
    case 248:
        LL_I3C_SetDeviceIBIPayload(io, args[0])
        return 0
    case 249:
        let result = LL_I3C_GetDeviceIBIPayload(io)
        return result
    case 250:
        LL_I3C_SetDataSpeedLimitation(io, args[0])
        return 0
    case 251:
        let result = LL_I3C_GetDataSpeedLimitation(io)
        return result
    case 252:
        LL_I3C_SetDeviceCharacteristics(io, args[0])
        return 0
    case 253:
        let result = LL_I3C_GetDeviceCharacteristics(io)
        return result
    case 254:
        LL_I3C_SetPendingReadMDB(io, args[0])
        return 0
    case 255:
        let result = LL_I3C_GetPendingReadMDB(io)
        return result
    case 256:
        LL_I3C_SetGrpAddrHandoffSupport(io, args[0])
        return 0
    case 257:
        let result = LL_I3C_GetGrpAddrHandoffSupport(io)
        return result
    case 258:
        LL_I3C_SetControllerHandoffDelayed(io, args[0])
        return 0
    case 259:
        let result = LL_I3C_GetControllerHandoffDelayed(io)
        return result
    case 260:
        LL_I3C_SetHandoffActivityState(io, args[0])
        return 0
    case 261:
        let result = LL_I3C_GetHandoffActivityState(io)
        return result
    case 262:
        LL_I3C_SetMaxDataSpeedFormat(io, args[0])
        return 0
    case 263:
        let result = LL_I3C_GetMaxDataSpeedFormat(io)
        return result
    case 264:
        LL_I3C_SetMiddleByteTurnAround(io, args[0])
        return 0
    case 265:
        let result = LL_I3C_GetMiddleByteTurnAround(io)
        return result
    case 266:
        LL_I3C_SetDataTurnAroundTime(io, args[0])
        return 0
    case 267:
        let result = LL_I3C_GetDataTurnAroundTime(io)
        return result
    case 268:
        LL_I3C_SetMIPIInstanceID(io, args[0])
        return 0
    case 269:
        let result = LL_I3C_GetMIPIInstanceID(io)
        return result
    case 270:
        let result = LL_I3C_GetIDTypeSelector(io)
        return result
    case 271:
        let result = LL_I3C_GetMIPIManufacturerID(io)
        return result
    case 272:
        LL_I3C_RequestRxFIFOFlush(io)
        return 0
    case 273:
        LL_I3C_RequestTxFIFOFlush(io)
        return 0
    case 274:
        LL_I3C_RequestStatusFIFOFlush(io)
        return 0
    case 275:
        let result = LL_I3C_GetActivityState(io)
        return result
    case 276:
        let result = LL_I3C_GetResetAction(io)
        return result
    case 277:
        LL_I3C_RequestControlFIFOFlush(io)
        return 0
    case 278:
        LL_I3C_RequestTransfer(io)
        return 0
    case 279:
        LL_I3C_ControllerHandleMessage(io, args[0], args[1], args[2], args[3], args[4])
        return 0
    case 280:
        LL_I3C_ControllerHandleCCC(io, args[0], args[1], args[2])
        return 0
    case 281:
        LL_I3C_TargetHandleMessage(io, args[0], args[1])
        return 0
    case 282:
        let result = UInt32(LL_I3C_ReceiveData8(io))
        return result
    case 283:
        LL_I3C_TransmitData8(io, UInt8(truncatingIfNeeded: args[0]))
        return 0
    case 284:
        let result = LL_I3C_ReceiveData32(io)
        return result
    case 285:
        LL_I3C_TransmitData32(io, args[0])
        return 0
    case 286:
        LL_I3C_SetIBIPayload(io, args[0])
        return 0
    case 287:
        let result = LL_I3C_GetIBIPayload(io)
        return result
    case 288:
        let result = LL_I3C_GetNbIBIAddData(io)
        return result
    case 289:
        let result = LL_I3C_GetIBITargetAddr(io)
        return result
    case 290:
        LL_I3C_ConfigTxPreload(io, UInt16(truncatingIfNeeded: args[0]))
        return 0
    case 291:
        let result = LL_I3C_IsActiveTxPreload(io)
        return result
    case 292:
        let result = UInt32(LL_I3C_GetTxPreloadDataCount(io))
        return result
    case 293:
        let result = LL_I3C_GetXferDataCount(io)
        return result
    case 294:
        let result = LL_I3C_IsTargetAbortPrivateRead(io)
        return result
    case 295:
        let result = LL_I3C_GetMessageDirection(io)
        return result
    case 296:
        let result = LL_I3C_GetMessageIdentifier(io)
        return result
    case 297:
        let result = LL_I3C_GetMessageErrorCode(io)
        return result
    case 298:
        let result = LL_I3C_GetReceiveCommandCode(io)
        return result
    case 299:
        LL_I3C_SetTargetDynamicAddress(io, args[0], args[1])
        return 0
    case 300:
        let result = LL_I3C_GetTargetDynamicAddress(io, args[0])
        return result
    case 301:
        LL_I3C_EnableTargetIBIAck(io, args[0])
        return 0
    case 302:
        LL_I3C_DisableTargetIBIAck(io, args[0])
        return 0
    case 303:
        let result = LL_I3C_IsEnabledTargetIBIAck(io, args[0])
        return result
    case 304:
        LL_I3C_EnableTargetCRAck(io, args[0])
        return 0
    case 305:
        LL_I3C_DisableTargetCRAck(io, args[0])
        return 0
    case 306:
        let result = LL_I3C_IsEnabledTargetCRAck(io, args[0])
        return result
    case 307:
        LL_I3C_EnableIBIAddData(io, args[0])
        return 0
    case 308:
        LL_I3C_DisableIBIAddData(io, args[0])
        return 0
    case 309:
        let result = LL_I3C_IsEnabledIBIAddData(io, args[0])
        return result
    case 310:
        LL_I3C_EnableFrameSuspend(io, args[0])
        return 0
    case 311:
        LL_I3C_DisableFrameSuspend(io, args[0])
        return 0
    case 312:
        let result = LL_I3C_IsFrameMustBeSuspended(io, args[0])
        return result
    case 313:
        let result = LL_I3C_IsAllowedPayloadUpdate(io, args[0])
        return result
    case 314:
        LL_I3C_ConfigDeviceCapabilities(io, args[0], args[1], args[2], args[3], args[4])
        return 0
    case 315:
        let result = LL_I3C_IsActiveFlag_CFE(io)
        return result
    case 316:
        let result = LL_I3C_IsActiveFlag_TXFE(io)
        return result
    case 317:
        let result = LL_I3C_IsActiveFlag_CFNF(io)
        return result
    case 318:
        let result = LL_I3C_IsActiveFlag_SFNE(io)
        return result
    case 319:
        let result = LL_I3C_IsActiveFlag_TXFNF(io)
        return result
    case 320:
        let result = LL_I3C_IsActiveFlag_RXFNE(io)
        return result
    case 321:
        let result = LL_I3C_IsActiveFlag_RXLAST(io)
        return result
    case 322:
        let result = LL_I3C_IsActiveFlag_TXLAST(io)
        return result
    case 323:
        let result = LL_I3C_IsActiveFlag_FC(io)
        return result
    case 324:
        let result = LL_I3C_IsActiveFlag_RXTGTEND(io)
        return result
    case 325:
        let result = LL_I3C_IsActiveFlag_ERR(io)
        return result
    case 326:
        let result = LL_I3C_IsActiveFlag_IBI(io)
        return result
    case 327:
        let result = LL_I3C_IsActiveFlag_IBIEND(io)
        return result
    case 328:
        let result = LL_I3C_IsActiveFlag_CR(io)
        return result
    case 329:
        let result = LL_I3C_IsActiveFlag_CRUPD(io)
        return result
    case 330:
        let result = LL_I3C_IsActiveFlag_HJ(io)
        return result
    case 331:
        let result = LL_I3C_IsActiveFlag_WKP(io)
        return result
    case 332:
        let result = LL_I3C_IsActiveFlag_GET(io)
        return result
    case 333:
        let result = LL_I3C_IsActiveFlag_STA(io)
        return result
    case 334:
        let result = LL_I3C_IsActiveFlag_DAUPD(io)
        return result
    case 335:
        let result = LL_I3C_IsActiveFlag_MWLUPD(io)
        return result
    case 336:
        let result = LL_I3C_IsActiveFlag_MRLUPD(io)
        return result
    case 337:
        let result = LL_I3C_IsActiveFlag_RST(io)
        return result
    case 338:
        let result = LL_I3C_IsActiveFlag_ASUPD(io)
        return result
    case 339:
        let result = LL_I3C_IsActiveFlag_INTUPD(io)
        return result
    case 340:
        let result = LL_I3C_IsActiveFlag_DEF(io)
        return result
    case 341:
        let result = LL_I3C_IsActiveFlag_GRP(io)
        return result
    case 342:
        let result = LL_I3C_IsActiveFlag_PERR(io)
        return result
    case 343:
        let result = LL_I3C_IsActiveFlag_STALL(io)
        return result
    case 344:
        let result = LL_I3C_IsActiveFlag_DOVR(io)
        return result
    case 345:
        let result = LL_I3C_IsActiveFlag_COVR(io)
        return result
    case 346:
        let result = LL_I3C_IsActiveFlag_ANACK(io)
        return result
    case 347:
        let result = LL_I3C_IsActiveFlag_DNACK(io)
        return result
    case 348:
        let result = LL_I3C_IsActiveFlag_DERR(io)
        return result
    case 349:
        LL_I3C_EnableIT_CFNF(io)
        return 0
    case 350:
        LL_I3C_DisableIT_CFNF(io)
        return 0
    case 351:
        let result = LL_I3C_IsEnabledIT_CFNF(io)
        return result
    case 352:
        LL_I3C_EnableIT_SFNE(io)
        return 0
    case 353:
        LL_I3C_DisableIT_SFNE(io)
        return 0
    case 354:
        let result = LL_I3C_IsEnabledIT_SFNE(io)
        return result
    case 355:
        LL_I3C_EnableIT_TXFNF(io)
        return 0
    case 356:
        LL_I3C_DisableIT_TXFNF(io)
        return 0
    case 357:
        let result = LL_I3C_IsEnabledIT_TXFNF(io)
        return result
    case 358:
        LL_I3C_EnableIT_RXFNE(io)
        return 0
    case 359:
        LL_I3C_DisableIT_RXFNE(io)
        return 0
    case 360:
        let result = LL_I3C_IsEnabledIT_RXFNE(io)
        return result
    case 361:
        LL_I3C_EnableIT_FC(io)
        return 0
    case 362:
        LL_I3C_DisableIT_FC(io)
        return 0
    case 363:
        let result = LL_I3C_IsEnabledIT_FC(io)
        return result
    case 364:
        LL_I3C_EnableIT_RXTGTEND(io)
        return 0
    case 365:
        LL_I3C_DisableIT_RXTGTEND(io)
        return 0
    case 366:
        let result = LL_I3C_IsEnabledIT_RXTGTEND(io)
        return result
    case 367:
        LL_I3C_EnableIT_ERR(io)
        return 0
    case 368:
        LL_I3C_DisableIT_ERR(io)
        return 0
    case 369:
        let result = LL_I3C_IsEnabledIT_ERR(io)
        return result
    case 370:
        LL_I3C_EnableIT_IBI(io)
        return 0
    case 371:
        LL_I3C_DisableIT_IBI(io)
        return 0
    case 372:
        let result = LL_I3C_IsEnabledIT_IBI(io)
        return result
    case 373:
        LL_I3C_EnableIT_IBIEND(io)
        return 0
    case 374:
        LL_I3C_DisableIT_IBIEND(io)
        return 0
    case 375:
        let result = LL_I3C_IsEnabledIT_IBIEND(io)
        return result
    case 376:
        LL_I3C_EnableIT_CR(io)
        return 0
    case 377:
        LL_I3C_DisableIT_CR(io)
        return 0
    case 378:
        let result = LL_I3C_IsEnabledIT_CR(io)
        return result
    case 379:
        LL_I3C_EnableIT_CRUPD(io)
        return 0
    case 380:
        LL_I3C_DisableIT_CRUPD(io)
        return 0
    case 381:
        let result = LL_I3C_IsEnabledIT_CRUPD(io)
        return result
    case 382:
        LL_I3C_EnableIT_HJ(io)
        return 0
    case 383:
        LL_I3C_DisableIT_HJ(io)
        return 0
    case 384:
        let result = LL_I3C_IsEnabledIT_HJ(io)
        return result
    case 385:
        LL_I3C_EnableIT_WKP(io)
        return 0
    case 386:
        LL_I3C_DisableIT_WKP(io)
        return 0
    case 387:
        let result = LL_I3C_IsEnabledIT_WKP(io)
        return result
    case 388:
        LL_I3C_EnableIT_GET(io)
        return 0
    case 389:
        LL_I3C_DisableIT_GET(io)
        return 0
    case 390:
        let result = LL_I3C_IsEnabledIT_GET(io)
        return result
    case 391:
        LL_I3C_EnableIT_STA(io)
        return 0
    case 392:
        LL_I3C_DisableIT_STA(io)
        return 0
    case 393:
        let result = LL_I3C_IsEnabledIT_STA(io)
        return result
    case 394:
        LL_I3C_EnableIT_DAUPD(io)
        return 0
    case 395:
        LL_I3C_DisableIT_DAUPD(io)
        return 0
    case 396:
        let result = LL_I3C_IsEnabledIT_DAUPD(io)
        return result
    case 397:
        LL_I3C_EnableIT_MWLUPD(io)
        return 0
    case 398:
        LL_I3C_DisableIT_MWLUPD(io)
        return 0
    case 399:
        let result = LL_I3C_IsEnabledIT_MWLUPD(io)
        return result
    case 400:
        LL_I3C_EnableIT_MRLUPD(io)
        return 0
    case 401:
        LL_I3C_DisableIT_MRLUPD(io)
        return 0
    case 402:
        let result = LL_I3C_IsEnabledIT_MRLUPD(io)
        return result
    case 403:
        LL_I3C_EnableIT_RST(io)
        return 0
    case 404:
        LL_I3C_DisableIT_RST(io)
        return 0
    case 405:
        let result = LL_I3C_IsEnabledIT_RST(io)
        return result
    case 406:
        LL_I3C_EnableIT_ASUPD(io)
        return 0
    case 407:
        LL_I3C_DisableIT_ASUPD(io)
        return 0
    case 408:
        let result = LL_I3C_IsEnabledIT_ASUPD(io)
        return result
    case 409:
        LL_I3C_EnableIT_INTUPD(io)
        return 0
    case 410:
        LL_I3C_DisableIT_INTUPD(io)
        return 0
    case 411:
        let result = LL_I3C_IsEnabledIT_INTUPD(io)
        return result
    case 412:
        LL_I3C_EnableIT_DEF(io)
        return 0
    case 413:
        LL_I3C_DisableIT_DEF(io)
        return 0
    case 414:
        let result = LL_I3C_IsEnabledIT_DEF(io)
        return result
    case 415:
        LL_I3C_EnableIT_GRP(io)
        return 0
    case 416:
        LL_I3C_DisableIT_GRP(io)
        return 0
    case 417:
        let result = LL_I3C_IsEnabledIT_GRP(io)
        return result
    case 418:
        LL_I3C_ClearFlag_FC(io)
        return 0
    case 419:
        LL_I3C_ClearFlag_RXTGTEND(io)
        return 0
    case 420:
        LL_I3C_ClearFlag_ERR(io)
        return 0
    case 421:
        LL_I3C_ClearFlag_IBI(io)
        return 0
    case 422:
        LL_I3C_ClearFlag_IBIEND(io)
        return 0
    case 423:
        LL_I3C_ClearFlag_CR(io)
        return 0
    case 424:
        LL_I3C_ClearFlag_CRUPD(io)
        return 0
    case 425:
        LL_I3C_ClearFlag_HJ(io)
        return 0
    case 426:
        LL_I3C_ClearFlag_WKP(io)
        return 0
    case 427:
        LL_I3C_ClearFlag_GET(io)
        return 0
    case 428:
        LL_I3C_ClearFlag_STA(io)
        return 0
    case 429:
        LL_I3C_ClearFlag_DAUPD(io)
        return 0
    case 430:
        LL_I3C_ClearFlag_MWLUPD(io)
        return 0
    case 431:
        LL_I3C_ClearFlag_MRLUPD(io)
        return 0
    case 432:
        LL_I3C_ClearFlag_RST(io)
        return 0
    case 433:
        LL_I3C_ClearFlag_ASUPD(io)
        return 0
    case 434:
        LL_I3C_ClearFlag_INTUPD(io)
        return 0
    case 435:
        LL_I3C_ClearFlag_DEF(io)
        return 0
    case 436:
        LL_I3C_ClearFlag_GRP(io)
        return 0
    case 437:
        let result = LL_I3C_DeInit(&bus).rawValue
        return result
    case 438:
        var v1 = LL_I3C_InitTypeDef()
        v1.CtrlBusCharacteristic.SDAHoldTime = args[0]
        v1.CtrlBusCharacteristic.WaitTime = args[1]
        v1.CtrlBusCharacteristic.SCLPPLowDuration = UInt8(truncatingIfNeeded: args[2])
        v1.CtrlBusCharacteristic.SCLI3CHighDuration = UInt8(truncatingIfNeeded: args[3])
        v1.CtrlBusCharacteristic.SCLODLowDuration = UInt8(truncatingIfNeeded: args[4])
        v1.CtrlBusCharacteristic.SCLI2CHighDuration = UInt8(truncatingIfNeeded: args[5])
        v1.CtrlBusCharacteristic.BusFreeDuration = UInt8(truncatingIfNeeded: args[6])
        v1.CtrlBusCharacteristic.BusIdleDuration = UInt8(truncatingIfNeeded: args[7])
        v1.TgtBusCharacteristic.BusAvailableDuration = UInt8(truncatingIfNeeded: args[8])
        let result = LL_I3C_Init(io, &v1, args[9]).rawValue
        io.cells[384] = UInt32(v1.CtrlBusCharacteristic.SDAHoldTime)
        io.cells[385] = UInt32(v1.CtrlBusCharacteristic.WaitTime)
        io.cells[386] = UInt32(v1.CtrlBusCharacteristic.SCLPPLowDuration)
        io.cells[387] = UInt32(v1.CtrlBusCharacteristic.SCLI3CHighDuration)
        io.cells[388] = UInt32(v1.CtrlBusCharacteristic.SCLODLowDuration)
        io.cells[389] = UInt32(v1.CtrlBusCharacteristic.SCLI2CHighDuration)
        io.cells[390] = UInt32(v1.CtrlBusCharacteristic.BusFreeDuration)
        io.cells[391] = UInt32(v1.CtrlBusCharacteristic.BusIdleDuration)
        io.cells[392] = UInt32(v1.TgtBusCharacteristic.BusAvailableDuration)
        return result
    case 439:
        var v0 = LL_I3C_InitTypeDef()
        v0.CtrlBusCharacteristic.SDAHoldTime = args[0]
        v0.CtrlBusCharacteristic.WaitTime = args[1]
        v0.CtrlBusCharacteristic.SCLPPLowDuration = UInt8(truncatingIfNeeded: args[2])
        v0.CtrlBusCharacteristic.SCLI3CHighDuration = UInt8(truncatingIfNeeded: args[3])
        v0.CtrlBusCharacteristic.SCLODLowDuration = UInt8(truncatingIfNeeded: args[4])
        v0.CtrlBusCharacteristic.SCLI2CHighDuration = UInt8(truncatingIfNeeded: args[5])
        v0.CtrlBusCharacteristic.BusFreeDuration = UInt8(truncatingIfNeeded: args[6])
        v0.CtrlBusCharacteristic.BusIdleDuration = UInt8(truncatingIfNeeded: args[7])
        v0.TgtBusCharacteristic.BusAvailableDuration = UInt8(truncatingIfNeeded: args[8])
        LL_I3C_StructInit(&v0)
        io.cells[384] = UInt32(v0.CtrlBusCharacteristic.SDAHoldTime)
        io.cells[385] = UInt32(v0.CtrlBusCharacteristic.WaitTime)
        io.cells[386] = UInt32(v0.CtrlBusCharacteristic.SCLPPLowDuration)
        io.cells[387] = UInt32(v0.CtrlBusCharacteristic.SCLI3CHighDuration)
        io.cells[388] = UInt32(v0.CtrlBusCharacteristic.SCLODLowDuration)
        io.cells[389] = UInt32(v0.CtrlBusCharacteristic.SCLI2CHighDuration)
        io.cells[390] = UInt32(v0.CtrlBusCharacteristic.BusFreeDuration)
        io.cells[391] = UInt32(v0.CtrlBusCharacteristic.BusIdleDuration)
        io.cells[392] = UInt32(v0.TgtBusCharacteristic.BusAvailableDuration)
        return 0
    case 440:
        LL_I2C_WriteReg(io, .cr2, args[0])
        return LL_I2C_ReadReg(io, .cr2)
    case 441:
        LL_I3C_WriteReg(io, .timingr1, args[0])
        return LL_I3C_ReadReg(io, .timingr1)
    default: preconditionFailure("Unknown operation")
    }
}
final class LLI2CDifferentialTests: XCTestCase {
    @discardableResult private func compare(
        _ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0, instance: UInt32 = 0,
        file: StaticString = #filePath, line: UInt = #line
    ) -> LLI2CImage {
        let c = CL56_Create()!
        defer { CL56_Destroy(c) }
        CL56_Reset(c, seed, salt, instance)
        let io = LLI2CImage(seed, salt, instance)
        let sr = runLLI2C(op, io, args)
        let cr = CL56_Run(c, UInt32(op), args)
        let context = "op=\(op) seed=\(seed) salt=\(salt) instance=\(instance) args=\(args)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL56_GetCells(c), count: 512)
        for i in cells.indices where cells[i] != io.cells[i] {
            XCTFail("\(context) cell \(i): Swift \(io.cells[i]), C \(cells[i])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL56_GetTrace(c), count: Int(CL56_GetTraceCount(c)))
        XCTAssertEqual(
            io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file,
            line: line)
        return io
    }
    func testEveryFunctionWithChangingReadsAndAllInstances() {
        for op in 0..<440 {
            for instance: UInt32 in 0..<(op < 146 ? 4 : 1) {
                for sample: UInt32 in 0..<32 {
                    let seed = sample &* 0x9E37_79B9
                    var args = (0..<16).map { seed ^ (UInt32($0) &* 0x1020_4081) }
                    if op == 299 { args[0] = 1 + sample % 4 }
                    if op == 300 { args[0] = 1 + sample % 4 }
                    if op == 301 { args[0] = 1 + sample % 4 }
                    if op == 302 { args[0] = 1 + sample % 4 }
                    if op == 303 { args[0] = 1 + sample % 4 }
                    if op == 304 { args[0] = 1 + sample % 4 }
                    if op == 305 { args[0] = 1 + sample % 4 }
                    if op == 306 { args[0] = 1 + sample % 4 }
                    if op == 307 { args[0] = 1 + sample % 4 }
                    if op == 308 { args[0] = 1 + sample % 4 }
                    if op == 309 { args[0] = 1 + sample % 4 }
                    if op == 310 { args[0] = 1 + sample % 4 }
                    if op == 311 { args[0] = 1 + sample % 4 }
                    if op == 312 { args[0] = 1 + sample % 4 }
                    if op == 313 { args[0] = 1 + sample % 4 }
                    if op == 314 { args[0] = 1 + sample % 4 }
                    compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x1020_4081, instance: instance)
                }
            }
        }
    }
    func testI2CTransferSizeRequestAndAddressBoundaries() {
        let sizes: [UInt32] = [0, 1, 2, 127, 128, 254, 255, 256, 257, 65535, 65536, .max]
        let requests: [UInt32] = [
            LL_I2C_GENERATE_NOSTARTSTOP, LL_I2C_GENERATE_STOP, LL_I2C_GENERATE_START_READ, LL_I2C_GENERATE_START_WRITE,
            LL_I2C_GENERATE_RESTART_10BIT_READ, 0x400, 0x8000_0000, 0x7FFF_FFFF, .max,
        ]
        for instance: UInt32 in 0..<4 {
            for size in sizes {
                for request in requests {
                    for end: UInt32 in [LL_I2C_MODE_RELOAD, LL_I2C_MODE_AUTOEND, LL_I2C_MODE_SOFTEND] {
                        for addressSize: UInt32 in [LL_I2C_ADDRSLAVE_7BIT, LL_I2C_ADDRSLAVE_10BIT] {
                            compare(
                                135, [0xFEDC_BA98, addressSize, size, end, request], seed: 0xA5A5_A5A5,
                                salt: 0x1020_4081, instance: instance)
                        }
                    }
                }
            }
        }
    }
    func testI2CInitializationModesFiltersAndOwnAddress() {
        let modes: [UInt32] = [
            LL_I2C_MODE_I2C, LL_I2C_MODE_SMBUS_HOST, LL_I2C_MODE_SMBUS_DEVICE, LL_I2C_MODE_SMBUS_DEVICE_ARP,
        ]
        for instance: UInt32 in 0..<4 {
            for mode in modes {
                for own: UInt32 in [0, 0xA4, 0x3FF] {
                    for addressSize: UInt32 in [LL_I2C_OWNADDRESS1_7BIT, LL_I2C_OWNADDRESS1_10BIT] {
                        for analog: UInt32 in [LL_I2C_ANALOGFILTER_ENABLE, LL_I2C_ANALOGFILTER_DISABLE] {
                            for digital: UInt32 in [0, 1, 15, .max] {
                                for seed: UInt32 in [0, 1] {
                                    compare(
                                        144, [mode, 0x1031_1720, analog, digital, own, LL_I2C_NACK, addressSize],
                                        seed: seed, instance: instance)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func testI3CNestedByteFieldsAndControllerTargetBranches() {
        let values: [UInt32] = [0, 1, 127, 128, 255, 256, 511, 65535, 65536, .max]
        for value in values {
            for mode: UInt32 in [LL_I3C_MODE_CONTROLLER, LL_I3C_MODE_TARGET, 1, 3, .max] {
                for seed: UInt32 in [0, 1, .max] {
                    let args: [UInt32] = [
                        0, 0, value, value &+ 1, value &+ 2, value &+ 3, value &+ 4, value &+ 5, value &+ 6, mode,
                    ]
                    compare(438, args, seed: seed, salt: 0x1020_4081)
                }
            }
        }
    }
    func testI3CDeviceTableSlotsAndWideInputFields() {
        let operations: [Int] = [299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314]
        for op in operations {
            for target: UInt32 in 1...4 {
                for sample: UInt32 in 0..<16 {
                    let seed = sample &* 0x9E37_79B9
                    var args = (0..<16).map { seed ^ (UInt32($0) &* 0x1020_4081) }
                    args[0] = target
                    compare(op, args, seed: seed, salt: 0x1020_4081)
                }
            }
        }
    }
    func testNarrowArgumentsAndRawRegisterMacros() {
        let values: [UInt32] = [0, 1, 127, 128, 255, 256, 511, 65535, 65536, 0x1234_5678, 0x8000_0000, .max]
        for op in [142, 204, 208, 283, 290] {
            for value in values {
                for salt: UInt32 in [0, 0x1020_4081] { compare(op, [value], seed: 0xA5A5_A5A5, salt: salt) }
            }
        }
        for instance: UInt32 in 0..<4 {
            for sample: UInt32 in 0..<32 {
                let value = sample &* 0x9E37_79B9
                compare(440, [value], seed: ~value, salt: 0x1020_4081, instance: instance)
            }
        }
        for sample: UInt32 in 0..<32 {
            let value = sample &* 0x9E37_79B9
            compare(441, [value], seed: ~value, salt: 0x1020_4081)
        }
    }
    func testIndependentAccessWidthControlBitsAndNestedPacking() {
        let io = LLI2CImage(0, 0, 0)
        io.cells[6] = 0x8000_0000
        LL_I2C_ClearFlag_TXE(io)
        XCTAssertEqual(io.trace, [.init(index: 6, value: 1, kind: 1)])
        io.trace.removeAll()
        LL_I2C_TransmitData8(io, 0xAB)
        LL_I3C_TransmitData8(io, 0xCD)
        XCTAssertEqual(io.trace, [.init(index: 10, value: 0xAB, kind: 1), .init(index: 70, value: 0xCD, kind: 1)])
        io.cells[1] = 0x400
        LL_I2C_HandleTransfer(io, 0xA4, LL_I2C_ADDRSLAVE_7BIT, 256, LL_I2C_MODE_SOFTEND, LL_I2C_GENERATE_NOSTARTSTOP)
        XCTAssertEqual(io.cells[1] & 0x400, 0x400)
        XCTAssertEqual(io.cells[1] & 0xFF0000, 0)
        LL_I2C_HandleTransfer(io, 0xA4, LL_I2C_ADDRSLAVE_7BIT, 1, LL_I2C_MODE_SOFTEND, LL_I2C_GENERATE_START_WRITE)
        XCTAssertEqual(io.cells[1] & 0x8000_0400, 0)
        var config = LL_I3C_InitTypeDef()
        LL_I3C_StructInit(&config)
        config.CtrlBusCharacteristic.SDAHoldTime = 0
        config.CtrlBusCharacteristic.WaitTime = 0
        config.CtrlBusCharacteristic.SCLPPLowDuration = 0x12
        config.CtrlBusCharacteristic.SCLI3CHighDuration = 0x34
        config.CtrlBusCharacteristic.SCLODLowDuration = 0x56
        config.CtrlBusCharacteristic.SCLI2CHighDuration = 0x78
        config.CtrlBusCharacteristic.BusFreeDuration = 0x56
        config.CtrlBusCharacteristic.BusIdleDuration = 0x78
        io.cells[65] = 0
        io.cells[104] = 0
        io.cells[105] = 0
        XCTAssertEqual(LL_I3C_Init(io, &config, LL_I3C_MODE_CONTROLLER), .success)
        XCTAssertEqual(io.cells[104], 0x7856_3412)
        XCTAssertEqual(io.cells[105], 0x560078)
        XCTAssertEqual(io.cells[65] & 3, 3)
        for target: UInt32 in 1...4 {
            io.cells[88 + Int(target)] = 0
            LL_I3C_SetTargetDynamicAddress(io, target, 0x52)
            XCTAssertEqual(io.cells[88 + Int(target)], 0xA4)
        }
    }
    func testPinnedConstants() {
        let constants: [UInt32] = [
            LL_I2C_ICR_ADDRCF,
            LL_I2C_ICR_NACKCF,
            LL_I2C_ICR_STOPCF,
            LL_I2C_ICR_BERRCF,
            LL_I2C_ICR_ARLOCF,
            LL_I2C_ICR_OVRCF,
            LL_I2C_ICR_PECCF,
            LL_I2C_ICR_TIMOUTCF,
            LL_I2C_ICR_ALERTCF,
            LL_I2C_ISR_TXE,
            LL_I2C_ISR_TXIS,
            LL_I2C_ISR_RXNE,
            LL_I2C_ISR_ADDR,
            LL_I2C_ISR_NACKF,
            LL_I2C_ISR_STOPF,
            LL_I2C_ISR_TC,
            LL_I2C_ISR_TCR,
            LL_I2C_ISR_BERR,
            LL_I2C_ISR_ARLO,
            LL_I2C_ISR_OVR,
            LL_I2C_ISR_PECERR,
            LL_I2C_ISR_TIMEOUT,
            LL_I2C_ISR_ALERT,
            LL_I2C_ISR_BUSY,
            LL_I2C_CR1_TXIE,
            LL_I2C_CR1_RXIE,
            LL_I2C_CR1_ADDRIE,
            LL_I2C_CR1_NACKIE,
            LL_I2C_CR1_STOPIE,
            LL_I2C_CR1_TCIE,
            LL_I2C_CR1_ERRIE,
            LL_I2C_MODE_I2C,
            LL_I2C_MODE_SMBUS_HOST,
            LL_I2C_MODE_SMBUS_DEVICE,
            LL_I2C_MODE_SMBUS_DEVICE_ARP,
            LL_I2C_ANALOGFILTER_ENABLE,
            LL_I2C_ANALOGFILTER_DISABLE,
            LL_I2C_ADDRESSING_MODE_7BIT,
            LL_I2C_ADDRESSING_MODE_10BIT,
            LL_I2C_OWNADDRESS1_7BIT,
            LL_I2C_OWNADDRESS1_10BIT,
            LL_I2C_OWNADDRESS2_NOMASK,
            LL_I2C_OWNADDRESS2_MASK01,
            LL_I2C_OWNADDRESS2_MASK02,
            LL_I2C_OWNADDRESS2_MASK03,
            LL_I2C_OWNADDRESS2_MASK04,
            LL_I2C_OWNADDRESS2_MASK05,
            LL_I2C_OWNADDRESS2_MASK06,
            LL_I2C_OWNADDRESS2_MASK07,
            LL_I2C_ACK,
            LL_I2C_NACK,
            LL_I2C_ADDRSLAVE_7BIT,
            LL_I2C_ADDRSLAVE_10BIT,
            LL_I2C_REQUEST_WRITE,
            LL_I2C_REQUEST_READ,
            LL_I2C_MODE_RELOAD,
            LL_I2C_MODE_AUTOEND,
            LL_I2C_MODE_SOFTEND,
            LL_I2C_MODE_SMBUS_RELOAD,
            LL_I2C_MODE_SMBUS_AUTOEND_NO_PEC,
            LL_I2C_MODE_SMBUS_SOFTEND_NO_PEC,
            LL_I2C_MODE_SMBUS_AUTOEND_WITH_PEC,
            LL_I2C_MODE_SMBUS_SOFTEND_WITH_PEC,
            LL_I2C_GENERATE_NOSTARTSTOP,
            LL_I2C_GENERATE_STOP,
            LL_I2C_GENERATE_START_READ,
            LL_I2C_GENERATE_START_WRITE,
            LL_I2C_GENERATE_RESTART_7BIT_READ,
            LL_I2C_GENERATE_RESTART_7BIT_WRITE,
            LL_I2C_GENERATE_RESTART_10BIT_READ,
            LL_I2C_GENERATE_RESTART_10BIT_WRITE,
            LL_I2C_DIRECTION_WRITE,
            LL_I2C_DIRECTION_READ,
            LL_I2C_DMA_REG_DATA_TRANSMIT,
            LL_I2C_DMA_REG_DATA_RECEIVE,
            LL_I2C_SMBUS_TIMEOUTA_MODE_SCL_LOW,
            LL_I2C_SMBUS_TIMEOUTA_MODE_SDA_SCL_HIGH,
            LL_I2C_SMBUS_TIMEOUTA,
            LL_I2C_SMBUS_TIMEOUTB,
            LL_I2C_SMBUS_ALL_TIMEOUT,
            LL_I3C_EVR_CFEF,
            LL_I3C_EVR_TXFEF,
            LL_I3C_EVR_CFNFF,
            LL_I3C_EVR_SFNEF,
            LL_I3C_EVR_TXFNFF,
            LL_I3C_EVR_RXFNEF,
            LL_I3C_EVR_RXLASTF,
            LL_I3C_EVR_TXLASTF,
            LL_I3C_EVR_FCF,
            LL_I3C_EVR_RXTGTENDF,
            LL_I3C_EVR_ERRF,
            LL_I3C_EVR_IBIF,
            LL_I3C_EVR_IBIENDF,
            LL_I3C_EVR_CRF,
            LL_I3C_EVR_CRUPDF,
            LL_I3C_EVR_HJF,
            LL_I3C_EVR_WKPF,
            LL_I3C_EVR_GETF,
            LL_I3C_EVR_STAF,
            LL_I3C_EVR_DAUPDF,
            LL_I3C_EVR_MWLUPDF,
            LL_I3C_EVR_MRLUPDF,
            LL_I3C_EVR_RSTF,
            LL_I3C_EVR_ASUPDF,
            LL_I3C_EVR_INTUPDF,
            LL_I3C_EVR_DEFF,
            LL_I3C_EVR_GRPF,
            LL_I3C_SER_PERR,
            LL_I3C_SER_STALL,
            LL_I3C_SER_DOVR,
            LL_I3C_SER_COVR,
            LL_I3C_SER_ANACK,
            LL_I3C_SER_DNACK,
            LL_I3C_SER_DERR,
            LL_I3C_IER_CFNFIE,
            LL_I3C_IER_SFNEIE,
            LL_I3C_IER_TXFNFIE,
            LL_I3C_IER_RXFNEIE,
            LL_I3C_IER_FCIE,
            LL_I3C_IER_RXTGTENDIE,
            LL_I3C_IER_ERRIE,
            LL_I3C_IER_IBIIE,
            LL_I3C_IER_IBIENDIE,
            LL_I3C_IER_CRIE,
            LL_I3C_IER_CRUPDIE,
            LL_I3C_IER_HJIE,
            LL_I3C_IER_WKPIE,
            LL_I3C_IER_GETIE,
            LL_I3C_IER_STAIE,
            LL_I3C_IER_DAUPDIE,
            LL_I3C_IER_MWLUPDIE,
            LL_I3C_IER_MRLUPDIE,
            LL_I3C_IER_RSTIE,
            LL_I3C_IER_ASUPDIE,
            LL_I3C_IER_INTUPDIE,
            LL_I3C_IER_DEFIE,
            LL_I3C_IER_GRPIE,
            LL_I3C_MODE_CONTROLLER,
            LL_I3C_MODE_TARGET,
            LL_I3C_DMA_REG_DATA_TRANSMIT_BYTE,
            LL_I3C_DMA_REG_DATA_RECEIVE_BYTE,
            LL_I3C_DMA_REG_DATA_TRANSMIT_WORD,
            LL_I3C_DMA_REG_DATA_RECEIVE_WORD,
            LL_I3C_DMA_REG_STATUS,
            LL_I3C_DMA_REG_CONTROL,
            LL_I3C_RXFIFO_THRESHOLD_1_4,
            LL_I3C_RXFIFO_THRESHOLD_4_4,
            LL_I3C_TXFIFO_THRESHOLD_1_4,
            LL_I3C_TXFIFO_THRESHOLD_4_4,
            LL_I3C_PAYLOAD_EMPTY,
            LL_I3C_PAYLOAD_1_BYTE,
            LL_I3C_PAYLOAD_2_BYTES,
            LL_I3C_PAYLOAD_3_BYTES,
            LL_I3C_PAYLOAD_4_BYTES,
            LL_I3C_SDA_HOLD_TIME_0_5,
            LL_I3C_SDA_HOLD_TIME_1_5,
            LL_I3C_OWN_ACTIVITY_STATE_0,
            LL_I3C_OWN_ACTIVITY_STATE_1,
            LL_I3C_OWN_ACTIVITY_STATE_2,
            LL_I3C_OWN_ACTIVITY_STATE_3,
            LL_I3C_DEVICE_ROLE_AS_TARGET,
            LL_I3C_DEVICE_ROLE_AS_CONTROLLER,
            LL_I3C_IBI_NO_ADDITIONAL_DATA,
            LL_I3C_IBI_ADDITIONAL_DATA,
            LL_I3C_NO_DATA_SPEED_LIMITATION,
            LL_I3C_MAX_DATA_SPEED_LIMITATION,
            LL_I3C_MDB_NO_PENDING_READ_NOTIFICATION,
            LL_I3C_MDB_PENDING_READ_NOTIFICATION,
            LL_I3C_HANDOFF_GRP_ADDR_NOT_SUPPORTED,
            LL_I3C_HANDOFF_GRP_ADDR_SUPPORTED,
            LL_I3C_HANDOFF_NOT_DELAYED,
            LL_I3C_HANDOFF_DELAYED,
            LL_I3C_HANDOFF_ACTIVITY_STATE_0,
            LL_I3C_HANDOFF_ACTIVITY_STATE_1,
            LL_I3C_HANDOFF_ACTIVITY_STATE_2,
            LL_I3C_HANDOFF_ACTIVITY_STATE_3,
            LL_I3C_GETMXDS_FORMAT_1,
            LL_I3C_GETMXDS_FORMAT_2_LSB,
            LL_I3C_GETMXDS_FORMAT_2_MID,
            LL_I3C_GETMXDS_FORMAT_2_MSB,
            LL_I3C_TURNAROUND_TIME_TSCO_LESS_12NS,
            LL_I3C_TURNAROUND_TIME_TSCO_GREATER_12NS,
            LL_I3C_BUS_ACTIVITY_STATE_0,
            LL_I3C_BUS_ACTIVITY_STATE_1,
            LL_I3C_BUS_ACTIVITY_STATE_2,
            LL_I3C_BUS_ACTIVITY_STATE_3,
            LL_I3C_RESET_ACTION_NONE,
            LL_I3C_RESET_ACTION_PARTIAL,
            LL_I3C_RESET_ACTION_FULL,
            LL_I3C_DIRECTION_WRITE,
            LL_I3C_DIRECTION_READ,
            LL_I3C_GENERATE_STOP,
            LL_I3C_GENERATE_RESTART,
            LL_I3C_CONTROLLER_MTYPE_RELEASE,
            LL_I3C_CONTROLLER_MTYPE_HEADER,
            LL_I3C_CONTROLLER_MTYPE_PRIVATE,
            LL_I3C_CONTROLLER_MTYPE_DIRECT,
            LL_I3C_CONTROLLER_MTYPE_LEGACY_I2C,
            LL_I3C_CONTROLLER_MTYPE_CCC,
            LL_I3C_TARGET_MTYPE_HOT_JOIN,
            LL_I3C_TARGET_MTYPE_CONTROLLER_ROLE_REQ,
            LL_I3C_TARGET_MTYPE_IBI,
            LL_I3C_MESSAGE_ERROR,
            LL_I3C_MESSAGE_DIRECTION_WRITE,
            LL_I3C_MESSAGE_DIRECTION_READ,
            LL_I3C_CONTROLLER_ERROR_CE0,
            LL_I3C_CONTROLLER_ERROR_CE1,
            LL_I3C_CONTROLLER_ERROR_CE2,
            LL_I3C_CONTROLLER_ERROR_CE3,
            LL_I3C_TARGET_ERROR_TE0,
            LL_I3C_TARGET_ERROR_TE1,
            LL_I3C_TARGET_ERROR_TE2,
            LL_I3C_TARGET_ERROR_TE3,
            LL_I3C_TARGET_ERROR_TE4,
            LL_I3C_TARGET_ERROR_TE5,
            LL_I3C_TARGET_ERROR_TE6,
            LL_I3C_BCR_IN_PAYLOAD_SHIFT,
            LL_I3C_IBI_CAPABILITY,
            LL_I3C_IBI_NO_CAPABILITY,
            LL_I3C_IBI_DATA_ENABLE,
            LL_I3C_IBI_DATA_DISABLE,
            LL_I3C_CR_CAPABILITY,
            LL_I3C_CR_NO_CAPABILITY,
        ]
        for (i, value) in constants.enumerated() { XCTAssertEqual(value, CL56_Constant(UInt32(i))) }
    }
}
