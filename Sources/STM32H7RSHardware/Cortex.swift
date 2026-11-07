// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Adapted from stm32h7rsxx_hal_cortex.c under BSD-3-Clause.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

import CortexMCore
import STM32H7RSHAL
#if STM32H7R
import STM32H7R
#else
import STM32H7S
#endif

public enum HALNVIC {
    public static func enableIRQ(_ interrupt: Interrupt) {
        var cortex = Cortex(registers: STM32CortexRegisters())
        cortex.enableIRQ(Int32(interrupt.rawValue))
    }

    public static func disableIRQ(_ interrupt: Interrupt) {
        var cortex = Cortex(registers: STM32CortexRegisters())
        cortex.disableIRQ(Int32(interrupt.rawValue))
    }
}
