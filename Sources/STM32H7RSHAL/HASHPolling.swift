// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Polling functions from stm32h7rsxx_hal_hash.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HASH {
  @discardableResult
  public func start(inputAddress: UInt32, size: UInt32, outputAddress: UInt32,
                    timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    guard handle.read(.state) == 1 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.outputAddress, value: outputAddress)
    handle.write(.inputCount, value: 0)
    handle.write(.size, value: size)
    modify(.cr, clear: 0x40)
    modify(.cr, clear: 4, set: 4)
    modify(.str, clear: 0x1F, set: 8 &* (size % 4))
    handle.write(.phase, value: 2)
    writeData(inputAddress: inputAddress, size: size)
    modify(.str, set: 0x100)
    guard waitOnFlagUntilTimeout(2, status: 0, timeout: timeout, getTick: getTick) == .ok else { return .error }
    getDigest(outputAddress: outputAddress, size: digestLength())
    handle.write(.state, value: 1)
    handle.write(.phase, value: 1)
    unlock()
    return .ok
  }
  @discardableResult
  public func accumulate(inputAddress: UInt32, size: UInt32, timeout: UInt32,
                         getTick: () -> UInt32) -> HALStatus {
    guard size % 4 == 0 else { return .error }
    let state = handle.read(.state)
    guard state == 1 || state == 3 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.inputCount, value: 0)
    handle.write(.size, value: size)
    if handle.read(.phase) == 1 {
      modify(.cr, clear: 0x40)
      modify(.cr, clear: 4, set: 4)
      handle.write(.phase, value: 2)
    }
    writeData(inputAddress: inputAddress, size: size)
    guard waitOnFlagUntilTimeout(8, status: 1, timeout: timeout, getTick: getTick) == .ok else { return .error }
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }
  @discardableResult
  public func accumulateLast(inputAddress: UInt32, size: UInt32, outputAddress: UInt32,
                             timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    let state = handle.read(.state)
    guard state == 1 || state == 3 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.outputAddress, value: outputAddress)
    handle.write(.inputCount, value: 0)
    handle.write(.size, value: size)
    if handle.read(.phase) == 1 {
      modify(.cr, clear: 0x40)
      modify(.cr, clear: 4, set: 4)
      handle.write(.phase, value: 2)
    }
    modify(.str, clear: 0x1F, set: 8 &* (size % 4))
    writeData(inputAddress: inputAddress, size: size)
    modify(.str, set: 0x100)
    guard waitOnFlagUntilTimeout(2, status: 0, timeout: timeout, getTick: getTick) == .ok else { return .error }
    getDigest(outputAddress: outputAddress, size: digestLength())
    handle.write(.state, value: 1)
    handle.write(.phase, value: 1)
    handle.write(.accumulation, value: 0)
    unlock()
    return .ok
  }
  @discardableResult
  public func startHMAC(inputAddress: UInt32, size: UInt32, outputAddress: UInt32,
                        timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    guard handle.read(.state) == 1 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.phase, value: 1)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.outputAddress, value: outputAddress)
    handle.write(.keyBufferAddress, value: handle.read(.keyAddress))
    handle.write(.inputCount, value: 0)
    handle.write(.size, value: size)
    initializeHMACCore()
    modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
    handle.write(.phase, value: 2)
    writeData(inputAddress: handle.read(.keyAddress), size: handle.read(.keySize))
    modify(.str, set: 0x100)
    guard waitOnFlagUntilTimeout(8, status: 1, timeout: timeout, getTick: getTick) == .ok else { return .error }
    modify(.str, clear: 0x1F, set: 8 &* (size % 4))
    writeData(inputAddress: inputAddress, size: size)
    modify(.str, set: 0x100)
    guard waitOnFlagUntilTimeout(8, status: 1, timeout: timeout, getTick: getTick) == .ok else { return .error }
    modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
    writeData(inputAddress: handle.read(.keyAddress), size: handle.read(.keySize))
    modify(.str, set: 0x100)
    guard waitOnFlagUntilTimeout(2, status: 0, timeout: timeout, getTick: getTick) == .ok else { return .error }
    getDigest(outputAddress: outputAddress, size: digestLength())
    handle.write(.state, value: 1)
    handle.write(.phase, value: 1)
    unlock()
    return .ok
  }
  @discardableResult
  public func accumulateHMAC(inputAddress: UInt32, size: UInt32, timeout: UInt32,
                            getTick: () -> UInt32) -> HALStatus {
    guard size % 4 == 0 else { return .error }
    guard handle.read(.state) == 1 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.keyBufferAddress, value: handle.read(.keyAddress))
    handle.write(.size, value: size)
    if handle.read(.phase) == 1 {
      handle.write(.inputCount, value: 0)
      initializeHMACCore()
      handle.write(.phase, value: 2)
      modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
      writeData(inputAddress: handle.read(.keyAddress), size: handle.read(.keySize))
      modify(.str, set: 0x100)
      guard waitOnFlagUntilTimeout(8, status: 1, timeout: timeout, getTick: getTick) == .ok else { return .error }
    }
    modify(.str, clear: 0x1F)
    writeData(inputAddress: inputAddress, size: size)
    handle.write(.state, value: 1)
    unlock()
    return .ok
  }
  @discardableResult
  public func accumulateHMACLast(inputAddress: UInt32, size: UInt32, outputAddress: UInt32,
                                timeout: UInt32, getTick: () -> UInt32) -> HALStatus {
    guard handle.read(.state) == 1 else { return .busy }
    guard tryLock() else { return .busy }
    handle.write(.state, value: 2)
    handle.write(.inputAddress, value: inputAddress)
    handle.write(.outputAddress, value: outputAddress)
    handle.write(.keyBufferAddress, value: handle.read(.keyAddress))
    handle.write(.size, value: size)
    // The original error path deliberately leaves State BUSY and Lock locked.
    guard handle.read(.phase) == 2 else { return .error }
    modify(.str, clear: 0x1F, set: 8 &* (size % 4))
    writeData(inputAddress: inputAddress, size: size)
    modify(.str, set: 0x100)
    guard waitOnFlagUntilTimeout(8, status: 1, timeout: timeout, getTick: getTick) == .ok else { return .error }
    modify(.str, clear: 0x1F, set: 8 &* (handle.read(.keySize) % 4))
    writeData(inputAddress: handle.read(.keyAddress), size: handle.read(.keySize))
    modify(.str, set: 0x100)
    guard waitOnFlagUntilTimeout(2, status: 0, timeout: timeout, getTick: getTick) == .ok else { return .error }
    getDigest(outputAddress: outputAddress, size: digestLength())
    handle.write(.state, value: 1)
    handle.write(.phase, value: 1)
    unlock()
    return .ok
  }
}
