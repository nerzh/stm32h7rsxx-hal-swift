// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PSSI operations and definitions from stm32h7rsxx_hal_pssi.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum PSSIRegister: UInt32, CaseIterable, Sendable { case cr = 0, sr = 4, ris = 8, ier = 12, mis = 16, icr = 20, dr = 40 }
public protocol PSSIRegisterIO {
    func read(_ register: PSSIRegister) -> UInt32
    func write(_ register: PSSIRegister, value: UInt32)
    func readData8() -> UInt8
    func readData16() -> UInt16
    func writeData8(_ value: UInt8)
    func writeData16(_ value: UInt16)
    func dataAddress() -> UInt32
}
public enum PSSIHandleWord: Int, CaseIterable {
    case dataWidth = 0, busWidth, controlSignal, clockPolarity, dataEnablePolarity, readyPolarity
    case transferCount, transferSize, lock, state, errorCode
}
public protocol PSSIHandleIO {
    func read(_ word: PSSIHandleWord) -> UInt32
    func write(_ word: PSSIHandleWord, value: UInt32)
    func readBuffer() -> UnsafeMutableRawPointer?
    func writeBuffer(_ buffer: UnsafeMutableRawPointer?)
}
public enum PSSIState: UInt32, CaseIterable, Sendable {
    case reset = 0, ready = 1, busy = 2, busyTransmit = 3, busyReceive = 4, timeout = 5, error = 6, abort = 7
}
public enum PSSIDataWidth: UInt32, CaseIterable, Sendable { case bits8 = 0, bits16 = 1, bits32 = 2 }
public enum PSSIBusWidth: UInt32, CaseIterable, Sendable { case lines8 = 0, lines16 = 0xC00 }
public enum PSSIControlSignal: UInt32, CaseIterable, Sendable {
    case disabled = 0, readyEnabled = 0x40000, dataEnableEnabled = 0x80000, alternate = 0xC0000
    case mappedReadyBidirectional = 0x100000, readyMapped = 0x140000, dataEnableMapped = 0x180000, mappedDataEnableBidirectional = 0x1C0000
}
public enum PSSIDirection: UInt32, CaseIterable, Sendable { case unidirectional = 0, bidirectional = 1 }
public enum PSSIConstants {
    public static let maximumByteCount: UInt32 = 0x10000
    public static let transmitTimeout: UInt32 = 0xFFFF
    public static let readyOneByte: UInt32 = 8
    public static let readyFourBytes: UInt32 = 4
    public static let rawOverrunUnderrun: UInt32 = 2
    public static let maskedOverrunUnderrun: UInt32 = 2
}
public enum PSSIClockPolarity: UInt32, CaseIterable, Sendable { case fallingEdge = 0, risingEdge = 1 }
public enum PSSIClockSource: UInt32, CaseIterable, Sendable { case external = 0, internalClock = 0x20000000 }
public enum PSSIDataEnablePolarity: UInt32, CaseIterable, Sendable { case activeLow = 0, activeHigh = 0x40 }
public enum PSSIReadyPolarity: UInt32, CaseIterable, Sendable { case activeLow = 0, activeHigh = 0x100 }
public struct PSSIError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let notSupported = Self(rawValue: 1)
    public static let underrun = Self(rawValue: 2)
    public static let overrun = Self(rawValue: 4)
    public static let dma = Self(rawValue: 8)
    public static let timeout = Self(rawValue: 16)
    public static let invalidCallback = Self(rawValue: 32)
}
public struct PSSIConfiguration: Equatable, Sendable {
    public var dataWidth: UInt32
    public var busWidth: UInt32
    public var controlSignal: UInt32
    public var clockPolarity: UInt32
    public var dataEnablePolarity: UInt32
    public var readyPolarity: UInt32
    public init(dataWidth: UInt32 = 0, busWidth: UInt32 = 0, controlSignal: UInt32 = 0,
                clockPolarity: UInt32 = 0, dataEnablePolarity: UInt32 = 0, readyPolarity: UInt32 = 0) {
        self.dataWidth = dataWidth; self.busWidth = busWidth; self.controlSignal = controlSignal
        self.clockPolarity = clockPolarity; self.dataEnablePolarity = dataEnablePolarity; self.readyPolarity = readyPolarity
    }
}
public enum PSSIDMADirection: UInt32, CaseIterable { case transmit = 0, receive = 1 }
public enum PSSIDMACallbackKind: UInt32, CaseIterable { case transmitComplete = 0, receiveComplete = 1, error = 2, abort = 3 }
public protocol PSSIDMAIO {
    func isPresent(_ direction: PSSIDMADirection) -> Bool
    // Read Init.DestDataWidth for transmit and Init.SrcDataWidth for receive.
    func readDataWidth(_ direction: PSSIDMADirection) -> UInt32
    func read(_ direction: PSSIDMADirection, word: DMAHandleWord) -> UInt32
    func readMemory32(_ direction: PSSIDMADirection, at address: UInt32) -> UInt32
    func writeMemory32(_ direction: PSSIDMADirection, at address: UInt32, value: UInt32)
    func writeCallback(_ direction: PSSIDMADirection, id: DMACallbackID, value: DMACallback?)
    func invokeCallback(_ direction: PSSIDMADirection, id: DMACallbackID)
    func callback(_ kind: PSSIDMACallbackKind) -> DMACallback
    func startInterrupt(_ direction: PSSIDMADirection, sourceAddress: UInt32, destinationAddress: UInt32, sourceDataSize: UInt32) -> HALStatus
    func startLinkedListInterrupt(_ direction: PSSIDMADirection) -> HALStatus
    func abortInterrupt(_ direction: PSSIDMADirection) -> HALStatus
}
public struct PSSIDMACallbackContext {
    public let dmaContext: UnsafeMutableRawPointer?
    public let readParent: @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?
    public let dispatch: @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
    public init(dmaContext: UnsafeMutableRawPointer?,
                readParent: @escaping @convention(c) (UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer?,
                dispatch: @escaping @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void) {
        self.dmaContext = dmaContext; self.readParent = readParent; self.dispatch = dispatch
    }
}
public struct PSSI<Registers: PSSIRegisterIO, Handle: PSSIHandleIO, Callbacks: PSSICallbackIO, DMAIO: PSSIDMAIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let dma: DMAIO
    public let defaults: PSSICallbackDefaults
    public let useRegisteredCallbacks: Bool
    public let dmaModuleEnabled: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks, dma: DMAIO,
                defaults: PSSICallbackDefaults = .init(), useRegisteredCallbacks: Bool = false, dmaModuleEnabled: Bool = true) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks; self.dma = dma
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks; self.dmaModuleEnabled = dmaModuleEnabled
    }
}
