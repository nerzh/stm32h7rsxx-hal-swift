import CLLReference
import STM32H7RSHAL
import XCTest

private struct LLConnectionAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var kind: UInt32
}
private final class LLConnectionImage: UCPDRegisterIO, DLYBRegisterIO, LLBusRegisterIO {
    var cells: [UInt32]
    var trace: [LLConnectionAccess] = []
    var reads: UInt32 = 0
    let salt: UInt32
    let instance: UInt32
    var measure: UInt32 = 0
    var cfgrReads: UInt32 = 0
    var tickValue: UInt32 = 0
    var readyAfter: UInt32 = 0
    var targetUnit: UInt32 = 0
    var length: UInt32 = 0
    var tickStep: UInt32 = 0
    init(_ seed: UInt32, _ salt: UInt32, _ instance: UInt32) {
        cells = (0..<512).map { seed ^ (UInt32($0) &* 0x9E37_79B9) }
        self.salt = salt
        self.instance = instance
    }
    func readIndex(_ i: Int) -> UInt32 {
        var value = cells[i] ^ (salt &* reads)
        reads &+= 1
        if measure != 0 && i == (instance == 0 ? 33 : 49) {
            cfgrReads &+= 1
            value = cells[i] & 0x7F0F
            if cfgrReads >= readyAfter {
                value |= 0x8000_0000
                if ((cells[i] >> 8) & 0x7F) >= targetUnit { value |= length << 16 }
            }
        }
        trace.append(.init(index: UInt32(i), value: value, kind: 0))
        return value
    }
    func writeIndex(_ i: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(i), value: value, kind: 1))
        cells[i] = value
        if i == (instance == 0 ? 33 : 49) { cfgrReads = 0 }
    }
    func tick() -> UInt32 {
        let value = tickValue
        tickValue &+= tickStep
        trace.append(.init(index: 511, value: value, kind: 2))
        return value
    }
    func read(_ r: UCPDRegister) -> UInt32 { readIndex((instance == 0 ? 0 : 128) + Int(r.rawValue / 4)) }
    func write(_ r: UCPDRegister, value: UInt32) { writeIndex((instance == 0 ? 0 : 128) + Int(r.rawValue / 4), value) }
    func read(_ r: DLYBRegister) -> UInt32 { readIndex((instance == 0 ? 32 : 48) + Int(r.rawValue / 4)) }
    func write(_ r: DLYBRegister, value: UInt32) { writeIndex((instance == 0 ? 32 : 48) + Int(r.rawValue / 4), value) }
    func read(_ r: LLBusRegister) -> UInt32 { readIndex(256 + Int(r.rawValue / 4)) }
    func write(_ r: LLBusRegister, value: UInt32) { writeIndex(256 + Int(r.rawValue / 4), value) }
}
private func runLLConnection(_ op: Int, _ io: LLConnectionImage, _ args: [UInt32]) -> UInt32 {
    var bus = io
    if op == 134 {
        io.measure = 1
        io.readyAfter = args[2]
        io.targetUnit = args[3]
        io.length = args[4] & 0xFFF
        io.tickStep = args[5] == 0 ? 1 : args[5]
        io.tickValue = args[6]
    }
    switch op {
    case 0:
        LL_UCPD_Enable(io)
        return 0
    case 1:
        LL_UCPD_Disable(io)
        return 0
    case 2:
        let result = LL_UCPD_IsEnabled(io)
        return result
    case 3:
        LL_UCPD_SetRxOrderSet(io, args[0])
        return 0
    case 4:
        LL_UCPD_SetPSCClk(io, args[0])
        return 0
    case 5:
        LL_UCPD_SetTransWin(io, args[0])
        return 0
    case 6:
        LL_UCPD_SetIfrGap(io, args[0])
        return 0
    case 7:
        LL_UCPD_SetHbitClockDiv(io, args[0])
        return 0
    case 8:
        LL_UCPD_RxAnalogFilterEnable(io)
        return 0
    case 9:
        LL_UCPD_RxAnalogFilterDisable(io)
        return 0
    case 10:
        LL_UCPD_WakeUpEnable(io)
        return 0
    case 11:
        LL_UCPD_WakeUpDisable(io)
        return 0
    case 12:
        LL_UCPD_ForceClockEnable(io)
        return 0
    case 13:
        LL_UCPD_ForceClockDisable(io)
        return 0
    case 14:
        LL_UCPD_RxFilterEnable(io)
        return 0
    case 15:
        LL_UCPD_RxFilterDisable(io)
        return 0
    case 16:
        LL_UCPD_TypeCDetectionCC2Enable(io)
        return 0
    case 17:
        LL_UCPD_TypeCDetectionCC2Disable(io)
        return 0
    case 18:
        LL_UCPD_TypeCDetectionCC1Enable(io)
        return 0
    case 19:
        LL_UCPD_TypeCDetectionCC1Disable(io)
        return 0
    case 20:
        LL_UCPD_VconnDischargeEnable(io)
        return 0
    case 21:
        LL_UCPD_VconnDischargeDisable(io)
        return 0
    case 22:
        LL_UCPD_SignalFRSTX(io)
        return 0
    case 23:
        LL_UCPD_FRSDetectionEnable(io)
        return 0
    case 24:
        LL_UCPD_FRSDetectionDisable(io)
        return 0
    case 25:
        LL_UCPD_SetccEnable(io, args[0])
        return 0
    case 26:
        LL_UCPD_SetSNKRole(io)
        return 0
    case 27:
        LL_UCPD_SetSRCRole(io)
        return 0
    case 28:
        let result = LL_UCPD_GetRole(io)
        return result
    case 29:
        LL_UCPD_SetRpResistor(io, args[0])
        return 0
    case 30:
        LL_UCPD_SetCCPin(io, args[0])
        return 0
    case 31:
        LL_UCPD_RxEnable(io)
        return 0
    case 32:
        LL_UCPD_RxDisable(io)
        return 0
    case 33:
        LL_UCPD_SetRxMode(io, args[0])
        return 0
    case 34:
        LL_UCPD_SendHardReset(io)
        return 0
    case 35:
        LL_UCPD_SendMessage(io)
        return 0
    case 36:
        LL_UCPD_SetTxMode(io, args[0])
        return 0
    case 37:
        LL_UCPD_EnableIT_FRS(io)
        return 0
    case 38:
        LL_UCPD_EnableIT_TypeCEventCC2(io)
        return 0
    case 39:
        LL_UCPD_EnableIT_TypeCEventCC1(io)
        return 0
    case 40:
        LL_UCPD_EnableIT_RxMsgEnd(io)
        return 0
    case 41:
        LL_UCPD_EnableIT_RxOvr(io)
        return 0
    case 42:
        LL_UCPD_EnableIT_RxHRST(io)
        return 0
    case 43:
        LL_UCPD_EnableIT_RxOrderSet(io)
        return 0
    case 44:
        LL_UCPD_EnableIT_RxNE(io)
        return 0
    case 45:
        LL_UCPD_EnableIT_TxUND(io)
        return 0
    case 46:
        LL_UCPD_EnableIT_TxHRSTSENT(io)
        return 0
    case 47:
        LL_UCPD_EnableIT_TxHRSTDISC(io)
        return 0
    case 48:
        LL_UCPD_EnableIT_TxMSGABT(io)
        return 0
    case 49:
        LL_UCPD_EnableIT_TxMSGSENT(io)
        return 0
    case 50:
        LL_UCPD_EnableIT_TxMSGDISC(io)
        return 0
    case 51:
        LL_UCPD_EnableIT_TxIS(io)
        return 0
    case 52:
        LL_UCPD_DisableIT_FRS(io)
        return 0
    case 53:
        LL_UCPD_DisableIT_TypeCEventCC2(io)
        return 0
    case 54:
        LL_UCPD_DisableIT_TypeCEventCC1(io)
        return 0
    case 55:
        LL_UCPD_DisableIT_RxMsgEnd(io)
        return 0
    case 56:
        LL_UCPD_DisableIT_RxOvr(io)
        return 0
    case 57:
        LL_UCPD_DisableIT_RxHRST(io)
        return 0
    case 58:
        LL_UCPD_DisableIT_RxOrderSet(io)
        return 0
    case 59:
        LL_UCPD_DisableIT_RxNE(io)
        return 0
    case 60:
        LL_UCPD_DisableIT_TxUND(io)
        return 0
    case 61:
        LL_UCPD_DisableIT_TxHRSTSENT(io)
        return 0
    case 62:
        LL_UCPD_DisableIT_TxHRSTDISC(io)
        return 0
    case 63:
        LL_UCPD_DisableIT_TxMSGABT(io)
        return 0
    case 64:
        LL_UCPD_DisableIT_TxMSGSENT(io)
        return 0
    case 65:
        LL_UCPD_DisableIT_TxMSGDISC(io)
        return 0
    case 66:
        LL_UCPD_DisableIT_TxIS(io)
        return 0
    case 67:
        let result = LL_UCPD_IsEnableIT_FRS(io)
        return result
    case 68:
        let result = LL_UCPD_IsEnableIT_TypeCEventCC2(io)
        return result
    case 69:
        let result = LL_UCPD_IsEnableIT_TypeCEventCC1(io)
        return result
    case 70:
        let result = LL_UCPD_IsEnableIT_RxMsgEnd(io)
        return result
    case 71:
        let result = LL_UCPD_IsEnableIT_RxOvr(io)
        return result
    case 72:
        let result = LL_UCPD_IsEnableIT_RxHRST(io)
        return result
    case 73:
        let result = LL_UCPD_IsEnableIT_RxOrderSet(io)
        return result
    case 74:
        let result = LL_UCPD_IsEnableIT_RxNE(io)
        return result
    case 75:
        let result = LL_UCPD_IsEnableIT_TxUND(io)
        return result
    case 76:
        let result = LL_UCPD_IsEnableIT_TxHRSTSENT(io)
        return result
    case 77:
        let result = LL_UCPD_IsEnableIT_TxHRSTDISC(io)
        return result
    case 78:
        let result = LL_UCPD_IsEnableIT_TxMSGABT(io)
        return result
    case 79:
        let result = LL_UCPD_IsEnableIT_TxMSGSENT(io)
        return result
    case 80:
        let result = LL_UCPD_IsEnableIT_TxMSGDISC(io)
        return result
    case 81:
        let result = LL_UCPD_IsEnableIT_TxIS(io)
        return result
    case 82:
        LL_UCPD_ClearFlag_FRS(io)
        return 0
    case 83:
        LL_UCPD_ClearFlag_TypeCEventCC2(io)
        return 0
    case 84:
        LL_UCPD_ClearFlag_TypeCEventCC1(io)
        return 0
    case 85:
        LL_UCPD_ClearFlag_RxMsgEnd(io)
        return 0
    case 86:
        LL_UCPD_ClearFlag_RxOvr(io)
        return 0
    case 87:
        LL_UCPD_ClearFlag_RxHRST(io)
        return 0
    case 88:
        LL_UCPD_ClearFlag_RxOrderSet(io)
        return 0
    case 89:
        LL_UCPD_ClearFlag_TxUND(io)
        return 0
    case 90:
        LL_UCPD_ClearFlag_TxHRSTSENT(io)
        return 0
    case 91:
        LL_UCPD_ClearFlag_TxHRSTDISC(io)
        return 0
    case 92:
        LL_UCPD_ClearFlag_TxMSGABT(io)
        return 0
    case 93:
        LL_UCPD_ClearFlag_TxMSGSENT(io)
        return 0
    case 94:
        LL_UCPD_ClearFlag_TxMSGDISC(io)
        return 0
    case 95:
        let result = LL_UCPD_IsActiveFlag_FRS(io)
        return result
    case 96:
        let result = LL_UCPD_IsActiveFlag_TypeCEventCC2(io)
        return result
    case 97:
        let result = LL_UCPD_IsActiveFlag_TypeCEventCC1(io)
        return result
    case 98:
        let result = LL_UCPD_IsActiveFlag_RxErr(io)
        return result
    case 99:
        let result = LL_UCPD_IsActiveFlag_RxMsgEnd(io)
        return result
    case 100:
        let result = LL_UCPD_IsActiveFlag_RxOvr(io)
        return result
    case 101:
        let result = LL_UCPD_IsActiveFlag_RxHRST(io)
        return result
    case 102:
        let result = LL_UCPD_IsActiveFlag_RxOrderSet(io)
        return result
    case 103:
        let result = LL_UCPD_IsActiveFlag_RxNE(io)
        return result
    case 104:
        let result = LL_UCPD_IsActiveFlag_TxUND(io)
        return result
    case 105:
        let result = LL_UCPD_IsActiveFlag_TxHRSTSENT(io)
        return result
    case 106:
        let result = LL_UCPD_IsActiveFlag_TxHRSTDISC(io)
        return result
    case 107:
        let result = LL_UCPD_IsActiveFlag_TxMSGABT(io)
        return result
    case 108:
        let result = LL_UCPD_IsActiveFlag_TxMSGSENT(io)
        return result
    case 109:
        let result = LL_UCPD_IsActiveFlag_TxMSGDISC(io)
        return result
    case 110:
        let result = LL_UCPD_IsActiveFlag_TxIS(io)
        return result
    case 111:
        let result = LL_UCPD_GetTypeCVstateCC2(io)
        return result
    case 112:
        let result = LL_UCPD_GetTypeCVstateCC1(io)
        return result
    case 113:
        LL_UCPD_RxDMAEnable(io)
        return 0
    case 114:
        LL_UCPD_RxDMADisable(io)
        return 0
    case 115:
        LL_UCPD_TxDMAEnable(io)
        return 0
    case 116:
        LL_UCPD_TxDMADisable(io)
        return 0
    case 117:
        let result = LL_UCPD_IsEnabledTxDMA(io)
        return result
    case 118:
        let result = LL_UCPD_IsEnabledRxDMA(io)
        return result
    case 119:
        LL_UCPD_WriteTxOrderSet(io, args[0])
        return 0
    case 120:
        LL_UCPD_WriteTxPaySize(io, args[0])
        return 0
    case 121:
        LL_UCPD_WriteData(io, UInt8(truncatingIfNeeded: args[0]))
        return 0
    case 122:
        let result = LL_UCPD_ReadRxOrderSet(io)
        return result
    case 123:
        let result = LL_UCPD_ReadRxPaySize(io)
        return result
    case 124:
        let result = LL_UCPD_ReadData(io)
        return result
    case 125:
        LL_UCPD_SetRxOrdExt1(io, args[0])
        return 0
    case 126:
        LL_UCPD_SetRxOrdExt2(io, args[0])
        return 0
    case 127:
        let result = LL_UCPD_DeInit(&bus, isKnownInstance: io.instance == 0).rawValue
        return result
    case 128:
        var v1 = LL_UCPD_InitTypeDef()
        v1.psc_ucpdclk = args[0]
        v1.transwin = args[1]
        v1.IfrGap = args[2]
        v1.HbitClockDiv = args[3]
        let result = LL_UCPD_Init(&bus, &v1, isKnownInstance: io.instance == 0).rawValue
        io.cells[384] = UInt32(v1.psc_ucpdclk)
        io.cells[385] = UInt32(v1.transwin)
        io.cells[386] = UInt32(v1.IfrGap)
        io.cells[387] = UInt32(v1.HbitClockDiv)
        return result
    case 129:
        var v0 = LL_UCPD_InitTypeDef()
        v0.psc_ucpdclk = args[0]
        v0.transwin = args[1]
        v0.IfrGap = args[2]
        v0.HbitClockDiv = args[3]
        LL_UCPD_StructInit(&v0)
        io.cells[384] = UInt32(v0.psc_ucpdclk)
        io.cells[385] = UInt32(v0.transwin)
        io.cells[386] = UInt32(v0.IfrGap)
        io.cells[387] = UInt32(v0.HbitClockDiv)
        return 0
    case 130:
        LL_DLYB_Enable(io)
        return 0
    case 131:
        LL_DLYB_Disable(io)
        return 0
    case 132:
        var v1 = LL_DLYB_CfgTypeDef()
        v1.Units = args[0]
        v1.PhaseSel = args[1]
        LL_DLYB_SetDelay(io, &v1)
        io.cells[384] = UInt32(v1.Units)
        io.cells[385] = UInt32(v1.PhaseSel)
        return 0
    case 133:
        var v1 = LL_DLYB_CfgTypeDef()
        v1.Units = args[0]
        v1.PhaseSel = args[1]
        LL_DLYB_GetDelay(io, &v1)
        io.cells[384] = UInt32(v1.Units)
        io.cells[385] = UInt32(v1.PhaseSel)
        return 0
    case 134:
        var v1 = LL_DLYB_CfgTypeDef()
        v1.Units = args[0]
        v1.PhaseSel = args[1]
        let result = LL_DLYB_GetClockPeriod(io, &v1, getTick: io.tick)
        io.cells[384] = UInt32(v1.Units)
        io.cells[385] = UInt32(v1.PhaseSel)
        return result
    case 135:
        LL_UCPD_WriteReg(io, .cfg1, args[0])
        return LL_UCPD_ReadReg(io, .cfg1)
    default: preconditionFailure("Unknown operation")
    }
}
final class LLConnectionDifferentialTests: XCTestCase {
    @discardableResult private func compare(
        _ op: Int, _ args: [UInt32], seed: UInt32 = 0, salt: UInt32 = 0, instance: UInt32 = 0,
        file: StaticString = #filePath, line: UInt = #line
    ) -> LLConnectionImage {
        let c = CL59_Create()!
        defer { CL59_Destroy(c) }
        CL59_Reset(c, seed, salt, instance)
        let io = LLConnectionImage(seed, salt, instance)
        let sr = runLLConnection(op, io, args)
        let cr = CL59_Run(c, UInt32(op), args)
        let context = "op=\(op) seed=\(seed) salt=\(salt) instance=\(instance) args=\(args)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        let cells = UnsafeBufferPointer(start: CL59_GetCells(c), count: 512)
        for i in cells.indices where cells[i] != io.cells[i] {
            XCTFail("\(context) cell \(i): Swift \(io.cells[i]), C \(cells[i])", file: file, line: line)
        }
        let trace = UnsafeBufferPointer(start: CL59_GetTrace(c), count: Int(CL59_GetTraceCount(c)))
        XCTAssertEqual(
            io.trace, trace.map { .init(index: $0.index, value: $0.value, kind: $0.kind) }, context, file: file,
            line: line)
        return io
    }
    func testEveryFunctionAndInstanceWithChangingReads() {
        for op in 0..<135 {
            for instance: UInt32 in 0..<2 {
                for sample: UInt32 in 0..<32 {
                    let seed = sample &* 0x9E37_79B9
                    var args = (0..<16).map { seed ^ (UInt32($0) &* 0x1020_4081) }
                    if op == 134 {
                        args[2] = sample % 4
                        args[3] = sample % 128
                        args[4] = 1 << (sample % 12)
                        args[5] = 255
                    }
                    compare(op, args, seed: seed, salt: sample % 2 == 0 ? 0 : 0x1020_4081, instance: instance)
                }
            }
        }
    }
    func testUCPDInitializationAndResetPartialEffects() {
        for op in [127, 128] {
            for instance: UInt32 in 0..<2 {
                for sample: UInt32 in 0..<64 {
                    for salt: UInt32 in [0, 0x1020_4081] {
                        compare(
                            op, [(sample % 8) << 17, sample, sample ^ 31, sample & 63], seed: sample &* 0x9E37_79B9,
                            salt: salt, instance: instance)
                    }
                }
            }
        }
    }
    func testDLYBDelayFieldsAndSeparateReads() {
        for op in [132, 133] {
            for instance: UInt32 in 0..<2 {
                for unit: UInt32 in [0, 1, 63, 127, 128, 255, 256, .max] {
                    for phase: UInt32 in [0, 1, 10, 12, 15, 16, 31, .max] {
                        for salt: UInt32 in [0, 0x1020_4081] {
                            compare(op, [unit, phase], seed: unit ^ (phase << 8), salt: salt, instance: instance)
                        }
                    }
                }
            }
        }
    }
    func testDLYBMeasurementEveryUnitAndPhase() {
        for instance: UInt32 in 0..<2 {
            for unit: UInt32 in 0..<128 {
                for bit: UInt32 in 0..<12 {
                    compare(134, [0xDEAD, 0xBEEF, 1, unit, 1 << bit, 1, 0], seed: 0xA5A5_A5A5, instance: instance)
                }
            }
        }
    }
    func testDLYBTimeoutLastReadTickWrapAndExhaustion() {
        for instance: UInt32 in 0..<2 {
            for ready: UInt32 in [0, 1, 2, 3, 254, 255, 256, 257, .max] {
                for step: UInt32 in [1, 127, 254, 255, 256] {
                    for start: UInt32 in [0, 0xFFFF_FF80] {
                        compare(134, [111, 222, ready, 0, 0x400, step, start], seed: 3, instance: instance)
                    }
                }
            }
        }
        for instance: UInt32 in 0..<2 {
            for length: UInt32 in [0, 1, 2, 0x400, 0x800, 0xC00, 0xFFF] {
                for unit: UInt32 in [0, 127, 128, 255] {
                    compare(134, [111, 222, 1, unit, length, 1, .max], seed: .max, instance: instance)
                }
            }
        }
    }
    func testUCPDByteArgumentAndClearMasks() {
        for op in [121, 111, 112, 82, 83, 84] {
            for v: UInt32 in [0, 1, 127, 255, 256, 65535, .max] {
                for salt: UInt32 in [0, 0x1020_4081] {
                    compare(op, [v], seed: v, salt: salt)
                }
            }
        }
        for sample: UInt32 in 0..<64 {
            compare(135, [sample &* 0x9E37_79B9], seed: ~sample, salt: 0x1020_4081, instance: sample % 2)
        }
    }
    func testIndependentMasksPartialEffectsAndSourceReturnCodes() {
        let io = LLConnectionImage(0, 0, 0)
        io.cells[6] = 0x1234_5678
        LL_UCPD_ClearFlag_FRS(io)
        XCTAssertEqual(
            io.trace,
            [.init(index: 6, value: 0x1234_5678, kind: 0), .init(index: 6, value: 0x1234_5678 | 0x100000, kind: 1)])
        io.trace.removeAll()
        LL_UCPD_WriteData(io, 0xAB)
        XCTAssertEqual(io.trace, [.init(index: 9, value: 0xAB, kind: 1)])
        let unknown = LLConnectionImage(0, 0, 1)
        unknown.cells[128] = .max
        var bus = unknown
        XCTAssertEqual(LL_UCPD_DeInit(&bus, isKnownInstance: false), .error)
        XCTAssertEqual(unknown.cells[128], 0x7FFF_FFFF)
        XCTAssertEqual(unknown.trace.count, 2)
        for access in unknown.trace { XCTAssertEqual(access.index, 128) }
        let timeout = LLConnectionImage(3, 0, 0)
        XCTAssertEqual(
            runLLConnection(134, timeout, [111, 222, .max, 0, 0x400, 255, 0xFFFF_FF80]), HALStatus.timeout.rawValue)
        XCTAssertEqual(timeout.cells[32], (3 ^ (32 &* 0x9E37_79B9)) | 2)
        XCTAssertEqual(timeout.cells[384], 111)
        XCTAssertEqual(timeout.cells[385], 222)
        let success = LLConnectionImage(3, 0, 0)
        XCTAssertEqual(
            runLLConnection(134, success, [111, 222, 2, 0, 0x400, 255, .max]), LLErrorStatus.success.rawValue)
        XCTAssertEqual(success.cells[384], 0)
        XCTAssertEqual(success.cells[385], 10)
        XCTAssertEqual(success.cells[32], 2)
        let failure = LLConnectionImage(3, 0, 0)
        XCTAssertEqual(runLLConnection(134, failure, [111, 222, 1, 128, 0x400, 1, 0]), LLErrorStatus.error.rawValue)
        XCTAssertEqual(failure.cells[384], 111)
        XCTAssertEqual(failure.cells[385], 222)
        XCTAssertEqual(failure.cells[32], 2)
        var c = LL_UCPD_InitTypeDef()
        LL_UCPD_StructInit(&c)
        XCTAssertEqual(c, .init(psc_ucpdclk: 0x20000, transwin: 7, IfrGap: 16, HbitClockDiv: 13))
    }
    func testPinnedConstants() {
        let constants: [UInt32] = [
            LL_UCPD_SR_TXIS,
            LL_UCPD_SR_TXMSGDISC,
            LL_UCPD_SR_TXMSGSENT,
            LL_UCPD_SR_TXMSGABT,
            LL_UCPD_SR_HRSTDISC,
            LL_UCPD_SR_HRSTSENT,
            LL_UCPD_SR_TXUND,
            LL_UCPD_SR_RXNE,
            LL_UCPD_SR_RXORDDET,
            LL_UCPD_SR_RXHRSTDET,
            LL_UCPD_SR_RXOVR,
            LL_UCPD_SR_RXMSGEND,
            LL_UCPD_SR_RXERR,
            LL_UCPD_SR_TYPECEVT1,
            LL_UCPD_SR_TYPECEVT2,
            LL_UCPD_SR_TYPEC_VSTATE_CC1,
            LL_UCPD_SR_TYPEC_VSTATE_CC2,
            LL_UCPD_SR_FRSEVT,
            LL_UCPD_IMR_TXIS,
            LL_UCPD_IMR_TXMSGDISC,
            LL_UCPD_IMR_TXMSGSENT,
            LL_UCPD_IMR_TXMSGABT,
            LL_UCPD_IMR_HRSTDISC,
            LL_UCPD_IMR_HRSTSENT,
            LL_UCPD_IMR_TXUND,
            LL_UCPD_IMR_RXNE,
            LL_UCPD_IMR_RXORDDET,
            LL_UCPD_IMR_RXHRSTDET,
            LL_UCPD_IMR_RXOVR,
            LL_UCPD_IMR_RXMSGEND,
            LL_UCPD_IMR_TYPECEVT1,
            LL_UCPD_IMR_TYPECEVT2,
            LL_UCPD_IMR_FRSEVT,
            LL_UCPD_SYNC1,
            LL_UCPD_SYNC2,
            LL_UCPD_SYNC3,
            LL_UCPD_RST1,
            LL_UCPD_RST2,
            LL_UCPD_EOP,
            LL_UCPD_ORDERED_SET_SOP,
            LL_UCPD_ORDERED_SET_SOP1,
            LL_UCPD_ORDERED_SET_SOP2,
            LL_UCPD_ORDERED_SET_HARD_RESET,
            LL_UCPD_ORDERED_SET_CABLE_RESET,
            LL_UCPD_ORDERED_SET_SOP1_DEBUG,
            LL_UCPD_ORDERED_SET_SOP2_DEBUG,
            LL_UCPD_ROLE_SNK,
            LL_UCPD_ROLE_SRC,
            LL_UCPD_RESISTOR_DEFAULT,
            LL_UCPD_RESISTOR_1_5A,
            LL_UCPD_RESISTOR_3_0A,
            LL_UCPD_RESISTOR_NONE,
            LL_UCPD_ORDERSET_SOP,
            LL_UCPD_ORDERSET_SOP1,
            LL_UCPD_ORDERSET_SOP2,
            LL_UCPD_ORDERSET_HARDRST,
            LL_UCPD_ORDERSET_CABLERST,
            LL_UCPD_ORDERSET_SOP1_DEBUG,
            LL_UCPD_ORDERSET_SOP2_DEBUG,
            LL_UCPD_ORDERSET_SOP_EXT1,
            LL_UCPD_ORDERSET_SOP_EXT2,
            LL_UCPD_SNK_CC1_VOPEN,
            LL_UCPD_SNK_CC1_VRP,
            LL_UCPD_SNK_CC1_VRP15A,
            LL_UCPD_SNK_CC1_VRP30A,
            LL_UCPD_SNK_CC2_VOPEN,
            LL_UCPD_SNK_CC2_VRP,
            LL_UCPD_SNK_CC2_VRP15A,
            LL_UCPD_SNK_CC2_VRP30A,
            LL_UCPD_SRC_CC1_VRA,
            LL_UCPD_SRC_CC1_VRD,
            LL_UCPD_SRC_CC1_OPEN,
            LL_UCPD_SRC_CC2_VRA,
            LL_UCPD_SRC_CC2_VRD,
            LL_UCPD_SRC_CC2_OPEN,
            LL_UCPD_PSC_DIV1,
            LL_UCPD_PSC_DIV2,
            LL_UCPD_PSC_DIV4,
            LL_UCPD_PSC_DIV8,
            LL_UCPD_PSC_DIV16,
            LL_UCPD_CCENABLE_NONE,
            LL_UCPD_CCENABLE_CC1,
            LL_UCPD_CCENABLE_CC2,
            LL_UCPD_CCENABLE_CC1CC2,
            LL_UCPD_CCPIN_CC1,
            LL_UCPD_CCPIN_CC2,
            LL_UCPD_RXMODE_NORMAL,
            LL_UCPD_RXMODE_BIST_TEST_DATA,
            LL_UCPD_TXMODE_NORMAL,
            LL_UCPD_TXMODE_CABLE_RESET,
            LL_UCPD_TXMODE_BIST_CARRIER2,
            LL_UCPD_RXORDSET_SOP,
            LL_UCPD_RXORDSET_SOP1,
            LL_UCPD_RXORDSET_SOP2,
            LL_UCPD_RXORDSET_SOP1_DEBUG,
            LL_UCPD_RXORDSET_SOP2_DEBUG,
            LL_UCPD_RXORDSET_CABLE_RESET,
            LL_UCPD_RXORDSET_SOPEXT1,
            LL_UCPD_RXORDSET_SOPEXT2,
            DLYB_MAX_UNIT,
            DLYB_MAX_SELECT,
            DLYB_FLAG_LNGF,
        ]
        for (i, value) in constants.enumerated() { XCTAssertEqual(value, CL59_Constant(UInt32(i))) }
    }
}
