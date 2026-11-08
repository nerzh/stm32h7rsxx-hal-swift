// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART abort paths and DMA callbacks from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USART {
  @discardableResult
  public func abort(getTick: () -> UInt32) -> HALStatus {
    modify(.cr1, clear: 0x1E0, set: 0)
    modify(.cr3, clear: 0x1080_0001, set: 0)
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
    if handle.read(.fifoMode) == 0x2000_0000 { sendRequest(0x10) }
    sendRequest(8)
    handle.write(.state, value: 1)
    handle.write(.errorCode, value: 0)
    return .ok
  }
  @discardableResult
  public func abortInterrupt() -> HALStatus {
    var complete = true
    modify(.cr1, clear: 0x1E0, set: 0)
    modify(.cr3, clear: 0x1080_0001, set: 0)
    if dma.isPresent(.transmit) {
      dma.writeCallback(
        .transmit, id: .abort,
        value: registers.read(.cr3) & 0x80 == 0x80 ? dma.callback(.transmitAbort) : nil)
    }
    if dma.isPresent(.receive) {
      dma.writeCallback(
        .receive, id: .abort,
        value: registers.read(.cr3) & 0x40 == 0x40 ? dma.callback(.receiveAbort) : nil)
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
    if complete {
      handle.write(.transmitCount, value: 0)
      handle.write(.receiveCount, value: 0)
      handle.write(.errorCode, value: 0)
      clearFlag(0xF)
      if handle.read(.fifoMode) == 0x2000_0000 { sendRequest(0x10) }
      sendRequest(8)
      handle.write(.state, value: 1)
      invokeCallback(.abortComplete)
    }
    return .ok
  }
  // Called by a caller-owned UARTDMACallbackContext dispatcher, after the
  // existing DMA bridge reads its live Parent. Source is the original DMA.
  public func handleDMAEvent<Source: UARTDMAEventSourceIO>(
    _ event: UARTDMACallbackKind, source: Source
  ) {
    switch event {
    case .transmitComplete:
      if source.readMode() != 0x81 {
        handle.write(.transmitCount, value: 0)
        if handle.read(.state) == 0x12 {
          modify(.cr3, clear: 0x80, set: 0)
          enableInterrupt(0x626)
        }
      } else if handle.read(.state) == 0x12 {
        invokeCallback(.transmitComplete)
      }
    case .transmitHalfComplete: invokeCallback(.transmitHalfComplete)
    case .receiveComplete:
      if source.readMode() != 0x81 {
        handle.write(.receiveCount, value: 0)
        modify(.cr1, clear: 0x100, set: 0)
        modify(.cr3, clear: 1, set: 0)
        modify(.cr3, clear: 0x40, set: 0)
        modify(.cr3, clear: 0x80, set: 0)
        if handle.read(.state) == 0x22 {
          invokeCallback(.receiveComplete)
        } else {
          invokeCallback(.transmitReceiveComplete)
        }
        handle.write(.state, value: 1)
      } else {
        if handle.read(.state) == 0x22 {
          invokeCallback(.receiveComplete)
        } else {
          invokeCallback(.transmitReceiveComplete)
        }
      }
    case .receiveHalfComplete: invokeCallback(.receiveHalfComplete)
    case .error:
      handle.write(.receiveCount, value: 0)
      handle.write(.transmitCount, value: 0)
      endTransfer()
      handle.write(.errorCode, value: handle.read(.errorCode) | 0x10)
      handle.write(.state, value: 1)
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
    case .transmitOnlyAbort, .receiveOnlyAbort:
      preconditionFailure("USART has no direction-only abort callback")
    }
  }
  private func completeDMAAbort() {
    handle.write(.transmitCount, value: 0)
    handle.write(.receiveCount, value: 0)
    handle.write(.errorCode, value: 0)
    clearFlag(0xF)
    handle.write(.state, value: 1)
    invokeCallback(.abortComplete)
  }
}
