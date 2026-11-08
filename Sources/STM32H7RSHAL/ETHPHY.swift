// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// ETH and ETHEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension ETH {
  public func readPHYRegister(
    address: UInt32, register: UInt32, value: UnsafeMutablePointer<UInt32>, getTick: () -> UInt32
  ) -> HALStatus {
    if registers.read(.macmdioar) & 0x1 != 0 { return .error }
    var bits = registers.read(.macmdioar)
    bits = (bits & ~0x3e00000) | (address << 21)
    bits = (bits & ~0x1f0000) | (register << 16)
    bits = (bits & ~0xc) | 0xc
    bits |= 0x1
    registers.write(.macmdioar, value: bits)
    let start = getTick()
    while registers.read(.macmdioar) & 0x1 > 0 {
      if getTick() &- start > mdioBusTimeout { return .error }
    }
    value.pointee = registers.read(.macmdiodr) & 0xFFFF
    return .ok
  }
  public func writePHYRegister(
    address: UInt32, register: UInt32, value: UInt32, getTick: () -> UInt32
  ) -> HALStatus {
    if registers.read(.macmdioar) & 0x1 != 0 { return .error }
    var bits = registers.read(.macmdioar)
    bits = (bits & ~0x3e00000) | (address << 21)
    bits = (bits & ~0x1f0000) | (register << 16)
    bits = (bits & ~0xc) | 0x4
    bits |= 0x1
    platform.writeGlobalETH(.macmdiodr, value: value & 0xFFFF)
    platform.writeGlobalETH(.macmdioar, value: bits)
    let start = getTick()
    while registers.read(.macmdioar) & 0x1 > 0 {
      if getTick() &- start > mdioBusTimeout { return .error }
    }
    return .ok
  }
}
