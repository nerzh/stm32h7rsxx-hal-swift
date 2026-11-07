// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DCMIPP operations and definitions from stm32h7rsxx_hal_dcmipp.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias DCMIPPCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias DCMIPPPipeCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public enum DCMIPPCallbackID: UInt32, CaseIterable, Sendable {
    case mspInitialize = 0
    case mspDeinitialize = 1
    case error = 2
}
public enum DCMIPPPipeCallbackID: UInt32, CaseIterable, Sendable {
    case limit = 1
    case line = 2
    case frame = 3
    case vsync = 4
    case error = 5
}
public protocol DCMIPPCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: DCMIPPCallbackID) -> DCMIPPCallback?
    func write(_ id: DCMIPPCallbackID, value: DCMIPPCallback?)
    func read(_ id: DCMIPPPipeCallbackID) -> DCMIPPPipeCallback?
    func write(_ id: DCMIPPPipeCallbackID, value: DCMIPPPipeCallback?)
}
public struct DCMIPPCallbackDefaults {
    public var mspInitialize: DCMIPPCallback
    public var mspDeinitialize: DCMIPPCallback
    public var error: DCMIPPCallback
    public var pipeLimit: DCMIPPPipeCallback
    public var pipeLine: DCMIPPPipeCallback
    public var pipeFrame: DCMIPPPipeCallback
    public var pipeVsync: DCMIPPPipeCallback
    public var pipeError: DCMIPPPipeCallback
    public init(mspInitialize: @escaping DCMIPPCallback = { _ in },
                mspDeinitialize: @escaping DCMIPPCallback = { _ in },
                error: @escaping DCMIPPCallback = { _ in },
                pipeLimit: @escaping DCMIPPPipeCallback = { _, _ in },
                pipeLine: @escaping DCMIPPPipeCallback = { _, _ in },
                pipeFrame: @escaping DCMIPPPipeCallback = { _, _ in },
                pipeVsync: @escaping DCMIPPPipeCallback = { _, _ in },
                pipeError: @escaping DCMIPPPipeCallback = { _, _ in }) {
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
        self.error = error
        self.pipeLimit = pipeLimit
        self.pipeLine = pipeLine
        self.pipeFrame = pipeFrame
        self.pipeVsync = pipeVsync
        self.pipeError = pipeError
    }
    public func callback(_ id: DCMIPPCallbackID) -> DCMIPPCallback {
        switch id {
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        case .error: return error
        }
    }
    public func callback(_ id: DCMIPPPipeCallbackID) -> DCMIPPPipeCallback {
        switch id {
        case .limit: return pipeLimit
        case .line: return pipeLine
        case .frame: return pipeFrame
        case .vsync: return pipeVsync
        case .error: return pipeError
        }
    }
}

extension DCMIPP {
    @discardableResult
    public func registerCallback(id: UInt32, callback: DCMIPPCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(0x40); return .error }
        let valid: Bool
        if handle.read(.state) == 2 { valid = id <= 2 }
        else if handle.read(.state) == 0 { valid = id <= 1 }
        else { valid = false }
        if valid, let id = DCMIPPCallbackID(rawValue: id) { callbacks.write(id, value: callback); return .ok }
        addError(0x40); return .error
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        // The C unregister switch omits ErrorCallback even in READY state.
        if (handle.read(.state) == 2 || handle.read(.state) == 0) && id <= 1 {
            let id = DCMIPPCallbackID(rawValue: id)!
            callbacks.write(id, value: defaults.callback(id)); return .ok
        }
        addError(0x40); return .error
    }
    @discardableResult
    public func registerPipeCallback(id: UInt32, callback: DCMIPPPipeCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(0x40); return .error }
        if handle.read(.state) == 2, let id = DCMIPPPipeCallbackID(rawValue: id) {
            callbacks.write(id, value: callback); return .ok
        }
        addError(0x40); return .error
    }
    @discardableResult
    public func unregisterPipeCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        if handle.read(.state) == 2, let id = DCMIPPPipeCallbackID(rawValue: id) {
            callbacks.write(id, value: defaults.callback(id)); return .ok
        }
        addError(0x40); return .error
    }
    @discardableResult
    public func registerCallback(id: DCMIPPCallbackID, callback: DCMIPPCallback?) -> HALStatus { registerCallback(id: id.rawValue, callback: callback) }
    @discardableResult
    public func unregisterCallback(id: DCMIPPCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    @discardableResult
    public func registerPipeCallback(id: DCMIPPPipeCallbackID, callback: DCMIPPPipeCallback?) -> HALStatus { registerPipeCallback(id: id.rawValue, callback: callback) }
    @discardableResult
    public func unregisterPipeCallback(id: DCMIPPPipeCallbackID) -> HALStatus { unregisterPipeCallback(id: id.rawValue) }
    func invoke(_ id: DCMIPPCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func invokePipe(_ id: DCMIPPPipeCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context, 0) }
        else { defaults.callback(id)(callbacks.context, 0) }
    }
}
