import XCTest
@testable import STM32H7RSHAL

private enum CortexAccess: Equatable {
    case read(CortexRegister, UInt32)
    case write(CortexRegister, UInt32)
    case readPriority(CortexPriorityRegister, UInt8)
    case writePriority(CortexPriorityRegister, UInt8)
    case instruction(CortexInstruction)
}

private struct CortexTestRegisters: CortexRegisterIO {
    var values: [CortexRegister: UInt32] = [:]
    var priorities: [CortexPriorityRegister: UInt8] = [:]
    var accesses: [CortexAccess] = []

    mutating func read(_ register: CortexRegister) -> UInt32 {
        let value = values[register, default: 0]
        accesses.append(.read(register, value))
        return value
    }

    mutating func write(_ register: CortexRegister, value: UInt32) {
        accesses.append(.write(register, value))
        values[register] = value
    }

    mutating func readPriority(_ register: CortexPriorityRegister) -> UInt8 {
        let value = priorities[register, default: 0]
        accesses.append(.readPriority(register, value))
        return value
    }

    mutating func writePriority(_ register: CortexPriorityRegister, value: UInt8) {
        accesses.append(.writePriority(register, value))
        priorities[register] = value
    }

    mutating func perform(_ instruction: CortexInstruction) {
        accesses.append(.instruction(instruction))
    }
}

final class CortexTests: XCTestCase {
    func testGroupingWritesUnlockKeyAndPreservesUnrelatedBits() {
        let expected: [UInt32] = [0x05FAABFF, 0x05FAACFF, 0x05FAADFF, 0x05FAAEFF, 0x05FAAFFF]
        for group in UInt32(3)...7 {
            var cortex = Cortex(registers: CortexTestRegisters(values: [.aircr: 0xFFFFAFFF]))
            cortex.setPriorityGrouping(group)
            XCTAssertEqual(cortex.registers.accesses, [
                .read(.aircr, 0xFFFFAFFF), .write(.aircr, expected[Int(group - 3)])
            ])
        }
    }

    func testGroupingReadExtractsOnlyPRIGROUP() {
        for group in UInt32(0)...7 {
            let value = 0xFFFFF8FF | (group << 8)
            var cortex = Cortex(registers: CortexTestRegisters(values: [.aircr: value]))
            XCTAssertEqual(cortex.priorityGrouping(), group)
            XCTAssertEqual(cortex.registers.accesses, [.read(.aircr, value)])
        }
    }

    func testPriorityEncodingAndDecodingAgainstEveryFourBitPriority() {
        // Number of subpriorities in each architectural PRIGROUP setting.
        // Quotient/remainder form an independent oracle for the CMSIS bit logic.
        let subpriorityCounts: [UInt32] = [1, 1, 1, 1, 2, 4, 8, 16]
        for group in UInt32(0)...7 {
            let count = subpriorityCounts[Int(group)]
            for priority in UInt32(0)...15 {
                let expected = NVICPriority(preemptPriority: priority / count, subpriority: priority % count)
                XCTAssertEqual(Cortex<CortexTestRegisters>.decodePriority(priority, group: group), expected)
                XCTAssertEqual(Cortex<CortexTestRegisters>.encodePriority(
                    group: group, preemptPriority: expected.preemptPriority, subpriority: expected.subpriority
                ), priority)
                // CMSIS masks higher PRIGROUP and priority input bits.
                XCTAssertEqual(Cortex<CortexTestRegisters>.decodePriority(priority | 0xFFFFFFF0, group: group | 0xFFFFFFF8), expected)
                XCTAssertEqual(Cortex<CortexTestRegisters>.encodePriority(
                    group: group | 0xFFFFFFF8,
                    preemptPriority: expected.preemptPriority | 0xFFFFFFF0,
                    subpriority: expected.subpriority | 0xFFFFFFF0
                ), priority)
            }
        }
    }

    func testSettingAndReadingAllPriorityValuesUsesByteAccesses() {
        let subpriorityCounts: [UInt32] = [1, 2, 4, 8, 16]
        let interrupts: [(Int32, CortexPriorityRegister)] = [
            (-12, .system(index: 0)), (-11, .system(index: 1)), (-10, .system(index: 2)),
            (-5, .system(index: 7)), (-2, .system(index: 10)), (-1, .system(index: 11)),
            (0, .device(index: 0)), (17, .device(index: 17)), (155, .device(index: 155))
        ]
        for group in UInt32(3)...7 {
            let count = subpriorityCounts[Int(group - 3)]
            for priority in UInt32(0)...15 {
                let preempt = priority / count
                let sub = priority % count
                let byte = UInt8(priority * 16)
                for (irq, register) in interrupts {
                    var cortex = Cortex(registers: CortexTestRegisters(values: [.aircr: group << 8]))
                    cortex.setPriority(irq: irq, preemptPriority: preempt, subpriority: sub)
                    XCTAssertEqual(cortex.registers.accesses, [
                        .read(.aircr, group << 8), .writePriority(register, byte)
                    ])
                    cortex.registers.accesses = []
                    // Unimplemented low bits cannot change the decoded priority.
                    cortex.registers.priorities[register] = byte | 0x0F
                    XCTAssertEqual(cortex.getPriority(irq: irq, group: group),
                                   NVICPriority(preemptPriority: preempt, subpriority: sub))
                    XCTAssertEqual(cortex.registers.accesses, [.readPriority(register, byte | 0x0F)])
                }
            }
        }
    }

    func testSettingPriorityBeforeGroupingAcceptsResetPRIGROUP() {
        var cortex = Cortex(registers: CortexTestRegisters())
        cortex.setPriority(irq: -1, preemptPriority: 15, subpriority: 0)
        XCTAssertEqual(cortex.registers.accesses, [
            .read(.aircr, 0), .writePriority(.system(index: 11), 0xF0)
        ])
    }

    func testEnableAndDisableIRQAcrossBankBoundaries() {
        let vectors: [(Int32, Int, UInt32)] = [
            (0, 0, 1), (31, 0, 0x80000000), (32, 1, 1),
            (63, 1, 0x80000000), (64, 2, 1), (155, 4, 0x08000000)
        ]
        for (irq, bank, mask) in vectors {
            var cortex = Cortex(registers: CortexTestRegisters())
            cortex.enableIRQ(irq)
            XCTAssertEqual(cortex.registers.accesses, [
                .instruction(.compilerBarrier), .write(.nvicSetEnable(bank: bank), mask),
                .instruction(.compilerBarrier)
            ])
            cortex.registers.accesses = []
            cortex.disableIRQ(irq)
            XCTAssertEqual(cortex.registers.accesses, [
                .write(.nvicClearEnable(bank: bank), mask), .instruction(.dataSynchronizationBarrier),
                .instruction(.instructionSynchronizationBarrier)
            ])
        }
    }

    func testPendingAndActiveUseSelectedBitWithoutReadModifyWrite() {
        for irq in Int32(0)...155 {
            let bank = Int(irq / 32)
            let mask = UInt32(1) << (irq % 32)
            var cortex = Cortex(registers: CortexTestRegisters())
            cortex.setPendingIRQ(irq)
            cortex.clearPendingIRQ(irq)
            XCTAssertEqual(cortex.registers.accesses, [
                .write(.nvicSetPending(bank: bank), mask), .write(.nvicClearPending(bank: bank), mask)
            ])
            let bitVectors: [(UInt32, UInt32)] = [(mask, 1), (~mask, 0), (UInt32.max, 1), (0, 0)]
            for (bits, expected) in bitVectors {
                cortex.registers.values[.nvicSetPending(bank: bank)] = bits
                cortex.registers.values[.nvicActive(bank: bank)] = bits
                cortex.registers.accesses = []
                XCTAssertEqual(cortex.getPendingIRQ(irq), expected)
                XCTAssertEqual(cortex.getActive(irq), expected)
                XCTAssertEqual(cortex.registers.accesses, [
                    .read(.nvicSetPending(bank: bank), bits), .read(.nvicActive(bank: bank), bits)
                ])
            }
        }
    }

    func testNegativeActiveIRQReturnsZeroWithoutRegisterAccess() {
        var cortex = Cortex(registers: CortexTestRegisters())
        for irq in Int32(-16) ... -1 {
            XCTAssertEqual(cortex.getActive(irq), 0)
        }
        XCTAssertTrue(cortex.registers.accesses.isEmpty)
    }

    func testResetKeepsGroupingAndDiscardsOtherAIRCRBits() {
        var cortex = Cortex(registers: CortexTestRegisters(values: [.aircr: 0xFFFFFFFF]))
        cortex.requestSystemReset()
        XCTAssertEqual(cortex.registers.accesses, [
            .instruction(.dataSynchronizationBarrier), .read(.aircr, 0xFFFFFFFF),
            .write(.aircr, 0x05FA0704), .instruction(.dataSynchronizationBarrier)
        ])
    }

    func testSysTickAcceptsOneTickAndFull24BitReload() {
        let vectors: [(UInt32, UInt32)] = [(1, 0), (64000, 63999), (0x01000000, 0x00FFFFFF)]
        for (ticks, reload) in vectors {
            var cortex = Cortex(registers: CortexTestRegisters())
            XCTAssertEqual(cortex.configureSysTick(ticks: ticks), 0)
            XCTAssertEqual(cortex.registers.accesses, [
                .write(.sysTickReload, reload), .writePriority(.system(index: 11), 0xF0),
                .write(.sysTickCurrent, 0), .write(.sysTickControl, 7)
            ])
        }
    }

    func testSysTickRejectsZeroAndOverflowWithoutChangingRegisters() {
        for ticks in [UInt32(0), 0x01000001, UInt32.max] {
            var cortex = Cortex(registers: CortexTestRegisters(values: [.sysTickControl: 7]))
            XCTAssertEqual(cortex.configureSysTick(ticks: ticks), 1)
            XCTAssertTrue(cortex.registers.accesses.isEmpty)
            XCTAssertEqual(cortex.registers.values[.sysTickControl], 7)
        }
    }

    func testSysTickClockSourcePreservesOtherControlBits() {
        var cortex = Cortex(registers: CortexTestRegisters(values: [.sysTickControl: 0x00010007]))
        cortex.setSysTickClockSource(.hclkDiv8)
        cortex.setSysTickClockSource(.hclk)
        XCTAssertEqual(cortex.registers.accesses, [
            .read(.sysTickControl, 0x00010007), .write(.sysTickControl, 0x00010003),
            .read(.sysTickControl, 0x00010003), .write(.sysTickControl, 0x00010007)
        ])
    }

    func testSysTickHandlerCallsCallbackExactlyOnce() {
        let cortex = Cortex(registers: CortexTestRegisters())
        var count = 0
        cortex.sysTickIRQHandler { count += 1 }
        cortex.sysTickIRQHandler()
        XCTAssertEqual(count, 1)
        XCTAssertTrue(cortex.registers.accesses.isEmpty)
    }

    func testMPUEnableAndDisablePreserveExceptionBitsAndBarrierOrder() {
        for control in [UInt32(0), 2, 4, 6] {
            var cortex = Cortex(registers: CortexTestRegisters(values: [.shcsr: 0x00068001]))
            cortex.enableMPU(control: control)
            XCTAssertEqual(cortex.registers.accesses, [
                .instruction(.dataMemoryBarrier), .write(.mpuControl, control | 1),
                .read(.shcsr, 0x00068001), .write(.shcsr, 0x00078001),
                .instruction(.dataSynchronizationBarrier), .instruction(.instructionSynchronizationBarrier)
            ])
            cortex.registers.accesses = []
            cortex.disableMPU()
            XCTAssertEqual(cortex.registers.accesses, [
                .instruction(.dataMemoryBarrier), .read(.shcsr, 0x00078001),
                .write(.shcsr, 0x00068001), .write(.mpuControl, 0),
                .instruction(.dataSynchronizationBarrier), .instruction(.instructionSynchronizationBarrier)
            ])
        }
    }

    func testMPURegionEnableAndDisableSelectRegionBeforeChangingOnlyEnableBit() {
        for number in UInt32(0)...15 {
            var cortex = Cortex(registers: CortexTestRegisters(values: [.mpuRegionAttributes: 0x130F1224]))
            cortex.enableMPURegion(number)
            cortex.disableMPURegion(number)
            XCTAssertEqual(cortex.registers.accesses, [
                .write(.mpuRegionNumber, number), .read(.mpuRegionAttributes, 0x130F1224),
                .write(.mpuRegionAttributes, 0x130F1225),
                .write(.mpuRegionNumber, number), .read(.mpuRegionAttributes, 0x130F1225),
                .write(.mpuRegionAttributes, 0x130F1224)
            ])
        }
    }

    func testMPUConfigurationPreservesBothUpstreamDisableWrites() {
        var cortex = Cortex(registers: CortexTestRegisters(values: [.mpuRegionAttributes: 0xFFFFFFFF]))
        cortex.configureMPURegion(MPURegionConfiguration(
            number: 15, baseAddress: 0x24000000, size: 18,
            disableExecute: true, accessPermission: 3, typeExtension: 1,
            shareable: true, cacheable: true, bufferable: true, subregionDisable: 0x12
        ))
        XCTAssertEqual(cortex.registers.accesses, [
            .write(.mpuRegionNumber, 15),
            .read(.mpuRegionAttributes, 0xFFFFFFFF), .write(.mpuRegionAttributes, 0xFFFFFFFE),
            .read(.mpuRegionAttributes, 0xFFFFFFFE), .write(.mpuRegionAttributes, 0xFFFFFFFE),
            .write(.mpuRegionBaseAddress, 0x24000000), .write(.mpuRegionAttributes, 0x130F1225)
        ])
    }

    func testMPUConfigurationAcceptsSmallestAndLargestRegion() {
        var cortex = Cortex(registers: CortexTestRegisters())
        cortex.configureMPURegion(MPURegionConfiguration(number: 0, baseAddress: 0x20000020, size: 4, enable: false))
        XCTAssertEqual(cortex.registers.values[.mpuRegionBaseAddress], 0x20000020)
        XCTAssertEqual(cortex.registers.values[.mpuRegionAttributes], 8)
        cortex.configureMPURegion(MPURegionConfiguration(number: 15, baseAddress: 0, size: 31))
        XCTAssertEqual(cortex.registers.values[.mpuRegionBaseAddress], 0)
        XCTAssertEqual(cortex.registers.values[.mpuRegionAttributes], 63)
    }

    func testClearEventSendsThenConsumesEvent() {
        var cortex = Cortex(registers: CortexTestRegisters())
        cortex.clearEvent()
        XCTAssertEqual(cortex.registers.accesses, [.instruction(.sendEvent), .instruction(.waitForEvent)])
    }
}
