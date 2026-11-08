// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Callback behavior from stm32h7rsxx_hal_irda.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension IRDA {
  @discardableResult
  public func registerCallback(id: UInt32, callback: IRDACallback?) -> HALStatus {
    precondition(useRegisteredCallbacks)
    guard let callback else {
      handle.write(.errorCode, value: handle.read(.errorCode) | 0x40)
      return .error
    }
    if handle.read(.globalState) == 0x20 {
      if let id = IRDACallbackID(rawValue: id) {
        callbacks.write(id, value: callback)
        return .ok
      }
    } else if handle.read(.globalState) == 0 {
      if let id = IRDACallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize {
        callbacks.write(id, value: callback)
        return .ok
      }
    }
    handle.write(.errorCode, value: handle.read(.errorCode) | 0x40)
    return .error
  }

  @discardableResult
  public func registerCallback(id: IRDACallbackID, callback: IRDACallback?) -> HALStatus {
    registerCallback(id: id.rawValue, callback: callback)
  }

  @discardableResult
  public func unregisterCallback(id: UInt32) -> HALStatus {
    precondition(useRegisteredCallbacks)
    if handle.read(.globalState) == 0x20 {
      if let id = IRDACallbackID(rawValue: id) {
        callbacks.write(id, value: defaults.callback(id))
        return .ok
      }
    } else if handle.read(.globalState) == 0 {
      if let id = IRDACallbackID(rawValue: id), id == .mspInitialize || id == .mspDeinitialize {
        callbacks.write(id, value: defaults.callback(id))
        return .ok
      }
    }
    handle.write(.errorCode, value: handle.read(.errorCode) | 0x40)
    return .error
  }

  @discardableResult
  public func unregisterCallback(id: IRDACallbackID) -> HALStatus {
    unregisterCallback(id: id.rawValue)
  }

  public func resetHandleState() {
    handle.write(.globalState, value: 0)
    handle.write(.receiveState, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }

  func initializeCallbacksToDefault() {
    var rawID: UInt32 = 0
    while rawID <= 7 {
      let id = IRDACallbackID(rawValue: rawID)!
      callbacks.write(id, value: defaults.callback(id))
      rawID += 1
    }
  }

  func invokeCallback(_ id: IRDACallbackID) {
    if useRegisteredCallbacks {
      callbacks.read(id)!(callbacks.context)
    } else {
      defaults.callback(id)(callbacks.context)
    }
  }

  func initializeMSPIfReset() {
    if handle.read(.globalState) == 0 {
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
