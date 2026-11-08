// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SD {
  public func configureWideBus(
    _ WideMode: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32,
    getPeripheralClockFrequency: (UInt32) -> UInt32
  ) -> HALStatus {
    var Init: SDMMCConfiguration = .init()
    var errorstate: UInt32 = 0
    var sdmmc_clk: UInt32 = 0
    var status: HALStatus = .ok

    status = .ok

    handle.write(.state, value: 0x3)
    if handle.read(.cardType) != 0x3 {
      if WideMode == 0x8000 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
      } else if WideMode == 0x4000 {
        errorstate = enableWideBus(getTick: getTick, getSystemCoreClock: getSystemCoreClock)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      } else if WideMode == 0x0 {
        errorstate = disableWideBus(getTick: getTick, getSystemCoreClock: getSystemCoreClock)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      } else {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
    }
    if handle.read(.errorCode) != 0x0 {
      sdmmc.clearFlag(0x1fe0_0fff)
      status = .error
    } else {
      sdmmc_clk = getPeripheralClockFrequency(0x200000)
      if sdmmc_clk != 0 {
        Init.clockEdge = handle.read(.clockEdge)
        Init.clockPowerSave = handle.read(.clockPowerSave)
        Init.busWide = WideMode
        Init.hardwareFlowControl = handle.read(.hardwareFlowControl)

        if handle.read(.clockDivider) >= (sdmmc_clk / (2 &* 0x17d7840)) {
          Init.clockDivider = handle.read(.clockDivider)
        } else if handle.read(.cardSpeed) == 0x200 {
          Init.clockDivider = handle.read(.clockDivider)
        } else if handle.read(.cardSpeed) == 0x100 {
          if handle.read(.clockDivider) == 0 {
            if sdmmc_clk > 0x2faf080 {
              Init.clockDivider = sdmmc_clk / (2 &* 0x2faf080)
            } else {
              Init.clockDivider = handle.read(.clockDivider)
            }
          } else {
            if (sdmmc_clk / (2 &* handle.read(.clockDivider))) > 0x2faf080 {
              Init.clockDivider = sdmmc_clk / (2 &* 0x2faf080)
            } else {
              Init.clockDivider = handle.read(.clockDivider)
            }
          }
        } else {
          if handle.read(.clockDivider) == 0 {
            if sdmmc_clk > 0x17d7840 {
              Init.clockDivider = sdmmc_clk / (2 &* 0x17d7840)
            } else {
              Init.clockDivider = handle.read(.clockDivider)
            }
          } else {
            if (sdmmc_clk / (2 &* handle.read(.clockDivider))) > 0x17d7840 {
              Init.clockDivider = sdmmc_clk / (2 &* 0x17d7840)
            } else {
              Init.clockDivider = handle.read(.clockDivider)
            }
          }
        }
        if useTransceiver {
          Init.transceiverPresent = handle.read(.transceiverPresent)
        }
        _ = sdmmc.initialize(Init)
      } else {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
        status = .error
      }
    }

    errorstate = sdmmc.commandBlockLength(0x200, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      status = .error
    }

    handle.write(.state, value: 0x1)
    return status

  }
  public func configureSpeedBus(
    _ SpeedMode: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var tickstart: UInt32 = 0
    var errorstate: UInt32 = 0
    var status: HALStatus = .ok

    status = .ok

    handle.write(.state, value: 0x3)
    if useTransceiver {
      if handle.read(.transceiverPresent) == 0x2 {
        switch SpeedMode
        {
        case 0x0:
          do {
            if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardType) == 0x1) {
              registers.write(.clkcr, value: registers.read(.clkcr) | (0x80000))

              if ultraHighSpeed(
                0x80ff_1f03, getTick: getTick, getSystemCoreClock: getSystemCoreClock) != 0x0
              {
                if switchSpeed(
                  0x80ff_ff01, getTick: getTick, getSystemCoreClock: getSystemCoreClock) != 0x0
                {
                  handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
                  status = .error
                }
              }
            } else if handle.read(.cardSpeed) == 0x100 {
              if switchSpeed(0x80ff_ff01, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
                != 0x0
              {
                handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
                status = .error
              }
            } else {
            }
            break
          }
        case 0x3:
          do {
            if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardType) == 0x1) {
              if ultraHighSpeed(
                0x80ff_1f03, getTick: getTick, getSystemCoreClock: getSystemCoreClock) != 0x0
              {
                handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
                status = .error
              }
              registers.write(.clkcr, value: registers.read(.clkcr) | (0x80000))
            } else {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
            break
          }
        case 0x5:
          do {
            if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardType) == 0x1) {
              if ultraHighSpeed(
                0x80ff_1f02, getTick: getTick, getSystemCoreClock: getSystemCoreClock) != 0x0
              {
                handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
                status = .error
              }
              registers.write(.clkcr, value: registers.read(.clkcr) | (0x80000))
            } else {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
            break
          }
        case 0x4:
          do {
            if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardType) == 0x1) {
              if ddrMode(getTick: getTick, getSystemCoreClock: getSystemCoreClock) != 0x0 {
                handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
                status = .error
              }
              registers.write(.clkcr, value: registers.read(.clkcr) | (0x80000 | 0x40000))
            } else {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
            break
          }
        case 0x2:
          do {
            if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardSpeed) == 0x100)
              || (handle.read(.cardType) == 0x1)
            {
              if switchSpeed(0x80ff_ff01, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
                != 0x0
              {
                handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
                status = .error
              }
            } else {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
            break
          }
        case 0x1:
          do {
            if switchSpeed(0x80ff_ff00, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
              != 0x0
            {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
            break
          }
        default:
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
          status = .error
          break
        }
      } else {
        switch SpeedMode
        {
        case 0x0:
          do {
            if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardSpeed) == 0x100)
              || (handle.read(.cardType) == 0x1)
            {
              if switchSpeed(0x80ff_ff01, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
                != 0x0
              {
                handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
                status = .error
              }
            } else {
            }
            break
          }
        case 0x2:
          do {
            if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardSpeed) == 0x100)
              || (handle.read(.cardType) == 0x1)
            {
              if switchSpeed(0x80ff_ff01, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
                != 0x0
              {
                handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
                status = .error
              }
            } else {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
            break
          }
        case 0x1:
          do {
            if switchSpeed(0x80ff_ff00, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
              != 0x0
            {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
            break
          }
        default:
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
          status = .error
          break
        }
      }
    } else {
      switch SpeedMode
      {
      case 0x0:
        do {
          if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardSpeed) == 0x100)
            || (handle.read(.cardType) == 0x1)
          {
            if switchSpeed(0x80ff_ff01, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
              != 0x0
            {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
          } else {
          }
          break
        }
      case 0x2:
        do {
          if (handle.read(.cardSpeed) == 0x200) || (handle.read(.cardSpeed) == 0x100)
            || (handle.read(.cardType) == 0x1)
          {
            if switchSpeed(0x80ff_ff01, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
              != 0x0
            {
              handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
              status = .error
            }
          } else {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
            status = .error
          }
          break
        }
      case 0x1:
        do {
          if switchSpeed(0x80ff_ff00, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
            != 0x0
          {
            handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
            status = .error
          }
          break
        }
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
        status = .error
        break
      }
    }

    tickstart = getTick()
    while (getCardState(getSystemCoreClock: getSystemCoreClock) != 0x4) {
      if (getTick() &- tickstart) >= 0xffff_ffff {
        handle.write(.errorCode, value: 0x8000_0000)
        handle.write(.state, value: 0x1)
        return .timeout
      }
    }

    errorstate = sdmmc.commandBlockLength(0x200, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      status = .error
    }

    handle.write(.state, value: 0x1)
    return status

  }
  func enableWideBus(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {
    return withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 2) { scr in
      scr.initialize(repeating: 0)
      var errorstate: UInt32 = 0

      if (sdmmc.getResponse(0x0) & 0x2000000) == 0x2000000 {
        return 0x800
      }

      errorstate = findSCR(
        scr.baseAddress, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      }

      if (scr[Int(1)] & 0x40000) != 0x0 {
        errorstate = sdmmc.commandApplication(
          UInt32(truncatingIfNeeded: (handle.read(.relativeCardAddress) << 16)),
          getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }

        errorstate = sdmmc.commandBusWidth(2, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }
        return 0x0
      } else {
        return 0x4000000
      }

    }
  }
  func disableWideBus(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {
    return withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 2) { scr in
      scr.initialize(repeating: 0)
      var errorstate: UInt32 = 0

      if (sdmmc.getResponse(0x0) & 0x2000000) == 0x2000000 {
        return 0x800
      }

      errorstate = findSCR(
        scr.baseAddress, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      }

      if (scr[Int(1)] & 0x10000) != 0x0 {
        errorstate = sdmmc.commandApplication(
          UInt32(truncatingIfNeeded: (handle.read(.relativeCardAddress) << 16)),
          getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }

        errorstate = sdmmc.commandBusWidth(0, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }
        return 0x0
      } else {
        return 0x4000000
      }

    }
  }
  func findSCR(
    _ pSCR: UnsafeMutablePointer<UInt32>?, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    return withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 2) { tempscr in
      tempscr.initialize(repeating: 0)
      var config: SDMMCDataConfiguration = .init()
      var errorstate: UInt32 = 0
      var tickstart: UInt32 = 0
      var index: UInt32 = 0
      var scr: UnsafeMutablePointer<UInt32>? = nil

      tickstart = getTick()
      index = 0

      scr = pSCR

      errorstate = sdmmc.commandBlockLength(8, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      }

      errorstate = sdmmc.commandApplication(
        UInt32(truncatingIfNeeded: ((handle.read(.relativeCardAddress)) << 16)),
        getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      }
      config.dataTimeout = 0xffff_ffff
      config.dataLength = 8
      config.dataBlockSize = 0x30
      config.transferDirection = 0x2
      config.transferMode = 0x0
      config.dpsm = 0x1
      _ = sdmmc.configureData(&config)

      errorstate = sdmmc.commandSendSCR(getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return errorstate
      }
      while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x400 | 0x100) {
        if (!sdmmc.getFlag(0x80000)) && (index == 0) {
          tempscr[Int(Int(0))] = sdmmc.readFIFO()
          tempscr[Int(Int(1))] = sdmmc.readFIFO()
          index = index &+ (1)
        }
        if (getTick() &- tickstart) >= 0xffff_ffff {
          return 0x8000_0000
        }
      }
      if sdmmc.getFlag(0x8) {
        sdmmc.clearFlag(0x8)
        return 0x8
      } else if sdmmc.getFlag(0x2) {
        sdmmc.clearFlag(0x2)
        return 0x2
      } else if sdmmc.getFlag(0x20) {
        sdmmc.clearFlag(0x20)
        return 0x20
      } else {

        sdmmc.clearFlag(0x1800_0f3a)
        scr!.pointee =
          (((tempscr[Int(Int(1))] & 0xff) << 24) | ((tempscr[Int(Int(1))] & 0xff00) << 8)
            | ((tempscr[Int(Int(1))] & 0xff0000) >> 8)
            | ((tempscr[Int(Int(1))] & 0xff00_0000) >> 24))
        scr = scr!.advanced(by: Int(1))
        scr!.pointee =
          (((tempscr[Int(Int(0))] & 0xff) << 24) | ((tempscr[Int(Int(0))] & 0xff00) << 8)
            | ((tempscr[Int(Int(0))] & 0xff0000) >> 8)
            | ((tempscr[Int(Int(0))] & 0xff00_0000) >> 24))
      }
      return 0x0

    }
  }
  func switchSpeed(
    _ SwitchSpeedMode: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    return withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 16) { SD_hs in
      SD_hs.initialize(repeating: 0)
      var errorstate: UInt32 = 0
      var sdmmc_datainitstructure: SDMMCDataConfiguration = .init()
      var count: UInt32 = 0
      var loop: UInt32 = 0
      var Timeout: UInt32 = 0

      errorstate = 0x0

      loop = 0
      Timeout = getTick()
      if handle.read(.cardSpeed) == 0x0 {
        return 0x4000000
      }
      if handle.read(.cardSpeed) >= 0x100 {
        registers.write(.dctrl, value: 0)
        errorstate = sdmmc.commandBlockLength(64, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }

        sdmmc_datainitstructure.dataTimeout = 0xffff_ffff
        sdmmc_datainitstructure.dataLength = 64
        sdmmc_datainitstructure.dataBlockSize = 0x60
        sdmmc_datainitstructure.transferDirection = 0x2
        sdmmc_datainitstructure.transferMode = 0x0
        sdmmc_datainitstructure.dpsm = 0x1
        _ = sdmmc.configureData(&sdmmc_datainitstructure)
        errorstate = sdmmc.commandSwitch(SwitchSpeedMode, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }
        while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x400 | 0x100) {
          if sdmmc.getFlag(0x8000) {
            count = 0
            while count < 8 {
              SD_hs[Int(Int((8 &* loop) &+ count))] = sdmmc.readFIFO()
              count = count &+ (1)
            }
            loop = loop &+ (1)
          }
          if (getTick() &- Timeout) >= 0xffff_ffff {
            handle.write(.errorCode, value: 0x8000_0000)
            handle.write(.state, value: 0x1)
            return 0x8000_0000
          }
        }
        if sdmmc.getFlag(0x8) {
          sdmmc.clearFlag(0x8)
          return errorstate
        } else if sdmmc.getFlag(0x2) {
          sdmmc.clearFlag(0x2)
          errorstate = 0x2
          return errorstate
        } else if sdmmc.getFlag(0x20) {
          sdmmc.clearFlag(0x20)
          errorstate = 0x20
          return errorstate
        } else {
        }

        sdmmc.clearFlag(0x1800_0f3a)

        if (UInt32(UnsafeRawPointer(SD_hs.baseAddress!).load(fromByteOffset: 13, as: UInt8.self))
          & 2) != 2
        {
          errorstate = 0x1000_0000
        }
      }
      return errorstate

    }
  }
  func ultraHighSpeed(
    _ UltraHighSpeedMode: UInt32, getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    return withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 16) { SD_hs in
      SD_hs.initialize(repeating: 0)
      var errorstate: UInt32 = 0
      var sdmmc_datainitstructure: SDMMCDataConfiguration = .init()
      var count: UInt32 = 0
      var loop: UInt32 = 0
      var Timeout: UInt32 = 0

      errorstate = 0x0

      loop = 0
      Timeout = getTick()
      if handle.read(.cardSpeed) == 0x0 {
        return 0x4000000
      }
      if handle.read(.cardSpeed) == 0x200 {
        registers.write(.dctrl, value: 0)
        errorstate = sdmmc.commandBlockLength(64, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }

        sdmmc_datainitstructure.dataTimeout = 0xffff_ffff
        sdmmc_datainitstructure.dataLength = 64
        sdmmc_datainitstructure.dataBlockSize = 0x60
        sdmmc_datainitstructure.transferDirection = 0x2
        sdmmc_datainitstructure.transferMode = 0x0
        sdmmc_datainitstructure.dpsm = 0x1
        if sdmmc.configureData(&sdmmc_datainitstructure) != .ok {
          return (0x10000)
        }
        errorstate = sdmmc.commandSwitch(UltraHighSpeedMode, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }
        while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x400 | 0x100) {
          if sdmmc.getFlag(0x8000) {
            count = 0
            while count < 8 {
              SD_hs[Int(Int((8 &* loop) &+ count))] = sdmmc.readFIFO()
              count = count &+ (1)
            }
            loop = loop &+ (1)
          }
          if (getTick() &- Timeout) >= 0xffff_ffff {
            handle.write(.errorCode, value: 0x8000_0000)
            handle.write(.state, value: 0x1)
            return 0x8000_0000
          }
        }
        if sdmmc.getFlag(0x8) {
          sdmmc.clearFlag(0x8)
          return errorstate
        } else if sdmmc.getFlag(0x2) {
          sdmmc.clearFlag(0x2)
          errorstate = 0x2
          return errorstate
        } else if sdmmc.getFlag(0x20) {
          sdmmc.clearFlag(0x20)
          errorstate = 0x20
          return errorstate
        } else {
        }

        sdmmc.clearFlag(0x1800_0f3a)

        if (UInt32(UnsafeRawPointer(SD_hs.baseAddress!).load(fromByteOffset: 13, as: UInt8.self))
          & 2) != 2
        {
          errorstate = 0x1000_0000
        } else {
          if useRegisteredCallbacks {
            callbacks.readTransceiver()!(1)
          } else {
            defaults.transceiver(1)
          }
          do {

            registers.write(.clkcr, value: ((registers.read(.clkcr) & ~(0x300000)) | (0x200000)))
            registers.writeDelayControl(registers.readDelayControl() | 1)
          }
        }
      }
      return errorstate

    }
  }
  func ddrMode(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {
    return withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 16) { SD_hs in
      SD_hs.initialize(repeating: 0)
      var errorstate: UInt32 = 0
      var sdmmc_datainitstructure: SDMMCDataConfiguration = .init()
      var count: UInt32 = 0
      var loop: UInt32 = 0
      var Timeout: UInt32 = 0

      errorstate = 0x0

      loop = 0
      Timeout = getTick()
      if handle.read(.cardSpeed) == 0x0 {
        return 0x4000000
      }
      if handle.read(.cardSpeed) == 0x200 {
        registers.write(.dctrl, value: 0)
        errorstate = sdmmc.commandBlockLength(64, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }

        sdmmc_datainitstructure.dataTimeout = 0xffff_ffff
        sdmmc_datainitstructure.dataLength = 64
        sdmmc_datainitstructure.dataBlockSize = 0x60
        sdmmc_datainitstructure.transferDirection = 0x2
        sdmmc_datainitstructure.transferMode = 0x0
        sdmmc_datainitstructure.dpsm = 0x1
        if sdmmc.configureData(&sdmmc_datainitstructure) != .ok {
          return (0x10000)
        }
        errorstate = sdmmc.commandSwitch(0x80ff_ff04, getSystemCoreClock: getSystemCoreClock)
        if errorstate != 0x0 {
          return errorstate
        }
        while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x400 | 0x100) {
          if sdmmc.getFlag(0x8000) {
            count = 0
            while count < 8 {
              SD_hs[Int(Int((8 &* loop) &+ count))] = sdmmc.readFIFO()
              count = count &+ (1)
            }
            loop = loop &+ (1)
          }
          if (getTick() &- Timeout) >= 0xffff_ffff {
            handle.write(.errorCode, value: 0x8000_0000)
            handle.write(.state, value: 0x1)
            return 0x8000_0000
          }
        }
        if sdmmc.getFlag(0x8) {
          sdmmc.clearFlag(0x8)
          return errorstate
        } else if sdmmc.getFlag(0x2) {
          sdmmc.clearFlag(0x2)
          errorstate = 0x2
          return errorstate
        } else if sdmmc.getFlag(0x20) {
          sdmmc.clearFlag(0x20)
          errorstate = 0x20
          return errorstate
        } else {
        }

        sdmmc.clearFlag(0x1800_0f3a)

        if (UInt32(UnsafeRawPointer(SD_hs.baseAddress!).load(fromByteOffset: 13, as: UInt8.self))
          & 2) != 2
        {
          errorstate = 0x1000_0000
        } else {
          if useRegisteredCallbacks {
            callbacks.readTransceiver()!(1)
          } else {
            defaults.transceiver(1)
          }
          do {

            registers.write(.clkcr, value: ((registers.read(.clkcr) & ~(0x300000)) | (0x100000)))
            registers.writeDelayControl(registers.readDelayControl() | 1)
          }
        }
      }
      return errorstate

    }
  }
}
