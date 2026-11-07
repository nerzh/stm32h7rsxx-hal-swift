// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Core operations and exported macros from stm32h7rsxx_hal_flash.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension Flash {
  @discardableResult
  public func program(type: UInt32, address: UInt32, dataAddress: UInt32,
                      getTick: () -> UInt32) -> HALStatus {
    precondition(FlashProgramType(rawValue: type) != nil)
    if !tryLock() { return .busy }
    process.write(.errorCode, value: 0)
    var status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status == .ok {
      status = performProgramming(type: type, address: address, dataAddress: dataAddress)
      if status != .error {
        status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
        modify(.cr, clear: type & ~UInt32(0xC000_0000), set: 0)
      }
    }
    unlockProcess()
    return status
  }

  @discardableResult
  public func program(_ type: FlashProgramType, address: UInt32, dataAddress: UInt32,
                      getTick: () -> UInt32) -> HALStatus {
    program(type: type.rawValue, address: address, dataAddress: dataAddress, getTick: getTick)
  }

  @discardableResult
  public func programInterrupt(type: UInt32, address: UInt32, dataAddress: UInt32,
                               getTick: () -> UInt32) -> HALStatus {
    precondition(FlashProgramType(rawValue: type) != nil)
    if !tryLock() { return .busy }
    process.write(.errorCode, value: 0)
    var status = waitForLastOperation(timeout: flashOperationTimeout, getTick: getTick)
    if status != .ok {
      unlockProcess()
    } else {
      process.write(.procedure, value: type)
      process.write(.address, value: address)
      modify(.ier, clear: 0, set: 0x002F_0000)
      status = performProgramming(type: type, address: address, dataAddress: dataAddress)
      if status == .error { unlockProcess() }
    }
    return status
  }

  @discardableResult
  public func programInterrupt(_ type: FlashProgramType, address: UInt32, dataAddress: UInt32,
                               getTick: () -> UInt32) -> HALStatus {
    programInterrupt(type: type.rawValue, address: address, dataAddress: dataAddress, getTick: getTick)
  }

  public func handleInterrupt() {
    var parameter: UInt32 = 0
    var error = registers.read(.isr) & 0x113E_0000
    error |= registers.read(.optisr) & 0x5800_0000
    if process.read(.procedure) == 4 {
      parameter = process.read(.sector)
    } else if process.read(.procedure) & 2 != 0 {
      parameter = process.read(.address)
    }
    modify(.cr, clear: process.read(.procedure) & ~UInt32(0xC000_0000), set: 0)
    if error != 0 {
      process.write(.errorCode, value: process.read(.errorCode) | error)
      registers.write(.icr, value: error & 0x113E_0000)
      registers.write(.opticr, value: error & 0x5800_0000)
      process.write(.procedure, value: 0)
      callbacks.operationError(callbacks.context, parameter)
    }
    if registers.read(.isr) & 0x0001_0000 != 0 {
      registers.write(.icr, value: 0x0001_0000)
      if process.read(.procedure) == 4 {
        process.write(.sectorsRemaining, value: process.read(.sectorsRemaining) &- 1)
        if process.read(.sectorsRemaining) != 0 {
          process.write(.sector, value: process.read(.sector) &+ 1)
          sectorErase(process.read(.sector))
        } else {
          process.write(.procedure, value: 0)
          parameter = UInt32.max
        }
      } else {
        process.write(.procedure, value: 0)
      }
      callbacks.endOfOperation(callbacks.context, parameter)
    }
    if process.read(.procedure) == 0 {
      modify(.ier, clear: 0x002F_0000, set: 0)
      unlockProcess()
    }
    if registers.read(.ier) & 0x0200_0000 != 0 {
      if registers.read(.isr) & 0x0200_0000 != 0 {
        callbacks.eccCorrection(callbacks.context)
        registers.write(.icr, value: 0x0200_0000)
      }
    }
    if registers.read(.ier) & 0x0400_0000 != 0 {
      if registers.read(.isr) & 0x0400_0000 != 0 {
        callbacks.eccDetection(callbacks.context)
        registers.write(.icr, value: 0x0400_0000)
      }
    }
  }

  @discardableResult
  public func unlock() -> HALStatus {
    if registers.read(.cr) & 1 != 0 {
      registers.write(.keyr, value: 0x4567_0123)
      registers.write(.keyr, value: 0xCDEF_89AB)
      if registers.read(.cr) & 1 != 0 { return .error }
    }
    return .ok
  }

  @discardableResult
  public func lock() -> HALStatus {
    modify(.cr, clear: 0, set: 1)
    return registers.read(.cr) & 1 != 0 ? .ok : .error
  }

  @discardableResult
  public func unlockOptionBytes() -> HALStatus {
    if registers.read(.optcr) & 1 != 0 {
      registers.write(.optkeyr, value: 0x0819_2A3B)
      registers.write(.optkeyr, value: 0x4C5D_6E7F)
      if registers.read(.optcr) & 1 != 0 { return .error }
    }
    return .ok
  }

  @discardableResult
  public func lockOptionBytes() -> HALStatus {
    modify(.optcr, clear: 0, set: 1)
    return registers.read(.optcr) & 1 != 0 ? .ok : .error
  }

  public func getError() -> UInt32 { process.read(.errorCode) }

  @discardableResult
  public func waitForLastOperation(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    let start = getTick()
    while registers.read(.sr) & 4 != 0 {
      if timeout != UInt32.max {
        if getTick() &- start > timeout || timeout == 0 { return .timeout }
      }
    }
    var error = registers.read(.isr) & 0x113E_0000
    error |= registers.read(.optisr) & 0x5800_0000
    if error != 0 {
      process.write(.errorCode, value: process.read(.errorCode) | error)
      registers.write(.icr, value: error & 0x113E_0000)
      registers.write(.opticr, value: error & 0x5800_0000)
      return .error
    }
    if registers.read(.isr) & 0x0001_0000 != 0 { registers.write(.icr, value: 0x0001_0000) }
    return .ok
  }

  public func setLatency(_ latency: FlashLatency) { FlashTiming(registers: registers).setLatency(latency) }
  public func getLatency() -> UInt32 { FlashTiming(registers: registers).getLatency() }

  public func enableInterrupts(_ interrupts: FlashInterrupts) { enableInterrupts(interrupts.rawValue) }
  public func disableInterrupts(_ interrupts: FlashInterrupts) { disableInterrupts(interrupts.rawValue) }
  public func getFlag(_ flags: FlashFlags) -> UInt32 { getFlag(flags.rawValue) }
  public func clearFlag(_ flags: FlashFlags) { clearFlag(flags.rawValue) }

  public func enableInterrupts(_ interrupts: UInt32) {
    if interrupts & 0x1F3F_0000 != 0 { modify(.ier, clear: 0, set: interrupts & 0x1F3F_0000) }
    if interrupts & 0x5800_0000 != 0 { modify(.optcr, clear: 0, set: interrupts & 0x5800_0000) }
  }
  public func disableInterrupts(_ interrupts: UInt32) {
    if interrupts & 0x1F3F_0000 != 0 { modify(.ier, clear: interrupts & 0x1F3F_0000, set: 0) }
    if interrupts & 0x5800_0000 != 0 { modify(.optcr, clear: interrupts & 0x5800_0000, set: 0) }
  }
  public func getFlag(_ flags: UInt32) -> UInt32 {
    if flags & 0x5800_0000 != 0 { return registers.read(.optisr) & flags == flags ? 1 : 0 }
    return registers.read(.isr) & flags == flags ? 1 : 0
  }
  public func clearFlag(_ flags: UInt32) {
    if flags & 0x5800_0000 != 0 { registers.write(.opticr, value: flags & 0x5800_0000) }
    if flags & 0x173F_0000 != 0 { registers.write(.icr, value: flags & 0x173F_0000) }
  }

  func tryLock() -> Bool {
    if process.read(.lock) == 1 { return false }
    process.write(.lock, value: 1)
    return true
  }
  func unlockProcess() { process.write(.lock, value: 0) }
  func modify(_ register: FlashRegister, clear: UInt32, set: UInt32) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
