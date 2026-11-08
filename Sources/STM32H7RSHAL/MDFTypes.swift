// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum MDFRegister: UInt32, CaseIterable, Sendable {
    case gcr = 0x0
    case ckgcr = 0x4
    case sitfcr = 0x80
    case bsmxcr = 0x84
    case dfltcr = 0x88
    case dfltcicr = 0x8C
    case dfltrsfr = 0x90
    case dlycr = 0xA4
    case dfltier = 0xAC
    case dfltisr = 0xB0
    case sadcr = 0xB8
    case sadcfgr = 0xBC
    case sadsdlvr = 0xC0
    case sadanlvr = 0xC4
    case dfltdr = 0xF0
}
public protocol MDFRegisterIO {
    func read(_ register: MDFRegister) -> UInt32
    func write(_ register: MDFRegister, value: UInt32)
    func dataAddress() -> UInt32
}
public enum MDFHandleWord: Int, CaseIterable {
    case processClockDivider = 0
    case outputClockActivation = 1
    case outputClockPins = 2
    case outputClockDivider = 3
    case clockTriggerActivation = 4
    case clockTriggerSource = 5
    case clockTriggerEdge = 6
    case serialInterfaceActivation = 7
    case serialMode = 8
    case serialClockSource = 9
    case serialThreshold = 10
    case filterBitstream = 11
    case state = 12
    case errorCode = 13
}
public protocol MDFHandleIO {
    var identity: UInt { get }
    func read(_ word: MDFHandleWord) -> UInt32
    func write(_ word: MDFHandleWord, value: UInt32)
}
// All handles for the single ADF1 filter must share this registration storage.
// It represents the upstream file's v_mdfHandle, independently of handle State.
public protocol MDFSharedIO {
    func readRegisteredHandle() -> UInt
    func writeRegisteredHandle(_ identity: UInt)
}
public enum MDFState: UInt32, CaseIterable, Sendable { case reset = 0, ready = 1, acquisition = 2, error = 255 }
public enum MDFAcquisitionMode: UInt32, CaseIterable, Sendable {
    case asynchronousContinuous = 0, asynchronousSingle = 0x10, synchronousContinuous = 0x20, synchronousSingle = 0x30, windowContinuous = 0x40
}
public enum MDFSerialMode: UInt32, CaseIterable, Sendable { case lowFrequencyMasterSPI = 0, normalSPI = 0x10, manchesterFalling = 0x20, manchesterRising = 0x30 }
public enum MDFDataSource: UInt32, CaseIterable, Sendable { case bitstream = 0, adcInterface1 = 2, adcInterface2 = 3 }
public enum MDFCICMode: UInt32, CaseIterable, Sendable { case sinc4 = 0x40, sinc5 = 0x50 }
public enum MDFSoundActivityMode: UInt32, CaseIterable, Sendable { case voice = 0, sound = 0x1000, ambientNoise = 0x3000 }
public struct MDFError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let acquisitionOverflow = Self(rawValue: 1)
    public static let reshapeOverrun = Self(rawValue: 2)
    public static let clockAbsence = Self(rawValue: 4)
    public static let saturation = Self(rawValue: 16)
    public static let dma = Self(rawValue: 64)
    public static let invalidCallback = Self(rawValue: 128)
}
public struct MDFTrigger: Equatable, Sendable {
    public var source: UInt32
    public var edge: UInt32
    public init(source: UInt32 = 0, edge: UInt32 = 0) {
        self.source = source
        self.edge = edge
    }
}
public struct MDFClockTrigger: Equatable, Sendable {
    public var activation: UInt32
    public var source: UInt32
    public var edge: UInt32
    public init(activation: UInt32 = 0, source: UInt32 = 0, edge: UInt32 = 0) {
        self.activation = activation
        self.source = source
        self.edge = edge
    }
}
public struct MDFOutputClock: Equatable, Sendable {
    public var activation: UInt32
    public var pins: UInt32
    public var divider: UInt32
    public var trigger: MDFClockTrigger
    public init(activation: UInt32 = 0, pins: UInt32 = 0x20, divider: UInt32 = 1, trigger: MDFClockTrigger = .init()) {
        self.activation = activation
        self.pins = pins
        self.divider = divider
        self.trigger = trigger
    }
}
public struct MDFSerialInterface: Equatable, Sendable {
    public var activation: UInt32
    public var mode: UInt32
    public var clockSource: UInt32
    public var threshold: UInt32
    public init(activation: UInt32 = 0, mode: UInt32 = 0, clockSource: UInt32 = 0, threshold: UInt32 = 4) {
        self.activation = activation
        self.mode = mode
        self.clockSource = clockSource
        self.threshold = threshold
    }
}
public struct MDFConfiguration: Equatable, Sendable {
    public var processClockDivider: UInt32
    public var outputClock: MDFOutputClock
    public var serialInterface: MDFSerialInterface
    public var filterBitstream: UInt32
    public init(processClockDivider: UInt32 = 1, outputClock: MDFOutputClock = .init(), serialInterface: MDFSerialInterface = .init(), filterBitstream: UInt32 = 0) {
        self.processClockDivider = processClockDivider
        self.outputClock = outputClock
        self.serialInterface = serialInterface
        self.filterBitstream = filterBitstream
    }
}
public struct MDFReshapeFilter: Equatable, Sendable {
    public var activation: UInt32
    public var decimationRatio: UInt32
    public init(activation: UInt32 = 0, decimationRatio: UInt32 = 0) {
        self.activation = activation
        self.decimationRatio = decimationRatio
    }
}
public struct MDFHighPassFilter: Equatable, Sendable {
    public var activation: UInt32
    public var cutoffFrequency: UInt32
    public init(activation: UInt32 = 0, cutoffFrequency: UInt32 = 0) {
        self.activation = activation
        self.cutoffFrequency = cutoffFrequency
    }
}
public struct MDFSoundActivity: Equatable, Sendable {
    public var activation: UInt32
    public var mode: UInt32
    public var frameSize: UInt32
    public var hysteresis: UInt32
    public var soundTriggerEvent: UInt32
    public var dataMemoryTransfer: UInt32
    public var minimumNoiseLevel: UInt32
    public var hangoverWindow: UInt32
    public var learningFrames: UInt32
    public var ambientNoiseSlope: UInt32
    public var signalNoiseThreshold: UInt32
    public var soundLevelInterrupt: UInt32
    public init(activation: UInt32 = 0, mode: UInt32 = 0, frameSize: UInt32 = 0, hysteresis: UInt32 = 0, soundTriggerEvent: UInt32 = 0, dataMemoryTransfer: UInt32 = 0, minimumNoiseLevel: UInt32 = 0, hangoverWindow: UInt32 = 0, learningFrames: UInt32 = 0, ambientNoiseSlope: UInt32 = 0, signalNoiseThreshold: UInt32 = 0, soundLevelInterrupt: UInt32 = 0) {
        self.activation = activation
        self.mode = mode
        self.frameSize = frameSize
        self.hysteresis = hysteresis
        self.soundTriggerEvent = soundTriggerEvent
        self.dataMemoryTransfer = dataMemoryTransfer
        self.minimumNoiseLevel = minimumNoiseLevel
        self.hangoverWindow = hangoverWindow
        self.learningFrames = learningFrames
        self.ambientNoiseSlope = ambientNoiseSlope
        self.signalNoiseThreshold = signalNoiseThreshold
        self.soundLevelInterrupt = soundLevelInterrupt
    }
}
public struct MDFFilterConfiguration: Equatable, Sendable {
    public var dataSource: UInt32
    public var delay: UInt32
    public var cicMode: UInt32
    public var decimationRatio: UInt32
    public var gain: Int32
    public var reshapeFilter: MDFReshapeFilter
    public var highPassFilter: MDFHighPassFilter
    public var soundActivity: MDFSoundActivity
    public var acquisitionMode: UInt32
    public var fifoThreshold: UInt32
    public var discardSamples: UInt32
    public var trigger: MDFTrigger
    public init(dataSource: UInt32 = 0, delay: UInt32 = 0, cicMode: UInt32 = 0x40, decimationRatio: UInt32 = 2, gain: Int32 = 0, reshapeFilter: MDFReshapeFilter = .init(), highPassFilter: MDFHighPassFilter = .init(), soundActivity: MDFSoundActivity = .init(), acquisitionMode: UInt32 = 0, fifoThreshold: UInt32 = 0, discardSamples: UInt32 = 0, trigger: MDFTrigger = .init()) {
        self.dataSource = dataSource
        self.delay = delay
        self.cicMode = cicMode
        self.decimationRatio = decimationRatio
        self.gain = gain
        self.reshapeFilter = reshapeFilter
        self.highPassFilter = highPassFilter
        self.soundActivity = soundActivity
        self.acquisitionMode = acquisitionMode
        self.fifoThreshold = fifoThreshold
        self.discardSamples = discardSamples
        self.trigger = trigger
    }
}
public struct MDFDMAConfiguration: Equatable, Sendable {
    public var address: UInt32
    public var dataLength: UInt32
    public var msbOnly: UInt32
    public init(address: UInt32, dataLength: UInt32, msbOnly: UInt32 = 0) {
        self.address = address
        self.dataLength = dataLength
        self.msbOnly = msbOnly
    }
}
public enum MDFDMACallbackKind: UInt32, CaseIterable { case complete = 0, halfComplete = 1, error = 2 }
public protocol MDFDMAIO {
    func read(_ word: DMAHandleWord) -> UInt32
    func readMemory32(at address: UInt32) -> UInt32
    func writeMemory32(at address: UInt32, value: UInt32)
    func writeCallback(_ id: DMACallbackID, value: DMACallback?)
    func callback(_ kind: MDFDMACallbackKind) -> DMACallback
    func startInterrupt(sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus
    func startLinkedListInterrupt() -> HALStatus
    func abort(getTick: () -> UInt32) -> HALStatus
}
public struct MDFDMACallbackContext {
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
public struct MDF<Registers: MDFRegisterIO, Handle: MDFHandleIO, Shared: MDFSharedIO, Callbacks: MDFCallbackIO, DMAIO: MDFDMAIO> {
    public let registers: Registers
    public let handle: Handle
    public let shared: Shared
    public let callbacks: Callbacks
    public let dma: DMAIO
    public let defaults: MDFCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, shared: Shared, callbacks: Callbacks, dma: DMAIO,
                defaults: MDFCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.shared = shared; self.callbacks = callbacks; self.dma = dma
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
