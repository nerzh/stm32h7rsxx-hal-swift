import XCTest
import CADCReference
import STM32H7RSHAL

final class ADCPair {
    private let cStorage = UnsafeMutableRawPointer.allocate(byteCount: CADC_Size(), alignment: 16)
    private let swiftStorage = UnsafeMutableRawPointer.allocate(byteCount: CADC_Size(), alignment: 16)
    let mode: UInt32
    var c: ADCModel { .init(state: OpaquePointer(cStorage), mode: mode) }
    var swift: ADCModel { .init(state: OpaquePointer(swiftStorage), mode: mode) }
    init(mode: UInt32 = 0, instance: UInt32 = 0) {
        self.mode = mode
        CADC_Reset(OpaquePointer(cStorage), mode, instance)
        CADC_Reset(OpaquePointer(swiftStorage), mode, instance)
    }
    deinit { cStorage.deallocate(); swiftStorage.deallocate() }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { c.set(area, index, value); swift.set(area, index, value) }
    func setup(_ body: (ADCModel) -> Void) { body(c); body(swift) }
    @discardableResult
    func check(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ argument: UInt32 = 0,
               file: StaticString = #filePath, line: UInt = #line) -> UInt32 {
        let expected = CADC_Run(c.state, op, a, b, argument)
        let actual = swift.run(op, a, b, argument)
        XCTAssertEqual(actual, expected, "ADC operation \(op)", file: file, line: line)
        func normalized(_ m: ADCModel, _ area: UInt32, _ index: UInt32) -> UInt32 {
            let value = m.get(area,index)
            if (area == 6 && index == 9) || (area == 7 && index % 16 == 13) {
                if value == CADC_DMADataAddress(m.state,0) { return 0x40022040 + m.get(5,2) * 0x100 }
                if value == CADC_DMADataAddress(m.state,1) { return 0x4002230C }
            }
            return value
        }
        for id: UInt32 in 0..<3 { XCTAssertEqual(CADC_GetDMACallback(c.state,id),CADC_GetDMACallback(swift.state,id),"DMA callback",file:file,line:line) }
        for (area, count): (UInt32, UInt32) in [(0,102),(1,4),(2,25),(3,60),(4,16),(5,5),(6,14),(7,512)] {
            if let index = (0..<count).first(where: { normalized(c,area,$0) != normalized(swift,area,$0) }) {
                XCTFail("ADC op \(op), area \(area), index \(index): C=\(c.get(area,index)), Swift=\(swift.get(area,index))", file: file, line: line)
            }
        }
        for id: UInt32 in 0..<11 {
            XCTAssertEqual(CADC_GetCallback(c.state,id), CADC_GetCallback(swift.state,id), "callback \(id), op \(op)", file: file, line: line)
        }
        return actual
    }
}

final class ADCDifferentialTests: XCTestCase {
    func testInitializationSharedClockAndActiveGroups() {
        for mode: UInt32 in 0...1 { for instance: UInt32 in 0...1 {
            for enabled: UInt32 in [0,1,4,8,13] { for neighbour: UInt32 in [0,1] { for state: UInt32 in [0,1,16,0xFFFFFFFF] {
                let p = ADCPair(mode: mode, instance: instance)
                p.set(0, instance * 51 + 2, 0x20000000 | enabled)
                p.set(0, (1-instance) * 51 + 2, neighbour)
                p.set(1, 2, 0xA5A5A5A5); p.set(2, 21, state)
                p.set(2, 0, ADCConstants.ADC_CLOCK_ASYNC_DIV16)
                p.setup { m in for id: UInt32 in 0..<11 { CADC_SetCallback(m.state,id,id < 9 ? 2 : 0) } }
                p.check(0)
            } } }
        } }
    }
    func testInitializationConfigurationSweep() {
        for v: UInt32 in 0..<128 {
            let p = ADCPair(instance: v & 1)
            p.setup { m in
                m.write(.resolution,value:(v&3)<<3); m.write(.dataAlign,value:(v&1)<<5)
                m.write(.scanConvMode,value:(v>>1)&1); m.write(.continuousConvMode,value:(v>>2)&1)
                m.write(.discontinuousConvMode,value:(v>>3)&1); m.write(.nbrOfDiscConversion,value:(v&7)+1)
                m.write(.nbrOfConversion,value:(v&15)+1); m.write(.externalTrigConv,value: v&1 == 0 ? ADCConstants.ADC_SOFTWARE_START : ADCConstants.ADC_EXTERNALTRIG_T1_CC2)
                m.write(.externalTrigConvEdge,value:((v>>4)&3)<<10)
                m.write(.lowPowerAutoWait,value:(v>>3)&1); m.write(.oversamplingMode,value:(v>>4)&1)
                m.write(.oversamplingRatio,value:(v&7)<<2); m.write(.oversamplingRightBitShift,value:(v&7)<<5)
                m.write(.oversamplingTriggeredMode,value:(v&1)<<9); m.write(.oversamplingOversamplingStopReset,value:(v&1)<<10)
                m.write(.conversionDataManagement,value: v&1 == 0 ? 2 : 0x80000000)
                m.write(.overrun,value:(v&1)<<12); m.write(.samplingMode,value:(v&3)<<25)
            }
            p.check(0)
        }
    }
    func testEnableDisableAndStopDeadlines() {
        for instance: UInt32 in 0...1 { for op: UInt32 in [20,21,22,1,5,9] {
            for cr: UInt32 in [0,1,2,4,5,8,9,12,13,16,32,0x80000000] {
                let p = ADCPair(instance: instance)
                p.set(0,instance*51+2,cr); p.set(0,instance*51,0)
                p.set(5,0,UInt32.max-4); p.check(op,ADCConstants.ADC_REGULAR_INJECTED_GROUP)
            }
        } }
        for op: UInt32 in [20,21,22,1,5,9] { for tick: UInt32 in [1,2,3] {
            let p = ADCPair(mode: 1)
            p.set(0,2,op == 21 ? 0 : 1); p.set(0,0,0)
            p.set(4,1,tick); p.set(4,2,1); p.set(4,3,1|4|8|16|32)
            p.check(op,ADCConstants.ADC_REGULAR_INJECTED_GROUP)
        } }
    }
    func testRegularStartAndPollingInEveryMultimode() {
        for mode: UInt32 in 0...31 { for instance: UInt32 in 0...1 { for op: UInt32 in [4,8,6] {
            for config: UInt32 in [0,0x02000000,0x400,0x4000,0x02002000] {
                let p = ADCPair(instance: instance)
                p.set(1,2,mode); p.set(0,instance*51+3,config); p.set(0,(1-instance)*51+3,config^0x02000000)
                p.set(0,instance*51,15); p.set(2,21,0x100100); p.set(2,22,0xF)
                p.check(op,0)
            }
        } } }
    }
    func testPollingEventFlagsTimeoutAndAutowait() {
        for op: UInt32 in [6,7] { for flag: UInt32 in [2,4,8,16,128,256,512,1024] {
            for selection: UInt32 in [4,8] { for arrival: UInt32 in [0,1,2,3] {
                let p = ADCPair()
                p.set(2,4,selection); p.set(0,0,0); p.set(4,1,arrival); p.set(4,2,flag)
                p.set(5,0,UInt32.max-2); p.set(2,20,1)
                p.check(op,op == 6 ? 3 : flag,3)
            } }
        } }
    }
    func testCalibrationAndValueAccess() {
        for single: UInt32 in [ADCConstants.ADC_SINGLE_ENDED,ADCConstants.ADC_DIFFERENTIAL_ENDED] {
            for op: UInt32 in [26,27,28] { for cr: UInt32 in [0,1,2,4,8,13] {
                let p = ADCPair()
                p.set(0,2,cr); p.set(0,45,0x12345678); p.set(4,10,3)
                p.check(op,single,0x55)
            } }
        }
        for op: UInt32 in [12,13,14,18,19] {
            let p = ADCPair(); p.set(0,16,0xBAAD1234); p.check(op)
        }
    }
    func testCallbackRegistrationStateMasksAndNullCallbacks() {
        for state: UInt32 in [0,1,2,16,17,0x1101] { for id: UInt32 in 0...12 { for token: UInt32 in 0...2 {
            let p = ADCPair(mode: 1); p.set(2,21,state)
            p.check(2,id,token); p.check(3,id)
        } } }
    }
}
