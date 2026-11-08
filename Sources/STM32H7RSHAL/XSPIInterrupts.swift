// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func interruptHandler() {

    let flag: UInt32 = registers.read(.sr)
    let itsource: UInt32 = registers.read(.cr)
    let currentstate: UInt32 = handle.read(.state)

    if ((flag & 0x4) != 0) && ((itsource & 0x40000) != 0) {
      if currentstate == 0x18 {
        registers.write8(
          .dr, value: UInt8(truncatingIfNeeded: UInt32(handle.readBuffer()!.pointee)))
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
        handle.write(.transferCount, value: handle.read(.transferCount) &- (1))
      } else if currentstate == 0x28 {
        handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: UInt32(registers.read8(.dr)))
        handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
        handle.write(.transferCount, value: handle.read(.transferCount) &- (1))
      } else {
      }
      if handle.read(.transferCount) == 0 {

        disableInterrupts(0x40000)
      }

      if useRegisteredCallbacks {
        callbacks.read(.fifoThreshold)!(callbacks.context)
      } else {
        defaults.fifoThreshold(callbacks.context)
      }
    } else if ((flag & 0x2) != 0) && ((itsource & 0x20000) != 0) {
      if currentstate == 0x28 {
        if (handle.read(.transferCount) > 0) && ((flag & 0x7f00) != 0) {
          handle.readBuffer()!.pointee = UInt8(truncatingIfNeeded: UInt32(registers.read8(.dr)))
          handle.writeBuffer(handle.readBuffer()!.advanced(by: 1))
          handle.write(.transferCount, value: handle.read(.transferCount) &- (1))
        } else if handle.read(.transferCount) == 0 {
          registers.write(.fcr, value: 0x2)

          disableInterrupts(0x20000 | 0x40000 | 0x10000)
          handle.write(.state, value: 0x2)

          if useRegisteredCallbacks {
            callbacks.read(.receiveComplete)!(callbacks.context)
          } else {
            defaults.receiveComplete(callbacks.context)
          }
        } else {
        }
      } else {
        registers.write(.fcr, value: 0x2)

        disableInterrupts(0x20000 | 0x40000 | 0x10000)
        handle.write(.state, value: 0x2)
        if currentstate == 0x18 {
          if useRegisteredCallbacks {
            callbacks.read(.transmitComplete)!(callbacks.context)
          } else {
            defaults.transmitComplete(callbacks.context)
          }
        } else if currentstate == 0x8 {
          if useRegisteredCallbacks {
            callbacks.read(.commandComplete)!(callbacks.context)
          } else {
            defaults.commandComplete(callbacks.context)
          }
        } else if currentstate == 0x100 {
          if handle.read(.errorCode) == 0x0 {

            if useRegisteredCallbacks {
              callbacks.read(.abortComplete)!(callbacks.context)
            } else {
              defaults.abortComplete(callbacks.context)
            }
          } else {

            if useRegisteredCallbacks {
              callbacks.read(.error)!(callbacks.context)
            } else {
              defaults.error(callbacks.context)
            }
          }
        } else {
        }
      }
    } else if ((flag & 0x8) != 0) && ((itsource & 0x80000) != 0) {
      registers.write(.fcr, value: 0x8)

      if (registers.read(.cr) & 0x400000) != 0 {
        disableInterrupts(0x80000 | 0x10000)
        handle.write(.state, value: 0x2)
      }

      if useRegisteredCallbacks {
        callbacks.read(.statusMatch)!(callbacks.context)
      } else {
        defaults.statusMatch(callbacks.context)
      }
    } else if ((flag & 0x1) != 0) && ((itsource & 0x10000) != 0) {
      registers.write(.fcr, value: 0x1)

      disableInterrupts((0x100000 | 0x80000 | 0x40000 | 0x20000 | 0x10000))

      handle.write(.errorCode, value: 0x2)

      if (registers.read(.cr) & 0x4) != 0 {
        registers.write(.cr, value: registers.read(.cr) & (~(0x4)))

        dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abortComplete))
        if dma.abortInterrupt(.transmit) != .ok {
          handle.write(.state, value: 0x2)

          if useRegisteredCallbacks {
            callbacks.read(.error)!(callbacks.context)
          } else {
            defaults.error(callbacks.context)
          }
        }

        dma.writeCallback(.receive, id: .abort, value: dma.callback(.abortComplete))
        if dma.abortInterrupt(.receive) != .ok {
          handle.write(.state, value: 0x2)

          if useRegisteredCallbacks {
            callbacks.read(.error)!(callbacks.context)
          } else {
            defaults.error(callbacks.context)
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
    } else if ((flag & 0x10) != 0) && ((itsource & 0x100000) != 0) {
      registers.write(.fcr, value: 0x10)

      if useRegisteredCallbacks {
        callbacks.read(.timeout)!(callbacks.context)
      } else {
        defaults.timeout(callbacks.context)
      }
    } else {
    }

  }
}
