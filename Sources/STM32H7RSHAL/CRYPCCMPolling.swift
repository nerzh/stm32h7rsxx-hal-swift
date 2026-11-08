// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func aesCCMProcess(timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    var tickStart: UInt32
    var wordSize = UInt32(handle.read(.size)) / 4
    var paddingBytes: UInt32
    var temporary: InlineArray<4, UInt32> = .init(repeating: 0)
    var index: UInt32
    var lastWordSize: UInt32
    var outputCount: UInt32
    var doKeyIVConfiguration: UInt32 = 1
    var mode: UInt32
    if handle.read(.keyIVConfigurationSkip) == 0x1 {
      if handle.read(.keyIVConfiguration) == 1 {
        doKeyIVConfiguration = 0
        handle.write(.sizesSum, value: handle.read(.sizesSum) &+ UInt32(handle.read(.size)))
      } else {
        handle.write(.keyIVConfiguration, value: 1)
        handle.write(.sizesSum, value: UInt32(handle.read(.size)))
      }
    } else {
      handle.write(.sizesSum, value: UInt32(handle.read(.size)))
    }
    if doKeyIVConfiguration == 1 {
      handle.write(.headerCount, value: 0)
      if hasCRYP && isCRYP {
        modify(.cr, clear: 0x30000, set: 0)
        if handle.read(.keyIVConfigurationSkip) != 0x2 {
          if handle.read(.keyMode) != 0x2000000 {
            setKey(handle.read(.keySize))
          } else {
            modify(.cr, clear: 0x2000000)
          }
        }
        registers.write(.iv0lr, value: handle.readPointer(.b0)![0] & 0x07FF_FFFF)
        registers.write(.iv0rr, value: handle.readPointer(.b0)![1])
        registers.write(.iv1lr, value: handle.readPointer(.b0)![2])
        registers.write(.iv1rr, value: (handle.readPointer(.b0)![3] & 0xFFFF_FF00) | 1)
        enable()
        registers.write(.din, value: handle.readPointer(.b0)![0])
        registers.write(.din, value: handle.readPointer(.b0)![1])
        registers.write(.din, value: handle.readPointer(.b0)![2])
        registers.write(.din, value: handle.readPointer(.b0)![3])
        tickStart = getTick()
        while registers.read(.cr) & 0x8000 == 0x8000 {
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
      }
      if hasSAES && isSAES {
        modify(.cr, clear: 0x6000, set: 0)
        if handle.read(.keySelection) == 0x0 && handle.read(.keyMode) == 0x0 {
          setKey(handle.read(.keySize))
        }
        registers.write(.ivr3, value: handle.readPointer(.b0)![0])
        registers.write(.ivr2, value: handle.readPointer(.b0)![1])
        registers.write(.ivr1, value: handle.readPointer(.b0)![2])
        registers.write(.ivr0, value: handle.readPointer(.b0)![3])
        enable()
        if waitOnComputationComplete(timeout: timeout, getTick: getTick) != .ok {
          disable()
          addError(0x10)
          handle.write(.state, value: 1)
          unlock()
          return .error
        }
        clearFlags(0x1)
      }
      if authenticationHeaderPhase(timeout: timeout, getTick: getTick) != .ok { return .error }
      handle.write(.phase, value: 2)
      if hasCRYP && isCRYP {
        disable()
        modify(.cr, clear: 0xF00000, set: 0)
        modify(.cr, clear: 0x30000, set: 0x20000)
        enable()
      }
      if hasSAES && isSAES {
        modify(.cr, clear: 0xF00000, set: 0)
        modify(.cr, clear: 0x6000, set: 0x4000)
      }
    }
    if handle.read(.size) % 16 != 0 { wordSize = (wordSize / 4) * 4 }
    tickStart = getTick()
    outputCount = UInt32(handle.read(.outputCount))
    while UInt32(handle.read(.inputCount)) < wordSize && outputCount < wordSize {
      aesProcessData(timeout: timeout, getTick: getTick)
      outputCount = UInt32(handle.read(.outputCount))
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
    if hasCRYP && isCRYP {
      if handle.read(.size) % 16 != 0 {
        paddingBytes = ((UInt32(handle.read(.size)) / 16 + 1) * 16) - UInt32(handle.read(.size))
        mode = registers.read(.cr) & 0x4
        if mode == 0x4 {
          disable()
          modify(.cr, clear: 0xF00000, set: paddingBytes << 20)
          enable()
        }
        if paddingBytes % 4 == 0 {
          lastWordSize = (16 - paddingBytes) / 4
        } else {
          lastWordSize = ((16 - paddingBytes) / 4) + 1
        }
        index = 0
        while index < lastWordSize {
          registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          index &+= 1
        }
        while index < 4 {
          registers.write(.din, value: 0)
          index &+= 1
        }
        if waitOnOutputNotEmpty(timeout: timeout, getTick: getTick) != .ok {
          disable()
          addError(0x10)
          handle.write(.state, value: 1)
          unlock()
          invoke(.error)
        }
        if registers.read(.sr) & 0x4 != 0 {
          for i in 0..<4 { temporary[i] = registers.read(.dout) }
          index = 0
          while index < lastWordSize {
            handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[Int(index)]
            handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
            index &+= 1
          }
        }
      }
    }
    if hasSAES && isSAES {
      if handle.read(.size) % 16 != 0 {
        paddingBytes = ((UInt32(handle.read(.size)) / 16 + 1) * 16) - UInt32(handle.read(.size))
        mode = crypAlgorithmDirection(registers.read(.cr) & 0x18)
        if mode == 0x4 {
          modify(.cr, clear: 0xF00000, set: paddingBytes << 20)
        }
        if paddingBytes % 4 == 0 {
          lastWordSize = (16 - paddingBytes) / 4
        } else {
          lastWordSize = ((16 - paddingBytes) / 4) + 1
        }
        index = 0
        while index < lastWordSize {
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          index &+= 1
        }
        while index < 4 {
          registers.write(.dinr, value: 0)
          index &+= 1
        }
        if waitOnComputationComplete(timeout: timeout, getTick: getTick) != .ok {
          disable()
          addError(0x10)
          handle.write(.state, value: 1)
          unlock()
          invoke(.error)
        }
        clearFlags(0x1)
        for i in 0..<4 { temporary[i] = registers.read(.doutr) }
        index = 0
        while index < lastWordSize {
          handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[Int(index)]
          handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
          index &+= 1
        }
      }
    }
    if waitOnBusy(timeout: timeout, getTick: getTick) != .ok {
      disable()
      addError(0x10)
      handle.write(.state, value: 1)
      unlock()
      return .error
    }
    return .ok
  }
}
