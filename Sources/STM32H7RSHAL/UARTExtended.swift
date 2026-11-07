// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_uart_ex.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension UART {
  @discardableResult
  public func setAddressLength(_ length: UInt32, getTick: () -> UInt32) -> HALStatus {
    precondition(length == 0 || length == 0x10)
    handle.write(.globalState, value: UARTState.busy.rawValue)
    modify(.cr1, clear: 1, set: 0)
    modify(.cr2, clear: 0x10, set: length)
    modify(.cr1, clear: 0, set: 1)
    return checkIdleState(getTick: getTick)
  }

  @discardableResult
  public func configureStopModeWakeup(_ configuration: UARTWakeUpConfiguration,
                                     getTick: () -> UInt32) -> HALStatus {
    precondition(configuration.event == 0 || configuration.event == 0x0020_0000
                 || configuration.event == 0x0030_0000)
    if !tryLock() { return .busy }
    handle.write(.globalState, value: UARTState.busy.rawValue)
    modify(.cr1, clear: 1, set: 0)
    modify(.cr3, clear: 0x0030_0000, set: configuration.event)
    if configuration.event == 0 { configureWakeupAddress(configuration) }
    modify(.cr1, clear: 0, set: 1)
    let start = getTick()
    let status: HALStatus
    if waitOnFlagUntilTimeout(flag: 0x0040_0000, status: false, tickStart: start,
                              timeout: 0x01FF_FFFF, getTick: getTick) != .ok {
      status = .timeout
    } else {
      handle.write(.globalState, value: UARTState.ready.rawValue)
      status = .ok
    }
    unlock()
    return status
  }

  private func configureWakeupAddress(_ configuration: UARTWakeUpConfiguration) {
    precondition(configuration.addressLength == 0 || configuration.addressLength == 0x10)
    modify(.cr2, clear: 0x10, set: UInt32(configuration.addressLength))
    modify(.cr2, clear: 0xFF00_0000, set: UInt32(configuration.address) << 24)
  }

  @discardableResult
  public func enableStopMode() -> HALStatus {
    if !tryLock() { return .busy }
    registers.atomicModify(.cr1, clear: 0, set: 2)
    unlock()
    return .ok
  }

  @discardableResult
  public func disableStopMode() -> HALStatus {
    if !tryLock() { return .busy }
    registers.atomicModify(.cr1, clear: 2, set: 0)
    unlock()
    return .ok
  }

  @discardableResult
  public func enableFIFOMode() -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.globalState, value: UARTState.busy.rawValue)
    var cr1 = registers.read(.cr1)
    modify(.cr1, clear: 1, set: 0)
    cr1 |= 0x2000_0000
    handle.write(.fifoMode, value: 0x2000_0000)
    registers.write(.cr1, value: cr1)
    setNbDataToProcess()
    handle.write(.globalState, value: UARTState.ready.rawValue)
    unlock()
    return .ok
  }

  @discardableResult
  public func disableFIFOMode() -> HALStatus {
    if !tryLock() { return .busy }
    handle.write(.globalState, value: UARTState.busy.rawValue)
    var cr1 = registers.read(.cr1)
    modify(.cr1, clear: 1, set: 0)
    cr1 &= ~UInt32(0x2000_0000)
    handle.write(.fifoMode, value: 0)
    registers.write(.cr1, value: cr1)
    handle.write(.globalState, value: UARTState.ready.rawValue)
    unlock()
    return .ok
  }

  @discardableResult
  public func setTransmitFIFOThreshold(_ threshold: UInt32) -> HALStatus {
    precondition(threshold & ~UInt32(0xE000_0000) == 0 && threshold >> 29 <= 5)
    if !tryLock() { return .busy }
    handle.write(.globalState, value: UARTState.busy.rawValue)
    let cr1 = registers.read(.cr1)
    modify(.cr1, clear: 1, set: 0)
    modify(.cr3, clear: 0xE000_0000, set: threshold)
    setNbDataToProcess()
    registers.write(.cr1, value: cr1)
    handle.write(.globalState, value: UARTState.ready.rawValue)
    unlock()
    return .ok
  }

  @discardableResult
  public func setReceiveFIFOThreshold(_ threshold: UInt32) -> HALStatus {
    precondition(threshold & ~UInt32(0x0E00_0000) == 0 && threshold >> 25 <= 5)
    if !tryLock() { return .busy }
    handle.write(.globalState, value: UARTState.busy.rawValue)
    let cr1 = registers.read(.cr1)
    modify(.cr1, clear: 1, set: 0)
    modify(.cr3, clear: 0x0E00_0000, set: threshold)
    setNbDataToProcess()
    registers.write(.cr1, value: cr1)
    handle.write(.globalState, value: UARTState.ready.rawValue)
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
      let numerator: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (1, 1, 1, 3, 7, 1, 0, 0)
      let denominator: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (8, 4, 2, 4, 8, 1, 1, 1)
      func value(_ values: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8), _ index: UInt32) -> UInt16 {
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
      handle.write(.txDataToProcess, value: (16 * value(numerator, txThreshold)) / value(denominator, txThreshold))
      handle.write(.rxDataToProcess, value: (16 * value(numerator, rxThreshold)) / value(denominator, rxThreshold))
    }
  }

  @discardableResult
  public func receiveToIdle(_ data: UnsafeMutableRawPointer?, size: UInt16,
                            receivedCount: UnsafeMutablePointer<UInt16>, timeout: UInt32,
                            getTick: () -> UInt32) -> HALStatus {
    if handle.read(.receiveState) != UARTState.ready.rawValue { return .busy }
    guard var data, size != 0 else { return .error }
    handle.write(.errorCode, value: 0)
    handle.write(.receiveState, value: UARTState.busyReceive.rawValue)
    handle.write(.receptionType, value: UARTReceptionType.toIdle.rawValue)
    handle.write(.rxEventType, value: UARTRxEventType.complete.rawValue)
    let start = getTick()
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    computeMask()
    let mask = handle.read(.mask)
    let halfWord = handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0
    receivedCount.pointee = 0
    while handle.read(.receiveCount) > 0 {
      if getFlag(0x10) != 0 {
        clearFlag(0x10)
        if receivedCount.pointee > 0 {
          handle.write(.rxEventType, value: UARTRxEventType.idle.rawValue)
          handle.write(.receiveState, value: UARTState.ready.rawValue)
          return .ok
        }
      }
      if getFlag(0x20) != 0 {
        if halfWord {
          data.storeBytes(of: UInt16(truncatingIfNeeded: registers.read(.rdr) & UInt32(mask)), as: UInt16.self)
          data = data.advanced(by: 2)
        } else {
          data.storeBytes(of: UInt8(truncatingIfNeeded: registers.read(.rdr) & UInt32(UInt8(truncatingIfNeeded: mask))), as: UInt8.self)
          data = data.advanced(by: 1)
        }
        receivedCount.pointee &+= 1
        handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
      }
      if timeout != UInt32.max {
        if (getTick() &- start) > timeout || timeout == 0 {
          handle.write(.receiveState, value: UARTState.ready.rawValue)
          return .timeout
        }
      }
    }
    receivedCount.pointee = handle.read(.receiveSize) &- handle.read(.receiveCount)
    handle.write(.receiveState, value: UARTState.ready.rawValue)
    return .ok
  }

  @discardableResult
  public func receiveToIdleInterrupt(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.receiveState) != UARTState.ready.rawValue { return .busy }
    guard data != nil, size != 0 else { return .error }
    handle.write(.receptionType, value: UARTReceptionType.toIdle.rawValue)
    handle.write(.rxEventType, value: UARTRxEventType.complete.rawValue)
    _ = startReceiveInterrupt(data, size: size)
    if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
      clearFlag(0x10)
      registers.atomicModify(.cr1, clear: 0, set: 0x10)
      return .ok
    } else {
      return .error
    }
  }

  public func getRxEventType() -> UInt32 { handle.read(.rxEventType) }
}
