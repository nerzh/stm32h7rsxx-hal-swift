// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HCD {
  public func registerCallback(_ rawID: UInt32, callback: USBCallback?) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard let callback else {
      invalidCallback()
      return .error
    }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      if let id = HCDCallbackID(rawValue: rawID) {
        callbacks.write(id, value: callback)
      } else {
        invalidCallback()
        result = .error
      }
    } else if handle.read(.state) == 0x0 {
      if rawID == 6 || rawID == 7 {
        callbacks.write(HCDCallbackID(rawValue: rawID)!, value: callback)
      } else {
        invalidCallback()
        result = .error
      }
    } else {
      invalidCallback()
      result = .error
    }
    unlock()
    return result
  }
  public func unregisterCallback(_ rawID: UInt32) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      if let id = HCDCallbackID(rawValue: rawID) {
        callbacks.write(id, value: defaults.callback(id))
      } else {
        invalidCallback()
        result = .error
      }
    } else if handle.read(.state) == 0x0 {
      if rawID == 6 || rawID == 7 {
        let id = HCDCallbackID(rawValue: rawID)!
        callbacks.write(id, value: defaults.callback(id))
      } else {
        invalidCallback()
        result = .error
      }
    } else {
      invalidCallback()
      result = .error
    }
    unlock()
    return result
  }
  public func registerURBCallback(_ callback: HCDURBCallback?) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard let callback else {
      invalidCallback()
      return .error
    }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      callbacks.writeURB(callback)
    } else {
      invalidCallback()
      result = .error
    }
    unlock()
    return result
  }
  public func unregisterURBCallback() -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      callbacks.writeURB(defaults.urbChange)
    } else {
      invalidCallback()
      result = .error
    }
    unlock()
    return result
  }
  func initializeCallbacks() {
    callbacks.write(.startOfFrame, value: defaults.startOfFrame)
    callbacks.write(.connect, value: defaults.connect)
    callbacks.write(.disconnect, value: defaults.disconnect)
    callbacks.write(.portEnabled, value: defaults.portEnabled)
    callbacks.write(.portDisabled, value: defaults.portDisabled)
    callbacks.writeURB(defaults.urbChange)
  }
}
