// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SD {
  public func abort(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus {
    var error_code: UInt32 = 0
    var tickstart: UInt32 = 0

    if handle.read(.state) == 0x3 {
      sdmmc.disableInterrupts(0x100 | 0x2 | 0x8 | 0x10 | 0x20)
      sdmmc.disableCommandTransfer()

      handle.write(
        .errorCode, value: sdmmc.commandStopTransfer(getSystemCoreClock: getSystemCoreClock))
      error_code = handle.read(.errorCode)
      if (error_code != 0x0) && (error_code != 0x4) {
        return .error
      }
      tickstart = getTick()
      if (registers.read(.dctrl) & 0x2) == 0x0 {
        if handle.read(.errorCode) == 0x0 {
          while !sdmmc.getFlag(0x800 | 0x200000) {
            if (getTick() &- tickstart) >= 0xffff_ffff {
              handle.write(.errorCode, value: 0x8000_0000)
              handle.write(.state, value: 0x1)
              return .timeout
            }
          }
        }
        if handle.read(.errorCode) == 0x4 {
          while !sdmmc.getFlag(0x100) {
            if (getTick() &- tickstart) >= 0xffff_ffff {
              handle.write(.errorCode, value: 0x8000_0000)
              handle.write(.state, value: 0x1)
              return .timeout
            }
          }
        }
      } else if (registers.read(.dctrl) & 0x2) == 0x2 {
        while !sdmmc.getFlag(0x800 | 0x100) {
          if (getTick() &- tickstart) >= 0xffff_ffff {
            handle.write(.errorCode, value: 0x8000_0000)
            handle.write(.state, value: 0x1)
            return .timeout
          }
        }
      } else {
      }

      sdmmc.clearFlag(0x200000)
      sdmmc.clearFlag(0x1800_0f3a)

      registers.write(.idmactrl, value: 0x0)
      handle.write(.state, value: 0x1)

      handle.write(.transferContext, value: 0x0)
    }
    return .ok

  }
  public func abortInterrupt(getSystemCoreClock: () -> UInt32) -> HALStatus {
    var CardState: UInt32 = 0

    sdmmc.disableInterrupts(0x100 | 0x2 | 0x8 | 0x10 | 0x20)

    registers.write(.idmactrl, value: 0x0)

    sdmmc.clearFlag(0x1800_0f3a)
    CardState = getCardState(getSystemCoreClock: getSystemCoreClock)
    handle.write(.state, value: 0x1)
    if (CardState == 0x6) || (CardState == 0x5) {
      handle.write(
        .errorCode, value: sdmmc.commandStopTransfer(getSystemCoreClock: getSystemCoreClock))
    }
    if handle.read(.errorCode) != 0x0 {
      return .error
    } else {
      if useRegisteredCallbacks {
        callbacks.read(.abortComplete)!(callbacks.context)
      } else {
        defaults.abortComplete(callbacks.context)
      }
    }
    return .ok

  }
}
