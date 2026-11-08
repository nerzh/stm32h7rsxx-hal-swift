// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPI {
  public func interruptHandler() {

    var itsource: UInt32 = registers.read(.ier)
    var itflag: UInt32 = registers.read(.sr)
    var trigger: UInt32 = itsource & itflag
    var cfg1: UInt32 = registers.read(.cfg1)
    var handled: UInt32 = 0
    var State: UInt32 = handle.read(.state)

    if ((itflag & (0x800)) == (0x800)) && ((itsource & (0x8)) == (0x8)) {
      clearSuspendFlag()

      if useRegisteredCallbacks {
        callbacks.read(.suspend)!(callbacks.context)
      } else {
        defaults.suspend(callbacks.context)
      }
      return
    }

    if ((trigger & (0x40)) == 0) && ((trigger & (0x20)) == 0) && ((trigger & (0x4)) == (0x4)) {
      dispatchTransferInterrupt(handle.read(.transmitISR))
      dispatchTransferInterrupt(handle.read(.receiveISR))
      handled = 1
    }

    if ((trigger & (0x40)) == 0) && ((trigger & (0x1)) == (0x1)) && ((trigger & (0x4)) == 0) {
      dispatchTransferInterrupt(handle.read(.receiveISR))
      handled = 1
    }

    if ((trigger & (0x20)) == 0) && ((trigger & (0x2)) == (0x2)) && ((trigger & (0x4)) == 0) {
      dispatchTransferInterrupt(handle.read(.transmitISR))
      handled = 1
    }
    if handled != 0 {
      return
    }

    if ((trigger & (0x8)) == (0x8)) {
      clearEndOfTransferFlag()
      clearTransmitFilledFlag()
      clearSuspendFlag()

      disableInterrupts(0x8)

      if ((registers.read(.cfg1) & (0x8000 | 0x4000)) == 0) {
        while UInt32(handle.read(.receiveCount)) != 0 {
          if handle.read(.dataSize) > 0xf {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt32(truncatingIfNeeded: UInt32(registers.read(.rxdr))), as: UInt32.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
          } else if handle.read(.dataSize) > 0x7 {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
          } else {
            handle.readPointer(.receive)!.storeBytes(
              of: UInt8(truncatingIfNeeded: UInt32(registers.read8(.rxdr))), as: UInt8.self)
            handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
          }
          handle.write(
            .receiveCount,
            value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
        }
      }

      closeTransfer()
      handle.write(.state, value: 0x1)
      if handle.read(.errorCode) != 0x0 {
        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
        return
      }
      if useRegisteredCallbacks {
        if State == 0x5 {
          callbacks.read(.transmitReceiveComplete)!(callbacks.context)
        } else if State == 0x4 {
          callbacks.read(.receiveComplete)!(callbacks.context)
        } else if State == 0x3 {
          callbacks.read(.transmitComplete)!(callbacks.context)
        }
      } else {
        if State == 0x5 {
          defaults.transmitReceiveComplete(callbacks.context)
        } else if State == 0x4 {
          defaults.receiveComplete(callbacks.context)
        } else if State == 0x3 {
          defaults.transmitComplete(callbacks.context)
        }
      }
      return
    }

    if (trigger & (0x200 | 0x40 | 0x100 | 0x20)) != 0 {
      if (trigger & 0x40) != 0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
        clearOverrunFlag()
      }

      if (trigger & 0x200) != 0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))
        clearModeFaultFlag()
      }

      if (trigger & 0x100) != 0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
        clearFrameErrorFlag()
      }

      if (trigger & 0x20) != 0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
        clearUnderrunFlag()
      }
      if handle.read(.errorCode) != 0x0 {
        disable()

        disableInterrupts((0x8 | 0x1 | 0x2 | 0x200 | 0x40 | 0x100 | 0x20))

        if ((cfg1 & (0x8000 | 0x4000)) == (0x8000 | 0x4000)) {
          registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000 | 0x4000)))

          if dma.isPresent(.receive) {
            dma.writeCallback(.receive, id: .abort, value: dma.callback(.abortOnError))
            if .ok != dma.abortInterrupt(.receive) {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
            }
          }
          if dma.isPresent(.transmit) {
            dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abortOnError))
            if .ok != dma.abortInterrupt(.transmit) {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
            }
          }
        } else {
          handle.write(.state, value: 0x1)

          if useRegisteredCallbacks {
            callbacks.read(.error)!(callbacks.context)
          } else {
            defaults.error(callbacks.context)
          }
        }
      }
      return
    }

  }
  func receive8Interrupt() {

    handle.readPointer(.receive)!.storeBytes(
      of: UInt8(truncatingIfNeeded: (UInt32(registers.read8(.rxdr)))), as: UInt8.self)
    handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
    handle.write(
      .receiveCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))

    if UInt32(handle.read(.receiveCount)) == 0 {
      disableInterrupts(0x1)
    }

  }
  func receive16Interrupt() {

    handle.readPointer(.receive)!.storeBytes(
      of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
    handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
    handle.write(
      .receiveCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))

    if UInt32(handle.read(.receiveCount)) == 0 {
      disableInterrupts(0x1)
    }

  }
  func receive32Interrupt() {

    handle.readPointer(.receive)!.storeBytes(
      of: UInt32(truncatingIfNeeded: (UInt32(registers.read(.rxdr)))), as: UInt32.self)
    handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
    handle.write(
      .receiveCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))

    if UInt32(handle.read(.receiveCount)) == 0 {
      disableInterrupts(0x1)
    }

  }
  func transmit8Interrupt() {

    if UInt32(handle.read(.transmitCount)) != 0 {
      registers.write8(
        .txdr,
        value: UInt8(
          truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt8.self))))
      handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 1))
      handle.write(
        .transmitCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
    } else {

      disableInterrupts(0x2)
    }

  }
  func transmit16Interrupt() {

    if UInt32(handle.read(.transmitCount)) != 0 {
      registers.write16(
        .txdr,
        value: UInt16(
          truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt16.self))))
      handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
      handle.write(
        .transmitCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
    } else {

      disableInterrupts(0x2)
    }

  }
  func transmit32Interrupt() {

    if UInt32(handle.read(.transmitCount)) != 0 {
      registers.write(
        .txdr,
        value: UInt32(
          truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self))))
      handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
      handle.write(
        .transmitCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
    } else {

      disableInterrupts(0x2)
    }

  }
  func dispatchTransferInterrupt(_ selector: UInt32) {
    switch SPITransferISR(rawValue: selector)! {
    case .none: preconditionFailure("Transfer ISR is not configured")
    case .transmit8: transmit8Interrupt()
    case .transmit16: transmit16Interrupt()
    case .transmit32: transmit32Interrupt()
    case .receive8: receive8Interrupt()
    case .receive16: receive16Interrupt()
    case .receive32: receive32Interrupt()
    }
  }
}
