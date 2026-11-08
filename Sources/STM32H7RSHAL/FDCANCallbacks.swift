// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FDCAN operations and definitions from stm32h7rsxx_hal_fdcan.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// The second argument is zero for common callbacks and contains the original event mask otherwise.
public typealias FDCANCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public enum FDCANCallbackID: UInt32, CaseIterable, Sendable {
    case txFifoEmpty = 0
    case highPriorityMessage = 1
    case timestampWraparound = 2
    case timeoutOccurred = 3
    case error = 4
    case mspInit = 5
    case mspDeinit = 6
    case txEventFifo = 7
    case rxFifo0 = 8
    case rxFifo1 = 9
    case txBufferComplete = 10
    case txBufferAbort = 11
    case errorStatus = 12
}
public protocol FDCANCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: FDCANCallbackID) -> FDCANCallback?
    func write(_ id: FDCANCallbackID, value: FDCANCallback?)
}
public struct FDCANDefaultCallbacks {
    public var txFifoEmpty: FDCANCallback?
    public var highPriorityMessage: FDCANCallback?
    public var timestampWraparound: FDCANCallback?
    public var timeoutOccurred: FDCANCallback?
    public var error: FDCANCallback?
    public var mspInit: FDCANCallback?
    public var mspDeinit: FDCANCallback?
    public var txEventFifo: FDCANCallback?
    public var rxFifo0: FDCANCallback?
    public var rxFifo1: FDCANCallback?
    public var txBufferComplete: FDCANCallback?
    public var txBufferAbort: FDCANCallback?
    public var errorStatus: FDCANCallback?
    public init(txFifoEmpty: FDCANCallback? = nil, highPriorityMessage: FDCANCallback? = nil, timestampWraparound: FDCANCallback? = nil, timeoutOccurred: FDCANCallback? = nil, error: FDCANCallback? = nil, mspInit: FDCANCallback? = nil, mspDeinit: FDCANCallback? = nil, txEventFifo: FDCANCallback? = nil, rxFifo0: FDCANCallback? = nil, rxFifo1: FDCANCallback? = nil, txBufferComplete: FDCANCallback? = nil, txBufferAbort: FDCANCallback? = nil, errorStatus: FDCANCallback? = nil) {
        self.txFifoEmpty = txFifoEmpty
        self.highPriorityMessage = highPriorityMessage
        self.timestampWraparound = timestampWraparound
        self.timeoutOccurred = timeoutOccurred
        self.error = error
        self.mspInit = mspInit
        self.mspDeinit = mspDeinit
        self.txEventFifo = txEventFifo
        self.rxFifo0 = rxFifo0
        self.rxFifo1 = rxFifo1
        self.txBufferComplete = txBufferComplete
        self.txBufferAbort = txBufferAbort
        self.errorStatus = errorStatus
    }
    func callback(_ id: FDCANCallbackID) -> FDCANCallback? {
        switch id {
        case .txFifoEmpty: return txFifoEmpty
        case .highPriorityMessage: return highPriorityMessage
        case .timestampWraparound: return timestampWraparound
        case .timeoutOccurred: return timeoutOccurred
        case .error: return error
        case .mspInit: return mspInit
        case .mspDeinit: return mspDeinit
        case .txEventFifo: return txEventFifo
        case .rxFifo0: return rxFifo0
        case .rxFifo1: return rxFifo1
        case .txBufferComplete: return txBufferComplete
        case .txBufferAbort: return txBufferAbort
        case .errorStatus: return errorStatus
        }
    }
}
extension FDCAN {
    func invoke(_ id: FDCANCallbackID, _ argument: UInt32 = 0) {
        if useRegisteredCallbacks { callbacks.read(id)?(callbacks.context, argument) }
        else { defaults.callback(id)?(callbacks.context, argument) }
    }
    public func resetHandleState() {
        handle.write(.state, value: FD.HAL_FDCAN_STATE_RESET)
        if useRegisteredCallbacks { callbacks.write(.mspInit, value: nil); callbacks.write(.mspDeinit, value: nil) }
    }
    @discardableResult
    public func registerCallback(_ id: FDCANCallbackID, callback: FDCANCallback?) -> HALStatus {
        guard let callback else { return fail(FD.HAL_FDCAN_ERROR_INVALID_CALLBACK) }
        if getState() == FD.HAL_FDCAN_STATE_READY {
            if id.rawValue <= 6 { callbacks.write(id, value: callback); return .ok }
        } else if getState() == FD.HAL_FDCAN_STATE_RESET {
            if id == .mspInit || id == .mspDeinit { callbacks.write(id, value: callback); return .ok }
        }
        return fail(FD.HAL_FDCAN_ERROR_INVALID_CALLBACK)
    }
    @discardableResult
    public func unregisterCallback(_ id: FDCANCallbackID) -> HALStatus {
        if getState() == FD.HAL_FDCAN_STATE_READY {
            if id.rawValue <= 6 { callbacks.write(id, value: defaults.callback(id)); return .ok }
        } else if getState() == FD.HAL_FDCAN_STATE_RESET {
            if id == .mspInit || id == .mspDeinit { callbacks.write(id, value: defaults.callback(id)); return .ok }
        }
        return fail(FD.HAL_FDCAN_ERROR_INVALID_CALLBACK)
    }
    func registerEventCallback(_ id: FDCANCallbackID, callback: FDCANCallback?) -> HALStatus {
        guard let callback else { return fail(FD.HAL_FDCAN_ERROR_INVALID_CALLBACK) }
        if getState() == FD.HAL_FDCAN_STATE_READY { callbacks.write(id, value: callback); return .ok }
        return fail(FD.HAL_FDCAN_ERROR_INVALID_CALLBACK)
    }
    func unregisterEventCallback(_ id: FDCANCallbackID) -> HALStatus {
        if getState() == FD.HAL_FDCAN_STATE_READY { callbacks.write(id, value: defaults.callback(id)); return .ok }
        return fail(FD.HAL_FDCAN_ERROR_INVALID_CALLBACK)
    }
    @discardableResult public func registerTxEventFifoCallback(_ callback: FDCANCallback?) -> HALStatus { registerEventCallback(.txEventFifo, callback: callback) }
    @discardableResult public func unregisterTxEventFifoCallback() -> HALStatus { unregisterEventCallback(.txEventFifo) }
    @discardableResult public func registerRxFifo0Callback(_ callback: FDCANCallback?) -> HALStatus { registerEventCallback(.rxFifo0, callback: callback) }
    @discardableResult public func unregisterRxFifo0Callback() -> HALStatus { unregisterEventCallback(.rxFifo0) }
    @discardableResult public func registerRxFifo1Callback(_ callback: FDCANCallback?) -> HALStatus { registerEventCallback(.rxFifo1, callback: callback) }
    @discardableResult public func unregisterRxFifo1Callback() -> HALStatus { unregisterEventCallback(.rxFifo1) }
    @discardableResult public func registerTxBufferCompleteCallback(_ callback: FDCANCallback?) -> HALStatus { registerEventCallback(.txBufferComplete, callback: callback) }
    @discardableResult public func unregisterTxBufferCompleteCallback() -> HALStatus { unregisterEventCallback(.txBufferComplete) }
    @discardableResult public func registerTxBufferAbortCallback(_ callback: FDCANCallback?) -> HALStatus { registerEventCallback(.txBufferAbort, callback: callback) }
    @discardableResult public func unregisterTxBufferAbortCallback() -> HALStatus { unregisterEventCallback(.txBufferAbort) }
    @discardableResult public func registerErrorStatusCallback(_ callback: FDCANCallback?) -> HALStatus { registerEventCallback(.errorStatus, callback: callback) }
    @discardableResult public func unregisterErrorStatusCallback() -> HALStatus { unregisterEventCallback(.errorStatus) }
}
