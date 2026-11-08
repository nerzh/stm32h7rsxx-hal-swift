// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Blocking USART transfers from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USART {
  @discardableResult
  public func transmit(
    _ data: UnsafeRawPointer?, size: UInt16, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    if handle.read(.state) != 1 { return .busy }
    guard var data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x12)
    let start = getTick()
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    let halfWord = handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0
    while handle.read(.transmitCount) > 0 {
      if waitOnFlag(0x80, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
        return .timeout
      }
      if halfWord {
        registers.write(.tdr, value: UInt32(data.load(as: UInt16.self) & 0x1FF))
      } else {
        registers.write(.tdr, value: UInt32(data.load(as: UInt8.self)))
      }
      data = data.advanced(by: halfWord ? 2 : 1)
      handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
    }
    if waitOnFlag(0x40, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
      return .timeout
    }
    clearFlag(0x40)
    clearFlag(8)
    sendRequest(8)
    sendRequest(0x10)
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }
  @discardableResult
  public func receive(
    _ data: UnsafeMutableRawPointer?, size: UInt16, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    if handle.read(.state) != 1 { return .busy }
    guard var data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x22)
    let start = getTick()
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    computeMask()
    let mask = handle.read(.mask)
    let halfWord = handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0
    while handle.read(.receiveCount) > 0 {
      if handle.read(.slaveMode) == 0 {
        if waitOnFlag(0x80, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
          return .timeout
        }
        registers.write(.tdr, value: 0xFF)
      }
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
      handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
    }
    if handle.read(.slaveMode) == 1 {
      clearFlag(0x2000)
      sendRequest(0x10)
    }
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }
  @discardableResult
  public func transmitReceive(
    _ transmitData: UnsafeRawPointer?, receiveData: UnsafeMutableRawPointer?,
    size: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    if handle.read(.state) != 1 { return .busy }
    guard var tx = transmitData, var rx = receiveData, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x22)
    let start = getTick()
    handle.write(.receiveSize, value: size)
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    handle.write(.receiveCount, value: size)
    computeMask()
    let mask = handle.read(.mask)
    let halfWord = handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0
    if handle.read(.transmitCount) == 1 || handle.read(.slaveMode) == 1 {
      if waitOnFlag(0x80, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
        return .timeout
      }
      if halfWord {
        registers.write(.tdr, value: UInt32(tx.load(as: UInt16.self) & mask))
      } else {
        registers.write(.tdr, value: UInt32(tx.load(as: UInt8.self)) & UInt32(mask & 0xFF))
      }
      tx = tx.advanced(by: halfWord ? 2 : 1)
      handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
    }
    var rxCount = handle.read(.receiveCount)
    while handle.read(.transmitCount) > 0 || rxCount > 0 {
      if handle.read(.transmitCount) > 0 {
        if waitOnFlag(0x80, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
          return .timeout
        }
        if halfWord {
          registers.write(.tdr, value: UInt32(tx.load(as: UInt16.self) & mask))
        } else {
          registers.write(.tdr, value: UInt32(tx.load(as: UInt8.self)) & UInt32(mask & 0xFF))
        }
        tx = tx.advanced(by: halfWord ? 2 : 1)
        handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
      }
      if handle.read(.receiveCount) > 0 {
        if waitOnFlag(0x20, status: 0, start: start, timeout: timeout, getTick: getTick) != .ok {
          return .timeout
        }
        if halfWord {
          rx.storeBytes(
            of: UInt16(truncatingIfNeeded: registers.read(.rdr) & UInt32(mask)), as: UInt16.self)
        } else {
          rx.storeBytes(
            of: UInt8(truncatingIfNeeded: registers.read(.rdr) & UInt32(mask & 0xFF)),
            as: UInt8.self)
        }
        rx = rx.advanced(by: halfWord ? 2 : 1)
        handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
      }
      rxCount = handle.read(.receiveCount)
    }
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }
}
