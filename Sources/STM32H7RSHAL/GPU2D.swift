// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// GPU2D operations from stm32h7rsxx_hal_gpu2d.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension GPU2D {
    public static var commandListCompleteFlag: UInt32 { 1 }
    public static var commandListCompleteInterrupt: UInt32 { 1 }
    @discardableResult
    public func initialize() -> HALStatus {
        if handle.read(.state) == 0 {
            if useRegisteredCallbacks {
                callbacks.writeCommandListComplete(defaults.commandListComplete)
                if callbacks.read(.mspInitialize) == nil {
                    callbacks.write(.mspInitialize, value: defaults.mspInitialize)
                }
            }
            invoke(.mspInitialize)
            handle.write(.lock, value: 0)
        }
        guard tryLock() else { return .busy }
        // The original deliberately invalidates even the default completion hook.
        if useRegisteredCallbacks { callbacks.writeCommandListComplete(nil) }
        handle.write(.errorCode, value: 0)
        handle.write(.state, value: 1)
        unlock()
        return .ok
    }
    @discardableResult
    public func deinitialize() -> HALStatus {
        guard tryLock() else { return .busy }
        if handle.read(.state) == 1 {
            if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
                callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
            }
            invoke(.mspDeinitialize)
        }
        if useRegisteredCallbacks { callbacks.writeCommandListComplete(nil) }
        handle.write(.errorCode, value: 0)
        handle.write(.state, value: 0)
        unlock()
        return .ok
    }
    public func readRegister(offset: UInt32) -> UInt32 {
        precondition(offset < 0x1000)
        return registers.read(offset: offset)
    }
    @discardableResult
    public func writeRegister(offset: UInt32, value: UInt32) -> HALStatus {
        precondition(offset < 0x1000)
        registers.write(offset: offset, value: value)
        return .ok
    }
    public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(offset: 0xF8) & flag }
    public func clearFlag(_ flag: UInt32) {
        registers.write(offset: 0xF8, value: registers.read(offset: 0xF8) & ~flag)
    }
    public func getInterruptSource(_ interrupts: UInt32) -> UInt32 { registers.read(offset: 0xF8) & interrupts }
    public func handleInterrupt() {
        let flags = registers.read(offset: 0xF8)
        if flags & 1 != 0 {
            clearFlag(1)
            let id = registers.read(offset: 0x148)
            if useRegisteredCallbacks {
                if callbacks.readCommandListComplete() != nil {
                    callbacks.readCommandListComplete()!(callbacks.context, id)
                }
            } else { defaults.commandListComplete(callbacks.context, id) }
        }
    }
    // ST's weak error hook loops forever. Override defaults.error when recovery
    // is possible; this hook is not part of registered callback storage in C.
    public func handleErrorInterrupt() { defaults.error(callbacks.context) }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks {
            callbacks.write(.mspInitialize, value: nil)
            callbacks.write(.mspDeinitialize, value: nil)
            callbacks.writeCommandListComplete(nil)
        }
    }
    @discardableResult
    public func registerCallback(id: UInt32, callback: GPU2DCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard tryLock() else { return .busy }
        var status = HALStatus.ok
        if callback == nil { status = invalidCallback() }
        else if handle.read(.state) == 1 || handle.read(.state) == 0 {
            if let id = GPU2DCallbackID(rawValue: id) { callbacks.write(id, value: callback) }
            else { status = invalidCallback() }
        } else { status = .error }
        unlock()
        return status
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard tryLock() else { return .busy }
        var status = HALStatus.ok
        if handle.read(.state) == 1 || handle.read(.state) == 0 {
            if let id = GPU2DCallbackID(rawValue: id) { callbacks.write(id, value: defaults.callback(id)) }
            else { status = invalidCallback() }
        } else { status = .error }
        unlock()
        return status
    }
    @discardableResult
    public func registerCallback(id: GPU2DCallbackID, callback: GPU2DCallback?) -> HALStatus {
        registerCallback(id: id.rawValue, callback: callback)
    }
    @discardableResult
    public func unregisterCallback(id: GPU2DCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    @discardableResult
    public func registerCommandListCompleteCallback(_ callback: GPU2DCommandListCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard tryLock() else { return .busy }
        var status = HALStatus.ok
        if callback == nil { status = invalidCallback() }
        else if handle.read(.state) == 1 || handle.read(.state) == 0 { callbacks.writeCommandListComplete(callback) }
        else { status = .error }
        unlock()
        return status
    }
    @discardableResult
    public func unregisterCommandListCompleteCallback() -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard tryLock() else { return .busy }
        var status = HALStatus.ok
        if handle.read(.state) == 1 || handle.read(.state) == 0 { callbacks.writeCommandListComplete(nil) }
        else { status = .error }
        unlock()
        return status
    }
    private func tryLock() -> Bool {
        if handle.read(.lock) == 1 { return false }
        handle.write(.lock, value: 1)
        return true
    }
    private func unlock() { handle.write(.lock, value: 0) }
    private func invalidCallback() -> HALStatus {
        handle.write(.errorCode, value: handle.read(.errorCode) | 2)
        return .error
    }
    private func invoke(_ id: GPU2DCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
}
