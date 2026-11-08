// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  func waitOnFlag(
    _ Flag: UInt32, _ Status: UInt32, _ Timeout: UInt32, _ Tickstart: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    while getFlag(Flag) == Status {
      if checkPollingErrors(Timeout, Tickstart, getTick: getTick) != .ok {
        return .error
      }

      if Timeout != UInt32.max {
        if ((getTick() &- Tickstart) > Timeout) || (Timeout == 0) {
          if getFlag(Flag) == Status {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
            handle.write(.state, value: 0x20)
            handle.write(.mode, value: 0x0)

            unlock()
            return .error
          }
        }
      }
    }
    return .ok

  }
  func waitOnTransmitReady(_ Timeout: UInt32, _ Tickstart: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {

    while getFlag(0x2) == 0 {
      if checkPollingErrors(Timeout, Tickstart, getTick: getTick) != .ok {
        return .error
      }

      if Timeout != UInt32.max {
        if ((getTick() &- Tickstart) > Timeout) || (Timeout == 0) {
          if getFlag(0x2) == 0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
            handle.write(.state, value: 0x20)
            handle.write(.mode, value: 0x0)

            unlock()
            return .error
          }
        }
      }
    }
    return .ok

  }
  func waitOnReceiveReady(_ Timeout: UInt32, _ Tickstart: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {

    var status: HALStatus = .ok
    while (getFlag(0x4) == 0) && (status == .ok) {
      if checkPollingErrors(Timeout, Tickstart, getTick: getTick) != .ok {
        status = .error
      }

      if (getFlag(0x20) == 1) && (status == .ok) {

        if (getFlag(0x4) == 1) && (UInt32(handle.read(.transferSize)) > 0) {

          status = .ok
        }

        if getFlag(0x10) == 1 {
          clearFlag(0x10)
          handle.write(.errorCode, value: 0x4)

          clearFlag(0x20)

          resetCR2()
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          unlock()
          status = .error
        } else {
          handle.write(.errorCode, value: 0x0)
        }
      }

      if (((getTick() &- Tickstart) > Timeout) || (Timeout == 0)) && (status == .ok) {
        if getFlag(0x4) == 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
          handle.write(.state, value: 0x20)

          unlock()
          status = .error
        }
      }
    }
    return status

  }
  func waitOnStop(_ Timeout: UInt32, _ Tickstart: UInt32, getTick: () -> UInt32) -> HALStatus {

    while getFlag(0x20) == 0 {
      if checkPollingErrors(Timeout, Tickstart, getTick: getTick) != .ok {
        return .error
      }

      if ((getTick() &- Tickstart) > Timeout) || (Timeout == 0) {
        if getFlag(0x20) == 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
          handle.write(.state, value: 0x20)
          handle.write(.mode, value: 0x0)

          unlock()
          return .error
        }
      }
    }
    return .ok

  }
  func checkPollingErrors(_ Timeout: UInt32, _ Tickstart: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {

    var status: HALStatus = .ok
    var itflag: UInt32 = registers.read(.isr)
    var error_code: UInt32 = 0
    var tickstart: UInt32 = Tickstart
    var tmp1: UInt32
    var tmp2: UInt32
    if (itflag & 0x10) == 0x10 {
      clearFlag(0x10)

      while (getFlag(0x20) == 0) && (status == .ok) {
        if Timeout != UInt32.max {
          if ((getTick() &- tickstart) > Timeout) || (Timeout == 0) {
            tmp1 = ((registers.read(.cr2) & 0x4000))
            tmp2 = handle.read(.mode)

            if (getFlag(0x8000) != 0) && (tmp1 != 0x4000) && (tmp2 != 0x20) {
              registers.write(.cr2, value: registers.read(.cr2) | (0x4000))

              tickstart = getTick()
            }
            while getFlag(0x20) == 0 {
              if (getTick() &- tickstart) > 0x19 {
                error_code |= 0x20
                status = .error
                break
              }
            }
          }
        }
      }

      if status == .ok {
        clearFlag(0x20)
      }
      error_code |= 0x4
      status = .error
    }

    itflag = registers.read(.isr)

    if (itflag & 0x100) == 0x100 {
      error_code |= 0x1

      clearFlag(0x100)
      status = .error
    }

    if (itflag & 0x400) == 0x400 {
      error_code |= 0x8

      clearFlag(0x400)
      status = .error
    }

    if (itflag & 0x200) == 0x200 {
      error_code |= 0x2

      clearFlag(0x200)
      status = .error
    }
    if status != .ok {
      flushTransmitData()

      resetCR2()
      handle.write(.errorCode, value: handle.read(.errorCode) | (error_code))
      handle.write(.state, value: 0x20)
      handle.write(.mode, value: 0x0)

      unlock()
    }
    return status

  }
  func requestMemoryWrite(
    _ DevAddress: UInt32, _ MemAddress: UInt32, _ MemAddSize: UInt32, _ Timeout: UInt32,
    _ Tickstart: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    transferConfiguration(
      UInt16(truncatingIfNeeded: DevAddress), UInt8(truncatingIfNeeded: ((MemAddSize) & 0xFF)),
      0x1000000, 0x8000_2000)

    if waitOnTransmitReady(Timeout, Tickstart, getTick: getTick) != .ok {
      return .error
    }

    if MemAddSize == 0x1 {
      registers.write(.txdr, value: (MemAddress & 0xFF))
    } else {
      registers.write(.txdr, value: ((MemAddress & 0xFF00) >> 8))

      if waitOnTransmitReady(Timeout, Tickstart, getTick: getTick) != .ok {
        return .error
      }

      registers.write(.txdr, value: (MemAddress & 0xFF))
    }

    if waitOnFlag(0x80, 0, Timeout, Tickstart, getTick: getTick) != .ok {
      return .error
    }
    return .ok

  }
  func requestMemoryRead(
    _ DevAddress: UInt32, _ MemAddress: UInt32, _ MemAddSize: UInt32, _ Timeout: UInt32,
    _ Tickstart: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    transferConfiguration(
      UInt16(truncatingIfNeeded: DevAddress), UInt8(truncatingIfNeeded: ((MemAddSize) & 0xFF)), 0x0,
      0x8000_2000)

    if waitOnTransmitReady(Timeout, Tickstart, getTick: getTick) != .ok {
      return .error
    }

    if MemAddSize == 0x1 {
      registers.write(.txdr, value: (MemAddress & 0xFF))
    } else {
      registers.write(.txdr, value: ((MemAddress & 0xFF00) >> 8))

      if waitOnTransmitReady(Timeout, Tickstart, getTick: getTick) != .ok {
        return .error
      }

      registers.write(.txdr, value: (MemAddress & 0xFF))
    }

    if waitOnFlag(0x40, 0, Timeout, Tickstart, getTick: getTick) != .ok {
      return .error
    }
    return .ok

  }
}
