// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SD/SDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SD {
  public func interruptHandler(getSystemCoreClock: () -> UInt32) {
    var errorstate: UInt32 = 0
    var context: UInt32 = 0

    context = handle.read(.transferContext)

    if (sdmmc.getFlag(0x8000)) && ((context & 0x8) != 0) {
      readInterruptData()
    } else if sdmmc.getFlag(0x100) {
      sdmmc.clearFlag(0x100)
      sdmmc.disableInterrupts(0x100 | 0x2 | 0x8 | 0x10 | 0x20 | 0x4000 | 0x8000)
      sdmmc.disableInterrupts(0x1000_0000)
      sdmmc.disableCommandTransfer()
      if (context & 0x8) != 0 {
        if ((context & 0x2) != 0) || ((context & 0x20) != 0) {
          errorstate = sdmmc.commandStopTransfer(getSystemCoreClock: getSystemCoreClock)
          if errorstate != 0x0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
            if useRegisteredCallbacks {
              callbacks.read(.error)!(callbacks.context)
            } else {
              defaults.error(callbacks.context)
            }
          }
        }

        sdmmc.clearFlag(0x1800_0f3a)
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        if ((context & 0x1) != 0) || ((context & 0x2) != 0) {
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
      } else if (context & 0x80) != 0 {
        registers.write(.dlen, value: 0)
        registers.write(.dctrl, value: 0)
        registers.write(.idmactrl, value: 0x0)

        if ((context & 0x2) != 0) || ((context & 0x20) != 0) {
          errorstate = sdmmc.commandStopTransfer(getSystemCoreClock: getSystemCoreClock)
          if errorstate != 0x0 {
            handle.write(.errorCode, value: handle.read(.errorCode) | (errorstate))
            if useRegisteredCallbacks {
              callbacks.read(.error)!(callbacks.context)
            } else {
              defaults.error(callbacks.context)
            }
          }
        }
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        if ((context & 0x10) != 0) || ((context & 0x20) != 0) {
          if useRegisteredCallbacks {
            callbacks.read(.transmitComplete)!(callbacks.context)
          } else {
            defaults.transmitComplete(callbacks.context)
          }
        }
        if ((context & 0x1) != 0) || ((context & 0x2) != 0) {
          if useRegisteredCallbacks {
            callbacks.read(.receiveComplete)!(callbacks.context)
          } else {
            defaults.receiveComplete(callbacks.context)
          }
        }
      } else {
      }
    } else if (sdmmc.getFlag(0x4000)) && ((context & 0x8) != 0) {
      writeInterruptData()
    } else if sdmmc.getFlag(0x2 | 0x8 | 0x20 | 0x10) {
      if sdmmc.getFlag(0x2) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x2))
      }
      if sdmmc.getFlag(0x8) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x8))
      }
      if sdmmc.getFlag(0x20) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
      }
      if sdmmc.getFlag(0x10) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
      }

      sdmmc.clearFlag(0x1800_0f3a)

      sdmmc.disableInterrupts(0x100 | 0x2 | 0x8 | 0x10 | 0x20)
      sdmmc.disableCommandTransfer()
      registers.write(.dctrl, value: registers.read(.dctrl) | (0x2000))
      registers.write(.cmd, value: registers.read(.cmd) | (0x80))
      handle.write(
        .errorCode,
        value: handle.read(.errorCode)
          | (sdmmc.commandStopTransfer(getSystemCoreClock: getSystemCoreClock)))
      registers.write(.cmd, value: registers.read(.cmd) & (~(0x80)))
      sdmmc.clearFlag(0x800)
      if (context & 0x8) != 0 {
        handle.write(.state, value: 0x1)
        handle.write(.transferContext, value: 0x0)
        if useRegisteredCallbacks {
          callbacks.read(.error)!(callbacks.context)
        } else {
          defaults.error(callbacks.context)
        }
      } else if (context & 0x80) != 0 {
        if handle.read(.errorCode) != 0x0 {
          sdmmc.disableInterrupts(0x1000_0000)
          registers.write(.idmactrl, value: 0x0)

          handle.write(.state, value: 0x1)
          if useRegisteredCallbacks {
            callbacks.read(.error)!(callbacks.context)
          } else {
            defaults.error(callbacks.context)
          }
        }
      } else {
      }
    } else if sdmmc.getFlag(0x1000_0000) {
      sdmmc.clearFlag(0x1000_0000)
      if (context & 0x20) != 0 {
        if useRegisteredCallbacks {
          callbacks.read(.writeDMALinkedListBufferComplete)!(callbacks.context)
        } else {
          defaults.writeDMALinkedListBufferComplete(callbacks.context)
        }
      } else {
        if useRegisteredCallbacks {
          callbacks.read(.readDMALinkedListBufferComplete)!(callbacks.context)
        } else {
          defaults.readDMALinkedListBufferComplete(callbacks.context)
        }
      }
    } else {
    }

  }
  func readInterruptData() {
    var count: UInt32 = 0
    var data: UInt32 = 0
    var tmp: UnsafeMutablePointer<UInt8>? = nil

    tmp = handle.readReceiveBuffer()
    if handle.read(.receiveSize) >= 0x20 {
      count = 0
      while count < (0x20 / 4) {
        data = sdmmc.readFIFO()
        tmp!.pointee = UInt8(truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (data & 0xFF))))
        tmp = tmp!.advanced(by: Int(1))
        tmp!.pointee = UInt8(
          truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 8) & 0xFF))))
        tmp = tmp!.advanced(by: Int(1))
        tmp!.pointee = UInt8(
          truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 16) & 0xFF))))
        tmp = tmp!.advanced(by: Int(1))
        tmp!.pointee = UInt8(
          truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: ((data >> 24) & 0xFF))))
        tmp = tmp!.advanced(by: Int(1))
        count = count &+ (1)
      }
      handle.writeReceiveBuffer(tmp)
      handle.write(.receiveSize, value: handle.read(.receiveSize) &- (0x20))
    }

  }
  func writeInterruptData() {
    var count: UInt32 = 0
    var data: UInt32 = 0
    var tmp: UnsafePointer<UInt8>? = nil

    tmp = handle.readTransmitBuffer()
    if handle.read(.transmitSize) >= 0x20 {
      count = 0
      while count < (0x20 / 4) {
        data = UInt32(truncatingIfNeeded: (UInt32(tmp!.pointee)))
        tmp = tmp!.advanced(by: Int(1))
        data = data | ((UInt32(truncatingIfNeeded: (UInt32(tmp!.pointee))) << 8))
        tmp = tmp!.advanced(by: Int(1))
        data = data | ((UInt32(truncatingIfNeeded: (UInt32(tmp!.pointee))) << 16))
        tmp = tmp!.advanced(by: Int(1))
        data = data | ((UInt32(truncatingIfNeeded: (UInt32(tmp!.pointee))) << 24))
        tmp = tmp!.advanced(by: Int(1))
        _ = sdmmc.writeFIFO(&data)
        count = count &+ (1)
      }
      handle.writeTransmitBuffer(tmp)
      handle.write(.transmitSize, value: handle.read(.transmitSize) &- (0x20))
    }

  }
}
