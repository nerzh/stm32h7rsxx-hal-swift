import XCTest
import CFDCANReference
import STM32H7RSHAL

private final class FDCANAccessProbe: FDCANRegisterIO, FDCANHandleIO, FDCANCallbackIO {
    let model=FDCANModel(state:CFDCAN_Create(1,0)!,mode:1)
    var states:[UInt32]=[]
    var stateReads=0
    var reads:[FDCANRegister]=[]
    var callbackWrites:[FDCANCallbackID]=[]
    var ignoreInit=false
    deinit {CFDCAN_Destroy(model.state)}
    var context:UnsafeMutableRawPointer? {model.context}
    var driver:FDCAN<FDCANAccessProbe,FDCANAccessProbe,FDCANAccessProbe> {.init(instance:.fdcan1,registers:self,handle:self,callbacks:self,defaults:model.defaults,useRegisteredCallbacks:true)}
    func read(_ r:FDCANRegister)->UInt32 {reads.append(r);return model.read(r)}
    func write(_ r:FDCANRegister,value:UInt32) {model.write(r,value:r == .cccr && ignoreInit ? value & ~1:value)}
    func read(_ w:FDCANHandleWord)->UInt32 {
        if w == .state {stateReads+=1;if !states.isEmpty {return states.removeFirst()}}
        return model.read(w)
    }
    func write(_ w:FDCANHandleWord,value:UInt32) {model.write(w,value:value)}
    func read(_ id:FDCANCallbackID)->FDCANCallback? {model.read(id)}
    func write(_ id:FDCANCallbackID,value:FDCANCallback?) {callbackWrites.append(id);model.write(id,value:value)}
    func readClockDivider()->UInt32 {model.readClockDivider()}
    func writeClockDivider(_ value:UInt32) {model.writeClockDivider(value)}
    func messageRAMBase()->UInt32 {model.messageRAMBase()}
    func readMemory32(at address:UInt32)->UInt32 {model.readMemory32(at:address)}
    func writeMemory32(at address:UInt32,value:UInt32) {model.writeMemory32(at:address,value:value)}
    func readMemory8(at address:UInt32)->UInt8 {model.readMemory8(at:address)}
}

final class FDCANAccessTests:XCTestCase {
    func testCallbackRegistrationRereadsStateForTheResetBranch() {
        for unregister in [false,true] {
            let p=FDCANAccessProbe();p.states=[2,0]
            let status=unregister ? p.driver.unregisterCallback(.mspInit):p.driver.registerCallback(.mspInit,callback:FDCANModel.callback(5,2))
            XCTAssertEqual(status,.ok);XCTAssertEqual(p.stateReads,2)
            XCTAssertEqual(CFDCAN_GetCallback(p.model.state,5),unregister ? 1:2)
        }
        let ready=FDCANAccessProbe();ready.states=[1,0]
        XCTAssertEqual(ready.driver.registerCallback(.txEventFifo,callback:FDCANModel.callback(7,2)),.error)
        XCTAssertEqual(ready.stateReads,1)
    }
    func testInitializationPreservesReferenceCallbackWriteOrder() {
        let p=FDCANAccessProbe()
        XCTAssertEqual(p.driver.initialize(getTick:{0}),.ok)
        XCTAssertEqual(p.callbackWrites,[.txEventFifo,.rxFifo0,.rxFifo1,.txFifoEmpty,.txBufferComplete,.txBufferAbort,
            .highPriorityMessage,.timestampWraparound,.timeoutOccurred,.error,.errorStatus])
    }
    func testStatusReadsAndStopIterationDeadline() {
        let p=FDCANAccessProbe();p.model.write(.psr,value:0xFFFFFFFF);p.model.write(.ecr,value:0xFFFFFFFF)
        var protocolStatus=FDCANProtocolStatus();var counters=FDCANErrorCounters();var priority=FDCANHighPriorityMessageStatus()
        p.driver.getProtocolStatus(&protocolStatus);p.driver.getErrorCounters(&counters);p.driver.getHighPriorityMessageStatus(&priority)
        XCTAssertEqual(p.reads,[.psr,.ecr,.hpms,.hpms,.hpms,.hpms])
        p.reads=[];p.model.write(.state,value:2);p.ignoreInit=true
        XCTAssertEqual(p.driver.stop(),.error)
        XCTAssertEqual(p.reads,Array(repeating:.cccr,count:13))
        XCTAssertEqual(p.model.read(.state),3);XCTAssertEqual(p.model.read(.errorCode),1)
    }
}
