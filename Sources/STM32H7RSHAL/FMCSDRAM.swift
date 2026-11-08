// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension FMC {
  public func initializeSDRAM(_ Init: UnsafePointer<FMCSDRAMConfiguration>?) -> HALStatus {

    if Init!.pointee.bank == 0x0 {
      registers.write(
        .sdcr(0x0),
        value: ((registers.read(.sdcr(0x0)) & ~(0x7fff))
          | ((Init!.pointee.columnBitsNumber | Init!.pointee.rowBitsNumber
            | Init!.pointee.memoryDataWidth | Init!.pointee.internalBankNumber
            | Init!.pointee.casLatency | Init!.pointee.writeProtection | Init!.pointee.sdClockPeriod
            | Init!.pointee.readBurst | Init!.pointee.readPipeDelay)))
      )
    } else {
      registers.write(
        .sdcr(0x0),
        value: ((registers.read(.sdcr(0x0)) & ~(0xc00 | 0x1000 | 0x6000))
          | ((Init!.pointee.sdClockPeriod | Init!.pointee.readBurst | Init!.pointee.readPipeDelay)))
      )
      registers.write(
        .sdcr(0x1),
        value: ((registers.read(.sdcr(0x1)) & ~(0x7fff))
          | ((Init!.pointee.columnBitsNumber | Init!.pointee.rowBitsNumber
            | Init!.pointee.memoryDataWidth | Init!.pointee.internalBankNumber
            | Init!.pointee.casLatency | Init!.pointee.writeProtection)))
      )
    }
    return .ok

  }
  public func configureSDRAMTiming(_ Timing: UnsafePointer<FMCSDRAMTiming>?, _ Bank: UInt32)
    -> HALStatus
  {

    if Bank == 0x0 {
      registers.write(
        .sdtr(0x0),
        value: ((registers.read(.sdtr(0x0)) & ~(0xfffffff))
          | ((((Timing!.pointee.loadToActiveDelay) &- 1)
            | (((Timing!.pointee.exitSelfRefreshDelay) &- 1) << 0x4)
            | (((Timing!.pointee.selfRefreshTime) &- 1) << 0x8)
            | (((Timing!.pointee.rowCycleDelay) &- 1) << 0xc)
            | (((Timing!.pointee.writeRecoveryTime) &- 1) << 0x10)
            | (((Timing!.pointee.rpDelay) &- 1) << 0x14)
            | (((Timing!.pointee.rcdDelay) &- 1) << 0x18))))
      )
    } else {
      registers.write(
        .sdtr(0x0),
        value: ((registers.read(.sdtr(0x0)) & ~(0xf000 | 0xf00000))
          | ((((Timing!.pointee.rowCycleDelay) &- 1) << 0xc)
            | (((Timing!.pointee.rpDelay) &- 1) << 0x14)))
      )
      registers.write(
        .sdtr(0x1),
        value: ((registers.read(.sdtr(0x1)) & ~(0xfffffff))
          | ((((Timing!.pointee.loadToActiveDelay) &- 1)
            | (((Timing!.pointee.exitSelfRefreshDelay) &- 1) << 0x4)
            | (((Timing!.pointee.selfRefreshTime) &- 1) << 0x8)
            | (((Timing!.pointee.writeRecoveryTime) &- 1) << 0x10)
            | (((Timing!.pointee.rcdDelay) &- 1) << 0x18))))
      )
    }
    return .ok

  }
  public func deinitializeSDRAM(_ Bank: UInt32) -> HALStatus {

    registers.write(.sdcr(Bank), value: 0x0000_02D0)
    registers.write(.sdtr(Bank), value: 0x0FFF_FFFF)
    registers.write(.sdcmr, value: 0x0000_0000)
    registers.write(.sdrtr, value: 0x0000_0000)
    registers.write(.sdsr, value: 0x0000_0000)
    return .ok

  }
  public func enableSDRAMWriteProtection(_ Bank: UInt32) -> HALStatus {

    registers.write(.sdcr(Bank), value: registers.read(.sdcr(Bank)) | (0x200))
    return .ok

  }
  public func disableSDRAMWriteProtection(_ Bank: UInt32) -> HALStatus {

    registers.write(.sdcr(Bank), value: registers.read(.sdcr(Bank)) & (~(0x200)))
    return .ok

  }
  public func sendSDRAMCommand(_ Command: UnsafePointer<FMCSDRAMCommand>?, _ Timeout: UInt32)
    -> HALStatus
  {

    registers.write(
      .sdcmr,
      value: ((registers.read(.sdcmr) & ~((0x7 | 0x8 | 0x10 | 0x1e0 | 0x7ffe00)))
        | (((Command!.pointee.commandMode) | (Command!.pointee.commandTarget)
          | (((Command!.pointee.autoRefreshNumber) &- 1) << 0x5)
          | ((Command!.pointee.modeRegisterDefinition) << 0x9))))
    )

    _ = Timeout
    return .ok

  }
  public func programSDRAMRefreshRate(_ RefreshRate: UInt32) -> HALStatus {

    registers.write(.sdrtr, value: ((registers.read(.sdrtr) & ~(0x3ffe)) | ((RefreshRate << 0x1))))
    return .ok

  }
  public func setSDRAMAutoRefreshNumber(_ AutoRefreshNumber: UInt32) -> HALStatus {

    registers.write(
      .sdcmr, value: ((registers.read(.sdcmr) & ~(0x1e0)) | (((AutoRefreshNumber &- 1) << 0x5))))
    return .ok

  }
  public func getSDRAMModeStatus(_ Bank: UInt32) -> UInt32 {

    var tmpreg: UInt32

    if Bank == 0x0 {
      tmpreg = UInt32(truncatingIfNeeded: (registers.read(.sdsr) & 0x6))
    } else {
      tmpreg = (UInt32(truncatingIfNeeded: (registers.read(.sdsr) & 0x18)) >> 2)
    }

    return tmpreg

  }
}
