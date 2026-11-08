// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  public func masterTransmit(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tickstart: UInt32
    if handle.read(.state) == 0x20 {
      guard lock() else { return .busy }

      tickstart = getTick()
      if waitOnFlag(0x8000, 1, 0x19, tickstart, getTick: getTick) != .ok {
        return .error
      }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferISR, value: 0)

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
          0x8000_2000)
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          0x8000_2000)
      }
      while UInt32(handle.read(.transferCount)) > 0 {
        if waitOnTransmitReady(Timeout, tickstart, getTick: getTick) != .ok {
          return .error
        }
        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
        if (UInt32(handle.read(.transferCount)) != 0) && (UInt32(handle.read(.transferSize)) == 0) {
          if waitOnFlag(0x80, 0, Timeout, tickstart, getTick: getTick) != .ok {
            return .error
          }
          if UInt32(handle.read(.transferCount)) > 0xFF {
            handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
            transferConfiguration(
              UInt16(truncatingIfNeeded: DevAddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
              0x0)
          } else {
            handle.write(
              .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
            transferConfiguration(
              UInt16(truncatingIfNeeded: DevAddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
              0x0)
          }
        }
      }

      if waitOnStop(Timeout, tickstart, getTick: getTick) != .ok {
        return .error
      }

      clearFlag(0x20)

      resetCR2()
      handle.write(.state, value: 0x20)
      handle.write(.mode, value: 0x0)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func masterReceive(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tickstart: UInt32
    if handle.read(.state) == 0x20 {
      guard lock() else { return .busy }

      tickstart = getTick()
      if waitOnFlag(0x8000, 1, 0x19, tickstart, getTick: getTick) != .ok {
        return .error
      }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferISR, value: 0)

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
          0x8000_2400)
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          0x8000_2400)
      }
      while UInt32(handle.read(.transferCount)) > 0 {
        if waitOnReceiveReady(Timeout, tickstart, getTick: getTick) != .ok {
          return .error
        }

        handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

        advanceBuffer(1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
        if (UInt32(handle.read(.transferCount)) != 0) && (UInt32(handle.read(.transferSize)) == 0) {
          if waitOnFlag(0x80, 0, Timeout, tickstart, getTick: getTick) != .ok {
            return .error
          }
          if UInt32(handle.read(.transferCount)) > 0xFF {
            handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
            transferConfiguration(
              UInt16(truncatingIfNeeded: DevAddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
              0x0)
          } else {
            handle.write(
              .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
            transferConfiguration(
              UInt16(truncatingIfNeeded: DevAddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
              0x0)
          }
        }
      }

      if waitOnStop(Timeout, tickstart, getTick: getTick) != .ok {
        return .error
      }

      clearFlag(0x20)

      resetCR2()
      handle.write(.state, value: 0x20)
      handle.write(.mode, value: 0x0)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveTransmit(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tickstart: UInt32
    var tmpXferCount: UInt32
    var error: HALStatus
    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }
      guard lock() else { return .busy }

      tickstart = getTick()
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferISR, value: 0)

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      if handle.read(.noStretchMode) == 0x20000 {

        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
      }

      if waitOnFlag(0x8, 0, Timeout, tickstart, getTick: getTick) != .ok {
        registers.write(.cr2, value: registers.read(.cr2) | (0x8000))

        flushTransmitData()
        return .error
      }

      clearFlag(0x8)

      if handle.read(.addressingMode) == 0x2 {
        if waitOnFlag(0x8, 0, Timeout, tickstart, getTick: getTick) != .ok {
          registers.write(.cr2, value: registers.read(.cr2) | (0x8000))

          flushTransmitData()
          return .error
        }

        clearFlag(0x8)
      }

      if waitOnFlag(0x10000, 0, Timeout, tickstart, getTick: getTick) != .ok {
        registers.write(.cr2, value: registers.read(.cr2) | (0x8000))

        flushTransmitData()
        return .error
      }
      while UInt32(handle.read(.transferCount)) > 0 {
        if waitOnTransmitReady(Timeout, tickstart, getTick: getTick) != .ok {
          registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
          return .error
        }

        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
      }

      error = waitOnFlag(0x10, 0, Timeout, tickstart, getTick: getTick)
      if error != .ok {

        tmpXferCount = UInt32(handle.read(.transferCount))
        if (handle.read(.errorCode) == 0x4) && (tmpXferCount == 0) {
          handle.write(.errorCode, value: 0x0)
        } else {
          registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
          return .error
        }
      } else {
        flushTransmitData()

        clearFlag(0x10)

        if waitOnStop(Timeout, tickstart, getTick: getTick) != .ok {
          registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
          return .error
        }

        clearFlag(0x20)
      }

      if waitOnFlag(0x8000, 1, Timeout, tickstart, getTick: getTick) != .ok {
        registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
        return .error
      }

      registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
      handle.write(.state, value: 0x20)
      handle.write(.mode, value: 0x0)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveReceive(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tickstart: UInt32
    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }
      guard lock() else { return .busy }

      tickstart = getTick()
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferISR, value: 0)

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      if waitOnFlag(0x8, 0, Timeout, tickstart, getTick: getTick) != .ok {
        registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
        return .error
      }

      clearFlag(0x8)

      if waitOnFlag(0x10000, 1, Timeout, tickstart, getTick: getTick) != .ok {
        registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
        return .error
      }
      while UInt32(handle.read(.transferCount)) > 0 {
        if waitOnReceiveReady(Timeout, tickstart, getTick: getTick) != .ok {
          registers.write(.cr2, value: registers.read(.cr2) | (0x8000))

          if getFlag(0x4) == 1 {
            handle.readBuffer()!.pointee = UInt8(
              truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

            advanceBuffer(1)
            handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
            handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
          }
          return .error
        }

        handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

        advanceBuffer(1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
      }

      if waitOnStop(Timeout, tickstart, getTick: getTick) != .ok {
        registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
        return .error
      }

      clearFlag(0x20)

      if waitOnFlag(0x8000, 1, Timeout, tickstart, getTick: getTick) != .ok {
        registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
        return .error
      }

      registers.write(.cr2, value: registers.read(.cr2) | (0x8000))
      handle.write(.state, value: 0x20)
      handle.write(.mode, value: 0x0)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func isDeviceReady(address: UInt16, trials: UInt32, timeout: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {
    let DevAddress = UInt32(address)
    let Trials = trials
    let Timeout = timeout

    var tickstart: UInt32
    var I2C_Trials: UInt32 = 0
    var tmp1: UInt32
    var tmp2: UInt32
    if handle.read(.state) == 0x20 {
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x24)
      handle.write(.errorCode, value: 0x0)
      repeat {
        registers.write(.cr2, value: generateStart(handle.read(.addressingMode), DevAddress))

        tickstart = getTick()
        tmp1 = getFlag(0x20)
        tmp2 = getFlag(0x10)
        while (tmp1 == 0) && (tmp2 == 0) {
          if Timeout != UInt32.max {
            if ((getTick() &- tickstart) > Timeout) || (Timeout == 0) {
              handle.write(.state, value: 0x20)

              handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))

              unlock()
              return .error
            }
          }
          tmp1 = getFlag(0x20)
          tmp2 = getFlag(0x10)
        }

        if getFlag(0x10) == 0 {
          if waitOnFlag(0x20, 0, Timeout, tickstart, getTick: getTick) != .ok {
            if handle.read(.errorCode) == 0x4 {
              clearFlag(0x20)

              handle.write(.errorCode, value: 0x0)
            }
          } else {

            clearFlag(0x20)

            handle.write(.state, value: 0x20)

            unlock()
            return .ok
          }
        } else {

          clearFlag(0x10)

          if waitOnFlag(0x20, 0, Timeout, tickstart, getTick: getTick) == .ok {
            clearFlag(0x20)
          }
        }

        I2C_Trials &+= 1
      } while I2C_Trials < Trials

      handle.write(.state, value: 0x20)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))

      unlock()
      return .error
    } else {
      return .busy
    }

  }
  public func writeMemory(
    address: UInt16, memoryAddress: UInt16, memoryAddressSize: UInt16,
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let MemAddress = UInt32(memoryAddress)
    let MemAddSize = UInt32(memoryAddressSize)
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tickstart: UInt32
    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }

      guard lock() else { return .busy }

      tickstart = getTick()
      if waitOnFlag(0x8000, 1, 0x19, tickstart, getTick: getTick) != .ok {
        return .error
      }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x40)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferISR, value: 0)

      if requestMemoryWrite(
        DevAddress, MemAddress, MemAddSize, Timeout, tickstart, getTick: getTick) != .ok
      {
        unlock()
        return .error
      }

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000, 0x0)
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000, 0x0)
      }
      repeat {
        if waitOnTransmitReady(Timeout, tickstart, getTick: getTick) != .ok {
          return .error
        }

        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
        if (UInt32(handle.read(.transferCount)) != 0) && (UInt32(handle.read(.transferSize)) == 0) {
          if waitOnFlag(0x80, 0, Timeout, tickstart, getTick: getTick) != .ok {
            return .error
          }
          if UInt32(handle.read(.transferCount)) > 0xFF {
            handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
            transferConfiguration(
              UInt16(truncatingIfNeeded: DevAddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
              0x0)
          } else {
            handle.write(
              .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
            transferConfiguration(
              UInt16(truncatingIfNeeded: DevAddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
              0x0)
          }
        }
      } while UInt32(handle.read(.transferCount)) > 0

      if waitOnStop(Timeout, tickstart, getTick: getTick) != .ok {
        return .error
      }

      clearFlag(0x20)

      resetCR2()
      handle.write(.state, value: 0x20)
      handle.write(.mode, value: 0x0)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func readMemory(
    address: UInt16, memoryAddress: UInt16, memoryAddressSize: UInt16,
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let MemAddress = UInt32(memoryAddress)
    let MemAddSize = UInt32(memoryAddressSize)
    let pData = buffer
    let Size = UInt32(count)
    let Timeout = timeout

    var tickstart: UInt32
    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }

      guard lock() else { return .busy }

      tickstart = getTick()
      if waitOnFlag(0x8000, 1, 0x19, tickstart, getTick: getTick) != .ok {
        return .error
      }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x40)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferISR, value: 0)

      if requestMemoryRead(DevAddress, MemAddress, MemAddSize, Timeout, tickstart, getTick: getTick)
        != .ok
      {
        unlock()
        return .error
      }

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
          0x8000_2400)
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        transferConfiguration(
          UInt16(truncatingIfNeeded: DevAddress),
          UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
          0x8000_2400)
      }
      repeat {
        if waitOnFlag(0x4, 0, Timeout, tickstart, getTick: getTick) != .ok {
          return .error
        }

        handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

        advanceBuffer(1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
        if (UInt32(handle.read(.transferCount)) != 0) && (UInt32(handle.read(.transferSize)) == 0) {
          if waitOnFlag(0x80, 0, Timeout, tickstart, getTick: getTick) != .ok {
            return .error
          }
          if UInt32(handle.read(.transferCount)) > 0xFF {
            handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
            transferConfiguration(
              UInt16(truncatingIfNeeded: DevAddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x1000000,
              0x0)
          } else {
            handle.write(
              .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
            transferConfiguration(
              UInt16(truncatingIfNeeded: DevAddress),
              UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), 0x2000000,
              0x0)
          }
        }
      } while UInt32(handle.read(.transferCount)) > 0

      if waitOnStop(Timeout, tickstart, getTick: getTick) != .ok {
        return .error
      }

      clearFlag(0x20)

      resetCR2()
      handle.write(.state, value: 0x20)
      handle.write(.mode, value: 0x0)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
}
