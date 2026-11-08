// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func authenticationHeaderInterrupt() {
    var loopCounter: UInt32
    var lastWordSize: UInt32
    var paddingBytes: UInt32
    var mode: UInt32
    let mask: InlineArray<16, UInt32> = [
      0, 0xFF00_0000, 0xFFFF_0000, 0xFFFF_FF00,
      0, 0x0000_FF00, 0x0000_FFFF, 0xFF00_FFFF,
      0, 0x0000_00FF, 0x0000_FFFF, 0x00FF_FFFF,
      0, 0x0000_00FF, 0x0000_FFFF, 0x00FF_FFFF,
    ]
    if hasCRYP && isCRYP {
      if handle.read(.headerSize) == UInt32(handle.read(.headerCount)) {
        disableInterrupts(0x1)
        disable()
        modify(.cr, clear: 0xF00000, set: 0)
        handle.write(.phase, value: 2)
        modify(.cr, clear: 0x30000, set: 0x20000)
        enableInterrupts(0x1 | 0x2)
        enable()
      } else if handle.read(.headerSize) &- UInt32(handle.read(.headerCount)) >= 4 {
        registers.write(.din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
        handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
        registers.write(.din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
        handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
        registers.write(.din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
        handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
        registers.write(.din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
        handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)

      } else {
        loopCounter = 0
        while loopCounter < handle.read(.headerSize) % 4 {
          registers.write(.din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          loopCounter &+= 1
        }
        while loopCounter < 4 {
          registers.write(.din, value: 0)
          loopCounter &+= 1
        }
      }
    }
    if hasSAES && isSAES {
      let headerSizeInBytes: UInt32
      if handle.read(.headerWidthUnit) == 0x0 {
        headerSizeInBytes = handle.read(.headerSize) &* 4
      } else {
        headerSizeInBytes = handle.read(.headerSize)
      }
      if headerSizeInBytes <= UInt32(handle.read(.headerCount)) * 4 {
        handle.write(.phase, value: 2)
        modify(.cr, clear: 0x6000, set: 0x4000)
        modify(.cr, clear: 0xF00000, set: 0)
        if handle.read(.algorithm) == 0x80008 {
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
        }
        if handle.read(.size) == 0 {
          disableInterrupts(0x1 | 0x2 | 0x4)
          handle.write(.state, value: 1)
          unlock()
        } else if handle.read(.size) >= 16 {
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(.dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)

          if UInt32(handle.read(.inputCount)) == UInt32(handle.read(.size)) / 4
            && handle.read(.size) % 16 == 0
          {
            invoke(.inputComplete)
          }
        } else {
          paddingBytes = 16 - UInt32(handle.read(.size))
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
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(handle.read(.inputCount))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            loopCounter &+= 1
          }
          while loopCounter < 4 {
            registers.write(.dinr, value: 0)
            loopCounter &+= 1
          }
          invoke(.inputComplete)
        }
      } else if (headerSizeInBytes / 4) &- UInt32(handle.read(.headerCount)) >= 4 {
        if useSuspendResume && handle.read(.suspendRequest) == 1 {
          clearFlags(0x1)
          handle.write(.suspendRequest, value: 0)
          disableInterrupts(0x1 | 0x2 | 0x4)
          handle.write(.state, value: 3)
          handle.write(.phase, value: 4)
          unlock()
        } else {
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)

        }
      } else {
        loopCounter = 0
        while loopCounter < (headerSizeInBytes / 4) % 4 {
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          loopCounter &+= 1
        }
        if headerSizeInBytes % 4 == 0 {
          while loopCounter < 4 {
            registers.write(.dinr, value: 0)
            loopCounter &+= 1
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          }
        } else {
          var temporary = handle.readPointer(.header)![Int(handle.read(.headerCount))]
          temporary &=
            mask[Int((saesDataType(handle.read(.dataType)) &* 2) &+ (headerSizeInBytes % 4))]
          registers.write(.dinr, value: temporary)
          loopCounter &+= 1
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          while loopCounter < 4 {
            registers.write(.dinr, value: 0)
            loopCounter &+= 1
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          }
        }
      }
    }
  }
}
