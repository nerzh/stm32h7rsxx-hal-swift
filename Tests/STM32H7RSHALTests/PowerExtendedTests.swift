import XCTest
@testable import STM32H7RSHAL

private enum PowerExtendedAccess: Equatable {
    case read(PowerExtendedRegister, UInt32), write(PowerExtendedRegister, UInt32)
    case tick(UInt32), callback(Int)
}

private final class PowerExtendedTestRegisters: PowerExtendedRegisterIO {
    var values: [PowerExtendedRegister: UInt32] = [:]
    var scriptedReads: [PowerExtendedRegister: [UInt32]] = [:]
    var ticks: [UInt32] = []
    var accesses: [PowerExtendedAccess] = []
    var clearWakeupFlagsOnWrite = false

    func read(_ register: PowerExtendedRegister) -> UInt32 {
        let value: UInt32
        if var pending = scriptedReads[register], !pending.isEmpty {
            value = pending.removeFirst()
            scriptedReads[register] = pending
        } else { value = values[register, default: 0] }
        accesses.append(.read(register, value))
        return value
    }
    func write(_ register: PowerExtendedRegister, value: UInt32) {
        accesses.append(.write(register, value))
        if register == .wakeupClear && clearWakeupFlagsOnWrite {
            values[.wakeupFlags, default: 0] &= ~value
            values[register] = value & ~UInt32(15)
        } else if register == .extiPending {
            values[register, default: 0] &= ~value
        } else { values[register] = value }
    }
    func getTick() -> UInt32 {
        precondition(!ticks.isEmpty, "Unexpected tick access")
        let tick = ticks.removeFirst()
        accesses.append(.tick(tick))
        return tick
    }
}

final class PowerExtendedTests: XCTestCase {
    private typealias Driver = PowerExtended<PowerExtendedTestRegisters>

    func testStopVoltageScalingAndReadbackPreserveOtherBits() {
        for scale in PowerStopVoltageScale.allCases {
            let io = PowerExtendedTestRegisters()
            io.values[.cr1] = 0xA55A_FFFF
            let driver = Driver(registers: io)
            let value = 0xA55A_FFFE | scale.rawValue
            XCTAssertEqual(driver.controlStopModeVoltageScaling(scale), .ok)
            XCTAssertEqual(driver.getStopModeVoltageRange(), scale)
            XCTAssertEqual(io.accesses, [.read(.cr1, 0xA55A_FFFF), .write(.cr1, value), .read(.cr1, value)])
        }
    }

    func testSingleBitControlsUseOneReadAndWriteAndPreserveOtherBits() {
        let cases: [(PowerExtendedRegister, UInt32, (Driver) -> Void, (Driver) -> Void)] = [
            (.cr1, 0x200, { $0.enableFlashPowerDown() }, { $0.disableFlashPowerDown() }),
            (.csr2, 0x0200_0000, { $0.enableUSBRegulator() }, { $0.disableUSBRegulator() }),
            (.csr2, 0x0800_0000, { $0.enableUSBHSRegulator() }, { $0.disableUSBHSRegulator() }),
            (.ucpdr, 2, { $0.enableUCPDStandbyMode() }, { $0.disableUCPDStandbyMode() }),
            (.ucpdr, 1, { $0.disableUCPDDeadBattery() }, { $0.enableUCPDDeadBattery() }),
            (.csr2, 0x4000, { $0.enableXSPIM1() }, { $0.disableXSPIM1() }),
            (.csr2, 0x8000, { $0.enableXSPIM2() }, { $0.disableXSPIM2() }),
            (.csr1, 0x10, { $0.enableMonitoring() }, { $0.disableMonitoring() }),
            (.cr1, 0x2000, { $0.enableAVD() }, { $0.disableAVD() }),
            (.apcr, 1, { $0.enablePullUpPullDownConfiguration() }, { $0.disablePullUpPullDownConfiguration() }),
            (.extiInterruptMask, 0x10000, { $0.enableAVDInterrupt() }, { $0.disableAVDInterrupt() }),
            (.extiEventMask, 0x10000, { $0.enableAVDEvent() }, { $0.disableAVDEvent() }),
            (.extiRisingTrigger, 0x10000, { $0.enableAVDRisingEdge() }, { $0.disableAVDRisingEdge() }),
            (.extiFallingTrigger, 0x10000, { $0.enableAVDFallingEdge() }, { $0.disableAVDFallingEdge() }),
        ]
        for (register, mask, enable, disable) in cases {
            for initial in [UInt32(0xA55A_55AA), UInt32.max] {
                let io = PowerExtendedTestRegisters()
                io.values[register] = initial
                let driver = Driver(registers: io)
                enable(driver); disable(driver)
                XCTAssertEqual(io.accesses, [.read(register, initial), .write(register, initial | mask),
                    .read(register, initial | mask), .write(register, initial & ~mask)], "\(register), \(mask)")
            }
        }
    }

    func testAnalogBoosterUsesSeparateWritesInOppositeEnableDisableOrders() {
        let io = PowerExtendedTestRegisters()
        io.values[.cr1] = 0x8000_0001
        let driver = Driver(registers: io)
        driver.enableAnalogBooster(); driver.disableAnalogBooster()
        XCTAssertEqual(io.accesses, [
            .read(.cr1, 0x8000_0001), .write(.cr1, 0x8000_1001),
            .read(.cr1, 0x8000_1001), .write(.cr1, 0x8000_1801),
            .read(.cr1, 0x8000_1801), .write(.cr1, 0x8000_1001),
            .read(.cr1, 0x8000_1001), .write(.cr1, 0x8000_0001),
        ])
    }

    func testBatteryChargingClearsResistorSelectionWhenDisabled() {
        for resistor in PowerBatteryChargingResistor.allCases {
            let io = PowerExtendedTestRegisters()
            io.values[.csr2] = 0xA500_03F6
            let driver = Driver(registers: io)
            driver.enableBatteryCharging(resistor)
            driver.disableBatteryCharging()
            let enabled = 0xA500_01F6 | resistor.rawValue
            XCTAssertEqual(io.accesses, [.read(.csr2, 0xA500_03F6), .write(.csr2, enabled),
                .read(.csr2, enabled), .write(.csr2, 0xA500_00F6)])
        }
    }

    func testXSPICapacitorBothPortsAllSettingsUsePortOneEncodingForReadback() {
        for port in PowerXSPICapacitorPort.allCases {
            for setting in PowerXSPICapacitance.allCases {
                let io = PowerExtendedTestRegisters()
                io.values[.csr2] = 0xA555_FFFF
                let driver = Driver(registers: io)
                driver.configureXSPIPortCapacitor(port, setting: setting)
                let value = port == .port1 ? 0xA555_F3FF | setting.rawValue : 0xA555_CFFF | (setting.rawValue << 2)
                XCTAssertEqual(driver.getXSPIPortCapacitorConfiguration(port), setting)
                XCTAssertEqual(io.accesses, [.read(.csr2, 0xA555_FFFF), .write(.csr2, value), .read(.csr2, value)])
            }
        }
    }

    func testRegulatorAndUSBDetectorPollingOrderStrictTimeoutAndTickWrap() {
        for operation in 0..<4 {
            for start in [UInt32(17), UInt32.max - 9] {
                for succeeds in [false, true] {
                    let io = PowerExtendedTestRegisters()
                    let driver = Driver(registers: io)
                    let register: PowerExtendedRegister = operation < 2 ? .csr1 : .csr2
                    let enableMask: UInt32 = operation < 2 ? 1 : 0x0100_0000
                    let readyMask: UInt32 = operation < 2 ? 0x10000 : 0x0400_0000
                    let enabling = operation == 0 || operation == 2
                    let initial = UInt32(0x8000_0000) | (enabling ? 0 : enableMask | readyMask)
                    let written = enabling ? initial | enableMask : initial & ~enableMask
                    let ready = enabling ? written | readyMask : written & ~readyMask
                    io.scriptedReads[register] = [initial, written, succeeds ? ready : written]
                    io.ticks = succeeds ? [start, start &+ 1000] : [start, start &+ 1000, start &+ 1001]
                    let result: HALStatus
                    switch operation {
                    case 0: result = driver.enableBackupRegulator(getTick: io.getTick)
                    case 1: result = driver.disableBackupRegulator(getTick: io.getTick)
                    case 2: result = driver.enableUSBVoltageDetector(getTick: io.getTick)
                    default: result = driver.disableUSBVoltageDetector(getTick: io.getTick)
                    }
                    XCTAssertEqual(result, succeeds ? .ok : .error)
                    var expected: [PowerExtendedAccess] = [.read(register, initial), .write(register, written),
                        .tick(start), .read(register, written), .tick(start &+ 1000), .read(register, succeeds ? ready : written)]
                    if !succeeds { expected.append(.tick(start &+ 1001)) }
                    XCTAssertEqual(io.accesses, expected)
                    XCTAssertEqual(io.values[register], written, "No rollback on timeout")
                }
            }
        }
    }

    func testPollingStillGetsStartTickWhenReadyImmediately() {
        let io = PowerExtendedTestRegisters()
        io.values[.csr1] = 0x10000
        io.ticks = [7]
        XCTAssertEqual(Driver(registers: io).enableBackupRegulator(getTick: io.getTick), .ok)
        XCTAssertEqual(io.accesses, [.read(.csr1, 0x10000), .write(.csr1, 0x10001), .tick(7), .read(.csr1, 0x10001)])
    }

    func testWakeupConfigurationAllPinsPolaritiesAndPullsReplacesAllEXTIMasks() {
        let pins: [(PowerWakeUpPin, UInt32, UInt32, UInt32, UInt32)] = [
            (.pin1High, 0x00030101, 0x100, 16, 0x00800000), (.pin1Low, 0x00030101, 0x100, 16, 0x80800000),
            (.pin2High, 0x000C0202, 0x200, 18, 0x01000000), (.pin2Low, 0x000C0202, 0x200, 18, 0x01000000),
            (.pin3High, 0x00300404, 0x400, 20, 0x02000000), (.pin3Low, 0x00300404, 0x400, 20, 0x02000000),
            (.pin4High, 0x00C00808, 0x800, 22, 0x04000000), (.pin4Low, 0x00C00808, 0x800, 22, 0x04000000),
        ]
        for (pin, mask, polarityMask, pullShift, interruptBits) in pins {
            for polarity in PowerWakeUpPolarity.allCases {
                for pull in PowerWakeUpPull.allCases {
                    let io = PowerExtendedTestRegisters()
                    io.values = [.wakeupEnablePolarity: UInt32.max, .extiInterruptMask2: UInt32.max]
                    let driver = Driver(registers: io)
                    driver.enableWakeUpPin(.init(pin: pin, polarity: polarity, pull: pull))
                    let configured = ~mask | pin.rawValue | (polarity == .low ? polarityMask : 0) | (pull.rawValue << pullShift)
                    XCTAssertEqual(io.accesses, [.read(.wakeupEnablePolarity, UInt32.max), .write(.wakeupEnablePolarity, configured),
                        .read(.extiInterruptMask2, UInt32.max), .write(.extiInterruptMask2, 0xF87FFFFF | interruptBits)])
                    io.accesses = []
                    driver.disableWakeUpPin(pin)
                    XCTAssertEqual(io.accesses, [.read(.wakeupEnablePolarity, configured),
                        .write(.wakeupEnablePolarity, configured & ~pin.rawValue)])
                }
            }
        }
    }

    func testWakeupFunctionDirectClearReadbackAndInvertedMacroAreDistinct() {
        for flag in PowerWakeUpFlag.allCases {
            for clears in [false, true] {
                let io = PowerExtendedTestRegisters()
                io.values = [.wakeupFlags: 15, .wakeupClear: 0x8000_0000]
                io.clearWakeupFlagsOnWrite = clears
                let driver = Driver(registers: io)
                XCTAssertEqual(driver.getWakeupFlag(flag), flag.rawValue)
                XCTAssertEqual(driver.getWakeupFlagStatus(flag), 0)
                XCTAssertEqual(driver.clearWakeupFlag(flag), clears ? .ok : .error)
                let remaining = clears ? 15 & ~flag.rawValue : 15
                XCTAssertEqual(driver.getWakeupFlagStatus(flag), clears ? 1 : 0)
                XCTAssertEqual(io.accesses, [.read(.wakeupFlags, 15), .read(.wakeupFlags, 15),
                    .write(.wakeupClear, flag.rawValue), .read(.wakeupFlags, remaining), .read(.wakeupFlags, remaining)])
            }
        }
    }

    func testLowEncodedWakeupPinPreservesUpstreamUnmaskedEXTIShift() {
        let io = PowerExtendedTestRegisters()
        Driver(registers: io).enableWakeUpPin(.init(pin: .pin1Low, polarity: .high, pull: .none))
        // IS_PWR_WAKEUP_PIN accepts 0x101, which C shifts directly into IMR2.
        XCTAssertEqual(io.accesses, [.read(.wakeupEnablePolarity, 0), .write(.wakeupEnablePolarity, 0x101),
            .read(.extiInterruptMask2, 0), .write(.extiInterruptMask2, 0x8080_0000)])
    }

    func testWakeupIRQChecksEachFlagAgainAndClearsBeforeCallback() {
        for flags in UInt32(0)...15 {
            let io = PowerExtendedTestRegisters()
            io.clearWakeupFlagsOnWrite = true
            io.values = [.wakeupFlags: flags, .wakeupClear: 0x8000_0000]
            let driver = Driver(registers: io)
            let callback: (Int) -> Void = { pin in
                XCTAssertEqual(io.values[.wakeupFlags, default: 0] & (1 << (pin - 1)), 0)
                io.accesses.append(.callback(pin))
            }
            driver.handleWakeUpPinInterrupt(pin1: { callback(1) }, pin2: { callback(2) },
                                             pin3: { callback(3) }, pin4: { callback(4) })
            var remaining = flags
            var expected: [PowerExtendedAccess] = []
            for pin in 1...4 {
                let mask = UInt32(1) << (pin - 1)
                expected.append(.read(.wakeupFlags, remaining))
                if (remaining & mask) != 0 {
                    expected += [.read(.wakeupClear, 0x8000_0000), .write(.wakeupClear, 0x8000_0000 | mask), .callback(pin)]
                    remaining &= ~mask
                }
            }
            XCTAssertEqual(io.accesses, expected)
        }
    }

    func testWakeupCallbackCanExposeANewLaterFlagThroughIndependentHandle() {
        let io = PowerExtendedTestRegisters()
        io.values[.wakeupFlags] = 1
        io.clearWakeupFlagsOnWrite = true
        let driver = Driver(registers: io)
        let interruptHandle = Driver(registers: io)
        driver.handleWakeUpPinInterrupt(pin1: {
            XCTAssertEqual(interruptHandle.getWakeupFlag(.all), 0)
            io.values[.wakeupFlags] = 8
        }, pin4: { io.accesses.append(.callback(4)) })
        XCTAssertEqual(io.accesses.last, .callback(4))
        XCTAssertEqual(io.values[.wakeupFlags], 0)
    }

    func testMonitoringBothThresholdBitsReturnBetweenThresholds() {
        for temperature in UInt32(0)...3 {
            for battery in UInt32(0)...3 {
                let io = PowerExtendedTestRegisters()
                let value = 0xA500_0001 | (temperature << 22) | (battery << 20)
                io.values[.csr1] = value
                let driver = Driver(registers: io)
                XCTAssertEqual(driver.getTemperatureLevel().rawValue, temperature == 1 ? 0x400000 : temperature == 2 ? 0x800000 : 0)
                XCTAssertEqual(driver.getVBATLevel().rawValue, battery == 1 ? 0x100000 : battery == 2 ? 0x200000 : 0)
                XCTAssertEqual(io.accesses, [.read(.csr1, value), .read(.csr1, value)])
            }
        }
    }

    func testAVDAllLevelsAndModesResetEXTIThenEnableSelectedModeInOrder() {
        for level in PowerAVDLevel.allCases {
            for mode in PowerAVDMode.allCases {
                let io = PowerExtendedTestRegisters()
                for register in PowerExtendedRegister.allCases { io.values[register] = UInt32.max }
                Driver(registers: io).configureAVD(.init(level: level, mode: mode))
                var expected: [PowerExtendedAccess] = [.read(.cr1, UInt32.max), .write(.cr1, 0xFFFF3FFF | level.rawValue)]
                for register: PowerExtendedRegister in [.extiEventMask, .extiInterruptMask, .extiRisingTrigger, .extiFallingTrigger] {
                    expected += [.read(register, UInt32.max), .write(register, 0xFFFEFFFF)]
                }
                let selected: [PowerExtendedRegister]
                switch mode {
                case .normal: selected = []
                case .interruptRising: selected = [.extiInterruptMask, .extiRisingTrigger]
                case .interruptFalling: selected = [.extiInterruptMask, .extiFallingTrigger]
                case .interruptRisingFalling: selected = [.extiInterruptMask, .extiRisingTrigger, .extiFallingTrigger]
                case .eventRising: selected = [.extiEventMask, .extiRisingTrigger]
                case .eventFalling: selected = [.extiEventMask, .extiFallingTrigger]
                case .eventRisingFalling: selected = [.extiEventMask, .extiRisingTrigger, .extiFallingTrigger]
                }
                for register in selected { expected += [.read(register, 0xFFFEFFFF), .write(register, UInt32.max)] }
                XCTAssertEqual(io.accesses, expected)
            }
        }
    }

    func testPVDAVDHandlerClearsOnlyLine16BeforeCallback() {
        for pending in [UInt32(0x40), 0x10040] {
            let io = PowerExtendedTestRegisters()
            io.values[.extiPending] = pending
            Driver(registers: io).handlePVDAVDInterrupt {
                XCTAssertEqual(io.values[.extiPending], 0x40)
                io.accesses.append(.callback(16))
            }
            XCTAssertEqual(io.accesses, pending == 0x40 ? [.read(.extiPending, pending)] :
                [.read(.extiPending, pending), .write(.extiPending, 0x10000), .callback(16)])
        }
    }

    func testAVDEdgeAndPendingMacrosKeepTheirAccessOrder() {
        let io = PowerExtendedTestRegisters()
        io.values = [.extiRisingTrigger: 1, .extiFallingTrigger: 2, .extiPending: 0x10040, .extiSoftwareInterrupt: 4]
        let driver = Driver(registers: io)
        driver.enableAVDRisingFallingEdge(); driver.disableAVDRisingFallingEdge()
        XCTAssertTrue(driver.getAVDFlag()); driver.clearAVDFlag(); XCTAssertFalse(driver.getAVDFlag())
        driver.generateAVDSoftwareInterrupt()
        XCTAssertEqual(io.accesses, [.read(.extiRisingTrigger, 1), .write(.extiRisingTrigger, 0x10001),
            .read(.extiFallingTrigger, 2), .write(.extiFallingTrigger, 0x10002),
            .read(.extiRisingTrigger, 0x10001), .write(.extiRisingTrigger, 1),
            .read(.extiFallingTrigger, 0x10002), .write(.extiFallingTrigger, 2),
            .read(.extiPending, 0x10040), .write(.extiPending, 0x10000), .read(.extiPending, 0x40),
            .read(.extiSoftwareInterrupt, 4), .write(.extiSoftwareInterrupt, 0x10004)])
    }

    func testPullConfigurationAllSupportedPinSubsetsAndRawMasksNeverChangesOppositePull() {
        let groups: [(PowerPullDownPort, [UInt16], [UInt16])] = [
            (.n, [2, 0x40, 0x1000], [1, 2, 4, 0x40, 0x100, 0x1000]),
            (.o, [1, 2, 0x10], [1, 2, 4, 8, 0x10]),
            (.p, [], [1, 0x10, 0x100, 0x1000]),
        ]
        for (port, upBits, downBits) in groups {
            for isPullUp in [false, true] {
                let bits = isPullUp ? upBits : downBits
                if bits.isEmpty { continue }
                var masks: [UInt16] = [0xFFFF, 0xA55A]
                for combination in 1..<(1 << bits.count) {
                    var mask: UInt16 = 0
                    for (index, bit) in bits.enumerated() where (combination & (1 << index)) != 0 { mask |= bit }
                    masks.append(mask)
                }
                for pins in masks {
                    let io = PowerExtendedTestRegisters()
                    for register in PowerExtendedRegister.allCases { io.values[register] = 0xA500_55AA }
                    let driver = Driver(registers: io)
                    let register: PowerExtendedRegister
                    if isPullUp {
                        register = port == .n ? .pullUpN : .pullUpO
                        let upPort = PowerPullUpPort(rawValue: port.rawValue)!
                        XCTAssertEqual(driver.enableGPIOPullUp(port: upPort, pins: pins), .ok)
                        XCTAssertEqual(driver.disableGPIOPullUp(port: upPort, pins: pins), .ok)
                    } else {
                        register = port == .n ? .pullDownN : port == .o ? .pullDownO : .pullDownP
                        XCTAssertEqual(driver.enableGPIOPullDown(port: port, pins: pins), .ok)
                        XCTAssertEqual(driver.disableGPIOPullDown(port: port, pins: pins), .ok)
                    }
                    let enabled = 0xA500_55AA | UInt32(pins)
                    XCTAssertEqual(io.accesses, [.read(register, 0xA500_55AA), .write(register, enabled),
                        .read(register, enabled), .write(register, 0xA500_55AA & ~UInt32(pins))])
                    for other in PowerExtendedRegister.allCases where other != register {
                        XCTAssertEqual(io.values[other], 0xA500_55AA)
                    }
                }
            }
        }
    }

    func testFlagMacrosSelectExactRegisterAndPreserveTheirFallbacks() {
        let flags: [(PowerFlag, PowerExtendedRegister, UInt32)] = [
            (.activeVoltage, .sr1, 1), (.activeVoltageReady, .sr1, 2), (.pvdOutput, .sr1, 0x10), (.avdOutput, .sr1, 0x2000),
            (.backupRegulatorReady, .csr1, 0x10000), (.vbatLow, .csr1, 0x100000), (.vbatHigh, .csr1, 0x200000),
            (.temperatureLow, .csr1, 0x400000), (.temperatureHigh, .csr1, 0x800000),
            (.externalSupplyReady, .csr2, 0x10000), (.usb33Ready, .csr2, 0x4000000),
            (.stop, .csr3, 0x100), (.standby, .csr3, 0x200), (.voltageReady, .csr4, 2),
            (.wakeup1, .wakeupFlags, 1), (.wakeup2, .wakeupFlags, 2), (.wakeup3, .wakeupFlags, 4),
            (.wakeup4, .wakeupFlags, 8), (.wakeupAll, .wakeupFlags, 8),
        ]
        for (flag, register, mask) in flags {
            let io = PowerExtendedTestRegisters()
            let driver = Driver(registers: io)
            io.values[register] = mask
            XCTAssertTrue(driver.getFlag(flag))
            io.values[register] = ~mask
            XCTAssertFalse(driver.getFlag(flag))
            XCTAssertEqual(io.accesses, [.read(register, mask), .read(register, ~mask)])
        }
        for flag in PowerFlag.allCases {
            let io = PowerExtendedTestRegisters()
            io.values = [.csr3: 0x8000_0300, .wakeupClear: 0x8000_0000]
            Driver(registers: io).clearFlag(flag)
            let register: PowerExtendedRegister = flag == .stop || flag == .standby ? .csr3 : .wakeupClear
            let bits: UInt32
            switch flag {
            case .stop, .standby: bits = 2
            case .wakeup1: bits = 1
            case .wakeup2: bits = 2
            case .wakeup3: bits = 4
            case .wakeup4: bits = 8
            default: bits = 15
            }
            let initial: UInt32 = register == .csr3 ? 0x8000_0300 : 0x8000_0000
            XCTAssertEqual(io.accesses, [.read(register, initial), .write(register, initial | bits)])
        }
    }
}
