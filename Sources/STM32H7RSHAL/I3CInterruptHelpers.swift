// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  func enableTransferInterrupts(_ InterruptRequest: UInt32) {

    var tmpisr: UInt32 = 0

    if (InterruptRequest & 0x1) != 0 {
      tmpisr |= ((InterruptRequest & (~0x1)) | 0x800)
    }

    if (InterruptRequest & 0x2) != 0 {
      tmpisr |= (0x200 | 0x10 | 0x800)
    }

    if (InterruptRequest & 0x4) != 0 {
      tmpisr |= (0x200 | 0x20 | 0x800)
    }

    if (InterruptRequest & 0x8) != 0 {
      tmpisr |= (0x200 | 0x800)

      tmpisr |= 0x8
    }

    if (InterruptRequest & 0x20) != 0 {
      tmpisr |= (0x1000000 | 0x800)
    }

    if (InterruptRequest & 0x10) != 0 {
      tmpisr |= (0x40000 | 0x800)
    }

    if (InterruptRequest & 0x40) != 0 {
      tmpisr |= (0x10000 | 0x800)
    }

    if (InterruptRequest & 0x80) != 0 {
      tmpisr |= (0x200 | 0x4 | 0x10 | 0x800)

      tmpisr |= 0x8
    }

    if (InterruptRequest & 0x100) != 0 {
      tmpisr |= (0x200 | 0x4 | 0x20 | 0x800)

      tmpisr |= 0x8
    }

    if (InterruptRequest & 0x400) != 0 {
      tmpisr |= (0x200 | 0x10 | 0x4 | 0x20 | 0x800)

      tmpisr |= 0x8
    }

    if (InterruptRequest & 0x1000) != 0 {
      tmpisr |= (0x200 | 0x4 | 0x10 | 0x800)

      tmpisr |= 0x8
    }

    registers.write(.ier, value: registers.read(.ier) | (tmpisr))

  }
  func disableTransferInterrupts(_ InterruptRequest: UInt32) {

    var tmpisr: UInt32 = 0

    if (InterruptRequest & 0x1) != 0 {
      tmpisr |= ((InterruptRequest & (~0x1)) | 0x800)
    }

    if (InterruptRequest & 0x2) != 0 {
      tmpisr |= (0x200 | 0x10 | 0x800)
    }

    if (InterruptRequest & 0x4) != 0 {
      tmpisr |= (0x200 | 0x20 | 0x800)
    }

    if (InterruptRequest & 0x8) != 0 {
      tmpisr |= (0x200 | 0x800)

      tmpisr |= 0x8
    }

    if (InterruptRequest & 0x20) != 0 {
      tmpisr |= (0x1000000 | 0x800)
    }

    if (InterruptRequest & 0x10) != 0 {
      tmpisr |= (0x40000 | 0x800)
    }

    if (InterruptRequest & 0x40) != 0 {
      tmpisr |= (0x10000 | 0x800)
    }

    if (InterruptRequest & 0x80) != 0 {
      tmpisr |= (0x200 | 0x4 | 0x10 | 0x800)

      tmpisr |= 0x8
    }

    if (InterruptRequest & 0x400) != 0 {
      tmpisr |= (0x200 | 0x10 | 0x4 | 0x20 | 0x800)

      tmpisr |= 0x8
    }

    if (InterruptRequest & 0x1000) != 0 {
      tmpisr |= (0x200 | 0x4 | 0x10 | 0x800)

      tmpisr |= 0x8
    }

    registers.write(.ier, value: registers.read(.ier) & (~(tmpisr)))

  }
  func treatError() {

    let tmpstate: UInt32 = handle.read(.state)
    var dmaabortongoing: UInt32 = 0

    if tmpstate == 0x20 {
      updateState()

      disableTransferInterrupts((0x40 | 0x20 | 0x10))
    } else {
      disableTransferInterrupts(0x400)

      handle.write(.transmitTransferCount, value: 0)

      handle.write(.receiveTransferCount, value: 0)

      handle.write(.controlTransferCount, value: 0)

      handle.write(.transmitTreatment, value: 0)

      handle.write(.receiveTreatment, value: 0)

      handle.writeTransfer(nil)
      handle.writeCCCDescriptors(nil)
      handle.writePrivateDescriptors(nil)

      llRequestTxFIFOFlush()

      llRequestRxFIFOFlush()

      if handle.read(.mode) == 0x1 {
        llRequestControlFIFOFlush()

        llRequestStatusFIFOFlush()
      }
      do {
        if dma.isPresent(.control) {
          llDisableDMAReqControl()

          if dma.readState(.control) != 1 {

            dmaabortongoing = 1

            if dma.abortInterrupt(.control) != .ok {
              dma.invokeCallback(.control, id: .abort)
            }
          }
        }

        if dma.isPresent(.receive) {
          llDisableDMAReqRX()

          if dma.readState(.receive) != 1 {
            dma.writeCallback(.receive, id: .abort, value: dma.callback(.abort))

            dmaabortongoing = 1

            if dma.abortInterrupt(.receive) != .ok {
              dma.invokeCallback(.receive, id: .abort)
            }
          }
        }

        if dma.isPresent(.transmit) {
          llDisableDMAReqTX()

          if dma.readState(.transmit) != 1 {
            dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abort))

            dmaabortongoing = 1

            if dma.abortInterrupt(.transmit) != .ok {
              dma.invokeCallback(.transmit, id: .abort)
            }
          }
        }
      }
    }

    if dmaabortongoing == 0 {
      invokeErrorCallback()
    }

  }
  func invokeErrorCallback() {

    if handle.read(.state) == 0x60 {
      updateState()

      if useRegisteredCallbacks {
        callbacks.read(.abortComplete)!(callbacks.context)
      } else {
        defaults.abortComplete(callbacks.context)
      }
    } else {
      updateState()

      if useRegisteredCallbacks {
        callbacks.read(.error)!(callbacks.context)
      } else {
        defaults.error(callbacks.context)
      }
    }

  }
}
