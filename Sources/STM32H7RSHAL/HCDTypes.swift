// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USB, PCD and HCD operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum HCDHandleWord: Int, CaseIterable {
  case state = 0
  case errorCode, lock
}
public protocol HCDHandleIO: USBConfigurationIO {
  associatedtype Channel: USBHostChannelIO
  func read(_ word: HCDHandleWord) -> UInt32
  func write(_ word: HCDHandleWord, value: UInt32)
  func channel(_ index: UInt32) -> Channel
}
public typealias HCDURBCallback = @convention(c) (UnsafeMutableRawPointer?, UInt8, UInt32) -> Void
public enum HCDCallbackID: UInt32, CaseIterable {
  case startOfFrame = 1
  case connect, disconnect, portEnabled, portDisabled, mspInitialize, mspDeinitialize
}
public protocol HCDCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: HCDCallbackID) -> USBCallback?
  func write(_ id: HCDCallbackID, value: USBCallback?)
  func readURB() -> HCDURBCallback?
  func writeURB(_ value: HCDURBCallback?)
}
public struct HCDCallbackDefaults {
  public let startOfFrame: USBCallback
  public let connect: USBCallback
  public let disconnect: USBCallback
  public let portEnabled: USBCallback
  public let portDisabled: USBCallback
  public let mspInitialize: USBCallback
  public let mspDeinitialize: USBCallback
  public let urbChange: HCDURBCallback
  public init(
    startOfFrame: @escaping USBCallback, connect: @escaping USBCallback,
    disconnect: @escaping USBCallback, portEnabled: @escaping USBCallback,
    portDisabled: @escaping USBCallback, mspInitialize: @escaping USBCallback,
    mspDeinitialize: @escaping USBCallback, urbChange: @escaping HCDURBCallback
  ) {
    self.startOfFrame = startOfFrame
    self.connect = connect
    self.disconnect = disconnect
    self.portEnabled = portEnabled
    self.portDisabled = portDisabled
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.urbChange = urbChange
  }
  func callback(_ id: HCDCallbackID) -> USBCallback {
    switch id {
    case .startOfFrame: return startOfFrame
    case .connect: return connect
    case .disconnect: return disconnect
    case .portEnabled: return portEnabled
    case .portDisabled: return portDisabled
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct HCD<Registers: USBRegisterIO, Handle: HCDHandleIO, Callbacks: HCDCallbackIO> {
  public let usb: USB<Registers>
  public let handle: Handle
  public let callbacks: Callbacks
  public let defaults: HCDCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public let inNAKAutoActivateDisabled: Bool
  public let channelNAKCount: UInt32
  public init(
    usb: USB<Registers>, handle: Handle, callbacks: Callbacks, defaults: HCDCallbackDefaults,
    useRegisteredCallbacks: Bool = false, inNAKAutoActivateDisabled: Bool = false,
    channelNAKCount: UInt32 = 2
  ) {
    self.usb = usb
    self.handle = handle
    self.callbacks = callbacks
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
    self.inNAKAutoActivateDisabled = inNAKAutoActivateDisabled
    self.channelNAKCount = channelNAKCount
  }
  func invoke(_ id: HCDCallbackID) {
    (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
  }
  func invokeURB(_ channel: UInt8, _ state: UInt32) {
    (useRegisteredCallbacks ? callbacks.readURB()! : defaults.urbChange)(
      callbacks.context, channel, state)
  }
  func lock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func invalidCallback() { handle.write(.errorCode, value: handle.read(.errorCode) | 0x10) }
}
