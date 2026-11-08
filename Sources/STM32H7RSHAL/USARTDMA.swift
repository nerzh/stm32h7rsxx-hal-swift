// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART DMA transfers from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USART {
  @discardableResult
  public func transmitDMA(_ data: UnsafeRawPointer?, size: UInt16) -> HALStatus {
    var status = HALStatus.ok
    var bytes = size
    if handle.read(.state) != 1 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: data))
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x12)
    if dma.isPresent(.transmit) {
      dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.transmitComplete))
      dma.writeCallback(.transmit, id: .halfTransfer, value: dma.callback(.transmitHalfComplete))
      dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 { bytes = size &* 2 }
      status = startDMA(
        .transmit, source: UInt32(truncatingIfNeeded: UInt(bitPattern: data)),
        destination: registers.instance.rawValue &+ 0x28, bytes: bytes)
    }
    if status == .ok {
      clearFlag(0x40)
      unlock()
      modify(.cr3, clear: 0, set: 0x80)
      return .ok
    }
    handle.write(.errorCode, value: 0x10)
    unlock()
    handle.write(.state, value: 1)
    return .error
  }
  @discardableResult
  public func receiveDMA(
    _ data: UnsafeMutableRawPointer?, size: UInt16,
    getTick: () -> UInt32
  ) -> HALStatus {
    var status = HALStatus.ok
    var bytes = size
    if handle.read(.state) != 1 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.receive, value: data)
    handle.write(.receiveSize, value: size)
    handle.writePointer(.transmit, value: data)
    handle.write(.transmitSize, value: size)
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x22)
    let address = UInt32(truncatingIfNeeded: UInt(bitPattern: data))
    if dma.isPresent(.receive) {
      dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.receiveComplete))
      dma.writeCallback(.receive, id: .halfTransfer, value: dma.callback(.receiveHalfComplete))
      dma.writeCallback(.receive, id: .error, value: dma.callback(.error))
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 { bytes = size &* 2 }
      status = startDMA(
        .receive, source: registers.instance.rawValue &+ 0x24, destination: address, bytes: bytes)
    }
    if status == .ok && handle.read(.slaveMode) == 0 {
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .error, value: nil)
        dma.writeCallback(.transmit, id: .halfTransfer, value: nil)
        dma.writeCallback(.transmit, id: .transferComplete, value: nil)
        status = startDMA(
          .transmit, source: address, destination: registers.instance.rawValue &+ 0x28, bytes: bytes
        )
      }
    }
    if status == .ok {
      unlock()
      if handle.read(.parity) != 0 { modify(.cr1, clear: 0, set: 0x100) }
      modify(.cr3, clear: 0, set: 1)
      modify(.cr3, clear: 0, set: 0x40)
      modify(.cr3, clear: 0, set: 0x80)
      return .ok
    }
    if dma.isPresent(.receive) && dma.read(.receive, word: .mode) & 0x80 != 0x80 {
      _ = dma.abort(.receive, getTick: getTick)
    }
    handle.write(.errorCode, value: 0x10)
    unlock()
    handle.write(.state, value: 1)
    return .error
  }
  @discardableResult
  public func transmitReceiveDMA(
    _ tx: UnsafeRawPointer?, receiveData rx: UnsafeMutableRawPointer?,
    size: UInt16, getTick: () -> UInt32
  ) -> HALStatus {
    var status: HALStatus
    var bytes = size
    if handle.read(.state) != 1 { return .busy }
    guard let tx, let rx, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.receive, value: rx)
    handle.write(.receiveSize, value: size)
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: tx))
    handle.write(.transmitSize, value: size)
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x32)
    if dma.isPresent(.receive) && dma.isPresent(.transmit) {
      dma.writeCallback(.receive, id: .transferComplete, value: dma.callback(.receiveComplete))
      dma.writeCallback(.receive, id: .halfTransfer, value: dma.callback(.receiveHalfComplete))
      dma.writeCallback(.transmit, id: .transferComplete, value: dma.callback(.transmitComplete))
      dma.writeCallback(.transmit, id: .halfTransfer, value: dma.callback(.transmitHalfComplete))
      dma.writeCallback(.transmit, id: .error, value: dma.callback(.error))
      dma.writeCallback(.receive, id: .error, value: dma.callback(.error))
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 { bytes = size &* 2 }
      status = startDMA(
        .receive, source: registers.instance.rawValue &+ 0x24,
        destination: UInt32(truncatingIfNeeded: UInt(bitPattern: rx)), bytes: bytes)
      if status == .ok {
        status = startDMA(
          .transmit, source: UInt32(truncatingIfNeeded: UInt(bitPattern: tx)),
          destination: registers.instance.rawValue &+ 0x28, bytes: bytes)
      }
    } else {
      status = .error
    }
    if status == .ok {
      unlock()
      if handle.read(.parity) != 0 { modify(.cr1, clear: 0, set: 0x100) }
      modify(.cr3, clear: 0, set: 1)
      clearFlag(0x40)
      modify(.cr3, clear: 0, set: 0x40)
      modify(.cr3, clear: 0, set: 0x80)
      return .ok
    }
    if dma.isPresent(.receive) && dma.read(.receive, word: .mode) & 0x80 != 0x80 {
      _ = dma.abort(.receive, getTick: getTick)
    }
    handle.write(.errorCode, value: 0x10)
    unlock()
    handle.write(.state, value: 1)
    return .error
  }
  private func startDMA(
    _ direction: UARTDMADirection, source: UInt32, destination: UInt32, bytes: UInt16
  ) -> HALStatus {
    if dma.read(direction, word: .mode) & 0x80 == 0x80 {
      if dma.read(direction, word: .queueAddress) != 0
        && dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress)) != 0
      {
        dma.writeMemory32(direction, at: dmaHead(direction) &+ 8, value: UInt32(bytes))
        dma.writeMemory32(direction, at: dmaHead(direction) &+ 12, value: source)
        dma.writeMemory32(direction, at: dmaHead(direction) &+ 16, value: destination)
        return dma.startLinkedListInterrupt(direction)
      }
      return .error
    }
    return dma.startInterrupt(
      direction, sourceAddress: source, destinationAddress: destination,
      sourceDataSize: UInt32(bytes))
  }
  private func dmaHead(_ direction: UARTDMADirection) -> UInt32 {
    dma.readMemory32(direction, at: dma.read(direction, word: .queueAddress))
  }
  @discardableResult
  public func pauseDMA(getTick: () -> UInt32) -> HALStatus {
    let state = handle.read(.state)
    if !tryLock() { return .busy }
    if registers.read(.cr3) & 0x80 == 0x80 && state == 0x12 {
      if dma.isPresent(.transmit) {
        dma.writeCallback(.transmit, id: .suspend, value: nil)
        if dma.suspend(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: 0x10)
            return .timeout
          }
        }
      }
    } else if state == 0x22 || state == 0x32 {
      modify(.cr1, clear: 0x100, set: 0)
      modify(.cr3, clear: 1, set: 0)
      dma.writeCallback(.receive, id: .suspend, value: nil)
      if dma.suspend(.receive, getTick: getTick) != .ok {
        if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
          handle.write(.errorCode, value: 0x10)
          return .timeout
        }
      }
      if state == 0x32 {
        dma.writeCallback(.transmit, id: .suspend, value: nil)
        if dma.suspend(.transmit, getTick: getTick) != .ok {
          if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
            handle.write(.errorCode, value: 0x10)
            return .timeout
          }
        }
      }
    }
    unlock()
    return .ok
  }
  @discardableResult
  public func resumeDMA() -> HALStatus {
    let state = handle.read(.state)
    if !tryLock() { return .busy }
    if state == 0x12 {
      if dma.isPresent(.transmit) {
        if dma.resume(.transmit) != .ok {
          handle.write(.errorCode, value: 0x10)
          return .error
        }
      }
    } else if state == 0x22 || state == 0x32 {
      clearFlag(8)
      if handle.read(.parity) != 0 { modify(.cr1, clear: 0, set: 0x100) }
      modify(.cr3, clear: 0, set: 1)
      if dma.isPresent(.receive) {
        if dma.resume(.receive) != .ok {
          handle.write(.errorCode, value: 0x10)
          return .error
        }
      }
      if state == 0x32 {
        if dma.isPresent(.transmit) {
          if dma.resume(.transmit) != .ok {
            handle.write(.errorCode, value: 0x10)
            return .error
          }
        }
      }
    }
    unlock()
    return .ok
  }
  @discardableResult
  public func stopDMA(getTick: () -> UInt32) -> HALStatus {
    modify(.cr3, clear: 0x80, set: 0)
    modify(.cr3, clear: 0x40, set: 0)
    if dma.isPresent(.transmit) {
      if dma.abort(.transmit, getTick: getTick) != .ok {
        if dma.read(.transmit, word: .errorCode) == DMAError.timeout.rawValue {
          handle.write(.errorCode, value: 0x10)
          return .timeout
        }
      }
    }
    if dma.isPresent(.receive) {
      if dma.abort(.receive, getTick: getTick) != .ok {
        if dma.read(.receive, word: .errorCode) == DMAError.timeout.rawValue {
          handle.write(.errorCode, value: 0x10)
          return .timeout
        }
      }
    }
    endTransfer()
    handle.write(.state, value: 1)
    return .ok
  }
}
