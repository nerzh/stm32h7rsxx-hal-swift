// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  public func processSuspend() { handle.write(.suspendRequest, value: 1) }
  public func dmaProcessSuspend(getTick: () -> UInt32) -> HALStatus {
    if hasCRYP && isCRYP {
      modify(.dmacr, clear: 1)
      while registers.read(.sr) & (1 | 4 | 0x10) != 1 {}
      modify(.dmacr, clear: 2)
      disable()
    }
    if hasSAES && isSAES {
      modify(.cr, clear: 0x800)
      if waitOnComputationComplete(timeout: 500, getTick: getTick) != .ok {
        disable()
        addError(0x10)
        handle.write(.state, value: 1)
        unlock()
        invoke(.error)
      }
      modify(.cr, clear: 0x1000)
      clearFlags(1)
    }
    var remaining = dma.getCounter(.input) / 4
    remaining &+= dma.getFIFOLevel(.input)
    if dma.abort(.input, getTick: getTick) != .ok { return .error }
    if dma.abort(.output, getTick: getTick) != .ok { return .error }
    let initial = UInt32(handle.read(.size)) / 4
    handle.writePointer(
      .input, value: handle.readPointer(.input)!.advanced(by: Int(initial &- remaining)))
    handle.writePointer(
      .output, value: handle.readPointer(.output)!.advanced(by: Int(initial &- remaining)))
    handle.write(.inputCount, value: UInt16(truncatingIfNeeded: remaining))
    handle.write(.outputCount, value: UInt16(truncatingIfNeeded: remaining))
    handle.write(.state, value: 3)
    return .ok
  }
  public func suspend(getTick: () -> UInt32) -> HALStatus {
    let saesInputDMA = registers.read(.cr) & 0x800
    if (registers.read(.dmacr) & 1 == 1 && isCRYP) || (saesInputDMA == 0x800 && isSAES) {
      if dmaProcessSuspend(getTick: getTick) != .ok { return .error }
      handle.write(.suspendedProcessing, value: 1)
    } else {
      processSuspend()
      handle.write(.suspendedProcessing, value: 0)
    }
    var state: UInt32
    repeat { state = getState() } while state != 3 && state != 1
    handle.write(.suspendRequest, value: 0)
    if getState() == 1 { return .error }
    if handle.read(.algorithm) == 0x28 || handle.read(.algorithm) == 0x30
      || handle.read(.algorithm) == 0x80000 || handle.read(.algorithm) == 0x80008
    {
      readInitialVector(handle.savedWords(.initialVector))
    }
    if hasCRYP && isCRYP {
      handle.write(.savedControl, value: registers.read(.cr))
      if handle.read(.algorithm) == 0x80000 || handle.read(.algorithm) == 0x80008 {
        readContext(handle.savedWords(.context), algorithm: handle.read(.algorithm))
      }
    }
    if hasSAES && isSAES {
      disable()
      registers.write(.keyr7, value: 0)
      registers.write(.keyr6, value: 0)
      registers.write(.keyr5, value: 0)
      registers.write(.keyr4, value: 0)
      registers.write(.keyr3, value: 0)
      registers.write(.keyr2, value: 0)
      registers.write(.keyr1, value: 0)
      registers.write(.keyr0, value: 0)
      handle.write(.savedControl, value: registers.read(.cr))
    }
    handle.write(.dataType, saved: true, value: handle.read(.dataType))
    handle.write(.keySize, saved: true, value: handle.read(.keySize))
    handle.write(.algorithm, saved: true, value: handle.read(.algorithm))
    handle.write(.headerSize, saved: true, value: handle.read(.headerSize))
    handle.write(.dataWidthUnit, saved: true, value: handle.read(.dataWidthUnit))
    handle.write(.headerWidthUnit, saved: true, value: handle.read(.headerWidthUnit))
    handle.write(.keyIVConfigurationSkip, saved: true, value: handle.read(.keyIVConfigurationSkip))
    handle.write(.keyMode, saved: true, value: handle.read(.keyMode))
    handle.write(.keySelection, saved: true, value: handle.read(.keySelection))
    handle.writePointer(.savedKey, value: handle.readPointer(.key))
    handle.writePointer(.savedInitialVector, value: handle.readPointer(.initialVector))
    handle.writePointer(.savedHeader, value: handle.readPointer(.header))
    handle.writePointer(.savedB0, value: handle.readPointer(.b0))
    handle.writePointer(.savedInput, value: handle.readPointer(.input))
    handle.writePointer(.savedOutput, value: handle.readPointer(.output))
    handle.write(.savedInputCount, value: UInt32(handle.read(.inputCount)))
    handle.write(.savedOutputCount, value: UInt32(handle.read(.outputCount)))
    handle.write(.savedPhase, value: UInt32(handle.read(.phase)))
    handle.write(.savedState, value: UInt32(handle.read(.state)))
    handle.write(
      .savedSize,
      value: handle.read(.dataWidthUnit) == 0 ? handle.read(.size) / 4 : handle.read(.size))
    handle.write(.savedSizesSum, value: handle.read(.sizesSum))
    handle.write(.savedHeaderCount, value: handle.read(.headerCount))
    handle.write(.suspendRequest, value: 0)
    return .ok
  }
  func phaseProcessingResume() {
    if handle.read(.phase) == 4 {
      handle.write(.phase, value: 2)
      if hasCRYP && isCRYP { modify(.cr, clear: 0x30000, set: 0x10000) }
      if hasSAES && isSAES { modify(.cr, clear: 0x6000, set: 0x2000) }
      enableInterrupts(1)
      enable()
    } else {
      handle.write(.phase, value: 2)
      if hasCRYP && isCRYP { modify(.cr, clear: 0x30000, set: 0x20000) }
      if hasSAES && isSAES { modify(.cr, clear: 0x6000, set: 0x4000) }
      enableInterrupts(1 | 2)
      enable()
    }
  }
  func readInitialVector(_ buffer: UnsafeMutablePointer<UInt32>) {
    if hasCRYP && isCRYP {
      buffer[0] = registers.read(.iv0lr)
      buffer[1] = registers.read(.iv0rr)
      buffer[2] = registers.read(.iv1lr)
      buffer[3] = registers.read(.iv1rr)
    }
    if hasSAES && isSAES {
      buffer[0] = registers.read(.ivr3)
      buffer[1] = registers.read(.ivr2)
      buffer[2] = registers.read(.ivr1)
      buffer[3] = registers.read(.ivr0)
    }
  }
  func readContext(_ buffer: UnsafeMutablePointer<UInt32>, algorithm: UInt32) {
    for i in 0..<8 {
      buffer[i] = registers.read(CRYPRegister(rawValue: 0x50 + UInt32(i) * 4))
    }
    if algorithm == 0x80000 {
      for i in 8..<16 {
        buffer[i] = registers.read(CRYPRegister(rawValue: 0x50 + UInt32(i) * 4))
      }
    }
  }
  func writeInitialVector(_ buffer: UnsafeMutablePointer<UInt32>) {
    if hasCRYP && isCRYP {
      registers.write(.iv0lr, value: buffer[0])
      registers.write(.iv0rr, value: buffer[1])
      registers.write(.iv1lr, value: buffer[2])
      registers.write(.iv1rr, value: buffer[3])
    }
    if hasSAES && isSAES {
      registers.write(.ivr3, value: buffer[0])
      registers.write(.ivr2, value: buffer[1])
      registers.write(.ivr1, value: buffer[2])
      registers.write(.ivr0, value: buffer[3])
    }
  }
  func writeContext(_ buffer: UnsafeMutablePointer<UInt32>, algorithm: UInt32) {
    for i in 0..<8 {
      registers.write(CRYPRegister(rawValue: 0x50 + UInt32(i) * 4), value: buffer[i])
    }
    if algorithm == 0x80000 {
      for i in 8..<16 {
        registers.write(CRYPRegister(rawValue: 0x50 + UInt32(i) * 4), value: buffer[i])
      }
    }
  }
}
