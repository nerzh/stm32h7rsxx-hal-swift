// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HCD {
  public func initialize(delay: (UInt32) -> Void) -> HALStatus {
    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0)
      if useRegisteredCallbacks {
        initializeCallbacks()
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
      }
      invoke(.mspInitialize)
    }
    handle.write(.state, value: 0x3)
    if !usb.registers.isHighSpeedInstance { handle.writeConfiguration(.dmaEnable, value: 0) }
    _ = usb.disableGlobalInterrupt()
    if usb.initializeCore(handle.configuration()) != .ok {
      handle.write(.state, value: 0x2)
      return .error
    }
    if usb.setCurrentMode(1, delay: delay) != .ok {
      handle.write(.state, value: 0x2)
      return .error
    }
    if usb.initializeHost(handle.configuration()) != .ok {
      handle.write(.state, value: 0x2)
      return .error
    }
    handle.write(.state, value: 0x1)
    return .ok
  }
  public func deinitialize() -> HALStatus {
    handle.write(.state, value: 0x3)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invoke(.mspDeinitialize)
    _ = usb.disableGlobalInterrupt()
    handle.write(.state, value: 0x0)
    return .ok
  }
  public func initializeChannel(
    _ number: UInt8, endpoint: UInt8, deviceAddress: UInt8, speed: UInt8, type: UInt8,
    maximumPacketSize: UInt16
  ) -> HALStatus {
    var maximum = UInt32(maximumPacketSize)
    guard lock() else { return .busy }
    let h = handle.channel(UInt32(number))
    h.write(.doPing, value: 0)
    h.write(.deviceAddress, value: UInt32(deviceAddress))
    h.write(.channelNumber, value: UInt32(number))
    h.write(.endpointType, value: UInt32(type))
    h.write(.endpointNumber, value: UInt32(endpoint & 0x7F))
    _ = clearHubInfo(number)
    if endpoint & 0x80 == 0x80 {
      h.write(.endpointIsIn, value: 1)
    } else {
      h.write(.endpointIsIn, value: 0)
    }
    let hostSpeed = usb.getHostSpeed()
    if type == 0x1 {
      if speed == 0x1 && hostSpeed == 0x0 {
        if maximum > 0xbc { maximum = 0xbc }
      }
    }
    h.write(.speed, value: UInt32(speed))
    h.write(.maximumPacketSize, value: UInt32(UInt16(truncatingIfNeeded: maximum)))
    let result = usb.initializeHostChannel(
      number, endpoint: endpoint, deviceAddress: deviceAddress, speed: speed, type: type,
      maximumPacketSize: UInt16(truncatingIfNeeded: maximum))
    unlock()
    return result
  }
  public func haltChannel(_ number: UInt8) -> HALStatus {
    guard lock() else { return .busy }
    _ = usb.haltHostChannel(number)
    unlock()
    return .ok
  }
  public func activateChannel(_ number: UInt8) -> HALStatus {
    guard lock() else { return .busy }
    _ = usb.activateHostChannel(
      number,
      direction: UInt8(truncatingIfNeeded: handle.channel(UInt32(number)).read(.channelDirection)))
    unlock()
    return .ok
  }
  public func submitRequest(
    _ number: UInt8, direction: UInt8, type: UInt8, token: UInt8,
    buffer: UnsafeMutablePointer<UInt8>?, length: UInt16, doPing: UInt8
  ) -> HALStatus {
    let h = handle.channel(UInt32(number))
    h.write(.endpointIsIn, value: UInt32(direction))
    h.write(.endpointType, value: UInt32(type))
    if token == 0 {
      h.write(.dataPID, value: 0x3)
      h.write(.doPing, value: UInt32(doPing))
    } else {
      h.write(.dataPID, value: 0x2)
    }
    switch type {
    case 0x0:
      if token == 1 {
        if direction == 0 {
          if length == 0 { h.write(.toggleOut, value: 1) }
          if h.read(.toggleOut) == 0 {
            h.write(.dataPID, value: 0x0)
          } else {
            h.write(.dataPID, value: 0x2)
          }
        } else {
          if h.read(.doStartSplit) == 1 {
            if h.read(.toggleIn) == 0 {
              h.write(.dataPID, value: 0x0)
            } else {
              h.write(.dataPID, value: 0x2)
            }
          }
        }
      }
    case 0x2, 0x3:
      if direction == 0 {
        if h.read(.toggleOut) == 0 {
          h.write(.dataPID, value: 0x0)
        } else {
          h.write(.dataPID, value: 0x2)
        }
      } else {
        if h.read(.toggleIn) == 0 {
          h.write(.dataPID, value: 0x0)
        } else {
          h.write(.dataPID, value: 0x2)
        }
      }
    case 0x1: h.write(.dataPID, value: 0x0)
    default: break
    }
    h.writeBuffer(buffer)
    h.write(.transferLength, value: UInt32(length))
    h.write(.urbState, value: 0x0)
    h.write(.transferCount, value: 0)
    h.write(.channelNumber, value: UInt32(number))
    h.write(.state, value: 0x0)
    return usb.startHostChannelTransfer(h, dma: handle.readConfiguration(.dmaEnable))
  }
  public func start() -> HALStatus {
    guard lock() else { return .busy }
    _ = usb.driveVBUS(1)
    _ = usb.enableGlobalInterrupt()
    unlock()
    return .ok
  }
  public func stop() -> HALStatus {
    guard lock() else { return .busy }
    _ = usb.stopHost()
    unlock()
    return .ok
  }
  public func resetPort(delay: (UInt32) -> Void) -> HALStatus { usb.resetPort(delay: delay) }
  public func getState() -> UInt32 { handle.read(.state) }
  public func getURBState(_ number: UInt8) -> UInt32 {
    handle.channel(UInt32(number)).read(.urbState)
  }
  public func getTransferCount(_ number: UInt8) -> UInt32 {
    handle.channel(UInt32(number)).read(.transferCount)
  }
  public func getChannelState(_ number: UInt8) -> UInt32 {
    handle.channel(UInt32(number)).read(.state)
  }
  public func getCurrentFrame() -> UInt32 { usb.getCurrentFrame() }
  public func getCurrentSpeed() -> UInt32 { usb.getHostSpeed() }
  public func setHubInfo(_ number: UInt8, address: UInt8, port: UInt8) -> HALStatus {
    let hostSpeed = usb.getHostSpeed()
    let h = handle.channel(UInt32(number))
    if h.read(.speed) != 0x0 && hostSpeed == 0x0 {
      h.write(.doStartSplit, value: 1)
      if h.read(.endpointType) == 0x0 && h.read(.endpointIsIn) != 0 { h.write(.toggleIn, value: 1) }
    }
    h.write(.hubAddress, value: UInt32(address))
    h.write(.hubPortNumber, value: UInt32(port))
    return .ok
  }
  public func clearHubInfo(_ number: UInt8) -> HALStatus {
    let h = handle.channel(UInt32(number))
    h.write(.doStartSplit, value: 0)
    h.write(.doCompleteSplit, value: 0)
    h.write(.hubAddress, value: 0)
    h.write(.hubPortNumber, value: 0)
    return .ok
  }
}
