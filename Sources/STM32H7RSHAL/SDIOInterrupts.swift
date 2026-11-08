// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDIO {
  public func interruptHandler(getSystemCoreClock: () -> UInt32) {
    var CMD53_desc: SDIOExtendedCommand = .init()
    var errorstate: HALStatus = .ok
    var ctx: UInt32 = 0
    var flags: UInt32 = 0

    ctx = handle.read(.transferContext)

    flags = registers.read(.sta)
    if (flags & 0x400000) != 0 {
      _ = ioFunctionInterruptHandler(getSystemCoreClock: getSystemCoreClock)
    }
    if (flags & 0x100) != 0 {
      sdmmc.clearFlag(0x100)
      handle.write(.state, value: 0x1)
      sdmmc.disableInterrupts(0x100 | 0x2 | 0x8 | 0x10 | 0x20 | 0x4000 | 0x8000)
      sdmmc.disableInterrupts(0x1000_0000)
      sdmmc.disableCommandTransfer()
      if (ctx & 0x80) != 0 {
        registers.write(.dlen, value: 0)
        registers.write(.idmactrl, value: 0x0)
        if (registers.read(.dctrl) & 0x800) != 0 {
          registers.write(.dctrl, value: 0x800)
        } else {
          registers.write(.dctrl, value: 0)
        }
        handle.write(.transferContext, value: 0x0)
      }
      if handle.read(.remainingData) != 0 {
        CMD53_desc.blockMode = 0x0
        CMD53_desc.registerAddress = handle.read(.nextRegisterAddress)
        CMD53_desc.ioFunctionNumber = 1
        CMD53_desc.operationCode = 1
        if ((ctx & 0x1) != 0) || ((ctx & 0x2) != 0) {
          handle.writeReceiveBuffer(
            UnsafeMutablePointer<UInt8>(bitPattern: UInt(handle.read(.nextDataAddress))))
          errorstate = readExtendedDMA(
            &CMD53_desc, handle.readReceiveBuffer(), handle.read(.remainingData),
            getSystemCoreClock: getSystemCoreClock)
        } else {
          handle.writeTransmitBuffer(
            UnsafeMutablePointer<UInt8>(bitPattern: UInt(handle.read(.nextDataAddress))))
          errorstate = writeExtendedDMA(
            &CMD53_desc, handle.readTransmitBuffer(), handle.read(.remainingData),
            getSystemCoreClock: getSystemCoreClock)
        }
        if errorstate != .ok {
          if useRegisteredCallbacks {
            callbacks.read(.error)!(callbacks.context)
          } else {
            defaults.error(callbacks.context)
          }
        }
      } else if ((ctx & 0x1) != 0) || ((ctx & 0x2) != 0) {
        if useRegisteredCallbacks {
          callbacks.read(.receiveComplete)!(callbacks.context)
        } else {
          defaults.receiveComplete(callbacks.context)
        }
      } else {
        if useRegisteredCallbacks {
          callbacks.read(.transmitComplete)!(callbacks.context)
        } else {
          defaults.transmitComplete(callbacks.context)
        }
      }
    }
    if sdmmc.getFlag(0x2 | 0x8 | 0x20 | 0x10) {
      if useRegisteredCallbacks {
        callbacks.read(.error)!(callbacks.context)
      } else {
        defaults.error(callbacks.context)
      }
    }

  }
  func ioFunctionInterruptHandler(getSystemCoreClock: () -> UInt32) -> HALStatus {
    var count: UInt8 = 0
    var pendingInt: UInt8 = 0

    if UInt32(handle.read(.ioInterruptCount)) == 1 {
      if (callbacks.readIOFunction(UInt32(handle.read(.ioFunctionMask)) &- 1)) != nil {
        callbacks.readIOFunction(UInt32(handle.read(.ioFunctionMask)) &- 1)!(
          callbacks.context, UInt32(handle.read(.ioFunctionMask)) &- 1)
      }
    } else if (UInt32(handle.read(.ioInterruptCount)) > 1)
      && (UInt32(handle.read(.ioFunctionMask)) != 0)
    {
      if readDirectByte(0x5, 0x0, 0x0, &pendingInt, getSystemCoreClock: getSystemCoreClock) != .ok {
        return .error
      }
      if (UInt32(pendingInt) != 0) && (UInt32(handle.read(.ioFunctionMask)) != 0) {
        count = UInt8(truncatingIfNeeded: 1)
        while UInt32(count) <= 0x7 {
          if ((UInt32(pendingInt) & (1 << UInt32(count))) != 0)
            && (((1 << UInt32(count)) & UInt32(handle.read(.ioFunctionMask))) != 0)
          {
            if (callbacks.readIOFunction(UInt32(UInt32(count)) &- 1)) != nil {
              callbacks.readIOFunction(UInt32(count) &- 1)!(callbacks.context, UInt32(count))
            }
          }
          count = UInt8(truncatingIfNeeded: UInt32(UInt32(count)) &+ (1))
        }
      }
    } else {
    }
    return .ok

  }
}
