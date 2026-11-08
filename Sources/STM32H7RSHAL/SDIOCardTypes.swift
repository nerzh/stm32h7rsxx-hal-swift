// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct SDIOCommonControlRegister: Equatable, Sendable {
  public var sdioRevision: UInt8
  public var cccrRevision: UInt8
  public var sdSpecificationRevision: UInt8
  public var busWidth8Bit: UInt8
  public var cardCapability: UInt32
  public var commonCISPointer: UInt32
  public init(
    sdioRevision: UInt8 = 0, cccrRevision: UInt8 = 0, sdSpecificationRevision: UInt8 = 0,
    busWidth8Bit: UInt8 = 0, cardCapability: UInt32 = 0, commonCISPointer: UInt32 = 0
  ) {
    self.sdioRevision = sdioRevision
    self.cccrRevision = cccrRevision
    self.sdSpecificationRevision = sdSpecificationRevision
    self.busWidth8Bit = busWidth8Bit
    self.cardCapability = cardCapability
    self.commonCISPointer = commonCISPointer
  }
}
public struct SDIOFunctionBasicRegister: Equatable, Sendable {
  public var flags: UInt8
  public var ioStdFunctionCode: UInt8
  public var ioExtFunctionCode: UInt8
  public var ioPointerToCIS: UInt32
  public var ioPointerToCSA: UInt32
  public init(
    flags: UInt8 = 0, ioStdFunctionCode: UInt8 = 0, ioExtFunctionCode: UInt8 = 0,
    ioPointerToCIS: UInt32 = 0, ioPointerToCSA: UInt32 = 0
  ) {
    self.flags = flags
    self.ioStdFunctionCode = ioStdFunctionCode
    self.ioExtFunctionCode = ioExtFunctionCode
    self.ioPointerToCIS = ioPointerToCIS
    self.ioPointerToCSA = ioPointerToCSA
  }
}
public struct SDIODirectCommand: Equatable, Sendable {
  public var registerAddress: UInt32
  public var readAfterWrite: UInt8
  public var ioFunctionNumber: UInt8
  public init(registerAddress: UInt32 = 0, readAfterWrite: UInt8 = 0, ioFunctionNumber: UInt8 = 0) {
    self.registerAddress = registerAddress
    self.readAfterWrite = readAfterWrite
    self.ioFunctionNumber = ioFunctionNumber
  }
}
public struct SDIOExtendedCommand: Equatable, Sendable {
  public var registerAddress: UInt32
  public var operationCode: UInt32
  public var blockMode: UInt32
  public var ioFunctionNumber: UInt32
  public init(
    registerAddress: UInt32 = 0, operationCode: UInt32 = 0, blockMode: UInt32 = 0,
    ioFunctionNumber: UInt32 = 0
  ) {
    self.registerAddress = registerAddress
    self.operationCode = operationCode
    self.blockMode = blockMode
    self.ioFunctionNumber = ioFunctionNumber
  }
}
