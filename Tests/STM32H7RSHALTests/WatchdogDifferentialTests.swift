import CWatchdogReference
import XCTest

@testable import STM32H7RSHAL

// Match the original C access boundary: direct fields use plain memory; only
// IWDG.KR and WWDG.CR/CFR writes pass through WRITE_REG and enter the trace.
// Peripheral W1C/W0C effects and full access order have separate trace/board tests.
private final class WatchdogDifferentialIO: IWDGRegisterIO, IWDGConfigurationIO, IWDGCallbackIO,
    WWDGRegisterIO, WWDGConfigurationIO, WWDGCallbackIO
{
    var storage = CWatchdogState()
    var context: UnsafeMutableRawPointer?
    var iwdg: IWDG<WatchdogDifferentialIO, WatchdogDifferentialIO> {
        .init(
            registers: self, configuration: self,
            timing: .init(lsiFrequency: storage.lsi, lsiStartupMicroseconds: storage.lsiStartupTime))
    }
    var wwdg: WWDG<WatchdogDifferentialIO, WatchdogDifferentialIO> { .init(registers: self, configuration: self) }
    var registeredIWDG: IWDGRegistered<WatchdogDifferentialIO, WatchdogDifferentialIO, WatchdogDifferentialIO> {
        .init(
            core: iwdg, callbacks: self,
            defaults: .init(
                earlyWakeup: Self.callback(CWatchdog_IWDG, 0, 1)!, mspInitialize: Self.callback(CWatchdog_IWDG, 1, 1)!))
    }
    var registeredWWDG: WWDGRegistered<WatchdogDifferentialIO, WatchdogDifferentialIO, WatchdogDifferentialIO> {
        .init(
            core: wwdg, callbacks: self,
            defaults: .init(
                earlyWakeup: Self.callback(CWatchdog_WWDG, 0, 1)!, mspInitialize: Self.callback(CWatchdog_WWDG, 1, 1)!))
    }
    static func register(_ register: IWDGRegister) -> CWatchdogRegister {
        switch register {
        case .kr: return CWatchdog_IWDG_KR
        case .pr: return CWatchdog_IWDG_PR
        case .rlr: return CWatchdog_IWDG_RLR
        case .sr: return CWatchdog_IWDG_SR
        case .winr: return CWatchdog_IWDG_WINR
        case .ewcr: return CWatchdog_IWDG_EWCR
        }
    }
    static func register(_ register: WWDGRegister) -> CWatchdogRegister {
        switch register {
        case .cr: return CWatchdog_WWDG_CR
        case .cfr: return CWatchdog_WWDG_CFR
        case .sr: return CWatchdog_WWDG_SR
        }
    }
    func read(_ register: IWDGRegister) -> UInt32 { CWatchdog_Get(&storage, Self.register(register)) }
    func write(_ register: IWDGRegister, value: UInt32) {
        if register == .kr {
            CWatchdog_Write(&storage, Self.register(register), value)
        } else {
            CWatchdog_Set(&storage, Self.register(register), value)
        }
    }
    func read(_ register: WWDGRegister) -> UInt32 { CWatchdog_Get(&storage, Self.register(register)) }
    func write(_ register: WWDGRegister, value: UInt32) {
        if register == .sr {
            CWatchdog_Set(&storage, Self.register(register), value)
        } else {
            CWatchdog_Write(&storage, Self.register(register), value)
        }
    }
    func read(_ word: IWDGConfigurationWord) -> UInt32 {
        CWatchdog_GetConfiguration(&storage, CWatchdog_IWDG, UInt32(word.rawValue))
    }
    func write(_ word: IWDGConfigurationWord, value: UInt32) {
        CWatchdog_SetConfiguration(&storage, CWatchdog_IWDG, UInt32(word.rawValue), value)
    }
    func read(_ word: WWDGConfigurationWord) -> UInt32 {
        CWatchdog_GetConfiguration(&storage, CWatchdog_WWDG, UInt32(word.rawValue))
    }
    func write(_ word: WWDGConfigurationWord, value: UInt32) {
        CWatchdog_SetConfiguration(&storage, CWatchdog_WWDG, UInt32(word.rawValue), value)
    }
    func getTick() -> UInt32 { CWatchdog_Tick(&storage) }

    static func object(_ context: UnsafeMutableRawPointer?) -> WatchdogDifferentialIO {
        Unmanaged<WatchdogDifferentialIO>.fromOpaque(context!).takeUnretainedValue()
    }
    static func callback(_ device: CWatchdogDevice, _ id: UInt32, _ implementation: UInt32) -> IWDGCallback? {
        if implementation == 0 { return nil }
        switch (device.rawValue, id, implementation) {
        case (0, 1, 1): return { WatchdogDifferentialIO.object($0).record(CWatchdog_IWDG, 1, 1) }
        case (0, 1, 2): return { WatchdogDifferentialIO.object($0).record(CWatchdog_IWDG, 1, 2) }
        case (0, 1, 3): return { WatchdogDifferentialIO.object($0).record(CWatchdog_IWDG, 1, 3) }
        case (0, _, 1): return { WatchdogDifferentialIO.object($0).record(CWatchdog_IWDG, 0, 1) }
        case (0, _, 2): return { WatchdogDifferentialIO.object($0).record(CWatchdog_IWDG, 0, 2) }
        case (0, _, 3): return { WatchdogDifferentialIO.object($0).record(CWatchdog_IWDG, 0, 3) }
        case (1, 1, 1): return { WatchdogDifferentialIO.object($0).record(CWatchdog_WWDG, 1, 1) }
        case (1, 1, 2): return { WatchdogDifferentialIO.object($0).record(CWatchdog_WWDG, 1, 2) }
        case (1, 1, 3): return { WatchdogDifferentialIO.object($0).record(CWatchdog_WWDG, 1, 3) }
        case (1, _, 1): return { WatchdogDifferentialIO.object($0).record(CWatchdog_WWDG, 0, 1) }
        case (1, _, 2): return { WatchdogDifferentialIO.object($0).record(CWatchdog_WWDG, 0, 2) }
        case (1, _, 3): return { WatchdogDifferentialIO.object($0).record(CWatchdog_WWDG, 0, 3) }
        default: preconditionFailure("Unknown test callback")
        }
    }
    func selector(_ device: CWatchdogDevice, _ id: UInt32, _ value: IWDGCallback?) -> UInt32 {
        guard let value else { return 0 }
        let bits = unsafeBitCast(value, to: UInt.self)
        return (UInt32(1)...3).first { unsafeBitCast(Self.callback(device, id, $0)!, to: UInt.self) == bits }!
    }
    func read(_ id: IWDGCallbackID) -> IWDGCallback? {
        Self.callback(CWatchdog_IWDG, id.rawValue, CWatchdog_GetCallback(&storage, CWatchdog_IWDG, id.rawValue))
    }
    func write(_ id: IWDGCallbackID, value: IWDGCallback?) {
        CWatchdog_SetCallback(&storage, CWatchdog_IWDG, id.rawValue, selector(CWatchdog_IWDG, id.rawValue, value))
    }
    func read(_ id: WWDGCallbackID) -> WWDGCallback? {
        Self.callback(CWatchdog_WWDG, id.rawValue, CWatchdog_GetCallback(&storage, CWatchdog_WWDG, id.rawValue))
    }
    func write(_ id: WWDGCallbackID, value: WWDGCallback?) {
        CWatchdog_SetCallback(&storage, CWatchdog_WWDG, id.rawValue, selector(CWatchdog_WWDG, id.rawValue, value))
    }
    func record(_ device: CWatchdogDevice, _ id: UInt32, _ implementation: UInt32) {
        let index = CWatchdog_RecordCallback(&storage, device, id, implementation)
        switch CWatchdog_GetCallbackAction(&storage, device, id) {
        case 1:
            let status = refresh(device)
            CWatchdog_SetCallbackActionStatus(&storage, index, status.rawValue)
        case 2: CWatchdog_ApplyCallbackMutation(&storage, device, id)
        default: break
        }
    }
    func initialize(_ device: CWatchdogDevice) -> HALStatus {
        if device == CWatchdog_IWDG {
            return storage.registeredCallbacks != 0
                ? registeredIWDG.initialize(getTick: getTick)
                : iwdg.initialize(getTick: getTick, mspInitialize: { _ in self.record(device, 1, 1) })
        }
        return storage.registeredCallbacks != 0
            ? registeredWWDG.initialize() : wwdg.initialize(mspInitialize: { _ in self.record(device, 1, 1) })
    }
    func refresh(_ device: CWatchdogDevice) -> HALStatus {
        if device == CWatchdog_IWDG {
            return storage.registeredCallbacks != 0 ? registeredIWDG.refresh() : iwdg.refresh()
        }
        return storage.registeredCallbacks != 0 ? registeredWWDG.refresh() : wwdg.refresh()
    }
    func interrupt(_ device: CWatchdogDevice) {
        if device == CWatchdog_IWDG {
            if storage.registeredCallbacks != 0 {
                registeredIWDG.handleInterrupt()
            } else {
                iwdg.handleInterrupt(earlyWakeup: { _ in self.record(device, 0, 1) })
            }
        } else {
            if storage.registeredCallbacks != 0 {
                registeredWWDG.handleInterrupt()
            } else {
                wwdg.handleInterrupt(earlyWakeup: { _ in self.record(device, 0, 1) })
            }
        }
    }
    func register(_ device: CWatchdogDevice, _ id: UInt32, _ implementation: UInt32) -> HALStatus {
        if device == CWatchdog_IWDG {
            return registeredIWDG.registerCallback(id: id, callback: Self.callback(device, id, implementation))
        }
        return registeredWWDG.registerCallback(id: id, callback: Self.callback(device, id, implementation))
    }
    func unregister(_ device: CWatchdogDevice, _ id: UInt32) -> HALStatus {
        device == CWatchdog_IWDG ? registeredIWDG.unregisterCallback(id: id) : registeredWWDG.unregisterCallback(id: id)
    }
}

final class WatchdogDifferentialTests: XCTestCase {
    private func withPair(
        _ variant: UInt32, setup: (inout CWatchdogState) -> Void = { _ in },
        file: StaticString = #filePath, line: UInt = #line,
        body: (WatchdogDifferentialIO, WatchdogDifferentialIO) -> Void
    ) {
        let actual = WatchdogDifferentialIO()
        CWatchdog_Reset(&actual.storage, variant)
        setup(&actual.storage)
        let reference = WatchdogDifferentialIO()
        reference.storage = actual.storage
        let retained = Unmanaged.passRetained(actual)
        actual.context = retained.toOpaque()
        defer { retained.release() }
        body(actual, reference)
        for index in UInt32(0)..<CWatchdog_RegisterCount.rawValue {
            let register = CWatchdogRegister(rawValue: index)
            XCTAssertEqual(
                CWatchdog_Get(&actual.storage, register), CWatchdog_Get(&reference.storage, register),
                "register \(index)", file: file, line: line)
        }
        for device in [CWatchdog_IWDG, CWatchdog_WWDG] {
            for word in UInt32(0)..<4 {
                XCTAssertEqual(
                    CWatchdog_GetConfiguration(&actual.storage, device, word),
                    CWatchdog_GetConfiguration(&reference.storage, device, word),
                    "device \(device.rawValue) configuration \(word)", file: file, line: line)
            }
            for slot in UInt32(0)..<2 {
                XCTAssertEqual(
                    CWatchdog_GetCallback(&actual.storage, device, slot),
                    CWatchdog_GetCallback(&reference.storage, device, slot),
                    "device \(device.rawValue) callback \(slot)", file: file, line: line)
            }
        }
        XCTAssertEqual(
            [actual.storage.tick, actual.storage.tickCalls], [reference.storage.tick, reference.storage.tickCalls],
            file: file, line: line)
        XCTAssertEqual(actual.storage.writeCount, reference.storage.writeCount, file: file, line: line)
        for index in UInt32(0)..<min(actual.storage.writeCount, reference.storage.writeCount) {
            let a = CWatchdog_GetWrite(&actual.storage, index)
            let e = CWatchdog_GetWrite(&reference.storage, index)
            XCTAssertEqual(
                [a.reg.rawValue, a.value, a.tickCall], [e.reg.rawValue, e.value, e.tickCall],
                "macro write \(index)", file: file, line: line)
        }
        XCTAssertEqual(actual.storage.callbackCount, reference.storage.callbackCount, file: file, line: line)
        for index in UInt32(0)..<min(actual.storage.callbackCount, reference.storage.callbackCount) {
            let a = CWatchdog_GetCallbackEvent(&actual.storage, index)
            let e = CWatchdog_GetCallbackEvent(&reference.storage, index)
            XCTAssertEqual(
                [a.device.rawValue, a.callbackID, a.implementation, a.tickCall, a.writeCount, a.actionStatus],
                [e.device.rawValue, e.callbackID, e.implementation, e.tickCall, e.writeCount, e.actionStatus],
                "callback \(index)", file: file, line: line)
            XCTAssertEqual(
                words(a.configuration), words(e.configuration), "callback configuration", file: file, line: line)
            XCTAssertEqual(words(a.callbackSlots), words(e.callbackSlots), "callback slots", file: file, line: line)
            XCTAssertEqual(words(a.registers), words(e.registers), "callback registers", file: file, line: line)
        }
    }
    private func words<T>(_ value: T) -> [UInt32] {
        // Used only for C arrays imported as fixed tuples of UInt32.
        withUnsafeBytes(of: value) { Array($0.bindMemory(to: UInt32.self)) }
    }
    private func setConfiguration(_ state: inout CWatchdogState, _ device: CWatchdogDevice, _ values: [UInt32]) {
        for (word, value) in values.enumerated() { CWatchdog_SetConfiguration(&state, device, UInt32(word), value) }
    }
    @discardableResult
    private func initialize(
        _ device: CWatchdogDevice, _ actual: WatchdogDifferentialIO, _ reference: WatchdogDifferentialIO,
        file: StaticString = #filePath, line: UInt = #line
    ) -> HALStatus {
        let status = actual.initialize(device)
        XCTAssertEqual(status.rawValue, CWatchdog_Initialize(&reference.storage, device, 0), file: file, line: line)
        return status
    }

    func testIWDGAllPrescalersReloadWindowAndEarlyWakeupBoundariesMatchC() {
        for variant in UInt32(0)...1 {
            for prescaler in UInt32(0)...8 {
                for value: UInt32 in [0, 1, 0x40, 0xAAA, 0xFFF] {
                    for ewi: UInt32 in [0, 1, 0xFFF] {
                        for sameWindow in [false, true] {
                            withPair(
                                variant,
                                setup: { state in
                                    setConfiguration(&state, CWatchdog_IWDG, [prescaler, value, value, ewi])
                                    state.iwdg.WINR = sameWindow ? value : value ^ 1
                                    state.iwdg.EWCR = 0xAAAA_5555
                                }
                            ) { actual, reference in
                                XCTAssertEqual(initialize(CWatchdog_IWDG, actual, reference), .ok)
                                XCTAssertEqual(actual.storage.iwdg.EWCR, ewi == 0 ? 0x4000 : 0xC000 | ewi)
                                XCTAssertEqual(
                                    actual.refresh(CWatchdog_IWDG).rawValue,
                                    CWatchdog_Refresh(&reference.storage, CWatchdog_IWDG))
                            }
                        }
                    }
                }
            }
        }
    }

    func testWWDGAllPrescalersWindowCounterAndEarlyWakeupBoundariesMatchC() {
        for variant in UInt32(0)...1 {
            for divider in UInt32(0)...7 {
                for window: UInt32 in [0x40, 0x41, 0x7E, 0x7F] {
                    for counter: UInt32 in [0x40, 0x41, 0x7E, 0x7F] {
                        for ewi: UInt32 in [0, 0x200] {
                            withPair(
                                variant,
                                setup: { state in
                                    setConfiguration(&state, CWatchdog_WWDG, [divider << 11, window, counter, ewi])
                                    state.wwdg.CR = 0xFFFF_FFFF
                                    state.wwdg.CFR = 0xA5A5_5A5A
                                }
                            ) { actual, reference in
                                XCTAssertEqual(initialize(CWatchdog_WWDG, actual, reference), .ok)
                                XCTAssertEqual(actual.storage.wwdg.CR, 0x80 | counter)
                                XCTAssertEqual(
                                    actual.refresh(CWatchdog_WWDG).rawValue,
                                    CWatchdog_Refresh(&reference.storage, CWatchdog_WWDG))
                                XCTAssertEqual(actual.storage.wwdg.CR, counter)
                            }
                        }
                    }
                }
            }
        }
    }

    func testIWDGTimeoutBothWaitsDeadlineRecheckAndTickWrapMatchC() {
        for variant in UInt32(0)...1 {
            for flags: UInt32 in [0, 1, 2, 4, 8, 0xF] {
                for clearCall in UInt32(0)...5 {
                    for start: UInt32 in [0, .max - 2000] {
                        withPair(
                            variant,
                            setup: { state in
                                state.tick = start
                                state.tickStep = CWatchdog_GetUpdateTimeout(&state)
                                state.iwdg.SR = flags
                                state.iwdg.EWCR = 0x1234
                                state.iwdg.WINR = 0x111
                                setConfiguration(&state, CWatchdog_IWDG, [8, 0xAAA, 0x222, 0x333])
                                if clearCall != 0 {
                                    CWatchdog_ScheduleTick(&state, clearCall, CWatchdog_IWDG_SR, 0xF, 0)
                                }
                            }
                        ) { actual, reference in
                            _ = initialize(CWatchdog_IWDG, actual, reference)
                            if clearCall == 0 && flags != 0 {
                                XCTAssertEqual(actual.storage.iwdg.WINR, 0x111)
                                XCTAssertEqual(actual.storage.iwdg.EWCR, flags & 2 != 0 ? 0x1234 : 0xC333)
                            }
                            XCTAssertLessThanOrEqual(actual.storage.tickCalls, 6)
                        }
                    }
                }
            }
        }
    }

    func testIWDGFirstTimeoutRecheckRecoveryThenSecondWaitUsesNewStartTick() {
        for variant in UInt32(0)...1 {
            withPair(
                variant,
                setup: { state in
                    state.tick = .max - 4096
                    state.tickStep = 4098
                    state.iwdg.SR = 2
                    CWatchdog_ScheduleTick(&state, 2, CWatchdog_IWDG_SR, 2, 8)
                    CWatchdog_ScheduleTick(&state, 4, CWatchdog_IWDG_SR, 8, 0)
                }
            ) { actual, reference in
                XCTAssertEqual(initialize(CWatchdog_IWDG, actual, reference), .ok)
                XCTAssertEqual(actual.storage.tickCalls, 4)
            }
        }
    }

    func testIWDGTimeoutFormulaPreservesIntegerDivisionOrder() {
        for lsi: UInt32 in [128, 129, 999, 32_000, 32_768, 47_999, 65_535] {
            for startup: UInt32 in [0, 130, 999, 1000, 999_999] {
                withPair(
                    0,
                    setup: { state in
                        state.lsi = lsi
                        state.lsiStartupTime = startup
                    }
                ) { actual, _ in
                    XCTAssertEqual(actual.iwdg.timing.updateTimeout, CWatchdog_GetUpdateTimeout(&actual.storage))
                }
            }
        }
    }

    func testEveryExistingCallbackCombinationSurvivesRepeatedInitialization() {
        for variant in UInt32(0)...1 {
            for device in [CWatchdog_IWDG, CWatchdog_WWDG] {
                for early in UInt32(0)...3 {
                    for msp in UInt32(0)...3 {
                        withPair(
                            variant,
                            setup: { state in
                                CWatchdog_SetCallback(&state, device, 0, early)
                                CWatchdog_SetCallback(&state, device, 1, msp)
                            }
                        ) { actual, reference in
                            XCTAssertEqual(initialize(device, actual, reference), .ok)
                            XCTAssertEqual(initialize(device, actual, reference), .ok)
                            XCTAssertEqual(actual.storage.callbackCount, 2)
                            if variant != 0 {
                                XCTAssertEqual(
                                    CWatchdog_GetCallback(&actual.storage, device, 0), early == 0 ? 1 : early)
                                XCTAssertEqual(CWatchdog_GetCallback(&actual.storage, device, 1), msp == 0 ? 1 : msp)
                            }
                        }
                    }
                }
            }
        }
    }

    func testMSPCallbackChangesSharedConfigurationBeforeRegisterWrites() {
        for variant in UInt32(0)...1 {
            for device in [CWatchdog_IWDG, CWatchdog_WWDG] {
                withPair(
                    variant,
                    setup: { state in
                        CWatchdog_SetCallback(&state, device, 1, 2)
                        CWatchdog_SetCallbackAction(&state, device, 1, 2)
                        let values: [UInt32] =
                            device == CWatchdog_IWDG ? [8, 0xABC, 0x123, 0x456] : [0x3800, 0x65, 0x71, 0x200]
                        values.withUnsafeBufferPointer {
                            CWatchdog_SetCallbackMutation(&state, device, 1, $0.baseAddress)
                        }
                    }
                ) { actual, reference in XCTAssertEqual(initialize(device, actual, reference), .ok) }
            }
        }
    }

    func testIWDGActiveStatusAndIRQIgnoresEnableBitThenCallbackMayRefresh() {
        for variant in UInt32(0)...1 {
            for status: UInt32 in [0, 0x100, 0x4000, 0x4100, 0xFFFF_FFFF] {
                for ewcr: UInt32 in [0, 0x8000, 0xA5A5_0123] {
                    withPair(
                        variant,
                        setup: { state in
                            state.iwdg.SR = status
                            state.iwdg.EWCR = ewcr
                            CWatchdog_SetCallback(&state, CWatchdog_IWDG, 0, 3)
                            CWatchdog_SetCallbackAction(&state, CWatchdog_IWDG, 0, 1)
                        }
                    ) { actual, reference in
                        let active =
                            variant != 0 ? actual.registeredIWDG.getActiveStatus() : actual.iwdg.getActiveStatus()
                        XCTAssertEqual(active, CWatchdog_GetActiveStatus(&reference.storage))
                        actual.interrupt(CWatchdog_IWDG)
                        CWatchdog_HandleInterrupt(&reference.storage, CWatchdog_IWDG)
                        XCTAssertEqual(actual.storage.callbackCount, status & 0x4000 != 0 ? 1 : 0)
                    }
                }
            }
        }
    }

    func testWWDGIRQChecksEnableAndFlagThenCallbackMayRefresh() {
        for variant in UInt32(0)...1 {
            for status: UInt32 in [0, 1, 0xFFFF_FFFE, .max] {
                for cfr: UInt32 in [0, 0x200, 0xA5A5_5A5A] {
                    withPair(
                        variant,
                        setup: { state in
                            state.wwdg.SR = status
                            state.wwdg.CFR = cfr
                            CWatchdog_SetCallback(&state, CWatchdog_WWDG, 0, 2)
                            CWatchdog_SetCallbackAction(&state, CWatchdog_WWDG, 0, 1)
                            CWatchdog_SetConfiguration(&state, CWatchdog_WWDG, 2, 0x61)
                        }
                    ) { actual, reference in
                        actual.interrupt(CWatchdog_WWDG)
                        CWatchdog_HandleInterrupt(&reference.storage, CWatchdog_WWDG)
                        actual.interrupt(CWatchdog_WWDG)
                        CWatchdog_HandleInterrupt(&reference.storage, CWatchdog_WWDG)
                        XCTAssertEqual(actual.storage.callbackCount, status & 1 != 0 && cfr & 0x200 != 0 ? 1 : 0)
                    }
                }
            }
        }
    }

    func testCallbackRegistrationAcceptsKnownIDsAndRejectsNilOrUnknownIDs() {
        for device in [CWatchdog_IWDG, CWatchdog_WWDG] {
            for id: UInt32 in [0, 1, 2, .max] {
                for implementation in UInt32(0)...3 {
                    for old in UInt32(0)...2 {
                        withPair(
                            1,
                            setup: { state in
                                CWatchdog_SetCallback(&state, device, 0, old)
                                CWatchdog_SetCallback(&state, device, 1, old)
                            }
                        ) { actual, reference in
                            XCTAssertEqual(
                                actual.register(device, id, implementation).rawValue,
                                CWatchdog_RegisterCallback(&reference.storage, device, id, implementation))
                        }
                    }
                }
            }
        }
    }

    func testUnregisterRestoresDefaultAndRejectsUnknownIDs() {
        for device in [CWatchdog_IWDG, CWatchdog_WWDG] {
            for id: UInt32 in [0, 1, 2, .max] {
                withPair(
                    1,
                    setup: { state in
                        CWatchdog_SetCallback(&state, device, 0, 3)
                        CWatchdog_SetCallback(&state, device, 1, 2)
                    }
                ) { actual, reference in
                    XCTAssertEqual(
                        actual.unregister(device, id).rawValue,
                        CWatchdog_UnregisterCallback(&reference.storage, device, id))
                    XCTAssertEqual(initialize(device, actual, reference), .ok)
                }
            }
        }
    }

    func testRegistrationAfterStartAndRefreshUseCurrentSharedConfiguration() {
        for device in [CWatchdog_IWDG, CWatchdog_WWDG] {
            withPair(1) { actual, reference in
                XCTAssertEqual(initialize(device, actual, reference), .ok)
                for id in UInt32(0)...1 {
                    XCTAssertEqual(
                        actual.register(device, id, 2).rawValue,
                        CWatchdog_RegisterCallback(&reference.storage, device, id, 2))
                }
                if device == CWatchdog_WWDG {
                    CWatchdog_SetConfiguration(&actual.storage, device, 2, 0x42)
                    CWatchdog_SetConfiguration(&reference.storage, device, 2, 0x42)
                }
                XCTAssertEqual(actual.refresh(device).rawValue, CWatchdog_Refresh(&reference.storage, device))
                XCTAssertEqual(initialize(device, actual, reference), .ok)
            }
        }
    }
}
