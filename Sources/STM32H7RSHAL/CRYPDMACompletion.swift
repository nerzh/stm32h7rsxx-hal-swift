// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  public func dmaOutputComplete() {
    var count: UInt32
    var paddingBytes: UInt32
    var lastWordSize: UInt32
    var temporary: UInt32
    var mode: UInt32
    if hasCRYP && isCRYP { modify(.dmacr, clear: 0x2) }
    if hasSAES && isSAES {
      modify(.cr, clear: 0x1000)
      modify(.cr, clear: 0x1000)
    }
    if hasCRYP && isCRYP {
      if handle.read(.size) % 16 != 0 {
        handle.write(.inputCount, value: (handle.read(.size) / 16) * 4)
        handle.write(.outputCount, value: handle.read(.inputCount))
        paddingBytes = ((UInt32(handle.read(.size)) / 16 + 1) * 16) - UInt32(handle.read(.size))
        mode = crypAlgorithmDirection(registers.read(.cr) & 0x18)
        if (mode == 0x0 && handle.read(.algorithm) == 0x80000)
          || (mode == 0x4 && handle.read(.algorithm) == 0x80008)
        {
          disable()
          modify(.cr, clear: 0xF00000, set: paddingBytes << 20)
          enable()
        }
        if paddingBytes % 4 == 0 {
          lastWordSize = (16 - paddingBytes) / 4
        } else {
          lastWordSize = ((16 - paddingBytes) / 4) + 1
        }
        count = 0
        while count < lastWordSize {
          registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          count &+= 1
        }
        while count < 4 {
          registers.write(.din, value: 0)
          count &+= 1
        }
        count = 290
        repeat {
          count &-= 1
          if count == 0 {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            invoke(.error)
          }
        } while registers.read(.sr) & 0x4 == 0
        for _ in 0..<4 {
          temporary = registers.read(.dout)
          handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary
          handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
        }
      }
    }
    if hasSAES && isSAES {
      temporary = 0
      if handle.read(.size) % 16 != 0 {
        handle.write(.inputCount, value: (handle.read(.size) / 16) * 4)
        handle.write(.outputCount, value: handle.read(.inputCount))
        paddingBytes = ((UInt32(handle.read(.size)) / 16 + 1) * 16) - UInt32(handle.read(.size))
        mode = crypAlgorithmDirection(registers.read(.cr) & 0x18)
        if (mode == 0x0 && handle.read(.algorithm) == 0x80000)
          || (mode == 0x4 && handle.read(.algorithm) == 0x80008)
        {
          modify(.cr, clear: 0xF00000, set: paddingBytes << 20)
        }
        if paddingBytes % 4 == 0 {
          lastWordSize = (16 - paddingBytes) / 4
        } else {
          lastWordSize = ((16 - paddingBytes) / 4) + 1
        }
        count = 0
        while count < lastWordSize {
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          count &+= 1
        }
        while count < 4 {
          registers.write(.dinr, value: 0)
          count &+= 1
        }
        clearFlags(0x1)
        for _ in 0..<4 { temporary = registers.read(.doutr) }
        count = 0
        while UInt32(handle.read(.outputCount)) < (UInt32(handle.read(.size)) + 3) / 4 && count < 4
        {
          handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary
          handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
          count &+= 1
        }
      }
    }
    if handle.read(.algorithm) & 0x80000 != 0x80000 && handle.read(.algorithm) & 0x80008 != 0x80008
    {
      disable()
    }
    handle.write(.state, value: 1)
    unlock()
    invoke(.outputComplete)
  }
}
