// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Callback behavior from stm32h7rsxx_hal_hash.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias HASHCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum HASHCallbackID: UInt32, CaseIterable {
  case mspInitialize = 0, mspDeinitialize, inputComplete, digestComplete, error
}
public protocol HASHCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: HASHCallbackID) -> HASHCallback?
  func write(_ id: HASHCallbackID, value: HASHCallback?)
}
public struct HASHCallbackDefaults {
  public let mspInitialize, mspDeinitialize, inputComplete, digestComplete, error: HASHCallback
  public init(mspInitialize: @escaping HASHCallback = { _ in },
              mspDeinitialize: @escaping HASHCallback = { _ in },
              inputComplete: @escaping HASHCallback = { _ in },
              digestComplete: @escaping HASHCallback = { _ in },
              error: @escaping HASHCallback = { _ in }) {
    self.mspInitialize = mspInitialize; self.mspDeinitialize = mspDeinitialize
    self.inputComplete = inputComplete; self.digestComplete = digestComplete; self.error = error
  }
  public func callback(_ id: HASHCallbackID) -> HASHCallback {
    switch id {
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    case .inputComplete: return inputComplete
    case .digestComplete: return digestComplete
    case .error: return error
    }
  }
}
public struct HASHUnregisteredCallbacks: HASHCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: HASHCallbackID) -> HASHCallback? { nil }
  public func write(_ id: HASHCallbackID, value: HASHCallback?) {
    preconditionFailure("HASH callback storage is absent")
  }
}
extension HASH {
  @discardableResult
  public func registerCallback(id: UInt32, callback: HASHCallback?) -> HALStatus {
    precondition(useRegisteredCallbacks)
    guard let callback else { addError(0x10); return .error }
    if handle.read(.state) == 1 {
      guard let id = HASHCallbackID(rawValue: id) else { addError(0x10); return .error }
      callbacks.write(id, value: callback)
    } else if handle.read(.state) == 0 {
      guard let id = HASHCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize else {
        addError(0x10); return .error
      }
      callbacks.write(id, value: callback)
    } else { addError(0x10); return .error }
    return .ok
  }
  @discardableResult
  public func registerCallback(id: HASHCallbackID, callback: HASHCallback?) -> HALStatus {
    registerCallback(id: id.rawValue, callback: callback)
  }
  @discardableResult
  public func unregisterCallback(id: UInt32) -> HALStatus {
    precondition(useRegisteredCallbacks)
    if handle.read(.state) == 1 {
      guard let id = HASHCallbackID(rawValue: id) else { addError(0x10); return .error }
      callbacks.write(id, value: defaults.callback(id))
    } else if handle.read(.state) == 0 {
      guard let id = HASHCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize else {
        addError(0x10); return .error
      }
      callbacks.write(id, value: defaults.callback(id))
    } else { addError(0x10); return .error }
    return .ok
  }
  @discardableResult
  public func unregisterCallback(id: HASHCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
  func invokeCallback(_ id: HASHCallbackID) {
    if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
    else { defaults.callback(id)(callbacks.context) }
  }
}
