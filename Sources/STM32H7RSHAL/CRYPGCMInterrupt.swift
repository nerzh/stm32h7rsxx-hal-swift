// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func aesGCMProcessIT(getTick: () -> UInt32) -> HALStatus {
    let timeout: UInt32 = 500
    var tickStart: UInt32
    var loopCounter: UInt32
    var lastWordSize: UInt32
    var paddingBytes: UInt32
    var headerSizeInBytes: UInt32 = 0
    var temporary: UInt32
    var doKeyIVConfiguration: UInt32 = 1
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
    if hasSAES {
      if handle.read(.headerWidthUnit) == 0 {
        headerSizeInBytes = handle.read(.headerSize) &* 4
      } else {
        headerSizeInBytes = handle.read(.headerSize)
      }
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
        loadInitialVector()
        enable()
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
        } else {
          modify(.cr, clear: 0x2000000)
        }
        loadInitialVector()
        enable()
        var count: UInt32 = 82
        repeat {
          count &-= 1
          if count == 0 {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
        } while registers.read(.sr) & 0x80 == 0
        count = 299
        repeat {
          count &-= 1
          if count == 0 {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
        } while registers.read(.sr) & 0x1 == 0
        clearFlags(0x1)
      }
      if hasCRYP && isCRYP {
        modify(.cr, clear: 0x30000, set: 0x10000)
      }
      if hasSAES && isSAES {
        modify(.cr, clear: 0x6000, set: 0x2000)
        enable()
        if headerSizeInBytes == 0 {
          handle.write(.phase, value: 2)
          modify(.cr, clear: 0x6000, set: 0x4000)
          modify(.cr, clear: 0xF00000, set: 0)
          if handle.read(.size) == 0 {
            disableInterrupts(1 | 2 | 4)
            handle.write(.state, value: 1)
            unlock()
          } else if handle.read(.size) >= 16 {
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            registers.write(
              .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
            handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
            if UInt32(handle.read(.inputCount)) == UInt32(handle.read(.size)) / 4
              && handle.read(.size) % 16 == 0
            {
              invoke(.inputComplete)
            }
            enableInterrupts(1 | 2 | 4)
          } else {
            paddingBytes = 16 - UInt32(handle.read(.size))
            if registers.read(.cr) & 0x18 == 0 {
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
            enableInterrupts(1 | 2 | 4)
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
              handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            }
          } else {
            temporary = handle.readPointer(.header)![Int(handle.read(.headerCount))]
            // Preserve the source index; nonzero CRYP data types exceed this table.
            temporary &= mask[Int((handle.read(.dataType) &* 2) &+ (headerSizeInBytes % 4))]
            registers.write(.dinr, value: temporary)
            loopCounter &+= 1
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            while loopCounter < 4 {
              registers.write(.dinr, value: 0)
              loopCounter &+= 1
              handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            }
          }
          invoke(.inputComplete)
        } else {
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.header)![Int(UInt32(handle.read(.headerCount)))])
          handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
        }
      }
    } else {
      if hasSAES && isSAES {
        enableInterrupts(1 | 2 | 4)
        modify(.cr, clear: 0xF00000, set: 0)
        if handle.read(.size) == 0 {
          disableInterrupts(1 | 2 | 4)
          handle.write(.state, value: 1)
          unlock()
        } else if handle.read(.size) >= 16 {
          registers.write(
            .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          registers.write(
            .dinr, value: handle.readPointer(.input)![Int(UInt32(handle.read(.inputCount)))])
          handle.write(.inputCount, value: handle.read(.inputCount) &+ 1)
          if UInt32(handle.read(.inputCount)) == UInt32(handle.read(.size)) / 4 {
            invoke(.inputComplete)
          }
        } else {
          paddingBytes = 16 - UInt32(handle.read(.size))
          if registers.read(.cr) & 0x18 == 0 {
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
        }
      }
    }
    if hasCRYP && isCRYP {
      modify(.cr, clear: 0x30000, set: 0x10000)
      enableInterrupts(1)
      enable()
    }
    return .ok
  }
}
