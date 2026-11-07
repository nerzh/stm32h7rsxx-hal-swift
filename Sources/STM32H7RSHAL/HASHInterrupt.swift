// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Interrupt functions from stm32h7rsxx_hal_hash.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HASH {
  @discardableResult
  public func startInterrupt(inputAddress: UInt32, size: UInt32, outputAddress: UInt32) -> HALStatus {
    let state = handle.read(.state)
    guard state == 1 || state == 3 else { return .busy }
    guard tryLock() else { return .busy }
    if handle.read(.state) == 1 {
      handle.write(.inputCount, value: 0)
      handle.write(.inputAddress, value: inputAddress)
      handle.write(.outputAddress, value: outputAddress)
      handle.write(.size, value: size)
      modify(.cr, clear: 0x40)
      modify(.cr, clear: 4, set: 4)
      modify(.str, clear: 0x1F, set: 8 &* (size % 4))
    }
    handle.write(.state, value: 2)
    handle.write(.phase, value: 2)
    // C enables IRQs before the first synchronous feed. The caller controls
    // serialization with HASH_IRQHandler; the HAL lock does not mask IRQs.
    enableInterrupts(3)
    return writeDataInterrupt()
  }
  @discardableResult
  public func accumulateInterrupt(inputAddress: UInt32, size: UInt32) -> HALStatus {
    guard size % 4 == 0 else { return .error }
    guard handle.read(.state) == 1 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.inputCount, value: 0)
    handle.write(.size, value: size)
    handle.write(.accumulation, value: 1)
    if handle.read(.phase) == 1 {
      modify(.cr, clear: 0x40)
      modify(.cr, clear: 4, set: 4)
      handle.write(.phase, value: 2)
    }
    enableInterrupts(1)
    let status = writeDataInterrupt()
    // C returns READY after one FIFO window, even if input remains.
    handle.write(.state, value: 1)
    unlock()
    return status
  }
  @discardableResult
  public func accumulateLastInterrupt(inputAddress: UInt32, size: UInt32, outputAddress: UInt32) -> HALStatus {
    guard handle.read(.state) == 1 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.outputAddress, value: outputAddress)
    handle.write(.inputCount, value: 0)
    handle.write(.size, value: size)
    if handle.read(.phase) == 1 {
      modify(.cr, clear: 0x40)
      modify(.cr, clear: 4, set: 4)
      handle.write(.phase, value: 2)
    }
    modify(.str, clear: 0x1F, set: 8 &* (size % 4))
    enableInterrupts(3)
    let status = writeDataInterrupt()
    // Preserve C's unconditional READY transition after the initial feed.
    handle.write(.state, value: 1)
    handle.write(.phase, value: 1)
    unlock()
    return status
  }
  @discardableResult
  public func startHMACInterrupt(inputAddress: UInt32, size: UInt32, outputAddress: UInt32) -> HALStatus {
    if handle.read(.state) == 1 {
      guard tryLock() else { return .busy }
      handle.write(.state, value: 2)
      handle.write(.phase, value: 1)
      handle.write(.inputAddress, value: inputAddress)
      handle.write(.outputAddress, value: outputAddress)
      handle.write(.keyBufferAddress, value: handle.read(.keyAddress))
      handle.write(.inputCount, value: 0)
      handle.write(.size, value: size)
      initializeHMACCore()
      modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
      handle.write(.phase, value: 2)
    } else if handle.read(.state) == 3 {
      guard tryLock() else { return .busy }
      handle.write(.state, value: 2)
    } else { return .busy }
    let status = writeDataInterrupt()
    enableInterrupts(3)
    return status
  }
  @discardableResult
  public func accumulateHMACInterrupt(inputAddress: UInt32, size: UInt32) -> HALStatus {
    guard size % 4 == 0 else { return .error }
    guard handle.read(.state) == 1 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.keyBufferAddress, value: handle.read(.keyAddress))
    handle.write(.inputCount, value: 0)
    handle.write(.size, value: size)
    handle.write(.accumulation, value: 1)
    if handle.read(.phase) == 1 {
      initializeHMACCore()
      modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
      handle.write(.phase, value: 2)
    }
    let status = writeDataInterrupt()
    enableInterrupts(3)
    return status
  }
  @discardableResult
  public func accumulateHMACLastInterrupt(inputAddress: UInt32, size: UInt32, outputAddress: UInt32) -> HALStatus {
    guard handle.read(.state) == 1 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.outputAddress, value: outputAddress)
    handle.write(.keyBufferAddress, value: handle.read(.keyAddress))
    handle.write(.inputCount, value: 0)
    handle.write(.size, value: size)
    handle.write(.accumulation, value: 0)
    let status = writeDataInterrupt()
    enableInterrupts(3)
    return status
  }
  public func handleInterrupt() {
    let source = registers.read(.imr)
    let flags = registers.read(.sr)
    // The original DCIS branch does not test IMR.DCIE.
    if flags & 2 == 2 {
      getDigest(outputAddress: handle.read(.outputAddress), size: digestLength())
      disableInterrupts(3)
      handle.write(.state, value: 1)
      handle.write(.phase, value: 1)
      unlock()
      invokeCallback(.digestComplete)
    }
    if flags & 1 == 1 && flags & 2 != 2 {
      if source & 1 == 1 {
        if writeDataInterrupt() != .ok { invokeCallback(.error) }
      }
    }
  }

  func writeDataInterrupt() -> HALStatus {
    var keyAddress = handle.read(.keyBufferAddress)
    var inputAddress = handle.read(.inputAddress)
    // Preserve the unmasked SR shift from the C implementation.
    let partialByteCount = (registers.read(.sr) >> 16) &* 4
    if handle.read(.state) == 2 {
      if registers.read(.cr) & 0x40 == 0 {
        if useSuspendResume && handle.read(.suspendRequest) == 1 {
          suspendInterruptProcessing()
        } else {
          if handle.read(.inputCount) &+ partialByteCount < handle.read(.size) {
            var counter: UInt32 = 0
            while counter < partialByteCount {
              registers.write(.din, value: memory.read32(at: inputAddress))
              inputAddress &+= 4
              handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
              handle.write(.inputAddress, value: handle.read(.inputAddress) &+ 4)
              counter &+= 4
            }
            if waitForInterruptFlag(1) != .ok { return .error }
          } else {
            while handle.read(.inputCount) < handle.read(.size) {
              registers.write(.din, value: memory.read32(at: inputAddress))
              inputAddress &+= 4
              handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
              handle.write(.inputAddress, value: handle.read(.inputAddress) &+ 4)
            }
            invokeCallback(.inputComplete)
            if handle.read(.accumulation) == 0 {
              if getInterruptSource(1) != 0 {
                modify(.str, set: 0x100)
                if waitForInterruptFlag(2) != .ok { return .error }
              }
            } else {
              handle.write(.accumulation, value: 0)
              disableInterrupts(1)
            }
          }
        }
      } else {
        if handle.read(.phase) == 4 {
          if useSuspendResume && handle.read(.suspendRequest) == 1 {
            suspendInterruptProcessing()
          } else {
            if handle.read(.accumulation) == 1 { modify(.str, clear: 0x1F) }
            else { modify(.str, clear: 0x1F, set: 8 &* (handle.read(.size) % 4)) }
            if handle.read(.inputCount) &+ partialByteCount < handle.read(.size) {
              var counter: UInt32 = 0
              while counter < partialByteCount {
                registers.write(.din, value: memory.read32(at: inputAddress))
                inputAddress &+= 4
                handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
                handle.write(.inputAddress, value: handle.read(.inputAddress) &+ 4)
                counter &+= 4
              }
              if waitForInterruptFlag(1) != .ok { return .error }
            } else {
              while handle.read(.inputCount) < handle.read(.size) {
                registers.write(.din, value: memory.read32(at: inputAddress))
                inputAddress &+= 4
                handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
                handle.write(.inputAddress, value: handle.read(.inputAddress) &+ 4)
              }
              invokeCallback(.inputComplete)
              if handle.read(.accumulation) == 0 {
                if getInterruptSource(1) != 0 {
                  modify(.str, set: 0x100)
                  if waitForInterruptFlag(8, whileSet: true) != .ok { return .error }
                  handle.write(.phase, value: 5)
                  handle.write(.inputCount, value: 0)
                  handle.write(.keyBufferAddress, value: handle.read(.keyAddress))
                }
              } else {
                disableInterrupts(3)
                handle.write(.state, value: 1)
                unlock()
                return .ok
              }
            }
          }
        } else if handle.read(.phase) == 5 {
          modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
          if handle.read(.inputCount) &+ partialByteCount < handle.read(.keySize) {
            var counter: UInt32 = 0
            while counter < partialByteCount {
              registers.write(.din, value: memory.read32(at: keyAddress))
              keyAddress &+= 4
              handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
              handle.write(.keyBufferAddress, value: handle.read(.keyBufferAddress) &+ 4)
              counter &+= 4
            }
            if waitForInterruptFlag(1) != .ok { return .error }
          } else {
            while handle.read(.inputCount) < handle.read(.keySize) {
              registers.write(.din, value: memory.read32(at: keyAddress))
              keyAddress &+= 4
              handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
              // Unlike HMAC step 1, C does not advance pHashKeyBuffPtr here.
            }
            modify(.str, set: 0x100)
            if waitForInterruptFlag(2) != .ok { return .error }
          }
        } else {
          handle.write(.phase, value: 3)
          if handle.read(.inputCount) &+ partialByteCount < handle.read(.keySize) {
            var counter: UInt32 = 0
            while counter < partialByteCount {
              registers.write(.din, value: memory.read32(at: keyAddress))
              keyAddress &+= 4
              handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
              handle.write(.keyBufferAddress, value: handle.read(.keyBufferAddress) &+ 4)
              counter &+= 4
            }
            if waitForInterruptFlag(1) != .ok { return .error }
          } else {
            while handle.read(.inputCount) < handle.read(.keySize) {
              registers.write(.din, value: memory.read32(at: keyAddress))
              keyAddress &+= 4
              handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
              handle.write(.keyBufferAddress, value: handle.read(.keyBufferAddress) &+ 4)
            }
            modify(.str, set: 0x100)
            if waitForInterruptFlag(8, whileSet: true) != .ok { return .error }
            handle.write(.phase, value: 4)
            handle.write(.inputCount, value: 0)
          }
        }
      }
    } else if handle.read(.state) == 3 { return .ok }
    else {
      addError(1)
      invokeCallback(.error)
    }
    return .ok
  }
  func suspendInterruptProcessing() {
    handle.write(.suspendRequest, value: 0)
    disableInterrupts(3)
    handle.write(.state, value: 3)
    unlock()
  }
  func waitForInterruptFlag(_ flag: UInt32, whileSet: Bool = false) -> HALStatus {
    var count: UInt32 = 1000
    repeat {
      count &-= 1
      if count == 0 {
        disableInterrupts(3)
        addError(4)
        handle.write(.state, value: 1)
        unlock()
        return .error
      }
    } while (registers.read(.sr) & flag != 0) == whileSet
    return .ok
  }
}
