// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPI {
  public func transmitInterrupt(_ pData: UnsafeRawPointer?, _ Size: UInt16) -> HALStatus {
    let Size = UInt32(Size)

    if isLimitedInstance {
    } else {
    }
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
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
    handle.write(.receiveISR, value: 0)

    if (handle.read(.dataSize) > 0xf) && ((!isLimitedInstance)) {
      handle.write(.transmitISR, value: SPITransferISR.transmit32.rawValue)
    } else if handle.read(.dataSize) > 0x7 {
      handle.write(.transmitISR, value: SPITransferISR.transmit16.rawValue)
    } else {
      handle.write(.transmitISR, value: SPITransferISR.transmit8.rawValue)
    }

    if handle.read(.direction) == 0x60000 {
      setOneLineTransmit()
    } else {
      setTwoLinesTransmit()
    }

    registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))

    enable()

    unlock()

    enableInterrupts((0x8 | 0x2 | 0x20 | 0x100 | 0x200))
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }
    return .ok

  }
  public func receiveInterrupt(_ pData: UnsafeMutableRawPointer?, _ Size: UInt16) -> HALStatus {
    let Size = UInt32(Size)

    if isLimitedInstance {
    } else {
    }
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
    handle.write(.transmitISR, value: 0)

    if (handle.read(.dataSize) > 0xf) && ((!isLimitedInstance)) {
      handle.write(.receiveISR, value: SPITransferISR.receive32.rawValue)
    } else if handle.read(.dataSize) > 0x7 {
      handle.write(.receiveISR, value: SPITransferISR.receive16.rawValue)
    } else {
      handle.write(.receiveISR, value: SPITransferISR.receive8.rawValue)
    }

    if handle.read(.direction) == 0x60000 {
      setOneLineReceive()
    } else {
      setTwoLinesReceive()
    }

    registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))

    enable()

    unlock()

    enableInterrupts((0x8 | 0x1 | 0x40 | 0x100 | 0x200))
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }
    return .ok

  }
  public func transmitReceiveInterrupt(
    _ pTxData: UnsafeRawPointer?, _ pRxData: UnsafeMutableRawPointer?, _ Size: UInt16
  ) -> HALStatus {
    let Size = UInt32(Size)

    var tmp_TxXferCount: UInt32

    if isLimitedInstance {
    } else {
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }
    if (pTxData == nil) || (pRxData == nil) || (Size == 0) {
      return .error
    }

    guard lock() else { return .busy }

    handle.write(.state, value: 0x5)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: pTxData))
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))
    handle.writePointer(.receive, value: pRxData)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))
    tmp_TxXferCount = UInt32(handle.read(.transmitCount))

    if (handle.read(.dataSize) > 0xf) && ((!isLimitedInstance)) {
      handle.write(.transmitISR, value: SPITransferISR.transmit32.rawValue)
      handle.write(.receiveISR, value: SPITransferISR.receive32.rawValue)
    } else if handle.read(.dataSize) > 0x7 {
      handle.write(.receiveISR, value: SPITransferISR.receive16.rawValue)
      handle.write(.transmitISR, value: SPITransferISR.transmit16.rawValue)
    } else {
      handle.write(.receiveISR, value: SPITransferISR.receive8.rawValue)
      handle.write(.transmitISR, value: SPITransferISR.transmit8.rawValue)
    }

    setTwoLines()

    registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))

    enable()

    while (isFlagSet(0x2)) && (tmp_TxXferCount != 0) {
      if handle.read(.dataSize) > 0xf {
        registers.write(
          .txdr,
          value: UInt32(
            truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self))))
        handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
        handle.write(
          .transmitCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
        tmp_TxXferCount = UInt32(handle.read(.transmitCount))
      } else if handle.read(.dataSize) > 0x7 {
        registers.write16(
          .txdr,
          value: UInt16(
            truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt16.self))))
        handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
        handle.write(
          .transmitCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
        tmp_TxXferCount = UInt32(handle.read(.transmitCount))
      } else {
        registers.write8(
          .txdr,
          value: UInt8(
            truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt8.self))))
        handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 1))
        handle.write(
          .transmitCount,
          value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
        tmp_TxXferCount = UInt32(handle.read(.transmitCount))
      }
    }

    unlock()

    enableInterrupts((0x8 | 0x4 | 0x20 | 0x40 | 0x100 | 0x200))
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }
    return .ok

  }
}
