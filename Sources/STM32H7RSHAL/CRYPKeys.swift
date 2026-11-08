// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  func setKey(_ keySize: UInt32) {
    if hasCRYP && isCRYP {
      switch keySize {
      case 0x200:
        registers.write(.k0lr, value: handle.readPointer(.key)![0])
        registers.write(.k0rr, value: handle.readPointer(.key)![1])
        registers.write(.k1lr, value: handle.readPointer(.key)![2])
        registers.write(.k1rr, value: handle.readPointer(.key)![3])
        registers.write(.k2lr, value: handle.readPointer(.key)![4])
        registers.write(.k2rr, value: handle.readPointer(.key)![5])
        registers.write(.k3lr, value: handle.readPointer(.key)![6])
        registers.write(.k3rr, value: handle.readPointer(.key)![7])
      case 0x100:
        registers.write(.k1lr, value: handle.readPointer(.key)![0])
        registers.write(.k1rr, value: handle.readPointer(.key)![1])
        registers.write(.k2lr, value: handle.readPointer(.key)![2])
        registers.write(.k2rr, value: handle.readPointer(.key)![3])
        registers.write(.k3lr, value: handle.readPointer(.key)![4])
        registers.write(.k3rr, value: handle.readPointer(.key)![5])
      case 0x0:
        registers.write(.k2lr, value: handle.readPointer(.key)![0])
        registers.write(.k2rr, value: handle.readPointer(.key)![1])
        registers.write(.k3lr, value: handle.readPointer(.key)![2])
        registers.write(.k3rr, value: handle.readPointer(.key)![3])
      default: break
      }
    }
    if hasSAES && isSAES { setExtendedKey(keySize) }
  }

  func loadInitialVector() {
    if hasCRYP && isCRYP {
      registers.write(.iv0lr, value: handle.readPointer(.initialVector)![0])
      registers.write(.iv0rr, value: handle.readPointer(.initialVector)![1])
      registers.write(.iv1lr, value: handle.readPointer(.initialVector)![2])
      registers.write(.iv1rr, value: handle.readPointer(.initialVector)![3])
    }
    if hasSAES && isSAES {
      registers.write(.ivr3, value: handle.readPointer(.initialVector)![0])
      registers.write(.ivr2, value: handle.readPointer(.initialVector)![1])
      registers.write(.ivr1, value: handle.readPointer(.initialVector)![2])
      registers.write(.ivr0, value: handle.readPointer(.initialVector)![3])
    }
  }
}
