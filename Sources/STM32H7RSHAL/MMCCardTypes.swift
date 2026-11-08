// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MMC/MMCEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct MMCCardInfo: Equatable, Sendable {
  public var cardType: UInt32
  public var cardClass: UInt32
  public var relativeCardAddress: UInt32
  public var blockCount: UInt32
  public var blockSize: UInt32
  public var logicalBlockCount: UInt32
  public var logicalBlockSize: UInt32
  public init(
    cardType: UInt32 = 0, cardClass: UInt32 = 0, relativeCardAddress: UInt32 = 0,
    blockCount: UInt32 = 0, blockSize: UInt32 = 0, logicalBlockCount: UInt32 = 0,
    logicalBlockSize: UInt32 = 0
  ) {
    self.cardType = cardType
    self.cardClass = cardClass
    self.relativeCardAddress = relativeCardAddress
    self.blockCount = blockCount
    self.blockSize = blockSize
    self.logicalBlockCount = logicalBlockCount
    self.logicalBlockSize = logicalBlockSize
  }
}
public typealias MMCCardCSD = SDCardCSD
public typealias MMCCardCID = SDCardCID
