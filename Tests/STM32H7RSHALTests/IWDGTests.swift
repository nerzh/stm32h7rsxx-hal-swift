import XCTest
@testable import STM32H7RSHAL

private enum IWDGAccess: Equatable {
    case read(IWDGRegister, UInt32), write(IWDGRegister, UInt32), tick(UInt32), callback(Int)
}

private final class IWDGTestIO: IWDGRegisterIO, IWDGConfigurationIO, IWDGCallbackIO {
    var registers: [IWDGRegister: UInt32] = [.winr: 0xFFF]
    var words: [IWDGConfigurationWord: UInt32] = [.prescaler: 0, .reload: 0x456, .window: 0xFFF, .earlyWakeup: 0]
    var statusReads: [UInt32] = []
    var ticks: [UInt32] = []
    var accesses: [IWDGAccess] = []
    var markWindowUpdate = false
    var callbacks: [IWDGCallbackID: IWDGCallback] = [:]
    var context: UnsafeMutableRawPointer?
    var driver: IWDG<IWDGTestIO, IWDGTestIO> { .init(registers: self, configuration: self) }

    func read(_ register: IWDGRegister) -> UInt32 {
        let value = register == .sr && !statusReads.isEmpty ? statusReads.removeFirst() : registers[register, default: 0]
        accesses.append(.read(register, value))
        return value
    }
    func write(_ register: IWDGRegister, value: UInt32) {
        accesses.append(.write(register, value))
        registers[register] = value
        if register == .ewcr {
            if value & 0x4000 != 0 { registers[.sr, default: 0] &= ~UInt32(0x4000) }
            registers[.ewcr] = value & ~UInt32(0x4000)
        }
        if register == .winr && markWindowUpdate { registers[.sr, default: 0] |= 4 }
    }
    func read(_ word: IWDGConfigurationWord) -> UInt32 { words[word, default: 0] }
    func write(_ word: IWDGConfigurationWord, value: UInt32) { words[word] = value }
    func getTick() -> UInt32 {
        precondition(!ticks.isEmpty)
        let value = ticks.removeFirst()
        accesses.append(.tick(value))
        return value
    }
    func read(_ id: IWDGCallbackID) -> IWDGCallback? { callbacks[id] }
    func write(_ id: IWDGCallbackID, value: IWDGCallback?) { callbacks[id] = value }
    static func object(_ context: UnsafeMutableRawPointer?) -> IWDGTestIO {
        Unmanaged<IWDGTestIO>.fromOpaque(context!).takeUnretainedValue()
    }
}

final class IWDGTests: XCTestCase {
    func testInitKeysRegistersBothWindowPathsAndEveryPrescaler() {
        for prescaler in IWDGPrescaler.allCases {
            for earlyWakeup in [UInt32(0), 1, 0xFFF] {
                for window in [UInt32(0xFFF), 0x123] {
                    let io = IWDGTestIO()
                    io.words[.prescaler] = prescaler.rawValue
                    io.words[.earlyWakeup] = earlyWakeup
                    io.words[.window] = window
                    io.markWindowUpdate = true
                    io.ticks = [11, 12]
                    XCTAssertEqual(io.driver.initialize(getTick: io.getTick,
                        mspInitialize: { _ in io.accesses.append(.callback(1)) }), .ok)
                    let ewiValue: UInt32 = earlyWakeup == 0 ? 0x4000 : 0xC000 | earlyWakeup
                    XCTAssertEqual(io.accesses, [.callback(1), .write(.kr, 0xCCCC), .write(.kr, 0x5555),
                        .write(.pr, prescaler.rawValue), .write(.rlr, 0x456), .tick(11), .read(.sr, 0),
                        .write(.ewcr, ewiValue), .tick(12), .read(.sr, 0), .read(.winr, 0xFFF),
                        window == 0xFFF ? .write(.kr, 0xAAAA) : .write(.winr, 0x123)])
                    if window != 0xFFF { XCTAssertEqual(io.registers[.sr], 4, "No wait follows the WINR write") }
                }
            }
        }
    }

    func testMSPConfigurationChangesAreReadAfterValidationAndBeforeHardwareWrites() {
        let io = IWDGTestIO()
        io.ticks = [0, 0]
        XCTAssertEqual(io.driver.initialize(getTick: io.getTick, mspInitialize: { driver in
            IWDGConfiguration(prescaler: 8, reload: 0xABC, window: 0xDEF, earlyWakeup: 0x123).store(in: driver.configuration)
            io.accesses.append(.callback(1))
        }), .ok)
        XCTAssertEqual(io.accesses, [.callback(1), .write(.kr, 0xCCCC), .write(.kr, 0x5555),
            .write(.pr, 8), .write(.rlr, 0xABC), .tick(0), .read(.sr, 0), .write(.ewcr, 0xC123),
            .tick(0), .read(.sr, 0), .read(.winr, 0xFFF), .write(.winr, 0xDEF)])
    }

    func testTimeoutFormulaKeepsLSIDivisionAndStartupRoundingOrder() {
        XCTAssertEqual(IWDGTiming().updateTimeout, 4097)
        XCTAssertEqual(IWDGTiming(lsiFrequency: 32_001).updateTimeout, 4097)
        XCTAssertEqual(IWDGTiming(lsiFrequency: 32_768).updateTimeout, 4001)
        XCTAssertEqual(IWDGTiming(lsiFrequency: 128).updateTimeout, 1_024_001)
        XCTAssertEqual(IWDGTiming(lsiFrequency: .max).updateTimeout, 1)
        XCTAssertEqual(IWDGTiming(lsiStartupMicroseconds: 1000).updateTimeout, 4098)
    }

    func testBothWaitsUseStrictTimeoutSecondCheckAndWrappingTicks() {
        for stage in 0...1 {
            for recovers in [false, true] {
                for start in [UInt32(0), UInt32.max - 100] {
                    let io = IWDGTestIO()
                    let pending: UInt32 = stage == 0 ? 2 : 8
                    io.statusReads = (stage == 0 ? [] : [0]) + [pending, pending, recovers ? 0 : pending]
                    io.ticks = (stage == 0 ? [] : [17]) + [start, start &+ 4097, start &+ 4098]
                    if stage == 0 && recovers { io.ticks.append(50) }
                    XCTAssertEqual(io.driver.initialize(getTick: io.getTick), recovers ? .ok : .timeout)
                    var expected: [IWDGAccess] = [.write(.kr, 0xCCCC), .write(.kr, 0x5555), .write(.pr, 0), .write(.rlr, 0x456)]
                    if stage == 1 { expected += [.tick(17), .read(.sr, 0), .write(.ewcr, 0x4000)] }
                    expected += [.tick(start), .read(.sr, pending), .tick(start &+ 4097),
                                 .read(.sr, pending), .tick(start &+ 4098), .read(.sr, recovers ? 0 : pending)]
                    if recovers {
                        expected.append(.read(.sr, 0))
                        if stage == 0 { expected += [.write(.ewcr, 0x4000), .tick(50), .read(.sr, 0)] }
                        expected += [.read(.winr, 0xFFF), .write(.kr, 0xAAAA)]
                    }
                    XCTAssertEqual(io.accesses, expected)
                }
            }
        }
    }

    func testFirstWaitOnlyTestsRVUButSecondWaitTestsEveryUpdateFlag() {
        for flag in [UInt32(1), 4, 8] {
            let io = IWDGTestIO()
            io.registers[.sr] = flag
            io.ticks = [0, 0, 4098]
            XCTAssertEqual(io.driver.initialize(getTick: io.getTick), .timeout)
            XCTAssertEqual(io.accesses, [.write(.kr, 0xCCCC), .write(.kr, 0x5555), .write(.pr, 0), .write(.rlr, 0x456),
                .tick(0), .read(.sr, flag), .write(.ewcr, 0x4000), .tick(0), .read(.sr, flag),
                .tick(4098), .read(.sr, flag)])
        }
    }

    func testIRQIgnoresEWIEAndClearsBeforeReentrantRefresh() {
        for ewcr in [UInt32(0), 0x8000, 0x8001, 0xFFFF] {
            let io = IWDGTestIO()
            io.registers[.sr] = 0x410F
            io.registers[.ewcr] = ewcr
            let copy = io.driver
            io.driver.handleInterrupt { driver in
                XCTAssertEqual(io.registers[.sr], 0x10F)
                io.accesses.append(.callback(0))
                XCTAssertEqual(driver.refresh(), .ok)
                XCTAssertEqual(copy.getActiveStatus(), 0x100)
            }
            XCTAssertEqual(io.accesses, [.read(.sr, 0x410F), .read(.ewcr, ewcr),
                .write(.ewcr, ewcr | 0x4000), .callback(0), .write(.kr, 0xAAAA), .read(.sr, 0x10F)])
        }
        let io = IWDGTestIO()
        io.registers[.sr] = 0x100
        io.driver.handleInterrupt { _ in XCTFail("EWIF was not set") }
        XCTAssertEqual(io.accesses, [.read(.sr, 0x100)])
    }

    func testKeyHelpersAndActiveStatusRetainRawCValues() {
        let io = IWDGTestIO()
        io.driver.start(); io.driver.enableWriteAccess(); io.driver.disableWriteAccess()
        XCTAssertEqual(io.driver.refresh(), .ok)
        XCTAssertEqual(io.accesses, [.write(.kr, 0xCCCC), .write(.kr, 0x5555), .write(.kr, 0), .write(.kr, 0xAAAA)])
        for value in [UInt32(0), 0x400F, 0x100, .max] {
            io.registers[.sr] = value
            XCTAssertEqual(io.driver.getActiveStatus(), value & 0x100)
        }
    }

    func testRegisteredDefaultsPreserveCallbacksAndMSPRunsOnEveryInit() {
        let io = IWDGTestIO()
        io.context = Unmanaged.passUnretained(io).toOpaque()
        let defaults = IWDGCallbackDefaults(
            earlyWakeup: { IWDGTestIO.object($0).accesses.append(.callback(0)) },
            mspInitialize: { IWDGTestIO.object($0).accesses.append(.callback(1)) })
        let custom: IWDGCallback = { IWDGTestIO.object($0).accesses.append(.callback(2)) }
        let driver = IWDGRegistered(core: io.driver, callbacks: io, defaults: defaults)
        XCTAssertEqual(driver.registerCallback(id: .mspInitialize, callback: custom), .ok)
        io.ticks = [0, 0, 0, 0]
        XCTAssertEqual(driver.initialize(getTick: io.getTick), .ok)
        XCTAssertEqual(driver.initialize(getTick: io.getTick), .ok)
        XCTAssertEqual(io.accesses.filter { $0 == .callback(2) }.count, 2)
        XCTAssertFalse(io.accesses.contains(.callback(1)))
        io.registers[.sr] = 0x4000
        driver.handleInterrupt()
        XCTAssertEqual(io.accesses.last, .callback(0))
        XCTAssertEqual(driver.registerCallback(id: .earlyWakeup, callback: custom), .ok)
        XCTAssertEqual(driver.registerCallback(id: UInt32.max, callback: custom), .error)
        XCTAssertEqual(driver.registerCallback(id: .earlyWakeup, callback: nil), .error)
        io.registers[.sr] = 0x4000
        driver.handleInterrupt()
        XCTAssertEqual(io.accesses.last, .callback(2))
        XCTAssertEqual(driver.unregisterCallback(id: UInt32(2)), .error)
        XCTAssertEqual(driver.unregisterCallback(id: .earlyWakeup), .ok)
        io.registers[.sr] = 0x4000
        driver.handleInterrupt()
        XCTAssertEqual(io.accesses.last, .callback(0))
    }
}
