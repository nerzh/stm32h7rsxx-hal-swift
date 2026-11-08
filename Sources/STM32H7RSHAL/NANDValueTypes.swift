// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NAND operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct NANDID: Equatable, Sendable {
  public var makerID: UInt8
  public var deviceID: UInt8
  public var thirdID: UInt8
  public var fourthID: UInt8
  public init(makerID: UInt8 = 0, deviceID: UInt8 = 0, thirdID: UInt8 = 0, fourthID: UInt8 = 0) {
    self.makerID = makerID
    self.deviceID = deviceID
    self.thirdID = thirdID
    self.fourthID = fourthID
  }
}
public struct NANDAddress: Equatable, Sendable {
  public var page: UInt16
  public var plane: UInt16
  public var block: UInt16
  public init(page: UInt16 = 0, plane: UInt16 = 0, block: UInt16 = 0) {
    self.page = page
    self.plane = plane
    self.block = block
  }
}
public struct NANDDeviceConfiguration: Equatable, Sendable {
  public var pageSize: UInt32
  public var spareAreaSize: UInt32
  public var blockSize: UInt32
  public var blockCount: UInt32
  public var planeCount: UInt32
  public var planeSize: UInt32
  public var extraCommandEnable: UInt32
  public init(
    pageSize: UInt32 = 0, spareAreaSize: UInt32 = 0, blockSize: UInt32 = 0, blockCount: UInt32 = 0,
    planeCount: UInt32 = 0, planeSize: UInt32 = 0, extraCommandEnable: UInt32 = 0
  ) {
    self.pageSize = pageSize
    self.spareAreaSize = spareAreaSize
    self.blockSize = blockSize
    self.blockCount = blockCount
    self.planeCount = planeCount
    self.planeSize = planeSize
    self.extraCommandEnable = extraCommandEnable
  }
}
