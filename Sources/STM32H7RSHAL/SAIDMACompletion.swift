// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SAI {
  func dmaTransmitComplete(source: some SAIDMAEventSourceIO) {

    if source.readMode() != 0x81 {
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: 0))

      registers.write(.cr1, value: registers.read(.cr1) & (((~0x20000))))

      disableInterrupts(interruptFlags(0))
      handle.write(.state, value: 0x1)
    }
    if useRegisteredCallbacks {
      callbacks.read(.transmitComplete)!(callbacks.context)
    } else {
      defaults.transmitComplete(callbacks.context)
    }

  }
  func dmaTransmitHalfComplete(source: some SAIDMAEventSourceIO) {

    if useRegisteredCallbacks {
      callbacks.read(.transmitHalfComplete)!(callbacks.context)
    } else {
      defaults.transmitHalfComplete(callbacks.context)
    }

  }
  func dmaReceiveComplete(source: some SAIDMAEventSourceIO) {

    if source.readMode() != 0x81 {
      registers.write(.cr1, value: registers.read(.cr1) & (((~0x20000))))
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: 0))

      disableInterrupts(interruptFlags(0))
      handle.write(.state, value: 0x1)
    }
    if useRegisteredCallbacks {
      callbacks.read(.receiveComplete)!(callbacks.context)
    } else {
      defaults.receiveComplete(callbacks.context)
    }

  }
  func dmaReceiveHalfComplete(source: some SAIDMAEventSourceIO) {

    if useRegisteredCallbacks {
      callbacks.read(.receiveHalfComplete)!(callbacks.context)
    } else {
      defaults.receiveHalfComplete(callbacks.context)
    }

  }
  func dmaError(source: some SAIDMAEventSourceIO, systemCoreClock: () -> UInt32) {

    handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))

    registers.write(.cr1, value: registers.read(.cr1) & (~0x20000))

    _ = disableBlock(systemCoreClock: systemCoreClock)

    handle.write(.state, value: 0x1)

    handle.write(.transferCount, value: UInt16(truncatingIfNeeded: 0))

    if useRegisteredCallbacks {
      callbacks.read(.error)!(callbacks.context)
    } else {
      defaults.error(callbacks.context)
    }

  }
  func dmaAbort(source: some SAIDMAEventSourceIO, systemCoreClock: () -> UInt32) {

    registers.write(.cr1, value: registers.read(.cr1) & (~0x20000))

    registers.write(.imr, value: 0)
    registers.write(.clrfr, value: 0xFFFF_FFFF)
    if handle.read(.errorCode) != 0x20 {

      _ = disableBlock(systemCoreClock: systemCoreClock)

      registers.write(.cr2, value: registers.read(.cr2) | (0x8))
    }
    handle.write(.state, value: 0x1)

    handle.write(.transferCount, value: UInt16(truncatingIfNeeded: 0))

    if useRegisteredCallbacks {
      callbacks.read(.error)!(callbacks.context)
    } else {
      defaults.error(callbacks.context)
    }

  }
  func dmaHead(_ direction: UARTDMADirection) -> UInt32 {
    dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress))
  }
  public func dmaCallback(
    _ kind: SAIDMACallbackKind, source: some SAIDMAEventSourceIO, systemCoreClock: () -> UInt32
  ) {
    switch kind {
    case .transmitComplete: dmaTransmitComplete(source: source)
    case .transmitHalfComplete: dmaTransmitHalfComplete(source: source)
    case .receiveComplete: dmaReceiveComplete(source: source)
    case .receiveHalfComplete: dmaReceiveHalfComplete(source: source)
    case .error: dmaError(source: source, systemCoreClock: systemCoreClock)
    case .abort: dmaAbort(source: source, systemCoreClock: systemCoreClock)
    }
  }
}
