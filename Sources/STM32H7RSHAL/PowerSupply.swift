// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of the supply and voltage-scaling functions in stm32h7rsxx_hal_pwr_ex.c
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum PowerSupplySource: UInt32, CaseIterable {
    case ldo = 0x02
    case externalSource = 0x01
    case directSMPS = 0x04
    case smps1V8SuppliesLDO = 0x16
    case smps1V8SuppliesExternalAndLDO = 0x1E
    case smps1V8SuppliesExternal = 0x1D
}

public enum PowerVoltageScale: UInt32, CaseIterable {
    case scale0 = 1
    case scale1 = 0
}

public enum PowerSupplyRegister: Hashable {
    case csr2, csr4, sr1
}

// Each access is one volatile 32-bit load/store. Shared hardware state is
// external to the handle, so tick interrupts need no exclusive access to it.
public protocol PowerSupplyRegisterIO {
    func read(_ register: PowerSupplyRegister) -> UInt32
    func write(_ register: PowerSupplyRegister, value: UInt32)
}

public struct PowerSupply<IO: PowerSupplyRegisterIO> {
    public let registers: IO

    public init(registers: IO) {
        self.registers = registers
    }

    // The tick source must continue advancing while this function polls.
    // SMPS modes require a device package that provides the SMPS regulator.
    public func configureSupply(_ source: PowerSupplySource, getTick: () -> UInt32) -> HALStatus {
        // Match the upstream lock check, including its separate CSR2 reads.
        if (registers.read(.csr2) & 0x07) != 0x06 {
            if (registers.read(.csr2) & 0x1F) != source.rawValue {
                return .error
            } else {
                return .ok
            }
        }

        let value = (registers.read(.csr2) & ~UInt32(0x1F)) | source.rawValue
        registers.write(.csr2, value: value)

        var start = getTick()
        while (registers.read(.sr1) & (1 << 1)) == 0 {
            if (getTick() &- start) > 1000 {
                return .error
            }
        }

        if source == .smps1V8SuppliesExternalAndLDO || source == .smps1V8SuppliesExternal {
            start = getTick()
            while (registers.read(.csr2) & (1 << 16)) == 0 {
                if (getTick() &- start) > 1000 {
                    return .error
                }
            }
        }
        return .ok
    }

    // Keep the raw result: the reset value (SDEN | LDOEN) is not a supply enum case.
    public func getSupplyConfig() -> UInt32 {
        registers.read(.csr2) & 0x1F
    }

    // Raise voltage before raising the clock; lower the clock before voltage.
    // STOP/STANDBY exit resets run-mode scaling to scale1, as documented by ST.
    public func controlVoltageScaling(_ scale: PowerVoltageScale, getTick: () -> UInt32) -> HALStatus {
        let value = (registers.read(.csr4) & ~UInt32(1)) | scale.rawValue
        registers.write(.csr4, value: value)

        let start = getTick()
        while (registers.read(.csr4) & (1 << 1)) == 0 {
            if (getTick() &- start) > 1000 {
                return .error
            }
        }
        return .ok
    }

    // The active value comes from SR1, not the requested CSR4.VOS setting.
    public func getVoltageRange() -> PowerVoltageScale {
        PowerVoltageScale(rawValue: registers.read(.sr1) & 1)!
    }
}
