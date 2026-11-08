// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPDIFRX operations and definitions from stm32h7rsxx_hal_spdifrx.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias SPDIFRXCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum SPDIFRXCallbackID: UInt32, CaseIterable, Sendable {
    case receiveHalf = 0
    case receiveComplete = 1
    case controlHalf = 2
    case controlComplete = 3
    case error = 4
    case mspInitialize = 5
    case mspDeinitialize = 6
}
public protocol SPDIFRXCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: SPDIFRXCallbackID) -> SPDIFRXCallback?
    func write(_ id: SPDIFRXCallbackID, value: SPDIFRXCallback?)
}
public struct SPDIFRXCallbackDefaults {
    public var receiveHalf: SPDIFRXCallback
    public var receiveComplete: SPDIFRXCallback
    public var controlHalf: SPDIFRXCallback
    public var controlComplete: SPDIFRXCallback
    public var error: SPDIFRXCallback
    public var mspInitialize: SPDIFRXCallback
    public var mspDeinitialize: SPDIFRXCallback
    public init(receiveHalf: @escaping SPDIFRXCallback = { _ in }, receiveComplete: @escaping SPDIFRXCallback = { _ in }, controlHalf: @escaping SPDIFRXCallback = { _ in }, controlComplete: @escaping SPDIFRXCallback = { _ in }, error: @escaping SPDIFRXCallback = { _ in }, mspInitialize: @escaping SPDIFRXCallback = { _ in }, mspDeinitialize: @escaping SPDIFRXCallback = { _ in }) {
        self.receiveHalf = receiveHalf
        self.receiveComplete = receiveComplete
        self.controlHalf = controlHalf
        self.controlComplete = controlComplete
        self.error = error
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
    }
    public func callback(_ id: SPDIFRXCallbackID) -> SPDIFRXCallback {
        switch id {
        case .receiveHalf: return receiveHalf
        case .receiveComplete: return receiveComplete
        case .controlHalf: return controlHalf
        case .controlComplete: return controlComplete
        case .error: return error
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        }
    }
}
extension SPDIFRX {
    @discardableResult
    public func registerCallback(id: UInt32, callback: SPDIFRXCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(32); return .error }
        guard lock() else { return .busy }
        var result = HALStatus.ok
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && id >= 5), let id = SPDIFRXCallbackID(rawValue: id) { callbacks.write(id, value: callback) }
        else { addError(32); result = .error }
        unlock(); return result
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard lock() else { return .busy }
        var result = HALStatus.ok
        // Unlike RegisterCallback, C rejects MSP IDs while READY.
        let allowed: Bool
        if handle.read(.state) == 1 { allowed = id < 5 }
        else if handle.read(.state) == 0 { allowed = id >= 5 }
        else { allowed = false }
        if allowed, let id = SPDIFRXCallbackID(rawValue: id) { callbacks.write(id, value: defaults.callback(id)) }
        else { addError(32); result = .error }
        unlock(); return result
    }
    @discardableResult
    public func registerCallback(id: SPDIFRXCallbackID, callback: SPDIFRXCallback?) -> HALStatus { registerCallback(id: id.rawValue, callback: callback) }
    @discardableResult
    public func unregisterCallback(id: SPDIFRXCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    func invoke(_ id: SPDIFRXCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func prepareMSPCallback(_ id: SPDIFRXCallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
}
