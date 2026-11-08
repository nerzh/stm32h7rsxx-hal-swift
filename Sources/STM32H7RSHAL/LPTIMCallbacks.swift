// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LPTIM operations and definitions from stm32h7rsxx_hal_lptim.c/.h and
// stm32h7rsxx_ll_lptim.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias LPTIMCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum LPTIMCallbackID: UInt32, CaseIterable, Sendable {
    case mspInitialize = 0
    case mspDeinitialize = 1
    case compareMatch = 2
    case autoReloadMatch = 3
    case trigger = 4
    case compareWrite = 5
    case autoReloadWrite = 6
    case directionUp = 7
    case directionDown = 8
    case updateEvent = 9
    case repetitionWrite = 10
    case updateHalfComplete = 11
    case error = 12
    case inputCapture = 13
    case inputCaptureHalfComplete = 14
    case overCapture = 15
}
public protocol LPTIMCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: LPTIMCallbackID) -> LPTIMCallback?
    func write(_ id: LPTIMCallbackID, value: LPTIMCallback?)
}
public struct LPTIMCallbackDefaults {
    public var mspInitialize: LPTIMCallback
    public var mspDeinitialize: LPTIMCallback
    public var compareMatch: LPTIMCallback
    public var autoReloadMatch: LPTIMCallback
    public var trigger: LPTIMCallback
    public var compareWrite: LPTIMCallback
    public var autoReloadWrite: LPTIMCallback
    public var directionUp: LPTIMCallback
    public var directionDown: LPTIMCallback
    public var updateEvent: LPTIMCallback
    public var repetitionWrite: LPTIMCallback
    public var updateHalfComplete: LPTIMCallback
    public var error: LPTIMCallback
    public var inputCapture: LPTIMCallback
    public var inputCaptureHalfComplete: LPTIMCallback
    public var overCapture: LPTIMCallback
    public init(mspInitialize: @escaping LPTIMCallback = { _ in },
                mspDeinitialize: @escaping LPTIMCallback = { _ in },
                compareMatch: @escaping LPTIMCallback = { _ in },
                autoReloadMatch: @escaping LPTIMCallback = { _ in },
                trigger: @escaping LPTIMCallback = { _ in },
                compareWrite: @escaping LPTIMCallback = { _ in },
                autoReloadWrite: @escaping LPTIMCallback = { _ in },
                directionUp: @escaping LPTIMCallback = { _ in },
                directionDown: @escaping LPTIMCallback = { _ in },
                updateEvent: @escaping LPTIMCallback = { _ in },
                repetitionWrite: @escaping LPTIMCallback = { _ in },
                updateHalfComplete: @escaping LPTIMCallback = { _ in },
                error: @escaping LPTIMCallback = { _ in },
                inputCapture: @escaping LPTIMCallback = { _ in },
                inputCaptureHalfComplete: @escaping LPTIMCallback = { _ in },
                overCapture: @escaping LPTIMCallback = { _ in }) {
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
        self.compareMatch = compareMatch
        self.autoReloadMatch = autoReloadMatch
        self.trigger = trigger
        self.compareWrite = compareWrite
        self.autoReloadWrite = autoReloadWrite
        self.directionUp = directionUp
        self.directionDown = directionDown
        self.updateEvent = updateEvent
        self.repetitionWrite = repetitionWrite
        self.updateHalfComplete = updateHalfComplete
        self.error = error
        self.inputCapture = inputCapture
        self.inputCaptureHalfComplete = inputCaptureHalfComplete
        self.overCapture = overCapture
    }
    public func callback(_ id: LPTIMCallbackID) -> LPTIMCallback {
        switch id {
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        case .compareMatch: return compareMatch
        case .autoReloadMatch: return autoReloadMatch
        case .trigger: return trigger
        case .compareWrite: return compareWrite
        case .autoReloadWrite: return autoReloadWrite
        case .directionUp: return directionUp
        case .directionDown: return directionDown
        case .updateEvent: return updateEvent
        case .repetitionWrite: return repetitionWrite
        case .updateHalfComplete: return updateHalfComplete
        case .error: return error
        case .inputCapture: return inputCapture
        case .inputCaptureHalfComplete: return inputCaptureHalfComplete
        case .overCapture: return overCapture
        }
    }
}
extension LPTIM {
    @discardableResult
    public func registerCallback(id: UInt32, callback: LPTIMCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { return .error }
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && id <= 1),
           let id = LPTIMCallbackID(rawValue: id) {
            callbacks.write(id, value: callback); return .ok
        }
        return .error
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && id <= 1),
           let id = LPTIMCallbackID(rawValue: id) {
            callbacks.write(id, value: defaults.callback(id)); return .ok
        }
        return .error
    }
    @discardableResult
    public func registerCallback(id: LPTIMCallbackID, callback: LPTIMCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }
    @discardableResult
    public func unregisterCallback(id: LPTIMCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    func invoke(_ id: LPTIMCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func prepareMSPCallback(_ id: LPTIMCallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
}
