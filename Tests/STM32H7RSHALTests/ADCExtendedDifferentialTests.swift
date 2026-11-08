import XCTest
import CADCReference
import STM32H7RSHAL

final class ADCExtendedDifferentialTests: XCTestCase {
    func testAll48UpstreamEntriesInBothCallbackModes() {
        for mode: UInt32 in 0...1 { for instance: UInt32 in 0...1 { for op: UInt32 in 0..<48 {
            let p = ADCPair(mode: mode, instance: instance)
            p.set(4,10,2)
            p.set(3,0,ADCConstants.ADC_CHANNEL_3); p.set(3,1,ADCConstants.ADC_REGULAR_RANK_1)
            p.set(3,3,ADCConstants.ADC_SINGLE_ENDED); p.set(3,4,ADCConstants.ADC_OFFSET_NONE)
            p.set(3,20,ADCConstants.ADC_ANALOGWATCHDOG_1); p.set(3,22,ADCConstants.ADC_CHANNEL_3)
            p.set(3,40,ADCConstants.ADC_CHANNEL_3); p.set(3,41,ADCConstants.ADC_INJECTED_RANK_1)
            p.set(3,43,ADCConstants.ADC_SINGLE_ENDED); p.set(3,44,ADCConstants.ADC_OFFSET_NONE)
            p.set(3,48,1); p.set(3,52,ADCConstants.ADC_INJECTED_SOFTWARE_START)
            let a: UInt32
            if [26,27,28].contains(op) { a = ADCConstants.ADC_SINGLE_ENDED }
            else if op == 20 { a = ADCConstants.ADC_REGULAR_INJECTED_GROUP }
            else if op == 7 { a = ADCConstants.ADC_EOSMP_EVENT }
            else if op == 10 || op == 34 { a = 0x3000 }
            else { a = 0 }
            p.check(op,a,op == 10 || op == 34 ? 16 : 0)
        } } }
    }
    func testEveryChannelRegularRankSamplingOffsetAndActiveGroup() {
        let channels: [UInt32] = [ADCConstants.ADC_CHANNEL_0, ADCConstants.ADC_CHANNEL_1, ADCConstants.ADC_CHANNEL_2, ADCConstants.ADC_CHANNEL_3, ADCConstants.ADC_CHANNEL_4, ADCConstants.ADC_CHANNEL_5, ADCConstants.ADC_CHANNEL_6, ADCConstants.ADC_CHANNEL_7, ADCConstants.ADC_CHANNEL_8, ADCConstants.ADC_CHANNEL_9, ADCConstants.ADC_CHANNEL_10, ADCConstants.ADC_CHANNEL_11, ADCConstants.ADC_CHANNEL_12, ADCConstants.ADC_CHANNEL_13, ADCConstants.ADC_CHANNEL_14, ADCConstants.ADC_CHANNEL_15, ADCConstants.ADC_CHANNEL_16, ADCConstants.ADC_CHANNEL_17, ADCConstants.ADC_CHANNEL_18, ADCConstants.ADC_CHANNEL_TEMPSENSOR, ADCConstants.ADC_CHANNEL_VBAT, ADCConstants.ADC_CHANNEL_VREFINT, ADCConstants.ADC_CHANNEL_VDDCORE]
        let ranks: [UInt32] = [ADCConstants.ADC_REGULAR_RANK_1, ADCConstants.ADC_REGULAR_RANK_2, ADCConstants.ADC_REGULAR_RANK_3, ADCConstants.ADC_REGULAR_RANK_4, ADCConstants.ADC_REGULAR_RANK_5, ADCConstants.ADC_REGULAR_RANK_6, ADCConstants.ADC_REGULAR_RANK_7, ADCConstants.ADC_REGULAR_RANK_8, ADCConstants.ADC_REGULAR_RANK_9, ADCConstants.ADC_REGULAR_RANK_10, ADCConstants.ADC_REGULAR_RANK_11, ADCConstants.ADC_REGULAR_RANK_12, ADCConstants.ADC_REGULAR_RANK_13, ADCConstants.ADC_REGULAR_RANK_14, ADCConstants.ADC_REGULAR_RANK_15, ADCConstants.ADC_REGULAR_RANK_16]
        let times: [UInt32] = [ADCConstants.ADC_SAMPLETIME_2CYCLES_5, ADCConstants.ADC_SAMPLETIME_3CYCLES_5, ADCConstants.ADC_SAMPLETIME_6CYCLES_5, ADCConstants.ADC_SAMPLETIME_12CYCLES_5, ADCConstants.ADC_SAMPLETIME_24CYCLES_5, ADCConstants.ADC_SAMPLETIME_47CYCLES_5, ADCConstants.ADC_SAMPLETIME_92CYCLES_5, ADCConstants.ADC_SAMPLETIME_247CYCLES_5, ADCConstants.ADC_SAMPLETIME_640CYCLES_5]
        for instance: UInt32 in 0...1 { for (i,ch) in channels.enumerated() { for (rankIndex,rank) in ranks.enumerated() {
            for cr: UInt32 in [0,1,4,8] {
                let p = ADCPair(instance: instance)
                p.set(0,instance*51+2,cr); p.set(0,instance*51+3,UInt32(rankIndex&3)<<3)
                p.set(3,0,ch); p.set(3,1,rank); p.set(3,2,times[(i+rankIndex)%times.count])
                p.set(3,3,i < 16 && i&1 == 0 ? ADCConstants.ADC_DIFFERENTIAL_ENDED : ADCConstants.ADC_SINGLE_ENDED)
                p.set(3,4,rankIndex%5 == 4 ? ADCConstants.ADC_OFFSET_NONE : UInt32(rankIndex%5))
                p.set(3,5,UInt32(i+7)); p.set(3,6,rankIndex&1 == 0 ? ADCConstants.ADC_OFFSET_SIGN_NEGATIVE : ADCConstants.ADC_OFFSET_SIGN_POSITIVE)
                p.set(3,7,UInt32(rankIndex&1))
                for j: UInt32 in 24...27 { p.set(0,instance*51+j,0xFFFF_FFFF) }
                p.check(16)
            }
        } } }
    }
    func testInjectedContextAssemblyAndErrorsKeepEarlierWrites() {
        let ranks: [UInt32] = [ADCConstants.ADC_INJECTED_RANK_3,ADCConstants.ADC_INJECTED_RANK_1,ADCConstants.ADC_INJECTED_RANK_4,ADCConstants.ADC_INJECTED_RANK_2]
        for instance: UInt32 in 0...1 { for cr: UInt32 in [0,1,4,8] { for config: UInt32 in 0..<32 {
            let p = ADCPair(instance: instance)
            p.set(0,instance*51+2,cr); p.set(2,3,(config>>4)&1)
            p.set(3,43,ADCConstants.ADC_SINGLE_ENDED); p.set(3,44,config&3)
            p.set(3,45,0x55); p.set(3,46,(config&1)<<24); p.set(3,47,(config>>1)&1)
            p.set(3,48,4); p.set(3,49,config&1); p.set(3,50,(config>>1)&1); p.set(3,51,(config>>2)&1)
            p.set(3,52,config&1 == 0 ? ADCConstants.ADC_INJECTED_SOFTWARE_START : ADCConstants.ADC_EXTERNALTRIGINJEC_T1_TRGO)
            p.set(3,53,(config&3)<<6); p.set(3,54,(config>>3)&1); p.set(3,55,12); p.set(3,56,96)
            for (i,rank) in ranks.enumerated() {
                p.set(3,40,ADCHelpers.channel(UInt32(i+2))); p.set(3,41,rank)
                p.set(3,42,UInt32(i)); p.check(42)
            }
        } } }
        for instance: UInt32 in 0...1 { for channel: UInt32 in [ADCConstants.ADC_CHANNEL_TEMPSENSOR,ADCConstants.ADC_CHANNEL_VBAT,ADCConstants.ADC_CHANNEL_VREFINT,ADCConstants.ADC_CHANNEL_VDDCORE] {
            let p = ADCPair(instance: instance)
            p.set(3,40,channel); p.set(3,41,ADCConstants.ADC_INJECTED_RANK_1)
            p.set(3,43,ADCConstants.ADC_SINGLE_ENDED); p.set(3,44,ADCConstants.ADC_OFFSET_NONE)
            p.set(3,48,1); p.set(3,52,ADCConstants.ADC_INJECTED_SOFTWARE_START)
            p.check(42)
        } }
    }
    func testAnalogWatchdogsThresholdsAndBusyGroups() {
        let modes: [UInt32] = [ADCConstants.ADC_ANALOGWATCHDOG_NONE,ADCConstants.ADC_ANALOGWATCHDOG_SINGLE_REG,ADCConstants.ADC_ANALOGWATCHDOG_SINGLE_INJEC,ADCConstants.ADC_ANALOGWATCHDOG_SINGLE_REGINJEC,ADCConstants.ADC_ANALOGWATCHDOG_ALL_REG,ADCConstants.ADC_ANALOGWATCHDOG_ALL_INJEC,ADCConstants.ADC_ANALOGWATCHDOG_ALL_REGINJEC]
        for watchdog: UInt32 in [ADCConstants.ADC_ANALOGWATCHDOG_1,ADCConstants.ADC_ANALOGWATCHDOG_2,ADCConstants.ADC_ANALOGWATCHDOG_3] {
            for mode in modes { for cr: UInt32 in [0,4,8] { for resolution: UInt32 in [0,8,16,24] { for interrupt: UInt32 in [0,1] {
                let p = ADCPair(); p.set(0,2,cr); p.set(0,3,resolution)
                p.set(0,40,0x100); p.set(0,41,0x200); p.set(2,21,0x70000)
                p.set(3,20,watchdog); p.set(3,21,mode); p.set(3,22,ADCConstants.ADC_CHANNEL_7)
                p.set(3,23,interrupt); p.set(3,24,0x3F); p.set(3,25,0x10); p.set(3,26,ADCConstants.ADC_AWD_FILTERING_8SAMPLES)
                p.check(17)
            } } } }
        }
    }
    func testInjectedStartsPollsAndSeparateStops() {
        for instance: UInt32 in 0...1 { for mode: UInt32 in 0...31 { for op: UInt32 in [29,30,31,32,33,38,39,44,45,46,47] {
            for config: UInt32 in [0,0x80000000,0x82000000,0x82402000] {
                let p = ADCPair(instance: instance)
                p.set(1,2,mode); p.set(0,instance*51+3,config); p.set(0,(1-instance)*51+3,config^0x02000000)
                p.set(0,instance*51,0x7F); p.set(2,21,0x101100); p.set(2,22,0xF)
                p.check(op,0)
            }
        } } }
    }
    func testInterruptSnapshotsLiveFlagsAndCallbackMutation() {
        for mode: UInt32 in 0...1 { for instance: UInt32 in 0...1 { for mask: UInt32 in [0,2,4,8,12,32,64,96,128,256,512,16,1024,0x7FF] {
            for mutation: UInt32 in 0...3 { for config: UInt32 in [0,1,0x2000,0x4000,0x02000000] {
                let p = ADCPair(mode: mode,instance: instance)
                p.set(0,instance*51,mask); p.set(0,instance*51+1,0x7FF); p.set(0,instance*51+3,config)
                p.set(0,(1-instance)*51+3,config^0x2000); p.set(1,2,instance == 0 ? 0 : 1)
                p.set(2,21,0x1100); p.set(4,6,mutation); p.check(15)
            } }
        } } }
        for state: UInt32 in [0,16,64,80,0x100,0x1100] { for flags: UInt32 in [0,8] { for config: UInt32 in [0,2,0x400,0x2000] {
            let p = ADCPair(mode: 1); p.set(2,21,state); p.set(0,0,flags); p.set(0,3,config)
            p.check(23); p.check(24); p.check(25)
        } } }
    }
    func testMultimodeConfigBothADCsAndReadback() {
        for instance: UInt32 in 0...1 { for master: UInt32 in [0,1,4,8] { for slave: UInt32 in [0,1,4,8] {
            for mode: UInt32 in [0,1,5,9] {
                let p = ADCPair(instance: instance); p.set(0,2,master); p.set(0,53,slave)
                p.set(1,2,0xA5A5A5A5); p.set(2,13,2)
                p.check(43,mode,0x6000,0x300); p.set(1,3,0x12345678); p.check(36)
                for rank: UInt32 in [0,ADCConstants.ADC_INJECTED_RANK_1,ADCConstants.ADC_INJECTED_RANK_2,ADCConstants.ADC_INJECTED_RANK_3,ADCConstants.ADC_INJECTED_RANK_4] { p.check(37,rank) }
            }
        } } }
    }
    func testDMASubmissionWidthsFailuresAndPartialSetup() {
        for op: UInt32 in [10,34] { for instance: UInt32 in 0...1 { for list: UInt32 in [0,0x80,0x81] {
            for width: UInt32 in [0,1,2] { for result: UInt32 in 0...3 { for missing: UInt32 in 0...3 {
                let p = ADCPair(mode: 1,instance: instance)
                p.set(0,0,1); p.set(0,51,1); p.set(6,1,list); p.set(6,0,width); p.set(6,5,width)
                p.set(6,3,missing&1 == 0 ? 1 : 0); p.set(6,4,missing&2 == 0 ? 1 : 0)
                p.set(4,7,result); p.check(op,0x3000,19)
            } } }
        } } }
        for op: UInt32 in [10,34] { for width: UInt32 in 0...2 {
            let p = ADCPair(); p.set(0,51,1); p.set(6,0,width); p.check(op,0x3000,UInt32.max)
            let bad = ADCPair(); bad.set(0,51,1); bad.set(6,1,0x80); bad.set(4,9,1); bad.check(op,0x3000,8)
        } }
    }
    func testDMAStopsPreserveDistinctAbortAndDisableStatuses() {
        for op: UInt32 in [11,35,40,41] { for instance: UInt32 in 0...1 { for result: UInt32 in 0...3 {
            for cr: UInt32 in [0,1,2,4,8,13] { for slave: UInt32 in [0,1,4,8] {
                let p = ADCPair(instance: instance); p.set(0,instance*51+2,cr); p.set(0,(1-instance)*51+2,slave)
                p.set(2,21,0x1100); p.set(6,2,2); p.set(4,8,result)
                p.check(op)
            } }
        } } }
    }
}
