// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMBUS {
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
  func enableIRQ(_ InterruptRequest: UInt32) {

    var tmpisr: UInt32 = 0
    if (InterruptRequest & 0x80) == 0x80 {
      tmpisr |= 0x80
    }
    if (InterruptRequest & 0x38) == 0x38 {
      tmpisr |= 0x8 | 0x20 | 0x10 | 0x80
    }
    if (InterruptRequest & 0xf2) == 0xf2 {
      tmpisr |= 0x80 | 0x40 | 0x20 | 0x10 | 0x2
    }
    if (InterruptRequest & 0xd4) == 0xd4 {
      tmpisr |= 0x80 | 0x40 | 0x20 | 0x10 | 0x4
    }

    enableInterrupts(tmpisr)

  }
  func disableIRQ(_ InterruptRequest: UInt32) {

    var tmpisr: UInt32 = 0
    var tmpstate: UInt32 = handle.read(.state)
    if (tmpstate == 0x1) && ((InterruptRequest & 0x80) == 0x80) {
      tmpisr |= 0x80
    }
    if (InterruptRequest & 0xf2) == 0xf2 {
      tmpisr |= 0x40 | 0x2
      if (alertEnabled() == 0)
        && ((tmpstate & 0x8) != 0x8)
      {
        tmpisr |= 0x80
      }
      if (tmpstate & 0x8) != 0x8 {
        tmpisr |= 0x20 | 0x10
      }
    }
    if (InterruptRequest & 0xd4) == 0xd4 {
      tmpisr |= 0x40 | 0x4
      if (alertEnabled() == 0)
        && ((tmpstate & 0x8) != 0x8)
      {
        tmpisr |= 0x80
      }
      if (tmpstate & 0x8) != 0x8 {
        tmpisr |= 0x20 | 0x10
      }
    }
    if (InterruptRequest & 0x38) == 0x38 {
      tmpisr |= 0x8 | 0x20 | 0x10
      if alertEnabled() == 0 {
        tmpisr |= 0x80
      }
    }

    disableInterrupts(tmpisr)

  }
  func waitOnFlag(_ Flag: UInt32, _ Status: UInt32, _ Timeout: UInt32, getTick: () -> UInt32)
    -> HALStatus
  {

    var tickstart: UInt32 = getTick()

    while (getFlag(Flag)) == Status {
      if Timeout != UInt32.max {
        if ((getTick() &- tickstart) > Timeout) || (Timeout == 0) {
          handle.write(.previousState, value: handle.read(.state))
          handle.write(.state, value: 0x1)

          handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))

          unlock()
          return .error
        }
      }
    }
    return .ok

  }
  func flushTransmitData() {

    if getFlag(0x2) != 0 {
      registers.write(.txdr, value: 0x00)
    }

    if getFlag(0x1) == 0 {
      clearFlag(0x1)
    }

  }
  func transferConfiguration(
    _ DevAddress: UInt32, _ Size: UInt32, _ Mode: UInt32, _ Request: UInt32
  ) {
    let DevAddress = UInt32(UInt16(truncatingIfNeeded: DevAddress))
    let Size = UInt32(UInt8(truncatingIfNeeded: Size))

    registers.write(
      .cr2,
      value: (registers.read(.cr2)
        & ~(((0x3ff | 0xff0000 | 0x1000000 | 0x2000000 | (0x400 & ((Request >> (31 &- 0xa))))
        | 0x2000 | 0x4000 | 0x4000000))))
        | (((((DevAddress) & 0x3ff) | (((Size) << 0x10) & 0xff0000) | (Mode) | (Request)))))

  }
  func convertOtherTransferOptions() {

    if handle.read(.transferOptions) == 0xaa {
      handle.write(.transferOptions, value: 0x0)
    } else if handle.read(.transferOptions) == 0xaa00 {
      handle.write(.transferOptions, value: 0x0 | 0x4000000)
    } else if handle.read(.transferOptions) == 0xaa0000 {
      handle.write(.transferOptions, value: 0x2000000)
    } else if handle.read(.transferOptions) == 0xaa00_0000 {
      handle.write(.transferOptions, value: 0x6000000)
    } else {
    }

  }
}
