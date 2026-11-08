// Copyright (c) 2022 STMicroelectronics.
// SPDX-License-Identifier: Apache-2.0
// PKA RAM layout from CMSIS stm32h7s3xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import MMIO
import STM32H7RSHAL
import _Volatile
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32PKARegisters: PKARegisterIO {
    public init() {}
    public func read(_ register: PKARegister) -> UInt32 {
        switch register {
        case .cr: return pka.cr.read().raw.storage
        case .sr: return pka.sr.read().raw.storage
        case .clrfr: return pka.clrfr.read().raw.storage
        }
    }
    public func write(_ register: PKARegister, value: UInt32) {
        switch register {
        case .cr: pka.cr.write { $0.raw.storage = value }
        case .sr: preconditionFailure("PKA status register is read-only")
        case .clrfr: pka.clrfr.write { $0.raw.storage = value }
        }
    }
    public func readRAM(_ index: UInt32) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: ramAddress(index)).load()
    }
    public func writeRAM(_ index: UInt32, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: ramAddress(index)).store(value)
    }
    public func readOperandWord(_ pointer: UnsafePointer<UInt32>) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(bitPattern: pointer)).load()
    }
    public func writeResultWord(_ pointer: UnsafeMutablePointer<UInt32>, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: UInt(bitPattern: pointer)).store(value)
    }
    func address(of register: PKARegister) -> UInt {
        switch register {
        case .cr: return pka.cr.unsafeAddress
        case .sr: return pka.sr.unsafeAddress
        case .clrfr: return pka.clrfr.unsafeAddress
        }
    }
    func ramAddress(_ index: UInt32) -> UInt {
        precondition(index < 1334)
        return pka.unsafeAddress + 0x400 + UInt(index) * 4
    }
}
