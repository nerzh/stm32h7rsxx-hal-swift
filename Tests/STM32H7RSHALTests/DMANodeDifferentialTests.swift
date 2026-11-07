import XCTest
import CDMAReference
@testable import STM32H7RSHAL

// Only the unchanged C BuildNode/GetNodeConfig operations run here. They never
// walk a uint32_t-cast host pointer. Swift uses the same nine C node words behind
// the target's logical address; queue walks are compared on the ARM board.
private final class DMANodeOracleMemory: DMAMemoryIO {
    var storage = CDMAState()
    var list: DMALinkedList<DMANodeOracleMemory> { .init(memory: self) }

    init() {
        CDMA_Reset(&storage, 0, 0)
        for index: UInt32 in 0..<9 {
            write32(at: storage.nodeAddress + index * 4, value: 0xA5A5_0000 | index)
        }
        storage.nodeConfiguration.Init.Priority = 0x8765_4321
    }

    func read32(at address: UInt32) -> UInt32 {
        precondition(address >= storage.nodeAddress && address < storage.nodeAddress + 36 && address & 3 == 0)
        let index = Int((address - storage.nodeAddress) / 4)
        return withUnsafeBytes(of: &storage.node) { $0.bindMemory(to: UInt32.self)[index] }
    }

    func write32(at address: UInt32, value: UInt32) {
        precondition(address >= storage.nodeAddress && address < storage.nodeAddress + 36 && address & 3 == 0)
        let index = Int((address - storage.nodeAddress) / 4)
        withUnsafeMutableBytes(of: &storage.node) { $0.bindMemory(to: UInt32.self)[index] = value }
    }

    func nodeWords() -> [UInt32] {
        withUnsafeBytes(of: &storage.node) { Array($0.bindMemory(to: UInt32.self)) }
    }

    func configuration() -> DMANodeConfiguration {
        let c = storage.nodeConfiguration
        return .init(nodeType: c.NodeType, configuration: .init(
            request: c.Init.Request, blockHardwareRequest: c.Init.BlkHWRequest, direction: c.Init.Direction,
            sourceIncrement: c.Init.SrcInc, destinationIncrement: c.Init.DestInc,
            sourceDataWidth: c.Init.SrcDataWidth, destinationDataWidth: c.Init.DestDataWidth,
            priority: c.Init.Priority, sourceBurstLength: c.Init.SrcBurstLength,
            destinationBurstLength: c.Init.DestBurstLength, transferAllocatedPort: c.Init.TransferAllocatedPort,
            transferEventMode: c.Init.TransferEventMode, mode: c.Init.Mode),
            dataHandling: .init(alignment: c.DataHandlingConfig.DataAlignment, exchange: c.DataHandlingConfig.DataExchange),
            trigger: .init(mode: c.TriggerConfig.TriggerMode, polarity: c.TriggerConfig.TriggerPolarity,
                           selection: c.TriggerConfig.TriggerSelection),
            repeatBlock: .init(repeatCount: c.RepeatBlockConfig.RepeatCount,
                               sourceAddressOffset: c.RepeatBlockConfig.SrcAddrOffset,
                               destinationAddressOffset: c.RepeatBlockConfig.DestAddrOffset,
                               blockSourceAddressOffset: c.RepeatBlockConfig.BlkSrcAddrOffset,
                               blockDestinationAddressOffset: c.RepeatBlockConfig.BlkDestAddrOffset),
            sourceAddress: c.SrcAddress, destinationAddress: c.DstAddress, dataSize: c.DataSize)
    }
}

final class DMANodeDifferentialTests: XCTestCase {
    private func compareStorage(_ swift: DMANodeOracleMemory, _ reference: DMANodeOracleMemory, _ message: String,
                                file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(swift.nodeWords(), reference.nodeWords(), "\(message) all nine node words", file: file, line: line)
        XCTAssertEqual(swift.storage.tickCalls, 0, message, file: file, line: line)
        XCTAssertEqual(reference.storage.tickCalls, 0, message, file: file, line: line)
        XCTAssertEqual(swift.storage.callbackCount, 0, message, file: file, line: line)
        XCTAssertEqual(reference.storage.callbackCount, 0, message, file: file, line: line)
        for word: UInt32 in 0..<5 {
            XCTAssertEqual(CDMA_GetHandle(&swift.storage, word), CDMA_GetHandle(&reference.storage, word),
                           "\(message) handle \(word)", file: file, line: line)
        }
        for value: UInt32 in 0..<CDMA_RegisterCount.rawValue {
            let register = CDMARegister(rawValue: value)
            XCTAssertEqual(CDMA_Get(&swift.storage, register), CDMA_Get(&reference.storage, register),
                           "\(message) register \(value)", file: file, line: line)
        }
    }

    private func compareGet(_ swift: DMANodeOracleMemory, _ reference: DMANodeOracleMemory, _ message: String,
                            file: StaticString = #filePath, line: UInt = #line) {
        let beforeSwift = swift.nodeWords()
        let beforeC = reference.nodeWords()
        let originalC = reference.configuration()
        var result: DMANodeConfiguration? = swift.storage.nullMask & 2 == 0 ? swift.configuration() : nil
        let address = swift.storage.nullMask & 4 == 0 ? swift.storage.nodeAddress : 0
        let status = swift.list.getNodeConfiguration(at: address, configuration: &result)
        XCTAssertEqual(status.rawValue, CDMA_Call(&reference.storage, CDMA_GetNodeConfiguration, 0, 0, 0),
                       message, file: file, line: line)
        if let result { XCTAssertEqual(result, reference.configuration(), message, file: file, line: line) }
        if status != .ok {
            XCTAssertEqual(originalC, reference.configuration(), "\(message) failed get preserves output", file: file, line: line)
        }
        XCTAssertEqual(swift.nodeWords(), beforeSwift, "\(message) get preserves Swift node", file: file, line: line)
        XCTAssertEqual(reference.nodeWords(), beforeC, "\(message) get preserves C node", file: file, line: line)
        compareStorage(swift, reference, message, file: file, line: line)
    }

    private func checkBuild(_ message: String = "", seed: (DMANodeOracleMemory) -> Void = { _ in },
                            file: StaticString = #filePath, line: UInt = #line) {
        let swift = DMANodeOracleMemory(), reference = DMANodeOracleMemory()
        seed(swift); seed(reference)
        let original = reference.configuration()
        let configuration: DMANodeConfiguration? = swift.storage.nullMask & 2 == 0 ? swift.configuration() : nil
        let address = swift.storage.nullMask & 4 == 0 ? swift.storage.nodeAddress : 0
        let status = swift.list.buildNode(configuration, at: address)
        XCTAssertEqual(status.rawValue, CDMA_Call(&reference.storage, CDMA_BuildNode, 0, 0, 0),
                       message, file: file, line: line)
        XCTAssertEqual(original, reference.configuration(), "\(message) build preserves config", file: file, line: line)
        compareStorage(swift, reference, message, file: file, line: line)
        if status == .ok {
            // Readback must preserve these two configuration fields even though
            // their values do not come from the constructed register image.
            swift.storage.nodeConfiguration.Init.Priority = 0xDEAD_BEEF
            reference.storage.nodeConfiguration.Init.Priority = 0xDEAD_BEEF
            swift.storage.nodeConfiguration.Init.Mode = 0xA55A_5AA5
            reference.storage.nodeConfiguration.Init.Mode = 0xA55A_5AA5
            compareGet(swift, reference, "\(message) round trip", file: file, line: line)
        }
    }

    private func checkGet(_ message: String = "", seed: (DMANodeOracleMemory) -> Void,
                         file: StaticString = #filePath, line: UInt = #line) {
        let swift = DMANodeOracleMemory(), reference = DMANodeOracleMemory()
        seed(swift); seed(reference)
        compareGet(swift, reference, message, file: file, line: line)
    }

    func testAllNodeTypesWidthsIncrementsAndBurstBoundariesRoundTrip() {
        for type: UInt32 in [0x21, 0x22, 0x41, 0x42] {
            for sourceWidth: UInt32 in 0...3 {
                for destinationWidth: UInt32 in 0...3 {
                    for increments: UInt32 in 0..<4 {
                        for sourceBurst: UInt32 in [1, 2, 63, 64] {
                            for destinationBurst: UInt32 in [1, 2, 63, 64] {
                                checkBuild("type\(type) width\(sourceWidth)/\(destinationWidth) inc\(increments) burst\(sourceBurst)/\(destinationBurst)") { io in
                                    io.storage.nodeConfiguration.NodeType = type
                                    io.storage.nodeConfiguration.Init.SrcDataWidth = sourceWidth
                                    io.storage.nodeConfiguration.Init.DestDataWidth = destinationWidth << 16
                                    io.storage.nodeConfiguration.Init.SrcInc = increments & 1 == 0 ? 0 : 8
                                    io.storage.nodeConfiguration.Init.DestInc = increments & 2 == 0 ? 0 : 0x80000
                                    io.storage.nodeConfiguration.Init.SrcBurstLength = sourceBurst
                                    io.storage.nodeConfiguration.Init.DestBurstLength = destinationBurst
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func testEveryRequestDirectionAndIgnoredBlockHardwareRequest() {
        for type: UInt32 in [0x21, 0x22, 0x41, 0x42] {
            for request in Array(UInt32(0)...109) + [0x200] {
                for direction: UInt32 in [0, 0x200, 0x400] {
                    for block: UInt32 in [0, 0x800] {
                        checkBuild("type\(type) request\(request) direction\(direction) block\(block)") { io in
                            io.storage.nodeConfiguration.NodeType = type
                            io.storage.nodeConfiguration.Init.Request = request
                            io.storage.nodeConfiguration.Init.Direction = direction
                            io.storage.nodeConfiguration.Init.BlkHWRequest = block
                            io.storage.nodeConfiguration.Init.Mode = request & 1 == 0 ? 0 : 0x1000
                            io.storage.nodeConfiguration.Init.TransferEventMode = (request & 3) << 30
                        }
                    }
                }
            }
        }
    }

    func testAllExchangeAlignmentAndPortCombinations() {
        for type: UInt32 in [0x21, 0x22, 0x41, 0x42] {
            for bits: UInt32 in 0..<16 {
                let exchange = ((bits & 1) << 13) | ((bits & 14) << 25)
                for alignment: UInt32 in [0, 0x800, 0x1000] {
                    for ports: UInt32 in [0, 0x4000, 0x40000000, 0x40004000] {
                        checkBuild("type\(type) exchange\(exchange) alignment\(alignment) ports\(ports)") { io in
                            io.storage.nodeConfiguration.NodeType = type
                            io.storage.nodeConfiguration.DataHandlingConfig.DataExchange = exchange
                            io.storage.nodeConfiguration.DataHandlingConfig.DataAlignment = alignment
                            io.storage.nodeConfiguration.Init.TransferAllocatedPort = ports
                        }
                    }
                }
            }
        }
    }

    func testEveryTriggerSourceModeAndPolarity() {
        for type: UInt32 in [0x21, 0x22, 0x41, 0x42] {
            for source: UInt32 in 0...55 {
                for mode: UInt32 in [0, 0x4000, 0x8000, 0xC000] {
                    for polarity: UInt32 in [0, 0x01000000, 0x02000000] {
                        checkBuild("type\(type) source\(source) mode\(mode) polarity\(polarity)") { io in
                            io.storage.nodeConfiguration.NodeType = type
                            io.storage.nodeConfiguration.TriggerConfig.TriggerSelection = source
                            io.storage.nodeConfiguration.TriggerConfig.TriggerMode = mode
                            io.storage.nodeConfiguration.TriggerConfig.TriggerPolarity = polarity
                        }
                    }
                }
            }
        }
    }

    func testTwoDimensionalRepeatCountsAndAllOffsetSignsAndBounds() {
        for type: UInt32 in [0x22, 0x42] {
            for count: UInt32 in [1, 2, 2047] {
                for source: Int32 in [-8191, -1, 0, 1, 8191] {
                    for destination: Int32 in [-8191, -1, 0, 1, 8191] {
                        for blockSource: Int32 in [-65535, 0, 65535] {
                            for blockDestination: Int32 in [-65535, 0, 65535] {
                                checkBuild("type\(type) count\(count) offsets\(source)/\(destination)/\(blockSource)/\(blockDestination)") { io in
                                    io.storage.nodeConfiguration.NodeType = type
                                    io.storage.nodeConfiguration.RepeatBlockConfig.RepeatCount = count
                                    io.storage.nodeConfiguration.RepeatBlockConfig.SrcAddrOffset = source
                                    io.storage.nodeConfiguration.RepeatBlockConfig.DestAddrOffset = destination
                                    io.storage.nodeConfiguration.RepeatBlockConfig.BlkSrcAddrOffset = blockSource
                                    io.storage.nodeConfiguration.RepeatBlockConfig.BlkDestAddrOffset = blockDestination
                                    io.storage.nodeConfiguration.DataSize = 65535
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func testRawAddressesAndMaskedDataSizeWithoutInventedValidation() {
        for type: UInt32 in [0x21, 0x22, 0x41, 0x42] {
            for count: UInt32 in [0, 1, 65535, 65536, UInt32.max] {
                for address: UInt32 in [0, 1, 0x24001234, 0xFFFFFFFF] {
                    checkBuild("type\(type) bytes\(count) address\(address)") { io in
                        io.storage.nodeConfiguration.NodeType = type
                        io.storage.nodeConfiguration.DataSize = count
                        io.storage.nodeConfiguration.SrcAddress = address
                        io.storage.nodeConfiguration.DstAddress = ~address
                    }
                }
            }
        }
    }

    func testDisabledTriggerAndLinearRepeatFieldsAreIgnored() {
        for type: UInt32 in [0x21, 0x41] {
            checkBuild("linear type\(type) ignored fields") { io in
                io.storage.nodeConfiguration.NodeType = type
                io.storage.nodeConfiguration.TriggerConfig.TriggerPolarity = 0
                io.storage.nodeConfiguration.TriggerConfig.TriggerMode = UInt32.max
                io.storage.nodeConfiguration.TriggerConfig.TriggerSelection = UInt32.max
                io.storage.nodeConfiguration.RepeatBlockConfig.RepeatCount = 0
                io.storage.nodeConfiguration.RepeatBlockConfig.SrcAddrOffset = Int32.min
                io.storage.nodeConfiguration.RepeatBlockConfig.DestAddrOffset = Int32.max
                io.storage.nodeConfiguration.RepeatBlockConfig.BlkSrcAddrOffset = Int32.min
                io.storage.nodeConfiguration.RepeatBlockConfig.BlkDestAddrOffset = Int32.max
            }
        }
    }

    func testNullConfigurationAndNodePreserveStorageForBothOperations() {
        for mask: UInt32 in [2, 4, 6] {
            checkBuild("null mask\(mask)") { io in io.storage.nullMask = mask }
            checkGet("null mask\(mask)") { io in io.storage.nullMask = mask }
        }
    }

    func testGetDecodesEveryBitAndItsComplementWithoutModifyingNode() {
        for type: UInt32 in [0x21, 0x22, 0x41, 0x42] {
            for index: UInt32 in 0..<8 {
                for bit: UInt32 in 0..<32 {
                    for inverted in [false, true] {
                        let value = inverted ? ~(UInt32(1) << bit) : (UInt32(1) << bit)
                        checkGet("type\(type) word\(index) bit\(bit) inverted\(inverted)") { io in
                            for word: UInt32 in 0..<8 { io.write32(at: io.storage.nodeAddress + word * 4, value: 0) }
                            io.write32(at: io.storage.nodeAddress + index * 4, value: value)
                            io.write32(at: io.storage.nodeAddress + 32, value: type | 0xFFFF_FF00)
                            io.storage.nodeConfiguration.Init.Mode = 0xA55A5AA5
                        }
                    }
                }
            }
        }
    }

    func testGetAllRawNodeTypesAndRepeatSignsPreservesPriorityAndMode() {
        for type: UInt32 in 0..<256 {
            for signs: UInt32 in 0..<16 {
                checkGet("raw type\(type) signs\(signs)") { io in
                    for word: UInt32 in 0..<8 { io.write32(at: io.storage.nodeAddress + word * 4, value: UInt32.max) }
                    io.write32(at: io.storage.nodeAddress + 8, value: 0x07FFFFFF | (signs << 28))
                    io.write32(at: io.storage.nodeAddress + 32, value: 0xA55A5A00 | type)
                    io.storage.nodeConfiguration.Init.Priority = UInt32.max
                    io.storage.nodeConfiguration.Init.Mode = UInt32.max
                }
            }
        }
    }
}
