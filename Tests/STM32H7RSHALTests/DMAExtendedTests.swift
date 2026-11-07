import XCTest
@testable import STM32H7RSHAL

private enum DMAExtendedEvent: Equatable {
    case read(DMARegister), write(DMARegister, UInt32)
    case handleRead(DMAHandleWord), handleWrite(DMAHandleWord, UInt32), tick
}

private final class DMAExtendedIO: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
    var channel = DMAChannel(controller: .hpdma1, index: 15)
    var registers: [DMARegister: UInt32] = [:]
    var words: [DMAHandleWord: UInt32] = [.state: 1]
    var events: [DMAExtendedEvent] = []
    var ticks: UInt32 = 0
    var tickCalls: UInt32 = 0
    var onTick: ((DMAExtendedIO) -> Void)?
    var context: UnsafeMutableRawPointer? { nil }
    var driver: DMA<DMAExtendedIO, DMAExtendedIO, DMAExtendedIO, DMAExtendedIO> {
        .init(registers: self, handle: self, callbacks: self, memory: self)
    }
    func read(_ register: DMARegister) -> UInt32 {
        events.append(.read(register)); return registers[register, default: 0]
    }
    func write(_ register: DMARegister, value: UInt32) {
        events.append(.write(register, value)); registers[register] = value
    }
    func read(_ word: DMAHandleWord) -> UInt32 {
        events.append(.handleRead(word)); return words[word, default: 0]
    }
    func write(_ word: DMAHandleWord, value: UInt32) {
        events.append(.handleWrite(word, value)); words[word] = value
    }
    func read(_ id: DMACallbackID) -> DMACallback? { XCTFail("Unexpected callback read"); return nil }
    func write(_ id: DMACallbackID, value: DMACallback?) { XCTFail("Unexpected callback write") }
    func readParent() -> UnsafeMutableRawPointer? { XCTFail("Unexpected parent read"); return nil }
    func writeParent(_ value: UnsafeMutableRawPointer?) { XCTFail("Unexpected parent write") }
    func read32(at address: UInt32) -> UInt32 { XCTFail("Unexpected queue access"); return 0 }
    func write32(at address: UInt32, value: UInt32) { XCTFail("Unexpected queue access") }
    func getTick() -> UInt32 {
        events.append(.tick)
        let result = ticks
        ticks &+= 1; tickCalls += 1; onTick?(self)
        return result
    }
}

final class DMAExtendedTests: XCTestCase {
    func testNilConfigurationsHaveNoSideEffectsEvenOnNon2DChannel() {
        let io = DMAExtendedIO()
        io.channel = .init(controller: .gpdma1, index: 0)
        XCTAssertEqual(io.driver.configureDataHandling(nil), .error)
        XCTAssertEqual(io.driver.configureTrigger(nil), .error)
        XCTAssertEqual(io.driver.configureRepeatBlock(nil), .error)
        XCTAssertEqual(io.events, [])
    }

    func testDataHandlingWritesFullCMSISMaskIncludingGPDMAWordExchange() {
        for controller in [DMAController.gpdma1, .hpdma1] {
            for alignment: UInt32 in [0, 0x800, 0x1000] {
                for exchange in UInt32(0)..<16 {
                    let bits = ((exchange & 1) << 13) | ((exchange & 14) << 25)
                    let io = DMAExtendedIO()
                    io.channel = .init(controller: controller, index: 0)
                    io.registers[.ctr1] = .max; io.words[.lock] = 1; io.words[.errorCode] = 0xAB
                    XCTAssertEqual(io.driver.configureDataHandling(.init(alignment: alignment, exchange: bits)), .ok)
                    XCTAssertEqual(io.events, [.handleRead(.state), .read(.ctr1), .write(.ctr1, 0xE3FF_C7FF | alignment | bits)])
                    XCTAssertEqual(io.words[.lock], 1); XCTAssertEqual(io.words[.errorCode], 0xAB)
                }
            }
        }
    }

    func testAllTriggerModesPolaritiesAndSelectionsPreserveOtherFields() {
        for mode in UInt32(0)..<4 {
            for polarity in UInt32(0)..<3 {
                for selection in UInt32(0)...55 {
                    let io = DMAExtendedIO()
                    io.registers[.ctr2] = .max
                    let encoded = (polarity << 24) | (selection << 16) | (mode << 14)
                    XCTAssertEqual(io.driver.configureTrigger(.init(mode: mode << 14, polarity: polarity << 24,
                                                                    selection: selection)), .ok)
                    XCTAssertEqual(io.events, [.handleRead(.state), .read(.ctr2), .write(.ctr2, 0xFCC0_3FFF | encoded)])
                }
            }
        }
    }

    func testRepeatBlockSignBitsExtremesAndWriteOrderOverwriteByteCount() {
        for count: UInt32 in [1, 2, 2047] {
            for source: Int32 in [-8191, 0, 8191] {
                for destination: Int32 in [-8191, 0, 8191] {
                    for blockSource: Int32 in [-65535, 0, 65535] {
                        for blockDestination: Int32 in [-65535, 0, 65535] {
                            let io = DMAExtendedIO()
                            io.registers[.cbr1] = .max
                            let configuration = DMARepeatBlockConfiguration(repeatCount: count, sourceAddressOffset: source,
                                destinationAddressOffset: destination, blockSourceAddressOffset: blockSource,
                                blockDestinationAddressOffset: blockDestination)
                            var flags: UInt32 = 0
                            if source < 0 { flags |= 1 << 28 }
                            if destination < 0 { flags |= 1 << 29 }
                            if blockSource < 0 { flags |= 1 << 30 }
                            if blockDestination < 0 { flags |= 1 << 31 }
                            XCTAssertEqual(io.driver.configureRepeatBlock(configuration), .ok)
                            XCTAssertEqual(io.events, [.handleRead(.state),
                                .write(.ctr3, (UInt32(abs(destination)) << 16) | UInt32(abs(source))),
                                .write(.cbr2, (UInt32(abs(blockDestination)) << 16) | UInt32(abs(blockSource))),
                                .write(.cbr1, flags | ((count - 1) << 16))])
                        }
                    }
                }
            }
        }
    }

    func testConfigurationsRejectEveryNonReadyStateAndOverwriteErrorThenUnlock() {
        for state: UInt32 in [0, 2, 3, 4, 5, .max] {
            for operation in 0..<3 {
                let io = DMAExtendedIO()
                io.words = [.state: state, .lock: 1, .errorCode: .max]
                let status: HALStatus
                switch operation {
                case 0: status = io.driver.configureDataHandling(.init())
                case 1: status = io.driver.configureTrigger(.init())
                default: status = io.driver.configureRepeatBlock(.init())
                }
                XCTAssertEqual(status, .error)
                XCTAssertEqual(io.events, [.handleRead(.state), .handleWrite(.errorCode, 0x40), .handleWrite(.lock, 0)])
                XCTAssertEqual(io.words[.state], state)
            }
        }
    }

    func testSuspendSuccessKeepsLockErrorAndPendingFlag() {
        let io = DMAExtendedIO()
        io.words = [.state: 2, .lock: 1, .errorCode: 0xA5]
        io.registers[.ccr] = 0x4001; io.registers[.csr] = 0x2000
        XCTAssertEqual(io.driver.suspend(getTick: io.getTick), .ok)
        XCTAssertEqual(io.events, [.tick, .handleRead(.state), .read(.ccr), .write(.ccr, 0x4005),
                                   .read(.csr), .handleWrite(.state, 5)])
        XCTAssertEqual(io.words[.lock], 1); XCTAssertEqual(io.words[.errorCode], 0xA5)
        XCTAssertEqual(io.registers[.csr], 0x2000)
    }

    func testSuspendFailureStillReadsInitialTickBeforeState() {
        for state: UInt32 in [0, 1, 3, 4, 5, .max] {
            let io = DMAExtendedIO()
            io.words = [.state: state, .lock: 1, .errorCode: .max]
            XCTAssertEqual(io.driver.suspend(getTick: io.getTick), .error)
            XCTAssertEqual(io.events, [.tick, .handleRead(.state), .handleWrite(.errorCode, 0x20), .handleWrite(.lock, 0)])
            XCTAssertEqual(io.words[.state], state)
        }
    }

    func testSuspendTimeoutIsStrictGreaterThanFiveWrapsAndDoesNotRecheck() {
        for initialTick: UInt32 in [0, .max - 2] {
            for readyTickCall: UInt32 in [6, 7] {
                let io = DMAExtendedIO()
                io.ticks = initialTick; io.words = [.state: 2, .lock: 1, .errorCode: 0x81]
                io.onTick = { if $0.tickCalls == readyTickCall { $0.registers[.csr] = 0x2000 } }
                let status = io.driver.suspend(getTick: io.getTick)
                if readyTickCall == 6 {
                    XCTAssertEqual(status, .ok); XCTAssertEqual(io.tickCalls, 6)
                    XCTAssertEqual(io.words[.state], 5); XCTAssertEqual(io.words[.lock], 1)
                } else {
                    XCTAssertEqual(status, .error); XCTAssertEqual(io.tickCalls, 7)
                    XCTAssertEqual(io.words[.errorCode], 0x91); XCTAssertEqual(io.words[.state], 3)
                    XCTAssertEqual(io.words[.lock], 0)
                }
            }
        }
        // The sixth elapsed tick already exceeds five. A flag arriving on that
        // tick must not turn the timeout into success: there is no second read.
        let io = DMAExtendedIO()
        io.words = [.state: 2, .lock: 1, .errorCode: 1]
        io.onTick = { if $0.tickCalls == 7 { $0.registers[.csr] = 0x2000 } }
        XCTAssertEqual(io.driver.suspend(getTick: io.getTick), .error)
        XCTAssertEqual(Array(io.events.suffix(5)), [.tick, .handleRead(.errorCode), .handleWrite(.errorCode, 17),
                                                   .handleWrite(.state, 3), .handleWrite(.lock, 0)])
    }

    func testSuspendInterruptDoesNotChangeStateOrUnlockOnSuccess() {
        let io = DMAExtendedIO()
        io.words = [.state: 2, .lock: 1, .errorCode: 3]; io.registers[.ccr] = 0x100
        XCTAssertEqual(io.driver.suspendInterrupt(), .ok)
        XCTAssertEqual(io.events, [.handleRead(.state), .read(.ccr), .write(.ccr, 0x2104)])
        XCTAssertEqual(io.words[.state], 2); XCTAssertEqual(io.words[.lock], 1)
    }

    func testResumeReadsClearRegisterAndRetainsUnrelatedPendingClearBits() {
        let io = DMAExtendedIO()
        io.words = [.state: 5, .lock: 1, .errorCode: 0xA5]
        io.registers[.ccr] = 0x4405; io.registers[.cfcr] = 0x4500
        XCTAssertEqual(io.driver.resume(), .ok)
        XCTAssertEqual(io.events, [.handleRead(.state), .read(.ccr), .write(.ccr, 0x4401),
            .read(.cfcr), .write(.cfcr, 0x6500), .handleWrite(.state, 2)])
        XCTAssertEqual(io.words[.lock], 1); XCTAssertEqual(io.words[.errorCode], 0xA5)
    }

    func testNonblockingSuspendAndResumeErrorSideEffects() {
        for state: UInt32 in [0, 1, 2, 3, 4, 5, .max] {
            for resume in [false, true] where state != (resume ? 5 : 2) {
                let io = DMAExtendedIO()
                io.words = [.state: state, .lock: 1, .errorCode: .max]
                XCTAssertEqual(resume ? io.driver.resume() : io.driver.suspendInterrupt(), .error)
                XCTAssertEqual(io.events, [.handleRead(.state), .handleWrite(.errorCode, 0x20), .handleWrite(.lock, 0)])
                XCTAssertEqual(io.words[.state], state)
            }
        }
    }

    func testFIFOUsesEightBitCMSISMaskForBothControllers() {
        for controller in [DMAController.gpdma1, .hpdma1] {
            for level in UInt32(0)...511 {
                let io = DMAExtendedIO()
                io.channel = .init(controller: controller, index: 15)
                io.registers[.csr] = 0xFE00_FFFF | (level << 16)
                XCTAssertEqual(io.driver.getFIFOLevel(), level & 255)
                XCTAssertEqual(io.events, [.read(.csr)])
            }
        }
    }
}
