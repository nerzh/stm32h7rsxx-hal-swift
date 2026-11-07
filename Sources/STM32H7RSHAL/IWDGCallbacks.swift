// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Callback registration from stm32h7rsxx_hal_iwdg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias IWDGCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum IWDGCallbackID: UInt32, CaseIterable { case earlyWakeup = 0, mspInitialize = 1 }

// Two caller-owned function-pointer slots, initially nil. The context and slots
// must outlive every foreground/IRQ wrapper that accesses them.
public protocol IWDGCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: IWDGCallbackID) -> IWDGCallback?
    func write(_ id: IWDGCallbackID, value: IWDGCallback?)
}

public struct IWDGCallbackDefaults {
    public let earlyWakeup: IWDGCallback
    public let mspInitialize: IWDGCallback

    public init(earlyWakeup: @escaping IWDGCallback = { _ in },
                mspInitialize: @escaping IWDGCallback = { _ in }) {
        self.earlyWakeup = earlyWakeup
        self.mspInitialize = mspInitialize
    }
}

// USE_HAL_IWDG_REGISTER_CALLBACKS=1. As in C, registration has no state
// restrictions or lock, and initialization preserves existing callback pointers.
public struct IWDGRegistered<Registers: IWDGRegisterIO, Configuration: IWDGConfigurationIO, Callbacks: IWDGCallbackIO> {
    public let core: IWDG<Registers, Configuration>
    public let callbacks: Callbacks
    public let defaults: IWDGCallbackDefaults

    public init(core: IWDG<Registers, Configuration>, callbacks: Callbacks,
                defaults: IWDGCallbackDefaults = .init()) {
        self.core = core
        self.callbacks = callbacks
        self.defaults = defaults
    }

    @discardableResult
    public func initialize(getTick: () -> UInt32) -> HALStatus {
        core.initialize(getTick: getTick) { _ in
            if callbacks.read(.earlyWakeup) == nil { callbacks.write(.earlyWakeup, value: defaults.earlyWakeup) }
            if callbacks.read(.mspInitialize) == nil { callbacks.write(.mspInitialize, value: defaults.mspInitialize) }
            callbacks.read(.mspInitialize)!(callbacks.context)
        }
    }

    @discardableResult
    public func registerCallback(id: UInt32, callback: IWDGCallback?) -> HALStatus {
        guard let callback, let id = IWDGCallbackID(rawValue: id) else { return .error }
        callbacks.write(id, value: callback)
        return .ok
    }

    @discardableResult
    public func registerCallback(id: IWDGCallbackID, callback: IWDGCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }

    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        guard let id = IWDGCallbackID(rawValue: id) else { return .error }
        callbacks.write(id, value: id == .earlyWakeup ? defaults.earlyWakeup : defaults.mspInitialize)
        return .ok
    }

    @discardableResult
    public func unregisterCallback(id: IWDGCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    @discardableResult
    public func refresh() -> HALStatus { core.refresh() }
    public func getActiveStatus() -> UInt32 { core.getActiveStatus() }
    public func handleInterrupt() {
        core.handleInterrupt { _ in callbacks.read(.earlyWakeup)!(callbacks.context) }
    }
}
