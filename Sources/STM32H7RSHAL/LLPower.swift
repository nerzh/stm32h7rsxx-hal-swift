// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public let LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET: UInt32 = 0x00000002
public let LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK: UInt32 = 0x0000001F
public let LL_PWR_SR_CSSF: UInt32 = 0x00000002
public let LL_PWR_WKUPCR_WKUPC1: UInt32 = 0x00000001
public let LL_PWR_WKUPCR_WKUPC2: UInt32 = 0x00000002
public let LL_PWR_WKUPCR_WKUPC3: UInt32 = 0x00000004
public let LL_PWR_WKUPCR_WKUPC4: UInt32 = 0x00000008
public let LL_PWR_WKUPCR_WKUPC: UInt32 = 0x0000000F
public let LL_PWR_FLAG_VOSRDY: UInt32 = 0x00000002
public let LL_PWR_FLAG_STOPF: UInt32 = 0x00000100
public let LL_PWR_FLAG_SBF: UInt32 = 0x00000200
public let LL_PWR_WAKEUP_FLAG1: UInt32 = 0x00000001
public let LL_PWR_WAKEUP_FLAG2: UInt32 = 0x00000002
public let LL_PWR_WAKEUP_FLAG3: UInt32 = 0x00000004
public let LL_PWR_WAKEUP_FLAG4: UInt32 = 0x00000008
public let LL_PWR_POWERDOWN_MODE_DS_STOP: UInt32 = 0x00000000
public let LL_PWR_POWERDOWN_MODE_DS_STANDBY: UInt32 = 0x00000001
public let LL_PWR_REGU_VOLTAGE_SCALE0: UInt32 = 0x00000001
public let LL_PWR_REGU_VOLTAGE_SCALE1: UInt32 = 0x00000000
public let LL_PWR_REGU_STOP_VOLTAGE_SCALE3: UInt32 = 0x00000001
public let LL_PWR_REGU_STOP_VOLTAGE_SCALE5: UInt32 = 0x00000000
public let LL_PWR_PVDLEVEL_1: UInt32 = 0x00000000
public let LL_PWR_PVDLEVEL_2: UInt32 = 0x00000020
public let LL_PWR_PVDLEVEL_3: UInt32 = 0x00000040
public let LL_PWR_PVDLEVEL_4: UInt32 = 0x00000060
public let LL_PWR_PVDLEVEL_5: UInt32 = 0x00000080
public let LL_PWR_PVDLEVEL_6: UInt32 = 0x000000A0
public let LL_PWR_PVDLEVEL_7: UInt32 = 0x000000C0
public let LL_PWR_PVDLEVEL_EXT: UInt32 = 0x000000E0
public let LL_PWR_AVDLEVEL_1: UInt32 = 0x00000000
public let LL_PWR_AVDLEVEL_2: UInt32 = 0x00004000
public let LL_PWR_AVDLEVEL_3: UInt32 = 0x00008000
public let LL_PWR_AVDLEVEL_4: UInt32 = 0x0000C000
public let LL_PWR_XSPI1_CAPACITOR_OFF: UInt32 = 0x00000000
public let LL_PWR_XSPI1_CAPACITOR_1_DIV_3: UInt32 = 0x00000400
public let LL_PWR_XSPI1_CAPACITOR_2_DIV_3: UInt32 = 0x00000800
public let LL_PWR_XSPI1_CAPACITOR_FULL: UInt32 = 0x00000C00
public let LL_PWR_XSPI2_CAPACITOR_OFF: UInt32 = 0x00000000
public let LL_PWR_XSPI2_CAPACITOR_1_DIV_3: UInt32 = 0x00001000
public let LL_PWR_XSPI2_CAPACITOR_2_DIV_3: UInt32 = 0x00002000
public let LL_PWR_XSPI2_CAPACITOR_FULL: UInt32 = 0x00003000
public let LL_PWR_BATT_CHARG_RESISTOR_5K: UInt32 = 0x00000000
public let LL_PWR_BATT_CHARG_RESISTOR_1_5K: UInt32 = 0x00000200
public let LL_PWR_WAKEUP_PIN1: UInt32 = 0x00000001
public let LL_PWR_WAKEUP_PIN2: UInt32 = 0x00000002
public let LL_PWR_WAKEUP_PIN3: UInt32 = 0x00000004
public let LL_PWR_WAKEUP_PIN4: UInt32 = 0x00000008
public let LL_PWR_WAKEUP_PIN_NOPULL: UInt32 = 0x00000000
public let LL_PWR_WAKEUP_PIN_PULLUP: UInt32 = 0x00000001
public let LL_PWR_WAKEUP_PIN_PULLDOWN: UInt32 = 0x00000002
public let LL_PWR_LDO_SUPPLY: UInt32 = 0x00000002
public let LL_PWR_DIRECT_SMPS_SUPPLY: UInt32 = 0x00000004
public let LL_PWR_SMPS_1V8_SUPPLIES_LDO: UInt32 = 0x00000016
public let LL_PWR_SMPS_1V8_SUPPLIES_EXT_AND_LDO: UInt32 = 0x0000001E
public let LL_PWR_SMPS_1V8_SUPPLIES_EXT: UInt32 = 0x0000001D
public let LL_PWR_EXTERNAL_SOURCE_SUPPLY: UInt32 = 0x00000001
public let LL_PWR_GPIO_PIN_0: UInt32 = 0x00000001
public let LL_PWR_GPIO_PIN_1: UInt32 = 0x00000002
public let LL_PWR_GPIO_PIN_2: UInt32 = 0x00000004
public let LL_PWR_GPIO_PIN_3: UInt32 = 0x00000008
public let LL_PWR_GPIO_PIN_4: UInt32 = 0x00000010
public let LL_PWR_GPIO_PIN_5: UInt32 = 0x00000020
public let LL_PWR_GPIO_PIN_6: UInt32 = 0x00000040
public let LL_PWR_GPIO_PIN_7: UInt32 = 0x00000080
public let LL_PWR_GPIO_PIN_8: UInt32 = 0x00000100
public let LL_PWR_GPIO_PIN_9: UInt32 = 0x00000200
public let LL_PWR_GPIO_PIN_10: UInt32 = 0x00000400
public let LL_PWR_GPIO_PIN_11: UInt32 = 0x00000800
public let LL_PWR_GPIO_PIN_12: UInt32 = 0x00001000
public let LL_PWR_GPIO_PIN_13: UInt32 = 0x00002000
public let LL_PWR_GPIO_PIN_14: UInt32 = 0x00004000
public let LL_PWR_GPIO_PIN_15: UInt32 = 0x00008000

public func LL_PWR_EnablePVD<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) | (0x10))
}

public func LL_PWR_DisablePVD<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) & ~(0x10))
}

public func LL_PWR_IsEnabledPVD<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.cr1) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_PWR_SetPVDLevel<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ PVDLevel: UInt32) {
    registers.write(PowerExtendedRegister.cr1, value: (registers.read(PowerExtendedRegister.cr1) & ~(0xE0)) | (PVDLevel))
}

public func LL_PWR_GetPVDLevel<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(PowerExtendedRegister.cr1) & (0xE0))
}

public func LL_PWR_EnableBkUpAccess<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) | (0x100))
}

public func LL_PWR_DisableBkUpAccess<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) & ~(0x100))
}

public func LL_PWR_IsEnabledBkUpAccess<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.cr1) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_PWR_EnableFlashLowPower<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) | (0x200))
}

public func LL_PWR_DisableFlashLowPower<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) & ~(0x200))
}

public func LL_PWR_IsEnabledFlashLowPower<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.cr1) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_PWR_EnableAnalogBooster<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) | (0x800))
}

public func LL_PWR_DisableAnalogBooster<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) & ~(0x800))
}

public func LL_PWR_IsEnabledAnalogBooster<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.cr1) & (0x800)) == (0x800)) ? 1 : 0)
}

public func LL_PWR_EnableAnalogVoltageReady<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) | (0x1000))
}

public func LL_PWR_DisableAnalogVoltageReady<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) & ~(0x1000))
}

public func LL_PWR_IsEnabledAnalogVoltageReady<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.cr1) & (0x1000)) == (0x1000)) ? 1 : 0)
}

public func LL_PWR_EnableAVD<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) | (0x2000))
}

public func LL_PWR_DisableAVD<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.cr1, value: registers.read(PowerExtendedRegister.cr1) & ~(0x2000))
}

public func LL_PWR_IsEnabledAVD<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.cr1) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_PWR_SetAVDLevel<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ AVDLevel: UInt32) {
    registers.write(PowerExtendedRegister.cr1, value: (registers.read(PowerExtendedRegister.cr1) & ~(0xC000)) | (AVDLevel))
}

public func LL_PWR_GetAVDLevel<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(PowerExtendedRegister.cr1) & (0xC000))
}

public func LL_PWR_EnableBkUpRegulator<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr1, value: registers.read(PowerExtendedRegister.csr1) | (0x1))
}

public func LL_PWR_DisableBkUpRegulator<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr1, value: registers.read(PowerExtendedRegister.csr1) & ~(0x1))
}

public func LL_PWR_IsEnabledBkUpRegulator<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr1) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_PWR_EnableMonitoring<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr1, value: registers.read(PowerExtendedRegister.csr1) | (0x10))
}

public func LL_PWR_DisableMonitoring<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr1, value: registers.read(PowerExtendedRegister.csr1) & ~(0x10))
}

public func LL_PWR_IsEnabledMonitoring<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr1) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_PWR_ConfigSupply<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ SupplySource: UInt32) {
    registers.write(PowerExtendedRegister.csr2, value: (registers.read(PowerExtendedRegister.csr2) & ~((0x10 | 0x8 | 0x4 | 0x2 | 0x1))) | (SupplySource))
}

public func LL_PWR_GetSupply<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(PowerExtendedRegister.csr2) & ((0x10 | 0x8 | 0x4 | 0x2 | 0x1)))
}

public func LL_PWR_EnableBatteryCharging<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) | (0x100))
}

public func LL_PWR_DisableBatteryCharging<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) & ~(0x100))
}

public func LL_PWR_IsEnabledBatteryCharging<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr2) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_PWR_SetBattChargResistor<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ Resistor: UInt32) {
    registers.write(PowerExtendedRegister.csr2, value: (registers.read(PowerExtendedRegister.csr2) & ~(0x200)) | (Resistor))
}

public func LL_PWR_GetBattChargResistor<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(PowerExtendedRegister.csr2) & (0x200)))
}

public func LL_PWR_SetXSPI1Capacitor<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ Capacitor: UInt32) {
    registers.write(PowerExtendedRegister.csr2, value: (registers.read(PowerExtendedRegister.csr2) & ~(0xC00)) | (Capacitor))
}

public func LL_PWR_GetXSPI1Capacitor<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(PowerExtendedRegister.csr2) & (0xC00)))
}

public func LL_PWR_SetXSPI2Capacitor<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ Capacitor: UInt32) {
    registers.write(PowerExtendedRegister.csr2, value: (registers.read(PowerExtendedRegister.csr2) & ~(0x3000)) | (Capacitor))
}

public func LL_PWR_GetXSPI2Capacitor<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(PowerExtendedRegister.csr2) & (0x3000)))
}

public func LL_PWR_EnableUSBVoltageDetector<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) | (0x1000000))
}

public func LL_PWR_DisableUSBVoltageDetector<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) & ~(0x1000000))
}

public func LL_PWR_IsEnabledUSBVoltageDetector<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr2) & (0x1000000)) == (0x1000000)) ? 1 : 0)
}

public func LL_PWR_EnableUSBReg<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) | (0x2000000))
}

public func LL_PWR_DisableUSBReg<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) & ~(0x2000000))
}

public func LL_PWR_IsEnabledUSBReg<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr2) & (0x2000000)) == (0x2000000)) ? 1 : 0)
}

public func LL_PWR_EnableUSBHSPHYReg<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) | (0x8000000))
}

public func LL_PWR_DisableUSBHSPHYReg<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) & ~(0x8000000))
}

public func LL_PWR_IsEnabledUSBHSPHYReg<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr2) & (0x8000000)) == (0x8000000)) ? 1 : 0)
}

public func LL_PWR_EnableUCPDStandbyMode<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.ucpdr, value: registers.read(PowerExtendedRegister.ucpdr) | (0x2))
}

public func LL_PWR_DisableUCPDStandbyMode<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.ucpdr, value: registers.read(PowerExtendedRegister.ucpdr) & ~(0x2))
}

public func LL_PWR_IsEnabledUCPDStandbyMode<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.ucpdr) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_PWR_EnableUCPDDeadBattery<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.ucpdr, value: registers.read(PowerExtendedRegister.ucpdr) & ~(0x1))
}

public func LL_PWR_DisableUCPDDeadBattery<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.ucpdr, value: registers.read(PowerExtendedRegister.ucpdr) | (0x1))
}

public func LL_PWR_IsEnabledUCPDDeadBattery<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.ucpdr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_PWR_EnableXSPIM1<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) | (0x4000))
}

public func LL_PWR_DisableXSPIM1<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) & ~(0x4000))
}

public func LL_PWR_IsEnabledXSPIM1<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr2) & (0x4000)) == (0x4000)) ? 1 : 0)
}

public func LL_PWR_EnableXSPIM2<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) | (0x8000))
}

public func LL_PWR_DisableXSPIM2<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr2, value: registers.read(PowerExtendedRegister.csr2) & ~(0x8000))
}

public func LL_PWR_IsEnabledXSPIM2<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr2) & (0x8000)) == (0x8000)) ? 1 : 0)
}

public func LL_PWR_SetPowerDownModeDS<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ PDMode: UInt32) {
    registers.write(PowerExtendedRegister.csr3, value: (registers.read(PowerExtendedRegister.csr3) & ~(0x1)) | (PDMode))
}

public func LL_PWR_GetPowerDownModeDS<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(PowerExtendedRegister.csr3) & (0x1)))
}

public func LL_PWR_SetRegulVoltageScaling<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ VoltageScaling: UInt32) {
    registers.write(PowerExtendedRegister.csr4, value: (registers.read(PowerExtendedRegister.csr4) & ~(0x1)) | (VoltageScaling))
}

public func LL_PWR_GetRegulVoltageScaling<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(PowerExtendedRegister.csr4) & (0x1)))
}

public func LL_PWR_SetStopModeRegulVoltageScaling<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ VoltageScaling: UInt32) {
    registers.write(PowerExtendedRegister.cr1, value: (registers.read(PowerExtendedRegister.cr1) & ~(0x1)) | (VoltageScaling))
}

public func LL_PWR_GetStopModeRegulVoltageScaling<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(PowerExtendedRegister.cr1) & (0x1))
}

public func LL_PWR_EnableWakeUpPin<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) {
    registers.write(PowerExtendedRegister.wakeupEnablePolarity, value: registers.read(PowerExtendedRegister.wakeupEnablePolarity) | (WakeUpPin))
}

public func LL_PWR_DisableWakeUpPin<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) {
    registers.write(PowerExtendedRegister.wakeupEnablePolarity, value: registers.read(PowerExtendedRegister.wakeupEnablePolarity) & ~(WakeUpPin))
}

public func LL_PWR_IsEnabledWakeUpPin<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.wakeupEnablePolarity) & (WakeUpPin)) == (WakeUpPin)) ? 1 : 0)
}

public func LL_PWR_SetWakeUpPinPolarityLow<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) {
    registers.write(PowerExtendedRegister.wakeupEnablePolarity, value: registers.read(PowerExtendedRegister.wakeupEnablePolarity) | ((WakeUpPin << 0x8)))
}

public func LL_PWR_SetWakeUpPinPolarityHigh<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) {
    registers.write(PowerExtendedRegister.wakeupEnablePolarity, value: registers.read(PowerExtendedRegister.wakeupEnablePolarity) & ~((WakeUpPin << 0x8)))
}

public func LL_PWR_IsWakeUpPinPolarityLow<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.wakeupEnablePolarity) & ((WakeUpPin << 0x8))) == (WakeUpPin << 0x8)) ? 1 : 0)
}

public func LL_PWR_SetWakeUpPinPullNone<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) {
    registers.write(PowerExtendedRegister.wakeupEnablePolarity, value: (registers.read(PowerExtendedRegister.wakeupEnablePolarity) & ~((0x30000 << ((LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET &* UInt32(WakeUpPin.trailingZeroBitCount)) & LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK)))) | ((LL_PWR_WAKEUP_PIN_NOPULL << ((0x10 &+ (LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET &* UInt32(WakeUpPin.trailingZeroBitCount))) & LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK))))
}

public func LL_PWR_SetWakeUpPinPullUp<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) {
    registers.write(PowerExtendedRegister.wakeupEnablePolarity, value: (registers.read(PowerExtendedRegister.wakeupEnablePolarity) & ~((0x30000 << ((LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET &* UInt32(WakeUpPin.trailingZeroBitCount)) & LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK)))) | ((LL_PWR_WAKEUP_PIN_PULLUP << ((0x10 &+ (LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET &* UInt32(WakeUpPin.trailingZeroBitCount))) & LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK))))
}

public func LL_PWR_SetWakeUpPinPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) {
    registers.write(PowerExtendedRegister.wakeupEnablePolarity, value: (registers.read(PowerExtendedRegister.wakeupEnablePolarity) & ~((0x30000 << ((LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET &* UInt32(WakeUpPin.trailingZeroBitCount)) & LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK)))) | ((LL_PWR_WAKEUP_PIN_PULLDOWN << ((0x10 &+ (LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET &* UInt32(WakeUpPin.trailingZeroBitCount))) & LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK))))
}

public func LL_PWR_GetWakeUpPinPull<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ WakeUpPin: UInt32) -> UInt32 {
    let regValue: UInt32 = (registers.read(PowerExtendedRegister.wakeupEnablePolarity) & ((0x30000 << ((LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET &* UInt32(WakeUpPin.trailingZeroBitCount)) & LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK))))
    return (regValue >> ((0x10 &+ (LL_PWR_WAKEUP_PINS_PULL_SHIFT_OFFSET &* UInt32(WakeUpPin.trailingZeroBitCount))) & LL_PWR_WAKEUP_PINS_MAX_SHIFT_MASK))
}

public func LL_PWR_EnableI3CPB6PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) | (0x10000000))
}

public func LL_PWR_DisableI3CPB6PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) & ~(0x10000000))
}

public func LL_PWR_IsEnabledI3CPB6PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.apcr) & (0x10000000)) == (0x10000000)) ? 1 : 0)
}

public func LL_PWR_EnableI3CPB7PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) | (0x20000000))
}

public func LL_PWR_DisableI3CPB7PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) & ~(0x20000000))
}

public func LL_PWR_IsEnabledI3CPB7PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.apcr) & (0x20000000)) == (0x20000000)) ? 1 : 0)
}

public func LL_PWR_EnableI3CPB8PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) | (0x40000000))
}

public func LL_PWR_DisableI3CPB8PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) & ~(0x40000000))
}

public func LL_PWR_IsEnabledI3CPB8PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.apcr) & (0x40000000)) == (0x40000000)) ? 1 : 0)
}

public func LL_PWR_EnableI3CPB9PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) | (0x80000000))
}

public func LL_PWR_DisableI3CPB9PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) & ~(0x80000000))
}

public func LL_PWR_IsEnabledI3CPB9PU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.apcr) & (0x80000000)) == (0x80000000)) ? 1 : 0)
}

public func LL_PWR_EnablePUPDConfig<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) | (0x1))
}

public func LL_PWR_DisablePUPDConfig<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.apcr, value: registers.read(PowerExtendedRegister.apcr) & ~(0x1))
}

public func LL_PWR_IsEnabledPUPDConfig<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.apcr) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_PWR_EnableGPIONPullUp<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullUpN, value: registers.read(PowerExtendedRegister.pullUpN) | (GPIOPin))
}

public func LL_PWR_DisableGPIONPullUp<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullUpN, value: registers.read(PowerExtendedRegister.pullUpN) & ~(GPIOPin))
}

public func LL_PWR_IsEnabledGPIONPullUp<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.pullUpN) & (GPIOPin)) == (GPIOPin)) ? 1 : 0)
}

public func LL_PWR_EnableGPIOOPullUp<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullUpO, value: registers.read(PowerExtendedRegister.pullUpO) | (GPIOPin))
}

public func LL_PWR_DisableGPIOOPullUp<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullUpO, value: registers.read(PowerExtendedRegister.pullUpO) & ~(GPIOPin))
}

public func LL_PWR_IsEnabledGPIOOPullUp<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.pullUpO) & (GPIOPin)) == (GPIOPin)) ? 1 : 0)
}

public func LL_PWR_EnableGPIONPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullDownN, value: registers.read(PowerExtendedRegister.pullDownN) | (GPIOPin))
}

public func LL_PWR_DisableGPIONPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullDownN, value: registers.read(PowerExtendedRegister.pullDownN) & ~(GPIOPin))
}

public func LL_PWR_IsEnabledGPIONPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.pullDownN) & (GPIOPin)) == (GPIOPin)) ? 1 : 0)
}

public func LL_PWR_EnableGPIOOPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullDownO, value: registers.read(PowerExtendedRegister.pullDownO) | (GPIOPin))
}

public func LL_PWR_DisableGPIOOPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullDownO, value: registers.read(PowerExtendedRegister.pullDownO) & ~(GPIOPin))
}

public func LL_PWR_IsEnabledGPIOOPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.pullDownO) & (GPIOPin)) == (GPIOPin)) ? 1 : 0)
}

public func LL_PWR_EnableGPIOPPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullDownP, value: registers.read(PowerExtendedRegister.pullDownP) | (GPIOPin))
}

public func LL_PWR_DisableGPIOPPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) {
    registers.write(PowerExtendedRegister.pullDownP, value: registers.read(PowerExtendedRegister.pullDownP) & ~(GPIOPin))
}

public func LL_PWR_IsEnabledGPIOPPullDown<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ GPIOPin: UInt32) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.pullDownP) & (GPIOPin)) == (GPIOPin)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_ACTVOSRDY<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.sr1) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_PVDO<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.sr1) & (0x10)) == (0x10)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_AVDO<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.sr1) & (0x2000)) == (0x2000)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_BRRDY<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr1) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_VBATL<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr1) & (0x100000)) == (0x100000)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_VBATH<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr1) & (0x200000)) == (0x200000)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_TEMPL<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr1) & (0x400000)) == (0x400000)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_TEMPH<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr1) & (0x800000)) == (0x800000)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_SDEXTRDY<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr2) & (0x10000)) == (0x10000)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_USB33RDY<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr2) & (0x4000000)) == (0x4000000)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_STOP<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr3) & (0x100)) == (0x100)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_SB<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr3) & (0x200)) == (0x200)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_VOSRDY<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.csr4) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_WU1<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.wakeupFlags) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_WU2<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.wakeupFlags) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_WU3<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.wakeupFlags) & (0x4)) == (0x4)) ? 1 : 0)
}

public func LL_PWR_IsActiveFlag_WU4<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(PowerExtendedRegister.wakeupFlags) & (0x8)) == (0x8)) ? 1 : 0)
}

public func LL_PWR_ClearFlag_STOP_SB<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.csr3, value: registers.read(PowerExtendedRegister.csr3) | (0x2))
}

public func LL_PWR_ClearFlag_WU1<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.wakeupClear, value: 0x1)
}

public func LL_PWR_ClearFlag_WU2<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.wakeupClear, value: 0x2)
}

public func LL_PWR_ClearFlag_WU3<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.wakeupClear, value: 0x4)
}

public func LL_PWR_ClearFlag_WU4<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.wakeupClear, value: 0x8)
}

public func LL_PWR_ClearFlag_WU<IO: PowerExtendedRegisterIO>(_ registers: inout IO) {
    registers.write(PowerExtendedRegister.wakeupClear, value: 0xF)
}

@discardableResult
public func LL_PWR_DeInit<IO: PowerExtendedRegisterIO>(_ registers: inout IO) -> LLErrorStatus {
    LL_PWR_ClearFlag_STOP_SB(&registers)
    LL_PWR_ClearFlag_WU(&registers)
    return .success
}

public func LL_PWR_WriteReg<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ register: PowerExtendedRegister, _ value: UInt32) {
    registers.write(register, value: value)
}

public func LL_PWR_ReadReg<IO: PowerExtendedRegisterIO>(_ registers: inout IO, _ register: PowerExtendedRegister) -> UInt32 {
    registers.read(register)
}
