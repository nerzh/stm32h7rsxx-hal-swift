import XCTest
import CPKAReference
import STM32H7RSHAL

final class PKAPair {
    private let cStorage = UnsafeMutableRawPointer.allocate(byteCount:CPKA_Size(),alignment:16)
    private let swiftStorage = UnsafeMutableRawPointer.allocate(byteCount:CPKA_Size(),alignment:16)
    var c: PKAModel { .init(state:OpaquePointer(cStorage)) }
    var swift: PKAModel { .init(state:OpaquePointer(swiftStorage)) }
    init(mode: UInt32=0,seed: UInt32=1) {
        for storage in [cStorage,swiftStorage] {
            let m=PKAModel(state:OpaquePointer(storage))
            CPKA_Reset(m.state,mode,seed)
            m.set(1,2,64); m.set(1,0x32,64)
            for index: UInt32 in [0x2F8,0x48,0xA0,0x3A6] { m.set(1,index,0xD60D) }
        }
    }
    deinit { cStorage.deallocate(); swiftStorage.deallocate() }
    func set(_ area: UInt32,_ index: UInt32,_ value: UInt32) { c.set(area,index,value); swift.set(area,index,value) }
    func setup(_ body: (PKAModel)->Void) { body(c); body(swift) }
    @discardableResult
    func check(_ op: UInt32,_ a: UInt32=0,_ b: UInt32=0,_ argument: UInt32=0,file: StaticString=#filePath,line: UInt=#line) -> UInt32 {
        let expected=CPKA_Run(c.state,op,a,b,argument)
        let actual=swift.run(op,a,b,argument)
        XCTAssertEqual(actual,expected,"PKA operation \(op)",file:file,line:line)
        for (area,count): (UInt32,UInt32) in [(0,3),(1,1334),(2,5),(3,400),(4,12),(5,4),(6,2560),(7,384)] {
            if let index=(0..<count).first(where:{c.get(area,$0) != swift.get(area,$0)}) {
                XCTFail("PKA op \(op), area \(area), index \(index): C=\(c.get(area,index)), Swift=\(swift.get(area,index))",file:file,line:line)
            }
        }
        for id: UInt32 in 0..<4 { XCTAssertEqual(CPKA_GetCallback(c.state,id),CPKA_GetCallback(swift.state,id),"callback \(id), op \(op)",file:file,line:line) }
        return actual
    }
}

final class PKADifferentialTests: XCTestCase {
    func testEveryUpstreamFunctionInBothCallbackModes() {
        for mode: UInt32 in 0...1 {
            for op: UInt32 in 0...94 {
                let p=PKAPair(mode:mode,seed:op)
                let a: UInt32 = [64,65,66,67,68,69,70,84,91].contains(op) ? 8 : (op==92 ? 1 : 0)
                let b: UInt32 = op==93 ? 8 : (op==65 ? 0x80 : 0)
                p.check(op,a,b)
            }
        }
    }
    func testAllOperationEntriesPreserveSubmissionSideEffectsWhenNotReady() {
        let operations: [UInt32] = [4,5,6,7,8,9,11,12,14,15,17,18,20,21,23,24,25,26,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,47,48,49,50,51,52,53,54]
        for state: UInt32 in [0,2,3,99] {
            for op in operations {
                let p=PKAPair(mode:1,seed:op&*47); p.set(2,0,state); p.set(2,1,0x12345678); p.set(1,2,0xDEADBEEF)
                XCTAssertEqual(p.check(op),HALStatus.error.rawValue)
                XCTAssertEqual(p.swift.get(2,0),state); XCTAssertEqual(p.swift.get(2,1),0x12345678)
                XCTAssertNotEqual(p.swift.get(1,2),0xDEADBEEF)
            }
        }
    }
    func testAllInputSettersAndSubmissionLengthsForPartialWords() {
        let setters: [UInt32] = Array(73...83)+[85,87,89]
        for size: UInt32 in [1,2,3,4,5,7,8,9,16,17,31,32,65] {
            for op in setters {
                let p=PKAPair(seed:size&*97)
                p.setup { m in for i: UInt32 in 0..<400 { m.set(3,i,size) } }
                p.check(op)
            }
        }
    }
    func testDistinctECCPrimeOrderModulusAndScalarSizes() {
        for op: UInt32 in [11,12,14,15,23,24,25,26,76,77,80,81] {
            let p=PKAPair()
            p.set(3,0,3); p.set(3,1,7)
            p.set(3,20,5); p.set(3,21,3); p.set(3,22,7)
            p.set(3,80,5); p.set(3,81,7); p.set(3,100,5); p.set(3,101,7)
            p.setup { m in m.bytes(2)[0]=0x03; m.bytes(3)[0]=0x07 }
            p.check(op)
        }
    }
    func testOptionalArithmeticInputsAndLeadingZeroMontgomeryModulus() {
        for size: UInt32 in [0,1,2,3,4,7,8,17,64] {
            for mask: UInt32 in 0..<8 { let p=PKAPair(); p.check(91,size,mask) }
        }
        for size: UInt32 in [1,2,3,4,5,8,16,33,64] {
            for zeros in 0..<size {
                let p=PKAPair(seed:size)
                p.setup { m in for i in 0..<zeros {m.bytes(0)[Int(i)]=0};m.bytes(0)[Int(zeros)]=0x03 }
                p.check(84,size)
                XCTAssertEqual(p.swift.get(1,2),(size-zeros-1)*8+2)
            }
            PKAPair().check(84,size,1)
        }
    }
    func testPointCheckRejectsMissingMontgomeryParameterBeforeWrites() {
        for op: UInt32 in [20,21] {
            let p=PKAPair();p.set(4,6,1<<7)
            XCTAssertEqual(p.check(op),1);XCTAssertEqual(p.swift.get(1,2),64)
        }
    }
    func testByteAndWordCopiesAtAllRemaindersWithNullBuffersAndGuards() {
        for size: UInt32 in 0...67 {
            for op: UInt32 in [68,69,70] {
                for flags: UInt32 in 0..<(op==70 ? 4 : 2) { PKAPair(seed:size).check(op,size,flags,100) }
            }
        }
    }
    func testResultGettersForAllModesLengthsAndNullOutputStructures() {
        for size: UInt32 in [0,1,2,3,4,5,7,8,9,16,33,65] {
            for op: UInt32 in [10,13,19,27,55,86,88,90] {
                for nulls: UInt32 in 0..<(op==13 ? 4 : 2) {
                    let p=PKAPair(seed:size); p.set(1,2,size*8); for word: UInt32 in 2...4 {p.set(2,word,size)}
                    p.check(op,0,nulls)
                }
            }
        }
        for mode: UInt32 in 0..<64 {
            for carry: UInt32 in 0...1 {
                for null: UInt32 in 0...1 {
                    let p=PKAPair();p.set(0,0,mode<<8|1);p.set(1,2,96);p.set(1,0x29E+3,carry);p.check(46,0,null)
                }
            }
        }
    }
    func testResultSizeScansHighWordsAndPreservesZeroSizeConvention() {
        for size: UInt32 in 1...32 {
            for nonzero in 0...size {
                let p=PKAPair();for i in 0..<size { p.set(1,100+i,i<nonzero ? 0xABCD : 0) }
                XCTAssertEqual(p.check(93,100,size),max(1,nonzero)*4)
            }
        }
    }
    func testErrorChecksAndIRQSynchronousCallbackMutations() {
        for mode: UInt32 in 0..<64 {
            for errors: UInt32 in 0..<16 {
                let p=PKAPair(mode:mode&1)
                let flags=(errors&1 != 0 ? UInt32(0x80000):0)|(errors&2 != 0 ? 0x100000:0)|(errors&4 != 0 ? 0x200000:0)|0x20000
                p.set(0,0,mode<<8|0x3A0001);p.set(0,1,flags)
                if errors&8 != 0 { for index: UInt32 in [0x2F8,0x48,0xA0,0x3A6] {p.set(1,index,0)} }
                p.set(4,4,3);p.check(63,mode);p.check(58)
            }
        }
    }
    func testIRQRespectsEnableMaskAndRetainsEarlierError() {
        for mask: UInt32 in 0..<16 {
            let p=PKAPair(mode:1)
            let source=(mask&1 != 0 ? UInt32(0x20000):0)|(mask&2 != 0 ? 0x80000:0)|(mask&4 != 0 ? 0x100000:0)|(mask&8 != 0 ? 0x200000:0)
            p.set(0,0,source);p.set(0,1,0x3A0000);p.set(2,1,4);p.check(58)
        }
    }
    func testInitializationTimeoutsAndWrappedTicks() {
        for state: UInt32 in 0...3 {
            for blocked: UInt32 in [0,1,3,7] {
                for ready: UInt32 in [0,1] {
                    let p=PKAPair(mode:1);p.set(2,0,state);p.set(0,0,0);p.set(0,1,ready);p.set(4,8,blocked);p.set(5,0,UInt32.max-1500)
                    p.setup {m in CPKA_SetCallback(m.state,2,0)};p.check(0)
                }
            }
        }
        let p=PKAPair();p.set(0,1,0);p.set(4,1,3);p.set(4,2,1);p.check(0)
    }
    func testPollingWaitAndProcessTimeoutsDoNotShareCleanupSemantics() {
        for mode: UInt32 in [0,3,9,0x20,0x24,0x27,0x2F] {
            for timeout: UInt32 in [0,1,1001,3000,UInt32.max] {
                let p=PKAPair();p.set(0,1,0);p.set(4,1,3);p.set(4,2,0x20000);p.set(5,0,UInt32.max-1500)
                // Infinite timeout does not read ticks, so make the flag ready before entering.
                if timeout==UInt32.max {p.set(0,1,0x20000)}
                p.check(71,mode,timeout)
            }
        }
        for op: UInt32 in [62,92] {
            for timeout: UInt32 in [0,1,3000] {
                let p=PKAPair();p.set(0,1,0);p.set(2,0,2);p.set(2,1,0x81)
                if op==62 {p.check(op,0,timeout)} else {p.check(op,1,0,timeout)}
            }
        }
    }
    func testDefaultMSPResetsRAMAndContinuesAfterEnableTimeout() {
        for op: UInt32 in [1,94] {
            for blocked: UInt32 in [0,3,7] {
                for ready: UInt32 in [0,1] {
                    let p=PKAPair(mode:1);p.set(4,8,blocked);p.set(4,9,ready);p.set(4,0,601);p.set(2,1,0x80);p.check(op)
                    for i: UInt32 in 0..<1334 {XCTAssertEqual(p.swift.get(1,i),0)}
                    XCTAssertEqual(p.swift.get(0,0),0)
                    XCTAssertEqual(p.swift.get(2,0),op==1 ? 0 : (ready != 0 || blocked>0 ? 3 : 1))
                }
            }
        }
    }
    func testCustomMSPCallbacksAndRegistrationStateMatrix() {
        for state: UInt32 in 0...4 {
            for id: UInt32 in 0...5 {
                for token: UInt32 in 0...2 {
                    let p=PKAPair(mode:1);p.set(2,0,state);p.set(2,1,0x80);p.check(2,id,token);p.check(3,id)
                }
            }
        }
        for mode: UInt32 in 0...1 {
            let p=PKAPair(mode:mode);p.setup {m in CPKA_SetCallback(m.state,3,2)};p.check(1)
        }
    }
    func testPublicMacrosAllMasksBothCallbackModes() {
        for mode: UInt32 in 0...1 {
            for op: UInt32 in 100...108 {
                for mask: UInt32 in [0,1,2,0x20000,0x80000,0x100000,0x200000,0x3A0000,UInt32.max] {
                    let p=PKAPair(mode:mode);p.set(0,0,0xA52A3F01);p.set(0,1,0x203001);p.check(op,mask)
                }
            }
        }
    }
    func testBitSizeHelpersMatchUInt32Arithmetic() {
        for value: UInt32 in [0,1,2,3,7,8,31,32,33,512,0x7FFFFFFF,UInt32.max] {
            let p=PKAPair();p.check(64,value);p.check(66,value)
            for byte: UInt32 in [0,1,2,3,0x7F,0x80,0xFF] {p.check(65,value,byte)}
            // The host C ABI has 64-bit unsigned long; division-overflow cases run on ARM.
            if value<UInt32.max-7 {p.check(67,value)}
        }
    }
}
