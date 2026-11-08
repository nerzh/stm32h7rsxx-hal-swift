// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMARTCARD/SMARTCARDEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMARTCARD {

  @discardableResult
  public func transmitInterrupt(_ data: UnsafeRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.globalState) != 0x20 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: 0x21)
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: data))
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    handle.write(.txISR, value: 0)
    prepareTransmitRegisters()
    if handle.read(.fifoMode) == 0x2000_0000 {
      handle.write(.txISR, value: UARTISR.byteFIFO.rawValue)
      unlock()
      modify(.cr3, clear: 0, set: 1)
      modify(.cr3, clear: 0, set: 0x0080_0000)
    } else {
      handle.write(.txISR, value: UARTISR.byte.rawValue)
      unlock()
      modify(.cr3, clear: 0, set: 1)
      modify(.cr1, clear: 0, set: 0x80)
    }
    return .ok
  }
  @discardableResult
  public func receiveInterrupt(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.receiveState) != 0x20 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.write(.errorCode, value: 0)
    handle.write(.receiveState, value: 0x22)
    handle.writePointer(.receive, value: data)
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    if handle.read(.fifoMode) == 0x2000_0000 && size >= handle.read(.rxDataToProcess) {
      handle.write(.rxISR, value: UARTISR.byteFIFO.rawValue)
      unlock()
      modify(.cr1, clear: 0, set: 0x100)
      modify(.cr3, clear: 0, set: 0x1000_0000)
    } else {
      handle.write(.rxISR, value: UARTISR.byte.rawValue)
      unlock()
      modify(.cr1, clear: 0, set: 0x120)
    }
    modify(.cr3, clear: 0, set: 1)
    return .ok
  }
  public func handleInterrupt() {
    let flags = registers.read(.isr)
    let cr1 = registers.read(.cr1)
    let cr3 = registers.read(.cr3)
    let errors = flags & 0x80F
    if errors == 0 {
      if flags & 0x20 != 0 && (cr1 & 0x20 != 0 || cr3 & 0x1000_0000 != 0) {
        invokeReceiveISR()
        return
      }
    }
    if errors != 0 && (cr3 & 0x1000_0001 != 0 || cr1 & 0x120 != 0) {
      if flags & 1 != 0 && cr1 & 0x100 != 0 {
        clearInterrupt(1)
        handle.write(.errorCode, value: handle.read(.errorCode) | 1)
      }
      if flags & 2 != 0 && cr3 & 1 != 0 {
        clearInterrupt(2)
        handle.write(.errorCode, value: handle.read(.errorCode) | 4)
      }
      if flags & 4 != 0 && cr3 & 1 != 0 {
        clearInterrupt(4)
        handle.write(.errorCode, value: handle.read(.errorCode) | 2)
      }
      if flags & 8 != 0 && ((cr1 & 0x20 != 0 || cr3 & 0x1000_0000 != 0) || cr3 & 1 != 0) {
        clearInterrupt(8)
        handle.write(.errorCode, value: handle.read(.errorCode) | 8)
      }
      if flags & 0x800 != 0 && cr1 & 0x0400_0000 != 0 {
        clearInterrupt(0x800)
        handle.write(.errorCode, value: handle.read(.errorCode) | 0x20)
      }
      if handle.read(.errorCode) != 0 {
        if flags & 0x20 != 0 && (cr1 & 0x20 != 0 || cr3 & 0x1000_0000 != 0) { invokeReceiveISR() }
        let error = handle.read(.errorCode)
        if registers.read(.cr3) & 0x40 == 0x40 || error & 0x28 != 0 {
          endReceiveTransfer()
          if registers.read(.cr3) & 0x40 == 0x40 {
            modify(.cr3, clear: 0x40, set: 0)
            if dma.isPresent(.receive) {
              dma.writeCallback(.receive, id: .abort, value: dma.callback(.abortOnError))
              if dma.abortInterrupt(.receive) != .ok { dma.invokeCallback(.receive, id: .abort) }
            } else {
              invokeCallback(.error)
            }
          } else {
            invokeCallback(.error)
          }
        } else if handle.read(.globalState) == 0x21 && error & 4 != 0 {
          endTransmitTransfer()
          if registers.read(.cr3) & 0x80 == 0x80 {
            modify(.cr3, clear: 0x80, set: 0)
            if dma.isPresent(.transmit) {
              dma.writeCallback(.transmit, id: .abort, value: dma.callback(.abortOnError))
              if dma.abortInterrupt(.transmit) != .ok { dma.invokeCallback(.transmit, id: .abort) }
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
    if flags & 0x1000 != 0 && cr1 & 0x0800_0000 != 0 {
      handle.write(.receiveState, value: 0x20)
      unlock()
      invokeCallback(.receiveComplete)
      clearInterrupt(0x1000)
      return
    }
    if flags & 0x80 != 0 && (cr1 & 0x80 != 0 || cr3 & 0x0080_0000 != 0) {
      invokeTransmitISR()
      return
    }
    if getInterrupt(handle.read(.transmitCompletionIndication)) != 0 {
      if getInterruptSource(handle.read(.transmitCompletionIndication)) != 0 {
        endTransmitInterrupt()
        return
      }
    }
    if flags & 0x0080_0000 != 0 && cr1 & 0x4000_0000 != 0 {
      invokeCallback(.transmitFIFOEmpty)
      return
    }
    if flags & 0x0100_0000 != 0 && cr1 & 0x8000_0000 != 0 {
      invokeCallback(.receiveFIFOFull)
      return
    }
  }

  private func invokeTransmitISR() {
    if handle.read(.txISR) != 0 {
      switch handle.read(.txISR) {
      case UARTISR.byte.rawValue: transmitISR(fifo: false)
      case UARTISR.byteFIFO.rawValue: transmitISR(fifo: true)
      default: preconditionFailure("Invalid SMARTCARD TX ISR")
      }
    }
  }
  private func invokeReceiveISR() {
    if handle.read(.rxISR) != 0 {
      switch handle.read(.rxISR) {
      case UARTISR.byte.rawValue: receiveISR(fifo: false)
      case UARTISR.byteFIFO.rawValue: receiveISR(fifo: true)
      default: preconditionFailure("Invalid SMARTCARD RX ISR")
      }
    }
  }
  private func transmitISR(fifo: Bool) {
    if handle.read(.globalState) == 0x21 {
      var remaining: UInt16 = fifo ? handle.read(.txDataToProcess) : 1
      while remaining > 0 {
        if handle.read(.transmitCount) == 0 {
          modify(.cr1, clear: 0x80, set: 0)
          enableInterrupt(handle.read(.transmitCompletionIndication))
        } else if !fifo || registers.read(.isr) & 0x80 != 0 {
          registers.write(.tdr, value: UInt32(handle.readPointer(.transmit)!.load(as: UInt8.self)))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 1))
          handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
        }
        remaining &-= 1
      }
    }
  }
  private func receiveISR(fifo: Bool) {
    if handle.read(.receiveState) == 0x22 {
      var remaining: UInt16 = fifo ? handle.read(.rxDataToProcess) : 1
      while remaining > 0 {
        handle.readPointer(.receive)!.storeBytes(
          of: UInt8(truncatingIfNeeded: registers.read(.rdr)), as: UInt8.self)
        handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
        handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
        if handle.read(.receiveCount) == 0 {
          modify(.cr1, clear: 0x20, set: 0)
          if handle.read(.globalState) == 0x20 { modify(.cr3, clear: 1, set: 0) }
          modify(.cr1, clear: 0x100, set: 0)
          handle.write(.receiveState, value: 0x20)
          handle.write(.rxISR, value: 0)
          invokeCallback(.receiveComplete)
        }
        remaining &-= 1
      }
      if fifo {
        let count = handle.read(.receiveCount)
        if count != 0 && count < handle.read(.rxDataToProcess) {
          modify(.cr3, clear: 0x1000_0000, set: 0)
          handle.write(.rxISR, value: UARTISR.byte.rawValue)
          modify(.cr1, clear: 0, set: 0x20)
        }
      }
    } else {
      sendRequest(8)
    }
  }
  private func endTransmitInterrupt() {
    disableInterrupt(handle.read(.transmitCompletionIndication))
    if handle.read(.receiveState) == 0x20 { modify(.cr3, clear: 1, set: 0) }
    disable()
    if handle.read(.mode) == 8 && handle.read(.nackEnable) == 0x10 {
      modify(.cr1, clear: 4, set: 0)
    }
    if handle.read(.mode) == 12 || handle.read(.nackEnable) == 0x10 { flushDataRegisters() }
    enable()
    handle.write(.globalState, value: 0x20)
    handle.write(.txISR, value: 0)
    invokeCallback(.transmitComplete)
  }
  func endTransmitTransfer() {
    modify(.cr1, clear: 0xC0, set: 0)
    modify(.cr3, clear: 1, set: 0)
    handle.write(.globalState, value: 0x20)
  }
  func endReceiveTransfer() {
    modify(.cr1, clear: 0x120, set: 0)
    modify(.cr3, clear: 1, set: 0)
    handle.write(.receiveState, value: 0x20)
  }
}
