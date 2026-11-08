// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2S {
  public func interruptHandler() {

    let i2sier: UInt32 = registers.read(.ier)
    let i2ssr: UInt32 = registers.read(.sr)
    let trigger: UInt32 = i2sier & i2ssr
    if handle.read(.state) == 0x4 {
      if ((trigger & 0x1) == 0x1) && ((trigger & 0x40) == 0) {
        dispatchTransferInterrupt(handle.read(.receiveISR))
      }

      if ((trigger & 0x40) == 0x40) {
        disableInterrupts((0x1 | 0x160))

        clearOverrunFlag()

        handle.write(.state, value: 0x1)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
      }
    }
    if handle.read(.state) == 0x3 {
      if ((trigger & 0x2) == 0x2) && ((trigger & 0x20) == 0) {
        dispatchTransferInterrupt(handle.read(.transmitISR))
      }

      if ((trigger & 0x20) == 0x20) {
        disableInterrupts((0x2 | 0x160))

        clearUnderrunFlag()

        handle.write(.state, value: 0x1)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
      }
    }
    if handle.read(.state) == 0x5 {
      if ((trigger & 0x4) == 0x4) {
        dispatchTransferInterrupt(handle.read(.transmitISR))
        dispatchTransferInterrupt(handle.read(.receiveISR))
      }
      if ((trigger & 0x1) == 0x1) && ((trigger & 0x4) == 0) {
        dispatchTransferInterrupt(handle.read(.receiveISR))
      }
      if ((trigger & 0x2) == 0x2) && ((trigger & 0x4) == 0) {
        dispatchTransferInterrupt(handle.read(.transmitISR))
      }

      if ((trigger & 0x20) == 0x20) {
        disableInterrupts((0x2 | 0x1 | 0x160))

        clearUnderrunFlag()

        handle.write(.state, value: 0x1)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x4))
        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
      }

      if ((trigger & 0x40) == 0x40) {
        disableInterrupts((0x2 | 0x1 | 0x160))

        clearOverrunFlag()

        handle.write(.state, value: 0x1)

        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))

        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
      }
    }

  }
  func transmit16Interrupt() {

    registers.write16(
      .txdr,
      value: UInt16(
        truncatingIfNeeded: UInt32(handle.readPointer(.transmit)!.load(as: UInt16.self))))
    handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
    handle.write(
      .transmitCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
    if UInt32(handle.read(.transmitCount)) == 0 {
      disableInterrupts((0x2 | 0x160))
      if (handle.read(.mode) == 0x0) || (handle.read(.mode) == 0x4) {
        handle.write(.state, value: 0x1)

        if useRegisteredCallbacks {
          callbacks.read(.transmitComplete)!(callbacks.context)
        } else {
          defaults.transmitComplete(callbacks.context)
        }
      }
    }

  }
  func transmit32Interrupt() {

    registers.write(.txdr, value: UInt32(handle.readPointer(.transmit)!.load(as: UInt32.self)))
    handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 4))
    handle.write(
      .transmitCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.transmitCount)) &- (1)))
    if UInt32(handle.read(.transmitCount)) == 0 {
      disableInterrupts((0x2 | 0x160))
      if (handle.read(.mode) == 0x0) || (handle.read(.mode) == 0x4) {
        handle.write(.state, value: 0x1)

        if useRegisteredCallbacks {
          callbacks.read(.transmitComplete)!(callbacks.context)
        } else {
          defaults.transmitComplete(callbacks.context)
        }
      }
    }

  }
  func receive16Interrupt() {

    handle.readPointer(.receive)!.storeBytes(
      of: UInt16(truncatingIfNeeded: UInt32(registers.read16(.rxdr))), as: UInt16.self)
    handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
    handle.write(
      .receiveCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
    if UInt32(handle.read(.receiveCount)) == 0 {
      if ((handle.read(.mode) == 0xa) || (handle.read(.mode) == 0x8)) {
        disableInterrupts((0x2 | 0x1 | 0x4 | 0x160))
      } else {
        disableInterrupts((0x1 | 0x160))
      }
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        if ((handle.read(.mode) == 0xa) || (handle.read(.mode) == 0x8)) {
          callbacks.read(.transmitReceiveComplete)!(callbacks.context)
        } else {
          callbacks.read(.receiveComplete)!(callbacks.context)
        }
      } else {
        if ((handle.read(.mode) == 0xa) || (handle.read(.mode) == 0x8)) {
          defaults.transmitReceiveComplete(callbacks.context)
        } else {
          defaults.receiveComplete(callbacks.context)
        }
      }
    }

  }
  func receive32Interrupt() {

    handle.readPointer(.receive)!.storeBytes(
      of: UInt32(truncatingIfNeeded: registers.read(.rxdr)), as: UInt32.self)
    handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 4))
    handle.write(
      .receiveCount, value: UInt16(truncatingIfNeeded: UInt32(handle.read(.receiveCount)) &- (1)))
    if UInt32(handle.read(.receiveCount)) == 0 {
      if ((handle.read(.mode) == 0xa) || (handle.read(.mode) == 0x8)) {
        disableInterrupts((0x2 | 0x1 | 0x4 | 0x160))
      } else {
        disableInterrupts((0x1 | 0x160))
      }
      handle.write(.state, value: 0x1)
      if useRegisteredCallbacks {
        if ((handle.read(.mode) == 0xa) || (handle.read(.mode) == 0x8)) {
          callbacks.read(.transmitReceiveComplete)!(callbacks.context)
        } else {
          callbacks.read(.receiveComplete)!(callbacks.context)
        }
      } else {
        if ((handle.read(.mode) == 0xa) || (handle.read(.mode) == 0x8)) {
          defaults.transmitReceiveComplete(callbacks.context)
        } else {
          defaults.receiveComplete(callbacks.context)
        }
      }
    }

  }
  func dispatchTransferInterrupt(_ selector: UInt32) {
    switch I2STransferISR(rawValue: selector)! {
    case .none: preconditionFailure("Transfer ISR is not configured")
    case .transmit16: transmit16Interrupt()
    case .transmit32: transmit32Interrupt()
    case .receive16: receive16Interrupt()
    case .receive32: receive32Interrupt()
    }
  }
}
