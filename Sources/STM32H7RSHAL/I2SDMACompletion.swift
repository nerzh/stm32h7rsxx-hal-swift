// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2S {
  func dmaTransmitComplete(source: some I2SDMAEventSourceIO) {

    if source.readConfigurationMode() == 0x0 {
      registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000)))
      handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
      handle.write(.state, value: 0x1)
    }
    if useRegisteredCallbacks {
      callbacks.read(.transmitComplete)!(callbacks.context)
    } else {
      defaults.transmitComplete(callbacks.context)
    }

  }
  func dmaTransmitHalfComplete(source: some I2SDMAEventSourceIO) {

    if useRegisteredCallbacks {
      callbacks.read(.transmitHalfComplete)!(callbacks.context)
    } else {
      defaults.transmitHalfComplete(callbacks.context)
    }

  }
  func dmaReceiveComplete(source: some I2SDMAEventSourceIO) {

    if source.readConfigurationMode() == 0x0 {
      registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x4000)))
      handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
      handle.write(.state, value: 0x1)
    }
    if useRegisteredCallbacks {
      callbacks.read(.receiveComplete)!(callbacks.context)
    } else {
      defaults.receiveComplete(callbacks.context)
    }

  }
  func dmaReceiveHalfComplete(source: some I2SDMAEventSourceIO) {

    if useRegisteredCallbacks {
      callbacks.read(.receiveHalfComplete)!(callbacks.context)
    } else {
      defaults.receiveHalfComplete(callbacks.context)
    }

  }
  func dmaTransmitReceiveComplete(source: some I2SDMAEventSourceIO) {

    if source.readConfigurationMode() == 0x0 {
      registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x8000)))
      handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

      registers.write(.cfg1, value: registers.read(.cfg1) & (~(0x4000)))
      handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

      handle.write(.state, value: 0x1)
    }

    if useRegisteredCallbacks {
      callbacks.read(.transmitReceiveComplete)!(callbacks.context)
    } else {
      defaults.transmitReceiveComplete(callbacks.context)
    }

  }
  func dmaTransmitReceiveHalfComplete(source: some I2SDMAEventSourceIO) {

    if useRegisteredCallbacks {
      callbacks.read(.transmitReceiveHalfComplete)!(callbacks.context)
    } else {
      defaults.transmitReceiveHalfComplete(callbacks.context)
    }

  }
  func dmaError(source: some I2SDMAEventSourceIO) {

    registers.write(.cfg1, value: registers.read(.cfg1) & (~((0x4000 | 0x8000))))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.state, value: 0x1)

    handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
    if useRegisteredCallbacks {
      callbacks.read(.error)!(callbacks.context)
    } else {
      defaults.error(callbacks.context)
    }

  }
  func dmaHead(_ direction: UARTDMADirection) -> UInt32 {
    dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress))
  }
  public func dmaCallback(_ kind: I2SDMACallbackKind, source: some I2SDMAEventSourceIO) {
    switch kind {
    case .transmitComplete: dmaTransmitComplete(source: source)
    case .transmitHalfComplete: dmaTransmitHalfComplete(source: source)
    case .receiveComplete: dmaReceiveComplete(source: source)
    case .receiveHalfComplete: dmaReceiveHalfComplete(source: source)
    case .transmitReceiveComplete: dmaTransmitReceiveComplete(source: source)
    case .transmitReceiveHalfComplete: dmaTransmitReceiveHalfComplete(source: source)
    case .error: dmaError(source: source)
    }
  }
}
