// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SAIRegister: UInt32, CaseIterable {
  case cr1 = 0
  case cr2 = 4
  case frcr = 8
  case slotr = 12
  case imr = 16
  case sr = 20
  case clrfr = 24
  case dr = 28
}
public enum SAIInstance: UInt32, CaseIterable {
  case sai1A = 1_107_318_788
  case sai1B = 1_107_318_820
  case sai2A = 1_107_319_812
  case sai2B = 1_107_319_844
}
public enum SAIPeripheral: UInt32, CaseIterable {
  case sai1 = 1
  case sai2 = 2
}
public enum SAIGlobalRegister: UInt32, CaseIterable {
  case gcr = 0
  case pdmcr = 68
  case pdmdly = 72
}
public protocol SAIRegisterIO {
  var instance: SAIInstance { get }
  func read(_ register: SAIRegister) -> UInt32
  func write(_ register: SAIRegister, value: UInt32)
  func address(of register: SAIRegister) -> UInt32
  func readGlobal(_ peripheral: SAIPeripheral, _ register: SAIGlobalRegister) -> UInt32
  func writeGlobal(_ peripheral: SAIPeripheral, _ register: SAIGlobalRegister, value: UInt32)
}
public enum SAIConfigurationWord: Int, CaseIterable {
  case audioMode = 0
  case synchronization = 1
  case externalSynchronization = 2
  case masterClockOutput = 3
  case outputDrive = 4
  case noDivider = 5
  case fifoThreshold = 6
  case audioFrequency = 7
  case masterClockDivider = 8
  case masterClockOversampling = 9
  case monoStereoMode = 10
  case compandingMode = 11
  case triState = 12
  case pdmActivation = 13
  case pdmMicrophonePairs = 14
  case pdmClockEnable = 15
  case protocolMode = 16
  case dataSize = 17
  case firstBit = 18
  case clockStrobing = 19
}
public enum SAIHandleWord: Int, CaseIterable {
  case lock = 0
  case state = 1
  case errorCode = 2
  case transferISR = 3
}
public enum SAIHandleHalfWord: Int, CaseIterable {
  case transferSize = 0
  case transferCount = 1
}
public enum SAIFrameWord: Int, CaseIterable {
  case frameLength = 0
  case activeFrameLength = 1
  case frameSyncDefinition = 2
  case frameSyncPolarity = 3
  case frameSyncOffset = 4
}
public enum SAISlotWord: Int, CaseIterable {
  case firstBitOffset = 0
  case slotSize = 1
  case slotCount = 2
  case activeSlots = 3
}
public enum SAITransferISR: UInt32, CaseIterable {
  case none = 0
  case transmit8 = 1
  case transmit16 = 2
  case transmit32 = 3
  case receive8 = 4
  case receive16 = 5
  case receive32 = 6
}
public struct SAIConfiguration: Equatable, Sendable {
  public var audioMode: UInt32
  public var synchronization: UInt32
  public var externalSynchronization: UInt32
  public var masterClockOutput: UInt32
  public var outputDrive: UInt32
  public var noDivider: UInt32
  public var fifoThreshold: UInt32
  public var audioFrequency: UInt32
  public var masterClockDivider: UInt32
  public var masterClockOversampling: UInt32
  public var monoStereoMode: UInt32
  public var compandingMode: UInt32
  public var triState: UInt32
  public var pdmActivation: UInt32
  public var pdmMicrophonePairs: UInt32
  public var pdmClockEnable: UInt32
  public var protocolMode: UInt32
  public var dataSize: UInt32
  public var firstBit: UInt32
  public var clockStrobing: UInt32
  public init(
    audioMode: UInt32 = 0, synchronization: UInt32 = 0, externalSynchronization: UInt32 = 0,
    masterClockOutput: UInt32 = 0, outputDrive: UInt32 = 0, noDivider: UInt32 = 0,
    fifoThreshold: UInt32 = 0, audioFrequency: UInt32 = 0, masterClockDivider: UInt32 = 0,
    masterClockOversampling: UInt32 = 0, monoStereoMode: UInt32 = 0, compandingMode: UInt32 = 0,
    triState: UInt32 = 0, pdmActivation: UInt32 = 0, pdmMicrophonePairs: UInt32 = 0,
    pdmClockEnable: UInt32 = 0, protocolMode: UInt32 = 0, dataSize: UInt32 = 0,
    firstBit: UInt32 = 0, clockStrobing: UInt32 = 0
  ) {
    self.audioMode = audioMode
    self.synchronization = synchronization
    self.externalSynchronization = externalSynchronization
    self.masterClockOutput = masterClockOutput
    self.outputDrive = outputDrive
    self.noDivider = noDivider
    self.fifoThreshold = fifoThreshold
    self.audioFrequency = audioFrequency
    self.masterClockDivider = masterClockDivider
    self.masterClockOversampling = masterClockOversampling
    self.monoStereoMode = monoStereoMode
    self.compandingMode = compandingMode
    self.triState = triState
    self.pdmActivation = pdmActivation
    self.pdmMicrophonePairs = pdmMicrophonePairs
    self.pdmClockEnable = pdmClockEnable
    self.protocolMode = protocolMode
    self.dataSize = dataSize
    self.firstBit = firstBit
    self.clockStrobing = clockStrobing
  }
}
public struct SAIFrameConfiguration: Equatable, Sendable {
  public var frameLength: UInt32
  public var activeFrameLength: UInt32
  public var frameSyncDefinition: UInt32
  public var frameSyncPolarity: UInt32
  public var frameSyncOffset: UInt32
  public init(
    frameLength: UInt32 = 0, activeFrameLength: UInt32 = 0, frameSyncDefinition: UInt32 = 0,
    frameSyncPolarity: UInt32 = 0, frameSyncOffset: UInt32 = 0
  ) {
    self.frameLength = frameLength
    self.activeFrameLength = activeFrameLength
    self.frameSyncDefinition = frameSyncDefinition
    self.frameSyncPolarity = frameSyncPolarity
    self.frameSyncOffset = frameSyncOffset
  }
}
public struct SAISlotConfiguration: Equatable, Sendable {
  public var firstBitOffset: UInt32
  public var slotSize: UInt32
  public var slotCount: UInt32
  public var activeSlots: UInt32
  public init(
    firstBitOffset: UInt32 = 0, slotSize: UInt32 = 0, slotCount: UInt32 = 0, activeSlots: UInt32 = 0
  ) {
    self.firstBitOffset = firstBitOffset
    self.slotSize = slotSize
    self.slotCount = slotCount
    self.activeSlots = activeSlots
  }
}
public struct SAIPDMMicrophoneDelay: Equatable, Sendable {
  public var microphonePair: UInt32
  public var leftDelay: UInt32
  public var rightDelay: UInt32
  public init(microphonePair: UInt32 = 0, leftDelay: UInt32 = 0, rightDelay: UInt32 = 0) {
    self.microphonePair = microphonePair
    self.leftDelay = leftDelay
    self.rightDelay = rightDelay
  }
}
public protocol SAIHandleIO {
  func read(_ word: SAIConfigurationWord) -> UInt32
  func write(_ word: SAIConfigurationWord, value: UInt32)
  func read(_ word: SAIHandleWord) -> UInt32
  func write(_ word: SAIHandleWord, value: UInt32)
  func read(_ word: SAIHandleHalfWord) -> UInt16
  func write(_ word: SAIHandleHalfWord, value: UInt16)
  func read(_ word: SAIFrameWord) -> UInt32
  func write(_ word: SAIFrameWord, value: UInt32)
  func read(_ word: SAISlotWord) -> UInt32
  func write(_ word: SAISlotWord, value: UInt32)
  func readBuffer() -> UnsafeMutablePointer<UInt8>?
  func writeBuffer(_ value: UnsafeMutablePointer<UInt8>?)
}
extension SAIHandleIO {
  public func setConfiguration(_ value: SAIConfiguration) {
    write(.audioMode, value: value.audioMode)
    write(.synchronization, value: value.synchronization)
    write(.externalSynchronization, value: value.externalSynchronization)
    write(.masterClockOutput, value: value.masterClockOutput)
    write(.outputDrive, value: value.outputDrive)
    write(.noDivider, value: value.noDivider)
    write(.fifoThreshold, value: value.fifoThreshold)
    write(.audioFrequency, value: value.audioFrequency)
    write(.masterClockDivider, value: value.masterClockDivider)
    write(.masterClockOversampling, value: value.masterClockOversampling)
    write(.monoStereoMode, value: value.monoStereoMode)
    write(.compandingMode, value: value.compandingMode)
    write(.triState, value: value.triState)
    write(.pdmActivation, value: value.pdmActivation)
    write(.pdmMicrophonePairs, value: value.pdmMicrophonePairs)
    write(.pdmClockEnable, value: value.pdmClockEnable)
    write(.protocolMode, value: value.protocolMode)
    write(.dataSize, value: value.dataSize)
    write(.firstBit, value: value.firstBit)
    write(.clockStrobing, value: value.clockStrobing)
  }
}
extension SAIHandleIO {
  public func setFrame(_ value: SAIFrameConfiguration) {
    write(.frameLength, value: value.frameLength)
    write(.activeFrameLength, value: value.activeFrameLength)
    write(.frameSyncDefinition, value: value.frameSyncDefinition)
    write(.frameSyncPolarity, value: value.frameSyncPolarity)
    write(.frameSyncOffset, value: value.frameSyncOffset)
  }
}
extension SAIHandleIO {
  public func setSlots(_ value: SAISlotConfiguration) {
    write(.firstBitOffset, value: value.firstBitOffset)
    write(.slotSize, value: value.slotSize)
    write(.slotCount, value: value.slotCount)
    write(.activeSlots, value: value.activeSlots)
  }
}
public typealias SAICallback = UARTCallback
public enum SAICallbackID: UInt32, CaseIterable {
  case receiveComplete = 0
  case receiveHalfComplete = 1
  case transmitComplete = 2
  case transmitHalfComplete = 3
  case error = 4
  case mspInitialize = 5
  case mspDeinitialize = 6
}
public protocol SAICallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: SAICallbackID) -> SAICallback?
  func write(_ id: SAICallbackID, value: SAICallback?)
  func readMute() -> SAIMuteCallback?
  func writeMute(_ value: SAIMuteCallback?)
}
public typealias SAIMuteCallback = @convention(c) () -> Void
public struct SAICallbackDefaults {
  public var receiveComplete: SAICallback
  public var receiveHalfComplete: SAICallback
  public var transmitComplete: SAICallback
  public var transmitHalfComplete: SAICallback
  public var error: SAICallback
  public var mspInitialize: SAICallback
  public var mspDeinitialize: SAICallback
  public init(
    receiveComplete: @escaping SAICallback = { _ in },
    receiveHalfComplete: @escaping SAICallback = { _ in },
    transmitComplete: @escaping SAICallback = { _ in },
    transmitHalfComplete: @escaping SAICallback = { _ in }, error: @escaping SAICallback = { _ in },
    mspInitialize: @escaping SAICallback = { _ in },
    mspDeinitialize: @escaping SAICallback = { _ in }
  ) {
    self.receiveComplete = receiveComplete
    self.receiveHalfComplete = receiveHalfComplete
    self.transmitComplete = transmitComplete
    self.transmitHalfComplete = transmitHalfComplete
    self.error = error
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  func callback(_ id: SAICallbackID) -> SAICallback {
    switch id {
    case .receiveComplete: return receiveComplete
    case .receiveHalfComplete: return receiveHalfComplete
    case .transmitComplete: return transmitComplete
    case .transmitHalfComplete: return transmitHalfComplete
    case .error: return error
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public enum SAIDMACallbackKind: UInt32, CaseIterable {
  case transmitComplete = 0
  case transmitHalfComplete = 1
  case receiveComplete = 2
  case receiveHalfComplete = 3
  case error = 4
  case abort = 5
}
public typealias SAIDMACallbackContext = UARTDMACallbackContext
public typealias SAIDMAEventSourceIO = UARTDMAEventSourceIO
public protocol SAIDMAIO {
  func isPresent(_ direction: UARTDMADirection) -> Bool
  func read(_ direction: UARTDMADirection, word: DMAHandleWord) -> UInt32
  func readMemory32(_ direction: UARTDMADirection, at address: UInt32) -> UInt32
  func writeMemory32(_ direction: UARTDMADirection, at address: UInt32, value: UInt32)
  func writeCallback(_ direction: UARTDMADirection, id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: SAIDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ direction: UARTDMADirection, sourceAddress: UInt32, destinationAddress: UInt32,
    sourceDataSize: UInt32
  ) -> HALStatus
  func startLinkedListInterrupt(_ direction: UARTDMADirection) -> HALStatus
  func abort(_ direction: UARTDMADirection, getTick: () -> UInt32) -> HALStatus
  func abortInterrupt(_ direction: UARTDMADirection) -> HALStatus
}
public struct SAI<
  Registers: SAIRegisterIO, Handle: SAIHandleIO, Callbacks: SAICallbackIO, DMAIO: SAIDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: SAICallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: SAICallbackDefaults = .init(), useRegisteredCallbacks: Bool = false
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
  }
  func lock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func invoke(_ id: SAICallbackID) {
    (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
  }
  func modify(_ register: SAIRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
