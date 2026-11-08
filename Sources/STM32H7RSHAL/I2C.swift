// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  public func initialize() -> HALStatus {
    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0)
      if useRegisteredCallbacks {
        callbacks.write(.masterTransmitComplete, value: defaults.masterTransmitComplete)
        callbacks.write(.masterReceiveComplete, value: defaults.masterReceiveComplete)
        callbacks.write(.slaveTransmitComplete, value: defaults.slaveTransmitComplete)
        callbacks.write(.slaveReceiveComplete, value: defaults.slaveReceiveComplete)
        callbacks.write(.listenComplete, value: defaults.listenComplete)
        callbacks.write(.memoryTransmitComplete, value: defaults.memoryTransmitComplete)
        callbacks.write(.memoryReceiveComplete, value: defaults.memoryReceiveComplete)
        callbacks.write(.error, value: defaults.error)
        callbacks.write(.abortComplete, value: defaults.abortComplete)
        callbacks.writeAddress(defaults.address)
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
      }
      invoke(.mspInitialize)
    }
    handle.write(.state, value: 0x24)
    disable()
    registers.write(.timingr, value: handle.read(.timing) & 0xF0FF_FFFF)
    modify(.oar1, clear: 0x8000)
    if handle.read(.addressingMode) == 0x1 {
      registers.write(.oar1, value: 0x8000 | handle.read(.ownAddress1))
    } else {
      registers.write(.oar1, value: 0x8000 | 0x400 | handle.read(.ownAddress1))
    }
    if handle.read(.addressingMode) == 0x2 {
      modify(.cr2, set: 0x800)
    } else {
      modify(.cr2, clear: 0x800)
    }
    modify(.cr2, set: 0x2000000 | 0x8000)
    modify(.oar2, clear: 0x8000)
    registers.write(
      .oar2,
      value: handle.read(.dualAddressMode) | handle.read(.ownAddress2)
        | (handle.read(.ownAddress2Masks) << 8))
    registers.write(.cr1, value: handle.read(.generalCallMode) | handle.read(.noStretchMode))
    enable()
    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x20)
    handle.write(.previousState, value: 0x0)
    handle.write(.mode, value: 0x0)
    return .ok
  }
  public func deinitialize() -> HALStatus {
    handle.write(.state, value: 0x24)
    disable()
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invoke(.mspDeinitialize)
    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x0)
    handle.write(.previousState, value: 0x0)
    handle.write(.mode, value: 0x0)
    unlock()
    return .ok
  }
  public func getState() -> UInt32 { handle.read(.state) }
  public func getMode() -> UInt32 { handle.read(.mode) }
  public func getError() -> UInt32 { handle.read(.errorCode) }
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
  public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.isr) & flag == flag ? 1 : 0 }
  public func clearFlag(_ flag: UInt32) {
    if flag == 0x1 { modify(.isr, set: flag) } else { registers.write(.icr, value: flag) }
  }
  public func generateNACK() { modify(.cr2, set: 0x8000) }
  func resetCR2() { modify(.cr2, clear: 0x3FF | 0x1000 | 0xFF0000 | 0x1000000 | 0x400) }
  func addressMatch() -> UInt16 {
    UInt16(truncatingIfNeeded: (registers.read(.isr) & 0xFE0000) >> 16)
  }
  func direction() -> UInt8 { UInt8(truncatingIfNeeded: (registers.read(.isr) & 0x10000) >> 16) }
  func stopMode() -> UInt32 { registers.read(.cr2) & 0x2000000 }
  func ownAddress1() -> UInt16 { UInt16(truncatingIfNeeded: registers.read(.oar1) & 0x3FF) }
  func ownAddress2() -> UInt16 { UInt16(truncatingIfNeeded: registers.read(.oar2) & 0xFE) }
  func checkFlag(_ flags: UInt32, _ flag: UInt32) -> UInt32 {
    flags & (flag & 0x1FFFF) == flag & 0x1FFFF ? 1 : 0
  }
  func checkInterruptSource(_ sources: UInt32, _ interrupt: UInt32) -> UInt32 {
    sources & interrupt == interrupt ? 1 : 0
  }
  func generateStart(_ mode: UInt32, _ address: UInt32) -> UInt32 {
    if mode == 0x1 { return ((address & 0x3FF) | 0x2000 | 0x2000000) & ~0x400 }
    return ((address & 0x3FF) | 0x800 | 0x2000 | 0x2000000) & ~0x400
  }
  func transferConfiguration(_ address: UInt16, _ size: UInt8, _ mode: UInt32, _ request: UInt32) {
    let value =
      ((UInt32(address) & 0x3FF) | ((UInt32(size) << 0x10) & 0xFF0000) | mode | request) & ~UInt32(
        0x8000_0000)
    modify(
      .cr2,
      clear: 0x3FF | 0xFF0000 | 0x1000000 | 0x2000000 | (0x400 & (request >> (31 - 0xA))) | 0x2000
        | 0x4000, set: value)
  }
  func flushTransmitData() {
    if getFlag(0x2) != 0 { registers.write(.txdr, value: 0) }
    if getFlag(0x1) == 0 { clearFlag(0x1) }
  }
}
