// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension PCD {
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
    if usb.setCurrentMode(0, delay: delay) != .ok {
      handle.write(.state, value: 0x2)
      return .error
    }
    var i: UInt8 = 0
    while i < handle.readConfiguration(.deviceEndpoints) {
      let ep = handle.endpoint(UInt32(i), isIn: true)
      ep.write(.isIn, value: 1)
      ep.write(.number, value: UInt32(i))
      ep.write(.transmitFIFONumber, value: UInt32(i))
      ep.write(.type, value: 0x0)
      ep.write(.maximumPacketSize, value: 0)
      ep.writeBuffer(nil)
      ep.write(.transferLength, value: 0)
      i &+= 1
    }
    i = 0
    while i < handle.readConfiguration(.deviceEndpoints) {
      let ep = handle.endpoint(UInt32(i), isIn: false)
      ep.write(.isIn, value: 0)
      ep.write(.number, value: UInt32(i))
      ep.write(.type, value: 0x0)
      ep.write(.maximumPacketSize, value: 0)
      ep.writeBuffer(nil)
      ep.write(.transferLength, value: 0)
      i &+= 1
    }
    if usb.initializeDevice(handle.configuration()) != .ok {
      handle.write(.state, value: 0x2)
      return .error
    }
    handle.write(.address, value: 0)
    handle.write(.state, value: 0x1)
    if handle.readConfiguration(.lpmEnable) == 1 { _ = activateLPM() }
    _ = usb.disconnectDevice()
    return .ok
  }
  public func deinitialize() -> HALStatus {
    handle.write(.state, value: 0x3)
    if usb.stopDevice() != .ok { return .error }
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invoke(.mspDeinitialize)
    handle.write(.state, value: 0x0)
    return .ok
  }
  public func start() -> HALStatus {
    guard lock() else { return .busy }
    if usb.registers.read(.gusbcfg) & 0x40 != 0
      && handle.readConfiguration(.batteryChargingEnable) == 1
    {
      usb.modify(.gccfg, set: 0x10000)
    }
    _ = usb.enableGlobalInterrupt()
    _ = usb.connectDevice()
    unlock()
    return .ok
  }
  public func stop() -> HALStatus {
    guard lock() else { return .busy }
    _ = usb.disableGlobalInterrupt()
    _ = usb.disconnectDevice()
    _ = usb.flushTransmitFIFO(0x10)
    if usb.registers.read(.gusbcfg) & 0x40 != 0
      && handle.readConfiguration(.batteryChargingEnable) == 1
    {
      usb.modify(.gccfg, clear: 0x10000)
    }
    unlock()
    return .ok
  }
  public func connectDevice() -> HALStatus {
    guard lock() else { return .busy }
    if usb.registers.read(.gusbcfg) & 0x40 != 0
      && handle.readConfiguration(.batteryChargingEnable) == 1
    {
      usb.modify(.gccfg, set: 0x10000)
    }
    _ = usb.connectDevice()
    unlock()
    return .ok
  }
  public func disconnectDevice() -> HALStatus {
    guard lock() else { return .busy }
    _ = usb.disconnectDevice()
    if usb.registers.read(.gusbcfg) & 0x40 != 0
      && handle.readConfiguration(.batteryChargingEnable) == 1
    {
      usb.modify(.gccfg, clear: 0x10000)
    }
    unlock()
    return .ok
  }
  public func setAddress(_ address: UInt8) -> HALStatus {
    guard lock() else { return .busy }
    handle.write(.address, value: UInt32(address))
    _ = usb.setDeviceAddress(address)
    unlock()
    return .ok
  }
  public func openEndpoint(_ address: UInt8, maximumPacketSize: UInt16, type: UInt8) -> HALStatus {
    let ep = handle.endpoint(UInt32(address & 15), isIn: address & 0x80 == 0x80)
    ep.write(.isIn, value: address & 0x80 == 0x80 ? 1 : 0)
    ep.write(.number, value: UInt32(address & 15))
    ep.write(.maximumPacketSize, value: UInt32(maximumPacketSize) & 0x7FF)
    ep.write(.type, value: UInt32(type))
    if ep.read(.isIn) != 0 { ep.write(.transmitFIFONumber, value: ep.read(.number)) }
    if type == 0x2 { ep.write(.dataPIDStart, value: 0) }
    guard lock() else { return .busy }
    _ = usb.activateEndpoint(ep)
    unlock()
    return .ok
  }
  public func closeEndpoint(_ address: UInt8) -> HALStatus {
    let ep = handle.endpoint(UInt32(address & 15), isIn: address & 0x80 == 0x80)
    ep.write(.isIn, value: address & 0x80 == 0x80 ? 1 : 0)
    ep.write(.number, value: UInt32(address & 15))
    guard lock() else { return .busy }
    _ = usb.deactivateEndpoint(ep)
    unlock()
    return .ok
  }
  public func receive(_ address: UInt8, buffer: UnsafeMutablePointer<UInt8>?, length: UInt32)
    -> HALStatus
  {
    let ep = handle.endpoint(UInt32(address & 15), isIn: false)
    ep.writeBuffer(buffer)
    ep.write(.transferLength, value: length)
    ep.write(.transferCount, value: 0)
    ep.write(.isIn, value: 0)
    ep.write(.number, value: UInt32(address & 15))
    if handle.readConfiguration(.dmaEnable) == 1 {
      ep.write(.dmaAddress, value: UInt32(truncatingIfNeeded: UInt(bitPattern: buffer)))
    }
    _ = usb.startEndpointTransfer(ep, dma: handle.readConfiguration(.dmaEnable))
    return .ok
  }
  public func transmit(_ address: UInt8, buffer: UnsafeMutablePointer<UInt8>?, length: UInt32)
    -> HALStatus
  {
    let ep = handle.endpoint(UInt32(address & 15), isIn: true)
    ep.writeBuffer(buffer)
    ep.write(.transferLength, value: length)
    ep.write(.transferCount, value: 0)
    ep.write(.isIn, value: 1)
    ep.write(.number, value: UInt32(address & 15))
    if handle.readConfiguration(.dmaEnable) == 1 {
      ep.write(.dmaAddress, value: UInt32(truncatingIfNeeded: UInt(bitPattern: buffer)))
    }
    _ = usb.startEndpointTransfer(ep, dma: handle.readConfiguration(.dmaEnable))
    return .ok
  }
  public func getReceiveCount(_ address: UInt8) -> UInt32 {
    handle.endpoint(UInt32(address & 15), isIn: false).read(.transferCount)
  }
  public func setEndpointStall(_ address: UInt8) -> HALStatus {
    if UInt32(address & 15) > handle.readConfiguration(.deviceEndpoints) { return .error }
    let isIn = address & 0x80 == 0x80
    let ep = handle.endpoint(UInt32(isIn ? address & 15 : address), isIn: isIn)
    ep.write(.isIn, value: isIn ? 1 : 0)
    ep.write(.isStall, value: 1)
    ep.write(.number, value: UInt32(address & 15))
    guard lock() else { return .busy }
    _ = usb.setEndpointStall(ep)
    if address & 15 == 0 {
      _ = usb.startEndpoint0Out(
        dma: handle.readConfiguration(.dmaEnable), setup: handle.setupBuffer())
    }
    unlock()
    return .ok
  }
  public func clearEndpointStall(_ address: UInt8) -> HALStatus {
    if UInt32(address & 15) > handle.readConfiguration(.deviceEndpoints) { return .error }
    let isIn = address & 0x80 == 0x80
    let ep = handle.endpoint(UInt32(address & 15), isIn: isIn)
    ep.write(.isIn, value: isIn ? 1 : 0)
    ep.write(.isStall, value: 0)
    ep.write(.number, value: UInt32(address & 15))
    guard lock() else { return .busy }
    _ = usb.clearEndpointStall(ep)
    unlock()
    return .ok
  }
  public func abortEndpoint(_ address: UInt8) -> HALStatus {
    usb.stopEndpointTransfer(handle.endpoint(UInt32(address & 15), isIn: address & 0x80 == 0x80))
  }
  public func flushEndpoint(_ address: UInt8) -> HALStatus {
    guard lock() else { return .busy }
    if address & 0x80 == 0x80 {
      _ = usb.flushTransmitFIFO(UInt32(address) & 15)
    } else {
      _ = usb.flushReceiveFIFO()
    }
    unlock()
    return .ok
  }
  public func activateRemoteWakeup() -> HALStatus { usb.activateRemoteWakeup() }
  public func deactivateRemoteWakeup() -> HALStatus { usb.deactivateRemoteWakeup() }
  public func getState() -> UInt32 { handle.read(.state) }
  public func setTestMode(_ mode: UInt8) -> HALStatus {
    switch mode {
    case 0x1, 0x2, 0x3, 0x4, 0x5:
      usb.modify(.dctl, clear: 7 << 4)
      usb.modify(.dctl, set: UInt32(mode) << 4)
    default: break
    }
    return .ok
  }
}
