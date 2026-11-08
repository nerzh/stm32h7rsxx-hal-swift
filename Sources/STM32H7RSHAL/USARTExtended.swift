// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART/USARTEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USART {
  @discardableResult
  public func enableFIFOMode() -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.state, value: 2)
    var cr1 = registers.read(.cr1)
    modify(.cr1, clear: 1, set: 0)
    cr1 |= 0x2000_0000
    handle.write(.fifoMode, value: 0x2000_0000)
    registers.write(.cr1, value: cr1)
    setNbDataToProcess()
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }

  @discardableResult
  public func disableFIFOMode() -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.state, value: 2)
    var cr1 = registers.read(.cr1)
    modify(.cr1, clear: 1, set: 0)
    cr1 &= ~UInt32(0x2000_0000)
    handle.write(.fifoMode, value: 0)
    registers.write(.cr1, value: cr1)
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }

  @discardableResult
  public func setTransmitFIFOThreshold(_ threshold: UInt32) -> HALStatus {
    precondition(threshold & ~UInt32(0xE000_0000) == 0 && threshold >> 29 <= 5)
    if !tryLock() { return .busy }
    handle.write(.state, value: 2)
    let cr1 = registers.read(.cr1)
    modify(.cr1, clear: 1, set: 0)
    modify(.cr3, clear: 0xE000_0000, set: threshold)
    setNbDataToProcess()
    registers.write(.cr1, value: cr1)
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }

  @discardableResult
  public func setReceiveFIFOThreshold(_ threshold: UInt32) -> HALStatus {
    precondition(threshold & ~UInt32(0x0E00_0000) == 0 && threshold >> 25 <= 5)
    if !tryLock() { return .busy }
    handle.write(.state, value: 2)
    let cr1 = registers.read(.cr1)
    modify(.cr1, clear: 1, set: 0)
    modify(.cr3, clear: 0x0E00_0000, set: threshold)
    setNbDataToProcess()
    registers.write(.cr1, value: cr1)
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }

  private func setNbDataToProcess() {
    if handle.read(.fifoMode) == 0 {
      handle.write(.txDataToProcess, value: 1)
      handle.write(.rxDataToProcess, value: 1)
    } else {
      let rxThreshold = (registers.read(.cr3) & 0x0E00_0000) >> 25
      let txThreshold = (registers.read(.cr3) & 0xE000_0000) >> 29
      let numerator: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (
        1, 1, 1, 3, 7, 1, 0, 0
      )
      let denominator: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (
        8, 4, 2, 4, 8, 1, 1, 1
      )
      func value(
        _ values: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8), _ index: UInt32
      ) -> UInt16 {
        switch index {
        case 0: return UInt16(values.0)
        case 1: return UInt16(values.1)
        case 2: return UInt16(values.2)
        case 3: return UInt16(values.3)
        case 4: return UInt16(values.4)
        case 5: return UInt16(values.5)
        case 6: return UInt16(values.6)
        default: return UInt16(values.7)
        }
      }
      handle.write(
        .txDataToProcess,
        value: (16 * value(numerator, txThreshold)) / value(denominator, txThreshold))
      handle.write(
        .rxDataToProcess,
        value: (16 * value(numerator, rxThreshold)) / value(denominator, rxThreshold))
    }
  }

}

extension USART {
  @discardableResult
  public func enableSlaveMode() -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.state, value: 2)
    let saved = registers.read(.cr1)
    disable()
    modify(.cr2, clear: 0x4800, set: 0)
    modify(.cr3, clear: 0x2A, set: 0)
    modify(.cr2, clear: 0, set: 1)
    registers.write(.cr1, value: saved)
    handle.write(.slaveMode, value: 1)
    handle.write(.state, value: 1)
    enable()
    unlock()
    return .ok
  }
  @discardableResult
  public func disableSlaveMode() -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.state, value: 2)
    let saved = registers.read(.cr1)
    disable()
    modify(.cr2, clear: 1, set: 0)
    registers.write(.cr1, value: saved)
    handle.write(.slaveMode, value: 0)
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }
  @discardableResult
  public func configureNSS(_ configuration: UInt32) -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.state, value: 2)
    let saved = registers.read(.cr1)
    disable()
    modify(.cr2, clear: 8, set: configuration)
    registers.write(.cr1, value: saved)
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }
}
