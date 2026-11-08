// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PCD {
  public func registerCallback(_ rawID: UInt32, callback: USBCallback?) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard let callback else {
      invalidCallback()
      return .error
    }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      if let id = PCDCallbackID(rawValue: rawID) {
        callbacks.write(id, value: callback)
      } else {
        invalidCallback()
        result = .error
      }
    } else if handle.read(.state) == 0x0 {
      if rawID == 8 || rawID == 9 {
        callbacks.write(PCDCallbackID(rawValue: rawID)!, value: callback)
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
      if let id = PCDCallbackID(rawValue: rawID) {
        callbacks.write(id, value: defaults.callback(id))
      } else {
        invalidCallback()
        result = .error
      }
    } else if handle.read(.state) == 0x0 {
      if rawID == 8 || rawID == 9 {
        let id = PCDCallbackID(rawValue: rawID)!
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
  public func registerEndpointCallback(_ id: PCDEndpointCallbackID, callback: USBEndpointCallback?)
    -> HALStatus
  {
    if !useRegisteredCallbacks { return .error }
    guard let callback else {
      invalidCallback()
      return .error
    }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      callbacks.writeEndpoint(id, value: callback)
    } else {
      invalidCallback()
      result = .error
    }
    unlock()
    return result
  }
  public func unregisterEndpointCallback(_ id: PCDEndpointCallbackID) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      callbacks.writeEndpoint(id, value: defaults.endpoint(id))
    } else {
      invalidCallback()
      result = .error
    }
    unlock()
    return result
  }
  public func registerMessageCallback(_ id: PCDMessageCallbackID, callback: USBMessageCallback?)
    -> HALStatus
  {
    if !useRegisteredCallbacks { return .error }
    guard let callback else {
      invalidCallback()
      return .error
    }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      callbacks.writeMessage(id, value: callback)
    } else {
      invalidCallback()
      result = .error
    }
    unlock()
    return result
  }
  public func unregisterMessageCallback(_ id: PCDMessageCallbackID) -> HALStatus {
    if !useRegisteredCallbacks { return .error }
    guard lock() else { return .busy }
    var result = HALStatus.ok
    if handle.read(.state) == 0x1 {
      callbacks.writeMessage(id, value: defaults.message(id))
    } else {
      invalidCallback()
      result = .error
    }
    unlock()
    return result
  }
  func initializeCallbacks() {
    callbacks.write(.startOfFrame, value: defaults.startOfFrame)
    callbacks.write(.setupStage, value: defaults.setupStage)
    callbacks.write(.reset, value: defaults.reset)
    callbacks.write(.suspend, value: defaults.suspend)
    callbacks.write(.resume, value: defaults.resume)
    callbacks.write(.connect, value: defaults.connect)
    callbacks.write(.disconnect, value: defaults.disconnect)
    callbacks.writeEndpoint(.dataOut, value: defaults.dataOut)
    callbacks.writeEndpoint(.dataIn, value: defaults.dataIn)
    callbacks.writeEndpoint(.isochronousOutIncomplete, value: defaults.isochronousOutIncomplete)
    callbacks.writeEndpoint(.isochronousInIncomplete, value: defaults.isochronousInIncomplete)
    callbacks.writeMessage(.linkPowerManagement, value: defaults.linkPowerManagement)
    callbacks.writeMessage(.batteryCharging, value: defaults.batteryCharging)
  }
}
