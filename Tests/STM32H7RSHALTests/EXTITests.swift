import XCTest
@testable import STM32H7RSHAL

private enum EXTIAccess: Equatable {
    case read(EXTIRegister)
    case write(EXTIRegister, UInt32)
    case callback
}

private final class EXTITrace {
    var values: [EXTIRegister: UInt32] = [:]
    var accesses: [EXTIAccess] = []
}

private struct EXTITraceIO: EXTIRegisterIO {
    let trace: EXTITrace

    mutating func read(_ register: EXTIRegister) -> UInt32 {
        trace.accesses.append(.read(register))
        return trace.values[register, default: 0]
    }

    mutating func write(_ register: EXTIRegister, value: UInt32) {
        trace.accesses.append(.write(register, value))
        if case .pending = register {
            // Model PRx write-one-to-clear behavior, including unrelated flags.
            trace.values[register, default: 0] &= ~value
        } else {
            trace.values[register] = value
        }
    }
}

final class EXTITests: XCTestCase {
    func testGPIOConfigurationPreservesNeighborsAndCOperationOrder() {
        let trace = EXTITrace()
        trace.values = [
            .risingTrigger(bank: 0): 0x8000_0001,
            .fallingTrigger(bank: 0): 0x8000_0081,
            .gpioSelection(index: 1): 0xFEDC_BA98,
            .interruptMask(bank: 0): 0x8000_0001,
            .eventMask(bank: 0): 0x8000_0081,
        ]
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line0)
        XCTAssertEqual(exti.setConfigLine(.init(line: .line7, mode: .interrupt, trigger: .rising, gpioSelection: 12)), .ok)
        XCTAssertEqual(exti.line, .line7)
        XCTAssertEqual(trace.accesses, [
            .read(.risingTrigger(bank: 0)), .write(.risingTrigger(bank: 0), 0x8000_0081),
            .read(.fallingTrigger(bank: 0)), .write(.fallingTrigger(bank: 0), 0x8000_0001),
            .read(.gpioSelection(index: 1)), .write(.gpioSelection(index: 1), 0xFEDC_CA98),
            .read(.interruptMask(bank: 0)), .write(.interruptMask(bank: 0), 0x8000_0081),
            .read(.eventMask(bank: 0)), .write(.eventMask(bank: 0), 0x8000_0001),
        ])
    }

    func testAllGPIOSelectionsAndTriggerModeCombinationsRoundTrip() {
        let ports: [UInt32] = [0, 1, 2, 3, 4, 5, 6, 7, 12, 13, 14, 15]
        for pin in UInt32(0)..<16 {
            for port in ports {
                for mode in UInt32(1)...3 {
                    for trigger in UInt32(0)...3 {
                        let trace = EXTITrace()
                        trace.values = [
                            .risingTrigger(bank: 0): 0xA5A5_A5A5,
                            .fallingTrigger(bank: 0): 0x5A5A_5A5A,
                            .interruptMask(bank: 0): 0xA5A5_A5A5,
                            .eventMask(bank: 0): 0x5A5A_5A5A,
                            .gpioSelection(index: Int(pin >> 2)): 0x8765_4321,
                        ]
                        let line = EXTILine(rawValue: 0x1600_0000 | pin)
                        let configuration = EXTIConfiguration(
                            line: line, mode: EXTIMode(rawValue: mode),
                            trigger: EXTITrigger(rawValue: trigger), gpioSelection: port
                        )
                        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: line)
                        XCTAssertEqual(exti.setConfigLine(configuration), .ok)
                        XCTAssertEqual(exti.getConfigLine(), configuration)
                        let pinMask = UInt32(1) << pin
                        XCTAssertEqual(trace.values[.risingTrigger(bank: 0)]! & ~pinMask, 0xA5A5_A5A5 & ~pinMask)
                        XCTAssertEqual(trace.values[.fallingTrigger(bank: 0)]! & ~pinMask, 0x5A5A_5A5A & ~pinMask)
                        let muxMask = UInt32(0xF) << (4 * (pin & 3))
                        XCTAssertEqual(trace.values[.gpioSelection(index: Int(pin >> 2))]! & ~muxMask, 0x8765_4321 & ~muxMask)
                    }
                }
            }
        }
    }

    func testSecondBankConfigurableLineUsesBitTwoAndNoGPIOMultiplexer() {
        let trace = EXTITrace()
        trace.values[.risingTrigger(bank: 1)] = 0xFFFF_FFFF
        trace.values[.interruptMask(bank: 1)] = 0xFFFF_FFFF
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line34)
        XCTAssertEqual(exti.setConfigLine(.init(line: .line34, mode: .event, trigger: .falling)), .ok)
        XCTAssertEqual(trace.accesses, [
            .read(.risingTrigger(bank: 1)), .write(.risingTrigger(bank: 1), 0xFFFF_FFFB),
            .read(.fallingTrigger(bank: 1)), .write(.fallingTrigger(bank: 1), 4),
            .read(.interruptMask(bank: 1)), .write(.interruptMask(bank: 1), 0xFFFF_FFFB),
            .read(.eventMask(bank: 1)), .write(.eventMask(bank: 1), 4),
        ])
    }

    func testThirdBankDirectLineDoesNotAccessTriggerOrGPIORegisters() {
        let trace = EXTITrace()
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line77)
        let configuration = EXTIConfiguration(line: .line77, mode: [.interrupt, .event])
        XCTAssertEqual(exti.setConfigLine(configuration), .ok)
        XCTAssertEqual(trace.accesses, [
            .read(.interruptMask(bank: 2)), .write(.interruptMask(bank: 2), 0x2000),
            .read(.eventMask(bank: 2)), .write(.eventMask(bank: 2), 0x2000),
        ])
        trace.accesses = []
        XCTAssertEqual(exti.getConfigLine(), configuration)
        XCTAssertEqual(trace.accesses, [.read(.interruptMask(bank: 2)), .read(.eventMask(bank: 2))])
        trace.accesses = []
        XCTAssertEqual(exti.clearConfigLine(), .ok)
        XCTAssertEqual(trace.accesses, [
            .read(.interruptMask(bank: 2)), .write(.interruptMask(bank: 2), 0),
            .read(.eventMask(bank: 2)), .write(.eventMask(bank: 2), 0),
        ])
    }

    func testGetConfigLineReadOrderAndFieldExtraction() {
        let trace = EXTITrace()
        trace.values = [
            .interruptMask(bank: 0): 0x8000,
            .eventMask(bank: 0): 0x8000,
            .risingTrigger(bank: 0): 0xFFFF_7FFF,
            .fallingTrigger(bank: 0): 0x8000,
            .gpioSelection(index: 3): 0xFFFF_CFFF,
        ]
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line15)
        XCTAssertEqual(exti.getConfigLine(), .init(line: .line15, mode: [.interrupt, .event], trigger: .falling, gpioSelection: 12))
        XCTAssertEqual(trace.accesses, [
            .read(.interruptMask(bank: 0)), .read(.eventMask(bank: 0)),
            .read(.risingTrigger(bank: 0)), .read(.fallingTrigger(bank: 0)),
            .read(.gpioSelection(index: 3)),
        ])
    }

    func testClearConfigPreservesUnrelatedBitsAndDoesNotClearPending() {
        let trace = EXTITrace()
        trace.values = [
            .interruptMask(bank: 0): 0xFFFF_FFFF,
            .eventMask(bank: 0): 0xFFFF_FFFF,
            .risingTrigger(bank: 0): 0xFFFF_FFFF,
            .fallingTrigger(bank: 0): 0xFFFF_FFFF,
            .gpioSelection(index: 2): 0xFFFF_FFFF,
            .pending(bank: 0): 0xFFFF_FFFF,
        ]
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line8)
        XCTAssertEqual(exti.clearConfigLine(), .ok)
        XCTAssertEqual(trace.accesses, [
            .read(.interruptMask(bank: 0)), .write(.interruptMask(bank: 0), 0xFFFF_FEFF),
            .read(.eventMask(bank: 0)), .write(.eventMask(bank: 0), 0xFFFF_FEFF),
            .read(.risingTrigger(bank: 0)), .write(.risingTrigger(bank: 0), 0xFFFF_FEFF),
            .read(.fallingTrigger(bank: 0)), .write(.fallingTrigger(bank: 0), 0xFFFF_FEFF),
            .read(.gpioSelection(index: 2)), .write(.gpioSelection(index: 2), 0xFFFF_FFF0),
        ])
        XCTAssertEqual(trace.values[.pending(bank: 0)], 0xFFFF_FFFF)
    }

    func testIRQWritesOnlySelectedW1CBitBeforeCallingCallback() {
        let trace = EXTITrace()
        trace.values[.pending(bank: 1)] = 0x8000_0004
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line34)
        XCTAssertEqual(exti.registerCallback { trace.accesses.append(.callback) }, .ok)
        exti.irqHandler()
        XCTAssertEqual(trace.accesses, [.read(.pending(bank: 1)), .write(.pending(bank: 1), 4), .callback])
        XCTAssertEqual(trace.values[.pending(bank: 1)], 0x8000_0000)
        trace.accesses = []
        exti.irqHandler()
        XCTAssertEqual(trace.accesses, [.read(.pending(bank: 1))])
    }

    func testCallbackRegistrationRejectsUnknownIDAndAcceptsNil() {
        let trace = EXTITrace()
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line0)
        XCTAssertEqual(exti.registerCallback { trace.accesses.append(.callback) }, .ok)
        XCTAssertEqual(exti.registerCallback(id: 1, nil), .error)
        trace.values[.pending(bank: 0)] = 1
        exti.irqHandler()
        XCTAssertEqual(trace.accesses.last, .callback)
        XCTAssertEqual(exti.registerCallback(nil), .ok)
        trace.values[.pending(bank: 0)] = 1
        trace.accesses = []
        exti.irqHandler()
        XCTAssertEqual(trace.accesses, [.read(.pending(bank: 0)), .write(.pending(bank: 0), 1)])
    }

    func testGetHandleChangesOnlyLineAndRetainsCallback() {
        let trace = EXTITrace()
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line0)
        exti.registerCallback { trace.accesses.append(.callback) }
        XCTAssertEqual(exti.getHandle(line: .line54), .ok)
        XCTAssertEqual(exti.line, .line54)
        XCTAssertTrue(trace.accesses.isEmpty)
        trace.values[.pending(bank: 1)] = 0x0040_0000
        exti.irqHandler()
        XCTAssertEqual(trace.accesses, [.read(.pending(bank: 1)), .write(.pending(bank: 1), 0x0040_0000), .callback])
    }

    func testPendingReturnsNormalizedBitAndIgnoresEdgeLikeC() {
        let trace = EXTITrace()
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line54)
        trace.values[.pending(bank: 1)] = 0xFFFF_FFFF
        XCTAssertEqual(exti.getPending(edge: 0xFFFF_FFFF), 1)
        exti.clearPending(edge: 0)
        XCTAssertEqual(exti.getPending(), 0)
        XCTAssertEqual(trace.values[.pending(bank: 1)], 0xFFBF_FFFF)
        XCTAssertEqual(trace.accesses, [
            .read(.pending(bank: 1)), .write(.pending(bank: 1), 0x0040_0000), .read(.pending(bank: 1)),
        ])
    }

    func testSoftwareInterruptUsesDirectWriteWithoutReadModifyWrite() {
        let trace = EXTITrace()
        trace.values[.softwareInterrupt(bank: 1)] = 0xFFFF_FFFF
        var exti = EXTI(registers: EXTITraceIO(trace: trace), line: .line49)
        exti.generateSWI()
        XCTAssertEqual(trace.accesses, [.write(.softwareInterrupt(bank: 1), 0x0002_0000)])
    }

    func testBoundaryLineEncodingsMatchSTHeader() {
        XCTAssertEqual(EXTILine.line0.rawValue, 0x1600_0000)
        XCTAssertEqual(EXTILine.line15.rawValue, 0x1600_000F)
        XCTAssertEqual(EXTILine.line16.rawValue, 0x1200_0010)
        XCTAssertEqual(EXTILine.line21.rawValue, 0x1200_0015)
        XCTAssertEqual(EXTILine.line22.rawValue, 0x1100_0016)
        XCTAssertEqual(EXTILine.line31.rawValue, 0x1100_001F)
        XCTAssertEqual(EXTILine.line32.rawValue, 0x1101_0000)
        XCTAssertEqual(EXTILine.line34.rawValue, 0x1201_0002)
        XCTAssertEqual(EXTILine.line59.rawValue, 0x1101_001B)
        XCTAssertEqual(EXTILine.line77.rawValue, 0x1102_000D)
    }
}
