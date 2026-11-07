// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DMA transfers and abort paths from stm32h7rsxx_hal_uart.c and uart_ex.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension UART {
  @discardableResult
  public func transmitDMA(_ data: UnsafeRawPointer?, size: UInt16) -> HALStatus {
    var byteCount = size
    guard handle.read(.globalState) == UARTState.ready.rawValue else { return .busy }
    guard let data, size != 0 else { return .error }

    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: data))
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: UARTState.busyTransmit.rawValue)

    if dma.isPresent(.transmit) {
      dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.transmitComplete))
      dma.writeCallback(.transmit, id: .halfTransfer, value: dma.callback(.transmitHalfComplete))
      dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))
      dma.writeCallback(.transmit, id: .abort, value: nil)
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
        byteCount = size &* 2
      }

      let status: HALStatus
      if dma.read(.transmit, word: .mode) & 0x80 == 0x80 {
        if dma.read(.transmit, word: .queueAddress) != 0
          && dma.readMemory32(.transmit, at: dma.read(.transmit, word: .queueAddress)) != 0
        {
          dma.writeMemory32(.transmit, at: dmaHead(.transmit) &+ 8, value: UInt32(byteCount))
          dma.writeMemory32(.transmit, at: dmaHead(.transmit) &+ 12,
                            value: busAddress(handle.readPointer(.transmit)))
          dma.writeMemory32(.transmit, at: dmaHead(.transmit) &+ 16,
                            value: registers.instance.rawValue &+ 0x28)
          status = dma.startLinkedListInterrupt(.transmit)
        } else {
          status = .error
        }
      } else {
        status = dma.startInterrupt(.transmit,
          sourceAddress: busAddress(handle.readPointer(.transmit)),
          destinationAddress: registers.instance.rawValue &+ 0x28, sourceDataSize: UInt32(byteCount))
      }
      if status != .ok {
        handle.write(.errorCode, value: UARTError.dma.rawValue)
        handle.write(.globalState, value: UARTState.ready.rawValue)
        return .error
      }
    }
    clearFlag(0x40)
    registers.atomicModify(.cr3, clear: 0, set: 0x80)
    return .ok
  }

  @discardableResult
  public func receiveDMA(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    guard handle.read(.receiveState) == UARTState.ready.rawValue else { return .busy }
    guard let data, size != 0 else { return .error }
    handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
    if !registers.instance.isLowPower && registers.read(.cr2) & 0x0080_0000 != 0 {
      registers.atomicModify(.cr1, clear: 0, set: 0x0400_0000)
    }
    return startReceiveDMA(data, size: size)
  }

  @discardableResult
  public func pauseDMA(getTick: () -> UInt32) -> HALStatus {
    let globalState = handle.read(.globalState)
    let receiveState = handle.read(.receiveState)
    if registers.read(.cr3) & 0x80 != 0 && globalState == UARTState.busyTransmit.rawValue {
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .suspend, value: nil)
        if dma.suspend(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: UARTError.dma.rawValue)
            return .timeout
          }
        }
      }
    }
    if registers.read(.cr3) & 0x40 != 0 && receiveState == UARTState.busyReceive.rawValue {
      if dma.isPresent(.receive) {
        registers.atomicModify(.cr1, clear: 0x100, set: 0)
        registers.atomicModify(.cr3, clear: 1, set: 0)
        dma.writeCallback(.receive, id: .suspend, value: nil)
        if dma.suspend(.receive, getTick: getTick) != .ok {
          if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: UARTError.dma.rawValue)
            return .timeout
          }
        }
      }
    }
    return .ok
  }

  @discardableResult
  public func resumeDMA() -> HALStatus {
    if handle.read(.globalState) == UARTState.busyTransmit.rawValue {
      if dma.isPresent(.transmit) {
        if dma.resume(.transmit) != .ok {
          handle.write(.errorCode, value: UARTError.dma.rawValue)
          return .error
        }
      }
    }
    if handle.read(.receiveState) == UARTState.busyReceive.rawValue {
      clearFlag(8)
      if handle.read(.parity) != 0 { registers.atomicModify(.cr1, clear: 0, set: 0x100) }
      registers.atomicModify(.cr3, clear: 0, set: 1)
      if dma.isPresent(.receive) {
        if dma.resume(.receive) != .ok {
          handle.write(.errorCode, value: UARTError.dma.rawValue)
          return .error
        }
      }
    }
    return .ok
  }

  @discardableResult
  public func stopDMA(getTick: () -> UInt32) -> HALStatus {
    let globalState = handle.read(.globalState)
    let receiveState = handle.read(.receiveState)
    if registers.read(.cr3) & 0x80 != 0 && globalState == UARTState.busyTransmit.rawValue {
      registers.atomicModify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        if dma.abort(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: UARTError.dma.rawValue)
            return .timeout
          }
        }
      }
      endTransmitTransfer()
    }
    if registers.read(.cr3) & 0x40 != 0 && receiveState == UARTState.busyReceive.rawValue {
      registers.atomicModify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        if dma.abort(.receive, getTick: getTick) != .ok {
          if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: UARTError.dma.rawValue)
            return .timeout
          }
        }
      }
      endReceiveTransfer()
    }
    return .ok
  }

  @discardableResult
  public func abort(getTick: () -> UInt32) -> HALStatus {
    registers.atomicModify(.cr1, clear: 0x1E0, set: 0)
    registers.atomicModify(.cr3, clear: 0x1080_0001, set: 0)
    if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
      registers.atomicModify(.cr1, clear: 0x10, set: 0)
    }
    if registers.read(.cr3) & 0x80 != 0 {
      registers.atomicModify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .abort, value: nil)
        if dma.abort(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: UARTError.dma.rawValue)
            return .timeout
          }
        }
      }
    }
    if registers.read(.cr3) & 0x40 != 0 {
      registers.atomicModify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        dma.writeCallback(.receive, id: .abort, value: nil)
        if dma.abort(.receive, getTick: getTick) != .ok {
          if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: UARTError.dma.rawValue)
            return .timeout
          }
        }
      }
    }
    clearFlag(0xF)
    if handle.read(.fifoMode) == 0x2000_0000 { sendRequest(0x10) }
    sendRequest(8)
    handle.write(.globalState, value: UARTState.ready.rawValue)
    handle.write(.receiveState, value: UARTState.ready.rawValue)
    handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
    handle.write(.errorCode, value: 0)
    return .ok
  }

  @discardableResult
  public func abortTransmit(getTick: () -> UInt32) -> HALStatus {
    registers.atomicModify(.cr1, clear: 0xC0, set: 0)
    registers.atomicModify(.cr3, clear: 0x0080_0000, set: 0)
    if registers.read(.cr3) & 0x80 != 0 {
      registers.atomicModify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .abort, value: nil)
        if dma.abort(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: UARTError.dma.rawValue)
            return .timeout
          }
        }
      }
    }
    if handle.read(.fifoMode) == 0x2000_0000 { sendRequest(0x10) }
    handle.write(.globalState, value: UARTState.ready.rawValue)
    return .ok
  }

  @discardableResult
  public func abortReceive(getTick: () -> UInt32) -> HALStatus {
    registers.atomicModify(.cr1, clear: 0x120, set: 0)
    registers.atomicModify(.cr3, clear: 0x1000_0001, set: 0)
    if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
      registers.atomicModify(.cr1, clear: 0x10, set: 0)
    }
    if registers.read(.cr3) & 0x40 != 0 {
      registers.atomicModify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        dma.writeCallback(.receive, id: .abort, value: nil)
        if dma.abort(.receive, getTick: getTick) != .ok {
          if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: UARTError.dma.rawValue)
            return .timeout
          }
        }
      }
    }
    clearFlag(0xF)
    sendRequest(8)
    handle.write(.receiveState, value: UARTState.ready.rawValue)
    handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
    return .ok
  }

  @discardableResult
  public func abortInterrupt() -> HALStatus {
    var abortComplete = true
    registers.atomicModify(.cr1, clear: 0x1E0, set: 0)
    registers.atomicModify(.cr3, clear: 0x1080_0001, set: 0)
    if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
      registers.atomicModify(.cr1, clear: 0x10, set: 0)
    }
    // Both callbacks must be installed before either DMA abort may complete.
    if dma.isPresent(.transmit) {
      if registers.read(.cr3) & 0x80 != 0 {
        dma.writeCallback(.transmit, id: .abort, value: dma.callback(.transmitAbort))
      } else {
        dma.writeCallback(.transmit, id: .abort, value: nil)
      }
    }
    if dma.isPresent(.receive) {
      if registers.read(.cr3) & 0x40 != 0 {
        dma.writeCallback(.receive, id: .abort, value: dma.callback(.receiveAbort))
      } else {
        dma.writeCallback(.receive, id: .abort, value: nil)
      }
    }
    if registers.read(.cr3) & 0x80 != 0 {
      registers.atomicModify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        if dma.abortInterrupt(.transmit) != .ok {
          dma.writeCallback(.transmit, id: .abort, value: nil)
        } else {
          abortComplete = false
        }
      }
    }
    if registers.read(.cr3) & 0x40 != 0 {
      registers.atomicModify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        if dma.abortInterrupt(.receive) != .ok {
          dma.writeCallback(.receive, id: .abort, value: nil)
          abortComplete = true
        } else {
          abortComplete = false
        }
      }
    }
    if abortComplete {
      handle.write(.rxISR, value: UARTISR.none.rawValue)
      handle.write(.txISR, value: UARTISR.none.rawValue)
      handle.write(.errorCode, value: 0)
      clearFlag(0xF)
      if handle.read(.fifoMode) == 0x2000_0000 { sendRequest(0x10) }
      sendRequest(8)
      handle.write(.globalState, value: UARTState.ready.rawValue)
      handle.write(.receiveState, value: UARTState.ready.rawValue)
      handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
      invokeCallback(.abortComplete)
    }
    return .ok
  }

  @discardableResult
  public func abortTransmitInterrupt() -> HALStatus {
    registers.atomicModify(.cr1, clear: 0xC0, set: 0)
    registers.atomicModify(.cr3, clear: 0x0080_0000, set: 0)
    if registers.read(.cr3) & 0x80 != 0 {
      registers.atomicModify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .abort, value: dma.callback(.transmitOnlyAbort))
        if dma.abortInterrupt(.transmit) != .ok { dma.invokeCallback(.transmit, id: .abort) }
      } else {
        handle.write(.txISR, value: UARTISR.none.rawValue)
        handle.write(.globalState, value: UARTState.ready.rawValue)
        invokeCallback(.abortTransmitComplete)
      }
    } else {
      handle.write(.txISR, value: UARTISR.none.rawValue)
      if handle.read(.fifoMode) == 0x2000_0000 { sendRequest(0x10) }
      handle.write(.globalState, value: UARTState.ready.rawValue)
      invokeCallback(.abortTransmitComplete)
    }
    return .ok
  }

  @discardableResult
  public func abortReceiveInterrupt() -> HALStatus {
    registers.atomicModify(.cr1, clear: 0x120, set: 0)
    registers.atomicModify(.cr3, clear: 0x1000_0001, set: 0)
    if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
      registers.atomicModify(.cr1, clear: 0x10, set: 0)
    }
    if registers.read(.cr3) & 0x40 != 0 {
      registers.atomicModify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        dma.writeCallback(.receive, id: .abort, value: dma.callback(.receiveOnlyAbort))
        if dma.abortInterrupt(.receive) != .ok { dma.invokeCallback(.receive, id: .abort) }
      } else {
        // The pinned C source clears pRxBuffPtr here, despite its RxISR comment.
        handle.writePointer(.receive, value: nil)
        clearFlag(0xF)
        sendRequest(8)
        handle.write(.receiveState, value: UARTState.ready.rawValue)
        handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
        invokeCallback(.abortReceiveComplete)
      }
    } else {
      handle.writePointer(.receive, value: nil)
      clearFlag(0xF)
      handle.write(.receiveState, value: UARTState.ready.rawValue)
      handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
      invokeCallback(.abortReceiveComplete)
    }
    return .ok
  }

  @discardableResult
  public func receiveToIdleDMA(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    guard handle.read(.receiveState) == UARTState.ready.rawValue else { return .busy }
    guard let data, size != 0 else { return .error }
    handle.write(.receptionType, value: UARTReceptionType.toIdle.rawValue)
    handle.write(.rxEventType, value: UARTRxEventType.complete.rawValue)
    var status = startReceiveDMA(data, size: size)
    if status == .ok {
      if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
        clearFlag(0x10)
        registers.atomicModify(.cr1, clear: 0, set: 0x10)
      } else {
        status = .error
      }
    }
    return status
  }

  func startReceiveDMA(_ data: UnsafeMutableRawPointer, size: UInt16) -> HALStatus {
    var byteCount = size
    handle.writePointer(.receive, value: data)
    handle.write(.receiveSize, value: size)
    handle.write(.errorCode, value: 0)
    handle.write(.receiveState, value: UARTState.busyReceive.rawValue)
    if dma.isPresent(.receive) {
      dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.receiveComplete))
      dma.writeCallback(.receive, id: .halfTransfer, value: dma.callback(.receiveHalfComplete))
      dma.writeCallback(.receive, id: .error, value: dma.callback(.error))
      dma.writeCallback(.receive, id: .abort, value: nil)
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 { byteCount = size &* 2 }
      let status: HALStatus
      if dma.read(.receive, word: .mode) & 0x80 == 0x80 {
        if dma.read(.receive, word: .queueAddress) != 0
          && dma.readMemory32(.receive, at: dma.read(.receive, word: .queueAddress)) != 0
        {
          dma.writeMemory32(.receive, at: dmaHead(.receive) &+ 8, value: UInt32(byteCount))
          dma.writeMemory32(.receive, at: dmaHead(.receive) &+ 12,
                            value: registers.instance.rawValue &+ 0x24)
          dma.writeMemory32(.receive, at: dmaHead(.receive) &+ 16,
                            value: busAddress(handle.readPointer(.receive)))
          status = dma.startLinkedListInterrupt(.receive)
        } else {
          status = .error
        }
      } else {
        status = dma.startInterrupt(.receive, sourceAddress: registers.instance.rawValue &+ 0x24,
          destinationAddress: busAddress(handle.readPointer(.receive)), sourceDataSize: UInt32(byteCount))
      }
      if status != .ok {
        handle.write(.errorCode, value: UARTError.dma.rawValue)
        handle.write(.receiveState, value: UARTState.ready.rawValue)
        return .error
      }
    }
    if handle.read(.parity) != 0 { registers.atomicModify(.cr1, clear: 0, set: 0x100) }
    registers.atomicModify(.cr3, clear: 0, set: 1)
    registers.atomicModify(.cr3, clear: 0, set: 0x40)
    return .ok
  }

  func endTransmitTransfer() {
    registers.atomicModify(.cr1, clear: 0xC0, set: 0)
    registers.atomicModify(.cr3, clear: 0x0080_0000, set: 0)
    handle.write(.globalState, value: UARTState.ready.rawValue)
  }

  // Called by the concrete UART dispatcher after a DMA thunk reads Parent.
  public func handleDMAEvent<Source: UARTDMAEventSourceIO>(_ kind: UARTDMACallbackKind, source: Source) {
    switch kind {
    case .transmitComplete:
      if source.readMode() != 0x81 {
        handle.write(.transmitCount, value: 0)
        registers.atomicModify(.cr3, clear: 0x80, set: 0)
        registers.atomicModify(.cr1, clear: 0, set: 0x40)
      } else {
        invokeCallback(.transmitComplete)
      }
    case .transmitHalfComplete:
      invokeCallback(.transmitHalfComplete)
    case .receiveComplete:
      if source.readMode() != 0x81 {
        handle.write(.receiveCount, value: 0)
        registers.atomicModify(.cr1, clear: 0x100, set: 0)
        registers.atomicModify(.cr3, clear: 1, set: 0)
        registers.atomicModify(.cr3, clear: 0x40, set: 0)
        handle.write(.receiveState, value: UARTState.ready.rawValue)
        if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
          registers.atomicModify(.cr1, clear: 0x10, set: 0)
        }
      }
      handle.write(.rxEventType, value: UARTRxEventType.complete.rawValue)
      if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
        handle.write(.receiveCount, value: 0)
        let remaining = UInt16(truncatingIfNeeded: source.getCounter())
        if remaining < handle.read(.receiveSize) { handle.write(.receiveCount, value: remaining) }
        invokeRxEvent(handle.read(.receiveSize) &- handle.read(.receiveCount))
      } else {
        invokeCallback(.receiveComplete)
      }
    case .receiveHalfComplete:
      handle.write(.rxEventType, value: UARTRxEventType.halfComplete.rawValue)
      if handle.read(.receptionType) == UARTReceptionType.toIdle.rawValue {
        handle.write(.receiveCount, value: handle.read(.receiveSize) / 2)
        let remaining = UInt16(truncatingIfNeeded: source.getCounter())
        if remaining <= handle.read(.receiveSize) { handle.write(.receiveCount, value: remaining) }
        invokeRxEvent(handle.read(.receiveSize) &- handle.read(.receiveCount))
      } else {
        invokeCallback(.receiveHalfComplete)
      }
    case .error:
      let globalState = handle.read(.globalState)
      let receiveState = handle.read(.receiveState)
      if registers.read(.cr3) & 0x80 != 0 && globalState == UARTState.busyTransmit.rawValue {
        endTransmitTransfer()
      }
      if registers.read(.cr3) & 0x40 != 0 && receiveState == UARTState.busyReceive.rawValue {
        endReceiveTransfer()
      }
      handle.write(.errorCode, value: handle.read(.errorCode) | UARTError.dma.rawValue)
      invokeCallback(.error)
    case .abortOnError:
      invokeCallback(.error)
    case .transmitAbort:
      dma.writeCallback(.transmit, id: .abort, value: nil)
      if dma.isPresent(.receive) {
        if dma.readCallback(.receive, id: .abort) != nil { return }
      }
      handle.write(.errorCode, value: 0)
      clearFlag(0xF)
      if handle.read(.fifoMode) == 0x2000_0000 { sendRequest(0x10) }
      handle.write(.globalState, value: UARTState.ready.rawValue)
      handle.write(.receiveState, value: UARTState.ready.rawValue)
      handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
      invokeCallback(.abortComplete)
    case .receiveAbort:
      dma.writeCallback(.receive, id: .abort, value: nil)
      if dma.isPresent(.transmit) {
        if dma.readCallback(.transmit, id: .abort) != nil { return }
      }
      handle.write(.errorCode, value: 0)
      clearFlag(0xF)
      sendRequest(8)
      handle.write(.globalState, value: UARTState.ready.rawValue)
      handle.write(.receiveState, value: UARTState.ready.rawValue)
      handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
      invokeCallback(.abortComplete)
    case .transmitOnlyAbort:
      if handle.read(.fifoMode) == 0x2000_0000 { sendRequest(0x10) }
      handle.write(.globalState, value: UARTState.ready.rawValue)
      invokeCallback(.abortTransmitComplete)
    case .receiveOnlyAbort:
      clearFlag(0xF)
      sendRequest(8)
      handle.write(.receiveState, value: UARTState.ready.rawValue)
      handle.write(.receptionType, value: UARTReceptionType.standard.rawValue)
      invokeCallback(.abortReceiveComplete)
    }
  }

  private func dmaHead(_ direction: UARTDMADirection) -> UInt32 {
    dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress))
  }

  private func busAddress(_ pointer: UnsafeMutableRawPointer?) -> UInt32 {
    UInt32(truncatingIfNeeded: pointer.map { UInt(bitPattern: $0) } ?? 0)
  }
}
