import STM32H7RSHAL
import CDMA2DReference

func dma2dCallback(_ id: UInt32, _ token: UInt32) -> DMA2DCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (0, 1): return { CDMA2D_Callback(OpaquePointer($0!), 0, 1) }
    case (0, 2): return { CDMA2D_Callback(OpaquePointer($0!), 0, 2) }
    case (1, 1): return { CDMA2D_Callback(OpaquePointer($0!), 1, 1) }
    case (1, 2): return { CDMA2D_Callback(OpaquePointer($0!), 1, 2) }
    case (2, 1): return { CDMA2D_Callback(OpaquePointer($0!), 2, 1) }
    case (2, 2): return { CDMA2D_Callback(OpaquePointer($0!), 2, 2) }
    case (3, 1): return { CDMA2D_Callback(OpaquePointer($0!), 3, 1) }
    case (3, 2): return { CDMA2D_Callback(OpaquePointer($0!), 3, 2) }
    case (4, 1): return { CDMA2D_Callback(OpaquePointer($0!), 4, 1) }
    case (4, 2): return { CDMA2D_Callback(OpaquePointer($0!), 4, 2) }
    case (5, 1): return { CDMA2D_Callback(OpaquePointer($0!), 5, 1) }
    case (5, 2): return { CDMA2D_Callback(OpaquePointer($0!), 5, 2) }
    default: preconditionFailure("Invalid DMA2D callback")
    }
}
struct DMA2DReferenceIO: DMA2DRegisterIO, DMA2DHandleIO, DMA2DCallbackIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func read(_ register: DMA2DRegister) -> UInt32 { CDMA2D_Get(state, 0, register.rawValue / 4) }
    func write(_ register: DMA2DRegister, value: UInt32) { CDMA2D_Write(state, register.rawValue, value) }
    func isClockEnabled() -> Bool { CDMA2D_Get(state, 2, 0) != 0 }
    func read(_ word: DMA2DHandleWord) -> UInt32 { CDMA2D_Get(state, 1, UInt32(word.rawValue)) }
    func write(_ word: DMA2DHandleWord, value: UInt32) { CDMA2D_Set(state, 1, UInt32(word.rawValue), value) }
    func read(_ id: DMA2DCallbackID) -> DMA2DCallback? { dma2dCallback(id.rawValue, CDMA2D_GetCallback(state, id.rawValue)) }
    func write(_ id: DMA2DCallbackID, value: DMA2DCallback?) {
        let token: UInt32 = value.map {
            unsafeBitCast($0, to: UInt.self) == unsafeBitCast(dma2dCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2
        } ?? 0
        CDMA2D_SetCallback(state, id.rawValue, token)
    }
    var dma: DMA2D<Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self,
              defaults: .init(mspInitialize: dma2dCallback(0, 1)!, mspDeinitialize: dma2dCallback(1, 1)!,
                              lineEvent: dma2dCallback(4, 1)!, clutComplete: dma2dCallback(5, 1)!),
              useRegisteredCallbacks: mode != 0)
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32, _ d: UInt32, _ e: UInt32) -> UInt32 {
        let getTick = { CDMA2D_Tick(state) }
        switch op {
        case 0: return a != 0 ? 1 : dma.initialize().rawValue
        case 1: return a != 0 ? 1 : dma.deinitialize(getTick: getTick).rawValue
        case 2, 3: return dma.start(data: a, destination: b, width: c, height: d, interrupts: op == 3).rawValue
        case 4, 5: return dma.startBlending(foreground: a, background: b, destination: c, width: d, height: e, interrupts: op == 5).rawValue
        case 6: return dma.abort(getTick: getTick).rawValue
        case 7: return dma.suspend(getTick: getTick).rawValue
        case 8: return dma.resume().rawValue
        case 9: return dma.enableCLUT(layer: a).rawValue
        case 10...13: return dma.loadCLUT(.init(address: b, colorMode: c, size: d), layer: a, interrupts: op & 1 != 0).rawValue
        case 14: return dma.abortCLUT(layer: a, getTick: getTick).rawValue
        case 15: return dma.suspendCLUT(layer: a, getTick: getTick).rawValue
        case 16: return dma.resumeCLUT(layer: a).rawValue
        case 17: return dma.pollForTransfer(timeout: a, getTick: getTick).rawValue
        case 18: dma.handleInterrupt()
        case 19: return dma.configureLayer(a).rawValue
        case 20: return dma.configureCLUT(.init(address: b, colorMode: c, size: d), layer: a).rawValue
        case 21: return dma.programLineEvent(a).rawValue
        case 22: return dma.enableDeadTime().rawValue
        case 23: return dma.disableDeadTime().rawValue
        case 24: return dma.configureDeadTime(UInt8(truncatingIfNeeded: a)).rawValue
        case 25: return dma.getState()
        case 26: return dma.getError()
        case 27: dma.resetHandleState()
        case 28: dma.enable()
        case 29: return dma.getFlag(a)
        case 30: dma.clearFlag(a)
        case 31: dma.enableInterrupts(a)
        case 32: dma.disableInterrupts(a)
        case 33: return dma.getInterruptSource(a)
        case 34: return dma.registerCallback(id: a, callback: dma2dCallback(a <= 5 ? a : 0, b)).rawValue
        case 35: return dma.unregisterCallback(id: a).rawValue
        default: preconditionFailure("Invalid DMA2D operation")
        }
        return 0
    }
}
