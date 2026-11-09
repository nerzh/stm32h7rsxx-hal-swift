// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Adapted from ST LL 606ed7132ef1bc32c77fd9a040103bc98f23c748,
// device CMSIS 7e6e213ddc397c76622a0aca2f623ccc3b34c010 and
// Arm CMSIS 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt for attribution and complete license texts.

public enum LLCoreRegister: Hashable, Sendable {
    case cpuid, systemControl
}

public protocol LLCortexRegisterIO: CortexRegisterIO {
    mutating func read(_ register: LLCoreRegister) -> UInt32
    mutating func write(_ register: LLCoreRegister, value: UInt32)
}

public let LL_SYSTICK_CLKSOURCE_HCLK_DIV8: UInt32 = 0x00000000
public let LL_SYSTICK_CLKSOURCE_HCLK: UInt32 = 0x00000004
public let LL_HANDLER_FAULT_USG: UInt32 = 0x00040000
public let LL_HANDLER_FAULT_BUS: UInt32 = 0x00020000
public let LL_HANDLER_FAULT_MEM: UInt32 = 0x00010000
public let LL_MPU_CTRL_HFNMI_PRIVDEF_NONE: UInt32 = 0x00000000
public let LL_MPU_CTRL_HARDFAULT_NMI: UInt32 = 0x00000002
public let LL_MPU_CTRL_PRIVILEGED_DEFAULT: UInt32 = 0x00000004
public let LL_MPU_CTRL_HFNMI_PRIVDEF: UInt32 = 0x00000006
public let LL_MPU_REGION_NUMBER0: UInt32 = 0x00000000
public let LL_MPU_REGION_NUMBER1: UInt32 = 0x00000001
public let LL_MPU_REGION_NUMBER2: UInt32 = 0x00000002
public let LL_MPU_REGION_NUMBER3: UInt32 = 0x00000003
public let LL_MPU_REGION_NUMBER4: UInt32 = 0x00000004
public let LL_MPU_REGION_NUMBER5: UInt32 = 0x00000005
public let LL_MPU_REGION_NUMBER6: UInt32 = 0x00000006
public let LL_MPU_REGION_NUMBER7: UInt32 = 0x00000007
public let LL_MPU_REGION_NUMBER8: UInt32 = 0x00000008
public let LL_MPU_REGION_NUMBER9: UInt32 = 0x00000009
public let LL_MPU_REGION_NUMBER10: UInt32 = 0x0000000A
public let LL_MPU_REGION_NUMBER11: UInt32 = 0x0000000B
public let LL_MPU_REGION_NUMBER12: UInt32 = 0x0000000C
public let LL_MPU_REGION_NUMBER13: UInt32 = 0x0000000D
public let LL_MPU_REGION_NUMBER14: UInt32 = 0x0000000E
public let LL_MPU_REGION_NUMBER15: UInt32 = 0x0000000F
public let LL_MPU_REGION_SIZE_32B: UInt32 = 0x00000008
public let LL_MPU_REGION_SIZE_64B: UInt32 = 0x0000000A
public let LL_MPU_REGION_SIZE_128B: UInt32 = 0x0000000C
public let LL_MPU_REGION_SIZE_256B: UInt32 = 0x0000000E
public let LL_MPU_REGION_SIZE_512B: UInt32 = 0x00000010
public let LL_MPU_REGION_SIZE_1KB: UInt32 = 0x00000012
public let LL_MPU_REGION_SIZE_2KB: UInt32 = 0x00000014
public let LL_MPU_REGION_SIZE_4KB: UInt32 = 0x00000016
public let LL_MPU_REGION_SIZE_8KB: UInt32 = 0x00000018
public let LL_MPU_REGION_SIZE_16KB: UInt32 = 0x0000001A
public let LL_MPU_REGION_SIZE_32KB: UInt32 = 0x0000001C
public let LL_MPU_REGION_SIZE_64KB: UInt32 = 0x0000001E
public let LL_MPU_REGION_SIZE_128KB: UInt32 = 0x00000020
public let LL_MPU_REGION_SIZE_256KB: UInt32 = 0x00000022
public let LL_MPU_REGION_SIZE_512KB: UInt32 = 0x00000024
public let LL_MPU_REGION_SIZE_1MB: UInt32 = 0x00000026
public let LL_MPU_REGION_SIZE_2MB: UInt32 = 0x00000028
public let LL_MPU_REGION_SIZE_4MB: UInt32 = 0x0000002A
public let LL_MPU_REGION_SIZE_8MB: UInt32 = 0x0000002C
public let LL_MPU_REGION_SIZE_16MB: UInt32 = 0x0000002E
public let LL_MPU_REGION_SIZE_32MB: UInt32 = 0x00000030
public let LL_MPU_REGION_SIZE_64MB: UInt32 = 0x00000032
public let LL_MPU_REGION_SIZE_128MB: UInt32 = 0x00000034
public let LL_MPU_REGION_SIZE_256MB: UInt32 = 0x00000036
public let LL_MPU_REGION_SIZE_512MB: UInt32 = 0x00000038
public let LL_MPU_REGION_SIZE_1GB: UInt32 = 0x0000003A
public let LL_MPU_REGION_SIZE_2GB: UInt32 = 0x0000003C
public let LL_MPU_REGION_SIZE_4GB: UInt32 = 0x0000003E
public let LL_MPU_REGION_NO_ACCESS: UInt32 = 0x00000000
public let LL_MPU_REGION_PRIV_RW: UInt32 = 0x01000000
public let LL_MPU_REGION_PRIV_RW_URO: UInt32 = 0x02000000
public let LL_MPU_REGION_FULL_ACCESS: UInt32 = 0x03000000
public let LL_MPU_REGION_PRIV_RO: UInt32 = 0x05000000
public let LL_MPU_REGION_PRIV_RO_URO: UInt32 = 0x06000000
public let LL_MPU_TEX_LEVEL0: UInt32 = 0x00000000
public let LL_MPU_TEX_LEVEL1: UInt32 = 0x00080000
public let LL_MPU_TEX_LEVEL2: UInt32 = 0x00100000
public let LL_MPU_INSTRUCTION_ACCESS_ENABLE: UInt32 = 0x00000000
public let LL_MPU_INSTRUCTION_ACCESS_DISABLE: UInt32 = 0x10000000
public let LL_MPU_ACCESS_SHAREABLE: UInt32 = 0x00040000
public let LL_MPU_ACCESS_NOT_SHAREABLE: UInt32 = 0x00000000
public let LL_MPU_ACCESS_CACHEABLE: UInt32 = 0x00020000
public let LL_MPU_ACCESS_NOT_CACHEABLE: UInt32 = 0x00000000
public let LL_MPU_ACCESS_BUFFERABLE: UInt32 = 0x00010000
public let LL_MPU_ACCESS_NOT_BUFFERABLE: UInt32 = 0x00000000

public func LL_SYSTICK_IsActiveCounterFlag<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CortexRegister.sysTickControl) & 0x10000) == (0x10000)) ? 1 : 0)
}

public func LL_SYSTICK_SetClkSource<IO: LLCortexRegisterIO>(_ registers: inout IO, _ Source: UInt32) {
    registers.write(CortexRegister.sysTickControl, value: (registers.read(CortexRegister.sysTickControl) & ~(LL_SYSTICK_CLKSOURCE_HCLK)) | (Source))
}

public func LL_SYSTICK_GetClkSource<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (registers.read(CortexRegister.sysTickControl) & (LL_SYSTICK_CLKSOURCE_HCLK))
}

public func LL_SYSTICK_EnableIT<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.write(CortexRegister.sysTickControl, value: registers.read(CortexRegister.sysTickControl) | (0x2))
}

public func LL_SYSTICK_DisableIT<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.write(CortexRegister.sysTickControl, value: registers.read(CortexRegister.sysTickControl) & ~(0x2))
}

public func LL_SYSTICK_IsEnabledIT<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CortexRegister.sysTickControl) & (0x2)) == (0x2)) ? 1 : 0)
}

public func LL_LPM_EnableSleep<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.write(LLCoreRegister.systemControl, value: registers.read(LLCoreRegister.systemControl) & ~(0x4))
}

public func LL_LPM_EnableDeepSleep<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.write(LLCoreRegister.systemControl, value: registers.read(LLCoreRegister.systemControl) | (0x4))
}

public func LL_LPM_EnableSleepOnExit<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.write(LLCoreRegister.systemControl, value: registers.read(LLCoreRegister.systemControl) | (0x2))
}

public func LL_LPM_DisableSleepOnExit<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.write(LLCoreRegister.systemControl, value: registers.read(LLCoreRegister.systemControl) & ~(0x2))
}

public func LL_LPM_EnableEventOnPend<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.write(LLCoreRegister.systemControl, value: registers.read(LLCoreRegister.systemControl) | (0x10))
}

public func LL_LPM_DisableEventOnPend<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.write(LLCoreRegister.systemControl, value: registers.read(LLCoreRegister.systemControl) & ~(0x10))
}

public func LL_LPM_ClearEvent<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.perform(.sendEvent)
    registers.perform(.waitForEvent)
}

public func LL_HANDLER_EnableFault<IO: LLCortexRegisterIO>(_ registers: inout IO, _ Fault: UInt32) {
    registers.write(CortexRegister.shcsr, value: registers.read(CortexRegister.shcsr) | (Fault))
}

public func LL_HANDLER_DisableFault<IO: LLCortexRegisterIO>(_ registers: inout IO, _ Fault: UInt32) {
    registers.write(CortexRegister.shcsr, value: registers.read(CortexRegister.shcsr) & ~(Fault))
}

public func LL_CPUID_GetImplementer<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLCoreRegister.cpuid) & (0xFF000000)) >> 0x18)
}

public func LL_CPUID_GetVariant<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLCoreRegister.cpuid) & (0xF00000)) >> 0x14)
}

public func LL_CPUID_GetArchitecture<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLCoreRegister.cpuid) & (0xF0000)) >> 0x10)
}

public func LL_CPUID_GetParNo<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLCoreRegister.cpuid) & (0xFFF0)) >> 0x4)
}

public func LL_CPUID_GetRevision<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return ((registers.read(LLCoreRegister.cpuid) & (0xF)) >> 0x0)
}

public func LL_MPU_Enable<IO: LLCortexRegisterIO>(_ registers: inout IO, _ MPU_Control: UInt32) {
    registers.perform(.dataMemoryBarrier)
    registers.write(CortexRegister.mpuControl, value: (MPU_Control | 0x1))
    registers.perform(.dataSynchronizationBarrier)
    registers.perform(.instructionSynchronizationBarrier)
}

public func LL_MPU_Disable<IO: LLCortexRegisterIO>(_ registers: inout IO) {
    registers.perform(.dataMemoryBarrier)
    registers.write(CortexRegister.mpuControl, value: 0)
}

public func LL_MPU_IsEnabled<IO: LLCortexRegisterIO>(_ registers: inout IO) -> UInt32 {
    return (((registers.read(CortexRegister.mpuControl) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_MPU_EnableRegion<IO: LLCortexRegisterIO>(_ registers: inout IO, _ Region: UInt32) {
    registers.write(CortexRegister.mpuRegionNumber, value: Region)
    registers.write(CortexRegister.mpuRegionAttributes, value: registers.read(CortexRegister.mpuRegionAttributes) | (0x1))
}

public func LL_MPU_IsEnabled_Region<IO: LLCortexRegisterIO>(_ registers: inout IO, _ Region: UInt32) -> UInt32 {
    registers.write(CortexRegister.mpuRegionNumber, value: Region)
    return (((registers.read(CortexRegister.mpuRegionAttributes) & (0x1)) == (0x1)) ? 1 : 0)
}

public func LL_MPU_ConfigRegion<IO: LLCortexRegisterIO>(_ registers: inout IO, _ Region: UInt32, _ SubRegionDisable: UInt32, _ Address: UInt32, _ Attributes: UInt32) {
    registers.write(CortexRegister.mpuRegionNumber, value: Region)
    registers.write(CortexRegister.mpuRegionBaseAddress, value: (Address & 0xFFFFFFE0))
    registers.write(CortexRegister.mpuRegionAttributes, value: (0x1 | Attributes | (SubRegionDisable << 0x8)))
}

public func LL_MPU_DisableRegion<IO: LLCortexRegisterIO>(_ registers: inout IO, _ Region: UInt32) {
    registers.write(CortexRegister.mpuRegionNumber, value: Region)
    registers.write(CortexRegister.mpuRegionAttributes, value: registers.read(CortexRegister.mpuRegionAttributes) & ~(0x1))
}
