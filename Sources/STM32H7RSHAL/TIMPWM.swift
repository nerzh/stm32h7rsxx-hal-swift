// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func pwmInitialize() -> HALStatus {

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        resetCallback()
        if callbacks.read(.pWMMspInitialize) == nil {
          callbacks.write(.pWMMspInitialize, value: defaults.pWMMspInitialize)
        }
        callbacks.read(.pWMMspInitialize)!(callbacks.context)
      } else {
        defaults.pWMMspInitialize(callbacks.context)
      }
    }

    handle.write(.state, value: 0x2)

    baseSetConfig(handle.configuration())

    handle.write(.dmaBurstState, value: 0x1)

    channelSetAllStates(0x1)
    channelNSetAllStates(0x1)

    handle.write(.state, value: 0x1)
    return .ok

  }
  public func pwmDeinitialize() -> HALStatus {

    handle.write(.state, value: 0x2)

    disable()
    if useRegisteredCallbacks {
      if callbacks.read(.pWMMspDeinitialize) == nil {
        callbacks.write(.pWMMspDeinitialize, value: defaults.pWMMspDeinitialize)
      }
      callbacks.read(.pWMMspDeinitialize)!(callbacks.context)
    } else {
      defaults.pWMMspDeinitialize(callbacks.context)
    }

    handle.write(.dmaBurstState, value: 0x0)

    channelSetAllStates(0x0)
    channelNSetAllStates(0x0)

    handle.write(.state, value: 0x0)

    unlock()
    return .ok

  }
  public func pwmStart(_ Channel: UInt32) -> HALStatus {

    var tmpsmcr: UInt32

    if channelState(Channel) != 0x1 {
      return .error
    }

    channelSetState(Channel, 0x2)

    ccxChannelCmd(Channel, 0x1)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      enableMainOutput()
    }

    if ((((registers.instance)) == TIMInstance.tim1) || (((registers.instance)) == TIMInstance.tim2)
      || (((registers.instance)) == TIMInstance.tim3)
      || (((registers.instance)) == TIMInstance.tim4)
      || (((registers.instance)) == TIMInstance.tim5)
      || (((registers.instance)) == TIMInstance.tim9)
      || (((registers.instance)) == TIMInstance.tim12)
      || (((registers.instance)) == TIMInstance.tim15))
    {
      tmpsmcr = registers.read(.smcr) & 0x10007
      if !(((tmpsmcr) == 0x6) || ((tmpsmcr) == 0x10000)) {
        enable()
      }
    } else {
      enable()
    }

    return .ok

  }
  public func pwmStop(_ Channel: UInt32) -> HALStatus {

    ccxChannelCmd(Channel, 0x0)
    if ((((registers.instance)) == TIMInstance.tim1)
      || (((registers.instance)) == TIMInstance.tim15)
      || (((registers.instance)) == TIMInstance.tim16)
      || (((registers.instance)) == TIMInstance.tim17))
    {
      disableMainOutput()
    }

    disable()

    channelSetState(Channel, 0x1)

    return .ok

  }
  public func pwmStartInterrupt(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var tmpsmcr: UInt32

    if channelState(Channel) != 0x1 {
      return .error
    }

    channelSetState(Channel, 0x2)
    switch Channel
    {
    case 0x0:
      do {
        enableInterrupts(0x2)
        break
      }
    case 0x4:
      do {
        enableInterrupts(0x4)
        break
      }
    case 0x8:
      do {
        enableInterrupts(0x8)
        break
      }
    case 0xc:
      do {
        enableInterrupts(0x10)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxChannelCmd(Channel, 0x1)
      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim15)
        || (((registers.instance)) == TIMInstance.tim16)
        || (((registers.instance)) == TIMInstance.tim17))
      {
        enableMainOutput()
      }

      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim2)
        || (((registers.instance)) == TIMInstance.tim3)
        || (((registers.instance)) == TIMInstance.tim4)
        || (((registers.instance)) == TIMInstance.tim5)
        || (((registers.instance)) == TIMInstance.tim9)
        || (((registers.instance)) == TIMInstance.tim12)
        || (((registers.instance)) == TIMInstance.tim15))
      {
        tmpsmcr = registers.read(.smcr) & 0x10007
        if !(((tmpsmcr) == 0x6) || ((tmpsmcr) == 0x10000)) {
          enable()
        }
      } else {
        enable()
      }
    }

    return status

  }
  public func pwmStopInterrupt(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    switch Channel
    {
    case 0x0:
      do {
        disableInterrupts(0x2)
        break
      }
    case 0x4:
      do {
        disableInterrupts(0x4)
        break
      }
    case 0x8:
      do {
        disableInterrupts(0x8)
        break
      }
    case 0xc:
      do {
        disableInterrupts(0x10)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxChannelCmd(Channel, 0x0)
      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim15)
        || (((registers.instance)) == TIMInstance.tim16)
        || (((registers.instance)) == TIMInstance.tim17))
      {
        disableMainOutput()
      }

      disable()

      channelSetState(Channel, 0x1)
    }

    return status

  }
  public func pwmStartDMA(_ Channel: UInt32, _ pData: UnsafePointer<UInt32>?, _ Length: UInt16)
    -> HALStatus
  {
    let Length = UInt32(Length)

    var status: HALStatus = .ok
    var tmpsmcr: UInt32

    if channelState(Channel) == 0x2 {
      return .busy
    } else if channelState(Channel) == 0x1 {
      if (pData == nil) || (Length == 0) {
        return .error
      } else {
        channelSetState(Channel, 0x2)
      }
    } else {
      return .error
    }
    switch Channel
    {
    case 0x0:
      do {
        dma.writeCallback(
          .captureCompare1, id: .transferComplete, value: dma.callback(.delayPulseComplete))
        dma.writeCallback(
          .captureCompare1, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare1, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr1), Length) != .ok
        {
          return .error
        }

        enableDMARequests(0x200)
        break
      }
    case 0x4:
      do {
        dma.writeCallback(
          .captureCompare2, id: .transferComplete, value: dma.callback(.delayPulseComplete))
        dma.writeCallback(
          .captureCompare2, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare2, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare2, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr2), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x400)
        break
      }
    case 0x8:
      do {
        dma.writeCallback(
          .captureCompare3, id: .transferComplete, value: dma.callback(.delayPulseComplete))
        dma.writeCallback(
          .captureCompare3, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare3, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare3, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr3), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x800)
        break
      }
    case 0xc:
      do {
        dma.writeCallback(
          .captureCompare4, id: .transferComplete, value: dma.callback(.delayPulseComplete))
        dma.writeCallback(
          .captureCompare4, id: .halfTransfer, value: dma.callback(.delayPulseHalfComplete))

        dma.writeCallback(.captureCompare4, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare4, UInt32(truncatingIfNeeded: UInt(bitPattern: pData)),
          registers.address(of: .ccr4), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x1000)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxChannelCmd(Channel, 0x1)
      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim15)
        || (((registers.instance)) == TIMInstance.tim16)
        || (((registers.instance)) == TIMInstance.tim17))
      {
        enableMainOutput()
      }

      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim2)
        || (((registers.instance)) == TIMInstance.tim3)
        || (((registers.instance)) == TIMInstance.tim4)
        || (((registers.instance)) == TIMInstance.tim5)
        || (((registers.instance)) == TIMInstance.tim9)
        || (((registers.instance)) == TIMInstance.tim12)
        || (((registers.instance)) == TIMInstance.tim15))
      {
        tmpsmcr = registers.read(.smcr) & 0x10007
        if !(((tmpsmcr) == 0x6) || ((tmpsmcr) == 0x10000)) {
          enable()
        }
      } else {
        enable()
      }
    }

    return status

  }
  public func pwmStopDMA(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    switch Channel
    {
    case 0x0:
      do {
        disableDMARequests(0x200)
        _ = dma.abortInterrupt(.captureCompare1)
        break
      }
    case 0x4:
      do {
        disableDMARequests(0x400)
        _ = dma.abortInterrupt(.captureCompare2)
        break
      }
    case 0x8:
      do {
        disableDMARequests(0x800)
        _ = dma.abortInterrupt(.captureCompare3)
        break
      }
    case 0xc:
      do {
        disableDMARequests(0x1000)
        _ = dma.abortInterrupt(.captureCompare4)
        break
      }
    default:
      status = .error
      break
    }
    if status == .ok {
      ccxChannelCmd(Channel, 0x0)
      if ((((registers.instance)) == TIMInstance.tim1)
        || (((registers.instance)) == TIMInstance.tim15)
        || (((registers.instance)) == TIMInstance.tim16)
        || (((registers.instance)) == TIMInstance.tim17))
      {
        disableMainOutput()
      }

      disable()

      channelSetState(Channel, 0x1)
    }

    return status

  }
}
