import CADCReference
import STM32H7RSHAL

struct ADCModel: ADCRegisterIO, ADCHandleIO, ADCCallbackIO, ADCDMAIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func get(_ area: UInt32, _ i: UInt32) -> UInt32 { CADC_Get(state, area, i) }
    func set(_ area: UInt32, _ i: UInt32, _ value: UInt32) { CADC_Set(state, area, i, value) }
    func read(_ register: ADCRegister, instance: ADCInstance) -> UInt32 { CADC_ReadRegister(state, instance.rawValue, register.rawValue) }
    func write(_ register: ADCRegister, instance: ADCInstance, value: UInt32) { set(0, instance.rawValue * 51 + register.rawValue / 4, value) }
    func readCommon(_ register: ADCCommonRegister) -> UInt32 { get(1, register.rawValue / 4) }
    func writeCommon(_ register: ADCCommonRegister, value: UInt32) { set(1, register.rawValue / 4, value) }
    func dataAddress(instance: ADCInstance) -> UInt32 { CADC_DMADataAddress(state, 0) }
    func commonDataAddress() -> UInt32 { CADC_DMADataAddress(state, 1) }
    func systemCoreClock() -> UInt32 { get(4, 11) }
    func stabilizationDelay(iterations: UInt32) {}
    func read(_ word: ADCHandleWord) -> UInt32 { get(2, UInt32(word.rawValue)) }
    func write(_ word: ADCHandleWord, value: UInt32) { set(2, UInt32(word.rawValue), value) }
    func read(_ id: ADCCallbackID) -> ADCCallback? { Self.callback(id.rawValue, CADC_GetCallback(state, id.rawValue)) }
    func write(_ id: ADCCallbackID, value: ADCCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(Self.callback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CADC_SetCallback(state, id.rawValue, token)
    }
    static func callback(_ id: UInt32, _ token: UInt32) -> ADCCallback? {
        if token == 0 { return nil }
        switch (id, token) {
        case (0, 1): return { CADC_Callback(OpaquePointer($0!), 0, 1) }
        case (0, 2): return { CADC_Callback(OpaquePointer($0!), 0, 2) }
        case (1, 1): return { CADC_Callback(OpaquePointer($0!), 1, 1) }
        case (1, 2): return { CADC_Callback(OpaquePointer($0!), 1, 2) }
        case (2, 1): return { CADC_Callback(OpaquePointer($0!), 2, 1) }
        case (2, 2): return { CADC_Callback(OpaquePointer($0!), 2, 2) }
        case (3, 1): return { CADC_Callback(OpaquePointer($0!), 3, 1) }
        case (3, 2): return { CADC_Callback(OpaquePointer($0!), 3, 2) }
        case (4, 1): return { CADC_Callback(OpaquePointer($0!), 4, 1) }
        case (4, 2): return { CADC_Callback(OpaquePointer($0!), 4, 2) }
        case (5, 1): return { CADC_Callback(OpaquePointer($0!), 5, 1) }
        case (5, 2): return { CADC_Callback(OpaquePointer($0!), 5, 2) }
        case (6, 1): return { CADC_Callback(OpaquePointer($0!), 6, 1) }
        case (6, 2): return { CADC_Callback(OpaquePointer($0!), 6, 2) }
        case (7, 1): return { CADC_Callback(OpaquePointer($0!), 7, 1) }
        case (7, 2): return { CADC_Callback(OpaquePointer($0!), 7, 2) }
        case (8, 1): return { CADC_Callback(OpaquePointer($0!), 8, 1) }
        case (8, 2): return { CADC_Callback(OpaquePointer($0!), 8, 2) }
        case (9, 1): return { CADC_Callback(OpaquePointer($0!), 9, 1) }
        case (9, 2): return { CADC_Callback(OpaquePointer($0!), 9, 2) }
        case (10, 1): return { CADC_Callback(OpaquePointer($0!), 10, 1) }
        case (10, 2): return { CADC_Callback(OpaquePointer($0!), 10, 2) }
        default: return nil
        }
    }
    var defaults: ADCCallbackDefaults { .init(conversionComplete: Self.callback(0, 1)!, conversionHalfComplete: Self.callback(1, 1)!, analogWatchdog1: Self.callback(2, 1)!, error: Self.callback(3, 1)!, injectedComplete: Self.callback(4, 1)!, injectedQueueOverflow: Self.callback(5, 1)!, analogWatchdog2: Self.callback(6, 1)!, analogWatchdog3: Self.callback(7, 1)!, endSampling: Self.callback(8, 1)!, mspInitialize: Self.callback(9, 1)!, mspDeinitialize: Self.callback(10, 1)!) }
    var driver: ADC<Self, Self, Self, Self> {
        .init(instance: ADCInstance(rawValue: get(5, 2))!, registers: self, handle: self, callbacks: self,
              dma: self, defaults: defaults, useRegisteredCallbacks: mode != 0)
    }
    func sourceDataWidth() -> UInt32 { get(6,0) }
    func read(_ word: DMAHandleWord) -> UInt32 {
        switch word {
        case .mode: return get(6,1)
        case .state: return get(6,2)
        case .queueAddress: return get(6,3) == 0 ? 0 : 0x1000
        default: preconditionFailure("Unexpected DMA field")
        }
    }
    func readMemory32(at address: UInt32) -> UInt32 {
        if address == 0x1000 { return get(6,4) == 0 ? 0 : 0x2000 }
        return get(6, 6 + (address - 0x2000) / 4)
    }
    func writeMemory32(at address: UInt32, value: UInt32) { set(6,6+(address-0x2000)/4,value) }
    func writeCallback(_ id: DMACallbackID, value: DMACallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0,to:UInt.self) == unsafeBitCast(Self.dmaCallback(id.rawValue,1)!,to:UInt.self) ? 1 : 2 } ?? 0
        CADC_SetDMACallback(state,id.rawValue,token)
    }
    func callback(_ kind: ADCDMACallbackKind) -> DMACallback { Self.dmaCallback(kind.rawValue,1)! }
    static func dmaCallback(_ id: UInt32, _ token: UInt32) -> DMACallback? {
        if token == 0 { return nil }
        switch (id,token) {
        case (0,1): return { let s=OpaquePointer($0!); let m=ADCModel(state:s,mode:CADC_Mode(s)); m.driver.dmaConversionComplete(context:$0) }
        case (1,1): return { let s=OpaquePointer($0!); ADCModel(state:s,mode:CADC_Mode(s)).driver.dmaConversionHalfComplete() }
        case (2,1): return { let s=OpaquePointer($0!); ADCModel(state:s,mode:CADC_Mode(s)).driver.dmaError() }
        case (0,2): return { CADC_Callback(OpaquePointer($0!),30,2) }
        case (1,2): return { CADC_Callback(OpaquePointer($0!),31,2) }
        case (2,2): return { CADC_Callback(OpaquePointer($0!),32,2) }
        default: return nil
        }
    }
    func getNodeSourceWidth(at address: UInt32, width: inout UInt32) -> HALStatus {
        let result = HALStatus(rawValue: CADC_DMAAction(state,3,0,0,0))!
        if result == .ok { width = get(6,5) }
        return result
    }
    func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        HALStatus(rawValue: CADC_DMAAction(state,0,sourceAddress,destinationAddress,sourceDataSize))!
    }
    func startLinkedListInterrupt() -> HALStatus { HALStatus(rawValue: CADC_DMAAction(state,1,0,0,0))! }
    func abort(getTick: () -> UInt32) -> HALStatus { HALStatus(rawValue: CADC_DMAAction(state,2,0,0,0))! }
    func invokeErrorCallback(context: UnsafeMutableRawPointer?) { Self.dmaCallback(2,CADC_GetDMACallback(state,2))!(context) }
    func tick() -> UInt32 { CADC_TickFor(state) }
    var config0: ADCChannelConfiguration {
        var c = ADCChannelConfiguration()
        c.channel = get(3, 0)
        c.rank = get(3, 1)
        c.samplingTime = get(3, 2)
        c.singleDiff = get(3, 3)
        c.offsetNumber = get(3, 4)
        c.offset = get(3, 5)
        c.offsetSign = get(3, 6)
        c.offsetSaturation = get(3, 7)
        return c
    }
    var config1: ADCAnalogWatchdogConfiguration {
        var c = ADCAnalogWatchdogConfiguration()
        c.watchdogNumber = get(3, 20)
        c.watchdogMode = get(3, 21)
        c.channel = get(3, 22)
        c.interruptMode = get(3, 23)
        c.highThreshold = get(3, 24)
        c.lowThreshold = get(3, 25)
        c.filteringConfig = get(3, 26)
        return c
    }
    var config2: ADCInjectedConfiguration {
        var c = ADCInjectedConfiguration()
        c.injectedChannel = get(3, 40)
        c.injectedRank = get(3, 41)
        c.injectedSamplingTime = get(3, 42)
        c.injectedSingleDiff = get(3, 43)
        c.injectedOffsetNumber = get(3, 44)
        c.injectedOffset = get(3, 45)
        c.injectedOffsetSign = get(3, 46)
        c.injectedOffsetSaturation = get(3, 47)
        c.injectedNbrOfConversion = get(3, 48)
        c.injectedDiscontinuousConvMode = get(3, 49)
        c.autoInjectedConv = get(3, 50)
        c.queueInjectedContext = get(3, 51)
        c.externalTrigInjecConv = get(3, 52)
        c.externalTrigInjecConvEdge = get(3, 53)
        c.injecOversamplingMode = get(3, 54)
        c.injecOversampling.ratio = get(3, 55)
        c.injecOversampling.rightBitShift = get(3, 56)
        return c
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        CADC_Activate(state)
        switch op {
        case 0: return driver.initialize().rawValue
        case 1: return driver.deinitialize(getTick: tick).rawValue
        case 2: return mode == 0 ? UInt32.max : driver.registerCallback(id: a, callback: Self.callback(a < 11 ? a : 0, b)).rawValue
        case 3: return mode == 0 ? UInt32.max : driver.unregisterCallback(id: a).rawValue
        case 4: return driver.start(getTick: tick).rawValue
        case 5: return driver.stop(getTick: tick).rawValue
        case 6: return driver.pollForConversion(timeout: a, getTick: tick).rawValue
        case 7: return driver.pollForEvent(a, timeout: b, getTick: tick).rawValue
        case 8: return driver.startInterrupt(getTick: tick).rawValue
        case 9: return driver.stopInterrupt(getTick: tick).rawValue
        case 10: return driver.startDMA(destinationAddress:a,length:b,getTick:tick).rawValue
        case 11: return driver.stopDMA(getTick:tick).rawValue
        case 12: return driver.getValue()
        case 13: return driver.startSampling().rawValue
        case 14: return driver.stopSampling().rawValue
        case 15: driver.irqHandler(); return 0
        case 16: return driver.configureChannel(config0).rawValue
        case 17: return driver.configureAnalogWatchdog(config1).rawValue
        case 18: return driver.getState()
        case 19: return driver.getError()
        case 20: return driver.conversionStop(group: a, getTick: tick).rawValue
        case 21: return driver.enable(getTick: tick).rawValue
        case 22: return driver.disable(getTick: tick).rawValue
        case 26: return driver.startCalibration(singleDiff: a, getTick: tick).rawValue
        case 27: return driver.getCalibrationValue(singleDiff: a)
        case 28: return driver.setCalibrationValue(singleDiff: a, factor: b).rawValue
        case 23: driver.dmaConversionComplete(context: context); return 0
        case 24: driver.dmaConversionHalfComplete(); return 0
        case 25: driver.dmaError(); return 0
        case 29: return driver.startInjected(getTick: tick).rawValue
        case 30: return driver.stopInjected(getTick: tick).rawValue
        case 31: return driver.pollForInjectedConversion(timeout: a, getTick: tick).rawValue
        case 32: return driver.startInjectedInterrupt(getTick: tick).rawValue
        case 33: return driver.stopInjectedInterrupt(getTick: tick).rawValue
        case 34: return driver.startMultimodeDMA(destinationAddress:a,length:b,getTick:tick).rawValue
        case 35: return driver.stopMultimodeDMA(getTick:tick).rawValue
        case 36: return driver.getMultimodeValue()
        case 37: return driver.getInjectedValue(rank: a)
        case 38: return driver.stopRegular(getTick: tick).rawValue
        case 39: return driver.stopRegularInterrupt(getTick: tick).rawValue
        case 40: return driver.stopRegularDMA(getTick:tick).rawValue
        case 41: return driver.stopRegularMultimodeDMA(getTick:tick).rawValue
        case 42: return driver.configureInjectedChannel(config2).rawValue
        case 43: return driver.configureMultimode(.init(mode: a, dmaAccessMode: b, twoSamplingDelay: c)).rawValue
        case 44: return driver.enableInjectedQueue().rawValue
        case 45: return driver.disableInjectedQueue().rawValue
        case 46: return driver.disableVoltageRegulator().rawValue
        case 47: return driver.enterDeepPowerDownMode().rawValue
        default: preconditionFailure("ADC operation not implemented in fixture: \(op)")
        }
    }
}
