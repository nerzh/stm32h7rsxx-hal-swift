// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_WWDG_CFR_EWI: UInt32 = 0x0000_0200
public let LL_WWDG_PRESCALER_1: UInt32 = 0x0000_0000
public let LL_WWDG_PRESCALER_2: UInt32 = 0x0000_0800
public let LL_WWDG_PRESCALER_4: UInt32 = 0x0000_1000
public let LL_WWDG_PRESCALER_8: UInt32 = 0x0000_1800
public let LL_WWDG_PRESCALER_16: UInt32 = 0x0000_2000
public let LL_WWDG_PRESCALER_32: UInt32 = 0x0000_2800
public let LL_WWDG_PRESCALER_64: UInt32 = 0x0000_3000
public let LL_WWDG_PRESCALER_128: UInt32 = 0x0000_3800

public func LL_WWDG_Enable<IO: WWDGRegisterIO>(_ registers: IO) {
    registers.write(WWDGRegister.cr, value: registers.read(WWDGRegister.cr) | (0x80))
}

public func LL_WWDG_IsEnabled<IO: WWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(WWDGRegister.cr) & (0x80)) == (0x80)) ? 1 : 0)
}

public func LL_WWDG_SetCounter<IO: WWDGRegisterIO>(_ registers: IO, _ Counter: UInt32) {
    registers.write(WWDGRegister.cr, value: (registers.read(WWDGRegister.cr) & ~(0x7f)) | (Counter))
}

public func LL_WWDG_GetCounter<IO: WWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(WWDGRegister.cr) & (0x7f)))
}

public func LL_WWDG_SetPrescaler<IO: WWDGRegisterIO>(_ registers: IO, _ Prescaler: UInt32) {
    registers.write(WWDGRegister.cfr, value: (registers.read(WWDGRegister.cfr) & ~(0x3800)) | (Prescaler))
}

public func LL_WWDG_GetPrescaler<IO: WWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(WWDGRegister.cfr) & (0x3800)))
}

public func LL_WWDG_SetWindow<IO: WWDGRegisterIO>(_ registers: IO, _ Window: UInt32) {
    registers.write(WWDGRegister.cfr, value: (registers.read(WWDGRegister.cfr) & ~(0x7f)) | (Window))
}

public func LL_WWDG_GetWindow<IO: WWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(WWDGRegister.cfr) & (0x7f)))
}

public func LL_WWDG_IsActiveFlag_EWKUP<IO: WWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(WWDGRegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_WWDG_ClearFlag_EWKUP<IO: WWDGRegisterIO>(_ registers: IO) {
    registers.write(WWDGRegister.sr, value: ~0x1)
}

public func LL_WWDG_EnableIT_EWKUP<IO: WWDGRegisterIO>(_ registers: IO) {
    registers.write(WWDGRegister.cfr, value: registers.read(WWDGRegister.cfr) | (0x200))
}

public func LL_WWDG_IsEnabledIT_EWKUP<IO: WWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(WWDGRegister.cfr) & (0x200)) == (0x200)) ? 1 : 0)
}
