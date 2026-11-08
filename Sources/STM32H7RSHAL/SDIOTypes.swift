// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public typealias SDIOConfigurationWord = SDConfigurationWord
public enum SDIOHandleWord: Int, CaseIterable {
  case lock = 0
  case transmitSize = 1
  case receiveSize = 2
  case remainingData = 3
  case nextDataAddress = 4
  case nextRegisterAddress = 5
  case transferContext = 6
  case state = 7
  case errorCode = 8
}
public enum SDIOHandleHalfWord: Int, CaseIterable {
  case blockSize = 0
}
public enum SDIOHandleByte: Int, CaseIterable {
  case ioFunctionMask = 0
  case ioInterruptCount = 1
}
public protocol SDIOHandleIO {
  func read(_ field: SDIOConfigurationWord) -> UInt32
  func write(_ field: SDIOConfigurationWord, value: UInt32)
  func read(_ field: SDIOHandleWord) -> UInt32
  func write(_ field: SDIOHandleWord, value: UInt32)
  func read(_ field: SDIOHandleHalfWord) -> UInt16
  func write(_ field: SDIOHandleHalfWord, value: UInt16)
  func read(_ field: SDIOHandleByte) -> UInt8
  func write(_ field: SDIOHandleByte, value: UInt8)
  func readTransmitBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeTransmitBuffer(_ value: UnsafeMutablePointer<UInt8>?)
  func readReceiveBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeReceiveBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
extension SDIOHandleIO {
  public func setConfiguration(_ value: SDMMCConfiguration) {
    write(.clockEdge, value: value.clockEdge)
    write(.clockPowerSave, value: value.clockPowerSave)
    write(.busWide, value: value.busWide)
    write(.hardwareFlowControl, value: value.hardwareFlowControl)
    write(.clockDivider, value: value.clockDivider)
    write(.transceiverPresent, value: value.transceiverPresent)
  }
}
public typealias SDIOCallback = UARTCallback
public typealias SDIOFunctionCallback = FDCANCallback
public typealias SDIOTransceiverCallback = FDCANCallback
public typealias SDIOIdentifyCallback = @convention(c) (UnsafeMutableRawPointer?) -> UInt32
public enum SDIOIdentifyOperation {
  case none
  case initializeCard
  case custom(SDIOIdentifyCallback)
}
public enum SDIOCallbackID: UInt32, CaseIterable {
  case transmitComplete = 0
  case receiveComplete = 1
  case error = 2
  case mspInitialize = 16
  case mspDeinitialize = 17
}
public protocol SDIOCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: SDIOCallbackID) -> SDIOCallback?
  func write(_ id: SDIOCallbackID, value: SDIOCallback?)
  func readTransceiver() -> SDIOTransceiverCallback?
  func writeTransceiver(_ value: SDIOTransceiverCallback?)
  func readIdentify() -> SDIOIdentifyOperation
  func writeIdentify(_ value: SDIOIdentifyOperation)
  func readIOFunction(_ index: UInt32) -> SDIOFunctionCallback?
  func writeIOFunction(_ index: UInt32, value: SDIOFunctionCallback?)
}
public struct SDIOCallbackDefaults {
  public let transmitComplete: SDIOCallback
  public let receiveComplete: SDIOCallback
  public let error: SDIOCallback
  public let mspInitialize: SDIOCallback
  public let mspDeinitialize: SDIOCallback
  public let transceiver: SDIOTransceiverCallback
  public init(
    transmitComplete: @escaping SDIOCallback = { _ in },
    receiveComplete: @escaping SDIOCallback = { _ in }, error: @escaping SDIOCallback = { _ in },
    mspInitialize: @escaping SDIOCallback = { _ in },
    mspDeinitialize: @escaping SDIOCallback = { _ in },
    transceiver: @escaping SDIOTransceiverCallback = { _, _ in }
  ) {
    self.transmitComplete = transmitComplete
    self.receiveComplete = receiveComplete
    self.error = error
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.transceiver = transceiver
  }
  public func callback(_ id: SDIOCallbackID) -> SDIOCallback {
    switch id {
    case .transmitComplete: return transmitComplete
    case .receiveComplete: return receiveComplete
    case .error: return error
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct SDIO<Registers: SDMMCRegisterIO, Handle: SDIOHandleIO, Callbacks: SDIOCallbackIO> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let defaults: SDIOCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public let useTransceiver: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks,
    defaults: SDIOCallbackDefaults = .init(), useRegisteredCallbacks: Bool = true,
    useTransceiver: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
    self.useTransceiver = useTransceiver
  }
  public var sdmmc: SDMMC<Registers> { .init(registers: registers) }
  func identifyCard(getSystemCoreClock: () -> UInt32, delay: (UInt32) -> Void) -> UInt32 {
    switch callbacks.readIdentify() {
    case .none: preconditionFailure("Card identification callback is absent")
    case .initializeCard:
      return initializeCard(getSystemCoreClock: getSystemCoreClock, delay: delay).rawValue
    case .custom(let callback): return callback(callbacks.context)
    }
  }
}
