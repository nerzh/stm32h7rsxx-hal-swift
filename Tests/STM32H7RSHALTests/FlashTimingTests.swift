import XCTest
@testable import STM32H7RSHAL

private enum FlashTimingAccess: Equatable {
    case read(UInt32)
    case write(UInt32)
}

private final class FlashTimingTestRegisters: FlashTimingRegisterIO {
    var value: UInt32 = 0
    var ignoreWrites = false
    var accesses: [FlashTimingAccess] = []

    func read(_ register: FlashTimingRegister) -> UInt32 {
        accesses.append(.read(value))
        return value
    }

    func write(_ register: FlashTimingRegister, value: UInt32) {
        accesses.append(.write(value))
        if !ignoreWrites { self.value = value }
    }
}

final class FlashTimingTests: XCTestCase {
    func testLatencyConstantsIncludeTheRequiredWRHIGHFREQEncoding() {
        XCTAssertEqual(FlashLatency.allCases.map(\.rawValue), [0, 1, 0x12, 0x13, 0x24, 0x25, 0x36, 0x37])
        XCTAssertNil(FlashLatency(rawValue: 2))
        XCTAssertNil(FlashLatency(rawValue: 7))
        XCTAssertNil(FlashLatency(rawValue: 0x3F))
    }

    func testEveryLatencyReplacesBothFieldsAndPreservesUnrelatedBits() {
        for latency in FlashLatency.allCases {
            for initial in [UInt32(0), 8, 0xA5A5A5A5, UInt32.max] {
                let io = FlashTimingTestRegisters()
                io.value = initial
                let timing = FlashTiming(registers: io)
                timing.setLatency(latency)
                let expected = (initial & 0xFFFFFFC0) | latency.rawValue
                XCTAssertEqual(io.accesses, [.read(initial), .write(expected)])
                XCTAssertEqual(io.value, expected)
                XCTAssertEqual(timing.getLatency(), latency.rawValue)
            }
        }
    }

    func testReadbackKeepsAllSixBitsIncludingUnexpectedCombinations() {
        for raw in UInt32(0)...0x3F {
            let io = FlashTimingTestRegisters()
            io.value = 0xA5A5A5C0 | raw
            XCTAssertEqual(FlashTiming(registers: io).getLatency(), raw)
            XCTAssertEqual(io.accesses, [.read(io.value)])
        }
    }

    func testSetMacroDoesNotAddReadbackOrConcealRejectedWrites() {
        let io = FlashTimingTestRegisters()
        io.value = 0xA5000028
        io.ignoreWrites = true
        let timing = FlashTiming(registers: io)
        timing.setLatency(.waitStates7)
        XCTAssertEqual(io.accesses, [.read(0xA5000028), .write(0xA5000037)])
        XCTAssertEqual(timing.getLatency(), 0x28)
        XCTAssertNotEqual(timing.getLatency(), FlashLatency.waitStates7.rawValue)
    }
}
