// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// CRYP and SAES register layout from CMSIS stm32h7s3xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import STM32H7RSHAL
import _Volatile

#if STM32H7S
  import MMIO
  import STM32H7S

  public struct STM32CRYPRegisters: CRYPRegisterIO {
    public let instance: CRYPInstance
    public init(_ instance: CRYPInstance) { self.instance = instance }
    public func address(of register: CRYPRegister) -> UInt32 { UInt32(nativeAddress(of: register)) }
    func nativeAddress(of register: CRYPRegister) -> UInt {
      // The original driver uses both register layouts for some accesses.
      // Retain the byte offset even when it aliases another SAES register.
      (instance == .cryp ? cryp.unsafeAddress : saes.unsafeAddress) + UInt(register.rawValue)
    }
    public func read(_ register: CRYPRegister) -> UInt32 {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: nativeAddress(of: register)).load()
    }
    public func write(_ register: CRYPRegister, value: UInt32) {
      VolatileMappedRegister<UInt32>(unsafeBitPattern: nativeAddress(of: register)).store(value)
    }
  }
#endif
