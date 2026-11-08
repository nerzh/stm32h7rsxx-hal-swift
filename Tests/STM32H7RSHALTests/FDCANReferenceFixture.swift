import CFDCANReference
import STM32H7RSHAL

struct FDCANModel: FDCANRegisterIO, FDCANHandleIO, FDCANCallbackIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CFDCAN_Get(state, area, index) }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CFDCAN_Set(state, area, index, value) }
    func read(_ register: FDCANRegister) -> UInt32 { get(0, get(5, 2) * 59 + register.rawValue / 4) }
    func write(_ register: FDCANRegister, value: UInt32) { set(0, get(5, 2) * 59 + register.rawValue / 4, value) }
    func readClockDivider() -> UInt32 { get(1, 0) }
    func writeClockDivider(_ value: UInt32) { set(1, 0, value) }
    func messageRAMBase() -> UInt32 { 0x4000AC00 }
    func readMemory32(at address: UInt32) -> UInt32 { get(6, (address - messageRAMBase()) / 4) }
    func writeMemory32(at address: UInt32, value: UInt32) { set(6, (address - messageRAMBase()) / 4, value) }
    func readMemory8(at address: UInt32) -> UInt8 { UInt8(truncatingIfNeeded: readMemory32(at: address & ~3) >> ((address & 3) * 8)) }
    func read(_ word: FDCANHandleWord) -> UInt32 { get(2, UInt32(word.rawValue)) }
    func write(_ word: FDCANHandleWord, value: UInt32) { set(2, UInt32(word.rawValue), value) }
    func read(_ id: FDCANCallbackID) -> FDCANCallback? { Self.callback(id.rawValue, CFDCAN_GetCallback(state, id.rawValue)) }
    func write(_ id: FDCANCallbackID, value: FDCANCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(Self.callback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CFDCAN_SetCallback(state, id.rawValue, token)
    }
    static func callback(_ id: UInt32, _ token: UInt32) -> FDCANCallback? {
        if token == 0 { return nil }
        switch (id, token) {
        case (0, 1): return { CFDCAN_Callback(OpaquePointer($0!), 0, 1, $1) }
        case (0, 2): return { CFDCAN_Callback(OpaquePointer($0!), 0, 2, $1) }
        case (1, 1): return { CFDCAN_Callback(OpaquePointer($0!), 1, 1, $1) }
        case (1, 2): return { CFDCAN_Callback(OpaquePointer($0!), 1, 2, $1) }
        case (2, 1): return { CFDCAN_Callback(OpaquePointer($0!), 2, 1, $1) }
        case (2, 2): return { CFDCAN_Callback(OpaquePointer($0!), 2, 2, $1) }
        case (3, 1): return { CFDCAN_Callback(OpaquePointer($0!), 3, 1, $1) }
        case (3, 2): return { CFDCAN_Callback(OpaquePointer($0!), 3, 2, $1) }
        case (4, 1): return { CFDCAN_Callback(OpaquePointer($0!), 4, 1, $1) }
        case (4, 2): return { CFDCAN_Callback(OpaquePointer($0!), 4, 2, $1) }
        case (5, 1): return { CFDCAN_Callback(OpaquePointer($0!), 5, 1, $1) }
        case (5, 2): return { CFDCAN_Callback(OpaquePointer($0!), 5, 2, $1) }
        case (6, 1): return { CFDCAN_Callback(OpaquePointer($0!), 6, 1, $1) }
        case (6, 2): return { CFDCAN_Callback(OpaquePointer($0!), 6, 2, $1) }
        case (7, 1): return { CFDCAN_Callback(OpaquePointer($0!), 7, 1, $1) }
        case (7, 2): return { CFDCAN_Callback(OpaquePointer($0!), 7, 2, $1) }
        case (8, 1): return { CFDCAN_Callback(OpaquePointer($0!), 8, 1, $1) }
        case (8, 2): return { CFDCAN_Callback(OpaquePointer($0!), 8, 2, $1) }
        case (9, 1): return { CFDCAN_Callback(OpaquePointer($0!), 9, 1, $1) }
        case (9, 2): return { CFDCAN_Callback(OpaquePointer($0!), 9, 2, $1) }
        case (10, 1): return { CFDCAN_Callback(OpaquePointer($0!), 10, 1, $1) }
        case (10, 2): return { CFDCAN_Callback(OpaquePointer($0!), 10, 2, $1) }
        case (11, 1): return { CFDCAN_Callback(OpaquePointer($0!), 11, 1, $1) }
        case (11, 2): return { CFDCAN_Callback(OpaquePointer($0!), 11, 2, $1) }
        case (12, 1): return { CFDCAN_Callback(OpaquePointer($0!), 12, 1, $1) }
        case (12, 2): return { CFDCAN_Callback(OpaquePointer($0!), 12, 2, $1) }
        default: return nil
        }
    }
    var defaults: FDCANDefaultCallbacks { .init(txFifoEmpty: Self.callback(0, 1), highPriorityMessage: Self.callback(1, 1), timestampWraparound: Self.callback(2, 1), timeoutOccurred: Self.callback(3, 1), error: Self.callback(4, 1), mspInit: Self.callback(5, 1), mspDeinit: Self.callback(6, 1), txEventFifo: Self.callback(7, 1), rxFifo0: Self.callback(8, 1), rxFifo1: Self.callback(9, 1), txBufferComplete: Self.callback(10, 1), txBufferAbort: Self.callback(11, 1), errorStatus: Self.callback(12, 1)) }
    var driver: FDCAN<Self, Self, Self> {
        .init(instance: FDCANInstance(rawValue: get(5, 2))!, registers: self, handle: self, callbacks: self,
              defaults: defaults, useRegisteredCallbacks: mode != 0)
    }
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, _ d: UInt32 = 0) -> UInt32 {
        let driver = self.driver
        let tick = { CFDCAN_ModelTick(state) }
        let p0 = FDCANFilter(idType: get(3, 0), filterIndex: get(3, 1), filterType: get(3, 2), filterConfig: get(3, 3), filterID1: get(3, 4), filterID2: get(3, 5))
        let p1 = FDCANTxHeader(identifier: get(3, 20), idType: get(3, 21), txFrameType: get(3, 22), dataLength: get(3, 23), errorStateIndicator: get(3, 24), bitRateSwitch: get(3, 25), fdFormat: get(3, 26), txEventFifoControl: get(3, 27), messageMarker: get(3, 28))
        var p2 = FDCANRxHeader(identifier: get(3, 40), idType: get(3, 41), rxFrameType: get(3, 42), dataLength: get(3, 43), errorStateIndicator: get(3, 44), bitRateSwitch: get(3, 45), fdFormat: get(3, 46), rxTimestamp: get(3, 47), filterIndex: get(3, 48), isFilterMatchingFrame: get(3, 49))
        var p3 = FDCANTxEvent(identifier: get(3, 60), idType: get(3, 61), txFrameType: get(3, 62), dataLength: get(3, 63), errorStateIndicator: get(3, 64), bitRateSwitch: get(3, 65), fdFormat: get(3, 66), txTimestamp: get(3, 67), messageMarker: get(3, 68), eventType: get(3, 69))
        var p4 = FDCANHighPriorityMessageStatus(filterList: get(3, 80), filterIndex: get(3, 81), messageStorage: get(3, 82), messageIndex: get(3, 83))
        var p5 = FDCANProtocolStatus(lastErrorCode: get(3, 100), dataLastErrorCode: get(3, 101), activity: get(3, 102), errorPassive: get(3, 103), warning: get(3, 104), busOff: get(3, 105), rxESIFlag: get(3, 106), rxBRSFlag: get(3, 107), rxFDFFlag: get(3, 108), protocolException: get(3, 109), tdcValue: get(3, 110))
        var p6 = FDCANErrorCounters(txErrorCnt: get(3, 120), rxErrorCnt: get(3, 121), rxErrorPassive: get(3, 122), errorLogging: get(3, 123))
        let result: UInt32
        switch op {
        case 0: result = driver.initialize(getTick: tick).rawValue
        case 1: result = driver.deinitialize().rawValue
        case 2: result = driver.enterPowerDownMode(getTick: tick).rawValue
        case 3: result = driver.exitPowerDownMode(getTick: tick).rawValue
        case 4: if mode == 0 { result = .max } else { result = driver.registerCallback(FDCANCallbackID(rawValue: a)!, callback: Self.callback(a, b)).rawValue }
        case 5: if mode == 0 { result = .max } else { result = driver.unregisterCallback(FDCANCallbackID(rawValue: a)!).rawValue }
        case 6: if mode == 0 { result = .max } else { result = driver.registerTxEventFifoCallback(Self.callback(7, a)).rawValue }
        case 7: if mode == 0 { result = .max } else { result = driver.unregisterTxEventFifoCallback().rawValue }
        case 8: if mode == 0 { result = .max } else { result = driver.registerRxFifo0Callback(Self.callback(8, a)).rawValue }
        case 9: if mode == 0 { result = .max } else { result = driver.unregisterRxFifo0Callback().rawValue }
        case 10: if mode == 0 { result = .max } else { result = driver.registerRxFifo1Callback(Self.callback(9, a)).rawValue }
        case 11: if mode == 0 { result = .max } else { result = driver.unregisterRxFifo1Callback().rawValue }
        case 12: if mode == 0 { result = .max } else { result = driver.registerTxBufferCompleteCallback(Self.callback(10, a)).rawValue }
        case 13: if mode == 0 { result = .max } else { result = driver.unregisterTxBufferCompleteCallback().rawValue }
        case 14: if mode == 0 { result = .max } else { result = driver.registerTxBufferAbortCallback(Self.callback(11, a)).rawValue }
        case 15: if mode == 0 { result = .max } else { result = driver.unregisterTxBufferAbortCallback().rawValue }
        case 16: if mode == 0 { result = .max } else { result = driver.registerErrorStatusCallback(Self.callback(12, a)).rawValue }
        case 17: if mode == 0 { result = .max } else { result = driver.unregisterErrorStatusCallback().rawValue }
        case 18: result = driver.configureFilter(p0).rawValue
        case 19: result = driver.configureGlobalFilter(nonMatchingStandard: a, nonMatchingExtended: b, rejectRemoteStandard: c, rejectRemoteExtended: d).rawValue
        case 20: result = driver.configureExtendedIDMask(a).rawValue
        case 21: result = driver.configureRxFIFOOverwrite(fifo: a, operationMode: b).rawValue
        case 22: result = driver.configureRAMWatchdog(counterStartValue: a).rawValue
        case 23: result = driver.configureTimestampCounter(prescaler: a).rawValue
        case 24: result = driver.enableTimestampCounter(operation: a).rawValue
        case 25: result = driver.disableTimestampCounter().rawValue
        case 26: result = UInt32(driver.getTimestampCounter())
        case 27: result = driver.resetTimestampCounter().rawValue
        case 28: result = driver.configureTimeoutCounter(operation: a, period: b).rawValue
        case 29: result = driver.enableTimeoutCounter().rawValue
        case 30: result = driver.disableTimeoutCounter().rawValue
        case 31: result = UInt32(driver.getTimeoutCounter())
        case 32: result = driver.resetTimeoutCounter().rawValue
        case 33: result = driver.configureTxDelayCompensation(offset: a, filter: b).rawValue
        case 34: result = driver.enableTxDelayCompensation().rawValue
        case 35: result = driver.disableTxDelayCompensation().rawValue
        case 36: result = driver.enableISOMode().rawValue
        case 37: result = driver.disableISOMode().rawValue
        case 38: result = driver.enableEdgeFiltering().rawValue
        case 39: result = driver.disableEdgeFiltering().rawValue
        case 40: result = driver.start().rawValue
        case 41: result = driver.stop().rawValue
        case 42: result = driver.addMessageToTxFifoQ(header: p1, data: CFDCAN_Data(state, 0)!).rawValue
        case 43: result = driver.getLatestTxFifoQRequestBuffer()
        case 44: result = driver.abortTxRequest(bufferIndex: a).rawValue
        case 45: result = driver.getRxMessage(location: a, header: &p2, data: CFDCAN_Data(state, 1)!).rawValue
        case 46: result = driver.getTxEvent(&p3).rawValue
        case 47: result = driver.getHighPriorityMessageStatus(&p4).rawValue
        case 48: result = driver.getProtocolStatus(&p5).rawValue
        case 49: result = driver.getErrorCounters(&p6).rawValue
        case 50: result = driver.isTxBufferMessagePending(bufferIndex: a)
        case 51: result = driver.getRxFifoFillLevel(fifo: a)
        case 52: result = driver.getTxFifoFreeLevel()
        case 53: result = driver.isRestrictedOperationMode()
        case 54: result = driver.exitRestrictedOperationMode().rawValue
        case 55: result = driver.configureInterruptLines(groups: a, line: b).rawValue
        case 56: result = driver.activateNotification(interrupts: a, bufferIndexes: b).rawValue
        case 57: result = driver.deactivateNotification(interrupts: a).rawValue
        case 58: driver.irqHandler(); result = 0
        case 59: result = driver.getState()
        case 60: result = driver.getError()
        default: preconditionFailure("Unsupported reference operation")
        }
        set(3, 40, p2.identifier)
        set(3, 41, p2.idType)
        set(3, 42, p2.rxFrameType)
        set(3, 43, p2.dataLength)
        set(3, 44, p2.errorStateIndicator)
        set(3, 45, p2.bitRateSwitch)
        set(3, 46, p2.fdFormat)
        set(3, 47, p2.rxTimestamp)
        set(3, 48, p2.filterIndex)
        set(3, 49, p2.isFilterMatchingFrame)
        set(3, 60, p3.identifier)
        set(3, 61, p3.idType)
        set(3, 62, p3.txFrameType)
        set(3, 63, p3.dataLength)
        set(3, 64, p3.errorStateIndicator)
        set(3, 65, p3.bitRateSwitch)
        set(3, 66, p3.fdFormat)
        set(3, 67, p3.txTimestamp)
        set(3, 68, p3.messageMarker)
        set(3, 69, p3.eventType)
        set(3, 80, p4.filterList)
        set(3, 81, p4.filterIndex)
        set(3, 82, p4.messageStorage)
        set(3, 83, p4.messageIndex)
        set(3, 100, p5.lastErrorCode)
        set(3, 101, p5.dataLastErrorCode)
        set(3, 102, p5.activity)
        set(3, 103, p5.errorPassive)
        set(3, 104, p5.warning)
        set(3, 105, p5.busOff)
        set(3, 106, p5.rxESIFlag)
        set(3, 107, p5.rxBRSFlag)
        set(3, 108, p5.rxFDFFlag)
        set(3, 109, p5.protocolException)
        set(3, 110, p5.tdcValue)
        set(3, 120, p6.txErrorCnt)
        set(3, 121, p6.rxErrorCnt)
        set(3, 122, p6.rxErrorPassive)
        set(3, 123, p6.errorLogging)
        return result
    }
}
