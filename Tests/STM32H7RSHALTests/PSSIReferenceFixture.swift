import STM32H7RSHAL
import CPSSIReference

struct PSSIModel: PSSIRegisterIO, PSSIHandleIO, PSSICallbackIO, PSSIDMAIO {
    let state: OpaquePointer
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CPSSI_Get(state, area, index) }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CPSSI_Set(state, area, index, value) }
    func read(_ register: PSSIRegister) -> UInt32 { get(0, register.rawValue / 4) }
    func write(_ register: PSSIRegister, value: UInt32) { set(0, register.rawValue / 4, value) }
    func dataAddress() -> UInt32 { 0x48000428 }
    func readData8() -> UInt8 { UInt8(truncatingIfNeeded: read(.dr)) }
    func readData16() -> UInt16 { UInt16(truncatingIfNeeded: read(.dr)) }
    func writeData8(_ value: UInt8) { write(.dr, value: (read(.dr) & 0xFFFFFF00) | UInt32(value)) }
    func writeData16(_ value: UInt16) { write(.dr, value: (read(.dr) & 0xFFFF0000) | UInt32(value)) }
    func read(_ word: PSSIHandleWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
    func write(_ word: PSSIHandleWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
    func readBuffer() -> UnsafeMutableRawPointer? { CPSSI_GetBuffer(state) }
    func writeBuffer(_ buffer: UnsafeMutableRawPointer?) { CPSSI_SetBuffer(state, buffer) }
    func read(_ id: PSSICallbackID) -> PSSICallback? { callback(id, CPSSI_GetCallback(state, id.rawValue)) }
    func write(_ id: PSSICallbackID, value: PSSICallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(callback(id, 1)!, to: UInt.self) ? 1 : 2
        CPSSI_SetCallback(state, id.rawValue, token)
    }
    func callback(_ id: PSSICallbackID, _ token: UInt32) -> PSSICallback? {
        if token == 0 { return nil }
        switch id {
        case .transmitComplete: return token == 1 ? { CPSSI_Callback(OpaquePointer($0!), 0, 1) } : { CPSSI_Callback(OpaquePointer($0!), 0, 2) }
        case .receiveComplete: return token == 1 ? { CPSSI_Callback(OpaquePointer($0!), 1, 1) } : { CPSSI_Callback(OpaquePointer($0!), 1, 2) }
        case .error: return token == 1 ? { CPSSI_Callback(OpaquePointer($0!), 3, 1) } : { CPSSI_Callback(OpaquePointer($0!), 3, 2) }
        case .abortComplete: return token == 1 ? { CPSSI_Callback(OpaquePointer($0!), 4, 1) } : { CPSSI_Callback(OpaquePointer($0!), 4, 2) }
        case .mspInitialize: return token == 1 ? { CPSSI_Callback(OpaquePointer($0!), 5, 1) } : { CPSSI_Callback(OpaquePointer($0!), 5, 2) }
        case .mspDeinitialize: return token == 1 ? { CPSSI_Callback(OpaquePointer($0!), 6, 1) } : { CPSSI_Callback(OpaquePointer($0!), 6, 2) }
        }
    }
    var driver: PSSI<PSSIModel, PSSIModel, PSSIModel, PSSIModel> {
        .init(registers: self, handle: self, callbacks: self, dma: self,
              defaults: .init(mspInitialize: callback(.mspInitialize, 1)!, mspDeinitialize: callback(.mspDeinitialize, 1)!,
                              transmitComplete: callback(.transmitComplete, 1)!, receiveComplete: callback(.receiveComplete, 1)!,
                              error: callback(.error, 1)!, abortComplete: callback(.abortComplete, 1)!),
              useRegisteredCallbacks: get(9, 0) != 0, dmaModuleEnabled: get(9, 1) != 0)
    }
    func isPresent(_ direction: PSSIDMADirection) -> Bool { get(2, direction.rawValue * 15) != 0 }
    func readDataWidth(_ direction: PSSIDMADirection) -> UInt32 { get(2, direction.rawValue * 15 + 2) }
    func read(_ direction: PSSIDMADirection, word: DMAHandleWord) -> UInt32 {
        if word == .mode { return get(2, direction.rawValue * 15 + 1) }
        precondition(word == .queueAddress)
        return get(2, direction.rawValue * 15 + 3) == 0 ? 0 : 0x1000 + direction.rawValue * 0x100
    }
    func readMemory32(_ direction: PSSIDMADirection, at address: UInt32) -> UInt32 {
        precondition(address == 0x1000 + direction.rawValue * 0x100)
        return get(2, direction.rawValue * 15 + 4) == 0 ? 0 : 0x2000 + direction.rawValue * 0x100
    }
    func writeMemory32(_ direction: PSSIDMADirection, at address: UInt32, value: UInt32) {
        let offset = address - (0x2000 + direction.rawValue * 0x100)
        precondition(offset == 8 || offset == 12 || offset == 16)
        set(2, direction.rawValue * 15 + 3 + offset / 4, value)
    }
    func writeCallback(_ direction: PSSIDMADirection, id: DMACallbackID, value: DMACallback?) {
        var token: UInt32 = 0
        if let value {
            for kind in PSSIDMACallbackKind.allCases where unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) {
                token = kind.rawValue + 1
            }
            precondition(token != 0)
        }
        set(2, direction.rawValue * 15 + 8 + id.rawValue, token)
    }
    func invokeCallback(_ direction: PSSIDMADirection, id: DMACallbackID) {
        let token = get(2, direction.rawValue * 15 + 8 + id.rawValue)
        callback(PSSIDMACallbackKind(rawValue: token - 1)!)(context)
    }
    func callback(_ kind: PSSIDMACallbackKind) -> DMACallback {
        switch kind {
        case .transmitComplete: return { PSSIModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.transmitComplete) }
        case .receiveComplete: return { PSSIModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.receiveComplete) }
        case .error: return { PSSIModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.error) }
        case .abort: return { PSSIModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.abort) }
        }
    }
    func startInterrupt(_ direction: PSSIDMADirection, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        HALStatus(rawValue: CPSSI_Start(state, direction.rawValue, 0, sourceAddress, destinationAddress, sourceDataSize))!
    }
    func startLinkedListInterrupt(_ direction: PSSIDMADirection) -> HALStatus {
        HALStatus(rawValue: CPSSI_Start(state, direction.rawValue, 1, get(2, direction.rawValue * 15 + 6), get(2, direction.rawValue * 15 + 7), get(2, direction.rawValue * 15 + 5)))!
    }
    func abortInterrupt(_ direction: PSSIDMADirection) -> HALStatus {
        let result = HALStatus(rawValue: CPSSI_Abort(state, direction.rawValue))!
        if result == .ok && get(2, direction.rawValue * 15 + 14) != 0 && get(2, direction.rawValue * 15 + 11) != 0 {
            invokeCallback(direction, id: .abort)
        }
        return result
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        let d = driver
        switch op {
        case 0: return d.initialize().rawValue
        case 1: return d.deinitialize().rawValue
        case 2: return d.transmit(a == 0 ? nil : CPSSI_Buffer(state, a - 1), count: b, timeout: c, getTick: { CPSSI_Tick(state) }).rawValue
        case 3: return d.receive(a == 0 ? nil : CPSSI_Buffer(state, a - 1), count: b, timeout: c, getTick: { CPSSI_Tick(state) }).rawValue
        case 4: return d.transmitDMA(a == 0 ? nil : CPSSI_Buffer(state, a - 1).assumingMemoryBound(to: UInt32.self), count: b).rawValue
        case 5: return d.receiveDMA(a == 0 ? nil : CPSSI_Buffer(state, a - 1).assumingMemoryBound(to: UInt32.self), count: b).rawValue
        case 6: return d.abortDMA().rawValue
        case 7: d.handleInterrupt()
        case 8: return d.getState()
        case 9: return d.getError()
        case 10...13: d.handleDMAEvent(.init(rawValue: op - 10)!)
        case 14: return d.configureClock(a).rawValue
        case 15: return d.registerCallback(id: a, callback: callback(.init(rawValue: a) ?? .transmitComplete, b)).rawValue
        case 16: return d.unregisterCallback(id: a).rawValue
        case 17: d.resetHandleState()
        case 18: d.enable()
        case 19: d.disable()
        case 20: return d.getStatus(a)
        case 21: return d.getFlag(a)
        case 22: d.clearFlag(a)
        case 23: d.enableInterrupts(a)
        case 24: d.disableInterrupts(a)
        case 25: return d.getInterruptSource(a)
        default: return .max
        }
        return 0
    }
}
