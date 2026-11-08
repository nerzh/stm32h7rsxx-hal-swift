// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPI {
  public func abort(getTick: () -> UInt32, systemCoreClock: () -> UInt32) -> HALStatus {

    var errorcode: HALStatus
    var count: UInt32

    guard lock() else { return .busy }

    handle.write(.state, value: 0x7)

    errorcode = .ok
    count = 0x64 &* (systemCoreClock() / 24 / 1000)

    if ((registers.read(.cr1) & (0x200)) == (0x200)) {
      disableInterrupts(0x8)
      repeat {
        count &-= 1
        if count == 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          break
        }
      } while ((registers.read(.ier) & (0x8)) == (0x8))

      registers.write(.cr1, value: registers.read(.cr1) | (0x400))
      repeat {
        count &-= 1
        if count == 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          break
        }
      } while ((registers.read(.cr1) & (0x200)) == (0x200))

      clearSuspendFlag()
      repeat {
        count &-= 1
        if count == 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          break
        }
      } while isFlagSet(0x800)
    }

    if ((registers.read(.cfg1) & (0x8000)) == (0x8000)) {
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .abort, value: nil)

        if dma.abort(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == 0x10 {
            handle.write(.errorCode, value: 0x40)
          }
        }
      }
    }

    if ((registers.read(.cfg1) & (0x4000)) == (0x4000)) {
      if dma.isPresent(.receive) {
        dma.writeCallback(.receive, id: .abort, value: nil)

        if dma.abort(.receive, getTick: getTick) != .ok {
          if dma.read(.receive, word: .errorCode) == 0x10 {
            handle.write(.errorCode, value: 0x40)
          }
        }
      }
    }

    abortTransfer()

    if ((handle.read(.errorCode) & (0x40)) == (0x40)) {
      errorcode = .error
    } else {
      handle.write(.errorCode, value: 0x0)
    }

    handle.write(.state, value: 0x1)

    unlock()
    return errorcode

  }
  public func abortInterrupt(systemCoreClock: () -> UInt32) -> HALStatus {

    var errorcode: HALStatus
    var count: UInt32
    var dma_tx_abort_done: UInt32 = 1
    var dma_rx_abort_done: UInt32 = 1

    handle.write(.state, value: 0x7)

    errorcode = .ok
    count = 0x64 &* (systemCoreClock() / 24 / 1000)

    if ((registers.read(.cr1) & (0x200)) == (0x200)) {
      disableInterrupts(0x8)
      repeat {
        count &-= 1
        if count == 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          break
        }
      } while ((registers.read(.ier) & (0x8)) == (0x8))

      registers.write(.cr1, value: registers.read(.cr1) | (0x400))
      repeat {
        count &-= 1
        if count == 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          break
        }
      } while ((registers.read(.cr1) & (0x200)) == (0x200))

      clearSuspendFlag()
      repeat {
        count &-= 1
        if count == 0 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
          break
        }
      } while isFlagSet(0x800)
    }

    if dma.isPresent(.receive) {
      if ((registers.read(.cfg1) & (0x4000)) == (0x4000)) {
        dma.writeCallback(.receive, id: .abort, value: dma.callback(.receiveAbort))
      }
    }
    if dma.isPresent(.transmit) {
      if ((registers.read(.cfg1) & (0x8000)) == (0x8000)) {
        dma.writeCallback(.transmit, id: .abort, value: dma.callback(.transmitAbort))
        dma_tx_abort_done = 0

        if dma.abortInterrupt(.transmit) != .ok {
          if dma.read(.transmit, word: .errorCode) == 0x20 {
            dma_tx_abort_done = 1
            dma.writeCallback(.transmit, id: .abort, value: nil)
          }
        }
      } else {
        dma.writeCallback(.transmit, id: .abort, value: nil)
      }
    }
    if dma.isPresent(.receive) {
      if ((registers.read(.cfg1) & (0x4000)) == (0x4000)) {
        dma.writeCallback(.receive, id: .abort, value: dma.callback(.receiveAbort))
        dma_rx_abort_done = 0

        if dma.abortInterrupt(.receive) != .ok {
          if dma.read(.receive, word: .errorCode) == 0x20 {
            dma_rx_abort_done = 1
            dma.writeCallback(.receive, id: .abort, value: nil)
          }
        }
      } else {
        dma.writeCallback(.receive, id: .abort, value: nil)
      }
    }

    if (dma_tx_abort_done == 1) && (dma_rx_abort_done == 1) {
      abortTransfer()

      if ((handle.read(.errorCode) & (0x40)) == (0x40)) {
        errorcode = .error
      } else {
        handle.write(.errorCode, value: 0x0)
      }

      handle.write(.state, value: 0x1)

      if useRegisteredCallbacks {
        callbacks.read(.abortComplete)!(callbacks.context)
      } else {
        defaults.abortComplete(callbacks.context)
      }
    }
    return errorcode

  }
  public func pauseDMA() -> HALStatus {

    handle.write(.errorCode, value: handle.read(.errorCode) | (0x400))
    return .error

  }
  public func resumeDMA() -> HALStatus {

    handle.write(.errorCode, value: handle.read(.errorCode) | (0x400))
    return .error

  }
  public func stopDMA() -> HALStatus {

    handle.write(.errorCode, value: handle.read(.errorCode) | (0x400))
    return .error

  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
  func abortTransfer() {

    disable()

    disableInterrupts((0x8 | 0x2 | 0x1 | 0x4 | 0x20 | 0x40 | 0x100 | 0x200))

    clearEndOfTransferFlag()
    clearTransmitFilledFlag()

    registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000 | 0x4000)))

    clearOverrunFlag()
    clearUnderrunFlag()
    clearFrameErrorFlag()
    clearModeFaultFlag()
    clearSuspendFlag()
    if useCRC {
      clearCRCErrorFlag()
    }
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

  }
  func closeTransfer() {

    var itflag: UInt32 = registers.read(.sr)
    clearEndOfTransferFlag()
    clearTransmitFilledFlag()

    disable()

    disableInterrupts((0x8 | 0x2 | 0x1 | 0x4 | 0x20 | 0x40 | 0x100 | 0x200))

    registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000 | 0x4000)))

    if handle.read(.state) != 0x4 {
      if (itflag & 0x20) != 0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
        clearUnderrunFlag()
      }
    }

    if handle.read(.state) != 0x3 {
      if (itflag & 0x40) != 0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
        clearOverrunFlag()
      }
      if useCRC {
        if handle.read(.crcCalculation) == 0x400000 {
          if (itflag & 0x80) != 0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
            clearCRCErrorFlag()
          }
        }
      }
    }

    if (itflag & 0x200) != 0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))
      clearModeFaultFlag()
    }

    if (itflag & 0x100) != 0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      clearFrameErrorFlag()
    }
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

  }
  func waitOnFlag(
    _ Flag: UInt32, _ Status: UInt32, _ Timeout: UInt32, _ Tickstart: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    while (isFlagSet(Flag) ? 1 : 0) == Status {
      if (((getTick() &- Tickstart) >= Timeout) && (Timeout != UInt32.max)) || (Timeout == 0) {
        return .timeout
      }
    }
    return .ok

  }
  func packetSize() -> UInt32 {

    var fifo_threashold: UInt32 = (handle.read(.fifoThreshold) >> 0x5) &+ 1
    var data_size: UInt32 = (handle.read(.dataSize) >> 0x0) &+ 1

    data_size = (data_size &+ 7) / 8
    return data_size &* fifo_threashold

  }
}
