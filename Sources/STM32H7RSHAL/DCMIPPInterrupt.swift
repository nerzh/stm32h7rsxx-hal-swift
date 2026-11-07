// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DCMIPP IRQ operations from stm32h7rsxx_hal_dcmipp.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DCMIPP {
    public func handleInterrupt() {
        let flags = registers.read(.cmsr2), sources = registers.read(.cmier)
        if flags & 0x4000 != 0 && sources & 0x4000 != 0 {
            disableInterrupts(0x4000); addError(4); clearFlag(0x4000); invokePipe(.limit)
        }
        if flags & 0x400 != 0 && sources & 0x400 != 0 {
            clearFlag(0x400); invokePipe(.vsync)
        }
        if flags & 0x200 != 0 && sources & 0x200 != 0 {
            if registers.read(.p0fctcr) & 4 == 4 {
                disableInterrupts(0x8600); handle.write(.pipeState, value: 1)
            }
            clearFlag(0x200); invokePipe(.frame)
        }
        if flags & 0x100 != 0 && sources & 0x100 != 0 {
            clearFlag(0x100); invokePipe(.line)
        }
        if flags & 0x8000 != 0 && sources & 0x8000 != 0 {
            disableInterrupts(0x8000); addError(8); clearFlag(0x8000)
            handle.write(.pipeState, value: 4); invokePipe(.error)
        }
        if flags & 0x40 != 0 && sources & 0x40 != 0 {
            disableInterrupts(0x40); addError(2); clearFlag(0x40)
            handle.write(.state, value: 4); invoke(.error)
        }
        if flags & 0x20 != 0 && sources & 0x20 != 0 {
            disableInterrupts(0x20); addError(1); clearFlag(0x20)
            handle.write(.state, value: 4); invoke(.error)
        }
    }
}
