// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SAI {
  public func transmitInterrupt(buffer: UnsafeMutablePointer<UInt8>?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.writeBuffer(pData)
      handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x12)
      if (handle.read(.dataSize) == 0x40) && (handle.read(.compandingMode) == 0x0) {
        handle.write(.transferISR, value: SAITransferISR.transmit8.rawValue)
      } else if handle.read(.dataSize) <= 0x80 {
        handle.write(.transferISR, value: SAITransferISR.transmit16.rawValue)
      } else {
        handle.write(.transferISR, value: SAITransferISR.transmit32.rawValue)
      }

      fillFIFO()

      enableInterrupts(interruptFlags(1))

      if (registers.read(.cr1) & 0x10000) == 0 {
        enable()
      }
      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func receiveInterrupt(buffer: UnsafeMutablePointer<UInt8>?, count: UInt16) -> HALStatus {
    let pData = buffer
    let Size = UInt32(count)

    if (pData == nil) || (Size == 0) {
      return .error
    }
    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.writeBuffer(pData)
      handle.write(.transferSize, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.transferCount, value: UInt16(truncatingIfNeeded: Size))
      handle.write(.errorCode, value: 0x0)
      handle.write(.state, value: 0x22)
      if (handle.read(.dataSize) == 0x40) && (handle.read(.compandingMode) == 0x0) {
        handle.write(.transferISR, value: SAITransferISR.receive8.rawValue)
      } else if handle.read(.dataSize) <= 0x80 {
        handle.write(.transferISR, value: SAITransferISR.receive16.rawValue)
      } else {
        handle.write(.transferISR, value: SAITransferISR.receive32.rawValue)
      }

      enableInterrupts(interruptFlags(1))

      if (registers.read(.cr1) & 0x10000) == 0 {
        enable()
      }

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
}
