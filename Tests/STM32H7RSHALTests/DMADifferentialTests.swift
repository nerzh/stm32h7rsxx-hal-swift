import XCTest
import CDMAReference
@testable import STM32H7RSHAL

// Shared C storage supplies no DMA algorithm, register side effect, or invented
// read/write instrumentation to Swift. Original direct C MMIO stays untouched.
// Compare final state and tick/callback snapshots; trace/board suites separately
// verify volatile access ordering, W1C/reset behavior and real data movement.
private final class DMAOracleIO: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
    var storage = CDMAState()
    let channel: DMAChannel
    var context: UnsafeMutableRawPointer? { Unmanaged.passUnretained(self).toOpaque() }
    var dma: DMA<DMAOracleIO, DMAOracleIO, DMAOracleIO, DMAOracleIO> {
        .init(registers: self, handle: self, callbacks: self, memory: self)
    }

    init(controller: UInt32 = 0, index: UInt32 = 0) {
        channel = DMAChannel(controller: controller == 0 ? .gpdma1 : .hpdma1, index: Int(index))
        CDMA_Reset(&storage, controller, index)
    }

    static func register(_ register: DMARegister) -> CDMARegister {
        switch register {
        case .clbar: return CDMA_CLBAR
        case .cfcr: return CDMA_CFCR
        case .csr: return CDMA_CSR
        case .ccr: return CDMA_CCR
        case .ctr1: return CDMA_CTR1
        case .ctr2: return CDMA_CTR2
        case .cbr1: return CDMA_CBR1
        case .csar: return CDMA_CSAR
        case .cdar: return CDMA_CDAR
        case .ctr3: return CDMA_CTR3
        case .cbr2: return CDMA_CBR2
        case .cllr: return CDMA_CLLR
        case .privcfgr: return CDMA_PRIVCFGR
        case .rcfglockr: return CDMA_RCFGLOCKR
        case .misr: return CDMA_MISR
        }
    }
    func read(_ register: DMARegister) -> UInt32 { CDMA_Get(&storage, Self.register(register)) }
    func write(_ register: DMARegister, value: UInt32) { CDMA_Set(&storage, Self.register(register), value) }
    func read(_ word: DMAHandleWord) -> UInt32 { CDMA_GetHandle(&storage, UInt32(word.rawValue)) }
    func write(_ word: DMAHandleWord, value: UInt32) { CDMA_SetHandle(&storage, UInt32(word.rawValue), value) }
    func read32(at address: UInt32) -> UInt32 {
        precondition(address >= storage.queueAddress && address < storage.queueAddress + 24 && address & 3 == 0)
        return CDMA_GetQueue(&storage, (address - storage.queueAddress) / 4)
    }
    func write32(at address: UInt32, value: UInt32) {
        precondition(address >= storage.queueAddress && address < storage.queueAddress + 24 && address & 3 == 0)
        CDMA_SetQueue(&storage, (address - storage.queueAddress) / 4, value)
    }
    func getTick() -> UInt32 { CDMA_Tick(&storage) }
    func readParent() -> UnsafeMutableRawPointer? { UnsafeMutableRawPointer(bitPattern: CDMA_GetParent(&storage)) }
    func writeParent(_ value: UnsafeMutableRawPointer?) {
        CDMA_SetParent(&storage, value.map { UInt(bitPattern: $0) } ?? 0)
    }
    func read(_ id: DMACallbackID) -> DMACallback? {
        Self.callback(id.rawValue, CDMA_GetCallback(&storage, id.rawValue))
    }
    func write(_ id: DMACallbackID, value: DMACallback?) {
        guard let value else { CDMA_SetCallback(&storage, id.rawValue, 0); return }
        let bits = unsafeBitCast(value, to: UInt.self)
        for selector: UInt32 in 1...3 {
            if bits == unsafeBitCast(Self.callback(id.rawValue, selector)!, to: UInt.self) {
                CDMA_SetCallback(&storage, id.rawValue, selector)
                return
            }
        }
        preconditionFailure("Unexpected Swift DMA callback")
    }
    static func object(_ context: UnsafeMutableRawPointer?) -> DMAOracleIO {
        Unmanaged<DMAOracleIO>.fromOpaque(context!).takeUnretainedValue()
    }
    static func callback(_ id: UInt32, _ selector: UInt32) -> DMACallback? {
        if selector == 0 { return nil }
        switch (id, selector) {
        case (1, 1): return { DMAOracleIO.object($0).record(1, 1) }
        case (1, 2): return { DMAOracleIO.object($0).record(1, 2) }
        case (1, 3): return { DMAOracleIO.object($0).record(1, 3) }
        case (2, 1): return { DMAOracleIO.object($0).record(2, 1) }
        case (2, 2): return { DMAOracleIO.object($0).record(2, 2) }
        case (2, 3): return { DMAOracleIO.object($0).record(2, 3) }
        case (3, 1): return { DMAOracleIO.object($0).record(3, 1) }
        case (3, 2): return { DMAOracleIO.object($0).record(3, 2) }
        case (3, 3): return { DMAOracleIO.object($0).record(3, 3) }
        case (4, 1): return { DMAOracleIO.object($0).record(4, 1) }
        case (4, 2): return { DMAOracleIO.object($0).record(4, 2) }
        case (4, 3): return { DMAOracleIO.object($0).record(4, 3) }
        case (_, 1): return { DMAOracleIO.object($0).record(0, 1) }
        case (_, 2): return { DMAOracleIO.object($0).record(0, 2) }
        default: return { DMAOracleIO.object($0).record(0, 3) }
        }
    }
    func record(_ id: UInt32, _ selector: UInt32) {
        let index = CDMA_RecordCallback(&storage, id, selector)
        let action = CDMA_GetCallbackAction(&storage, id)
        let a = CDMA_GetCallbackArgument(&storage, id, 0)
        let b = CDMA_GetCallbackArgument(&storage, id, 1)
        let c = CDMA_GetCallbackArgument(&storage, id, 2)
        let result: HALStatus
        switch action {
        case 1: result = dma.start(sourceAddress: a, destinationAddress: b, sourceDataSize: c)
        case 2: result = dma.startInterrupt(sourceAddress: a, destinationAddress: b, sourceDataSize: c)
        case 3: result = dma.abortInterrupt()
        case 4: result = dma.resume()
        case 5: write(.errorCode, value: a); return
        default: return
        }
        CDMA_SetCallbackActionStatus(&storage, index, result.rawValue)
    }

    func configuration() -> DMAConfiguration {
        let c = storage.handle.Init
        return .init(request: c.Request, blockHardwareRequest: c.BlkHWRequest, direction: c.Direction,
                     sourceIncrement: c.SrcInc, destinationIncrement: c.DestInc,
                     sourceDataWidth: c.SrcDataWidth, destinationDataWidth: c.DestDataWidth,
                     priority: c.Priority, sourceBurstLength: c.SrcBurstLength, destinationBurstLength: c.DestBurstLength,
                     transferAllocatedPort: c.TransferAllocatedPort, transferEventMode: c.TransferEventMode, mode: c.Mode)
    }
    func callSwift(_ operation: CDMAOperation, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        let result: HALStatus
        switch operation {
        case CDMA_Initialize: result = dma.initialize(configuration(), getTick: getTick)
        case CDMA_Deinitialize: result = dma.deinitialize(getTick: getTick)
        case CDMA_Start: result = dma.start(sourceAddress: a, destinationAddress: b, sourceDataSize: c)
        case CDMA_StartInterrupt: result = dma.startInterrupt(sourceAddress: a, destinationAddress: b, sourceDataSize: c)
        case CDMA_Abort: result = dma.abort(getTick: getTick)
        case CDMA_AbortInterrupt: result = dma.abortInterrupt()
        case CDMA_Poll: result = dma.pollForTransfer(DMATransferCompleteLevel(rawValue: a)!, timeout: b, getTick: getTick)
        case CDMA_Interrupt: dma.handleInterrupt(); return 0
        case CDMA_GetState: return dma.getState().rawValue
        case CDMA_GetError: return dma.getError().rawValue
        case CDMA_ConfigureAttributes: result = dma.configureChannelAttributes(a)
        case CDMA_GetAttributes, CDMA_GetAttributeLock:
            var output: UInt32? = storage.nullMask & 4 == 0 ? storage.output : nil
            result = operation == CDMA_GetAttributes ? dma.getChannelAttributes(&output) : dma.getChannelAttributeLock(&output)
            if let output { storage.output = output }
        case CDMA_LockAttributes: result = dma.lockChannelAttributes()
        case CDMA_RegisterCallback: result = dma.registerCallback(id: a, callback: Self.callback(a, b))
        case CDMA_UnregisterCallback: result = dma.unregisterCallback(id: a)
        case CDMA_ConfigureDataHandling:
            let value = storage.dataHandling
            result = dma.configureDataHandling(storage.nullMask & 2 == 0 ? .init(alignment: value.DataAlignment, exchange: value.DataExchange) : nil)
        case CDMA_ConfigureTrigger:
            let value = storage.trigger
            result = dma.configureTrigger(storage.nullMask & 2 == 0 ? .init(mode: value.TriggerMode, polarity: value.TriggerPolarity, selection: value.TriggerSelection) : nil)
        case CDMA_ConfigureRepeatBlock:
            let value = storage.repeatBlock
            result = dma.configureRepeatBlock(storage.nullMask & 2 == 0 ? .init(
                repeatCount: value.RepeatCount, sourceAddressOffset: value.SrcAddrOffset,
                destinationAddressOffset: value.DestAddrOffset, blockSourceAddressOffset: value.BlkSrcAddrOffset,
                blockDestinationAddressOffset: value.BlkDestAddrOffset) : nil)
        case CDMA_Suspend: result = dma.suspend(getTick: getTick)
        case CDMA_SuspendInterrupt: result = dma.suspendInterrupt()
        case CDMA_Resume: result = dma.resume()
        case CDMA_GetFifoLevel: return dma.getFIFOLevel()
        default: preconditionFailure("Unsupported DMA differential operation")
        }
        return result.rawValue
    }
}

final class DMADifferentialTests: XCTestCase {
    private func compare(_ swift: DMAOracleIO, _ reference: DMAOracleIO, _ message: String,
                         file: StaticString = #filePath, line: UInt = #line) {
        for index: UInt32 in 0..<CDMA_RegisterCount.rawValue {
            let register = CDMARegister(rawValue: index)
            XCTAssertEqual(CDMA_Get(&swift.storage, register), CDMA_Get(&reference.storage, register),
                           "\(message) register \(index)", file: file, line: line)
        }
        for index: UInt32 in 0..<5 {
            XCTAssertEqual(CDMA_GetHandle(&swift.storage, index), CDMA_GetHandle(&reference.storage, index),
                           "\(message) handle \(index)", file: file, line: line)
            XCTAssertEqual(CDMA_GetCallback(&swift.storage, index), CDMA_GetCallback(&reference.storage, index),
                           "\(message) callback slot \(index)", file: file, line: line)
        }
        for index: UInt32 in 0..<6 {
            XCTAssertEqual(CDMA_GetQueue(&swift.storage, index), CDMA_GetQueue(&reference.storage, index),
                           "\(message) queue \(index)", file: file, line: line)
        }
        XCTAssertEqual(CDMA_GetParent(&swift.storage), CDMA_GetParent(&reference.storage), message, file: file, line: line)
        XCTAssertEqual(swift.storage.output, reference.storage.output, "\(message) output", file: file, line: line)
        XCTAssertEqual(swift.storage.tick, reference.storage.tick, "\(message) tick", file: file, line: line)
        XCTAssertEqual(swift.storage.tickCalls, reference.storage.tickCalls, message, file: file, line: line)
        XCTAssertEqual(swift.storage.snapshotCount, reference.storage.snapshotCount, message, file: file, line: line)
        for index in 0..<min(swift.storage.snapshotCount, reference.storage.snapshotCount) {
            var a = CDMA_GetSnapshot(&swift.storage, index)
            var b = CDMA_GetSnapshot(&reference.storage, index)
            let lhs = withUnsafeBytes(of: &a) { Array($0.bindMemory(to: UInt32.self)) }
            let rhs = withUnsafeBytes(of: &b) { Array($0.bindMemory(to: UInt32.self)) }
            XCTAssertEqual(lhs, rhs, "\(message) tick snapshot \(index)", file: file, line: line)
        }
        XCTAssertEqual(swift.storage.callbackCount, reference.storage.callbackCount, message, file: file, line: line)
        for index in 0..<min(swift.storage.callbackCount, reference.storage.callbackCount) {
            var a = CDMA_GetCallbackEvent(&swift.storage, index)
            var b = CDMA_GetCallbackEvent(&reference.storage, index)
            XCTAssertEqual(a.callbackID, b.callbackID, message, file: file, line: line)
            XCTAssertEqual(a.implementation, b.implementation, message, file: file, line: line)
            XCTAssertEqual(a.actionStatus, b.actionStatus, message, file: file, line: line)
            XCTAssertEqual(a.parent, b.parent, message, file: file, line: line)
            let lhs = withUnsafeBytes(of: &a.snapshot) { Array($0.bindMemory(to: UInt32.self)) }
            let rhs = withUnsafeBytes(of: &b.snapshot) { Array($0.bindMemory(to: UInt32.self)) }
            XCTAssertEqual(lhs, rhs, "\(message) callback snapshot \(index)", file: file, line: line)
            let slotsA = withUnsafeBytes(of: &a.slots) { Array($0.bindMemory(to: UInt32.self)) }
            let slotsB = withUnsafeBytes(of: &b.slots) { Array($0.bindMemory(to: UInt32.self)) }
            XCTAssertEqual(slotsA, slotsB, message, file: file, line: line)
        }
    }

    private func check(_ operation: CDMAOperation, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0,
                       controller: UInt32 = 0, channel: UInt32 = 0, label: String = "",
                       seed: (DMAOracleIO) -> Void = { _ in },
                       file: StaticString = #filePath, line: UInt = #line) {
        let swift = DMAOracleIO(controller: controller, index: channel)
        let reference = DMAOracleIO(controller: controller, index: channel)
        seed(swift); seed(reference)
        let message = "op\(operation.rawValue) \(label)"
        XCTAssertEqual(swift.callSwift(operation, a, b, c), CDMA_Call(&reference.storage, operation, a, b, c),
                       message, file: file, line: line)
        compare(swift, reference, message, file: file, line: line)
    }

    private func transfer(_ io: DMAOracleIO, state: UInt32 = 2, lock: UInt32 = 1, mode: UInt32 = 0) {
        io.write(.state, value: state); io.write(.lock, value: lock); io.write(.mode, value: mode)
        io.write(.queueAddress, value: io.storage.queueAddress)
        io.write(.errorCode, value: 0x80000000)
        CDMA_SetQueue(&io.storage, 0, io.storage.nodeAddress)
        CDMA_SetQueue(&io.storage, 2, 1); CDMA_SetQueue(&io.storage, 3, 2)
        CDMA_SetQueue(&io.storage, 4, 0x1234)
        CDMA_SetParent(&io.storage, 0x12345678)
        for slot: UInt32 in 0..<5 { CDMA_SetCallback(&io.storage, slot, slot % 3 + 1) }
    }

    func testInitializeAndDeinitializeEveryControllerChannelAndHandleState() {
        for controller: UInt32 in 0...1 {
            for channel: UInt32 in 0..<16 {
                for state: UInt32 in 0...5 {
                    for operation in [CDMA_Initialize, CDMA_Deinitialize] {
                        check(operation, controller: controller, channel: channel, label: "state\(state)") { io in
                            self.transfer(io, state: state)
                            for register in DMARegister.allCases { io.write(register, value: 0xA5A5A5A4) }
                            io.storage.handle.Init.Request = 109
                            io.storage.handle.Init.BlkHWRequest = 0x800
                            io.storage.handle.Init.Direction = 0x400
                            io.storage.handle.Init.SrcInc = 8; io.storage.handle.Init.DestInc = 0x80000
                            io.storage.handle.Init.SrcDataWidth = 3; io.storage.handle.Init.DestDataWidth = 0x30000
                            io.storage.handle.Init.Priority = (state & 3) << 22
                            io.storage.handle.Init.SrcBurstLength = 1 + channel
                            io.storage.handle.Init.DestBurstLength = 64 - channel
                            io.storage.handle.Init.TransferAllocatedPort = 0x40004000
                            io.storage.handle.Init.TransferEventMode = (state & 3) << 30
                        }
                    }
                }
            }
        }
    }

    func testInitializerAllSourceDestinationWidthsBurstsDirectionsAndMasks() {
        for source: UInt32 in 0...3 {
            for destination: UInt32 in 0...3 {
                for direction: UInt32 in [0, 0x200, 0x400] {
                    for burst: UInt32 in [1, 2, 63, 64] {
                        check(CDMA_Initialize, controller: 1, channel: 15) { io in
                            io.storage.handle.Init.SrcDataWidth = source
                            io.storage.handle.Init.DestDataWidth = destination << 16
                            io.storage.handle.Init.Direction = direction
                            io.storage.handle.Init.Request = direction == 0x200 ? UInt32.max : 0x200
                            io.storage.handle.Init.SrcBurstLength = burst
                            io.storage.handle.Init.DestBurstLength = 65 - burst
                            io.storage.handle.Init.Mode = 0x1000
                            io.write(.ctr2, value: UInt32.max)
                        }
                    }
                }
            }
        }
    }

    func testDisableAndAbortTimeoutBoundaryWrapAndLateHardwareEvents() {
        for operation in [CDMA_Initialize, CDMA_Deinitialize, CDMA_Abort, CDMA_Suspend] {
            for start: UInt32 in [0, UInt32.max - 3] {
                for event: UInt32 in [0, 1, 2, 6, 7, 8] {
                    for mode: UInt32 in [0, 0x80, 0x81] {
                        check(operation, label: "start\(start) event\(event) mode\(mode)") { io in
                            self.transfer(io, mode: mode)
                            io.storage.tick = start
                            io.write(.ccr, value: 1); io.write(.csr, value: 0)
                            if event != 0 {
                                if operation == CDMA_Initialize || operation == CDMA_Deinitialize {
                                    CDMA_ScheduleTick(&io.storage, event, CDMA_CCR, 1, 0)
                                } else { CDMA_ScheduleTick(&io.storage, event, CDMA_CSR, 0, 0x2000) }
                            }
                        }
                    }
                }
            }
        }
    }

    func testStartAllStatesLocksOptionalCallbacksSizesAndPreservedCounters() {
        for state: UInt32 in 0...5 {
            for lock: UInt32 in [0, 1, 2] {
                for callbacks: UInt32 in 0..<4 {
                    for operation in [CDMA_Start, CDMA_StartInterrupt] {
                        for size: UInt32 in [1, 0xFFFF] {
                            check(operation, 0xFFFFFFFC, 0x24001000, size, label: "state\(state) lock\(lock)") { io in
                                self.transfer(io, state: state, lock: lock)
                                io.write(.ccr, value: 0xA5A58000); io.write(.cbr1, value: 0xFAAA5555)
                                CDMA_SetCallback(&io.storage, 1, callbacks & 1 == 0 ? 0 : 2)
                                CDMA_SetCallback(&io.storage, 4, callbacks & 2 == 0 ? 0 : 3)
                            }
                        }
                    }
                }
            }
        }
    }

    func testAllStatesLocksAcrossAbortSuspendResumeAndGetters() {
        for state: UInt32 in 0...5 {
            for lock: UInt32 in [0, 1, 2] {
                for mode: UInt32 in [0, 0x1000, 0x80, 0x81] {
                    for operation in [CDMA_Abort, CDMA_AbortInterrupt, CDMA_Suspend, CDMA_SuspendInterrupt,
                                      CDMA_Resume, CDMA_GetState, CDMA_GetError] {
                        check(operation, label: "state\(state) lock\(lock) mode\(mode)") { io in
                            self.transfer(io, state: state, lock: lock, mode: mode)
                            io.write(.ccr, value: 0xA5A5A5A5); io.write(.csr, value: 0x2000)
                            io.write(.cfcr, value: 0x80000400); io.write(.cbr1, value: 0xABCD1234)
                        }
                    }
                }
            }
        }
    }

    func testPollEveryFlagCombinationBothCompletionLevelsAndLinkedModes() {
        for flags: UInt32 in 0..<128 {
            for level: UInt32 in 0...1 {
                for mode: UInt32 in [0, 0x80, 0x81] {
                    check(CDMA_Poll, level, 0, label: "flags\(flags) mode\(mode)") { io in
                        self.transfer(io, mode: mode)
                        io.write(.csr, value: (flags << 8) | (level == 0 ? 1 : 0x200))
                        io.write(.ccr, value: 0xFFFF0001)
                    }
                }
            }
        }
        for state: UInt32 in 0...5 {
            for lock: UInt32 in [0, 1] {
                check(CDMA_Poll, 0, 0) { io in
                    self.transfer(io, state: state, lock: lock)
                    io.write(.csr, value: 1)
                }
            }
        }
    }

    func testPollTimeoutUsesNestedAbortAndStrictWrappingTickComparison() {
        for start: UInt32 in [0, UInt32.max - 2] {
            for timeout: UInt32 in [0, 1, 5] {
                for readyAt: UInt32 in [0, 1, 2, 6, 7, 8] {
                    for suspendReady in [false, true] {
                        check(CDMA_Poll, 0, timeout, label: "readyAt\(readyAt) timeout\(timeout)") { io in
                            self.transfer(io, mode: 0x80)
                            io.storage.tick = start
                            io.write(.ccr, value: 1); io.write(.csr, value: suspendReady ? 0x2000 : 0)
                            if readyAt != 0 { CDMA_ScheduleTick(&io.storage, readyAt, CDMA_CSR, 0, 1) }
                        }
                    }
                }
            }
        }
        check(CDMA_Poll, 0, UInt32.max) { io in self.transfer(io); io.write(.csr, value: 1) }
        check(CDMA_Poll, 1, UInt32.max) { io in self.transfer(io); io.write(.csr, value: 0x200) }
    }

    func testIRQEveryStatusAndInterruptMaskCombinationOnBothControllers() {
        for controller: UInt32 in 0...1 {
            for flags: UInt32 in 0..<128 {
                for enabled: UInt32 in 0..<128 {
                    let channel: UInt32 = enabled & 1 == 0 ? 0 : 15
                    check(CDMA_Interrupt, controller: controller, channel: channel,
                          label: "flags\(flags) enabled\(enabled)") { io in
                        self.transfer(io)
                        io.write(.errorCode, value: 0)
                        io.write(.misr, value: 1 << channel)
                        io.write(.csr, value: flags << 8)
                        io.write(.ccr, value: enabled << 8 | 1)
                    }
                }
            }
        }
    }

    func testIRQStatesLocksModesRemainingWordsAndGlobalGate() {
        for state: UInt32 in 0...5 {
            for lock: UInt32 in [0, 1] {
                for mode: UInt32 in [0, 0x80, 0x81] {
                    for link: UInt32 in [0, 4] {
                        for remaining: UInt32 in [0, 1, 0x10000] {
                            for active in [false, true] {
                                check(CDMA_Interrupt, controller: 1, channel: 15) { io in
                                    self.transfer(io, state: state, lock: lock, mode: mode)
                                    io.write(.misr, value: active ? 0x8000 : 0x4000)
                                    io.write(.ccr, value: 0x7F01); io.write(.csr, value: 0x7F00)
                                    io.write(.cllr, value: link); io.write(.cbr1, value: remaining)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func testIRQCallbackReentryActionsUseSwiftDriverAndMatchOriginalCSnapshots() {
        for callback: UInt32 in 0..<5 {
            for action: UInt32 in 1...5 {
                for mode: UInt32 in [0, 0x80] {
                    for selector: UInt32 in 1...3 {
                        check(CDMA_Interrupt, label: "callback\(callback) action\(action)") { io in
                            self.transfer(io, state: callback == 3 ? 4 : 2, mode: mode)
                            io.write(.errorCode, value: 0)
                            io.write(.misr, value: 1); io.write(.ccr, value: 0x7F01)
                            let flags: UInt32 = callback == 3 ? 0x2500 : callback == 4 ? 0x2100 : callback == 1 ? 0x2300 : 0x500
                            io.write(.csr, value: flags)
                            for slot: UInt32 in 0..<5 { CDMA_SetCallback(&io.storage, slot, selector) }
                            CDMA_SetCallbackAction(&io.storage, callback, action, 0x24004000, 0x24005000, 16)
                        }
                    }
                }
            }
        }
        // HT may assign an error before TC; TC may remove it before the final
        // error branch. This checks that the current handle value is reread.
        check(CDMA_Interrupt) { io in
            self.transfer(io); io.write(.errorCode, value: 0)
            io.write(.misr, value: 1); io.write(.csr, value: 0x300); io.write(.ccr, value: 0x301)
            CDMA_SetCallbackAction(&io.storage, 1, 5, 0xFFFF, 0, 0)
            CDMA_SetCallbackAction(&io.storage, 0, 5, 0, 0, 0)
        }
    }

    func testRegistrationEveryStateLockIDAndNullPointer() {
        for state: UInt32 in 0...5 {
            for lock: UInt32 in [0, 1] {
                for id: UInt32 in [0, 1, 2, 3, 4, 5, 6, UInt32.max] {
                    for selector: UInt32 in 0...3 {
                        for operation in [CDMA_RegisterCallback, CDMA_UnregisterCallback] {
                            check(operation, id, selector) { io in self.transfer(io, state: state, lock: lock) }
                        }
                    }
                }
            }
        }
    }

    func testAttributesAllChannelsStatesAndNullOutputsPreserveUnrelatedBits() {
        for controller: UInt32 in 0...1 {
            for channel: UInt32 in 0..<16 {
                for state: UInt32 in 0...5 {
                    for operation in [CDMA_ConfigureAttributes, CDMA_GetAttributes, CDMA_LockAttributes, CDMA_GetAttributeLock] {
                        for attribute: UInt32 in [0x01000000, 0x01000001] {
                            check(operation, attribute, controller: controller, channel: channel) { io in
                                self.transfer(io, state: state)
                                io.storage.output = 0xDEADBEEF
                                io.write(.privcfgr, value: 0xA5A55A5A); io.write(.rcfglockr, value: 0x5A5AA5A5)
                            }
                        }
                    }
                }
            }
        }
        for operation in [CDMA_GetAttributes, CDMA_GetAttributeLock] {
            check(operation) { io in io.storage.nullMask = 4; io.storage.output = 0xDEADBEEF }
        }
    }

    func testDataHandlingAllExchangeAndAlignmentCombinationsAndStates() {
        for alignment: UInt32 in [0, 0x800, 0x1000] {
            for exchange: UInt32 in 0..<16 {
                for state: UInt32 in 0...5 {
                    check(CDMA_ConfigureDataHandling) { io in
                        self.transfer(io, state: state)
                        io.storage.dataHandling.DataAlignment = alignment
                        io.storage.dataHandling.DataExchange = ((exchange & 1) << 13) | ((exchange & 14) << 25)
                        io.write(.ctr1, value: 0xA5A5A5A5)
                    }
                }
            }
        }
    }

    func testTriggerAllSourcesModesPolaritiesAndUnrelatedBits() {
        for source: UInt32 in 0...55 {
            for mode: UInt32 in [0, 0x4000, 0x8000, 0xC000] {
                for polarity: UInt32 in [0, 0x01000000, 0x02000000] {
                    check(CDMA_ConfigureTrigger) { io in
                        self.transfer(io, state: 1)
                        io.storage.trigger.TriggerMode = mode
                        io.storage.trigger.TriggerPolarity = polarity
                        io.storage.trigger.TriggerSelection = source
                        io.write(.ctr2, value: UInt32.max)
                    }
                }
            }
        }
    }

    func testRepeatBlockAllOffsetSignsBoundsAndCountsOnBothControllers() {
        for controller: UInt32 in 0...1 {
            for repeatCount: UInt32 in [1, 2, 2047] {
                for source: Int32 in [-8191, -1, 0, 1, 8191] {
                    for destination: Int32 in [-8191, -1, 0, 1, 8191] {
                        for blockSource: Int32 in [-65535, 0, 65535] {
                            for blockDestination: Int32 in [-65535, 0, 65535] {
                                check(CDMA_ConfigureRepeatBlock, controller: controller, channel: 15) { io in
                                    self.transfer(io, state: 1)
                                    io.storage.repeatBlock.RepeatCount = repeatCount
                                    io.storage.repeatBlock.SrcAddrOffset = source
                                    io.storage.repeatBlock.DestAddrOffset = destination
                                    io.storage.repeatBlock.BlkSrcAddrOffset = blockSource
                                    io.storage.repeatBlock.BlkDestAddrOffset = blockDestination
                                    io.write(.cbr1, value: UInt32.max)
                                    io.write(.ctr3, value: UInt32.max); io.write(.cbr2, value: UInt32.max)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func testExtendedConfigurationFailureStatesAndNilLeaveOutputUntouched() {
        for operation in [CDMA_ConfigureDataHandling, CDMA_ConfigureTrigger, CDMA_ConfigureRepeatBlock] {
            for state: UInt32 in 0...5 {
                for lock: UInt32 in [0, 1] {
                    for missing in [false, true] {
                        check(operation, channel: 12) { io in
                            self.transfer(io, state: state, lock: lock)
                            io.storage.nullMask = missing ? 2 : 0
                            io.write(.ctr1, value: UInt32.max); io.write(.ctr2, value: UInt32.max)
                            io.write(.ctr3, value: UInt32.max); io.write(.cbr1, value: UInt32.max)
                            io.write(.cbr2, value: UInt32.max)
                        }
                    }
                }
            }
        }
    }

    func testFIFOUsesEightBitCMSISMaskOnBothControllersForEveryNineBitInput() {
        for controller: UInt32 in 0...1 {
            for level: UInt32 in 0..<512 {
                check(CDMA_GetFifoLevel, controller: controller, channel: 15) { io in
                    io.write(.csr, value: (level << 16) | 0xFE00FFFF)
                }
            }
        }
    }
}
