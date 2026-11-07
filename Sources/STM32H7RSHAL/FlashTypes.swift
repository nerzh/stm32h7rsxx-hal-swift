// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// FLASH types/encodings from HAL 606ed7132ef1bc32c77fd9a040103bc98f23c748
// and CMSIS device 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

// FLASH_TIMEOUT_VALUE from the pinned HAL header (milliseconds).
let flashOperationTimeout: UInt32 = 1000

public enum FlashRegister: Hashable {
  case cr, sr, ier, isr, icr, keyr, optkeyr, optcr, optisr, opticr
  case wrpsr, wrpsrp, obw1sr, obw1srp, obw2sr, obw2srp, hdpsr, hdpsrp
  case nvsr, nvsrp, rotsr, epochsr, otplsr, otplsrp, obkcr
  case obkdr(index: Int)
  case crccr, crcsaddr, crceaddr, crcdatar, eccdfaddr, eccsfaddr
}

// ACR access and latency encodings reuse the existing FlashTiming API.
public protocol FlashRegisterIO: FlashTimingRegisterIO {
  func read(_ register: FlashRegister) -> UInt32
  func write(_ register: FlashRegister, value: UInt32)
}
public enum FlashProcessWord: Int, CaseIterable {
  case lock = 0, errorCode, procedure, address, sector, sectorsRemaining
}

// All Flash wrappers for one peripheral must share these six initially zero
// words, matching the single C pFlash object. Foreground and IRQ accesses are
// volatile and do not hold Swift inout exclusivity over a HAL call. The HAL
// software lock remains the original non-atomic check/set, not an IRQ mutex.
public protocol FlashProcessIO {
  func read(_ word: FlashProcessWord) -> UInt32
  func write(_ word: FlashProcessWord, value: UInt32)
}

// Target bus addresses are UInt32. Callers retain accessible source storage
// throughout programming. Implementations preserve each requested access
// width and the order of interrupt-mask and barrier operations.
public protocol FlashMemoryIO: DMAMemoryIO {
  func read8(at address: UInt32) -> UInt8
  func read16(at address: UInt32) -> UInt16
  func write8(at address: UInt32, value: UInt8)
  func write16(at address: UInt32, value: UInt16)
  func getPRIMASK() -> UInt32
  func disableIRQ()
  func setPRIMASK(_ value: UInt32)
  func instructionSynchronizationBarrier()
  func dataSynchronizationBarrier()
}

public enum FlashProgramType: UInt32, CaseIterable, Sendable {
  case byte = 0x0000_0012
  case halfWord = 0x4000_0012
  case word = 0x8000_0012
  case doubleWord = 0xC000_0012
  case quadWord = 0x0000_0002
  case otpHalfWord = 0x4001_0010
  case otpWord = 0x8001_0010
}

public struct FlashFlags: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let endOfOperation = Self(rawValue: 0x0001_0000)
  public static let writeProtectionError = Self(rawValue: 0x0002_0000)
  public static let programmingSequenceError = Self(rawValue: 0x0004_0000)
  public static let strobeError = Self(rawValue: 0x0008_0000)
  public static let optionLoadingError = Self(rawValue: 0x0010_0000)
  public static let inconsistencyError = Self(rawValue: 0x0020_0000)
  public static let readSecurityError = Self(rawValue: 0x0100_0000)
  public static let eccSingleError = Self(rawValue: 0x0200_0000)
  public static let eccDoubleError = Self(rawValue: 0x0400_0000)
  public static let crcEnd = Self(rawValue: 0x0800_0000)
  public static let crcReadError = Self(rawValue: 0x1000_0000)
  public static let keyValidError = Self(rawValue: 0x0800_0000)
  public static let keyTransferError = Self(rawValue: 0x1000_0000)
  public static let optionChangeError = Self(rawValue: 0x4000_0000)
  public static let interruptStatusErrors = Self(rawValue: 0x113E_0000)
  public static let eccErrors = Self(rawValue: 0x0600_0000)
  public static let optionStatusErrors = Self(rawValue: 0x5800_0000)
  public static let allErrors = Self(rawValue: 0x5F3E_0000)
  public static let interruptStatusFlags = Self(rawValue: 0x173F_0000)
}

// The C interrupt/flag encodings intentionally overlap between ISR and OPTISR.
public struct FlashInterrupts: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let endOfOperation = Self(rawValue: 0x0001_0000)
  public static let writeProtectionError = Self(rawValue: 0x0002_0000)
  public static let programmingSequenceError = Self(rawValue: 0x0004_0000)
  public static let strobeError = Self(rawValue: 0x0008_0000)
  public static let optionLoadingError = Self(rawValue: 0x0010_0000)
  public static let inconsistencyError = Self(rawValue: 0x0020_0000)
  public static let readSecurityError = Self(rawValue: 0x0100_0000)
  public static let eccSingleError = Self(rawValue: 0x0200_0000)
  public static let eccDoubleError = Self(rawValue: 0x0400_0000)
  public static let crcEnd = Self(rawValue: 0x0800_0000)
  public static let crcReadError = Self(rawValue: 0x1000_0000)
  public static let keyValidError = Self(rawValue: 0x0800_0000)
  public static let keyTransferError = Self(rawValue: 0x1000_0000)
  public static let optionChangeError = Self(rawValue: 0x4000_0000)
  public static let interruptEnableRegister = Self(rawValue: 0x1F3F_0000)
  public static let optionControlRegister = Self(rawValue: 0x5800_0000)
}

public struct FlashError: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let writeProtection = Self(rawValue: 0x0002_0000)
  public static let programmingSequence = Self(rawValue: 0x0004_0000)
  public static let strobe = Self(rawValue: 0x0008_0000)
  public static let optionLoading = Self(rawValue: 0x0010_0000)
  public static let inconsistency = Self(rawValue: 0x0020_0000)
  public static let readSecurity = Self(rawValue: 0x0100_0000)
  public static let eccSingle = Self(rawValue: 0x0200_0000)
  public static let eccDouble = Self(rawValue: 0x0400_0000)
  public static let crc = Self(rawValue: 0x1000_0000)
  public static let keyValid = Self(rawValue: 0x0800_0000)
  public static let keyTransfer = Self(rawValue: 0x1000_0000)
  public static let optionChange = Self(rawValue: 0x4000_0000)
}

public typealias FlashOperationCallback = @convention(c) (UnsafeMutableRawPointer?, UInt32) -> Void
public typealias FlashECCCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void

// Immutable application hooks replace the four C weak callbacks. Context and
// callback targets are unowned and must remain alive during foreground/IRQ use.
public struct FlashCallbacks {
  public let context: UnsafeMutableRawPointer?
  public let endOfOperation, operationError: FlashOperationCallback
  public let eccCorrection, eccDetection: FlashECCCallback
  public init(context: UnsafeMutableRawPointer? = nil,
              endOfOperation: @escaping FlashOperationCallback = { _, _ in },
              operationError: @escaping FlashOperationCallback = { _, _ in },
              eccCorrection: @escaping FlashECCCallback = { _ in },
              eccDetection: @escaping FlashECCCallback = { _ in }) {
    self.context = context; self.endOfOperation = endOfOperation; self.operationError = operationError
    self.eccCorrection = eccCorrection; self.eccDetection = eccDetection
  }
}

public struct Flash<Registers: FlashRegisterIO, Process: FlashProcessIO, Memory: FlashMemoryIO> {
  public let registers: Registers
  public let process: Process
  public let memory: Memory
  public let callbacks: FlashCallbacks
  public init(registers: Registers, process: Process, memory: Memory, callbacks: FlashCallbacks = .init()) {
    self.registers = registers; self.process = process; self.memory = memory; self.callbacks = callbacks
  }
}
