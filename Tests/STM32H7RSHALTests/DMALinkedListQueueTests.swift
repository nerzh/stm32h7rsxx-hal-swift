import XCTest
@testable import STM32H7RSHAL

final class DMALinkedListQueueTests: XCTestCase {
    private let q: UInt32 = 0x2400_F000
    private let other: UInt32 = 0x2400_F100
    private let a: UInt32 = 0x2400_0100
    private let b: UInt32 = 0x2400_0200
    private let c: UInt32 = 0x2400_0300
    private let d: UInt32 = 0x2400_0400
    private let e: UInt32 = 0x2400_0500

    private func assertQueue(_ io: DMAListTestIO, nodes: [UInt32], circular: UInt32 = 0,
                             at address: UInt32? = nil, type: UInt32 = 0x21,
                             file: StaticString = #filePath, line: UInt = #line) {
        let queue = address ?? q
        let offset: UInt32 = type & 2 == 2 ? 28 : 20
        let mask: UInt32 = type & 2 == 2 ? 0xFE01_0000 : 0xF801_0000
        XCTAssertEqual(io.image(queue, count: 6), [nodes.first ?? 0, circular, UInt32(nodes.count),
                                                  nodes.isEmpty ? 0 : 1, 0, 0], file: file, line: line)
        for (index, node) in nodes.enumerated() {
            let next = index + 1 == nodes.count ? circular : nodes[index + 1]
            XCTAssertEqual(io.memory[node + offset], next == 0 ? 0 : mask | (next & 0xFFFC), file: file, line: line)
        }
    }

    func testNullArgumentsForEveryMemoryOperation() {
        let io = DMAListTestIO()
        let statuses = [io.list.insertNode(in: 0, after: 0, node: a),
            io.list.insertNode(in: q, after: a, node: 0), io.list.insertNodeAtHead(in: 0, node: a),
            io.list.insertNodeAtTail(in: q, node: 0), io.list.removeNode(from: 0, node: a),
            io.list.removeNode(from: q, node: 0), io.list.removeNodeAtHead(from: 0),
            io.list.removeNodeAtTail(from: 0), io.list.replaceNode(in: q, node: 0, with: a),
            io.list.replaceNodeAtHead(in: 0, with: a), io.list.replaceNodeAtTail(in: q, with: 0),
            io.list.resetQueue(at: 0), io.list.insertQueue(in: 0, after: 0, queue: other),
            io.list.insertQueueAtHead(in: q, queue: 0), io.list.insertQueueAtTail(in: 0, queue: other),
            io.list.configureCircularMode(in: q, firstCircularNode: 0), io.list.setCircularMode(in: 0),
            io.list.clearCircularMode(in: 0), io.list.convertToDynamic(in: 0), io.list.convertToStatic(in: 0)]
        XCTAssertTrue(statuses.allSatisfy { $0 == .error })
        XCTAssertEqual(io.events, [])
    }

    func testInsertNodeAllPositionsAndCircularTails() {
        for type: UInt32 in [0x21, 0x22, 0x41, 0x42] {
            for circular in [UInt32(0), a, b, c] {
                for position in 0...3 {
                    let io = DMAListTestIO()
                    io.seedQueue(q, nodes: [a, b, c], type: type, circular: circular)
                    io.seedNode(d, type: type)
                    let previous: UInt32 = position == 0 ? 0 : [a, b, c][position - 1]
                    XCTAssertEqual(io.list.insertNode(in: q, after: previous, node: d), .ok)
                    var expected = [a, b, c]; expected.insert(d, at: position)
                    assertQueue(io, nodes: expected, circular: circular, type: type)
                }
            }
        }
    }

    func testSpecialHeadTailAndEmptyQueueDoNotClearNewNodeLink() {
        for operation in 0..<3 {
            let io = DMAListTestIO()
            io.seedNode(a); io.memory[a + 20] = 0xABCD
            let status: HALStatus
            switch operation {
            case 0: status = io.list.insertNode(in: q, after: 0, node: a)
            case 1: status = io.list.insertNodeAtHead(in: q, node: a)
            default: status = io.list.insertNodeAtTail(in: q, node: a)
            }
            XCTAssertEqual(status, .ok)
            XCTAssertEqual(io.memory[a + 20], 0xABCD)
            XCTAssertEqual(io.image(q, count: 6), [a, 0, 1, 1, 0, 0])
            if operation == 2 { XCTAssertFalse(io.memoryWrites.contains(.memoryWrite(q + 12, 2))) }
            else { XCTAssertTrue(io.memoryWrites.contains(.memoryWrite(q + 12, 2))) }
        }
        let io = DMAListTestIO()
        io.seedNode(a); io.seedNode(b)
        XCTAssertEqual(io.list.insertNode(in: q, after: a, node: b), .ok)
        assertQueue(io, nodes: [a, b])
        io.seedNode(c)
        XCTAssertEqual(io.list.setCircularMode(in: q), .ok)
        XCTAssertEqual(io.list.insertNodeAtHead(in: q, node: c), .ok)
        assertQueue(io, nodes: [c, a, b], circular: a)
        io.seedNode(d)
        XCTAssertEqual(io.list.insertNodeAtTail(in: q, node: d), .ok)
        assertQueue(io, nodes: [c, a, b, d], circular: a)
    }

    func testBaseORComparisonAndTypeChecksAreLiteral() {
        let io = DMAListTestIO()
        let head: UInt32 = 0x2403_0100
        let overlapsBase: UInt32 = 0x2401_0200
        io.seedQueue(q, nodes: [head]); io.seedNode(overlapsBase)
        XCTAssertEqual(io.list.insertNodeAtHead(in: q, node: overlapsBase), .ok)
        XCTAssertEqual(io.memory[q], overlapsBase)
        let rejected = DMAListTestIO()
        rejected.seedQueue(q, nodes: [head]); rejected.seedNode(0x2404_0200)
        XCTAssertEqual(rejected.list.insertNodeAtTail(in: q, node: 0x2404_0200), .error)
        XCTAssertEqual(rejected.memoryWrites, [.memoryWrite(q + 16, 5)])
        let wrongType = DMAListTestIO()
        wrongType.seedQueue(q, nodes: [a]); wrongType.seedNode(b, type: 0x42)
        XCTAssertEqual(wrongType.list.insertNodeAtHead(in: q, node: b), .error)
        XCTAssertEqual(wrongType.memoryWrites, [.memoryWrite(q + 16, 4)])
    }

    func testFailedNodeSearchLeavesQueueBusyAndResetThenRejectsIt() {
        for operation in 0..<4 {
            let io = DMAListTestIO()
            io.seedQueue(q, nodes: [a, b]); io.seedNode(c); io.seedNode(d)
            let status: HALStatus
            switch operation {
            case 0: status = io.list.insertNode(in: q, after: c, node: d)
            case 1: status = io.list.removeNode(from: q, node: c)
            case 2: status = io.list.replaceNode(in: q, node: c, with: d)
            default: status = io.list.configureCircularMode(in: q, firstCircularNode: c)
            }
            XCTAssertEqual(status, .error)
            XCTAssertEqual(io.memory[q + 12], 2)
            XCTAssertEqual(io.memory[q + 16], 6)
            XCTAssertEqual(io.memory[q + 8], 2)
            XCTAssertEqual(io.list.resetQueue(at: q), .error)
            XCTAssertEqual(io.memory[q + 16], 1)
        }
    }

    func testRemoveEveryPositionAndCircularBoundary() {
        for count in 1...3 {
            let nodes = Array([a, b, c].prefix(count))
            for circular in [UInt32(0)] + nodes {
                for removed in nodes {
                    let io = DMAListTestIO()
                    io.seedQueue(q, nodes: nodes, circular: circular)
                    XCTAssertEqual(io.list.removeNode(from: q, node: removed), .ok)
                    let expected = nodes.filter { $0 != removed }
                    let expectedCircular: UInt32 = removed == circular || removed == nodes.last ? 0 : circular
                    assertQueue(io, nodes: expected, circular: expectedCircular)
                    XCTAssertEqual(io.memory[removed + 20], 0)
                }
            }
        }
    }

    func testHeadTailRemovalAndResetUnlinkOnlyLinkWords() {
        for head in [false, true] {
            for count in 1...3 {
                let nodes = Array([a, b, c].prefix(count))
                let io = DMAListTestIO()
                io.seedQueue(q, nodes: nodes, circular: a)
                XCTAssertEqual(head ? io.list.removeNodeAtHead(from: q) : io.list.removeNodeAtTail(from: q), .ok)
                assertQueue(io, nodes: head ? Array(nodes.dropFirst()) : Array(nodes.dropLast()))
            }
        }
        let io = DMAListTestIO()
        io.seedQueue(q, nodes: [a, b, c], circular: b)
        let dataWords = [a, b, c].map { Array(io.image($0).prefix(5)) }
        XCTAssertEqual(io.list.resetQueue(at: q), .ok)
        assertQueue(io, nodes: [])
        for (index, address) in [a, b, c].enumerated() {
            XCTAssertEqual(io.memory[address + 20], 0)
            XCTAssertEqual(Array(io.image(address).prefix(5)), dataWords[index])
        }
    }

    func testReplaceEveryPositionAndCircularBoundary() {
        for count in 1...3 {
            let nodes = Array([a, b, c].prefix(count))
            for circular in [UInt32(0)] + nodes {
                for replaced in nodes {
                    let io = DMAListTestIO()
                    io.seedQueue(q, nodes: nodes, circular: circular); io.seedNode(d)
                    XCTAssertEqual(io.list.replaceNode(in: q, node: replaced, with: d), .ok)
                    assertQueue(io, nodes: nodes.map { $0 == replaced ? d : $0 },
                                circular: circular == replaced ? d : circular)
                    XCTAssertEqual(io.memory[replaced + 20], 0)
                }
            }
        }
    }

    func testHeadTailReplacementAndSingletonTailBaseWriteQuirk() {
        for head in [false, true] {
            for count in 1...3 {
                let nodes = Array([a, b, c].prefix(count))
                for circular in [UInt32(0)] + nodes {
                    let io = DMAListTestIO()
                    io.seedQueue(q, nodes: nodes, circular: circular); io.seedNode(d)
                    let replaced = head ? nodes[0] : nodes.last!
                    XCTAssertEqual(head ? io.list.replaceNodeAtHead(in: q, with: d) :
                                    io.list.replaceNodeAtTail(in: q, with: d), .ok)
                    assertQueue(io, nodes: nodes.map { $0 == replaced ? d : $0 },
                                circular: circular == replaced ? d : circular)
                    if !head && count == 1 {
                        XCTAssertTrue(io.memoryWrites.contains(.memoryWrite(0x2400_0014, 0xF801_0400)))
                    }
                }
            }
        }
        let io = DMAListTestIO()
        io.seedQueue(q, nodes: [a, b]); io.seedNode(0x2404_0300)
        XCTAssertEqual(io.list.replaceNodeAtTail(in: q, with: 0x2404_0300), .ok)
        XCTAssertEqual(io.memory[b + 20], 0)
        XCTAssertEqual(io.memory[a + 20], 0xF801_0300)
    }

    func testInsertQueueAllPositionsCleansSourceAndPreservesCircularDestination() {
        for circular in [UInt32(0), a, b, c] {
            for position in 0...3 {
                let io = DMAListTestIO()
                io.seedQueue(q, nodes: [a, b, c], circular: circular)
                io.seedQueue(other, nodes: [d, e])
                let previous: UInt32 = position == 0 ? 0 : [a, b, c][position - 1]
                XCTAssertEqual(io.list.insertQueue(in: q, after: previous, queue: other), .ok)
                var expected = [a, b, c]; expected.insert(contentsOf: [d, e], at: position)
                assertQueue(io, nodes: expected, circular: position == 0 && circular == a ? d : circular)
                assertQueue(io, nodes: [], at: other)
            }
        }
    }

    func testQueueHeadTailAndEmptyDestinationBranches() {
        for operation in 0..<3 {
            for empty in [false, true] {
                let io = DMAListTestIO()
                io.seedQueue(q, nodes: empty ? [] : [a, b], circular: empty ? 0 : a)
                io.seedQueue(other, nodes: [c, d])
                let status: HALStatus
                switch operation {
                case 0: status = io.list.insertQueue(in: q, after: 0, queue: other)
                case 1: status = io.list.insertQueueAtHead(in: q, queue: other)
                default: status = io.list.insertQueueAtTail(in: q, queue: other)
                }
                XCTAssertEqual(status, .ok)
                assertQueue(io, nodes: empty ? [c, d] : operation == 2 ? [a, b, c, d] : [c, d, a, b],
                            circular: empty ? 0 : operation == 2 ? a : c)
                assertQueue(io, nodes: [], at: other)
            }
        }
    }

    func testSourceCircularQueueOnlyRejectedByGeneralInsertAndFailedSearchKeepsBothBusy() {
        for operation in 0..<3 {
            let io = DMAListTestIO()
            io.seedQueue(q, nodes: []); io.seedQueue(other, nodes: [a, b], circular: a)
            let status: HALStatus
            switch operation {
            case 0: status = io.list.insertQueue(in: q, after: 0, queue: other)
            case 1: status = io.list.insertQueueAtHead(in: q, queue: other)
            default: status = io.list.insertQueueAtTail(in: q, queue: other)
            }
            XCTAssertEqual(status, operation == 0 ? .error : .ok)
            if operation == 0 { XCTAssertEqual(io.memoryWrites, [.memoryWrite(other + 16, 4)]) }
            else {
                XCTAssertEqual(io.image(q, count: 6), [a, 0, 2, 1, 0, 0])
                XCTAssertEqual(io.memory[b + 20], 0xF801_0100)
                assertQueue(io, nodes: [], at: other)
            }
        }
        let io = DMAListTestIO()
        io.seedQueue(q, nodes: [a, b]); io.seedQueue(other, nodes: [c]); io.seedNode(d)
        XCTAssertEqual(io.list.insertQueue(in: q, after: d, queue: other), .error)
        XCTAssertEqual(io.memory[q + 12], 2); XCTAssertEqual(io.memory[other + 12], 2)
        XCTAssertEqual(io.memory[q + 16], 6); XCTAssertEqual(io.memory[other + 16], 0)
    }

    func testCircularModeNoOpPrecedenceAndDynamicMutationRejection() {
        let io = DMAListTestIO()
        io.seedQueue(q, nodes: [a, b, c])
        XCTAssertEqual(io.list.configureCircularMode(in: q, firstCircularNode: b), .ok)
        assertQueue(io, nodes: [a, b, c], circular: b)
        io.memory[q + 20] = 1; io.memory[q + 16] = 99; io.events = []
        XCTAssertEqual(io.list.configureCircularMode(in: q, firstCircularNode: b), .ok)
        XCTAssertEqual(io.memoryWrites, [])
        XCTAssertEqual(io.list.configureCircularMode(in: q, firstCircularNode: a), .error)
        XCTAssertEqual(io.memory[q + 16], 4)
        XCTAssertEqual(io.list.clearCircularMode(in: q), .error)
        io.memory[q + 20] = 0
        XCTAssertEqual(io.list.clearCircularMode(in: q), .ok)
        assertQueue(io, nodes: [a, b, c])
        XCTAssertEqual(io.list.setCircularMode(in: q), .ok)
        assertQueue(io, nodes: [a, b, c], circular: a)
        io.memory[q + 20] = 1; io.memory[q + 16] = 99; io.events = []
        XCTAssertEqual(io.list.setCircularMode(in: q), .ok)
        XCTAssertEqual(io.memoryWrites, [])
        io.memory[q + 4] = 0; io.events = []
        XCTAssertEqual(io.list.clearCircularMode(in: q), .ok)
        XCTAssertEqual(io.memoryWrites, [])
        XCTAssertEqual(io.list.insertNodeAtHead(in: q, node: d), .error)
        XCTAssertEqual(io.memory[q + 16], 4)
    }
}
