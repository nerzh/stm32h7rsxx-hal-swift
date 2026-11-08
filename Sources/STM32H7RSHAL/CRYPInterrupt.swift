// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  public func handleInterrupt() {
    if hasCRYP && isCRYP {
      let status = registers.read(.misr)
      if status & 3 != 0 {
        let algorithm = handle.read(.algorithm)
        if algorithm == 0x20 || algorithm == 0x28 || algorithm == 0x30 {
          aesInterrupt()
        } else if algorithm == 0x80000 || algorithm == 0x80008 {
          if registers.read(.cr) & 0x10000 == 0x10000 {
            authenticationHeaderInterrupt()
          } else {
            authenticationPayloadInterrupt()
          }
        }
      }
    }
    if hasSAES && isSAES {
      if getInterruptSource(2) {
        if getFlag(0x8000_0004) {
          addError(1)
          clearFlags(2)
        }
        if getFlag(0x8000_0002) {
          addError(2)
          clearFlags(2)
        }
        // The C IRQ calls the weak callback directly, even with registered callbacks.
        defaults.error(callbacks.context)
      }
      if getInterruptSource(4) {
        if getFlag(4) {
          addError(0x100)
          clearFlags(4)
          defaults.error(callbacks.context)
        }
      }
      if getInterruptSource(8) {
        if getFlag(8) {
          addError(0x200)
          defaults.error(callbacks.context)
          clearFlags(8)
        }
      }
      if getFlag(1) {
        if getInterruptSource(1) {
          clearFlags(1)
          if handle.read(.algorithm) == 0x80000 || handle.read(.algorithm) == 0x80008 {
            if registers.read(.cr) & 0x2000 == 0x2000 {
              authenticationHeaderInterrupt()
            } else {
              authenticationPayloadInterrupt()
            }
          } else {
            aesInterrupt()
          }
        }
      }
    }
  }
}
