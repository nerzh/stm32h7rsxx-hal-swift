// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// I2S and SAI/SAIEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension SAI {
  public func initialize(
    getPeripheralClockFrequency: (UInt32) -> UInt32, systemCoreClock: () -> UInt32
  ) -> HALStatus {

    var tmpregisterGCR: UInt32
    var ckstr_bits: UInt32
    var syncen_bits: UInt32

    if handle.read(.pdmActivation) == 1 {

      if (registers.instance != .sai1A) || (handle.read(.audioMode) != 0x1)
        || (handle.read(.protocolMode) != 0x0)
      {
        return .error
      }
    }
    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0)
      if useRegisteredCallbacks {
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        callbacks.write(.receiveHalfComplete, value: defaults.receiveHalfComplete)
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        callbacks.write(.transmitHalfComplete, value: defaults.transmitHalfComplete)
        callbacks.write(.error, value: defaults.error)

        if callbacks.read(.mspInitialize) == nil {
          callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        }
        callbacks.read(.mspInitialize)!(callbacks.context)
      } else {
        defaults.mspInitialize(callbacks.context)
      }
    }

    if disableBlock(systemCoreClock: systemCoreClock) != .ok {
      return .error
    }
    handle.write(.state, value: 0x2)

    switch handle.read(.externalSynchronization)
    {
    case 0x0:
      tmpregisterGCR = 0
      break
    case 0x1:
      tmpregisterGCR = 0x10
      break
    case 0x2:
      tmpregisterGCR = 0x20
      break
    default:
      tmpregisterGCR = 0
      break
    }
    switch handle.read(.synchronization)
    {
    case 0x0:
      syncen_bits = 0
      break
    case 0x1:
      syncen_bits = 0x400
      break
    case 0x2:
      syncen_bits = 0x800
      break
    case 0x3:
      syncen_bits = 0x800
      tmpregisterGCR |= 0x1
      break
    default:
      syncen_bits = 0
      break
    }
    if (registers.instance == .sai1A) || (registers.instance == .sai1B) {
      registers.writeGlobal(.sai1, .gcr, value: tmpregisterGCR)
    } else {
      registers.writeGlobal(.sai2, .gcr, value: tmpregisterGCR)
    }
    if handle.read(.audioFrequency) != 0x0 {
      var freq: UInt32 = 0
      var tmpval: UInt32

      if (registers.instance == .sai1A) || (registers.instance == .sai1B) {
        freq = getPeripheralClockFrequency(0x80000)
      }
      if (registers.instance == .sai2A) || (registers.instance == .sai2B) {
        freq = getPeripheralClockFrequency(0x100000)
      }

      if handle.read(.noDivider) == 0x80000 {
        var tmpframelength: UInt32
        if handle.read(.protocolMode) == 0x4 {
          tmpframelength = 0x40
        } else if handle.read(.protocolMode) == 0x8 {
          tmpframelength = 0x100
        } else {
          tmpframelength = handle.read(.frameLength)
        }

        tmpval = (freq &* 10) / (handle.read(.audioFrequency) &* tmpframelength)
      } else {
        var tmposr: UInt32
        tmposr = (handle.read(.masterClockOversampling) == 0x4000000) ? 2 : 1
        tmpval = (freq &* 10) / (handle.read(.audioFrequency) &* tmposr &* 256)
      }
      handle.write(.masterClockDivider, value: tmpval / 10)

      if (tmpval % 10) > 8 {
        handle.write(.masterClockDivider, value: handle.read(.masterClockDivider) &+ (1))
      }

      if handle.read(.protocolMode) == 0x4 {
        handle.write(.masterClockDivider, value: handle.read(.masterClockDivider) >> 1)
      }
    }

    if (handle.read(.audioMode) == 0x0) || (handle.read(.audioMode) == 0x2) {
      ckstr_bits = (handle.read(.clockStrobing) == 0x1) ? 0 : 0x200
    } else {
      ckstr_bits = (handle.read(.clockStrobing) == 0x1) ? 0x200 : 0
    }

    registers.write(
      .cr1,
      value: registers.read(.cr1)
        & (~(0x3 | 0xc | 0xe0 | 0x100 | 0x200 | 0xc00 | 0x1000 | 0x2000 | 0x20000 | 0x80000
          | 0x3f00000 | 0x4000000 | 0x8000000)))
    registers.write(
      .cr1,
      value: registers.read(.cr1)
        | ((handle.read(.audioMode) | handle.read(.protocolMode) | handle.read(.dataSize)
          | handle.read(.firstBit) | ckstr_bits | syncen_bits | handle.read(.monoStereoMode)
          | handle.read(.outputDrive) | handle.read(.noDivider)
          | (handle.read(.masterClockDivider) << 20) | handle.read(.masterClockOversampling)
          | handle.read(.masterClockOutput))))

    registers.write(.cr2, value: registers.read(.cr2) & (~(0x7 | 0x8 | 0xc000 | 0x2000)))
    registers.write(
      .cr2,
      value: registers.read(.cr2)
        | ((handle.read(.fifoThreshold) | handle.read(.compandingMode) | handle.read(.triState))))

    registers.write(
      .frcr, value: registers.read(.frcr) & ((~(0xff | 0x7f00 | 0x10000 | 0x20000 | 0x40000))))
    registers.write(
      .frcr,
      value: registers.read(.frcr)
        | (((handle.read(.frameLength) &- 1) | handle.read(.frameSyncOffset)
          | handle.read(.frameSyncDefinition) | handle.read(.frameSyncPolarity)
          | ((handle.read(.activeFrameLength) &- 1) << 8))))

    registers.write(
      .slotr, value: registers.read(.slotr) & ((~(0x1f | 0xc0 | 0xf00 | 0xffff_0000))))
    registers.write(
      .slotr,
      value: registers.read(.slotr)
        | (handle.read(.firstBitOffset) | handle.read(.slotSize) | (handle.read(.activeSlots) << 16)
          | ((handle.read(.slotCount) &- 1) << 8)))

    if registers.instance == .sai1A {
      registers.writeGlobal(.sai1, .pdmcr, value: registers.readGlobal(.sai1, .pdmcr) & (~(0x1)))
      if handle.read(.pdmActivation) == 1 {
        registers.writeGlobal(
          .sai1, .pdmcr,
          value: (handle.read(.pdmClockEnable) | ((handle.read(.pdmMicrophonePairs) &- 1) << 0x4)))
        registers.writeGlobal(.sai1, .pdmcr, value: registers.readGlobal(.sai1, .pdmcr) | (0x1))
      }
    }

    handle.write(.errorCode, value: 0x0)

    handle.write(.state, value: 0x1)

    unlock()
    return .ok

  }
  public func deinitialize(systemCoreClock: () -> UInt32) -> HALStatus {

    handle.write(.state, value: 0x2)

    registers.write(.imr, value: 0)
    registers.write(.clrfr, value: 0xFFFF_FFFF)

    if disableBlock(systemCoreClock: systemCoreClock) != .ok {
      handle.write(.state, value: 0x1)

      unlock()
      return .error
    }

    registers.write(.cr2, value: registers.read(.cr2) | (0x8))

    if registers.instance == .sai1A {
      registers.writeGlobal(.sai1, .pdmdly, value: 0)

      registers.writeGlobal(.sai1, .pdmcr, value: registers.readGlobal(.sai1, .pdmcr) & (~(0x1)))
    }

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
  func disableBlock(systemCoreClock: () -> UInt32) -> HALStatus {

    var count: UInt32 = 0x4 &* (systemCoreClock() / 7 / 1000)
    var status: HALStatus = .ok

    disable()
    repeat {
      if count == 0 {
        handle.write(.errorCode, value: handle.read(.errorCode) | (0x40))
        status = .timeout
        break
      }
      count &-= 1
    } while (registers.read(.cr1) & 0x10000) != 0
    return status

  }
  public func getState() -> UInt32 {

    return handle.read(.state)

  }
  public func getError() -> UInt32 {

    return handle.read(.errorCode)

  }
  public func registerCallback(_ CallbackID: UInt32, callback pCallback: SAICallback?) -> HALStatus
  {
    guard useRegisteredCallbacks else { return .error }

    var status: HALStatus = .ok
    if pCallback == nil {
      handle.write(.errorCode, value: handle.read(.errorCode) | (0x100))
      status = .error
    } else {
      if 0x1 == handle.read(.state) {
        switch CallbackID
        {
        case 0x0:
          callbacks.write(.receiveComplete, value: pCallback)
          break
        case 0x1:
          callbacks.write(.receiveHalfComplete, value: pCallback)
          break
        case 0x2:
          callbacks.write(.transmitComplete, value: pCallback)
          break
        case 0x3:
          callbacks.write(.transmitHalfComplete, value: pCallback)
          break
        case 0x4:
          callbacks.write(.error, value: pCallback)
          break
        case 0x5:
          callbacks.write(.mspInitialize, value: pCallback)
          break
        case 0x6:
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
        case 0x5:
          callbacks.write(.mspInitialize, value: pCallback)
          break
        case 0x6:
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
        callbacks.write(.receiveComplete, value: defaults.receiveComplete)
        break
      case 0x1:
        callbacks.write(.receiveHalfComplete, value: defaults.receiveHalfComplete)
        break
      case 0x2:
        callbacks.write(.transmitComplete, value: defaults.transmitComplete)
        break
      case 0x3:
        callbacks.write(.transmitHalfComplete, value: defaults.transmitHalfComplete)
        break
      case 0x4:
        callbacks.write(.error, value: defaults.error)
        break
      case 0x5:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x6:
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
      case 0x5:
        callbacks.write(.mspInitialize, value: defaults.mspInitialize)
        break
      case 0x6:
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
  public func initializeProtocol(
    _ protocolValue: UInt32, dataSize datasize: UInt32, slotCount nbslot: UInt32,
    getPeripheralClockFrequency: (UInt32) -> UInt32, systemCoreClock: () -> UInt32
  ) -> HALStatus {

    var status: HALStatus

    switch protocolValue
    {
    case 0x0, 0x1, 0x2:
      status = configureI2SProtocol(protocolValue, datasize, nbslot)
      break
    case 0x3, 0x4:
      status = configurePCMProtocol(protocolValue, datasize, nbslot)
      break
    default:
      status = .error
      break
    }
    if status == .ok {
      status = initialize(
        getPeripheralClockFrequency: getPeripheralClockFrequency, systemCoreClock: systemCoreClock)
    }
    return status

  }
  func configureI2SProtocol(_ protocolValue: UInt32, _ datasize: UInt32, _ nbslot: UInt32)
    -> HALStatus
  {

    var status: HALStatus = .ok
    handle.write(.protocolMode, value: 0x0)
    handle.write(.firstBit, value: 0x0)
    if (handle.read(.audioMode) == 0x0) || (handle.read(.audioMode) == 0x2) {
      handle.write(.clockStrobing, value: 0x0)
    } else {
      handle.write(.clockStrobing, value: 0x1)
    }
    handle.write(.frameSyncDefinition, value: 0x10000)
    handle.write(.activeSlots, value: 0xffff)
    handle.write(.firstBitOffset, value: 0)
    handle.write(.slotCount, value: nbslot)

    if (nbslot & 0x1) != 0 {
      return .error
    }
    if protocolValue == 0x0 {
      handle.write(.frameSyncPolarity, value: 0x0)
      handle.write(.frameSyncOffset, value: 0x40000)
    } else {
      handle.write(.frameSyncPolarity, value: 0x20000)
      handle.write(.frameSyncOffset, value: 0x0)
    }

    switch datasize
    {
    case 0x0:
      handle.write(.dataSize, value: 0x80)
      handle.write(.frameLength, value: 32 &* (nbslot / 2))
      handle.write(.activeFrameLength, value: 16 &* (nbslot / 2))
      handle.write(.slotSize, value: 0x40)
      break
    case 0x1:
      handle.write(.dataSize, value: 0x80)
      handle.write(.frameLength, value: 64 &* (nbslot / 2))
      handle.write(.activeFrameLength, value: 32 &* (nbslot / 2))
      handle.write(.slotSize, value: 0x80)
      break
    case 0x2:
      handle.write(.dataSize, value: 0xc0)
      handle.write(.frameLength, value: 64 &* (nbslot / 2))
      handle.write(.activeFrameLength, value: 32 &* (nbslot / 2))
      handle.write(.slotSize, value: 0x80)
      break
    case 0x3:
      handle.write(.dataSize, value: 0xe0)
      handle.write(.frameLength, value: 64 &* (nbslot / 2))
      handle.write(.activeFrameLength, value: 32 &* (nbslot / 2))
      handle.write(.slotSize, value: 0x80)
      break
    default:
      status = .error
      break
    }
    if protocolValue == 0x2 {
      if datasize == 0x1 {
        handle.write(.firstBitOffset, value: 16)
      }
      if datasize == 0x2 {
        handle.write(.firstBitOffset, value: 8)
      }
    }
    return status

  }
  func configurePCMProtocol(_ protocolValue: UInt32, _ datasize: UInt32, _ nbslot: UInt32)
    -> HALStatus
  {

    var status: HALStatus = .ok
    handle.write(.protocolMode, value: 0x0)
    handle.write(.firstBit, value: 0x0)
    if (handle.read(.audioMode) == 0x0) || (handle.read(.audioMode) == 0x2) {
      handle.write(.clockStrobing, value: 0x1)
    } else {
      handle.write(.clockStrobing, value: 0x0)
    }
    handle.write(.frameSyncDefinition, value: 0x0)
    handle.write(.frameSyncPolarity, value: 0x20000)
    handle.write(.frameSyncOffset, value: 0x40000)
    handle.write(.firstBitOffset, value: 0)
    handle.write(.slotCount, value: nbslot)
    handle.write(.activeSlots, value: 0xffff)
    if protocolValue == 0x4 {
      handle.write(.activeFrameLength, value: 1)
    } else {
      handle.write(.activeFrameLength, value: 13)
    }
    switch datasize
    {
    case 0x0:
      handle.write(.dataSize, value: 0x80)
      handle.write(.frameLength, value: 16 &* nbslot)
      handle.write(.slotSize, value: 0x40)
      break
    case 0x1:
      handle.write(.dataSize, value: 0x80)
      handle.write(.frameLength, value: 32 &* nbslot)
      handle.write(.slotSize, value: 0x80)
      break
    case 0x2:
      handle.write(.dataSize, value: 0xc0)
      handle.write(.frameLength, value: 32 &* nbslot)
      handle.write(.slotSize, value: 0x80)
      break
    case 0x3:
      handle.write(.dataSize, value: 0xe0)
      handle.write(.frameLength, value: 32 &* nbslot)
      handle.write(.slotSize, value: 0x80)
      break
    default:
      status = .error
      break
    }
    return status

  }
  public func configurePDMMicrophoneDelay(_ configuration: SAIPDMMicrophoneDelay) -> HALStatus {

    var status: HALStatus = .ok
    var offset: UInt32

    if registers.instance != .sai1A {
      status = .error
    } else {

      offset = 0x8 &* (configuration.microphonePair &- 1)

      if (handle.read(.state) != 0x0) && (offset <= 24) {
        registers.writeGlobal(
          .sai1, .pdmdly, value: registers.readGlobal(.sai1, .pdmdly) & (~(0x77 << offset)))

        registers.writeGlobal(
          .sai1, .pdmdly,
          value: registers.readGlobal(.sai1, .pdmdly)
            | ((((configuration.rightDelay << 0x4) | configuration.leftDelay) << offset)))
      } else {
        status = .error
      }
    }
    return status

  }
  public func enable() { modify(.cr1, set: 0x10000) }
  public func disable() { modify(.cr1, clear: 0x10000) }
  public func enableInterrupts(_ interrupts: UInt32) { modify(.imr, set: interrupts) }
  public func disableInterrupts(_ interrupts: UInt32) { modify(.imr, clear: interrupts) }
  public func getFlag(_ flag: UInt32) -> UInt32 { registers.read(.sr) & flag == flag ? 1 : 0 }
  public func getInterruptSource(_ interrupts: UInt32) -> UInt32 {
    registers.read(.imr) & interrupts == interrupts ? 1 : 0
  }
  public func resetHandleState() {
    handle.write(.state, value: 0)
    if useRegisteredCallbacks {
      callbacks.write(.mspInitialize, value: nil)
      callbacks.write(.mspDeinitialize, value: nil)
    }
  }
  public func clearFlag(_ flag: UInt32) { registers.write(.clrfr, value: flag) }
}
