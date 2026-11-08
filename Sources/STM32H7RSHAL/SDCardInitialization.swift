// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SD {
  func initializeCardDetails(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {
    var CSD: SDCardCSD = .init()
    var errorstate: UInt32 = 0
    var sd_rca: UInt16 = 0
    var tickstart: UInt32 = 0

    sd_rca = UInt16(truncatingIfNeeded: 0)
    tickstart = getTick()

    if sdmmc.getPowerState() == 0 {
      return 0x4000000
    }
    if handle.read(.cardType) != 0x3 {
      errorstate = sdmmc.commandSendCID(getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      } else {
        handle.writeCardRegister(.cid, index: Int(0), value: sdmmc.getResponse(0x0))
        handle.writeCardRegister(.cid, index: Int(1), value: sdmmc.getResponse(0x4))
        handle.writeCardRegister(.cid, index: Int(2), value: sdmmc.getResponse(0x8))
        handle.writeCardRegister(.cid, index: Int(3), value: sdmmc.getResponse(0xc))
      }
    }
    if handle.read(.cardType) != 0x3 {

      while sd_rca == 0 {
        errorstate = sdmmc.commandSetRelativeAddress(
          &sd_rca, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }
        if (getTick() &- tickstart) >= 0x1388 {
          return 0x8000_0000
        }
      }
    }
    if handle.read(.cardType) != 0x3 {
      handle.write(.relativeCardAddress, value: UInt32(sd_rca))

      errorstate = sdmmc.commandSendCSD(
        UInt32(truncatingIfNeeded: (handle.read(.relativeCardAddress) << 16)),
        getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      } else {
        handle.writeCardRegister(.csd, index: Int(0), value: sdmmc.getResponse(0x0))
        handle.writeCardRegister(.csd, index: Int(1), value: sdmmc.getResponse(0x4))
        handle.writeCardRegister(.csd, index: Int(2), value: sdmmc.getResponse(0x8))
        handle.writeCardRegister(.csd, index: Int(3), value: sdmmc.getResponse(0xc))
      }
    }

    handle.write(.cardClass, value: (sdmmc.getResponse(0x4) >> 20))

    if getCardCSD(&CSD) != .ok {
      return 0x1000_0000
    }

    errorstate = sdmmc.commandSelectDeselect(
      UInt32(
        truncatingIfNeeded: ((UInt32(truncatingIfNeeded: handle.read(.relativeCardAddress))) << 16)),
      getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return errorstate
    }

    return 0x0

  }
  func powerOn(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {
    var count: UInt32 = 0
    var response: UInt32 = 0
    var validvoltage: UInt32 = 0
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0

    count = 0
    response = 0
    validvoltage = 0

    if useTransceiver {
      tickstart = getTick()
    }

    errorstate = sdmmc.commandGoIdle(getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return errorstate
    }

    errorstate = sdmmc.commandOperatingCondition(getSystemCoreClock: getSystemCoreClock)
    if errorstate == 0x4 {
      handle.write(.cardVersion, value: 0x0)

      errorstate = sdmmc.commandGoIdle(getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      }
    } else {
      handle.write(.cardVersion, value: 0x1)
    }
    if handle.read(.cardVersion) == 0x1 {
      errorstate = sdmmc.commandApplication(0, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return 0x1000_0000
      }
    }

    while (count < 0xffff) && (validvoltage == 0) {
      errorstate = sdmmc.commandApplication(0, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      }

      errorstate = sdmmc.commandApplicationOperatingCondition(
        0x8010_0000 | 0x4000_0000 | 0x1000000, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return 0x1000_0000
      }

      response = sdmmc.getResponse(0x0)

      validvoltage = (((response >> 31) == 1) ? 1 : 0)
      count = count &+ (1)
    }
    if count >= 0xffff {
      return 0x1000000
    }

    handle.write(.cardType, value: 0x0)
    if (response & 0x4000_0000) == 0x4000_0000 {
      handle.write(.cardType, value: 0x1)
      if useTransceiver {
        if handle.read(.transceiverPresent) == 0x2 {
          if (response & 0x1000000) == 0x1000000 {
            handle.write(.cardSpeed, value: 0x200)

            registers.write(.power, value: registers.read(.power) | (0x8))

            errorstate = sdmmc.commandVoltageSwitch(getSystemCoreClock: getSystemCoreClock)
            if errorstate != 0x0 {
              return errorstate
            }

            while (registers.read(.sta) & 0x4000000) != 0x4000000 {
              if (getTick() &- tickstart) >= 0xffff_ffff {
                return 0x8000_0000
              }
            }

            registers.write(.icr, value: 0x4000000)

            if (registers.read(.sta) & 0x100000) != 0x100000 {
              return 0x1000_0000
            } else {
              if useRegisteredCallbacks {
                callbacks.readTransceiver()!(1)
              } else {
                defaults.transceiver(1)
              }

              registers.write(.power, value: registers.read(.power) | (0x4))

              while (registers.read(.sta) & 0x2000000) != 0x2000000 {
                if (getTick() &- tickstart) >= 0xffff_ffff {
                  return 0x8000_0000
                }
              }

              registers.write(.icr, value: 0x2000000)

              if (registers.read(.sta) & 0x100000) == 0x100000 {
                return 0x1000000
              }

              registers.write(.power, value: 0x13)

              registers.write(.icr, value: 0xFFFF_FFFF)
            }
          }
        }
      }
    }
    return 0x0

  }
  func powerOff() {

    _ = sdmmc.powerOff()

  }
  func sendSDStatus(
    _ pSDstatus: UnsafeMutablePointer<UInt32>?, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0
    var count: UInt32 = 0
    var pData: UnsafeMutablePointer<UInt32>? = nil

    tickstart = getTick()

    pData = pSDstatus

    if (sdmmc.getResponse(0x0) & 0x2000000) == 0x2000000 {
      return 0x800
    }

    errorstate = sdmmc.commandBlockLength(64, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x0))
      return errorstate
    }

    errorstate = sdmmc.commandApplication(
      UInt32(truncatingIfNeeded: (handle.read(.relativeCardAddress) << 16)),
      getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x0))
      return errorstate
    }

    config.dataTimeout = 0xffff_ffff
    config.dataLength = 64
    config.dataBlockSize = 0x60
    config.transferDirection = 0x2
    config.transferMode = 0x0
    config.dpsm = 0x1
    _ = sdmmc.configureData(&config)

    errorstate = sdmmc.commandStatusRegister(getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x0))
      return errorstate
    }

    while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
      if sdmmc.getFlag(0x8000) {
        count = 0
        while count < 8 {
          pData!.pointee = sdmmc.readFIFO()
          pData = pData!.advanced(by: Int(1))
          count = count &+ (1)
        }
      }
      if (getTick() &- tickstart) >= 0xffff_ffff {
        return 0x8000_0000
      }
    }
    if sdmmc.getFlag(0x8) {
      return 0x8
    } else if sdmmc.getFlag(0x2) {
      return 0x2
    } else if sdmmc.getFlag(0x20) {
      return 0x20
    } else {
    }
    while (sdmmc.getFlag(0x1000)) {
      pData!.pointee = sdmmc.readFIFO()
      pData = pData!.advanced(by: Int(1))
      if (getTick() &- tickstart) >= 0xffff_ffff {
        return 0x8000_0000
      }
    }

    sdmmc.clearFlag(0x1800_0f3a)
    return 0x0

  }
}
