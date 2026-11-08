import STM32H7RSHAL
import CLPTIMReference

func lptimCallback(_ id: UInt32, _ token: UInt32) -> LPTIMCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (0, 1): return { CLPTIM_Callback(OpaquePointer($0!), 0, 1) }
    case (0, 2): return { CLPTIM_Callback(OpaquePointer($0!), 0, 2) }
    case (1, 1): return { CLPTIM_Callback(OpaquePointer($0!), 1, 1) }
    case (1, 2): return { CLPTIM_Callback(OpaquePointer($0!), 1, 2) }
    case (2, 1): return { CLPTIM_Callback(OpaquePointer($0!), 2, 1) }
    case (2, 2): return { CLPTIM_Callback(OpaquePointer($0!), 2, 2) }
    case (3, 1): return { CLPTIM_Callback(OpaquePointer($0!), 3, 1) }
    case (3, 2): return { CLPTIM_Callback(OpaquePointer($0!), 3, 2) }
    case (4, 1): return { CLPTIM_Callback(OpaquePointer($0!), 4, 1) }
    case (4, 2): return { CLPTIM_Callback(OpaquePointer($0!), 4, 2) }
    case (5, 1): return { CLPTIM_Callback(OpaquePointer($0!), 5, 1) }
    case (5, 2): return { CLPTIM_Callback(OpaquePointer($0!), 5, 2) }
    case (6, 1): return { CLPTIM_Callback(OpaquePointer($0!), 6, 1) }
    case (6, 2): return { CLPTIM_Callback(OpaquePointer($0!), 6, 2) }
    case (7, 1): return { CLPTIM_Callback(OpaquePointer($0!), 7, 1) }
    case (7, 2): return { CLPTIM_Callback(OpaquePointer($0!), 7, 2) }
    case (8, 1): return { CLPTIM_Callback(OpaquePointer($0!), 8, 1) }
    case (8, 2): return { CLPTIM_Callback(OpaquePointer($0!), 8, 2) }
    case (9, 1): return { CLPTIM_Callback(OpaquePointer($0!), 9, 1) }
    case (9, 2): return { CLPTIM_Callback(OpaquePointer($0!), 9, 2) }
    case (10, 1): return { CLPTIM_Callback(OpaquePointer($0!), 10, 1) }
    case (10, 2): return { CLPTIM_Callback(OpaquePointer($0!), 10, 2) }
    case (11, 1): return { CLPTIM_Callback(OpaquePointer($0!), 11, 1) }
    case (11, 2): return { CLPTIM_Callback(OpaquePointer($0!), 11, 2) }
    case (12, 1): return { CLPTIM_Callback(OpaquePointer($0!), 12, 1) }
    case (12, 2): return { CLPTIM_Callback(OpaquePointer($0!), 12, 2) }
    case (13, 1): return { CLPTIM_Callback(OpaquePointer($0!), 13, 1) }
    case (13, 2): return { CLPTIM_Callback(OpaquePointer($0!), 13, 2) }
    case (14, 1): return { CLPTIM_Callback(OpaquePointer($0!), 14, 1) }
    case (14, 2): return { CLPTIM_Callback(OpaquePointer($0!), 14, 2) }
    case (15, 1): return { CLPTIM_Callback(OpaquePointer($0!), 15, 1) }
    case (15, 2): return { CLPTIM_Callback(OpaquePointer($0!), 15, 2) }
    default: preconditionFailure("Invalid LPTIM callback")
    }
}
private func lptimDMACallback(_ token: UInt32) -> DMACallback {
    switch token {
    case 0: return { _ in }
    case 1: return { if let p = $0 { p.storeBytes(of: UInt32(1), as: UInt32.self) } }
    case 2: return { if let p = $0 { p.storeBytes(of: UInt32(2), as: UInt32.self) } }
    case 3: return { if let p = $0 { p.storeBytes(of: UInt32(3), as: UInt32.self) } }
    default: return { if let p = $0 { p.storeBytes(of: UInt32(4), as: UInt32.self) } }
    }
}
struct LPTIMReferenceIO: LPTIMRegisterIO, LPTIMHandleIO, LPTIMCallbackIO, LPTIMDMAIO {
    let state: OpaquePointer
    let mode: UInt32
    let instance: LPTIMInstance
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func read(_ register: LPTIMRegister) -> UInt32 {
        register == .isr ? CLPTIM_ReadISR(state) : CLPTIM_Get(state, 0, register.rawValue / 4)
    }
    func write(_ register: LPTIMRegister, value: UInt32) { CLPTIM_Set(state, 0, register.rawValue / 4, value) }
    func address(of register: LPTIMRegister) -> UInt32 { CLPTIM_Address(state, register.rawValue) }
    func readWakeupInterruptMask() -> UInt32 { CLPTIM_Get(state, 5, 0) }
    func writeWakeupInterruptMask(_ value: UInt32) { CLPTIM_Set(state, 5, 0, value) }
    func read(_ word: LPTIMHandleWord) -> UInt32 { CLPTIM_Get(state, 1, UInt32(word.rawValue)) }
    func write(_ word: LPTIMHandleWord, value: UInt32) { CLPTIM_Set(state, 1, UInt32(word.rawValue), value) }
    func read(_ id: LPTIMCallbackID) -> LPTIMCallback? { lptimCallback(id.rawValue, CLPTIM_GetCallback(state, id.rawValue)) }
    func write(_ id: LPTIMCallbackID, value: LPTIMCallback?) {
        let token: UInt32 = value.map {
            unsafeBitCast($0, to: UInt.self) == unsafeBitCast(lptimCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2
        } ?? 0
        CLPTIM_SetCallback(state, id.rawValue, token)
    }
    func read(_ channel: LPTIMChannel, word: DMAHandleWord) -> UInt32 {
        precondition(word == .mode || word == .queueAddress)
        return CLPTIM_Get(state, 7, (channel.rawValue + 1) * 3 + (word == .mode ? 0 : 1))
    }
    func readMemory32(_ channel: LPTIMChannel, at address: UInt32) -> UInt32 {
        precondition(address == 0x1000)
        return CLPTIM_Get(state, 7, (channel.rawValue + 1) * 3 + 2)
    }
    func writeMemory32(_ channel: LPTIMChannel, at address: UInt32, value: UInt32) {
        CLPTIM_Set(state, 6, (channel.rawValue + 1) * 8 + (address - 0x2000) / 4, value)
    }
    func callback(_ kind: LPTIMDMACallbackKind) -> DMACallback { lptimDMACallback(kind.rawValue) }
    func writeCallback(_ channel: LPTIMChannel, id: DMACallbackID, value: DMACallback?) {
        var token: UInt32 = .max
        if let value {
            for kind: UInt32 in 0..<5 where unsafeBitCast(value, to: UInt.self) == unsafeBitCast(lptimDMACallback(kind), to: UInt.self) { token = kind; break }
        }
        CLPTIM_SetDMACallback(state, channel.rawValue + 1, id.rawValue, token)
    }
    func matches(_ channel: LPTIMChannel, context: UnsafeMutableRawPointer?) -> Bool {
        UInt(bitPattern: context) == UInt(channel.rawValue + 1)
    }
    func startInterrupt(_ channel: LPTIMChannel, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus {
        .init(rawValue: CLPTIM_DMAStart(state, channel.rawValue + 1, sourceAddress, destinationAddress, sourceDataSize, 0))!
    }
    func startLinkedListInterrupt(_ channel: LPTIMChannel) -> HALStatus {
        .init(rawValue: CLPTIM_DMAStart(state, channel.rawValue + 1, 0, 0, 0, 1))!
    }
    func abortInterrupt(_ channel: LPTIMChannel) -> HALStatus { .init(rawValue: CLPTIM_DMAAbort(state, channel.rawValue + 1))! }
    var hal: LPTIM<Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self, getSystemCoreClock: { CLPTIM_Clock(state) },
              defaults: .init(mspInitialize: lptimCallback(0, 1)!,
                              mspDeinitialize: lptimCallback(1, 1)!,
                              compareMatch: lptimCallback(2, 1)!,
                              autoReloadMatch: lptimCallback(3, 1)!,
                              trigger: lptimCallback(4, 1)!,
                              compareWrite: lptimCallback(5, 1)!,
                              autoReloadWrite: lptimCallback(6, 1)!,
                              directionUp: lptimCallback(7, 1)!,
                              directionDown: lptimCallback(8, 1)!,
                              updateEvent: lptimCallback(9, 1)!,
                              repetitionWrite: lptimCallback(10, 1)!,
                              updateHalfComplete: lptimCallback(11, 1)!,
                              error: lptimCallback(12, 1)!,
                              inputCapture: lptimCallback(13, 1)!,
                              inputCaptureHalfComplete: lptimCallback(14, 1)!,
                              overCapture: lptimCallback(15, 1)!),
              useRegisteredCallbacks: mode != 0)
    }
    func parameter(_ index: UInt32) -> UInt32 { CLPTIM_Get(state, 4, index) }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        let channel = LPTIMChannel(rawValue: a) ?? .channel1
        switch op {
        case 0: return hal.initialize().rawValue
        case 1: return hal.deinitialize().rawValue
        case 2: return hal.startPWM(channel: channel, interrupts: false).rawValue
        case 3: return hal.stopPWM(channel: channel, interrupts: false).rawValue
        case 4: return hal.startPWM(channel: channel, interrupts: true).rawValue
        case 5: return hal.stopPWM(channel: channel, interrupts: true).rawValue
        case 6: return hal.startOnePulse(channel: channel, interrupts: false).rawValue
        case 7: return hal.stopOnePulse(channel: channel, interrupts: false).rawValue
        case 8: return hal.startOnePulse(channel: channel, interrupts: true).rawValue
        case 9: return hal.stopOnePulse(channel: channel, interrupts: true).rawValue
        case 10: return hal.startSetOnce(channel: channel, interrupts: false).rawValue
        case 11: return hal.stopSetOnce(channel: channel, interrupts: false).rawValue
        case 12: return hal.startSetOnce(channel: channel, interrupts: true).rawValue
        case 13: return hal.stopSetOnce(channel: channel, interrupts: true).rawValue
        case 14: return hal.startEncoder(interrupts: false).rawValue
        case 15: return hal.stopEncoder(interrupts: false).rawValue
        case 16: return hal.startEncoder(interrupts: true).rawValue
        case 17: return hal.stopEncoder(interrupts: true).rawValue
        case 18: return hal.startTimeout(a, interrupts: false).rawValue
        case 19: return hal.stopTimeout(interrupts: false).rawValue
        case 20: return hal.startTimeout(a, interrupts: true).rawValue
        case 21: return hal.stopTimeout(interrupts: true).rawValue
        case 22: return hal.startCounter(interrupts: false).rawValue
        case 23: return hal.stopCounter(interrupts: false).rawValue
        case 24: return hal.startCounter(interrupts: true).rawValue
        case 25: return hal.stopCounter(interrupts: true).rawValue
        case 26: return hal.startInputCapture(channel: channel, interrupts: false).rawValue
        case 27: return hal.stopInputCapture(channel: channel, interrupts: false).rawValue
        case 28: return hal.startInputCapture(channel: channel, interrupts: true).rawValue
        case 29: return hal.stopInputCapture(channel: channel, interrupts: true).rawValue
        case 30: return hal.configureOutputCompare(.init(pulse: parameter(0), polarity: parameter(1)), channel: channel).rawValue
        case 31: return hal.configureInputCapture(.init(inputSource: parameter(2), prescaler: parameter(3), polarity: parameter(4), filter: parameter(5)), channel: channel).rawValue
        case 32: return hal.startPWMDMA(channel: channel, data: .init(bitPattern: UInt(b)), length: c, dma: self).rawValue
        case 33: return hal.stopPWMDMA(channel: channel, dma: self).rawValue
        case 34: return hal.startInputCaptureDMA(channel: channel, data: .init(bitPattern: UInt(b)), length: c, dma: self).rawValue
        case 35: return hal.stopInputCaptureDMA(channel: channel, dma: self).rawValue
        case 36: hal.handleInterrupt()
        case 37: return hal.readCounter()
        case 38: return hal.readAutoReload()
        case 39: return hal.readCapturedValue(channel: channel)
        case 40: return UInt32(hal.inputCaptureOffset(channel: channel))
        case 41: return hal.getState()
        case 42: hal.resetHandleState()
        case 43: return hal.registerCallback(id: a, callback: lptimCallback(a <= 15 ? a : 0, b)).rawValue
        case 44: return hal.unregisterCallback(id: a).rawValue
        case 45: hal.enable()
        case 46: hal.disable()
        case 47: hal.startContinuous()
        case 48: hal.startSingle()
        case 49: hal.resetCounter()
        case 50: hal.resetCounterAfterRead()
        case 51: hal.setAutoReload(a)
        case 52: hal.setCompare(channel: channel, value: b)
        case 53: hal.setRepetitionCounter(a)
        case 54: return hal.getRepetitionCounter()
        case 55: hal.enableCaptureCompare(channel: channel)
        case 56: hal.disableCaptureCompare(channel: channel)
        case 57: return hal.getFlag(.init(rawValue: a)) ? 1 : 0
        case 58: hal.clearFlag(.init(rawValue: a))
        case 59: hal.enableInterrupts(.init(rawValue: a))
        case 60: hal.disableInterrupts(.init(rawValue: a))
        case 61: return hal.getInterruptSource(.init(rawValue: a)) ? 1 : 0
        case 62: hal.enableDMARequests(.init(rawValue: a))
        case 63: hal.disableDMARequests(.init(rawValue: a))
        case 64: hal.enableWakeupInterrupt()
        case 65: hal.disableWakeupInterrupt()
        case 66: hal.handleDMAEvent(.init(rawValue: a)!, sourceContext: .init(bitPattern: UInt(b)), dma: self)
        default: preconditionFailure("Invalid LPTIM operation")
        }
        return 0
    }
}
