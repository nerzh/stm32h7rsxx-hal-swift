// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMARTCARD initialization from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMARTCARD {
  @discardableResult
  public func initialize<Clock: UARTClockIO>(clocks: Clock, getTick: () -> UInt32) -> HALStatus {
    initializeMSPIfReset()
    handle.write(.globalState, value: 0x24)
    disable()
    modify(.cr2, clear: 0x4000, set: 0)
    modify(.cr3, clear: 0xA, set: 0)
    modify(.cr3, clear: 0, set: 0x20)
    if setConfiguration(clocks: clocks) == .error { return .error }
    setTransmissionCompletion()
    if handle.read(.features) != 0 { configureAdvancedFeatures() }
    enable()
    return checkIdleState(getTick: getTick)
  }
  @discardableResult
  public func deinitialize() -> HALStatus {
    handle.write(.globalState, value: 0x24)
    disable()
    registers.write(.cr1, value: 0)
    registers.write(.cr2, value: 0)
    registers.write(.cr3, value: 0)
    registers.write(.rtor, value: 0)
    registers.write(.gtpr, value: 0)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invokeCallback(.mspDeinitialize)
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: 0)
    handle.write(.receiveState, value: 0)
    unlock()
    return .ok
  }
  @discardableResult
  public func setConfiguration<Clock: UARTClockIO>(clocks: Clock) -> HALStatus {
    var value = handle.read(.parity) | handle.read(.mode) | handle.read(.wordLength)
    modify(.cr1, clear: 0x3000_960C, set: value)
    value = handle.read(.oneBitSampling) | handle.read(.nackEnable)
    value |= handle.read(.autoRetryCount) << 17
    modify(.cr3, clear: 0xEE0E_0810, set: value)
    modify(.presc, clear: 15, set: handle.read(.clockPrescaler))
    value = handle.read(.prescaler) | (handle.read(.guardTime) << 8)
    modify(.gtpr, clear: 0xFFFF, set: UInt32(UInt16(truncatingIfNeeded: value)))
    value = handle.read(.stopBits)
    value |= 0x800 | handle.read(.clockPolarity)
    value |= handle.read(.clockPhase) | handle.read(.clockLastBit)
    value |= handle.read(.timeoutEnable)
    modify(.cr2, clear: 0x803F00, set: value)
    value = handle.read(.blockLength) << 24
    if handle.read(.timeoutEnable) == 0x800000 { value |= handle.read(.timeoutValue) }
    registers.write(.rtor, value: value)
    let source: UARTClockSource
    switch registers.instance {
    case .usart1, .usart2, .usart3: source = clocks.source(for: registers.instance)
    default: source = .undefined
    }
    var divider: UInt32 = 0
    var status = HALStatus.ok
    switch source {
    case .pclk1, .pclk2, .pll2Q, .pll3Q, .hsi, .csi, .lse:
      let frequency = clocks.frequency(source)
      let prescaler = handle.read(.clockPrescaler)
      precondition(prescaler < 12)
      let divided = frequency / serialPrescalerDivisor(prescaler)
      let narrowed = source == .lse ? UInt32(UInt16(truncatingIfNeeded: divided)) : divided
      divider = (narrowed &+ (handle.read(.baudRate) / 2)) / handle.read(.baudRate)
    default: status = .error
    }
    if divider >= 0x10 && divider <= 0xFFFF {
      registers.write(.brr, value: UInt32(UInt16(divider)))
    } else {
      status = .error
    }
    handle.write(.txDataToProcess, value: 1)
    handle.write(.rxDataToProcess, value: 1)
    handle.write(.rxISR, value: 0)
    handle.write(.txISR, value: 0)
    return status
  }
  public func setTransmissionCompletion() {
    if handle.read(.features) & 0x100 == 0 {
      handle.write(.transmitCompletionIndication, value: 0x626)
    } else {
      precondition(
        handle.read(.transmitCompletionIndication) == 0x626
          || handle.read(.transmitCompletionIndication) == 0x1978)
    }
  }
  public func transmissionCompletionFlag() -> UInt32 {
    handle.read(.transmitCompletionIndication) == 0x626 ? 0x40 : 0x2000000
  }
  public func configureAdvancedFeatures() {
    if handle.read(.features) & 1 == 1 {
      modify(.cr2, clear: 0x20000, set: handle.read(.txPinLevelInvert))
    }
    if handle.read(.features) & 2 == 2 {
      modify(.cr2, clear: 0x10000, set: handle.read(.rxPinLevelInvert))
    }
    if handle.read(.features) & 4 == 4 {
      modify(.cr2, clear: 0x40000, set: handle.read(.dataInvert))
    }
    if handle.read(.features) & 8 == 8 { modify(.cr2, clear: 0x8000, set: handle.read(.swap)) }
    if handle.read(.features) & 0x10 == 0x10 {
      modify(.cr3, clear: 0x1000, set: handle.read(.overrunDisable))
    }
    if handle.read(.features) & 0x20 == 0x20 {
      modify(.cr3, clear: 0x2000, set: handle.read(.dmaDisableOnReceiveError))
    }
    if handle.read(.features) & 0x80 == 0x80 {
      modify(.cr2, clear: 0x80000, set: handle.read(.mostSignificantBitFirst))
    }
  }
}
