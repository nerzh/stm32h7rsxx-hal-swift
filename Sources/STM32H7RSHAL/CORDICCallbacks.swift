// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Callback behavior from stm32h7rsxx_hal_cordic.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias CORDICCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum CORDICCallbackID: UInt32, CaseIterable {
  case error = 0, calculateComplete, mspInitialize, mspDeinitialize
}
public protocol CORDICCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: CORDICCallbackID) -> CORDICCallback?
  func write(_ id: CORDICCallbackID, value: CORDICCallback?)
}
public struct CORDICCallbackDefaults {
  public let error, calculateComplete, mspInitialize, mspDeinitialize: CORDICCallback
  public init(error: @escaping CORDICCallback = { _ in },
              calculateComplete: @escaping CORDICCallback = { _ in },
              mspInitialize: @escaping CORDICCallback = { _ in },
              mspDeinitialize: @escaping CORDICCallback = { _ in }) {
    self.error = error; self.calculateComplete = calculateComplete
    self.mspInitialize = mspInitialize; self.mspDeinitialize = mspDeinitialize
  }
  public func callback(_ id: CORDICCallbackID) -> CORDICCallback {
    switch id {
    case .error: return error
    case .calculateComplete: return calculateComplete
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct CORDICUnregisteredCallbacks: CORDICCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: CORDICCallbackID) -> CORDICCallback? { nil }
  public func write(_ id: CORDICCallbackID, value: CORDICCallback?) {
    preconditionFailure("CORDIC callback storage is absent")
  }
}

extension CORDIC {
  @discardableResult
  public func registerCallback(id: UInt32, callback: CORDICCallback?) -> HALStatus {
    precondition(useRegisteredCallbacks)
    guard let callback else { addError(0x10); return .error }
    if handle.read(.state) == 1 {
      guard let id = CORDICCallbackID(rawValue: id) else { addError(0x10); return .error }
      callbacks.write(id, value: callback)
      return .ok
    } else if handle.read(.state) == 0 {
      guard let id = CORDICCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize else {
        addError(0x10); return .error
      }
      callbacks.write(id, value: callback)
      return .ok
    }
    addError(0x10)
    return .error
  }
  @discardableResult
  public func registerCallback(id: CORDICCallbackID, callback: CORDICCallback?) -> HALStatus {
    registerCallback(id: id.rawValue, callback: callback)
  }
  @discardableResult
  public func unregisterCallback(id: UInt32) -> HALStatus {
    precondition(useRegisteredCallbacks)
    if handle.read(.state) == 1 {
      guard let id = CORDICCallbackID(rawValue: id) else { addError(0x10); return .error }
      callbacks.write(id, value: defaults.callback(id))
      return .ok
    } else if handle.read(.state) == 0 {
      guard let id = CORDICCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize else {
        addError(0x10); return .error
      }
      callbacks.write(id, value: defaults.callback(id))
      return .ok
    }
    addError(0x10)
    return .error
  }
  @discardableResult
  public func unregisterCallback(id: CORDICCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
  func invokeCallback(_ id: CORDICCallbackID) {
    if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
    else { defaults.callback(id)(callbacks.context) }
  }
  func addError(_ error: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | error) }
}
