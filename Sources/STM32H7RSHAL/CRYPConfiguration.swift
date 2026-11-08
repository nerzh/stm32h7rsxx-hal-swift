// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// CRYP/SAES and CRYPEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension CRYP {
  @discardableResult
  public func initialize(getRevision: () -> UInt32, getTick: () -> UInt32) -> HALStatus {
    if engines == .crypOnly && isSAES { return .error }
    if engines == .saesOnly && isCRYP { return .error }
    if handle.read(.state) == 0 {
      unlock()
      if useRegisteredCallbacks {
        callbacks.write(.inputComplete, value: defaults.inputComplete)
        callbacks.write(.outputComplete, value: defaults.outputComplete)
        callbacks.write(.error, value: defaults.error)
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
      }
      invoke(.mspInitialize)
    }
    if hasCRYP && isCRYP {
      modify(
        .cr, clear: 0x3000000 | 0xC0 | 0x300 | 0x80038,
        set: handle.read(.keyMode) | handle.read(.dataType) | handle.read(.keySize)
          | handle.read(.algorithm))
    }
    if hasSAES && isSAES {
      resetSAES()
      if waitOnBusy(timeout: 500, getTick: getTick) != .ok {
        disable()
        addError(0x10)
        handle.write(.state, value: 1)
        unlock()
        return .error
      }
      modify(
        .cr, clear: 0x7000_0000 | 0x3000000 | 0x6 | 0x40000 | 0x10060,
        set: handle.read(.keySelection) | handle.read(.keyMode)
          | saesDataType(handle.read(.dataType)) | saesKeySize(handle.read(.keySize))
          | saesAlgorithm(handle.read(.algorithm)))
    }
    handle.write(.version, value: getRevision())
    handle.write(.errorCode, value: 0)
    handle.write(.keyIVConfiguration, value: 0)
    handle.write(.state, value: 1)
    handle.write(.phase, value: 1)
    return .ok
  }
  @discardableResult
  public func deinitialize() -> HALStatus {
    if engines == .crypOnly && isSAES { return .error }
    if engines == .saesOnly && isCRYP { return .error }
    handle.write(.phase, value: 1)
    handle.write(.inputCount, value: 0)
    handle.write(.outputCount, value: 0)
    handle.write(.headerCount, value: 0)
    disable()
    if useRegisteredCallbacks && callbacks.read(.mspDeinitialize) == nil {
      callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
    }
    invoke(.mspDeinitialize)
    handle.write(.state, value: 0)
    unlock()
    return .ok
  }
  @discardableResult
  public func setConfiguration(_ configuration: UnsafePointer<CRYPConfiguration>?) -> HALStatus {
    guard let configuration else { return .error }
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard lock() else { return .busy }
      handle.write(.dataType, value: configuration.pointee.dataType)
      handle.writePointer(.key, value: configuration.pointee.key)
      handle.write(.algorithm, value: configuration.pointee.algorithm)
      handle.write(.keySize, value: configuration.pointee.keySize)
      handle.writePointer(.initialVector, value: configuration.pointee.initialVector)
      handle.writePointer(.header, value: configuration.pointee.header)
      handle.write(.headerSize, value: configuration.pointee.headerSize)
      handle.writePointer(.b0, value: configuration.pointee.b0)
      handle.write(.dataWidthUnit, value: configuration.pointee.dataWidthUnit)
      handle.write(.headerWidthUnit, value: configuration.pointee.headerWidthUnit)
      handle.write(.keyMode, value: configuration.pointee.keyMode)
      handle.write(.keyIVConfigurationSkip, value: configuration.pointee.keyIVConfigurationSkip)
      handle.write(.keySelection, value: configuration.pointee.keySelection)
      if hasCRYP && isCRYP {
        // HAL_CRYP_SetConfig deliberately leaves KMOD unchanged.
        modify(
          .cr, clear: 0xC0 | 0x300 | 0x80038,
          set: handle.read(.dataType) | handle.read(.keySize) | handle.read(.algorithm))
      }
      if hasSAES && isSAES {
        if handle.read(.keySelection) != 0x0 && handle.read(.keyMode) == 0x1000000 {
          modify(.cr, clear: 0x3000000, set: 0x1000000)
        }
        modify(
          .cr, clear: 0x7000_0000 | 0x3000000 | 0x6 | 0x40000 | 0x10060,
          set: handle.read(.keySelection) | handle.read(.keyMode)
            | saesDataType(handle.read(.dataType)) | saesKeySize(handle.read(.keySize))
            | saesAlgorithm(handle.read(.algorithm)))
      }
      unlock()
      handle.write(.errorCode, value: 0)
      handle.write(.state, value: 1)
      handle.write(.phase, value: 1)
      return .ok
    }
    unlock()
    addError(0x8)
    return .error
  }
  @discardableResult
  public func getConfiguration(_ configuration: UnsafeMutablePointer<CRYPConfiguration>?)
    -> HALStatus
  {
    guard let configuration else { return .error }
    if handle.read(.state) == 1 {
      handle.write(.state, value: 2)
      guard lock() else { return .busy }
      configuration.pointee.dataType = handle.read(.dataType)
      configuration.pointee.key = handle.readPointer(.key)
      configuration.pointee.algorithm = handle.read(.algorithm)
      configuration.pointee.keySize = handle.read(.keySize)
      configuration.pointee.initialVector = handle.readPointer(.initialVector)
      configuration.pointee.header = handle.readPointer(.header)
      configuration.pointee.headerSize = handle.read(.headerSize)
      configuration.pointee.b0 = handle.readPointer(.b0)
      configuration.pointee.dataWidthUnit = handle.read(.dataWidthUnit)
      configuration.pointee.headerWidthUnit = handle.read(.headerWidthUnit)
      configuration.pointee.keyMode = handle.read(.keyMode)
      configuration.pointee.keySelection = handle.read(.keySelection)
      configuration.pointee.keyIVConfigurationSkip = handle.read(.keyIVConfigurationSkip)
      unlock()
      handle.write(.state, value: 1)
      return .ok
    }
    unlock()
    addError(0x8)
    return .error
  }
}
