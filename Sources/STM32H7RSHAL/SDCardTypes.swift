// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct SDCardInfo: Equatable, Sendable {
  public var cardType: UInt32
  public var cardVersion: UInt32
  public var cardClass: UInt32
  public var relativeCardAddress: UInt32
  public var blockCount: UInt32
  public var blockSize: UInt32
  public var logicalBlockCount: UInt32
  public var logicalBlockSize: UInt32
  public var cardSpeed: UInt32
  public init(
    cardType: UInt32 = 0, cardVersion: UInt32 = 0, cardClass: UInt32 = 0,
    relativeCardAddress: UInt32 = 0, blockCount: UInt32 = 0, blockSize: UInt32 = 0,
    logicalBlockCount: UInt32 = 0, logicalBlockSize: UInt32 = 0, cardSpeed: UInt32 = 0
  ) {
    self.cardType = cardType
    self.cardVersion = cardVersion
    self.cardClass = cardClass
    self.relativeCardAddress = relativeCardAddress
    self.blockCount = blockCount
    self.blockSize = blockSize
    self.logicalBlockCount = logicalBlockCount
    self.logicalBlockSize = logicalBlockSize
    self.cardSpeed = cardSpeed
  }
}
public struct SDCardCSD: Equatable, Sendable {
  public var csdStruct: UInt8
  public var sysSpecVersion: UInt8
  public var reserved1: UInt8
  public var taac: UInt8
  public var nsac: UInt8
  public var maximumBusClockFrequency: UInt8
  public var commandClasses: UInt16
  public var rdBlockLen: UInt8
  public var partBlockRead: UInt8
  public var wrBlockMisalign: UInt8
  public var rdBlockMisalign: UInt8
  public var dsrImpl: UInt8
  public var reserved2: UInt8
  public var deviceSize: UInt32
  public var maxRdCurrentVDDMin: UInt8
  public var maxRdCurrentVDDMax: UInt8
  public var maxWrCurrentVDDMin: UInt8
  public var maxWrCurrentVDDMax: UInt8
  public var deviceSizeMul: UInt8
  public var eraseGrSize: UInt8
  public var eraseGrMul: UInt8
  public var wrProtectGrSize: UInt8
  public var wrProtectGrEnable: UInt8
  public var manDeflECC: UInt8
  public var wrSpeedFact: UInt8
  public var maxWrBlockLen: UInt8
  public var writeBlockPaPartial: UInt8
  public var reserved3: UInt8
  public var contentProtectAppli: UInt8
  public var fileFormatGroup: UInt8
  public var copyFlag: UInt8
  public var permWrProtect: UInt8
  public var tempWrProtect: UInt8
  public var fileFormat: UInt8
  public var ecc: UInt8
  public var csdCRC: UInt8
  public var reserved4: UInt8
  public init(
    csdStruct: UInt8 = 0, sysSpecVersion: UInt8 = 0, reserved1: UInt8 = 0, taac: UInt8 = 0,
    nsac: UInt8 = 0, maximumBusClockFrequency: UInt8 = 0, commandClasses: UInt16 = 0,
    rdBlockLen: UInt8 = 0, partBlockRead: UInt8 = 0, wrBlockMisalign: UInt8 = 0,
    rdBlockMisalign: UInt8 = 0, dsrImpl: UInt8 = 0, reserved2: UInt8 = 0, deviceSize: UInt32 = 0,
    maxRdCurrentVDDMin: UInt8 = 0, maxRdCurrentVDDMax: UInt8 = 0, maxWrCurrentVDDMin: UInt8 = 0,
    maxWrCurrentVDDMax: UInt8 = 0, deviceSizeMul: UInt8 = 0, eraseGrSize: UInt8 = 0,
    eraseGrMul: UInt8 = 0, wrProtectGrSize: UInt8 = 0, wrProtectGrEnable: UInt8 = 0,
    manDeflECC: UInt8 = 0, wrSpeedFact: UInt8 = 0, maxWrBlockLen: UInt8 = 0,
    writeBlockPaPartial: UInt8 = 0, reserved3: UInt8 = 0, contentProtectAppli: UInt8 = 0,
    fileFormatGroup: UInt8 = 0, copyFlag: UInt8 = 0, permWrProtect: UInt8 = 0,
    tempWrProtect: UInt8 = 0, fileFormat: UInt8 = 0, ecc: UInt8 = 0, csdCRC: UInt8 = 0,
    reserved4: UInt8 = 0
  ) {
    self.csdStruct = csdStruct
    self.sysSpecVersion = sysSpecVersion
    self.reserved1 = reserved1
    self.taac = taac
    self.nsac = nsac
    self.maximumBusClockFrequency = maximumBusClockFrequency
    self.commandClasses = commandClasses
    self.rdBlockLen = rdBlockLen
    self.partBlockRead = partBlockRead
    self.wrBlockMisalign = wrBlockMisalign
    self.rdBlockMisalign = rdBlockMisalign
    self.dsrImpl = dsrImpl
    self.reserved2 = reserved2
    self.deviceSize = deviceSize
    self.maxRdCurrentVDDMin = maxRdCurrentVDDMin
    self.maxRdCurrentVDDMax = maxRdCurrentVDDMax
    self.maxWrCurrentVDDMin = maxWrCurrentVDDMin
    self.maxWrCurrentVDDMax = maxWrCurrentVDDMax
    self.deviceSizeMul = deviceSizeMul
    self.eraseGrSize = eraseGrSize
    self.eraseGrMul = eraseGrMul
    self.wrProtectGrSize = wrProtectGrSize
    self.wrProtectGrEnable = wrProtectGrEnable
    self.manDeflECC = manDeflECC
    self.wrSpeedFact = wrSpeedFact
    self.maxWrBlockLen = maxWrBlockLen
    self.writeBlockPaPartial = writeBlockPaPartial
    self.reserved3 = reserved3
    self.contentProtectAppli = contentProtectAppli
    self.fileFormatGroup = fileFormatGroup
    self.copyFlag = copyFlag
    self.permWrProtect = permWrProtect
    self.tempWrProtect = tempWrProtect
    self.fileFormat = fileFormat
    self.ecc = ecc
    self.csdCRC = csdCRC
    self.reserved4 = reserved4
  }
}
public struct SDCardCID: Equatable, Sendable {
  public var manufacturerID: UInt8
  public var oemApplicationID: UInt16
  public var productName1: UInt32
  public var productName2: UInt8
  public var productRevision: UInt8
  public var productSerialNumber: UInt32
  public var reserved1: UInt8
  public var manufacturingDate: UInt16
  public var cidCRC: UInt8
  public var reserved2: UInt8
  public init(
    manufacturerID: UInt8 = 0, oemApplicationID: UInt16 = 0, productName1: UInt32 = 0,
    productName2: UInt8 = 0, productRevision: UInt8 = 0, productSerialNumber: UInt32 = 0,
    reserved1: UInt8 = 0, manufacturingDate: UInt16 = 0, cidCRC: UInt8 = 0, reserved2: UInt8 = 0
  ) {
    self.manufacturerID = manufacturerID
    self.oemApplicationID = oemApplicationID
    self.productName1 = productName1
    self.productName2 = productName2
    self.productRevision = productRevision
    self.productSerialNumber = productSerialNumber
    self.reserved1 = reserved1
    self.manufacturingDate = manufacturingDate
    self.cidCRC = cidCRC
    self.reserved2 = reserved2
  }
}
public struct SDCardStatus: Equatable, Sendable {
  public var dataBusWidth: UInt8
  public var securedMode: UInt8
  public var cardType: UInt16
  public var protectedAreaSize: UInt32
  public var speedClass: UInt8
  public var performanceMove: UInt8
  public var allocationUnitSize: UInt8
  public var eraseSize: UInt16
  public var eraseTimeout: UInt8
  public var eraseOffset: UInt8
  public var uhsSpeedGrade: UInt8
  public var uhsAllocationUnitSize: UInt8
  public var videoSpeedClass: UInt8
  public init(
    dataBusWidth: UInt8 = 0, securedMode: UInt8 = 0, cardType: UInt16 = 0,
    protectedAreaSize: UInt32 = 0, speedClass: UInt8 = 0, performanceMove: UInt8 = 0,
    allocationUnitSize: UInt8 = 0, eraseSize: UInt16 = 0, eraseTimeout: UInt8 = 0,
    eraseOffset: UInt8 = 0, uhsSpeedGrade: UInt8 = 0, uhsAllocationUnitSize: UInt8 = 0,
    videoSpeedClass: UInt8 = 0
  ) {
    self.dataBusWidth = dataBusWidth
    self.securedMode = securedMode
    self.cardType = cardType
    self.protectedAreaSize = protectedAreaSize
    self.speedClass = speedClass
    self.performanceMove = performanceMove
    self.allocationUnitSize = allocationUnitSize
    self.eraseSize = eraseSize
    self.eraseTimeout = eraseTimeout
    self.eraseOffset = eraseOffset
    self.uhsSpeedGrade = uhsSpeedGrade
    self.uhsAllocationUnitSize = uhsAllocationUnitSize
    self.videoSpeedClass = videoSpeedClass
  }
}
