// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// LPTIM operations and definitions from stm32h7rsxx_hal_lptim.c/.h and
// stm32h7rsxx_ll_lptim.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension LPTIM {
    public func handleInterrupt() {
        if getFlag(.captureCompare1) {
            if getInterruptSource(.captureCompare1) {
                clearFlag(.captureCompare1)
                handle.write(.activeChannel, value: 1)
                if registers.read(.ccmr1) & 0x1 != 0 { invoke(.inputCapture) }
                else { invoke(.compareMatch) }
                handle.write(.activeChannel, value: 0)
            }
        }
        if getFlag(.captureCompare2) {
            if getInterruptSource(.captureCompare2) {
                clearFlag(.captureCompare2)
                handle.write(.activeChannel, value: 2)
                if registers.read(.ccmr1) & 0x10000 != 0 { invoke(.inputCapture) }
                else { invoke(.compareMatch) }
                handle.write(.activeChannel, value: 0)
            }
        }
        if getFlag(.capture1Overrun) {
            if getInterruptSource(.capture1Overrun) {
                clearFlag(.capture1Overrun)
                handle.write(.activeChannel, value: 1)
                invoke(.overCapture)
                handle.write(.activeChannel, value: 0)
            }
        }
        if getFlag(.capture2Overrun) {
            if getInterruptSource(.capture2Overrun) {
                clearFlag(.capture2Overrun)
                handle.write(.activeChannel, value: 2)
                invoke(.overCapture)
                handle.write(.activeChannel, value: 0)
            }
        }
        if getFlag(.autoReloadMatch) {
            if getInterruptSource(.autoReloadMatch) {
                clearFlag(.autoReloadMatch)
                invoke(.autoReloadMatch)
            }
        }
        if getFlag(.externalTrigger) {
            if getInterruptSource(.externalTrigger) {
                clearFlag(.externalTrigger)
                invoke(.trigger)
            }
        }
        if getFlag(.compare1Write) {
            if getInterruptSource(.compare1Write) {
                clearFlag(.compare1Write)
                handle.write(.activeChannel, value: 1)
                invoke(.compareWrite)
            }
        }
        if getFlag(.compare2Write) {
            if getInterruptSource(.compare2Write) {
                clearFlag(.compare2Write)
                handle.write(.activeChannel, value: 2)
                invoke(.compareWrite)
            }
        }
        if getFlag(.autoReloadWrite) {
            if getInterruptSource(.autoReloadWrite) {
                clearFlag(.autoReloadWrite)
                invoke(.autoReloadWrite)
            }
        }
        if getFlag(.directionUp) {
            if getInterruptSource(.directionUp) {
                clearFlag(.directionUp)
                invoke(.directionUp)
            }
        }
        if getFlag(.directionDown) {
            if getInterruptSource(.directionDown) {
                clearFlag(.directionDown)
                invoke(.directionDown)
            }
        }
        if getFlag(.update) {
            if getInterruptSource(.update) {
                clearFlag(.update)
                invoke(.updateEvent)
            }
        }
        if getFlag(.repetitionWrite) {
            if getInterruptSource(.repetitionWrite) {
                clearFlag(.repetitionWrite)
                invoke(.repetitionWrite)
            }
        }
    }
}
