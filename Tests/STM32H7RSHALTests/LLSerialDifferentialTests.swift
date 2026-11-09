import CLLReference
import STM32H7RSHAL
import XCTest

private struct LLSerialAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}
private final class LLSerialImage: UARTRegisterIO, LLRCCRegisterIO {
    var cells: [UInt32]
    var trace: [LLSerialAccess] = []
    var reads: UInt32 = 0
    var failures: UInt32
    let salt: UInt32
    let instanceID: UInt32
    let mode: UInt32
    init(seed: UInt32, salt: UInt32, instance: UInt32, failures: UInt32, mode: UInt32) {
        cells = (0..<1024).map { seed ^ (UInt32($0) &* 0x9E37_79B9) }
        for i in 256..<512 { cells[i] = 0 }
        cells[256] = (mode & 256 != 0 ? 0 : 0x2a02_0124) | (((mode >> 6) & 3) << 3)
        cells[260] = ((mode >> 4) & 3) << 3
        cells[266] = (6 << 4) | (6 << 12) | (6 << 20)
        cells[267] = .max
        cells[268] = 47 | (7 << 9) | (3 << 16) | (3 << 24)
        cells[270] = cells[268]
        cells[272] = cells[268]
        cells[276] = mode & 7
        cells[277] = mode & 7
        cells[278] = mode & 7
        cells[284] = mode & 256 != 0 ? 0 : 2
        self.salt = salt
        self.instanceID = instance
        self.failures = failures
        self.mode = mode
    }
    var instance: UARTInstance {
        let instances: [UARTInstance] = [.usart1, .usart2, .usart3, .uart4, .uart5, .uart7, .uart8, .lpuart1]
        return instances[Int(instanceID)]
    }
    var oscillators: RCCOscillatorValues {
        let d: UInt32 = mode & 512 != 0 ? 17 : 0
        return .init(
            hsi: 64_000_000 + d, csi: 4_000_000 + d, hse: 24_000_000 + d, lse: 32_768 + d, lsi: 32_000 + d,
            hsi48: 48_000_000 + d, external: 12_288_000 + d)
    }
    func readIndex(_ index: Int) -> UInt32 {
        let value = cells[index] ^ (index < 256 ? salt &* reads : 0)
        reads &+= 1
        trace.append(.init(index: UInt32(index), value: value, kind: 0))
        return value
    }
    func writeIndex(_ index: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(index), value: value, kind: 1))
        cells[index] = value
    }
    func uartIndex(_ r: UARTRegister) -> Int {
        let offset: Int
        switch r {
        case .cr1: offset = 0
        case .cr2: offset = 1
        case .cr3: offset = 2
        case .brr: offset = 3
        case .gtpr: offset = 4
        case .rtor: offset = 5
        case .rqr: offset = 6
        case .isr: offset = 7
        case .icr: offset = 8
        case .rdr: offset = 9
        case .tdr: offset = 10
        case .presc: offset = 11
        }
        return Int(instanceID) * 16 + offset
    }
    func read(_ r: UARTRegister) -> UInt32 { readIndex(uartIndex(r)) }
    func write(_ r: UARTRegister, value: UInt32) { writeIndex(uartIndex(r), value) }
    func atomicModify(_ r: UARTRegister, clear: UInt32, set: UInt32) {
        let index = uartIndex(r)
        while true {
            let old = cells[index] ^ (salt &* reads)
            reads &+= 1
            trace.append(.init(index: UInt32(index), value: old, kind: 2))
            let value = (old & ~clear) | set
            if failures != 0 {
                failures &-= 1
                trace.append(.init(index: UInt32(index), value: value, kind: 4))
                cells[index] ^= 0x0101_0101
            } else {
                trace.append(.init(index: UInt32(index), value: value, kind: 3))
                cells[index] = value
                return
            }
        }
    }
    func index(_ r: RCCClockRegister) -> Int {
        switch r {
        case .apbcfgr: return 264
        case .bmcfgr: return 263
        case .cdcfgr: return 262
        case .cfgr: return 260
        case .cr: return 256
        case .pll1divr1: return 268
        case .pll1divr2: return 304
        case .pll1fracr: return 269
        case .pll2divr1: return 270
        case .pll2divr2: return 305
        case .pll2fracr: return 271
        case .pll3divr1: return 272
        case .pll3divr2: return 306
        case .pll3fracr: return 273
        case .pllcfgr: return 267
        case .pllckselr: return 266
        }
    }
    func read(_ r: RCCClockRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: RCCClockRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: RCCExtendedRegister) -> Int {
        switch r {
        case .ccipr1: return 275
        case .ccipr2: return 276
        case .ccipr3: return 277
        case .ccipr4: return 278
        case .ckprotr: return 320
        }
    }
    func read(_ r: RCCExtendedRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: RCCExtendedRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: RCCControlRegister) -> Int {
        switch r {
        case .bdcr: return 284
        case .cicr: return 282
        case .cier: return 280
        case .cifr: return 281
        case .csr: return 285
        case .hsicfgr: return 257
        case .rsr: return 332
        default: preconditionFailure("Unused register")
        }
    }
    func read(_ r: RCCControlRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: RCCControlRegister, value: UInt32) { writeIndex(index(r), value) }
    func index(_ r: LLRCCRegister) -> Int {
        switch r {
        case .crrcr: return 258
        case .csicfgr: return 259
        case .pll1sscgr: return 307
        case .pll2sscgr: return 308
        case .pll3sscgr: return 309
        }
    }
    func read(_ r: LLRCCRegister) -> UInt32 { readIndex(index(r)) }
    func write(_ r: LLRCCRegister, value: UInt32) { writeIndex(index(r), value) }
    func read(_ r: LLBusRegister) -> UInt32 { readIndex(256 + Int(r.rawValue / 4)) }
    func write(_ r: LLBusRegister, value: UInt32) { writeIndex(256 + Int(r.rawValue / 4), value) }
    func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration) {
        preconditionFailure("Unused LL serial operation")
    }
    func read(_ r: FlashTimingRegister) -> UInt32 { preconditionFailure("Unused LL serial register") }
    func write(_ r: FlashTimingRegister, value: UInt32) { preconditionFailure("Unused LL serial register") }
    func read(_ r: EXTIRegister) -> UInt32 { preconditionFailure("Unused LL serial register") }
    func write(_ r: EXTIRegister, value: UInt32) { preconditionFailure("Unused LL serial register") }
}
private func runLLSerial(_ op: Int, _ io: LLSerialImage, _ args: [UInt32]) -> UInt32 {
    var uart = io
    var clocks = io
    switch op {
    case 0:
        LL_USART_Enable(io)
        return 0
    case 1:
        LL_USART_Disable(io)
        return 0
    case 2:
        let result = LL_USART_IsEnabled(io)
        return result
    case 3:
        LL_USART_EnableFIFO(io)
        return 0
    case 4:
        LL_USART_DisableFIFO(io)
        return 0
    case 5:
        let result = LL_USART_IsEnabledFIFO(io)
        return result
    case 6:
        LL_USART_SetTXFIFOThreshold(io, args[0])
        return 0
    case 7:
        let result = LL_USART_GetTXFIFOThreshold(io)
        return result
    case 8:
        LL_USART_SetRXFIFOThreshold(io, args[0])
        return 0
    case 9:
        let result = LL_USART_GetRXFIFOThreshold(io)
        return result
    case 10:
        LL_USART_ConfigFIFOsThreshold(io, args[0], args[1])
        return 0
    case 11:
        LL_USART_EnableInStopMode(io)
        return 0
    case 12:
        LL_USART_DisableInStopMode(io)
        return 0
    case 13:
        let result = LL_USART_IsEnabledInStopMode(io)
        return result
    case 14:
        LL_USART_EnableDirectionRx(io)
        return 0
    case 15:
        LL_USART_DisableDirectionRx(io)
        return 0
    case 16:
        LL_USART_EnableDirectionTx(io)
        return 0
    case 17:
        LL_USART_DisableDirectionTx(io)
        return 0
    case 18:
        LL_USART_SetTransferDirection(io, args[0])
        return 0
    case 19:
        let result = LL_USART_GetTransferDirection(io)
        return result
    case 20:
        LL_USART_SetParity(io, args[0])
        return 0
    case 21:
        let result = LL_USART_GetParity(io)
        return result
    case 22:
        LL_USART_SetWakeUpMethod(io, args[0])
        return 0
    case 23:
        let result = LL_USART_GetWakeUpMethod(io)
        return result
    case 24:
        LL_USART_SetDataWidth(io, args[0])
        return 0
    case 25:
        let result = LL_USART_GetDataWidth(io)
        return result
    case 26:
        LL_USART_EnableMuteMode(io)
        return 0
    case 27:
        LL_USART_DisableMuteMode(io)
        return 0
    case 28:
        let result = LL_USART_IsEnabledMuteMode(io)
        return result
    case 29:
        LL_USART_SetOverSampling(io, args[0])
        return 0
    case 30:
        let result = LL_USART_GetOverSampling(io)
        return result
    case 31:
        LL_USART_SetLastClkPulseOutput(io, args[0])
        return 0
    case 32:
        let result = LL_USART_GetLastClkPulseOutput(io)
        return result
    case 33:
        LL_USART_SetClockPhase(io, args[0])
        return 0
    case 34:
        let result = LL_USART_GetClockPhase(io)
        return result
    case 35:
        LL_USART_SetClockPolarity(io, args[0])
        return 0
    case 36:
        let result = LL_USART_GetClockPolarity(io)
        return result
    case 37:
        LL_USART_ConfigClock(io, args[0], args[1], args[2])
        return 0
    case 38:
        LL_USART_SetPrescaler(io, args[0])
        return 0
    case 39:
        let result = LL_USART_GetPrescaler(io)
        return result
    case 40:
        LL_USART_EnableSCLKOutput(io)
        return 0
    case 41:
        LL_USART_DisableSCLKOutput(io)
        return 0
    case 42:
        let result = LL_USART_IsEnabledSCLKOutput(io)
        return result
    case 43:
        LL_USART_SetStopBitsLength(io, args[0])
        return 0
    case 44:
        let result = LL_USART_GetStopBitsLength(io)
        return result
    case 45:
        LL_USART_ConfigCharacter(io, args[0], args[1], args[2])
        return 0
    case 46:
        LL_USART_SetTXRXSwap(io, args[0])
        return 0
    case 47:
        let result = LL_USART_GetTXRXSwap(io)
        return result
    case 48:
        LL_USART_SetRXPinLevel(io, args[0])
        return 0
    case 49:
        let result = LL_USART_GetRXPinLevel(io)
        return result
    case 50:
        LL_USART_SetTXPinLevel(io, args[0])
        return 0
    case 51:
        let result = LL_USART_GetTXPinLevel(io)
        return result
    case 52:
        LL_USART_SetBinaryDataLogic(io, args[0])
        return 0
    case 53:
        let result = LL_USART_GetBinaryDataLogic(io)
        return result
    case 54:
        LL_USART_SetTransferBitOrder(io, args[0])
        return 0
    case 55:
        let result = LL_USART_GetTransferBitOrder(io)
        return result
    case 56:
        LL_USART_EnableAutoBaudRate(io)
        return 0
    case 57:
        LL_USART_DisableAutoBaudRate(io)
        return 0
    case 58:
        let result = LL_USART_IsEnabledAutoBaud(io)
        return result
    case 59:
        LL_USART_SetAutoBaudRateMode(io, args[0])
        return 0
    case 60:
        let result = LL_USART_GetAutoBaudRateMode(io)
        return result
    case 61:
        LL_USART_EnableRxTimeout(io)
        return 0
    case 62:
        LL_USART_DisableRxTimeout(io)
        return 0
    case 63:
        let result = LL_USART_IsEnabledRxTimeout(io)
        return result
    case 64:
        LL_USART_ConfigNodeAddress(io, args[0], args[1])
        return 0
    case 65:
        let result = LL_USART_GetNodeAddress(io)
        return result
    case 66:
        let result = LL_USART_GetNodeAddressLen(io)
        return result
    case 67:
        LL_USART_EnableRTSHWFlowCtrl(io)
        return 0
    case 68:
        LL_USART_DisableRTSHWFlowCtrl(io)
        return 0
    case 69:
        LL_USART_EnableCTSHWFlowCtrl(io)
        return 0
    case 70:
        LL_USART_DisableCTSHWFlowCtrl(io)
        return 0
    case 71:
        LL_USART_SetHWFlowCtrl(io, args[0])
        return 0
    case 72:
        let result = LL_USART_GetHWFlowCtrl(io)
        return result
    case 73:
        LL_USART_EnableOneBitSamp(io)
        return 0
    case 74:
        LL_USART_DisableOneBitSamp(io)
        return 0
    case 75:
        let result = LL_USART_IsEnabledOneBitSamp(io)
        return result
    case 76:
        LL_USART_EnableOverrunDetect(io)
        return 0
    case 77:
        LL_USART_DisableOverrunDetect(io)
        return 0
    case 78:
        let result = LL_USART_IsEnabledOverrunDetect(io)
        return result
    case 79:
        LL_USART_SetWKUPType(io, args[0])
        return 0
    case 80:
        let result = LL_USART_GetWKUPType(io)
        return result
    case 81:
        LL_USART_SetBaudRate(io, args[0], args[1], args[2], args[3])
        return 0
    case 82:
        let result = LL_USART_GetBaudRate(io, args[0], args[1], args[2])
        return result
    case 83:
        LL_USART_SetRxTimeout(io, args[0])
        return 0
    case 84:
        let result = LL_USART_GetRxTimeout(io)
        return result
    case 85:
        LL_USART_SetBlockLength(io, args[0])
        return 0
    case 86:
        let result = LL_USART_GetBlockLength(io)
        return result
    case 87:
        LL_USART_EnableIrda(io)
        return 0
    case 88:
        LL_USART_DisableIrda(io)
        return 0
    case 89:
        let result = LL_USART_IsEnabledIrda(io)
        return result
    case 90:
        LL_USART_SetIrdaPowerMode(io, args[0])
        return 0
    case 91:
        let result = LL_USART_GetIrdaPowerMode(io)
        return result
    case 92:
        LL_USART_SetIrdaPrescaler(io, args[0])
        return 0
    case 93:
        let result = LL_USART_GetIrdaPrescaler(io)
        return result
    case 94:
        LL_USART_EnableSmartcardNACK(io)
        return 0
    case 95:
        LL_USART_DisableSmartcardNACK(io)
        return 0
    case 96:
        let result = LL_USART_IsEnabledSmartcardNACK(io)
        return result
    case 97:
        LL_USART_EnableSmartcard(io)
        return 0
    case 98:
        LL_USART_DisableSmartcard(io)
        return 0
    case 99:
        let result = LL_USART_IsEnabledSmartcard(io)
        return result
    case 100:
        LL_USART_SetSmartcardAutoRetryCount(io, args[0])
        return 0
    case 101:
        let result = LL_USART_GetSmartcardAutoRetryCount(io)
        return result
    case 102:
        LL_USART_SetSmartcardPrescaler(io, args[0])
        return 0
    case 103:
        let result = LL_USART_GetSmartcardPrescaler(io)
        return result
    case 104:
        LL_USART_SetSmartcardGuardTime(io, args[0])
        return 0
    case 105:
        let result = LL_USART_GetSmartcardGuardTime(io)
        return result
    case 106:
        LL_USART_EnableHalfDuplex(io)
        return 0
    case 107:
        LL_USART_DisableHalfDuplex(io)
        return 0
    case 108:
        let result = LL_USART_IsEnabledHalfDuplex(io)
        return result
    case 109:
        LL_USART_EnableSPISlave(io)
        return 0
    case 110:
        LL_USART_DisableSPISlave(io)
        return 0
    case 111:
        let result = LL_USART_IsEnabledSPISlave(io)
        return result
    case 112:
        LL_USART_EnableSPISlaveSelect(io)
        return 0
    case 113:
        LL_USART_DisableSPISlaveSelect(io)
        return 0
    case 114:
        let result = LL_USART_IsEnabledSPISlaveSelect(io)
        return result
    case 115:
        LL_USART_SetLINBrkDetectionLen(io, args[0])
        return 0
    case 116:
        let result = LL_USART_GetLINBrkDetectionLen(io)
        return result
    case 117:
        LL_USART_EnableLIN(io)
        return 0
    case 118:
        LL_USART_DisableLIN(io)
        return 0
    case 119:
        let result = LL_USART_IsEnabledLIN(io)
        return result
    case 120:
        LL_USART_SetDEDeassertionTime(io, args[0])
        return 0
    case 121:
        let result = LL_USART_GetDEDeassertionTime(io)
        return result
    case 122:
        LL_USART_SetDEAssertionTime(io, args[0])
        return 0
    case 123:
        let result = LL_USART_GetDEAssertionTime(io)
        return result
    case 124:
        LL_USART_EnableDEMode(io)
        return 0
    case 125:
        LL_USART_DisableDEMode(io)
        return 0
    case 126:
        let result = LL_USART_IsEnabledDEMode(io)
        return result
    case 127:
        LL_USART_SetDESignalPolarity(io, args[0])
        return 0
    case 128:
        let result = LL_USART_GetDESignalPolarity(io)
        return result
    case 129:
        LL_USART_ConfigAsyncMode(io)
        return 0
    case 130:
        LL_USART_ConfigSyncMode(io)
        return 0
    case 131:
        LL_USART_ConfigLINMode(io)
        return 0
    case 132:
        LL_USART_ConfigHalfDuplexMode(io)
        return 0
    case 133:
        LL_USART_ConfigSmartcardMode(io)
        return 0
    case 134:
        LL_USART_ConfigIrdaMode(io)
        return 0
    case 135:
        LL_USART_ConfigMultiProcessMode(io)
        return 0
    case 136:
        let result = LL_USART_IsActiveFlag_PE(io)
        return result
    case 137:
        let result = LL_USART_IsActiveFlag_FE(io)
        return result
    case 138:
        let result = LL_USART_IsActiveFlag_NE(io)
        return result
    case 139:
        let result = LL_USART_IsActiveFlag_ORE(io)
        return result
    case 140:
        let result = LL_USART_IsActiveFlag_IDLE(io)
        return result
    case 141:
        let result = LL_USART_IsActiveFlag_RXNE_RXFNE(io)
        return result
    case 142:
        let result = LL_USART_IsActiveFlag_TC(io)
        return result
    case 143:
        let result = LL_USART_IsActiveFlag_TXE_TXFNF(io)
        return result
    case 144:
        let result = LL_USART_IsActiveFlag_LBD(io)
        return result
    case 145:
        let result = LL_USART_IsActiveFlag_nCTS(io)
        return result
    case 146:
        let result = LL_USART_IsActiveFlag_CTS(io)
        return result
    case 147:
        let result = LL_USART_IsActiveFlag_RTO(io)
        return result
    case 148:
        let result = LL_USART_IsActiveFlag_EOB(io)
        return result
    case 149:
        let result = LL_USART_IsActiveFlag_UDR(io)
        return result
    case 150:
        let result = LL_USART_IsActiveFlag_ABRE(io)
        return result
    case 151:
        let result = LL_USART_IsActiveFlag_ABR(io)
        return result
    case 152:
        let result = LL_USART_IsActiveFlag_BUSY(io)
        return result
    case 153:
        let result = LL_USART_IsActiveFlag_CM(io)
        return result
    case 154:
        let result = LL_USART_IsActiveFlag_SBK(io)
        return result
    case 155:
        let result = LL_USART_IsActiveFlag_RWU(io)
        return result
    case 156:
        let result = LL_USART_IsActiveFlag_WKUP(io)
        return result
    case 157:
        let result = LL_USART_IsActiveFlag_TEACK(io)
        return result
    case 158:
        let result = LL_USART_IsActiveFlag_REACK(io)
        return result
    case 159:
        let result = LL_USART_IsActiveFlag_TXFE(io)
        return result
    case 160:
        let result = LL_USART_IsActiveFlag_RXFF(io)
        return result
    case 161:
        let result = LL_USART_IsActiveFlag_TCBGT(io)
        return result
    case 162:
        let result = LL_USART_IsActiveFlag_TXFT(io)
        return result
    case 163:
        let result = LL_USART_IsActiveFlag_RXFT(io)
        return result
    case 164:
        LL_USART_ClearFlag_PE(io)
        return 0
    case 165:
        LL_USART_ClearFlag_FE(io)
        return 0
    case 166:
        LL_USART_ClearFlag_NE(io)
        return 0
    case 167:
        LL_USART_ClearFlag_ORE(io)
        return 0
    case 168:
        LL_USART_ClearFlag_IDLE(io)
        return 0
    case 169:
        LL_USART_ClearFlag_TXFE(io)
        return 0
    case 170:
        LL_USART_ClearFlag_TC(io)
        return 0
    case 171:
        LL_USART_ClearFlag_TCBGT(io)
        return 0
    case 172:
        LL_USART_ClearFlag_LBD(io)
        return 0
    case 173:
        LL_USART_ClearFlag_nCTS(io)
        return 0
    case 174:
        LL_USART_ClearFlag_RTO(io)
        return 0
    case 175:
        LL_USART_ClearFlag_EOB(io)
        return 0
    case 176:
        LL_USART_ClearFlag_UDR(io)
        return 0
    case 177:
        LL_USART_ClearFlag_CM(io)
        return 0
    case 178:
        LL_USART_ClearFlag_WKUP(io)
        return 0
    case 179:
        LL_USART_EnableIT_IDLE(io)
        return 0
    case 180:
        LL_USART_EnableIT_RXNE_RXFNE(io)
        return 0
    case 181:
        LL_USART_EnableIT_TC(io)
        return 0
    case 182:
        LL_USART_EnableIT_TXE_TXFNF(io)
        return 0
    case 183:
        LL_USART_EnableIT_PE(io)
        return 0
    case 184:
        LL_USART_EnableIT_CM(io)
        return 0
    case 185:
        LL_USART_EnableIT_RTO(io)
        return 0
    case 186:
        LL_USART_EnableIT_EOB(io)
        return 0
    case 187:
        LL_USART_EnableIT_TXFE(io)
        return 0
    case 188:
        LL_USART_EnableIT_RXFF(io)
        return 0
    case 189:
        LL_USART_EnableIT_LBD(io)
        return 0
    case 190:
        LL_USART_EnableIT_ERROR(io)
        return 0
    case 191:
        LL_USART_EnableIT_CTS(io)
        return 0
    case 192:
        LL_USART_EnableIT_WKUP(io)
        return 0
    case 193:
        LL_USART_EnableIT_TXFT(io)
        return 0
    case 194:
        LL_USART_EnableIT_TCBGT(io)
        return 0
    case 195:
        LL_USART_EnableIT_RXFT(io)
        return 0
    case 196:
        LL_USART_DisableIT_IDLE(io)
        return 0
    case 197:
        LL_USART_DisableIT_RXNE_RXFNE(io)
        return 0
    case 198:
        LL_USART_DisableIT_TC(io)
        return 0
    case 199:
        LL_USART_DisableIT_TXE_TXFNF(io)
        return 0
    case 200:
        LL_USART_DisableIT_PE(io)
        return 0
    case 201:
        LL_USART_DisableIT_CM(io)
        return 0
    case 202:
        LL_USART_DisableIT_RTO(io)
        return 0
    case 203:
        LL_USART_DisableIT_EOB(io)
        return 0
    case 204:
        LL_USART_DisableIT_TXFE(io)
        return 0
    case 205:
        LL_USART_DisableIT_RXFF(io)
        return 0
    case 206:
        LL_USART_DisableIT_LBD(io)
        return 0
    case 207:
        LL_USART_DisableIT_ERROR(io)
        return 0
    case 208:
        LL_USART_DisableIT_CTS(io)
        return 0
    case 209:
        LL_USART_DisableIT_WKUP(io)
        return 0
    case 210:
        LL_USART_DisableIT_TXFT(io)
        return 0
    case 211:
        LL_USART_DisableIT_TCBGT(io)
        return 0
    case 212:
        LL_USART_DisableIT_RXFT(io)
        return 0
    case 213:
        let result = LL_USART_IsEnabledIT_IDLE(io)
        return result
    case 214:
        let result = LL_USART_IsEnabledIT_RXNE_RXFNE(io)
        return result
    case 215:
        let result = LL_USART_IsEnabledIT_TC(io)
        return result
    case 216:
        let result = LL_USART_IsEnabledIT_TXE_TXFNF(io)
        return result
    case 217:
        let result = LL_USART_IsEnabledIT_PE(io)
        return result
    case 218:
        let result = LL_USART_IsEnabledIT_CM(io)
        return result
    case 219:
        let result = LL_USART_IsEnabledIT_RTO(io)
        return result
    case 220:
        let result = LL_USART_IsEnabledIT_EOB(io)
        return result
    case 221:
        let result = LL_USART_IsEnabledIT_TXFE(io)
        return result
    case 222:
        let result = LL_USART_IsEnabledIT_RXFF(io)
        return result
    case 223:
        let result = LL_USART_IsEnabledIT_LBD(io)
        return result
    case 224:
        let result = LL_USART_IsEnabledIT_ERROR(io)
        return result
    case 225:
        let result = LL_USART_IsEnabledIT_CTS(io)
        return result
    case 226:
        let result = LL_USART_IsEnabledIT_WKUP(io)
        return result
    case 227:
        let result = LL_USART_IsEnabledIT_TXFT(io)
        return result
    case 228:
        let result = LL_USART_IsEnabledIT_TCBGT(io)
        return result
    case 229:
        let result = LL_USART_IsEnabledIT_RXFT(io)
        return result
    case 230:
        LL_USART_EnableDMAReq_RX(io)
        return 0
    case 231:
        LL_USART_DisableDMAReq_RX(io)
        return 0
    case 232:
        let result = LL_USART_IsEnabledDMAReq_RX(io)
        return result
    case 233:
        LL_USART_EnableDMAReq_TX(io)
        return 0
    case 234:
        LL_USART_DisableDMAReq_TX(io)
        return 0
    case 235:
        let result = LL_USART_IsEnabledDMAReq_TX(io)
        return result
    case 236:
        LL_USART_EnableDMADeactOnRxErr(io)
        return 0
    case 237:
        LL_USART_DisableDMADeactOnRxErr(io)
        return 0
    case 238:
        let result = LL_USART_IsEnabledDMADeactOnRxErr(io)
        return result
    case 239:
        let result = LL_USART_DMA_GetRegAddr(io, args[0])
        return result
    case 240:
        let result = UInt32(LL_USART_ReceiveData8(io))
        return result
    case 241:
        let result = UInt32(LL_USART_ReceiveData9(io))
        return result
    case 242:
        LL_USART_TransmitData8(io, UInt8(truncatingIfNeeded: args[0]))
        return 0
    case 243:
        LL_USART_TransmitData9(io, UInt16(truncatingIfNeeded: args[0]))
        return 0
    case 244:
        LL_USART_RequestAutoBaudRate(io)
        return 0
    case 245:
        LL_USART_RequestBreakSending(io)
        return 0
    case 246:
        LL_USART_RequestEnterMuteMode(io)
        return 0
    case 247:
        LL_USART_RequestRxDataFlush(io)
        return 0
    case 248:
        LL_USART_RequestTxDataFlush(io)
        return 0
    case 249:
        let result = LL_USART_DeInit(&uart).rawValue
        return result
    case 250:
        let v1 = LL_USART_InitTypeDef(
            PrescalerValue: args[0], BaudRate: args[1], DataWidth: args[2], StopBits: args[3], Parity: args[4],
            TransferDirection: args[5], HardwareFlowControl: args[6], OverSampling: args[7])
        let result = LL_USART_Init(io, v1, clocks: &clocks, oscillators: io.oscillators).rawValue
        io.cells[512] = v1.PrescalerValue
        io.cells[513] = v1.BaudRate
        io.cells[514] = v1.DataWidth
        io.cells[515] = v1.StopBits
        io.cells[516] = v1.Parity
        io.cells[517] = v1.TransferDirection
        io.cells[518] = v1.HardwareFlowControl
        io.cells[519] = v1.OverSampling
        return result
    case 251:
        var v0 = LL_USART_InitTypeDef(
            PrescalerValue: args[0], BaudRate: args[1], DataWidth: args[2], StopBits: args[3], Parity: args[4],
            TransferDirection: args[5], HardwareFlowControl: args[6], OverSampling: args[7])
        LL_USART_StructInit(&v0)
        io.cells[512] = v0.PrescalerValue
        io.cells[513] = v0.BaudRate
        io.cells[514] = v0.DataWidth
        io.cells[515] = v0.StopBits
        io.cells[516] = v0.Parity
        io.cells[517] = v0.TransferDirection
        io.cells[518] = v0.HardwareFlowControl
        io.cells[519] = v0.OverSampling
        return 0
    case 252:
        let v1 = LL_USART_ClockInitTypeDef(
            ClockOutput: args[0], ClockPolarity: args[1], ClockPhase: args[2], LastBitClockPulse: args[3])
        let result = LL_USART_ClockInit(io, v1).rawValue
        io.cells[512] = v1.ClockOutput
        io.cells[513] = v1.ClockPolarity
        io.cells[514] = v1.ClockPhase
        io.cells[515] = v1.LastBitClockPulse
        return result
    case 253:
        var v0 = LL_USART_ClockInitTypeDef(
            ClockOutput: args[0], ClockPolarity: args[1], ClockPhase: args[2], LastBitClockPulse: args[3])
        LL_USART_ClockStructInit(&v0)
        io.cells[512] = v0.ClockOutput
        io.cells[513] = v0.ClockPolarity
        io.cells[514] = v0.ClockPhase
        io.cells[515] = v0.LastBitClockPulse
        return 0
    case 254:
        LL_LPUART_Enable(io)
        return 0
    case 255:
        LL_LPUART_Disable(io)
        return 0
    case 256:
        let result = LL_LPUART_IsEnabled(io)
        return result
    case 257:
        LL_LPUART_EnableFIFO(io)
        return 0
    case 258:
        LL_LPUART_DisableFIFO(io)
        return 0
    case 259:
        let result = LL_LPUART_IsEnabledFIFO(io)
        return result
    case 260:
        LL_LPUART_SetTXFIFOThreshold(io, args[0])
        return 0
    case 261:
        let result = LL_LPUART_GetTXFIFOThreshold(io)
        return result
    case 262:
        LL_LPUART_SetRXFIFOThreshold(io, args[0])
        return 0
    case 263:
        let result = LL_LPUART_GetRXFIFOThreshold(io)
        return result
    case 264:
        LL_LPUART_ConfigFIFOsThreshold(io, args[0], args[1])
        return 0
    case 265:
        LL_LPUART_EnableInStopMode(io)
        return 0
    case 266:
        LL_LPUART_DisableInStopMode(io)
        return 0
    case 267:
        let result = LL_LPUART_IsEnabledInStopMode(io)
        return result
    case 268:
        LL_LPUART_EnableDirectionRx(io)
        return 0
    case 269:
        LL_LPUART_DisableDirectionRx(io)
        return 0
    case 270:
        LL_LPUART_EnableDirectionTx(io)
        return 0
    case 271:
        LL_LPUART_DisableDirectionTx(io)
        return 0
    case 272:
        LL_LPUART_SetTransferDirection(io, args[0])
        return 0
    case 273:
        let result = LL_LPUART_GetTransferDirection(io)
        return result
    case 274:
        LL_LPUART_SetParity(io, args[0])
        return 0
    case 275:
        let result = LL_LPUART_GetParity(io)
        return result
    case 276:
        LL_LPUART_SetWakeUpMethod(io, args[0])
        return 0
    case 277:
        let result = LL_LPUART_GetWakeUpMethod(io)
        return result
    case 278:
        LL_LPUART_SetDataWidth(io, args[0])
        return 0
    case 279:
        let result = LL_LPUART_GetDataWidth(io)
        return result
    case 280:
        LL_LPUART_EnableMuteMode(io)
        return 0
    case 281:
        LL_LPUART_DisableMuteMode(io)
        return 0
    case 282:
        let result = LL_LPUART_IsEnabledMuteMode(io)
        return result
    case 283:
        LL_LPUART_SetPrescaler(io, args[0])
        return 0
    case 284:
        let result = LL_LPUART_GetPrescaler(io)
        return result
    case 285:
        LL_LPUART_SetStopBitsLength(io, args[0])
        return 0
    case 286:
        let result = LL_LPUART_GetStopBitsLength(io)
        return result
    case 287:
        LL_LPUART_ConfigCharacter(io, args[0], args[1], args[2])
        return 0
    case 288:
        LL_LPUART_SetTXRXSwap(io, args[0])
        return 0
    case 289:
        let result = LL_LPUART_GetTXRXSwap(io)
        return result
    case 290:
        LL_LPUART_SetRXPinLevel(io, args[0])
        return 0
    case 291:
        let result = LL_LPUART_GetRXPinLevel(io)
        return result
    case 292:
        LL_LPUART_SetTXPinLevel(io, args[0])
        return 0
    case 293:
        let result = LL_LPUART_GetTXPinLevel(io)
        return result
    case 294:
        LL_LPUART_SetBinaryDataLogic(io, args[0])
        return 0
    case 295:
        let result = LL_LPUART_GetBinaryDataLogic(io)
        return result
    case 296:
        LL_LPUART_SetTransferBitOrder(io, args[0])
        return 0
    case 297:
        let result = LL_LPUART_GetTransferBitOrder(io)
        return result
    case 298:
        LL_LPUART_ConfigNodeAddress(io, args[0], args[1])
        return 0
    case 299:
        let result = LL_LPUART_GetNodeAddress(io)
        return result
    case 300:
        let result = LL_LPUART_GetNodeAddressLen(io)
        return result
    case 301:
        LL_LPUART_EnableRTSHWFlowCtrl(io)
        return 0
    case 302:
        LL_LPUART_DisableRTSHWFlowCtrl(io)
        return 0
    case 303:
        LL_LPUART_EnableCTSHWFlowCtrl(io)
        return 0
    case 304:
        LL_LPUART_DisableCTSHWFlowCtrl(io)
        return 0
    case 305:
        LL_LPUART_SetHWFlowCtrl(io, args[0])
        return 0
    case 306:
        let result = LL_LPUART_GetHWFlowCtrl(io)
        return result
    case 307:
        LL_LPUART_EnableOverrunDetect(io)
        return 0
    case 308:
        LL_LPUART_DisableOverrunDetect(io)
        return 0
    case 309:
        let result = LL_LPUART_IsEnabledOverrunDetect(io)
        return result
    case 310:
        LL_LPUART_SetWKUPType(io, args[0])
        return 0
    case 311:
        let result = LL_LPUART_GetWKUPType(io)
        return result
    case 312:
        LL_LPUART_SetBaudRate(io, args[0], args[1], args[2])
        return 0
    case 313:
        let result = LL_LPUART_GetBaudRate(io, args[0], args[1])
        return result
    case 314:
        LL_LPUART_EnableHalfDuplex(io)
        return 0
    case 315:
        LL_LPUART_DisableHalfDuplex(io)
        return 0
    case 316:
        let result = LL_LPUART_IsEnabledHalfDuplex(io)
        return result
    case 317:
        LL_LPUART_SetDEDeassertionTime(io, args[0])
        return 0
    case 318:
        let result = LL_LPUART_GetDEDeassertionTime(io)
        return result
    case 319:
        LL_LPUART_SetDEAssertionTime(io, args[0])
        return 0
    case 320:
        let result = LL_LPUART_GetDEAssertionTime(io)
        return result
    case 321:
        LL_LPUART_EnableDEMode(io)
        return 0
    case 322:
        LL_LPUART_DisableDEMode(io)
        return 0
    case 323:
        let result = LL_LPUART_IsEnabledDEMode(io)
        return result
    case 324:
        LL_LPUART_SetDESignalPolarity(io, args[0])
        return 0
    case 325:
        let result = LL_LPUART_GetDESignalPolarity(io)
        return result
    case 326:
        let result = LL_LPUART_IsActiveFlag_PE(io)
        return result
    case 327:
        let result = LL_LPUART_IsActiveFlag_FE(io)
        return result
    case 328:
        let result = LL_LPUART_IsActiveFlag_NE(io)
        return result
    case 329:
        let result = LL_LPUART_IsActiveFlag_ORE(io)
        return result
    case 330:
        let result = LL_LPUART_IsActiveFlag_IDLE(io)
        return result
    case 331:
        let result = LL_LPUART_IsActiveFlag_RXNE_RXFNE(io)
        return result
    case 332:
        let result = LL_LPUART_IsActiveFlag_TC(io)
        return result
    case 333:
        let result = LL_LPUART_IsActiveFlag_TXE_TXFNF(io)
        return result
    case 334:
        let result = LL_LPUART_IsActiveFlag_nCTS(io)
        return result
    case 335:
        let result = LL_LPUART_IsActiveFlag_CTS(io)
        return result
    case 336:
        let result = LL_LPUART_IsActiveFlag_BUSY(io)
        return result
    case 337:
        let result = LL_LPUART_IsActiveFlag_CM(io)
        return result
    case 338:
        let result = LL_LPUART_IsActiveFlag_SBK(io)
        return result
    case 339:
        let result = LL_LPUART_IsActiveFlag_RWU(io)
        return result
    case 340:
        let result = LL_LPUART_IsActiveFlag_WKUP(io)
        return result
    case 341:
        let result = LL_LPUART_IsActiveFlag_TEACK(io)
        return result
    case 342:
        let result = LL_LPUART_IsActiveFlag_REACK(io)
        return result
    case 343:
        let result = LL_LPUART_IsActiveFlag_TXFE(io)
        return result
    case 344:
        let result = LL_LPUART_IsActiveFlag_RXFF(io)
        return result
    case 345:
        let result = LL_LPUART_IsActiveFlag_TXFT(io)
        return result
    case 346:
        let result = LL_LPUART_IsActiveFlag_RXFT(io)
        return result
    case 347:
        LL_LPUART_ClearFlag_PE(io)
        return 0
    case 348:
        LL_LPUART_ClearFlag_FE(io)
        return 0
    case 349:
        LL_LPUART_ClearFlag_NE(io)
        return 0
    case 350:
        LL_LPUART_ClearFlag_ORE(io)
        return 0
    case 351:
        LL_LPUART_ClearFlag_IDLE(io)
        return 0
    case 352:
        LL_LPUART_ClearFlag_TC(io)
        return 0
    case 353:
        LL_LPUART_ClearFlag_nCTS(io)
        return 0
    case 354:
        LL_LPUART_ClearFlag_CM(io)
        return 0
    case 355:
        LL_LPUART_ClearFlag_WKUP(io)
        return 0
    case 356:
        LL_LPUART_EnableIT_IDLE(io)
        return 0
    case 357:
        LL_LPUART_EnableIT_RXNE_RXFNE(io)
        return 0
    case 358:
        LL_LPUART_EnableIT_TC(io)
        return 0
    case 359:
        LL_LPUART_EnableIT_TXE_TXFNF(io)
        return 0
    case 360:
        LL_LPUART_EnableIT_PE(io)
        return 0
    case 361:
        LL_LPUART_EnableIT_CM(io)
        return 0
    case 362:
        LL_LPUART_EnableIT_TXFE(io)
        return 0
    case 363:
        LL_LPUART_EnableIT_RXFF(io)
        return 0
    case 364:
        LL_LPUART_EnableIT_ERROR(io)
        return 0
    case 365:
        LL_LPUART_EnableIT_CTS(io)
        return 0
    case 366:
        LL_LPUART_EnableIT_WKUP(io)
        return 0
    case 367:
        LL_LPUART_EnableIT_TXFT(io)
        return 0
    case 368:
        LL_LPUART_EnableIT_RXFT(io)
        return 0
    case 369:
        LL_LPUART_DisableIT_IDLE(io)
        return 0
    case 370:
        LL_LPUART_DisableIT_RXNE_RXFNE(io)
        return 0
    case 371:
        LL_LPUART_DisableIT_TC(io)
        return 0
    case 372:
        LL_LPUART_DisableIT_TXE_TXFNF(io)
        return 0
    case 373:
        LL_LPUART_DisableIT_PE(io)
        return 0
    case 374:
        LL_LPUART_DisableIT_CM(io)
        return 0
    case 375:
        LL_LPUART_DisableIT_TXFE(io)
        return 0
    case 376:
        LL_LPUART_DisableIT_RXFF(io)
        return 0
    case 377:
        LL_LPUART_DisableIT_ERROR(io)
        return 0
    case 378:
        LL_LPUART_DisableIT_CTS(io)
        return 0
    case 379:
        LL_LPUART_DisableIT_WKUP(io)
        return 0
    case 380:
        LL_LPUART_DisableIT_TXFT(io)
        return 0
    case 381:
        LL_LPUART_DisableIT_RXFT(io)
        return 0
    case 382:
        let result = LL_LPUART_IsEnabledIT_IDLE(io)
        return result
    case 383:
        let result = LL_LPUART_IsEnabledIT_RXNE_RXFNE(io)
        return result
    case 384:
        let result = LL_LPUART_IsEnabledIT_TC(io)
        return result
    case 385:
        let result = LL_LPUART_IsEnabledIT_TXE_TXFNF(io)
        return result
    case 386:
        let result = LL_LPUART_IsEnabledIT_PE(io)
        return result
    case 387:
        let result = LL_LPUART_IsEnabledIT_CM(io)
        return result
    case 388:
        let result = LL_LPUART_IsEnabledIT_TXFE(io)
        return result
    case 389:
        let result = LL_LPUART_IsEnabledIT_RXFF(io)
        return result
    case 390:
        let result = LL_LPUART_IsEnabledIT_ERROR(io)
        return result
    case 391:
        let result = LL_LPUART_IsEnabledIT_CTS(io)
        return result
    case 392:
        let result = LL_LPUART_IsEnabledIT_WKUP(io)
        return result
    case 393:
        let result = LL_LPUART_IsEnabledIT_TXFT(io)
        return result
    case 394:
        let result = LL_LPUART_IsEnabledIT_RXFT(io)
        return result
    case 395:
        LL_LPUART_EnableDMAReq_RX(io)
        return 0
    case 396:
        LL_LPUART_DisableDMAReq_RX(io)
        return 0
    case 397:
        let result = LL_LPUART_IsEnabledDMAReq_RX(io)
        return result
    case 398:
        LL_LPUART_EnableDMAReq_TX(io)
        return 0
    case 399:
        LL_LPUART_DisableDMAReq_TX(io)
        return 0
    case 400:
        let result = LL_LPUART_IsEnabledDMAReq_TX(io)
        return result
    case 401:
        LL_LPUART_EnableDMADeactOnRxErr(io)
        return 0
    case 402:
        LL_LPUART_DisableDMADeactOnRxErr(io)
        return 0
    case 403:
        let result = LL_LPUART_IsEnabledDMADeactOnRxErr(io)
        return result
    case 404:
        let result = LL_LPUART_DMA_GetRegAddr(io, args[0])
        return result
    case 405:
        let result = UInt32(LL_LPUART_ReceiveData8(io))
        return result
    case 406:
        let result = UInt32(LL_LPUART_ReceiveData9(io))
        return result
    case 407:
        LL_LPUART_TransmitData8(io, UInt8(truncatingIfNeeded: args[0]))
        return 0
    case 408:
        LL_LPUART_TransmitData9(io, UInt16(truncatingIfNeeded: args[0]))
        return 0
    case 409:
        LL_LPUART_RequestBreakSending(io)
        return 0
    case 410:
        LL_LPUART_RequestEnterMuteMode(io)
        return 0
    case 411:
        LL_LPUART_RequestRxDataFlush(io)
        return 0
    case 412:
        LL_LPUART_RequestTxDataFlush(io)
        return 0
    case 413:
        let result = LL_LPUART_DeInit(&uart).rawValue
        return result
    case 414:
        let v1 = LL_LPUART_InitTypeDef(
            PrescalerValue: args[0], BaudRate: args[1], DataWidth: args[2], StopBits: args[3], Parity: args[4],
            TransferDirection: args[5], HardwareFlowControl: args[6])
        let result = LL_LPUART_Init(io, v1, clocks: &clocks, oscillators: io.oscillators).rawValue
        io.cells[512] = v1.PrescalerValue
        io.cells[513] = v1.BaudRate
        io.cells[514] = v1.DataWidth
        io.cells[515] = v1.StopBits
        io.cells[516] = v1.Parity
        io.cells[517] = v1.TransferDirection
        io.cells[518] = v1.HardwareFlowControl
        return result
    case 415:
        var v0 = LL_LPUART_InitTypeDef(
            PrescalerValue: args[0], BaudRate: args[1], DataWidth: args[2], StopBits: args[3], Parity: args[4],
            TransferDirection: args[5], HardwareFlowControl: args[6])
        LL_LPUART_StructInit(&v0)
        io.cells[512] = v0.PrescalerValue
        io.cells[513] = v0.BaudRate
        io.cells[514] = v0.DataWidth
        io.cells[515] = v0.StopBits
        io.cells[516] = v0.Parity
        io.cells[517] = v0.TransferDirection
        io.cells[518] = v0.HardwareFlowControl
        return 0
    case 416: return LL_USART_IsActiveFlag_RXNE(io)
    case 417: return LL_USART_IsActiveFlag_TXE(io)
    case 418:
        LL_USART_EnableIT_RXNE(io)
        return 0
    case 419:
        LL_USART_EnableIT_TXE(io)
        return 0
    case 420:
        LL_USART_DisableIT_RXNE(io)
        return 0
    case 421:
        LL_USART_DisableIT_TXE(io)
        return 0
    case 422: return LL_USART_IsEnabledIT_RXNE(io)
    case 423: return LL_USART_IsEnabledIT_TXE(io)
    case 424: return LL_LPUART_IsActiveFlag_RXNE(io)
    case 425: return LL_LPUART_IsActiveFlag_TXE(io)
    case 426:
        LL_LPUART_EnableIT_RXNE(io)
        return 0
    case 427:
        LL_LPUART_EnableIT_TXE(io)
        return 0
    case 428:
        LL_LPUART_DisableIT_RXNE(io)
        return 0
    case 429:
        LL_LPUART_DisableIT_TXE(io)
        return 0
    case 430: return LL_LPUART_IsEnabledIT_RXNE(io)
    case 431: return LL_LPUART_IsEnabledIT_TXE(io)
    case 432:
        LL_USART_WriteReg(io, .cr2, args[0])
        return LL_USART_ReadReg(io, .cr2)
    case 433:
        LL_LPUART_WriteReg(io, .cr2, args[0])
        return LL_LPUART_ReadReg(io, .cr2)
    case 434: return __LL_USART_DIV_SAMPLING8(args[0], args[1], args[2])
    case 435: return __LL_USART_DIV_SAMPLING16(args[0], args[1], args[2])
    case 436: return __LL_LPUART_DIV(args[0], args[1], args[2])
    default: preconditionFailure("Unknown operation")
    }
}
final class LLSerialDifferentialTests: XCTestCase {
    @discardableResult
    private func compare(
        _ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0, instance: UInt32 = 0, failures: UInt32 = 0,
        mode: UInt32 = 3,
        brr: UInt32? = nil, enabled: Bool? = nil, file: StaticString = #filePath, line: UInt = #line
    ) -> LLSerialImage {
        let c = CL54_Create()!
        defer { CL54_Destroy(c) }
        CL54_Reset(c, seed, salt, instance, failures, mode)
        let io = LLSerialImage(seed: seed, salt: salt, instance: instance, failures: failures, mode: mode)
        if let brr {
            io.cells[Int(instance * 16 + 3)] = brr
            CL54_GetCells(c)[Int(instance * 16 + 3)] = brr
        }
        if let enabled {
            io.cells[Int(instance * 16)] = (io.cells[Int(instance * 16)] & ~1) | (enabled ? 1 : 0)
            CL54_GetCells(c)[Int(instance * 16)] = io.cells[Int(instance * 16)]
        }
        let sr = runLLSerial(op, io, args)
        let cr = CL54_Run(c, UInt32(op), args)
        let context = "op=\(op) seed=\(seed) salt=\(salt) instance=\(instance) args=\(args) mode=\(mode)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL54_GetCells(c), count: 1024)
        for i in cells.indices where cells[i] != io.cells[i] {
            XCTFail("\(context) cell \(i): Swift \(io.cells[i]), C \(cells[i])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL54_GetTrace(c), count: Int(CL54_GetTraceCount(c)))
        XCTAssertEqual(
            io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file,
            line: line)
        return io
    }
    func testEveryFunctionOnAllInstancesAndAtomicRetries() {
        for op in 0..<416 {
            for instance: UInt32 in 0..<8 {
                for sample: UInt32 in 0..<16 {
                    let seed = sample &* 0x9E37_79B9
                    var args = (0..<16).map { seed ^ (UInt32($0) &* 0x1020_4081) }
                    if op == 38 { args[0] = sample % 12 }
                    if op == 81 { args[1] = sample % 12 }
                    if op == 82 { args[1] = sample % 12 }
                    if op == 92 { args[0] = sample % 12 }
                    if op == 102 { args[0] = sample % 12 }
                    if op == 250 {
                        args[0] = sample % 12
                        args[1] = sample % 4 == 0 ? 0 : 9600 + sample * 1200
                    }
                    if op == 251 {
                        args[0] = sample % 12
                        args[1] = sample % 4 == 0 ? 0 : 9600 + sample * 1200
                    }
                    if op == 283 { args[0] = sample % 12 }
                    if op == 312 { args[1] = sample % 12 }
                    if op == 313 { args[1] = sample % 12 }
                    if op == 414 {
                        args[0] = sample % 12
                        args[1] = sample % 4 == 0 ? 0 : 9600 + sample * 1200
                    }
                    if op == 415 {
                        args[0] = sample % 12
                        args[1] = sample % 4 == 0 ? 0 : 9600 + sample * 1200
                    }
                    compare(
                        op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x1020_4081, instance: instance,
                        failures: sample % 4)
                }
            }
        }
    }
    func testBaudRateArithmeticAndRegisterBoundaries() {
        let clocks: [UInt32] = [0, 32_768, 4_000_000, 64_000_000, 480_000_000, .max]
        let bauds: [UInt32] = [0, 1, 300, 9600, 115200, 1_000_000, .max]
        let brrs: [UInt32] = [
            0, 1, 7, 8, 15, 16, 0x2FF, 0x300, 0xFFF, 0xFFFF, 0x10000, 0x10001, 0xFFFFF, 0x100000, .max,
        ]
        for clock in clocks {
            for prescaler: UInt32 in 0..<12 {
                for baud in bauds {
                    compare(81, [clock, prescaler, LL_USART_OVERSAMPLING_8, baud], seed: .max)
                    compare(81, [clock, prescaler, LL_USART_OVERSAMPLING_16, baud], seed: .max)
                    compare(312, [clock, prescaler, baud], seed: .max, instance: 7)
                    if baud != 0 { for op in 434..<437 { compare(op, [clock, prescaler, baud]) } }
                }
                for brr in brrs {
                    compare(82, [clock, prescaler, LL_USART_OVERSAMPLING_8], brr: brr)
                    compare(82, [clock, prescaler, LL_USART_OVERSAMPLING_16], brr: brr)
                    compare(313, [clock, prescaler], instance: 7, brr: brr)
                }
            }
        }
    }
    func testPrescalerNarrowingAndRejectedUSARTSetter() {
        for prescaler: UInt32 in 0..<12 {
            for high: UInt32 in [0, 256, 65536, 0xFFFF_FF00] {
                compare(82, [64_000_000, prescaler | high, LL_USART_OVERSAMPLING_8], brr: 555)
                compare(82, [64_000_000, prescaler | high, LL_USART_OVERSAMPLING_16], brr: 555)
            }
            for high: UInt32 in [0, 65536, 0xFFFF_0000] {
                compare(312, [64_000_000, prescaler | high, 115200], instance: 7)
                compare(313, [64_000_000, prescaler | high], instance: 7, brr: 0x12345)
                compare(436, [64_000_000, prescaler | high, 115200])
            }
        }
        for prescaler: UInt32 in [12, 255, 256, 65535, 65536, .max] {
            for baud: UInt32 in [0, 9600] {
                for over: UInt32 in [0, LL_USART_OVERSAMPLING_8] {
                    let io = compare(81, [64_000_000, prescaler, over, baud], seed: .max)
                    XCTAssertTrue(io.trace.isEmpty)
                }
            }
        }
    }
    func testInitializationUsesOriginalRCCClockQueries() {
        for op in [250, 414] {
            for instance: UInt32 in 0..<8 {
                for source: UInt32 in 0..<8 {
                    for sys: UInt32 in 0..<4 {
                        for ready: UInt32 in 0..<2 {
                            for custom: UInt32 in 0..<2 {
                                for enabled in [false, true] {
                                    let mode =
                                        source | (sys << 4) | ((source % 4) << 6) | (ready * 256) | (custom * 512)
                                    let args: [UInt32] = [
                                        source % 12, 115200, 0, 0, 0, LL_USART_DIRECTION_TX_RX, 0,
                                        LL_USART_OVERSAMPLING_8,
                                    ]
                                    compare(op, args, instance: instance, mode: mode, enabled: enabled)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func testAliasesAndRawRegisterMacros() {
        for op in 416..<434 {
            for instance: UInt32 in 0..<8 {
                for sample: UInt32 in 0..<16 {
                    compare(
                        op, [sample &* 0x9E37_79B9], seed: sample, salt: 0x1020_4081, instance: instance,
                        failures: sample % 4)
                }
            }
        }
    }
    func testIndependentAtomicWidthAndPartialInitializationContracts() {
        let io = LLSerialImage(seed: 0, salt: 0, instance: 0, failures: 2, mode: 3)
        io.cells[0] = 0
        LL_USART_EnableIT_RXNE_RXFNE(io)
        XCTAssertEqual(io.trace.map(\.kind), [2, 4, 2, 4, 2, 3])
        XCTAssertEqual(io.cells[0], 1 << 5)
        io.trace.removeAll()
        LL_USART_TransmitData9(io, 0xFFFF)
        XCTAssertEqual(io.trace, [.init(index: 10, value: 0x1FF, kind: 1)])
        io.trace.removeAll()
        io.cells[3] = 0x10001
        XCTAssertEqual(LL_USART_GetBaudRate(io, 64_000_000, 0, LL_USART_OVERSAMPLING_16), 64_000_000 / 0x10001)
        io.trace.removeAll()
        io.cells[0] = 0
        var clocks = io
        var config = LL_USART_InitTypeDef()
        LL_USART_StructInit(&config)
        config.BaudRate = 0
        config.PrescalerValue = 5
        XCTAssertEqual(LL_USART_Init(io, config, clocks: &clocks), .error)
        XCTAssertEqual(io.cells[11] & 15, 5)
        XCTAssertEqual(io.trace.last?.index, 11)
        XCTAssertTrue(io.trace.contains { $0.index == 0 && $0.kind == 1 })
        XCTAssertFalse(io.trace.contains { $0.index == 3 && $0.kind == 1 })
    }
    func testNarrowRegisterAssignmentsPreserveUInt16Casts() {
        let inputs: [UInt32] = [0, 1, 11, 12, 255, 256, 65535, 65536, 0x1234_5678, 0xABCD_EF01, 0x8000_0000, .max]
        for op in [38, 92, 102, 104, 283] {
            for instance: UInt32 in 0..<8 {
                for value in inputs {
                    compare(op, [value], seed: 0xA5A5_A5A5, salt: 0x1020_4081, instance: instance)
                }
            }
        }
        let io = LLSerialImage(seed: 0, salt: 0, instance: 0, failures: 0, mode: 3)
        io.cells[4] = 0
        LL_USART_SetSmartcardGuardTime(io, 0x1234_5678)
        XCTAssertEqual(io.cells[4], 0x7800)
        io.cells[11] = 0
        LL_USART_SetPrescaler(io, 0xABCD_EF01)
        XCTAssertEqual(io.cells[11], 0xEF01)
    }
    func testPinnedConstantsAndPrescalerTables() {
        let constants: [UInt32] = [
            LL_USART_ICR_PECF,
            LL_USART_ICR_FECF,
            LL_USART_ICR_NECF,
            LL_USART_ICR_ORECF,
            LL_USART_ICR_IDLECF,
            LL_USART_ICR_TXFECF,
            LL_USART_ICR_TCCF,
            LL_USART_ICR_TCBGTCF,
            LL_USART_ICR_LBDCF,
            LL_USART_ICR_CTSCF,
            LL_USART_ICR_RTOCF,
            LL_USART_ICR_EOBCF,
            LL_USART_ICR_UDRCF,
            LL_USART_ICR_CMCF,
            LL_USART_ICR_WUCF,
            LL_USART_ISR_PE,
            LL_USART_ISR_FE,
            LL_USART_ISR_NE,
            LL_USART_ISR_ORE,
            LL_USART_ISR_IDLE,
            LL_USART_ISR_RXNE_RXFNE,
            LL_USART_ISR_TC,
            LL_USART_ISR_TXE_TXFNF,
            LL_USART_ISR_LBDF,
            LL_USART_ISR_CTSIF,
            LL_USART_ISR_CTS,
            LL_USART_ISR_RTOF,
            LL_USART_ISR_EOBF,
            LL_USART_ISR_UDR,
            LL_USART_ISR_ABRE,
            LL_USART_ISR_ABRF,
            LL_USART_ISR_BUSY,
            LL_USART_ISR_CMF,
            LL_USART_ISR_SBKF,
            LL_USART_ISR_RWU,
            LL_USART_ISR_WUF,
            LL_USART_ISR_TEACK,
            LL_USART_ISR_REACK,
            LL_USART_ISR_TXFE,
            LL_USART_ISR_RXFF,
            LL_USART_ISR_TCBGT,
            LL_USART_ISR_RXFT,
            LL_USART_ISR_TXFT,
            LL_USART_CR1_IDLEIE,
            LL_USART_CR1_RXNEIE_RXFNEIE,
            LL_USART_CR1_TCIE,
            LL_USART_CR1_TXEIE_TXFNFIE,
            LL_USART_CR1_PEIE,
            LL_USART_CR1_CMIE,
            LL_USART_CR1_RTOIE,
            LL_USART_CR1_EOBIE,
            LL_USART_CR1_TXFEIE,
            LL_USART_CR1_RXFFIE,
            LL_USART_CR2_LBDIE,
            LL_USART_CR3_EIE,
            LL_USART_CR3_CTSIE,
            LL_USART_CR3_WUFIE,
            LL_USART_CR3_TXFTIE,
            LL_USART_CR3_TCBGTIE,
            LL_USART_CR3_RXFTIE,
            LL_USART_FIFOTHRESHOLD_1_8,
            LL_USART_FIFOTHRESHOLD_1_4,
            LL_USART_FIFOTHRESHOLD_1_2,
            LL_USART_FIFOTHRESHOLD_3_4,
            LL_USART_FIFOTHRESHOLD_7_8,
            LL_USART_FIFOTHRESHOLD_8_8,
            LL_USART_DIRECTION_NONE,
            LL_USART_DIRECTION_RX,
            LL_USART_DIRECTION_TX,
            LL_USART_DIRECTION_TX_RX,
            LL_USART_PARITY_NONE,
            LL_USART_PARITY_EVEN,
            LL_USART_PARITY_ODD,
            LL_USART_WAKEUP_IDLELINE,
            LL_USART_WAKEUP_ADDRESSMARK,
            LL_USART_DATAWIDTH_7B,
            LL_USART_DATAWIDTH_8B,
            LL_USART_DATAWIDTH_9B,
            LL_USART_OVERSAMPLING_16,
            LL_USART_OVERSAMPLING_8,
            LL_USART_CLOCK_DISABLE,
            LL_USART_CLOCK_ENABLE,
            LL_USART_LASTCLKPULSE_NO_OUTPUT,
            LL_USART_LASTCLKPULSE_OUTPUT,
            LL_USART_PHASE_1EDGE,
            LL_USART_PHASE_2EDGE,
            LL_USART_POLARITY_LOW,
            LL_USART_POLARITY_HIGH,
            LL_USART_PRESCALER_DIV1,
            LL_USART_PRESCALER_DIV2,
            LL_USART_PRESCALER_DIV4,
            LL_USART_PRESCALER_DIV6,
            LL_USART_PRESCALER_DIV8,
            LL_USART_PRESCALER_DIV10,
            LL_USART_PRESCALER_DIV12,
            LL_USART_PRESCALER_DIV16,
            LL_USART_PRESCALER_DIV32,
            LL_USART_PRESCALER_DIV64,
            LL_USART_PRESCALER_DIV128,
            LL_USART_PRESCALER_DIV256,
            LL_USART_STOPBITS_0_5,
            LL_USART_STOPBITS_1,
            LL_USART_STOPBITS_1_5,
            LL_USART_STOPBITS_2,
            LL_USART_TXRX_STANDARD,
            LL_USART_TXRX_SWAPPED,
            LL_USART_RXPIN_LEVEL_STANDARD,
            LL_USART_RXPIN_LEVEL_INVERTED,
            LL_USART_TXPIN_LEVEL_STANDARD,
            LL_USART_TXPIN_LEVEL_INVERTED,
            LL_USART_BINARY_LOGIC_POSITIVE,
            LL_USART_BINARY_LOGIC_NEGATIVE,
            LL_USART_BITORDER_LSBFIRST,
            LL_USART_BITORDER_MSBFIRST,
            LL_USART_AUTOBAUD_DETECT_ON_STARTBIT,
            LL_USART_AUTOBAUD_DETECT_ON_FALLINGEDGE,
            LL_USART_AUTOBAUD_DETECT_ON_7F_FRAME,
            LL_USART_AUTOBAUD_DETECT_ON_55_FRAME,
            LL_USART_ADDRESS_DETECT_4B,
            LL_USART_ADDRESS_DETECT_7B,
            LL_USART_HWCONTROL_NONE,
            LL_USART_HWCONTROL_RTS,
            LL_USART_HWCONTROL_CTS,
            LL_USART_HWCONTROL_RTS_CTS,
            LL_USART_WAKEUP_ON_ADDRESS,
            LL_USART_WAKEUP_ON_STARTBIT,
            LL_USART_WAKEUP_ON_RXNE,
            LL_USART_IRDA_POWER_NORMAL,
            LL_USART_IRDA_POWER_LOW,
            LL_USART_LINBREAK_DETECT_10B,
            LL_USART_LINBREAK_DETECT_11B,
            LL_USART_DE_POLARITY_HIGH,
            LL_USART_DE_POLARITY_LOW,
            LL_USART_DMA_REG_DATA_TRANSMIT,
            LL_USART_DMA_REG_DATA_RECEIVE,
            LL_LPUART_ICR_PECF,
            LL_LPUART_ICR_FECF,
            LL_LPUART_ICR_NCF,
            LL_LPUART_ICR_ORECF,
            LL_LPUART_ICR_IDLECF,
            LL_LPUART_ICR_TCCF,
            LL_LPUART_ICR_CTSCF,
            LL_LPUART_ICR_CMCF,
            LL_LPUART_ICR_WUCF,
            LL_LPUART_ISR_PE,
            LL_LPUART_ISR_FE,
            LL_LPUART_ISR_NE,
            LL_LPUART_ISR_ORE,
            LL_LPUART_ISR_IDLE,
            LL_LPUART_ISR_RXNE_RXFNE,
            LL_LPUART_ISR_TC,
            LL_LPUART_ISR_TXE_TXFNF,
            LL_LPUART_ISR_CTSIF,
            LL_LPUART_ISR_CTS,
            LL_LPUART_ISR_BUSY,
            LL_LPUART_ISR_CMF,
            LL_LPUART_ISR_SBKF,
            LL_LPUART_ISR_RWU,
            LL_LPUART_ISR_WUF,
            LL_LPUART_ISR_TEACK,
            LL_LPUART_ISR_REACK,
            LL_LPUART_ISR_TXFE,
            LL_LPUART_ISR_RXFF,
            LL_LPUART_ISR_RXFT,
            LL_LPUART_ISR_TXFT,
            LL_LPUART_CR1_IDLEIE,
            LL_LPUART_CR1_RXNEIE_RXFNEIE,
            LL_LPUART_CR1_TCIE,
            LL_LPUART_CR1_TXEIE_TXFNFIE,
            LL_LPUART_CR1_PEIE,
            LL_LPUART_CR1_CMIE,
            LL_LPUART_CR1_TXFEIE,
            LL_LPUART_CR1_RXFFIE,
            LL_LPUART_CR3_EIE,
            LL_LPUART_CR3_CTSIE,
            LL_LPUART_CR3_WUFIE,
            LL_LPUART_CR3_TXFTIE,
            LL_LPUART_CR3_RXFTIE,
            LL_LPUART_FIFOTHRESHOLD_1_8,
            LL_LPUART_FIFOTHRESHOLD_1_4,
            LL_LPUART_FIFOTHRESHOLD_1_2,
            LL_LPUART_FIFOTHRESHOLD_3_4,
            LL_LPUART_FIFOTHRESHOLD_7_8,
            LL_LPUART_FIFOTHRESHOLD_8_8,
            LL_LPUART_DIRECTION_NONE,
            LL_LPUART_DIRECTION_RX,
            LL_LPUART_DIRECTION_TX,
            LL_LPUART_DIRECTION_TX_RX,
            LL_LPUART_PARITY_NONE,
            LL_LPUART_PARITY_EVEN,
            LL_LPUART_PARITY_ODD,
            LL_LPUART_WAKEUP_IDLELINE,
            LL_LPUART_WAKEUP_ADDRESSMARK,
            LL_LPUART_DATAWIDTH_7B,
            LL_LPUART_DATAWIDTH_8B,
            LL_LPUART_DATAWIDTH_9B,
            LL_LPUART_PRESCALER_DIV1,
            LL_LPUART_PRESCALER_DIV2,
            LL_LPUART_PRESCALER_DIV4,
            LL_LPUART_PRESCALER_DIV6,
            LL_LPUART_PRESCALER_DIV8,
            LL_LPUART_PRESCALER_DIV10,
            LL_LPUART_PRESCALER_DIV12,
            LL_LPUART_PRESCALER_DIV16,
            LL_LPUART_PRESCALER_DIV32,
            LL_LPUART_PRESCALER_DIV64,
            LL_LPUART_PRESCALER_DIV128,
            LL_LPUART_PRESCALER_DIV256,
            LL_LPUART_STOPBITS_1,
            LL_LPUART_STOPBITS_2,
            LL_LPUART_TXRX_STANDARD,
            LL_LPUART_TXRX_SWAPPED,
            LL_LPUART_RXPIN_LEVEL_STANDARD,
            LL_LPUART_RXPIN_LEVEL_INVERTED,
            LL_LPUART_TXPIN_LEVEL_STANDARD,
            LL_LPUART_TXPIN_LEVEL_INVERTED,
            LL_LPUART_BINARY_LOGIC_POSITIVE,
            LL_LPUART_BINARY_LOGIC_NEGATIVE,
            LL_LPUART_BITORDER_LSBFIRST,
            LL_LPUART_BITORDER_MSBFIRST,
            LL_LPUART_ADDRESS_DETECT_4B,
            LL_LPUART_ADDRESS_DETECT_7B,
            LL_LPUART_HWCONTROL_NONE,
            LL_LPUART_HWCONTROL_RTS,
            LL_LPUART_HWCONTROL_CTS,
            LL_LPUART_HWCONTROL_RTS_CTS,
            LL_LPUART_WAKEUP_ON_ADDRESS,
            LL_LPUART_WAKEUP_ON_STARTBIT,
            LL_LPUART_WAKEUP_ON_RXNE,
            LL_LPUART_DE_POLARITY_HIGH,
            LL_LPUART_DE_POLARITY_LOW,
            LL_LPUART_DMA_REG_DATA_TRANSMIT,
            LL_LPUART_DMA_REG_DATA_RECEIVE,
        ]
        for (i, v) in constants.enumerated() { XCTAssertEqual(v, CL54_Constant(UInt32(i))) }
        let divisors: [UInt32] = [1, 2, 4, 6, 8, 10, 12, 16, 32, 64, 128, 256]
        for (i, d) in divisors.enumerated() {
            XCTAssertEqual(d, CL54_Constant(UInt32(233 + i)))
            XCTAssertEqual(d, CL54_Constant(UInt32(245 + i)))
            XCTAssertEqual(__LL_USART_DIV_SAMPLING16(256, UInt32(i), 1), 256 / d)
        }
    }
}
