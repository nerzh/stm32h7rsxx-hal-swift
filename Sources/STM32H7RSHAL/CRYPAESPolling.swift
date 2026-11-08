// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func aesEncrypt(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    var doKeyIVConfiguration: UInt32 = 1
    if handle.read(.keyIVConfigurationSkip) == 0x1 {
      if handle.read(.keyIVConfiguration) == 1 {
        doKeyIVConfiguration = 0
      } else {
        handle.write(.keyIVConfiguration, value: 1)
      }
    }
    if doKeyIVConfiguration == 1 {
      if handle.read(.keySelection) == 0x0 && handle.read(.keyMode) == 0x0 {
        setKey(handle.read(.keySize))
      }
      let start = getTick()
      while !getFlag(0x80) {
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
      if hasCRYP && isCRYP {
        if handle.read(.keyMode) == 0x2000000 { modify(.cr, clear: 0x3000000) }
      }
      if handle.read(.algorithm) != 0x20 { loadInitialVector() }
    }
    handle.write(.phase, value: 2)
    enable()
    var outputCount = handle.read(.outputCount)
    while UInt32(handle.read(.inputCount)) < UInt32(handle.read(.size)) / 4
      && UInt32(outputCount) < UInt32(handle.read(.size)) / 4
    {
      aesProcessData(timeout: timeout, getTick: getTick)
      outputCount = handle.read(.outputCount)
    }
    disable()
    handle.write(.state, value: 1)
    return .ok
  }
  func aesDecrypt(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    var doKeyIVConfiguration: UInt32 = 1
    if handle.read(.keyIVConfigurationSkip) == 0x1 {
      if handle.read(.keyIVConfiguration) == 1 {
        doKeyIVConfiguration = 0
      } else {
        handle.write(.keyIVConfiguration, value: 1)
      }
    }
    if doKeyIVConfiguration == 1 {
      if handle.read(.algorithm) != 0x30 {
        if hasCRYP && isCRYP {
          modify(.cr, clear: 0x80038, set: 0x38)
          if handle.read(.keyIVConfigurationSkip) != 0x2 {
            if handle.read(.keyMode) != 0x2000000 { setKey(handle.read(.keySize)) }
          }
          enable()
          if waitOnBusy(timeout: timeout, getTick: getTick) != .ok {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
          modify(.cr, clear: 0x80038, set: handle.read(.algorithm))
        }
        if hasSAES && isSAES {
          if registers.read(.cr) & (0x1000000 | 0x2000000) != 0 {
            modify(.cr, clear: 0x3000000, set: 0x0)
          }
          modify(.cr, clear: 0x18, set: 0x8)
          if handle.read(.keySelection) == 0x0 && handle.read(.keyMode) == 0x0 {
            if handle.read(.keyIVConfigurationSkip) != 0x2 { setKey(handle.read(.keySize)) }
          }
          enable()
          if waitOnComputationComplete(timeout: timeout, getTick: getTick) != .ok {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
          clearFlags(0x1)
          modify(.cr, clear: 0x18, set: 0x10)
        }
      } else {
        if hasCRYP && isCRYP {
          if handle.read(.keyIVConfigurationSkip) != 0x2 {
            if handle.read(.keyMode) != 0x2000000 {
              setKey(handle.read(.keySize))
            } else {
              modify(.cr, clear: 0x2000000)
            }
          }
        }
        if hasSAES && isSAES { setKey(handle.read(.keySize)) }
      }
      if handle.read(.algorithm) != 0x20 { loadInitialVector() }
    }
    handle.write(.phase, value: 2)
    enable()
    var outputCount = handle.read(.outputCount)
    while UInt32(handle.read(.inputCount)) < UInt32(handle.read(.size)) / 4
      && UInt32(outputCount) < UInt32(handle.read(.size)) / 4
    {
      aesProcessData(timeout: timeout, getTick: getTick)
      outputCount = handle.read(.outputCount)
    }
    disable()
    handle.write(.state, value: 1)
    return .ok
  }
  func aesProcessData(timeout: UInt32, getTick: () -> UInt32) {
    var temporary: InlineArray<4, UInt32> = .init(repeating: 0)
    if hasCRYP && isCRYP {
      let inputCount = handle.read(.inputCount)
      if registers.read(.sr) & 0x2 != 0 && UInt32(inputCount) < UInt32(handle.read(.size)) / 4 {
        registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      }
      if waitOnOutputNotEmpty(timeout: timeout, getTick: getTick) != .ok {
        disable()
        addError(0x10)
        handle.write(.state, value: 1)
        unlock()
        invoke(.error)
      }
      let outputCount = handle.read(.outputCount)
      if registers.read(.sr) & 0x4 != 0 && UInt32(outputCount) < UInt32(handle.read(.size)) / 4 {
        for i in 0..<4 { temporary[i] = registers.read(.dout) }
        var i = 0
        while UInt32(handle.read(.outputCount)) < UInt32(handle.read(.size)) / 4 && i < 4 {
          handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[i]
          handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
          i += 1
        }
      }
    }
    if hasSAES && isSAES {
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      if waitOnComputationComplete(timeout: timeout, getTick: getTick) != .ok {
        disable()
        addError(0x10)
        handle.write(.state, value: 1)
        unlock()
        invoke(.error)
      }
      clearFlags(0x1)
      for i in 0..<4 { temporary[i] = registers.read(.doutr) }
      var i = 0
      while UInt32(handle.read(.outputCount)) < (UInt32(handle.read(.size)) + 3) / 4 && i < 4 {
        handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[i]
        handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
        i += 1
      }
    }
  }
}
