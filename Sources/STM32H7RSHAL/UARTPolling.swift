// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Blocking transfers and shared wait/mask helpers from stm32h7rsxx_hal_uart.c
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension UART {
  // Size counts UInt16 elements for 9-bit/no-parity and UInt8 elements for all
  // other configurations. The raw buffer must contain that many elements,
  // with UInt16 alignment in 9-bit/no-parity mode. No buffer copy is made.
  @discardableResult
  public func transmit(
    _ data: UnsafeRawPointer?, size: UInt16, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    if handle.read(.globalState) != 0x20 { return .busy }
    guard let data, size != 0 else { return .error }
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: 0x21)
    let start = getTick()
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    let wide = handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0
    var cursor = data
    while handle.read(.transmitCount) > 0 {
      if waitOnFlagUntilTimeout(
        flag: 0x80, status: false, tickStart: start, timeout: timeout,
        getTick: getTick) != .ok
      {
        handle.write(.globalState, value: 0x20)
        return .timeout
      }
      if wide {
        registers.write(.tdr, value: UInt32(cursor.load(as: UInt16.self) & 0x01FF))
        cursor = cursor.advanced(by: 2)
      } else {
        registers.write(.tdr, value: UInt32(cursor.load(as: UInt8.self) & 0xFF))
        cursor = cursor.advanced(by: 1)
      }
      if handle.read(.globalState) & 0x21 == 0x21 {
        handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
      } else {
        return .error
      }
    }
    if waitOnFlagUntilTimeout(
      flag: 0x40, status: false, tickStart: start, timeout: timeout,
      getTick: getTick) != .ok
    {
      handle.write(.globalState, value: 0x20)
      return .timeout
    }
    handle.write(.globalState, value: 0x20)
    return .ok
  }

  @discardableResult
  public func receive(
    _ data: UnsafeMutableRawPointer?, size: UInt16, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    if handle.read(.receiveState) != 0x20 { return .busy }
    guard let data, size != 0 else { return .error }
    handle.write(.errorCode, value: 0)
    handle.write(.receiveState, value: 0x22)
    handle.write(.receptionType, value: 0)
    let start = getTick()
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    computeMask()
    let mask = handle.read(.mask)
    let wide = handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0
    var cursor = data
    while handle.read(.receiveCount) > 0 {
      if waitOnFlagUntilTimeout(
        flag: 0x20, status: false, tickStart: start, timeout: timeout,
        getTick: getTick) != .ok
      {
        handle.write(.receiveState, value: 0x20)
        return .timeout
      }
      if wide {
        let value = UInt16(truncatingIfNeeded: registers.read(.rdr) & UInt32(mask))
        cursor.storeBytes(of: value, as: UInt16.self)
        cursor = cursor.advanced(by: 2)
      } else {
        let value = UInt8(
          truncatingIfNeeded: registers.read(.rdr) & UInt32(UInt8(truncatingIfNeeded: mask)))
        cursor.storeBytes(of: value, as: UInt8.self)
        cursor = cursor.advanced(by: 1)
      }
      if handle.read(.receiveState) == 0x22 {
        handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
      } else {
        return .error
      }
    }
    handle.write(.receiveState, value: 0x20)
    return .ok
  }

  // Typed overloads enforce the element interpretation before entering the
  // exact raw-pointer HAL algorithm. Raw APIs retain the C nil/zero paths.
  @discardableResult
  public func transmit(_ data: UnsafeBufferPointer<UInt8>, timeout: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {
    precondition(data.count <= Int(UInt16.max))
    precondition(handle.read(.wordLength) != 0x1000 || handle.read(.parity) != 0)
    return transmit(data.baseAddress, size: UInt16(data.count), timeout: timeout, getTick: getTick)
  }

  @discardableResult
  public func transmit(_ data: UnsafeBufferPointer<UInt16>, timeout: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {
    precondition(data.count <= Int(UInt16.max))
    precondition(handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0)
    return transmit(data.baseAddress, size: UInt16(data.count), timeout: timeout, getTick: getTick)
  }

  @discardableResult
  public func receive(
    _ data: UnsafeMutableBufferPointer<UInt8>, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    precondition(data.count <= Int(UInt16.max))
    precondition(handle.read(.wordLength) != 0x1000 || handle.read(.parity) != 0)
    return receive(data.baseAddress, size: UInt16(data.count), timeout: timeout, getTick: getTick)
  }

  @discardableResult
  public func receive(
    _ data: UnsafeMutableBufferPointer<UInt16>, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    precondition(data.count <= Int(UInt16.max))
    precondition(handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0)
    return receive(data.baseAddress, size: UInt16(data.count), timeout: timeout, getTick: getTick)
  }

  func computeMask() {
    if handle.read(.wordLength) == 0x1000 {
      if handle.read(.parity) == 0 {
        handle.write(.mask, value: 0x1FF)
      } else {
        handle.write(.mask, value: 0xFF)
      }
    } else if handle.read(.wordLength) == 0 {
      if handle.read(.parity) == 0 {
        handle.write(.mask, value: 0xFF)
      } else {
        handle.write(.mask, value: 0x7F)
      }
    } else if handle.read(.wordLength) == 0x1000_0000 {
      if handle.read(.parity) == 0 {
        handle.write(.mask, value: 0x7F)
      } else {
        handle.write(.mask, value: 0x3F)
      }
    } else {
      handle.write(.mask, value: 0)
    }
  }

  func checkIdleState(getTick: () -> UInt32) -> HALStatus {
    handle.write(.errorCode, value: 0)
    let start = getTick()
    if registers.read(.cr1) & 8 == 8 {
      if waitOnFlagUntilTimeout(
        flag: 0x200000, status: false, tickStart: start, timeout: 0x01FF_FFFF,
        getTick: getTick) != .ok
      {
        registers.atomicModify(.cr1, clear: 0x80, set: 0)
        handle.write(.globalState, value: 0x20)
        unlock()
        return .timeout
      }
    }
    if registers.read(.cr1) & 4 == 4 {
      if waitOnFlagUntilTimeout(
        flag: 0x400000, status: false, tickStart: start, timeout: 0x01FF_FFFF,
        getTick: getTick) != .ok
      {
        registers.atomicModify(.cr1, clear: 0x120, set: 0)
        registers.atomicModify(.cr3, clear: 1, set: 0)
        handle.write(.receiveState, value: 0x20)
        unlock()
        return .timeout
      }
    }
    handle.write(.globalState, value: 0x20)
    handle.write(.receiveState, value: 0x20)
    handle.write(.receptionType, value: 0)
    handle.write(.rxEventType, value: 0)
    unlock()
    return .ok
  }

  func waitOnFlagUntilTimeout(
    flag: UInt32, status: Bool, tickStart: UInt32, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    while (getFlag(flag) != 0) == status {
      if timeout != UInt32.max {
        if getTick() &- tickStart > timeout || timeout == 0 { return .timeout }
        if registers.read(.cr1) & 4 != 0 && flag != 0x80 && flag != 0x40 {
          if getFlag(8) == 1 {
            clearFlag(8)
            endReceiveTransfer()
            handle.write(.errorCode, value: 8)
            unlock()
            return .error
          }
          if getFlag(0x800) == 1 {
            clearFlag(0x800)
            endReceiveTransfer()
            handle.write(.errorCode, value: 0x20)
            unlock()
            return .timeout
          }
        }
      }
    }
    return .ok
  }
}
