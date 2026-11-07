import XCTest
@testable import STM32H7RSHAL

private enum DMACoreAccess: Equatable {
    case read(DMARegister), write(DMARegister, UInt32)
    case handle(DMAHandleWord, UInt32), memory(UInt32, UInt32)
    case callbackRead(DMACallbackID), callbackWrite(DMACallbackID, Bool), callback(DMACallbackID)
    case parentRead, parentWrite(UInt), tick(UInt32)
}

private struct DMACoreCallbackSnapshot: Equatable {
    var id: DMACallbackID
    var state, lock, error, ccr, csr, cbr1, queueState: UInt32
}

private func dmaCoreComplete(_ context: UnsafeMutableRawPointer?) { dmaCoreIO(context).record(.transferComplete) }
private func dmaCoreHalf(_ context: UnsafeMutableRawPointer?) { dmaCoreIO(context).record(.halfTransfer) }
private func dmaCoreError(_ context: UnsafeMutableRawPointer?) { dmaCoreIO(context).record(.error) }
private func dmaCoreAbort(_ context: UnsafeMutableRawPointer?) { dmaCoreIO(context).record(.abort) }
private func dmaCoreSuspend(_ context: UnsafeMutableRawPointer?) { dmaCoreIO(context).record(.suspend) }
private func dmaCoreIO(_ context: UnsafeMutableRawPointer?) -> DMACoreIO {
    Unmanaged<DMACoreIO>.fromOpaque(context!).takeUnretainedValue()
}

private final class DMACoreIO: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
    let channel: DMAChannel
    var registers: [DMARegister: UInt32] = [.csr: 1]
    var words: [DMAHandleWord: UInt32] = [:]
    var ram: [UInt32: UInt32] = [:]
    var callbackSlots: [DMACallbackID: DMACallback] = [:]
    var parent: UnsafeMutableRawPointer?
    var accesses: [DMACoreAccess] = []
    var snapshots: [DMACoreCallbackSnapshot] = []
    var scriptedReads: [DMARegister: [UInt32]] = [:]
    var onRead: ((DMARegister) -> Void)?
    var onCallback: ((DMACallbackID) -> Void)?
    var onTick: ((UInt32) -> Void)?
    var automaticReset = true
    var automaticSuspend = true
    var tick: UInt32 = 0
    var tickStep: UInt32 = 1
    var tickCalls = 0

    init(controller: DMAController = .gpdma1, channel: Int = 0) {
        self.channel = DMAChannel(controller: controller, index: channel)
    }

    var dma: DMA<DMACoreIO, DMACoreIO, DMACoreIO, DMACoreIO> {
        DMA(registers: self, handle: self, callbacks: self, memory: self)
    }
    var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
    var mmio: [DMACoreAccess] {
        accesses.filter { if case .read = $0 { return true }; if case .write = $0 { return true }; return false }
    }
    var writes: [DMACoreAccess] { accesses.filter { if case .write = $0 { return true }; return false } }

    func read(_ register: DMARegister) -> UInt32 {
        accesses.append(.read(register))
        onRead?(register)
        if scriptedReads[register]?.isEmpty == false { return scriptedReads[register]!.removeFirst() }
        return registers[register, default: 0]
    }
    func write(_ register: DMARegister, value: UInt32) {
        accesses.append(.write(register, value))
        if register == .cfcr {
            registers[.csr, default: 0] &= ~value
        } else if register == .ccr {
            if value & 2 != 0, automaticReset {
                registers[register] = value & ~UInt32(7)
                registers[.csr, default: 0] |= 1
                return
            }
            if value & 4 != 0, automaticSuspend { registers[.csr, default: 0] |= 0x2000 }
        }
        registers[register] = value
    }
    func read(_ word: DMAHandleWord) -> UInt32 { words[word, default: 0] }
    func write(_ word: DMAHandleWord, value: UInt32) {
        accesses.append(.handle(word, value))
        words[word] = value
    }
    func read32(at address: UInt32) -> UInt32 { ram[address, default: 0] }
    func write32(at address: UInt32, value: UInt32) {
        accesses.append(.memory(address, value))
        ram[address] = value
    }
    func read(_ id: DMACallbackID) -> DMACallback? {
        accesses.append(.callbackRead(id))
        return callbackSlots[id]
    }
    func write(_ id: DMACallbackID, value: DMACallback?) {
        accesses.append(.callbackWrite(id, value != nil))
        callbackSlots[id] = value
    }
    func readParent() -> UnsafeMutableRawPointer? { accesses.append(.parentRead); return parent }
    func writeParent(_ value: UnsafeMutableRawPointer?) {
        accesses.append(.parentWrite(value.map { UInt(bitPattern: $0) } ?? 0))
        parent = value
    }
    func getTick() -> UInt32 {
        let value = tick
        tick &+= tickStep
        tickCalls += 1
        accesses.append(.tick(value))
        onTick?(value)
        return value
    }
    func installCallbacks() {
        callbackSlots = [.transferComplete: dmaCoreComplete, .halfTransfer: dmaCoreHalf,
                         .error: dmaCoreError, .abort: dmaCoreAbort, .suspend: dmaCoreSuspend]
    }
    func record(_ id: DMACallbackID) {
        accesses.append(.callback(id))
        snapshots.append(.init(id: id, state: words[.state, default: 0], lock: words[.lock, default: 0],
                               error: words[.errorCode, default: 0], ccr: registers[.ccr, default: 0],
                               csr: registers[.csr, default: 0], cbr1: registers[.cbr1, default: 0],
                               queueState: ram[words[.queueAddress, default: 0] &+ 12, default: 0]))
        onCallback?(id)
    }
    func prepareTransfer(mode: UInt32 = 0) {
        words = [.state: 2, .lock: 1, .mode: mode, .queueAddress: 0x2400_1000]
        ram[0x2400_100C] = 2
        registers[.ccr] = 1
        registers[.csr] = 0
    }
}

final class DMACoreTests: XCTestCase {
    func testInitializeAllControllersAndChannelsUsesExactRawMasksAnd2DOrder() {
        for controller in [DMAController.gpdma1, .hpdma1] {
            for channel in 0..<16 {
                let io = DMACoreIO(controller: controller, channel: channel)
                io.registers[.ccr] = 0xFFFF_FFF8
                io.registers[.ctr2] = 0xFFFF_FFFF
                io.words[.lock] = 1
                io.installCallbacks()
                let config = DMAConfiguration(request: 109, blockHardwareRequest: 0x800, direction: 0x400,
                    sourceIncrement: 8, destinationIncrement: 0x80000, sourceDataWidth: 3,
                    destinationDataWidth: 0x30000, priority: 0x800000, sourceBurstLength: 7,
                    destinationBurstLength: 64, transferAllocatedPort: 0x40004000, transferEventMode: 0xC0000000)
                XCTAssertEqual(io.dma.initialize(config, getTick: io.getTick), .ok)
                var expected: [DMACoreAccess] = [
                    .read(.ccr), .write(.ccr, 0xFFFF_FFFE), .read(.ccr),
                    .read(.ccr), .write(.ccr, 0xFFBC_FFF8),
                    .write(.ctr1, 0x43FB_406B), .read(.ctr2), .write(.ctr2, 0xFCC0_2DED), .write(.cbr1, 0)
                ]
                if channel >= 12 { expected += [.write(.ctr3, 0), .write(.cbr2, 0)] }
                expected += [.write(.cllr, 0)]
                XCTAssertEqual(io.mmio, expected, "\(controller) channel \(channel)")
                XCTAssertEqual(io.accesses.prefix(7), [
                    .tick(0), .handle(.lock, 0), .callbackWrite(.transferComplete, false),
                    .callbackWrite(.halfTransfer, false), .callbackWrite(.error, false),
                    .callbackWrite(.abort, false), .callbackWrite(.suspend, false)
                ])
                XCTAssertEqual(io.words[.state], 1)
                XCTAssertEqual(io.words[.errorCode], 0)
                XCTAssertEqual(io.words[.mode], 0)
                XCTAssertTrue(io.callbackSlots.isEmpty)
            }
        }
    }

    func testInitializeReadyPreservesCallbacksQueueAndDirectionRequestEncoding() {
        for direction: UInt32 in [0, 0x400, 0x200] {
            let io = DMACoreIO()
            io.words = [.state: 1, .queueAddress: 0x24001000]
            io.installCallbacks()
            let config = DMAConfiguration(request: direction == 0x200 ? UInt32.max : 0x200, direction: direction)
            XCTAssertEqual(io.dma.initialize(config, getTick: io.getTick), .ok)
            XCTAssertEqual(io.registers[.ctr2], direction == 0x200 ? 0x27F : direction)
            XCTAssertEqual(io.callbackSlots.count, 5)
            XCTAssertEqual(io.words[.queueAddress], 0x24001000)
        }
        for channel in [DMAChannel(controller: .gpdma1, index: 0),
                        DMAChannel(controller: .gpdma1, index: 15), DMAChannel(controller: .hpdma1, index: 15)] {
            let io = DMACoreIO(controller: channel.controller, channel: channel.index)
            XCTAssertEqual(io.dma.initialize(.init(mode: 0x1000), getTick: io.getTick), .ok)
            XCTAssertEqual(io.words[.mode], 0x1000)
            XCTAssertEqual(io.registers[.ctr2], 0x1000)
        }
    }

    func testInitializeStrictFiveMillisecondTimeoutWrapsAndDoesNotRecheck() {
        for completeAt: UInt32 in [5, 6] {
            let io = DMACoreIO()
            io.automaticReset = false
            io.registers[.ccr] = 1
            io.tick = UInt32.max - 2
            let start = io.tick
            io.onTick = { value in
                if value &- start == completeAt { io.registers[.ccr] = 0 }
            }
            XCTAssertEqual(io.dma.initialize(.init(), getTick: io.getTick), completeAt == 5 ? .ok : .error)
            XCTAssertEqual(io.tickCalls, completeAt == 5 ? 6 : 7)
            XCTAssertEqual(io.words[.state], completeAt == 5 ? 1 : 3)
            XCTAssertEqual(io.words[.errorCode], completeAt == 5 ? 0 : 0x10)
            if completeAt == 6 { XCTAssertEqual(io.writes, [.write(.ccr, 7)]) }
        }
    }

    func testDeinitializeExact2DResetOrderClearsParentButDoesNotChangeQueueMetadata() {
        let io = DMACoreIO(controller: .hpdma1, channel: 12)
        io.prepareTransfer(mode: 0x81)
        io.installCallbacks()
        io.parent = UnsafeMutableRawPointer(bitPattern: 0x1234)
        let originalContext = io.context
        XCTAssertEqual(io.dma.deinitialize(getTick: io.getTick), .ok)
        XCTAssertEqual(io.mmio, [
            .read(.ccr), .write(.ccr, 7), .read(.ccr),
            .write(.clbar, 0), .write(.ccr, 0), .write(.ctr1, 0), .write(.ctr2, 0),
            .write(.cbr1, 0), .write(.csar, 0), .write(.cdar, 0), .write(.cllr, 0),
            .write(.ctr3, 0), .write(.cbr2, 0), .write(.cfcr, 0x7F00)
        ])
        XCTAssertEqual(io.ram[0x2400100C], 2)
        XCTAssertEqual(io.words[.queueAddress], 0)
        XCTAssertEqual(io.words[.state], 0)
        XCTAssertEqual(io.words[.lock], 0)
        XCTAssertNil(io.parent)
        XCTAssertEqual(io.context, originalContext)
        XCTAssertTrue(io.callbackSlots.isEmpty)
        XCTAssertTrue(io.accesses.contains(.parentWrite(0)))
    }

    func testDeinitializeTimeoutPreservesLockCallbacksQueueAndParent() {
        let io = DMACoreIO()
        io.prepareTransfer(mode: 0x80)
        io.automaticReset = false
        io.installCallbacks()
        io.parent = UnsafeMutableRawPointer(bitPattern: 0x5678)
        XCTAssertEqual(io.dma.deinitialize(getTick: io.getTick), .error)
        XCTAssertEqual(io.tickCalls, 7)
        XCTAssertEqual(io.words[.state], 3)
        XCTAssertEqual(io.words[.lock], 1)
        XCTAssertEqual(io.words[.queueAddress], 0x24001000)
        XCTAssertEqual(io.callbackSlots.count, 5)
        XCTAssertEqual(io.parent, UnsafeMutableRawPointer(bitPattern: 0x5678))
        XCTAssertEqual(io.writes, [.write(.ccr, 7)])
    }

    func testStartProgramsCounterThenClearsFlagsThenAddressesAndRetainsLock() {
        let io = DMACoreIO()
        io.words = [.state: 1, .errorCode: 0xFFFF]
        io.registers[.cbr1] = 0xAABB_FFFF
        io.registers[.ccr] = 0x8000_0000
        XCTAssertEqual(io.dma.start(sourceAddress: 0x24000000, destinationAddress: 0x24001000, sourceDataSize: 17), .ok)
        XCTAssertEqual(io.mmio, [
            .read(.cbr1), .write(.cbr1, 0xAABB_0011), .write(.cfcr, 0x7F00),
            .write(.csar, 0x24000000), .write(.cdar, 0x24001000),
            .read(.ccr), .write(.ccr, 0x80000001)
        ])
        XCTAssertEqual(io.accesses.prefix(3), [.handle(.lock, 1), .handle(.state, 2), .handle(.errorCode, 0)])
        XCTAssertEqual(io.words[.lock], 1)
    }

    func testInterruptStartEnablesOptionalSourcesFromLiveCallbackSlots() {
        for selected in 0..<4 {
            let io = DMACoreIO()
            io.words[.state] = 1
            if selected & 1 != 0 { io.callbackSlots[.halfTransfer] = dmaCoreHalf }
            if selected & 2 != 0 { io.callbackSlots[.suspend] = dmaCoreSuspend }
            XCTAssertEqual(io.dma.startInterrupt(sourceAddress: 4, destinationAddress: 8, sourceDataSize: 0xFFFF), .ok)
            let optional: UInt32 = (selected & 1 == 0 ? 0 : 0x200) | (selected & 2 == 0 ? 0 : 0x2000)
            XCTAssertEqual(io.registers[.ccr], 0x5D01 | optional)
            XCTAssertEqual(io.accesses.filter { if case .callbackRead = $0 { return true }; return false },
                           [.callbackRead(.halfTransfer), .callbackRead(.suspend)])
            XCTAssertEqual(io.words[.lock], 1)
        }
    }

    func testStartFailuresDistinguishLockedFromStateBusyAndPreserveNoTransferSideEffects() {
        for useInterrupt in [false, true] {
            for state: UInt32 in [0, 1, 2, 3, 4, 5, 99] {
                let io = DMACoreIO()
                io.words = [.lock: 1, .state: state, .errorCode: 0x1234]
                let start = { useInterrupt ? io.dma.startInterrupt(sourceAddress: 4, destinationAddress: 8, sourceDataSize: 1)
                                          : io.dma.start(sourceAddress: 4, destinationAddress: 8, sourceDataSize: 1) }
                XCTAssertEqual(start(), .busy)
                XCTAssertEqual(io.words[.errorCode], 0x1234)
                XCTAssertTrue(io.accesses.isEmpty)
                if state != 1 {
                    io.words[.lock] = 0
                    XCTAssertEqual(start(), .error)
                    XCTAssertEqual(io.accesses, [.handle(.lock, 1), .handle(.errorCode, 0x40), .handle(.lock, 0)])
                }
            }
        }
    }

    func testAbortAndAbortInterruptHaveDifferentFailureUnlockAndTickSemantics() {
        let blocking = DMACoreIO()
        blocking.words = [.state: 1, .lock: 1]
        XCTAssertEqual(blocking.dma.abort(getTick: blocking.getTick), .error)
        XCTAssertEqual(blocking.accesses, [.tick(0), .handle(.errorCode, 0x20), .handle(.lock, 0)])
        let interrupt = DMACoreIO()
        interrupt.words = [.state: 1, .lock: 1]
        XCTAssertEqual(interrupt.dma.abortInterrupt(), .error)
        XCTAssertEqual(interrupt.accesses, [.handle(.errorCode, 0x20)])
        XCTAssertEqual(interrupt.words[.lock], 1)
    }

    func testAbortLinkedTransferQueuesReadyBeforeClearingRemainingSizeAndUnlocking() {
        let io = DMACoreIO()
        io.prepareTransfer(mode: 0x81)
        io.installCallbacks()
        io.registers[.cbr1] = 0x12345678
        XCTAssertEqual(io.dma.abort(getTick: io.getTick), .ok)
        XCTAssertEqual(io.accesses, [
            .tick(0), .read(.ccr), .write(.ccr, 5), .handle(.state, 5), .read(.csr),
            .read(.ccr), .write(.ccr, 7), .handle(.state, 4), .write(.cfcr, 0x7F00),
            .handle(.state, 1), .memory(0x2400100C, 1), .write(.cbr1, 0), .handle(.lock, 0)
        ])
        XCTAssertTrue(io.snapshots.isEmpty)
    }

    func testAbortTimeoutAccumulatesErrorAndReleasesLinkedQueueWithStrictWrap() {
        let io = DMACoreIO()
        io.prepareTransfer(mode: 0x80)
        io.words[.errorCode] = 5
        io.automaticSuspend = false
        io.tick = UInt32.max - 1
        XCTAssertEqual(io.dma.abort(getTick: io.getTick), .error)
        XCTAssertEqual(io.tickCalls, 7)
        XCTAssertEqual(io.words[.state], 3)
        XCTAssertEqual(io.words[.errorCode], 0x15)
        XCTAssertEqual(io.words[.lock], 0)
        XCTAssertEqual(io.ram[0x2400100C], 1)
        XCTAssertEqual(io.writes, [.write(.ccr, 5)])
    }

    func testPollFullUsesIdleWhileHalfRetainsBusyAndLock() {
        for level in [DMATransferCompleteLevel.full, .half] {
            let io = DMACoreIO()
            io.prepareTransfer(mode: 0x80)
            io.registers[.csr] = level == .full ? 1 : 0x200
            XCTAssertEqual(io.dma.pollForTransfer(level, timeout: 0, getTick: io.getTick), .ok)
            XCTAssertEqual(io.tickCalls, 1)
            XCTAssertEqual(io.writes, [.write(.cfcr, level == .full ? 0x300 : 0x200)])
            XCTAssertEqual(io.words[.lock], level == .full ? 0 : 1)
            XCTAssertEqual(io.words[.state], level == .full ? 1 : 2)
            XCTAssertEqual(io.ram[0x2400100C], level == .full ? 1 : 2)
        }
        let io = DMACoreIO()
        io.prepareTransfer()
        io.registers[.csr] = 0x100
        XCTAssertEqual(io.dma.pollForTransfer(.full, timeout: 0, getTick: io.getTick), .error)
        XCTAssertEqual(io.accesses.filter { if case .tick = $0 { return true }; return false }, [.tick(0), .tick(1), .tick(2)])
        XCTAssertEqual(io.words[.errorCode], 0x10)
        XCTAssertEqual(io.words[.state], 1)
    }

    func testPollUnsupportedCircularRetainsLockAndDoesNotReadRegisters() {
        let io = DMACoreIO()
        io.prepareTransfer(mode: 0x81)
        XCTAssertEqual(io.dma.pollForTransfer(.full, timeout: 1, getTick: io.getTick), .error)
        XCTAssertEqual(io.accesses, [.tick(0), .handle(.errorCode, 0x100)])
        XCTAssertEqual(io.words[.lock], 1)
    }

    func testPollMaxDelayDoesNotReadTickInsideWait() {
        let io = DMACoreIO()
        io.prepareTransfer()
        io.scriptedReads[.csr] = [0, 0, 1]
        XCTAssertEqual(io.dma.pollForTransfer(.full, timeout: .max, getTick: io.getTick), .ok)
        XCTAssertEqual(io.tickCalls, 1)
        XCTAssertEqual(io.mmio, [.read(.csr), .read(.csr), .read(.csr), .write(.cfcr, 0x300)])
    }

    func testPollAllErrorsAreInspectedAfterCompletionAndTriggerOverrunAloneReturnsOK() {
        for bits: UInt32 in 0..<16 {
            for level in [DMATransferCompleteLevel.full, .half] {
                for mode: UInt32 in [0, 0x80] {
                    let io = DMACoreIO()
                    io.prepareTransfer(mode: mode)
                    io.words[.errorCode] = 0x80000000
                    io.registers[.csr] = (bits & 7) << 10 | (bits & 8) << 11 | (level == .full ? 1 : 0x200)
                    XCTAssertEqual(io.dma.pollForTransfer(level, timeout: 100, getTick: io.getTick), bits & 7 == 0 ? .ok : .error)
                    XCTAssertEqual(io.words[.errorCode], 0x80000000 | bits)
                    var clears: [DMACoreAccess] = []
                    if bits & 8 != 0 { clears.append(.write(.cfcr, 0x4000)) }
                    let errors: [(UInt32, UInt32)] = [(1, 0x400), (2, 0x800), (4, 0x1000)]
                    for (bit, flag) in errors {
                        if bits & bit != 0 { clears.append(.write(.cfcr, flag)) }
                    }
                    if bits & 7 == 0 { clears.append(.write(.cfcr, level == .full ? 0x300 : 0x200)) }
                    XCTAssertEqual(io.writes.filter { if case .write(.cfcr, _) = $0 { return true }; return false }, clears)
                    XCTAssertEqual(io.words[.lock], bits & 7 != 0 || level == .full ? 0 : 1)
                }
            }
        }
    }

    func testIRQGlobalGateSkipsEvenStaleErrorsAndChannel15UsesBit15() {
        let io = DMACoreIO(controller: .hpdma1, channel: 15)
        io.words[.errorCode] = 0xFFFF
        io.registers[.misr] = 0x4000
        io.dma.handleInterrupt()
        XCTAssertEqual(io.accesses, [.read(.misr)])
        io.registers[.misr] = 0x8000
        io.accesses = []
        io.dma.handleInterrupt()
        XCTAssertTrue(io.writes.contains(.write(.ccr, 2)))
    }

    func testIRQCombinesAllEnabledErrorsAndPreservesCallbackOrderAndSnapshots() {
        let io = DMACoreIO()
        io.prepareTransfer(mode: 0x80)
        io.installCallbacks()
        io.registers[.misr] = 1
        io.registers[.ccr] = 0x7F01
        io.registers[.csr] = 0x7F00
        io.registers[.cbr1] = 0
        io.registers[.cllr] = 0
        io.dma.handleInterrupt()
        XCTAssertEqual(io.snapshots.map(\.id), [.halfTransfer, .suspend, .transferComplete, .error])
        XCTAssertEqual(io.snapshots.map(\.state), [2, 5, 1, 1])
        XCTAssertEqual(io.snapshots.map(\.lock), [1, 1, 0, 0])
        XCTAssertEqual(io.snapshots.map(\.error), [15, 15, 15, 15])
        XCTAssertEqual(io.snapshots.map(\.queueState), [2, 2, 1, 1])
        XCTAssertEqual(io.writes, [.write(.cfcr, 0x400), .write(.cfcr, 0x800), .write(.cfcr, 0x1000),
                                  .write(.cfcr, 0x4000), .write(.cfcr, 0x200), .write(.cfcr, 0x2000),
                                  .write(.cfcr, 0x300), .write(.ccr, 0x7F03)])
    }

    func testIRQReadsFlagsAgainAfterHalfCallback() {
        let io = DMACoreIO()
        io.prepareTransfer()
        io.installCallbacks()
        io.registers[.misr] = 1
        io.registers[.ccr] = 0x2301
        io.registers[.csr] = 0x200
        io.onCallback = { id in if id == .halfTransfer { io.registers[.csr, default: 0] |= 0x2100 } }
        io.dma.handleInterrupt()
        XCTAssertEqual(io.snapshots.map(\.id), [.halfTransfer, .suspend, .transferComplete])
        XCTAssertEqual(io.mmio.filter { $0 == .read(.csr) }.count, 7)
        io.onCallback = nil
    }

    func testIRQLinkedCompletionOnlyMarksReadyWhenBothCLLRAndEntireCBR1AreZero() {
        for link: UInt32 in [0, 4] {
            for remaining: UInt32 in [0, 1, 0x10000] {
                let io = DMACoreIO()
                io.prepareTransfer(mode: 0x80)
                io.registers[.misr] = 1
                io.registers[.csr] = 0x100
                io.registers[.ccr] = 0x101
                io.registers[.cllr] = link
                io.registers[.cbr1] = remaining
                io.dma.handleInterrupt()
                XCTAssertEqual(io.words[.state], link == 0 && remaining == 0 ? 1 : 2)
                XCTAssertEqual(io.words[.lock], 0)
                XCTAssertEqual(io.mmio.contains(.read(.cbr1)), link == 0)
            }
        }
    }

    func testCompleteCallbackCanRearmAndSuppressPreviousErrorsExactlyAsLiveCState() {
        let io = DMACoreIO()
        io.prepareTransfer()
        io.installCallbacks()
        io.registers[.misr] = 1
        io.registers[.ccr] = 0x501
        io.registers[.csr] = 0x500
        var result: HALStatus?
        io.onCallback = { id in
            if id == .transferComplete { result = io.dma.startInterrupt(sourceAddress: 4, destinationAddress: 8, sourceDataSize: 37) }
        }
        io.dma.handleInterrupt()
        XCTAssertEqual(result, .ok)
        XCTAssertEqual(io.snapshots.map(\.id), [.transferComplete])
        XCTAssertEqual(io.snapshots.first?.error, 1)
        XCTAssertEqual(io.snapshots.first?.lock, 0)
        XCTAssertEqual(io.words[.state], 2)
        XCTAssertEqual(io.words[.lock], 1)
        XCTAssertEqual(io.words[.errorCode], 0)
        XCTAssertEqual(io.registers[.cbr1], 37)
        io.onCallback = nil
    }

    func testAbortIRQReturnsImmediatelyAfterCallbackRearmWithoutProcessingOldTCOrError() {
        let io = DMACoreIO()
        io.prepareTransfer(mode: 0x80)
        io.words[.state] = 4
        io.installCallbacks()
        io.registers[.misr] = 1
        io.registers[.ccr] = 0x2501
        io.registers[.csr] = 0x2500
        io.registers[.cbr1] = 99
        var result: HALStatus?
        io.onCallback = { id in
            if id == .abort { result = io.dma.start(sourceAddress: 12, destinationAddress: 16, sourceDataSize: 3) }
        }
        io.dma.handleInterrupt()
        XCTAssertEqual(result, .ok)
        XCTAssertEqual(io.snapshots.map(\.id), [.abort])
        XCTAssertEqual(io.snapshots.first?.queueState, 1)
        XCTAssertEqual(io.snapshots.first?.cbr1, 0)
        XCTAssertEqual(io.snapshots.first?.lock, 0)
        XCTAssertEqual(io.words[.state], 2)
        XCTAssertEqual(io.words[.lock], 1)
        XCTAssertEqual(io.registers[.cbr1], 3)
        io.onCallback = nil
    }

    func testCallbackRegistrationAllStatesIDsAndNilPreservesErrorAndLock() {
        for state: UInt32 in 0...5 {
            for id: UInt32 in 0...7 {
                for nilCallback in [false, true] {
                    let io = DMACoreIO()
                    io.words = [.state: state, .lock: 1, .errorCode: 0x1234]
                    io.installCallbacks()
                    XCTAssertEqual(io.dma.registerCallback(id: id, callback: nilCallback ? nil : dmaCoreComplete),
                                   state == 1 && id < 5 ? .ok : .error)
                    XCTAssertEqual(io.words[.lock], 1)
                    XCTAssertEqual(io.words[.errorCode], 0x1234)
                    XCTAssertTrue(io.mmio.isEmpty)
                    XCTAssertEqual(io.dma.unregisterCallback(id: id), state == 1 && id <= 5 ? .ok : .error)
                    if state == 1 && id == 5 { XCTAssertTrue(io.callbackSlots.isEmpty) }
                }
            }
        }
    }

    func testAttributesAllChannelsPreserveOtherBitsAndNullOutputDoesNotRead() {
        for controller in [DMAController.gpdma1, .hpdma1] {
            for channel in 0..<16 {
                let io = DMACoreIO(controller: controller, channel: channel)
                let mask = UInt32(1) << channel
                io.registers[.privcfgr] = 0xFFFF_FFFF
                XCTAssertEqual(io.dma.configureChannelAttributes(0x01000000), .ok)
                XCTAssertEqual(io.registers[.privcfgr], ~mask)
                var output: UInt32 = 0
                XCTAssertEqual(io.dma.getChannelAttributes(&output), .ok)
                XCTAssertEqual(output, 0x01000000)
                XCTAssertEqual(io.dma.configureChannelAttributes(0x01000001), .ok)
                XCTAssertEqual(io.dma.getChannelAttributes(&output), .ok)
                XCTAssertEqual(output, 0x01000001)
                io.registers[.rcfglockr] = 0x80000000
                XCTAssertEqual(io.dma.lockChannelAttributes(), .ok)
                XCTAssertEqual(io.registers[.rcfglockr], 0x80000000 | mask)
                XCTAssertEqual(io.dma.getChannelAttributeLock(&output), .ok)
                XCTAssertEqual(output, 1)
                var missing: UInt32?
                io.accesses = []
                XCTAssertEqual(io.dma.getChannelAttributes(&missing), .error)
                XCTAssertEqual(io.dma.getChannelAttributeLock(&missing), .error)
                XCTAssertTrue(io.accesses.isEmpty)
            }
        }
    }

    func testMacroEquivalentsRetainRawMasksAndCounterSetDoesNotMaskInput() {
        let io = DMACoreIO()
        io.registers[.ccr] = 0x80000000
        io.dma.enable()
        io.dma.enableInterrupts(0x1200)
        XCTAssertEqual(io.dma.getInterruptSource(0x300), 0x200)
        io.dma.disableInterrupts(0x1000)
        io.registers[.csr] = 0x12345678
        XCTAssertEqual(io.dma.getFlag(0xF00), 0x600)
        io.dma.clearFlag(0x600)
        io.registers[.cbr1] = 0x1234FFFF
        io.dma.setCounter(0x80000005)
        XCTAssertEqual(io.registers[.cbr1], 0x92340005)
        XCTAssertEqual(io.dma.getCounter(), 5)
        io.words[.lock] = 1
        io.words[.errorCode] = 0x100
        io.dma.resetHandleState()
        XCTAssertEqual(io.words[.state], 0)
        XCTAssertEqual(io.words[.lock], 1)
        XCTAssertEqual(io.words[.errorCode], 0x100)
    }
}
