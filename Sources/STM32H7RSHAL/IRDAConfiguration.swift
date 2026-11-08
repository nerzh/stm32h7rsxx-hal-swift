// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// IRDA initialization from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension IRDA {
  @discardableResult
  public func initialize<Clock: IRDAClockIO>(clocks: Clock, getTick: () -> UInt32) -> HALStatus {
    initializeMSPIfReset()
    handle.write(.globalState, value: 0x24)
    disable()
    if setConfiguration(clocks: clocks) == .error { return .error }
    modify(.cr2, clear: 0x7800, set: 0)
    modify(.cr3, clear: 0x28, set: 0)
    modify(.cr3, clear: 0, set: 2)
    enable()
    return checkIdleState(getTick: getTick)
  }
  @discardableResult
  public func deinitialize() -> HALStatus {
    handle.write(.globalState, value: 0x24)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invokeCallback(.mspDeinitialize)
    disable()
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: 0)
    handle.write(.receiveState, value: 0)
    unlock()
    return .ok
  }
  @discardableResult
  public func setConfiguration<Clock: IRDAClockIO>(clocks: Clock) -> HALStatus {
    let fields = handle.read(.wordLength) | handle.read(.parity) | handle.read(.mode)
    modify(.cr1, clear: 0x1000_160C, set: fields)
    modify(.cr3, clear: 4, set: handle.read(.powerMode))
    modify(.presc, clear: 15, set: handle.read(.clockPrescaler))
    modify(.gtpr, clear: 0xFF, set: handle.read(.prescaler))
    let source =
      registers.instance == .lpuart1
      ? UARTClockSource.undefined : clocks.source(for: registers.instance)
    var divider: UInt32 = 0
    var status = HALStatus.ok
    switch source {
    case .pclk1, .pclk2, .pll2Q, .pll3Q, .hsi, .csi, .lse:
      let frequency = source == .hsi ? clocks.unprescaledHSIFrequency() : clocks.frequency(source)
      let prescaler = handle.read(.clockPrescaler)
      precondition(prescaler < 12)
      divider =
        (frequency / serialPrescalerDivisor(prescaler) &+ (handle.read(.baudRate) / 2))
        / handle.read(.baudRate)
    default: status = .error
    }
    if divider >= 0x10 && divider <= 0xFFFF {
      registers.write(.brr, value: UInt32(UInt16(divider)))
    } else {
      status = .error
    }
    return status
  }
}
