// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PKA operations and definitions from stm32h7rsxx_hal_pka.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias PKACallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum PKACallbackID: UInt32, CaseIterable, Sendable {
    case operationComplete = 0, error, mspInitialize, mspDeinitialize
}
public protocol PKACallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: PKACallbackID) -> PKACallback?
    func write(_ id: PKACallbackID, value: PKACallback?)
}
public struct PKACallbackDefaults {
    public var operationComplete: PKACallback
    public var error: PKACallback
    public var mspInitialize: PKACallback
    public var mspDeinitialize: PKACallback
    // MSP teardown is required because the upstream weak implementation erases
    // accelerator RAM and disables its clock/IRQ. Bind deinitializeMSP(system:getTick:)
    // in this callback to retain that behavior, or supply an explicit override.
    public init(operationComplete: @escaping PKACallback = { _ in }, error: @escaping PKACallback = { _ in },
                mspInitialize: @escaping PKACallback = { _ in }, mspDeinitialize: @escaping PKACallback) {
        self.operationComplete = operationComplete; self.error = error
        self.mspInitialize = mspInitialize; self.mspDeinitialize = mspDeinitialize
    }
    public func callback(_ id: PKACallbackID) -> PKACallback {
        switch id {
        case .operationComplete: return operationComplete
        case .error: return error
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        }
    }
}
public struct PKA<Registers: PKARegisterIO, Handle: PKAHandleIO, Callbacks: PKACallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: PKACallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks, defaults: PKACallbackDefaults,
                useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
extension PKA {
    @discardableResult
    public func registerCallback(id: UInt32, callback: PKACallback?) -> HALStatus {
        guard let callback else { addError(0x10); return .error }
        if handle.read(.state) == 1 {
            guard let id = PKACallbackID(rawValue: id) else { addError(0x10); return .error }
            callbacks.write(id, value: callback)
        } else if handle.read(.state) == 0 {
            guard id == 2 || id == 3 else { addError(0x10); return .error }
            callbacks.write(PKACallbackID(rawValue: id)!, value: callback)
        } else { addError(0x10); return .error }
        return .ok
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        if handle.read(.state) == 1 {
            guard let id = PKACallbackID(rawValue: id) else { addError(0x10); return .error }
            callbacks.write(id, value: defaults.callback(id))
        } else if handle.read(.state) == 0 {
            guard id == 2 || id == 3 else { addError(0x10); return .error }
            let id = PKACallbackID(rawValue: id)!; callbacks.write(id, value: defaults.callback(id))
        } else { addError(0x10); return .error }
        return .ok
    }
    @discardableResult
    public func registerCallback(id: PKACallbackID, callback: PKACallback?) -> HALStatus { registerCallback(id: id.rawValue, callback: callback) }
    @discardableResult
    public func unregisterCallback(id: PKACallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
    func invoke(_ id: PKACallbackID) { (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context) }
    func addError(_ bits: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | bits) }
    func modify(_ register: PKARegister, clear: UInt32 = 0, set: UInt32 = 0) { registers.write(register, value: (registers.read(register) & ~clear) | set) }
    public func getState() -> UInt32 { handle.read(.state) }
    public func getError() -> UInt32 { handle.read(.errorCode) }
    public func getMode() -> UInt32 { (registers.read(.cr) & 0x3F00) >> 0x8 }
    public func getFlag(_ mask: UInt32) -> Bool { registers.read(.sr) & mask == mask }
    public func getInterruptSource(_ mask: UInt32) -> Bool { registers.read(.cr) & mask == mask }
    public func clearFlags(_ mask: UInt32) { registers.write(.clrfr, value: mask) }
    public func enableInterrupts(_ mask: UInt32) { modify(.cr, set: mask) }
    public func disableInterrupts(_ mask: UInt32) { modify(.cr, clear: mask) }
    public func enable() { modify(.cr, set: 0x1) }
    public func disable() { modify(.cr, clear: 0x1) }
    public func start() { modify(.cr, set: 0x2) }
    public func resetHandleState() {
        handle.write(.state, value: 0)
        if useRegisteredCallbacks { callbacks.write(.mspInitialize, value: nil); callbacks.write(.mspDeinitialize, value: nil) }
    }
}
