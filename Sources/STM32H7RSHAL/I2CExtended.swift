// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2C/I2CEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2C {
  public func configureAnalogFilter(_ filter: UInt32) -> HALStatus {
    if handle.read(.state) != 0x20 { return .busy }
    guard lock() else { return .busy }
    handle.write(.state, value: 0x24)
    disable()
    modify(.cr1, clear: 0x1000)
    modify(.cr1, set: filter)
    enable()
    handle.write(.state, value: 0x20)
    unlock()
    return .ok
  }
  public func configureDigitalFilter(_ filter: UInt32) -> HALStatus {
    if handle.read(.state) != 0x20 { return .busy }
    guard lock() else { return .busy }
    handle.write(.state, value: 0x24)
    disable()
    var value = registers.read(.cr1)
    value &= ~0xF00
    value |= filter << 8
    registers.write(.cr1, value: value)
    enable()
    handle.write(.state, value: 0x20)
    unlock()
    return .ok
  }
  public func enableWakeup() -> HALStatus {
    if handle.read(.state) != 0x20 { return .busy }
    guard lock() else { return .busy }
    handle.write(.state, value: 0x24)
    disable()
    modify(.cr1, set: 0x40000)
    enable()
    handle.write(.state, value: 0x20)
    unlock()
    return .ok
  }
  public func disableWakeup() -> HALStatus {
    if handle.read(.state) != 0x20 { return .busy }
    guard lock() else { return .busy }
    handle.write(.state, value: 0x24)
    disable()
    modify(.cr1, clear: 0x40000)
    enable()
    handle.write(.state, value: 0x20)
    unlock()
    return .ok
  }
  public func configureFastModePlus(_ state: UInt32) -> HALStatus {
    if handle.read(.state) != 0x20 { return .busy }
    guard lock() else { return .busy }
    handle.write(.state, value: 0x24)
    disable()
    if state == 0x0 { modify(.cr1, set: 0x1000000) } else { modify(.cr1, clear: 0x1000000) }
    enable()
    handle.write(.state, value: 0x20)
    unlock()
    return .ok
  }
}
