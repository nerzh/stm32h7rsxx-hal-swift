import CLLReference
import STM32H7RSHAL
import XCTest

private struct LLSPIAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}
private final class LLSPIImage: SPIRegisterIO, LLRCCRegisterIO {
    var cells: [UInt32]
    var trace: [LLSPIAccess] = []
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
        cells[275] = ((mode >> 10) & 3) << 28
        cells[276] = (mode & 7) << 4
        cells[277] = (mode & 7) << 8
        cells[278] = (mode & 7) << 4
        cells[284] = mode & 256 != 0 ? 0 : 2
        self.salt = salt
        self.instanceID = instance
        self.failures = failures
        self.mode = mode
    }
    var instance: SPIInstance {
        let instances: [SPIInstance] = [.spi1, .spi2, .spi3, .spi4, .spi5, .spi6]
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
    func spiIndex(_ r: SPIRegister) -> Int { Int(instanceID) * 32 + Int(r.rawValue / 4) }
    func read(_ r: SPIRegister) -> UInt32 { readIndex(spiIndex(r)) }
    func write(_ r: SPIRegister, value: UInt32) { writeIndex(spiIndex(r), value) }
    func address(of r: SPIRegister) -> UInt32 { instance.rawValue + r.rawValue }
    func readN(_ r: SPIRegister, _ width: UInt32) -> UInt32 {
        let index = spiIndex(r)
        let mask: UInt32 = width == 8 ? 0xFF : 0xFFFF
        let value = (cells[index] ^ (salt &* reads)) & mask
        reads &+= 1
        trace.append(.init(index: UInt32(index), value: value, kind: width == 8 ? 2 : 4))
        return value
    }
    func writeN(_ r: SPIRegister, _ value: UInt32, _ width: UInt32) {
        let index = spiIndex(r)
        let mask: UInt32 = width == 8 ? 0xFF : 0xFFFF
        trace.append(.init(index: UInt32(index), value: value, kind: width == 8 ? 3 : 5))
        cells[index] = (cells[index] & ~mask) | value
    }
    func read8(_ r: SPIRegister) -> UInt8 { UInt8(readN(r, 8)) }
    func write8(_ r: SPIRegister, value: UInt8) { writeN(r, UInt32(value), 8) }
    func read16(_ r: SPIRegister) -> UInt16 { UInt16(readN(r, 16)) }
    func write16(_ r: SPIRegister, value: UInt16) { writeN(r, UInt32(value), 16) }
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
        preconditionFailure("Unused LL SPI operation")
    }
    func read(_ r: FlashTimingRegister) -> UInt32 { preconditionFailure("Unused LL SPI register") }
    func write(_ r: FlashTimingRegister, value: UInt32) { preconditionFailure("Unused LL SPI register") }
    func read(_ r: EXTIRegister) -> UInt32 { preconditionFailure("Unused LL SPI register") }
    func write(_ r: EXTIRegister, value: UInt32) { preconditionFailure("Unused LL SPI register") }
}
private func runLLSPI(_ op: Int, _ io: LLSPIImage, _ args: [UInt32]) -> UInt32 {
    var uart = io
    var clocks = io
    switch op {
    case 0:
        LL_SPI_Enable(io)
        return 0
    case 1:
        LL_SPI_Disable(io)
        return 0
    case 2:
        let result = LL_SPI_IsEnabled(io)
        return result
    case 3:
        LL_SPI_EnableIOSwap(io)
        return 0
    case 4:
        LL_SPI_DisableIOSwap(io)
        return 0
    case 5:
        let result = LL_SPI_IsEnabledIOSwap(io)
        return result
    case 6:
        LL_SPI_EnableGPIOControl(io)
        return 0
    case 7:
        LL_SPI_DisableGPIOControl(io)
        return 0
    case 8:
        let result = LL_SPI_IsEnabledGPIOControl(io)
        return result
    case 9:
        LL_SPI_SetMode(io, args[0])
        return 0
    case 10:
        let result = LL_SPI_GetMode(io)
        return result
    case 11:
        LL_SPI_SetMasterSSIdleness(io, args[0])
        return 0
    case 12:
        let result = LL_SPI_GetMasterSSIdleness(io)
        return result
    case 13:
        LL_SPI_SetInterDataIdleness(io, args[0])
        return 0
    case 14:
        let result = LL_SPI_GetInterDataIdleness(io)
        return result
    case 15:
        LL_SPI_SetTransferSize(io, args[0])
        return 0
    case 16:
        let result = LL_SPI_GetTransferSize(io)
        return result
    case 17:
        LL_SPI_EnableIOLock(io)
        return 0
    case 18:
        let result = LL_SPI_IsEnabledIOLock(io)
        return result
    case 19:
        LL_SPI_SetTxCRCInitPattern(io, args[0])
        return 0
    case 20:
        let result = LL_SPI_GetTxCRCInitPattern(io)
        return result
    case 21:
        LL_SPI_SetRxCRCInitPattern(io, args[0])
        return 0
    case 22:
        let result = LL_SPI_GetRxCRCInitPattern(io)
        return result
    case 23:
        LL_SPI_SetInternalSSLevel(io, args[0])
        return 0
    case 24:
        let result = LL_SPI_GetInternalSSLevel(io)
        return result
    case 25:
        LL_SPI_EnableFullSizeCRC(io)
        return 0
    case 26:
        LL_SPI_DisableFullSizeCRC(io)
        return 0
    case 27:
        let result = LL_SPI_IsEnabledFullSizeCRC(io)
        return result
    case 28:
        LL_SPI_SuspendMasterTransfer(io)
        return 0
    case 29:
        LL_SPI_StartMasterTransfer(io)
        return 0
    case 30:
        let result = LL_SPI_IsActiveMasterTransfer(io)
        return result
    case 31:
        LL_SPI_EnableMasterRxAutoSuspend(io)
        return 0
    case 32:
        LL_SPI_DisableMasterRxAutoSuspend(io)
        return 0
    case 33:
        let result = LL_SPI_IsEnabledMasterRxAutoSuspend(io)
        return result
    case 34:
        LL_SPI_SetUDRConfiguration(io, args[0])
        return 0
    case 35:
        let result = LL_SPI_GetUDRConfiguration(io)
        return result
    case 36:
        LL_SPI_SetStandard(io, args[0])
        return 0
    case 37:
        let result = LL_SPI_GetStandard(io)
        return result
    case 38:
        LL_SPI_SetClockPhase(io, args[0])
        return 0
    case 39:
        let result = LL_SPI_GetClockPhase(io)
        return result
    case 40:
        LL_SPI_SetClockPolarity(io, args[0])
        return 0
    case 41:
        let result = LL_SPI_GetClockPolarity(io)
        return result
    case 42:
        LL_SPI_SetNSSPolarity(io, args[0])
        return 0
    case 43:
        let result = LL_SPI_GetNSSPolarity(io)
        return result
    case 44:
        LL_SPI_SetBaudRatePrescaler(io, args[0])
        return 0
    case 45:
        let result = LL_SPI_GetBaudRatePrescaler(io)
        return result
    case 46:
        LL_SPI_SetTransferBitOrder(io, args[0])
        return 0
    case 47:
        let result = LL_SPI_GetTransferBitOrder(io)
        return result
    case 48:
        LL_SPI_SetTransferDirection(io, args[0])
        return 0
    case 49:
        let result = LL_SPI_GetTransferDirection(io)
        return result
    case 50:
        LL_SPI_SetHalfDuplexDirection(io, args[0])
        return 0
    case 51:
        let result = LL_SPI_GetHalfDuplexDirection(io)
        return result
    case 52:
        LL_SPI_SetDataWidth(io, args[0])
        return 0
    case 53:
        let result = LL_SPI_GetDataWidth(io)
        return result
    case 54:
        LL_SPI_SetFIFOThreshold(io, args[0])
        return 0
    case 55:
        let result = LL_SPI_GetFIFOThreshold(io)
        return result
    case 56:
        LL_SPI_EnableCRC(io)
        return 0
    case 57:
        LL_SPI_DisableCRC(io)
        return 0
    case 58:
        let result = LL_SPI_IsEnabledCRC(io)
        return result
    case 59:
        LL_SPI_SetCRCWidth(io, args[0])
        return 0
    case 60:
        let result = LL_SPI_GetCRCWidth(io)
        return result
    case 61:
        LL_SPI_SetNSSMode(io, args[0])
        return 0
    case 62:
        let result = LL_SPI_GetNSSMode(io)
        return result
    case 63:
        LL_SPI_EnableNSSPulseMgt(io)
        return 0
    case 64:
        LL_SPI_DisableNSSPulseMgt(io)
        return 0
    case 65:
        let result = LL_SPI_IsEnabledNSSPulse(io)
        return result
    case 66:
        let result = LL_SPI_IsActiveFlag_RXP(io)
        return result
    case 67:
        let result = LL_SPI_IsActiveFlag_TXP(io)
        return result
    case 68:
        let result = LL_SPI_IsActiveFlag_DXP(io)
        return result
    case 69:
        let result = LL_SPI_IsActiveFlag_EOT(io)
        return result
    case 70:
        let result = LL_SPI_IsActiveFlag_TXTF(io)
        return result
    case 71:
        let result = LL_SPI_IsActiveFlag_UDR(io)
        return result
    case 72:
        let result = LL_SPI_IsActiveFlag_CRCERR(io)
        return result
    case 73:
        let result = LL_SPI_IsActiveFlag_MODF(io)
        return result
    case 74:
        let result = LL_SPI_IsActiveFlag_OVR(io)
        return result
    case 75:
        let result = LL_SPI_IsActiveFlag_FRE(io)
        return result
    case 76:
        let result = LL_SPI_IsActiveFlag_SUSP(io)
        return result
    case 77:
        let result = LL_SPI_IsActiveFlag_TXC(io)
        return result
    case 78:
        let result = LL_SPI_IsActiveFlag_RXWNE(io)
        return result
    case 79:
        let result = LL_SPI_GetRemainingDataFrames(io)
        return result
    case 80:
        let result = LL_SPI_GetRxFIFOPackingLevel(io)
        return result
    case 81:
        LL_SPI_ClearFlag_EOT(io)
        return 0
    case 82:
        LL_SPI_ClearFlag_TXTF(io)
        return 0
    case 83:
        LL_SPI_ClearFlag_UDR(io)
        return 0
    case 84:
        LL_SPI_ClearFlag_OVR(io)
        return 0
    case 85:
        LL_SPI_ClearFlag_CRCERR(io)
        return 0
    case 86:
        LL_SPI_ClearFlag_MODF(io)
        return 0
    case 87:
        LL_SPI_ClearFlag_FRE(io)
        return 0
    case 88:
        LL_SPI_ClearFlag_SUSP(io)
        return 0
    case 89:
        LL_SPI_EnableIT_RXP(io)
        return 0
    case 90:
        LL_SPI_EnableIT_TXP(io)
        return 0
    case 91:
        LL_SPI_EnableIT_DXP(io)
        return 0
    case 92:
        LL_SPI_EnableIT_EOT(io)
        return 0
    case 93:
        LL_SPI_EnableIT_TXTF(io)
        return 0
    case 94:
        LL_SPI_EnableIT_UDR(io)
        return 0
    case 95:
        LL_SPI_EnableIT_OVR(io)
        return 0
    case 96:
        LL_SPI_EnableIT_CRCERR(io)
        return 0
    case 97:
        LL_SPI_EnableIT_FRE(io)
        return 0
    case 98:
        LL_SPI_EnableIT_MODF(io)
        return 0
    case 99:
        LL_SPI_DisableIT_RXP(io)
        return 0
    case 100:
        LL_SPI_DisableIT_TXP(io)
        return 0
    case 101:
        LL_SPI_DisableIT_DXP(io)
        return 0
    case 102:
        LL_SPI_DisableIT_EOT(io)
        return 0
    case 103:
        LL_SPI_DisableIT_TXTF(io)
        return 0
    case 104:
        LL_SPI_DisableIT_UDR(io)
        return 0
    case 105:
        LL_SPI_DisableIT_OVR(io)
        return 0
    case 106:
        LL_SPI_DisableIT_CRCERR(io)
        return 0
    case 107:
        LL_SPI_DisableIT_FRE(io)
        return 0
    case 108:
        LL_SPI_DisableIT_MODF(io)
        return 0
    case 109:
        let result = LL_SPI_IsEnabledIT_RXP(io)
        return result
    case 110:
        let result = LL_SPI_IsEnabledIT_TXP(io)
        return result
    case 111:
        let result = LL_SPI_IsEnabledIT_DXP(io)
        return result
    case 112:
        let result = LL_SPI_IsEnabledIT_EOT(io)
        return result
    case 113:
        let result = LL_SPI_IsEnabledIT_TXTF(io)
        return result
    case 114:
        let result = LL_SPI_IsEnabledIT_UDR(io)
        return result
    case 115:
        let result = LL_SPI_IsEnabledIT_OVR(io)
        return result
    case 116:
        let result = LL_SPI_IsEnabledIT_CRCERR(io)
        return result
    case 117:
        let result = LL_SPI_IsEnabledIT_FRE(io)
        return result
    case 118:
        let result = LL_SPI_IsEnabledIT_MODF(io)
        return result
    case 119:
        LL_SPI_EnableDMAReq_RX(io)
        return 0
    case 120:
        LL_SPI_DisableDMAReq_RX(io)
        return 0
    case 121:
        let result = LL_SPI_IsEnabledDMAReq_RX(io)
        return result
    case 122:
        LL_SPI_EnableDMAReq_TX(io)
        return 0
    case 123:
        LL_SPI_DisableDMAReq_TX(io)
        return 0
    case 124:
        let result = LL_SPI_IsEnabledDMAReq_TX(io)
        return result
    case 125:
        let result = LL_SPI_DMA_GetTxRegAddr(io)
        return result
    case 126:
        let result = LL_SPI_DMA_GetRxRegAddr(io)
        return result
    case 127:
        let result = UInt32(LL_SPI_ReceiveData8(io))
        return result
    case 128:
        let result = UInt32(LL_SPI_ReceiveData16(io))
        return result
    case 129:
        let result = LL_SPI_ReceiveData32(io)
        return result
    case 130:
        LL_SPI_TransmitData8(io, UInt8(truncatingIfNeeded: args[0]))
        return 0
    case 131:
        LL_SPI_TransmitData16(io, UInt16(truncatingIfNeeded: args[0]))
        return 0
    case 132:
        LL_SPI_TransmitData32(io, args[0])
        return 0
    case 133:
        LL_SPI_SetCRCPolynomial(io, args[0])
        return 0
    case 134:
        let result = LL_SPI_GetCRCPolynomial(io)
        return result
    case 135:
        LL_SPI_SetUDRPattern(io, args[0])
        return 0
    case 136:
        let result = LL_SPI_GetUDRPattern(io)
        return result
    case 137:
        let result = LL_SPI_GetRxCRC(io)
        return result
    case 138:
        let result = LL_SPI_GetTxCRC(io)
        return result
    case 139:
        LL_I2S_SetDataFormat(io, args[0])
        return 0
    case 140:
        let result = LL_I2S_GetDataFormat(io)
        return result
    case 141:
        LL_I2S_SetChannelLengthType(io, args[0])
        return 0
    case 142:
        let result = LL_I2S_GetChannelLengthType(io)
        return result
    case 143:
        LL_I2S_EnableWordSelectInversion(io)
        return 0
    case 144:
        LL_I2S_DisableWordSelectInversion(io)
        return 0
    case 145:
        let result = LL_I2S_IsEnabledWordSelectInversion(io)
        return result
    case 146:
        LL_I2S_SetClockPolarity(io, args[0])
        return 0
    case 147:
        let result = LL_I2S_GetClockPolarity(io)
        return result
    case 148:
        LL_I2S_SetStandard(io, args[0])
        return 0
    case 149:
        let result = LL_I2S_GetStandard(io)
        return result
    case 150:
        LL_I2S_SetTransferMode(io, args[0])
        return 0
    case 151:
        let result = LL_I2S_GetTransferMode(io)
        return result
    case 152:
        LL_I2S_Enable(io)
        return 0
    case 153:
        LL_I2S_Disable(io)
        return 0
    case 154:
        LL_I2S_EnableIOSwap(io)
        return 0
    case 155:
        LL_I2S_DisableIOSwap(io)
        return 0
    case 156:
        let result = LL_I2S_IsEnabledIOSwap(io)
        return result
    case 157:
        LL_I2S_EnableGPIOControl(io)
        return 0
    case 158:
        LL_I2S_DisableGPIOControl(io)
        return 0
    case 159:
        let result = LL_I2S_IsEnabledGPIOControl(io)
        return result
    case 160:
        LL_I2S_EnableIOLock(io)
        return 0
    case 161:
        let result = LL_I2S_IsEnabledIOLock(io)
        return result
    case 162:
        LL_I2S_SetTransferBitOrder(io, args[0])
        return 0
    case 163:
        let result = LL_I2S_GetTransferBitOrder(io)
        return result
    case 164:
        LL_I2S_StartTransfer(io)
        return 0
    case 165:
        let result = LL_I2S_IsActiveTransfer(io)
        return result
    case 166:
        LL_I2S_SetFIFOThreshold(io, args[0])
        return 0
    case 167:
        let result = LL_I2S_GetFIFOThreshold(io)
        return result
    case 168:
        LL_I2S_SetPrescalerLinear(io, args[0])
        return 0
    case 169:
        let result = LL_I2S_GetPrescalerLinear(io)
        return result
    case 170:
        LL_I2S_SetPrescalerParity(io, args[0])
        return 0
    case 171:
        let result = LL_I2S_GetPrescalerParity(io)
        return result
    case 172:
        LL_I2S_EnableMasterClock(io)
        return 0
    case 173:
        LL_I2S_DisableMasterClock(io)
        return 0
    case 174:
        let result = LL_I2S_IsEnabledMasterClock(io)
        return result
    case 175:
        let result = LL_I2S_IsActiveFlag_RXP(io)
        return result
    case 176:
        let result = LL_I2S_IsActiveFlag_TXP(io)
        return result
    case 177:
        let result = LL_I2S_IsActiveFlag_UDR(io)
        return result
    case 178:
        let result = LL_I2S_IsActiveFlag_OVR(io)
        return result
    case 179:
        let result = LL_I2S_IsActiveFlag_FRE(io)
        return result
    case 180:
        LL_I2S_ClearFlag_UDR(io)
        return 0
    case 181:
        LL_I2S_ClearFlag_OVR(io)
        return 0
    case 182:
        LL_I2S_ClearFlag_FRE(io)
        return 0
    case 183:
        LL_I2S_EnableIT_RXP(io)
        return 0
    case 184:
        LL_I2S_EnableIT_TXP(io)
        return 0
    case 185:
        LL_I2S_EnableIT_UDR(io)
        return 0
    case 186:
        LL_I2S_EnableIT_OVR(io)
        return 0
    case 187:
        LL_I2S_EnableIT_FRE(io)
        return 0
    case 188:
        LL_I2S_DisableIT_RXP(io)
        return 0
    case 189:
        LL_I2S_DisableIT_TXP(io)
        return 0
    case 190:
        LL_I2S_DisableIT_UDR(io)
        return 0
    case 191:
        LL_I2S_DisableIT_OVR(io)
        return 0
    case 192:
        LL_I2S_DisableIT_FRE(io)
        return 0
    case 193:
        let result = LL_I2S_IsEnabledIT_RXP(io)
        return result
    case 194:
        let result = LL_I2S_IsEnabledIT_TXP(io)
        return result
    case 195:
        let result = LL_I2S_IsEnabledIT_UDR(io)
        return result
    case 196:
        let result = LL_I2S_IsEnabledIT_OVR(io)
        return result
    case 197:
        let result = LL_I2S_IsEnabledIT_FRE(io)
        return result
    case 198:
        LL_I2S_EnableDMAReq_RX(io)
        return 0
    case 199:
        LL_I2S_DisableDMAReq_RX(io)
        return 0
    case 200:
        let result = LL_I2S_IsEnabledDMAReq_RX(io)
        return result
    case 201:
        LL_I2S_EnableDMAReq_TX(io)
        return 0
    case 202:
        LL_I2S_DisableDMAReq_TX(io)
        return 0
    case 203:
        let result = LL_I2S_IsEnabledDMAReq_TX(io)
        return result
    case 204:
        let result = UInt32(LL_I2S_ReceiveData16(io))
        return result
    case 205:
        let result = LL_I2S_ReceiveData32(io)
        return result
    case 206:
        LL_I2S_TransmitData16(io, UInt16(truncatingIfNeeded: args[0]))
        return 0
    case 207:
        LL_I2S_TransmitData32(io, args[0])
        return 0
    case 208:
        let result = LL_SPI_DeInit(&uart).rawValue
        return result
    case 209:
        var v1 = LL_SPI_InitTypeDef(
            TransferDirection: args[0], Mode: args[1], DataWidth: args[2], ClockPolarity: args[3], ClockPhase: args[4],
            NSS: args[5], BaudRate: args[6], BitOrder: args[7], CRCCalculation: args[8], CRCPoly: args[9])
        let result = LL_SPI_Init(io, &v1).rawValue
        io.cells[512] = v1.TransferDirection
        io.cells[513] = v1.Mode
        io.cells[514] = v1.DataWidth
        io.cells[515] = v1.ClockPolarity
        io.cells[516] = v1.ClockPhase
        io.cells[517] = v1.NSS
        io.cells[518] = v1.BaudRate
        io.cells[519] = v1.BitOrder
        io.cells[520] = v1.CRCCalculation
        io.cells[521] = v1.CRCPoly
        return result
    case 210:
        var v0 = LL_SPI_InitTypeDef(
            TransferDirection: args[0], Mode: args[1], DataWidth: args[2], ClockPolarity: args[3], ClockPhase: args[4],
            NSS: args[5], BaudRate: args[6], BitOrder: args[7], CRCCalculation: args[8], CRCPoly: args[9])
        LL_SPI_StructInit(&v0)
        io.cells[512] = v0.TransferDirection
        io.cells[513] = v0.Mode
        io.cells[514] = v0.DataWidth
        io.cells[515] = v0.ClockPolarity
        io.cells[516] = v0.ClockPhase
        io.cells[517] = v0.NSS
        io.cells[518] = v0.BaudRate
        io.cells[519] = v0.BitOrder
        io.cells[520] = v0.CRCCalculation
        io.cells[521] = v0.CRCPoly
        return 0
    case 211:
        let result = LL_I2S_DeInit(&uart).rawValue
        return result
    case 212:
        let v1 = LL_I2S_InitTypeDef(
            Mode: args[0], Standard: args[1], DataFormat: args[2], MCLKOutput: args[3], AudioFreq: args[4],
            ClockPolarity: args[5])
        let result = LL_I2S_Init(io, v1, clocks: &clocks, oscillators: io.oscillators).rawValue
        io.cells[512] = v1.Mode
        io.cells[513] = v1.Standard
        io.cells[514] = v1.DataFormat
        io.cells[515] = v1.MCLKOutput
        io.cells[516] = v1.AudioFreq
        io.cells[517] = v1.ClockPolarity
        return result
    case 213:
        var v0 = LL_I2S_InitTypeDef(
            Mode: args[0], Standard: args[1], DataFormat: args[2], MCLKOutput: args[3], AudioFreq: args[4],
            ClockPolarity: args[5])
        LL_I2S_StructInit(&v0)
        io.cells[512] = v0.Mode
        io.cells[513] = v0.Standard
        io.cells[514] = v0.DataFormat
        io.cells[515] = v0.MCLKOutput
        io.cells[516] = v0.AudioFreq
        io.cells[517] = v0.ClockPolarity
        return 0
    case 214:
        LL_I2S_ConfigPrescaler(io, args[0], args[1])
        return 0
    case 215:
        LL_SPI_WriteReg(io, .cr2, args[0])
        return LL_SPI_ReadReg(io, .cr2)
    case 216:
        LL_I2S_WriteReg(io, .cr2, args[0])
        return LL_I2S_ReadReg(io, .cr2)
    default: preconditionFailure("Unknown operation")
    }
}
final class LLSPIDifferentialTests: XCTestCase {
    @discardableResult
    private func compare(
        _ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0, instance: UInt32 = 0, failures: UInt32 = 0,
        mode: UInt32 = 0,
        enabled: Bool? = nil, file: StaticString = #filePath, line: UInt = #line
    ) -> LLSPIImage {
        let c = CL55_Create()!
        defer { CL55_Destroy(c) }
        CL55_Reset(c, seed, salt, instance, failures, mode)
        let io = LLSPIImage(seed: seed, salt: salt, instance: instance, failures: failures, mode: mode)
        if let enabled {
            io.cells[Int(instance * 32)] = (io.cells[Int(instance * 32)] & ~1) | (enabled ? 1 : 0)
            CL55_GetCells(c)[Int(instance * 32)] = io.cells[Int(instance * 32)]
        }
        let sr = runLLSPI(op, io, args)
        let cr = CL55_Run(c, UInt32(op), args)
        let context = "op=\(op) seed=\(seed) salt=\(salt) instance=\(instance) args=\(args) mode=\(mode)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL55_GetCells(c), count: 1024)
        for i in cells.indices where cells[i] != io.cells[i] {
            XCTFail("\(context) cell \(i): Swift \(io.cells[i]), C \(cells[i])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL55_GetTrace(c), count: Int(CL55_GetTraceCount(c)))
        XCTAssertEqual(
            io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file,
            line: line)
        return io
    }
    func testEveryFunctionOnAllSixInstancesAndChangingReads() {
        for op in 0..<215 {
            for instance: UInt32 in 0..<6 {
                for sample: UInt32 in 0..<32 {
                    let seed = sample &* 0x9E37_79B9
                    var args = (0..<16).map { seed ^ (UInt32($0) &* 0x1020_4081) }
                    if op == 212 && args[4] == 0 { args[4] = 1 }
                    compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x1020_4081, instance: instance)
                }
            }
        }
    }
    func testSPIInitializationNSSPolarityAndCRCPreservation() {
        let directions: [UInt32] = [
            LL_SPI_FULL_DUPLEX, LL_SPI_SIMPLEX_RX, LL_SPI_HALF_DUPLEX_RX, LL_SPI_HALF_DUPLEX_TX,
        ]
        let nss: [UInt32] = [LL_SPI_NSS_SOFT, LL_SPI_NSS_HARD_INPUT, LL_SPI_NSS_HARD_OUTPUT]
        for instance: UInt32 in 0..<6 {
            for enabled in [false, true] {
                for mode: UInt32 in [LL_SPI_MODE_SLAVE, LL_SPI_MODE_MASTER] {
                    for select in nss {
                        for polarity: UInt32 in [0, LL_SPI_NSS_POLARITY_HIGH] {
                            for crc: UInt32 in [0, LL_SPI_CRCCALCULATION_ENABLE] {
                                for direction in directions {
                                    let args: [UInt32] = [
                                        direction, mode, LL_SPI_DATAWIDTH_16BIT, LL_SPI_POLARITY_HIGH,
                                        LL_SPI_PHASE_2EDGE, select, LL_SPI_BAUDRATEPRESCALER_DIV32, LL_SPI_LSB_FIRST,
                                        crc, 0x1021,
                                    ]
                                    compare(209, args, seed: polarity, instance: instance, enabled: enabled)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func testI2SAudioDividerRoundingFallbackAndRetainedFields() {
        let formats: [UInt32] = [
            LL_I2S_DATAFORMAT_16B, LL_I2S_DATAFORMAT_16B_EXTENDED, LL_I2S_DATAFORMAT_24B,
            LL_I2S_DATAFORMAT_24B_LEFT_ALIGNED, LL_I2S_DATAFORMAT_32B,
        ]
        let standards: [UInt32] = [
            LL_I2S_STANDARD_PHILIPS, LL_I2S_STANDARD_MSB, LL_I2S_STANDARD_LSB, LL_I2S_STANDARD_PCM_SHORT,
            LL_I2S_STANDARD_PCM_LONG,
        ]
        let frequencies: [UInt32] = [
            1, 2, 3, 1000, 8000, 11025, 22050, 44100, 48000, 83333, 96000, 192000, 250000, 500000, 1_000_000, .max,
        ]
        for instance: UInt32 in 0..<6 {
            for format in formats {
                for standard in standards {
                    for mclk: UInt32 in [LL_I2S_MCLK_OUTPUT_DISABLE, LL_I2S_MCLK_OUTPUT_ENABLE] {
                        for frequency in frequencies {
                            compare(
                                212, [LL_I2S_MODE_MASTER_TX, standard, format, mclk, frequency, LL_I2S_POLARITY_HIGH],
                                seed: 0xA5A5_A5A5, instance: instance, mode: 3, enabled: false)
                        }
                    }
                }
            }
        }
    }
    func testI2SUsesOriginalRCCClockQueriesAndEnabledGuard() {
        for instance: UInt32 in 0..<6 {
            for source: UInt32 in 0..<8 {
                for clkp: UInt32 in 0..<4 {
                    for ready: UInt32 in 0..<2 {
                        for custom: UInt32 in 0..<2 {
                            for enabled in [false, true] {
                                let mode = source | (clkp << 10) | (ready * 256) | (custom * 512)
                                compare(
                                    212,
                                    [
                                        LL_I2S_MODE_MASTER_FULL_DUPLEX, LL_I2S_STANDARD_PHILIPS, LL_I2S_DATAFORMAT_32B,
                                        LL_I2S_MCLK_OUTPUT_ENABLE, 44100, 0,
                                    ], instance: instance, mode: mode, enabled: enabled)
                            }
                        }
                    }
                }
            }
        }
    }
    func testRawRegisterMacrosAndPrescalerFields() {
        for instance: UInt32 in 0..<6 {
            for sample: UInt32 in 0..<32 {
                let value = sample &* 0x1020_4081
                compare(215, [value], seed: ~value, salt: 0x1020_4081, instance: instance)
                compare(216, [value], seed: ~value, salt: 0x1020_4081, instance: instance)
                compare(214, [value, ~value], seed: ~value, salt: 0x1020_4081, instance: instance)
            }
        }
    }
    func testIndependentFIFOAccessWidthAndSourceQuirks() {
        let io = LLSPIImage(seed: 0, salt: 0, instance: 0, failures: 0, mode: 3)
        io.cells[8] = 0x1234_5678
        LL_SPI_TransmitData8(io, 0xAB)
        XCTAssertEqual(io.cells[8], 0x1234_56AB)
        LL_SPI_TransmitData16(io, 0xCDEF)
        XCTAssertEqual(io.cells[8], 0x1234_CDEF)
        LL_I2S_TransmitData16(io, 0x3456)
        XCTAssertEqual(io.cells[8], 0x1234_3456)
        io.cells[12] = 0x89AB_CDEF
        XCTAssertEqual(LL_SPI_ReceiveData8(io), 0xEF)
        XCTAssertEqual(LL_SPI_ReceiveData16(io), 0xCDEF)
        XCTAssertEqual(LL_I2S_ReceiveData32(io), 0x89AB_CDEF)
        XCTAssertEqual(io.trace.map(\.kind), [3, 5, 5, 2, 4, 0])
        io.cells[0] = 0
        XCTAssertEqual(LL_SPI_GetHalfDuplexDirection(io), 0x60000)
        io.cells[0] = 0
        io.cells[3] = LL_SPI_NSS_POLARITY_LOW
        io.cells[20] = 0x80
        var config = LL_SPI_InitTypeDef()
        LL_SPI_StructInit(&config)
        config.Mode = LL_SPI_MODE_MASTER
        config.NSS = LL_SPI_NSS_SOFT
        XCTAssertEqual(LL_SPI_Init(io, &config), .success)
        XCTAssertEqual(io.cells[0] & 0x1000, 0x1000)
        config.Mode = LL_SPI_MODE_SLAVE
        XCTAssertEqual(LL_SPI_Init(io, &config), .success)
        XCTAssertEqual(io.cells[0] & 0x1000, 0x1000)
        XCTAssertEqual(io.cells[20] & 0x80, 0x80)
        var audio = LL_I2S_InitTypeDef()
        LL_I2S_StructInit(&audio)
        audio.AudioFreq = LL_I2S_AUDIOFREQ_DEFAULT
        io.trace.removeAll()
        var clocks = io
        XCTAssertEqual(LL_I2S_Init(io, audio, clocks: &clocks), .success)
        XCTAssertFalse(io.trace.contains { $0.index >= 256 })
        XCTAssertEqual(io.cells[20] & 0x80, 0x80)
    }
    func testClockFixtureSelectorsAndDividerFallbackBoundaries() {
        let c = CL55_Create()!
        defer { CL55_Destroy(c) }
        for source: UInt32 in 0..<8 {
            for clkp: UInt32 in 0..<4 {
                let mode = source | (clkp << 10)
                CL55_Reset(c, 0, 0, 0, 0, mode)
                let cells = CL55_GetCells(c)!
                XCTAssertEqual((cells[275] >> 28) & 3, clkp)
                XCTAssertEqual((cells[276] >> 4) & 7, source)
                XCTAssertEqual((cells[277] >> 8) & 7, source)
                XCTAssertEqual((cells[278] >> 4) & 7, source)
                var io = LLSPIImage(seed: 0, salt: 0, instance: 0, failures: 0, mode: mode)
                XCTAssertEqual(LL_RCC_GetCLKPClockSource(&io, LL_RCC_CLKP_CLKSOURCE), clkp << 28)
                for selector in [LL_RCC_SPI1_CLKSOURCE, LL_RCC_SPI23_CLKSOURCE, LL_RCC_SPI6_CLKSOURCE] {
                    XCTAssertEqual(LL_RCC_GetSPIClockSource(&io, selector), selector | (source << 16))
                }
            }
        }
        let frequencies: [UInt32] = [83333, 125000, 250000, 489, 488]
        let expected: [UInt32] = [0, 0x10000, 0x1000000, 0x1FF0000, 0]
        for (i, frequency) in frequencies.enumerated() {
            let io = LLSPIImage(seed: 0, salt: 0, instance: 5, failures: 0, mode: 3)
            io.cells[160] = 0
            var clocks = io
            XCTAssertEqual(LL_RCC_GetSPIClockFreq(&clocks, LL_RCC_SPI6_CLKSOURCE), 64_000_000)
            var config = LL_I2S_InitTypeDef()
            LL_I2S_StructInit(&config)
            config.AudioFreq = frequency
            config.MCLKOutput = LL_I2S_MCLK_OUTPUT_ENABLE
            XCTAssertEqual(LL_I2S_Init(io, config, clocks: &clocks), .success)
            XCTAssertEqual(io.cells[180] & 0x1FF0000, expected[i])
        }
    }
    func testPinnedConstants() {
        let constants: [UInt32] = [
            LL_SPI_SR_RXP,
            LL_SPI_SR_TXP,
            LL_SPI_SR_DXP,
            LL_SPI_SR_EOT,
            LL_SPI_SR_TXTF,
            LL_SPI_SR_UDR,
            LL_SPI_SR_CRCE,
            LL_SPI_SR_MODF,
            LL_SPI_SR_OVR,
            LL_SPI_SR_TIFRE,
            LL_SPI_SR_SUSP,
            LL_SPI_SR_TXC,
            LL_SPI_SR_RXWNE,
            LL_SPI_IER_RXPIE,
            LL_SPI_IER_TXPIE,
            LL_SPI_IER_DXPIE,
            LL_SPI_IER_EOTIE,
            LL_SPI_IER_TXTFIE,
            LL_SPI_IER_UDRIE,
            LL_SPI_IER_OVRIE,
            LL_SPI_IER_CRCEIE,
            LL_SPI_IER_TIFREIE,
            LL_SPI_IER_MODFIE,
            LL_SPI_MODE_MASTER,
            LL_SPI_MODE_SLAVE,
            LL_SPI_SS_LEVEL_HIGH,
            LL_SPI_SS_LEVEL_LOW,
            LL_SPI_SS_IDLENESS_00CYCLE,
            LL_SPI_SS_IDLENESS_01CYCLE,
            LL_SPI_SS_IDLENESS_02CYCLE,
            LL_SPI_SS_IDLENESS_03CYCLE,
            LL_SPI_SS_IDLENESS_04CYCLE,
            LL_SPI_SS_IDLENESS_05CYCLE,
            LL_SPI_SS_IDLENESS_06CYCLE,
            LL_SPI_SS_IDLENESS_07CYCLE,
            LL_SPI_SS_IDLENESS_08CYCLE,
            LL_SPI_SS_IDLENESS_09CYCLE,
            LL_SPI_SS_IDLENESS_10CYCLE,
            LL_SPI_SS_IDLENESS_11CYCLE,
            LL_SPI_SS_IDLENESS_12CYCLE,
            LL_SPI_SS_IDLENESS_13CYCLE,
            LL_SPI_SS_IDLENESS_14CYCLE,
            LL_SPI_SS_IDLENESS_15CYCLE,
            LL_SPI_ID_IDLENESS_00CYCLE,
            LL_SPI_ID_IDLENESS_01CYCLE,
            LL_SPI_ID_IDLENESS_02CYCLE,
            LL_SPI_ID_IDLENESS_03CYCLE,
            LL_SPI_ID_IDLENESS_04CYCLE,
            LL_SPI_ID_IDLENESS_05CYCLE,
            LL_SPI_ID_IDLENESS_06CYCLE,
            LL_SPI_ID_IDLENESS_07CYCLE,
            LL_SPI_ID_IDLENESS_08CYCLE,
            LL_SPI_ID_IDLENESS_09CYCLE,
            LL_SPI_ID_IDLENESS_10CYCLE,
            LL_SPI_ID_IDLENESS_11CYCLE,
            LL_SPI_ID_IDLENESS_12CYCLE,
            LL_SPI_ID_IDLENESS_13CYCLE,
            LL_SPI_ID_IDLENESS_14CYCLE,
            LL_SPI_ID_IDLENESS_15CYCLE,
            LL_SPI_TXCRCINIT_ALL_ZERO_PATTERN,
            LL_SPI_TXCRCINIT_ALL_ONES_PATTERN,
            LL_SPI_RXCRCINIT_ALL_ZERO_PATTERN,
            LL_SPI_RXCRCINIT_ALL_ONES_PATTERN,
            LL_SPI_UDR_CONFIG_REGISTER_PATTERN,
            LL_SPI_UDR_CONFIG_LAST_RECEIVED,
            LL_SPI_PROTOCOL_MOTOROLA,
            LL_SPI_PROTOCOL_TI,
            LL_SPI_PHASE_1EDGE,
            LL_SPI_PHASE_2EDGE,
            LL_SPI_POLARITY_LOW,
            LL_SPI_POLARITY_HIGH,
            LL_SPI_NSS_POLARITY_LOW,
            LL_SPI_NSS_POLARITY_HIGH,
            LL_SPI_BAUDRATEPRESCALER_BYPASS,
            LL_SPI_BAUDRATEPRESCALER_DIV2,
            LL_SPI_BAUDRATEPRESCALER_DIV4,
            LL_SPI_BAUDRATEPRESCALER_DIV8,
            LL_SPI_BAUDRATEPRESCALER_DIV16,
            LL_SPI_BAUDRATEPRESCALER_DIV32,
            LL_SPI_BAUDRATEPRESCALER_DIV64,
            LL_SPI_BAUDRATEPRESCALER_DIV128,
            LL_SPI_BAUDRATEPRESCALER_DIV256,
            LL_SPI_LSB_FIRST,
            LL_SPI_MSB_FIRST,
            LL_SPI_FULL_DUPLEX,
            LL_SPI_SIMPLEX_TX,
            LL_SPI_SIMPLEX_RX,
            LL_SPI_HALF_DUPLEX_RX,
            LL_SPI_HALF_DUPLEX_TX,
            LL_SPI_DATAWIDTH_4BIT,
            LL_SPI_DATAWIDTH_5BIT,
            LL_SPI_DATAWIDTH_6BIT,
            LL_SPI_DATAWIDTH_7BIT,
            LL_SPI_DATAWIDTH_8BIT,
            LL_SPI_DATAWIDTH_9BIT,
            LL_SPI_DATAWIDTH_10BIT,
            LL_SPI_DATAWIDTH_11BIT,
            LL_SPI_DATAWIDTH_12BIT,
            LL_SPI_DATAWIDTH_13BIT,
            LL_SPI_DATAWIDTH_14BIT,
            LL_SPI_DATAWIDTH_15BIT,
            LL_SPI_DATAWIDTH_16BIT,
            LL_SPI_DATAWIDTH_17BIT,
            LL_SPI_DATAWIDTH_18BIT,
            LL_SPI_DATAWIDTH_19BIT,
            LL_SPI_DATAWIDTH_20BIT,
            LL_SPI_DATAWIDTH_21BIT,
            LL_SPI_DATAWIDTH_22BIT,
            LL_SPI_DATAWIDTH_23BIT,
            LL_SPI_DATAWIDTH_24BIT,
            LL_SPI_DATAWIDTH_25BIT,
            LL_SPI_DATAWIDTH_26BIT,
            LL_SPI_DATAWIDTH_27BIT,
            LL_SPI_DATAWIDTH_28BIT,
            LL_SPI_DATAWIDTH_29BIT,
            LL_SPI_DATAWIDTH_30BIT,
            LL_SPI_DATAWIDTH_31BIT,
            LL_SPI_DATAWIDTH_32BIT,
            LL_SPI_FIFO_TH_01DATA,
            LL_SPI_FIFO_TH_02DATA,
            LL_SPI_FIFO_TH_03DATA,
            LL_SPI_FIFO_TH_04DATA,
            LL_SPI_FIFO_TH_05DATA,
            LL_SPI_FIFO_TH_06DATA,
            LL_SPI_FIFO_TH_07DATA,
            LL_SPI_FIFO_TH_08DATA,
            LL_SPI_FIFO_TH_09DATA,
            LL_SPI_FIFO_TH_10DATA,
            LL_SPI_FIFO_TH_11DATA,
            LL_SPI_FIFO_TH_12DATA,
            LL_SPI_FIFO_TH_13DATA,
            LL_SPI_FIFO_TH_14DATA,
            LL_SPI_FIFO_TH_15DATA,
            LL_SPI_FIFO_TH_16DATA,
            LL_SPI_CRCCALCULATION_DISABLE,
            LL_SPI_CRCCALCULATION_ENABLE,
            LL_SPI_CRC_4BIT,
            LL_SPI_CRC_5BIT,
            LL_SPI_CRC_6BIT,
            LL_SPI_CRC_7BIT,
            LL_SPI_CRC_8BIT,
            LL_SPI_CRC_9BIT,
            LL_SPI_CRC_10BIT,
            LL_SPI_CRC_11BIT,
            LL_SPI_CRC_12BIT,
            LL_SPI_CRC_13BIT,
            LL_SPI_CRC_14BIT,
            LL_SPI_CRC_15BIT,
            LL_SPI_CRC_16BIT,
            LL_SPI_CRC_17BIT,
            LL_SPI_CRC_18BIT,
            LL_SPI_CRC_19BIT,
            LL_SPI_CRC_20BIT,
            LL_SPI_CRC_21BIT,
            LL_SPI_CRC_22BIT,
            LL_SPI_CRC_23BIT,
            LL_SPI_CRC_24BIT,
            LL_SPI_CRC_25BIT,
            LL_SPI_CRC_26BIT,
            LL_SPI_CRC_27BIT,
            LL_SPI_CRC_28BIT,
            LL_SPI_CRC_29BIT,
            LL_SPI_CRC_30BIT,
            LL_SPI_CRC_31BIT,
            LL_SPI_CRC_32BIT,
            LL_SPI_NSS_SOFT,
            LL_SPI_NSS_HARD_INPUT,
            LL_SPI_NSS_HARD_OUTPUT,
            LL_SPI_RX_FIFO_0PACKET,
            LL_SPI_RX_FIFO_1PACKET,
            LL_SPI_RX_FIFO_2PACKET,
            LL_SPI_RX_FIFO_3PACKET,
            LL_I2S_DATAFORMAT_16B,
            LL_I2S_DATAFORMAT_16B_EXTENDED,
            LL_I2S_DATAFORMAT_24B,
            LL_I2S_DATAFORMAT_24B_LEFT_ALIGNED,
            LL_I2S_DATAFORMAT_32B,
            LL_I2S_SLAVE_VARIABLE_CH_LENGTH,
            LL_I2S_SLAVE_FIXED_CH_LENGTH,
            LL_I2S_POLARITY_LOW,
            LL_I2S_POLARITY_HIGH,
            LL_I2S_STANDARD_PHILIPS,
            LL_I2S_STANDARD_MSB,
            LL_I2S_STANDARD_LSB,
            LL_I2S_STANDARD_PCM_SHORT,
            LL_I2S_STANDARD_PCM_LONG,
            LL_I2S_MODE_SLAVE_TX,
            LL_I2S_MODE_SLAVE_RX,
            LL_I2S_MODE_SLAVE_FULL_DUPLEX,
            LL_I2S_MODE_MASTER_TX,
            LL_I2S_MODE_MASTER_RX,
            LL_I2S_MODE_MASTER_FULL_DUPLEX,
            LL_I2S_PRESCALER_PARITY_EVEN,
            LL_I2S_PRESCALER_PARITY_ODD,
            LL_I2S_FIFO_TH_01DATA,
            LL_I2S_FIFO_TH_02DATA,
            LL_I2S_FIFO_TH_03DATA,
            LL_I2S_FIFO_TH_04DATA,
            LL_I2S_FIFO_TH_05DATA,
            LL_I2S_FIFO_TH_06DATA,
            LL_I2S_FIFO_TH_07DATA,
            LL_I2S_FIFO_TH_08DATA,
            LL_I2S_LSB_FIRST,
            LL_I2S_MSB_FIRST,
            LL_I2S_MCLK_OUTPUT_DISABLE,
            LL_I2S_MCLK_OUTPUT_ENABLE,
            LL_I2S_AUDIOFREQ_192K,
            LL_I2S_AUDIOFREQ_96K,
            LL_I2S_AUDIOFREQ_48K,
            LL_I2S_AUDIOFREQ_44K,
            LL_I2S_AUDIOFREQ_32K,
            LL_I2S_AUDIOFREQ_22K,
            LL_I2S_AUDIOFREQ_16K,
            LL_I2S_AUDIOFREQ_11K,
            LL_I2S_AUDIOFREQ_8K,
            LL_I2S_AUDIOFREQ_DEFAULT,
        ]
        for (i, value) in constants.enumerated() { XCTAssertEqual(value, CL55_Constant(UInt32(i))) }
    }
}
