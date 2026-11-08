// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  @discardableResult
  public func wrapKey(
    input: UnsafeMutablePointer<UInt32>?, output: UnsafeMutablePointer<UInt32>?, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    let status: HALStatus
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard lock() else { return .busy }
      handle.write(.inputCount, value: 0)
      handle.write(.outputCount, value: 0)
      handle.writePointer(.input, value: input)
      handle.writePointer(.output, value: output)
      disable()
      modify(.cr, clear: 0x3000000, set: 0x1000000)
      status = extendedKeyEncrypt(timeout: timeout, getTick: getTick)
      if status == .ok {
        handle.write(.state, value: 1)
        unlock()
      }
    } else {
      addError(0x8)
      status = .error
    }
    return status
  }
  @discardableResult
  public func unwrapKey(
    input: UnsafeMutablePointer<UInt32>?, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let status: HALStatus
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard lock() else { return .busy }
      handle.write(.inputCount, value: 0)
      handle.write(.outputCount, value: 0)
      handle.writePointer(.input, value: input)
      disable()
      modify(.cr, clear: 0x3000000, set: 0x1000000)
      status = extendedKeyDecrypt(timeout: timeout, getTick: getTick)
      if status == .ok {
        handle.write(.state, value: 1)
        unlock()
      }
    } else {
      addError(0x8)
      status = .error
    }
    return status
  }
  @discardableResult
  public func encryptSharedKey(
    input: UnsafeMutablePointer<UInt32>?, output: UnsafeMutablePointer<UInt32>?, id: UInt32,
    timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let status: HALStatus
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard lock() else { return .busy }
      handle.write(.inputCount, value: 0)
      handle.write(.outputCount, value: 0)
      handle.writePointer(.input, value: input)
      handle.writePointer(.output, value: output)
      disable()
      modify(.cr, clear: 0x3000000 | 0xC000000, set: 0x2000000 | id)
      status = extendedKeyEncrypt(timeout: timeout, getTick: getTick)
      if status == .ok {
        handle.write(.state, value: 1)
        unlock()
      }
    } else {
      addError(0x8)
      status = .error
    }
    return status
  }
  @discardableResult
  public func decryptSharedKey(
    input: UnsafeMutablePointer<UInt32>?, id: UInt32, timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    let status: HALStatus
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard lock() else { return .busy }
      handle.write(.inputCount, value: 0)
      handle.write(.outputCount, value: 0)
      handle.writePointer(.input, value: input)
      disable()
      modify(.cr, clear: 0x3000000 | 0xC000000, set: 0x2000000 | id)
      status = extendedKeyDecrypt(timeout: timeout, getTick: getTick)
      if status == .ok {
        handle.write(.state, value: 1)
        unlock()
      }
    } else {
      addError(0x8)
      status = .error
    }
    return status
  }
  func extendedKeyDecrypt(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    var tickStart: UInt32
    modify(.cr, clear: 0x18, set: 0x8)
    if handle.read(.keySelection) == 0x0 { setExtendedKey(handle.read(.keySize)) }
    enable()
    tickStart = getTick()
    while registers.read(.sr) & 0x1 == 0 {
      if timeout != UInt32.max {
        if getTick() &- tickStart > timeout || timeout == 0 {
          disable()
          addError(0x10)
          handle.write(.state, value: 1)
          unlock()
          return .error
        }
      }
    }
    clearFlags(0x1)
    modify(.cr, clear: 0x18, set: 0x10)
    if handle.read(.algorithm) != 0x20 {
      registers.write(.ivr3, value: handle.readPointer(.initialVector)![0])
      registers.write(.ivr2, value: handle.readPointer(.initialVector)![1])
      registers.write(.ivr1, value: handle.readPointer(.initialVector)![2])
      registers.write(.ivr0, value: handle.readPointer(.initialVector)![3])
    }
    enable()
    handle.write(.phase, value: 2)
    let inputCount: UInt32 = handle.read(.keySize) == 0x0 ? 4 : 8
    while UInt32(handle.read(.inputCount)) < inputCount {
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      tickStart = getTick()
      while registers.read(.sr) & 0x1 == 0 {
        if timeout != UInt32.max {
          if getTick() &- tickStart > timeout || timeout == 0 {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
        }
      }
      clearFlags(0x1)
    }
    disable()
    return .ok
  }
  func extendedKeyEncrypt(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    var tickStart: UInt32
    modify(.cr, clear: 0x18, set: 0x0)
    if handle.read(.algorithm) != 0x20 {
      registers.write(.ivr3, value: handle.readPointer(.initialVector)![0])
      registers.write(.ivr2, value: handle.readPointer(.initialVector)![1])
      registers.write(.ivr1, value: handle.readPointer(.initialVector)![2])
      registers.write(.ivr0, value: handle.readPointer(.initialVector)![3])
    }
    if handle.read(.keySelection) == 0x0 { setExtendedKey(handle.read(.keySize)) }
    tickStart = getTick()
    while registers.read(.sr) & 0x80 == 0 {
      if timeout != UInt32.max {
        if getTick() &- tickStart > timeout || timeout == 0 {
          addError(0x10)
          handle.write(.state, value: 1)
          return .error
        }
      }
    }
    enable()
    handle.write(.phase, value: 2)
    let inputCount: UInt32 = handle.read(.keySize) == 0x0 ? 4 : 8
    while UInt32(handle.read(.inputCount)) < inputCount {
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      tickStart = getTick()
      while registers.read(.sr) & 0x1 == 0 {
        if timeout != UInt32.max {
          if getTick() &- tickStart > timeout || timeout == 0 {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
        }
      }
      clearFlags(0x1)
      let temporary0 = registers.read(.doutr)
      handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary0
      handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
      let temporary1 = registers.read(.doutr)
      handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary1
      handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
      let temporary2 = registers.read(.doutr)
      handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary2
      handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
      let temporary3 = registers.read(.doutr)
      handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary3
      handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
    }
    disable()
    return .ok
  }
  func setExtendedKey(_ keySize: UInt32) {
    if handle.readPointer(.key) != nil {
      switch keySize {
      case 0x200:
        registers.write(.keyr7, value: handle.readPointer(.key)![0])
        registers.write(.keyr6, value: handle.readPointer(.key)![1])
        registers.write(.keyr5, value: handle.readPointer(.key)![2])
        registers.write(.keyr4, value: handle.readPointer(.key)![3])
        registers.write(.keyr3, value: handle.readPointer(.key)![4])
        registers.write(.keyr2, value: handle.readPointer(.key)![5])
        registers.write(.keyr1, value: handle.readPointer(.key)![6])
        registers.write(.keyr0, value: handle.readPointer(.key)![7])
      case 0x0:
        registers.write(.keyr3, value: handle.readPointer(.key)![0])
        registers.write(.keyr2, value: handle.readPointer(.key)![1])
        registers.write(.keyr1, value: handle.readPointer(.key)![2])
        registers.write(.keyr0, value: handle.readPointer(.key)![3])
      default: break
      }
    }
  }
}
