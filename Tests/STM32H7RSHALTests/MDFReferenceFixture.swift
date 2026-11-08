import STM32H7RSHAL
import CMDFReference

struct MDFModel: MDFRegisterIO, MDFHandleIO, MDFSharedIO, MDFCallbackIO, MDFDMAIO {
    let state: OpaquePointer
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    var identity: UInt { 1 }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CMDF_Get(state, area, index) }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CMDF_Set(state, area, index, value) }
    func read(_ register: MDFRegister) -> UInt32 { get(0, register.rawValue / 4) }
    func write(_ register: MDFRegister, value: UInt32) { set(0, register.rawValue / 4, value) }
    func dataAddress() -> UInt32 { 0x4002F0F0 }
    func read(_ word: MDFHandleWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
    func write(_ word: MDFHandleWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
    func readRegisteredHandle() -> UInt { UInt(get(8, 0)) }
    func writeRegisteredHandle(_ identity: UInt) { set(8, 0, UInt32(identity)) }
    func read(_ id: MDFCallbackID) -> MDFCallback? { callback(id, CMDF_GetCallback(state, id.rawValue)) }
    func write(_ id: MDFCallbackID, value: MDFCallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(callback(id, 1)!, to: UInt.self) ? 1 : 2
        CMDF_SetCallback(state, id.rawValue, token)
    }
    func readSoundLevel() -> MDFSoundLevelCallback? { soundCallback(CMDF_GetCallback(state, 3)) }
    func writeSoundLevel(_ value: MDFSoundLevelCallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(soundCallback(1)!, to: UInt.self) ? 1 : 2
        CMDF_SetCallback(state, 3, token)
    }
    func soundCallback(_ token: UInt32) -> MDFSoundLevelCallback? {
        if token == 0 { return nil }
        return token == 1 ? { CMDF_Callback(OpaquePointer($0!), 3, 1, $1, $2) } : { CMDF_Callback(OpaquePointer($0!), 3, 2, $1, $2) }
    }
    func callback(_ id: MDFCallbackID, _ token: UInt32) -> MDFCallback? {
        if token == 0 { return nil }
        switch id {
        case .acquisitionComplete: return token == 1 ? { CMDF_Callback(OpaquePointer($0!), 1, 1, 0, 0) } : { CMDF_Callback(OpaquePointer($0!), 1, 2, 0, 0) }
        case .acquisitionHalfComplete: return token == 1 ? { CMDF_Callback(OpaquePointer($0!), 2, 1, 0, 0) } : { CMDF_Callback(OpaquePointer($0!), 2, 2, 0, 0) }
        case .soundActivity: return token == 1 ? { CMDF_Callback(OpaquePointer($0!), 4, 1, 0, 0) } : { CMDF_Callback(OpaquePointer($0!), 4, 2, 0, 0) }
        case .error: return token == 1 ? { CMDF_Callback(OpaquePointer($0!), 5, 1, 0, 0) } : { CMDF_Callback(OpaquePointer($0!), 5, 2, 0, 0) }
        case .mspInitialize: return token == 1 ? { CMDF_Callback(OpaquePointer($0!), 6, 1, 0, 0) } : { CMDF_Callback(OpaquePointer($0!), 6, 2, 0, 0) }
        case .mspDeinitialize: return token == 1 ? { CMDF_Callback(OpaquePointer($0!), 7, 1, 0, 0) } : { CMDF_Callback(OpaquePointer($0!), 7, 2, 0, 0) }
        case .soundLevel: preconditionFailure()
        }
    }
    var driver: MDF<MDFModel, MDFModel, MDFModel, MDFModel, MDFModel> {
        .init(registers: self, handle: self, shared: self, callbacks: self, dma: self,
              defaults: .init(acquisitionComplete: callback(.acquisitionComplete, 1)!, acquisitionHalfComplete: callback(.acquisitionHalfComplete, 1)!,
                              soundLevel: soundCallback(1)!, soundActivity: callback(.soundActivity, 1)!, error: callback(.error, 1)!,
                              mspInitialize: callback(.mspInitialize, 1)!, mspDeinitialize: callback(.mspDeinitialize, 1)!),
              useRegisteredCallbacks: get(11, 0) != 0)
    }
    func read(_ word: DMAHandleWord) -> UInt32 {
        if word == .mode { return get(4, 0) }
        precondition(word == .queueAddress); return get(4, 1) == 0 ? 0 : 0x1000
    }
    func readMemory32(at address: UInt32) -> UInt32 { precondition(address == 0x1000); return get(4, 2) == 0 ? 0 : 0x2000 }
    func writeMemory32(at address: UInt32, value: UInt32) {
        let offset = address - 0x2000; precondition(offset == 8 || offset == 12 || offset == 16)
        set(4, 1 + offset / 4, value)
    }
    func writeCallback(_ id: DMACallbackID, value: DMACallback?) {
        var token: UInt32 = 0
        if let value {
            for kind in MDFDMACallbackKind.allCases where unsafeBitCast(value, to: UInt.self) == unsafeBitCast(callback(kind), to: UInt.self) { token = kind.rawValue + 1 }
            precondition(token != 0)
        }
        let i: UInt32
        switch id { case .transferComplete: i = 6; case .halfTransfer: i = 7; case .error: i = 8; default: preconditionFailure() }
        set(4, i, token)
    }
    func callback(_ kind: MDFDMACallbackKind) -> DMACallback {
        switch kind {
        case .complete: return { let m = MDFModel(state: OpaquePointer($0!)); m.driver.handleDMAEvent(.complete, dmaMode: m.get(4, 0)) }
        case .halfComplete: return { MDFModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.halfComplete, dmaMode: 0) }
        case .error: return { MDFModel(state: OpaquePointer($0!)).driver.handleDMAEvent(.error, dmaMode: 0) }
        }
    }
    func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        HALStatus(rawValue: CMDF_Start(state, 0, sourceAddress, destinationAddress, sourceDataSize))!
    }
    func startLinkedListInterrupt() -> HALStatus { HALStatus(rawValue: CMDF_Start(state, 1, get(4, 4), get(4, 5), get(4, 3)))! }
    func abort(getTick: () -> UInt32) -> HALStatus { HALStatus(rawValue: CMDF_Abort(state))! }
    var filterConfiguration: MDFFilterConfiguration {
        .init(dataSource: get(2, 0), delay: get(2, 1), cicMode: get(2, 2), decimationRatio: get(2, 3), gain: Int32(bitPattern: get(2, 4)),
              reshapeFilter: .init(activation: get(2, 5), decimationRatio: get(2, 6)), highPassFilter: .init(activation: get(2, 7), cutoffFrequency: get(2, 8)),
              soundActivity: .init(activation: get(2, 9), mode: get(2, 10), frameSize: get(2, 11), hysteresis: get(2, 12),
                                   soundTriggerEvent: get(2, 13), dataMemoryTransfer: get(2, 14), minimumNoiseLevel: get(2, 15), hangoverWindow: get(2, 16),
                                   learningFrames: get(2, 17), ambientNoiseSlope: get(2, 18), signalNoiseThreshold: get(2, 19), soundLevelInterrupt: get(2, 20)),
              acquisitionMode: get(2, 21), fifoThreshold: get(2, 22), discardSamples: get(2, 23), trigger: .init(source: get(2, 24), edge: get(2, 25)))
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32) -> UInt32 {
        let d = driver, f = get(5, 0) != 0 ? filterConfiguration : nil
        let output = CMDF_Output(state, 0)!, signedOutput = UnsafeMutableRawPointer(output).assumingMemoryBound(to: Int32.self)
        let tick = { CMDF_Tick(state) }
        switch op {
        case 0: return d.initialize().rawValue
        case 1: return d.deinitialize().rawValue
        case 2: return d.registerCallback(id: a, callback: callback(a == 3 ? .acquisitionComplete : .init(rawValue: a) ?? .acquisitionComplete, b)).rawValue
        case 3: return d.unregisterCallback(id: a).rawValue
        case 4: return d.registerSoundLevelCallback(soundCallback(a)).rawValue
        case 5: return d.unregisterSoundLevelCallback().rawValue
        case 6: return d.startAcquisition(f).rawValue
        case 7: return d.pollForAcquisition(timeout: a, getTick: tick).rawValue
        case 8: return d.getAcquisitionValue(a == 0 ? nil : signedOutput).rawValue
        case 9: return d.stopAcquisition().rawValue
        case 10: return d.startAcquisitionInterrupt(f).rawValue
        case 11: return d.stopAcquisitionInterrupt().rawValue
        case 12: return d.startAcquisitionDMA(f, dmaConfiguration: get(5, 1) == 0 ? nil : .init(address: get(3, 0), dataLength: get(3, 1), msbOnly: get(3, 2))).rawValue
        case 13: return d.stopAcquisitionDMA(getTick: tick).rawValue
        case 14: return d.generateTrigger().rawValue
        case 15: return d.setDelay(a).rawValue
        case 16: return d.getDelay(a == 0 ? nil : output).rawValue
        case 17: return d.setGain(Int32(bitPattern: a)).rawValue
        case 18: return d.getGain(a == 0 ? nil : signedOutput).rawValue
        case 19: return d.pollForSoundLevel(timeout: a, soundLevel: b & 1 == 0 ? nil : output, ambientNoise: b & 2 == 0 ? nil : output + 1, getTick: tick).rawValue
        case 20: return d.pollForSoundActivity(timeout: a, getTick: tick).rawValue
        case 21: return d.pollForClockAbsence(timeout: a, getTick: tick).rawValue
        case 22: return d.startClockAbsenceInterrupt().rawValue
        case 23: return d.stopClockAbsenceInterrupt().rawValue
        case 24: d.handleInterrupt()
        case 25: return d.getState()
        case 26: return d.getError()
        case 27: d.resetHandleState()
        case 28...30: d.handleDMAEvent(.init(rawValue: op - 28)!, dmaMode: get(4, 0))
        default: preconditionFailure()
        }
        return 0
    }
}
