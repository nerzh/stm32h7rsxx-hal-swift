import STM32H7RSHAL
import CSPDIFRXReference

struct SPDIFRXModel: SPDIFRXRegisterIO, SPDIFRXHandleIO, SPDIFRXCallbackIO, SPDIFRXDMAIO {
    let state: OpaquePointer
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CSPDIFRX_Get(state, area, index) }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CSPDIFRX_Set(state, area, index, value) }
    func read(_ register: SPDIFRXRegister) -> UInt32 { get(0, register.rawValue / 4) }
    func write(_ register: SPDIFRXRegister, value: UInt32) { set(0, register.rawValue / 4, value) }
    func dataAddress(_ stream: SPDIFRXStream) -> UInt32 { stream == .data ? 0x40004010 : 0x40004014 }
    func readPeripheralControl() -> UInt32 { get(3, 8) == 0 ? read(.cr) : get(11, 0) }
    func read(_ word: SPDIFRXHandleWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
    func write(_ word: SPDIFRXHandleWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
    func readBuffer(_ stream: SPDIFRXStream) -> UnsafeMutablePointer<UInt32>? { CSPDIFRX_GetBuffer(state, stream.rawValue) }
    func writeBuffer(_ stream: SPDIFRXStream, value: UnsafeMutablePointer<UInt32>?) { CSPDIFRX_SetBuffer(state, stream.rawValue, value) }
    func read(_ id: SPDIFRXCallbackID) -> SPDIFRXCallback? { callback(id, CSPDIFRX_GetCallback(state, id.rawValue)) }
    func write(_ id: SPDIFRXCallbackID, value: SPDIFRXCallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(callback(id, 1)!, to: UInt.self) ? 1 : 2
        CSPDIFRX_SetCallback(state, id.rawValue, token)
    }
    func callback(_ id: SPDIFRXCallbackID, _ token: UInt32) -> SPDIFRXCallback? {
        if token == 0 { return nil }
        switch id {
        case .receiveHalf: return token == 1 ? { CSPDIFRX_Callback(OpaquePointer($0!), 0, 1) } : { CSPDIFRX_Callback(OpaquePointer($0!), 0, 2) }
        case .receiveComplete: return token == 1 ? { CSPDIFRX_Callback(OpaquePointer($0!), 1, 1) } : { CSPDIFRX_Callback(OpaquePointer($0!), 1, 2) }
        case .controlHalf: return token == 1 ? { CSPDIFRX_Callback(OpaquePointer($0!), 2, 1) } : { CSPDIFRX_Callback(OpaquePointer($0!), 2, 2) }
        case .controlComplete: return token == 1 ? { CSPDIFRX_Callback(OpaquePointer($0!), 3, 1) } : { CSPDIFRX_Callback(OpaquePointer($0!), 3, 2) }
        case .error: return token == 1 ? { CSPDIFRX_Callback(OpaquePointer($0!), 4, 1) } : { CSPDIFRX_Callback(OpaquePointer($0!), 4, 2) }
        case .mspInitialize: return token == 1 ? { CSPDIFRX_Callback(OpaquePointer($0!), 5, 1) } : { CSPDIFRX_Callback(OpaquePointer($0!), 5, 2) }
        case .mspDeinitialize: return token == 1 ? { CSPDIFRX_Callback(OpaquePointer($0!), 6, 1) } : { CSPDIFRX_Callback(OpaquePointer($0!), 6, 2) }
        }
    }
    var driver: SPDIFRX<SPDIFRXModel, SPDIFRXModel, SPDIFRXModel, SPDIFRXModel> {
        .init(registers: self, handle: self, callbacks: self, dma: self,
              defaults: .init(receiveHalf: callback(.receiveHalf, 1)!, receiveComplete: callback(.receiveComplete, 1)!,
                              controlHalf: callback(.controlHalf, 1)!, controlComplete: callback(.controlComplete, 1)!,
                              error: callback(.error, 1)!, mspInitialize: callback(.mspInitialize, 1)!, mspDeinitialize: callback(.mspDeinitialize, 1)!),
              useRegisteredCallbacks: get(9, 0) != 0)
    }
    func isPresent(_ stream: SPDIFRXStream) -> Bool { get(2, stream.rawValue * 13) != 0 }
    func read(_ stream: SPDIFRXStream, word: DMAHandleWord) -> UInt32 {
        if word == .mode { return get(2, stream.rawValue * 13 + 1) }
        precondition(word == .queueAddress)
        return get(2, stream.rawValue * 13 + 2) == 0 ? 0 : 0x1000 + stream.rawValue * 0x100
    }
    func readMemory32(_ stream: SPDIFRXStream, at address: UInt32) -> UInt32 {
        precondition(address == 0x1000 + stream.rawValue * 0x100)
        return get(2, stream.rawValue * 13 + 3) == 0 ? 0 : 0x2000 + stream.rawValue * 0x100
    }
    func writeMemory32(_ stream: SPDIFRXStream, at address: UInt32, value: UInt32) {
        let offset = address - (0x2000 + stream.rawValue * 0x100)
        precondition(offset == 8 || offset == 12 || offset == 16)
        set(2, stream.rawValue * 13 + 2 + offset / 4, value)
    }
    func writeCallback(_ stream: SPDIFRXStream, id: DMACallbackID, value: DMACallback?) {
        var token: UInt32 = 0
        if let value {
            for kind in SPDIFRXDMACallbackKind.allCases where unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) { token = kind.rawValue + 1 }
            precondition(token != 0)
        }
        let i: UInt32
        switch id { case .halfTransfer: i = 7; case .transferComplete: i = 8; case .error: i = 9; case .abort: i = 10; default: preconditionFailure() }
        set(2, stream.rawValue * 13 + i, token)
    }
    func callback(_ kind: SPDIFRXDMACallbackKind) -> DMACallback {
        switch kind {
        case .receiveComplete: return { let m = SPDIFRXModel(state: OpaquePointer($0!)); m.driver.handleDMAEvent(.receiveComplete, dmaMode: m.get(2, 1)) }
        case .receiveHalf: return { SPDIFRXModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.receiveHalf, dmaMode: 0) }
        case .controlComplete: return { SPDIFRXModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.controlComplete, dmaMode: 0) }
        case .controlHalf: return { SPDIFRXModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.controlHalf, dmaMode: 0) }
        case .error: return { SPDIFRXModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.error, dmaMode: 0) }
        }
    }
    func startInterrupt(_ stream: SPDIFRXStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        HALStatus(rawValue: CSPDIFRX_Start(state, stream.rawValue, 0, sourceAddress, destinationAddress, sourceDataSize))!
    }
    func startLinkedListInterrupt(_ stream: SPDIFRXStream) -> HALStatus {
        HALStatus(rawValue: CSPDIFRX_Start(state, stream.rawValue, 1, get(2, stream.rawValue * 13 + 5), get(2, stream.rawValue * 13 + 6), get(2, stream.rawValue * 13 + 4)))!
    }
    func disable(_ stream: SPDIFRXStream) { CSPDIFRX_Disable(state, stream.rawValue) }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        let d = driver
        switch op {
        case 0: return d.initialize().rawValue
        case 1: return d.deinitialize().rawValue
        case 2: return d.setDataFormat(.init(dataFormat: get(10, 0), stereoMode: get(10, 1), preambleTypeMask: get(10, 2), channelStatusMask: get(10, 3), validityBitMask: get(10, 4), parityErrorMask: get(10, 5))).rawValue
        case 3,4: return d.receive(op == 3 ? .data : .control, data: a == 0 ? nil : CSPDIFRX_Buffer(state, a - 1), count: UInt16(truncatingIfNeeded: b), timeout: c, getTick: { CSPDIFRX_Tick(state) }).rawValue
        case 5,6: return d.receiveInterrupt(op == 5 ? .data : .control, data: a == 0 ? nil : CSPDIFRX_Buffer(state, a - 1), count: UInt16(truncatingIfNeeded: b), systemCoreClock: get(3, 0)).rawValue
        case 7,8: return d.receiveDMA(op == 7 ? .data : .control, data: a == 0 ? nil : CSPDIFRX_Buffer(state, a - 1), count: UInt16(truncatingIfNeeded: b), systemCoreClock: get(3, 0)).rawValue
        case 9: return d.stopDMA().rawValue
        case 10: d.handleInterrupt()
        case 11: return d.getState()
        case 12: return d.getError()
        case 13...17: d.handleDMAEvent(.init(rawValue: op - 13)!, dmaMode: get(2, a * 13 + 1))
        case 18: return d.registerCallback(id: a, callback: callback(.init(rawValue: a) ?? .receiveHalf, b)).rawValue
        case 19: return d.unregisterCallback(id: a).rawValue
        case 20: d.resetHandleState()
        case 21: d.idle()
        case 22: d.synchronize()
        case 23: d.enableReception()
        case 24: d.enableInterrupts(a)
        case 25: d.disableInterrupts(a)
        case 26: return d.getInterruptSource(a)
        case 27: return d.getFlag(a)
        case 28: d.clearInterrupts(a)
        default: return .max
        }
        return 0
    }
}
