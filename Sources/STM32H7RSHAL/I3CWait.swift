// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  func waitOnFlag(
    _ flag: UInt32, _ flagstatus: UInt32, _ timeout: UInt32, _ tickstart: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {

    var status: HALStatus = .ok
    while (getFlag(flag) == flagstatus) && (status == .ok) {
      if timeout != UInt32.max {
        if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
          if getFlag(flag) == flagstatus {
            handle.write(.errorCode, value: 0x20000)
            status = .timeout
          }
        }
      }

      if getFlag(0x8) != 0 {
        _ = registers.read(.sr)
      }

      if getFlag(0x800) == 1 {
        llClearFlagERR()

        getErrorSources()
        status = .error
      }
    }
    return status

  }
  func waitOnDynamicAddress(_ timeout: UInt32, _ tickstart: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {

    var status: HALStatus = .ok
    var active_flags: UInt32 = registers.read(.evr)
    while ((active_flags & (0x200 | 0x10)) == 0) && (status == .ok) {
      if timeout != UInt32.max {
        if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
          if (active_flags & (0x200 | 0x10)) == 0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x20000))
            status = .timeout
          }
        }
      }

      if getFlag(0x8) != 0 {
        _ = registers.read(.sr)
      }

      if getFlag(0x800) == 1 {
        llClearFlagERR()

        getErrorSources()
        status = .error
      }

      active_flags = registers.read(.evr)
    }
    return status

  }
  func probeDevice(
    _ pDevice: I3CDeviceProbe, _ trials: UInt32, _ timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {

    var I3C_Trials: UInt32 = 0
    var exit_condition: UInt32
    var CR_tmp: UInt32
    var tickstart: UInt32
    var status: HALStatus = .ok
    var handle_state: UInt32
    var arbitration_previous_state: UInt32

    handle_state = handle.read(.state)

    if handle.read(.mode) != 0x1 {
      handle.write(.errorCode, value: 0x200000)
      status = .error
    } else if (handle_state != 0x10) && (handle_state != 0x30) {
      status = .busy
    } else {
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x20)

      arbitration_previous_state = llIsEnabledArbitrationHeader()

      llDisableArbitrationHeader()
      CR_tmp =
        (0x0 | (UInt32(truncatingIfNeeded: UInt32(pDevice.address)) << 0x11) | pDevice.messageType
          | 0x8000_0000)
      repeat {
        registers.write(.cr, value: CR_tmp)

        exit_condition = (registers.read(.evr) & (0x200 | 0x800))
        tickstart = getTick()
        while exit_condition == 0 {
          if getFlag(0x8) != 0 {
            _ = registers.read(.sr)
          }
          if timeout != UInt32.max {
            if ((getTick() &- tickstart) > timeout) || (timeout == 0) {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x20000))
              status = .timeout
              break
            }
          }
          exit_condition = (registers.read(.evr) & (0x200 | 0x800))
        }
        if status == .ok {
          if getFlag(0x200) == 1 {
            llClearFlagFC()

            break
          } else {
            llClearFlagERR()
          }
        }

        I3C_Trials = I3C_Trials &+ (1)
      } while (I3C_Trials < trials) && (status == .ok)

      if trials == I3C_Trials {
        handle.write(.errorCode, value: 0x100)
        status = .error
      }

      updateState()

      if arbitration_previous_state == 1 {
        llEnableArbitrationHeader()
      }
    }
    return status

  }
}
