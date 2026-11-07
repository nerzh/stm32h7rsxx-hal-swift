import XCTest
@testable import STM32H7RSHAL

private enum ECCEvent: Equatable {
    case read(RAMECCRegister, UInt32), write(RAMECCRegister, UInt32)
    case stateRead(RAMECCHandleWord, UInt32), stateWrite(RAMECCHandleWord, UInt32)
    case callbackRead(RAMECCCallbackID, Bool), callbackWrite(RAMECCCallbackID, Bool), call(String)
}

private final class ECCIO: RAMECCRegisterIO, RAMECCStateIO, RAMECCCallbackIO {
    var registers: [RAMECCRegister: UInt32] = [:]
    var words: [RAMECCHandleWord: UInt32] = [.state: 1, .errorCode: 0x80]
    var slots: [RAMECCCallbackID: RAMECCCallback] = [:]
    var trace: [ECCEvent] = []
    var action: ((String, ECCIO) -> Void)?
    var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
    var core: RAMECC<ECCIO, ECCIO> { .init(registers: self, state: self) }
    var registered: RAMECCRegistered<ECCIO, ECCIO, ECCIO> {
        .init(core: core, callbacks: self, defaultMSPInitialize: Self.defaultMSP)
    }

    func read(_ register: RAMECCRegister) -> UInt32 {
        let value = registers[register, default: 0]
        trace.append(.read(register, value)); return value
    }
    func write(_ register: RAMECCRegister, value: UInt32) {
        trace.append(.write(register, value)); registers[register] = value
    }
    func read(_ word: RAMECCHandleWord) -> UInt32 {
        let value = words[word, default: 0]
        trace.append(.stateRead(word, value)); return value
    }
    func write(_ word: RAMECCHandleWord, value: UInt32) {
        trace.append(.stateWrite(word, value)); words[word] = value
    }
    func read(_ id: RAMECCCallbackID) -> RAMECCCallback? {
        trace.append(.callbackRead(id, slots[id] != nil)); return slots[id]
    }
    func write(_ id: RAMECCCallbackID, value: RAMECCCallback?) {
        trace.append(.callbackWrite(id, value != nil)); slots[id] = value
    }
    func call(_ name: String) { trace.append(.call(name)); action?(name, self) }
    static func object(_ context: UnsafeMutableRawPointer?) -> ECCIO {
        Unmanaged<ECCIO>.fromOpaque(context!).takeUnretainedValue()
    }
    static var defaultMSP: RAMECCCallback { { ECCIO.object($0).call("defaultMSP") } }
    static var mspInit: RAMECCCallback { { ECCIO.object($0).call("mspInit") } }
    static var mspDeinit: RAMECCCallback { { ECCIO.object($0).call("mspDeinit") } }
    static var single: RAMECCCallback { { ECCIO.object($0).call("single") } }
    static var double: RAMECCCallback { { ECCIO.object($0).call("double") } }

    func fillCallbacks() {
        slots = [.mspInitialize: Self.mspInit, .mspDeinitialize: Self.mspDeinit,
                 .singleError: Self.single, .doubleError: Self.double]
    }
}

final class RAMECCTests: XCTestCase {
    private var clearing: [ECCEvent] {
        [.read(.cr, 0xFFFFFFFF), .write(.cr, 0xFFFFFFDF), .read(.ier, 0xFFFFFFFF), .write(.ier, 0xFFFFFFF0),
         .read(.cr, 0xFFFFFFDF), .write(.cr, 0xFFFFFFC3), .read(.sr, 0xFFFFFFFF), .write(.sr, 0xFFFFFFF8)]
    }

    func testInitializeAlwaysMarksBusyBeforeMSPAndPreservesUnrelatedBits() {
        for initial: UInt32 in 0...3 {
            let io = ECCIO()
            io.words[.state] = initial
            io.registers = [.cr: UInt32.max, .ier: UInt32.max, .sr: UInt32.max]
            XCTAssertEqual(io.core.initialize { core in
                XCTAssertEqual(core.getState(), .busy)
                XCTAssertEqual(io.registers[.cr], UInt32.max)
                io.call("msp")
            }, .ok)
            XCTAssertEqual(io.trace, [.stateWrite(.state, 2), .stateRead(.state, 2), .call("msp")] + clearing +
                           [.stateWrite(.errorCode, 0), .stateWrite(.state, 1)])
        }
    }

    func testDeinitializeLeavesStateUntilMSPAfterAllHardwareClears() {
        for initial: UInt32 in 0...3 {
            let io = ECCIO(); io.words[.state] = initial
            io.registers = [.cr: UInt32.max, .ier: UInt32.max, .sr: UInt32.max]
            XCTAssertEqual(io.core.deinitialize { core in
                XCTAssertEqual(core.getState().rawValue, initial)
                XCTAssertEqual(core.getError().rawValue, 0x80)
                io.call("msp")
            }, .ok)
            XCTAssertEqual(io.trace, clearing + [.stateRead(.state, initial), .stateRead(.errorCode, 0x80), .call("msp"),
                                                .stateWrite(.errorCode, 0), .stateWrite(.state, 0)])
        }
    }

    func testMonitorStartStopEveryStateAndErrorAssignment() {
        for initial: UInt32 in 0...3 {
            for start in [false, true] {
                let io = ECCIO(); io.words[.state] = initial; io.registers[.cr] = 0xA5A5A5A5
                let status = start ? io.core.startMonitor() : io.core.stopMonitor()
                if initial == 1 {
                    XCTAssertEqual(status, .ok)
                    XCTAssertEqual(io.trace, [.stateRead(.state, 1), .stateWrite(.state, 2), .read(.cr, 0xA5A5A5A5),
                                              .write(.cr, start ? 0xA5A5A5A5 : 0xA5A5A585), .stateWrite(.state, 1)])
                    XCTAssertEqual(io.words[.errorCode], 0x80)
                } else {
                    XCTAssertEqual(status, .error)
                    XCTAssertEqual(io.trace, [.stateRead(.state, initial), .stateWrite(.errorCode, 2)])
                    XCTAssertEqual(io.words[.state], initial)
                }
            }
        }
    }

    func testEveryValidNotificationBothDirectionsEveryState() {
        for value in RAMECCInterrupt.allCases {
            for initial: UInt32 in 0...3 {
                for enable in [false, true] {
                    let io = ECCIO(); io.words[.state] = initial
                    io.registers = [.cr: 0xA5A5A5A5, .ier: 0xA5A5A5A5]
                    let status = enable ? io.core.enableNotification(value) : io.core.disableNotification(value)
                    if initial != 1 {
                        XCTAssertEqual(status, .error)
                        XCTAssertEqual(io.trace, [.stateRead(.state, initial), .stateWrite(.errorCode, 2)])
                    } else {
                        let global = value.rawValue & 0x10000000 != 0
                        let mask = value.rawValue & 0xFFFF
                        let changed: UInt32 = enable ? 0xA5A5A5A5 | mask : 0xA5A5A5A5 & ~mask
                        XCTAssertEqual(status, .ok)
                        XCTAssertEqual(io.trace, [.stateRead(.state, 1), .stateWrite(.state, 2),
                                                  .read(global ? .ier : .cr, 0xA5A5A5A5),
                                                  .write(global ? .ier : .cr, changed), .stateWrite(.state, 1)])
                        XCTAssertEqual(io.words[.errorCode], 0x80)
                    }
                }
            }
        }
    }

    func testIRQAllMonitorGlobalAndStatusCombinationsHaveExactReadClearCallbackOrder() {
        for monitor: UInt32 in 0..<8 {
            for global: UInt32 in 0..<16 {
                for flags: UInt32 in 0..<8 {
                    let io = ECCIO()
                    io.registers = [.cr: monitor << 2, .ier: global, .sr: flags | 0x80]
                    io.core.handleInterrupt(singleError: { _ in io.call("single") }, doubleError: { _ in io.call("double") })
                    var expected: [ECCEvent] = [.read(.cr, monitor << 2), .read(.ier, global)]
                    var remaining = flags | 0x80
                    func expectFlag(_ flag: UInt32, _ callback: String) {
                        expected.append(.read(.sr, remaining))
                        if remaining & flag != 0 {
                            expected.append(.read(.sr, remaining))
                            remaining &= ~flag
                            expected.append(.write(.sr, remaining)); expected.append(.call(callback))
                        }
                    }
                    if monitor & 1 != 0 || global & 3 != 0 { expectFlag(1, "single") }
                    if monitor & 6 != 0 || global & 0xD != 0 {
                        expectFlag(2, "double"); expectFlag(4, "double")
                    }
                    XCTAssertEqual(io.trace, expected, "monitor\(monitor) global\(global) flags\(flags)")
                    XCTAssertEqual(io.registers[.sr], remaining)
                    XCTAssertEqual(io.words, [.state: 1, .errorCode: 0x80])
                }
            }
        }
    }

    func testIRQCachesSourcesButReadsEachFlagAgainAfterCallbacks() {
        let io = ECCIO(); io.registers = [.cr: 0, .ier: 1, .sr: 1]
        var doubles = 0
        io.core.handleInterrupt(singleError: { _ in
            XCTAssertEqual(io.registers[.sr], 0)
            io.registers[.ier] = 0
            io.registers[.sr] = 6
            io.call("single")
        }, doubleError: { core in
            doubles += 1
            XCTAssertEqual(core.stopMonitor(), .ok)
            io.registers[.sr] = 0
            io.call("double")
        })
        XCTAssertEqual(doubles, 1)
        XCTAssertEqual(io.trace.filter { if case .read(.ier, _) = $0 { return true }; return false }, [.read(.ier, 1)])
        XCTAssertEqual(io.trace.suffix(2), [.call("double"), .read(.sr, 0)])
    }

    func testIRQReentryObservesAlreadyClearedSingleFlag() {
        let io = ECCIO(); io.registers = [.cr: 0, .ier: 1, .sr: 7]
        var calls: [String] = []
        io.core.handleInterrupt(singleError: { core in
            calls.append("single")
            core.handleInterrupt(singleError: { _ in XCTFail("Single flag must be clear before reentry") },
                                 doubleError: { _ in calls.append("nested double") })
        }, doubleError: { _ in calls.append("outer double") })
        XCTAssertEqual(calls, ["single", "nested double", "nested double"])
        XCTAssertEqual(io.registers[.sr], 0)
    }

    func testRawGettersFlagsAndResetUseOnlyTheirExactWords() {
        let io = ECCIO()
        io.registers = [.far: UInt32.max, .fdrl: 0x12345678, .fdrh: 0x87654321, .fecr: 0xABCDEF01]
        XCTAssertEqual(io.core.getFailingAddress(), UInt32.max)
        XCTAssertEqual(io.core.getFailingDataLow(), 0x12345678)
        XCTAssertEqual(io.core.getFailingDataHigh(), 0x87654321)
        XCTAssertEqual(io.core.getHammingErrorCode(), 0xABCDEF01)
        XCTAssertEqual(io.trace, [.read(.far, UInt32.max), .read(.fdrl, 0x12345678), .read(.fdrh, 0x87654321), .read(.fecr, 0xABCDEF01)])
        for flags: UInt32 in 0..<8 {
            io.registers[.sr] = flags | 0xF0000000
            XCTAssertEqual(io.core.isECCSingleErrorDetected(), flags & 1)
            XCTAssertEqual(io.core.isECCDoubleErrorDetected(), flags & 6 == 0 ? 0 : 1)
            XCTAssertEqual(io.core.getFlag(0), 0)
            XCTAssertEqual(io.core.getFlag(7), flags == 0 ? 0 : 1)
        }
        io.trace.removeAll()
        io.core.resetHandleState()
        XCTAssertEqual(io.trace, [.stateWrite(.state, 0)])
        XCTAssertEqual(io.words[.errorCode], 0x80)
    }

    func testRawMacroRoutingUsesExactGlobalValuesAndAnySetBit() {
        for value: UInt32 in [0x10000001, 0x10000002, 0x10000004, 0x10000008, 0x10000003, 0x30000001, 0, UInt32.max] {
            let io = ECCIO()
            let global = [UInt32(0x10000001), 0x10000002, 0x10000004, 0x10000008].contains(value)
            let register: RAMECCRegister = global ? .ier : .cr
            let mask = value & ~(global ? UInt32(0x10000000) : UInt32(0x20000000))
            io.core.enableInterrupts(value)
            XCTAssertEqual(io.trace, [.read(register, 0), .write(register, mask)])
            XCTAssertEqual(io.core.getInterruptSource(value), mask == 0 ? 0 : 1)
            io.core.disableInterrupts(value)
            XCTAssertEqual(io.registers[register], 0)
        }
        let io = ECCIO(); io.registers[.cr] = 4
        XCTAssertEqual(io.core.getMonitorInterruptSource(0x2000001C), 1)
        io.registers[.sr] = 0xA5A5A5A5; io.trace.removeAll()
        io.core.clearFlag(7)
        XCTAssertEqual(io.trace, [.read(.sr, 0xA5A5A5A5), .write(.sr, 0xA5A5A5A0)])
    }

    func testRegisteredInitializeFillsOnlyNilMSPAndCallsEveryTime() {
        let io = ECCIO(); io.fillCallbacks(); io.slots[.mspInitialize] = nil
        XCTAssertEqual(io.registered.initialize(), .ok)
        XCTAssertEqual(Array(io.trace.prefix(5)), [.stateWrite(.state, 2), .callbackRead(.mspInitialize, false),
                                                 .callbackWrite(.mspInitialize, true), .callbackRead(.mspInitialize, true), .call("defaultMSP")])
        XCTAssertNotNil(io.slots[.singleError]); XCTAssertNotNil(io.slots[.doubleError])
        io.trace.removeAll()
        XCTAssertEqual(io.registered.initialize(), .ok)
        XCTAssertEqual(Array(io.trace.prefix(4)), [.stateWrite(.state, 2), .callbackRead(.mspInitialize, true),
                                                 .callbackRead(.mspInitialize, true), .call("defaultMSP")])
    }

    func testRegisteredDeinitializeSkipsNilMSPAndClearsOnlyDetectionCallbacksAfterMSP() {
        for hasMSP in [false, true] {
            let io = ECCIO(); io.fillCallbacks()
            if !hasMSP { io.slots[.mspDeinitialize] = nil }
            io.action = { name, memory in
                XCTAssertEqual(name, "mspDeinit")
                XCTAssertNotNil(memory.slots[.singleError]); XCTAssertNotNil(memory.slots[.doubleError])
                XCTAssertEqual(memory.words[.state], 1)
            }
            XCTAssertEqual(io.registered.deinitialize(), .ok)
            let expected: [ECCEvent] = (hasMSP ? [.callbackRead(.mspDeinitialize, true), .callbackRead(.mspDeinitialize, true), .call("mspDeinit")] : [.callbackRead(.mspDeinitialize, false)]) +
                [.callbackWrite(.singleError, false), .callbackWrite(.doubleError, false), .stateWrite(.errorCode, 0), .stateWrite(.state, 0)]
            XCTAssertEqual(Array(io.trace.dropFirst(8)), expected)
            XCTAssertNotNil(io.slots[.mspInitialize]); XCTAssertEqual(io.slots[.mspDeinitialize] != nil, hasMSP)
        }
    }

    func testRegistrationEveryStateIDAndNilPreservesAsymmetricErrorRules() {
        for state: UInt32 in 0...3 {
            for id: UInt32 in [0, 1, 2, 3, 4, 5, UInt32.max] {
                for hasCallback in [false, true] {
                    let io = ECCIO(); io.words[.state] = state
                    let valid = hasCallback && (state == 1 && id < 4 || state == 0 && id < 2)
                    XCTAssertEqual(io.registered.registerCallback(id: id, callback: hasCallback ? ECCIO.single : nil), valid ? .ok : .error)
                    XCTAssertEqual(io.words[.errorCode], valid ? 0x80 : (!hasCallback || state <= 1 ? 0x83 : 3))
                    XCTAssertEqual(io.slots.count, valid ? 1 : 0)
                    if !hasCallback { XCTAssertEqual(io.trace, [.stateRead(.errorCode, 0x80), .stateWrite(.errorCode, 0x83)]) }
                    XCTAssertEqual(io.words[.state], state)
                }
            }
        }
    }

    func testUnregistrationEveryStateIDAndExactAllCallbackOrder() {
        for state: UInt32 in 0...3 {
            for id: UInt32 in [0, 1, 2, 3, 4, 5, UInt32.max] {
                let io = ECCIO(); io.fillCallbacks(); io.words[.state] = state
                let valid = state == 1 && id <= 4 || state == 0 && (id < 2 || id == 4)
                XCTAssertEqual(io.registered.unregisterCallback(id: id), valid ? .ok : .error)
                let expectedError: UInt32 = valid || state == 1 ? 0x80 : (state == 0 ? 0x83 : 3)
                XCTAssertEqual(io.words[.errorCode], expectedError)
                let clears = io.trace.compactMap { event -> RAMECCCallbackID? in
                    if case .callbackWrite(let id, false) = event { return id }; return nil
                }
                if valid {
                    XCTAssertEqual(clears, id == 4 ? (state == 1 ? [.singleError, .doubleError, .mspDeinitialize, .mspInitialize] : [.mspDeinitialize, .mspInitialize]) : [RAMECCCallbackID(rawValue: id)!])
                } else { XCTAssertEqual(clears, []) }
            }
        }
    }

    func testRegisteredIRQReadsSlotsAgainAndCallbackCanUnregisterNextError() {
        let io = ECCIO(); io.fillCallbacks(); io.registers = [.cr: 0, .ier: 1, .sr: 7]
        io.action = { name, memory in
            if name == "single" { XCTAssertEqual(memory.registered.unregisterCallback(id: .doubleError), .ok) }
        }
        io.registered.handleInterrupt()
        XCTAssertEqual(io.trace.filter { if case .call = $0 { return true }; return false }, [.call("single")])
        XCTAssertEqual(io.trace.filter { if case .callbackRead(.singleError, _) = $0 { return true }; return false },
                       [.callbackRead(.singleError, true), .callbackRead(.singleError, true)])
        XCTAssertEqual(io.trace.filter { if case .callbackRead(.doubleError, _) = $0 { return true }; return false },
                       [.callbackRead(.doubleError, false), .callbackRead(.doubleError, false)])
        XCTAssertEqual(io.registers[.sr], 0)
    }

    func testRegisteredResetMacroRetainsAllCallbacksAndError() {
        let io = ECCIO(); io.fillCallbacks()
        io.registered.resetHandleState()
        XCTAssertEqual(io.trace, [.stateWrite(.state, 0)])
        XCTAssertEqual(io.slots.count, 4)
        XCTAssertEqual(io.words[.errorCode], 0x80)
    }
}
