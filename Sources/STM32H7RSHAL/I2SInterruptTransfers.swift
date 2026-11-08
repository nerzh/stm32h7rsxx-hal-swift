// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2S {
  public func transmitInterrupt(buffer: UnsafeMutableRawPointer?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }

    guard lock() else { return .busy }

    handle.write(.state, value: 0x3)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.transmit, value: pData)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))

    handle.writePointer(.receive, value: nil)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

    if (handle.read(.dataFormat) == 0x100) || (handle.read(.dataFormat) == 0x200) {
      handle.write(.transmitISR, value: I2STransferISR.transmit32.rawValue)
    } else {
      handle.write(.transmitISR, value: I2STransferISR.transmit16.rawValue)
    }

    if (registers.read(.cr1) & 0x1) != 0x1 {
      enable()
    }

    enableInterrupts((0x2 | 0x20))

    if handle.read(.mode) == 0x0 {
      enableInterrupts(0x100)
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    unlock()
    return .ok

  }
  public func receiveInterrupt(buffer: UnsafeMutableRawPointer?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }

    guard lock() else { return .busy }

    handle.write(.state, value: 0x4)
    handle.write(.errorCode, value: 0x0)
    handle.writePointer(.receive, value: pData)
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))

    handle.writePointer(.transmit, value: nil)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: ((0) & 0xFFFF)))

    if (handle.read(.dataFormat) == 0x100) || (handle.read(.dataFormat) == 0x200) {
      handle.write(.receiveISR, value: I2STransferISR.receive32.rawValue)
    } else {
      handle.write(.receiveISR, value: I2STransferISR.receive16.rawValue)
    }

    if (registers.read(.cr1) & 0x1) != 0x1 {
      enable()
    }
    enableInterrupts((0x1 | 0x40))

    if handle.read(.mode) == 0x2 {
      enableInterrupts(0x100)
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    unlock()
    return .ok

  }
  public func transmitReceiveInterrupt(
    transmitBuffer: UnsafeMutableRawPointer?, receiveBuffer: UnsafeMutableRawPointer?, count: UInt16
  ) -> HALStatus {
    let pTxData = transmitBuffer
    let pRxData = receiveBuffer
    let Size = UInt32(count)

    if (pTxData == nil) || (pRxData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) != 0x1 {
      return .busy
    }

    guard lock() else { return .busy }
    handle.writePointer(.transmit, value: pTxData)
    handle.writePointer(.receive, value: pRxData)
    handle.write(.transmitSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.transmitCount, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveSize, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.receiveCount, value: UInt16(truncatingIfNeeded: Size))
    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x5)

    if (handle.read(.dataFormat) == 0x100) || (handle.read(.dataFormat) == 0x200) {
      handle.write(.transmitISR, value: I2STransferISR.transmit32.rawValue)
      handle.write(.receiveISR, value: I2STransferISR.receive32.rawValue)
    } else {
      handle.write(.transmitISR, value: I2STransferISR.transmit16.rawValue)
      handle.write(.receiveISR, value: I2STransferISR.receive16.rawValue)
    }

    if (registers.read(.cr1) & 0x1) != 0x1 {
      enable()
    }

    enableInterrupts((0x2 | 0x1 | 0x4 | 0x20 | 0x40))

    if handle.read(.mode) == 0x8 {
      enableInterrupts(0x100)
    }

    registers.write(.cr1, value: registers.read(.cr1) | (0x200))
    unlock()
    return .ok

  }
}
