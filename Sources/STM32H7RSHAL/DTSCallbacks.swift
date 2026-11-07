// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Callback behavior from stm32h7rsxx_hal_dts.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias DTSCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum DTSCallbackID: UInt32, CaseIterable {
  case measureComplete = 0, asyncMeasureComplete, lowThreshold, asyncLowThreshold
  case highThreshold, asyncHighThreshold, mspInitialize, mspDeinitialize
}
// Eight native-function-pointer slots in callback-ID order. Context, storage
// and targets are unowned and must remain valid for all foreground/IRQ uses.
public protocol DTSCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: DTSCallbackID) -> DTSCallback?
  func write(_ id: DTSCallbackID, value: DTSCallback?)
}
public struct DTSCallbackDefaults {
  public let measureComplete, asyncMeasureComplete, lowThreshold, asyncLowThreshold: DTSCallback
  public let highThreshold, asyncHighThreshold, mspInitialize, mspDeinitialize: DTSCallback
  public init(measureComplete: @escaping DTSCallback = { _ in },
              asyncMeasureComplete: @escaping DTSCallback = { _ in },
              lowThreshold: @escaping DTSCallback = { _ in },
              asyncLowThreshold: @escaping DTSCallback = { _ in },
              highThreshold: @escaping DTSCallback = { _ in },
              asyncHighThreshold: @escaping DTSCallback = { _ in },
              mspInitialize: @escaping DTSCallback = { _ in },
              mspDeinitialize: @escaping DTSCallback = { _ in }) {
    self.measureComplete = measureComplete; self.asyncMeasureComplete = asyncMeasureComplete
    self.lowThreshold = lowThreshold; self.asyncLowThreshold = asyncLowThreshold
    self.highThreshold = highThreshold; self.asyncHighThreshold = asyncHighThreshold
    self.mspInitialize = mspInitialize; self.mspDeinitialize = mspDeinitialize
  }
  public func callback(_ id: DTSCallbackID) -> DTSCallback {
    switch id {
    case .measureComplete: return measureComplete
    case .asyncMeasureComplete: return asyncMeasureComplete
    case .lowThreshold: return lowThreshold
    case .asyncLowThreshold: return asyncLowThreshold
    case .highThreshold: return highThreshold
    case .asyncHighThreshold: return asyncHighThreshold
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct DTSUnregisteredCallbacks: DTSCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: DTSCallbackID) -> DTSCallback? { nil }
  public func write(_ id: DTSCallbackID, value: DTSCallback?) {
    preconditionFailure("DTS callback storage is absent")
  }
}

extension DTS {
  @discardableResult
  public func registerCallback(id: UInt32, callback: DTSCallback?) -> HALStatus {
    precondition(useRegisteredCallbacks)
    guard let callback else { return .error }
    if handle.read(.state) == DTSState.ready.rawValue {
      guard let id = DTSCallbackID(rawValue: id) else { return .error }
      callbacks.write(id, value: callback)
      return .ok
    } else if handle.read(.state) == DTSState.reset.rawValue {
      guard let id = DTSCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize else {
        return .error
      }
      callbacks.write(id, value: callback)
      return .ok
    }
    return .error
  }
  @discardableResult
  public func registerCallback(id: DTSCallbackID, callback: DTSCallback?) -> HALStatus {
    registerCallback(id: id.rawValue, callback: callback)
  }
  @discardableResult
  public func unregisterCallback(id: UInt32) -> HALStatus {
    precondition(useRegisteredCallbacks)
    if handle.read(.state) == DTSState.ready.rawValue {
      guard let id = DTSCallbackID(rawValue: id) else { return .error }
      callbacks.write(id, value: defaults.callback(id))
      return .ok
    } else if handle.read(.state) == DTSState.reset.rawValue {
      guard let id = DTSCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize else {
        return .error
      }
      callbacks.write(id, value: defaults.callback(id))
      return .ok
    }
    return .error
  }
  @discardableResult
  public func unregisterCallback(id: DTSCallbackID) -> HALStatus { unregisterCallback(id: id.rawValue) }

  public func resetHandleState() {
    handle.write(.state, value: DTSState.reset.rawValue)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
  func invokeCallback(_ id: DTSCallbackID) {
    if useRegisteredCallbacks { callbacks.read(id)!(callbacks.context) }
    else { defaults.callback(id)(callbacks.context) }
  }
}
