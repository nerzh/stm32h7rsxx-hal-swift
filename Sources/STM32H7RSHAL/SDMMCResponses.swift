// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDMMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDMMC {
  public func getCommandResponse1(
    _ SD_CMD: UInt8, _ Timeout: UInt32, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    let SD_CMD = UInt32(SD_CMD)

    var response_r1: UInt32
    var sta_reg: UInt32

    var count: UInt32 = Timeout &* (getSystemCoreClock() / 8 / 1000)
    repeat {
      let previousCount = count
      count &-= 1
      if previousCount == 0 {
        return 0x8000_0000
      }
      sta_reg = registers.read(.sta)
    } while ((sta_reg & (0x1 | 0x40 | 0x4 | 0x200000)) == 0) || ((sta_reg & 0x2000) != 0)
    if getFlag(0x4) {
      clearFlag(0x4)
      return 0x4
    } else if getFlag(0x1) {
      clearFlag(0x1)
      return 0x1
    } else {
    }

    clearFlag(0x2000c5)

    if UInt32(getCommandResponse()) != SD_CMD {
      return 0x1
    }

    response_r1 = getResponse(0x0)
    if (response_r1 & 0xfdff_e008) == 0x0 {
      return 0x0
    } else if (response_r1 & 0x8000_0000) == 0x8000_0000 {
      return 0x2000000
    } else if (response_r1 & 0x4000_0000) == 0x4000_0000 {
      return 0x40
    } else if (response_r1 & 0x2000_0000) == 0x2000_0000 {
      return 0x80
    } else if (response_r1 & 0x1000_0000) == 0x1000_0000 {
      return 0x100
    } else if (response_r1 & 0x8000000) == 0x8000000 {
      return 0x200
    } else if (response_r1 & 0x4000000) == 0x4000000 {
      return 0x400
    } else if (response_r1 & 0x1000000) == 0x1000000 {
      return 0x800
    } else if (response_r1 & 0x800000) == 0x800000 {
      return 0x1000
    } else if (response_r1 & 0x400000) == 0x400000 {
      return 0x2000
    } else if (response_r1 & 0x200000) == 0x200000 {
      return 0x4000
    } else if (response_r1 & 0x100000) == 0x100000 {
      return 0x8000
    } else if (response_r1 & 0x40000) == 0x40000 {
      return 0x20000
    } else if (response_r1 & 0x20000) == 0x20000 {
      return 0x40000
    } else if (response_r1 & 0x10000) == 0x10000 {
      return 0x80000
    } else if (response_r1 & 0x8000) == 0x8000 {
      return 0x100000
    } else if (response_r1 & 0x4000) == 0x4000 {
      return 0x200000
    } else if (response_r1 & 0x2000) == 0x2000 {
      return 0x400000
    } else if (response_r1 & 0x8) == 0x8 {
      return 0x800000
    } else {
      return 0x10000
    }

  }
  public func getCommandResponse2(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sta_reg: UInt32

    var count: UInt32 = 0x1388 &* (getSystemCoreClock() / 8 / 1000)
    repeat {
      let previousCount = count
      count &-= 1
      if previousCount == 0 {
        return 0x8000_0000
      }
      sta_reg = registers.read(.sta)
    } while ((sta_reg & (0x1 | 0x40 | 0x4)) == 0) || ((sta_reg & 0x2000) != 0)
    if getFlag(0x4) {
      clearFlag(0x4)
      return 0x4
    } else if getFlag(0x1) {
      clearFlag(0x1)
      return 0x1
    } else {

      clearFlag(0x2000c5)
    }
    return 0x0

  }
  public func getCommandResponse3(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sta_reg: UInt32

    var count: UInt32 = 0x1388 &* (getSystemCoreClock() / 8 / 1000)
    repeat {
      let previousCount = count
      count &-= 1
      if previousCount == 0 {
        return 0x8000_0000
      }
      sta_reg = registers.read(.sta)
    } while ((sta_reg & (0x1 | 0x40 | 0x4)) == 0) || ((sta_reg & 0x2000) != 0)
    if getFlag(0x4) {
      clearFlag(0x4)
      return 0x4
    } else {
      clearFlag(0x2000c5)
    }
    return 0x0

  }
  public func getCommandResponse4(
    _ pResp: UnsafeMutablePointer<UInt32>?, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {

    var sta_reg: UInt32

    var count: UInt32 = 0x1388 &* (getSystemCoreClock() / 8 / 1000)
    repeat {
      let previousCount = count
      count &-= 1
      if previousCount == 0 {
        return 0x8000_0000
      }
      sta_reg = registers.read(.sta)
    } while ((sta_reg & (0x1 | 0x40 | 0x4)) == 0) || ((sta_reg & 0x2000) != 0)
    if getFlag(0x4) {
      clearFlag(0x4)
      return 0x4
    } else {
      clearFlag(0x2000c5)
    }

    clearFlag(0x2000c5)

    pResp!.pointee = getResponse(0x0)
    return 0x0

  }
  public func getCommandResponse5(
    _ SDIO_CMD: UInt8, _ pData: UnsafeMutablePointer<UInt8>?, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    let SDIO_CMD = UInt32(SDIO_CMD)

    var response_r5: UInt32
    var sta_reg: UInt32

    var count: UInt32 = 0x1388 &* (getSystemCoreClock() / 8 / 1000)
    repeat {
      let previousCount = count
      count &-= 1
      if previousCount == 0 {
        return 0x8000_0000
      }
      sta_reg = registers.read(.sta)
    } while ((sta_reg & (0x1 | 0x40 | 0x4)) == 0) || ((sta_reg & 0x2000) != 0)
    if getFlag(0x4) {
      clearFlag(0x4)
      return 0x4
    } else if getFlag(0x1) {
      clearFlag(0x1)
      return 0x1
    } else {
    }

    if UInt32(getCommandResponse()) != SDIO_CMD {
      return 0x1
    }

    clearFlag(0x2000c5)

    response_r5 = getResponse(0x0)
    if (response_r5 & 0xcb00) == 0x0 {
      if pData != nil {
        pData!.pointee = UInt8(
          truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (response_r5 & 0xFF))))
      }
      return 0x0
    } else if (response_r5 & 0x100) == 0x100 {
      return 0x2000000
    } else if (response_r5 & 0x200) == 0x200 {
      return 0x8000000
    } else if (response_r5 & 0x4000) == 0x4000 {
      return 0x2000
    } else if (response_r5 & 0x8000) == 0x8000 {
      return 0x1000
    } else {
      return 0x10000
    }

  }
  public func getCommandResponse6(
    _ SD_CMD: UInt8, _ pRCA: UnsafeMutablePointer<UInt16>?, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {
    let SD_CMD = UInt32(SD_CMD)

    var response_r1: UInt32
    var sta_reg: UInt32

    var count: UInt32 = 0x1388 &* (getSystemCoreClock() / 8 / 1000)
    repeat {
      let previousCount = count
      count &-= 1
      if previousCount == 0 {
        return 0x8000_0000
      }
      sta_reg = registers.read(.sta)
    } while ((sta_reg & (0x1 | 0x40 | 0x4)) == 0) || ((sta_reg & 0x2000) != 0)
    if getFlag(0x4) {
      clearFlag(0x4)
      return 0x4
    } else if getFlag(0x1) {
      clearFlag(0x1)
      return 0x1
    } else {
    }

    if UInt32(getCommandResponse()) != SD_CMD {
      return 0x1
    }

    clearFlag(0x2000c5)

    response_r1 = getResponse(0x0)
    if (response_r1 & (0x2000 | 0x4000 | 0x8000)) == 0x0 {
      pRCA!.pointee = UInt16(
        truncatingIfNeeded: UInt32(UInt16(truncatingIfNeeded: (response_r1 >> 16))))
      return 0x0
    } else if (response_r1 & 0x4000) == 0x4000 {
      return 0x2000
    } else if (response_r1 & 0x8000) == 0x8000 {
      return 0x1000
    } else {
      return 0x10000
    }

  }
  public func getCommandResponse7(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sta_reg: UInt32

    var count: UInt32 = 0x1388 &* (getSystemCoreClock() / 8 / 1000)
    repeat {
      let previousCount = count
      count &-= 1
      if previousCount == 0 {
        return 0x8000_0000
      }
      sta_reg = registers.read(.sta)
    } while ((sta_reg & (0x1 | 0x40 | 0x4)) == 0) || ((sta_reg & 0x2000) != 0)
    if getFlag(0x4) {
      clearFlag(0x4)
      return 0x4
    } else if getFlag(0x1) {
      clearFlag(0x1)
      return 0x1
    } else {
    }
    if getFlag(0x40) {
      clearFlag(0x40)
    }
    return 0x0

  }
  func getCommandError(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var count: UInt32 = 0x1388 &* (getSystemCoreClock() / 8 / 1000)
    repeat {
      let previousCount = count
      count &-= 1
      if previousCount == 0 {
        return 0x8000_0000
      }
    } while !getFlag(0x80)

    clearFlag(0x2000c5)
    return 0x0

  }
}
