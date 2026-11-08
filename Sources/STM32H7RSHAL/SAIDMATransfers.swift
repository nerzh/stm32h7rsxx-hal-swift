// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SAI {
  public func pauseDMA() -> HALStatus {

    guard lock() else { return .busy }

    registers.write(.cr1, value: registers.read(.cr1) & (~0x20000))

    unlock()
    return .ok

  }
  public func resumeDMA() -> HALStatus {

    guard lock() else { return .busy }

    registers.write(.cr1, value: registers.read(.cr1) | (0x20000))

    if (registers.read(.cr1) & 0x10000) == 0 {
      enable()
    }

    unlock()
    return .ok

  }
  public func stopDMA(getTick: () -> UInt32, systemCoreClock: () -> UInt32) -> HALStatus {

    var status: HALStatus = .ok

    guard lock() else { return .busy }

    if disableBlock(systemCoreClock: systemCoreClock) != .ok {
      status = .error
    }

    registers.write(.cr1, value: registers.read(.cr1) & (~0x20000))

    if (handle.read(.state) == 0x12) && (dma.isPresent(.transmit)) {
      if dma.abort(.transmit, getTick: getTick) != .ok {
        if dma.read(.transmit, word: .errorCode) != 0x20 {
          status = .error
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
        }
      }
    }

    if (handle.read(.state) == 0x22) && (dma.isPresent(.receive)) {
      if dma.abort(.receive, getTick: getTick) != .ok {
        if dma.read(.receive, word: .errorCode) != 0x20 {
          status = .error
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
        }
      }
    }

    registers.write(.cr2, value: registers.read(.cr2) | (0x8))

    handle.write(.state, value: 0x1)

    unlock()
    return status

  }
  public func abort(getTick: () -> UInt32, systemCoreClock: () -> UInt32) -> HALStatus {

    var status: HALStatus = .ok

    guard lock() else { return .busy }

    if disableBlock(systemCoreClock: systemCoreClock) != .ok {
      status = .error
    }

    if (registers.read(.cr1) & 0x20000) == 0x20000 {
      registers.write(.cr1, value: registers.read(.cr1) & (~0x20000))

      if (handle.read(.state) == 0x12) && (dma.isPresent(.transmit)) {
        if dma.abort(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) != 0x20 {
            status = .error
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
          }
        }
      }

      if (handle.read(.state) == 0x22) && (dma.isPresent(.receive)) {
        if dma.abort(.receive, getTick: getTick) != .ok {
          if dma.read(.receive, word: .errorCode) != 0x20 {
            status = .error
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
          }
        }
      }
    }

    registers.write(.imr, value: 0)
    registers.write(.clrfr, value: 0xFFFF_FFFF)

    registers.write(.cr2, value: registers.read(.cr2) | (0x8))

    handle.write(.state, value: 0x1)

    unlock()
    return status

  }
  public func transmitDMA(
    buffer: UnsafeMutablePointer<UInt8>?, count: UInt16, getTick: () -> UInt32
  ) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    var status: HALStatus
    let tickstart: UInt32 = getTick()
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      var dmaSrcSize: UInt32

      guard lock() else { return .busy }
      handle.writeBuffer(pData)
      handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x12)

      dma.writeCallback(.transmit, id: .halfTransfer, value: dma.callback(.transmitHalfComplete))

      dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.transmitComplete))

      dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))

      dma.writeCallback(.transmit, id: .abort, value: nil)

      if (handle.read(.dataSize) == 0x40) && (handle.read(.compandingMode) == 0x0) {
        dmaSrcSize = (Size)
      } else if handle.read(.dataSize) <= 0x80 {
        dmaSrcSize = 2 &* (Size)
      } else {
        dmaSrcSize = 4 &* (Size)
      }

      if (dma.read(.transmit, word: .mode) & 0x80) == 0x80 {
        if dma.read(.transmit, word: .queueAddress) != 0 {
          dma.writeMemory32(.transmit, at: dmaHead(.transmit) &+ (0x2 &* 4), value: dmaSrcSize)

          dma.writeMemory32(
            .transmit, at: dmaHead(.transmit) &+ (0x3 &* 4),
            value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())))

          dma.writeMemory32(
            .transmit, at: dmaHead(.transmit) &+ (0x4 &* 4), value: registers.address(of: .dr))
          status = dma.startLinkedListInterrupt(.transmit)
        } else {
          unlock()
          return .error
        }
      } else {
        status = dma.startInterrupt(
          .transmit,
          sourceAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())),
          destinationAddress: registers.address(of: .dr), sourceDataSize: dmaSrcSize)
      }
      if status != .ok {
        unlock()
        return .error
      }

      enableInterrupts(interruptFlags(0))

      registers.write(.cr1, value: registers.read(.cr1) | (0x20000))

      while (registers.read(.sr) & 0x70000) == 0x0 {
        if (getTick() &- tickstart) > 0x3e8 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))

          unlock()
          return .timeout
        }
      }

      if (registers.read(.cr1) & 0x10000) == 0 {
        enable()
      }

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func receiveDMA(buffer: UnsafeMutablePointer<UInt8>?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    var status: HALStatus
    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      var dmaSrcSize: UInt32

      guard lock() else { return .busy }
      handle.writeBuffer(pData)
      handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x22)

      dma.writeCallback(.receive, id: .halfTransfer, value: dma.callback(.receiveHalfComplete))

      dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.receiveComplete))

      dma.writeCallback(.receive, id: .error, value: dma.callback(.error))

      dma.writeCallback(.receive, id: .abort, value: nil)

      if (handle.read(.dataSize) == 0x40) && (handle.read(.compandingMode) == 0x0) {
        dmaSrcSize = (Size)
      } else if handle.read(.dataSize) <= 0x80 {
        dmaSrcSize = 2 &* (Size)
      } else {
        dmaSrcSize = 4 &* (Size)
      }

      if (dma.read(.receive, word: .mode) & 0x80) == 0x80 {
        if dma.read(.receive, word: .queueAddress) != 0 {
          dma.writeMemory32(.receive, at: dmaHead(.receive) &+ (0x2 &* 4), value: dmaSrcSize)

          dma.writeMemory32(
            .receive, at: dmaHead(.receive) &+ (0x3 &* 4), value: registers.address(of: .dr))

          dma.writeMemory32(
            .receive, at: dmaHead(.receive) &+ (0x4 &* 4),
            value: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())))
          status = dma.startLinkedListInterrupt(.receive)
        } else {
          unlock()
          return .error
        }
      } else {
        status = dma.startInterrupt(
          .receive, sourceAddress: registers.address(of: .dr),
          destinationAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readBuffer())),
          sourceDataSize: dmaSrcSize)
      }
      if status != .ok {
        unlock()
        return .error
      }

      enableInterrupts(interruptFlags(0))

      registers.write(.cr1, value: registers.read(.cr1) | (0x20000))

      if (registers.read(.cr1) & 0x10000) == 0 {
        enable()
      }

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
}
