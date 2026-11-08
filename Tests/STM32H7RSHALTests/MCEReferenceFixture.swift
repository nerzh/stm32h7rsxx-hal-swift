import CMCEReference
import STM32H7RSHAL

struct MCEModel: MCERegisterIO, MCEHandleIO, MCECallbackIO {
    let state: OpaquePointer
    var instance: MCEInstance { .init(rawValue: get(7, 1))! }
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func get(_ area: UInt32, _ index: UInt32) -> UInt32 { CMCE_Get(state, area, index) }
    func set(_ area: UInt32, _ index: UInt32, _ value: UInt32) { CMCE_Set(state, area, index, value) }
    static func offset(_ register: MCERegister) -> UInt32 {
        switch register {
        case .cr: return 0
        case .sr: return 4
        case .iasr: return 8
        case .iacr: return 12
        case .iaier: return 16
        case .privcfgr: return 28
        case .iaesr: return 32
        case .iaddr: return 36
        case .masterKey(let i): return 0x200 + i * 4
        case .fastMasterKey(let i): return 0x220 + i * 4
        case .region(let i, let f): return 0x40 + i * 0x10 + f.rawValue
        case .context(let i, let f): return 0x240 + i * 0x30 + f.rawValue
        }
    }
    func read(_ register: MCERegister) -> UInt32 { get(0, Self.offset(register) / 4) }
    func write(_ register: MCERegister, value: UInt32) { CMCE_Write(state, Self.offset(register), value) }
    func read(_ word: MCEHandleWord) -> UInt32 { get(1, UInt32(word.rawValue)) }
    func write(_ word: MCEHandleWord, value: UInt32) { set(1, UInt32(word.rawValue), value) }
    func read(_ id: MCECallbackID) -> MCECallback? { callback(id, CMCE_GetCallback(state, id.rawValue)) }
    func write(_ id: MCECallbackID, value: MCECallback?) {
        let token: UInt32 = value == nil ? 0 : unsafeBitCast(value!, to: UInt.self) == unsafeBitCast(callback(id, 1)!, to: UInt.self) ? 1 : 2
        CMCE_SetCallback(state, id.rawValue, token)
    }
    func callback(_ id: MCECallbackID, _ token: UInt32) -> MCECallback? {
        if token == 0 { return nil }
        switch id {
        case .error: return token == 1 ? { CMCE_Callback(OpaquePointer($0!), 0, 1) } : { CMCE_Callback(OpaquePointer($0!), 0, 2) }
        case .mspInitialize: return token == 1 ? { CMCE_Callback(OpaquePointer($0!), 1, 1) } : { CMCE_Callback(OpaquePointer($0!), 1, 2) }
        case .mspDeinitialize: return token == 1 ? { CMCE_Callback(OpaquePointer($0!), 2, 1) } : { CMCE_Callback(OpaquePointer($0!), 2, 2) }
        }
    }
    var driver: MCE<MCEModel, MCEModel, MCEModel> {
        .init(registers: self, handle: self, callbacks: self,
              defaults: .init(error: callback(.error, 1)!, mspInitialize: callback(.mspInitialize, 1)!,
                              mspDeinitialize: callback(.mspDeinitialize, 1)!), useRegisteredCallbacks: get(7, 0) != 0)
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32) -> UInt32 {
        let d = driver
        switch op {
        case 0: return d.initialize().rawValue
        case 1: return d.deinitialize().rawValue
        case 2: return d.configureNoekeon(keyType: a, key: get(2, 0) == 0 ? nil : CMCE_Key(state), getTick: { CMCE_Tick(state) }).rawValue
        case 3: return d.configureAESContext(get(2, 1) == 0 ? nil : .init(nonce0: get(3, 6), nonce1: get(3, 7), version: get(3, 8), key: get(2, 0) == 0 ? nil : CMCE_Key(state)), context: a).rawValue
        case 4: return d.configureRegion(get(2, 1) == 0 ? nil : .init(context: get(3, 0), startAddress: get(3, 1), endAddress: get(3, 2), cipher: get(3, 3), access: get(3, 4), privilege: get(3, 5)), index: a).rawValue
        case 5: return d.setRegionAESContext(a, region: b).rawValue
        case 6: return d.enableAESContext(a).rawValue
        case 7: return d.disableAESContext(a).rawValue
        case 8: return d.enableRegion(a).rawValue
        case 9: return d.disableRegion(a).rawValue
        case 10: return d.lockGlobalConfiguration().rawValue
        case 11: return d.lockAESContextConfiguration(a).rawValue
        case 12: return d.lockAESContextKey(a).rawValue
        case 13: return d.lockNoekeonMasterKeys().rawValue
        case 14:
            var crc = get(3, 9)
            let status = d.getAESContextKeyCRC(a, value: &crc)
            set(3, 9, crc); return status.rawValue
        case 15: return MCEKeyCRC.compute(CMCE_Key(state))
        case 16: d.handleInterrupt()
        case 17: return d.getState()
        case 18: return d.getError()
        case 19: d.resetHandleState()
        case 20: d.enableInterrupts(.init(rawValue: a))
        case 21: d.disableInterrupts(.init(rawValue: a))
        case 22: return d.getFlag(a) ? 1 : 0
        case 23: d.clearFlag(a)
        default: return .max
        }
        return 0
    }
}
