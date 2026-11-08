// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MMC {
  public func configureWideBus(
    _ WideMode: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var count: UInt32 = 0
    var Init: SDMMCConfiguration = .init()
    var errorstate: UInt32 = 0
    var response: UInt32 = 0

    response = 0

    handle.write(.state, value: 0x3)

    if (registers.read(.clkcr) & 0x80000) != 0 {
      if (registers.read(.clkcr) & 0x40000) != 0 {
        errorstate = updatePowerClass(
          WideMode, 0x4, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
      } else {
        errorstate = updatePowerClass(
          WideMode, 0x2, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
      }
    } else {
      errorstate = updatePowerClass(
        WideMode, 0x1, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
    }
    if errorstate == 0x0 {
      if WideMode == 0x8000 {
        errorstate = sdmmc.commandSwitch(0x03B7_0200, getSystemCoreClock: getSystemCoreClock)
      } else if WideMode == 0x4000 {
        errorstate = sdmmc.commandSwitch(0x03B7_0100, getSystemCoreClock: getSystemCoreClock)
      } else if WideMode == 0x0 {
        errorstate = sdmmc.commandSwitch(0x03B7_0000, getSystemCoreClock: getSystemCoreClock)
      } else {
        errorstate = 0x8000000
      }

      if errorstate == 0x0 {
        count = 0xffff
        repeat {
          errorstate = sdmmc.commandSendStatus(
            UInt32(
              truncatingIfNeeded: ((UInt32(truncatingIfNeeded: handle.read(.relativeCardAddress)))
                << 16)), getSystemCoreClock: getSystemCoreClock)
          if errorstate != 0x0 {
            break
          }

          response = sdmmc.getResponse(0x0)
          count = count &- (1)
        } while ((response & 0x100) == 0) && (count != 0)

        if (count != 0) && (errorstate == 0x0) {
          if (response & 0x80) != 0 {
            errorstate = 0x10000
          } else {
            Init = SDMMCConfiguration(
              clockEdge: handle.read(.clockEdge), clockPowerSave: handle.read(.clockPowerSave),
              busWide: handle.read(.busWide),
              hardwareFlowControl: handle.read(.hardwareFlowControl),
              clockDivider: handle.read(.clockDivider),
              transceiverPresent: handle.read(.transceiverPresent))
            Init.busWide = WideMode
            _ = sdmmc.initialize(Init)
          }
        } else if count == 0 {
          errorstate = 0x8000_0000
        } else {
        }
      }
    }

    handle.write(.state, value: 0x1)
    if errorstate != 0x0 {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      return .error
    }
    return .ok

  }
  public func configureSpeedBus(
    _ SpeedMode: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32,
    getPeripheralClockFrequency: (UInt32) -> UInt32
  ) -> HALStatus {
    var tickstart: UInt32 = 0
    var status: HALStatus = .ok
    var device_type: UInt32 = 0
    var errorstate: UInt32 = 0

    status = .ok

    handle.write(.state, value: 0x3)

    device_type = (handle.extendedCSDPointer()[Int(49)] & 0x0000_00FF)
    switch SpeedMode
    {
    case 0x0:
      do {
        if ((registers.read(.clkcr) & 0xc000) != 0) && ((device_type & 0x04) != 0) {
          errorstate = highSpeed(
            0x1, getTick: getTick, getSystemCoreClock: getSystemCoreClock,
            getPeripheralClockFrequency: getPeripheralClockFrequency)
          if errorstate != 0x0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          } else {
            if (registers.read(.clkcr) & 0x3ff) != 0 {
              errorstate = ddrMode(0x1, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              }
            }
          }
        } else if (device_type & 0x02) != 0 {
          errorstate = highSpeed(
            0x1, getTick: getTick, getSystemCoreClock: getSystemCoreClock,
            getPeripheralClockFrequency: getPeripheralClockFrequency)
          if errorstate != 0x0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          }
        } else {
        }
        break
      }
    case 0x4:
      do {
        if ((registers.read(.clkcr) & 0xc000) != 0) && ((device_type & 0x04) != 0) {
          errorstate = highSpeed(
            0x1, getTick: getTick, getSystemCoreClock: getSystemCoreClock,
            getPeripheralClockFrequency: getPeripheralClockFrequency)
          if errorstate != 0x0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          } else {
            if (registers.read(.clkcr) & 0x3ff) != 0 {
              errorstate = ddrMode(0x1, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
              }
            }
          }
        } else {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
          status = .error
        }
        break
      }
    case 0x2:
      do {
        if (device_type & 0x02) != 0 {
          errorstate = highSpeed(
            0x1, getTick: getTick, getSystemCoreClock: getSystemCoreClock,
            getPeripheralClockFrequency: getPeripheralClockFrequency)
          if errorstate != 0x0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          }
        } else {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
          status = .error
        }
        break
      }
    case 0x1:
      do {
        if (registers.read(.clkcr) & 0x40000) != 0 {
          errorstate = ddrMode(0x0, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
          if errorstate != 0x0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          }
        }
        if (registers.read(.clkcr) & 0x80000) != 0 {
          errorstate = highSpeed(
            0x0, getTick: getTick, getSystemCoreClock: getSystemCoreClock,
            getPeripheralClockFrequency: getPeripheralClockFrequency)
          if errorstate != 0x0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
          }
        }
        break
      }
    default:
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      status = .error
      break
    }

    tickstart = getTick()
    while (getCardState(getSystemCoreClock: getSystemCoreClock) != 0x4) {
      if (getTick() &- tickstart) >= 0xffff_ffff {
        handle.write(.errorCode, value: 0x8000_0000)
        handle.write(.state, value: 0x1)
        return .timeout
      }
    }

    handle.write(.state, value: 0x1)
    return status

  }
  func highSpeed(
    _ state: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32,
    getPeripheralClockFrequency: (UInt32) -> UInt32
  ) -> UInt32 {
    var errorstate: UInt32 = 0
    var response: UInt32 = 0
    var count: UInt32 = 0
    var sdmmc_clk: UInt32 = 0
    var Init: SDMMCConfiguration = .init()

    errorstate = 0x0
    response = 0

    if ((registers.read(.clkcr) & 0x80000) != 0) && (state == 0x0) {
      errorstate = updatePowerClass(
        (registers.read(.clkcr) & 0xc000), 0x1, getTick: getTick,
        getSystemCoreClock: getSystemCoreClock)
      if errorstate == 0x0 {
        errorstate = sdmmc.commandSwitch(0x03B9_0000, getSystemCoreClock: getSystemCoreClock)
      }
    }
    if ((registers.read(.clkcr) & 0x80000) == 0) && (state != 0x0) {
      errorstate = updatePowerClass(
        (registers.read(.clkcr) & 0xc000), 0x2, getTick: getTick,
        getSystemCoreClock: getSystemCoreClock)
      if errorstate == 0x0 {
        errorstate = sdmmc.commandSwitch(0x03B9_0100, getSystemCoreClock: getSystemCoreClock)
      }
    }
    if errorstate == 0x0 {
      count = 0xffff
      repeat {
        errorstate = sdmmc.commandSendStatus(
          UInt32(
            truncatingIfNeeded: ((UInt32(truncatingIfNeeded: handle.read(.relativeCardAddress)))
              << 16)), getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          break
        }

        response = sdmmc.getResponse(0x0)
        count = count &- (1)
      } while ((response & 0x100) == 0) && (count != 0)

      if (count != 0) && (errorstate == 0x0) {
        if (response & 0x80) != 0 {
          errorstate = 0x1000_0000
        } else {
          Init.clockEdge = handle.read(.clockEdge)
          Init.clockPowerSave = handle.read(.clockPowerSave)
          Init.busWide = (registers.read(.clkcr) & 0xc000)
          Init.hardwareFlowControl = handle.read(.hardwareFlowControl)
          if state == 0x0 {
            Init.clockDivider = handle.read(.clockDivider)
            _ = sdmmc.initialize(Init)
            registers.write(.clkcr, value: registers.read(.clkcr) & (~(0x80000)))
          } else {
            sdmmc_clk = getPeripheralClockFrequency(0x200000)
            if sdmmc_clk == 0 {
              errorstate = 0x8000000
            } else {
              if sdmmc_clk <= 0x3197500 {
                Init.clockDivider = 0
              } else {
                Init.clockDivider = (sdmmc_clk / (2 &* 0x3197500)) &+ 1
              }
              _ = sdmmc.initialize(Init)
              registers.write(.clkcr, value: registers.read(.clkcr) | (0x80000))
            }
          }
        }
      } else if count == 0 {
        errorstate = 0x8000_0000
      } else {
      }
    }
    return errorstate

  }
  func ddrMode(_ state: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {
    var errorstate: UInt32 = 0
    var response: UInt32 = 0
    var count: UInt32 = 0

    errorstate = 0x0
    response = 0

    if ((registers.read(.clkcr) & 0x40000) != 0) && (state == 0x0) {
      if (registers.read(.clkcr) & 0x4000) != 0 {
        errorstate = updatePowerClass(
          0x4000, 0x2, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
        if errorstate == 0x0 {
          errorstate = sdmmc.commandSwitch(0x03B7_0100, getSystemCoreClock: getSystemCoreClock)
        }
      } else {
        errorstate = updatePowerClass(
          0x8000, 0x2, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
        if errorstate == 0x0 {
          errorstate = sdmmc.commandSwitch(0x03B7_0200, getSystemCoreClock: getSystemCoreClock)
        }
      }
    }
    if ((registers.read(.clkcr) & 0x40000) == 0) && (state != 0x0) {
      if (registers.read(.clkcr) & 0x4000) != 0 {
        errorstate = updatePowerClass(
          0x4000, 0x4, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
        if errorstate == 0x0 {
          errorstate = sdmmc.commandSwitch(0x03B7_0500, getSystemCoreClock: getSystemCoreClock)
        }
      } else {
        errorstate = updatePowerClass(
          0x8000, 0x4, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
        if errorstate == 0x0 {
          errorstate = sdmmc.commandSwitch(0x03B7_0600, getSystemCoreClock: getSystemCoreClock)
        }
      }
    }
    if errorstate == 0x0 {
      count = 0xffff
      repeat {
        errorstate = sdmmc.commandSendStatus(
          UInt32(
            truncatingIfNeeded: ((UInt32(truncatingIfNeeded: handle.read(.relativeCardAddress)))
              << 16)), getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          break
        }

        response = sdmmc.getResponse(0x0)
        count = count &- (1)
      } while ((response & 0x100) == 0) && (count != 0)

      if (count != 0) && (errorstate == 0x0) {
        if (response & 0x80) != 0 {
          errorstate = 0x1000_0000
        } else {
          if state == 0x0 {
            registers.write(.clkcr, value: registers.read(.clkcr) & (~(0x40000)))
          } else {
            registers.write(.clkcr, value: registers.read(.clkcr) | (0x40000))
          }
        }
      } else if count == 0 {
        errorstate = 0x8000_0000
      } else {
      }
    }
    return errorstate

  }
  func updatePowerClass(
    _ Wide: UInt32, _ Speed: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    var count: UInt32 = 0
    var response: UInt32 = 0
    var errorstate: UInt32 = 0
    var power_class: UInt32 = 0
    var supported_pwr_class: UInt32 = 0

    response = 0
    errorstate = 0x0

    if (Wide == 0x8000) || (Wide == 0x4000) {
      power_class = 0

      if readExtendedCSDField(
        &power_class, UInt16(truncatingIfNeeded: 187), 0xffff_ffff, getTick: getTick,
        getSystemCoreClock: getSystemCoreClock) != .ok
      {
        errorstate = 0x10000
      } else {
        power_class = ((power_class >> 24) & 0x0000_00FF)
      }

      if Speed == 0x4 {
        supported_pwr_class =
          ((handle.extendedCSDPointer()[Int(((lowVoltage ? 0xee : 0xef) / 4))]
            >> (lowVoltage ? 0x10 : 0x18)) & 0x0000_00FF)
      } else if Speed == 0x2 {
        supported_pwr_class =
          ((handle.extendedCSDPointer()[Int(((lowVoltage ? 0xc8 : 0xca) / 4))]
            >> (lowVoltage ? 0x0 : 0x10)) & 0x0000_00FF)
      } else {
        supported_pwr_class =
          ((handle.extendedCSDPointer()[Int(((lowVoltage ? 0xc9 : 0xcb) / 4))]
            >> (lowVoltage ? 0x8 : 0x18)) & 0x0000_00FF)
      }
      if errorstate == 0x0 {
        if Wide == 0x8000 {
          supported_pwr_class = (supported_pwr_class >> 4)
        }
        if (power_class & 0x0F) != (supported_pwr_class & 0x0F) {
          errorstate = sdmmc.commandSwitch(
            (0x03BB_0000 | ((supported_pwr_class & 0x0F) << 8)),
            getSystemCoreClock: getSystemCoreClock)
          if errorstate == 0x0 {
            count = 0xffff
            repeat {
              errorstate = sdmmc.commandSendStatus(
                UInt32(
                  truncatingIfNeeded: ((UInt32(
                    truncatingIfNeeded: handle.read(.relativeCardAddress))) << 16)),
                getSystemCoreClock: getSystemCoreClock)
              if errorstate != 0x0 {
                break
              }

              response = sdmmc.getResponse(0x0)
              count = count &- (1)
            } while ((response & 0x100) == 0) && (count != 0)

            if (count != 0) && (errorstate == 0x0) {
              if (response & 0x80) != 0 {
                errorstate = 0x1000_0000
              }
            } else if count == 0 {
              errorstate = 0x8000_0000
            } else {
            }
          }
        }
      }
    }
    return errorstate

  }
}
