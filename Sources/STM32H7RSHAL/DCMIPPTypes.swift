// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DCMIPP operations and definitions from stm32h7rsxx_hal_dcmipp.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum DCMIPPRegister: UInt32, CaseIterable, Sendable {
    case ipgr1 = 0x0
    case ipgr2 = 0x4
    case ipgr3 = 0x8
    case ipc1r1 = 0x20
    case ipc1r2 = 0x24
    case ipc1r3 = 0x28
    case prcr = 0x104
    case prescr = 0x108
    case presur = 0x10c
    case cmcr = 0x204
    case cmfrcr = 0x208
    case cmier = 0x3f0
    case cmsr1 = 0x3f4
    case cmsr2 = 0x3f8
    case cmfcr = 0x3fc
    case p0fscr = 0x404
    case p0fctcr = 0x500
    case p0scstr = 0x504
    case p0scszr = 0x508
    case p0dccntr = 0x5b0
    case p0dclmtr = 0x5b4
    case p0ppcr = 0x5c0
    case p0ppm0ar1 = 0x5c4
    case p0ppm0ar2 = 0x5c8
}
public protocol DCMIPPRegisterIO {
    func read(_ register: DCMIPPRegister) -> UInt32
    func write(_ register: DCMIPPRegister, value: UInt32)
}
public enum DCMIPPHandleWord: Int, CaseIterable, Sendable {
    case state = 0
    case pipeState = 1
    case errorCode = 2
}
public protocol DCMIPPHandleIO {
    func read(_ word: DCMIPPHandleWord) -> UInt32
    func write(_ word: DCMIPPHandleWord, value: UInt32)
}
public enum DCMIPPState: UInt32, CaseIterable, Sendable {
    case reset = 0x0
    case initialized = 0x1
    case ready = 0x2
    case busy = 0x3
    case error = 0x4
}
public enum DCMIPPPipeState: UInt32, CaseIterable, Sendable {
    case reset = 0x0
    case ready = 0x1
    case busy = 0x2
    case suspended = 0x3
    case error = 0x4
}
public enum DCMIPPCaptureMode: UInt32, CaseIterable, Sendable {
    case continuous = 0x0
    case snapshot = 0x4
}
public enum DCMIPPFrameRate: UInt32, CaseIterable, Sendable {
    case all = 0x0
    case half = 0x1
    case quarter = 0x2
    case eighth = 0x3
}
public enum DCMIPPFormat: UInt32, CaseIterable, Sendable {
    case byte = 0x0
    case yuv422 = 0x1e0000
    case rgb565 = 0x220000
    case rgb666 = 0x230000
    case rgb888 = 0x240000
    case raw8 = 0x2a0000
    case raw10 = 0x2b0000
    case raw12 = 0x2c0000
    case raw14 = 0x2d0000
    case monochrome8 = 0x4a0000
    case monochrome10 = 0x4b0000
    case monochrome12 = 0x4c0000
    case monochrome14 = 0x4d0000
}
public enum DCMIPPDataWidth: UInt32, CaseIterable, Sendable {
    case bits8 = 0x0
    case bits10 = 0x400
    case bits12 = 0x800
    case bits14 = 0xc00
    case bits16 = 0x1000
}
public enum DCMIPPHorizontalSyncPolarity: UInt32, CaseIterable, Sendable {
    case low = 0x0
    case high = 0x40
}
public enum DCMIPPVerticalSyncPolarity: UInt32, CaseIterable, Sendable {
    case low = 0x0
    case high = 0x80
}
public enum DCMIPPPixelClockPolarity: UInt32, CaseIterable, Sendable {
    case falling = 0x0
    case rising = 0x20
}
public enum DCMIPPSynchronization: UInt32, CaseIterable, Sendable {
    case hardware = 0x0
    case embedded = 0x10
}
public enum DCMIPPSwapBits: UInt32, CaseIterable, Sendable {
    case disabled = 0x0
    case enabled = 0x4000000
}
public enum DCMIPPSwapCycles: UInt32, CaseIterable, Sendable {
    case disabled = 0x0
    case enabled = 0x2000000
}
public enum DCMIPPMemoryPageSize: UInt32, CaseIterable, Sendable {
    case bytes64 = 0x0
    case bytes128 = 0x1
    case bytes256 = 0x2
    case bytes512 = 0x3
    case bytes1024 = 0x4
    case bytes2048 = 0x5
    case bytes4096 = 0x6
    case bytes8192 = 0x7
}
public enum DCMIPPTrafficBurstSize: UInt32, CaseIterable, Sendable {
    case bytes8 = 0x0
    case bytes16 = 0x1
    case bytes32 = 0x2
    case bytes64 = 0x3
    case bytes128 = 0x4
}
public enum DCMIPPOutstandingTransactions: UInt32, CaseIterable, Sendable {
    case none = 0x0
    case two = 0x1
    case three = 0x2
    case four = 0x3
}
public enum DCMIPPCropArea: UInt32, CaseIterable, Sendable {
    case positive = 0x0
    case negative = 0x40000000
}
public enum DCMIPPByteSelection: UInt32, CaseIterable, Sendable {
    case all = 0x0
    case dataOutOfTwo = 0x80
    case byteOutOfFour = 0x100
    case twoBytesOutOfFour = 0x180
}
public enum DCMIPPByteSelectionStart: UInt32, CaseIterable, Sendable {
    case odd = 0x0
    case even = 0x200
}
public enum DCMIPPLineSelection: UInt32, CaseIterable, Sendable {
    case all = 0x0
    case alternate = 0x400
}
public enum DCMIPPLineSelectionStart: UInt32, CaseIterable, Sendable {
    case odd = 0x0
    case even = 0x800
}
public enum DCMIPPMemory: UInt32, CaseIterable, Sendable {
    case first = 0x0
    case second = 0x1
}
public enum DCMIPPLineEventInterval: UInt32, CaseIterable, Sendable {
    case one = 0x0
    case two = 0x2000
    case four = 0x4000
    case eight = 0x6000
    case sixteen = 0x8000
    case thirtyTwo = 0xa000
    case sixtyFour = 0xc000
    case oneHundredTwentyEight = 0xe000
}
public struct DCMIPPError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let axiTransfer = Self(rawValue: 0x1)
    public static let parallelSync = Self(rawValue: 0x2)
    public static let pipeLimit = Self(rawValue: 0x4)
    public static let pipeOverrun = Self(rawValue: 0x8)
    public static let invalidCallback = Self(rawValue: 0x40)
}
public struct DCMIPPInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let axiTransferError = Self(rawValue: 0x20)
    public static let parallelSyncError = Self(rawValue: 0x40)
    public static let frame = Self(rawValue: 0x200)
    public static let vsync = Self(rawValue: 0x400)
    public static let line = Self(rawValue: 0x100)
    public static let limit = Self(rawValue: 0x4000)
    public static let overrun = Self(rawValue: 0x8000)
}
public typealias DCMIPPFlags = DCMIPPInterrupts
public struct DCMIPPParallelConfiguration: Equatable, Sendable {
    // Synchronization code bytes: frame start, line start, line end, frame end.
    public var format: UInt32
    public var vsPolarity: UInt32
    public var hsPolarity: UInt32
    public var pixelClockPolarity: UInt32
    public var dataWidth: UInt32
    public var synchronization: UInt32
    public var synchronizationCodes: UInt32
    public var swapBits: UInt32
    public var swapCycles: UInt32
    public init(format: UInt32, vsPolarity: UInt32, hsPolarity: UInt32,
                pixelClockPolarity: UInt32, dataWidth: UInt32, synchronization: UInt32,
                synchronizationCodes: UInt32, swapBits: UInt32, swapCycles: UInt32) {
        self.format = format
        self.vsPolarity = vsPolarity
        self.hsPolarity = hsPolarity
        self.pixelClockPolarity = pixelClockPolarity
        self.dataWidth = dataWidth
        self.synchronization = synchronization
        self.synchronizationCodes = synchronizationCodes
        self.swapBits = swapBits
        self.swapCycles = swapCycles
    }
}
public struct DCMIPPIPPlugConfiguration: Equatable, Sendable {
    public var client: UInt32
    public var memoryPageSize: UInt32
    public var traffic: UInt32
    public var maxOutstandingTransactions: UInt32
    public var start: UInt32
    public var end: UInt32
    public var arbitrationRatio: UInt32
    public init(client: UInt32, memoryPageSize: UInt32, traffic: UInt32,
                maxOutstandingTransactions: UInt32, start: UInt32, end: UInt32,
                arbitrationRatio: UInt32) {
        self.client = client
        self.memoryPageSize = memoryPageSize
        self.traffic = traffic
        self.maxOutstandingTransactions = maxOutstandingTransactions
        self.start = start
        self.end = end
        self.arbitrationRatio = arbitrationRatio
    }
}
public struct DCMIPPCropConfiguration: Equatable, Sendable {
    public var verticalStart: UInt32
    public var horizontalStart: UInt32
    public var verticalSize: UInt32
    public var horizontalSize: UInt32
    public var area: UInt32
    public init(verticalStart: UInt32, horizontalStart: UInt32, verticalSize: UInt32,
                horizontalSize: UInt32, area: UInt32) {
        self.verticalStart = verticalStart
        self.horizontalStart = horizontalStart
        self.verticalSize = verticalSize
        self.horizontalSize = horizontalSize
        self.area = area
    }
}
public struct DCMIPP<Registers: DCMIPPRegisterIO, Handle: DCMIPPHandleIO, Callbacks: DCMIPPCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: DCMIPPCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: DCMIPPCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
