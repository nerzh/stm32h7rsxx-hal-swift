import XCTest
import STM32H7RSHAL

private final class ADCAccessModel: ADCRegisterIO {
    let model: ADCModel
    var accesses: [String] = []
    var delays: [UInt32] = []
    var readyOnSecondRead = false
    var flagReads = 0
    init(_ model: ADCModel) { self.model = model }
    func read(_ register: ADCRegister, instance: ADCInstance) -> UInt32 {
        accesses.append("r\(instance.rawValue):\(register.rawValue)")
        if register == .isr {
            flagReads += 1
            if readyOnSecondRead && flagReads == 2 { model.write(.isr,instance:instance,value:1) }
        }
        return model.read(register,instance:instance)
    }
    func write(_ register: ADCRegister, instance: ADCInstance, value: UInt32) {
        accesses.append("w\(instance.rawValue):\(register.rawValue)=\(value)")
        model.write(register,instance:instance,value:value)
    }
    func readCommon(_ register: ADCCommonRegister) -> UInt32 {
        accesses.append("rc:\(register.rawValue)"); return model.readCommon(register)
    }
    func writeCommon(_ register: ADCCommonRegister, value: UInt32) {
        accesses.append("wc:\(register.rawValue)=\(value)"); model.writeCommon(register,value:value)
    }
    func dataAddress(instance: ADCInstance) -> UInt32 { model.dataAddress(instance:instance) }
    func commonDataAddress() -> UInt32 { model.commonDataAddress() }
    func systemCoreClock() -> UInt32 { model.systemCoreClock() }
    func stabilizationDelay(iterations: UInt32) { delays.append(iterations) }
    var driver: ADC<ADCAccessModel,ADCModel,ADCModel,ADCModel> {
        .init(instance:ADCInstance(rawValue:model.get(5,2))!,registers:self,handle:model,callbacks:model,dma:model,defaults:model.defaults)
    }
}
final class ADCAccessTests: XCTestCase {
    func testBothCommonEnableReadsAndNoShortCircuit() {
        let pair=ADCPair(), spy=ADCAccessModel(pair.swift)
        pair.set(0,2,1)
        XCTAssertEqual(spy.driver.configureMultimode(.init(mode:1)),.ok)
        XCTAssertEqual(spy.accesses,["r1:8","r0:8","rc:8","wc:8=0","r0:8","r1:8"])
    }
    func testVolatileDelayCountsRetainInjectedAdditionalIncrement() {
        let pair=ADCPair(), spy=ADCAccessModel(pair.swift)
        XCTAssertEqual(spy.driver.initialize(),.ok)
        XCTAssertEqual(spy.delays,[642]); spy.delays=[]
        XCTAssertEqual(spy.driver.configureChannel(.init(channel:ADCConstants.ADC_CHANNEL_TEMPSENSOR,rank:ADCConstants.ADC_REGULAR_RANK_1,
            singleDiff:ADCConstants.ADC_SINGLE_ENDED,offsetNumber:ADCConstants.ADC_OFFSET_NONE)),.ok)
        XCTAssertEqual(spy.delays,[3852]); spy.delays=[]; pair.set(1,2,0)
        XCTAssertEqual(spy.driver.configureInjectedChannel(.init(injectedChannel:ADCConstants.ADC_CHANNEL_TEMPSENSOR,injectedRank:ADCConstants.ADC_INJECTED_RANK_1,
            injectedSingleDiff:ADCConstants.ADC_SINGLE_ENDED,injectedOffsetNumber:ADCConstants.ADC_OFFSET_NONE,injectedNbrOfConversion:1,
            externalTrigInjecConv:ADCConstants.ADC_INJECTED_SOFTWARE_START)),.ok)
        XCTAssertEqual(spy.delays,[3864]); spy.delays=[]
        XCTAssertEqual(spy.driver.enable(getTick:pair.swift.tick),.ok)
        XCTAssertEqual(spy.delays,[3852])
    }
    func testEnableRereadsReadyAtTimeoutAndClearsCommandBits() {
        let pair=ADCPair(), spy=ADCAccessModel(pair.swift)
        pair.set(0,0,0); spy.readyOnSecondRead=true
        XCTAssertEqual(spy.driver.enable(getTick:pair.swift.tick),.ok)
        XCTAssertEqual(spy.flagReads,3); XCTAssertEqual(pair.swift.get(5,1),2)
        XCTAssertEqual(pair.swift.get(0,2),1)
        pair.set(0,2,0x8000003E)
        XCTAssertEqual(spy.driver.enterDeepPowerDownMode(),.ok)
        XCTAssertEqual(pair.swift.get(0,2),0x20000000)
    }
}
