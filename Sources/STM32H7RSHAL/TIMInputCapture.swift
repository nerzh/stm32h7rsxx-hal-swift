// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// TIM/TIMEx operations from STM32H7RS HAL
// at 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension TIM {
  public func inputCaptureInitialize() -> HALStatus {

    if handle.read(.state) == 0x0 {
      handle.write(.lock, value: 0x0)
      if useRegisteredCallbacks {
        resetCallback()
        if callbacks.read(.inputCaptureMspInitialize) == nil {
          callbacks.write(.inputCaptureMspInitialize, value: defaults.inputCaptureMspInitialize)
        }
        callbacks.read(.inputCaptureMspInitialize)!(callbacks.context)
      } else {
        defaults.inputCaptureMspInitialize(callbacks.context)
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
  public func inputCaptureDeinitialize() -> HALStatus {

    handle.write(.state, value: 0x2)

    disable()
    if useRegisteredCallbacks {
      if callbacks.read(.inputCaptureMspDeinitialize) == nil {
        callbacks.write(.inputCaptureMspDeinitialize, value: defaults.inputCaptureMspDeinitialize)
      }
      callbacks.read(.inputCaptureMspDeinitialize)!(callbacks.context)
    } else {
      defaults.inputCaptureMspDeinitialize(callbacks.context)
    }

    handle.write(.dmaBurstState, value: 0x0)

    channelSetAllStates(0x0)
    channelNSetAllStates(0x0)

    handle.write(.state, value: 0x0)

    unlock()
    return .ok

  }
  public func inputCaptureStart(_ Channel: UInt32) -> HALStatus {

    var tmpsmcr: UInt32
    var channel_state: UInt32 = channelState(Channel)
    var complementary_channel_state: UInt32 = channelNState(Channel)

    if (channel_state != 0x1)
      || (complementary_channel_state != 0x1)
    {
      return .error
    }

    channelSetState(Channel, 0x2)
    channelNSetState(Channel, 0x2)

    ccxChannelCmd(Channel, 0x1)

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
  public func inputCaptureStop(_ Channel: UInt32) -> HALStatus {

    ccxChannelCmd(Channel, 0x0)

    disable()

    channelSetState(Channel, 0x1)
    channelNSetState(Channel, 0x1)

    return .ok

  }
  public func inputCaptureStartInterrupt(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok
    var tmpsmcr: UInt32
    var channel_state: UInt32 = channelState(Channel)
    var complementary_channel_state: UInt32 = channelNState(Channel)

    if (channel_state != 0x1)
      || (complementary_channel_state != 0x1)
    {
      return .error
    }

    channelSetState(Channel, 0x2)
    channelNSetState(Channel, 0x2)
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
  public func inputCaptureStopInterrupt(_ Channel: UInt32) -> HALStatus {

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

      disable()

      channelSetState(Channel, 0x1)
      channelNSetState(Channel, 0x1)
    }

    return status

  }
  public func inputCaptureStartDMA(
    _ Channel: UInt32, _ pData: UnsafeMutablePointer<UInt32>?, _ Length: UInt16
  ) -> HALStatus {
    let Length = UInt32(Length)

    var status: HALStatus = .ok
    var tmpsmcr: UInt32
    var channel_state: UInt32 = channelState(Channel)
    var complementary_channel_state: UInt32 = channelNState(Channel)

    if (channel_state == 0x2)
      || (complementary_channel_state == 0x2)
    {
      return .busy
    } else if (channel_state == 0x1)
      && (complementary_channel_state == 0x1)
    {
      if (pData == nil) || (Length == 0) {
        return .error
      } else {
        channelSetState(Channel, 0x2)
        channelNSetState(Channel, 0x2)
      }
    } else {
      return .error
    }

    ccxChannelCmd(Channel, 0x1)
    switch Channel
    {
    case 0x0:
      do {
        dma.writeCallback(
          .captureCompare1, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare1, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare1, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare1, registers.address(of: .ccr1),
          UInt32(truncatingIfNeeded: UInt(bitPattern: pData)), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x200)
        break
      }
    case 0x4:
      do {
        dma.writeCallback(
          .captureCompare2, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare2, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare2, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare2, registers.address(of: .ccr2),
          UInt32(truncatingIfNeeded: UInt(bitPattern: pData)), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x400)
        break
      }
    case 0x8:
      do {
        dma.writeCallback(
          .captureCompare3, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare3, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare3, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare3, registers.address(of: .ccr3),
          UInt32(truncatingIfNeeded: UInt(bitPattern: pData)), Length) != .ok
        {
          return .error
        }
        enableDMARequests(0x800)
        break
      }
    case 0xc:
      do {
        dma.writeCallback(
          .captureCompare4, id: .transferComplete, value: dma.callback(.captureComplete))
        dma.writeCallback(
          .captureCompare4, id: .halfTransfer, value: dma.callback(.captureHalfComplete))

        dma.writeCallback(.captureCompare4, id: .error, value: dma.callback(.error))

        if dmaStartInterrupt(
          .captureCompare4, registers.address(of: .ccr4),
          UInt32(truncatingIfNeeded: UInt(bitPattern: pData)), Length) != .ok
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

    return status

  }
  public func inputCaptureStopDMA(_ Channel: UInt32) -> HALStatus {

    var status: HALStatus = .ok

    ccxChannelCmd(Channel, 0x0)
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
      disable()

      channelSetState(Channel, 0x1)
      channelNSetState(Channel, 0x1)
    }

    return status

  }
}
