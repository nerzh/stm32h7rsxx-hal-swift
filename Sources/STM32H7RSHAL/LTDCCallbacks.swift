// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LTDC operations and definitions from stm32h7rsxx_hal_ltdc.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias LTDCCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum LTDCCallbackID: UInt32, CaseIterable, Sendable {
    case mspInitialize = 0
    case mspDeinitialize = 1
    case lineEvent = 2
    case reloadEvent = 3
    case error = 4
}
public protocol LTDCCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: LTDCCallbackID) -> LTDCCallback?
    func write(_ id: LTDCCallbackID, value: LTDCCallback?)
}
public struct LTDCCallbackDefaults {
    public var mspInitialize: LTDCCallback
    public var mspDeinitialize: LTDCCallback
    public var lineEvent: LTDCCallback
    public var error: LTDCCallback
    public var reloadEvent: LTDCCallback
    public init(mspInitialize: @escaping LTDCCallback = { _ in },
                mspDeinitialize: @escaping LTDCCallback = { _ in },
                lineEvent: @escaping LTDCCallback = { _ in },
                error: @escaping LTDCCallback = { _ in },
                reloadEvent: @escaping LTDCCallback = { _ in }) {
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
        self.lineEvent = lineEvent
        self.error = error
        self.reloadEvent = reloadEvent
    }
    public func callback(_ id: LTDCCallbackID) -> LTDCCallback? {
        switch id {
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        case .lineEvent: return lineEvent
        case .reloadEvent: return reloadEvent
        case .error: return error
        }
    }
}

extension LTDC {
    @discardableResult
    public func registerCallback(id: UInt32, callback: LTDCCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(0x40); return .error }
        return updateCallback(id: id, callback: callback, useDefault: false)
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        return updateCallback(id: id, callback: nil, useDefault: true)
    }
    @discardableResult
    public func registerCallback(id: LTDCCallbackID, callback: LTDCCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }
    @discardableResult
    public func unregisterCallback(id: LTDCCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    private func updateCallback(id: UInt32, callback: LTDCCallback?, useDefault: Bool) -> HALStatus {
        if !lock() { return .busy }
        let valid: Bool
        if handle.read(.state) == 1 { valid = id <= 4 }
        else if handle.read(.state) == 0 { valid = id <= 1 }
        else { valid = false }
        let status: HALStatus
        if valid, let id = LTDCCallbackID(rawValue: id) {
            callbacks.write(id, value: useDefault ? defaults.callback(id) : callback)
            status = .ok
        } else { addError(0x40); status = .error }
        handle.write(.lock, value: 0)
        return status
    }
}
