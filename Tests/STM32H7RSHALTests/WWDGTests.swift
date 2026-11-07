import XCTest
@testable import STM32H7RSHAL

private enum WWDGAccess: Equatable {
    case read(WWDGRegister, UInt32), write(WWDGRegister, UInt32), callback(Int)
}

private final class WWDGTestIO: WWDGRegisterIO, WWDGConfigurationIO, WWDGCallbackIO {
    var registers: [WWDGRegister: UInt32] = [:]
    var words: [WWDGConfigurationWord: UInt32] = [.prescaler: 0, .window: 0x7F, .counter: 0x7F, .earlyWakeupMode: 0]
    var accesses: [WWDGAccess] = []
    var callbacks: [WWDGCallbackID: WWDGCallback] = [:]
    var context: UnsafeMutableRawPointer?
    var driver: WWDG<WWDGTestIO, WWDGTestIO> { .init(registers: self, configuration: self) }

    func read(_ register: WWDGRegister) -> UInt32 {
        let value = registers[register, default: 0]
        accesses.append(.read(register, value))
        return value
    }
    func write(_ register: WWDGRegister, value: UInt32) {
        accesses.append(.write(register, value))
        if register == .sr { registers[.sr, default: 0] &= value | ~UInt32(1) }
        else { registers[register] = value }
    }
    func read(_ word: WWDGConfigurationWord) -> UInt32 { words[word, default: 0] }
    func write(_ word: WWDGConfigurationWord, value: UInt32) { words[word] = value }
    func read(_ id: WWDGCallbackID) -> WWDGCallback? { callbacks[id] }
    func write(_ id: WWDGCallbackID, value: WWDGCallback?) { callbacks[id] = value }
    static func object(_ context: UnsafeMutableRawPointer?) -> WWDGTestIO {
        Unmanaged<WWDGTestIO>.fromOpaque(context!).takeUnretainedValue()
    }
}

final class WWDGTests: XCTestCase {
    func testInitWritesEnabledCounterBeforeWindowForAllPrescalersAndBoundaries() {
        for prescaler in WWDGPrescaler.allCases {
            for mode in [UInt32(0), 0x200] {
                for window in [UInt32(0x40), 0x41, 0x7E, 0x7F] {
                    for counter in [UInt32(0x40), 0x7F] {
                        let io = WWDGTestIO()
                        WWDGConfiguration(prescaler: prescaler.rawValue, window: window,
                            counter: counter, earlyWakeupMode: mode).store(in: io)
                        XCTAssertEqual(io.driver.initialize(mspInitialize: { _ in io.accesses.append(.callback(1)) }), .ok)
                        XCTAssertEqual(io.accesses, [.callback(1), .write(.cr, 0x80 | counter),
                            .write(.cfr, mode | prescaler.rawValue | window)])
                    }
                }
            }
        }
    }

    func testMSPChangesLiveConfigurationAndRefreshReadsLatestCounterWithoutWDGA() {
        let io = WWDGTestIO()
        let copy = io.driver
        XCTAssertEqual(io.driver.initialize(mspInitialize: { driver in
            WWDGConfiguration(prescaler: 0x3800, window: 0x51, counter: 0x73, earlyWakeupMode: 0x200)
                .store(in: driver.configuration)
            io.accesses.append(.callback(1))
        }), .ok)
        io.write(.counter, value: 0x65)
        XCTAssertEqual(copy.refresh(), .ok)
        XCTAssertEqual(io.accesses, [.callback(1), .write(.cr, 0xF3), .write(.cfr, 0x3A51), .write(.cr, 0x65)])
    }

    func testInterruptChecksEnableBeforeReadingFlagAndClearsBeforeRefreshCallback() {
        for enabled in [false, true] {
            for pending in [false, true] {
                let io = WWDGTestIO()
                let cfr: UInt32 = enabled ? 0x3A7F : 0x387F
                let sr: UInt32 = pending ? 0x1234_0001 : 0x1234_0000
                io.registers = [.cfr: cfr, .sr: sr]
                io.driver.handleInterrupt { driver in
                    XCTAssertEqual(io.registers[.sr], 0x1234_0000)
                    io.accesses.append(.callback(0))
                    io.write(.counter, value: 0x6A)
                    XCTAssertEqual(driver.refresh(), .ok)
                }
                var expected: [WWDGAccess] = [.read(.cfr, cfr)]
                if enabled {
                    expected.append(.read(.sr, sr))
                    if pending { expected += [.write(.sr, 0xFFFF_FFFE), .callback(0), .write(.cr, 0x6A)] }
                }
                XCTAssertEqual(io.accesses, expected)
            }
        }
    }

    func testMacroHelpersMatchMasksAndWriteZeroToClearValue() {
        let io = WWDGTestIO()
        io.registers = [.cr: 0x1234_005A, .cfr: 0x5678_007F, .sr: 3]
        let driver = io.driver
        driver.enable()
        driver.enableInterrupt()
        XCTAssertTrue(driver.getInterruptSource())
        XCTAssertTrue(driver.getInterrupt())
        driver.clearInterrupt()
        XCTAssertFalse(driver.getFlag())
        XCTAssertTrue(driver.getFlag(0))
        XCTAssertTrue(driver.getInterruptSource(0))
        XCTAssertEqual(io.accesses, [
            .read(.cr, 0x1234_005A), .write(.cr, 0x1234_00DA),
            .read(.cfr, 0x5678_007F), .write(.cfr, 0x5678_027F), .read(.cfr, 0x5678_027F),
            .read(.sr, 3), .write(.sr, 0xFFFF_FFFE), .read(.sr, 2), .read(.sr, 2), .read(.cfr, 0x5678_027F),
        ])
    }

    func testRegisteredDefaultsFillOnlyNilSlotsOnEveryInitialization() {
        let io = WWDGTestIO()
        io.context = Unmanaged.passUnretained(io).toOpaque()
        let defaults = WWDGCallbackDefaults(
            earlyWakeup: { WWDGTestIO.object($0).accesses.append(.callback(0)) },
            mspInitialize: { WWDGTestIO.object($0).accesses.append(.callback(1)) })
        let custom: WWDGCallback = { WWDGTestIO.object($0).accesses.append(.callback(2)) }
        let driver = WWDGRegistered(core: io.driver, callbacks: io, defaults: defaults)
        XCTAssertEqual(driver.registerCallback(id: .earlyWakeup, callback: custom), .ok)
        XCTAssertEqual(driver.initialize(), .ok)
        XCTAssertEqual(driver.initialize(), .ok)
        XCTAssertEqual(io.accesses.filter { $0 == .callback(1) }.count, 2)
        io.registers[.cfr] = 0x200
        io.registers[.sr] = 1
        driver.handleInterrupt()
        XCTAssertEqual(io.accesses.last, .callback(2))
        XCTAssertEqual(driver.registerCallback(id: UInt32(2), callback: custom), .error)
        XCTAssertEqual(driver.registerCallback(id: .earlyWakeup, callback: nil), .error)
        XCTAssertEqual(driver.unregisterCallback(id: UInt32.max), .error)
        io.registers[.sr] = 1
        driver.handleInterrupt()
        XCTAssertEqual(io.accesses.last, .callback(2))
        XCTAssertEqual(driver.unregisterCallback(id: .earlyWakeup), .ok)
        io.registers[.sr] = 1
        driver.handleInterrupt()
        XCTAssertEqual(io.accesses.last, .callback(0))
        XCTAssertEqual(driver.unregisterCallback(id: .mspInitialize), .ok)
        XCTAssertEqual(driver.refresh(), .ok)
    }
}
