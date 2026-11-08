// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDIOS operations and definitions from stm32h7rsxx_hal_mdios.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias MDIOSCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum MDIOSCallbackID: UInt32, CaseIterable, Sendable {
    case mspInitialize = 0
    case mspDeinitialize = 1
    case writeComplete = 2
    case readComplete = 3
    case error = 4
    case wakeup = 5
}
public protocol MDIOSCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: MDIOSCallbackID) -> MDIOSCallback?
    func write(_ id: MDIOSCallbackID, value: MDIOSCallback?)
}
public struct MDIOSCallbackDefaults {
    public var mspInitialize: MDIOSCallback
    public var mspDeinitialize: MDIOSCallback
    public var writeComplete: MDIOSCallback
    public var readComplete: MDIOSCallback
    public var error: MDIOSCallback
    public var wakeup: MDIOSCallback
    public init(mspInitialize: @escaping MDIOSCallback = { _ in },
                mspDeinitialize: @escaping MDIOSCallback = { _ in },
                writeComplete: @escaping MDIOSCallback = { _ in },
                readComplete: @escaping MDIOSCallback = { _ in },
                error: @escaping MDIOSCallback = { _ in },
                wakeup: @escaping MDIOSCallback = { _ in }) {
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
        self.writeComplete = writeComplete
        self.readComplete = readComplete
        self.error = error
        self.wakeup = wakeup
    }
    public func callback(_ id: MDIOSCallbackID) -> MDIOSCallback {
        switch id {
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        case .writeComplete: return writeComplete
        case .readComplete: return readComplete
        case .error: return error
        case .wakeup: return wakeup
        }
    }
}
extension MDIOS {
    @discardableResult
    public func registerCallback(id: UInt32, callback: MDIOSCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(0x20); return .error }
        guard lock() else { return .busy }
        var result = HALStatus.ok
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && id <= 1),
           let id = MDIOSCallbackID(rawValue: id) { callbacks.write(id, value: callback) }
        else { addError(0x20); result = .error }
        unlock(); return result
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard lock() else { return .busy }
        var result = HALStatus.ok
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && id <= 1),
           let id = MDIOSCallbackID(rawValue: id) { callbacks.write(id, value: defaults.callback(id)) }
        else { addError(0x20); result = .error }
        unlock(); return result
    }
    @discardableResult
    public func registerCallback(id: MDIOSCallbackID, callback: MDIOSCallback?) -> HALStatus { registerCallback(id: id.rawValue, callback: callback) }
    @discardableResult
    public func unregisterCallback(id: MDIOSCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    func invoke(_ id: MDIOSCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func prepareMSPCallback(_ id: MDIOSCallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
}
