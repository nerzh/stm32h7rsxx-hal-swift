// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  public func resume(getRevision: () -> UInt32, getTick: () -> UInt32) -> HALStatus {
    if handle.read(.savedState) != 3 { return .error }
    handle.write(.dataType, value: handle.read(.dataType, saved: true))
    handle.write(.keySize, value: handle.read(.keySize, saved: true))
    handle.write(.algorithm, value: handle.read(.algorithm, saved: true))
    handle.write(.headerSize, value: handle.read(.headerSize, saved: true))
    handle.write(.dataWidthUnit, value: handle.read(.dataWidthUnit, saved: true))
    handle.write(.headerWidthUnit, value: handle.read(.headerWidthUnit, saved: true))
    handle.write(.keyIVConfigurationSkip, value: handle.read(.keyIVConfigurationSkip, saved: true))
    handle.write(.keyMode, value: handle.read(.keyMode, saved: true))
    handle.write(.keySelection, value: handle.read(.keySelection, saved: true))
    handle.writePointer(.key, value: handle.readPointer(.savedKey))
    handle.writePointer(.initialVector, value: handle.readPointer(.savedInitialVector))
    handle.writePointer(.header, value: handle.readPointer(.savedHeader))
    handle.writePointer(.b0, value: handle.readPointer(.savedB0))
    handle.write(.state, value: handle.read(.savedState))
    handle.write(.phase, value: handle.read(.savedPhase))
    handle.write(.headerCount, value: handle.read(.savedHeaderCount))
    if handle.read(.algorithm) != 0x20 {
      handle.writePointer(.initialVector, value: handle.savedWords(.initialVector))
    }
    resetHandleState()
    if hasCRYP && isCRYP {
      modify(.cr, set: 0x8000_0000)
      modify(.cr, clear: 0x8000_0000)
    }
    if hasSAES && isSAES {
      modify(.cr, set: 0x8000_0000)
      modify(.cr, clear: 0x8000_0000)
    }
    disable()
    if handle.read(.algorithm) == 0x20 || handle.read(.algorithm) == 0x28
      || handle.read(.algorithm) == 0x30
    {
      _ = initialize(getRevision: getRevision, getTick: getTick)
    } else {
      registers.write(.cr, value: handle.read(.savedControl))
      setKey(handle.read(.keySize))
      writeContext(handle.savedWords(.context), algorithm: handle.read(.algorithm))
      writeInitialVector(handle.savedWords(.initialVector))
      handle.write(.state, value: 1)
    }
    if handle.read(.suspendedProcessing) == 1 {
      if (isCRYP && handle.read(.savedControl) & 4 == 0)
        || (isSAES && handle.read(.savedControl) & 0x18 == 0)
      {
        if encryptDMA(
          input: handle.readPointer(.savedInput),
          size: UInt16(truncatingIfNeeded: handle.read(.savedInputCount)),
          output: handle.readPointer(.savedOutput), getTick: getTick) != .ok
        {
          return .error
        }
      } else {
        if decryptDMA(
          input: handle.readPointer(.savedInput),
          size: UInt16(truncatingIfNeeded: handle.read(.savedInputCount)),
          output: handle.readPointer(.savedOutput), getTick: getTick) != .ok
        {
          return .error
        }
      }
    } else {
      handle.write(.resumingFlag, value: 1)
      if (isCRYP && handle.read(.savedControl) & 4 == 0)
        || (isSAES && handle.read(.savedControl) & 0x18 == 0)
      {
        if encryptInterrupt(
          input: handle.readPointer(.savedInput), size: handle.read(.savedSize),
          output: handle.readPointer(.savedOutput), getTick: getTick) != .ok
        {
          return .error
        }
      } else {
        if decryptInterrupt(
          input: handle.readPointer(.savedInput), size: handle.read(.savedSize),
          output: handle.readPointer(.savedOutput), getTick: getTick) != .ok
        {
          return .error
        }
      }
    }
    return .ok
  }
}
