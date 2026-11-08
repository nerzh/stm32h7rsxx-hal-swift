// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SAI {
  public func transmit(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, timeout: UInt32, getTick: () -> UInt32,
    systemCoreClock: () -> UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    let tickstart: UInt32 = getTick()
    var temp: UInt32
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.writeBuffer(pData)
      handle.write(.state, value: 0x12)
      handle.write(.errorCode, value: 0x0)

      if (registers.read(.cr1) & 0x10000) == 0 {
        fillFIFO()
        enable()
      }
      while UInt32(handle.read(.transferCount)) > 0 {
        if (registers.read(.sr) & 0x70000) != 0x50000 {
          if (handle.read(.dataSize) == 0x40) && (handle.read(.compandingMode) == 0x0) {
            registers.write(.dr, value: UInt32(handle.readBuffer()!.pointee))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
          } else if handle.read(.dataSize) <= 0x80 {
            temp = ((UInt32(handle.readBuffer()!.pointee)))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            temp |= (((UInt32(handle.readBuffer()!.pointee))) << 8)
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            registers.write(.dr, value: temp)
          } else {
            temp = ((UInt32(handle.readBuffer()!.pointee)))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            temp |= (((UInt32(handle.readBuffer()!.pointee))) << 8)
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            temp |= (((UInt32(handle.readBuffer()!.pointee))) << 16)
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            temp |= (((UInt32(handle.readBuffer()!.pointee))) << 24)
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            registers.write(.dr, value: temp)
          }
          handle.write(
            .transferCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
        } else {
          if (((getTick() &- tickstart) > Timeout) || (Timeout == 0)) && (Timeout != UInt32.max) {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))

            registers.write(.clrfr, value: 0xFFFF_FFFF)

            _ = disableBlock(systemCoreClock: systemCoreClock)

            registers.write(.cr2, value: registers.read(.cr2) | (0x8))

            handle.write(.state, value: 0x1)

            unlock()
            return .error
          }
        }
      }
      handle.write(.state, value: 0x1)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func receive(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, timeout: UInt32, getTick: () -> UInt32,
    systemCoreClock: () -> UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    let tickstart: UInt32 = getTick()
    var temp: UInt32
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.writeBuffer(pData)
      handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.state, value: 0x22)
      handle.write(.errorCode, value: 0x0)

      if (registers.read(.cr1) & 0x10000) == 0 {
        enable()
      }

      while UInt32(handle.read(.transferCount)) > 0 {
        if (registers.read(.sr) & 0x70000) != 0x0 {
          if (handle.read(.dataSize) == 0x40) && (handle.read(.compandingMode) == 0x0) {
            handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.dr)) & 0xFF))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
          } else if handle.read(.dataSize) <= 0x80 {
            temp = registers.read(.dr)
            handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((temp) & 0xFF))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((temp >> 8)) & 0xFF))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
          } else {
            temp = registers.read(.dr)
            handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((temp) & 0xFF))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((temp >> 8)) & 0xFF))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((temp >> 16)) & 0xFF))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
            handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((temp >> 24)) & 0xFF))
            handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
          }
          handle.write(
            .transferCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
        } else {
          if (((getTick() &- tickstart) > Timeout) || (Timeout == 0)) && (Timeout != UInt32.max) {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))

            registers.write(.clrfr, value: 0xFFFF_FFFF)

            _ = disableBlock(systemCoreClock: systemCoreClock)

            registers.write(.cr2, value: registers.read(.cr2) | (0x8))

            handle.write(.state, value: 0x1)

            unlock()
            return .error
          }
        }
      }
      handle.write(.state, value: 0x1)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func enableTransmitMute(value: UInt16) -> HALStatus {
    let val = UInt32(value)

    if handle.read(.state) != 0x0 {
      registers.write(.cr2, value: registers.read(.cr2) & (~(0x40 | 0x20)))
      registers.write(.cr2, value: registers.read(.cr2) | (0x20 | (val)))
      return .ok
    }
    return .error

  }
  public func disableTransmitMute() -> HALStatus {

    if handle.read(.state) != 0x0 {
      registers.write(.cr2, value: registers.read(.cr2) & (~(0x40 | 0x20)))
      return .ok
    }
    return .error

  }
  public func enableReceiveMute(callback: SAIMuteCallback?, counter: UInt16) -> HALStatus {
    let counter = UInt32(counter)

    if handle.read(.state) != 0x0 {
      registers.write(.cr2, value: registers.read(.cr2) & (~(0x1f80)))
      registers.write(.cr2, value: registers.read(.cr2) | ((((counter) << 0x7))))
      callbacks.writeMute(callback)
      enableInterrupts(0x2)
      return .ok
    }
    return .error

  }
  public func disableReceiveMute() -> HALStatus {

    if handle.read(.state) != 0x0 {
      callbacks.writeMute(nil)
      disableInterrupts(0x2)
      return .ok
    }
    return .error

  }
  func fillFIFO() {

    var temp: UInt32

    while ((registers.read(.sr) & 0x70000) != 0x50000) && (UInt32(handle.read(.transferCount)) > 0)
    {
      if (handle.read(.dataSize) == 0x40) && (handle.read(.compandingMode) == 0x0) {
        registers.write(.dr, value: UInt32(handle.readBuffer()!.pointee))
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
      } else if handle.read(.dataSize) <= 0x80 {
        temp = ((UInt32(handle.readBuffer()!.pointee)))
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
        temp |= (((UInt32(handle.readBuffer()!.pointee))) << 8)
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
        registers.write(.dr, value: temp)
      } else {
        temp = ((UInt32(handle.readBuffer()!.pointee)))
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
        temp |= (((UInt32(handle.readBuffer()!.pointee))) << 8)
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
        temp |= (((UInt32(handle.readBuffer()!.pointee))) << 16)
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
        temp |= (((UInt32(handle.readBuffer()!.pointee))) << 24)
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
        registers.write(.dr, value: temp)
      }
      handle.write(
        .transferCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
    }

  }
}
