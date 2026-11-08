import XCTest
import CJPEGReference
@testable import STM32H7RSHAL

final class JPEGPair {
    let actualStorage = UnsafeMutableRawPointer.allocate(byteCount: CJPEG_Size(), alignment: 16)
    let expectedStorage = UnsafeMutableRawPointer.allocate(byteCount: CJPEG_Size(), alignment: 16)
    var actual: OpaquePointer { OpaquePointer(actualStorage) }
    var expected: OpaquePointer { OpaquePointer(expectedStorage) }
    init(_ mode: UInt32 = 0) { CJPEG_Reset(actual, mode); CJPEG_Reset(expected, mode); set(1, 11, 1) }
    deinit { actualStorage.deallocate(); expectedStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CJPEG_Set(actual, area, index, value); CJPEG_Set(expected, area, index, value) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CJPEG_Get(actual, area, index) }
    func reg(_ register: JPEGRegister, _ value: UInt32) { set(0, register.rawValue / 4, value) }
    func callback(_ id: UInt32, _ token: UInt32) { CJPEG_SetCallback(actual, id, token); CJPEG_SetCallback(expected, id, token) }
    @discardableResult
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        set(12, 0, 0)
        let wanted = CJPEG_Run(expected, op, a, b, c), result = JPEGModel(state: actual).run(op, a, b, c)
        let label = "mode \(get(13, 0)), op \(op), args \([a,b,c])"
        XCTAssertEqual(result, wanted, label, file: file, line: line)
        let counts: [UInt32] = [512,14,5,5,32,16,256,256,4,2,12,2]
        for area: UInt32 in 0..<12 {
            XCTAssertEqual((0..<counts[Int(area)]).map { CJPEG_Get(actual, area, $0) }, (0..<counts[Int(area)]).map { CJPEG_Get(expected, area, $0) }, "\(label), area \(area)", file: file, line: line)
        }
        for i: UInt32 in 1...8 { XCTAssertEqual(CJPEG_GetCallback(actual, i), CJPEG_GetCallback(expected, i), label, file: file, line: line) }
        let events = get(12, 0), expectedEvents = CJPEG_Get(expected, 12, 0)
        XCTAssertEqual(events, expectedEvents, label, file: file, line: line)
        for e in 0..<min(events, expectedEvents) {
            XCTAssertEqual((0..<1536).map { CJPEG_TraceWord(actual, e, $0) }, (0..<1536).map { CJPEG_TraceWord(expected, e, $0) }, "\(label), event \(e)", file: file, line: line)
        }
        return result
    }
}
final class JPEGDifferentialTests: XCTestCase {
    func testHuffmanCodeGenerationAndPartialFailureMatchC() {
        let p = JPEGPair(), d = JPEGModel(state:p.actual).driver
        for isAC in [false,true] { for scenario in 0..<512 {
            let count = isAC ? 162 : 12
            var bits = [UInt8](repeating:0,count:16)
            if scenario==0 { bits[0]=255; bits[1]=2 }
            else { bits[scenario%16] = UInt8(scenario%(count+1)) }
            let symbols = (0..<162).map { UInt8(truncatingIfNeeded:$0 + scenario/16) }
            var actualCodes = [UInt32](repeating:0xABCD1234,count:count), expectedCodes = actualCodes
            var actualLengths = [UInt8](repeating:0xA5,count:count), expectedLengths = actualLengths
            let expected = CJPEG_Huffman(isAC ? 1:0,bits,symbols,&expectedCodes,&expectedLengths)
            let actual = d.makeHuffmanCodes(isAC:isAC,bits:{bits[$0]},symbols:{symbols[$0]},store:{ actualCodes[$0]=$1; actualLengths[$0]=$2 })
            XCTAssertEqual(actual.rawValue,expected); XCTAssertEqual(actualCodes,expectedCodes); XCTAssertEqual(actualLengths,expectedLengths)
        }}
    }
    func testInitializationProgramsExactStandardTablesAndDeinitKeepsRegisters() {
        for mode: UInt32 in 0...1 { for state: UInt32 in 0...6 { for token: UInt32 in 0...2 {
            let p = JPEGPair(mode); p.set(1,11,state); p.set(1,10,1); p.set(1,12,0x8000); p.set(1,13,.max); p.set(1,9,0xA5)
            for i: UInt32 in 0..<512 { p.set(0,i,0xABCD0000 | i) }
            for i: UInt32 in 1...8 { p.callback(i,token) }; p.set(5,10,1)
            XCTAssertEqual(p.run(0),0); XCTAssertEqual(p.get(8,0),1); XCTAssertEqual(p.get(8,1),2); XCTAssertEqual(p.get(1,9),0xA5)
            p.run(1)
        } } }
    }
    func testQuantizationEveryQualityAndCustomTableBytes() {
        for quality: UInt32 in 0...105 { for table: UInt32 in 0..<4 {
            let p = JPEGPair(); p.set(1,4,quality)
            for i: UInt32 in 0..<64 { p.set(14,table*64+i,(i*17+table)&255) }
            p.run(36,table)
        } }
        for quality: UInt32 in 1...100 {
            let p = JPEGPair(); p.run(0); p.set(2,4,quality); p.run(2); p.run(37); p.run(3,1)
        }
    }
    func testConfigurationColorSubsamplingDimensionsAndCustomTables() {
        for mode: UInt32 in 0...1 { for color: UInt32 in [0,0x10,0x30] { for sampling: UInt32 in 0...2 { for custom: UInt32 in 0...1 {
            for size: UInt32 in [0,1,8,9,16,17,65535,65536,.max] {
                let p = JPEGPair(mode); p.run(0); if custom==1 { p.run(6,15) }
                p.set(2,0,color); p.set(2,1,sampling); p.set(2,2,size); p.set(2,3,size); p.set(2,4,custom==0 ? 50:100)
                p.reg(.confr1,.max); p.reg(.confr3,.max); p.run(2); p.run(3,1)
            }
        } } } }
        for state: UInt32 in 0...6 { for lock: UInt32 in 0...2 { for present: UInt32 in 0...1 {
            let p = JPEGPair(); p.set(1,11,state); p.set(1,10,lock); p.set(5,2,present); p.run(2)
            p.run(4); p.run(5); p.run(6,0); p.run(29)
        } } }
    }
    func testGetInfoInfersComponentsFromNFAndPreservesInvalidOutput() {
        for nf: UInt32 in 0..<4 { for y: UInt32 in 0..<4 { for cb: UInt32 in 0...1 { for cr: UInt32 in 0...1 {
            let p = JPEGPair(); p.reg(.confr1,0x12340000 | nf | 0x30); p.reg(.confr3,0x56780000)
            p.reg(.confr4,y<<4); p.reg(.confr5,cb<<4); p.reg(.confr6,cr<<4)
            for i: UInt32 in 0..<5 { p.set(3,i,0xA000+i) }; p.run(3,0); p.run(3,1)
        } } } }
    }
    func testPollingInitialValidationTickPlacementAndTimeoutRetention() {
        for op: UInt32 in [7,8] { for mode: UInt32 in 0...1 { for state: UInt32 in [0,1,3,4,6] { for lock: UInt32 in 0...1 {
            for present: UInt32 in 0..<4 {
                let p = JPEGPair(mode); p.set(1,11,state); p.set(1,10,lock); p.set(1,13,0x100)
                p.set(5,0,present&1); p.set(5,1,(present>>1)&1); p.set(11,0,.max-2); p.run(op,5,7,1)
            }
        } } } }
        for op: UInt32 in [7,8] { for flags: UInt32 in [0,2,4,8,0x10,0x20,0x40,0x60] { for timeout: UInt32 in [0,1,3] {
            let p = JPEGPair(1); p.set(1,13,0x100); p.reg(.sr,flags); p.reg(.confr1,2); p.reg(.dor,0xA1B2C3D4)
            p.set(5,7,1); p.set(5,8,1); p.run(op,16,16,timeout)
        } } }
        let p = JPEGPair(); p.set(1,13,0x100); p.set(5,4,2); p.set(5,5,0x20); p.run(7,16,16,3)
    }
    func testInterruptAndDMAStartsRoundLengthsAndKeepFailureSideEffects() {
        for op: UInt32 in 9...12 { for state: UInt32 in [0,1,3,4,6] { for lock: UInt32 in 0...1 {
            let p = JPEGPair(1); p.set(1,11,state); p.set(1,10,lock); p.set(1,13,0x3000); p.run(op,7,9)
            p.set(1,10,0); p.set(1,13,0x3100); p.run(op,7,9)
        } } }
        for op: UInt32 in [11,12] { for inputMode: UInt32 in [0,0x80,0x81] { for outputMode: UInt32 in [0,0x80,0x81] {
            for failureStream: UInt32 in 0...1 { for status: UInt32 in 0...3 { for queue: UInt32 in 0...1 {
                let p = JPEGPair(); p.set(1,13,0x100); p.set(4,0,inputMode); p.set(4,16,outputMode)
                p.set(4,failureStream*16+11,status); p.set(4,failureStream*16+1,queue); p.run(op,7,9)
            } } }
        } } }
    }
    func testInputShortWordsCallbackReplacementAndPause() {
        for mode: UInt32 in 0...1 { for length: UInt32 in 0...20 { for count: UInt32 in [0,1,4,8,20] {
            for words: UInt32 in [0,1,4] { for action: UInt32 in 0...4 {
                let p = JPEGPair(mode); p.set(1,7,length); p.set(1,5,count); p.set(1,13,9); p.set(5,7,action); p.run(34,words)
            } }
        } } }
    }
    func testOutputPartialWordsPreserveReferenceRemainderIndicesAndLiveBuffer() {
        for mode: UInt32 in 0...1 { for length: UInt32 in 0...20 { for count: UInt32 in [0,1,4,8,20] {
            for words: UInt32 in [0,1,4] { for action: UInt32 in 0...3 {
                let p = JPEGPair(mode); p.set(1,8,length); p.set(1,6,count); p.set(1,13,9); p.set(5,8,action); p.reg(.dor,0xA1B2C3D4); p.run(35,words)
            } }
        } } }
    }
    func testIRQUsesStatusSnapshotAndLiveContextAcrossCallbacks() {
        for mode: UInt32 in 0...1 { for flags: UInt32 in 0..<128 { for method: UInt32 in [8,12] { for pause: UInt32 in 0..<4 {
            let p = JPEGPair(mode); p.set(1,11,4); p.set(1,13,2 | method | (pause<<12)); p.set(1,7,16); p.set(1,8,20)
            p.reg(.sr,flags); p.reg(.confr1,2); p.reg(.cr,0x7E); p.reg(.dor,0xA1B2C3D4)
            p.set(5,6,flags&1); p.set(5,7,1); p.set(5,8,1); p.set(5,9,(flags>>1)&1)
            for id: UInt32 in 1...8 { p.callback(id,2) }; p.run(18)
        } } } }
    }
    func testPauseResumeAndAbortErrorsPreserveExistingContext() {
        for context: UInt32 in [0,4,8,12,0x1008,0x2008,0x3008,0x100C,0x200C,0x300C,0xA00C] {
            for selection: UInt32 in 1...3 { for status: UInt32 in 0...3 {
                let p = JPEGPair(); p.set(1,13,context); p.set(1,7,7); p.set(1,8,16); p.set(4,11,status); p.set(4,27,status)
                p.run(13,selection); p.run(14,selection)
            } }
        }
        for context: UInt32 in [0,9,12,0xB10E] { for status: UInt32 in 0...3 { for dmaError: UInt32 in [0,0x10,0x11] { for error: UInt32 in [0,1] {
            let p = JPEGPair(); p.set(1,13,context); p.set(1,12,error); p.set(1,10,1); p.set(4,12,status); p.set(4,28,status)
            p.set(4,15,dmaError); p.set(4,31,dmaError); p.reg(.sr,0x80); p.set(5,4,3); p.set(5,5,0); p.set(11,0,.max-2); p.run(17)
        } } } }
        let p = JPEGPair(); p.reg(.sr,0x80); p.run(17)
    }
    func testDMAEventsUseSourceChannelCountersAndLiveBuffers() {
        for mode: UInt32 in 0...1 { for op: UInt32 in 30...33 { for source: UInt32 in 0...1 {
            for context: UInt32 in [0,0xC,0xD,0xE,0x100D,0x200D,0x800D] { for status: UInt32 in 0...3 {
                let p = JPEGPair(mode); p.set(1,13,context); p.set(1,11,3); p.set(1,10,1); p.set(1,7,16); p.set(1,8,16)
                p.set(4,source*16+9,4); p.set(4,source*16+10,2); p.set(4,source*16+15,status); p.set(4,11,status); p.set(4,27,status)
                p.set(5,7,2); p.set(5,8,3); p.run(op,source)
            } }
        } } }
        for pause: UInt32 in 0...1 { let p = JPEGPair(1); p.set(1,13,0x800D | (pause<<13)); p.set(1,8,16); p.reg(.sr,0x10); p.set(5,8,pause); p.run(33,1) }
    }
    func testCallbackRegistrationAndRawMacros() {
        for state: UInt32 in 0...6 { for lock: UInt32 in 0...2 { for id: UInt32 in 0...7 { for token: UInt32 in 0...2 {
            let p = JPEGPair(1); p.set(1,11,state); p.set(1,10,lock); p.run(21,id,token); p.run(22,id)
            for op: UInt32 in 23...28 { p.run(op,token) }
        } } } }
        for mode: UInt32 in 0...1 { for op: UInt32 in [15,16,19,20,29,38,39,40,41,42,43,44] {
            for value: UInt32 in [0,1,3,0x7E] { let p = JPEGPair(mode); p.reg(.cr,.max); p.reg(.sr,.max); p.run(op,value,7) }
        } }
    }
}
