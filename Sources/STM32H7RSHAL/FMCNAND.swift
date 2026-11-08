// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// FMC operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension FMC {
  public func initializeNAND(_ Init: UnsafePointer<FMCNANDConfiguration>?) -> HALStatus {

    registers.write(
      .pcr,
      value: ((registers.read(.pcr) & ~(0xffe76))
        | ((Init!.pointee.waitFeature | 0x8 | Init!.pointee.memoryDataWidth
          | Init!.pointee.eccComputation | Init!.pointee.eccPageSize
          | ((Init!.pointee.tclrSetupTime) << 0x9) | ((Init!.pointee.tarSetupTime) << 0xd))))
    )
    return .ok

  }
  public func configureNANDCommonSpaceTiming(
    _ Timing: UnsafePointer<FMCNANDTiming>?, _ Bank: UInt32
  ) -> HALStatus {

    _ = Bank

    registers.write(
      .pmem,
      value: (Timing!.pointee.setupTime | ((Timing!.pointee.waitSetupTime) << 0x8)
        | ((Timing!.pointee.holdSetupTime) << 0x10) | ((Timing!.pointee.hiZSetupTime) << 0x18)))
    return .ok

  }
  public func configureNANDAttributeSpaceTiming(
    _ Timing: UnsafePointer<FMCNANDTiming>?, _ Bank: UInt32
  ) -> HALStatus {

    _ = Bank

    registers.write(
      .patt,
      value: (Timing!.pointee.setupTime | ((Timing!.pointee.waitSetupTime) << 0x8)
        | ((Timing!.pointee.holdSetupTime) << 0x10) | ((Timing!.pointee.hiZSetupTime) << 0x18)))
    return .ok

  }
  public func deinitializeNAND(_ Bank: UInt32) -> HALStatus {

    disableNAND()

    _ = Bank

    registers.write(.pcr, value: 0x0000_0018)
    registers.write(.sr, value: 0x0000_0040)
    registers.write(.pmem, value: 0xFCFC_FCFC)
    registers.write(.patt, value: 0xFCFC_FCFC)
    return .ok

  }
  public func enableNANDECC(_ Bank: UInt32) -> HALStatus {

    _ = Bank
    registers.write(.pcr, value: registers.read(.pcr) | (0x40))
    return .ok

  }
  public func disableNANDECC(_ Bank: UInt32) -> HALStatus {

    _ = Bank
    registers.write(.pcr, value: registers.read(.pcr) & (~(0x40)))
    return .ok

  }
  public func getNANDECC(
    _ ECCval: UnsafeMutablePointer<UInt32>?, _ Bank: UInt32, _ Timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {

    var tickstart: UInt32

    tickstart = getTick()

    while getNANDFlag(0x40) == false {
      if Timeout != 0xffff_ffff {
        if ((getTick() &- tickstart) > Timeout) || (Timeout == 0) {
          return .timeout
        }
      }
    }

    _ = Bank

    ECCval!.pointee = UInt32(truncatingIfNeeded: registers.read(.eccr))
    return .ok

  }
}
