import XCTest
@testable import STM32H7RSHAL

private enum HALAccess: Equatable {
    case read(HALRegister)
    case write(HALRegister, UInt32)
    case grouping(UInt32)
    case configureTick, tickPriority, msp
}

private final class HALTestRegisters: HALRegisterIO {
    var values: [HALRegister: UInt32] = [:]
    var trace: [HALAccess] = []
    func read(_ register: HALRegister) -> UInt32 {
        trace.append(.read(register))
        return values[register, default: 0]
    }
    func write(_ register: HALRegister, value: UInt32) {
        trace.append(.write(register, value))
        values[register] = value
    }
    func setPriorityGrouping(_ group: UInt32) { trace.append(.grouping(group)) }
}

final class HALTests: XCTestCase {
    func testInitializationOrderAndFailureDoNotCallMSP() {
        for failure in [false, true] {
            let io = HALTestRegisters()
            let time = TimeTestRegisters()
            time.state.configResult = failure ? 1 : 0
            time.onConfigure = { io.trace.append(.configureTick) }
            time.onPriority = { io.trace.append(.tickPriority) }
            var hal = HAL(registers: io, timeBase: HALTimeBase(registers: time))
            let status = hal.initialize(coreClockHz: 64_000_000) { io.trace.append(.msp) }
            XCTAssertEqual(status, failure ? .error : .ok)
            XCTAssertEqual(io.trace, failure ? [.grouping(3), .configureTick] :
                           [.grouping(3), .configureTick, .tickPriority, .msp])
            XCTAssertEqual(time.state.priority, failure ? 16 : 15)
        }
    }

    func testDeinitializationMatchesUpstreamResetMasksAndBusOrder() {
        let io = HALTestRegisters()
        let time = TimeTestRegisters()
        time.state.tick = 123
        time.state.sysTick.CTRL = 7
        var hal = HAL(registers: io, timeBase: HALTimeBase(registers: time))
        XCTAssertEqual(hal.deinitialize { io.trace.append(.msp) }, .ok)
        // Values taken from the pinned upstream RCC force/release-reset macros.
        XCTAssertEqual(io.trace, [
            .write(.apb1Reset1, 0xC8FFC3FF), .write(.apb1Reset2, 0x08000122),
            .write(.apb1Reset1, 0), .write(.apb1Reset2, 0),
            .write(.apb2Reset, 0xC8FFC3FF), .write(.apb2Reset, 0),
            .write(.apb4Reset, 0x04009E2A), .write(.apb4Reset, 0),
            .write(.apb5Reset, 0x16), .write(.apb5Reset, 0),
            .write(.ahb1Reset, 0x8E008030), .write(.ahb1Reset, 0),
            .write(.ahb2Reset, 0x4202), .write(.ahb2Reset, 0),
            .write(.ahb3Reset, 0x57), .write(.ahb3Reset, 0),
            .write(.ahb4Reset, 0x8B0FF), .write(.ahb4Reset, 0),
            .write(.ahb5Reset, 0x18513B), .write(.ahb5Reset, 0), .msp,
        ])
        XCTAssertEqual(time.state.tick, 123)
        XCTAssertEqual(time.state.sysTick.CTRL, 7)
        XCTAssertEqual(time.state.configCalls, 0)
    }

    func testVersionAndIdentificationMasks() {
        let io = HALTestRegisters()
        io.values[.debugIdentification] = 0xABCD6485
        var hal = HAL(registers: io, timeBase: HALTimeBase(registers: TimeTestRegisters()))
        XCTAssertEqual(type(of: hal).version, 0x01020100)
        XCTAssertEqual(hal.getRevisionID(), 0xABCD)
        XCTAssertEqual(hal.getDeviceID(), 0x485)
        XCTAssertEqual(io.trace, [.read(.debugIdentification), .read(.debugIdentification)])
        for index in 0..<3 {
            io.trace = []
            io.values[.uniqueIDWord(index: index)] = UInt32(index) + 100
            XCTAssertEqual(hal.getUniqueIDWord(index), UInt32(index) + 100)
            XCTAssertEqual(io.trace, [.read(.uniqueIDWord(index: index))])
        }
    }

    func testDebugControlsPreserveUnrelatedBits() {
        for initial in [UInt32(0), 0xA5A5A5A5, UInt32.max] {
            let io = HALTestRegisters()
            io.values[.debugControl] = initial
            var hal = HAL(registers: io, timeBase: HALTimeBase(registers: TimeTestRegisters()))
            hal.enableDebugSleepMode()
            hal.enableDebugStopMode()
            hal.enableDebugStandbyMode()
            XCTAssertEqual(io.values[.debugControl], initial | 7)
            hal.disableDebugSleepMode()
            hal.disableDebugStopMode()
            hal.disableDebugStandbyMode()
            XCTAssertEqual(io.values[.debugControl], initial & ~UInt32(7))
            XCTAssertEqual(io.trace.count, 12)
            for index in stride(from: 0, to: 12, by: 2) {
                XCTAssertEqual(io.trace[index], .read(.debugControl))
            }
        }
    }
}
