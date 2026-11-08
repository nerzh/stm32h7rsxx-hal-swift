// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension FMC {
  public func initializeNORSRAM(_ Init: UnsafePointer<FMCNORSRAMConfiguration>?) -> HALStatus {

    var flashaccess: UInt32
    var btcr_reg: UInt32
    var mask: UInt32

    disableNORSRAM(Init!.pointee.bank)

    if Init!.pointee.memoryType == 0x8 {
      flashaccess = 0x40
    } else {
      flashaccess = 0x0
    }
    btcr_reg =
      (flashaccess | Init!.pointee.dataAddressMux | Init!.pointee.memoryType
        | Init!.pointee.memoryDataWidth | Init!.pointee.burstAccessMode
        | Init!.pointee.waitSignalPolarity | Init!.pointee.waitSignalActive
        | Init!.pointee.writeOperation | Init!.pointee.waitSignal | Init!.pointee.extendedMode
        | Init!.pointee.asynchronousWait | Init!.pointee.writeBurst)
    btcr_reg = btcr_reg | (Init!.pointee.continuousClock)
    btcr_reg = btcr_reg | (Init!.pointee.writeFIFO)
    btcr_reg = btcr_reg | (Init!.pointee.pageSize)
    mask =
      (0x1 | 0x2 | 0xc | 0x30 | 0x40 | 0x100 | 0x200 | 0x800 | 0x1000 | 0x2000 | 0x4000 | 0x8000
        | 0x80000)
    mask = mask | (0x100000)
    mask = mask | (0x200000)
    mask = mask | (0x70000)
    registers.write(
      .btcr(Init!.pointee.bank),
      value: ((registers.read(.btcr(Init!.pointee.bank)) & ~(mask)) | (btcr_reg)))

    if (Init!.pointee.continuousClock == 0x100000) && (Init!.pointee.bank != 0x0) {
      registers.write(
        .btcr(0x0),
        value: ((registers.read(.btcr(0x0)) & ~(0x100000)) | (Init!.pointee.continuousClock)))
    }
    if Init!.pointee.bank != 0x0 {
      registers.write(
        .btcr(0x0),
        value: registers.read(.btcr(0x0)) | (UInt32(truncatingIfNeeded: (Init!.pointee.writeFIFO))))
    }
    return .ok

  }
  public func deinitializeNORSRAM(_ Bank: UInt32) -> HALStatus {

    disableNORSRAM(Bank)

    if Bank == 0x0 {
      registers.write(.btcr(Bank), value: 0x0000_30DB)
    } else {
      registers.write(.btcr(Bank), value: 0x0000_30D2)
    }
    registers.write(.btcr(Bank &+ 1), value: 0x0FFF_FFFF)
    registers.write(.bwtr(Bank), value: 0x0FFF_FFFF)
    return .ok

  }
  public func configureNORSRAMTiming(_ Timing: UnsafePointer<FMCNORSRAMTiming>?, _ Bank: UInt32)
    -> HALStatus
  {

    var tmpr: UInt32

    registers.write(
      .btcr(Bank &+ 1),
      value: (Timing!.pointee.addressSetupTime << 0x0) | (Timing!.pointee.addressHoldTime << 0x4)
        | (Timing!.pointee.dataSetupTime << 0x8) | (Timing!.pointee.busTurnAroundDuration << 0x10)
        | ((Timing!.pointee.clockDivision &- 1) << 0x14)
        | ((Timing!.pointee.dataLatency &- 2) << 0x18) | Timing!.pointee.accessMode)

    if ((registers.read(.btcr(0x0)) & 0x100000) == 0x100000) {
      tmpr = UInt32(truncatingIfNeeded: (registers.read(.btcr(0x0 &+ 1)) & ~((0x0F) << 0x14)))
      tmpr = tmpr | (UInt32(truncatingIfNeeded: (((Timing!.pointee.clockDivision) &- 1) << 0x14)))
      registers.write(
        .btcr(0x0 &+ 1), value: ((registers.read(.btcr(0x0 &+ 1)) & ~(0xf00000)) | (tmpr)))
    }
    return .ok

  }
  public func configureNORSRAMExtendedTiming(
    _ Timing: UnsafePointer<FMCNORSRAMTiming>?, _ Bank: UInt32, _ ExtendedMode: UInt32
  ) -> HALStatus {

    if ExtendedMode == 0x4000 {

      registers.write(
        .bwtr(Bank),
        value: ((registers.read(.bwtr(Bank)) & ~(0x300f_ffff))
          | ((Timing!.pointee.addressSetupTime | ((Timing!.pointee.addressHoldTime) << 0x4)
            | ((Timing!.pointee.dataSetupTime) << 0x8) | Timing!.pointee.accessMode
            | ((Timing!.pointee.busTurnAroundDuration) << 0x10))))
      )

    } else {
      registers.write(.bwtr(Bank), value: 0x0FFF_FFFF)
    }
    return .ok

  }
  public func enableNORSRAMWrite(_ Bank: UInt32) -> HALStatus {

    registers.write(.btcr(Bank), value: registers.read(.btcr(Bank)) | (0x1000))
    return .ok

  }
  public func disableNORSRAMWrite(_ Bank: UInt32) -> HALStatus {

    registers.write(.btcr(Bank), value: registers.read(.btcr(Bank)) & (~(0x1000)))
    return .ok

  }
}
