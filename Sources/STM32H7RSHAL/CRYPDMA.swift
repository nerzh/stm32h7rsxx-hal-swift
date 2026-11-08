// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func setDMAConfiguration(inputAddress: UInt32, size: UInt16, outputAddress: UInt32) {
    var status: HALStatus
    var peripheralInput: UInt32 = 0
    var peripheralOutput: UInt32 = 0
    dma.writeCallback(.input, id: .transferComplete, value: dma.callback(.inputComplete))
    dma.writeCallback(.input, id: .error, value: dma.callback(.error))
    dma.writeCallback(.output, id: .transferComplete, value: dma.callback(.outputComplete))
    dma.writeCallback(.output, id: .error, value: dma.callback(.error))
    enable()
    if hasCRYP && isCRYP {
      peripheralInput = registers.address(of: .din)
      peripheralOutput = registers.address(of: .dout)
    }
    if hasSAES && isSAES {
      peripheralInput = registers.address(of: .dinr)
      peripheralOutput = registers.address(of: .doutr)
    }
    if dma.read(.input, word: .mode) & 0x80 == 0x80 {
      if dma.read(.input, word: .queueAddress) != 0
        && dma.readMemory32(.input, at: dma.read(.input, word: .queueAddress)) != 0
      {
        dma.writeMemory32(
          .input, at: dma.readMemory32(.input, at: dma.read(.input, word: .queueAddress)) &+ 8,
          value: UInt32(size))
        dma.writeMemory32(
          .input, at: dma.readMemory32(.input, at: dma.read(.input, word: .queueAddress)) &+ 12,
          value: inputAddress)
        dma.writeMemory32(
          .input, at: dma.readMemory32(.input, at: dma.read(.input, word: .queueAddress)) &+ 16,
          value: peripheralInput)
        status = dma.startLinkedListInterrupt(.input)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        .input, sourceAddress: inputAddress, destinationAddress: peripheralInput,
        sourceDataSize: UInt32(size))
    }
    if status != .ok {
      addError(0x4)
      invoke(.error)
    }
    if dma.read(.output, word: .mode) & 0x80 == 0x80 {
      if dma.read(.output, word: .queueAddress) != 0
        && dma.readMemory32(.output, at: dma.read(.output, word: .queueAddress)) != 0
      {
        dma.writeMemory32(
          .output, at: dma.readMemory32(.output, at: dma.read(.output, word: .queueAddress)) &+ 8,
          value: UInt32(size))
        dma.writeMemory32(
          .output, at: dma.readMemory32(.output, at: dma.read(.output, word: .queueAddress)) &+ 12,
          value: peripheralOutput)
        dma.writeMemory32(
          .output, at: dma.readMemory32(.output, at: dma.read(.output, word: .queueAddress)) &+ 16,
          value: outputAddress)
        status = dma.startLinkedListInterrupt(.output)
      } else {
        status = .error
      }
    } else {
      status = dma.startInterrupt(
        .output, sourceAddress: peripheralOutput, destinationAddress: outputAddress,
        sourceDataSize: UInt32(size))
    }
    if status != .ok {
      addError(0x4)
      invoke(.error)
    }
    if hasCRYP && isCRYP { registers.write(.dmacr, value: 0x2 | 0x1) }
    if hasSAES && isSAES { modify(.cr, set: 0x800 | 0x1000) }
  }
  public func dmaInputComplete() {
    if hasCRYP && isCRYP { modify(.dmacr, clear: 0x1) }
    if hasSAES && isSAES { modify(.cr, clear: 0x800) }
    invoke(.inputComplete)
  }
  public func dmaError() {
    handle.write(.state, value: 1)
    addError(0x4)
    invoke(.error)
  }
  func aesDecryptDMA(getTick: () -> UInt32) -> HALStatus {
    var doKeyIVConfiguration: UInt32 = 1
    if handle.read(.keyIVConfigurationSkip) == 0x1 {
      if handle.read(.keyIVConfiguration) == 1 {
        doKeyIVConfiguration = 0
      } else {
        handle.write(.keyIVConfiguration, value: 1)
      }
    }
    if doKeyIVConfiguration == 1 {
      if handle.read(.algorithm) != 0x30 {
        if hasCRYP && isCRYP {
          modify(.cr, clear: 0x80038, set: 0x38)
          if handle.read(.keyIVConfigurationSkip) != 0x2 {
            if handle.read(.keyMode) != 0x2000000 {
              setKey(handle.read(.keySize))
            } else {
              modify(.cr, clear: 0x2000000)
            }
          }
          enable()
          if waitOnBusy(timeout: 500, getTick: getTick) != .ok {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
          modify(.cr, clear: 0x80038, set: handle.read(.algorithm))
        }
        if hasSAES && isSAES {
          if registers.read(.cr) & (0x1000000 | 0x2000000) != 0 {
            modify(.cr, clear: 0x3000000, set: 0x0)
          }
          modify(.cr, clear: 0x18, set: 0x8)
          if handle.read(.keySelection) == 0x0 && handle.read(.keyMode) == 0x0 {
            if handle.read(.keyIVConfigurationSkip) != 0x2 { setKey(handle.read(.keySize)) }
          }
          enable()
          if waitOnComputationComplete(timeout: 500, getTick: getTick) != .ok {
            disable()
            addError(0x10)
            handle.write(.state, value: 1)
            unlock()
            return .error
          }
          clearFlags(0x1)
          modify(.cr, clear: 0x18, set: 0x10)
        }
      } else {
        if hasCRYP && isCRYP {
          if handle.read(.keyIVConfigurationSkip) != 0x2 {
            if handle.read(.keyMode) != 0x2000000 {
              setKey(handle.read(.keySize))
            } else {
              modify(.cr, clear: 0x2000000)
            }
          }
        }
        if hasSAES && isSAES { setKey(handle.read(.keySize)) }
      }
      if handle.read(.algorithm) != 0x20 { loadInitialVector() }
    }
    handle.write(.phase, value: 2)
    if handle.read(.size) != 0 {
      setDMAConfiguration(
        inputAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.input))),
        size: handle.read(.size),
        outputAddress: UInt32(truncatingIfNeeded: UInt(bitPattern: handle.readPointer(.output))))
    } else {
      unlock()
      handle.write(.state, value: 1)
    }
    return .ok
  }
}
