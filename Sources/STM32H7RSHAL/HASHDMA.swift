// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// DMA functions from stm32h7rsxx_hal_hash.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HASH {
  @discardableResult
  public func startDMA(inputAddress: UInt32, size: UInt32, outputAddress: UInt32) -> HALStatus {
    let state = handle.read(.state)
    guard state == 1 || state == 3 else { return .busy }
    guard tryLock() else { return .busy }
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      handle.write(.inputCount, value: 0)
      handle.write(.inputAddress, value: inputAddress)
      handle.write(.outputAddress, value: outputAddress)
      handle.write(.inputCount, value: 0)
      handle.write(.size, value: size)
      if handle.read(.phase) == 1 {
        modify(.cr, clear: 0x40)
        modify(.cr, clear: 4, set: 4)
        handle.write(.phase, value: 2)
      }
      if registers.read(.cr) & 0x2000 == 0 {
        modify(.str, clear: 0x1F, set: 8 &* (handle.read(.size) % 4))
      } else { modify(.str, clear: 0x1F) }
    } else {
      handle.write(.state, value: 2)
      handle.write(.size, value: handle.read(.inputCount))
    }
    dma.writeCallback(.transferComplete, value: dma.callback(.inputComplete))
    dma.writeCallback(.error, value: dma.callback(.error))
    // On resume, C uses the argument for normal DMA but the saved handle
    // address for a linked-list channel. Keep these two sources distinct.
    let status = startInputDMA(normalInputAddress: { inputAddress })
    if status != .ok {
      addError(2)
      invokeCallback(.error)
    } else { modify(.cr, set: 8) }
    return status
  }
  @discardableResult
  public func startHMACDMA(inputAddress: UInt32, size: UInt32, outputAddress: UInt32) -> HALStatus {
    if handle.read(.state) == 1 {
      guard tryLock() else { return .busy }
      handle.write(.state, value: 2)
      handle.write(.inputAddress, value: inputAddress)
      handle.write(.outputAddress, value: outputAddress)
      handle.write(.keyBufferAddress, value: handle.read(.keyAddress))
      handle.write(.inputCount, value: 0)
      handle.write(.size, value: size)
      if handle.read(.phase) == 1 {
        initializeHMACCore()
        handle.write(.phase, value: 3)
        modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
        writeData(inputAddress: handle.read(.keyAddress), size: handle.read(.keySize))
        modify(.str, set: 0x100)
        // C waits for BUSY to become set. Preemption can miss this short pulse;
        // interrupt masking remains the caller's responsibility.
        var count: UInt32 = 1000
        repeat {
          count &-= 1
          if count == 0 {
            addError(4)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
        } while registers.read(.sr) & 8 == 0
      }
      handle.write(.phase, value: 4)
      if registers.read(.cr) & 0x2000 == 0 {
        modify(.str, clear: 0x1F, set: 8 &* (handle.read(.size) % 4))
      } else { modify(.str, clear: 0x1F) }
    } else if handle.read(.state) == 3 {
      guard tryLock() else { return .busy }
      handle.write(.state, value: 2)
      handle.write(.size, value: handle.read(.inputCount))
    } else { return .busy }
    dma.writeCallback(.transferComplete, value: dma.callback(.inputComplete))
    dma.writeCallback(.error, value: dma.callback(.error))
    let status = startInputDMA(normalInputAddress: { handle.read(.inputAddress) })
    if status != .ok {
      addError(2)
      invokeCallback(.error)
    } else { modify(.cr, set: 8) }
    return status
  }
  public func handleDMAEvent(_ kind: HASHDMACallbackKind) {
    switch kind {
    case .inputComplete: dmaTransferComplete()
    case .error:
      addError(2)
      handle.write(.state, value: 1)
      invokeCallback(.error)
    }
  }
  func startInputDMA(normalInputAddress: () -> UInt32) -> HALStatus {
    if dma.read(.mode) & 0x80 == 0x80 {
      if dma.read(.queueAddress) != 0 && dma.readMemory32(at: dma.read(.queueAddress)) != 0 {
        dma.writeMemory32(at: dmaHead() &+ 8, value: roundedDMAByteCount())
        dma.writeMemory32(at: dmaHead() &+ 12, value: handle.read(.inputAddress))
        dma.writeMemory32(at: dmaHead() &+ 16, value: registers.address(of: .din))
        return dma.startLinkedListInterrupt()
      }
      return .error
    }
    return dma.startInterrupt(sourceAddress: normalInputAddress(), destinationAddress: registers.address(of: .din),
                              sourceDataSize: roundedDMAByteCount())
  }
  func dmaHead() -> UInt32 { dma.readMemory32(at: dma.read(.queueAddress)) }
  func roundedDMAByteCount() -> UInt32 {
    if handle.read(.size) % 4 != 0 { return handle.read(.size) &+ (4 &- (handle.read(.size) % 4)) }
    return handle.read(.size)
  }
  func dmaTransferComplete() {
    if registers.read(.cr) & 0x40 == 0 {
      if registers.read(.cr) & 0x2000 == 0 {
        modify(.cr, clear: 8)
        var count: UInt32 = 1000
        repeat {
          count &-= 1
          if count == 0 {
            addError(4)
            handle.write(.state, value: 1)
            unlock()
            invokeCallback(.error)
            // C continues the loop after the callback; count may wrap.
          }
        } while registers.read(.sr) & 2 == 0
        invokeCallback(.inputComplete)
        getDigest(outputAddress: handle.read(.outputAddress), size: digestLength())
        handle.write(.state, value: 1)
        handle.write(.phase, value: 1)
        unlock()
        invokeCallback(.digestComplete)
      } else {
        handle.write(.state, value: 1)
        unlock()
      }
    } else {
      if handle.read(.phase) == 4 {
        if registers.read(.cr) & 0x2000 == 0 {
          handle.write(.phase, value: 5)
          modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
          writeData(inputAddress: handle.read(.keyAddress), size: handle.read(.keySize))
          modify(.str, set: 0x100)
          var count: UInt32 = 1000
          repeat {
            count &-= 1
            if count == 0 {
              modify(.cr, clear: 8)
              addError(2)
              handle.write(.state, value: 1)
              unlock()
              invokeCallback(.error)
              // This C branch reports DMA (not TIMEOUT) and keeps waiting.
            }
          } while registers.read(.sr) & 2 == 0
          getDigest(outputAddress: handle.read(.outputAddress), size: digestLength())
          handle.write(.state, value: 1)
          handle.write(.phase, value: 1)
          unlock()
          invokeCallback(.digestComplete)
        } else {
          handle.write(.state, value: 1)
          unlock()
          handle.write(.accumulation, value: 1)
        }
      }
    }
  }
}
