// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DMA2D operations and definitions from stm32h7rsxx_hal_dma2d.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias DMA2DCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum DMA2DCallbackID: UInt32, CaseIterable, Sendable {
    case mspInitialize = 0
    case mspDeinitialize = 1
    case transferComplete = 2
    case transferError = 3
    case lineEvent = 4
    case clutComplete = 5
}
// Transfer callbacks exist in both C callback modes and may be nil.
public protocol DMA2DCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: DMA2DCallbackID) -> DMA2DCallback?
    func write(_ id: DMA2DCallbackID, value: DMA2DCallback?)
}
public struct DMA2DCallbackDefaults {
    public var mspInitialize: DMA2DCallback
    public var mspDeinitialize: DMA2DCallback
    public var lineEvent: DMA2DCallback
    public var clutComplete: DMA2DCallback
    public init(mspInitialize: @escaping DMA2DCallback = { _ in },
                mspDeinitialize: @escaping DMA2DCallback = { _ in },
                lineEvent: @escaping DMA2DCallback = { _ in },
                clutComplete: @escaping DMA2DCallback = { _ in }) {
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
        self.lineEvent = lineEvent
        self.clutComplete = clutComplete
    }
    public func callback(_ id: DMA2DCallbackID) -> DMA2DCallback? {
        switch id {
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        case .lineEvent: return lineEvent
        case .clutComplete: return clutComplete
        case .transferComplete, .transferError: return nil
        }
    }
}

extension DMA2D {
    @discardableResult
    public func registerCallback(id: UInt32, callback: DMA2DCallback?) -> HALStatus {
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
    public func registerCallback(id: DMA2DCallbackID, callback: DMA2DCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }
    @discardableResult
    public func unregisterCallback(id: DMA2DCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    private func updateCallback(id: UInt32, callback: DMA2DCallback?, useDefault: Bool) -> HALStatus {
        if !lock() { return .busy }
        let valid: Bool
        if handle.read(.state) == 1 { valid = id <= 5 }
        else if handle.read(.state) == 0 { valid = id <= 1 }
        else { valid = false }
        let status: HALStatus
        if valid, let id = DMA2DCallbackID(rawValue: id) {
            callbacks.write(id, value: useDefault ? defaults.callback(id) : callback)
            status = .ok
        } else { addError(0x40); status = .error }
        handle.write(.lock, value: 0)
        return status
    }
}
