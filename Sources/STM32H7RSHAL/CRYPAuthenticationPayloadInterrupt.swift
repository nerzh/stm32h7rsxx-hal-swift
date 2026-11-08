// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func authenticationPayloadInterrupt() {
    var loopCounter: UInt32
    var temporary: InlineArray<4, UInt32> = .init(repeating: 0)
    var lastWordSize: UInt32
    var paddingBytes: UInt32
    var mode: UInt32
    var negative: UInt8 = 0
    var i: UInt32
    if hasCRYP && isCRYP {
      if UInt32(handle.read(.size)) / 4 < UInt32(handle.read(.inputCount)) { negative = 1 }
      if handle.read(.size) == 0 {
        disableInterrupts(0x1 | 0x2)
        unlock()
        handle.write(.state, value: 1)
      } else if (UInt32(handle.read(.size)) / 4) &- UInt32(handle.read(.inputCount)) >= 4
        && negative == 0
      {
        if registers.read(.imscr) & 0x1 != 0 {
          if useSuspendResume && handle.read(.suspendRequest) == 1 {
            while registers.read(.sr) & (0x1 | 0x4 | 0x10) != 0x1 {}
            disableInterrupts(0x1 | 0x2)
            disable()
            handle.write(.suspendRequest, value: 0)
            handle.write(.state, value: 3)
            handle.write(.phase, value: 5)
            unlock()
          } else {
            registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)

            if UInt32(handle.read(.size)) / 4 == UInt32(handle.read(.inputCount))
              && handle.read(.size) % 16 == 0
            {
              disableInterrupts(0x1)
              invoke(.inputComplete)
            }
            if UInt32(handle.read(.outputCount)) < UInt32(handle.read(.size)) / 4 {
              if registers.read(.sr) & 0x4 != 0 {
                for index in 0..<4 { temporary[index] = registers.read(.dout) }
                i = 0
                while UInt32(handle.read(.outputCount)) < UInt32(handle.read(.size)) / 4 && i < 4 {
                  handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[Int(i)]
                  handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
                  i &+= 1
                }

                if UInt32(handle.read(.size)) / 4 == UInt32(handle.read(.outputCount))
                  && handle.read(.size) % 16 == 0
                {
                  disableInterrupts(0x2)
                  handle.write(.state, value: 1)
                  disable()
                  unlock()
                  invoke(.outputComplete)
                }
              }
            }
          }
        }
      } else if handle.read(.size) % 16 != 0 {
        if registers.read(.imscr) & 0x1 != 0 {
          paddingBytes = ((UInt32(handle.read(.size)) / 16 + 1) * 16) - UInt32(handle.read(.size))
          mode = registers.read(.cr) & 0x4
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
            lastWordSize = (16 - paddingBytes) / 4 + 1
          }
          loopCounter = 0
          while loopCounter < lastWordSize {
            registers.write(.din, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            loopCounter &+= 1
          }
          while loopCounter < 4 {
            registers.write(.din, value: 0)
            loopCounter &+= 1
          }
          disableInterrupts(0x1)
        }
        if registers.read(.sr) & 0x4 != 0 {
          for index in 0..<4 { temporary[index] = registers.read(.dout) }
          if UInt32(handle.read(.size)) / 4 == 0 {
            i = 0
            while UInt16(truncatingIfNeeded: i) < handle.read(.size) % 4 {
              handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[Int(i)]
              handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
              i &+= 1
            }
          }
          i = 0
          while UInt32(handle.read(.outputCount)) < UInt32(handle.read(.size)) / 4 && i < 4 {
            handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[Int(i)]
            handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
            i &+= 1
          }

        }
        if UInt32(handle.read(.outputCount)) >= UInt32(handle.read(.size)) / 4 {
          disableInterrupts(0x2 | 0x1)
          handle.write(.state, value: 1)
          unlock()
          invoke(.outputComplete)
        }
      }
    }
    if hasSAES && isSAES {
      for index in 0..<4 { temporary[index] = registers.read(.doutr) }
      i = 0
      while UInt32(handle.read(.outputCount)) < (UInt32(handle.read(.size)) + 3) / 4 && i < 4 {
        handle.readPointer(.output)![Int(handle.read(.outputCount))] = temporary[Int(i)]
        handle.write(.outputCount, value: handle.read(.outputCount) &+ 1)
        i &+= 1
      }

      let inputCount = UInt32(handle.read(.inputCount))
      let outputCount = UInt32(handle.read(.outputCount))
      if outputCount >= UInt32(handle.read(.size)) / 4
        && inputCount * 4 >= UInt32(handle.read(.size))
      {
        if !(handle.read(.algorithm) == 0x80008 && handle.read(.keyIVConfiguration) == 1) {
          disableInterrupts(0x1 | 0x2 | 0x4)
        }
        handle.write(.state, value: 1)
        unlock()
        invoke(.outputComplete)
      } else if (UInt32(handle.read(.size)) / 4) &- UInt32(handle.read(.inputCount)) >= 4 {
        if useSuspendResume && handle.read(.suspendRequest) == 1 {
          clearFlags(0x1)
          handle.write(.suspendRequest, value: 0)
          disableInterrupts(0x1 | 0x2 | 0x4)
          handle.write(.state, value: 3)
          handle.write(.phase, value: 5)
          unlock()
        } else {
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)

          if handle.read(.inputCount) == handle.read(.size) && handle.read(.algorithm) == 0x80000 {
            invoke(.inputComplete)
          }
        }
      } else {
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
          lastWordSize = (16 - paddingBytes) / 4 + 1
        }
        loopCounter = 0
        while loopCounter < lastWordSize {
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          loopCounter &+= 1
        }
        while loopCounter < 4 {
          registers.write(.dinr, value: 0)
          loopCounter &+= 1
        }
      }
    }
  }
}
