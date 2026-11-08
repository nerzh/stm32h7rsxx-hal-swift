// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  @discardableResult
  public func generateGCMAuthenticationTag(
    _ output: UnsafeMutablePointer<UInt32>?, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let inputLength = UInt64(handle.read(.sizesSum)) * 8
    let headerLength: UInt64
    if handle.read(.headerWidthUnit) == 0x0 {
      headerLength = UInt64(handle.read(.headerSize)) * 32
    } else {
      headerLength = UInt64(handle.read(.headerSize)) * 8
    }
    if handle.read(.state) == 1 {
      guard lock() else { return .busy }
      handle.write(.state, value: 2)
      if handle.read(.phase) == 2 {
        handle.write(.phase, value: 3)
      } else {
        disable()
        addError(0x40)
        handle.write(.state, value: 1)
        unlock()
        return .error
      }
      if hasCRYP && isCRYP {
        disable()
        modify(.cr, clear: 0x30000, set: 0x30000)
        modify(.cr, clear: 0x4)
        enable()
        registers.write(.din, value: 0)
        registers.write(.din, value: UInt32(truncatingIfNeeded: headerLength))
        registers.write(.din, value: 0)
        registers.write(.din, value: UInt32(truncatingIfNeeded: inputLength))
        let start = getTick()
        while registers.read(.sr) & 0x4 == 0 {
          if timeout != UInt32.max {
            if getTick() &- start > timeout || timeout == 0 {
              disable()
              addError(0x10)
              handle.write(.state, value: 1)
              unlock()
              return .error
            }
          }
        }
        for i in 0..<4 { output![i] = registers.read(.dout) }
      }
      if hasSAES && isSAES {
        modify(.cr, clear: 0x6000, set: 0x6000)
        registers.write(.dinr, value: 0)
        registers.write(.dinr, value: UInt32(truncatingIfNeeded: headerLength))
        registers.write(.dinr, value: 0)
        registers.write(.dinr, value: UInt32(truncatingIfNeeded: inputLength))
        let start = getTick()
        while registers.read(.sr) & 0x1 == 0 {
          if timeout != UInt32.max {
            if getTick() &- start > timeout || timeout == 0 {
              disable()
              addError(0x10)
              handle.write(.state, value: 1)
              unlock()
              return .error
            }
          }
        }
        for i in 0..<4 { output![i] = registers.read(.doutr) }
        clearFlags(0x1)
      }
      disable()
      handle.write(.state, value: 1)
      unlock()
    } else {
      addError(0x8)
      return .error
    }
    return .ok
  }
  @discardableResult
  public func generateCCMAuthenticationTag(
    _ output: UnsafeMutablePointer<UInt32>?, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var counter0: InlineArray<4, UInt32> = .init(repeating: 0)
    if handle.read(.state) == 1 {
      guard lock() else { return .busy }
      if hasSAES && isSAES { disableInterrupts(0x1 | 0x2 | 0x4) }
      handle.write(.state, value: 2)
      if handle.read(.phase) == 2 {
        handle.write(.phase, value: 3)
      } else {
        disable()
        addError(0x40)
        handle.write(.state, value: 1)
        unlock()
        return .error
      }
      if hasCRYP && isCRYP {
        disable()
        modify(.cr, clear: 0x30000, set: 0x30000)
        modify(.cr, clear: 0x4)
        counter0[0] = handle.readPointer(.b0)![0] & 0x07FF_FFFF
        counter0[1] = handle.readPointer(.b0)![1]
        counter0[2] = handle.readPointer(.b0)![2]
        counter0[3] = handle.readPointer(.b0)![3] & 0xFFFF_FF00
        for i in 0..<4 { registers.write(.din, value: counter0[i]) }
        enable()
        let start = getTick()
        while registers.read(.sr) & 0x4 == 0 {
          if timeout != UInt32.max {
            if getTick() &- start > timeout || timeout == 0 {
              disable()
              addError(0x10)
              handle.write(.state, value: 1)
              unlock()
              return .error
            }
          }
        }
        for i in 0..<4 { output![i] = registers.read(.dout) }
      }
      if hasSAES && isSAES {
        modify(.cr, clear: 0x6000, set: 0x6000)
        for i in 0..<4 { registers.write(.dinr, value: counter0[i]) }
        let start = getTick()
        while registers.read(.sr) & 0x1 == 0 {
          if timeout != UInt32.max {
            if getTick() &- start > timeout || timeout == 0 {
              disable()
              addError(0x10)
              handle.write(.state, value: 1)
              unlock()
              return .error
            }
          }
        }
        for i in 0..<4 { output![i] = registers.read(.doutr) }
        clearFlags(0x1)
      }
      handle.write(.state, value: 1)
      unlock()
      disable()
    } else {
      handle.write(.errorCode, value: 0x8)
      return .error
    }
    return .ok
  }
}
