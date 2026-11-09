import XCTest
import STM32H7RSHAL
import CLLReference

private struct LLAccess: Equatable {
    var index: UInt32
    var value: UInt32
    var write: UInt32
}

private struct LLImage: GPIORegisterIO, EXTIRegisterIO, LLBusRegisterIO {
    var cells: [UInt32]
    var trace: [LLAccess] = []
    var reads: UInt32 = 0
    var salt: UInt32
    init(seed: UInt32, salt: UInt32) {
        cells = (0..<1024).map { seed ^ (UInt32($0) &* 0x9E3779B9) }
        self.salt = salt
    }
    mutating func readIndex(_ index: Int) -> UInt32 {
        let value = cells[index] ^ (salt &* reads)
        reads &+= 1
        trace.append(.init(index: UInt32(index), value: value, write: 0))
        return value
    }
    mutating func writeIndex(_ index: Int, _ value: UInt32) {
        trace.append(.init(index: UInt32(index), value: value, write: 1))
        cells[index] = value
    }
    func index(_ r: GPIORegister) -> Int {
        switch r {
        case .moder: return 0x00 / 4
        case .otyper: return 0x04 / 4
        case .ospeedr: return 0x08 / 4
        case .pupdr: return 0x0C / 4
        case .idr: return 0x10 / 4
        case .odr: return 0x14 / 4
        case .bsrr: return 0x18 / 4
        case .lckr: return 0x1C / 4
        case .alternateFunction(let i): return (0x20 / 4) + i
        case .brr: return 0x28 / 4
        default: preconditionFailure("Not a GPIO register")
        }
    }
    func index(_ r: EXTIRegister) -> Int {
        let offset: Int
        switch r {
        case .risingTrigger(let b): offset = b * 0x20
        case .fallingTrigger(let b): offset = 0x04 + b * 0x20
        case .softwareInterrupt(let b): offset = 0x08 + b * 0x20
        case .interruptMask(let b): offset = 0x80 + b * 0x10
        case .eventMask(let b): offset = 0x84 + b * 0x10
        case .pending(let b): offset = 0x88 + b * 0x10
        case .gpioSelection: preconditionFailure("Not used by LL EXTI")
        }
        return 512 + offset / 4
    }
    mutating func read(_ r: GPIORegister) -> UInt32 { readIndex(index(r)) }
    mutating func write(_ r: GPIORegister, value: UInt32) { writeIndex(index(r), value) }
    mutating func read(_ r: EXTIRegister) -> UInt32 { readIndex(index(r)) }
    mutating func write(_ r: EXTIRegister, value: UInt32) { writeIndex(index(r), value) }
    mutating func read(_ r: LLBusRegister) -> UInt32 { readIndex(256 + Int(r.rawValue) / 4) }
    mutating func write(_ r: LLBusRegister, value: UInt32) { writeIndex(256 + Int(r.rawValue) / 4, value) }
}

private func runSwift(_ op: Int, _ io: inout LLImage, _ args: inout [UInt32], _ port: UInt32) -> UInt32 {
    switch op {
    case 0: LL_GPIO_SetPinMode(&io, args[0], args[1]); return 0
    case 1: return LL_GPIO_GetPinMode(&io, args[0])
    case 2: LL_GPIO_SetPinOutputType(&io, args[0], args[1]); return 0
    case 3: return LL_GPIO_GetPinOutputType(&io, args[0])
    case 4: LL_GPIO_SetPinSpeed(&io, args[0], args[1]); return 0
    case 5: return LL_GPIO_GetPinSpeed(&io, args[0])
    case 6: LL_GPIO_SetPinPull(&io, args[0], args[1]); return 0
    case 7: return LL_GPIO_GetPinPull(&io, args[0])
    case 8: LL_GPIO_SetAFPin_0_7(&io, args[0], args[1]); return 0
    case 9: return LL_GPIO_GetAFPin_0_7(&io, args[0])
    case 10: LL_GPIO_SetAFPin_8_15(&io, args[0], args[1]); return 0
    case 11: return LL_GPIO_GetAFPin_8_15(&io, args[0])
    case 12: LL_GPIO_LockPin(&io, args[0]); return 0
    case 13: return LL_GPIO_IsPinLocked(&io, args[0])
    case 14: return LL_GPIO_IsAnyPinLocked(&io)
    case 15: return LL_GPIO_ReadInputPort(&io)
    case 16: return LL_GPIO_IsInputPinSet(&io, args[0])
    case 17: LL_GPIO_WriteOutputPort(&io, args[0]); return 0
    case 18: return LL_GPIO_ReadOutputPort(&io)
    case 19: return LL_GPIO_IsOutputPinSet(&io, args[0])
    case 20: LL_GPIO_SetOutputPin(&io, args[0]); return 0
    case 21: LL_GPIO_ResetOutputPin(&io, args[0]); return 0
    case 22: LL_GPIO_TogglePin(&io, args[0]); return 0
    case 23: LL_EXTI_EnableIT_0_31(&io, args[0]); return 0
    case 24: LL_EXTI_EnableIT_32_63(&io, args[0]); return 0
    case 25: LL_EXTI_EnableIT_64_95(&io, args[0]); return 0
    case 26: LL_EXTI_DisableIT_0_31(&io, args[0]); return 0
    case 27: LL_EXTI_DisableIT_32_63(&io, args[0]); return 0
    case 28: LL_EXTI_DisableIT_64_95(&io, args[0]); return 0
    case 29: return LL_EXTI_IsEnabledIT_0_31(&io, args[0])
    case 30: return LL_EXTI_IsEnabledIT_32_63(&io, args[0])
    case 31: return LL_EXTI_IsEnabledIT_64_95(&io, args[0])
    case 32: LL_EXTI_EnableEvent_0_31(&io, args[0]); return 0
    case 33: LL_EXTI_EnableEvent_32_63(&io, args[0]); return 0
    case 34: LL_EXTI_EnableEvent_64_95(&io, args[0]); return 0
    case 35: LL_EXTI_DisableEvent_0_31(&io, args[0]); return 0
    case 36: LL_EXTI_DisableEvent_32_63(&io, args[0]); return 0
    case 37: LL_EXTI_DisableEvent_64_95(&io, args[0]); return 0
    case 38: return LL_EXTI_IsEnabledEvent_0_31(&io, args[0])
    case 39: return LL_EXTI_IsEnabledEvent_32_63(&io, args[0])
    case 40: return LL_EXTI_IsEnabledEvent_64_95(&io, args[0])
    case 41: LL_EXTI_EnableRisingTrig_0_31(&io, args[0]); return 0
    case 42: LL_EXTI_EnableRisingTrig_32_63(&io, args[0]); return 0
    case 43: LL_EXTI_DisableRisingTrig_0_31(&io, args[0]); return 0
    case 44: LL_EXTI_DisableRisingTrig_32_63(&io, args[0]); return 0
    case 45: return LL_EXTI_IsEnabledRisingTrig_0_31(&io, args[0])
    case 46: return LL_EXTI_IsEnabledRisingTrig_32_63(&io, args[0])
    case 47: LL_EXTI_EnableFallingTrig_0_31(&io, args[0]); return 0
    case 48: LL_EXTI_EnableFallingTrig_32_63(&io, args[0]); return 0
    case 49: LL_EXTI_DisableFallingTrig_0_31(&io, args[0]); return 0
    case 50: LL_EXTI_DisableFallingTrig_32_63(&io, args[0]); return 0
    case 51: return LL_EXTI_IsEnabledFallingTrig_0_31(&io, args[0])
    case 52: return LL_EXTI_IsEnabledFallingTrig_32_63(&io, args[0])
    case 53: LL_EXTI_GenerateSWI_0_31(&io, args[0]); return 0
    case 54: LL_EXTI_GenerateSWI_32_63(&io, args[0]); return 0
    case 55: return LL_EXTI_IsActiveFlag_0_31(&io, args[0])
    case 56: return LL_EXTI_IsActiveFlag_32_63(&io, args[0])
    case 57: return LL_EXTI_ReadFlag_0_31(&io, args[0])
    case 58: return LL_EXTI_ReadFlag_32_63(&io, args[0])
    case 59: LL_EXTI_ClearFlag_0_31(&io, args[0]); return 0
    case 60: LL_EXTI_ClearFlag_32_63(&io, args[0]); return 0
    case 61: LL_AHB1_GRP1_EnableClock(&io, args[0]); return 0
    case 62: return LL_AHB1_GRP1_IsEnabledClock(&io, args[0])
    case 63: LL_AHB1_GRP1_DisableClock(&io, args[0]); return 0
    case 64: LL_AHB1_GRP1_ForceReset(&io, args[0]); return 0
    case 65: LL_AHB1_GRP1_ReleaseReset(&io, args[0]); return 0
    case 66: LL_AHB1_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 67: LL_AHB1_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 68: LL_AHB2_GRP1_EnableClock(&io, args[0]); return 0
    case 69: return LL_AHB2_GRP1_IsEnabledClock(&io, args[0])
    case 70: LL_AHB2_GRP1_DisableClock(&io, args[0]); return 0
    case 71: LL_AHB2_GRP1_ForceReset(&io, args[0]); return 0
    case 72: LL_AHB2_GRP1_ReleaseReset(&io, args[0]); return 0
    case 73: LL_AHB2_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 74: LL_AHB2_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 75: LL_AHB3_GRP1_EnableClock(&io, args[0]); return 0
    case 76: return LL_AHB3_GRP1_IsEnabledClock(&io, args[0])
    case 77: LL_AHB3_GRP1_DisableClock(&io, args[0]); return 0
    case 78: LL_AHB3_GRP1_ForceReset(&io, args[0]); return 0
    case 79: LL_AHB3_GRP1_ReleaseReset(&io, args[0]); return 0
    case 80: LL_AHB3_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 81: LL_AHB3_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 82: LL_AHB4_GRP1_EnableClock(&io, args[0]); return 0
    case 83: return LL_AHB4_GRP1_IsEnabledClock(&io, args[0])
    case 84: LL_AHB4_GRP1_DisableClock(&io, args[0]); return 0
    case 85: LL_AHB4_GRP1_ForceReset(&io, args[0]); return 0
    case 86: LL_AHB4_GRP1_ReleaseReset(&io, args[0]); return 0
    case 87: LL_AHB4_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 88: LL_AHB4_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 89: LL_AHB5_GRP1_EnableClock(&io, args[0]); return 0
    case 90: return LL_AHB5_GRP1_IsEnabledClock(&io, args[0])
    case 91: LL_AHB5_GRP1_DisableClock(&io, args[0]); return 0
    case 92: LL_AHB5_GRP1_ForceReset(&io, args[0]); return 0
    case 93: LL_AHB5_GRP1_ReleaseReset(&io, args[0]); return 0
    case 94: LL_AHB5_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 95: LL_AHB5_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 96: LL_APB1_GRP1_EnableClock(&io, args[0]); return 0
    case 97: return LL_APB1_GRP1_IsEnabledClock(&io, args[0])
    case 98: LL_APB1_GRP1_DisableClock(&io, args[0]); return 0
    case 99: LL_APB1_GRP1_ForceReset(&io, args[0]); return 0
    case 100: LL_APB1_GRP1_ReleaseReset(&io, args[0]); return 0
    case 101: LL_APB1_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 102: LL_APB1_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 103: LL_APB1_GRP2_EnableClock(&io, args[0]); return 0
    case 104: return LL_APB1_GRP2_IsEnabledClock(&io, args[0])
    case 105: LL_APB1_GRP2_DisableClock(&io, args[0]); return 0
    case 106: LL_APB1_GRP2_ForceReset(&io, args[0]); return 0
    case 107: LL_APB1_GRP2_ReleaseReset(&io, args[0]); return 0
    case 108: LL_APB1_GRP2_EnableClockSleep(&io, args[0]); return 0
    case 109: LL_APB1_GRP2_DisableClockSleep(&io, args[0]); return 0
    case 110: LL_APB2_GRP1_EnableClock(&io, args[0]); return 0
    case 111: return LL_APB2_GRP1_IsEnabledClock(&io, args[0])
    case 112: LL_APB2_GRP1_DisableClock(&io, args[0]); return 0
    case 113: LL_APB2_GRP1_ForceReset(&io, args[0]); return 0
    case 114: LL_APB2_GRP1_ReleaseReset(&io, args[0]); return 0
    case 115: LL_APB2_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 116: LL_APB2_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 117: LL_APB4_GRP1_EnableClock(&io, args[0]); return 0
    case 118: return LL_APB4_GRP1_IsEnabledClock(&io, args[0])
    case 119: LL_APB4_GRP1_DisableClock(&io, args[0]); return 0
    case 120: LL_APB4_GRP1_ForceReset(&io, args[0]); return 0
    case 121: LL_APB4_GRP1_ReleaseReset(&io, args[0]); return 0
    case 122: LL_APB4_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 123: LL_APB4_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 124: LL_APB5_GRP1_EnableClock(&io, args[0]); return 0
    case 125: return LL_APB5_GRP1_IsEnabledClock(&io, args[0])
    case 126: LL_APB5_GRP1_DisableClock(&io, args[0]); return 0
    case 127: LL_APB5_GRP1_ForceReset(&io, args[0]); return 0
    case 128: LL_APB5_GRP1_ReleaseReset(&io, args[0]); return 0
    case 129: LL_APB5_GRP1_EnableClockSleep(&io, args[0]); return 0
    case 130: LL_APB5_GRP1_DisableClockSleep(&io, args[0]); return 0
    case 131: LL_CKGA_Enable(&io, args[0]); return 0
    case 132: return LL_CKGA_IsEnabledClock(&io, args[0])
    case 133: LL_CKGA_Disable(&io, args[0]); return 0
    case 134: return LL_GPIO_Init(&io, .init(Pin: args[0], Mode: args[1], Speed: args[2], OutputType: args[3], Pull: args[4], Alternate: args[5])).rawValue
    case 135: return LL_GPIO_DeInit(&io, GPIOPort(rawValue: port)).rawValue
    case 136:
        var v = LL_GPIO_InitTypeDef(Pin: .max, Mode: .max, Speed: .max, OutputType: .max, Pull: .max, Alternate: .max)
        LL_GPIO_StructInit(&v)
        args = [v.Pin, v.Mode, v.Speed, v.OutputType, v.Pull, v.Alternate]
        return 0
    case 137: return LL_EXTI_Init(&io, .init(Line_0_31: args[0], Line_32_63: args[1], Line_64_95: args[2], LineCommand: args[3], Mode: UInt8(truncatingIfNeeded: args[4]), Trigger: UInt8(truncatingIfNeeded: args[5]))).rawValue
    case 138: return LL_EXTI_DeInit(&io).rawValue
    case 139:
        var v = LL_EXTI_InitTypeDef(Line_0_31: .max, Line_32_63: .max, Line_64_95: .max, LineCommand: .max, Mode: .max, Trigger: .max)
        LL_EXTI_StructInit(&v)
        args = [v.Line_0_31, v.Line_32_63, v.Line_64_95, v.LineCommand, UInt32(v.Mode), UInt32(v.Trigger)]
        return 0
    case 140: LL_GPIO_WriteReg(&io, .moder, args[0]); return 0
    case 141: return LL_GPIO_ReadReg(&io, .moder)
    case 142: LL_EXTI_WriteReg(&io, .interruptMask(bank: 2), args[0]); return 0
    case 143: return LL_EXTI_ReadReg(&io, .interruptMask(bank: 2))
    default: preconditionFailure("Unknown operation")
    }
}

final class LLDifferentialTests: XCTestCase {
    private func compare(_ op: Int, _ input: [UInt32], seed: UInt32 = 0x89ABCDEF,
                         salt: UInt32 = 0, port: UInt32 = 0,
                         file: StaticString = #filePath, line: UInt = #line) {
        let c = CLL_Create()!
        defer { CLL_Destroy(c) }
        CLL_Reset(c, seed, salt, port)
        var cArgs = input
        var sArgs = input
        var io = LLImage(seed: seed, salt: salt)
        let cr = CLL_Run(c, UInt32(op), &cArgs)
        let sr = runSwift(op, &io, &sArgs, port)
        let context = "op=\(op) args=\(input) seed=\(seed) salt=\(salt)"
        XCTAssertEqual(sr, cr, context, file: file, line: line)
        XCTAssertEqual(sArgs, cArgs, context, file: file, line: line)
        XCTAssertEqual(io.cells, Array(UnsafeBufferPointer(start: CLL_GetCells(c), count: 1024)), context, file: file, line: line)
        let trace = UnsafeBufferPointer(start: CLL_GetTrace(c), count: Int(CLL_GetTraceCount(c)))
        XCTAssertEqual(io.trace, trace.map { .init(index: $0.index, value: $0.value, write: $0.write) }, context, file: file, line: line)
    }

    func testAllInlineFunctionsAndReadWriteMacrosAgainstOriginalC() {
        for op in Array(0..<134) + Array(140..<144) {
            for sample in 0..<64 {
                let seed = UInt32(sample) &* 0x9E3779B9
                var a = [seed, seed ^ 0xFFFFFFFF, 0, 0, 0, 0]
                // Pin-position helpers require defined shift counts. Raw-mask helpers
                // keep all 32 bits, including zero and high reserved bits.
                if op == 0 { a[0] = 1 << (sample % 16) }
                if op == 1 { a[0] = 1 << (sample % 16) }
                if op == 3 { a[0] = 1 << (sample % 16) }
                if op == 4 { a[0] = 1 << (sample % 16) }
                if op == 5 { a[0] = 1 << (sample % 16) }
                if op == 6 { a[0] = 1 << (sample % 16) }
                if op == 7 { a[0] = 1 << (sample % 16) }
                if op == 8 { a[0] = 1 << (sample % 8) }
                if op == 9 { a[0] = 1 << (sample % 8) }
                if op == 10 { a[0] = 1 << (8 + sample % 8) }
                if op == 11 { a[0] = 1 << (8 + sample % 8) }
                compare(op, a, seed: seed, salt: sample % 2 == 0 ? 0 : 0x10204081)
            }
        }
    }

    func testGPIOInitializationAllModesPinsAndOutputParameters() {
        for pins: UInt32 in [1, 0x80, 0x100, 0x8000, 0x8181, 0xFFFF] {
            for mode: UInt32 in 0...3 {
                for speed: UInt32 in 0...3 {
                    for type: UInt32 in 0...1 {
                        for pull: UInt32 in 0...2 {
                            for alternate: UInt32 in [0, 7, 15] {
                                compare(134, [pins, mode, speed, type, pull, alternate], salt: 0x10203)
                            }
                        }
                    }
                }
            }
        }
    }

    func testGPIOResetEveryPortAndUnknownInstance() {
        for port: UInt32 in 0...16 {
            compare(135, [0, 0, 0, 0, 0, 0], salt: 0x80000001, port: port)
        }
    }

    func testEXTIConfigurationErrorsAndPartialEffects() {
        for banks in 0..<8 {
            for command: UInt32 in [0, 1, 2] {
                for mode: UInt32 in [0, 1, 2, 3, 255] {
                    for trigger: UInt32 in [0, 1, 2, 3, 4, 255] {
                        let lines: [UInt32] = [banks & 1 == 0 ? 0 : 0x8001,
                                              banks & 2 == 0 ? 0 : 0x4A4004,
                                              banks & 4 == 0 ? 0 : 0x2001]
                        compare(137, lines + [command, mode, trigger], salt: 0x01010101)
                    }
                }
            }
        }
        compare(138, [0, 0, 0, 0, 0, 0])
    }

    func testStructureDefaultsAndExactCMSISStatusEncoding() {
        compare(136, [1, 2, 3, 4, 5, 6])
        compare(139, [1, 2, 3, 4, 5, 6])
        XCTAssertEqual(LLErrorStatus.success.rawValue, 0)
        XCTAssertEqual(LLErrorStatus.error.rawValue, 1)
        XCTAssertEqual(LL_EXTI_MODE_IT, 0)
        XCTAssertEqual(LL_GPIO_InitTypeDef().Mode, LL_GPIO_MODE_ANALOG)
    }

    func testAllConstantsAgainstPinnedCMSISAndLLHeaders() {
        XCTAssertEqual(UInt32(LL_GPIO_PIN_0), CLL_Constant(0), "LL_GPIO_PIN_0")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_1), CLL_Constant(1), "LL_GPIO_PIN_1")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_2), CLL_Constant(2), "LL_GPIO_PIN_2")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_3), CLL_Constant(3), "LL_GPIO_PIN_3")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_4), CLL_Constant(4), "LL_GPIO_PIN_4")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_5), CLL_Constant(5), "LL_GPIO_PIN_5")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_6), CLL_Constant(6), "LL_GPIO_PIN_6")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_7), CLL_Constant(7), "LL_GPIO_PIN_7")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_8), CLL_Constant(8), "LL_GPIO_PIN_8")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_9), CLL_Constant(9), "LL_GPIO_PIN_9")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_10), CLL_Constant(10), "LL_GPIO_PIN_10")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_11), CLL_Constant(11), "LL_GPIO_PIN_11")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_12), CLL_Constant(12), "LL_GPIO_PIN_12")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_13), CLL_Constant(13), "LL_GPIO_PIN_13")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_14), CLL_Constant(14), "LL_GPIO_PIN_14")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_15), CLL_Constant(15), "LL_GPIO_PIN_15")
        XCTAssertEqual(UInt32(LL_GPIO_PIN_ALL), CLL_Constant(16), "LL_GPIO_PIN_ALL")
        XCTAssertEqual(UInt32(LL_GPIO_MODE_INPUT), CLL_Constant(17), "LL_GPIO_MODE_INPUT")
        XCTAssertEqual(UInt32(LL_GPIO_MODE_OUTPUT), CLL_Constant(18), "LL_GPIO_MODE_OUTPUT")
        XCTAssertEqual(UInt32(LL_GPIO_MODE_ALTERNATE), CLL_Constant(19), "LL_GPIO_MODE_ALTERNATE")
        XCTAssertEqual(UInt32(LL_GPIO_MODE_ANALOG), CLL_Constant(20), "LL_GPIO_MODE_ANALOG")
        XCTAssertEqual(UInt32(LL_GPIO_OUTPUT_PUSHPULL), CLL_Constant(21), "LL_GPIO_OUTPUT_PUSHPULL")
        XCTAssertEqual(UInt32(LL_GPIO_OUTPUT_OPENDRAIN), CLL_Constant(22), "LL_GPIO_OUTPUT_OPENDRAIN")
        XCTAssertEqual(UInt32(LL_GPIO_SPEED_FREQ_LOW), CLL_Constant(23), "LL_GPIO_SPEED_FREQ_LOW")
        XCTAssertEqual(UInt32(LL_GPIO_SPEED_FREQ_MEDIUM), CLL_Constant(24), "LL_GPIO_SPEED_FREQ_MEDIUM")
        XCTAssertEqual(UInt32(LL_GPIO_SPEED_FREQ_HIGH), CLL_Constant(25), "LL_GPIO_SPEED_FREQ_HIGH")
        XCTAssertEqual(UInt32(LL_GPIO_SPEED_FREQ_VERY_HIGH), CLL_Constant(26), "LL_GPIO_SPEED_FREQ_VERY_HIGH")
        XCTAssertEqual(UInt32(LL_GPIO_PULL_NO), CLL_Constant(27), "LL_GPIO_PULL_NO")
        XCTAssertEqual(UInt32(LL_GPIO_PULL_UP), CLL_Constant(28), "LL_GPIO_PULL_UP")
        XCTAssertEqual(UInt32(LL_GPIO_PULL_DOWN), CLL_Constant(29), "LL_GPIO_PULL_DOWN")
        XCTAssertEqual(UInt32(LL_GPIO_AF_0), CLL_Constant(30), "LL_GPIO_AF_0")
        XCTAssertEqual(UInt32(LL_GPIO_AF_1), CLL_Constant(31), "LL_GPIO_AF_1")
        XCTAssertEqual(UInt32(LL_GPIO_AF_2), CLL_Constant(32), "LL_GPIO_AF_2")
        XCTAssertEqual(UInt32(LL_GPIO_AF_3), CLL_Constant(33), "LL_GPIO_AF_3")
        XCTAssertEqual(UInt32(LL_GPIO_AF_4), CLL_Constant(34), "LL_GPIO_AF_4")
        XCTAssertEqual(UInt32(LL_GPIO_AF_5), CLL_Constant(35), "LL_GPIO_AF_5")
        XCTAssertEqual(UInt32(LL_GPIO_AF_6), CLL_Constant(36), "LL_GPIO_AF_6")
        XCTAssertEqual(UInt32(LL_GPIO_AF_7), CLL_Constant(37), "LL_GPIO_AF_7")
        XCTAssertEqual(UInt32(LL_GPIO_AF_8), CLL_Constant(38), "LL_GPIO_AF_8")
        XCTAssertEqual(UInt32(LL_GPIO_AF_9), CLL_Constant(39), "LL_GPIO_AF_9")
        XCTAssertEqual(UInt32(LL_GPIO_AF_10), CLL_Constant(40), "LL_GPIO_AF_10")
        XCTAssertEqual(UInt32(LL_GPIO_AF_11), CLL_Constant(41), "LL_GPIO_AF_11")
        XCTAssertEqual(UInt32(LL_GPIO_AF_12), CLL_Constant(42), "LL_GPIO_AF_12")
        XCTAssertEqual(UInt32(LL_GPIO_AF_13), CLL_Constant(43), "LL_GPIO_AF_13")
        XCTAssertEqual(UInt32(LL_GPIO_AF_14), CLL_Constant(44), "LL_GPIO_AF_14")
        XCTAssertEqual(UInt32(LL_GPIO_AF_15), CLL_Constant(45), "LL_GPIO_AF_15")
        XCTAssertEqual(UInt32(LL_EXTI_REGISTER_PINPOS_SHFT), CLL_Constant(46), "LL_EXTI_REGISTER_PINPOS_SHFT")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_0), CLL_Constant(47), "LL_EXTI_LINE_0")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_1), CLL_Constant(48), "LL_EXTI_LINE_1")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_2), CLL_Constant(49), "LL_EXTI_LINE_2")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_3), CLL_Constant(50), "LL_EXTI_LINE_3")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_4), CLL_Constant(51), "LL_EXTI_LINE_4")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_5), CLL_Constant(52), "LL_EXTI_LINE_5")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_6), CLL_Constant(53), "LL_EXTI_LINE_6")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_7), CLL_Constant(54), "LL_EXTI_LINE_7")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_8), CLL_Constant(55), "LL_EXTI_LINE_8")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_9), CLL_Constant(56), "LL_EXTI_LINE_9")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_10), CLL_Constant(57), "LL_EXTI_LINE_10")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_11), CLL_Constant(58), "LL_EXTI_LINE_11")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_12), CLL_Constant(59), "LL_EXTI_LINE_12")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_13), CLL_Constant(60), "LL_EXTI_LINE_13")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_14), CLL_Constant(61), "LL_EXTI_LINE_14")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_15), CLL_Constant(62), "LL_EXTI_LINE_15")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_16), CLL_Constant(63), "LL_EXTI_LINE_16")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_17), CLL_Constant(64), "LL_EXTI_LINE_17")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_18), CLL_Constant(65), "LL_EXTI_LINE_18")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_19), CLL_Constant(66), "LL_EXTI_LINE_19")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_20), CLL_Constant(67), "LL_EXTI_LINE_20")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_21), CLL_Constant(68), "LL_EXTI_LINE_21")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_22), CLL_Constant(69), "LL_EXTI_LINE_22")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_23), CLL_Constant(70), "LL_EXTI_LINE_23")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_24), CLL_Constant(71), "LL_EXTI_LINE_24")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_25), CLL_Constant(72), "LL_EXTI_LINE_25")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_26), CLL_Constant(73), "LL_EXTI_LINE_26")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_27), CLL_Constant(74), "LL_EXTI_LINE_27")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_28), CLL_Constant(75), "LL_EXTI_LINE_28")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_29), CLL_Constant(76), "LL_EXTI_LINE_29")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_30), CLL_Constant(77), "LL_EXTI_LINE_30")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_31), CLL_Constant(78), "LL_EXTI_LINE_31")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_ALL_0_31), CLL_Constant(79), "LL_EXTI_LINE_ALL_0_31")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_32), CLL_Constant(80), "LL_EXTI_LINE_32")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_33), CLL_Constant(81), "LL_EXTI_LINE_33")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_34), CLL_Constant(82), "LL_EXTI_LINE_34")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_35), CLL_Constant(83), "LL_EXTI_LINE_35")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_36), CLL_Constant(84), "LL_EXTI_LINE_36")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_37), CLL_Constant(85), "LL_EXTI_LINE_37")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_38), CLL_Constant(86), "LL_EXTI_LINE_38")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_39), CLL_Constant(87), "LL_EXTI_LINE_39")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_40), CLL_Constant(88), "LL_EXTI_LINE_40")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_41), CLL_Constant(89), "LL_EXTI_LINE_41")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_42), CLL_Constant(90), "LL_EXTI_LINE_42")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_43), CLL_Constant(91), "LL_EXTI_LINE_43")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_44), CLL_Constant(92), "LL_EXTI_LINE_44")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_45), CLL_Constant(93), "LL_EXTI_LINE_45")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_46), CLL_Constant(94), "LL_EXTI_LINE_46")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_47), CLL_Constant(95), "LL_EXTI_LINE_47")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_48), CLL_Constant(96), "LL_EXTI_LINE_48")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_49), CLL_Constant(97), "LL_EXTI_LINE_49")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_50), CLL_Constant(98), "LL_EXTI_LINE_50")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_51), CLL_Constant(99), "LL_EXTI_LINE_51")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_52), CLL_Constant(100), "LL_EXTI_LINE_52")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_53), CLL_Constant(101), "LL_EXTI_LINE_53")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_54), CLL_Constant(102), "LL_EXTI_LINE_54")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_55), CLL_Constant(103), "LL_EXTI_LINE_55")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_56), CLL_Constant(104), "LL_EXTI_LINE_56")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_57), CLL_Constant(105), "LL_EXTI_LINE_57")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_58), CLL_Constant(106), "LL_EXTI_LINE_58")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_59), CLL_Constant(107), "LL_EXTI_LINE_59")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_ALL_32_63), CLL_Constant(108), "LL_EXTI_LINE_ALL_32_63")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_77), CLL_Constant(109), "LL_EXTI_LINE_77")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_ALL_64_95), CLL_Constant(110), "LL_EXTI_LINE_ALL_64_95")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_ALL), CLL_Constant(111), "LL_EXTI_LINE_ALL")
        XCTAssertEqual(UInt32(LL_EXTI_LINE_NONE), CLL_Constant(112), "LL_EXTI_LINE_NONE")
        XCTAssertEqual(UInt32(LL_EXTI_MODE_IT), CLL_Constant(113), "LL_EXTI_MODE_IT")
        XCTAssertEqual(UInt32(LL_EXTI_MODE_EVENT), CLL_Constant(114), "LL_EXTI_MODE_EVENT")
        XCTAssertEqual(UInt32(LL_EXTI_MODE_IT_EVENT), CLL_Constant(115), "LL_EXTI_MODE_IT_EVENT")
        XCTAssertEqual(UInt32(LL_EXTI_TRIGGER_NONE), CLL_Constant(116), "LL_EXTI_TRIGGER_NONE")
        XCTAssertEqual(UInt32(LL_EXTI_TRIGGER_RISING), CLL_Constant(117), "LL_EXTI_TRIGGER_RISING")
        XCTAssertEqual(UInt32(LL_EXTI_TRIGGER_FALLING), CLL_Constant(118), "LL_EXTI_TRIGGER_FALLING")
        XCTAssertEqual(UInt32(LL_EXTI_TRIGGER_RISING_FALLING), CLL_Constant(119), "LL_EXTI_TRIGGER_RISING_FALLING")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_GPDMA1), CLL_Constant(120), "LL_AHB1_GRP1_PERIPH_GPDMA1")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_ADC12), CLL_Constant(121), "LL_AHB1_GRP1_PERIPH_ADC12")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_ETH1MAC), CLL_Constant(122), "LL_AHB1_GRP1_PERIPH_ETH1MAC")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_ETH1TX), CLL_Constant(123), "LL_AHB1_GRP1_PERIPH_ETH1TX")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_ETH1RX), CLL_Constant(124), "LL_AHB1_GRP1_PERIPH_ETH1RX")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_USBOTGHS), CLL_Constant(125), "LL_AHB1_GRP1_PERIPH_USBOTGHS")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_USBOTGFS), CLL_Constant(126), "LL_AHB1_GRP1_PERIPH_USBOTGFS")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_USBPHYC), CLL_Constant(127), "LL_AHB1_GRP1_PERIPH_USBPHYC")
        XCTAssertEqual(UInt32(LL_AHB1_GRP1_PERIPH_ADF1), CLL_Constant(128), "LL_AHB1_GRP1_PERIPH_ADF1")
        XCTAssertEqual(UInt32(LL_AHB2_GRP1_PERIPH_PSSI), CLL_Constant(129), "LL_AHB2_GRP1_PERIPH_PSSI")
        XCTAssertEqual(UInt32(LL_AHB2_GRP1_PERIPH_SDMMC2), CLL_Constant(130), "LL_AHB2_GRP1_PERIPH_SDMMC2")
        XCTAssertEqual(UInt32(LL_AHB2_GRP1_PERIPH_CORDIC), CLL_Constant(131), "LL_AHB2_GRP1_PERIPH_CORDIC")
        XCTAssertEqual(UInt32(LL_AHB2_GRP1_PERIPH_AHBSRAM1), CLL_Constant(132), "LL_AHB2_GRP1_PERIPH_AHBSRAM1")
        XCTAssertEqual(UInt32(LL_AHB2_GRP1_PERIPH_AHBSRAM2), CLL_Constant(133), "LL_AHB2_GRP1_PERIPH_AHBSRAM2")
        XCTAssertEqual(UInt32(LL_AHB3_GRP1_PERIPH_RNG), CLL_Constant(134), "LL_AHB3_GRP1_PERIPH_RNG")
        XCTAssertEqual(UInt32(LL_AHB3_GRP1_PERIPH_HASH), CLL_Constant(135), "LL_AHB3_GRP1_PERIPH_HASH")
        XCTAssertEqual(UInt32(LL_AHB3_GRP1_PERIPH_CRYP), CLL_Constant(136), "LL_AHB3_GRP1_PERIPH_CRYP")
        XCTAssertEqual(UInt32(LL_AHB3_GRP1_PERIPH_SAES), CLL_Constant(137), "LL_AHB3_GRP1_PERIPH_SAES")
        XCTAssertEqual(UInt32(LL_AHB3_GRP1_PERIPH_PKA), CLL_Constant(138), "LL_AHB3_GRP1_PERIPH_PKA")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOA), CLL_Constant(139), "LL_AHB4_GRP1_PERIPH_GPIOA")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOB), CLL_Constant(140), "LL_AHB4_GRP1_PERIPH_GPIOB")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOC), CLL_Constant(141), "LL_AHB4_GRP1_PERIPH_GPIOC")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOD), CLL_Constant(142), "LL_AHB4_GRP1_PERIPH_GPIOD")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOE), CLL_Constant(143), "LL_AHB4_GRP1_PERIPH_GPIOE")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOF), CLL_Constant(144), "LL_AHB4_GRP1_PERIPH_GPIOF")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOG), CLL_Constant(145), "LL_AHB4_GRP1_PERIPH_GPIOG")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOH), CLL_Constant(146), "LL_AHB4_GRP1_PERIPH_GPIOH")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOM), CLL_Constant(147), "LL_AHB4_GRP1_PERIPH_GPIOM")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPION), CLL_Constant(148), "LL_AHB4_GRP1_PERIPH_GPION")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOO), CLL_Constant(149), "LL_AHB4_GRP1_PERIPH_GPIOO")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_GPIOP), CLL_Constant(150), "LL_AHB4_GRP1_PERIPH_GPIOP")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_CRC), CLL_Constant(151), "LL_AHB4_GRP1_PERIPH_CRC")
        XCTAssertEqual(UInt32(LL_AHB4_GRP1_PERIPH_BKPRAM), CLL_Constant(152), "LL_AHB4_GRP1_PERIPH_BKPRAM")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_HPDMA1), CLL_Constant(153), "LL_AHB5_GRP1_PERIPH_HPDMA1")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_DMA2D), CLL_Constant(154), "LL_AHB5_GRP1_PERIPH_DMA2D")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_JPEG), CLL_Constant(155), "LL_AHB5_GRP1_PERIPH_JPEG")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_FMC), CLL_Constant(156), "LL_AHB5_GRP1_PERIPH_FMC")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_XSPI1), CLL_Constant(157), "LL_AHB5_GRP1_PERIPH_XSPI1")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_XSPI2), CLL_Constant(158), "LL_AHB5_GRP1_PERIPH_XSPI2")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_XSPIM), CLL_Constant(159), "LL_AHB5_GRP1_PERIPH_XSPIM")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_SDMMC1), CLL_Constant(160), "LL_AHB5_GRP1_PERIPH_SDMMC1")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_GFXMMU), CLL_Constant(161), "LL_AHB5_GRP1_PERIPH_GFXMMU")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_GPU2D), CLL_Constant(162), "LL_AHB5_GRP1_PERIPH_GPU2D")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_FLASH), CLL_Constant(163), "LL_AHB5_GRP1_PERIPH_FLASH")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_AXISRAM), CLL_Constant(164), "LL_AHB5_GRP1_PERIPH_AXISRAM")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_DTCM1), CLL_Constant(165), "LL_AHB5_GRP1_PERIPH_DTCM1")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_DTCM2), CLL_Constant(166), "LL_AHB5_GRP1_PERIPH_DTCM2")
        XCTAssertEqual(UInt32(LL_AHB5_GRP1_PERIPH_ITCM), CLL_Constant(167), "LL_AHB5_GRP1_PERIPH_ITCM")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM2), CLL_Constant(168), "LL_APB1_GRP1_PERIPH_TIM2")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM3), CLL_Constant(169), "LL_APB1_GRP1_PERIPH_TIM3")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM4), CLL_Constant(170), "LL_APB1_GRP1_PERIPH_TIM4")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM5), CLL_Constant(171), "LL_APB1_GRP1_PERIPH_TIM5")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM6), CLL_Constant(172), "LL_APB1_GRP1_PERIPH_TIM6")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM7), CLL_Constant(173), "LL_APB1_GRP1_PERIPH_TIM7")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM12), CLL_Constant(174), "LL_APB1_GRP1_PERIPH_TIM12")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM13), CLL_Constant(175), "LL_APB1_GRP1_PERIPH_TIM13")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_TIM14), CLL_Constant(176), "LL_APB1_GRP1_PERIPH_TIM14")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_LPTIM1), CLL_Constant(177), "LL_APB1_GRP1_PERIPH_LPTIM1")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_WWDG), CLL_Constant(178), "LL_APB1_GRP1_PERIPH_WWDG")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_SPI2), CLL_Constant(179), "LL_APB1_GRP1_PERIPH_SPI2")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_SPI3), CLL_Constant(180), "LL_APB1_GRP1_PERIPH_SPI3")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_SPDIFRX), CLL_Constant(181), "LL_APB1_GRP1_PERIPH_SPDIFRX")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_USART2), CLL_Constant(182), "LL_APB1_GRP1_PERIPH_USART2")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_USART3), CLL_Constant(183), "LL_APB1_GRP1_PERIPH_USART3")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_UART4), CLL_Constant(184), "LL_APB1_GRP1_PERIPH_UART4")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_UART5), CLL_Constant(185), "LL_APB1_GRP1_PERIPH_UART5")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_I2C1), CLL_Constant(186), "LL_APB1_GRP1_PERIPH_I2C1")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_I2C2), CLL_Constant(187), "LL_APB1_GRP1_PERIPH_I2C2")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_I2C3), CLL_Constant(188), "LL_APB1_GRP1_PERIPH_I2C3")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_I3C1), CLL_Constant(189), "LL_APB1_GRP1_PERIPH_I3C1")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_CEC), CLL_Constant(190), "LL_APB1_GRP1_PERIPH_CEC")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_UART7), CLL_Constant(191), "LL_APB1_GRP1_PERIPH_UART7")
        XCTAssertEqual(UInt32(LL_APB1_GRP1_PERIPH_UART8), CLL_Constant(192), "LL_APB1_GRP1_PERIPH_UART8")
        XCTAssertEqual(UInt32(LL_APB1_GRP2_PERIPH_CRS), CLL_Constant(193), "LL_APB1_GRP2_PERIPH_CRS")
        XCTAssertEqual(UInt32(LL_APB1_GRP2_PERIPH_MDIOS), CLL_Constant(194), "LL_APB1_GRP2_PERIPH_MDIOS")
        XCTAssertEqual(UInt32(LL_APB1_GRP2_PERIPH_FDCAN), CLL_Constant(195), "LL_APB1_GRP2_PERIPH_FDCAN")
        XCTAssertEqual(UInt32(LL_APB1_GRP2_PERIPH_UCPD1), CLL_Constant(196), "LL_APB1_GRP2_PERIPH_UCPD1")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_TIM1), CLL_Constant(197), "LL_APB2_GRP1_PERIPH_TIM1")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_USART1), CLL_Constant(198), "LL_APB2_GRP1_PERIPH_USART1")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_SPI1), CLL_Constant(199), "LL_APB2_GRP1_PERIPH_SPI1")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_SPI4), CLL_Constant(200), "LL_APB2_GRP1_PERIPH_SPI4")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_TIM15), CLL_Constant(201), "LL_APB2_GRP1_PERIPH_TIM15")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_TIM16), CLL_Constant(202), "LL_APB2_GRP1_PERIPH_TIM16")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_TIM17), CLL_Constant(203), "LL_APB2_GRP1_PERIPH_TIM17")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_TIM9), CLL_Constant(204), "LL_APB2_GRP1_PERIPH_TIM9")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_SPI5), CLL_Constant(205), "LL_APB2_GRP1_PERIPH_SPI5")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_SAI1), CLL_Constant(206), "LL_APB2_GRP1_PERIPH_SAI1")
        XCTAssertEqual(UInt32(LL_APB2_GRP1_PERIPH_SAI2), CLL_Constant(207), "LL_APB2_GRP1_PERIPH_SAI2")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_SBS), CLL_Constant(208), "LL_APB4_GRP1_PERIPH_SBS")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_LPUART1), CLL_Constant(209), "LL_APB4_GRP1_PERIPH_LPUART1")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_SPI6), CLL_Constant(210), "LL_APB4_GRP1_PERIPH_SPI6")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_LPTIM2), CLL_Constant(211), "LL_APB4_GRP1_PERIPH_LPTIM2")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_LPTIM3), CLL_Constant(212), "LL_APB4_GRP1_PERIPH_LPTIM3")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_LPTIM4), CLL_Constant(213), "LL_APB4_GRP1_PERIPH_LPTIM4")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_LPTIM5), CLL_Constant(214), "LL_APB4_GRP1_PERIPH_LPTIM5")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_VREF), CLL_Constant(215), "LL_APB4_GRP1_PERIPH_VREF")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_RTCAPB), CLL_Constant(216), "LL_APB4_GRP1_PERIPH_RTCAPB")
        XCTAssertEqual(UInt32(LL_APB4_GRP1_PERIPH_DTS), CLL_Constant(217), "LL_APB4_GRP1_PERIPH_DTS")
        XCTAssertEqual(UInt32(LL_APB5_GRP1_PERIPH_LTDC), CLL_Constant(218), "LL_APB5_GRP1_PERIPH_LTDC")
        XCTAssertEqual(UInt32(LL_APB5_GRP1_PERIPH_DCMIPP), CLL_Constant(219), "LL_APB5_GRP1_PERIPH_DCMIPP")
        XCTAssertEqual(UInt32(LL_APB5_GRP1_PERIPH_GFXTIM), CLL_Constant(220), "LL_APB5_GRP1_PERIPH_GFXTIM")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_AXI), CLL_Constant(221), "LL_CKGA_PERIPH_AXI")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_AHBM), CLL_Constant(222), "LL_CKGA_PERIPH_AHBM")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_SDMMC1), CLL_Constant(223), "LL_CKGA_PERIPH_SDMMC1")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_HPDMA1), CLL_Constant(224), "LL_CKGA_PERIPH_HPDMA1")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_CPU), CLL_Constant(225), "LL_CKGA_PERIPH_CPU")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_GPU2DS1), CLL_Constant(226), "LL_CKGA_PERIPH_GPU2DS1")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_GPU2DS0), CLL_Constant(227), "LL_CKGA_PERIPH_GPU2DS0")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_GPU2DCL), CLL_Constant(228), "LL_CKGA_PERIPH_GPU2DCL")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_DCMIPP), CLL_Constant(229), "LL_CKGA_PERIPH_DCMIPP")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_DMA2D), CLL_Constant(230), "LL_CKGA_PERIPH_DMA2D")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_GFXMMUS), CLL_Constant(231), "LL_CKGA_PERIPH_GFXMMUS")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_LTDC), CLL_Constant(232), "LL_CKGA_PERIPH_LTDC")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_GFXMMUM), CLL_Constant(233), "LL_CKGA_PERIPH_GFXMMUM")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_AHBS), CLL_Constant(234), "LL_CKGA_PERIPH_AHBS")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_FMC), CLL_Constant(235), "LL_CKGA_PERIPH_FMC")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_XSPI1), CLL_Constant(236), "LL_CKGA_PERIPH_XSPI1")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_XSPI2), CLL_Constant(237), "LL_CKGA_PERIPH_XSPI2")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_AXIRAM1), CLL_Constant(238), "LL_CKGA_PERIPH_AXIRAM1")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_AXIRAM2), CLL_Constant(239), "LL_CKGA_PERIPH_AXIRAM2")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_AXIRAM3), CLL_Constant(240), "LL_CKGA_PERIPH_AXIRAM3")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_AXIRAM4), CLL_Constant(241), "LL_CKGA_PERIPH_AXIRAM4")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_FLASH), CLL_Constant(242), "LL_CKGA_PERIPH_FLASH")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_EXTI), CLL_Constant(243), "LL_CKGA_PERIPH_EXTI")
        XCTAssertEqual(UInt32(LL_CKGA_PERIPH_JTAG), CLL_Constant(244), "LL_CKGA_PERIPH_JTAG")
    }
}
