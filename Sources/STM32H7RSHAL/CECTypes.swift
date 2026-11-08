// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CEC operations and definitions from stm32h7rsxx_hal_cec.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum CECRegister: UInt32, CaseIterable, Sendable { case cr = 0, cfgr = 4, txdr = 8, rxdr = 12, isr = 16, ier = 20 }
public protocol CECRegisterIO {
    func read(_ register: CECRegister) -> UInt32
    func write(_ register: CECRegister, value: UInt32)
}
public enum CECHandleWord: Int, CaseIterable {
    case signalFreeTime = 0, tolerance, bitRisingErrorReceiveStop, bitRisingErrorGeneration
    case longBitPeriodErrorGeneration, broadcastNoErrorGeneration, signalFreeTimeOption, listenMode
    case lock, globalState, receiveState, errorCode
}
public enum CECHandleHalfWord: Int, CaseIterable { case ownAddress = 0, transmitCount, receiveSize }
public enum CECBufferPointer: Int, CaseIterable { case transmit = 0, receive }
// Fifteen caller-owned UInt32 slots plus two native-pointer-width slots.
public protocol CECHandleIO {
    func read(_ word: CECHandleWord) -> UInt32
    func write(_ word: CECHandleWord, value: UInt32)
    func read(_ word: CECHandleHalfWord) -> UInt16
    func write(_ word: CECHandleHalfWord, value: UInt16)
    func readPointer(_ pointer: CECBufferPointer) -> UnsafeMutableRawPointer?
    func writePointer(_ pointer: CECBufferPointer, value: UnsafeMutableRawPointer?)
}
public enum CECState: UInt32, CaseIterable, Sendable {
    case reset = 0, ready = 0x20, busy = 0x24, busyReceive = 0x22, busyTransmit = 0x21, busyReceiveTransmit = 0x23, error = 0x50
}
public enum CECSignalFreeTime: UInt32, CaseIterable, Sendable {
    case automatic = 0x0
    case halfBitPeriod = 0x1
    case oneAndHalfBitPeriods = 0x2
    case twoAndHalfBitPeriods = 0x3
    case threeAndHalfBitPeriods = 0x4
    case fourAndHalfBitPeriods = 0x5
    case fiveAndHalfBitPeriods = 0x6
    case sixAndHalfBitPeriods = 0x7
}
public enum CECTolerance: UInt32, CaseIterable, Sendable {
    case standard = 0x0
    case extended = 0x8
}
public enum CECBitRisingErrorReceiveStop: UInt32, CaseIterable, Sendable {
    case disabled = 0x0
    case enabled = 0x10
}
public enum CECBitRisingErrorGeneration: UInt32, CaseIterable, Sendable {
    case disabled = 0x0
    case enabled = 0x20
}
public enum CECLongBitPeriodErrorGeneration: UInt32, CaseIterable, Sendable {
    case disabled = 0x0
    case enabled = 0x40
}
public enum CECBroadcastErrorGeneration: UInt32, CaseIterable, Sendable {
    case enabled = 0x0
    case disabled = 0x80
}
public enum CECSignalFreeTimeOption: UInt32, CaseIterable, Sendable {
    case startOnTransmitStart = 0x0
    case startOnTransmitReceiveEnd = 0x100
}
public enum CECListenMode: UInt32, CaseIterable, Sendable {
    case reduced = 0x0
    case full = 0x80000000
}
public struct CECFlags: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let receiveByte = Self(rawValue: 0x1)
    public static let receiveEnd = Self(rawValue: 0x2)
    public static let receiveOverrun = Self(rawValue: 0x4)
    public static let bitRisingError = Self(rawValue: 0x8)
    public static let shortBitPeriodError = Self(rawValue: 0x10)
    public static let longBitPeriodError = Self(rawValue: 0x20)
    public static let receiveAcknowledgeError = Self(rawValue: 0x40)
    public static let arbitrationLost = Self(rawValue: 0x80)
    public static let transmitByte = Self(rawValue: 0x100)
    public static let transmitEnd = Self(rawValue: 0x200)
    public static let transmitUnderrun = Self(rawValue: 0x400)
    public static let transmitError = Self(rawValue: 0x800)
    public static let transmitAcknowledgeError = Self(rawValue: 0x1000)
}
public struct CECInterrupts: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let receiveByte = Self(rawValue: 0x1)
    public static let receiveEnd = Self(rawValue: 0x2)
    public static let receiveOverrun = Self(rawValue: 0x4)
    public static let bitRisingError = Self(rawValue: 0x8)
    public static let shortBitPeriodError = Self(rawValue: 0x10)
    public static let longBitPeriodError = Self(rawValue: 0x20)
    public static let receiveAcknowledgeError = Self(rawValue: 0x40)
    public static let arbitrationLost = Self(rawValue: 0x80)
    public static let transmitByte = Self(rawValue: 0x100)
    public static let transmitEnd = Self(rawValue: 0x200)
    public static let transmitUnderrun = Self(rawValue: 0x400)
    public static let transmitError = Self(rawValue: 0x800)
    public static let transmitAcknowledgeError = Self(rawValue: 0x1000)
}
public struct CECError: OptionSet, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let receiveOverrun = Self(rawValue: 0x4)
    public static let bitRisingError = Self(rawValue: 0x8)
    public static let shortBitPeriodError = Self(rawValue: 0x10)
    public static let longBitPeriodError = Self(rawValue: 0x20)
    public static let receiveAcknowledgeError = Self(rawValue: 0x40)
    public static let arbitrationLost = Self(rawValue: 0x80)
    public static let transmitUnderrun = Self(rawValue: 0x400)
    public static let transmitError = Self(rawValue: 0x800)
    public static let transmitAcknowledgeError = Self(rawValue: 0x1000)
    public static let invalidCallback = Self(rawValue: 0x2000)
}
public struct CECConfiguration: Equatable, Sendable {
    public var signalFreeTime: UInt32
    public var tolerance: UInt32
    public var bitRisingErrorReceiveStop: UInt32
    public var bitRisingErrorGeneration: UInt32
    public var longBitPeriodErrorGeneration: UInt32
    public var broadcastNoErrorGeneration: UInt32
    public var signalFreeTimeOption: UInt32
    public var listenMode: UInt32
    public var ownAddress: UInt16
    public init(signalFreeTime: UInt32 = 0,
                tolerance: UInt32 = 0,
                bitRisingErrorReceiveStop: UInt32 = 0,
                bitRisingErrorGeneration: UInt32 = 0,
                longBitPeriodErrorGeneration: UInt32 = 0,
                broadcastNoErrorGeneration: UInt32 = 0,
                signalFreeTimeOption: UInt32 = 0,
                listenMode: UInt32 = 0,
                ownAddress: UInt16 = 0) {
        self.signalFreeTime = signalFreeTime
        self.tolerance = tolerance
        self.bitRisingErrorReceiveStop = bitRisingErrorReceiveStop
        self.bitRisingErrorGeneration = bitRisingErrorGeneration
        self.longBitPeriodErrorGeneration = longBitPeriodErrorGeneration
        self.broadcastNoErrorGeneration = broadcastNoErrorGeneration
        self.signalFreeTimeOption = signalFreeTimeOption
        self.listenMode = listenMode
        self.ownAddress = ownAddress
    }
}
public struct CEC<Registers: CECRegisterIO, Handle: CECHandleIO, Callbacks: CECCallbackIO> {
    public let registers: Registers
    public let handle: Handle
    public let callbacks: Callbacks
    public let defaults: CECCallbackDefaults
    public let useRegisteredCallbacks: Bool
    public init(registers: Registers, handle: Handle, callbacks: Callbacks,
                defaults: CECCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
        self.registers = registers; self.handle = handle; self.callbacks = callbacks
        self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
    }
}
