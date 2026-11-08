// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  func invalidCallback() { handle.write(.errorCode, value: handle.read(.errorCode) | 0x100) }
  public func registerCallback(_ rawID: UInt32, callback: I2CCallback?) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard let callback else {
      invalidCallback()
      return .error
    }
    if handle.read(.state) == 0x20 {
      if let id = I2CCallbackID(rawValue: rawID) {
        callbacks.write(id, value: callback)
      } else {
        invalidCallback()
        return .error
      }
    } else if handle.read(.state) == 0x0 {
      if rawID == 9 || rawID == 10 {
        callbacks.write(I2CCallbackID(rawValue: rawID)!, value: callback)
      } else {
        invalidCallback()
        return .error
      }
    } else {
      invalidCallback()
      return .error
    }
    return .ok
  }
  public func unregisterCallback(_ rawID: UInt32) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    if handle.read(.state) == 0x20 {
      if let id = I2CCallbackID(rawValue: rawID) {
        callbacks.write(id, value: defaults.callback(id))
      } else {
        invalidCallback()
        return .error
      }
    } else if handle.read(.state) == 0x0 {
      if rawID == 9 || rawID == 10 {
        let id = I2CCallbackID(rawValue: rawID)!
        callbacks.write(id, value: defaults.callback(id))
      } else {
        invalidCallback()
        return .error
      }
    } else {
      invalidCallback()
      return .error
    }
    return .ok
  }
  public func registerAddressCallback(_ callback: I2CAddressCallback?) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard let callback else {
      invalidCallback()
      return .error
    }
    if handle.read(.state) == 0x20 {
      callbacks.writeAddress(callback)
    } else {
      invalidCallback()
      return .error
    }
    return .ok
  }
  public func unregisterAddressCallback() -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    if handle.read(.state) == 0x20 {
      callbacks.writeAddress(defaults.address)
    } else {
      invalidCallback()
      return .error
    }
    return .ok
  }
}
