import XCTest
@testable import STM32H7RSHAL

private enum ICacheTraceEvent: Equatable {
    case read(ICacheRegister), write(ICacheRegister, UInt32), tick, callback(String)
}

private final class ICacheTraceIO: ICacheRegisterIO {
    var registers: [ICacheRegister: UInt32] = [:]
    var reads: [ICacheRegister: Int] = [:]
    var events: [ICacheTraceEvent] = []
    var ticks: UInt32 = 0
    var tickCalls = 0
    var onRead: ((ICacheTraceIO, ICacheRegister, Int) -> Void)?
    var onWrite: ((ICacheTraceIO, ICacheRegister, UInt32) -> Void)?
    var driver: ICache<ICacheTraceIO> { .init(registers: self) }
    func read(_ register: ICacheRegister) -> UInt32 {
        events.append(.read(register))
        reads[register, default: 0] += 1
        onRead?(self, register, reads[register, default: 0])
        return registers[register, default: 0]
    }
    func write(_ register: ICacheRegister, value: UInt32) {
        events.append(.write(register, value))
        registers[register] = value
        if register == .fcr { registers[.sr, default: 0] &= ~value }
        onWrite?(self, register, value)
    }
    func getTick() -> UInt32 {
        events.append(.tick)
        let result = ticks; ticks &+= 1; tickCalls += 1
        return result
    }
    var writes: [ICacheTraceEvent] { events.filter { if case .write = $0 { return true }; return false } }
}

final class ICacheTests: XCTestCase {
    func testAssociativityPreservesOtherBitsAndRejectsEnabledCache() {
        for mode: UInt32 in [0, 4] {
            for enabled in [false, true] {
                let io = ICacheTraceIO()
                io.registers[.cr] = enabled ? .max : .max - 1
                XCTAssertEqual(io.driver.configureAssociativity(mode), enabled ? .error : .ok)
                XCTAssertEqual(io.events, enabled ? [.read(.cr)] : [.read(.cr), .read(.cr), .write(.cr, 0xFFFF_FFFA | mode)])
            }
        }
    }

    func testDeinitializeWriteSequenceRestoresFourWaysAndPulsesBothMonitorResets() {
        let io = ICacheTraceIO()
        io.registers = [.cr: .max, .sr: 7, .ier: .max]
        XCTAssertEqual(io.driver.deinitialize(), .ok)
        XCTAssertEqual(io.events, [.write(.ier, 0), .write(.fcr, 6), .read(.cr), .write(.cr, 0xFFFF_FFFE),
            .write(.cr, 4), .read(.cr), .write(.cr, 4), .read(.cr), .write(.cr, 0xC0004),
            .read(.cr), .write(.cr, 4)])
        XCTAssertEqual(io.registers[.sr], 1)
        XCTAssertEqual(io.tickCalls, 0)
    }

    func testEnableDoesNotWaitForBusyAndIsEnabledReturnsBoolean() {
        let io = ICacheTraceIO()
        io.registers = [.cr: 0x1234, .sr: 7]
        XCTAssertEqual(io.driver.enable(), .ok)
        XCTAssertEqual(io.events, [.read(.cr), .write(.cr, 0x1235)])
        XCTAssertEqual(io.driver.isEnabled(), 1)
        io.registers[.cr] = 0xFFFF_FFFE
        XCTAssertEqual(io.driver.isEnabled(), 0)
        XCTAssertEqual(io.tickCalls, 0)
    }

    func testDisableClearsBusyEndBeforeENAndAlwaysCapturesTick() {
        let io = ICacheTraceIO()
        io.registers = [.cr: 0x30005, .sr: 7]
        XCTAssertEqual(io.driver.disable(getTick: io.getTick), .ok)
        XCTAssertEqual(io.events, [.write(.fcr, 2), .read(.cr), .write(.cr, 0x30004), .tick, .read(.cr)])
        XCTAssertEqual(io.registers[.sr], 5)
        XCTAssertEqual(io.tickCalls, 1)
    }

    func testDisableTimeoutBoundaryFinalRecheckAndTickWrap() {
        for start: UInt32 in [0, .max - 1] {
            for readyRead in 2...5 {
                let io = ICacheTraceIO()
                io.ticks = start; io.registers[.cr] = 5
                io.onWrite = { model, register, _ in
                    if register == .cr { model.registers[.cr, default: 0] |= 1 }
                }
                io.onRead = { model, register, count in
                    if register == .cr && count == readyRead { model.registers[.cr, default: 0] &= ~UInt32(1) }
                }
                XCTAssertEqual(io.driver.disable(getTick: io.getTick), readyRead <= 4 ? .ok : .timeout)
                XCTAssertEqual(io.tickCalls, min(readyRead - 1, 3))
                XCTAssertEqual(io.reads[.cr], readyRead == 4 ? 5 : min(readyRead, 4))
                XCTAssertEqual(io.writes, [.write(.fcr, 2), .write(.cr, 4)])
            }
        }
    }

    func testWaitSkipsTickWhenNotBusyButStillClearsBusyEnd() {
        for flags: UInt32 in [0, 2, 4, 6] {
            let io = ICacheTraceIO()
            io.registers[.sr] = flags
            XCTAssertEqual(io.driver.waitForInvalidateComplete(getTick: io.getTick), .ok)
            XCTAssertEqual(io.events, [.read(.sr), .write(.fcr, 2)])
            XCTAssertEqual(io.registers[.sr], flags & ~UInt32(2))
        }
        let io = ICacheTraceIO()
        io.registers[.sr] = 7
        XCTAssertEqual(io.driver.waitForInvalidateComplete(getTick: io.getTick), .ok)
        XCTAssertEqual(io.events, [.read(.sr), .tick, .read(.sr), .write(.fcr, 2)])
    }

    func testWaitTimeoutAndLateCompletionAlwaysClearBusyEnd() {
        for start: UInt32 in [0, .max - 1] {
            for completeRead in 2...5 {
                let io = ICacheTraceIO()
                io.ticks = start; io.registers[.sr] = 5
                io.onRead = { model, register, count in
                    if register == .sr && count == completeRead { model.registers[.sr, default: 0] |= 2 }
                }
                XCTAssertEqual(io.driver.waitForInvalidateComplete(getTick: io.getTick), completeRead <= 4 ? .ok : .timeout)
                XCTAssertEqual(io.tickCalls, min(completeRead - 1, 3))
                XCTAssertEqual(io.reads[.sr], completeRead == 4 ? 5 : min(completeRead, 4))
                XCTAssertEqual(io.writes, [.write(.fcr, 2)])
                XCTAssertEqual(io.registers[.sr], 5)
            }
        }
    }

    func testInvalidateBusyWaitsForExistingOperationAndIdleLaunchDoesNotPreclearFlag() {
        let busy = ICacheTraceIO()
        busy.registers[.sr] = 3
        XCTAssertEqual(busy.driver.invalidate(getTick: busy.getTick), .ok)
        XCTAssertEqual(busy.events, [.read(.sr), .read(.sr), .tick, .read(.sr), .write(.fcr, 2)])
        let idle = ICacheTraceIO()
        idle.registers = [.cr: 4, .sr: 2]
        XCTAssertEqual(idle.driver.invalidate(getTick: idle.getTick), .ok)
        XCTAssertEqual(idle.events, [.read(.sr), .read(.cr), .write(.cr, 6), .read(.sr), .write(.fcr, 2)])
        XCTAssertEqual(idle.tickCalls, 0)
    }

    func testInterruptInvalidateRejectsBusyAndOrdersClearEnableLaunch() {
        for flags in UInt32(0)..<8 {
            let io = ICacheTraceIO()
            io.registers = [.sr: flags, .ier: 4, .cr: 5]
            XCTAssertEqual(io.driver.invalidateInterrupt(), flags & 1 == 0 ? .ok : .error)
            XCTAssertEqual(io.events, flags & 1 != 0 ? [.read(.sr)] :
                [.read(.sr), .write(.fcr, 2), .read(.ier), .write(.ier, 6), .read(.cr), .write(.cr, 7)])
            XCTAssertEqual(io.tickCalls, 0)
        }
    }

    func testMonitorSelectionsOnlyChangeTheirEnableAndResetBits() {
        for monitor: UInt32 in [0x10000, 0x20000, 0x30000] {
            let io = ICacheTraceIO()
            io.registers[.cr] = 0x8000_0005
            XCTAssertEqual(io.driver.startMonitor(monitor), .ok)
            XCTAssertEqual(io.driver.stopMonitor(monitor), .ok)
            XCTAssertEqual(io.driver.resetMonitor(monitor), .ok)
            XCTAssertEqual(io.events, [.read(.cr), .write(.cr, 0x8000_0005 | monitor),
                .read(.cr), .write(.cr, 0x8000_0005),
                .read(.cr), .write(.cr, 0x8000_0005 | (monitor << 2)), .read(.cr), .write(.cr, 0x8000_0005)])
        }
    }

    func testHitAndMissReadbackReturnsEntireRegisterIncludingReservedHighBits() {
        let io = ICacheTraceIO()
        io.registers[.hmonr] = .max; io.registers[.mmonr] = 0xABCD_1234
        XCTAssertEqual(io.driver.getHitValue(), .max)
        XCTAssertEqual(io.driver.getMissValue(), 0xABCD_1234)
        XCTAssertEqual(io.events, [.read(.hmonr), .read(.mmonr)])
    }

    func testEveryIRQFlagAndEnableCombinationUsesSnapshotAndErrorFirst() {
        for flags in UInt32(0)..<8 {
            for sources in UInt32(0)..<8 {
                let io = ICacheTraceIO()
                io.registers = [.sr: flags, .ier: sources]
                io.driver.handleInterrupt(error: { _ in io.events.append(.callback("error")) },
                                          invalidateComplete: { _ in io.events.append(.callback("complete")) })
                var expected: [ICacheTraceEvent] = [.read(.sr), .read(.ier)]
                var enabled = sources
                if flags & sources & 4 != 0 {
                    enabled &= ~UInt32(4)
                    expected += [.read(.ier), .write(.ier, enabled), .write(.fcr, 4), .callback("error")]
                }
                if flags & sources & 2 != 0 {
                    enabled &= ~UInt32(2)
                    expected += [.read(.ier), .write(.ier, enabled), .write(.fcr, 2), .callback("complete")]
                }
                XCTAssertEqual(io.events, expected)
            }
        }
    }

    func testIRQUsesFreshIERAfterCallbackButCachedFlagsAndSources() {
        let io = ICacheTraceIO()
        io.registers = [.sr: 6, .ier: 6]
        io.driver.handleInterrupt(error: { _ in
            XCTAssertEqual(io.registers[.sr], 2)
            XCTAssertEqual(io.registers[.ier], 2)
            io.registers[.sr] = 0; io.registers[.ier] = 0xA2
            io.events.append(.callback("error"))
        }, invalidateComplete: { _ in io.events.append(.callback("complete")) })
        XCTAssertEqual(io.events, [.read(.sr), .read(.ier), .read(.ier), .write(.ier, 2), .write(.fcr, 4),
            .callback("error"), .read(.ier), .write(.ier, 0xA0), .write(.fcr, 2), .callback("complete")])
    }

    func testErrorCallbackCanReenterBeforeOuterCachedCompleteCallback() {
        let io = ICacheTraceIO()
        io.registers = [.sr: 6, .ier: 6]
        io.driver.handleInterrupt(error: { cache in
            io.events.append(.callback("error"))
            cache.handleInterrupt(invalidateComplete: { _ in io.events.append(.callback("nested")) })
        }, invalidateComplete: { _ in io.events.append(.callback("outer")) })
        XCTAssertEqual(io.events.filter { if case .callback = $0 { return true }; return false },
                       [.callback("error"), .callback("nested"), .callback("outer")])
        XCTAssertEqual(io.writes, [.write(.ier, 2), .write(.fcr, 4), .write(.ier, 0), .write(.fcr, 2),
                                  .write(.ier, 0), .write(.fcr, 2)])
    }

    func testMacroHelpersPreserveAllBitVersusAnyBitSemantics() {
        let io = ICacheTraceIO()
        io.registers = [.ier: 0x8000_0000, .sr: 2]
        io.driver.enableInterrupts(6)
        XCTAssertEqual(io.driver.getInterruptSource(6), 1)
        io.driver.disableInterrupts(4)
        XCTAssertEqual(io.driver.getInterruptSource(6), 0)
        XCTAssertEqual(io.driver.getInterruptSource(0), 1)
        XCTAssertEqual(io.driver.getFlag(6), 1)
        XCTAssertEqual(io.driver.getFlag(0), 0)
        io.driver.clearFlag(6)
        XCTAssertEqual(io.writes, [.write(.ier, 0x8000_0006), .write(.ier, 0x8000_0002), .write(.fcr, 6)])
        XCTAssertEqual(io.registers[.sr], 0)
    }
}
