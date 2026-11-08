// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// MDF operations and definitions from stm32h7rsxx_hal_mdf.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension MDF {
    public func handleInterrupt() {
        let enabled = registers.read(.dfltier), flags = registers.read(.dfltisr)
        let interrupts = enabled & flags
        if interrupts & 2 == 2 {
            modify(.dfltisr, set: 2); addError(1); invoke(.error)
        } else if interrupts & 1 == 1 {
            invoke(.acquisitionComplete)
            if registers.read(.dfltcr) & 0x70 == 0x10 { handle.write(.state, value: 1) }
        } else if interrupts & 0x800 == 0x800 {
            modify(.dfltisr, set: 0x800); addError(2); invoke(.error)
        } else if interrupts & 0x400 == 0x400 {
            modify(.dfltisr, set: 0x400); addError(4); invoke(.error)
        } else if interrupts & 0x200 == 0x200 {
            modify(.dfltisr, set: 0x200); addError(16); invoke(.error)
        } else if interrupts & 0x1000 == 0x1000 {
            modify(.dfltisr, set: 0x1000); invoke(.soundActivity)
        } else if interrupts & 0x2000 == 0x2000 {
            let sound = registers.read(.sadsdlvr), ambient = registers.read(.sadanlvr)
            modify(.dfltisr, set: 0x2000); invokeSoundLevel(sound, ambient)
        }
    }
}
