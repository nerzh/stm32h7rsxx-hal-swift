// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// XSPI operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension XSPI {
  public func command(_ pCmd: XSPIRegularCommand, _ Timeout: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {

    var status: HALStatus
    var state: UInt32
    let tickstart: UInt32 = getTick()

    if handle.read(.memoryMode) == 0x0 {
    }

    if pCmd.instructionMode != 0x0 {

    }

    if pCmd.addressMode != 0x0 {

    }

    if pCmd.alternateBytesMode != 0x0 {

    }

    if pCmd.dataMode != 0x0 {
      if pCmd.operationType == 0x0 {
      }

    }

    state = handle.read(.state)
    if ((state == 0x2) && (handle.read(.memoryType) != 0x4000000))
      || ((state == 0x14) && ((pCmd.operationType == 0x2) || (pCmd.operationType == 0x3)))
      || ((state == 0x24) && ((pCmd.operationType == 0x1) || (pCmd.operationType == 0x3)))
    {
      status = waitOnFlag(0x20, 0, tickstart, Timeout, getTick: getTick)
      if status == .ok {
        handle.write(.errorCode, value: 0x0)

        status = configureCommand(pCmd)
        if status == .ok {
          if pCmd.dataMode == 0x0 {
            status = waitOnFlag(0x20, 0, tickstart, Timeout, getTick: getTick)

            clearFlags(0x2)
          } else {
            if pCmd.operationType == 0x0 {
              handle.write(.state, value: 0x4)
            } else if pCmd.operationType == 0x1 {
              if handle.read(.state) == 0x24 {
                handle.write(.state, value: 0x4)
              } else {
                handle.write(.state, value: 0x14)
              }
            } else if pCmd.operationType == 0x2 {
              if handle.read(.state) == 0x14 {
                handle.write(.state, value: 0x4)
              } else {
                handle.write(.state, value: 0x24)
              }
            } else {
            }
          }
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
  public func commandInterrupt(_ pCmd: XSPIRegularCommand, getTick: () -> UInt32) -> HALStatus {

    var status: HALStatus
    let tickstart: UInt32 = getTick()

    if handle.read(.memoryMode) == 0x0 {
    }

    if pCmd.instructionMode != 0x0 {

    }

    if pCmd.addressMode != 0x0 {

    }

    if pCmd.alternateBytesMode != 0x0 {

    }

    if pCmd.dataMode != 0x0 {

    }

    if (handle.read(.state) == 0x2) && (pCmd.operationType == 0x0) && (pCmd.dataMode == 0x0)
      && (handle.read(.memoryType) != 0x4000000)
    {
      status = waitOnFlag(0x20, 0, tickstart, handle.read(.timeout), getTick: getTick)
      if status == .ok {
        handle.write(.errorCode, value: 0x0)

        clearFlags(0x1 | 0x2)

        status = configureCommand(pCmd)
        if status == .ok {
          handle.write(.state, value: 0x8)

          enableInterrupts(0x20000 | 0x10000)
        }
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func configureHyperbus(
    _ pCfg: XSPIHyperbusConfiguration, _ Timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var status: HALStatus
    var state: UInt32
    let tickstart: UInt32 = getTick()

    state = handle.read(.state)
    if (state == 0x1) || (state == 0x2) {
      status = waitOnFlag(0x20, 0, tickstart, Timeout, getTick: getTick)
      if status == .ok {
        registers.write(
          .hlcr,
          value: ((pCfg.rwRecoveryTimeCycle << 0x10) | (pCfg.accessTimeCycle << 0x8)
            | pCfg.writeZeroLatency | pCfg.latencyMode))

        handle.write(.state, value: 0x2)
      } else {
        status = .busy
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  public func hyperbusCommand(_ pCmd: XSPIHyperbusCommand, _ Timeout: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {

    var status: HALStatus
    let tickstart: UInt32 = getTick()

    if (handle.read(.state) == 0x2) && (handle.read(.memoryType) == 0x4000000) {
      status = waitOnFlag(0x20, 0, tickstart, Timeout, getTick: getTick)
      if status == .ok {
        registers.write(.cr, value: (registers.read(.cr) & ~(0x3000_0000)) | (0))

        registers.write(.dcr1, value: (registers.read(.dcr1) & ~(0x1000000)) | (pCmd.addressSpace))

        registers.write(
          .ccr,
          value: (pCmd.dqsMode | 0x8000000 | pCmd.dataMode | pCmd.addressWidth | 0x800 | 0x400))
        registers.write(
          .wccr,
          value: (pCmd.dqsMode | 0x8000000 | pCmd.dataMode | pCmd.addressWidth | 0x800 | 0x400))

        registers.write(.dlr, value: (pCmd.dataLength &- 1))

        registers.write(.ar, value: pCmd.address)

        handle.write(.state, value: 0x4)
      } else {
        status = .busy
      }
    } else {
      status = .error
      handle.write(.errorCode, value: 0x10)
    }
    return status

  }
  func configureCommand(_ pCmd: XSPIRegularCommand) -> HALStatus {

    var status: HALStatus = .ok
    var ccr_reg: XSPIRegister
    var tcr_reg: XSPIRegister
    var ir_reg: XSPIRegister
    var abr_reg: XSPIRegister

    registers.write(.cr, value: (registers.read(.cr) & ~(0x3000_0000)) | (0))
    if handle.read(.memoryMode) == 0x0 {
      registers.write(.cr, value: (registers.read(.cr) & ~(0xc000_0000)) | (pCmd.ioSelect))
    }
    if pCmd.operationType == 0x2 {
      ccr_reg = .wccr
      tcr_reg = .wtcr
      ir_reg = .wir
      abr_reg = .wabr
    } else if pCmd.operationType == 0x3 {
      ccr_reg = .wpccr
      tcr_reg = .wptcr
      ir_reg = .wpir
      abr_reg = .wpabr
    } else {
      ccr_reg = .ccr
      tcr_reg = .tcr
      ir_reg = .ir
      abr_reg = .abr
    }

    registers.write(ccr_reg, value: pCmd.dqsMode)
    if pCmd.alternateBytesMode != 0x0 {
      registers.write(abr_reg, value: pCmd.alternateBytes)

      registers.write(
        ccr_reg,
        value: ((registers.read(ccr_reg)) & ~((0x70000 | 0x80000 | 0x300000)))
          | ((pCmd.alternateBytesMode | pCmd.alternateBytesDTRMode | pCmd.alternateBytesWidth)))
    }

    registers.write(tcr_reg, value: ((registers.read(tcr_reg)) & ~(0x1f)) | (pCmd.dummyCycles))
    if pCmd.dataMode != 0x0 {
      if pCmd.operationType == 0x0 {
        registers.write(.dlr, value: (pCmd.dataLength &- 1))
      }
    }

    if pCmd.dataMode != 0x0 {
      if pCmd.dataDTRMode == 0x8000000 {
        registers.write(.tcr, value: registers.read(.tcr) & (~(0x4000_0000)))
      } else if handle.read(.sampleShifting) == 0x4000_0000 {
        registers.write(.tcr, value: registers.read(.tcr) | (0x4000_0000))
      } else {
      }
    }
    if pCmd.instructionMode != 0x0 {
      if pCmd.addressMode != 0x0 {
        if pCmd.dataMode != 0x0 {

          registers.write(
            ccr_reg,
            value: ((registers.read(ccr_reg))
              & ~((0x7 | 0x8 | 0x30 | 0x700 | 0x800 | 0x3000 | 0x7000000 | 0x8000000)))
              | ((pCmd.instructionMode | pCmd.instructionDTRMode | pCmd.instructionWidth
                | pCmd.addressMode | pCmd.addressDTRMode | pCmd.addressWidth | pCmd.dataMode
                | pCmd.dataDTRMode)))
        } else {

          registers.write(
            ccr_reg,
            value: ((registers.read(ccr_reg)) & ~((0x7 | 0x8 | 0x30 | 0x700 | 0x800 | 0x3000)))
              | ((pCmd.instructionMode | pCmd.instructionDTRMode | pCmd.instructionWidth
                | pCmd.addressMode | pCmd.addressDTRMode | pCmd.addressWidth)))
        }
        registers.write(ir_reg, value: pCmd.instruction)

        registers.write(.ar, value: pCmd.address)
        if pCmd.operationType == 0x0 {

        }
      } else {
        if pCmd.dataMode != 0x0 {

          registers.write(
            ccr_reg,
            value: ((registers.read(ccr_reg)) & ~((0x7 | 0x8 | 0x30 | 0x7000000 | 0x8000000)))
              | ((pCmd.instructionMode | pCmd.instructionDTRMode | pCmd.instructionWidth
                | pCmd.dataMode | pCmd.dataDTRMode)))
        } else {

          registers.write(
            ccr_reg,
            value: ((registers.read(ccr_reg)) & ~((0x7 | 0x8 | 0x30)))
              | ((pCmd.instructionMode | pCmd.instructionDTRMode | pCmd.instructionWidth)))
        }

        registers.write(ir_reg, value: pCmd.instruction)
      }
    } else {
      if pCmd.addressMode != 0x0 {
        if pCmd.dataMode != 0x0 {

          registers.write(
            ccr_reg,
            value: ((registers.read(ccr_reg)) & ~((0x700 | 0x800 | 0x3000 | 0x7000000 | 0x8000000)))
              | ((pCmd.addressMode | pCmd.addressDTRMode | pCmd.addressWidth | pCmd.dataMode
                | pCmd.dataDTRMode)))
        } else {

          registers.write(
            ccr_reg,
            value: ((registers.read(ccr_reg)) & ~((0x700 | 0x800 | 0x3000)))
              | ((pCmd.addressMode | pCmd.addressDTRMode | pCmd.addressWidth)))
        }

        registers.write(.ar, value: pCmd.address)
        if pCmd.operationType == 0x0 {

        }
      } else {
        status = .error
        handle.write(.errorCode, value: 0x8)
      }
    }
    if pCmd.dataMode != 0x0 {
      if pCmd.operationType == 0x0 {
        registers.write(.dlr, value: (pCmd.dataLength &- 1))

      }
    }
    return status

  }
}
