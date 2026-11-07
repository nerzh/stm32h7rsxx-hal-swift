import XCTest
@testable import STM32H7RSHAL

enum RNGTestAccess: Equatable {
    case read(RNGRegister)
    case write(RNGRegister, UInt32)
    case state(RNGHandleWord, UInt32)
    case tick(UInt32)
    case callback(String)
}

final class RNGTestTrace {
    var registers: [RNGRegister: UInt32] = [.cr: 0, .sr: 1, .dr: 0x1234_5678, .htcr: 0]
    var words: [RNGHandleWord: UInt32] = [:]
    var accesses: [RNGTestAccess] = []
    var scriptedReads: [RNGRegister: [UInt32]] = [:]
    var tickValues: [UInt32] = []
    var tick: UInt32 = 0
    var tickStep: UInt32 = 1
    var holdConditionReset = false
    var autoRecoverSeed = false
    var seedErrorOnDataRead = false
    var onTick: (() -> Void)?

    var peripheralAccesses: [RNGTestAccess] {
        accesses.filter {
            switch $0 { case .read, .write: return true; default: return false }
        }
    }

    func makeRNG() -> RNG<RNGTestIO, RNGTestIO> {
        let io = RNGTestIO(trace: self)
        return RNG(registers: io, state: io)
    }

    func getTick() -> UInt32 {
        let value = tickValues.isEmpty ? tick : tickValues.removeFirst()
        tick &+= tickStep
        accesses.append(.tick(value))
        if let action = onTick {
            onTick = nil
            action()
        }
        return value
    }
}

struct RNGTestIO: RNGRegisterIO, RNGStateIO {
    let trace: RNGTestTrace

    func read(_ register: RNGRegister) -> UInt32 {
        trace.accesses.append(.read(register))
        let result: UInt32
        if trace.scriptedReads[register]?.isEmpty == false {
            result = trace.scriptedReads[register]!.removeFirst()
        } else {
            result = trace.registers[register, default: 0]
                | (register == .cr && trace.holdConditionReset ? 0x4000_0000 : 0)
        }
        if register == .dr {
            trace.registers[.sr, default: 0] &= ~UInt32(1)
            if trace.seedErrorOnDataRead { trace.registers[.sr, default: 0] |= 0x40 }
        }
        return result
    }

    func write(_ register: RNGRegister, value: UInt32) {
        trace.accesses.append(.write(register, value))
        if register == .sr {
            // Error interrupt flags are cleared by writing zero; status bits
            // remain hardware-owned. Tests inject them through registers directly.
            let old = trace.registers[.sr, default: 0]
            trace.registers[.sr] = (old & ~UInt32(0x60)) | (old & value & 0x60)
        } else {
            if register == .cr, trace.autoRecoverSeed,
               trace.registers[.cr, default: 0] & 0x4000_0000 != 0, value & 0x4000_0000 == 0 {
                trace.registers[.sr, default: 0] &= ~UInt32(4)
            }
            trace.registers[register] = value
        }
    }

    func read(_ word: RNGHandleWord) -> UInt32 { trace.words[word, default: 0] }
    func write(_ word: RNGHandleWord, value: UInt32) {
        trace.accesses.append(.state(word, value))
        trace.words[word] = value
    }
}

final class RNGTests: XCTestCase {
    func testInitializeMSPTimingAndLiveClockDetectionConfiguration() {
        let trace = RNGTestTrace()
        trace.registers[.cr] = 0x8000_000C
        trace.words[.lock] = 1
        trace.words[.errorCode] = 0x10
        let rng = trace.makeRNG()
        XCTAssertEqual(rng.initialize(getTick: trace.getTick) { handle in
            XCTAssertEqual(handle.getState(), .reset)
            XCTAssertEqual(trace.words[.lock], 0)
            XCTAssertEqual(trace.accesses, [.state(.lock, 0)])
            handle.state.write(.clockErrorDetection, value: 0x20)
            trace.accesses.append(.callback("init"))
        }, .ok)
        XCTAssertEqual(trace.peripheralAccesses, [
            .read(.cr), .write(.cr, 0x8000_0008),
            .read(.cr), .write(.cr, 0xC000_0028),
            .read(.cr), .write(.cr, 0x8000_0028), .read(.cr),
            .read(.cr), .write(.cr, 0x8000_002C), .read(.sr), .read(.sr),
        ])
        XCTAssertEqual(rng.getState(), .ready)
        XCTAssertEqual(rng.getError(), [])
        XCTAssertEqual(trace.words[.lock], 0)
        XCTAssertEqual(rng.initialize(getTick: trace.getTick) { _ in XCTFail("MSP only in RESET") }, .ok)
    }

    func testInitializationDistinguishesThreeFailureBranches() {
        let condition = RNGTestTrace()
        condition.holdConditionReset = true
        condition.words = [.state: 1, .lock: 1, .errorCode: 0x10]
        condition.tickValues = [0, 11]
        XCTAssertEqual(condition.makeRNG().initialize(getTick: condition.getTick), .error)
        XCTAssertEqual(condition.words[.state], 1)
        XCTAssertEqual(condition.words[.lock], 1) // Init timeout does not unlock.
        XCTAssertEqual(condition.words[.errorCode], 2)

        let seed = RNGTestTrace()
        seed.registers[.sr] = 0x41
        seed.words[.errorCode] = 0x10
        XCTAssertEqual(seed.makeRNG().initialize(getTick: seed.getTick), .error)
        XCTAssertEqual(seed.words[.state], 4)
        XCTAssertEqual(seed.words[.errorCode], 0x10) // Seed failure does not assign ErrorCode.

        let data = RNGTestTrace()
        data.registers[.sr] = 0
        data.tickValues = [100, 200, 211]
        XCTAssertEqual(data.makeRNG().initialize(getTick: data.getTick), .error)
        XCTAssertEqual(data.words[.state], 4)
        XCTAssertEqual(data.words[.errorCode], 2)
        XCTAssertFalse(data.peripheralAccesses.contains(.read(.dr)))
    }

    func testTimeoutRecheckAndTickWrapAllowDataArrivingAfterDeadline() {
        let trace = RNGTestTrace()
        trace.words[.state] = 1
        // SEIS check, initial DRDY check, timeout recheck, next loop check,
        // final SEIS check after DR. A ready timeout recheck must not return error.
        trace.scriptedReads[.sr] = [0, 0, 1, 1, 0]
        trace.tickValues = [UInt32.max - 5, 6]
        var output: UInt32 = 0xFFFF_FFFF
        XCTAssertEqual(trace.makeRNG().generateRandomNumber(&output, getTick: trace.getTick), .ok)
        XCTAssertEqual(output, 0x1234_5678)
        XCTAssertEqual(trace.words[.state], 1)
        XCTAssertEqual(trace.words[.lock], 0)
        XCTAssertNil(trace.words[.errorCode])
        XCTAssertEqual(trace.peripheralAccesses, [
            .read(.sr), .read(.sr), .read(.sr), .read(.sr), .read(.dr), .read(.sr),
        ])
    }

    func testPollLockedNonReadyAndLateSeedErrorsLeaveCallerOutputUntouched() {
        let trace = RNGTestTrace()
        let rng = trace.makeRNG()
        trace.words = [.state: 1, .lock: 1, .errorCode: 0x10]
        var output: UInt32 = 0xDEAD_BEEF
        XCTAssertEqual(rng.generateRandomNumber(&output, getTick: trace.getTick), .busy)
        XCTAssertTrue(trace.accesses.isEmpty)
        XCTAssertEqual(rng.getError(), .clock)
        trace.words[.lock] = 0
        trace.words[.state] = 4
        XCTAssertEqual(rng.generateRandomNumber(&output, getTick: trace.getTick), .error)
        XCTAssertEqual(trace.words[.errorCode], 4)
        XCTAssertEqual(trace.words[.state], 4)
        XCTAssertEqual(trace.words[.lock], 0)
        XCTAssertEqual(output, 0xDEAD_BEEF)
        trace.words[.state] = 1
        trace.seedErrorOnDataRead = true
        XCTAssertEqual(rng.generateRandomNumber(&output, getTick: trace.getTick), .error)
        XCTAssertEqual(output, 0xDEAD_BEEF)
        XCTAssertEqual(rng.readLastRandomNumber(), 0x1234_5678)
        XCTAssertEqual(rng.getState(), .ready)
        XCTAssertEqual(rng.getError(), .seed)
        XCTAssertEqual(trace.words[.lock], 0)
    }

    func testPollingTimeoutIsStrictlyGreaterThanTenAndReturnsErrorNotTimeout() {
        let trace = RNGTestTrace()
        trace.words[.state] = 1
        trace.registers[.sr] = 0
        trace.tickValues = [0, 10, 11]
        var output: UInt32 = 9
        XCTAssertEqual(trace.makeRNG().generateRandomNumber(&output, getTick: trace.getTick), .error)
        XCTAssertEqual(output, 9)
        XCTAssertEqual(trace.words[.state], 1)
        XCTAssertEqual(trace.words[.errorCode], 2)
        XCTAssertEqual(trace.words[.lock], 0)
        XCTAssertEqual(trace.peripheralAccesses, [.read(.sr), .read(.sr), .read(.sr), .read(.sr)])
    }

    func testSuccessfulPollDoesNotClearPreexistingError() {
        let trace = RNGTestTrace()
        trace.words = [.state: 1, .errorCode: 0x10]
        var output: UInt32 = 0
        XCTAssertEqual(trace.makeRNG().generateRandomNumber(&output, getTick: trace.getTick), .ok)
        XCTAssertEqual(output, 0x1234_5678)
        XCTAssertEqual(trace.words[.errorCode], 0x10)
    }

    func testInterruptStartKeepsLockUntilReadyCallbackWhichMayRearm() {
        let trace = RNGTestTrace()
        trace.words[.state] = 1
        trace.registers[.cr] = 4
        let rng = trace.makeRNG()
        XCTAssertEqual(rng.generateRandomNumberInterrupt(), .ok)
        XCTAssertEqual(trace.words[.state], 2)
        XCTAssertEqual(trace.words[.lock], 1)
        XCTAssertEqual(trace.registers[.cr], 12)
        XCTAssertEqual(rng.generateRandomNumberInterrupt(), .busy)
        rng.handleInterrupt(readyDataCallback: { handle, value in
            XCTAssertEqual(value, 0x1234_5678)
            XCTAssertEqual(handle.readLastRandomNumber(), value)
            XCTAssertEqual(handle.getState(), .ready)
            XCTAssertEqual(trace.words[.lock], 0)
            XCTAssertEqual(trace.registers[.cr], 4)
            XCTAssertEqual(handle.generateRandomNumberInterrupt(), .ok)
        })
        XCTAssertEqual(rng.getState(), .busy)
        XCTAssertEqual(trace.words[.lock], 1)
        XCTAssertEqual(trace.registers[.cr], 12)
    }

    func testInterruptNonReadySetsErrorAndUnlocksOnlyAfterAcquiringLock() {
        for state in RNGState.allCases where state != .ready {
            let trace = RNGTestTrace()
            trace.words = [.state: state.rawValue, .errorCode: 0x10]
            XCTAssertEqual(trace.makeRNG().generateRandomNumberInterrupt(), .error)
            XCTAssertEqual(trace.words[.state], state.rawValue)
            XCTAssertEqual(trace.words[.errorCode], 4)
            XCTAssertEqual(trace.words[.lock], 0)
            XCTAssertTrue(trace.peripheralAccesses.isEmpty)
        }
    }

    func testInterruptClockErrorTakesPriorityAndClearsFlagsAfterCallback() {
        let trace = RNGTestTrace()
        trace.words = [.state: 2, .lock: 1]
        trace.registers[.cr] = 12
        trace.registers[.sr] = 0x65 // Clock + seed + SECS + DRDY.
        let rng = trace.makeRNG()
        rng.handleInterrupt(readyDataCallback: { _, _ in XCTFail("No DR on error") }, errorCallback: { handle in
            XCTAssertEqual(handle.getState(), .error)
            XCTAssertEqual(handle.getError(), .clock)
            XCTAssertEqual(trace.words[.lock], 1)
            XCTAssertEqual(trace.registers[.cr], 12) // Clock error leaves IE enabled.
            XCTAssertEqual(trace.peripheralAccesses, [.read(.sr)])
            trace.accesses.append(.callback("error"))
        })
        XCTAssertEqual(trace.accesses.suffix(2), [.callback("error"), .write(.sr, 0xFFFF_FF9F)])
        XCTAssertEqual(trace.words[.lock], 1)
        XCTAssertFalse(trace.peripheralAccesses.contains(.read(.dr)))
    }

    func testInterruptSeedFailureDisablesInterruptAndAutoRecoveryUsesOriginalSnapshot() {
        let failed = RNGTestTrace()
        failed.words = [.state: 2, .lock: 1]
        failed.registers[.cr] = 12
        failed.registers[.sr] = 0x45
        failed.makeRNG().handleInterrupt(errorCallback: { handle in
            XCTAssertEqual(handle.getError(), .seed)
            XCTAssertEqual(failed.registers[.cr], 4)
        })
        XCTAssertEqual(failed.peripheralAccesses, [
            .read(.sr), .read(.cr), .write(.cr, 4), .write(.sr, 0xFFFF_FF9F),
        ])
        XCTAssertEqual(failed.words[.lock], 1)

        let recovered = RNGTestTrace()
        recovered.words = [.state: 2, .lock: 1, .errorCode: 0x10]
        recovered.registers[.cr] = 12
        recovered.registers[.sr] = 0x41
        var ready = false
        recovered.makeRNG().handleInterrupt(readyDataCallback: { handle, _ in
            ready = true
            XCTAssertEqual(handle.getError(), .clock)
        }, errorCallback: { _ in XCTFail("Auto-recovered seed does not call error hook") })
        XCTAssertTrue(ready)
        XCTAssertEqual(recovered.peripheralAccesses, [
            .read(.sr), .read(.sr), .write(.sr, 1), .read(.cr), .write(.cr, 4), .read(.dr),
        ])
        XCTAssertEqual(recovered.words[.lock], 0)
    }

    func testDataReadyWhileAlreadyErrorStillReadsDRWithoutUnlockingOrCallback() {
        let trace = RNGTestTrace()
        trace.words = [.state: 4, .lock: 1]
        trace.registers[.cr] = 12
        trace.makeRNG().handleInterrupt(readyDataCallback: { _, _ in XCTFail("State is ERROR") })
        XCTAssertEqual(trace.peripheralAccesses, [.read(.sr), .read(.cr), .write(.cr, 4), .read(.dr)])
        XCTAssertEqual(trace.words[.randomNumber], 0x1234_5678)
        XCTAssertEqual(trace.words[.state], 4)
        XCTAssertEqual(trace.words[.lock], 1)
    }

    func testRecoverSuccessRemainsBusyAndClearsOnlySeedError() {
        for fullRecovery in [false, true] {
            let trace = RNGTestTrace()
            trace.words = [.state: 1, .lock: 1, .errorCode: 0x18]
            trace.registers[.sr] = fullRecovery ? 0x44 : 0x40
            trace.autoRecoverSeed = true
            let rng = trace.makeRNG()
            XCTAssertEqual(rng.recoverSeedError { _ in XCTFail("Successful recovery") }, .ok)
            XCTAssertEqual(rng.getState(), .busy) // Preserve the upstream RNGEx behavior.
            XCTAssertEqual(rng.getError(), .clock)
            XCTAssertEqual(trace.words[.lock], 1)
            XCTAssertFalse(trace.accesses.contains { if case .tick = $0 { return true }; return false })
            XCTAssertEqual(trace.registers[.sr], 0)
        }
    }

    func testRecoverTimeoutCallsHookBeforeOuterErrorOverwriteWithNineConditionReads() {
        for conditionTimeout in [false, true] {
            let trace = RNGTestTrace()
            trace.words = [.state: 1, .lock: 1, .errorCode: 0x18]
            trace.registers[.sr] = 0x44
            trace.holdConditionReset = conditionTimeout
            var callbackCount = 0
            let rng = trace.makeRNG()
            XCTAssertEqual(rng.recoverSeedError { handle in
                callbackCount += 1
                XCTAssertEqual(handle.getState(), .ready)
                XCTAssertEqual(handle.getError().rawValue, 0x1A)
                XCTAssertEqual(trace.words[.lock], 0)
                trace.accesses.append(.callback("recover"))
            }, .error)
            XCTAssertEqual(callbackCount, 1)
            XCTAssertEqual(rng.getState(), .ready)
            XCTAssertEqual(rng.getError(), .recoverSeed)
            XCTAssertEqual(trace.accesses.suffix(2), [.callback("recover"), .state(.errorCode, 0x20)])
            let reads = trace.peripheralAccesses.filter { $0 == .read(conditionTimeout ? .cr : .sr) }.count
            // Two CR RMW reads plus nine condition reads; or initial SECS,
            // SEIS check, clear-SEIS RMW, then nine SECS condition reads.
            XCTAssertEqual(reads, conditionTimeout ? 11 : 12)
            XCTAssertFalse(trace.accesses.contains { if case .tick = $0 { return true }; return false })
        }
    }

    func testPollingRecoveryFailureOverwritesErrorButPreservesCallbackReentry() {
        let trace = RNGTestTrace()
        trace.words[.state] = 1
        trace.registers[.sr] = 0x44
        trace.holdConditionReset = true
        let rng = trace.makeRNG()
        var output: UInt32 = 0xDEAD_BEEF
        XCTAssertEqual(rng.generateRandomNumber(&output, getTick: trace.getTick) { handle in
            XCTAssertEqual(handle.getError().rawValue, 0x0A)
            XCTAssertEqual(handle.generateRandomNumberInterrupt(), .ok)
        }, .error)
        XCTAssertEqual(output, 0xDEAD_BEEF)
        XCTAssertEqual(rng.getState(), .busy)
        XCTAssertEqual(trace.words[.lock], 1)
        XCTAssertEqual(rng.getError(), .recoverSeed)
        XCTAssertFalse(trace.accesses.contains { if case .tick = $0 { return true }; return false })
    }

    func testConfigurationWriteMasksReadOrderAndUnvalidatedHealthTest() {
        let trace = RNGTestTrace()
        trace.words = [.state: 1, .lock: 1, .errorCode: 0x10]
        trace.registers[.cr] = 0xBC00_007C
        let rng = trace.makeRNG()
        let configuration = RNGConfiguration(config1: 0x25, config2: 5, config3: 9,
            clockDivider: 0x000B_0000, nistCompliance: 0x1000, autoReset: 0x80, healthTest: 0xFFFF_FFFF)
        XCTAssertEqual(rng.setConfig(configuration, getTick: trace.getTick), .ok)
        XCTAssertEqual(trace.peripheralAccesses, [
            .read(.cr), .write(.cr, 0xBC00_0078), .read(.cr), .write(.cr, 0xFE5B_B9F8),
            .write(.htcr, 0xFFFF_FFFF), .read(.cr), .write(.cr, 0xBE5B_B9F8), .read(.cr),
            .read(.cr), .write(.cr, 0xBE5B_B9FC),
        ])
        XCTAssertEqual(rng.getError(), .clock)
        XCTAssertEqual(trace.words[.lock], 1) // RNGEx configuration does not lock/unlock.
        trace.accesses = []
        var output = RNGConfiguration()
        XCTAssertEqual(rng.getConfig(&output), .ok)
        XCTAssertEqual(output, configuration)
        XCTAssertEqual(trace.peripheralAccesses, [
            .read(.cr), .read(.cr), .read(.cr), .read(.cr), .read(.cr), .read(.cr), .read(.htcr),
        ])
        XCTAssertEqual(rng.lockConfig(), .ok)
        XCTAssertEqual(trace.registers[.cr]! & 0x8000_0000, 0x8000_0000)
    }

    func testConfigurationNilBusyAndStrictTwoTickTimeoutSemantics() {
        let trace = RNGTestTrace()
        let rng = trace.makeRNG()
        var absent: RNGConfiguration?
        XCTAssertEqual(rng.setConfig(nil, getTick: trace.getTick), .error)
        XCTAssertEqual(rng.getConfig(&absent), .error)
        XCTAssertTrue(trace.accesses.isEmpty)
        trace.words[.errorCode] = 0x10
        var value = RNGConfiguration(healthTest: 0x1234)
        XCTAssertEqual(rng.getConfig(&value), .error)
        XCTAssertEqual(value.healthTest, 0x1234)
        XCTAssertEqual(rng.getError().rawValue, 0x14)
        XCTAssertEqual(rng.setConfig(value, getTick: trace.getTick), .error)
        XCTAssertEqual(rng.getError(), .busy)
        trace.words[.errorCode] = 0x10
        XCTAssertEqual(rng.lockConfig(), .error)
        XCTAssertEqual(rng.getError(), .busy)
        trace.words = [.state: 1, .lock: 1]
        trace.holdConditionReset = true
        trace.tickValues = [0, 2, 3]
        XCTAssertEqual(rng.setConfig(value, getTick: trace.getTick), .error)
        XCTAssertEqual(rng.getState(), .ready)
        XCTAssertEqual(rng.getError(), .timeout)
        XCTAssertEqual(trace.words[.lock], 1)
        XCTAssertEqual(trace.accesses.filter { if case .tick = $0 { return true }; return false }, [
            .tick(0), .tick(2), .tick(3),
        ])
    }

    func testDeinitializeRunsWhileBusyAndMSPSeesOldStateBeforeFinalReset() {
        let trace = RNGTestTrace()
        trace.words = [.state: 2, .lock: 1, .errorCode: 0x10, .randomNumber: 0xCAFE_BABE]
        trace.registers[.cr] = 0x2C
        trace.registers[.sr] = 0x65
        let rng = trace.makeRNG()
        XCTAssertEqual(rng.deinitialize(getTick: trace.getTick) { handle in
            XCTAssertEqual(handle.getState(), .busy)
            XCTAssertEqual(handle.getError(), .clock)
            XCTAssertEqual(trace.words[.lock], 1)
            XCTAssertEqual(trace.registers[.cr], 0)
            XCTAssertEqual(trace.registers[.sr], 5)
        }, .ok)
        XCTAssertEqual(rng.getState(), .reset)
        XCTAssertEqual(rng.getError(), [])
        XCTAssertEqual(trace.words[.lock], 0)
        XCTAssertEqual(rng.readLastRandomNumber(), 0xCAFE_BABE)
        XCTAssertEqual(trace.peripheralAccesses, [
            .read(.cr), .write(.cr, 0x4000_000C), .read(.cr), .write(.cr, 12), .read(.cr),
            .read(.cr), .write(.cr, 0), .read(.sr), .write(.sr, 5),
        ])
    }

    func testDeinitializeTimeoutUnlocksWithoutInvokingMSP() {
        let trace = RNGTestTrace()
        trace.words = [.state: 2, .lock: 1]
        trace.holdConditionReset = true
        trace.tickValues = [0, 11]
        XCTAssertEqual(trace.makeRNG().deinitialize(getTick: trace.getTick) { _ in XCTFail("Timed out first") }, .error)
        XCTAssertEqual(trace.words[.state], 1)
        XCTAssertEqual(trace.words[.errorCode], 2)
        XCTAssertEqual(trace.words[.lock], 0)
    }

    func testImmutableCopiesShareLiveStateAndCanBeUsedFromTickInterrupt() {
        let trace = RNGTestTrace()
        trace.words[.state] = 1
        let foreground = trace.makeRNG()
        let interruptCopy = foreground
        trace.onTick = {
            XCTAssertEqual(interruptCopy.getState(), .busy)
            XCTAssertEqual(interruptCopy.generateRandomNumberInterrupt(), .busy)
        }
        var output: UInt32 = 0
        XCTAssertEqual(foreground.generateRandomNumber(&output, getTick: trace.getTick), .ok)
        XCTAssertEqual(interruptCopy.readLastRandomNumber(), output)
        XCTAssertEqual(interruptCopy.getState(), .ready)
    }

    func testRegisterMacrosUseW0CClearAndDummyClearFlagHasNoEffect() {
        let trace = RNGTestTrace()
        trace.registers[.sr] = 0x61
        trace.words = [.state: 4, .lock: 1, .errorCode: 0x10]
        let rng = trace.makeRNG()
        XCTAssertTrue(rng.getFlag(1))
        XCTAssertFalse(rng.getFlag(4))
        XCTAssertTrue(rng.getInterrupt(0x60))
        rng.clearFlag(0x60)
        XCTAssertEqual(trace.registers[.sr], 0x61)
        rng.clearInterrupt(0x60)
        XCTAssertEqual(trace.registers[.sr], 1)
        XCTAssertEqual(trace.peripheralAccesses, [.read(.sr), .read(.sr), .read(.sr), .write(.sr, 0xFFFF_FF9F)])
        rng.resetHandleState()
        XCTAssertEqual(rng.getState(), .reset)
        XCTAssertEqual(trace.words[.lock], 1)
        XCTAssertEqual(rng.getError(), .clock)
    }
}
