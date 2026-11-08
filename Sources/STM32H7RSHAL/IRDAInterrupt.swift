// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// IRDA operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension IRDA {

  @discardableResult
  public func transmitInterrupt(_ data: UnsafeRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.globalState) != 0x20 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.transmit, value: UnsafeMutableRawPointer(mutating: data))
    handle.write(.transmitSize, value: size)
    handle.write(.transmitCount, value: size)
    handle.write(.errorCode, value: 0)
    handle.write(.globalState, value: 0x21)
    unlock()
    modify(.cr1, clear: 0, set: 0x80)
    return .ok
  }
  @discardableResult
  public func receiveInterrupt(_ data: UnsafeMutableRawPointer?, size: UInt16) -> HALStatus {
    if handle.read(.receiveState) != 0x20 { return .busy }
    guard let data, size != 0 else { return .error }
    if !tryLock() { return .busy }
    handle.writePointer(.receive, value: data)
    handle.write(.receiveSize, value: size)
    handle.write(.receiveCount, value: size)
    computeMask()
    handle.write(.errorCode, value: 0)
    handle.write(.receiveState, value: 0x22)
    unlock()
    if handle.read(.parity) != 0 {
      modify(.cr1, clear: 0, set: 0x120)
    } else {
      modify(.cr1, clear: 0, set: 0x20)
    }
    modify(.cr3, clear: 0, set: 1)
    return .ok
  }
  public func handleInterrupt() {
    let flags = registers.read(.isr)
    let cr1 = registers.read(.cr1)
    let errors = flags & 0xF
    if errors == 0 {
      if flags & 0x20 != 0 && cr1 & 0x20 != 0 {
        receiveISR()
        return
      }
    }
    let cr3 = registers.read(.cr3)
    if errors != 0 && (cr3 & 1 != 0 || cr1 & 0x120 != 0) {
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
      if flags & 8 != 0 && (cr1 & 0x20 != 0 || cr3 & 1 != 0) {
        clearFlag(8)
        handle.write(.errorCode, value: handle.read(.errorCode) | 8)
      }
      if handle.read(.errorCode) != 0 {
        if flags & 0x20 != 0 && cr1 & 0x20 != 0 { receiveISR() }
        let error = handle.read(.errorCode)
        if registers.read(.cr3) & 0x40 == 0x40 || error & 8 != 0 {
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
        } else {
          invokeCallback(.error)
          handle.write(.errorCode, value: 0)
        }
      }
      return
    }
    if flags & 0x80 != 0 && cr1 & 0x80 != 0 {
      transmitISR()
      return
    }
    if flags & 0x40 != 0 && cr1 & 0x40 != 0 {
      modify(.cr1, clear: 0x40, set: 0)
      handle.write(.globalState, value: 0x20)
      invokeCallback(.transmitComplete)
      return
    }
  }
  private func transmitISR() {
    if handle.read(.globalState) == 0x21 {
      if handle.read(.transmitCount) == 0 {
        modify(.cr1, clear: 0x80, set: 0)
        modify(.cr1, clear: 0, set: 0x40)
      } else {
        if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
          let pointer = handle.readPointer(.transmit)!
          registers.write(.tdr, value: UInt32(pointer.load(as: UInt16.self) & 0x1FF))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 2))
        } else {
          registers.write(.tdr, value: UInt32(handle.readPointer(.transmit)!.load(as: UInt8.self)))
          handle.writePointer(.transmit, value: handle.readPointer(.transmit)!.advanced(by: 1))
        }
        handle.write(.transmitCount, value: handle.read(.transmitCount) &- 1)
      }
    }
  }
  private func receiveISR() {
    let mask = handle.read(.mask)
    if handle.read(.receiveState) == 0x22 {
      let data = UInt16(truncatingIfNeeded: registers.read(.rdr))
      if handle.read(.wordLength) == 0x1000 && handle.read(.parity) == 0 {
        handle.readPointer(.receive)!.storeBytes(of: data & mask, as: UInt16.self)
        handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 2))
      } else {
        handle.readPointer(.receive)!.storeBytes(
          of: UInt8(truncatingIfNeeded: data) & UInt8(truncatingIfNeeded: mask), as: UInt8.self)
        handle.writePointer(.receive, value: handle.readPointer(.receive)!.advanced(by: 1))
      }
      handle.write(.receiveCount, value: handle.read(.receiveCount) &- 1)
      if handle.read(.receiveCount) == 0 {
        modify(.cr1, clear: 0x120, set: 0)
        modify(.cr3, clear: 1, set: 0)
        handle.write(.receiveState, value: 0x20)
        invokeCallback(.receiveComplete)
      }
    } else {
      sendRequest(8)
    }
  }
  func endTransmitTransfer() {
    modify(.cr1, clear: 0xC0, set: 0)
    handle.write(.globalState, value: 0x20)
  }
  func endReceiveTransfer() {
    modify(.cr1, clear: 0x120, set: 0)
    modify(.cr3, clear: 1, set: 0)
    handle.write(.receiveState, value: 0x20)
  }

}
