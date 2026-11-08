// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPI {
  func dmaTransmitComplete(source: some SPIDMAEventSourceIO) {

    if handle.read(.state) != 0x7 {
      if dma.read(.transmit, word: .mode) == 0x81 {
        if useRegisteredCallbacks {
          callbacks.read(.transmitComplete)!(callbacks.context)
        } else {
          defaults.transmitComplete(callbacks.context)
        }
      } else {
        enableInterrupts(0x8)
      }
    }

  }
  func dmaReceiveComplete(source: some SPIDMAEventSourceIO) {

    if handle.read(.state) != 0x7 {
      if dma.read(.receive, word: .mode) == 0x81 {
        if useRegisteredCallbacks {
          callbacks.read(.receiveComplete)!(callbacks.context)
        } else {
          defaults.receiveComplete(callbacks.context)
        }
      } else {
        enableInterrupts(0x8)
      }
    }

  }
  func dmaTransmitReceiveComplete(source: some SPIDMAEventSourceIO) {

    if handle.read(.state) != 0x7 {
      if (dma.read(.receive, word: .mode) == 0x81) && (dma.read(.transmit, word: .mode) == 0x81) {
        if useRegisteredCallbacks {
          callbacks.read(.transmitReceiveComplete)!(callbacks.context)
        } else {
          defaults.transmitReceiveComplete(callbacks.context)
        }
      } else {
        enableInterrupts(0x8)
      }
    }

  }
  func dmaTransmitHalfComplete(source: some SPIDMAEventSourceIO) {

    if useRegisteredCallbacks {
      callbacks.read(.transmitHalfComplete)!(callbacks.context)
    } else {
      defaults.transmitHalfComplete(callbacks.context)
    }

  }
  func dmaReceiveHalfComplete(source: some SPIDMAEventSourceIO) {

    if useRegisteredCallbacks {
      callbacks.read(.receiveHalfComplete)!(callbacks.context)
    } else {
      defaults.receiveHalfComplete(callbacks.context)
    }

  }
  func dmaTransmitReceiveHalfComplete(source: some SPIDMAEventSourceIO) {

    if useRegisteredCallbacks {
      callbacks.read(.transmitReceiveHalfComplete)!(callbacks.context)
    } else {
      defaults.transmitReceiveHalfComplete(callbacks.context)
    }

  }
  func dmaError(source: some SPIDMAEventSourceIO) {

    if source.readErrorCode() != 0x0 {
      closeTransfer()
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        callbacks.read(.error)!(callbacks.context)
      } else {
        defaults.error(callbacks.context)
      }
    }

  }
  func dmaAbortOnError(source: some SPIDMAEventSourceIO) {

    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

    handle.write(.state, value: 0x1)
    if useRegisteredCallbacks {
      callbacks.read(.error)!(callbacks.context)
    } else {
      defaults.error(callbacks.context)
    }

  }
  func dmaTransmitAbort(source: some SPIDMAEventSourceIO) {

    dma.writeCallback(.transmit, id: .abort, value: nil)

    if dma.isPresent(.receive) {
      if dma.readCallback(.receive, id: .abort) != nil {
        return
      }
    }

    abortTransfer()

    handle.write(.state, value: 0x1)

    if useRegisteredCallbacks {
      callbacks.read(.abortComplete)!(callbacks.context)
    } else {
      defaults.abortComplete(callbacks.context)
    }

  }
  func dmaReceiveAbort(source: some SPIDMAEventSourceIO) {

    dma.writeCallback(.receive, id: .abort, value: nil)

    if dma.isPresent(.transmit) {
      if dma.readCallback(.transmit, id: .abort) != nil {
        return
      }
    }

    abortTransfer()

    handle.write(.state, value: 0x1)

    if useRegisteredCallbacks {
      callbacks.read(.abortComplete)!(callbacks.context)
    } else {
      defaults.abortComplete(callbacks.context)
    }

  }
  func dmaHead(_ direction: UARTDMADirection) -> UInt32 {
    dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress))
  }
  public func dmaCallback(_ kind: SPIDMACallbackKind, source: some SPIDMAEventSourceIO) {
    switch kind {
    case .transmitComplete: dmaTransmitComplete(source: source)
    case .receiveComplete: dmaReceiveComplete(source: source)
    case .transmitReceiveComplete: dmaTransmitReceiveComplete(source: source)
    case .transmitHalfComplete: dmaTransmitHalfComplete(source: source)
    case .receiveHalfComplete: dmaReceiveHalfComplete(source: source)
    case .transmitReceiveHalfComplete: dmaTransmitReceiveHalfComplete(source: source)
    case .error: dmaError(source: source)
    case .abortOnError: dmaAbortOnError(source: source)
    case .transmitAbort: dmaTransmitAbort(source: source)
    case .receiveAbort: dmaReceiveAbort(source: source)
    }
  }
}
