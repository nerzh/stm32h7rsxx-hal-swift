// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// USART interrupt transfers from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension USART {
  @discardableResult
  public func transmitInterrupt(_ data: UnsafeRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.state) != 1 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: data))
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    handle.write(.txISR, value: 0)
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x12)
    if handle.read(.fifoMode) == 0x2000_0000 {
      handle.write(
        .txISR, value: handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 ? 4 : 3)
      unlock()
      enableInterrupt(0x1B77)
    } else {
      handle.write(
        .txISR, value: handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 ? 2 : 1)
      unlock()
      enableInterrupt(0x727)
    }
    return .ok
  }
  @discardableResult
  public func receiveInterrupt(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.state) != 1 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.receive, value: data)
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    handle.write(.rxISR, value: 0)
    computeMask()
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x22)
    modify(.cr3, clear: 0, set: 1)
    if handle.read(.fifoMode) == 0x2000_0000 && size >= handle.read(.rxDataToProcess) {
      handle.write(
        .rxISR, value: handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 ? 4 : 3)
      unlock()
      if handle.read(.parity) != 0 { modify(.cr1, clear: 0, set: 0x100) }
      modify(.cr3, clear: 0, set: 0x1000_0000)
    } else {
      handle.write(
        .rxISR, value: handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 ? 2 : 1)
      unlock()
      if handle.read(.parity) != 0 {
        modify(.cr1, clear: 0, set: 0x120)
      } else {
        modify(.cr1, clear: 0, set: 0x20)
      }
    }
    if handle.read(.slaveMode) == 0 {
      if handle.read(.fifoMode) == 0x2000_0000 && size >= handle.read(.rxDataToProcess) {
        var count = handle.read(.rxDataToProcess)
        while count > 0 {
          registers.write(.tdr, value: 0xFF)
          count &-= 1
        }
      } else {
        registers.write(.tdr, value: 0xFF)
      }
    }
    return .ok
  }
  @discardableResult
  public func transmitReceiveInterrupt(
    _ tx: UnsafeRawPointer?, receiveData rx: UnsafeMutableRawPointer?,
    size: UInt16
  ) -> HALStatus {
    if handle.read(.state) != 1 { return .busy }
    guard let tx, let rx, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.receive, value: rx)
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: tx))
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    computeMask()
    handle.write(.errorCode, value: 0)
    handle.write(.state, value: 0x32)
    if handle.read(.fifoMode) == 0x2000_0000 && size >= handle.read(.rxDataToProcess) {
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
        handle.write(.txISR, value: 4)
        handle.write(.rxISR, value: 4)
      } else {
        handle.write(.txISR, value: 3)
        handle.write(.rxISR, value: 3)
      }
      unlock()
      modify(.cr3, clear: 0, set: 1)
      if handle.read(.parity) != 0 { modify(.cr1, clear: 0, set: 0x100) }
      modify(.cr3, clear: 0, set: 0x1080_0000)
    } else {
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
        handle.write(.txISR, value: 2)
        handle.write(.rxISR, value: 2)
      } else {
        handle.write(.txISR, value: 1)
        handle.write(.rxISR, value: 1)
      }
      unlock()
      modify(.cr3, clear: 0, set: 1)
      if handle.read(.parity) != 0 {
        modify(.cr1, clear: 0, set: 0x120)
      } else {
        modify(.cr1, clear: 0, set: 0x20)
      }
      modify(.cr1, clear: 0, set: 0x80)
    }
    return .ok
  }
  public func handleInterrupt() {
    let flags = registers.read(.isr)
    let cr1 = registers.read(.cr1)
    let cr3 = registers.read(.cr3)
    let errors = flags & 0x280F
    if errors == 0 {
      if flags & 0x20 != 0 && (cr1 & 0x20 != 0 || cr3 & 0x1000_0000 != 0) {
        if handle.read(.rxISR) != 0 { invokeRxISR(handle.read(.rxISR)) }
        return
      }
    }
    if errors != 0 && (cr3 & 0x1000_0001 != 0 || cr1 & 0x120 != 0) {
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
      if flags & 0x800 != 0 && cr1 & 0x4000000 != 0 {
        clearFlag(0x800)
        handle.write(.errorCode, value: handle.read(.errorCode) | 0x80)
      }
      if flags & 0x2000 != 0 && cr3 & 1 != 0 {
        if handle.read(.state) == 0x22 {
          clearFlag(0x2000)
          return
        } else {
          clearFlag(0x2000)
          handle.write(.errorCode, value: handle.read(.errorCode) | 0x20)
        }
      }
      if handle.read(.errorCode) != 0 {
        if flags & 0x20 != 0 && (cr1 & 0x20 != 0 || cr3 & 0x1000_0000 != 0) {
          if handle.read(.rxISR) != 0 { invokeRxISR(handle.read(.rxISR)) }
        }
        let overrun = handle.read(.errorCode) & 8
        if registers.read(.cr3) & 0x40 == 0x40 || overrun != 0 {
          endTransfer()
          if registers.read(.cr3) & 0x40 == 0x40 {
            // The source repeats DMAR here; it does not clear DMAT.
            modify(.cr3, clear: 0x40 | 0x40, set: 0)
            if dma.isPresent(.transmit) {
              dma.writeCallback(.transmit, id: .abort, value: nil)
              _ = dma.abortInterrupt(.transmit)
            }
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
    if flags & 0x80 != 0 && (cr1 & 0x80 != 0 || cr3 & 0x800000 != 0) {
      if handle.read(.txISR) != 0 { invokeTxISR(handle.read(.txISR)) }
      return
    }
    if flags & 0x40 != 0 && cr1 & 0x40 != 0 {
      endTransmitInterrupt()
      return
    }
    if flags & 0x800000 != 0 && cr1 & 0x4000_0000 != 0 {
      invokeCallback(.transmitFIFOEmpty)
      return
    }
    if flags & 0x1000000 != 0 && cr1 & 0x8000_0000 != 0 {
      invokeCallback(.receiveFIFOFull)
      return
    }
  }
  func endTransfer() {
    modify(.cr1, clear: 0x1E0, set: 0)
    modify(.cr3, clear: 0x1080_0001, set: 0)
    handle.write(.state, value: 1)
  }
  func invokeTxISR(_ selector: UInt32) {
    precondition(selector >= 1 && selector <= 4)
    let state = handle.read(.state)
    if state != 0x12 && state != 0x32 { return }
    let fifo = selector >= 3
    let halfWord = selector == 2 || selector == 4
    var count: UInt16 = fifo ? handle.read(.txDataToProcess) : 1
    while count > 0 {
      if handle.read(.transmitCount) == 0 {
        disableInterrupt(fifo ? 0x1B77 : 0x727)
        enableInterrupt(0x626)
        break
      } else if !fifo || getFlag(0x80) == 1 {
        let pointer = handle.readPointer(.transmit)!
        if halfWord {
          registers.write(.tdr, value: UInt32(pointer.load(as: UInt16.self) & 0x1FF))
        } else {
          registers.write(.tdr, value: UInt32(pointer.load(as: UInt8.self)))
        }
        handle.writePointer(
          .transmit, value: handle.readPointer(.transmit)!.advanced(by: halfWord ? 2 : 1))
        handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
      }
      count &-= 1
    }
  }
  func endTransmitInterrupt() {
    disableInterrupt(0x626)
    disableInterrupt(0x60)
    handle.write(.txISR, value: 0)
    if handle.read(.state) == 0x12 {
      clearFlag(8)
      sendRequest(8)
      handle.write(.state, value: 1)
      invokeCallback(.transmitComplete)
    } else if handle.read(.receiveCount) == 0 {
      handle.write(.state, value: 1)
      invokeCallback(.transmitReceiveComplete)
    }
  }
  func invokeRxISR(_ selector: UInt32) {
    precondition(selector >= 1 && selector <= 4)
    var state = handle.read(.state)
    let mask = handle.read(.mask)
    let fifo = selector >= 3
    let halfWord = selector == 2 || selector == 4
    if state != 0x22 && state != 0x32 {
      if fifo { sendRequest(8) }
      return
    }
    var count: UInt16 = fifo ? handle.read(.rxDataToProcess) : 1
    while count > 0 {
      if !fifo || getFlag(0x20) == 1 {
        let pointer = handle.readPointer(.receive)!
        if halfWord {
          pointer.storeBytes(
            of: UInt16(truncatingIfNeeded: registers.read(.rdr) & UInt32(mask)), as: UInt16.self)
        } else {
          pointer.storeBytes(
            of: UInt8(truncatingIfNeeded: registers.read(.rdr) & UInt32(mask & 0xFF)),
            as: UInt8.self)
        }
        handle.writePointer(
          .receive, value: handle.readPointer(.receive)!.advanced(by: halfWord ? 2 : 1))
        handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
        if handle.read(.receiveCount) == 0 {
          modify(.cr1, clear: fifo ? 0x100 : 0x120, set: 0)
          modify(.cr3, clear: fifo ? 0x1000_0001 : 1, set: 0)
          handle.write(.rxISR, value: 0)
          let txThreshold = registers.read(.cr3) & 0x800000
          let txCount = handle.read(.transmitCount)
          if state == 0x22 {
            if handle.read(.slaveMode) == 1 {
              clearFlag(0x2000)
              sendRequest(0x10)
            }
            handle.write(.state, value: 1)
            if fifo { state = 1 }
            invokeCallback(.receiveComplete)
          } else if registers.read(.cr1) & 0x40 != 0x40 && txThreshold != 0x800000 && txCount == 0 {
            handle.write(.state, value: 1)
            if fifo { state = 1 }
            invokeCallback(.transmitReceiveComplete)
          }
        } else if state == 0x22 && handle.read(.slaveMode) == 0 {
          registers.write(.tdr, value: 0xFF)
        }
      }
      count &-= 1
    }
    if fifo {
      let rxCount = handle.read(.receiveCount)
      if rxCount != 0 && rxCount < handle.read(.rxDataToProcess) {
        modify(.cr3, clear: 0x1000_0000, set: 0)
        handle.write(.rxISR, value: halfWord ? 2 : 1)
        modify(.cr1, clear: 0, set: 0x20)
        if handle.read(.transmitCount) == 0 && state == 0x32 && handle.read(.slaveMode) == 0 {
          registers.write(.tdr, value: 0xFF)
        }
      }
    }
  }
}
