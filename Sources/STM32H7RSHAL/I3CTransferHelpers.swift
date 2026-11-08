// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I3C operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I3C {
  func transmitBytes() {

    while (getFlag(0x10) == 1) && (handle.read(.transmitTransferCount) > 0) {
      llTransmitData8(UInt32(handle.readTransfer()!.pointee.transmitBuffer.buffer!.pointee))

      handle.readTransfer()!.pointee.transmitBuffer.buffer = handle.readTransfer()!.pointee
        .transmitBuffer.buffer!.advanced(by: Int(1))

      handle.write(.transmitTransferCount, value: handle.read(.transmitTransferCount) &- (1))
    }

  }
  func transmitWords() {

    while getFlag(0x10) == 1 {
      llTransmitData32(
        UnsafeRawPointer(handle.readTransfer()!.pointee.transmitBuffer.buffer!).load(
          as: UInt32.self))

      handle.readTransfer()!.pointee.transmitBuffer.buffer = handle.readTransfer()!.pointee
        .transmitBuffer.buffer!.advanced(by: Int(4))
      if handle.read(.transmitTransferCount) < 4 {
        handle.write(.transmitTransferCount, value: 0)
      } else {
        handle.write(.transmitTransferCount, value: handle.read(.transmitTransferCount) &- (4))
      }
    }

  }
  func receiveBytes() {

    while getFlag(0x20) == 1 {
      handle.readTransfer()!.pointee.receiveBuffer.buffer!.pointee = UInt8(
        truncatingIfNeeded: llReceiveData8())

      handle.readTransfer()!.pointee.receiveBuffer.buffer = handle.readTransfer()!.pointee
        .receiveBuffer.buffer!.advanced(by: Int(1))

      handle.write(.receiveTransferCount, value: handle.read(.receiveTransferCount) &- (1))
    }

  }
  func receiveWords() {

    while getFlag(0x20) == 1 {
      UnsafeMutableRawPointer(handle.readTransfer()!.pointee.receiveBuffer.buffer!).storeBytes(
        of: llReceiveData32(), as: UInt32.self)

      handle.readTransfer()!.pointee.receiveBuffer.buffer = handle.readTransfer()!.pointee
        .receiveBuffer.buffer!.advanced(by: Int(4))
      if handle.read(.receiveTransferCount) > 4 {
        handle.write(.receiveTransferCount, value: handle.read(.receiveTransferCount) &- (4))
      } else {
        handle.write(.receiveTransferCount, value: 0)
      }
    }

  }
  func controlData() {

    if getFlag(0x4) == 1 {
      handle.write(.controlTransferCount, value: handle.read(.controlTransferCount) &- (1))

      registers.write(.cr, value: handle.readTransfer()!.pointee.controlBuffer.buffer!.pointee)

      handle.readTransfer()!.pointee.controlBuffer.buffer = handle.readTransfer()!.pointee
        .controlBuffer.buffer!.advanced(by: Int(1))
    }

    if getFlag(0x8) != 0 {
      _ = registers.read(.sr)
    }

  }
  func updateState() {

    if handle.read(.previousState) == 0x30 {
      handle.write(.state, value: 0x30)

      if handle.read(.mode) == 0x2 {
        handle.write(.transferISR, value: I3CTransferISR.targetEvent.rawValue)
      } else {
        handle.write(.transferISR, value: I3CTransferISR.controllerEvent.rawValue)
      }
    } else {
      handle.write(.state, value: 0x10)

      handle.write(.transferISR, value: 0)
    }

  }
  func getErrorSources() {

    switch handle.read(.mode)
    {
    case 0x1:
      do {
        if llIsActiveFlagDERR() == 1 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x400))
        }

        if llIsActiveFlagDNACK() == 1 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x200))
        }

        if llIsActiveFlagANACK() == 1 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
        }

        if llIsActiveFlagCOVR() == 1 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x80))
        }
        break
      }
    case 0x2:
      do {
        if llIsActiveFlagSTALL() == 1 {
          handle.write(.errorCode, value: handle.read(.errorCode) | (0x20))
        }
        break
      }
    default:
      do {
        break
      }
    }

    if llIsActiveFlagDOVR() == 1 {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
    }

    if llIsActiveFlagPERR() == 1 {
      handle.write(.errorCode, value: handle.read(.errorCode) | ((0x10 | llGetMessageErrorCode())))
    }

  }
}
