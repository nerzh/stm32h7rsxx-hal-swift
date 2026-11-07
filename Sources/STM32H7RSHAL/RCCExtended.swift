// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_rcc_ex.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum RCCExtendedRegister: Hashable, CaseIterable {
    case ccipr1, ccipr2, ccipr3, ccipr4, ckprotr
}

public protocol RCCExtendedRegisterIO: RCCRegisterIO, EXTIRegisterIO {
    mutating func read(_ register: RCCExtendedRegister) -> UInt32
    mutating func write(_ register: RCCExtendedRegister, value: UInt32)
}

public struct RCCPeripheralClockSelection: OptionSet, Sendable {
    public let rawValue: UInt64
    public init(rawValue: UInt64) { self.rawValue = rawValue }
    public static let fmc = Self(rawValue: 0x1)
    public static let xspi1 = Self(rawValue: 0x2)
    public static let xspi2 = Self(rawValue: 0x4)
    public static let ckper = Self(rawValue: 0x8)
    public static let adc = Self(rawValue: 0x10)
    public static let adf1 = Self(rawValue: 0x20)
    public static let cec = Self(rawValue: 0x40)
    public static let eth1Ref = Self(rawValue: 0x80)
    public static let eth1Phy = Self(rawValue: 0x100)
    public static let fdcan = Self(rawValue: 0x200)
    public static let i2c23 = Self(rawValue: 0x400)
    public static let i2c1I3c1 = Self(rawValue: 0x800)
    public static let lptim1 = Self(rawValue: 0x1000)
    public static let lptim23 = Self(rawValue: 0x2000)
    public static let lptim45 = Self(rawValue: 0x4000)
    public static let lpuart1 = Self(rawValue: 0x8000)
    public static let ltdc = Self(rawValue: 0x10000)
    public static let pssi = Self(rawValue: 0x20000)
    public static let rtc = Self(rawValue: 0x40000)
    public static let sai1 = Self(rawValue: 0x80000)
    public static let sai2 = Self(rawValue: 0x100000)
    public static let sdmmc12 = Self(rawValue: 0x200000)
    public static let spdifrx = Self(rawValue: 0x400000)
    public static let spi1 = Self(rawValue: 0x800000)
    public static let spi23 = Self(rawValue: 0x1000000)
    public static let spi45 = Self(rawValue: 0x2000000)
    public static let spi6 = Self(rawValue: 0x4000000)
    public static let tim = Self(rawValue: 0x8000000)
    public static let usart1 = Self(rawValue: 0x1000_0000)
    public static let usart234578 = Self(rawValue: 0x2000_0000)
    public static let usbPhyc = Self(rawValue: 0x4000_0000)
    public static let usbOtgFs = Self(rawValue: 0x8000_0000)
    public static let usbRef = Self(rawValue: 0x1_0000_0000)
}

// Field values retain the C register encodings; selection is 64-bit because
// USBREF occupies bit 32. Only selected fields are validated and configured.
public struct RCCPeripheralClockConfiguration: Equatable, Sendable {
    public var selection: RCCPeripheralClockSelection
    public var fmcClockSelection: UInt32
    public var xspi1ClockSelection: UInt32
    public var xspi2ClockSelection: UInt32
    public var ckperClockSelection: UInt32
    public var adcClockSelection: UInt32
    public var adf1ClockSelection: UInt32
    public var cecClockSelection: UInt32
    public var eth1RefClockSelection: UInt32
    public var eth1PhyClockSelection: UInt32
    public var fdcanClockSelection: UInt32
    public var i2c1I3c1ClockSelection: UInt32
    public var i2c23ClockSelection: UInt32
    public var lptim1ClockSelection: UInt32
    public var lptim23ClockSelection: UInt32
    public var lptim45ClockSelection: UInt32
    public var lpuart1ClockSelection: UInt32
    public var ltdcClockSelection: UInt32
    public var pssiClockSelection: UInt32
    public var sai1ClockSelection: UInt32
    public var sai2ClockSelection: UInt32
    public var sdmmc12ClockSelection: UInt32
    public var spi1ClockSelection: UInt32
    public var spi23ClockSelection: UInt32
    public var spi45ClockSelection: UInt32
    public var spi6ClockSelection: UInt32
    public var spdifrxClockSelection: UInt32
    public var usart1ClockSelection: UInt32
    public var usart234578ClockSelection: UInt32
    public var usbPhycClockSelection: UInt32
    public var usbRefClockSelection: UInt32
    public var usbOtgFsClockSelection: UInt32
    public var rtcClockSelection: UInt32
    public var timPresSelection: UInt32

    public init(
        selection: RCCPeripheralClockSelection = [],
        fmcClockSelection: UInt32 = 0,
        xspi1ClockSelection: UInt32 = 0,
        xspi2ClockSelection: UInt32 = 0,
        ckperClockSelection: UInt32 = 0,
        adcClockSelection: UInt32 = 0,
        adf1ClockSelection: UInt32 = 0,
        cecClockSelection: UInt32 = 0,
        eth1RefClockSelection: UInt32 = 0,
        eth1PhyClockSelection: UInt32 = 0,
        fdcanClockSelection: UInt32 = 0,
        i2c1I3c1ClockSelection: UInt32 = 0,
        i2c23ClockSelection: UInt32 = 0,
        lptim1ClockSelection: UInt32 = 0,
        lptim23ClockSelection: UInt32 = 0,
        lptim45ClockSelection: UInt32 = 0,
        lpuart1ClockSelection: UInt32 = 0,
        ltdcClockSelection: UInt32 = 0,
        pssiClockSelection: UInt32 = 0,
        sai1ClockSelection: UInt32 = 0,
        sai2ClockSelection: UInt32 = 0,
        sdmmc12ClockSelection: UInt32 = 0,
        spi1ClockSelection: UInt32 = 0,
        spi23ClockSelection: UInt32 = 0,
        spi45ClockSelection: UInt32 = 0,
        spi6ClockSelection: UInt32 = 0,
        spdifrxClockSelection: UInt32 = 0,
        usart1ClockSelection: UInt32 = 0,
        usart234578ClockSelection: UInt32 = 0,
        usbPhycClockSelection: UInt32 = 0,
        usbRefClockSelection: UInt32 = 0,
        usbOtgFsClockSelection: UInt32 = 0,
        rtcClockSelection: UInt32 = 0,
        timPresSelection: UInt32 = 0
    ) {
        self.selection = selection
        self.fmcClockSelection = fmcClockSelection
        self.xspi1ClockSelection = xspi1ClockSelection
        self.xspi2ClockSelection = xspi2ClockSelection
        self.ckperClockSelection = ckperClockSelection
        self.adcClockSelection = adcClockSelection
        self.adf1ClockSelection = adf1ClockSelection
        self.cecClockSelection = cecClockSelection
        self.eth1RefClockSelection = eth1RefClockSelection
        self.eth1PhyClockSelection = eth1PhyClockSelection
        self.fdcanClockSelection = fdcanClockSelection
        self.i2c1I3c1ClockSelection = i2c1I3c1ClockSelection
        self.i2c23ClockSelection = i2c23ClockSelection
        self.lptim1ClockSelection = lptim1ClockSelection
        self.lptim23ClockSelection = lptim23ClockSelection
        self.lptim45ClockSelection = lptim45ClockSelection
        self.lpuart1ClockSelection = lpuart1ClockSelection
        self.ltdcClockSelection = ltdcClockSelection
        self.pssiClockSelection = pssiClockSelection
        self.sai1ClockSelection = sai1ClockSelection
        self.sai2ClockSelection = sai2ClockSelection
        self.sdmmc12ClockSelection = sdmmc12ClockSelection
        self.spi1ClockSelection = spi1ClockSelection
        self.spi23ClockSelection = spi23ClockSelection
        self.spi45ClockSelection = spi45ClockSelection
        self.spi6ClockSelection = spi6ClockSelection
        self.spdifrxClockSelection = spdifrxClockSelection
        self.usart1ClockSelection = usart1ClockSelection
        self.usart234578ClockSelection = usart234578ClockSelection
        self.usbPhycClockSelection = usbPhycClockSelection
        self.usbRefClockSelection = usbRefClockSelection
        self.usbOtgFsClockSelection = usbOtgFsClockSelection
        self.rtcClockSelection = rtcClockSelection
        self.timPresSelection = timPresSelection
    }
}

extension RCC where IO: RCCExtendedRegisterIO {
    // Preserve the upstream sticky intermediate error: later PLL enables and
    // unconditional selectors still run after an earlier failure. A timeout is
    // mapped to HAL_ERROR at the end. RTC source changes may reset the backup
    // domain, including RTC registers; no additional rollback is performed.
    @discardableResult
    public mutating func configurePeripheralClocks(_ configuration: RCCPeripheralClockConfiguration) -> HALStatus {
        var tmpreg: UInt32 = 0
        var tickstart: UInt32 = 0
        var ret: HALStatus = .ok
        var status: HALStatus = .ok
        precondition(
            ((((configuration.selection.rawValue) & 0x1) == 0x1) || (((configuration.selection.rawValue) & 0x2) == 0x2)
                || (((configuration.selection.rawValue) & 0x4) == 0x4)
                || (((configuration.selection.rawValue) & 0x8) == 0x8)
                || (((configuration.selection.rawValue) & 0x10) == 0x10)
                || (((configuration.selection.rawValue) & 0x20) == 0x20)
                || (((configuration.selection.rawValue) & 0x40) == 0x40)
                || (((configuration.selection.rawValue) & 0x80) == 0x80)
                || (((configuration.selection.rawValue) & 0x100) == 0x100)
                || (((configuration.selection.rawValue) & 0x200) == 0x200)
                || (((configuration.selection.rawValue) & 0x800) == 0x800)
                || (((configuration.selection.rawValue) & 0x400) == 0x400)
                || (((configuration.selection.rawValue) & 0x1000) == 0x1000)
                || (((configuration.selection.rawValue) & 0x2000) == 0x2000)
                || (((configuration.selection.rawValue) & 0x4000) == 0x4000)
                || (((configuration.selection.rawValue) & 0x8000) == 0x8000)
                || (((configuration.selection.rawValue) & 0x10000) == 0x10000)
                || (((configuration.selection.rawValue) & 0x20000) == 0x20000)
                || (((configuration.selection.rawValue) & 0x40000) == 0x40000)
                || (((configuration.selection.rawValue) & 0x80000) == 0x80000)
                || (((configuration.selection.rawValue) & 0x100000) == 0x100000)
                || (((configuration.selection.rawValue) & 0x200000) == 0x200000)
                || (((configuration.selection.rawValue) & 0x400000) == 0x400000)
                || (((configuration.selection.rawValue) & 0x800000) == 0x800000)
                || (((configuration.selection.rawValue) & 0x1000000) == 0x1000000)
                || (((configuration.selection.rawValue) & 0x2000000) == 0x2000000)
                || (((configuration.selection.rawValue) & 0x4000000) == 0x4000000)
                || (((configuration.selection.rawValue) & 0x8000000) == 0x8000000)
                || (((configuration.selection.rawValue) & 0x1000_0000) == 0x1000_0000)
                || (((configuration.selection.rawValue) & 0x2000_0000) == 0x2000_0000)
                || (((configuration.selection.rawValue) & 0x4000_0000) == 0x4000_0000)
                || (((configuration.selection.rawValue) & 0x8000_0000) == 0x8000_0000)
                || (((configuration.selection.rawValue) & 0x1_0000_0000) == 0x1_0000_0000)))
        if (configuration.selection.rawValue & 0x40000) == 0x40000 {
            precondition(
                (((configuration.rtcClockSelection) == 0x100) || ((configuration.rtcClockSelection) == 0x200)
                    || ((configuration.rtcClockSelection) == 0x2300) || ((configuration.rtcClockSelection) == 0x3300)
                    || ((configuration.rtcClockSelection) == 0x4300) || ((configuration.rtcClockSelection) == 0x5300)
                    || ((configuration.rtcClockSelection) == 0x6300) || ((configuration.rtcClockSelection) == 0x7300)
                    || ((configuration.rtcClockSelection) == 0x8300) || ((configuration.rtcClockSelection) == 0x9300)
                    || ((configuration.rtcClockSelection) == 0xa300) || ((configuration.rtcClockSelection) == 0xb300)
                    || ((configuration.rtcClockSelection) == 0xc300) || ((configuration.rtcClockSelection) == 0xd300)
                    || ((configuration.rtcClockSelection) == 0xe300) || ((configuration.rtcClockSelection) == 0xf300)
                    || ((configuration.rtcClockSelection) == 0x10300) || ((configuration.rtcClockSelection) == 0x11300)
                    || ((configuration.rtcClockSelection) == 0x12300) || ((configuration.rtcClockSelection) == 0x13300)
                    || ((configuration.rtcClockSelection) == 0x14300) || ((configuration.rtcClockSelection) == 0x15300)
                    || ((configuration.rtcClockSelection) == 0x16300) || ((configuration.rtcClockSelection) == 0x17300)
                    || ((configuration.rtcClockSelection) == 0x18300) || ((configuration.rtcClockSelection) == 0x19300)
                    || ((configuration.rtcClockSelection) == 0x1a300) || ((configuration.rtcClockSelection) == 0x1b300)
                    || ((configuration.rtcClockSelection) == 0x1c300) || ((configuration.rtcClockSelection) == 0x1d300)
                    || ((configuration.rtcClockSelection) == 0x1e300) || ((configuration.rtcClockSelection) == 0x1f300)
                    || ((configuration.rtcClockSelection) == 0x20300) || ((configuration.rtcClockSelection) == 0x21300)
                    || ((configuration.rtcClockSelection) == 0x22300) || ((configuration.rtcClockSelection) == 0x23300)
                    || ((configuration.rtcClockSelection) == 0x24300) || ((configuration.rtcClockSelection) == 0x25300)
                    || ((configuration.rtcClockSelection) == 0x26300) || ((configuration.rtcClockSelection) == 0x27300)
                    || ((configuration.rtcClockSelection) == 0x28300) || ((configuration.rtcClockSelection) == 0x29300)
                    || ((configuration.rtcClockSelection) == 0x2a300) || ((configuration.rtcClockSelection) == 0x2b300)
                    || ((configuration.rtcClockSelection) == 0x2c300) || ((configuration.rtcClockSelection) == 0x2d300)
                    || ((configuration.rtcClockSelection) == 0x2e300) || ((configuration.rtcClockSelection) == 0x2f300)
                    || ((configuration.rtcClockSelection) == 0x30300) || ((configuration.rtcClockSelection) == 0x31300)
                    || ((configuration.rtcClockSelection) == 0x32300) || ((configuration.rtcClockSelection) == 0x33300)
                    || ((configuration.rtcClockSelection) == 0x34300) || ((configuration.rtcClockSelection) == 0x35300)
                    || ((configuration.rtcClockSelection) == 0x36300) || ((configuration.rtcClockSelection) == 0x37300)
                    || ((configuration.rtcClockSelection) == 0x38300) || ((configuration.rtcClockSelection) == 0x39300)
                    || ((configuration.rtcClockSelection) == 0x3a300) || ((configuration.rtcClockSelection) == 0x3b300)
                    || ((configuration.rtcClockSelection) == 0x3c300) || ((configuration.rtcClockSelection) == 0x3d300)
                    || ((configuration.rtcClockSelection) == 0x3e300) || ((configuration.rtcClockSelection) == 0x3f300)
                    || ((configuration.rtcClockSelection) == 0x0)))
            tmpreg = (registers.read(.bdcr) & 0x300)
            if (tmpreg != 0x0) && (tmpreg != (configuration.rtcClockSelection & 0x300)) {
                modifyExtended(.powerControl1, clear: 0, set: 0x100)
                if (registers.read(.powerControl1) & 0x100) == 0 {
                    ret = .error
                } else {
                    tmpreg = (registers.read(.bdcr) & ~(0x300))
                    modifyExtended(.bdcr, clear: 0, set: 0x10000)
                    modifyExtended(.bdcr, clear: 0x10000, set: 0)
                    registers.write(.bdcr, value: tmpreg)
                }
            }
            if ret == .ok {
                if configuration.rtcClockSelection == 0x100 {
                    tickstart = system.getTick()
                    while (registers.read(.bdcr) & 0x2) == 0 {
                        if (system.getTick() &- tickstart) > timeouts.lseStartup {
                            ret = .timeout
                            break
                        }
                    }
                }
                if ret == .ok {
                    if (configuration.rtcClockSelection & (0x3F << 12)) != 0 {
                        modifyExtended(
                            .cfgr, clear: 0x3F00, set: (configuration.rtcClockSelection & ~UInt32(0x300)) >> 4)
                    } else {
                        modifyExtended(.cfgr, clear: 0x3F00, set: 0)
                    }
                    modifyExtended(.bdcr, clear: 0, set: configuration.rtcClockSelection & 0x300)
                    modifyExtended(.bdcr, clear: 0, set: 0x8000)
                } else {
                    status = ret
                }
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x1) == 0x1 {
            precondition(
                (((configuration.fmcClockSelection) == 0x0) || ((configuration.fmcClockSelection) == 0x1)
                    || ((configuration.fmcClockSelection) == 0x2) || ((configuration.fmcClockSelection) == 0x3)))
            switch configuration.fmcClockSelection
            {
            case 0x0:
                break
            case 0x1:
                modifyExtended(.pllcfgr, clear: 0, set: (0x40))
                break
            case 0x2:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x10 - 0x5)))
                break
            case 0x3:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0x3, set: (configuration.fmcClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x2) == 0x2 {
            precondition(
                (((configuration.xspi1ClockSelection) == 0x0) || ((configuration.xspi1ClockSelection) == 0x10)
                    || ((configuration.xspi1ClockSelection) == 0x20)))
            switch configuration.xspi1ClockSelection
            {
            case 0x0:
                break
            case 0x10:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x100) << (0x10 - 0x5)))
                break
            case 0x20:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x200) << (0x10 - 0x5)))
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0x30, set: (configuration.xspi1ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x4) == 0x4 {
            precondition(
                (((configuration.xspi2ClockSelection) == 0x0) || ((configuration.xspi2ClockSelection) == 0x40)
                    || ((configuration.xspi2ClockSelection) == 0x80)))
            switch configuration.xspi2ClockSelection
            {
            case 0x0:
                break
            case 0x40:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x100) << (0x10 - 0x5)))
                break
            case 0x80:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x200) << (0x10 - 0x5)))
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0xc0, set: (configuration.xspi2ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x8) == 0x8 {
            precondition(
                (((configuration.ckperClockSelection) == 0x0) || ((configuration.ckperClockSelection) == 0x1000_0000)
                    || ((configuration.ckperClockSelection) == 0x2000_0000)))
            modifyExtended(.ccipr1, clear: 0x3000_0000, set: (configuration.ckperClockSelection))
        }
        if (configuration.selection.rawValue & 0x200000) == 0x200000 {
            precondition(
                (((configuration.sdmmc12ClockSelection) == 0x0) || ((configuration.sdmmc12ClockSelection) == 0x4)))
            switch configuration.sdmmc12ClockSelection
            {
            case 0x0:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x100) << (0x10 - 0x5)))
                break
            case 0x4:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x200) << (0x10 - 0x5)))
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0x4, set: (configuration.sdmmc12ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x10) == 0x10 {
            precondition(
                (((configuration.adcClockSelection) == 0x0) || ((configuration.adcClockSelection) == 0x1000000)
                    || ((configuration.adcClockSelection) == 0x2000000)))
            switch configuration.adcClockSelection
            {
            case 0x0:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x1000000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
                break
            case 0x2000000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0x3000000, set: (configuration.adcClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x20) == 0x20 {
            precondition(
                (((configuration.adf1ClockSelection) == 0x0) || ((configuration.adf1ClockSelection) == 0x100000)
                    || ((configuration.adf1ClockSelection) == 0x200000)
                    || ((configuration.adf1ClockSelection) == 0x300000)
                    || ((configuration.adf1ClockSelection) == 0x400000)
                    || ((configuration.adf1ClockSelection) == 0x500000)))
            switch configuration.adf1ClockSelection
            {
            case 0x100000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x200000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x1b - 0x5)))
                break
            case 0x0, 0x300000, 0x400000, 0x500000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0x700000, set: (configuration.adf1ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x40) == 0x40 {
            precondition(
                (((configuration.cecClockSelection) == 0x0) || ((configuration.cecClockSelection) == 0x1000_0000)
                    || ((configuration.cecClockSelection) == 0x2000_0000)))
            modifyExtended(.ccipr2, clear: 0x3000_0000, set: (configuration.cecClockSelection))
        }
        if (configuration.selection.rawValue & 0x80) == 0x80 {
            precondition(
                (((configuration.eth1RefClockSelection) == 0x0) || ((configuration.eth1RefClockSelection) == 0x10000)
                    || ((configuration.eth1RefClockSelection) == 0x20000)))
            modifyExtended(.ccipr1, clear: 0x30000, set: (configuration.eth1RefClockSelection))
        }
        if (configuration.selection.rawValue & 0x100) == 0x100 {
            precondition(
                (((configuration.eth1PhyClockSelection) == 0x0) || ((configuration.eth1PhyClockSelection) == 0x40000)))
            switch configuration.eth1PhyClockSelection
            {
            case 0x0:
                break
            case 0x40000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x100) << (0x1b - 0x5)))
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0x40000, set: (configuration.eth1PhyClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x200) == 0x200 {
            precondition(
                (((configuration.fdcanClockSelection) == 0x0) || ((configuration.fdcanClockSelection) == 0x400000)
                    || ((configuration.fdcanClockSelection) == 0x800000)))
            switch configuration.fdcanClockSelection
            {
            case 0x400000:
                modifyExtended(.pllcfgr, clear: 0, set: (0x40))
                break
            case 0x800000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x0:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr2, clear: 0xc00000, set: (configuration.fdcanClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x800) == 0x800 {
            precondition(
                (((configuration.i2c1I3c1ClockSelection) == 0x0) || ((configuration.i2c1I3c1ClockSelection) == 0x1000)
                    || ((configuration.i2c1I3c1ClockSelection) == 0x2000)
                    || ((configuration.i2c1I3c1ClockSelection) == 0x3000)))
            switch configuration.i2c1I3c1ClockSelection
            {
            case 0x1000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
                break
            case 0x0, 0x2000, 0x3000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr2, clear: 0x3000, set: (configuration.i2c1I3c1ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x400) == 0x400 {
            precondition(
                (((configuration.i2c23ClockSelection) == 0x0) || ((configuration.i2c23ClockSelection) == 0x100)
                    || ((configuration.i2c23ClockSelection) == 0x200) || ((configuration.i2c23ClockSelection) == 0x300))
            )
            switch configuration.i2c23ClockSelection
            {
            case 0x100:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
                break
            case 0x0, 0x200, 0x300:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr2, clear: 0x300, set: (configuration.i2c23ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x1000) == 0x1000 {
            precondition(
                (((configuration.lptim1ClockSelection) == 0x0) || ((configuration.lptim1ClockSelection) == 0x10000)
                    || ((configuration.lptim1ClockSelection) == 0x20000)
                    || ((configuration.lptim1ClockSelection) == 0x30000)
                    || ((configuration.lptim1ClockSelection) == 0x40000)
                    || ((configuration.lptim1ClockSelection) == 0x50000)))
            switch configuration.lptim1ClockSelection
            {
            case 0x0:
                break
            case 0x10000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x20000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
                break
            case 0x30000:
                break
            case 0x40000:
                break
            case 0x50000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr2, clear: 0x70000, set: (configuration.lptim1ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x2000) == 0x2000 {
            switch configuration.lptim23ClockSelection
            {
            case 0x0:
                break
            case 0x100:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x200:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
                break
            case 0x300:
                break
            case 0x400:
                break
            case 0x500:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr4, clear: 0x700, set: (configuration.lptim23ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x4000) == 0x4000 {
            switch configuration.lptim45ClockSelection
            {
            case 0x0:
                break
            case 0x1000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x2000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
                break
            case 0x3000:
                break
            case 0x4000:
                break
            case 0x5000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr4, clear: 0x7000, set: (configuration.lptim45ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x8000) == 0x8000 {
            precondition(
                (((configuration.lpuart1ClockSelection) == 0x0) || ((configuration.lpuart1ClockSelection) == 0x1)
                    || ((configuration.lpuart1ClockSelection) == 0x2) || ((configuration.lpuart1ClockSelection) == 0x3)
                    || ((configuration.lpuart1ClockSelection) == 0x4) || ((configuration.lpuart1ClockSelection) == 0x5))
            )
            switch configuration.lpuart1ClockSelection
            {
            case 0x0:
                break
            case 0x1:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x10 - 0x5)))
                break
            case 0x2:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x1b - 0x5)))
                break
            case 0x3:
                break
            case 0x4:
                break
            case 0x5:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr4, clear: 0x7, set: (configuration.lpuart1ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x10000) == 0x10000 {
            modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
        }
        if (configuration.selection.rawValue & 0x20000) == 0x20000 {
            precondition(
                (((configuration.pssiClockSelection) == 0x0) || ((configuration.pssiClockSelection) == 0x8000000)))
            switch configuration.pssiClockSelection
            {
            case 0x0:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
                break
            case 0x8000000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0x8000000, set: (configuration.pssiClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x80000) == 0x80000 {
            precondition(
                (((configuration.sai1ClockSelection) == 0x0) || ((configuration.sai1ClockSelection) == 0x10000)
                    || ((configuration.sai1ClockSelection) == 0x20000)
                    || ((configuration.sai1ClockSelection) == 0x40000)
                    || ((configuration.sai1ClockSelection) == 0x30000)))
            switch configuration.sai1ClockSelection
            {
            case 0x0:
                modifyExtended(.pllcfgr, clear: 0, set: (0x40))
                break
            case 0x10000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x20000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x1b - 0x5)))
                break
            case 0x30000:
                break
            case 0x40000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr3, clear: 0x70000, set: (configuration.sai1ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x100000) == 0x100000 {
            precondition(
                (((configuration.sai2ClockSelection) == 0x0) || ((configuration.sai2ClockSelection) == 0x100000)
                    || ((configuration.sai2ClockSelection) == 0x200000)
                    || ((configuration.sai2ClockSelection) == 0x400000)
                    || ((configuration.sai2ClockSelection) == 0x300000)
                    || ((configuration.sai2ClockSelection) == 0x500000)))
            switch configuration.sai2ClockSelection
            {
            case 0x0:
                modifyExtended(.pllcfgr, clear: 0, set: (0x40))
                break
            case 0x100000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x200000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x1b - 0x5)))
                break
            case 0x300000:
                break
            case 0x400000:
                break
            case 0x500000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr3, clear: 0x700000, set: (configuration.sai2ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x400000) == 0x400000 {
            precondition(
                (((configuration.spdifrxClockSelection) == 0x0) || ((configuration.spdifrxClockSelection) == 0x1000000)
                    || ((configuration.spdifrxClockSelection) == 0x2000000)
                    || ((configuration.spdifrxClockSelection) == 0x3000000)))
            switch configuration.spdifrxClockSelection
            {
            case 0x0:
                modifyExtended(.pllcfgr, clear: 0, set: (0x40))
                break
            case 0x1000000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x10 - 0x5)))
                break
            case 0x2000000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x80) << (0x1b - 0x5)))
                break
            case 0x3000000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr2, clear: 0x3000000, set: (configuration.spdifrxClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x800000) == 0x800000 {
            precondition(
                (((configuration.spi1ClockSelection) == 0x0) || ((configuration.spi1ClockSelection) == 0x100)
                    || ((configuration.spi1ClockSelection) == 0x200) || ((configuration.spi1ClockSelection) == 0x300)
                    || ((configuration.spi1ClockSelection) == 0x400)))
            switch configuration.spi1ClockSelection
            {
            case 0x0:
                modifyExtended(.pllcfgr, clear: 0, set: (0x40))
                break
            case 0x100:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x200:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x1b - 0x5)))
                break
            case 0x300:
                break
            case 0x400:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr3, clear: 0x700, set: (configuration.spi1ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x1000000) == 0x1000000 {
            precondition(
                (((configuration.spi23ClockSelection) == 0x0) || ((configuration.spi23ClockSelection) == 0x10)
                    || ((configuration.spi23ClockSelection) == 0x20) || ((configuration.spi23ClockSelection) == 0x30)
                    || ((configuration.spi23ClockSelection) == 0x40)))
            switch configuration.spi23ClockSelection
            {
            case 0x0:
                modifyExtended(.pllcfgr, clear: 0, set: (0x40))
                break
            case 0x10:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x10 - 0x5)))
                break
            case 0x20:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x20) << (0x1b - 0x5)))
                break
            case 0x30:
                break
            case 0x40:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr2, clear: 0x70, set: (configuration.spi23ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x2000000) == 0x2000000 {
            precondition(
                (((configuration.spi45ClockSelection) == 0x0) || ((configuration.spi45ClockSelection) == 0x10)
                    || ((configuration.spi45ClockSelection) == 0x20) || ((configuration.spi45ClockSelection) == 0x30)
                    || ((configuration.spi45ClockSelection) == 0x40) || ((configuration.spi45ClockSelection) == 0x50)))
            switch configuration.spi45ClockSelection
            {
            case 0x0:
                break
            case 0x10:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x10 - 0x5)))
                break
            case 0x20:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x1b - 0x5)))
                break
            case 0x30:
                break
            case 0x40:
                break
            case 0x50:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr3, clear: 0x70, set: (configuration.spi45ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x4000000) == 0x4000000 {
            precondition(
                (((configuration.spi6ClockSelection) == 0x0) || ((configuration.spi6ClockSelection) == 0x10)
                    || ((configuration.spi6ClockSelection) == 0x20) || ((configuration.spi6ClockSelection) == 0x30)
                    || ((configuration.spi6ClockSelection) == 0x40) || ((configuration.spi6ClockSelection) == 0x50)))
            switch configuration.spi6ClockSelection
            {
            case 0x0:
                break
            case 0x10:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x10 - 0x5)))
                break
            case 0x20:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x1b - 0x5)))
                break
            case 0x30:
                break
            case 0x40:
                break
            case 0x50:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr4, clear: 0x70, set: (configuration.spi6ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x1000_0000) == 0x1000_0000 {
            precondition(
                (((configuration.usart1ClockSelection) == 0x0) || ((configuration.usart1ClockSelection) == 0x1)
                    || ((configuration.usart1ClockSelection) == 0x2) || ((configuration.usart1ClockSelection) == 0x3)
                    || ((configuration.usart1ClockSelection) == 0x4) || ((configuration.usart1ClockSelection) == 0x5)))
            switch configuration.usart1ClockSelection
            {
            case 0x0:
                break
            case 0x1:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x10 - 0x5)))
                break
            case 0x2:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x1b - 0x5)))
                break
            case 0x3:
                break
            case 0x4:
                break
            case 0x5:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr3, clear: 0x7, set: (configuration.usart1ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x2000_0000) == 0x2000_0000 {
            precondition(
                (((configuration.usart234578ClockSelection) == 0x0)
                    || ((configuration.usart234578ClockSelection) == 0x1)
                    || ((configuration.usart234578ClockSelection) == 0x2)
                    || ((configuration.usart234578ClockSelection) == 0x3)
                    || ((configuration.usart234578ClockSelection) == 0x5)
                    || ((configuration.usart234578ClockSelection) == 0x4)))
            switch configuration.usart234578ClockSelection
            {
            case 0x0:
                break
            case 0x1:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x10 - 0x5)))
                break
            case 0x2:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x1b - 0x5)))
                break
            case 0x3:
                break
            case 0x4:
                break
            case 0x5:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr2, clear: 0x7, set: (configuration.usart234578ClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x4000_0000) == 0x4000_0000 {
            precondition(
                (((configuration.usbPhycClockSelection) == 0x0) || ((configuration.usbPhycClockSelection) == 0x1000)
                    || ((configuration.usbPhycClockSelection) == 0x2000)))
            switch configuration.usbPhycClockSelection
            {
            case 0x2000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x1b - 0x5)))
                break
            case 0x0, 0x1000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0x3000, set: (configuration.usbPhycClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x8000_0000) == 0x8000_0000 {
            precondition(
                (((configuration.usbOtgFsClockSelection) == 0x0) || ((configuration.usbOtgFsClockSelection) == 0x4000)
                    || ((configuration.usbOtgFsClockSelection) == 0x8000)
                    || ((configuration.usbOtgFsClockSelection) == 0xc000)))
            switch configuration.usbOtgFsClockSelection
            {
            case 0x4000:
                modifyExtended(.pllcfgr, clear: 0, set: ((0x40) << (0x1b - 0x5)))
                break
            case 0x0, 0x8000, 0xc000:
                break
            default:
                ret = .error
                break
            }
            if ret == .ok {
                modifyExtended(.ccipr1, clear: 0xc000, set: (configuration.usbOtgFsClockSelection))
            } else {
                status = ret
            }
        }
        if (configuration.selection.rawValue & 0x8000000) == 0x8000000 {
            precondition((((configuration.timPresSelection) == 0x0) || ((configuration.timPresSelection) == 0x8000)))
            modifyExtended(.cfgr, clear: 0x8000, set: (configuration.timPresSelection))
        }
        if (configuration.selection.rawValue & 0x1_0000_0000) == 0x1_0000_0000 {
            precondition(
                (((configuration.usbRefClockSelection) == 0x300) || ((configuration.usbRefClockSelection) == 0x800)
                    || ((configuration.usbRefClockSelection) == 0x900)
                    || ((configuration.usbRefClockSelection) == 0xa00)
                    || ((configuration.usbRefClockSelection) == 0xe00)
                    || ((configuration.usbRefClockSelection) == 0xb00)))
            modifyExtended(.ccipr1, clear: 0xf00, set: (configuration.usbRefClockSelection))
        }
        if status == .ok {
            return .ok
        }
        return .error
    }

    public mutating func getPeripheralClockConfiguration() -> RCCPeripheralClockConfiguration {
        var configuration = RCCPeripheralClockConfiguration()
        configuration.selection = RCCPeripheralClockSelection(rawValue: 0x1_FFFF_FFFF)
        configuration.adcClockSelection = (((registers.read(.ccipr1) & 0x3000000)))
        configuration.adf1ClockSelection = (((registers.read(.ccipr1) & 0x700000)))
        configuration.cecClockSelection = (((registers.read(.ccipr2) & 0x3000_0000)))
        configuration.ckperClockSelection = (((registers.read(.ccipr1) & 0x3000_0000)))
        configuration.eth1RefClockSelection = (((registers.read(.ccipr1) & 0x30000)))
        configuration.eth1PhyClockSelection = (((registers.read(.ccipr1) & 0x40000)))
        configuration.fdcanClockSelection = (((registers.read(.ccipr2) & 0xc00000)))
        configuration.fmcClockSelection =
            (((registers.read(.ckprotr) & 0x7000) == 0x5000) ? 0x5000 : (((registers.read(.ccipr1) & 0x3))))
        configuration.i2c1I3c1ClockSelection = (((registers.read(.ccipr2) & 0x3000)))
        configuration.i2c23ClockSelection = (((registers.read(.ccipr2) & 0x300)))
        configuration.lptim1ClockSelection = (((registers.read(.ccipr2) & 0x70000)))
        configuration.lptim23ClockSelection = (((registers.read(.ccipr4) & 0x700)))
        configuration.lptim45ClockSelection = (((registers.read(.ccipr4) & 0x7000)))
        configuration.lpuart1ClockSelection = (((registers.read(.ccipr4) & 0x7)))
        configuration.ltdcClockSelection = 0x0
        configuration.xspi1ClockSelection =
            (((registers.read(.ckprotr) & 0x70) == 0x40) ? 0x40 : (((registers.read(.ccipr1) & 0x30))))
        configuration.xspi2ClockSelection =
            (((registers.read(.ckprotr) & 0x700) == 0x400) ? 0x400 : (((registers.read(.ccipr1) & 0xc0))))
        configuration.pssiClockSelection = (((registers.read(.ccipr1) & 0x8000000)))
        configuration.rtcClockSelection =
            (((registers.read(.bdcr) & 0x300) == 0x300)
                ? (((registers.read(.cfgr) & 0x3f00) << 4) | 0x300) : (registers.read(.bdcr) & 0x300))
        configuration.sai1ClockSelection = (((registers.read(.ccipr3) & 0x70000)))
        configuration.sai2ClockSelection = (((registers.read(.ccipr3) & 0x700000)))
        configuration.sdmmc12ClockSelection = (((registers.read(.ccipr1) & 0x4)))
        configuration.spdifrxClockSelection = (((registers.read(.ccipr2) & 0x3000000)))
        configuration.spi1ClockSelection = (((registers.read(.ccipr3) & 0x700)))
        configuration.spi23ClockSelection = (((registers.read(.ccipr2) & 0x70)))
        configuration.spi45ClockSelection = (((registers.read(.ccipr3) & 0x70)))
        configuration.spi6ClockSelection = (((registers.read(.ccipr4) & 0x70)))
        if (registers.read(.cfgr) & 0x8000) == 0 {
            configuration.timPresSelection = 0x0
        } else {
            configuration.timPresSelection = 0x8000
        }
        configuration.usart1ClockSelection = (((registers.read(.ccipr3) & 0x7)))
        configuration.usart234578ClockSelection = (((registers.read(.ccipr2) & 0x7)))
        configuration.usbPhycClockSelection = (((registers.read(.ccipr1) & 0x3000)))
        configuration.usbOtgFsClockSelection = (((registers.read(.ccipr1) & 0xc000)))
        configuration.usbRefClockSelection = (((registers.read(.ccipr1) & 0xf00)))
        return configuration
    }

    public mutating func enableClockProtection(_ clocks: UInt32) {
        precondition(((((clocks) & 0x2) == 0x2) || (((clocks) & 0x1) == 0x1) || (((clocks) & ~(0x2 | 0x1)) == 0)))
        modifyExtended(.ckprotr, clear: 0, set: clocks)
    }

    public mutating func disableClockProtection(_ clocks: UInt32) {
        precondition(((((clocks) & 0x2) == 0x2) || (((clocks) & 0x1) == 0x1) || (((clocks) & ~(0x2 | 0x1)) == 0)))
        modifyExtended(.ckprotr, clear: clocks, set: 0)
    }

    public mutating func enableLSECSS() {
        modifyExtended(.bdcr, clear: 0, set: 0x20)
    }

    public mutating func disableLSECSS() {
        modifyExtended(.bdcr, clear: 0x20, set: 0)
        modifyExtended(.cier, clear: (0x200), set: 0)
    }

    public mutating func enableLSECSSInterrupt() {
        modifyExtended(.bdcr, clear: 0, set: 0x20)
        modifyExtended(.cier, clear: 0, set: (0x200))
        modifyExtended(.risingTrigger(bank: 0), clear: 0, set: 0x40000)
        modifyExtended(.interruptMask(bank: 0), clear: 0, set: 0x40000)
    }

    public mutating func configureWakeUpStopClock(_ source: UInt32) {
        precondition((((source) == 0x40) || ((source) == 0x0)))
        modifyExtended(.cfgr, clear: 0x40, set: (source))
    }

    public mutating func configureKernelWakeUpStopClock(_ source: UInt32) {
        precondition((((source) == 0x80) || ((source) == 0x0)))
        modifyExtended(.cfgr, clear: 0x80, set: (source))
    }

    public mutating func handleLSECSSInterrupt(callback: () -> Void = {}) {
        if ((registers.read(.cifr) & (0x200)) == (0x200)) {
            registers.write(.cicr, value: (0x200))
            callback()
        }
    }

    private mutating func modifyExtended(_ register: RCCExtendedRegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }

    private mutating func modifyExtended(_ register: RCCClockRegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }

    private mutating func modifyExtended(_ register: RCCControlRegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }

    private mutating func modifyExtended(_ register: EXTIRegister, clear: UInt32, set: UInt32) {
        registers.write(register, value: (registers.read(register) & ~clear) | set)
    }

}
