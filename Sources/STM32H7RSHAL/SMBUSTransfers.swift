// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMBUS {
  public func masterTransmitInterrupt(
    _ DevAddress: UInt16, _ pData: UnsafeMutablePointer<UInt8>?, _ Size: UInt16,
    _ XferOptions: UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(DevAddress)
    let Size = UInt32(Size)

    var tmp: UInt32

    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x12)
      handle.write(.errorCode, value: 0x0)
      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: XferOptions)

      if handle.readBuffer() == nil {
        handle.write(.transferOptions, value: handle.read(.transferOptions) & (~0x2000000))
      }
      if Size > 0xff {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xff))
      } else {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      }

      if (UInt32(handle.read(.transferSize)) < UInt32(handle.read(.transferCount)))
        && (UInt32(handle.read(.transferSize)) == 0xff)
      {
        transferConfiguration(
          DevAddress, ((UInt32(handle.read(.transferSize))) & 0xFF),
          0x1000000 | (handle.read(.transferOptions) & 0x4000000), 0x8000_2000)
      } else {

        tmp = handle.read(.transferOptions)
        if (handle.read(.previousState) == 0x12) && (isOtherTransferOptions(tmp) == 0) {
          transferConfiguration(
            DevAddress, ((UInt32(handle.read(.transferSize))) & 0xFF),
            handle.read(.transferOptions), 0x0)
        } else {
          convertOtherTransferOptions()

          transferConfiguration(
            DevAddress, ((UInt32(handle.read(.transferSize))) & 0xFF),
            handle.read(.transferOptions), 0x8000_2000)
        }

        if pecMode() != 0 {
          if UInt32(handle.read(.transferSize)) > 0 {
            handle.write(
              .transferSize,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
            handle.write(
              .transferCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
          } else {
            return .error
          }
        }
      }

      unlock()

      enableIRQ(0xf2)
      return .ok
    } else {
      return .busy
    }

  }
  public func masterReceiveInterrupt(
    _ DevAddress: UInt16, _ pData: UnsafeMutablePointer<UInt8>?, _ Size: UInt16,
    _ XferOptions: UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(DevAddress)
    let Size = UInt32(Size)

    var tmp: UInt32

    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: XferOptions)

      if handle.readBuffer() == nil {
        handle.write(.transferOptions, value: handle.read(.transferOptions) & (~0x2000000))
      }
      if Size > 0xff {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xff))
      } else {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      }

      if (UInt32(handle.read(.transferSize)) < UInt32(handle.read(.transferCount)))
        && (UInt32(handle.read(.transferSize)) == 0xff)
      {
        transferConfiguration(
          DevAddress, ((UInt32(handle.read(.transferSize))) & 0xFF),
          0x1000000 | (handle.read(.transferOptions) & 0x4000000), 0x8000_2400)
      } else {

        tmp = handle.read(.transferOptions)
        if (handle.read(.previousState) == 0x22) && (isOtherTransferOptions(tmp) == 0) {
          transferConfiguration(
            DevAddress, ((UInt32(handle.read(.transferSize))) & 0xFF),
            handle.read(.transferOptions), 0x0)
        } else {
          convertOtherTransferOptions()

          transferConfiguration(
            DevAddress, ((UInt32(handle.read(.transferSize))) & 0xFF),
            handle.read(.transferOptions), 0x8000_2400)
        }
      }

      unlock()

      enableIRQ(0xd4)
      return .ok
    } else {
      return .busy
    }

  }
  public func abortMasterInterrupt(_ DevAddress: UInt16) -> HALStatus {
    let DevAddress = UInt32(DevAddress)

    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }

      if handle.read(.previousState) == 0x12 {
        handle.write(.state, value: 0x12)
      } else if handle.read(.previousState) == 0x22 {
        handle.write(.state, value: 0x22)
      } else {

        return .error
      }
      handle.write(.errorCode, value: 0x0)

      transferConfiguration(DevAddress, 1, 0x2000000, 0x0)

      unlock()

      if handle.read(.state) == 0x12 {
        enableIRQ(0xf2)
      } else if handle.read(.state) == 0x22 {
        enableIRQ(0xd4)
      } else {
      }
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveTransmitInterrupt(
    _ pData: UnsafeMutablePointer<UInt8>?, _ Size: UInt16, _ XferOptions: UInt32
  ) -> HALStatus {
    let Size = UInt32(Size)

    if (handle.read(.state) & 0x8) == 0x8 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }

      disableIRQ(0x38 | 0xf2)

      guard lock() else { return .busy }
      handle.write(.state, value: (0x32 | 0x8))
      handle.write(.errorCode, value: 0x0)

      registers.write(.cr1, value: registers.read(.cr1) | (0x10000))

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: XferOptions)

      convertOtherTransferOptions()
      if Size > 0xff {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xff))
      } else {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      }

      if (UInt32(handle.read(.transferSize)) < UInt32(handle.read(.transferCount)))
        && (UInt32(handle.read(.transferSize)) == 0xff)
      {
        transferConfiguration(
          0, ((UInt32(handle.read(.transferSize))) & 0xFF),
          0x1000000 | (handle.read(.transferOptions) & 0x4000000), 0x0)
      } else {
        transferConfiguration(
          0, ((UInt32(handle.read(.transferSize))) & 0xFF), handle.read(.transferOptions), 0x0)

        if pecMode() != 0 {
          handle.write(
            .transferSize,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferSize)) &- (1)))
          handle.write(
            .transferCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
        }
      }

      clearFlag(0x8)

      unlock()

      enableIRQ(0xf2 | 0x38)
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveReceiveInterrupt(
    _ pData: UnsafeMutablePointer<UInt8>?, _ Size: UInt16, _ XferOptions: UInt32
  ) -> HALStatus {
    let Size = UInt32(Size)

    if (handle.read(.state) & 0x8) == 0x8 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }

      disableIRQ(0x38 | 0xd4)

      guard lock() else { return .busy }
      handle.write(.state, value: (0x42 | 0x8))
      handle.write(.errorCode, value: 0x0)

      registers.write(.cr1, value: registers.read(.cr1) | (0x10000))

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      handle.writeBuffer(pData)
      handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: XferOptions)

      convertOtherTransferOptions()

      if ((pecMode() != 0) && (UInt32(handle.read(.transferSize)) == 2))
        || (UInt32(handle.read(.transferSize)) == 1)
      {
        transferConfiguration(
          0, ((UInt32(handle.read(.transferSize))) & 0xFF), handle.read(.transferOptions), 0x0)
      } else {
        transferConfiguration(0, 1, handle.read(.transferOptions) | 0x1000000, 0x0)
      }

      clearFlag(0x8)

      unlock()

      enableIRQ(0xd4 | 0x38)
      return .ok
    } else {
      return .busy
    }

  }
  public func enableListenInterrupt() -> HALStatus {

    handle.write(.state, value: 0x8)

    enableIRQ(0x38)
    return .ok

  }
  public func disableListenInterrupt() -> HALStatus {

    if handle.read(.state) == 0x8 {
      handle.write(.state, value: 0x1)

      disableIRQ(0x38)
      return .ok
    } else {
      return .busy
    }

  }
  public func enableAlertInterrupt() -> HALStatus {

    registers.write(.cr1, value: registers.read(.cr1) | (0x400000))

    clearFlag(0x2000)

    enableIRQ(0x80)
    return .ok

  }
  public func disableAlertInterrupt() -> HALStatus {

    registers.write(.cr1, value: registers.read(.cr1) & (~0x400000))

    disableIRQ(0x80)
    return .ok

  }
  public func isDeviceReady(
    _ DevAddress: UInt16, _ Trials: UInt32, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(DevAddress)

    var tickstart: UInt32
    var SMBUS_Trials: UInt32 = 0
    var tmp1: UInt32
    var tmp2: UInt32
    if handle.read(.state) == 0x1 {
      if getFlag(0x8000) != 0 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x2)
      handle.write(.errorCode, value: 0x0)
      repeat {
        registers.write(.cr2, value: generateStart(handle.read(.addressingMode), DevAddress))

        tickstart = getTick()
        tmp1 = getFlag(0x20)
        tmp2 = getFlag(0x10)
        while (tmp1 == 0) && (tmp2 == 0) {
          if Timeout != UInt32.max {
            if ((getTick() &- tickstart) > Timeout) || (Timeout == 0) {
              handle.write(.state, value: 0x1)

              handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

              unlock()
              return .error
            }
          }
          tmp1 = getFlag(0x20)
          tmp2 = getFlag(0x10)
        }

        if getFlag(0x10) == 0 {
          if waitOnFlag(0x20, 0, Timeout, getTick: getTick) != .ok {

            clearFlag(0x20)

            handle.write(.errorCode, value: 0x0)
          } else {

            clearFlag(0x20)

            handle.write(.state, value: 0x1)

            unlock()
            return .ok
          }
        } else {

          clearFlag(0x10)

          if waitOnFlag(0x20, 0, Timeout, getTick: getTick) == .ok {
            clearFlag(0x20)
          }
        }

        SMBUS_Trials &+= 1
      } while SMBUS_Trials < Trials

      handle.write(.state, value: 0x1)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

      unlock()
      return .error
    } else {
      return .busy
    }

  }
}
