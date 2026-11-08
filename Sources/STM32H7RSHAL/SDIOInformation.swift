// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDIO {
  public func getCommonControlRegister(
    _ pCccr: UnsafeMutablePointer<SDIOCommonControlRegister>?, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 256) { tempBuffer in
      tempBuffer.initialize(repeating: 0)
      var count: UInt32 = 0

      if (pCccr == nil) {
        return .error
      }
      count = 0
      while count <= 0x16 {
        if readDirectByte(
          0x0 &+ count, 0x0, 0x0, &tempBuffer[Int(count)], getSystemCoreClock: getSystemCoreClock)
          != .ok
        {
          return .error
        }
        count = count &+ (1)
      }
      pCccr!.pointee.cccrRevision = UInt8(
        truncatingIfNeeded: UInt32(UInt32(tempBuffer[Int(Int(0))])) & 0x0F)
      pCccr!.pointee.sdioRevision = UInt8(
        truncatingIfNeeded: (UInt32(UInt32(tempBuffer[Int(Int(0))])) & 0xF0) >> 4)
      pCccr!.pointee.sdSpecificationRevision = UInt8(
        truncatingIfNeeded: UInt32(UInt32(tempBuffer[Int(Int(0x01))])) & 0x0F)
      pCccr!.pointee.busWidth8Bit = UInt8(
        truncatingIfNeeded: ((UInt32(UInt32(tempBuffer[Int(Int(0x07))])) & 0x04) != 0)
          ? 0x1
          : 0x0)
      pCccr!.pointee.cardCapability = (UInt32(UInt32(tempBuffer[Int(Int(0x08))])) & 0xDF)

      pCccr!.pointee.commonCISPointer =
        UInt32(UInt32(tempBuffer[Int(Int(0x09))]))
        | (UInt32(
          truncatingIfNeeded: UInt32(
            UInt32(tempBuffer[Int(Int(UInt32(truncatingIfNeeded: 0x09) &+ 1))]))) << 8)
        | (UInt32(
          truncatingIfNeeded: UInt32(
            UInt32(tempBuffer[Int(Int(UInt32(truncatingIfNeeded: 0x09) &+ 2))]))) << 16)
      return .ok

    }
  }
  public func getFunctionBasicRegister(
    _ pFbr: UnsafeMutablePointer<SDIOFunctionBasicRegister>?, getSystemCoreClock: () -> UInt32
  ) -> HALStatus {
    return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 256) { tempBuffer in
      tempBuffer.initialize(repeating: 0)
      var count: UInt32 = 0
      var func_idx: UInt8 = 0

      if (pFbr == nil) {
        return .error
      }
      func_idx = UInt8(truncatingIfNeeded: 2)
      while UInt32(func_idx) <= 0x7 {
        count = 0
        while count <= 0x16 {
          if readDirectByte(
            ((UInt32(truncatingIfNeeded: 0x100) &* UInt32(truncatingIfNeeded: UInt32(func_idx)))
              &+ count), 0x0, 0x0, &tempBuffer[Int(count)], getSystemCoreClock: getSystemCoreClock)
            != .ok
          {
            return .error
          }
          count = count &+ (1)
        }
        pFbr![Int(UInt32(truncatingIfNeeded: UInt32(UInt32(func_idx))) &- 1)].ioStdFunctionCode =
          UInt8(truncatingIfNeeded: UInt32(UInt32(tempBuffer[Int(Int(0))])) & 0x0F)
        pFbr![Int(UInt32(truncatingIfNeeded: UInt32(UInt32(func_idx))) &- 1)].ioExtFunctionCode =
          UInt8(truncatingIfNeeded: UInt32(UInt32(tempBuffer[Int(Int(1))])))
        pFbr![Int(UInt32(truncatingIfNeeded: UInt32(UInt32(func_idx))) &- 1)].ioPointerToCIS =
          UInt32(UInt32(tempBuffer[Int(Int(9))]))
          | (UInt32(truncatingIfNeeded: UInt32(UInt32(tempBuffer[Int(Int(10))]))) << 8)
          | (UInt32(truncatingIfNeeded: UInt32(UInt32(tempBuffer[Int(Int(11))]))) << 16)
        pFbr![Int(UInt32(truncatingIfNeeded: UInt32(UInt32(func_idx))) &- 1)].ioPointerToCSA =
          UInt32(UInt32(tempBuffer[Int(Int(12))]))
          | (UInt32(truncatingIfNeeded: UInt32(UInt32(tempBuffer[Int(Int(13))]))) << 8)
          | (UInt32(truncatingIfNeeded: UInt32(UInt32(tempBuffer[Int(Int(14))]))) << 16)
        if (UInt32(tempBuffer[Int(2)]) & 0x01) != 0 {
          pFbr![Int(UInt32(truncatingIfNeeded: UInt32(UInt32(func_idx))) &- 1)].flags = UInt8(
            truncatingIfNeeded: UInt32(
              pFbr![Int(UInt32(truncatingIfNeeded: UInt32(UInt32(UInt32(func_idx)))) &- 1)].flags)
              | (UInt32(UInt8(truncatingIfNeeded: 0x1))))
        }
        if (UInt32(tempBuffer[Int(0)]) & 0x40) != 0 {
          pFbr![Int(UInt32(truncatingIfNeeded: UInt32(UInt32(func_idx))) &- 1)].flags = UInt8(
            truncatingIfNeeded: UInt32(
              pFbr![Int(UInt32(truncatingIfNeeded: UInt32(UInt32(UInt32(func_idx)))) &- 1)].flags)
              | (UInt32(UInt8(truncatingIfNeeded: 0x1))))
        }
        func_idx = UInt8(truncatingIfNeeded: UInt32(UInt32(func_idx)) &+ (1))
      }
      return .ok

    }
  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
}
