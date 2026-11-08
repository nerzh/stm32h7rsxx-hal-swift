// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum I3CRegister: UInt32, CaseIterable, Sendable {
  case cr = 0
  case cfgr = 4
  case rdr = 16
  case rdwr = 20
  case tdr = 24
  case tdwr = 28
  case ibidr = 32
  case tgttdr = 36
  case sr = 48
  case ser = 52
  case rmr = 64
  case evr = 80
  case ier = 84
  case cevr = 88
  case devr0 = 96
  case devrx1 = 100
  case devrx2 = 104
  case devrx3 = 108
  case devrx4 = 112
  case maxrlr = 144
  case maxwlr = 148
  case timingr0 = 160
  case timingr1 = 164
  case timingr2 = 168
  case bcr = 192
  case dcr = 196
  case getcapr = 200
  case crcapr = 204
  case getmxdsr = 208
  case epidr = 212
}
public protocol I3CRegisterIO {
  func read(_ register: I3CRegister) -> UInt32
  func write(_ register: I3CRegister, value: UInt32)
  func address(of register: I3CRegister) -> UInt32
}
public enum I3CConfigurationWord: Int, CaseIterable {
  case sdaHoldTime = 0
  case waitTime = 1
  case sclppLowDuration = 2
  case sclI3CHighDuration = 3
  case sclodLowDuration = 4
  case sclI2CHighDuration = 5
  case busFreeDuration = 6
  case busIdleDuration = 7
  case busAvailableDuration = 8
}
public enum I3CHandleWord: Int, CaseIterable {
  case mode = 0
  case controlTransferCount = 1
  case receiveTransferCount = 2
  case transmitTransferCount = 3
  case lock = 4
  case state = 5
  case previousState = 6
  case errorCode = 7
  case transferISR = 8
  case transmitTreatment = 9
  case receiveTreatment = 10
}
public enum I3CTransferISR: UInt32, CaseIterable {
  case none = 0
  case targetEvent = 1
  case controllerEvent = 2
  case targetHotJoin = 3
  case targetControlRole = 4
  case targetIBI = 5
  case targetTransmit = 6
  case targetReceive = 7
  case targetTransmitDMA = 8
  case targetReceiveDMA = 9
  case controllerTransmit = 10
  case controllerReceive = 11
  case controllerMultipleTransfer = 12
  case controllerTransmitListen = 13
  case controllerReceiveListen = 14
  case controllerMultipleTransferListen = 15
  case controllerDynamicAddress = 16
  case controllerTransmitDMA = 17
  case controllerReceiveDMA = 18
  case controllerMultipleTransferDMA = 19
  case abort = 20
}
public protocol I3CHandleIO {
  func read(_ word: I3CConfigurationWord) -> UInt32
  func write(_ word: I3CConfigurationWord, value: UInt32)
  func read(_ word: I3CHandleWord) -> UInt32
  func write(_ word: I3CHandleWord, value: UInt32)
  func readTransfer() -> UnsafeMutablePointer<I3CTransfer>?
  func writeTransfer(_ value: UnsafeMutablePointer<I3CTransfer>?)
  func readCCCDescriptors() -> UnsafePointer<I3CCCCDescriptor>?
  func writeCCCDescriptors(_ value: UnsafePointer<I3CCCCDescriptor>?)
  func readPrivateDescriptors() -> UnsafePointer<I3CPrivateDescriptor>?
  func writePrivateDescriptors(_ value: UnsafePointer<I3CPrivateDescriptor>?)
}
extension I3CHandleIO {
  public func setConfiguration(_ value: I3CConfiguration) {
    write(.sdaHoldTime, value: UInt32(value.controllerBus.sdaHoldTime))
    write(.waitTime, value: UInt32(value.controllerBus.waitTime))
    write(.sclppLowDuration, value: UInt32(value.controllerBus.sclppLowDuration))
    write(.sclI3CHighDuration, value: UInt32(value.controllerBus.sclI3CHighDuration))
    write(.sclodLowDuration, value: UInt32(value.controllerBus.sclodLowDuration))
    write(.sclI2CHighDuration, value: UInt32(value.controllerBus.sclI2CHighDuration))
    write(.busFreeDuration, value: UInt32(value.controllerBus.busFreeDuration))
    write(.busIdleDuration, value: UInt32(value.controllerBus.busIdleDuration))
    write(.busAvailableDuration, value: UInt32(value.targetBus.busAvailableDuration))
  }
}
public typealias I3CCallback = UARTCallback
public typealias I3CDynamicAddressCallback =
  @convention(c) (UnsafeMutableRawPointer?, UInt64) -> Void
public typealias I3CHotJoinCallback = @convention(c) (UnsafeMutableRawPointer?, UInt8) -> Void
public typealias I3CNotifyCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public enum I3CCallbackID: UInt32, CaseIterable {
  case controllerTransmitComplete = 0
  case controllerReceiveComplete = 1
  case controllerMultipleTransferComplete = 2
  case controllerDynamicAddressComplete = 3
  case targetTransmitComplete = 5
  case targetReceiveComplete = 6
  case error = 9
  case abortComplete = 10
  case mspInitialize = 11
  case mspDeinitialize = 12
}
public protocol I3CCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: I3CCallbackID) -> I3CCallback?
  func write(_ id: I3CCallbackID, value: I3CCallback?)
  func readTargetRequestDynamicAddress() -> I3CDynamicAddressCallback?
  func writeTargetRequestDynamicAddress(_ value: I3CDynamicAddressCallback?)
  func readTargetHotJoin() -> I3CHotJoinCallback?
  func writeTargetHotJoin(_ value: I3CHotJoinCallback?)
  func readNotify() -> I3CNotifyCallback?
  func writeNotify(_ value: I3CNotifyCallback?)
}
public struct I3CCallbackDefaults {
  public let controllerTransmitComplete: I3CCallback
  public let controllerReceiveComplete: I3CCallback
  public let controllerMultipleTransferComplete: I3CCallback
  public let controllerDynamicAddressComplete: I3CCallback
  public let targetRequestDynamicAddress: I3CDynamicAddressCallback
  public let targetTransmitComplete: I3CCallback
  public let targetReceiveComplete: I3CCallback
  public let targetHotJoin: I3CHotJoinCallback
  public let notify: I3CNotifyCallback
  public let error: I3CCallback
  public let abortComplete: I3CCallback
  public let mspInitialize: I3CCallback
  public let mspDeinitialize: I3CCallback
  public init(
    controllerTransmitComplete: @escaping I3CCallback = { _ in },
    controllerReceiveComplete: @escaping I3CCallback = { _ in },
    controllerMultipleTransferComplete: @escaping I3CCallback = { _ in },
    controllerDynamicAddressComplete: @escaping I3CCallback = { _ in },
    targetRequestDynamicAddress: @escaping I3CDynamicAddressCallback = { _, _ in },
    targetTransmitComplete: @escaping I3CCallback = { _ in },
    targetReceiveComplete: @escaping I3CCallback = { _ in },
    targetHotJoin: @escaping I3CHotJoinCallback = { _, _ in },
    notify: @escaping I3CNotifyCallback = { _, _ in }, error: @escaping I3CCallback = { _ in },
    abortComplete: @escaping I3CCallback = { _ in },
    mspInitialize: @escaping I3CCallback = { _ in },
    mspDeinitialize: @escaping I3CCallback = { _ in }
  ) {
    self.controllerTransmitComplete = controllerTransmitComplete
    self.controllerReceiveComplete = controllerReceiveComplete
    self.controllerMultipleTransferComplete = controllerMultipleTransferComplete
    self.controllerDynamicAddressComplete = controllerDynamicAddressComplete
    self.targetRequestDynamicAddress = targetRequestDynamicAddress
    self.targetTransmitComplete = targetTransmitComplete
    self.targetReceiveComplete = targetReceiveComplete
    self.targetHotJoin = targetHotJoin
    self.notify = notify
    self.error = error
    self.abortComplete = abortComplete
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  public func callback(_ id: I3CCallbackID) -> I3CCallback {
    switch id {
    case .controllerTransmitComplete: return controllerTransmitComplete
    case .controllerReceiveComplete: return controllerReceiveComplete
    case .controllerMultipleTransferComplete: return controllerMultipleTransferComplete
    case .controllerDynamicAddressComplete: return controllerDynamicAddressComplete
    case .targetTransmitComplete: return targetTransmitComplete
    case .targetReceiveComplete: return targetReceiveComplete
    case .error: return error
    case .abortComplete: return abortComplete
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct I3CUnregisteredCallbacks: I3CCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: I3CCallbackID) -> I3CCallback? { nil }
  public func write(_ id: I3CCallbackID, value: I3CCallback?) {
    preconditionFailure("Callback storage is absent")
  }
  public func readTargetRequestDynamicAddress() -> I3CDynamicAddressCallback? { nil }
  public func writeTargetRequestDynamicAddress(_ value: I3CDynamicAddressCallback?) {
    preconditionFailure("Callback storage is absent")
  }
  public func readTargetHotJoin() -> I3CHotJoinCallback? { nil }
  public func writeTargetHotJoin(_ value: I3CHotJoinCallback?) {
    preconditionFailure("Callback storage is absent")
  }
  public func readNotify() -> I3CNotifyCallback? { nil }
  public func writeNotify(_ value: I3CNotifyCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public struct I3C<
  Registers: I3CRegisterIO, Handle: I3CHandleIO, Callbacks: I3CCallbackIO, DMAIO: I3CDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: I3CCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: I3CCallbackDefaults = .init(), useRegisteredCallbacks: Bool = true
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  func modify(_ register: I3CRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
