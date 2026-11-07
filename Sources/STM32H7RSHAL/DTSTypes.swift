// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Types and encodings from stm32h7rsxx_hal_dts.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

public enum DTSRegister: Hashable, CaseIterable {
  case cfgr1, t0valr1, rampvalr, itr1, dr, sr, itenr, icifr
}
public protocol DTSRegisterIO {
  func read(_ register: DTSRegister) -> UInt32
  func write(_ register: DTSRegister, value: UInt32)
}
public enum DTSConfigurationWord: Int, CaseIterable {
  case quickMeasure = 0, referenceClock, triggerInput, samplingTime, divider, highThreshold, lowThreshold
}
public enum DTSHandleWord: Int, CaseIterable { case lock = 0, state = 1 }

// Seven configuration words followed by lock/state in caller-owned storage.
// Copies and IRQ wrappers share these words; hardware implementations use
// volatile access and do not hold a Swift inout access across a HAL operation.
public protocol DTSHandleIO {
  func read(_ word: DTSConfigurationWord) -> UInt32
  func write(_ word: DTSConfigurationWord, value: UInt32)
  func read(_ word: DTSHandleWord) -> UInt32
  func write(_ word: DTSHandleWord, value: UInt32)
}

public enum DTSState: UInt32, CaseIterable, Sendable {
  case reset = 0, ready = 1, busy = 2, timeout = 3, error = 4
}
public enum DTSQuickMeasure: UInt32, CaseIterable, Sendable { case disabled = 0, enabled = 0x0020_0000 }
public enum DTSReferenceClock: UInt32, CaseIterable, Sendable { case pclk = 0, lse = 0x0010_0000 }
public enum DTSTrigger: UInt32, CaseIterable, Sendable {
  case none = 0, lowPowerTimer4 = 0x100, lowPowerTimer2 = 0x200, lowPowerTimer3 = 0x300, exti13 = 0x400
}
public enum DTSSamplingTime: UInt32, CaseIterable, Sendable {
  case cycles1 = 0x0001_0000, cycles2 = 0x0002_0000, cycles3 = 0x0003_0000
  case cycles4 = 0x0004_0000, cycles5 = 0x0005_0000, cycles6 = 0x0006_0000
  case cycles7 = 0x0007_0000, cycles8 = 0x0008_0000, cycles9 = 0x0009_0000
  case cycles10 = 0x000A_0000, cycles11 = 0x000B_0000, cycles12 = 0x000C_0000
  case cycles13 = 0x000D_0000, cycles14 = 0x000E_0000, cycles15 = 0x000F_0000
}
public struct DTSFlags: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let measureComplete = Self(rawValue: 1)
  public static let lowThreshold = Self(rawValue: 2)
  public static let highThreshold = Self(rawValue: 4)
  public static let asyncMeasureComplete = Self(rawValue: 0x10)
  public static let asyncLowThreshold = Self(rawValue: 0x20)
  public static let asyncHighThreshold = Self(rawValue: 0x40)
  public static let ready = Self(rawValue: 0x8000)
}
public struct DTSInterrupts: OptionSet, Sendable {
  public let rawValue: UInt32
  public init(rawValue: UInt32) { self.rawValue = rawValue }
  public static let measureComplete = Self(rawValue: 1)
  public static let lowThreshold = Self(rawValue: 2)
  public static let highThreshold = Self(rawValue: 4)
  public static let asyncMeasureComplete = Self(rawValue: 0x10)
  public static let asyncLowThreshold = Self(rawValue: 0x20)
  public static let asyncHighThreshold = Self(rawValue: 0x40)
}

public struct DTSConfiguration: Equatable, Sendable {
  public var quickMeasure, referenceClock, triggerInput, samplingTime, divider: UInt32
  public var highThreshold, lowThreshold: UInt32
  public init(quickMeasure: UInt32 = 0, referenceClock: UInt32 = 0, triggerInput: UInt32 = 0,
              samplingTime: UInt32 = 0x10000, divider: UInt32 = 0,
              highThreshold: UInt32 = 0, lowThreshold: UInt32 = 0) {
    self.quickMeasure = quickMeasure; self.referenceClock = referenceClock
    self.triggerInput = triggerInput; self.samplingTime = samplingTime; self.divider = divider
    self.highThreshold = highThreshold; self.lowThreshold = lowThreshold
  }
}
extension DTSHandleIO {
  public func setConfiguration(_ configuration: DTSConfiguration) {
    write(.quickMeasure, value: configuration.quickMeasure)
    write(.referenceClock, value: configuration.referenceClock)
    write(.triggerInput, value: configuration.triggerInput)
    write(.samplingTime, value: configuration.samplingTime)
    write(.divider, value: configuration.divider)
    write(.highThreshold, value: configuration.highThreshold)
    write(.lowThreshold, value: configuration.lowThreshold)
  }
  public func getConfiguration() -> DTSConfiguration {
    .init(quickMeasure: read(.quickMeasure), referenceClock: read(.referenceClock),
      triggerInput: read(.triggerInput), samplingTime: read(.samplingTime), divider: read(.divider),
      highThreshold: read(.highThreshold), lowThreshold: read(.lowThreshold))
  }
}

public struct DTS<Registers: DTSRegisterIO, Handle: DTSHandleIO, Callbacks: DTSCallbackIO> {
  public let registers: Registers
  public let handle: Handle
  public let callbacks: Callbacks
  public let defaults: DTSCallbackDefaults
  public let useRegisteredCallbacks: Bool
  public init(registers: Registers, handle: Handle, callbacks: Callbacks,
              defaults: DTSCallbackDefaults = .init(), useRegisteredCallbacks: Bool = false) {
    self.registers = registers; self.handle = handle; self.callbacks = callbacks
    self.defaults = defaults; self.useRegisteredCallbacks = useRegisteredCallbacks
  }
}
