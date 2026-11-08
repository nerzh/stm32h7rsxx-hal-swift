// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPI {
  public func transmitDMA(_ pData: UnsafeRawPointer?, _ Size: UInt16) -> HALStatus {
    let Size = UInt32(Size)

    var status: HALStatus

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

    handle.write(.state, value: 0x3)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: pData))
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))

    handle.writePointer(.receive, value: nil)
    handle.write(.transmitISR, value: 0)
    handle.write(.receiveISR, value: 0)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

    if handle.read(.direction) == 0x60000 {
      setOneLineTransmit()
    } else {
      setTwoLinesTransmit()
    }

    if ((handle.read(.dataSize) > 0xf) && (dma.readSourceDataWidth(.transmit) != 0x2)
      && ((!isLimitedInstance)))
      || ((handle.read(.dataSize) > 0x7) && (dma.readSourceDataWidth(.transmit) == 0x0))
    {
      unlock()
      return .error
    }

    if handle.read(.dataSize) <= 0x7 {
      if dma.readSourceDataWidth(.transmit) == 0x1 {
        handle.write(
          .transmitCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.transmitCount)) &+ ((1) & 0xFFFF)) >> 1))
      }
      if dma.readSourceDataWidth(.transmit) == 0x2 {
        handle.write(
          .transmitCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.transmitCount)) &+ ((3) & 0xFFFF)) >> 2))
      }
    } else if handle.read(.dataSize) <= 0xf {
      if dma.readSourceDataWidth(.transmit) == 0x2 {
        handle.write(
          .transmitCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.transmitCount)) &+ ((1) & 0xFFFF)) >> 1))
      }
    } else {
    }

    dma.writeCallback(.transmit, id: .halfTransfer, value: dma.callback(.transmitHalfComplete))

    dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.transmitComplete))

    dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

    dma.writeCallback(.transmit, id: .abort, value: nil)

    registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000)))
    if handle.read(.dataSize) <= 0x7 {
      handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))
    } else if handle.read(.dataSize) <= 0xf {
      handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size &* 2))
    } else {
      handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size &* 4))
    }

    if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
      if dma.read(.transmit, word: .queueAddress) != 0 {
        dma.writeMemory32(
          .transmit, at: dmaHead(.transmit) &+ (0x2 &* 4),
          value: UInt32(handle.read(.transmitCount)))

        dma.writeMemory32(
          .transmit, at: dmaHead(.transmit) &+ (0x3 &* 4),
          value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.transmit))))

        dma.writeMemory32(
          .transmit, at: dmaHead(.transmit) &+ (0x4 &* 4), value: registers.address(of: .txdr))
        status = dma.startLinkedListInterrupt(.transmit)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        .transmit,
        sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.transmit))),
        destinationAddress: registers.address(of: .txdr),
        sourceDataSize: UInt32(handle.read(.transmitCount)))
    }

    if status != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
      handle.write(.state, value: 0x1)

      unlock()
      return .error
    }

    if dma.read(.transmit, word: .mode) == 0x81 {
      registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (0))
    } else {
      registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))
    }

    registers.write(.cfg1, value: registers.read(.cfg1) | (0x8000))

    enableInterrupts((0x20 | 0x100 | 0x200))

    enable()
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }

    unlock()
    return .ok

  }
  public func receiveDMA(_ pData: UnsafeMutableRawPointer?, _ Size: UInt16) -> HALStatus {
    let Size = UInt32(Size)

    var status: HALStatus

    if isLimitedInstance {
    } else {
    }
    if handle.read(.state) != 0x1 {
      unlock()
      return .busy
    }
    if (pData == nil) || (Size == 0) {
      unlock()
      return .error
    }

    guard lock() else { return .busy }

    handle.write(.state, value: 0x4)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.receive, value: pData)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))

    handle.write(.receiveISR, value: 0)
    handle.write(.transmitISR, value: 0)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

    if handle.read(.direction) == 0x60000 {
      setOneLineReceive()
    } else {
      setTwoLinesReceive()
    }

    if ((handle.read(.dataSize) > 0xf) && (dma.readDestinationDataWidth(.receive) != 0x20000)
      && ((!isLimitedInstance)))
      || ((handle.read(.dataSize) > 0x7) && (dma.readDestinationDataWidth(.receive) == 0x0))
    {
      unlock()
      return .error
    }

    registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x4000)))

    if handle.read(.dataSize) <= 0x7 {
      if dma.readDestinationDataWidth(.receive) == 0x10000 {
        handle.write(
          .receiveCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.receiveCount)) &+ ((1) & 0xFFFF)) >> 1))
      }
      if dma.readDestinationDataWidth(.receive) == 0x20000 {
        handle.write(
          .receiveCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.receiveCount)) &+ ((3) & 0xFFFF)) >> 2))
      }
    } else if handle.read(.dataSize) <= 0xf {
      if dma.readDestinationDataWidth(.receive) == 0x20000 {
        handle.write(
          .receiveCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.receiveCount)) &+ ((1) & 0xFFFF)) >> 1))
      }
    } else {
    }

    dma.writeCallback(.receive, id: .halfTransfer, value: dma.callback(.receiveHalfComplete))

    dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.receiveComplete))

    dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

    dma.writeCallback(.receive, id: .abort, value: nil)
    if handle.read(.dataSize) <= 0x7 {
      handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))
    } else if handle.read(.dataSize) <= 0xf {
      handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size &* 2))
    } else {
      handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size &* 4))
    }

    if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
      if dma.read(.receive, word: .queueAddress) != 0 {
        dma.writeMemory32(
          .receive, at: dmaHead(.receive) &+ (0x2 &* 4), value: UInt32(handle.read(.receiveCount)))

        dma.writeMemory32(
          .receive, at: dmaHead(.receive) &+ (0x3 &* 4), value: registers.address(of: .rxdr))

        dma.writeMemory32(
          .receive, at: dmaHead(.receive) &+ (0x4 &* 4),
          value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.receive))))
        status = dma.startLinkedListInterrupt(.receive)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        .receive, sourceAddress: registers.address(of: .rxdr),
        destinationAddress: UInt32(
          truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.receive))),
        sourceDataSize: UInt32(handle.read(.receiveCount)))
    }

    if status != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
      handle.write(.state, value: 0x1)

      unlock()
      return .error
    }

    if dma.read(.receive, word: .mode) == 0x81 {
      registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (0))
    } else {
      registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))
    }

    registers.write(.cfg1, value: registers.read(.cfg1) | (0x4000))

    enableInterrupts((0x40 | 0x100 | 0x200))

    enable()
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }

    unlock()
    return .ok

  }
  public func transmitReceiveDMA(
    _ pTxData: UnsafeRawPointer?, _ pRxData: UnsafeMutableRawPointer?, _ Size: UInt16,
    getTick: () -> UInt32
  ) -> HALStatus {
    let Size = UInt32(Size)

    var status: HALStatus

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

    handle.write(.receiveISR, value: 0)
    handle.write(.transmitISR, value: 0)

    setTwoLines()

    registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000 | 0x4000)))

    if ((handle.read(.dataSize) > 0xf)
      && ((dma.readDestinationDataWidth(.receive) != 0x20000)
        || (dma.readSourceDataWidth(.transmit) != 0x2))
      && ((!isLimitedInstance)))
      || ((handle.read(.dataSize) > 0x7)
        && ((dma.readDestinationDataWidth(.receive) == 0x0)
          || (dma.readSourceDataWidth(.transmit) == 0x0)))
    {

      unlock()
      return .error
    }

    if handle.read(.dataSize) <= 0x7 {
      if dma.readSourceDataWidth(.transmit) == 0x1 {
        handle.write(
          .transmitCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.transmitCount)) &+ ((1) & 0xFFFF)) >> 1))
      }
      if dma.readSourceDataWidth(.transmit) == 0x2 {
        handle.write(
          .transmitCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.transmitCount)) &+ ((3) & 0xFFFF)) >> 2))
      }
      if dma.readDestinationDataWidth(.receive) == 0x10000 {
        handle.write(
          .receiveCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.receiveCount)) &+ ((1) & 0xFFFF)) >> 1))
      }
      if dma.readDestinationDataWidth(.receive) == 0x20000 {
        handle.write(
          .receiveCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.receiveCount)) &+ ((3) & 0xFFFF)) >> 2))
      }
    } else if handle.read(.dataSize) <= 0xf {
      if dma.readSourceDataWidth(.transmit) == 0x2 {
        handle.write(
          .transmitCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.transmitCount)) &+ ((1) & 0xFFFF)) >> 1))
      }
      if dma.readDestinationDataWidth(.receive) == 0x20000 {
        handle.write(
          .receiveCount,
          value: UInt16(
            truncatingIfNeeded: (UInt32(handle.read(.receiveCount)) &+ ((1) & 0xFFFF)) >> 1))
      }
    } else {
    }

    dma.writeCallback(
      .receive, id: .halfTransfer, value: dma.callback(.transmitReceiveHalfComplete))
    dma.writeCallback(
      .receive, id: .transferComplete, value: dma.callback(.transmitReceiveComplete))

    dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

    dma.writeCallback(.receive, id: .abort, value: nil)
    if handle.read(.dataSize) <= 0x7 {
      handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))
    } else if handle.read(.dataSize) <= 0xf {
      handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size &* 2))
    } else {
      handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size &* 4))
    }
    if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
      if dma.read(.receive, word: .queueAddress) != 0 {
        dma.writeMemory32(
          .receive, at: dmaHead(.receive) &+ (0x2 &* 4), value: UInt32(handle.read(.receiveCount)))

        dma.writeMemory32(
          .receive, at: dmaHead(.receive) &+ (0x3 &* 4), value: registers.address(of: .rxdr))

        dma.writeMemory32(
          .receive, at: dmaHead(.receive) &+ (0x4 &* 4),
          value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.receive))))
        status = dma.startLinkedListInterrupt(.receive)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        .receive, sourceAddress: registers.address(of: .rxdr),
        destinationAddress: UInt32(
          truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.receive))),
        sourceDataSize: UInt32(handle.read(.receiveCount)))
    }

    if status != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
      handle.write(.state, value: 0x1)

      unlock()
      return .error
    }

    registers.write(.cfg1, value: registers.read(.cfg1) | (0x4000))

    dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
    dma.writeCallback(.transmit, id: .transferComplete, value: nil)
    dma.writeCallback(.transmit, id: .abort, value: nil)

    dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))
    if handle.read(.dataSize) <= 0x7 {
      handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))
    } else if handle.read(.dataSize) <= 0xf {
      handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size &* 2))
    } else {
      handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size &* 4))
    }

    if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
      if dma.read(.transmit, word: .queueAddress) != 0 {
        dma.writeMemory32(
          .transmit, at: dmaHead(.transmit) &+ (0x2 &* 4),
          value: UInt32(handle.read(.transmitCount)))

        dma.writeMemory32(
          .transmit, at: dmaHead(.transmit) &+ (0x3 &* 4),
          value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.transmit))))

        dma.writeMemory32(
          .transmit, at: dmaHead(.transmit) &+ (0x4 &* 4), value: registers.address(of: .txdr))
        status = dma.startLinkedListInterrupt(.transmit)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        .transmit,
        sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.transmit))),
        destinationAddress: registers.address(of: .txdr),
        sourceDataSize: UInt32(handle.read(.transmitCount)))
    }

    if status != .ok {
      _ = dma.abort(.receive, getTick: getTick)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
      handle.write(.state, value: 0x1)

      unlock()
      return .error
    }
    if (dma.read(.receive, word: .mode) == 0x81) && (dma.read(.transmit, word: .mode) == 0x81) {
      registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (0))
    } else {
      registers.write(.cr2, value: (registers.read(.cr2) & ~(0xffff)) | (Size))
    }

    registers.write(.cfg1, value: registers.read(.cfg1) | (0x8000))

    enableInterrupts((0x40 | 0x20 | 0x100 | 0x200))

    enable()
    if handle.read(.mode) == 0x400000 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    }

    unlock()
    return .ok

  }
}
