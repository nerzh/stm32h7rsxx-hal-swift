// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func aesEncryptIT(getTick: () -> UInt32) -> HALStatus {
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
        if getTick() &- start > 500 {
          disable()
          addError(0x10)
          handle.write(.state, value: 1)
          unlock()
          return .error
        }
      }
      if hasCRYP && isCRYP {
        if handle.read(.keyMode) == 0x2000000 { modify(.cr, clear: 0x3000000) }
      }
      if handle.read(.algorithm) != 0x20 { loadInitialVector() }
    }
    handle.write(.phase, value: 2)
    if handle.read(.size) != 0 {
      enable()
      if hasSAES && isSAES {
        registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      }
      if hasCRYP && isCRYP { enableInterrupts(0x1 | 0x2) }
      if hasSAES && isSAES { enableInterrupts(0x1 | 0x2 | 0x4 | 0x8) }
    } else {
      handle.write(.state, value: 1)
      unlock()
    }
    return .ok
  }
  func aesDecryptIT(getTick: () -> UInt32) -> HALStatus {
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
            if handle.read(.keyMode) != 0x2000000 {
              setKey(handle.read(.keySize))
            } else {
              modify(.cr, clear: 0x2000000)
            }
          }
          enable()
          if waitOnBusy(timeout: 500, getTick: getTick) != .ok {
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
          if waitOnComputationComplete(timeout: 500, getTick: getTick) != .ok {
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
    if handle.read(.size) != 0 {
      enable()
      if hasSAES && isSAES {
        registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
      }
      if hasCRYP && isCRYP { enableInterrupts(0x1 | 0x2) }
      if hasSAES && isSAES { enableInterrupts(0x1 | 0x2 | 0x4 | 0x8) }
    } else {
      unlock()
      handle.write(.state, value: 1)
    }
    return .ok
  }
  func aesInterrupt() {
    var temporary: InlineArray<4, UInt32> = .init(repeating: 0)
    if handle.read(.state) == 2 {
      if hasCRYP && isCRYP {
        if useSuspendResume && handle.read(.suspendRequest) == 1 {
          while registers.read(.sr) & (0x1 | 0x4 | 0x10) != 0x1 {}
          disableInterrupts(0x1 | 0x2)
          disable()
          handle.write(.suspendRequest, value: 0)
          handle.write(.state, value: 3)
          unlock()
        } else {
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
            if UInt32(handle.read(.inputCount)) == UInt32(handle.read(.size)) / 4 {
              disableInterrupts(0x1)
              invoke(.inputComplete)
            }
          }
          let outputCount = handle.read(.outputCount)
          if registers.read(.sr) & 0x4 != 0 && UInt32(outputCount) < UInt32(handle.read(.size)) / 4
          {
            for i in 0..<4 { temporary[i] = registers.read(.dout) }
            var i = 0
            while UInt32(handle.read(.outputCount)) < UInt32(handle.read(.size)) / 4 && i < 4 {
              handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[i]
              handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
              i += 1
            }
            if UInt32(handle.read(.outputCount)) == UInt32(handle.read(.size)) / 4 {
              disableInterrupts(0x2)
              handle.write(.state, value: 1)
              disable()
              unlock()
              invoke(.outputComplete)
            }
          }
        }
      }
      if hasSAES && isSAES {
        for i in 0..<4 { temporary[i] = registers.read(.doutr) }
        var i = 0
        while UInt32(handle.read(.outputCount)) < (UInt32(handle.read(.size)) + 3) / 4 && i < 4 {
          handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[i]
          handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
          i += 1
        }
        if UInt32(handle.read(.outputCount)) == UInt32(handle.read(.size)) / 4 {
          disableInterrupts(0x1 | 0x2 | 0x4)
          handle.write(.state, value: 1)
          disable()
          unlock()
          invoke(.outputComplete)
        } else {
          if useSuspendResume && handle.read(.suspendRequest) == 1 {
            clearFlags(0x1)
            handle.write(.suspendRequest, value: 0)
            disableInterrupts(0x1 | 0x2 | 0x4)
            handle.write(.state, value: 3)
            handle.write(.phase, value: 5)
            unlock()
          } else {
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            if UInt32(handle.read(.inputCount)) == UInt32(handle.read(.size)) / 4 {
              invoke(.inputComplete)
            }
          }
        }
      }
    } else {
      unlock()
      addError(0x8)
      invoke(.error)
    }
  }
}
