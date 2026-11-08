// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias MDFCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias MDFSoundLevelCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32, UInt32) -> Void
public enum MDFCallbackID: UInt32, CaseIterable, Sendable {
    case acquisitionComplete = 1
    case acquisitionHalfComplete = 2
    case soundLevel = 3
    case soundActivity = 4
    case error = 5
    case mspInitialize = 6
    case mspDeinitialize = 7
}
public protocol MDFCallbackIO {
    var context: UnsafeMutableRawPointer? { get }
    func read(_ id: MDFCallbackID) -> MDFCallback?
    func write(_ id: MDFCallbackID, value: MDFCallback?)
    func readSoundLevel() -> MDFSoundLevelCallback?
    func writeSoundLevel(_ value: MDFSoundLevelCallback?)
}
public struct MDFCallbackDefaults {
    public var acquisitionComplete: MDFCallback
    public var acquisitionHalfComplete: MDFCallback
    public var soundLevel: MDFSoundLevelCallback
    public var soundActivity: MDFCallback
    public var error: MDFCallback
    public var mspInitialize: MDFCallback
    public var mspDeinitialize: MDFCallback
    public init(acquisitionComplete: @escaping MDFCallback = { _ in }, acquisitionHalfComplete: @escaping MDFCallback = { _ in }, soundLevel: @escaping MDFSoundLevelCallback = { _, _, _ in }, soundActivity: @escaping MDFCallback = { _ in }, error: @escaping MDFCallback = { _ in }, mspInitialize: @escaping MDFCallback = { _ in }, mspDeinitialize: @escaping MDFCallback = { _ in }) {
        self.acquisitionComplete = acquisitionComplete
        self.acquisitionHalfComplete = acquisitionHalfComplete
        self.soundLevel = soundLevel
        self.soundActivity = soundActivity
        self.error = error
        self.mspInitialize = mspInitialize
        self.mspDeinitialize = mspDeinitialize
    }
    public func callback(_ id: MDFCallbackID) -> MDFCallback {
        switch id {
        case .acquisitionComplete: return acquisitionComplete
        case .acquisitionHalfComplete: return acquisitionHalfComplete
        case .soundLevel: preconditionFailure("Use the sound-level callback signature")
        case .soundActivity: return soundActivity
        case .error: return error
        case .mspInitialize: return mspInitialize
        case .mspDeinitialize: return mspDeinitialize
        }
    }
}
extension MDF {
    @discardableResult
    public func registerCallback(id: UInt32, callback: MDFCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(128); return .error }
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && id >= 6), let id = MDFCallbackID(rawValue: id), id != .soundLevel {
            callbacks.write(id, value: callback); return .ok
        }
        addError(128); return .error
    }
    @discardableResult
    public func unregisterCallback(id: UInt32) -> HALStatus {
        precondition(useRegisteredCallbacks)
        if handle.read(.state) == 1 || (handle.read(.state) == 0 && id >= 6), let id = MDFCallbackID(rawValue: id), id != .soundLevel {
            callbacks.write(id, value: defaults.callback(id)); return .ok
        }
        addError(128); return .error
    }
    @discardableResult
    public func registerSoundLevelCallback(_ callback: MDFSoundLevelCallback?) -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard let callback else { addError(128); return .error }
        guard handle.read(.state) == 1 else { addError(128); return .error }
        callbacks.writeSoundLevel(callback); return .ok
    }
    @discardableResult
    public func unregisterSoundLevelCallback() -> HALStatus {
        precondition(useRegisteredCallbacks)
        guard handle.read(.state) == 1 else { addError(128); return .error }
        callbacks.writeSoundLevel(defaults.soundLevel); return .ok
    }
    func invoke(_ id: MDFCallbackID) {
        if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
        else { defaults.callback(id)(callbacks.context) }
    }
    func invokeSoundLevel(_ sound: UInt32, _ ambient: UInt32) {
        if useRegisteredCallbacks { callbacks.readSoundLevel()!(callbacks.context, sound, ambient) }
        else { defaults.soundLevel(callbacks.context, sound, ambient) }
    }
    func prepareMSPCallback(_ id: MDFCallbackID) {
        if useRegisteredCallbacks && callbacks.read(id) == nil { callbacks.write(id, value: defaults.callback(id)) }
    }
}
