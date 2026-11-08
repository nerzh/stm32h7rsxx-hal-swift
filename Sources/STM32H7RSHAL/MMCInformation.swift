// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MMC {
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
  public func getCardCID(_ pCID: UnsafeMutablePointer<MMCCardCID>?) -> HALStatus {

    pCID!.pointee.manufacturerID = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.cid, index: Int(0)) & 0xFF00_0000) >> 24)))
    )
    pCID!.pointee.oemApplicationID = UInt16(
      truncatingIfNeeded: UInt32(
        UInt16(
          truncatingIfNeeded: ((handle.readCardRegister(.cid, index: Int(0)) & 0x00FF_FF00) >> 8))))
    pCID!.pointee.productName1 =
      (((handle.readCardRegister(.cid, index: Int(0)) & 0x0000_00FF) << 24)
        | ((handle.readCardRegister(.cid, index: Int(1)) & 0xFFFF_FF00) >> 8))
    pCID!.pointee.productName2 = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(truncatingIfNeeded: (handle.readCardRegister(.cid, index: Int(1)) & 0x0000_00FF))))
    pCID!.pointee.productRevision = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.cid, index: Int(2)) & 0xFF00_0000) >> 24)))
    )
    pCID!.pointee.productSerialNumber =
      (((handle.readCardRegister(.cid, index: Int(2)) & 0x00FF_FFFF) << 8)
        | ((handle.readCardRegister(.cid, index: Int(3)) & 0xFF00_0000) >> 24))
    pCID!.pointee.reserved1 = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.cid, index: Int(3)) & 0x00F0_0000) >> 20)))
    )
    pCID!.pointee.manufacturingDate = UInt16(
      truncatingIfNeeded: UInt32(
        UInt16(
          truncatingIfNeeded: ((handle.readCardRegister(.cid, index: Int(3)) & 0x000F_FF00) >> 8))))
    pCID!.pointee.cidCRC = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.cid, index: Int(3)) & 0x0000_00FE) >> 1))))
    pCID!.pointee.reserved2 = UInt8(truncatingIfNeeded: 1)
    return .ok

  }
  public func getCardCSD(
    _ pCSD: UnsafeMutablePointer<MMCCardCSD>?, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var block_nbr: UInt32 = 0

    block_nbr = 0
    pCSD!.pointee.csdStruct = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(0)) & 0xC000_0000) >> 30)))
    )
    pCSD!.pointee.sysSpecVersion = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(0)) & 0x3C00_0000) >> 26)))
    )
    pCSD!.pointee.reserved1 = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(0)) & 0x0300_0000) >> 24)))
    )
    pCSD!.pointee.taac = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(0)) & 0x00FF_0000) >> 16)))
    )
    pCSD!.pointee.nsac = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(0)) & 0x0000_FF00) >> 8))))
    pCSD!.pointee.maximumBusClockFrequency = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(truncatingIfNeeded: (handle.readCardRegister(.csd, index: Int(0)) & 0x0000_00FF))))
    pCSD!.pointee.commandClasses = UInt16(
      truncatingIfNeeded: UInt32(
        UInt16(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(1)) & 0xFFF0_0000) >> 20)))
    )
    pCSD!.pointee.rdBlockLen = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(1)) & 0x000F_0000) >> 16)))
    )
    pCSD!.pointee.partBlockRead = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(1)) & 0x0000_8000) >> 15)))
    )
    pCSD!.pointee.wrBlockMisalign = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(1)) & 0x0000_4000) >> 14)))
    )
    pCSD!.pointee.rdBlockMisalign = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(1)) & 0x0000_2000) >> 13)))
    )
    pCSD!.pointee.dsrImpl = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(1)) & 0x0000_1000) >> 12)))
    )
    pCSD!.pointee.reserved2 = UInt8(truncatingIfNeeded: 0)
    if readExtendedCSDField(
      &block_nbr, UInt16(truncatingIfNeeded: 212), 0x0FFF_FFFF, getTick: getTick,
      getSystemCoreClock: getSystemCoreClock) != .ok
    {
      return .error
    }
    if handle.read(.cardType) == 0x0 {
      pCSD!.pointee.deviceSize =
        (((handle.readCardRegister(.csd, index: Int(1)) & 0x0000_03FF) << 2)
          | ((handle.readCardRegister(.csd, index: Int(2)) & 0xC000_0000) >> 30))
      pCSD!.pointee.maxRdCurrentVDDMin = UInt8(
        truncatingIfNeeded: UInt32(
          UInt8(
            truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(2)) & 0x3800_0000) >> 27)
          )))
      pCSD!.pointee.maxRdCurrentVDDMax = UInt8(
        truncatingIfNeeded: UInt32(
          UInt8(
            truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(2)) & 0x0700_0000) >> 24)
          )))
      pCSD!.pointee.maxWrCurrentVDDMin = UInt8(
        truncatingIfNeeded: UInt32(
          UInt8(
            truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(2)) & 0x00E0_0000) >> 21)
          )))
      pCSD!.pointee.maxWrCurrentVDDMax = UInt8(
        truncatingIfNeeded: UInt32(
          UInt8(
            truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(2)) & 0x001C_0000) >> 18)
          )))
      pCSD!.pointee.deviceSizeMul = UInt8(
        truncatingIfNeeded: UInt32(
          UInt8(
            truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(2)) & 0x0003_8000) >> 15)
          )))
      handle.write(.blockCount, value: (pCSD!.pointee.deviceSize &+ 1))
      handle.write(
        .blockCount,
        value: handle.read(.blockCount)
          &* ((1 << ((UInt32(pCSD!.pointee.deviceSizeMul) & 0x07) &+ 2))))
      handle.write(.blockSize, value: (1 << (UInt32(pCSD!.pointee.rdBlockLen) & 0x0F)))
      handle.write(
        .logicalBlockCount, value: (handle.read(.blockCount)) &* ((handle.read(.blockSize)) / 0x200)
      )
      handle.write(.logicalBlockSize, value: 0x200)
    } else if handle.read(.cardType) == 0x1 {
      handle.write(.blockCount, value: block_nbr)
      handle.write(.logicalBlockCount, value: handle.read(.blockCount))
      handle.write(.blockSize, value: 0x200)
      handle.write(.logicalBlockSize, value: handle.read(.blockSize))
    } else {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000_0000))
      handle.write(.state, value: 0x1)
      return .error
    }
    pCSD!.pointee.eraseGrSize = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(2)) & 0x0000_4000) >> 14)))
    )
    pCSD!.pointee.eraseGrMul = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(2)) & 0x0000_3F80) >> 7))))
    pCSD!.pointee.wrProtectGrSize = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(truncatingIfNeeded: (handle.readCardRegister(.csd, index: Int(2)) & 0x0000_007F))))
    pCSD!.pointee.wrProtectGrEnable = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x8000_0000) >> 31)))
    )
    pCSD!.pointee.manDeflECC = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x6000_0000) >> 29)))
    )
    pCSD!.pointee.wrSpeedFact = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x1C00_0000) >> 26)))
    )
    pCSD!.pointee.maxWrBlockLen = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x03C0_0000) >> 22)))
    )
    pCSD!.pointee.writeBlockPaPartial = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0020_0000) >> 21)))
    )
    pCSD!.pointee.reserved3 = UInt8(truncatingIfNeeded: 0)
    pCSD!.pointee.contentProtectAppli = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0001_0000) >> 16)))
    )
    pCSD!.pointee.fileFormatGroup = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0000_8000) >> 15)))
    )
    pCSD!.pointee.copyFlag = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0000_4000) >> 14)))
    )
    pCSD!.pointee.permWrProtect = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0000_2000) >> 13)))
    )
    pCSD!.pointee.tempWrProtect = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0000_1000) >> 12)))
    )
    pCSD!.pointee.fileFormat = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0000_0C00) >> 10)))
    )
    pCSD!.pointee.ecc = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0000_0300) >> 8))))
    pCSD!.pointee.csdCRC = UInt8(
      truncatingIfNeeded: UInt32(
        UInt8(
          truncatingIfNeeded: ((handle.readCardRegister(.csd, index: Int(3)) & 0x0000_00FE) >> 1))))
    pCSD!.pointee.reserved4 = UInt8(truncatingIfNeeded: 1)
    return .ok

  }
  public func getCardInfo(_ pCardInfo: UnsafeMutablePointer<MMCCardInfo>?) -> HALStatus {

    pCardInfo!.pointee.cardType = UInt32(truncatingIfNeeded: (handle.read(.cardType)))
    pCardInfo!.pointee.cardClass = UInt32(truncatingIfNeeded: (handle.read(.cardClass)))
    pCardInfo!.pointee.relativeCardAddress = UInt32(
      truncatingIfNeeded: (handle.read(.relativeCardAddress)))
    pCardInfo!.pointee.blockCount = UInt32(truncatingIfNeeded: (handle.read(.blockCount)))
    pCardInfo!.pointee.blockSize = UInt32(truncatingIfNeeded: (handle.read(.blockSize)))
    pCardInfo!.pointee.logicalBlockCount = UInt32(
      truncatingIfNeeded: (handle.read(.logicalBlockCount)))
    pCardInfo!.pointee.logicalBlockSize = UInt32(
      truncatingIfNeeded: (handle.read(.logicalBlockSize)))
    return .ok

  }
  public func getCardExtendedCSD(
    _ pExtCSD: UnsafeMutablePointer<UInt32>?, _ Timeout: UInt32, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0
    var count: UInt32 = 0
    var tmp_buf: UnsafeMutablePointer<UInt32>? = nil

    tickstart = getTick()

    if nil == pExtCSD {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000000))
      return .error
    }
    if handle.read(.state) == 0x1 {
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x3)

      registers.write(.dctrl, value: 0)

      tmp_buf = pExtCSD

      config.dataTimeout = 0xffff_ffff
      config.dataLength = 0x200
      config.dataBlockSize = 0x90
      config.transferDirection = 0x2
      config.transferMode = 0x0
      config.dpsm = 0x0
      _ = sdmmc.configureData(&config)
      sdmmc.enableCommandTransfer()

      errorstate = sdmmc.commandSendExtendedCSD(0, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        return .error
      }

      while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
        if sdmmc.getFlag(0x8000) {
          count = 0
          while count < (0x20 / 4) {
            tmp_buf!.pointee = sdmmc.readFIFO()
            tmp_buf = tmp_buf!.advanced(by: Int(1))
            count = count &+ (1)
          }
        }
        if ((getTick() &- tickstart) >= Timeout) || (Timeout == 0) {
          sdmmc.clearFlag(0x1fe0_0fff)
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000_0000))
          handle.write(.state, value: 0x1)
          return .timeout
        }
      }
      sdmmc.disableCommandTransfer()

      if sdmmc.getFlag(0x8) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
        handle.write(.state, value: 0x1)
        return .error
      } else if sdmmc.getFlag(0x2) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
        handle.write(.state, value: 0x1)
        return .error
      } else if sdmmc.getFlag(0x20) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        handle.write(.state, value: 0x1)
        return .error
      } else {
      }

      sdmmc.clearFlag(0x1800_0f3a)
      handle.write(.state, value: 0x1)
    }
    return .ok

  }
  public func getCardState(getSystemCoreClock: () -> UInt32) -> UInt32 {
    var cardstate: UInt32 = 0
    var errorstate: UInt32 = 0
    var resp1: UInt32 = 0

    resp1 = 0
    errorstate = sendStatus(&resp1, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
    }
    cardstate = ((resp1 >> 9) & 0x0F)
    return UInt32(truncatingIfNeeded: cardstate)

  }
  func sendStatus(_ pCardStatus: UnsafeMutablePointer<UInt32>?, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {
    var errorstate: UInt32 = 0

    if pCardStatus == nil {
      return 0x8000000
    }

    errorstate = sdmmc.commandSendStatus(
      UInt32(truncatingIfNeeded: (handle.read(.relativeCardAddress) << 16)),
      getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      return errorstate
    }

    pCardStatus!.pointee = sdmmc.getResponse(0x0)
    return 0x0

  }
  func readExtendedCSDField(
    _ pFieldData: UnsafeMutablePointer<UInt32>?, _ FieldIndex: UInt16, _ Timeout: UInt32,
    getTick: () -> UInt32, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    let FieldIndex = UInt32(FieldIndex)
    var config: SDMMCDataConfiguration = .init()
    var errorstate: UInt32 = 0
    var tickstart: UInt32 = 0
    var count: UInt32 = 0
    var i: UInt32 = 0
    var tmp_data: UInt32 = 0

    tickstart = getTick()

    i = 0

    handle.write(.errorCode, value: 0x0)

    registers.write(.dctrl, value: 0)

    config.dataTimeout = 0xffff_ffff
    config.dataLength = 0x200
    config.dataBlockSize = 0x90
    config.transferDirection = 0x2
    config.transferMode = 0x0
    config.dpsm = 0x1
    _ = sdmmc.configureData(&config)

    errorstate = sdmmc.commandSendExtendedCSD(0, getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
      handle.write(.state, value: 0x1)
      return .error
    }

    while !sdmmc.getFlag(0x20 | 0x2 | 0x8 | 0x100) {
      if sdmmc.getFlag(0x8000) {
        count = 0
        while count < (0x20 / 4) {
          tmp_data = sdmmc.readFIFO()

          if (i &+ count) == (UInt32(truncatingIfNeeded: FieldIndex) / 4) {
            pFieldData!.pointee = tmp_data
          }
          count = count &+ (1)
        }
        i = i &+ (8)
      }
      if ((getTick() &- tickstart) >= Timeout) || (Timeout == 0) {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8000_0000))
        handle.write(.state, value: 0x1)
        return .timeout
      }
    }

    if sdmmc.getFlag(0x8) {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      handle.write(.state, value: 0x1)
      return .error
    } else if sdmmc.getFlag(0x2) {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
      handle.write(.state, value: 0x1)
      return .error
    } else if sdmmc.getFlag(0x20) {
      sdmmc.clearFlag(0x1fe0_0fff)
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
      handle.write(.state, value: 0x1)
      return .error
    } else {
    }

    errorstate = sdmmc.commandSendStatus(
      UInt32(
        truncatingIfNeeded: ((UInt32(truncatingIfNeeded: handle.read(.relativeCardAddress))) << 16)),
      getSystemCoreClock: getSystemCoreClock)
    if errorstate != 0x0 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
    }

    sdmmc.clearFlag(0x1800_0f3a)
    handle.write(.state, value: 0x1)
    return .ok

  }
}
