// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Initialization, control and register helpers from stm32h7rsxx_hal_uart.c/.h
// and stm32h7rsxx_hal_uart_ex.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension UART {
  @discardableResult
  public func initialize<Clock: UARTClockIO>(clocks: Clock, getTick: () -> UInt32) -> HALStatus {
    prepareInitialization()
    if setConfiguration(clocks: clocks) == .error { return .error }
    modify(.cr2, clear: 0x4800, set: 0)
    modify(.cr3, clear: 0x2A, set: 0)
    enable()
    return checkIdleState(getTick: getTick)
  }

  @discardableResult
  public func initializeHalfDuplex<Clock: UARTClockIO>(clocks: Clock, getTick: () -> UInt32)
    -> HALStatus
  {
    prepareInitialization()
    if setConfiguration(clocks: clocks) == .error { return .error }
    modify(.cr2, clear: 0x4800, set: 0)
    modify(.cr3, clear: 0x22, set: 0)
    modify(.cr3, clear: 0, set: 8)
    enable()
    return checkIdleState(getTick: getTick)
  }

  @discardableResult
  public func initializeLIN<Clock: UARTClockIO>(
    breakDetectLength: UInt32, clocks: Clock,
    getTick: () -> UInt32
  ) -> HALStatus {
    precondition(!registers.instance.isLowPower)
    precondition(breakDetectLength == 0 || breakDetectLength == 0x20)
    if handle.read(.overSampling) == 0x8000 { return .error }
    if handle.read(.wordLength) != 0 { return .error }
    prepareInitialization()
    if setConfiguration(clocks: clocks) == .error { return .error }
    modify(.cr2, clear: 0x800, set: 0)
    modify(.cr3, clear: 0x2A, set: 0)
    modify(.cr2, clear: 0, set: 0x4000)
    modify(.cr2, clear: 0x20, set: breakDetectLength)
    enable()
    return checkIdleState(getTick: getTick)
  }

  @discardableResult
  public func initializeMultiProcessor<Clock: UARTClockIO>(
    address: UInt8, wakeupMethod: UInt32,
    clocks: Clock, getTick: () -> UInt32
  ) -> HALStatus {
    precondition(wakeupMethod == 0 || wakeupMethod == 0x800)
    prepareInitialization()
    if setConfiguration(clocks: clocks) == .error { return .error }
    modify(.cr2, clear: 0x4800, set: 0)
    modify(.cr3, clear: 0x2A, set: 0)
    if wakeupMethod == 0x800 { modify(.cr2, clear: 0xFF00_0000, set: UInt32(address) << 24) }
    modify(.cr1, clear: 0x800, set: wakeupMethod)
    enable()
    return checkIdleState(getTick: getTick)
  }

  @discardableResult
  public func initializeRS485<Clock: UARTClockIO>(
    polarity: UInt32, assertionTime: UInt32,
    deassertionTime: UInt32, clocks: Clock,
    getTick: () -> UInt32
  ) -> HALStatus {
    precondition(polarity == 0 || polarity == 0x8000)
    precondition(assertionTime <= 0x1F && deassertionTime <= 0x1F)
    prepareInitialization()
    if setConfiguration(clocks: clocks) == .error { return .error }
    modify(.cr3, clear: 0, set: 0x4000)
    modify(.cr3, clear: 0x8000, set: polarity)
    var value = assertionTime << 21
    value |= deassertionTime << 16
    modify(.cr1, clear: 0x03FF_0000, set: value)
    enable()
    return checkIdleState(getTick: getTick)
  }

  @discardableResult
  public func deinitialize() -> HALStatus {
    handle.write(.globalState, value: 0x24)
    registers.write(.cr1, value: 0)
    registers.write(.cr2, value: 0)
    registers.write(.cr3, value: 0)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invokeCallback(.mspDeinitialize)
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: 0)
    handle.write(.receiveState, value: 0)
    handle.write(.receptionType, value: 0)
    handle.write(.rxEventType, value: 0)
    unlock()
    return .ok
  }

  public func configureReceiverTimeout(_ timeout: UInt32) {
    if !registers.instance.isLowPower {
      precondition(timeout <= 0xFF_FFFF)
      modify(.rtor, clear: 0xFF_FFFF, set: timeout)
    }
  }

  @discardableResult
  public func enableReceiverTimeout() -> HALStatus {
    if registers.instance.isLowPower { return .error }
    if handle.read(.globalState) != 0x20 { return .busy }
    if !tryLock() { return .busy }
    handle.write(.globalState, value: 0x24)
    modify(.cr2, clear: 0, set: 0x800000)
    handle.write(.globalState, value: 0x20)
    unlock()
    return .ok
  }

  @discardableResult
  public func disableReceiverTimeout() -> HALStatus {
    if registers.instance.isLowPower { return .error }
    if handle.read(.globalState) != 0x20 { return .busy }
    if !tryLock() { return .busy }
    handle.write(.globalState, value: 0x24)
    modify(.cr2, clear: 0x800000, set: 0)
    handle.write(.globalState, value: 0x20)
    unlock()
    return .ok
  }

  @discardableResult
  public func enableMuteMode(getTick: () -> UInt32) -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.globalState, value: 0x24)
    registers.atomicModify(.cr1, clear: 0, set: 0x2000)
    handle.write(.globalState, value: 0x20)
    return checkIdleState(getTick: getTick)
  }

  @discardableResult
  public func disableMuteMode(getTick: () -> UInt32) -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.globalState, value: 0x24)
    registers.atomicModify(.cr1, clear: 0x2000, set: 0)
    handle.write(.globalState, value: 0x20)
    return checkIdleState(getTick: getTick)
  }

  public func enterMuteMode() { sendRequest(4) }

  @discardableResult
  public func enableTransmitter() -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.globalState, value: 0x24)
    registers.atomicModify(.cr1, clear: 0xC, set: 0)
    registers.atomicModify(.cr1, clear: 0, set: 8)
    handle.write(.globalState, value: 0x20)
    unlock()
    return .ok
  }

  @discardableResult
  public func enableReceiver() -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.globalState, value: 0x24)
    registers.atomicModify(.cr1, clear: 0xC, set: 0)
    registers.atomicModify(.cr1, clear: 0, set: 4)
    handle.write(.globalState, value: 0x20)
    unlock()
    return .ok
  }

  @discardableResult
  public func sendBreak() -> HALStatus {
    precondition(!registers.instance.isLowPower)
    if !tryLock() { return .busy }
    handle.write(.globalState, value: 0x24)
    sendRequest(2)
    handle.write(.globalState, value: 0x20)
    unlock()
    return .ok
  }

  public func getState() -> UInt32 {
    let global = handle.read(.globalState)
    let receive = handle.read(.receiveState)
    return global | receive
  }
  public func getError() -> UInt32 { handle.read(.errorCode) }

  func prepareInitialization() {
    initializeMSPIfReset()
    handle.write(.globalState, value: 0x24)
    disable()
    if handle.read(.features) != 0 { configureAdvancedFeatures() }
  }

  func setConfiguration<Clock: UARTClockIO>(clocks: Clock) -> HALStatus {
    validateConfiguration()
    var value =
      handle.read(.wordLength) | handle.read(.parity) | handle.read(.mode)
      | handle.read(.overSampling)
    modify(.cr1, clear: 0x3000_960C, set: value)
    modify(.cr2, clear: 0x3000, set: handle.read(.stopBits))
    value = handle.read(.hardwareFlowControl)
    if !registers.instance.isLowPower { value |= handle.read(.oneBitSampling) }
    modify(.cr3, clear: 0xEE00_0B00, set: value)
    modify(.presc, clear: 0xF, set: handle.read(.clockPrescaler))

    let source = clocks.source(for: registers.instance)
    var status = HALStatus.ok
    let pclk: UInt32
    if registers.instance.isLowPower {
      switch source {
      case .pll2Q, .pll3Q, .pclk4, .hsi, .csi, .lse: pclk = clocks.frequency(source)
      default:
        pclk = 0
        status = .error
      }
      if pclk != 0 {
        let divided = pclk / Self.prescalerDivisor(handle.read(.clockPrescaler))
        if divided < 3 &* handle.read(.baudRate) || divided > 4096 &* handle.read(.baudRate) {
          status = .error
        } else {
          let divisor = UInt32(
            truncatingIfNeeded: ((UInt64(pclk)
              / UInt64(Self.prescalerDivisor(handle.read(.clockPrescaler)))) * 256
              + UInt64(handle.read(.baudRate) / 2)) / UInt64(handle.read(.baudRate)))
          if divisor >= 0x300 && divisor <= 0xFFFFF {
            registers.write(.brr, value: divisor)
          } else {
            status = .error
          }
        }
      }
    } else if handle.read(.overSampling) == 0x8000 {
      switch source {
      case .pclk1, .pclk2, .pll2Q, .pll3Q, .hsi, .csi, .lse: pclk = clocks.frequency(source)
      default:
        pclk = 0
        status = .error
      }
      if pclk != 0 {
        let divisor =
          ((pclk / Self.prescalerDivisor(handle.read(.clockPrescaler))) &* 2
            &+ (handle.read(.baudRate) / 2)) / handle.read(.baudRate)
        if divisor >= 0x10 && divisor <= 0xFFFF {
          var brr = UInt16(truncatingIfNeeded: divisor & 0xFFF0)
          brr |= UInt16(truncatingIfNeeded: (divisor & 0xF) >> 1)
          registers.write(.brr, value: UInt32(brr))
        } else {
          status = .error
        }
      }
    } else {
      switch source {
      case .pclk1, .pclk2, .pll2Q, .pll3Q, .hsi, .csi, .lse: pclk = clocks.frequency(source)
      default:
        pclk = 0
        status = .error
      }
      if pclk != 0 {
        let divisor =
          ((pclk / Self.prescalerDivisor(handle.read(.clockPrescaler)))
            &+ (handle.read(.baudRate) / 2)) / handle.read(.baudRate)
        if divisor >= 0x10 && divisor <= 0xFFFF {
          registers.write(.brr, value: UInt32(UInt16(truncatingIfNeeded: divisor)))
        } else {
          status = .error
        }
      }
    }
    handle.write(.txDataToProcess, value: 1)
    handle.write(.rxDataToProcess, value: 1)
    handle.write(.rxISR, value: 0)
    handle.write(.txISR, value: 0)
    return status
  }

  func configureAdvancedFeatures() {
    precondition(handle.read(.features) <= 0xFF)
    if handle.read(.features) & 8 == 8 {
      precondition(handle.read(.swap) == 0 || handle.read(.swap) == 0x8000)
      modify(.cr2, clear: 0x8000, set: handle.read(.swap))
    }
    if handle.read(.features) & 1 == 1 {
      precondition(handle.read(.txPinLevelInvert) == 0 || handle.read(.txPinLevelInvert) == 0x20000)
      modify(.cr2, clear: 0x20000, set: handle.read(.txPinLevelInvert))
    }
    if handle.read(.features) & 2 == 2 {
      precondition(handle.read(.rxPinLevelInvert) == 0 || handle.read(.rxPinLevelInvert) == 0x10000)
      modify(.cr2, clear: 0x10000, set: handle.read(.rxPinLevelInvert))
    }
    if handle.read(.features) & 4 == 4 {
      precondition(handle.read(.dataInvert) == 0 || handle.read(.dataInvert) == 0x40000)
      modify(.cr2, clear: 0x40000, set: handle.read(.dataInvert))
    }
    if handle.read(.features) & 0x10 == 0x10 {
      precondition(handle.read(.overrunDisable) == 0 || handle.read(.overrunDisable) == 0x1000)
      modify(.cr3, clear: 0x1000, set: handle.read(.overrunDisable))
    }
    if handle.read(.features) & 0x20 == 0x20 {
      precondition(
        handle.read(.dmaDisableOnReceiveError) == 0
          || handle.read(.dmaDisableOnReceiveError) == 0x2000)
      modify(.cr3, clear: 0x2000, set: handle.read(.dmaDisableOnReceiveError))
    }
    if handle.read(.features) & 0x40 == 0x40 {
      precondition(!registers.instance.isLowPower)
      precondition(
        handle.read(.autoBaudRateEnable) == 0 || handle.read(.autoBaudRateEnable) == 0x100000)
      modify(.cr2, clear: 0x100000, set: handle.read(.autoBaudRateEnable))
      if handle.read(.autoBaudRateEnable) == 0x100000 {
        precondition(handle.read(.autoBaudRateMode) & ~UInt32(0x600000) == 0)
        modify(.cr2, clear: 0x600000, set: handle.read(.autoBaudRateMode))
      }
    }
    if handle.read(.features) & 0x80 == 0x80 {
      precondition(
        handle.read(.mostSignificantBitFirst) == 0
          || handle.read(.mostSignificantBitFirst) == 0x80000)
      modify(.cr2, clear: 0x80000, set: handle.read(.mostSignificantBitFirst))
    }
  }

  func validateConfiguration() {
    precondition(handle.read(.baudRate) < 15_625_001)
    precondition(
      handle.read(.wordLength) == 0 || handle.read(.wordLength) == 0x1000
        || handle.read(.wordLength) == 0x1000_0000)
    if registers.instance.isLowPower {
      precondition(handle.read(.stopBits) == 0 || handle.read(.stopBits) == 0x2000)
    } else {
      precondition(handle.read(.stopBits) & ~UInt32(0x3000) == 0)
      precondition(handle.read(.oneBitSampling) == 0 || handle.read(.oneBitSampling) == 0x800)
    }
    precondition(
      handle.read(.parity) == 0 || handle.read(.parity) == 0x400 || handle.read(.parity) == 0x600)
    precondition(handle.read(.mode) & ~UInt32(0xC) == 0 && handle.read(.mode) != 0)
    precondition(handle.read(.hardwareFlowControl) & ~UInt32(0x300) == 0)
    precondition(handle.read(.overSampling) == 0 || handle.read(.overSampling) == 0x8000)
    precondition(handle.read(.clockPrescaler) <= 11)
  }

  static func prescalerDivisor(_ index: UInt32) -> UInt32 { serialPrescalerDivisor(index) }

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
  public func flushDataRegisters() {
    modify(.rqr, clear: 0, set: 8)
    modify(.rqr, clear: 0, set: 0x10)
  }
  public func enableOneBitSampling() { modify(.cr3, clear: 0, set: 0x800) }
  public func disableOneBitSampling() { modify(.cr3, clear: 0x800, set: 0) }
  public func enableCTS() {
    registers.atomicModify(.cr3, clear: 0, set: 0x200)
    handle.write(.hardwareFlowControl, value: handle.read(.hardwareFlowControl) | 0x200)
  }
  public func disableCTS() {
    registers.atomicModify(.cr3, clear: 0x200, set: 0)
    handle.write(.hardwareFlowControl, value: handle.read(.hardwareFlowControl) & ~UInt32(0x200))
  }
  public func enableRTS() {
    registers.atomicModify(.cr3, clear: 0, set: 0x100)
    handle.write(.hardwareFlowControl, value: handle.read(.hardwareFlowControl) | 0x100)
  }
  public func disableRTS() {
    registers.atomicModify(.cr3, clear: 0x100, set: 0)
    handle.write(.hardwareFlowControl, value: handle.read(.hardwareFlowControl) & ~UInt32(0x100))
  }
  public func enableInterrupt(_ interrupt: UInt32) {
    modify(Self.interruptRegister(interrupt), clear: 0, set: UInt32(1) << (interrupt & 0x1F))
  }
  public func disableInterrupt(_ interrupt: UInt32) {
    modify(Self.interruptRegister(interrupt), clear: UInt32(1) << (interrupt & 0x1F), set: 0)
  }
  public func getInterrupt(_ interrupt: UInt32) -> UInt32 {
    registers.read(.isr) & (UInt32(1) << (interrupt >> 8)) != 0 ? 1 : 0
  }
  public func getInterruptSource(_ interrupt: UInt32) -> UInt32 {
    registers.read(Self.interruptRegister(interrupt)) & (UInt32(1) << (interrupt & 0x1F)) != 0
      ? 1 : 0
  }
  static func interruptRegister(_ interrupt: UInt32) -> UARTRegister {
    let register = UInt8(truncatingIfNeeded: interrupt) >> 5
    return register == 1 ? .cr1 : (register == 2 ? .cr2 : .cr3)
  }
}
