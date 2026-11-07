// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Swift port of the clock frequency queries in stm32h7rsxx_hal_rcc.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt for license terms.

public enum RCCClockRegister: Hashable, CaseIterable, Sendable {
    case cr, cfgr, cdcfgr, bmcfgr, apbcfgr, pllckselr, pllcfgr
    case pll1divr1, pll1fracr, pll2divr1, pll2fracr, pll3divr1, pll3fracr
    case pll1divr2, pll2divr2, pll3divr2
}

public protocol RCCClockRegisterIO {
    mutating func read(_ register: RCCClockRegister) -> UInt32
}

public struct RCCOscillatorValues: Equatable, Sendable {
    public var hsi: UInt32
    public var csi: UInt32
    public var hse: UInt32
    public var lse: UInt32
    public var lsi: UInt32
    public var hsi48: UInt32
    public var external: UInt32

    // Defaults from stm32h7rsxx_hal_conf_template.h. Set HSE to the board oscillator.
    public init(hsi: UInt32 = 64_000_000, csi: UInt32 = 4_000_000, hse: UInt32 = 24_000_000,
                lse: UInt32 = 32_768, lsi: UInt32 = 32_000, hsi48: UInt32 = 48_000_000,
                external: UInt32 = 48_000) {
        self.hsi = hsi
        self.csi = csi
        self.hse = hse
        self.lse = lse
        self.lsi = lsi
        self.hsi48 = hsi48
        self.external = external
    }
}

public struct RCCClock<IO: RCCClockRegisterIO> {
    public var registers: IO
    public var oscillators: RCCOscillatorValues

    public init(registers: IO, oscillators: RCCOscillatorValues = RCCOscillatorValues()) {
        self.registers = registers
        self.oscillators = oscillators
    }

    public mutating func getSysClockFreq() -> UInt32 {
        var sysclockfreq: UInt32
        switch registers.read(.cfgr) & 0x38 {
        case 0: // RCC_SYSCLKSOURCE_STATUS_HSI
            if (registers.read(.cr) & 0x20) != 0 {
                sysclockfreq = oscillators.hsi >> ((registers.read(.cr) & 0x18) >> 3)
            } else {
                sysclockfreq = 0
            }
        case 0x08: // RCC_SYSCLKSOURCE_STATUS_CSI
            sysclockfreq = oscillators.csi
        case 0x10: // RCC_SYSCLKSOURCE_STATUS_HSE
            sysclockfreq = oscillators.hse
        case 0x18: // RCC_SYSCLKSOURCE_STATUS_PLLCLK
            let pllsource = registers.read(.pllckselr) & 3
            let pllm = (registers.read(.pllckselr) & 0x3F0) >> 4
            let pllfracen = registers.read(.pllcfgr) & 1
            let fracn1 = Float(pllfracen * ((registers.read(.pll1fracr) & 0xFFF8) >> 3))
            if pllm != 0 {
                let pllvco: Float
                switch pllsource {
                case 0: // RCC_PLLSOURCE_HSI
                    if (registers.read(.cr) & 0x20) != 0 {
                        let hsivalue = oscillators.hsi >> ((registers.read(.cr) & 0x18) >> 3)
                        pllvco = (Float(hsivalue) / Float(pllm)) *
                            (Float(registers.read(.pll1divr1) & 0x1FF) + (fracn1 / Float(0x2000)) + Float(1))
                    } else {
                        pllvco = 0
                    }
                case 2: // RCC_PLLSOURCE_HSE
                    pllvco = (Float(oscillators.hse) / Float(pllm)) *
                        (Float(registers.read(.pll1divr1) & 0x1FF) + (fracn1 / Float(0x2000)) + Float(1))
                default: // RCC_PLLSOURCE_CSI and upstream's default both use CSI.
                    pllvco = (Float(oscillators.csi) / Float(pllm)) *
                        (Float(registers.read(.pll1divr1) & 0x1FF) + (fracn1 / Float(0x2000)) + Float(1))
                }
                let pllp = ((registers.read(.pll1divr1) & 0xFE00) >> 9) + 1
                // Upstream divides in float_t before converting SYSCLK to uint32_t.
                sysclockfreq = UInt32(pllvco / Float(pllp))
            } else {
                sysclockfreq = 0
            }
        default:
            sysclockfreq = oscillators.csi
        }
        let prescaler = registers.read(.cdcfgr) & 0xF
        if prescaler >= 8 {
            sysclockfreq >>= prescaler - 8 + 1
        }
        return sysclockfreq
    }

    public mutating func getHCLKFreq() -> UInt32 {
        // Fixed-size storage preserves the C table without allocating an Array.
        let ahbPrescTable: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (1, 2, 3, 4, 6, 7, 8, 9)
        var clock = getSysClockFreq()
        let prescaler = registers.read(.bmcfgr) & 0xF
        if prescaler >= 8 {
            let shift = withUnsafeBytes(of: ahbPrescTable) { $0[Int(prescaler - 8)] }
            clock >>= shift
        }
        return clock
    }

    public mutating func getPCLK1Freq() -> UInt32 {
        var clock = getHCLKFreq()
        let prescaler = registers.read(.apbcfgr) & 7
        if prescaler >= 4 { clock >>= prescaler - 3 }
        return clock
    }

    public mutating func getPCLK2Freq() -> UInt32 {
        var clock = getHCLKFreq()
        let prescaler = (registers.read(.apbcfgr) & 0x70) >> 4
        if prescaler >= 4 { clock >>= prescaler - 3 }
        return clock
    }

    public mutating func getPCLK4Freq() -> UInt32 {
        var clock = getHCLKFreq()
        let prescaler = (registers.read(.apbcfgr) & 0x700) >> 8
        if prescaler >= 4 { clock >>= prescaler - 3 }
        return clock
    }

    public mutating func getPCLK5Freq() -> UInt32 {
        var clock = getHCLKFreq()
        let prescaler = (registers.read(.apbcfgr) & 0x7000) >> 12
        if prescaler >= 4 { clock >>= prescaler - 3 }
        return clock
    }

    public mutating func getPLL1PFreq() -> UInt32 {
        let pllp = ((registers.read(.pll1divr1) & 0xFE00) >> 9) + 1
        return getVCOOutputFreq(pll: 1) / pllp
    }

    public mutating func getPLL1QFreq() -> UInt32 {
        let pllq = ((registers.read(.pll1divr1) & 0x7F_0000) >> 16) + 1
        return getVCOOutputFreq(pll: 1) / pllq
    }

    public mutating func getPLL1RFreq() -> UInt32 {
        let pllr = ((registers.read(.pll1divr1) & 0x7F00_0000) >> 24) + 1
        return getVCOOutputFreq(pll: 1) / pllr
    }

    public mutating func getPLL1SFreq() -> UInt32 {
        let plls = (registers.read(.pll1divr2) & 7) + 1
        return getVCOOutputFreq(pll: 1) / plls
    }

    public mutating func getPLL2PFreq() -> UInt32 {
        let pllp = ((registers.read(.pll2divr1) & 0xFE00) >> 9) + 1
        return getVCOOutputFreq(pll: 2) / pllp
    }

    public mutating func getPLL2QFreq() -> UInt32 {
        let pllq = ((registers.read(.pll2divr1) & 0x7F_0000) >> 16) + 1
        return getVCOOutputFreq(pll: 2) / pllq
    }

    public mutating func getPLL2RFreq() -> UInt32 {
        let pllr = ((registers.read(.pll2divr1) & 0x7F00_0000) >> 24) + 1
        return getVCOOutputFreq(pll: 2) / pllr
    }

    public mutating func getPLL2SFreq() -> UInt32 {
        let plls = (registers.read(.pll2divr2) & 7) + 1
        return getVCOOutputFreq(pll: 2) / plls
    }

    public mutating func getPLL2TFreq() -> UInt32 {
        let pllt = ((registers.read(.pll2divr2) & 0x700) >> 8) + 1
        return getVCOOutputFreq(pll: 2) / pllt
    }

    public mutating func getPLL3PFreq() -> UInt32 {
        let pllp = ((registers.read(.pll3divr1) & 0xFE00) >> 9) + 1
        return getVCOOutputFreq(pll: 3) / pllp
    }

    public mutating func getPLL3QFreq() -> UInt32 {
        let pllq = ((registers.read(.pll3divr1) & 0x7F_0000) >> 16) + 1
        return getVCOOutputFreq(pll: 3) / pllq
    }

    public mutating func getPLL3RFreq() -> UInt32 {
        let pllr = ((registers.read(.pll3divr1) & 0x7F00_0000) >> 24) + 1
        return getVCOOutputFreq(pll: 3) / pllr
    }

    public mutating func getPLL3SFreq() -> UInt32 {
        let plls = (registers.read(.pll3divr2) & 7) + 1
        return getVCOOutputFreq(pll: 3) / plls
    }

    // The three upstream VCO helpers have identical operations with these register fields.
    private mutating func getVCOOutputFreq(pll: UInt32) -> UInt32 {
        let divr1: RCCClockRegister
        let fracr: RCCClockRegister
        let divmPosition: UInt32
        let fracenPosition: UInt32
        switch pll {
        case 1: (divr1, fracr, divmPosition, fracenPosition) = (.pll1divr1, .pll1fracr, 4, 0)
        case 2: (divr1, fracr, divmPosition, fracenPosition) = (.pll2divr1, .pll2fracr, 12, 11)
        default: (divr1, fracr, divmPosition, fracenPosition) = (.pll3divr1, .pll3fracr, 20, 22)
        }
        let tmpreg1 = registers.read(.pllckselr)
        let tmpreg2 = registers.read(divr1)
        let pllm = (tmpreg1 & (0x3F << divmPosition)) >> divmPosition
        let plln = (tmpreg2 & 0x1FF) + 1
        if pllm == 0 { return 0 }

        let pllfracn: UInt32
        if (registers.read(.pllcfgr) & (1 << fracenPosition)) != 0 {
            pllfracn = (registers.read(fracr) & 0xFFF8) >> 3
        } else {
            pllfracn = 0
        }

        let pllsrc: UInt32
        switch tmpreg1 & 3 {
        case 0: // RCC_PLLSOURCE_HSI
            if (registers.read(.cr) & 0x20) != 0 {
                pllsrc = oscillators.hsi >> ((registers.read(.cr) & 0x18) >> 3)
            } else {
                pllsrc = 0
            }
        case 2: pllsrc = oscillators.hse
        case 1: pllsrc = oscillators.csi
        default: pllsrc = 0
        }
        // float_t is Float on the supported Cortex-M and host test targets.
        // Unlike SYSCLK, PLL output queries truncate VCO before integer division.
        let frequency = (Float(pllsrc) / Float(pllm)) *
            (Float(plln) + (Float(pllfracn) / Float(0x2000)))
        return UInt32(frequency)
    }
}
