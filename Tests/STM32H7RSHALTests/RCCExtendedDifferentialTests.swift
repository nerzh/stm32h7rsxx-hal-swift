import CRCCExtendedReference
import XCTest

@testable import STM32H7RSHAL

// The shared C model supplies register behavior, ticks and observations only.
// This side invokes the Swift HAL; the other state invokes unchanged C bodies.
private final class RCCExtendedDifferentialIO: RCCExtendedRegisterIO, RCCSystemIO {
    var storage = CRCCExtendedState()
    // GetPeriphCLKConfig reads TIMPRE directly through RCC->CFGR once. That
    // access bypasses the C READ_REG hook, while Swift still records it. These
    // readback fixtures keep CFGR stable and compare this exact extra read;
    // they do not discard CFGR observations or relax any register/write check.
    var directTIMReads: UInt32 = 0
    var rcc: RCC<RCCExtendedDifferentialIO, RCCExtendedDifferentialIO> {
        .init(
            registers: self, system: self,
            oscillators: .init(
                hsi: storage.hsi, csi: storage.csi, hse: storage.hse,
                lse: storage.lse, lsi: storage.lsi, hsi48: storage.hsi48,
                external: storage.externalClock),
            timeouts: .init(lseStartup: storage.lseStartupTimeout))
    }

    static func register(_ register: RCCClockRegister) -> CRCCExtendedRegister {
        switch register {
        case .cr: return CRCCExtended_CR
        case .cfgr: return CRCCExtended_CFGR
        case .cdcfgr: return CRCCExtended_CDCFGR
        case .bmcfgr: return CRCCExtended_BMCFGR
        case .apbcfgr: return CRCCExtended_APBCFGR
        case .pllckselr: return CRCCExtended_PLLCKSELR
        case .pllcfgr: return CRCCExtended_PLLCFGR
        case .pll1divr1: return CRCCExtended_PLL1DIVR1
        case .pll1fracr: return CRCCExtended_PLL1FRACR
        case .pll2divr1: return CRCCExtended_PLL2DIVR1
        case .pll2fracr: return CRCCExtended_PLL2FRACR
        case .pll3divr1: return CRCCExtended_PLL3DIVR1
        case .pll3fracr: return CRCCExtended_PLL3FRACR
        case .pll1divr2: return CRCCExtended_PLL1DIVR2
        case .pll2divr2: return CRCCExtended_PLL2DIVR2
        case .pll3divr2: return CRCCExtended_PLL3DIVR2
        }
    }
    static func register(_ register: RCCControlRegister) -> CRCCExtendedRegister {
        switch register {
        case .bdcr: return CRCCExtended_BDCR
        case .csr: return CRCCExtended_CSR
        case .cier: return CRCCExtended_CIER
        case .cifr: return CRCCExtended_CIFR
        case .cicr: return CRCCExtended_CICR
        case .powerControl1: return CRCCExtended_PWR_CR1
        default: preconditionFailure("RCCEx must not access this control register")
        }
    }
    static func register(_ register: RCCExtendedRegister) -> CRCCExtendedRegister {
        switch register {
        case .ccipr1: return CRCCExtended_CCIPR1
        case .ccipr2: return CRCCExtended_CCIPR2
        case .ccipr3: return CRCCExtended_CCIPR3
        case .ccipr4: return CRCCExtended_CCIPR4
        case .ckprotr: return CRCCExtended_CKPROTR
        }
    }
    static func register(_ register: EXTIRegister) -> CRCCExtendedRegister {
        switch register {
        case .interruptMask(bank: 0): return CRCCExtended_EXTI_IMR1
        case .eventMask(bank: 0): return CRCCExtended_EXTI_EMR1
        case .risingTrigger(bank: 0): return CRCCExtended_EXTI_RTSR1
        case .fallingTrigger(bank: 0): return CRCCExtended_EXTI_FTSR1
        case .softwareInterrupt(bank: 0): return CRCCExtended_EXTI_SWIER1
        case .pending(bank: 0): return CRCCExtended_EXTI_PR1
        default: preconditionFailure("RCCEx must not access this EXTI bank")
        }
    }
    func read(_ register: RCCClockRegister) -> UInt32 { CRCCExtended_Read(&storage, Self.register(register)) }
    func write(_ register: RCCClockRegister, value: UInt32) {
        CRCCExtended_Write(&storage, Self.register(register), value)
    }
    func read(_ register: RCCControlRegister) -> UInt32 { CRCCExtended_Read(&storage, Self.register(register)) }
    func write(_ register: RCCControlRegister, value: UInt32) {
        CRCCExtended_Write(&storage, Self.register(register), value)
    }
    func read(_ register: RCCExtendedRegister) -> UInt32 { CRCCExtended_Read(&storage, Self.register(register)) }
    func write(_ register: RCCExtendedRegister, value: UInt32) {
        CRCCExtended_Write(&storage, Self.register(register), value)
    }
    func read(_ register: EXTIRegister) -> UInt32 { CRCCExtended_Read(&storage, Self.register(register)) }
    func write(_ register: EXTIRegister, value: UInt32) { CRCCExtended_Write(&storage, Self.register(register), value) }
    func read(_ register: FlashTimingRegister) -> UInt32 {
        XCTFail("Unexpected FLASH read")
        return 0
    }
    func write(_ register: FlashTimingRegister, value: UInt32) { XCTFail("Unexpected FLASH write") }
    func initializeMCOGPIO(port: GPIOPort, configuration: GPIOConfiguration) { XCTFail("Unexpected GPIO access") }
    func getTick() -> UInt32 { CRCCExtended_Tick(&storage) }
    func getTickPriority() -> UInt32 {
        XCTFail("Unexpected tick priority read")
        return 0
    }
    func getSystemCoreClock() -> UInt32 {
        XCTFail("Unexpected cached SystemCoreClock read")
        return 0
    }
    func setSystemCoreClock(_ frequency: UInt32) { XCTFail("Unexpected SystemCoreClock write") }
    func initializeTick(priority: UInt32, coreClockHz: UInt32) -> HALStatus {
        XCTFail("Unexpected tick initialization")
        return .error
    }
}

final class RCCExtendedDifferentialTests: XCTestCase {
    private let fields:
        [(WritableKeyPath<RCCPeripheralClockConfiguration, UInt32>, WritableKeyPath<RCC_PeriphCLKInitTypeDef, UInt32>)] =
            [
                (\.fmcClockSelection, \.FmcClockSelection), (\.xspi1ClockSelection, \.Xspi1ClockSelection),
                (\.xspi2ClockSelection, \.Xspi2ClockSelection), (\.ckperClockSelection, \.CkperClockSelection),
                (\.adcClockSelection, \.AdcClockSelection), (\.adf1ClockSelection, \.Adf1ClockSelection),
                (\.cecClockSelection, \.CecClockSelection), (\.eth1RefClockSelection, \.Eth1RefClockSelection),
                (\.eth1PhyClockSelection, \.Eth1PhyClockSelection), (\.fdcanClockSelection, \.FdcanClockSelection),
                (\.i2c1I3c1ClockSelection, \.I2c1_I3c1ClockSelection), (\.i2c23ClockSelection, \.I2c23ClockSelection),
                (\.lptim1ClockSelection, \.Lptim1ClockSelection), (\.lptim23ClockSelection, \.Lptim23ClockSelection),
                (\.lptim45ClockSelection, \.Lptim45ClockSelection), (\.lpuart1ClockSelection, \.Lpuart1ClockSelection),
                (\.ltdcClockSelection, \.LtdcClockSelection), (\.pssiClockSelection, \.PssiClockSelection),
                (\.sai1ClockSelection, \.Sai1ClockSelection), (\.sai2ClockSelection, \.Sai2ClockSelection),
                (\.sdmmc12ClockSelection, \.Sdmmc12ClockSelection), (\.spi1ClockSelection, \.Spi1ClockSelection),
                (\.spi23ClockSelection, \.Spi23ClockSelection), (\.spi45ClockSelection, \.Spi45ClockSelection),
                (\.spi6ClockSelection, \.Spi6ClockSelection), (\.spdifrxClockSelection, \.SpdifrxClockSelection),
                (\.usart1ClockSelection, \.Usart1ClockSelection),
                (\.usart234578ClockSelection, \.Usart234578ClockSelection),
                (\.usbPhycClockSelection, \.UsbPhycClockSelection), (\.usbRefClockSelection, \.UsbRefClockSelection),
                (\.usbOtgFsClockSelection, \.UsbOtgFsClockSelection), (\.rtcClockSelection, \.RTCClockSelection),
                (\.timPresSelection, \.TIMPresSelection),
            ]

    private func cConfiguration(_ value: RCCPeripheralClockConfiguration) -> RCC_PeriphCLKInitTypeDef {
        var result = RCC_PeriphCLKInitTypeDef()
        result.PeriphClockSelection = value.selection.rawValue
        for (swiftField, cField) in fields { result[keyPath: cField] = value[keyPath: swiftField] }
        return result
    }
    private func swiftConfiguration(_ value: RCC_PeriphCLKInitTypeDef) -> RCCPeripheralClockConfiguration {
        var result = RCCPeripheralClockConfiguration(selection: .init(rawValue: value.PeriphClockSelection))
        for (swiftField, cField) in fields { result[keyPath: swiftField] = value[keyPath: cField] }
        return result
    }

    private func withPair(
        setup: (inout CRCCExtendedState) -> Void = { _ in }, compareReads: Bool = true,
        file: StaticString = #filePath, line: UInt = #line,
        body: (RCCExtendedDifferentialIO, RCCExtendedDifferentialIO) -> Void
    ) {
        let actual = RCCExtendedDifferentialIO()
        CRCCExtended_Reset(&actual.storage)
        setup(&actual.storage)
        let reference = RCCExtendedDifferentialIO()
        reference.storage = actual.storage
        body(actual, reference)
        for index in UInt32(0)..<CRCCExtended_RegisterCount.rawValue {
            let register = CRCCExtendedRegister(rawValue: index)
            XCTAssertEqual(
                CRCCExtended_Get(&actual.storage, register), CRCCExtended_Get(&reference.storage, register),
                "register \(index)", file: file, line: line)
            if compareReads {
                let directReads = register == CRCCExtended_CFGR ? actual.directTIMReads : 0
                XCTAssertEqual(
                    CRCCExtended_ReadCount(&actual.storage, register),
                    CRCCExtended_ReadCount(&reference.storage, register) + directReads,
                    "reads of register \(index), including known direct C reads", file: file, line: line)
            }
        }
        XCTAssertEqual(
            [
                actual.storage.tick, actual.storage.tickCalls, actual.storage.backupResetCount,
                actual.storage.crsResetCount,
                actual.storage.lseReadyPending, actual.storage.lseReadyDueCall,
            ],
            [
                reference.storage.tick, reference.storage.tickCalls, reference.storage.backupResetCount,
                reference.storage.crsResetCount,
                reference.storage.lseReadyPending, reference.storage.lseReadyDueCall,
            ], file: file, line: line)
        XCTAssertEqual(actual.storage.writeCount, reference.storage.writeCount, file: file, line: line)
        for index in UInt32(0)..<min(actual.storage.writeCount, reference.storage.writeCount) {
            let a = CRCCExtended_GetWrite(&actual.storage, index)
            let e = CRCCExtended_GetWrite(&reference.storage, index)
            XCTAssertEqual(
                [a.reg.rawValue, a.value, a.tickCall], [e.reg.rawValue, e.value, e.tickCall],
                "write \(index)", file: file, line: line)
        }
        XCTAssertEqual(actual.storage.callbackCount, reference.storage.callbackCount, file: file, line: line)
        for index in UInt32(0)..<min(actual.storage.callbackCount, reference.storage.callbackCount) {
            let a = CRCCExtended_GetCallback(&actual.storage, index)
            let e = CRCCExtended_GetCallback(&reference.storage, index)
            XCTAssertEqual(
                [
                    a.callbackID.rawValue, a.argument, a.tickCall, a.writeCount,
                    a.rccBDCR, a.rccCIER, a.rccCIFR, a.rccCICR, a.extiPR1,
                ],
                [
                    e.callbackID.rawValue, e.argument, e.tickCall, e.writeCount,
                    e.rccBDCR, e.rccCIER, e.rccCIFR, e.rccCICR, e.extiPR1,
                ],
                "callback \(index)", file: file, line: line)
        }
    }

    @discardableResult
    private func configure(
        _ value: RCCPeripheralClockConfiguration, _ actual: RCCExtendedDifferentialIO,
        _ reference: RCCExtendedDifferentialIO,
        file: StaticString = #filePath, line: UInt = #line
    ) -> HALStatus {
        var rcc = actual.rcc
        var config = cConfiguration(value)
        let status = rcc.configurePeripheralClocks(value)
        XCTAssertEqual(
            status.rawValue, CRCCExtended_ConfigurePeripheralClocks(&reference.storage, &config), file: file, line: line
        )
        return status
    }

    private func compareReadback(
        _ actual: RCCExtendedDifferentialIO, _ reference: RCCExtendedDifferentialIO,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        var rcc = actual.rcc
        var config = RCC_PeriphCLKInitTypeDef()
        CRCCExtended_GetPeripheralClockConfiguration(&reference.storage, &config)
        actual.directTIMReads += 1
        XCTAssertEqual(rcc.getPeripheralClockConfiguration(), swiftConfiguration(config), file: file, line: line)
    }

    private func frequencyFixture(_ storage: inout CRCCExtendedState) {
        let io = RCCExtendedTraceIO()
        configureRCCExtendedFrequencyFixture(io)
        for (register, value) in io.clocks {
            CRCCExtended_Set(&storage, RCCExtendedDifferentialIO.register(register), value)
        }
        for (register, value) in io.controls {
            CRCCExtended_Set(&storage, RCCExtendedDifferentialIO.register(register), value)
        }
    }

    private func compareFrequency(
        _ selection: UInt32, _ actual: RCCExtendedDifferentialIO,
        _ reference: RCCExtendedDifferentialIO,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        var rcc = actual.rcc
        XCTAssertEqual(
            rcc.getPeripheralClockFrequency(selection),
            CRCCExtended_GetPeripheralClockFrequency(&reference.storage, selection),
            "peripheral \(selection)", file: file, line: line)
        XCTAssertEqual(actual.storage.writeCount, 0, file: file, line: line)
    }

    func testEveryMuxSourceConfigurationAndReadbackMatchesC() {
        for fixture in rccExtendedMuxFixtures {
            for (source, _) in fixture.sources {
                for background: UInt32 in [0, 0xA5A5_5A5A, .max] {
                    withPair(setup: { state in
                        for register in [
                            CRCCExtended_CCIPR1, CRCCExtended_CCIPR2, CRCCExtended_CCIPR3, CRCCExtended_CCIPR4,
                        ] {
                            CRCCExtended_Set(&state, register, background)
                        }
                        CRCCExtended_Set(&state, CRCCExtended_PLLCFGR, background)
                    }) { actual, reference in
                        var config = RCCPeripheralClockConfiguration(selection: fixture.selection)
                        config[keyPath: fixture.field] = source
                        XCTAssertEqual(configure(config, actual, reference), .ok)
                        compareReadback(actual, reference)
                    }
                }
            }
        }
    }

    func testAllThirtyThreeSelectionsTogetherPreserveCWriteOrder() {
        for index in 0..<12 {
            var config = RCCPeripheralClockConfiguration(
                selection: .init(rawValue: 0x1_FFFF_FFFF),
                rtcClockSelection: 0x100, timPresSelection: index & 1 == 0 ? 0 : 0x8000)
            for fixture in rccExtendedMuxFixtures {
                config[keyPath: fixture.field] = fixture.sources[index % fixture.sources.count].0
            }
            withPair(setup: { state in
                CRCCExtended_Set(&state, CRCCExtended_BDCR, 3)
                CRCCExtended_Set(&state, CRCCExtended_PLLCFGR, 0x8000_0000)
                CRCCExtended_Set(&state, CRCCExtended_CFGR, 0x55AA_FFFF)
            }) { actual, reference in
                XCTAssertEqual(configure(config, actual, reference), .ok)
                compareReadback(actual, reference)
            }
        }
    }

    func testAllRTCSourcesPreviousSelectionsAndHSEDivisorsMatchC() {
        let sources: [UInt32] = [0, 0x100, 0x200] + (UInt32(2)...63).map { ($0 << 12) | 0x300 }
        for oldSource: UInt32 in [0, 0x100, 0x200, 0x300] {
            for source in sources {
                withPair(setup: { state in
                    CRCCExtended_Set(&state, CRCCExtended_BDCR, oldSource | 0x8033)
                    CRCCExtended_Set(&state, CRCCExtended_PWR_CR1, 0x20)
                    CRCCExtended_Set(&state, CRCCExtended_CFGR, 0xA5A5_FFFF)
                }) { actual, reference in
                    XCTAssertEqual(configure(.init(selection: .rtc, rtcClockSelection: source), actual, reference), .ok)
                    let resets: UInt32 = oldSource != 0 && oldSource != source & 0x300 ? 1 : 0
                    XCTAssertEqual(actual.storage.backupResetCount, resets)
                    compareReadback(actual, reference)
                }
            }
        }
    }

    func testRTCBackupAccessRejectionKeepsErrorStickyAcrossAllLaterSelections() {
        var config = RCCPeripheralClockConfiguration(
            selection: .init(rawValue: 0x1_FFFF_FFFF),
            rtcClockSelection: 0x200, timPresSelection: 0x8000)
        for fixture in rccExtendedMuxFixtures {
            config[keyPath: fixture.field] = fixture.sources.first(where: { $0.1 != 0 })?.0 ?? fixture.sources.last!.0
        }
        withPair(setup: { state in
            state.rejectBackupAccess = 1
            CRCCExtended_Set(&state, CRCCExtended_BDCR, 0x8133)
            CRCCExtended_Set(&state, CRCCExtended_PLLCFGR, 0x8000_0000)
            CRCCExtended_Set(&state, CRCCExtended_CCIPR1, 0xA5A5_5A5A)
            CRCCExtended_Set(&state, CRCCExtended_CCIPR2, 0x5A5A_A5A5)
        }) { actual, reference in
            XCTAssertEqual(configure(config, actual, reference), .error)
            XCTAssertEqual(actual.storage.backupResetCount, 0)
            XCTAssertEqual(actual.storage.tickCalls, 0)
            compareReadback(actual, reference)
        }
    }

    func testDelayedLSEBackupRestoreTimeoutBoundaryAndTickWrapMatchC() {
        for start: UInt32 in [0, .max - 2] {
            for delay: UInt32 in [0, 1, 2, 4, 5, 6] {
                for automatic: UInt32 in [0, 1] {
                    withPair(setup: { state in
                        state.tick = start
                        state.lseStartupTimeout = 3
                        state.automaticLSE = automatic
                        state.lseReadyDelay = delay
                        CRCCExtended_Set(&state, CRCCExtended_BDCR, 0x8233)
                    }) { actual, reference in
                        let config = RCCPeripheralClockConfiguration(
                            selection: [.rtc, .fmc, .cec, .ltdc, .tim, .usbRef],
                            fmcClockSelection: 1, cecClockSelection: 0x2000_0000,
                            usbRefClockSelection: 0x900, rtcClockSelection: 0x100,
                            timPresSelection: 0x8000)
                        let status = configure(config, actual, reference)
                        XCTAssertEqual(status, automatic != 0 && delay <= 4 ? .ok : .error)
                        XCTAssertEqual(actual.storage.backupResetCount, 1)
                        compareReadback(actual, reference)
                    }
                }
            }
        }
    }

    func testLSEReadEventsAndDeadlineDoNotInventFinalRecheck() {
        for triggerRead: UInt32 in [2, 3, 4, 5, 6] {
            withPair(setup: { state in
                state.tick = .max - 1
                state.lseStartupTimeout = 2
                state.automaticLSE = 0
                CRCCExtended_Set(&state, CRCCExtended_BDCR, 1)
                CRCCExtended_ScheduleRead(&state, CRCCExtended_BDCR, triggerRead, CRCCExtended_BDCR, 0, 2)
            }) { actual, reference in
                let result = configure(.init(selection: .rtc, rtcClockSelection: 0x100), actual, reference)
                XCTAssertEqual(result, triggerRead <= 4 ? .ok : .error)
            }
        }
        withPair(setup: { state in
            state.lseStartupTimeout = 2
            state.automaticLSE = 0
            CRCCExtended_Set(&state, CRCCExtended_BDCR, 1)
            CRCCExtended_ScheduleTick(&state, 4, CRCCExtended_BDCR, 0, 2)
        }) { actual, reference in
            XCTAssertEqual(configure(.init(selection: .rtc, rtcClockSelection: 0x100), actual, reference), .error)
            XCTAssertEqual(CRCCExtended_Get(&actual.storage, CRCCExtended_BDCR) & 2, 2)
            XCTAssertEqual(actual.storage.writeCount, 0)
        }
    }

    func testRuntimeInvalidLPTIMSelectionsLeaveLaterErrorsSticky() {
        for selection in [RCCPeripheralClockSelection.lptim23, .lptim45] {
            for invalid: UInt32 in [0x600, 0x700, 0x6000, 0x7000, .max] {
                var config = RCCPeripheralClockConfiguration(
                    selection: [selection, .lpuart1, .ltdc, .sai1, .tim, .usbRef],
                    lpuart1ClockSelection: 1, sai1ClockSelection: 0x20000,
                    usbRefClockSelection: 0xB00, timPresSelection: 0x8000)
                if selection == .lptim23 {
                    config.lptim23ClockSelection = invalid
                } else {
                    config.lptim45ClockSelection = invalid
                }
                withPair { actual, reference in
                    XCTAssertEqual(configure(config, actual, reference), .error)
                    compareReadback(actual, reference)
                }
            }
        }
    }

    func testReadbackPreservesRawEncodingsAndRepeatedRegisterReads() {
        for pattern: UInt32 in [0, .max, 0xA5A5_5A5A, 0x5A5A_A5A5, 0x0123_4567, 0x89AB_CDEF] {
            for protection: UInt32 in [0, 0x40, 0x400, 0x5000, 0x5440, .max] {
                withPair(setup: { state in
                    for register in [
                        CRCCExtended_CCIPR1, CRCCExtended_CCIPR2, CRCCExtended_CCIPR3,
                        CRCCExtended_CCIPR4, CRCCExtended_CFGR, CRCCExtended_BDCR,
                    ] {
                        CRCCExtended_Set(&state, register, pattern)
                    }
                    CRCCExtended_Set(&state, CRCCExtended_CKPROTR, protection)
                    CRCCExtended_ScheduleRead(
                        &state, CRCCExtended_CCIPR1, 4, CRCCExtended_CCIPR1, 0xFFFF_FFFF, ~pattern)
                    CRCCExtended_ScheduleRead(
                        &state, CRCCExtended_CCIPR2, 3, CRCCExtended_CCIPR2, 0xFFFF_FFFF, ~pattern)
                    CRCCExtended_ScheduleRead(&state, CRCCExtended_BDCR, 2, CRCCExtended_BDCR, 0x300, 0x200)
                }) { actual, reference in compareReadback(actual, reference) }
            }
        }
    }

    func testProtectionStopAndKernelStopOperationsMatchC() {
        for protection: UInt32 in [0, 1, 2, 3, 0x8000_0001, .max] {
            withPair(setup: { state in
                CRCCExtended_Set(&state, CRCCExtended_CKPROTR, 0xA5A5_5A5A)
                CRCCExtended_Set(&state, CRCCExtended_CFGR, 0xAA55_55AA)
            }) { actual, reference in
                var rcc = actual.rcc
                rcc.enableClockProtection(protection)
                CRCCExtended_EnableClockProtection(&reference.storage, protection)
                for stop: UInt32 in [0, 0x40] {
                    for kernel: UInt32 in [0, 0x80] {
                        rcc.configureWakeUpStopClock(stop)
                        CRCCExtended_ConfigureWakeupStopClock(&reference.storage, stop)
                        rcc.configureKernelWakeUpStopClock(kernel)
                        CRCCExtended_ConfigureKernelWakeupStopClock(&reference.storage, kernel)
                    }
                }
                rcc.disableClockProtection(protection)
                CRCCExtended_DisableClockProtection(&reference.storage, protection)
            }
        }
    }

    func testLSECSSInterruptCallbackObservesClearedRCCAndUnchangedEXTIPending() {
        for pending: UInt32 in [0, 0x200, 0xFFFF_FFFF] {
            withPair(setup: { state in
                CRCCExtended_Set(&state, CRCCExtended_BDCR, 0xA513)
                CRCCExtended_Set(&state, CRCCExtended_CIER, 0xA555)
                CRCCExtended_Set(&state, CRCCExtended_CIFR, pending)
                CRCCExtended_Set(&state, CRCCExtended_EXTI_RTSR1, 0x8000_0000)
                CRCCExtended_Set(&state, CRCCExtended_EXTI_IMR1, 3)
                CRCCExtended_Set(&state, CRCCExtended_EXTI_PR1, 0x40001)
            }) { actual, reference in
                var rcc = actual.rcc
                rcc.enableLSECSS()
                CRCCExtended_EnableLSECSS(&reference.storage)
                rcc.enableLSECSSInterrupt()
                CRCCExtended_EnableLSECSSInterrupt(&reference.storage)
                rcc.handleLSECSSInterrupt {
                    CRCCExtended_RecordCallback(&actual.storage, CRCCExtended_LSECSSCallback, 0)
                }
                CRCCExtended_HandleLSECSSInterrupt(&reference.storage)
                rcc.handleLSECSSInterrupt {
                    CRCCExtended_RecordCallback(&actual.storage, CRCCExtended_LSECSSCallback, 0)
                }
                CRCCExtended_HandleLSECSSInterrupt(&reference.storage)
                rcc.disableLSECSS()
                CRCCExtended_DisableLSECSS(&reference.storage)
                XCTAssertEqual(actual.storage.callbackCount, pending & 0x200 != 0 ? 1 : 0)
                XCTAssertEqual(CRCCExtended_Get(&actual.storage, CRCCExtended_EXTI_PR1), 0x40001)
            }
        }
    }

    func testEveryFrequencyMuxEncodingWithReadinessAndOutputGatingMatchesC() {
        // Direct reads inside the unchanged core frequency helpers bypass the
        // oracle hooks. Static fixtures compare the actual result and no-write
        // behavior; RCCPeripheralClockFrequencyTests covers full read order.
        for fixture in rccExtendedMuxFixtures where fixture.selection != .usbRef {
            let shift = fixture.mask.trailingZeroBitCount
            for encoded in UInt32(0)...(fixture.mask >> shift) {
                for gate in 0..<11 {
                    withPair(
                        setup: { state in
                            frequencyFixture(&state)
                            CRCCExtended_Set(
                                &state, RCCExtendedDifferentialIO.register(fixture.register), encoded << shift)
                            switch gate {
                            case 1: CRCCExtended_Set(&state, CRCCExtended_PLLCFGR, 0)
                            case 2: CRCCExtended_Set(&state, CRCCExtended_CR, 0)
                            case 3: state.rcc.CR &= ~UInt32(0x20)
                            case 4: state.rcc.CR &= ~UInt32(4)
                            case 5: state.rcc.CR &= ~UInt32(0x20000)
                            case 6: state.rcc.CR &= ~UInt32(0x2000)
                            case 7: state.rcc.CR &= ~UInt32(0x100)
                            case 8:
                                state.rcc.BDCR = 0
                                state.rcc.CSR = 0
                            case 9: state.rcc.CR &= ~UInt32(0x2A00_0000)
                            case 10:
                                state.hsi = 63_987_653
                                state.csi = 3_999_983
                                state.hse = 25_000_007
                                state.hsi48 = 47_999_999
                                state.lse = 32_769
                                state.lsi = 31_999
                                state.externalClock = 12_288_001
                            default: break
                            }
                        }, compareReads: false
                    ) { actual, reference in
                        compareFrequency(UInt32(fixture.selection.rawValue), actual, reference)
                    }
                }
            }
        }
    }

    func testAllFrequencyPLLSourceFractionAndHSIDividerPathsMatchC() {
        for pllSource in UInt32(0)...3 {
            for hsiDivider in UInt32(0)...3 {
                for fraction: UInt32 in [0, 1, 4095, 8191] {
                    for fixture in rccExtendedMuxFixtures where fixture.selection != .usbRef {
                        for (source, output) in fixture.sources where output != 0 {
                            withPair(
                                setup: { state in
                                    frequencyFixture(&state)
                                    state.rcc.CR = (state.rcc.CR & ~UInt32(0x18)) | (hsiDivider << 3)
                                    state.rcc.PLLCKSELR = 0x0040_4040 | pllSource
                                    state.rcc.PLL1FRACR = fraction << 3
                                    state.rcc.PLL2FRACR = ((fraction ^ 0x1234) & 0x1FFF) << 3
                                    state.rcc.PLL3FRACR = ((fraction ^ 0x07AB) & 0x1FFF) << 3
                                    CRCCExtended_Set(
                                        &state, RCCExtendedDifferentialIO.register(fixture.register), source)
                                }, compareReads: false
                            ) { actual, reference in
                                compareFrequency(UInt32(fixture.selection.rawValue), actual, reference)
                            }
                        }
                    }
                }
            }
        }
    }

    func testRTCFrequencyAllSourcesDivisorsAndReadinessMatchC() {
        for source: UInt32 in [0, 0x100, 0x200, 0x300] {
            for divider in UInt32(0)...63 {
                for ready in [false, true] {
                    withPair(
                        setup: { state in
                            frequencyFixture(&state)
                            state.rcc.BDCR = source | (ready ? 2 : 0)
                            state.rcc.CSR = ready ? 2 : 0
                            state.rcc.CFGR = divider << 8
                            if !ready { state.rcc.CR &= ~UInt32(0x20000) }
                        }, compareReads: false
                    ) { actual, reference in
                        compareFrequency(0x40000, actual, reference)
                    }
                }
            }
        }
    }

    func testFrequencyProtectionBusPrescalersNestedETHAndCLKPMatchC() {
        for source: UInt32 in [0, 8, 16, 24, 32, 56] {
            for cpre: UInt32 in [0, 7, 8, 10, 15] {
                for hpre: UInt32 in [0, 7, 8, 12, 15] {
                    withPair(
                        setup: { state in
                            frequencyFixture(&state)
                            state.rcc.CFGR = source
                            state.rcc.CDCFGR = cpre
                            state.rcc.BMCFGR = hpre
                            state.rcc.APBCFGR = 0x7654
                            state.rcc.CKPROTR = 0x5440
                        }, compareReads: false
                    ) { actual, reference in
                        for peripheral: UInt32 in [
                            1, 2, 4, 0x400, 0x800, 0x1000, 0x2000, 0x4000,
                            0x8000, 0x2000000, 0x4000000, 0x1000_0000, 0x2000_0000,
                        ] {
                            compareFrequency(peripheral, actual, reference)
                        }
                    }
                }
            }
        }
        for ckper in UInt32(0)...3 {
            for phy in UInt32(0)...1 {
                withPair(
                    setup: { state in
                        frequencyFixture(&state)
                        state.rcc.CCIPR1 = (ckper << 28) | (phy << 18) | 0x20000 | 0x0200_0000 | 0x0800_0000
                        state.rcc.CCIPR2 = 0x3000000 | 0x40
                        state.rcc.CCIPR3 = 0x400000 | 0x40000 | 0x400
                    }, compareReads: false
                ) { actual, reference in
                    for peripheral: UInt32 in [
                        8, 0x10, 0x80, 0x100, 0x20000, 0x80000, 0x100000, 0x400000, 0x800000, 0x1000000,
                    ] {
                        compareFrequency(peripheral, actual, reference)
                    }
                }
            }
        }
    }

    func testLTDCUnsupportedSelectorsAndUnknownSelectionBitsMatchC() {
        for ready in [false, true] {
            withPair(
                setup: { state in
                    frequencyFixture(&state)
                    if !ready { state.rcc.PLLCFGR &= ~UInt32(0x2000_0000) }
                }, compareReads: false
            ) { actual, reference in
                for peripheral: UInt32 in [0x10000, 0, 3, 0x0800_0000, .max] {
                    compareFrequency(peripheral, actual, reference)
                }
            }
        }
        withPair { actual, reference in
            XCTAssertEqual(
                configure(
                    .init(selection: [.ltdc, .init(rawValue: 1 << 63)], ltdcClockSelection: .max), actual, reference),
                .ok)
        }
    }
}
