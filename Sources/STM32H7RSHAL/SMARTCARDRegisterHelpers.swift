// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMARTCARD/SMARTCARDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMARTCARD {
  @discardableResult
  public func checkIdleState(getTick: () -> UInt32) -> HALStatus {
    handle.write(.errorCode, value: 0)
    let start = getTick()
    if registers.read(.cr1) & 8 == 8 {
      if waitOnFlag(0x200000, status: 0, start: start, timeout: 1000, getTick: getTick) != .ok {
        return .timeout
      }
    }
    if registers.read(.cr1) & 4 == 4 {
      if waitOnFlag(0x400000, status: 0, start: start, timeout: 1000, getTick: getTick) != .ok {
        return .timeout
      }
    }
    handle.write(.globalState, value: 0x20)
    handle.write(.receiveState, value: 0x20)
    unlock()
    return .ok
  }
  @discardableResult
  public func waitOnFlag(
    _ flag: UInt32, status: UInt32, start: UInt32, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    while getFlag(flag) == status {
      if timeout != UInt32.max {
        if getTick() &- start > timeout || timeout == 0 {
          modify(.cr1, clear: 0x1A0, set: 0)
          modify(.cr3, clear: 1, set: 0)
          handle.write(.globalState, value: 0x20)
          handle.write(.receiveState, value: 0x20)
          unlock()
          return .timeout
        }
      }
    }
    return .ok
  }
  public func getState() -> UInt32 { handle.read(.globalState) | handle.read(.receiveState) }
  public func getError() -> UInt32 { handle.read(.errorCode) }
  func modify(_ register: UARTRegister, clear: UInt32, set: UInt32) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
  func tryLock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  public func enable() { modify(.cr1, clear: 0, set: 1) }
  public func disable() { modify(.cr1, clear: 1, set: 0) }
  public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.isr) & flag == flag ? 1 : 0 }
  public func clearFlag(_ flag: UInt32) { registers.write(.icr, value: flag) }
  public func sendRequest(_ request: UInt32) {
    modify(.rqr, clear: 0, set: UInt32(UInt16(truncatingIfNeeded: request)))
  }
  public func enableOneBitSampling() { modify(.cr3, clear: 0, set: 0x800) }
  public func disableOneBitSampling() { modify(.cr3, clear: 0x800, set: 0) }
  public func enableInterrupt(_ interrupt: UInt32) {
    modify(Self.interruptRegister(interrupt), clear: 0, set: UInt32(1) << (interrupt & 0x1F))
  }
  public func disableInterrupt(_ interrupt: UInt32) {
    modify(Self.interruptRegister(interrupt), clear: UInt32(1) << (interrupt & 0x1F), set: 0)
  }
  public func getInterrupt(_ interrupt: UInt32) -> UInt32 {
    registers.read(.isr) & (UInt32(1) << ((interrupt & 0x1F00) >> 8)) != 0 ? 1 : 0
  }
  public func getInterruptSource(_ interrupt: UInt32) -> UInt32 {
    registers.read(Self.interruptRegister(interrupt)) & (UInt32(1) << (interrupt & 0x1F)) != 0
      ? 1 : 0
  }
  static func interruptRegister(_ interrupt: UInt32) -> UARTRegister {
    let register = UInt8(truncatingIfNeeded: interrupt) >> 5
    return register == 1 ? .cr1 : (register == 2 ? .cr2 : .cr3)
  }
  public func flushDataRegisters() {
    sendRequest(8)
    sendRequest(0x10)
  }
  public func clearInterrupt(_ flag: UInt32) { modify(.icr, clear: 0, set: flag) }
}
