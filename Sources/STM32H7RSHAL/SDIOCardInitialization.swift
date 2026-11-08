// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDIO {
  func initializeCard(getSystemCoreClock: () -> UInt32, delay: (UInt32) -> Void) -> HALStatus {
    var errorstate: UInt32 = 0
    var timeout: UInt32 = 0
    var sdio_rca: UInt16 = 0
    var Resp4: UInt32 = 0
    var nbr_of_func: UInt32 = 0

    timeout = 0
    sdio_rca = UInt16(truncatingIfNeeded: 1)

    errorstate = sdmmc.commandGoIdle(getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return .error
    }

    if sdmmc.getPowerState() == 0 {
      return .error
    }

    errorstate = sdmmc.commandSendOperationCondition(
      0, &Resp4, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return .error
    }
    nbr_of_func = ((Resp4 & 0x7000_0000) >> 28)

    if nbr_of_func > 0 {
      if sdmmc.commandSendOperationCondition(
        (0x100000 | 0x1000000), &Resp4, getSystemCoreClock: getSystemCoreClock)
        != 0x0
      {
        return .error
      }
      if (((Resp4 & 0x8000_0000) >> 31) != 0) && (((Resp4 & 0x1000000) >> 24) != 0) {
        errorstate = sdmmc.commandVoltageSwitch(getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return .error
        }
      } else {
      }
    }

    repeat {
      errorstate = sdmmc.commandSetRelativeAddress(
        &sdio_rca, getSystemCoreClock: getSystemCoreClock)
      timeout = timeout &+ (1)
      delay(1)
    } while (errorstate == 0x2000) && (timeout != 0x3e8)
    if (timeout == 0x3e8) || (errorstate != 0x0) {
      return .error
    }

    errorstate = sdmmc.commandSelectDeselect(
      UInt32(truncatingIfNeeded: ((UInt32(truncatingIfNeeded: UInt32(UInt32(sdio_rca)))) << 16)),
      getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return .error
    }
    return .ok

  }
}
