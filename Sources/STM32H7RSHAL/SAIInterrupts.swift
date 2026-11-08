// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SAI {
  public func interruptHandler(getTick: () -> UInt32, systemCoreClock: () -> UInt32) {

    if handle.read(.state) != 0x0 {
      let itflags: UInt32 = registers.read(.sr)
      let itsources: UInt32 = registers.read(.imr)
      let cr1config: UInt32 = registers.read(.cr1)
      var tmperror: UInt32

      if ((itflags & 0x8) == 0x8) && ((itsources & 0x8) == 0x8) {
        dispatchTransferInterrupt(handle.read(.transferISR))
      } else if ((itflags & 0x1) == 0x1) && ((itsources & 0x1) == 0x1) {
        clearFlag(0x1)
        tmperror = ((handle.read(.state) == 0x22) ? 0x1 : 0x2)
        handle.write(.errorCode, value: handle.read(.errorCode) | (tmperror))
        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
      } else if ((itflags & 0x2) == 0x2) && ((itsources & 0x2) == 0x2) {
        clearFlag(0x2)
        if callbacks.readMute() != nil {
          callbacks.readMute()!()
        }
      } else if ((itflags & 0x20) == 0x20) && ((itsources & 0x20) == 0x20) {
        clearFlag(0x20)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))

        if (cr1config & 0x20000) == 0x20000 {
          if dma.isPresent(.transmit) {
            dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.transmit) != .ok {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              if useRegisteredCallbacks {
                callbacks.read(.error)!(callbacks.context)
              } else {
                defaults.error(callbacks.context)
              }
            }
          }
          if dma.isPresent(.receive) {
            dma.writeCallback(.receive, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.receive) != .ok {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              if useRegisteredCallbacks {
                callbacks.read(.error)!(callbacks.context)
              } else {
                defaults.error(callbacks.context)
              }
            }
          }
        } else {

          _ = abort(getTick: getTick, systemCoreClock: systemCoreClock)

          if useRegisteredCallbacks {
            callbacks.read(.error)!(callbacks.context)
          } else {
            defaults.error(callbacks.context)
          }
        }
      } else if ((itflags & 0x40) == 0x40) && ((itsources & 0x40) == 0x40) {
        clearFlag(0x40)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))

        if (cr1config & 0x20000) == 0x20000 {
          if dma.isPresent(.transmit) {
            dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.transmit) != .ok {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              if useRegisteredCallbacks {
                callbacks.read(.error)!(callbacks.context)
              } else {
                defaults.error(callbacks.context)
              }
            }
          }
          if dma.isPresent(.receive) {
            dma.writeCallback(.receive, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.receive) != .ok {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              if useRegisteredCallbacks {
                callbacks.read(.error)!(callbacks.context)
              } else {
                defaults.error(callbacks.context)
              }
            }
          }
        } else {

          _ = abort(getTick: getTick, systemCoreClock: systemCoreClock)

          if useRegisteredCallbacks {
            callbacks.read(.error)!(callbacks.context)
          } else {
            defaults.error(callbacks.context)
          }
        }
      } else if ((itflags & 0x4) == 0x4) && ((itsources & 0x4) == 0x4) {
        clearFlag(0x4)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))

        if (cr1config & 0x20000) == 0x20000 {
          if dma.isPresent(.transmit) {
            dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.transmit) != .ok {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              if useRegisteredCallbacks {
                callbacks.read(.error)!(callbacks.context)
              } else {
                defaults.error(callbacks.context)
              }
            }
          }
          if dma.isPresent(.receive) {
            dma.writeCallback(.receive, id: .abort, value: dma.callback(.abort))

            if dma.abortInterrupt(.receive) != .ok {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

              if useRegisteredCallbacks {
                callbacks.read(.error)!(callbacks.context)
              } else {
                defaults.error(callbacks.context)
              }
            }
          }
        } else {

          registers.write(.imr, value: 0)
          registers.write(.clrfr, value: 0xFFFF_FFFF)
          handle.write(.state, value: 0x1)

          handle.write(.transferCount, value: UInt16(truncatingIfNeeded: 0))

          if useRegisteredCallbacks {
            callbacks.read(.error)!(callbacks.context)
          } else {
            defaults.error(callbacks.context)
          }
        }
      } else if ((itflags & 0x10) == 0x10) && ((itsources & 0x10) == 0x10) {
        clearFlag(0x10)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
      } else {
      }
    }

  }
  func interruptFlags(_ mode: UInt32) -> UInt32 {

    var tmpIT: UInt32 = 0x1
    if mode == 1 {
      tmpIT |= 0x8
    }
    if (handle.read(.protocolMode) == 0x8)
      && ((handle.read(.audioMode) == 0x3) || (handle.read(.audioMode) == 0x1))
    {
      tmpIT |= 0x10
    }
    if (handle.read(.audioMode) == 0x3) || (handle.read(.audioMode) == 0x2) {
      tmpIT |= 0x20 | 0x40
    } else {
      tmpIT |= 0x4
    }
    return tmpIT

  }
  func transmit8Interrupt() {

    if UInt32(handle.read(.transferCount)) == 0 {

      disableInterrupts(interruptFlags(1))
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        callbacks.read(.transmitComplete)!(callbacks.context)
      } else {
        defaults.transmitComplete(callbacks.context)
      }
    } else {
      registers.write(.dr, value: UInt32(handle.readBuffer()!.pointee))
      handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
      handle.write(
        .transferCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
    }

  }
  func transmit16Interrupt() {

    if UInt32(handle.read(.transferCount)) == 0 {

      disableInterrupts(interruptFlags(1))
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        callbacks.read(.transmitComplete)!(callbacks.context)
      } else {
        defaults.transmitComplete(callbacks.context)
      }
    } else {
      var temp: UInt32
      temp = ((UInt32(handle.readBuffer()!.pointee)))
      handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
      temp |= (((UInt32(handle.readBuffer()!.pointee))) << 8)
      handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
      registers.write(.dr, value: temp)
      handle.write(
        .transferCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
    }

  }
  func transmit32Interrupt() {

    if UInt32(handle.read(.transferCount)) == 0 {

      disableInterrupts(interruptFlags(1))
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        callbacks.read(.transmitComplete)!(callbacks.context)
      } else {
        defaults.transmitComplete(callbacks.context)
      }
    } else {
      var temp: UInt32
      temp = ((UInt32(handle.readBuffer()!.pointee)))
      handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
      temp |= (((UInt32(handle.readBuffer()!.pointee))) << 8)
      handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
      temp |= (((UInt32(handle.readBuffer()!.pointee))) << 16)
      handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
      temp |= (((UInt32(handle.readBuffer()!.pointee))) << 24)
      handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
      registers.write(.dr, value: temp)
      handle.write(
        .transferCount,
        value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))
    }

  }
  func receive8Interrupt() {

    handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.dr)) & 0xFF))
    handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
    handle.write(
      .transferCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))

    if UInt32(handle.read(.transferCount)) == 0 {
      disableInterrupts(interruptFlags(1))

      clearFlag(0x1)
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        callbacks.read(.receiveComplete)!(callbacks.context)
      } else {
        defaults.receiveComplete(callbacks.context)
      }
    }

  }
  func receive16Interrupt() {

    var temp: UInt32

    temp = registers.read(.dr)
    handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((temp) & 0xFF))
    handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
    handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((temp >> 8)) & 0xFF))
    handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
    handle.write(
      .transferCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))

    if UInt32(handle.read(.transferCount)) == 0 {
      disableInterrupts(interruptFlags(1))

      clearFlag(0x1)
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        callbacks.read(.receiveComplete)!(callbacks.context)
      } else {
        defaults.receiveComplete(callbacks.context)
      }
    }

  }
  func receive32Interrupt() {

    var temp: UInt32

    temp = registers.read(.dr)
    handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((temp) & 0xFF))
    handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
    handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((temp >> 8)) & 0xFF))
    handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
    handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((temp >> 16)) & 0xFF))
    handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
    handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: (((temp >> 24)) & 0xFF))
    handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
    handle.write(
      .transferCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transferCount)) &- (1)))

    if UInt32(handle.read(.transferCount)) == 0 {
      disableInterrupts(interruptFlags(1))

      clearFlag(0x1)
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        callbacks.read(.receiveComplete)!(callbacks.context)
      } else {
        defaults.receiveComplete(callbacks.context)
      }
    }

  }
  func dispatchTransferInterrupt(_ selector: UInt32) {
    switch SAITransferISR(rawValue: selector)! {
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
