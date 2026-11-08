// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MMC {
  func initializeCardDetails(getTick: () -> UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {
    var CSD: MMCCardCSD = .init()
    var errorstate: UInt32 = 0
    var mmc_rca: UInt16 = 0
    var Init: SDMMCConfiguration = .init()

    mmc_rca = UInt16(truncatingIfNeeded: 2)

    if sdmmc.getPowerState() == 0 {
      return 0x4000000
    }

    errorstate = sdmmc.commandSendCID(getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return errorstate
    } else {
      handle.writeCardRegister(.cid, index: Int(0), value: sdmmc.getResponse(0x0))
      handle.writeCardRegister(.cid, index: Int(1), value: sdmmc.getResponse(0x4))
      handle.writeCardRegister(.cid, index: Int(2), value: sdmmc.getResponse(0x8))
      handle.writeCardRegister(.cid, index: Int(3), value: sdmmc.getResponse(0xc))
    }

    errorstate = sdmmc.commandSetRelativeAddressMMC(
      UInt16(truncatingIfNeeded: mmc_rca), getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return errorstate
    }

    handle.write(.relativeCardAddress, value: UInt32(mmc_rca))

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

    handle.write(.cardClass, value: (sdmmc.getResponse(0x4) >> 20))

    errorstate = sdmmc.commandSelectDeselect(
      UInt32(
        truncatingIfNeeded: ((UInt32(truncatingIfNeeded: handle.read(.relativeCardAddress))) << 16)),
      getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return errorstate
    }

    if getCardCSD(&CSD, getTick: getTick, getSystemCoreClock: getSystemCoreClock) != .ok {
      return handle.read(.errorCode)
    }

    errorstate = sdmmc.commandSendStatus(
      UInt32(
        truncatingIfNeeded: ((UInt32(truncatingIfNeeded: handle.read(.relativeCardAddress))) << 16)),
      getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
    }

    if getCardExtendedCSD(
      handle.extendedCSDPointer(), 0xffff_ffff, getTick: getTick,
      getSystemCoreClock: getSystemCoreClock) != .ok
    {
      return handle.read(.errorCode)
    }

    errorstate = sdmmc.commandSendStatus(
      UInt32(
        truncatingIfNeeded: ((UInt32(truncatingIfNeeded: handle.read(.relativeCardAddress))) << 16)),
      getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
    }

    Init = SDMMCConfiguration(
      clockEdge: handle.read(.clockEdge), clockPowerSave: handle.read(.clockPowerSave),
      busWide: handle.read(.busWide), hardwareFlowControl: handle.read(.hardwareFlowControl),
      clockDivider: handle.read(.clockDivider), transceiverPresent: handle.read(.transceiverPresent)
    )
    Init.busWide = 0x0
    _ = sdmmc.initialize(Init)

    return 0x0

  }
  func powerOn(getSystemCoreClock: () -> UInt32) -> UInt32 {
    var count: UInt32 = 0
    var response: UInt32 = 0
    var validvoltage: UInt32 = 0
    var errorstate: UInt32 = 0

    count = 0
    response = 0
    validvoltage = 0

    errorstate = sdmmc.commandGoIdle(getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return errorstate
    }
    while validvoltage == 0 {
      let previousCount = count
      count = count &+ 1
      if previousCount == 0xffff {
        return 0x1000000
      }

      errorstate = sdmmc.commandOperationCondition(
        (lowVoltage ? 0xc000_0080 : 0xc0ff_8000), getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        return 0x1000_0000
      }

      response = sdmmc.getResponse(0x0)

      validvoltage = (((response >> 31) == 1) ? 1 : 0)
    }

    if ((response & (0xFF00_0000)) >> 24) == 0xC0 {
      handle.write(.cardType, value: 0x1)
    } else {
      handle.write(.cardType, value: 0x0)
    }
    return 0x0

  }
  func powerOff() {

    _ = sdmmc.powerOff()

  }
}
