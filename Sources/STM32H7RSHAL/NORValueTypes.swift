// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// NOR operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public struct NORID: Equatable, Sendable {
  public var manufacturerCode: UInt16
  public var deviceCode1: UInt16
  public var deviceCode2: UInt16
  public var deviceCode3: UInt16
  public init(
    manufacturerCode: UInt16 = 0, deviceCode1: UInt16 = 0, deviceCode2: UInt16 = 0,
    deviceCode3: UInt16 = 0
  ) {
    self.manufacturerCode = manufacturerCode
    self.deviceCode1 = deviceCode1
    self.deviceCode2 = deviceCode2
    self.deviceCode3 = deviceCode3
  }
}
public struct NORCFI: Equatable, Sendable {
  public var cfi1: UInt16
  public var cfi2: UInt16
  public var cfi3: UInt16
  public var cfi4: UInt16
  public init(cfi1: UInt16 = 0, cfi2: UInt16 = 0, cfi3: UInt16 = 0, cfi4: UInt16 = 0) {
    self.cfi1 = cfi1
    self.cfi2 = cfi2
    self.cfi3 = cfi3
    self.cfi4 = cfi4
  }
}
