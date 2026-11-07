import XCTest
@testable import STM32H7RSHAL

private enum PowerAccess: Equatable {
    case read(PowerRegister, UInt32)
    case write(PowerRegister, UInt32)
    case dsb, isb, wfi, sev, wfe
}

private struct PowerTestRegisters: PowerRegisterIO {
    var values: [PowerRegister: UInt32] = [:]
    var accesses: [PowerAccess] = []
    var systemControlBitsSetByWake: UInt32 = 0

    mutating func read(_ register: PowerRegister) -> UInt32 {
        let value = values[register, default: 0]
        accesses.append(.read(register, value))
        return value
    }

    mutating func write(_ register: PowerRegister, value: UInt32) {
        accesses.append(.write(register, value))
        values[register] = value
    }

    mutating func dataSynchronizationBarrier() { accesses.append(.dsb) }
    mutating func instructionSynchronizationBarrier() { accesses.append(.isb) }
    mutating func sendEvent() { accesses.append(.sev) }

    mutating func waitForInterrupt() {
        accesses.append(.wfi)
        values[.systemControl, default: 0] |= systemControlBitsSetByWake
    }

    mutating func waitForEvent() {
        accesses.append(.wfe)
        values[.systemControl, default: 0] |= systemControlBitsSetByWake
    }
}

final class PowerTests: XCTestCase {
    private let entrySequences: [(PowerEntry, [PowerAccess])] = [
        (.waitForInterrupt, [.wfi]),
        (.waitForEvent, [.sev, .wfe, .wfe]),
        (.waitForEventWithoutClearing, [.wfe]),
    ]

    func testTypedConstantsMatchTheCHeader() {
        XCTAssertEqual(PowerPVDLevel.allCases.map(\.rawValue), [
            0x00, 0x20, 0x40, 0x60, 0x80, 0xA0, 0xC0, 0xE0,
        ])
        XCTAssertEqual(PowerPVDMode.allCases.map(\.rawValue), [
            0, 0x10001, 0x10002, 0x10003, 0x20001, 0x20002, 0x20003,
        ])
        XCTAssertEqual(PowerWakeUpPin.allCases.map(\.rawValue), [
            1, 2, 4, 8, 0x101, 0x202, 0x404, 0x808,
        ])
        XCTAssertEqual(PowerEntry.allCases.map(\.rawValue), [1, 2, 3])
        XCTAssertNil(PowerPVDLevel(rawValue: 1))
        XCTAssertNil(PowerPVDMode(rawValue: 0x30003))
        XCTAssertNil(PowerWakeUpPin(rawValue: 3))
        XCTAssertNil(PowerEntry(rawValue: 0))
        XCTAssertNil(PowerEntry(rawValue: 4))
    }

    func testDeinitializeAndNullPVDConfigurationDoNotAccessHardware() {
        let values: [PowerRegister: UInt32] = [.cr1: 0x12345678, .csr3: 0x87654321]
        var power = Power(registers: PowerTestRegisters(values: values))
        power.deinitialize()
        power.configurePVD(nil)
        XCTAssertEqual(power.registers.values, values)
        XCTAssertEqual(power.registers.accesses, [])
    }

    func testBackupDomainAccessChangesOnlyDBP() {
        for initial in [UInt32(0), 0xA5A5A5A5, UInt32.max] {
            var power = Power(registers: PowerTestRegisters(values: [.cr1: initial]))
            power.enableBackupAccess()
            power.disableBackupAccess()
            XCTAssertEqual(power.registers.accesses, [
                .read(.cr1, initial), .write(.cr1, initial | 0x100),
                .read(.cr1, initial | 0x100), .write(.cr1, initial & 0xFFFFFEFF),
            ])
            XCTAssertEqual(power.registers.values[.cr1], initial & 0xFFFFFEFF)
        }
    }

    func testPVDEnableAndDisableChangeOnlyPVDE() {
        for initial in [UInt32(0), 0x5A5A5A5A, UInt32.max] {
            var power = Power(registers: PowerTestRegisters(values: [.cr1: initial]))
            power.enablePVD()
            power.disablePVD()
            XCTAssertEqual(power.registers.accesses, [
                .read(.cr1, initial), .write(.cr1, initial | 0x10),
                .read(.cr1, initial | 0x10), .write(.cr1, initial & 0xFFFFFFEF),
            ])
            XCTAssertEqual(power.registers.values[.cr1], initial & 0xFFFFFFEF)
        }
    }

    func testPVDConfigurationMatchesEveryLevelAndModeWithExactAccessOrder() {
        // The table specifies enabled registers independently of the raw mode bits.
        let modes: [(PowerPVDMode, [PowerRegister])] = [
            (.normal, []),
            (.interruptRising, [.extiInterruptMask, .extiRisingTrigger]),
            (.interruptFalling, [.extiInterruptMask, .extiFallingTrigger]),
            (.interruptRisingFalling, [.extiInterruptMask, .extiRisingTrigger, .extiFallingTrigger]),
            (.eventRising, [.extiEventMask, .extiRisingTrigger]),
            (.eventFalling, [.extiEventMask, .extiFallingTrigger]),
            (.eventRisingFalling, [.extiEventMask, .extiRisingTrigger, .extiFallingTrigger]),
        ]
        let clearOrder: [PowerRegister] = [
            .extiEventMask, .extiInterruptMask, .extiRisingTrigger, .extiFallingTrigger,
        ]
        for initial in [UInt32(0), UInt32.max, 0xA5A5A5A5] {
            for level in PowerPVDLevel.allCases {
                for (mode, enabled) in modes {
                    let seed: [PowerRegister: UInt32] = [
                        .cr1: initial, .csr3: 0x11223344,
                        .extiEventMask: initial, .extiInterruptMask: initial,
                        .extiRisingTrigger: initial, .extiFallingTrigger: initial,
                    ]
                    var power = Power(registers: PowerTestRegisters(values: seed))
                    power.configurePVD(.init(level: level, mode: mode))

                    var expectedValues = seed
                    expectedValues[.cr1] = (initial & 0xFFFFFF1F) | level.rawValue
                    var expected: [PowerAccess] = [
                        .read(.cr1, initial), .write(.cr1, expectedValues[.cr1]!),
                    ]
                    for register in clearOrder {
                        expectedValues[register] = initial & 0xFFFEFFFF
                        expected.append(.read(register, initial))
                        expected.append(.write(register, initial & 0xFFFEFFFF))
                    }
                    for register in enabled {
                        expectedValues[register] = initial | 0x10000
                        expected.append(.read(register, initial & 0xFFFEFFFF))
                        expected.append(.write(register, initial | 0x10000))
                    }
                    XCTAssertEqual(power.registers.values, expectedValues, "\(level), \(mode)")
                    XCTAssertEqual(power.registers.accesses, expected, "\(level), \(mode)")
                }
            }
        }
    }

    func testEnableWakeUpPinReplacesAllEnableAndPolarityBitsButPreservesPulls() {
        for pin in PowerWakeUpPin.allCases {
            for initial in [UInt32(0), 0xA55A0F0F, UInt32.max] {
                var power = Power(registers: PowerTestRegisters(values: [.wakeupEnablePolarity: initial]))
                power.enableWakeUpPin(pin)
                let expected = (initial & 0xFFFFF0F0) | pin.rawValue
                XCTAssertEqual(power.registers.accesses, [
                    .read(.wakeupEnablePolarity, initial), .write(.wakeupEnablePolarity, expected),
                ], "\(pin)")
                XCTAssertEqual(power.registers.values[.wakeupEnablePolarity], expected)
            }
        }
    }

    func testDisableWakeUpPinPreservesPolarityPullsAndOtherPinEnables() {
        let pins: [(PowerWakeUpPin, UInt32)] = [
            (.pin1High, 1), (.pin1Low, 1), (.pin2High, 2), (.pin2Low, 2),
            (.pin3High, 4), (.pin3Low, 4), (.pin4High, 8), (.pin4Low, 8),
        ]
        for (pin, enableBit) in pins {
            for initial in [UInt32(0), 0xA55A0F0F, UInt32.max] {
                var power = Power(registers: PowerTestRegisters(values: [.wakeupEnablePolarity: initial]))
                power.disableWakeUpPin(pin)
                XCTAssertEqual(power.registers.accesses, [
                    .read(.wakeupEnablePolarity, initial),
                    .write(.wakeupEnablePolarity, initial & ~enableBit),
                ], "\(pin)")
            }
        }
    }

    func testSleepClearsSleepDeepBeforeTheExactEntrySequenceAndIgnoresRegulator() {
        for (entry, sequence) in entrySequences {
            for regulator in [UInt32(0), 1, UInt32.max] {
                var power = Power(registers: PowerTestRegisters(values: [
                    .systemControl: 0xA5A5A5A5, .csr3: 0x12345679,
                ]))
                power.enterSleepMode(regulator: regulator, entry: entry)
                XCTAssertEqual(power.registers.accesses, [
                    .read(.systemControl, 0xA5A5A5A5), .write(.systemControl, 0xA5A5A5A1),
                ] + sequence, "\(entry), regulator \(regulator)")
                XCTAssertEqual(power.registers.values[.csr3], 0x12345679)
                XCTAssertEqual(power.registers.values[.systemControl], 0xA5A5A5A1)
            }
        }
    }

    func testStopConfiguresDeepSleepAndBarriersThenClearsSleepDeepAfterWake() {
        for (entry, sequence) in entrySequences {
            for regulator in [UInt32(0), 1, UInt32.max] {
                var power = Power(registers: PowerTestRegisters(values: [
                    .csr3: 0xA55A0333, .systemControl: 0xA5A5A5A1,
                ]))
                power.enterStopMode(regulator: regulator, entry: entry)
                let prefix: [PowerAccess] = [
                    .read(.csr3, 0xA55A0333), .write(.csr3, 0xA55A0332),
                    .read(.systemControl, 0xA5A5A5A1), .write(.systemControl, 0xA5A5A5A5),
                    .dsb, .isb,
                ]
                let suffix: [PowerAccess] = [
                    .read(.systemControl, 0xA5A5A5A5), .write(.systemControl, 0xA5A5A5A1),
                ]
                XCTAssertEqual(power.registers.accesses, prefix + sequence + suffix,
                               "\(entry), regulator \(regulator)")
                XCTAssertEqual(power.registers.values[.csr3], 0xA55A0332)
                XCTAssertEqual(power.registers.values[.systemControl], 0xA5A5A5A1)
            }
        }
    }

    func testStopRereadsSystemControlAfterWakeToPreserveAnInterruptsChanges() {
        for (entry, _) in entrySequences {
            let io = PowerTestRegisters(values: [.systemControl: 2], systemControlBitsSetByWake: 0x10)
            var power = Power(registers: io)
            power.enterStopMode(entry: entry)
            XCTAssertEqual(Array(power.registers.accesses.suffix(2)), [
                .read(.systemControl, 0x16), .write(.systemControl, 0x12),
            ], "\(entry)")
            XCTAssertEqual(power.registers.values[.systemControl], 0x12)
        }
    }

    func testStandbySetsPDDSAndSleepDeepBeforeBarriersAndWFIWithoutClearingOnReturn() {
        var power = Power(registers: PowerTestRegisters(values: [
            .csr3: 0xA55A0332, .systemControl: 0xA5A5A5A1,
        ]))
        power.enterStandbyMode()
        XCTAssertEqual(power.registers.accesses, [
            .read(.csr3, 0xA55A0332), .write(.csr3, 0xA55A0333),
            .read(.systemControl, 0xA5A5A5A1), .write(.systemControl, 0xA5A5A5A5),
            .dsb, .isb, .wfi,
        ])
        XCTAssertEqual(power.registers.values[.csr3], 0xA55A0333)
        XCTAssertEqual(power.registers.values[.systemControl], 0xA5A5A5A5)
    }

    func testSleepOnExitChangesOnlyBitOne() {
        for initial in [UInt32(0), 0xA5A5A5A5, UInt32.max] {
            var power = Power(registers: PowerTestRegisters(values: [.systemControl: initial]))
            power.enableSleepOnExit()
            power.disableSleepOnExit()
            XCTAssertEqual(power.registers.accesses, [
                .read(.systemControl, initial), .write(.systemControl, initial | 2),
                .read(.systemControl, initial | 2), .write(.systemControl, initial & 0xFFFFFFFD),
            ])
        }
    }

    func testSEVOnPendChangesOnlyBitFour() {
        for initial in [UInt32(0), 0xA5A5A5A5, UInt32.max] {
            var power = Power(registers: PowerTestRegisters(values: [.systemControl: initial]))
            power.enableSEVOnPend()
            power.disableSEVOnPend()
            XCTAssertEqual(power.registers.accesses, [
                .read(.systemControl, initial), .write(.systemControl, initial | 0x10),
                .read(.systemControl, initial | 0x10), .write(.systemControl, initial & 0xFFFFFFEF),
            ])
        }
    }
}
