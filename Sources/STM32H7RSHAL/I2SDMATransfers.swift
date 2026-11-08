// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2S {
  public func transmitDMA(buffer: UnsafeMutableRawPointer?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    var errorcode: HALStatus
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }

    guard lock() else { return .busy }

    handle.write(.state, value: 0x3)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.transmit, value: pData)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))

    handle.writePointer(.receive, value: nil)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

    dma.writeCallback(.transmit, id: .halfTransfer, value: dma.callback(.transmitHalfComplete))

    dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.transmitComplete))

    dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))
    if (handle.read(.dataFormat) == 0x0) || (handle.read(.dataFormat) == 0x400) {
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
        errorcode = dma.startLinkedListInterrupt(.transmit)
      } else {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))

        unlock()
        handle.write(.state, value: 0x1)
        errorcode = .error
        return errorcode
      }
    } else {
      errorcode = dma.startInterrupt(
        .transmit,
        sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.transmit))),
        destinationAddress: registers.address(of: .txdr),
        sourceDataSize: UInt32(handle.read(.transmitCount)))
    }

    if errorcode != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      handle.write(.state, value: 0x1)
      unlock()
      errorcode = .error
      return errorcode
    }

    if ((registers.read(.cfg1) & 0x8000) == 0) {
      registers.write(.cfg1, value: registers.read(.cfg1) | (0x8000))
    }

    if ((registers.read(.cr1) & 0x1) == 0) {
      enable()
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    unlock()
    return errorcode

  }
  public func receiveDMA(buffer: UnsafeMutableRawPointer?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    var errorcode: HALStatus
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
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

    dma.writeCallback(.receive, id: .halfTransfer, value: dma.callback(.receiveHalfComplete))

    dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.receiveComplete))

    dma.writeCallback(.receive, id: .error, value: dma.callback(.error))
    if (handle.read(.dataFormat) == 0x0) || (handle.read(.dataFormat) == 0x400) {
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
        errorcode = dma.startLinkedListInterrupt(.receive)
      } else {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))

        unlock()
        handle.write(.state, value: 0x1)
        errorcode = .error
        return errorcode
      }
    } else {
      errorcode = dma.startInterrupt(
        .receive, sourceAddress: registers.address(of: .rxdr),
        destinationAddress: UInt32(
          truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.receive))),
        sourceDataSize: UInt32(handle.read(.receiveCount)))
    }

    if errorcode != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      handle.write(.state, value: 0x1)
      errorcode = .error
      unlock()
      return errorcode
    }

    if ((registers.read(.cfg1) & 0x4000) == 0) {
      registers.write(.cfg1, value: registers.read(.cfg1) | (0x4000))
    }

    if ((registers.read(.cr1) & 0x1) == 0) {
      enable()
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    unlock()
    return errorcode

  }
  public func transmitReceiveDMA(
    transmitBuffer: UnsafeMutableRawPointer?, receiveBuffer: UnsafeMutableRawPointer?, count: UInt16
  ) -> HALStatus {
    let pTxData = transmitBuffer
    let pRxData = receiveBuffer
    let Size = UInt32(count)

    var errorcode: HALStatus
    if (pTxData == nil) || (pRxData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }

    guard lock() else { return .busy }
    handle.writePointer(.transmit, value: pTxData)
    handle.writePointer(.receive, value: pRxData)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x5)

    registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000 | 0x4000)))

    dma.writeCallback(
      .receive, id: .halfTransfer, value: dma.callback(.transmitReceiveHalfComplete))

    dma.writeCallback(
      .receive, id: .transferComplete, value: dma.callback(.transmitReceiveComplete))

    dma.writeCallback(.receive, id: .error, value: dma.callback(.error))
    if (handle.read(.dataFormat) == 0x0) || (handle.read(.dataFormat) == 0x400) {
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
        errorcode = dma.startLinkedListInterrupt(.transmit)
      } else {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))

        unlock()
        handle.write(.state, value: 0x1)
        errorcode = .error
        return errorcode
      }
    } else {
      errorcode = dma.startInterrupt(
        .transmit,
        sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.transmit))),
        destinationAddress: registers.address(of: .txdr),
        sourceDataSize: UInt32(handle.read(.transmitCount)))
    }

    if errorcode != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      handle.write(.state, value: 0x1)
      unlock()
      errorcode = .error
      return errorcode
    }

    if ((registers.read(.cfg1) & 0x8000) == 0) {
      registers.write(.cfg1, value: registers.read(.cfg1) | (0x8000))
    }
    if (handle.read(.dataFormat) == 0x0) || (handle.read(.dataFormat) == 0x400) {
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
        errorcode = dma.startLinkedListInterrupt(.receive)
      } else {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))

        unlock()
        handle.write(.state, value: 0x1)
        errorcode = .error
        return errorcode
      }
    } else {
      errorcode = dma.startInterrupt(
        .receive, sourceAddress: registers.address(of: .rxdr),
        destinationAddress: UInt32(
          truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.receive))),
        sourceDataSize: UInt32(handle.read(.receiveCount)))
    }

    if errorcode != .ok {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      handle.write(.state, value: 0x1)
      errorcode = .error
      unlock()
      return errorcode
    }

    if ((registers.read(.cfg1) & 0x4000) == 0) {
      registers.write(.cfg1, value: registers.read(.cfg1) | (0x4000))
    }

    if ((registers.read(.cr1) & 0x1) == 0) {
      enable()
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    unlock()
    return errorcode

  }
  public func pauseDMA(getTick: () -> UInt32) -> HALStatus {

    guard lock() else { return .busy }
    var tickstart: UInt32

    tickstart = getTick()

    if ((handle.read(.mode) == 0x4) || (handle.read(.mode) == 0x6) || (handle.read(.mode) == 0xa)) {
      if ((registers.read(.cr1) & 0x200) == 0) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
        handle.write(.state, value: 0x1)
        unlock()
        return .error
      }
      registers.write(.cr1, value: registers.read(.cr1) | (0x400))
      while ((registers.read(.cr1) & 0x200) == 0x200) {
        if (((getTick() &- tickstart) >= 0xffff) && (0xffff != UInt32.max)) || (0xffff == 0) {
          handle.write(.state, value: 0x1)

          unlock()
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))
          handle.write(.state, value: 0x1)
          return .timeout
        }
      }

      disable()
      handle.write(.state, value: 0x1)

      unlock()
      return .ok
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
      handle.write(.state, value: 0x1)

      unlock()
      return .error
    }

  }
  public func resumeDMA() -> HALStatus {

    guard lock() else { return .busy }
    if handle.read(.state) != 0x1 {
      handle.write(.state, value: 0x1)
      unlock()
      return .error
    }

    handle.write(.state, value: 0x2)
    handle.write(.errorCode, value: 0x0)

    enable()

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))

    unlock()
    return .ok

  }
  public func stopDMA(getTick: () -> UInt32) -> HALStatus {

    var errorcode: HALStatus = .ok

    registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000)))
    registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x4000)))

    if dma.isPresent(.transmit) {
      if .ok != dma.abort(.transmit, getTick: getTick) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
        errorcode = .error
      }
    }

    if dma.isPresent(.receive) {
      if .ok != dma.abort(.receive, getTick: getTick) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
        errorcode = .error
      }
    }

    disable()
    handle.write(.state, value: 0x1)
    return errorcode

  }
}
