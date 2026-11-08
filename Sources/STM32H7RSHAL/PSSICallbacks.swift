// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PSSI operations and definitions from stm32h7rsxx_hal_pssi.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias PSSICallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum PSSICallbackID: UInt32, CaseIterable, Sendable {
    case transmitComplete = 0, receiveComplete = 1, error = 3, abortComplete = 4, mspInitialize = 5, mspDeinitialize = 6
}
public protocol PSSICallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: PSSICallbackID) -> PSSICallback?
    func write(_ id: PSSICallbackID, value: PSSICallback?)
}
public struct PSSICallbackDefaults {
    public var mspInitialize: PSSICallback
    public var mspDeinitialize: PSSICallback
    public var transmitComplete: PSSICallback
    public var receiveComplete: PSSICallback
    public var error: PSSICallback
    public var abortComplete: PSSICallback
    public init(mspInitialize: @escaping PSSICallback = { _ in },
                mspDeinitialize: @escaping PSSICallback = { _ in },
                transmitComplete: @escaping PSSICallback = { _ in },
                receiveComplete: @escaping PSSICallback = { _ in },
                error: @escaping PSSICallback = { _ in },
                abortComplete: @escaping PSSICallback = { _ in }) {
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
        self.transmitComplete = transmitComplete
        self.receiveComplete = receiveComplete
        self.error = error
        self.abortComplete = abortComplete
    }
    public func callback(_ id: PSSICallbackID) -> PSSICallback {
        switch id {
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        case .transmitComplete: return transmitComplete
        case .receiveComplete: return receiveComplete
        case .error: return error
        case .abortComplete: return abortComplete
        }
    }
}
extension PSSI {
    @discardableResult
    public func registerCallback(id: UInt32, callback: PSSICallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(0x20); return .error }
        var result = HALStatus.ok
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && (id == 5 || id == 6)),
           let id = PSSICallbackID(rawValue: id) { callbacks.write(id, value: callback) }
        else { addError(0x20); result = .error }
        return result
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        var result = HALStatus.ok
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && (id == 5 || id == 6)),
           let id = PSSICallbackID(rawValue: id) { callbacks.write(id, value: defaults.callback(id)) }
        else { addError(0x20); result = .error }
        return result
    }
    @discardableResult
    public func registerCallback(id: PSSICallbackID, callback: PSSICallback?) -> HALStatus { registerCallback(id: id.rawValue, callback: callback) }
    @discardableResult
    public func unregisterCallback(id: PSSICallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    func invoke(_ id: PSSICallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func prepareMSPCallback(_ id: PSSICallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
}
