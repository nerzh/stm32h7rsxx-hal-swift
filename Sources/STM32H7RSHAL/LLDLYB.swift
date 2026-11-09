// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let DLYB_MAX_UNIT: UInt32 = 0x0000_0080
public let DLYB_MAX_SELECT: UInt32 = 0x0000_000C
public let DLYB_FLAG_LNGF: UInt32 = 0x8000_0000

public func LL_DLYB_Enable<IO: DLYBRegisterIO>(_ registers: IO) {
    registers.write(DLYBRegister.cr, value: registers.read(DLYBRegister.cr) | (0x1))
}

public func LL_DLYB_Disable<IO: DLYBRegisterIO>(_ registers: IO) {
    registers.write(DLYBRegister.cr, value: registers.read(DLYBRegister.cr) & ~(0x1))
}

public func LL_DLYB_SetDelay<IO: DLYBRegisterIO>(_ registers: IO, _ pdlyb_cfg: inout LL_DLYB_CfgTypeDef) {
    registers.write(.cr, value: registers.read(.cr) | 2)
    registers.write(.cfgr, value: pdlyb_cfg.PhaseSel | (pdlyb_cfg.Units << 8))
    registers.write(.cr, value: registers.read(.cr) & ~UInt32(2))
}

public func LL_DLYB_GetDelay<IO: DLYBRegisterIO>(_ registers: IO, _ pdlyb_cfg: inout LL_DLYB_CfgTypeDef) {
    pdlyb_cfg.Units = (registers.read(.cfgr) & 0x7F00) >> 8
    pdlyb_cfg.PhaseSel = registers.read(.cfgr) & 0xF
}

public func LL_DLYB_GetClockPeriod<IO: DLYBRegisterIO>(
    _ registers: IO, _ pdlyb_cfg: inout LL_DLYB_CfgTypeDef, getTick: () -> UInt32
) -> UInt32 {
    var i: UInt32 = 0
    var nb: UInt32
    var lng: UInt32
    var tickstart: UInt32
    registers.write(.cr, value: registers.read(.cr) | 2)
    while i < DLYB_MAX_UNIT {
        registers.write(.cfgr, value: DLYB_MAX_SELECT | (i << 8))
        tickstart = getTick()
        while (registers.read(.cfgr) & 0x8000_0000) == 0 {
            if (getTick() &- tickstart) >= 0xFF {
                if (registers.read(.cfgr) & 0x8000_0000) == 0 { return HALStatus.timeout.rawValue }
            }
        }
        if (registers.read(.cfgr) & 0x07FF_0000) != 0 {
            if (registers.read(.cfgr) & 0x0C00_0000) != 0x0C00_0000 { break }
        }
        i &+= 1
    }
    if DLYB_MAX_UNIT != i {
        lng = (registers.read(.cfgr) & 0x0FFF_0000) >> 16
        nb = 10
        while nb > 0 && (lng >> nb) == 0 { nb &-= 1 }
        if nb != 0 {
            pdlyb_cfg.PhaseSel = nb
            pdlyb_cfg.Units = i
            registers.write(.cr, value: 2)
            return LLErrorStatus.success.rawValue
        }
    }
    registers.write(.cr, value: 2)
    return LLErrorStatus.error.rawValue
}
