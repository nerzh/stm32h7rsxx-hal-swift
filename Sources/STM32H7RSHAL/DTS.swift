// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_dts.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DTS {
  @discardableResult
  public func initialize() -> HALStatus {
    precondition(DTSQuickMeasure(rawValue: handle.read(.quickMeasure)) != nil)
    precondition(DTSReferenceClock(rawValue: handle.read(.referenceClock)) != nil)
    precondition(DTSTrigger(rawValue: handle.read(.triggerInput)) != nil)
    precondition(DTSSamplingTime(rawValue: handle.read(.samplingTime)) != nil)
    precondition(handle.read(.highThreshold) <= 0xFFFF)
    precondition(handle.read(.lowThreshold) <= 0xFFFF)
    if handle.read(.state) == DTSState.reset.rawValue {
      if useRegisteredCallbacks {
        callbacks.write(.measureComplete, value: defaults.measureComplete)
        callbacks.write(.lowThreshold, value: defaults.lowThreshold)
        callbacks.write(.highThreshold, value: defaults.highThreshold)
        callbacks.write(.asyncMeasureComplete, value: defaults.asyncMeasureComplete)
        callbacks.write(.asyncLowThreshold, value: defaults.asyncLowThreshold)
        callbacks.write(.asyncHighThreshold, value: defaults.asyncHighThreshold)
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
      }
      invokeCallback(.mspInitialize)
    }
    handle.write(.state, value: DTSState.busy.rawValue)
    if registers.read(.rampvalr) == 0 { return .error }
    if registers.read(.t0valr1) == 0 { return .error }
    if handle.read(.quickMeasure) == DTSQuickMeasure.disabled.rawValue {
      if handle.read(.referenceClock) == DTSReferenceClock.pclk.rawValue {
        precondition(handle.read(.divider) <= 127)
      }
      modify(.cfgr1, clear: 0x0020_0000, set: 0)
    } else {
      if handle.read(.referenceClock) != DTSReferenceClock.lse.rawValue { return .error }
      modify(.cfgr1, clear: 0, set: 0x0020_0000)
    }
    if handle.read(.referenceClock) == DTSReferenceClock.lse.rawValue {
      modify(.cfgr1, clear: 0, set: 0x0010_0000)
    } else {
      modify(.cfgr1, clear: 0x0010_0000, set: 0)
    }
    modify(.cfgr1, clear: 0x7F00_0000, set: handle.read(.divider) << 24)
    modify(.cfgr1, clear: 0x000F_0000, set: handle.read(.samplingTime))
    modify(.cfgr1, clear: 0xF00, set: handle.read(.triggerInput))
    modify(.itr1, clear: 0xFFFF_0000, set: handle.read(.highThreshold) << 16)
    modify(.itr1, clear: 0xFFFF, set: handle.read(.lowThreshold))
    handle.write(.state, value: DTSState.ready.rawValue)
    return .ok
  }

  @discardableResult
  public func deinitialize() -> HALStatus {
    registers.write(.cfgr1, value: 0)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invokeCallback(.mspDeinitialize)
    handle.write(.state, value: DTSState.reset.rawValue)
    return .ok
  }

  @discardableResult
  public func start(getTick: () -> UInt32, delay: (UInt32) -> Void) -> HALStatus {
    guard handle.read(.state) == DTSState.ready.rawValue else { return .busy }
    handle.write(.state, value: DTSState.busy.rawValue)
    enable()
    let start = getTick()
    while getFlag(0x8000) == 0 {
      if getTick() &- start > 1 { return .timeout }
    }
    if getTrigger() == DTSTrigger.none.rawValue {
      modify(.cfgr1, clear: 0, set: 0x10)
      delay(5)
    }
    handle.write(.state, value: DTSState.ready.rawValue)
    return .ok
  }

  @discardableResult
  public func stop() -> HALStatus {
    guard handle.read(.state) == DTSState.ready.rawValue else { return .busy }
    handle.write(.state, value: DTSState.busy.rawValue)
    if getTrigger() == DTSTrigger.none.rawValue { modify(.cfgr1, clear: 0x10, set: 0) }
    disable()
    handle.write(.state, value: DTSState.ready.rawValue)
    return .ok
  }

  @discardableResult
  public func startInterrupt(getTick: () -> UInt32, delay: (UInt32) -> Void) -> HALStatus {
    guard handle.read(.state) == DTSState.ready.rawValue else { return .busy }
    handle.write(.state, value: DTSState.busy.rawValue)
    if handle.read(.referenceClock) == DTSReferenceClock.lse.rawValue { enableInterrupts(0x70) }
    else { enableInterrupts(7) }
    enable()
    let start = getTick()
    while getFlag(0x8000) == 0 {
      if getTick() &- start > 1 { return .timeout }
    }
    if getTrigger() == DTSTrigger.none.rawValue {
      modify(.cfgr1, clear: 0, set: 0x10)
      delay(5)
    }
    handle.write(.state, value: DTSState.ready.rawValue)
    return .ok
  }

  @discardableResult
  public func stopInterrupt() -> HALStatus {
    guard handle.read(.state) == DTSState.ready.rawValue else { return .busy }
    handle.write(.state, value: DTSState.busy.rawValue)
    if handle.read(.referenceClock) == DTSReferenceClock.lse.rawValue { disableInterrupts(0x70) }
    else { disableInterrupts(7) }
    if getTrigger() == DTSTrigger.none.rawValue { modify(.cfgr1, clear: 0x10, set: 0) }
    disable()
    handle.write(.state, value: DTSState.ready.rawValue)
    return .ok
  }

  @discardableResult
  public func getTemperature(_ temperature: inout Int32, getPCLK1Frequency: () -> UInt32,
                             lseValue: UInt32 = 32_768) -> HALStatus {
    guard handle.read(.state) == DTSState.ready.rawValue else { return .busy }
    handle.write(.state, value: DTSState.busy.rawValue)
    let samples = registers.read(.dr) & 0xFFFF
    if handle.read(.samplingTime) == 0 || samples == 0 {
      handle.write(.state, value: DTSState.ready.rawValue)
      return .error
    }
    let frequency: UInt32
    if handle.read(.referenceClock) == DTSReferenceClock.lse.rawValue {
      frequency = (lseValue &* samples) / (handle.read(.samplingTime) >> 16)
    } else {
      frequency = (getPCLK1Frequency() &* (handle.read(.samplingTime) >> 16)) / samples
    }
    var calibrationTemperature = registers.read(.t0valr1) >> 16
    if calibrationTemperature == 0 { calibrationTemperature = 30 }
    else if calibrationTemperature == 1 { calibrationTemperature = 130 }
    else {
      handle.write(.state, value: DTSState.ready.rawValue)
      return .error
    }
    let calibrationFrequency = (registers.read(.t0valr1) & 0xFFFF) &* 100
    let ramp = registers.read(.rampvalr) & 0xFFFF
    if ramp == 0 {
      handle.write(.state, value: DTSState.ready.rawValue)
      return .error
    }
    let difference = Int32(bitPattern: frequency) &- Int32(bitPattern: calibrationFrequency)
    temperature = Int32(bitPattern: calibrationTemperature) &+ (difference / Int32(bitPattern: ramp))
    handle.write(.state, value: DTSState.ready.rawValue)
    return .ok
  }

  public func handleInterrupt() {
    if getFlag(0x10) != 0 { clearFlag(0x10); invokeCallback(.asyncMeasureComplete) }
    if getFlag(0x20) != 0 { clearFlag(0x20); invokeCallback(.asyncLowThreshold) }
    if getFlag(0x40) != 0 { clearFlag(0x40); invokeCallback(.asyncHighThreshold) }
    if getFlag(1) != 0 { clearFlag(1); invokeCallback(.measureComplete) }
    if getFlag(2) != 0 { clearFlag(2); invokeCallback(.lowThreshold) }
    if getFlag(4) != 0 { clearFlag(4); invokeCallback(.highThreshold) }
  }
  public func getState() -> UInt32 { handle.read(.state) }

  public func enable() { modify(.cfgr1, clear: 0, set: 1) }
  public func disable() { modify(.cfgr1, clear: 1, set: 0) }
  public func getFlag(_ flags: UInt32) -> UInt32 { registers.read(.sr) & flags == flags ? 1 : 0 }
  public func clearFlag(_ flags: UInt32) { registers.write(.icifr, value: flags) }
  public func enableInterrupts(_ interrupts: UInt32) { modify(.itenr, clear: 0, set: interrupts) }
  public func disableInterrupts(_ interrupts: UInt32) { modify(.itenr, clear: interrupts, set: 0) }
  public func getInterruptSource(_ interrupts: UInt32) -> UInt32 {
    registers.read(.itenr) & interrupts == interrupts ? 1 : 0
  }
  public func getReferenceClock(_ referenceClock: UInt32) -> UInt32 {
    registers.read(.cfgr1) & referenceClock == referenceClock ? 1 : 0
  }
  public func getTrigger() -> UInt32 { registers.read(.cfgr1) & 0xF00 }

  // The pinned HAL uses IMR2/EMR2 (bank 1) with EXTI_IMR3_IM77's bit 13 mask.
  public func enableWakeupInterrupt<IO: EXTIRegisterIO>(registers: inout IO) {
    let value = registers.read(.interruptMask(bank: 1)) | 0x2000
    registers.write(.interruptMask(bank: 1), value: value)
  }
  public func disableWakeupInterrupt<IO: EXTIRegisterIO>(registers: inout IO) {
    let value = registers.read(.interruptMask(bank: 1)) & ~UInt32(0x2000)
    registers.write(.interruptMask(bank: 1), value: value)
  }
  public func enableWakeupEvent<IO: EXTIRegisterIO>(registers: inout IO) {
    let value = registers.read(.eventMask(bank: 1)) | 0x2000
    registers.write(.eventMask(bank: 1), value: value)
  }
  public func disableWakeupEvent<IO: EXTIRegisterIO>(registers: inout IO) {
    let value = registers.read(.eventMask(bank: 1)) & ~UInt32(0x2000)
    registers.write(.eventMask(bank: 1), value: value)
  }
  func modify(_ register: DTSRegister, clear: UInt32, set: UInt32) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
}
