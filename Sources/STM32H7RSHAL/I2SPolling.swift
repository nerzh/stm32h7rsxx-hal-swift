// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2S {
  public func transmit(
    buffer: UnsafeMutableRawPointer?, count: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tickstart: UInt32
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }

    guard lock() else { return .busy }

    tickstart = getTick()

    handle.write(.state, value: 0x3)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.transmit, value: pData)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))

    handle.writePointer(.receive, value: nil)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

    if (registers.read(.cr1) & 0x1) != 0x1 {
      enable()
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))

    if waitFlag(0x2, 1, tickstart, Timeout, getTick: getTick) != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))
      handle.write(.state, value: 0x1)
      unlock()
      return .timeout
    }
    while UInt32(handle.read(.transmitCount)) > 0 {
      if (handle.read(.dataFormat) == 0x100) || (handle.read(.dataFormat) == 0x200) {
        registers.write(.txdr, value: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self)))
        handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
        handle.write(
          .transmitCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
      } else {
        registers.write16(
          .txdr,
          value: UInt16(
            truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt16.self))))
        handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
        handle.write(
          .transmitCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
      }

      if waitFlag(0x2, 1, tickstart, Timeout, getTick: getTick) != .ok {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))
        handle.write(.state, value: 0x1)
        unlock()
        return .timeout
      }

      if getFlag(0x20) == 1 {
        clearUnderrunFlag()

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
      }
    }
    handle.write(.state, value: 0x1)
    unlock()
    return .ok

  }
  public func receive(
    buffer: UnsafeMutableRawPointer?, count: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tickstart: UInt32
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }

    guard lock() else { return .busy }

    tickstart = getTick()

    handle.write(.state, value: 0x4)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.receive, value: pData)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))

    handle.writePointer(.transmit, value: nil)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

    if (registers.read(.cr1) & 0x1) != 0x1 {
      enable()
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))

    while UInt32(handle.read(.receiveCount)) > 0 {
      if waitFlag(0x1, 1, tickstart, Timeout, getTick: getTick) != .ok {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))
        handle.write(.state, value: 0x1)
        unlock()
        return .timeout
      }
      if (handle.read(.dataFormat) == 0x100) || (handle.read(.dataFormat) == 0x200) {
        handle.readPointer(.receive)!.storeBytes(
          of: UInt32(truncatingIfNeeded: registers.read(.rxdr)), as: UInt32.self)
        handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
        handle.write(
          .receiveCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
      } else {
        handle.readPointer(.receive)!.storeBytes(
          of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
        handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
        handle.write(
          .receiveCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
      }

      if getFlag(0x40) == 1 {
        clearOverrunFlag()

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
      }
    }
    handle.write(.state, value: 0x1)
    unlock()
    return .ok

  }
  public func transmitReceive(
    transmitBuffer: UnsafeMutableRawPointer?, receiveBuffer: UnsafeMutableRawPointer?,
    count: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let pTxData = transmitBuffer
    let pRxData = receiveBuffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tmp_TxXferCount: UInt32
    var tmp_RxXferCount: UInt32
    var tickstart: UInt32

    if (pTxData == nil) || (pRxData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }

    guard lock() else { return .busy }

    tickstart = getTick()
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))
    handle.writePointer(.transmit, value: pTxData)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))
    handle.writePointer(.receive, value: pRxData)
    tmp_TxXferCount = UInt32(handle.read(.transmitCount))
    tmp_RxXferCount = UInt32(handle.read(.receiveCount))

    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x5)

    if (registers.read(.cr1) & 0x1) != 0x1 {
      enable()
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    while (tmp_TxXferCount > 0) || (tmp_RxXferCount > 0) {
      if (getFlag(0x2) == 1) && (tmp_TxXferCount != 0) {
        if (handle.read(.dataFormat) == 0x100) || (handle.read(.dataFormat) == 0x200) {
          registers.write(
            .txdr, value: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self)))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
          tmp_TxXferCount &-= 1
        } else {
          registers.write16(
            .txdr,
            value: UInt16(
              truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt16.self))))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
          tmp_TxXferCount &-= 1
        }

        if getFlag(0x20) == 1 {
          clearUnderrunFlag()

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
        }
      }
      if (getFlag(0x1) == 1) && (tmp_RxXferCount != 0) {
        if (handle.read(.dataFormat) == 0x100) || (handle.read(.dataFormat) == 0x200) {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt32(truncatingIfNeeded: registers.read(.rxdr)), as: UInt32.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
          tmp_RxXferCount &-= 1
        } else {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
          tmp_RxXferCount &-= 1
        }

        if getFlag(0x40) == 1 {
          clearOverrunFlag()

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
        }
      }

      if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))
        handle.write(.state, value: 0x1)
        unlock()
        return .timeout
      }
    }
    handle.write(.state, value: 0x1)
    unlock()
    return .ok

  }
  func waitFlag(
    _ Flag: UInt32, _ State: UInt32, _ Tickstart: UInt32, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    while ((getFlag(Flag) != 0) ? 1 : 0) != State {
      if Timeout != UInt32.max {
        if ((getTick() &- Tickstart) >= Timeout) || (Timeout == 0) {
          handle.write(.state, value: 0x1)

          unlock()
          return .timeout
        }
      }
    }
    return .ok

  }
}
