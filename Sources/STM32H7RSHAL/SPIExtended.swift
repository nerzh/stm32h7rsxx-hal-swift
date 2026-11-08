// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPI {
  public func flushReceiveFIFO() -> HALStatus {

    var count: UInt32 = 0
    var itflag: UInt32 = registers.read(.sr)
    var tmpreg: UInt32
    while ((registers.read(.sr) & 0x6000) != 0x0) || ((itflag & 0x8000) != 0) {
      count &+= ((4) & 0xFF)
      tmpreg = registers.read(.rxdr)
      _ = tmpreg
      if (!isLimitedInstance) {
        if count > 0x10 {
          return .timeout
        }
      } else {
        if count > 0x8 {
          return .timeout
        }
      }
    }
    return .ok

  }
  public func enableLockConfiguration() -> HALStatus {

    var errorcode: HALStatus = .ok

    guard lock() else { return .busy }
    if handle.read(.state) != 0x1 {
      errorcode = .busy
      handle.write(.state, value: 0x1)
      unlock()
      return errorcode
    }

    if (registers.read(.cr1) & 0x1) != 0x1 {
      registers.write(.cr1, value: registers.read(.cr1) | (0x10000))
    } else {
      disable()
      registers.write(.cr1, value: registers.read(.cr1) | (0x10000))

      enable()
    }
    handle.write(.state, value: 0x1)
    unlock()
    return errorcode

  }
  public func configureUnderrun(_ UnderrunDetection: UInt32, _ UnderrunBehaviour: UInt32)
    -> HALStatus
  {

    _ = UnderrunDetection
    var errorcode: HALStatus = .ok

    guard lock() else { return .busy }

    if (handle.read(.state) != 0x1) || (handle.read(.mode) != 0x0) {
      errorcode = .busy
      handle.write(.state, value: 0x1)
      unlock()
      return errorcode
    }

    if (registers.read(.cr1) & 0x1) != 0x1 {
      registers.write(.cfg1, value: (registers.read(.cfg1) & ~(0x200)) | (UnderrunBehaviour))
    } else {
      disable()

      registers.write(.cfg1, value: (registers.read(.cfg1) & ~(0x200)) | (UnderrunBehaviour))

      enable()
    }
    handle.write(.state, value: 0x1)
    unlock()
    return errorcode

  }
}
