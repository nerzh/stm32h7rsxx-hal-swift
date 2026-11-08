// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// IRDA operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension IRDA {
  @discardableResult
  public func abort(getTick: () -> UInt32) -> HALStatus {
    modify(.cr1, clear: 0x1E0, set: 0)
    modify(.cr3, clear: 1, set: 0)
    if registers.read(.cr3) & 0x80 == 0x80 {
      modify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .abort, value: nil)
        if dma.abort(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: 0x10)
            return .timeout
          }
        }
      }
    }
    if registers.read(.cr3) & 0x40 == 0x40 {
      modify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        dma.writeCallback(.receive, id: .abort, value: nil)
        if dma.abort(.receive, getTick: getTick) != .ok {
          if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: 0x10)
            return .timeout
          }
        }
      }
    }
    handle.write(.transmitCount, value: 0)
    handle.write(.receiveCount, value: 0)
    clearFlag(0xF)
    handle.write(.globalState, value: 0x20)
    handle.write(.receiveState, value: 0x20)
    handle.write(.errorCode, value: 0)
    return .ok
  }
  @discardableResult
  public func abortTransmit(getTick: () -> UInt32) -> HALStatus {
    modify(.cr1, clear: 0xC0, set: 0)
    if registers.read(.cr3) & 0x80 == 0x80 {
      modify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .abort, value: nil)
        if dma.abort(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: 0x10)
            return .timeout
          }
        }
      }
    }
    handle.write(.transmitCount, value: 0)
    handle.write(.globalState, value: 0x20)
    return .ok
  }
  @discardableResult
  public func abortReceive(getTick: () -> UInt32) -> HALStatus {
    modify(.cr1, clear: 0x120, set: 0)
    modify(.cr3, clear: 1, set: 0)
    if registers.read(.cr3) & 0x40 == 0x40 {
      modify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        dma.writeCallback(.receive, id: .abort, value: nil)
        if dma.abort(.receive, getTick: getTick) != .ok {
          if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: 0x10)
            return .timeout
          }
        }
      }
    }
    handle.write(.receiveCount, value: 0)
    clearFlag(0xF)
    handle.write(.receiveState, value: 0x20)
    return .ok
  }
  @discardableResult
  public func abortInterrupt() -> HALStatus {
    var complete = true
    modify(.cr1, clear: 0x1E0, set: 0)
    modify(.cr3, clear: 1, set: 0)
    if dma.isPresent(.transmit) {
      if registers.read(.cr3) & 0x80 == 0x80 {
        dma.writeCallback(.transmit, id: .abort, value: dma.callback(.transmitAbort))
      } else {
        dma.writeCallback(.transmit, id: .abort, value: nil)
      }
    }
    if dma.isPresent(.receive) {
      if registers.read(.cr3) & 0x40 == 0x40 {
        dma.writeCallback(.receive, id: .abort, value: dma.callback(.receiveAbort))
      } else {
        dma.writeCallback(.receive, id: .abort, value: nil)
      }
    }
    if registers.read(.cr3) & 0x80 == 0x80 {
      modify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        if dma.abortInterrupt(.transmit) != .ok {
          dma.writeCallback(.transmit, id: .abort, value: nil)
        } else {
          complete = false
        }
      }
    }
    if registers.read(.cr3) & 0x40 == 0x40 {
      modify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        if dma.abortInterrupt(.receive) != .ok {
          dma.writeCallback(.receive, id: .abort, value: nil)
          complete = true
        } else {
          complete = false
        }
      }
    }
    if complete { completeDMAAbort() }
    return .ok
  }
  @discardableResult
  public func abortTransmitInterrupt() -> HALStatus {
    modify(.cr1, clear: 0xC0, set: 0)
    if registers.read(.cr3) & 0x80 == 0x80 {
      modify(.cr3, clear: 0x80, set: 0)
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .abort, value: dma.callback(.transmitOnlyAbort))
        if dma.abortInterrupt(.transmit) != .ok { dma.invokeCallback(.transmit, id: .abort) }
      } else {
        completeTransmitAbort()
      }
    } else {
      completeTransmitAbort()
    }
    return .ok
  }
  @discardableResult
  public func abortReceiveInterrupt() -> HALStatus {
    modify(.cr1, clear: 0x120, set: 0)
    modify(.cr3, clear: 1, set: 0)
    if registers.read(.cr3) & 0x40 == 0x40 {
      modify(.cr3, clear: 0x40, set: 0)
      if dma.isPresent(.receive) {
        dma.writeCallback(.receive, id: .abort, value: dma.callback(.receiveOnlyAbort))
        if dma.abortInterrupt(.receive) != .ok { dma.invokeCallback(.receive, id: .abort) }
      } else {
        completeReceiveAbort()
      }
    } else {
      completeReceiveAbort()
    }
    return .ok
  }
  // Dispatch with the live Parent and original DMA context through UARTDMACallbackContext.
  public func handleDMAEvent<Source: UARTDMAEventSourceIO>(
    _ event: UARTDMACallbackKind, source: Source
  ) {
    switch event {
    case .transmitComplete:
      if source.readMode() != 0x81 {
        handle.write(.transmitCount, value: 0)
        modify(.cr3, clear: 0x80, set: 0)
        modify(.cr1, clear: 0, set: 0x40)
      } else {
        invokeCallback(.transmitComplete)
      }
    case .transmitHalfComplete: invokeCallback(.transmitHalfComplete)
    case .receiveComplete:
      if source.readMode() != 0x81 {
        handle.write(.receiveCount, value: 0)
        modify(.cr1, clear: 0x100, set: 0)
        modify(.cr3, clear: 1, set: 0)
        modify(.cr3, clear: 0x40, set: 0)
        handle.write(.receiveState, value: 0x20)
      }
      invokeCallback(.receiveComplete)
    case .receiveHalfComplete: invokeCallback(.receiveHalfComplete)
    case .error:
      if handle.read(.globalState) == 0x21 {
        if registers.read(.cr3) & 0x80 == 0x80 {
          handle.write(.transmitCount, value: 0)
          endTransmitTransfer()
        }
      }
      if handle.read(.receiveState) == 0x22 {
        if registers.read(.cr3) & 0x40 == 0x40 {
          handle.write(.receiveCount, value: 0)
          endReceiveTransfer()
        }
      }
      handle.write(.errorCode, value: handle.read(.errorCode) | 0x10)
      invokeCallback(.error)
    case .abortOnError:
      handle.write(.receiveCount, value: 0)
      handle.write(.transmitCount, value: 0)
      invokeCallback(.error)
    case .transmitAbort:
      dma.writeCallback(.transmit, id: .abort, value: nil)
      if dma.isPresent(.receive) {
        if dma.readCallback(.receive, id: .abort) != nil { return }
      }
      completeDMAAbort()
    case .receiveAbort:
      dma.writeCallback(.receive, id: .abort, value: nil)
      if dma.isPresent(.transmit) {
        if dma.readCallback(.transmit, id: .abort) != nil { return }
      }
      completeDMAAbort()
    case .transmitOnlyAbort: completeTransmitAbort()
    case .receiveOnlyAbort: completeReceiveAbort()
    }
  }
  private func completeDMAAbort() {
    handle.write(.transmitCount, value: 0)
    handle.write(.receiveCount, value: 0)
    handle.write(.errorCode, value: 0)
    clearFlag(0xF)
    handle.write(.globalState, value: 0x20)
    handle.write(.receiveState, value: 0x20)
    invokeCallback(.abortComplete)
  }
  private func completeTransmitAbort() {
    handle.write(.transmitCount, value: 0)
    handle.write(.globalState, value: 0x20)
    invokeCallback(.abortTransmitComplete)
  }
  private func completeReceiveAbort() {
    handle.write(.receiveCount, value: 0)
    clearFlag(0xF)
    handle.write(.receiveState, value: 0x20)
    invokeCallback(.abortReceiveComplete)
  }
}
