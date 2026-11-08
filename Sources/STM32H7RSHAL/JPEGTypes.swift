// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// JPEG operations and definitions from stm32h7rsxx_hal_jpeg.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum JPEGRegister: UInt32, CaseIterable, Sendable {
    case confr0 = 0, confr1 = 4, confr2 = 8, confr3 = 12, confr4 = 16, confr5 = 20, confr6 = 24, confr7 = 28
    case cr = 0x30, sr = 0x34, cfr = 0x38, dir = 0x40, dor = 0x44
}
public enum JPEGTable: UInt32, CaseIterable, Sendable {
    case quantization0 = 0x50, quantization1 = 0x90, quantization2 = 0xD0, quantization3 = 0x110
    case huffmanMinimum = 0x150, huffmanBase = 0x190, huffmanSymbols = 0x210, dht = 0x360
    case ac0 = 0x500, ac1 = 0x660, dc0 = 0x7C0, dc1 = 0x7E0
    public var wordCount: Int {
        switch self {
        case .quantization0, .quantization1, .quantization2, .quantization3, .huffmanMinimum: return 16
        case .huffmanBase: return 32
        case .huffmanSymbols: return 84
        case .dht: return 103
        case .ac0, .ac1: return 88
        case .dc0, .dc1: return 8
        }
    }
}
public protocol JPEGRegisterIO {
    func read(_ register: JPEGRegister) -> UInt32
    func write(_ register: JPEGRegister, value: UInt32)
    func readTable(_ table: JPEGTable, index: Int) -> UInt32
    func writeTable(_ table: JPEGTable, index: Int, value: UInt32)
    func dataAddress(_ stream: JPEGStream) -> UInt32
}
public enum JPEGHandleWord: Int, CaseIterable {
    case colorSpace = 0, chromaSubsampling, imageHeight, imageWidth, imageQuality
    case inputCount, outputCount, inputLength, outputLength, customQuantizationTable, lock, state, errorCode, context
}
public enum JPEGStream: UInt32, CaseIterable { case input = 0, output = 1 }
public protocol JPEGHandleIO {
    func read(_ word: JPEGHandleWord) -> UInt32
    func write(_ word: JPEGHandleWord, value: UInt32)
    func readBuffer(_ stream: JPEGStream) -> UnsafeMutablePointer<UInt8>?
    func writeBuffer(_ stream: JPEGStream, value: UnsafeMutablePointer<UInt8>?)
    func readQuantizationTable(_ index: Int) -> UnsafePointer<UInt8>?
    func writeQuantizationTable(_ index: Int, value: UnsafePointer<UInt8>?)
    // Live caller-owned configuration: color space, subsampling, height, width, quality.
    var configurationPointer: UnsafeMutablePointer<UInt32> { get }
}
public enum JPEGState: UInt32, CaseIterable, Sendable { case reset = 0, ready, busy, encoding, decoding, timeout, error }
public enum JPEGColorSpace: UInt32, CaseIterable, Sendable { case grayscale = 0, ycbcr = 0x10, cmyk = 0x30 }
public enum JPEGChromaSubsampling: UInt32, CaseIterable, Sendable { case sampling444 = 0, sampling420 = 1, sampling422 = 2 }
public struct JPEGInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let inputThreshold = Self(rawValue: 2)
    public static let inputNotFull = Self(rawValue: 4)
    public static let outputThreshold = Self(rawValue: 8)
    // The pinned HAL defines JPEG_IT_OFNE as OFTIE, not OFNEIE.
    public static let outputNotEmpty = Self(rawValue: 8)
    public static let endOfConversion = Self(rawValue: 0x20)
    public static let headerParsingDone = Self(rawValue: 0x40)
}
public struct JPEGFlags: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let inputThreshold = Self(rawValue: 2)
    public static let inputNotFull = Self(rawValue: 4)
    public static let outputThreshold = Self(rawValue: 8)
    public static let outputNotEmpty = Self(rawValue: 0x10)
    public static let endOfConversion = Self(rawValue: 0x20)
    public static let headerParsingDone = Self(rawValue: 0x40)
    public static let operationOngoing = Self(rawValue: 0x80)
    public static let all = Self(rawValue: 0xFE)
}
public enum JPEGTransferSelection: UInt32, CaseIterable, Sendable { case input = 1, output = 2, inputAndOutput = 3 }
public struct JPEGConfiguration: Equatable, Sendable {
    public static let minimumQuality: UInt32 = 1
    public static let maximumQuality: UInt32 = 100
    public static let quantizationTableSize = 64
    public var colorSpace: UInt32
    public var chromaSubsampling: UInt32
    public var imageHeight: UInt32
    public var imageWidth: UInt32
    public var imageQuality: UInt32
    public init(colorSpace: UInt32 = 0, chromaSubsampling: UInt32 = 0, imageHeight: UInt32, imageWidth: UInt32, imageQuality: UInt32 = 75) {
        self.colorSpace = colorSpace; self.chromaSubsampling = chromaSubsampling
        self.imageHeight = imageHeight; self.imageWidth = imageWidth; self.imageQuality = imageQuality
    }
}
public struct JPEGError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let huffmanTable = Self(rawValue: 1)
    public static let quantizationTable = Self(rawValue: 2)
    public static let dma = Self(rawValue: 4)
    public static let timeout = Self(rawValue: 8)
    public static let invalidCallback = Self(rawValue: 16)
}
public enum JPEGDMACallbackKind: UInt32, CaseIterable { case inputComplete = 0, outputComplete, error, outputAbort }
public protocol JPEGDMAIO {
    func read(_ stream: JPEGStream, word: DMAHandleWord) -> UInt32
    func readMemory32(_ stream: JPEGStream, at address: UInt32) -> UInt32
    func writeMemory32(_ stream: JPEGStream, at address: UInt32, value: UInt32)
    func writeCallback(_ stream: JPEGStream, id: DMACallbackID, value: DMACallback?)
    func callback(_ kind: JPEGDMACallbackKind) -> DMACallback
    func startInterrupt(_ stream: JPEGStream, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus
    func startLinkedListInterrupt(_ stream: JPEGStream) -> HALStatus
    func abort(_ stream: JPEGStream, getTick: () -> UInt32) -> HALStatus
    func abortInterrupt(_ stream: JPEGStream) -> HALStatus
    func getCounter(_ stream: JPEGStream) -> UInt32
    func getFIFOLevel(_ stream: JPEGStream) -> UInt32
}
public struct JPEG<Registers: JPEGRegisterIO, Handle: JPEGHandleIO, Callbacks: JPEGCallbackIO, DMAIO: JPEGDMAIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let dma: DMAIO
    public let defaults: JPEGCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
                defaults: JPEGCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks; self.dma = dma
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}

public protocol JPEGDMAEventSourceIO {
    func getCounter() -> UInt32
    func getFIFOLevel() -> UInt32
    func getError() -> DMAError
}
extension DMA: JPEGDMAEventSourceIO {}
public struct JPEGDMACallbackContext {
    public let dmaContext: UnsafeMutableRawPointer?
    public let readParent: @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
    public let dispatch: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UInt32) -> Void
    public init(dmaContext: UnsafeMutableRawPointer?,
                readParent: @escaping @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?,
                dispatch: @escaping @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UInt32) -> Void) {
        self.dmaContext = dmaContext; self.readParent = readParent; self.dispatch = dispatch
    }
}
