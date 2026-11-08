// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPI {
  public func transmit(
    _ pData: UnsafeRawPointer?, _ Size: UInt16, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let Size = UInt32(Size)

    var tickstart: UInt32

    if isLimitedInstance {
    } else {
    }

    tickstart = getTick()
    if handle.read(.state) != 0x1 {
      return .busy
    }
    if (pData == nil) || (Size == 0) {
      return .error
    }

    guard lock() else { return .busy }

    handle.write(.state, value: 0x3)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: pData))
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))

    handle.writePointer(.receive, value: nil)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.transmitISR, value: 0)
    handle.write(.receiveISR, value: 0)

    if handle.read(.direction) == 0x60000 {
      setOneLineTransmit()
    } else {
      setTwoLinesTransmit()
    }

    registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))

    enable()
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }

    if (handle.read(.dataSize) > 0xf) && ((!isLimitedInstance)) {
      while UInt32(handle.read(.transmitCount)) > 0 {
        if isFlagSet(0x2) {
          registers.write(
            .txdr,
            value: UInt32(
              truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self))))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
          handle.write(
            .transmitCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
        } else {
          if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0) {
            closeTransfer()
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
            handle.write(.state, value: 0x1)

            unlock()
            return .timeout
          }
        }
      }
    } else if handle.read(.dataSize) > 0x7 {
      while UInt32(handle.read(.transmitCount)) > 0 {
        if isFlagSet(0x2) {
          if (UInt32(handle.read(.transmitCount)) > 1) && (handle.read(.fifoThreshold) > 0x0) {
            registers.write(
              .txdr,
              value: UInt32(
                truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self))))
            handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
            handle.write(
              .transmitCount,
              value: UInt16(
                truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (((2) & 0xFFFF))))
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
        } else {
          if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0) {
            closeTransfer()
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
            handle.write(.state, value: 0x1)

            unlock()
            return .timeout
          }
        }
      }
    } else {
      while UInt32(handle.read(.transmitCount)) > 0 {
        if isFlagSet(0x2) {
          if (UInt32(handle.read(.transmitCount)) > 3) && (handle.read(.fifoThreshold) > 0x40) {
            registers.write(
              .txdr,
              value: UInt32(
                truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self))))
            handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
            handle.write(
              .transmitCount,
              value: UInt16(
                truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (((4) & 0xFFFF))))
          } else if (UInt32(handle.read(.transmitCount)) > 1) && (handle.read(.fifoThreshold) > 0x0)
          {
            registers.write16(
              .txdr,
              value: UInt16(
                truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt16.self))))
            handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
            handle.write(
              .transmitCount,
              value: UInt16(
                truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (((2) & 0xFFFF))))
          } else {
            registers.write8(
              .txdr,
              value: UInt8(
                truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt8.self))))
            handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 1))
            handle.write(
              .transmitCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
          }
        } else {
          if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0) {
            closeTransfer()
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
            handle.write(.state, value: 0x1)

            unlock()
            return .timeout
          }
        }
      }
    }

    if waitOnFlag(0x8, 0, Timeout, tickstart, getTick: getTick) != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
    }

    closeTransfer()
    handle.write(.state, value: 0x1)

    unlock()
    if handle.read(.errorCode) != 0x0 {
      return .error
    } else {
      return .ok
    }

  }
  public func receive(
    _ pData: UnsafeMutableRawPointer?, _ Size: UInt16, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let Size = UInt32(Size)

    var tickstart: UInt32
    var temp_sr_reg: UInt32
    var init_max_data_in_fifo: UInt32
    init_max_data_in_fifo = ((((((handle.read(.fifoThreshold) >> 5)) & 0xFFFF) &+ 1))) & 0xFFFF

    if isLimitedInstance {
    } else {
    }

    tickstart = getTick()
    if handle.read(.state) != 0x1 {
      return .busy
    }
    if (pData == nil) || (Size == 0) {
      return .error
    }

    guard lock() else { return .busy }

    handle.write(.state, value: 0x4)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.receive, value: pData)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))

    handle.writePointer(.transmit, value: nil)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveISR, value: 0)
    handle.write(.transmitISR, value: 0)

    if handle.read(.direction) == 0x60000 {
      setOneLineReceive()
    } else {
      setTwoLinesReceive()
    }

    registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))

    enable()
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }

    if (handle.read(.dataSize) > 0xf) && ((!isLimitedInstance)) {
      while UInt32(handle.read(.receiveCount)) > 0 {
        temp_sr_reg = registers.read(.sr)

        if isFlagSet(0x1) {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt32(truncatingIfNeeded: UInt32(registers.read(.rxdr))), as: UInt32.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
          handle.write(
            .receiveCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
        } else if (UInt32(handle.read(.receiveCount)) < init_max_data_in_fifo)
          && ((temp_sr_reg & 0x8000) != 0)
        {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt32(truncatingIfNeeded: UInt32(registers.read(.rxdr))), as: UInt32.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
          handle.write(
            .receiveCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
        } else if ((temp_sr_reg & (0x800)) == (0x800)) {
          if ((registers.read(.cr1) & (0x200)) == (0x200)) {
            clearSuspendFlag()
          }
        } else {
          if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0) {
            closeTransfer()
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
            handle.write(.state, value: 0x1)

            unlock()
            return .timeout
          }
        }
      }
    } else if handle.read(.dataSize) > 0x7 {
      while UInt32(handle.read(.receiveCount)) > 0 {
        temp_sr_reg = registers.read(.sr)

        if isFlagSet(0x1) {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
          handle.write(
            .receiveCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
        } else if (UInt32(handle.read(.receiveCount)) < init_max_data_in_fifo)
          && ((temp_sr_reg & 0x8000) != 0)
        {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
          handle.readPointer(.receive)!.storeBytes(
            of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
          handle.write(
            .receiveCount,
            value: UInt16(
              truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (((2) & 0xFFFF))))
        } else if (UInt32(handle.read(.receiveCount)) == 1) && ((temp_sr_reg & 0x2000) != 0) {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
          handle.write(
            .receiveCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
        } else if ((temp_sr_reg & (0x800)) == (0x800)) {
          if ((registers.read(.cr1) & (0x200)) == (0x200)) {
            clearSuspendFlag()
          }
        } else {
          if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0) {
            closeTransfer()
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
            handle.write(.state, value: 0x1)

            unlock()
            return .timeout
          }
        }
      }
    } else {
      while UInt32(handle.read(.receiveCount)) > 0 {
        temp_sr_reg = registers.read(.sr)

        if isFlagSet(0x1) {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
          handle.write(
            .receiveCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
        } else if (UInt32(handle.read(.receiveCount)) < init_max_data_in_fifo)
          && ((temp_sr_reg & 0x8000) != 0)
        {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
          handle.readPointer(.receive)!.storeBytes(
            of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
          handle.readPointer(.receive)!.storeBytes(
            of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
          handle.readPointer(.receive)!.storeBytes(
            of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
          handle.write(
            .receiveCount,
            value: UInt16(
              truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (((4) & 0xFFFF))))
        } else if (UInt32(handle.read(.receiveCount)) < 4) && ((temp_sr_reg & 0x6000) != 0) {
          handle.readPointer(.receive)!.storeBytes(
            of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
          handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
          handle.write(
            .receiveCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
        } else if ((temp_sr_reg & (0x800)) == (0x800)) {
          if ((registers.read(.cr1) & (0x200)) == (0x200)) {
            clearSuspendFlag()
          }
        } else {
          if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0) {
            closeTransfer()
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
            handle.write(.state, value: 0x1)

            unlock()
            return .timeout
          }
        }
      }
    }
    if useCRC {
      if handle.read(.crcCalculation) == 0x400000 {
        if waitOnFlag(0x8, 0, Timeout, tickstart, getTick: getTick) != .ok {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        }
      }
    }

    closeTransfer()
    handle.write(.state, value: 0x1)

    unlock()
    if handle.read(.errorCode) != 0x0 {
      return .error
    } else {
      return .ok
    }

  }
  public func transmitReceive(
    _ pTxData: UnsafeRawPointer?, _ pRxData: UnsafeMutableRawPointer?, _ Size: UInt16,
    _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let Size = UInt32(Size)

    var tickstart: UInt32
    var fifo_length: UInt32
    var temp_sr_reg: UInt32
    var initial_TxXferCount: UInt32
    var initial_RxXferCount: UInt32
    var init_max_data_in_fifo: UInt32
    init_max_data_in_fifo = ((((((handle.read(.fifoThreshold) >> 5)) & 0xFFFF) &+ 1))) & 0xFFFF

    if isLimitedInstance {
    } else {
    }

    tickstart = getTick()
    initial_TxXferCount = Size
    initial_RxXferCount = Size
    if handle.read(.state) != 0x1 {
      return .busy
    }
    if (pTxData == nil) || (pRxData == nil) || (Size == 0) {
      return .error
    }

    guard lock() else { return .busy }

    handle.write(.state, value: 0x5)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.receive, value: pRxData)
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: pTxData))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))

    handle.write(.receiveISR, value: 0)
    handle.write(.transmitISR, value: 0)

    setTwoLines()

    if (!isLimitedInstance) {
      fifo_length = 0x10
    } else {
      fifo_length = 0x8
    }

    registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))
    enable()
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }

    if (handle.read(.dataSize) > 0xf) && ((!isLimitedInstance)) {
      fifo_length = (fifo_length / 4)
      while (initial_TxXferCount > 0) || (initial_RxXferCount > 0) {
        if (isFlagSet(0x2)) && (initial_TxXferCount > 0)
          && (initial_RxXferCount < (initial_TxXferCount &+ fifo_length))
        {
          registers.write(
            .txdr,
            value: UInt32(
              truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self))))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
          handle.write(
            .transmitCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
          initial_TxXferCount = UInt32(handle.read(.transmitCount))
        }

        temp_sr_reg = registers.read(.sr)
        if initial_RxXferCount > 0 {
          if isFlagSet(0x1) {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt32(truncatingIfNeeded: UInt32(registers.read(.rxdr))), as: UInt32.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
            handle.write(
              .receiveCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
            initial_RxXferCount = UInt32(handle.read(.receiveCount))
          } else if (initial_RxXferCount < init_max_data_in_fifo) && ((temp_sr_reg & 0x8000) != 0) {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt32(truncatingIfNeeded: UInt32(registers.read(.rxdr))), as: UInt32.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
            handle.write(
              .receiveCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
            initial_RxXferCount = UInt32(handle.read(.receiveCount))
          } else {
            if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0)
            {
              closeTransfer()
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
              handle.write(.state, value: 0x1)

              unlock()
              return .timeout
            }
          }
        }
      }
    } else if handle.read(.dataSize) > 0x7 {
      fifo_length = (fifo_length / 2)
      while (initial_TxXferCount > 0) || (initial_RxXferCount > 0) {
        if (isFlagSet(0x2)) && (initial_TxXferCount > 0)
          && (initial_RxXferCount < (initial_TxXferCount &+ fifo_length))
        {
          registers.write16(
            .txdr,
            value: UInt16(
              truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt16.self))))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
          handle.write(
            .transmitCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
          initial_TxXferCount = UInt32(handle.read(.transmitCount))
        }

        temp_sr_reg = registers.read(.sr)
        if initial_RxXferCount > 0 {
          if isFlagSet(0x1) {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
            handle.write(
              .receiveCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
            initial_RxXferCount = UInt32(handle.read(.receiveCount))
          } else if (initial_RxXferCount < init_max_data_in_fifo) && ((temp_sr_reg & 0x8000) != 0) {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
            handle.readPointer(.receive)!.storeBytes(
              of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
            handle.write(
              .receiveCount,
              value: UInt16(
                truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (((2) & 0xFFFF))))
            initial_RxXferCount = UInt32(handle.read(.receiveCount))
          } else if (initial_RxXferCount == 1) && ((temp_sr_reg & 0x2000) != 0) {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
            handle.write(
              .receiveCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
            initial_RxXferCount = UInt32(handle.read(.receiveCount))
          } else {
            if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0)
            {
              closeTransfer()
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
              handle.write(.state, value: 0x1)

              unlock()
              return .timeout
            }
          }
        }
      }
    } else {
      while (initial_TxXferCount > 0) || (initial_RxXferCount > 0) {
        if (isFlagSet(0x2)) && (initial_TxXferCount > 0)
          && (initial_RxXferCount < (initial_TxXferCount &+ fifo_length))
        {
          registers.write8(
            .txdr,
            value: UInt8(
              truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt8.self))))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 1))
          handle.write(
            .transmitCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
          initial_TxXferCount = UInt32(handle.read(.transmitCount))
        }

        temp_sr_reg = registers.read(.sr)
        if initial_RxXferCount > 0 {
          if isFlagSet(0x1) {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
            handle.write(
              .receiveCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
            initial_RxXferCount = UInt32(handle.read(.receiveCount))
          } else if (initial_RxXferCount < init_max_data_in_fifo) && ((temp_sr_reg & 0x8000) != 0) {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
            handle.readPointer(.receive)!.storeBytes(
              of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
            handle.readPointer(.receive)!.storeBytes(
              of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
            handle.readPointer(.receive)!.storeBytes(
              of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
            handle.write(
              .receiveCount,
              value: UInt16(
                truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (((4) & 0xFFFF))))
            initial_RxXferCount = UInt32(handle.read(.receiveCount))
          } else if (initial_RxXferCount < 4) && ((temp_sr_reg & 0x6000) != 0) {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
            handle.write(
              .receiveCount,
              value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
            initial_RxXferCount = UInt32(handle.read(.receiveCount))
          } else {
            if (((getTick() &- tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0)
            {
              closeTransfer()
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
              handle.write(.state, value: 0x1)

              unlock()
              return .timeout
            }
          }
        }
      }
    }

    if waitOnFlag(0x8, 0, Timeout, tickstart, getTick: getTick) != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
    }

    closeTransfer()
    handle.write(.state, value: 0x1)

    unlock()
    if handle.read(.errorCode) != 0x0 {
      return .error
    } else {
      return .ok
    }

  }
}
