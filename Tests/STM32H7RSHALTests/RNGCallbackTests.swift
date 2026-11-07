import XCTest
@testable import STM32H7RSHAL

private func callbackContext(_ pointer: UnsafeMutableRawPointer?) -> RNGCallbackTestContext {
    Unmanaged<RNGCallbackTestContext>.fromOpaque(pointer!).takeUnretainedValue()
}

private func defaultError(_ pointer: UnsafeMutableRawPointer?) { callbackContext(pointer).record("defaultError") }
private func defaultMSPInit(_ pointer: UnsafeMutableRawPointer?) { callbackContext(pointer).record("defaultInit") }
private func defaultMSPDeinit(_ pointer: UnsafeMutableRawPointer?) { callbackContext(pointer).record("defaultDeinit") }
private func customCommon(_ pointer: UnsafeMutableRawPointer?) { callbackContext(pointer).record("customCommon") }
private func defaultReady(_ pointer: UnsafeMutableRawPointer?, _ value: UInt32) {
    callbackContext(pointer).record("defaultReady", value: value)
}
private func customReady(_ pointer: UnsafeMutableRawPointer?, _ value: UInt32) {
    callbackContext(pointer).record("customReady", value: value)
}

private final class RNGCallbackTestContext {
    let trace = RNGTestTrace()
    var slots: [RNGCallbackID: RNGCallback] = [:]
    var ready: RNGReadyDataCallback?
    var writes: [String] = []
    var events: [String] = []
    var lastReadyValue: UInt32?
    var onCallback: ((String) -> Void)?

    func record(_ event: String, value: UInt32? = nil) {
        events.append(event)
        if let value { lastReadyValue = value }
        trace.accesses.append(.callback(event))
        onCallback?(event)
    }

    func makeRegistered() -> RNGRegistered<RNGTestIO, RNGTestIO, RNGCallbackTestIO> {
        RNGRegistered(core: trace.makeRNG(), callbacks: RNGCallbackTestIO(storage: self), defaults: .init(
            error: defaultError, mspInitialize: defaultMSPInit,
            mspDeinitialize: defaultMSPDeinit, readyData: defaultReady
        ))
    }
}

private struct RNGCallbackTestIO: RNGCallbackIO {
    let storage: RNGCallbackTestContext
    var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(storage).toOpaque() }
    func read(_ id: RNGCallbackID) -> RNGCallback? { storage.slots[id] }
    func write(_ id: RNGCallbackID, value: RNGCallback?) {
        storage.writes.append("\(id.rawValue):\(value == nil ? "nil" : "set")")
        storage.slots[id] = value
    }
    func readReadyDataCallback() -> RNGReadyDataCallback? { storage.ready }
    func writeReadyDataCallback(_ callback: RNGReadyDataCallback?) {
        storage.writes.append("3:\(callback == nil ? "nil" : "set")")
        storage.ready = callback
    }
}

final class RNGCallbackTests: XCTestCase {
    func testResetInitializationInstallsDefaultsAfterUnlockAndPreservesCustomMSP() {
        for customMSP in [false, true] {
            let context = RNGCallbackTestContext()
            let rng = context.makeRegistered()
            context.slots[.error] = customCommon
            context.ready = customReady
            if customMSP { context.slots[.mspInitialize] = customCommon }
            context.trace.words[.lock] = 1
            context.onCallback = { event in
                XCTAssertEqual(event, customMSP ? "customCommon" : "defaultInit")
                XCTAssertEqual(context.trace.words[.lock], 0)
                XCTAssertEqual(context.trace.words[.state, default: 0], 0)
                XCTAssertEqual(context.writes, customMSP ? ["3:set", "0:set"] : ["3:set", "0:set", "1:set"])
                XCTAssertTrue(context.trace.peripheralAccesses.isEmpty)
                context.trace.words[.clockErrorDetection] = 0x20
            }
            XCTAssertEqual(rng.initialize(getTick: context.trace.getTick), .ok)
            context.onCallback = nil
            XCTAssertEqual(rng.getState(), .ready)
            XCTAssertEqual(context.trace.registers[.cr]! & 0x20, 0x20)
            context.slots[.error]!(rng.callbacks.context)
            context.ready!(rng.callbacks.context, 0xCAFE)
            XCTAssertEqual(context.events.suffix(2), ["defaultError", "defaultReady"])
            XCTAssertEqual(context.lastReadyValue, 0xCAFE)
            context.writes = []
            context.events = []
            XCTAssertEqual(rng.initialize(getTick: context.trace.getTick), .ok)
            XCTAssertTrue(context.writes.isEmpty)
            XCTAssertTrue(context.events.isEmpty)
        }
    }

    func testDeinitializeInstallsOnlyMissingMSPAndCallsBeforeStateReset() {
        for customMSP in [false, true] {
            let context = RNGCallbackTestContext()
            let rng = context.makeRegistered()
            context.trace.words = [.state: 2, .lock: 1, .errorCode: 0x10]
            context.slots[.error] = customCommon
            context.ready = customReady
            if customMSP { context.slots[.mspDeinitialize] = customCommon }
            context.onCallback = { event in
                XCTAssertEqual(event, customMSP ? "customCommon" : "defaultDeinit")
                XCTAssertEqual(rng.getState(), .busy)
                XCTAssertEqual(rng.getError(), .clock)
                XCTAssertEqual(context.trace.words[.lock], 1)
                XCTAssertEqual(context.trace.registers[.cr]! & 12, 0)
            }
            XCTAssertEqual(rng.deinitialize(getTick: context.trace.getTick), .ok)
            context.onCallback = nil
            XCTAssertEqual(context.writes, customMSP ? [] : ["2:set"])
            XCTAssertEqual(rng.getState(), .reset)
            XCTAssertEqual(rng.getError(), [])
            XCTAssertEqual(context.trace.words[.lock], 0)
            context.slots[.error]!(rng.callbacks.context)
            context.ready!(rng.callbacks.context, 1)
            XCTAssertEqual(context.events.suffix(2), ["customCommon", "customReady"])
        }
    }

    func testCommonRegistrationStateIDMatrixNeverAcquiresLock() {
        for state in RNGState.allCases {
            for id in UInt32(0)...3 {
                for lock in UInt32(0)...1 {
                    let context = RNGCallbackTestContext()
                    let rng = context.makeRegistered()
                    context.trace.words = [.state: state.rawValue, .lock: lock, .errorCode: 0x10]
                    let allowed = (state == .ready && id <= 2) || (state == .reset && (id == 1 || id == 2))
                    XCTAssertEqual(rng.registerCallback(id: id, callback: customCommon), allowed ? .ok : .error)
                    XCTAssertEqual(context.trace.words[.lock], lock)
                    XCTAssertEqual(context.trace.words[.state], state.rawValue)
                    XCTAssertEqual(context.trace.words[.errorCode], allowed ? 0x10 : 1)
                    XCTAssertEqual(context.writes, allowed ? ["\(id):set"] : [])
                    XCTAssertFalse(context.trace.accesses.contains { if case .state(.lock, _) = $0 { return true }; return false })
                    if allowed {
                        context.slots[RNGCallbackID(rawValue: id)!]!(rng.callbacks.context)
                        XCTAssertEqual(context.events, ["customCommon"])
                    }
                }
            }
        }
    }

    func testCommonUnregistrationRestoresCorrespondingDefaultAndPreservesOtherSlots() {
        for state in RNGState.allCases {
            for id in UInt32(0)...3 {
                let context = RNGCallbackTestContext()
                let rng = context.makeRegistered()
                context.trace.words = [.state: state.rawValue, .lock: 1, .errorCode: 0x10]
                context.slots = [.error: customCommon, .mspInitialize: customCommon, .mspDeinitialize: customCommon]
                context.ready = customReady
                let allowed = (state == .ready && id <= 2) || (state == .reset && (id == 1 || id == 2))
                XCTAssertEqual(rng.unregisterCallback(id: id), allowed ? .ok : .error)
                XCTAssertEqual(context.trace.words[.lock], 1)
                XCTAssertEqual(context.trace.words[.errorCode], allowed ? 0x10 : 1)
                XCTAssertEqual(context.writes, allowed ? ["\(id):set"] : [])
                for slot in RNGCallbackID.allCases {
                    context.slots[slot]!(rng.callbacks.context)
                    let defaultName = ["defaultError", "defaultInit", "defaultDeinit"][Int(slot.rawValue)]
                    XCTAssertEqual(context.events.last, allowed && slot.rawValue == id ? defaultName : "customCommon")
                }
                context.ready!(rng.callbacks.context, 5)
                XCTAssertEqual(context.events.last, "customReady")
            }
        }
    }

    func testNilCommonAndReadyCallbacksReportInvalidBeforeAnyLockCheck() {
        let context = RNGCallbackTestContext()
        let rng = context.makeRegistered()
        context.trace.words = [.state: 2, .lock: 1, .errorCode: 0x10]
        XCTAssertEqual(rng.registerCallback(id: .error, callback: nil), .error)
        XCTAssertEqual(rng.getError(), .invalidCallback)
        context.trace.words[.errorCode] = 0x10
        XCTAssertEqual(rng.registerReadyDataCallback(nil), .error)
        XCTAssertEqual(rng.getError(), .invalidCallback)
        XCTAssertEqual(context.trace.words[.lock], 1)
        XCTAssertTrue(context.writes.isEmpty)
        XCTAssertEqual(context.trace.accesses, [.state(.errorCode, 1), .state(.errorCode, 1)])
    }

    func testReadyRegistrationAndUnregistrationStateLockMatrix() {
        for unregister in [false, true] {
            for state in RNGState.allCases {
                for lock in UInt32(0)...1 {
                    let context = RNGCallbackTestContext()
                    let rng = context.makeRegistered()
                    context.trace.words = [.state: state.rawValue, .lock: lock, .errorCode: 0x10]
                    if unregister { context.ready = customReady } else { context.ready = defaultReady }
                    let status = unregister ? rng.unregisterReadyDataCallback() : rng.registerReadyDataCallback(customReady)
                    let expected: HALStatus = lock == 1 ? .busy : (state == .ready ? .ok : .error)
                    XCTAssertEqual(status, expected)
                    XCTAssertEqual(context.trace.words[.lock], lock)
                    XCTAssertEqual(context.trace.words[.state], state.rawValue)
                    XCTAssertEqual(context.trace.words[.errorCode], expected == .error ? 1 : 0x10)
                    XCTAssertEqual(context.writes, expected == .ok ? ["3:set"] : [])
                    context.ready!(rng.callbacks.context, 0x1234)
                    let switched = expected == .ok
                    XCTAssertEqual(context.events.last, unregister == switched ? "defaultReady" : "customReady")
                    if lock == 1 { XCTAssertEqual(context.trace.accesses, [.callback(context.events.last!)]) }
                }
            }
        }
    }

    func testRegisteredReadyCallbackCanRearmThroughImmutableWrapper() {
        let context = RNGCallbackTestContext()
        let rng = context.makeRegistered()
        XCTAssertEqual(rng.initialize(getTick: context.trace.getTick), .ok)
        XCTAssertEqual(rng.registerReadyDataCallback(customReady), .ok)
        XCTAssertEqual(rng.generateRandomNumberInterrupt(), .ok)
        context.onCallback = { event in
            XCTAssertEqual(event, "customReady")
            XCTAssertEqual(rng.getState(), .ready)
            XCTAssertEqual(context.trace.words[.lock], 0)
            XCTAssertEqual(rng.readLastRandomNumber(), 0x1234_5678)
            XCTAssertEqual(rng.generateRandomNumberInterrupt(), .ok)
        }
        rng.handleInterrupt()
        context.onCallback = nil
        XCTAssertEqual(context.lastReadyValue, 0x1234_5678)
        XCTAssertEqual(rng.getState(), .busy)
        XCTAssertEqual(context.trace.words[.lock], 1)
        XCTAssertEqual(context.trace.registers[.cr]! & 8, 8)
    }

    func testRegisteredErrorCallbackSeesStateAndLockBeforeFlagsAreCleared() {
        let context = RNGCallbackTestContext()
        let rng = context.makeRegistered()
        XCTAssertEqual(rng.initialize(getTick: context.trace.getTick), .ok)
        XCTAssertEqual(rng.registerCallback(id: .error, callback: customCommon), .ok)
        XCTAssertEqual(rng.generateRandomNumberInterrupt(), .ok)
        context.trace.registers[.sr] = 0x21
        context.onCallback = { event in
            XCTAssertEqual(event, "customCommon")
            XCTAssertEqual(rng.getState(), .error)
            XCTAssertEqual(rng.getError(), .clock)
            XCTAssertEqual(context.trace.words[.lock], 1)
            XCTAssertEqual(context.trace.registers[.sr], 0x21)
        }
        rng.handleInterrupt()
        context.onCallback = nil
        XCTAssertEqual(context.trace.registers[.sr], 1)
        XCTAssertEqual(context.trace.accesses.suffix(2), [.callback("customCommon"), .write(.sr, 0xFFFF_FF9F)])
    }

    func testRecoveryUsesRegisteredErrorCallbackBeforeReplacingTimeoutError() {
        let context = RNGCallbackTestContext()
        let rng = context.makeRegistered()
        XCTAssertEqual(rng.initialize(getTick: context.trace.getTick), .ok)
        XCTAssertEqual(rng.registerCallback(id: .error, callback: customCommon), .ok)
        context.trace.registers[.sr] = 0x44
        context.trace.holdConditionReset = true
        context.trace.words[.errorCode] = 0x18
        context.onCallback = { event in
            XCTAssertEqual(event, "customCommon")
            XCTAssertEqual(rng.getState(), .ready)
            XCTAssertEqual(rng.getError().rawValue, 0x1A)
            XCTAssertEqual(context.trace.words[.lock], 0)
        }
        XCTAssertEqual(rng.recoverSeedError(), .error)
        context.onCallback = nil
        XCTAssertEqual(rng.getError(), .recoverSeed)
        XCTAssertEqual(context.trace.accesses.suffix(2), [.callback("customCommon"), .state(.errorCode, 0x20)])
    }

    func testResetHandleMacroNullsOnlyMSPCallbacksInSourceOrder() {
        let context = RNGCallbackTestContext()
        let rng = context.makeRegistered()
        context.trace.words = [.state: 4, .lock: 1, .errorCode: 0x10, .randomNumber: 123]
        context.slots = [.error: customCommon, .mspInitialize: customCommon, .mspDeinitialize: customCommon]
        context.ready = customReady
        rng.resetHandleState()
        XCTAssertEqual(context.writes, ["1:nil", "2:nil"])
        XCTAssertNil(context.slots[.mspInitialize])
        XCTAssertNil(context.slots[.mspDeinitialize])
        XCTAssertEqual(rng.getState(), .reset)
        XCTAssertEqual(rng.getError(), .clock)
        XCTAssertEqual(context.trace.words[.lock], 1)
        XCTAssertEqual(rng.readLastRandomNumber(), 123)
        context.slots[.error]!(rng.callbacks.context)
        context.ready!(rng.callbacks.context, 9)
        XCTAssertEqual(context.events, ["customCommon", "customReady"])
    }
}
