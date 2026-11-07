// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Registered callback behavior from stm32h7rsxx_hal_ramecc.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias RAMECCCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum RAMECCCallbackID: UInt32, CaseIterable, Sendable {
    case mspInitialize = 0, mspDeinitialize = 1, singleError = 2, doubleError = 3, all = 4
}

// Four caller-owned thin C function pointers, initially nil, and a separate
// unowned context. IO copies must address the same volatile storage.
public protocol RAMECCCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: RAMECCCallbackID) -> RAMECCCallback?
    func write(_ id: RAMECCCallbackID, value: RAMECCCallback?)
}

public struct RAMECCRegistered<Registers: RAMECCRegisterIO, State: RAMECCStateIO, Callbacks: RAMECCCallbackIO> {
    public let core: RAMECC<Registers, State>
    public let callbacks: Callbacks
    public let defaultMSPInitialize: RAMECCCallback

    public init(core: RAMECC<Registers, State>, callbacks: Callbacks,
                defaultMSPInitialize: @escaping RAMECCCallback = { _ in }) {
        self.core = core
        self.callbacks = callbacks
        self.defaultMSPInitialize = defaultMSPInitialize
    }

    @discardableResult
    public func initialize() -> HALStatus {
        core.initialize { _ in
            if callbacks.read(.mspInitialize) == nil {
                callbacks.write(.mspInitialize, value: defaultMSPInitialize)
            }
            callbacks.read(.mspInitialize)!(callbacks.context)
        }
    }

    @discardableResult
    public func deinitialize() -> HALStatus {
        core.deinitialize { _ in
            if callbacks.read(.mspDeinitialize) != nil {
                callbacks.read(.mspDeinitialize)!(callbacks.context)
            }
            callbacks.write(.singleError, value: nil)
            callbacks.write(.doubleError, value: nil)
        }
    }

    @discardableResult
    public func registerCallback(id: UInt32, callback: RAMECCCallback?) -> HALStatus {
        guard let callback else {
            addInvalidCallbackError()
            return .error
        }
        if core.state.read(.state) == RAMECCState.ready.rawValue {
            if let id = RAMECCCallbackID(rawValue: id), id != .all {
                callbacks.write(id, value: callback)
                return .ok
            }
            addInvalidCallbackError()
        } else if core.state.read(.state) == RAMECCState.reset.rawValue {
            if let id = RAMECCCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize {
                callbacks.write(id, value: callback)
                return .ok
            }
            addInvalidCallbackError()
        } else { core.state.write(.errorCode, value: 3) }
        return .error
    }

    @discardableResult
    public func registerCallback(id: RAMECCCallbackID, callback: RAMECCCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }

    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        if core.state.read(.state) == RAMECCState.ready.rawValue {
            guard let id = RAMECCCallbackID(rawValue: id) else { return .error }
            if id == .all {
                callbacks.write(.singleError, value: nil)
                callbacks.write(.doubleError, value: nil)
                callbacks.write(.mspDeinitialize, value: nil)
                callbacks.write(.mspInitialize, value: nil)
            } else { callbacks.write(id, value: nil) }
            return .ok
        } else if core.state.read(.state) == RAMECCState.reset.rawValue {
            if id == RAMECCCallbackID.mspInitialize.rawValue || id == RAMECCCallbackID.mspDeinitialize.rawValue {
                callbacks.write(RAMECCCallbackID(rawValue: id)!, value: nil)
                return .ok
            }
            if id == RAMECCCallbackID.all.rawValue {
                callbacks.write(.mspDeinitialize, value: nil)
                callbacks.write(.mspInitialize, value: nil)
                return .ok
            }
            addInvalidCallbackError()
        } else { core.state.write(.errorCode, value: 3) }
        return .error
    }

    @discardableResult
    public func unregisterCallback(id: RAMECCCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }

    public func handleInterrupt() {
        core.handleInterrupt(singleError: { _ in invoke(.singleError) }, doubleError: { _ in invoke(.doubleError) })
    }

    @discardableResult public func startMonitor() -> HALStatus { core.startMonitor() }
    @discardableResult public func stopMonitor() -> HALStatus { core.stopMonitor() }
    @discardableResult public func enableNotification(_ value: RAMECCInterrupt) -> HALStatus { core.enableNotification(value) }
    @discardableResult public func disableNotification(_ value: RAMECCInterrupt) -> HALStatus { core.disableNotification(value) }
    public func getFailingAddress() -> UInt32 { core.getFailingAddress() }
    public func getFailingDataLow() -> UInt32 { core.getFailingDataLow() }
    public func getFailingDataHigh() -> UInt32 { core.getFailingDataHigh() }
    public func getHammingErrorCode() -> UInt32 { core.getHammingErrorCode() }
    public func isECCSingleErrorDetected() -> UInt32 { core.isECCSingleErrorDetected() }
    public func isECCDoubleErrorDetected() -> UInt32 { core.isECCDoubleErrorDetected() }
    public func getState() -> RAMECCState { core.getState() }
    public func getError() -> RAMECCError { core.getError() }
    public func resetHandleState() { core.resetHandleState() }

    private func invoke(_ id: RAMECCCallbackID) {
        if callbacks.read(id) != nil { callbacks.read(id)!(callbacks.context) }
    }
    private func addInvalidCallbackError() {
        core.state.write(.errorCode, value: core.state.read(.errorCode) | 3)
    }
}
