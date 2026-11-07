// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// AXIM register layout from CMSIS stm32h7s3xx.h at
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010.
// See LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

import STM32H7RSHAL
import _Volatile

// AXIM is absent from the pinned STM32H7R/S SVDs. Use the CMSIS addresses
// and 32-bit volatile accesses, including the reserved register gaps.
public enum STM32AXIMASIBInstance: UInt, CaseIterable, Sendable {
    case asib1 = 0xBFF4_2000, asib2 = 0xBFF4_3000, asib3 = 0xBFF4_4000
    case asib4 = 0xBFF4_5000, asib5 = 0xBFF4_6000, asib6 = 0xBFF4_7000
    case asib7 = 0xBFF4_8000, asib8 = 0xBFF4_9000, asib9 = 0xBFF4_A000
    case asib10 = 0xBFF4_B000, asib11 = 0xBFF4_C000
}

public struct STM32AXIMASIBRegisters: AXIMASIBRegisterIO {
    public let instance: STM32AXIMASIBInstance
    public init(_ instance: STM32AXIMASIBInstance) { self.instance = instance }

    public func read(_ register: AXIMASIBRegister) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: address(of: register)).load()
    }
    public func write(_ register: AXIMASIBRegister, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: address(of: register)).store(value)
    }
    func address(of register: AXIMASIBRegister) -> UInt {
        let offset: UInt
        switch register {
        case .fnmod2: offset = 0x24
        case .readQoS: offset = 0x100
        case .writeQoS: offset = 0x104
        case .fnmod: offset = 0x108
        }
        return instance.rawValue + offset
    }
}

public enum STM32AXIMAMIBInstance: UInt, CaseIterable, Sendable {
    case amib1 = 0xBFF0_2000, amib2 = 0xBFF0_3000, amib3 = 0xBFF0_4000
    case amib4 = 0xBFF0_5000, amib5 = 0xBFF0_6000, amib6 = 0xBFF0_7000
    case amib7 = 0xBFF0_8000, amib8 = 0xBFF0_9000, amib9 = 0xBFF0_A000
    case amib10 = 0xBFF0_B000
}

public struct STM32AXIMAMIBRegisters: AXIMAMIBRegisterIO {
    public let instance: STM32AXIMAMIBInstance
    public init(_ instance: STM32AXIMAMIBInstance) { self.instance = instance }

    public func read(_ register: AXIMAMIBRegister) -> UInt32 {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: address(of: register)).load()
    }
    public func write(_ register: AXIMAMIBRegister, value: UInt32) {
        VolatileMappedRegister<UInt32>(unsafeBitPattern: address(of: register)).store(value)
    }
    func address(of register: AXIMAMIBRegister) -> UInt {
        let offset: UInt
        switch register {
        case .fnmodBusMatrixIssuing: offset = 0x08
        case .fnmod2: offset = 0x24
        case .fnmodLongBurst: offset = 0x2C
        case .fnmod: offset = 0x108
        }
        return instance.rawValue + offset
    }
}

public extension AXIMASIB where IO == STM32AXIMASIBRegisters {
    init(_ instance: STM32AXIMASIBInstance) { self.init(registers: .init(instance)) }
}
public extension AXIMAMIB where IO == STM32AXIMAMIBRegisters {
    init(_ instance: STM32AXIMAMIBInstance) { self.init(registers: .init(instance)) }
}
