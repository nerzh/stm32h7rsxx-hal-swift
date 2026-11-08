// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  @discardableResult
  public func registerCallback(id: UInt32, callback: CRYPCallback?) -> HALStatus {
    guard let callback else {
      addError(0x80)
      return .error
    }
    guard lock() else { return .busy }
    var status: HALStatus = .ok
    if handle.read(.state) == 1 {
      if let id = CRYPCallbackID(rawValue: id) {
        callbacks.write(id, value: callback)
      } else {
        addError(0x80)
        status = .error
      }
    } else if handle.read(.state) == 0 {
      if id == 4 || id == 5 {
        callbacks.write(CRYPCallbackID(rawValue: id)!, value: callback)
      } else {
        addError(0x80)
        status = .error
      }
    } else {
      addError(0x80)
      status = .error
    }
    unlock()
    return status
  }
  @discardableResult
  public func unregisterCallback(id: UInt32) -> HALStatus {
    guard lock() else { return .busy }
    var status: HALStatus = .ok
    if handle.read(.state) == 1 {
      if let id = CRYPCallbackID(rawValue: id) {
        callbacks.write(id, value: defaults.callback(id))
      } else {
        addError(0x80)
        status = .error
      }
    } else if handle.read(.state) == 0 {
      if id == 4 || id == 5 {
        let id = CRYPCallbackID(rawValue: id)!
        callbacks.write(id, value: defaults.callback(id))
      } else {
        addError(0x80)
        status = .error
      }
    } else {
      addError(0x80)
      status = .error
    }
    unlock()
    return status
  }
  @discardableResult
  public func registerCallback(id: CRYPCallbackID, callback: CRYPCallback?) -> HALStatus {
    registerCallback(id: id.rawValue, callback: callback)
  }
  @discardableResult
  public func unregisterCallback(id: CRYPCallbackID) -> HALStatus {
    unregisterCallback(id: id.rawValue)
  }
}
