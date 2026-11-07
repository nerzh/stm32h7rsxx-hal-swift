// Copyright (c) 2022 STMicroelectronics.
// SPDX-License-Identifier: Apache-2.0
// OBKDR array layout from CMSIS stm32h7s3xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
typealias DeviceFLASH = STM32H7R.FLASH
#else
import STM32H7S
typealias DeviceFLASH = STM32H7S.FLASH
#endif

public struct STM32FlashRegisters: FlashRegisterIO {
    public init() {}

    public func read(_ register: FlashTimingRegister) -> UInt32 {
        STM32FlashTimingRegisters().read(register)
    }
    public func write(_ register: FlashTimingRegister, value: UInt32) {
        STM32FlashTimingRegisters().write(register, value: value)
    }

    // All eight OBKDR registers share the same 32-bit layout.
    private func keyData(_ index: Int) -> Register<DeviceFLASH.OBKDR0> {
        precondition(index >= 0 && index < 8)
        return .init(unsafeAddress: flash.obkdr0.unsafeAddress + UInt(index) * 4)
    }

    public func read(_ register: FlashRegister) -> UInt32 {
        switch register {
        case .cr: return flash.cr.read().raw.storage
        case .sr: return flash.sr.read().raw.storage
        case .ier: return flash.ier.read().raw.storage
        case .isr: return flash.isr.read().raw.storage
        case .optcr: return flash.optcr.read().raw.storage
        case .optisr: return flash.optisr.read().raw.storage
        case .wrpsr: return flash.wrpsr.read().raw.storage
        case .wrpsrp: return flash.wrpsrp.read().raw.storage
        case .obw1sr: return flash.obw1sr.read().raw.storage
        case .obw1srp: return flash.obw1srp.read().raw.storage
        case .obw2sr: return flash.obw2sr.read().raw.storage
        case .obw2srp: return flash.obw2srp.read().raw.storage
        case .hdpsr: return flash.hdpsr.read().raw.storage
        case .hdpsrp: return flash.hdpsrp.read().raw.storage
        case .nvsr: return flash.nvsr.read().raw.storage
        case .nvsrp: return flash.nvsrp.read().raw.storage
        case .rotsr: return flash.rotsr.read().raw.storage
        case .epochsr: return flash.epochsr.read().raw.storage
        case .otplsr: return flash.otplsr.read().raw.storage
        case .otplsrp: return flash.otplsrp.read().raw.storage
        case .obkcr: return flash.obkcr.read().raw.storage
        case .crccr: return flash.crccr.read().raw.storage
        case .crcsaddr: return flash.crcsaddr.read().raw.storage
        case .crceaddr: return flash.crceaddr.read().raw.storage
        case .crcdatar: return flash.crcdatar.read().raw.storage
        case .eccdfaddr: return flash.eccdfaddr.read().raw.storage
        case .eccsfaddr: return flash.eccsfaddr.read().raw.storage
        case .obkdr(let index): return keyData(index).read().raw.storage
        case .icr, .keyr, .optkeyr, .opticr:
            preconditionFailure("FLASH key and interrupt-clear registers are write-only")
        }
    }

    public func write(_ register: FlashRegister, value: UInt32) {
        switch register {
        case .cr: flash.cr.write { $0.raw.storage = value }
        case .ier: flash.ier.write { $0.raw.storage = value }
        case .icr: flash.icr.write { $0.raw.storage = value }
        case .keyr: flash.keyr.write { $0.raw.storage = value }
        case .optkeyr: flash.optkeyr.write { $0.raw.storage = value }
        case .optcr: flash.optcr.write { $0.raw.storage = value }
        case .opticr: flash.opticr.write { $0.raw.storage = value }
        case .wrpsr: flash.wrpsr.write { $0.raw.storage = value }
        case .wrpsrp: flash.wrpsrp.write { $0.raw.storage = value }
        case .obw1srp: flash.obw1srp.write { $0.raw.storage = value }
        case .obw2srp: flash.obw2srp.write { $0.raw.storage = value }
        case .hdpsrp: flash.hdpsrp.write { $0.raw.storage = value }
        case .nvsrp: flash.nvsrp.write { $0.raw.storage = value }
        case .otplsrp: flash.otplsrp.write { $0.raw.storage = value }
        case .obkcr: flash.obkcr.write { $0.raw.storage = value }
        case .crccr: flash.crccr.write { $0.raw.storage = value }
        case .crcsaddr: flash.crcsaddr.write { $0.raw.storage = value }
        case .crceaddr: flash.crceaddr.write { $0.raw.storage = value }
        case .obkdr(let index): keyData(index).write { $0.raw.storage = value }
        case .sr, .isr, .optisr, .obw1sr, .obw2sr, .hdpsr, .nvsr, .rotsr, .epochsr, .otplsr, .crcdatar, .eccdfaddr, .eccsfaddr:
            preconditionFailure("FLASH status registers are read-only")
        }
    }

    func address(of register: FlashRegister) -> UInt {
        switch register {
        case .cr: return flash.cr.unsafeAddress
        case .sr: return flash.sr.unsafeAddress
        case .ier: return flash.ier.unsafeAddress
        case .isr: return flash.isr.unsafeAddress
        case .icr: return flash.icr.unsafeAddress
        case .keyr: return flash.keyr.unsafeAddress
        case .optkeyr: return flash.optkeyr.unsafeAddress
        case .optcr: return flash.optcr.unsafeAddress
        case .optisr: return flash.optisr.unsafeAddress
        case .opticr: return flash.opticr.unsafeAddress
        case .wrpsr: return flash.wrpsr.unsafeAddress
        case .wrpsrp: return flash.wrpsrp.unsafeAddress
        case .obw1sr: return flash.obw1sr.unsafeAddress
        case .obw1srp: return flash.obw1srp.unsafeAddress
        case .obw2sr: return flash.obw2sr.unsafeAddress
        case .obw2srp: return flash.obw2srp.unsafeAddress
        case .hdpsr: return flash.hdpsr.unsafeAddress
        case .hdpsrp: return flash.hdpsrp.unsafeAddress
        case .nvsr: return flash.nvsr.unsafeAddress
        case .nvsrp: return flash.nvsrp.unsafeAddress
        case .rotsr: return flash.rotsr.unsafeAddress
        case .epochsr: return flash.epochsr.unsafeAddress
        case .otplsr: return flash.otplsr.unsafeAddress
        case .otplsrp: return flash.otplsrp.unsafeAddress
        case .obkcr: return flash.obkcr.unsafeAddress
        case .crccr: return flash.crccr.unsafeAddress
        case .crcsaddr: return flash.crcsaddr.unsafeAddress
        case .crceaddr: return flash.crceaddr.unsafeAddress
        case .crcdatar: return flash.crcdatar.unsafeAddress
        case .eccdfaddr: return flash.eccdfaddr.unsafeAddress
        case .eccsfaddr: return flash.eccsfaddr.unsafeAddress
        case .obkdr(let index): return keyData(index).unsafeAddress
        }
    }
}

public extension Flash where Registers == STM32FlashRegisters, Memory == STM32FlashMemory {
    init(process: Process, callbacks: FlashCallbacks = .init()) {
        self.init(registers: STM32FlashRegisters(), process: process,
                  memory: STM32FlashMemory(), callbacks: callbacks)
    }
}
