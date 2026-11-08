// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// IRDA blocking transfers from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension IRDA {
  @discardableResult
  public func transmit(
    _ data: UnsafeRawPointer?, size: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    if handle.read(.globalState) != 0x20 { return .busy }
    guard var data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: 0x21)
    let start = getTick()
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    let halfWord = handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0
    while handle.read(.transmitCount) > 0 {
      handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
      if waitOnFlag(0x80, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
        return .timeout
      }
      if halfWord {
        registers.write(.tdr, value: UInt32(data.load(as: UInt16.self) & 0x1FF))
      } else {
        registers.write(.tdr, value: UInt32(data.load(as: UInt8.self)))
      }
      data = data.advanced(by: halfWord ? 2 : 1)
    }
    if waitOnFlag(0x40, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
      return .timeout
    }
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
    computeMask()
    let mask = handle.read(.mask)
    let halfWord = handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0
    while handle.read(.receiveCount) > 0 {
      handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
      if waitOnFlag(0x20, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
        return .timeout
      }
      if halfWord {
        data.storeBytes(
          of: UInt16(truncatingIfNeeded: registers.read(.rdr) & UInt32(mask)), as: UInt16.self)
      } else {
        data.storeBytes(
          of: UInt8(truncatingIfNeeded: registers.read(.rdr) & UInt32(mask & 0xFF)), as: UInt8.self)
      }
      data = data.advanced(by: halfWord ? 2 : 1)
    }
    handle.write(.receiveState, value: 0x20)
    unlock()
    return .ok
  }
}
