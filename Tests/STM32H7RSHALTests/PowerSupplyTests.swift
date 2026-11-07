import XCTest
@testable import STM32H7RSHAL

private enum PowerSupplyAccess: Equatable {
    case read(PowerSupplyRegister, UInt32)
    case write(PowerSupplyRegister, UInt32)
    case tick(UInt32)
}

private final class PowerSupplyTestRegisters: PowerSupplyRegisterIO {
    var values: [PowerSupplyRegister: UInt32] = [:]
    var scriptedReads: [PowerSupplyRegister: [UInt32]] = [:]
    var ticks: [UInt32] = []
    var nextTick: UInt32 = 0
    var ignoreWrites = false
    var accesses: [PowerSupplyAccess] = []

    func read(_ register: PowerSupplyRegister) -> UInt32 {
        let value: UInt32
        if var pending = scriptedReads[register], !pending.isEmpty {
            value = pending.removeFirst()
            scriptedReads[register] = pending
        } else {
            value = values[register, default: 0]
        }
        accesses.append(.read(register, value))
        return value
    }

    func write(_ register: PowerSupplyRegister, value: UInt32) {
        accesses.append(.write(register, value))
        if !ignoreWrites { values[register] = value }
    }

    func getTick() -> UInt32 {
        let value = ticks.isEmpty ? nextTick : ticks.removeFirst()
        nextTick = value &+ 1001
        accesses.append(.tick(value))
        return value
    }
}

final class PowerSupplyTests: XCTestCase {
    func testTypedConstantsMatchTheUpstreamHeader() {
        XCTAssertEqual(PowerSupplySource.allCases.map(\.rawValue), [2, 1, 4, 0x16, 0x1E, 0x1D])
        XCTAssertNil(PowerSupplySource(rawValue: 6))
        XCTAssertNil(PowerSupplySource(rawValue: 0x36))
        XCTAssertEqual(PowerVoltageScale.scale0.rawValue, 1)
        XCTAssertEqual(PowerVoltageScale.scale1.rawValue, 0)
    }

    func testEverySupplyConfiguresFromResetAndPreservesUnrelatedBits() {
        let initial: UInt32 = 0xA5010066 // SDEN | LDOEN; SDEXTRDY is already set.
        for source in PowerSupplySource.allCases {
            let io = PowerSupplyTestRegisters()
            io.values = [.csr2: initial, .sr1: 0x12345672]
            io.ticks = [17, 29]
            let supply = PowerSupply(registers: io)
            XCTAssertEqual(supply.configureSupply(source, getTick: io.getTick), .ok)
            let configured = (initial & 0xFFFFFFE0) | source.rawValue
            var expected: [PowerSupplyAccess] = [
                .read(.csr2, initial), .read(.csr2, initial), .write(.csr2, configured),
                .tick(17), .read(.sr1, 0x12345672),
            ]
            switch source {
            case .smps1V8SuppliesExternalAndLDO, .smps1V8SuppliesExternal:
                expected += [.tick(29), .read(.csr2, configured)]
            default: break
            }
            XCTAssertEqual(io.accesses, expected, "\(source)")
            XCTAssertEqual(io.values[.csr2], configured)
        }
    }

    func testLockedSupplyReturnsImmediatelyForMatchingAndConflictingRequests() {
        let locked: [PowerSupplySource] = [.ldo, .externalSource, .directSMPS, .smps1V8SuppliesExternal]
        for existing in locked {
            for requested in PowerSupplySource.allCases {
                let io = PowerSupplyTestRegisters()
                let initial = UInt32(0xA5000060) | existing.rawValue
                io.values[.csr2] = initial
                let supply = PowerSupply(registers: io)
                XCTAssertEqual(supply.configureSupply(requested, getTick: io.getTick),
                               requested == existing ? .ok : .error)
                XCTAssertEqual(io.accesses, [.read(.csr2, initial), .read(.csr2, initial)])
                XCTAssertEqual(io.values[.csr2], initial)
            }
        }
    }

    func testLockComparisonUsesASecondCSR2Read() {
        let io = PowerSupplyTestRegisters()
        io.scriptedReads[.csr2] = [2, 1]
        XCTAssertEqual(PowerSupply(registers: io).configureSupply(.externalSource, getTick: io.getTick), .ok)
        XCTAssertEqual(io.accesses, [.read(.csr2, 2), .read(.csr2, 1)])
    }

    func testSupplyModificationRereadsCSR2AndPreservesTheNewUnrelatedBits() {
        let io = PowerSupplyTestRegisters()
        io.scriptedReads[.csr2] = [6, 0xA5000026]
        io.values[.sr1] = 2
        XCTAssertEqual(PowerSupply(registers: io).configureSupply(.ldo, getTick: io.getTick), .ok)
        XCTAssertEqual(io.accesses, [
            .read(.csr2, 6), .read(.csr2, 0xA5000026), .write(.csr2, 0xA5000022),
            .tick(0), .read(.sr1, 2),
        ])
    }

    func testSupplyLockDetectionUsesOnlyTheThreeEnableAndBypassBits() {
        for existing in [UInt32(0x16), 0x1E] {
            let io = PowerSupplyTestRegisters()
            io.values = [.csr2: existing, .sr1: 2]
            XCTAssertEqual(PowerSupply(registers: io).configureSupply(.ldo, getTick: io.getTick), .ok)
            XCTAssertEqual(io.accesses, [
                .read(.csr2, existing), .read(.csr2, existing), .write(.csr2, 2),
                .tick(0), .read(.sr1, 2),
            ])
        }
    }

    func testWritableSupplyBranchDoesNotInventAConfigurationReadbackCheck() {
        let io = PowerSupplyTestRegisters()
        io.values = [.csr2: 6, .sr1: 2]
        io.ignoreWrites = true
        let supply = PowerSupply(registers: io)
        XCTAssertEqual(supply.configureSupply(.ldo, getTick: io.getTick), .ok)
        XCTAssertEqual(io.accesses, [
            .read(.csr2, 6), .read(.csr2, 6), .write(.csr2, 2), .tick(0), .read(.sr1, 2),
        ])
        XCTAssertEqual(supply.getSupplyConfig(), 6)
    }

    func testSupplyTimeoutIsStrictlyGreaterThanOneSecondAndReturnsErrorWithoutRollback() {
        let io = PowerSupplyTestRegisters()
        io.values[.csr2] = 6
        io.ticks = [31, 1031, 1032]
        XCTAssertEqual(PowerSupply(registers: io).configureSupply(.ldo, getTick: io.getTick), .error)
        XCTAssertEqual(io.accesses, [
            .read(.csr2, 6), .read(.csr2, 6), .write(.csr2, 2), .tick(31),
            .read(.sr1, 0), .tick(1031), .read(.sr1, 0), .tick(1032),
        ])
        XCTAssertEqual(io.values[.csr2], 2)
    }

    func testSupplyReadyAtTheTimeoutBoundarySucceedsWithoutAnExtraTickRead() {
        let io = PowerSupplyTestRegisters()
        io.values[.csr2] = 6
        io.scriptedReads[.sr1] = [0, 2]
        io.ticks = [0, 1000]
        XCTAssertEqual(PowerSupply(registers: io).configureSupply(.ldo, getTick: io.getTick), .ok)
        XCTAssertEqual(io.accesses, [
            .read(.csr2, 6), .read(.csr2, 6), .write(.csr2, 2), .tick(0),
            .read(.sr1, 0), .tick(1000), .read(.sr1, 2),
        ])
    }

    func testSupplyTimeoutHandlesTickRollover() {
        let io = PowerSupplyTestRegisters()
        io.values[.csr2] = 6
        let start = UInt32.max - 500
        io.ticks = [start, 499, 500]
        XCTAssertEqual(PowerSupply(registers: io).configureSupply(.ldo, getTick: io.getTick), .error)
        XCTAssertEqual(Array(io.accesses.suffix(5)), [
            .tick(start), .read(.sr1, 0), .tick(499), .read(.sr1, 0), .tick(500),
        ])
    }

    func testExternalSupplyWaitHasItsOwnTimeoutStart() {
        for source in [PowerSupplySource.smps1V8SuppliesExternalAndLDO, .smps1V8SuppliesExternal] {
            let io = PowerSupplyTestRegisters()
            io.values[.csr2] = 6
            io.scriptedReads[.sr1] = [0, 2]
            io.ticks = [100, 1100, 1101, 2101, 2102]
            XCTAssertEqual(PowerSupply(registers: io).configureSupply(source, getTick: io.getTick), .error)
            XCTAssertEqual(io.accesses, [
                .read(.csr2, 6), .read(.csr2, 6), .write(.csr2, source.rawValue),
                .tick(100), .read(.sr1, 0), .tick(1100), .read(.sr1, 2),
                .tick(1101), .read(.csr2, source.rawValue), .tick(2101),
                .read(.csr2, source.rawValue), .tick(2102),
            ])
            XCTAssertEqual(io.values[.csr2], source.rawValue)
        }
    }

    func testExternalSupplyReadyFlagAndTimeoutAcrossTickRollover() {
        for ready in [false, true] {
            let io = PowerSupplyTestRegisters()
            io.scriptedReads[.csr2] = [6, 6, 0x1E, ready ? 0x1001E : 0x1E]
            io.values[.sr1] = 2
            let start = UInt32.max - 500
            io.ticks = [0, start, 499, 500]
            XCTAssertEqual(PowerSupply(registers: io).configureSupply(
                .smps1V8SuppliesExternalAndLDO, getTick: io.getTick), ready ? .ok : .error)
            var expected: [PowerSupplyAccess] = [
                .read(.csr2, 6), .read(.csr2, 6), .write(.csr2, 0x1E),
                .tick(0), .read(.sr1, 2), .tick(start), .read(.csr2, 0x1E), .tick(499),
                .read(.csr2, ready ? 0x1001E : 0x1E),
            ]
            if !ready { expected.append(.tick(500)) }
            XCTAssertEqual(io.accesses, expected)
        }
    }

    func testSupplyQueryPreservesAllRawEncodingsIncludingResetAndReservedValues() {
        for raw in UInt32(0)...31 {
            let io = PowerSupplyTestRegisters()
            io.values[.csr2] = 0xA50100E0 | raw
            XCTAssertEqual(PowerSupply(registers: io).getSupplyConfig(), raw)
            XCTAssertEqual(io.accesses, [.read(.csr2, 0xA50100E0 | raw)])
        }
    }

    func testVoltageScalingChangesOnlyVOSAndWaitsForVOSRDY() {
        for scale in PowerVoltageScale.allCases {
            for initial in [UInt32(0), 0xA5A5A5A5, UInt32.max] {
                let io = PowerSupplyTestRegisters()
                let configured = (initial & 0xFFFFFFFE) | scale.rawValue
                io.scriptedReads[.csr4] = [initial, configured | 2]
                io.ticks = [13]
                XCTAssertEqual(PowerSupply(registers: io).controlVoltageScaling(scale, getTick: io.getTick), .ok)
                XCTAssertEqual(io.accesses, [
                    .read(.csr4, initial), .write(.csr4, configured),
                    .tick(13), .read(.csr4, configured | 2),
                ])
                XCTAssertEqual(io.values[.csr4], configured)
            }
        }
    }

    func testVoltageScalingTimeoutBoundaryAndRolloverReturnErrorWithoutRollback() {
        for start in [UInt32(27), UInt32.max - 500] {
            let io = PowerSupplyTestRegisters()
            io.values[.csr4] = 0xA5000000
            io.ticks = [start, start &+ 1000, start &+ 1001]
            XCTAssertEqual(PowerSupply(registers: io).controlVoltageScaling(.scale0, getTick: io.getTick), .error)
            XCTAssertEqual(io.accesses, [
                .read(.csr4, 0xA5000000), .write(.csr4, 0xA5000001), .tick(start),
                .read(.csr4, 0xA5000001), .tick(start &+ 1000),
                .read(.csr4, 0xA5000001), .tick(start &+ 1001),
            ])
            XCTAssertEqual(io.values[.csr4], 0xA5000001)
        }
    }

    func testVoltageScalingChecksReadyBeforeTimeoutAndDoesNotPollActiveVOS() {
        let io = PowerSupplyTestRegisters()
        io.scriptedReads[.csr4] = [0, 1, 3]
        io.values[.sr1] = 0
        io.ticks = [5, 1005]
        let supply = PowerSupply(registers: io)
        XCTAssertEqual(supply.controlVoltageScaling(.scale0, getTick: io.getTick), .ok)
        XCTAssertEqual(io.accesses, [
            .read(.csr4, 0), .write(.csr4, 1), .tick(5),
            .read(.csr4, 1), .tick(1005), .read(.csr4, 3),
        ])
        XCTAssertEqual(supply.getVoltageRange(), .scale1)
        XCTAssertEqual(io.accesses.last, .read(.sr1, 0))
    }

    func testVoltageQueryReadsActiveSR1InsteadOfRequestedCSR4() {
        for active in [UInt32(0), 1, 0xFFFFFFFE, UInt32.max] {
            let io = PowerSupplyTestRegisters()
            io.values = [.sr1: active, .csr4: (active & 1) ^ 1]
            XCTAssertEqual(PowerSupply(registers: io).getVoltageRange().rawValue, active & 1)
            XCTAssertEqual(io.accesses, [.read(.sr1, active)])
        }
    }
}
