import XCTest
@testable import STM32H7RSHAL

func configureRCCExtendedFrequencyFixture(_ io: RCCExtendedTraceIO) {
    io.clocks = [
        .cr: 0x2A02_2124, .cfgr: 0, .cdcfgr: 0, .bmcfgr: 8, .apbcfgr: 0x645,
        .pllckselr: 0x0040_4042, .pllcfgr: 0xFFFF_FFFF,
        .pll1divr1: 0x0302_0263, .pll1divr2: 0, .pll1fracr: 0,
        .pll2divr1: 0x0705_064F, .pll2divr2: 0x402, .pll2fracr: 0,
        .pll3divr1: 0x140C_0C5A, .pll3divr2: 5, .pll3fracr: 0,
    ]
    io.controls = [.bdcr: 2, .csr: 2]
}

private struct RCCExtendedValueIO: RCCExtendedRegisterIO {
    let underlying: RCCExtendedTraceIO
    var reads = 0
    mutating func read(_ register: RCCClockRegister) -> UInt32 { reads += 1; return underlying.read(register) }
    mutating func write(_ register: RCCClockRegister, value: UInt32) { underlying.write(register, value: value) }
    mutating func read(_ register: RCCControlRegister) -> UInt32 { reads += 1; return underlying.read(register) }
    mutating func write(_ register: RCCControlRegister, value: UInt32) { underlying.write(register, value: value) }
    mutating func read(_ register: RCCExtendedRegister) -> UInt32 { reads += 1; return underlying.read(register) }
    mutating func write(_ register: RCCExtendedRegister, value: UInt32) { underlying.write(register, value: value) }
    mutating func read(_ register: EXTIRegister) -> UInt32 { reads += 1; return underlying.read(register) }
    mutating func write(_ register: EXTIRegister, value: UInt32) { underlying.write(register, value: value) }
    func read(_ register: FlashTimingRegister) -> UInt32 { underlying.read(register) }
    func write(_ register: FlashTimingRegister, value: UInt32) { underlying.write(register, value: value) }
    mutating func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration) {
        underlying.initializeMCOGPIO(port: port, configuration: configuration)
    }
}

final class RCCPeripheralClockFrequencyTests: XCTestCase {
    func testAllSupportedMuxSourcesWithKnownDistinctPLLAndBusFrequencies() {
        let expected: [UInt64: [UInt32]] = [
            0x1: [32_000_000, 200_000_000, 60_000_000, 64_000_000],
            0x2: [32_000_000, 160_000_000, 96_000_000],
            0x4: [32_000_000, 160_000_000, 96_000_000],
            0x8: [64_000_000, 4_000_000, 24_000_000],
            0x10: [120_000_000, 26_000_000, 64_000_000],
            0x20: [32_000_000, 120_000_000, 78_000_000, 48_000, 4_000_000, 64_000_000],
            0x40: [32_768, 32_000, 4_000_000],
            0x80: [0, 24_000_000, 24_000_000],
            0x100: [24_000_000, 91_000_000],
            0x200: [24_000_000, 200_000_000, 120_000_000],
            0x400: [8_000_000, 26_000_000, 64_000_000, 4_000_000],
            0x800: [8_000_000, 26_000_000, 64_000_000, 4_000_000],
            0x1000: [8_000_000, 120_000_000, 26_000_000, 32_768, 32_000, 64_000_000],
            0x2000: [4_000_000, 120_000_000, 26_000_000, 32_768, 32_000, 64_000_000],
            0x4000: [4_000_000, 120_000_000, 26_000_000, 32_768, 32_000, 64_000_000],
            0x8000: [4_000_000, 80_000_000, 42_000_000, 64_000_000, 4_000_000, 32_768],
            0x20000: [26_000_000, 64_000_000],
            0x80000: [200_000_000, 120_000_000, 78_000_000, 48_000, 64_000_000],
            0x100000: [200_000_000, 120_000_000, 78_000_000, 48_000, 64_000_000, 0],
            0x200000: [160_000_000, 96_000_000],
            0x400000: [200_000_000, 60_000_000, 26_000_000, 64_000_000],
            0x800000: [200_000_000, 120_000_000, 78_000_000, 48_000, 64_000_000],
            0x1000000: [200_000_000, 120_000_000, 78_000_000, 48_000, 64_000_000],
            0x2000000: [16_000_000, 80_000_000, 42_000_000, 64_000_000, 4_000_000, 24_000_000],
            0x4000000: [4_000_000, 80_000_000, 42_000_000, 64_000_000, 4_000_000, 24_000_000],
            0x1000_0000: [16_000_000, 80_000_000, 42_000_000, 64_000_000, 4_000_000, 32_768],
            0x2000_0000: [8_000_000, 80_000_000, 42_000_000, 64_000_000, 4_000_000, 32_768],
            0x4000_0000: [24_000_000, 12_000_000, 42_000_000],
            0x8000_0000: [48_000_000, 42_000_000, 24_000_000, 0],
        ]
        for fixture in rccExtendedMuxFixtures where fixture.selection != .usbRef {
            for (index, source) in fixture.sources.enumerated() {
                let io = RCCExtendedTraceIO()
                configureRCCExtendedFrequencyFixture(io)
                io.extended[fixture.register] = source.0
                var rcc = RCC(registers: io, system: io)
                XCTAssertEqual(rcc.getPeripheralClockFrequency(UInt32(fixture.selection.rawValue)),
                    expected[fixture.selection.rawValue]![index], "selection=\(fixture.selection.rawValue) source=\(source.0)")
                XCTAssertTrue(io.writes.isEmpty)
            }
        }
    }

    func testPLLOutputGatePrecedesAllFrequencyReads() {
        for fixture in rccExtendedMuxFixtures where fixture.selection != .usbRef {
            for (source, output) in fixture.sources where output != 0 {
                let io = RCCExtendedTraceIO()
                configureRCCExtendedFrequencyFixture(io)
                io.extended[fixture.register] = source
                io.clocks[.pllcfgr] = 0xFFFF_FFFF & ~output
                var rcc = RCC(registers: io, system: io)
                XCTAssertEqual(rcc.getPeripheralClockFrequency(UInt32(fixture.selection.rawValue)), 0)
                var expected: [RCCExtendedAccess] = []
                if [.fmc, .xspi1, .xspi2].contains(fixture.selection) { expected.append(.readExtended(.ckprotr)) }
                expected += [.readExtended(fixture.register), .read(.pllcfgr)]
                XCTAssertEqual(io.trace, expected)
            }
        }
        let io = RCCExtendedTraceIO()
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x10000), 0)
        XCTAssertEqual(io.trace, [.read(.pllcfgr)])
        configureRCCExtendedFrequencyFixture(io)
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x10000), 26_000_000)
    }

    func testHSIAndCLKPUseFreshReadinessDividerFlagAndDividerReads() {
        let io = RCCExtendedTraceIO()
        io.extended[.ccipr1] = 3
        io.clockReads[.cr] = [4, 0x20, 0x18]
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.getPeripheralClockFrequency(1), 8_000_000)
        XCTAssertEqual(io.trace, [.readExtended(.ckprotr), .readExtended(.ccipr1), .read(.cr), .read(.cr), .read(.cr)])
        io.trace = []
        io.extended[.ccipr1] = 0x0200_0000 // ADC uses CKPER, which uses HSI.
        io.clockReads[.cr] = [4, 0x20, 0x10]
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x10), 16_000_000)
        XCTAssertEqual(io.trace, [.readExtended(.ccipr1), .readExtended(.ccipr1), .read(.cr), .read(.cr), .read(.cr)])
        for (bits, expectedReads) in [(UInt32(0), 1), (UInt32(4), 2)] {
            io.trace = []; io.clocks[.cr] = bits
            XCTAssertEqual(rcc.getPeripheralClockFrequency(0x10), 0)
            XCTAssertEqual(io.trace.filter { $0 == .read(.cr) }.count, expectedReads)
        }
        io.trace = []; io.extended[.ccipr1] = 0x3200_0000 // Reserved CKPER selection.
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x10), 0)
        XCTAssertEqual(io.trace, [.readExtended(.ccipr1), .readExtended(.ccipr1)])
    }

    func testProtectionFallbackAvoidsMuxReadsAndUsesHCLKDividedByFour() {
        for (peripheral, protection): (UInt32, UInt32) in [(1, 0x5000), (2, 0x40), (4, 0x400)] {
            let io = RCCExtendedTraceIO()
            configureRCCExtendedFrequencyFixture(io)
            io.extended[.ckprotr] = protection
            io.extended[.ccipr1] = 0xFFFF_FFFF
            var rcc = RCC(registers: io, system: io)
            XCTAssertEqual(rcc.getPeripheralClockFrequency(peripheral), 8_000_000)
            XCTAssertFalse(io.trace.contains(.readExtended(.ccipr1)))
            XCTAssertEqual(io.trace.first, .readExtended(.ckprotr))
        }
    }

    func testRTCReadbackRechecksSourceAndRejectsHSEPrescalersZeroAndOne() {
        for divider in UInt32(0)...63 {
            let io = RCCExtendedTraceIO()
            configureRCCExtendedFrequencyFixture(io)
            io.controls[.bdcr] = 0x300
            io.clocks[.cfgr] = divider << 8
            var rcc = RCC(registers: io, system: io)
            XCTAssertEqual(rcc.getPeripheralClockFrequency(0x40000), divider > 1 ? 24_000_000 / divider : 0)
            XCTAssertEqual(io.trace, [.readControl(.bdcr), .read(.cfgr), .readControl(.bdcr), .read(.cr), .read(.cfgr)])
        }
        for (source, frequency): (UInt32, UInt32) in [(0, 0), (0x100, 32_768), (0x200, 32_000)] {
            let io = RCCExtendedTraceIO()
            configureRCCExtendedFrequencyFixture(io)
            io.controls[.bdcr] = source | 2
            var rcc = RCC(registers: io, system: io)
            XCTAssertEqual(rcc.getPeripheralClockFrequency(0x40000), frequency)
        }
    }

    func testEthernetNestedClockSelectionAndUnspecifiedExternalFrequencies() {
        let io = RCCExtendedTraceIO()
        configureRCCExtendedFrequencyFixture(io)
        io.extended[.ccipr1] = 0x60000 // ETHREF <- ETHPHY <- PLL3S.
        var rcc = RCC(registers: io, system: io)
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x80), 91_000_000)
        XCTAssertEqual(Array(io.trace.prefix(3)), [.readExtended(.ccipr1), .readExtended(.ccipr1), .read(.pllcfgr)])
        for (selection, register, source): (UInt32, RCCExtendedRegister, UInt32) in [
            (0x80, .ccipr1, 0), (0x100000, .ccipr3, 0x500000), (0x8000_0000, .ccipr1, 0xC000),
        ] {
            io.trace = []; io.extended[register] = source
            XCTAssertEqual(rcc.getPeripheralClockFrequency(selection), 0)
            XCTAssertEqual(io.trace, [.readExtended(register)])
        }
        for selection: UInt32 in [0, 3, 0x0800_0000, 0xFFFF_FFFF] {
            io.trace = []
            XCTAssertEqual(rcc.getPeripheralClockFrequency(selection), 0)
            XCTAssertTrue(io.trace.isEmpty)
        }
    }

    func testFrequencyBridgePropagatesValueTypeReadSideEffects() {
        let underlying = RCCExtendedTraceIO()
        configureRCCExtendedFrequencyFixture(underlying)
        var rcc = RCC(registers: RCCExtendedValueIO(underlying: underlying), system: underlying)
        XCTAssertEqual(rcc.getPeripheralClockFrequency(1), 32_000_000)
        XCTAssertEqual(rcc.registers.reads, 7)
        XCTAssertEqual(underlying.trace.count, 7)
    }

    func testExtendedOscillatorDefaultsAndInjectedValuesAreUsedWithoutNewAlgorithms() {
        let defaults = RCCOscillatorValues(hse: 25_000_000)
        XCTAssertEqual(defaults.hsi48, 48_000_000)
        XCTAssertEqual(defaults.lse, 32_768)
        XCTAssertEqual(defaults.lsi, 32_000)
        XCTAssertEqual(defaults.external, 48_000)
        let io = RCCExtendedTraceIO()
        configureRCCExtendedFrequencyFixture(io)
        var rcc = RCC(registers: io, system: io, oscillators: .init(lse: 1, lsi: 2, hsi48: 3, external: 4))
        io.extended[.ccipr2] = 0
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x40), 1)
        io.extended[.ccipr2] = 0x1000_0000
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x40), 2)
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x8000_0000), 3)
        io.extended[.ccipr3] = 0x300
        XCTAssertEqual(rcc.getPeripheralClockFrequency(0x800000), 4)
    }
}
