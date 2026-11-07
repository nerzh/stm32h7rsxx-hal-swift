import CRCCReference
import XCTest
@testable import STM32H7RSHAL

private struct RCCClockTestRegisters: RCCClockRegisterIO {
    var values: [RCCClockRegister: UInt32] = [:]
    var scriptedReads: [RCCClockRegister: [UInt32]] = [:]
    var reads: [RCCClockRegister] = []

    mutating func read(_ register: RCCClockRegister) -> UInt32 {
        reads.append(register)
        if var pending = scriptedReads[register], !pending.isEmpty {
            let value = pending.removeFirst()
            scriptedReads[register] = pending
            return value
        }
        return values[register, default: 0]
    }
}

final class RCCClockTests: XCTestCase {
    private let registerPairs: [(RCCClockRegister, CRCCReferenceRegister)] = [
        (.cr, CRCCReference_CR), (.cfgr, CRCCReference_CFGR),
        (.cdcfgr, CRCCReference_CDCFGR), (.bmcfgr, CRCCReference_BMCFGR),
        (.apbcfgr, CRCCReference_APBCFGR), (.pllckselr, CRCCReference_PLLCKSELR),
        (.pllcfgr, CRCCReference_PLLCFGR),
        (.pll1divr1, CRCCReference_PLL1DIVR1), (.pll1fracr, CRCCReference_PLL1FRACR),
        (.pll2divr1, CRCCReference_PLL2DIVR1), (.pll2fracr, CRCCReference_PLL2FRACR),
        (.pll3divr1, CRCCReference_PLL3DIVR1), (.pll3fracr, CRCCReference_PLL3FRACR),
        (.pll1divr2, CRCCReference_PLL1DIVR2), (.pll2divr2, CRCCReference_PLL2DIVR2),
        (.pll3divr2, CRCCReference_PLL3DIVR2),
    ]

    private let clocks: [CRCCReferenceClock] = [
        CRCCReference_SysClock, CRCCReference_HCLK,
        CRCCReference_PCLK1, CRCCReference_PCLK2, CRCCReference_PCLK4, CRCCReference_PCLK5,
        CRCCReference_PLL1P, CRCCReference_PLL1Q, CRCCReference_PLL1R, CRCCReference_PLL1S,
        CRCCReference_PLL2P, CRCCReference_PLL2Q, CRCCReference_PLL2R, CRCCReference_PLL2S,
        CRCCReference_PLL2T,
        CRCCReference_PLL3P, CRCCReference_PLL3Q, CRCCReference_PLL3R, CRCCReference_PLL3S,
    ]

    private func frequency(_ clock: CRCCReferenceClock, _ rcc: inout RCCClock<RCCClockTestRegisters>) -> UInt32 {
        switch clock {
        case CRCCReference_SysClock: return rcc.getSysClockFreq()
        case CRCCReference_HCLK: return rcc.getHCLKFreq()
        case CRCCReference_PCLK1: return rcc.getPCLK1Freq()
        case CRCCReference_PCLK2: return rcc.getPCLK2Freq()
        case CRCCReference_PCLK4: return rcc.getPCLK4Freq()
        case CRCCReference_PCLK5: return rcc.getPCLK5Freq()
        case CRCCReference_PLL1P: return rcc.getPLL1PFreq()
        case CRCCReference_PLL1Q: return rcc.getPLL1QFreq()
        case CRCCReference_PLL1R: return rcc.getPLL1RFreq()
        case CRCCReference_PLL1S: return rcc.getPLL1SFreq()
        case CRCCReference_PLL2P: return rcc.getPLL2PFreq()
        case CRCCReference_PLL2Q: return rcc.getPLL2QFreq()
        case CRCCReference_PLL2R: return rcc.getPLL2RFreq()
        case CRCCReference_PLL2S: return rcc.getPLL2SFreq()
        case CRCCReference_PLL2T: return rcc.getPLL2TFreq()
        case CRCCReference_PLL3P: return rcc.getPLL3PFreq()
        case CRCCReference_PLL3Q: return rcc.getPLL3QFreq()
        case CRCCReference_PLL3R: return rcc.getPLL3RFreq()
        case CRCCReference_PLL3S: return rcc.getPLL3SFreq()
        default: preconditionFailure("Invalid reference clock")
        }
    }

    private func assertMatchesC(_ values: [RCCClockRegister: UInt32],
                                oscillators: RCCOscillatorValues = RCCOscillatorValues(),
                                includePLL: Bool = true,
                                file: StaticString = #filePath, line: UInt = #line) {
        var reference = CRCCReferenceState()
        CRCCReference_Reset(&reference, oscillators.hsi, oscillators.csi, oscillators.hse)
        for (register, cRegister) in registerPairs {
            CRCCReference_Set(&reference, cRegister, values[register, default: 0])
        }
        var rcc = RCCClock(registers: RCCClockTestRegisters(values: values), oscillators: oscillators)
        for clock in includePLL ? clocks[...] : clocks.prefix(6) {
            let actual = frequency(clock, &rcc)
            let expected = CRCCReference_GetFrequency(&reference, clock)
            if actual != expected {
                XCTFail("clock \(clock.rawValue): Swift \(actual) != C \(expected); registers \(values)",
                        file: file, line: line)
                return
            }
        }
    }

    func testOscillatorDefaultsMatchHALConfigurationTemplate() {
        let values = RCCOscillatorValues()
        XCTAssertEqual(values.hsi, 64_000_000)
        XCTAssertEqual(values.csi, 4_000_000)
        XCTAssertEqual(values.hse, 24_000_000)
    }

    func testSystemClockSourcesHSIDividersAndCPREMatchC() {
        for source: UInt32 in 0..<8 {
            for cr: UInt32 in [0, 8, 16, 24, 32, 40, 48, 56] {
                for cpre: UInt32 in 0..<16 {
                    // Include reserved source encodings and unrelated register bits.
                    assertMatchesC([
                        .cfgr: 0xFFFF_FFC7 | (source << 3), .cr: 0xFFFF_FFC7 | cr,
                        .cdcfgr: 0xFFFF_FFF0 | cpre,
                        .pllckselr: 2 | (3 << 4), .pll1divr1: 74 | (1 << 9),
                    ], includePLL: false)
                }
            }
        }
    }

    func testAllBusPrescalerEncodingsMatchC() {
        for cpre: UInt32 in 0..<16 {
            for bmpre: UInt32 in 0..<16 {
                for ppre: UInt32 in 0..<8 {
                    let apb = ppre | (((ppre + 1) & 7) << 4) |
                        (((ppre + 3) & 7) << 8) | (((ppre + 5) & 7) << 12)
                    assertMatchesC([
                        .cfgr: 0x10, .cdcfgr: 0xFFFF_FFF0 | cpre,
                        .bmcfgr: 0xFFFF_FFF0 | bmpre, .apbcfgr: 0xFFFF_8888 | apb,
                    ], oscillators: RCCOscillatorValues(hse: 25_000_001), includePLL: false)
                }
            }
        }
    }

    func testPLLSourceFractionalAndDividerBoundariesMatchC() {
        let factors: [(UInt32, UInt32)] = [
            (0, 512), (1, 1), (1, 31), (2, 63), (3, 75),
            (7, 101), (8, 511), (16, 512), (63, 512),
        ]
        let fractions: [UInt32] = [0, 1, 4095, 4096, 8191]
        let fractionalEnables: [UInt32] = [0, 1, 1 << 11, 1 << 22, 0x0040_0801]
        for source: UInt32 in 0..<4 {
            for hsiControl: UInt32 in [0, 8, 16, 24, 32, 40, 48, 56] {
                for (m, n) in factors {
                    for fraction in fractions {
                        for enabled in fractionalEnables {
                            let m2 = m == 0 ? 0 : min(m + 3, 63)
                            let m3 = m == 0 ? 0 : min(m + 7, 63)
                            let p = (fraction + m) & 127
                            let q = (fraction + m + 17) & 127
                            let r = (fraction + m + 31) & 127
                            let values: [RCCClockRegister: UInt32] = [
                                .cfgr: 0x18, .cr: 0xFFFF_FFC7 | hsiControl,
                                .pllckselr: 0xFC0C_0C0C | source | (m << 4) | (m2 << 12) | (m3 << 20),
                                .pllcfgr: 0xFFBF_F7FE | enabled,
                                .pll1divr1: 0x8080_0000 | (n - 1) | (p << 9) | (q << 16) | (r << 24),
                                .pll2divr1: 0x8080_0000 | (min(n + 1, 512) - 1) | (q << 9) | (r << 16) | (p << 24),
                                .pll3divr1: 0x8080_0000 | (min(n + 2, 512) - 1) | (r << 9) | (p << 16) | (q << 24),
                                .pll1fracr: 0xFFFF_0007 | (fraction << 3),
                                .pll2fracr: 0xFFFF_0007 | ((8191 - fraction) << 3),
                                .pll3fracr: 0xFFFF_0007 | (((fraction + 71) & 8191) << 3),
                                .pll1divr2: 0xFFFF_FFF8 | (p & 7),
                                .pll2divr2: 0xFFFF_F8F8 | (q & 7) | ((r & 7) << 8),
                                .pll3divr2: 0xFFFF_FFF8 | (r & 7),
                            ]
                            assertMatchesC(values, oscillators: RCCOscillatorValues(hse: 25_000_001))
                        }
                    }
                }
            }
        }
    }

    func testFloatDivisionBeforeSYSCLKConversionDiffersFromPLLIntegerDivision() {
        let values: [RCCClockRegister: UInt32] = [
            .cfgr: 0x18, .pllckselr: 2 | (3 << 4), .pllcfgr: 1,
            .pll1divr1: 49 | (2 << 9), .pll1fracr: 4096 << 3,
        ]
        assertMatchesC(values)
        var rcc = RCCClock(registers: RCCClockTestRegisters(values: values))
        XCTAssertEqual(rcc.getSysClockFreq(), 134_666_672)
        XCTAssertEqual(rcc.getPLL1PFreq(), 134_666_666)
    }

    func testEveryPLLInputAndOutputDividerEncodingMatchesC() {
        for m: UInt32 in 0..<64 {
            for divider: UInt32 in 0..<128 {
                let q = (divider + 43) & 127
                let r = (divider + 91) & 127
                assertMatchesC([
                    .cfgr: 0x18, .cr: 0x20,
                    .pllckselr: (m << 4) | (((m + 11) & 63) << 12) | (((m + 23) & 63) << 20),
                    .pllcfgr: 0x0040_0801,
                    .pll1divr1: 29 | (divider << 9) | (q << 16) | (r << 24),
                    .pll2divr1: 33 | (r << 9) | (divider << 16) | (q << 24),
                    .pll3divr1: 44 | (q << 9) | (r << 16) | (divider << 24),
                    .pll1fracr: (m * 127) << 3,
                    .pll2fracr: 8191 << 3, .pll3fracr: 4095 << 3,
                    .pll1divr2: divider & 7,
                    .pll2divr2: (divider & 7) | (((divider + 3) & 7) << 8),
                    .pll3divr2: (divider + 5) & 7,
                ])
            }
        }
    }

    func testAbsentPLLSourcePreservesDifferentSYSCLKAndVCOFallbacks() {
        let values: [RCCClockRegister: UInt32] = [
            .cfgr: 0x18, .pllckselr: 3 | (1 << 4), .pll1divr1: 49 | (1 << 9),
        ]
        assertMatchesC(values)
        var rcc = RCCClock(registers: RCCClockTestRegisters(values: values))
        XCTAssertEqual(rcc.getSysClockFreq(), 100_000_000)
        XCTAssertEqual(rcc.getPLL1PFreq(), 0)
    }

    func testHSIUsesSeparateStatusAndDividerReads() {
        var rcc = RCCClock(registers: RCCClockTestRegisters(scriptedReads: [.cr: [0x20, 0x18]]))
        XCTAssertEqual(rcc.getSysClockFreq(), 8_000_000)
        XCTAssertEqual(rcc.registers.reads, [.cfgr, .cr, .cr, .cdcfgr])
        rcc.registers = RCCClockTestRegisters()
        XCTAssertEqual(rcc.getSysClockFreq(), 0)
        XCTAssertEqual(rcc.registers.reads, [.cfgr, .cr, .cdcfgr])
    }

    func testZeroPLLMReadSequenceMatchesUpstreamBranches() {
        var rcc = RCCClock(registers: RCCClockTestRegisters(values: [.cfgr: 0x18]))
        XCTAssertEqual(rcc.getSysClockFreq(), 0)
        XCTAssertEqual(rcc.registers.reads, [.cfgr, .pllckselr, .pllckselr, .pllcfgr, .pll1fracr, .cdcfgr])
        rcc.registers.reads = []
        XCTAssertEqual(rcc.getPLL1PFreq(), 0)
        XCTAssertEqual(rcc.registers.reads, [.pll1divr1, .pllckselr, .pll1divr1])
    }

    func testPLLDividerIsReadBeforeVCOAndDisabledFractionIsNotRead() {
        var rcc = RCCClock(registers: RCCClockTestRegisters(
            values: [.pllckselr: 3 << 4],
            scriptedReads: [.pll1divr1: [2 << 9, 49], .cr: [0x20, 0x08]]
        ))
        XCTAssertEqual(rcc.getPLL1PFreq(), 177_777_781)
        XCTAssertEqual(rcc.registers.reads, [.pll1divr1, .pllckselr, .pll1divr1, .pllcfgr, .cr, .cr])
    }

    func testSYSCLKUsesSeparatePLLSourceAndMReads() {
        var rcc = RCCClock(registers: RCCClockTestRegisters(
            values: [.cfgr: 0x18, .pll1divr1: 49 | (1 << 9)],
            scriptedReads: [.pllckselr: [2, 3 << 4]]
        ))
        XCTAssertEqual(rcc.getSysClockFreq(), 200_000_000)
        XCTAssertEqual(rcc.registers.reads, [
            .cfgr, .pllckselr, .pllckselr, .pllcfgr, .pll1fracr,
            .pll1divr1, .pll1divr1, .cdcfgr,
        ])
    }

    func testHCLKRecomputesFromCurrentRegisters() {
        var rcc = RCCClock(registers: RCCClockTestRegisters(values: [.cfgr: 8]))
        XCTAssertEqual(rcc.getHCLKFreq(), 4_000_000)
        rcc.registers.values[.cfgr] = 0x10
        rcc.registers.values[.bmcfgr] = 8
        XCTAssertEqual(rcc.getHCLKFreq(), 12_000_000)
    }
}
