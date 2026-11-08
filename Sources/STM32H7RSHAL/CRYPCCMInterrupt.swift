// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func aesCCMProcessIT(getTick: () -> UInt32) -> HALStatus {
    let timeout: UInt32 = 500
    var tickStart: UInt32
    var loopCounter: UInt32
    var lastWordSize: UInt32
    var paddingBytes: UInt32
    var headerSizeInBytes: UInt32 = 0
    var temporary: UInt32
    var doKeyIVConfiguration: UInt32 = 1
    var mode: UInt32
    let mask: InlineArray<16, UInt32> = [
      0, 0xFF00_0000, 0xFFFF_0000, 0xFFFF_FF00,
      0, 0x0000_FF00, 0x0000_FFFF, 0xFF00_FFFF,
      0, 0x0000_00FF, 0x0000_FFFF, 0x00FF_FFFF,
      0, 0x0000_00FF, 0x0000_FFFF, 0x00FF_FFFF,
    ]
    if useSuspendResume && (handle.read(.phase) == 4 || handle.read(.phase) == 5) {
      phaseProcessingResume()
      return .ok
    }
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

          if getTick() &- tickStart > timeout || timeout == 0 {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
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
      if hasCRYP && isCRYP {
        modify(.cr, clear: 0x30000, set: 0x10000)
        enableInterrupts(1)
        enable()
      }
      if hasSAES && isSAES {
        modify(.cr, clear: 0x6000, set: 0x2000)
        enableInterrupts(1 | 2 | 4)
        enable()
        if handle.read(.headerWidthUnit) == 0 {
          headerSizeInBytes = handle.read(.headerSize) &* 4
        } else {
          headerSizeInBytes = handle.read(.headerSize)
        }
        if headerSizeInBytes == 0 {
          handle.write(.phase, value: 2)
          modify(.cr, clear: 0x6000, set: 0x4000)
          modify(.cr, clear: 0xF00000, set: 0)
          if handle.read(.algorithm) == 0x80008 {
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          }
          if handle.read(.size) == 0 {
            disableInterrupts(1 | 2 | 4)
            handle.write(.state, value: 1)
            unlock()
          } else if handle.read(.size) >= 16 {
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)) &- 1)])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)) &- 1)])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)) &- 1)])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)) &- 1)])
            if UInt32(handle.read(.inputCount)) == UInt32(handle.read(.size)) / 4
              && handle.read(.size) % 16 == 0
            {
              invoke(.inputComplete)
            }
          } else {
            paddingBytes = 16 - UInt32(handle.read(.size))
            mode = crypAlgorithmDirection(registers.read(.cr) & 0x18)
            if (mode == 0 && handle.read(.algorithm) == 0x80000)
              || (mode == 4 && handle.read(.algorithm) == 0x80008)
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
                .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
              handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
              loopCounter &+= 1
            }
            while loopCounter < 4 {
              registers.write(.dinr, value: 0)
              loopCounter &+= 1
            }
            invoke(.inputComplete)
          }
        } else if headerSizeInBytes <= 16 {
          loopCounter = 0
          while loopCounter < headerSizeInBytes / 4 {
            registers.write(
              .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            loopCounter &+= 1
          }
          if headerSizeInBytes % 4 == 0 {
            while loopCounter < 4 {
              registers.write(.dinr, value: 0)
              loopCounter &+= 1
            }
          } else {
            temporary = handle.readPointer(.header)![Int(handle.read(.headerCount))]
            // Preserve the source index; nonzero CRYP data types exceed this table.
            temporary &= mask[Int((handle.read(.dataType) &* 2) &+ (headerSizeInBytes % 4))]
            registers.write(.dinr, value: temporary)
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            loopCounter &+= 1
            while loopCounter < 4 {
              registers.write(.dinr, value: 0)
              loopCounter &+= 1
            }
          }
          invoke(.inputComplete)
        } else {
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)) &- 1)])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)) &- 1)])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)) &- 1)])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)) &- 1)])
        }
      }
    } else {
      if handle.read(.size) == 0 {
        disableInterrupts(1 | 2 | 4)
        handle.write(.state, value: 1)
        unlock()
      } else if handle.read(.size) >= 16 {
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(
          .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)) &- 1)])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(
          .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)) &- 1)])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(
          .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)) &- 1)])
        handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
        registers.write(
          .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)) &- 1)])
        if UInt32(handle.read(.inputCount)) == UInt32(handle.read(.size)) / 4
          && handle.read(.size) % 16 == 0
        {
          invoke(.inputComplete)
        }
      } else {
        paddingBytes = 16 - UInt32(handle.read(.size))
        mode = crypAlgorithmDirection(registers.read(.cr) & 0x18)
        if (mode == 0 && handle.read(.algorithm) == 0x80000)
          || (mode == 4 && handle.read(.algorithm) == 0x80008)
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
            .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          loopCounter &+= 1
        }
        while loopCounter < 4 {
          registers.write(.dinr, value: 0)
          loopCounter &+= 1
        }
        invoke(.inputComplete)
      }
    }
    return .ok
  }
}
