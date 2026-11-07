import STM32H7RSHAL
import CLTDCReference

func ltdcCallback(_ id: UInt32, _ token: UInt32) -> LTDCCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (0, 1): return { CLTDC_Callback(OpaquePointer($0!), 0, 1) }
    case (0, 2): return { CLTDC_Callback(OpaquePointer($0!), 0, 2) }
    case (1, 1): return { CLTDC_Callback(OpaquePointer($0!), 1, 1) }
    case (1, 2): return { CLTDC_Callback(OpaquePointer($0!), 1, 2) }
    case (2, 1): return { CLTDC_Callback(OpaquePointer($0!), 2, 1) }
    case (2, 2): return { CLTDC_Callback(OpaquePointer($0!), 2, 2) }
    case (3, 1): return { CLTDC_Callback(OpaquePointer($0!), 3, 1) }
    case (3, 2): return { CLTDC_Callback(OpaquePointer($0!), 3, 2) }
    case (4, 1): return { CLTDC_Callback(OpaquePointer($0!), 4, 1) }
    case (4, 2): return { CLTDC_Callback(OpaquePointer($0!), 4, 2) }
    default: preconditionFailure("Invalid LTDC callback")
    }
}
struct LTDCReferenceIO: LTDCRegisterIO, LTDCHandleIO, LTDCCallbackIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func read(_ register: LTDCRegister) -> UInt32 { CLTDC_Get(state, 0, register.rawValue / 4) }
    func write(_ register: LTDCRegister, value: UInt32) { CLTDC_Set(state, 0, register.rawValue / 4, value) }
    func read(_ register: LTDCLayerRegister, layer: UInt32) -> UInt32 {
        CLTDC_Get(state, 0, (0x84 + layer * 0x80 + register.rawValue) / 4)
    }
    func write(_ register: LTDCLayerRegister, layer: UInt32, value: UInt32) {
        CLTDC_Set(state, 0, (0x84 + layer * 0x80 + register.rawValue) / 4, value)
    }
    func read(_ word: LTDCHandleWord) -> UInt32 { CLTDC_Get(state, 1, UInt32(word.rawValue)) }
    func write(_ word: LTDCHandleWord, value: UInt32) { CLTDC_Set(state, 1, UInt32(word.rawValue), value) }
    func read(_ id: LTDCCallbackID) -> LTDCCallback? { ltdcCallback(id.rawValue, CLTDC_GetCallback(state, id.rawValue)) }
    func write(_ id: LTDCCallbackID, value: LTDCCallback?) {
        let token: UInt32 = value.map {
            unsafeBitCast($0, to: UInt.self) == unsafeBitCast(ltdcCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2
        } ?? 0
        CLTDC_SetCallback(state, id.rawValue, token)
    }
    var ltdc: LTDC<Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self,
              defaults: .init(mspInitialize: ltdcCallback(0, 1)!, mspDeinitialize: ltdcCallback(1, 1)!,
                              lineEvent: ltdcCallback(2, 1)!, error: ltdcCallback(4, 1)!, reloadEvent: ltdcCallback(3, 1)!),
              useRegisteredCallbacks: mode != 0)
    }
    func configuration() -> LTDCLayerConfiguration {
        .init(windowX0: CLTDC_Get(state, 5, 0),
              windowX1: CLTDC_Get(state, 5, 1),
              windowY0: CLTDC_Get(state, 5, 2),
              windowY1: CLTDC_Get(state, 5, 3),
              pixelFormat: CLTDC_Get(state, 5, 4),
              alpha: CLTDC_Get(state, 5, 5),
              alpha0: CLTDC_Get(state, 5, 6),
              blendingFactor1: CLTDC_Get(state, 5, 7),
              blendingFactor2: CLTDC_Get(state, 5, 8),
              frameBufferAddress: CLTDC_Get(state, 5, 9),
              imageWidth: CLTDC_Get(state, 5, 10),
              imageHeight: CLTDC_Get(state, 5, 11),
              backgroundColor: CLTDC_Get(state, 5, 12))
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        switch op {
        case 0: return a != 0 ? 1 : ltdc.initialize().rawValue
        case 1: return a != 0 ? 1 : ltdc.deinitialize { CLTDC_Tick(state) }.rawValue
        case 2: ltdc.handleInterrupt()
        case 3, 4: return ltdc.configureLayer(configuration(), layer: a, reload: op == 3).rawValue
        case 5: return ltdc.configureCLUT(.init(start: b == 0 ? nil : CLTDC_Colors(state), count: Int(b)), layer: a).rawValue
        case 6, 7: return ltdc.setWindowSize(width: b, height: c, layer: a, reload: op == 6).rawValue
        case 8, 9: return ltdc.setWindowPosition(x: b, y: c, layer: a, reload: op == 8).rawValue
        case 10, 11: return ltdc.setPixelFormat(.init(rawValue: b)!, layer: a, reload: op == 10).rawValue
        case 12, 13: return ltdc.setAlpha(b, layer: a, reload: op == 12).rawValue
        case 14, 15: return ltdc.setAddress(b, layer: a, reload: op == 14).rawValue
        case 16, 17: return ltdc.setPitch(pixels: b, layer: a, reload: op == 16).rawValue
        case 18, 19: return ltdc.configureColorKeying(rgb: b, layer: a, reload: op == 18).rawValue
        case 20, 21: return ltdc.enableColorKeying(layer: a, reload: op == 20).rawValue
        case 22, 23: return ltdc.disableColorKeying(layer: a, reload: op == 22).rawValue
        case 24, 25: return ltdc.enableCLUT(layer: a, reload: op == 24).rawValue
        case 26, 27: return ltdc.disableCLUT(layer: a, reload: op == 26).rawValue
        case 28: return ltdc.enableDither().rawValue
        case 29: return ltdc.disableDither().rawValue
        case 30: return ltdc.programLineEvent(a).rawValue
        case 31: return ltdc.reload(.init(rawValue: a)!).rawValue
        case 32: return ltdc.getState()
        case 33: return ltdc.getError()
        case 34: ltdc.resetHandleState()
        case 35: ltdc.enable()
        case 36: ltdc.disable()
        case 37: ltdc.enableLayer(a)
        case 38: ltdc.disableLayer(a)
        case 39: ltdc.reloadImmediately()
        case 40: ltdc.reloadAtVerticalBlanking()
        case 41: return ltdc.getFlag(a)
        case 42: ltdc.clearFlag(a)
        case 43: ltdc.enableInterrupts(a)
        case 44: ltdc.disableInterrupts(a)
        case 45: return ltdc.getInterruptSource(a)
        case 46: return ltdc.registerCallback(id: a, callback: ltdcCallback(a <= 4 ? a : 0, b)).rawValue
        case 47: return ltdc.unregisterCallback(id: a).rawValue
        default: preconditionFailure("Invalid LTDC operation")
        }
        return 0
    }
}
