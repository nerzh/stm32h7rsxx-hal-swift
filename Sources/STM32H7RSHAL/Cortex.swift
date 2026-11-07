// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// Copyright (c) 2009-2025 Arm Limited. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Port of stm32h7rsxx_hal_cortex.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748
// and CMSIS_6 core_cm7.h at 3c860f7a5810a34205bdbadb84b6d5f78f1cb322.
// See LICENSES/NOTICE.txt, LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt,
// and LICENSES/ARM-CMSIS-Apache-2.0.txt.

public enum CortexRegister: Hashable {
    case aircr, shcsr
    case sysTickControl, sysTickReload, sysTickCurrent
    case mpuControl, mpuRegionNumber, mpuRegionBaseAddress, mpuRegionAttributes
    case nvicSetEnable(bank: Int), nvicClearEnable(bank: Int)
    case nvicSetPending(bank: Int), nvicClearPending(bank: Int), nvicActive(bank: Int)
}

public enum CortexPriorityRegister: Hashable {
    case device(index: Int)
    case system(index: Int)
}

public enum CortexInstruction: Equatable {
    case compilerBarrier, dataMemoryBarrier, dataSynchronizationBarrier
    case instructionSynchronizationBarrier, sendEvent, waitForEvent, noOperation
}

public protocol CortexRegisterIO {
    mutating func read(_ register: CortexRegister) -> UInt32
    mutating func write(_ register: CortexRegister, value: UInt32)
    // NVIC IPR and SCB SHPR use volatile byte accesses, as in CMSIS.
    mutating func readPriority(_ register: CortexPriorityRegister) -> UInt8
    mutating func writePriority(_ register: CortexPriorityRegister, value: UInt8)
    mutating func perform(_ instruction: CortexInstruction)
}

public enum SysTickClockSource: UInt32 {
    case hclkDiv8 = 0
    case hclk = 4
}

public struct NVICPriority: Equatable {
    public var preemptPriority: UInt32
    public var subpriority: UInt32

    public init(preemptPriority: UInt32, subpriority: UInt32) {
        self.preemptPriority = preemptPriority
        self.subpriority = subpriority
    }
}

public struct MPURegionConfiguration {
    public var number: UInt32
    public var baseAddress: UInt32
    // The encoded SIZE field: 4 = 32 bytes, ... 31 = 4 GiB.
    public var size: UInt32
    public var enable: Bool
    public var disableExecute: Bool
    public var accessPermission: UInt32
    public var typeExtension: UInt32
    public var shareable: Bool
    public var cacheable: Bool
    public var bufferable: Bool
    public var subregionDisable: UInt8

    public init(number: UInt32, baseAddress: UInt32, size: UInt32,
                enable: Bool = true, disableExecute: Bool = false,
                accessPermission: UInt32 = 0, typeExtension: UInt32 = 0,
                shareable: Bool = false, cacheable: Bool = false,
                bufferable: Bool = false, subregionDisable: UInt8 = 0) {
        self.number = number
        self.baseAddress = baseAddress
        self.size = size
        self.enable = enable
        self.disableExecute = disableExecute
        self.accessPermission = accessPermission
        self.typeExtension = typeExtension
        self.shareable = shareable
        self.cacheable = cacheable
        self.bufferable = bufferable
        self.subregionDisable = subregionDisable
    }
}

public struct Cortex<IO: CortexRegisterIO> {
    public var registers: IO

    public init(registers: IO) {
        self.registers = registers
    }

    public mutating func setPriorityGrouping(_ group: UInt32) {
        precondition(group >= 3 && group <= 7)
        let temporaryGroup = group & 7
        var value = registers.read(.aircr)
        value &= ~(UInt32(0xFFFF0000) | 0x00000700)
        value |= (0x5FA << 16) | (temporaryGroup << 8)
        registers.write(.aircr, value: value)
    }

    public mutating func priorityGrouping() -> UInt32 {
        (registers.read(.aircr) & 0x700) >> 8
    }

    public mutating func setPriority(irq: Int32, preemptPriority: UInt32, subpriority: UInt32) {
        precondition(irq > -13 && irq != -4)
        let group = priorityGrouping()
        precondition(group < 3 ? subpriority < 1 : subpriority < (1 << (group - 3)))
        precondition(preemptPriority < 16 && preemptPriority < (1 << (7 - group)))
        let priority = Self.encodePriority(group: group, preemptPriority: preemptPriority, subpriority: subpriority)
        writeEncodedPriority(irq: irq, priority: priority)
    }

    public mutating func getPriority(irq: Int32, group: UInt32) -> NVICPriority {
        precondition(irq > -13 && irq != -4)
        precondition(group >= 3 && group <= 7)
        let priority = UInt32(registers.readPriority(Self.priorityRegister(irq: irq))) >> 4
        return Self.decodePriority(priority, group: group)
    }

    public static func encodePriority(group: UInt32, preemptPriority: UInt32, subpriority: UInt32) -> UInt32 {
        let temporaryGroup = group & 7
        let preemptBits: UInt32 = (7 - temporaryGroup) > 4 ? 4 : (7 - temporaryGroup)
        let subBits: UInt32 = (temporaryGroup + 4) < 7 ? 0 : ((temporaryGroup &- 7) &+ 4)
        return ((preemptPriority & ((1 << preemptBits) - 1)) << subBits)
            | (subpriority & ((1 << subBits) - 1))
    }

    public static func decodePriority(_ priority: UInt32, group: UInt32) -> NVICPriority {
        let temporaryGroup = group & 7
        let preemptBits: UInt32 = (7 - temporaryGroup) > 4 ? 4 : (7 - temporaryGroup)
        let subBits: UInt32 = (temporaryGroup + 4) < 7 ? 0 : ((temporaryGroup &- 7) &+ 4)
        return NVICPriority(
            preemptPriority: (priority >> subBits) & ((1 << preemptBits) - 1),
            subpriority: priority & ((1 << subBits) - 1)
        )
    }

    public mutating func enableIRQ(_ irq: Int32) {
        precondition(irq >= 0)
        let number = UInt32(irq)
        registers.perform(.compilerBarrier)
        registers.write(.nvicSetEnable(bank: Int(number >> 5)), value: 1 << (number & 0x1F))
        registers.perform(.compilerBarrier)
    }

    public mutating func disableIRQ(_ irq: Int32) {
        precondition(irq >= 0)
        let number = UInt32(irq)
        registers.write(.nvicClearEnable(bank: Int(number >> 5)), value: 1 << (number & 0x1F))
        registers.perform(.dataSynchronizationBarrier)
        registers.perform(.instructionSynchronizationBarrier)
    }

    public mutating func setPendingIRQ(_ irq: Int32) {
        precondition(irq >= 0)
        let number = UInt32(irq)
        registers.write(.nvicSetPending(bank: Int(number >> 5)), value: 1 << (number & 0x1F))
    }

    public mutating func getPendingIRQ(_ irq: Int32) -> UInt32 {
        precondition(irq >= 0)
        let number = UInt32(irq)
        return (registers.read(.nvicSetPending(bank: Int(number >> 5))) & (1 << (number & 0x1F))) != 0 ? 1 : 0
    }

    public mutating func clearPendingIRQ(_ irq: Int32) {
        precondition(irq >= 0)
        let number = UInt32(irq)
        registers.write(.nvicClearPending(bank: Int(number >> 5)), value: 1 << (number & 0x1F))
    }

    public mutating func getActive(_ irq: Int32) -> UInt32 {
        // HAL delegates directly to CMSIS here; negative IRQs return zero.
        guard irq >= 0 else { return 0 }
        let number = UInt32(irq)
        return (registers.read(.nvicActive(bank: Int(number >> 5))) & (1 << (number & 0x1F))) != 0 ? 1 : 0
    }

    public mutating func systemReset() -> Never {
        requestSystemReset()
        while true { registers.perform(.noOperation) }
    }

    // Kept separate so host tests can verify the reset writes without executing
    // the CMSIS non-returning wait loop or resetting the host.
    mutating func requestSystemReset() {
        registers.perform(.dataSynchronizationBarrier)
        let group = registers.read(.aircr) & 0x700
        registers.write(.aircr, value: (0x5FA << 16) | group | 4)
        registers.perform(.dataSynchronizationBarrier)
    }

    public mutating func configureSysTick(ticks: UInt32) -> UInt32 {
        if (ticks &- 1) > 0x00FFFFFF { return 1 }
        registers.write(.sysTickReload, value: ticks &- 1)
        writeEncodedPriority(irq: -1, priority: 15)
        registers.write(.sysTickCurrent, value: 0)
        registers.write(.sysTickControl, value: 7)
        return 0
    }

    public mutating func setSysTickClockSource(_ source: SysTickClockSource) {
        let value = (registers.read(.sysTickControl) & ~UInt32(4)) | source.rawValue
        registers.write(.sysTickControl, value: value)
    }

    public func sysTickIRQHandler(callback: () -> Void = {}) {
        callback()
    }

    public mutating func enableMPU(control: UInt32) {
        registers.perform(.dataMemoryBarrier)
        registers.write(.mpuControl, value: control | 1)
        let value = registers.read(.shcsr) | (1 << 16)
        registers.write(.shcsr, value: value)
        registers.perform(.dataSynchronizationBarrier)
        registers.perform(.instructionSynchronizationBarrier)
    }

    public mutating func disableMPU() {
        registers.perform(.dataMemoryBarrier)
        let value = registers.read(.shcsr) & ~(UInt32(1) << 16)
        registers.write(.shcsr, value: value)
        registers.write(.mpuControl, value: 0)
        registers.perform(.dataSynchronizationBarrier)
        registers.perform(.instructionSynchronizationBarrier)
    }

    public mutating func enableMPURegion(_ number: UInt32) {
        precondition(number <= 15)
        registers.write(.mpuRegionNumber, value: number)
        let value = registers.read(.mpuRegionAttributes) | 1
        registers.write(.mpuRegionAttributes, value: value)
    }

    public mutating func disableMPURegion(_ number: UInt32) {
        precondition(number <= 15)
        registers.write(.mpuRegionNumber, value: number)
        let value = registers.read(.mpuRegionAttributes) & ~UInt32(1)
        registers.write(.mpuRegionAttributes, value: value)
    }

    public mutating func configureMPURegion(_ configuration: MPURegionConfiguration) {
        precondition(configuration.number <= 15)
        registers.write(.mpuRegionNumber, value: configuration.number)
        let access = configuration.accessPermission
        precondition(access <= 3 || access == 5 || access == 6)
        precondition(configuration.typeExtension <= 2)
        precondition(configuration.subregionDisable < 0xFF)
        precondition(configuration.size >= 4 && configuration.size <= 31)
        // The C assertion shifts a 32-bit 1 by 32 for the 4-GiB case. Widening
        // the same bit expression makes the intended alignment check defined.
        let alignmentMask = (UInt64(1) << (configuration.size + 1)) - 1
        precondition((UInt64(configuration.baseAddress) & alignmentMask) == 0)

        var value = registers.read(.mpuRegionAttributes) & ~UInt32(1)
        registers.write(.mpuRegionAttributes, value: value)
        // This second read/clear is intentional: it is present in the C HAL.
        value = registers.read(.mpuRegionAttributes) & ~UInt32(1)
        registers.write(.mpuRegionAttributes, value: value)
        registers.write(.mpuRegionBaseAddress, value: configuration.baseAddress)
        value = (configuration.disableExecute ? UInt32(1) : 0) << 28
        value |= access << 24
        value |= configuration.typeExtension << 19
        value |= (configuration.shareable ? 1 : 0) << 18
        value |= (configuration.cacheable ? 1 : 0) << 17
        value |= (configuration.bufferable ? 1 : 0) << 16
        value |= UInt32(configuration.subregionDisable) << 8
        value |= configuration.size << 1
        value |= configuration.enable ? 1 : 0
        registers.write(.mpuRegionAttributes, value: value)
    }

    public mutating func clearEvent() {
        registers.perform(.sendEvent)
        registers.perform(.waitForEvent)
    }

    private static func priorityRegister(irq: Int32) -> CortexPriorityRegister {
        if irq >= 0 { return .device(index: Int(irq)) }
        return .system(index: Int((UInt32(bitPattern: irq) & 0xF) - 4))
    }

    private mutating func writeEncodedPriority(irq: Int32, priority: UInt32) {
        registers.writePriority(Self.priorityRegister(irq: irq), value: UInt8((priority << 4) & 0xFF))
    }
}
