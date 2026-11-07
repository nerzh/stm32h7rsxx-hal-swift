import XCTest
import CTimeReference
@testable import STM32H7RSHAL

// Reference semantics model the state shared with a SysTick interrupt handler.
final class TimeTestRegisters: HALTimeBaseIO {
    var state = CTimeReferenceState()
    var onConfigure: (() -> Void)?
    var onPriority: (() -> Void)?

    init() { CTime_Reset(&state) }

    func read(_ word: HALTimeBaseWord) -> UInt32 {
        switch word {
        case .tick:
            let value = state.tick
            state.tick &+= state.tickStep
            state.tickReads &+= 1
            return value
        case .priority: return state.priority
        case .frequency: return state.frequency
        }
    }

    func write(_ word: HALTimeBaseWord, value: UInt32) {
        switch word {
        case .tick: state.tick = value
        case .priority: state.priority = value
        case .frequency: state.frequency = value
        }
    }

    func configureSysTick(ticks: UInt32) -> UInt32 {
        onConfigure?()
        state.configCalls &+= 1
        state.configTicks = ticks
        return state.configResult
    }

    func setSysTickPriority(_ priority: UInt32) {
        onPriority?()
        state.priorityCalls &+= 1
        state.lastPriority = priority
    }

    func readSysTickControl() -> UInt32 { state.sysTick.CTRL }
    func writeSysTickControl(_ value: UInt32) { state.sysTick.CTRL = value }
}

final class HALTimeBaseTests: XCTestCase {
    private func assertState(_ actual: CTimeReferenceState, _ expected: CTimeReferenceState,
                             file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(actual.tick, expected.tick, file: file, line: line)
        XCTAssertEqual(actual.priority, expected.priority, file: file, line: line)
        XCTAssertEqual(actual.frequency, expected.frequency, file: file, line: line)
        XCTAssertEqual(actual.sysTick.CTRL, expected.sysTick.CTRL, file: file, line: line)
        XCTAssertEqual(actual.configCalls, expected.configCalls, file: file, line: line)
        XCTAssertEqual(actual.configTicks, expected.configTicks, file: file, line: line)
        XCTAssertEqual(actual.priorityCalls, expected.priorityCalls, file: file, line: line)
        XCTAssertEqual(actual.lastPriority, expected.lastPriority, file: file, line: line)
    }

    func testInitializationMatchesCIncludingFailureSideEffects() {
        for frequency in [UInt32(0), 1, 10, 100] {
            for clock in [UInt32(0), 999, 64_000_000, 600_000_000, UInt32.max] {
                for priority in [UInt32(0), 7, 15, 16, UInt32.max] {
                    for result in [UInt32(0), 1] {
                        let io = TimeTestRegisters()
                        io.state.frequency = frequency
                        io.state.coreClock = clock
                        io.state.configResult = result
                        var reference = io.state
                        let actual = HALTimeBase(registers: io).initializeTick(priority: priority, coreClockHz: clock)
                        let expected = CTime_InitTick(&reference, priority)
                        XCTAssertEqual(actual.rawValue, expected)
                        assertState(io.state, reference)
                    }
                }
            }
        }
    }

    func testFrequencyChangesMatchCIncludingRollbackAndNoChange() {
        for previous in HALTickFrequency.allCases {
            for next in HALTickFrequency.allCases {
                for priority in [UInt32(0), 15, 16] {
                    for result in [UInt32(0), 1] {
                        let io = TimeTestRegisters()
                        io.state.frequency = previous.rawValue
                        io.state.priority = priority
                        io.state.configResult = result
                        var reference = io.state
                        let hal = HALTimeBase(registers: io)
                        XCTAssertEqual(hal.setTickFrequency(next, coreClockHz: io.state.coreClock).rawValue,
                                       CTime_SetFrequency(&reference, next.rawValue))
                        assertState(io.state, reference)
                        XCTAssertEqual(hal.getTickFrequency().rawValue, reference.frequency)
                        XCTAssertEqual(hal.getTickPriority(), reference.priority)
                    }
                }
            }
        }
    }

    func testIncrementUsesUnsignedWrappingLikeC() {
        for frequency in HALTickFrequency.allCases {
            for tick in [UInt32(0), 100, UInt32.max - 100, UInt32.max - 1, UInt32.max] {
                let io = TimeTestRegisters()
                io.state.frequency = frequency.rawValue
                io.state.tick = tick
                var reference = io.state
                HALTimeBase(registers: io).incrementTick()
                CTime_IncTick(&reference)
                assertState(io.state, reference)
            }
        }
    }

    func testDelayMatchesCOverTickRolloverAndWaitOverflow() {
        for frequency in HALTickFrequency.allCases {
            for start in [UInt32(0), UInt32.max - 50, UInt32.max] {
                // Near-maximum waits intentionally overflow when the C code adds
                // one tick period. HAL_MAX_DELAY itself does not add that period.
                for delay in [UInt32(0), 1, 99, 250, UInt32.max - 1, UInt32.max] {
                    let io = TimeTestRegisters()
                    io.state.frequency = frequency.rawValue
                    io.state.tick = start
                    io.state.tickStep = delay >= UInt32.max - 100 ? UInt32.max : 1
                    var reference = io.state
                    HALTimeBase(registers: io).delay(milliseconds: delay)
                    CTime_Delay(&reference, delay)
                    assertState(io.state, reference)
                    XCTAssertEqual(io.state.tickReads, reference.tickReads)
                }
            }
        }
    }

    func testSuspendAndResumePreserveOtherControlBits() {
        for control in [UInt32(0), 7, 0x10005, UInt32.max] {
            let io = TimeTestRegisters()
            io.state.sysTick.CTRL = control
            var reference = io.state
            let hal = HALTimeBase(registers: io)
            hal.suspendTick()
            CTime_Suspend(&reference)
            assertState(io.state, reference)
            hal.resumeTick()
            CTime_Resume(&reference)
            assertState(io.state, reference)
        }
    }

    func testCopiedHandlesShareInterruptState() {
        let io = TimeTestRegisters()
        let foreground = HALTimeBase(registers: io)
        let interrupt = foreground
        interrupt.incrementTick()
        XCTAssertEqual(foreground.getTick(), 1)
        interrupt.incrementTick()
        XCTAssertEqual(foreground.getTick(), 2)
    }

    func testInterruptCanUpdateTickDuringForegroundConfiguration() {
        let io = TimeTestRegisters()
        let interrupt = HALTimeBase(registers: io)
        let foreground = interrupt
        io.onConfigure = { interrupt.incrementTick() }
        io.onPriority = { interrupt.incrementTick() }
        XCTAssertEqual(foreground.initializeTick(priority: 15, coreClockHz: 64_000_000), .ok)
        XCTAssertEqual(foreground.getTick(), 2)
    }
}
