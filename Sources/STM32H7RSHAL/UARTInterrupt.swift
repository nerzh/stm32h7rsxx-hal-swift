// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Port of stm32h7rsxx_hal_uart.c at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension UART {
  @discardableResult
  public func transmitInterrupt(_ data: UnsafeRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.globalState) != UARTState.ready.rawValue { return .busy }
    guard let data, size != 0 else { return .error }
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: data))
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    handle.write(.txISR, value: UARTISR.none.rawValue)
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: UARTState.busyTransmit.rawValue)
    if handle.read(.fifoMode) == 0x2000_0000 {
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
        handle.write(.txISR, value: UARTISR.halfWordFIFO.rawValue)
      } else {
        handle.write(.txISR, value: UARTISR.byteFIFO.rawValue)
      }
      registers.atomicModify(.cr3, clear: 0, set: 0x0080_0000)
    } else {
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
        handle.write(.txISR, value: UARTISR.halfWord.rawValue)
      } else {
        handle.write(.txISR, value: UARTISR.byte.rawValue)
      }
      registers.atomicModify(.cr1, clear: 0, set: 0x80)
    }
    return .ok
  }

  @discardableResult
  public func receiveInterrupt(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.receiveState) != UARTState.ready.rawValue { return .busy }
    guard data != nil, size != 0 else { return .error }
    handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
    if !registers.instance.isLowPower && registers.read(.cr2) & 0x0080_0000 != 0 {
      registers.atomicModify(.cr1, clear: 0, set: 0x0400_0000)
    }
    return startReceiveInterrupt(data, size: size)
  }

  @discardableResult
  internal func startReceiveInterrupt(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    handle.writePointer(.receive, value: data)
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    handle.write(.rxISR, value: UARTISR.none.rawValue)
    computeMask()
    handle.write(.errorCode, value: 0)
    handle.write(.receiveState, value: UARTState.busyReceive.rawValue)
    registers.atomicModify(.cr3, clear: 0, set: 1)
    if handle.read(.fifoMode) == 0x2000_0000 && size >= handle.read(.rxDataToProcess) {
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
        handle.write(.rxISR, value: UARTISR.halfWordFIFO.rawValue)
      } else {
        handle.write(.rxISR, value: UARTISR.byteFIFO.rawValue)
      }
      if handle.read(.parity) != 0 { registers.atomicModify(.cr1, clear: 0, set: 0x100) }
      registers.atomicModify(.cr3, clear: 0, set: 0x1000_0000)
    } else {
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
        handle.write(.rxISR, value: UARTISR.halfWord.rawValue)
      } else {
        handle.write(.rxISR, value: UARTISR.byte.rawValue)
      }
      if handle.read(.parity) != 0 {
        registers.atomicModify(.cr1, clear: 0, set: 0x120)
      } else {
        registers.atomicModify(.cr1, clear: 0, set: 0x20)
      }
    }
    return .ok
  }

  internal func endReceiveTransfer() {
    registers.atomicModify(.cr1, clear: 0x120, set: 0)
    registers.atomicModify(.cr3, clear: 0x1000_0001, set: 0)
    if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
      registers.atomicModify(.cr1, clear: 0x10, set: 0)
    }
    handle.write(.receiveState, value: UARTState.ready.rawValue)
    handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
    handle.write(.rxISR, value: UARTISR.none.rawValue)
  }

  public func handleInterrupt(getTick: () -> UInt32) {
    let flags = registers.read(.isr)
    let cr1 = registers.read(.cr1)
    let cr3 = registers.read(.cr3)
    let errors = flags & 0x80F
    if errors == 0 {
      if flags & 0x20 != 0 && (cr1 & 0x20 != 0 || cr3 & 0x1000_0000 != 0) {
        if handle.read(.rxISR) != UARTISR.none.rawValue { invokeReceiveISR() }
        return
      }
    }
    if errors != 0 && (cr3 & 0x1000_0001 != 0 || cr1 & 0x0400_0120 != 0) {
      if flags & 1 != 0 && cr1 & 0x100 != 0 {
        clearFlag(1)
        handle.write(.errorCode, value: handle.read(.errorCode) | 1)
      }
      if flags & 2 != 0 && cr3 & 1 != 0 {
        clearFlag(2)
        handle.write(.errorCode, value: handle.read(.errorCode) | 4)
      }
      if flags & 4 != 0 && cr3 & 1 != 0 {
        clearFlag(4)
        handle.write(.errorCode, value: handle.read(.errorCode) | 2)
      }
      if flags & 8 != 0 && (cr1 & 0x20 != 0 || cr3 & 0x1000_0001 != 0) {
        clearFlag(8)
        handle.write(.errorCode, value: handle.read(.errorCode) | 8)
      }
      if flags & 0x800 != 0 && cr1 & 0x0400_0000 != 0 {
        clearFlag(0x800)
        handle.write(.errorCode, value: handle.read(.errorCode) | 0x20)
      }
      if handle.read(.errorCode) != 0 {
        if flags & 0x20 != 0 && (cr1 & 0x20 != 0 || cr3 & 0x1000_0000 != 0) {
          if handle.read(.rxISR) != UARTISR.none.rawValue { invokeReceiveISR() }
        }
        let errorCode = handle.read(.errorCode)
        if registers.read(.cr3) & 0x40 != 0 || errorCode & 0x28 != 0 {
          endReceiveTransfer()
          if registers.read(.cr3) & 0x40 != 0 {
            registers.atomicModify(.cr3, clear: 0x40, set: 0)
            if dma.isPresent(.receive) {
              dma.writeCallback(.receive, id: .abort, value: dma.callback(.abortOnError))
              if dma.abortInterrupt(.receive) != .ok { dma.invokeCallback(.receive, id: .abort) }
            } else {
              invokeCallback(.error)
            }
          } else {
            invokeCallback(.error)
          }
        } else {
          invokeCallback(.error)
          handle.write(.errorCode, value: 0)
        }
      }
      return
    }
    if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue
      && flags & 0x10 != 0 && cr1 & 0x10 != 0 {
      clearFlag(0x10)
      if registers.read(.cr3) & 0x40 != 0 {
        let remaining = UInt16(truncatingIfNeeded: dma.getCounter(.receive))
        if remaining > 0 && remaining < handle.read(.receiveSize) {
          handle.write(.receiveCount, value: remaining)
          if dma.read(.receive, word: .mode) != 0x81 {
            registers.atomicModify(.cr1, clear: 0x100, set: 0)
            registers.atomicModify(.cr3, clear: 1, set: 0)
            registers.atomicModify(.cr3, clear: 0x40, set: 0)
            handle.write(.receiveState, value: UARTState.ready.rawValue)
            handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
            registers.atomicModify(.cr1, clear: 0x10, set: 0)
            _ = dma.abort(.receive, getTick: getTick)
          }
          handle.write(.rxEventType, value: UARTRxEventType.idle.rawValue)
          invokeRxEvent(handle.read(.receiveSize) &- handle.read(.receiveCount))
        } else if remaining == handle.read(.receiveSize) {
          if dma.read(.receive, word: .mode) == 0x81 {
            handle.write(.rxEventType, value: UARTRxEventType.idle.rawValue)
            invokeRxEvent(handle.read(.receiveSize))
          }
        }
        return
      } else {
        let received = handle.read(.receiveSize) &- handle.read(.receiveCount)
        if handle.read(.receiveCount) > 0 && received > 0 {
          registers.atomicModify(.cr1, clear: 0x120, set: 0)
          registers.atomicModify(.cr3, clear: 0x1000_0001, set: 0)
          handle.write(.receiveState, value: UARTState.ready.rawValue)
          handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
          handle.write(.rxISR, value: UARTISR.none.rawValue)
          registers.atomicModify(.cr1, clear: 0x10, set: 0)
          handle.write(.rxEventType, value: UARTRxEventType.idle.rawValue)
          invokeRxEvent(received)
        }
        return
      }
    }
    if flags & 0x0010_0000 != 0 && cr3 & 0x0040_0000 != 0 {
      clearFlag(0x0010_0000)
      invokeCallback(.wakeup)
      return
    }
    if flags & 0x80 != 0 && (cr1 & 0x80 != 0 || cr3 & 0x0080_0000 != 0) {
      if handle.read(.txISR) != UARTISR.none.rawValue { invokeTransmitISR() }
      return
    }
    if flags & 0x40 != 0 && cr1 & 0x40 != 0 {
      endTransmitInterrupt()
      return
    }
    if flags & 0x0080_0000 != 0 && cr1 & 0x4000_0000 != 0 {
      invokeCallback(.transmitFIFOEmpty)
      return
    }
    if flags & 0x0100_0000 != 0 && cr1 & 0x8000_0000 != 0 {
      invokeCallback(.receiveFIFOFull)
    }
  }

  internal func invokeTransmitISR() {
    switch UARTISR(rawValue: handle.read(.txISR)) {
    case .some(.none): break
    case .some(.byte): transmitISR(halfWord: false, fifo: false)
    case .some(.halfWord): transmitISR(halfWord: true, fifo: false)
    case .some(.byteFIFO): transmitISR(halfWord: false, fifo: true)
    case .some(.halfWordFIFO): transmitISR(halfWord: true, fifo: true)
    case nil: preconditionFailure("Invalid UART transmit ISR selector")
    }
  }

  private func transmitISR(halfWord: Bool, fifo: Bool) {
    if handle.read(.globalState) != UARTState.busyTransmit.rawValue { return }
    if fifo {
      var remaining = handle.read(.txDataToProcess)
      while remaining > 0 {
        if handle.read(.transmitCount) == 0 {
          registers.atomicModify(.cr3, clear: 0x0080_0000, set: 0)
          registers.atomicModify(.cr1, clear: 0, set: 0x40)
          break
        } else if registers.read(.isr) & 0x80 != 0 {
          transmitData(halfWord: halfWord)
        }
        remaining &-= 1
      }
    } else {
      if handle.read(.transmitCount) == 0 {
        registers.atomicModify(.cr1, clear: 0x80, set: 0)
        registers.atomicModify(.cr1, clear: 0, set: 0x40)
      } else {
        transmitData(halfWord: halfWord)
      }
    }
  }

  private func transmitData(halfWord: Bool) {
    if halfWord {
      let data = handle.readPointer(.transmit)!.load(as: UInt16.self)
      registers.write(.tdr, value: UInt32(data) & 0x1FF)
      handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
    } else {
      let data = handle.readPointer(.transmit)!.load(as: UInt8.self)
      registers.write(.tdr, value: UInt32(data & 0xFF))
      handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 1))
    }
    handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
  }

  private func endTransmitInterrupt() {
    registers.atomicModify(.cr1, clear: 0x40, set: 0)
    handle.write(.globalState, value: UARTState.ready.rawValue)
    handle.write(.txISR, value: UARTISR.none.rawValue)
    invokeCallback(.transmitComplete)
  }

  internal func invokeReceiveISR() {
    switch UARTISR(rawValue: handle.read(.rxISR)) {
    case .some(.none): break
    case .some(.byte): receiveISR(halfWord: false)
    case .some(.halfWord): receiveISR(halfWord: true)
    case .some(.byteFIFO): receiveFIFOISR(halfWord: false)
    case .some(.halfWordFIFO): receiveFIFOISR(halfWord: true)
    case nil: preconditionFailure("Invalid UART receive ISR selector")
    }
  }

  private func receiveISR(halfWord: Bool) {
    let mask = handle.read(.mask)
    if handle.read(.receiveState) == UARTState.busyReceive.rawValue {
      receiveData(halfWord: halfWord, mask: mask)
      if handle.read(.receiveCount) == 0 {
        registers.atomicModify(.cr1, clear: 0x120, set: 0)
        registers.atomicModify(.cr3, clear: 1, set: 0)
        finishReceiveInterrupt()
      }
    } else {
      sendRequest(8)
    }
  }

  private func receiveData(halfWord: Bool, mask: UInt16) {
    let data = UInt16(truncatingIfNeeded: registers.read(.rdr))
    if halfWord {
      handle.readPointer(.receive)!.storeBytes(of: data & mask, as: UInt16.self)
      handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
    } else {
      let byte = UInt8(truncatingIfNeeded: data & UInt16(UInt8(truncatingIfNeeded: mask)))
      handle.readPointer(.receive)!.storeBytes(of: byte, as: UInt8.self)
      handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
    }
    handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
  }

  private func finishReceiveInterrupt() {
    handle.write(.receiveState, value: UARTState.ready.rawValue)
    handle.write(.rxISR, value: UARTISR.none.rawValue)
    handle.write(.rxEventType, value: UARTRxEventType.complete.rawValue)
    if !registers.instance.isLowPower && registers.read(.cr2) & 0x0080_0000 != 0 {
      registers.atomicModify(.cr1, clear: 0x0400_0000, set: 0)
    }
    if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
      handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
      registers.atomicModify(.cr1, clear: 0x10, set: 0)
      if getFlag(0x10) == 1 { clearFlag(0x10) }
      invokeRxEvent(handle.read(.receiveSize))
    } else {
      invokeCallback(.receiveComplete)
    }
  }

  private func receiveFIFOISR(halfWord: Bool) {
    let mask = handle.read(.mask)
    var flags = registers.read(.isr)
    let cr1 = registers.read(.cr1)
    let cr3 = registers.read(.cr3)
    if handle.read(.receiveState) == UARTState.busyReceive.rawValue {
      let remaining = handle.read(.rxDataToProcess)
      // The original C never decrements nb_rx_data inside this loop.
      while remaining > 0 && flags & 0x20 != 0 {
        receiveData(halfWord: halfWord, mask: mask)
        flags = registers.read(.isr)
        if flags & 7 != 0 {
          if flags & 1 != 0 && cr1 & 0x100 != 0 {
            clearFlag(1)
            handle.write(.errorCode, value: handle.read(.errorCode) | 1)
          }
          if flags & 2 != 0 && cr3 & 1 != 0 {
            clearFlag(2)
            handle.write(.errorCode, value: handle.read(.errorCode) | 4)
          }
          if flags & 4 != 0 && cr3 & 1 != 0 {
            clearFlag(4)
            handle.write(.errorCode, value: handle.read(.errorCode) | 2)
          }
          if handle.read(.errorCode) != 0 {
            invokeCallback(.error)
            handle.write(.errorCode, value: 0)
          }
        }
        if handle.read(.receiveCount) == 0 {
          registers.atomicModify(.cr1, clear: 0x100, set: 0)
          registers.atomicModify(.cr3, clear: 0x1000_0001, set: 0)
          finishReceiveInterrupt()
          break
        }
      }
      let count = handle.read(.receiveCount)
      if count != 0 && count < handle.read(.rxDataToProcess) {
        registers.atomicModify(.cr3, clear: 0x1000_0000, set: 0)
        handle.write(.rxISR, value: halfWord ? UARTISR.halfWord.rawValue : UARTISR.byte.rawValue)
        registers.atomicModify(.cr1, clear: 0, set: 0x20)
      }
    } else {
      sendRequest(8)
    }
  }
}
