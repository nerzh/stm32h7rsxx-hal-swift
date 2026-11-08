// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum CRYPInstance: UInt32, CaseIterable, Sendable {
  case cryp = 0
  case saes = 1
}
public enum CRYPEngineSelection: Sendable { case both, crypOnly, saesOnly }
// Register names with the same byte offset intentionally alias: the C driver
// sometimes accesses an SAES instance through a CRYP_TypeDef cast.
public struct CRYPRegister: RawRepresentable, Hashable, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let cr = Self(rawValue: 0x0)
  public static let sr = Self(rawValue: 0x4)
  public static let din = Self(rawValue: 0x8)
  public static let dout = Self(rawValue: 0xC)
  public static let dmacr = Self(rawValue: 0x10)
  public static let imscr = Self(rawValue: 0x14)
  public static let risr = Self(rawValue: 0x18)
  public static let misr = Self(rawValue: 0x1C)
  public static let k0lr = Self(rawValue: 0x20)
  public static let k0rr = Self(rawValue: 0x24)
  public static let k1lr = Self(rawValue: 0x28)
  public static let k1rr = Self(rawValue: 0x2C)
  public static let k2lr = Self(rawValue: 0x30)
  public static let k2rr = Self(rawValue: 0x34)
  public static let k3lr = Self(rawValue: 0x38)
  public static let k3rr = Self(rawValue: 0x3C)
  public static let iv0lr = Self(rawValue: 0x40)
  public static let iv0rr = Self(rawValue: 0x44)
  public static let iv1lr = Self(rawValue: 0x48)
  public static let iv1rr = Self(rawValue: 0x4C)
  public static let csgcmccm0r = Self(rawValue: 0x50)
  public static let csgcmccm1r = Self(rawValue: 0x54)
  public static let csgcmccm2r = Self(rawValue: 0x58)
  public static let csgcmccm3r = Self(rawValue: 0x5C)
  public static let csgcmccm4r = Self(rawValue: 0x60)
  public static let csgcmccm5r = Self(rawValue: 0x64)
  public static let csgcmccm6r = Self(rawValue: 0x68)
  public static let csgcmccm7r = Self(rawValue: 0x6C)
  public static let csgcm0r = Self(rawValue: 0x70)
  public static let csgcm1r = Self(rawValue: 0x74)
  public static let csgcm2r = Self(rawValue: 0x78)
  public static let csgcm3r = Self(rawValue: 0x7C)
  public static let csgcm4r = Self(rawValue: 0x80)
  public static let csgcm5r = Self(rawValue: 0x84)
  public static let csgcm6r = Self(rawValue: 0x88)
  public static let csgcm7r = Self(rawValue: 0x8C)
  public static let dinr = Self(rawValue: 0x8)
  public static let doutr = Self(rawValue: 0xC)
  public static let keyr0 = Self(rawValue: 0x10)
  public static let keyr1 = Self(rawValue: 0x14)
  public static let keyr2 = Self(rawValue: 0x18)
  public static let keyr3 = Self(rawValue: 0x1C)
  public static let ivr0 = Self(rawValue: 0x20)
  public static let ivr1 = Self(rawValue: 0x24)
  public static let ivr2 = Self(rawValue: 0x28)
  public static let ivr3 = Self(rawValue: 0x2C)
  public static let keyr4 = Self(rawValue: 0x30)
  public static let keyr5 = Self(rawValue: 0x34)
  public static let keyr6 = Self(rawValue: 0x38)
  public static let keyr7 = Self(rawValue: 0x3C)
  public static let susp0r = Self(rawValue: 0x40)
  public static let susp1r = Self(rawValue: 0x44)
  public static let susp2r = Self(rawValue: 0x48)
  public static let susp3r = Self(rawValue: 0x4C)
  public static let susp4r = Self(rawValue: 0x50)
  public static let susp5r = Self(rawValue: 0x54)
  public static let susp6r = Self(rawValue: 0x58)
  public static let susp7r = Self(rawValue: 0x5C)
  public static let ier = Self(rawValue: 0x300)
  public static let isr = Self(rawValue: 0x304)
  public static let icr = Self(rawValue: 0x308)
}
public protocol CRYPRegisterIO {
  var instance: CRYPInstance { get }
  func read(_ register: CRYPRegister) -> UInt32
  func write(_ register: CRYPRegister, value: UInt32)
  func address(of register: CRYPRegister) -> UInt32
}
public enum CRYPConfigurationWord: Int, CaseIterable {
  case dataType = 0
  case keySize = 1
  case algorithm = 2
  case headerSize = 3
  case dataWidthUnit = 4
  case headerWidthUnit = 5
  case keyIVConfigurationSkip = 6
  case keyMode = 7
  case keySelection = 8
}
public enum CRYPHandleWord: Int, CaseIterable {
  case phase = 0
  case lock = 1
  case state = 2
  case errorCode = 3
  case version = 4
  case keyIVConfiguration = 5
  case sizesSum = 6
  case suspendRequest = 7
  case savedInputCount = 8
  case savedOutputCount = 9
  case savedPhase = 10
  case savedState = 11
  case savedControl = 12
  case savedSizesSum = 13
  case resumingFlag = 14
  case suspendedProcessing = 15
}
public enum CRYPHandleHalfWord: Int, CaseIterable {
  case headerCount = 0
  case inputCount = 1
  case outputCount = 2
  case size = 3
  case savedSize = 4
  case savedHeaderCount = 5
}
public enum CRYPPointer: Int, CaseIterable {
  case key = 0
  case initialVector = 1
  case header = 2
  case b0 = 3
  case input = 4
  case output = 5
  case savedKey = 6
  case savedInitialVector = 7
  case savedHeader = 8
  case savedB0 = 9
  case savedInput = 10
  case savedOutput = 11
}
public enum CRYPSavedWords: Int, CaseIterable {
  case initialVector = 0
  case context = 1
  case key = 2
}
public protocol CRYPHandleIO {
  func read(_ word: CRYPConfigurationWord, saved: Bool) -> UInt32
  func write(_ word: CRYPConfigurationWord, saved: Bool, value: UInt32)
  func read(_ word: CRYPHandleWord) -> UInt32
  func write(_ word: CRYPHandleWord, value: UInt32)
  func read(_ word: CRYPHandleHalfWord) -> UInt16
  func write(_ word: CRYPHandleHalfWord, value: UInt16)
  func readPointer(_ pointer: CRYPPointer) -> UnsafeMutablePointer<UInt32>?
  func writePointer(_ pointer: CRYPPointer, value: UnsafeMutablePointer<UInt32>?)
  // Caller-owned arrays with the C widths: IV[4], context[16], key[8].
  func savedWords(_ array: CRYPSavedWords) -> UnsafeMutablePointer<UInt32>
}
extension CRYPHandleIO {
  public func read(_ word: CRYPConfigurationWord) -> UInt32 { read(word, saved: false) }
  public func write(_ word: CRYPConfigurationWord, value: UInt32) {
    write(word, saved: false, value: value)
  }
}
public enum CRYPState: UInt32, CaseIterable, Sendable {
  case reset = 0
  case ready = 1
  case busy = 2
  case suspended = 3
}
public enum CRYPPhase: UInt32, CaseIterable, Sendable {
  case ready = 1
  case process = 2
  case final = 3
  case headerSuspended = 4
  case payloadSuspended = 5
  case headerDMAFeed = 6
}
public struct CRYPError: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let write = Self(rawValue: 0x1)
  public static let read = Self(rawValue: 0x2)
  public static let dma = Self(rawValue: 0x4)
  public static let busy = Self(rawValue: 0x8)
  public static let timeout = Self(rawValue: 0x10)
  public static let notSupported = Self(rawValue: 0x20)
  public static let authTagSequence = Self(rawValue: 0x40)
  public static let invalidCallback = Self(rawValue: 0x80)
  public static let key = Self(rawValue: 0x100)
  public static let rng = Self(rawValue: 0x200)
}
public struct CRYPConfiguration {
  public var dataType: UInt32
  public var keySize: UInt32
  public var key: UnsafeMutablePointer<UInt32>?
  public var initialVector: UnsafeMutablePointer<UInt32>?
  public var algorithm: UInt32
  public var header: UnsafeMutablePointer<UInt32>?
  public var headerSize: UInt32
  public var b0: UnsafeMutablePointer<UInt32>?
  public var dataWidthUnit: UInt32
  public var headerWidthUnit: UInt32
  public var keyIVConfigurationSkip: UInt32
  public var keyMode: UInt32
  public var keySelection: UInt32
  public init(
    dataType: UInt32 = 0, keySize: UInt32 = 0, key: UnsafeMutablePointer<UInt32>? = nil,
    initialVector: UnsafeMutablePointer<UInt32>? = nil, algorithm: UInt32 = 0,
    header: UnsafeMutablePointer<UInt32>? = nil, headerSize: UInt32 = 0,
    b0: UnsafeMutablePointer<UInt32>? = nil, dataWidthUnit: UInt32 = 0, headerWidthUnit: UInt32 = 0,
    keyIVConfigurationSkip: UInt32 = 0, keyMode: UInt32 = 0, keySelection: UInt32 = 0
  ) {
    self.dataType = dataType
    self.keySize = keySize
    self.key = key
    self.initialVector = initialVector
    self.algorithm = algorithm
    self.header = header
    self.headerSize = headerSize
    self.b0 = b0
    self.dataWidthUnit = dataWidthUnit
    self.headerWidthUnit = headerWidthUnit
    self.keyIVConfigurationSkip = keyIVConfigurationSkip
    self.keyMode = keyMode
    self.keySelection = keySelection
  }
}
extension CRYPHandleIO {
  public func setConfiguration(_ configuration: CRYPConfiguration) {
    write(.dataType, value: configuration.dataType)
    write(.keySize, value: configuration.keySize)
    writePointer(.key, value: configuration.key)
    writePointer(.initialVector, value: configuration.initialVector)
    write(.algorithm, value: configuration.algorithm)
    writePointer(.header, value: configuration.header)
    write(.headerSize, value: configuration.headerSize)
    writePointer(.b0, value: configuration.b0)
    write(.dataWidthUnit, value: configuration.dataWidthUnit)
    write(.headerWidthUnit, value: configuration.headerWidthUnit)
    write(.keyIVConfigurationSkip, value: configuration.keyIVConfigurationSkip)
    write(.keyMode, value: configuration.keyMode)
    write(.keySelection, value: configuration.keySelection)
  }
  public func getConfiguration() -> CRYPConfiguration {
    .init(
      dataType: read(.dataType), keySize: read(.keySize), key: readPointer(.key),
      initialVector: readPointer(.initialVector), algorithm: read(.algorithm),
      header: readPointer(.header), headerSize: read(.headerSize), b0: readPointer(.b0),
      dataWidthUnit: read(.dataWidthUnit), headerWidthUnit: read(.headerWidthUnit),
      keyIVConfigurationSkip: read(.keyIVConfigurationSkip), keyMode: read(.keyMode),
      keySelection: read(.keySelection))
  }
}
public typealias CRYPCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public enum CRYPCallbackID: UInt32, CaseIterable {
  case inputComplete = 1
  case outputComplete = 2
  case error = 3
  case mspInitialize = 4
  case mspDeinitialize = 5
}
public protocol CRYPCallbackIO {
  var context: UnsafeMutableRawPointer? { get }
  func read(_ id: CRYPCallbackID) -> CRYPCallback?
  func write(_ id: CRYPCallbackID, value: CRYPCallback?)
}
public struct CRYPCallbackDefaults {
  public let inputComplete: CRYPCallback
  public let outputComplete: CRYPCallback
  public let error: CRYPCallback
  public let mspInitialize: CRYPCallback
  public let mspDeinitialize: CRYPCallback
  public init(
    inputComplete: @escaping CRYPCallback = { _ in },
    outputComplete: @escaping CRYPCallback = { _ in }, error: @escaping CRYPCallback = { _ in },
    mspInitialize: @escaping CRYPCallback = { _ in },
    mspDeinitialize: @escaping CRYPCallback = { _ in }
  ) {
    self.inputComplete = inputComplete
    self.outputComplete = outputComplete
    self.error = error
    self.mspInitialize = mspInitialize
    self.mspDeinitialize = mspDeinitialize
  }
  public func callback(_ id: CRYPCallbackID) -> CRYPCallback {
    switch id {
    case .inputComplete: return inputComplete
    case .outputComplete: return outputComplete
    case .error: return error
    case .mspInitialize: return mspInitialize
    case .mspDeinitialize: return mspDeinitialize
    }
  }
}
public struct CRYPUnregisteredCallbacks: CRYPCallbackIO {
  public let context: UnsafeMutableRawPointer?
  public init(context: UnsafeMutableRawPointer? = nil) { self.context = context }
  public func read(_ id: CRYPCallbackID) -> CRYPCallback? { nil }
  public func write(_ id: CRYPCallbackID, value: CRYPCallback?) {
    preconditionFailure("Callback storage is absent")
  }
}
public enum CRYPStream: UInt32, CaseIterable {
  case input = 0
  case output = 1
}
public enum CRYPDMACallbackKind: UInt32, CaseIterable {
  case inputComplete = 0
  case outputComplete = 1
  case error = 2
}
public protocol CRYPDMAIO {
  func read(_ stream: CRYPStream, word: DMAHandleWord) -> UInt32
  func readMemory32(_ stream: CRYPStream, at address: UInt32) -> UInt32
  func writeMemory32(_ stream: CRYPStream, at address: UInt32, value: UInt32)
  func writeCallback(_ stream: CRYPStream, id: DMACallbackID, value: DMACallback?)
  func callback(_ kind: CRYPDMACallbackKind) -> DMACallback
  func startInterrupt(
    _ stream: CRYPStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32
  ) -> HALStatus
  func startLinkedListInterrupt(_ stream: CRYPStream) -> HALStatus
  func abort(_ stream: CRYPStream, getTick: () -> UInt32) -> HALStatus
  func getCounter(_ stream: CRYPStream) -> UInt32
  func getFIFOLevel(_ stream: CRYPStream) -> UInt32
}
public struct CRYP<
  Registers: CRYPRegisterIO, Handle: CRYPHandleIO, Callbacks: CRYPCallbackIO, DMAIO: CRYPDMAIO
> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let dma: DMAIO
  public let defaults: CRYPCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public let useSuspendResume: Bool
  public let engines: CRYPEngineSelection
  public init(
    registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
    defaults: CRYPCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false,
    useSuspendResume: Bool = false, engines: CRYPEngineSelection = .both
  ) {
    self.registers = registers
    self.handle = handle
    self.callbacks = callbacks
    self.dma = dma
    self.defaults = defaults
    self.useRegisteredCallbacks = useRegisteredCallbacks
    self.useSuspendResume = useSuspendResume
    self.engines = engines
  }
}
