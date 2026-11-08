// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SPI/SPIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SPI {
  public func initialize() -> HALStatus {

    var crc_length: UInt32 = 0
    var packet_length: UInt32
    var crc_poly_msb_mask: UInt32

    if isLimitedInstance {

    } else {

    }

    if handle.read(.tiMode) == 0x0 {

    }
    if useCRC {
      if handle.read(.crcCalculation) == 0x400000 {
        if isLimitedInstance {
        } else {
        }

      }
    } else {
      handle.write(.crcCalculation, value: 0x0)
    }

    if (isLimitedInstance) && (handle.read(.dataSize) > 0xf) {
      return .error
    }

    packet_length = packetSize()
    if ((isLimitedInstance) && (packet_length > 0x8))
      || (((!isLimitedInstance)) && (packet_length > 0x10))
    {
      return .error
    }
    if useCRC {
      if handle.read(.crcCalculation) == 0x400000 {
        if (isLimitedInstance) && (handle.read(.crcLength) > 0xf0000) {
          return .error
        }

        if handle.read(.crcLength) == 0x0 {
          crc_length = (handle.read(.dataSize) >> 0x0) << 0x10
        } else {
          crc_length = handle.read(.crcLength)
        }

        if (handle.read(.dataSize) >> 0x0) > (crc_length >> 0x10) {
          return .error
        }
      } else {
        crc_length = handle.read(.dataSize) << 0x10
      }
    }
    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        callbacks.write(.transmitReceiveComplete, value: defaults.transmitReceiveComplete)
        callbacks.write(.transmitHalfComplete, value: defaults.transmitHalfComplete)
        callbacks.write(.receiveHalfComplete, value: defaults.receiveHalfComplete)
        callbacks.write(.transmitReceiveHalfComplete, value: defaults.transmitReceiveHalfComplete)
        callbacks.write(.error, value: defaults.error)
        callbacks.write(.abortComplete, value: defaults.abortComplete)
        callbacks.write(.suspend, value: defaults.suspend)
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }

        callbacks.read(.mspInitialize)!(callbacks.context)
      } else {
        defaults.mspInitialize(callbacks.context)
      }
    }
    handle.write(.state, value: 0x2)

    disable()
    if !useCRC {
      crc_length = registers.read(.cfg1) & 0x1f0000
    }

    if (handle.read(.nss) == 0x4000000)
      && (((handle.read(.mode) == 0x400000) && (handle.read(.nssPolarity) == 0x0))
        || ((handle.read(.mode) == 0x0) && (handle.read(.nssPolarity) == 0x1000_0000)))
    {
      registers.write(.cr1, value: registers.read(.cr1) | (0x1000))
    }

    if ((handle.read(.mode) & 0x400000) == 0x400000) && (handle.read(.dataSize) >= 0x7) {
      registers.write(
        .cr1, value: (registers.read(.cr1) & ~(0x100)) | (handle.read(.masterReceiverAutoSuspend)))
    } else {
      registers.write(.cr1, value: registers.read(.cr1) & (~(0x100)))
    }

    registers.write(
      .cfg1,
      value: (handle.read(.baudRatePrescaler) | handle.read(.crcCalculation) | crc_length
        | handle.read(.fifoThreshold) | handle.read(.dataSize)))

    registers.write(
      .cfg2,
      value: (handle.read(.nssPulseMode) | handle.read(.tiMode) | handle.read(.nssPolarity)
        | handle.read(.nss) | handle.read(.clockPolarity) | handle.read(.clockPhase)
        | handle.read(.firstBit) | handle.read(.mode) | handle.read(.masterInterDataIdleness)
        | handle.read(.direction) | handle.read(.masterSSIdleness) | handle.read(.ioSwap)
        | handle.read(.readyMasterManagement) | handle.read(.readyPolarity)))
    if useCRC {

      if handle.read(.crcCalculation) == 0x400000 {
        if handle.read(.transmitCRCInitializationPattern) == 0x1 {
          registers.write(.cr1, value: registers.read(.cr1) | (0x8000))
        } else {
          registers.write(.cr1, value: registers.read(.cr1) & (~(0x8000)))
        }

        if handle.read(.receiveCRCInitializationPattern) == 0x1 {
          registers.write(.cr1, value: registers.read(.cr1) | (0x4000))
        } else {
          registers.write(.cr1, value: registers.read(.cr1) & (~(0x4000)))
        }

        if ((isLimitedInstance) && (crc_length == 0xf0000))
          || (((!isLimitedInstance)) && (crc_length == 0x1f0000))
        {
          registers.write(.cr1, value: registers.read(.cr1) | (0x2000))
          registers.write(.crcpoly, value: handle.read(.crcPolynomial))
        } else {
          registers.write(.cr1, value: registers.read(.cr1) & (~(0x2000)))

          crc_poly_msb_mask = (0x1 << ((crc_length >> 0x10) &+ 0x1))
          registers.write(.crcpoly, value: (handle.read(.crcPolynomial)) | crc_poly_msb_mask)
        }
      }
    }

    if handle.read(.mode) == 0x0 {
      if useCRC {
        registers.write(.cfg1, value: (registers.read(.cfg1) & ~(0x200)) | (0x200))
      }
    }

    registers.write(.i2scfgr, value: registers.read(.i2scfgr) & (~(0x1)))

    if (handle.read(.mode) & 0x400000) == 0x400000 {
      registers.write(
        .cfg2, value: (registers.read(.cfg2) & ~(0x8000_0000)) | ((handle.read(.masterKeepIOState)))
      )
    }
    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x1)
    return .ok

  }
  public func deinitialize() -> HALStatus {

    handle.write(.state, value: 0x2)

    disable()
    if useRegisteredCallbacks {
      if callbacks.read(.mspDeinitialize) == nil {
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
      }

      callbacks.read(.mspDeinitialize)!(callbacks.context)
    } else {
      defaults.mspDeinitialize(callbacks.context)
    }
    handle.write(.errorCode, value: 0x0)
    handle.write(.state, value: 0x0)

    unlock()
    return .ok

  }
  public func registerCallback(_ CallbackID: UInt32, _ pCallback: SPICallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000))
      return .error
    }
    if 0x1 == handle.read(.state) {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.transmitComplete, value: pCallback)
        break
      case 0x1:
        callbacks.write(.receiveComplete, value: pCallback)
        break
      case 0x2:
        callbacks.write(.transmitReceiveComplete, value: pCallback)
        break
      case 0x3:
        callbacks.write(.transmitHalfComplete, value: pCallback)
        break
      case 0x4:
        callbacks.write(.receiveHalfComplete, value: pCallback)
        break
      case 0x5:
        callbacks.write(.transmitReceiveHalfComplete, value: pCallback)
        break
      case 0x6:
        callbacks.write(.error, value: pCallback)
        break
      case 0x7:
        callbacks.write(.abortComplete, value: pCallback)
        break
      case 0x8:
        callbacks.write(.suspend, value: pCallback)
        break
      case 0x9:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0xa:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000))

        status = .error
        break
      }
    } else if 0x0 == handle.read(.state) {
      switch CallbackID
      {
      case 0x9:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0xa:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000))

        status = .error
        break
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000))

      status = .error
    }
    return status

  }
  public func unregisterCallback(_ CallbackID: UInt32) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if 0x1 == handle.read(.state) {
      switch CallbackID
      {
      case 0x0:
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        break
      case 0x1:
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        break
      case 0x2:
        callbacks.write(.transmitReceiveComplete, value: defaults.transmitReceiveComplete)
        break
      case 0x3:
        callbacks.write(.transmitHalfComplete, value: defaults.transmitHalfComplete)
        break
      case 0x4:
        callbacks.write(.receiveHalfComplete, value: defaults.receiveHalfComplete)
        break
      case 0x5:
        callbacks.write(.transmitReceiveHalfComplete, value: defaults.transmitReceiveHalfComplete)
        break
      case 0x6:
        callbacks.write(.error, value: defaults.error)
        break
      case 0x7:
        callbacks.write(.abortComplete, value: defaults.abortComplete)
        break
      case 0x8:
        callbacks.write(.suspend, value: defaults.suspend)
        break
      case 0x9:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0xa:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000))

        status = .error
        break
      }
    } else if 0x0 == handle.read(.state) {
      switch CallbackID
      {
      case 0x9:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0xa:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000))

        status = .error
        break
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x1000))

      status = .error
    }
    return status

  }
  var isLimitedInstance: Bool { registers.instance == .spi4 || registers.instance == .spi5 }
  public func enable() { modify(.cr1, set: 0x1) }
  public func disable() { modify(.cr1, clear: 0x1) }
  public func enableInterrupts(_ interrupts: UInt32) { modify(.ier, set: interrupts) }
  public func disableInterrupts(_ interrupts: UInt32) { modify(.ier, clear: interrupts) }
  func isFlagSet(_ flag: UInt32) -> Bool { registers.read(.sr) & flag == flag }
  public func getFlag(_ flag: UInt32) -> UInt32 { isFlagSet(flag) ? 1 : 0 }
  public func getInterruptSource(_ interrupts: UInt32) -> UInt32 {
    registers.read(.ier) & interrupts == interrupts ? 1 : 0
  }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
  public func clearCRCErrorFlag() { modify(.ifcr, set: 0x80) }
  public func clearModeFaultFlag() { modify(.ifcr, set: 0x200) }
  public func clearOverrunFlag() { modify(.ifcr, set: 0x40) }
  public func clearFrameErrorFlag() { modify(.ifcr, set: 0x100) }
  public func clearUnderrunFlag() { modify(.ifcr, set: 0x20) }
  public func clearEndOfTransferFlag() { modify(.ifcr, set: 0x8) }
  public func clearTransmitFilledFlag() { modify(.ifcr, set: 0x10) }
  public func clearSuspendFlag() { modify(.ifcr, set: 0x800) }
  public func setOneLineTransmit() { modify(.cr1, set: 0x800) }
  public func setOneLineReceive() { modify(.cr1, clear: 0x800) }
  public func setTwoLinesTransmit() { modify(.cfg2, clear: 0x60000, set: 0x20000) }
  public func setTwoLinesReceive() { modify(.cfg2, clear: 0x60000, set: 0x40000) }
  public func setTwoLines() { modify(.cfg2, clear: 0x60000) }
}
