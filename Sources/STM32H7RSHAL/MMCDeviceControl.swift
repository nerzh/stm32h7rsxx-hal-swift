// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MMC {
  public func eraseSequence(
    _ EraseType: UInt32, _ BlockStartAdd: UInt32, _ BlockEndAdd: UInt32, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var errorstate: UInt32 = 0
    var start_add: UInt32 = 0
    var end_add: UInt32 = 0
    var tickstart: UInt32 = 0

    start_add = BlockStartAdd
    end_add = BlockEndAdd
    tickstart = getTick()

    if end_add < start_add {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }

    if end_add > (handle.read(.logicalBlockCount)) {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x2000000))
      return .error
    }

    if ((handle.extendedCSDPointer()[Int((0x3d / 4))] >> 0x8) & 0x0000_00FF) != 0x0 {
      if ((start_add % 8) != 0) || ((end_add % 8) != 0) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
        return .error
      }
    }

    if ((handle.read(.cardClass)) & 0x20) == 0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x4000000))
      return .error
    }

    if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x3)

      if (sdmmc.getResponse(0x0) & 0x2000000) == 0x2000000 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x800))
        handle.write(.state, value: 0x1)
        return .error
      }

      if (handle.read(.cardType)) != 0x1 {
        start_add = start_add &* (0x200)
        end_add = end_add &* (0x200)
      }

      errorstate = sdmmc.commandEraseStartAddress(start_add, getSystemCoreClock: getSystemCoreClock)
      if errorstate == 0x0 {
        errorstate = sdmmc.commandEraseEndAddress(end_add, getSystemCoreClock: getSystemCoreClock)
        if errorstate == 0x0 {
          errorstate = sdmmc.commandErase(EraseType, getSystemCoreClock: getSystemCoreClock)
          if errorstate == 0x0 {
            if (EraseType == 0x8000_0000) || (EraseType == 0x8000_8000) {
              while (!sdmmc.getFlag(0x200000)) && (errorstate == 0x0) {
                if (getTick() &- tickstart) >= 0xf618 {
                  errorstate = 0x8000_0000
                }
              }

              sdmmc.clearFlag(0x200000)
            }
          }
        }
      }

      handle.write(.state, value: 0x1)

      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != 0x8000_0000 {
          return .error
        } else {
          return .timeout
        }
      } else {
        return .ok
      }
    } else {
      return .busy
    }

  }
  public func sanitize(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus {
    var errorstate: UInt32 = 0
    var response: UInt32 = 0
    var count: UInt32 = 0
    var tickstart: UInt32 = 0

    response = 0

    tickstart = getTick()

    if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x3)

      errorstate = sdmmc.commandSwitch(0x03A5_0100, getSystemCoreClock: getSystemCoreClock)
      if errorstate == 0x0 {
        while (!sdmmc.getFlag(0x200000)) && (errorstate == 0x0) {
          if (getTick() &- tickstart) >= 0xf618 {
            errorstate = 0x8000_0000
          }
        }

        sdmmc.clearFlag(0x200000)
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
        if errorstate != 0x8000_0000 {
          return .error
        } else {
          return .timeout
        }
      } else {
        return .ok
      }
    } else {
      return .busy
    }

  }
  public func configureSecureRemovalType(_ SRTMode: UInt32, getSystemCoreClock: () -> UInt32)
    -> HALStatus
  {
    var srt: UInt32 = 0
    var errorstate: UInt32 = 0
    var response: UInt32 = 0
    var count: UInt32 = 0

    response = 0

    if handle.read(.state) == 0x1 {
      if getSupportedSecureRemovalType(&srt) == .ok {
        handle.write(.state, value: 0x3)

        if (SRTMode & srt) != 0 {
          srt = srt | (((UInt32((SRTMode).trailingZeroBitCount)) << 4))
          errorstate = sdmmc.commandSwitch(
            (0x0310_0000 | (srt << 8)), getSystemCoreClock: getSystemCoreClock)
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
                errorstate = 0x10000
              }
            } else if count == 0 {
              errorstate = 0x8000_0000
            } else {
            }
          }
        } else {
          errorstate = 0x1000_0000
        }

        handle.write(.state, value: 0x1)
      } else {
        errorstate = 0x10000
      }

      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        return .error
      } else {
        return .ok
      }
    } else {
      return .busy
    }

  }
  public func getSupportedSecureRemovalType(_ SupportedSRT: UnsafeMutablePointer<UInt32>?)
    -> HALStatus
  {

    if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x3)

      SupportedSRT!.pointee = (handle.extendedCSDPointer()[Int(4)] & 0x0000_000F)

      handle.write(.state, value: 0x1)
      return .ok
    } else {
      return .busy
    }

  }
  public func sleepDevice(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus {
    var errorstate: UInt32 = 0
    var sleep_timeout: UInt32 = 0
    var timeout: UInt32 = 0
    var count: UInt32 = 0
    var response: UInt32 = 0
    var tickstart: UInt32 = 0

    response = 0
    tickstart = getTick()

    if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x3)

      errorstate = sdmmc.commandSwitch((0x0322_0100), getSystemCoreClock: getSystemCoreClock)
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

        if count == 0 {
          errorstate = 0x8000_0000
        } else if errorstate == 0x0 {
          if (response & 0x80) != 0 {
            errorstate = 0x1000_0000
          } else {
            errorstate = sdmmc.commandSwitch((0x0322_0400), getSystemCoreClock: getSystemCoreClock)
            if errorstate == 0x0 {
              sleep_timeout = ((handle.extendedCSDPointer()[Int((0xd8 / 4))] >> 0x0) & 0x0000_00FF)

              if (sleep_timeout == 0) || (sleep_timeout > 0x17) {
                sleep_timeout = 0x17
              }
              timeout = (((1 << sleep_timeout) / 100) &+ 1)

              while (!sdmmc.getFlag(0x200000)) && (errorstate == 0x0) {
                if (getTick() &- tickstart) >= timeout {
                  errorstate = 0x8000_0000
                }
              }

              sdmmc.clearFlag(0x200000)
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

                if count == 0 {
                  errorstate = 0x8000_0000
                } else if errorstate == 0x0 {
                  if (response & 0x80) != 0 {
                    errorstate = 0x1000_0000
                  } else {
                    _ = sdmmc.commandSelectDeselect(0, getSystemCoreClock: getSystemCoreClock)

                    sleep_timeout =
                      ((handle.extendedCSDPointer()[Int((0xd9 / 4))] >> 0x8) & 0x0000_00FF)

                    if (sleep_timeout == 0) || (sleep_timeout > 0x17) {
                      sleep_timeout = 0x17
                    }
                    timeout = (((1 << sleep_timeout) / 10000) &+ 1)
                    if getCardState(getSystemCoreClock: getSystemCoreClock) == 0x3 {
                      errorstate = sdmmc.commandSleepMMC(
                        ((handle.read(.relativeCardAddress) << 16) | (0x1 << 15)),
                        getSystemCoreClock: getSystemCoreClock)
                      if errorstate == 0x0 {
                        while (!sdmmc.getFlag(0x200000)) && (errorstate == 0x0) {
                          if (getTick() &- tickstart) >= timeout {
                            errorstate = 0x8000_0000
                          }
                        }

                        sdmmc.clearFlag(0x200000)
                      }
                    } else {
                      errorstate = 0x4000000
                    }
                  }
                } else {
                }
              }
            }
          }
        } else {
        }
      }

      handle.write(.state, value: 0x1)

      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != 0x8000_0000 {
          return .error
        } else {
          return .timeout
        }
      } else {
        return .ok
      }
    } else {
      return .busy
    }

  }
  public func awakeDevice(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus {
    var errorstate: UInt32 = 0
    var sleep_timeout: UInt32 = 0
    var timeout: UInt32 = 0
    var count: UInt32 = 0
    var response: UInt32 = 0
    var tickstart: UInt32 = 0

    response = 0
    tickstart = getTick()

    if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x3)

      sleep_timeout = ((handle.extendedCSDPointer()[Int((0xd9 / 4))] >> 0x8) & 0x0000_00FF)

      if (sleep_timeout == 0) || (sleep_timeout > 0x17) {
        sleep_timeout = 0x17
      }
      timeout = (((1 << sleep_timeout) / 10000) &+ 1)

      errorstate = sdmmc.commandSleepMMC(
        (handle.read(.relativeCardAddress) << 16), getSystemCoreClock: getSystemCoreClock)
      if errorstate == 0x0 {
        while (!sdmmc.getFlag(0x200000)) && (errorstate == 0x0) {
          if (getTick() &- tickstart) >= timeout {
            errorstate = 0x8000_0000
          }
        }

        sdmmc.clearFlag(0x200000)
        if errorstate == 0x0 {
          if getCardState(getSystemCoreClock: getSystemCoreClock) == 0x3 {
            errorstate = sdmmc.commandSelectDeselect(
              (handle.read(.relativeCardAddress) << 16), getSystemCoreClock: getSystemCoreClock)
            if errorstate == 0x0 {
              if getCardState(getSystemCoreClock: getSystemCoreClock) == 0x4 {
                errorstate = sdmmc.commandSwitch(
                  (0x0322_0100), getSystemCoreClock: getSystemCoreClock)
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

                  if count == 0 {
                    errorstate = 0x8000_0000
                  } else if errorstate == 0x0 {
                    if (response & 0x80) != 0 {
                      errorstate = 0x1000_0000
                    }
                  } else {
                  }
                }
              } else {
                errorstate = 0x4000000
              }
            }
          } else {
            errorstate = 0x4000000
          }
        }
      }

      handle.write(.state, value: 0x1)

      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        if errorstate != 0x8000_0000 {
          return .error
        } else {
          return .timeout
        }
      } else {
        return .ok
      }
    } else {
      return .busy
    }

  }
  public func switchPartition(
    _ Partition: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var errorstate: UInt32 = 0
    var response: UInt32 = 0
    var count: UInt32 = 0
    var tickstart: UInt32 = 0
    var arg: UInt32 = 0

    response = 0

    tickstart = getTick()
    arg = Partition | 0x03B3_0000

    if handle.read(.state) == 0x1 {
      handle.write(.state, value: 0x3)

      errorstate = sdmmc.commandSwitch(arg, getSystemCoreClock: getSystemCoreClock)
      if errorstate == 0x0 {
        while (!sdmmc.getFlag(0x200000)) && (errorstate == 0x0) {
          if (getTick() &- tickstart) >= 0xf618 {
            errorstate = 0x8000_0000
          }
        }

        sdmmc.clearFlag(0x200000)
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
        if errorstate != 0x8000_0000 {
          return .error
        } else {
          return .timeout
        }
      } else {
        return .ok
      }
    } else {
      return .busy
    }

  }
}
