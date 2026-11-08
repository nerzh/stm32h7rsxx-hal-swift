// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMARTCARD blocking transfers from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMARTCARD {
  @discardableResult
  public func transmit(
    _ data: UnsafeRawPointer?, size: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    if handle.read(.globalState) != 0x20 { return .busy }
    guard var data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.write(.globalState, value: 0x21)
    let start = getTick()
    prepareTransmitRegisters()
    handle.write(.errorCode, value: 0)
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    while handle.read(.transmitCount) > 0 {
      handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
      if waitOnFlag(0x80, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
        return .timeout
      }
      registers.write(.tdr, value: UInt32(data.load(as: UInt8.self)))
      data = data.advanced(by: 1)
    }
    if waitOnFlag(
      transmissionCompletionFlag(), status: 0, start: start, timeout: timeout, getTick: getTick)
      != .ok
    {
      return .timeout
    }
    disable()
    if handle.read(.mode) == 8 && handle.read(.nackEnable) == 0x10 {
      modify(.cr1, clear: 4, set: 0)
    }
    if handle.read(.mode) == 12 || handle.read(.nackEnable) == 0x10 { flushDataRegisters() }
    enable()
    handle.write(.globalState, value: 0x20)
    unlock()
    return .ok
  }
  @discardableResult
  public func receive(
    _ data: UnsafeMutableRawPointer?, size: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    if handle.read(.receiveState) != 0x20 { return .busy }
    guard var data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.write(.errorCode, value: 0)
    handle.write(.receiveState, value: 0x22)
    let start = getTick()
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    while handle.read(.receiveCount) > 0 {
      handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
      if waitOnFlag(0x20, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
        return .timeout
      }
      data.storeBytes(of: UInt8(truncatingIfNeeded: registers.read(.rdr) & 0xFF), as: UInt8.self)
      data = data.advanced(by: 1)
    }
    handle.write(.receiveState, value: 0x20)
    unlock()
    return .ok
  }
  func prepareTransmitRegisters() {
    disable()
    if handle.read(.mode) == 8 && handle.read(.nackEnable) == 0x10 {
      modify(.cr1, clear: 0, set: 4)
    }
    modify(.cr1, clear: 0, set: 8)
    enable()
    flushDataRegisters()
  }
}
