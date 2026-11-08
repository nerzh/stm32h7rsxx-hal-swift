// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDIO {
  public func initialize(
    getSystemCoreClock: () -> UInt32, getPeripheralClockFrequency: (UInt32) -> UInt32,
    delay: (UInt32) -> Void
  ) -> HALStatus {
    var Init: SDMMCConfiguration = .init()
    var sdmmc_clk: UInt32 = 0
    var data: UInt8 = 0

    if handle.read(.state) == 0x0 {
      if useRegisteredCallbacks {
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        callbacks.write(.error, value: defaults.error)
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
    Init.clockEdge = 0x0
    Init.clockPowerSave = 0x0
    Init.busWide = 0x0
    Init.hardwareFlowControl = 0x0
    sdmmc_clk = getPeripheralClockFrequency(0x200000)
    if sdmmc_clk == 0 {
      handle.write(.errorCode, value: 0x8000000)
      return .error
    }
    Init.clockDivider = sdmmc_clk / (2 &* 0x61a80)

    _ = sdmmc.initialize(Init)

    _ = sdmmc.powerOn()

    if Init.clockDivider != 0 {
      sdmmc_clk = sdmmc_clk / (2 &* Init.clockDivider)
    }
    if sdmmc_clk != 0 {
      delay(1 &+ (74 &* 1000 / (sdmmc_clk)))
    }
    if case .none = callbacks.readIdentify() {
      callbacks.writeIdentify(.initializeCard)
    }
    if identifyCard(getSystemCoreClock: getSystemCoreClock, delay: delay) != 0 {
      handle.write(.state, value: 0x0)
      return .error
    }

    Init.clockEdge = handle.read(.clockEdge)
    Init.clockPowerSave = handle.read(.clockPowerSave)
    Init.busWide = handle.read(.busWide)
    Init.hardwareFlowControl = handle.read(.hardwareFlowControl)
    Init.clockDivider = handle.read(.clockDivider)
    _ = sdmmc.initialize(Init)
    data = UInt8(truncatingIfNeeded: (handle.read(.busWide) == 0x1) ? 2 : 0)
    if writeDirectByte(0x7, 0x0, 0x0, &data, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }
    handle.write(.transferContext, value: 0x0)
    handle.write(.state, value: 0x1)
    return .ok

  }
  public func deinitialize() -> HALStatus {

    _ = sdmmc.powerOff()
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
  public func setDataBusWidth(_ BusWide: UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus {
    var data: UInt8 = 0
    var error_state: HALStatus = .ok

    error_state = .ok

    if handle.read(.state) == 0x1 {
      data = UInt8(truncatingIfNeeded: (BusWide == 0x1) ? 2 : 0)
      registers.write(
        .clkcr, value: ((registers.read(.clkcr) & ~(0xc000)) | ((BusWide == 0x1) ? 0x4000 : 0x0)))
      if writeDirectByte(0x7, 0x0, 0x0, &data, getSystemCoreClock: getSystemCoreClock) != .ok {
        error_state = .error
      }
    } else {
      error_state = .error
    }
    return error_state

  }
  public func configureFrequency(
    _ ClockSpeed: UInt32, getPeripheralClockFrequency: (UInt32) -> UInt32
  ) -> HALStatus {
    var ClockDiv: UInt32 = 0

    if handle.read(.state) == 0x1 {
      ClockDiv = (getPeripheralClockFrequency(0x200000)) / (2 &* ClockSpeed)
      registers.write(.clkcr, value: ((registers.read(.clkcr) & ~(0x3ff)) | (ClockDiv)))
    } else {
      return .error
    }
    return .ok

  }
  public func setBlockSize(
    _ function_nbr: UInt8, _ BlockSize: UInt16, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var BlockSize = BlockSize
    var cmd53: SDIOExtendedCommand = .init()

    cmd53.ioFunctionNumber = 0x0
    cmd53.operationCode = 0x1
    cmd53.blockMode = 0x0
    cmd53.registerAddress = (UInt32(UInt32(function_nbr)) &* 0x100) &+ 0x10
    if withUnsafeMutableBytes(
      of: &BlockSize,
      { bytes in
        writeExtendedBlock(
          &cmd53, bytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
          UInt16(truncatingIfNeeded: 2), getTick: getTick, getSystemCoreClock: getSystemCoreClock)
      }) != .ok
    {
      return .error
    }
    handle.write(.blockSize, value: UInt16(truncatingIfNeeded: UInt32(UInt32(BlockSize))))
    return .ok

  }
  public func setSpeedMode(_ DataRate: UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus {
    var errorstate: HALStatus = .ok
    var data: UInt8 = 0

    errorstate = .ok

    switch DataRate
    {
    case 0x1:
      data = UInt8(truncatingIfNeeded: 0x2)
      errorstate = writeDirectByte(0x13, 0x0, 0x0, &data, getSystemCoreClock: getSystemCoreClock)
      break
    case 0x2:
      data = UInt8(truncatingIfNeeded: 0x4)
      errorstate = writeDirectByte(
        ((0x0 << 2) | (0x0 << 1) | (0x0 << 14)
          | 0x13), 0x0, 0x0, &data, getSystemCoreClock: getSystemCoreClock)
      registers.write(.clkcr, value: ((registers.read(.clkcr) & ~(0x80000)) | (0x80000)))
      break
    case 0x3:
      data = UInt8(truncatingIfNeeded: 0x8)
      errorstate = writeDirectByte(
        ((0x0 << 2) | (0x0 << 1) | (0x0 << 14) | 0x13), 0x0, 0x0, &data,
        getSystemCoreClock: getSystemCoreClock)
      registers.write(
        .clkcr, value: ((registers.read(.clkcr) & ~(0x40000 | 0x80000)) | (0x40000 | 0x80000)))
      break
    default:
      break
    }
    return (errorstate != .ok) ? .error : .ok

  }
  public func resetCard(getSystemCoreClock: () -> UInt32) -> HALStatus {
    var data: UInt8 = 0

    data = UInt8(truncatingIfNeeded: 0)

    if writeDirectByte(
      ((0x0 << 2) | (0x0 << 1) | (0x0 << 14) | 0x6), 0x0, 0, &data,
      getSystemCoreClock: getSystemCoreClock) != .ok
    {
      return .error
    }
    handle.write(.state, value: 0x0)
    return .ok

  }
  public func registerCallback(_ CallbackID: UInt32, _ pCallback: SDIOCallback?) -> HALStatus {
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
  public func registerTransceiverCallback(_ pCallback: SDIOTransceiverCallback?) -> HALStatus {
    guard useTransceiver else { return .error }
    var status: HALStatus = .ok

    status = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      callbacks.writeTransceiver(pCallback)
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

      status = .error
    }
    return status

  }
  public func unregisterTransceiverCallback() -> HALStatus {
    guard useTransceiver else { return .error }
    var status: HALStatus = .ok

    status = .ok
    if handle.read(.state) == 0x1 {
      callbacks.writeTransceiver(defaults.transceiver)
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))

      status = .error
    }
    return status

  }
  public func registerIdentifyCardCallback(_ pCallback: SDIOIdentifyCallback?) -> HALStatus {

    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    callbacks.writeIdentify(.custom(pCallback!))
    return .ok

  }
}
