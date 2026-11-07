import XCTest
@testable import STM32H7RSHAL

private enum CRCAccess: Equatable {
    case read(CRCRegister)
    case write(CRCRegister, UInt32)
    case write8(UInt8)
    case write16(UInt16)
    case mspInitialize
    case mspDeinitialize
}

private final class CRCTrace {
    var values: [CRCRegister: UInt32] = [:]
    var accesses: [CRCAccess] = []
    var result: UInt32 = 0xD00D_BEEF
}

private struct CRCTraceIO: CRCRegisterIO {
    let trace: CRCTrace

    mutating func read(_ register: CRCRegister) -> UInt32 {
        trace.accesses.append(.read(register))
        return register == .dr ? trace.result : trace.values[register, default: 0]
    }

    mutating func write(_ register: CRCRegister, value: UInt32) {
        trace.accesses.append(.write(register, value))
        // The model deliberately does not calculate CRCs. DR reads return a
        // separately supplied hardware result, never the last data write.
        if register != .dr {
            trace.values[register] = register == .cr ? value & ~UInt32(1) : value
        }
    }

    mutating func writeData8(_ value: UInt8) { trace.accesses.append(.write8(value)) }
    mutating func writeData16(_ value: UInt16) { trace.accesses.append(.write16(value)) }
}

final class CRCTests: XCTestCase {
    func testDefaultInitializationOrderAndResetOnlyMSPHook() {
        let trace = CRCTrace()
        trace.values[.cr] = 0x8000_00F8
        var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: .bytes)
        crc.lock = .locked
        XCTAssertEqual(crc.initialize { handle in
            XCTAssertEqual(handle.getState(), .reset)
            XCTAssertEqual(handle.lock, .unlocked)
            XCTAssertTrue(trace.accesses.isEmpty)
            trace.accesses.append(.mspInitialize)
            handle.lock = .locked
        }, .ok)
        XCTAssertEqual(trace.accesses, [
            .mspInitialize, .write(.polynomial, 0x04C1_1DB7),
            .read(.cr), .write(.cr, 0x8000_00E0),
            .write(.initialValue, 0xFFFF_FFFF),
            .read(.cr), .write(.cr, 0x8000_0080),
            .read(.cr), .write(.cr, 0x8000_0000),
        ])
        XCTAssertEqual(crc.state, .ready)
        XCTAssertEqual(crc.lock, .locked)
        trace.accesses = []
        XCTAssertEqual(crc.initialize { _ in XCTFail("MSP must only run in RESET") }, .ok)
        XCTAssertEqual(crc.lock, .locked)
        XCTAssertFalse(trace.accesses.contains(.mspInitialize))
    }

    func testMSPCanChangeConfigurationAndInputFormatBeforeInitializationReadsThem() {
        let trace = CRCTrace()
        trace.values[.cr] = 0x8000_0000
        var crc = CRC(registers: CRCTraceIO(trace: trace))
        let custom = CRCConfiguration(
            usesDefaultPolynomial: false, usesDefaultInitialValue: false,
            generatingPolynomial: 0x65, length: .bits7, initialValue: 0xA6,
            inputInversion: .halfword, outputInversion: .enabled
        )
        XCTAssertEqual(crc.initialize { handle in
            handle.configuration = custom
            handle.inputDataFormat = .halfwords
        }, .ok)
        XCTAssertEqual(trace.accesses, [
            .write(.polynomial, 0x65), .read(.cr), .write(.cr, 0x8000_0018),
            .write(.initialValue, 0xA6), .read(.cr), .write(.cr, 0x8000_0058),
            .read(.cr), .write(.cr, 0x8000_00D8),
        ])
        XCTAssertEqual(crc.configuration, custom)
        XCTAssertEqual(crc.state, .ready)
    }

    func testInitializationFailureLeavesBusyAndOnlyResetPathUnlocks() {
        for initialState in CRCState.allCases {
            let trace = CRCTrace()
            var crc = CRC(registers: CRCTraceIO(trace: trace), configuration: .init(
                usesDefaultPolynomial: false, generatingPolynomial: 0x10001, length: .bits16
            ), inputDataFormat: .words)
            crc.state = initialState
            crc.lock = .locked
            var callbacks = 0
            XCTAssertEqual(crc.initialize { _ in callbacks += 1 }, .error)
            XCTAssertEqual(callbacks, initialState == .reset ? 1 : 0)
            XCTAssertEqual(crc.state, .busy)
            XCTAssertEqual(crc.lock, initialState == .reset ? .unlocked : .locked)
            XCTAssertTrue(trace.accesses.isEmpty)
            XCTAssertEqual(crc.deinitialize(), .busy)
            XCTAssertTrue(trace.accesses.isEmpty)
            // Init does not reject BUSY; correcting the polynomial allows retry.
            crc.configuration.generatingPolynomial = 0x1021
            XCTAssertEqual(crc.initialize { _ in XCTFail("Retry is not RESET") }, .ok)
            XCTAssertEqual(crc.state, .ready)
        }
    }

    func testDeinitializeBusyGuardAndCallbackTimingForEveryOtherState() {
        for initialState in CRCState.allCases {
            let trace = CRCTrace()
            trace.values[.cr] = 0x8000_00D8
            trace.values[.polynomial] = 0x65
            trace.values[.initialValue] = 0x37
            let configuration = CRCConfiguration(generatingPolynomial: 0xA5, initialValue: 0x1234)
            var crc = CRC(registers: CRCTraceIO(trace: trace), configuration: configuration, inputDataFormat: .bytes)
            crc.state = initialState
            crc.lock = .locked
            let status = crc.deinitialize { handle in
                XCTAssertEqual(handle.state, .busy)
                XCTAssertEqual(handle.lock, .locked)
                XCTAssertEqual(trace.accesses, [.read(.cr), .write(.cr, 0x8000_00D9), .write(.idr, 0)])
                trace.accesses.append(.mspDeinitialize)
                handle.state = .error
            }
            if initialState == .busy {
                XCTAssertEqual(status, .busy)
                XCTAssertTrue(trace.accesses.isEmpty)
                XCTAssertEqual(crc.state, .busy)
                XCTAssertEqual(crc.lock, .locked)
            } else {
                XCTAssertEqual(status, .ok)
                XCTAssertEqual(trace.accesses, [
                    .read(.cr), .write(.cr, 0x8000_00D9), .write(.idr, 0), .mspDeinitialize,
                ])
                XCTAssertEqual(crc.state, .reset)
                XCTAssertEqual(crc.lock, .unlocked)
            }
            XCTAssertEqual(crc.configuration, configuration)
            XCTAssertEqual(crc.inputDataFormat, .bytes)
            XCTAssertEqual(trace.values[.polynomial], 0x65)
            XCTAssertEqual(trace.values[.initialValue], 0x37)
            XCTAssertEqual(trace.values[.cr], 0x8000_00D8)
        }
    }

    func testPolynomialValidationBoundariesAndUpstreamIgnoredBit31() {
        // Explicit expectations include the C post-decrement quirk at bit 31.
        let cases: [(UInt32, [CRCPolynomialLength])] = [
            (0, []), (2, []), (0x8000_0000, []),
            (1, [.bits7, .bits8, .bits16, .bits32]),
            (0x7F, [.bits7, .bits8, .bits16, .bits32]),
            (0x81, [.bits8, .bits16, .bits32]),
            (0xFF, [.bits8, .bits16, .bits32]),
            (0x101, [.bits16, .bits32]), (0xFFFF, [.bits16, .bits32]),
            (0x10001, [.bits32]), (0x4000_0001, [.bits32]),
            (0x8000_0001, [.bits7, .bits8, .bits16, .bits32]),
            (0x8000_0081, [.bits8, .bits16, .bits32]),
            (0xFFFF_FFFF, [.bits32]),
        ]
        for (polynomial, acceptedLengths) in cases {
            for length in CRCPolynomialLength.allCases {
                for initialState in CRCState.allCases {
                    let trace = CRCTrace()
                    trace.values[.cr] = 0x8000_00F8
                    var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: .bytes)
                    let configuration = crc.configuration
                    crc.state = initialState
                    crc.lock = .locked
                    let accepted = acceptedLengths.contains(length)
                    XCTAssertEqual(crc.setPolynomial(polynomial, length: length), accepted ? .ok : .error,
                                   "polynomial=\(polynomial), length=\(length)")
                    XCTAssertEqual(trace.accesses, accepted ? [
                        .write(.polynomial, polynomial), .read(.cr), .write(.cr, 0x8000_00E0 | length.rawValue),
                    ] : [])
                    XCTAssertEqual(crc.state, initialState)
                    XCTAssertEqual(crc.lock, .locked)
                    XCTAssertEqual(crc.configuration, configuration)
                }
            }
        }
    }

    func testInputAndOutputReversalPreserveOtherBitsAndDoNotUpdateInitFields() {
        for input in CRCInputInversion.allCases {
            for output in CRCOutputInversion.allCases {
                let trace = CRCTrace()
                trace.values[.cr] = 0x8000_0018
                var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: .bytes)
                let configuration = crc.configuration
                crc.state = .busy
                crc.lock = .locked
                XCTAssertEqual(crc.reverseInputData(input), .ok)
                XCTAssertEqual(crc.state, .ready)
                crc.state = .error
                XCTAssertEqual(crc.reverseOutputData(output), .ok)
                XCTAssertEqual(crc.state, .ready)
                XCTAssertEqual(crc.lock, .locked)
                XCTAssertEqual(crc.configuration, configuration)
                XCTAssertEqual(trace.accesses, [
                    .read(.cr), .write(.cr, 0x8000_0018 | input.rawValue),
                    .read(.cr), .write(.cr, 0x8000_0018 | input.rawValue | output.rawValue),
                ])
            }
        }
    }

    func testBytePackingEveryRemainderAndMultipleFullWords() {
        let bytes: [UInt8] = [0x10, 0x21, 0x32, 0x43, 0x54, 0x65, 0x76, 0x87, 0x98, 0xA9, 0xBA]
        let expected: [[CRCAccess]] = [
            [], [.write8(0x10)], [.write16(0x1021)], [.write16(0x1021), .write8(0x32)],
            [.write(.dr, 0x1021_3243)], [.write(.dr, 0x1021_3243), .write8(0x54)],
            [.write(.dr, 0x1021_3243), .write16(0x5465)],
            [.write(.dr, 0x1021_3243), .write16(0x5465), .write8(0x76)],
            [.write(.dr, 0x1021_3243), .write(.dr, 0x5465_7687)],
            [.write(.dr, 0x1021_3243), .write(.dr, 0x5465_7687), .write8(0x98)],
            [.write(.dr, 0x1021_3243), .write(.dr, 0x5465_7687), .write16(0x98A9)],
            [.write(.dr, 0x1021_3243), .write(.dr, 0x5465_7687), .write16(0x98A9), .write8(0xBA)],
        ]
        bytes.withUnsafeBufferPointer { allBytes in
            for count in 0...bytes.count {
                let buffer = UnsafeBufferPointer(start: allBytes.baseAddress, count: count)
                let trace = CRCTrace()
                var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: .bytes)
                crc.state = .busy
                crc.lock = .locked
                XCTAssertEqual(crc.accumulate(buffer), trace.result)
                XCTAssertEqual(trace.accesses, expected[count] + [.read(.dr)], "length=\(count)")
                XCTAssertEqual(crc.state, .ready)
                XCTAssertEqual(crc.lock, .locked)
                trace.accesses = []
                XCTAssertEqual(crc.calculate(buffer), trace.result)
                XCTAssertEqual(trace.accesses, [.read(.cr), .write(.cr, 1)] + expected[count] + [.read(.dr)])
                trace.accesses = []
                XCTAssertEqual(crc.accumulate(UnsafeRawBufferPointer(buffer)), trace.result)
                XCTAssertEqual(trace.accesses, expected[count] + [.read(.dr)])
            }
        }
    }

    func testHalfwordPackingUsesHighHalfFirstAndNarrowOddTail() {
        let halfwords: [UInt16] = [0x0123, 0x4567, 0x89AB, 0xCDEF, 0x7654]
        let expected: [[CRCAccess]] = [
            [], [.write16(0x0123)], [.write(.dr, 0x0123_4567)],
            [.write(.dr, 0x0123_4567), .write16(0x89AB)],
            [.write(.dr, 0x0123_4567), .write(.dr, 0x89AB_CDEF)],
            [.write(.dr, 0x0123_4567), .write(.dr, 0x89AB_CDEF), .write16(0x7654)],
        ]
        halfwords.withUnsafeBufferPointer { allHalfwords in
            for count in 0...halfwords.count {
                let buffer = UnsafeBufferPointer(start: allHalfwords.baseAddress, count: count)
                let trace = CRCTrace()
                var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: .halfwords)
                XCTAssertEqual(crc.accumulate(buffer), trace.result)
                XCTAssertEqual(trace.accesses, expected[count] + [.read(.dr)])
                trace.accesses = []
                XCTAssertEqual(crc.calculate(buffer), trace.result)
                XCTAssertEqual(trace.accesses, [.read(.cr), .write(.cr, 1)] + expected[count] + [.read(.dr)])
                trace.accesses = []
                XCTAssertEqual(crc.accumulate(UnsafeRawBufferPointer(buffer)), trace.result)
                XCTAssertEqual(trace.accesses, expected[count] + [.read(.dr)])
                XCTAssertEqual(crc.state, .ready)
            }
        }
    }

    func testWordsAreWrittenUnchangedAndRawCountIsBytes() {
        let words: [UInt32] = [0xFEDC_BA98, 0x0123_4567, 0x8000_0001]
        let expected: [[CRCAccess]] = [
            [], [.write(.dr, 0xFEDC_BA98)],
            [.write(.dr, 0xFEDC_BA98), .write(.dr, 0x0123_4567)],
            [.write(.dr, 0xFEDC_BA98), .write(.dr, 0x0123_4567), .write(.dr, 0x8000_0001)],
        ]
        words.withUnsafeBufferPointer { allWords in
            for count in 0...words.count {
                let buffer = UnsafeBufferPointer(start: allWords.baseAddress, count: count)
                let trace = CRCTrace()
                var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: .words)
                XCTAssertEqual(crc.accumulate(buffer), trace.result)
                XCTAssertEqual(trace.accesses, expected[count] + [.read(.dr)])
                trace.accesses = []
                XCTAssertEqual(crc.calculate(buffer), trace.result)
                XCTAssertEqual(trace.accesses, [.read(.cr), .write(.cr, 1)] + expected[count] + [.read(.dr)])
                trace.accesses = []
                XCTAssertEqual(crc.accumulate(UnsafeRawBufferPointer(buffer)), trace.result)
                XCTAssertEqual(trace.accesses, expected[count] + [.read(.dr)])
                XCTAssertEqual(crc.state, .ready)
            }
        }
    }

    func testEmptyNilBuffersInAllFormatsAndDefaultBranchDoesNotReadDR() {
        let empty = UnsafeRawBufferPointer(start: nil, count: 0)
        for format in CRCInputDataFormat.allCases {
            for initialState in CRCState.allCases {
                let trace = CRCTrace()
                var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: format)
                crc.state = initialState
                crc.lock = .locked
                let expected: [CRCAccess] = format == .undefined ? [] : [.read(.dr)]
                let result: UInt32 = format == .undefined ? 0 : trace.result
                XCTAssertEqual(crc.accumulate(empty), result)
                XCTAssertEqual(trace.accesses, expected)
                XCTAssertEqual(crc.state, .ready)
                XCTAssertEqual(crc.lock, .locked)
                trace.accesses = []
                crc.state = initialState
                XCTAssertEqual(crc.calculate(empty), result)
                XCTAssertEqual(trace.accesses, [.read(.cr), .write(.cr, 1)] + expected)
                XCTAssertEqual(crc.state, .ready)
                XCTAssertEqual(crc.lock, .locked)
            }
        }
    }

    func testUnalignedByteBufferNeedsNoWordAlignmentAndIsNotCopied() {
        let bytes: [UInt8] = [0xFF, 0x10, 0x21, 0x32, 0x43, 0x54, 0x65, 0x76]
        let trace = CRCTrace()
        var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: .bytes)
        bytes.withUnsafeBytes {
            XCTAssertEqual(crc.calculate(UnsafeRawBufferPointer(rebasing: $0[1...])), trace.result)
        }
        XCTAssertEqual(trace.accesses, [
            .read(.cr), .write(.cr, 1), .write(.dr, 0x1021_3243),
            .write16(0x5465), .write8(0x76), .read(.dr),
        ])
    }

    func testExportedRegisterMacrosPreserveHandleFieldsAndFullWidthIDR() {
        let trace = CRCTrace()
        trace.values[.cr] = 0x8000_0058
        var crc = CRC(registers: CRCTraceIO(trace: trace), inputDataFormat: .words)
        let configuration = crc.configuration
        crc.state = .timeout
        crc.lock = .locked
        crc.resetDataRegister()
        crc.setInitialValue(0x1234_5678)
        crc.setIndependentData(0xFEDC_BA98)
        XCTAssertEqual(crc.getIndependentData(), 0xFEDC_BA98)
        crc.enableOutputReversal()
        crc.disableOutputReversal()
        // The macro bypasses polynomial validation, including the oddness check.
        crc.configurePolynomial(2)
        XCTAssertEqual(trace.accesses, [
            .read(.cr), .write(.cr, 0x8000_0059),
            .write(.initialValue, 0x1234_5678), .write(.idr, 0xFEDC_BA98), .read(.idr),
            .read(.cr), .write(.cr, 0x8000_00D8), .read(.cr), .write(.cr, 0x8000_0058),
            .write(.polynomial, 2),
        ])
        XCTAssertEqual(crc.state, .timeout)
        XCTAssertEqual(crc.lock, .locked)
        XCTAssertEqual(crc.configuration, configuration)
        let accesses = trace.accesses
        crc.resetHandleState()
        XCTAssertEqual(crc.getState(), .reset)
        XCTAssertEqual(crc.lock, .locked)
        XCTAssertEqual(trace.accesses, accesses)
    }
}
