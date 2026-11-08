// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C public macros from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  public func enableInterrupts(_ mask: UInt32) { modify(.ier, set: mask) }
  public func disableInterrupts(_ mask: UInt32) { modify(.ier, clear: mask) }
  public func getBusCharacteristics(_ payload: UInt64) -> UInt32 {
    UInt32(truncatingIfNeeded: payload >> 48) & 0xFF
  }
  public func isIBICapable(_ busCharacteristics: UInt32) -> UInt32 {
    ((busCharacteristics & 0x2) >> 1) == 1 ? 1 : 0
  }
  public func hasIBIPayload(_ busCharacteristics: UInt32) -> UInt32 {
    ((busCharacteristics & 0x4) >> 2) == 1 ? 1 : 0
  }
  public func isControllerCapable(_ busCharacteristics: UInt32) -> UInt32 {
    ((busCharacteristics & 0x40) >> 6) == 1 ? 1 : 0
  }
}
