// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of HAL_AXIM_* in stm32h7rsxx_hal.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// ASIB, AMIB and AMIB bus-matrix issuing use the same register encodings.
public enum AXIMReadIssuing: UInt32, CaseIterable, Sendable {
  case normal = 0, forceOne = 1
}
public enum AXIMWriteIssuing: UInt32, CaseIterable, Sendable {
  case normal = 0, forceOne = 2
}

public enum AXIMASIBRegister: Hashable, CaseIterable {
  case fnmod2, readQoS, writeQoS, fnmod
}
public protocol AXIMASIBRegisterIO {
  func read(_ register: AXIMASIBRegister) -> UInt32
  func write(_ register: AXIMASIBRegister, value: UInt32)
}

public struct AXIMASIB<IO: AXIMASIBRegisterIO> {
  public let registers: IO
  public init(registers: IO) { self.registers = registers }

  // These HAL operations replace the whole register, including unrelated bits.
  public func enablePacking() { registers.write(.fnmod2, value: 0) }
  public func disablePacking() { registers.write(.fnmod2, value: 1) }

  public func configureIssuing(read: UInt32, write: UInt32) {
    precondition(read == 0 || read == 1)
    precondition(write == 0 || write == 2)
    registers.write(.fnmod, value: read | write)
  }
  public func configureIssuing(read: AXIMReadIssuing, write: AXIMWriteIssuing) {
    configureIssuing(read: read.rawValue, write: write.rawValue)
  }

  public func configureReadQoS(_ priority: UInt32) {
    precondition(priority <= 0xF)
    registers.write(.readQoS, value: priority)
  }
  public func configureWriteQoS(_ priority: UInt32) {
    precondition(priority <= 0xF)
    registers.write(.writeQoS, value: priority)
  }
}

public enum AXIMAMIBRegister: Hashable, CaseIterable {
  case fnmodBusMatrixIssuing, fnmod2, fnmodLongBurst, fnmod
}
public protocol AXIMAMIBRegisterIO {
  func read(_ register: AXIMAMIBRegister) -> UInt32
  func write(_ register: AXIMAMIBRegister, value: UInt32)
}

public struct AXIMAMIB<IO: AXIMAMIBRegisterIO> {
  public let registers: IO
  public init(registers: IO) { self.registers = registers }

  public func enablePacking() { registers.write(.fnmod2, value: 0) }
  public func disablePacking() { registers.write(.fnmod2, value: 1) }

  public func configureIssuing(read: UInt32, write: UInt32) {
    precondition(read == 0 || read == 1)
    precondition(write == 0 || write == 2)
    registers.write(.fnmod, value: read | write)
  }
  public func configureIssuing(read: AXIMReadIssuing, write: AXIMWriteIssuing) {
    configureIssuing(read: read.rawValue, write: write.rawValue)
  }

  public func configureBusMatrixIssuing(read: UInt32, write: UInt32) {
    precondition(read == 0 || read == 1)
    precondition(write == 0 || write == 2)
    registers.write(.fnmodBusMatrixIssuing, value: read | write)
  }
  public func configureBusMatrixIssuing(read: AXIMReadIssuing, write: AXIMWriteIssuing) {
    configureBusMatrixIssuing(read: read.rawValue, write: write.rawValue)
  }

  public func enableLongBurst() { registers.write(.fnmodLongBurst, value: 1) }
  public func disableLongBurst() { registers.write(.fnmodLongBurst, value: 0) }
}
