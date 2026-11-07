// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause AND Apache-2.0
// Programming helpers from stm32h7rsxx_hal_flash.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748. Address limits from CMSIS device
// 7e6e213ddc397c76622a0aca2f623ccc3b34c010, identical on H7R3/R7/S3/S7.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt and
// LICENSES/STM32H7RSxx-CMSIS-Apache-2.0.txt.

extension Flash {
  func performProgramming(type: UInt32, address: UInt32, dataAddress: UInt32) -> HALStatus {
    switch type {
    case FlashProgramType.byte.rawValue:
      programByte(address: address, dataAddress: dataAddress)
    case FlashProgramType.halfWord.rawValue:
      programHalfWords(address: address, dataAddress: dataAddress, count: 1, otp: false, forceWrite: true)
    case FlashProgramType.word.rawValue:
      programHalfWords(address: address, dataAddress: dataAddress, count: 2, otp: false, forceWrite: true)
    case FlashProgramType.doubleWord.rawValue:
      programHalfWords(address: address, dataAddress: dataAddress, count: 4, otp: false, forceWrite: true)
    case FlashProgramType.quadWord.rawValue:
      programHalfWords(address: address, dataAddress: dataAddress, count: 8, otp: false, forceWrite: false)
    case FlashProgramType.otpHalfWord.rawValue:
      programHalfWords(address: address, dataAddress: dataAddress, count: 1, otp: true, forceWrite: true)
    case FlashProgramType.otpWord.rawValue:
      programHalfWords(address: address, dataAddress: dataAddress, count: 2, otp: true, forceWrite: true)
    default: return .error
    }
    return .ok
  }

  private func programByte(address: UInt32, dataAddress: UInt32) {
    precondition(address >= 0x0800_0000 && address < 0x0801_0000)
    modify(.cr, clear: 0, set: 2)
    let mask = memory.getPRIMASK()
    memory.disableIRQ()
    memory.write8(at: address, value: memory.read8(at: dataAddress))
    memory.instructionSynchronizationBarrier()
    memory.dataSynchronizationBarrier()
    modify(.cr, clear: 0, set: 0x10)
    memory.setPRIMASK(mask)
  }

  // The original word/double-word/quad-word helpers use 2/4/8 UInt16
  // transactions, respectively. Keep the interleaved load/store loop and its
  // byte stride; widening these accesses would change the programming sequence.
  private func programHalfWords(address: UInt32, dataAddress: UInt32, count: UInt8,
                                otp: Bool, forceWrite: Bool) {
    if otp { precondition(address >= 0x08FF_F000 && address < 0x08FF_F400) }
    else { precondition(address >= 0x0800_0000 && address < 0x0801_0000) }
    var destination = address
    var source = dataAddress
    var remaining = count
    modify(.cr, clear: 0, set: otp ? 0x10000 : 2)
    let mask = memory.getPRIMASK()
    memory.disableIRQ()
    repeat {
      memory.write16(at: destination, value: memory.read16(at: source))
      destination &+= 2
      source &+= 2
      remaining &-= 1
    } while remaining != 0
    memory.instructionSynchronizationBarrier()
    memory.dataSynchronizationBarrier()
    if forceWrite { modify(.cr, clear: 0, set: 0x10) }
    memory.setPRIMASK(mask)
  }
}
