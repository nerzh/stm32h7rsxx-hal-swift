// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// PKA operations and definitions from stm32h7rsxx_hal_pka.c/.h
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum PKARegister: UInt32, CaseIterable, Sendable { case cr = 0, sr = 4, clrfr = 8 }
public protocol PKARegisterIO {
    func read(_ register: PKARegister) -> UInt32
    func write(_ register: PKARegister, value: UInt32)
    func readRAM(_ index: UInt32) -> UInt32
    func writeRAM(_ index: UInt32, value: UInt32)
    // C qualifies both word-copy operands as volatile, including caller buffers.
    func readOperandWord(_ pointer: UnsafePointer<UInt32>) -> UInt32
    func writeResultWord(_ pointer: UnsafeMutablePointer<UInt32>, value: UInt32)
}
public enum PKAHandleWord: Int, CaseIterable {
    case state = 0, errorCode, primeOrderSize, operandSize, modulusSize
}
public protocol PKAHandleIO {
    func read(_ word: PKAHandleWord) -> UInt32
    func write(_ word: PKAHandleWord, value: UInt32)
}
public protocol PKASystemIO {
    func forceReset()
    func releaseReset()
    func disableClock()
    func disableInterrupt()
}
public enum PKAState: UInt32, CaseIterable, Sendable { case reset = 0, ready, busy, error }
public struct PKAError: OptionSet, Equatable, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let address = Self(rawValue: 1)
    public static let ram = Self(rawValue: 2)
    public static let timeout = Self(rawValue: 4)
    public static let operation = Self(rawValue: 8)
    public static let invalidCallback = Self(rawValue: 16)
}
public enum PKAMode: UInt32, CaseIterable, Sendable {
    case modularExponentiation = 0, montgomeryParameter = 1, modularExponentiationFast = 2, modularExponentiationProtected = 3
    case rsaCRTExponentiation = 7, modularInversion = 8, addition = 9, subtraction = 10, multiplication = 11
    case comparison = 12, modularReduction = 13, modularAddition = 14, modularSubtraction = 15, montgomeryMultiplication = 16
    case eccMultiplication = 0x20, eccCompleteAddition = 0x23, ecdsaSignature = 0x24, ecdsaVerification = 0x26
    case eccDoubleBaseLadder = 0x27, pointCheck = 0x28, eccProjectiveToAffine = 0x2F
}
public struct PKAInterrupt: OptionSet, Equatable, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let processEnd = Self(rawValue: 0x20000)
    public static let ramError = Self(rawValue: 0x80000)
    public static let addressError = Self(rawValue: 0x100000)
    public static let operationError = Self(rawValue: 0x200000)
}
public struct PKAFlag: OptionSet, Equatable, Sendable {
    public let rawValue: UInt32
    public init(rawValue: UInt32) { self.rawValue = rawValue }
    public static let processEnd = Self(rawValue: 0x20000)
    public static let ramError = Self(rawValue: 0x80000)
    public static let addressError = Self(rawValue: 0x100000)
    public static let operationError = Self(rawValue: 0x200000)
}
public enum PKAOperationStatus: UInt32, CaseIterable, Sendable {
    case noError = 0xD60D, failedComputation = 0xCBC9, signatureRZero = 0xA3B7, signatureSZero = 0xF946
}
