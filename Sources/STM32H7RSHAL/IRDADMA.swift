// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// IRDA operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension IRDA {

  @discardableResult
  public func transmitDMA(_ data: UnsafeRawPointer?, size: UInt16) -> HALStatus {
    var bytes = size
    if handle.read(.globalState) != 0x20 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: data))
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: 0x21)
    dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.transmitComplete))
    dma.writeCallback(.transmit, id: .halfTransfer, value: dma.callback(.transmitHalfComplete))
    dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))
    dma.writeCallback(.transmit, id: .abort, value: nil)
    if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 { bytes = size &* 2 }
    let status: HALStatus
    if dma.read(.transmit, word: .mode) & 0x80 == 0x80 {
      if dma.read(.transmit, word: .queueAddress) != 0
        && dma.readMemory32(.transmit, at: dma.read(.transmit, word: .queueAddress)) != 0
      {
        dma.writeMemory32(.transmit, at: dmaHead(.transmit) &+ 8, value: UInt32(bytes))
        dma.writeMemory32(
          .transmit, at: dmaHead(.transmit) &+ 12,
          value: busAddress(handle.readPointer(.transmit)))
        dma.writeMemory32(
          .transmit, at: dmaHead(.transmit) &+ 16,
          value: registers.instance.rawValue &+ 0x28)
        status = dma.startLinkedListInterrupt(.transmit)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        .transmit,
        sourceAddress: busAddress(handle.readPointer(.transmit)),
        destinationAddress: registers.instance.rawValue &+ 0x28, sourceDataSize: UInt32(bytes))
    }
    if status == .ok {
      clearFlag(0x40)
      unlock()
      modify(.cr3, clear: 0, set: 0x80)
      return .ok
    }
    handle.write(.errorCode, value: 0x10)
    unlock()
    handle.write(.globalState, value: 0x20)
    return .error
  }

  @discardableResult
  public func receiveDMA(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    var bytes = size
    if handle.read(.receiveState) != 0x20 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.receive, value: data)
    handle.write(.receiveSize, value: size)
    handle.write(.errorCode, value: 0)
    handle.write(.receiveState, value: 0x22)
    dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.receiveComplete))
    dma.writeCallback(.receive, id: .halfTransfer, value: dma.callback(.receiveHalfComplete))
    dma.writeCallback(.receive, id: .error, value: dma.callback(.error))
    dma.writeCallback(.receive, id: .abort, value: nil)
    if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 { bytes = size &* 2 }
    let status: HALStatus
    if dma.read(.receive, word: .mode) & 0x80 == 0x80 {
      if dma.read(.receive, word: .queueAddress) != 0
        && dma.readMemory32(.receive, at: dma.read(.receive, word: .queueAddress)) != 0
      {
        dma.writeMemory32(.receive, at: dmaHead(.receive) &+ 8, value: UInt32(bytes))
        dma.writeMemory32(
          .receive, at: dmaHead(.receive) &+ 12,
          value: registers.instance.rawValue &+ 0x24)
        dma.writeMemory32(
          .receive, at: dmaHead(.receive) &+ 16,
          value: busAddress(handle.readPointer(.receive)))
        status = dma.startLinkedListInterrupt(.receive)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        .receive,
        sourceAddress: registers.instance.rawValue &+ 0x24,
        destinationAddress: busAddress(handle.readPointer(.receive)), sourceDataSize: UInt32(bytes))
    }
    if status == .ok {
      unlock()
      if handle.read(.parity) != 0 { modify(.cr1, clear: 0, set: 0x100) }
      modify(.cr3, clear: 0, set: 1)
      modify(.cr3, clear: 0, set: 0x40)
      return .ok
    }
    handle.write(.errorCode, value: 0x10)
    unlock()
    handle.write(.receiveState, value: 0x20)
    return .error
  }

  private func busAddress(_ pointer: UnsafeMutableRawPointer?) -> UInt32 {
    UInt32(truncatingIfNeeded: UInt(bitPattern: pointer))
  }
  private func dmaHead(_ direction: UARTDMADirection) -> UInt32 {
    dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress))
  }
  @discardableResult
  public func pauseDMA() -> HALStatus {
    if !tryLock() { return .busy }
    if handle.read(.globalState) == 0x21 {
      if registers.read(.cr3) & 0x80 == 0x80 { modify(.cr3, clear: 0x80, set: 0) }
    }
    if handle.read(.receiveState) == 0x22 {
      if registers.read(.cr3) & 0x40 == 0x40 {
        modify(.cr1, clear: 0x100, set: 0)
        modify(.cr3, clear: 1, set: 0)
        modify(.cr3, clear: 0x40, set: 0)
      }
    }
    unlock()
    return .ok
  }
  @discardableResult
  public func resumeDMA() -> HALStatus {
    if !tryLock() { return .busy }
    if handle.read(.globalState) == 0x21 { modify(.cr3, clear: 0, set: 0x80) }
    if handle.read(.receiveState) == 0x22 {
      clearFlag(8)
      if handle.read(.parity) != 0 { modify(.cr1, clear: 0, set: 0x100) }
      modify(.cr3, clear: 0, set: 1)
      modify(.cr3, clear: 0, set: 0x40)
    }
    unlock()
    return .ok
  }
  @discardableResult
  public func stopDMA(getTick: () -> UInt32) -> HALStatus {
    if handle.read(.globalState) == 0x21 {
      if registers.read(.cr3) & 0x80 == 0x80 {
        modify(.cr3, clear: 0x80, set: 0)
        if dma.isPresent(.transmit) {
          if dma.abort(.transmit, getTick: getTick) != .ok {
            if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
              handle.write(.errorCode, value: 0x10)
              return .timeout
            }
          }
        }
        endTransmitTransfer()
      }
    }
    if handle.read(.receiveState) == 0x22 {
      if registers.read(.cr3) & 0x40 == 0x40 {
        modify(.cr3, clear: 0x40, set: 0)
        if dma.isPresent(.receive) {
          if dma.abort(.receive, getTick: getTick) != .ok {
            if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
              handle.write(.errorCode, value: 0x10)
              return .timeout
            }
          }
        }
        endReceiveTransfer()
      }
    }
    return .ok
  }

}
