import CCortexHALSupport
import CortexMCore
import MMIO
// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// ETH register offsets from CMSIS stm32h7s3xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.
import STM32H7RSHAL
import _Volatile

#if STM32H7R
  import STM32H7R
#else
  import STM32H7S
#endif
public struct STM32ETHRegisters: ETHRegisterIO {
  public init() {}
  public func address(of register: ETHRegister) -> UInt32 {
    UInt32(eth.unsafeAddress) + register.rawValue
  }
  public func read(_ register: ETHRegister) -> UInt32 {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).load()
  }
  public func write(_ register: ETHRegister, value: UInt32) {
    VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(address(of: register))).store(value)
  }
}
extension STM32DMAMemory: ETHMemoryIO {}
public struct STM32ETHPlatform: ETHPlatformIO {
  public init() {}
  public func writeGlobalETH(_ register: ETHRegister, value: UInt32) {
    STM32ETHRegisters().write(register, value: value)
  }
  public func enableSBSClock() {
    rcc.apb4enr.modify { $0.raw.storage |= 2 }
    _ = rcc.apb4enr.read().raw.storage & 2
  }
  public func configureEthernetPHY(_ configuration: UInt32) {
    SBS(registers: STM32SBSRegisters()).configureEthernetPHY(configuration)
  }
  public func readSBSPeripheralMode() -> UInt32 { STM32SBSRegisters().read(.pmcr) }
  public func dataMemoryBarrier() { hal_cortex_dmb() }
  public func dataSynchronizationBarrier() { CortexMCore.dataSynchronizationBarrier() }
  public func readInterruptMask() -> UInt32 { STM32FlashMemory().getPRIMASK() }
  public func writeInterruptMask(_ value: UInt32) { STM32FlashMemory().setPRIMASK(value) }
}
