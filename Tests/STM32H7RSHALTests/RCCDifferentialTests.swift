import CRCCControlReference
import XCTest
@testable import STM32H7RSHAL

// Both implementations receive the same hardware-only model. No Swift RCC
// algorithm is delegated to C; C runs the unchanged upstream function bodies.
private final class RCCDifferentialIO: RCCRegisterIO, RCCSystemIO {
    var state = CRCCControlState()

    init() { CRCCControl_Reset(&state) }
    init(copying state: CRCCControlState) { self.state = state }

    static func register(_ register: RCCClockRegister) -> CRCCControlRegister {
        switch register {
        case .cr: return CRCCControl_CR
        case .cfgr: return CRCCControl_CFGR
        case .cdcfgr: return CRCCControl_CDCFGR
        case .bmcfgr: return CRCCControl_BMCFGR
        case .apbcfgr: return CRCCControl_APBCFGR
        case .pllckselr: return CRCCControl_PLLCKSELR
        case .pllcfgr: return CRCCControl_PLLCFGR
        case .pll1divr1: return CRCCControl_PLL1DIVR1
        case .pll1fracr: return CRCCControl_PLL1FRACR
        case .pll2divr1: return CRCCControl_PLL2DIVR1
        case .pll2fracr: return CRCCControl_PLL2FRACR
        case .pll3divr1: return CRCCControl_PLL3DIVR1
        case .pll3fracr: return CRCCControl_PLL3FRACR
        case .pll1divr2: return CRCCControl_PLL1DIVR2
        case .pll2divr2: return CRCCControl_PLL2DIVR2
        case .pll3divr2: return CRCCControl_PLL3DIVR2
        }
    }

    static func register(_ register: RCCControlRegister) -> CRCCControlRegister {
        switch register {
        case .hsicfgr: return CRCCControl_HSICFGR
        case .bdcr: return CRCCControl_BDCR
        case .csr: return CRCCControl_CSR
        case .cier: return CRCCControl_CIER
        case .cifr: return CRCCControl_CIFR
        case .cicr: return CRCCControl_CICR
        case .rsr: return CRCCControl_RSR
        case .ahb4enr: return CRCCControl_AHB4ENR
        case .powerControl1: return CRCCControl_PWR_CR1
        }
    }

    func read(_ register: RCCClockRegister) -> UInt32 { CRCCControl_Get(&state, Self.register(register)) }
    func write(_ register: RCCClockRegister, value: UInt32) { CRCCControl_Write(&state, Self.register(register), value) }
    func read(_ register: RCCControlRegister) -> UInt32 { CRCCControl_Get(&state, Self.register(register)) }
    func write(_ register: RCCControlRegister, value: UInt32) { CRCCControl_Write(&state, Self.register(register), value) }
    func read(_ register: FlashTimingRegister) -> UInt32 { CRCCControl_Get(&state, CRCCControl_FLASH_ACR) }
    func write(_ register: FlashTimingRegister, value: UInt32) { CRCCControl_Write(&state, CRCCControl_FLASH_ACR, value) }

    func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration) {
        state.gpioCalls += 1
        state.gpioPort = 0x58020000 + port.rawValue * 0x400
        state.gpioPin = UInt32(configuration.pins)
        state.gpioMode = configuration.mode.rawValue
        state.gpioSpeed = configuration.speed.rawValue
        state.gpioPull = configuration.pull.rawValue
        state.gpioAlternate = configuration.alternate
    }

    func getTick() -> UInt32 { CRCCControl_Tick(&state) }
    func getTickPriority() -> UInt32 { state.tickPriority }
    func getSystemCoreClock() -> UInt32 { state.systemCoreClock }
    func setSystemCoreClock(_ frequency: UInt32) { state.systemCoreClock = frequency }
    func initializeTick(priority: UInt32, coreClockHz: UInt32) -> HALStatus {
        XCTAssertEqual(coreClockHz, state.systemCoreClock)
        return HALStatus(rawValue: CRCCControl_InitTick(&state, priority))!
    }
}

private struct RCCComparedWrite: Equatable {
    var register: UInt32
    var value: UInt32
    var tickCall: UInt32
}

final class RCCDifferentialTests: XCTestCase {
    private typealias Driver = RCC<RCCDifferentialIO, RCCDifferentialIO>

    private func pair(_ initial: (inout CRCCControlState) -> Void = { _ in })
        -> (RCCDifferentialIO, RCCDifferentialIO, Driver) {
        let swift = RCCDifferentialIO()
        // Reset-like HSI, with the divider-ready flag used by HAL frequency queries.
        CRCCControl_Set(&swift.state, CRCCControl_CR, 0x25)
        initial(&swift.state)
        let reference = RCCDifferentialIO(copying: swift.state)
        return (swift, reference, Driver(registers: swift, system: swift,
            oscillators: .init(hsi: swift.state.hsi, csi: swift.state.csi, hse: swift.state.hse)))
    }

    private func assertMatches(_ swift: RCCDifferentialIO, _ reference: RCCDifferentialIO,
                               _ context: String = "", file: StaticString = #filePath, line: UInt = #line) {
        func writes(_ io: RCCDifferentialIO, before count: UInt32? = nil) -> [RCCComparedWrite] {
            (UInt32(0)..<(count ?? io.state.writeCount)).compactMap { index in
                let entry = CRCCControl_GetWrite(&io.state, index)
                // The unchanged C bodies directly assign these two registers.
                guard entry.reg != CRCCControl_PWR_CR1, entry.reg != CRCCControl_RSR else { return nil }
                return RCCComparedWrite(register: entry.reg.rawValue, value: entry.value, tickCall: entry.tickCall)
            }
        }
        for index in UInt32(0)..<CRCCControl_RegisterCount.rawValue {
            let register = CRCCControlRegister(rawValue: index)
            XCTAssertEqual(CRCCControl_Get(&swift.state, register), CRCCControl_Get(&reference.state, register),
                           "\(context), register \(index)", file: file, line: line)
        }
        let actual = swift.state
        let expected = reference.state
        XCTAssertEqual(actual.tick, expected.tick, context, file: file, line: line)
        XCTAssertEqual(actual.tickCalls, expected.tickCalls, context, file: file, line: line)
        XCTAssertEqual(actual.systemCoreClock, expected.systemCoreClock, context, file: file, line: line)
        XCTAssertEqual(actual.tickPriority, expected.tickPriority, context, file: file, line: line)
        XCTAssertEqual(actual.initTickCalls, expected.initTickCalls, context, file: file, line: line)
        for index in UInt32(0)..<min(actual.initTickCalls, expected.initTickCalls) {
            let a = CRCCControl_GetInitTickCall(&swift.state, index)
            let e = CRCCControl_GetInitTickCall(&reference.state, index)
            XCTAssertEqual([a.priority, a.coreClock, a.tickCall], [e.priority, e.coreClock, e.tickCall],
                           context, file: file, line: line)
            // Compare the preceding MMIO trace as well as the tick, so moving
            // InitTick across a write within the same tick cannot pass.
            XCTAssertEqual(writes(swift, before: a.writeCount), writes(reference, before: e.writeCount),
                           context, file: file, line: line)
        }
        XCTAssertEqual(actual.hseCSSCallbacks, expected.hseCSSCallbacks, context, file: file, line: line)
        XCTAssertEqual([actual.gpioCalls, actual.gpioPort, actual.gpioPin, actual.gpioMode,
                        actual.gpioSpeed, actual.gpioPull, actual.gpioAlternate],
                       [expected.gpioCalls, expected.gpioPort, expected.gpioPin, expected.gpioMode,
                        expected.gpioSpeed, expected.gpioPull, expected.gpioAlternate],
                       context, file: file, line: line)
        XCTAssertEqual(writes(swift), writes(reference), context, file: file, line: line)
    }

    private func cPLL(_ value: RCCPLLConfiguration) -> RCC_PLLInitTypeDef {
        var result = RCC_PLLInitTypeDef()
        result.PLLState = value.state; result.PLLSource = value.source
        result.PLLM = value.m; result.PLLN = value.n; result.PLLP = value.p
        result.PLLQ = value.q; result.PLLR = value.r; result.PLLS = value.s
        result.PLLT = value.t; result.PLLFractional = value.fractional
        return result
    }

    private func swiftPLL(_ value: RCC_PLLInitTypeDef) -> RCCPLLConfiguration {
        .init(state: value.PLLState, source: value.PLLSource, m: value.PLLM, n: value.PLLN,
              p: value.PLLP, q: value.PLLQ, r: value.PLLR, s: value.PLLS,
              t: value.PLLT, fractional: value.PLLFractional)
    }

    private func cOscillators(_ value: RCCOscillatorConfiguration) -> RCC_OscInitTypeDef {
        var result = RCC_OscInitTypeDef()
        result.OscillatorType = value.oscillatorType; result.HSEState = value.hseState
        result.LSEState = value.lseState; result.HSIState = value.hsiState
        result.HSIDiv = value.hsiDivider; result.HSICalibrationValue = value.hsiCalibration
        result.LSIState = value.lsiState; result.HSI48State = value.hsi48State; result.CSIState = value.csiState
        result.PLL1 = cPLL(value.pll1); result.PLL2 = cPLL(value.pll2); result.PLL3 = cPLL(value.pll3)
        return result
    }

    private func swiftOscillators(_ value: RCC_OscInitTypeDef) -> RCCOscillatorConfiguration {
        .init(oscillatorType: value.OscillatorType, hseState: value.HSEState, lseState: value.LSEState,
              hsiState: value.HSIState, hsiDivider: value.HSIDiv, hsiCalibration: value.HSICalibrationValue,
              lsiState: value.LSIState, hsi48State: value.HSI48State, csiState: value.CSIState,
              pll1: swiftPLL(value.PLL1), pll2: swiftPLL(value.PLL2), pll3: swiftPLL(value.PLL3))
    }

    private func cClock(_ value: RCCClockConfiguration) -> RCC_ClkInitTypeDef {
        var result = RCC_ClkInitTypeDef()
        result.ClockType = value.clockType; result.SYSCLKSource = value.systemSource
        result.SYSCLKDivider = value.systemDivider; result.AHBCLKDivider = value.ahbDivider
        result.APB1CLKDivider = value.apb1Divider; result.APB2CLKDivider = value.apb2Divider
        result.APB4CLKDivider = value.apb4Divider; result.APB5CLKDivider = value.apb5Divider
        return result
    }

    private func swiftClock(_ value: RCC_ClkInitTypeDef) -> RCCClockConfiguration {
        .init(clockType: value.ClockType, systemSource: value.SYSCLKSource,
              systemDivider: value.SYSCLKDivider, ahbDivider: value.AHBCLKDivider,
              apb1Divider: value.APB1CLKDivider, apb2Divider: value.APB2CLKDivider,
              apb4Divider: value.APB4CLKDivider, apb5Divider: value.APB5CLKDivider)
    }

    @discardableResult
    private func checkOscillators(_ configuration: RCCOscillatorConfiguration,
                                  expected: HALStatus? = nil, context: String = "",
                                  initial: (inout CRCCControlState) -> Void = { _ in },
                                  file: StaticString = #filePath, line: UInt = #line) -> RCCDifferentialIO {
        var (swift, reference, driver) = pair(initial)
        var actualConfiguration = configuration
        var expectedConfiguration = cOscillators(configuration)
        let actualStatus = driver.configureOscillators(&actualConfiguration)
        let expectedStatus = CRCCControl_OscConfig(&reference.state, &expectedConfiguration)
        XCTAssertEqual(actualStatus.rawValue, expectedStatus, context, file: file, line: line)
        if let expected { XCTAssertEqual(actualStatus, expected, context, file: file, line: line) }
        XCTAssertEqual(actualConfiguration, swiftOscillators(expectedConfiguration), context, file: file, line: line)
        assertMatches(swift, reference, context, file: file, line: line)
        return swift
    }

    @discardableResult
    private func checkClock(_ configuration: RCCClockConfiguration, latency: FlashLatency,
                            expected: HALStatus? = nil, context: String = "",
                            initial: (inout CRCCControlState) -> Void = { _ in },
                            file: StaticString = #filePath, line: UInt = #line) -> RCCDifferentialIO {
        var (swift, reference, driver) = pair(initial)
        var expectedConfiguration = cClock(configuration)
        let actualStatus = driver.configureClock(configuration, latency: latency)
        let expectedStatus = CRCCControl_ClockConfig(&reference.state, &expectedConfiguration, latency.rawValue)
        XCTAssertEqual(actualStatus.rawValue, expectedStatus, context, file: file, line: line)
        if let expected { XCTAssertEqual(actualStatus, expected, context, file: file, line: line) }
        assertMatches(swift, reference, context, file: file, line: line)
        return swift
    }

    func testNullInputsMatchCWithoutSideEffects() {
        var (swift, reference, driver) = pair()
        var configuration: RCCOscillatorConfiguration?
        XCTAssertEqual(driver.configureOscillators(&configuration).rawValue, CRCCControl_OscConfig(&reference.state, nil))
        XCTAssertNil(configuration)
        XCTAssertEqual(driver.configureClock(nil, latency: .waitStates7).rawValue,
                       CRCCControl_ClockConfig(&reference.state, nil, 0x37))
        assertMatches(swift, reference)
    }

    func testEveryOscillatorSelectionCombinationMatchesC() {
        for mask in UInt32(0)...63 {
            checkOscillators(.init(oscillatorType: mask, hseState: 0x10000, lseState: 1,
                                   hsiState: 1, hsiCalibration: 0x23, lsiState: 1,
                                   hsi48State: 0x1000, csiState: 0x80), expected: .ok,
                             context: "oscillator mask \(mask)")
        }
    }

    func testOscillatorOnOffBypassAndHSIDividerTransitionsMatchC() {
        for state in [UInt32(0), 0x10000, 0x50000, 0xD0000] {
            checkOscillators(.init(oscillatorType: 1, hseState: state), expected: .ok) {
                CRCCControl_Set(&$0, CRCCControl_CR, 0xF0025)
            }
        }
        for state in [UInt32(0), 1, 5, 0x85] {
            checkOscillators(.init(oscillatorType: 4, lseState: state), expected: .ok) {
                CRCCControl_Set(&$0, CRCCControl_BDCR, 0xA5000087)
                CRCCControl_Set(&$0, CRCCControl_PWR_CR1, 0x5A00)
            }
        }
        for enabled in [false, true] {
            checkOscillators(.init(oscillatorType: 8, lsiState: enabled ? 1 : 0), expected: .ok) {
                CRCCControl_Set(&$0, CRCCControl_CSR, 0xA5000003)
            }
            checkOscillators(.init(oscillatorType: 0x10, csiState: enabled ? 0x80 : 0), expected: .ok) {
                CRCCControl_Set(&$0, CRCCControl_CR, 0x1A5)
            }
            checkOscillators(.init(oscillatorType: 0x20, hsi48State: enabled ? 0x1000 : 0), expected: .ok) {
                CRCCControl_Set(&$0, CRCCControl_CR, 0x3025)
            }
            for divider in [UInt32(0), 8, 16, 24] {
                for calibration in [UInt32(0), 63, 127] {
                    checkOscillators(.init(oscillatorType: 2, hsiState: enabled ? 1 : 0,
                                           hsiDivider: divider, hsiCalibration: calibration), expected: .ok) {
                        CRCCControl_Set(&$0, CRCCControl_CR, 0x1A5)
                        CRCCControl_Set(&$0, CRCCControl_CFGR, 9) // CSI supplies SYSCLK.
                    }
                }
            }
        }
    }

    func testHSIRetimingAndInitTickFailureBeforeTrimmingMatchC() {
        for divider in [UInt32(0), 8, 16, 24] {
            for status in UInt32(0)...3 {
                let result = checkOscillators(.init(oscillatorType: 2, hsiState: 1,
                                                    hsiDivider: divider, hsiCalibration: 0x55),
                                              expected: status == 0 ? .ok : .error) {
                    $0.initTickStatus = status
                    $0.systemCoreClock = 123456
                    CRCCControl_Set(&$0, CRCCControl_HSICFGR, 0xA5012345)
                }
                if status != 0 {
                    XCTAssertEqual(CRCCControl_Get(&result.state, CRCCControl_HSICFGR), 0xA5012345)
                }
            }
        }
    }

    func testActiveSystemAndPLLSourceProtectionMatchesC() {
        let sources: [(UInt32, UInt32, RCCOscillatorConfiguration)] = [
            (0, 0x25, .init(oscillatorType: 2)),
            (1, 0x1A5, .init(oscillatorType: 0x10)),
            (2, 0x30025, .init(oscillatorType: 1)),
        ]
        for (source, cr, configuration) in sources {
            checkOscillators(configuration, expected: .error, context: "active SYSCLK source \(source)") {
                CRCCControl_Set(&$0, CRCCControl_CR, cr)
                CRCCControl_Set(&$0, CRCCControl_CFGR, source | (source << 3))
            }
            for pll in UInt32(0)...2 {
                checkOscillators(configuration, expected: .error,
                                 context: "PLL\(pll + 1) protects source \(source)") {
                    CRCCControl_Set(&$0, CRCCControl_CR, cr | (3 << (24 + 2 * pll)))
                    CRCCControl_Set(&$0, CRCCControl_PLLCKSELR, source)
                    // Select a different SYSCLK to isolate PLL-source protection.
                    CRCCControl_Set(&$0, CRCCControl_CFGR, source == 0 ? 9 : 0)
                }
            }
        }
        checkOscillators(.init(oscillatorType: 2, hsiState: 1, hsiDivider: 8), expected: .error) {
            CRCCControl_Set(&$0, CRCCControl_CR, 0x03000025)
        }
        checkOscillators(.init(oscillatorType: 1, hseState: 0xD0000), expected: .ok) {
            CRCCControl_Set(&$0, CRCCControl_CR, 0x30025)
            CRCCControl_Set(&$0, CRCCControl_CFGR, 0x12)
        }
    }

    @discardableResult
    private func checkPLL(_ number: UInt32, _ configuration: RCCPLLConfiguration,
                          expected: HALStatus? = nil, context: String = "",
                          initial: (inout CRCCControlState) -> Void = { _ in },
                          file: StaticString = #filePath, line: UInt = #line) -> RCCDifferentialIO {
        var (swift, reference, driver) = pair(initial)
        var cConfiguration = cPLL(configuration)
        let actual = driver.configurePLL(number, configuration: configuration)
        let cStatus = CRCCControl_PLLConfig(&reference.state, number, &cConfiguration)
        XCTAssertEqual(actual.rawValue, cStatus, context, file: file, line: line)
        if let expected { XCTAssertEqual(actual, expected, context, file: file, line: line) }
        assertMatches(swift, reference, context, file: file, line: line)
        return swift
    }

    func testAllPLLsInputRangesDividerEdgesAndFractionsMatchC() {
        // Each resulting VCO input is within the upstream 1...16 MHz range.
        let inputs: [(source: UInt32, hsiDivider: UInt32, m: UInt32)] = [
            (0, 0, 4), (0, 0, 8), (0, 0, 16), (0, 0, 32), (0, 0, 63),
            (0, 24, 8), (1, 0, 1), (1, 0, 2), (1, 0, 4),
            (2, 0, 2), (2, 0, 3), (2, 0, 6), (2, 0, 12), (2, 0, 24),
        ]
        for number in UInt32(0)...2 {
            for input in inputs {
                for fractional in [UInt32(0), 1, 8191] {
                    for maximum in [false, true] {
                        let configuration = RCCPLLConfiguration(
                            state: 2, source: input.source, m: input.m, n: maximum ? 420 : 8,
                            p: maximum ? 128 : 1, q: maximum ? 127 : 2,
                            r: maximum ? 128 : 1, s: maximum ? 8 : 1,
                            t: maximum ? 8 : 1, fractional: fractional
                        )
                        checkPLL(number, configuration, expected: .ok,
                                 context: "PLL\(number) source\(input.source) M\(input.m) frac\(fractional)") {
                            CRCCControl_Set(&$0, CRCCControl_CR, 0x25 | input.hsiDivider | (3 << (24 + 2 * number)))
                            CRCCControl_Set(&$0, CRCCControl_PLLCKSELR, 0xFAFAFAFA)
                            CRCCControl_Set(&$0, CRCCControl_PLLCFGR, 0xFFFFFFFF)
                            CRCCControl_Set(&$0, CRCCControl_PLL1FRACR, 0xA5A50007)
                            CRCCControl_Set(&$0, CRCCControl_PLL2FRACR, 0x5A5A0007)
                            CRCCControl_Set(&$0, CRCCControl_PLL3FRACR, 0x12340007)
                        }
                    }
                }
            }
        }
    }

    func testPLLOffMaskSourceLockAndOscillatorInputMutationMatchC() {
        for number in UInt32(0)...2 {
            checkPLL(number, .init(state: 1), expected: .ok) {
                CRCCControl_Set(&$0, CRCCControl_CR, 0x25 | (3 << (24 + 2 * number)))
                CRCCControl_Set(&$0, CRCCControl_PLLCKSELR, 0xFFFFFFFF)
                CRCCControl_Set(&$0, CRCCControl_PLLCFGR, 0xFFFFFFFF)
            }
            checkPLL(number, .init(state: 2, source: 2, m: 3, n: 50, p: 2, q: 4, r: 8, s: 2, t: 7),
                     expected: .error) {
                $0.lockPLLSource = 1
                CRCCControl_Set(&$0, CRCCControl_PLLCKSELR, 1)
            }
        }
        let pll = RCCPLLConfiguration(state: 2, source: 2, m: 3, n: 50,
                                      p: 2, q: 4, r: 8, s: 2, t: 7, fractional: 8191)
        checkOscillators(.init(pll1: pll, pll2: pll, pll3: pll), expected: .ok)
        checkOscillators(.init(pll1: pll), expected: .error) {
            $0.automaticTransitions &= ~UInt32(CRCCControl_AutoPLL1.rawValue)
        }
    }

    func testRunningPLL1FractionalUpdatesAndTickRolloverMatchC() {
        for start in [UInt32(0), UInt32.max] {
            for fraction in [UInt32(0), 1, 4096, 8191] {
                checkOscillators(.init(pll1: .init(state: 2, t: 7, fractional: fraction)), expected: .ok) {
                    $0.tick = start
                    CRCCControl_Set(&$0, CRCCControl_CR, 0x03000025)
                    CRCCControl_Set(&$0, CRCCControl_CFGR, 0x1B)
                    CRCCControl_Set(&$0, CRCCControl_PLL1FRACR, 4096 << 3)
                    CRCCControl_Set(&$0, CRCCControl_PLLCFGR, 0xA5A50001)
                }
            }
        }
        checkOscillators(.init(pll1: .init(state: 1)), expected: .error) {
            CRCCControl_Set(&$0, CRCCControl_CFGR, 0x1B)
        }
    }

    func testOscillatorReadyDelayAndStrictTimeoutBoundariesMatchC() {
        let cases: [(RCCOscillatorConfiguration, UInt32, UInt32)] = [
            (.init(oscillatorType: 1, hseState: 0x10000), UInt32(CRCCControl_AutoHSE.rawValue), 100),
            (.init(oscillatorType: 2, hsiState: 1), UInt32(CRCCControl_AutoHSI.rawValue), 1),
            (.init(oscillatorType: 4, lseState: 1), UInt32(CRCCControl_AutoLSE.rawValue), 5000),
            (.init(oscillatorType: 8, lsiState: 1), UInt32(CRCCControl_AutoLSI.rawValue), 1),
            (.init(oscillatorType: 0x10, csiState: 0x80), UInt32(CRCCControl_AutoCSI.rawValue), 1),
            (.init(oscillatorType: 0x20, hsi48State: 0x1000), UInt32(CRCCControl_AutoHSI48.rawValue), 1),
        ]
        for (configuration, automatic, timeout) in cases {
            for delay in [UInt32(0), timeout + 1, timeout + 2] {
                checkOscillators(configuration, expected: delay <= timeout + 1 ? .ok : .timeout,
                                 context: "osc\(configuration.oscillatorType) delay\(delay)") {
                    $0.transitionDelay = delay
                    $0.tick = UInt32.max - 2
                    if configuration.oscillatorType == 2 {
                        CRCCControl_Set(&$0, CRCCControl_CR, 0x180)
                        CRCCControl_Set(&$0, CRCCControl_CFGR, 9)
                    }
                }
            }
            checkOscillators(configuration, expected: .timeout) {
                $0.automaticTransitions &= ~automatic
                if configuration.oscillatorType == 2 {
                    CRCCControl_Set(&$0, CRCCControl_CR, 0x180)
                    CRCCControl_Set(&$0, CRCCControl_CFGR, 9)
                }
            }
        }
    }

    func testPLLReadyTimeoutsKeepHelperStatusAndOuterErrorMapping() {
        let configuration = RCCPLLConfiguration(state: 2, source: 2, m: 3, n: 50,
                                                p: 2, q: 4, r: 8, s: 1, t: 1)
        for number in UInt32(0)...2 {
            for delay in [UInt32(1), 51, 52] {
                checkPLL(number, configuration, expected: delay <= 51 ? .ok : .timeout) {
                    $0.transitionDelay = delay
                }
            }
            let automatic = UInt32(1) << (6 + number)
            checkPLL(number, configuration, expected: .timeout) { $0.automaticTransitions &= ~automatic }
            checkPLL(number, .init(state: 1), expected: .timeout) {
                $0.automaticTransitions &= ~automatic
                CRCCControl_Set(&$0, CRCCControl_CR, 0x25 | (3 << (24 + 2 * number)))
            }
        }
    }

    private func checkDeinitialize(expected: HALStatus, context: String = "",
                                  initial: (inout CRCCControlState) -> Void = { _ in },
                                  file: StaticString = #filePath, line: UInt = #line) {
        var (swift, reference, driver) = pair(initial)
        let actual = driver.deinitialize()
        XCTAssertEqual(actual.rawValue, CRCCControl_DeInit(&reference.state), context, file: file, line: line)
        XCTAssertEqual(actual, expected, context, file: file, line: line)
        assertMatches(swift, reference, context, file: file, line: line)
    }

    private func fastPLLClock(_ state: inout CRCCControlState) {
        // 64 MHz / 4 * 24 / 2 = 192 MHz, with no fractional component.
        CRCCControl_Set(&state, CRCCControl_CR, 0x03000025)
        CRCCControl_Set(&state, CRCCControl_CFGR, 0x1B)
        CRCCControl_Set(&state, CRCCControl_PLLCKSELR, 4 << 4)
        CRCCControl_Set(&state, CRCCControl_PLL1DIVR1, 23 | (1 << 9))
        state.systemCoreClock = 192_000_000
    }

    func testDeinitializeBothFrequencyBranchesAndInitTickFailuresMatchC() {
        for fast in [false, true] {
            for initStatus in UInt32(0)...3 {
                checkDeinitialize(expected: initStatus == 0 ? .ok : .error,
                                  context: "DeInit fast\(fast) InitTick\(initStatus)") {
                    if fast { fastPLLClock(&$0) }
                    else { $0.systemCoreClock = 12_345_678 }
                    $0.initTickStatus = initStatus
                    CRCCControl_Set(&$0, CRCCControl_HSICFGR, 0x80001234)
                    CRCCControl_Set(&$0, CRCCControl_CIER, 0xFFFFFFFF)
                    CRCCControl_Set(&$0, CRCCControl_CIFR, 0xFFFFFFFF)
                    CRCCControl_Set(&$0, CRCCControl_RSR, 0x55620000)
                    CRCCControl_Set(&$0, CRCCControl_FLASH_ACR, 0xA5000037)
                }
            }
        }
    }

    func testDeinitializeReadyAndSwitchTimeoutsMatchC() {
        checkDeinitialize(expected: .timeout, context: "HSI never ready") {
            CRCCControl_Set(&$0, CRCCControl_CR, 0)
            $0.automaticTransitions &= ~UInt32(CRCCControl_AutoHSI.rawValue)
        }
        checkDeinitialize(expected: .timeout, context: "HSE never stops") {
            CRCCControl_Set(&$0, CRCCControl_CR, 0x30025)
            $0.automaticTransitions &= ~UInt32(CRCCControl_AutoHSE.rawValue)
        }
        for pll in UInt32(0)...2 {
            checkDeinitialize(expected: .timeout, context: "PLL\(pll + 1) never stops") {
                CRCCControl_Set(&$0, CRCCControl_CR, 0x25 | (3 << (24 + 2 * pll)))
                $0.automaticTransitions &= ~(1 << (6 + pll))
            }
        }
        checkDeinitialize(expected: .timeout, context: "SYSCLK switch never finishes") {
            CRCCControl_Set(&$0, CRCCControl_CR, 0x30025)
            CRCCControl_Set(&$0, CRCCControl_CFGR, 0x12)
            $0.automaticTransitions &= ~UInt32(CRCCControl_AutoSystemClock.rawValue)
            $0.tick = UInt32.max - 10
        }
        for delay in [UInt32(1), 2, 3] {
            checkDeinitialize(expected: delay <= 1 ? .ok : .timeout, context: "HSI delay\(delay)") {
                CRCCControl_Set(&$0, CRCCControl_CR, 0)
                $0.transitionDelay = delay
            }
        }
    }

    func testAllValidClockTypeMasksSourcesAndDividerDirectionsMatchC() {
        // ClockType zero is rejected by both upstream assert_param and Swift.
        // All 63 valid masks are covered, independently of the null-input test.
        for mask in UInt32(1)...63 {
            for source in UInt32(0)...3 {
                for increasing in [false, true] {
                    let configuration = RCCClockConfiguration(
                        clockType: mask, systemSource: source, systemDivider: increasing ? 8 : 0,
                        ahbDivider: increasing ? 10 : 0, apb1Divider: increasing ? 4 : 0,
                        apb2Divider: increasing ? 0x50 : 0, apb4Divider: increasing ? 0x600 : 0,
                        apb5Divider: increasing ? 0x7000 : 0
                    )
                    checkClock(configuration, latency: increasing ? .waitStates7 : .waitStates0,
                               expected: .ok, context: "mask\(mask) source\(source) inc\(increasing)") {
                        CRCCControl_Set(&$0, CRCCControl_CR, 0x030301A5)
                        CRCCControl_Set(&$0, CRCCControl_PLLCKSELR, 4 << 4)
                        CRCCControl_Set(&$0, CRCCControl_PLL1DIVR1, 23 | (1 << 9))
                        CRCCControl_Set(&$0, CRCCControl_CDCFGR, increasing ? 0 : 0xF)
                        CRCCControl_Set(&$0, CRCCControl_BMCFGR, 0xA5000000 | (increasing ? 0 : 0xF))
                        CRCCControl_Set(&$0, CRCCControl_APBCFGR, 0xA5000000 | (increasing ? 0 : 0x7777))
                        CRCCControl_Set(&$0, CRCCControl_FLASH_ACR, 0xA5000000 | (increasing ? 0 : 0x37))
                    }
                }
            }
        }
    }

    func testEveryBusDividerAndFlashLatencyEncodingMatchesC() {
        let coreDividers: [UInt32] = [0, 8, 9, 10, 11, 12, 13, 14, 15]
        let apbDividers: [UInt32] = [0, 4, 5, 6, 7]
        for (index, divider) in coreDividers.enumerated() {
            for apb in apbDividers {
                for latency in FlashLatency.allCases {
                    checkClock(.init(clockType: 63, systemSource: 2, systemDivider: divider,
                                     ahbDivider: coreDividers[coreDividers.count - index - 1],
                                     apb1Divider: apb, apb2Divider: apb << 4,
                                     apb4Divider: apb << 8, apb5Divider: apb << 12),
                               latency: latency, expected: .ok) {
                        CRCCControl_Set(&$0, CRCCControl_CR, 0x30025)
                        CRCCControl_Set(&$0, CRCCControl_FLASH_ACR, 0x80000012)
                        CRCCControl_Set(&$0, CRCCControl_APBCFGR, 0x5555)
                    }
                }
            }
        }
    }

    func testClockSourceReadinessFlashRejectionAndInitTickResultsMatchC() {
        for source in UInt32(0)...3 {
            checkClock(.init(clockType: 63, systemSource: source, systemDivider: 8,
                             ahbDivider: 8, apb1Divider: 4, apb2Divider: 0x40,
                             apb4Divider: 0x400, apb5Divider: 0x4000),
                       latency: .waitStates7, expected: .error) {
                CRCCControl_Set(&$0, CRCCControl_CR, 0)
            }
        }
        for increasing in [false, true] {
            checkClock(.init(clockType: 63, systemSource: 0, systemDivider: 8,
                             ahbDivider: 8, apb1Divider: 4),
                       latency: increasing ? .waitStates7 : .waitStates0, expected: .error) {
                $0.rejectFlashLatency = 1
                CRCCControl_Set(&$0, CRCCControl_FLASH_ACR, increasing ? 0 : 0x37)
            }
        }
        for status in UInt32(0)...3 {
            checkClock(.init(clockType: 1, systemSource: 0), latency: .waitStates1,
                       expected: HALStatus(rawValue: status)!) { $0.initTickStatus = status }
        }
    }

    func testClockSwitchStrictTimeoutBoundaryAndRolloverMatchC() {
        for delay in [UInt32(0), 1, 5001, 5002] {
            checkClock(.init(clockType: 1, systemSource: 2), latency: .waitStates1,
                       expected: delay <= 5001 ? .ok : .timeout) {
                CRCCControl_Set(&$0, CRCCControl_CR, 0x30025)
                $0.transitionDelay = delay
                $0.tick = UInt32.max - 5
            }
        }
        checkClock(.init(clockType: 1, systemSource: 2), latency: .waitStates1, expected: .timeout) {
            CRCCControl_Set(&$0, CRCCControl_CR, 0x30025)
            $0.automaticTransitions &= ~UInt32(CRCCControl_AutoSystemClock.rawValue)
        }
    }

    func testExplicitReadyEventsWithNonUnitTickStepMatchC() {
        for due in [UInt32(51), 52] {
            checkOscillators(.init(oscillatorType: 1, hseState: 0x10000),
                             expected: due == 51 ? .ok : .timeout) {
                $0.tick = UInt32.max - 10
                $0.tickStep = 2
                $0.automaticTransitions &= ~UInt32(CRCCControl_AutoHSE.rawValue)
                CRCCControl_ScheduleEvent(&$0, CRCCControl_CR, 0x20000, 0x20000, due)
            }
        }
    }

    func testReadyFlagsStuckDuringOscillatorShutdownMatchC() {
        let cases: [(RCCOscillatorConfiguration, CRCCControlRegister, UInt32, UInt32)] = [
            (.init(oscillatorType: 1), CRCCControl_CR, 0x30025, UInt32(CRCCControl_AutoHSE.rawValue)),
            (.init(oscillatorType: 2), CRCCControl_CR, 0x1A5, UInt32(CRCCControl_AutoHSI.rawValue)),
            (.init(oscillatorType: 4), CRCCControl_BDCR, 3, UInt32(CRCCControl_AutoLSE.rawValue)),
            (.init(oscillatorType: 8), CRCCControl_CSR, 3, UInt32(CRCCControl_AutoLSI.rawValue)),
            (.init(oscillatorType: 0x10), CRCCControl_CR, 0x1A5, UInt32(CRCCControl_AutoCSI.rawValue)),
            (.init(oscillatorType: 0x20), CRCCControl_CR, 0x3025, UInt32(CRCCControl_AutoHSI48.rawValue)),
        ]
        for (configuration, register, bits, automatic) in cases {
            checkOscillators(configuration, expected: .timeout) {
                CRCCControl_Set(&$0, register, bits)
                $0.automaticTransitions &= ~automatic
                if configuration.oscillatorType == 2 { CRCCControl_Set(&$0, CRCCControl_CFGR, 9) }
            }
        }
    }

    func testNonNullOptionalConfigurationCopiesBackPLLTMutations() {
        var (swift, reference, driver) = pair()
        let pll = RCCPLLConfiguration(state: 2, source: 2, m: 3, n: 50, p: 2, q: 4, r: 8, s: 2, t: 7)
        var configuration: RCCOscillatorConfiguration? = .init(pll1: pll, pll3: pll)
        var cConfiguration = cOscillators(configuration!)
        XCTAssertEqual(driver.configureOscillators(&configuration).rawValue,
                       CRCCControl_OscConfig(&reference.state, &cConfiguration))
        XCTAssertEqual(configuration, swiftOscillators(cConfiguration))
        XCTAssertEqual(configuration?.pll1.t, 1)
        XCTAssertEqual(configuration?.pll3.t, 1)
        assertMatches(swift, reference)
    }

    func testRawOscillatorAndClockReadbackMatchesCIncludingReservedBits() {
        var seed: UInt32 = 0xC10C5EED
        func next() -> UInt32 {
            seed ^= seed << 13
            seed ^= seed >> 17
            seed ^= seed << 5
            return seed
        }
        for sample in 0..<128 {
            var (swift, reference, driver) = pair { state in
                for index in UInt32(0)..<CRCCControl_RegisterCount.rawValue {
                    CRCCControl_Set(&state, CRCCControlRegister(rawValue: index), next())
                }
            }
            var oscillator = RCC_OscInitTypeDef()
            CRCCControl_GetOscConfig(&reference.state, &oscillator)
            XCTAssertEqual(driver.getOscillatorConfiguration(), swiftOscillators(oscillator), "sample \(sample)")
            var clock = RCC_ClkInitTypeDef()
            var latency: UInt32 = 0
            CRCCControl_GetClockConfig(&reference.state, &clock, &latency)
            let actual = driver.getClockConfiguration()
            XCTAssertEqual(actual.configuration, swiftClock(clock), "sample \(sample)")
            XCTAssertEqual(actual.latency, latency, "sample \(sample)")
            assertMatches(swift, reference, "readback \(sample)")
        }
    }

    func testBothMCOOutputsAllSourcesAndDividersMatchC() {
        for second in [false, true] {
            for source in UInt32(0)...(second ? 5 : 4) {
                for divisor in UInt32(0)...15 {
                    var (swift, reference, driver) = pair {
                        CRCCControl_Set(&$0, CRCCControl_CFGR, 0xA5A50000)
                        CRCCControl_Set(&$0, CRCCControl_AHB4ENR, 0xA5000050)
                    }
                    let output: UInt32 = second ? 0x10020200 : 0x100
                    let encodedSource = source << (second ? 29 : 22)
                    let encodedDivider = divisor << 18
                    driver.configureMCO(output: output, source: encodedSource, divider: encodedDivider)
                    CRCCControl_MCOConfig(&reference.state, output, encodedSource, encodedDivider)
                    assertMatches(swift, reference, "MCO\(second ? 2 : 1) source\(source) divisor\(divisor)")
                }
            }
        }
    }

    func testCSSNMIAndResetSourceMatchC() {
        for initialCR in [UInt32(0x25), 0xFFFFFFFF, 0xA5A5A5A5] {
            var (swift, reference, driver) = pair {
                $0.automaticTransitions = 0
                CRCCControl_Set(&$0, CRCCControl_CR, initialCR)
            }
            driver.enableCSS()
            CRCCControl_EnableCSS(&reference.state)
            assertMatches(swift, reference)
            driver.disableCSS()
            CRCCControl_DisableCSS(&reference.state)
            assertMatches(swift, reference)
        }
        for flags in [UInt32(0), 0x400, 0x800, 0xFFFFFFFF] {
            var (swift, reference, driver) = pair { CRCCControl_Set(&$0, CRCCControl_CIFR, flags) }
            for _ in 0..<2 {
                driver.handleNMI { swift.state.hseCSSCallbacks += 1 }
                CRCCControl_NMI(&reference.state)
                assertMatches(swift, reference)
            }
        }
        for flags in [UInt32(0), 0x55620000, 0xFFFFFFFF, 0xAAAAAAAA, 0x55555555] {
            var (swift, reference, driver) = pair { CRCCControl_Set(&$0, CRCCControl_RSR, flags) }
            XCTAssertEqual(driver.getResetSource(), CRCCControl_GetResetSource(&reference.state))
            assertMatches(swift, reference)
            XCTAssertNotEqual(CRCCControl_Get(&swift.state, CRCCControl_RSR) & 0x10000, 0)
        }
    }
}
