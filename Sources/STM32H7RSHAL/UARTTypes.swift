// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Types and encodings from stm32h7rsxx_hal_uart.h and uart_ex.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.
// Peripheral addresses follow CMSIS at 7e6e213ddc397c76622a0aca2f623ccc3b34c010;
// see LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt (Apache-2.0).

public enum UARTInstance: UInt32, CaseIterable, Sendable {
  case usart1 = 0x4200_1000
  case usart2 = 0x4000_4400
  case usart3 = 0x4000_4800
  case uart4 = 0x4000_4C00
  case uart5 = 0x4000_5000
  case uart7 = 0x4000_7800
  case uart8 = 0x4000_7C00
  case lpuart1 = 0x5800_0C00
  public var isLowPower: Bool { self == .lpuart1 }
}

public enum UARTRegister: Hashable, CaseIterable {
  case cr1, cr2, cr3, brr, gtpr, rtor, rqr, isr, icr, rdr, tdr, presc
}

public protocol UARTRegisterIO {
  var instance: UARTInstance { get }
  func read(_ register: UARTRegister) -> UInt32
  func write(_ register: UARTRegister, value: UInt32)
  // CMSIS ATOMIC_* operations use the LDREXW/STREXW retry loop. A normal
  // read/modify/write or masking interrupts is not an equivalent implementation.
  func atomicModify(_ register: UARTRegister, clear: UInt32, set: UInt32)
}

public enum UARTConfigurationWord: Int, CaseIterable {
  case baudRate = 0
  case wordLength, stopBits, parity, mode, hardwareFlowControl
  case overSampling, oneBitSampling, clockPrescaler
}
public enum UARTAdvancedConfigurationWord: Int, CaseIterable {
  case features = 0
  case txPinLevelInvert, rxPinLevelInvert, dataInvert, swap
  case overrunDisable, dmaDisableOnReceiveError, autoBaudRateEnable, autoBaudRateMode,
    mostSignificantBitFirst
}
// These seven fields have uint16_t assignment/wrapping semantics in C.
public enum UARTHandleHalfWord: Int, CaseIterable {
  case transmitSize = 0
  case transmitCount, receiveSize, receiveCount, mask, rxDataToProcess, txDataToProcess
}
public enum UARTHandleWord: Int, CaseIterable {
  case fifoMode = 0
  case receptionType, rxEventType, lock, globalState, receiveState, errorCode, rxISR, txISR
}
public enum UARTBufferPointer: Int, CaseIterable {
  case transmit = 0
  case receive = 1
}

// The descriptor is shared by all immutable UART copies and interrupt handlers.
// Configuration is external too: MSP hooks can change Init/AdvancedInit before
// the subsequent C-equivalent reads. Access must be volatile on hardware; no
// Swift inout access to the whole descriptor may span a foreground operation.
// Suggested hardware storage: 35 UInt32 slots (9 configuration, 10 advanced,
// 7 halfword fields, 9 state/ISR fields) plus two native-pointer-width slots.
public protocol UARTHandleIO {
  func read(_ word: UARTConfigurationWord) -> UInt32
  func write(_ word: UARTConfigurationWord, value: UInt32)
  func read(_ word: UARTAdvancedConfigurationWord) -> UInt32
  func write(_ word: UARTAdvancedConfigurationWord, value: UInt32)
  func read(_ word: UARTHandleHalfWord) -> UInt16
  func write(_ word: UARTHandleHalfWord, value: UInt16)
  func read(_ word: UARTHandleWord) -> UInt32
  func write(_ word: UARTHandleWord, value: UInt32)
  func readPointer(_ pointer: UARTBufferPointer) -> UnsafeMutableRawPointer?
  func writePointer(_ pointer: UARTBufferPointer, value: UnsafeMutableRawPointer?)
}

// Selectors replace only the five private C RxISR/TxISR function addresses.
public enum UARTISR: UInt32, Sendable {
  case none = 0
  case byte = 1
  case halfWord = 2
  case byteFIFO = 3
  case halfWordFIFO = 4
}
public enum UARTState: UInt32, Sendable {
  case reset = 0
  case ready = 0x20
  case busy = 0x24
  case busyTransmit = 0x21
  case busyReceive = 0x22
  case busyTransmitReceive = 0x23
  case timeout = 0xA0
  case error = 0xE0
}
public enum UARTReceptionType: UInt32, Sendable {
  case standard = 0
  case toIdle = 1
  case toReceiverTimeout = 2
  case toCharacterMatch = 3
}
public enum UARTRxEventType: UInt32, Sendable {
  case complete = 0
  case halfComplete = 1
  case idle = 2
}
public struct UARTError: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let parity = Self(rawValue: 1)
  public static let noise = Self(rawValue: 2)
  public static let framing = Self(rawValue: 4)
  public static let overrun = Self(rawValue: 8)
  public static let dma = Self(rawValue: 0x10)
  public static let receiverTimeout = Self(rawValue: 0x20)
  public static let invalidCallback = Self(rawValue: 0x40)
}

public enum UARTClockSource: UInt32, Sendable {
  case pclk1 = 0
  case pclk2 = 1
  case pclk4 = 2
  case pll2Q = 4
  case pll3Q = 8
  case hsi = 0x10
  case csi = 0x20
  case lse = 0x40
  case undefined = 0x80
}
public protocol UARTClockIO {
  func source(for instance: UARTInstance) -> UARTClockSource
  // Match UART_SetConfig, not RCCEx peripheral-clock readiness filtering.
  // HSI uses HSIDIV only when HSIDIVF is set; otherwise it uses HSI_VALUE.
  // CSI/LSE return configured oscillator values without ready-bit checks.
  func frequency(_ source: UARTClockSource) -> UInt32
}

public struct UARTConfiguration: Equatable, Sendable {
  public var baudRate: UInt32
  public var wordLength: UInt32
  public var stopBits: UInt32
  public var parity: UInt32
  public var mode: UInt32
  public var hardwareFlowControl: UInt32
  public var overSampling: UInt32
  public var oneBitSampling: UInt32
  public var clockPrescaler: UInt32
  public init(
    baudRate: UInt32 = 115_200, wordLength: UInt32 = 0, stopBits: UInt32 = 0, parity: UInt32 = 0,
    mode: UInt32 = 0xC, hardwareFlowControl: UInt32 = 0, overSampling: UInt32 = 0,
    oneBitSampling: UInt32 = 0, clockPrescaler: UInt32 = 0
  ) {
    self.baudRate = baudRate
    self.wordLength = wordLength
    self.stopBits = stopBits
    self.parity = parity
    self.mode = mode
    self.hardwareFlowControl = hardwareFlowControl
    self.overSampling = overSampling
    self.oneBitSampling = oneBitSampling
    self.clockPrescaler = clockPrescaler
  }
}

public struct UARTAdvancedConfiguration: Equatable, Sendable {
  public var features: UInt32
  public var txPinLevelInvert: UInt32
  public var rxPinLevelInvert: UInt32
  public var dataInvert: UInt32
  public var swap: UInt32
  public var overrunDisable: UInt32
  public var dmaDisableOnReceiveError: UInt32
  public var autoBaudRateEnable: UInt32
  public var autoBaudRateMode: UInt32
  public var mostSignificantBitFirst: UInt32
  public init(
    features: UInt32 = 0, txPinLevelInvert: UInt32 = 0, rxPinLevelInvert: UInt32 = 0,
    dataInvert: UInt32 = 0, swap: UInt32 = 0, overrunDisable: UInt32 = 0,
    dmaDisableOnReceiveError: UInt32 = 0, autoBaudRateEnable: UInt32 = 0,
    autoBaudRateMode: UInt32 = 0, mostSignificantBitFirst: UInt32 = 0
  ) {
    self.features = features
    self.txPinLevelInvert = txPinLevelInvert
    self.rxPinLevelInvert = rxPinLevelInvert
    self.dataInvert = dataInvert
    self.swap = swap
    self.overrunDisable = overrunDisable
    self.dmaDisableOnReceiveError = dmaDisableOnReceiveError
    self.autoBaudRateEnable = autoBaudRateEnable
    self.autoBaudRateMode = autoBaudRateMode
    self.mostSignificantBitFirst = mostSignificantBitFirst
  }
}

public struct UARTWakeUpConfiguration: Equatable, Sendable {
  public var event: UInt32
  public var addressLength: UInt16
  public var address: UInt8
  public init(event: UInt32 = 0, addressLength: UInt16 = 0, address: UInt8 = 0) {
    self.event = event
    self.addressLength = addressLength
    self.address = address
  }
}

extension UARTHandleIO {
  public func setConfiguration(_ configuration: UARTConfiguration) {
    write(.baudRate, value: configuration.baudRate)
    write(.wordLength, value: configuration.wordLength)
    write(.stopBits, value: configuration.stopBits)
    write(.parity, value: configuration.parity)
    write(.mode, value: configuration.mode)
    write(.hardwareFlowControl, value: configuration.hardwareFlowControl)
    write(.overSampling, value: configuration.overSampling)
    write(.oneBitSampling, value: configuration.oneBitSampling)
    write(.clockPrescaler, value: configuration.clockPrescaler)
  }
  public func getConfiguration() -> UARTConfiguration {
    .init(
      baudRate: read(.baudRate), wordLength: read(.wordLength), stopBits: read(.stopBits),
      parity: read(.parity), mode: read(.mode), hardwareFlowControl: read(.hardwareFlowControl),
      overSampling: read(.overSampling), oneBitSampling: read(.oneBitSampling),
      clockPrescaler: read(.clockPrescaler))
  }
  public func setAdvancedConfiguration(_ configuration: UARTAdvancedConfiguration) {
    write(.features, value: configuration.features)
    write(.txPinLevelInvert, value: configuration.txPinLevelInvert)
    write(.rxPinLevelInvert, value: configuration.rxPinLevelInvert)
    write(.dataInvert, value: configuration.dataInvert)
    write(.swap, value: configuration.swap)
    write(.overrunDisable, value: configuration.overrunDisable)
    write(.dmaDisableOnReceiveError, value: configuration.dmaDisableOnReceiveError)
    write(.autoBaudRateEnable, value: configuration.autoBaudRateEnable)
    write(.autoBaudRateMode, value: configuration.autoBaudRateMode)
    write(.mostSignificantBitFirst, value: configuration.mostSignificantBitFirst)
  }
  public func getAdvancedConfiguration() -> UARTAdvancedConfiguration {
    .init(
      features: read(.features), txPinLevelInvert: read(.txPinLevelInvert),
      rxPinLevelInvert: read(.rxPinLevelInvert), dataInvert: read(.dataInvert), swap: read(.swap),
      overrunDisable: read(.overrunDisable),
      dmaDisableOnReceiveError: read(.dmaDisableOnReceiveError),
      autoBaudRateEnable: read(.autoBaudRateEnable), autoBaudRateMode: read(.autoBaudRateMode),
      mostSignificantBitFirst: read(.mostSignificantBitFirst))
  }
}

public typealias UARTCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias UARTRxEventCallback = @convention(c) (UnsafeMutableRawPointer?, UInt16) -> Void
public enum UARTCallbackID: UInt32, CaseIterable {
  case transmitHalfComplete = 0
  case transmitComplete, receiveHalfComplete, receiveComplete, error
  case abortComplete, abortTransmitComplete, abortReceiveComplete, wakeup, receiveFIFOFull,
    transmitFIFOEmpty
  case mspInitialize, mspDeinitialize
}
public protocol UARTCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: UARTCallbackID) -> UARTCallback?
  func write(_ id: UARTCallbackID, value: UARTCallback?)
  func readRxEventCallback() -> UARTRxEventCallback?
  func writeRxEventCallback(_ value: UARTRxEventCallback?)
}

public struct UARTCallbackDefaults {
  public let transmitHalfComplete: UARTCallback
  public let transmitComplete: UARTCallback
  public let receiveHalfComplete: UARTCallback
  public let receiveComplete: UARTCallback
  public let error: UARTCallback
  public let abortComplete: UARTCallback
  public let abortTransmitComplete: UARTCallback
  public let abortReceiveComplete: UARTCallback
  public let wakeup: UARTCallback
  public let receiveFIFOFull: UARTCallback
  public let transmitFIFOEmpty: UARTCallback
  public let mspInitialize: UARTCallback
  public let mspDeinitialize: UARTCallback
  public let rxEvent: UARTRxEventCallback
  public init(
    transmitHalfComplete: @escaping UARTCallback = { _ in },
    transmitComplete: @escaping UARTCallback = { _ in },
    receiveHalfComplete: @escaping UARTCallback = { _ in },
    receiveComplete: @escaping UARTCallback = { _ in }, error: @escaping UARTCallback = { _ in },
    abortComplete: @escaping UARTCallback = { _ in },
    abortTransmitComplete: @escaping UARTCallback = { _ in },
    abortReceiveComplete: @escaping UARTCallback = { _ in },
    wakeup: @escaping UARTCallback = { _ in }, receiveFIFOFull: @escaping UARTCallback = { _ in },
    transmitFIFOEmpty: @escaping UARTCallback = { _ in },
    mspInitialize: @escaping UARTCallback = { _ in },
    mspDeinitialize: @escaping UARTCallback = { _ in },
    rxEvent: @escaping UARTRxEventCallback = { _, _ in }
  ) {
    self.transmitHalfComplete = transmitHalfComplete
    self.transmitComplete = transmitComplete
    self.receiveHalfComplete = receiveHalfComplete
    self.receiveComplete = receiveComplete
    self.error = error
    self.abortComplete = abortComplete
    self.abortTransmitComplete = abortTransmitComplete
    self.abortReceiveComplete = abortReceiveComplete
    self.wakeup = wakeup
    self.receiveFIFOFull = receiveFIFOFull
    self.transmitFIFOEmpty = transmitFIFOEmpty
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
    self.rxEvent = rxEvent
  }
  public func callback(_ id: UARTCallbackID) -> UARTCallback {
    switch id {
    case .transmitHalfComplete: return transmitHalfComplete
    case .transmitComplete: return transmitComplete
    case .receiveHalfComplete: return receiveHalfComplete
    case .receiveComplete: return receiveComplete
    case .error: return error
    case .abortComplete: return abortComplete
    case .abortTransmitComplete: return abortTransmitComplete
    case .abortReceiveComplete: return abortReceiveComplete
    case .wakeup: return wakeup
    case .receiveFIFOFull: return receiveFIFOFull
    case .transmitFIFOEmpty: return transmitFIFOEmpty
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}

// A no-storage adapter for USE_HAL_UART_REGISTER_CALLBACKS=0. Weak defaults
// are supplied to UART; their context remains caller-owned.
public struct UARTUnregisteredCallbacks: UARTCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: UARTCallbackID) -> UARTCallback? { nil }
  public func write(_ id: UARTCallbackID, value: UARTCallback?) {
    preconditionFailure("Callback storage is absent")
  }
  public func readRxEventCallback() -> UARTRxEventCallback? { nil }
  public func writeRxEventCallback(_ value: UARTRxEventCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}

public enum UARTDMADirection: UInt32, Sendable {
  case transmit = 0
  case receive = 1
}
public enum UARTDMACallbackKind: UInt32, CaseIterable, Sendable {
  case transmitComplete = 0
  case transmitHalfComplete, receiveComplete, receiveHalfComplete
  case error, abortOnError, transmitAbort, receiveAbort, transmitOnlyAbort, receiveOnlyAbort
}
public typealias UARTDMAParentReader =
  @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
public typealias UARTDMADispatcher =
  @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UInt32) -> Void
// The DMA callback's original handle remains distinct from the UART's linked
// handles, including when Parent was changed. Mode/counter reads use this source.
public protocol UARTDMAEventSourceIO {
  func readMode() -> UInt32
  func getCounter() -> UInt32
}
// DMA callback context points to this immutable caller-owned descriptor. Every
// thunk reads the DMA's current Parent, then passes Parent, the original DMA
// context and event to the dispatcher. Parent is never cached here.
public struct UARTDMACallbackContext {
  public let dmaContext: UnsafeMutableRawPointer?
  public let readParent: UARTDMAParentReader
  public let dispatch: UARTDMADispatcher
  public init(
    dmaContext: UnsafeMutableRawPointer?, readParent: @escaping UARTDMAParentReader,
    dispatch: @escaping UARTDMADispatcher
  ) {
    self.dmaContext = dmaContext
    self.readParent = readParent
    self.dispatch = dispatch
  }
}

// A bridge to the existing DMA driver, not another DMA implementation. Methods
// are called only after the same non-null handle checks as the C source.
public protocol UARTDMAIO {
  func isPresent(_ direction: UARTDMADirection) -> Bool
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32
  func getCounter(_ direction: UARTDMADirection) -> UInt32
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32)
  func readCallback(_ direction: UARTDMADirection, id: DMACallbackID) -> DMACallback?
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?)
  func readParent(_ direction: UARTDMADirection) -> UnsafeMutableRawPointer?
  func writeParent(_ direction: UARTDMADirection, value: UnsafeMutableRawPointer?)
  // Exactly one slot read and an unconditional invocation, as at the UART C
  // fallback sites where the callback was just installed. No nil guard.
  func invokeCallback(_ direction: UARTDMADirection, id: DMACallbackID)
  func callback(_ kind: UARTDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32,
    destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus
  func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus
  func suspend(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus
  func resume(_ direction: UARTDMADirection) -> HALStatus
}

public struct UART<
  Registers: UARTRegisterIO, Handle: UARTHandleIO,
  Callbacks: UARTCallbackIO, DMAIO: UARTDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: UARTCallbackDefaults
  public let useRegisteredCallbacks: Bool

  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: UARTCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
}
