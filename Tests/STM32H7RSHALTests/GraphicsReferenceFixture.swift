import STM32H7RSHAL
import CGraphicsReference

func graphicsMMUCallback(_ index: UInt32, _ token: UInt32) -> GFXMMUCallback? {
    if token == 0 { return nil }
    switch (index, token) {
    case (0, 1): return { CGraphics_EmitCallback(OpaquePointer($0!), 0, 0, 1, 0) }
    case (0, 2): return { CGraphics_EmitCallback(OpaquePointer($0!), 0, 0, 2, 0) }
    case (1, 1): return { CGraphics_EmitCallback(OpaquePointer($0!), 0, 1, 1, 0) }
    case (1, 2): return { CGraphics_EmitCallback(OpaquePointer($0!), 0, 1, 2, 0) }
    case (2, 1): return { CGraphics_EmitCallback(OpaquePointer($0!), 0, 2, 1, 0) }
    case (2, 2): return { CGraphics_EmitCallback(OpaquePointer($0!), 0, 2, 2, 0) }
    default: preconditionFailure("Invalid graphics callback")
    }
}
func graphicsGPUCallback(_ index: UInt32, _ token: UInt32) -> GPU2DCallback? {
    if token == 0 { return nil }
    switch (index, token) {
    case (0, 1): return { CGraphics_EmitCallback(OpaquePointer($0!), 1, 0, 1, 0) }
    case (0, 2): return { CGraphics_EmitCallback(OpaquePointer($0!), 1, 0, 2, 0) }
    case (1, 1): return { CGraphics_EmitCallback(OpaquePointer($0!), 1, 1, 1, 0) }
    case (1, 2): return { CGraphics_EmitCallback(OpaquePointer($0!), 1, 1, 2, 0) }
    default: preconditionFailure("Invalid graphics callback")
    }
}
func graphicsCompletion(_ token: UInt32) -> GPU2DCommandListCallback? {
    if token == 0 { return nil }
    if token == 1 { return { CGraphics_EmitCallback(OpaquePointer($0!), 1, 2, 1, $1) } }
    return { CGraphics_EmitCallback(OpaquePointer($0!), 1, 2, 2, $1) }
}

struct GraphicsReferenceIO: GFXMMURegisterIO, GFXMMUHandleIO, GFXMMUCallbackIO, GFXMMUMemoryIO,
                            GPU2DRegisterIO, GPU2DHandleIO, GPU2DCallbackIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func offset(_ register: GFXMMURegister) -> UInt32 {
        switch register {
        case .cr: return 0; case .sr: return 4; case .fcr: return 8; case .dvr: return 0x10
        case .dar: return 0x14; case .b0cr: return 0x20; case .b1cr: return 0x24
        case .b2cr: return 0x28; case .b3cr: return 0x2C
        case .lut(let index): return 0x1000 + UInt32(index) * 4
        }
    }
    func read(_ register: GFXMMURegister) -> UInt32 { CGraphics_Get(state, 0, offset(register) / 4) }
    func write(_ register: GFXMMURegister, value: UInt32) { CGraphics_Set(state, 0, offset(register) / 4, value) }
    func address(of register: GFXMMURegister) -> UInt32 { CGraphics_Address(state, 0, offset(register) / 4) }
    func read(_ word: GFXMMUHandleWord) -> UInt32 { CGraphics_Get(state, 2, UInt32(word.rawValue)) }
    func write(_ word: GFXMMUHandleWord, value: UInt32) { CGraphics_Set(state, 2, UInt32(word.rawValue), value) }
    func read(_ word: GPU2DHandleWord) -> UInt32 { CGraphics_Get(state, 3, UInt32(word.rawValue)) }
    func write(_ word: GPU2DHandleWord, value: UInt32) { CGraphics_Set(state, 3, UInt32(word.rawValue), value) }
    func read(offset: UInt32) -> UInt32 { CGraphics_ReadGPU(state, offset) }
    func write(offset: UInt32, value: UInt32) { CGraphics_WriteGPU(state, offset, value) }
    func read32(at address: UInt32) -> UInt32 { CGraphics_ReadMemory(state, address) }
    func write32(at address: UInt32, value: UInt32) { CGraphics_WriteMemory(state, address, value) }
    func getPRIMASK() -> UInt32 { CGraphics_Mask(state, 0, 0) }
    func disableIRQ() { _ = CGraphics_Mask(state, 1, 0) }
    func setPRIMASK(_ value: UInt32) { _ = CGraphics_Mask(state, 2, value) }
    func read(_ id: GFXMMUCallbackID) -> GFXMMUCallback? {
        graphicsMMUCallback(id.rawValue, CGraphics_GetCallback(state, 0, id.rawValue))
    }
    func write(_ id: GFXMMUCallbackID, value: GFXMMUCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(graphicsMMUCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CGraphics_SetCallback(state, 0, id.rawValue, token)
    }
    func read(_ id: GPU2DCallbackID) -> GPU2DCallback? {
        graphicsGPUCallback(id.rawValue, CGraphics_GetCallback(state, 1, id.rawValue))
    }
    func write(_ id: GPU2DCallbackID, value: GPU2DCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(graphicsGPUCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CGraphics_SetCallback(state, 1, id.rawValue, token)
    }
    func readCommandListComplete() -> GPU2DCommandListCallback? { graphicsCompletion(CGraphics_GetCallback(state, 1, 2)) }
    func writeCommandListComplete(_ value: GPU2DCommandListCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(graphicsCompletion(1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CGraphics_SetCallback(state, 1, 2, token)
    }
    var mmu: GFXMMU<Self, Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self, memory: self,
              defaults: .init(error: graphicsMMUCallback(0, 1)!, mspInitialize: graphicsMMUCallback(1, 1)!,
                              mspDeinitialize: graphicsMMUCallback(2, 1)!), useRegisteredCallbacks: mode != 0)
    }
    var gpu: GPU2D<Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self,
              defaults: .init(mspInitialize: graphicsGPUCallback(0, 1)!, mspDeinitialize: graphicsGPUCallback(1, 1)!,
                              commandListComplete: graphicsCompletion(1)!,
                              error: { CGraphics_EmitCallback(OpaquePointer($0!), 1, 3, 1, 0) }), useRegisteredCallbacks: mode != 0)
    }
    func run(_ op: UInt32, _ a: UInt32 = 0, _ b: UInt32 = 0, _ c: UInt32 = 0, _ d: UInt32 = 0) -> UInt32 {
        switch op {
        case 0: return a != 0 ? 1 : mmu.initialize().rawValue
        case 1: return a != 0 ? 1 : mmu.deinitialize().rawValue
        case 2: return mmu.configureLUT(firstLine: a, lineCount: b, sourceAddress: CGraphics_Address(state, c != 0 ? 0 : 4, d)).rawValue
        case 3: return mmu.disableLUTLines(firstLine: a, lineCount: b).rawValue
        case 4: return mmu.configureLUTLine(.init(lineNumber: a, lineStatus: b, firstVisibleBlock: c & 255,
                                               lastVisibleBlock: (c >> 8) & 255, lineOffset: Int32(bitPattern: d))).rawValue
        case 5: return mmu.modifyBuffers(.init(buffer0: a, buffer1: b, buffer2: c, buffer3: d)).rawValue
        case 6: return mmu.configurePacking(.init(buffer0Enabled: a & 1, buffer0Mode: b & 1,
            buffer1Enabled: (a >> 1) & 1, buffer1Mode: (b >> 1) & 1, buffer2Enabled: (a >> 2) & 1,
            buffer2Mode: (b >> 2) & 1, buffer3Enabled: (a >> 3) & 1, buffer3Mode: (b >> 3) & 1, defaultAlpha: c)).rawValue
        case 7: mmu.handleInterrupt()
        case 8: return mmu.getState()
        case 9: return mmu.getError()
        case 10: mmu.resetHandleState()
        case 11: return mmu.registerCallback(id: a, callback: graphicsMMUCallback(min(a, 2), b)).rawValue
        case 12: return mmu.unregisterCallback(id: a).rawValue
        case 20: return a != 0 ? 1 : gpu.initialize().rawValue
        case 21: return a != 0 ? 1 : gpu.deinitialize().rawValue
        case 22: return gpu.readRegister(offset: a)
        case 23: return gpu.writeRegister(offset: a, value: b).rawValue
        case 24: gpu.handleInterrupt()
        case 25: gpu.handleErrorInterrupt()
        case 26: return gpu.getState()
        case 27: return gpu.getError()
        case 28: gpu.resetHandleState()
        case 29: return gpu.getFlag(a)
        case 30: gpu.clearFlag(a)
        case 31: return gpu.getInterruptSource(a)
        case 32: return a != 0 ? 1 : gpu.registerCallback(id: b, callback: graphicsGPUCallback(min(b, 1), c)).rawValue
        case 33: return a != 0 ? 1 : gpu.unregisterCallback(id: b).rawValue
        case 34: return a != 0 ? 1 : gpu.registerCommandListCompleteCallback(graphicsCompletion(b)).rawValue
        case 35: return a != 0 ? 1 : gpu.unregisterCommandListCompleteCallback().rawValue
        default: preconditionFailure("Invalid graphics operation")
        }
        return 0
    }
}
