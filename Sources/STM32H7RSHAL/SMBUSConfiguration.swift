// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// SMBUS/SMBUSEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SMBUS {
  public func initialize() -> HALStatus {

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        callbacks.write(.masterTransmitComplete, value: defaults.masterTransmitComplete)
        callbacks.write(.masterReceiveComplete, value: defaults.masterReceiveComplete)
        callbacks.write(.slaveTransmitComplete, value: defaults.slaveTransmitComplete)
        callbacks.write(.slaveReceiveComplete, value: defaults.slaveReceiveComplete)
        callbacks.write(.listenComplete, value: defaults.listenComplete)
        callbacks.write(.error, value: defaults.error)
        callbacks.writeAddress(defaults.address)
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

    registers.write(.timingr, value: handle.read(.timing) & 0xf0ff_ffff)

    registers.write(.timeoutr, value: registers.read(.timeoutr) & (~0x8000))
    registers.write(.timeoutr, value: registers.read(.timeoutr) & (~0x8000_0000))
    registers.write(.timeoutr, value: handle.read(.smbusTimeout))

    registers.write(.oar1, value: registers.read(.oar1) & (~0x8000))
    if handle.read(.ownAddress1) != 0 {
      if handle.read(.addressingMode) == 0x1 {
        registers.write(.oar1, value: (0x8000 | handle.read(.ownAddress1)))
      }
    }

    registers.write(.cr2, value: registers.read(.cr2) | ((0x2000000 | 0x8000)))

    registers.write(
      .oar2,
      value: (handle.read(.dualAddressMode) | handle.read(.ownAddress2)
        | (handle.read(.ownAddress2Masks) << 8)))

    registers.write(
      .cr1,
      value: (handle.read(.generalCallMode) | handle.read(.noStretchMode)
        | handle.read(.packetErrorCheckMode) | handle.read(.peripheralMode)
        | handle.read(.analogFilter)))

    if (handle.read(.packetErrorCheckMode) == 0x800000)
      && ((handle.read(.peripheralMode) == 0x0) || (handle.read(.peripheralMode) == 0x200000))
    {
      registers.write(.cr1, value: registers.read(.cr1) | (0x10000))
    }

    enable()
    handle.write(.errorCode, value: 0x0)
    handle.write(.previousState, value: 0x1)
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
    handle.write(.previousState, value: 0x0)
    handle.write(.state, value: 0x0)

    unlock()
    return .ok

  }
  public func configureAnalogFilter(_ AnalogFilter: UInt32) -> HALStatus {

    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x2)

      disable()

      registers.write(.cr1, value: registers.read(.cr1) & (~(0x1000)))

      registers.write(.cr1, value: registers.read(.cr1) | (AnalogFilter))
      enable()
      handle.write(.state, value: 0x1)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func configureDigitalFilter(_ DigitalFilter: UInt32) -> HALStatus {

    var tmpreg: UInt32

    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x2)

      disable()

      tmpreg = registers.read(.cr1)

      tmpreg &= ~(0xf00)

      tmpreg |= DigitalFilter << 0x8

      registers.write(.cr1, value: tmpreg)
      enable()
      handle.write(.state, value: 0x1)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func registerCallback(_ CallbackID: UInt32, _ pCallback: SMBUSCallback?) -> HALStatus {
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
        callbacks.write(.masterTransmitComplete, value: pCallback)
        break
      case 0x1:
        callbacks.write(.masterReceiveComplete, value: pCallback)
        break
      case 0x2:
        callbacks.write(.slaveTransmitComplete, value: pCallback)
        break
      case 0x3:
        callbacks.write(.slaveReceiveComplete, value: pCallback)
        break
      case 0x4:
        callbacks.write(.listenComplete, value: pCallback)
        break
      case 0x5:
        callbacks.write(.error, value: pCallback)
        break
      case 0x6:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x7:
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
      case 0x6:
        callbacks.write(.mspInitialize, value: pCallback)
        break
      case 0x7:
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
        callbacks.write(.masterTransmitComplete, value: defaults.masterTransmitComplete)
        break
      case 0x1:
        callbacks.write(.masterReceiveComplete, value: defaults.masterReceiveComplete)
        break
      case 0x2:
        callbacks.write(.slaveTransmitComplete, value: defaults.slaveTransmitComplete)
        break
      case 0x3:
        callbacks.write(.slaveReceiveComplete, value: defaults.slaveReceiveComplete)
        break
      case 0x4:
        callbacks.write(.listenComplete, value: defaults.listenComplete)
        break
      case 0x5:
        callbacks.write(.error, value: defaults.error)
        break
      case 0x6:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x7:
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
      case 0x6:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x7:
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
  public func registerAddressCallback(_ pCallback: SMBUSAddressCallback?) -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
      return .error
    }
    if 0x1 == handle.read(.state) {
      callbacks.writeAddress(pCallback)
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))

      status = .error
    }
    return status

  }
  public func unregisterAddressCallback() -> HALStatus {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if 0x1 == handle.read(.state) {
      callbacks.writeAddress(defaults.address)
    } else {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))

      status = .error
    }
    return status

  }
  public func enableWakeUp() -> HALStatus {

    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x2)

      disable()

      registers.write(.cr1, value: registers.read(.cr1) | (0x40000))
      enable()
      handle.write(.state, value: 0x1)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func disableWakeUp() -> HALStatus {

    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x2)

      disable()

      registers.write(.cr1, value: registers.read(.cr1) & (~(0x40000)))
      enable()
      handle.write(.state, value: 0x1)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
  public func configureFastModePlus(_ FastModePlus: UInt32) -> HALStatus {

    if handle.read(.state) == 0x1 {
      guard lock() else { return .busy }
      handle.write(.state, value: 0x2)

      disable()
      if FastModePlus == 0x0 {
        registers.write(.cr1, value: registers.read(.cr1) | ((0x1000000)))
      } else {
        registers.write(.cr1, value: registers.read(.cr1) & (~(0x1000000)))
      }
      enable()
      handle.write(.state, value: 0x1)

      unlock()
      return .ok
    } else {
      return .busy
    }

  }
}
