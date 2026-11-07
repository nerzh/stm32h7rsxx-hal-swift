import XCTest
@testable import STM32H7RSHAL

final class DMALinkedListDynamicTests: XCTestCase {
    private let q: UInt32 = 0x2400_F000
    private let a: UInt32 = 0x2400_0100
    private let b: UInt32 = 0x2400_0200
    private let c: UInt32 = 0x2400_0300
    private let d: UInt32 = 0x2400_0400

    func testIdenticalLinearNodesHaveExactPackedImagesAndRestore() {
        let io = DMAListTestIO()
        io.seedQueue(q, nodes: [a, b, c])
        let original = [a, b, c].map { io.image($0) }
        XCTAssertEqual(io.list.convertToDynamic(in: q), .ok)
        XCTAssertEqual(io.image(a), [0, 0, 16, 0x2400_8000, 0x2400_9000, 0x1801_0200, 0, 0, 0x521])
        XCTAssertEqual(io.image(b), [0x2400_8000, 0x2400_9000, 0x1801_0300, 0, 0, 0, 0, 0, 0x221])
        XCTAssertEqual(io.image(c), [0x2400_8000, 0x2400_9000, 0, 0, 0, 0, 0, 0, 0x221])
        XCTAssertEqual(io.image(q, count: 6), [a, 0, 3, 1, 0, 1])
        io.events = []
        XCTAssertEqual(io.list.convertToStatic(in: q), .ok)
        XCTAssertEqual([a, b, c].map { io.image($0) }, original)
        XCTAssertEqual(io.events.filter { $0 == .memoryRead(0x2400_0020) }.count, 2)
        XCTAssertEqual(io.image(q, count: 6), [a, 0, 3, 1, 0, 0])
    }

    func testEveryOptionalRegisterSubsetKeepsAddressesAndRestoresAllUsedWords() {
        for type: UInt32 in [0x21, 0x22, 0x41, 0x42] {
            let twoD = type & 2 == 2
            let optional: [Int] = twoD ? [0, 1, 2, 5, 6] : [0, 1, 2]
            let offset = twoD ? 7 : 5
            for combination in 0..<(1 << optional.count) {
                let io = DMAListTestIO()
                io.seedQueue(q, nodes: [a, b], type: type)
                if twoD {
                    io.memory[a + 20] = 0x123; io.memory[a + 24] = 0x456
                    io.memory[b + 20] = 0x123; io.memory[b + 24] = 0x456
                }
                for (bit, index) in optional.enumerated() where combination & (1 << bit) != 0 {
                    io.memory[b + UInt32(index * 4), default: 0] ^= 0x8000
                }
                let originalA = io.image(a), originalB = io.image(b)
                XCTAssertEqual(io.list.convertToDynamic(in: q), .ok)
                let expectedIndices = (0..<offset).filter { index in
                    index == 3 || index == 4 || originalA[index] != originalB[index]
                }
                let packedCount = expectedIndices.count + 1
                let packed = expectedIndices.map { originalB[$0] } + [0] + Array(repeating: UInt32(0), count: 8 - packedCount)
                XCTAssertEqual(Array(io.image(b).prefix(8)), packed)
                XCTAssertEqual(io.memory[b + 32], UInt32(packedCount - 1) << 8 | type)
                XCTAssertEqual(io.list.convertToStatic(in: q), .ok)
                XCTAssertEqual(io.image(a), originalA)
                XCTAssertEqual(io.image(b), originalB)
            }
        }
    }

    func test2DIdenticalFieldsPackFiveOptionalRegistersAndClearUnusedWords() {
        let io = DMAListTestIO()
        io.seedQueue(q, nodes: [a, b, c], type: 0x42)
        for address in [a, b, c] {
            io.memory[address + 20] = 0x1234
            io.memory[address + 24] = 0x5678
        }
        XCTAssertEqual(io.list.convertToDynamic(in: q), .ok)
        XCTAssertEqual(io.image(a), [0, 0, 16, 0x2400_8000, 0x2400_9000, 0x1234, 0x5678, 0x1801_0200, 0x742])
        XCTAssertEqual(io.image(b), [0x2400_8000, 0x2400_9000, 0x1801_0300, 0, 0, 0, 0, 0, 0x242])
        XCTAssertEqual(io.image(c), [0x2400_8000, 0x2400_9000, 0, 0, 0, 0, 0, 0, 0x242])
        XCTAssertEqual(io.list.convertToStatic(in: q), .ok)
        for address in [a, b, c] {
            XCTAssertEqual(io.memory[address + 20], 0x1234)
            XCTAssertEqual(io.memory[address + 24], 0x5678)
            XCTAssertEqual(io.memory[address + 32], 0x742)
        }
    }

    func testPartialCircularConversionBypassesEntryAndRelinksTailToHeadAsCDoes() {
        let io = DMAListTestIO()
        io.seedQueue(q, nodes: [a, b, c, d], circular: b)
        XCTAssertEqual(io.list.convertToDynamic(in: q), .ok)
        XCTAssertEqual(io.memory[a + 20], 0xF801_0200)
        XCTAssertEqual(io.memory[b + 32], 0x521)
        XCTAssertEqual(io.memory[b + 20], 0x1801_0300)
        XCTAssertEqual(io.memory[c + 32], 0x221)
        XCTAssertEqual(io.memory[c + 8], 0x1801_0400)
        XCTAssertEqual(io.memory[d + 32], 0x221)
        XCTAssertEqual(io.memory[d + 8], 0xF801_0100)
        XCTAssertEqual(io.memory[q + 4], b)
        XCTAssertEqual(io.list.convertToStatic(in: q), .ok)
        XCTAssertEqual(io.memory[d + 20], 0xF801_0100)
        XCTAssertEqual(io.memory[q + 4], b)
    }

    func testLastNodeCircularDisablesULLIncludingSingleNodeQueue() {
        for count in 1...3 {
            let nodes = Array([a, b, c].prefix(count))
            let last = nodes.last!
            let io = DMAListTestIO()
            io.seedQueue(q, nodes: nodes, circular: last)
            let original = nodes.map { io.image($0) }
            XCTAssertEqual(io.list.convertToDynamic(in: q), .ok)
            let offset: UInt32 = count == 1 ? 20 : 8
            XCTAssertEqual(io.memory[last + offset], (count == 1 ? 0xF800_0000 : 0x1800_0000) | (last & 0xFFFC))
            XCTAssertEqual(io.memory[q + 4], last)
            XCTAssertEqual(io.list.convertToStatic(in: q), .ok)
            XCTAssertEqual(nodes.map { io.image($0) }, original)
        }
    }

    func testAlreadyConvertedPreservesBusyStateAndErrorAndEmptyCheckComesFirst() {
        for dynamic in [false, true] {
            let io = DMAListTestIO()
            io.seedQueue(q, nodes: [a, b])
            io.memory[q + 12] = 2; io.memory[q + 16] = 99; io.memory[q + 20] = dynamic ? 1 : 0
            XCTAssertEqual(dynamic ? io.list.convertToDynamic(in: q) : io.list.convertToStatic(in: q), .ok)
            XCTAssertEqual(io.events, [.memoryRead(q), .memoryRead(q + 20)])
            XCTAssertEqual(io.memory[q + 12], 2)
            XCTAssertEqual(io.memory[q + 16], 99)
            io.memory[q] = 0; io.events = []
            XCTAssertEqual(dynamic ? io.list.convertToDynamic(in: q) : io.list.convertToStatic(in: q), .error)
            XCTAssertEqual(io.events, [.memoryRead(q), .memoryWrite(q + 16, 2)])
        }
    }

    func testLinearUnusedWordsAreClearedByCompressionAndNotRecreated() {
        let io = DMAListTestIO()
        io.seedQueue(q, nodes: [a, b])
        io.memory[b + 24] = 0xDEAD; io.memory[b + 28] = 0xBEEF
        XCTAssertEqual(io.list.convertToDynamic(in: q), .ok)
        XCTAssertEqual(io.memory[b + 24], 0); XCTAssertEqual(io.memory[b + 28], 0)
        XCTAssertEqual(io.list.convertToStatic(in: q), .ok)
        XCTAssertEqual(io.memory[b + 24], 0); XCTAssertEqual(io.memory[b + 28], 0)
    }
}
