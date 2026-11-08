// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RTC operations and definitions from stm32h7rsxx_hal_rtc.c/.h and rtc_ex.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias RTCCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum RTCCallbackID: UInt32, CaseIterable, Sendable {
    case alarmA = 0
    case alarmB = 1
    case timestamp = 2
    case wakeUp = 3
    case subsecondUnderflow = 4
    case tamper1 = 5
    case tamper2 = 6
    case tamper3 = 7
    case tamper4 = 8
    case tamper5 = 9
    case tamper6 = 10
    case tamper7 = 11
    case tamper8 = 12
    case internalTamper1 = 13
    case internalTamper2 = 14
    case internalTamper3 = 15
    case internalTamper4 = 16
    case internalTamper5 = 17
    case internalTamper6 = 18
    case internalTamper7 = 19
    case internalTamper8 = 20
    case internalTamper9 = 21
    case internalTamper11 = 22
    case internalTamper15 = 23
    case mspInitialize = 24
    case mspDeinitialize = 25
}
public protocol RTCCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: RTCCallbackID) -> RTCCallback?
    func write(_ id: RTCCallbackID, value: RTCCallback?)
}
public struct RTCCallbackDefaults {
    public var alarmA: RTCCallback
    public var alarmB: RTCCallback
    public var timestamp: RTCCallback
    public var wakeUp: RTCCallback
    public var subsecondUnderflow: RTCCallback
    public var tamper1: RTCCallback
    public var tamper2: RTCCallback
    public var tamper3: RTCCallback
    public var tamper4: RTCCallback
    public var tamper5: RTCCallback
    public var tamper6: RTCCallback
    public var tamper7: RTCCallback
    public var tamper8: RTCCallback
    public var internalTamper1: RTCCallback
    public var internalTamper2: RTCCallback
    public var internalTamper3: RTCCallback
    public var internalTamper4: RTCCallback
    public var internalTamper5: RTCCallback
    public var internalTamper6: RTCCallback
    public var internalTamper7: RTCCallback
    public var internalTamper8: RTCCallback
    public var internalTamper9: RTCCallback
    public var internalTamper11: RTCCallback
    public var internalTamper15: RTCCallback
    public var mspInitialize: RTCCallback
    public var mspDeinitialize: RTCCallback
    public init(alarmA: @escaping RTCCallback = { _ in }, alarmB: @escaping RTCCallback = { _ in }, timestamp: @escaping RTCCallback = { _ in }, wakeUp: @escaping RTCCallback = { _ in }, subsecondUnderflow: @escaping RTCCallback = { _ in }, tamper1: @escaping RTCCallback = { _ in }, tamper2: @escaping RTCCallback = { _ in }, tamper3: @escaping RTCCallback = { _ in }, tamper4: @escaping RTCCallback = { _ in }, tamper5: @escaping RTCCallback = { _ in }, tamper6: @escaping RTCCallback = { _ in }, tamper7: @escaping RTCCallback = { _ in }, tamper8: @escaping RTCCallback = { _ in }, internalTamper1: @escaping RTCCallback = { _ in }, internalTamper2: @escaping RTCCallback = { _ in }, internalTamper3: @escaping RTCCallback = { _ in }, internalTamper4: @escaping RTCCallback = { _ in }, internalTamper5: @escaping RTCCallback = { _ in }, internalTamper6: @escaping RTCCallback = { _ in }, internalTamper7: @escaping RTCCallback = { _ in }, internalTamper8: @escaping RTCCallback = { _ in }, internalTamper9: @escaping RTCCallback = { _ in }, internalTamper11: @escaping RTCCallback = { _ in }, internalTamper15: @escaping RTCCallback = { _ in }, mspInitialize: @escaping RTCCallback = { _ in }, mspDeinitialize: @escaping RTCCallback = { _ in }) {
        self.alarmA = alarmA
        self.alarmB = alarmB
        self.timestamp = timestamp
        self.wakeUp = wakeUp
        self.subsecondUnderflow = subsecondUnderflow
        self.tamper1 = tamper1
        self.tamper2 = tamper2
        self.tamper3 = tamper3
        self.tamper4 = tamper4
        self.tamper5 = tamper5
        self.tamper6 = tamper6
        self.tamper7 = tamper7
        self.tamper8 = tamper8
        self.internalTamper1 = internalTamper1
        self.internalTamper2 = internalTamper2
        self.internalTamper3 = internalTamper3
        self.internalTamper4 = internalTamper4
        self.internalTamper5 = internalTamper5
        self.internalTamper6 = internalTamper6
        self.internalTamper7 = internalTamper7
        self.internalTamper8 = internalTamper8
        self.internalTamper9 = internalTamper9
        self.internalTamper11 = internalTamper11
        self.internalTamper15 = internalTamper15
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
    }
    public func callback(_ id: RTCCallbackID) -> RTCCallback {
        switch id {
        case .alarmA: return alarmA
        case .alarmB: return alarmB
        case .timestamp: return timestamp
        case .wakeUp: return wakeUp
        case .subsecondUnderflow: return subsecondUnderflow
        case .tamper1: return tamper1
        case .tamper2: return tamper2
        case .tamper3: return tamper3
        case .tamper4: return tamper4
        case .tamper5: return tamper5
        case .tamper6: return tamper6
        case .tamper7: return tamper7
        case .tamper8: return tamper8
        case .internalTamper1: return internalTamper1
        case .internalTamper2: return internalTamper2
        case .internalTamper3: return internalTamper3
        case .internalTamper4: return internalTamper4
        case .internalTamper5: return internalTamper5
        case .internalTamper6: return internalTamper6
        case .internalTamper7: return internalTamper7
        case .internalTamper8: return internalTamper8
        case .internalTamper9: return internalTamper9
        case .internalTamper11: return internalTamper11
        case .internalTamper15: return internalTamper15
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        }
    }
}
extension RTC {
    @discardableResult
    public func registerCallback(id: UInt32, callback: RTCCallback?) -> HALStatus {
        guard let callback else { return .error }
        if handle.read(.state) == 1 {
            guard let id = RTCCallbackID(rawValue: id) else { return .error }
            callbacks.write(id, value: callback)
        } else if handle.read(.state) == 0 {
            guard id == 24 || id == 25 else { return .error }
            callbacks.write(RTCCallbackID(rawValue: id)!, value: callback)
        } else { return .error }
        return .ok
    }
    @discardableResult
    public func registerCallback(id: RTCCallbackID, callback: RTCCallback?) -> HALStatus { registerCallback(id: id.rawValue, callback: callback) }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        if handle.read(.state) == 1 {
            guard let id = RTCCallbackID(rawValue: id) else { return .error }
            callbacks.write(id, value: defaults.callback(id))
        } else if handle.read(.state) == 0 {
            guard id == 24 || id == 25 else { return .error }
            let id = RTCCallbackID(rawValue: id)!; callbacks.write(id, value: defaults.callback(id))
        } else { return .error }
        return .ok
    }
    @discardableResult
    public func unregisterCallback(id: RTCCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    func invoke(_ id: RTCCallbackID) { (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context) }
    func lock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func unlock() { handle.write(.lock, value: 0) }
    func modify(_ register: RTCRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func modifyTamper(_ register: RTCTamperRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.writeTamper(register, value: (registers.readTamper(register) & ~clear) | set) }
    public func disableWriteProtection() { registers.write(.wpr, value: 0xCA); registers.write(.wpr, value: 0x53) }
    public func enableWriteProtection() { registers.write(.wpr, value: 0xFF) }
    public func getState() -> UInt32 { handle.read(.state) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
}
