import STM32H7RSHAL
import CDCMIPPReference

func dcmippCallback(_ id: UInt32, _ token: UInt32) -> DCMIPPCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (0, 1): return { CDCMIPP_Callback(OpaquePointer($0!), 0, 1) }
    case (0, 2): return { CDCMIPP_Callback(OpaquePointer($0!), 0, 2) }
    case (1, 1): return { CDCMIPP_Callback(OpaquePointer($0!), 1, 1) }
    case (1, 2): return { CDCMIPP_Callback(OpaquePointer($0!), 1, 2) }
    case (2, 1): return { CDCMIPP_Callback(OpaquePointer($0!), 2, 1) }
    case (2, 2): return { CDCMIPP_Callback(OpaquePointer($0!), 2, 2) }
    default: preconditionFailure("Invalid DCMIPP callback")
    }
}
func dcmippPipeCallback(_ id: UInt32, _ token: UInt32) -> DCMIPPPipeCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (1, 1): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 1, 1, $1) }
    case (1, 2): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 1, 2, $1) }
    case (2, 1): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 2, 1, $1) }
    case (2, 2): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 2, 2, $1) }
    case (3, 1): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 3, 1, $1) }
    case (3, 2): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 3, 2, $1) }
    case (4, 1): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 4, 1, $1) }
    case (4, 2): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 4, 2, $1) }
    case (5, 1): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 5, 1, $1) }
    case (5, 2): return { CDCMIPP_PipeCallback(OpaquePointer($0!), 5, 2, $1) }
    default: preconditionFailure("Invalid DCMIPP callback")
    }
}
struct DCMIPPReferenceIO: DCMIPPRegisterIO, DCMIPPHandleIO, DCMIPPCallbackIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func read(_ register: DCMIPPRegister) -> UInt32 { CDCMIPP_Get(state, 0, register.rawValue / 4) }
    func write(_ register: DCMIPPRegister, value: UInt32) { CDCMIPP_Set(state, 0, register.rawValue / 4, value) }
    func read(_ word: DCMIPPHandleWord) -> UInt32 { CDCMIPP_Get(state, 1, UInt32(word.rawValue)) }
    func write(_ word: DCMIPPHandleWord, value: UInt32) { CDCMIPP_Set(state, 1, UInt32(word.rawValue), value) }
    func read(_ id: DCMIPPCallbackID) -> DCMIPPCallback? { dcmippCallback(id.rawValue, CDCMIPP_GetCallback(state, id.rawValue)) }
    func write(_ id: DCMIPPCallbackID, value: DCMIPPCallback?) {
        let token: UInt32 = value.map {
            unsafeBitCast($0, to: UInt.self) == unsafeBitCast(dcmippCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2
        } ?? 0
        CDCMIPP_SetCallback(state, id.rawValue, token)
    }
    func read(_ id: DCMIPPPipeCallbackID) -> DCMIPPPipeCallback? { dcmippPipeCallback(id.rawValue, CDCMIPP_GetCallback(state, id.rawValue + 2)) }
    func write(_ id: DCMIPPPipeCallbackID, value: DCMIPPPipeCallback?) {
        let token: UInt32 = value.map {
            unsafeBitCast($0, to: UInt.self) == unsafeBitCast(dcmippPipeCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2
        } ?? 0
        CDCMIPP_SetCallback(state, id.rawValue + 2, token)
    }
    var hal: DCMIPP<Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self,
              defaults: .init(mspInitialize: dcmippCallback(0, 1)!, mspDeinitialize: dcmippCallback(1, 1)!,
                              error: dcmippCallback(2, 1)!, pipeLimit: dcmippPipeCallback(1, 1)!,
                              pipeLine: dcmippPipeCallback(2, 1)!, pipeFrame: dcmippPipeCallback(3, 1)!,
                              pipeVsync: dcmippPipeCallback(4, 1)!, pipeError: dcmippPipeCallback(5, 1)!),
              useRegisteredCallbacks: mode != 0)
    }
    func parameter(_ index: UInt32) -> UInt32 { CDCMIPP_Get(state, 4, index) }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        let tick = { CDCMIPP_Tick(state) }
        switch op {
        case 0: return hal.initialize().rawValue
        case 1: return hal.deinitialize().rawValue
        case 2: return hal.configureParallel(.init(format: parameter(0), vsPolarity: parameter(1), hsPolarity: parameter(2),
            pixelClockPolarity: parameter(3), dataWidth: parameter(4), synchronization: parameter(5),
            synchronizationCodes: parameter(6), swapBits: parameter(7), swapCycles: parameter(8))).rawValue
        case 3: return hal.configurePipe(frameRate: .init(rawValue: parameter(9))!).rawValue
        case 4: return hal.configureIPPlug(.init(client: parameter(10), memoryPageSize: parameter(11), traffic: parameter(12),
            maxOutstandingTransactions: parameter(13), start: parameter(14), end: parameter(15), arbitrationRatio: parameter(16)), getTick: tick).rawValue
        case 5: return hal.start(address: a, mode: .init(rawValue: b)!).rawValue
        case 6: return hal.startDoubleBuffer(address0: a, address1: b, mode: .init(rawValue: c)!).rawValue
        case 7: return hal.stop(getTick: tick).rawValue
        case 8: return hal.suspend(getTick: tick).rawValue
        case 9: return hal.resume().rawValue
        case 10: hal.handleInterrupt()
        case 11: return hal.configureCrop(.init(verticalStart: parameter(17), horizontalStart: parameter(18),
            verticalSize: parameter(19), horizontalSize: parameter(20), area: parameter(21))).rawValue
        case 12: return hal.enableCrop().rawValue
        case 13: return hal.disableCrop().rawValue
        case 14: return hal.configureByteDecimation(start: .init(rawValue: a)!, mode: .init(rawValue: b)!).rawValue
        case 15: return hal.configureLineDecimation(start: .init(rawValue: a)!, mode: .init(rawValue: b)!).rawValue
        case 16: return hal.enableLimitEvent(a).rawValue
        case 17: return hal.disableLimitEvent().rawValue
        case 18: return hal.setFrameRate(.init(rawValue: a)!).rawValue
        case 19: return hal.setCaptureMode(.init(rawValue: a)!).rawValue
        case 20: return hal.enableCapture(pipe: a).rawValue
        case 21: return hal.setMemoryAddress(b, memory: .init(rawValue: a)!).rawValue
        case 22: return hal.setInputPixelFormat(.init(rawValue: a)!).rawValue
        case 23: return hal.setSyncUnmask(parameter(22)).rawValue
        case 24: return hal.enableLineEvent(.init(rawValue: a)!).rawValue
        case 25: return hal.disableLineEvent().rawValue
        case 26: return hal.resetFrameCounter().rawValue
        case 27, 28:
            var counter = parameter(23)
            let result = op == 27 ? hal.readFrameCounter(&counter) : hal.readDataCounter(&counter)
            CDCMIPP_Set(state, 4, 23, counter)
            return result.rawValue
        case 29: return hal.getState()
        case 30: return hal.getError()
        case 31: return hal.getPipeState()
        case 32: hal.enableInterrupts(a)
        case 33: hal.disableInterrupts(a)
        case 34: return hal.getFlag(a)
        case 35: hal.clearFlag(a)
        case 36: return hal.getInterruptSource(a) ? 1 : 0
        case 37: return hal.registerCallback(id: a, callback: dcmippCallback(a <= 2 ? a : 0, b)).rawValue
        case 38: return hal.unregisterCallback(id: a).rawValue
        case 39: return hal.registerPipeCallback(id: a, callback: dcmippPipeCallback(a >= 1 && a <= 5 ? a : 1, b)).rawValue
        case 40: return hal.unregisterPipeCallback(id: a).rawValue
        default: preconditionFailure("Invalid DCMIPP operation")
        }
        return 0
    }
}
