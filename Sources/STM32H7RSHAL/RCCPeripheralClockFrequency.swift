// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_rcc_ex.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension RCC where IO: RCCExtendedRegisterIO {
    // The C parameter is UInt32, unlike the 64-bit configuration selection.
    // TIM and unknown selections return zero; USBREF has no frequency query.
    // Returned frequencies are Hz, matching the C arithmetic (not its KHz comment).
    public mutating func getPeripheralClockFrequency(_ peripheral: UInt32) -> UInt32 {
        var frequency: UInt32 = 0
        var clocksource: UInt32 = 0
        var ethclocksource: UInt32 = 0
        var prescaler: UInt32 = 0
        switch peripheral
        {
        case 0x1:
            clocksource =
                (((registers.read(.ckprotr) & 0x7000) == 0x5000) ? 0x5000 : (((registers.read(.ccipr1) & 0x3))))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getHCLKFreq() })
                break
            case 0x1:
                if (registers.read(.pllcfgr) & (0x40)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL1QFreq() })
                }
                break
            case 0x2:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2RFreq() })
                }
                break
            case 0x3:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x5000:
                frequency = (readRCCFrequency({ $0.getHCLKFreq() }) / 4)
                break
            default:
                break
            }
            break
        case 0x2:
            clocksource = (((registers.read(.ckprotr) & 0x70) == 0x40) ? 0x40 : (((registers.read(.ccipr1) & 0x30))))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getHCLKFreq() })
                break
            case 0x10:
                if ((registers.read(.pllcfgr) & ((0x100) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2SFreq() })
                }
                break
            case 0x20:
                if ((registers.read(.pllcfgr) & ((0x200) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2TFreq() })
                }
                break
            case 0x40:
                frequency = (readRCCFrequency({ $0.getHCLKFreq() }) / 4)
                break
            default:
                break
            }
            break
        case 0x4:
            clocksource = (((registers.read(.ckprotr) & 0x700) == 0x400) ? 0x400 : (((registers.read(.ccipr1) & 0xc0))))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getHCLKFreq() })
                break
            case 0x40:
                if ((registers.read(.pllcfgr) & ((0x100) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2SFreq() })
                }
                break
            case 0x80:
                if ((registers.read(.pllcfgr) & ((0x200) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2TFreq() })
                }
                break
            case 0x400:
                frequency = (readRCCFrequency({ $0.getHCLKFreq() }) / 4)
                break
            default:
                break
            }
            break
        case 0x8:
            clocksource = (((registers.read(.ccipr1) & 0x3000_0000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x1000_0000:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            case 0x2000_0000:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = oscillators.hse
                }
                break
            default:
                break
            }
            break
        case 0x10:
            clocksource = (((registers.read(.ccipr1) & 0x3000000)))
            switch clocksource
            {
            case 0x0:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x1000000:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3RFreq() })
                }
                break
            case 0x2000000:
                frequency = getCLKPFrequency()
                break
            default:
                break
            }
            break
        case 0x20:
            clocksource = (((registers.read(.ccipr1) & 0x700000)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getHCLKFreq() })
                break
            case 0x100000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x200000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3PFreq() })
                }
                break
            case 0x300000:
                frequency = oscillators.external
                break
            case 0x400000:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            case 0x500000:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            default:
                break
            }
            break
        case 0x40:
            clocksource = (((registers.read(.ccipr2) & 0x3000_0000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.bdcr) & 0x2) != 0 {
                    frequency = oscillators.lse
                }
                break
            case 0x1000_0000:
                if (registers.read(.csr) & 0x2) != 0 {
                    frequency = oscillators.lsi
                }
                break
            case 0x2000_0000:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            default:
                break
            }
            break
        case 0x80:
            clocksource = (((registers.read(.ccipr1) & 0x30000)))
            switch clocksource
            {
            case 0x0:
                break
            case 0x10000:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = oscillators.hse
                }
                break
            case 0x20000:
                ethclocksource = (((registers.read(.ccipr1) & 0x40000)))
                switch ethclocksource
                {
                case 0x0:
                    if (registers.read(.cr) & 0x20000) != 0 {
                        frequency = oscillators.hse
                    }
                    break
                case 0x40000:
                    if ((registers.read(.pllcfgr) & ((0x100) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                        frequency = readRCCFrequency({ $0.getPLL3SFreq() })
                    }
                    break
                default:
                    break
                }
                break
            default:
                break
            }
            break
        case 0x100:
            clocksource = (((registers.read(.ccipr1) & 0x40000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = oscillators.hse
                }
                break
            case 0x40000:
                if ((registers.read(.pllcfgr) & ((0x100) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3SFreq() })
                }
                break
            default:
                break
            }
            break
        case 0x200:
            clocksource = (((registers.read(.ccipr2) & 0xc00000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = oscillators.hse
                }
                break
            case 0x400000:
                if (registers.read(.pllcfgr) & (0x40)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL1QFreq() })
                }
                break
            case 0x800000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            default:
                break
            }
            break
        case 0x400:
            clocksource = (((registers.read(.ccipr2) & 0x300)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK1Freq() })
                break
            case 0x100:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3RFreq() })
                }
                break
            case 0x200:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x300:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            default:
                break
            }
            break
        case 0x800:
            clocksource = (((registers.read(.ccipr2) & 0x3000)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK1Freq() })
                break
            case 0x1000:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3RFreq() })
                }
                break
            case 0x2000:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x3000:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            default:
                break
            }
            break
        case 0x1000:
            clocksource = (((registers.read(.ccipr2) & 0x70000)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK1Freq() })
                break
            case 0x10000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x20000:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3RFreq() })
                }
                break
            case 0x30000:
                if (registers.read(.bdcr) & 0x2) != 0 {
                    frequency = oscillators.lse
                }
                break
            case 0x40000:
                if (registers.read(.csr) & 0x2) != 0 {
                    frequency = oscillators.lsi
                }
                break
            case 0x50000:
                frequency = getCLKPFrequency()
                break
            default:
                break
            }
            break
        case 0x2000:
            clocksource = (((registers.read(.ccipr4) & 0x700)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK4Freq() })
                break
            case 0x100:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x200:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3RFreq() })
                }
                break
            case 0x300:
                if (registers.read(.bdcr) & 0x2) != 0 {
                    frequency = oscillators.lse
                }
                break
            case 0x400:
                if (registers.read(.csr) & 0x2) != 0 {
                    frequency = oscillators.lsi
                }
                break
            case 0x500:
                frequency = getCLKPFrequency()
                break
            default:
                break
            }
            break
        case 0x4000:
            clocksource = (((registers.read(.ccipr4) & 0x7000)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK4Freq() })
                break
            case 0x1000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x2000:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3RFreq() })
                }
                break
            case 0x3000:
                if (registers.read(.bdcr) & 0x2) != 0 {
                    frequency = oscillators.lse
                }
                break
            case 0x4000:
                if (registers.read(.csr) & 0x2) != 0 {
                    frequency = oscillators.lsi
                }
                break
            case 0x5000:
                frequency = getCLKPFrequency()
                break
            default:
                break
            }
            break
        case 0x8000:
            clocksource = (((registers.read(.ccipr4) & 0x7)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK4Freq() })
                break
            case 0x1:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2QFreq() })
                }
                break
            case 0x2:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3QFreq() })
                }
                break
            case 0x3:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x4:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            case 0x5:
                if (registers.read(.bdcr) & 0x2) != 0 {
                    frequency = oscillators.lse
                }
                break
            default:
                break
            }
            break
        case 0x10000:
            if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                frequency = readRCCFrequency({ $0.getPLL3RFreq() })
            }
            break
        case 0x20000:
            clocksource = (((registers.read(.ccipr1) & 0x8000000)))
            switch clocksource
            {
            case 0x0:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3RFreq() })
                }
                break
            case 0x8000000:
                frequency = getCLKPFrequency()
                break
            default:
                break
            }
            break
        case 0x40000:
            clocksource =
                (((registers.read(.bdcr) & 0x300) == 0x300)
                    ? (((registers.read(.cfgr) & 0x3f00) << 4) | 0x300) : (registers.read(.bdcr) & 0x300))
            switch clocksource
            {
            case 0x0:
                break
            case 0x100:
                if (registers.read(.bdcr) & 0x2) != 0 {
                    frequency = oscillators.lse
                }
                break
            case 0x200:
                if (registers.read(.csr) & 0x2) != 0 {
                    frequency = oscillators.lsi
                }
                break
            default:
                if (registers.read(.bdcr) & 0x300) == 0x300 {
                    if (registers.read(.cr) & 0x20000) != 0 {
                        prescaler = (registers.read(.cfgr) & 0x3f00) >> 0x8
                        if prescaler > 1 {
                            frequency = oscillators.hse / prescaler
                        }
                    }
                } else {
                }
                break
            }
            break
        case 0x80000:
            clocksource = (((registers.read(.ccipr3) & 0x70000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.pllcfgr) & (0x40)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL1QFreq() })
                }
                break
            case 0x10000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x20000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3PFreq() })
                }
                break
            case 0x40000:
                frequency = getCLKPFrequency()
                break
            case 0x30000:
                frequency = oscillators.external
                break
            default:
                break
            }
            break
        case 0x100000:
            clocksource = (((registers.read(.ccipr3) & 0x700000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.pllcfgr) & (0x40)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL1QFreq() })
                }
                break
            case 0x100000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x200000:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3PFreq() })
                }
                break
            case 0x400000:
                frequency = getCLKPFrequency()
                break
            case 0x500000:
                break
            case 0x300000:
                frequency = oscillators.external
                break
            default:
                break
            }
            break
        case 0x200000:
            clocksource = (((registers.read(.ccipr1) & 0x4)))
            if clocksource == 0x0 {
                if ((registers.read(.pllcfgr) & ((0x100) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2SFreq() })
                }
            } else {
                if ((registers.read(.pllcfgr) & ((0x200) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2TFreq() })
                }
            }
            break
        case 0x400000:
            clocksource = (((registers.read(.ccipr2) & 0x3000000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.pllcfgr) & (0x40)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL1QFreq() })
                }
                break
            case 0x1000000:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2RFreq() })
                }
                break
            case 0x2000000:
                if ((registers.read(.pllcfgr) & ((0x80) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3RFreq() })
                }
                break
            case 0x3000000:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            default:
                break
            }
            break
        case 0x800000:
            clocksource = (((registers.read(.ccipr3) & 0x700)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.pllcfgr) & (0x40)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL1QFreq() })
                }
                break
            case 0x100:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x200:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3PFreq() })
                }
                break
            case 0x400:
                frequency = getCLKPFrequency()
                break
            case 0x300:
                frequency = oscillators.external
                break
            default:
                break
            }
            break
        case 0x1000000:
            clocksource = (((registers.read(.ccipr2) & 0x70)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.pllcfgr) & (0x40)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL1QFreq() })
                }
                break
            case 0x10:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2PFreq() })
                }
                break
            case 0x20:
                if ((registers.read(.pllcfgr) & ((0x20) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3PFreq() })
                }
                break
            case 0x40:
                frequency = getCLKPFrequency()
                break
            case 0x30:
                frequency = oscillators.external
                break
            default:
                break
            }
            break
        case 0x2000000:
            clocksource = (((registers.read(.ccipr3) & 0x70)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK2Freq() })
                break
            case 0x10:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2QFreq() })
                }
                break
            case 0x20:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3QFreq() })
                }
                break
            case 0x30:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x40:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            case 0x50:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = oscillators.hse
                }
                break
            default:
                break
            }
            break
        case 0x4000000:
            clocksource = (((registers.read(.ccipr4) & 0x70)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK4Freq() })
                break
            case 0x10:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2QFreq() })
                }
                break
            case 0x20:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3QFreq() })
                }
                break
            case 0x30:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x40:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            case 0x50:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = oscillators.hse
                }
                break
            default:
                break
            }
            break
        case 0x1000_0000:
            clocksource = (((registers.read(.ccipr3) & 0x7)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK2Freq() })
                break
            case 0x1:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2QFreq() })
                }
                break
            case 0x2:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3QFreq() })
                }
                break
            case 0x3:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x4:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            case 0x5:
                if (registers.read(.bdcr) & 0x2) != 0 {
                    frequency = oscillators.lse
                }
                break
            default:
                break
            }
            break
        case 0x2000_0000:
            clocksource = (((registers.read(.ccipr2) & 0x7)))
            switch clocksource
            {
            case 0x0:
                frequency = readRCCFrequency({ $0.getPCLK1Freq() })
                break
            case 0x1:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x10 - 0x5))) >> (0x10 - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL2QFreq() })
                }
                break
            case 0x2:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3QFreq() })
                }
                break
            case 0x3:
                if (registers.read(.cr) & 0x4) != 0 {
                    if (registers.read(.cr) & 0x20) != 0 {
                        frequency = (oscillators.hsi >> ((((registers.read(.cr) & 0x18))) >> 0x3))
                    } else {
                    }
                }
                break
            case 0x4:
                if (registers.read(.cr) & 0x100) != 0 {
                    frequency = oscillators.csi
                }
                break
            case 0x5:
                if (registers.read(.bdcr) & 0x2) != 0 {
                    frequency = oscillators.lse
                }
                break
            default:
                break
            }
            break
        case 0x4000_0000:
            clocksource = (((registers.read(.ccipr1) & 0x3000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = oscillators.hse
                }
                break
            case 0x1000:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = (oscillators.hse >> 1)
                }
                break
            case 0x2000:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3QFreq() })
                }
                break
            default:
                break
            }
            break
        case 0x8000_0000:
            clocksource = (((registers.read(.ccipr1) & 0xc000)))
            switch clocksource
            {
            case 0x0:
                if (registers.read(.cr) & 0x2000) != 0 {
                    frequency = oscillators.hsi48
                }
                break
            case 0x4000:
                if ((registers.read(.pllcfgr) & ((0x40) << (0x1b - 0x5))) >> (0x1b - 0x5)) != 0 {
                    frequency = readRCCFrequency({ $0.getPLL3QFreq() })
                }
                break
            case 0x8000:
                if (registers.read(.cr) & 0x20000) != 0 {
                    frequency = oscillators.hse
                }
                break
            case 0xc000:
                break
            default:
                break
            }
            break
        default:
            break
        }
        return frequency
    }

    private mutating func getCLKPFrequency() -> UInt32 {
        var frequency: UInt32 = 0
        let source = registers.read(.ccipr1) & 0x3000_0000
        if source == 0 {
            if (registers.read(.cr) & 4) != 0 {
                if (registers.read(.cr) & 0x20) != 0 {
                    frequency = oscillators.hsi >> ((registers.read(.cr) & 0x18) >> 3)
                }
            }
        } else if source == 0x1000_0000 {
            if (registers.read(.cr) & 0x100) != 0 { frequency = oscillators.csi }
        } else if source == 0x2000_0000 {
            if (registers.read(.cr) & 0x20000) != 0 { frequency = oscillators.hse }
        }
        return frequency
    }

    private mutating func readRCCFrequency(_ query: (inout RCCClock<IO>) -> UInt32) -> UInt32 {
        var clock = RCCClock(registers: registers, oscillators: oscillators)
        let frequency = query(&clock)
        registers = clock.registers
        return frequency
    }
}
