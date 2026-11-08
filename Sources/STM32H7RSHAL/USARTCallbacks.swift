// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Callback behavior from stm32h7rsxx_hal_usart.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USART {
  @discardableResult
  public func registerCallback(id: UInt32, callback: USARTCallback?) -> HALStatus {
    precondition(useRegisteredCallbacks)
    guard let callback else {
      handle.write(.errorCode, value: handle.read(.errorCode) | 0x40)
      return .error
    }
    if handle.read(.state) == 1 {
      if let id = USARTCallbackID(rawValue: id) {
        callbacks.write(id, value: callback)
        return .ok
      }
    } else if handle.read(.state) == 0 {
      if let id = USARTCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize {
        callbacks.write(id, value: callback)
        return .ok
      }
    }
    handle.write(.errorCode, value: handle.read(.errorCode) | 0x40)
    return .error
  }

  @discardableResult
  public func registerCallback(id: USARTCallbackID, callback: USARTCallback?) -> HALStatus {
    registerCallback(id: id.rawValue, callback: callback)
  }

  @discardableResult
  public func unregisterCallback(id: UInt32) -> HALStatus {
    precondition(useRegisteredCallbacks)
    if handle.read(.state) == 1 {
      if let id = USARTCallbackID(rawValue: id) {
        callbacks.write(id, value: defaults.callback(id))
        return .ok
      }
    } else if handle.read(.state) == 0 {
      if let id = USARTCallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize {
        callbacks.write(id, value: defaults.callback(id))
        return .ok
      }
    }
    handle.write(.errorCode, value: handle.read(.errorCode) | 0x40)
    return .error
  }

  @discardableResult
  public func unregisterCallback(id: USARTCallbackID) -> HALStatus {
    unregisterCallback(id: id.rawValue)
  }

  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }

  func initializeCallbacksToDefault() {
    var rawID: UInt32 = 0
    while rawID <= 8 {
      let id = USARTCallbackID(rawValue: rawID)!
      callbacks.write(id, value: defaults.callback(id))
      rawID += 1
    }
  }

  func invokeCallback(_ id: USARTCallbackID) {
    if useRegisteredCallbacks {
      callbacks.read(id)!(callbacks.context)
    } else {
      defaults.callback(id)(callbacks.context)
    }
  }

  func initializeMSPIfReset() {
    if handle.read(.state) == 0 {
      handle.write(.lock, value: 0)
      if useRegisteredCallbacks {
        initializeCallbacksToDefault()
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
      }
      invokeCallback(.mspInitialize)
    }
  }
}
