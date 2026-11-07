import XCTest
@testable import STM32H7RSHAL

enum DMAListTestEvent: Equatable {
    case registerRead(DMARegister), registerWrite(DMARegister, UInt32)
    case handleRead(DMAHandleWord), handleWrite(DMAHandleWord, UInt32)
    case memoryRead(UInt32), memoryWrite(UInt32, UInt32)
    case callbackRead(DMACallbackID), callbackWrite(DMACallbackID), parentRead, parentWrite, tick
}

private func dmaListTestCallback(_ context: UnsafeMutableRawPointer?) {}

final class DMAListTestIO: DMARegisterIO, DMAHandleIO, DMACallbackIO, DMAMemoryIO {
    var channel = DMAChannel(controller: .gpdma1, index: 0)
    var registers: [DMARegister: UInt32] = [:]
    var handleWords: [DMAHandleWord: UInt32] = [:]
    var memory: [UInt32: UInt32] = [:]
    var callbackSlots: [UInt32: DMACallback] = [:]
    var parent: UnsafeMutableRawPointer?
    var events: [DMAListTestEvent] = []
    var ticks: UInt32 = 0
    var tickCalls = 0
    var onTick: ((DMAListTestIO) -> Void)?
    var context: UnsafeMutableRawPointer? { nil }
    var driver: DMA<DMAListTestIO, DMAListTestIO, DMAListTestIO, DMAListTestIO> {
        .init(registers: self, handle: self, callbacks: self, memory: self)
    }
    var list: DMALinkedList<DMAListTestIO> { .init(memory: self) }
    func read(_ register: DMARegister) -> UInt32 {
        events.append(.registerRead(register)); return registers[register, default: 0]
    }
    func write(_ register: DMARegister, value: UInt32) {
        events.append(.registerWrite(register, value)); registers[register] = value
    }
    func read(_ word: DMAHandleWord) -> UInt32 {
        events.append(.handleRead(word)); return handleWords[word, default: 0]
    }
    func write(_ word: DMAHandleWord, value: UInt32) {
        events.append(.handleWrite(word, value)); handleWords[word] = value
    }
    func read32(at address: UInt32) -> UInt32 {
        events.append(.memoryRead(address)); return memory[address, default: 0]
    }
    func write32(at address: UInt32, value: UInt32) {
        events.append(.memoryWrite(address, value)); memory[address] = value
    }
    func read(_ id: DMACallbackID) -> DMACallback? {
        events.append(.callbackRead(id)); return callbackSlots[id.rawValue]
    }
    func write(_ id: DMACallbackID, value: DMACallback?) {
        events.append(.callbackWrite(id)); callbackSlots[id.rawValue] = value
    }
    func readParent() -> UnsafeMutableRawPointer? { events.append(.parentRead); return parent }
    func writeParent(_ value: UnsafeMutableRawPointer?) { events.append(.parentWrite); parent = value }
    func getTick() -> UInt32 {
        events.append(.tick); let result = ticks
        ticks &+= 1; tickCalls += 1; onTick?(self); return result
    }
    func seedNode(_ address: UInt32, type: UInt32 = 0x21, words: [UInt32]? = nil) {
        let values = words ?? [0, 0, 16, 0x2400_8000, 0x2400_9000, 0, 0, 0,
                               type | (type & 2 == 2 ? 0x700 : 0x500)]
        for (index, value) in values.enumerated() { memory[address + UInt32(index * 4)] = value }
    }
    func seedQueue(_ address: UInt32, nodes: [UInt32], type: UInt32 = 0x21, circular: UInt32 = 0) {
        let offset: UInt32 = type & 2 == 2 ? 28 : 20
        let mask: UInt32 = type & 2 == 2 ? 0xFE01_0000 : 0xF801_0000
        for (index, node) in nodes.enumerated() {
            seedNode(node, type: type)
            let next = index + 1 < nodes.count ? nodes[index + 1] : circular
            memory[node + offset] = next == 0 ? 0 : mask | (next & 0xFFFC)
        }
        for (index, value) in [nodes.first ?? 0, circular, UInt32(nodes.count), 1, 0, 0].enumerated() {
            memory[address + UInt32(index * 4)] = value
        }
    }
    func image(_ address: UInt32, count: Int = 9) -> [UInt32] {
        (0..<count).map { memory[address + UInt32($0 * 4), default: 0] }
    }
    var registerWrites: [DMAListTestEvent] { events.filter { if case .registerWrite = $0 { return true }; return false } }
    var memoryWrites: [DMAListTestEvent] { events.filter { if case .memoryWrite = $0 { return true }; return false } }
}

final class DMALinkedListTests: XCTestCase {
    func testNilNodeArgumentsDoNotAccessMemory() {
        let io = DMAListTestIO()
        var missing: DMANodeConfiguration?
        var configuration: DMANodeConfiguration? = .init()
        XCTAssertEqual(io.list.buildNode(nil, at: 0x2400_0100), .error)
        XCTAssertEqual(io.list.buildNode(.init(), at: 0), .error)
        XCTAssertEqual(io.list.getNodeConfiguration(at: 0x2400_0100, configuration: &missing), .error)
        XCTAssertEqual(io.list.getNodeConfiguration(at: 0, configuration: &configuration), .error)
        XCTAssertEqual(io.events, [])
    }

    func testLinearNodeLeavesTwoUnusedWordsAndMaskedTriggerUntouched() {
        for type: UInt32 in [0x21, 0x41] {
            let io = DMAListTestIO()
            let address: UInt32 = 0x2400_0100
            io.seedNode(address, words: Array(repeating: 0xA5A5_A5A5, count: 9))
            let config = DMANodeConfiguration(nodeType: type,
                configuration: .init(blockHardwareRequest: 0x800),
                trigger: .init(mode: .max, polarity: 0, selection: .max),
                repeatBlock: .init(repeatCount: 0, sourceAddressOffset: .min),
                sourceAddress: 0x1122_3344, destinationAddress: 0x5566_7788, dataSize: 0x12345)
            XCTAssertEqual(io.list.buildNode(config, at: address), .ok)
            XCTAssertEqual(io.image(address), [0, 0, 0x2345, 0x1122_3344, 0x5566_7788, 0,
                                               0xA5A5_A5A5, 0xA5A5_A5A5, type | 0x500])
            var output: DMANodeConfiguration? = .init(configuration: .init(priority: 0xDEAD, mode: 0xBEEF))
            XCTAssertEqual(io.list.getNodeConfiguration(at: address, configuration: &output), .ok)
            XCTAssertEqual(output?.configuration.blockHardwareRequest, 0)
            XCTAssertEqual(output?.configuration.priority, 0xDEAD)
            XCTAssertEqual(output?.configuration.mode, 0xBEEF)
            XCTAssertEqual(output?.repeatBlock, .init())
        }
    }

    func test2DNodeFixedEncodingAndExactWriteOffsets() {
        let io = DMAListTestIO()
        let address: UInt32 = 0x2400_0200
        let configuration = DMANodeConfiguration(nodeType: 0x42,
            configuration: .init(request: 109, blockHardwareRequest: 0x800, direction: 0x400,
                sourceIncrement: 8, destinationIncrement: 0x80000, sourceDataWidth: 3,
                destinationDataWidth: 0x30000, sourceBurstLength: 64, destinationBurstLength: 64,
                transferAllocatedPort: 0x4000_4000, transferEventMode: 0xC000_0000, mode: 0x1000),
            dataHandling: .init(alignment: 0x1000, exchange: 0x1C00_2000),
            trigger: .init(mode: 0xC000, polarity: 0x0200_0000, selection: 55),
            repeatBlock: .init(repeatCount: 2047, sourceAddressOffset: -8191, destinationAddressOffset: 8191,
                               blockSourceAddressOffset: -65535, blockDestinationAddressOffset: 65535),
            sourceAddress: 0x2000_0004, destinationAddress: 0x2400_FFF0, dataSize: .max)
        XCTAssertEqual(io.list.buildNode(configuration, at: address), .ok)
        XCTAssertEqual(io.image(address), [0x5FFB_73FB, 0xC237_D46D, 0x57FE_FFFF,
                                           0x2000_0004, 0x2400_FFF0, 0x1FFF_1FFF, .max, 0, 0x742])
        let offsets = io.memoryWrites.compactMap { event -> UInt32? in
            if case let .memoryWrite(location, _) = event { return location - address }; return nil
        }
        XCTAssertEqual(offsets, [0, 0, 4, 4, 4, 4, 8, 8, 8, 8, 8, 8, 12, 16, 20, 20, 24, 24, 28, 32, 32])
        var output: DMANodeConfiguration? = .init(configuration: .init(priority: 0xAA, mode: 0xBB))
        XCTAssertEqual(io.list.getNodeConfiguration(at: address, configuration: &output), .ok)
        XCTAssertEqual(output?.repeatBlock, configuration.repeatBlock)
        XCTAssertEqual(output?.dataHandling, configuration.dataHandling)
        XCTAssertEqual(output?.trigger, configuration.trigger)
        XCTAssertEqual(output?.configuration.priority, 0xAA)
        XCTAssertEqual(output?.configuration.mode, 0xBB)
        XCTAssertEqual(output?.configuration.blockHardwareRequest, 0)
    }

    func testRawNodeReadbackAllDirectionAndSignedOffsetBranches() {
        for software in [false, true] {
            for destination in [false, true] {
                for flags in UInt32(0)..<16 {
                    let io = DMAListTestIO()
                    io.seedNode(0x2400_0100, words: [.max, (software ? 0x200 : 0) | (destination ? 0x400 : 0) | 0x800 | 109,
                                                  (flags << 28) | 0x07FF_FFFF, 5, 7, 0x1FFF_1FFF, .max, 0, 0x742])
                    var output: DMANodeConfiguration? = .init()
                    XCTAssertEqual(io.list.getNodeConfiguration(at: 0x2400_0100, configuration: &output), .ok)
                    XCTAssertEqual(output?.configuration.request, software ? 0x200 : 109)
                    XCTAssertEqual(output?.configuration.direction, software ? 0x200 : destination ? 0x400 : 0)
                    XCTAssertEqual(output?.configuration.blockHardwareRequest, 0x800)
                    XCTAssertEqual(output?.repeatBlock.repeatCount, 2048)
                    XCTAssertEqual(output?.repeatBlock.sourceAddressOffset, flags & 1 == 0 ? 8191 : -8191)
                    XCTAssertEqual(output?.repeatBlock.destinationAddressOffset, flags & 2 == 0 ? 8191 : -8191)
                    XCTAssertEqual(output?.repeatBlock.blockSourceAddressOffset, flags & 4 == 0 ? 65535 : -65535)
                    XCTAssertEqual(output?.repeatBlock.blockDestinationAddressOffset, flags & 8 == 0 ? 65535 : -65535)
                }
            }
        }
    }

    func testLinkedListInitializePreservesCallbacksAndUses2DRegisterOrder() {
        for index in [0, 12] {
            let io = DMAListTestIO()
            io.channel = .init(controller: .hpdma1, index: index)
            io.registers[.ccr] = 0x8000_4000
            io.handleWords = [.state: 0, .lock: 1, .queueAddress: 0x2400_F000]
            io.callbackSlots[0] = dmaListTestCallback
            let configuration = DMALinkedListConfiguration(priority: 0xC00000, linkStepMode: 0x10000,
                linkAllocatedPort: 0x20000, transferEventMode: 0x8000_0000, linkedListMode: 0x81)
            XCTAssertEqual(io.driver.initializeLinkedList(configuration, getTick: io.getTick), .ok)
            var expected: [DMAListTestEvent] = [.registerWrite(.ccr, 0x8000_4006),
                .registerWrite(.ccr, 0x80C3_4006), .registerWrite(.ctr1, 0), .registerWrite(.ctr2, 0x8000_0000),
                .registerWrite(.cbr1, 0), .registerWrite(.csar, 0), .registerWrite(.cdar, 0)]
            if index == 12 { expected += [.registerWrite(.ctr3, 0), .registerWrite(.cbr2, 0)] }
            expected += [.registerWrite(.cllr, 0)]
            XCTAssertEqual(io.registerWrites, expected)
            XCTAssertEqual(io.tickCalls, 1)
            XCTAssertEqual(io.handleWords[.lock], 0)
            XCTAssertEqual(io.handleWords[.state], 1)
            XCTAssertEqual(io.handleWords[.mode], 0x81)
            XCTAssertEqual(io.handleWords[.queueAddress], 0x2400_F000)
            XCTAssertNotNil(io.callbackSlots[0])
            XCTAssertEqual(io.memoryWrites, [])
        }
    }

    func testDisableTimeoutHasNoFinalRecheckAndPreservesDeinitLock() {
        for deinitialize in [false, true] {
            let io = DMAListTestIO()
            io.ticks = .max - 2
            io.registers[.ccr] = 1
            io.handleWords = [.state: 1, .lock: 1]
            io.onTick = { if $0.tickCalls == 7 { $0.registers[.ccr] = 0 } }
            let status = deinitialize ? io.driver.deinitializeLinkedList(getTick: io.getTick) :
                io.driver.initializeLinkedList(.init(), getTick: io.getTick)
            XCTAssertEqual(status, .error)
            XCTAssertEqual(io.tickCalls, 7)
            XCTAssertEqual(io.handleWords[.state], 3)
            XCTAssertEqual(io.handleWords[.errorCode], 0x10)
            XCTAssertEqual(io.handleWords[.lock], deinitialize ? 1 : 0)
            XCTAssertEqual(io.registerWrites, [.registerWrite(.ccr, 7)])
        }
    }

    func testDeinitializeResetsRegistersCallbacksAndOnlyQueueStateAndError() {
        let io = DMAListTestIO()
        let queue: UInt32 = 0x2400_F000
        io.seedQueue(queue, nodes: [0x2400_0100], circular: 0x2400_0100)
        io.memory[queue + 12] = 2; io.memory[queue + 16] = 6; io.memory[queue + 20] = 1
        io.handleWords = [.state: 2, .lock: 1, .queueAddress: queue]
        io.channel = .init(controller: .gpdma1, index: 15)
        io.parent = UnsafeMutableRawPointer(bitPattern: 0x1234)
        for id in UInt32(0)..<5 { io.callbackSlots[id] = dmaListTestCallback }
        XCTAssertEqual(io.driver.deinitializeLinkedList(getTick: io.getTick), .ok)
        XCTAssertEqual(io.registerWrites, [.registerWrite(.ccr, 6), .registerWrite(.ccr, 0), .registerWrite(.clbar, 0),
            .registerWrite(.ctr1, 0), .registerWrite(.ctr2, 0), .registerWrite(.cbr1, 0), .registerWrite(.csar, 0),
            .registerWrite(.cdar, 0), .registerWrite(.cllr, 0), .registerWrite(.ctr3, 0), .registerWrite(.cbr2, 0),
            .registerWrite(.cfcr, 0x7F00)])
        XCTAssertEqual(io.image(queue, count: 6), [0x2400_0100, 0x2400_0100, 1, 1, 0, 1])
        XCTAssertEqual(io.memoryWrites, [.memoryWrite(queue + 12, 1), .memoryWrite(queue + 16, 0)])
        XCTAssertEqual(io.handleWords[.queueAddress], 0)
        XCTAssertEqual(io.handleWords[.state], 0)
        XCTAssertEqual(io.handleWords[.lock], 0)
        XCTAssertTrue(io.callbackSlots.isEmpty)
        XCTAssertNil(io.parent)
    }

    func testStartReadyAndStepBusyPathsInterruptsAndLock() {
        for interrupts in [false, true] {
            for type: UInt32 in [0x21, 0x42] {
                let io = DMAListTestIO()
                let queue: UInt32 = 0x2400_F000
                io.seedQueue(queue, nodes: [0x2400_0100], type: type)
                io.handleWords = [.state: 1, .queueAddress: queue, .lock: 0]
                io.callbackSlots[1] = dmaListTestCallback; io.callbackSlots[4] = dmaListTestCallback
                let status = interrupts ? io.driver.startLinkedListInterrupt() : io.driver.startLinkedList()
                XCTAssertEqual(status, .ok)
                let mask: UInt32 = type == 0x21 ? 0xF801_0100 : 0xFE01_0100
                var expected: [DMAListTestEvent] = []
                if interrupts { expected += [.registerWrite(.ccr, 0x5D00), .registerWrite(.ccr, 0x5F00), .registerWrite(.ccr, 0x7F00)] }
                expected += [.registerWrite(.clbar, 0x2400_0000), .registerWrite(.cllr, mask),
                             .registerWrite(.ccr, interrupts ? 0x7F01 : 1)]
                XCTAssertEqual(io.registerWrites, expected)
                XCTAssertEqual(io.handleWords[.lock], 1)
                XCTAssertEqual(io.memory[queue + 12], 2)
                io.events = []; io.registers[.ccr] = 0x10000
                XCTAssertEqual(interrupts ? io.driver.startLinkedListInterrupt() : io.driver.startLinkedList(), .ok)
                XCTAssertEqual(io.registerWrites, [.registerWrite(.ccr, 0x10001)])
                XCTAssertEqual(io.memoryWrites, [])
                XCTAssertFalse(io.events.contains(.handleRead(.lock)))
            }
        }
    }

    func testStartMissingQueueLockedAndInvalidState() {
        let io = DMAListTestIO()
        XCTAssertEqual(io.driver.startLinkedList(), .error)
        XCTAssertEqual(io.events, [.handleRead(.queueAddress)])
        io.events = []; io.handleWords = [.queueAddress: 0x2400_F000, .state: 1, .lock: 1]
        XCTAssertEqual(io.driver.startLinkedList(), .busy)
        XCTAssertEqual(io.memoryWrites, [])
        XCTAssertEqual(io.registerWrites, [])
        for state: UInt32 in [0, 2, 3, 4, 5, .max] {
            io.handleWords[.state] = state; io.handleWords[.lock] = 1
            XCTAssertEqual(io.driver.startLinkedList(), .error)
            XCTAssertEqual(io.handleWords[.errorCode], 0x40)
            XCTAssertEqual(io.handleWords[.lock], 0)
        }
    }

    func testLinkQueueCompatibilityAndUnlinkBusyStateRules() {
        for state: UInt32 in [0, 1, 2, 3, 4, 5, .max] {
            let io = DMAListTestIO()
            io.seedQueue(0x2400_F000, nodes: [0x2400_0100])
            io.handleWords = [.state: state, .mode: 0x80, .lock: 1]
            let expected: HALStatus = state == 2 || state == 5 ? .error : .ok
            XCTAssertEqual(io.driver.linkQueue(at: 0x2400_F000), expected)
            XCTAssertEqual(io.driver.unlinkQueue(), expected)
            if expected == .ok { XCTAssertEqual(io.handleWords[.queueAddress], 0) }
            else { XCTAssertEqual(io.handleWords[.errorCode], 0x40); XCTAssertEqual(io.handleWords[.lock], 0) }
        }
        for mode: UInt32 in [0x80, 0x81] {
            for circular: UInt32 in [0, 0x2400_0100] {
                for index in [0, 12] {
                    let io = DMAListTestIO()
                    io.channel = .init(controller: .gpdma1, index: index)
                    io.handleWords = [.state: 1, .mode: mode]
                    io.seedQueue(0x2400_F000, nodes: [0x2400_0100], type: 0x22, circular: circular)
                    let expected: HALStatus = index == 0 || ((mode == 0x81) != (circular != 0)) ? .error : .ok
                    XCTAssertEqual(io.driver.linkQueue(at: 0x2400_F000), expected)
                    if index == 0 { XCTAssertEqual(io.memory[0x2400_F010], 3) }
                    else if expected == .error { XCTAssertEqual(io.memory[0x2400_F010], 4) }
                }
            }
        }
    }
}
