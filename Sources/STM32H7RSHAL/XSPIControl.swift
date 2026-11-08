// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func abort(getTick: () -> UInt32) -> HALStatus {

    var status: HALStatus = .ok
    let tickstart: UInt32 = getTick()

    if handle.read(.state) != 0x0 {
      if (registers.read(.cr) & 0x4) != 0 {
        registers.write(.cr, value: registers.read(.cr) & (~(0x4)))

        status = dma.abort(.transmit, getTick: getTick)
        if status != .ok {
          handle.write(.errorCode, value: 0x4)
        }

        status = dma.abort(.receive, getTick: getTick)
        if status != .ok {
          handle.write(.errorCode, value: 0x4)
        }
      }
      if getFlag(0x20) != 0 {
        registers.write(.cr, value: registers.read(.cr) | (0x2))

        status = waitOnFlag(0x2, 1, tickstart, handle.read(.timeout), getTick: getTick)
        if status == .ok {
          clearFlags(0x2)

          status = waitOnFlag(0x20, 0, tickstart, handle.read(.timeout), getTick: getTick)
          if status == .ok {
            registers.write(.cr, value: registers.read(.cr) & (~(0x3000_0000)))
            handle.write(.state, value: 0x2)
          }
        }
      } else {
        registers.write(.cr, value: registers.read(.cr) & (~(0x3000_0000)))
        handle.write(.state, value: 0x2)
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func abortInterrupt() -> HALStatus {

    var status: HALStatus = .ok

    if handle.read(.state) != 0x0 {
      disableInterrupts((0x100000 | 0x80000 | 0x40000 | 0x20000 | 0x10000))
      handle.write(.state, value: 0x100)

      if (registers.read(.cr) & 0x4) != 0 {
        registers.write(.cr, value: registers.read(.cr) & (~(0x4)))

        dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abortComplete))
        if dma.abortInterrupt(.transmit) != .ok {
          handle.write(.state, value: 0x2)

          if useRegisteredCallbacks {
            callbacks.read(.abortComplete)!(callbacks.context)
          } else {
            defaults.abortComplete(callbacks.context)
          }
        }

        dma.writeCallback(.receive, id: .abort, value: dma.callback(.abortComplete))
        if dma.abortInterrupt(.receive) != .ok {
          handle.write(.state, value: 0x2)

          if useRegisteredCallbacks {
            callbacks.read(.abortComplete)!(callbacks.context)
          } else {
            defaults.abortComplete(callbacks.context)
          }
        }
      } else {
        if getFlag(0x20) != 0 {
          clearFlags(0x2)

          enableInterrupts(0x20000)

          registers.write(.cr, value: registers.read(.cr) | (0x2))

          registers.write(.cr, value: registers.read(.cr) & (~(0x3000_0000)))
        } else {
          registers.write(.cr, value: registers.read(.cr) & (~(0x3000_0000)))
          handle.write(.state, value: 0x2)

          if useRegisteredCallbacks {
            callbacks.read(.abortComplete)!(callbacks.context)
          } else {
            defaults.abortComplete(callbacks.context)
          }
        }
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func setFifoThreshold(_ Threshold: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    if (handle.read(.state) & 0x8) == 0 {
      handle.write(.fifoThresholdByte, value: Threshold)

      registers.write(
        .cr,
        value: (registers.read(.cr) & ~(0x1f00)) | (((handle.read(.fifoThresholdByte) &- 1) << 0x8))
      )
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func getFifoThreshold() -> UInt32 {

    return (((registers.read(.cr) & 0x1f00) >> 0x8) &+ 1)

  }
  public func setMemoryType(_ Type: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    if (handle.read(.state) & 0x8) == 0 {
      handle.write(.memoryType, value: Type)

      registers.write(
        .dcr1, value: (registers.read(.dcr1) & ~(0x7000000)) | (handle.read(.memoryType)))
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func setDeviceSize(_ Size: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    if (handle.read(.state) & 0x8) == 0 {
      handle.write(.memorySize, value: Size)

      registers.write(
        .dcr1, value: (registers.read(.dcr1) & ~(0x1f0000)) | ((handle.read(.memorySize) << 0x10)))
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func setClockPrescaler(_ Prescaler: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    if (handle.read(.state) & 0x8) == 0 {
      handle.write(.clockPrescaler, value: Prescaler)

      registers.write(
        .dcr2, value: (registers.read(.dcr2) & ~(0xff)) | (((handle.read(.clockPrescaler)) << 0x0)))
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func setTimeout(_ Timeout: UInt32) -> HALStatus {

    handle.write(.timeout, value: Timeout)
    return .ok

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  func waitOnFlag(
    _ Flag: UInt32, _ State: UInt32, _ Tickstart: UInt32, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    while (getFlag(Flag)) != State {
      if Timeout != UInt32.max {
        if ((getTick() &- Tickstart) > Timeout) || (Timeout == 0) {
          handle.write(.state, value: 0x2)
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x1))
          return .timeout
        }
      }
    }
    return .ok

  }
  public func enable() { modify(.cr, set: 0x1) }
  public func disable() { modify(.cr, clear: 0x1) }
  public func enableInterrupts(_ interrupts: UInt32) { modify(.cr, set: interrupts) }
  public func disableInterrupts(_ interrupts: UInt32) { modify(.cr, clear: interrupts) }
  public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.sr) & flag != 0 ? 1 : 0 }
  public func getInterruptSource(_ interrupts: UInt32) -> UInt32 {
    registers.read(.cr) & interrupts == interrupts ? 1 : 0
  }
  public func clearFlags(_ flags: UInt32) { registers.write(.fcr, value: flags) }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
}
