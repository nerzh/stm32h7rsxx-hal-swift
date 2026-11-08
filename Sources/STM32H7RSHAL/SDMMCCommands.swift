// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDMMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDMMC {
  public func commandBlockLength(_ BlockSize: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: BlockSize)
    sdmmc_cmdinit.commandIndex = 0x10
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x10), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandBlockCount(_ BlockCount: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: BlockCount)
    sdmmc_cmdinit.commandIndex = 0x17
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x17), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandReadSingleBlock(_ ReadAdd: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: ReadAdd)
    sdmmc_cmdinit.commandIndex = 0x11
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x11), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandReadMultipleBlocks(_ ReadAdd: UInt32, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: ReadAdd)
    sdmmc_cmdinit.commandIndex = 0x12
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x12), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandWriteSingleBlock(_ WriteAdd: UInt32, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: WriteAdd)
    sdmmc_cmdinit.commandIndex = 0x18
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x18), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandWriteMultipleBlocks(_ WriteAdd: UInt32, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: WriteAdd)
    sdmmc_cmdinit.commandIndex = 0x19
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x19), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSDEraseStartAddress(_ StartAdd: UInt32, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: StartAdd)
    sdmmc_cmdinit.commandIndex = 0x20
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x20), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSDEraseEndAddress(_ EndAdd: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: EndAdd)
    sdmmc_cmdinit.commandIndex = 0x21
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x21), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandEraseStartAddress(_ StartAdd: UInt32, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: StartAdd)
    sdmmc_cmdinit.commandIndex = 0x23
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x23), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandEraseEndAddress(_ EndAdd: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: EndAdd)
    sdmmc_cmdinit.commandIndex = 0x24
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x24), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandErase(_ EraseType: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = EraseType
    sdmmc_cmdinit.commandIndex = 0x26
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x26), 0xf618, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandStopTransfer(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = 0
    sdmmc_cmdinit.commandIndex = 0xc
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    enableCommandStop()
    disableCommandTransfer()
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0xc), 0x5f5e100, getSystemCoreClock: getSystemCoreClock)
    disableCommandStop()

    if errorstate == 0x2000000 {
      errorstate = 0x0
    }
    return errorstate

  }
  public func commandSelectDeselect(_ Addr: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: Addr)
    sdmmc_cmdinit.commandIndex = 0x7
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x7), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandGoIdle(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = 0
    sdmmc_cmdinit.commandIndex = 0x0
    sdmmc_cmdinit.response = 0x0
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandError(getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandOperatingCondition(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = 0x1aa
    sdmmc_cmdinit.commandIndex = 0x8
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse7(getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandApplication(_ Argument: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: Argument)
    sdmmc_cmdinit.commandIndex = 0x37
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x37), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandApplicationOperatingCondition(
    _ Argument: UInt32, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x29
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse3(getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandBusWidth(_ BusWidth: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = UInt32(truncatingIfNeeded: BusWidth)
    sdmmc_cmdinit.commandIndex = 0x6
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x6), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSendSCR(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = 0
    sdmmc_cmdinit.commandIndex = 0x33
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x33), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSendCID(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = 0
    sdmmc_cmdinit.commandIndex = 0x2
    sdmmc_cmdinit.response = 0x300
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse2(getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSendCSD(_ Argument: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x9
    sdmmc_cmdinit.response = 0x300
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse2(getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSetRelativeAddress(
    _ pRCA: UnsafeMutablePointer<UInt16>?, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = 0
    sdmmc_cmdinit.commandIndex = 0x3
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse6(
      UInt8(truncatingIfNeeded: 0x3), pRCA, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSetRelativeAddressMMC(_ RCA: UInt16, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {
    let RCA = UInt32(RCA)

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = (UInt32(truncatingIfNeeded: RCA) << 16)
    sdmmc_cmdinit.commandIndex = 0x3
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x3), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSleepMMC(_ Argument: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x5
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x5), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSendStatus(_ Argument: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0xd
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0xd), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandStatusRegister(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = 0
    sdmmc_cmdinit.commandIndex = 0xd
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0xd), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandOperationCondition(_ Argument: UInt32, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x1
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse3(getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSwitch(_ Argument: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x6
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x6), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandVoltageSwitch(getSystemCoreClock: () -> UInt32) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = 0x0000_0000
    sdmmc_cmdinit.commandIndex = 0xb
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0xb), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSendExtendedCSD(_ Argument: UInt32, getSystemCoreClock: () -> UInt32) -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32

    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x8
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse1(
      UInt8(truncatingIfNeeded: 0x8), 0x1388, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSDIOReadWriteDirect(
    _ Argument: UInt32, _ pResponse: UnsafeMutablePointer<UInt8>?, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x34
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse5(
      UInt8(truncatingIfNeeded: 0x34), pResponse, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSDIOReadWriteExtended(_ Argument: UInt32, getSystemCoreClock: () -> UInt32)
    -> UInt32
  {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x35
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse5(
      UInt8(truncatingIfNeeded: 0x35), nil, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
  public func commandSendOperationCondition(
    _ Argument: UInt32, _ pResp: UnsafeMutablePointer<UInt32>?, getSystemCoreClock: () -> UInt32
  ) -> UInt32 {

    var sdmmc_cmdinit = SDMMCCommand()
    var errorstate: UInt32
    sdmmc_cmdinit.argument = Argument
    sdmmc_cmdinit.commandIndex = 0x5
    sdmmc_cmdinit.response = 0x100
    sdmmc_cmdinit.waitForInterrupt = 0x0
    sdmmc_cmdinit.cpsm = 0x1000
    _ = sendCommand(&sdmmc_cmdinit)

    errorstate = getCommandResponse4(pResp, getSystemCoreClock: getSystemCoreClock)
    return errorstate

  }
}
