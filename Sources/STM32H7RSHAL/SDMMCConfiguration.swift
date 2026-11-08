// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDMMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct SDMMCConfiguration: Equatable, Sendable {
  public var clockEdge: UInt32
  public var clockPowerSave: UInt32
  public var busWide: UInt32
  public var hardwareFlowControl: UInt32
  public var clockDivider: UInt32
  public var transceiverPresent: UInt32
  public init(
    clockEdge: UInt32 = 0, clockPowerSave: UInt32 = 0, busWide: UInt32 = 0,
    hardwareFlowControl: UInt32 = 0, clockDivider: UInt32 = 0, transceiverPresent: UInt32 = 0
  ) {
    self.clockEdge = clockEdge
    self.clockPowerSave = clockPowerSave
    self.busWide = busWide
    self.hardwareFlowControl = hardwareFlowControl
    self.clockDivider = clockDivider
    self.transceiverPresent = transceiverPresent
  }
}
public struct SDMMCCommand: Equatable, Sendable {
  public var argument: UInt32
  public var commandIndex: UInt32
  public var response: UInt32
  public var waitForInterrupt: UInt32
  public var cpsm: UInt32
  public init(
    argument: UInt32 = 0, commandIndex: UInt32 = 0, response: UInt32 = 0,
    waitForInterrupt: UInt32 = 0, cpsm: UInt32 = 0
  ) {
    self.argument = argument
    self.commandIndex = commandIndex
    self.response = response
    self.waitForInterrupt = waitForInterrupt
    self.cpsm = cpsm
  }
}
public struct SDMMCDataConfiguration: Equatable, Sendable {
  public var dataTimeout: UInt32
  public var dataLength: UInt32
  public var dataBlockSize: UInt32
  public var transferDirection: UInt32
  public var transferMode: UInt32
  public var dpsm: UInt32
  public init(
    dataTimeout: UInt32 = 0, dataLength: UInt32 = 0, dataBlockSize: UInt32 = 0,
    transferDirection: UInt32 = 0, transferMode: UInt32 = 0, dpsm: UInt32 = 0
  ) {
    self.dataTimeout = dataTimeout
    self.dataLength = dataLength
    self.dataBlockSize = dataBlockSize
    self.transferDirection = transferDirection
    self.transferMode = transferMode
    self.dpsm = dpsm
  }
}
public struct SDMMCDMANodeConfiguration: Equatable, Sendable {
  public var bufferAddress: UInt32
  public var bufferSize: UInt32
  public init(bufferAddress: UInt32 = 0, bufferSize: UInt32 = 0) {
    self.bufferAddress = bufferAddress
    self.bufferSize = bufferSize
  }
}
