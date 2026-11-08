// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CEC operations and definitions from stm32h7rsxx_hal_cec.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias CECCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias CECReceiveCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public enum CECCallbackID: UInt32, CaseIterable, Sendable {
    case transmitComplete = 0, receiveComplete = 1, error = 2, mspInitialize = 3, mspDeinitialize = 4
}
public protocol CECCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: CECCallbackID) -> CECCallback?
    func write(_ id: CECCallbackID, value: CECCallback?)
    func readReceive() -> CECReceiveCallback?
    func writeReceive(_ value: CECReceiveCallback?)
}
public struct CECCallbackDefaults {
    public var transmitComplete: CECCallback
    public var receiveComplete: CECReceiveCallback
    public var error: CECCallback
    public var mspInitialize: CECCallback
    public var mspDeinitialize: CECCallback
    public init(transmitComplete: @escaping CECCallback = { _ in },
                receiveComplete: @escaping CECReceiveCallback = { _, _ in },
                error: @escaping CECCallback = { _ in },
                mspInitialize: @escaping CECCallback = { _ in },
                mspDeinitialize: @escaping CECCallback = { _ in }) {
        self.transmitComplete = transmitComplete; self.receiveComplete = receiveComplete; self.error = error
        self.mspInitialize = mspInitialize; self.mspDeinitialize = mspDeinitialize
    }
    public func callback(_ id: CECCallbackID) -> CECCallback {
        switch id {
        case .transmitComplete: return transmitComplete
        case .error: return error
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        case .receiveComplete: preconditionFailure("Use the receive callback signature")
        }
    }
}
extension CEC {
    @discardableResult
    public func registerCallback(id: UInt32, callback: CECCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(0x2000); return .error }
        guard lock() else { return .busy }
        var result = HALStatus.ok
        let ready = handle.read(.globalState) == 0x20
        if ready || (handle.read(.globalState) == 0 && (id == 3 || id == 4)),
           let id = CECCallbackID(rawValue: id), id != .receiveComplete { callbacks.write(id, value: callback) }
        else { addError(0x2000); result = .error }
        unlock(); return result
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard lock() else { return .busy }
        var result = HALStatus.ok
        let ready = handle.read(.globalState) == 0x20
        if ready || (handle.read(.globalState) == 0 && (id == 3 || id == 4)),
           let id = CECCallbackID(rawValue: id), id != .receiveComplete { callbacks.write(id, value: defaults.callback(id)) }
        else { addError(0x2000); result = .error }
        unlock(); return result
    }
    @discardableResult
    public func registerCallback(id: CECCallbackID, callback: CECCallback?) -> HALStatus { registerCallback(id: id.rawValue, callback: callback) }
    @discardableResult
    public func unregisterCallback(id: CECCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    @discardableResult
    public func registerReceiveCallback(_ callback: CECReceiveCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(0x2000); return .error }
        guard lock() else { return .busy }
        var result = HALStatus.ok
        if handle.read(.receiveState) == 0x20 { callbacks.writeReceive(callback) }
        else { addError(0x2000); result = .error }
        unlock(); return result
    }
    @discardableResult
    public func unregisterReceiveCallback() -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard lock() else { return .busy }
        var result = HALStatus.ok
        if handle.read(.receiveState) == 0x20 { callbacks.writeReceive(defaults.receiveComplete) }
        else { addError(0x2000); result = .error }
        unlock(); return result
    }
    func invoke(_ id: CECCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func invokeReceive(_ count: UInt32) {
        if useRegisteredCallbacks { callbacks.readReceive()!(callbacks.context, count) }
        else { defaults.receiveComplete(callbacks.context, count) }
    }
    func prepareMSPCallback(_ id: CECCallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
}
