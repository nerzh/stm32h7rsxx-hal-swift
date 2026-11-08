// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum USBConfigurationField: Int, CaseIterable {
  case deviceEndpoints = 0
  case hostChannels = 1
  case dmaEnable = 2
  case speed = 3
  case endpoint0MaximumPacketSize = 4
  case phyInterface = 5
  case sofEnable = 6
  case lowPowerEnable = 7
  case lpmEnable = 8
  case batteryChargingEnable = 9
  case vbusSensingEnable = 10
  case useDedicatedEndpoint1 = 11
  case useExternalVBUS = 12
}
public protocol USBConfigurationIO {
  func readConfiguration(_ field: USBConfigurationField) -> UInt8
  func writeConfiguration(_ field: USBConfigurationField, value: UInt8)
}
extension USBConfigurationIO {
  public func configuration() -> USBConfiguration {
    USBConfiguration(
      deviceEndpoints: readConfiguration(.deviceEndpoints),
      hostChannels: readConfiguration(.hostChannels), dmaEnable: readConfiguration(.dmaEnable),
      speed: readConfiguration(.speed),
      endpoint0MaximumPacketSize: readConfiguration(.endpoint0MaximumPacketSize),
      phyInterface: readConfiguration(.phyInterface), sofEnable: readConfiguration(.sofEnable),
      lowPowerEnable: readConfiguration(.lowPowerEnable), lpmEnable: readConfiguration(.lpmEnable),
      batteryChargingEnable: readConfiguration(.batteryChargingEnable),
      vbusSensingEnable: readConfiguration(.vbusSensingEnable),
      useDedicatedEndpoint1: readConfiguration(.useDedicatedEndpoint1),
      useExternalVBUS: readConfiguration(.useExternalVBUS))
  }
}
public enum PCDHandleWord: Int, CaseIterable {
  case state = 0
  case errorCode, lock, address, lpmState, besl, frameNumber, lpmActive, batteryChargingActive
}
public protocol PCDHandleIO: USBConfigurationIO {
  associatedtype Endpoint: USBEndpointIO
  func read(_ word: PCDHandleWord) -> UInt32
  func write(_ word: PCDHandleWord, value: UInt32)
  func endpoint(_ index: UInt32, isIn: Bool) -> Endpoint
  func setupBuffer() -> UnsafeMutablePointer<UInt8>
}
public typealias USBCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias USBEndpointCallback = @convention(c) (UnsafeMutableRawPointer?, UInt8) -> Void
public typealias USBMessageCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public enum PCDCallbackID: UInt32, CaseIterable {
  case startOfFrame = 1
  case setupStage, reset, suspend, resume, connect, disconnect, mspInitialize, mspDeinitialize
}
public enum PCDEndpointCallbackID: UInt32, CaseIterable {
  case dataOut = 10
  case dataIn, isochronousOutIncomplete, isochronousInIncomplete
}
public enum PCDMessageCallbackID: UInt32, CaseIterable {
  case batteryCharging = 14
  case linkPowerManagement
}
public protocol PCDCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: PCDCallbackID) -> USBCallback?
  func write(_ id: PCDCallbackID, value: USBCallback?)
  func readEndpoint(_ id: PCDEndpointCallbackID) -> USBEndpointCallback?
  func writeEndpoint(_ id: PCDEndpointCallbackID, value: USBEndpointCallback?)
  func readMessage(_ id: PCDMessageCallbackID) -> USBMessageCallback?
  func writeMessage(_ id: PCDMessageCallbackID, value: USBMessageCallback?)
}
public struct PCDCallbackDefaults {
  public let startOfFrame: USBCallback
  public let setupStage: USBCallback
  public let reset: USBCallback
  public let suspend: USBCallback
  public let resume: USBCallback
  public let connect: USBCallback
  public let disconnect: USBCallback
  public let mspInitialize: USBCallback
  public let mspDeinitialize: USBCallback
  public let dataOut: USBEndpointCallback
  public let dataIn: USBEndpointCallback
  public let isochronousOutIncomplete: USBEndpointCallback
  public let isochronousInIncomplete: USBEndpointCallback
  public let batteryCharging: USBMessageCallback
  public let linkPowerManagement: USBMessageCallback
  public init(
    startOfFrame: @escaping USBCallback, setupStage: @escaping USBCallback,
    reset: @escaping USBCallback, suspend: @escaping USBCallback, resume: @escaping USBCallback,
    connect: @escaping USBCallback, disconnect: @escaping USBCallback,
    mspInitialize: @escaping USBCallback, mspDeinitialize: @escaping USBCallback,
    dataOut: @escaping USBEndpointCallback, dataIn: @escaping USBEndpointCallback,
    isochronousOutIncomplete: @escaping USBEndpointCallback,
    isochronousInIncomplete: @escaping USBEndpointCallback,
    batteryCharging: @escaping USBMessageCallback, linkPowerManagement: @escaping USBMessageCallback
  ) {
    self.startOfFrame = startOfFrame
    self.setupStage = setupStage
    self.reset = reset
    self.suspend = suspend
    self.resume = resume
    self.connect = connect
    self.disconnect = disconnect
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.dataOut = dataOut
    self.dataIn = dataIn
    self.isochronousOutIncomplete = isochronousOutIncomplete
    self.isochronousInIncomplete = isochronousInIncomplete
    self.batteryCharging = batteryCharging
    self.linkPowerManagement = linkPowerManagement
  }
  func callback(_ id: PCDCallbackID) -> USBCallback {
    switch id {
    case .startOfFrame: return startOfFrame
    case .setupStage: return setupStage
    case .reset: return reset
    case .suspend: return suspend
    case .resume: return resume
    case .connect: return connect
    case .disconnect: return disconnect
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
  func endpoint(_ id: PCDEndpointCallbackID) -> USBEndpointCallback {
    switch id {
    case .dataOut: return dataOut
    case .dataIn: return dataIn
    case .isochronousOutIncomplete: return isochronousOutIncomplete
    case .isochronousInIncomplete: return isochronousInIncomplete
    }
  }
  func message(_ id: PCDMessageCallbackID) -> USBMessageCallback {
    switch id {
    case .batteryCharging: return batteryCharging
    case .linkPowerManagement: return linkPowerManagement
    }
  }
}
public struct PCD<Registers: USBRegisterIO, Handle: PCDHandleIO, Callbacks: PCDCallbackIO> {
  public let usb: USB<Registers>
  public let handle: Handle
  public let callbacks: Callbacks
  public let defaults: PCDCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    usb: USB<Registers>, handle: Handle, callbacks: Callbacks, defaults: PCDCallbackDefaults,
    useRegisteredCallbacks: Bool = false
  ) {
    self.usb = usb
    self.handle = handle
    self.callbacks = callbacks
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  func invoke(_ id: PCDCallbackID) {
    (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
  }
  func invoke(_ id: PCDEndpointCallbackID, _ endpoint: UInt8) {
    (useRegisteredCallbacks ? callbacks.readEndpoint(id)! : defaults.endpoint(id))(
      callbacks.context, endpoint)
  }
  func invoke(_ id: PCDMessageCallbackID, _ message: UInt32) {
    (useRegisteredCallbacks ? callbacks.readMessage(id)! : defaults.message(id))(
      callbacks.context, message)
  }
  func lock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func invalidCallback() { handle.write(.errorCode, value: handle.read(.errorCode) | 0x10) }
}
