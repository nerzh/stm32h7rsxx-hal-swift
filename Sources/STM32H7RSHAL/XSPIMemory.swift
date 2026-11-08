// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func autoPolling(
    _ pCfg: XSPIAutoPollingConfiguration, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var status: HALStatus
    let tickstart: UInt32 = getTick()
    let addr_reg: UInt32 = registers.read(.ar)
    let ir_reg: UInt32 = registers.read(.ir)

    if (handle.read(.state) == 0x4) && (pCfg.automaticStop == 0x400000) {
      status = waitOnFlag(0x20, 0, tickstart, Timeout, getTick: getTick)
      if status == .ok {
        registers.write(.psmar, value: pCfg.matchValue)
        registers.write(.psmkr, value: pCfg.matchMask)
        registers.write(.pir, value: pCfg.intervalTime)
        registers.write(
          .cr,
          value: (registers.read(.cr) & ~((0x800000 | 0x400000 | 0x3000_0000)))
            | ((pCfg.matchMode | pCfg.automaticStop | 0x2000_0000)))

        if handle.read(.memoryType) == 0x4000000 {
          registers.write(.ar, value: addr_reg)
        } else {
          if (registers.read(.ccr) & 0x700) != 0x0 {
            registers.write(.ar, value: addr_reg)
          } else {
            registers.write(.ir, value: ir_reg)
          }
        }

        status = waitOnFlag(0x8, 1, tickstart, Timeout, getTick: getTick)
        if status == .ok {
          clearFlags(0x8)
          handle.write(.state, value: 0x2)
        }
      } else {
        status = .busy
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func autoPollingInterrupt(_ pCfg: XSPIAutoPollingConfiguration, getTick: () -> UInt32)
    -> HALStatus
  {

    var status: HALStatus
    let tickstart: UInt32 = getTick()
    let addr_reg: UInt32 = registers.read(.ar)
    let ir_reg: UInt32 = registers.read(.ir)

    if handle.read(.state) == 0x4 {
      status = waitOnFlag(0x20, 0, tickstart, handle.read(.timeout), getTick: getTick)
      if status == .ok {
        registers.write(.psmar, value: pCfg.matchValue)
        registers.write(.psmkr, value: pCfg.matchMask)
        registers.write(.pir, value: pCfg.intervalTime)
        registers.write(
          .cr,
          value: (registers.read(.cr) & ~((0x800000 | 0x400000 | 0x3000_0000)))
            | ((pCfg.matchMode | pCfg.automaticStop | 0x2000_0000)))

        clearFlags(0x1 | 0x8)
        handle.write(.state, value: 0x48)

        enableInterrupts(0x80000 | 0x10000)

        if handle.read(.memoryType) == 0x4000000 {
          registers.write(.ar, value: addr_reg)
        } else {
          if (registers.read(.ccr) & 0x700) != 0x0 {
            registers.write(.ar, value: addr_reg)
          } else {
            registers.write(.ir, value: ir_reg)
          }
        }
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func memoryMapped(_ pCfg: XSPIMemoryMappedConfiguration, getTick: () -> UInt32)
    -> HALStatus
  {

    var status: HALStatus
    let tickstart: UInt32 = getTick()

    if handle.read(.state) == 0x4 {
      status = waitOnFlag(0x20, 0, tickstart, handle.read(.timeout), getTick: getTick)
      if status == .ok {
        handle.write(.state, value: 0x88)
        if pCfg.timeOutActivation == 0x8 {

          registers.write(.lptr, value: pCfg.timeoutPeriodClock)

          clearFlags(0x10)

          enableInterrupts(0x100000)
        }

        registers.write(
          .cr,
          value: (registers.read(.cr) & ~((0x8 | 0x3000_0000)))
            | ((pCfg.timeOutActivation | 0x3000_0000)))
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func isMemoryMapped() -> UInt32 {

    if handle.read(.state) == 0x0 {
      return (0)
    } else {
      return (((registers.read(.cr) & 0x3000_0000) == 0x3000_0000) ? 1 : 0)
    }

  }
}
