import XCTest
import CRNGReference
@testable import STM32H7RSHAL

// C supplies only register stimuli, raw handle/slot storage and observations on
// this side. Every driver call and callback action below executes Swift HAL.
private final class RNGDifferentialIO: RNGRegisterIO, RNGStateIO, RNGCallbackIO {
    var storage = CRNGReferenceState()
    var context: UnsafeMutableRawPointer?
    var bypassIRQSnapshot = false
    var bypassConfigurationReads = false
    var core: RNG<RNGDifferentialIO, RNGDifferentialIO> { .init(registers: self, state: self) }
    var registered: RNGRegistered<RNGDifferentialIO, RNGDifferentialIO, RNGDifferentialIO> {
        .init(core: core, callbacks: self, defaults: .init(
            error: Self.callback(0, 1)!, mspInitialize: Self.callback(1, 1)!,
            mspDeinitialize: Self.callback(2, 1)!, readyData: Self.readyCallback(1)!))
    }

    static func register(_ register: RNGRegister) -> CRNGReferenceRegister {
        switch register {
        case .cr: return CRNGReference_CR
        case .sr: return CRNGReference_SR
        case .dr: return CRNGReference_DR
        case .htcr: return CRNGReference_HTCR
        }
    }
    func read(_ register: RNGRegister) -> UInt32 {
        // The unchanged C IRQ snapshot and GetConfig use direct field reads,
        // outside the oracle's macro hooks. Match that instrumentation boundary;
        // RNGTests independently checks the complete Swift MMIO read sequence.
        if bypassConfigurationReads { return CRNGReference_Get(&storage, Self.register(register)) }
        if bypassIRQSnapshot && register == .sr {
            bypassIRQSnapshot = false
            return CRNGReference_Get(&storage, CRNGReference_SR)
        }
        return CRNGReference_Read(&storage, Self.register(register))
    }
    func write(_ register: RNGRegister, value: UInt32) { CRNGReference_Write(&storage, Self.register(register), value) }
    func read(_ word: RNGHandleWord) -> UInt32 {
        CRNGReference_GetHandle(&storage, CRNGReferenceHandleWord(rawValue: UInt32(word.rawValue)))
    }
    func write(_ word: RNGHandleWord, value: UInt32) {
        CRNGReference_SetHandle(&storage, CRNGReferenceHandleWord(rawValue: UInt32(word.rawValue)), value)
    }
    func getTick() -> UInt32 { CRNGReference_Tick(&storage) }

    static func object(_ context: UnsafeMutableRawPointer?) -> RNGDifferentialIO {
        Unmanaged<RNGDifferentialIO>.fromOpaque(context!).takeUnretainedValue()
    }
    static func callback(_ id: UInt32, _ selector: UInt32) -> RNGCallback? {
        if selector == 0 { return nil }
        switch (id, selector) {
        case (1, 1): return { RNGDifferentialIO.object($0).record(1, 1) }
        case (1, 2): return { RNGDifferentialIO.object($0).record(1, 2) }
        case (1, 3): return { RNGDifferentialIO.object($0).record(1, 3) }
        case (2, 1): return { RNGDifferentialIO.object($0).record(2, 1) }
        case (2, 2): return { RNGDifferentialIO.object($0).record(2, 2) }
        case (2, 3): return { RNGDifferentialIO.object($0).record(2, 3) }
        case (_, 1): return { RNGDifferentialIO.object($0).record(0, 1) }
        case (_, 2): return { RNGDifferentialIO.object($0).record(0, 2) }
        default: return { RNGDifferentialIO.object($0).record(0, 3) }
        }
    }
    static func readyCallback(_ selector: UInt32) -> RNGReadyDataCallback? {
        switch selector {
        case 0: return nil
        case 1: return { RNGDifferentialIO.object($0).record(3, 1, $1) }
        case 2: return { RNGDifferentialIO.object($0).record(3, 2, $1) }
        default: return { RNGDifferentialIO.object($0).record(3, 3, $1) }
        }
    }
    func read(_ id: RNGCallbackID) -> RNGCallback? {
        Self.callback(id.rawValue, CRNGReference_GetCallback(&storage, id.rawValue))
    }
    func write(_ id: RNGCallbackID, value: RNGCallback?) {
        guard let value else { CRNGReference_SetCallback(&storage, id.rawValue, 0); return }
        let bits = unsafeBitCast(value, to: UInt.self)
        let selector = (UInt32(1)...3).first { unsafeBitCast(Self.callback(id.rawValue, $0)!, to: UInt.self) == bits }!
        CRNGReference_SetCallback(&storage, id.rawValue, selector)
    }
    func readReadyDataCallback() -> RNGReadyDataCallback? { Self.readyCallback(CRNGReference_GetCallback(&storage, 3)) }
    func writeReadyDataCallback(_ value: RNGReadyDataCallback?) {
        guard let value else { CRNGReference_SetCallback(&storage, 3, 0); return }
        let bits = unsafeBitCast(value, to: UInt.self)
        let selector = (UInt32(1)...3).first { unsafeBitCast(Self.readyCallback($0)!, to: UInt.self) == bits }!
        CRNGReference_SetCallback(&storage, 3, selector)
    }
    func record(_ id: UInt32, _ implementation: UInt32, _ argument: UInt32 = 0) {
        let index = CRNGReference_RecordCallback(&storage, id, implementation, argument)
        if CRNGReference_GetCallbackAction(&storage, id) == 1 {
            let status = generateInterrupt()
            CRNGReference_SetCallbackActionStatus(&storage, index, status.rawValue)
        }
    }
    func initialize() -> HALStatus {
        storage.registeredCallbacks != 0 ? registered.initialize(getTick: getTick) :
            core.initialize(getTick: getTick, mspInitialize: { _ in self.record(1, 1) })
    }
    func deinitialize() -> HALStatus {
        storage.registeredCallbacks != 0 ? registered.deinitialize(getTick: getTick) :
            core.deinitialize(getTick: getTick, mspDeinitialize: { _ in self.record(2, 1) })
    }
    func generate(_ output: inout UInt32) -> HALStatus {
        storage.registeredCallbacks != 0 ? registered.generateRandomNumber(&output, getTick: getTick) :
            core.generateRandomNumber(&output, getTick: getTick, errorCallback: { _ in self.record(0, 1) })
    }
    func generateInterrupt() -> HALStatus {
        storage.registeredCallbacks != 0 ? registered.generateRandomNumberInterrupt() : core.generateRandomNumberInterrupt()
    }
    func interrupt() {
        bypassIRQSnapshot = true
        if storage.registeredCallbacks != 0 { registered.handleInterrupt() }
        else { core.handleInterrupt(readyDataCallback: { _, value in self.record(3, 1, value) },
                                   errorCallback: { _ in self.record(0, 1) }) }
        precondition(!bypassIRQSnapshot)
    }
    func recover(extended: Bool) -> HALStatus {
        if extended {
            return storage.registeredCallbacks != 0 ? registered.recoverSeedError() :
                core.recoverSeedError(errorCallback: { _ in self.record(0, 1) })
        }
        return core.recoverSeedErrorInternal { _ in
            if self.storage.registeredCallbacks != 0 { self.read(.error)!(self.context) }
            else { self.record(0, 1) }
        }
    }
}

final class RNGDifferentialTests: XCTestCase {
    private func withPair(_ variant: UInt32, setup: (inout CRNGReferenceState) -> Void = { _ in },
                          file: StaticString = #filePath, line: UInt = #line,
                          body: (RNGDifferentialIO, RNGDifferentialIO) -> Void) {
        let actual = RNGDifferentialIO()
        CRNGReference_Reset(&actual.storage, variant)
        for id in UInt32(0)...3 { CRNGReference_SetCallback(&actual.storage, id, 1) }
        setup(&actual.storage)
        let reference = RNGDifferentialIO()
        reference.storage = actual.storage
        // Retain only for the synchronous test-pair scope. No production driver
        // stores an ARC-managed closure or object.
        let retained = Unmanaged.passRetained(actual)
        actual.context = retained.toOpaque()
        defer { retained.release() }
        body(actual, reference)
        assertMatches(actual, reference, file: file, line: line)
    }

    private func assertMatches(_ actual: RNGDifferentialIO, _ reference: RNGDifferentialIO,
                               file: StaticString = #filePath, line: UInt = #line) {
        for index in UInt32(0)..<4 {
            let register = CRNGReferenceRegister(rawValue: index)
            XCTAssertEqual(CRNGReference_Get(&actual.storage, register), CRNGReference_Get(&reference.storage, register),
                           "register \(index)", file: file, line: line)
            // These are macro-mediated/model reads, not a complete MMIO trace.
            XCTAssertEqual(CRNGReference_ReadCount(&actual.storage, register), CRNGReference_ReadCount(&reference.storage, register),
                           "instrumented register \(index)", file: file, line: line)
            XCTAssertEqual(CRNGReference_GetCallback(&actual.storage, index), CRNGReference_GetCallback(&reference.storage, index),
                           "callback slot \(index)", file: file, line: line)
        }
        for index in UInt32(0)..<5 {
            let word = CRNGReferenceHandleWord(rawValue: index)
            XCTAssertEqual(CRNGReference_GetHandle(&actual.storage, word), CRNGReference_GetHandle(&reference.storage, word),
                           "handle word \(index)", file: file, line: line)
        }
        XCTAssertEqual([actual.storage.tick, actual.storage.tickCalls, actual.storage.dataIndex],
                       [reference.storage.tick, reference.storage.tickCalls, reference.storage.dataIndex], file: file, line: line)
        XCTAssertEqual(actual.storage.writeCount, reference.storage.writeCount, file: file, line: line)
        for index in UInt32(0)..<min(actual.storage.writeCount, reference.storage.writeCount) {
            let a = CRNGReference_GetWrite(&actual.storage, index), e = CRNGReference_GetWrite(&reference.storage, index)
            XCTAssertEqual([a.reg.rawValue, a.value, a.tickCall], [e.reg.rawValue, e.value, e.tickCall],
                           "write \(index)", file: file, line: line)
        }
        XCTAssertEqual(actual.storage.callbackCount, reference.storage.callbackCount, file: file, line: line)
        for index in UInt32(0)..<min(actual.storage.callbackCount, reference.storage.callbackCount) {
            let a = CRNGReference_GetCallbackEvent(&actual.storage, index)
            let e = CRNGReference_GetCallbackEvent(&reference.storage, index)
            XCTAssertEqual([a.callbackID, a.implementation, a.argument, a.lock, a.state, a.errorCode, a.randomNumber,
                            a.cr, a.sr, a.tickCalls, a.writeCount, a.dataReads, a.actionStatus],
                           [e.callbackID, e.implementation, e.argument, e.lock, e.state, e.errorCode, e.randomNumber,
                            e.cr, e.sr, e.tickCalls, e.writeCount, e.dataReads, e.actionStatus],
                           "callback \(index)", file: file, line: line)
        }
    }

    private func cConfiguration(_ value: RNGConfiguration) -> RNG_ConfigTypeDef {
        var result = RNG_ConfigTypeDef()
        result.Config1 = value.config1; result.Config2 = value.config2; result.Config3 = value.config3
        result.ClockDivider = value.clockDivider; result.NistCompliance = value.nistCompliance
        result.AutoReset = value.autoReset; result.HealthTest = value.healthTest
        return result
    }
    private func swiftConfiguration(_ value: RNG_ConfigTypeDef) -> RNGConfiguration {
        .init(config1: value.Config1, config2: value.Config2, config3: value.Config3,
              clockDivider: value.ClockDivider, nistCompliance: value.NistCompliance,
              autoReset: value.AutoReset, healthTest: value.HealthTest)
    }

    func testInitializeEveryStateLockDetectionAndCallbackPresetMatchesC() {
        for variant in UInt32(0)...1 {
            for state in UInt32(0)...4 {
                for lock in UInt32(0)...1 {
                    for detection in [UInt32(0), 0x20] {
                        for preset in UInt32(0)...3 {
                            withPair(variant, setup: {
                                CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                                CRNGReference_SetHandle(&$0, CRNGReference_Lock, lock)
                                CRNGReference_SetHandle(&$0, CRNGReference_ClockErrorDetection, detection)
                                CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0xA5)
                                CRNGReference_Set(&$0, CRNGReference_CR, 0xA155_A5AC)
                                for id in UInt32(0)...3 { CRNGReference_SetCallback(&$0, id, preset) }
                            }) { actual, reference in
                                XCTAssertEqual(actual.initialize().rawValue, CRNGReference_Initialize(&reference.storage))
                                XCTAssertEqual(actual.core.getState(), .ready)
                            }
                        }
                    }
                }
            }
        }
    }

    func testDeinitializeEveryStateLockAndMSPCallbackMatchesC() {
        for variant in UInt32(0)...1 {
            for state in UInt32(0)...4 {
                for lock in UInt32(0)...1 {
                    for selector in UInt32(0)...3 {
                        withPair(variant, setup: {
                            CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                            CRNGReference_SetHandle(&$0, CRNGReference_Lock, lock)
                            CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0xA5)
                            CRNGReference_Set(&$0, CRNGReference_CR, 0xA155_A5AC)
                            CRNGReference_Set(&$0, CRNGReference_SR, 0x67)
                            CRNGReference_SetCallback(&$0, 2, selector)
                        }) { actual, reference in
                            XCTAssertEqual(actual.deinitialize().rawValue, CRNGReference_Deinitialize(&reference.storage))
                            XCTAssertEqual(actual.core.getState(), .reset)
                        }
                    }
                }
            }
        }
    }

    func testAllStatusBitsStatesAndLocksForPollingInterruptStartAndIRQMatchC() {
        for variant in UInt32(0)...1 {
            for flags in UInt32(0)...127 {
                for state in UInt32(0)...4 {
                    for lock in UInt32(0)...1 {
                        for operation in 0..<3 {
                            withPair(variant, setup: {
                                $0.tickStep = 11
                                CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                                CRNGReference_SetHandle(&$0, CRNGReference_Lock, lock)
                                CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x8000_0010)
                                CRNGReference_SetHandle(&$0, CRNGReference_RandomNumber, 0xCAFE_BABE)
                                CRNGReference_Set(&$0, CRNGReference_CR, 0x24)
                                CRNGReference_Set(&$0, CRNGReference_SR, flags | 0x8000_0000)
                                CRNGReference_PushData(&$0, 0x1234_5678)
                            }) { actual, reference in
                                switch operation {
                                case 0:
                                    var a: UInt32 = 0xDEAD_BEEF, e: UInt32 = a
                                    let status = actual.generate(&a)
                                    XCTAssertEqual(status.rawValue, CRNGReference_Generate(&reference.storage, &e))
                                    XCTAssertEqual(a, e)
                                    if status != .ok { XCTAssertEqual(a, 0xDEAD_BEEF) }
                                case 1:
                                    XCTAssertEqual(actual.generateInterrupt().rawValue, CRNGReference_GenerateInterrupt(&reference.storage))
                                default:
                                    actual.interrupt(); CRNGReference_HandleInterrupt(&reference.storage)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func testSeedErrorAfterDataReadPreservesOutputAndStoresLastRead() {
        for variant in UInt32(0)...1 {
            withPair(variant, setup: {
                CRNGReference_SetHandle(&$0, CRNGReference_State, 1)
                CRNGReference_Set(&$0, CRNGReference_SR, 1)
                CRNGReference_PushData(&$0, 0x89AB_CDEF)
                CRNGReference_Schedule(&$0, CRNGReference_OnDRRead, 1, CRNGReference_SR, 0, 0x40)
            }) { actual, reference in
                var a: UInt32 = 0x12345678, e = a
                XCTAssertEqual(actual.generate(&a), .error)
                XCTAssertEqual(CRNGReference_Generate(&reference.storage, &e), HALStatus.error.rawValue)
                XCTAssertEqual(a, e); XCTAssertEqual(a, 0x12345678)
                XCTAssertEqual(actual.core.readLastRandomNumber(), 0x89AB_CDEF)
            }
        }
    }

    func testInitializationSeedFailureKeepsErrorAndDoesNotStartSecondTimeout() {
        for variant in UInt32(0)...1 {
            withPair(variant, setup: {
                CRNGReference_Set(&$0, CRNGReference_SR, 0x40)
                CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x8000_0010)
            }) { actual, reference in
                XCTAssertEqual(actual.initialize(), .error)
                XCTAssertEqual(CRNGReference_Initialize(&reference.storage), HALStatus.error.rawValue)
                XCTAssertEqual(actual.core.getState(), .error)
                XCTAssertEqual(actual.core.getError().rawValue, 0x8000_0010)
                XCTAssertEqual(actual.storage.tickCalls, 1)
            }
        }
    }

    func testConditioningTimeoutStrictBoundaryRecheckAndWrapForInitDeinitAndConfig() {
        for variant in UInt32(0)...1 {
            for operation in 0..<3 {
                for start in [UInt32(0), UInt32.max - 5] {
                    // Three CR reads precede conditioning wait (Disable/RMW/Clear)
                    // for Init/SetConfig; DeInit has only its two RMW reads.
                    let initialReads: UInt32 = operation == 1 ? 2 : 3
                    let timeout: UInt32 = operation == 2 ? 2 : 10
                    for completion in [timeout + 1, timeout + 2, timeout + 3, timeout + 4] {
                        withPair(variant, setup: {
                            $0.tick = start
                            $0.automaticTransitions = UInt32(CRNGReference_AutoDataReady.rawValue)
                            CRNGReference_SetHandle(&$0, CRNGReference_State, 1)
                            CRNGReference_SetHandle(&$0, CRNGReference_Lock, 1)
                            CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x80)
                            CRNGReference_Schedule(&$0, CRNGReference_OnCRRead, initialReads + completion,
                                                   CRNGReference_CR, 0x4000_0000, 0)
                        }) { actual, reference in
                            let status: HALStatus, expected: UInt32
                            if operation == 0 {
                                status = actual.initialize(); expected = CRNGReference_Initialize(&reference.storage)
                            } else if operation == 1 {
                                status = actual.deinitialize(); expected = CRNGReference_Deinitialize(&reference.storage)
                            } else {
                                let configuration = RNGConfiguration(config1: 17, config2: 3, config3: 9, healthTest: 0xAA55)
                                var c = cConfiguration(configuration)
                                status = actual.core.setConfig(configuration, getTick: actual.getTick)
                                expected = CRNGReference_SetConfig(&reference.storage, &c)
                            }
                            XCTAssertEqual(status.rawValue, expected)
                            // The additional read after elapsed > timeout may
                            // observe completion and must still return success.
                            XCTAssertEqual(status, completion <= timeout + 2 ? .ok : .error)
                        }
                    }
                }
            }
        }
    }

    func testDataReadyTimeoutRecheckForInitAndPollingAcrossWrap() {
        for variant in UInt32(0)...1 {
            for initializes in [false, true] {
                for start in [UInt32(4), UInt32.max - 5] {
                    for completion in [UInt32(11), 12, 13, 14] {
                        withPair(variant, setup: {
                            $0.tick = start
                            $0.automaticTransitions &= ~UInt32(CRNGReference_AutoDataReady.rawValue)
                            CRNGReference_SetHandle(&$0, CRNGReference_State, 1)
                            CRNGReference_PushData(&$0, 0xFEED_0102)
                            // The SEIS test is the first instrumented SR read.
                            CRNGReference_Schedule(&$0, CRNGReference_OnSRRead, 1 + completion,
                                                   CRNGReference_SR, 0, 1)
                        }) { actual, reference in
                            let status: HALStatus
                            if initializes {
                                status = actual.initialize()
                                XCTAssertEqual(status.rawValue, CRNGReference_Initialize(&reference.storage))
                            } else {
                                var a: UInt32 = 0xA5A5_5A5A, e = a
                                status = actual.generate(&a)
                                XCTAssertEqual(status.rawValue, CRNGReference_Generate(&reference.storage, &e))
                                XCTAssertEqual(a, e)
                                if status != .ok { XCTAssertEqual(a, 0xA5A5_5A5A) }
                            }
                            XCTAssertEqual(status, completion <= 12 ? .ok : .error)
                        }
                    }
                }
            }
        }
    }

    func testTickTriggeredCompletionAtStrictDeadlineAndNonUnitTickSteps() {
        for variant in UInt32(0)...1 {
            for step in [UInt32(1), 2, 10, 11] {
                for due in [UInt32(1), 2, 3, 11, 12, 13] {
                    withPair(variant, setup: {
                        $0.tick = UInt32.max - 2; $0.tickStep = step
                        CRNGReference_SetHandle(&$0, CRNGReference_State, 1)
                        CRNGReference_PushData(&$0, 0xC001_D00D)
                        CRNGReference_Schedule(&$0, CRNGReference_OnTick, due, CRNGReference_SR, 0, 1)
                    }) { actual, reference in
                        var a: UInt32 = 0x12345678, e = a
                        XCTAssertEqual(actual.generate(&a).rawValue, CRNGReference_Generate(&reference.storage, &e))
                        XCTAssertEqual(a, e)
                    }
                }
            }
        }
    }

    func testRecoveryNineReadBoundaryBothLoopsAndEveryStateLockMatchesC() {
        for variant in UInt32(0)...1 {
            for extended in [false, true] {
                for state in UInt32(0)...4 {
                    for lock in UInt32(0)...1 {
                        for loop in 0..<2 {
                            for completion in [UInt32(0), 1, 8, 9, 10] {
                                withPair(variant, setup: {
                                    $0.automaticTransitions = loop == 0 ? 0 : UInt32(CRNGReference_AutoConditioning.rawValue)
                                    CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                                    CRNGReference_SetHandle(&$0, CRNGReference_Lock, lock)
                                    CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x8000_0018)
                                    CRNGReference_Set(&$0, CRNGReference_SR, 0x44)
                                    if loop == 0 && completion != 0 {
                                        // SET/CLEAR CONDRST each reads CR first.
                                        CRNGReference_Schedule(&$0, CRNGReference_OnCRRead, 2 + completion,
                                                               CRNGReference_CR, 0x40000000, 0)
                                        CRNGReference_Schedule(&$0, CRNGReference_OnCRRead, 2 + completion,
                                                               CRNGReference_SR, 4, 0)
                                    } else if loop == 1 && completion != 0 {
                                        // Initial SECS, SEIS and its CLEAR_BIT RMW
                                        // account for three SR reads before wait.
                                        CRNGReference_Schedule(&$0, CRNGReference_OnSRRead, 3 + completion,
                                                               CRNGReference_SR, 4, 0)
                                    }
                                }) { actual, reference in
                                    let status = actual.recover(extended: extended)
                                    let expected = extended ? CRNGReference_RecoverExtended(&reference.storage) : CRNGReference_Recover(&reference.storage)
                                    XCTAssertEqual(status.rawValue, expected)
                                    XCTAssertEqual(actual.storage.tickCalls, 0)
                                    if !extended || state == 1 {
                                        XCTAssertEqual(status, completion >= 1 && completion <= 9 ? .ok : .error)
                                        if completion == 0 || completion == 10 {
                                            let event = CRNGReference_GetCallbackEvent(&actual.storage, 0)
                                            XCTAssertEqual(event.state, 1); XCTAssertEqual(event.lock, 0)
                                            XCTAssertEqual(event.errorCode, 0x8000_001A)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func testRecoveryWithoutSeedStatusAndPollingRecoveryFailureMatchC() {
        for variant in UInt32(0)...1 {
            for extended in [false, true] {
                for flags in [UInt32(0), 1, 0x40, 0x41] {
                    withPair(variant, setup: {
                        CRNGReference_SetHandle(&$0, CRNGReference_State, 1)
                        CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x19)
                        CRNGReference_Set(&$0, CRNGReference_SR, flags)
                    }) { actual, reference in
                        XCTAssertEqual(actual.recover(extended: extended).rawValue,
                            extended ? CRNGReference_RecoverExtended(&reference.storage) : CRNGReference_Recover(&reference.storage))
                        XCTAssertEqual(actual.core.getError().rawValue, 0x11)
                        XCTAssertEqual(actual.core.getState(), extended ? .busy : .ready)
                    }
                }
            }
            for rearm in UInt32(0)...1 {
                withPair(variant, setup: {
                    $0.automaticTransitions = 0
                    CRNGReference_SetHandle(&$0, CRNGReference_State, 1)
                    CRNGReference_Set(&$0, CRNGReference_SR, 0x44)
                    CRNGReference_SetCallbackAction(&$0, 0, rearm)
                }) { actual, reference in
                    var a: UInt32 = 0x11223344, e = a
                    XCTAssertEqual(actual.generate(&a).rawValue, CRNGReference_Generate(&reference.storage, &e))
                    XCTAssertEqual(a, e); XCTAssertEqual(a, 0x11223344)
                    XCTAssertEqual(actual.core.getError(), .recoverSeed)
                }
            }
        }
    }

    func testInterruptCallbackSnapshotsAndRearmingMatchCForBothImplementations() {
        for variant in UInt32(0)...1 {
            for selector in UInt32(1)...3 {
                for flags in [UInt32(1), 0x21, 0x41, 0x45, 0x65] {
                    for rearm in UInt32(0)...1 {
                        withPair(variant, setup: {
                            CRNGReference_SetHandle(&$0, CRNGReference_State, 2)
                            CRNGReference_SetHandle(&$0, CRNGReference_Lock, 1)
                            CRNGReference_Set(&$0, CRNGReference_CR, 0x2C)
                            CRNGReference_Set(&$0, CRNGReference_SR, flags)
                            CRNGReference_PushData(&$0, 0x01234567)
                            CRNGReference_PushData(&$0, 0x89ABCDEF)
                            CRNGReference_SetCallback(&$0, 0, selector)
                            CRNGReference_SetCallback(&$0, 3, selector)
                            CRNGReference_SetCallbackAction(&$0, 0, rearm)
                            CRNGReference_SetCallbackAction(&$0, 3, rearm)
                        }) { actual, reference in
                            actual.interrupt(); CRNGReference_HandleInterrupt(&reference.storage)
                            assertMatches(actual, reference)
                            // A second IRQ checks that the callback action and
                            // W0C error clear left identical externally visible state.
                            actual.interrupt(); CRNGReference_HandleInterrupt(&reference.storage)
                        }
                    }
                }
            }
        }
    }

    func testAllRegistrationStatesLocksIdentifiersAndNullCallbacksMatchC() {
        for state in UInt32(0)...4 {
            for lock in UInt32(0)...1 {
                for identifier in [UInt32(0), 1, 2, 3, UInt32.max] {
                    for selector in UInt32(0)...3 {
                        for unregisters in [false, true] {
                            withPair(1, setup: {
                                CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                                CRNGReference_SetHandle(&$0, CRNGReference_Lock, lock)
                                CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0xA5)
                                for id in UInt32(0)...3 { CRNGReference_SetCallback(&$0, id, 3) }
                            }) { actual, reference in
                                let status: HALStatus, expected: UInt32
                                if unregisters {
                                    status = actual.registered.unregisterCallback(id: identifier)
                                    expected = CRNGReference_UnregisterCallback(&reference.storage, identifier)
                                } else {
                                    status = actual.registered.registerCallback(id: identifier,
                                        callback: RNGDifferentialIO.callback(identifier, selector))
                                    expected = CRNGReference_RegisterCallback(&reference.storage, identifier, selector)
                                }
                                XCTAssertEqual(status.rawValue, expected)
                                XCTAssertEqual(actual.read(.lock), lock, "Ordinary callback registration never acquires the lock")
                            }
                        }
                    }
                }
                for selector in UInt32(0)...3 {
                    for unregisters in [false, true] {
                        withPair(1, setup: {
                            CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                            CRNGReference_SetHandle(&$0, CRNGReference_Lock, lock)
                            CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0xA5)
                            CRNGReference_SetCallback(&$0, 3, 3)
                        }) { actual, reference in
                            let status = unregisters ? actual.registered.unregisterReadyDataCallback() :
                                actual.registered.registerReadyDataCallback(RNGDifferentialIO.readyCallback(selector))
                            let expected = unregisters ? CRNGReference_UnregisterReadyCallback(&reference.storage) :
                                CRNGReference_RegisterReadyCallback(&reference.storage, selector)
                            XCTAssertEqual(status.rawValue, expected)
                        }
                    }
                }
            }
        }
    }

    func testRegisteredCallbacksSurviveOrResetAtTheSameLifecyclePointsAsC() {
        withPair(1, setup: {
            for id in UInt32(0)...3 { CRNGReference_SetCallback(&$0, id, 2) }
        }) { actual, reference in
            XCTAssertEqual(actual.initialize().rawValue, CRNGReference_Initialize(&reference.storage))
            assertMatches(actual, reference)
            XCTAssertEqual(actual.registered.registerCallback(id: .error, callback: RNGDifferentialIO.callback(0, 3)), .ok)
            XCTAssertEqual(CRNGReference_RegisterCallback(&reference.storage, 0, 3), 0)
            XCTAssertEqual(actual.registered.registerReadyDataCallback(RNGDifferentialIO.readyCallback(2)), .ok)
            XCTAssertEqual(CRNGReference_RegisterReadyCallback(&reference.storage, 2), 0)
            XCTAssertEqual(actual.deinitialize().rawValue, CRNGReference_Deinitialize(&reference.storage))
            assertMatches(actual, reference)
            XCTAssertEqual(actual.initialize().rawValue, CRNGReference_Initialize(&reference.storage))
            for id in [UInt32(0), 3] { XCTAssertEqual(CRNGReference_GetCallback(&actual.storage, id), 1) }
        }
    }

    func testConfigurationAllFieldValuesPreserveUnrelatedBitsMatchC() {
        for variant in UInt32(0)...1 {
            for field in 0..<7 {
                let values: [UInt32]
                switch field {
                case 0: values = Array(0...63)
                case 1: values = Array(0...7)
                case 2: values = Array(0...15)
                case 3: values = (UInt32(0)...15).map { $0 << 16 }
                case 4: values = [0, 0x1000]
                case 5: values = [0, 0x80]
                default: values = [0, 1, 0xA5A55A5A, UInt32.max]
                }
                for value in values {
                    var configuration = RNGConfiguration(config1: 0x2A, config2: 5, config3: 10,
                        clockDivider: 0xA0000, nistCompliance: 0x1000, autoReset: 0x80, healthTest: 0xA55A_5AA5)
                    switch field {
                    case 0: configuration.config1 = value
                    case 1: configuration.config2 = value
                    case 2: configuration.config3 = value
                    case 3: configuration.clockDivider = value
                    case 4: configuration.nistCompliance = value
                    case 5: configuration.autoReset = value
                    default: configuration.healthTest = value
                    }
                    withPair(variant, setup: {
                        CRNGReference_SetHandle(&$0, CRNGReference_State, 1)
                        CRNGReference_SetHandle(&$0, CRNGReference_Lock, 1)
                        CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x80)
                        CRNGReference_Set(&$0, CRNGReference_CR, 0xBFFF_FFFF)
                    }) { actual, reference in
                        var c = cConfiguration(configuration)
                        XCTAssertEqual(actual.core.setConfig(configuration, getTick: actual.getTick).rawValue,
                                       CRNGReference_SetConfig(&reference.storage, &c))
                        var a: RNGConfiguration? = .init()
                        var e = RNG_ConfigTypeDef()
                        actual.bypassConfigurationReads = true
                        XCTAssertEqual(actual.core.getConfig(&a).rawValue, CRNGReference_GetConfig(&reference.storage, &e))
                        actual.bypassConfigurationReads = false
                        XCTAssertEqual(a, swiftConfiguration(e))
                        XCTAssertEqual(a, configuration)
                    }
                }
            }
        }
    }

    func testConfigurationReadbackAllBitsAndNonReadyErrorAccumulationMatchC() {
        for variant in UInt32(0)...1 {
            for state in UInt32(0)...4 {
                for bit in 0..<33 {
                    let value = bit == 32 ? UInt32.max : UInt32(1) << bit
                    withPair(variant, setup: {
                        CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                        CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x80)
                        CRNGReference_Set(&$0, CRNGReference_CR, value)
                        CRNGReference_Set(&$0, CRNGReference_HTCR, ~value)
                    }) { actual, reference in
                        var a: RNGConfiguration? = .init(config1: 0xBAD, healthTest: 0xCAFE)
                        var e = cConfiguration(a!)
                        actual.bypassConfigurationReads = true
                        XCTAssertEqual(actual.core.getConfig(&a).rawValue, CRNGReference_GetConfig(&reference.storage, &e))
                        actual.bypassConfigurationReads = false
                        XCTAssertEqual(a, swiftConfiguration(e))
                        if state != 1 { XCTAssertEqual(actual.core.getError().rawValue, 0x84) }
                    }
                }
            }
        }
    }

    func testConfigurationAndLockForEveryStateDoNotAcquireHandleLock() {
        for variant in UInt32(0)...1 {
            for state in UInt32(0)...4 {
                for lock in UInt32(0)...1 {
                    for locksConfiguration in [false, true] {
                        withPair(variant, setup: {
                            CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                            CRNGReference_SetHandle(&$0, CRNGReference_Lock, lock)
                            CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x80)
                            CRNGReference_Set(&$0, CRNGReference_CR, 0x2000_0028)
                        }) { actual, reference in
                            if locksConfiguration {
                                XCTAssertEqual(actual.core.lockConfig().rawValue, CRNGReference_LockConfig(&reference.storage))
                            } else {
                                var c = cConfiguration(.init())
                                XCTAssertEqual(actual.core.setConfig(.init(), getTick: actual.getTick).rawValue,
                                               CRNGReference_SetConfig(&reference.storage, &c))
                            }
                            XCTAssertEqual(actual.read(.lock), lock)
                            if state != 1 { XCTAssertEqual(actual.core.getError(), .busy) }
                        }
                    }
                }
            }
        }
    }

    func testNilConfigurationAndReadOnlyQueriesHaveNoSideEffects() {
        for variant in UInt32(0)...1 {
            for state in UInt32(0)...4 {
                withPair(variant, setup: {
                    CRNGReference_SetHandle(&$0, CRNGReference_State, state)
                    CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0xA55A)
                    CRNGReference_SetHandle(&$0, CRNGReference_RandomNumber, 0xDEADBEEF)
                }) { actual, reference in
                    XCTAssertEqual(actual.core.setConfig(nil, getTick: actual.getTick).rawValue,
                                   CRNGReference_SetConfig(&reference.storage, nil))
                    var value: RNGConfiguration?
                    XCTAssertEqual(actual.core.getConfig(&value).rawValue, CRNGReference_GetConfig(&reference.storage, nil))
                    XCTAssertNil(value)
                    XCTAssertEqual(actual.core.getState().rawValue, CRNGReference_GetState(&reference.storage))
                    XCTAssertEqual(actual.core.getError().rawValue, CRNGReference_GetError(&reference.storage))
                    XCTAssertEqual(actual.core.readLastRandomNumber(), CRNGReference_ReadLast(&reference.storage))
                    XCTAssertEqual(actual.storage.writeCount, 0)
                    XCTAssertEqual(actual.storage.tickCalls, 0)
                }
            }
        }
    }

    func testEveryErrorBitCombinationPreserveClearAndORPathsMatchC() {
        for variant in UInt32(0)...1 {
            for errors in UInt32(0)...63 {
                for operation in 0..<4 {
                    withPair(variant, setup: {
                        CRNGReference_SetHandle(&$0, CRNGReference_State, operation == 3 ? 2 : 1)
                        CRNGReference_SetHandle(&$0, CRNGReference_ErrorCode, 0x8000_0000 | errors)
                        CRNGReference_Set(&$0, CRNGReference_SR, operation == 0 ? 1 : 0x40)
                        CRNGReference_PushData(&$0, 0xA55A_1234)
                    }) { actual, reference in
                        switch operation {
                        case 0:
                            var a: UInt32 = 0, e: UInt32 = 0
                            XCTAssertEqual(actual.generate(&a).rawValue, CRNGReference_Generate(&reference.storage, &e))
                            XCTAssertEqual(a, e)
                        case 1:
                            XCTAssertEqual(actual.recover(extended: true).rawValue, CRNGReference_RecoverExtended(&reference.storage))
                        case 2:
                            XCTAssertEqual(actual.initialize().rawValue, CRNGReference_Initialize(&reference.storage))
                        default:
                            var a: RNGConfiguration? = .init(), e = RNG_ConfigTypeDef()
                            XCTAssertEqual(actual.core.getConfig(&a).rawValue, CRNGReference_GetConfig(&reference.storage, &e))
                            XCTAssertEqual(a, swiftConfiguration(e))
                        }
                    }
                }
            }
        }
    }
}
