import XCTest
import CFDCANReference
import STM32H7RSHAL

final class FDCANPair {
    let mode: UInt32
    let c: FDCANModel
    let swift: FDCANModel
    init(mode: UInt32 = 0, instance: UInt32 = 0) {
        self.mode = mode
        c = .init(state: CFDCAN_Create(mode, instance)!, mode: mode)
        swift = .init(state: CFDCAN_Create(mode, instance)!, mode: mode)
    }
    deinit { CFDCAN_Destroy(c.state); CFDCAN_Destroy(swift.state) }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { c.set(area,index,value); swift.set(area,index,value) }
    func setup(_ body: (FDCANModel) -> Void) { body(c); body(swift) }
    func ready() {
        setup { m in
            m.driver.setConfiguration(.init(nominalPrescaler: 1, nominalSyncJumpWidth: 1, nominalTimeSeg1: 2,
                nominalTimeSeg2: 2, dataPrescaler: 1, dataSyncJumpWidth: 1, dataTimeSeg1: 1, dataTimeSeg2: 1,
                stdFiltersNbr: 28, extFiltersNbr: 8))
            let base = UInt32(0x4000AC00) + m.get(5,2) * 848
            for (w, offset): (FDCANHandleWord, UInt32) in [(.standardFilterSA,0),(.extendedFilterSA,112),(.rxFIFO0SA,176),(.rxFIFO1SA,392),(.txEventFIFOSA,608),(.txFIFOQSA,632)] { m.write(w, value:base+offset) }
            m.write(.state, value:1)
        }
    }
    @discardableResult
    func check(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ argument: UInt32 = 0, _ d: UInt32 = 0,
               file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        let expected = CFDCAN_Run(c.state,op,a,b,argument,d)
        let actual = swift.run(op,a,b,argument,d)
        XCTAssertEqual(actual,expected,"FDCAN operation \(op)",file:file,line:line)
        for (area,count): (UInt32,UInt32) in [(0,118),(1,1),(2,27),(3,140),(4,8),(5,5),(6,448),(7,256),(8,160)] {
            if let index=(0..<count).first(where: {c.get(area,$0) != swift.get(area,$0)}) {
                XCTFail("FDCAN op \(op), area \(area), index \(index): C=\(c.get(area,index)), Swift=\(swift.get(area,index))",file:file,line:line)
            }
        }
        for id: UInt32 in 0..<13 { XCTAssertEqual(CFDCAN_GetCallback(c.state,id),CFDCAN_GetCallback(swift.state,id),"callback \(id), op \(op)",file:file,line:line) }
        return actual
    }
}

final class FDCANDifferentialTests: XCTestCase {
    func testEveryPublicEntryInBothCallbackModesAndBothInstances() {
        for mode: UInt32 in 0...1 { for instance: UInt32 in 0...1 { for state: UInt32 in 0...3 { for op: UInt32 in 0...60 {
            let p=FDCANPair(mode:mode,instance:instance);p.ready();p.setup { $0.write(.state,value:state) }
            p.check(op)
        } } } }
    }
    func testInitializationClockConfigurationAndExactRAMPartition() {
        for mode: UInt32 in 0...1 { for instance: UInt32 in 0...1 { for v: UInt32 in 0..<96 {
            let p=FDCANPair(mode:mode,instance:instance)
            p.setup { m in
                for i: UInt32 in 0..<448 {m.set(6,i,0xA5A50000+i)}
                m.driver.setConfiguration(.init(clockDivider:(v&15)<<1,frameFormat:[0,256,768][Int(v%3)],mode:v%5,
                    autoRetransmission:v&1,transmitPause:(v>>1)&1,protocolException:(v>>2)&1,
                    nominalPrescaler:(v&31)+1,nominalSyncJumpWidth:(v&15)+1,nominalTimeSeg1:(v&63)+2,nominalTimeSeg2:(v&31)+2,
                    dataPrescaler:(v&15)+1,dataSyncJumpWidth:(v&7)+1,dataTimeSeg1:(v&15)+1,dataTimeSeg2:(v&7)+1,
                    stdFiltersNbr:v%29,extFiltersNbr:v%9,txFifoQueueMode:(v&1)<<24))
                m.write(.cccr,value:0xFFFF_FFE7);m.write(.txbc,value:0x5555AAAA);m.writeClockDivider(7)
                for id: UInt32 in 0..<13 { CFDCAN_SetCallback(m.state,id,id==5 || id==6 ? v%3 : 2) }
                m.write(.state,value:v&1)
            }
            p.check(0)
            XCTAssertEqual(p.swift.driver.getState(),1)
            for i: UInt32 in 0..<448 {
                let expected: UInt32 = (instance*212..<instance*212+212).contains(i) ? 0 : 0xA5A50000+i
                XCTAssertEqual(p.swift.get(6,i),expected)
            }
        } } }
    }
    func testPowerTransitionsTickWrapAndDeinitIgnoresStopErrors() {
        for op: UInt32 in [0,1,2,3,40,41] { for cr: UInt32 in [0,1,2,8,16,24,31] { for arrival: UInt32 in 0...6 {
            let p=FDCANPair(mode:1);p.ready();p.setup { m in m.write(.state,value:2);m.write(.cccr,value:cr) }
            p.set(5,0,UInt32.max-4);p.set(4,1,arrival);p.set(4,2,op==2 ? 0:8);p.set(4,3,op==2 ? 8:0)
            p.check(op)
        } } }
    }
    func testConfigurationAndStatusMasks() {
        let ops:[UInt32]=Array(19...39)+[43,44,47,48,49,50,51,52,53,54]
        for state: UInt32 in 0...3 { for seed: UInt32 in [0,1,2,3,0x12345678,0xFFFFFFFF] { for op in ops {
            let p=FDCANPair();p.ready();p.setup { m in
                for r in FDCANRegister.allCases {m.write(r,value:seed)}
                m.write(.state,value:state);m.write(.errorCode,value:0x40000000)
            }
            p.check(op,(op==21 || op==51) ? FDCANConstants.FDCAN_RX_FIFO0+(seed&1):seed,seed&0xFFFF,(seed>>1)&1,seed&1)
        } } }
    }
    func testCommonAndEventCallbackRegistrationStates() {
        for state: UInt32 in [0,1,2,3,0xFFFFFFFF] {for id: UInt32 in 0..<13 {for token: UInt32 in 0...2 {
            let p=FDCANPair(mode:1);p.setup {$0.write(.state,value:state)}
            p.check(4,id,token);p.check(5,id)
        } } }
        for state: UInt32 in 0...3 {for op: UInt32 in 6...17 {for token: UInt32 in 0...2 {
            let p=FDCANPair(mode:1);p.setup {$0.write(.state,value:state)};p.check(op,token)
        } } }
    }
    func testFilterPackingPreservesAdjacentWords() {
        for instance: UInt32 in 0...1 {for extended: UInt32 in 0...1 {for index: UInt32 in 0..<(extended==0 ? 28:8) {
            for kind: UInt32 in 0...3 {for config: UInt32 in 0...7 {
                let p=FDCANPair(instance:instance);p.ready();p.set(3,0,extended<<30);p.set(3,1,index)
                p.set(3,2,kind);p.set(3,3,config);p.set(3,4,extended==0 ? 0x321:0x12345678);p.set(3,5,extended==0 ? 0x456:0x1ABCDEFF)
                p.setup {m in for i:UInt32 in 0..<448 {m.set(6,i,0xA5A5A5A5)};m.write(.state,value:config&1==0 ? 1:2)}
                p.check(18)
            } }
        } } }
    }
    func testTxMessagesEveryDLCAndFullWordPadding() {
        for instance: UInt32 in 0...1 {for dlc: UInt32 in 0...15 {for index: UInt32 in 0...2 {for variant:UInt32 in 0..<8 {
            let p=FDCANPair(instance:instance);p.ready();p.setup {m in
                m.write(.state,value:2);m.write(.txfqs,value:index<<16)
                for i:UInt32 in 0..<80 {m.set(8,i,(i*7+variant)&255)}
                for i:UInt32 in 0..<448 {m.set(6,i,0xAAAAAAAA)}
            }
            p.set(3,20,variant&1==0 ? 0x345:0x12345678);p.set(3,21,(variant&1)<<30);p.set(3,22,((variant>>1)&1)<<29)
            p.set(3,23,dlc);p.set(3,24,((variant>>2)&1)<<31);p.set(3,25,(variant&1)<<20)
            p.set(3,26,1<<21);p.set(3,27,1<<23);p.set(3,28,0x93)
            p.check(42);p.check(43)
        } } } }
        let full=FDCANPair();full.ready();full.setup {$0.write(.state,value:2);$0.write(.txfqs,value:1<<21)};XCTAssertEqual(full.check(42),1)
    }
    func testRxMessagesEveryDLCOverwriteAndAdjacentSlot() {
        for fifo:UInt32 in 0...1 {for index:UInt32 in 0...2 {for dlc:UInt32 in 0...15 {for overwrite:UInt32 in 0...1 {
            let p=FDCANPair(instance:fifo);p.ready();p.setup {m in
                m.write(.state,value:2);m.write(fifo==0 ? .rxf0s:.rxf1s,value:3|(index<<8)|(overwrite<<24))
                m.write(.rxgfc,value:overwrite<<(fifo==0 ? 24:25))
                for i:UInt32 in 0..<448 {m.set(6,i,0xA0B0C000+i)}
                let chosen=overwrite != 0 ? (index+1)&3:index
                let a=m.read(fifo==0 ? FDCANHandleWord.rxFIFO0SA:.rxFIFO1SA)+chosen*72
                m.writeMemory32(at:a,value:(dlc&1)==0 ? 0xD2345678:0x691C0000)
                m.writeMemory32(at:a+4,value:0xA5300123|(dlc<<16))
                for i:UInt32 in 80..<160 {m.set(8,i,0xCC)}
            };XCTAssertEqual(p.check(45,FDCANConstants.FDCAN_RX_FIFO0+fifo),0)
            let length=FDCAN<FDCANModel,FDCANModel,FDCANModel>.payloadByteCount(dataLength:dlc)
            for i in length..<80 {XCTAssertEqual(p.swift.get(8,80+i),0xCC)}
        } } } }
    }
    func testTxEventHeaderDecodingAndAcknowledgement() {
        for index:UInt32 in 0...2 {for seed:UInt32 in [0,1,0x12345678,0xFFFFFFFF] {
            let p=FDCANPair();p.ready();p.setup {m in
                m.write(.state,value:2);m.write(.txefs,value:3|(index<<8))
                let a=m.read(FDCANHandleWord.txEventFIFOSA)+index*8
                m.writeMemory32(at:a,value:seed);m.writeMemory32(at:a+4,value:seed^0x76543210)
            };p.check(46)
        } }
    }
    func testInterruptGroupsAndLineDisableDecisions() {
        for selection:UInt32 in 0..<128 {for mask:UInt32 in [0,1,7,0x38,0x40,0x180,0xE00,0x1C0000,0xE00000,0xFFFFFF] {
            let p=FDCANPair();p.ready();p.setup {m in m.write(.ils,value:selection);m.write(.ile,value:3);m.write(.ie,value:0xFFFFFF);m.write(.txbtie,value:5);m.write(.txbcie,value:6)}
            p.check(56,mask,3);p.check(57,mask);p.check(55,selection,1);p.check(55,selection,2)
        } }
    }
    func testInterruptSnapshotsCallbackMutationAndLiveError() {
        for mode:UInt32 in 0...1 {for mask:UInt32 in [0,1,8,64,128,256,512,1024,0x1000,0x2000,0x10000,0xE0000,0xF00000,0xFFFFFF] {
            for mutation:UInt32 in [0,1,2,3,4,8,16,31] {for enabled:UInt32 in [0,0xAAAAAA,0xFFFFFF] {
                let p=FDCANPair(mode:mode);p.ready();p.setup {m in
                    m.write(.ir,value:mask);m.write(.ie,value:enabled);m.write(.txbcf,value:7);m.write(.txbcie,value:3)
                    m.write(.txbto,value:6);m.write(.txbtie,value:5);m.write(.errorCode,value:mutation&1)
                };p.set(4,4,mutation);p.check(58)
            } }
        } }
    }
}
