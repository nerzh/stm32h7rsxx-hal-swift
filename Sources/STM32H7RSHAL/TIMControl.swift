// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  func channelState(_ channel: UInt32) -> UInt32 {
    handle.readChannelState(
      channel == 0
        ? 0 : channel == 4 ? 1 : channel == 8 ? 2 : channel == 12 ? 3 : channel == 16 ? 4 : 5,
      complementary: false)
  }
  func channelSetState(_ channel: UInt32, _ value: UInt32) {
    handle.writeChannelState(
      channel == 0
        ? 0 : channel == 4 ? 1 : channel == 8 ? 2 : channel == 12 ? 3 : channel == 16 ? 4 : 5,
      complementary: false, value: value)
  }
  func channelSetAllStates(_ value: UInt32) {
    handle.writeChannelState(0, complementary: false, value: value)
    handle.writeChannelState(1, complementary: false, value: value)
    handle.writeChannelState(2, complementary: false, value: value)
    handle.writeChannelState(3, complementary: false, value: value)
    handle.writeChannelState(4, complementary: false, value: value)
    handle.writeChannelState(5, complementary: false, value: value)
  }
  func channelNState(_ channel: UInt32) -> UInt32 {
    handle.readChannelState(
      channel == 0 ? 0 : channel == 4 ? 1 : channel == 8 ? 2 : 3, complementary: true)
  }
  func channelNSetState(_ channel: UInt32, _ value: UInt32) {
    handle.writeChannelState(
      channel == 0 ? 0 : channel == 4 ? 1 : channel == 8 ? 2 : 3, complementary: true, value: value)
  }
  func channelNSetAllStates(_ value: UInt32) {
    handle.writeChannelState(0, complementary: true, value: value)
    handle.writeChannelState(1, complementary: true, value: value)
    handle.writeChannelState(2, complementary: true, value: value)
    handle.writeChannelState(3, complementary: true, value: value)
  }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    channelSetAllStates(0)
    channelNSetAllStates(0)
    handle.write(.dmaBurstState, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.baseMspInitialize, value: nil)
      callbacks.write(.baseMspDeinitialize, value: nil)
      callbacks.write(.inputCaptureMspInitialize, value: nil)
      callbacks.write(.inputCaptureMspDeinitialize, value: nil)
      callbacks.write(.outputCompareMspInitialize, value: nil)
      callbacks.write(.outputCompareMspDeinitialize, value: nil)
      callbacks.write(.pWMMspInitialize, value: nil)
      callbacks.write(.pWMMspDeinitialize, value: nil)
      callbacks.write(.onePulseMspInitialize, value: nil)
      callbacks.write(.onePulseMspDeinitialize, value: nil)
      callbacks.write(.encoderMspInitialize, value: nil)
      callbacks.write(.encoderMspDeinitialize, value: nil)
      callbacks.write(.hallSensorMspInitialize, value: nil)
      callbacks.write(.hallSensorMspDeinitialize, value: nil)
    }
  }
  public func enable() { modify(.cr1, set: 0x1) }
  public func enableMainOutput() { modify(.bdtr, set: 0x8000) }
  public func enableUpdateFlagRemap() { modify(.cr1, set: 0x800) }
  public func disableUpdateFlagRemap() { modify(.cr1, clear: 0x800) }
  public func enableUpdateRequestSource() { modify(.cr1, set: 0x4) }
  public func disableUpdateRequestSource() { modify(.cr1, clear: 0x4) }
  public func disable() {
    if registers.read(.ccer) & 0x111111 == 0 {
      if registers.read(.ccer) & 0x4444 == 0 { modify(.cr1, clear: 0x1) }
    }
  }
  public func disableMainOutput() {
    if registers.read(.ccer) & 0x111111 == 0 {
      if registers.read(.ccer) & 0x4444 == 0 { modify(.bdtr, clear: 0x8000) }
    }
  }
  public func disableMainOutputUnconditionally() { modify(.bdtr, clear: 0x8000) }
  public func enableInterrupts(_ mask: UInt32) { modify(.dier, set: mask) }
  public func disableInterrupts(_ mask: UInt32) { modify(.dier, clear: mask) }
  public func enableDMARequests(_ mask: UInt32) { modify(.dier, set: mask) }
  public func disableDMARequests(_ mask: UInt32) { modify(.dier, clear: mask) }
  public func getFlag(_ flag: UInt32) -> Bool { registers.read(.sr) & flag == flag }
  public func clearFlag(_ flag: UInt32) { registers.write(.sr, value: ~flag) }
  public func getInterruptSource(_ source: UInt32) -> Bool {
    registers.read(.dier) & source == source
  }
  public func clearInterrupt(_ interrupt: UInt32) { registers.write(.sr, value: ~interrupt) }
  public func isCountingDown() -> Bool { registers.read(.cr1) & 0x10 == 0x10 }
  public func setPrescaler(_ value: UInt32) { registers.write(.psc, value: value) }
  public func setCounter(_ value: UInt32) { registers.write(.cnt, value: value) }
  public func getCounter() -> UInt32 { registers.read(.cnt) }
  public func setAutoReload(_ value: UInt32) {
    registers.write(.arr, value: value)
    handle.write(.period, value: value)
  }
  public func getAutoReload() -> UInt32 { registers.read(.arr) }
  public func setClockDivision(_ value: UInt32) {
    modify(.cr1, clear: 0x300, set: value)
    handle.write(.clockDivision, value: value)
  }
  public func getClockDivision() -> UInt32 { registers.read(.cr1) & 0x300 }
  public func setInputCapturePrescaler(_ channel: UInt32, _ value: UInt32) {
    if channel == 0 {
      modify(.ccmr1, clear: 0xC)
      modify(.ccmr1, set: value)
    } else if channel == 4 {
      modify(.ccmr1, clear: 0xC00)
      modify(.ccmr1, set: value << 8)
    } else if channel == 8 {
      modify(.ccmr2, clear: 0xC)
      modify(.ccmr2, set: value)
    } else {
      modify(.ccmr2, clear: 0xC00)
      modify(.ccmr2, set: value << 8)
    }
  }
  public func getInputCapturePrescaler(_ channel: UInt32) -> UInt32 {
    if channel == 0 {
      return registers.read(.ccmr1) & 0xC
    } else if channel == 4 {
      return (registers.read(.ccmr1) & 0xC00) >> 8
    } else if channel == 8 {
      return registers.read(.ccmr2) & 0xC
    } else {
      return (registers.read(.ccmr2) & 0xC00) >> 8
    }
  }
  func compareRegister(_ channel: UInt32) -> TIMRegister {
    channel == 0
      ? .ccr1
      : channel == 4
        ? .ccr2 : channel == 8 ? .ccr3 : channel == 12 ? .ccr4 : channel == 16 ? .ccr5 : .ccr6
  }
  public func setCompare(_ channel: UInt32, _ value: UInt32) {
    registers.write(compareRegister(channel), value: value)
  }
  public func getCompare(_ channel: UInt32) -> UInt32 { registers.read(compareRegister(channel)) }
  public func enableOutputComparePreload(_ channel: UInt32) {
    if channel == 0 {
      modify(.ccmr1, set: 0x8)
    } else if channel == 4 {
      modify(.ccmr1, set: 0x800)
    } else if channel == 8 {
      modify(.ccmr2, set: 0x8)
    } else if channel == 12 {
      modify(.ccmr2, set: 0x800)
    } else if channel == 16 {
      modify(.ccmr3, set: 0x8)
    } else {
      modify(.ccmr3, set: 0x800)
    }
  }
  public func disableOutputComparePreload(_ channel: UInt32) {
    if channel == 0 {
      modify(.ccmr1, clear: 0x8)
    } else if channel == 4 {
      modify(.ccmr1, clear: 0x800)
    } else if channel == 8 {
      modify(.ccmr2, clear: 0x8)
    } else if channel == 12 {
      modify(.ccmr2, clear: 0x800)
    } else if channel == 16 {
      modify(.ccmr3, clear: 0x8)
    } else {
      modify(.ccmr3, clear: 0x800)
    }
  }
  public func enableOutputCompareFast(_ channel: UInt32) {
    if channel == 0 {
      modify(.ccmr1, set: 0x4)
    } else if channel == 4 {
      modify(.ccmr1, set: 0x400)
    } else if channel == 8 {
      modify(.ccmr2, set: 0x4)
    } else if channel == 12 {
      modify(.ccmr2, set: 0x400)
    } else if channel == 16 {
      modify(.ccmr3, set: 0x4)
    } else {
      modify(.ccmr3, set: 0x400)
    }
  }
  public func disableOutputCompareFast(_ channel: UInt32) {
    if channel == 0 {
      modify(.ccmr1, clear: 0x4)
    } else if channel == 4 {
      modify(.ccmr1, clear: 0x400)
    } else if channel == 8 {
      modify(.ccmr2, clear: 0x4)
    } else if channel == 12 {
      modify(.ccmr2, clear: 0x400)
    } else if channel == 16 {
      modify(.ccmr3, clear: 0x4)
    } else {
      modify(.ccmr3, clear: 0x400)
    }
  }
  public func setCapturePolarity(_ channel: UInt32, _ value: UInt32) {
    if channel == 0 {
      modify(.ccer, clear: 0xA)
      modify(.ccer, set: value)
    } else if channel == 4 {
      modify(.ccer, clear: 0xA0)
      modify(.ccer, set: value << 4)
    } else if channel == 8 {
      modify(.ccer, clear: 0xA00)
      modify(.ccer, set: value << 8)
    } else {
      modify(.ccer, clear: 0xA000)
      modify(.ccer, set: value << 12)
    }
  }
  public func selectCaptureCompareDMARequest(_ value: UInt32) { modify(.cr2, clear: 8, set: value) }
}
public enum TIMCalculations {
  public static func updateFlagCopy(_ counter: UInt32) -> Bool {
    counter & 0x8000_0000 == 0x8000_0000
  }
  public static func prescaler(_ timerClock: UInt32, _ counterClock: UInt32) -> UInt32 {
    timerClock >= counterClock ? timerClock / counterClock &- 1 : 0
  }
  public static func period(_ timerClock: UInt32, _ prescaler: UInt32, _ frequency: UInt32)
    -> UInt32
  {
    timerClock / (prescaler &+ 1) >= frequency
      ? timerClock / (frequency &* (prescaler &+ 1)) &- 1 : 0
  }
  public static func periodDither(_ timerClock: UInt32, _ prescaler: UInt32, _ frequency: UInt32)
    -> UInt32
  {
    timerClock / (prescaler &+ 1) >= frequency
      ? UInt32(
        truncatingIfNeeded: UInt64(timerClock) &* 16 / UInt64(frequency &* (prescaler &+ 1)) &- 16)
      : 0
  }
  public static func pulse(_ timerClock: UInt32, _ prescaler: UInt32, _ delay: UInt32) -> UInt32 {
    UInt32(
      truncatingIfNeeded: UInt64(timerClock) &* UInt64(delay)
        / (1_000_000 &* UInt64(prescaler &+ 1)))
  }
  public static func pulseDither(_ timerClock: UInt32, _ prescaler: UInt32, _ delay: UInt32)
    -> UInt32
  {
    UInt32(
      truncatingIfNeeded: UInt64(timerClock) &* UInt64(delay) &* 16
        / (1_000_000 &* UInt64(prescaler &+ 1)))
  }
  public static func periodByDelay(
    _ timerClock: UInt32, _ prescaler: UInt32, _ delay: UInt32, _ pulse: UInt32
  ) -> UInt32 {
    self.pulse(timerClock, prescaler, pulse) &+ self.pulse(timerClock, prescaler, delay)
  }
  public static func periodDitherByDelay(
    _ timerClock: UInt32, _ prescaler: UInt32, _ delay: UInt32, _ pulse: UInt32
  ) -> UInt32 {
    pulseDither(timerClock, prescaler, pulse) &+ pulseDither(timerClock, prescaler, delay)
  }
}
