// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// RCC/NVIC operations from HAL_PKA_MspDeInit at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

import MMIO
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public struct STM32PKASystemRegisters: PKASystemIO {
    public init() {}
    public func forceReset() { rcc.ahb3rstr.modify { $0.raw.storage |= 0x40 } }
    public func releaseReset() { rcc.ahb3rstr.modify { $0.raw.storage &= ~0x40 } }
    public func disableClock() { rcc.ahb3enr.modify { $0.raw.storage &= ~0x40 } }
    public func disableInterrupt() {
        var cortex = Cortex(registers: STM32CortexRegisters())
        cortex.disableIRQ(35)
    }
}
