// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SD {
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
  public func getCardCID(_ pCID: UnsafeMutablePointer<SDCardCID>?) -> HALStatus {

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
  public func getCardCSD(_ pCSD: UnsafeMutablePointer<SDCardCSD>?) -> HALStatus {

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
      pCSD!.pointee.deviceSize =
        (((handle.readCardRegister(.csd, index: Int(1)) & 0x0000_003F) << 16)
          | ((handle.readCardRegister(.csd, index: Int(2)) & 0xFFFF_0000) >> 16))
      handle.write(.blockCount, value: ((pCSD!.pointee.deviceSize &+ 1) &* 1024))
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
  public func getCardStatus(
    _ pStatus: UnsafeMutablePointer<SDCardStatus>?, getTick: () -> UInt32,
    getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    return withUnsafeTemporaryAllocation(of: UInt32.self, capacity: 16) { sd_status in
      sd_status.initialize(repeating: 0)
      var errorstate: UInt32 = 0
      var status: HALStatus = .ok

      status = .ok
      if handle.read(.state) == 0x3 {
        return .error
      }
      errorstate = sendSDStatus(
        sd_status.baseAddress, getTick: getTick, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
        handle.write(.state, value: 0x1)
        status = .error
      } else {
        pStatus!.pointee.dataBusWidth = UInt8(
          truncatingIfNeeded: UInt32(
            UInt8(truncatingIfNeeded: ((sd_status[Int(Int(0))] & 0xC0) >> 6))))
        pStatus!.pointee.securedMode = UInt8(
          truncatingIfNeeded: UInt32(
            UInt8(truncatingIfNeeded: ((sd_status[Int(Int(0))] & 0x20) >> 5))))
        pStatus!.pointee.cardType = UInt16(
          truncatingIfNeeded: UInt32(
            UInt16(
              truncatingIfNeeded: (((sd_status[Int(Int(0))] & 0x00FF_0000) >> 8)
                | ((sd_status[Int(Int(0))] & 0xFF00_0000) >> 24)))))
        pStatus!.pointee.protectedAreaSize =
          (((sd_status[Int(Int(1))] & 0xFF) << 24) | ((sd_status[Int(Int(1))] & 0xFF00) << 8)
            | ((sd_status[Int(Int(1))] & 0xFF0000) >> 8)
            | ((sd_status[Int(Int(1))] & 0xFF00_0000) >> 24))
        pStatus!.pointee.speedClass = UInt8(
          truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (sd_status[Int(Int(2))] & 0xFF))))
        pStatus!.pointee.performanceMove = UInt8(
          truncatingIfNeeded: UInt32(
            UInt8(truncatingIfNeeded: ((sd_status[Int(Int(2))] & 0xFF00) >> 8))))
        pStatus!.pointee.allocationUnitSize = UInt8(
          truncatingIfNeeded: UInt32(
            UInt8(truncatingIfNeeded: ((sd_status[Int(Int(2))] & 0xF00000) >> 20))))
        pStatus!.pointee.eraseSize = UInt16(
          truncatingIfNeeded: UInt32(
            UInt16(
              truncatingIfNeeded: (((sd_status[Int(Int(2))] & 0xFF00_0000) >> 16)
                | (sd_status[Int(Int(3))] & 0xFF)))))
        pStatus!.pointee.eraseTimeout = UInt8(
          truncatingIfNeeded: UInt32(
            UInt8(truncatingIfNeeded: ((sd_status[Int(Int(3))] & 0xFC00) >> 10))))
        pStatus!.pointee.eraseOffset = UInt8(
          truncatingIfNeeded: UInt32(
            UInt8(truncatingIfNeeded: ((sd_status[Int(Int(3))] & 0x0300) >> 8))))
        pStatus!.pointee.uhsSpeedGrade = UInt8(
          truncatingIfNeeded: UInt32(
            UInt8(truncatingIfNeeded: ((sd_status[Int(Int(3))] & 0x00F0) >> 4))))
        pStatus!.pointee.uhsAllocationUnitSize = UInt8(
          truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (sd_status[Int(Int(3))] & 0x000F))))
        pStatus!.pointee.videoSpeedClass = UInt8(
          truncatingIfNeeded: UInt32(
            UInt8(truncatingIfNeeded: ((sd_status[Int(Int(4))] & 0xFF00_0000) >> 24))))
      }

      errorstate = sdmmc.commandBlockLength(0x200, getSystemCoreClock: getSystemCoreClock)
      if errorstate != 0x0 {
        sdmmc.clearFlag(0x1fe0_0fff)
        handle.write(.errorCode, value: errorstate)
        handle.write(.state, value: 0x1)
        status = .error
      }
      return status

    }
  }
  public func getCardInfo(_ pCardInfo: UnsafeMutablePointer<SDCardInfo>?) -> HALStatus {

    pCardInfo!.pointee.cardType = UInt32(truncatingIfNeeded: (handle.read(.cardType)))
    pCardInfo!.pointee.cardVersion = UInt32(truncatingIfNeeded: (handle.read(.cardVersion)))
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
}
