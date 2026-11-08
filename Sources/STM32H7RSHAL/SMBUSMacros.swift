// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMBUS {
  public func resetHandleState() {
    handle.write(.state, value: 0x0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
  public func enable() { modify(.cr1, set: 0x1) }
  public func disable() { modify(.cr1, clear: 0x1) }
  public func enableInterrupts(_ interrupts: UInt32) { modify(.cr1, set: interrupts) }
  public func disableInterrupts(_ interrupts: UInt32) { modify(.cr1, clear: interrupts) }
  public func getInterruptSource(_ interrupts: UInt32) -> UInt32 {
    registers.read(.cr1) & interrupts == interrupts ? 1 : 0
  }
  public func getFlag(_ flag: UInt32) -> UInt32 {
    registers.read(.isr) & (flag & 0x1FFFF) == (flag & 0x1FFFF) ? 1 : 0
  }
  public func clearFlag(_ flag: UInt32) {
    if flag == 0x1 { modify(.isr, set: flag) } else { registers.write(.icr, value: flag) }
  }
  public func generateNACK() { modify(.cr2, set: 0x8000) }
  func resetCR2() { modify(.cr2, clear: 0x3FF | 0x1000 | 0xFF0000 | 0x1000000 | 0x400) }
  func addressMatch() -> UInt32 {
    (registers.read(.isr) & 0xFE0000) >> 17
  }
  func direction() -> UInt32 { (registers.read(.isr) & 0x10000) >> 16 }
  func stopMode() -> UInt32 { registers.read(.cr2) & 0x2000000 }
  func checkFlag(_ flags: UInt32, _ flag: UInt32) -> UInt32 {
    flags & (flag & 0x1FFFF) == flag & 0x1FFFF ? 1 : 0
  }
  func checkInterruptSource(_ sources: UInt32, _ interrupt: UInt32) -> UInt32 {
    sources & interrupt == interrupt ? 1 : 0
  }
  func generateStart(_ mode: UInt32, _ address: UInt32) -> UInt32 {
    if mode == 0x1 { return ((address & 0x3FF) | 0x2000 | 0x2000000) & ~0x400 }
    return ((address & 0x3FF) | 0x800 | 0x2000) & ~0x400
  }
  func resetCR1() { modify(.cr1, clear: 0x100000 | 0x200000 | 0x800000) }
  func pecMode() -> UInt32 { registers.read(.cr2) & 0x4000000 }
  func alertEnabled() -> UInt32 { registers.read(.cr1) & 0x400000 }
  func isOtherTransferOptions(_ options: UInt32) -> UInt32 {
    (options == SMBUSConstants.SMBUS_OTHER_FRAME_NO_PEC
      || options == SMBUSConstants.SMBUS_OTHER_AND_LAST_FRAME_NO_PEC
      || options == SMBUSConstants.SMBUS_OTHER_FRAME_WITH_PEC
      || options == SMBUSConstants.SMBUS_OTHER_AND_LAST_FRAME_WITH_PEC) ? 1 : 0
  }
}
