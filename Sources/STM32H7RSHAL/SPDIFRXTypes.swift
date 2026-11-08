// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPDIFRX operations and definitions from stm32h7rsxx_hal_spdifrx.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum SPDIFRXRegister: UInt32, CaseIterable, Sendable { case cr = 0, imr = 4, sr = 8, ifcr = 12, dr = 16, csr = 20, dir = 24 }
public enum SPDIFRXStream: UInt32, CaseIterable, Sendable { case data = 0, control = 1 }
public protocol SPDIFRXRegisterIO {
    func read(_ register: SPDIFRXRegister) -> UInt32
    func write(_ register: SPDIFRXRegister, value: UInt32)
    func dataAddress(_ stream: SPDIFRXStream) -> UInt32
    // The C interrupt/DMA start routines read SPDIFRX->CR, not Instance->CR.
    func readPeripheralControl() -> UInt32
}
public extension SPDIFRXRegisterIO { func readPeripheralControl() -> UInt32 { read(.cr) } }
public enum SPDIFRXHandleWord: Int, CaseIterable {
    case inputSelection = 0
    case retries = 1
    case waitForActivity = 2
    case channelSelection = 3
    case dataFormat = 4
    case stereoMode = 5
    case preambleTypeMask = 6
    case channelStatusMask = 7
    case validityBitMask = 8
    case parityErrorMask = 9
    case symbolClockGeneration = 10
    case backupSymbolClockGeneration = 11
    case receiveSize = 12
    case receiveCount = 13
    case controlSize = 14
    case controlCount = 15
    case lock = 16
    case state = 17
    case errorCode = 18
}
public protocol SPDIFRXHandleIO {
    func read(_ word: SPDIFRXHandleWord) -> UInt32
    func write(_ word: SPDIFRXHandleWord, value: UInt32)
    func readBuffer(_ stream: SPDIFRXStream) -> UnsafeMutablePointer<UInt32>?
    func writeBuffer(_ stream: SPDIFRXStream, value: UnsafeMutablePointer<UInt32>?)
}
public enum SPDIFRXState: UInt32, CaseIterable, Sendable { case reset = 0, ready = 1, busy = 2, busyReceive = 3, busyControl = 4, error = 7 }
public enum SPDIFRXInput: UInt32, CaseIterable, Sendable { case input0 = 0, input1 = 0x10000, input2 = 0x20000, input3 = 0x30000 }
public enum SPDIFRXRetries: UInt32, CaseIterable, Sendable { case none = 0, retries3 = 0x1000, retries15 = 0x2000, retries63 = 0x3000 }
public enum SPDIFRXChannel: UInt32, CaseIterable, Sendable { case channelA = 0, channelB = 0x800 }
public enum SPDIFRXDataFormat: UInt32, CaseIterable, Sendable { case lsb = 0, msb = 0x10, bits32 = 0x20 }
public struct SPDIFRXError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let timeout = Self(rawValue: 1)
    public static let overrun = Self(rawValue: 2)
    public static let parity = Self(rawValue: 4)
    public static let dma = Self(rawValue: 8)
    public static let unknown = Self(rawValue: 16)
    public static let invalidCallback = Self(rawValue: 32)
}
public struct SPDIFRXInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let receive = Self(rawValue: 1)
    public static let control = Self(rawValue: 2)
    public static let parity = Self(rawValue: 4)
    public static let overrun = Self(rawValue: 8)
    public static let block = Self(rawValue: 16)
    public static let synchronization = Self(rawValue: 32)
    public static let interfaceError = Self(rawValue: 64)
}
public struct SPDIFRXFlags: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let receive = Self(rawValue: 1)
    public static let control = Self(rawValue: 2)
    public static let parity = Self(rawValue: 4)
    public static let overrun = Self(rawValue: 8)
    public static let block = Self(rawValue: 16)
    public static let synchronization = Self(rawValue: 32)
    public static let frameError = Self(rawValue: 64)
    public static let synchronizationError = Self(rawValue: 128)
    public static let timeoutError = Self(rawValue: 256)
}
public struct SPDIFRXConfiguration: Equatable, Sendable {
    public var inputSelection: UInt32
    public var retries: UInt32
    public var waitForActivity: UInt32
    public var channelSelection: UInt32
    public var dataFormat: UInt32
    public var stereoMode: UInt32
    public var preambleTypeMask: UInt32
    public var channelStatusMask: UInt32
    public var validityBitMask: UInt32
    public var parityErrorMask: UInt32
    public var symbolClockGeneration: UInt32
    public var backupSymbolClockGeneration: UInt32
    public init(inputSelection: UInt32 = 0, retries: UInt32 = 0, waitForActivity: UInt32 = 0, channelSelection: UInt32 = 0, dataFormat: UInt32 = 0, stereoMode: UInt32 = 0, preambleTypeMask: UInt32 = 0, channelStatusMask: UInt32 = 0, validityBitMask: UInt32 = 0, parityErrorMask: UInt32 = 0, symbolClockGeneration: UInt32 = 0, backupSymbolClockGeneration: UInt32 = 0) {
        self.inputSelection = inputSelection
        self.retries = retries
        self.waitForActivity = waitForActivity
        self.channelSelection = channelSelection
        self.dataFormat = dataFormat
        self.stereoMode = stereoMode
        self.preambleTypeMask = preambleTypeMask
        self.channelStatusMask = channelStatusMask
        self.validityBitMask = validityBitMask
        self.parityErrorMask = parityErrorMask
        self.symbolClockGeneration = symbolClockGeneration
        self.backupSymbolClockGeneration = backupSymbolClockGeneration
    }
}
public struct SPDIFRXFormatConfiguration: Equatable, Sendable {
    public var dataFormat: UInt32
    public var stereoMode: UInt32
    public var preambleTypeMask: UInt32
    public var channelStatusMask: UInt32
    public var validityBitMask: UInt32
    public var parityErrorMask: UInt32
    public init(dataFormat: UInt32 = 0, stereoMode: UInt32 = 0, preambleTypeMask: UInt32 = 0, channelStatusMask: UInt32 = 0, validityBitMask: UInt32 = 0, parityErrorMask: UInt32 = 0) {
        self.dataFormat = dataFormat
        self.stereoMode = stereoMode
        self.preambleTypeMask = preambleTypeMask
        self.channelStatusMask = channelStatusMask
        self.validityBitMask = validityBitMask
        self.parityErrorMask = parityErrorMask
    }
}
public enum SPDIFRXDMACallbackKind: UInt32, CaseIterable { case receiveComplete = 0, receiveHalf = 1, controlComplete = 2, controlHalf = 3, error = 4 }
public protocol SPDIFRXDMAIO {
    func isPresent(_ stream: SPDIFRXStream) -> Bool
    func read(_ stream: SPDIFRXStream, word: DMAHandleWord) -> UInt32
    func readMemory32(_ stream: SPDIFRXStream, at address: UInt32) -> UInt32
    func writeMemory32(_ stream: SPDIFRXStream, at address: UInt32, value: UInt32)
    func writeCallback(_ stream: SPDIFRXStream, id: DMACallbackID, value: DMACallback?)
    func callback(_ kind: SPDIFRXDMACallbackKind) -> DMACallback
    func startInterrupt(_ stream: SPDIFRXStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus
    func startLinkedListInterrupt(_ stream: SPDIFRXStream) -> HALStatus
    func disable(_ stream: SPDIFRXStream)
}
public struct SPDIFRXDMACallbackContext {
    public let dmaContext: UnsafeMutableRawPointer?
    public let readParent: @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
    public let readMode: @convention(c) (UnsafeMutableRawPointer?) -> UInt32
    public let dispatch: @convention(c) (UnsafeMutableRawPointer?, UInt32, UInt32) -> Void
    public init(dmaContext: UnsafeMutableRawPointer?,
                readParent: @escaping @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?,
                readMode: @escaping @convention(c) (UnsafeMutableRawPointer?) -> UInt32,
                dispatch: @escaping @convention(c) (UnsafeMutableRawPointer?, UInt32, UInt32) -> Void) {
        self.dmaContext = dmaContext; self.readParent = readParent; self.readMode = readMode; self.dispatch = dispatch
    }
}
public struct SPDIFRX<Registers: SPDIFRXRegisterIO, Handle: SPDIFRXHandleIO, Callbacks: SPDIFRXCallbackIO, DMAIO: SPDIFRXDMAIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let dma: DMAIO
    public let defaults: SPDIFRXCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
                defaults: SPDIFRXCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks; self.dma = dma
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
