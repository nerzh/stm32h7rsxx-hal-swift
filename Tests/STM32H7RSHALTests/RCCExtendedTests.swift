import XCTest
@testable import STM32H7RSHAL

enum RCCExtendedAccess: Equatable {
    case read(RCCClockRegister), write(RCCClockRegister, UInt32)
    case readControl(RCCControlRegister), writeControl(RCCControlRegister, UInt32)
    case readExtended(RCCExtendedRegister), writeExtended(RCCExtendedRegister, UInt32)
    case readEXTI(EXTIRegister), writeEXTI(EXTIRegister, UInt32)
    case tick(UInt32), callback
}

final class RCCExtendedTraceIO: RCCExtendedRegisterIO, RCCSystemIO {
    var clocks: [RCCClockRegister: UInt32] = [:]
    var controls: [RCCControlRegister: UInt32] = [:]
    var extended: [RCCExtendedRegister: UInt32] = [:]
    var exti: [EXTIRegister: UInt32] = [:]
    var clockReads: [RCCClockRegister: [UInt32]] = [:]
    var controlReads: [RCCControlRegister: [UInt32]] = [:]
    var trace: [RCCExtendedAccess] = []
    var tick: UInt32 = 0
    var tickStep: UInt32 = 1
    var rejectBackupAccess = false
    var resetBackupDomain = false

    func read(_ register: RCCClockRegister) -> UInt32 {
        trace.append(.read(register))
        if clockReads[register]?.isEmpty == false { return clockReads[register]!.removeFirst() }
        return clocks[register, default: 0]
    }
    func write(_ register: RCCClockRegister, value: UInt32) {
        trace.append(.write(register, value)); clocks[register] = value
    }
    func read(_ register: RCCControlRegister) -> UInt32 {
        trace.append(.readControl(register))
        if controlReads[register]?.isEmpty == false { return controlReads[register]!.removeFirst() }
        return controls[register, default: 0]
    }
    func write(_ register: RCCControlRegister, value: UInt32) {
        trace.append(.writeControl(register, value))
        if register == .powerControl1 && rejectBackupAccess { return }
        if register == .bdcr && resetBackupDomain && value & 0x10000 != 0 {
            controls[.bdcr] = 0x10000
        } else {
            controls[register] = value
        }
        if register == .cicr { controls[.cifr, default: 0] &= ~value }
    }
    func read(_ register: RCCExtendedRegister) -> UInt32 {
        trace.append(.readExtended(register)); return extended[register, default: 0]
    }
    func write(_ register: RCCExtendedRegister, value: UInt32) {
        trace.append(.writeExtended(register, value)); extended[register] = value
    }
    func read(_ register: EXTIRegister) -> UInt32 {
        trace.append(.readEXTI(register)); return exti[register, default: 0]
    }
    func write(_ register: EXTIRegister, value: UInt32) {
        trace.append(.writeEXTI(register, value)); exti[register] = value
    }
    func read(_ register: FlashTimingRegister) -> UInt32 { XCTFail("RCCEx must not read FLASH"); return 0 }
    func write(_ register: FlashTimingRegister, value: UInt32) { XCTFail("RCCEx must not write FLASH") }
    func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration) { XCTFail("RCCEx must not touch MCO GPIO") }
    func getTick() -> UInt32 { let value = tick; trace.append(.tick(value)); tick &+= tickStep; return value }
    func getTickPriority() -> UInt32 { XCTFail("RCCEx must not reconfigure tick"); return 0 }
    func getSystemCoreClock() -> UInt32 { XCTFail("RCCEx must not use cached SystemCoreClock"); return 0 }
    func setSystemCoreClock(_ frequency: UInt32) { XCTFail("RCCEx must not change SystemCoreClock") }
    func initializeTick(priority: UInt32, coreClockHz: UInt32) -> HALStatus { XCTFail("RCCEx must not reinitialize tick"); return .error }
    var writes: [RCCExtendedAccess] {
        trace.filter { switch $0 { case .write, .writeControl, .writeExtended, .writeEXTI: return true; default: return false } }
    }
}

struct RCCExtendedMuxFixture {
    let selection: RCCPeripheralClockSelection
    let field: WritableKeyPath<RCCPeripheralClockConfiguration, UInt32>
    let register: RCCExtendedRegister
    let mask: UInt32
    // Each tuple is an encoded source and the PLLCFGR output bit that C enables.
    let sources: [(UInt32, UInt32)]
}

// Independent explicit fixtures for all thirty selectors that write CCIPRx.
// RTC, TIM and LTDC have dedicated tests because their behavior is different.
var rccExtendedMuxFixtures: [RCCExtendedMuxFixture] { [
    .init(selection: .fmc, field: \.fmcClockSelection, register: .ccipr1, mask: 3, sources: [(0, 0), (1, 0x40), (2, 0x40000), (3, 0)]),
    .init(selection: .xspi1, field: \.xspi1ClockSelection, register: .ccipr1, mask: 0x30, sources: [(0, 0), (0x10, 0x80000), (0x20, 0x100000)]),
    .init(selection: .xspi2, field: \.xspi2ClockSelection, register: .ccipr1, mask: 0xC0, sources: [(0, 0), (0x40, 0x80000), (0x80, 0x100000)]),
    .init(selection: .ckper, field: \.ckperClockSelection, register: .ccipr1, mask: 0x3000_0000, sources: [(0, 0), (0x1000_0000, 0), (0x2000_0000, 0)]),
    .init(selection: .sdmmc12, field: \.sdmmc12ClockSelection, register: .ccipr1, mask: 4, sources: [(0, 0x80000), (4, 0x100000)]),
    .init(selection: .adc, field: \.adcClockSelection, register: .ccipr1, mask: 0x3000000, sources: [(0, 0x10000), (0x1000000, 0x2000_0000), (0x2000000, 0)]),
    .init(selection: .adf1, field: \.adf1ClockSelection, register: .ccipr1, mask: 0x700000, sources: [(0, 0), (0x100000, 0x10000), (0x200000, 0x0800_0000), (0x300000, 0), (0x400000, 0), (0x500000, 0)]),
    .init(selection: .cec, field: \.cecClockSelection, register: .ccipr2, mask: 0x3000_0000, sources: [(0, 0), (0x1000_0000, 0), (0x2000_0000, 0)]),
    .init(selection: .eth1Ref, field: \.eth1RefClockSelection, register: .ccipr1, mask: 0x30000, sources: [(0, 0), (0x10000, 0), (0x20000, 0)]),
    .init(selection: .eth1Phy, field: \.eth1PhyClockSelection, register: .ccipr1, mask: 0x40000, sources: [(0, 0), (0x40000, 0x4000_0000)]),
    .init(selection: .fdcan, field: \.fdcanClockSelection, register: .ccipr2, mask: 0xC00000, sources: [(0, 0), (0x400000, 0x40), (0x800000, 0x10000)]),
    .init(selection: .i2c1I3c1, field: \.i2c1I3c1ClockSelection, register: .ccipr2, mask: 0x3000, sources: [(0, 0), (0x1000, 0x2000_0000), (0x2000, 0), (0x3000, 0)]),
    .init(selection: .i2c23, field: \.i2c23ClockSelection, register: .ccipr2, mask: 0x300, sources: [(0, 0), (0x100, 0x2000_0000), (0x200, 0), (0x300, 0)]),
    .init(selection: .lptim1, field: \.lptim1ClockSelection, register: .ccipr2, mask: 0x70000, sources: [(0, 0), (0x10000, 0x10000), (0x20000, 0x2000_0000), (0x30000, 0), (0x40000, 0), (0x50000, 0)]),
    .init(selection: .lptim23, field: \.lptim23ClockSelection, register: .ccipr4, mask: 0x700, sources: [(0, 0), (0x100, 0x10000), (0x200, 0x2000_0000), (0x300, 0), (0x400, 0), (0x500, 0)]),
    .init(selection: .lptim45, field: \.lptim45ClockSelection, register: .ccipr4, mask: 0x7000, sources: [(0, 0), (0x1000, 0x10000), (0x2000, 0x2000_0000), (0x3000, 0), (0x4000, 0), (0x5000, 0)]),
    .init(selection: .lpuart1, field: \.lpuart1ClockSelection, register: .ccipr4, mask: 7, sources: [(0, 0), (1, 0x20000), (2, 0x1000_0000), (3, 0), (4, 0), (5, 0)]),
    .init(selection: .pssi, field: \.pssiClockSelection, register: .ccipr1, mask: 0x0800_0000, sources: [(0, 0x2000_0000), (0x0800_0000, 0)]),
    .init(selection: .sai1, field: \.sai1ClockSelection, register: .ccipr3, mask: 0x70000, sources: [(0, 0x40), (0x10000, 0x10000), (0x20000, 0x0800_0000), (0x30000, 0), (0x40000, 0)]),
    .init(selection: .sai2, field: \.sai2ClockSelection, register: .ccipr3, mask: 0x700000, sources: [(0, 0x40), (0x100000, 0x10000), (0x200000, 0x0800_0000), (0x300000, 0), (0x400000, 0), (0x500000, 0)]),
    .init(selection: .spdifrx, field: \.spdifrxClockSelection, register: .ccipr2, mask: 0x3000000, sources: [(0, 0x40), (0x1000000, 0x40000), (0x2000000, 0x2000_0000), (0x3000000, 0)]),
    .init(selection: .spi1, field: \.spi1ClockSelection, register: .ccipr3, mask: 0x700, sources: [(0, 0x40), (0x100, 0x10000), (0x200, 0x0800_0000), (0x300, 0), (0x400, 0)]),
    .init(selection: .spi23, field: \.spi23ClockSelection, register: .ccipr2, mask: 0x70, sources: [(0, 0x40), (0x10, 0x10000), (0x20, 0x0800_0000), (0x30, 0), (0x40, 0)]),
    .init(selection: .spi45, field: \.spi45ClockSelection, register: .ccipr3, mask: 0x70, sources: [(0, 0), (0x10, 0x20000), (0x20, 0x1000_0000), (0x30, 0), (0x40, 0), (0x50, 0)]),
    .init(selection: .spi6, field: \.spi6ClockSelection, register: .ccipr4, mask: 0x70, sources: [(0, 0), (0x10, 0x20000), (0x20, 0x1000_0000), (0x30, 0), (0x40, 0), (0x50, 0)]),
    .init(selection: .usart1, field: \.usart1ClockSelection, register: .ccipr3, mask: 7, sources: [(0, 0), (1, 0x20000), (2, 0x1000_0000), (3, 0), (4, 0), (5, 0)]),
    .init(selection: .usart234578, field: \.usart234578ClockSelection, register: .ccipr2, mask: 7, sources: [(0, 0), (1, 0x20000), (2, 0x1000_0000), (3, 0), (4, 0), (5, 0)]),
    .init(selection: .usbPhyc, field: \.usbPhycClockSelection, register: .ccipr1, mask: 0x3000, sources: [(0, 0), (0x1000, 0), (0x2000, 0x1000_0000)]),
    .init(selection: .usbOtgFs, field: \.usbOtgFsClockSelection, register: .ccipr1, mask: 0xC000, sources: [(0, 0), (0x4000, 0x1000_0000), (0x8000, 0), (0xC000, 0)]),
    .init(selection: .usbRef, field: \.usbRefClockSelection, register: .ccipr1, mask: 0xF00, sources: [(0x300, 0), (0x800, 0), (0x900, 0), (0xA00, 0), (0xE00, 0), (0xB00, 0)]),
]
}

final class RCCExtendedTests: XCTestCase {
    func testAllMuxSourcesEnableOnlyRequestedPLLOutputBeforeMaskedWrite() {
        XCTAssertEqual(rccExtendedMuxFixtures.count, 30)
        for fixture in rccExtendedMuxFixtures {
            for (source, output) in fixture.sources {
                let io = RCCExtendedTraceIO()
                io.extended[fixture.register] = 0xA5A5_5A5A
                io.clocks[.pllcfgr] = 0x8000_0000
                var rcc = RCC(registers: io, system: io)
                var config = RCCPeripheralClockConfiguration(selection: fixture.selection)
                config[keyPath: fixture.field] = source
                XCTAssertEqual(rcc.configurePeripheralClocks(config), .ok)
                var expected: [RCCExtendedAccess] = []
                if output != 0 { expected += [.read(.pllcfgr), .write(.pllcfgr, 0x8000_0000 | output)] }
                expected += [.readExtended(fixture.register), .writeExtended(fixture.register, (0xA5A5_5A5A & ~fixture.mask) | source)]
                XCTAssertEqual(io.trace, expected, "selection=\(fixture.selection.rawValue), source=\(source)")
                XCTAssertEqual(rcc.getPeripheralClockConfiguration()[keyPath: fixture.field], source)
            }
        }
    }

    func testRTCFailureKeepsErrorStickyButContinuesPLLEnablesAndUnconditionalSelectors() {
        let io = RCCExtendedTraceIO()
        io.controls[.bdcr] = 0x100
        io.rejectBackupAccess = true
        var rcc = RCC(registers: io, system: io)
        let config = RCCPeripheralClockConfiguration(
            selection: [.rtc, .fmc, .ckper, .adc, .cec, .eth1Ref, .ltdc, .tim, .usbRef],
            fmcClockSelection: 1, ckperClockSelection: 0x1000_0000, cecClockSelection: 0x1000_0000,
            eth1RefClockSelection: 0x10000, usbRefClockSelection: 0xA00, rtcClockSelection: 0x200, timPresSelection: 0x8000)
        XCTAssertEqual(rcc.configurePeripheralClocks(config), .error)
        XCTAssertEqual(io.writes, [
            .writeControl(.powerControl1, 0x100), .write(.pllcfgr, 0x40),
            .writeExtended(.ccipr1, 0x1000_0000), .write(.pllcfgr, 0x10040),
            .writeExtended(.ccipr2, 0x1000_0000), .writeExtended(.ccipr1, 0x1001_0000),
            .write(.pllcfgr, 0x2001_0040), .write(.cfgr, 0x8000), .writeExtended(.ccipr1, 0x1001_0A00),
        ])
        XCTAssertEqual(io.controls[.bdcr], 0x100)
    }

    func testRTCBackupResetRestoreAndHSEPrescalerOrder() {
        let io = RCCExtendedTraceIO()
        io.controls[.bdcr] = 0x8503
        io.controls[.powerControl1] = 0x20
        io.clocks[.cfgr] = 0xA5A5_FFFF
        io.resetBackupDomain = true
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.configurePeripheralClocks(.init(selection: .rtc, rtcClockSelection: 0x18300)), .ok)
        XCTAssertEqual(io.trace, [
            .readControl(.bdcr), .readControl(.powerControl1), .writeControl(.powerControl1, 0x120), .readControl(.powerControl1),
            .readControl(.bdcr), .readControl(.bdcr), .writeControl(.bdcr, 0x18503),
            .readControl(.bdcr), .writeControl(.bdcr, 0), .writeControl(.bdcr, 0x8403),
            .read(.cfgr), .write(.cfgr, 0xA5A5_D8FF),
            .readControl(.bdcr), .writeControl(.bdcr, 0x8703), .readControl(.bdcr), .writeControl(.bdcr, 0x8703),
        ])
    }

    func testChangingOnlyRTCHSEPrescalerDoesNotResetBackupDomain() {
        let io = RCCExtendedTraceIO()
        io.controls[.bdcr] = 0x8300
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.configurePeripheralClocks(.init(selection: .rtc, rtcClockSelection: 0x3F300)), .ok)
        XCTAssertEqual(io.writes, [.write(.cfgr, 0x3F00), .writeControl(.bdcr, 0x8300), .writeControl(.bdcr, 0x8300)])
        XCTAssertFalse(io.trace.contains(.readControl(.powerControl1)))
    }

    func testRTCDisabledSelectionStillEnablesRTCAsInUpstreamMacroSequence() {
        let io = RCCExtendedTraceIO()
        io.clocks[.cfgr] = 0xFFFF_FFFF
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.configurePeripheralClocks(.init(selection: .rtc, rtcClockSelection: 0)), .ok)
        XCTAssertEqual(io.writes, [.write(.cfgr, 0xFFFF_C0FF), .writeControl(.bdcr, 0), .writeControl(.bdcr, 0x8000)])
    }

    func testLSETimeoutWrapAndStrictDeadlineAreCollapsedToError() {
        for start in [UInt32(0), UInt32.max - 2] {
            let io = RCCExtendedTraceIO()
            io.tick = start
            var rcc = RCC(registers: io, system: io, timeouts: .init(lseStartup: 3))
            let config = RCCPeripheralClockConfiguration(selection: [.rtc, .fmc], fmcClockSelection: 1, rtcClockSelection: 0x100)
            XCTAssertEqual(rcc.configurePeripheralClocks(config), .error)
            XCTAssertEqual(io.trace.filter { if case .tick = $0 { return true }; return false },
                           (0...4).map { .tick(start &+ UInt32($0)) })
            XCTAssertEqual(io.trace.filter { $0 == .readControl(.bdcr) }.count, 5)
            XCTAssertEqual(io.writes, [.write(.pllcfgr, 0x40)])
        }
    }

    func testLSEReadinessOnNextIterationAvoidsTimeoutWithoutExtraRecheck() {
        let io = RCCExtendedTraceIO()
        io.controlReads[.bdcr] = [0, 0, 2, 2, 0x102]
        var rcc = RCC(registers: io, system: io, timeouts: .init(lseStartup: 1))
        XCTAssertEqual(rcc.configurePeripheralClocks(.init(selection: .rtc, rtcClockSelection: 0x100)), .ok)
        XCTAssertEqual(io.writes, [.write(.cfgr, 0), .writeControl(.bdcr, 0x102), .writeControl(.bdcr, 0x8102)])
    }

    func testInvalidLPTIM23SelectionHasRuntimeErrorAndSuppressesLaterMuxOnly() {
        let io = RCCExtendedTraceIO()
        var rcc = RCC(registers: io, system: io)
        let config = RCCPeripheralClockConfiguration(selection: [.lptim23, .lptim45, .tim],
            lptim23ClockSelection: 0x600, lptim45ClockSelection: 0x1000, timPresSelection: 0x8000)
        XCTAssertEqual(rcc.configurePeripheralClocks(config), .error)
        XCTAssertEqual(io.writes, [.write(.pllcfgr, 0x10000), .write(.cfgr, 0x8000)])
    }

    func testLTDCIgnoresUnusedSourceFieldAndSelectionValidationAllowsUnknownBits() {
        let io = RCCExtendedTraceIO()
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.configurePeripheralClocks(.init(
            selection: [.ltdc, .init(rawValue: 1 << 63)], ltdcClockSelection: 0xFFFF_FFFF)), .ok)
        XCTAssertEqual(io.trace, [.read(.pllcfgr), .write(.pllcfgr, 0x2000_0000)])
    }

    func testReadbackContainsAllThirtyThreeBitsAndPreservesRawReservedSelectors() {
        let io = RCCExtendedTraceIO()
        for register in [RCCExtendedRegister.ccipr1, .ccipr2, .ccipr3, .ccipr4] { io.extended[register] = 0xFFFF_FFFF }
        io.controls[.bdcr] = 0x300
        io.clocks[.cfgr] = 0xBF00
        var rcc = RCC(registers: io, system: io)
        let config = rcc.getPeripheralClockConfiguration()
        XCTAssertEqual(config.selection.rawValue, 0x1_FFFF_FFFF)
        for fixture in rccExtendedMuxFixtures { XCTAssertEqual(config[keyPath: fixture.field], fixture.mask) }
        XCTAssertEqual(config.rtcClockSelection, 0x3F300)
        XCTAssertEqual(config.timPresSelection, 0x8000)
        XCTAssertEqual(config.ltdcClockSelection, 0)
        XCTAssertTrue(io.writes.isEmpty)
        XCTAssertEqual(io.trace.filter { $0 == .readExtended(.ckprotr) }.count, 3)
    }

    func testClockProtectionAndStopSourcesPreserveUnrelatedBits() {
        let io = RCCExtendedTraceIO()
        io.extended[.ckprotr] = 0x7000
        io.clocks[.cfgr] = 0x1234_5600
        var rcc = RCC(registers: io, system: io)
        rcc.enableClockProtection(3)
        rcc.disableClockProtection(1)
        rcc.configureWakeUpStopClock(0x40)
        rcc.configureKernelWakeUpStopClock(0x80)
        rcc.configureWakeUpStopClock(0)
        XCTAssertEqual(io.writes, [.writeExtended(.ckprotr, 0x7003), .writeExtended(.ckprotr, 0x7002),
            .write(.cfgr, 0x1234_5640), .write(.cfgr, 0x1234_56C0), .write(.cfgr, 0x1234_5680)])
        // The C assertion accepts extra bits when either valid protection bit is present.
        rcc.enableClockProtection(0x8000_0001)
        XCTAssertEqual(io.extended[.ckprotr], 0x8000_7003)
    }

    func testLSECSSInterruptUsesLineEighteenAndDoesNotClearEXTIPending() {
        let io = RCCExtendedTraceIO()
        io.controls[.bdcr] = 3
        io.controls[.cier] = 0x10
        io.exti[.risingTrigger(bank: 0)] = 0x80
        io.exti[.interruptMask(bank: 0)] = 0x40
        var rcc = RCC(registers: io, system: io)
        rcc.enableLSECSSInterrupt()
        XCTAssertEqual(io.writes, [.writeControl(.bdcr, 0x23), .writeControl(.cier, 0x210),
            .writeEXTI(.risingTrigger(bank: 0), 0x40080), .writeEXTI(.interruptMask(bank: 0), 0x40040)])
        io.trace = []
        rcc.handleLSECSSInterrupt { XCTFail("No pending flag") }
        XCTAssertEqual(io.trace, [.readControl(.cifr)])
        io.controls[.cifr] = 0x210
        io.trace = []
        rcc.handleLSECSSInterrupt { io.trace.append(.callback) }
        XCTAssertEqual(io.trace, [.readControl(.cifr), .writeControl(.cicr, 0x200), .callback])
        io.trace = []
        rcc.disableLSECSS()
        XCTAssertEqual(io.writes, [.writeControl(.bdcr, 3), .writeControl(.cier, 0x10)])
        XCTAssertEqual(io.exti[.interruptMask(bank: 0)], 0x40040)
    }
}
