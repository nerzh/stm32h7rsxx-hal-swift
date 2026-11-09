// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_ICACHE_1WAY: UInt32 = 0x0000_0000
public let LL_ICACHE_4WAYS: UInt32 = 0x0000_0004
public let LL_ICACHE_MONITOR_HIT: UInt32 = 0x0001_0000
public let LL_ICACHE_MONITOR_MISS: UInt32 = 0x0002_0000
public let LL_ICACHE_MONITOR_ALL: UInt32 = 0x0003_0000
public let LL_ICACHE_SR_BUSYF: UInt32 = 0x0000_0001
public let LL_ICACHE_SR_BSYENDF: UInt32 = 0x0000_0002
public let LL_ICACHE_SR_ERRF: UInt32 = 0x0000_0004
public let LL_ICACHE_FCR_CBSYENDF: UInt32 = 0x0000_0002
public let LL_ICACHE_FCR_CERRF: UInt32 = 0x0000_0004
public let LL_ICACHE_IER_BSYENDIE: UInt32 = 0x0000_0002
public let LL_ICACHE_IER_ERRIE: UInt32 = 0x0000_0004

public func LL_ICACHE_Enable<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.cr, value: registers.read(ICacheRegister.cr) | (0x1))
}

public func LL_ICACHE_Disable<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.cr, value: registers.read(ICacheRegister.cr) & ~(0x1))
}

public func LL_ICACHE_IsEnabled<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(ICacheRegister.cr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_ICACHE_SetMode<IO: ICacheRegisterIO>(_ registers: IO, _ Mode: UInt32) {
    registers.write(ICacheRegister.cr, value: (registers.read(ICacheRegister.cr) & ~(0x4)) | (Mode))
}

public func LL_ICACHE_GetMode<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return ((registers.read(ICacheRegister.cr) & (0x4)))
}

public func LL_ICACHE_Invalidate<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.cr, value: registers.read(ICacheRegister.cr) | (0x2))
}

public func LL_ICACHE_EnableMonitors<IO: ICacheRegisterIO>(_ registers: IO, _ Monitors: UInt32) {
    registers.write(ICacheRegister.cr, value: registers.read(ICacheRegister.cr) | (Monitors))
}

public func LL_ICACHE_DisableMonitors<IO: ICacheRegisterIO>(_ registers: IO, _ Monitors: UInt32) {
    registers.write(ICacheRegister.cr, value: registers.read(ICacheRegister.cr) & ~(Monitors))
}

public func LL_ICACHE_IsEnabledMonitors<IO: ICacheRegisterIO>(_ registers: IO, _ Monitors: UInt32) -> UInt32 {
    return (((registers.read(ICacheRegister.cr) & (Monitors)) == (Monitors)) ? 1 : 0)
}

public func LL_ICACHE_ResetMonitors<IO: ICacheRegisterIO>(_ registers: IO, _ Monitors: UInt32) {
    registers.write(ICacheRegister.cr, value: registers.read(ICacheRegister.cr) | ((Monitors << 2)))
    registers.write(ICacheRegister.cr, value: registers.read(ICacheRegister.cr) & ~((Monitors << 2)))
}

public func LL_ICACHE_GetHitMonitor<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(ICacheRegister.hmonr))
}

public func LL_ICACHE_GetMissMonitor<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return (registers.read(ICacheRegister.mmonr))
}

public func LL_ICACHE_EnableIT_BSYEND<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.ier, value: registers.read(ICacheRegister.ier) | (0x2))
}

public func LL_ICACHE_DisableIT_BSYEND<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.ier, value: registers.read(ICacheRegister.ier) & ~(0x2))
}

public func LL_ICACHE_IsEnabledIT_BSYEND<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(ICacheRegister.ier) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_ICACHE_EnableIT_ERR<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.ier, value: registers.read(ICacheRegister.ier) | (0x4))
}

public func LL_ICACHE_DisableIT_ERR<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.ier, value: registers.read(ICacheRegister.ier) & ~(0x4))
}

public func LL_ICACHE_IsEnabledIT_ERR<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(ICacheRegister.ier) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_ICACHE_IsActiveFlag_BUSY<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(ICacheRegister.sr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_ICACHE_IsActiveFlag_BSYEND<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(ICacheRegister.sr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_ICACHE_IsActiveFlag_ERR<IO: ICacheRegisterIO>(_ registers: IO) -> UInt32 {
    return (((registers.read(ICacheRegister.sr) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_ICACHE_ClearFlag_BSYEND<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.fcr, value: 0x2)
}

public func LL_ICACHE_ClearFlag_ERR<IO: ICacheRegisterIO>(_ registers: IO) {
    registers.write(ICacheRegister.fcr, value: 0x4)
}
