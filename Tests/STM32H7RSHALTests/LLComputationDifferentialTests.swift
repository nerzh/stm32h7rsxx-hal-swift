import CLLReference
import STM32H7RSHAL
import XCTest

private struct LLComputationAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}
private final class LLComputationImage: CRCRegisterIO, CORDICRegisterIO, RNGRegisterIO, PKARegisterIO, ICacheRegisterIO,
    LLBusRegisterIO
{
    var cells: [UInt32]
    var trace: [LLComputationAccess] = []
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
    func crcIndex(_ r: CRCRegister) -> Int {
        switch r {
        case .dr: return 0
        case .idr: return 1
        case .cr: return 2
        case .initialValue: return 4
        case .polynomial: return 5
        }
    }
    func read(_ r: CRCRegister) -> UInt32 { readIndex(crcIndex(r)) }
    func write(_ r: CRCRegister, value: UInt32) { writeIndex(crcIndex(r), value) }
    func writeData16(_ value: UInt16) {
        trace.append(.init(index: 0, value: UInt32(value), kind: 2))
        cells[0] = (cells[0] & 0xFFFF_0000) | UInt32(value)
    }
    func writeData8(_ value: UInt8) {
        trace.append(.init(index: 0, value: UInt32(value), kind: 3))
        cells[0] = (cells[0] & 0xFFFF_FF00) | UInt32(value)
    }
    func cordicIndex(_ r: CORDICRegister) -> Int {
        switch r {
        case .csr: return 16
        case .wdata: return 17
        case .rdata: return 18
        }
    }
    func read(_ r: CORDICRegister) -> UInt32 { readIndex(cordicIndex(r)) }
    func write(_ r: CORDICRegister, value: UInt32) { writeIndex(cordicIndex(r), value) }
    func address(of r: CORDICRegister) -> UInt32 { 0x4800_4400 + UInt32(cordicIndex(r) - 16) * 4 }
    func rngIndex(_ r: RNGRegister) -> Int {
        switch r {
        case .cr: return 32
        case .sr: return 33
        case .dr: return 34
        case .htcr: return 36
        }
    }
    func read(_ r: RNGRegister) -> UInt32 { readIndex(rngIndex(r)) }
    func write(_ r: RNGRegister, value: UInt32) { writeIndex(rngIndex(r), value) }
    func read(_ r: PKARegister) -> UInt32 { readIndex(48 + Int(r.rawValue / 4)) }
    func write(_ r: PKARegister, value: UInt32) { writeIndex(48 + Int(r.rawValue / 4), value) }
    func readRAM(_ i: UInt32) -> UInt32 { preconditionFailure("Unexpected PKA RAM read") }
    func writeRAM(_ i: UInt32, value: UInt32) { preconditionFailure("Unexpected PKA RAM write") }
    func readOperandWord(_ p: UnsafePointer<UInt32>) -> UInt32 { preconditionFailure("Unexpected operand read") }
    func writeResultWord(_ p: UnsafeMutablePointer<UInt32>, value: UInt32) {
        preconditionFailure("Unexpected result write")
    }
    func cacheIndex(_ r: ICacheRegister) -> Int {
        switch r {
        case .cr: return 64
        case .sr: return 65
        case .ier: return 66
        case .fcr: return 67
        case .hmonr: return 68
        case .mmonr: return 69
        }
    }
    func read(_ r: ICacheRegister) -> UInt32 { readIndex(cacheIndex(r)) }
    func write(_ r: ICacheRegister, value: UInt32) { writeIndex(cacheIndex(r), value) }
    func read(_ r: LLBusRegister) -> UInt32 { readIndex(256 + Int(r.rawValue / 4)) }
    func write(_ r: LLBusRegister, value: UInt32) { writeIndex(256 + Int(r.rawValue / 4), value) }

}
private func runLLComputation(_ op: Int, _ io: LLComputationImage, _ args: [UInt32]) -> UInt32 {
    var bus = io
    switch op {
    case 0:
        LL_CRC_ResetCRCCalculationUnit(&bus)
        return 0
    case 1:
        LL_CRC_SetPolynomialSize(&bus, args[0])
        return 0
    case 2:
        let result = LL_CRC_GetPolynomialSize(&bus)
        return result
    case 3:
        LL_CRC_SetInputDataReverseMode(&bus, args[0])
        return 0
    case 4:
        let result = LL_CRC_GetInputDataReverseMode(&bus)
        return result
    case 5:
        LL_CRC_SetOutputDataReverseMode(&bus, args[0])
        return 0
    case 6:
        let result = LL_CRC_GetOutputDataReverseMode(&bus)
        return result
    case 7:
        LL_CRC_SetInitialData(&bus, args[0])
        return 0
    case 8:
        let result = LL_CRC_GetInitialData(&bus)
        return result
    case 9:
        LL_CRC_SetPolynomialCoef(&bus, args[0])
        return 0
    case 10:
        let result = LL_CRC_GetPolynomialCoef(&bus)
        return result
    case 11:
        LL_CRC_FeedData32(&bus, args[0])
        return 0
    case 12:
        LL_CRC_FeedData16(&bus, UInt16(truncatingIfNeeded: args[0]))
        return 0
    case 13:
        LL_CRC_FeedData8(&bus, UInt8(truncatingIfNeeded: args[0]))
        return 0
    case 14:
        let result = LL_CRC_ReadData32(&bus)
        return result
    case 15:
        let result = UInt32(LL_CRC_ReadData16(&bus))
        return result
    case 16:
        let result = UInt32(LL_CRC_ReadData8(&bus))
        return result
    case 17:
        let result = UInt32(LL_CRC_ReadData7(&bus))
        return result
    case 18:
        let result = LL_CRC_Read_IDR(&bus)
        return result
    case 19:
        LL_CRC_Write_IDR(&bus, args[0])
        return 0
    case 20:
        let result = LL_CRC_DeInit(&bus, isKnownInstance: io.instance == 0).rawValue
        return result
    case 21:
        LL_CORDIC_Config(io, args[0], args[1], args[2], args[3], args[4], args[5], args[6])
        return 0
    case 22:
        LL_CORDIC_SetFunction(io, args[0])
        return 0
    case 23:
        let result = LL_CORDIC_GetFunction(io)
        return result
    case 24:
        LL_CORDIC_SetPrecision(io, args[0])
        return 0
    case 25:
        let result = LL_CORDIC_GetPrecision(io)
        return result
    case 26:
        LL_CORDIC_SetScale(io, args[0])
        return 0
    case 27:
        let result = LL_CORDIC_GetScale(io)
        return result
    case 28:
        LL_CORDIC_SetNbWrite(io, args[0])
        return 0
    case 29:
        let result = LL_CORDIC_GetNbWrite(io)
        return result
    case 30:
        LL_CORDIC_SetNbRead(io, args[0])
        return 0
    case 31:
        let result = LL_CORDIC_GetNbRead(io)
        return result
    case 32:
        LL_CORDIC_SetInSize(io, args[0])
        return 0
    case 33:
        let result = LL_CORDIC_GetInSize(io)
        return result
    case 34:
        LL_CORDIC_SetOutSize(io, args[0])
        return 0
    case 35:
        let result = LL_CORDIC_GetOutSize(io)
        return result
    case 36:
        LL_CORDIC_EnableIT(io)
        return 0
    case 37:
        LL_CORDIC_DisableIT(io)
        return 0
    case 38:
        let result = LL_CORDIC_IsEnabledIT(io)
        return result
    case 39:
        LL_CORDIC_EnableDMAReq_RD(io)
        return 0
    case 40:
        LL_CORDIC_DisableDMAReq_RD(io)
        return 0
    case 41:
        let result = LL_CORDIC_IsEnabledDMAReq_RD(io)
        return result
    case 42:
        LL_CORDIC_EnableDMAReq_WR(io)
        return 0
    case 43:
        LL_CORDIC_DisableDMAReq_WR(io)
        return 0
    case 44:
        let result = LL_CORDIC_IsEnabledDMAReq_WR(io)
        return result
    case 45:
        let result = LL_CORDIC_DMA_GetRegAddr(io, args[0])
        return result
    case 46:
        let result = LL_CORDIC_IsActiveFlag_RRDY(io)
        return result
    case 47:
        LL_CORDIC_WriteData(io, args[0])
        return 0
    case 48:
        let result = LL_CORDIC_ReadData(io)
        return result
    case 49:
        let result = LL_CORDIC_DeInit(&bus, isKnownInstance: io.instance == 0).rawValue
        return result
    case 50:
        LL_RNG_Enable(io)
        return 0
    case 51:
        LL_RNG_Disable(io)
        return 0
    case 52:
        let result = LL_RNG_IsEnabled(io)
        return result
    case 53:
        LL_RNG_EnableClkErrorDetect(io)
        return 0
    case 54:
        LL_RNG_DisableClkErrorDetect(io)
        return 0
    case 55:
        let result = LL_RNG_IsEnabledClkErrorDetect(io)
        return result
    case 56:
        LL_RNG_EnableCondReset(io)
        return 0
    case 57:
        LL_RNG_DisableCondReset(io)
        return 0
    case 58:
        let result = LL_RNG_IsEnabledCondReset(io)
        return result
    case 59:
        LL_RNG_ConfigLock(io)
        return 0
    case 60:
        let result = LL_RNG_IsConfigLocked(io)
        return result
    case 61:
        LL_RNG_EnableNistCompliance(io)
        return 0
    case 62:
        LL_RNG_DisableNistCompliance(io)
        return 0
    case 63:
        let result = LL_RNG_IsEnabledNistCompliance(io)
        return result
    case 64:
        LL_RNG_SetConfig1(io, args[0])
        return 0
    case 65:
        let result = LL_RNG_GetConfig1(io)
        return result
    case 66:
        LL_RNG_SetConfig2(io, args[0])
        return 0
    case 67:
        let result = LL_RNG_GetConfig2(io)
        return result
    case 68:
        LL_RNG_SetConfig3(io, args[0])
        return 0
    case 69:
        let result = LL_RNG_GetConfig3(io)
        return result
    case 70:
        LL_RNG_SetClockDivider(io, args[0])
        return 0
    case 71:
        let result = LL_RNG_GetClockDivider(io)
        return result
    case 72:
        let result = LL_RNG_IsActiveFlag_DRDY(io)
        return result
    case 73:
        let result = LL_RNG_IsActiveFlag_CECS(io)
        return result
    case 74:
        let result = LL_RNG_IsActiveFlag_SECS(io)
        return result
    case 75:
        let result = LL_RNG_IsActiveFlag_CEIS(io)
        return result
    case 76:
        let result = LL_RNG_IsActiveFlag_SEIS(io)
        return result
    case 77:
        LL_RNG_ClearFlag_CEIS(io)
        return 0
    case 78:
        LL_RNG_ClearFlag_SEIS(io)
        return 0
    case 79:
        LL_RNG_EnableIT(io)
        return 0
    case 80:
        LL_RNG_DisableIT(io)
        return 0
    case 81:
        let result = LL_RNG_IsEnabledIT(io)
        return result
    case 82:
        let result = LL_RNG_ReadRandData32(io)
        return result
    case 83:
        LL_RNG_EnableArdis(io)
        return 0
    case 84:
        LL_RNG_DisableArdis(io)
        return 0
    case 85:
        let result = LL_RNG_IsEnabledArdis(io)
        return result
    case 86:
        LL_RNG_SetHealthConfig(io, args[0])
        return 0
    case 87:
        let result = LL_RNG_GetHealthConfig(io)
        return result
    case 88:
        let result = LL_RNG_DeInit(&bus, isKnownInstance: io.instance == 0).rawValue
        return result
    case 89:
        var v1 = LL_RNG_InitTypeDef()
        v1.ClockErrorDetection = args[0]
        let result = LL_RNG_Init(io, v1).rawValue
        io.cells[384] = UInt32(v1.ClockErrorDetection)
        return result
    case 90:
        var v0 = LL_RNG_InitTypeDef()
        v0.ClockErrorDetection = args[0]
        LL_RNG_StructInit(&v0)
        io.cells[384] = UInt32(v0.ClockErrorDetection)
        return 0
    case 91:
        LL_PKA_Config(io, args[0])
        return 0
    case 92:
        LL_PKA_Enable(io)
        return 0
    case 93:
        LL_PKA_Disable(io)
        return 0
    case 94:
        let result = LL_PKA_IsEnabled(io)
        return result
    case 95:
        LL_PKA_SetMode(io, args[0])
        return 0
    case 96:
        let result = LL_PKA_GetMode(io)
        return result
    case 97:
        LL_PKA_Start(io)
        return 0
    case 98:
        LL_PKA_EnableIT_ADDRERR(io)
        return 0
    case 99:
        LL_PKA_EnableIT_RAMERR(io)
        return 0
    case 100:
        LL_PKA_EnableIT_OPERR(io)
        return 0
    case 101:
        LL_PKA_EnableIT_PROCEND(io)
        return 0
    case 102:
        LL_PKA_DisableIT_ADDERR(io)
        return 0
    case 103:
        LL_PKA_DisableIT_RAMERR(io)
        return 0
    case 104:
        LL_PKA_DisableIT_PROCEND(io)
        return 0
    case 105:
        LL_PKA_DisableIT_OPERR(io)
        return 0
    case 106:
        let result = LL_PKA_IsEnabledIT_ADDRERR(io)
        return result
    case 107:
        let result = LL_PKA_IsEnabledIT_RAMERR(io)
        return result
    case 108:
        let result = LL_PKA_IsEnabledIT_OPERR(io)
        return result
    case 109:
        let result = LL_PKA_IsEnabledIT_PROCEND(io)
        return result
    case 110:
        let result = LL_PKA_IsActiveFlag_ADDRERR(io)
        return result
    case 111:
        let result = LL_PKA_IsActiveFlag_RAMERR(io)
        return result
    case 112:
        let result = LL_PKA_IsActiveFlag_OPERR(io)
        return result
    case 113:
        let result = LL_PKA_IsActiveFlag_PROCEND(io)
        return result
    case 114:
        let result = LL_PKA_IsActiveFlag_BUSY(io)
        return result
    case 115:
        let result = LL_PKA_IsActiveFlag_INITOK(io)
        return result
    case 116:
        LL_PKA_ClearFlag_ADDERR(io)
        return 0
    case 117:
        LL_PKA_ClearFlag_RAMERR(io)
        return 0
    case 118:
        LL_PKA_ClearFlag_OPERR(io)
        return 0
    case 119:
        LL_PKA_ClearFlag_PROCEND(io)
        return 0
    case 120:
        let result = LL_PKA_DeInit(&bus, isKnownInstance: io.instance == 0).rawValue
        return result
    case 121:
        var v1 = LL_PKA_InitTypeDef()
        v1.Mode = args[0]
        let result = LL_PKA_Init(io, &v1).rawValue
        io.cells[384] = UInt32(v1.Mode)
        return result
    case 122:
        var v0 = LL_PKA_InitTypeDef()
        v0.Mode = args[0]
        LL_PKA_StructInit(&v0)
        io.cells[384] = UInt32(v0.Mode)
        return 0
    case 123:
        LL_ICACHE_Enable(io)
        return 0
    case 124:
        LL_ICACHE_Disable(io)
        return 0
    case 125:
        let result = LL_ICACHE_IsEnabled(io)
        return result
    case 126:
        LL_ICACHE_SetMode(io, args[0])
        return 0
    case 127:
        let result = LL_ICACHE_GetMode(io)
        return result
    case 128:
        LL_ICACHE_Invalidate(io)
        return 0
    case 129:
        LL_ICACHE_EnableMonitors(io, args[0])
        return 0
    case 130:
        LL_ICACHE_DisableMonitors(io, args[0])
        return 0
    case 131:
        let result = LL_ICACHE_IsEnabledMonitors(io, args[0])
        return result
    case 132:
        LL_ICACHE_ResetMonitors(io, args[0])
        return 0
    case 133:
        let result = LL_ICACHE_GetHitMonitor(io)
        return result
    case 134:
        let result = LL_ICACHE_GetMissMonitor(io)
        return result
    case 135:
        LL_ICACHE_EnableIT_BSYEND(io)
        return 0
    case 136:
        LL_ICACHE_DisableIT_BSYEND(io)
        return 0
    case 137:
        let result = LL_ICACHE_IsEnabledIT_BSYEND(io)
        return result
    case 138:
        LL_ICACHE_EnableIT_ERR(io)
        return 0
    case 139:
        LL_ICACHE_DisableIT_ERR(io)
        return 0
    case 140:
        let result = LL_ICACHE_IsEnabledIT_ERR(io)
        return result
    case 141:
        let result = LL_ICACHE_IsActiveFlag_BUSY(io)
        return result
    case 142:
        let result = LL_ICACHE_IsActiveFlag_BSYEND(io)
        return result
    case 143:
        let result = LL_ICACHE_IsActiveFlag_ERR(io)
        return result
    case 144:
        LL_ICACHE_ClearFlag_BSYEND(io)
        return 0
    case 145:
        LL_ICACHE_ClearFlag_ERR(io)
        return 0
    case 146:
        LL_CRC_WriteReg(&bus, CRCRegister.cr, args[0])
        return LL_CRC_ReadReg(&bus, CRCRegister.cr)
    case 147:
        LL_CORDIC_WriteReg(io, CORDICRegister.csr, args[0])
        return LL_CORDIC_ReadReg(io, CORDICRegister.csr)
    case 148:
        LL_RNG_WriteReg(io, RNGRegister.cr, args[0])
        return LL_RNG_ReadReg(io, RNGRegister.cr)
    case 149:
        LL_PKA_WriteReg(io, PKARegister.cr, args[0])
        return LL_PKA_ReadReg(io, PKARegister.cr)
    case 150:
        LL_ICACHE_WriteReg(io, ICacheRegister.cr, args[0])
        return LL_ICACHE_ReadReg(io, ICacheRegister.cr)
    default: preconditionFailure("Unknown operation")
    }
}
final class LLComputationDifferentialTests: XCTestCase {
    @discardableResult private func compare(
        _ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0, instance: UInt32 = 0,
        file: StaticString = #filePath, line: UInt = #line
    ) -> LLComputationImage {
        let c = CL58_Create()!
        defer { CL58_Destroy(c) }
        CL58_Reset(c, seed, salt, instance)
        let io = LLComputationImage(seed, salt, instance)
        let sr = runLLComputation(op, io, args)
        let cr = CL58_Run(c, UInt32(op), args)
        let context = "op=\(op) seed=\(seed) salt=\(salt) instance=\(instance) args=\(args)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL58_GetCells(c), count: 512)
        for i in cells.indices where cells[i] != io.cells[i] {
            XCTFail("\(context) cell \(i): Swift \(io.cells[i]), C \(cells[i])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL58_GetTrace(c), count: Int(CL58_GetTraceCount(c)))
        XCTAssertEqual(
            io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file,
            line: line)
        return io
    }
    func testEveryFunctionWithChangingReadsAndAllInstances() {
        for op in 0..<146 {
            for instance: UInt32 in 0..<2 {
                for sample: UInt32 in 0..<32 {
                    let seed = sample &* 0x9E37_79B9
                    var args = (0..<16).map { seed ^ (UInt32($0) &* 0x1020_4081) }
                    compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x1020_4081, instance: instance)
                }
            }
        }
    }
    func testCRCTransactionWidthsAndNarrowResults() {
        for op in [11, 12, 13, 14, 15, 16, 17, 19] {
            for value: UInt32 in [0, 1, 127, 128, 255, 256, 32767, 32768, 65535, 65536, 0x89AB_CDEF, .max] {
                for salt: UInt32 in [0, 0x1020_4081] { compare(op, [value], seed: ~value, salt: salt) }
            }
        }
    }
    func testCORDICConfigurationCombinations() {
        for function: UInt32 in 0..<10 {
            for precision: UInt32 in [1, 6, 15] {
                for scale: UInt32 in 0..<8 {
                    for nwrite: UInt32 in 0..<2 {
                        for nread: UInt32 in 0..<2 {
                            for insize: UInt32 in 0..<2 {
                                for outsize: UInt32 in 0..<2 {
                                    compare(
                                        21,
                                        [
                                            function, precision << 4, scale << 8, nwrite << 20, nread << 19,
                                            insize << 22, outsize << 21,
                                        ], seed: 0xA5A5_A5A5, salt: 0x1020_4081)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func testRNGConditionerConfigurationAndClockDetection() {
        for op in [53, 54, 61, 62, 64, 66, 68, 70, 86, 89] {
            for value: UInt32 in [0, 1, 7, 15, 63, 0x20, 0x4000_0000, .max] {
                for seed: UInt32 in [0, .max] {
                    for salt: UInt32 in [0, 0x1020_4081] { compare(op, [value], seed: seed, salt: salt) }
                }
            }
        }
    }
    func testPKAConfigAndInitializationModes() {
        for op in [91, 95, 121] {
            for v: UInt32 in 0..<68 {
                let mode: UInt32 = v < 64 ? v : (v == 64 ? 255 : (v == 65 ? 256 : (v == 66 ? 0x1234_5678 : .max)))
                for salt: UInt32 in [0, 0x1020_4081] { compare(op, [mode], seed: 0x8000_0003, salt: salt) }
            }
        }
    }
    func testICacheMonitorMasksAndClearSequences() {
        for op in 129...132 {
            for mask: UInt32 in [
                0, 1, 2, 3, 0x10000, 0x20000, 0x30000, 0xC0000, 0x4000_0000, 0x8000_0000, 0xA5A5_A5A5, .max,
            ] {
                for seed: UInt32 in [0, 1, .max] {
                    for salt: UInt32 in [0, 0x1020_4081] { compare(op, [mask], seed: seed, salt: salt) }
                }
            }
        }
    }
    func testUnknownInstancesAndRawMacros() {
        for op in [20, 49, 88, 120] {
            for instance: UInt32 in 0..<2 {
                for seed: UInt32 in [0, 1, 0xA5A5_A5A5, 0x8000_0000, .max] {
                    compare(op, [], seed: seed, salt: 0x1020_4081, instance: instance)
                }
            }
        }
        for op in 146..<151 {
            for sample: UInt32 in 0..<32 { compare(op, [sample &* 0x9E37_79B9], seed: ~sample, salt: 0x1020_4081) }
        }
    }
    func testIndependentAccessWidthsMasksAndResetOrdering() {
        var io = LLComputationImage(0, 0, 0)
        io.cells[0] = 0xDEAD_BEEF
        LL_CRC_FeedData8(&io, 0x12)
        LL_CRC_FeedData16(&io, 0x3456)
        XCTAssertEqual(io.cells[0], 0xDEAD_3456)
        XCTAssertEqual(io.trace, [.init(index: 0, value: 0x12, kind: 3), .init(index: 0, value: 0x3456, kind: 2)])
        io.trace.removeAll()
        io.cells[0] = 0xFEDC_BA98
        XCTAssertEqual(LL_CRC_ReadData16(&io), 0xBA98)
        XCTAssertEqual(LL_CRC_ReadData8(&io), 0x98)
        XCTAssertEqual(LL_CRC_ReadData7(&io), 0x18)
        XCTAssertEqual(io.trace, Array(repeating: .init(index: 0, value: 0xFEDC_BA98, kind: 0), count: 3))
        io.trace.removeAll()
        io.cells[32] = 0xA5A5_A5A5
        LL_RNG_EnableClkErrorDetect(io)
        XCTAssertEqual(
            io.trace,
            [
                .init(index: 32, value: 0xA5A5_A5A5, kind: 0), .init(index: 32, value: 0xE5A5_A585, kind: 1),
                .init(index: 32, value: 0xE5A5_A585, kind: 0), .init(index: 32, value: 0xA5A5_A585, kind: 1),
            ])
        io.trace.removeAll()
        LL_RNG_ClearFlag_CEIS(io)
        LL_RNG_ClearFlag_SEIS(io)
        XCTAssertEqual(
            io.trace, [.init(index: 33, value: 0xFFFF_FFDF, kind: 1), .init(index: 33, value: 0xFFFF_FFBF, kind: 1)])
        io.trace.removeAll()
        io.cells[64] = 0
        LL_ICACHE_ResetMonitors(io, LL_ICACHE_MONITOR_ALL)
        XCTAssertEqual(
            io.trace,
            [
                .init(index: 64, value: 0, kind: 0), .init(index: 64, value: 0xC0000, kind: 1),
                .init(index: 64, value: 0xC0000, kind: 0), .init(index: 64, value: 0, kind: 1),
            ])
        io.trace.removeAll()
        io.cells[68] = 0x1234_5678
        io.cells[69] = 0xFEDC_BA98
        XCTAssertEqual(LL_ICACHE_GetHitMonitor(io), 0x1234_5678)
        XCTAssertEqual(LL_ICACHE_GetMissMonitor(io), 0xFEDC_BA98)
        XCTAssertEqual(
            io.trace, [.init(index: 68, value: 0x1234_5678, kind: 0), .init(index: 69, value: 0xFEDC_BA98, kind: 0)])
        XCTAssertEqual(LL_CORDIC_DMA_GetRegAddr(io, LL_CORDIC_DMA_REG_DATA_OUT), 0x4800_4408)
        XCTAssertEqual(LL_CORDIC_DMA_GetRegAddr(io, LL_CORDIC_DMA_REG_DATA_IN), 0x4800_4404)
        XCTAssertEqual(LL_CORDIC_DMA_GetRegAddr(io, .max), 0x4800_4404)
        io.trace.removeAll()
        XCTAssertEqual(LL_CRC_DeInit(&io, isKnownInstance: false), .error)
        XCTAssertEqual(LL_CORDIC_DeInit(&io, isKnownInstance: false), .error)
        XCTAssertEqual(LL_RNG_DeInit(&io, isKnownInstance: false), .error)
        XCTAssertEqual(LL_PKA_DeInit(&io, isKnownInstance: false), .error)
        XCTAssertTrue(io.trace.isEmpty)
        var r = LL_RNG_InitTypeDef()
        LL_RNG_StructInit(&r)
        XCTAssertEqual(r.ClockErrorDetection, 0)
        var p = LL_PKA_InitTypeDef()
        LL_PKA_StructInit(&p)
        XCTAssertEqual(p.Mode, LL_PKA_MODE_MODULAR_EXP)
    }
    func testPinnedConstants() {
        let constants: [UInt32] = [
            LL_CRC_POLYLENGTH_32B,
            LL_CRC_POLYLENGTH_16B,
            LL_CRC_POLYLENGTH_8B,
            LL_CRC_POLYLENGTH_7B,
            LL_CRC_INDATA_REVERSE_NONE,
            LL_CRC_INDATA_REVERSE_BYTE,
            LL_CRC_INDATA_REVERSE_HALFWORD,
            LL_CRC_INDATA_REVERSE_WORD,
            LL_CRC_OUTDATA_REVERSE_NONE,
            LL_CRC_OUTDATA_REVERSE_BIT,
            LL_CRC_DEFAULT_CRC32_POLY,
            LL_CRC_DEFAULT_CRC_INITVALUE,
            LL_CORDIC_FLAG_RRDY,
            LL_CORDIC_IT_IEN,
            LL_CORDIC_FUNCTION_COSINE,
            LL_CORDIC_FUNCTION_SINE,
            LL_CORDIC_FUNCTION_PHASE,
            LL_CORDIC_FUNCTION_MODULUS,
            LL_CORDIC_FUNCTION_ARCTANGENT,
            LL_CORDIC_FUNCTION_HCOSINE,
            LL_CORDIC_FUNCTION_HSINE,
            LL_CORDIC_FUNCTION_HARCTANGENT,
            LL_CORDIC_FUNCTION_NATURALLOG,
            LL_CORDIC_FUNCTION_SQUAREROOT,
            LL_CORDIC_PRECISION_1CYCLE,
            LL_CORDIC_PRECISION_2CYCLES,
            LL_CORDIC_PRECISION_3CYCLES,
            LL_CORDIC_PRECISION_4CYCLES,
            LL_CORDIC_PRECISION_5CYCLES,
            LL_CORDIC_PRECISION_6CYCLES,
            LL_CORDIC_PRECISION_7CYCLES,
            LL_CORDIC_PRECISION_8CYCLES,
            LL_CORDIC_PRECISION_9CYCLES,
            LL_CORDIC_PRECISION_10CYCLES,
            LL_CORDIC_PRECISION_11CYCLES,
            LL_CORDIC_PRECISION_12CYCLES,
            LL_CORDIC_PRECISION_13CYCLES,
            LL_CORDIC_PRECISION_14CYCLES,
            LL_CORDIC_PRECISION_15CYCLES,
            LL_CORDIC_SCALE_0,
            LL_CORDIC_SCALE_1,
            LL_CORDIC_SCALE_2,
            LL_CORDIC_SCALE_3,
            LL_CORDIC_SCALE_4,
            LL_CORDIC_SCALE_5,
            LL_CORDIC_SCALE_6,
            LL_CORDIC_SCALE_7,
            LL_CORDIC_NBWRITE_1,
            LL_CORDIC_NBWRITE_2,
            LL_CORDIC_NBREAD_1,
            LL_CORDIC_NBREAD_2,
            LL_CORDIC_INSIZE_32BITS,
            LL_CORDIC_INSIZE_16BITS,
            LL_CORDIC_OUTSIZE_32BITS,
            LL_CORDIC_OUTSIZE_16BITS,
            LL_CORDIC_DMA_REG_DATA_IN,
            LL_CORDIC_DMA_REG_DATA_OUT,
            LL_RNG_CED_ENABLE,
            LL_RNG_CED_DISABLE,
            LL_RNG_ARDIS_ENABLE,
            LL_RNG_ARDIS_DISABLE,
            LL_RNG_CLKDIV_BY_1,
            LL_RNG_CLKDIV_BY_2,
            LL_RNG_CLKDIV_BY_4,
            LL_RNG_CLKDIV_BY_8,
            LL_RNG_CLKDIV_BY_16,
            LL_RNG_CLKDIV_BY_32,
            LL_RNG_CLKDIV_BY_64,
            LL_RNG_CLKDIV_BY_128,
            LL_RNG_CLKDIV_BY_256,
            LL_RNG_CLKDIV_BY_512,
            LL_RNG_CLKDIV_BY_1024,
            LL_RNG_CLKDIV_BY_2048,
            LL_RNG_CLKDIV_BY_4096,
            LL_RNG_CLKDIV_BY_8192,
            LL_RNG_CLKDIV_BY_16384,
            LL_RNG_CLKDIV_BY_32768,
            LL_RNG_NIST_COMPLIANT,
            LL_RNG_CUSTOM_NIST,
            LL_RNG_SR_DRDY,
            LL_RNG_SR_CECS,
            LL_RNG_SR_SECS,
            LL_RNG_SR_CEIS,
            LL_RNG_SR_SEIS,
            LL_RNG_CR_IE,
            LL_PKA_SR_ADDRERRF,
            LL_PKA_SR_RAMERRF,
            LL_PKA_SR_PROCENDF,
            LL_PKA_SR_BUSY,
            LL_PKA_SR_INITOK,
            LL_PKA_SR_OPERRF,
            LL_PKA_CR_ADDRERRIE,
            LL_PKA_CR_RAMERRIE,
            LL_PKA_CR_PROCENDIE,
            LL_PKA_CLRFR_PROCENDFC,
            LL_PKA_CLRFR_RAMERRFC,
            LL_PKA_CLRFR_ADDRERRFC,
            LL_PKA_CR_OPERRIE,
            LL_PKA_CLRFR_OPERRFC,
            LL_PKA_MODE_MODULAR_EXP,
            LL_PKA_MODE_MONTGOMERY_PARAM,
            LL_PKA_MODE_MODULAR_EXP_FAST,
            LL_PKA_MODE_MODULAR_EXP_PROTECT,
            LL_PKA_MODE_ECC_MUL,
            LL_PKA_MODE_ECC_COMPLETE_ADD,
            LL_PKA_MODE_ECDSA_SIGNATURE,
            LL_PKA_MODE_ECDSA_VERIFICATION,
            LL_PKA_MODE_POINT_CHECK,
            LL_PKA_MODE_RSA_CRT_EXP,
            LL_PKA_MODE_MODULAR_INV,
            LL_PKA_MODE_ARITHMETIC_ADD,
            LL_PKA_MODE_ARITHMETIC_SUB,
            LL_PKA_MODE_ARITHMETIC_MUL,
            LL_PKA_MODE_COMPARISON,
            LL_PKA_MODE_MODULAR_REDUC,
            LL_PKA_MODE_MODULAR_ADD,
            LL_PKA_MODE_MODULAR_SUB,
            LL_PKA_MODE_MONTGOMERY_MUL,
            LL_PKA_MODE_DOUBLE_BASE_LADDER,
            LL_PKA_MODE_ECC_PROJECTIVE_AFF,
            LL_ICACHE_1WAY,
            LL_ICACHE_4WAYS,
            LL_ICACHE_MONITOR_HIT,
            LL_ICACHE_MONITOR_MISS,
            LL_ICACHE_MONITOR_ALL,
            LL_ICACHE_SR_BUSYF,
            LL_ICACHE_SR_BSYENDF,
            LL_ICACHE_SR_ERRF,
            LL_ICACHE_FCR_CBSYENDF,
            LL_ICACHE_FCR_CERRF,
            LL_ICACHE_IER_BSYENDIE,
            LL_ICACHE_IER_ERRIE,
        ]
        for (i, value) in constants.enumerated() { XCTAssertEqual(value, CL58_Constant(UInt32(i))) }
    }
}
