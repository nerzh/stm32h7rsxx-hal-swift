// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Registered callback behavior from stm32h7rsxx_hal_rng.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// C function pointers cannot capture Swift values and require no heap storage or
// ARC. The caller-owned context replaces the C handle pointer. A callback may
// reconstruct an immutable RNG wrapper from that context and reenter the driver.
public typealias RNGCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias RNGReadyDataCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void

public enum RNGCallbackID: UInt32, CaseIterable {
    case error = 0, mspInitialize = 1, mspDeinitialize = 2
}

// Registered function pointers belong to external storage shared by all wrapper
// copies. Hardware implementations must access slots with volatile semantics.
// The four slots start nil; context and callback targets must outlive their use.
public protocol RNGCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: RNGCallbackID) -> RNGCallback?
    func write(_ id: RNGCallbackID, value: RNGCallback?)
    func readReadyDataCallback() -> RNGReadyDataCallback?
    func writeReadyDataCallback(_ callback: RNGReadyDataCallback?)
}

public struct RNGCallbackDefaults {
    public let error: RNGCallback
    public let mspInitialize: RNGCallback
    public let mspDeinitialize: RNGCallback
    public let readyData: RNGReadyDataCallback

    public init(error: @escaping RNGCallback = { _ in },
                mspInitialize: @escaping RNGCallback = { _ in },
                mspDeinitialize: @escaping RNGCallback = { _ in },
                readyData: @escaping RNGReadyDataCallback = { _, _ in }) {
        self.error = error
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
        self.readyData = readyData
    }
}

// USE_HAL_RNG_REGISTER_CALLBACKS=1. The core holds no callbacks; this wrapper
// supplies its registered functions through nonescaping hooks at the exact C
// call sites. Defaults are the equivalents of the link-time weak HAL functions.
public struct RNGRegistered<Registers: RNGRegisterIO, State: RNGStateIO, Callbacks: RNGCallbackIO> {
    public let core: RNG<Registers, State>
    public let callbacks: Callbacks
    public let defaults: RNGCallbackDefaults

    public init(core: RNG<Registers, State>, callbacks: Callbacks, defaults: RNGCallbackDefaults = .init()) {
        self.core = core
        self.callbacks = callbacks
        self.defaults = defaults
    }

    @discardableResult
    public func initialize(getTick: () -> UInt32) -> HALStatus {
        core.initialize(getTick: getTick) { _ in
            // Core has just unlocked the RESET handle, before setting BUSY.
            callbacks.writeReadyDataCallback(defaults.readyData)
            callbacks.write(.error, value: defaults.error)
            if callbacks.read(.mspInitialize) == nil {
                callbacks.write(.mspInitialize, value: defaults.mspInitialize)
            }
            callbacks.read(.mspInitialize)!(callbacks.context)
        }
    }

    @discardableResult
    public func deinitialize(getTick: () -> UInt32) -> HALStatus {
        core.deinitialize(getTick: getTick) { _ in
            if callbacks.read(.mspDeinitialize) == nil {
                callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
            }
            callbacks.read(.mspDeinitialize)!(callbacks.context)
        }
    }

    // Raw IDs retain the C runtime error path for unknown callback identifiers.
    @discardableResult
    public func registerCallback(id: UInt32, callback: RNGCallback?) -> HALStatus {
        guard let callback else {
            core.setError(.invalidCallback)
            return .error
        }
        if core.getState() == .ready {
            if let id = RNGCallbackID(rawValue: id) {
                callbacks.write(id, value: callback)
                return .ok
            }
        } else if core.getState() == .reset {
            if let id = RNGCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize {
                callbacks.write(id, value: callback)
                return .ok
            }
        }
        core.setError(.invalidCallback)
        return .error
    }

    @discardableResult
    public func registerCallback(id: RNGCallbackID, callback: RNGCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }

    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        if core.getState() == .ready {
            if let id = RNGCallbackID(rawValue: id) {
                setDefaultCallback(id)
                return .ok
            }
        } else if core.getState() == .reset {
            if let id = RNGCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize {
                setDefaultCallback(id)
                return .ok
            }
        }
        core.setError(.invalidCallback)
        return .error
    }

    @discardableResult
    public func unregisterCallback(id: RNGCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }

    @discardableResult
    public func registerReadyDataCallback(_ callback: RNGReadyDataCallback?) -> HALStatus {
        guard let callback else {
            core.setError(.invalidCallback)
            return .error
        }
        if !core.tryLock() { return .busy }
        var status = HALStatus.ok
        if core.getState() == .ready {
            callbacks.writeReadyDataCallback(callback)
        } else {
            core.setError(.invalidCallback)
            status = .error
        }
        core.unlock()
        return status
    }

    @discardableResult
    public func unregisterReadyDataCallback() -> HALStatus {
        if !core.tryLock() { return .busy }
        var status = HALStatus.ok
        if core.getState() == .ready {
            callbacks.writeReadyDataCallback(defaults.readyData)
        } else {
            core.setError(.invalidCallback)
            status = .error
        }
        core.unlock()
        return status
    }

    @discardableResult
    public func generateRandomNumber(_ output: inout UInt32, getTick: () -> UInt32) -> HALStatus {
        core.generateRandomNumber(&output, getTick: getTick) { _ in
            callbacks.read(.error)!(callbacks.context)
        }
    }

    @discardableResult
    public func generateRandomNumberInterrupt() -> HALStatus { core.generateRandomNumberInterrupt() }

    public func handleInterrupt() {
        core.handleInterrupt(readyDataCallback: { _, value in
            callbacks.readReadyDataCallback()!(callbacks.context, value)
        }, errorCallback: { _ in
            callbacks.read(.error)!(callbacks.context)
        })
    }

    public func readLastRandomNumber() -> UInt32 { core.readLastRandomNumber() }
    public func getState() -> RNGState { core.getState() }
    public func getError() -> RNGError { core.getError() }

    @discardableResult
    public func setConfig(_ configuration: RNGConfiguration?, getTick: () -> UInt32) -> HALStatus {
        core.setConfig(configuration, getTick: getTick)
    }

    @discardableResult
    public func getConfig(_ configuration: inout RNGConfiguration?) -> HALStatus { core.getConfig(&configuration) }

    @discardableResult
    public func getConfig(_ configuration: inout RNGConfiguration) -> HALStatus { core.getConfig(&configuration) }

    @discardableResult
    public func lockConfig() -> HALStatus { core.lockConfig() }

    @discardableResult
    public func recoverSeedError() -> HALStatus {
        core.recoverSeedError { _ in callbacks.read(.error)!(callbacks.context) }
    }

    public func resetHandleState() {
        core.resetHandleState()
        callbacks.write(.mspInitialize, value: nil)
        callbacks.write(.mspDeinitialize, value: nil)
    }

    private func setDefaultCallback(_ id: RNGCallbackID) {
        switch id {
        case .error: callbacks.write(id, value: defaults.error)
        case .mspInitialize: callbacks.write(id, value: defaults.mspInitialize)
        case .mspDeinitialize: callbacks.write(id, value: defaults.mspDeinitialize)
        }
    }
}
