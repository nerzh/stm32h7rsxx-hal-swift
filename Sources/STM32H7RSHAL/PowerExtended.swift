// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_pwr_ex.c/.h and PWR flag macros at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum PowerStopVoltageScale: UInt32, CaseIterable { case scale3 = 1, scale5 = 0 }
public enum PowerWakeUpPolarity: UInt32, CaseIterable { case high = 0, low = 1 }
public enum PowerWakeUpPull: UInt32, CaseIterable { case none = 0, up = 1, down = 2 }
public enum PowerWakeUpFlag: UInt32, CaseIterable { case pin1 = 1, pin2 = 2, pin3 = 4, pin4 = 8, all = 15 }

public struct PowerWakeUpConfiguration {
    public var pin: PowerWakeUpPin
    public var polarity: PowerWakeUpPolarity
    public var pull: PowerWakeUpPull
    public init(pin: PowerWakeUpPin, polarity: PowerWakeUpPolarity, pull: PowerWakeUpPull) {
        self.pin = pin; self.polarity = polarity; self.pull = pull
    }
}

public enum PowerAVDLevel: UInt32, CaseIterable {
    case level1 = 0, level2 = 0x4000, level3 = 0x8000, level4 = 0xC000
}
// Both detectors use identical mode encodings and share EXTI line 16.
public typealias PowerAVDMode = PowerPVDMode
public struct PowerAVDConfiguration {
    public var level: PowerAVDLevel
    public var mode: PowerAVDMode
    public init(level: PowerAVDLevel, mode: PowerAVDMode) { self.level = level; self.mode = mode }
}

public enum PowerBatteryChargingResistor: UInt32, CaseIterable {
    case kiloOhms5 = 0, kiloOhms1_5 = 0x200
}
public enum PowerXSPICapacitorPort: UInt32, CaseIterable { case port1 = 0xC00, port2 = 0x3000 }
public enum PowerXSPICapacitance: UInt32, CaseIterable {
    case off = 0, oneThird = 0x400, twoThirds = 0x800, full = 0xC00
}
public enum PowerTemperatureLevel: UInt32, CaseIterable {
    case betweenThresholds = 0, belowLowThreshold = 0x400000, aboveHighThreshold = 0x800000
}
public enum PowerVBATLevel: UInt32, CaseIterable {
    case betweenThresholds = 0, belowLowThreshold = 0x100000, aboveHighThreshold = 0x200000
}

// These are the PWR HAL encodings, not GPIOPort's peripheral indices.
public enum PowerPullUpPort: UInt32, CaseIterable { case n = 0, o = 1 }
public enum PowerPullDownPort: UInt32, CaseIterable { case n = 0, o = 1, p = 2 }

public enum PowerFlag: UInt32, CaseIterable {
    case activeVoltage = 0x20, activeVoltageReady = 0x21, pvdOutput = 0x24, avdOutput = 0x2D
    case backupRegulatorReady = 0x50, vbatLow = 0x54, vbatHigh = 0x55
    case temperatureLow = 0x56, temperatureHigh = 0x57
    case externalSupplyReady = 0x90, usb33Ready = 0x9A
    case stop = 0x108, standby = 0x109, voltageReady = 0x201
    case wakeup1 = 0x400, wakeup2 = 0x401, wakeup3 = 0x402, wakeup4 = 0x403, wakeupAll = 0x404
}

public enum PowerExtendedRegister: Hashable, CaseIterable {
    case cr1, sr1, csr1, csr2, csr3, csr4
    case wakeupClear, wakeupFlags, wakeupEnablePolarity, ucpdr, apcr
    case pullUpN, pullDownN, pullUpO, pullDownO, pullDownP
    case extiInterruptMask, extiEventMask, extiRisingTrigger, extiFallingTrigger
    case extiPending, extiSoftwareInterrupt, extiInterruptMask2
}

// Each access is one volatile 32-bit load/store. State lives outside the handle;
// an interrupt can use an independent immutable handle to the same registers.
public protocol PowerExtendedRegisterIO {
    func read(_ register: PowerExtendedRegister) -> UInt32
    func write(_ register: PowerExtendedRegister, value: UInt32)
}

public struct PowerExtended<IO: PowerExtendedRegisterIO> {
    public let registers: IO
    public init(registers: IO) { self.registers = registers }

    @discardableResult
    public func controlStopModeVoltageScaling(_ scale: PowerStopVoltageScale) -> HALStatus {
        modify(.cr1, clear: 1, set: scale.rawValue)
        return .ok
    }
    public func getStopModeVoltageRange() -> PowerStopVoltageScale {
        PowerStopVoltageScale(rawValue: registers.read(.cr1) & 1)!
    }
    public func enableFlashPowerDown() { set(.cr1, bits: 0x200) }
    public func disableFlashPowerDown() { clear(.cr1, bits: 0x200) }

    public func enableWakeUpPin(_ configuration: PowerWakeUpConfiguration) {
        let pin = configuration.pin.rawValue
        let position = UInt32(pin.trailingZeroBitCount)
        // Preserve low-polarity bits already encoded in WakeUpPin, as C does.
        let value = pin | (configuration.polarity.rawValue << ((position + 8) & 0x1F)) |
            (configuration.pull.rawValue << (((position * 2) + 16) & 0x1F))
        let mask = pin | (UInt32(0x100) << (position & 0x1F)) |
            (UInt32(0x30000) << ((position * 2) & 0x1F))
        modify(.wakeupEnablePolarity, clear: mask, set: value)
        // The C function replaces all four wakeup interrupt masks.
        modify(.extiInterruptMask2, clear: 0x0780_0000, set: pin << 23)
    }
    public func disableWakeUpPin(_ pin: PowerWakeUpPin) {
        // Unlike HAL_PWR_DisableWakeUpPin, the Ex function also clears polarity.
        clear(.wakeupEnablePolarity, bits: pin.rawValue)
    }
    public func getWakeupFlag(_ flag: PowerWakeUpFlag) -> UInt32 { registers.read(.wakeupFlags) & flag.rawValue }
    @discardableResult
    public func clearWakeupFlag(_ flag: PowerWakeUpFlag) -> HALStatus {
        registers.write(.wakeupClear, value: flag.rawValue)
        return (registers.read(.wakeupFlags) & flag.rawValue) != 0 ? .error : .ok
    }
    public func handleWakeUpPinInterrupt(pin1: () -> Void = {}, pin2: () -> Void = {},
                                         pin3: () -> Void = {}, pin4: () -> Void = {}) {
        if (registers.read(.wakeupFlags) & 1) != 0 { clearWakeupFlagBits(.pin1); pin1() }
        if (registers.read(.wakeupFlags) & 2) != 0 { clearWakeupFlagBits(.pin2); pin2() }
        if (registers.read(.wakeupFlags) & 4) != 0 { clearWakeupFlagBits(.pin3); pin3() }
        if (registers.read(.wakeupFlags) & 8) != 0 { clearWakeupFlagBits(.pin4); pin4() }
    }

    @discardableResult
    public func enableBackupRegulator(getTick: () -> UInt32) -> HALStatus {
        set(.csr1, bits: 1)
        return wait(.csr1, mask: 0x10000, value: 0x10000, getTick: getTick)
    }
    @discardableResult
    public func disableBackupRegulator(getTick: () -> UInt32) -> HALStatus {
        clear(.csr1, bits: 1)
        return wait(.csr1, mask: 0x10000, value: 0, getTick: getTick)
    }
    public func enableUSBRegulator() { set(.csr2, bits: 0x0200_0000) }
    public func disableUSBRegulator() { clear(.csr2, bits: 0x0200_0000) }
    @discardableResult
    public func enableUSBVoltageDetector(getTick: () -> UInt32) -> HALStatus {
        set(.csr2, bits: 0x0100_0000)
        return wait(.csr2, mask: 0x0400_0000, value: 0x0400_0000, getTick: getTick)
    }
    @discardableResult
    public func disableUSBVoltageDetector(getTick: () -> UInt32) -> HALStatus {
        clear(.csr2, bits: 0x0100_0000)
        return wait(.csr2, mask: 0x0400_0000, value: 0, getTick: getTick)
    }
    public func enableUSBHSRegulator() { set(.csr2, bits: 0x0800_0000) }
    public func disableUSBHSRegulator() { clear(.csr2, bits: 0x0800_0000) }
    public func enableUCPDStandbyMode() { set(.ucpdr, bits: 2) }
    public func disableUCPDStandbyMode() { clear(.ucpdr, bits: 2) }
    public func enableUCPDDeadBattery() { clear(.ucpdr, bits: 1) }
    public func disableUCPDDeadBattery() { set(.ucpdr, bits: 1) }
    public func enableBatteryCharging(_ resistor: PowerBatteryChargingResistor) {
        modify(.csr2, clear: 0x300, set: resistor.rawValue | 0x100)
    }
    public func disableBatteryCharging() { clear(.csr2, bits: 0x300) }
    public func enableAnalogBooster() { set(.cr1, bits: 0x1000); set(.cr1, bits: 0x800) }
    public func disableAnalogBooster() { clear(.cr1, bits: 0x800); clear(.cr1, bits: 0x1000) }
    public func enableXSPIM1() { set(.csr2, bits: 0x4000) }
    public func disableXSPIM1() { clear(.csr2, bits: 0x4000) }
    public func enableXSPIM2() { set(.csr2, bits: 0x8000) }
    public func disableXSPIM2() { clear(.csr2, bits: 0x8000) }
    public func configureXSPIPortCapacitor(_ port: PowerXSPICapacitorPort, setting: PowerXSPICapacitance) {
        if port == .port1 { modify(.csr2, clear: 0xC00, set: setting.rawValue) }
        else { modify(.csr2, clear: 0x3000, set: setting.rawValue << 2) }
    }
    public func getXSPIPortCapacitorConfiguration(_ port: PowerXSPICapacitorPort) -> PowerXSPICapacitance {
        let value: UInt32
        if port == .port1 { value = registers.read(.csr2) & 0xC00 }
        else { value = (registers.read(.csr2) & 0x3000) >> 2 }
        return PowerXSPICapacitance(rawValue: value)!
    }
    public func enableMonitoring() { set(.csr1, bits: 0x10) }
    public func disableMonitoring() { clear(.csr1, bits: 0x10) }
    public func getTemperatureLevel() -> PowerTemperatureLevel {
        let value = registers.read(.csr1) & 0xC00000
        if value == 0x400000 { return .belowLowThreshold }
        if value == 0x800000 { return .aboveHighThreshold }
        return .betweenThresholds
    }
    public func getVBATLevel() -> PowerVBATLevel {
        let value = registers.read(.csr1) & 0x300000
        if value == 0x100000 { return .belowLowThreshold }
        if value == 0x200000 { return .aboveHighThreshold }
        return .betweenThresholds
    }

    public func configureAVD(_ configuration: PowerAVDConfiguration) {
        modify(.cr1, clear: 0xC000, set: configuration.level.rawValue)
        disableAVDEvent(); disableAVDInterrupt(); disableAVDRisingEdge(); disableAVDFallingEdge()
        let mode = configuration.mode.rawValue
        if (mode & 0x10000) == 0x10000 { enableAVDInterrupt() }
        if (mode & 0x20000) == 0x20000 { enableAVDEvent() }
        if (mode & 1) == 1 { enableAVDRisingEdge() }
        if (mode & 2) == 2 { enableAVDFallingEdge() }
    }
    public func enableAVD() { set(.cr1, bits: 0x2000) }
    public func disableAVD() { clear(.cr1, bits: 0x2000) }
    public func handlePVDAVDInterrupt(callback: () -> Void = {}) {
        if (registers.read(.extiPending) & 0x10000) != 0 {
            registers.write(.extiPending, value: 0x10000)
            callback()
        }
    }
    public func enablePullUpPullDownConfiguration() { set(.apcr, bits: 1) }
    public func disablePullUpPullDownConfiguration() { clear(.apcr, bits: 1) }
    // Pins are the raw 16-bit PWR masks, including grouped pull-down bits.
    // The C checks only nonzero/16-bit width; it does not filter by port capability
    // or clear the opposite pull register.
    @discardableResult
    public func enableGPIOPullUp(port: PowerPullUpPort, pins: UInt16) -> HALStatus {
        precondition(pins != 0)
        set(port == .n ? .pullUpN : .pullUpO, bits: UInt32(pins))
        return .ok
    }
    @discardableResult
    public func disableGPIOPullUp(port: PowerPullUpPort, pins: UInt16) -> HALStatus {
        precondition(pins != 0)
        clear(port == .n ? .pullUpN : .pullUpO, bits: UInt32(pins))
        return .ok
    }
    @discardableResult
    public func enableGPIOPullDown(port: PowerPullDownPort, pins: UInt16) -> HALStatus {
        precondition(pins != 0)
        set(port == .n ? .pullDownN : port == .o ? .pullDownO : .pullDownP, bits: UInt32(pins))
        return .ok
    }
    @discardableResult
    public func disableGPIOPullDown(port: PowerPullDownPort, pins: UInt16) -> HALStatus {
        precondition(pins != 0)
        clear(port == .n ? .pullDownN : port == .o ? .pullDownO : .pullDownP, bits: UInt32(pins))
        return .ok
    }

    // AVD EXTI macros also operate on PVD's shared line 16.
    public func enableAVDInterrupt() { set(.extiInterruptMask, bits: 0x10000) }
    public func disableAVDInterrupt() { clear(.extiInterruptMask, bits: 0x10000) }
    public func enableAVDEvent() { set(.extiEventMask, bits: 0x10000) }
    public func disableAVDEvent() { clear(.extiEventMask, bits: 0x10000) }
    public func enableAVDRisingEdge() { set(.extiRisingTrigger, bits: 0x10000) }
    public func disableAVDRisingEdge() { clear(.extiRisingTrigger, bits: 0x10000) }
    public func enableAVDFallingEdge() { set(.extiFallingTrigger, bits: 0x10000) }
    public func disableAVDFallingEdge() { clear(.extiFallingTrigger, bits: 0x10000) }
    public func enableAVDRisingFallingEdge() { enableAVDRisingEdge(); enableAVDFallingEdge() }
    public func disableAVDRisingFallingEdge() { disableAVDRisingEdge(); disableAVDFallingEdge() }
    public func getAVDFlag() -> Bool { (registers.read(.extiPending) & 0x10000) == 0x10000 }
    public func clearAVDFlag() { registers.write(.extiPending, value: 0x10000) }
    public func generateAVDSoftwareInterrupt() { set(.extiSoftwareInterrupt, bits: 0x10000) }

    // __HAL_PWR_GET_WAKEUPFLAG returns 0 when any selected flag is set, unlike
    // HAL_PWREx_GetWakeupFlag. Keep that upstream macro behavior explicit.
    public func getWakeupFlagStatus(_ flag: PowerWakeUpFlag) -> UInt32 {
        (registers.read(.wakeupFlags) & flag.rawValue) != 0 ? 0 : 1
    }
    // __HAL_PWR_CLEAR_WAKEUPFLAG uses RMW, unlike the Ex function's direct write.
    public func clearWakeupFlagBits(_ flag: PowerWakeUpFlag) { set(.wakeupClear, bits: flag.rawValue) }
    public func getFlag(_ flag: PowerFlag) -> Bool {
        let register: PowerExtendedRegister
        let mask: UInt32
        switch flag {
        case .activeVoltage: register = .sr1; mask = 1
        case .activeVoltageReady: register = .sr1; mask = 2
        case .pvdOutput: register = .sr1; mask = 0x10
        case .avdOutput: register = .sr1; mask = 0x2000
        case .backupRegulatorReady: register = .csr1; mask = 0x10000
        case .vbatLow: register = .csr1; mask = 0x100000
        case .vbatHigh: register = .csr1; mask = 0x200000
        case .temperatureLow: register = .csr1; mask = 0x400000
        case .temperatureHigh: register = .csr1; mask = 0x800000
        case .externalSupplyReady: register = .csr2; mask = 0x10000
        case .usb33Ready: register = .csr2; mask = 0x4000000
        case .stop: register = .csr3; mask = 0x100
        case .standby: register = .csr3; mask = 0x200
        case .voltageReady: register = .csr4; mask = 2
        case .wakeup1: register = .wakeupFlags; mask = 1
        case .wakeup2: register = .wakeupFlags; mask = 2
        case .wakeup3: register = .wakeupFlags; mask = 4
        // The GET_FLAG macro falls through to WKUPF4 even for WUF_ALL.
        case .wakeup4, .wakeupAll: register = .wakeupFlags; mask = 8
        }
        return (registers.read(register) & mask) == mask
    }
    public func clearFlag(_ flag: PowerFlag) {
        switch flag {
        case .stop, .standby: set(.csr3, bits: 2)
        case .wakeup1: clearWakeupFlagBits(.pin1)
        case .wakeup2: clearWakeupFlagBits(.pin2)
        case .wakeup3: clearWakeupFlagBits(.pin3)
        case .wakeup4: clearWakeupFlagBits(.pin4)
        // Preserve the macro's fallback for every other encoded flag.
        default: clearWakeupFlagBits(.all)
        }
    }

    private func wait(_ register: PowerExtendedRegister, mask: UInt32, value: UInt32,
                      getTick: () -> UInt32) -> HALStatus {
        let started = getTick()
        while (registers.read(register) & mask) != value {
            if (getTick() &- started) > 1000 { return .error }
        }
        return .ok
    }
    private func modify(_ register: PowerExtendedRegister, clear mask: UInt32, set value: UInt32) {
        registers.write(register, value: (registers.read(register) & ~mask) | value)
    }
    private func set(_ register: PowerExtendedRegister, bits: UInt32) { modify(register, clear: 0, set: bits) }
    private func clear(_ register: PowerExtendedRegister, bits: UInt32) { modify(register, clear: bits, set: 0) }
}
