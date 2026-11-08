// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MMC {
  public func initialize(
    getTick: () -> UInt32, getSystemCoreClock: () -> UInt32,
    getPeripheralClockFrequency: (UInt32) -> UInt32, delay: (UInt32) -> Void
  ) -> HALStatus {

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0)
      if useRegisteredCallbacks {
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        callbacks.write(.error, value: defaults.error)
        callbacks.write(.abortComplete, value: defaults.abortComplete)
        callbacks.write(
          .readDMALinkedListBufferComplete, value: defaults.readDMALinkedListBufferComplete)
        callbacks.write(
          .writeDMALinkedListBufferComplete, value: defaults.writeDMALinkedListBufferComplete)
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }

        callbacks.read(.mspInitialize)!(callbacks.context)
      } else {
        defaults.mspInitialize(callbacks.context)
      }
    }
    handle.write(.state, value: 0x3)

    if initializeCard(
      getTick: getTick, getSystemCoreClock: getSystemCoreClock,
      getPeripheralClockFrequency: getPeripheralClockFrequency, delay: delay) == .error
    {
      return .error
    }

    handle.write(.errorCode, value: 0x0)

    handle.write(.transferContext, value: 0x0)

    handle.write(.state, value: 0x1)

    if handle.read(.busWide) != 0x0 {
      if configureWideBus(
        handle.read(.busWide), getTick: getTick, getSystemCoreClock: getSystemCoreClock) != .ok
      {
        return .error
      }
    }
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
    if useSDTransceiver {
      Init.transceiverPresent = 0x1
    }

    _ = sdmmc.initialize(Init)

    _ = sdmmc.powerOn()

    if Init.clockDivider != 0 {
      sdmmc_clk = sdmmc_clk / (2 &* Init.clockDivider)
    }
    if sdmmc_clk != 0 {
      delay(1 &+ (74 &* 1000 / (sdmmc_clk)))
    }

    errorstate = powerOn(getSystemCoreClock: getSystemCoreClock)
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
  public func registerCallback(_ CallbackId: UInt32, _ pCallback: MMCCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }
    var status: HALStatus = .ok

    status = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      switch CallbackId
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
      switch CallbackId
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
  public func unregisterCallback(_ CallbackId: UInt32) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }
    var status: HALStatus = .ok

    status = .ok
    if handle.read(.state) == 0x1 {
      switch CallbackId
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
      switch CallbackId
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
}
