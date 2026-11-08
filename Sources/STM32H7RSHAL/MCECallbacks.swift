// Copyright (c) 2024 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MCE operations and definitions from stm32h7rsxx_hal_mce.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias MCECallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum MCECallbackID: UInt32, CaseIterable, Sendable { case error = 0, mspInitialize = 1, mspDeinitialize = 2 }
public protocol MCECallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: MCECallbackID) -> MCECallback?
    func write(_ id: MCECallbackID, value: MCECallback?)
}
public struct MCECallbackDefaults {
    public var error: MCECallback
    public var mspInitialize: MCECallback
    public var mspDeinitialize: MCECallback
    public init(error: @escaping MCECallback = { _ in }, mspInitialize: @escaping MCECallback = { _ in },
                mspDeinitialize: @escaping MCECallback = { _ in }) {
        self.error = error; self.mspInitialize = mspInitialize; self.mspDeinitialize = mspDeinitialize
    }
    public func callback(_ id: MCECallbackID) -> MCECallback {
        switch id { case .error: return error; case .mspInitialize: return mspInitialize; case .mspDeinitialize: return mspDeinitialize }
    }
}
extension MCE {
    func invoke(_ id: MCECallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func prepareMSPCallback(_ id: MCECallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
}
