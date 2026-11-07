// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Suspend/resume functions from stm32h7rsxx_hal_hash.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HASH {
  public func suspend(contextAddress: UInt32) {
    precondition(useSuspendResume)
    var address = contextAddress
    memory.write32(at: address, value: registers.read(.imr) & 3)
    address &+= 4
    memory.write32(at: address, value: registers.read(.str) & 0x1F)
    address &+= 4
    memory.write32(at: address, value: registers.read(.cr) & 0x001F_2078)
    address &+= 4
    for index in 0..<103 {
      memory.write32(at: address, value: registers.read(.csr(index: index)))
      address &+= 4
    }
    handle.write(.savedDataType, value: handle.read(.dataType))
    handle.write(.savedKeySize, value: handle.read(.keySize))
    handle.write(.savedKeyAddress, value: handle.read(.keyAddress))
    handle.write(.savedAlgorithm, value: handle.read(.algorithm))
    handle.write(.savedOutputAddress, value: handle.read(.outputAddress))
    handle.write(.savedInputCount, value: handle.read(.inputCount))
    handle.write(.savedSize, value: handle.read(.size))
    handle.write(.savedInputAddress, value: handle.read(.inputAddress))
    handle.write(.savedPhase, value: handle.read(.phase))
    handle.write(.savedKeyBufferAddress, value: handle.read(.keyBufferAddress))
  }
  public func resume(contextAddress: UInt32) {
    precondition(useSuspendResume)
    var address = contextAddress
    registers.write(.imr, value: memory.read32(at: address))
    address &+= 4
    registers.write(.str, value: memory.read32(at: address))
    address &+= 4
    registers.write(.cr, value: memory.read32(at: address))
    address &+= 4
    modify(.cr, set: 4)
    for index in 0..<103 {
      registers.write(.csr(index: index), value: memory.read32(at: address))
      address &+= 4
    }
    handle.write(.dataType, value: handle.read(.savedDataType))
    handle.write(.keySize, value: handle.read(.savedKeySize))
    handle.write(.keyAddress, value: handle.read(.savedKeyAddress))
    handle.write(.algorithm, value: handle.read(.savedAlgorithm))
    handle.write(.outputAddress, value: handle.read(.savedOutputAddress))
    handle.write(.inputCount, value: handle.read(.savedInputCount))
    handle.write(.size, value: handle.read(.savedSize))
    handle.write(.inputAddress, value: handle.read(.savedInputAddress))
    handle.write(.phase, value: handle.read(.savedPhase))
    handle.write(.state, value: 3)
    handle.write(.keyBufferAddress, value: handle.read(.savedKeyBufferAddress))
  }
  @discardableResult
  public func processSuspend(getTick: () -> UInt32) -> HALStatus {
    precondition(useSuspendResume)
    let partialByteCount = (registers.read(.sr) >> 16) &* 4
    if getFlag(4) != 0 {
      if handle.read(.state) == 1 { return .error }
      modify(.cr, clear: 8)
      if waitOnFlagUntilTimeout(4, status: 1, timeout: 1000, getTick: getTick) != .ok { return .timeout }
      var remainingWords = dma.getCounter() / 4
      remainingWords &+= dma.getFIFOLevel()
      // The C comparison mixes remaining words and partial bytes. Preserve it.
      if remainingWords <= partialByteCount { return .error }
      if dma.abort(getTick: getTick) != .ok { return .error }
      if getFlag(2) != 0 { return .error }
      if waitOnFlagUntilTimeout(1, status: 0, timeout: 1000, getTick: getTick) != .ok { return .timeout }
      let sizeInWords = handle.read(.size) % 4 != 0
        ? (handle.read(.size) &+ 3) / 4 : handle.read(.size) / 4
      handle.write(.inputAddress, value: handle.read(.inputAddress) &+ (4 &* (sizeInWords &- remainingWords)))
      handle.write(.inputCount, value: 4 &* remainingWords)
      handle.write(.state, value: 3)
      unlock()
      return .ok
    }
    handle.write(.suspendRequest, value: 1)
    return .ok
  }
}
