// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748 and
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

// Legacy re-arm macros are empty in the pinned ST header.
public func LL_TIM_ReArmBRK<IO: TIMRegisterIO>(_ registers: inout IO) {}
public func LL_TIM_ReArmBRK2<IO: TIMRegisterIO>(_ registers: inout IO) {}

@available(*, unavailable, message: "The pinned ST macro refers to undefined LL_TIM_BKIN_SOURCE_DF1BK.")
public var LL_TIM_BKIN_SOURCE_DFBK: UInt32 { preconditionFailure("Missing upstream definition") }

@available(*, unavailable, message: "The pinned ST alias refers to missing LL_LPTIM_ClearFlag_CMPM.")
public func LL_LPTIM_ClearFLAG_CMPM<IO: LPTIMRegisterIO>(_ registers: inout IO) {
    preconditionFailure("Missing upstream definition")
}

public func LL_LPTIM_ClearFLAG_CC1<IO: LPTIMRegisterIO>(_ registers: inout IO) { LL_LPTIM_ClearFlag_CC1(&registers) }
public func LL_LPTIM_ClearFLAG_CC2<IO: LPTIMRegisterIO>(_ registers: inout IO) { LL_LPTIM_ClearFlag_CC2(&registers) }
public func LL_LPTIM_ClearFLAG_CC1O<IO: LPTIMRegisterIO>(_ registers: inout IO) { LL_LPTIM_ClearFlag_CC1O(&registers) }
public func LL_LPTIM_ClearFLAG_CC2O<IO: LPTIMRegisterIO>(_ registers: inout IO) { LL_LPTIM_ClearFlag_CC2O(&registers) }
public func LL_LPTIM_ClearFLAG_ARRM<IO: LPTIMRegisterIO>(_ registers: inout IO) { LL_LPTIM_ClearFlag_ARRM(&registers) }
public func LL_TIM_WriteReg<IO: TIMRegisterIO>(_ registers: inout IO, _ register: TIMRegister, _ value: UInt32) {
    registers.write(register, value: value)
}
public func LL_TIM_ReadReg<IO: TIMRegisterIO>(_ registers: inout IO, _ register: TIMRegister) -> UInt32 {
    registers.read(register)
}
public func LL_LPTIM_WriteReg<IO: LPTIMRegisterIO>(_ registers: inout IO, _ register: LPTIMRegister, _ value: UInt32) {
    registers.write(register, value: value)
}
public func LL_LPTIM_ReadReg<IO: LPTIMRegisterIO>(_ registers: inout IO, _ register: LPTIMRegister) -> UInt32 {
    registers.read(register)
}

public func LL_LPTIM_IC_GET_OFFSET(_ prescaler: UInt32, _ filter: UInt32) -> UInt8 {
    LL_LPTIM_OFFSET_TAB_ICx[Int((prescaler & 0xE00) >> 9)][Int((filter & 0x3000) >> 12)]
}

public func __LL_TIM_GETFLAG_UIFCPY(_ counter: UInt32) -> UInt32 { (counter & 0x8000_0000) >> 31 }

private func _llTIMCalcDTS(_ clock: UInt32, _ division: UInt32) -> UInt64 {
    let frequency =
        division == LL_TIM_CLOCKDIVISION_DIV1
        ? clock : (division == LL_TIM_CLOCKDIVISION_DIV2 ? clock >> 1 : clock >> 2)
    return 1_000_000_000_000 / UInt64(frequency)
}

public func __LL_TIM_CALC_DEADTIME(_ clock: UInt32, _ division: UInt32, _ deadTime: UInt32) -> UInt32 {
    // Preserve the distinct UInt32-before-cast and UInt64-before-product paths in C.
    let narrow = UInt64(deadTime &* 1000)
    let dts = _llTIMCalcDTS(clock, division)
    if narrow < 128 &* dts {
        return UInt32(UInt8(truncatingIfNeeded: narrow / dts) & 0x7F)
    } else if narrow < 128 &* 2 &* dts {
        return 0x80 | UInt32((UInt8(truncatingIfNeeded: (narrow / dts) >> 1) &- 64) & 0x3F)
    } else if narrow < 64 &* 8 &* dts {
        return 0xC0 | UInt32((UInt8(truncatingIfNeeded: ((UInt64(deadTime) &* 1000) / dts) >> 3) &- 32) & 0x1F)
    } else if narrow < 64 &* 16 &* dts {
        return 0xE0 | UInt32((UInt8(truncatingIfNeeded: ((UInt64(deadTime) &* 1000) / dts) >> 4) &- 32) & 0x1F)
    }
    return 0
}
public func __LL_TIM_CALC_PSC(_ clock: UInt32, _ counterClock: UInt32) -> UInt32 {
    clock >= counterClock ? ((clock &+ counterClock / 2) / counterClock) &- 1 : 0
}
public func __LL_TIM_CALC_ARR(_ clock: UInt32, _ prescaler: UInt32, _ frequency: UInt32) -> UInt32 {
    clock / (prescaler &+ 1) >= frequency ? (clock / (frequency &* (prescaler &+ 1))) &- 1 : 0
}
public func __LL_TIM_CALC_ARR_DITHER(_ clock: UInt32, _ prescaler: UInt32, _ frequency: UInt32) -> UInt32 {
    clock / (prescaler &+ 1) >= frequency
        ? UInt32(truncatingIfNeeded: (UInt64(clock) &* 16 / UInt64(frequency &* (prescaler &+ 1))) &- 16) : 0
}
public func __LL_TIM_CALC_DELAY(_ clock: UInt32, _ prescaler: UInt32, _ delay: UInt32) -> UInt32 {
    UInt32(truncatingIfNeeded: (UInt64(clock) &* UInt64(delay)) / (1_000_000 &* UInt64(prescaler &+ 1)))
}
public func __LL_TIM_CALC_DELAY_DITHER(_ clock: UInt32, _ prescaler: UInt32, _ delay: UInt32) -> UInt32 {
    UInt32(truncatingIfNeeded: (UInt64(clock) &* UInt64(delay) &* 16) / (1_000_000 &* UInt64(prescaler &+ 1)))
}
public func __LL_TIM_CALC_PULSE(_ clock: UInt32, _ prescaler: UInt32, _ delay: UInt32, _ pulse: UInt32) -> UInt32 {
    __LL_TIM_CALC_DELAY(clock, prescaler, pulse) &+ __LL_TIM_CALC_DELAY(clock, prescaler, delay)
}
public func __LL_TIM_CALC_PULSE_DITHER(_ clock: UInt32, _ prescaler: UInt32, _ delay: UInt32, _ pulse: UInt32) -> UInt32
{
    __LL_TIM_CALC_DELAY_DITHER(clock, prescaler, pulse) &+ __LL_TIM_CALC_DELAY_DITHER(clock, prescaler, delay)
}
public func __LL_TIM_GET_ICPSC_RATIO(_ prescaler: UInt32) -> UInt32 { 1 << ((prescaler >> 16) >> 2) }
