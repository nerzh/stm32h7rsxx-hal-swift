// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  func addressComplete(_ ITFlags: UInt32) {

    var transferdirection: UInt32
    var slaveaddrcode: UInt32
    var ownadd1code: UInt32
    var ownadd2code: UInt32

    _ = ITFlags

    if ((handle.read(.state)) & (0x28)) == (0x28) {
      transferdirection = UInt32(direction())
      slaveaddrcode = UInt32(addressMatch())
      ownadd1code = UInt32(ownAddress1())
      ownadd2code = UInt32(ownAddress2())

      if handle.read(.addressingMode) == 0x2 {
        if (slaveaddrcode & 0x6) == ((ownadd1code >> 0x7) & 0x6) {
          slaveaddrcode = ownadd1code
          handle.write(.addressEventCount, value: handle.read(.addressEventCount) &+ 1)
          if handle.read(.addressEventCount) == 2 {
            handle.write(.addressEventCount, value: 0)

            clearFlag(0x8)

            unlock()

            invokeAddress(
              direction: UInt8(truncatingIfNeeded: transferdirection),
              match: UInt16(truncatingIfNeeded: slaveaddrcode))
          }
        } else {
          slaveaddrcode = ownadd2code

          disableIRQ(0x8000)

          unlock()

          invokeAddress(
            direction: UInt8(truncatingIfNeeded: transferdirection),
            match: UInt16(truncatingIfNeeded: slaveaddrcode))
        }
      } else {
        disableIRQ(0x8000)

        unlock()

        invokeAddress(
          direction: UInt8(truncatingIfNeeded: transferdirection),
          match: UInt16(truncatingIfNeeded: slaveaddrcode))
      }
    } else {
      clearFlag(0x8)

      unlock()
    }

  }
  func masterSequenceComplete() {

    handle.write(.mode, value: 0x0)

    if handle.read(.state) == 0x21 {
      handle.write(.state, value: 0x20)
      handle.write(.previousState, value: 0x11)
      handle.write(.transferISR, value: 0)

      disableIRQ(0x1)

      unlock()

      invoke(.masterTransmitComplete)
    } else {
      handle.write(.state, value: 0x20)
      handle.write(.previousState, value: 0x12)
      handle.write(.transferISR, value: 0)

      disableIRQ(0x2)

      unlock()

      invoke(.masterReceiveComplete)
    }

  }
  func slaveSequenceComplete() {

    let tmpcr1value: UInt32 = registers.read(.cr1)

    handle.write(.mode, value: 0x0)

    if checkInterruptSource(tmpcr1value, 0x4000) != 0 {
      registers.write(.cr1, value: registers.read(.cr1) & (~0x4000))
    } else if checkInterruptSource(tmpcr1value, 0x8000) != 0 {
      registers.write(.cr1, value: registers.read(.cr1) & (~0x8000))
    } else {
    }
    if handle.read(.state) == 0x29 {
      handle.write(.state, value: 0x28)
      handle.write(.previousState, value: 0x21)

      disableIRQ(0x1)

      unlock()

      invoke(.slaveTransmitComplete)
    } else if handle.read(.state) == 0x2A {
      handle.write(.state, value: 0x28)
      handle.write(.previousState, value: 0x22)

      disableIRQ(0x2)

      unlock()

      invoke(.slaveReceiveComplete)
    } else {
    }

  }
  func masterComplete(_ ITFlags: UInt32) {

    var tmperror: UInt32
    let tmpITFlags: UInt32 = ITFlags
    var tmpreg: UInt32

    clearFlag(0x20)

    if handle.read(.state) == 0x21 {
      disableIRQ(0x1)
      handle.write(.previousState, value: 0x11)
    } else if handle.read(.state) == 0x22 {
      disableIRQ(0x2)
      handle.write(.previousState, value: 0x12)
    } else {
    }

    resetCR2()

    handle.write(.transferISR, value: 0)
    handle.write(.transferOptions, value: 0xFFFF_0000)
    if checkFlag(tmpITFlags, 0x10) != 0 {
      clearFlag(0x10)

      handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
    }

    if (handle.read(.state) == 0x60) && (checkFlag(tmpITFlags, 0x4) != 0) {
      tmpreg = ((registers.read(.rxdr)) & 0xFF)
      _ = tmpreg
    }

    flushTransmitData()

    tmperror = handle.read(.errorCode)

    if (handle.read(.state) == 0x60) || (tmperror != 0x0) {
      interruptError(handle.read(.errorCode))
    } else if handle.read(.state) == 0x21 {
      handle.write(.state, value: 0x20)
      handle.write(.previousState, value: 0x0)
      if handle.read(.mode) == 0x40 {
        handle.write(.mode, value: 0x0)

        unlock()

        invoke(.memoryTransmitComplete)
      } else {
        handle.write(.mode, value: 0x0)

        unlock()

        invoke(.masterTransmitComplete)
      }
    } else if handle.read(.state) == 0x22 {
      handle.write(.state, value: 0x20)
      handle.write(.previousState, value: 0x0)
      if handle.read(.mode) == 0x40 {
        handle.write(.mode, value: 0x0)

        unlock()

        invoke(.memoryReceiveComplete)
      } else {
        handle.write(.mode, value: 0x0)

        unlock()

        invoke(.masterReceiveComplete)
      }
    } else {
    }

  }
  func slaveComplete(_ ITFlags: UInt32) {

    let tmpcr1value: UInt32 = registers.read(.cr1)
    var tmpITFlags: UInt32 = ITFlags
    let tmpoptions: UInt32 = handle.read(.transferOptions)
    let tmpstate: UInt32 = handle.read(.state)

    clearFlag(0x20)

    if (tmpstate == 0x21) || (tmpstate == 0x29) {
      disableIRQ(0x8000 | 0x1)
      handle.write(.previousState, value: 0x21)
    } else if (tmpstate == 0x22) || (tmpstate == 0x2A) {
      disableIRQ(0x8000 | 0x2)
      handle.write(.previousState, value: 0x22)
    } else if tmpstate == 0x28 {
      disableIRQ(0x8000 | 0x1 | 0x2)
      handle.write(.previousState, value: 0x0)
    } else {
    }

    registers.write(.cr2, value: registers.read(.cr2) | (0x8000))

    resetCR2()

    flushTransmitData()

    if checkInterruptSource(tmpcr1value, 0x4000) != 0 {
      registers.write(.cr1, value: registers.read(.cr1) & (~0x4000))
      if dma.isPresent(.transmit) {
        handle.write(
          .transferCount,
          value: UInt16(
            truncatingIfNeeded: (((dma.getCounter(.transmit) &+ dma.getFIFOLevel(.transmit)))
              & 0xFFFF)))
      }
    } else if checkInterruptSource(tmpcr1value, 0x8000) != 0 {
      registers.write(.cr1, value: registers.read(.cr1) & (~0x8000))
      if dma.isPresent(.receive) {
        handle.write(
          .transferCount,
          value: UInt16(
            truncatingIfNeeded: (((dma.getCounter(.receive) &+ dma.getFIFOLevel(.receive))) & 0xFFFF)
          ))
      }
    } else {
    }

    if checkFlag(tmpITFlags, 0x4) != 0 {
      tmpITFlags &= ~0x4

      handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

      advanceBuffer(1)
      if UInt32(handle.read(.transferSize)) > 0 {
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)
      }
    }

    if UInt32(handle.read(.transferCount)) != 0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
    }
    if (checkFlag(tmpITFlags, 0x10) != 0) && (checkInterruptSource(tmpcr1value, 0x10) != 0) {

      if UInt32(handle.read(.transferCount)) == 0 {
        if (handle.read(.state) == 0x28) && (tmpoptions == 0x2000000) {
          listenComplete(tmpITFlags)
        } else if (handle.read(.state) == 0x29) && (tmpoptions != 0xFFFF_0000) {
          clearFlag(0x10)

          flushTransmitData()

          slaveSequenceComplete()
        } else {
          clearFlag(0x10)
        }
      } else {

        clearFlag(0x10)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
        if (tmpoptions == 0x0) || (tmpoptions == 0x1000000) {
          interruptError(handle.read(.errorCode))
        }
      }
    }
    handle.write(.mode, value: 0x0)
    handle.write(.transferISR, value: 0)
    if handle.read(.errorCode) != 0x0 {
      interruptError(handle.read(.errorCode))

      if handle.read(.state) == 0x28 {
        listenComplete(tmpITFlags)
      }
    } else if handle.read(.transferOptions) != 0xFFFF_0000 {
      slaveSequenceComplete()
      handle.write(.transferOptions, value: 0xFFFF_0000)
      handle.write(.state, value: 0x20)
      handle.write(.previousState, value: 0x0)

      unlock()

      invoke(.listenComplete)
    } else if handle.read(.state) == 0x22 {
      handle.write(.state, value: 0x20)
      handle.write(.previousState, value: 0x0)

      unlock()

      invoke(.slaveReceiveComplete)
    } else {
      handle.write(.state, value: 0x20)
      handle.write(.previousState, value: 0x0)

      unlock()

      invoke(.slaveTransmitComplete)
    }

  }
  func listenComplete(_ ITFlags: UInt32) {

    handle.write(.transferOptions, value: 0xFFFF_0000)
    handle.write(.previousState, value: 0x0)
    handle.write(.state, value: 0x20)
    handle.write(.mode, value: 0x0)
    handle.write(.transferISR, value: 0)

    if checkFlag(ITFlags, 0x4) != 0 {
      handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: ((registers.read(.rxdr)) & 0xFF))

      advanceBuffer(1)
      if UInt32(handle.read(.transferSize)) > 0 {
        handle.write(.transferSize, value: handle.read(.transferSize) &- 1)
        handle.write(.transferCount, value: handle.read(.transferCount) &- 1)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
      }
    }

    disableIRQ(0x8000 | 0x2 | 0x1)

    clearFlag(0x10)

    unlock()

    invoke(.listenComplete)

  }
  func interruptError(_ ErrorCode: UInt32) {

    let tmpstate: UInt32 = handle.read(.state)
    var tmppreviousstate: UInt32

    handle.write(.mode, value: 0x0)
    handle.write(.transferOptions, value: 0xFFFF_0000)
    handle.write(.transferCount, value: UInt16(truncatingIfNeeded: 0))

    handle.write(.errorCode, value: handle.read(.errorCode) | (ErrorCode))

    if (tmpstate == 0x28) || (tmpstate == 0x29) || (tmpstate == 0x2A) {
      disableIRQ(0x2 | 0x1)

      handle.write(.state, value: 0x28)
      handle.write(.transferISR, value: 3)
    } else {
      disableIRQ(0x8000 | 0x2 | 0x1)

      flushTransmitData()

      if handle.read(.state) != 0x60 {
        handle.write(.state, value: 0x20)

        if getFlag(0x20) == 1 {
          if getFlag(0x10) == 1 {
            clearFlag(0x10)
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
          }

          clearFlag(0x20)
        }
      }
      handle.write(.transferISR, value: 0)
    }

    tmppreviousstate = handle.read(.previousState)
    if (dma.isPresent(.transmit)) && ((tmppreviousstate == 0x11) || (tmppreviousstate == 0x21)) {
      if (registers.read(.cr1) & 0x4000) == 0x4000 {
        registers.write(.cr1, value: registers.read(.cr1) & (~0x4000))
      }
      if dma.read(.transmit, word: .state) != 0x1 {
        dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abort))

        unlock()

        if dma.abortInterrupt(.transmit) != .ok {
          dma.invokeCallback(.transmit, id: .abort)
        }
      } else {
        treatError()
      }
    } else if (dma.isPresent(.receive))
      && ((tmppreviousstate == 0x12) || (tmppreviousstate == 0x22))
    {
      if (registers.read(.cr1) & 0x8000) == 0x8000 {
        registers.write(.cr1, value: registers.read(.cr1) & (~0x8000))
      }
      if dma.read(.receive, word: .state) != 0x1 {
        dma.writeCallback(.receive, id: .abort, value: dma.callback(.abort))

        unlock()

        if dma.abortInterrupt(.receive) != .ok {
          dma.invokeCallback(.receive, id: .abort)
        }
      } else {
        treatError()
      }
    } else {
      treatError()
    }

  }
  func treatError() {

    if handle.read(.state) == 0x60 {
      handle.write(.state, value: 0x20)
      handle.write(.previousState, value: 0x0)

      unlock()

      invoke(.abortComplete)
    } else {
      handle.write(.previousState, value: 0x0)

      unlock()

      invoke(.error)
    }

  }
  func enableIRQ(_ InterruptRequest: UInt32) {

    var tmpisr: UInt32 = 0
    if (handle.read(.transferISR) != 4) && (handle.read(.transferISR) != 6)
      && (handle.read(.transferISR) != 5)
    {
      if (InterruptRequest & 0x8000) == 0x8000 {
        tmpisr |= 0x8 | 0x20 | 0x10 | 0x80
      }
      if (InterruptRequest & 0x1) == 0x1 {
        tmpisr |= 0x80 | 0x40 | 0x20 | 0x10 | 0x2
      }
      if (InterruptRequest & 0x2) == 0x2 {
        tmpisr |= 0x80 | 0x40 | 0x20 | 0x10 | 0x4
      }
      if InterruptRequest == 0x10 {
        tmpisr |= 0x80 | 0x10
      }
      if InterruptRequest == 0x20 {
        tmpisr |= 0x20
      }
    } else {
      if (InterruptRequest & 0x8000) == 0x8000 {
        tmpisr |= 0x8 | 0x20 | 0x10 | 0x80
      }
      if (InterruptRequest & 0x1) == 0x1 {
        tmpisr |= 0x80 | 0x40 | 0x20 | 0x10 | 0x2
      }
      if (InterruptRequest & 0x2) == 0x2 {
        tmpisr |= 0x80 | 0x40 | 0x20 | 0x10 | 0x4
      }
      if InterruptRequest == 0x10 {
        tmpisr |= 0x80 | 0x10
      }
      if InterruptRequest == 0x20 {
        tmpisr |= (0x20 | 0x40)
      }
      if InterruptRequest == 0x40 {
        tmpisr |= 0x40
      }
    }

    enableInterrupts(tmpisr)

  }
  func disableIRQ(_ InterruptRequest: UInt32) {

    var tmpisr: UInt32 = 0
    if (InterruptRequest & 0x1) == 0x1 {
      tmpisr |= 0x40 | 0x2
      if ((handle.read(.state)) & (0x28)) != (0x28) {
        tmpisr |= 0x20 | 0x10 | 0x80
      }
    }
    if (InterruptRequest & 0x2) == 0x2 {
      tmpisr |= 0x40 | 0x4
      if ((handle.read(.state)) & (0x28)) != (0x28) {
        tmpisr |= 0x20 | 0x10 | 0x80
      }
    }
    if (InterruptRequest & 0x8000) == 0x8000 {
      tmpisr |= 0x8 | 0x20 | 0x10 | 0x80
    }
    if InterruptRequest == 0x10 {
      tmpisr |= 0x80 | 0x10
    }
    if InterruptRequest == 0x20 {
      tmpisr |= 0x20
    }
    if InterruptRequest == 0x40 {
      tmpisr |= 0x40
    }

    disableInterrupts(tmpisr)

  }
  func convertOtherTransferOptions() {

    if handle.read(.transferOptions) == 0xAA {
      handle.write(.transferOptions, value: 0x0)
    } else if handle.read(.transferOptions) == 0xAA00 {
      handle.write(.transferOptions, value: 0x2000000)
    } else {
    }

  }
}
