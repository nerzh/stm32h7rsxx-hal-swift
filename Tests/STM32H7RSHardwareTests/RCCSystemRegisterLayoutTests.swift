import XCTest
import STM32H7RSHAL
import STM32H7RSHardware

private final class RCCSystemTimeRegisters: HALTimeBaseIO {
    var tick: UInt32 = 7
    var priority: UInt32 = 9
    var frequency: UInt32 = 1
    var configuredTicks: UInt32 = 0
    var configuredPriority: UInt32 = 0
    var configureResult: UInt32 = 0
    var control: UInt32 = 0

    func read(_ word: HALTimeBaseWord) -> UInt32 {
        switch word {
        case .tick: return tick
        case .priority: return priority
        case .frequency: return frequency
        }
    }

    func write(_ word: HALTimeBaseWord, value: UInt32) {
        switch word {
        case .tick: tick = value
        case .priority: priority = value
        case .frequency: frequency = value
        }
    }

    func configureSysTick(ticks: UInt32) -> UInt32 {
        configuredTicks = ticks
        return configureResult
    }

    func setSysTickPriority(_ priority: UInt32) { configuredPriority = priority }
    func readSysTickControl() -> UInt32 { control }
    func writeSysTickControl(_ value: UInt32) { control = value }
}

final class RCCSystemRegisterLayoutTests: XCTestCase {
    func testSharedClockWordAndTimeBaseStayIndependent() {
        var storage: [UInt32] = [0xAABBCCDD, 64_000_000, 0x11223344]
        let timeRegisters = RCCSystemTimeRegisters()
        let interruptTimeBase = HALTimeBase(registers: timeRegisters)
        storage.withUnsafeMutableBufferPointer { buffer in
            let system = STM32RCCSystem(systemCoreClock: buffer.baseAddress! + 1,
                                        timeBase: interruptTimeBase)
            let copy = system
            XCTAssertEqual(system.getSystemCoreClock(), 64_000_000)
            copy.setSystemCoreClock(600_000_000)
            XCTAssertEqual(system.getSystemCoreClock(), 600_000_000)
            XCTAssertEqual(Array(buffer), [0xAABBCCDD, 600_000_000, 0x11223344])

            interruptTimeBase.incrementTick()
            XCTAssertEqual(system.getTick(), 8)
            XCTAssertEqual(system.getTickPriority(), 9)
            XCTAssertEqual(system.initializeTick(priority: 5, coreClockHz: 123_000_000), .ok)
            XCTAssertEqual(timeRegisters.configuredTicks, 123_000)
            XCTAssertEqual(timeRegisters.configuredPriority, 5)
            XCTAssertEqual(copy.getTickPriority(), 5)
            XCTAssertEqual(system.getSystemCoreClock(), 600_000_000)
        }
    }

    func testInitializationFailurePropagatesWithoutChangingClockOrPriority() {
        var clock: UInt32 = 64_000_000
        let timeRegisters = RCCSystemTimeRegisters()
        timeRegisters.configureResult = 1
        withUnsafeMutablePointer(to: &clock) { pointer in
            let system = STM32RCCSystem(systemCoreClock: pointer,
                                        timeBase: HALTimeBase(registers: timeRegisters))
            XCTAssertEqual(system.initializeTick(priority: 3, coreClockHz: 600_000_000), .error)
            XCTAssertEqual(system.getSystemCoreClock(), 64_000_000)
            XCTAssertEqual(system.getTickPriority(), 9)
        }
    }
}
