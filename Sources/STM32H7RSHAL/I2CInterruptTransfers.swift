// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  public func masterTransmitInterrupt(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)

    var xfermode: UInt32
    if handle.read(.state) == 0x20 {
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 1)
      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        xfermode = 0x1000000
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        xfermode = 0x2000000
      }

      transferConfiguration(
        UInt16(truncatingIfNeeded: DevAddress),
        UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode,
        0x8000_2000)

      unlock()

      enableIRQ(0x1)
      return .ok
    } else {
      return .busy
    }

  }
  public func masterReceiveInterrupt(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)

    var xfermode: UInt32
    if handle.read(.state) == 0x20 {
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 1)
      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        xfermode = 0x1000000
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        xfermode = 0x2000000
      }

      transferConfiguration(
        UInt16(truncatingIfNeeded: DevAddress),
        UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode,
        0x8000_2400)

      unlock()

      enableIRQ(0x2)
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveTransmitInterrupt(buffer: UnsafeMutablePointer<UInt8>?, count: UInt16)
    -> HALStatus
  {
    let pData = buffer
    let Size = UInt32(count)

    if handle.read(.state) == 0x20 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 3)

      if handle.read(.noStretchMode) == 0x20000 {

        registers.write(.txdr, value: UInt32(handle.readBuffer()!.pointee))

        advanceBuffer(1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
      }

      unlock()

      enableIRQ(0x1 | 0x8000)
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveReceiveInterrupt(buffer: UnsafeMutablePointer<UInt8>?, count: UInt16)
    -> HALStatus
  {
    let pData = buffer
    let Size = UInt32(count)

    if handle.read(.state) == 0x20 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 3)

      unlock()

      enableIRQ(0x2 | 0x8000)
      return .ok
    } else {
      return .busy
    }

  }
  public func writeMemoryInterrupt(
    address: UInt16, memoryAddress: UInt16, memoryAddressSize: UInt16,
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let MemAddress = UInt32(memoryAddress)
    let MemAddSize = UInt32(memoryAddressSize)
    let pData = buffer
    let Size = UInt32(count)

    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x40)
      handle.write(.errorCode, value: 0x0)

      handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0))
      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 2)
      handle.write(.deviceAddress, value: DevAddress)

      if MemAddSize == 0x1 {
        registers.write(.txdr, value: (MemAddress & 0xFF))

        handle.write(.memoryAddress, value: 0xFFFF_FFFF)
      } else {
        registers.write(.txdr, value: ((MemAddress & 0xFF00) >> 8))

        handle.write(.memoryAddress, value: (MemAddress & 0xFF))
      }
      transferConfiguration(
        UInt16(truncatingIfNeeded: DevAddress), UInt8(truncatingIfNeeded: ((MemAddSize) & 0xFF)),
        0x1000000, 0x8000_2000)

      unlock()

      enableIRQ(0x1)
      return .ok
    } else {
      return .busy
    }

  }
  public func readMemoryInterrupt(
    address: UInt16, memoryAddress: UInt16, memoryAddressSize: UInt16,
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let MemAddress = UInt32(memoryAddress)
    let MemAddSize = UInt32(memoryAddressSize)
    let pData = buffer
    let Size = UInt32(count)

    if handle.read(.state) == 0x20 {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }
      if getFlag(0x8000) == 1 {
        return .busy
      }

      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x40)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.transferISR, value: 2)
      handle.write(.deviceAddress, value: DevAddress)

      if MemAddSize == 0x1 {
        registers.write(.txdr, value: (MemAddress & 0xFF))

        handle.write(.memoryAddress, value: 0xFFFF_FFFF)
      } else {
        registers.write(.txdr, value: ((MemAddress & 0xFF00) >> 8))

        handle.write(.memoryAddress, value: (MemAddress & 0xFF))
      }
      transferConfiguration(
        UInt16(truncatingIfNeeded: DevAddress), UInt8(truncatingIfNeeded: ((MemAddSize) & 0xFF)),
        0x0, 0x8000_2000)

      unlock()

      enableIRQ(0x1)
      return .ok
    } else {
      return .busy
    }

  }
  public func masterSequentialTransmitInterrupt(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, options: UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)
    let XferOptions = options

    var xfermode: UInt32
    var xferrequest: UInt32 = 0x8000_2000
    if handle.read(.state) == 0x20 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x21)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: XferOptions)
      handle.write(.transferISR, value: 1)

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        xfermode = 0x1000000
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        xfermode = handle.read(.transferOptions)
      }

      if (handle.read(.previousState) == 0x11)
        && ((((XferOptions == 0xAA) || (XferOptions == 0xAA00)) ? UInt32(1) : UInt32(0)) == 0)
      {
        xferrequest = 0x0
      } else {
        convertOtherTransferOptions()

        if UInt32(handle.read(.transferCount)) <= 0xFF {
          xfermode = handle.read(.transferOptions)
        }
      }

      transferConfiguration(
        UInt16(truncatingIfNeeded: DevAddress),
        UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode,
        xferrequest)

      unlock()

      enableIRQ(0x1)
      return .ok
    } else {
      return .busy
    }

  }
  public func masterSequentialReceiveInterrupt(
    address: UInt16, buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, options: UInt32
  ) -> HALStatus {
    let DevAddress = UInt32(address)
    let pData = buffer
    let Size = UInt32(count)
    let XferOptions = options

    var xfermode: UInt32
    var xferrequest: UInt32 = 0x8000_2400
    if handle.read(.state) == 0x20 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x22)
      handle.write(.mode, value: 0x10)
      handle.write(.errorCode, value: 0x0)

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferOptions, value: XferOptions)
      handle.write(.transferISR, value: 1)

      if UInt32(handle.read(.transferCount)) > 0xFF {
        handle.write(.transferSize, value: UInt16(truncatingIfNeeded: 0xFF))
        xfermode = 0x1000000
      } else {
        handle.write(
          .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
        xfermode = handle.read(.transferOptions)
      }

      if (handle.read(.previousState) == 0x12)
        && ((((XferOptions == 0xAA) || (XferOptions == 0xAA00)) ? UInt32(1) : UInt32(0)) == 0)
      {
        xferrequest = 0x0
      } else {
        convertOtherTransferOptions()

        if UInt32(handle.read(.transferCount)) <= 0xFF {
          xfermode = handle.read(.transferOptions)
        }
      }

      transferConfiguration(
        UInt16(truncatingIfNeeded: DevAddress),
        UInt8(truncatingIfNeeded: ((UInt32(handle.read(.transferSize))) & 0xFF)), xfermode,
        xferrequest)

      unlock()

      enableIRQ(0x2)
      return .ok
    } else {
      return .busy
    }

  }
  public func slaveSequentialTransmitInterrupt(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, options: UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let XferOptions = options

    var tmp: UInt32
    if ((handle.read(.state)) & (0x28)) == (0x28) {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }

      disableIRQ(0x8000 | 0x1)

      guard lock() else { return .busy }

      if handle.read(.state) == 0x2A {
        disableIRQ(0x2)

        if (registers.read(.cr1) & 0x8000) == 0x8000 {
          registers.write(.cr1, value: registers.read(.cr1) & (~0x8000))
          if dma.isPresent(.receive) {
            dma.writeCallback(.receive, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.receive) != .ok {
              dma.invokeCallback(.receive, id: .abort)
            }
          }
        }
      }
      handle.write(.state, value: 0x29)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferOptions, value: XferOptions)
      handle.write(.transferISR, value: 3)
      tmp = getFlag(0x8)
      if (UInt32(direction()) == 0x1) && (tmp != 0) {

        clearFlag(0x8)
      }

      unlock()

      enableIRQ(0x1 | 0x8000)
      return .ok
    } else {
      return .error
    }

  }
  public func slaveSequentialReceiveInterrupt(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, options: UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)
    let XferOptions = options

    var tmp: UInt32
    if ((handle.read(.state)) & (0x28)) == (0x28) {
      if (pData == nil) || (Size == 0) {
        handle.write(.errorCode, value: 0x200)
        return .error
      }

      disableIRQ(0x8000 | 0x2)

      guard lock() else { return .busy }

      if handle.read(.state) == 0x29 {
        disableIRQ(0x1)
        if (registers.read(.cr1) & 0x4000) == 0x4000 {
          registers.write(.cr1, value: registers.read(.cr1) & (~0x4000))

          if dma.isPresent(.transmit) {
            dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.transmit) != .ok {
              dma.invokeCallback(.transmit, id: .abort)
            }
          }
        }
      }
      handle.write(.state, value: 0x2A)
      handle.write(.mode, value: 0x20)
      handle.write(.errorCode, value: 0x0)

      registers.write(.cr2, value: registers.read(.cr2) & (~0x8000))

      handle.writeBuffer(pData)
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(
        .transferSize, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount))))
      handle.write(.transferOptions, value: XferOptions)
      handle.write(.transferISR, value: 3)
      tmp = getFlag(0x8)
      if (UInt32(direction()) == 0x0) && (tmp != 0) {

        clearFlag(0x8)
      }

      unlock()

      enableIRQ(0x2 | 0x8000)
      return .ok
    } else {
      return .error
    }

  }
  public func enableListenInterrupt() -> HALStatus {

    if handle.read(.state) == 0x20 {
      handle.write(.state, value: 0x28)
      handle.write(.transferISR, value: 3)

      enableIRQ(0x8000)
      return .ok
    } else {
      return .busy
    }

  }
  public func disableListenInterrupt() -> HALStatus {

    var tmp: UInt32

    if handle.read(.state) == 0x28 {
      tmp = ((handle.read(.state))) & 0x3
      handle.write(.previousState, value: tmp | ((handle.read(.mode))))
      handle.write(.state, value: 0x20)
      handle.write(.mode, value: 0x0)
      handle.write(.transferISR, value: 0)

      disableIRQ(0x8000)
      return .ok
    } else {
      return .busy
    }

  }
  public func abortMasterInterrupt(address: UInt16) -> HALStatus {
    let DevAddress = UInt32(address)

    let tmp_mode: UInt32 = handle.read(.mode)
    if (tmp_mode == 0x10) || (tmp_mode == 0x40) {
      guard lock() else { return .busy }

      if handle.read(.state) == 0x21 {
        disableIRQ(0x1)
        handle.write(.previousState, value: 0x11)
      } else if handle.read(.state) == 0x22 {
        disableIRQ(0x2)
        handle.write(.previousState, value: 0x12)
      } else {
      }

      handle.write(.state, value: 0x60)

      transferConfiguration(
        UInt16(truncatingIfNeeded: DevAddress), UInt8(truncatingIfNeeded: 1), 0x2000000, 0x8000_4000
      )

      unlock()

      enableIRQ(0x20)
      return .ok
    } else {

      return .error
    }

  }
}
