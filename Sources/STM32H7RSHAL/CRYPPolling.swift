// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  @discardableResult
  public func encrypt(
    input: UnsafeMutablePointer<UInt32>?, size: UInt16, output: UnsafeMutablePointer<UInt32>?,
    timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var algorithm: UInt32 = 0
    let status: HALStatus
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard lock() else { return .busy }
      handle.write(.inputCount, value: 0)
      handle.write(.outputCount, value: 0)
      handle.writePointer(.input, value: input)
      handle.writePointer(.output, value: output)
      if handle.read(.dataWidthUnit) == 0x0 {
        handle.write(.size, value: size &* 4)
      } else {
        handle.write(.size, value: size)
      }
      if hasCRYP && isCRYP {
        modify(.cr, clear: 0x4, set: 0x0)
        algorithm = registers.read(.cr) & 0x80038
      }
      if hasSAES && isSAES {
        modify(.cr, clear: 0x18, set: 0x0)
        algorithm = saesAlgorithm(registers.read(.cr) & 0x10060, order: 1)
      }
      switch algorithm {
      case 0x20, 0x28, 0x30: status = aesEncrypt(timeout: timeout, getTick: getTick)
      case 0x80000: status = aesGCMProcess(timeout: timeout, getTick: getTick)
      case 0x80008: status = aesCCMProcess(timeout: timeout, getTick: getTick)
      default:
        addError(0x20)
        status = .error
      }
      if status == .ok {
        handle.write(.state, value: 1)
        unlock()
      }
    } else {
      unlock()
      addError(0x8)
      status = .error
    }
    return status
  }
  @discardableResult
  public func decrypt(
    input: UnsafeMutablePointer<UInt32>?, size: UInt16, output: UnsafeMutablePointer<UInt32>?,
    timeout: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    var algorithm: UInt32 = 0
    let status: HALStatus
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard lock() else { return .busy }
      handle.write(.inputCount, value: 0)
      handle.write(.outputCount, value: 0)
      handle.writePointer(.input, value: input)
      handle.writePointer(.output, value: output)
      if handle.read(.dataWidthUnit) == 0x0 {
        handle.write(.size, value: size &* 4)
      } else {
        handle.write(.size, value: size)
      }
      if hasCRYP && isCRYP {
        modify(.cr, clear: 0x4, set: 0x4)
        algorithm = registers.read(.cr) & 0x80038
      }
      if hasSAES && isSAES {
        modify(.cr, clear: 0x18, set: 0x10)
        algorithm = saesAlgorithm(registers.read(.cr) & 0x10060, order: 1)
      }
      switch algorithm {
      case 0x20, 0x28, 0x30: status = aesDecrypt(timeout: timeout, getTick: getTick)
      case 0x80000: status = aesGCMProcess(timeout: timeout, getTick: getTick)
      case 0x80008: status = aesCCMProcess(timeout: timeout, getTick: getTick)
      default:
        addError(0x20)
        status = .error
      }
      if status == .ok {
        handle.write(.state, value: 1)
        unlock()
      }
    } else {
      unlock()
      addError(0x8)
      status = .error
    }
    return status
  }
}
