// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func authenticationHeaderPhaseDMA(getTick: () -> UInt32) -> HALStatus {
    var timeout: UInt32 = 290
    var loopCounter: UInt32
    let mask: InlineArray<16, UInt32> = [
      0, 0xFF00_0000, 0xFFFF_0000, 0xFFFF_FF00,
      0, 0x0000_FF00, 0x0000_FFFF, 0xFF00_FFFF,
      0, 0x0000_00FF, 0x0000_FFFF, 0x00FF_FFFF,
      0, 0x0000_00FF, 0x0000_FFFF, 0x00FF_FFFF,
    ]
    if handle.read(.headerSize) != 0 {
      if hasCRYP && isCRYP {
        modify(.cr, clear: 0x30000, set: 0x10000)
        enable()
        if handle.read(.headerSize) % 4 == 0 {
          loopCounter = 0
          while loopCounter < handle.read(.headerSize) {
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            if waitOnInputEmpty(timeout: timeout, getTick: getTick) != .ok {
              disable()
              addError(0x10)
              handle.write(.state, value: 1)
              unlock()
              return .error
            }
            loopCounter &+= 4
          }

        } else {
          loopCounter = 0
          while loopCounter < handle.read(.headerSize) &- (handle.read(.headerSize) % 4) {
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            if waitOnInputEmpty(timeout: timeout, getTick: getTick) != .ok {
              disable()
              addError(0x10)
              handle.write(.state, value: 1)
              unlock()
              return .error
            }
            loopCounter &+= 4
          }

          loopCounter = 0
          while loopCounter < handle.read(.headerSize) % 4 {
            registers.write(
              .din, value: handle.readPointer(.header)![Int(handle.read(.headerCount))])
            handle.write(.headerCount, value: handle.read(.headerCount) &+ 1)
            loopCounter &+= 1
          }
          while loopCounter < 4 {
            registers.write(.din, value: 0)
            loopCounter &+= 1
          }
          if waitOnInputEmpty(timeout: timeout, getTick: getTick) != .ok {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
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
        modify(.cr, clear: 0x6000, set: 0x2000)
        enable()
        if headerSizeInBytes % 16 == 0 {
          loopCounter = 0
          while loopCounter < handle.read(.headerSize) {
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
            if waitOnComputationComplete(timeout: timeout, getTick: getTick) != .ok {
              disable()
              addError(0x10)
              handle.write(.state, value: 1)
              unlock()
              return .error
            }
            loopCounter &+= 4
          }

        } else {
          loopCounter = 0
          while loopCounter < (headerSizeInBytes / 16) &* 4 {
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
            if waitOnComputationComplete(timeout: timeout, getTick: getTick) != .ok {
              disable()
              addError(0x10)
              handle.write(.state, value: 1)
              unlock()
              return .error
            }
            loopCounter &+= 4
          }

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
            }
          } else {
            var temporary = handle.readPointer(.header)![Int(handle.read(.headerCount))]
            temporary &=
              mask[Int((saesDataType(handle.read(.dataType)) &* 2) &+ (headerSizeInBytes % 4))]
            registers.write(.dinr, value: temporary)
            loopCounter &+= 1
            while loopCounter < 4 {
              registers.write(.dinr, value: 0)
              loopCounter &+= 1
            }
          }
          if waitOnComputationComplete(timeout: timeout, getTick: getTick) != .ok {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
        }
      }
      timeout = 500
      if waitOnBusy(timeout: timeout, getTick: getTick) != .ok {
        disable()
        addError(0x10)
        handle.write(.state, value: 1)
        unlock()
        return .error
      }
    }
    return .ok
  }
}
