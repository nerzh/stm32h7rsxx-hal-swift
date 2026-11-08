// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  var hasCRYP: Bool { engines != .saesOnly }
  var hasSAES: Bool { engines != .crypOnly }
  var isCRYP: Bool { registers.instance == .cryp }
  var isSAES: Bool { registers.instance == .saes }
  func modify(_ register: CRYPRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
  func addError(_ bits: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | bits) }
  func lock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func invoke(_ id: CRYPCallbackID) {
    (useRegisteredCallbacks ? callbacks.read(id)! : defaults.callback(id))(callbacks.context)
  }
  public func getState() -> UInt32 { handle.read(.state) }
  public func getError() -> UInt32 { handle.read(.errorCode) }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
  public func enable() { modify(.cr, set: isCRYP ? 0x8000 : 0x1) }
  public func disable() { modify(.cr, clear: isCRYP ? 0x8000 : 0x1) }
  public func getFlag(_ flag: UInt32) -> Bool {
    if isCRYP {
      if flag == 0x80 { return registers.read(.sr) & 0x80 == 0x80 }
      if flag == 0x10 { return registers.read(.sr) & 0x10 == 0x10 }
      if flag == 0x4 { return registers.read(.sr) & 0x40 == 0x40 }
      // Both branches of the original flag macro read RISR, including FIFO flags.
      if UInt8(truncatingIfNeeded: flag >> 24) == 1 {
        return registers.read(.risr) & (flag & 0x1F) == (flag & 0x1F)
      }
      return registers.read(.risr) & (flag & 0x1F) == (flag & 0x1F)
    }
    if flag == 0x80 { return registers.read(.sr) & 0x80 == 0x80 }
    if flag == 0x10 { return registers.read(.sr) & 0x10 == 0x10 }
    if flag == 0x8000_0004 {
      return registers.read(.sr) & (0x8000_0004 & 0x7FFF_FFFF) == (0x8000_0004 & 0x7FFF_FFFF)
    }
    if flag == 0x8000_0002 {
      return registers.read(.sr) & (0x8000_0002 & 0x7FFF_FFFF) == (0x8000_0002 & 0x7FFF_FFFF)
    }
    if flag == 0x8 { return registers.read(.isr) & 0x8 == 0x8 }
    if flag == 0x4 { return registers.read(.isr) & 0x4 == 0x4 }
    if flag == 0x2 { return registers.read(.isr) & 0x2 == 0x2 }
    return registers.read(.isr) & 0x1 == 0x1
  }
  public func clearFlags(_ flags: UInt32) { registers.write(.icr, value: flags) }
  public func getInterrupt(_ mask: UInt32) -> Bool { registers.read(.misr) & mask == mask }
  public func getInterruptSource(_ mask: UInt32) -> Bool { registers.read(.ier) & mask == mask }
  public func enableInterrupts(_ mask: UInt32) { modify(isCRYP ? .imscr : .ier, set: mask) }
  public func disableInterrupts(_ mask: UInt32) { modify(isCRYP ? .imscr : .ier, clear: mask) }
  func setPhase(_ phase: UInt32) { modify(.cr, clear: isCRYP ? 0x30000 : 0x6000, set: phase) }
  func resetSAES() {
    modify(.cr, set: 0x8000_0000)
    _ = registers.read(.cr) & 0x8000_0000
    modify(.cr, clear: 0x8000_0000)
  }
  func waitOnInputEmpty(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    let start = getTick()
    while registers.read(.sr) & 0x1 == 0 {
      if timeout != UInt32.max {
        if getTick() &- start > timeout || timeout == 0 { return .error }
      }
    }
    return .ok
  }
  func waitOnOutputNotEmpty(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    let start = getTick()
    while registers.read(.sr) & 0x4 == 0 {
      if timeout != UInt32.max {
        if getTick() &- start > timeout || timeout == 0 { return .error }
      }
    }
    return .ok
  }
  func waitOnBusy(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    let start = getTick()
    var mask: UInt32 = 0
    if hasCRYP && isCRYP { mask = 0x10 }
    if hasSAES && isSAES { mask = 0x8 }
    while registers.read(.sr) & mask == mask {
      if timeout != UInt32.max {
        if getTick() &- start > timeout || timeout == 0 { return .error }
      }
    }
    return .ok
  }
  func waitOnComputationComplete(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    let start = getTick()
    while registers.read(.sr) & 0x1 == 0 {
      if timeout != UInt32.max {
        if getTick() &- start > timeout || timeout == 0 { return .error }
      }
    }
    return .ok
  }
  func saesAlgorithm(_ algorithm: UInt32, order: UInt32 = 0) -> UInt32 {
    if order == 0 {
      switch algorithm {
      case 0x20: return 0x0
      case 0x28: return 0x20
      case 0x30: return 0x40
      case 0x80000: return 0x60
      case 0x80008: return 0x10000
      default: return 0
      }
    }
    switch algorithm {
    case 0x0: return 0x20
    case 0x20: return 0x28
    case 0x40: return 0x30
    case 0x60: return 0x80000
    case 0x10000: return 0x80008
    default: return 0
    }
  }
  func saesDataType(_ dataType: UInt32) -> UInt32 { dataType >> (0x6 - 0x1) }
  func saesKeySize(_ keySize: UInt32) -> UInt32 { (keySize & 0x200) << (0x12 - (0x8 + 1)) }
  func saesAlgorithmBits(_ algorithm: UInt32) -> UInt32 {
    (algorithm & (0x10 | 0x8)) << (0x5 - 0x3)
  }
  func crypAlgorithmDirection(_ direction: UInt32) -> UInt32 {
    (direction & 0x10) >> ((0x3 + 1) - 0x2)
  }
}
