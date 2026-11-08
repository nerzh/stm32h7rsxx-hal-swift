// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDIO operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDIO {
  public func enableIOFunctionInterrupt(_ IOFunction: UInt32, getSystemCoreClock: () -> UInt32)
    -> HALStatus
  {
    var intEn: UInt8 = 0

    intEn = UInt8(truncatingIfNeeded: 0)

    if readDirectByte(0x4, 0x0, 0x0, &intEn, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }

    if (((UInt32(intEn) >> UInt32(truncatingIfNeeded: IOFunction)) & 0x01) == 0x01)
      && ((UInt32(intEn) & 0x01) != 0)
    {
      return .ok
    } else {
      intEn = UInt8(
        truncatingIfNeeded: UInt32(UInt32(intEn))
          | ((1 << UInt32(truncatingIfNeeded: IOFunction)) | 0x01))
      handle.write(
        .ioInterruptCount,
        value: UInt8(truncatingIfNeeded: UInt32(handle.read(.ioInterruptCount)) &+ (1)))
    }
    if writeDirectByte(0x4, 0x0, 0x0, &intEn, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }
    sdmmc.enableInterrupts(0x400000)

    sdmmc.enableOperation()
    return .ok

  }
  public func disableIOFunctionInterrupt(_ IOFunction: UInt32, getSystemCoreClock: () -> UInt32)
    -> HALStatus
  {
    var intEn: UInt8 = 0

    intEn = UInt8(truncatingIfNeeded: 0)

    if readDirectByte(0x4, 0x0, 0x0, &intEn, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }

    if ((UInt32(intEn) >> UInt32(truncatingIfNeeded: IOFunction)) & 0x01) == 0x00 {
      return .ok
    } else {
      intEn = UInt8(
        truncatingIfNeeded: UInt32(UInt32(intEn)) & (~(1 << UInt32(truncatingIfNeeded: IOFunction)))
      )
    }
    if writeDirectByte(0x4, 0x1, 0x0, &intEn, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }
    if UInt32(handle.read(.ioInterruptCount)) > 1 {
      handle.write(
        .ioInterruptCount,
        value: UInt8(truncatingIfNeeded: UInt32(handle.read(.ioInterruptCount)) &- (1)))
    } else {
      handle.write(.ioInterruptCount, value: UInt8(truncatingIfNeeded: 0))
      sdmmc.disableInterrupts(0x400000)
    }
    return .ok

  }
  public func enableIOFunction(_ IOFunction: UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus
  {
    var ioEn: UInt8 = 0
    var ioReady: UInt8 = 0

    ioEn = UInt8(truncatingIfNeeded: 0)
    ioReady = UInt8(truncatingIfNeeded: 0)

    if readDirectByte(0x2, 0x0, 0x0, &ioEn, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }

    if ((UInt32(ioEn) >> UInt32(truncatingIfNeeded: IOFunction)) & 0x01) == 0x01 {
      return .ok
    } else {
      ioEn = UInt8(
        truncatingIfNeeded: UInt32(UInt32(ioEn)) | ((1 << UInt32(truncatingIfNeeded: IOFunction))))
    }
    if writeDirectByte(0x2, 0x1, 0x0, &ioEn, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }
    if readDirectByte(0x3, 0x0, 0x0, &ioReady, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }
    if (UInt32(ioReady) & (1 << UInt32(truncatingIfNeeded: IOFunction))) != 0 {
      return .ok
    }
    return .error

  }
  public func disableIOFunction(_ IOFunction: UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus
  {
    var ioEn: UInt8 = 0

    ioEn = UInt8(truncatingIfNeeded: 0)

    if readDirectByte(0x2, 0x0, 0x0, &ioEn, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }

    if ((UInt32(ioEn) >> UInt32(truncatingIfNeeded: IOFunction)) & 0x01) == 0x00 {
      return .ok
    } else {
      ioEn = UInt8(
        truncatingIfNeeded: UInt32(UInt32(ioEn)) & (~(1 << UInt32(truncatingIfNeeded: IOFunction))))
    }
    if writeDirectByte(0x2, 0x1, 0x0, &ioEn, getSystemCoreClock: getSystemCoreClock) != .ok {
      return .error
    }
    return .ok

  }
  public func selectIOFunction(_ IOFunction: UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus
  {

    if withUnsafeBytes(
      of: IOFunction,
      { bytes in
        writeDirectByte(
          0xd, 0x1, 0x0, bytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
          getSystemCoreClock: getSystemCoreClock)
      }) != .ok
    {
      return .error
    }
    return .ok

  }
  public func abortIOFunction(_ IOFunction: UInt32, getSystemCoreClock: () -> UInt32) -> HALStatus {

    if withUnsafeBytes(
      of: IOFunction,
      { bytes in
        writeDirectByte(
          0x6, 0x1, 0x0, bytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
          getSystemCoreClock: getSystemCoreClock)
      }) != .ok
    {
      return .error
    }
    return .ok

  }
  public func enableIOAsynchronousInterrupt(getSystemCoreClock: () -> UInt32) -> HALStatus {
    var enable_asyn_it: UInt8 = 0

    enable_asyn_it = UInt8(truncatingIfNeeded: 0)

    if readDirectByte(0x16, 0x0, 0x0, &enable_asyn_it, getSystemCoreClock: getSystemCoreClock)
      != .ok
    {
      return .error
    }

    if (UInt32(enable_asyn_it) & 0x02) == 0x02 {
      return .ok
    } else {
      enable_asyn_it = UInt8(truncatingIfNeeded: UInt32(UInt32(enable_asyn_it)) | (0x02))
    }
    if writeDirectByte(0x16, 0x1, 0x0, &enable_asyn_it, getSystemCoreClock: getSystemCoreClock)
      != .ok
    {
      return .error
    }
    return .ok

  }
  public func disableIOAsynchronousInterrupt(getSystemCoreClock: () -> UInt32) -> HALStatus {
    var enable_asyn_it: UInt8 = 0

    enable_asyn_it = UInt8(truncatingIfNeeded: 0)

    if readDirectByte(0x16, 0x0, 0x0, &enable_asyn_it, getSystemCoreClock: getSystemCoreClock)
      != .ok
    {
      return .error
    }

    if (UInt32(enable_asyn_it) & 0x02) == 0x00 {
      return .ok
    } else {
      enable_asyn_it = UInt8(
        truncatingIfNeeded: UInt32(UInt32(enable_asyn_it))
          & (UInt32(UInt8(truncatingIfNeeded: ~(0x02)))))
    }
    if writeDirectByte(0x16, 0x1, 0x0, &enable_asyn_it, getSystemCoreClock: getSystemCoreClock)
      != .ok
    {
      return .error
    }
    return .ok

  }
  public func registerIOFunctionCallback(_ IOFunction: UInt32, _ pCallback: SDIOFunctionCallback?)
    -> HALStatus
  {

    callbacks.writeIOFunction(UInt32(truncatingIfNeeded: IOFunction), value: pCallback)
    handle.write(
      .ioFunctionMask,
      value: UInt8(
        truncatingIfNeeded: UInt32(handle.read(.ioFunctionMask))
          | ((1 << UInt32(UInt8(truncatingIfNeeded: IOFunction))))))
    return .ok

  }
}
