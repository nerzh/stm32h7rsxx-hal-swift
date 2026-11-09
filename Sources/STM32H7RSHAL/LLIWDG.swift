// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_IWDG_KEY_RELOAD: UInt32 = 0x0000_AAAA
public let LL_IWDG_KEY_ENABLE: UInt32 = 0x0000_CCCC
public let LL_IWDG_KEY_WR_ACCESS_ENABLE: UInt32 = 0x0000_5555
public let LL_IWDG_KEY_WR_ACCESS_DISABLE: UInt32 = 0x0000_0000
public let LL_IWDG_SR_PVU: UInt32 = 0x0000_0001
public let LL_IWDG_SR_RVU: UInt32 = 0x0000_0002
public let LL_IWDG_SR_WVU: UInt32 = 0x0000_0004
public let LL_IWDG_PRESCALER_4: UInt32 = 0x0000_0000
public let LL_IWDG_PRESCALER_8: UInt32 = 0x0000_0001
public let LL_IWDG_PRESCALER_16: UInt32 = 0x0000_0002
public let LL_IWDG_PRESCALER_32: UInt32 = 0x0000_0003
public let LL_IWDG_PRESCALER_64: UInt32 = 0x0000_0004
public let LL_IWDG_PRESCALER_128: UInt32 = 0x0000_0005
public let LL_IWDG_PRESCALER_256: UInt32 = 0x0000_0006
public let LL_IWDG_PRESCALER_512: UInt32 = 0x0000_0007
public let LL_IWDG_PRESCALER_1024: UInt32 = 0x0000_0008

public func LL_IWDG_Enable<IO: IWDGRegisterIO>(_ registers: IO) {
    registers.write(IWDGRegister.kr, value: LL_IWDG_KEY_ENABLE)
}

public func LL_IWDG_ReloadCounter<IO: IWDGRegisterIO>(_ registers: IO) {
    registers.write(IWDGRegister.kr, value: LL_IWDG_KEY_RELOAD)
}

public func LL_IWDG_EnableWriteAccess<IO: IWDGRegisterIO>(_ registers: IO) {
    registers.write(IWDGRegister.kr, value: LL_IWDG_KEY_WR_ACCESS_ENABLE)
}

public func LL_IWDG_DisableWriteAccess<IO: IWDGRegisterIO>(_ registers: IO) {
    registers.write(IWDGRegister.kr, value: LL_IWDG_KEY_WR_ACCESS_DISABLE)
}

public func LL_IWDG_SetPrescaler<IO: IWDGRegisterIO>(_ registers: IO, _ Prescaler: UInt32) {
    registers.write(IWDGRegister.pr, value: 0xf & Prescaler)
}

public func LL_IWDG_GetPrescaler<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(IWDGRegister.pr))
}

public func LL_IWDG_SetReloadCounter<IO: IWDGRegisterIO>(_ registers: IO, _ Counter: UInt32) {
    registers.write(IWDGRegister.rlr, value: 0xfff & Counter)
}

public func LL_IWDG_GetReloadCounter<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(IWDGRegister.rlr))
}

public func LL_IWDG_SetWindow<IO: IWDGRegisterIO>(_ registers: IO, _ Window: UInt32) {
    registers.write(IWDGRegister.winr, value: 0xfff & Window)
}

public func LL_IWDG_GetWindow<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(IWDGRegister.winr))
}

public func LL_IWDG_SetEwiTime<IO: IWDGRegisterIO>(_ registers: IO, _ Time: UInt32) {
    registers.write(IWDGRegister.ewcr, value: (registers.read(IWDGRegister.ewcr) & ~(0xfff)) | (Time))
}

public func LL_IWDG_GetEwiTime<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(IWDGRegister.ewcr) & (0xfff)))
}

public func LL_IWDG_EnableIT_EWI<IO: IWDGRegisterIO>(_ registers: IO) {
    registers.write(IWDGRegister.ewcr, value: registers.read(IWDGRegister.ewcr) | (0x8000))
}

public func LL_IWDG_DisableIT_EWI<IO: IWDGRegisterIO>(_ registers: IO) {
    registers.write(IWDGRegister.ewcr, value: registers.read(IWDGRegister.ewcr) & ~(0x8000))
}

public func LL_IWDG_IsEnabledIT_EWI<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(IWDGRegister.ewcr) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_IWDG_IsActiveFlag_PVU<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(IWDGRegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_IWDG_IsActiveFlag_RVU<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(IWDGRegister.sr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_IWDG_IsActiveFlag_WVU<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(IWDGRegister.sr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_IWDG_IsActiveFlag_EWU<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(IWDGRegister.sr) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_IWDG_IsReady<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(IWDGRegister.sr) & (0x1 | 0x2 | 0x4 | 0x8)) == 0) ? 1 : 0)
}

public func LL_IWDG_IsActiveFlag_ONF<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(IWDGRegister.sr) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_IWDG_IsActiveFlag_EWIF<IO: IWDGRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(IWDGRegister.sr) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_IWDG_ClearFlag_EWIF<IO: IWDGRegisterIO>(_ registers: IO) {
    registers.write(IWDGRegister.ewcr, value: registers.read(IWDGRegister.ewcr) | (0x4000))
}
