import STM32H7RSHAL
import CSerialControlReference

func serialMDIOSCallback(_ id: UInt32, _ token: UInt32) -> MDIOSCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (0, 1): return { CSerial_Callback(OpaquePointer($0!), 0, 1, 0) }
    case (0, 2): return { CSerial_Callback(OpaquePointer($0!), 0, 2, 0) }
    case (1, 1): return { CSerial_Callback(OpaquePointer($0!), 1, 1, 0) }
    case (1, 2): return { CSerial_Callback(OpaquePointer($0!), 1, 2, 0) }
    case (2, 1): return { CSerial_Callback(OpaquePointer($0!), 2, 1, 0) }
    case (2, 2): return { CSerial_Callback(OpaquePointer($0!), 2, 2, 0) }
    case (3, 1): return { CSerial_Callback(OpaquePointer($0!), 3, 1, 0) }
    case (3, 2): return { CSerial_Callback(OpaquePointer($0!), 3, 2, 0) }
    case (4, 1): return { CSerial_Callback(OpaquePointer($0!), 4, 1, 0) }
    case (4, 2): return { CSerial_Callback(OpaquePointer($0!), 4, 2, 0) }
    case (5, 1): return { CSerial_Callback(OpaquePointer($0!), 5, 1, 0) }
    case (5, 2): return { CSerial_Callback(OpaquePointer($0!), 5, 2, 0) }
    default: preconditionFailure("Invalid callback token")
    }
}
func serialCECCallback(_ id: UInt32, _ token: UInt32) -> CECCallback? {
    if token == 0 { return nil }
    switch (id, token) {
    case (0, 1): return { CSerial_Callback(OpaquePointer($0!), 0, 1, 0) }
    case (0, 2): return { CSerial_Callback(OpaquePointer($0!), 0, 2, 0) }
    case (2, 1): return { CSerial_Callback(OpaquePointer($0!), 2, 1, 0) }
    case (2, 2): return { CSerial_Callback(OpaquePointer($0!), 2, 2, 0) }
    case (3, 1): return { CSerial_Callback(OpaquePointer($0!), 3, 1, 0) }
    case (3, 2): return { CSerial_Callback(OpaquePointer($0!), 3, 2, 0) }
    case (4, 1): return { CSerial_Callback(OpaquePointer($0!), 4, 1, 0) }
    case (4, 2): return { CSerial_Callback(OpaquePointer($0!), 4, 2, 0) }
    default: preconditionFailure("Invalid callback token")
    }
}
func serialCECReceiveCallback(_ token: UInt32) -> CECReceiveCallback? {
    if token == 0 { return nil }
    if token == 1 { return { CSerial_Callback(OpaquePointer($0!), 1, 1, $1) } }
    return { CSerial_Callback(OpaquePointer($0!), 1, 2, $1) }
}
struct SerialMDIOSIO: MDIOSRegisterIO, MDIOSHandleIO, MDIOSCallbackIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func read(_ register: MDIOSRegister) -> UInt32 { CSerial_Get(state, 0, register.rawValue / 4) }
    func write(_ register: MDIOSRegister, value: UInt32) { CSerial_Set(state, 0, register.rawValue / 4, value) }
    func readInput(_ index: UInt32) -> UInt32 { CSerial_Get(state, 0, 64 + index) }
    func writeOutput(_ index: UInt32, value: UInt32) { CSerial_Set(state, 0, 96 + index, value) }
    func read(_ register: MDIOSWakeupRegister) -> UInt32 { CSerial_Get(state, 4, wakeupIndex(register)) }
    func write(_ register: MDIOSWakeupRegister, value: UInt32) { CSerial_Set(state, 4, wakeupIndex(register), value) }
    func wakeupIndex(_ register: MDIOSWakeupRegister) -> UInt32 {
        switch register { case .imr2: return 0; case .pr2: return 1; case .rtsr2: return 2; case .ftsr2: return 3; case .swier2: return 4 }
    }
    func read(_ word: MDIOSHandleWord) -> UInt32 { CSerial_Get(state, 1, UInt32(word.rawValue)) }
    func write(_ word: MDIOSHandleWord, value: UInt32) { CSerial_Set(state, 1, UInt32(word.rawValue), value) }
    func read(_ id: MDIOSCallbackID) -> MDIOSCallback? { serialMDIOSCallback(id.rawValue, CSerial_GetCallback(state, id.rawValue)) }
    func write(_ id: MDIOSCallbackID, value: MDIOSCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(serialMDIOSCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CSerial_SetCallback(state, id.rawValue, token)
    }
    var hal: MDIOS<Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self, defaults: .init(mspInitialize: serialMDIOSCallback(0, 1)!, mspDeinitialize: serialMDIOSCallback(1, 1)!, writeComplete: serialMDIOSCallback(2, 1)!, readComplete: serialMDIOSCallback(3, 1)!, error: serialMDIOSCallback(4, 1)!, wakeup: serialMDIOSCallback(5, 1)!), useRegisteredCallbacks: mode != 0)
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        switch op {
        case 0: return hal.initialize().rawValue
        case 1: return hal.deinitialize().rawValue
        case 2: return hal.writeRegister(a, value: UInt16(truncatingIfNeeded: b)).rawValue
        case 3:
            var value = UInt16(truncatingIfNeeded: CSerial_Get(state, 3, 2))
            let result = hal.readRegister(a, value: &value); CSerial_Set(state, 3, 2, UInt32(value)); return result.rawValue
        case 4: return hal.getWrittenRegisterAddress()
        case 5: return hal.getReadRegisterAddress()
        case 6: return hal.clearWrittenRegisterAddress(a).rawValue
        case 7: return hal.clearReadRegisterAddress(a).rawValue
        case 8: return hal.enableEvents().rawValue
        case 9: hal.handleInterrupt()
        case 10: return hal.getState()
        case 11: return hal.getError()
        case 12: return hal.registerCallback(id: a, callback: serialMDIOSCallback(a <= 5 ? a : 0, b)).rawValue
        case 13: return hal.unregisterCallback(id: a).rawValue
        case 14: hal.resetHandleState()
        case 15: hal.enable()
        case 16: hal.disable()
        case 17: hal.enableInterrupts(.init(rawValue: a))
        case 18: hal.disableInterrupts(.init(rawValue: a))
        case 19: return hal.getWriteFlag(a)
        case 20: return hal.getReadFlag(a)
        case 21: return hal.getErrorFlag(.init(rawValue: a))
        case 22: hal.clearErrorFlag(.init(rawValue: a))
        case 23: return hal.getInterruptSource(.init(rawValue: a))
        case 24: hal.enableWakeupInterrupt(mask: a)
        case 25: return hal.getWakeupFlag(mask: a)
        case 26: hal.clearWakeupFlag(mask: a)
        case 27: hal.enableWakeupRisingEdge(mask: a)
        case 28: hal.enableWakeupFallingEdge(mask: a)
        case 29: hal.enableWakeupBothEdges(mask: a)
        case 30: hal.generateWakeupInterrupt(mask: a)
        default: preconditionFailure("Invalid MDIOS operation")
        }
        return 0
    }
}
struct SerialCECIO: CECRegisterIO, CECHandleIO, CECCallbackIO {
    let state: OpaquePointer
    let mode: UInt32
    var context: UnsafeMutableRawPointer? { UnsafeMutableRawPointer(state) }
    func read(_ register: CECRegister) -> UInt32 { CSerial_Get(state, 0, register.rawValue / 4) }
    func write(_ register: CECRegister, value: UInt32) { CSerial_Set(state, 0, register.rawValue / 4, value) }
    func read(_ word: CECHandleWord) -> UInt32 { CSerial_Get(state, 1, UInt32(word.rawValue)) }
    func write(_ word: CECHandleWord, value: UInt32) { CSerial_Set(state, 1, UInt32(word.rawValue), value) }
    func read(_ word: CECHandleHalfWord) -> UInt16 { UInt16(truncatingIfNeeded: CSerial_Get(state, 1, UInt32(word.rawValue + 12))) }
    func write(_ word: CECHandleHalfWord, value: UInt16) { CSerial_Set(state, 1, UInt32(word.rawValue + 12), UInt32(value)) }
    func readPointer(_ pointer: CECBufferPointer) -> UnsafeMutableRawPointer? { CSerial_GetPointer(state, UInt32(pointer.rawValue)) }
    func writePointer(_ pointer: CECBufferPointer, value: UnsafeMutableRawPointer?) { CSerial_SetPointer(state, UInt32(pointer.rawValue), value) }
    func read(_ id: CECCallbackID) -> CECCallback? { serialCECCallback(id.rawValue, CSerial_GetCallback(state, id.rawValue)) }
    func write(_ id: CECCallbackID, value: CECCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(serialCECCallback(id.rawValue, 1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CSerial_SetCallback(state, id.rawValue, token)
    }
    func readReceive() -> CECReceiveCallback? { serialCECReceiveCallback(CSerial_GetCallback(state, 1)) }
    func writeReceive(_ value: CECReceiveCallback?) {
        let token: UInt32 = value.map { unsafeBitCast($0, to: UInt.self) == unsafeBitCast(serialCECReceiveCallback(1)!, to: UInt.self) ? 1 : 2 } ?? 0
        CSerial_SetCallback(state, 1, token)
    }
    var hal: CEC<Self, Self, Self> {
        .init(registers: self, handle: self, callbacks: self, defaults: .init(transmitComplete: serialCECCallback(0, 1)!, receiveComplete: serialCECReceiveCallback(1)!, error: serialCECCallback(2, 1)!, mspInitialize: serialCECCallback(3, 1)!, mspDeinitialize: serialCECCallback(4, 1)!), useRegisteredCallbacks: mode != 0)
    }
    func run(_ op: UInt32, _ a: UInt32, _ b: UInt32, _ c: UInt32) -> UInt32 {
        switch op {
        case 0: return hal.initialize().rawValue
        case 1: return hal.deinitialize().rawValue
        case 2: return hal.setDeviceAddress(UInt16(truncatingIfNeeded: a)).rawValue
        case 3: return hal.transmitInterrupt(initiator: UInt8(truncatingIfNeeded: a), destination: UInt8(truncatingIfNeeded: b),
            data: c == 0 ? nil : CSerial_Buffer(state, c - 1)!.assumingMemoryBound(to: UInt8.self), count: CSerial_Get(state, 3, 2)).rawValue
        case 4: hal.handleInterrupt()
        case 5: return hal.getLastReceivedFrameSize()
        case 6: hal.changeReceiveBuffer(a == 0 ? nil : CSerial_Buffer(state, a - 1)!.assumingMemoryBound(to: UInt8.self))
        case 7: return hal.getState()
        case 8: return hal.getError()
        case 9: return hal.registerCallback(id: a, callback: serialCECCallback(a <= 4 && a != 1 ? a : 0, b)).rawValue
        case 10: return hal.unregisterCallback(id: a).rawValue
        case 11: return hal.registerReceiveCallback(serialCECReceiveCallback(a)).rawValue
        case 12: return hal.unregisterReceiveCallback().rawValue
        case 13: hal.resetHandleState()
        case 14: return hal.getFlag(.init(rawValue: a))
        case 15: hal.clearFlag(.init(rawValue: a))
        case 16: hal.enableInterrupts(.init(rawValue: a))
        case 17: hal.disableInterrupts(.init(rawValue: a))
        case 18: return hal.getInterruptSource(.init(rawValue: a))
        case 19: hal.enable()
        case 20: hal.disable()
        case 21: hal.setFirstTransmitByte()
        case 22: hal.setLastTransmitByte()
        case 23: return hal.getTransmissionStartFlag()
        case 24: return hal.getTransmissionEndFlag()
        case 25: hal.clearOwnAddress()
        case 26: hal.setOwnAddress(a)
        default: preconditionFailure("Invalid CEC operation")
        }
        return 0
    }
}
