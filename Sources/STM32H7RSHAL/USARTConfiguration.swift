// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART initialization and macros from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USART {
  @discardableResult
  public func initialize<Clock: UARTClockIO>(clocks: Clock, getTick: () -> UInt32) -> HALStatus {
    initializeMSPIfReset()
    handle.write(.state, value: 2)
    disable()
    if setConfiguration(clocks: clocks) == .error { return .error }
    modify(.cr2, clear: 0x4000, set: 0)
    modify(.cr3, clear: 0x2A, set: 0)
    enable()
    return checkIdleState(getTick: getTick)
  }
  @discardableResult
  public func deinitialize() -> HALStatus {
    handle.write(.state, value: 2)
    registers.write(.cr1, value: 0)
    registers.write(.cr2, value: 0)
    registers.write(.cr3, value: 0)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invokeCallback(.mspDeinitialize)
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0)
    unlock()
    return .ok
  }
  @discardableResult
  public func setConfiguration<Clock: UARTClockIO>(clocks: Clock) -> HALStatus {
    var value = handle.read(.wordLength) | handle.read(.parity) | handle.read(.mode) | 0x8000
    modify(.cr1, clear: 0x3000_960C, set: value)
    value = 0x800
    value |= handle.read(.clockLastBit)
    value |= handle.read(.clockPolarity) | handle.read(.clockPhase)
    value |= handle.read(.stopBits)
    modify(.cr2, clear: 0x3F09, set: value)
    modify(.presc, clear: 0xF, set: handle.read(.clockPrescaler))
    let source: UARTClockSource
    switch registers.instance {
    case .usart1, .usart2, .usart3: source = clocks.source(for: registers.instance)
    default: source = .undefined
    }
    var divider: UInt32 = 0
    var result = HALStatus.ok
    switch source {
    case .pclk1, .pclk2, .pll2Q, .pll3Q, .hsi, .csi, .lse:
      let frequency = clocks.frequency(source)
      let prescaler = serialPrescalerDivisor(handle.read(.clockPrescaler))
      divider =
        ((frequency / prescaler) &* 2 &+ (handle.read(.baudRate) / 2)) / handle.read(.baudRate)
    default: result = .error
    }
    if divider >= 0x10 && divider <= 0xFFFF {
      let brr = UInt16(divider & 0xFFF0) | UInt16((divider & 0xF) >> 1)
      registers.write(.brr, value: UInt32(brr))
    } else {
      result = .error
    }
    handle.write(.txDataToProcess, value: 1)
    handle.write(.rxDataToProcess, value: 1)
    handle.write(.rxISR, value: 0)
    handle.write(.txISR, value: 0)
    return result
  }
  @discardableResult
  public func checkIdleState(getTick: () -> UInt32) -> HALStatus {
    handle.write(.errorCode, value: 0)
    let start = getTick()
    if registers.read(.cr1) & 8 == 8 {
      if waitOnFlag(0x200000, status: 0, start: start, timeout: 1000, getTick: getTick) != .ok {
        return .timeout
      }
    }
    if registers.read(.cr1) & 4 == 4 {
      if waitOnFlag(0x400000, status: 0, start: start, timeout: 1000, getTick: getTick) != .ok {
        return .timeout
      }
    }
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }
  @discardableResult
  public func waitOnFlag(
    _ flag: UInt32, status: UInt32, start: UInt32, timeout: UInt32,
    getTick: () -> UInt32
  ) -> HALStatus {
    while getFlag(flag) == status {
      if timeout != UInt32.max {
        if getTick() &- start > timeout || timeout == 0 {
          handle.write(.state, value: 1)
          unlock()
          return .timeout
        }
      }
    }
    return .ok
  }
  public func getState() -> UInt32 { handle.read(.state) }
  public func getError() -> UInt32 { handle.read(.errorCode) }
  func modify(_ register: UARTRegister, clear: UInt32, set: UInt32) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
  func tryLock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  public func enable() { modify(.cr1, clear: 0, set: 1) }
  public func disable() { modify(.cr1, clear: 1, set: 0) }
  public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.isr) & flag == flag ? 1 : 0 }
  public func clearFlag(_ flag: UInt32) { registers.write(.icr, value: flag) }
  public func sendRequest(_ request: UInt32) {
    modify(.rqr, clear: 0, set: UInt32(UInt16(truncatingIfNeeded: request)))
  }
  public func enableOneBitSampling() { modify(.cr3, clear: 0, set: 0x800) }
  public func disableOneBitSampling() { modify(.cr3, clear: 0x800, set: 0) }
  public func enableInterrupt(_ interrupt: UInt32) {
    modify(Self.interruptRegister(interrupt), clear: 0, set: UInt32(1) << (interrupt & 0x1F))
  }
  public func disableInterrupt(_ interrupt: UInt32) {
    modify(Self.interruptRegister(interrupt), clear: UInt32(1) << (interrupt & 0x1F), set: 0)
  }
  public func getInterrupt(_ interrupt: UInt32) -> UInt32 {
    registers.read(.isr) & (UInt32(1) << ((interrupt & 0x1F00) >> 8)) != 0 ? 1 : 0
  }
  public func getInterruptSource(_ interrupt: UInt32) -> UInt32 {
    registers.read(Self.interruptRegister(interrupt)) & (UInt32(1) << (interrupt & 0x1F)) != 0
      ? 1 : 0
  }
  static func interruptRegister(_ interrupt: UInt32) -> UARTRegister {
    let register = UInt8(truncatingIfNeeded: interrupt) >> 5
    return register == 1 ? .cr1 : (register == 2 ? .cr2 : .cr3)
  }
  func computeMask() {
    if handle.read(.wordLength) == 0x1000 {
      handle.write(.mask, value: handle.read(.parity) == 0 ? 0x1FF : 0xFF)
    } else if handle.read(.wordLength) == 0 {
      handle.write(.mask, value: handle.read(.parity) == 0 ? 0xFF : 0x7F)
    } else if handle.read(.wordLength) == 0x1000_0000 {
      handle.write(.mask, value: handle.read(.parity) == 0 ? 0x7F : 0x3F)
    } else {
      handle.write(.mask, value: 0)
    }
  }
}
