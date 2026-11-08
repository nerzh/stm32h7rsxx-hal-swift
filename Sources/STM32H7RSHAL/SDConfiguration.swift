// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SD {
  public func initialize(
    getTick: () -> UInt32, getSystemCoreClock: () -> UInt32,
    getPeripheralClockFrequency: (UInt32) -> UInt32, delay: (UInt32) -> Void
  ) -> HALStatus {
    var CardStatus: SDCardStatus = .init()
    var speedgrade: UInt32 = 0
    var unitsize: UInt32 = 0
    var tickstart: UInt32 = 0

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0)
      if useTransceiver {
        if handle.read(.transceiverPresent) == 0x0 {
          handle.write(.transceiverPresent, value: 0x2)
        }
      }
      if useRegisteredCallbacks {
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        callbacks.write(.error, value: defaults.error)
        callbacks.write(.abortComplete, value: defaults.abortComplete)
        callbacks.write(
          .readDMALinkedListBufferComplete, value: defaults.readDMALinkedListBufferComplete)
        callbacks.write(
          .writeDMALinkedListBufferComplete, value: defaults.writeDMALinkedListBufferComplete)
        if useTransceiver {
          if handle.read(.transceiverPresent) == 0x2 {
            callbacks.writeTransceiver(defaults.transceiver)
          }
        }
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }

        callbacks.read(.mspInitialize)!(callbacks.context)
      } else {
        defaults.mspInitialize(callbacks.context)
      }
    }
    handle.write(.state, value: 0x4)

    if initializeCard(
      getTick: getTick, getSystemCoreClock: getSystemCoreClock,
      getPeripheralClockFrequency: getPeripheralClockFrequency, delay: delay) != .ok
    {
      return .error
    }
    if getCardStatus(&CardStatus, getTick: getTick, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }
    speedgrade = UInt32(UInt32(CardStatus.uhsSpeedGrade))
    unitsize = UInt32(UInt32(CardStatus.uhsAllocationUnitSize))
    if (handle.read(.cardType) == 0x1) && ((speedgrade != 0) || (unitsize != 0)) {
      handle.write(.cardSpeed, value: 0x200)
    } else {
      if handle.read(.cardType) == 0x1 {
        handle.write(.cardSpeed, value: 0x100)
      } else {
        handle.write(.cardSpeed, value: 0x0)
      }
    }
    if configureWideBus(
      handle.read(.busWide), getTick: getTick, getSystemCoreClock: getSystemCoreClock,
      getPeripheralClockFrequency: getPeripheralClockFrequency) != .ok
    {
      return .error
    }

    tickstart = getTick()
    while (getCardState(getSystemCoreClock: getSystemCoreClock) != 0x4) {
      if (getTick() &- tickstart) >= 0xffff_ffff {
        handle.write(.errorCode, value: 0x8000_0000)
        handle.write(.state, value: 0x1)
        return .timeout
      }
    }

    handle.write(.errorCode, value: 0x0)

    handle.write(.transferContext, value: 0x0)

    handle.write(.state, value: 0x1)
    return .ok

  }
  public func initializeCard(
    getTick: () -> UInt32, getSystemCoreClock: () -> UInt32,
    getPeripheralClockFrequency: (UInt32) -> UInt32, delay: (UInt32) -> Void
  ) -> HALStatus {
    var errorstate: UInt32 = 0
    var Init: SDMMCConfiguration = .init()
    var sdmmc_clk: UInt32 = 0

    Init.clockEdge = 0x0
    Init.clockPowerSave = 0x0
    Init.busWide = 0x0
    Init.hardwareFlowControl = 0x0

    sdmmc_clk = getPeripheralClockFrequency(0x200000)
    if sdmmc_clk == 0 {
      handle.write(.state, value: 0x1)
      handle.write(.errorCode, value: 0x8000000)
      return .error
    }
    Init.clockDivider = sdmmc_clk / (2 &* 0x61a80)
    if useTransceiver {
      Init.transceiverPresent = handle.read(.transceiverPresent)
      if handle.read(.transceiverPresent) == 0x2 {
        registers.write(.power, value: registers.read(.power) | (0x10))
      }
    } else if useDirectionPolarity {
      registers.write(.power, value: registers.read(.power) | (0x10))
    }

    _ = sdmmc.initialize(Init)

    _ = sdmmc.powerOn()

    if Init.clockDivider != 0 {
      sdmmc_clk = sdmmc_clk / (2 &* Init.clockDivider)
    }
    if sdmmc_clk != 0 {
      delay(1 &+ (74 &* 1000 / (sdmmc_clk)))
    }

    errorstate = powerOn(getTick: getTick, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.state, value: 0x1)
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      return .error
    }

    errorstate = initializeCardDetails(getTick: getTick, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.state, value: 0x1)
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      return .error
    }

    errorstate = sdmmc.commandBlockLength(0x200, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      handle.write(.state, value: 0x1)
      return .error
    }
    return .ok

  }
  public func deinitialize() -> HALStatus {

    handle.write(.state, value: 0x3)
    if useTransceiver {
      if handle.read(.transceiverPresent) == 0x2 {
        if useRegisteredCallbacks {
          if callbacks.readTransceiver() == nil {
            callbacks.writeTransceiver(defaults.transceiver)
          }
          callbacks.readTransceiver()!(0)
        } else {
          defaults.transceiver(0)
        }
      }
    }

    powerOff()
    if useRegisteredCallbacks {
      if callbacks.read(.mspDeinitialize) == nil {
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
      }

      callbacks.read(.mspDeinitialize)!(callbacks.context)
    } else {
      defaults.mspDeinitialize(callbacks.context)
    }
    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x0)
    return .ok

  }
  public func registerCallback(_ CallbackID: UInt32, _ pCallback: SDCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }
    var status: HALStatus = .ok

    status = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.transmitComplete, value: pCallback)
        break
      case 0x1:
        callbacks.write(.receiveComplete, value: pCallback)
        break
      case 0x2:
        callbacks.write(.error, value: pCallback)
        break
      case 0x3:
        callbacks.write(.abortComplete, value: pCallback)
        break
      case 0x4:
        callbacks.write(.readDMALinkedListBufferComplete, value: pCallback)
        break
      case 0x5:
        callbacks.write(.writeDMALinkedListBufferComplete, value: pCallback)
        break
      case 0x10:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x11:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

        status = .error
        break
      }
    } else if handle.read(.state) == 0x0 {
      switch CallbackID
      {
      case 0x10:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x11:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

        status = .error
        break
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

      status = .error
    }
    return status

  }
  public func unregisterCallback(_ CallbackID: UInt32) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }
    var status: HALStatus = .ok

    status = .ok
    if handle.read(.state) == 0x1 {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        break
      case 0x1:
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        break
      case 0x2:
        callbacks.write(.error, value: defaults.error)
        break
      case 0x3:
        callbacks.write(.abortComplete, value: defaults.abortComplete)
        break
      case 0x4:
        callbacks.write(
          .readDMALinkedListBufferComplete, value: defaults.readDMALinkedListBufferComplete)
        break
      case 0x5:
        callbacks.write(
          .writeDMALinkedListBufferComplete, value: defaults.writeDMALinkedListBufferComplete)
        break
      case 0x10:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x11:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

        status = .error
        break
      }
    } else if handle.read(.state) == 0x0 {
      switch CallbackID
      {
      case 0x10:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x11:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

        status = .error
        break
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

      status = .error
    }
    return status

  }
  public func registerTransceiverCallback(_ pCallback: SDTransceiverCallback?) -> HALStatus {
    guard useRegisteredCallbacks && useTransceiver else { return .error }
    var status: HALStatus = .ok

    status = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }

    if handle.read(.lock) == 1 { return .busy }
    handle.write(.lock, value: 1)
    if handle.read(.state) == 0x1 {
      callbacks.writeTransceiver(pCallback)
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

      status = .error
    }

    handle.write(.lock, value: 0)
    return status

  }
  public func unregisterTransceiverCallback() -> HALStatus {
    guard useRegisteredCallbacks && useTransceiver else { return .error }
    var status: HALStatus = .ok

    status = .ok

    if handle.read(.lock) == 1 { return .busy }
    handle.write(.lock, value: 1)
    if handle.read(.state) == 0x1 {
      callbacks.writeTransceiver(defaults.transceiver)
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

      status = .error
    }

    handle.write(.lock, value: 0)
    return status

  }
}
