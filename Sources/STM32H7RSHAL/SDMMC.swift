// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SDMMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SDMMC {
  public func initialize(_ Init: SDMMCConfiguration) -> HALStatus {

    var tmpreg: UInt32 = 0

    tmpreg =
      tmpreg
      | ((Init.clockEdge | Init.clockPowerSave | Init.busWide | Init.hardwareFlowControl
        | Init.clockDivider))

    registers.write(.clkcr, value: ((registers.read(.clkcr) & ~(0x3fd3ff)) | (tmpreg)))
    return .ok

  }
  public func readFIFO() -> UInt32 {

    return (registers.read(.fifo))

  }
  public func writeFIFO(_ pWriteData: UnsafeMutablePointer<UInt32>?) -> HALStatus {

    registers.write(.fifo, value: pWriteData!.pointee)
    return .ok

  }
  public func powerOn() -> HALStatus {

    registers.write(.power, value: registers.read(.power) | (0x3))
    return .ok

  }
  public func powerCycle() -> HALStatus {

    registers.write(.power, value: registers.read(.power) | (0x2))
    return .ok

  }
  public func powerOff() -> HALStatus {

    registers.write(.power, value: registers.read(.power) & (~(0x3)))
    return .ok

  }
  public func getPowerState() -> UInt32 {

    return (registers.read(.power) & 0x3)

  }
  public func sendCommand(_ Command: UnsafePointer<SDMMCCommand>?) -> HALStatus {

    var tmpreg: UInt32 = 0

    registers.write(.arg, value: Command!.pointee.argument)

    tmpreg =
      tmpreg
      | (UInt32(
        truncatingIfNeeded: (Command!.pointee.commandIndex | Command!.pointee.response
          | Command!.pointee.waitForInterrupt | Command!.pointee.cpsm)))

    registers.write(.cmd, value: ((registers.read(.cmd) & ~(0x11f3f)) | (tmpreg)))
    return .ok

  }
  public func getCommandResponse() -> UInt8 {

    return UInt8(truncatingIfNeeded: UInt32(UInt8(truncatingIfNeeded: (registers.read(.respcmd)))))

  }
  public func getResponse(_ Response: UInt32) -> UInt32 {
    return registers.read(SDMMCRegister(rawValue: 0x14 &+ Response)!)
  }
  public func configureData(_ Data: UnsafePointer<SDMMCDataConfiguration>?) -> HALStatus {

    var tmpreg: UInt32 = 0

    registers.write(.dtimer, value: Data!.pointee.dataTimeout)

    registers.write(.dlen, value: Data!.pointee.dataLength)

    tmpreg =
      tmpreg
      | (UInt32(
        truncatingIfNeeded: (Data!.pointee.dataBlockSize | Data!.pointee.transferDirection
          | Data!.pointee.transferMode | Data!.pointee.dpsm)))

    registers.write(.dctrl, value: ((registers.read(.dctrl) & ~(0xff)) | (tmpreg)))
    return .ok

  }
  public func getDataCounter() -> UInt32 {

    return (registers.read(.dcount))

  }
  public func getFIFOCount() -> UInt32 {

    return (registers.read(.fifo))

  }
  public func setReadWaitMode(_ SDMMC_ReadWaitMode: UInt32) -> HALStatus {

    registers.write(.dctrl, value: ((registers.read(.dctrl) & ~(0x400)) | (SDMMC_ReadWaitMode)))
    return .ok

  }
}
