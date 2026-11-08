// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension I2S {
  public func initialize(getPeripheralClockFrequency: (UInt32) -> UInt32) -> HALStatus {

    var i2sdiv: UInt32
    var i2sodd: UInt32
    var packetlength: UInt32
    var tmp: UInt32
    var i2sclk: UInt32
    var ispcm: UInt32

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0)
      if useRegisteredCallbacks {
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        callbacks.write(.transmitReceiveComplete, value: defaults.transmitReceiveComplete)
        callbacks.write(.transmitHalfComplete, value: defaults.transmitHalfComplete)
        callbacks.write(.receiveHalfComplete, value: defaults.receiveHalfComplete)
        callbacks.write(.transmitReceiveHalfComplete, value: defaults.transmitReceiveHalfComplete)
        callbacks.write(.error, value: defaults.error)
        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }

        callbacks.read(.mspInitialize)!(callbacks.context)
      } else {
        defaults.mspInitialize(callbacks.context)
      }
    }
    handle.write(.state, value: 0x2)

    if (registers.read(.cr1) & 0x1) == 0x1 {
      disable()
    }

    registers.write(.i2scfgr, value: 0)
    if (handle.read(.mode) == 0x4) || (handle.read(.mode) == 0x6) || (handle.read(.mode) == 0xa) {

      if handle.read(.audioFrequency) != 0x2 {
        if handle.read(.dataFormat) != 0x0 {
          packetlength = 2
        } else {
          packetlength = 1
        }

        if (handle.read(.standard) == 0x30) || (handle.read(.standard) == 0xb0) {
          ispcm = 1
        } else {
          ispcm = 0
        }

        if registers.instance == .spi1 {
          i2sclk = getPeripheralClockFrequency(0x800000)
        } else if (registers.instance == .spi2) || (registers.instance == .spi3) {
          i2sclk = getPeripheralClockFrequency(0x1000000)
        } else {
          i2sclk = getPeripheralClockFrequency(0x4000000)
        }

        if handle.read(.masterClockOutput) == 0x2000000 {
          tmp = (((((i2sclk / (256 >> ispcm)) &* 10) / handle.read(.audioFrequency)) &+ 5))
        } else {
          tmp =
            (((((i2sclk / ((32 >> ispcm) &* packetlength)) &* 10) / handle.read(.audioFrequency))
              &+ 5))
        }

        tmp = tmp / 10

        i2sodd = ((tmp & (1)))

        i2sdiv = (((tmp &- i2sodd) / 2))
      } else {
        i2sdiv = 2
        i2sodd = 0
      }

      if ((i2sodd == 1) && (i2sdiv == 1)) || (i2sdiv > 0xFF) {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x10))
        return .error
      }

      if i2sdiv == 0 {
        i2sodd = 1
      }
      registers.write(
        .i2scfgr,
        value: ((registers.read(.i2scfgr) & ~((0xff0000 | 0x1000000)))
          | (((i2sdiv << 0x10) | (i2sodd << 0x18)))))
    }

    registers.write(
      .i2scfgr,
      value: ((registers.read(.i2scfgr)
        & ~((0x1 | 0xe | 0x30 | 0x80 | 0x300 | 0x400 | 0x800 | 0x2000 | 0x4000 | 0x2000000)))
        | ((0x1 | handle.read(.mode) | handle.read(.standard) | handle.read(.dataFormat)
          | handle.read(.clockPolarity) | handle.read(.wordSelectInversion)
          | handle.read(.data24BitAlignment) | handle.read(.masterClockOutput))))
    )
    registers.write(.ifcr, value: 0x0FF8)

    registers.write(.cr1, value: registers.read(.cr1) & (~(0x10000)))
    registers.write(
      .cfg2, value: ((registers.read(.cfg2) & ~(0x800000)) | (handle.read(.firstBit))))

    if (handle.read(.mode) == 0x4) || (handle.read(.mode) == 0x6) || (handle.read(.mode) == 0xa) {
      registers.write(
        .cfg2,
        value: ((registers.read(.cfg2) & ~(0x8000_0000)) | ((handle.read(.masterKeepIOState)))))
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
  public func enableIOSwap() -> HALStatus {

    if handle.read(.state) != 0x1 {
      return .error
    }

    if (registers.read(.cr1) & 0x10000) == (0x10000) {
      return .error
    }

    if (registers.read(.cr1) & 0x1) == 0x1 {
      disable()
    }

    registers.write(.cfg2, value: registers.read(.cfg2) | (0x8000))
    return .ok

  }
  public func disableIOSwap() -> HALStatus {

    if handle.read(.state) != 0x1 {
      return .error
    }

    if (registers.read(.cr1) & 0x10000) == (0x10000) {
      return .error
    }

    if (registers.read(.cr1) & 0x1) == 0x1 {
      disable()
    }

    registers.write(.cfg2, value: registers.read(.cfg2) & (~(0x8000)))
    return .ok

  }
  public func isIOSwapEnabled() -> UInt32 {

    return (((registers.read(.cfg2) & 0x8000) == (0x8000)) ? 1 : 0)

  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
  public func registerCallback(_ CallbackID: UInt32, callback pCallback: I2SCallback?) -> HALStatus
  {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
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
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x8:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))

        status = .error
        break
      }
    } else if 0x0 == handle.read(.state) {
      switch CallbackID
      {
      case 0x7:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x8:
        callbacks.write(.mspDeinitialize, value: pCallback)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))

        status = .error
        break
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))

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
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x8:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))

        status = .error
        break
      }
    } else if 0x0 == handle.read(.state) {
      switch CallbackID
      {
      case 0x7:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x8:
        callbacks.write(.mspDeinitialize, value: defaults.mspDeinitialize)
        break
      default:
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))

        status = .error
        break
      }
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))

      status = .error
    }
    return status

  }
  public func enable() { modify(.cr1, set: 0x1) }
  public func disable() { modify(.cr1, clear: 0x1) }
  public func enableInterrupts(_ interrupts: UInt32) { modify(.ier, set: interrupts) }
  public func disableInterrupts(_ interrupts: UInt32) { modify(.ier, clear: interrupts) }
  public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.sr) & flag == flag ? 1 : 0 }
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
  public func clearOverrunFlag() { modify(.ifcr, set: 0x40) }
  public func clearUnderrunFlag() { modify(.ifcr, set: 0x20) }
  public func clearFrameErrorFlag() { modify(.ifcr, set: 0x100) }
}
