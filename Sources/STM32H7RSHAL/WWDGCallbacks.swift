// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Callback registration from stm32h7rsxx_hal_wwdg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias WWDGCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum WWDGCallbackID: UInt32, CaseIterable { case earlyWakeup = 0, mspInitialize = 1 }

// Two caller-owned function-pointer slots, initially nil. The context and slots
// must outlive every foreground/IRQ wrapper that accesses them.
public protocol WWDGCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: WWDGCallbackID) -> WWDGCallback?
    func write(_ id: WWDGCallbackID, value: WWDGCallback?)
}

public struct WWDGCallbackDefaults {
    public let earlyWakeup: WWDGCallback
    public let mspInitialize: WWDGCallback

    public init(earlyWakeup: @escaping WWDGCallback = { _ in },
                mspInitialize: @escaping WWDGCallback = { _ in }) {
        self.earlyWakeup = earlyWakeup
        self.mspInitialize = mspInitialize
    }
}

// USE_HAL_WWDG_REGISTER_CALLBACKS=1. As in C, registration has no state
// restrictions or lock, and initialization preserves existing callback pointers.
public struct WWDGRegistered<Registers: WWDGRegisterIO, Configuration: WWDGConfigurationIO, Callbacks: WWDGCallbackIO> {
    public let core: WWDG<Registers, Configuration>
    public let callbacks: Callbacks
    public let defaults: WWDGCallbackDefaults

    public init(core: WWDG<Registers, Configuration>, callbacks: Callbacks,
                defaults: WWDGCallbackDefaults = .init()) {
        self.core = core
        self.callbacks = callbacks
        self.defaults = defaults
    }

    @discardableResult
    public func initialize() -> HALStatus {
        core.initialize() { _ in
            if callbacks.read(.earlyWakeup) == nil { callbacks.write(.earlyWakeup, value: defaults.earlyWakeup) }
            if callbacks.read(.mspInitialize) == nil { callbacks.write(.mspInitialize, value: defaults.mspInitialize) }
            callbacks.read(.mspInitialize)!(callbacks.context)
        }
    }

    @discardableResult
    public func registerCallback(id: UInt32, callback: WWDGCallback?) -> HALStatus {
        guard let callback, let id = WWDGCallbackID(rawValue: id) else { return .error }
        callbacks.write(id, value: callback)
        return .ok
    }

    @discardableResult
    public func registerCallback(id: WWDGCallbackID, callback: WWDGCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }

    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        guard let id = WWDGCallbackID(rawValue: id) else { return .error }
        callbacks.write(id, value: id == .earlyWakeup ? defaults.earlyWakeup : defaults.mspInitialize)
        return .ok
    }

    @discardableResult
    public func unregisterCallback(id: WWDGCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    @discardableResult
    public func refresh() -> HALStatus { core.refresh() }

    public func handleInterrupt() {
        core.handleInterrupt { _ in callbacks.read(.earlyWakeup)!(callbacks.context) }
    }
}
