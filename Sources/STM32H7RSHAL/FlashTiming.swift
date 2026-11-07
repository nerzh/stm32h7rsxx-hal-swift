// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of FLASH_LATENCY_* and __HAL_FLASH_{SET,GET}_LATENCY in
// stm32h7rsxx_hal_flash.h at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

// Raw values include both LATENCY and the corresponding WRHIGHFREQ setting.
public enum FlashLatency: UInt32, CaseIterable {
    case waitStates0 = 0x00
    case waitStates1 = 0x01
    case waitStates2 = 0x12
    case waitStates3 = 0x13
    case waitStates4 = 0x24
    case waitStates5 = 0x25
    case waitStates6 = 0x36
    case waitStates7 = 0x37
}

public enum FlashTimingRegister: Hashable {
    case acr
}

// Each operation performs exactly one volatile 32-bit register access.
public protocol FlashTimingRegisterIO {
    func read(_ register: FlashTimingRegister) -> UInt32
    func write(_ register: FlashTimingRegister, value: UInt32)
}

public struct FlashTiming<IO: FlashTimingRegisterIO> {
    public let registers: IO

    public init(registers: IO) {
        self.registers = registers
    }

    // Like the C macro, this only writes the value; the caller owns readback checks.
    public func setLatency(_ latency: FlashLatency) {
        let value = (registers.read(.acr) & ~UInt32(0x3F)) | latency.rawValue
        registers.write(.acr, value: value)
    }

    // Preserve unexpected encodings for readback comparisons, as the C macro does.
    public func getLatency() -> UInt32 {
        registers.read(.acr) & 0x3F
    }
}
