import XCTest
@testable import STM32H7RSHAL

private enum RCCTrace: Equatable {
    case read(RCCClockRegister), write(RCCClockRegister, UInt32)
    case readControl(RCCControlRegister), writeControl(RCCControlRegister, UInt32)
    case readFlash, writeFlash(UInt32)
    case tick(UInt32), priority, coreClock, updateCoreClock(UInt32), initializeTick(UInt32, UInt32)
    case gpio(GPIOPort, UInt16, UInt32, UInt32, UInt32, UInt32)
    case callback
}

private final class RCCTraceState: RCCRegisterIO, RCCSystemIO {
    var values: [RCCClockRegister: UInt32] = [:]
    var control: [RCCControlRegister: UInt32] = [:]
    var scriptedReads: [RCCClockRegister: [UInt32]] = [:]
    var scriptedControlReads: [RCCControlRegister: [UInt32]] = [:]
    var flash: UInt32 = 0
    var tick: UInt32 = 0
    var tickStep: UInt32 = 1
    var priority: UInt32 = 15
    var coreClock: UInt32 = 64_000_000
    var tickStatus: HALStatus = .ok
    var automaticReady = false
    var rejectFlashLatency = false
    var lockPLLSource = false
    var trace: [RCCTrace] = []

    func read(_ register: RCCClockRegister) -> UInt32 {
        trace.append(.read(register))
        if var pending = scriptedReads[register], !pending.isEmpty {
            let value = pending.removeFirst()
            scriptedReads[register] = pending
            return value
        }
        return values[register, default: 0]
    }

    func write(_ register: RCCClockRegister, value: UInt32) {
        trace.append(.write(register, value))
        var stored = value
        if automaticReady && register == .cr {
            for (enable, ready): (UInt32, UInt32) in [
                (1, 4), (0x80, 0x100), (0x1000, 0x2000), (0x10000, 0x20000),
                (0x01000000, 0x02000000), (0x04000000, 0x08000000), (0x10000000, 0x20000000),
            ] {
                if (value & enable) != 0 { stored |= ready } else { stored &= ~ready }
            }
            if (value & 1) != 0 { stored |= 0x20 }
        }
        if automaticReady && register == .cfgr { stored = (stored & ~UInt32(0x38)) | ((stored & 7) << 3) }
        if lockPLLSource && register == .pllckselr {
            stored = (stored & ~UInt32(3)) | (values[.pllckselr, default: 0] & 3)
        }
        values[register] = stored
    }

    func read(_ register: RCCControlRegister) -> UInt32 {
        trace.append(.readControl(register))
        if var pending = scriptedControlReads[register], !pending.isEmpty {
            let value = pending.removeFirst()
            scriptedControlReads[register] = pending
            return value
        }
        return control[register, default: 0]
    }

    func write(_ register: RCCControlRegister, value: UInt32) {
        trace.append(.writeControl(register, value))
        control[register] = value
        if register == .cicr { control[.cifr, default: 0] &= ~value }
        if automaticReady && (register == .bdcr || register == .csr) {
            control[register] = (value & 1) != 0 ? value | 2 : value & ~UInt32(2)
        }
    }

    func read(_ register: FlashTimingRegister) -> UInt32 { trace.append(.readFlash); return flash }
    func write(_ register: FlashTimingRegister, value: UInt32) {
        trace.append(.writeFlash(value))
        if !rejectFlashLatency { flash = value }
    }
    func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration) {
        trace.append(.gpio(port, configuration.pins, configuration.mode.rawValue,
                           configuration.pull.rawValue, configuration.speed.rawValue, configuration.alternate))
    }
    func getTick() -> UInt32 {
        let value = tick
        trace.append(.tick(value))
        tick &+= tickStep
        return value
    }
    func getTickPriority() -> UInt32 { trace.append(.priority); return priority }
    func getSystemCoreClock() -> UInt32 { trace.append(.coreClock); return coreClock }
    func setSystemCoreClock(_ frequency: UInt32) { trace.append(.updateCoreClock(frequency)); coreClock = frequency }
    func initializeTick(priority: UInt32, coreClockHz: UInt32) -> HALStatus {
        trace.append(.initializeTick(priority, coreClockHz))
        return tickStatus
    }
    var writes: [RCCTrace] {
        trace.filter { access in
            switch access {
            case .write, .writeControl, .writeFlash, .gpio, .updateCoreClock, .initializeTick, .callback: return true
            default: return false
            }
        }
    }
}

final class RCCControlTests: XCTestCase {
    func testNullConfigurationsReturnErrorWithoutAnyAccess() {
        let io = RCCTraceState()
        var rcc = RCC(registers: io, system: io)
        var oscillator: RCCOscillatorConfiguration?
        XCTAssertEqual(rcc.configureOscillators(&oscillator), .error)
        XCTAssertEqual(rcc.configureClock(nil, latency: .waitStates0), .error)
        XCTAssertTrue(io.trace.isEmpty)
    }

    func testUsedOscillatorCannotBeDisabledEvenWhenPLLIsNotSYSCLK() {
        let io = RCCTraceState()
        io.values = [.cfgr: 8, .pllckselr: 2, .cr: 0x0800_0000]
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(oscillatorType: 1, hseState: 0)
        XCTAssertEqual(rcc.configureOscillators(&configuration), .error)
        XCTAssertEqual(io.trace, [.read(.cfgr), .read(.pllckselr), .read(.cr)])
        XCTAssertTrue(io.writes.isEmpty)
    }

    func testHSIDividerChangeIsRejectedWhenAnyPLLUsesHSI() {
        let io = RCCTraceState()
        io.values = [.cfgr: 8, .pllckselr: 0, .cr: 0x0800_0008]
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(oscillatorType: 2, hsiState: 1, hsiDivider: 0)
        XCTAssertEqual(rcc.configureOscillators(&configuration), .error)
        XCTAssertEqual(io.trace, [.read(.cfgr), .read(.pllckselr), .read(.cr), .read(.cr)])
    }

    func testHSITickFailureRetainsDividerAndCoreClockButDoesNotAdjustTrim() {
        let io = RCCTraceState()
        io.values[.cr] = 0x25
        io.tickStatus = .error
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(oscillatorType: 2, hsiState: 1,
                                                       hsiDivider: 8, hsiCalibration: 0x40)
        XCTAssertEqual(rcc.configureOscillators(&configuration), .error)
        XCTAssertEqual(io.writes, [.write(.cr, 0x2D), .updateCoreClock(32_000_000), .initializeTick(15, 32_000_000)])
        XCTAssertEqual(io.coreClock, 32_000_000)
        XCTAssertNil(io.control[.hsicfgr])
    }

    func testHSISuccessRetimesBeforeAdjustingTrimWithoutPollingReady() {
        let io = RCCTraceState()
        io.values[.cr] = 0x25
        io.control[.hsicfgr] = 0x8000_0001
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(oscillatorType: 2, hsiState: 1,
                                                       hsiDivider: 8, hsiCalibration: 0x40)
        XCTAssertEqual(rcc.configureOscillators(&configuration), .ok)
        XCTAssertEqual(io.trace, [
            .read(.cfgr), .read(.pllckselr), .read(.cr), .read(.cr),
            .read(.cr), .write(.cr, 0x2D), .read(.cr), .updateCoreClock(32_000_000),
            .priority, .coreClock, .initializeTick(15, 32_000_000),
            .readControl(.hsicfgr), .writeControl(.hsicfgr, 0xC000_0001),
        ])
    }

    func testHSEOffUsesThreeDistinctWritesInUpstreamOrder() {
        let io = RCCTraceState()
        io.values = [.cfgr: 8, .cr: 0xD0000]
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(oscillatorType: 1)
        XCTAssertEqual(rcc.configureOscillators(&configuration), .ok)
        XCTAssertEqual(io.writes, [.write(.cr, 0xC0000), .write(.cr, 0x40000), .write(.cr, 0)])
    }

    func testLSEOffEnablesBackupAccessAndPreservesOtherBits() {
        let io = RCCTraceState()
        io.control = [.powerControl1: 0x8000_0000, .bdcr: 0x0001_0085]
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(oscillatorType: 4)
        XCTAssertEqual(rcc.configureOscillators(&configuration), .ok)
        XCTAssertEqual(io.writes, [
            .writeControl(.powerControl1, 0x8000_0100), .writeControl(.bdcr, 0x0001_0084),
            .writeControl(.bdcr, 0x0001_0004), .writeControl(.bdcr, 0x0001_0000),
        ])
    }

    func testOscillatorTimeoutUsesStrictComparisonAcrossTickWrap() {
        let io = RCCTraceState()
        io.tick = UInt32.max - 1
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(oscillatorType: 8, lsiState: 1)
        XCTAssertEqual(rcc.configureOscillators(&configuration), .timeout)
        XCTAssertEqual(io.trace.filter { if case .tick = $0 { true } else { false } },
                       [.tick(UInt32.max - 1), .tick(UInt32.max), .tick(0)])
        XCTAssertEqual(io.control[.csr], 1)
    }

    func testLivePLL1FractionalUpdateLeavesOtherFactorsAndInputTUnchanged() {
        let io = RCCTraceState()
        io.values = [.cfgr: 0x18, .cr: 0x0300_0000, .pllckselr: 2, .pllcfgr: 0x21, .pll1fracr: 5 << 3]
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(pll1: .init(state: 2, t: 7, fractional: 9))
        XCTAssertEqual(rcc.configureOscillators(&configuration), .ok)
        XCTAssertEqual(configuration.pll1.t, 7)
        XCTAssertEqual(io.writes, [.write(.pllcfgr, 0x20), .write(.pll1fracr, 9 << 3), .write(.pllcfgr, 0x21)])
        XCTAssertEqual(io.trace.filter { if case .tick = $0 { true } else { false } }, [.tick(0), .tick(1)])
    }

    func testLivePLL1ZeroFractionStillEnablesFractionalLatch() {
        let io = RCCTraceState()
        io.values = [.cfgr: 0x18, .cr: 0x0300_0000, .pllckselr: 2,
                     .pllcfgr: 0x20, .pll1fracr: 0x8000_004F]
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(pll1: .init(state: 2, fractional: 0))
        XCTAssertEqual(rcc.configureOscillators(&configuration), .ok)
        XCTAssertEqual(io.writes, [.write(.pllcfgr, 0x20), .write(.pll1fracr, 0x8000_0007), .write(.pllcfgr, 0x21)])
    }

    func testPLLSourceWriteFailureStopsBeforeProgrammingDividers() {
        let io = RCCTraceState()
        io.lockPLLSource = true
        var rcc = RCC(registers: io, system: io)
        let configuration = RCCPLLConfiguration(state: 2, source: 2, m: 4, n: 100, p: 1, q: 15, r: 2, s: 2, t: 1)
        XCTAssertEqual(rcc.configurePLL(0, configuration: configuration), .error)
        XCTAssertEqual(io.writes, [.write(.pllcfgr, 0), .write(.cr, 0), .write(.pllckselr, 0x42)])
        XCTAssertEqual(io.values[.pllckselr], 0x40)
    }

    func testPLLTimeoutMapsToErrorAfterMutatingInputT() {
        let io = RCCTraceState()
        io.values[.cfgr] = 8
        var rcc = RCC(registers: io, system: io)
        var configuration = RCCOscillatorConfiguration(pll1: .init(state: 2, source: 2, m: 4, n: 100,
                                                                   p: 1, q: 15, r: 2, s: 3, t: 7))
        XCTAssertEqual(rcc.configureOscillators(&configuration), .error)
        XCTAssertEqual(configuration.pll1.t, 1)
        XCTAssertEqual(io.values[.pll1divr2], 2)
        XCTAssertTrue(io.writes.contains(.write(.cr, 0x0100_0000)))
        XCTAssertFalse(io.writes.contains { if case .initializeTick = $0 { true } else { false } })

        let helperIO = RCCTraceState()
        var helper = RCC(registers: helperIO, system: helperIO)
        XCTAssertEqual(helper.configurePLL(0, configuration: configuration.pll1), .timeout)
    }

    func testDisabledPLLUsesTheUpstreamAdditionalDIVMShift() {
        for number: UInt32 in 0..<3 {
            let io = RCCTraceState()
            io.values[.pllckselr] = UInt32.max
            var rcc = RCC(registers: io, system: io)
            XCTAssertEqual(rcc.configurePLL(number, configuration: .init(state: 1)), .ok)
            let expected = (UInt32.max & ~((UInt32(0x3F0) << (4 + 8 * number)) | 3)) | 3
            XCTAssertEqual(io.values[.pllckselr], expected)
        }
    }

    func testClockIncreasePreservesFlashBusAndSwitchOrdering() {
        let io = RCCTraceState()
        io.automaticReady = true
        io.values[.cr] = 0x0003_0000
        var rcc = RCC(registers: io, system: io)
        let configuration = RCCClockConfiguration(clockType: 63, systemSource: 2, systemDivider: 8,
                                                   ahbDivider: 8, apb1Divider: 4, apb2Divider: 0x40,
                                                   apb4Divider: 0x400, apb5Divider: 0x4000)
        XCTAssertEqual(rcc.configureClock(configuration, latency: .waitStates7), .ok)
        XCTAssertEqual(io.writes, [
            .writeFlash(0x37), .write(.apbcfgr, 4), .write(.apbcfgr, 0x44),
            .write(.apbcfgr, 0x444), .write(.apbcfgr, 0x4444),
            .write(.bmcfgr, 8), .write(.cdcfgr, 8), .write(.cfgr, 2),
            .updateCoreClock(12_000_000), .initializeTick(15, 12_000_000),
        ])
    }

    func testClockDecreasePreservesSwitchAHBFlashAndAPBOrdering() {
        let io = RCCTraceState()
        io.automaticReady = true
        io.values = [.cfgr: 0x1B, .cr: 0x25, .bmcfgr: 15, .apbcfgr: 0x7777]
        io.flash = 0x37
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.configureClock(.init(clockType: 63), latency: .waitStates0), .ok)
        XCTAssertEqual(io.writes, [
            .write(.cdcfgr, 0), .write(.cfgr, 0x18), .write(.bmcfgr, 0), .writeFlash(0),
            .write(.apbcfgr, 0x7770), .write(.apbcfgr, 0x7700),
            .write(.apbcfgr, 0x7000), .write(.apbcfgr, 0),
            .updateCoreClock(64_000_000), .initializeTick(15, 64_000_000),
        ])
    }

    func testClockNotReadyFailureRetainsEarlierChanges() {
        let io = RCCTraceState()
        var rcc = RCC(registers: io, system: io)
        let configuration = RCCClockConfiguration(clockType: 7, systemSource: 2, systemDivider: 8,
                                                   ahbDivider: 9, apb1Divider: 5)
        XCTAssertEqual(rcc.configureClock(configuration, latency: .waitStates3), .error)
        XCTAssertEqual(io.writes, [.writeFlash(0x13), .write(.apbcfgr, 5), .write(.bmcfgr, 9), .write(.cdcfgr, 8)])
        XCTAssertEqual(io.coreClock, 64_000_000)
    }

    func testFlashReadbackFailureStopsBeforeAnyClockChange() {
        let io = RCCTraceState()
        io.flash = 0x80
        io.rejectFlashLatency = true
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.configureClock(.init(clockType: 1, systemSource: 2), latency: .waitStates3), .error)
        XCTAssertEqual(io.trace, [.readFlash, .readFlash, .writeFlash(0x93), .readFlash])
        XCTAssertEqual(io.coreClock, 64_000_000)
    }

    func testFrozenClockSwitchReturnsTimeoutWithoutUpdatingCachedClock() {
        let io = RCCTraceState()
        io.values[.cr] = 0x20000
        io.tickStep = 1001
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.configureClock(.init(clockType: 1, systemSource: 2), latency: .waitStates0), .timeout)
        XCTAssertEqual(io.writes, [.write(.cdcfgr, 0), .write(.cfgr, 2)])
        XCTAssertEqual(io.trace.filter { if case .tick = $0 { true } else { false } },
                       [.tick(0), .tick(1001), .tick(2002), .tick(3003), .tick(4004), .tick(5005)])
        XCTAssertEqual(io.coreClock, 64_000_000)
    }

    func testDeinitializeLowHCLKBranchKeepsCachedClockAndExistingTrimBits() {
        let io = RCCTraceState()
        io.automaticReady = true
        io.values[.cfgr] = 0x12
        io.control[.hsicfgr] = 0x1100_0000
        io.coreClock = 24_000_000
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.deinitialize(), .ok)
        XCTAssertEqual(io.coreClock, 24_000_000)
        XCTAssertEqual(io.control[.hsicfgr], 0x5100_0000)
        XCTAssertFalse(io.writes.contains { if case .updateCoreClock = $0 { true } else { false } })
        let expectedStart: [RCCTrace] = [
            .tick(0), .read(.cr), .write(.cr, 1), .read(.cr),
            .readControl(.hsicfgr), .writeControl(.hsicfgr, 0x5100_0000),
            .read(.cfgr), .read(.cdcfgr), .read(.bmcfgr),
            .readFlash, .writeFlash(1), .write(.cfgr, 0),
            .priority, .coreClock, .initializeTick(15, 24_000_000),
            .tick(1), .read(.cfgr),
        ]
        XCTAssertEqual(Array(io.trace.prefix(expectedStart.count)), expectedStart)
        XCTAssertEqual(io.values[.pll1divr1], 0x0101_0280)
        XCTAssertEqual(io.values[.pll2divr2], 0x101)
        XCTAssertEqual(io.control[.cicr], UInt32.max)
    }

    func testDeinitializeHighHCLKBranchUpdatesTickBeforeReducingFlashLatency() {
        let io = RCCTraceState()
        io.automaticReady = true
        io.values = [.cfgr: 0x1B, .cr: 0x0303_0000, .pllckselr: 0x42, .pll1divr1: 99]
        io.flash = 0x37
        io.coreClock = 600_000_000
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.deinitialize(), .ok)
        XCTAssertEqual(io.coreClock, 64_000_000)
        let switchIndex = io.trace.firstIndex(of: .write(.cfgr, 0))!
        let tickIndex = io.trace.firstIndex(of: .initializeTick(15, 64_000_000))!
        let flashIndex = io.trace.firstIndex(of: .writeFlash(1))!
        XCTAssertLessThan(switchIndex, tickIndex)
        XCTAssertLessThan(tickIndex, flashIndex)
    }

    func testClockGetterReadsSWAndEachAPBFieldSeparately() {
        let io = RCCTraceState()
        io.values[.cfgr] = 0x17
        io.scriptedReads[.apbcfgr] = [7, 0x60, 0x500, 0x4000]
        io.flash = 0x8000_002F
        var rcc = RCC(registers: io, system: io)
        let result = rcc.getClockConfiguration()
        XCTAssertEqual(result.configuration.systemSource, 7)
        XCTAssertEqual(result.configuration.apb1Divider, 7)
        XCTAssertEqual(result.configuration.apb2Divider, 0x60)
        XCTAssertEqual(result.configuration.apb4Divider, 0x500)
        XCTAssertEqual(result.configuration.apb5Divider, 0x4000)
        XCTAssertEqual(result.latency, 0x2F)
        XCTAssertEqual(io.trace, [.read(.cfgr), .read(.cdcfgr), .read(.bmcfgr),
                                  .read(.apbcfgr), .read(.apbcfgr), .read(.apbcfgr), .read(.apbcfgr), .readFlash])
    }

    func testOscillatorGetterKeepsRawFieldsAndOnlyPLL2HasT() {
        let io = RCCTraceState()
        for register in RCCClockRegister.allCases { io.values[register] = UInt32.max }
        for register in RCCControlRegister.allCases { io.control[register] = UInt32.max }
        var rcc = RCC(registers: io, system: io)
        let configuration = rcc.getOscillatorConfiguration()
        XCTAssertEqual(configuration.oscillatorType, 63)
        XCTAssertEqual(configuration.hseState, 0xD0000)
        XCTAssertEqual(configuration.lseState, 0x85)
        XCTAssertEqual(configuration.hsiCalibration, 127)
        XCTAssertEqual(configuration.pll1.source, 3)
        XCTAssertEqual(configuration.pll1.fractional, 8191)
        XCTAssertEqual(configuration.pll1.n, 512)
        XCTAssertEqual(configuration.pll2.p, 128)
        XCTAssertEqual(configuration.pll1.t, 0)
        XCTAssertEqual(configuration.pll2.t, 8)
        XCTAssertEqual(configuration.pll3.t, 0)
    }

    func testOscillatorGetterReadsEachPLLControlAndOnlyEnabledFractionsInOrder() {
        for enabled in UInt32(0)...7 {
            let io = RCCTraceState()
            // Each PLL's ON bit is present only in its own CR snapshot.
            io.scriptedReads[.cr] = [0x0100_0000, 0x0400_0000, 0x1000_0000]
            io.values[.pllcfgr] = (enabled & 1) | ((enabled & 2) << 10) | ((enabled & 4) << 20)
            io.values[.pll1fracr] = 5 << 3
            io.values[.pll2fracr] = 17 << 3
            io.values[.pll3fracr] = 8191 << 3
            var rcc = RCC(registers: io, system: io)
            let configuration = rcc.getOscillatorConfiguration()

            var expected: [RCCTrace] = [
                .readControl(.bdcr), .readControl(.csr), .read(.cr), .readControl(.hsicfgr),
                .read(.pllckselr), .read(.pllcfgr),
            ]
            if (enabled & 1) != 0 { expected.append(.read(.pll1fracr)) }
            expected += [.read(.pll1divr1), .read(.pll1divr2), .read(.cr),
                         .read(.pllckselr), .read(.pllcfgr)]
            if (enabled & 2) != 0 { expected.append(.read(.pll2fracr)) }
            expected += [.read(.pll2divr1), .read(.pll2divr2), .read(.cr),
                         .read(.pllckselr), .read(.pllcfgr)]
            if (enabled & 4) != 0 { expected.append(.read(.pll3fracr)) }
            expected += [.read(.pll3divr1), .read(.pll3divr2)]

            XCTAssertEqual(io.trace, expected, "FRACEN combination \(enabled)")
            XCTAssertEqual([configuration.pll1.state, configuration.pll2.state, configuration.pll3.state], [2, 2, 2])
            XCTAssertEqual(configuration.pll1.fractional, (enabled & 1) != 0 ? 5 : 0)
            XCTAssertEqual(configuration.pll2.fractional, (enabled & 2) != 0 ? 17 : 0)
            XCTAssertEqual(configuration.pll3.fractional, (enabled & 4) != 0 ? 8191 : 0)
        }
    }

    func testMCOEnablesGPIOBeforeConfigurationAndClockSelection() {
        let io = RCCTraceState()
        var rcc = RCC(registers: io, system: io)
        rcc.configureMCO(output: 0x1002_0200, source: 0xA000_0000, divider: 3 << 18)
        XCTAssertEqual(io.writes, [.writeControl(.ahb4enr, 4), .gpio(.c, 0x200, 2, 0, 3, 0), .write(.cfgr, 0xA600_0000)])
    }

    func testCSSUsesBit20AndNMIClearsBeforeCallingBack() {
        let io = RCCTraceState()
        io.values[.cr] = 0x0008_0000
        var rcc = RCC(registers: io, system: io)
        rcc.enableCSS()
        rcc.disableCSS()
        XCTAssertEqual(io.writes, [.write(.cr, 0x0018_0000), .write(.cr, 0x0008_0000)])
        io.trace = []
        io.control[.cifr] = 0x440
        rcc.handleNMI { io.trace.append(.callback); XCTAssertEqual(io.control[.cifr], 0x40) }
        XCTAssertEqual(io.trace, [.readControl(.cifr), .writeControl(.cicr, 0x400), .callback])
        io.trace = []
        rcc.handleNMI { XCTFail("Unexpected HSE callback") }
        XCTAssertEqual(io.trace, [.readControl(.cifr)])
    }

    func testResetSourceReturnsFirstReadAndClearsFlagsUsingSecondRead() {
        let io = RCCTraceState()
        io.scriptedControlReads[.rsr] = [UInt32.max, 0x1234_5678]
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.getResetSource(), 0x5562_0000)
        XCTAssertEqual(io.trace, [.readControl(.rsr), .readControl(.rsr), .writeControl(.rsr, 0x1235_5678)])
    }
}
