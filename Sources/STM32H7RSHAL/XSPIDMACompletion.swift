// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  func dmaComplete() {

    handle.write(.transferCount, value: 0)

    registers.write(.cr, value: registers.read(.cr) & (~(0x4)))

    enableInterrupts(0x20000)

  }
  func dmaHalfComplete() {

    handle.write(.transferCount, value: (handle.read(.transferCount) >> 1))
    if handle.read(.state) == 0x28 {
      if useRegisteredCallbacks {
        callbacks.read(.receiveHalfComplete)!(callbacks.context)
      } else {
        defaults.receiveHalfComplete(callbacks.context)
      }
    } else {
      if useRegisteredCallbacks {
        callbacks.read(.transmitHalfComplete)!(callbacks.context)
      } else {
        defaults.transmitHalfComplete(callbacks.context)
      }
    }

  }
  func dmaError() {

    handle.write(.transferCount, value: 0)
    handle.write(.errorCode, value: 0x4)

    registers.write(.cr, value: registers.read(.cr) & (~(0x4)))

    if abortInterrupt() != .ok {
      disableInterrupts(0x20000 | 0x40000 | 0x10000)
      handle.write(.state, value: 0x2)

      if useRegisteredCallbacks {
        callbacks.read(.error)!(callbacks.context)
      } else {
        defaults.error(callbacks.context)
      }
    }

  }
  func dmaAbortComplete() {

    handle.write(.transferCount, value: 0)

    if handle.read(.state) == 0x100 {
      if getFlag(0x20) != 0 {
        clearFlags(0x2)

        enableInterrupts(0x20000)

        registers.write(.cr, value: registers.read(.cr) | (0x2))
      } else {
        handle.write(.state, value: 0x2)

        if useRegisteredCallbacks {
          callbacks.read(.abortComplete)!(callbacks.context)
        } else {
          defaults.abortComplete(callbacks.context)
        }
      }
    } else {
      handle.write(.state, value: 0x2)

      if useRegisteredCallbacks {
        callbacks.read(.error)!(callbacks.context)
      } else {
        defaults.error(callbacks.context)
      }
    }

  }
  public func dmaCallback(_ kind: XSPIDMACallbackKind) {
    switch kind {
    case .complete: dmaComplete()
    case .halfComplete: dmaHalfComplete()
    case .error: dmaError()
    case .abortComplete: dmaAbortComplete()
    }
  }
}
