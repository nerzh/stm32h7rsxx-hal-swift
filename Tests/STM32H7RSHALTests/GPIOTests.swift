import CGPIOReference
import XCTest
@testable import STM32H7RSHAL

private enum GPIOAccess: Equatable {
    case read(GPIORegister, UInt32)
    case write(GPIORegister, UInt32)
    case callback(UInt16)
}

private final class GPIOTrace {
    var accesses: [GPIOAccess] = []
}

private struct GPIOTestRegisters: GPIORegisterIO {
    var values: [GPIORegister: UInt32] = [:]
    var scriptedReads: [GPIORegister: [UInt32]] = [:]
    var trace: GPIOTrace?

    mutating func read(_ register: GPIORegister) -> UInt32 {
        let value: UInt32
        if var pending = scriptedReads[register], !pending.isEmpty {
            value = pending.removeFirst()
            scriptedReads[register] = pending
        } else {
            value = values[register, default: 0]
        }
        trace?.accesses.append(.read(register, value))
        return value
    }

    mutating func write(_ register: GPIORegister, value: UInt32) {
        trace?.accesses.append(.write(register, value))
        values[register] = value
    }
}

final class GPIOTests: XCTestCase {
    private let registerPairs: [(GPIORegister, CGPIOReferenceRegister)] = [
        (.moder, CGPIOReference_MODER), (.otyper, CGPIOReference_OTYPER),
        (.ospeedr, CGPIOReference_OSPEEDR), (.pupdr, CGPIOReference_PUPDR),
        (.idr, CGPIOReference_IDR), (.odr, CGPIOReference_ODR),
        (.bsrr, CGPIOReference_BSRR), (.brr, CGPIOReference_BRR),
        (.lckr, CGPIOReference_LCKR),
        (.alternateFunction(index: 0), CGPIOReference_AFRL),
        (.alternateFunction(index: 1), CGPIOReference_AFRH),
        (.extiConfiguration(index: 0), CGPIOReference_EXTICR0),
        (.extiConfiguration(index: 1), CGPIOReference_EXTICR1),
        (.extiConfiguration(index: 2), CGPIOReference_EXTICR2),
        (.extiConfiguration(index: 3), CGPIOReference_EXTICR3),
        (.extiRisingTrigger, CGPIOReference_RTSR1),
        (.extiFallingTrigger, CGPIOReference_FTSR1),
        (.extiEventMask, CGPIOReference_EMR1),
        (.extiInterruptMask, CGPIOReference_IMR1),
        (.extiPending, CGPIOReference_PR1),
    ]

    private var pinMasks: [UInt16] {
        (0..<16).map { UInt16(1) << $0 } + [0x0180, 0x8001, 0xFFFF, 0xAAAA, 0x5555]
    }

    private func next(_ state: inout UInt32) -> UInt32 {
        state ^= state << 13
        state ^= state >> 17
        state ^= state << 5
        return state
    }

    private func initializedPair(port: GPIOPort, seed: inout UInt32)
        -> (GPIO<GPIOTestRegisters>, CGPIOReferenceState) {
        var reference = CGPIOReferenceState()
        CGPIOReference_Reset(&reference, port.rawValue)
        var io = GPIOTestRegisters()
        for (register, cRegister) in registerPairs {
            let value = next(&seed)
            io.values[register] = value
            CGPIOReference_Set(&reference, cRegister, value)
        }
        return (GPIO(registers: io, port: port), reference)
    }

    private func assertMatches(_ gpio: GPIO<GPIOTestRegisters>, _ reference: inout CGPIOReferenceState,
                               context: @autoclosure () -> String,
                               file: StaticString = #filePath, line: UInt = #line) {
        for (register, cRegister) in registerPairs {
            let actual = gpio.registers.values[register, default: 0]
            let expected = CGPIOReference_Get(&reference, cRegister)
            if actual != expected {
                XCTFail("\(context()): \(register): \(actual) != C \(expected)", file: file, line: line)
                return
            }
        }
    }

    func testInitializationMatchesUnmodifiedCForAllModesPortsAndPinBoundaries() {
        var seed: UInt32 = 0xC001D00D
        var configurations = 0
        for port in GPIOPort.allCases {
            for mode in GPIOMode.allCases {
                for pins in pinMasks {
                    for pull in GPIOPull.allCases {
                        var (gpio, reference) = initializedPair(port: port, seed: &seed)
                        let speed = GPIOSpeed.allCases[configurations & 3]
                        let alternate = UInt32(configurations & 15)
                        let configuration = GPIOConfiguration(pins: pins, mode: mode, pull: pull,
                                                              speed: speed, alternate: alternate)
                        gpio.initialize(configuration)
                        CGPIOReference_Init(&reference, UInt32(pins), mode.rawValue, pull.rawValue,
                                            speed.rawValue, alternate)
                        assertMatches(gpio, &reference,
                                      context: "init port=\(port) mode=\(mode) pins=\(pins) pull=\(pull)")
                        configurations += 1
                    }
                }
            }
        }
        XCTAssertEqual(configurations, 12 * 12 * 21 * 3)
    }

    func testDeinitializationMatchesCForOwnForeignAndMixedRoutes() {
        var seed: UInt32 = 0xD31A17
        for port in GPIOPort.allCases {
            for pins in pinMasks {
                for routeKind in 0..<3 {
                    var (gpio, reference) = initializedPair(port: port, seed: &seed)
                    for index in 0..<4 {
                        let foreign = (port.rawValue + 1) & 15
                        let route = routeKind == 0 ? port.rawValue : foreign
                        var value: UInt32 = 0
                        for field in 0..<4 {
                            let selected = routeKind == 2 && field & 1 == 0 ? port.rawValue : route
                            value |= selected << (field * 4)
                        }
                        let register = GPIORegister.extiConfiguration(index: index)
                        gpio.registers.values[register] = value
                        CGPIOReference_Set(&reference, registerPairs[11 + index].1, value)
                    }
                    gpio.deinitialize(pins: pins)
                    CGPIOReference_DeInit(&reference, UInt32(pins))
                    assertMatches(gpio, &reference,
                                  context: "deinit port=\(port) pins=\(pins) routes=\(routeKind)")
                }
            }
        }
    }

    func testIOOperationsMatchC() {
        var seed: UInt32 = 0x1A2B3C4D
        for port in GPIOPort.allCases {
            for pins in pinMasks {
                var (gpio, reference) = initializedPair(port: port, seed: &seed)
                XCTAssertEqual(gpio.readPin(pins).rawValue, CGPIOReference_ReadPin(&reference, pins))
                for state in [GPIOPinState.reset, .set] {
                    gpio.writePin(pins, state: state)
                    CGPIOReference_WritePin(&reference, pins, state.rawValue)
                    assertMatches(gpio, &reference, context: "write \(pins) \(state)")
                }
                gpio.togglePin(pins)
                CGPIOReference_TogglePin(&reference, pins)
                assertMatches(gpio, &reference, context: "toggle \(pins)")

                let reset = pins & 0xAAAA
                let set = pins & 0x5555
                gpio.writeMultipleStatePin(reset: reset, set: set)
                CGPIOReference_WriteMultipleStatePin(&reference, reset, set)
                assertMatches(gpio, &reference, context: "multiple \(pins)")

                XCTAssertEqual(gpio.lockPin(pins).rawValue, CGPIOReference_LockPin(&reference, pins))
                assertMatches(gpio, &reference, context: "lock \(pins)")

                var callbackPins: UInt16 = 0
                var callbackCount: UInt32 = 0
                gpio.extiIRQHandler(pins) { callbackPins = $0; callbackCount += 1 }
                CGPIOReference_IRQHandler(&reference, pins)
                XCTAssertEqual(callbackCount, CGPIOReference_CallbackCount(&reference))
                XCTAssertEqual(UInt32(callbackPins), CGPIOReference_CallbackPins(&reference))
                assertMatches(gpio, &reference, context: "irq \(pins)")
            }
        }
    }

    func testDirectWritesNeverReadBSRRBRROrPendingRegister() {
        let trace = GPIOTrace()
        var gpio = GPIO(registers: GPIOTestRegisters(trace: trace), port: .a)
        gpio.writePin(0x8001, state: .set)
        gpio.writePin(0x8001, state: .reset)
        gpio.writeMultipleStatePin(reset: 0x8000, set: 0x0001)
        gpio.extiClearFlag(0x0080)
        gpio.extiGenerateSoftwareInterrupt(0x0100)
        XCTAssertEqual(trace.accesses, [
            .write(.bsrr, 0x8001), .write(.brr, 0x8001),
            .write(.bsrr, 0x80000001), .write(.extiPending, 0x0080),
            .write(.extiSoftwareInterrupt, 0x0100),
        ])
    }

    func testToggleReadsODROnceThenWritesBSRR() {
        let trace = GPIOTrace()
        let io = GPIOTestRegisters(values: [.odr: 0x8001], trace: trace)
        var gpio = GPIO(registers: io, port: .b)
        gpio.togglePin(0x8103)
        XCTAssertEqual(trace.accesses, [.read(.odr, 0x8001), .write(.bsrr, 0x80010102)])
    }

    func testLockRequiresThreeWritesAndTwoReadsAndUsesSecondRead() {
        for confirmed in [false, true] {
            let trace = GPIOTrace()
            // The first read deliberately contradicts the second one.
            let first: UInt32 = confirmed ? 0 : 0x10000
            let second: UInt32 = confirmed ? 0x10000 : 0
            let io = GPIOTestRegisters(scriptedReads: [.lckr: [first, second]], trace: trace)
            var gpio = GPIO(registers: io, port: .c)
            XCTAssertEqual(gpio.lockPin(0x8001), confirmed ? .ok : .error)
            XCTAssertEqual(trace.accesses, [
                .write(.lckr, 0x18001), .write(.lckr, 0x8001), .write(.lckr, 0x18001),
                .read(.lckr, first), .read(.lckr, second),
            ])
        }
    }

    func testIRQClearsEntireRequestedMaskBeforeCallback() {
        let trace = GPIOTrace()
        let io = GPIOTestRegisters(values: [.extiPending: 0x8001], trace: trace)
        var gpio = GPIO(registers: io, port: .a)
        gpio.extiIRQHandler(0x0003) { trace.accesses.append(.callback($0)) }
        XCTAssertEqual(trace.accesses, [
            .read(.extiPending, 0x8001), .write(.extiPending, 0x0003), .callback(0x0003),
        ])

        trace.accesses = []
        gpio.registers.values[.extiPending] = 0x8000
        gpio.extiIRQHandler(0x0003) { trace.accesses.append(.callback($0)) }
        XCTAssertEqual(trace.accesses, [.read(.extiPending, 0x8000)])
    }

    func testAlternateConfigurationAccessOrder() {
        let trace = GPIOTrace()
        var gpio = GPIO(registers: GPIOTestRegisters(trace: trace), port: .b)
        gpio.initialize(.init(pins: 0x0100, mode: .alternateOpenDrain, pull: .down,
                              speed: .veryHigh, alternate: 11))
        XCTAssertEqual(trace.accesses, [
            .read(.ospeedr, 0), .write(.ospeedr, 0x00030000),
            .read(.otyper, 0), .write(.otyper, 0x00000100),
            .read(.pupdr, 0), .write(.pupdr, 0x00020000),
            .read(.alternateFunction(index: 1), 0), .write(.alternateFunction(index: 1), 11),
            .read(.moder, 0), .write(.moder, 0x00020000),
        ])
    }

    func testInterruptConfigurationAccessOrderAndNonContiguousPortIndex() {
        let trace = GPIOTrace()
        var gpio = GPIO(registers: GPIOTestRegisters(trace: trace), port: .m)
        gpio.initialize(.init(pins: 0x0020, mode: .interruptRisingFalling, pull: .up))
        XCTAssertEqual(trace.accesses, [
            .read(.pupdr, 0), .write(.pupdr, 0x400),
            .read(.moder, 0), .write(.moder, 0),
            .read(.extiConfiguration(index: 1), 0), .write(.extiConfiguration(index: 1), 0xC0),
            .read(.extiRisingTrigger, 0), .write(.extiRisingTrigger, 0x20),
            .read(.extiFallingTrigger, 0), .write(.extiFallingTrigger, 0x20),
            .read(.extiEventMask, 0), .write(.extiEventMask, 0),
            .read(.extiInterruptMask, 0), .write(.extiInterruptMask, 0x20),
        ])
    }

    func testAnalogPullUpDoesNotAccessPUPDR() {
        let trace = GPIOTrace()
        var gpio = GPIO(registers: GPIOTestRegisters(values: [.pupdr: 0xAAAAAAAA], trace: trace), port: .a)
        gpio.initialize(.init(pins: 0x8000, mode: .analog, pull: .up))
        XCTAssertEqual(trace.accesses, [.read(.moder, 0), .write(.moder, 0xC0000000)])
        XCTAssertEqual(gpio.registers.values[.pupdr], 0xAAAAAAAA)
    }

    func testDeinitializationClearsOwnRouteInCOrder() {
        let trace = GPIOTrace()
        let io = GPIOTestRegisters(values: [
            .extiConfiguration(index: 0): 0x10,
            .extiInterruptMask: 0xFFFF, .extiEventMask: 0xFFFF,
            .extiFallingTrigger: 0xFFFF, .extiRisingTrigger: 0xFFFF,
            .alternateFunction(index: 0): 0xFFFFFFFF,
            .ospeedr: 0xFFFFFFFF, .otyper: 0xFFFF, .pupdr: 0xFFFFFFFF,
        ], trace: trace)
        var gpio = GPIO(registers: io, port: .b)
        gpio.deinitialize(pins: 0x0002)
        XCTAssertEqual(trace.accesses, [
            .read(.extiConfiguration(index: 0), 0x10),
            .read(.extiInterruptMask, 0xFFFF), .write(.extiInterruptMask, 0xFFFD),
            .read(.extiEventMask, 0xFFFF), .write(.extiEventMask, 0xFFFD),
            .read(.extiFallingTrigger, 0xFFFF), .write(.extiFallingTrigger, 0xFFFD),
            .read(.extiRisingTrigger, 0xFFFF), .write(.extiRisingTrigger, 0xFFFD),
            .read(.extiConfiguration(index: 0), 0x10), .write(.extiConfiguration(index: 0), 0),
            .read(.moder, 0), .write(.moder, 0xC),
            .read(.alternateFunction(index: 0), 0xFFFFFFFF),
            .write(.alternateFunction(index: 0), 0xFFFFFF0F),
            .read(.ospeedr, 0xFFFFFFFF), .write(.ospeedr, 0xFFFFFFF3),
            .read(.otyper, 0xFFFF), .write(.otyper, 0xFFFD),
            .read(.pupdr, 0xFFFFFFFF), .write(.pupdr, 0xFFFFFFF3),
        ])
    }

    func testInitializationProcessesSelectedPinsInAscendingOrder() {
        let trace = GPIOTrace()
        var gpio = GPIO(registers: GPIOTestRegisters(trace: trace), port: .a)
        gpio.initialize(.init(pins: 0x8001, mode: .analog, pull: .up))
        XCTAssertEqual(trace.accesses, [
            .read(.moder, 0), .write(.moder, 3),
            .read(.moder, 3), .write(.moder, 0xC0000003),
        ])
    }

    func testReadPinUsesAnySelectedBitAndFlagReadReturnsMask() {
        let trace = GPIOTrace()
        let io = GPIOTestRegisters(values: [.idr: 0x8000, .extiPending: 0x8001], trace: trace)
        var gpio = GPIO(registers: io, port: .p)
        XCTAssertEqual(gpio.readPin(0x8001), .set)
        XCTAssertEqual(gpio.readPin(0x0001), .reset)
        XCTAssertEqual(gpio.extiGetFlag(0x8002), 0x8000)
        XCTAssertEqual(trace.accesses, [
            .read(.idr, 0x8000), .read(.idr, 0x8000), .read(.extiPending, 0x8001),
        ])
    }
}
