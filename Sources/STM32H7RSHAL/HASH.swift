// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Lifecycle, macros and data helpers from stm32h7rsxx_hal_hash.c/.h at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension HASH {
  public static var driverVersion: UInt32 { 200 }
  public static var contextByteCount: UInt32 { 424 }

  @discardableResult
  public func initialize() -> HALStatus {
    precondition(HASHDataType(rawValue: handle.read(.dataType)) != nil)
    precondition(HASHAlgorithm(rawValue: handle.read(.algorithm)) != nil)
    if handle.read(.state) == 0 {
      handle.write(.lock, value: 0)
      if useRegisteredCallbacks {
        callbacks.write(.inputComplete, value: defaults.inputComplete)
        callbacks.write(.digestComplete, value: defaults.digestComplete)
        callbacks.write(.error, value: defaults.error)
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
      }
      invokeCallback(.mspInitialize)
    }
    let value = handle.read(.dataType) | handle.read(.algorithm)
    modify(.cr, clear: 0x001E_0034, set: value)
    handle.write(.phase, value: 1)
    handle.write(.state, value: 1)
    handle.write(.errorCode, value: 0)
    if useSuspendResume { handle.write(.suspendRequest, value: 0) }
    return .ok
  }
  @discardableResult
  public func deinitialize() -> HALStatus {
    handle.write(.phase, value: 1)
    handle.write(.inputCount, value: 0)
    handle.write(.accumulation, value: 0)
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invokeCallback(.mspDeinitialize)
    handle.write(.state, value: 0)
    unlock()
    return .ok
  }
  @discardableResult
  public func setConfiguration(_ configuration: HASHConfiguration?) -> HALStatus {
    guard let configuration else { return .error }
    precondition(HASHDataType(rawValue: configuration.dataType) != nil)
    precondition(HASHAlgorithm(rawValue: configuration.algorithm) != nil)
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard tryLock() else { return .busy }
      handle.write(.dataType, value: configuration.dataType)
      handle.write(.keyAddress, value: configuration.keyAddress)
      handle.write(.algorithm, value: configuration.algorithm)
      handle.write(.keySize, value: configuration.keySize)
      let value = handle.read(.dataType) | handle.read(.algorithm)
      modify(.cr, clear: 0x001E_0034, set: value)
      handle.write(.phase, value: 1)
      handle.write(.state, value: 1)
      handle.write(.errorCode, value: 0)
      unlock()
      return .ok
    }
    addError(1)
    return .error
  }
  @discardableResult
  public func getConfiguration(_ configuration: UnsafeMutablePointer<HASHConfiguration>?) -> HALStatus {
    guard let configuration else { return .error }
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard tryLock() else { return .busy }
      configuration.pointee.dataType = handle.read(.dataType)
      configuration.pointee.keyAddress = handle.read(.keyAddress)
      configuration.pointee.algorithm = handle.read(.algorithm)
      configuration.pointee.keySize = handle.read(.keySize)
      handle.write(.state, value: 1)
      unlock()
      return .ok
    }
    addError(1)
    return .error
  }
  public func getState() -> UInt32 { handle.read(.state) }
  public func getError() -> UInt32 { handle.read(.errorCode) }
  public func getFlag(_ flag: UInt32) -> UInt32 {
    let value = flag > 8 ? registers.read(.cr) : registers.read(.sr)
    return value & flag == flag ? 1 : 0
  }
  public func getFlag(_ flag: HASHFlags) -> UInt32 { getFlag(flag.rawValue) }
  public func clearFlag(_ flag: UInt32) { modify(.sr, clear: flag) }
  public func clearFlag(_ flag: HASHFlags) { clearFlag(flag.rawValue) }
  public func getInterruptSource(_ interrupts: UInt32) -> UInt32 {
    registers.read(.imr) & interrupts == interrupts ? 1 : 0
  }
  public func getInterruptSource(_ interrupts: HASHInterrupts) -> UInt32 { getInterruptSource(interrupts.rawValue) }
  public func enableInterrupts(_ interrupts: UInt32) { modify(.imr, set: interrupts) }
  public func disableInterrupts(_ interrupts: UInt32) { modify(.imr, clear: interrupts) }
  public func enableInterrupts(_ interrupts: HASHInterrupts) { enableInterrupts(interrupts.rawValue) }
  public func disableInterrupts(_ interrupts: HASHInterrupts) { disableInterrupts(interrupts.rawValue) }
  public func enableMultipleDMATransfers() { modify(.cr, set: 0x2000) }
  public func disableMultipleDMATransfers() { modify(.cr, clear: 0x2000) }

  func modify(_ register: HASHRegister, clear: UInt32 = 0, set: UInt32 = 0) {
    registers.write(register, value: (registers.read(register) & ~clear) | set)
  }
  func tryLock() -> Bool {
    if handle.read(.lock) == 1 { return false }
    handle.write(.lock, value: 1)
    return true
  }
  func unlock() { handle.write(.lock, value: 0) }
  func addError(_ value: UInt32) { handle.write(.errorCode, value: handle.read(.errorCode) | value) }
  func waitOnFlagUntilTimeout(_ flag: UInt32, status: UInt32, timeout: UInt32,
                             getTick: () -> UInt32) -> HALStatus {
    let tickStart = getTick()
    while getFlag(flag) == status {
      if timeout != UInt32.max {
        if (getTick() &- tickStart) > timeout || timeout == 0 {
          handle.write(.state, value: 1)
          addError(4)
          unlock()
          return .error
        }
      }
    }
    return .ok
  }
  func digestLength() -> UInt8 {
    // HASH_DIGEST_LENGTH reads CR again for each unsuccessful comparison.
    if registers.read(.cr) & 0x001E_0000 == 0 { return 20 }
    if registers.read(.cr) & 0x001E_0000 == 0x0004_0000 { return 28 }
    if registers.read(.cr) & 0x001E_0000 == 0x0006_0000 { return 32 }
    if registers.read(.cr) & 0x001E_0000 == 0x0018_0000 { return 48 }
    if registers.read(.cr) & 0x001E_0000 == 0x001A_0000 { return 28 }
    if registers.read(.cr) & 0x001E_0000 == 0x001C_0000 { return 32 }
    if registers.read(.cr) & 0x001E_0000 == 0x001E_0000 { return 64 }
    return 20
  }
  func getDigest(outputAddress: UInt32, size: UInt8) {
    guard size == 20 || size == 28 || size == 32 || size == 48 || size == 64 else { return }
    var address = outputAddress
    for index in 0..<(Int(size) / 4) {
      let register: HASHRegister = index < 5 ? .hr(index: index) : .digest(index: index)
      memory.write32(at: address, value: registers.read(register).byteSwapped)
      address &+= 4
    }
  }
  func writeData(inputAddress: UInt32, size: UInt32) {
    var address = inputAddress
    var counter: UInt32 = 0
    while counter < size / 4 {
      registers.write(.din, value: memory.read32(at: address))
      address &+= 4
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
      counter &+= 1
    }
    if size % 4 != 0 {
      if handle.read(.dataType) == 0x10 {
        if size % 4 <= 2 { registers.write(.din, value: UInt32(memory.read16(at: address))) }
        if size % 4 == 3 { registers.write(.din, value: memory.read32(at: address)) }
      } else if handle.read(.dataType) == 0x20 || handle.read(.dataType) == 0x30 {
        if size % 4 == 1 { registers.write(.din, value: UInt32(memory.read8(at: address))) }
        if size % 4 == 2 { registers.write(.din, value: UInt32(memory.read16(at: address))) }
        if size % 4 == 3 {
          let first = memory.read8(at: address)
          let second = memory.read8(at: address &+ 1)
          let third = memory.read8(at: address &+ 2)
          registers.write(.din, value: UInt32(first) | (UInt32(second) << 8) | (UInt32(third) << 16))
        }
      } else { registers.write(.din, value: memory.read32(at: address)) }
      handle.write(.inputCount, value: handle.read(.inputCount) &+ 4)
    }
  }
  func hmacBlockSize() -> UInt32 {
    if handle.read(.algorithm) == 0 || handle.read(.algorithm) == 0x0004_0000 ||
       handle.read(.algorithm) == 0x0006_0000 { return 64 }
    return 128
  }
  func initializeHMACCore() {
    let blockSize = hmacBlockSize()
    if handle.read(.keySize) > blockSize { modify(.cr, clear: 0x0001_0044, set: 0x0001_0044) }
    else { modify(.cr, clear: 0x0001_0044, set: 0x44) }
  }
}
