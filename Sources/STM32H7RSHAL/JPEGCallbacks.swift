// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// JPEG operations and definitions from stm32h7rsxx_hal_jpeg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias JPEGCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias JPEGInfoReadyCallback = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutablePointer<UInt32>?) -> Void
public typealias JPEGGetDataCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public typealias JPEGDataReadyCallback = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutablePointer<UInt8>?, UInt32) -> Void
public enum JPEGCallbackID: UInt32, CaseIterable, Sendable { case encodeComplete = 1, decodeComplete, error, mspInitialize, mspDeinitialize }
public protocol JPEGCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: JPEGCallbackID) -> JPEGCallback?
    func write(_ id: JPEGCallbackID, value: JPEGCallback?)
    func readInfoReady() -> JPEGInfoReadyCallback?
    func writeInfoReady(_ value: JPEGInfoReadyCallback?)
    func readGetData() -> JPEGGetDataCallback?
    func writeGetData(_ value: JPEGGetDataCallback?)
    func readDataReady() -> JPEGDataReadyCallback?
    func writeDataReady(_ value: JPEGDataReadyCallback?)
}
public struct JPEGCallbackDefaults {
    public var encodeComplete: JPEGCallback
    public var decodeComplete: JPEGCallback
    public var error: JPEGCallback
    public var mspInitialize: JPEGCallback
    public var mspDeinitialize: JPEGCallback
    public var infoReady: JPEGInfoReadyCallback
    public var getData: JPEGGetDataCallback
    public var dataReady: JPEGDataReadyCallback
    public init(encodeComplete: @escaping JPEGCallback = { _ in }, decodeComplete: @escaping JPEGCallback = { _ in }, error: @escaping JPEGCallback = { _ in }, mspInitialize: @escaping JPEGCallback = { _ in }, mspDeinitialize: @escaping JPEGCallback = { _ in }, infoReady: @escaping JPEGInfoReadyCallback = { _, _ in }, getData: @escaping JPEGGetDataCallback = { _, _ in }, dataReady: @escaping JPEGDataReadyCallback = { _, _, _ in }) {
        self.encodeComplete = encodeComplete
        self.decodeComplete = decodeComplete
        self.error = error
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
        self.infoReady = infoReady
        self.getData = getData
        self.dataReady = dataReady
    }
    public func callback(_ id: JPEGCallbackID) -> JPEGCallback {
        switch id {
        case .encodeComplete: return encodeComplete
        case .decodeComplete: return decodeComplete
        case .error: return error
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        }
    }
}
extension JPEG {
    func lock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1); return true
    }
    func unlock() { handle.write(.lock, value: 0) }
    func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
    func modifyContext(clear: UInt32 = 0, set: UInt32 = 0) { handle.write(.context, value: (handle.read(.context) & ~clear) | set) }
    func modify(_ register: JPEGRegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    func invoke(_ id: JPEGCallbackID) {
        (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
    }
    func invokeInfoReady() {
        (useRegisteredCallbacks ? callbacks.readInfoReady()! : defaults.infoReady)(callbacks.context, handle.configurationPointer)
    }
    func invokeGetData() {
        (useRegisteredCallbacks ? callbacks.readGetData()! : defaults.getData)(callbacks.context, handle.read(.inputCount))
    }
    func invokeDataReady() {
        (useRegisteredCallbacks ? callbacks.readDataReady()! : defaults.dataReady)(callbacks.context, handle.readBuffer(.output), handle.read(.outputCount))
    }
    func prepareMSP(_ id: JPEGCallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
    func validCallbackID(_ id: UInt32) -> Bool {
        if handle.read(.state) == 1 { return JPEGCallbackID(rawValue: id) != nil }
        else if handle.read(.state) == 0 { return id == 4 || id == 5 }
        return false
    }
    @discardableResult
    public func registerCallback(id: UInt32, callback: JPEGCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(16); return .error }
        guard lock() else { return .busy }
        var status = HALStatus.ok
        if validCallbackID(id) { callbacks.write(.init(rawValue: id)!, value: callback) }
        else { addError(16); status = .error }
        unlock(); return status
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard lock() else { return .busy }
        var status = HALStatus.ok
        if validCallbackID(id) { callbacks.write(.init(rawValue: id)!, value: defaults.callback(.init(rawValue: id)!)) }
        else { addError(16); status = .error }
        unlock(); return status
    }
    @discardableResult
    public func registerInfoReadyCallback(_ callback: JPEGInfoReadyCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(16); return .error }
        guard lock() else { return .busy }
        var status = HALStatus.ok
        if handle.read(.state) == 1 { callbacks.writeInfoReady(callback) }
        else { addError(16); status = .error }
        unlock(); return status
    }
    @discardableResult
    public func unregisterInfoReadyCallback() -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard lock() else { return .busy }
        var status = HALStatus.ok
        if handle.read(.state) == 1 { callbacks.writeInfoReady(defaults.infoReady) }
        else { addError(16); status = .error }
        unlock(); return status
    }
    @discardableResult
    public func registerGetDataCallback(_ callback: JPEGGetDataCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(16); return .error }
        guard lock() else { return .busy }
        var status = HALStatus.ok
        if handle.read(.state) == 1 { callbacks.writeGetData(callback) }
        else { addError(16); status = .error }
        unlock(); return status
    }
    @discardableResult
    public func unregisterGetDataCallback() -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard lock() else { return .busy }
        var status = HALStatus.ok
        if handle.read(.state) == 1 { callbacks.writeGetData(defaults.getData) }
        else { addError(16); status = .error }
        unlock(); return status
    }
    @discardableResult
    public func registerDataReadyCallback(_ callback: JPEGDataReadyCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(16); return .error }
        guard lock() else { return .busy }
        var status = HALStatus.ok
        if handle.read(.state) == 1 { callbacks.writeDataReady(callback) }
        else { addError(16); status = .error }
        unlock(); return status
    }
    @discardableResult
    public func unregisterDataReadyCallback() -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard lock() else { return .busy }
        var status = HALStatus.ok
        if handle.read(.state) == 1 { callbacks.writeDataReady(defaults.dataReady) }
        else { addError(16); status = .error }
        unlock(); return status
    }
}
